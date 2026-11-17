import http from 'node:http';
import { readFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { randomUUID } from 'node:crypto';
import { createStore } from './lib/store.js';
import {
  fail,
  str,
  date,
  profileInput,
  recordInput,
  analytics,
  answer,
  reportHTML,
  reportCSV
} from './lib/core.js';

const root = dirname(fileURLToPath(import.meta.url));

async function body(req) {
  if (!req.headers['content-type']?.startsWith('application/json')) {
    fail('Send application/json.', 415);
  }

  let raw = '';

  for await (const chunk of req) {
    raw += chunk;

    if (Buffer.byteLength(raw) > 100000) {
      fail('Request too large.', 413);
    }
  }

  try {
    const value = JSON.parse(raw);

    if (!value || typeof value !== 'object' || Array.isArray(value)) {
      fail('Expected an object.');
    }

    return value;
  } catch {
    fail('Invalid JSON object.');
  }
}

export function createApp({
  directory = join(root, 'data'),
  config = {},
  fetcher = fetch
} = {}) {
  const store = createStore(directory);
  const pending = new Set();
  let lastChat = 0;

  const mode = config.mode === 'live' ? 'live' : 'demo';

  const server = http.createServer(async (req, res) => {
    const send = (
      status,
      value,
      type = 'application/json; charset=utf-8'
    ) => {
      res.writeHead(status, { 'Content-Type': type });

      res.end(
        type.startsWith('application/json')
          ? JSON.stringify(value)
          : value
      );
    };

    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('Referrer-Policy', 'no-referrer');
    res.setHeader('Cache-Control', 'no-store');

    res.setHeader(
      'Content-Security-Policy',
      "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self'; frame-ancestors 'none'; base-uri 'none'; form-action 'self'"
    );

    try {
      const expectedHosts = [
        `127.0.0.1:${server.address()?.port}`,
        `localhost:${server.address()?.port}`
      ];

      if (!expectedHosts.includes(req.headers.host)) {
        fail('Local access only.', 403);
      }

      if (
        req.headers.origin &&
        req.headers.origin !== `http://${req.headers.host}`
      ) {
        fail('Cross-origin request rejected.', 403);
      }

      if (req.headers['sec-fetch-site'] === 'cross-site') {
        fail('Cross-site request rejected.', 403);
      }

      const url = new URL(req.url, `http://${req.headers.host}`);
      const path = url.pathname;
      const method = req.method;

      if (
        method === 'GET' &&
        ['/', '/app.js', '/styles.css'].includes(path)
      ) {
        const file = path === '/' ? 'index.html' : path.slice(1);

        return send(
          200,
          readFileSync(join(root, 'public', file)),
          file.endsWith('.js')
            ? 'text/javascript; charset=utf-8'
            : file.endsWith('.css')
              ? 'text/css; charset=utf-8'
              : 'text/html; charset=utf-8'
        );
      }

      if (method === 'GET' && path === '/api/state') {
        const s = store.read();

        return send(200, {
          ...s,
          analytics: analytics(s.records),
          mode
        });
      }

      if (method === 'PUT' && path === '/api/profile') {
        const p = profileInput(await body(req));

        store.update(s => {
          s.profile = p;
        });

        return send(200, p);
      }

      if (method === 'POST' && path === '/api/records') {
        const r = recordInput(await body(req));

        store.update(s => {
          if (s.records.length >= 10000) {
            fail('Local record limit reached.');
          }

          s.records.push(r);
        });

        return send(201, r);
      }

      if (method === 'DELETE' && path.startsWith('/api/records/')) {
        const id = path.split('/')[3];

        store.update(s => {
          if (!s.records.some(x => x.id === id)) {
            fail('Record not found.', 404);
          }

          s.records = s.records.filter(x => x.id !== id);
        });

        return send(200, { ok: true });
      }

      if (method === 'POST' && path === '/api/reminders') {
        const b = await body(req);

        const r = {
          id: randomUUID(),
          title: str(b.title, 'Title', 200),
          dueDate: date(b.dueDate),
          done: false
        };

        store.update(s => {
          if (s.reminders.length >= 1000) {
            fail('Reminder limit reached.');
          }

          s.reminders.push(r);
        });

        return send(201, r);
      }

      if (method === 'PATCH' && path.startsWith('/api/reminders/')) {
        const b = await body(req);

        if (typeof b.done !== 'boolean') {
          fail('done must be boolean.');
        }

        store.update(s => {
          const r = s.reminders.find(
            x => x.id === path.split('/')[3]
          );

          if (!r) {
            fail('Reminder not found.', 404);
          }

          r.done = b.done;
        });

        return send(200, { ok: true });
      }

      if (method === 'POST' && path === '/api/chat') {
        const b = await body(req);
        const question = str(b.message, 'Message', 3000);
        const s = store.read();

        const id = b.conversationId
          ? str(b.conversationId, 'Conversation ID', 80)
          : randomUUID();

        const convo = s.conversations.find(c => c.id === id);

        if (b.conversationId && !convo) {
          fail('Conversation not found.', 404);
        }

        if (convo?.messages.length >= 200) {
          fail('Start a new conversation.');
        }

        if (!convo && s.conversations.length >= 200) {
          fail('Delete an old conversation first.');
        }

        if (pending.has(id)) {
          fail('A response is already in progress.', 409);
        }

        if (
          mode === 'live' &&
          (pending.size || Date.now() - lastChat < 2000)
        ) {
          fail('Please wait before another AI request.', 429);
        }

        pending.add(id);
        lastChat = Date.now();

        try {
          const result = await answer(
            question,
            s,
            convo?.messages || [],
            { ...config, mode },
            fetcher
          );

          store.update(next => {
            let c = next.conversations.find(x => x.id === id);

            if (convo && !c) {
              fail('Conversation was deleted while responding.', 409);
            }

            if (!c) {
              c = {
                id,
                title: question.slice(0, 60),
                createdAt: new Date().toISOString(),
                messages: []
              };

              next.conversations.push(c);
            }

            c.messages.push(
              { role: 'user', text: question },
              {
                role: 'assistant',
                ...result,
                createdAt: new Date().toISOString()
              }
            );
          });

          return send(200, {
            conversationId: id,
            ...result
          });
        } finally {
          pending.delete(id);
        }
      }

      if (
        method === 'DELETE' &&
        path.startsWith('/api/conversations/')
      ) {
        store.update(s => {
          const id = path.split('/')[3];

          if (!s.conversations.some(c => c.id === id)) {
            fail('Conversation not found.', 404);
          }

          s.conversations = s.conversations.filter(
            c => c.id !== id
          );
        });

        return send(200, { ok: true });
      }

      if (method === 'POST' && path === '/api/reports') {
        const b = await body(req);
        const from = date(b.from);
        const to = date(b.to);

        if (from > to) {
          fail('Start date must precede end date.');
        }

        const s = store.read();

        const records = s.records.filter(
          r => r.date >= from && r.date <= to
        );

        const a = analytics(records);

        const r = {
          id: randomUUID(),
          from,
          to,
          createdAt: new Date().toISOString(),
          profile: s.profile,
          records,
          analytics: a,
          summary: records.length
            ? `${a.count} records in this period. Recorded cash balance is INR ${a.balance.toFixed(2)}. This excludes unrecorded transactions and is not audited profit. Review missing costs and revenue before making decisions.`
            : 'No records exist in this period. Zero totals mean no recorded activity, not necessarily no farm activity.'
        };

        store.update(s => {
          if (s.reports.length >= 200) {
            fail('Delete an old report first.');
          }

          s.reports.push(r);
        });

        return send(201, r);
      }

      if (path.startsWith('/api/reports/')) {
        const [, , , id, format] = path.split('/');

        const r = store
          .read()
          .reports.find(x => x.id === id);

        if (!r) {
          fail('Report not found.', 404);
        }

        if (method === 'DELETE' && !format) {
          store.update(s => {
            s.reports = s.reports.filter(x => x.id !== id);
          });

          return send(200, { ok: true });
        }

        if (
          method === 'GET' &&
          ['html', 'csv'].includes(format)
        ) {
          if (
            format === 'csv' ||
            url.searchParams.has('download')
          ) {
            res.setHeader(
              'Content-Disposition',
              `attachment; filename="agrisphere-report-${id}.${format}"`
            );
          }

          return send(
            200,
            format === 'csv' ? reportCSV(r) : reportHTML(r),
            format === 'csv'
              ? 'text/csv; charset=utf-8'
              : 'text/html; charset=utf-8'
          );
        }
      }

      fail('Not found.', 404);
    } catch (error) {
      send(error.status || 500, {
        error: error.status
          ? error.message
          : 'An internal error occurred. Check local data permissions and restart.'
      });
    }
  });

  return server;
}

if (
  process.argv[1] &&
  import.meta.url === pathToFileURL(resolve(process.argv[1])).href
) {
  const port = Number(process.env.PORT || 3000);

  const config = {
    mode: process.env.AI_MODE,
    endpoint: process.env.LLM_ENDPOINT,
    key: process.env.LLM_API_KEY,
    model: process.env.LLM_MODEL
  };

  // Allows HTTPS providers and only local Ollama HTTP endpoint.
  if (config.mode === 'live') {
    const u = new URL(
      config.endpoint ||
      'https://api.openai.com/v1/chat/completions'
    );

    const isLocalOllama =
      u.protocol === 'http:' &&
      ['127.0.0.1', 'localhost', '::1'].includes(u.hostname) &&
      u.port === '11434';

    if (u.protocol !== 'https:' && !isLocalOllama) {
      throw new Error(
        'Live AI endpoint must use HTTPS, except local Ollama on port 11434.'
      );
    }
  }

  const app = createApp({ config });

  app.on('error', e => {
    console.error(
      e.code === 'EADDRINUSE'
        ? 'Port is busy. Stop the existing server or change PORT in .env.'
        : e.message
    );

    process.exitCode = 1;
  });

  app.listen(port, '127.0.0.1', () => {
    console.log(
      `Agrisphere: http://127.0.0.1:${app.address().port} | ${
        config.mode === 'live' ? 'Live AI' : 'Offline demo'
      } | Local single-user module`
    );
  });
}
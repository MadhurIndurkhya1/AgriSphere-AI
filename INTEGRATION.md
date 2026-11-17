# Integration handoff

## Architecture

The same local Node process serves `public/` and the `/api` routes. The browser never calls the AI provider directly. `lib/store.js` stores state in one JSON file with synchronous atomic replacement. `lib/core.js` exports validation, retrieval, AI and report functions so your team can reuse them behind another backend.

## API contract

All writes with a body require `Content-Type: application/json`. Errors are `{ "error": "message" }` with a non-2xx status. Amounts are nonnegative numeric INR, not strings. Dates are `YYYY-MM-DD`. IDs are server-generated UUIDs.

| Method | Endpoint | Body / result |
| --- | --- | --- |
| GET | `/api/state` | Profile, records, conversations, reports, reminders, analytics, AI mode |
| PUT | `/api/profile` | Complete profile: `name, location, farmName, area, crop, soil, language, reminders, aiConsent` |
| POST | `/api/records` | `date, type: expense/revenue, category, amount, note` |
| DELETE | `/api/records/:id` | Deletes one record; report snapshots unaffected |
| POST | `/api/chat` | `message, conversationId?`; returns conversation ID, text, mode, retrieved notes |
| DELETE | `/api/conversations/:id` | Deletes one conversation |
| POST | `/api/reports` | `from, to`; returns stored report snapshot |
| GET | `/api/reports/:id/html` | Printable HTML; add `?download=1` to download |
| GET | `/api/reports/:id/csv` | CSV download with spreadsheet formula neutralization |
| DELETE | `/api/reports/:id` | Deletes report snapshot |
| POST | `/api/reminders` | `title, dueDate` |
| PATCH | `/api/reminders/:id` | `done: true/false` |

Live chat uses a minimal chat-completions payload (`model`, `messages`) and reads `choices[0].message.content`. Endpoint and credentials are server configuration only. Retrieved notes and farm records are explicitly described to the model as untrusted data. Prompt instructions do not guarantee model correctness; production needs domain review, evaluations and stronger controls.

## Before production

1. Connect the main application's authentication. Derive farmer identity from a verified server session, never a client-supplied ID.
2. Replace the shared JSON store with per-farmer database tables. Scope every read, report snapshot, conversation and write by authenticated ownership; add transactional writes and row-level controls where appropriate.
3. Replace `/api/state` with paginated, owner-scoped endpoints. Minimize report/message payloads.
4. Add vetted regional agronomy documents, titles, source URLs, dates, crop/location metadata and document versioning. Build chunking/retrieval tests; optionally replace lexical retrieval with embeddings and a vector index. Do not call the starter notes authoritative.
5. Obtain farmer consent and minimize provider-bound data. Add privacy and retention rules, encrypted backups, account deletion, auditing and secret management.
6. Add per-user cost quotas, rate limiting, monitoring, safe logs, domain-specific AI evaluations, and human escalation.
7. For live weather, integrate a provider server-side with explicit location, units, observation/forecast timestamps, caching and failure/stale-data indicators. No weather adapter is currently included.
8. For background notifications, use a scheduler/queue, a farmer timezone, consent, idempotent delivery records and authenticated notification providers. Do not infer contact consent from the profile checkbox for in-app reminders.
9. Add authentication and HTTPS before changing the local-only binding/Host policy. Rework CSRF/CORS for your exact application origin; do not disable checks broadly.
10. Keep reports deterministic for exact calculations. If adding an LLM narrative, label it separately and validate every numeric claim against computed totals. Add a proper PDF renderer if a one-click server PDF endpoint is needed.

No production hosting, external notification accounts, live weather service or database migration was performed for this source package.

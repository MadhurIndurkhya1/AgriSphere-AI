# Agrisphere — AI Assistant & Reports

A self-contained **local, single-farmer starter module**. Everything is in this folder. No npm dependencies, database installation or API key is needed for the offline demo. This is not a production multi-user service.

## Start on Windows

1. Extract the ZIP. Open the `agrisphere-ai-reports` folder in VS Code.
2. Open its terminal. Check `node --version`; use Node.js 24 or newer.
3. Run:

```powershell
npm start
```

4. Open **http://127.0.0.1:3000** in your browser.
5. Stop the server with **Ctrl+C**.

No `npm install` is necessary. If PowerShell blocks `npm.ps1`, run `npm.cmd start` or use Command Prompt. Do not change system execution policy just for this project.

## What is included

| Feature | Implemented behaviour |
| --- | --- |
| AI assistant | Offline template demo; optional live chat-completions API adapter |
| Retrieval / RAG | Keyword ranking of five original starter notes, plus saved farm context; passed to the LLM in live mode |
| Farm records | Add/delete dated INR expense and revenue transactions |
| Analytics | Recorded revenue, expenses, cash balance and expense category bars |
| Reports | Date-filtered, immutable snapshots, understandable deterministic summaries, HTML and CSV downloads |
| PDF | Open a saved report, press Ctrl+P, choose **Save as PDF**; browser print-to-PDF, not a server PDF endpoint |
| Notifications | Dated in-app reminders, completion status and due badge |
| Profile | Farmer name, farm, location, hectares, crop, soil, language preference and AI consent |
| History | Persistent conversations with continuation, report history and deletion |

Two **sample expense entries** are created on first startup. Delete them in Farm records before entering real data. The sample warning remains until all sample entries are removed. Previously generated reports are snapshots and keep their original sample labels.

## Test the module

```powershell
npm test
```

Suggested walkthrough:

1. Edit and save Profile.
2. Ask the assistant to summarize expenses. Verify that the answer says offline demo.
3. Add revenue and expense entries; check dashboard totals.
4. Generate a report covering those dates; open HTML, download CSV and save PDF using browser print.
5. Add a reminder due today; verify the due badge, then mark it complete.
6. Open History and continue a conversation.
7. Restart the server and check that your entries remain saved.

## Enable live AI (optional)

The server adapter follows the [official Chat Completions request structure](https://developers.openai.com/api/reference/resources/chat). Choose a model available to your provider account that supports this endpoint. No model or paid provider account is bundled.

```powershell
Copy-Item .env.example .env
```

Edit `.env` locally:

```dotenv
AI_MODE=live
LLM_ENDPOINT=https://api.openai.com/v1/chat/completions
LLM_API_KEY=your_private_api_key
LLM_MODEL=your_available_chat_model
PORT=3000
```

Restart the server and enable **AI data-sharing consent** in Profile. API calls may incur provider charges. A ChatGPT subscription is not an API credential. Never place an API key in frontend code or commit `.env`.

Live requests include farm location, area, crop, soil notes, transaction totals, up to 30 recent transactions, retrieved notes, the latest 10 conversation messages and the current question. Farmer name and farm name are not explicitly added to AI context, but users can include personal details in notes or questions. Only enable live mode if you agree to this sharing. The server uses HTTPS, a 30-second provider timeout and a basic single-user request throttle. Provider errors are shown rather than silently replaced by demo answers.

The live adapter has automated mocked tests. No real provider credentials or live AI requests were used to validate this package.

Validation: 11 automated unit/integration tests passed on Node 24.19.0, frontend JavaScript syntax passed, and the start command served the app successfully. Interactive browser/layout verification was blocked by this environment's browser access policy. Follow the walkthrough above for a manual UI check on your computer.

## Important limits

- This is a local development module, not an authenticated multi-farmer application. The server deliberately binds to `127.0.0.1` and rejects non-local Host headers and cross-origin browser requests. Anyone with local machine access can use the workspace. Do not expose it through a public tunnel.
- The five knowledge notes are original, general starter content, **not authoritative agricultural references**. This is simple lexical retrieval, not vector embeddings or semantic search. English keywords are supported; live Hindi replies are a preference, not Hindi retrieval support.
- No weather API, disease image analysis, yield prediction, fertilizer dose recommendation or pesticide instructions are implemented. The assistant must state missing evidence and refer diagnosis/chemical advice to a qualified local professional.
- Reports summarize financial records; cash balance is not audited profit. They do not infer missing transactions, future income or crop health.
- Notifications are in-app only, with a 30-second badge check while the page is open. There is no background scheduler, email, SMS, WhatsApp or push integration.
- Records, profile and history are plain JSON on disk, not encrypted. There is no authentication, multi-user isolation or database concurrency support.
- Local limits: 10,000 transactions, 1,000 reminders, 200 reports, 200 conversations, 200 messages per conversation. These protect the starter, not production capacity.

## Folder map

```text
agrisphere-ai-reports/
  public/       Interface: HTML, CSS, JavaScript
  lib/core.js   Validation, analytics, retrieval, LLM adapter, report exports
  lib/store.js  Local JSON storage
  server.js     Local HTTP server and REST routes
  test/         Automated unit and HTTP integration tests
  README.md     Setup and limitations
  INTEGRATION.md  API map and production handoff
  .env.example  Configuration template (no secret)
  .gitignore    Excludes private/runtime files
  package.json  Start and test commands
```

The `data/store.json` file is created automatically on first run. Stop the server before copying `data/` to a safe location for backup. To restore, stop the server and replace `data/store.json` with your backup. A malformed data file causes startup to fail rather than silently erasing it. Deleting a transaction does not remove copies from saved reports; delete those reports separately when needed.

## Upload to your team repository

Copy this complete folder into your Agrisphere repository and commit it. Exclude `.env` and `data/`; the supplied `.gitignore` handles these. The ZIP contains source only, no API key or personal runtime records. Uploading the source to GitHub does not run a Node server. GitHub Pages alone cannot run this backend.

Read `INTEGRATION.md` before connecting this module to your team's existing login, database or public deployment.

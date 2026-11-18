# AgriSphere — Smart Agriculture System

## Member 6: AI Assistant & Reports

**Contributor:** Sumit Rajput  
**GitHub:** [Sumit-rajput-007](https://github.com/Sumit-rajput-007)  
**Branch:** `feature/member6/ai-assistant-reports`

This branch contains Member 6’s AI Chat Assistant, Reports, Analytics, Notifications, Profile and History module for the team project.

A self-contained **local, single-farmer starter module**. Everything is in this folder. No npm dependencies, database installation or API key is needed for the offline demo. This is not a production multi-user service.

## Requirements

- Node.js 24 or newer
- Git to clone the repository
- A modern browser
- Optional: a compatible LLM provider API key for live AI

## Clone and run

```powershell
git clone --branch feature/member6/ai-assistant-reports --single-branch https://github.com/MadhurIndurkhya1/AgriSphere-AI.git
cd AgriSphere-AI
node --version
npm start
```

Open **http://127.0.0.1:3000** in your browser. Stop the server with **Ctrl+C**.

No `npm install` is necessary because this module has no external npm dependencies. If PowerShell blocks `npm.ps1`, use `npm.cmd start`.

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

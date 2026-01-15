# 📊 Agentic Reporting & Automated Ticketing (n8n + GitHub + pyATS MCP)

An **agentic n8n workflow** that automatically:

- 🧠 Investigates network state
- 📝 Generates professional technical reports
- 📁 Commits reports to GitHub
- 🎫 Detects issues and auto-creates GitHub tickets with actionable tasks

Designed for **continuous operational visibility** and **closed-loop remediation workflows**.

[🔗 Link to n8n workflow file](https://github.com/ponchotitlan/pyATS-loves-agenticops/blob/main/workflows/Network%20Status%20Reports%20Workflow.json)

---

## ✨ What this gives you

- 📅 Scheduled or manual report generation  
- 🤖 Agent-driven investigation using real device data  
- 📄 Structured Markdown reports (committed to GitHub)  
- 🎫 Automatic issue creation when risks/recommendations are detected  
- 🔗 Tight traceability between reports and tickets  
- 🧩 Fully auditable, GitOps-friendly workflow  

---

## 🧠 Architecture at a glance

| Agent | Responsibility | Talks to Network? | Creates Tickets? |
|------|----------------|--------------------|------------------|
| Reporting Agent | Investigates, gathers facts, renders Markdown report | ✅ via pyATS MCP | ❌ |
| Ticketing Agent | Analyzes report, detects issues, generates GitHub issue | ❌ | ✅ |

Clean separation of concerns:  
> One agent observes. One agent escalates.

---

## 🔄 End-to-end flow

1. Workflow triggered:
   - ⏱️ By scheduler  
   - ▶️ Or manually  

2. System loads dynamically from GitHub:
   - A [report request file](https://github.com/ponchotitlan/pyATS-loves-agenticops/tree/main/reports) 
   - The [reporting agent prompt](https://github.com/ponchotitlan/pyATS-loves-agenticops/blob/main/agents/network_report_agent.txt)

3. **Reporting Agent**:
   - Uses **pyATS MCP** to query real devices  
   - Produces a structured Markdown report with sections like:
     - Executive Summary  
     - Analysis & Findings  
     - Risks & Considerations  
     - Recommendations  

4. Report is automatically committed to GitHub:
   - 📁 [Target folder](https://github.com/ponchotitlan/pyATS-loves-agenticops/tree/main/reports/files)

5. **Ticketing Agent**:
   - Loads its prompt from GitHub  
   - Analyzes the generated report  
   - If risks/recommendations exist:
     - 🎫 Creates a GitHub Issue including:
       - Priority  
       - Summary  
       - Detailed description  
       - Actionable task list  
       - Link to the originating report  

---

## 🔌 pyATS MCP integration

The reporting agent performs all factual investigation using a real execution backend:

👉 [pyATS MCP server](https://github.com/ponchotitlan/pyATS_MCP)

This ensures:
- ✅ No hallucinated device data  
- ✅ Real CLI outputs  
- ✅ Auditable automation  
- ✅ Clean separation between reasoning and execution  

---

## 📂 GitHub-driven behavior

This workflow is intentionally **Git-native**:

- Prompts are stored in GitHub  
- Report requests are stored in GitHub  
- Outputs (reports) are committed to GitHub  
- Findings become GitHub Issues  

This enables:
- Versioned prompts  
- Reviewable report definitions  
- Full audit trail  
- Native integration with engineering workflows  

---

## 🧰 Core stack

- **n8n** – orchestration engine  
- **GitHub API** – storage, reports, tickets  
- **pyATS MCP** – real device interrogation  
- **LLM Agents (via LangChain in n8n)** – reasoning layer  

---

## 🏗️ Use cases

- Continuous network posture reporting  
- Audit preparation  
- Compliance evidence generation  
- Proactive risk detection  
- Auto-generated remediation backlogs  
- GitOps-driven NetOps workflows  

---

## 🚀 Setup (high level)

You’ll need:

- n8n (self-hosted)
- GitHub repo access + API token
- [pyATS MCP server](https://github.com/ponchotitlan/pyATS_MCP) running in HTTP transport mode

Then:
- Import workflow JSON into n8n  
- Configure GitHub credentials  
- Point MCP node to your MCP endpoint  
- Customize report request files  

---

## 📌 Philosophy

> Reports shouldn’t rot in dashboards.  
> They should generate action.

This workflow enforces:
- Facts over assumptions (MCP-backed data)
- Structure over free-form text
- Traceability between evidence and action
- Git as the operational source of truth

---

If you’re building **serious operational intelligence pipelines**, this gives you a clean, extensible foundation for **agentic observability + automated governance**.

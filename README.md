<h1 align="center">pyATS 🫰 AgenticOps<br /><br />
<div align="center">
<img src="images/pyATS_logoAsset.png"/>
</div>

<div align="center">
<img src="https://img.shields.io/badge/n8n-Workflow-EA4B71?style=flat-square&logo=n8n&logoColor=white" alt="n8n">
<img src="https://img.shields.io/badge/Cisco-pyATS-049fd9?style=flat-square&logo=cisco&logoColor=white" alt="Cisco pyATS">
<img src="https://img.shields.io/badge/MCP-Protocol-000000?style=flat-square&logo=anthropic&logoColor=white" alt="MCP">
<img src="https://img.shields.io/badge/Python-3.10+-3776AB?style=flat-square&logo=python&logoColor=white" alt="Python">
<img src="https://img.shields.io/badge/Docker-Required-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker">
<a href="https://deepwiki.com/ponchotitlan/pyATS-loves-agenticops"><img src="https://deepwiki.com/badge.svg" alt="Ask DeepWiki"></a>
</div>
</h1>

<div align="center">
A collection of <strong>low-code</strong>, AgenticOps workflows based on <strong>n8n, MCP and Cisco pyATS</strong> for network automation experiments across ChatOps and reporting use cases 🧪
<br /><br />
</div>

---

## 📦 Included projects

### ⚙️ 1. ChatOps Agentic Network Automation
Operate your network directly from Slack or Webex Teams using a multi-agent architecture.

**Highlights**
- 💬 Slack and Webex Teams ChatOps interfaces  
- 🧠 Multiple specialized agents (intent, planning, read, commit, formatting)  
- 🛡️ Guardrails with human approval before writes  
- 🔌 Real execution via **pyATS MCP**  
- 🔁 Rollback-aware configuration workflows  

**Use cases**
- Safe interactive automation  
- Change workflows with approval  
- Secure self-hosted NetOps bots  


📁 More information:  
[Agentic ChatOps for network automation using n8n + Slack + pyATS MCP](https://github.com/ponchotitlan/pyATS-loves-agenticops/blob/main/docs/chatops_slack_workflow.md)  
[Agentic ChatOps for network automation using n8n + Webex Teams + pyATS MCP](https://github.com/ponchotitlan/pyATS-loves-agenticops/blob/main/docs/chatops_wxt_workflow.md)

---

### 📊 2. Agentic Reporting & Automated Ticketing
An autonomous pipeline for **continuous network reporting and GitHub-native remediation tracking**.

**Highlights**
- 📅 Scheduled or manual execution  
- 🤖 Reporting agent investigates network using **pyATS MCP**  
- 📄 Generates professional Markdown reports  
- 📁 Commits reports to GitHub  
- 🎫 Ticketing agent detects risks and auto-creates GitHub Issues  
- 🔗 Tight traceability between evidence and action  

**Use cases**
- Continuous posture reporting  
- Compliance evidence  
- Risk-driven backlog generation  
- GitOps-style operational governance  

📁 More information:  
[Agentic reporting + GitHub issue automation using n8n + pyATS MCP](https://github.com/ponchotitlan/pyATS-loves-agenticops/blob/main/docs/reporting_ticketing_workflow.md)

---

## ⚙️ General setup

Clone this repository:

```
git clone https://github.com/ponchotitlan/pyATS-loves-agenticops
```

Then choose one of the included Docker Compose examples and copy it to `docker-compose.yml`:

```
cp docker-compose-example-cloudflare.yml docker-compose.yml
```

or:

```
cp docker-compose-example-ngrok.yml docker-compose.yml
```

### Cloudflare Docker Compose setup

Use `docker-compose-example-cloudflare.yml` when you want n8n exposed through a Cloudflare Tunnel.

- Replace `YOUR_DOMAIN` in these n8n settings with your public hostname, for example `n8n.example.com`:
  - `WEBHOOK_URL=https://YOUR_DOMAIN`
  - `N8N_HOST=YOUR_DOMAIN`
  - `N8N_EDITOR_BASE_URL=https://YOUR_DOMAIN`
- Replace `YOUR_TUNNEL_TOKEN` with the token from the Cloudflare Zero Trust dashboard

### ngrok Docker Compose setup

Use `docker-compose-example-ngrok.yml` when you want to expose n8n through ngrok.

- Reserve a static ngrok domain in your ngrok dashboard
- Replace `YOUR-STATIC-DOMAIN` in these settings with that domain:
  - `WEBHOOK_URL=https://YOUR-STATIC-DOMAIN`
  - `N8N_HOST=YOUR-STATIC-DOMAIN`
  - `N8N_EDITOR_BASE_URL=https://YOUR-STATIC-DOMAIN`
  - `--domain=YOUR-STATIC-DOMAIN`
- Replace `YOUR-TOKEN` with your ngrok authtoken

### Shared pyATS MCP setup

Both Docker Compose examples already contain the same `pyats-mcp` service. Verify these shared settings:

- `MCP_TRANSPORT: http` keeps the MCP server in HTTP mode, which is what these workflows expect
- `MCP_HOST: 0.0.0.0` exposes the MCP server on all container interfaces
- `MCP_PORT: 8000` publishes the MCP API on port 8000 inside the Docker network and on the host
- `ports: - "8000:8000"` exposes the same MCP port on the host
- `./testbed.yaml:/app/testbed.yaml:ro` mounts your pyATS inventory file read-only into the container
- Replace `./testbed.yaml` with your own inventory before starting the stack

If you need a different MCP port, change both `MCP_PORT` and the published port mapping together so they stay consistent.

After the compose file is configured, start the services:

```bash
docker compose up -d
```

This starts n8n, the selected tunnel service, and the shared `pyats-mcp` container.

To stop the services:

```
docker compose down
```

---

## 🧠 Architectural philosophy

| Principle | Meaning |
|--------|--------|
| 🧩 Separation of concerns | No agent has unlimited power |
| 🔒 Guardrails by design | Writes require structure + approval |
| 🔧 Tools over hallucinations | Real data via pyATS MCP |
| 📁 Git as source of truth | Prompts, reports, tickets are versioned |
| 👤 Humans stay in control | Automation proposes, humans approve |

> Assume models are fallible. Design systems that remain safe anyway.

---

## 🔌 Core execution layer: pyATS MCP

Both projects rely on a shared real-world execution backend:

👉 [pyATS MCP](https://github.com/ponchotitlan/pyATS_MCP)

This provides:
- Real CLI execution  
- Real device outputs  
- Zero fabricated telemetry  
- Clean separation between reasoning and execution  

---

## 🧰 Core stack

- **pyATS** – network interaction engine  
- **MCP server** – execution abstraction  
- **n8n** – workflow orchestration  
- **LLM agents** – reasoning layer  
- **GitHub** – storage, audit trail, collaboration  
- **Slack** – ChatOps interface (project 1)  

---

## 🏗️ What this is good for

- Agentic NetOps experimentation  
- Secure automation architecture  
- Internal platform foundations  
- Operational AI
- GitOps + AI convergence   

---

## 🤝 Contributing

Got ideas for new workflows or improvements? Contributions are welcome! Feel free to open issues or submit pull requests.

---

## 🌐 Resources

- [Cisco pyATS Documentation](https://developer.cisco.com/docs/pyats/)
- [n8n Documentation](https://docs.n8n.io/)
- [Model Context Protocol](https://modelcontextprotocol.io/)

---

<div align="center"><br />
    Made with ☕️ by Poncho Sandoval - <code>Developer Advocate 🥑 @ DevNet - Cisco Systems 🇵🇹</code><br /><br />
    <a href="mailto:alfsando@cisco.com?subject=Question%20about%20[pyATS%20loves%20AgenticOps]&body=Hello,%0A%0AI%20have%20a%20question%20regarding%20your%20project.%0A%0AThanks!">
        <img src="https://img.shields.io/badge/Contact%20me!-blue?style=flat&logo=gmail&labelColor=555555&logoColor=white" alt="Contact Me via Email!"/>
    </a>
    <a href="https://github.com/ponchotitlan/pyATS-loves-agenticops/issues/new">
      <img src="https://img.shields.io/badge/Open%20Issue-2088FF?style=flat&logo=github&labelColor=555555&logoColor=white" alt="Open an Issue"/>
    </a>
    <a href="https://github.com/ponchotitlan/pyATS-loves-agenticops/fork">
      <img src="https://img.shields.io/badge/Fork%20Repository-000000?style=flat&logo=github&labelColor=555555&logoColor=white" alt="Fork Repository"/>
    </a>
</div>

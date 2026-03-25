# ⚙️ ChatOps Agentic Network Automation Workflow (n8n + Slack)

<div align="center">
<img src="../images/chatops_workflow_read.png"/>
<img src="../images/chatops_workflow_write.png"/>
</div>

A practical **low-code, agentic ChatOps workflow** built in **n8n** for safe network automation via **Slack**.  
Uses **multiple specialized agents**, structured guardrails, and real device interaction through **pyATS MCP**.

[🔗 Link to n8n workflow file](https://github.com/ponchotitlan/pyATS-loves-agenticops/blob/main/workflows/ChatOps%20Network%20Automation%20Workflow.json)

---

## ✨ What this gives you

- 💬 Operate your network from Slack (ChatOps)
- 🧠 Agentic architecture (separation of responsibilities)
- 🛡️ Guardrails for risky operations
- 👤 Human approval before changes
- 🔁 Rollback-aware execution
- 🧩 Fully self-hosted (n8n + local models + MCP)

---

## 🧠 Architecture at a glance

| Agent | Responsibility | Can Execute Writes? |
|------|----------------|----------------------|
| Intent Agent | Classifies `read` vs `write`, extracts structured JSON payload | ❌ |
| Reading Agent | Executes operational queries via **pyATS MCP** | ❌ (read-only) |
| Planning Agent | Generates CLI plan, risk level, and rollback commands | ❌ |
| Commit Agent | Pushes approved configs via **pyATS MCP** | ✅ (after approval) |
| Formatting Agent | Formats clean Slack replies for the thread | ❌ |

This separation ensures **no single agent has full power**.

---

## 🔐 Safety & Guardrails

Built-in by design:

- Strict intent classification (`read` vs `write`)
- Structured JSON contracts between agents
- No configuration executed without:
  - Generated plan
  - Risk level
  - Rollback commands
  - Explicit Slack button confirmation
- Read and Write execution handled by different agents

Result: **predictable, inspectable, auditable automation**.

---

## 🔄 End-to-end flow

1. User mentions bot in Slack  
2. Intent Agent classifies and extracts request  
3. Switch by intent:
   - `read` → Reading Agent → **pyATS MCP executes show commands** → formatted reply
   - `write` → Planning Agent → approval card posted to Slack
4. User clicks:
   - ❌ Cancel → nothing happens
   - ✅ Confirm → Commit Agent → **pyATS MCP pushes configuration**
5. Result posted back to the same Slack thread

<div align="center">
<img src="../images/slack_inventory.png"/>
<img src="../images/slack_read.png"/>
<img src="../images/slack_write.png"/>
</div>

---

## 🔌 pyATS MCP integration

Both execution agents rely on an external **[MCP server backed by pyATS](https://github.com/ponchotitlan/pyATS_MCP)**:

- Reading Agent → uses MCP to run operational commands safely  
- Commit Agent → uses MCP to apply approved configurations  

MCP server implementation used here:  
👉 https://github.com/ponchotitlan/pyATS_MCP

This cleanly separates:
- 🧠 Reasoning (agents)
- 🔧 Execution (pyATS tooling)

---

## 🧰 Core stack

- **n8n** – workflow orchestration  
- **Slack** – ChatOps interface  
- **Ollama (local LLMs)** – agent runtime  
- **[pyATS MCP](https://github.com/ponchotitlan/pyATS_MCP)** – real network execution layer  
- **LangChain (via n8n nodes)** – agent abstraction  

---

## 🏗️ Use cases

- Internal NetOps automation platforms  
- Secure ChatOps bots  
- Agentic system experimentation  
- Self-hosted AI infra for operations  

---

## 🚀 Setup (high level)

You’ll need:

- n8n (self-hosted)
- Slack App (mentions + interactive buttons enabled) - [🔗 Check this frustration-free guide](https://github.com/ponchotitlan/pyATS-loves-agenticops/blob/main/docs/chatops_slack_setup.md)
- Ollama with your preferred model
- [pyATS MCP server](https://github.com/ponchotitlan/pyATS_MCP) running in HTTP transport mode

Then:
- Pick one Docker Compose example and copy it to `docker-compose.yml`
- Configure the tunnel-specific settings for your chosen option
- Configure the shared pyATS MCP settings
- Import the workflow JSON into n8n
- Update credentials (Slack, Ollama)
- Adjust MCP endpoint URL

### Cloudflare Docker Compose setup

Use `docker-compose-example-cloudflare.yml` when you want n8n exposed through a Cloudflare Tunnel.

- Copy `docker-compose-example-cloudflare.yml` to `docker-compose.yml`
- Replace `YOUR_DOMAIN` in these n8n settings with your public hostname, for example `n8n.example.com`:
   - `WEBHOOK_URL=https://YOUR_DOMAIN`
   - `N8N_HOST=YOUR_DOMAIN`
   - `N8N_EDITOR_BASE_URL=https://YOUR_DOMAIN`
- Replace `YOUR_TUNNEL_TOKEN` with the token from the Cloudflare Zero Trust dashboard

### ngrok Docker Compose setup

Use `docker-compose-example-ngrok.yml` when you want to expose n8n through ngrok.

- Copy `docker-compose-example-ngrok.yml` to `docker-compose.yml`
- Reserve a static ngrok domain in your ngrok dashboard
- Replace `YOUR-STATIC-DOMAIN` in these settings with that domain:
   - `WEBHOOK_URL=https://YOUR-STATIC-DOMAIN`
   - `N8N_HOST=YOUR-STATIC-DOMAIN`
   - `N8N_EDITOR_BASE_URL=https://YOUR-STATIC-DOMAIN`
   - `--domain=YOUR-STATIC-DOMAIN`
- Replace `YOUR-TOKEN` with your ngrok authtoken

### Shared pyATS MCP setup

Both Docker Compose examples already contain the same `pyats-mcp` service. Verify these shared settings:

- `MCP_TRANSPORT: http` keeps the MCP server in HTTP mode, which is what this workflow expects
- `MCP_HOST: 0.0.0.0` exposes the MCP server on all container interfaces
- `MCP_PORT: 8000` publishes the MCP API on port 8000 inside the Docker network and on the host
- `ports: - "8000:8000"` exposes the same MCP port on the host
- `./testbed.yaml:/app/testbed.yaml:ro` mounts your pyATS inventory file read-only into the container
- Replace `./testbed.yaml` with your own inventory file contents before starting the stack

If you need a different MCP port, change both `MCP_PORT` and the published port mapping together so they stay consistent.

---

## 📌 Philosophy

> Assume the model can be wrong. Design the system so mistakes are contained.

This workflow favors:
- Structure over clever prompts
- Multiple constrained agents over a single powerful one
- Human approval over blind execution

---

If you're building serious agentic automation (not demos), this is meant to be a **solid foundation you can extend, audit, and trust**.

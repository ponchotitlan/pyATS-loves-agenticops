# Network Assessment Report

## Executive Summary

R1 (Cisco IOS-XE 17.15, IOL platform) was audited against 22 supplied hardening rules. The device is in a **largely unhardened, default-lab state** and fails the majority of controls.

| Verdict | Count |
|---|---|
| PASS | 2 |
| FAIL | 15 |
| NOT ASSESSED | 5 |

**Critical/High findings requiring immediate action:**

- **R001 (CRITICAL)** — `enable password cisco` in cleartext; no `enable secret`. Privileged EXEC is trivially compromised.
- **R002 (HIGH)** — All secrets are type 0 cleartext. No type 6/8/9 hashing anywhere.
- **R003 (HIGH)** — Local users defined with `password 0`, not `secret`. Credentials readable in config.
- **R009 (HIGH)** — `ip http server` enabled (cleartext web management).
- **R017 (HIGH)** — `exec-timeout 0 0` on both console and VTY: sessions never time out.
- **R022 (HIGH)** — No Management Plane Protection configured.

Compounding these, `line vty 0 4` permits `transport input telnet ssh`, meaning cleartext credentials traverse the network. Combined with cleartext local passwords and infinite EXEC timeouts, R1 should be treated as **effectively unauthenticated from a security-assurance standpoint** until remediated.

## Scope & Assumptions

**Scope:** Single device, R1. All 22 rules fall within the Management Plane domain despite the request listing eight domains — the supplied Rules JSON contains no AAA-, SNMP-, Logging-, Control Plane-, Routing-, Data Plane-, or Other-domain rules beyond those that overlap Management Plane.

**Data collected:**
- `pyats_list_devices` — testbed inventory (one call)
- `pyats_show_running_config` on R1 — one call, full config

No supplementary show commands were issued: every rule carries `evidence_type: running_config`, so the single config retrieval is authoritative for all config-derived verdicts.

**Assumptions and limitations:**

1. **The hardening guide was not fetched.** No web-retrieval tool is available in this environment. The requested step of extracting core hardening domains from the guide's checklist/appendix could not be performed. Assessment is based solely on the 22 rules provided.
2. **Default-off services cannot be confirmed from running config.** IOS-XE suppresses default-state commands from `show running-config`. Absence of a line is therefore ambiguous — it may mean "default off" or "not applicable to this platform." Rules R007, R010, R011, R015 and R016 are marked NOT ASSESSED for this reason; confirming them requires `show running-config all`.
3. **Business context unknown.** Several rules (R006 password recovery, R012 DNS lookup, R013/R014 discovery protocols) depend on operational requirements and trust boundaries not supplied. Verdicts reflect the literal rule text; caveats are noted inline.
4. `Ethernet0/2` sits in VRF `Mgmt-intf` and is described as `to port1.sandbox-backend` — treated as the out-of-band management interface. `Ethernet0/0` and `Ethernet0/1` are treated as untrusted/production-facing.

## Environment Overview

| Property | Value |
|---|---|
| Hostname | R1 |
| OS / Version | IOS-XE 17.15 |
| Platform | iol (IOS on Linux) |
| Type | Router |
| Config size | 3614 bytes |
| Last change | 08:21:32 UTC Tue Sep 15 2026 |

**Interfaces:**

| Interface | Address | Role |
|---|---|---|
| Ethernet0/0 | 10.10.10.100/24 | Production |
| Ethernet0/1 | 1.1.1.1/24 | Production (transit to 1.1.1.2) |
| Ethernet0/2 | 10.10.20.171/24, VRF Mgmt-intf | Out-of-band management |
| Ethernet0/3 | unassigned | Shutdown |

**Notable state:** `no aaa new-model`; no Loopback interfaces; no SNMP configuration; no `logging host` configured (`no logging console`, `no logging btrace`); self-signed PKI trustpoint `TP-self-signed-131184641` present; `ip http server` and `ip http secure-server` both enabled; static routes for 20.20.20.0/24 and a VRF default route.

## Analysis & Findings

| Device | Rule ID | Rule | Severity | Evidence | Verdict |
|---|---|---|---|---|---|
| R1 | R001 | Enable secret configured for privileged access | CRITICAL | `enable password cisco` present; no `enable secret` line anywhere in config | FAIL |
| R1 | R002 | Use strong password hash types only | HIGH | `enable password cisco` (type 0); `username cisco password 0 cisco`; `username admin password 0 15 admin`; `password cisco` under `line con 0` and `line vty 0 4`. No type 6/8/9 present | FAIL |
| R1 | R003 | Local users defined with secret not password | HIGH | `username cisco password 0 cisco`; `username admin password 0 15 admin` — both use `password`, neither uses `secret` or `algorithm-type scrypt` | FAIL |
| R1 | R004 | Login password retry lockout enabled | MEDIUM | `no aaa new-model`; no `aaa local authentication attempts max-fail` present | FAIL |
| R1 | R005 | Minimize number of privilege level 15 users | MEDIUM | No `username ... privilege 15` entries. Note: `username admin password 0 15 admin` parses `0` as encryption type and `15 admin` as the password literal — not a privilege assignment | PASS |
| R1 | R006 | Password recovery disabled (risk-considered) | MEDIUM | No `no service password-recovery` in config; recovery remains enabled | FAIL |
| R1 | R007 | TCP and UDP small servers disabled | MEDIUM | No `service tcp-small-servers` / `service udp-small-servers` lines. Default is off in modern IOS-XE, but cannot be confirmed from `show running-config` alone | NOT ASSESSED |
| R1 | R008 | Finger and BOOTP services disabled | MEDIUM | No `no ip finger`, no `no ip bootp server`, no `ip dhcp bootp ignore` present. BOOTP server is on by default in IOS-XE and is not explicitly disabled | FAIL |
| R1 | R009 | HTTP server disabled and HTTPS used if needed | HIGH | `ip http server` enabled (cleartext); `ip http secure-server` also enabled. No `ip http access-class` restriction | FAIL |
| R1 | R010 | Network autoloading of configuration disabled | MEDIUM | No `service config` or `no service config` line. Default off, but not explicitly confirmed | NOT ASSESSED |
| R1 | R011 | PAD service disabled | MEDIUM | No `no service pad` line present; default state not verifiable from running config | NOT ASSESSED |
| R1 | R012 | DNS lookup disabled if not required | MEDIUM | `ip domain name virl.info` configured; no `no ip domain-lookup` — resolution remains enabled | FAIL |
| R1 | R013 | CDP disabled globally or on untrusted interfaces | MEDIUM | No `no cdp run` globally; no `no cdp enable` on Ethernet0/0, Ethernet0/1 or Ethernet0/2. CDP is on by default | FAIL |
| R1 | R014 | LLDP disabled globally or on untrusted interfaces | MEDIUM | No `lldp run` and no `no lldp run`. LLDP is disabled by default on IOS-XE and was not enabled — no transmit/receive configured on any interface | PASS |
| R1 | R015 | MOP disabled on interfaces | MEDIUM | No `no mop enabled` under any interface. MOP defaults on for Ethernet interfaces, but state is not shown in running config | NOT ASSESSED |
| R1 | R016 | Guestshell and Smart Install disabled | MEDIUM | No `no vstack` and no guestshell config present. Neither service state is verifiable from running config on this platform | NOT ASSESSED |
| R1 | R017 | EXEC timeout configured on console and vty | HIGH | `line con 0` → `exec-timeout 0 0`; `line vty 0 4` → `exec-timeout 0 0`. Zero disables timeout entirely on both | FAIL |
| R1 | R018 | TCP keepalives enabled inbound and outbound | MEDIUM | Neither `service tcp-keepalives-in` nor `service tcp-keepalives-out` present | FAIL |
| R1 | R019 | Dedicated loopback used as management source | MEDIUM | No `interface Loopback0` defined; no `source-interface` directives for any management protocol | FAIL |
| R1 | R020 | Memory threshold notification and reservation | MEDIUM | `memory free low-watermark processor 81225` present, but `memory free low-watermark io` and `memory reserve critical` both absent — partial compliance only | FAIL |
| R1 | R021 | CPU thresholding notification configured | MEDIUM | No `process cpu threshold type ...` and no `snmp-server enable traps cpu threshold` present | FAIL |
| R1 | R022 | Management Plane Protection restricts interfaces | HIGH | `control-plane` block is present but empty — no `host` sub-mode, no `management-interface ... allow` statement | FAIL |

**Cross-cutting observation (not a supplied rule):** `line vty 0 4` has `transport input telnet ssh`. Telnet transmits credentials in cleartext. Given that those credentials are also stored in cleartext (R002/R003), this materially amplifies every management-plane finding and should be remediated alongside them.

## Risks & Considerations

**R001 — No enable secret (CRITICAL).** `enable password cisco` is stored in cleartext and uses a reversible algorithm. Anyone with read access to the config — including via the enabled HTTP server — obtains full privileged EXEC. This is the single highest-impact finding.

**R002 — Weak/no password hashing (HIGH).** Every credential on the device is type 0 cleartext. Config backups, TFTP transfers, screen-shares and support-case uploads all leak working administrative credentials.

**R003 — Local users use `password` not `secret` (HIGH).** Both `cisco` and `admin` accounts are readable. `line vty 0 4` uses `login local`, so these accounts directly gate remote access.

**R009 — HTTP server enabled (HIGH).** `ip http server` exposes cleartext web management. With no `ip http access-class`, it is reachable from any interface with an IP — including the two production-facing interfaces.

**R017 — No EXEC timeout (HIGH).** `exec-timeout 0 0` on console and VTY means an authenticated session persists indefinitely. An unattended console or an orphaned VTY session remains fully privileged until manually
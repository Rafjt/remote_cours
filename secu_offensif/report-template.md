# Penetration Test Report — Template

> **How to use this template**
>
> - Replace every `[PLACEHOLDER]`. Delete every instruction block like this one.
> - One finding per `### F-NN` block. Keep the field order — it is what makes
>   the report easy to nvigate.
> - Evidence goes in `evidence/`, referenced by relative path.
> - This file is valid Markdown and imports directly into SysReptor.

---

# Penetration Test Report

| | |
| --- | --- |
| **Client** | [CLIEN_NAME] |
| **Assessment type** | [Black box / Grey box / White box] |
| **Testing window** | [START] → [END] |
| **Report date** | [DATE] |
| **Team** | [NAMES] |
| **Version** | 1.0 |

**Classification: CONFIDENTIAL** — contains exploitable vulnerability
details. Distribute on a need-to-know basis.

---

## 1. Executive summary

> **Written for a reader who will not go past this page.**
> No tool names. No CVE numbers. No jargon. One page.

### 1.1 Context

[Two or three sentences: what was tested, under what rules, over what
period.]

### 1.2 Overall assessment

[One paragraph. What could an attacker achieve, and how hard was it?
State the time and the starting position — "in four hours, without
credentials" is the sentence that gets budget.]

### 1.3 Findings

| Severity | Count |
| --- | --- |
| Critical | |
| High | |
| Medium | |
| Low | |
| Informational | |

### 1.4 Priority recommendations

1. [Action, in business language, highest impact first]
2. [...]
3. [...]

---

## 2. Scope and methodology

### 2.1 Scope

**In scope**

| Asset | Type | Notes |
| --- | --- | --- |

**Out of scope**

| Asset | Reason |
| --- | --- |

### 2.2 Rules of engagement

| Constraint | Detail |
| --- | --- |
| Authorised techniques | |
| Forbidden techniques | |
| Testing hours | |
| Rate limits | |
| Stop conditions | |

### 2.3 Methodology

[Which frameworks you followed — PTES phases, OWASP WSTG test IDs — and
how the engagement was sequenced.]

### 2.4 Limitations

[What you could not test, and why. Be honest: time, access, scope,
availability. A report without limitations is not credible.]

---

## 3. Attack narrative

> **The story of the intrusion, in chronological order.**
> This is the section technical readers enjoy and the one that proves you
> understood the environment rather than ran a scanner.

### 3.1 Reconnaissance

[What you found, what you prioritised, and why.]

### 3.2 Initial access

[How you got in. Reference the finding: see F-01.]

### 3.3 Privilege escalation

[...]

### 3.4 Lateral movement and pivoting

[...]

### 3.5 Objectives reached

[What you ultimately obtained, and what it would mean for the business.]

---

## 4. Findings

> One block per finding. Order by severity, highest first.

### F-01 — [TITLE: the vulnerability, not the tool]

| | |
| --- | --- |
| **Severity** | [Critical / High / Medium / Low / Info] |
| **CVSS** | `CVSS:3.1/AV:_/AC:_/PR:_/UI:_/S:_/C:_/I:_/A:_` (`[SCORE]`) |
| **Affected asset** | [Unambiguous: hostname, IP, URL, parameter] |
| **CWE** | [CWE-NNN] |
| **Status** | Open |

#### Description

[What the flaw is, in plain language. Assume the reader knows their own
system but not this vulnerability class.]

#### Impact

[What an attacker gains. Business terms, not technical restatement.
"Full read access to the customer database" — not "SQL injection is
possible".]

#### Proof of concept

[Numbered, reproducible steps. Exact commands and requests. A competent
engineer who was not present must be able to follow this.]

```
[EXACT COMMAND OR REQUEST]
```

```
[EXACT RESPONSE — truncated if long, with the truncation marked]
```

![Evidence](evidence/F-01-01.png)

> Credentials and personal data redacted. Prove access, not volume.

#### Remediation

[Specific and actionable. "Apply patches" is not a remediation.
Name the setting, the version, the code change.]

| Priority | Effort | Recommendation |
| --- | --- | --- |
| | | |

#### References

- [CVE / vendor advisory / OWASP / CWE links]

#### MITRE ATT&CK

| Technique | ID |
| --- | --- |

---

### F-02 — [TITLE]

[Repeat the block.]

---

## 5. MITRE ATT&CK coverage

> The section the client's SOC reads first.

| Tactic | Technique | ID | Where used |
| --- | --- | --- | --- |
| Reconnaissance | | | |
| Initial Access | | | |
| Execution | | | |
| Persistence | | | |
| Privilege Escalation | | | |
| Defense Evasion | | | |
| Credential Access | | | |
| Discovery | | | |
| Lateral Movement | | | |
| Command and Control | | | |

---

## 6. Remediation roadmap

| # | Finding | Severity | Effort | Priority |
| --- | --- | --- | --- | --- |
| 1 | | | | Immediate |
| 2 | | | | Short term |
| 3 | | | | Medium term |

---

## 7. Cleanup and artefacts

> **Mandatory.** Anything you created must be listed and confirmed removed.

| Artefact | Location | Created | Removed | Confirmed by |
| --- | --- | --- | --- | --- |
| [Account, webshell, scheduled task, implant...] | | | | |

**Data retention:** [What you hold, how it is protected, when it is
destroyed.]

---

## 8. Appendices

### A. Tooling

| Tool | Version | Used for |
| --- | --- | --- |

### B. Raw output

[Reference files in `scans/`. Do not paste hundreds of lines inline.]

### C. Glossary

[Terms a non-technical reader may need.]

---

## Submission checklist

- [ ] Every `[PLACEHOLDER]` replaced, every instruction block deleted
- [ ] Executive summary contains no tool names, CVEs, or jargon
- [ ] Every finding reproducible by someone who was not present
- [ ] Every CVSS score includes the full v3.1 vector string
- [ ] Every credential and personal data item redacted
- [ ] Every screenshot shows the command and identifies the target
- [ ] Impact written in business terms, not restating the description
- [ ] Remediation is specific — no "apply patches"
- [ ] ATT&CK mapping at sub-technique level where applicable
- [ ] Cleanup table complete
- [ ] Limitations stated honestly

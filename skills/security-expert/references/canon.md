# Security canon: fetch, don't recall

Security guidance moves. Model recall of a Top 10 is frequently a version or two out of date, and the categories get renamed and merged between revisions. **Fetch the source before citing a category.**

Use these when you need the authoritative category name, the current ranking, or the recommended control. Cite the specific item, not "OWASP says".

## Primary lists

| Source | Use for | URL |
|---|---|---|
| OWASP Top 10 (web) | The category vocabulary for web application findings | https://owasp.org/www-project-top-ten/ |
| OWASP API Security Top 10 | Anything with an API surface. Object-level authorization lives here | https://owasp.org/www-project-api-security/ |
| OWASP Mobile Top 10 | Mobile clients | https://owasp.org/www-project-mobile-top-10/ |
| OWASP MASVS | Mobile verification requirements, by level | https://mas.owasp.org/MASVS/ |
| OWASP MASTG | Mobile testing procedures, per requirement | https://mas.owasp.org/MASTG/ |
| OWASP ASVS | Verification requirements for web and services, by level | https://owasp.org/www-project-application-security-verification-standard/ |
| OWASP Top 10 for LLM Applications | Prompt injection, insecure output handling, agent permissions | https://owasp.org/www-project-top-10-for-large-language-model-applications/ |
| CWE Top 25 | The weakness vocabulary, when a finding needs a precise CWE | https://cwe.mitre.org/top25/ |

## Cheat sheets

The OWASP Cheat Sheet Series is the fastest route from "what is the correct control here" to a concrete answer. Index: https://cheatsheetseries.owasp.org/

The ones worth knowing by name:

- **Authentication**, **Session Management**, **Password Storage**
- **Authorization**, **Access Control.** For object-level checks
- **SQL Injection Prevention**, **Query Parameterization**
- **Input Validation**, **Deserialization**
- **Cross-Site Request Forgery Prevention**
- **Cross-Site Scripting Prevention**, **Content Security Policy**
- **Server-Side Request Forgery Prevention**
- **File Upload**
- **Secrets Management**
- **Logging**, **Error Handling**
- **Transport Layer Security**

## Advisories and versions

| Source | Use for | URL |
|---|---|---|
| GitHub Advisory Database | Whether a specific dependency version is vulnerable | https://github.com/advisories |
| NVD | CVE detail and CVSS scoring | https://nvd.nist.gov/ |
| OSV | Cross-ecosystem vulnerability lookup by package | https://osv.dev/ |

## How to use this file

1. **Before naming a category**, fetch the current list. Category names and rankings change between revisions, and citing a stale one undermines an otherwise correct finding.
2. **Before recommending a control**, check the relevant cheat sheet. The recommended approach for password storage, token binding, and CSRF has all changed within recent memory.
3. **Before calling a dependency vulnerable**, look it up. "This package has had CVEs" is not a finding; "version 4.2.1, which this repo pins, is affected by GHSA-xxxx" is.
4. **Prefer the repo's own playbooks** where they exist. This file is the general canon; a stack-specific playbook in the consuming repo is more specific and wins.

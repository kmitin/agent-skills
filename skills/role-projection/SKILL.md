---
name: role-projection
description: >-
  Use when the user gives a target role and a city (optionally a job posting, as
  text or a public URL) and wants to see how their real experience maps onto that
  role. Produces one markdown document with two sections: an openly FICTIONAL
  mirror persona, a person who grew up in that city, presented as a CV with a
  section on how they operate; and a REAL PROJECTION of the user's own record,
  with lead-with items each cited to their profile file, a gap list, and at most
  three questions. Never invents facts about the user, never creates accounts,
  and never applies or submits anything.
---

# Role projection

Behaviour is specified in `role-projection.feature`, next to this file. The
scenarios are the contract; this file implements them and adds nothing they do
not describe. If the two ever disagree, the feature wins.

## Why this exists

Fabricated-persona hiring fraud works by inventing a candidate to fit the
posting. This skill does the honest inverse. The mirror shows what an ideal
candidate for the role looks like, openly fictional. The real projection shows
how the user's own record maps onto it. Whatever does not map goes on the gap
list instead of being covered up.

## Inputs

**Ask once, up front, never wait.** Once the role and city are known, ask in a
single round only what the user has not already stated:

1. Which file is the source of truth for your real record?
2. How old should the mirror persona be?
3. Is there a posting to use?

Ask nothing further before compiling. An answer that is missing or unusable
falls back to a default, and is raised again in the document's questions list:

| input | missing or unusable answer | fallback |
|---|---|---|
| profile file | none, or "another file" with no path given | the default record structure, every field a gap |
| persona age | none | about 30 |
| posting | none, or unreadable | no posting |

- **Target role and city.** The one thing the skill cannot run without; ask if
  missing.
- **Persona age.** The document states the age, and the birth year every date
  is measured from.
- **Posting** (optional). Pasted text, or a URL readable without signing in;
  record the URL and read date. If the posting is behind a sign-in, do not
  read it and never offer to authenticate. Compile without it, and ask for the
  text in the questions list.
- **Profile file.** The user names one file in their workspace as the source of
  truth for their record. It is the **only** source for the real projection,
  and this skill never modifies it.
  **A missing profile never blocks.** If the user names none and none can be
  found, do not stop. Build the mirror in full, state in the real projection
  that no profile was available, list every field of the default record
  structure as a gap, and make the first question ask for the profile's path,
  offering that structure as its shape.
- **Default record structure**: the shape of a working CV, without its content.
  Use it to measure a record, never as a source of facts. In order:
  - **headline**: the roles the person is known for, separated by " | ";
  - **summary**: a few short paragraphs: years, domains, what they build;
  - **technical skills**, grouped by category: languages, data, frameworks,
    storage, cloud, operations;
  - **professional highlights**: the handful of results worth reading first;
  - **experience**: per position: title at employer, city,
    `MM.YYYY – MM.YYYY`, core technologies, project, bullets;
  - **education**: degree, field, institution, country, date;
  - **certification**: name and issuer.

  It holds no contact details, photo, or links. When a profile lacks one of
  these sections, list that section in the gaps under its name.
- **Pasted CV or LinkedIn text** may be read, but is never stored and never
  cited. A fact in it that would close a gap becomes the question "add this to
  your profile file?".

## Output

One markdown file, with every section in it:

- `role-projections/<company>-<role>.md` when a posting was used;
- `role-projections/<city>-<role>.md` when none was;
- or a directory the user names.

Substitute real values in the name. If the posting does not name the company or
the role, name the file by city and the target role instead. If the file already
exists, show the change as a diff and overwrite nothing until the user approves.
Mark the document `draft`.

### Document shape, in order

1. **Header.** State that the mirror persona is **FICTIONAL**: a mirror for
   self-presentation, not a CV. Give the target role and city, and the posting's
   source and read date, or that no posting was used.
2. **MIRROR PERSONA.** Repeat the FICTIONAL marking at its start.
   - A fictional name, never the user's. No contact detail, photo, profile
     link, or account handle.
   - A city only: no street, postcode, or residential address.
   - Employers, clients, universities, and certification issuers are described
     generically ("a payments scale-up", "a technical university"), never as a
     real, named organisation.
   - A person who grew up in the city, presented as a CV, in this order:
     - **headline**: the role, in one line;
     - **introduction**: a short introductory word in the persona's own voice;
     - **work experience**: title, generic employer, city,
       `MM.YYYY – MM.YYYY`, stack, and a few lines of what they did;
     - **projects**: what was built, and its outcome;
     - **education**: the path through the local education system;
     - **side activities**: volunteering, student life, side jobs, community;
     - **languages**, and how well each is spoken.
   - **How this person operates**, after the CV: how they behave in an
     interview, a disagreement, a salary conversation, and when giving
     feedback. For each, how a staff-level interviewer reads it, and what in
     the persona's path it traces to. Never nationality alone.
3. **REAL PROJECTION**
   - A headline and intro built only from the profile file. Add no
     self-assessing adjective ("expert", "seasoned", "proven") that the profile
     does not state, and copy no wording from the mirror.
   - **Lead with:** real projects and skills, each citing the profile section
     it came from.
   - **Gaps:** posting requirements, and mirror fields, that the record does
     not support.
   - **Questions**: at most three, the ones whose answers change the most,
     whichever rule raised them. Every other unknown goes in the gap list.

No template placeholder, angle-bracket token, or "TBD" survives into the file.
Every mirror value is a concrete fictional value. Every real value comes from the
posting or the profile file. Where a real value cannot be filled, its place holds
a question stated in full, repeated in the questions list.

## Rules while compiling

**Date check, both sections.** No technology appears in a role dated before its
first public release. If the release year cannot be established, leave the
technology out of the mirror. If the profile dates a technology before it
existed, do not use the claim; raise a question naming the conflict.

**The persona's life is variable, and checked.**
- The number of positions follows a realistic path to the target seniority at
  the persona's age. Fix no count and no tenure length. Tenures differ, and a
  side engagement may overlap employment.
- Education and side activities follow the local system of the city's country,
  and are things people who grew up there actually do, not national
  stereotypes.
- Every milestone falls at a plausible age. No position starts before the
  education preceding it could have ended.
- A local custom or requirement that existed only for some years appears only
  if the persona was the right age during them. Leave out any custom you
  cannot verify. A wrong cultural detail breaks the mirror faster than a wrong
  technology.

**Real projection: cite it or list it as a gap.**
- The reason a lead-with item fits refers only to the posting or the role as
  named. Never assert anything about the job market or hiring trends.
- Requirement stated in the profile → lead with it, with a citation.
- Requirement not stated → gap list. It stays out of the headline, intro, and
  lead-with section.
- **Adjacency is not evidence.** Do not claim a skill because it usually
  accompanies one the user has. List it as a gap, and ask whether the
  experience exists.
- **Partly supported** → cite the supported part exactly as stated, adding no
  duration or setting. The rest is a gap, and a question.
- **No inflated title.** Claim no title the profile does not state; the title
  requirement is a gap. Cited evidence of scope at that level may lead, if it
  exists.
- Take employers, titles, dates, degrees, skills, projects, outcomes, and
  numbers only from the profile.
- If two profile sections disagree, use neither value; ask a question naming
  both.
- If the profile is too thin for a headline, the headline section holds
  questions, never a placeholder draft.

**Keep the sections separate.** Nothing moves from the mirror into the real
projection: no fact, no wording, no citation. A mirror field the record does not
support appears only in the gap list. Decline to present the mirror's history as
the user's own, and decline to produce the real projection under any other
identity. A stretched claim the user asks for becomes a gap with the question
"what evidence supports this?", and enters only once that evidence is in the
profile file.

Across postings, real projections describe the same person with the same facts.
They differ only in which facts lead and which requirements are gaps.

## Hard limits

- Never create, edit, or sign in to an account or profile on any external
  service.
- Never submit an application or send a message. Applying is the user's act.
- Never modify the profile file. A gap closed in conversation is recorded as an
  answered question, for the user to carry into their profile.

## Characteristic failures

1. **Leakage from the mirror into the real projection.** The mirror is written
   first and reads fluently, so it is the nearest material to hand when drafting
   the real headline. A leaked fact looks exactly like a real one. Any line in
   the real section without a profile citation is the tell.
2. **Inference from adjacency.** A skill that nearly always accompanies one the
   user has is the most tempting claim to add. That association is exactly why
   it has to be a question.
3. **The mirror drifting toward a usable identity:** a real employer name, a
   street, a contact line. Each one moves the document from mirror toward
   fabricated persona, which is what this skill exists to be the inverse of.

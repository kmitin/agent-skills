# Behaviour specification for the role-projection skill.
#
# This file is the contract. SKILL.md implements it and does not extend it.
#
# Two sections, one document: an openly FICTIONAL mirror persona of the ideal
# candidate for a role, and a REAL PROJECTION of the user's own record onto the
# same role. Every real claim cites the user's profile file; everything
# unsupported is a gap; nothing crosses from the mirror into the real section.
#
# Placeholders in angle brackets (<technology>, <adjacent skill>, <title>, ...)
# stand for any value. The rules are stack-neutral.

Feature: Role projection

  As the user considering a specific position
  I want an openly fictional ideal candidate beside my real experience, mapped onto the same role
  So that I lead with what is true and relevant, and see plainly what is missing

  Background:
    Given the profile file the user named is the source of truth
    And nothing else is a source of truth for the real projection
    And the skill only proposes files for the user to review

  Rule: The skill is given a role and a city, and optionally a posting

    Scenario: A role and a city without a posting
      Given the user supplies a target role and a city
      And supplies no posting
      When the skill compiles the document
      Then the mirror persona is built for that role and city
      And the real projection is mapped onto the same role
      And the document records that no posting was used

    Scenario: A role and a city with a posting
      Given the user supplies a target role, a city, and a posting
      When the skill compiles the document
      Then both sections are built against the posting's requirements

  Rule: The mirror persona is openly fictional and identifies no real person or company

    Scenario: The document header marks the mirror as fictional
      When the skill compiles the document
      Then the file header states the mirror persona is FICTIONAL
      And states it is a mirror for self-presentation, not a CV
      And the mirror section repeats the FICTIONAL marking at its start

    Scenario: The mirror never carries the user's identity
      When the skill builds the mirror persona
      Then its name is a fictional name that is not the user's name
      And it carries no contact detail, photo, profile link, or account handle

    Scenario: The mirror is located by city only
      When the skill builds the mirror persona
      Then its location is a city
      And no street, postcode, or residential address appears

    Scenario Outline: No real organisation appears in the mirror
      When the skill builds the mirror persona
      Then every <entity> is described generically
      And no real, named <entity> appears

      Examples:
        | entity                  |
        | employer                |
        | client                  |
        | university or school    |
        | certification issuer    |
      # "A Dutch bank, in-house IT", "a payments scale-up", "an MSc CS from a
      # Dutch technical university" — never a name a reader could look up.

    Scenario: The mirror has a fixed shape per role
      When the skill builds the mirror persona
      Then it has a headline and a short intro
      And for each role in its history it states
        | field                                             |
        | years                                             |
        | stack                                             |
        | two or three responsibilities                     |
        | a signature project with an outcome               |
        | one line on what this signals to a staff interviewer |

  Rule: Every technology passes the date check

    Scenario Outline: A technology is dated before it existed
      Given a role in <section> is dated <year>
      And <technology> was first publicly released after <year>
      When the skill compiles the document
      Then <technology> does not appear in that role

      Examples:
        | section            |
        | the mirror persona |
        | the real projection |

    Scenario: A technology's release year cannot be established
      Given the skill cannot establish when <technology> was first released
      When the skill builds the mirror persona
      Then <technology> is left out of the mirror

    Scenario: The profile file dates a technology before it existed
      Given the profile file places <technology> in a year before its first release
      When the skill assembles the real projection
      Then the claim is not used
      And it is recorded as a question naming the conflict

  Rule: The real projection never imports anything from the mirror

    Scenario: A mirror fact is absent from the profile file
      Given the mirror persona states <fact>
      And the profile file does not state <fact>
      When the skill assembles the real projection
      Then <fact> does not appear in the real projection's headline, intro, or lead-with section
      And it appears in the gap list as a field the mirror fills and the record does not yet support

    Scenario: A mirror phrase is reused as the user's
      When the skill drafts the real projection's headline and intro
      Then no wording is copied from the mirror
      And every factual element traces to the profile file

    Scenario: Nothing in the real projection cites the mirror
      When the skill completes the real projection
      Then every citation points at the profile file
      And none points at the mirror persona

  Rule: Every claim in the real projection cites the profile file

    Scenario Outline: A claim is supported by the profile
      Given a posting requires <requirement>
      And the profile file states <requirement>
      When the skill assembles the projection
      Then the claim appears in the lead-with section
      And it cites the profile file section it came from

      Examples:
        | requirement              |
        | a primary language       |
        | a role or level of scope |
        | a shipped project        |

    Scenario: The user supplies CV or LinkedIn text in the session
      Given the user pastes CV or LinkedIn text
      When the skill assembles the projection
      Then the pasted text is not stored in the repository
      And nothing in the projection cites it
      And each fact from it that would close a gap is listed as a question: "add this to your profile file?"
      # A fact enters a projection only once the user has carried it into
      # the profile file, where every citation can resolve.

    Scenario: A composed headline or intro contains only cited facts
      When the skill drafts the tailored headline and intro
      Then every factual element of them traces to the profile file
      And no adjective of self-assessment is added that the profile does not state
      # "Expert", "seasoned", "proven" are claims. If the profile does not say
      # it, the headline does not say it.

  Rule: An unsupported requirement goes to the gap list, never into the profile

    Scenario: A requirement has no supporting evidence
      Given a posting requires <technology>
      And the profile file does not mention <technology>
      When the skill assembles the projection
      Then the requirement appears in the gap list
      And it does not appear in the headline, intro, or lead-with section

    Scenario: Adjacency is not evidence
      Given a posting requires <adjacent skill>
      And the profile file states <skill> but not <adjacent skill>
      And <adjacent skill> is commonly used alongside <skill>
      When the skill assembles the projection
      Then <adjacent skill> is not claimed on the grounds of that association
      And the requirement appears in the gap list
      And the skill asks the user whether experience with <adjacent skill> exists

    Scenario: A requirement is partly supported
      Given a posting requires <duration> of <technology> in <setting>
      And the profile file states <technology> without duration or setting
      When the skill assembles the projection
      Then the supported part is cited as stated, with no duration or setting added
      And the unsupported part appears in the gap list
      And the skill asks the user for the duration and setting

    Scenario: Seniority is not inflated to match the posting
      Given a posting is for <title>
      And the profile file does not state <title> or an equivalent
      When the skill assembles the projection
      Then no title is claimed that the profile does not state
      And the title requirement appears in the gap list
      And the skill may lead with cited evidence of scope at that level, if any exists

  Rule: The skill never invents employers, titles, dates, degrees, skills, or projects

    Scenario Outline: A fact of this kind is absent from the profile
      Given the posting asks for <fact>
      And the profile file does not state <fact>
      When the skill assembles the projection
      Then no value for <fact> appears anywhere in the real projection
      And the absence is recorded as a gap or a question

      Examples:
        | fact                         |
        | an employer name             |
        | a job title                  |
        | employment dates             |
        | a degree or certification    |
        | a skill or technology        |
        | a project or its outcome     |
        | a metric or number           |

    Scenario: The profile contradicts itself
      Given two sections of the profile file disagree on a fact
      When the skill assembles the projection
      Then it uses neither value in the headline, intro, or lead-with section
      And it records the contradiction as a question naming both sections

    Scenario: Substance is missing
      Given the profile file is too thin to support a headline for this posting
      When the skill assembles the projection
      Then the headline section contains questions for the user
      And it contains no placeholder draft
      # A plausible draft anchors what follows; a question does not.

  Rule: The real projection carries only the user's real identity

    Scenario: The user asks for a different identity in the real projection
      When the user asks for the real projection under a different name, nationality, location, photo, or contact detail
      Then the skill declines that part of the request
      And it produces the real projection under the user's real identity only
      # The mirror persona is the only fictional identity the skill produces,
      # and it never stands in for the user.

    Scenario: The user asks for mirror facts to be merged into the real projection
      When the user asks for the mirror persona's history to be presented as their own
      Then the skill declines
      And the mirror facts remain in the gap list

    Scenario: The user asks for a stretched claim
      When the user asks the skill to state a skill or title the profile does not support
      Then the skill does not add it to the projection
      And it records the request as a gap with the question "what evidence supports this?"
      And the claim enters the projection only once the user has added that evidence to the profile

    Scenario: Several projections exist for different postings
      Given projections exist for two different postings
      Then both real projections describe the same person with the same facts
      And they differ only in which facts lead and which requirements are gaps
      # Projection selects and orders; it never varies the facts.

  Rule: The skill never acts on an external service

    Scenario: The posting is supplied as text
      Given the user pastes the posting text
      When the skill assembles the projection
      Then it contacts no external service

    Scenario: The posting is a public URL
      Given the user supplies a URL readable without signing in
      When the skill reads the posting
      Then it reads it without credentials
      And it records the URL and the date it was read

    Scenario: The posting sits behind a sign-in
      Given the user supplies a URL that requires signing in to read
      When the skill attempts to read the posting
      Then it stops that step
      And it asks the user to paste the posting text
      And it does not offer to authenticate

    Scenario: The job is done
      When the projection is complete
      Then the skill has created no account or profile on any external service
      And it has edited no external profile
      And it has submitted no application and sent no message
      And applying remains the user's act

  Rule: A projection is proposed, never silently written

    Scenario: A projection is produced
      When the skill completes a projection
      Then it lands as an ordinary file under "role-projections/<company>-<role>.md" when a posting was used
      And under "role-projections/<city>-<role>.md" when none was
      And it is marked as a draft
      And it is reviewable in a diff

    Scenario: A projection for the same posting already exists
      Given a projection file for this company and role exists
      When the skill produces a new projection
      Then it presents the change as a diff
      And it overwrites nothing until the user approves

    Scenario: The source of truth is never modified
      When the skill produces a projection
      Then the profile file is unchanged
      # A gap closed in conversation is recorded as a question answered, for
      # the user to carry into the profile themselves.

  Rule: A projection has a fixed shape

    Scenario: The sections of a projection
      When the skill completes a projection
      Then it contains a header marking the mirror persona FICTIONAL
      And the target role, the city, and the posting's source and read date, or that no posting was used
      And a MIRROR PERSONA section
      And a REAL PROJECTION section, after the mirror, containing
        | part                                                                      |
        | a tailored headline and intro built only from the profile file        |
        | a lead-with section of real projects and skills, each cited               |
        | a gap list of requirements and mirror fields the record does not support |
        | a list of questions for the user                                      |

    Scenario: A projection is compiled into one document
      When the skill completes a projection
      Then every section is in a single markdown file
      And nothing needed to read the projection lives in another file

    Scenario: No placeholder survives into the final document
      When the skill completes a projection
      Then the file name has the real company or city, and the role, substituted
      And no template placeholder, angle-bracket token, or "TBD" remains in the file
      And every value in the real projection is taken from the posting or the profile file
      And every value in the mirror persona is a concrete fictional value, never a token

    Scenario: A value cannot be filled
      Given a value the real projection needs is in neither the posting nor the profile file
      When the skill compiles the projection
      Then that value's place holds a question to the user, stated in full
      And the question also appears in the questions list
      # A placeholder token and an invented value are the same failure in two
      # forms; a question is the only admissible stand-in.

    Scenario: The posting does not name the company or the role
      Given the company or the role cannot be read from the posting
      When the skill is about to name the file
      Then it asks the user for the missing name
      And it does not write the file until the name is supplied

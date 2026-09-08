# GILDCO Meeting Notes Processor

Process and structure meeting notes for: $ARGUMENTS

## Input
Raw meeting notes, voice memo transcript, or bullet points about a client meeting.

## Process
1. Read the raw input from $ARGUMENTS
2. Organize into structured format
3. Extract actionable items
4. Update client pipeline status recommendation

## Output Format
Save to `meetings/{client-name}-{date}.md`:

### Meeting Summary
- Client: [name]
- Date: [date]
- Attendees: [who was there]
- Pipeline phase: Contactado / Reunión agendada / Ya tuvimos la reunión / En proceso / Recibido
- 2-3 sentence summary

### Key Discussion Points
- Bullet points of main topics discussed

### Client Pain Points Identified
- Map each to GILDCO's 5-phase model where applicable

### Action Items
| Action | Owner | Deadline |
|--------|-------|----------|
| ...    | ...   | ...      |

### Next Steps
- Recommended next action with client
- Pipeline phase recommendation (should it move?)
- Follow-up date

### Internal Notes
- Anything relevant for GILDCO strategy (budget signals, decision timeline, competitors mentioned)

## Language
Spanish, professional internal document

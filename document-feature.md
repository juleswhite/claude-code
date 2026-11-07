---
description: Generate developer and user documentation for one feature
argument-hint: <feature-name>
---

Document the feature: $ARGUMENTS

If no feature name was given, stop and ask for one.

## 1. Find the feature's code
- Search the project for code related to "$ARGUMENTS" (function names, comments,
  file names, instrument commands). Do not read every file.
- A single file may contain many features. Identify the specific
  functions that implement this feature, plus the helpers they call.
- List the files and functions you selected. If nothing matches, or the match is
  ambiguous, stop and ask me before writing anything.

## 2. Classify the feature
Decide which layer it belongs to and say why:
- Instrument layer – talks to hardware (GPIB/serial commands, drivers).
  Emphasize: instrument settings, command sequence, timing, error handling,
  hardware limits.
- Analysis layer – processes data into results.
  Emphasize: equations, units, sign conventions, assumptions, validation.
- Operator layer – what a person runs during a measurement (scripts, panels,
  config files). Emphasize: setup, procedure, expected results, troubleshooting.
- End-to-end – crosses several layers. Emphasize: how the parts connect, plus
  a full operator procedure.

## 3. Match existing style
Look in docs/ for existing documentation and follow its structure and tone.
If none exists, use the default sections below.

## 4. Write the developer doc
File: docs/dev/<feature-name>-implementation.md
Default sections: Overview, Layer, Files and functions (with signatures),
How it works, Parameters and units, Error handling, Limitations, Related docs.

## 5. Write the user doc
File: docs/user/how-to-<task>.md
The "user" may be another programmer calling this code or an operator at the
bench. Write for whichever fits the layer.
Default sections: What this does, Before you start, Steps (numbered),
Example (code or command), Expected result, Troubleshooting, Related docs.
Where a visual would help (screenshot, front-panel photo, wiring diagram, plot),
insert a placeholder:
![Description of what the figure must show](images/<feature>-<n>.png)
<!-- TODO: capture this figure -->

## 6. Link everything
- Near the top of each doc, add a relative link to the other one.
- Under "Related docs", link any existing docs in docs/ that cover functions or
  instruments this feature uses.

## 7. Accuracy rules
- Base every statement on the code or its comments. Do not guess units, sign
  conventions, or what an instrument command does.
- Mark anything uncertain as `<!-- TODO: verify ... -->`.

## 8. Report
Finish with: files created, functions covered, layer detected, and a list of
open TODOs.








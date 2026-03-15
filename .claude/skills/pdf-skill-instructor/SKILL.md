---
name: pdf-skill-instructor
description: Reads the PDF file and extracts the content specified by the arguments, in order to create a Claude Code skill. 
argument_hint: [pdf-path] [pages-range] [skill-name] [skill-description] [claude-code-scope]
---

# PDF Skill Instructor

- Read precisely through the PDF file, on the path $PDF_PATH, in range of $PAGES_RANGE
- Create a Claude Code skill by the name of $SKILL_NAME with the description of $SKILL_DESCRIPTION
- The newly created skill can be used by the Claude Code in the scope of $CLAUDE_CODE_SCOPE.

## Read through the document

- Read the text inside the PDF file on the path $PDF_PATH, from the begining to the end of the $PAGES_RANGE.
- In case the $PAGES_RANGE carries the name of the chapter, read that chapter from the begining to the end.
- Focus primarily on text. Do not focus on pictures, unless they are representing data that is relevant to the text that you are reading. This exception specificaly applies to graphs and algorithms.
- To read the text inside PDF make sure that you are using proven software tools.

## Persist the text

- Durring the read of the relevant text, save the text on the fly.
- The text will be saved under the skill $SKILL_NAME being created in the $CLAUDE_CODE_SCOPE scope folder structure.

## Create the skill

- Once the text is read, proceed with compacting it, in order to derive the skill named $SKILL_NAME from it.
- Save the Claude Code SKILL.md in the $CLAUDE_CODE_SCOPE scope folder structure.
- Make sure you do not compact too much of the content when transfering from text files to SKILL.md in order not to loose any valuable information.

### The new skill $SKILL_NAME

- The skill being created must NOT:
  * assume any knowledge outside of the scope of the PDF that was read.
  * ever invent, extrapolate, borrow from other sources, or derive knowledge from unlisted websites, community interpretations, or any other material
- The skill being created must:
  * be factual in it's response
  * list a quote from the book, with a reference to a chapter and a subtitle the quote belongs to
  * have indifferent tone in it's responses

## Extend the existing skill

In case there is already skill named $SKILL_NAME, check if the $PDF_PATH was already used to build $SKILL_NAME. If it was, compare the previously created conversion and see if there is anything missing in the text files.

If this is a new file than treat it as additional valid source for training this skill:
- follow the same instructions from the 'Read through the document' and 'Persist the text'
- extend this skill with any additional content found in the newly read PDF

In any case, if this is extending request, ignore the scope of the $CLAUDE_CODE_SCOPE and add any new content to already existing folder structure, without creating new folders.

## Test the skill

* When the new skill is created or extended, propose the short prompt, not bigger than 2 sentences in order to test it.
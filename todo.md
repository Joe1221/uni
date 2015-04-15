# General ToDo-List

## Common

- Reimplement Theorems using `\DeclareDocumentEnvironment` or even using Coffins (fixes `]` inside theorem title).
- Figure out a good way for referencing (or just marking) exercises with `\Exercise` (index too?)
- <del>Revise `\coursetimestamp{}{}{}` syntax and usage</del>
- What about `\fixme` notation, showing on the margin, or even with an index?
- Reference `\ref{4.7}[b]` for subitems
- Find some better notation for arrows (injective, bijectiv, `\leadsto`, left/right, …)

### Minor Cosmetics

- Find a solution for `:=` colon not being centered (define `:` as active char?), but not breaking anything else
- Prevent word wrap in references (e.g. `\ref{18.4-6}` having `6` on a new line)
- `\R` symbol is above baseline, why?
- Use nicer bullets for second order `itemize`-environment (currently dashes)

### Titlepage

- Add field for lecturer/docent
- Add field for semester/time, maybe below institute?
- <del>Include timestamps for last change date</del>
- Include recent git history (filtered for current course)

### Index

- Figure out dotfill style with xindy

## Exercise Class

- rewrite `myexercise` class
- use xtemplate?

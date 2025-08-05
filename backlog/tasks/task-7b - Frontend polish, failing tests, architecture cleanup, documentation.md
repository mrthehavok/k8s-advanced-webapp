id: task-7b
title: "Frontend polish, fix tests, cleanup, docs"
status: "To Do"
depends_on: ["task-7a"]
created: 2025-08-05
updated: 2025-08-05

## Description

Address outstanding quality items after task-7a:

1. Fix failing unit tests .
2. Redesign frontend: display note content, improved styling, propose extra features (edit notes, search filter, dark mode).
3. Architecture hygiene: remove obsolete configs/manifests, tidy charts and Terraform.
4. Update all documentation: First deploy, design decisions, README.

## Acceptance Criteria

- [ ] All frontend tests pass in CI.
- [ ] Notes list shows title and content; refreshed UI with responsive design.
- [ ] At least two new UX features implemented and documented.
- [ ] Obsolete manifests/config removed; repo lint passes.
- [ ] Documentation updated with new setup and features.
- [ ] All work committed on branch `feat/task-7b-frontend-polish` and PR references task-7b.

## Session History

<!-- Update as work progresses -->

## Decisions Made

<!-- Document key implementation decisions -->

## Files Modified

<!-- Track all file changes -->

## Blockers

<!-- Document any blockers encountered -->

## Next Steps

<!-- Maintain continuity between sessions -->

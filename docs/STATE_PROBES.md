# Protected-choice state investigation

## What the current diagnostics log

The read-only `UI/SmartTurnTimerDiagnostics.lua` now logs:

- current local-player technology and civic research IDs;
- counts of entries for which `CanResearch(index)` / `CanProgress(index)` return true, if those methods work in the UI context;
- player pantheon and founded religion identifiers;
- state changes on the supported local-turn and research/civic events.

All API calls are protected so an absent method or unusable signature is reported as **unknown**, not treated as a blocker. The probe does not issue game actions or replace the timer.

## What the values cannot prove

- `GetResearchingTech() == -1` or `GetProgressingCivic() == -1` **does not by itself prove** that the player has an actionable pending choice.
- A count from `CanResearch` or `CanProgress` only hints at eligible options. It must be checked against the actual in-game choice prompt and the local player's state, including boosts, queued research and completion of all available entries.
- `GetPantheon()` and `GetReligionTypeCreated()` do not identify whether a pantheon/religion founding choice or belief picker is currently displayed or required.
- The presence of an event doesn't guarantee it fires for every kind of selection.
- This probe is local-client diagnostics only. There is no multiplayer synchronization or timer interception.

## Repeatable test cases

Use a disposable single-player game, with the new mod files installed. Inspect `Lua.log` for `[Civ6SmartTurnTimer] Snapshot`.

1. On the first turn, before selecting a technology and civic, record the snapshot and note whether the UI prompts for a choice.
2. Select a technology, then a civic. Record logs after each action and the next turn. Distinguish real event output from a snapshot only produced at turn start.
3. When faith first permits founding a pantheon, record state before and after selection, ideally with screenshots of the choice dialog.
4. At religion founding and when selecting an additional belief, capture the UI state and logs. The IDs are not sufficient on their own.
5. At the end of a tree / with no available technology or civic, verify that there is no false positive.
6. Recheck with the actual multiplayer configuration after we have a reliable local detector.

Keep the original time limit setting unchanged. The diagnostic mod cannot prevent a turn expiring.

## Validation requirement

A protected-choice detector can only become a turn-blocking condition after its output is compared with the UI across positive and negative tests. Fail open when state cannot be established (or provide an explicit safe fallback) rather than creating an unrecoverable multiplayer turn.

## Steam manual test: 2026-10-25

The third supplied Lua log confirms the state probe is loaded and event handlers are registered. Local player 0: current tech `-1`, 5 researchable of 77 checked; current civic `0`, 1 progressable of 61 checked; pantheon `-1`, founded religion `-1`. This is **not yet** a verified mandatory-choice detection result: the corresponding UI prompts were not captured.

The log contains repeated `CivicChanged` events without an observed change in snapshot. Suppress unchanged snapshots to avoid high-volume logging. The log also shows an earlier diagnostic script version running before the new probe, likely due to same-session reload; use a fresh process for a controlled baseline when necessary.

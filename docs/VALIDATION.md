# Manual validation matrix

Record the Civ VI version/build, Steam or Epic distribution, enabled DLC, mod list, player count, mode and Lua log excerpt for each test. Start in a disposable single-player game.

| Scenario | Expected future behavior | Current prototype |
| --- | --- | --- |
| Timer expires; no outstanding choices | Turn ends normally | No change to timer |
| Technology selection required and available | Hold only affected player's turn | Read-only state probe |
| Civic selection required and available | Hold only affected player's turn | Read-only state probe |
| Pantheon earned and unselected | Hold only affected player's turn | IDs only; not a decision detector |
| Pantheon not yet available | Do not hold | IDs only |
| Religion founding in progress | Hold until required selections are resolved | IDs only |
| Apostle provides a new belief selection | Hold only while selection is actionable | Not detected |
| No remaining research/civics | Do not hold | Eligible-option count probe |
| Last protected decision completed after timeout | End affected player's turn if supported | Not implemented |
| Player clicks End Turn before timeout | Preserve normal manual behavior | No change to timer |
| Two players, only one with a pending selection | Do not block unrelated player | Not tested |
| Multiplayer reconnection / host migration | No timer deadlock or desync | Not tested |
| Steam/Epic multiplayer and mod matching | Same mod/version loaded and stable | Not tested |

## Diagnostic smoke test

1. Enable the mod and enter a disposable single-player game.
2. Look for `[Civ6SmartTurnTimer] Research state probe loaded` in `Lua.log`.
3. Inspect `Snapshot (load)`, choose research, advance a turn and compare subsequent snapshots.
4. If the marker is absent, inspect `Modding.log` and `Database.log`. The UI context is declared through the matching XML file.
5. Verify that enabling the mod **does not alter** a game's turn timer.
6. Follow [state probe scenarios](STATE_PROBES.md) and capture negative cases before implementing any blockers.
7. Repeat with an identical mod/DLC set in multiplayer only once local detection is reliable.

The earlier test log confirmed the original Lua module loaded and `LocalPlayerTurnBegin` fired. The new research-state probe has **not** been tested in the game yet.

Do not tick off protected-choice behavior until a functional implementation exists.

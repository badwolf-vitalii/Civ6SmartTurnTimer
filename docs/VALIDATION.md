# Manual validation matrix

Record the Civ VI version/build, Steam or Epic distribution, enabled DLC, mod list, player count, mode and Lua log excerpt for each test. Start in a disposable single-player game.

| Scenario | Expected future behavior | Current prototype |
| --- | --- | --- |
| Timer expires; no outstanding choices | Turn ends normally | No change to timer |
| Technology selection required and available | Hold only affected player's turn | Diagnostics only |
| Civic selection required and available | Hold only affected player's turn | Diagnostics only |
| Pantheon earned and unselected | Hold only affected player's turn | Diagnostics only |
| Pantheon not yet available | Do not hold | Diagnostics only |
| Religion founding in progress | Hold until required selections are resolved | Diagnostics only |
| Apostle provides a new belief selection | Hold only while selection is actionable | Diagnostics only |
| No remaining research/civics | Do not hold | Diagnostics only |
| Last protected decision completed after timeout | End affected player's turn if supported | Diagnostics only |
| Player clicks End Turn before timeout | Preserve normal manual behavior | No change to timer |
| Two players, only one with a pending selection | Do not block unrelated player | Not tested |
| Multiplayer reconnection / host migration | No timer deadlock or desync | Not tested |
| Steam/Epic multiplayer and mod matching | Same mod/version loaded and stable | Not tested |

## Diagnostic smoke test

1. Enable the mod and enter a single-player match.
2. Look for `[Civ6SmartTurnTimer] Read-only diagnostics loaded` in `Lua.log`.
3. Advance one turn; verify the local-player-turn event produces a snapshot if the event is supported.
4. If the marker is absent, inspect `Modding.log` and `Database.log`, and confirm that the mod is enabled in the actual game configuration.
5. The UI context must be declared through `UI/SmartTurnTimerDiagnostics.xml`; the matching Lua file is loaded by the game as the context script. The modinfo imports both files.
6. Confirm that enabling the mod **does not alter** a game's turn timer.
7. Only after single-player smoke tests succeed, repeat in a controlled multiplayer test match with identical mod and DLC sets.

The original test log contained no mod-specific marker and many unrelated-looking repeating `MainMenu.lua:1373` failures. The latter cannot be attributed to this mod without isolation testing.

Do not tick off protected-choice behavior until a separate, functional implementation exists.

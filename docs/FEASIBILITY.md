# Feasibility investigation

## Confirmed project constraints

This repository currently has no validated multiplayer-safe timer implementation. The read-only UI diagnostics only report local-player API surface hints; a reported Lua method is **not** proof of safe usage.

## Critical questions to answer from installed game scripts

1. Locate the game's timer UI and gameplay scripts, then trace the **dynamic** duration calculation and automatic timeout/end-turn path.
2. Check whether timeout is controlled by game engine code, host settings, UI state, or a replaceable Lua handler. Establish if a single player can be exempted without blocking other players.
3. Determine whether a network-safe per-player end-turn operation is exposed to mods. Avoid UI-only fake clicks and unsynchronized state changes.
4. Identify reliable, *currently actionable* selection states for:
   - required technology research;
   - required civic research;
   - available-but-unselected pantheon;
   - religion founding including identity and founding beliefs;
   - additional belief selection (including apostle actions).
5. Determine whether built-in computed dynamic duration can be accessed. If it must be re-created, label it as an approximation and characterize discrepancies.
6. Test Epic and Steam clients, DLC differences, reconnects and multiplayer desynchronization.

## Implementation gate

Do not replace the game's timer or ship auto-end behavior until both interception and a network-safe completion mechanism have been demonstrated in a real multiplayer game. Do not keep a player's turn open indefinitely if the alleged mandatory choice cannot actually be made.

## Reference sources to inspect locally

Inspect the shipped Civilization VI Lua UI files and `*.modinfo` examples from the exact installed game build. Track file names, relevant function names and build/version notes in the investigation issue. Public Lua references may be incomplete or predate DLC patches.

Tracking: [Issue #1](https://github.com/badwolf-vitalii/Civ6SmartTurnTimer/issues/1).

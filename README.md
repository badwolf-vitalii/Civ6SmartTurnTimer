# Civ6SmartTurnTimer

A research-stage Civilization VI multiplayer mod intended to protect unfinished research and religion decisions from automatic turn timeout.

> **Status: experimental diagnostic prototype.** This repository does **not** yet implement a replacement dynamic turn timer or protect players from timeout. Do not use it as a working timer mod.

## Intended behavior

The future timer should follow Civilization VI's dynamic turn duration as closely as the game's supported APIs permit. When time expires, a player with an *available and pending* technology, civic, pantheon, religion-founding or belief-selection decision should retain their turn. Once all protected decisions are resolved, the timer should request completion of that player's turn if the multiplayer API supports it. Players may still end their turns manually.

The mod must not make choices for the player, prevent a turn when no decision is available, or hold every player because another player has an outstanding choice.

## Current prototype

The included UI-only diagnostic mod prints observable local-player state and the availability of candidate Lua API methods. It deliberately **does not** change turn timers or call any end-turn operations. Its purpose is to establish the actual capabilities of the installed Civ VI version and available DLC.

### Install for manual investigation

1. Copy the `Civ6SmartTurnTimer` directory (containing `Civ6SmartTurnTimer.modinfo` and `UI`) into your Civilization VI `Mods` directory.
2. Enable **Civ6SmartTurnTimer (Diagnostics)** in Additional Content.
3. Start a disposable single-player session before attempting multiplayer tests.
4. Inspect the game's Lua logs for `[Civ6SmartTurnTimer]` messages. Enable Lua logging in your game configuration if necessary.
5. Check the [validation plan](docs/VALIDATION.md) and record observed behavior; do not assume the API supports multiplayer interception because a Lua method exists.

Installation paths and logging options can differ between Epic/Steam installations and Civ VI versions. Test compatibility rather than assuming cross-platform synchronization.

## Research constraints

- The built-in Dynamic Turn Timer's calculated time and automatic completion path have **not** been verified as script-accessible.
- Safe per-player multiplayer turn completion has **not** been proven.
- Pantheon, religion founding and apostle-related belief selection may use distinct UI/gameplay paths; none has been validated.
- The diagnostic mod must not be treated as evidence that the requested behavior works.

See [technical investigation](docs/FEASIBILITY.md) and [manual validation matrix](docs/VALIDATION.md).

## License

MIT. See [LICENSE](LICENSE).

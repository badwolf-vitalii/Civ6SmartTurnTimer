# Civ6SmartTurnTimer

A research-stage Civilization VI multiplayer mod intended to protect unfinished research and religion decisions from automatic turn timeout.

> **Status: experimental read-only diagnostics.** This repository does **not** implement a replacement dynamic timer or protect anyone from timeout yet.

## Intended behavior

The future timer should follow Civilization VI's dynamic turn duration as closely as its supported APIs permit. When time expires, a player with an *available and pending* technology, civic, pantheon, religion-founding or belief-selection decision should retain their turn. Once all protected decisions are resolved, the timer should request completion of only that player's turn, if the multiplayer API supports it. Players may still finish turns manually.

The mod must not make choices for the player, prevent a turn when no decision is actionable, or hold every player because another player has an outstanding choice.

## Current prototype

The UI-only module records local-player research/civic identifiers, eligible-option probes and religion identifiers. It deliberately **does not** change turn timers or call end-turn actions. Numeric IDs and research availability counts are diagnostic observations, not verified proof of a mandatory pending choice.

### Manual install and test

1. Download the currently developing feature branch and copy the mod folder (containing `Civ6SmartTurnTimer.modinfo` and `UI`) into your Civilization VI `Mods` directory.
2. Enable **Civ6SmartTurnTimer (Diagnostics)** under Additional Content.
3. Start a disposable single-player session.
4. Inspect `Lua.log` for `[Civ6SmartTurnTimer]` messages. Depending on the installation, the log is under `%LOCALAPPDATA%\Firaxis Games\Sid Meier's Civilization VI\Logs`.
5. Run the [research and religion tests](docs/STATE_PROBES.md) and compare actual in-game dialogs against the logs.

For changes to `.modinfo`, fully restart the game. Scripts and UI files may sometimes be hot-reloaded in a development setup, but do not rely on that for baseline tests.

## Limitations

- The built-in Dynamic Turn Timer's calculated duration and automatic completion path are not verified as script-accessible.
- Safe per-player multiplayer turn completion is not proven.
- Pending pantheon, religion founding and apostle belief choices are **not yet detected**.
- Local research/civic availability probes require validation across game builds and DLC.
- Epic/Steam compatibility and synchronization have not been tested.

See [technical investigation](docs/FEASIBILITY.md), [state probes](docs/STATE_PROBES.md) and [validation matrix](docs/VALIDATION.md).

## License

MIT. See [LICENSE](LICENSE).

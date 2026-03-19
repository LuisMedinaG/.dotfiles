# Karabiner-Elements Configuration

Keyboard customization using [karabiner.ts](https://karabiner.ts.evanliu.dev/), a TypeScript DSL that compiles to Karabiner-Elements JSON.

## Setup

1. Install [Karabiner-Elements](https://karabiner-elements.pqrs.org/) and grant the required permissions (Accessibility, Input Monitoring).
2. Install dependencies and build:
   ```sh
   npm install
   npm run build
   ```
   `build` writes directly to `~/.config/karabiner/karabiner.json` (the "Default" profile).
3. During development, auto-rebuild on save:
   ```sh
   npm run watch
   ```

## How It Works

`npm run build` runs `tsx src/index.ts`, which uses the `karabiner.ts` library to generate the full JSON config that Karabiner-Elements reads. Edit TypeScript, rebuild, and Karabiner picks up the changes automatically.

## Keybindings

### Meh Key (Caps Lock)

| Action      | Result              |
|-------------|---------------------|
| Hold        | `⌃⌥⇧` (Meh)        |
| Tap         | `⎋` (Escape)        |

### Quick Access

| Key         | App                 |
|-------------|---------------------|
| `Meh + g`   | Google Chrome       |
| `Meh + v`   | Visual Studio Code  |

### Leader Key System

Press `Meh + [category]`, then an action key. A notification shows available actions. Press `⎋`, `␣`, or `⇥` to cancel.

#### `Meh + o` — Applications

| Key | App                 |
|-----|---------------------|
| `c` | Cisco Secure Client |
| `f` | Finder              |
| `g` | Google Chrome       |
| `i` | iTerm               |
| `l` | Open WebUI          |
| `n` | Notes               |
| `o` | Obsidian            |
| `r` | Reminders           |
| `s` | Slack               |
| `v` | Visual Studio Code  |
| `w` | WhatsApp            |
| `y` | Spotify             |
| `z` | Zoom.us             |
| `,` | System Settings     |

#### `Meh + l` — Links

Defined in `src/links.json`:

| Key | URL                            |
|-----|--------------------------------|
| `x` | x.com                          |
| `i` | instagram.com                  |
| `m` | mail.google.com                |
| `l` | linkedin.com                   |
| `h` | news.ycombinator.com           |
| `g` | gemini.google.com              |

#### `Meh + r` — Raycast Extensions

| Key | Extension                      |
|-----|--------------------------------|
| `/` | Search menu items              |
| `a` | Google search all (Codely)     |
| `c` | Calendar                       |
| `f` | File search                    |
| `g` | Fix spelling/grammar (Ollama)  |
| `k` | Keyboard brightness            |
| `l` | Copy path                      |
| `m` | Reminders                      |
| `n` | Create Obsidian note           |
| `o` | OCR (Screenocr)                |
| `q` | Quick add reminder             |
| `r` | Recent VS Code projects        |
| `s` | Snippets                       |

#### `Meh + ,` — System Settings

| Key | Pane        |
|-----|-------------|
| `a` | Appearance  |
| `d` | Displays    |
| `k` | Keyboard    |
| `o` | Dock        |

#### `Meh + u` — System Utilities

| Key | Action              |
|-----|---------------------|
| `n` | Clear notifications |
| `s` | Sleep               |

## Project Structure

```
src/
  index.ts       Main config — rules and leader key definitions
  utils.ts       Helpers: Raycast, AppleScript, System Settings openers
  types.ts       Type definitions and commented-out experiments
  links.json     URL mappings for the Link leader category
package.json     Scripts and dependencies
```

## Scripts

| Command              | Description                    |
|----------------------|--------------------------------|
| `npm run build`      | Generate karabiner.json        |
| `npm run watch`      | Rebuild on file changes        |
| `npm run lint`       | ESLint                         |
| `npm run format`     | Prettier                       |
| `npm run validate`   | lint + format + build          |

## Troubleshooting

- **Permissions** — System Settings > Privacy & Security > Accessibility + Input Monitoring. Both must list Karabiner-Elements.
- **Key events** — Open Karabiner-EventViewer to see what Karabiner receives.
- **Logs** — Console.app, filter by `karabiner`.
- **Conflicts** — Check System Settings > Keyboard > Keyboard Shortcuts for collisions.

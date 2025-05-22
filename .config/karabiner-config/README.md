# Karabiner-Elements Configuration

Personal keyboard customization using [karabiner.ts](https://karabiner.ts.evanliu.dev/).

## Features

### 🎯 Hyper/Meh Keys
- **Caps Lock** → Hyper (⌘⌃⌥⇧) when held, Escape when tapped
- **Right Command** → Meh (⌃⌥⇧) when held, Escape when tapped

### 🚀 Leader Key System
Press `Hyper + [category]` followed by an action key:

- **`o` - Applications**: Quick app launcher
  - `c` → Cisco Secure Client
  - `g` → Google Chrome
  - `i` → iTerm
  - `s` → Slack
  - `v` → Visual Studio Code
  - [and more...]

- **`l` - Links**: Open frequently used websites
  - Configure in `links.json`

- **`r` - Raycast**: Access Raycast extensions
  - `c` → Calendar
  - `v` → Clipboard History
  - `f` → File Search
  - [and more...]

- **`s` - System**: Open System Settings panes
  - `a` → Appearance
  - `d` → Displays
  - `k` → Keyboard

### 🪟 Window Management
Using Raycast window management:

**Hyper + Key:**
- `u/i/o` → First/Center/Last third
- `n/m` → Left/Right half
- `↑↓←→` → Navigate displays/desktops

**Meh + Number:**
- `1-4` → Quarter positions
- `5` → Center
- `6` → Center half

## Installation

1. Install [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
2. Install dependencies:
   ```bash
   npm install
   ```

3. Build configuration:
   ```bash
   npm run build
   ```

4. Watch for changes:
   ```bash
   npm run watch
   ```

## Project Structure

```
├── index.ts       # Main configuration
├── utils.ts       # Utility functions
├── types.ts       # TypeScript type definitions
├── links.json     # Quick link mappings
├── tsconfig.json  # TypeScript configuration
├── package.json   # Dependencies and scripts
└── README.md      # This file
```

## Development

### Scripts
- `npm run build` - Generate Karabiner configuration
- `npm run watch` - Auto-rebuild on changes
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier
- `npm run validate` - Run all checks

### Adding New Features

1. **New Leader Category:**
   ```typescript
   // In createLeaderKeyRule()
   x: {
     name: 'New Category',
     mapping: {
       a: 'Action A',
       b: ['command-path', 'Display Name'],
     },
     action: yourActionFunction,
   }
   ```

2. **New Utility Function:**
   ```typescript
   // In utils.ts
   export const newUtility = (): ToEvent => {
     return to$('your-command-here');
   };
   ```

## Tips

- Press `Escape`, `Caps Lock`, or `Space` to exit leader mode
- Notifications show available actions in each category
- All AppleScripts include error handling
- Window positioning is optimized for my display setup - adjust as needed

## Troubleshooting

1. **Permissions**: Ensure Karabiner-Elements has accessibility permissions
2. **Conflicts**: Check for conflicting shortcuts in System Settings
3. **Debugging**: Check Karabiner-EventViewer for key events
4. **Errors**: Look at Karabiner-Elements logs in Console.app

## Future Enhancements

- [ ] Implement symbol layer for special characters
- [ ] Add app-specific configurations (Slack, VS Code)
- [ ] Create system control layer
- [ ] Add more Raycast extensions
- [ ] Implement double-tap modifiers

## License

MIT

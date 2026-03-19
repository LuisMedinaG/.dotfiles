# Kanata — Keyboard Remapping

[Kanata](https://github.com/jtroo/kanata) is a cross-platform keyboard remapping daemon. On macOS it runs as a LaunchDaemon (root-level service) to intercept key events system-wide.

> **Note:** Caps Lock / Hyper key is handled by [Karabiner-Elements](../karabiner-config/). Kanata only handles home-row mods and the Fn layer. They can run simultaneously without conflict since they remap different keys.

## What it does

### Home-Row Mods ([CAGS order](https://precondition.github.io/home-row-mods))

| Key | Tap | Hold |
|-----|-----|------|
| `A` | a | Left Control |
| `S` | s | Left Option |
| `D` | d | Left Command |
| `F` | f | Left Shift |
| `J` | j | Right Shift |
| `K` | k | Right Command |
| `L` | l | Right Option |
| `;` | ; | Right Control |

Timing: 150ms tap / 220ms hold threshold.

### Fn Layer

Tap `fn` for normal fn behavior. Hold `fn` to access a layer where the media keys (brightness, play/pause, volume, etc.) become actual F1–F12 keys.

## Installation

### 1. Install kanata

```sh
brew install kanata
```

### 2. Grant permissions

Go to **System Settings → Privacy & Security**:

- **Input Monitoring** → add the kanata binary (`/opt/homebrew/bin/kanata`)
- **Full Disk Access** → add the kanata binary

To find the binary path: `which kanata`

### 3. Create log directory

```sh
sudo mkdir -p /Library/Logs/Kanata
```

### 4. Install the LaunchDaemon

```sh
sudo cp ~/.config/kanata/com.lumedina.kanata.plist /Library/LaunchDaemons/
sudo launchctl load /Library/LaunchDaemons/com.lumedina.kanata.plist
sudo launchctl start io.lumedina.kanata
```

Kanata will now start automatically on boot.

## Managing the service

The easiest way is the shell function (handles first-run setup automatically):

```sh
kanata-reload          # reload config / first-time install
```

Manual commands:

```sh
# Check status
sudo launchctl list | grep kanata

# Stop
sudo launchctl stop io.lumedina.kanata

# Start
sudo launchctl start io.lumedina.kanata

# Uninstall
sudo launchctl unload /Library/LaunchDaemons/com.lumedina.kanata.plist
sudo rm /Library/LaunchDaemons/com.lumedina.kanata.plist
```

## Logs

```sh
tail -f /Library/Logs/Kanata/kanata.out.log
tail -f /Library/Logs/Kanata/kanata.err.log
```

## Troubleshooting

- **Keys not remapping** — Check permissions (Input Monitoring + Full Disk Access). Restart the service after granting.
- **F-row keys behave wrong** — Known macOS bug with fn on Apple keyboards ([#975](https://github.com/jtroo/kanata/issues/975)). Fixed in Karabiner-Elements v15.0.14.
- **Conflicts with Karabiner** — Disable one before enabling the other. Both intercept at the same level.
- **Binary path on Intel Macs** — Change `/opt/homebrew/bin/kanata` to `/usr/local/bin/kanata` in the plist.

## Files

| File | Purpose |
|------|---------|
| `kanata.kbd` | Key mappings and layer definitions |
| `com.lumedina.kanata.plist` | macOS LaunchDaemon for auto-start |

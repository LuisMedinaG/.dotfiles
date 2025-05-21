/* 
  karabiner.ts
  Documentation: https://karabiner.ts.evanliu.dev/
*/

import {
  map,
  rule,
  writeToProfile,
  hyperLayer,
  toApp,
  // toShellCommand,
} from 'karabiner.ts';

const PROFILE_NAME = 'Beta';

const hyperKeyRule = rule('Hyper Key (Caps Lock to ⌘⌥⌃⇧, Escape on tap)').manipulators([
  map('caps_lock')
    .toHyper()
    .toIfAlone('escape'),
]);

// --- App Launcher Leader Layer (Hyper + L) ---
// After releasing Hyper + L, you enter a leader mode.
const appLauncherLeaderLayer = hyperLayer(
  'l',
  'app_launcher_leader_mode'
)
  .description('App Launcher (Hyper+L, then key)')
  // By default, 'escape' and 'caps_lock' (if it's your hyper key) will cancel leader mode.
  .leaderMode()
  .notification()
  .manipulators({
    // Format: 'subsequent_key': action_to_perform
    c: toApp('Cisco Secure Client'),
    f: toApp('Finder'),
    g: toApp('Google Chrome'),
    i: toApp('iTerm2'),
    o: toApp('Obsidian'),
    l: toApp('Open WebUI'),
    s: toApp('Slack'),
    y: toApp('Spotify'),
    v: toApp('Visual Studio Code'),
    w: toApp('WhatsApp'),
    z: toApp('Zoom'),
    // Example for an app that might have a more complex name or you want to use bundle ID
    // n: toApp({ bundle_identifier: 'com.apple.Notes' }),

    // Example: A non-app action, like running a shell command
    // 'x': toShellCommand('echo "Hello from Karabiner Leader Mode" > ~/Desktop/leader_test.txt'),
  });

writeToProfile(
  PROFILE_NAME,
  [
    hyperKeyRule,
    appLauncherLeaderLayer,
  ],
  // Optional: Set parameters for complex_modifications
  {
    // 'basic.to_if_alone_timeout_milliseconds': 500, // Default is 500
    // 'basic.to_delayed_action_delay_milliseconds': 500, // Default is 500
    // 'simultaneous_threshold_milliseconds': 50, // Default is 50
    // 'leader.timeout_milliseconds': 1000, // Default timeout for leader mode (1 second)
  }
);

console.log(
  `Karabiner configuration for profile "${PROFILE_NAME}" updated successfully!`
);

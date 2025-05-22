/* 
  karabiner.ts
  Documentation: https://karabiner.ts.evanliu.dev/
  
  Based on: 
  https://github.com/evan-liu/karabiner-config/blob/main/karabiner-config.ts
*/


import {
  map,
  rule,
  writeToProfile,
  toApp,
  withModifier,
  toUnsetVar,
  toRemoveNotificationMessage,
  to$,
  ToEvent,
  withCondition,
  ifVar,
  withMapper,
  // toShellCommand,
} from 'karabiner.ts';
import { raycastExt, raycastWin, toSystemSetting } from './utils';

const hyperKeyRule = rule('Apple Keyboard').manipulators([
  // Hyper Key (Caps Lock to ⌘⌥⌃⇧, Escape on tap)
  map('caps_lock').toHyper().toIfAlone('escape'),
  map('right_command').toMeh().toIfAlone('escape'),
]);


function rule_leaderKey() {
  let _var = 'leader'
  let escapeActions = [toUnsetVar(_var), toRemoveNotificationMessage(_var)]

  // const mappings: { [key: string]: string } = {

  let mappings = {
    o: {
      name: 'App',
      mapping: {
        c: 'Cisco Secure Client',
        f: 'Finder',
        g: 'Google Chrome',
        i: 'iTerm',
        o: 'Obsidian',
        l: 'Open WebUI',
        n: 'Notes',
        s: 'Slack',
        y: 'Spotify',
        ';': 'System Settings',
        v: 'Visual Studio Code',
        w: 'WhatsApp',
        z: 'Zoom',
      },
      action: toApp,
    },
    l: {
      name: 'Link',
      mapping: require('./links.json') as { [key: string]: string[] },
      action: (x) => to$(`open ${x}`),
    },
    r: {
      name: 'Raycast',
      mapping: {
        c: ['raycast/calendar/my-schedule', 'Calendar'],
        d: ['raycast/dictionary/define-word', 'Dictionary'],
        e: ['raycast/emoji-symbols/search-emoji-symbols', 'Emoji'],
        s: ['raycast/snippets/search-snippets', 'Snippets'],
        v: ['raycast/clipboard-history/clipboard-history', 'Clipboard'],
      },
      action: raycastExt,
    },
    s: {
      name: 'SystemSetting',
      mapping: {
        a: 'Appearance',
        d: 'Displays',
        k: 'Keyboard',
        o: 'Dock',
      },
      action: toSystemSetting,
    },
  } satisfies {
    [key: string]: {
      name: string
      mapping: { [key: string]: string | string[] }
      action: (v: string) => ToEvent | ToEvent[]
    }
  }

  let keys = Object.keys(mappings) as Array<keyof typeof mappings>
  let hint = keys.map((x) => `${x}_${mappings[x].name}`).join(' ')

  return rule('Leader Key').manipulators([
    // 0: Inactive -> Leader (1)
    withCondition(ifVar(_var, 0))([
      map('k', 'Hyper')
        .toVar(_var, 1)
        .toNotificationMessage(_var, hint),
    ]),

    // 0.unless: Leader or NestedLeader -> Inactive (0)
    withCondition(ifVar(_var, 0).unless())([
      withMapper(['⎋', '␣'])((x) => map(x).to(escapeActions)),
    ]),

    // 1: Leader -> NestedLeader (🔤)
    withCondition(ifVar(_var, 1))(
      keys.map((k) => {
        let hint = Object.entries(mappings[k].mapping)
          .map(([k, v]) => `${k}_${Array.isArray(v) ? v[1] : v}`)
          .join(' ')
        return map(k).toVar(_var, k).toNotificationMessage(_var, hint)
      }),
    ),

    // 🔤: NestedLeader
    ...keys.map((nestedLeaderKey) => {
      let { mapping, action } = mappings[nestedLeaderKey]
      let actionKeys = Object.keys(mapping) as Array<keyof typeof mapping>
      return withCondition(ifVar(_var, nestedLeaderKey))(
        actionKeys.map((x) => {
          let v = Array.isArray(mapping[x]) ? mapping[x][0] : mapping[x]
          return map(x).to(action(v)).to(escapeActions)
        }),
      )
    }),
  ])
}

// After releasing Hyper + L, you enter a leader mode.
// const appLauncherLeaderLayer = hyperLayer(
//   'l',
//   'app_launcher_leader_mode'
// )
//     .description('App Launcher (Hyper+L, then key)')
//     // By default, 'escape' and 'caps_lock' (if it's your hyper key) will cancel leader mode.
//     .leaderMode()
//     .notification()
//     .manipulators({
//       // Format: 'subsequent_key': action_to_perform
//       c: toApp('Cisco Secure Client'),
//       f: toApp('Finder'),
//       g: toApp('Google Chrome'),
//       i: toApp('iTerm2'),
//       o: toApp('Obsidian'),
//       l: toApp('Open WebUI'),
//       s: toApp('Slack'),
//       y: toApp('Spotify'),
//       a: toApp('System Settings'),
//       v: toApp('Visual Studio Code'),
//       w: toApp('WhatsApp'),
//       z: toApp('Zoom'),
//       // Example for an app that might have a more complex name or you want to use bundle ID
//       // n: toApp({ bundle_identifier: 'com.apple.Notes' }),

//       // Example: A non-app action, like running a shell command
//       // 'x': toShellCommand('echo "Hello from Karabiner Leader Mode" > ~/Desktop/leader_test.txt'),
//     });
// }

function app_raycast() {
  return rule('Raycast').manipulators([
    // map('␣', '⌥').to(raycastExt('evan-liu/quick-open/index')),

    withModifier('Hyper')({
      '↑': raycastWin('previous-display'),
      '↓': raycastWin('next-display'),
      '←': raycastWin('previous-desktop'),
      '→': raycastWin('next-desktop'),
    }),
    withModifier('Hyper')({
      1: raycastWin('first-third'),
      2: raycastWin('center-third'),
      3: raycastWin('last-third'),
      4: raycastWin('first-two-thirds'),
      5: raycastWin('last-two-thirds'),
      9: raycastWin('left-half'),
      0: raycastWin('right-half'),
    }),
    withModifier('Meh')({
      1: raycastWin('first-fourth'),
      2: raycastWin('second-fourth'),
      3: raycastWin('third-fourth'),
      4: raycastWin('last-fourth'),
      5: raycastWin('center'),
      6: raycastWin('center-half'),
      7: raycastWin('center-two-thirds'),
      8: raycastWin('maximize'),
    }),
    // Dropopver
    // Calculator History
    // My Schedule
    // Clipboard History
    // Toggle Caffeinate
    // Search All
    // Toggle Keyboard Brightness
    // Toggle Next Layout
    // Search Menu Items
    // Chat with Ollama
    // Create Note
    // Raycast Notes
    // Search Notes
    // Recognize Text
    // Emmoji
    // Search files
    // Toggle Favorite Device #1
    // Search Recent Projects
    // -----
    // Spotify - like, now playing, etc
  ])
}

const PROFILE_NAME = 'Beta';

writeToProfile(
  PROFILE_NAME,
  [
    hyperKeyRule,
    // appLauncherLeaderLayer,
    rule_leaderKey(),
    app_raycast(),
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

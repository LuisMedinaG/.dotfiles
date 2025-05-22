/* karabiner.ts
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
  layer,
  toMouseCursorPosition,
  toPointingButton,
  toSleepSystem,
  toKey,
  ifApp,
  toPaste,
  simlayer,
  // toShellCommand,
} from 'karabiner.ts';
import { historyNavi, raycastExt, raycastWin, tapModifiers, toClearNotifications, toResizeWindow, toSystemSetting } from './utils';

function main() {
  writeToProfile(
    'Default',
    [
      // HyperSubLayers
      rule_leaderKey(),

      // Global Layers
      // layer_symbol(),
      // layer_system(),

      // Apps
      app_raycast(),
      // app_slack(),

      // Keyboard Remap
      hyperKeyRule(),
    ],
    // Optional: Set parameters for complex_modifications
    {
      // 'basic.to_if_alone_timeout_milliseconds': 500, // Default is 500
      // 'basic.to_delayed_action_delay_milliseconds': 500, // Default is 500
      'basic.simultaneous_threshold_milliseconds': 50,
      // 'leader.timeout_milliseconds': 1500, // Default timeout for leader mode (1 second)
    }
  );
}

// --- Hyper Key Definition ---
function hyperKeyRule() {
  return rule('Hyper/Meh Key').manipulators([
    map('caps_lock').toHyper().toIfAlone('escape'), // Command + Control + Option + Shift
    map('right_command').toMeh().toIfAlone('escape'), // Control + Option + Shift
  ]);
}

function rule_leaderKey() {
  let _var = 'leader'
  let escapeActions = [toUnsetVar(_var), toRemoveNotificationMessage(_var)]

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
          // Toggle Favorite Device #1o
          // Search Recent Projects
          // -----
          // Spotify - like, now playing, etc
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

  let categoryKeys = Object.keys(mappings) as Array<keyof typeof mappings>

  return rule('Leader Key').manipulators([
    // Part 1: Activate Leader Sub-mode (Inactive -> Category State)
    // Maps Hyper + <category_key> (e.g., Hyper + 'o') to set the
    // leader variable directly to the category key (e.g., 'o')
    // and show the relevant sub-options in the notification.
    withCondition(ifVar(_var, 0))(
      categoryKeys.map((key) => {
        const category = mappings[key];
        const categoryHint = Object.entries(category.mapping)
          .map(([subKey, subValue]) => `${subKey}_${Array.isArray(subValue) ? subValue[1] : subValue}`)
          .join(' ');
        return map(key, 'Hyper') // e.g., map('o', 'Hyper')
          .toVar(_var, key) // Sets _var to 'o', 'l', 'r', or 's'
          .toNotificationMessage(_var, `${category.name}: ${categoryHint}`);
      })
    ),

    // Part 2: Escape from any active Leader Mode (Category State -> Inactive)
    // If the leader variable is set (i.e., not 0), pressing Escape or Space
    // will unset the variable and clear the notification.
    withCondition(ifVar(_var, 0).unless())([
      withMapper(['⎋', '⇪' , '␣'])((keyToMap) => map(keyToMap).to(escapeActions)),
    ]),

    // Part 3: Execute Action in Leader Sub-mode (Category State -> Action -> Inactive)
    // This part handles the second key press after a leader sub-mode is active.
    // It iterates through each category. If the _var matches the categoryKey,
    // it maps the subKeys of that category to their respective actions.
    ...categoryKeys.map((categoryKey) => {
      const { mapping, action } = mappings[categoryKey];
      const actionSubKeys = Object.keys(mapping) as Array<keyof typeof mapping>;

      return withCondition(ifVar(_var, categoryKey))(
        actionSubKeys.map((subKey) => {
          const mappingEntry = mapping[subKey];
          // If the mapping entry is an array (like for Raycast ['path', 'DisplayName']),
          // pass the first element (the actual command path/identifier) to the action.
          // Otherwise, pass the string value directly.
          const valueToPassToAction = Array.isArray(mappingEntry)
            ? mappingEntry[0]
            : mappingEntry;

          return map(subKey as any) // `subKey as any` for type compatibility with map()
            .to(action(valueToPassToAction))
            .to(escapeActions); // Reset leader mode after executing action
        })
      );
    }),
  ]);
}


function app_raycast() {
  return rule('Raycast').manipulators([
    // Easy access to clipboard history
    // map('v', '›⌘⇧').to(raycastExt('raycast/clipboard-history/clipboard-history')),
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
      '⏎': raycastWin('maximize'),
      '`': raycastWin('almost-maximize'),
    }),
    withModifier('Meh')({
      1: raycastWin('first-fourth'),
      2: raycastWin('second-fourth'),
      3: raycastWin('third-fourth'),
      4: raycastWin('last-fourth'),
      5: raycastWin('center'),
      6: raycastWin('center-half'),
      7: raycastWin('center-two-thirds'),
    }),
  ])
}

// TODO: Not working
// function app_slack() {
//   return rule('Slack', ifApp('^com.tinyspeck.slackmacgap$')).manipulators([
//     ...historyNavi(),

//     ...tapModifiers({
//       '‹⌘': toKey('d', '⌘⇧'), // showHideSideBar
//       '‹⌥': toKey('f6'), // moveFocusToTheNextSection

//       '›⌘': toKey('.', '⌘'), // hideRightBar
//       '›⌥': toKey('k', '⌘'), // open
//     }),

//     map(1, 'Meh').to(
//       // After the 1/4 width, leave some space for opening thread in a new window
//       // before the last 1/4 width
//       toResizeWindow('Slack', { x: 1263, y: 25 }, { w: 1760, h: 1415 }),
//     ),
//   ])
// }

// TODO: Not working
// function layer_system() {
//   return layer('`', 'system').manipulators({
//     // 1: toMouseCursorPosition({ x: '25%', y: '50%', screen: 0 }),
//     // 2: toMouseCursorPosition({ x: '50%', y: '50%', screen: 0 }),
//     // 3: toMouseCursorPosition({ x: '75%', y: '50%', screen: 0 }),
//     // 4: toMouseCursorPosition({ x: '99%', y: 20, screen: 0 }),

//     // 5: toMouseCursorPosition({ x: '50%', y: '50%', screen: 1 }),

//     // '⏎': toPointingButton('button1'),

//     n: toClearNotifications,

//     '␣': toSleepSystem(),

//     j: toKey('⇥', '⌘'),
//     k: toKey('⇥', '⌘⇧'),
//   })
// }


// TODO: Not working
// function layer_symbol() {
//   return layer('z', 'symbols').manipulators([
//     withMapper(['←', '→', '↑', '↓', '␣', '⏎', '⌫', '⌦'])((k) =>
//       map(k).toPaste(k),
//     ),

//     { ',': toPaste('‹'), '.': toPaste('›') },

//     withMapper({ 4: '⇥', 5: '⎋', 6: '⌘', 7: '⌥', 8: '⌃', 9: '⇧', 0: '⇪' })(
//       (k, v) => map(k).toPaste(v),
//     ),
//   ])
// }

main()

import { ToEvent } from 'karabiner.ts';

export interface CategoryMapping {
  [categoryKey: string]: {
    name: string;
    mapping: { [subKey: string]: string | string[] };
    action: (v: string) => ToEvent | ToEvent[];
  };
}

export type CategoryMappings = Record<string, CategoryMapping>;


// ------------------------------------------------------------------------
// Functionalities not working properly
// ------------------------------------------------------------------------

// function createSlackRules() {
//   return rule('Slack', ifApp('^com\\.tinyspeck\\.slackmacgap$')).manipulators([
//     ...historyNavi(),

//     ...tapModifiers({
//       '‹⌘': toKey('d', '⌘⇧'), // showHideSideBar
//       '‹⌥': toKey('f6'), // moveFocusToTheNextSection

//       // '›⌘': toKey('.', '⌘'), // hideRightBar
//       '›⌥': toKey('k', '⌘'), // open
//     }),
//   ])
// }

// function layer_system() {
//   return simlayer('`', 'system').manipulators({
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

// function createRaycastRules() {
//   return rule('Raycast').manipulators([
//     map('v', ['command', 'shift']).to(raycastExt('raycast/clipboard-history/clipboard-history')),

//     // Yabai
//     // Navigation with Hyper + arrows
//     withModifier('Hyper')({
//       '↑': raycastWin('previous-display'),
//       '↓': raycastWin('next-display'),
//       '←': raycastWin('previous-desktop'),
//       '→': raycastWin('next-desktop'),
//     }),

//     // Window positioning with Hyper
//     withModifier('Hyper')({
//       // Thirds
//       1: raycastWin('first-third'),
//       2: raycastWin('center-third'),
//       3: raycastWin('last-third'),
//       // Two-thirds
//       4: raycastWin('first-two-thirds'),
//       5: raycastWin('top-half'),
//       6: raycastWin('bottom-half'),
//       7: raycastWin('last-two-thirds'),
//       // Halves
//       8: raycastWin('left-half'),
//       9: raycastWin('center'),
//       0: raycastWin('right-half'),
//       // Special
//       '-': raycastWin('make-smaller'),
//       '=': raycastWin('make-larger'),
//       '`': raycastWin('almost-maximize'),
//       '⏎': raycastWin('maximize'),
//       '⌫': raycastWin('restore'),
//     }),
//   ]);
// }

// function createChromeRules() {
//   return rule('Google Chrome').manipulators([
//     withModifier('Hyper')({
//       p: toPictureInPicture()
//     })
//   ]);
// }

// function createNavigationRules() {
//   return rule('Navigation Shortcuts').manipulators([
//     // History navigation (Ctrl+H/L -> Cmd+[/])
//     ...historyNavi(),

//     // Tab navigation (Opt+H/L -> Cmd+Shift+[/])
//     ...tabNavi(),

//     // App switcher (Cmd+Opt+Ctrl+H/L -> Ctrl+Shift+Tab/Ctrl+Tab)
//     ...switcher(),
//   ]);
// }

// --- Home Row Mods Definition ---
// NOTE: Better with kanata
// function createHomeRowModsRule() {
//   const fastTypingParams = {
//     'basic.to_if_alone_timeout_milliseconds': 130,        // Quick tap threshold
//     'basic.to_if_held_down_threshold_milliseconds': 140,  // Quick hold threshold - only 10ms gap!
//   };

//   return rule('Home Row Mods').manipulators([
//     // Left Hand
//     map('a').to('left_control', undefined, { lazy: true }).toIfAlone('a').parameters(fastTypingParams), // a/⌃
//     map('s').to('left_option', undefined, { lazy: true }).toIfAlone('s').parameters(fastTypingParams), // s/⌥
//     map('d').to('left_command', undefined, { lazy: true }).toIfAlone('d').parameters(fastTypingParams), // d/⌘
//     map('f').to('left_shift', undefined, { lazy: true }).toIfAlone('f').parameters(fastTypingParams), // f/⇧

//     // Right Hand
//     map('j').to('right_control', undefined, { lazy: true }).toIfAlone('j').parameters(fastTypingParams), // j/⌃
//     map('k').to('right_option', undefined, { lazy: true }).toIfAlone('k').parameters(fastTypingParams), // k/⌥
//     map('l').to('right_command', undefined, { lazy: true }).toIfAlone('l').parameters(fastTypingParams), // l/⌘
//     map('semicolon').to('right_shift', undefined, { lazy: true }).toIfAlone('semicolon').parameters(fastTypingParams), // ;/⇧
//   ]);
// }

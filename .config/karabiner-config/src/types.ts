import { ToEvent } from 'karabiner.ts';

export interface CategoryMapping {
  [categoryKey: string]: {
    name: string;
    mapping: { [subKey: string]: string | string[] };
    action: (v: string) => ToEvent | ToEvent[];
  };
}

export type CategoryMappings = Record<string, CategoryMapping>;

// TODO: Not working properly
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

// TODO: Not working
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

/* karabiner.ts Configuration
 * Based on: https://github.com/evan-liu/karabiner-config
 *
 * Documentation: https://karabiner.ts.evanliu.dev/
 * Required macOS settings: https://karabiner-elements.pqrs.org/docs/manual/misc/required-macos-settings/
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
  FromKeyParam,
} from 'karabiner.ts';

import {
  genericStaticAction,
  historyNavi,
  raycastExt,
  raycastWin,
  switcher,
  tabNavi,
  toPictureInPicture,
  toSystemSetting,
} from './utils';

import linksData from './links.json';

// Constants
const PROFILE_NAME = 'Default';
const LEADER_VAR = 'leader_mode';

function main() {
  const rules = [
    createHyperKeyRule(),
    createLeaderKeyRule(),
    createRaycastRules(),
    createAppQuickAccessRules(),
  ];

  const parameters = {
    // If keyup event comes within <alone> ms from keydown, the key is not just pressed but held
    'basic.to_if_alone_timeout_milliseconds': 100,

    // If keydown event for two different keys are pressed within :sim ms, the keypresses are considered simultaneous
    // 'basic.simultaneous_threshold_milliseconds': 30,

    // Key is fired twice when :held ms is elapsed
    'basic.to_if_held_down_threshold_milliseconds': 120,

    // After :delay ms, the key press is considered to be delayed (User for double tap hotkey)
    // 'basic.to_delayed_action_delay_milliseconds': 500,
  };

  writeToProfile(PROFILE_NAME, rules, parameters);
}

main();

// --- Hyper Key Definition ---
function createHyperKeyRule() {
  return rule('Hyper/Meh Key').manipulators([
    map('caps_lock')
      .toIfHeldDown('‹⌘', ['⌃', '⌥', '⇧'])
      // .toHyper()
      .toIfAlone('⎋'),
    map('right_command').toMeh().toIfAlone('right_command'), // Control + Option + Shift
  ]);
}

function createAppQuickAccessRules() {
  return rule('App Quick Access').manipulators([
    map('i', 'Hyper').to(toApp('iTerm')),
    map('g', 'Hyper').to(toApp('Google Chrome')),
    map('s', 'Hyper').to(toApp('Slack')),
    map('c', 'Hyper').to(toApp('Visual Studio Code')),
  ]);
}

function createLeaderKeyRule() {
  const escapeActions = [toUnsetVar(LEADER_VAR), toRemoveNotificationMessage(LEADER_VAR)];

  const categoryMappings = {
    o: {
      name: 'App',
      mapping: {
        v: 'Cisco Secure Client',
        f: 'Finder',
        l: 'Open WebUI',
        o: 'Obsidian',
        w: 'WhatsApp',
        y: 'Spotify',
        z: 'Zoom.us',
        ';': 'System Settings',
      },
      action: toApp,
    },
    l: {
      name: 'Link',
      mapping: linksData as { [key: string]: string },
      action: url => to$(`open ${url}`),
    },
    r: {
      name: 'Raycast',
      mapping: {
        c: ['raycast/calendar/my-schedule', 'Calendar'],
        h: ['raycast/calculator/calculator-history', 'Calculator'],
        f: ['raycast/file-search/search-files', 'Search files'],
        s: ['raycast/snippets/search-snippets', 'Snippets'],
        '.': ['raycast/raycast-notes/raycast-notes', 'Raycast notes'],
        '/': ['raycast/navigation/search-menu-items', 'Search menu'],
        '0': ['lucaschultz/input-switcher/toggle', 'Input lang'],
        r: ['thomas/visual-studio-code/index', 'Recent projects'],
        a: ['Codely/google-chrome/search-all', 'Google search all'],
        d: ['jag-k/dropover/index', 'Add Dropover'],
        t: ['huzef44/screenocr/recognize-text', 'OCR'],
        k: ['huzef44/keyboard-brightness/toggle-keyboard-brightness', 'Keyboard ☀︎'],
        g: ['massimiliano_pasquini/raycast-ollama/ollama-fix-spelling-grammar', 'Fix Spell'],
        p: ['massimiliano_pasquini/raycast-ollama/ollama-professional', 'Profesional'],
        // raycast://extensions/mooxl/coffee/caffeinateToggle
        // raycast://extensions/massimiliano_pasquini/raycast-ollama/ollama-chat
        // raycast://extensions/VladCuciureanu/toothpick/toggle-favorite-device-1
        // raycast://extensions/marcjulian/obsidian/createNoteCommand
        // -----
        // raycast://extensions/mattisssa/spotify-player/nowPlaying
        // raycast://extensions/mattisssa/spotify-player/like
        // raycast://extensions/mattisssa/spotify-player/addPlayingSongToPlaylist
      },
      action: raycastExt,
    },
    ';': {
      name: 'SystemSetting',
      mapping: {
        a: 'Appearance',
        d: 'Displays',
        k: 'Keyboard',
        o: 'Dock',
      },
      action: toSystemSetting,
    },
    u: {
      name: 'System Utils',
      mapping: {
        // [ID, Name]
        n: ['sys_clear_notifications', 'Clear Notifications'],
        s: ['sys_sleep', 'Sleep System'],
        // w: ['night_shift_toggle', 'Toggle Night Shift'],
      },
      action: genericStaticAction,
    },
  } satisfies {
    [key: string]: {
      name: string;
      mapping: { [key: string]: string | string[] };
      action: (v: string) => ToEvent | ToEvent[];
    };
  };

  return createLeaderSystem(LEADER_VAR, categoryMappings, escapeActions);
}

function formatCategoryHint(mapping: Record<string, string | [string, string]>): string {
  return Object.entries(mapping)
    .map(([key, value]) => {
      const displayName = Array.isArray(value) ? value[1] : value;
      return `${key.toUpperCase()}_${displayName}\n`;
    })
    .join('  ');
}

function createLeaderSystem(varName: string, mappings, escapeActions) {
  let categoryKeys = Object.keys(mappings) as FromKeyParam[];

  return rule('Leader Key').manipulators([
    // Part 1: Activate Leader Sub-mode (Inactive -> Category State)
    // Maps Hyper + <category_key> (e.g., Hyper + 'o') to set the
    // leader variable directly to the category key (e.g., 'o')
    // and show the relevant sub-options in the notification.
    withCondition(ifVar(varName, 0))(
      categoryKeys.map(key => {
        const category = mappings[key];
        const hint = formatCategoryHint(category.mapping);

        return map(key, 'Hyper')
          .toVar(varName, key)
          .toNotificationMessage(varName, `${category.name}:\n  ${hint}`);
      }),
    ),

    // Part 2: Escape from any active Leader Mode (Category State -> Inactive)
    withCondition(ifVar(varName, 0).unless())([
      withMapper(['⎋', '␣', '⇥'])(keyToMap => map(keyToMap).to(escapeActions)),
    ]),

    // Part 3: Execute Action in Leader Sub-mode (Category State -> Action -> Inactive)
    // This part handles the second key press after a leader sub-mode is active.
    // It iterates through each category. If the varName matches the categoryKey,
    // it maps the subKeys of that category to their respective actions.
    ...categoryKeys.map(categoryKey => {
      const { mapping, action } = mappings[categoryKey];
      const actionKeys = Object.keys(mapping) as string[];

      return withCondition(ifVar(varName, categoryKey))(
        actionKeys.map((subKey: string) => {
          const value = mapping[subKey];
          const actionValue = Array.isArray(value) ? value[0] : value;

          return map(subKey as any) // `subKey as any` for type compatibility with map()
            .to(action(actionValue))
            .to(escapeActions); // Reset leader mode after executing action
        }),
      );
    }),
  ]);
}

function createRaycastRules() {
  return rule('Raycast').manipulators([
    map('v', ['command', 'shift']).to(raycastExt('raycast/clipboard-history/clipboard-history')),

    // Navigation with Hyper + arrows
    withModifier('Hyper')({
      '↑': raycastWin('previous-display'),
      '↓': raycastWin('next-display'),
      '←': raycastWin('previous-desktop'),
      '→': raycastWin('next-desktop'),
    }),

    // Window positioning with Hyper
    withModifier('Hyper')({
      // Thirds
      1: raycastWin('first-third'),
      2: raycastWin('center-third'),
      3: raycastWin('last-third'),
      // Two-thirds
      4: raycastWin('first-two-thirds'),
      5: raycastWin('top-half'),
      6: raycastWin('bottom-half'),
      7: raycastWin('last-two-thirds'),
      // Halves
      8: raycastWin('left-half'),
      9: raycastWin('center'),
      0: raycastWin('right-half'),
      // Special
      '-': raycastWin('make-smaller'),
      '=': raycastWin('make-larger'),
      '`': raycastWin('almost-maximize'),
      '⏎': raycastWin('maximize'),
      '⌫': raycastWin('restore'),
    }),

    withModifier('Hyper')({
      e: raycastExt('raycast/emoji-symbols/search-emoji-symbols'),
    }),
  ]);
}

function createChromeRules() {
  return rule('Google Chrome').manipulators([
    withModifier('Hyper')({
      p: toPictureInPicture()
    })
  ]);
}

function createNavigationRules() {
  return rule('Navigation Shortcuts').manipulators([
    // History navigation (Ctrl+H/L -> Cmd+[/])
    ...historyNavi(),

    // Tab navigation (Opt+H/L -> Cmd+Shift+[/])
    ...tabNavi(),

    // App switcher (Cmd+Opt+Ctrl+H/L -> Ctrl+Shift+Tab/Ctrl+Tab)
    ...switcher(),
  ]);
}

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
  raycastExt,
  toSystemSetting,
} from './utils';

import linksData from './links.json';

// Constants
const PROFILE_NAME = 'Default';
const LEADER_VAR = 'leader_mode';

function main() {
  const rules = [
    createMehKeyRule(),
    createLeaderKeyRule(),
    createAppQuickAccessRules(),
  ];

  const parameters = {
    // How long to hold before "held down" behavior starts (modifiers activate)
    'basic.to_if_held_down_threshold_milliseconds': 75,

    // How long to wait after key release to decide if it was a "tap" (triggers to_if_alone)
    'basic.to_if_alone_timeout_milliseconds': 125,
  };

  writeToProfile(PROFILE_NAME, rules, parameters);
}

function createMehKeyRule() {
  return rule('Hyper/Meh Key').manipulators([
    map('caps_lock')
      // NOTE: When quickly pressed, it is also sendin 'escape', heldDown fix this
      .toIfHeldDown('‹⌃', ['⌥', '⇧'])
      // .toMeh()
      .toIfAlone('⎋'),
  ]);
}

function createAppQuickAccessRules() {
  return rule('App Quick Access').manipulators([
    
    map('g', 'Meh').to(toApp('Google Chrome')),
    map('v', 'Meh').to(toApp('Visual Studio Code')),
  ]);
}

function createLeaderKeyRule() {
  const escapeActions = [toUnsetVar(LEADER_VAR), toRemoveNotificationMessage(LEADER_VAR)];

  const categoryMappings = {
    o: {
      name: 'App',
      mapping: {
        c: 'Cisco Secure Client',
        f: 'Finder',
        l: 'Open WebUI',
        i: 'iTerm',
        g: 'Google Chrome',
        o: 'Obsidian',
        n: 'Notes',
        r: 'Reminders',
        s: 'Slack',
        w: 'WhatsApp',
        y: 'Spotify',
        v: 'Visual Studio Code',
        z: 'Zoom.us',
        ',': 'System Settings',
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
        '/': ['raycast/navigation/search-menu-items', 'Search menu'],
        a: ['Codely/google-chrome/search-all', 'Google search all'],
        c: ['raycast/calendar/my-schedule', 'Calendar'],
        f: ['raycast/file-search/search-files', 'Search files'],
        g: ['massimiliano_pasquini/raycast-ollama/ollama-fix-spelling-grammar', 'Fix Spell'],
        k: ['huzef44/keyboard-brightness/toggle-keyboard-brightness', 'Keyboard ☀︎'],
        l: ['koinzhang/copy-path/copy-path', 'Calendar'],
        m: ['raycast/apple-reminders/my-reminders', 'Reminders'],
        n: ['marcjulian/obsidian/createNoteCommand', 'Obsidian Note'],
        p: ['massimiliano_pasquini/raycast-ollama/ollama-professional', 'Profesional'],
        r: ['thomas/visual-studio-code/index', 'Recent projects'],
        s: ['raycast/snippets/search-snippets', 'Snippets'],
        o: ['huzef44/screenocr/recognize-text', 'OCR'],

        // raycast://extensions/mooxl/coffee/caffeinateToggle
        // raycast://extensions/massimiliano_pasquini/raycast-ollama/ollama-chat
        // raycast://extensions/VladCuciureanu/toothpick/toggle-favorite-device-1
        // -----
        // raycast://extensions/mattisssa/spotify-player/nowPlaying
        // raycast://extensions/mattisssa/spotify-player/like
        // raycast://extensions/mattisssa/spotify-player/addPlayingSongToPlaylist

        // ------- Added in Raycast ----------
        // This commands are not working properlly, added directly to config.
        // d: ['jag-k/dropover/index', 'Add Dropover'],
        // e: ['raycast/emoji-symbols/search-emoji-symbols', 'Emoji'],

        // Changed to Mac system setting keyboard shortcuts.
        // '0': ['lucaschultz/input-switcher/toggle', 'Input lang'],
      },
      action: raycastExt,
    },
    ',': {
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

        return map(key, 'Meh')
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

main();

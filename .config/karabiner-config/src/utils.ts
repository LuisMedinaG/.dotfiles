import { map, SideModifierAlias, to$, ToEvent } from 'karabiner.ts';

/** Back/Forward history in most apps. */
export function historyNavi() {
  return [
    map('h', '⌃').to('[', '⌘'), //
    map('l', '⌃').to(']', '⌘'),
  ];
}

/** Pre/Next tab in most apps. */
export function tabNavi() {
  return [
    map('h', '⌥').to('[', '⌘⇧'), //
    map('l', '⌥').to(']', '⌘⇧'),
  ];
}

/** Pre/Next switcher in most apps. */
export function switcher() {
  return [
    map('h', '⌘⌥⌃').to('⇥', '⌃⇧'), //
    map('l', '⌘⌥⌃').to('⇥', '⌃'),
  ];
}

/**
 * Map when tap a modifier key; keep as modifier when hold.
 *
 * - ‹⌘ Show/Hide UI (e.g. left sidebars, or all UI)
 * - ‹⌥ Run current task (re-run)
 * - ‹⌃ Run list
 *
 * - ›⌘ Show/Hide UI (e.g. right sidebars, or terminal)
 * - ›⌥ Command Palette (e.g. ⌘K, ⌘P)
 * - ›⌃ History (e.g. recent files)
 */
export const tapModifiers = (
  modifierMappings: Partial<Record<SideModifierAlias | 'fn', ToEvent>>,
) => {
  return Object.entries(modifierMappings).map(([modifier, tapAction]) => {
    const key = modifier as SideModifierAlias | 'fn';
    return map(key).to(key).toIfAlone(tapAction);
  });
};

export function raycastExt(name: string) {
  return to$(`open raycast://extensions/${name}`);
}

export function raycastWin(name: string) {
  return to$(`open -g raycast://extensions/raycast/window-management/${name}`);
}

export function toSystemSetting(pane: string) {
  const path = `/System/Library/PreferencePanes/${pane}.prefPane`;
  return to$(`open -b com.apple.systempreferences ${path}`);
}

// Helper function for AppleScript commands
function toAppleScript(script: string) {
  // Escape single quotes for shell command
  const escapedScript = script.replace(/'/g, "'\\''");
  return to$(`osascript -e '${escapedScript}'`);
}

/** @see https://gist.github.com/lancethomps/a5ac103f334b171f70ce2ff983220b4f?permalink_comment_id=4698498#gistcomment-4698498 */
export function toClearNotifications() {
  return toAppleScript(`
tell application "System Events"
  try
    repeat
      set _groups to groups of UI element 1 of scroll area 1 of group 1 of window "Notification Center" of application process "NotificationCenter"
      set numGroups to number of _groups
      if numGroups = 0 then
        exit repeat
      end if
      repeat with _group in _groups
        set _actions to actions of _group
        set actionPerformed to false
        repeat with _action in _actions
          if description of _action is in {"Clear All", "Close"} then
            perform _action
            set actionPerformed to true
            exit repeat
          end if
        end repeat
        if actionPerformed then
          exit repeat
        end if
      end repeat
    end repeat
  end try
end tell`);
}

export function toNightShift(enabled?: boolean, strength?: number) {
  let commands = [];
  if (enabled !== undefined) commands.push(`client's setEnabled:${enabled}`);
  if (strength !== undefined) commands.push(`client's setStrength:${strength} commit:true`);

  const script = `
use framework "CoreBrightness"
property CBBlueLightClient : class "CBBlueLightClient"
set client to CBBlueLightClient's alloc()'s init()
${commands.join('\n')}`;

  return toAppleScript(script);
}

export function toToggleNightShift() {
  const script = `
use framework "CoreBrightness"
property CBBlueLightClient : class "CBBlueLightClient"
set client to CBBlueLightClient's alloc()'s init()
try
  set currentStrength to 0.0
  client's getStrength:(a reference to currentStrength)
  if currentStrength > 0 then
    client's setEnabled:false
  else
    client's setEnabled:true
    client's setStrength:0.5 commit:true
  end if
end try`;

  return toAppleScript(script);
}

export function toPictureInPicture() {
  const script = `
(* 
Description: Applescript to open/close picture-in-picture in Safari
Supported Applications: Safari, IINA
Author: Daniel Rotärmel
Source: https://gist.github.com/danielrotaermel/201f549d5755ea886eb78bb660133722
Instructions: 
   Assign this to a global keyboard shortcut with better touch tool / hammerspoon etc. - suggested: cmd+ctrl+p. 
   Make sure "Developer > Allow JavaScript from Apple Events" is enabled in Safari. 
   Download the BTT preset here -> https://share.folivora.ai/sP/3dd264e3-5d16-425f-8ab3-ce14877ec04f
*)

set jsStartPip to "document.querySelector('video').webkitSetPresentationMode('picture-in-picture')"

set jsVideoExistsAndInline to "document.querySelector('video') !== null ? (document.querySelector('video').webkitPresentationMode === 'inline' ? 'true' : 'false') : 'false';"

on closePip()
	tell application "System Events"
		if exists (window 1 of process "PIPAgent") then
			-- display dialog "Found window 1"
			-- get every UI element of (window 1 of process "PIPAgent")
			click button 3 of (window 1 of process "PIPAgent")
			-- click button 1 of (window 1 of process "PIPAgent")		
		end if
	end tell
end closePip

-- tell application "Safari" to activate
-- tell application "IINA" to activate


tell application "System Events" to set frontApp to name of first process whose frontmost is true

if frontApp = "Safari" then
	tell application "Safari"
		set isVideoInline to do JavaScript jsVideoExistsAndInline in front document
		if isVideoInline is "true" then
			do JavaScript jsStartPip in front document
		else
			tell application "System Events"
				if exists (window 1 of process "PIPAgent") then
					-- display dialog "Found window 1"
					-- get every UI element of (window 1 of process "PIPAgent")
					click button 3 of (window 1 of process "PIPAgent")
					-- click button 1 of (window 1 of process "PIPAgent")		
				end if
			end tell
		end if
	end tell
else if (frontApp = "IINA") then
	tell application "System Events"
		tell process "IINA"
			try
				click menu item "Enter Picture-in-Picture" of menu "Video" of menu bar 1
			on error
				click menu item "Exit Picture-in-Picture" of menu "Video" of menu bar 1
			end try
		end tell
	end tell
else
	closePip()
end if`;

  return toAppleScript(script);
}

export const systemUtilsActionRegistry: Record<string, ToEvent | ToEvent[]> = {
  sys_clear_notifications: toClearNotifications(),
  sys_sleep: to$('pmset sleepnow'),
};

// This actions dont receive any parameters.
export function genericStaticAction(actionId: string) {
  // TODO: Check if key exists in registry
  return systemUtilsActionRegistry[actionId];
}

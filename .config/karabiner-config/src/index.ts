/* 
  karabiner.ts
  Documentation: https://karabiner.ts.evanliu.dev/
*/

import {
  layer,
  map,
  NumberKeyValue,
  rule,
  withMapper,
  writeToProfile,
} from 'karabiner.ts'

// ! Change '--dry-run' to your Karabiner-Elements Profile name.
// (--dry-run print the config json into console)
// + Create a new profile if needed.
writeToProfile('Test', [

  // rule('Key mapping').manipulators([
  //   // config key mappings
  //   map(1).to(1)
  // ]),

  // CAGS/⎈⎇◆⇧
  // https://precondition.github.io/home-row-mods
  // layer(['caps_lock', 'return_or_enter'], 'mod-layer').manipulators([
  //   map('a').to('left_control'),
  //   map('s').to('left_option'),
  //   map('d').to('left_command'),
  //   map('f').to('left_shift'),

  //   map('j').to('right_shift'),
  //   map('l').to('right_option'),
  //   map('k').to('right_command'),
  //   map(';').to('right_control'),
  // ]),

  // duoLayer('a', 's').manipulators([
  //   map('i').to('up_arrow'), 
  //   map('j').to('left_arrow'), 
  //   map('k').to('down_arrow'), 
  //   map('l').to('right_arrow'),
  // ])
])

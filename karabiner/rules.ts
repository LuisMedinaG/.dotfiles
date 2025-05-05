import fs from "fs";
import { KarabinerRules } from "./types";
//import { createHyperSubLayers, createSequentialHyperLayers, app, open, rectangle, shell } from "./utils"; // Comment out this line

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘) - TEST",
    manipulators: [
      {
        description: "Caps Lock -> Hyper Key - TEST",
        type: "basic",
        from: {
          key_code: "caps_lock",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "hyper",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "hyper",
              value: 0,
            },
          },
        ],
        to_if_alone: [  // Comment out this section
         {
           key_code: "escape",
         },
        ],
      },
    ],
  },
  //...createHyperSubLayers({ // Comment out this line
  //  // ...
  //}),
  //...createSequentialHyperLayers({ // Comment out this line
  //  // ...
  //}),
];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      global: {
        show_in_menu_bar: false,
      },
      profiles: [
        {
          name: "Default",
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
);

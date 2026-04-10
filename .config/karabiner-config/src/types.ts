import { ToEvent } from 'karabiner.ts';

export interface CategoryMapping {
  [categoryKey: string]: {
    name: string;
    mapping: { [subKey: string]: string | string[] };
    action: (v: string) => ToEvent | ToEvent[];
  };
}

export type CategoryMappings = Record<string, CategoryMapping>;

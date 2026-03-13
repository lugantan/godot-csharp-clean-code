# Project Layout

Use this reference when planning folders, scene locations, script grouping, or naming conventions for a Godot C# project.

## Layout Principles

- Group by feature or domain before grouping by file type when the project is medium or large.
- Keep scenes and scripts close enough that ownership is obvious.
- Separate reusable engine-wide systems from feature-specific content.
- Keep art, audio, and code folders predictable and shallow.

## Recommended Layout

```text
res://
├── addons/
├── autoload/
├── core/
│   ├── scenes/
│   ├── scripts/
│   └── services/
├── features/
│   ├── player/
│   │   ├── scenes/
│   │   ├── scripts/
│   │   └── resources/
│   ├── combat/
│   └── inventory/
├── ui/
│   ├── scenes/
│   ├── scripts/
│   └── themes/
├── levels/
├── assets/
│   ├── art/
│   ├── audio/
│   └── fonts/
└── tests/
```

For a concrete starter version of this structure, reuse [../assets/godot-template](../assets/godot-template). The template includes a main scene, player feature, HUD, Autoload example, and focused C# scripts.

## Folder Rules

- `autoload/`: only global services or persistent coordinators
- `core/`: shared infrastructure that multiple features depend on
- `features/`: gameplay domains such as player, enemies, quests, inventory, or dialogue
- `ui/`: reusable UI scenes, menus, HUDs, and theme assets
- `levels/`: assembled game spaces and level-specific content

## Naming

- Scene files: `Player.tscn`, `InventoryPanel.tscn`, `EnemySpawner.tscn`
- Script files: `Player.cs`, `InventoryPanel.cs`, `EnemySpawner.cs`
- Keep scene and main script names aligned unless the scene intentionally composes multiple scripts.

## Anti-Patterns

- A single `scripts/` folder with every gameplay class mixed together
- `utils/` or `managers/` folders collecting unrelated gameplay logic
- UI scenes scattered across gameplay folders with no clear ownership

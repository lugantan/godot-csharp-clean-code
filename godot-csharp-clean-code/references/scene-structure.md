# Scene Structure

Use this reference when the task involves scene trees, packed scenes, node ownership, or splitting gameplay features into maintainable scenes.

## Principles

- Start with the gameplay concept, then choose the root node that best expresses it.
- Give each scene one primary responsibility, such as `Player`, `EnemySpawner`, `InventoryPanel`, or `MainMenu`.
- Split reusable parts into packed scenes instead of creating giant scene trees with unrelated branches.
- Attach scripts to the node that owns the behavior. Do not attach orchestration code to arbitrary parents.
- Keep node paths local and stable. If a script must constantly search deep in the tree, the scene is likely structured poorly.

## Scene Tree Rules

- Use a root node whose type matches the feature, such as `CharacterBody2D`, `Control`, `Node2D`, or `Node3D`.
- Keep visual nodes, collision nodes, timers, and audio nodes as children of the scene that owns them.
- Prefer child scenes for modular subsystems like health bars, interact prompts, or weapon sockets.
- Avoid monolithic root scenes that own every system in the level unless they are acting as composition shells.

## Example Scene Plan

```text
Player.tscn
└── Player (CharacterBody2D)
    ├── VisualRoot (Node2D)
    │   ├── Sprite2D
    │   └── AnimationPlayer
    ├── CollisionShape2D
    ├── HurtBox (Area2D)
    ├── InteractionDetector (Area2D)
    └── CameraAnchor (Marker2D)
```

Why this is clean:

- The root node owns player movement and physics.
- Visual concerns stay under `VisualRoot`.
- Collision and interaction are explicit nodes instead of hidden logic.
- The scene can grow without one script becoming a junk drawer.

## Example Responsibility Split

- `Player.cs`: movement, facing, and interaction orchestration
- `HurtBox.cs`: damage detection and signal emission
- `PlayerAnimationController.cs`: animation state updates if animation logic becomes complex

## Anti-Patterns

- One `Level.cs` script directly controlling every enemy, UI widget, and camera effect
- Deep `GetNode("../../Something")` chains across unrelated branches
- Reusing one scene for multiple unrelated concepts because it already exists

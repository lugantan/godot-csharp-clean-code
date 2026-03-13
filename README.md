# godot-csharp-clean-code

[English](./README.md) | [中文](./README.zh-CN.md)

A Codex skill for designing, generating, refactoring, and reviewing Godot C# projects with clean-code rules and Godot-specific architecture guidance.

## Overview

`godot-csharp-clean-code` is built for cases where general clean code is not enough and Godot structure matters:

- scene trees and packed scene boundaries
- node ownership and script responsibilities
- `_Ready`, `_Process`, `_PhysicsProcess`, and input lifecycle usage
- signals, event flow, and Autoload boundaries
- Godot-friendly C# naming and exported configuration
- maintainable project layout for gameplay, UI, and shared systems

## What This Skill Helps With

- planning cleaner scene trees before implementation
- splitting large Godot scenes into focused packed scenes
- keeping node scripts aligned with the node they belong to
- choosing between direct references, signals, and Autoload services
- structuring Godot C# projects by feature or domain
- generating cleaner starter code for gameplay and UI systems
- reviewing existing Godot C# code for coupling, lifecycle misuse, and responsibility leaks

## Repository Structure

```text
.
├── README.md
├── README.zh-CN.md
└── godot-csharp-clean-code
    ├── SKILL.md
    ├── assets
    │   └── godot-template
    │       ├── autoload
    │       ├── core
    │       ├── features
    │       ├── project.godot
    │       ├── scenes
    │       └── ui
    └── references
        ├── csharp-style.md
        ├── lifecycle.md
        ├── project-layout.md
        ├── scene-structure.md
        └── signals-and-events.md
```

## Core References

- [godot-csharp-clean-code/SKILL.md](./godot-csharp-clean-code/SKILL.md): trigger rules, workflow, and output rules
- [godot-csharp-clean-code/references/scene-structure.md](./godot-csharp-clean-code/references/scene-structure.md): scene composition and node ownership
- [godot-csharp-clean-code/references/lifecycle.md](./godot-csharp-clean-code/references/lifecycle.md): Godot lifecycle boundaries
- [godot-csharp-clean-code/references/signals-and-events.md](./godot-csharp-clean-code/references/signals-and-events.md): signals, event flow, and Autoload guidance
- [godot-csharp-clean-code/references/project-layout.md](./godot-csharp-clean-code/references/project-layout.md): folder and feature layout
- [godot-csharp-clean-code/references/csharp-style.md](./godot-csharp-clean-code/references/csharp-style.md): Godot-oriented C# style and examples

## Starter Template

This repository also includes a near-runnable starter template at [godot-csharp-clean-code/assets/godot-template](./godot-csharp-clean-code/assets/godot-template).

The template demonstrates:

- a `Main.tscn` composition root
- a `Player` feature scene and focused player script
- a `Hud` scene with a dedicated HUD controller
- a small `GameDirector` Autoload example
- a clear separation between `core`, `features`, `ui`, and `autoload`

## Example Prompt

```text
Use $godot-csharp-clean-code to design or refactor a Godot C# project with clean scene trees, focused scripts, sane signals, and clear project structure.
```

## Best Use Cases

- starting a new Godot C# project with better defaults
- refactoring a messy scene tree into smaller packed scenes
- reviewing gameplay scripts that have grown too large
- improving communication between nodes without overusing global managers
- applying consistent project structure across a team

## License

Use this repository according to the repository license or your own project needs after copying the skill into your Codex environment.

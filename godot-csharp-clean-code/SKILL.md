---
name: godot-csharp-clean-code
description: Design, generate, refactor, or review Godot C# projects with clean-code standards and Godot-specific architecture rules. Use when Codex needs to work on Godot scenes, node trees, C# gameplay scripts, signals, Autoload singletons, project folders, or scene and script responsibilities. Trigger for requests involving Godot node structure, scene splitting, lifecycle methods like `_Ready` or `_PhysicsProcess`, Godot C# naming, signal wiring, UI scenes, gameplay systems, or maintainable project layout.
---

# Godot CSharp Clean Code

## Overview

Use this skill when Godot engine structure matters as much as code quality. Plan scenes and node ownership first, then write focused C# scripts that align with Godot lifecycle and signal patterns.

## Workflow

1. Start from the scene tree, not from raw script output. Identify the root node, child nodes, packed scenes, and ownership boundaries before coding.
2. Split responsibilities across scenes, nodes, and scripts. Avoid giant controller scripts that own UI, gameplay, input, and persistence at once.
3. Keep each script attached to the node that actually owns the behavior. Prefer local ownership over global managers.
4. Choose the right lifecycle method for the behavior. Keep setup in `_Ready`, frame-dependent work in `_Process`, physics movement in `_PhysicsProcess`, and input routing in `_UnhandledInput` or `_Input` when justified.
5. Prefer signals and clear public methods for coordination. Do not couple distant nodes with hard-coded tree traversal unless the hierarchy is stable and local.
6. Use Autoload sparingly for true application-level concerns like save state, scene navigation, audio routing, or shared configuration.
7. Keep project structure readable. Group scenes, scripts, UI, gameplay systems, and resources by feature or domain.
8. Before finishing, review the scene structure, script responsibilities, signal flow, and node dependencies for hidden coupling.

## Output Rules

- For new features or refactors, propose the scene tree and folder structure before or alongside code.
- Name scenes, scripts, nodes, signals, and exported properties after gameplay intent, not temporary implementation detail.
- Keep node scripts small and cohesive. If a script coordinates many unrelated children, split the scene or add focused helper components.
- Prefer composition through child scenes and signals over inheritance-heavy hierarchies.
- Keep serialized node references and exported fields intentional and easy to audit.
- Explain why a node is an Autoload, packed scene, component script, or local helper when the choice is not obvious.
- Reuse [assets/godot-template](assets/godot-template) when the user wants a new Godot C# project skeleton or a concrete example of the recommended project layout.

## Decomposition Rules (hard limits)

Split by domain, and keep each unit small enough to reason about. These two limits are not left to discipline — they are enforced mechanically by [scripts/check-decomposition.ps1](scripts/check-decomposition.ps1), which exits non-zero on a violation so CI can block the merge.

- **One class = one hand-written file.** Godot 4.x requires a single `partial` on every `Node`- or `Resource`-derived type so its source generator can emit the companion half (that half is the `*.g.cs` under `obj/`). Keep that one. Never add a *second* hand-written file for the same type (`PlayerController.Inventory.cs`, `PlayerController.SaveLoad.cs`).
  - **Why a `partial` split is not decomposition:** a `partial class` is one type. The compiler concatenates every partial file into a single class with one shared set of fields and methods — splitting the file reduces no coupling and no responsibility. Every member still sees every other, the type is just as large and just as hard to test in isolation, and you have only hidden the growth from your size signals. It also cannot cross a layer boundary: logic left inside a `Node`-derived partial stays engine-coupled. The fix is to **extract a real collaborator** — a focused child-scene component or a plain C# helper class — not to add another partial half.
- **No file over ~1000 lines.** Line count is a smell signal, not a budget to fill. A class approaching 1000 lines is almost always doing several domains' jobs at once; find the seams and extract each into its own focused script or scene until the original is a thin coordinator.

Run the gate locally or in CI:

```yaml
- name: Enforce decomposition
  shell: pwsh
  run: pwsh scripts/check-decomposition.ps1 -Path . -MaxLines 1000
```

## Review Checklist

- Does each scene own one gameplay or UI concept?
- Is each type a single hand-written file, and is every source file comfortably under 1000 lines?
- Does each script match the responsibility of the node it is attached to?
- Are lifecycle methods used for the right kind of work?
- Are signals clearer than direct node coupling in this case?
- Is Autoload used only for true cross-scene concerns?
- Can another developer understand the scene tree and folder layout quickly?

## Reference Guide

- Load [references/scene-structure.md](references/scene-structure.md) for scene composition, node ownership, packed scenes, and scene tree examples.
- Load [references/lifecycle.md](references/lifecycle.md) for `_Ready`, `_Process`, `_PhysicsProcess`, `_UnhandledInput`, timers, and update boundaries.
- Load [references/signals-and-events.md](references/signals-and-events.md) for signal wiring, event flow, decoupling, and Autoload boundaries.
- Load [references/project-layout.md](references/project-layout.md) for Godot folder layout, naming, and feature grouping.
- Load [references/csharp-style.md](references/csharp-style.md) for C# naming, exported fields, properties, partial classes, and script examples.
- Reuse [assets/godot-template](assets/godot-template) for a near-runnable starter project that demonstrates scene composition, Autoload, HUD coordination, input, and clean script boundaries.
- Run [scripts/check-decomposition.ps1](scripts/check-decomposition.ps1) to enforce the Decomposition Rules (one hand-written file per type, no file over 1000 lines) locally or in CI.

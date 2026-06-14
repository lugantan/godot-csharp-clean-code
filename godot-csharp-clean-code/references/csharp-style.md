# CSharp Style

Use this reference when writing or reviewing Godot C# scripts.

## Naming

- Use standard C# naming: PascalCase for classes, methods, properties, signals, and exported members.
- Use `_camelCase` for private fields when the surrounding project follows that style.
- Name scripts after the node or concept they control, such as `Player`, `PauseMenu`, or `EnemySpawner`.
- Prefer intention-revealing names like `MoveSpeed`, `CurrentTarget`, and `TryStartDialogue`.

## Script Design

- Keep node scripts focused on the behavior owned by that node.
- Prefer small helper methods when they make lifecycle methods easier to scan.
- Do not hide complex logic inside anonymous lambdas when named methods would be clearer.
- Prefer properties for configuration and clearly exported members for editor-facing tuning.
- Keep the single `partial` Godot requires on Node- and Resource-derived types, but never spread one type's hand-written logic across multiple files. A `partial class` is one merged type, so a second hand-written file reduces no coupling and hides growth — extract a real collaborator instead. See the Decomposition Rules in SKILL.md; it is enforced by `scripts/check-decomposition.ps1`.

## Exported Members

- Export data the designer or level builder should tune in the editor.
- Do not export internal state that should remain private to runtime logic.
- Validate exported values in `_Ready` or a dedicated validation method when bad configuration would cause broken behavior.

## Example

```csharp
using Godot;

public partial class InteractionPrompt : Control
{
    [Export] public string DefaultPromptText { get; set; } = "Interact";

    private Label _promptLabel = null!;

    public override void _Ready()
    {
        _promptLabel = GetNode<Label>("PromptLabel");
        ApplyPromptText(DefaultPromptText);
        Hide();
    }

    public void ShowPrompt(string promptText)
    {
        ApplyPromptText(promptText);
        Show();
    }

    public void HidePrompt()
    {
        Hide();
    }

    private void ApplyPromptText(string promptText)
    {
        _promptLabel.Text = string.IsNullOrWhiteSpace(promptText)
            ? DefaultPromptText
            : promptText;
    }
}
```

Why this is clean:

- The script owns one UI concept.
- Editor-facing configuration is exported clearly.
- Public methods express the small surface area this node exposes.

## Anti-Patterns

- One node script acting as scene controller, save manager, input router, and animation coordinator
- Exporting many loosely related fields because the script owns too many jobs
- Public methods that leak internal node traversal details to callers

# Lifecycle

Use this reference when code depends on Godot execution timing, input flow, physics updates, or initialization order.

## Lifecycle Boundaries

- `_Ready`: resolve node references, connect local signals, initialize state that depends on the scene tree
- `_Process(double delta)`: non-physics per-frame updates such as UI interpolation, timers not tied to physics, or camera polish
- `_PhysicsProcess(double delta)`: movement, velocity, collision-aware behavior, and deterministic gameplay updates
- `_Input(InputEvent @event)`: low-level input capture when the node must see raw input
- `_UnhandledInput(InputEvent @event)`: gameplay input after UI or other higher-priority consumers have had a chance to handle it

## Rules

- Do not mix setup, physics, UI animation, and input handling into one large lifecycle method.
- Keep lifecycle methods thin and delegate to intention-revealing helpers.
- Avoid expensive tree traversal inside `_Process` or `_PhysicsProcess`.
- Cache stable node references in `_Ready`.
- If timing logic is stateful or long-lived, consider a `Timer`, animation track, or focused helper node instead of custom counters everywhere.

## Example

```csharp
using Godot;

public partial class Player : CharacterBody2D
{
    [Export] public float MoveSpeed { get; set; } = 240f;

    public override void _Ready()
    {
        ValidateConfiguration();
    }

    public override void _PhysicsProcess(double delta)
    {
        Velocity = BuildMovementVelocity();
        MoveAndSlide();
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("interact"))
        {
            TryInteract();
        }
    }

    private void ValidateConfiguration()
    {
        if (MoveSpeed <= 0)
        {
            GD.PushError("MoveSpeed must be greater than zero.");
        }
    }

    private Vector2 BuildMovementVelocity()
    {
        Vector2 inputDirection = Input.GetVector("move_left", "move_right", "move_up", "move_down");
        return inputDirection * MoveSpeed;
    }

    private void TryInteract()
    {
        // Delegate interaction resolution to the focused interaction subsystem.
    }
}
```

Why this is clean:

- Each lifecycle method owns one kind of work.
- Helper names reveal intent.
- Validation stays out of frame loops.

## Anti-Patterns

- Reading input, moving physics, spawning effects, and saving data inside `_Process`
- Doing node discovery every frame instead of caching references once
- Putting critical physics behavior in `_Process` for moving bodies

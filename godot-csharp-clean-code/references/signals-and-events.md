# Signals And Events

Use this reference when nodes need to communicate, when systems span multiple scenes, or when deciding between direct references, signals, and Autoload services.

## Signal Rules

- Prefer signals when one node needs to announce something and another node reacts.
- Keep signal names event-like, such as `HealthDepleted`, `InventoryOpened`, or `InteractionRequested`.
- Connect local or scene-internal signals in `_Ready` when ownership is clear.
- Disconnect only when the lifecycle requires manual cleanup beyond node destruction.
- Use direct references for tight parent-child ownership. Use signals for looser coordination.

## Event Flow Guidance

- Child node detects a local event.
- Child emits a signal with useful payload.
- Parent or coordinator reacts and decides the next action.
- Cross-scene systems should route through a clear boundary, not a chain of unrelated node lookups.

## Autoload Boundaries

Use Autoload for:

- save and load services
- scene transition coordinators
- settings and audio managers
- profile-wide persistent state

Avoid Autoload for:

- per-scene combat logic
- local UI widget communication
- feature-specific gameplay state that belongs to a scene or subsystem

## Example

```csharp
using Godot;

public partial class HurtBox : Area2D
{
    [Signal]
    public delegate void HitReceivedEventHandler(int damageAmount);

    public void ApplyHit(int damageAmount)
    {
        EmitSignal(SignalName.HitReceived, damageAmount);
    }
}

public partial class PlayerHealth : Node
{
    [Export] public int MaxHealth { get; set; } = 5;

    private int _currentHealth;
    private HurtBox _hurtBox = null!;

    public override void _Ready()
    {
        _currentHealth = MaxHealth;
        _hurtBox = GetNode<HurtBox>("../HurtBox");
        _hurtBox.HitReceived += OnHitReceived;
    }

    private void OnHitReceived(int damageAmount)
    {
        _currentHealth -= damageAmount;

        if (_currentHealth <= 0)
        {
            QueueFree();
        }
    }
}
```

Why this is clean:

- The hit source announces an event instead of owning health logic.
- The health node owns health state.
- Responsibilities stay separated and reusable.

## Anti-Patterns

- Global event buses for every interaction in a small scene
- Autoload managers that become dumping grounds for unrelated feature logic
- Child nodes reaching across the tree to mutate distant siblings directly

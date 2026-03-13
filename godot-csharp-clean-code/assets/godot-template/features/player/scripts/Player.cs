using Godot;

public partial class Player : CharacterBody2D
{
    [Signal]
    public delegate void PositionChangedEventHandler(Vector2 worldPosition);

    [Signal]
    public delegate void PauseRequestedEventHandler();

    [Export] public float MoveSpeed { get; set; } = 240f;

    public override void _Ready()
    {
        ValidateConfiguration();
    }

    public override void _PhysicsProcess(double delta)
    {
        Velocity = BuildMovementVelocity();
        MoveAndSlide();

        EmitSignal(SignalName.PositionChanged, GlobalPosition);
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("pause"))
        {
            EmitSignal(SignalName.PauseRequested);
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
}

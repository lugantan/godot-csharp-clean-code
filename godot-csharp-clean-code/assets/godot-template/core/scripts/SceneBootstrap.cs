using Godot;

public partial class SceneBootstrap : Node2D
{
    private Player _player = null!;
    private HudController _hud = null!;

    public override void _Ready()
    {
        _player = GetNode<Player>("Player");
        _hud = GetNode<HudController>("Hud");

        _player.PositionChanged += OnPlayerPositionChanged;
        _player.PauseRequested += OnPauseRequested;

        _hud.UpdateStatus("Use WASD to move and Esc to toggle pause.");
        _hud.UpdatePlayerPosition(_player.GlobalPosition);
    }

    private void OnPlayerPositionChanged(Vector2 worldPosition)
    {
        _hud.UpdatePlayerPosition(worldPosition);
    }

    private void OnPauseRequested()
    {
        GetTree().Paused = !GetTree().Paused;
        _hud.UpdateStatus(GetTree().Paused ? "Game paused" : "Game resumed");
    }
}

using Godot;

public partial class HudController : CanvasLayer
{
    private Label _statusLabel = null!;
    private Label _positionLabel = null!;

    public override void _Ready()
    {
        _statusLabel = GetNode<Label>("MarginContainer/Panel/VBoxContainer/StatusLabel");
        _positionLabel = GetNode<Label>("MarginContainer/Panel/VBoxContainer/PositionLabel");
    }

    public void UpdateStatus(string statusText)
    {
        _statusLabel.Text = $"Status: {statusText}";
    }

    public void UpdatePlayerPosition(Vector2 worldPosition)
    {
        _positionLabel.Text = $"Player: ({worldPosition.X:0}, {worldPosition.Y:0})";
    }
}

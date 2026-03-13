using Godot;

public partial class GameDirector : Node
{
    public string StatusMessage { get; private set; } = "Ready";

    public void SetStatusMessage(string statusMessage)
    {
        StatusMessage = string.IsNullOrWhiteSpace(statusMessage)
            ? "Ready"
            : statusMessage;
    }
}

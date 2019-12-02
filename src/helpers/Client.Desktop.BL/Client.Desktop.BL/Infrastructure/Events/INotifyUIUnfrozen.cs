namespace Client.Desktop.BL.Infrastructure.Events
{
    public interface INotifyUiUnfrozen
    {
        // ReSharper disable once EventNeverSubscribedTo.Global
        event UiUnfrozenEventHandler UiUnfrozen;
    }
}
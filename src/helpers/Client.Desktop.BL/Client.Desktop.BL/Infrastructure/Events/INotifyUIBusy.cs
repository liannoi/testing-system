namespace Client.Desktop.BL.Infrastructure.Events
{
    public interface INotifyUiBusy
    {
        // ReSharper disable once EventNeverSubscribedTo.Global
        event UiBusyEventHandler UiBusy;
    }
}
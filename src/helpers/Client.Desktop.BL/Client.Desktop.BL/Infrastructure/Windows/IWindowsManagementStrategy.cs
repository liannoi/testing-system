namespace Client.Desktop.BL.Infrastructure.Windows
{
    public interface IWindowsManagementStrategy
    {
        void CloseParent();
        void Open();
        void OpenDialog();
    }
}
using System.Windows;

namespace Client.Desktop.BL.Infrastructure.Windows
{
    public class WindowsManagementStrategy<TViewModel, TWindow> : IWindowsManagementStrategy
        where TViewModel : BaseViewModel
        where TWindow : Window
    {
        private readonly TViewModel viewModel;
        private readonly TWindow window;

        public WindowsManagementStrategy(TViewModel viewModel, TWindow window)
        {
            this.viewModel = viewModel;
            this.window = window;
        }

        public void Open()
        {
            DataContext();
            window.Show();
        }

        public void OpenDialog()
        {
            DataContext();
            window.ShowDialog();
        }

        public void CloseParent()
        {
            Application.Current.MainWindow?.Close();
        }

        private void DataContext()
        {
            window.DataContext = viewModel;
        }
    }
}
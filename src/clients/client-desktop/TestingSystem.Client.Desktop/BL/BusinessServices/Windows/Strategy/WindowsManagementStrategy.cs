using Client.Desktop.BL.Infrastructure;
using System.Windows;

namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.Strategy
{
    public class WindowsManagementStrategy<TViewModel, TWindow> : IWindowsManagementStrategy
        where TViewModel : IBaseViewModel
        where TWindow : Window
    {
        private readonly TViewModel viewModel;
        private TWindow window;

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
            Application.Current.MainWindow.Close();
        }

        private void DataContext()
        {
            window.DataContext = viewModel;
        }
    }
}

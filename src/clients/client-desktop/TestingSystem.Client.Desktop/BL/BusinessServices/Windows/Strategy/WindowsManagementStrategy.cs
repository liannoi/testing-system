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
            window.DataContext = viewModel;
            window.Show();
            Application.Current.MainWindow.Close();
        }
    }
}

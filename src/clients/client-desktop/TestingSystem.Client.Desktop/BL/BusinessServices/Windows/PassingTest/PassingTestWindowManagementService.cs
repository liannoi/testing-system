using Client.Desktop.BL.Infrastructure.Windows;
using TestingSystem.Client.Desktop.BL.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Windows.PassingTest
{
    public class PassingTestWindowManagementService : IPassingTestWindowManagementService
    {
        private IWindowsManagementStrategy strategy;

        public TestBusinessObject Test { get; set; }

        public void OpenWindow()
        {
            strategy = new WindowsManagementStrategy<StudentPassTestViewModel, StudentPassTestWindow>(
                new StudentPassTestViewModel(Test),
                new StudentPassTestWindow());
            strategy.OpenDialog();
            strategy.CloseParent();
        }
    }
}
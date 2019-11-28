using TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.Strategy;
using TestingSystem.Client.Desktop.UI.BL.Infrastructure.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.PassingTest
{
    // TODO: Make interface.
    public class PassingTestWindowManagementService
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

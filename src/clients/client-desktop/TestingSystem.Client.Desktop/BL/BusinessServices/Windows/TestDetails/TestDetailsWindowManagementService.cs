using TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.Strategy;
using TestingSystem.Client.Desktop.UI.BL.Infrastructure.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.TestDetails
{
    public class TestDetailsWindowManagementService : ITestDetailsWindowManagementService
    {
        private IWindowsManagementStrategy strategy;

        public TestBusinessObject Test { get; set; }
        public StudentTestBusinessObject TestDetails { get; set; }

        public void OpenWindow()
        {
            strategy = new WindowsManagementStrategy<StudentTestDetailsViewModel, StudentTestDetailsWindow>(
                new StudentTestDetailsViewModel(Test, TestDetails),
                new StudentTestDetailsWindow());
            strategy.OpenDialog();
        }
    }
}

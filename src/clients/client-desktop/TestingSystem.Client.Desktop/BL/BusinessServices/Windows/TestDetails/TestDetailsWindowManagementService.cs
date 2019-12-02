using Client.Desktop.BL.Infrastructure.Windows;
using TestingSystem.Client.Desktop.BL.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Windows.TestDetails
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
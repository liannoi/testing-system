using Client.Desktop.BL.Infrastructure.Windows;
using TestingSystem.Client.Desktop.BL.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.WindowManagement.PassingTest.End
{
    public class EndPassingTestWindowManagementService : BaseWindowManagementService, IEndPassingTestWindowManagementService
    {
        public int Grade { get; set; }
        public StudentTestBusinessObject TestDetails { get; set; }

        public void OpenWindow()
        {
            Strategy = new WindowsManagementStrategy<StudentEndPassTestViewModel, StudentTestPassEndWindow>(
                new StudentEndPassTestViewModel(),
                new StudentTestPassEndWindow());
            Strategy.OpenDialog();
            Strategy.CloseLatest();
        }
    }
}

using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.TestDetails
{
    public interface ITestDetailsWindowManagementService
    {
        TestBusinessObject Test { get; set; }
        StudentTestBusinessObject TestDetails { get; set; }

        void OpenWindow();
    }
}
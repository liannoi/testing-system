using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.WindowManagement.PassingTest.End
{
    public interface IEndPassingTestWindowManagementService
    {
        int Grade { get; set; }
        StudentTestBusinessObject TestDetails { get; set; }

        void OpenWindow();
    }
}
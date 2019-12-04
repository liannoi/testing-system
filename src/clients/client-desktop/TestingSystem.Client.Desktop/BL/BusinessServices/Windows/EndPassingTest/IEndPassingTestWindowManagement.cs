using TestingSystem.Common.BL.BusinessObjects.NonEntities;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Windows.EndPassingTest
{
    public interface IEndPassingTestWindowManagement
    {
        PassingTestResultBusinessObject PassingTestResult { get; set; }

        void OpenWindow();
    }
}
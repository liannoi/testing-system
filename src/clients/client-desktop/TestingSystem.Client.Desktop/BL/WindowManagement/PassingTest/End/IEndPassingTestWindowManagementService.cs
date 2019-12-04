using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;

namespace TestingSystem.Client.Desktop.BL.WindowManagement.PassingTest.End
{
    public interface IEndPassingTestWindowManagementService
    {
        TestAdvancedDetailsBusinessObject TestDetails { get; set; }

        void OpenWindow();
    }
}
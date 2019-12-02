using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Windows.PassingTest
{
    public interface IPassingTestWindowManagementService
    {
        TestBusinessObject Test { get; set; }

        void OpenWindow();
    }
}
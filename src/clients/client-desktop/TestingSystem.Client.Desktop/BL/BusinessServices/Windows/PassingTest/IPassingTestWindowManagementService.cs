using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.PassingTest
{
    public interface IPassingTestWindowManagementService
    {
        TestBusinessObject Test { get; set; }

        void OpenWindow();
    }
}
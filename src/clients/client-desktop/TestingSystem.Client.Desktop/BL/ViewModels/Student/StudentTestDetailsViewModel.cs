using System.Windows.Input;
using Client.Desktop.BL.Infrastructure;
using TestingSystem.Client.Desktop.BL.BusinessServices.Windows.PassingTest;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Student
{
    public class StudentTestDetailsViewModel : BaseViewModel
    {
        #region Fields

        #region Services

        private readonly IPassingTestWindowManagementService windowManager;

        #endregion

        #endregion

        #region Constructors

        public StudentTestDetailsViewModel(TestBusinessObject test, StudentTestBusinessObject testDetails)
        {
            Test = test;
            TestDetails = testDetails;
            windowManager = new PassingTestWindowManagementService
            {
                Test = Test
            };
        }

        #endregion

        #region Commands

        public ICommand StartTestCommand => MakeCommand(a => StartTest(), c => TestDetails.AllowToPass);

        #endregion

        #region Commands implementation

        private void StartTest()
        {
            windowManager.OpenWindow();
        }

        #endregion

        #region Properties

        public TestBusinessObject Test
        {
            get => Get<TestBusinessObject>();
            set => Set(value);
        }

        public StudentTestBusinessObject TestDetails
        {
            get => Get<StudentTestBusinessObject>();
            set => Set(value);
        }

        #endregion
    }
}
using Client.Desktop.BL.Infrastructure;
using System;
using System.Windows.Input;
using TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.PassingTest;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.Infrastructure.ViewModels.Student
{
    public class StudentTestDetailsViewModel : BaseViewModel
    {
        #region Fields

        #region Services

        // TODO: Replace by interface.
        private PassingTestWindowManagementService windowManager;

        #endregion

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

        #region Commands

        public ICommand StartTestCommand => MakeCommand(a => StartTest(), c => TestDetails.AllowToPass);

        #endregion

        #region Constructors

        public StudentTestDetailsViewModel(TestBusinessObject test, StudentTestBusinessObject testDetails)
        {
            Test = test;
            TestDetails = testDetails;
            windowManager = new PassingTestWindowManagementService()
            {
                Test = Test
            };
        }

        #endregion

        #region Commands implementation

        private void StartTest()
        {
            windowManager.OpenWindow();
        }

        #endregion
    }
}

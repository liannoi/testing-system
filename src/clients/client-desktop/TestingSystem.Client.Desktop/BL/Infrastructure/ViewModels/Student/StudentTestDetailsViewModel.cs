using Client.Desktop.BL.Infrastructure;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.Infrastructure.ViewModels.Student
{
    public class StudentTestDetailsViewModel : BaseViewModel
    {
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

        public StudentTestDetailsViewModel(TestBusinessObject test, StudentTestBusinessObject testDetails)
        {
            Test = test;
            TestDetails = testDetails;
        }
    }
}

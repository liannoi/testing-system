using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Converters;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.Infrastructure.ViewModels.Student
{
    public class StudentTestDetailsViewModel : BaseViewModel
    {
        public IBoolToStringConverter BoolToStringConverter { get; set; }

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
            BoolToStringConverter = new BoolToStringConverter(new BoolAnswer
            {
                Negative = "No",
                Positive = "Yes"
            });
            //AllowToPass = TestDetails.AllowToPass;
        }
    }
}

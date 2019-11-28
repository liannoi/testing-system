using Multilayer.BusinessServices;
using System.Collections.Generic;
using System.Linq;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.PassingTest
{
    public class PassingTestService
    {
        private IBusinessService<QuestionBusinessObject> questions;
        private IBusinessService<AnswerBusinessObject> answers;

        public TestBusinessObject Test { get; set; }

        public int QuestionsCount => Questions.Count();

        public IEnumerable<QuestionBusinessObject> Questions => questions.Find(e => e.TestId == Test.TestId).Where(e => e.IsRemoved == false);

        public PassingTestService(IBusinessService<QuestionBusinessObject> questions, IBusinessService<AnswerBusinessObject> answers)
        {
            this.questions = questions;
            this.answers = answers;
        }
    }
}

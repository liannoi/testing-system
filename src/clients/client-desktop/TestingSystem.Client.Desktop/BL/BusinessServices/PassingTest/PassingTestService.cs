using Multilayer.BusinessServices;
using System;
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

        public QuestionBusinessObject CurrentQuestion { get; set; }

        public int QuestionsCount => Questions.Count();

        public int SuitableAnswersCount => SuitableAnswers.Count();

        public IEnumerable<AnswerBusinessObject> SuitableAnswers => GetAnswers(e => e.IsRemoved == false && e.IsSuitable == true);

        public IEnumerable<AnswerBusinessObject> Answers => GetAnswers();

        public IEnumerable<QuestionBusinessObject> YieldQuestions
        {
            get
            {
                yield return Questions.FirstOrDefault();
            }
        }

        private IEnumerable<QuestionBusinessObject> Questions => questions.Find(e => e.TestId == Test.TestId).Where(e => e.IsRemoved == false);

        public PassingTestService(IBusinessService<QuestionBusinessObject> questions, IBusinessService<AnswerBusinessObject> answers)
        {
            this.questions = questions;
            this.answers = answers;
        }

        public bool CheckAnswers(IEnumerable<AnswerBusinessObject> answers)
        {
            foreach (AnswerBusinessObject answer in answers)
            {
                if (!answer.IsChecked)
                {
                    return false;
                }
            }
            return true;
        }

        private IEnumerable<AnswerBusinessObject> GetAnswers(Func<AnswerBusinessObject, bool> predicate)
        {
            return answers.Find(e => e.QuestionId == CurrentQuestion.QuestionId).Where(predicate);
        }

        private IEnumerable<AnswerBusinessObject> GetAnswers()
        {
            return GetAnswers(e => e.IsRemoved == false);
        }
    }
}

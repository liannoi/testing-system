using Multilayer.BusinessServices;
using System;
using System.Collections.Generic;
using System.Linq;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.PassingTest
{
    public class PassingTestService
    {
        #region Fields

        private readonly IBusinessService<AnswerBusinessObject> answers;
        private readonly IBusinessService<QuestionBusinessObject> questions;

        #endregion

        #region Constructors

        public PassingTestService(IBusinessService<QuestionBusinessObject> questions,
            IBusinessService<AnswerBusinessObject> answers)
        {
            this.questions = questions;
            this.answers = answers;
        }

        #endregion

        #region Properties

        public TestBusinessObject Test { get; set; }

        public int QuestionsCount => Questions.Count();

        public QuestionBusinessObject CurrentQuestion { get; set; }

        public int SuitableAnswersCount => SuitableAnswers.Count();

        public IEnumerable<AnswerBusinessObject> SuitableAnswers =>
            GetAnswers(e => e.IsRemoved == false && e.IsSuitable);

        public IEnumerable<AnswerBusinessObject> Answers => GetAnswers();

        public IEnumerable<QuestionBusinessObject> Questions =>
            questions.Find(e => e.TestId == Test.TestId).Where(e => e.IsRemoved == false);

        #endregion

        #region Methods

        // ReSharper disable once MemberCanBeMadeStatic.Global
        // ReSharper disable once ParameterHidesMember
        public bool CheckAnswers(IEnumerable<AnswerBusinessObject> answers)
        {
            return answers.ToList().All(answer => !answer.IsSuitable || answer.IsChecked);
        }

        private IEnumerable<AnswerBusinessObject> GetAnswers(Func<AnswerBusinessObject, bool> predicate)
        {
            return answers.Find(e => e.QuestionId == CurrentQuestion.QuestionId).Where(predicate);
        }

        private IEnumerable<AnswerBusinessObject> GetAnswers()
        {
            return GetAnswers(e => e.IsRemoved == false);
        }

        #endregion
    }
}
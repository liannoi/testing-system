using System.Collections.Generic;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.PassingTest
{
    public interface IPassingTestService
    {
        IEnumerable<AnswerBusinessObject> Answers { get; }
        QuestionBusinessObject CurrentQuestion { get; set; }
        IEnumerable<QuestionBusinessObject> Questions { get; }
        int QuestionsCount { get; }
        IEnumerable<AnswerBusinessObject> SuitableAnswers { get; }
        int SuitableAnswersCount { get; }
        TestBusinessObject Test { get; set; }

        bool CheckAnswers(IEnumerable<AnswerBusinessObject> answers);
    }
}
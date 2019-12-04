using System;
using System.Collections.Generic;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;

namespace TestingSystem.Common.BL.BusinessServices.Tests.Passing
{
    public interface IPassingTestService
    {
        IEnumerable<AnswerBusinessObject> Answers { get; }
        QuestionBusinessObject CurrentQuestion { get; set; }
        IEnumerable<QuestionBusinessObject> Questions { get; }
        int QuestionsCount { get; }
        IEnumerable<AnswerBusinessObject> SuitableAnswers { get; }
        int SuitableAnswersCount { get; }
        TestAdvancedDetailsBusinessObject TestDetailsBusinessObject { get; set; }

        bool CheckAnswers(IEnumerable<AnswerBusinessObject> collection);
        void ProcessEndTest();
        IEnumerable<AnswerBusinessObject> SelectAnswers(Func<AnswerBusinessObject, bool> predicate);
        IEnumerable<QuestionBusinessObject> SelectQuestions(Func<QuestionBusinessObject, bool> predicate);
    }
}
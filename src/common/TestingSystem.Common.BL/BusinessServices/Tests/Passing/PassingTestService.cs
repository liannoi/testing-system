// Copyright 2019 Maksym Liannoi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

using Multilayer.BusinessServices;
using System;
using System.Collections.Generic;
using System.Linq;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;

namespace TestingSystem.Common.BL.BusinessServices.Tests.Passing
{
    public class PassingTestService : IPassingTestService
    {
        private readonly IBusinessService<AnswerBusinessObject> answers;
        private readonly IBusinessService<QuestionBusinessObject> questions;
        private readonly IBusinessService<StudentTestBusinessObject> studentTests;

        public PassingTestService(IBusinessService<QuestionBusinessObject> questions,
            IBusinessService<AnswerBusinessObject> answers,
            IBusinessService<StudentTestBusinessObject> studentTests)
        {
            this.questions = questions;
            this.answers = answers;
            this.studentTests = studentTests;
        }

        public TestAdvancedDetailsBusinessObject TestDetailsBusinessObject { get; set; }
        public int QuestionsCount => Questions.Count();
        public QuestionBusinessObject CurrentQuestion { get; set; }
        public int SuitableAnswersCount => SuitableAnswers.Count();

        public IEnumerable<AnswerBusinessObject> SuitableAnswers =>
            SelectAnswers(e => e.IsRemoved == false && e.IsSuitable);

        public IEnumerable<AnswerBusinessObject> Answers => SelectAnswers(e => e.IsRemoved == false);

        public IEnumerable<QuestionBusinessObject> Questions =>
            SelectQuestions(e => e.IsRemoved == false && e.TestId == TestDetailsBusinessObject.Test.TestId);

        public bool CheckAnswers(IEnumerable<AnswerBusinessObject> collection)
        {
            return collection.ToList().All(answer => !answer.IsSuitable || answer.IsChecked);
        }

        public IEnumerable<AnswerBusinessObject> SelectAnswers(Func<AnswerBusinessObject, bool> predicate)
        {
            return answers.Find(e => e.QuestionId == CurrentQuestion.QuestionId).Where(predicate);
        }

        public IEnumerable<QuestionBusinessObject> SelectQuestions(Func<QuestionBusinessObject, bool> predicate)
        {
            IEnumerable<AnswerBusinessObject> selectedAnswers = answers.Select();
            return questions
                .Find(e => e.TestId == TestDetailsBusinessObject.Test.TestId)
                .Join(selectedAnswers, c => c.QuestionId, a => a.QuestionId, (c, a) => c)
                .Where(predicate)
                .GroupBy(e => e.QuestionId)
                .Select(e => e.First());
        }

        public void ProcessEndTest()
        {
            StudentTestBusinessObject @new = TestDetailsBusinessObject.TestDetails;
            @new.RecordId = -1;
            @new.Start = TestDetailsBusinessObject.DateStart;
            @new.End = DateTime.Now;
            @new.PCA = 100;
            studentTests.Add(@new);
        }
    }
}
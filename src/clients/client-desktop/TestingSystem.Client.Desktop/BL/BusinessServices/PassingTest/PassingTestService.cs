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

        public IEnumerable<AnswerBusinessObject> Answers => GetAnswers(e => e.IsRemoved == false);

        public IEnumerable<QuestionBusinessObject> Questions => GetQuestions(e => e.IsRemoved == false && e.TestId == 7);

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

        private IEnumerable<QuestionBusinessObject> GetQuestions(Func<QuestionBusinessObject, bool> predicate)
        {
            IEnumerable<AnswerBusinessObject> selectedAnswers = answers.Select();
            return questions
                .Find(e => e.TestId == Test.TestId)
                .Join(selectedAnswers, c => c.QuestionId, a => a.QuestionId, (c, a) => c)
                .Where(predicate)
                .GroupBy(e=>e.QuestionId)
                .Select(e=>e.First());
        }

        #endregion
    }
}
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

using Client.Desktop.BL.Infrastructure.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;
using TestingSystem.Common.BL.Infrastructure.Container;

namespace TestingSystem.Common.BL.BusinessServices.Tests
{
    public class TestsService
    {
        public int CountCorrentAnswers { get; set; }
        public QuestionBusinessObject CurrentQuestion { get; set; }
        public TestBusinessObject Test { get; set; }

        public IEnumerable<QuestionBusinessObject> Questions => SelectQuestions(e => e.IsRemoved == false && e.TestId == 7);
        

        public bool IncreaseIfCorrect(IEnumerable<AnswerBusinessObject> answers)
        {
            bool result = CheckAnswers(answers);
            _ = result ? ++CountCorrentAnswers : --CountCorrentAnswers;
            return result;
        }

        public RemainQuestionsBusinessObject UpdateCounter(RemainQuestionsBusinessObject remainQuestions)
        {
            var clone = Deeper<RemainQuestionsBusinessObject, RemainQuestionsBusinessObject>.Clone(remainQuestions);
            clone.Current += 1;
            return clone;
        }

        public void UpdateQuestion(RemainQuestionsBusinessObject remainQuestions)
        {
            CurrentQuestion = Questions.Skip(remainQuestions.Current).FirstOrDefault() ?? throw new TestQuestionsOverException();
        }

        public void UpdateAnswers()
        {

        }

        private IEnumerable<QuestionBusinessObject> SelectQuestion()





        //#region Bad code

        //private IEnumerable<StudentTestBusinessObject> TestsByUser
        //{
        //    get
        //    {
        //        if (user == null) throw new ArgumentNullException();
        //        yield return StudentTests.Where(e => e.IsRemoved == false).FirstOrDefault();
        //    }
        //}
        //private IEnumerable<StudentTestBusinessObject> StudentTests => SelectStudentTests(e => e.IsRemoved == false);
        //public double AverageGrade => StudentTests.Select(e => e.PCA / 100 * 12).Average() ?? 0;
        //public IEnumerable<TestBusinessObject> Tests
        //{
        //    get
        //    {
        //        foreach (var test in TestsByUser)
        //            yield return testsBusinessService.Find(e => e.TestId == test.TestId)
        //                .Where(e => e.IsRemoved == false).FirstOrDefault();
        //    }
        //}
        //public IEnumerable<QuestionBusinessObject> Questions => SelectQuestions(e => e.IsRemoved == false && e.TestId == 7);
        //public IEnumerable<AnswerBusinessObject> Answers => SelectAnswers(e => e.IsRemoved == false);

        

        

        //// TODO: Implement.
        //public StudentTestBusinessObject EndPassing()
        //{
        //    throw new NotImplementedException();
        //}

        //private IEnumerable<StudentTestBusinessObject> SelectStudentTests(Func<StudentTestBusinessObject, bool> predicate)
        //{
        //    return studentsTestsBusinessService.Find(e => e.UserId == user.UserId).Where(predicate);
        //}

        //private IEnumerable<QuestionBusinessObject> SelectQuestions(Func<QuestionBusinessObject, bool> predicate)
        //{
        //    var selectedAnswers = answersBusinessService.Select();
        //    return questionsBusinessSerivce
        //        .Find(e => e.TestId == test.TestId)
        //        .Join(selectedAnswers, c => c.QuestionId, a => a.QuestionId, (c, a) => c)
        //        .Where(predicate)
        //        .GroupBy(e => e.QuestionId)
        //        .Select(e => e.First());
        //}

        //#endregion
    }
}
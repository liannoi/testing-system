﻿// Copyright 2019 Maksym Liannoi
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

using System.Collections.ObjectModel;
using System.Linq;
using System.Windows.Input;
using Autofac;
using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Helpers;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;
using TestingSystem.Common.BL.BusinessServices.Tests.Passing;
using TestingSystem.Common.BL.Infrastructure.Container;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Student
{
    public class StudentPassTestViewModel : BaseViewModel
    {
        private readonly ContainerConfig container;
        private IBusinessService<AnswerBusinessObject> answers;
        private int countCorrectAnswers;
        private IPassingTestService passingTestService;
        private IBusinessService<QuestionBusinessObject> questions;
        private IBusinessService<StudentTestBusinessObject> studentTests;

        public StudentPassTestViewModel(TestBusinessObject test, StudentTestBusinessObject testDetails)
        {
            Test = test;
            TestDetails = testDetails;
            container = new ContainerConfig();
            ResolveContainers();
            InitializeServices();
            InitializeProperties();
            InitializeTest();
        }

        public ICommand RespondCommand => MakeCommand(a => Respond());

        public RemainQuestionsBusinessObject RemainQuestions
        {
            get => Get<RemainQuestionsBusinessObject>();
            set => Set(value);
        }

        public QuestionBusinessObject CurrentQuestion
        {
            get => Get<QuestionBusinessObject>();
            set => Set(value);
        }

        public TestBusinessObject Test
        {
            get => Get<TestBusinessObject>();
            set => Set(value);
        }

        public StudentTestBusinessObject TestDetails { get; set; }

        public int SuitableAnswersCount
        {
            get => Get<int>();
            set => Set(value);
        }

        public ObservableCollection<AnswerBusinessObject> Answers
        {
            get => Get<ObservableCollection<AnswerBusinessObject>>();
            set => Set(value);
        }

        public int CountCorrectAnswers => countCorrectAnswers > 0 ? 0 : countCorrectAnswers;

        /// <summary>
        ///     Если ответы на вопрос, все правильные - +1.
        ///     Если хотя бы один ошибочный, то -1.
        ///     По окончанию вопросов, посчитать количество единиц и составить пропорцию.
        ///     Например, 7 вопросов,
        ///     все правильные - 7 очков - 100 %
        ///     2 очка  - ?
        ///     2 * 100 = 200 / 7 = 28.5 (%)
        ///     7 очков - 12 балов
        ///     2 очка  - ? балов
        ///     2 * 12 = 24 / 7 = 3.42 (б)
        /// </summary>
        private void Respond()
        {
            countCorrectAnswers =
                passingTestService.CheckAnswers(Answers) ? ++countCorrectAnswers : --countCorrectAnswers;
            var tmp = Deeper<RemainQuestionsBusinessObject, RemainQuestionsBusinessObject>.Clone(RemainQuestions);
            tmp.Current += 1;
            RemainQuestions = tmp;
            try
            {
                UpdateQuestion(RemainQuestions.Current);
            }
            catch (TestQuestionsOverException)
            {
                passingTestService.ProcessEndTest();
            }
        }

        private void UpdateQuestion(int skipCount = 0)
        {
            passingTestService.CurrentQuestion = passingTestService.Questions.Skip(--skipCount).FirstOrDefault() ??
                                                 throw new TestQuestionsOverException();
            CurrentQuestion = passingTestService.CurrentQuestion;
            UpdateAnswers();
        }

        private void UpdateAnswers()
        {
            SuitableAnswersCount = passingTestService.SuitableAnswersCount;
            Answers = new ObservableCollection<AnswerBusinessObject>(passingTestService.Answers);
        }

        private void InitializeTest()
        {
            UpdateQuestion();
            UpdateAnswers();
        }

        private void ResolveContainers()
        {
            questions = container.Container.Resolve<IBusinessService<QuestionBusinessObject>>();
            answers = container.Container.Resolve<IBusinessService<AnswerBusinessObject>>();
            studentTests = container.Container.Resolve<IBusinessService<StudentTestBusinessObject>>();
        }

        private void InitializeProperties()
        {
            RemainQuestions = new RemainQuestionsBusinessObject
            {
                All = passingTestService.QuestionsCount,
                Current = 1
            };
        }

        private void InitializeServices()
        {
            passingTestService = new PassingTestService(questions, answers, studentTests)
            {
                TestDetailsBusinessObject = new TestAdvancedDetailsBusinessObject
                {
                    Test = Test,
                    TestDetails = TestDetails
                }
            };
        }
    }
}
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

using Autofac;
using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Helpers;
using Multilayer.BusinessServices;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows.Input;
using TestingSystem.Client.Desktop.BL.BusinessServices.PassingTest;
using TestingSystem.Client.Desktop.BL.WindowManagementServices.EndPassingTest;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;
using TestingSystem.Common.BL.BusinessServices.Tests;
using TestingSystem.Common.BL.Infrastructure.Container;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Student
{
    public class StudentPassTestViewModel : BaseViewModel
    {
        private TestsService testsService;
        private ContainerConfig container;

        public RemainQuestionsBusinessObject RemainQuestions
        {
            get => Get<RemainQuestionsBusinessObject>();
            set => Set(value);
        }

        public StudentPassTestViewModel()
        {
            container = new ContainerConfig();
            testsService = new TestsService(container);
        }

        public ICommand RespondCommand => MakeCommand(a => Respond());

        private void Respond()
        {
            testsService.IncreaseIfCorrect(Answers);
            RemainQuestions = testsService.UpdateCounter(RemainQuestions);
            try
            {
                testsService.UpdateQuestion(RemainQuestions);




                CurrentQuestion = testsService.CurrentQuestion;

                UpdateQuestion(RemainQuestions.Current);
            }
            catch (TestQuestionsOverException)
            {
                ProcessTestEnd();
            }
        }




















        
        
        private IBusinessService<QuestionBusinessObject> questions;
        private IBusinessService<AnswerBusinessObject> answers;
        private IBusinessService<StudentTestBusinessObject> studentTests;
        private IEndPassingTestWindowManagement windowManagement;

        public StudentPassTestViewModel(TestBusinessObject test)
        {
            Test = test;
            InitializeContainers();
            ResolveContainers();
            InitializeServices();
            InitializeProperties();
            InitializeTest();
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


        private void UpdateQuestion(int skipCount = 0)
        {
            testsService.CurrentQuestion = testsService.Questions.Skip(--skipCount).FirstOrDefault() ??
                                                 throw new TestQuestionsOverException();
            CurrentQuestion = testsService.CurrentQuestion;
            UpdateAnswers();
        }

        private void UpdateAnswers()
        {
            SuitableAnswersCount = testsService.SuitableAnswers.Count();
            Answers = new ObservableCollection<AnswerBusinessObject>(testsService.Answers);
        }

        private void ProcessTestEnd()
        {
            // TODO: Return to this, again.
            windowManagement = new EndPassingTestWindowManagement();

            windowManagement.OpenWindow();
        }

        private void InitializeTest()
        {
            UpdateQuestion();
            UpdateAnswers();
        }

        private void InitializeContainers()
        {
            businessLogicContainer = new ContainerConfig();
            clientContainer = new Container.ContainerConfig();
        }

        private void ResolveContainers()
        {
            questions = businessLogicContainer.Container.Resolve<IBusinessService<QuestionBusinessObject>>();
            answers = businessLogicContainer.Container.Resolve<IBusinessService<AnswerBusinessObject>>();
            studentTests = businessLogicContainer.Container.Resolve<IBusinessService<StudentTestBusinessObject>>();
        }

        private void InitializeProperties()
        {
            RemainQuestions = new RemainQuestionsBusinessObject
            {
                All = testsService.Questions.Count(),
                Current = 1
            };
        }

        private void InitializeServices()
        {
            testsService = new TestsService(tests)
            {
                Test = Test
            };
        }
    }
}
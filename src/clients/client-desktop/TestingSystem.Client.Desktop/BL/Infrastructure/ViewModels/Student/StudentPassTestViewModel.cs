using Autofac;
using Client.Desktop.BL.Infrastructure;
using Multilayer.BusinessServices;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Input;
using TestingSystem.Client.Desktop.BL.Infrastructure.Container;
using TestingSystem.Client.Desktop.UI.BL.BusinessServices.PassingTest;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;

namespace TestingSystem.Client.Desktop.UI.BL.Infrastructure.ViewModels.Student
{
    public class StudentPassTestViewModel : BaseViewModel
    {
        #region Fields

        #region Containers

        private Common.BL.Infrastructure.ContainerConfig businessLogicContainer;
        private ContainerConfig clientContainer;

        #endregion

        #region Services

        // TODO: Replace by interface.
        private PassingTestService passingTestService;

        private IBusinessService<QuestionBusinessObject> questions;
        private IBusinessService<AnswerBusinessObject> answers;

        #endregion

        #endregion

        #region Properties

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

        public int SuitableAnswersCount
        {
            get => Get<int>();
            set => Set(value);
        }

        public IEnumerable<AnswerBusinessObject> Answers
        {
            get => Get<IEnumerable<AnswerBusinessObject>>();
            set => Set(value);
        }

        #endregion

        #region Commands

        public ICommand RespondCommand => MakeCommand(a => Respond());

        #endregion

        #region Constructors

        public StudentPassTestViewModel(TestBusinessObject test)
        {
            Test = test;
            InitializeContainers();
            ResolveContainers();
            InitializeServices();
            InitializeProperties();
            UpdateQuestion();
            PropertyChanged += StudentPassTestViewModel_PropertyChanged;
        }

        #endregion

        #region Commands implementation

        private void Respond()
        {
            if (passingTestService.CheckAnswers(Answers.ToList()))
            {
                MessageBox.Show("The answers to the question are given correctly.");
                return;
            }
            MessageBox.Show("The answers to the question are given incorrectly.");
        }

        #endregion

        #region Initializers and resolves

        private void InitializeContainers()
        {
            businessLogicContainer = new Common.BL.Infrastructure.ContainerConfig();
            clientContainer = new ContainerConfig();
        }

        private void ResolveContainers()
        {
            questions = businessLogicContainer.Container.Resolve<IBusinessService<QuestionBusinessObject>>();
            answers = businessLogicContainer.Container.Resolve<IBusinessService<AnswerBusinessObject>>();
        }

        private void InitializeProperties()
        {
            RemainQuestions = new RemainQuestionsBusinessObject
            {
                All = passingTestService.QuestionsCount
            };
        }

        private void InitializeServices()
        {
            passingTestService = new PassingTestService(questions, answers)
            {
                Test = Test
            };
        }

        #endregion

        #region Helpers

        private void UpdateQuestion()
        {
            CurrentQuestion = passingTestService.YieldQuestions.FirstOrDefault();
            passingTestService.CurrentQuestion = CurrentQuestion;
            SuitableAnswersCount = passingTestService.SuitableAnswersCount;
            Answers = passingTestService.Answers;
        }

        #endregion

        #region Debug

        private void StudentPassTestViewModel_PropertyChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
            if(e.PropertyName=="Answer")
            {
                MessageBox.Show("123");
            }
        }

        #endregion
    }
}

using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;
using Autofac;
using Client.Desktop.BL.Infrastructure;
using Multilayer.BusinessServices;
using TestingSystem.Client.Desktop.BL.BusinessServices.PassingTest;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;
using TestingSystem.Common.BL.Infrastructure.Container;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Student
{
    public class StudentPassTestViewModel : BaseViewModel
    {
        #region Constructors

        public StudentPassTestViewModel(TestBusinessObject test)
        {
            Test = test;
            InitializeContainers();
            ResolveContainers();
            InitializeServices();
            InitializeProperties();
            UpdateQuestion();
        }

        #endregion

        #region Commands

        public ICommand RespondCommand => MakeCommand(a => Respond());

        #endregion

        #region Commands implementation

        private void Respond()
        {
            if (passingTestService.CheckAnswers(Answers))
            {
                MessageBox.Show("The answers to the question are given correctly.");
                return;
            }

            MessageBox.Show("The answers to the question are given incorrectly.");
        }

        #endregion

        #region Helpers

        private void UpdateQuestion()
        {
            CurrentQuestion = passingTestService.YieldQuestions.FirstOrDefault();
            passingTestService.CurrentQuestion = CurrentQuestion;
            SuitableAnswersCount = passingTestService.SuitableAnswersCount;
            Answers = new ObservableCollection<AnswerBusinessObject>(passingTestService.Answers);
        }

        #endregion

        #region Fields

        #region Containers

        private ContainerConfig businessLogicContainer;
        private Container.ContainerConfig clientContainer;

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

        public ObservableCollection<AnswerBusinessObject> Answers
        {
            get => Get<ObservableCollection<AnswerBusinessObject>>();
            set => Set(value);
        }

        #endregion

        #region Initializers and resolves

        private void InitializeContainers()
        {
            businessLogicContainer = new ContainerConfig();
            clientContainer = new Container.ContainerConfig();
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
    }
}
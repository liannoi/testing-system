using Autofac;
using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Helpers;
using Multilayer.BusinessServices;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;
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
            InitializeTest();
        }

        #endregion

        #region Commands

        public ICommand RespondCommand => MakeCommand(a => Respond());

        #endregion

        #region Commands implementation

        /// <summary>
        /// Если ответы на вопрос, все правильные - +1.
        /// Если хотя бы один ошибочный, то -1.
        /// 
        /// По окончанию вопросов, посчитать количество единиц и составить пропорцию.
        /// 
        /// Например, 7 вопросов,
        /// все правильные - 7 очков - 100 %
        ///                  2 очка  - ?
        /// 2 * 100 = 200 / 7 = 28.5 (%)
        /// 
        /// 7 очков - 12 балов
        /// 2 очка  - ? балов
        /// 2 * 12 = 24 / 7 = 3.42 (б)
        /// </summary>
        private void Respond()
        {
            countCorrectAnswers = passingTestService.CheckAnswers(Answers) ? ++countCorrectAnswers : --countCorrectAnswers;
            RemainQuestionsBusinessObject tmp = Deeper<RemainQuestionsBusinessObject, RemainQuestionsBusinessObject>.Clone(RemainQuestions);
            tmp.Current += 1;
            RemainQuestions = tmp;
            try
            {
                UpdateQuestion(RemainQuestions.Current);
            }
            catch (TestQuestionsOverException e)
            {
                MessageBox.Show(e.Message);
            }
        }

        #endregion

        #region Helpers

        private void InitializeTest()
        {
            UpdateQuestion();
            UpdateAnswers();
        }

        private void UpdateQuestion(int skipCount = 0)
        {
            passingTestService.CurrentQuestion = passingTestService.Questions.Skip(--skipCount).FirstOrDefault() ?? throw new TestQuestionsOverException();
            CurrentQuestion = passingTestService.CurrentQuestion;
            UpdateAnswers();
        }

        private void UpdateAnswers()
        {
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

        #region Helpers

        private int countCorrectAnswers;

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

        public int CountCorrectAnswers => (countCorrectAnswers > 0) ? 0 : countCorrectAnswers;

        public float Grade => CountCorrectAnswers * 12 / RemainQuestions.All;

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
                All = passingTestService.QuestionsCount,
                Current = 1
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
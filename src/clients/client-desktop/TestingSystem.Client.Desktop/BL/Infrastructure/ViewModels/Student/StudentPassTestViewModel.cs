using Autofac;
using Client.Desktop.BL.Infrastructure;
using Multilayer.BusinessServices;
using System.Collections;
using System.Collections.Generic;
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

        public IEnumerable<QuestionBusinessObject> Questions
        {
            get => Get<IEnumerable<QuestionBusinessObject>>();
            set => Set(value);
        }

        #endregion

        #region Commands



        #endregion

        #region Constructors

        public StudentPassTestViewModel(TestBusinessObject test)
        {
            InitializeContainers();
            ResolveContainers();
            passingTestService = new PassingTestService(questions, answers)
            {
                Test = test
            };
            InitializeProperties();
        }

        #endregion

        #region Commands implementation



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
            Questions = passingTestService.Questions;
            RemainQuestions = new RemainQuestionsBusinessObject
            {
                All = passingTestService.QuestionsCount,
                Current = 1
            };
        }

        #endregion
    }
}

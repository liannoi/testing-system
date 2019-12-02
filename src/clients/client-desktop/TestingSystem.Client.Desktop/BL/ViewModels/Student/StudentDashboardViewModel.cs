using System.Collections.Generic;
using System.Linq;
using Autofac;
using Client.Desktop.BL.Infrastructure;
using Multilayer.BusinessServices;
using TestingSystem.Client.Desktop.BL.BusinessServices.Windows.TestDetails;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Tests;
using TestingSystem.Common.BL.Infrastructure.Container;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Student
{
    public sealed class StudentDashboardViewModel : BaseViewModel
    {
        #region Constructors

        public StudentDashboardViewModel(UserBusinessObject user)
        {
            User = user;
            InitializeContainers();
            ResolveContainers();
            InitializeServices();
            InitializeProperties();
        }

        #endregion

        #region Helpers

        public void ShowTestDetails()
        {
            if (SelectedTest == null) return;

            windowManager.Test = SelectedTest;
            windowManager.TestDetails = studentsTests.Find(e => e.TestId == SelectedTest.TestId).FirstOrDefault();
            windowManager.OpenWindow();
        }

        #endregion

        #region Fields

        #region Containers

        private ContainerConfig businessLogicContainer;
        private Container.ContainerConfig clientContainer;

        #endregion

        #region Services

        private ITestsService testsService;
        private IBusinessService<TestBusinessObject> tests;
        private IBusinessService<StudentTestBusinessObject> studentsTests;
        private ITestDetailsWindowManagementService windowManager;

        #endregion

        #endregion

        #region Properties

        public UserBusinessObject User
        {
            get => Get<UserBusinessObject>();
            set => Set(value);
        }

        public double AverageGrade
        {
            get => Get<double>();
            set => Set(value);
        }

        public TestBusinessObject SelectedTest
        {
            get => Get<TestBusinessObject>();
            set => Set(value);
        }

        public IEnumerable<TestBusinessObject> Tests
        {
            get => Get<IEnumerable<TestBusinessObject>>();
            set => Set(value);
        }

        #endregion

        #region Initializers and resolves

        private void InitializeProperties()
        {
            Tests = testsService.Tests;
            AverageGrade = testsService.AverageGrade;
        }

        private void InitializeServices()
        {
            testsService = new TestsService(tests, studentsTests, User);
            windowManager = new TestDetailsWindowManagementService();
        }

        private void InitializeContainers()
        {
            businessLogicContainer = new ContainerConfig();
            clientContainer = new Container.ContainerConfig();
        }

        private void ResolveContainers()
        {
            tests = businessLogicContainer.Container.Resolve<IBusinessService<TestBusinessObject>>();
            studentsTests = businessLogicContainer.Container.Resolve<IBusinessService<StudentTestBusinessObject>>();
        }

        #endregion
    }
}
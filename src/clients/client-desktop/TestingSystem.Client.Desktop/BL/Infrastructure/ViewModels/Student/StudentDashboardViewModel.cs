using Autofac;
using Client.Desktop.BL.Infrastructure;
using Multilayer.BusinessServices;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using TestingSystem.Client.Desktop.BL.BusinessServices.Tests;
using TestingSystem.Client.Desktop.BL.BusinessServices.Windows;
using TestingSystem.Client.Desktop.BL.BusinessServices.Windows.SuggestedRole;
using TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.TestDetails;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.Infrastructure.ViewModels.Student
{
    public sealed class StudentDashboardViewModel : BaseViewModel
    {
        #region Fields

        #region Containers

        private Common.BL.Infrastructure.ContainerConfig businessLogicContainer;
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
            businessLogicContainer = new Common.BL.Infrastructure.ContainerConfig();
            clientContainer = new Container.ContainerConfig();
        }

        private void ResolveContainers()
        {
            tests = businessLogicContainer.Container.Resolve<IBusinessService<TestBusinessObject>>();
            studentsTests = businessLogicContainer.Container.Resolve<IBusinessService<StudentTestBusinessObject>>();
        }

        #endregion

        #region Helpers

        public void ShowTestDetails()
        {
            if (SelectedTest == null)
            {
                return;
            }

            windowManager.Test = SelectedTest;
            windowManager.TestDetails = studentsTests.Find(e => e.TestId == SelectedTest.TestId).FirstOrDefault();
            windowManager.OpenWindow();
        }

        #endregion
    }
}

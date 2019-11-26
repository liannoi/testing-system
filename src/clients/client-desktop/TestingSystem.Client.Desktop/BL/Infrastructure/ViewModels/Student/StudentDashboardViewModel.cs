using Autofac;
using Client.Desktop.BL.Infrastructure;
using Multilayer.BusinessServices;
using System.Collections.Generic;
using TestingSystem.Client.Desktop.BL.BusinessServices.Tests;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.Infrastructure.ViewModels.Student
{
    public sealed class StudentDashboardViewModel : BaseViewModel
    {
        private Common.BL.Infrastructure.ContainerConfig businessLogicContainer;
        private Container.ContainerConfig clientContainer;
        private ITestsService testsService;
        private IBusinessService<TestBusinessObject> tests;
        private IBusinessService<StudentTestBusinessObject> studentsTests;

        public IEnumerable<TestBusinessObject> Tests
        {
            get => Get<IEnumerable<TestBusinessObject>>();
            set => Set(value);
        }

        public StudentDashboardViewModel(UserBusinessObject user)
        {
            InitializeContainers();
            ResolveContainers();
            testsService = new TestsService(tests, studentsTests, user);
            Tests = testsService.Tests;
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
    }
}

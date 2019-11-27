using Autofac;
using Client.Desktop.BL.Infrastructure;
using Multilayer.BusinessServices;
using System.Collections.Generic;
using System.Windows;
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

        public StudentDashboardViewModel(UserBusinessObject user)
        {
            User = user;
            InitializeContainers();
            ResolveContainers();
            testsService = new TestsService(tests, studentsTests, User);
            Tests = testsService.Tests;
            AverageGrade = testsService.AverageGrade;
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

        public void DoubleClickMethod()
        {
            MessageBox.Show("It is a Double Click");
            if (SelectedTest == null)
            {
                return;
            }
            MessageBox.Show($"{SelectedTest.Description} {SelectedTest.TestId}");
        }
    }
}

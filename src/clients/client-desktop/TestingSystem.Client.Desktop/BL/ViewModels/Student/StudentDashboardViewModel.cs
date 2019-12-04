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
        private ContainerConfig businessLogicContainer;
        private Container.ContainerConfig clientContainer;
        private IBusinessService<StudentTestBusinessObject> studentsTests;
        private IBusinessService<TestBusinessObject> tests;
        private ITestsService testsService;
        private ITestDetailsWindowManagementService windowManager;

        public StudentDashboardViewModel(UserBusinessObject user)
        {
            User = user;
            InitializeContainers();
            ResolveContainers();
            InitializeServices();
            InitializeProperties();
        }

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

        public void ShowTestDetails()
        {
            if (SelectedTest == null) return;
            windowManager.Test = SelectedTest;
            windowManager.TestDetails = studentsTests.Find(e => e.TestId == SelectedTest.TestId).FirstOrDefault();
            windowManager.OpenWindow();
        }

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
    }
}
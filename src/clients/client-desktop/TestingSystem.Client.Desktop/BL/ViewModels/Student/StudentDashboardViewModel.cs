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
using TestingSystem.Client.Desktop.BL.WindowManagement.TestDetails;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Tests;
using TestingSystem.Common.BL.Infrastructure.Container;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Student
{
    public sealed class StudentDashboardViewModel : BaseViewModel
    {
        private readonly ContainerConfig container;
        private IBusinessService<StudentTestBusinessObject> studentsTests;
        private IBusinessService<TestBusinessObject> tests;
        private IStudentTestsService testsService;
        private ITestDetailsWindowManagementService windowManager;

        public StudentDashboardViewModel(UserBusinessObject user)
        {
            User = user;
            container = new ContainerConfig();
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

        public StudentTestBusinessObject StudentTest
        {
            get => Get<StudentTestBusinessObject>();
            set => Set(value);
        }

        public IEnumerable<StudentTestBusinessObject> Tests
        {
            get => Get<IEnumerable<StudentTestBusinessObject>>();
            set => Set(value);
        }

        private void InitializeProperties()
        {
            Tests = testsService.Tests;
            AverageGrade = testsService.AverageGrade;
        }

        private void InitializeServices()
        {
            testsService = new StudentTestsService(studentsTests, User);
            windowManager = new TestDetailsWindowManagementService();
        }

        private void ResolveContainers()
        {
            tests = container.Container.Resolve<IBusinessService<TestBusinessObject>>();
            studentsTests = container.Container.Resolve<IBusinessService<StudentTestBusinessObject>>();
        }

        public void ShowTestDetails()
        {
            var findRecord = studentsTests.Find(e => e.RecordId == StudentTest.RecordId).FirstOrDefault();
            var findTest = tests.Find(e => e.TestId == findRecord.TestId).FirstOrDefault();
            windowManager.Test = findTest;
            windowManager.TestDetails = findRecord;
            windowManager.OpenWindow();
        }
    }
}
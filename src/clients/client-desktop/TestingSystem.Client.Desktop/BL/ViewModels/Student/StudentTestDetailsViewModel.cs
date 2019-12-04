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

using Autofac;
using Client.Desktop.BL.Infrastructure;
using System.Windows.Input;
using TestingSystem.Client.Desktop.BL.Container;
using TestingSystem.Client.Desktop.BL.WindowManagement.PassingTest;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Student
{
    public class StudentTestDetailsViewModel : BaseViewModel
    {
        private readonly ContainerConfig container;
        private readonly IPassingTestWindowManagementService windowManager;

        public StudentTestDetailsViewModel(TestBusinessObject test, StudentTestBusinessObject testDetails)
        {
            Test = test;
            TestDetails = testDetails;
            container = new ContainerConfig();
            windowManager = container.Container.Resolve<IPassingTestWindowManagementService>();
            windowManager.Test = Test;
            windowManager.TestDetails = TestDetails;
        }

        public ICommand StartTestCommand => MakeCommand(a => StartTest(), c => TestDetails.AllowToPass);

        public TestBusinessObject Test
        {
            get => Get<TestBusinessObject>();
            set => Set(value);
        }

        public StudentTestBusinessObject TestDetails
        {
            get => Get<StudentTestBusinessObject>();
            set => Set(value);
        }

        private void StartTest()
        {
            windowManager.OpenWindow();
        }
    }
}
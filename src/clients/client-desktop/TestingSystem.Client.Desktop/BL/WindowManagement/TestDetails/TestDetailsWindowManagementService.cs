﻿// Copyright 2020 Maksym Liannoi
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

using Client.Desktop.BL.Infrastructure.Windows;
using TestingSystem.Client.Desktop.BL.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Client.Desktop.BL.WindowManagement.TestDetails
{
    public class TestDetailsWindowManagementService : BaseWindowManagementService, ITestDetailsWindowManagementService
    {
        public TestBusinessObject Test { get; set; }
        public StudentTestBusinessObject TestDetails { get; set; }

        public void OpenWindow()
        {
            Strategy = new WindowsManagementStrategy<StudentTestDetailsViewModel, StudentTestDetailsWindow>(
                new StudentTestDetailsViewModel(Test, TestDetails),
                new StudentTestDetailsWindow());
            Strategy.OpenDialog();
            Strategy.CloseParent();
        }
    }
}
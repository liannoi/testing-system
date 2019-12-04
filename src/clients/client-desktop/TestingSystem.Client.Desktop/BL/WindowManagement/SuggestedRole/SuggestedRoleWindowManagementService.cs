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

using Client.Desktop.BL.Infrastructure.Windows;
using System;
using TestingSystem.Client.Desktop.BL.ViewModels.Student;
using TestingSystem.Client.Desktop.UI.Windows.Student;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Authorization;

namespace TestingSystem.Client.Desktop.BL.WindowManagement.SuggestedRole
{
    public class SuggestedRoleWindowManagementService : BaseWindowManagementService,
        ISuggestedRoleWindowManagementService
    {
        public UserBusinessObject User { get; set; }
        public AuthorizationRole Role { get; set; }

        public void OpenSuggestWindow()
        {
            switch (Role)
            {
                case AuthorizationRole.Student:
                    Strategy = new WindowsManagementStrategy<StudentDashboardViewModel, StudentDashboard>(
                        new StudentDashboardViewModel(User),
                        new StudentDashboard());
                    Strategy.Open();
                    Strategy.CloseParent();
                    break;
                case AuthorizationRole.Teacher:
                    throw new NotSupportedException("This method isn't implemented.");
                case AuthorizationRole.Administrator:
                    throw new NotSupportedException("This method isn't implemented.");
                default:
                    throw new ArgumentOutOfRangeException();
            }
        }
    }
}
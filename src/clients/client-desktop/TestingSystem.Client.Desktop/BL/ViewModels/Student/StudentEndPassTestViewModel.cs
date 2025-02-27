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

using Client.Desktop.BL.Infrastructure;
using Client.Desktop.BL.Infrastructure.Windows;
using System;
using System.Windows;
using System.Windows.Input;
using TestingSystem.Common.BL.BusinessObjects.NonEntities;

namespace TestingSystem.Client.Desktop.BL.ViewModels.Student
{
    public class StudentEndPassTestViewModel : BaseViewModel
    {
        public StudentEndPassTestViewModel(TestAdvancedDetailsBusinessObject testDetails)
        {
            TestDetails = testDetails;
            Grade = TestDetails.Grade;
            PCA = Convert.ToSingle(TestDetails.TestDetails.PCA);
        }

        public TestAdvancedDetailsBusinessObject TestDetails
        {
            get => Get<TestAdvancedDetailsBusinessObject>();
            set => Set(value);
        }

        public int Grade
        {
            get => Get<int>();
            set => Set(value);
        }

        public float PCA
        {
            get => Get<float>();
            set => Set(value);
        }
    }
}

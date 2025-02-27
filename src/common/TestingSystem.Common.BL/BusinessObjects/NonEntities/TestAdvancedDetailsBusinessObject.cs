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

using System;

namespace TestingSystem.Common.BL.BusinessObjects.NonEntities
{
    public class TestAdvancedDetailsBusinessObject
    {
        public DateTime DateStart { get; set; } = DateTime.Now;
        public StudentTestBusinessObject TestDetails { get; set; }
        public TestBusinessObject Test { get; set; }
        public int AmountQuestions { get; set; }
        public int CountCorrectAnswers { get; set; }
        public int MaxGrade { get; set; }
        public int Grade
        {
            get
            {
                int result = CountCorrectAnswers * MaxGrade / AmountQuestions;
                if (result <= 0)
                {
                    result = 1;
                }
                else if (result > MaxGrade)
                {
                    result = MaxGrade;
                }
                return result;
            }
        }
    }
}
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

using System;

namespace TestingSystem.Common.BL.BusinessObjects
{
    public sealed class StudentTestBusinessObject
    {
        public int RecordId { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public int TestId { get; set; }
        public string TestName { get; set; }
        public bool AllowToPass { get; set; }
        public double? PCA { get; set; }
        public bool IsPassed { get; set; }
        public DateTime? Start { get; set; }
        public DateTime? End { get; set; }
        public bool IsRemoved { get; set; }
    }
}
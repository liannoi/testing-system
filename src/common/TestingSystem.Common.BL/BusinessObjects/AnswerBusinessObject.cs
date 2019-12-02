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

namespace TestingSystem.Common.BL.BusinessObjects
{
    public sealed class AnswerBusinessObject
    {
        public int AnswerId { get; set; }
        public int QuestionId { get; set; }
        public string QuestionTitle { get; set; }
        public string Text { get; set; }
        public bool IsSuitable { get; set; }
        public bool IsChecked { get; set; }
        public bool IsRemoved { get; set; }
    }
}
﻿// Copyright 2019 Maksym Liannoi
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
using System.Runtime.Serialization;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.PassingTest
{
    [Serializable]
    public class TestQuestionsOverException : Exception
    {
        public TestQuestionsOverException() : base("Questions are over.") { }
        public TestQuestionsOverException(string message) : base(message) { }
        public TestQuestionsOverException(string message, Exception inner) : base(message, inner) { }
        protected TestQuestionsOverException(SerializationInfo info, StreamingContext context) : base(info, context) { }
    }
}

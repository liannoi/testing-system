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
using System.Collections.Generic;
using System.Linq;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Common.BL.BusinessServices.Tests
{
    public class TestsService : ITestsService
    {
        private readonly IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService;
        private readonly IBusinessService<TestBusinessObject> testsBusinessService;
        private readonly UserBusinessObject user;

        public TestsService(IBusinessService<TestBusinessObject> testsBusinessService,
            IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService, UserBusinessObject user)
        {
            this.testsBusinessService = testsBusinessService;
            this.studentsTestsBusinessService = studentsTestsBusinessService;
            this.user = user;
        }

        private IEnumerable<StudentTestBusinessObject> TestsByUser
        {
            get
            {
                if (user == null) throw new ArgumentNullException();
                yield return StudentTests().Where(e => e.IsRemoved == false).FirstOrDefault();
            }
        }

        public IEnumerable<TestBusinessObject> Tests
        {
            get
            {
                foreach (var test in TestsByUser)
                    yield return testsBusinessService.Find(e => e.TestId == test.TestId)
                        .Where(e => e.IsRemoved == false).FirstOrDefault();
            }
        }

        public double AverageGrade => StudentTests().Select(e => e.PCA / 100 * 12).Average() ?? 0;

        private IEnumerable<StudentTestBusinessObject> StudentTests()
        {
            return studentsTestsBusinessService.Find(e => e.UserId == user.UserId).Where(e => e.IsRemoved == false);
        }
    }
}
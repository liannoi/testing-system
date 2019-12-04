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
    public class StudentTestsService : IStudentTestsService
    {
        private readonly IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService;
        private readonly UserBusinessObject user;

        public StudentTestsService(IBusinessService<StudentTestBusinessObject> studentsTestsBusinessService,
            UserBusinessObject user)
        {
            this.studentsTestsBusinessService = studentsTestsBusinessService;
            this.user = user;
        }

        public IEnumerable<StudentTestBusinessObject> Tests
        {
            get
            {
                if (user == null) throw new ArgumentNullException();
                yield return SelectStudentTests().FirstOrDefault();
            }
        }

        public float AverageGrade => Convert.ToSingle(SelectStudentTests().Average(e => e.PCA / 100 * 12));

        private IEnumerable<StudentTestBusinessObject> SelectStudentTests(
            Func<StudentTestBusinessObject, bool> predicate)
        {
            return studentsTestsBusinessService.Find(e => e.UserId == user.UserId).Where(predicate);
        }

        private IEnumerable<StudentTestBusinessObject> SelectStudentTests()
        {
            return SelectStudentTests(e => e.IsRemoved == false);
        }
    }
}
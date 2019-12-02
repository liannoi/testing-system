﻿using System.Collections.Generic;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Common.BL.BusinessServices.Tests
{
    public interface ITestsService
    {
        IEnumerable<TestBusinessObject> Tests { get; }
        double AverageGrade { get; }
    }
}
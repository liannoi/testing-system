﻿using System;

namespace TestingSystem.BL.BusinessObjects
{
    public sealed class StudentTestBusinessObject
    {
        public int RecordId { get; set; }
        public int UserId { get; set; }
        public int TestId { get; set; }
        public bool AllowToPass { get; set; }
        public double PCA { get; set; }
        public bool IsPassed { get; set; }
        public DateTime? Start { get; set; }
        public DateTime? End { get; set; }
        public bool IsRemoved { get; set; }
    }
}

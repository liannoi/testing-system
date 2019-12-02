using System;

namespace TestingSystem.Common.BL.BusinessObjects
{
    public sealed class GroupTestBusinessObject
    {
        public int RecordId { get; set; }
        public int GroupId { get; set; }
        public string GroupName { get; set; }
        public int TestId { get; set; }
        public string TestName { get; set; }
        public bool IsPassed { get; set; }
        public DateTime? Start { get; set; }
        public DateTime? End { get; set; }
        public bool IsRemoved { get; set; }
    }
}
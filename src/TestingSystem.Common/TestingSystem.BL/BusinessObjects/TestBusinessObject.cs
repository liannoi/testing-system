using System;

namespace TestingSystem.BL.BusinessObjects
{
    public sealed class TestBusinessObject
    {
        public int TestId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public bool IsPassed { get; set; }
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public bool IsRemoved { get; set; }
    }
}

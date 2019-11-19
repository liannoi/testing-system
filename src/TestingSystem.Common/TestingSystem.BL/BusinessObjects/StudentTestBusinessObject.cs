namespace TestingSystem.BL.BusinessObjects
{
    public sealed class StudentTestBusinessObject
    {
        public int RecordId { get; set; }

        public int UserId { get; set; }

        public int TestId { get; set; }

        public bool AllowToPass { get; set; }

        public double PCA { get; set; }

        public bool IsRemoved { get; set; }
    }
}

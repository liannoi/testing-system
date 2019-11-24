namespace TestingSystem.Common.BL.BusinessObjects
{
    public sealed class QuestionBusinessObject
    {
        public int QuestionId { get; set; }
        public string Question { get; set; }
        public int TestId { get; set; }
        public string TestName { get; set; }
        public bool IsRemoved { get; set; }
    }
}

namespace TestingSystem.BL.BusinessObjects
{
    public sealed class QuestionBusinessObject
    {
        public int QuestionId { get; set; }
        public string Text { get; set; }
        public int TestId { get; set; }
        public bool IsRemoved { get; set; }
    }
}

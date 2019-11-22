namespace TestingSystem.Common.BL.BusinessObjects
{
    public sealed class AnswerBusinessObject
    {
        public int AnswerId { get; set; }
        public int QuestionId { get; set; }
        public string QuestionTitle { get; set; }
        public string Text { get; set; }
        public bool IsRemoved { get; set; }
    }
}

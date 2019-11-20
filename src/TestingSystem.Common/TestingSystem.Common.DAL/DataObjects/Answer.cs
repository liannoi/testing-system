namespace TestingSystem.Common.DAL.DataObjects
{
    using System.ComponentModel.DataAnnotations;

    public partial class Answer
    {
        public int AnswerId { get; set; }

        public int QuestionId { get; set; }

        [Required]
        [StringLength(256)]
        public string Text { get; set; }

        public bool IsRemoved { get; set; }

        public virtual Question Question { get; set; }
    }
}

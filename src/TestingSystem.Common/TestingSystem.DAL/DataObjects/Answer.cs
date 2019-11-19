namespace TestingSystem.DAL.DataObjects
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

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

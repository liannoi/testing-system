namespace TestingSystem.DAL.DataObjects
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public partial class StudentTest
    {
        [Key]
        public int RecordId { get; set; }

        public int UserId { get; set; }

        public int TestId { get; set; }

        public bool AllowToPass { get; set; }

        public double? PCA { get; set; }

        public bool IsPassed { get; set; }

        public DateTime? Start { get; set; }

        public DateTime? End { get; set; }

        public bool IsRemoved { get; set; }

        public virtual Test Test { get; set; }

        public virtual User User { get; set; }
    }
}

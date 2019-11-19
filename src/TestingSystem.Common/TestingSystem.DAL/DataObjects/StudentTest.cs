namespace TestingSystem.DAL.DataObjects
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class StudentTest
    {
        [Key]
        public int RecordId { get; set; }

        public int UserId { get; set; }

        public int TestId { get; set; }

        public bool AllowToPass { get; set; }

        public double PCA { get; set; }

        public bool IsRemoved { get; set; }

        public virtual Test Test { get; set; }

        public virtual User User { get; set; }
    }
}

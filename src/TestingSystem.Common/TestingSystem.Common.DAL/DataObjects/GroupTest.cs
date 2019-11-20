namespace TestingSystem.Common.DAL.DataObjects
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class GroupTest
    {
        [Key]
        public int RecordId { get; set; }

        public int GroupId { get; set; }

        public int TestId { get; set; }

        public bool IsPassed { get; set; }

        public DateTime? Start { get; set; }

        public DateTime? End { get; set; }

        public bool IsRemoved { get; set; }

        public virtual Group Group { get; set; }

        public virtual Test Test { get; set; }
    }
}

namespace TestingSystem.Common.DAL.DataObjects
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class Test
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Test()
        {
            GroupTests = new HashSet<GroupTest>();
            Questions = new HashSet<Question>();
            StudentTests = new HashSet<StudentTest>();
        }

        public int TestId { get; set; }

        [Required]
        [StringLength(64)]
        public string Title { get; set; }

        [StringLength(4000)]
        public string Description { get; set; }

        public bool IsRemoved { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<GroupTest> GroupTests { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Question> Questions { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<StudentTest> StudentTests { get; set; }
    }
}

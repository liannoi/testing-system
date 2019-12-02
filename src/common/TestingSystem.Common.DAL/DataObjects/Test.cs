using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace TestingSystem.Common.DAL.DataObjects
{
    public class Test
    {
        [SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Test()
        {
            GroupTests = new HashSet<GroupTest>();
            Questions = new HashSet<Question>();
            StudentTests = new HashSet<StudentTest>();
        }

        public int TestId { get; set; }

        [Required] [StringLength(256)] public string Title { get; set; }

        [StringLength(4000)] public string Description { get; set; }

        public bool IsRemoved { get; set; }

        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<GroupTest> GroupTests { get; set; }

        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Question> Questions { get; set; }

        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<StudentTest> StudentTests { get; set; }
    }
}
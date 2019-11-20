namespace TestingSystem.DAL.DataObjects
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class Group
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Group()
        {
            GroupTests = new HashSet<GroupTest>();
            Users = new HashSet<User>();
        }

        public int GroupId { get; set; }

        [Required]
        [StringLength(13)]
        public string Name { get; set; }

        public bool IsRemoved { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<GroupTest> GroupTests { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<User> Users { get; set; }
    }
}

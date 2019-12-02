using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace TestingSystem.Common.DAL.DataObjects
{
    public class User
    {
        [SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public User()
        {
            StudentTests = new HashSet<StudentTest>();
            UserRoles = new HashSet<UserRole>();
        }

        public int UserId { get; set; }

        public int? GroupId { get; set; }

        [Required] [StringLength(64)] public string FirstName { get; set; }

        [Required] [StringLength(64)] public string LastName { get; set; }

        [Required] [StringLength(64)] public string MiddleName { get; set; }

        [Column(TypeName = "date")] public DateTime Birthday { get; set; }

        [Required] [StringLength(128)] public string Email { get; set; }

        public bool IsEmailVerified { get; set; }

        [StringLength(17)] public string PhoneNumber { get; set; }

        public bool IsPhoneVerified { get; set; }

        [Required] [StringLength(128)] public string Login { get; set; }

        [Required] [StringLength(128)] public string Password { get; set; }

        public bool IsRemoved { get; set; }

        public virtual Group Group { get; set; }

        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<StudentTest> StudentTests { get; set; }

        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<UserRole> UserRoles { get; set; }
    }
}
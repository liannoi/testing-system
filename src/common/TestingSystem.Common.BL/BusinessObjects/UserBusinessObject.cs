using System;

namespace TestingSystem.Common.BL.BusinessObjects
{
    public sealed class UserBusinessObject
    {
        public int UserId { get; set; }
        public int? GroupId { get; set; }
        public string GroupName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MiddleName { get; set; }
        public DateTime Birthday { get; set; }
        public string Email { get; set; }
        public bool IsEmailVerified { get; set; }
        public string PhoneNumber { get; set; }
        public bool IsPhoneVerified { get; set; }
        public string Login { get; set; }
        public string Password { get; set; }
        public bool IsRemoved { get; set; }
    }
}

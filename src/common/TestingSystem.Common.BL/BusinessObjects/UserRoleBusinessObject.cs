namespace TestingSystem.Common.BL.BusinessObjects
{
    public sealed class UserRoleBusinessObject
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public bool IsRemoved { get; set; }
    }
}

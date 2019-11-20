namespace TestingSystem.BL.BusinessObjects
{
    public sealed class UserRolesBusinessObject
    {
        public int UserId { get; set; }
        public int RoleId { get; set; }
        public bool IsRemoved { get; set; }
    }
}

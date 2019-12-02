namespace TestingSystem.Common.BL.Infrastructure.Validators
{
    public interface IPasswordValidator
    {
        bool IsValid(string str);
    }
}
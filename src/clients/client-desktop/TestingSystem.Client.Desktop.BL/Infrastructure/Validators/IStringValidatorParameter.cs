namespace TestingSystem.Client.Desktop.BL.Infrastructure.Validators
{
    public interface IStringValidatorParameter
    {
        int MaxLength { get; set; }
        int MinLength { get; set; }
    }
}
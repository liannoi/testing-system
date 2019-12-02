namespace TestingSystem.Common.BL.Infrastructure.Validators
{
    public interface IStringValidatorParameter
    {
        // ReSharper disable once UnusedMemberInSuper.Global
        int MaxLength { get; set; }

        // ReSharper disable once UnusedMemberInSuper.Global
        int MinLength { get; set; }
    }
}
namespace TestingSystem.Client.Desktop.BL.Infrastructure.Validators
{
    public class PasswordValidator : IPasswordValidator
    {
        private readonly IStringValidatorParameter validatorParameter;

        public PasswordValidator(IStringValidatorParameter validatorParameter)
        {
            this.validatorParameter = validatorParameter;
        }

        public bool IsValid(string str)
        {
            if (str == null)
            {
                return false;
            }

            return str.Length <= validatorParameter.MaxLength && str.Length >= validatorParameter.MinLength;
        }
    }
}

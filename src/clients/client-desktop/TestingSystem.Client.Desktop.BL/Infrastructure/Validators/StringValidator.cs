namespace TestingSystem.Client.Desktop.BL.Infrastructure.Validators
{
    public class StringValidator
    {
        private readonly int minLength;
        private readonly int maxLength;

        public StringValidator(int minLength, int maxLength)
        {
            this.minLength = minLength;
            this.maxLength = maxLength;
        }

        public bool IsValid(string str)
        {
            return !string.IsNullOrEmpty(str) && str.Length <= maxLength && str.Length >= minLength;
        }

        public static bool IsValid(string str, int minLength, int maxLength)
        {
            return !string.IsNullOrEmpty(str) && str.Length <= maxLength && str.Length >= minLength;
        }
    }
}

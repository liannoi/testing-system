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
            return IsValid(str, minLength, maxLength);
        }

        public static bool IsValid(string str, int minLength, int maxLength)
        {
            if (str == null)
            {
                return false;
            }

            return str.Length <= maxLength && str.Length >= minLength;
        }
    }
}

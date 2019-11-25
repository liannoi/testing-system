using System;
using System.Runtime.Serialization;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Authentication
{
    [Serializable]
    public class InvalidAuthenticationException : Exception
    {
        public InvalidAuthenticationException() : base("Login or password is incorrect.") { }
        public InvalidAuthenticationException(string message) : base(message) { }
        public InvalidAuthenticationException(string message, Exception inner) : base(message, inner) { }
        protected InvalidAuthenticationException(SerializationInfo info, StreamingContext context) : base(info, context) { }
    }
}

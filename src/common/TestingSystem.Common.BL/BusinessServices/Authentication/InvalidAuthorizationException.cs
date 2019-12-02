using System;
using System.Runtime.Serialization;

namespace TestingSystem.Common.BL.BusinessServices.Authentication
{
    [Serializable]
    public class InvalidAuthorizationException : Exception
    {
        public InvalidAuthorizationException() : base("You don't have access.")
        {
        }

        public InvalidAuthorizationException(string message) : base(message)
        {
        }

        public InvalidAuthorizationException(string message, Exception inner) : base(message, inner)
        {
        }

        protected InvalidAuthorizationException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}
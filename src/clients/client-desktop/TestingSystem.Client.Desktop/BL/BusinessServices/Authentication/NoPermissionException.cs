using System;
using System.Runtime.Serialization;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.Authentication
{
    [Serializable]
    public class NoPermissionException : Exception
    {
        public NoPermissionException() : base("You don't have access.") { }
        public NoPermissionException(string message) : base(message) { }
        public NoPermissionException(string message, Exception inner) : base(message, inner) { }
        protected NoPermissionException(SerializationInfo info, StreamingContext context) : base(info, context) { }
    }
}

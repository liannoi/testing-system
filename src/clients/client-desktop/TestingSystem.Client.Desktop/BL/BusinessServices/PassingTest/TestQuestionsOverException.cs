using System;
using System.Runtime.Serialization;

namespace TestingSystem.Client.Desktop.BL.BusinessServices.PassingTest
{
    [Serializable]
    public class TestQuestionsOverException : Exception
    {
        public TestQuestionsOverException() : base("Questions are over.") { }
        public TestQuestionsOverException(string message) : base(message) { }
        public TestQuestionsOverException(string message, Exception inner) : base(message, inner) { }
        protected TestQuestionsOverException(SerializationInfo info, StreamingContext context) : base(info, context) { }
    }
}

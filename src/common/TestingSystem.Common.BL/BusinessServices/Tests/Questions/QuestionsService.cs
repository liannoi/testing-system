using Autofac;
using Multilayer.BusinessServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.Infrastructure.Container;

namespace TestingSystem.Common.BL.BusinessServices.Tests.Questions
{
    public class QuestionsService
    {
        private readonly ContainerConfig container;
        private IBusinessService<QuestionBusinessObject> questions;

        public TestBusinessObject Test { get; set; }
        public QuestionBusinessObject Question { get; set; }
        public IEnumerable<QuestionBusinessObject> AnswersEnumerable { get; private set; }

        public QuestionsService(ContainerConfig container)
        {
            this.container = container;
            questions = container.Container.Resolve<IBusinessService<QuestionBusinessObject>>();
            QuestionsEnumerable = questions.Select();
        }
    }
}

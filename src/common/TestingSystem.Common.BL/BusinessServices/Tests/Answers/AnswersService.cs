using Autofac;
using Multilayer.BusinessServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.Infrastructure.Container;

namespace TestingSystem.Common.BL.BusinessServices.Tests.Answers
{
    public class AnswersService
    {
        private readonly ContainerConfig container;
        private IBusinessService<AnswerBusinessObject> answers;

        public QuestionBusinessObject Question { get; set; }
        public IEnumerable<AnswerBusinessObject> AnswersEnumerable { get; private set; }

        public AnswersService(ContainerConfig container)
        {
            this.container = container;
            answers = container.Container.Resolve<IBusinessService<AnswerBusinessObject>>();
            AnswersEnumerable = answers.Select();
        }

        public bool Check()
        {
            return AnswersEnumerable.ToList().All(answer => !answer.IsSuitable || answer.IsChecked);
        }

        public void Update()
        {
            AnswersEnumerable = answers.Find(e => e.QuestionId == Question.QuestionId).Where(e => e.IsRemoved == false);
        }
    }
}

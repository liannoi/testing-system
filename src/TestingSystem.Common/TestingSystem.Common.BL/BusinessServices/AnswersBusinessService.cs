using AutoMapper;
using AutoMapper.Extensions.ExpressionMapping;
using Multilayer.BusinessServices;
using Multilayer.DataServices;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.DAL.DataObjects;

namespace TestingSystem.Common.BL.BusinessServices
{
    public class AnswersBusinessService : IBusinessService<AnswerBusinessObject>
    {
        protected readonly IDataService<Answer> dataService;
        protected readonly IMapper mapper;

        public AnswersBusinessService(IDataService<Answer> dataService)
        {
            this.dataService = dataService;
            mapper = new MapperConfiguration(cfg =>
            {
                cfg.AddExpressionMapping();
                cfg.CreateMap<Answer, AnswerBusinessObject>()
                   .ForMember(nameof(AnswerBusinessObject.QuestionTitle), o => o.MapFrom(s => s.Question.Text));
                cfg.CreateMap<AnswerBusinessObject, Answer>();
            }).CreateMapper();
        }

        public AnswerBusinessObject Add(AnswerBusinessObject entity)
        {
            Answer current = dataService.Add(mapper.Map<Answer>(entity));
            dataService.Commit();
            return mapper.Map<AnswerBusinessObject>(dataService.Select(current.AnswerId));
        }

        public IEnumerable<AnswerBusinessObject> Find(Expression<Func<AnswerBusinessObject, bool>> expression)
        {
            throw new NotImplementedException();
        }

        public AnswerBusinessObject Remove(AnswerBusinessObject entity)
        {
            Answer current = dataService.Remove(entity.AnswerId);
            dataService.Commit();
            return mapper.Map<AnswerBusinessObject>(dataService.Select(current.AnswerId));
        }

        public IEnumerable<AnswerBusinessObject> Select()
        {
            throw new NotImplementedException();
        }

        public AnswerBusinessObject Select(int id)
        {
            throw new NotImplementedException();
        }

        public AnswerBusinessObject Update(AnswerBusinessObject entity)
        {
            throw new NotImplementedException();
        }
    }
}

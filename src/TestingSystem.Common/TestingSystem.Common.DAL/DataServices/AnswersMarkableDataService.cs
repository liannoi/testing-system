using Multilayer.DataServices;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using TestingSystem.Common.DAL.DataObjects;

namespace TestingSystem.Common.DAL.DataServices
{
    public sealed class AnswersMarkableDataService : BaseDataService<Answer>
    {
        public AnswersMarkableDataService(DbContext context) : base(context)
        {
        }

        public override Answer Remove(int id)
        {
            Answer find = entities.Find(id);
            find.IsRemoved = true;
            entities.AddOrUpdate(find);
            return Select(id);
        }
    }
}

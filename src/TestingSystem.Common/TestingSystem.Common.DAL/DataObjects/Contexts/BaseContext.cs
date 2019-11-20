using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestingSystem.Common.DAL.DataObjects.Contexts
{
    public class BaseContext : DbContext
    {
        public BaseContext(string databaseAlias, Action<string > logAction) : base($"name={databaseAlias}")
        {
            InitializeDatabaseLog(logAction);
        }

        public BaseContext(string databaseAlias) : base($"name={databaseAlias}")
        {
            InitializeDatabaseLog(a => Debug.WriteLine(a));
        }

        private void InitializeDatabaseLog(Action<string> action)
        {
            Database.Log = action;
        }
    }
}

using System;
using System.Data.Entity;
using System.Diagnostics;

namespace TestingSystem.DAL.DataObjects.Context
{
    public class BaseContext : DbContext
    {
        public BaseContext(string databaseAlias, Action<string> logAction) : base($"name={databaseAlias}")
        {
            Database.Log = logAction;
        }

        public BaseContext(string databaseAlias) : base($"name={databaseAlias}")
        {
            Database.Log = a => Debug.WriteLine(a);
        }
    }
}

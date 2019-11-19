using System;
using System.Data.Entity;
using System.Diagnostics;

namespace TestingSystem.DAL.DataObjects.Context
{
    public class BaseContext : DbContext
    {
        protected BaseContext(string databaseAlias, Action<string> logAction) : base($"name={databaseAlias}")
        {
            Database.Log = logAction;
        }

        protected BaseContext(string databaseAlias) : base($"name={databaseAlias}")
        {
            Database.Log = a => Debug.WriteLine(a);
        }
    }
}

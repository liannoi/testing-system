// Copyright 2020 Maksym Liannoi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

using Multilayer.Infrastructure.Keys;
using System;
using System.Data.Entity;

namespace Multilayer.Infrastructure.Helpers
{
    public interface ITypeTools<TEntity> where TEntity : class, new()
    {
        EntityKeyAttribute FirstKeyAttribute { get; set; }
        EntityKeyAttribute SecondKeyAttribute { get; set; }
        Type Type { get; }

        TEntity Find(IDbSet<TEntity> entities, TEntity entity);
        TEntity AddOrUpdate(IDbSet<TEntity> entities, TEntity entity, bool isRemoved);
    }
}
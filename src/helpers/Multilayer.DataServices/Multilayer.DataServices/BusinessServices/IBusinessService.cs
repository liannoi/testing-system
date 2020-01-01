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

using System;
using System.Collections.Generic;
using System.Linq.Expressions;

namespace Multilayer.BusinessServices
{
    public interface IBusinessService<BTEntity> where BTEntity : class, new()
    {
        BTEntity Add(BTEntity entity);
        BTEntity Update(BTEntity oldEntity, BTEntity entity);
        IEnumerable<BTEntity> Select();
        BTEntity Select(BTEntity entity);
        BTEntity Remove(BTEntity entity);
        BTEntity Restore(BTEntity entity);
        IEnumerable<BTEntity> Find(Expression<Func<BTEntity, bool>> expression);
    }
}
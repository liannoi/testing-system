// Copyright 2019 Maksym Liannoi
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
using System.Linq;
using System.Threading.Tasks;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;
using TestingSystem.Common.BL.BusinessServices.Authentication;

namespace TestingSystem.Common.BL.BusinessServices.Authorization
{
    public class AuthorizationService : IAuthorizationService
    {
        private readonly IBusinessService<UserRoleBusinessObject> usersRolesBusinessService;

        public AuthorizationService(IBusinessService<UserRoleBusinessObject> usersRolesBusinessService)
        {
            this.usersRolesBusinessService = usersRolesBusinessService;
        }

        public UserBusinessObject User { get; set; }
        public AuthorizationRole AuthorizationRole { get; set; }

        public async Task<UserRoleBusinessObject> CheckUserPermission()
        {
            if (User == null) throw new ArgumentNullException();

            return await Task.Factory.StartNew(() =>
            {
                return usersRolesBusinessService
                           .Find(e => e.UserId == User.UserId && e.RoleId == (int) AuthorizationRole)
                           .FirstOrDefault() ?? throw new InvalidAuthorizationException();
            });
        }
    }
}
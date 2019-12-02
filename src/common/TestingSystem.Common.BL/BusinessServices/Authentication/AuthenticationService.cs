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

using System.Linq;
using System.Threading.Tasks;
using Client.Desktop.BL.Infrastructure.Helpers;
using Multilayer.BusinessServices;
using TestingSystem.Common.BL.BusinessObjects;

namespace TestingSystem.Common.BL.BusinessServices.Authentication
{
    public class AuthenticationService : IAuthenticationService
    {
        private readonly IBusinessService<UserBusinessObject> usersBusinessService;

        public AuthenticationService(IBusinessService<UserBusinessObject> usersBusinessService)
        {
            this.usersBusinessService = usersBusinessService;
        }

        public string Login { get; set; }
        public string Password { get; set; }

        public async Task<UserBusinessObject> SignInAsync()
        {
            return await Task.Factory.StartNew(() =>
            {
                Password = Md5DataTools.ToMd5Hash(Password);
                return usersBusinessService.Find(e => e.Password == Password && e.Login == Login).FirstOrDefault() ??
                       throw new InvalidAuthenticationException();
            });
        }
    }
}
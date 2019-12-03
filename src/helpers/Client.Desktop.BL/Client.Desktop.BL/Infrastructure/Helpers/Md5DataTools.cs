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
using System.Security.Cryptography;
using System.Text;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public static class Md5DataTools
    {
        public static string ToMd5(string input)
        {
            using (var mD5Hash = MD5.Create())
            {
                var result = string.Empty;
                var data = mD5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));
                return data.Aggregate(result, (current, t) => current + t.ToString("x2"));
            }
        }
    }
}
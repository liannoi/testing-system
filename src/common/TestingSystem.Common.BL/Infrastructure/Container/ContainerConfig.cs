﻿// Copyright 2019 Maksym Liannoi
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

using Autofac;

namespace TestingSystem.Common.BL.Infrastructure.Container
{
    public sealed class ContainerConfig
    {
        public ContainerConfig()
        {
            Container = Build();
        }

        public IContainer Container { get; }

        // ReSharper disable once MemberCanBeMadeStatic.Local
        private IContainer Build()
        {
            ContainerBuilder builder = new ContainerBuilder();
            builder.RegisterModule<ContainerModule>();
            return builder.Build();
        }
    }
}
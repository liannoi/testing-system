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
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace TestingSystem.Common.BL.Infrastructure.Behaviors
{
    public class PasswordBehavior : Behavior<PasswordBox>
    {
        private bool skipUpdate;

        public static DependencyProperty PasswordProperty { get; } = DependencyProperty.Register("Password",
            typeof(string), typeof(PasswordBehavior), new PropertyMetadata(default(string)));

        public string Password
        {
            get => GetValue(PasswordProperty) as string;
            set => SetValue(PasswordProperty, value);
        }

        protected override void OnAttached()
        {
            AssociatedObject.PasswordChanged += PasswordBox_PasswordChanged;
        }

        protected override void OnDetaching()
        {
            AssociatedObject.PasswordChanged -= PasswordBox_PasswordChanged;
        }

        protected override void OnPropertyChanged(DependencyPropertyChangedEventArgs e)
        {
            base.OnPropertyChanged(e);

            if (e.Property != PasswordProperty)
            {
                return;
            }

            if (skipUpdate)
            {
                return;
            }

            skipUpdate = true;
            AssociatedObject.Password = e.NewValue as string ?? throw new NullReferenceException();
            skipUpdate = false;
        }

        private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e)
        {
            skipUpdate = true;
            Password = AssociatedObject.Password;
            skipUpdate = false;
        }
    }
}
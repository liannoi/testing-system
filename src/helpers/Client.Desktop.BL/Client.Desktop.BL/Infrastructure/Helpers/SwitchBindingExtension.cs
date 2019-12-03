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
using System.Globalization;
using System.Windows;
using System.Windows.Data;
using System.Windows.Markup;

namespace Client.Desktop.BL.Infrastructure.Helpers
{
    public class SwitchBindingExtension : Binding
    {
        public SwitchBindingExtension(string path, object valueIfTrue, object valueIfFalse) : base(path)
        {
            Initialize();
            ValueIfTrue = valueIfTrue;
            ValueIfFalse = valueIfFalse;
        }

        [ConstructorArgument("valueIfTrue")] public object ValueIfTrue { get; set; }
        [ConstructorArgument("valueIfFalse")] public object ValueIfFalse { get; set; }

        private void Initialize()
        {
            ValueIfTrue = DoNothing;
            ValueIfFalse = DoNothing;
            Converter = new SwitchConverter(this);
        }

        private class SwitchConverter : IValueConverter
        {
            private readonly SwitchBindingExtension switchExtension;

            public SwitchConverter(SwitchBindingExtension switchExtension)
            {
                this.switchExtension = switchExtension;
            }

            public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
            {
                try
                {
                    var b = System.Convert.ToBoolean(value);
                    return b ? switchExtension.ValueIfTrue : switchExtension.ValueIfFalse;
                }
                catch
                {
                    return DependencyProperty.UnsetValue;
                }
            }

            public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
            {
                return DoNothing;
            }
        }
    }
}
using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace TestingSystem.Common.BL.Infrastructure.Behaviors
{
    public class PasswordBehavior : Behavior<PasswordBox>, IPasswordBehavior
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

            if (e.Property != PasswordProperty) return;
            if (skipUpdate) return;
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
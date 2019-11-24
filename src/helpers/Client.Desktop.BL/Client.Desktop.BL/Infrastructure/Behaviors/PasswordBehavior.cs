using System.Windows;
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace Client.Desktop.BL.Infrastructure.Behaviors
{
    public class PasswordBehavior : Behavior<PasswordBox>
    {
        private bool skipUpdate;

        public static DependencyProperty PasswordProperty { get; } = DependencyProperty.Register("Password", typeof(string), typeof(PasswordBehavior), new PropertyMetadata(default(string)));

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

            if (e.Property == PasswordProperty)
            {
                if (!skipUpdate)
                {
                    skipUpdate = true;
                    AssociatedObject.Password = e.NewValue as string;
                    skipUpdate = false;
                }
            }
        }

        private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e)
        {
            skipUpdate = true;
            Password = AssociatedObject.Password;
            skipUpdate = false;
        }
    }
}

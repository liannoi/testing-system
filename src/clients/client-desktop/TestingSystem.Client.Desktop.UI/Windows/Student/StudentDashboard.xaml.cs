using System.Windows;
using TestingSystem.Client.Desktop.BL.Infrastructure.ViewModels.Student;

namespace TestingSystem.Client.Desktop.UI.Windows.Student
{
    /// <summary>
    /// Interaction logic for StudentDashboard.xaml
    /// </summary>
    public partial class StudentDashboard : Window
    {
        public StudentDashboard()
        {
            InitializeComponent();
            DataContext = new StudentDashboardViewModel();
        }

        public void Load()
        {
            throw new System.NotImplementedException();
        }
    }
}

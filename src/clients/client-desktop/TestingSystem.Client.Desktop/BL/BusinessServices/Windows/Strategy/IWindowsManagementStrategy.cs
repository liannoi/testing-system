﻿namespace TestingSystem.Client.Desktop.UI.BL.BusinessServices.Windows.Strategy
{
    public interface IWindowsManagementStrategy
    {
        void CloseParent();
        void Open();
        void OpenDialog();
    }
}
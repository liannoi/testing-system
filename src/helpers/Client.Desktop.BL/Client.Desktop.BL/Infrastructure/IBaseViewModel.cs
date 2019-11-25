using Client.Desktop.BL.Infrastructure.Events;
using System.Threading;

namespace Client.Desktop.BL.Infrastructure
{
    public interface IBaseViewModel
    {
        CancellationToken CancellationToken { get; }

        event UIBusyEventHandler UIBusy;
        event UIUnfrozenEventHandler UIUnfrozen;

        void CancelRequests();
        void Dispose();
    }
}
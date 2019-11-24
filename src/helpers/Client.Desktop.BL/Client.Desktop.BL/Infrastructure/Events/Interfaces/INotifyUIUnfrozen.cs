using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Client.Desktop.BL.Infrastructure.Events.Interfaces
{
    public interface INotifyUIUnfrozen
    {
        event UIUnfrozenEventHandler UIUnfrozen;
    }
}

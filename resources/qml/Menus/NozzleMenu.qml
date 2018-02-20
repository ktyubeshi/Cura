// Copyright (c) 2017 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.8
import QtQuick.Controls 1.4

import UM 1.2 as UM
import Cura 1.0 as Cura

Menu
{
    id: menu
    title: "Nozzle"

    property int extruderIndex: 0
    property QtObject extruderStack: Cura.MachineManager.getExtruder(menu.extruderIndex)
    property bool hasExtruderStack: extruderStack != null

    Cura.NozzleModel
    {
        id: nozzleModel
    }

    Connections
    {
        target: Cura.MachineManager
        onGlobalContainerChanged: {
            menu.extruderStack = Cura.MachineManager.getExtruder(menu.extruderIndex);
        }
    }

    Instantiator
    {
        model: nozzleModel

        MenuItem
        {
            text: model.hotend_name
            checkable: true
            checked: menu.hasExtruderStack && extruderStack.variant.name == model.hotend_name
            exclusiveGroup: group
            onTriggered: {
                Cura.MachineManager.setVariantGroup(extruderIndex, model.container_node);
            }
        }

        onObjectAdded: menu.insertItem(index, object);
        onObjectRemoved: menu.removeItem(object);
    }

    ExclusiveGroup { id: group }
}

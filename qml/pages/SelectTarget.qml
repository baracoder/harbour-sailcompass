import QtQuick 2.0

import Sailfish.Silica 1.0


Page {
    id: selectTarget

    SilicaFlickable {
        anchors.fill: parent
        /*
        PullDownMenu {
            MenuItem {
                text: "From map"
            }
        }
        */
        Column {
            anchors.fill: parent
            PageHeader {
                title: "Select target"
            }
            TextField {
                id: name
                placeholderText: 'Name'
                color: Theme.primaryColor
                width: parent.width
                EnterKey.enabled: text.length > 0
                EnterKey.onClicked: lat.focus = true
            }
            TextField {
                id: lat
                placeholderText: 'Latitude'
                color: Theme.primaryColor
                width: parent.width
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.enabled: text.length > 0
                EnterKey.onClicked: lon.focus = true
            }
            TextField {
                id: lon
                placeholderText: 'Longitude'
                color: Theme.primaryColor
                width: parent.width
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.enabled: text.length > 0
                EnterKey.onClicked: buttonAdd.focus = true
            }
            Button {
                id: buttonAdd
                text: 'Add'
            }
        }
    }
}

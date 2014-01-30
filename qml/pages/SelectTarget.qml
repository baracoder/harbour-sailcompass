import QtQuick 2.0

import Sailfish.Silica 1.0


Page {
    id: selectTarget
    property alias m: model

    signal targetAdd(string name, real lat, real lon)

    ListModel {
        id: model
    }

    /*
    PullDownMenu {
        MenuItem {
            text: "From map"
        }
    }
    */
    SilicaListView {
        id: locationList
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
            onClicked: targetAdd(name.text, parseFloat(lat.text), parseFloat(lon.text))
        }

        header: Label {
            text: "Saved locations"
        }
        model: model
        delegate: BackgroundItem {
            id: delegate
            height: childrenRect.height
            Label {
                text: locationName
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right: parent.right
                color: Theme.primaryColor
            }
            Label {
                text: locationPosition
                anchors.top: locationName.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: Theme.secondaryColor
            }
        }
    }
}

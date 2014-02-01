import QtQuick 2.0

import Sailfish.Silica 1.0


Page {
    id: selectTarget
    property alias m: model

    signal targetAdd(string name, real lat, real lon)
    signal positionSelected(int position)

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
    Column {
        id: addColumn
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
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
            onClicked: {
                var fLat = parseFloat(lat.text.replace(',','.'))
                var fLon = parseFloat(lon.text.replace(',','.'))
                targetAdd(name.text, fLat, fLon)
            }
        }
    }
    SilicaListView {
        id: locationList
        ScrollDecorator {

        }
        anchors {
            top: addColumn.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        header: Label {
            text: "Saved locations"
            font.family: Theme.fontFamilyHeading
        }
        model: model
        spacing: 10
        clip: true
        delegate: BackgroundItem {
            id: delegate
            height: contentItem.childrenRect.height
            onClicked: positionSelected(lid)
            Label {
                id: locLabelName
                text: locationName + ': ' + lid
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                color: Theme.primaryColor
            }
            Label {
                text: locationPosition
                anchors {
                    top: locLabelName.bottom
                    left: parent.left
                    right: parent.right
                }
                color: Theme.secondaryColor
            }
        }
    }
}

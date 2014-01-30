/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: compassScreen
    property real azimuth
    property real targetAzimuth
    property real targetDistance
    property real lat
    property real lon
    property real horizAc
    signal savePosition
    signal selectTarget

    onAzimuthChanged: updateRose()
    onTargetAzimuthChanged: updateRose()

    function updateRose () {
        var new_value = -azimuth
        if (Math.abs(rose.rotation - new_value) > 270) {
            if (rose.rotation > new_value){
                new_value += 360.0
            } else {
                new_value -= 360.0
            }
        }
        rose.rotation = new_value
        degrees.text = azimuth + '°'
    }

    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            /*
            MenuItem {
                text: "Show map"
            }
            */
        }
        Column {
            spacing: Theme.paddingMedium
            anchors.fill: parent
            Text {
                id: degrees
                anchors.horizontalCenter: parent.horizontalCenter
                text: '--°'
                font.pixelSize: Theme.fontSizeHuge
                color: Theme.primaryColor
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'V'
                font.pixelSize: Theme.fontSizeHuge
                color: Theme.secondaryColor
            }
            Image {
                id:rose
                source: "../assets/rose.png"
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectCrop
                opacity: 0.8
                Behavior on rotation {
                    RotationAnimation {
                    }
                }
                Image {
                    id: roseTarget
                    source: "../assets/rose.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectCrop
                    width: rose.width/2
                    height: rose.height/2
                    opacity: 0.8
                    rotation: targetAzimuth
                    Behavior on rotation {
                        RotationAnimation {
                        }
                    }
                    Text {
                        id: distance
                        text: Math.round(targetDistance) + 'm'
                        color: Theme.primaryColor
                        anchors.centerIn: parent
                        font.pixelSize: Theme.fontSizeMedium
                    }
                }
            }

            Text {
                text: "Position: " + lat + ", " + lon
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
            }
            Text {
                text: "Accuracy: " + horizAc +'m'
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
            }


            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: 'Save position'
                    onClicked: savePosition()
                }
                Button {
                    text: 'Select target'
                    onClicked: selectTarget()
                }
            }
        }
    }



}






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

import QtSensors 5.0
import QtPositioning 5.0

import "pages"
import "cover"

ApplicationWindow
{
    Storage {
        id: storage
    }

    Compass {
       id: compass
       active:true
    }
    PositionSource {
        id: positionSource
        active: true
        updateInterval: 1000
    }


    initialPage: Component {
        CompassScreen {
            Component.onCompleted: {
                storage.initialize(doSetLastTarget);
            }
            id: compassScreen
            azimuth: compass.reading.azimuth
            targetAzimuth: positionSource.position.coordinate.azimuthTo(target.coordinate)
            targetDistance: positionSource.position.coordinate.distanceTo(target.coordinate)
            lat: positionSource.position.coordinate.latitude
            lon: positionSource.position.coordinate.longitude
            horizAc: positionSource.position.horizontalAccuracy

            onSavePosition: doSavePosition()
            onSelectTarget: {
                pageStack.push(selectTargetPage)
                storage.targetGetAll(function (rows) {
                    var i, item;
                    selectTargetPage.m.clear()
                    console.log('rows: '+rows.length)
                    for (i=0; i< rows.length; i++) {
                        item = rows.item(i)
                        selectTargetPage.m.append({
                            lid: item.id,
                            locationName: item.name,
                            locationPosition: item.lat + ', ' + item.lon
                        })
                        console.log(JSON.stringify(item))
                        console.log(item.name)
                    }
                });
            }
        }
    }
    cover: Component {
        CoverPage {
            id: coverPage
            azimuth: compass.reading.azimuth
            targetAzimuth: positionSource.position.coordinate.azimuthTo(target.coordinate)
            targetDistance: positionSource.position.coordinate.distanceTo(target.coordinate)

        }
    }

    SelectTarget {
        id: selectTargetPage
        onTargetAdd: doAddTarget(name, lat, lon)
        onPositionSelected: {
            storage.targetGet(position, function (row) {
                if (row) {
                    target.coordinate.latitude = row.lat
                    target.coordinate.longitude = row.lon
                    console.log('coordinates set as target')
                    pageStack.pop()
                } else {
                    console.error('no entry found')
                }
            });
        }
    }

    Location {
        id: target
        coordinate {
            latitude: 0.0
            longitude: 0.0
        }
    }

    function doSavePosition() {
        console.log('saving current position')
        storage.targetAdd(new Date().toLocaleString(),
                  positionSource.position.coordinate.latitude,
                  positionSource.position.coordinate.longitude, function () {
            console.log('location saved')
        });

    }

    function doAddTarget(name, lat, lon) {
        console.log('saving position')
        storage.targetAdd(name, lat, lon, function () {
            console.log('location saved')
            doSetLastTarget()
            pageStack.pop()
        });

    }

    function doSetLastTarget() {
        storage.targetGetLastUsed(function (row) {
            if (row) {
                target.coordinate.latitude = row.lat
                target.coordinate.longitude = row.lon
                console.log('ast coordinates set as target')
            } else {
                console.log('no last used coordiante')
            }
        });
    }

}

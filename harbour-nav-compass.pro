# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-nav-compass

CONFIG += sailfishapp

SOURCES += src/harbour-nav-compass.cpp

OTHER_FILES += qml/harbour-nav-compass.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-nav-compass.spec \
    rpm/harbour-nav-compass.yaml \
    harbour-nav-compass.desktop \
    qml/pages/CompassScreen.qml \
    qml/pages/Settings.qml \
    qml/pages/SelectTarget.qml


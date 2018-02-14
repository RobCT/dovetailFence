import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "." as L
import org.qtproject.serial 1.0
import org.qtproject.filereader 1.0
import "../javascript/jointPaths.js" as J

Rectangle {
    id: top
    objectName: "top"
    property int level: 5
    property int ardlevel: 1
    property real seeme: 1
    property var parameters
    property var paths
    property var tool
    property var material
    property var pin
    property var tail
    property var process
    property var haunches
    z: top.level

    width: 1200
    height: 740
    signal closing()
    signal retn()

    signal sndVal( string object, string value)
    Component.onDestruction: {
        //console.log("closing!")
        closing()
    }
    Component.onCompleted: {
        parameters = {length: 1, width: 1, height: 1, finger: 1, delta: 1, step: 1, thick: 1, mill: 1, tool: 1, feed: 1, plunge: 1, dovetailOverlap: 0.5, tails: [], pins: [], pinTraverse: 0, cutType: 'None', cutIndex: 0, cutCount: 0, homePos: 0 , lasttail: 0}
        var ui = {inHeight: inHeight, inStepOver:inStepOver, inThickness:inThickness, inToolDia:inToolDia, inSlip: inSlip, chkPinHeight:chkPinHeight, inPinHeight:inPinHeight, inAngle: inAngle, inh:inh, inh2:inh2, inp1:inp1, int1:int1,inp2:inp2, int2:int2,inp3:inp3, int3:int3,inp4:inp4, int4:int4,inp5:inp5, int5:int5,inp6:inp6, int6:int6,inp7:inp7, int7:int7,inp8:inp8, int8:int8,inp9:inp9, int9:int9,inp10:inp10, inLeft: inLeft, inUsed:inUsed, matplot1: matplot1, matplot2: matplot2}
        parameters.tails = [0,0,0,0,0,0,0,0,0,0, 0]
        parameters.pins= [0,0,0,0,0,0,0,0,0,0, 0]
        paths = new J.calcPaths(parameters, ui)
        tool = []
        material = []
        pin = []
        tail = []
        process = []
        haunches = []
        //console.log("testjs",paths.parameters.pinTraverse, parameters.pinTraverse)
        paths.defaultInputs()


    }
    function savedata() {
        tool[0] = "diameter"
        tool[1] = inToolDia.text
        tool[2] = "angle"
        tool[3] = inAngle.text

        pin[0] = "p1"
        pin[1] = inp1.text
        pin[2] = "p2"
        pin[3] = inp2.text
        pin[4] = "p3"
        pin[5] = inp3.text
        pin[6] = "p4"
        pin[7] = inp4.text
        pin[8] = "p5"
        pin[9] = inp5.text
        pin[10] = "p6"
        pin[11] = inp6.text
        pin[12] = "p7"
        pin[13] = inp7.text
        pin[14] = "p8"
        pin[15] = inp8.text
        pin[16] = "p9"
        pin[17] = inp9.text
        pin[18] = "p10"
        pin[19] = inp10.text

        tail[0] = "t1"
        tail[1] = int1.text
        tail[2] = "t2"
        tail[3] = int2.text
        tail[4] = "t3"
        tail[5] = int3.text
        tail[6] = "t4"
        tail[7] = int4.text
        tail[8] = "t5"
        tail[9] = int5.text
        tail[10] = "t6"
        tail[11] = int6.text
        tail[12] = "t7"
        tail[13] = int7.text
        tail[14] = "t8"
        tail[15] = int8.text
        tail[16] = "t9"
        tail[17] = int9.text


        material[0] = "thickness"
        material[1] = inThickness.text
        material[2] = "height"
        material[3] = inHeight.text

        haunches[0] = "h1"
        haunches[1] = inh.text
        haunches[2] = "h2"
        haunches[3] = inh2.text

        process[0] = "stepover"
        process[1] = inStepOver.text
        process[2] = "slip"
        process[3] = inSlip.text
        process[4] = "blind"
        process[5] = parameters.blind.toString()
        process[6] = "manual"
        process[7]= "false"
        if (chkPinHeight.checked) {
            process[7]= "true"
        }


    }
    function readData(parms) {

    }
    function parseParm(parms, ind) {
        switch (parms[ind]) {
            case "height":
                inHeight.text = parms[ind + 1]
                break
            case "thickenss":
                inThickness.text = parms[ind + 1]
                break
            case "diameter":
                inToolDia.text = parms[ind + 1]
                break
            case "angle":
                inAngle.text = parms[ind + 1]
                break
            case "p1":
                inp1.text = parms[ind + 1]
                break
            case "p2":
                inp2.text = parms[ind + 1]
                break
            case "p3":
                inp3.text = parms[ind + 1]
                break
            case "p4":
                inp4.text = parms[ind + 1]
                break
            case "p5":
                inp5.text = parms[ind + 1]
                break
            case "p6":
                inp6.text = parms[ind + 1]
                break
            case "p7":
                inp7.text = parms[ind + 1]
                break
            case "p8":
                inp8.text = parms[ind + 1]
                break
            case "p9":
                inp9.text = parms[ind + 1]
                break
            case "p10":
                inp10.text = parms[ind + 1]
                break
            case "t1":
                int1.text = parms[ind + 1]
                break
            case "t2":
                int2.text = parms[ind + 1]
                break
            case "t3":
                int3.text = parms[ind + 1]
                break
            case "t4":
                int4.text = parms[ind + 1]
                break
            case "t5":
                int5.text = parms[ind + 1]
                break
            case "t6":
                int6.text = parms[ind + 1]
                break
            case "t7":
                int7.text = parms[ind + 1]
                break
            case "t8":
                int8.text = parms[ind + 1]
                break
            case "t9":
                int9.text = parms[ind + 1]
                break
            case "h1":
                inh.text = parms[ind + 1]
                break
            case "h2":
                inh2.text = parms[ind + 1]
                break
            case "stepover":
                inStepOver.text = parms[ind + 1]
                break
            case "slip":
                inSlip.text = parms[ind + 1]
                break
            case "blind":
                inPinHeight.text = parms[ind + 1]
                break
            case "manual":
                if (parms[ind + 1] == "true") {
                    chkPinHeight.checked = true
                } else {
                    chkPinHeight.checked = false
                }

                break
        }
    }

    Grid {
        id: controls
        objectName: "controls"
        z: top.level
        opacity:  top.seeme
        width: parent.width
        height: (parent.height*0.7 )
        property int c1width: width*0.35 
        property int c2width: width*0.2 
        property int c3width: width*0.2
        property int c4width: width*0.25
        property int rheight: height/14

        // Row 1
        Rectangle {
            z: top.level
            opacity:  top.seeme
            width: controls.c1width
            height: controls.rheight
            border.color: "black"
            border.width: 0.5
            Text {
                width: parent.width*0.9
                anchors.right: parent.right
                font.weight: Font.Bold
                font.pointSize: 14
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                text: " Box Dimensions in mm"
            }
        }
        Rectangle {
            z: top.level
            opacity:  top.seeme
            width: controls.c2width
            height: controls.rheight
            border.width: 0.0
            Text {
                width: parent.width*0.9
                anchors.right: parent.right
                font.weight: Font.Bold
                font.pointSize: 14
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                text: " Layout"
            }
        }
        Rectangle {
            z: top.level
            width: controls.c3width
            height: controls.rheight
            border.width: 0.0
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
        }
        // Row 2
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inHeight
                objectName: "inHeight"

                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.3
                height: parent.height * 0.8

                placeholderText: qsTr("Height")
                onEditingFinished: {
                    top.paths.inputChanged()
                }

            }
            Text {
                anchors.right: inHeight.left
                anchors.rightMargin: parent.width*0.1
                width: parent.width*0.3
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Height"


            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inh
                objectName: "inh"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("h")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inh.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "h"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp7
                objectName: "inp7"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p7")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp7.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p7"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
            Button {
                id: btnOpen
                objectName: "btnOpen"
                width: parent.width* 0.5
                height: parent.height * 0.7
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.25
                anchors.verticalCenter: parent.verticalCenter
                text: "Open"
                onClicked: {
                    fileDialog2.visible = true
                }
            }
        }
        // Row 3
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inThickness
                objectName: "inThickness"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.3
                height: parent.height * 0.8

                placeholderText: qsTr("Thickness")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inThickness.left
                anchors.rightMargin: parent.width*0.1
                width: parent.width*0.3
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Material Thickness"

            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp1
                objectName: "inp1"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p1")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp1.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p1"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int7
                objectName: "int7"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t7")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int7.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t7"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
        }
        // Row 4
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            Text {
                width: parent.width*0.9
                anchors.right: parent.right
                font.weight: Font.Bold
                font.pointSize: 14
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                text: " Machine parameters"
            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int1
                objectName: "int1"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t1")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int1.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t1"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp8
                objectName: "inp8"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p8")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp8.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p8"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
            Button {
                id: btnArduino
                objectName: "btnArduino"
                width: parent.width* 0.5
                height: parent.height * 0.7
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.25
                anchors.verticalCenter: parent.verticalCenter
                text: "Arduino"
                onClicked: {
                    ardtop.z = 100
                    arduinocont.dat1 = matplot1.dat
                    arduinocont.dat2 = matplot2.dat
                    ards.getSerialDevice()
                }
            }
        }
        // Row 5
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inToolDia
                objectName: "inToolDia"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.3
                height: parent.height * 0.8

                placeholderText: qsTr("Tool Dia")

            }
            Text {
                anchors.right: inToolDia.left
                anchors.rightMargin: parent.width*0.1
                width: parent.width*0.3
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Cutter Diameter"

            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp2
                objectName: "inp2"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p2")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp2.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p2"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int8
                objectName: "int8"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t8")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int8.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t8"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
        }
        // Row 6
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inAngle
                objectName: "inAngle"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.3
                height: parent.height * 0.8

                placeholderText: qsTr("Tool Angle")

            }
            Text {
                anchors.right: inAngle.left
                anchors.rightMargin: parent.width*0.1
                width: parent.width*0.3
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Tool Angle"

            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int2
                objectName: "int2"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t2")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int2.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t2"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp9
                objectName: "inp9"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p9")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp9.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p9"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
            Button {
                id: btnMainSave
                objectName: "btnMainSave"
                width: parent.width* 0.5
                height: parent.height * 0.7
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.25
                anchors.verticalCenter: parent.verticalCenter
                text: "Save"
                onClicked: {
                    top.savedata()
                    fileDialog.visible = true
                }
            }
        }
        // Row 7
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inStepOver
                objectName: "inStepOver"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.3
                height: parent.height * 0.8

                placeholderText: qsTr("Step Over")

            }
            Text {
                anchors.right: inStepOver.left
                anchors.rightMargin: parent.width*0.1
                width: parent.width*0.3
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Step Over"

            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp3
                objectName: "inp3"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p3")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp3.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p3"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int9
                objectName: "int9"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t9")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int9.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t9"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
        }
        // Row 8
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inSlip
                objectName: "inSlip"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.3
                height: parent.height * 0.8

                placeholderText: qsTr("Slip")

            }
            Text {
                anchors.right: inSlip.left
                anchors.rightMargin: parent.width*0.1
                width: parent.width*0.3
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Joint Slip"

            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int3
                objectName: "int3"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t3")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int3.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t3"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp10
                objectName: "inp10"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p10")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp10.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p10"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
            Button {
                id: btnMainCancel
                objectName: "btnMainCancel"
                width: parent.width* 0.5
                height: parent.height * 0.7
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.25
                anchors.verticalCenter: parent.verticalCenter
                text: "Cancel"
            }
        }
        // Row 9
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            CheckBox {
                id: chkPinHeight
                objectName: "chkPinHeight"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.1
                height: parent.height * 0.8



            }
            Text {
                anchors.right: chkPinHeight.left
                anchors.rightMargin: parent.width*0.1
                width: parent.width*0.5
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Manually set pin height"

            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp4
                objectName: "inp4"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p4")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp4.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p4"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inh2
                objectName: "inh2"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("h2")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inh2.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "h2"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
        }
        // Row 10
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inPinHeight
                objectName: "inPinHeight"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.3
                height: parent.height * 0.8

                placeholderText: qsTr("Height")

            }
            Text {
                anchors.right: inPinHeight.left
                anchors.rightMargin: parent.width*0.1
                width: parent.width*0.3
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Pin Height"

            }
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int4
                objectName: "int4"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t4")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int4.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t4"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextEdit {
                id: teArduino
                objectName: "teArduino"

                anchors.fill: parent
                text: ""



            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
            Button {
                id: btnMainOK
                objectName: "btnMainOK"
                width: parent.width* 0.5
                height: parent.height * 0.7
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.25
                anchors.verticalCenter: parent.verticalCenter
                text: "OK"
                onClicked: {
                    top.paths.OK()
                    var rpins=[]
                    var rtails=[]
                    for (var ind = 0 ; ind < top.paths.cutPins.length; ind++) {
                        rpins[ind] = top.paths.cutPins[ind].toFixed(3).toString()
                    }
                    for (ind = 0 ; ind < top.paths.cutTails.length; ind++) {
                        rtails[ind] = top.paths.cutTails[ind].toFixed(3).toString()
                    }

                    top.savedata()
                    reader.setSaveFileData(top.tool,top.material, top.pin, top.tail, top.process, top.haunches)
                    reader.setPinsTails(rpins, rtails)
                    reader.savePinsTails()
                    reader.readPinsTails()


                }
            }
        }
        // Row 11
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp5
                objectName: "inp5"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p5")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp5.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p5"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
        }
        // Row 12
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int5
                objectName: "int5"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t5")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int5.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t5"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
            Button {
                id: btnEdit
                objectName: "btnEdit"
                width: parent.width* 0.5
                height: parent.height * 0.7
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.25
                anchors.verticalCenter: parent.verticalCenter
                text: "Edit"
            }
        }
        // Row 13
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inp6
                objectName: "inp6"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("p6")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: inp6.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "p6"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inUsed
                objectName: "inUsed"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("Used")

            }
            Text {
                anchors.right: inUsed.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Used"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
        }
        // Row 14
        Rectangle {
            width: controls.c1width
            height: controls.rheight
            border.width: 0.5
        }
        Rectangle {
            width: controls.c2width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: int6
                objectName: "int6"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("t6")
                onEditingFinished: {
                    top.paths.inputChanged()
                }
            }
            Text {
                anchors.right: int6.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "t6"

            }
        }
        Rectangle {
            width: controls.c3width
            height: controls.rheight
            border.width: 0.5
            TextField {
                id: inLeft
                objectName: "inLeft"
                anchors.right: parent.right
                anchors.rightMargin: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width*0.4
                height: parent.height * 0.8

                placeholderText: qsTr("Left")

            }
            Text {
                anchors.right: inLeft.left
                anchors.rightMargin: parent.width*0.2
                width: parent.width*0.2
                font.weight: Font.Normal
                font.pointSize: 12
                font.family: "Arial"
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                text: "Left"

            }
        }
        Rectangle {
            width: controls.c4width
            height: controls.rheight
            border.width: 0.5
        }

     }
    Rectangle {
        id: rectmp1
        z: top.level
        opacity:  top.seeme
        width: parent.width
        height: parent.height*0.15
        border.width: 0.5
        anchors.top: controls.bottom
        Canvas {
            id: matplot1
            objectName: "matplot1"
            z: top.level
            opacity:  top.seeme

            property var dat
            property var parms
            property int lmargin: 50
            property int rmargin: 50
            property int tmargin: 15
            property int bmargin: 15
            property int gwidth: width - lmargin - rmargin
            property int gheight: height - tmargin - bmargin
            property real yfact
            property real xfact
            anchors.fill: parent
            function testmp1(val) {
                inSlip.text = "testxx" + val
            }
            function xy(xval, yval) {
                return {x: xval * xfact + lmargin, y: yval * -yfact + tmargin}
            }

            onDatChanged: {
                //console.log("dat", dat[1][0], dat[1][1], dat.length);
                xfact = gwidth / dat[1][1]
                yfact = -gheight / dat[1][0]
                //console.log(xfact, yfact,dat[1][1], dat[1][0], gwidth/xfact)
                //console.log(xy(dat[0][1],dat[0][0]).x, xy(dat[0][1],dat[0][0]).y);
                //console.log(xy(dat[1][1],dat[1][0]).x, xy(dat[1][1],dat[1][0]).y);
                //console.log(xy(dat[2][1],dat[2][0]).x, xy(dat[2][1],dat[2][0]).y);
                //console.log(xy(dat[3][1],dat[3][0]).x, xy(dat[3][1],dat[3][0]).y);
                requestPaint();
            }

            onPaint: {
                // Get drawing context
                //console.log("paint")
                var context = getContext("2d");

                // Make canvas all white
                context.beginPath();
                context.clearRect(0, 0, width, height);
                context.fill();




                // Draw a line
                context.beginPath();
                context.lineWidth = 2;
                context.moveTo(xy(0,0).x, xy(0,0).y);
                context.strokeStyle = "black"
                context.fillStyle = "burlywood"


                //context.lineTo(xy(dat[2][1],dat[2][0]).x, xy(dat[2][1],dat[2][0]).y);
                //context.moveTo(xy(dat[3][1],dat[3][0]).x, xy(dat[3][1],dat[3][0]).y);
                for (var ind = 4; ind < dat.length; ind++) {

                   context.lineTo(xy(dat[ind][1],dat[ind][0]).x, xy(dat[ind][1],dat[ind][0]).y);
                }
                context.lineTo(xy(dat[2][1],dat[2][0]).x, xy(dat[2][1],dat[2][0]).y);
                context.lineTo(xy(dat[1][1],dat[1][0]).x, xy(dat[1][1],dat[1][0]).y);
                context.lineTo(xy(dat[0][1],dat[0][0]).x, xy(dat[0][1],dat[0][0]).y);
                context.lineTo(xy(0,0).x, xy(0,0).y);
                for (ind = 1 ; ind < gwidth/xfact; ind++) {
                    if (!(ind % 5)) {
                        context.moveTo(xy(ind, -gheight/yfact).x,xy(ind, -gheight/yfact).y)
                        context.lineTo(xy(ind, -gheight/yfact +3 ).x,xy(ind, -gheight/yfact + 3).y)
                    }
                    else {
                        context.moveTo(xy(ind, -gheight/yfact).x,xy(ind, -gheight/yfact).y)
                        context.lineTo(xy(ind, -gheight/yfact +2 ).x,xy(ind, -gheight/yfact + 2).y)
                    }
                }

                context.fill();
                context.stroke();


            }
        }
    }

    Rectangle {
        z: top.level
        opacity:  top.seeme

        width: parent.width
        height: parent.height*0.15
        border.width: 0.5
        anchors.top: rectmp1.bottom

        Canvas {
            id: matplot2
            objectName: "matplot2"
            z: top.level
            opacity:  top.seeme
            anchors.fill: parent
            property var dat
            property int lmargin: 50
            property int rmargin: 50
            property int tmargin: 15
            property int bmargin: 15
            property int gwidth: width - lmargin - rmargin
            property int gheight: height - tmargin - bmargin
            property real yfact: matplot1.yfact
            property real xfact: matplot1.xfact
            onDatChanged: {
                //console.log("dat2", dat[1][0], dat[1][1], dat.length);
                //xfact = gwidth / dat[1][1]
                //yfact = -gheight / dat[1][0]
                //console.log(dat[0][1],dat[0][0])
                //console.log(dat[1][1],dat[1][0])
                //console.log(dat[2][1],dat[2][0])
                //console.log(dat[3][1],dat[3][0])

                //console.log(xy(dat[0][1],dat[0][0]).x, xy(dat[0][1],dat[0][0]).y);
                //console.log(xy(dat[1][1],dat[1][0]).x, xy(dat[1][1],dat[1][0]).y);
                //console.log(xy(dat[2][1],dat[2][0]).x, xy(dat[2][1],dat[2][0]).y);
                //console.log(xy(dat[3][1],dat[3][0]).x, xy(dat[3][1],dat[3][0]).y);
                requestPaint();
            }
            function xy(xval, yval) {
                return {x: xval * xfact + lmargin, y: yval * -yfact + tmargin}
            }

            onPaint: {
                // Get drawing context
                var context = getContext("2d");

                // Make canvas all white
                context.beginPath();
                context.clearRect(0, 0, width, height);
                context.fill();




                // Draw a line
                context.beginPath();
                context.lineWidth = 2;
                context.moveTo(xy(dat[0][1],dat[0][0]).x, xy(dat[0][1],dat[0][0]).y);
                context.strokeStyle = "black"
                context.fillStyle = "black"
                context.font = "130px arial"
                for (var ind = 1 ; ind < gwidth/xfact; ind++) {
                    if (!(ind % 5)) {
                        context.moveTo(xy(ind, -gheight/yfact).x,xy(ind, -gheight/yfact).y)
                        context.lineTo(xy(ind, -gheight/yfact +3 ).x,xy(ind, -gheight/yfact + 3).y)
                        context.text(ind.toString(), xy(ind, -gheight/yfact +3.5 ).x , xy(ind, -gheight/yfact + 3.5 ))
                        context.strokeText(ind.toString(), xy(ind, -gheight/yfact +3.5 ).x , xy(ind, -gheight/yfact + 3.5 ))
                        context.fillText(ind.toString(), xy(ind, -gheight/yfact +3.5 ).x , xy(ind, -gheight/yfact + 3.5 ))

                    }
                    else {
                        context.moveTo(xy(ind, -gheight/yfact).x,xy(ind, -gheight/yfact).y)
                        context.lineTo(xy(ind, -gheight/yfact +2  ).x,xy(ind, -gheight/yfact + 2).y)
                    }
                }
                context.fillStyle = "burlywood"
                context.moveTo(xy(dat[0][1],dat[0][0]).x, xy(dat[0][1],dat[0][0]).y);

                //context.lineTo(xy(dat[2][1],dat[2][0]).x, xy(dat[2][1],dat[2][0]).y);
                //context.moveTo(xy(dat[3][1],dat[3][0]).x, xy(dat[3][1],dat[3][0]).y);
                for ( ind = 0; ind < dat.length; ind++) {

                   context.lineTo(xy(dat[ind][1],dat[ind][0]).x, xy(dat[ind][1],dat[ind][0]).y);
                }
                context.lineTo(gwidth+lmargin, gheight+tmargin);
                context.lineTo(lmargin, gheight+tmargin);
                context.lineTo(xy(dat[0][1],dat[0][0]).x, xy(dat[0][1],dat[0][0]).y);
                //context.lineTo(xy(0,0).x, xy(0,0).y);

                context.fill();
                context.stroke();

            }
        }
    }
    Rectangle {
        id: ardtop
        objectName: "ardtop"
        anchors.fill: parent
        color: "blue"
        z: top.ardlevel
        visible: true
        //L.Arduino {
         //   id: arduinocont
         //   paths: top.paths

       // }
    }
    Serial {
        id: ards
        onNewmsg: {
            //console.log("Message", ards.msg, arduinocont.msgqueue.length)
            arduinocont.msgqueue.push(ards.msg)
            arduinocont.nomsg = arduinocont.msgqueue.length
        }
        Component.onCompleted: {
            arduinocont.ser = ards
        }



    }
    FileReader {
        id: reader

    }
    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home + "/Woodwork/CNC/fj"
        selectExisting:  false
        selectMultiple: false

        onAccepted: {

            reader.setSaveFileData(top.tool,top.material, top.pin, top.tail, top.process, top.haunches)
            reader.saveData(fileDialog.fileUrls.toString().substring(7))
            visible = false
        }
        onRejected: {
            console.log("Canceled")
            Qt.quit()
        }
        Component.onCompleted: {
            visible = false

        }
    }
    FileDialog {
        id: fileDialog2
        title: "Please choose a file"
        folder: shortcuts.home + "/Woodwork/CNC/fj"
        selectExisting:  false
        selectMultiple: false
        onAccepted: {
            var ret = reader.readData(fileDialog2.fileUrls.toString().substring(7))

            for (var  ind = 0; ind < ret.length; ind = ind + 2) {
                top.parseParm(ret, ind)
            }

            visible = false
        }
        onRejected: {
            console.log("Canceled")
            Qt.quit()
        }
        Component.onCompleted: {
            visible = false

        }
    }
}


import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import QtGamepad 1.0
import Qt.labs.settings 1.0


import "../javascript/arduino.js" as C
Rectangle {
    id: part1
    objectName: "part1"
    width: parent.width
    height: parent.height
    border.width: 1
    property int cutType: 0
    property int jogType: 0
    property var cutlist//: cutType == 1 ? paths.cutPins : cutType == 2 ? paths.cutTails : paths.cutTailsReversed
    property var paths
    property var msgqueue: []
    property var nomsg: msgqueue.length
    property int eNCSTEPS: 8170
    property var ser
    property int parz: parent.z
    property var parms
    property var dat1
    property var dat2
    property var code
    onCutlistChanged: {
        messages.text = ""
        for (var ind = 0; ind < cutlist.length; ind++) {

            messages.append(cutlist[ind].toString())
        }
    }
    onNomsgChanged:  {
        //console.log("message",msgqueue.length)
        if (nomsg > 0) {
            //console.log("message")
            var msg = msgqueue.shift()
            messages.insert(0,msg)
            parseMessage(msg)
            nomsg = msgqueue.length
        }
    }
    onParzChanged:  {
        if (parz = 100) checkT.start()
        else checkT.stop()

    }
    Component.onCompleted: {
        slidePos.prevVal = slidePos.value
        parms = {setpoint: 0, encoderPos: 0, output: 0, transoutput: 0, badmsg: false, kd:0, kp: 0, ki:0, ready: false, cutType: 'None', cutIndex: 0, cutCount: 0, homePos: 0, orientation: 1 }
        var ui = {matplot3: matplot3, matplot4: matplot4, numerator1: numerator1, numerator2: numerator2, slidePos: slidePos, leTarget: leTarget, messages: messages, pcode: paths, ct: part1.cutType, cutlist: cutlist, parms: parms, parent: part1}
        var parameters = { cutType: 'None', cutIndex: 0, cutCount: 0, homePos: 0, ENCSTEPS: eNCSTEPS}
        code = new C.arduino(parameters, ui)
        //console.log(code.about)
    }
    Component.onDestruction: {
        settings.username = "bbbb"
        settings.email = ""
        settings.password = ""

    }

    function parseMessage(msg) {
        console.log(msg)
        var msg_tup = msg.split(';')[0].split(',')
        //for (var ind = 0; ind < msg_tup.length; ind++) {
         //   console.log(msg_tup[ind])
        //}
        part1.parms.badmsg = false
        switch(msg_tup[0]) {

        case '1':
            if (msg_tup[1] == 'Command without attached callback') {
              part1.parms.badmsg = true
            }
            else if (msg_tup[1] == 'Arduino has started!') {
                part1.parms.ready = true
            }
            break

        case '2':
            if (msg_tup.length == 3) {
                part1.parms.target = msg_tup[2]
                //numerator1.num1 = (part1.parms.target * 350 / part1.eNCSTEPS)
            }
            break

        case '3':
            if (msg_tup.length == 5) {
                part1.parms.encoderPos = msg_tup[1]
                part1.parms.transoutput = msg_tup[2]
                part1.parms.output = msg_tup[3]
                part1.parms.setpoint = msg_tup[4]
                numerator1.num1 = (part1.parms.setpoint * 350 / part1.eNCSTEPS).toFixed(2)
                numerator2.num2 = (part1.parms.encoderPos* 350 / part1.eNCSTEPS).toFixed(2)

            }
            break

        case '4':

        case '5':
            if (msg_tup.length == 4) {
                part1.parms.kp = msg_tup[1]
                part1.parms.kd = msg_tup[2]
                part1.parms.ki = msg_tup[3]
            }
            break
         case '7':
             if (msg_tup.length == 2) {
                 part1.parms.orientation = msg_tup[1]
             }
             break
         case '9':
             if (msg_tup.length == 1) {
                 slidePos.prevVal = part1.parms.homePos*part1.eNCSTEPS/350
                 slidePos.value = part1.parms.homePos*part1.eNCSTEPS/350
                 //console.log("home", part1.parms.homePos)
             }
             break
         case '18':
             console.log('twelve')
             var msgdet = '12'
             for (var ind = 0; ind < msg_tup.length; ind++) {
                 msgdet = msgdet + ',' + msg_tup[ind].toString()
             }
             console.log('Set Pins', msgdet)
             break
         case '19':
             console.log('thirteen')
             msgdet = '13'
             for ( ind = 0; ind < msg_tup.length; ind++) {
                 msgdet = msgdet + ',' + msg_tup[ind].toString()
             }
             console.log('Set Tails', msgdet)
        }
    }
    Settings {
        id: settings
        property string email
        property string password
        property string username


    }
    Gamepad {
        id: gamepad
        deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1
        onDeviceIdChanged: GamepadManager.setCancelConfigureButton(deviceId, GamepadManager.ButtonStart);
        onButtonOtherPressedChanged: {
            //console.log("pressed",gamepad.buttonOtherPressed)
            ser.writeMsg('11;\n')
            switch(gamepad.buttonOtherPressed) {
            case 5:
                console.log("home")
                slidePos.value = part1.parms.homePos*part1.eNCSTEPS/350
                break
            case 16:
                slidePos.value = 0
                part1.parms.homePos = 0
                ser.writeMsg('8;\n')
                break
            case 6:
                part1.cutType = 1
                sprite1.z = part1.z - 2
                sprite2.z = part1.z + 2
                //part1.code.parameters.cutType = "Pins"
                part1.code.cutType()
                break
            case 4:
                part1.cutType = 2
                sprite2.z = part1.z - 2
                sprite1.z = part1.z + 2
                part1.code.parameters.cutType = "Tails"
                part1.code.cutType()
                break
            case 15:
                ser.writeMsg('10,-1;\n')
                break
            case 2:
                ser.writeMsg('10,1;\n')
                break
            case 10:
                ser.writeMsg('10,0;\n')
                break
            case 12:
                part1.code.jog(-3)
                break
            case 14:
                part1.code.jog(-2)
                break
            case 13:
                part1.code.jog(-1)
                break
            case 1:
                part1.code.jog(1)
                break
            case 0:
                part1.code.jog(2)
                break
            case 3:
                part1.code.jog(3)
                break
            case 8:
                part1.code.prevCut()
                break
            case 9:
                part1.code.nextCut()
                break




            }
        }
        onButtonOtherReleasedChanged: {
            //console.log("released",gamepad.buttonOtherReleased)
        }
    }
    Connections {
        target: GamepadManager
        onGamepadConnected: gamepad.deviceId = deviceId
    }

    Rectangle {
        id: sprite1
        color: "transparent"
        opacity: 0.5
        border.width: 0
        visible: true
        property var tan: part1.paths.parameters.dovetailOverlap + matplot3.tmargin  * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180)
        //opacity: 0.5
        width: part1.paths.parameters.tool * matplot3.xfact
        z: 200
        height: part1.paths.parameters.blind * matplot3.yfact + matplot3.tmargin
        x: numerator1.num1 * matplot3.xfact + matplot3.lmargin - part1.paths.parameters.tool * matplot3.xfact
        y: numerator1.height + mesrect.height + parent.height* 0.02
        Canvas {
            id: sp1
            anchors.fill: parent
            onPaint: {
                //console.log("fact2",part1.paths.parameters.dovetailOverlap + (matplot3.tmargin / matplot3.yfact)  * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180), part1.paths.parameters.dovetailOverlap, (part1.paths.parameters.blind + matplot3.tmargin  ) * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180), part1.paths.parameters.toolAngle, part1.paths.parameters.blind,x+(part1.paths.parameters.blind+ matplot3.tmargin ) * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180))
                var context = getContext("2d");
                context.fillStyle = "transparent"
                context.beginPath();
                context.clearRect(0, 0, width, height);
                context.fill();
                context.beginPath();
                context.lineWidth = 2;
                context.moveTo(x + (part1.paths.parameters.dovetailOverlap + (matplot3.tmargin / matplot3.yfact)  * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180)) * matplot3.xfact, y);
                context.strokeStyle = "black"
                context.fillStyle = "lightgrey"
                context.lineTo(x+width - (part1.paths.parameters.dovetailOverlap + (matplot3.tmargin / matplot3.yfact)  * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180)) * matplot3.xfact, y)
                context.lineTo(x+width, y+height)
                context.lineTo(x, y+height)
                context.lineTo(x+(part1.paths.parameters.dovetailOverlap + (matplot3.tmargin / matplot3.yfact)  * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180)) * matplot3.xfact, y)
                context.fill()

            }
            Component.onCompleted: {
                //console.log("fact",part1.paths.parameters.tool, part1.paths.parameters.blind,x+(part1.paths.blind + matplot3.tmargin ) * Math.tan(Math.PI*part1.paths.Angle/180))
                requestPaint();
            }
        }
    }
    Rectangle {
        id: sprite2
        color: "transparent"
        opacity: 0.5
        border.width: 0
        visible: true
        //opacity: 0.5
        width: part1.paths.parameters.tool * matplot4.xfact
        z: 200
        height: part1.paths.parameters.blind * matplot4.yfact + matplot4.tmargin
        x: numerator1.num1 * matplot4.xfact + matplot4.lmargin - part1.paths.parameters.tool * matplot3.xfact
        y: numerator1.height + mesrect.height + parent.height* 0.02 + matplot3.height
        Canvas {
            id: sp2
            anchors.fill: parent
            onPaint: {
                var context = getContext("2d");
                context.fillStyle = "transparent"
                context.beginPath();
                context.clearRect(0, 0, width, height);
                context.fill();
                context.beginPath();
                context.lineWidth = 2;
                context.moveTo(x+(part1.paths.parameters.dovetailOverlap + (matplot3.tmargin / matplot3.yfact)  * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180)) * matplot4.xfact, y);
                context.strokeStyle = "black"
                context.fillStyle = "lightgrey"
                context.lineTo(x+width - (part1.paths.parameters.dovetailOverlap + (matplot3.tmargin / matplot3.yfact)  * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180)) * matplot4.xfact, y)
                context.lineTo(x+width, y+height)
                context.lineTo(x, y+height)
                context.lineTo(x+(part1.paths.parameters.dovetailOverlap + (matplot3.tmargin / matplot3.yfact)  * Math.tan(Math.PI*part1.paths.parameters.toolAngle/180)) * matplot4.xfact, y)
                context.fill()

            }
            Component.onCompleted: {
                requestPaint();
            }
        }
    }

    Timer {
        id: checkT
          interval: 300; running: false; repeat: true
            onTriggered: {
                slidePos.checkTarget()
            }
    }


    Column {
        anchors.fill: parent
        Row {
            width: parent.width
            height: parent.height * 0.2
            Button {
                id: leave
                objectName: "leave"
                width: parent.height
                height: parent.height

                text: "BACK"
                onClicked: {
                   part1.parent.z = 1
                    ser.close()
                }



            }
            Item {
                id: numerator1
                objectName: "numerator1"
                width: parent.height * 3
                height: parent.height
                property real num1: 0


                BorderImage {
                    id: bi2
                    source: "qrc:/images/shadow.png"
                    anchors.fill: num1rect
                    anchors { leftMargin: -6; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
                    border.left: 5; border.top: 5
                    border.right: 5; border.bottom: 5
                }

                Rectangle {
                    id: num1rect
                    //radius: 30
                    anchors.centerIn: parent
                    width:parent.width-3
                    height: parent.height-3
                    BorderImage {
                        id: bi
                        source: "qrc:/images/bevel30.png"
                        anchors.fill: parent
                        border.left: 5; border.top: 5
                        border.right: 5; border.bottom: 5
                    }
                    Rectangle {

                        anchors.fill: parent
                        anchors.margins: parent.height/7
                        color: "linen"
                        radius: 7

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignRight
                            anchors.rightMargin: parent.width*0.1
                            font.pixelSize: parent.height*1.2
                            font.family: "digital-7"
                            font.italic: true
                            text: numerator1.num1.toFixed(2).toString(6)
                        }
                    }
                }
            }

            Button {
                width: parent.height/2
                height: parent.height
                text: ""

            }

            Item {
                id: numerator2
                objectName: "numerator2"
                width: parent.height * 3
                height: parent.height
                property real num2: 0

                BorderImage {
                    id: bi3
                    source: "qrc:/images/shadow.png"
                    anchors.fill: num2rect
                    anchors { leftMargin: -6; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
                    border.left: 5; border.top: 5
                    border.right: 5; border.bottom: 5
                }

                Rectangle {
                    id: num2rect
                    //radius: 30
                    anchors.centerIn: parent
                    width:parent.width-3
                    height: parent.height-3
                    BorderImage {
                        id: bi4
                        source: "qrc:/images/bevel30.png"
                        anchors.fill: parent
                        border.left: 5; border.top: 5
                        border.right: 5; border.bottom: 5
                    }
                    Rectangle {

                        anchors.fill: parent
                        anchors.margins: parent.height/7
                        color: "linen"
                        radius: 7

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignRight
                            anchors.rightMargin: parent.width*0.1
                            font.pixelSize: parent.height*1.2
                            font.family: "digital-7"
                            font.italic: true
                            text: numerator2.num2.toFixed(2).toString(5)
                        }
                    }
                }
            }
            Button {

                height: parent.height
                width: parent.x + parent.width - x
                text: ""

            }


        }
    Button {

        height: parent.height * 0.02
        width: parent.width
        text: ""

    }
    Row {
        width: parent.width
        height: parent.height * 0.3
        Rectangle {
            id: mesrect
            width: parent.height
            height: parent.height
            border.width: 1
            Flickable {
                id: flickArea
                 anchors.fill: parent
                 contentWidth: messages.width; contentHeight: messages.height
                 flickableDirection: Flickable.VerticalFlick
                 clip: true
                    TextEdit {
                        id: messages

                        objectName: "messages"

                        width: mesrect.height
                        height: mesrect.height
                        wrapMode: TextEdit.Wrap

                        text: "hmmm"

                    }
            }
        }

        Rectangle {
            width: parent.width * 0.05
            height: parent.height
            border.width: 1
            Column {
                width: parent.width
                height: parent.height
                Button {
                    id: home
                    objectName: "btnHome"
                    text: "Go HOME"
                    width: parent.width
                    height: parent.height/4
                    onClicked: {
                        slidePos.value = part1.parms.homePos*part1.eNCSTEPS/350
                    }

                }
                Button {
                    id: setHhome
                    objectName: "btnSetHome"
                    text: "Set HOME"
                    width: parent.width
                    height: parent.height/4
                    onClicked: {
                                //part1.parms.homePos = part1.parms.encoderPos * 350 /part1.eNCSTEPS
                        //ser.writeMsg('10,0;\n')
                        slidePos.value = 0
                        part1.parms.homePos = 0
                        ser.writeMsg('8;\n')

                        ser.writeMsg('11;\n')


                    }

                }
                Button {
                    id: btnForward
                    objectName: "btnForward"
                    text: "<-"
                    width: parent.width
                    height: parent.height/4
                    onClicked: {
                                ser.writeMsg('6,1;\n')
                    }

                }
                Button {
                    id: btnBackward
                    objectName: "btnBackward"
                    text: "->"
                    width: parent.width
                    height: parent.height/4
                    onClicked: {
                                ser.writeMsg('6,-1;\n')
                    }

                }
            }

        }
        Column {
            width: parent.width * 0.2
            height: parent.height
            Row {
                width: parent.width
                height: parent.height/4
                Button {
                    height: parent.height
                    width: parent.width/3
                    text: "<<"
                    onClicked: {
                        ser.writeMsg('10,-1;\n')
                    }
                }
                Button {
                    height: parent.height
                    width: parent.width/3
                    text: "||"
                    onClicked: {
                        ser.writeMsg('10,0;\n')
                    }
                }
                Button {
                    height: parent.height
                    width: parent.width/3
                    text: ">>"
                    onClicked: {
                        ser.writeMsg('10,1;\n')
                    }
                }

            }
            Row {
                width: parent.width
                height: parent.height/4
                Text {
                    width: parent.width*0.6
                    height: parent.height
                    text: "GOTO"
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                }

                TextField {
                    id: leTarget
                    objectName: "letarget"
                    width: parent.width*0.4
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    onEditingFinished: {
                        slidePos.value = parseFloat(leTarget.text) * part1.eNCSTEPS/350
                    }

                }
            }
            Row {
                width: parent.width
                height: parent.height/4
                Button {
                    id: btnPins
                    objectName: "btnPins"
                    width: parent.width/2
                    height: parent.height
                    text: "Pins"
                    onClicked: {
                        part1.cutType = 1
                        sprite1.z = part1.z - 2
                        sprite2.z = part1.z + 2
                        //part1.code.parameters.cutType = "Pins"
                        part1.code.cutType()
                        var msgdet, ind, chunk
                        msgdet = '12,1,'
                        chunk = part1.cutlist.length / 5 | 0
                        console.log(chunk)
                        for (var chind = 0 ; chind < chunk  ; chind++ ) {
                            for (ind = 0; ind < 5; ind++) {
                                msgdet = msgdet + (part1.cutlist[5 * chind + ind]*part1.eNCSTEPS/350).toFixed(0).toString() + ','
                            }
                            msgdet = msgdet + '-99;\n'
                            ser.writeMsg(msgdet)
                            console.log(msgdet)
                            msgdet = '12,2,'
                        }
                        if (part1.cutlist.length % 5 > 0 ) {
                            msgdet = '12,2,'
                            for (ind = chunk * 5; ind < part1.cutlist.length; ind++) {
                                console.log(ind,chunk,part1.cutlist.length,  ind)
                                msgdet = msgdet + (part1.cutlist[ ind]*part1.eNCSTEPS/350).toFixed(0).toString() + ','
                            }
                            msgdet = msgdet + '-99;\n'
                            ser.writeMsg(msgdet)
                            console.log("remnant",msgdet)
                        }




                        //for (ind = part1.cutlist.length -1; ind >= 0; ind--) {
                        //     msgdet = msgdet + ',' + part1.cutlist[ind].toFixed(3).toString()
                        //}
                        //msgdet = msgdet + ';\n'

                        //ser.writeMsg(msgdet)
                        //ser.writeMsg('12,1,110.012,109.912,85.798,83.912,59.798, -99;\n')
                        //ser.writeMsg('12,2,57.912,33.798,31.912,7.798,7.698,-99;\n')
                        ser.writeMsg('18;\n')
                    }
                }

                Button {
                    id: btnTails
                    objectName: "btnTails"
                    width: parent.width/2
                    height: parent.height
                    text: "Tails"
                    onClicked: {
                        part1.cutType = 2
                        sprite2.z = part1.z - 2
                        sprite1.z = part1.z + 2
                        part1.code.parameters.cutType = "Tails"
                        part1.code.cutType()
                        var msgdet, ind, chunk
                        msgdet = '13,1,'
                        chunk = part1.cutlist.length / 5 | 0
                        console.log(chunk)
                        for (var chind = 0 ; chind < chunk  ; chind++ ) {
                            for (ind = 0; ind < 5; ind++) {
                                msgdet = msgdet + (part1.cutlist[5 * chind + ind]*part1.eNCSTEPS/350).toFixed(0).toString() + ','
                            }
                            msgdet = msgdet + '-99;\n'
                            ser.writeMsg(msgdet)
                            console.log(msgdet)
                            msgdet = '13,2,'
                        }
                        if (part1.cutlist.length % 5 > 0 ) {
                            msgdet = '13,2,'
                            for (ind = chunk * 5; ind < part1.cutlist.length; ind++) {
                                console.log(ind,chunk,part1.cutlist.length,  ind)
                                msgdet = msgdet + (part1.cutlist[ ind]*part1.eNCSTEPS/350).toFixed(0).toString() + ','
                            }
                            msgdet = msgdet + '-99;\n'
                            ser.writeMsg(msgdet)
                            console.log("remnant",msgdet)
                        }
                        //ser.writeMsg('6,1;\n')
                        ser.writeMsg('19;\n')
                    }
                }


            }
            Row {
                width: parent.width
                height: parent.height/4
                Button {
                    id: btnRevTails
                    objectName: "btnRevTails"
                    width: parent.width/2
                    height: parent.height
                    text: "Rev Tails"
                    onClicked: {
                        part1.cutType = 3
                        sprite2.z = part1.z - 2
                        sprite1.z = part1.z + 2
                        part1.code.parameters.cutType = "ReverseTails"
                        part1.code.cutType()
                        //ser.writeMsg('6,-1;\n')
                    }
                }
                Button {
                    width: parent.width/2
                    height: parent.height
                }
            }



        }
        Column {
            width: parent.width - 0.25 * parent.width - parent.height
            height: parent.height

            Slider {
                id: slidePos
                objectName: "slidePos"
                orientation: Qt.Horizontal
                width: parent.width
                height: parent.height * 0.2
                minimumValue: -part1.eNCSTEPS * 0.2 | 0
                maximumValue: part1.eNCSTEPS + minimumValue
                property var prevVal
                function checkTarget() {
                    if (value != prevVal) {
                        prevVal = value
                        //console.log(value,( value * 350/part1.eNCSTEPS).toString())
                        ser.writeMsg('2,' + (value * 350/part1.eNCSTEPS).toString() + ';\n')
                    }
                }
            }
            Row {
                width: parent.width
                height: parent.height*0.4
                Button {
                    id: btn3Left
                    objectName: "btn3Left"
                    width: parent.width/7
                    height: parent.height
                    text: "<<<"
                    onClicked: {
                        //part1.jogType = -3
                        part1.code.jog(-3)
                    }
                }
                Button {
                    id: btn2Left
                    objectName: "btn2Left"
                    width: parent.width/7
                    height: parent.height
                    text: "<<"
                    onClicked: {
                        //part1.jogType = -2
                        part1.code.jog(-2)
                    }
                }
                Button {
                    id: btn1Left
                    objectName: "btn1Left"
                    width: parent.width/7
                    height: parent.height
                    text: "<"
                    onClicked: {
                        //part1.jogType = -1
                        part1.code.jog(-1)
                    }
                }
                Button {
                    width: parent.width/7
                    height: parent.height
                }
                Button {
                    id: btn1Right
                    objectName: "btn1Right"
                    width: parent.width/7
                    height: parent.height
                    text: ">"
                    onClicked: {
                        //part1.jogType = 1
                        part1.code.jog(1)
                    }
                }
                Button {
                    id: btn2Right
                    objectName: "btn2Right"
                    width: parent.width/7
                    height: parent.height
                    text: ">>"
                    onClicked: {
                        //part1.jogType = 2
                        part1.code.jog(2)
                    }
                }
                Button {
                    id: btn3Right
                    objectName: "btn3Right"
                    width: parent.width/7
                    height: parent.height
                    text: ">>>"
                    onClicked: {
                        //part1.jogType = 3
                        part1.code.jog(3)
                    }
                }


            }
            Row {
                width: parent.width
                height: parent.height*0.4
                Button {
                    id: btnPrevCut
                    objectName: "btnPrevCut"
                    width: parent.width/2
                    height: parent.height
                    text: "Prev"
                    onClicked: {
                        //part1.code.prevCut()
                        if (part1.code.parameters.cutType == 'Pins') ser.writeMsg('17;\n')
                        else ser.writeMsg('15;\n')
                    }
                }
                Button {
                    id: btnNextCut
                    objectName: "btnNextCut"
                    width: parent.width/2
                    height: parent.height
                    text: "Next"
                    onClicked: {
                        if (part1.code.parameters.cutType == 'Pins') ser.writeMsg('16;\n')
                        else ser.writeMsg('14;\n')

                        //part1.code.nextCut()
                    }
                }
            }
        }

    }
    Rectangle {
        width: parent.width
        height: parent.height*0.2
        border.width: 1
        Rectangle {
            //color: "red"
            border.width: 1
            visible: true
            //opacity: 0.5
            width: 60
            z: 200
            height: parent.height * 0.5
            x: parent.x + 50
            y: parent.y
        }

        Canvas {
            id: matplot3
            objectName: "matplot3"



            property var dat: part1.dat1
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
                //console.log(xfact, yfact)
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
                context.fill();
                context.stroke();


            }
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height*0.2
        border.width: 1

        Canvas {
            id: matplot4
            objectName: "matplot4"
            //z: top.level
            //opacity:  top.seeme
            anchors.fill: parent
            property var dat: part1.dat2
            property int lmargin: 50
            property int rmargin: 50
            property int tmargin: 15
            property int bmargin: 15
            property int gwidth: width - lmargin - rmargin
            property int gheight: height - tmargin - bmargin
            property real yfact: matplot3.yfact
            property real xfact: matplot3.xfact
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
                context.fillStyle = "burlywood"


                //context.lineTo(xy(dat[2][1],dat[2][0]).x, xy(dat[2][1],dat[2][0]).y);
                //context.moveTo(xy(dat[3][1],dat[3][0]).x, xy(dat[3][1],dat[3][0]).y);
                for (var ind = 0; ind < dat.length; ind++) {

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
    }

}


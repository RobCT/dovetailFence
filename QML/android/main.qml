import QtQuick 2.5
import QtQuick.Controls 1.4
import org.qtproject.mymodules 1.0
import org.qtproject.filereader 1.0
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    id: top
    visible: true
    width: 640
    height: 480
    title: qsTr("Fence Controller")
    property var value: 0
    property var prevVal: 0
    property int eNCSTEPS: 8300
    property bool badmsg: false
    property bool ready: false
    property bool ePINS: false
    property bool eTAILS: false
    property bool eREVTAILS: false
    property var target
    property var encoderPos
    property var setpoint
    property var output
    property var transoutput
    property int pinindex
    property int tailindex
    property var kd
    property var ki
    property var kp
    property var homePos:0


    Component.onCompleted: {
        checkT.start()
    }
    Timer {
        id: checkT
          interval: 300; running: false; repeat: true
            onTriggered: {
                checkTarget()
            }
    }
    function checkTarget() {
        if (value != prevVal) {
            prevVal = value
            blue.sendMessage('2,' + (value * 350/top.eNCSTEPS).toString() + ';\n')
        }
    }
    function parseMessage(msg) {
        //console.log(msg)
        var msg_tup = msg.split(';')[0].split(',')
        //for (var ind = 0; ind < msg_tup.length; ind++) {
         //   console.log(msg_tup[ind])
        //}
        top.badmsg = false
        switch(msg_tup[0]) {

        case '1':
            if (msg_tup[1] == 'Command without attached callback') {
              top.badmsg = true
            }
            else if (msg_tup[1] == 'Arduino has started!') {
                top.ready = true
            }
            break

        case '2':
            console.log("msg2",msg)
            if (msg_tup.length == 3) {
                top.target = msg_tup[2]
                //numerator1.num1 = (top.target * 350 / part1.eNCSTEPS)
            }
            break

        case '3':
            if (msg_tup.length == 9) {
                top.encoderPos = msg_tup[1]
                top.transoutput = msg_tup[2]
                top.output = msg_tup[3]
                top.setpoint = msg_tup[4]
                if (msg_tup[6] == 1) {
                    top.pinindex = msg_tup[5]
                    if (top.pinindex > 0) {
                        tePrev.text = reader.pins[top.pinindex-1]
                    }
                    else tePrev.text = "0.00"
                    teCurr.text = reader.pins[top.pinindex]
                    teNext.text = reader.pins[top.pinindex+1]

                }
                if (msg_tup[8] == 1) {
                    top.tailindex = msg_tup[7]
                     if (top.tailindex > 0) {
                        tePrev.text = reader.tails[top.tailindex-1]
                    }
                    else tePrev.text = "0.00"
                    teCurr.text = reader.tails[top.tailindex]
                    teNext.text = reader.tails[top.tailindex+1]
                }

                numerator1.num1 = (top.setpoint * 350 / top.eNCSTEPS).toFixed(2)
                numerator2.num2 = (top.encoderPos* 350 / top.eNCSTEPS).toFixed(2)

            }
            break

        case '4':

        case '5':
            if (msg_tup.length == 4) {
                top.kp = msg_tup[1]
                top.kd = msg_tup[2]
                top.ki = msg_tup[3]
            }
            break
         case '7':
             if (msg_tup.length == 2) {
                 top.orientation = msg_tup[1]
             }
             break
         case '9':
             if (msg_tup.length == 1) {
                 top.prevVal = top.homePos*part1.eNCSTEPS/350
                 top.value = top.homePos*part1.eNCSTEPS/350
                 //console.log("home", top.homePos)
             }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }


    Rectangle {
        color: "transparent"
        anchors.fill: parent
        Column {
            anchors.fill: parent
            TextField {
                id: te1
                width: parent.width
                height: parent.height / 10
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                font.pixelSize: height*0.6
            }
            Row {
                width: parent.width
                height: parent.height / 10
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "Send"
                    onClicked:  {
                        top.value = parseFloat(te1.text) * top.eNCSTEPS/350
                    }
                }
                Button {
                    id: btnOpen
                    property bool opened: false
                    width: parent.width / 2
                    height: parent.height
                    style: ButtonStyle {
                        background: Rectangle {
                                    implicitWidth: btnOpen.width
                                    implicitHeight: btnOpen.height
                                    color: btnOpen.opened ? "green" : "red"
                                    border.width: control.activeFocus ? 2 : 1
                                    border.color: "#888"
                                    radius: 4
                                    //gradient: Gradient {
                                    //    GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                    //    GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                                    //}
                                }
                    }

                    text: "Open"
                    onClicked:  {
                        blue.openConnection()
                    }

                }
            }

            TextField {
                id: te2
                width: parent.width
                height: parent.height / 10
                font.pixelSize: height*0.6

            }
            Row {
                width: parent.width
                height: parent.height / 10
                Text {
                    id: numerator1
                    width: parent.width/2
                    height: parent.height
                    property real num1
                    text: num1.toFixed(2).toString(6)
                    font.pixelSize: width/6

                }
                Text {
                    id: numerator2
                    width: parent.width/2
                    height: parent.height
                    property real num2
                    text: num2.toFixed(2).toString(6)
                    font.pixelSize: width/6

                }
            }
            Row {
                width: parent.width
                height: parent.height / 10
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "Home"
                    onClicked:  {
                        top.value = top.homePos*top.eNCSTEPS/350
                    }
                }
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "Set Home"
                    onClicked:  {
                        top.value = 0
                        top.homePos = 0
                        blue.sendMessage('8;\n')
                    }
                }

            }
            Row {
                width: parent.width
                height: parent.height / 10
                Button {
                    width: parent.width / 6
                    height: parent.height
                    text: "<<<"
                    onClicked:  {
                        top.value = top.value - 10*top.eNCSTEPS/350
                    }
                }
                Button {
                    width: parent.width / 6
                    height: parent.height
                    text: "<<"
                    onClicked:  {
                        top.value = top.value - top.eNCSTEPS/350
                    }
                }
                Button {
                    width: parent.width / 6
                    height: parent.height
                    text: "<"
                    onClicked:  {
                        top.value = top.value - 0.1*top.eNCSTEPS/350
                    }
                }
                Button {
                    width: parent.width / 6
                    height: parent.height
                    text: ">"
                    onClicked:  {
                        top.value = top.value + 0.1*top.eNCSTEPS/350
                    }
                }
                Button {
                    width: parent.width / 6
                    height: parent.height
                    text: ">>"
                    onClicked:  {
                        top.value = top.value + top.eNCSTEPS/350
                    }
                }
                Button {
                    width: parent.width / 6
                    height: parent.height
                    text: ">>>"
                    onClicked:  {
                        top.value = top.value + 10*top.eNCSTEPS/350
                    }
                }

            }
            Row {
                width: parent.width
                height: parent.height / 10
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "GetPinsnTails"
                    onClicked:  {
                        reader.readPinsTails()
                        top.eREVTAILS = false
                        console.log(reader.pins.length, reader.tails.length)

                    }
                }
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "GetPinsnRevTails"
                    onClicked:  {
                        reader.readPinsTails()
                        top.eREVTAILS = true
                        console.log(reader.pins.length, reader.tails.length)

                    }
                }
            }
            Row {
                width: parent.width
                height: parent.height / 10
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "Pins"
                    onClicked:  {
                        top.ePINS = true
                        top.eTAILS = false
                        var msgdet, ind, chunk
                        msgdet = '12,1,'
                        chunk = reader.pins.length / 5 | 0
                        console.log(chunk)
                        for (var chind = 0 ; chind < chunk  ; chind++ ) {
                            for (ind = 0; ind < 5; ind++) {
                                msgdet = msgdet + (reader.pins[5 * chind + ind]*top.eNCSTEPS/350).toFixed(0).toString() + ','
                            }
                            msgdet = msgdet + '-99;\n'
                            blue.sendMessage(msgdet)
                            console.log(msgdet)
                            msgdet = '12,2,'
                        }
                        if (reader.pins.length % 5 > 0 ) {
                            msgdet = '12,2,'
                            for (ind = chunk * 5; ind < reader.pins.length; ind++) {
                                console.log(ind,chunk,reader.pinslength,  ind)
                                msgdet = msgdet + (reader.pins[ ind]*top.eNCSTEPS/350).toFixed(0).toString() + ','
                            }
                            msgdet = msgdet + '-99;\n'
                            blue.sendMessage(msgdet)
                            console.log("remnant",msgdet)
                        }


                        blue.sendMessage('18;\n')
                    }
                }
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "Tails"
                    onClicked:  {
                        top.ePINS = false
                        top.eTAILS = true
                        var msgdet, ind, chunk
                        if (top.eREVTAILS) {
                         msgdet = '20,1,'
                        }
                        else {
                           msgdet = '13,1,'
                        }

                        chunk = reader.tails.length / 5 | 0
                        console.log("chunky",reader.tails.length,chunk)
                        for (var chind = 0 ; chind < chunk  ; chind++ ) {
                            for (ind = 0; ind < 5; ind++) {
                                if (top.eREVTAILS) {
                                    msgdet = msgdet + (-reader.tails[5 * chind + ind]*top.eNCSTEPS/350).toFixed(0).toString() + ','
                                }
                                else {
                                    msgdet = msgdet + (reader.tails[5 * chind + ind]*top.eNCSTEPS/350).toFixed(0).toString() + ','
                                }
                            }
                            if (top.eREVTAILS) {
                                msgdet = msgdet + '99;\n'
                            }
                            else {
                                msgdet = msgdet + '-99;\n'
                            }

                            blue.sendMessage(msgdet)
                            console.log(msgdet)
                            if (top.eREVTAILS) {
                             msgdet = '20,2,'
                            }
                            else {
                               msgdet = '13,2,'
                            }

                        }
                        if (reader.tails.length % 5 > 0 ) {
                            if (top.eREVTAILS) {
                             msgdet = '20,2,'
                            }
                            else {
                               msgdet = '13,2,'
                            }

                            for (ind = chunk * 5; ind < reader.tails.length; ind++) {
                                console.log(ind,chunk,reader.tails.length,  ind)
                                if (top.eREVTAILS) {
                                   msgdet = msgdet + (-reader.tails[ ind]*top.eNCSTEPS/350).toFixed(0).toString() + ','
                                }
                                else {
                                   msgdet = msgdet + (reader.tails[ ind]*top.eNCSTEPS/350).toFixed(0).toString() + ','
                                }
                            }
                            if (top.eREVTAILS) {
                                msgdet = msgdet + '99;\n'
                            }
                            else {
                                msgdet = msgdet + '-99;\n'
                            }
                            blue.sendMessage(msgdet)
                            console.log("remnant",msgdet)
                        }


                        blue.sendMessage('19;\n')

                    }
                }


            }
            Row {
                width: parent.width
                height: parent.height / 10
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "Next"
                    onClicked:  {
                        if (top.ePINS) blue.sendMessage('16;\n')
                        else blue.sendMessage('14;\n')

                    }
                }
                Button {
                    width: parent.width / 2
                    height: parent.height
                    text: "Prev"
                    onClicked:  {
                        if (top.ePINS) blue.sendMessage('17;\n')
                        else blue.sendMessage('15;\n')
                    }
                }

            }
            Row {
                width: parent.width
                height: parent.height / 10
                TextField {
                    id: tePrev
                    width: parent.width/3
                    height: parent.height
                    font.pixelSize: height*0.6

                }
                TextField {
                    id: teCurr
                    width: parent.width/3
                    height: parent.height
                    font.pixelSize: height*0.6

                }
                TextField {
                    id: teNext
                    width: parent.width/3
                    height: parent.height
                    font.pixelSize: height*0.6

                }
            }

        }
    }
    Blue {
        id: blue
        onMessageReceived: {
            console.log(blue.msg)
            te2.text = blue.msg
            top.parseMessage(blue.msg)
        }
        onClientConnected: {
            btnOpen.opened = true
        }
        onClientDis: {
            btnOpen.opened = false
        }

    }
    FileReader {
        id: reader
    }
}


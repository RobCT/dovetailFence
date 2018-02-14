import QtQuick 2.4
Item {
    id:root
    property int colid
    property int childid
    property string role
    property var model
    property int currentIndex
    property var currentItem: model.get(currentIndex)
    signal sendCurrent(int colid, int childid, int index, var rec)
    Component.onCompleted: {
        setWidth.connect(lvtumbcol.setW)
        setHeight.connect(lvtumbcol.setH)
        sendCurrent.connect(getVals)
        tcrepindex.connect(lvtumbcol.checkIndex)
        tcrepmodel.connect(lvtumbcol._model)
        tcreprole.connect(lvtumbcol._role)
    }
    onCurrentIndexChanged: {
        sendCurrent(colid, childid,  currentIndex,  currentItem)
        //console.log("ci",currentIndex, colid)
    }

    ListView {
        id: lvtumbcol
        anchors.fill: parent
        property var inp
        property bool inhibit: true

        property int ci: currentIndex
        property var cit: currentItem
        property string role: parent.role

        property var mod: alt

        property var altmod
        clip: true
        //move: Transition {
        //    NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
        //    NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
        //}
        //populate: Transition {
        //    NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
        //    NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
       // }

        //displaced: Transition {
        //    NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
        //}
        snapMode: ListView.SnapOneItem
        delegate: lvdelegate
        //highlight: highlight
        verticalLayoutDirection: ListView.BottomToTop

        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: y+height/3
        preferredHighlightEnd: y + height*2/3


        function setW(w) {
            root.width = w
        }
        function setH(h) {
            root.height = h
        }


        function checkIndex(ind, cid) {

            if (ind != root.currentIndex && cid == root.colid) {
                root.currentIndex = ind
                setupRotators()
            }
    }
        function _model(mod, cid) {
            if ( cid == root.colid) {
                root.model = mod
                setupRotators()

            }
        }
        function _role(rol, cid) {
            if ( cid == root.colid) {
                root.role = rol
            }
        }
        function setupRotators() {
            inhibit = true
            //alt.clear()
            lvtumbcol.currentIndex = 1
            if (root.currentIndex > 0 && root.currentIndex <= root.model.count - 2) {
                alt.set(0,root.model.get(root.currentIndex-1))
                alt.set(1,root.model.get(root.currentIndex))
                alt.set(2, root.model.get(root.currentIndex+1))
                //console.log(alt.get(0).disp,alt.get(1).disp,alt.get(2).disp)
            }
            else if (root.currentIndex == 0){

                 alt.set(0,root.model.get(root.model.count - 1))
                alt.set(1,root.model.get(root.currentIndex))
               alt.set(2,root.model.get(root.currentIndex+1))
            }
            else if (root.currentIndex == root.model.count - 1){
                alt.set(0,root.model.get(root.currentIndex - 1))
                alt.set(1,root.model.get(root.currentIndex))
                    alt.set(2,root.model.get(0))

            }
            lvtumbcol.currentIndex = 0
            
            model = alt
            inhibit = false
	    lvtumbcol.currentIndex = 1
	    



        }



        onCurrentIndexChanged: {

            slo.start()
            //if (!lvtumbcol.inhibit)
            //lvtumbcol.ic()

        }

        Component.onCompleted: {

            setupRotators()
	    lvtumbcol.positionViewAtIndex(lvtumbcol.currentIndex, ListView.SnapPosition)




        }
        function ic() {
            if (!inhibit && (lvtumbcol.currentIndex != (alt.count/2 | 0 + 1)) ) {

            if (currentIndex == 2) {

                root.currentIndex = root.currentIndex + (lvtumbcol.currentIndex - alt.count/2 | 0 + 1)
            }
            else if (currentIndex == 0) {
                if (root.currentIndex == 0) {
                    root.currentIndex = root.model.count -1
                }
                else root.currentIndex = root.currentIndex + (lvtumbcol.currentIndex - alt.count/2 | 0 + 1)
            }
            if (root.currentIndex > root.model.count -1) {

                root.currentIndex = 0
            }

            setupRotators()
	    
            }

        }

    Component {
        id: highlight
        Rectangle {
            color: "lightsteelblue"
            width: lvtumbcol.width
            height: lvtumbcol.height
       }
    }
    Component {
        id: lvdelegate
        Item {
            id: deltop
            width: lvtumbcol.width
            height: lvtumbcol.height/3

            property int currentIndex: ListView.view.ci
            property var currentItem: ListView.view.cit
            property string role: ListView.view.role

            property var model: ListView.view.mod
            BorderImage {
                id: bi2
                source: "images/shadow.png"
                anchors.fill: delrect
                anchors { leftMargin: -6; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
                border.left: 5; border.top: 5
                border.right: 5; border.bottom: 5
            }

            Rectangle {
                id: delrect
                //radius: 30
                anchors.centerIn: parent
                width:parent.width-3
                height: parent.height-3
                BorderImage {
                    id: bi
                    source: "images/bevel30.png"
                    anchors.fill: parent
                    border.left: 5; border.top: 5
                    border.right: 5; border.bottom: 5
                }
                //color: "white"
                //border.width: 0.5


                //border.color: "grey"
                //visible: deltop.currentIndex == index ? true : false
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: parent.height*0.4
                    text: deltop.model.get(index)[deltop.role]
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {

                        if (index == deltop.currentIndex - 1) {
                            lvtumbcol.currentIndex += 1
                        }
                        else if (index == deltop.currentIndex + 1) {
                            lvtumbcol.currentIndex -= 1
                        }
                    }
                    onPressAndHold: {

                        if (index == deltop.currentIndex - 1) {
                            repp.start()
                        }
                        else if (index == deltop.currentIndex + 1) {
                            repm.start()
                        }
                    }
                    onPressedChanged:   {

                        if (!pressed) {

                        repp.stop()
                        repm.stop()
                        }
                    }
                }
                Timer {
                    id: repp
                    interval: 200; running: false; repeat: true
                    onTriggered: {

                            lvtumbcol.currentIndex += 1
                            restart()
                    }
                }
                Timer {
                    id: repm
                    interval: 200; running: false; repeat: true
                    onTriggered: {

                            lvtumbcol.currentIndex -= 1
                            restart()
                    }
                }

        }
        }
    }
    Timer {
        id: slo
        interval: 250; running: false; repeat: false
        onTriggered: {
            if (!lvtumbcol.inhibit)
            lvtumbcol.ic()
        }
    }


    ListModel {
        id: alt
    }

}
}


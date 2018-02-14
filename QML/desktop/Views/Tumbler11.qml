import QtQuick 2.4
import QtQuick.Controls 1.3

Rectangle {
    id: eventRect
    property var _tumbColArr: []
    property var _tumbColCount
    property bool ready: false


    signal setWidth(real wdth)
    signal setHeight(real ht)
    signal setCurrentIndex(var vals)
    signal tcrepindex(int ind, int colid)
    signal tcrepmodel(var mod, int colid)
    signal tcreprole(string rol, int colid)
    //color: "linen"
    function getVals(cid,chid,ind, val){
        //console.log(cid,chid,ind)
        children[chid].currentIndex = ind
        children[chid].currentItem = val

    }
    function _repeatIndex(ind, colid) {
        //console.log("repind", ind,colid)
        tcrepindex(ind, colid)
    }
    function _modelChanged (model,colid) {
        tcrepmodel(model, colid)

}
    function _roleChanged (role,colid) {
        tcreprole(role, colid)
    }
    onReadyChanged: { // not elegant but works - first set up when dynamic objects have been created
        if (ready) {
            setWidth(lvRect.width/_tumbColCount)
            setHeight(lvRect.height)
            var ind
            for (ind = 0; ind < children.length; ind++) {

                if (children[ind].objectName == "TumblerColumn") {
                    _repeatIndex(children[ind].currentIndex, children[ind]._colid)
                }
            }

        }
    }



    Component.onCompleted: {

        var ind
        var tumbCol = Qt.createComponent("./TumblerColumnComponent11.qml")
        var colCount = 0
        for (ind = 0; ind < children.length; ind++) {

            if (children[ind].objectName == "TumblerColumn") {

                _tumbColArr.push(tumbCol.createObject(lvRect,{"model": children[ind].model, "role":children[ind].role, "width": children[ind].width, "height": lvRect.height, "colid": colCount, "childid": ind}))
                children[ind]._colid = colCount

                colCount += 1
                _tumbColCount = colCount
            }
        }
        ready = true



    }

    Rectangle{
        anchors.fill: parent
        //anchors.margins: parent.height/20
        BorderImage {
            id: bi
            source: "images/bevel30.png"
            anchors.fill: parent
            border.left: 5; border.top: 5
            border.right: 5; border.bottom: 5
        }

        color: "coral"
        //radius: 10


        Rectangle {
            id: inRect
            anchors.fill: parent
            anchors.margins: parent.height/7
            color: "linen"

            //radius: 9
            property bool update: true
            property real cellwidth: eventRect.showType == "weeks" || eventRect.showType == "days" ? inRect.width/3 : inRect.width/2

            Row {
                id: lvRect
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height// - parent.height * 0.1
                onWidthChanged: { // is this possible with property binding?
                    eventRect.setWidth(width/eventRect._tumbColCount)
                }
                onHeightChanged:  { // is this possible with property binding?
                    eventRect.setHeight(height)
                }





            }

        }

    }







}


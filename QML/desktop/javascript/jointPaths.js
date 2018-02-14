.pragma library

function calcPaths(p, ui) {
    this.parameters = p
    this.dparr = []
    this.tails = []
    this.pins = []
    this.cutPins = []
    this.cutTailsReversed = []
    this.cutTails = []
    this.defaultInputs = function() {
        ui.inHeight.text = '105'
        ui.inStepOver.text = '3'
        ui.inThickness.text = '12'
        ui.inToolDia.text = '6.35'
        ui.inSlip.text = '0.05'
        ui.inAngle.text = 7.5
        ui.chkPinHeight.checked = false
        ui.inPinHeight.text = '6'
        ui.inh.text = '7'
        ui.inh2.text = '7'
        ui.inp1.text = '13'
        ui.int1.text = '13'
        ui.inp2.text = '13'
        ui.int2.text = '13'
        ui.inp3.text = '13'
        ui.int3.text = '13'
        ui.inp4.text = '13'
    }
    this.OK = function() {
        p.height = parseFloat(ui.inHeight.text)
        p.thick = parseFloat(ui.inThickness.text)
        p.tool = parseFloat(ui.inToolDia.text)
        p.step = parseFloat(ui.inStepOver.text)
        p.slip = parseFloat(ui.inSlip.text)
        p.manualPinHeight = ui.chkPinHeight.checked
        p.toolAngle = parseFloat(ui.inAngle.text)
        p.blind = p.thick/2

        p.pinHeight = parseFloat(ui.inPinHeight.text)
        if (p.manualPinHeight == true) {
            p.blind = p.pinHeight
        }

        p.dovetailOverlap = p.blind * Math.tan(Math.PI*p.toolAngle/180)
        p.toolAdjusted = p.tool - p.dovetailOverlap
        console.log(p.dovetailOverlap, p.toolAdjusted , Math.PI*p.toolAngle/180,p.toolAngle, p.blind )
        //console.log("tooladj", p.toolAdjusted)


        this.inputChanged()
        this.calcTails()
        this.calcPins()



    }
    this.inputChanged = function() {
        if (this.checkText(ui.inHeight.text) != p.height) {
            //console.log("BOO")
            p.height = this.checkText(ui.inHeight.text)
            this.clearLayout()
            this.defaultLayout()
        }


        p.tails[0] = this.checkText(ui.inh.text)
        p.taillast = this.checkText(ui.inh2.text)
        p.pins[0] = this.checkText(ui.inp1.text)
        p.tails[1] = this.checkText(ui.int1.text)
        p.pins[1] = this.checkText(ui.inp2.text)
        p.tails[2] = this.checkText(ui.int2.text)
        p.pins[2] = this.checkText(ui.inp3.text)
        p.tails[3] = this.checkText(ui.int3.text)
        p.pins[3] = this.checkText(ui.inp4.text)
        p.tails[4] = this.checkText(ui.int4.text)
        p.pins[4] = this.checkText(ui.inp5.text)
        p.tails[5] = this.checkText(ui.int5.text)
        p.pins[5] = this.checkText(ui.inp6.text)
        p.tails[6] = this.checkText(ui.int6.text)
        p.pins[6] = this.checkText(ui.inp7.text)
        p.tails[7] = this.checkText(ui.int7.text)
        p.pins[7] = this.checkText(ui.inp8.text)
        p.tails[8] = this.checkText(ui.int8.text)
        p.pins[8] = this.checkText(ui.inp9.text)
        p.tails[9] = this.checkText(ui.int9.text)
        p.pins[9] = this.checkText(ui.inp10.text)
        p.used = 0
        var ind
        for (ind = 0; ind < p.pins.length; ind++) {
               p.used += p.pins[ind]
               //console.log(p.pins[ind])
        }
        for (ind = 0; ind < p.tails.length; ind++) {
               p.used += p.tails[ind]
        }

        p.used += p.taillast

        while (this.dparr.length > 0)
            this.dparr.pop(0)
        this.dparr.push(p.tails[0])
        this.dparr.push(p.pins[0])
        ind = 1
        while (p.tails[ind] != 0) {
            this.dparr.push(p.tails[ind])
            this.dparr.push(p.pins[ind])
            ind += 1
        }
        this.dparr.push(p.taillast)
        p.left = p.height - p.used
        ui.inLeft.text = p.left.toFixed(2)
        ui.inUsed.text = p.used.toFixed(2)
    }

    this.checkText = function(val) {
        if (val == "") return 0
        else return parseFloat(val)
    }
    this.clearLayout = function() {
        ui.inh.text = ""
        ui.inh2.text = ""
        ui.inp1.text = ""
        ui.int1.text = ""
        ui.inp2.text = ""
        ui.int2.text = ""
        ui.inp3.text = ""
        ui.int3.text = ""
        ui.inp4.text = ""
        ui.int4.text = ""
        ui.inp5.text = ""
        ui.int5.text = ""
        ui.inp6.text = ""
        ui.int6.text = ""
        ui.inp7.text = ""
        ui.int7.text = ""
        ui.inp8.text = ""
        ui.int8.text = ""
        ui.inp9.text = ""
        ui.int9.text = ""
        ui.inp10.text = ""
    }
    this.defaultLayout = function() {
        var ind, numbpins, fing, pnt, pin, tail
        ui.inh.text = "7"
        ui.inh2.text = "7"
        pnt = this.checkText(ui.inHeight.text)  - 14
        fing = 13
        numbpins = pnt/fing | 0
        while (numbpins > 19) {
            fing += 1
            numbpins = pnt/fing | 0
        }
        if (numbpins%2 == 0)
            numbpins -= 1

        while (pnt - numbpins * fing >= (numbpins * 0.05))
            fing += 0.05
        for (ind = 1; ind <= (numbpins/2 | 0); ind ++) {
            pin = this.getPin(ind)
            tail = this.getTail(ind )
            pin.text= fing.toFixed(2)
            tail.text = fing.toFixed(2)
        }
        pin = this.getPin(ind)
        tail = this.getTail(ind)

        pin.text = fing.toFixed(2)
        ui.inp1.text = (this.checkText(ui.inp1.text) + pnt - numbpins * fing).toFixed(2)

    }

    this.getPin = function(ind) {

        switch(ind) {
        case 1:
            return ui.inp1
        case 2:
            return ui.inp2
        case 3:
            return ui.inp3
        case 4:
            return ui.inp4
        case 5:
            return ui.inp5
        case 6:
            return ui.inp6
        case 7:
            return ui.inp7
        case 8:
            return ui.inp8
        case 9:
            return ui.inp9
        case 10:
            return ui.inp10
        }
    }
    this.getTail = function(ind) {

        switch(ind) {
        case 1:
            return ui.int1
        case 2:
            return ui.int2
        case 3:
            return ui.int3
        case 4:
            return ui.int4
        case 5:
            return ui.int5
        case 6:
            return ui.int6
        case 7:
            return ui.int7
        case 8:
            return ui.int8
        case 9:
            return ui.int9
        }
    }
    this.calcTails = function() {
        var y1, y2, z, ind, Y1, Y2
        this.tails.length = 0
        this.cutTails.length = 0
        this.cutTailsReversed.length = 0
        y1 = y2 = 0
        z = -p.blind
        this.tails.push([-p.thick,0])
        this.tails.push([-p.thick,p.height])
        this.tails.push([0,p.height])
        this.tails.push([0,0])
        //console.log(this.tails[1][0],this.tails[1][1])
        for (ind = 0; ind<p.tails.length; ind++) {
            if (p.tails[ind] == 0 || p.pins[ind] == 0)
                break
            y1 = y2 + p.tails[ind]
            y2 = y1 + p.pins[ind]
            this.tails.push([0,y1 + p.dovetailOverlap / 2])
            this.tails.push([z,y1 - p.dovetailOverlap / 2])
            this.tails.push([z,y2 + p.dovetailOverlap / 2])
            this.tails.push([0,y2 - p.dovetailOverlap / 2])
            Y1 = y1 + p.toolAdjusted/2
            Y2 = y2 - p.toolAdjusted/2
            console.log(Y1,Y2,y1,y2)

            while (Y1 < Y2) {
                this.cutTails.push(Y1 + p.tool/2)
                this.cutTailsReversed.push(p.height + p.tool -(Y1 + p.tool/2))
                Y1 += p.step
            }
            this.cutTails.push(Y2 + p.tool/2)
            this.cutTailsReversed.push(p.height + p.tool -(Y2 + p.tool/2))
            ui.matplot1.dat = this.tails




        }
        for (ind = 0; ind < this.cutTails.length; ind++ ) {
            console.log(this.cutTails[ind])
        }
    }
    this.calcPins = function() {
        var y1, y2, z, ind, Y1, Y2
        this.pins.length = 0
        this.cutPins.length = 0
        y1 = y2 = 0
        z = -p.blind
        for (ind = 0 ; ind < p.pins.length; ind++) {
            //console.log(p.pins[ind], p.tails[ind],ind)
            if (p.pins[ind - 1] != 0) {
                if (p.tails[ind] == 0  && ind > 0) {
                    y1 = y2 + p.pins[ind - 1]
                    if (y1 + p.toolAdjusted >= p.height) {
                        y2 = y1 +  p.toolAdjusted
                    }
                    else {
                        //y2 = p.height - p.tool/2
                        y2 = p.height - p.taillast +  p.toolAdjusted
                    }
                    //console.log("last", y1, y2)

                }
                else {
                    if (ind == 0) {
                        if (p.tails[ind] > p.toolAdjusted) {

                            y1 = 0
                            y2 = p.tails[ind]
                            //console.log("first", y1, y2)
                        }
                        else {
                            y1 = p.tails[ind] - p.toolAdjusted
                            y2 = p.tails[ind]
                        }
                    }
                    else {
                        y1 = y2 + p.pins[ind - 1]
                        y2 = y1 +  p.tails[ind]
                    }

                }
                if (p.tails[ind] == 0) {
                    this.pins.push([0,y1 + p.dovetailOverlap / 2])
                    this.pins.push([z,y1 -p.dovetailOverlap / 2])
                    this.pins.push([z,p.height])
                }
                else {
                    if (y1 <= 0) {
                       this.pins.push([z,0])
                    }
                    else {
                        this.pins.push([0,y1 + p.dovetailOverlap / 2])
                        this.pins.push([z,y1 -p.dovetailOverlap / 2])

                    }
                    this.pins.push([z,y2 + p.dovetailOverlap / 2])
                    this.pins.push([0,y2 -p.dovetailOverlap / 2])
                }
                Y1 = y1 + p.toolAdjusted/2 - p.slip
                Y2 = y2 - p.toolAdjusted/2 + p.slip
                while (Y1 < Y2) {
                    this.cutPins.push(Y1 + p.tool/2)
                    //console.log("a",Y1, Y2, Y1 + p.tool/2, y1, y2)

                    Y1 += p.step
                }
                this.cutPins.push(Y2 + p.tool/2)
                //console.log("b",Y1, Y2, Y2 + p.tool/2, y1, y2)
                if (Y2 + p.tool/2 < p.height && (p.tails[ind] == 0  && ind > 0) ) {
                    this.cutPins.push(p.height + 0.1)
                    //console.log("c",Y1, Y2, Y2 + p.tool, y1, y2)
                }


            }

            //this.pins.push([p.height,-2*p.blind])




        }

        ui.matplot2.dat = this.pins


    }

    this.status = function(aui) {
        return aui.messages.text
    }

}



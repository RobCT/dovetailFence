.pragma library

function arduino(p, ui) {
    this.parameters = p
    this.about = "Logic code for arduino.qml"
    this.jog = function(jt) {
        var cur = ui.slidePos.value
        //console.log(cur, jt, p.ENCSTEPS)
        switch(jt) {
        case -3:
            ui.slidePos.value = cur - 10*p.ENCSTEPS/350
            break
        case -2:
            ui.slidePos.value = cur - 1*p.ENCSTEPS/350
            break
        case -1:
            ui.slidePos.value = cur - 0.1*p.ENCSTEPS/350
            break
        case 1:
            ui.slidePos.value = cur + 0.1*p.ENCSTEPS/350
            break
        case 2:
            ui.slidePos.value = cur + 1*p.ENCSTEPS/350
            break
        case 3:
            ui.slidePos.value = cur + 10*p.ENCSTEPS/350
            break
        }
    }
    this.nextCut = function() {
        //console.log(p.cutType, p.cutIndex, p.cutCount, ui.pcode.cutPins[p.cutIndex]  )
        if (p.cutIndex < p.cutCount) {

            ui.leTarget.text = ""

            if (p.cutType == "Pins") {
                ui.slidePos.value = (ui.pcode.cutPins[p.cutIndex]*p.ENCSTEPS/350 )
            }
            else if (p.cutType == "Tails") {
                ui.slidePos.value = (ui.pcode.cutTails[p.cutIndex]*p.ENCSTEPS/350 )
            }
            else if (p.cutType == "ReverseTails") {
                ui.slidePos.value = (ui.pcode.cutTailsReversed[p.cutIndex]*p.ENCSTEPS/350 )
            }
            p.cutIndex += 1
        }
        else  {
                    p.cutIndex = p.cutCount
                    ui.leTarget.text = "DONE!"
        }
    }
    this.prevCut = function() {
        console.log("prev",p.cutIndex ,p.cutType)
        if (p.cutIndex > 0) {
            p.cutIndex -= 1
            ui.leTarget.text = ""

            if (p.cutType == "Pins") {
                ui.slidePos.value = (ui.pcode.cutPins[p.cutIndex]*p.ENCSTEPS/350 )
            }
            else if (p.cutType == "Tails") {
                ui.slidePos.value = (ui.pcode.cutTails[p.cutIndex]*p.ENCSTEPS/350 )
            }
            else if (p.cutType == "ReverseTails") {
                ui.slidePos.value = (ui.pcode.cutTailsReversed[p.cutIndex]*p.ENCSTEPS/350 )
            }

        }
        else  {
                    p.cutIndex = p.cutCount
                    ui.leTarget.text = "DONE!"
        }
    }
    this.cutType = function() {
            //console.log("cuttype", ui.ct, ui.parent.cutType)
        switch(ui.parent.cutType) {

           case 1:
            ui.parent.cutlist = ui.parent.paths.cutPins
            p.cutType = "Pins"
            p.cutIndex = 0
            p.cutCount = (ui.parent.paths.cutPins.length)
            p.home = ui.parent.parms.encoderPos
            break

            case 2:
            ui.parent.cutlist = ui.parent.paths.cutTails
            p.cutType = "Tails"
            p.cutIndex = 0
            p.cutCount = (ui.parent.paths.cutTails.length)
            p.home = ui.parent.parms.encoderPos
            break
            case 3:
            ui.parent.cutlist = ui.parent.paths.cutTailsReversed
            p.cutType = "ReverseTails"
            p.cutIndex = 0
            p.cutCount = (ui.parent.paths.cutTailsReversed.length)
             p.home = ui.parent.parms.encoderPos
            break
        }
    }

}


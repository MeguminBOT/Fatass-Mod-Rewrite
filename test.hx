var upHold:Bool = false;
var downHold:Bool = false;
var rightHold:Bool = false;
var leftHold:Bool = false;

// Hold notes
private function keyShit():Void
{
    // control arrays, order L D R U
    var holdArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];
    var pressArray:Array<Bool> = [
        controls.NOTE_LEFT_P,
        controls.NOTE_DOWN_P,
        controls.NOTE_UP_P,
        controls.NOTE_RIGHT_P
    ];
    var releaseArray:Array<Bool> = [
        controls.NOTE_LEFT_R,
        controls.NOTE_DOWN_R,
        controls.NOTE_UP_R,
        controls.NOTE_RIGHT_R
    ];

    // Prevent player input if botplay is on
    if(cpuControlled)
    {
        holdArray = [false, false, false, false];
        pressArray = [false, false, false, false];
        releaseArray = [false, false, false, false];
    } 
    // HOLDS, check for sustain notes
    if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
    {
        notes.forEachAlive(function(daNote:Note)
        {
            if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
                goodNoteHit(daNote);
        });
    }

    // PRESSES, check for note hits
    if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
    {
        boyfriend.holdTimer = 0;

        var possibleNotes:Array<Note> = []; // notes that can be hit
        var directionList:Array<Int> = []; // directions that can be hit
        var dumbNotes:Array<Note> = []; // notes to kill later
        
        notes.forEachAlive(function(daNote:Note)
        {
            if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
            {
                if (directionList.contains(daNote.noteData))
                {
                    for (coolNote in possibleNotes)
                    {
                        if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
                        { // if it's the same note twice at < 10ms distance, just delete it
                            // EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
                            dumbNotes.push(daNote);
                            break;
                        }
                        else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
                        { // if daNote is earlier than existing note (coolNote), replace
                            possibleNotes.remove(coolNote);
                            possibleNotes.push(daNote);
                            break;
                        }
                    }
                }
                else
                {
                    possibleNotes.push(daNote);
                    directionList.push(daNote.noteData);
                }
            }
        });
        for (note in dumbNotes)
        {
            FlxG.log.add("killing dumb ass note at " + note.strumTime);
            note.kill();
            notes.remove(note, true);
            note.destroy();
        }

        var dontCheck = false;
        for (i in 0...pressArray.length)
        {
            if (pressArray[i] && !directionList.contains(i))
                dontCheck = true;
        }
        if (possibleNotes.length > 0 && !dontCheck)
        {
            if (!ClientPrefs.ghostTapping)
            {
                for (shit in 0...pressArray.length)
                    { // if a direction is hit that shouldn't be
                        if (pressArray[shit] && !directionList.contains(shit))
                            noteMiss(shit, null);
                    }
            }
            for (coolNote in possibleNotes)
            {
                if (pressArray[coolNote.noteData])
                {
                    goodNoteHit(coolNote);
                }
            }
        }
        else if(!ClientPrefs.ghostTapping)
        {
            for (shit in 0...pressArray.length)
            { // if a direction is hit that shouldn't be
                if (pressArray[shit] && !directionList.contains(shit))
                    noteMissPress(shit);
            }
        }
    }
    
    notes.forEachAlive(function(daNote:Note)
    {
        if(ClientPrefs.downScroll && daNote.y > strumLine.y ||
        !ClientPrefs.downScroll && daNote.y < strumLine.y)
        {
            // Force good note hit regardless if it's too late to hit it or not as a fail safe
            if(cpuControlled && daNote.canBeHit && daNote.mustPress ||
            cpuControlled && daNote.tooLate && daNote.mustPress)
            {
                goodNoteHit(daNote);
                boyfriend.holdTimer = daNote.sustainLength;
            }
        }
    });
    
    if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || cpuControlled))
    {
        if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
            boyfriend.playAnim('idle');
    }

    playerStrums.forEach(function(spr:StrumNote)
    {
        if(pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm') {
            spr.playAnim('pressed');
            spr.resetAnim = 0;
        }
        if(releaseArray[spr.ID]) {
            spr.playAnim('static');
            spr.resetAnim = 0;
        }
    });
}
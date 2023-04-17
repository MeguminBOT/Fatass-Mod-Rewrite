package;

import Note;
import Song;
import flixel.FlxG;
import openfl.utils.Assets;

class Strain {
    public static final individual_decay_base = 0.125;
    public static final overall_decay_base = 0.30;
    public static final release_threshold = 24;

    public var startTimes:Array<Float>;
    public var endTimes:Array<Float>;
    public var individualStrains:Array<Float>;

    public var individualStrain:Float;
    public var overallStrain:Float;

    public function new(notes:Array<Note>, totalColumns:Int) {
        startTimes = new Array<Float>();
        endTimes = new Array<Float>();
        individualStrains = new Array<Float>();
        overallStrain = 1;
    
        trace('notes length:', notes.length);
        trace('totalColumns:', totalColumns);
        trace('individualStrain:', individualStrain);
        trace('overallStrain:', overallStrain);
        for (note in notes) {
            strainValueOf(note);
        }
    }

    public function strainValueOf(note:Note):Float {
        var startTime:Float = note.strumTime;
        var endTime:Float = note.strumTime + note.sustainLength;
        var column:Int = note.noteData;
        var isOverlapping:Bool = false;

        var closestEndTime:Float = Math.abs(endTime - startTime);
        var holdFactor:Float = 1.0;
        var holdAddition:Float = 0;

        for (i in 0...endTimes.length) {
            if (endTimes[i] > startTime && endTime > endTimes[i]) {
                isOverlapping = true;
            }

            if (endTimes[i] > endTime) {
                holdFactor = 1.25;
            }

            closestEndTime = Math.min(closestEndTime, Math.abs(endTime - endTimes[i]));
        }

        if (isOverlapping) {
            holdAddition = 1 / (1 + Math.exp(-0.5 * (release_threshold - closestEndTime))); // Changed the syntax
        }

        individualStrains[column] = applyDecay(individualStrains[column], startTime - startTimes[column], individual_decay_base);
        individualStrains[column] += 2.0 * holdFactor;

        var deltaNoteTime:Float = note.getDeltaTime();
        individualStrain = deltaNoteTime <= 1 ? Math.max(individualStrain, individualStrains[column]) : individualStrains[column];

        overallStrain = applyDecay(overallStrain, deltaNoteTime, overall_decay_base);
        overallStrain += (1 + holdAddition) * holdFactor;

        startTimes[column] = startTime;
        endTimes[column] = endTime;

        return individualStrain + overallStrain;
    }


    public function calculateInitialStrain(offset:Float, note:Note):Float { // added the type for "note" parameter
        return applyDecay(individualStrain, offset - note.prevNote.strumTime, individual_decay_base)
               + applyDecay(overallStrain, offset - note.prevNote.strumTime, overall_decay_base);
    }

    public function applyDecay(value:Float, deltaTime:Float, decayBase:Float):Float {
        return value * Math.pow(decayBase, deltaTime / 1000);
    }

}

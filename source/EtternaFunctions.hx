package;

import flixel.util.FlxColor;
import FunkinLua;
import HelperFunctions;
import sys.thread.Thread;

class EtternaFunctions
{
	public static var a1:Float = 0.254829592;
	public static var a2:Float = -0.284496736;
	public static var a3:Float = 1.421413741;
	public static var a4:Float = -1.453152027;
	public static var a5:Float = 1.061405429;
	public static var p:Float = 0.3275911;
	public static var actualRatingHere:Float = 0.00;
	public static var msDiffTimeLimit:Int = 500;
	public static var lastMsShowUp:Float = 0;
	public static var msTextVisible:Bool = false;
	public static var msText:ModchartText;

	public static function updateMsText() {
		var curSongPos = Conductor.songPosition;
    	if (curSongPos - lastMsShowUp > msDiffTimeLimit && msTextVisible) {
    	    msText.text = '';
       		msTextVisible = false;
		}

    	if (PlayState.instance.ratingName == '?') {
        	var beforeScoreTxt = 'Score: 0 | Combo Breaks: 0 | Accuracy: 0.00% | N/A';
        	PlayState.instance.scoreTxt.text = beforeScoreTxt;
		} else {
        	var ratingName = PlayState.instance.ratingFC;

        	var ratingFull = Math.max(actualRatingHere * 100, 0);
        	var ratingFullAsStr = HelperFunctions.truncateFloat(ratingFull, 3);

        	var tempRatingNameVery = EtternaFunctions.accuracyToRatingString(ratingFull);
        	var finalScoreTxt = 'Score: ' + PlayState.instance.songScore + ' | Combo Breaks: ' + PlayState.instance.songMisses + ' | Accuracy: ' + ratingFullAsStr + '% | (' + ratingName + ') ' + tempRatingNameVery;
        	PlayState.instance.scoreTxt.text = finalScoreTxt;
		}	
	}

	public static function accuracyToRatingString(accuracy) {
		if (accuracy >= 99.9935) {
			return 'AAAAA';
		} else if (accuracy >= 99.980) {
			return 'AAAA:';
		} else if (accuracy >= 99.970) {
			return 'AAAA.';
		} else if (accuracy >= 99.955) {
			return 'AAAA';
		} else if (accuracy >= 99.90) {
			return 'AAA:';
		} else if (accuracy >= 99.80) {
			return 'AAA.';
		} else if (accuracy >= 99.70) {
			return 'AAA';
		} else if (accuracy >= 99) {
			return 'AA:';
		} else if (accuracy >= 96.50) {
			return 'AA.';
		} else if (accuracy >= 93) {
			return 'AA';
		} else if (accuracy >= 90) {
			return 'A:';
		} else if (accuracy >= 85) {
			return 'A.';
		} else if (accuracy >= 80) {
			return 'A';
		} else if (accuracy >= 70) {
			return 'B';
		} else if (accuracy >= 60) {
			return 'C';
		} else {
			return 'D';
		}
	}

	public static function updateAccuracy(strumTime:Float, songPos:Float, rOffset:Int) {
		var thread:Thread = Thread.create(function() {
			var noteDiffSign:Float = strumTime - songPos + rOffset;
			var noteDiffAbs:Float = Math.abs(noteDiffSign);
			var totalNotesForNow = handleNoteDiff(noteDiffAbs);
			showMsDiffOnScreen(noteDiffSign);
			PlayState.instance.totalNotesHit = PlayState.instance.totalNotesHit + totalNotesForNow;
			PlayState.instance.totalPlayed = PlayState.instance.totalPlayed + 1;
			actualRatingHere = PlayState.instance.totalNotesHit / PlayState.instance.totalPlayed;
			PlayState.instance.ratingPercent = Math.min(1, Math.max(0, actualRatingHere));
		});										
	}

	public static function handleNoteDiff(diff:Float) {
		var maxms = diff;
		var ts:Float = 1;
		var max_points = 1.0;
		var miss_weight = -5.5;
		var ridic = 5 * ts;
		var max_boo_weight = 166 * (ts / PlayState.instance.playbackRate);
		var ts_pow = 0.75;
		var zero = 65 * (Math.pow(ts, ts_pow));
		var power = 2.5;
		var dev = 22.7 * (Math.pow(ts, ts_pow));

		var isNormalComplexity = ClientPrefs.inputComplexity == "Normal";
		var isHighComplexity = !isNormalComplexity;

		if ((isNormalComplexity && maxms <= 45) || (isHighComplexity && maxms <= ridic)) {
			return max_points;
		} else if (maxms <= zero) {
			return max_points * erf((zero - maxms) / dev);
		} else if (maxms <= max_boo_weight) {
			return (maxms - zero) * miss_weight / (max_boo_weight - zero);
		} else {
			return miss_weight;
		}
	}


	public static function showMsDiffOnScreen(diff:Float) {
		msText.color = ratingTextColor(diff);
		if (diff > 399) {
			msText.text = '';
		} else {
			msText.text = HelperFunctions.truncateFloat(-diff / PlayState.instance.playbackRate, 3) + 'ms';
		}
		lastMsShowUp = Conductor.songPosition;
		msTextVisible = true;
	}

	public static function ratingTextColor(diff:Float):FlxColor {
		var absDiff = Math.abs(diff);
		if (absDiff < 46.0) {
			return 0xff00FFFF;
		} else if (absDiff < 91.0) {
			return 0xff008000;
		} else {
			return 0xffFF0000;
		}
	}

	public static function erf(x:Float):Float
	{
		// Save the sign of x
		var sign = 1;
		if (x < 0)
			sign = -1;
		x = Math.abs(x);

		// A&S formula 7.1.26
		var t = 1.0 / (1.0 + p * x);
		var y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * Math.exp(-x * x);

		return sign * y;
	}
}

package;

import flixel.graphics.FlxGraphic;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSave;
import flixel.animation.FlxAnimationController;
import animateatlas.AtlasFrameMaker;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import Conductor.Rating;
import Strain;
import flixel.addons.display.FlxBackdrop;

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED
#if (hxCodec >= "2.6.1") import hxcodec.VideoHandler as MP4Handler;
#elseif (hxCodec == "2.6.0") import VideoHandler as MP4Handler;
#else import vlc.MP4Handler; #end
#end


class StarRating extends MusicBeatState
{
    public var notes:FlxTypedGroup<Note>;
    public var mustHitNotes:Array<Note> = [];
    public var nonMustHitNotes:Array<Note> = [];
    public var unspawnNotes:Array<Note> = [];
    var curSong:String = "";
    private static inline var star_scaling_factor:Float = 0.018;

    public function calculateDifficulty():Dynamic {
       
        var songData = PlayState.SONG;
        
        curSong = songData.song;
        notes = new FlxTypedGroup<Note>();
        add(notes);
    
        var noteData:Array<SwagSection>;
        noteData = songData.notes;

        for (section in noteData) {
            for (songNotes in section.sectionNotes) {
                var daStrumTime:Float = songNotes[0];
                var daNoteData:Int = Std.int(songNotes[1] % 4);
                var gottaHitNote:Bool = section.mustHitSection;
                var oldNote:Note = null;

                var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
                swagNote.mustPress = section.mustHitSection;
                swagNote.sustainLength = songNotes[2];

                var susLength:Float = swagNote.sustainLength;
                susLength = susLength / Conductor.stepCrochet;
                unspawnNotes.push(swagNote);

                var floorSus:Int = Math.floor(susLength);
                if(floorSus > 0) {
                    for (susNote in 0...floorSus+1)
                    {
                        oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

                        var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote), daNoteData, oldNote, true);
                        sustainNote.mustPress = gottaHitNote;
                        swagNote.tail.push(sustainNote);
                        sustainNote.parent = swagNote;
                        unspawnNotes.push(sustainNote);
                    }
                }

                if (swagNote.mustPress) {
                    mustHitNotes.push(swagNote);
                } else {
                    nonMustHitNotes.push(swagNote);
                }
            } // Move this closing brace here
        }

        // Calculate strain for mustHitNotes and nonMustHitNotes separately
        var totalColumns:Int = 4;
        var mustHitStrain:Strain = new Strain(mustHitNotes, totalColumns);
        var nonMustHitStrain:Strain = new Strain(nonMustHitNotes, totalColumns);
        

        // Normalize the values
        var maxValue:Float = 10.0;
        var minValue:Float = 0.0;
        var mustHitNormalized:Float = (mustHitStrain.individualStrain + mustHitStrain.overallStrain - minValue) / (maxValue - minValue);
        var nonMustHitNormalized:Float = (nonMustHitStrain.individualStrain + nonMustHitStrain.overallStrain - minValue) / (maxValue - minValue);
        // Take BPM into account
        var bpmFactor:Float = songData.bpm / 120.0;
        var finalDifficultyMustHit:Float = mustHitNormalized * bpmFactor;
        var finalDifficultyNonMustHit:Float = nonMustHitNormalized * bpmFactor;

        // Clamp the values between 0 and 10
        finalDifficultyMustHit = Math.max(minValue, Math.min(maxValue, finalDifficultyMustHit) * star_scaling_factor);
        finalDifficultyNonMustHit = Math.max(minValue, Math.min(maxValue, finalDifficultyNonMustHit) * star_scaling_factor);
        
        return {
            mustHit: finalDifficultyMustHit,
            nonMustHit: finalDifficultyNonMustHit
        };

    }
}

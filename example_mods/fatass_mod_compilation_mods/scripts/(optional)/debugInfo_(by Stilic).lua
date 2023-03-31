local noteHits = 0;

function onCreate()
    makeLuaText('debugInfo', '', getPropertyFromClass('flixel.FlxG', 'width'), 0,
        getPropertyFromClass('flixel.FlxG', 'height') / 3);
    setTextAlignment('debugInfo', 'left');
    setProperty('debugInfo.visible', false);
    addLuaText('debugInfo');
end

function goodNoteHit()
    noteHits = noteHits + 1;
end

function opponentNoteHit()
    noteHits = noteHits + 1;
end

function onUpdatePost()
    setTextString('debugInfo',
        'week:  ' .. week .. '\nsong:  ' .. songName .. '\ndiff:  ' .. difficulty .. '\nplayer:  ' .. boyfriendName .. '\nopponent:  ' ..
            dadName .. '\nbpm:  ' .. curBpm .. '\nscrollspeed:  ' .. scrollSpeed .. '\ncrochet:  ' .. crochet ..
            '\nstepCrochet:  ' .. stepCrochet .. '\nlength:  ' .. songLength / 1000 .. '\nsection: ' ..
            math.floor(curStep / 16) .. '\nbeat:  ' .. curBeat .. '\nstep:  ' .. curStep .. '\nnoteHits:  ' .. noteHits);

    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.F3') then
        setProperty('debugInfo.visible', not getProperty('debugInfo.visible'));
    end
end

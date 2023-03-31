function onCreate()
	precacheImage('white')

	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an Instakill Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'whitenote' then --Change texture
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has no penalties
			end
		end
	end
end

-- Function called when you hit a note (after note hit calculations)
-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"
-- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right
-- noteType: The note type string/tag
-- isSustainNote: If it's a hold note, can be either true or false
function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'whitenote' then
		if flashingLights then
			makeLuaSprite('image', 'white', -500, -300);
			addLuaSprite('image', true);
			doTweenColor('hello', 'image', 'FFFFFFFF', 0.5, 'quartIn');
			setObjectCamera('image', 'other');
    		runTimer('wait', 0.1);
		end
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'white Note' then
		if flashingLights then
			makeLuaSprite('image', 'white', -500, -300);
			addLuaSprite('image', true);
			doTweenColor('hello', 'image', 'FFFFFFFF', 0.5, 'quartIn');
			setObjectCamera('image', 'other');
			runTimer('wait', 0.1);
			bruh = getProperty('health');
			setProperty('health', bruh - 0.25);
		end
	end
end

function onTimerCompleted(tag, loops, loopsleft)
    if tag == 'wait' then
   		doTweenAlpha('byebye', 'image', 0, 0.1, 'linear');
    end
end

function onTweenCompleted(tag)
    if tag == 'byebye' then
    	removeLuaSprite('image', true);
    end
end
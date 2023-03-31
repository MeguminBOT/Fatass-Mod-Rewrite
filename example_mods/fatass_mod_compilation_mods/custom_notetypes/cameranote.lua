function onCreate()

    debugPrint('Please disable "Flashing Effects" and "Camera Effects" in options if you are at risk of seizures')
	debugPrint('This song contains "Flashing Lights" and "Camera Shake".')
	debugPrint('Epilepsy / Photosensitivity Warning:')
	
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an Instakill Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Static Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'StaticNOTE_assets'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'staticSplash'); -- change splash
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
	if noteType == 'cameranote' then
		if flashingLights then
			cameraShake('camGame', 0.014, 0.2)
		end
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Static Note' then
		if flashingLights then
			makeLuaSprite('image', 'static', -500, -300);
			addLuaSprite('image', true);
			doTweenColor('hello', 'image', 'FFFFFFFF', 0.5, 'quartIn');
			setObjectCamera('image', 'other');
			cameraShake('camGame', 0.01, 0.2)
			playSound('staticSound', 0.25);
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
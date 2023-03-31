function onCreate()
    debugPrint('Please disable "Flashing Effects" and "Camera Effects" in options if you are at risk of seizures')
	debugPrint('This song contains "Flashing Lights" and "Camera Shake".')
	debugPrint('Epilepsy / Photosensitivity Warning:')
	precacheImage('white')
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'bulletnote2' then
		makeLuaSprite('image', 'white', -500, -300);
		if flashingLights then
		addLuaSprite('image', true);
		end
		doTweenColor('hello', 'image', 'FFFFFFFF', 0.2, 'quartIn');
		setObjectCamera('image', 'other');
		runTimer('wait', 0.01);
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'bulletnote2' then
		makeLuaSprite('image', 'white', -500, -300);
		if flashingLights then
		addLuaSprite('image', true);
		end
		doTweenColor('hello', 'image', 'FFFFFFFF', 0.2, 'quartIn');
		setObjectCamera('image', 'other');
		runTimer('wait', 0.01);
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
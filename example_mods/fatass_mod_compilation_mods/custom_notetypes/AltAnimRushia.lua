function onCreate()
	precacheImage('red')

	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'AltAnimRushia' then --Check if the note on the chart is a Bullet Note
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'AltAnimRushia' then
		if flashingLights then
			makeLuaSprite('image', 'red', 0, 0);
			addLuaSprite('image', true);
			doTweenColor('hello', 'image', 'FFFFFFFF', 0, 'quartIn');
			setObjectCamera('image', 'other');
			runTimer('delet', 0.1)
		end

		if direction == 0 then
		characterPlayAnim('dad', 'singLEFT-alt', true);
				elseif direction == 1 then
				characterPlayAnim('dad', 'singDOWN-alt', true);
					elseif direction == 2 then
					characterPlayAnim('dad', 'singUP-alt', true);
							elseif direction == 3 then
							characterPlayAnim('dad', 'singRIGHT-alt', true); -- those elseifs are bootlegs because I don't know how to make this note type have alt animation note effects lol.
		end
	end
end

function onTimerCompleted(tag, loops, loopsleft)
    if tag == 'delet' then
    removeLuaSprite('image', false); -- Looks like intro event's tag was conflicting with my deletion tag huh
    end
end
function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'jebus-hurtnote' then --Check if the note on the chart is a Bullet Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'jebus-hurtnote'); --Change texture
			scoreWas = getProperty('songScore'); -- gets score shit
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has penalties
			end
		end
	end
end

function noteMissPress()
	scoreWas = getProperty('songScore'); -- gets score on note miss press just to avoid loosing too big/too small amount of score. I tried calling it before calculation, but script was getting player's score only AFTER the calculation is finished because lua is so fucking slow.
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'jebus-hurtnote' then
		setProperty('health', getProperty('health')-0.4);
		characterPlayAnim('boyfriend', 'hurt', true);
		setScore(scoreWas-200) -- stealy wheelly automobiley (score stealing).
		scoreWas = getProperty('songScore'); -- getting score value
		else scoreWas = getProperty('songScore'); -- still getting score value
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'jebus-hurtnote' then
	    setProperty('health', getProperty('health') +0.0475);
		addMisses(-1);
		cameraShake('camGame', 0.01, 0.2);
		else scoreWas = getProperty('songScore'); -- gets score on miss.
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if loopsLeft >= 1 then
		setProperty('health', getProperty('health')-0.001);
	end
end
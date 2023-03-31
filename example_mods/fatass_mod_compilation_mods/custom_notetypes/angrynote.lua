function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'angrynote' then --Check if the note on the chart is a Bullet Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'angrynote'); --Change texture
			scoreWas = getProperty('songScore'); -- score getting
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has penalties
			end
		end
	end
end

function noteMissPress()
	scoreWas = getProperty('songScore'); -- score getting
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'angrynote' then
		setProperty('health', getProperty('health')-0.4);
		characterPlayAnim('girlfriend', 'scared', true);
		cameraShake('camGame', 0.02, 0.2);
		setScore(scoreWas-200); -- I'm decreasing score via setScore because hurt notes still give you score. You'll be punishing a player less for hitting those notes with SICK! rating, and punishing more with SHIT which makes no sense.
	else scoreWas = getProperty('songScore'); -- score getting
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'angrynote' then
	    setProperty('health', getProperty('health') +0.0475);
		addMisses(-1);
		cameraShake('camGame', 0.02, 0.2);
	else scoreWas = getProperty('songScore'); -- score getting
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
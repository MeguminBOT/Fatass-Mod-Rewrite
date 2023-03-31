function onCreate()
	precacheImage('jebus-dodgenote')
	precacheSound('jebus-bullet')

	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'jebus-dodgenote' then --Check if the note on the chart is a Bullet Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'jebus-dodgenote'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0); --custom notesplash color, why not
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 0);
			scoreWas = getProperty('songScore'); -- get to be sure that player WILL loose score.
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end

function noteMissPress()
	scoreWas = getProperty('songScore'); -- get to avoid loosing too big/too small amount of score.
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'jebus-dodgenote' then
		playSound('jebus-bullet', 0.2);
		characterPlayAnim('dad', 'attack', true);
		characterPlayAnim('boyfriend', 'dodge', true);
		setProperty('boyfriend.specialAnim', true);
		setProperty('dad.specialAnim', true);
		if camShake then 
			cameraShake('camGame', 0.01, 0.2)
		end
		scoreWas = getProperty('songScore'); -- score again
		else scoreWas = getProperty('songScore'); -- get to avoid loosing too big/too small amount of score.
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'jebus-dodgenote' then
		setProperty('health', getProperty('health')-0.3);
		playSound('jebus-bullet', 0.2);
		characterPlayAnim('dad', 'attack', true);
		characterPlayAnim('boyfriend', 'hurt', true);
		setProperty('boyfriend.specialAnim', true);
		setProperty('dad.specialAnim', true);
		if camShake then 
			cameraShake('camGame', 0.01, 0.2)
		end
		setScore(scoreWas-190); -- score steal. 10 points less because miss penalties.
		scoreWas = getProperty('songScore') -- get da score
		else scoreWas = getProperty('songScore'); -- getting score again
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
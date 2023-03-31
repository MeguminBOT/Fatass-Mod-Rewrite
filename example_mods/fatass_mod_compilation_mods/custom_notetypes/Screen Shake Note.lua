-- Function called when you hit a note (after note hit calculations)
-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"
-- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right
-- noteType: The note type string/tag
-- isSustainNote: If it's a hold note, can be either true or false
function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Screen Shake Note' then
		if camShake then
			cameraShake('camGame', 0.014, 0.2)
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
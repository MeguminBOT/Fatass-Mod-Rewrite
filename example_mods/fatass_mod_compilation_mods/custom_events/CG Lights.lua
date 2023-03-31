-- Luscious's CG Lights event.

-- AutisticLulu's additions to script:
-- 1. Prevent the script from running if Flashing Lights is disabled in options, which in turn makes it safer for people who are at risk for epilepsy/seizures.
-- 2. Also prevent the script from running if Low Quality is enabled in options.

function onEvent(name,value1,value2)
    if not lowQuality then  -- If Low Quality is disabled, allow the code to run
        if flashingLights then  -- If Flashing Lights are enabled, allow the code to run	
			if name == 'CG Lights' then
				if value1 == "dad" then
					if value2 == "on" then
						function opponentNoteHit(id, noteData, isSustainNote)
							if noteData == 0 then
								makeLuaSprite('image', 'LEFT LIGHT', -200, -200); -- -200/-200 is for light sprites with a resolution of 1588x926.
								addLuaSprite('image', false);
								setObjectCamera('image', 'other');
								runTimer('wait', 0.1);
					
							elseif noteData == 1 then
								makeLuaSprite('image', 'DOWN LIGHT', -200, -200);
								addLuaSprite('image', false);
								setObjectCamera('image', 'other');
								runTimer('wait', 0.1);
						
							elseif noteData == 2 then
								makeLuaSprite('image', 'UP LIGHT', -200, -200);
								addLuaSprite('image', false);
								setObjectCamera('image', 'other');
								runTimer('wait', 0.1);
						
							elseif noteData == 3 then
								makeLuaSprite('image', 'RIGHT LIGHT', -200, -200);
								addLuaSprite('image', false);
								setObjectCamera('image', 'other');
								runTimer('wait', 0.1);
							end
						end
				
						function onTimerCompleted(tag, loops, loopsleft)
							if tag == 'wait' then
								doTweenAlpha('byebye', 'image', 0, 0.8, 'linear');
							end
						end
			
						function onTweenCompleted(tag)
							if tag == 'byebye' then
								doTweenAlpha('image', 0.9, 1.2, 'linear'); --note: if you want the light effect to stay on screen a bit longer uncomment these lines and in line 110
								--doTweenAlpha('image', 0.8, 1.2, 'linear'); --0.8 is duration
								doTweenAlpha('image', 0.7, 1.2, 'linear');
								--doTweenAlpha('image', 0.6, 1.2, 'linear');
								doTweenAlpha('image', 0.5, 1.2, 'linear');
								--doTweenAlpha('image', 0.4, 1.2, 'linear');
								doTweenAlpha('image', 0.3, 1.2, 'linear');
								--doTweenAlpha('image', 0.2, 1.2, 'linear');
								doTweenAlpha('image', 0.1, 1.2, 'linear');
								removeLuaSprite('image', true);
							end
						end				
					end
					
				end
				if value2 == "off" then
					function opponentNoteHit(id, noteData, isSustainNote)
					end
				end	
				
				if value1 == "bf" then
					if value2 == "on" then
						function goodNoteHit(id, noteData, isSustainNote)
							if noteData == 0 then
								makeLuaSprite('image', 'LEFT LIGHT', -200, -200);
								addLuaSprite('image', false);
								setObjectCamera('image', 'other');
								runTimer('wait', 0.1);
					
							elseif noteData == 1 then
								makeLuaSprite('image', 'DOWN LIGHT', -200, -200);
								addLuaSprite('image', false);
								setObjectCamera('image', 'other');
								runTimer('wait', 0.1);
						
							elseif noteData == 2 then
								makeLuaSprite('image', 'UP LIGHT', -200, -200);
								addLuaSprite('image', false);
								setObjectCamera('image', 'other');
								runTimer('wait', 0.1);
						
							elseif noteData == 3 then
								makeLuaSprite('image', 'RIGHT LIGHT', -200, -200);
								addLuaSprite('image', false);
								setObjectCamera('image', 'other');
								runTimer('wait', 0.1);
							end
						end
				
						function onTimerCompleted(tag, loops, loopsleft)
							if tag == 'wait' then
								doTweenAlpha('byebye', 'image', 0, 0.8, 'linear');
							end
						end
			
						function onTweenCompleted(tag)
							if tag == 'byebye' then
								doTweenAlpha('image', 0.9, 1.2, 'linear'); --this is soo unneccessary and useless starting from 0.5 to 0.3 to 0.1 is same *maybe*
								--doTweenAlpha('image', 0.8, 1.2, 'linear'); --0.8 is duration
								doTweenAlpha('image', 0.7, 1.2, 'linear');
								--doTweenAlpha('image', 0.6, 1.2, 'linear');
								doTweenAlpha('image', 0.5, 1.2, 'linear');
								--doTweenAlpha('image', 0.4, 1.2, 'linear');
								doTweenAlpha('image', 0.3, 1.2, 'linear');
								--doTweenAlpha('image', 0.2, 1.2, 'linear');
								doTweenAlpha('image', 0.1, 1.2, 'linear');
								removeLuaSprite('image', true);
							end
						end
					end
				end
				if value2 == "off" then
					function goodNoteHit(id, noteData, isSustainNote)
					end
				end
			end
		end
	end
end
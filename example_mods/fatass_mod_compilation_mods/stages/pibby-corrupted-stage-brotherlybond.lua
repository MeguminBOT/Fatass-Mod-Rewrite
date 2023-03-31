function onCreate()

	makeLuaSprite('stage', 'stages/pibby-corrupted-stage', -600, -300);
	addLuaSprite('stage', false);
	
	if not lowQuality then	-- sprites that only load if Low Quality is turned off
		makeAnimatedLuaSprite('glitchattack','pibby-corrupted-glitchattack',700,30)
		addAnimationByPrefix('glitchattack','blank','nonglitch',24,false)
		addAnimationByPrefix('glitchattack','gattack','glitchattack',24,false)
		addLuaSprite('glitchattack',true)

			function onBeatHit()
				objectPlayAnimation('glitchattack','blank',true)
			end
			function goodNoteHit(id, direction, noteType, isSustainNote)
				if noteType == 'Sword' then
						characterPlayAnim('gf', 'attack', true);
					objectPlayAnimation('glitchattack','gattack',true)
				end
			end

			function noteMiss(id, direction, noteType, isSustainNote)
				if noteType == 'Sword' then
						characterPlayAnim('gf', 'attack', true);
					objectPlayAnimation('glitchattack','gattack',true)
				end
			end
	end
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
function onCreate()
	-- background shit
	makeLuaSprite('stageback', 'stages/whitty-stageback', -600, -300);
	makeLuaSprite('stagefront', 'stages/whitty-stagefront', -650, 600);
	scaleObject('stagefront', 1.1, 1.1);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		--Low Quality mode not yet implemented
	end

	addLuaSprite('stageback', false);
	addLuaSprite('stagefront', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
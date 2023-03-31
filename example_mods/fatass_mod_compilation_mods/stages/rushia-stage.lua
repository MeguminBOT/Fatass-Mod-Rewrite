function onCreate()
	-- background shit
	makeLuaSprite('background', 'stages/rushia-stage-background', -500, -750);
	addLuaSprite('background', false);
	setLuaSpriteScrollFactor('background', 0.5, 0.5);

	makeLuaSprite('stage', 'stages/rushia-stage-floor', -520, -720);
	scaleObject('stage', 1.1, 1.1);
	addLuaSprite('stage', false);
	setLuaSpriteScrollFactor('stage', 0.9, 0.9);

	makeLuaSprite('plants', 'stages/rushia-stage-plants', -1250, -1250);
	scaleObject('plants', 1.5, 1.5);
	addLuaSprite('plants', true);
	setLuaSpriteScrollFactor('plants', 1.3, 1.3);

	if not lowQuality then	-- sprites that only load if Low Quality is turned off
	end
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
function onCreate()

	-- background shit
	makeLuaSprite('bg', 'stages/gunfight-stagebg', -500, -300);
	addLuaSprite('bg', false);
	scaleObject('bg', 1.2, 1.2);
	setLuaSpriteScrollFactor('bg', 0.9, 0.9);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		makeAnimatedLuaSprite('right-smoke', 'smokeRight', 0, -800);
		addAnimationByPrefix('right-smoke', 'first', 'smokeRight', 28, true);
		objectPlayAnimation('right-smoke', 'first');
		addLuaSprite('right-smoke', false);
		scaleObject('right-smoke', 2, 2);	

		makeAnimatedLuaSprite('right-smoke2', 'smokeRight', 1250, -200);
		addAnimationByPrefix('right-smoke2', 'first', 'smokeRight', 24, true);
		objectPlayAnimation('right-smoke2', 'first');
		addLuaSprite('right-smoke2', false);
		scaleObject('right-smoke2', 1.0, 1.0);
		
		makeLuaBackdrop('clouds', 'backdrop-cloud', -400, -600)
		setProperty('clouds.velocity.x', -80);
		setProperty('clouds.velocity.y', 0);
		addLuaBackdrop('clouds', true);
		scaleObject('clouds', 2.5, 2.5);
	end
 	
	-- more background shit
	makeLuaSprite('stagefloor', 'stages/gunfight-stagefloor', -500, -300);
	scaleObject('stagefloor', 1.2, 1.2);
	addLuaSprite('stagefloor', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
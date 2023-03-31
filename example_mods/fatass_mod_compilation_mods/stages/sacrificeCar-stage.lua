function onCreate()

	if not lowQuality then -- If lowQuality is turned off, load the following sprites:
	
		makeLuaBackdrop('clouds', 'backdrop-cloud-big', 0, -2500)
		setProperty('clouds.velocity.x', -1650);
		setProperty('clouds.velocity.y', 0);
		setProperty('object.useScaleHack', false);
		setProperty('clouds.lowestCamZoom', 0.75);
		addLuaBackdrop('clouds', true);
		scaleObject('clouds', 4.0, 4.0);
	
		makeLuaBackdrop('background', 'stages/sacrifice-background', -600, -250);
		setProperty('background.velocity.x', -1400);
		setProperty('background.velocity.y', 0);
		setProperty('object.useScaleHack', false);
		setProperty('background.lowestCamZoom', 0.75);
		addLuaBackdrop('background', false);
		
		makeAnimatedLuaSprite('left-smoke', 'smokeLeft', 1050, -1100);
		addAnimationByPrefix('left-smoke', 'first', 'smokeLeft', 24, true);
		objectPlayAnimation('left-smoke', 'first');
		addLuaSprite('left-smoke', false);
		scaleObject('left-smoke', 1.0, 1.0);
		
	    makeAnimatedLuaSprite('left-smoke2', 'smokeLeft', 1250, -1200);
		addAnimationByPrefix('left-smoke2', 'first', 'smokeLeft', 26, true);
		objectPlayAnimation('left-smoke2', 'first');
		addLuaSprite('left-smoke2', false);
		scaleObject('left-smoke2', 1.2, 1.2);
	end
	
	
	-- Second layer
	makeAnimatedLuaSprite('car', 'stages/sacrifice-car', -300, -300);
	addAnimationByPrefix('car', 'first','car', 35, true);
	objectPlayAnimation('car', 'first');
	addLuaSprite('car', false);

	-- Third layer
   	makeLuaSprite('effects', 'stages/sacrifice-effects', -600, -300);
  	addLuaSprite('effects', false)
	setLuaSpriteScrollFactor('effects', 0.9, 0.9);
	setLuaBackdropScrollFactor('background', 0.6, 0.6);


	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
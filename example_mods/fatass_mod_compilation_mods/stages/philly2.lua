function onCreate()
	-- background 
	makeLuaSprite('sky','stages/philly-sky2', -100, 00);
	setLuaSpriteScrollFactor('sky', 0.1, 0.1);

	makeLuaSprite('city','stages/philly-city2', -10, 0);
	setLuaSpriteScrollFactor('city', 0.3, 0.3);
	scaleObject('city', 0.85, 0.85);

	makeLuaSprite('behindTrain','stages/philly-behindTrain2', -40, 50);
	makeLuaSprite('street','stages/philly-street2', -40, 50);

	if not lowQuality then	-- sprites that only load if Low Quality is turned off
		makeAnimatedLuaSprite('light', 'stages/philly-light',-10, 0);
        setLuaSpriteScrollFactor('light', 0.3, 0.3);		
	    scaleObject('light',0.85, 0.85);
	end

	addLuaSprite('sky', false);
	addLuaSprite('city', false);
	addLuaSprite('light', false); --Added offscreen before it starts moving.
	addAnimationByPrefix('light', 'idle', 'light idle', 1, true);
	addLuaSprite('behindTrain', false);
	addLuaSprite('street', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
function onCreate()

     makeLuaSprite('theSky', 'stages/sonicexe-stage-sky', -400, -200)
	addLuaSprite('theSky' , false) 
     setLuaSpriteScrollFactor('theSky', 0.2, 0.2);

     makeLuaSprite('theCity', 'stages/sonicexe-stage-trees-background', -120, -100)
	addLuaSprite('theCity', false) 
     setLuaSpriteScrollFactor('theCity', 0.3, 0.6);

	makeLuaSprite('theTrees', 'stages/sonicexe-stage-trees', -200, -100)
	addLuaSprite('theTrees', false) 
     setLuaSpriteScrollFactor('theTrees', 1.0, 1.0);

	makeLuaSprite('theGround', 'stages/sonicexe-stage-ground', -200, -100)
	addLuaSprite('theGround', false) 
     setLuaSpriteScrollFactor('theGround', 1.0, 1.0);

     makeLuaBackdrop('clouds', 'backdrop-cloud', -400, -1000)
     setProperty('clouds.velocity.x', -80);
     setProperty('clouds.velocity.y', 0);
     addLuaBackdrop('clouds', true);
     scaleObject('clouds', 2.5, 2.5);

     close(true);
end


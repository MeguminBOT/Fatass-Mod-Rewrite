function onCreate()

   makeLuaSprite('background', 'stages/sonicexe-old-stage-lordX-background', -600, -400);
   addLuaSprite('background', false);
   setLuaSpriteScrollFactor('background', 1);
   scaleObject('background', 0.5, 0.5); 

   makeLuaSprite('hills1', 'stages/sonicexe-old-stage-lordX-hills1', -600, -500);
   addLuaSprite('hills1', false);
   setLuaSpriteScrollFactor('hills1', 0.98);
   scaleObject('hills1', 0.5, 0.5);

   makeLuaSprite('hills2', 'stages/sonicexe-old-stage-lordX-hills2', -900, -500);
   addLuaSprite('hills2', false);
   setLuaSpriteScrollFactor('hills2', 0.95);
   scaleObject('hills2', 0.5, 0.5);

   makeLuaSprite('floor', 'stages/sonicexe-old-stage-lordX-floor', -600, -400);
   addLuaSprite('floor', false);
   scaleObject('floor', 0.5, 0.5);

	if not lowQuality then -- sprites that only load if Low Quality is turned off
            makeAnimatedLuaSprite('Hands', 'stages/sonicexe-old-stage-lordX-hands', 200, -100);
            addAnimationByPrefix('Hands', 'first', 'Hands', 24, true);
            objectPlayAnimation('Hands', 'first');
            addLuaSprite('Hands', false);
            scaleObject('Hands', 0.4, 0.4);
      
            makeAnimatedLuaSprite('Tree', 'stages/sonicexe-old-stage-lordX-tree', 900, -150);
            addAnimationByPrefix('Tree', 'first', 'Tree', 24, true);
            objectPlayAnimation('Tree', 'first');
            addLuaSprite('Tree', false);
            scaleObject('Tree', 1.5, 1.5);
      
            makeAnimatedLuaSprite('EyeFlower', 'stages/sonicexe-old-stage-lordX-eyeflower', -300, 200);
            addAnimationByPrefix('EyeFlower', 'first', 'EyeFlower', 12, true);
            objectPlayAnimation('EyeFlower', 'first');
            addLuaSprite('EyeFlower', false);
            scaleObject('EyeFlower', 1.5, 1.5);
	end
      close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
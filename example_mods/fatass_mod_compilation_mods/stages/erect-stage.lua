function onCreate() 
	-- main sprites
	makeLuaSprite('stageback', 'stages/stageback-erect', -550, -200);
	setScrollFactor('stageback', 1, 1);
	makeLuaSprite('stagefront', 'stages/stagefront-erect', -675, 600);
	setScrollFactor('stagefront', 1, 1);
	scaleObject('stagefront', 1.1, 1.1);
	-- sprites that only load if Low Quality is turned off
	if not lowQuality then 
		makeLuaSprite('stagelight_left', 'stages/stagelight-erect', -125, -100);
		setScrollFactor('stagelight_left', 0.9, 0.9);
		scaleObject('stagelight_left', 1.1, 1.1);
		
		makeLuaSprite('stagelight_right', 'stages/stagelight-erect', 1225, -100);
		setScrollFactor('stagelight_right', 0.9, 0.9);
		scaleObject('stagelight_right', 1.1, 1.1);
		setProperty('stagelight_right.flipX', true); --mirror sprite horizontally
	end
	-- add sprites
	addLuaSprite('stageback', false);
	addLuaSprite('stagefront', false);
	addLuaSprite('stagelight_left', false);
	addLuaSprite('stagelight_right', false);
	addLuaSprite('stagecurtains', false);
end
function onCreate()
    -- background shit
    precacheImage('stages/schoolEvil-bgGhouls')
    precacheImage('stages/schoolEvil-animatedSchool')
    
    makeAnimatedLuaSprite('bgGhouls', 'stages/schoolEvil-bgGhouls-grey', -150, 220)
    setLuaSpriteScrollFactor('bgGhouls', 0.8, 0.8)
    scaleObject('bgGhouls', 6, 6)
    updateHitbox('bgGhouls')
    setProperty('bgGhouls.antialiasing', false)

    makeAnimatedLuaSprite('animatedSchool', 'stages/schoolEvil-animatedSchool-grey', -900, -1000)
    setLuaSpriteScrollFactor('animatedSchool', 0.8, 0.9)
    scaleObject('animatedSchool', 6, 6)
    updateHitbox('animatedSchool')
    setProperty('animatedSchool.antialiasing', false)

    addLuaSprite('animatedSchool', false) --Added offscreen before it starts moving.
    addAnimationByPrefix('animatedSchool', 'school', 'background instance', 24, true)
    addLuaSprite('bgGhouls', false)
    addAnimationByPrefix('bgGhouls', 'freaks', 'BG freaks glitch instance', 24, false)
	
    setProperty('bgGhouls.visible', false)
    

	function onEvent(name,value1,value2)
		if name == 'Trigger BG Ghouls' then 
			if value1 == '' then
                objectPlayAnimation('bgGhouls', 'freaks', true)
				setProperty('bgGhouls.visible', true);	
			elseif value1 == 'stop' then
				setProperty('bgGhouls.visible', false);
			end
		end
	end
end

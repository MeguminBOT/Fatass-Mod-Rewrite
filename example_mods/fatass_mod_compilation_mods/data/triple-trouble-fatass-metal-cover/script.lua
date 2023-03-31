function onCreate()
	-- Warn players about effects used in the song.
    debugPrint('Please disable "Flashing Effects" and "Camera Effects" in options if you are at risk of seizures')
	debugPrint('This song contains "Flashing Lights" and "Camera Shake".')
	debugPrint('Epilepsy / Photosensitivity Warning:')
	-- Precache stage
	precacheImage('stages/sonicexe-stage-sky')
	precacheImage('stages/sonicexe-stage-trees-background')
	precacheImage('stages/sonicexe-stage-trees')
	precacheImage('stages/sonicexe-stage-ground')
	-- Precache characters
	precacheImage('characters/bf-Rox-small')
	precacheImage('characters/bf-per-rox')
	precacheImage('characters/sonicexe-tails')
	precacheImage('characters/sonicexe-xeno')
	precacheImage('characters/sonicexe-robotnik')
	-- Precache icons
	precacheImage('icons/icon-bf-rox')
	precacheImage('icons/icon-sonicexe-tails')
	precacheImage('icons/icon-sonicexe-xeno')
	precacheImage('icons/icon-sonicexe-robotnik')
	-- If low quality is disabled, precache additional sprites
	if not LowQuality then 
		precacheImage('backdrop-cloud')
		if flashingLights then -- If Flashing Lights are enabled, precache additional sprites
			precacheImage('stages/triple-trouble-static-transition')
			precacheImage('stages/triple-trouble-static-phase3-bg')
			precacheImage('stages/triple-trouble-jumpscare-robotnik')
			precacheImage('stages/triple-trouble-jumpscare-tails')
			precacheImage('static')
			precacheImage('static-tv')
			precacheImage('vignette-red')
			precacheImage('vignette-black')
		end
	end
	-- If low quality is disabled, Prepare the conditional sprites
	if not LowQuality then 
		if flashingLights then -- If Flashing Lights are enabled, precache additional sprites
			makeAnimatedLuaSprite('transition', 'stages/triple-trouble-static-transition', -400, -150);
			addAnimationByPrefix('transition', 'first', 'static-transition', 30, false);
			scaleObject('transition', 6, 6);
			makeAnimatedLuaSprite('phase3-bg', 'stages/triple-trouble-static-phase3-bg', -120, -100);
			addAnimationByPrefix('phase3-bg', 'first', 'static-phase3-bg', 30, true);
			objectPlayAnimation('phase3-bg', 'first');
			scaleObject('phase3-bg', 6, 6);
		end
	end
    -- Prepare the stage
    makeLuaSprite('theSky', 'stages/sonicexe-stage-sky', -400, -200)
    makeLuaSprite('theCity', 'stages/sonicexe-stage-trees-background', -120, -100)
	makeLuaSprite('theTrees', 'stages/sonicexe-stage-trees', -200, -100)
	makeLuaSprite('theGround', 'stages/sonicexe-stage-ground', -200, -100)
    if not LowQuality then -- If low quality is disabled, prepare the fog effect
        makeLuaBackdrop('clouds', 'backdrop-cloud', -400, -1000)
        setProperty('clouds.velocity.x', -80);
        setProperty('clouds.velocity.y', 0);
        scaleObject('clouds', 2.5, 2.5);
    end
    -- Configure the stage movement relative to camera
    setLuaSpriteScrollFactor('theSky', 0.2, 0.2);
    setLuaSpriteScrollFactor('theCity', 0.3, 0.6);
    setLuaSpriteScrollFactor('theTrees', 1.0, 1.0);
    setLuaSpriteScrollFactor('theGround', 1.0, 1.0);
    -- Create the stage
    if not LowQuality then -- If low quality is disabled, create phase 3 bg
        if flashingLights then -- If Flashing Lights is enabled, create phase 3 bg
            addLuaSprite('phase3-bg', false)
        end
    end
    addLuaSprite('theSky', false) 
	addLuaSprite('theCity', false) 
	addLuaSprite('theTrees', false) 
	addLuaSprite('theGround', false) 
    if not LowQuality then -- If low quality is disabled, create the fog effect
        addLuaBackdrop('clouds', true);
    end
end

function onBeatHit()
	-- Swap Characters / Background
	if curBeat == 0 then
        if not LowQuality then -- If Low Quality is disabled, make sure phase 3 bg isn't visible
            if flashingLights then -- If Flashing Lights is enabled, make sure phase 3 bg isn't visible
                setProperty('phase3-bg.visible', false);
            end
        end
        setProperty('theSky.visible', true);
	end
	if curBeat == 260 then
		triggerEvent('Change Character', 'dad', 'sonicexe-xeno')
		triggerEvent('Change Character', 'bf', 'bf-per-rox')
        if not LowQuality then 
            if flashingLights then 
                setProperty('phase3-bg.visible', true);
                setProperty('theSky.visible', false);
            end
        end
	end
	if curBeat == 452 then
		triggerEvent('Change Character', 'dad', 'sonicexe-robotnik')
		triggerEvent('Change Character', 'bf', 'bf-Rox-small')
        if not LowQuality then 
            if flashingLights then 
                setProperty('phase3-bg.visible', false);
                setProperty('theSky.visible', true);
            end
        end
	end
	if curBeat == 772 then
		triggerEvent('Change Character', 'dad', 'sonicexe-xeno')
		triggerEvent('Change Character', 'bf', 'bf-per-rox')
        if not LowQuality then 
            if flashingLights then 
                setProperty('phase3-bg.visible', true);
                setProperty('theSky.visible', false);
            end
        end
	end
	-- Transition Animation Start
	if not LowQuality then -- If Low Quality is disabled, allow the transition animation to play.
		if flashingLights then -- If Flashing Lights are enabled, allow the transition animation to play.
			if curBeat == 1 then
				addLuaSprite('transition', true);
				objectPlayAnimation('transition', 'first');
			end
			if curBeat == 256 then
				objectPlayAnimation('transition', 'first');
				addLuaSprite('transition', true);
			end
			if curBeat == 448 then
				objectPlayAnimation('transition', 'first');
				addLuaSprite('transition', true);
			end
			if curBeat == 768 then
				objectPlayAnimation('transition', 'first');
				addLuaSprite('transition', true);
			end
		end
	end
end

function onStepHit()
	-- Eggman Laugh Animation
	if curStep == 1864 then
		triggerEvent('Play Animation', 'laugh', 'dad');
	end
	if curStep == 1992 then
		triggerEvent('Play Animation', 'laugh', 'dad');
	end
	if curStep == 3016 then
		triggerEvent('Play Animation', 'laugh', 'dad');
	end
	-- Transition Animation End
	if not LowQuality then -- If Low Quality is disabled, allow the transition animation to end.
		if flashingLights then -- If Flashing Lights are enabled, allow the transition animation to end.
			if curStep == 18 then
				removeLuaSprite('transition', false);
			end
			if curStep == 1042 then
				removeLuaSprite('transition', false);
			end
			if curStep == 1810 then
				removeLuaSprite('transition', false);
			end
			if curStep == 3090 then
				removeLuaSprite('transition', false);
			end
		end	
	end
end

function opponentNoteHit()
	health = getProperty('health')
	if getProperty('health') > 1 then
		setProperty('health', health -0.025);
	end
end
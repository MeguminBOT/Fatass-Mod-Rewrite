local xx = 520;
local yy = 451;
local xx2 = 820;
local yy2 = 451;
local ofs = 60;
local followchars = true;
local del = 0;
local del2 = 0;

function onCreate()
    debugPrint('Please disable "Flashing Effects" and "Camera Shake" in options if you are at risk of seizures')
	debugPrint('This song contains "Flashing Lights" and "Camera Shake".')
	debugPrint('Epilepsy / Photosensitivity Warning:')

    if not lowQuality then  -- If Low Quality is disabled, allow the precaching of assets
        if flashingLights then  -- If Flashing Lights are enabled, allow the precaching of assets
            precacheImage('stages/stagecurtains-erect-left')
            precacheImage('stages/stagecurtains-erect-down')
            precacheImage('stages/stagecurtains-erect-up')
            precacheImage('stages/stagecurtains-erect-right')
            precacheImage('stages/stagefront-beatglow')
        end
    end
end

function onBeatHit(id, noteData, isSustainNote)
    if not lowQuality then  -- If Low Quality is disabled, allow the code to run
        if flashingLights then  -- If Flashing Lights are enabled, allow the code to run
            makeLuaSprite('beatglow', 'stages/stagefront-erect-beatglow', -675, 600);
            scaleObject('beatglow', 1.1, 1.1)
            addLuaSprite('beatglow', false);
            runTimer('wait', 0.1);
        end
    end
end

function opponentNoteHit(id, noteData, isSustainNote)
    if not lowQuality then  -- If Low Quality is disabled, allow the code to run
        if flashingLights then  -- If Flashing Lights are enabled, allow the code to run
            if noteData == 0 then  -- Left Note
                -- Stage lights
                makeLuaSprite('stagelight-left', 'stages/stagecurtains-erect-left', -800, -525);
                setScrollFactor('stagelight-left', 1.3, 1.3);
                scaleObject('stagelight-left', 1.2, 1.2);
                addLuaSprite('stagelight-left', false);       
                setObjectCamera('stagelight-left', 'camGame');
            elseif noteData == 1 then  -- Down Note
                -- Stage lights                
                makeLuaSprite('stagelight-down', 'stages/stagecurtains-erect-down', -800, -525);
                setScrollFactor('stagelight-down', 1.3, 1.3);
                scaleObject('stagelight-down', 1.2, 1.2);
                addLuaSprite('stagelight-down', false); 
                setObjectCamera('stagelight-down', 'camGame');   
            elseif noteData == 2 then  -- Up Note
                -- Stage lights
                makeLuaSprite('stagelight-up', 'stages/stagecurtains-erect-up', -800, -525);
                setScrollFactor('stagelight-up', 1.3, 1.3);
                scaleObject('stagelight-up', 1.2, 1.2);
                addLuaSprite('stagelight-up', false);    
                setObjectCamera('stagelight-up', 'camGame');
            elseif noteData == 3 then  -- Right Note
                -- Stage lights
                makeLuaSprite('stagelight-right', 'stages/stagecurtains-erect-right', -800, -525);
                setScrollFactor('stagelight-right', 1.3, 1.3);
                scaleObject('stagelight-right', 1.2, 1.2);
                addLuaSprite('stagelight-right', false);    
                setObjectCamera('stagelight-right', 'camGame');
            end
        end
	end
end

function goodNoteHit(id, noteData, isSustainNote)
    if not lowQuality then  -- If Low Quality is disabled, allow the code to run
        if flashingLights then  -- If Flashing Lights are enabled, allow the code to run
            if noteData == 0 then  -- Left Note
                -- Stage lights
                makeLuaSprite('stagelight-left', 'stages/stagecurtains-erect-left', -800, -525);
                setScrollFactor('stagelight-left', 1.3, 1.3);
                scaleObject('stagelight-left', 1.2, 1.2);
                addLuaSprite('stagelight-left', false);       
                setObjectCamera('stagelight-left', 'camGame');
            elseif noteData == 1 then  -- Down Note
                -- Stage lights
                makeLuaSprite('stagelight-down', 'stages/stagecurtains-erect-down', -800, -525);
                setScrollFactor('stagelight-down', 1.3, 1.3);
                scaleObject('stagelight-down', 1.2, 1.2);
                addLuaSprite('stagelight-down', false); 
                setObjectCamera('stagelight-down', 'camGame');   
            elseif noteData == 2 then  -- Up Note
                -- Stage lights
                makeLuaSprite('stagelight-up', 'stages/stagecurtains-erect-up', -800, -525);
                setScrollFactor('stagelight-up', 1.3, 1.3);
                scaleObject('stagelight-up', 1.2, 1.2);
                addLuaSprite('stagelight-up', false);    
                setObjectCamera('stagelight-up', 'camGame');
            elseif noteData == 3 then  -- Right Note
                -- Stage lights
                makeLuaSprite('stagelight-right', 'stages/stagecurtains-erect-right', -800, -525);
                setScrollFactor('stagelight-right', 1.3, 1.3);
                scaleObject('stagelight-right', 1.2, 1.2);
                addLuaSprite('stagelight-right', false);    
                setObjectCamera('stagelight-right', 'camGame');
            end
        end
	end
end
		
function onTimerCompleted(tag, loops, loopsleft)
    if not lowQuality then  -- If Low Quality is disabled, allow the code to run
        if flashingLights then  -- If Flashing Lights are enabled, allow the code to run
            if tag == 'wait' then
                doTweenAlpha('byebye', 'beatglow', 0, 0.2, 'linear');
            end
        end
    end
end
	
function onTweenCompleted(tag)
    if not lowQuality then  -- If Low Quality is disabled, allow the code to run
        if flashingLights then  -- If Flashing Lights are enabled, allow the code to run
            if tag == 'byebye' then
                doTweenAlpha('beatglow', 0.1, 1.2, 'linear');
                removeLuaSprite('beatglow', true);
            end
        end
    end
end

function onUpdate(elapsed)
    if cameraZoomOnBeat then  -- If Camera Effects are enabled, allow the code to run
        if del > 0 then
            del = del - 1
        end
        if del2 > 0 then
            del2 = del2 - 1
        end
        if followchars == true then
            if mustHitSection == false then
                if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                    triggerEvent('Camera Follow Pos',xx-ofs,yy)
                end
                if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                    triggerEvent('Camera Follow Pos',xx+ofs,yy)
                end
                if getProperty('dad.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos',xx,yy-ofs)
                end
                if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                    triggerEvent('Camera Follow Pos',xx,yy+ofs)
                end
                if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                    triggerEvent('Camera Follow Pos',xx-ofs,yy)
                end
                if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                    triggerEvent('Camera Follow Pos',xx+ofs,yy)
                end
                if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                    triggerEvent('Camera Follow Pos',xx,yy-ofs)
                end
                if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                    triggerEvent('Camera Follow Pos',xx,yy+ofs)
                end
                if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                    triggerEvent('Camera Follow Pos',xx,yy)
                end
                if getProperty('dad.animation.curAnim.name') == 'idle' then
                    triggerEvent('Camera Follow Pos',xx,yy)
                end
            else
                if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                    triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                    triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                    triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
                end
                if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                    triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
                end
            if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                    triggerEvent('Camera Follow Pos',xx2,yy2)
                end
            end
        else
            triggerEvent('Camera Follow Pos','','')
        end
    end
end
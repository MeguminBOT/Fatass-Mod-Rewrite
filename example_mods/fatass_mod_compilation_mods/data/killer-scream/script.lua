function onCreate()
	if not LowQuality then
		makeLuaSprite('winningicon', 'icons/icon-aloe-mano-winning', getProperty('iconP1.x'), getProperty('iconP1.y')) -- creates a fake icon for BF
		makeLuaSprite('winningiconP2', 'icons/icon-rushia-winning', getProperty('iconP2.x'), getProperty('iconP2.y')) -- creates a fake icon for opponent
		setScrollFactor('winningicon', 0, 0)
		setScrollFactor('winningiconP2', 0, 0)
		setObjectCamera('winningiconP2', 'other')
		setObjectCamera('winningicon', 'other')
	end
end

function onUpdate(elapsed)
	if getProperty('health') >= 1.6 then
		setProperty('iconP1.alpha', 0)
		addLuaSprite('winningicon', true)
			elseif getProperty('health') < 1.6 and getProperty('health') > 0.4 then
				setProperty('iconP1.alpha', 1)
				setProperty('iconP2.alpha', 1)
				removeLuaSprite('winningicon', false)
				removeLuaSprite('winningiconP2', false)
					elseif getProperty('health') <= 0.4 then
						setProperty('iconP2.alpha', 0)
						addLuaSprite('winningiconP2', true) -- HP checks
						
	end
	setProperty('camOther.zoom', getProperty('camHUD.zoom'))
	setProperty('winningicon.x', getProperty('iconP1.x'))
	setProperty('winningicon.y', getProperty('iconP1.y'))
	setProperty('winningicon.scale.x', getProperty('iconP1.scale.x'))
	setProperty('winningicon.scale.y', getProperty('iconP1.scale.y'))
	setProperty('winningiconP2.x', getProperty('iconP2.x'))
	setProperty('winningiconP2.y', getProperty('iconP2.y'))
	setProperty('winningicon.scaleP2.x', getProperty('iconP2.scale.x'))
	setProperty('winningicon.scaleP2.y', getProperty('iconP2.scale.y'))-- position checks
end
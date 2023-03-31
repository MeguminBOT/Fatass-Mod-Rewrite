-- makeLuaSprite ('vad ska sprite objektet heta', 'spritens riktiga namn', posX, posy);
    -- makeAnimatedLuaSprite('vad ska sprite animations objektet heta', 'spritens riktiga namn', posX, posy);



    -- setLuaSpriteScrollFactor('objektnamn', scrollX, scrollY); scrollX/Y på "1" resulterar i att bilden scrollar inte med camera changes

    -- scaleObject('objektnamn', ScaleX, ScaleY);

    -- setProperty('objektnamn.antialiasing', false/true);

    -- addLuaSprite('animatedEvilSchool', false);
    -- addAnimationByPrefix('vad ska animationen heta', 'first', 'spritens riktiga animation namn', 24, true);

function onCreate()
	-- background shit
	makeLuaSprite('stageback', 'stages/guitarhero-stageback', -550, -200);
	setScrollFactor('stageback', 1, 1);
	addLuaSprite('stageback', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
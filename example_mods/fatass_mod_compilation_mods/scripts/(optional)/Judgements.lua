function onCreatePost()
	makeLuaText('perfect sicks', 'Perfect Sicks: ' .. getProperty('sicks'), 1260, 0, 550);
	makeLuaText('sicks', 'Sicks: ' .. getProperty('greats'), 1270, 0, 575);
	makeLuaText('goods', 'Goods: ' .. getProperty('goods'), 1270, 0, 600);
	makeLuaText('bads', 'Bads: ' .. getProperty('bads'), 1270, 0, 625);
	makeLuaText('shits', 'Shits: ' .. getProperty('shits'), 1270, 0, 650);
	addLuaText('perfect sicks');
	addLuaText('sicks');
	addLuaText('goods');
	addLuaText('bads');
	addLuaText('shits');
    setTextFont('perfect sicks', 'rubik.ttf');
	setTextFont('sicks', 'rubik.ttf');
    setTextFont('goods', 'rubik.ttf');
    setTextFont('bads', 'rubik.ttf');
    setTextFont('shits', 'rubik.ttf');
end

function onRecalculateRating()
	setTextString('perfect sicks', 'Perfect Sicks: ' .. getProperty('sicks'));
	setTextString('sicks', 'Sicks: ' .. getProperty('greats'));
	setTextString('goods', 'Goods: ' .. getProperty('goods'));
	setTextString('bads', 'Bads: ' .. getProperty('bads'));
	setTextString('shits', 'Shits: ' .. getProperty('shits'));
end
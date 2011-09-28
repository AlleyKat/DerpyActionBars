-- local replacement = {
	-- ["(Mouse Button )"] =









-- }


local range = _G['RANGE_INDICATOR']
local replace = string.gsub
local function updatehotkey(self)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()
	if text == range then
		hotkey:SetText('')
	else
		text = replace(text, '(s%-)', 'S')
		text = replace(text, '(a%-)', 'A')
		text = replace(text, '(c%-)', 'C')
		text = replace(text, '(Mouse Button )', 'M')
		text = replace(text, '(Middle Mouse)', 'M3')
		text = replace(text, '(Средняя кнопка мыши)', 'M3')
		text = replace(text, '(Кнопка мыши )', 'M')
		text = replace(text, '(Num Pad )', 'N')
		text = replace(text, '(Page Up)', 'PU')
		text = replace(text, '(Page Down)', 'PD')
		text = replace(text, '(Spacebar)', 'SpB')
		text = replace(text, '(Insert)', 'Ins')
		text = replace(text, '(Home)', 'Hm')
		text = replace(text, '(Delete)', 'Del')
		hotkey:SetFormattedText("|cffFFFFFF%s",text)
	end
end

hooksecurefunc("ActionButton_UpdateHotkeys",updatehotkey)
--[[
	Thx to Tulla, most lowest cpu usage range script
		Adds out of range coloring to action buttons
		Derived from RedRange with negligable improvements to CPU usage
--]]

--[[ locals and speed ]]--
local C,M,L,V = unpack(select(2,...))

if V.range ~= true then return end

local _G = _G
local TULLARANGE_COLORS

local ActionButton_GetPagedID = ActionButton_GetPagedID
local ActionButton_IsFlashing = ActionButton_IsFlashing
local ActionHasRange = ActionHasRange
local IsActionInRange = IsActionInRange
local IsUsableAction = IsUsableAction
local HasAction = HasAction


--[[ The main thing ]]--

local tullaRange = CreateFrame('Frame', 'tullaRange', UIParent); tullaRange:Hide()

--[[ Game Events ]]--

M.addafter(function()
	
	if not TULLARANGE_COLORS then
		TULLARANGE_COLORS = {
		normal = {1, 1, 1},
		oor = {1, 0.1, 0.1},
		oom = {0.1, 0.3, 1},
	}
	end
	tullaRange.colors = TULLARANGE_COLORS

	tullaRange.buttonsToUpdate = {}
	do
		local tullaRange = tullaRange
		M.set_updater(function() tullaRange:UpdateButtons() end,"DerpyRangeColors",.1,true)
	end
	hooksecurefunc('ActionButton_OnUpdate', tullaRange.RegisterButton)
	hooksecurefunc('ActionButton_UpdateUsable', tullaRange.OnUpdateButtonUsable)
	hooksecurefunc('ActionButton_Update', tullaRange.OnButtonUpdate)
end)


--[[ Actions ]]--

function tullaRange:Update()
	self:UpdateButtons()
end

function tullaRange:ForceColorUpdate()
	for button in pairs(self.buttonsToUpdate) do
		tullaRange.OnUpdateButtonUsable(button)
	end
end

function tullaRange:UpdateShown()
	if next(self.buttonsToUpdate) then
		self:Show()
	else
		self:Hide()
	end
end

function tullaRange:UpdateButtons()
	if not next(self.buttonsToUpdate) then
		self:Hide()
		return
	end

	for button in pairs(self.buttonsToUpdate) do
		self:UpdateButton(button)
	end
end

function tullaRange:UpdateButton(button)
	tullaRange.UpdateButtonUsable(button)
end

function tullaRange:UpdateButtonStatus(button)
	local action = ActionButton_GetPagedID(button)
	if not(button:IsVisible() and action and HasAction(action) and ActionHasRange(action)) then
		self.buttonsToUpdate[button] = nil
	else
		self.buttonsToUpdate[button] = true
	end
	self:UpdateShown()
end



--[[ Button Hooking ]]--

function tullaRange.RegisterButton(button)
	button:HookScript('OnShow', tullaRange.OnButtonShow)
	button:HookScript('OnHide', tullaRange.OnButtonHide)
	button:SetScript('OnUpdate', nil)

	tullaRange:UpdateButtonStatus(button)
end

function tullaRange.OnButtonShow(button)
	tullaRange:UpdateButtonStatus(button)
end

function tullaRange.OnButtonHide(button)
	tullaRange:UpdateButtonStatus(button)
end

function tullaRange.OnUpdateButtonUsable(button)
	button.tullaRangeColor = nil
	tullaRange.UpdateButtonUsable(button)
end

function tullaRange.OnButtonUpdate(button)
	 tullaRange:UpdateButtonStatus(button)
end


--[[ Range Coloring ]]--

function tullaRange.UpdateButtonUsable(button)
	local action = ActionButton_GetPagedID(button)
	local isUsable, notEnoughMana = IsUsableAction(action)

	--usable
	if isUsable then
		--but out of range
		if IsActionInRange(action) == 0 then
			tullaRange.SetButtonColor(button, 'oor')
		--in range
		else
			tullaRange.SetButtonColor(button, 'normal')
		end
	--out of mana
	elseif notEnoughMana then
		tullaRange.SetButtonColor(button, 'oom')
	--unusable
	else
		tullaRange.ResetColorBack(button, 'unusuable')
	end
end

function tullaRange.SetButtonColor(button, colorType)
	if button.tullaRangeColor ~= colorType then
		button.tullaRangeColor = colorType
		local r, g, b = tullaRange:GetColor(colorType)
		local icon =  _G[button:GetName() .. 'Icon']
		if not button._derpy_mask then return end
		if button.tullaRangeColor == 'normal' then 
			button._derpy_mask:backcolor(0,0,0)
			icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
		else
			button._derpy_mask:backcolor(r*.7,g*.7,b*.7,.7)
			icon:SetGradient("VERTICAL",r*.6, g*.6, b*.6, r, g, b)
		end
	end
end

function tullaRange.ResetColorBack(button, colorType)
	if button.tullaRangeColor ~= colorType then
		button.tullaRangeColor = colorType
		if not button._derpy_mask then return end
		button._derpy_mask:backcolor(0,0,0)
	end
end

function tullaRange:Reset()
	self.colors = TULLARANGE_COLORS
	self:ForceColorUpdate()
end

function tullaRange:SetColor(index, r, g, b)
	local color = self.colors[index]
	color[1] = r
	color[2] = g
	color[3] = b
	self:ForceColorUpdate()
end

function tullaRange:GetColor(index)
	local color = self.colors[index]
	return color[1], color[2], color[3]
end
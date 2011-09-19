local C,M,L,V = unpack(select(2,...))
if V.showtotems ~= true then return end

--[[	Shaman Totem Bar Skin by Darth Android / Telroth-Black Dragonflight		]]--

local bordercolors = {
	{.23,.45,.13},    -- Earth
	{.58,.23,.10},    -- Fire
	{.19,.48,.60},   -- Water
	{.42,.18,.74},   -- Air
	{.39,.39,.12}    -- Summon / Recall
}

local reset_color = function(self,r,g,b,mode)
	self.top:SetTexture(r,g,b)
	self.bottom:SetTexture(r,g,b)
	self.left:SetTexture(r,g,b)
	self.right:SetTexture(r,g,b)
	if mode then
		self:SetBackdropColor(r*.4,g*.4,b*.4)
		self.bg:SetTexture(nil)
	end
		self:SetBackdropBorderColor(r,g,b,.4)
end
		
local function SkinFlyoutButton(button)
	if not button.skin then
		button.skin = CreateFrame("Frame",nil,button)
		local bb = M.frame(button.skin)
		bb:SetPoint("TOPLEFT",-4,4)
		bb:SetPoint("BOTTOMRIGHT",4,-4)
	end
	
	button:GetNormalTexture():SetTexture(nil)
	button:ClearAllPoints()
	button.skin:ClearAllPoints()
	button.skin:SetFrameStrata("TOOLTIP")
	button.skin:SetFrameLevel(6)

	button:SetWidth(28)
	button:SetHeight(14)
	button.skin:SetWidth(28)
	button.skin:SetHeight(10)
	button:SetPoint("BOTTOM",button:GetParent(),"TOP")    
	button.skin:SetPoint("TOP",button,"TOP")

	button:GetHighlightTexture():SetTexture(1,1,1,.222)
	button:GetHighlightTexture():ClearAllPoints()
	button:GetHighlightTexture():SetAllPoints(button.skin)
end

local function SkinActionButton(button, colorr, colorg, colorb)
	button:SetBackdropBorderColor(colorr,colorg,colorb)
	button:SetBackdropColor(0,0,0,0)
	button:ClearAllPoints()
	button:SetAllPoints(button.slotButton)
	button:GetNormalTexture():SetTexture(nil)
	button:GetRegions():SetDrawLayer("ARTWORK")
end

local function SkinButton(button,colorr, colorg, colorb)
	button.background:SetDrawLayer("BORDER")
	button.background:ClearAllPoints()
	button.background:SetPoint("TOPLEFT",button,"TOPLEFT",2,-2)
	button.background:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	button:SetNormalTexture(nil)
	
	if not button.f_skin then
		local skin = M.frame(button)
		skin:SetPoint("TOPLEFT",button,-4,4)
		skin:SetPoint("BOTTOMRIGHT",button,4,-4)
		button.f_skin = skin
	end
	
	reset_color(button.f_skin,colorr, colorg, colorb, true)
	button:SetSize(32,32)
	button:SetBackdropBorderColor(colorr,colorg,colorb)
end

local function SkinSummonButton(button,colorr, colorg, colorb)
	local icon = select(1,button:GetRegions())
	icon:SetDrawLayer("ARTWORK")
	icon:ClearAllPoints()
	icon:SetPoint("TOPLEFT",button,"TOPLEFT")
	icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT")
	icon:SetTexCoord(.1,.9,.1,.9)
	if not button.ss then	
		local skin = M.frame(button)
		skin:SetPoint("TOPLEFT",button,-4,4)
		skin:SetPoint("BOTTOMRIGHT",button,4,-4)
		button.ss = skin
	end
	reset_color(button.ss,colorr, colorg, colorb)
	button:SetSize(32,32)
	button:SetNormalTexture("")
	button:SetPushedTexture(0,0,0,.4)
	button:SetHighlightTexture(1,1,1,.2)
	button.SetNormalTexture = M.null
end

local function SkinFlyoutTray(tray)
	local parent = tray.parent
	local buttons = {select(2,tray:GetChildren())}
	local closebutton = tray:GetChildren()
	local numbuttons = 0


	for i,k in ipairs(buttons) do
		local prev = i > 1 and buttons[i-1] or tray

		if k:IsVisible() then numbuttons = numbuttons + 1 end

		if k.icon then
			k.icon:SetDrawLayer("ARTWORK")
			k.icon:ClearAllPoints()
			k.icon:SetPoint("TOPLEFT",k)
			k.icon:SetPoint("BOTTOMRIGHT",k)
			
			if not k.a then
				local a = M.frame(k)
				a:SetPoint("TOPLEFT",-4,4)
				a:SetFrameStrata("LOW")
				a:SetFrameLevel(10)
				a:SetPoint("BOTTOMRIGHT",4,-4)
				k.a = a
			end
			local t1,t2,t3 = unpack(bordercolors[((parent.idx-1)%5)+1])
			reset_color(k.a,t1,t2,t3)
			if k.icon:GetTexture() ~= [[Interface\Buttons\UI-TotemBar]] then
				k.icon:SetTexCoord(.1,.9,.1,.9)
			end
		end
		k:SetHighlightTexture(nil)
		k:ClearAllPoints()
		k:SetPoint("BOTTOM",prev,"TOP",0,6)
	end

	tray.middle:SetTexture(nil)
	tray.top:SetTexture(nil)

	if not closebutton.ss then
		local s_skin = M.frame(closebutton,2,"HIGH")
		s_skin:SetPoint("TOPLEFT",-4,4)
		s_skin:SetPoint("BOTTOMRIGHT",4,-4)
		closebutton.ss = s_skin
	end
	
	closebutton:GetHighlightTexture():SetTexture(1,1,1,.222)
	closebutton:GetHighlightTexture():SetPoint("TOPLEFT")
	closebutton:GetHighlightTexture():SetPoint("BOTTOMRIGHT")
	closebutton:GetNormalTexture():SetTexture(nil)

	tray:ClearAllPoints()
	closebutton:ClearAllPoints()
	
	tray:SetWidth(32)
	tray:SetHeight(30 * numbuttons)
	closebutton:SetHeight(10)
	closebutton:SetWidth(28)

	tray:SetPoint("BOTTOM",parent,"TOP",0,7)
	closebutton:SetPoint("BOTTOM",tray,"TOP",0,6)
	buttons[1]:SetPoint("BOTTOM",tray,"BOTTOM",0,7)
end

local loloffset = V.showgcd == true and 12 or 0

M.addafter(function()
		local bgframe = CreateFrame("Frame","TotemBG",MultiCastSummonSpellButton)
		bgframe:SetHeight(44)
		bgframe:SetWidth(234)
		bgframe:SetFrameStrata("LOW")
		bgframe:ClearAllPoints()

		bgframe:SetHeight(44)
		bgframe:SetWidth(234)
		bgframe:SetPoint("BOTTOMLEFT",MultiCastSummonSpellButton,"BOTTOMLEFT",-6,-6)

		for i = 1,12 do
			if i < 6 then
				local button = _G["MultiCastSlotButton"..i] or MultiCastRecallSpellButton
				local prev = _G["MultiCastSlotButton"..(i-1)] or MultiCastSummonSpellButton
				prev.idx = i - 1
				if i == 1 or i == 5 then
					SkinSummonButton(i == 5 and button or prev,unpack(bordercolors[5]))
				end
				if i < 5 then
					SkinButton(button,unpack(bordercolors[((i-1) % 4) + 1]))
				end
				button:ClearAllPoints()
				ActionButton1.SetPoint(button,"LEFT",prev,"RIGHT",6,0)
			end
			SkinActionButton(_G["MultiCastActionButton"..i],unpack(bordercolors[((i-1) % 4) + 1]))
		end
		MultiCastFlyoutFrame:HookScript("OnShow",SkinFlyoutTray)
		MultiCastFlyoutFrameOpenButton:HookScript("OnShow", function(self) if MultiCastFlyoutFrame:IsShown() then MultiCastFlyoutFrame:Hide() end SkinFlyoutButton(self) end)
		MultiCastFlyoutFrame:SetFrameLevel(4)
		
		MultiCastActionBarFrame:SetParent(UIParent)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetPoint("BOTTOM",ActionButton1,"TOP",96,3+(V.showgcd == true and 12 or 0)+(not (V.reverse) and ({0,38,0,38,38,38,74,74})[V.layout] or 0))
		 
		for i = 1, 4 do
			local b = _G["MultiCastSlotButton"..i]
			local b2 = _G["MultiCastActionButton"..i]
			if i == 3 then
				b:ClearAllPoints()
				b:SetPoint("LEFT",MultiCastSlotButton2,"RIGHT",({538,538,918,918,348,728,310,538})[V.layout],0)
			end
			b2:ClearAllPoints()
			b2:SetAllPoints(b)
		end
		 
		MultiCastActionBarFrame.SetParent = M.null
		MultiCastActionBarFrame.SetPoint = M.null
		MultiCastRecallSpellButton.SetPoint = M.null
end)

-- taked from tukui:
-- Skin the actual totem buttons
local function _StyleTotemActionButton(button, index)
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.1,.9,.1,.9)
	icon:SetDrawLayer("ARTWORK")
	icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
	button.overlayTex:SetTexture(nil)
	button.overlayTex:Hide()
	button:GetNormalTexture():SetAlpha(0)
	if not InCombatLockdown() and button.slotButton then
		button:ClearAllPoints()
		button:SetAllPoints(button.slotButton)
		button:SetFrameLevel(button.slotButton:GetFrameLevel()+1)
	end
	button:SetBackdropBorderColor(unpack(bordercolors[((index-1) % 4) + 1]))
	button:SetBackdropColor(0,0,0,0)
end
hooksecurefunc("MultiCastActionButton_Update",function(actionButton, actionId, actionIndex, slot) _StyleTotemActionButton(actionButton,actionIndex) end)

-- Skin the summon and recall buttons
local function _StyleTotemSpellButton(button, index)
	if not button then return end
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.1,.9,.1,.9)
	icon:SetDrawLayer("ARTWORK")
	icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
	button:GetNormalTexture():SetTexture(nil)
	if not InCombatLockdown() then button:SetSize(32,32) end
	_G[button:GetName().."Highlight"]:SetTexture(nil)
	_G[button:GetName().."NormalTexture"]:SetTexture(nil)
end
hooksecurefunc("MultiCastSummonSpellButton_Update", function(self) _StyleTotemSpellButton(self,0) end)
hooksecurefunc("MultiCastRecallSpellButton_Update", function(self) _StyleTotemSpellButton(self,5) end)

if V.layout == 5 or V.layout == 7 then
	M.move_focus_target_up = true 
end

local C,M,L,V = unpack(select(2,...))
local _G = _G

-- HOOK FOR VERTEX COLOR
local teh_new_vertex = function(self,r,g,b)
	if self.r_old == r and self.g_old == g and self.b_old == b then return end
	self.r_old = r
	self.g_old = g
	self.b_old = b
	if r < .5 and b < .5 and g < .5 then
		self:SetGradient("VERTICAL",r*.24, g*.24, b*.24, r, g, b)
	else
		self:SetGradient("VERTICAL",r*.5, g*.5, b*.5, r, g, b)
	end
end

-- MAIN STYLE
local style
do
	local showmacro = V.showmacro 
	local hovermacro = V.hovermacro
	local select = select
	local teh_new_vertex = teh_new_vertex
	local getregion = function(self,num)
		local x = select(num,self:GetRegions())
		return x
	end	
	style = function(self,mode)
		local __t = self:GetPushedTexture()
			if __t then
				if __t.maked ~= true then
					__t:SetTexture(M.media.blank)
					__t:SetVertexColor(1,1,1,.2)
					__t.SetTexture = M.null
					__t.maked = true
				end
			end
		local Border = getregion(self,14)
			if Border then
				if Border.maked ~= true then
					Border:SetTexture(nil)
					Border:Hide()
					Border.Show = M.null
					Border.maked = true
				end
			end
			
		if self.setd then return end -- END
		
			local name = self:GetName()
		
			self:SetNormalTexture(nil)
			self.SetSetNormalTexture = M.null
			
			local Flash	 = _G[name.."Flash"]
			Flash:SetTexture(nil)
			Flash.SetTexture = M.null
			
			local __t = self:GetCheckedTexture()
			__t:SetTexture(M.media.blank)
			__t:SetVertexColor(1,1,1,.2)
			__t.SetTexture = M.null
			
			local __t = self:GetHighlightTexture()
			__t:SetTexture(M.media.blank)
			__t:SetVertexColor(1,1,1,.2)
			__t.SetTexture = M.null
			
			local __t = getregion(self,3)
			__t:Hide()
			__t.Show = M.null
			
			local __t = getregion(self,4)
			__t:Hide()
			__t.Show = M.null
			
		local f
		
		if name:match("MultiCast") then 
			f = true
			local icon = getregion(self,1)
			icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
			icon.SetVertexColor = teh_new_vertex
		end
		
		local HotKey = _G[name.."HotKey"]
			HotKey:ClearAllPoints()
			HotKey:SetPoint("TOPRIGHT", 1, -1)
			HotKey:SetFont(M["media"].font, 13, "OUTLINE")
			HotKey:SetShadowOffset(1, -1)
			
			self.setd = true
			
		if f then return end
			
		local Icon = _G[name.."Icon"]
		local Count = _G[name.."Count"]
		local Btname = _G[name.."Name"]
			
		if not mode then
			if self.flyR then
				Icon:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
			else
				Icon:SetTexCoord(3/32,1-3/32,5/32,1-5/32)
			end
		end
			
		Icon:SetPoint("TOPLEFT", self)
		Icon:SetPoint("BOTTOMRIGHT", self)
		Icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
		if not mode then 
			Icon.SetVertexColor = teh_new_vertex
		end
			
		if V.shownames ~= true then
			HotKey:Hide()
		elseif V.hovernames == true then
			HotKey:SetDrawLayer("HIGHLIGHT")
		end	
			
		HotKey.ClearAllPoints = M.null
		HotKey.SetPoint = M.null
			
		if HotKey:GetText() then
			HotKey:SetFormattedText("|cffFFFFFF%s",HotKey:GetText())
		end
		
		if Btname then
			Btname:ClearAllPoints()
			Btname:SetPoint("LEFT",.5,-1)
			Btname:SetPoint("RIGHT",-.5,-1)
			Btname:SetJustifyH("CENTER")
			if showmacro ~= true then
				Btname:SetText("")
				Btname:Hide()
				Btname.Show = M.null
			elseif hovermacro == true then
				Btname:SetDrawLayer("HIGHLIGHT")
			end
		end
			
		Count:ClearAllPoints()
		Count:SetPoint("BOTTOMRIGHT", 1, 1)
		Count:SetShadowOffset(1, -1)
		Count:SetFont(M["media"].font, 13, "OUTLINE")
	end
end

--PET BAR
local StylePet
do
	local teh_new_vertex = teh_new_vertex
	local function stylesmallbutton(name)
		local button = _G[name]
		if button.setd then return end

		local Flash	 = _G[name.."Flash"]
		Flash:SetTexture(nil)
		Flash.SetTexture = M.null
		
		button:SetNormalTexture(nil)
		button.SetNormalTexture = M.null
		
		local hilight = button:GetHighlightTexture()
		hilight:SetTexture(M.media.blank)
		hilight:SetVertexColor(1,1,1,.2)
		hilight.SetTexture = M.null
		
		local pushed = button:GetPushedTexture()
		pushed:SetTexture(M.media.blank)
		pushed:SetVertexColor(0,0,0,.4)
		pushed.SetTexture = M.null
		
		local check = button:GetCheckedTexture()
		check:SetTexture(M.media.blank)
		check:SetVertexColor(1,1,1,.2)
		check.SetTexture = M.null
		
		button:SetWidth(28)
		button:SetHeight(32)
			
		local icon = _G[name.."Icon"]
		icon:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
		icon:ClearAllPoints()
		icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
		icon:SetAllPoints()
		icon.SetVertexColor = teh_new_vertex
			
		button.setd = true
			
		local autocast = _G[name.."AutoCastable"]
		autocast:Hide()
		autocast.Show = M.null
	end
	local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
	StylePet = function()
		for i=1, NUM_PET_ACTION_SLOTS do
			stylesmallbutton("PetActionButton"..i)
		end
	end
end

-- COOLDOWN POINTS
do
	local tostring = tostring
	local ipairs = ipairs
	local buttonNames = { 
		"ActionButton",  
		"MultiBarBottomLeftButton", 
		"MultiBarBottomRightButton", 
		"MultiBarLeftButton",
		"MultiBarRightButton", 
		"ShapeshiftButton", 
		"PetActionButton"}
	for _, name in ipairs( buttonNames ) do
		for index = 1, 12 do
			local buttonName = name .. tostring(index)
			local button = _G[buttonName]
			local cooldown = _G[buttonName .. "Cooldown"]
	 
			if ( button == nil or cooldown == nil ) then
				break
			end
			
			cooldown:ClearAllPoints()
			cooldown:SetPoint("TOPLEFT", button)
			cooldown:SetPoint("BOTTOMRIGHT", button)
		end
	end
end

-- FLYOUT
local styleflyout
do
	local SpellFlyout = SpellFlyout
	local buttons = 0
	local function SetupFlyoutButton()
		for i=1, buttons do
			local p = _G["SpellFlyoutButton"..i]
			if p then style(p,true) end
		end
	end
	SpellFlyout:HookScript("OnShow", SetupFlyoutButton)
	local function FlyoutButtonPos(self, buttons, direction)
		for i=1, buttons do
			local parent = SpellFlyout:GetParent()
			if not _G["SpellFlyoutButton"..i] then return end
			
			if InCombatLockdown() then return end
			local x = _G["SpellFlyoutButton"..i]
		
			if direction == "LEFT" then
				if i == 1 then
					x:ClearAllPoints()
					x:SetPoint("RIGHT", parent, "LEFT", -6, 0)
				else
					x:ClearAllPoints()
					x:SetPoint("RIGHT", _G["SpellFlyoutButton"..i-1], "LEFT", -6, 0)
				end
				x:SetSize(28,32)
				_G["SpellFlyoutButton"..i.."Icon"]:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
			else
				if i == 1 then
					x:ClearAllPoints()
					x:SetPoint("BOTTOM", parent, "TOP", 0, 6)
				else
					x:ClearAllPoints()
					x:SetPoint("BOTTOM", _G["SpellFlyoutButton"..i-1], "TOP", 0, 6)
				end
				x:SetSize(32,28)
				_G["SpellFlyoutButton"..i.."Icon"]:SetTexCoord(3/32,1-3/32,5/32,1-5/32)
			end
		end
	end
	local GetFlyoutID = GetFlyoutID
	local SetClampedTextureRotation = SetClampedTextureRotation
	local GetMouseFocus = GetMouseFocus
	M.addenter(function()
		SpellFlyoutHorizontalBackground:Hide()
		SpellFlyoutVerticalBackground:Hide()
		SpellFlyoutBackgroundEnd:Hide()
		SpellFlyoutHorizontalBackground.Show = M.null
		SpellFlyoutVerticalBackground.Show = M.null
		SpellFlyoutBackgroundEnd.Show = M.null
	end)
	styleflyout = function(self)
		for i=1, GetNumFlyouts() do
			local x = GetFlyoutID(i)
			local _, _, numSlots, isKnown = GetFlyoutInfo(x)
			if isKnown then
				buttons = numSlots
				break
			end
		end
		local arrowDistance
		if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
			arrowDistance = 5
		else
			arrowDistance = 2
		end
		if (self.flyR) then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
			FlyoutButtonPos(self,buttons,"LEFT")
		elseif (self.flyT) then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
			FlyoutButtonPos(self,buttons,"UP")	
		elseif not self:GetParent():GetParent() == "SpellBookSpellIconsFrame" then
			FlyoutButtonPos(self,buttons,"UP")
		end
	end
end

-- PETBAR UPDATE
local PetBarUpdate
do
	local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
	local IsPetAttackAction = IsPetAttackAction
	local PetActionButton_StopFlash = PetActionButton_StopFlash
	local PetActionButton_StartFlash = PetActionButton_StartFlash
	local AutoCastShine_AutoCastStart = AutoCastShine_AutoCastStart
	local GetPetActionSlotUsable = GetPetActionSlotUsable
	local SetDesaturation = SetDesaturation
	local GetPetActionInfo = GetPetActionInfo
	local PetHasActionBar = PetHasActionBar
	PetBarUpdate = function()
		local petActionButton
		local petActionIcon
		local petAutoCastableTexture
		local petAutoCastShine
		for i=1, NUM_PET_ACTION_SLOTS do
			local buttonName = "PetActionButton" .. i
			local petActionButton = _G[buttonName]
			local petActionIcon = _G[buttonName.."Icon"]
			local petAutoCastShine = _G[buttonName.."Shine"]
			local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

			if not isToken then
				petActionIcon:SetTexture(texture)
				petActionButton.tooltipName = name
			else
				petActionIcon:SetTexture(_G[texture])
				petActionButton.tooltipName = _G[name]
			end
		
			petAutoCastShine:SetScale(1.2)
			petActionButton.isToken = isToken
			petActionButton.tooltipSubtext = subtext

			if isActive and name ~= "PET_ACTION_FOLLOW" then
				petActionButton:SetChecked(1)
				if IsPetAttackAction(i) then
					PetActionButton_StartFlash(petActionButton)
				end
			else
				petActionButton:SetChecked(0)
				if IsPetAttackAction(i) then
					PetActionButton_StopFlash(petActionButton)
				end
			end

			if autoCastEnabled then
				AutoCastShine_AutoCastStart(petAutoCastShine)
			else
				AutoCastShine_AutoCastStop(petAutoCastShine)
			end

			if texture then
				if GetPetActionSlotUsable(i) then
					SetDesaturation(petActionIcon, nil)
				else
					SetDesaturation(petActionIcon, 1)
				end
				petActionIcon:Show()
			else
				petActionIcon:Hide()
			end

			if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
					PetActionButton_StopFlash(petActionButton)
					SetDesaturation(petActionIcon, 1)
					petActionButton:SetChecked(0)
			end
		end
	end
end

-- INIT PET STYLE AND UPDATE
do
	local bar = CreateFrame("Frame", "DerpyPetBar", UIParent, "SecureHandlerStateTemplate")
	bar:ClearAllPoints()
	bar:SetAllPoints(DerpyMainMenuBar)
	bar:RegisterEvent("PLAYER_LOGIN")
	bar:RegisterEvent("PLAYER_CONTROL_LOST")
	bar:RegisterEvent("PLAYER_CONTROL_GAINED")
	bar:RegisterEvent("PLAYER_ENTERING_WORLD")
	bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
	bar:RegisterEvent("PET_BAR_UPDATE")
	bar:RegisterEvent("PET_BAR_UPDATE_USABLE")
	bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
	bar:RegisterEvent("PET_BAR_HIDE")
	bar:RegisterEvent("UNIT_PET")
	bar:RegisterEvent("UNIT_FLAGS")
	bar:RegisterEvent("UNIT_AURA")
	
	local PetBarUpdate = PetBarUpdate
	local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
	local StylePet = StylePet
	
	bar:SetScript("OnEvent", function(self, event, arg1)
		if event == "PET_BAR_UPDATE" or 
			(event == "UNIT_PET" and arg1 == "player") or 
				event == "PLAYER_CONTROL_LOST" or 
					event == "PLAYER_CONTROL_GAINED" or 
						event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or 
							event == "UNIT_FLAGS" or 
								(arg1 == "pet" and event == "UNIT_AURA") 
									then
										PetBarUpdate()
		elseif event == "PET_BAR_UPDATE_COOLDOWN" then
			PetActionBar_UpdateCooldowns()		
		elseif event == "PLAYER_LOGIN" then	
			PetActionBarFrame.showgrid = 1	
			for i = 1, 10 do
				local button = _G["PetActionButton"..i]
				button:ClearAllPoints()
				button:SetParent(self)
				button:SetSize(28,32)
				if i ~= 1 then
					button:SetPoint("TOP", _G["PetActionButton"..(i - 1)], "BOTTOM", 0, -6)
				end
				button:Show()
				local bg = M.frame(button,0,"MEDIUM")
				bg:SetPoint("TOPLEFT",-4,4)
				bg:SetPoint("BOTTOMRIGHT",4,-4)
				self:SetAttribute("addchild", button)
			end
			RegisterStateDriver(self, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
			PetActionButton_OnDragStart = M.null
			self:UnregisterEvent("PLAYER_LOGIN")
		else
			StylePet()
		end
	end)
end

-- SECURE HOOKS
hooksecurefunc("ActionButton_Update",style)
hooksecurefunc("ActionButton_UpdateFlyout",styleflyout)

-- HIDE AND UNREGISTER SOME STUFF
do
	MainMenuBar:SetScale(0.00001)
	MainMenuBar:SetAlpha(0)
	MainMenuBar:EnableMouse(false)
	VehicleMenuBar:SetScale(0.00001)
	VehicleMenuBar:SetAlpha(0)
	VehicleMenuBar:EnableMouse(false)
	PetActionBarFrame:EnableMouse(false)
	ShapeshiftBarFrame:EnableMouse(false)
	
	local elements = {
		MainMenuBar, MainMenuBarArtFrame, BonusActionBarFrame, VehicleMenuBar, PossessBarFrame,
		PetActionBarFrame, ShapeshiftBarFrame, ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
	}
	for _, element in pairs(elements) do
		if element:GetObjectType() == "Frame" then
			element:UnregisterAllEvents()
		end
		element:Hide()
		element:SetAlpha(0)
	end

	local uiManagedFrames = {
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"ShapeshiftBarFrame",
		"PossessBarFrame",
		"PETACTIONBAR_YPOS",
		"MultiCastActionBarFrame",
		"MULTICASTACTIONBAR_YPOS",
		"ChatFrame1",
		"ChatFrame2",
	}
	for _, frame in pairs(uiManagedFrames) do
		UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
	end
	
	local have = {
		"MultiBarBottomLeft",
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomRight",}
	for i=1, #have do
		_G[have[i]].Hide = M.null
		_G[have[i]]:Show()
	end
end

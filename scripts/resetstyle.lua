local C,M,L,V = unpack(select(2,...))

C.coress_unit = {}
local side_table = {}
local count = 0
local _G = _G
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut

local bar = CreateFrame("Frame", "DerpyMainMenuBar", UIParent, "SecureHandlerStateTemplate")
bar:ClearAllPoints()
bar:SetSize(100,100)
bar:SetPoint("CENTER")

local resetbt = function(b)
	local bg = M.frame(b,0,"MEDIUM")
	bg:SetPoint("TOP",0,4)
	bg:SetPoint("BOTTOM",0,-4)
	bg:SetPoint("LEFT",-4,0)
	bg:SetPoint("RIGHT",4,0)
	count = count + 1
	side_table[count] = b
	b._derpy_mask = bg
end

do
	local t = {
		"MultiBarBottomLeft",
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomRight"}
	for i=1,#t do
		local b = CreateFrame("Frame", "Derpy"..t[i], UIParent)
		b:SetAllPoints(bar)
		_G[t[i]]:SetParent(b)
	end
	local havetodo = {
		"ActionButton",
		"MultiBarBottomLeftButton",
		"MultiBarBottomRightButton",
		"MultiBarLeftButton",
		"MultiBarRightButton"}
	for i=1, #havetodo do
		for p = 1, 12 do
			resetbt(_G[havetodo[i]..p])
		end
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



-- Point Layout here:
local reverse = V.reverse
local layout = 	V.layout
M.oufspawn = ({124,162,124,162,162,162,200,200})[layout]
local chat_point = ({380,380,570,570,285,475,266,380})[layout]
local bt_x_point = ({-361,-361,-551,-551,-266,-456,-247,-361})[layout]
local bt_y_point = reverse and ({10,44,10,44,44,44,78,78})[layout] or 10

local check = function(bt)
	C.ChatPoint = chat_point
	bt:SetPoint("BOTTOM",UIParent,bt_x_point,bt_y_point)
end


---- This part taked from tukui (thx to him), coz old one coldnt woking ((((

--[[ 
	Bonus bar classes id

	DRUID: Caster: 0, Cat: 1, Tree of Life: 0, Bear: 3, Moonkin: 4
	WARRIOR: Battle Stance: 1, Defensive Stance: 2, Berserker Stance: 3 
	ROGUE: Normal: 0, Stealthed: 1
	PRIEST: Normal: 0, Shadowform: 1
	
	When Possessing a Target: 5
]]--

local Page = {
    ["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] %s; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
    ["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
    ["PRIEST"] = "[bonusbar:1] 7;",
    ["ROGUE"] = "[bonusbar:1] 7; [form:3] 8;",
    ["WARLOCK"] = "[form:2] 7;",
    ["DEFAULT"] = "[bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6; [bonusbar:5] 11;",
}

local function GetBar()
    local condition = Page["DEFAULT"]
    local page = Page[M.class]
    if page then
      if M.class == "DRUID" then
        -- Handles prowling, prowling has no real stance, so this is a hack which utilizes the Tree of Life bar for non-resto druids.
		-- Taked from Mono UI
        if IsSpellKnown(33891) then -- Tree of Life form
          page = page:format(7)
        else
          page = page:format(8)
        end
      end
      condition = condition.." "..page
    end
    condition = condition.." 1"
    return condition
end

local reset_colors = function()
	for i=1,12 do
		_G["ActionButton"..i]._derpy_mask:backcolor(0,0,0)
	end
	for i=13, #side_table do
		side_table[i]._derpy_mask:backcolor(0,0,0)
	end
end

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
bar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
bar:RegisterEvent("BAG_UPDATE")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
bar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
		end	

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		]])
		
		self:SetAttribute("_onstate-page", [[ 
			for i, button in ipairs(buttons) do
				button:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
			
		RegisterStateDriver(self, "page", GetBar())
		if event == "ACTIVE_TALENT_GROUP_CHANGED" then
			LoadAddOn("Blizzard_GlyphUI")
			reset_colors()			
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		local button
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:SetSize(32,28)
			button:ClearAllPoints()
			if i == 1 then
				check(button)
			else
				button:SetPoint("LEFT",_G["ActionButton"..i-1],"RIGHT",6,0)
			end
			button.flyT = true
			button:SetParent(DerpyMainMenuBar)
		end
	elseif event == "UPDATE_SHAPESHIFT_FORM" then
		reset_colors()
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

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
end

-- Style
local securehandler = bar

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

function style(self,mode)
	local name = self:GetName()
	
	local Button = self
	
	local Border  = _G[name.."Border"]
	local Flash	 = _G[name.."Flash"]
	
	self:GetHighlightTexture():SetTexture(1,1,1,.2)
	self:GetPushedTexture():SetTexture(0,0,0,.4)
	self:GetCheckedTexture():SetTexture(1,1,1,.2)
	
	Flash:SetTexture("")
	Button:SetNormalTexture("")
 
	--> fixing a taint issue while changing totem flyout button in combat.
	local f
	if name:match("MultiCast") then 
		f = true
		local icon = select(1,self:GetRegions())
		icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
		icon.SetVertexColor = teh_new_vertex
	else 
		Border:Hide()
		Border = M.null
	end
	
	if not self.setd then
		local Btname = _G[name.."Name"]
		local Icon = _G[name.."Icon"]
		local Count = _G[name.."Count"]
		local HotKey = _G[name.."HotKey"]
		
		HotKey:ClearAllPoints()
		HotKey:SetPoint("TOPRIGHT", 1, -1)
		HotKey:SetFont(M["media"].font, 13, "OUTLINE")
		HotKey:SetShadowOffset(1, -1)
		self.setd = true
		
		if f then return end
		if not mode then
			if self.flyR then
				Icon:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
			else
				Icon:SetTexCoord(3/32,1-3/32,5/32,1-5/32)
			end
		end
		
		Icon:SetPoint("TOPLEFT", Button)
		Icon:SetPoint("BOTTOMRIGHT", Button)
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

		Btname:ClearAllPoints()
		Btname:SetPoint("LEFT",.5,-1)
		Btname:SetPoint("RIGHT",-.5,-1)
		Btname:SetJustifyH("CENTER")

		if V.showmacro ~= true then
			Btname:SetText("")
			Btname:Hide()
			Btname.Show = M.null
		elseif V.hovermacro == true then
			Btname:SetDrawLayer("HIGHLIGHT")
		end
		
		Count:ClearAllPoints()
		Count:SetPoint("BOTTOMRIGHT", 1, 1)
		Count:SetShadowOffset(1, -1)
		Count:SetFont(M["media"].font, 13, "OUTLINE")
	end

end

local function stylesmallbutton( button, icon, name, pet, hilight, pushed, check)
	local Flash	 = _G[name.."Flash"]
	button:SetNormalTexture("")
	hilight:SetTexture(1,1,1,.2)
	pushed:SetTexture(0,0,0,.4)
	check:SetTexture(1,1,1,.2)
	button.SetNormalTexture = M.null
	Flash:SetTexture("")
	
	if not button.setd then
		button:SetWidth(28)
		button:SetHeight(32)
		
		icon:SetTexCoord(5/32,1-5/32,3/32,1-3/32)
		icon:ClearAllPoints()
		icon:SetGradient("VERTICAL",.5,.5,.5,1,1,1)
		icon:SetAllPoints()
		icon.SetVertexColor = teh_new_vertex
		
		button.setd = true
		
		if pet then
			local autocast = _G[name.."AutoCastable"]
			autocast:SetWidth(30)
			autocast:SetHeight(40)
			autocast:ClearAllPoints()
			autocast:SetPoint("CENTER",button)
		end
	end
end

local function StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local hilight = _G[name]:GetHighlightTexture()
		local pushed = _G[name]:GetPushedTexture()
		local check = _G[name]:GetCheckedTexture()
		stylesmallbutton(button, icon, name, true, hilight, pushed, check)
	end
end

-- rescale cooldown spiral to fix texture.
local buttonNames = { "ActionButton",  "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ShapeshiftButton", "PetActionButton"}
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

local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		--prevent error if you don't have max ammount of buttons
		if _G["SpellFlyoutButton"..i] then
			local p = _G["SpellFlyoutButton"..i]
			style(p,true)
			if not p.bbg then
				local bg = M.frame(p,5,"MEDIUM")
				bg:SetPoint("TOPLEFT",-4,4)
				bg:SetPoint("BOTTOMRIGHT",4,-4)
				p.bbg = bg
			end
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

-- Reposition flyout buttons depending on what tukui bar the button is parented to
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
--Hide the Mouseover texture and attempt to find the ammount of buttons to be skinned
local function styleflyout(self)
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
	
	--Change arrow direction depending on what bar the button is on
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

hooksecurefunc("ActionButton_Update",style)
hooksecurefunc("ActionButton_UpdateFlyout",styleflyout)

local IsPetAttackAction = IsPetAttackAction
local PetActionButton_StopFlash = PetActionButton_StopFlash
local PetActionButton_StartFlash = PetActionButton_StartFlash
local AutoCastShine_AutoCastStart = AutoCastShine_AutoCastStart
local GetPetActionSlotUsable = GetPetActionSlotUsable
local SetDesaturation = SetDesaturation
local GetPetActionInfo = GetPetActionInfo
local PetHasActionBar = PetHasActionBar
local function PetBarUpdate()

	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
		for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton" .. i
			petActionButton = _G[buttonName]
			petActionIcon = _G[buttonName.."Icon"]
			petAutoCastableTexture = _G[buttonName.."AutoCastable"]
			petAutoCastShine = _G[buttonName.."Shine"]
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end
	
		petAutoCastableTexture:Hide()
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

		-- between level 1 and 10 on cata, we don't have any control on Pet. (I lol'ed so hard)
		-- Setting desaturation on button to true until you learn the control on class trainer.
		-- you can at least control "follow" button.
		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
				PetActionButton_StopFlash(petActionButton)
				SetDesaturation(petActionIcon, 1)
				petActionButton:SetChecked(0)
		end
	end
end

local rp = M.frame(UIParent,1)
	rp:SetHeight(394)
	rp:SetPoint("RIGHT",5,0)
	rp:SetWidth(18)
	rp.bg:SetGradientAlpha("HORIZONTAL",.26,.26,.26,.14,.2,.2,.2,.47)
	rp.point_1 = "RIGHT"
	rp.point_2 = "RIGHT"
	rp.pos = 5
	rp.hor = true
	rp.parent = UIParent
	
local on_update = M.simple_move
	
rp.start_go_up = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = -1
	self.limit = 5
	self.speed = -30
	self:SetScript("OnUpdate",on_update)
end
	
rp.start_go_down = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = 1
	self.limit = 18
	self.speed = 30
	self:SetScript("OnUpdate",on_update)
end

C.check_right_bar = function()
	if V["savedright"] == 0 and V["pet_unit"] == 4 then
		if rp.moving_right == true then return end
		rp.moving_right = true
		rp:start_go_down()
	else
		if rp.moving_right ~= true then return end
		rp.moving_right = false
		rp:start_go_up()
	end
end

local stoped
do
	local secondroll = ({nil,21,nil,31,16,26,15,21})[layout]
	local from = ({20,40,30,60,30,50,42,60})[layout]
	for i=13, from do
		side_table[i]:SetSize(32,28)
		side_table[i]:ClearAllPoints()
		side_table[i]:SetPoint("LEFT",side_table[i-1],"RIGHT",6,0)
		side_table[i].flyT = true
	end
	if secondroll then
		side_table[secondroll]:ClearAllPoints()
		if reverse then
			side_table[secondroll]:SetPoint("TOP",side_table[1],"BOTTOM",0,-6)
		else
			side_table[secondroll]:SetPoint("BOTTOM",side_table[1],"TOP",0,6)
		end
	end
	stoped = from
	if layout == 7 or layout == 8 then
		local x = layout == 7 and 29 or 41
		local y = layout == 7 and 15 or 21
		side_table[x]:ClearAllPoints()
		if reverse then
			side_table[x]:SetPoint("TOP",side_table[y],"BOTTOM",0,-6)
		else
			side_table[x]:SetPoint("BOTTOM",side_table[y],"TOP",0,6)
		end
	end
end

if stoped~= 60 then
	local rightg,k,z = {},1,1

	rightg[1] = {}
	for i=stoped+1,60 do
		side_table[i]:SetSize(28,32)
		side_table[i].flyR = true
		side_table[i]:ClearAllPoints()
		side_table[i]:Hide()
		M.make_plav(side_table[i],.12345,true)
		if i~= stoped+1 and z~= 1 then
			side_table[i]:SetPoint("TOP",side_table[i-1],"BOTTOM",0,-6)
		elseif z == 1 then
			side_table[i]:SetPoint("RIGHT",UIParent,-6,171)
		end
		rightg[k][z] = side_table[i]
		z = z+1
		if z == 11 then
			k = k + 1
			z = 1
			rightg[k] = {}
		end
	end
	--add 2 fake
	if layout == 7 then
		k = k + 1
		for i=9,10 do
			rightg[2][i] = M.frame(UIParent)
			rightg[2][i]:SetSize(40,40)
			rightg[2][i]:SetPoint("TOP",rightg[2][i-1],"BOTTOM",0,i == 9 and -2 or 2)
			M.make_plav(rightg[2][i],.12345)
			local t = rightg[2][i]:CreateTexture(nil,"HIGHLIGHT")
			t:SetPoint("TOPLEFT",4,-4)
			t:SetPoint("BOTTOMRIGHT",-4,4)
			t:SetTexture(1,1,1,.2)
		end
	end
	
	local on_show_rep = function(self) if not InCombatLockdown() then self:Hide() end end
	
	local hideroll = function(coord)
		for i=1,10 do
			if rightg[coord][i]:IsShown() then
				rightg[coord][i].isshown = true
			else
				rightg[coord][i].isshown = false
			end
			rightg[coord][i]:Hide()
			rightg[coord][i]:SetAlpha(0)
			rightg[coord][i]:EnableMouse(false)
			rightg[coord][i]:SetScript("OnShow",on_show_rep)
		end
	end
	
	local showroll = function(coord)
		for i=1,10 do
			rightg[coord][i]:SetScript("OnShow",M.null)
			if rightg[coord][i].isshown then
				rightg[coord][i]:show()
			end
			rightg[coord][i]:SetAlpha(1)
			rightg[coord][i]:EnableMouse(true)
		end
	end
	
	local onp = false
	local bright = M.frame(UIParent,2)
	bright:SetAlpha(0)
	bright:SetPoint("RIGHT",2,-201)
	bright:SetSize(44,24)
	bright:EnableMouse(true)
	bright:SetScript("OnEnter", function(self) 
		 if not onp then
			UIFrameFadeIn(self,.2,0,1) end
		 end)
	bright:SetScript("OnLeave", function(self)
			onp = false
			UIFrameFadeOut(self,.2,1,0)
		end)	
	
	local bcount = bright:CreateFontString(nil, "OVERLAY")
		bcount:SetPoint("TOP",bright,"BOTTOM",1,1)
		bcount:SetFont(M["media"].font_s,22)
		bcount:SetShadowOffset(1,-1)
	
	local deadline = k - 1
	
	M.addafter(function()
		for i=1,deadline do
			hideroll(i)
		end
		if deadline < V.savedright then
			showroll(1)
			V.savedright = 1
			bcount:SetText(1)
		elseif V.savedright ~= 0 then
			showroll(V.savedright)
			bcount:SetText(V.savedright)
		else
			bcount:SetText("X")
		end
		C.checkthepet()
		C.update_grid()
	end)
	
	local switch = function(change)
		local abc = V.savedright
		if abc ~= 0 then
			hideroll(abc)
		end
		abc = abc + change
		if abc > deadline then
			abc = 0
		elseif abc < 0 then
			abc = deadline
		end
		if abc == 0 then
			bcount:SetText("X")
		else
			bcount:SetText(abc)
			showroll(abc)
		end
		V.savedright = abc
		C.checkthepet()
		C.update_grid()
		C.check_right_bar()
	end
	
	local setrr = function(tetx,unk,x,y,x1,y1,change)
		local rr = CreateFrame ("Button",nil,bright)
			rr:SetPoint(unk,bright,x,y)
			rr:SetWidth(18)
			rr:SetHeight(16)
			rr:RegisterForClicks("anydown")
			
		local rrtex = rr:CreateFontString(nil, "OVERLAY")
			rrtex:SetPoint(unk,bright,x1,y1)
			rrtex:SetFont(M["media"].font_s,29)
			rrtex:SetText(tetx)
				
		rr:SetScript("OnEnter", function()
			rrtex:SetTextColor(1,0.5,0.5)
			UIFrameFadeIn(bright,0,1,1)
			UIFrameFadeOut(bright,0,1,1)
			onp = true
		end)

		rr:SetScript("OnLeave", function()
			rrtex:SetTextColor(1,1,1)
			UIFrameFadeOut(bright,.2,1,0)
		end)
		
		rr:SetScript("OnClick", function()
			if InCombatLockdown() then return end
				switch(change)
		end)
	end
	setrr(">","TOPRIGHT",-4,-4,-8,2.9,1)
	setrr("<","TOPLEFT",4,-4,8,2.9,-1)
else
	M.addafter(function()
		C.checkthepet()
		C.update_grid()
	end)
	V.savedright = 0
end

-- PetStyle and place
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

bar:SetScript("OnEvent", function(self, event, ...)
	local arg1 = ...
	if event == "PLAYER_LOGIN" then	
		-- bug reported by Affli on t12 BETA
		PetActionBarFrame.showgrid = 1 -- hack to never hide pet button. :X
		local button		
		for i = 1, 10 do
			button = _G["PetActionButton"..i]
			button:ClearAllPoints()
			button:SetParent(bar)
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
	elseif event == "PET_BAR_UPDATE" or (event == "UNIT_PET" and arg1 == "player") or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or event == "UNIT_FLAGS" or (arg1 == "pet" and event == "UNIT_AURA") then
		PetBarUpdate()
	elseif event == "PET_BAR_UPDATE_COOLDOWN" then
		PetActionBar_UpdateCooldowns()
	else
		StylePet()
	end
end)

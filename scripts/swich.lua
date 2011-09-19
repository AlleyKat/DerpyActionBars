local C,M,L,V = unpack(select(2,...))

C.coress_unit[1] = PetActionButton1
local menuFrame = CreateFrame("Frame", "LeftChatFrameMenu", UIParent, "UIDropDownMenuTemplate")
local _G = _G
local pet_n = "PetActionButton"
local InCombatLockdown = InCombatLockdown
local simple_move = M.simple_move
local Mover = CreateFrame("Frame",nil,UIParent)
Mover:SetSize(10,10)

local petshownr = {"TOPRIGHT",Mover,"TOPRIGHT",0,0}
local petaway = {"TOPRIGHT",UIParent,"TOPRIGHT",200,187}

Mover.hor = true
Mover.alt = 187
Mover.point_2 = "RIGHT"
Mover.point_1 = "TOPRIGHT"
Mover.parent = UIParent
Mover.pos = -6
Mover:SetPoint("TOPRIGHT",UIParent,"RIGHT",-6,187)

Mover._SetPoint = Mover.SetPoint
Mover.SetPoint = function(self,...)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:SetScript("OnUpdate",nil)
		return
	end
	self:_SetPoint(...)
end

Mover:SetScript("OnEvent",function(self)
	self:UnregisterAllEvents()
	self:SetScript("OnUpdate",simple_move)
end)

Mover.left = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = 1
	self.limit = -6
	self.speed = 100
	self:SetScript("OnUpdate",simple_move)
end

Mover.right = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = -1
	self.limit = -40
	self.speed = -100
	self:SetScript("OnUpdate",simple_move)
end

local show = function(self)
	if self._skip_ then self._skip_ = nil return end 
	self:hide()
	self:show_()
	for i=2,10 do
		_G[pet_n..i]:hide()
		_G[pet_n..i]:show()
	end
end

for i = 1,10 do M.make_plav(_G[pet_n..i],.13,true,1) end

C.coress_unit[1].show_ = C.coress_unit[1].show
C.coress_unit[1].show = show

local pettriger = CreateFrame("Button",nil,UIParent)
	pettriger:SetAlpha(0)
	pettriger:SetPoint("RIGHT",-2,201)
	pettriger:SetSize(36,16)
	pettriger:RegisterForClicks("anydown")
	
local petbg = M.frame(pettriger,2)
	petbg:SetPoint("TOPLEFT",-4,4)
	petbg:SetPoint("BOTTOMRIGHT",4,-4)

local names = {"pet","mb","mm","na"}
	
local petn = pettriger:CreateFontString(nil,"OVERLAY")
	petn:SetPoint("CENTER",1.3,1)
	petn:SetFont(M["media"].font_s,18)
	petn:SetText(names[V.pet_unit])

C.checkthepet = function()
	if InCombatLockdown() then return end
	C.check_right_bar()
	for i=1,3 do
		if i == 1 then
			C.coress_unit[i]:SetPoint(unpack(petaway))
			if V.pet_unit == 1 then
				C.coress_unit[i]._skip_ = true	
			end
		else
			if V.pet_unit ~= i then
				C.coress_unit[i]:Hide()
			end
		end
	end
	if V.showpet == true then
		petn:SetText(names[V.pet_unit])
		M.backcolor(petbg,1,.5,.5,.5)
		petn:SetTextColor(1,.5,.5)
		C.coress_unit[V.pet_unit]:SetPoint(unpack(petshownr))
		if V.savedright == 0 then
			Mover:left()
		else
			Mover:right()
		end
		C.coress_unit[V.pet_unit]:show()
	else
		M.backcolor(petbg,0,0,0)
		petn:SetText(names[4])
		petn:SetTextColor(1,1,1)
	end
end

local orly = function(ar1,ar2)
	if InCombatLockdown() then return end
	V.pet_unit = ar1
	V.showpet = ar2
	C.checkthepet()
end

local tmen = {'PetBar','MarkBar','MicroMenu','Nothing'}
local _title = {text = "DISPLAY", isTitle = 1, notCheckable = 1}

local menu = function()
	local a = {}
	a[1] = _title
	for i=1,4 do
		if V.pet_unit~=i then
			tinsert(a,{text = tmen[i],func = function() orly(i,(i~=4 and true) or false) end, notCheckable = 1})
		end
	end
	return a
end

pettriger:SetScript("OnEnter",function(self) UIFrameFadeIn(self,.2,0,1) end)
pettriger:SetScript("OnLeave",function(self) UIFrameFadeOut(self,.2,1,0) end)
pettriger:SetScript("OnClick",function(self) EasyMenu(menu(), menuFrame, "cursor", 0, 0, "MENU", 2) end)

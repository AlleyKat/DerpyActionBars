local C,M,L,V = unpack(select(2,...))

C.coress_unit = {}
C.side_table = {}
local side_table = C.side_table
local count = 0
local _G = _G
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local reverse = V.reverse
local layout = 	V.layout
M.oufspawn = ({124,162,124,162,162,162,200,200})[layout]

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

local C,M,L,V = unpack(select(2,...))

local frame = M.make_settings_template("ACTION BARS",316,374)

if M.class ~= "SHAMAN" then
	V.showtotems = false
end

-- Move to locals next
		-- okay :(
local st = {
	["hovernames"] = "HOVER HOTKEYS",
	["shownames"] = "SHOW HOTKEYS",
	["hovermacro"] = "HOVER MACRO",
	["showmacro"] = "SHOW MACRO",
	["reverse"] = "REVERSE LAYOUT",
	["showtotems"] = "SHOW TOTEMS",
	["showgcd"] = "SHOW GLOBAL COOLDOWN",
	["range"] = "SHOW RANGE COLORS",
	["cooldown"] = "SHOW COOLDOWN COUNT",
	["fitchat"] = "FIT CHAT FRAMES",}

local layouttable = {"1 X 20","2 X 20","1 X 30","2 X 30","2 X 15","2 X 25","3 X 14","3 X 20"}	
local helplayw = {758,758,1138,1138,568,948,530,758}	
local helplayh = {32,66,32,66,66,66,100,100}	
		
local helptexture = frame:CreateTexture(nil,"OVERLAY")
	helptexture:SetTexture(1,1,1,1)
	helptexture:SetPoint("BOTTOM",UIParent,0,8)
	helptexture:SetSize(helplayw[V.layout],helplayh[V.layout])
	helptexture:SetGradientAlpha("VERTICAL",.2,.5,1,.8,.12,.3,.6,.7)		
		
local laystate = M.setfont(frame,21)
	laystate:SetPoint("TOPRIGHT",-34,-14)
	laystate:SetText(layouttable[V.layout])
		
local nname = M.setfont(frame,21)
	nname:SetPoint("TOPLEFT",14,-14)
	nname:SetText("ACTION BARS LAYOUT:")

local cdstate = M.setfont(frame,21)
	cdstate:SetPoint("TOPLEFT",nname,"BOTTOMLEFT",0,-8)
	cdstate:SetText("COOLDOWN COUNT POINT:")	
	
local cdcur = M.setfont(frame,21)
	cdcur:SetPoint("TOPRIGHT",-14,-43)
	cdcur:SetText("CENTER")	
	
local swt = function(change)
	local abc = V.layout + change
	if abc == 0 then abc = 8
	elseif abc == 9 then abc = 1
	end
	helptexture:SetSize(helplayw[abc],helplayh[abc])
	laystate:SetText(layouttable[abc])
	V.layout = abc
end	

local ts = {
	["l1"] = 0,
	["l2"] = 0,
	["l3"] = 14,
}
	
local a = M.makevarbar(frame, 304, -100, 100, ts, "l1", "COOLDOWN X POINT OFFSET", .1)	
local b = M.makevarbar(frame, 304, -100, 100, ts, "l2", "COOLDOWN Y POINT OFFSET", .1)	
local c = M.makevarbar(frame, 304, 8, 24, ts, "l3", "COOLDOWN FONT SIZE")

a:SetPoint("TOP",frame,0,-78)
b:SetPoint("TOP",a,"BOTTOM",0,-4)
c:SetPoint("TOP",b,"BOTTOM",0,-4)

local _d = function(self) self.text:SetTextColor(0,1,1) end
local _p = function(self) self.text:SetTextColor(1,1,1) end
local crbutton = function(parent,t,change,x,y,point1,point2)
	local f = CreateFrame("Frame",nil,parent)
	f:SetSize(30,30)
	f:SetFrameLevel(11)
	f:EnableMouse(true)
	local text = f:CreateFontString(nil,"OVERLAY")
	text:SetAllPoints()
	text:SetFont(M["media"].font_s,32)
	text:SetText(t)
	f.text = text
	f:SetPoint(point1,laystate,point2,x,y)
	f:SetScript("OnEnter",_d)
	f:SetScript("OnLeave",_p)
	f:SetScript("OnMouseDown",function() swt(change) end)
end
			
local bleft = crbutton(frame,"<",-1,2,-.7,"RIGHT","LEFT")
local bright = crbutton(frame,">",1,-2,-.7,"LEFT","RIGHT")	

M.tweaks_mvn(frame,V,st,212)

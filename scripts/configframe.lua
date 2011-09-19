local C,M,L,V = unpack(select(2,...))

local frame
M['call'].ActionBars = function()
	if frame then frame:Show() return end
		local st = {
			["hovernames"] = "Hover HotKeys",
			["shownames"] = "Show HotKeys",
			["hovermacro"] = "Hover Macro",
			["showmacro"] = "Show Macro",
			["reverse"] = "Reverse Layout",
			["showtotems"] = "Show Totems",
			["showgcd"] = "Show GlobalCD",
			["range"] = "Show Range Colors",
			["cooldown"] = "Show Cooldown Count",
			["fitchat"] = "Fit Chat Frames",}

		frame = M.make_settings(st,V,31,230,"DERPY ACTIONBARS",true)
		local layouttable = {"1 X 20","2 X 20","1 X 30","2 X 30","2 X 15","2 x 25","3x14","3x20"}	
		local helplayw = {758,758,1138,1138,568,948,530,758}
		local helplayh = {32,66,32,66,66,66,100,100}

		local helptexture = frame:CreateTexture(nil,"OVERLAY")
		helptexture:SetTexture(1,1,1,1)
		helptexture:SetPoint("BOTTOM",UIParent,0,8)
		helptexture:SetSize(helplayw[V.layout],helplayh[V.layout])
		helptexture:SetGradientAlpha("VERTICAL",.2,.5,1,.8,.12,.3,.6,.7)

		local laystate = frame:CreateFontString(nil,"OVERLAY")
		laystate:SetFont(M["media"].font_s,31)
		laystate:SetPoint("TOP",0,-25)
		laystate:SetText(layouttable[V.layout])
		laystate:SetJustifyH("LEFT")
		laystate:SetShadowOffset(1,-1)

		local swt = function(change)
			local abc = V.layout + change
			if abc == 0 then abc = 8
			elseif abc == 9 then abc = 1
			end
			helptexture:SetSize(helplayw[abc],helplayh[abc])
			laystate:SetText(layouttable[abc])
			V.layout = abc
		end

		local crbutton = function(parent,t,change,x,y)
			local f = CreateFrame("Frame",nil,parent)
			f:SetSize(30,30)
			f:EnableMouse(true)
			local text = f:CreateFontString(nil,"OVERLAY")
			text:SetAllPoints()
			text:SetFont(M["media"].font_s,30)
			text:SetText(t)
			f:SetPoint("TOP",x,y)
			f:SetScript("OnEnter",function() text:SetTextColor(1,.3,.3) end)
			f:SetScript("OnLeave",function() text:SetTextColor(1,1,1) end)
			f:SetScript("OnMouseDown",function() swt(change) end)
		end
			
		local bleft = crbutton(frame,"<",-1,-71,-26)
		local bright = crbutton(frame,">",1,71,-26)
		frame:Show()	
end

if M.class ~= "SHAMAN" then
	V.showtotems = false
end
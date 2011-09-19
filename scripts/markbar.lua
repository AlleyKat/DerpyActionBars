local C,M,L,V = unpack(select(2,...))

local markbar = CreateFrame("Frame",nil,UIParent)
markbar:SetPoint("TOPRIGHT",UIParent,"RIGHT",200,187)
markbar:SetSize(10,10)
C.coress_unit[2] = markbar
markbar:Hide()
M.make_plav(markbar,.13)
local main = M.frame(markbar,2,"MEDIUM")
main:SetPoint("TOPRIGHT",4,4)
main:SetSize(36,40)

local the_m = main:CreateFontString(nil,"ARTWORK")
	the_m:SetPoint("CENTER",0,1)
	the_m:SetFont(M['media'].font_s,24)
	the_m:SetTextColor(0,1,1)
	the_m:SetText("M")

local function RaidMarkButton_OnClick(self, arg1, arg2)
	if arg2 == false then
		self.press_:SetAlpha(0)
		PlaySound("UChatScrollButton")
		SetRaidTarget("target", (arg1~="RightButton") and self:GetID()or 0)
	else
		self.press_:SetAlpha(1)
	end
end

C.pl_tex = function(self,r,g,b,f,k)
	local a = self:CreateTexture(nil,k or "OVERLAY")
	a:SetAlpha(k and 1 or 0)
	a:SetTexture(r,g,b,f)
	a:SetPoint("TOPLEFT",4,-4)
	a:SetPoint("BOTTOMRIGHT",-4,4)
	return a
end

local buttons = {}
for i = 1, 9 do
	Button = CreateFrame("Button", "DerpyMarkIconButton"..i, main)
	Button:SetSize(36,40)
	C.pl_tex(Button,1,1,1,.2,"HIGHLIGHT")
	Button.press_ = C.pl_tex(Button,0,0,0,.4)
	M.ChangeTemplate(Button)
	if i~= 9 then
		Button:SetID(i)
		local Texture = Button:CreateTexture(Button:GetName().."NormalTexture", "ARTWORK");
		Texture:SetTexture(M['media'].ricon)
		Texture:SetPoint("TOPLEFT",7,-7)
		Texture:SetPoint("BOTTOMRIGHT",-7,7)
		SetRaidTargetIconTexture(Texture, i)
	else
		Button:SetID(0)
		local the_x = Button:CreateFontString(nil,"ARTWORK")
		the_x:SetPoint("CENTER",0,1)
		the_x:SetFont(M['media'].font_s,29)
		the_x:SetTextColor(1,0,0)
		the_x:SetText("X")
	end
		Button:RegisterForClicks("AnyUp","AnyDown")
		Button:SetScript("OnClick",RaidMarkButton_OnClick)
		Button:SetScript("OnLeave",function(self) self.press_:SetAlpha(0) end)
	if i == 1 then
		Button:SetPoint("TOP",main,"BOTTOM",0,2)
	else
		Button:SetPoint("TOP",buttons[i-1],"BOTTOM",0,2)
	end
	buttons[i] = Button
end

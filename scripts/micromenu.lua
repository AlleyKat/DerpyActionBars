local C,M,L,V = unpack(select(2,...))
local _G = _G
local micromenu = CreateFrame("Frame",HissyMicroMenu,UIParent,"SecureHandlerStateTemplate")
local micro_hold = CreateFrame("Frame",HissyMicroMenuV2,micromenu,"SecureHandlerStateTemplate")
C.coress_unit[3] = micromenu
micromenu:SetPoint("TOPRIGHT",UIParent,"RIGHT",-44,187)
local path = M.media.path
local textures = {
	false, -- char
	path..[=[spellbook]=],
	path..[=[talents]=],
	path..[=[achievement]=],
	path..[=[quest]=],
	false, -- tabart
	false, -- pvp
	path..[=[lfg]=],
	path..[=[raid]=], -- need find
	path..[=[book]=], -- need find
}

local buttons = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"AchievementMicroButton",
	"QuestLogMicroButton",
	"GuildMicroButton",
	"PVPMicroButton",
	"LFDMicroButton",
	"RaidMicroButton",
	"EJMicroButton",
}

micromenu:SetSize(10,10)
micro_hold:SetAllPoints()
micromenu:SetFrameStrata("MEDIUM")

local temp = {}
local masks = {}

for i=1,#buttons do
	local a = _G[buttons[i]]
	a:SetParent(micro_hold)
	a:ClearAllPoints()
	if i == 1 then
		a:SetPoint("TOPRIGHT",0,24)
	else
		a:SetPoint("TOP",temp[i-1],"BOTTOM",0,20)
	end
	temp[i] = a
	local mask = M.frame(micromenu,20,"MEDIUM")
	mask:SetPoint("CENTER",a,0,-11)
	mask:SetSize(36,40)
	mask.hil = C.pl_tex(mask,1,1,1,.2)
	mask.hil:SetDrawLayer("ARTWORK")
	a.hil = mask.hil
	masks[i] = mask
	if textures[i] then 
		local tex = mask:CreateTexture(nil,"OVERLAY")
		tex:SetTexture(textures[i])
		if i == 2 or i == 10 then
			tex:SetSize(29,29)
			if i == 2 then
				tex:SetPoint("CENTER",0,-1)
			else
				tex:SetPoint("CENTER",-1.5,-0.5)
			end
		else
			tex:SetSize(26,26)
			if i ==3 then
				tex:SetPoint("CENTER",-0.5,0)
			else
				tex:SetPoint("CENTER")
			end
		end
	end
end

M.kill(_G["MainMenuMicroButton"])
M.kill(_G["HelpMicroButton"])

micromenu:RegisterEvent("PLAYER_TALENT_UPDATE")
micromenu:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
micromenu:SetScript("OnEvent", function(self,event) 
      if  not InCombatLockdown() and (event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
		local temp = {}
        for i=1,#buttons do
			local a = _G[buttons[i]]
			a:SetParent(micro_hold)
			a:ClearAllPoints()
			if i == 1 then
				a:SetPoint("TOPRIGHT",0,24)
			else
				a:SetPoint("TOP",temp[i-1],"BOTTOM",0,20)
			end
			temp[i] = a
		end
      end
end)

local enter_ = function(self) 
	self.hil:SetAlpha(1)
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPRIGHT",micro_hold,"TOPLEFT",-18,4)
end

local leave_ = function(self) self.hil:SetAlpha(0) end

M.addafter(function()
	local tab = GuildMicroButtonTabard
	tab:SetParent(micromenu)
	tab.SetPoint = M.null
	tab:SetFrameLevel(20)
	micro_hold:SetAlpha(0)
	for i=1,#buttons do
		temp[i]:HookScript("OnEnter",enter_)
		temp[i]:HookScript("OnLeave",leave_)
	end
	temp[6]:HookScript("OnClick",function() tab:SetAlpha(1) end)
end)

local factionGroup = UnitFactionGroup("player")
local texture = masks[7]:CreateTexture(nil,"ARTWORK")
	texture:SetPoint("CENTER",7,-8)
	texture:SetTexture([[Interface\TargetingFrame\UI-PVP-]]..factionGroup)
	texture:SetSize(44,44)

local port_fix = function(self,_,unit)
	if unit ~= "player" then return end
	self:SetUnit(unit)
	self:fixworgen()
	self:SetPortraitZoom(1.03)
end	
	
local pmodel = CreateFrame("PlayerModel",nil,masks[1])
	pmodel:SetPoint("TOPLEFT",4,-4)
	pmodel:SetPoint("BOTTOMRIGHT",-4,4)
	pmodel:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	pmodel:RegisterEvent("UNIT_MODEL_CHANGED")	
	pmodel:SetScript("OnEvent",port_fix)
	pmodel:SetScript("OnShow",function(self) port_fix(self,nil,"player") end)
	pmodel.fixworgen = M.fixworgen
	
micromenu:Hide()
M.make_plav(micromenu,.13,true)
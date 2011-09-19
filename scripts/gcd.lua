local C,M,L,V = unpack(select(2,...))

if V.showgcd ~= true then return end

local referenceSpells = {
	49892,			-- Death Coil (Death Knight)
	66215,			-- Blood Strike (Death Knight)
	1978,			-- Serpent Sting (Hunter)
	585,			-- Smite (Priest)
	19740,			-- Blessing of Might (Paladin)
	172,			-- Corruption (Warlock)
	5504,			-- Conjure Water (Mage)
	772,			-- Rend (Warrior)
	331,			-- Healing Wave (Shaman)
	1752,			-- Sinister Strike (Rogue)
	5176,			-- Wrath (Druid)
}

local GetTime = GetTime
local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local GetSpellCooldown = GetSpellCooldown
local spellid = nil
local GetSpellInfo = GetSpellInfo
local GetSpellBookItemName = GetSpellBookItemName
local GetCVar = GetCVar
local min = math.min

local Init = function()
	local FindInSpellbook = function(spell)
		for tab = 1, 4 do
			local _, _, offset, numSpells = GetSpellTabInfo(tab)
			for i = (1+offset), (offset + numSpells) do
				local bspell = GetSpellBookItemName(i, BOOKTYPE_SPELL)
				if (bspell == spell) then
					return i   
				end
			end
		end
		return nil
	end

	for _, lspell in pairs(referenceSpells) do
		local na = GetSpellInfo (lspell)
		local x = FindInSpellbook(na)
		if x ~= nil then
			spellid = lspell
			break
		end
	end

	return spellid
end

local OnUpdateGCD = function(self)
	local perc = (GetTime() - self.starttime) / self.duration
	if perc > 1 then
		self:Hide()
	else
		self:SetValue(perc)
	end
end

local OnHideGCD = function(self)
 	self:SetScript('OnUpdate', nil)
end

local OnShowGCD = function(self)
	self:SetScript('OnUpdate', OnUpdateGCD)
end

local gettolerance = function()
	if GetCVar("reducedLagTolerance") == "1" then
		return GetCVar("maxSpellStartRecoveryOffset")
	else
		return 400
	end
end

local Update = function(self, event, unit)
	if spellid == nil then
		if Init() == nil then
			return
		end
	end

	local start, dur = GetSpellCooldown(spellid)

	if (not start) then return end
	if (not dur) then dur = 0 end

	if (dur == 0) then
		self:Hide() 
	else
		self.tol:SetWidth(min((self.w*(gettolerance()/(dur*1000))),self.w))
		self.starttime = start
		self.duration = dur
		self:Show()
	end

end

local make = function()
	local gcd = CreateFrame("StatusBar", "Player_GCD", UIParent)
		gcd:SetHeight(6)
		
		local w = ({754,754,1134,1134,564,946,526,754})[V.layout]
		local tex = M["media"].barv
		
		gcd:SetWidth(w)
		gcd:SetPoint("BOTTOM", UIParent,0,({44,78,44,78,78,78,112,112})[V.layout])
		gcd:SetStatusBarTexture(tex)
		gcd:SetStatusBarColor(1, 0.8, 0.15)
		gcd:SetFrameLevel(2)
		gcd:SetFrameStrata("BACKGROUND")
		gcd.mirror = CreateFrame("Frame",nil,gcd)
		
	local bg = M.frame(UIParent)
		bg:SetPoint("TOPLEFT",gcd,-4,4)
		bg:SetPoint("BOTTOMRIGHT",gcd,4,-4)
		bg:SetAlpha(0)
		bg:SetFrameLevel(0)
		bg:SetFrameStrata("BACKGROUND")
		
	local tol = gcd:CreateTexture(nil,"OVERLAY")
		tol:SetPoint("RIGHT")
		tol:SetTexture(tex)
		tol:SetVertexColor(1,0,0,.7)
		tol:SetHeight(6)
		gcd.tol = tol
		gcd.w = w
		
	local green_compl = bg:CreateTexture(nil,"OVERLAY")
		green_compl:SetAllPoints(gcd)
		green_compl:SetTexture(tex)
		green_compl:SetVertexColor(0,1,0,1)
		
		gcd.mirror:HookScript("OnShow", function() UIFrameFadeIn(bg,0,0,1) green_compl:SetAlpha(0) end)
		gcd.mirror:HookScript("OnHide", function() UIFrameFadeOut(bg,1,1,0) green_compl:SetAlpha(1) end)
		
	return gcd
end

M.addafter(function()
	local addon = make()
	addon:Hide()
	addon.starttime = 0
	addon.duration = 0
	addon:SetMinMaxValues(0, 1)
	addon:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
	addon:SetScript("OnEvent",Update)
	addon:SetScript('OnHide', OnHideGCD)
	addon:SetScript('OnShow', OnShowGCD)
end)
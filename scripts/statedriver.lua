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

local C,M,L,V = unpack(select(2,...))
local _G = _G
local bar = _G.DerpyMainMenuBar

local check
do
	local layout = V.layout
	local chat_point = ({380,380,570,570,285,475,266,380})[layout]
	local bt_x_point = ({-361,-361,-551,-551,-266,-456,-247,-361})[layout]
	local bt_y_point = V.reverse and ({10,44,10,44,44,44,78,78})[layout] or 10
	check = function(bt)
		C.ChatPoint = chat_point
		bt:SetPoint("BOTTOM",UIParent,bt_x_point,bt_y_point)
	end
end

local reset_colors
do
	local side_table = C.side_table
	reset_colors = function()
		for i=1,12 do
			_G["ActionButton"..i]._derpy_mask:backcolor(0,0,0)
		end
		for i=13, #side_table do
			side_table[i]._derpy_mask:backcolor(0,0,0)
		end
	end
end

local GetBar = function()
    local condition = Page["DEFAULT"]
    local page = Page[M.class]
    if page then
      if M.class == "DRUID" then
        if IsSpellKnown(33891) then
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

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
bar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
bar:RegisterEvent("BAG_UPDATE")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
bar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
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
			button:SetParent(self)
		end
	elseif event == "UPDATE_SHAPESHIFT_FORM" then
		reset_colors()
	elseif event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
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
		
		if event == "PLAYER_LOGIN" then
			self:UnregisterEvent("PLAYER_LOGIN")
		end
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

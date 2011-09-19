-- local C,M,L,V = unpack(select(2,...)) --

local ns = select(2,...)
ns[1] = {}
ns[2] = DerpyData[1]
ns[3] = DerpyData[2]

if not _G.DerpyAB then
	_G.DerpyAB = {
			["layout"] = 1,
			["savedright"] = 1,
			["pet_unit"] = 1,
			["range"] = true,
			["showpet"] = true,
			["hovernames"] = false,
			["shownames"] = true,
			["hovermacro"] = true,
			["showmacro"] = true,
			["reverse"] = true,
			["showright"] = true,
			["showtotems"] = true,
			["showgcd"] = true,
			["cooldown"] = true,
			["fitchat"] = true,}
end

ns[4] = _G.DerpyAB

local api = require("api")

local old_color_addon = {
  name = "Old Colors",
  author = "Shinimi",
  desc = "Maybe restores old ArcheAge nametag colors.",
  version = "1.0.0"
}


local OLD_COLORS = {
  green       = "8377419",   -- #7FD44B 
  purple      = "8816348",   -- #8686DC 
  red         = "15683153",  -- #EF4E51
  pink        = "15825848",  -- #F17BB8 
  light_blue  = "8638196",   -- #83CEF4
  dark_blue   = "3707124"    -- #3890F4
}


local function OnLoad()

  api.Nametag:SetColorFriendly(OLD_COLORS.green)
  api.Nametag:SetColorPK(OLD_COLORS.purple)
  api.Nametag:SetColorEnemy(OLD_COLORS.red)
  api.Nametag:SetColorPirate(OLD_COLORS.pink)
  api.Nametag:SetColorParty(OLD_COLORS.light_blue)
  api.Nametag:SetColorRaid(OLD_COLORS.dark_blue)

  api.Log:Info("[Old Colors] nyah~")
 
end

old_color_addon.OnLoad = OnLoad

return old_color_addon

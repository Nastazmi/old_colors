local api = require("api")

local old_color_addon = {
  name    = "Old Colors",
  author  = "Shinimi",
  desc    = "Restores ArcheAge nameplate colors!",
  version = "1.0.0"
}

local Color = {
	Bright_Lime_Green 	= "7590451",	-- #73D233
	Bright_Sky_Blue 	= "5229803",	-- #4FCCEB
	Golden_Yellow 		= "16766976",	-- #FFD800
	Bright_Red			= "16729670",	-- #FF4646
	Medium_Gray 		= "9803157",	-- #959595
	Lavender_Purple 	= "10122197",	-- #9A73D5
	Vivid_Azure_Blue 	= "2591740",	-- #278BFC
	Orange 				= "15624995",	-- #EE6B23
	Light_Lime_Green 	= "11795824",	-- #B3FD70
	Pale_Cyan			= "10152958",	-- #9AEBFE
	Light_Golden_Yellow = "16771178",	-- #FFE86A	
	Light_Coral_Red 	= "16742006",	-- #FF7676
	Light_Gray 			= "11645361",	-- #B1B1B1	
	Light_Lavender 		= "13149951",	-- #C8A6FF	
	Light_Azure_Blue 	= "5809919",	-- #58A6FF
	Coral_Orange 		= "16747872",	-- #FF8D60
	Pink 				= "15825848"    -- #F17BB8 
}

local NamePlate_Color = {
    player 		    = Color.Bright_Lime_Green,		-- #73d233 
    pk     		    = Color.Lavender_Purple,   		-- #9A73D5 
    enemy   		= Color.Bright_Red,   			-- #FF4646
    pirate   		= Color.Pink,					-- #F17BB8 
    party 		    = Color.Bright_Sky_Blue,    	-- #4FCCEB
    raid  		    = Color.Vivid_Azure_Blue,   	-- #278BFC
    friendly_npc    = Color.Light_Golden_Yellow, 	-- #FFD800
    monster		    = Color.Medium_Gray				-- #B1B1B1
}


local settingsWindow
local SettingsFrame = nil
local cbx           = nil
local SETTINGS      = nil
local SETTINGS_PATH = "old_colors/settings.txt"

local DEFAULT_SETTINGS = {
    monsterGray = false
}

local function LoadSettings()
    local savedSettings = api.File:Read(SETTINGS_PATH)

    if savedSettings == nil then
        SETTINGS = DEFAULT_SETTINGS
        api.File:Write(SETTINGS_PATH, SETTINGS)
        api.Log:Info("[Old Colors] Created default settings file.")
        return
    end

    SETTINGS = savedSettings

    if SETTINGS.monsterGray == nil then
        SETTINGS.monsterGray = DEFAULT_SETTINGS.monsterGray
        api.File:Write(SETTINGS_PATH, SETTINGS)
    end
end

local function SaveSettings()
    api.File:Write(SETTINGS_PATH, SETTINGS)
end


local function ApplyMonsterColor()
    local color = NamePlate_Color.enemy

    if SETTINGS.monsterGray == true then
        color = NamePlate_Color.monster
    end

    api.Nametag:SetColorMonster(color)
end

local function SkinCheckButton(checkbox)
    local function MakeDrawable(x, y)
        local drawable = checkbox:CreateImageDrawable("ui/button/check_button.dds", "background")
        drawable:SetExtent(18, 17)
        drawable:AddAnchor("CENTER", checkbox, 0, 0)
        drawable:SetCoords(x, y, 18, 17)
        return drawable
    end

    checkbox:SetNormalBackground(MakeDrawable(0, 0))
    checkbox:SetHighlightBackground(MakeDrawable(0, 0))
    checkbox:SetPushedBackground(MakeDrawable(0, 0))
    checkbox:SetDisabledBackground(MakeDrawable(0, 17))
    checkbox:SetCheckedBackground(MakeDrawable(18, 0))
    checkbox:SetDisabledCheckedBackground(MakeDrawable(18, 17))
end
 


local function CreateSettingsWindow()
    SettingsFrame = api.Interface:CreateWindow(
        "old_color_settings",
        "Old Colors",
        460,
        300
    )

    SettingsFrame:RemoveAllAnchors()
    SettingsFrame:AddAnchor("CENTER", "UIParent", 0, 0)
    SettingsFrame:SetExtent(300, 120)
    SettingsFrame:Show(false)

    cbx = api.Interface:CreateWidget(
        "checkbutton",
        "cbx",
        SettingsFrame
        )

    cbx:SetExtent(18, 17)
    cbx:AddAnchor("TOPLEFT", SettingsFrame, 20, 50)
    SkinCheckButton(cbx)
    cbx:SetChecked(SETTINGS.monsterGray == true)
    cbx:Show(true)

    local label = SettingsFrame:CreateChildWidget("label", "monsterGrayLabel", 0, true)
    label:SetText("Use gray monster nametag")
    label:AddAnchor("LEFT", cbx, "RIGHT", 8, 0)
    label.style:SetFontSize(13)
    label.style:SetAlign(ALIGN.LEFT)
    --label.style:SetShadow(true)

    ApplyTextColor(label, FONT_COLOR.DEFAULT)

    local applyButton = SettingsFrame:CreateChildWidget("button", "applyButton", 0, true)
    api.Interface:ApplyButtonSkin(applyButton, BUTTON_BASIC.DEFAULT)
    applyButton:SetText("Apply")
    applyButton:SetExtent(90, 28)
    applyButton:AddAnchor("BOTTOMRIGHT", SettingsFrame, -20, -20)

    function applyButton:OnClick()
        SETTINGS.monsterGray = cbx:GetChecked()
        SaveSettings()
        ApplyMonsterColor()
    end

    applyButton:SetHandler("OnClick", applyButton.OnClick)
end


local function ShowSettings()
    if SettingsFrame ~= nil then
        SettingsFrame:Show(true)
    end
end

local function OnLoad()
 	LoadSettings()

	api.Nametag:SetColorFriendly(NamePlate_Color.player)
	api.Nametag:SetColorParty(NamePlate_Color.party)
	api.Nametag:SetColorRaid(NamePlate_Color.raid)
	
	api.Nametag:SetColorRaidPK(NamePlate_Color.pk)
	api.Nametag:SetColorPK(NamePlate_Color.pk)

	api.Nametag:SetColorEnemy(NamePlate_Color.enemy)
	api.Nametag:SetColorPirate(NamePlate_Color.pirate)

	api.Nametag:SetColorFriendlyNPC(NamePlate_Color.friendly_npc)
	api.Nametag:SetColorMonster(NamePlate_Color.enemy)

	ApplyMonsterColor()
    CreateSettingsWindow()

	api.Log:Info("[Old Colors] nyah~")
	
end

local function OnUnload()
    if SettingsFrame ~= nil then
        SettingsFrame:Show(false)
        SettingsFrame = nil
    end

    api.Log:Info("[Old Colors] Unloaded.")
end

local function ShowSettings()
	SettingsFrame:Show(true)
end

old_color_addon.OnLoad = OnLoad
old_color_addon.OnUnload = OnUnload
old_color_addon.OnSettingToggle = ShowSettings 

return old_color_addon

--[[--------------------------------------------------------------------
	PetBattleAutoForfeit
	A World of Warcraft user interface addon
	Copyright (c) 2012-2014 Phanx

	This addon is freely available, and its source code freely viewable,
	but it is not "open source software" and you may not distribute it,
	with or without modifications, without permission from its author.

	See the included README and LICENSE files for more information!
----------------------------------------------------------------------]]

local ADDON, private = ...
local L = private.L

local options = CreateFrame("Frame", ADDON.."Options", InterfaceOptionsFramePanelContainer)
options.name = GetAddOnMetadata(ADDON, "Title") or ADDON
options:Hide()
InterfaceOptions_AddCategory(options)

options:SetScript("OnShow", function(options)
	local title = options:CreateFontString("$parentTitle", "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(options.name)
	options.title = title

	local subtext = options:CreateFontString("$parentSubText", "ARTWORK", "GameFontHighlightSmall")
	subtext:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtext:SetPoint("RIGHT", -32, 0)
	subtext:SetHeight(32)
	subtext:SetJustifyH("LEFT")
	subtext:SetJustifyV("TOP")
	subtext:SetText(GetAddOnMetadata(ADDON, "Notes"))
	options.subtext = subtext

	local enable = CreateFrame("CheckButton", "$parentEnable", options, "InterfaceOptionsCheckButtonTemplate")
	enable:SetPoint("TOPLEFT", subtext, "BOTTOMLEFT", -2, -8)
	enable.Text:SetText(L.Enable)
	enable.tooltipText = L.Enable_Tooltip
	enable:SetScript("OnClick", function(self)
		local checked = not not self:GetChecked()
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainmenuOptionCheckBoxOff")
		PBAF_ENABLE = checked
	end)

	--------------------------------

	local quality = CreateFrame("Slider", "$parentQuality", options, "OptionsSliderTemplate")
	quality:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 6, -30)
	quality:SetWidth(250)
	quality:SetMinMaxValues(1, 4)
	quality:SetValueStep(1)

	quality.low = _G[quality:GetName().."Low"]
	quality.low:SetPoint("TOPLEFT", quality, "BOTTOMLEFT", 0, 0)
	quality.low:SetFormattedText("%s%s|r", ITEM_QUALITY_COLORS[0].hex, BATTLE_PET_BREED_QUALITY1)

	quality.high = _G[quality:GetName().."High"]
	quality.high:SetPoint("TOPRIGHT", quality, "BOTTOMRIGHT", 0, 0)
	quality.high:SetFormattedText("%s%s|r", ITEM_QUALITY_COLORS[3].hex, BATTLE_PET_BREED_QUALITY4)

	quality.text = _G[quality:GetName().."Text"]
	quality.text:SetText(L.MinQuality)
	quality.tooltipText = L.MinQuality_Tooltip

	quality.value = quality:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	quality.value:SetPoint("TOP", quality, "BOTTOM", 0, 0)

	quality:SetScript("OnValueChanged", function(self, value)
		value = floor(value + 0.5)
		self.value:SetFormattedText("%s%s|r", ITEM_QUALITY_COLORS[value-1].hex, _G["BATTLE_PET_BREED_QUALITY"..value])
		PBAF_MIN_QUALITY = value
	end)

	--------------------------------

	local level = CreateFrame("Slider", "$parentLevel", options, "OptionsSliderTemplate")
	level:SetPoint("LEFT", quality, "RIGHT", 24, 0)
	level:SetWidth(250)
	level:SetMinMaxValues(1, 10)
	level:SetValueStep(1)

	level.low = _G[level:GetName().."Low"]
	level.low:SetPoint("TOPLEFT", level, "BOTTOMLEFT", 0, 0)
	level.low:SetText("+1")

	level.high = _G[level:GetName().."High"]
	level.high:SetPoint("TOPRIGHT", level, "BOTTOMRIGHT", 0, 0)
	level.high:SetText("+10")

	level.text = _G[level:GetName().."Text"]
	level.text:SetText(L.MinLevelUp)
	level.tooltipText = L.MinLevelUp_Tooltip

	level.value = level:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	level.value:SetPoint("TOP", level, "BOTTOM", 0, 0)

	level:SetScript("OnValueChanged", function(self, value)
		value = floor(value + 0.5)
		self.value:SetFormattedText("+%d", value)
		PBAF_MIN_LEVEL_DIFF = value
	end)

	--------------------------------

	function options:refresh()
		enable:SetChecked(PBAF_ENABLE)

		quality:SetValue(PBAF_MIN_QUALITY)
		quality.value:SetFormattedText("%s%s|r", ITEM_QUALITY_COLORS[PBAF_MIN_QUALITY-1].hex, _G["BATTLE_PET_BREED_QUALITY"..PBAF_MIN_QUALITY])

		level:SetValue(PBAF_MIN_LEVEL_DIFF)
		level.value:SetFormattedText("+%d", PBAF_MIN_LEVEL_DIFF)
	end

	options:refresh()
	options:SetScript("OnShow", nil)
end)

if LibStub and LibStub("LibAboutPanel", true) then
	options.about = LibStub("LibAboutPanel").new(options.name, ADDON)
end

SLASH_PBAF1 = "/pbaf"
SlashCmdList.PBAF = function(cmd)
	if options.about then
		InterfaceOptionsFrame_OpenToCategory(options.about)
	end
	InterfaceOptionsFrame_OpenToCategory(options)
end
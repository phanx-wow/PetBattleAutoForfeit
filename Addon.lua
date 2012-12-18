--[[--------------------------------------------------------------------
	PetBattleAutoForfeit
	A World of Warcraft user interface addon
	Copyright (c) 2012 Phanx

	This addon is freely available, and its source code freely viewable,
	but it is not "open source software" and you may not distribute it,
	with or without modifications, without permission from its author.

	See the included README and LICENSE files for more information!
----------------------------------------------------------------------]]

local ADDON = ...

local CLICK_TEXT = "|cffff9900No upgrades available!|r|n|nClick anywhere to forfeit.|nRight-click to continue the battle anyway."

------------------------------------------------------------------------

PBAF_ENABLE = true
PBAF_MIN_QUALITY = 3
PBAF_MIN_LEVEL_DIFF = 1

local f = CreateFrame("Button", ADDON, UIParent)
f:SetAllPoints(true)
f:SetFrameStrata("FULLSCREEN_DIALOG")
f:RegisterForClicks("AnyUp")
f:Hide()

f.bg = f:CreateTexture(nil, "BACKGROUND")
f.bg:SetAllPoints(true)
f.bg:SetTexture(0, 0, 0, 0.5)

f.text = f:CreateFontString(nil, "OVERLAY", "PVPInfoTextFont")
f.text:SetPoint("CENTER")
f.text:SetText(CLICK_TEXT)

f:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		C_PetBattles.ForfeitGame()
	end
	self:Hide()
end)

------------------------------------------------------------------------

local petLevel, petQuality = {}, {}

f:RegisterEvent("PET_BATTLE_OPENING_START")
f:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
f:SetScript("OnEvent", function(self, event)
	if event == "PET_JOURNAL_LIST_UPDATE" then
		local wiped
		local _, numPets = C_PetJournal.GetNumPets(false)
		for i = numPets, 1, -1 do
			local id, species, owned, _, level = C_PetJournal.GetPetInfoByIndex(i, false)
			if not id or not name then
				-- List is filtered. Skip update.
				return
			end
			if not wiped then
				wipe(petLevel)
				wipe(petQuality)
				wiped = true
			end
			if owned then
				local _, _, _, _, quality = C_PetJournal.GetPetStats(id)
				if not petLevel[species] or level > petLevel[species] then
					petLevel[species] = level
				end
				if not petQuality[species] or quality > petQuality[species] then
					petQuality[species] = quality
				end
			end
		end
	elseif PBAF_ENABLE and C_PetBattles.IsWildBattle() then
		local upgrade
		for i = 1, C_PetBattles.GetNumPets(LE_BATTLE_PET_ENEMY) do
			local species = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, i)
			local quality = C_PetBattles.GetBreedQuality(LE_BATTLE_PET_ENEMY, i)
			local level = C_PetBattles.GetLevel(LE_BATTLE_PET_ENEMY, i)
			if quality >= PBAF_MIN_QUALITY then
				if not petQuality[species] then
					upgrade = true
					break
				elseif quality > petQuality[species] then
					upgrade = true
					break
				elseif quality == petQuality[species] and level - PBAF_MIN_LEVEL_DIFF >= petLevel[species] then
					upgrade = true
					break
				end
			end
		end
		if not upgrade then
			self:Show()
		end
	end
end)
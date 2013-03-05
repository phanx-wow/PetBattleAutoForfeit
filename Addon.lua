--[[--------------------------------------------------------------------
	PetBattleAutoForfeit
	A World of Warcraft user interface addon
	Copyright (c) 2012-2013 Phanx

	This addon is freely available, and its source code freely viewable,
	but it is not "open source software" and you may not distribute it,
	with or without modifications, without permission from its author.

	See the included README and LICENSE files for more information!
----------------------------------------------------------------------]]

local ADDON = ...

local L_NoUpgrades = "No upgrades available!"
local L_ClickForfeit = "Click anywhere to forfeit.|nRight-click to continue the battle anyway."

if GetLocale():match("^es") then
	L_NoUpgrades = "No hay mejoras disponibles!"
	L_ClickForfeit = "Clic en cualquier parte para abandonar el duelo.|nClick derecho para continuar sin embargo el duelo."

elseif GetLocale() == "frFR" then
	-- Translated by L0relei
	L_NoUpgrades = "Pas d'améliorations disponibles !"
	L_ClickForfeit = "Cliquez n'importe où pour déclarer forfait.|nCliquez droit pour continuer quand même le combat."
end

------------------------------------------------------------------------

local SPECIES_NOT_CAPTURABLE = {
	[52] = true, -- Ancona Chicken
}

------------------------------------------------------------------------

local f = CreateFrame("Button", ADDON, UIParent)
f:SetAllPoints(true)
f:SetFrameStrata("FULLSCREEN_DIALOG")
f:RegisterForClicks("AnyUp")
f:Hide()

f.bg = f:CreateTexture(nil, "BACKGROUND")
f.bg:SetAllPoints(true)
f.bg:SetTexture(0, 0, 0, 0.5)

f.text1 = f:CreateFontString(nil, "OVERLAY", "SubZoneTextFont")
f.text1:SetPoint("BOTTOM", f, "CENTER", 0, 24)
f.text1:SetTextColor(1, 0.7, 0)
f.text1:SetText(L_NoUpgrades)

f.text2 = f:CreateFontString(nil, "OVERLAY", "PVPInfoTextFont")
f.text2:SetPoint("TOP", f, "CENTER", 0, 0)
f.text2:SetText(L_ClickForfeit)

f:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		C_PetBattles.ForfeitGame()
	end
	self:Hide()
end)

------------------------------------------------------------------------

function f:HookButton()
	if PetBattleFrame and PetBattleFrame.BottomFrame and PetBattleFrame.BottomFrame.ForfeitButton then
		PetBattleFrame.BottomFrame.ForfeitButton:SetScript("OnClick", function(...)
			if IsShiftKeyDown() then
				C_PetBattles.ForfeitGame()
			else
				PetBattleForfeitButton_OnClick(...)
			end
		end)
		self.HookButton = nil
	end
end

function f:GetBestPetInfo(species)
	local best, highest = 0, 0
	for _, petID in LibStub("LibPetJournal-2.0"):IteratePetIDs() do
		local speciesID, _, level = C_PetJournal.GetPetInfoByPetID(petID)
		if speciesID == species then
			local _, _, _, _, quality = C_PetJournal.GetPetStats(petID)
			if quality >= best then
				best = quality
				highest = max(highest, level)
			end
		end
	end
	return best, highest
end

f:RegisterEvent("PET_BATTLE_OPENING_START")
f:SetScript("OnEvent", function(self, event, name)
	if self.HookButton then
		self:HookButton()
	end
	if PBAF_ENABLE and C_PetBattles.IsWildBattle() then
		local upgrade
		for i = 1, C_PetBattles.GetNumPets(LE_BATTLE_PET_ENEMY) do
			local species = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, i)
			if not SPECIES_NOT_CAPTURABLE[species] then
				local quality = C_PetBattles.GetBreedQuality(LE_BATTLE_PET_ENEMY, i)
				if quality >= PBAF_MIN_QUALITY then
					local bestQuality, bestLevel = f:GetBestPetInfo(species)
					if not bestQuality then
						upgrade = true
						break
					elseif quality > bestQuality then
						upgrade = true
						break
					elseif quality == bestQuality then
						local level = C_PetBattles.GetLevel(LE_BATTLE_PET_ENEMY, i)
						if level - PBAF_MIN_LEVEL_DIFF >= bestLevel then
							upgrade = true
							break
						end
					end
				end
			end
		end
		if not upgrade then
			self:Show()
		end
	end
end)

------------------------------------------------------------------------

PBAF_ENABLE = true
PBAF_MIN_QUALITY = 3
PBAF_MIN_LEVEL_DIFF = 1
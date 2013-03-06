--[[--------------------------------------------------------------------
	PetBattleAutoForfeit
	A World of Warcraft user interface addon
	Copyright (c) 2012-2013 Phanx

	This addon is freely available, and its source code freely viewable,
	but it is not "open source software" and you may not distribute it,
	with or without modifications, without permission from its author.

	See the included README and LICENSE files for more information!
----------------------------------------------------------------------]]

local ADDON, private = ...
local L = private.L

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
f.text1:SetText(L.NoUpgrades)

f.text2 = f:CreateFontString(nil, "OVERLAY", "PVPInfoTextFont")
f.text2:SetPoint("TOP", f, "CENTER", 0, 0)
f.text2:SetText(L.ClickForfeit)

f:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		C_PetBattles.ForfeitGame()
	end
	self:Hide()
end)

------------------------------------------------------------------------

local PetJournal

f:RegisterEvent("PET_BATTLE_OPENING_START")
f:SetScript("OnEvent", function(self, event, name)
	if not PetJournal then
		PetJournal = LibStub("LibPetJournal-2.0")
	end

	if PBAF_ENABLE and C_PetBattles.IsWildBattle() then
		local upgrade
		for i = 1, C_PetBattles.GetNumPets(LE_BATTLE_PET_ENEMY) do

			local species = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, i)
			local _, _, _, _, _, _, wild = C_PetJournal.GetPetInfoBySpeciesID(species)
			if wild then

				local quality = C_PetBattles.GetBreedQuality(LE_BATTLE_PET_ENEMY, i)
				if quality >= PBAF_MIN_QUALITY then

					local bestQuality, bestLevel = 0, 0
					for _, petID in PetJournal:IteratePetIDs() do

						local petSpecies, _, petLevel = C_PetJournal.GetPetInfoByPetID(petID)
						if petSpecies == species then

							local _, _, _, _, petQuality = C_PetJournal.GetPetStats(petID)
							if petQuality >= bestQuality then
								bestQuality = petQuality
								bestLevel = max(bestLevel, petLevel)
							end
						end
					end

					if bestQuality == 0 then
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

	if not self.upgradedForfeitButton and PetBattleFrame and PetBattleFrame.BottomFrame and PetBattleFrame.BottomFrame.ForfeitButton then
		PetBattleFrame.BottomFrame.ForfeitButton:SetScript("OnClick", function(...)
			if IsShiftKeyDown() then
				C_PetBattles.ForfeitGame()
			else
				PetBattleForfeitButton_OnClick(...)
			end
		end)
		self.upgradedForfeitButton = true
	end
end)

------------------------------------------------------------------------

PBAF_ENABLE = true
PBAF_MIN_QUALITY = 3 -- 1: poor, 2: common, 3: uncommon, 4: rare | shifted +1 vs values from GetItemInfo and in ITEM_QUALITY_COLORS
PBAF_MIN_LEVEL_DIFF = 3
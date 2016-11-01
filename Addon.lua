--[[--------------------------------------------------------------------
	PetBattleAutoForfeit
	Prompts for immediate forfeit when you enter a pet battle with no available upgrades.
	Copyright (c) 2012-2016 Phanx <addons@phanx.net>. All rights reserved.
	https://github.com/Phanx/PetBattleAutoForfeit
	https://mods.curse.com/addons/wow/petbattleautoforfeit
	https://www.wowinterface.com/downloads/info21998-PetBattleAutoForfeit.html
----------------------------------------------------------------------]]

local ADDON, private = ...
local L = private.L

------------------------------------------------------------------------

local db
PetBattleAutoForfeitDB = {
	enable = true,
	minLevelGain = 3,
	minQuality = 3, -- 1: poor, 2: common, 3: uncommon, 4: rare | shifted +1 vs values from GetItemInfo and in ITEM_QUALITY_COLORS
}

------------------------------------------------------------------------

local f = CreateFrame("Button", ADDON, UIParent)
f:SetAllPoints(true)
f:SetFrameStrata("FULLSCREEN_DIALOG")
f:RegisterForClicks("AnyUp")
f:Hide()

f.bg = f:CreateTexture(nil, "BACKGROUND")
f.bg:SetAllPoints(true)
f.bg:SetColorTexture(0, 0, 0, 0.5)

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

local LibPetJournal = LibStub("LibPetJournal-2.0")

local function IsUpgrade(i)
	local species = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, i)
	local name, _, _, _, _, _, wild, _, _, _, obtainable = C_PetJournal.GetPetInfoBySpeciesID(species)
	if not wild or not obtainable then return false end

	local quality = C_PetBattles.GetBreedQuality(LE_BATTLE_PET_ENEMY, i)
	if quality < db.minQuality then return end

	local bestQuality, bestLevel = 0, 0
	for _, petID in LibPetJournal:IteratePetIDs() do
		local petSpecies, _, petLevel = C_PetJournal.GetPetInfoByPetID(petID)
		if petSpecies == species then
			local _, _, _, _, petQuality = C_PetJournal.GetPetStats(petID)
			if petQuality >= bestQuality then
				bestQuality = petQuality
				bestLevel = max(bestLevel, petLevel)
			end
		end
	end

	if quality > bestQuality then
		return true
	elseif quality == bestQuality then
		local level = C_PetBattles.GetLevel(LE_BATTLE_PET_ENEMY, i)
		if level >= 20 then
			level = level - 2
		elseif level >= 16 then
			level = level - 1
		end
		if (level - db.minLevelGain) > bestLevel then
			return true
		end
	end
end

f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PET_BATTLE_OPENING_START")
f:SetScript("OnEvent", function(self, event)
	if not db then
		db = PetBattleAutoForfeitDB
		self:UnregisterEvent("PLAYER_LOGIN")
		-- Upgrade old settings
		if PBAF_ENABLE ~= nil then
			PetBattleAutoForfeitDB.enable = PBAF_ENABLE
			PBAF_ENABLE = nil
		end
		if PBAF_MIN_LEVEL_DIFF then
			PetBattleAutoForfeitDB.minLevelGain = PBAF_MIN_LEVEL_DIFF
			PBAF_MIN_LEVEL_DIFF = nil
		end
		if PBAF_MIN_QUALITY then
			PetBattleAutoForfeitDB.minQuality = PBAF_MIN_QUALITY
			PBAF_MIN_QUALITY = nil
		end
	end
	if db.enable and C_PetBattles.IsWildBattle() then
		for i = 1, C_PetBattles.GetNumPets(LE_BATTLE_PET_ENEMY) do
			if IsUpgrade(i) ~= nil then -- don't prompt vs non-capturable NPCs (IsUpgrade == false)
				return
			end
		end
		self:Show()
	end
end)

PetBattleFrame.BottomFrame.ForfeitButton:SetScript("OnClick", function(...)
	if IsShiftKeyDown() then
		C_PetBattles.ForfeitGame()
	else
		PetBattleForfeitButton_OnClick(...)
	end
end)

hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", function(self)
	if not self.UpgradeIcon then
		local UpgradeIcon = self:CreateTexture(nil, "ARTWORK", nil, 3)
		UpgradeIcon:SetTexture("Interface\\ContainerFrame\\UI-Icon-QuestBang")
		UpgradeIcon:SetAllPoints(self.Icon)
		self.UpgradeIcon = UpgradeIcon
		if self.BorderAlive then
			self.BorderAlive:SetDrawLayer("ARTWORK", 4)
		end
	end
	local owner, i, wild = self.petOwner, self.petIndex, C_PetBattles.IsWildBattle()
	if i and wild and owner == LE_BATTLE_PET_ENEMY and i <= C_PetBattles.GetNumPets(owner) and IsUpgrade(i) then
		self.UpgradeIcon:Show()
	else
		self.UpgradeIcon:Hide()
	end
end)

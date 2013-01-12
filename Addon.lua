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

local NO_UPGRADES_AVAILABLE = "No upgrades available!"
local CLICK_TO_FORFEIT = "Click anywhere to forfeit.|nRight-click to continue the battle anyway."
if GetLocale():match("^es") then
	NO_UPGRADES_AVAILABLE = "No hay mejoras disponibles!"
	CLICK_TO_FORFEIT = "Clic en cualquier parte para abandonar.|nClick derecho para continuar el duelo sin embargo."

elseif GetLocale() == "frFR" then
	-- Translated by L0relei
	NO_UPGRADES_AVAILABLE = "Pas d'améliorations disponibles !"
	CLICK_TO_FORFEIT = "Cliquez n'importe où pour déclarer forfait.|nCliquez droit pour continuer quand même le combat."
end

------------------------------------------------------------------------

local petLevel, petQuality = {}, {}

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
f.text1:SetText(NO_UPGRADES_AVAILABLE)

f.text2 = f:CreateFontString(nil, "OVERLAY", "PVPInfoTextFont")
f.text2:SetPoint("TOP", f, "CENTER", 0, 0)
f.text2:SetText(CLICK_TO_FORFEIT)

f:SetScript("OnClick", function(self, button)
	if button == "LeftButton" then
		C_PetBattles.ForfeitGame()
	end
	self:Hide()
end)

------------------------------------------------------------------------

f:RegisterEvent("PET_BATTLE_OPENING_START")
f:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
f:SetScript("OnEvent", function(self, event)
	if event == "PET_JOURNAL_LIST_UPDATE" then
		self:ScanPets(event)

	elseif PBAF_ENABLE and C_PetBattles.IsWildBattle() then
		local upgrade
		for i = 1, C_PetBattles.GetNumPets(LE_BATTLE_PET_ENEMY) do
			local species = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, i)
			if not SPECIES_NOT_CAPTURABLE[species] then
				local quality = C_PetBattles.GetBreedQuality(LE_BATTLE_PET_ENEMY, i)
				if quality >= PBAF_MIN_QUALITY then
					if not petQuality[species] then
						upgrade = true
						break
					elseif quality > petQuality[species] then
						upgrade = true
						break
					elseif quality == petQuality[species] then
						local level = C_PetBattles.GetLevel(LE_BATTLE_PET_ENEMY, i)
						if level - PBAF_MIN_LEVEL_DIFF >= petLevel[species] then
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

do
	-- Blizzard, how many drugs were you on when you wrote this shit?
	-- IsFiltered returns the opposite value you want to send to SetFilter...
	-- Changing any filter fires the update event...
	-- Filtering changes the API return values...

	local updating

	local flagDefaults = {
        [LE_PET_JOURNAL_FLAG_COLLECTED] = true,
        [LE_PET_JOURNAL_FLAG_FAVORITES] = false,
        [LE_PET_JOURNAL_FLAG_NOT_COLLECTED] = true,
	}

	local flags, types, sources = {}, {}, {}

	local search
	hooksecurefunc(C_PetJournal, "SetSearchFilter", function(x)
		--print("SetSearchFilter", x)
		search = x
	end)
	hooksecurefunc(C_PetJournal, "ClearSearchFilter", function()
		--print("ClearSearchFilter")
		search = nil
	end)

	function f:ScanPets(event)
		if updating then return end
		--print("Scanning pets")
		updating = true

		--print("Removing events")
		self:UnregisterEvent(event)
		if PetJournal then
			PetJournal:UnregisterEvent(event)
		end
		if LibStub and LibStub("LibPetJournal-2.0", true) then
			LibStub("LibPetJournal-2.0").event_frame:UnregisterEvent(event)
		end

		for flag, defaultState in pairs(flagDefaults) do
			local state = not C_PetJournal.IsFlagFiltered(flag)
			if state ~= defaultState then
				--print(flag, state, defaultState)
				flags[flag] = state
				C_PetJournal.SetFlagFilter(flag, defaultState)
			end
		end

		for i = 1, C_PetJournal.GetNumPetTypes() do
			local hidden = C_PetJournal.IsPetTypeFiltered(i)
			if hidden then
				--print("IsPetTypeFiltered", i, hidden)
				types[i] = hidden
			end
		end
		if next(types) then
			--print("AddAllPetTypesFilter")
			C_PetJournal.AddAllPetTypesFilter()
		end

		for i = 1, C_PetJournal.GetNumPetSources() do
			local hidden = C_PetJournal.IsPetSourceFiltered(i)
			if hidden then
				--print("IsPetSourceFiltered", i, hidden)
				sources[i] = hidden
			end
		end
		if next(sources) then
			--print("AddAllPetSourcesFilter")
			C_PetJournal.AddAllPetSourcesFilter()
		end

		local currentSearch = search
		C_PetJournal.ClearSearchFilter()

		local wiped
		local _, numPets = C_PetJournal.GetNumPets(true)
		--print("Found pets:", numPets)
		for i = numPets, 1, -1 do
			local id, species, owned, _, level = C_PetJournal.GetPetInfoByIndex(i)
			if not id then
				--print("STILL FILTERED WTF")
				break
			end
			if not wiped then
				--print("Scan is good")
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

		if currentSearch then
			--print("Restoring previous search:", currentSearch)
			C_PetJournal.SetSearchFilter(currentSearch)
		end

		for flag, value in pairs(flags) do
			--print("Restoring previous filter:", flag, value)
			C_PetJournal.SetFlagFilter(flag, value)
			flags[flag] = nil
		end

		for flag in pairs(types) do
			--print("Restoring previous type filter:", flag)
			C_PetJournal.SetPetTypeFilter(flag, false)
			types[flag] = nil
		end

		for flag in pairs(sources) do
			--print("Restoring previous source filter:", flag)
			C_PetJournal.SetPetSourceFilter(flag, false)
			sources[flag] = nil
		end

		--print("Restoring events")
		self:RegisterEvent(event)
		if PetJournal then
			PetJournal:RegisterEvent(event)
			if PetJournal:IsShown() then
				PetJournal:GetScript("OnEvent")(PetJournal, event)
			end
		end
		if LibStub and LibStub("LibPetJournal-2.0", true) then
			local event_frame = LibStub("LibPetJournal-2.0").event_frame
			event_frame:RegisterEvent(event)
		end

		--print("Done")
		updating = nil
	end
end

------------------------------------------------------------------------
-- Defaults, overridden at ADDON_LOADED

PBAF_ENABLE = true
PBAF_MIN_QUALITY = 3
PBAF_MIN_LEVEL_DIFF = 1
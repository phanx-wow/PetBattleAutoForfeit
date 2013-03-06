--[[--------------------------------------------------------------------
	PetBattleAutoForfeit
	A World of Warcraft user interface addon
	Copyright (c) 2012-2013 Phanx

	This addon is freely available, and its source code freely viewable,
	but it is not "open source software" and you may not distribute it,
	with or without modifications, without permission from its author.

	See the included README and LICENSE files for more information!
----------------------------------------------------------------------]]

local _, private = ...
local L = {}
private.L = L

L.Enable = ENABLE

L.Enable_Hint = "You may want to disable the addon temporarily while you're leveling up pets."
L.MinLevelUp = "Minimum Level Gain"
L.MinLevelUp_Hint = "Pets at least this many levels higher than yours are considered upgrades at the same quality."
L.MinQuality = "Minimum Quality"
L.MinQuality_Hint = "Pets below this quality are never considered upgrades."
L.NoUpgrades = "No upgrades available!"
L.ClickForfeit = "Click anywhere to forfeit.|nRight-click to continue the battle anyway."

------------------------------------------------------------------------

if GetLocale():match("^es") then
	L.Enable_Hint = "Puedes desear desactivar temporalmente el addon mientras levantas el nivel de tus mascotas de combate."
	L.MinQuality = "Calidad mínima"
	L.MinQuality_Hint = "Mascotas debajo de esta calidad nunca se consideran mejoras."
	L.MinLevelUp = "Ganancia de nivel mínimo"
	L.MinLevelUp_Hint = "Mascotas con la misma calidad que los tuyos se consideran mejoras si son al menos estos niveles muchos más altos."
	L.NoUpgrades = "No hay mejoras disponibles!"
	L.ClickForfeit = "Clic en cualquier parte para abandonar el duelo.|nClick derecho para continuar sin embargo el duelo."

------------------------------------------------------------------------

elseif GetLocale() == "frFR" then
	-- Translated by L0relei
	L.Enable_Hint = "Vous pourriez vouloir désactiver temporairement l'addon tandis que vous montez vos mascottes en niveau."
	L.MinQuality = "Qualité minimum"
	L.MinQuality_Hint = "Les mascottes en-dessous de cette qualité ne sont jamais considérées comme des améliorations."
	L.MinLevelUp = "Gain de niveau minimum"
	L.MinLevelUp_Hint = "Les mascottes qui ont au moins ce nombre de niveaux de plus que les vôtres sont considérées comme des améliorations à qualité égale."
	L.NoUpgrades = "Pas d'améliorations disponibles !"
	L.ClickForfeit = "Cliquez n'importe où pour déclarer forfait.|nCliquez droit pour continuer quand même le combat."

------------------------------------------------------------------------

end
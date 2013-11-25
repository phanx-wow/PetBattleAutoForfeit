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
local L = { Enable = ENABLE }
private.L = L

L.ClickForfeit = "Click anywhere to forfeit.|nRight-click to continue the battle anyway."
L.Enable_Hint = "You may want to disable the addon temporarily while you're leveling up pets."
L.MinLevelUp = "Minimum Level Gain"
L.MinLevelUp_Hint = "Pets at least this many levels higher than yours are considered upgrades at the same quality."
L.MinQuality = "Minimum Quality"
L.MinQuality_Hint = "Pets below this quality are never considered upgrades."
L.NoUpgrades = "No upgrades available!"

------------------------------------------------------------------------
if GetLocale() == "deDE" then

	L.ClickForfeit = "Klicken irgendwo, um aufgeben.|nRechtsklicken, um den Kampf trotzdem fortzusetzen."
	L.Enable_Hint = "Vielleicht möchten Sie das Addon vorübergehend deaktivieren, während Sie die Stufen Ihrer Kampfhaustiere zu erhöhen."
	L.MinLevelUp = "Mindeststufenerhöhung"
	L.MinLevelUp_Hint = "Kampfhaustiere wenigstens diese vielen Stufen höher als Ihre gelten als Verbesserungen, wenn sie mindestens die gleiche Stufe sind."
	L.MinQuality = "Mindestqualität"
	L.MinQuality_Hint = "Kampfhaustiere unterhalb dieser Qualität gelten nie als Verbesserungen."
	L.NoUpgrades = "Keine Verbesserungen sind verfügbar!"

------------------------------------------------------------------------
elseif GetLocale():match("^es") then

	L.ClickForfeit = "Clic en cualquier parte para abandonar el duelo.|nClick derecho para continuar sin embargo el duelo."
	L.Enable_Hint = "Puedes desear desactivar temporalmente el addon mientras levantar el nivel de tus mascotas de combate."
	L.MinLevelUp = "Ganancia mínimo de nivel"
	L.MinLevelUp_Hint = "Mascotas con la misma calidad que los tuyos se consideran mejoras si son al menos estos niveles más altos."
	L.MinQuality = "Calidad mínima"
	L.MinQuality_Hint = "Mascotas debajo de esta calidad nunca se consideran mejoras."
	L.NoUpgrades = "No hay mejoras disponibles!"

------------------------------------------------------------------------
elseif GetLocale() == "frFR" then

	-- Translated by L0relei
	L.ClickForfeit = "Cliquez n'importe où pour déclarer forfait.|nCliquez droit pour continuer quand même le combat."
	L.Enable_Hint = "Vous pourriez vouloir désactiver temporairement l'addon tandis que vous montez vos mascottes en niveau."
	L.MinLevelUp = "Gain de niveau minimum"
	L.MinLevelUp_Hint = "Les mascottes qui ont au moins ce nombre de niveaux de plus que les vôtres sont considérées comme des améliorations à qualité égale."
	L.MinQuality = "Qualité minimum"
	L.MinQuality_Hint = "Les mascottes en-dessous de cette qualité ne sont jamais considérées comme des améliorations."
	L.NoUpgrades = "Pas d'améliorations disponibles !"

------------------------------------------------------------------------
elseif GetLocale() == "ruRU" then

	-- Translated by Wetxius
	L.ClickForfeit = "Кликните где-нибудь, чтобы сдаться.|nПравый-клик для продолжения битвы."
	L.Enable_Hint = "Вы можете временно отключить аддон, пока вы повышаете уровень питомцев."
	L.MinLevelUp = "Минимальный получаемый уровень"
	L.MinLevelUp_Hint = "Питомцы, которые выше уровнем, считаются улучшением с тем же качеством."
	L.MinQuality = "Минимальное качество"
	L.MinQuality_Hint = "Питомцы ниже этого качества не считаются улучшением."
	L.NoUpgrades = "Нет улучшений!"

------------------------------------------------------------------------
end
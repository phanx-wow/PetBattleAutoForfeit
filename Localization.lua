--[[--------------------------------------------------------------------
	PetBattleAutoForfeit
	Prompts for immediate forfeit when you enter a pet battle with no available upgrades.
	Copyright (c) 2012-2014 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info21978-PetBattleAutoForfeit.html
	http://www.curse.com/addons/wow/petbattleautoforfeit
	https://github.com/Phanx/PetBattleAutoForfeit
----------------------------------------------------------------------]]

local _, private = ...
local L = { Enable = ENABLE }
private.L = L

L.ClickForfeit = "Click anywhere to forfeit.|nRight-click to continue the battle anyway."
L.Enable_Tooltip = "You may want to disable the addon temporarily while you're leveling up pets."
L.MinLevelUp = "Minimum Level Gain"
L.MinLevelUp_Tooltip = "Pets at least this many levels higher than yours are considered upgrades at the same quality."
L.MinQuality = "Minimum Quality"
L.MinQuality_Tooltip = "Pets below this quality are never considered upgrades."
L.NoUpgrades = "No upgrades available!"

------------------------------------------------------------------------
if GetLocale() == "deDE" then

L.ClickForfeit = "Irgendwo klicken, um aufzugeben.|nRechtsklicken, um den Kampf trotzdem fortzusetzen."
L.Enable_Tooltip = "Vielleicht möchten Sie das Addon vorübergehend deaktivieren, während Sie die Stufen Ihrer Kampfhaustiere zu erhöhen."
L.MinLevelUp = "Mindeststufenerhöhung"
L.MinLevelUp_Tooltip = "Kampfhaustiere wenigstens diese vielen Stufen höher als Ihre gelten als Verbesserungen, wenn sie mindestens die gleiche Stufe sind."
L.MinQuality = "Mindestqualität"
L.MinQuality_Tooltip = "Kampfhaustiere unterhalb dieser Qualität gelten nie als Verbesserungen."
L.NoUpgrades = "Keine Verbesserungen sind verfügbar!"

------------------------------------------------------------------------
elseif GetLocale():match("^es") then

L.ClickForfeit = "Clic dondequiera para abandonar el duelo.|nClick derecho para continuar sin embargo el duelo."
L.Enable_Tooltip = "Puedes desear desactivar temporalmente el addon mientras levantar el nivel de tus mascotas de combate."
L.MinLevelUp = "Ganancia mínimo de nivel"
L.MinLevelUp_Tooltip = "Mascotas con la misma calidad que los tuyos se consideran mejoras si son al menos estos niveles más altos."
L.MinQuality = "Calidad mínima"
L.MinQuality_Tooltip = "Mascotas debajo de esta calidad nunca se consideran mejoras."
L.NoUpgrades = "No hay ningunas mejoras disponibles!"

------------------------------------------------------------------------
elseif GetLocale() == "frFR" then -- Translated by L0relei

L.ClickForfeit = "Cliquez n'importe où pour déclarer forfait.|nCliquez droit pour continuer quand même le combat."
L.Enable_Tooltip = "Vous pourriez vouloir désactiver temporairement l'addon tandis que vous montez vos mascottes en niveau."
L.MinLevelUp = "Gain de niveau minimum"
L.MinLevelUp_Tooltip = "Les mascottes qui ont au moins ce nombre de niveaux de plus que les vôtres sont considérées comme des améliorations à qualité égale."
L.MinQuality = "Qualité minimum"
L.MinQuality_Tooltip = "Les mascottes en-dessous de cette qualité ne sont jamais considérées comme des améliorations."
L.NoUpgrades = "Pas d'améliorations disponibles !"

------------------------------------------------------------------------
elseif GetLocale() == "ptPT" then -- Translated by Ogadita

L.ClickForfeit = "Clique em qualquer lugar para desistir.|nClique com botão direito para continuar a batalha."
L.Enable_Hint = "Você pode desativar o addon temporariamente enquanto você está nivelando seus mascotes."
L.MinLevelUp = "Ganhou o level minimo"
L.MinLevelUp_Hint = "Mascotes com níveis mais elevados que o seu são consideradas atualizações e com a mesma qualidade."
L.MinQuality = "Qualidade mínima"
L.MinQuality_Hint = "Mascotes abaixo desse nivel nunca serão consideradas atualizações."
L.NoUpgrades = "Não há atualizações disponíveis!"

------------------------------------------------------------------------
elseif GetLocale() == "ruRU" then -- Translated by Wetxius

L.ClickForfeit = "Кликните где-нибудь, чтобы сдаться.|nПравый-клик для продолжения битвы."
L.Enable_Tooltip = "Вы можете временно отключить аддон, пока вы повышаете уровень питомцев."
L.MinLevelUp = "Минимальный получаемый уровень"
L.MinLevelUp_Tooltip = "Питомцы, которые выше уровнем, считаются улучшением с тем же качеством."
L.MinQuality = "Минимальное качество"
L.MinQuality_Tooltip = "Питомцы ниже этого качества не считаются улучшением."
L.NoUpgrades = "Нет улучшений!"

------------------------------------------------------------------------
end
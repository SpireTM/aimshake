local menu = 'crossi'
local shake = false
local speed = 1.6
local size = {x=0.01, y=0.015}
local snipers = {
  [`weapon_sniperrifle`] = "weapon_sniperrifle_clip",--'L96A1', --Lipas L96A1 .308
  [`weapon_heavysniper`] = "weapon_heavysniper_clip",--'Barrett M82A1', --Lipas M82A1 .50
  [`weapon_marksmanrifle`] = "weapon_marksmanrifle_clip",--'M39 EMR', --Lipas M39 .308
  [`weapon_marksmanrifle_mk2`] = "weapon_marksmanrifle_mk2_clip",--'Ruger Mini-30', --Lipas Ruger Mini 7.62mm
  [`weapon_heavysniper_mk2`] = "weapon_heavysniper_mk2_clip",--'Barrett XM500', --Lipas XM500 .50
  [`weapon_hunterrifle`] = "weapon_hunterrifle_shell",--'Vako 85 Metsästys', --6.5x55
}


CreateThread(function()

	if not HasStreamedTextureDictLoaded(menu) then
		RequestStreamedTextureDict(menu)
	end

	while true do
		local player = GetPlayerPed(-1)
		local hasWeapon,weaponHash = GetCurrentPedWeapon(player)

		if IsPedUsingActionMode(PlayerPedId()) and not GetPedConfigFlag(PlayerPedId(),78,1) then
			SetPedUsingActionMode(PlayerPedId(), false, -1, 0)
		end

		if hasWeapon then

			if not snipers[weaponHash] then
				HideHudComponentThisFrame(14)
			end

			if IsPlayerFreeAiming(PlayerId()) then
				local x,y = GetActiveScreenResolution()
				local z = 0.5625 * y
				local speed_ = GetEntitySpeed(PlayerPedId())
					
				if not snipers[weaponHash] and GetFollowPedCamViewMode() ~= 4 then
					if speed_ <= 0.5 then
						DrawSprite(menu,'crosshair',0.5,0.5, 0.01, (x/y)/100, 0.0,255,255,255,255)
					else
						DrawSprite(menu,'crosshair',0.5,0.5, 0.01 * 1.5, ((x/y)/100) * 1.5, 0.0,255,255,255,255)
					end
				end

				if not shake then
					ShakeGameplayCam("HAND_SHAKE", speed)
					shake = true
				end
			else
				if shake then
					ShakeGameplayCam("HAND_SHAKE", 0.0)
					shake = false
				end
			end
			SetWeaponsNoAutoswap(GetSelectedPedWeapon(PlayerPedId()))
		else
			Wait(100)
		end
		Wait(1)
	end
end)
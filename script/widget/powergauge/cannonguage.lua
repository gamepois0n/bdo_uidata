Panel_CannonGauge:SetShow( false )

-- local progress		= UI.getChildControl( Panel_PowerGauge, "Progress2_Gauge" )
-- local progressValue	= UI.getChildControl( Panel_PowerGauge, "StaticText_GaugeValue" )

local progress 				= UI.getChildControl( Panel_CannonGauge, "CannonGaugeBar" )
-- local progressValue 		= UI.getChildControl( Panel_CannonGauge, "StaticText_CannonDesc" )
-- local _bar_FullGauge 	= UI.getChildControl( Panel_CannonGauge, "Static_FullGauge" )
local _txt_StaminaMax 	= UI.getChildControl( Panel_CannonGauge, "StaticText_CannonGaugeMax" )

local elapsTime = 0
function ConnonGauge_FrameUpdate( deltaTime )
	elapsTime = elapsTime + deltaTime
	local nowPower	= ToClient_getCommonGauge()
	local maxPower	= ToClient_getMaxCommonGauge()
	local percent	= (nowPower / maxPower) * 100
	if 100 == math.floor(percent) then
		return
	end
	_txt_StaminaMax:SetText( string.format( "%d", math.ceil(percent) ) ) -- "기운\n".. string.format( "%d", percent ))
	progress:SetProgressRate( percent )
	progress:SetCurrentProgressRate( percent )
end


function FGlobal_CannonGauge_Open()
	-- FromClient_PowerGauge_onScreenResize()

	Panel_CannonGauge:SetShow( true )
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
end

function FGlobal_CannonGauge_Close()
	Panel_CannonGauge:SetShow( false )
end

function FromClient_CannonGauge_onScreenResize()
	-- Panel_CannonGauge:SetPosX( (getScreenSizeX()/2) - (Panel_CannonGauge:GetPosX() ) )
	-- Panel_CannonGauge:SetPosY( (getScreenSizeY()/2) - (Panel_CannonGauge:GetPosY() ) )
	Panel_CannonGauge:ComputePos()
end

registerEvent("onScreenResize", "FromClient_CannonGauge_onScreenResize" )
Panel_CannonGauge:RegisterUpdateFunc("ConnonGauge_FrameUpdate")
Panel_PowerGauge:SetShow( false )

local progress		= UI.getChildControl( Panel_PowerGauge, "Progress2_Gauge" )
local progressValue	= UI.getChildControl( Panel_PowerGauge, "StaticText_GaugeValue" )
local wp = 0

local elapsTime = 0
function PowerGauge_FrameUpdate( deltaTime )
	elapsTime = elapsTime + deltaTime
	local nowPower	= ToClient_getCommonGauge()
	local maxPower	= ToClient_getMaxCommonGauge()
	local percent	= (nowPower / maxPower) * 100

	if wp < math.floor(percent) or 100 == math.floor(percent) then
		return
	end
	
	progressValue:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_POWERGAUGE_PROGRESSVALUE", "percent", string.format( "%d", percent ) ) ) -- "기운\n".. string.format( "%d", percent ))
	progress:SetProgressRate( percent )
	progress:SetCurrentProgressRate( percent )
end


function FGlobal_PowerGauge_Open()
	FromClient_PowerGauge_onScreenResize()
	
	Panel_PowerGauge:SetShow( true )
	
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end	
	wp = selfPlayer:getWp()
	if 0 == wp then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_POWERGAUGE_NOPOWER") ) -- "기운이 없습니다.")
	end
end

function FGlobal_PowerGauge_Close()
	Panel_PowerGauge:SetShow( false )
end

function FromClient_PowerGauge_onScreenResize()
	Panel_PowerGauge:SetPosX( (getScreenSizeX()/2) - (Panel_PowerGauge:GetSizeX()*2.6) )
	Panel_PowerGauge:SetPosY( (getScreenSizeY()/2) - (Panel_PowerGauge:GetSizeY()/1.8) )
end

registerEvent("onScreenResize", "FromClient_PowerGauge_onScreenResize" )
Panel_PowerGauge:RegisterUpdateFunc("PowerGauge_FrameUpdate")
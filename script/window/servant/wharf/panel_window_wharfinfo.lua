Panel_Window_WharfInfo:SetShow(false, false)
Panel_Window_WharfInfo:setMaskingChild(true)
Panel_Window_WharfInfo:ActiveMouseEventEffect(true)
Panel_Window_WharfInfo:SetDragEnable( true )

Panel_Window_WharfInfo:RegisterShowEventFunc( true,		'WharfInfoShowAni()' )
Panel_Window_WharfInfo:RegisterShowEventFunc( false,	'WharfInfoHideAni()' )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

function	WharfInfoShowAni()
	Panel_Window_WharfInfo:SetShow(true, false)

	UIAni.fadeInSCR_Right(Panel_Window_WharfInfo)
	local aniInfo3 = Panel_Window_WharfInfo:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = false
end

function	WharfInfoHideAni()
	Panel_Window_WharfInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_WharfInfo:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)

	-- local aniInfo2 = Panel_Window_WharfInfo:addScaleAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	-- aniInfo2:SetStartScale(1.0)
	-- aniInfo2:SetEndScale(0.97)
	-- aniInfo2.AxisX = 200
	-- aniInfo2.AxisY = 295
	-- aniInfo2.IsChangeChild = true
end

local wharfInfo	=
{
	_staticName					= UI.getChildControl(Panel_Window_WharfInfo,	"StaticText_Name"),

	_staticText_GaugeBar_Hp		= UI.getChildControl(Panel_Window_WharfInfo,	"HP_GaugeBar"),
	_staticText_GaugeBar_Mp		= UI.getChildControl(Panel_Window_WharfInfo,	"MP_GaugeBar"),
	_staticText_GaugeBar_Weight	= UI.getChildControl(Panel_Window_WharfInfo,	"Weight_GaugeBar"),		-- 무게 바 추가
	
	_staticText_Hp				= UI.getChildControl( Panel_Window_WharfInfo,	"HP_Value" ),
	_staticText_Mp				= UI.getChildControl( Panel_Window_WharfInfo,	"MP_Value" ),
	_staticText_Weight			= UI.getChildControl( Panel_Window_WharfInfo,	"Weight_Value" ),

	_staticText_MoveSpeed		= UI.getChildControl(Panel_Window_WharfInfo,	"MaxMoveSpeedValue"),
	_staticText_Acceleration	= UI.getChildControl(Panel_Window_WharfInfo,	"AccelerationValue"),
	_staticText_Cornering		= UI.getChildControl(Panel_Window_WharfInfo,	"CorneringSpeedValue"),
	_staticText_BrakeSpeed		= UI.getChildControl(Panel_Window_WharfInfo,	"BrakeSpeedValue"),

	_deadCount					= UI.getChildControl(Panel_Window_WharfInfo,	"StaticText_DeadCount"),
	_deadCountValue				= UI.getChildControl(Panel_Window_WharfInfo,	"StaticText_DeadCountValue"),
}

----------------------------------------------------------------------------------------------------
-- Init
function	wharfInfo:init()

end

function	wharfInfo:update()
	local	servantInfo		= stable_getServant( WharfList_SelectSlotNo() )
	if	( nil == servantInfo )	then
		return
	end

	local Weight = servantInfo:getInventoryWeight_s64()
	local MaxWeight = servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000

	local GuageWeight = Int64toInt32(Weight)
	local GuageMaxWeight = Int64toInt32(MaxWeight)
	
	self._staticName:SetText( servantInfo:getName() )

	self._staticText_GaugeBar_Hp:SetSize( 250 / 100 * ( ( servantInfo:getHp() / servantInfo:getMaxHp() ) * 100 ) ,6 )
	self._staticText_GaugeBar_Mp:SetSize( 250 / 100 * (( servantInfo:getMp() / servantInfo:getMaxMp())*100)	,6 )
	self._staticText_GaugeBar_Weight:SetSize( 250 / 100 * ( ( GuageWeight / GuageMaxWeight ) * 100 ) ,6 )
	
	
	self._staticText_Hp:SetText(			makeDotMoney( servantInfo:getHp() ) .. " / " .. makeDotMoney(servantInfo:getMaxHp() )	)
	self._staticText_Mp:SetText(			makeDotMoney( servantInfo:getMp()).. " / " ..makeDotMoney(servantInfo:getMaxMp())		)
--	self._staticText_Weight:SetText(		tostring( servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000 )										)
	self._staticText_Weight:SetText(		makeDotMoney( Weight ) 	.. " / " .. makeDotMoney ( MaxWeight )							)

	
	self._staticText_MoveSpeed:SetText(		string.format( "%.1f",(servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed)		/ 10000))	.. "%"	) -- 속도
	self._staticText_Acceleration:SetText(	string.format( "%.1f",(servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration)		/ 10000))	.. "%"	) -- 가속도
	self._staticText_Cornering:SetText(		string.format( "%.1f",(servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed)	/ 10000))	.. "%"	) -- 코너링
	self._staticText_BrakeSpeed:SetText(	string.format( "%.1f",(servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed)		/ 10000))	.. "%"	) -- 브레이크		

	--죽은횟수
	local deadCount = servantInfo:getDeadCount()
	if servantInfo:doClearCountByDead() then
		deadCount = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", deadCount ) -- deadCount .. " (초기화 가능)"
	else
		deadCount = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", deadCount ) -- deadCount .. " (초기화 불가)"
	end

	if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
		self._deadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_KILLCOUNT") ) -- "죽은 횟수")
	elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage then
		self._deadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT") ) -- "파괴 횟수")
	elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
		self._deadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT") ) -- "파괴 횟수")
	end

	self._deadCountValue:SetText( deadCount )
end

function	wharfInfo:registEventHandler()
end

function	wharfInfo:registMessageHandler()
	registerEvent( "onScreenResize",				"WharfInfo_Resize" )
end

function	WharfInfo_Resize()
	-- screenX = getScreenSizeX()
	-- screenY = getScreenSizeY()

	Panel_Window_WharfInfo:SetSpanSize( 20, 30 )
	Panel_Window_WharfInfo:ComputePos()
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	WharfInfo_Open()
	local	self	= wharfInfo
	self:update()
	
	if	( Panel_Window_WharfInfo:GetShow() )	then
		return
	end

	Panel_Window_WharfInfo:SetShow(true)
end

function	WharfInfo_Close()
	if	( not Panel_Window_WharfInfo:GetShow() )	then
		return
	end
	
	Panel_Window_WharfInfo:SetShow(false)
end

----------------------------------------------------------------------------------------------------
-- Init
wharfInfo:init()
wharfInfo:registEventHandler()
wharfInfo:registMessageHandler()

WharfInfo_Resize()
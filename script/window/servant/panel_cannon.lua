local UCT			= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM			= CppEnums.TextMode
local UI_color 		= Defines.Color
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_Cannon:SetShow(false, false)
Panel_Cannon:RegisterShowEventFunc( true,	'CannonShowAni()' )
Panel_Cannon:RegisterShowEventFunc( false,	'CannonHideAni()' )

Panel_Cannon_Value_IsCannon = false

-------------------------------------------------
-- 변수 설정
-------------------------------------------------
local progresssBG			= UI.getChildControl( Panel_Cannon, "Cannon_ProgresssBG" )
local progresss				= UI.getChildControl( Panel_Cannon, "Progress2_1" )
local progresss_Head		= UI.getChildControl( progresss,	"Progress2_1_Bar_Head" )
local vehicle_actorKeyRaw	= 0

-------------------------------------------------
-- 조작 설명용 컨트롤 생성
-------------------------------------------------
local fireGuide_BG			= UI.getChildControl ( Panel_Cannon, "Static_CommandBG" )
local fireGuide_KeyShift1	= UI.getChildControl ( Panel_Cannon, "StaticText_Key_Shift1" )
local fireGuide_KeyShift2 	= UI.getChildControl ( Panel_Cannon, "StaticText_Key_Shift2" )
local fireGuide_KeyShift3 	= UI.getChildControl ( Panel_Cannon, "StaticText_Key_Shift3" )
local fireGuide_KeyShift4 	= UI.getChildControl ( Panel_Cannon, "StaticText_Key_Shift4" )
local fireGuide_KeyW 		= UI.getChildControl ( Panel_Cannon, "StaticText_Key_W" )
local fireGuide_KeyS	 	= UI.getChildControl ( Panel_Cannon, "StaticText_Key_S" )
local fireGuide_MouseL	 	= UI.getChildControl ( Panel_Cannon, "Static_Key_MouseL_0" )
local fireGuide_MouseR	 	= UI.getChildControl ( Panel_Cannon, "Static_Key_MouseR_0" )
local fireGuide_Text_Ready 	= UI.getChildControl ( Panel_Cannon, "StaticText_Ready" )
local fireGuide_Text_High 	= UI.getChildControl ( Panel_Cannon, "StaticText_HighAngle" )
local fireGuide_Text_Low 	= UI.getChildControl ( Panel_Cannon, "StaticText_LowAngle" )
local fireGuide_Text_Fire 	= UI.getChildControl ( Panel_Cannon, "StaticText_Fire" )

fireGuide_BG:AddChild( fireGuide_KeyShift1 )
fireGuide_BG:AddChild( fireGuide_KeyShift2 )
fireGuide_BG:AddChild( fireGuide_KeyShift3 )
fireGuide_BG:AddChild( fireGuide_KeyShift4 )
fireGuide_BG:AddChild( fireGuide_KeyW )
fireGuide_BG:AddChild( fireGuide_KeyS )
fireGuide_BG:AddChild( fireGuide_MouseL )
fireGuide_BG:AddChild( fireGuide_MouseR )
fireGuide_BG:AddChild( fireGuide_Text_Ready )
fireGuide_BG:AddChild( fireGuide_Text_High )
fireGuide_BG:AddChild( fireGuide_Text_Low )
fireGuide_BG:AddChild( fireGuide_Text_Fire )

Panel_Cannon:RemoveControl( fireGuide_KeyShift1 )
Panel_Cannon:RemoveControl( fireGuide_KeyShift2 )
Panel_Cannon:RemoveControl( fireGuide_KeyShift3 )
Panel_Cannon:RemoveControl( fireGuide_KeyShift4 )
Panel_Cannon:RemoveControl( fireGuide_KeyW )
Panel_Cannon:RemoveControl( fireGuide_KeyS )
Panel_Cannon:RemoveControl( fireGuide_MouseL )
Panel_Cannon:RemoveControl( fireGuide_MouseR )
Panel_Cannon:RemoveControl( fireGuide_Text_Ready )
Panel_Cannon:RemoveControl( fireGuide_Text_High )
Panel_Cannon:RemoveControl( fireGuide_Text_Low )
Panel_Cannon:RemoveControl( fireGuide_Text_Fire )


function CannonShowAni()
	local aniInfo1 = Panel_Cannon:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.05)
	aniInfo1.AxisX = Panel_Cannon:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Cannon:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Cannon:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.05)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Cannon:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Cannon:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function CannonHideAni()
	Panel_Cannon:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Cannon:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

-------------------------------------------------
-- 초기화
-------------------------------------------------
local Cannon_Initialize = function()
	Panel_Cannon:SetPosX( (getScreenSizeX() / 2) - (Panel_Cannon:GetSizeX() / 2) - 240 )
	Panel_Cannon:SetPosY( (getScreenSizeY() / 2) )
	progresssBG:SetShow( true )
	progresss:SetShow( true )
	progresss:SetProgressRate( 100 )
	progresss:SetCurrentProgressRate( 100 )
	progresss_Head:SetShow( false )
	progresss:SetAniSpeed(0)

	fireGuide_BG:			SetPosX( (Panel_Cannon:GetSizeX() / 2) + 400 )

	fireGuide_KeyShift1:	SetPosX( 10 )
	fireGuide_KeyShift2:	SetPosX( 10 )
	fireGuide_KeyShift3:	SetPosX( 10 )
	fireGuide_KeyShift4:	SetPosX( 10 )
	fireGuide_KeyW:			SetPosX( 65 )
	fireGuide_KeyS:			SetPosX( 65 )
	fireGuide_MouseL:		SetPosX( 65 )
	fireGuide_MouseR:		SetPosX( 81 )
	fireGuide_Text_Ready:	SetPosX( 70 )
	fireGuide_Text_High:	SetPosX( 100 )
	fireGuide_Text_Low:		SetPosX( 100 )
	fireGuide_Text_Fire:	SetPosX( 112 )

	fireGuide_KeyShift1:	SetFontColor( 4294312447 )
	fireGuide_KeyShift2:	SetFontColor( 4294312447 )
	fireGuide_KeyShift3:	SetFontColor( 4294312447 )
	fireGuide_KeyShift4:	SetFontColor( 4294312447 )
	fireGuide_KeyW:			SetFontColor( 4294312447 )
	fireGuide_KeyS:			SetFontColor( 4294312447 )
	-- fireGuide_MouseL:		SetFontColor( 4294312447 )
	-- fireGuide_MouseR:		SetFontColor( 4294312447 )
end

-------------------------------------------------
-- 업데이트
-------------------------------------------------
local nowCool = 0
local cannon = {}
function FromClient_Cannon_ProgressUpdate()
	if 0 == vehicle_actorKeyRaw then
		return
	end
	cannon = getVehicleActor( vehicle_actorKeyRaw )
	if CppEnums.VehicleType.Type_Cannon == cannon:get():getVehicleType() then
		local mp			= cannon:get():getMp()
		local maxMp			= cannon:get():getMaxMp()
		local nowCoolTime	= (mp / maxMp * 100)
		--if nowCool < mp then
			--progresss:SetAniSpeed(20)
		--else
			progresss:SetAniSpeed(0.5)
		--end
		--nowCool = mp
		progresss:SetProgressRate( nowCoolTime )
	else
		return
	end
end


-------------------------------------------------
-- 가이드 온오프
-------------------------------------------------
function Cannon_GuideShow( show )
	if show == fireGuide_BG:GetShow() then
		return
	end
	fireGuide_BG:SetShow( show )
	fireGuide_KeyShift1:SetShow( show )
	fireGuide_KeyShift2:SetShow( show )
	fireGuide_KeyShift3:SetShow( show )
	fireGuide_KeyShift4:SetShow( show )
	fireGuide_KeyW:SetShow( show )
	fireGuide_KeyS:SetShow( show )
	fireGuide_MouseL:SetShow( show )
	fireGuide_MouseR:SetShow( show )
	fireGuide_Text_Ready:SetShow( show )
	fireGuide_Text_High:SetShow( show )
	fireGuide_Text_Low:SetShow( show )
	fireGuide_Text_Fire:SetShow( show )
end

-------------------------------------------------
-- 온오프
-------------------------------------------------
function FromClient_Cannon_Show( actorKeyRaw )
	if Panel_Cannon:GetShow() then
		return
	end
	Cannon_Initialize()
	vehicle_actorKeyRaw = actorKeyRaw
	if CppEnums.VehicleType.Type_Cannon == getVehicleActor(vehicle_actorKeyRaw):get():getVehicleType() then
		Panel_Cannon:SetShow( true, true )
		Panel_Cannon_Value_IsCannon = true
		cannon				= getVehicleActor( vehicle_actorKeyRaw )
		local mp			= cannon:get():getMp()
		local maxMp			= cannon:get():getMaxMp()
		local nowCoolTime	= (mp / maxMp * 100)
		-- if mp == maxMp then
			--progresss:SetCurrentProgressRate( nowCoolTime )
			progresss:SetProgressRate( nowCoolTime )
			
		-- end
		--nowCool = mp
		Cannon_GuideShow( true )
	else
		return
	end
end
function FromClient_Cannon_Hide()
	if not Panel_Cannon:GetShow() then
		return
	end
	Cannon_GuideShow( false )
	Panel_Cannon:SetShow( false, false )
	FGlobal_CannonGauge_Close()
	Panel_Cannon_Value_IsCannon = false
end

Cannon_Initialize()

registerEvent("EventSelfPlayerRideOn",			"FromClient_Cannon_Show")					-- 대포에 붙었다.
registerEvent("EventSelfPlayerRideOff",			"FromClient_Cannon_Hide")					-- 대포에서 떨어졌다.
registerEvent("FromClient_RideVehicleMpUpdate",	"FromClient_Cannon_ProgressUpdate")		-- 대포의 MP가 변한다.
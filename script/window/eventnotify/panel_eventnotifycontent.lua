local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_EventNotifyContent:SetShow( false )
Panel_EventNotifyContent:setGlassBackground( true )
Panel_EventNotifyContent:ActiveMouseEventEffect( true )

Panel_EventNotifyContent:RegisterShowEventFunc( true, 'Panel_EventNotifyContent_ShowAni()' )
Panel_EventNotifyContent:RegisterShowEventFunc( false, 'Panel_EventNotifyContent_HideAni()' )

local isBeforeShow = false

function Panel_EventNotifyContent_ShowAni()
	UIAni.fadeInSCR_Down( Panel_EventNotifyContent )
	
	local aniInfo1 = Panel_EventNotifyContent:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_EventNotifyContent:GetSizeX() / 2
	aniInfo1.AxisY = Panel_EventNotifyContent:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_EventNotifyContent:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_EventNotifyContent:GetSizeX() / 2
	aniInfo2.AxisY = Panel_EventNotifyContent:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_EventNotifyContent_HideAni()
	Panel_EventNotifyContent:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_EventNotifyContent, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local _btn_Close 		= UI.getChildControl( Panel_EventNotifyContent,	"Button_Close" )
local _Web 				= nil
local isShowEventNotifyContent = false
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--					최초 초기화 함수
------------------------------------------------------------
function Panel_EventNotifyContent_Initialize()
	_Web		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_EventNotifyContent, 'WebControl_EventNotifyContent_WebLink' )
	_Web:SetShow( true )
	_Web:SetPosX( 43 )
	_Web:SetPosY( 63 )
	_Web:SetSize( 817, 600 )
	_Web:ResetUrl()

	Panel_EventNotifyContent:SetSize( 905, 700 )
end
Panel_EventNotifyContent_Initialize()

------------------------------------------------------------
--						오픈
------------------------------------------------------------
function FGlobal_EventNotifyContent_Open( eventIndex )
	-- ♬ 창이 켜질 때 소리
	audioPostEvent_SystemUi(13,06)
	local url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL", "index", eventIndex )		-- "http://dev.pub.game.daum.net/black/internal/event/view.daum?id=" .. eventIndex

	_Web:SetSize( 817, 600 )
	_Web:SetUrl( 817, 600, url )

	Panel_EventNotifyContent:SetPosX( (getScreenSizeX()/2) - (Panel_EventNotifyContent:GetSizeX()/2) )
	Panel_EventNotifyContent:SetPosY( (getScreenSizeY()/2) - (Panel_EventNotifyContent:GetSizeY()/2) )
	Panel_EventNotifyContent:SetShow( true, true )

	SetUIMode( Defines.UIMode.eUIMode_EventNotify )
end

function EventNotifyContent_Close()
	_Web:ResetUrl()
	-- ♬ 창이 꺼질 때 소리
	audioPostEvent_SystemUi(13,05)
	Panel_EventNotifyContent:SetShow( false, false )
end

-- function FGlobal_EventNotifyContentClose()
-- 	EventNotifyContent_Close()
-- end

function HandleClicked_EventNotifyContent_Close()
	EventNotifyContent_Close()
	SetUIMode( Defines.UIMode.eUIMode_Default )	-- X버튼을 누를 수도 있으므로
end

registerEvent( "FromWeb_ExecuteLuaFuncByEvent", "FGlobal_EventNotifyContent_Open" )

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
_btn_Close			:addInputEvent( "Mouse_LUp", "HandleClicked_EventNotifyContent_Close()" )
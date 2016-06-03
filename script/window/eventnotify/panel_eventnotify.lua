local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode

Panel_EventNotify:SetShow( false )
Panel_EventNotify:setGlassBackground( true )
Panel_EventNotify:ActiveMouseEventEffect( true )

Panel_EventNotify:RegisterShowEventFunc( true, 'Panel_EventNotify_ShowAni()' )
Panel_EventNotify:RegisterShowEventFunc( false, 'Panel_EventNotify_HideAni()' )

btnClose = UI.getChildControl( Panel_EventNotify, "Button_Close" )
btnClose:addInputEvent( "Mouse_LUp", "HandleClicked_EventNotify_Close()" )

function Panel_EventNotify_ShowAni()
	UIAni.fadeInSCR_Down( Panel_EventNotify )
	
	local aniInfo1 = Panel_EventNotify:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_EventNotify:GetSizeX() / 2
	aniInfo1.AxisY = Panel_EventNotify:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_EventNotify:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_EventNotify:GetSizeX() / 2
	aniInfo2.AxisY = Panel_EventNotify:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_EventNotify_HideAni()
	Panel_EventNotify:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_EventNotify, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

function Panel_EventNotify_Initialize()
	_Web		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_EventNotify, 'WebControl_EventNotify_WebLink' )
	_Web:SetShow( true )
	_Web:SetPosX( 42 )
	_Web:SetPosY( 68 )
	_Web:SetSize( 636, 494 )
	_Web:ResetUrl()
end
Panel_EventNotify_Initialize()
------------------------------------------------------------
--						오픈
------------------------------------------------------------
function EventNotify_Open( isDo, isMenu )
	if not ToClient_IsPopUpToggle() then
		return
	end
	tempWrapper = getTemporaryInformationWrapper()
	if tempWrapper:isEventBeforeShow() and nil == isDo then
		return
	end
	
	if ( isGameTypeJapan() or isGameTypeRussia() ) then
		return
	end
	
	-- 튜토리얼을 완료하지 않은 쪼렙은 접속 시 이벤트창을 띄우지 않는다!
	if ( not TutorialQuestCompleteCheck() and not isMenu ) then
		return
	end
	
	-- ♬ 창이 켜질 때 소리
	audioPostEvent_SystemUi(13,06)

	Panel_EventNotify:SetPosX( (getScreenSizeX()/2) - (Panel_EventNotify:GetSizeX()/2) )
	Panel_EventNotify:SetPosY( (getScreenSizeY()/2) - (Panel_EventNotify:GetSizeY()/2) )
	Panel_EventNotify:SetShow( true, true )
	-- tempWrapper:setEventBeforeShow(true)
	
	local url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL" )	-- "http://dev.pub.game.daum.net/black/internal/event/index.daum"

	_Web:SetSize( 636, 494 )
	_Web:SetUrl( 636, 494, url )
end

function EventNotify_Close()
	-- ♬ 창이 꺼질 때 소리
	audioPostEvent_SystemUi(13,05)
	Panel_EventNotify:SetShow( false, false )
	_Web:ResetUrl()
	
	if not tempWrapper:isEventBeforeShow() then
		DailyStamp_ShowToggle()
		tempWrapper:setEventBeforeShow(true)
	else
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
	end
end

function FGlobal_EventNotifyClose()
	EventNotify_Close()
end

function HandleClicked_EventNotify_Close()
	EventNotify_Close()
end

function HandleClicked_EventNotify_Next()
	EventNotify_Close()
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
registerEvent("FromClient_LoadCompleteMsg",				"EventNotify_Open")
--EventNotify_Open()
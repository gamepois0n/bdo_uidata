local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Panel_PvpMode:SetShow(false, false)

Panel_PvpMode:RegisterShowEventFunc( true, 'pvpModeShowAni()' )
Panel_PvpMode:RegisterShowEventFunc( false, 'pvpModeHideAni()' )

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

local pvpText = UI.getChildControl ( Panel_PvpMode, "StaticText_pvpText" )
local _bubbleNotice = UI.getChildControl ( Panel_PvpMode, "StaticText_Notice" )

_pvpButton = UI.getChildControl ( Panel_PvpMode, "CheckButton_PvpButton" )
--_pvpButton:AddEffect("LightEffect", true, 0.0, 0.0)
--_pvpButton:AddEffect("LightEffect", true, 100.0, 100.0)
--_pvpButton:EraseAllEffect()
_pvpButton:addInputEvent("Mouse_LUp", "requestTogglePvP()")
_pvpButton:addInputEvent("Mouse_On",  "PvpMode_ButtonOver(true)" )
_pvpButton:addInputEvent("Mouse_Out", "PvpMode_ButtonOver(false)" )
Panel_PvpMode:addInputEvent( "Mouse_On", "Panel_PvpMode_ChangeTexture_On()" )
Panel_PvpMode:addInputEvent( "Mouse_Out", "Panel_PvpMode_ChangeTexture_Off()" )
-- Panel_PvpMode:addInputEvent( "Mouse_PressMove", "PvpModeButton_RefreshPosition()" )	
Panel_PvpMode:addInputEvent( "Mouse_LUp", "ResetPos_WidgetButton()" )			--메인UI위젯 위치 초기화

Panel_PvpMode:SetPosX( Panel_MainStatus_User_Bar:GetPosX() - 20 )
Panel_PvpMode:SetPosY( Panel_MainStatus_User_Bar:GetPosY() + Panel_MainStatus_User_Bar:GetSizeY() - 47 )

posX = Panel_PvpMode:GetPosX()
posY = Panel_PvpMode:GetPosY()
	
local isPvPOn = true
local PvPOnCount  = 0
local prePvp = false
local calculateTime = 0

function Panel_PvpMode_ChangeTexture_On()
	-- ♬ 마우스 올렸을 때 사운드 추가
	audioPostEvent_SystemUi(00,10)
	
	Panel_PvpMode:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
	pvpText:SetText ( PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI_MOVE") )	--"PVP 활성화\n드래그해서 옮기세요.")
end
function Panel_PvpMode_ChangeTexture_Off()
	-- ♬ 마우스 뺐을 때 사운드 추가
	if Panel_UIControl:IsShow() then
		Panel_PvpMode:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
		pvpText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PVPMODE_UI") )	-- "PVP 활성화"
	else
		Panel_PvpMode:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	end
end

-- 켜주는 애니
function pvpModeShowAni()
	Panel_PvpMode:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local PvPModeOpen_Alpha = Panel_PvpMode:addColorAnimation( 0.0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	PvPModeOpen_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	PvPModeOpen_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	PvPModeOpen_Alpha.IsChangeChild = true
end

-- 꺼주는 애니
function pvpModeHideAni()
	Panel_PvpMode:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local PvPModeClose_Alpha = Panel_PvpMode:addColorAnimation( 0.0, 0.6, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	PvPModeClose_Alpha:SetStartColor( UI_color.C_FFFFFFFF )
	PvPModeClose_Alpha:SetEndColor( UI_color.C_00FFFFFF )
	PvPModeClose_Alpha.IsChangeChild = true
	PvPModeClose_Alpha:SetHideAtEnd(true)
	PvPModeClose_Alpha:SetDisableWhileAni(true)
end

function Panel_PvpMode_ShowToggle()
	local isShow = Panel_PvpMode:IsShow()
	if isShow == true then
		Panel_PvpMode:SetShow ( false, false )
	else
		Panel_PvpMode:SetShow ( true, true )
	end
end

function Panel_PvpMode_EnableSimpleUI()
	pvpText			:SetAlpha( Panel_MainStatus_User_Bar:GetAlpha() );
	_pvpButton		:SetAlpha( Panel_MainStatus_User_Bar:GetAlpha() );
	_bubbleNotice	:SetAlpha( Panel_MainStatus_User_Bar:GetAlpha() );
end
function Panel_PvpMode_DisableSimpleUI()
	pvpText			:SetAlpha( 1.0 );
	_pvpButton		:SetAlpha( 1.0 );
	_bubbleNotice	:SetAlpha( 1.0 );
end
function Panel_PvpMode_UpdateSimpleUI( fDeltaTime )
	pvpText			:SetAlpha( Panel_MainStatus_User_Bar:GetAlpha() );
	_pvpButton		:SetAlpha( Panel_MainStatus_User_Bar:GetAlpha() );
	_bubbleNotice	:SetAlpha( Panel_MainStatus_User_Bar:GetAlpha() );
end
registerEvent( "SimpleUI_UpdatePerFrame",		"Panel_PvpMode_UpdateSimpleUI")
registerEvent( "EventSimpleUIEnable",			"Panel_PvpMode_EnableSimpleUI")
registerEvent( "EventSimpleUIDisable",			"Panel_PvpMode_DisableSimpleUI")

-- 위젯 위치값 저장
function PvpModeButton_RefreshPosition()
	pvpText.posX = Panel_PvpMode:GetPosX()
	pvpText.posY = Panel_PvpMode:GetPosY()
	_bubbleNotice.posX = Panel_PvpMode:GetPosX()
	_bubbleNotice.posY = Panel_PvpMode:GetPosY()
	_pvpButton.posX = Panel_PvpMode:GetPosX()
	_pvpButton.posY = Panel_PvpMode:GetPosY()
end

function pvpMode_changedMode( actorKeyRaw )
	FromClient_PvpMode_changeMode( nil, actorKeyRaw )
end

function pvpMode_changedMode1( actorKeyRaw )
	if nil ~= actorKeyRaw then
		FromClient_PvpMode_changeMode( nil, actorKeyRaw )
	end
end

function FromClient_PvpMode_changeMode( where, actorKeyRaw )
	if nil ~= actorKeyRaw then
		local actorProxyWrapper = getActor(actorKeyRaw)
		if ( nil == actorProxyWrapper ) then
			return
		end
		
		if not actorProxyWrapper:get():isSelfPlayer() then		-- 자기가 아니면 리턴
			return
		end
	end
	
	if isPvpEnable() and (false == isFlushedUI()) then
		Panel_PvpMode:SetShow( true, true )
		if getPvPMode() then
			-- ♬ PVP 버튼을 눌렀을 때 사운드 펑!
			audioPostEvent_SystemUi(00,09)
			audioPostEvent_SystemUi(09,00)
			
			-- _pvpButton:SetCheck(true)
			_pvpButton:EraseAllEffect()
			_pvpButton:AddEffect("fUI_SkillButton02", false, 0, 0)
			_pvpButton:AddEffect("fUI_PvPButtonLoop", false, 0, 0)
			if nil == where then
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PVP_BUTTON_ON") )
			end

			isPvPOn = true
		elseif (isPvPOn) then
			-- ♬ PVP 버튼을 눌러서 껐을 때 사운드 슝
			audioPostEvent_SystemUi(00,11)
			
			-- _pvpButton:SetCheck(false)
			_pvpButton:EraseAllEffect()
			
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PVP_BUTTON_OFF") )
			isPvPOn = false
		end
		
		FGlobal_MainStatus_FadeIn( 5.0 );
		-- widgetControlButtonFunction(6)
		changePositionBySever(Panel_PvpMode, CppEnums.PAGameUIType.PAGameUIPanel_PvpMode, true, true, false)
	else
		--Panel_PvpMode:SetShow( false, true )
	end
end

function PvpMode_ButtonOver(isON)
	if isON then
		-- _bubbleNotice:SetPosX(_pvpButton:GetPosX() - _pvpButton:GetPosX() - 66)
		-- _bubbleNotice:SetPosY(45)
		-- _bubbleNotice:SetShow(true)
	else
		-- _bubbleNotice:SetShow(false)
	end
end

function PvpMode_PlayerPvPAbleChanged(actorKeyRaw)
	local selfWrapper = getSelfPlayer()
	if ( nil == selfWrapper ) then
		return
	end
	if ( selfWrapper:getActorKey() == actorKeyRaw ) then
		-- 2번 메시지가 나오지 않도록 nil이 아닌 값을 넣는다.
		FromClient_PvpMode_changeMode( selfWrapper )
	end
end


function PvpMode_Resize()
	Panel_PvpMode:SetPosX( Panel_MainStatus_User_Bar:GetPosX() - 20 )
	Panel_PvpMode:SetPosY( Panel_MainStatus_User_Bar:GetPosY() + Panel_MainStatus_User_Bar:GetSizeY() - 47 )

	if isPvpEnable() then
		-- Panel_PvpMode:SetShow( true, true )
		changePositionBySever(Panel_PvpMode, CppEnums.PAGameUIType.PAGameUIPanel_PvpMode, true, true, false)
	else
		Panel_PvpMode:SetShow( false, false )
	end
end

-- 게임모드 변경에 따라 PVP 활성화를 체크하지 않도록 주석처리.
-- local postRestorEvent = function()
-- 	pvpMode_changedMode()
-- end
-- UI.addRunPostRestorFunction( postRestorEvent )

registerEvent("EventPvPModeChanged",		"pvpMode_changedMode1")
registerEvent("EventPlayerPvPAbleChanged",	"PvpMode_PlayerPvPAbleChanged" )

registerEvent("onScreenResize",	"PvpMode_Resize" )

Panel_Adrenallin:SetShow( false )

-- local isUserOff = false
local ui = {
	_adCircleProgress = UI.getChildControl( Panel_Adrenallin, "CircularProgress_Adrenallin" ),
	_txt_Adrenallin = UI.getChildControl( Panel_Adrenallin, "StaticText_AdPercent" ),
}
local _close_Adrenallin = UI.getChildControl ( Panel_Adrenallin, "Button_Win_Close" )
_close_Adrenallin:SetShow(false)

local prevAdrenallin = 0;
function adrenallin_Update()
	local selfPlayer = getSelfPlayer()
	local adrenallin = selfPlayer:getAdrenalin()
	
	ui._adCircleProgress:SetProgressRate( adrenallin )
	ui._txt_Adrenallin:SetText( tostring(adrenallin) .. "%" )
	
	if ( prevAdrenallin ~= adrenallin ) then
		FGlobal_MainStatus_FadeIn( 5.0 );
	end
	prevAdrenallin = adrenallin;
end


function Panel_adrenallin_EnableSimpleUI()
	Panel_adrenallin_SetAlphaAllChild( Panel_MainStatus_User_Bar:GetAlpha() );
end
function Panel_adrenallin_DisableSimpleUI()
	Panel_adrenallin_SetAlphaAllChild( 1.0 );
end
function Panel_adrenallin_UpdateSimpleUI( fDeltaTime )
	Panel_adrenallin_SetAlphaAllChild( Panel_MainStatus_User_Bar:GetAlpha() );
end
function Panel_adrenallin_SetAlphaAllChild( alphaValue )
	Panel_Adrenallin			:SetAlpha( alphaValue );
	ui._adCircleProgress		:SetAlpha( alphaValue );
	ui._txt_Adrenallin			:SetFontAlpha( alphaValue );
end
registerEvent( "SimpleUI_UpdatePerFrame",		"Panel_adrenallin_UpdateSimpleUI")
registerEvent( "EventSimpleUIEnable",			"Panel_adrenallin_EnableSimpleUI")
registerEvent( "EventSimpleUIDisable",			"Panel_adrenallin_DisableSimpleUI")


function FromClient_UpdateAdrenalin()
	local selfPlayer = getSelfPlayer()
	
	if nil == selfPlayer then
		return
	end

	changePositionBySever(Panel_Adrenallin, CppEnums.PAGameUIType.PAGameUIPanel_Adrenallin, false, true, false)
	Panel_Adrenallin:SetShow( getSelfPlayer():isEnableAdrenalin() )
	adrenallin_Update()
end

function FromClient_ChangeAdrenalinMode()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end

	adrenallin_Update()											-- 할 수 있다면, 업데이트는 먼저 한다.

	if not isLuaLoadingComplete then							-- lua 로딩이 끝나지 않았으면 리턴
		return
	else
		if Defines.UIMode.eUIMode_Default ~= GetUIMode() then	-- 게임 모드가 아니라면 리턴(커마 등에서 나오지 않아야 함)
			return
		end
	end

	changePositionBySever(Panel_Adrenallin, CppEnums.PAGameUIType.PAGameUIPanel_Adrenallin, false, true, false)
	Panel_Adrenallin:SetShow( getSelfPlayer():isEnableAdrenalin() )
end

function Adrenallin_ShowSimpleToolTip( isShow )
	name = PAGetString(Defines.StringSheet_GAME, "LUA_ADRENALLIN_TOOLTIP_TITLE") -- "흑정령의 분노"
	desc = PAGetString(Defines.StringSheet_GAME, "LUA_ADRENALLIN_TOOLTIP_DESC") -- "흑정령의 분노를 사용하면 더욱 강력한 힘을 발휘할 수 있다. 35레벨부터 가능."
	uiControl = Panel_Adrenallin

	if isShow == true then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function Panel_Adrenallin_ChangeTexture_On()
	Panel_Adrenallin:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
	_close_Adrenallin:SetShow( true )
end
function Panel_Adrenallin_ChangeTexture_Off()
	_close_Adrenallin:SetShow( false )
	if Panel_UIControl:IsShow() then
		Panel_Adrenallin:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
	else
		Panel_Adrenallin:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	end
end


-- { 플러시가 끝날 때 다시 실행한다.
	function check_Adrenallin_PostEvent()
		FromClient_ChangeAdrenalinMode()
	end
	UI.addRunPostRestorFunction( check_Adrenallin_PostEvent )
-- }

function Panel_Adrenallin_OnSreenResize()
	Panel_Adrenallin:SetPosX( (getScreenSizeX()/2) - (Panel_Adrenallin:GetSizeX()/2) + 225 )
	Panel_Adrenallin:SetPosY( getScreenSizeY() - Panel_QuickSlot:GetSizeY() - 76 )

	changePositionBySever(Panel_Adrenallin, CppEnums.PAGameUIType.PAGameUIPanel_Adrenallin, false, true, false)
	Panel_Adrenallin:SetShow( getSelfPlayer():isEnableAdrenalin() )
end

FromClient_UpdateAdrenalin()
FromClient_ChangeAdrenalinMode()


Panel_Adrenallin:addInputEvent( "Mouse_On",		"Panel_Adrenallin_ChangeTexture_On()" )
Panel_Adrenallin:addInputEvent( "Mouse_Out",	"Panel_Adrenallin_ChangeTexture_Off()" )
Panel_Adrenallin:addInputEvent( "Mouse_On",		"Adrenallin_ShowSimpleToolTip( true )" )
Panel_Adrenallin:addInputEvent( "Mouse_Out",	"Adrenallin_ShowSimpleToolTip( false ) ")

registerEvent("FromClient_UpdateAdrenalin",		"FromClient_UpdateAdrenalin")
registerEvent("FromClient_ChangeAdrenalinMode",	"FromClient_ChangeAdrenalinMode")
registerEvent("onScreenResize",					"Panel_Adrenallin_OnSreenResize")

function Panel_Adrenallin_InitShow()
	changePositionBySever(Panel_Adrenallin, CppEnums.PAGameUIType.PAGameUIPanel_Adrenallin, false, true, false)
	Panel_Adrenallin:SetShow( getSelfPlayer():isEnableAdrenalin() )
end
Panel_Adrenallin_InitShow()
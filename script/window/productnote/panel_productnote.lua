local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local preUIMode		= Defines.UIMode.eUIMode_Default
local IM			= CppEnums.EProcessorInputMode

Panel_ProductNote:SetShow( false, false )
Panel_ProductNote:ActiveMouseEventEffect( true )
Panel_ProductNote:setGlassBackground( true )

Panel_ProductNote:RegisterShowEventFunc( true, 'Panel_ProductNote_ShowAni()' )
Panel_ProductNote:RegisterShowEventFunc( false, 'Panel_ProductNote_HideAni()' )
-----------------------------------------------------------
--					창 애니메이션 처리
-----------------------------------------------------------
function Panel_ProductNote_ShowAni()
	-- Panel_ProductNote:SetShow(true)
	-- Panel_ProductNote:SetAlpha( 0 )
	UIAni.fadeInSCR_Down( Panel_ProductNote )
	
	local aniInfo1 = Panel_ProductNote:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_ProductNote:GetSizeX() / 2
	aniInfo1.AxisY = Panel_ProductNote:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_ProductNote:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_ProductNote:GetSizeX() / 2
	aniInfo2.AxisY = Panel_ProductNote:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_ProductNote_HideAni()
	Panel_ProductNote:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_ProductNote, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local _btn_Close 		= UI.getChildControl ( Panel_ProductNote, "Button_Close" )
local _btn_CloseWindow 	= UI.getChildControl ( Panel_ProductNote, "Button_CloseWindow" )

local 	_buttonQuestion = UI.getChildControl( Panel_ProductNote, "Button_Question" )								-- 물음표 버튼
	_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ProductNote\" )" )				-- 물음표 좌클릭
	_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"ProductNote\", \"true\")" )		-- 물음표 마우스오버
	_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"ProductNote\", \"false\")" )		-- 물음표 마우스아웃

local _productWeb 		= nil
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--					최초 초기화 함수
------------------------------------------------------------
function Panel_ProductNote_Initialize()
	_productWeb		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_ProductNote, 'WebControl_ProductNote' )
	_productWeb:SetShow( true )
	_productWeb:SetPosX( 43 )
	_productWeb:SetPosY( 63 )
	_productWeb:SetSize( 700, 558 )
	_productWeb:ResetUrl()
end

Panel_ProductNote_Initialize()
------------------------------------------------------------
--						SHOW TOGGLE
------------------------------------------------------------
function Panel_ProductNote_ShowToggle( )
	local isShow = Panel_ProductNote:IsShow()
	if ( isShow == true ) then
		FGlobal_ClearCandidate()
		_productWeb:ResetUrl()
		-- ♬ 창이 꺼질 때 소리
		audioPostEvent_SystemUi(13,05)
		Panel_ProductNote:SetShow( false, false )
		ClearFocusEdit();
		--SetUIMode( preUIMode )		-- 모드가 안바껴서 주석처리. 모드가 필요한 이유를 모르겠음
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		return false;
	else
		-- ♬ 창이 켜질 때 소리
		audioPostEvent_SystemUi(13,06)
		Panel_ProductNote:SetShow( true, true )
		FGlobal_SetCandidate()
		--_productWeb:SetUrl(1015, 586, "http://bbs.black.game.daum.net/gaia/do/black/free/list?bbsId=BDT001")
		--_productWeb:SetUrl(1015, 586, "coui://UI_Data/UI_Html/Window/ProductNote/ProductNote.html?"..itemKey)
		_productWeb:SetUrl(700, 558, "coui://UI_Data/UI_Html/Window/ProductNote/ProductNote_CategoryItemList.html?nodeProduct")
		_productWeb:SetIME(true)
		--preUIMode = GetUIMode()
--		SetUIMode( Defines.UIMode.eUIMode_ProductNote )

		return true;
	end

	return true;
end

function Panel_ProductNoteClose()

end

function ProductNote_Item_ShowToggle( itemKey )
	--local isShow = Panel_ProductNote:IsShow()		-- 인벤창에서 재료 우클릭하는 경우 내용만 바꿔주기 위해 구문 삭제	
	if ( isShow == true ) then
		FGlobal_ClearCandidate()
		_productWeb:ResetUrl()
		-- ♬ 창이 꺼질 때 소리
		audioPostEvent_SystemUi(13,05)
		Panel_ProductNote:SetShow( false, false )
		if( AllowChangeInputMode() ) then
			ClearFocusEdit();
			UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode)
		else
			SetFocusChatting();
		end
--		SetUIMode( preUIMode )
	else
		-- ♬ 창이 켜질 때 소리
		audioPostEvent_SystemUi(13,06)
		Panel_ProductNote:SetShow( true, true )
		FGlobal_SetCandidate()
		_productWeb:SetUrl(700, 558, "coui://UI_Data/UI_Html/Window/ProductNote/ProductNote_CategoryItemList.html?manufacture&"..itemKey)
		_productWeb:SetIME(true)
--		preUIMode = GetUIMode()
--		SetUIMode( Defines.UIMode.eUIMode_ProductNote )
	end
end

function ProductNote_onScreenResize()
	Panel_ProductNote:SetPosX( math.floor((getScreenSizeX() - Panel_ProductNote:GetSizeX()) / 2) )
	Panel_ProductNote:SetPosY( math.floor((getScreenSizeY() - Panel_ProductNote:GetSizeY()) / 2) )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
_btn_Close:addInputEvent( "Mouse_LUp", "Panel_ProductNote_ShowToggle()" )
_btn_CloseWindow:addInputEvent( "Mouse_LUp", "Panel_ProductNote_ShowToggle()" )

registerEvent("onScreenResize", 		"ProductNote_onScreenResize" )
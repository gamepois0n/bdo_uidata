local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local preUIMode		= Defines.UIMode.eUIMode_InGameCashShop

Panel_QnAWebLink:SetShow( false, false )
Panel_QnAWebLink:ActiveMouseEventEffect( true )
Panel_QnAWebLink:setGlassBackground( true )

Panel_QnAWebLink:RegisterShowEventFunc( true, 'Panel_QnAWebLink_ShowAni()' )
Panel_QnAWebLink:RegisterShowEventFunc( false, 'Panel_QnAWebLink_HideAni()' )

local eCountryType		= CppEnums.CountryType
local gameServiceType	= getGameServiceType()
local isKorea			= (eCountryType.NONE == gameServiceType) or (eCountryType.DEV == gameServiceType) or (eCountryType.KOR_ALPHA == gameServiceType) or (eCountryType.KOR_REAL == gameServiceType) or (eCountryType.KOR_TEST == gameServiceType)
local isNaver			= ( CppEnums.MembershipType.naver == getMembershipType() )

-----------------------------------------------------------
--					창 애니메이션 처리
-----------------------------------------------------------
function Panel_QnAWebLink_ShowAni()
	-- Panel_QnAWebLink:SetShow(true)
	-- Panel_QnAWebLink:SetAlpha( 0 )
	UIAni.fadeInSCR_Down( Panel_QnAWebLink )
	
	local aniInfo1 = Panel_QnAWebLink:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_QnAWebLink:GetSizeX() / 2
	aniInfo1.AxisY = Panel_QnAWebLink:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_QnAWebLink:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_QnAWebLink:GetSizeX() / 2
	aniInfo2.AxisY = Panel_QnAWebLink:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_QnAWebLink_HideAni()
	Panel_QnAWebLink:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_QnAWebLink, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local _btn_Close 		= UI.getChildControl ( Panel_QnAWebLink, "Button_Close" )
local _btn_CloseWindow 	= UI.getChildControl ( Panel_QnAWebLink, "Button_CloseWindow" )

local 	_buttonQuestion = UI.getChildControl( Panel_QnAWebLink, "Button_Question" )								-- 물음표 버튼
	-- _buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ProductNote\" )" )				-- 물음표 좌클릭
	-- _buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"ProductNote\", \"true\")" )		-- 물음표 마우스오버
	-- _buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"ProductNote\", \"false\")" )		-- 물음표 마우스아웃

local _qnaWeb 		= nil
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--					최초 초기화 함수
------------------------------------------------------------
function Panel_QnAWebLink_Initialize()
	_qnaWeb		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_QnAWebLink, 'WebControl_QnAWebLink' )
	_qnaWeb:SetShow( true )
	_qnaWeb:SetPosX( 43 )
	_qnaWeb:SetPosY( 63 )
	_qnaWeb:SetSize( 1015, 586 )
	_qnaWeb:ResetUrl()
end

--Panel_QnAWebLink_Initialize()
------------------------------------------------------------
--						SHOW TOGGLE
------------------------------------------------------------
function Panel_QnAWebLink_ShowToggle()
	-- if not Panel_IngameCashShop:GetShow() then
	-- 	return
	-- end
	local isShow = Panel_QnAWebLink:IsShow()
	if ( isShow == true ) then
		_qnaWeb:ResetUrl()
		-- ♬ 창이 꺼질 때 소리
		audioPostEvent_SystemUi(13,05)
		Panel_QnAWebLink:SetShow( false, false )
	--	UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode)
		SetUIMode( preUIMode )
		return false;
	else
		-- ♬ 창이 켜질 때 소리
		audioPostEvent_SystemUi(13,06)
		Panel_QnAWebLink:SetShow( true, true )
		_qnaWeb:SetUrl(1015, 586, PAGetString(Defines.StringSheet_GAME, "LUA_QNAWEBLINK_URL"))
		_qnaWeb:SetIME(true)
		preUIMode = GetUIMode()
		SetUIMode( Defines.UIMode.eUIMode_QnAWebLink )
		return true;
	end

	return false;
end

function FGlobal_QnAWebLink_Open()
	if true == isKorea and true == isNaver then
		local naverLink = "http://black.game.naver.com/black/cs/faq/index.daum"
		ToClient_OpenChargeWebPage( naverLink, false )
	else
		ToClient_OpenChargeWebPage( PAGetString(Defines.StringSheet_GAME, "LUA_QNAWEBLINK_URL"), false )
	end
end

function FGlobal_QnAWebLink_Close()
	_qnaWeb:ResetUrl()
	-- ♬ 창이 꺼질 때 소리
	audioPostEvent_SystemUi(13,05)
	Panel_QnAWebLink:SetShow( false, false )
	if( AllowChangeInputMode() ) then
		UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode)
	else
		SetFocusChatting();
	end
--	SetUIMode( preUIMode )
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
_btn_Close			:addInputEvent( "Mouse_LUp", "Panel_QnAWebLink_ShowToggle()" )
_btn_CloseWindow	:addInputEvent( "Mouse_LUp", "Panel_QnAWebLink_ShowToggle()" )

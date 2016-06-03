-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 변수
-----------------------------------------------------------------------------------------------------------------------------------------------------
local INPUT_COUNT_START = 0
local INPUT_COUNT_END = 29

local STATIC_INPUT_TITLE = {}
local BUTTON_KEY = {}
local BUTTON_PAD = {}

local INPUT_TYPE

local controls = {
	-- 컨트롤들
	title					= UI.getChildControl( Panel_KeyCustom_Action, "StaticText_Title" ),
	subtitle1				= UI.getChildControl( Panel_KeyCustom_Action, "StaticText_Keyboard" ),
	subtitle2				= UI.getChildControl( Panel_KeyCustom_Action, "StaticText_Gamepad" ),
	BG						= UI.getChildControl( Panel_KeyCustom_Action, "Static_BG" ),
	confirm					= UI.getChildControl( Panel_KeyCustom_Action, "Button_Confirm" ),
	cancel					= UI.getChildControl( Panel_KeyCustom_Action, "Button_Cancel" ),
	apply					= UI.getChildControl( Panel_KeyCustom_Action, "Button_Apply" ),
	scrollbar				= UI.getChildControl( Panel_KeyCustom_Action, "Scroll_Vertical" ),
	scrollbarBtn			= nil,	--Scroll_CtrlButton

	staticInputTitle_Func1	= UI.getChildControl( Panel_KeyCustom_Action, "StaticText_PadFunc1" ),
	staticInputTitle_Func2	= UI.getChildControl( Panel_KeyCustom_Action, "StaticText_PadFunc2" ),
	button_key				= UI.getChildControl( Panel_KeyCustom_Action, "Button_Key" ),
	button_Pad_Func1		= UI.getChildControl( Panel_KeyCustom_Action, "Button_PadFunc1" ),
	button_Pad_Func2		= UI.getChildControl( Panel_KeyCustom_Action, "Button_PadFunc2" ),
	sample_staticInputTitle	= UI.getChildControl( Panel_KeyCustom_Action, "StaticText_PadFunc2" ),
	sample_keyButton		= UI.getChildControl( Panel_KeyCustom_Action, "Button_Key" ),
	sample_padButton		= UI.getChildControl( Panel_KeyCustom_Action, "Button_PadFunc2" ),
}

local keyConfigListShowCount = 10	-- 화면에 보여줄 키컨피그버튼 갯수 const value
local configDataIndex = 0	-- 키컨피그가 시작될 인덱스
local keyConfigData = {}
-- key : index ( -2 to 11 == keyConfigListShowCount ) -2 , -1은 Pad 전용 Func 데이터입니다.
-- value
-- {
-- 	titleText : 키컨피그 종류 text임 controls.title하고 매칭됨
-- 	buttonKeyText : 키컨피그 키보드 입력 text임 subtitle1과 매칭됨
-- 	padKeyText : 키컨피그 패드 입력 text임 subtitle2과 매칭됨
--	padOnly : 패드버튼만 보일거면 true, 아니면 false
-- }


-- keyConfig의 상대 인댁스 데이터를 가져옴
local getKeyConfigData = function( index )
	return keyConfigData[ configDataIndex + index -2 ]
end

local setKeyConfigDataTitle = function(index, title )
	keyConfigData[index] = { titleText = title, buttonKeyText = "", padKeyText = "", padOnly = false }
end

local setKeyConfigDataConfigButton = function(index, button )
	keyConfigData[index].buttonKeyText = button
end

local setKeyConfigDataConfigPad = function(index, pad )
	keyConfigData[index].padKeyText = pad
end

local setKeyConfigDataConfigOnlyPad = function(index, padOnly )
	keyConfigData[index].padOnly = padOnly
end

local updateKeyConfig = function()
	for index = 0, keyConfigListShowCount -1 do
		local keyConfigData = getKeyConfigData(index)
		if ( nil ~= keyConfigData ) then
			STATIC_INPUT_TITLE[index]:SetText( keyConfigData.titleText )
			if ( false == keyConfigData.padOnly ) then
				BUTTON_KEY[index]:SetText( keyConfigData.buttonKeyText )
				BUTTON_KEY[index]:SetShow(true)
			else
				BUTTON_KEY[index]:SetShow(false)
			end
			BUTTON_PAD[index]:SetText( keyConfigData.padKeyText )
		else
			STATIC_INPUT_TITLE[index]:SetText( " " )
			BUTTON_KEY[index]:SetText( " " )
			BUTTON_PAD[index]:SetText( " " )
		end
	end
end

function KeyCustom_OnButton()
	local volume = (controls.scrollbarBtn:GetPosY() / ( controls.scrollbar:GetSizeY() - controls.scrollbarBtn:GetSizeY() )) -- 대략 0~1
	configDataIndex = math.floor((INPUT_COUNT_END - keyConfigListShowCount +1) * volume)
	updateKeyConfig()
end 

function KeyCustom_OnSlider()
	local volume = controls.scrollbar:GetControlPos()
	configDataIndex = math.floor((INPUT_COUNT_END - keyConfigListShowCount +1) * volume)
	updateKeyConfig()
end 
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 초기화 함수
-----------------------------------------------------------------------------------------------------------------------------------------------------
local init = function()

	local adderPosY = 35
	
	local titleStaticPosY	= controls.button_Pad_Func1:GetPosY() -- controls.sample_staticInputTitle:GetPosY()
	local keyButtonPosY		= controls.button_Pad_Func1:GetPosY() -- controls.sample_keyButton:GetPosY()
	local padButtonPosY		= controls.button_Pad_Func1:GetPosY()

	for ii = 0, keyConfigListShowCount -1 do
		--local titleString =  PAGetString( Defines.StringSheet_GAME, ("Lua_KeyCustom_Action_" .. ii) )

		STATIC_INPUT_TITLE[ii]	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_KeyCustom_Action, "StaticText_InputTitle_" .. tostring(ii) )
		BUTTON_KEY[ii]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_KeyCustom_Action, "Button_Key_" .. tostring(ii) )
		BUTTON_PAD[ii]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_KeyCustom_Action, "Button_Pad_" .. tostring(ii) )

		CopyBaseProperty( controls.staticInputTitle_Func1, STATIC_INPUT_TITLE[ii] )
		CopyBaseProperty( controls.button_key, BUTTON_KEY[ii] )
		CopyBaseProperty( controls.button_Pad_Func2, BUTTON_PAD[ii] )

		STATIC_INPUT_TITLE[ii]:SetIgnore( true )
		STATIC_INPUT_TITLE[ii]:SetShow( true )
		BUTTON_KEY[ii]:SetShow( true )
		BUTTON_PAD[ii]:SetShow( true )

		--STATIC_INPUT_TITLE[ii]:SetText( titleString )

		STATIC_INPUT_TITLE[ii]:SetPosY( titleStaticPosY )
		BUTTON_KEY[ii]:SetPosY( keyButtonPosY )
		BUTTON_PAD[ii]:SetPosY( padButtonPosY )

		BUTTON_KEY[ii]:addInputEvent( "Mouse_LUp", "KeyCustom_Action_ButtonPushed_Key(" .. ii .. ")" )
		BUTTON_KEY[ii]:addInputEvent(	"Mouse_UpScroll",	"KeyCustom_Action_Scroll( true )"	)
		BUTTON_KEY[ii]:addInputEvent(	"Mouse_DownScroll",	"KeyCustom_Action_Scroll( false )"	)
		BUTTON_PAD[ii]:addInputEvent( "Mouse_LUp", "KeyCustom_Action_ButtonPushed_Pad(" .. ii .. ")" )
		BUTTON_PAD[ii]:addInputEvent(	"Mouse_UpScroll",	"KeyCustom_Action_Scroll( true )"	)
		BUTTON_PAD[ii]:addInputEvent(	"Mouse_DownScroll",	"KeyCustom_Action_Scroll( false )"	)

		titleStaticPosY		= titleStaticPosY + adderPosY
		keyButtonPosY		= keyButtonPosY + adderPosY
		padButtonPosY		= padButtonPosY + adderPosY
	end
	
	for index = INPUT_COUNT_START, INPUT_COUNT_END do
		local titleString =  PAGetString( Defines.StringSheet_GAME, ("Lua_KeyCustom_Action_" .. index) )
		setKeyConfigDataTitle(index, titleString)
	end

	setKeyConfigDataTitle(-2, controls.staticInputTitle_Func1:GetText() )
	setKeyConfigDataTitle(-1, controls.staticInputTitle_Func2:GetText() )
	setKeyConfigDataConfigOnlyPad(-2, true)
	setKeyConfigDataConfigOnlyPad(-1, true)

	controls.button_key:SetShow( false )
	controls.button_Pad_Func2:SetShow( false )
	controls.staticInputTitle_Func1:SetShow( false )
	controls.staticInputTitle_Func2:SetShow( false )
	controls.button_Pad_Func1:SetShow( false )
	controls.button_Pad_Func2:SetShow( false )

	updateKeyConfig();
	
	controls.scrollbarBtn	= UI.getChildControl( controls.scrollbar, "Scroll_CtrlButton" )
	
	controls.scrollbar:addInputEvent( "Mouse_LPress",	 "KeyCustom_OnSlider()" )
	controls.scrollbarBtn:addInputEvent( "Mouse_LPress",  "KeyCustom_OnButton()" )
	
	Panel_KeyCustom_Action:addInputEvent(	"Mouse_UpScroll",	"KeyCustom_Action_Scroll( true )"	)
	Panel_KeyCustom_Action:addInputEvent(	"Mouse_DownScroll",	"KeyCustom_Action_Scroll( false )"	)
	
	controls.scrollbarBtn:SetSize( controls.scrollbarBtn:GetSizeX(), controls.scrollbar:GetSizeY() / (INPUT_COUNT_END - keyConfigListShowCount) )
end

local registEventHandler = function()
	controls.confirm:addInputEvent( "Mouse_LUp", "KeyCustom_Action_Confirm()" )
	controls.cancel:addInputEvent( "Mouse_LUp", "KeyCustom_Action_Cancel()" )
	controls.apply:addInputEvent( "Mouse_LUp", "KeyCustom_Action_Apply()" )

	--controls.button_Pad_Func1:addInputEvent( "Mouse_LUp", "KeyCustom_Action_ButtonPushed_PadFunc1()" )
	--controls.button_Pad_Func2:addInputEvent( "Mouse_LUp", "KeyCustom_Action_ButtonPushed_PadFunc2()" )
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 잡다구리 함수
-----------------------------------------------------------------------------------------------------------------------------------------------------
function KeyCustom_Action_Show()
	Panel_KeyCustom_Action:SetShow(true)
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_Wait )
	keyCustom_StartEdit()
	KeyCustom_Action_UpdateButtonText_Key()
	KeyCustom_Action_UpdateButtonText_Pad()
	
	configDataIndex = 0
	controls.scrollbar:SetControlPos( 0 )
	updateKeyConfig()
end

function KeyCustom_Action_Close()
	Panel_KeyCustom_Action:SetShow(false)
	SetUIMode( Defines.UIMode.eUIMode_Default )
	UI.Set_ProcessorInputMode( CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode )
	-- UI.debugMessage( "KeyCustom_Action 창 닫기" )
end

function KeyCustom_Action_UpdateButtonText_Key()
	for ii = INPUT_COUNT_START, INPUT_COUNT_END do
		setKeyConfigDataConfigButton(ii, keyCustom_GetString_ActionKey( ii ))
	end
	updateKeyConfig()
end

function KeyCustom_Action_UpdateButtonText_Pad()
	keyConfigData[-2].padKeyText = keyCustom_GetString_ActionPadFunc1()
	keyConfigData[-1].padKeyText = keyCustom_GetString_ActionPadFunc2()

	for ii = INPUT_COUNT_START, INPUT_COUNT_END do
		setKeyConfigDataConfigPad(ii, keyCustom_GetString_ActionPad( ii ))
	end
	updateKeyConfig()
end

function KeyCustom_Action_GetInputType()
	return INPUT_TYPE
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 이벤트 함수
-----------------------------------------------------------------------------------------------------------------------------------------------------
function KeyCustom_Action_Confirm()
	keyCustom_applyChange()
	KeyCustom_Action_Close()
end

function KeyCustom_Action_Cancel()
	keyCustom_RollBack()
	KeyCustom_Action_Close()
end

function KeyCustom_Action_Apply()
	KeyCustom_Action_Close()
end

function KeyCustom_Action_ButtonPushed_Key( inputTypeIndex )
	local inputType = configDataIndex + inputTypeIndex - 2
	if ( 0 <= inputType ) then
		INPUT_TYPE = inputType
		SetUIMode( Defines.UIMode.eUIMode_KeyCustom_ActionKey )
		-- UI.debugMessage( "KeyCustom_Action_Key 수정 중... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_" .. inputType ) .. ")" )
	else
		-- _PA_LOG("LUA", "ERROR")
	end
end

function KeyCustom_Action_ButtonPushed_Pad( inputTypeIndex )
	local inputType = configDataIndex + inputTypeIndex - 2
	if ( 0 <= inputType ) then
		INPUT_TYPE = inputType
		SetUIMode( Defines.UIMode.eUIMode_KeyCustom_ActionPad )
		-- UI.debugMessage( "KeyCustom_Action_Pad 수정 중... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_" .. inputType ) .. ")" )
	elseif ( -1 == inputType ) then
		KeyCustom_Action_ButtonPushed_PadFunc2()
	else
		KeyCustom_Action_ButtonPushed_PadFunc1()
	end
end

function KeyCustom_Action_ButtonPushed_PadFunc1()
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_ActionPadFunc1 )
	-- UI.debugMessage( "KeyCustom_Action_Pad_Func1 수정 중..." )
end

function KeyCustom_Action_ButtonPushed_PadFunc2()
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_ActionPadFunc2 )
	-- UI.debugMessage( "KeyCustom_Action_Pad_Func2 수정 중..." )
end

function KeyCustom_Action_Scroll( isUp )
	if ( isUp ) then
		configDataIndex = configDataIndex -1
	else
		configDataIndex = configDataIndex + 1
	end
	configDataIndex = math.min(math.max( configDataIndex, 0), INPUT_COUNT_END - keyConfigListShowCount +2 )
	
	controls.scrollbar:SetControlPos( configDataIndex / (INPUT_COUNT_END - keyConfigListShowCount + 2) )
	
	updateKeyConfig()
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
--[[ 여기서부터 실행되는 코드 영역 ]]
-----------------------------------------------------------------------------------------------------------------------------------------------------
Panel_KeyCustom_Action:SetShow(false, false)
Panel_KeyCustom_Action:ActiveMouseEventEffect(true)
Panel_KeyCustom_Action:setGlassBackground(true)
init()
registEventHandler()
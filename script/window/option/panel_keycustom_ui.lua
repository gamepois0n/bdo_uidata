-- 사용하지 않는 파일.

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 변수
-----------------------------------------------------------------------------------------------------------------------------------------------------
local INPUT_COUNT_START_UI = 0
local INPUT_COUNT_END_UI = 14

local STATIC_INPUT_TITLE_UI = {}
local BUTTON_KEY_UI = {}
local BUTTON_PAD_UI = {}

local INPUT_TYPE_UI

local controls = {
	-- 컨트롤들
	title				= UI.getChildControl( Panel_KeyCustom_Ui, "StaticText_Title" ),
	subtitle1				= UI.getChildControl( Panel_KeyCustom_Ui, "StaticText_Keyboard" ),
	subtitle2				= UI.getChildControl( Panel_KeyCustom_Ui, "StaticText_Gamepad" ),
	BG					= UI.getChildControl( Panel_KeyCustom_Ui, "Static_BG" ),
	confirm				= UI.getChildControl( Panel_KeyCustom_Ui, "Button_Confirm" ),
	cancel				= UI.getChildControl( Panel_KeyCustom_Ui, "Button_Cancel" ),
	apply				= UI.getChildControl( Panel_KeyCustom_Ui, "Button_Apply" ),
	scrollbar		= UI.getChildControl( Panel_KeyCustom_Ui, "Scroll_Vertical" ),
	scrollbarBtn	= nil,	--Scroll_CtrlButton
	sample_staticInputTitle	= UI.getChildControl( Panel_KeyCustom_Ui, "StaticText_MoveFoward" ),
	sample_keyButton		= UI.getChildControl( Panel_KeyCustom_Ui, "Button_Key_MoveFoward" ),
	sample_padButton		= UI.getChildControl( Panel_KeyCustom_Ui, "Button_Pad_MoveFoward" ),
}

local keyConfigListShowCount_UI = 10	-- 화면에 보여줄 키컨피그버튼 갯수 const value
local configDataIndex_UI = 0	-- 키컨피그가 시작될 인덱스




local keyConfigData_UI = {}
-- key : index ( 0 to 11 == keyConfigListShowCount_UI )
-- value
-- {
-- 	titleText : 키컨피그 종류 text임 controls.title하고 매칭됨
-- 	buttonKeyText : 키컨피그 키보드 입력 text임 subtitle1과 매칭됨
-- 	padKeyText : 키컨피그 패드 입력 text임 subtitle2과 매칭됨
-- }


-- keyConfig의 상대 인댁스 데이터를 가져옴
local getKeyConfigData_UI = function( index )
	return keyConfigData_UI[ configDataIndex_UI + index ]
end

local setKeyConfigData_UI = function( index, title, button, padKey )
	if ( title ~= nil ) then
		keyConfigData_UI[index] = { titleText = title, buttonKeyText = button, padKeyText = padKey }
	else
		if ( nil ~= button ) then
			keyConfigData_UI[index].buttonKeyText = button
		else
			keyConfigData_UI[index].padKeyText = padKey
		end
	end
end
local setKeyConfigData_UITitle = function(index, title )
	setKeyConfigData_UI(index, title, "", "")
end

local setKeyConfigData_UIConfigButton = function(index, button )
	setKeyConfigData_UI(index, nil, button, nil)
end

local setKeyConfigData_UIConfigPad = function(index, pad )
	setKeyConfigData_UI(index, nil, nil, pad)
end

local updateKeyConfig_UI = function()
	for index = 0, keyConfigListShowCount_UI -1 do
		local keyConfigData_UI = getKeyConfigData_UI(index)
		if ( nil ~= keyConfigData_UI ) then
			STATIC_INPUT_TITLE_UI[index]:SetText( keyConfigData_UI.titleText )
			BUTTON_KEY_UI[index]:SetText( keyConfigData_UI.buttonKeyText )
			BUTTON_PAD_UI[index]:SetText( keyConfigData_UI.padKeyText )
		else
			STATIC_INPUT_TITLE_UI[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_KEYCUSTOM_KEYSET_EMPTY" )) -- 빔
			BUTTON_KEY_UI[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_KEYCUSTOM_KEYSET_EMPTY" ))
			BUTTON_PAD_UI[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_KEYCUSTOM_KEYSET_EMPTY" ))
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 초기화 함수
-----------------------------------------------------------------------------------------------------------------------------------------------------
local init = function()

	--UI.debugMessage( "KeyCustom_Ui 초기화" )
	
	local adderPosY = 35

	local titleStaticPosY	= controls.sample_staticInputTitle:GetPosY()
	local keyButtonPosY		= controls.sample_keyButton:GetPosY()
	local padButtonPosY		= controls.sample_padButton:GetPosY()

	for ii = 0, keyConfigListShowCount_UI -1 do
		--local titleString =  PAGetString( Defines.StringSheet_GAME, ("Lua_KeyCustom_Ui_" .. ii) )

		STATIC_INPUT_TITLE_UI[ii]	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_KeyCustom_Ui, "StaticText_InputTitle_" .. tostring(ii) )
		BUTTON_KEY_UI[ii]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_KeyCustom_Ui, "Button_Key_" .. tostring(ii) )
		BUTTON_PAD_UI[ii]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_KeyCustom_Ui, "Button_Pad_" .. tostring(ii) )

		CopyBaseProperty( controls.sample_staticInputTitle, STATIC_INPUT_TITLE_UI[ii] )
		CopyBaseProperty( controls.sample_keyButton, BUTTON_KEY_UI[ii] )
		CopyBaseProperty( controls.sample_padButton, BUTTON_PAD_UI[ii] )

		STATIC_INPUT_TITLE_UI[ii]:SetIgnore( true )
		STATIC_INPUT_TITLE_UI[ii]:SetShow( true )
		BUTTON_KEY_UI[ii]:SetShow( true )
		BUTTON_PAD_UI[ii]:SetShow( true )

		--STATIC_INPUT_TITLE_UI[ii]:SetText( titleString )

		STATIC_INPUT_TITLE_UI[ii]:SetPosY( titleStaticPosY )
		BUTTON_KEY_UI[ii]:SetPosY( keyButtonPosY )
		BUTTON_PAD_UI[ii]:SetPosY( padButtonPosY )

		BUTTON_KEY_UI[ii]:addInputEvent( "Mouse_LUp", "KeyCustom_UI_ButtonPushed_Key(" .. ii .. ")" )
		BUTTON_KEY_UI[ii]:addInputEvent(	"Mouse_UpScroll",	"KeyCustom_Ui_Scroll( true )"	)
		BUTTON_KEY_UI[ii]:addInputEvent(	"Mouse_DownScroll",	"KeyCustom_Ui_Scroll( false )"	)
		BUTTON_PAD_UI[ii]:addInputEvent( "Mouse_LUp", "KeyCustom_UI_ButtonPushed_Pad(" .. ii .. ")" )
		BUTTON_PAD_UI[ii]:addInputEvent(	"Mouse_UpScroll",	"KeyCustom_Ui_Scroll( true )"	)
		BUTTON_PAD_UI[ii]:addInputEvent(	"Mouse_DownScroll",	"KeyCustom_Ui_Scroll( false )"	)

		titleStaticPosY		= titleStaticPosY + adderPosY
		keyButtonPosY		= keyButtonPosY + adderPosY
		padButtonPosY		= padButtonPosY + adderPosY
	end

	for index = INPUT_COUNT_START_UI , INPUT_COUNT_END_UI do
		local titleString =  PAGetString( Defines.StringSheet_GAME, ("Lua_KeyCustom_Ui_" .. index) )
		setKeyConfigData_UITitle(index, titleString)
	end
	
	controls.sample_staticInputTitle:SetShow( false )
	controls.sample_keyButton:SetShow( false )
	controls.sample_padButton:SetShow( false )

	
	updateKeyConfig_UI();
	
	controls.scrollbarBtn	= UI.getChildControl( controls.scrollbar, "Scroll_CtrlButton" )
	
	controls.scrollbar:addInputEvent( "Mouse_LPress",	 "KeyCustom_OnSlider()" )
	controls.scrollbarBtn:addInputEvent( "Mouse_LPress",  "KeyCustom_OnButton()" )
	
	Panel_KeyCustom_Ui:addInputEvent(	"Mouse_UpScroll",	"KeyCustom_Ui_Scroll( true )"	)
	Panel_KeyCustom_Ui:addInputEvent(	"Mouse_DownScroll",	"KeyCustom_Ui_Scroll( false )"	)
	
	controls.scrollbarBtn:SetSize( controls.scrollbarBtn:GetSizeX(), controls.scrollbar:GetSizeY() / (INPUT_COUNT_END_UI - keyConfigListShowCount_UI) )
end

local registEventHandler = function()
	controls.confirm:addInputEvent( "Mouse_LUp", "KeyCustom_Ui_Confirm()" )
	controls.cancel:addInputEvent( "Mouse_LUp", "KeyCustom_Ui_Cancel()" )
	controls.apply:addInputEvent( "Mouse_LUp", "KeyCustom_Ui_Apply()" )
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 잡다구리 함수
-----------------------------------------------------------------------------------------------------------------------------------------------------
function KeyCustom_Ui_Show()
	Panel_KeyCustom_Ui:SetShow(true)
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_Wait )
	keyCustom_StartEdit()
	KeyCustom_Ui_UpdateButtonText_Key()
	KeyCustom_Ui_UpdateButtonText_Pad()
end

function KeyCustom_Ui_Close()
	Panel_KeyCustom_Ui:SetShow(false)
	SetUIMode( Defines.UIMode.eUIMode_Default )
	UI.Set_ProcessorInputMode( CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode )
end

function KeyCustom_Ui_UpdateButtonText_Key()
	for ii = INPUT_COUNT_START_UI, INPUT_COUNT_END_UI do
		setKeyConfigData_UIConfigButton(ii, keyCustom_GetString_UiKey( ii ))
	end
	updateKeyConfig_UI()
end

function KeyCustom_Ui_UpdateButtonText_Pad()
	for ii = INPUT_COUNT_START_UI, INPUT_COUNT_END_UI do
		setKeyConfigData_UIConfigPad(ii, keyCustom_GetString_UiPad( ii ))
	end
	updateKeyConfig_UI()
end

function KeyCustom_Ui_GetInputType()
	return INPUT_TYPE_UI
end



-----------------------------------------------------------------------------------------------------------------------------------------------------
-- 이벤트 함수
-----------------------------------------------------------------------------------------------------------------------------------------------------
function KeyCustom_Ui_Confirm()
	keyCustom_applyChange()
	KeyCustom_Ui_Close()
	--_PA_LOG("LUA", "KeyCustom_Ui_Confirm")
end

function KeyCustom_Ui_Cancel()
	keyCustom_RollBack()
	KeyCustom_Ui_Close()
end

function KeyCustom_Ui_Apply()
	KeyCustom_Ui_Close()
end

function KeyCustom_UI_ButtonPushed_Key( inputTypeIndex )
	local inputType = configDataIndex_UI + inputTypeIndex
	INPUT_TYPE_UI = inputType
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_UiKey )
end

function KeyCustom_UI_ButtonPushed_Pad( inputTypeIndex )
	local inputType = configDataIndex_UI + inputTypeIndex
	INPUT_TYPE_UI = inputType
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_UiPad )
end

function KeyCustom_Ui_Scroll( isUp )
	if ( isUp ) then
		configDataIndex_UI = configDataIndex_UI -1
	else
		configDataIndex_UI = configDataIndex_UI + 1
	end
	configDataIndex_UI = math.min(math.max( configDataIndex_UI, 0), INPUT_COUNT_END_UI - keyConfigListShowCount_UI )
	
	controls.scrollbar:SetControlPos( configDataIndex_UI / (INPUT_COUNT_END_UI - keyConfigListShowCount_UI) )
	
	updateKeyConfig_UI()
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
--[[ 여기서부터 실행되는 코드 영역 ]]
-----------------------------------------------------------------------------------------------------------------------------------------------------
Panel_KeyCustom_Ui:SetShow(false, false)
Panel_KeyCustom_Ui:ActiveMouseEventEffect(true)
Panel_KeyCustom_Ui:setGlassBackground(true)
init()
registEventHandler()

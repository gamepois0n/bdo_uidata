--
-- 숫자 창 관련
--

Panel_Window_Exchange_Number:SetShow( false, false)
Panel_Window_Exchange_Number:setMaskingChild(true)
Panel_Window_Exchange_Number:ActiveMouseEventEffect(true)
Panel_Window_Exchange_Number:setGlassBackground(true)

Panel_Window_Exchange_Number:RegisterShowEventFunc( true, 'ExchangeNumberShowAni()' )
Panel_Window_Exchange_Number:RegisterShowEventFunc( false, 'ExchangeNumberHideAni()' )

local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode
local UI_color 		= Defines.Color
local strlen = string.len
local substring = string.sub

local numberPad =
{
	MAX_NUMBER_BTN_COUNT  = 10,
	-- maxNumber 와 inputNumber 만 64비트로 사용한다.
	s64_maxNumber =  Defines.s64_const.s64_0,
	s64_inputNumber = Defines.s64_const.s64_0,
	param0		= nil,
	param1		= nil,
	confirmFunction,
	init_Number = false,				-- 최초 키패드 누를시 그 값으로 세팅해준다.
	_buttonNumber = Array.new(),
	numberPadUiModeNotInput = false
}

local numberKeyCode =
{
	VCK.KeyCode_0,			
	VCK.KeyCode_1,	
	VCK.KeyCode_2,	
	VCK.KeyCode_3,	
	VCK.KeyCode_4,	
	VCK.KeyCode_5,	
	VCK.KeyCode_6,	
	VCK.KeyCode_7,	
	VCK.KeyCode_8,	
	VCK.KeyCode_9,
	VCK.KeyCode_NUMPAD0,
	VCK.KeyCode_NUMPAD1,
	VCK.KeyCode_NUMPAD2,
	VCK.KeyCode_NUMPAD3,
	VCK.KeyCode_NUMPAD4,
	VCK.KeyCode_NUMPAD5,
	VCK.KeyCode_NUMPAD6,
	VCK.KeyCode_NUMPAD7,
	VCK.KeyCode_NUMPAD8,
	VCK.KeyCode_NUMPAD9,
}


----------------------------------------------------- -----------------------
-- 컨트롤 및 이벤트
-----------------------------------------------------------------------------
local _textNumber = UI.getChildControl(Panel_Window_Exchange_Number, "Static_DisplayNumber");
_textNumber:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
_textNumber:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")

local _buttonClose = UI.getChildControl(Panel_Window_Exchange_Number, "Button_Close");
_buttonClose:addInputEvent( "Mouse_LUp", "Panel_NumberPad_ButtonCancel_Mouse_Click()" );
_buttonClose:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonClose:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")

local _buttonCancel = UI.getChildControl(Panel_Window_Exchange_Number, "Button_Cancel");
_buttonCancel:addInputEvent( "Mouse_LUp", "Panel_NumberPad_ButtonCancel_Mouse_Click()" );
_buttonCancel:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonCancel:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")

local _buttonClear = UI.getChildControl(Panel_Window_Exchange_Number, "Button_Clear");
_buttonClear:addInputEvent( "Mouse_LUp", "Panel_NumberPad_ButtonClear_Mouse_Click()" );
_buttonClear:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonClear:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")

local _buttonBackSpace = UI.getChildControl(Panel_Window_Exchange_Number, "Button_Back");
_buttonBackSpace:addInputEvent( "Mouse_LUp", "Panel_NumberPad_ButtonBackSpace_Mouse_Click(false)" );
_buttonBackSpace:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonBackSpace:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")

local _buttonConfirm = UI.getChildControl(Panel_Window_Exchange_Number, "Button_Apply");
_buttonConfirm:addInputEvent( "Mouse_LUp", "Panel_NumberPad_ButtonConfirm_Mouse_Click()" );
_buttonConfirm:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonConfirm:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")
 
local _buttonAllSelect = UI.getChildControl(Panel_Window_Exchange_Number, "Button_AllSelect")
_buttonAllSelect:addInputEvent( "Mouse_LUp", "Panel_NumberPad_ButtonAllSelect_Mouse_Click()")
_buttonAllSelect:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
_buttonAllSelect:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")

-- registerEvent("EventNumberPadShow", 				"Panel_NumberPad_Show" );

----------------------------------------------------------------------------
-- 지역 함수
-----------------------------------------------------------------------------
function numberPad:init()
	for ii=1, numberPad.MAX_NUMBER_BTN_COUNT do
		local btn =  UI.getChildControl(Panel_Window_Exchange_Number, "Button_"  ..(ii-1) );
		btn:addInputEvent( "Mouse_LUp", "Panel_NumberPad_ButtonNumber_Mouse_Click(" ..(ii-1).. ")" );
		btn:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
		btn:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")
		numberPad._buttonNumber[ii] = btn;	
	end
	confirmFunction = Panel_NumberPad_Default_ConfirmFunction;	
end

function ExchangeNumberShowAni()
	UIAni.fadeInSCR_Down(Panel_Window_Exchange_Number)
end

function ExchangeNumberHideAni()
	Panel_Window_Exchange_Number:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_Exchange_Number:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

----------------------------------------------------------------------------
-- 이벤트 핸들
-----------------------------------------------------------------------------
function	Panel_NumberPad_Init( param0, confirmFunction, isShow, param1 )
	numberPad.param0			= param0
	numberPad.param1			= param1
	numberPad.confirmFunction	= confirmFunction
	numberPad.init_Number		= true

	_textNumber:SetEditText( tostring(numberPad.s64_inputNumber) );
	_textNumber:SetNumberMode(true)
	
	_buttonConfirm:SetEnable(true)
	_buttonConfirm:SetMonoTone(false)
	_buttonConfirm:SetFontColor(UI_color.C_FFFFFFFF)
	
	if (not Panel_Window_Exchange_Number:GetShow()) then	
		Panel_Window_Exchange_Number:SetPosX(getMousePosX())
		Panel_Window_Exchange_Number:SetPosY(getMousePosY())
	end
	
	local keyPadPosY = Panel_Window_Exchange_Number:GetPosY()
	keyPadPosY = keyPadPosY + Panel_Window_Exchange_Number:GetSizeY()
	if keyPadPosY > getScreenSizeY() then
		Panel_Window_Exchange_Number:SetPosY( getScreenSizeY() - Panel_Window_Exchange_Number:GetSizeY() - 30 )
	end
	
	local keyPadPosX = Panel_Window_Exchange_Number:GetPosX()
	keyPadPosX = keyPadPosX + Panel_Window_Exchange_Number:GetSizeX()
	if keyPadPosX > getScreenSizeX() then
		Panel_Window_Exchange_Number:SetPosX( getScreenSizeX() - Panel_Window_Exchange_Number:GetSizeX() )
	end
	if	isShow	then
		Panel_NumberPad_Open()
	end
end
function	Panel_NumberPad_Open()
	if	not Panel_Window_Exchange_Number:IsShow()	then
		Panel_Window_Exchange_Number:SetShow( true, true )
	end
end
function	Panel_NumberPad_Close()
	if Panel_Window_Exchange_Number:IsShow() then
		-- maxNumber 와 inputNumber 만 64비트로 사용한다.
		numberPad.s64_maxNumber		= Defines.s64_const.s64_0
		numberPad.s64_inputNumber	= Defines.s64_const.s64_0
		numberPad.param0			= nil
		numberPad.param1			= nil
		numberPad.confirmFunction	= nil;
		
		Panel_Window_Exchange_Number:SetShow( false, true );	
	end
end

function Panel_NumberPad_Show_Min( isShow, s64_minNumber, param0, confirmFunction, param1 )
	
	if ( not isShow ) then
		Panel_NumberPad_Close()
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		ClearFocusEdit()
		if ( numberPad.numberPadUiModeNotInput ) then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)
		end
	else
		numberPad.s64_maxNumber		= Defines.s64_const.s64_max
		numberPad.s64_inputNumber	= s64_minNumber
		
		Panel_NumberPad_Init( param0, confirmFunction, true, param1 )
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		SetFocusEdit( _textNumber )
		_textNumber:SetEditText(numberPad.s64_maxNumber)
	end
end

local _isExchange = nil -- 개인 거래의 예외 처리를 위한 임시 변수!
function	Panel_NumberPad_Show( isShow, s64_maxNumber, param0, confirmFunction, isExchange, param1, isItemMarket )
	_isExchange = isExchange -- 개인 거래의 예외 처리를 위한 임시 변수!
	
	local maxLength = string.len(tostring(s64_maxNumber))
	_textNumber:SetMaxInput( maxLength + 1 )
	
	if ( not isShow ) then
		Panel_NumberPad_Close()
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		ClearFocusEdit()
		if ( numberPad.numberPadUiModeNotInput ) then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)
		end
	else 
		numberPad.s64_maxNumber		= s64_maxNumber
		if true == isItemMarket then
			numberPad.s64_inputNumber	= s64_maxNumber
		else
			numberPad.s64_inputNumber	= Defines.s64_const.s64_1
		end

		if( Defines.s64_const.s64_1 == s64_maxNumber ) then
			Panel_NumberPad_Init( param0, confirmFunction, false, param1 )
			Panel_NumberPad_ButtonConfirm_Mouse_Click()
		else
			Panel_NumberPad_Init( param0, confirmFunction, true, param1 )
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
			SetFocusEdit( _textNumber )
			if true == isItemMarket then
				_textNumber:SetEditText( Int64toInt32( s64_maxNumber ) )
			else
				_textNumber:SetEditText( "1" )
			end
		end
	end
end

function FGlobal_SetNumberPadUiModeNotInput(isSet)
	numberPad.numberPadUiModeNotInput = isSet
end

function Panel_NumberPad_ButtonClose_Mouse_Click()
	Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);
end

function Panel_NumberPad_ButtonCancel_Mouse_Click()
	Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);
end

function Panel_NumberPad_ButtonClear_Mouse_Click()
	numberPad.s64_inputNumber = Defines.s64_const.s64_0;
	_textNumber:SetEditText( "0" );
	if _isExchange ~= true then
		_buttonConfirm:SetEnable(false)
		_buttonConfirm:SetMonoTone(true)
		_buttonConfirm:SetFontColor(UI_color.C_FFC4BEBE)
	end
end

function Panel_NumberPad_ButtonNumber_Mouse_Click( number )
	local newStr = _textNumber:GetEditText()
	if ( nil ~= number ) then
		newStr = ( newStr .. tostring(number) )
	end

	local s64_newNumber = tonumber64(newStr);
	
	local s64_MAX = numberPad.s64_maxNumber;

	if true == numberPad.init_Number then
		numberPad.init_Number = false
		if ( nil == number ) then
			local length = strlen(newStr)
			newStr = substring( newStr, -1)
		else
			newStr = tostring( number )
		end
		s64_newNumber = tonumber64( newStr )
	end
	
	if( s64_MAX < s64_newNumber ) then
		numberPad.s64_inputNumber = numberPad.s64_maxNumber
	else
		if ( 0 == string.len(newStr) ) then
			_textNumber:SetEditText( "0" )
			numberPad.s64_inputNumber = 0
		else
			numberPad.s64_inputNumber = s64_newNumber
		end
	end

	_textNumber:SetEditText( tostring( numberPad.s64_inputNumber) )
	
	if Defines.s64_const.s64_0 < numberPad.s64_inputNumber or _isExchange == true then -- _isExchange : 개인 거래의 예외 처리를 위한 임시 변수!
		_buttonConfirm:SetEnable(true)
		_buttonConfirm:SetMonoTone(false)
		_buttonConfirm:SetFontColor(UI_color.C_FFFFFFFF)
	else
		_buttonConfirm:SetEnable(false)
		_buttonConfirm:SetMonoTone(true)
		_buttonConfirm:SetFontColor(UI_color.C_FFC4BEBE)
	end
end

function Panel_NumberPad_ButtonBackSpace_Mouse_Click(fromOnKey)
	local str = _textNumber:GetEditText()
	local length = strlen(str);
	local newStr = "";

	if ( fromOnKey ) then
		if 1 <= length then
			newStr = str
			numberPad.s64_inputNumber = tonumber64(newStr)
			newStr = tostring(numberPad.s64_inputNumber)
		else
			newStr = "0";
			numberPad.init_Number = true
			numberPad.s64_inputNumber = Defines.s64_const.s64_0;
		end

	else
		if 1 < length then
			newStr = substring( str, 1, length-1 )
			numberPad.s64_inputNumber = tonumber64(newStr)
			newStr = tostring(numberPad.s64_inputNumber)
		else
			newStr = "0";
			numberPad.init_Number = true
			numberPad.s64_inputNumber = Defines.s64_const.s64_0;
		end

	end
		
	_textNumber:SetEditText( newStr )

	if Defines.s64_const.s64_0 >= numberPad.s64_inputNumber then
		_buttonConfirm:SetEnable(false)
		_buttonConfirm:SetMonoTone(true)	
		_buttonConfirm:SetFontColor(UI_color.C_FFC4BEBE)
	end
end

function Panel_NumberPad_ButtonConfirm_Mouse_Click()
	if Defines.s64_const.s64_0 < numberPad.s64_inputNumber or  _isExchange == true then
		if nil ~= numberPad.confirmFunction then
			numberPad.confirmFunction( numberPad.s64_inputNumber, numberPad.param0, numberPad.param1  );
		end
		Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);	
	end	
end

function Panel_NumberPad_ButtonAllSelect_Mouse_Click()
	numberPad.s64_inputNumber = numberPad.s64_maxNumber

	if( Defines.s64_const.s64_1 == s64_maxNumber ) then
		Panel_NumberPad_Init( numberPad.param0, numberPad.confirmFunction, false, numberPad.param1 )
		Panel_NumberPad_ButtonConfirm_Mouse_Click()
	else
		Panel_NumberPad_Init( numberPad.param0, numberPad.confirmFunction, false, numberPad.param1 )
		-- Panel_NumberPad_ButtonConfirm_Mouse_Click() -- 일괄 최대 선택+구매에서 일괄 최대 선택이기 때문에 주석부분을 사용하지 않는다.
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode) -- 일괄 최대 선택에서 일괄 최대 선택+구매이기 때문에 주석부분을 사용하지 않는다.
		SetFocusEdit( _textNumber )
		_textNumber:SetEditText( tostring(numberPad.s64_maxNumber) )
	end
end

function Panel_NumberPad_Mouse_Scroll_Event( isUp )	-- 마우스 스크롤로 갯수 카운팅하기 -- 20150124 정승철
	local currentNumber_s32 = tonumber(_textNumber:GetEditText());
	local currentNumber_s64 = toInt64(0,currentNumber_s32)
	local inputNumber_s64 = currentNumber_s64 

	if true == isUp then
		if numberPad.s64_maxNumber <= currentNumber_s64 then return end
		inputNumber_s64 = currentNumber_s64 + toInt64(0,1)
		
	elseif false == isUp then
		if currentNumber_s32 <= 1 then return end
		inputNumber_s64 = currentNumber_s64 - toInt64(0,1)
	end
	
	_textNumber:SetEditText( tostring(inputNumber_s64) )
	numberPad.s64_inputNumber = inputNumber_s64
end


-- 임의의 기본함수
function Panel_NumberPad_Default_ConfirmFunction( count, param0, param1 )
	Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);
end

function Panel_NumberPad_IsPopUp()
	return Panel_Window_Exchange_Number:IsShow()
end

function Panel_NumberPad_NumberKey_Input()
	for idx,val in ipairs(numberKeyCode) do
		if isKeyDown_Once( val ) then
			Panel_NumberPad_ButtonNumber_Mouse_Click(nil)
		end
	end
	
	if isKeyDown_Once( VCK.KeyCode_BACK ) or isKeyDown_Once ( VCK.KeyCode_DELETE ) then
		Panel_NumberPad_ButtonBackSpace_Mouse_Click(true)
	end
end

Panel_Window_Exchange_Number:addInputEvent("Mouse_UpScroll","Panel_NumberPad_Mouse_Scroll_Event(true)")
Panel_Window_Exchange_Number:addInputEvent("Mouse_DownScroll","Panel_NumberPad_Mouse_Scroll_Event(false)")


-- 초기화
numberPad:init();



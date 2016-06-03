---------------------------------------------------- UI Control 등록 ------------------------------------------------------

-- 본 컨트롤 관련
local StaticText_DefaultControl		= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_DefaultControl")
local RadioButton_Bone_Scale 		= UI.getChildControl(Panel_CustomizationTransformBody, "RadioButton_Bone_Scale")

local StaticText_ScaleX				= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_ScaleX")
local StaticText_ScaleY				= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_ScaleY")
local StaticText_ScaleZ				= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_ScaleZ")

local Slider_ScaleX					= UI.getChildControl(Panel_CustomizationTransformBody, "Slider_ScaleX_Controller")
local Slider_ScaleY					= UI.getChildControl(Panel_CustomizationTransformBody, "Slider_ScaleY_Controller")
local Slider_ScaleZ					= UI.getChildControl(Panel_CustomizationTransformBody, "Slider_ScaleZ_Controller")

local Button_Slider_ScaleX				= UI.getChildControl(Slider_ScaleX, "Slider_GammaController_Button")
local Button_Slider_ScaleY				= UI.getChildControl(Slider_ScaleY, "Slider_GammaController_Button")
local Button_Slider_ScaleZ				= UI.getChildControl(Slider_ScaleZ, "Slider_GammaController_Button")

local StaticText_ControlPart			= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_ControlPart")
local CheckButton_ControlPart		= UI.getChildControl(Panel_CustomizationTransformBody, "CheckButton_ControlPart")

local Button_All_Reset				= UI.getChildControl(Panel_CustomizationTransformBody, "Button_All_Reset")
local Button_Part_Reset				= UI.getChildControl(Panel_CustomizationTransformBody, "Button_Part_Reset")

local StaticText_CurrValue_ScaleX	= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Slider_ScaleX_Left")
local StaticText_CurrValue_ScaleY	= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Slider_ScaleY_Left")
local StaticText_CurrValue_ScaleZ	= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Slider_ScaleZ_Left")

local Slider_Height					= UI.getChildControl(Panel_CustomizationTransformBody, "Slider_Height_Controller")
local Button_Slider_Height			= UI.getChildControl(Slider_Height, "Slider_GammaController_Button")

local Slider_Weight					= UI.getChildControl(Panel_CustomizationTransformBody, "Slider_Weight_Controller")
local Button_Slider_Weight			= UI.getChildControl(Slider_Weight, "Slider_GammaController_Button")

local StaticText_Weight				= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Weight")
local StaticText_Height				= UI.getChildControl(Panel_CustomizationTransformBody, "StaticText_Height")
--local Static_MouseCursor			= UI.getChildControl(Panel_Customization_Control, "Static_Cursor_Scale")

---------------------------------------------------- UI control 초기값 설정 -------------------------------------------------------



StaticText_DefaultControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONTRANSFORM_STATICTEXT_DEFAULTCONTROL")) -- 본 컨트롤러

StaticText_ControlPart:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_CONTROLPART")) -- 조절 부위 보기

Button_All_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_ALL_RESET")) -- 전체 초기화

Button_Part_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_PART_RESET")) -- 부위 초기화
CheckButton_ControlPart:SetCheck(true)

StaticText_Weight:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_WEIGHT"))
StaticText_Height:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_HEIGHT"))

--Static_MouseCursor:SetShow(false);
--Static_MouseCursor:SetIgnore(true);
---------------------------------------------------- Event 등록 -----------------------------------------------------


Slider_ScaleX:addInputEvent( "Mouse_LPress", "UpdateBodyBoneScale()");
Slider_ScaleY:addInputEvent( "Mouse_LPress", "UpdateBodyBoneScale()");
Slider_ScaleZ:addInputEvent( "Mouse_LPress", "UpdateBodyBoneScale()");
Button_Slider_ScaleX:addInputEvent( "Mouse_LPress", "UpdateBodyBoneScale()");
Button_Slider_ScaleY:addInputEvent( "Mouse_LPress", "UpdateBodyBoneScale()");
Button_Slider_ScaleZ:addInputEvent( "Mouse_LPress", "UpdateBodyBoneScale()");

Slider_Height:addInputEvent("Mouse_LPress", "UpdateBodyHeight()");
Button_Slider_Height:addInputEvent("Mouse_LPress", "UpdateBodyHeight()");

Slider_Weight:addInputEvent("Mouse_LPress", "UpdateBodyWeight()");
Button_Slider_Weight:addInputEvent("Mouse_LPress", "UpdateBodyWeight()");

Button_All_Reset:addInputEvent("Mouse_LUp", "clearGroupCustomizedBonInfoLua()")
Button_Part_Reset:addInputEvent("Mouse_LUp", "clearCustomizedBoneInfo()")
	
CheckButton_ControlPart:addInputEvent("Mouse_LUp", "ToggleShowBodyBoneControlPart()")
	
-- 처음 hair shape Editor 호출 시 
registerEvent("EventShowBodyBoneEditor","ShowBodyBoneEditor")
-- body bone 피킹 시
registerEvent("EventPickingBodyBone", "PickingBodyBone")
-- 바디  본 Scale 시 
registerEvent("EventAdjustBodyBoneScale", "AdjustBodyBoneScale")

registerEvent("EventOpenBodyShapeUi","OpenBodyShapeUi")
registerEvent("EventCloseBodyShapeUi","CloseBodyShapeUi")
registerEvent("EventEnableBodySlide", "EnableBodySlide")
------------------------------------------------------ 필요 변수 선언 및 정의 --------------------------------------------------

local scaleMin
local scaleMax
local currentScale

local selectedClassType

local SculptingUIRect = 
{
	left,
	top,
	right,
	bottom
}

--local mouseCursorRadius = Static_MouseCursor:GetSizeX()

local selectedCharacterClass =-1

--텍스트와 슬라이더 거리
local sliderTextGap = 3
local contentsGapHeight = 10

-- 선택된 클래스 , 
-- 현재 헤어 본 컨트롤은 특정 클래스(워리어,자이언츠)에 대해 본컨트롤UI가 들어가지 않으므로 
-- 이를 처리하기 위해 선택된 클래스를 저장함.
local selectedClassIndex

---------------------------------------------- local 함수 ---------------------------------------------
-- 커서 그리는 함수 
--[[local EnableCursor = function ( Enable )
	if selectedClassIndex == 0 or selectedClassIndex ==3 then
		return
	end
	
	Static_MouseCursor:SetShow( Enable )
	if true == Enable then
		setCursorMode(0)
	else
		setCursorMode(1)
	end
end]]

-- 각종 컨트롤 value 초기화
local InitBodyBoneControls = function()
	if currentScale ~= nil then
		setValueSlider( Slider_ScaleX, currentScale.x, scaleMin.x, scaleMax.x )
		setValueSlider( Slider_ScaleY, currentScale.y, scaleMin.y, scaleMax.y )
		setValueSlider( Slider_ScaleZ, currentScale.z, scaleMin.z, scaleMax.z )
	end
end

-- float 스트링 변환 함수 
local floatString = function( floatValue ) 
	return string.format(  "%.2f", floatValue )
end

-- 커서가 UI 내에 있는 지 체크하는 함수, 커서의 범위도 포함하여 체크한다.
--[[local CheckCursorInSculptingUI = function()
	SculptingUIRect.left	=	Panel_CustomizationFrame:GetPosX()--Panel_CustomizationTransform:GetPosX()
	SculptingUIRect.top		=	Panel_CustomizationFrame:GetPosY()--Panel_CustomizationTransform:GetPosY()
	SculptingUIRect.right	=	SculptingUIRect.left+Panel_CustomizationFrame:GetSizeX()
	SculptingUIRect.bottom	=	SculptingUIRect.top+Panel_CustomizationFrame:GetSizeY()
	
	if getMousePosX() >= SculptingUIRect.left - mouseCursorRadius/2 and 
		getMousePosY() >= SculptingUIRect.top - mouseCursorRadius/2 and 
		getMousePosX() <= SculptingUIRect.right  + mouseCursorRadius/2 and 
		getMousePosY() <= SculptingUIRect.bottom + mouseCursorRadius/2 then
		EnableCursor(false)
	else
		EnableCursor(true)
		
	end
end
]]

-- clearGroupCustomizedBonInfoLua() 후처리 동작
local bonInfoPostFunction = function()
	Slider_Height:SetControlPos(getCustomizationBodyHeight())
	Slider_Weight:SetControlPos(getCustomizationBodyWeight())
end
pushClearGroupCustomizedBonInfoPostFunction(bonInfoPostFunction)
---------------------------------------------- global 함수 ---------------------------------------------

function UpdateBodyHeight()
	applyBodyHeight( selectedClassType, Slider_Height:GetControlPos() * 100 )
end

function UpdateBodyWeight()
	applyBodyWeight( selectedClassType, Slider_Weight:GetControlPos() * 100 )
end

-- 헤어 본 컨트롤 정보 업데이트
function UpdateBodyBoneScale()
	local x = calculateSliderValue( Slider_ScaleX, scaleMin.x, scaleMax.x )
	local y = calculateSliderValue( Slider_ScaleY, scaleMin.y, scaleMax.y )
	local z = calculateSliderValue( Slider_ScaleZ, scaleMin.z, scaleMax.z )
	currentScale.x = x
	currentScale.y = y
	currentScale.z = z
	applyScaleValue( x, y, z )	
	
	StaticText_CurrValue_ScaleX:SetText( math.floor( x * 100 ) / 100 )
	StaticText_CurrValue_ScaleY:SetText( math.floor( y * 100 ) / 100 )
	StaticText_CurrValue_ScaleZ:SetText( math.floor( z * 100 ) / 100 )
	--임시코드
	StaticText_CurrValue_ScaleX:SetShow(false)
	StaticText_CurrValue_ScaleY:SetShow(false)
	StaticText_CurrValue_ScaleZ:SetShow(false)
end


----------------------------------------- 클라이언트에 의해 호출 되는 함수, global 함수 ---------------------------------------------------

function OpenBodyShapeUi( classType, uiId )
	selectedClassType = classType
	startBodyPickingMode()
	EnableBodySlide( false )
	ShowBodyBoneEditor()
end

function CloseBodyShapeUi()
	endPickingMode()
end

-- 처음 헤어 bone UI 호출 시 
function ShowBodyBoneEditor()
	Slider_ScaleX:SetControlPos(50)
	Slider_ScaleY:SetControlPos(50)
	Slider_ScaleZ:SetControlPos(50)
	Slider_Height:SetControlPos(getCustomizationBodyHeight())
	Slider_Weight:SetControlPos(getCustomizationBodyWeight())
	StaticText_CurrValue_ScaleX:SetText( 0 )
	StaticText_CurrValue_ScaleY:SetText( 0 )
    StaticText_CurrValue_ScaleZ:SetText( 0 )
	setSymmetryBoneTransform( true );
	RadioButton_Bone_Scale:SetCheck(true);
	CursorSelect(3)
	updateGroupFrameControls(  Panel_CustomizationTransformBody:GetSizeY() , Panel_CustomizationTransformBody )
	StaticText_CurrValue_ScaleX:SetShow(false)
	StaticText_CurrValue_ScaleY:SetShow(false)
	StaticText_CurrValue_ScaleZ:SetShow(false)
	ToggleShowBodyBoneControlPart()
end

-- 헤어 본 컨트롤 파트 표시 flag
function ToggleShowBodyBoneControlPart()
	showBoneControlPart( CheckButton_ControlPart:IsCheck() )
end

-- 특정 본은 Picking 시 호출 
function PickingBodyBone( customizationData )
	
	scaleMin 	= customizationData:getSelectedBoneScaleMin()
	scaleMax 	= customizationData:getSelectedBoneScaleMax()
	currentScale	= customizationData:getSelectedBoneScaleValue()
	EnableBodySlide( true )
	InitBodyBoneControls()
end 

function EnableBodySlide( enable )
	local color = Defines.Color.C_FF444444
	if( enable ) then
		color = Defines.Color.C_FFFFFFFF
	end
	StaticText_ScaleX:SetFontColor( color )
	StaticText_ScaleY:SetFontColor( color )
	StaticText_ScaleZ:SetFontColor( color )
	Slider_ScaleX:SetMonoTone( not enable )
	Slider_ScaleY:SetMonoTone( not enable )
	Slider_ScaleZ:SetMonoTone( not enable )
	Slider_ScaleX:SetEnable( enable )
	Slider_ScaleY:SetEnable( enable )
	Slider_ScaleZ:SetEnable( enable )
	
	
	color = Defines.Color.C_FFFFFFFF
	if( enable ) then
		color = Defines.Color.C_FF444444
	end
	
	Slider_Weight:SetMonoTone( enable )
	Slider_Weight:SetEnable( not enable )
	StaticText_Weight:SetFontColor( color )
	Slider_Height:SetMonoTone( enable )
	Slider_Height:SetEnable( not enable )
	StaticText_Height:SetFontColor( color )

end

-- bone 컨트롤에 따른 translation 적용
function AdjustBodyBoneScale( scaleX, scaleY, scaleZ )

	local self = sculptingBoneSettingUI
	
	self.EditText[ self.PARAM_SCALEVALX ]:SetEditText( floatString( scaleX )  )
	self.EditText[ self.PARAM_SCALEVALY ]:SetEditText( floatString( scaleY )  )
	self.EditText[ self.PARAM_SCALEVALZ ]:SetEditText( floatString( scaleZ )  )
	
	setValueSlider( Slider_ScaleX, scaleX, scaleMin.x, scaleMax.x)
	setValueSlider( Slider_ScaleY, scaleY, scaleMin.y, scaleMax.y)
	setValueSlider( Slider_ScaleZ, scaleZ, scaleMin.z, scaleMax.z)
	
	currentScale.x = scaleX
	currentScale.y = scaleY
	currentScale.z = scaleZ
end

-----------------------------------------------------------------------------------------------------------------------------------
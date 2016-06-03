---------------------------------------------------- UI Control 등록 ------------------------------------------------------

-- 본 컨트롤 관련
local RadioButton_Bone_Trans 		= UI.getChildControl(Panel_CustomizationTransformHair, "RadioButton_Bone_Trans")
local RadioButton_Bone_Rot			= UI.getChildControl(Panel_CustomizationTransformHair, "RadioButton_Bone_Rot")

local StaticText_DefaultControl		= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_DefaultControl")
local StaticText_ControlPart			= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_ControlPart")

local StaticText_TransX				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_TransX")
local StaticText_TransY				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_TransY")
local StaticText_TransZ				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_TransZ")

local Slider_TransX						= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_TransX_Controller")
local Slider_TransY						= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_TransY_Controller")
local Slider_TransZ						= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_TransZ_Controller")

local Button_Slider_TransX				= UI.getChildControl(Slider_TransX, "Slider_GammaController_Button")
local Button_Slider_TransY				= UI.getChildControl(Slider_TransY, "Slider_GammaController_Button")
local Button_Slider_TransZ				= UI.getChildControl(Slider_TransZ, "Slider_GammaController_Button")

local StaticText_RotX				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_RotX")
local StaticText_RotY				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_RotY")
local StaticText_RotZ				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_RotZ")

local Slider_RotX						= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_RotX_Controller")
local Slider_RotY						= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_RotY_Controller")
local Slider_RotZ						= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_RotZ_Controller")

local Button_Slider_RotX				= UI.getChildControl(Slider_RotX, "Slider_GammaController_Button")
local Button_Slider_RotY				= UI.getChildControl(Slider_RotY, "Slider_GammaController_Button")
local Button_Slider_RotZ				= UI.getChildControl(Slider_RotZ, "Slider_GammaController_Button")

--슬라이더 관련 컨트롤
local SliderArr = {}
local Button_SliderArr = {}
local StaticTextArr = {}
local StaticText_CurrentValue = {}

-- todo(zezzeg) : 슬라이더 카피 기능으로 불필요한 중복을 피하자
SliderArr[1]					= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller1")
SliderArr[2]					= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller2")
SliderArr[3]					= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller3")
SliderArr[4]					= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller4")
SliderArr[5]					= UI.getChildControl(Panel_CustomizationTransformHair, "Slider_Controller5")
	
Button_SliderArr[1] = UI.getChildControl(SliderArr[1], "Slider_GammaController_Button")
Button_SliderArr[2] = UI.getChildControl(SliderArr[2], "Slider_GammaController_Button")
Button_SliderArr[3] = UI.getChildControl(SliderArr[3], "Slider_GammaController_Button")
Button_SliderArr[4] = UI.getChildControl(SliderArr[4], "Slider_GammaController_Button")
Button_SliderArr[5] = UI.getChildControl(SliderArr[5], "Slider_GammaController_Button")

StaticTextArr[1]				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc1")
StaticTextArr[2]				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc2")
StaticTextArr[3]				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc3")
StaticTextArr[4]				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc4")
StaticTextArr[5]				= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderDesc5")

StaticText_CurrentValue[1] 	= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue1") 
StaticText_CurrentValue[2]  	= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue2")
StaticText_CurrentValue[3]  	= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue3")
StaticText_CurrentValue[4]  	= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue4")
StaticText_CurrentValue[5]	= UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_SliderValue5")


local CheckButton_ControlPart		= UI.getChildControl(Panel_CustomizationTransformHair, "CheckButton_ControlPart")

local Button_All_Reset				= UI.getChildControl(Panel_CustomizationTransformHair, "Button_All_Reset")
local Button_Part_Reset				= UI.getChildControl(Panel_CustomizationTransformHair, "Button_Part_Reset")

-- 흠냐~
local StaticText_CurrValue_TransX = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_Slider_TransX_Left") 
local StaticText_CurrValue_TransY = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_Slider_TransY_Left") 
local StaticText_CurrValue_TransZ = UI.getChildControl(Panel_CustomizationTransformHair, "StaticText_Slider_TransZ_Left") 

StaticText_CurrValue_TransX:SetShow( false )
StaticText_CurrValue_TransY:SetShow( false )
StaticText_CurrValue_TransZ:SetShow( false )


---------------------------------------------------- UI control 초기값 설정 -------------------------------------------------------

StaticText_DefaultControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONTRANSFORM_STATICTEXT_DEFAULTCONTROL")) -- 본 컨트롤러
StaticText_ControlPart:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_CONTROLPART")) -- 조절 부위 보기
Button_All_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_ALL_RESET")) -- 전체 초기화
Button_Part_Reset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_PART_RESET")) -- 부위 초기화

CheckButton_ControlPart:SetCheck(true)
---------------------------------------------------- Event 등록 -----------------------------------------------------
RadioButton_Bone_Trans:addInputEvent("Mouse_LUp",		"CursorSelect(1)")
RadioButton_Bone_Rot:addInputEvent("Mouse_LUp",		"CursorSelect(2)")

Slider_TransX:addInputEvent( "Mouse_LPress", "UpdateHairBone(1)")
Slider_TransY:addInputEvent( "Mouse_LPress", "UpdateHairBone(1)")
Slider_TransZ:addInputEvent( "Mouse_LPress", "UpdateHairBone(1)")
Button_Slider_TransX:addInputEvent( "Mouse_LPress", "UpdateHairBone(1)")
Button_Slider_TransY:addInputEvent( "Mouse_LPress", "UpdateHairBone(1)")
Button_Slider_TransZ:addInputEvent( "Mouse_LPress", "UpdateHairBone(1)")

Slider_RotX:addInputEvent( "Mouse_LPress", "UpdateHairBone(2)")
Slider_RotY:addInputEvent( "Mouse_LPress", "UpdateHairBone(2)")
Slider_RotZ:addInputEvent( "Mouse_LPress", "UpdateHairBone(2)")
Button_Slider_RotX:addInputEvent( "Mouse_LPress", "UpdateHairBone(2)")
Button_Slider_RotY:addInputEvent( "Mouse_LPress", "UpdateHairBone(2)")
Button_Slider_RotZ:addInputEvent( "Mouse_LPress", "UpdateHairBone(2)")


SliderArr[1]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(0)");
SliderArr[2]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(1)");
SliderArr[3]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(2)");
SliderArr[4]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(3)");
SliderArr[5]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(4)");
Button_SliderArr[1]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(0)");
Button_SliderArr[2]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(1)");
Button_SliderArr[3]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(2)");
Button_SliderArr[4]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(3)");
Button_SliderArr[5]:addInputEvent( "Mouse_LPress", "UpdateHairSlider(4)");

Button_All_Reset:addInputEvent("Mouse_LUp", "clearGroupCustomizedBonInfoLua()")
Button_Part_Reset:addInputEvent("Mouse_LUp", "clearCustomizedBoneInfo()")
	
CheckButton_ControlPart:addInputEvent("Mouse_LUp", "ToggleShowHairBoneControlPart()")
	
--  Open  함수  호출 시 
-- 기본 HairShapeUi Open
registerEvent("EventOpenHairShapeUi","OpenHairShapeUi")
registerEvent("EventCloseHairShapeUi","CloseHairShapeUi")

-- BoneControl 기능이 없는 HairShapeUi Open
registerEvent("EventOpenHairShapeUiWithoutBoneControl","OpenHairShapeUiWithoutBoneControl")
registerEvent("EventCloseHairShapeUiWithoutBoneControl","CloseHairShapeUiWithoutBoneControl")

-- hair bone 피킹 시
registerEvent("EventPickingHairBone", "PickingHairBone")
-- 헤어 본 변경 시 
registerEvent("EventAdjustHairBoneTranslation", "AdjustHairBoneTranslation")
registerEvent("EventAdjustHairBoneRotation", "AdjustHairBoneRotation")

registerEvent("EventEnableHairSlide", "EnableHairSlide")
------------------------------------------------------ 필요 변수 선언 및 정의 --------------------------------------------------

local transMin
local transMax
local currentTranslation

local rotMin
local rotMax
local currentRotation

local paramType = {}
local paramIndex = {}

local SculptingUIRect = 
{
	left,
	top,
	right,
	bottom
}

local selectedClassType =-1
local sliderContentsStartY = 125
--텍스트와 슬라이더 거리
local sliderTextGap = 3
local contentsGapHeight = 10

-- 선택된 클래스 , 
-- 현재 헤어 본 컨트롤은 특정 클래스(워리어,자이언츠)에 대해 본컨트롤UI가 들어가지 않으므로 
-- 이를 처리하기 위해 선택된 클래스를 저장함.
local selectedClassIndex

local param = {}
local paramMin = {}
local paramMax = {}
local paramDefault = {}

---------------------------------------------- local 함수 ---------------------------------------------
local UpdateHairBoneControls = function()
	if currentTranslation ~= nil then
		setValueSlider( Slider_TransX, currentTranslation.x, transMin.x, transMax.x )
		setValueSlider( Slider_TransY, currentTranslation.y, transMin.y, transMax.y )
		setValueSlider( Slider_TransZ, currentTranslation.z, transMin.z, transMax.z )
	end
	
	if currentRotation ~= nil then
		setValueSlider( Slider_RotX, currentRotation.x, rotMin.x, rotMax.x )
		setValueSlider( Slider_RotY, currentRotation.y, rotMin.y, rotMax.y )
		setValueSlider( Slider_RotZ, currentRotation.z, rotMin.z, rotMax.z )
	end
end

-- float 스트링 변환 함수 
local floatString = function( floatValue ) 
	return string.format(  "%.2f", floatValue )
end

local ShowBoneControls = function( show )
	StaticText_DefaultControl:SetShow(show)
	
	RadioButton_Bone_Trans:SetShow(show)
	StaticText_TransX:SetShow(show)
	StaticText_TransY:SetShow(show)
	StaticText_TransZ:SetShow(show)
	Slider_TransX:SetShow(show)
	Slider_TransY:SetShow(show)
	Slider_TransZ:SetShow(show)
	
	RadioButton_Bone_Rot:SetShow(show)
	StaticText_RotX:SetShow(show)
	StaticText_RotY:SetShow(show)
	StaticText_RotZ:SetShow(show)
	Slider_RotX:SetShow(show)
	Slider_RotY:SetShow(show)
	Slider_RotZ:SetShow(show)
	
	
	--StaticText_CurrValue_TransX:SetShow(show)
	--StaticText_CurrValue_TransY:SetShow(show)
	--StaticText_CurrValue_TransZ:SetShow(show)
	StaticText_ControlPart:SetShow(show)
	CheckButton_ControlPart:SetShow(show)
	Button_Part_Reset:SetShow(show)
	Button_All_Reset:SetShow(show)
end

local EnableSlide = function( static1, static2, slide, enable )

	local color = Defines.Color.C_FF444444
	if( enable ) then
		color = Defines.Color.C_FFFFFFFF
	end
	
	slide:SetMonoTone( not enable )
	slide:SetEnable( enable )
	static1:SetFontColor( color )
	static2:SetFontColor( color )
end

local UpdateHairRadioButtons = function(  updateControlMode )	
	if updateControlMode == 1 then
		RadioButton_Bone_Trans:SetCheck(true)
		RadioButton_Bone_Rot:SetCheck(false)
	elseif updateControlMode == 2 then
		RadioButton_Bone_Trans:SetCheck(false)
		RadioButton_Bone_Rot:SetCheck(true)
	end
end

---------------------------------------------- global 함수 ---------------------------------------------
-- 헤어 본 컨트롤 정보 업데이트
function UpdateHairBone( updateControlMode )
	
	if ControlMode ~= updateControlMode then
		UpdateHairRadioButtons( updateControlMode )
	end
	CursorSelect( updateControlMode )
	
	if updateControlMode == 1 then
		local x = calculateSliderValue( Slider_TransX, transMin.x, transMax.x )
		local y = calculateSliderValue( Slider_TransY, transMin.y, transMax.y )
		local z = calculateSliderValue( Slider_TransZ, transMin.z, transMax.z )
		currentTranslation.x = x
		currentTranslation.y = y
		currentTranslation.z = z
		applyTranslationValue( x, y, z )
--		StaticText_CurrValue_TransX:SetText( math.floor(x * 10)/10 )
--		StaticText_CurrValue_TransY:SetText( math.floor(y * 10)/10 )
--		StaticText_CurrValue_TransZ:SetText( math.floor(z * 10)/10 )
	elseif updateControlMode == 2 then
		local x = calculateSliderValue( Slider_RotX, rotMin.x, rotMax.x )
		local y = calculateSliderValue( Slider_RotY, rotMin.y, rotMax.y )
		local z = calculateSliderValue( Slider_RotZ, rotMin.z, rotMax.z )
		currentRotation.x = x
		currentRotation.y = y
		currentRotation.z = z
		applyRotationValue( x, y, z )
	end
end

-- 슬라이더 동작
function UpdateHairSlider( sliderIndex )

	local luaSliderIndex = sliderIndex + 1
	
	local value = getSliderValue( SliderArr[ luaSliderIndex ] , paramMin[ luaSliderIndex ], paramMax[ luaSliderIndex ] )
	setParam( selectedClassType, paramType[ luaSliderIndex ] , paramIndex[ luaSliderIndex ] , value )
	StaticText_CurrentValue[ luaSliderIndex ]:SetText( value )
	
end
----------------------------------------- 클라이언트에 의해 호출 되는 함수, global 함수 ---------------------------------------------------

--  헤어 shape UI 호출 시  호출되는 init 함수
function OpenHairShapeUi( classType, uiId )
	-- 1을 enumeration 화 해야한다.
	CameraLookEnable( false )
	CursorSelect(1)
	EnableHairSlide(false)
	startHairPickingMode()
	
	selectedClassType = classType
	
	ShowBoneControls( true )
	
	-- 각 슬라이더에 맵핑되어있는 param을 들고 온다.
	-- hair shape 경우 contents 는 무조껀 하나임
	local defaultContentsIndex = 0
	local sliderNum = getUiSliderCount( classType, uiId, defaultContentsIndex )
	
	-- 피킹 컨트롤이 없을 경우 contentsGapHeight 로 초기화
	local controlPosY = 206
	
	-- 컨트롤 부위 표시 위치 조절
	StaticText_ControlPart:SetPosY( controlPosY )
	controlPosY = controlPosY + 2
	CheckButton_ControlPart:SetPosY( controlPosY)
	
	-- 초기화 버튼 위치 조절
	controlPosY = controlPosY + CheckButton_ControlPart:GetSizeY() + 5
	Button_Part_Reset:SetPosY(controlPosY)
	Button_All_Reset:SetPosY(controlPosY)
	controlPosY = controlPosY+Button_Part_Reset:GetSizeY() + contentsGapHeight
	local meshParamType = 1
	local curlRange = getCurlLengthRange()

	for sliderIndex = 0 , sliderNum -1 do 
		local luaSliderIndex = sliderIndex + 1 
		
		paramType[ luaSliderIndex ] = 	getUiSliderParamType( classType, uiId, defaultContentsIndex, sliderIndex )
		paramIndex[ luaSliderIndex ] = 	getUiSliderParamIndex( classType, uiId, defaultContentsIndex, sliderIndex )	
		
		local sliderText = 		getUiSliderDescName( classType, uiId, defaultContentsIndex, sliderIndex )
		local param = getParam( paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )
		
		if sliderIndex >= 0 and sliderIndex < 3 then
			paramMin[luaSliderIndex] = getHairMinLength( sliderIndex )
			paramMax[luaSliderIndex] = getParamMax( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] ) 
			paramDefault[luaSliderIndex] = getParamDefault( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )	
			
			if paramMin[luaSliderIndex] == paramMax[luaSliderIndex] then 
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false )
				--Button_SliderArr[luaSliderIndex]:SetShow( false )
			else
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true )
				--Button_SliderArr[luaSliderIndex]:SetShow( true )
			end
		
		elseif sliderIndex == 3 then
			local curlRange = getCurlLengthRange()
			paramMin[luaSliderIndex] = 50 - curlRange/2
			paramMax[luaSliderIndex] = 50 + curlRange/2
			paramDefault[luaSliderIndex] = getParamDefault( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )	
			
			if curlRange == 0 then 
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false )
				--Button_SliderArr[luaSliderIndex]:SetShow( false )
			else
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true )
				--Button_SliderArr[luaSliderIndex]:SetShow( true )
			end
			
		elseif sliderIndex == 4 then
			paramMin[luaSliderIndex] = getParamMin( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )
			paramMax[luaSliderIndex] = getParamMax( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] ) 
			paramDefault[luaSliderIndex] = getParamDefault( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )	
			--Button_SliderArr[luaSliderIndex]:SetShow(   )	
			if curlRange == 0 then 
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false )
			else
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true )
			end
		end
		
		-- 슬라이더 값 및 텍스트 세팅
		StaticTextArr[luaSliderIndex]:SetText( PAGetString(Defines.StringSheet_GAME, sliderText) )
		StaticText_CurrentValue[luaSliderIndex]:SetText( param ) 
		setSliderValue( SliderArr[luaSliderIndex], param, paramMin[luaSliderIndex] , paramMax[luaSliderIndex] )

		-- 슬라이더 위치 세팅
		StaticTextArr[luaSliderIndex]:SetPosY( controlPosY )
		SliderArr[luaSliderIndex]:SetPosY( controlPosY + sliderTextGap )
		StaticText_CurrentValue[luaSliderIndex]:SetPosY( controlPosY + sliderTextGap )
		
		controlPosY = controlPosY + contentsGapHeight + StaticTextArr[luaSliderIndex]:GetSizeY()
	end
	
	Panel_CustomizationTransformHair:SetSize( Panel_CustomizationTransformHair:GetSizeX(), controlPosY )
	
	UpdateHairRadioButtons(1)
	
	updateGroupFrameControls(  Panel_CustomizationTransformHair:GetSizeY() , Panel_CustomizationTransformHair )
	ToggleShowHairBoneControlPart()
end

function OpenHairShapeUiWithoutBoneControl( classType, uiId )
	
	selectedClassType = classType
	CameraLookEnable( false ) 
	ShowBoneControls( false )
	
	-- 피킹 컨트롤이 없을 경우 contentsGapHeight 로 초기화
	local controlPosY = 10 
	
	local defaultContentsIndex = 0
	local sliderNum = getUiSliderCount( classType, uiId, defaultContentsIndex )
	local meshParamType = 1
	local curlRange = getCurlLengthRange()

	for sliderIndex = 0 , sliderNum -1 do 
		local luaSliderIndex = sliderIndex + 1 
		
		paramType[ luaSliderIndex ] = 	getUiSliderParamType( classType, uiId, defaultContentsIndex, sliderIndex )
		paramIndex[ luaSliderIndex ] = 	getUiSliderParamIndex( classType, uiId, defaultContentsIndex, sliderIndex )	
		
		local sliderText = 		getUiSliderDescName( classType, uiId, defaultContentsIndex, sliderIndex )
		local param = getParam( paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )
		
		if sliderIndex >= 0 and sliderIndex < 3 then
			paramMin[luaSliderIndex] = getHairMinLength( sliderIndex )
			paramMax[luaSliderIndex] = getParamMax( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] ) 
			paramDefault[luaSliderIndex] = getParamDefault( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )	
			
			if paramMin[luaSliderIndex] == paramMax[luaSliderIndex] then 
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false )
				--Button_SliderArr[luaSliderIndex]:SetShow( false )
			else
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true )
				--Button_SliderArr[luaSliderIndex]:SetShow( true )
			end
		
		elseif sliderIndex == 3 then
			paramMin[luaSliderIndex] = 50 - curlRange/2
			paramMax[luaSliderIndex] = 50 + curlRange/2
			paramDefault[luaSliderIndex] = getParamDefault( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )	
			
			if curlRange == 0 then 
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false )
				--Button_SliderArr[luaSliderIndex]:SetShow( false )
			else
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true )
				--Button_SliderArr[luaSliderIndex]:SetShow( true )
			end
			
		elseif sliderIndex == 4 then
			paramMin[luaSliderIndex] = getParamMin( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )
			paramMax[luaSliderIndex] = getParamMax( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] ) 
			paramDefault[luaSliderIndex] = getParamDefault( classType, paramType[ luaSliderIndex ], paramIndex[ luaSliderIndex ] )	
				
			--Button_SliderArr[luaSliderIndex]:SetShow( Button_SliderArr[luaSliderIndex - 1]:GetShow( )  )
			if curlRange == 0 then
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], false )
			else
				EnableSlide( StaticTextArr[luaSliderIndex], StaticText_CurrentValue[luaSliderIndex], SliderArr[luaSliderIndex], true )
			end
		end

	-- 슬라이더 값 및 텍스트 세팅
		StaticTextArr[luaSliderIndex]:SetText( PAGetString(Defines.StringSheet_GAME, sliderText) )
		StaticText_CurrentValue[luaSliderIndex]:SetText( param ) 
		setSliderValue( SliderArr[luaSliderIndex], param, paramMin[luaSliderIndex] , paramMax[luaSliderIndex] )

		-- 슬라이더 위치 세팅
		StaticTextArr[luaSliderIndex]:SetPosY( controlPosY )
		SliderArr[luaSliderIndex]:SetPosY( controlPosY + sliderTextGap )
		StaticText_CurrentValue[luaSliderIndex]:SetPosY( controlPosY + sliderTextGap )
		
		controlPosY = controlPosY + contentsGapHeight + StaticTextArr[luaSliderIndex]:GetSizeY()
	end
	
	Panel_CustomizationTransformHair:SetSize( Panel_CustomizationTransformHair:GetSizeX(), controlPosY )
	
	updateGroupFrameControls(  Panel_CustomizationTransformHair:GetSizeY() , Panel_CustomizationTransformHair )
end

-- 헤어 본 컨트롤 파트 표시 flag
function ToggleShowHairBoneControlPart()
	showBoneControlPart( CheckButton_ControlPart:IsCheck() )
end

-- 특정 본은 Picking 시 호출 
function PickingHairBone( )
	
	EnableHairSlide( true )
	transMin 	= getSelectedBoneMinTrans()
	transMax 	= getSelectedBoneMaxTrans()
	currentTranslation	= getSelectedBoneTrans()
	
	rotMin 	= getSelectedBoneMinRot()
	rotMax 	= getSelectedBoneMaxRot()
	currentRotation	= getSelectedBoneRot()
	
	if currentTranslation ~= nil then
		setValueSlider( Slider_TransX, currentTranslation.x, transMin.x, transMax.x )
		setValueSlider( Slider_TransY, currentTranslation.y, transMin.y, transMax.y )
		setValueSlider( Slider_TransZ, currentTranslation.z, transMin.z, transMax.z )
	end
	
	if currentRotation ~= nil then
		setValueSlider( Slider_RotX, currentRotation.x, rotMin.x, rotMax.x )
		setValueSlider( Slider_RotY, currentRotation.y, rotMin.y, rotMax.y )
		setValueSlider( Slider_RotZ, currentRotation.z, rotMin.z, rotMax.z )
	end
	
end 

function EnableHairSlide( enable )
	Slider_TransX:SetEnable( enable )
	Slider_TransY:SetEnable( enable )
	Slider_TransZ:SetEnable( enable )
	
	Button_Slider_TransX:SetMonoTone( not enable )
	Button_Slider_TransY:SetMonoTone( not enable )
	Button_Slider_TransZ:SetMonoTone( not enable )

	Slider_RotX:SetEnable( enable )
	Slider_RotY:SetEnable( enable )
	Slider_RotZ:SetEnable( enable )	
	
	Button_Slider_RotX:SetMonoTone( not enable ) 
	Button_Slider_RotY:SetMonoTone( not enable )
	Button_Slider_RotZ:SetMonoTone( not enable )
	
	local color = Defines.Color.C_FF444444
	if( enable ) then
		color = Defines.Color.C_FFFFFFFF
	end
	
	StaticText_CurrValue_TransX:SetFontColor( color )
	StaticText_CurrValue_TransY:SetFontColor( color )
	StaticText_CurrValue_TransZ:SetFontColor( color )
	
	StaticText_TransX:SetFontColor( color )
	StaticText_TransY:SetFontColor( color )
	StaticText_TransZ:SetFontColor( color )
		
	StaticText_RotX:SetFontColor( color )
	StaticText_RotY:SetFontColor( color )
	StaticText_RotZ:SetFontColor( color )

end

-- bone 컨트롤에 따른 translation 적용
function AdjustHairBoneTranslation( translationX, translationY, translationZ )

	setValueSlider( Slider_TransX, translationX, transMin.x, transMax.x)
	StaticText_CurrValue_TransX:SetText( math.floor(translationX * 10)/10 )
	
	setValueSlider( Slider_TransY, translationY, transMin.y, transMax.y)
	StaticText_CurrValue_TransY:SetText( math.floor(translationY * 10)/10 )
	
	setValueSlider( Slider_TransZ, translationZ, transMin.z, transMax.z)
	StaticText_CurrValue_TransZ:SetText( math.floor(translationZ * 10)/10 )
	
	currentTranslation.x = translationX
	currentTranslation.y = translationY
	currentTranslation.z = translationZ
end

function AdjustHairBoneRotation( rotationX, rotationY, rotationZ )
	setValueSlider( Slider_RotX, rotationX, rotMin.x, rotMax.x)
	setValueSlider( Slider_RotY, rotationY, rotMin.y, rotMax.y)
	setValueSlider( Slider_RotZ, rotationZ, rotMin.z, rotMax.z)	
	
	currentRotation.x = rotationX
	currentRotation.y = rotationY
	currentRotation.z = rotationZ
	
end

function CloseHairShapeUi()
	endPickingMode()
	CameraLookEnable( true )
end

function CloseHairShapeUiWithoutBoneControl()
	CameraLookEnable( true )
end
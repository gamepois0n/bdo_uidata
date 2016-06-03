-----------------------------------------------------------------------------------------------------------------------------
-- ( 라디오 버튼 컨트롤, 이미지 리스트 컨트롤, 슬라이더 컨트롤, 팔레트 컨트롤 ) 이 차례대로 나오는 커스터마이징 Ui 용 파일

---------------------------------------------------- UI Control 등록 ------------------------------------------------------
local NoCashType = CppEnums.CustomizationNoCashType
local NoCashDeco = CppEnums.CustomizationNoCashDeco

local isTattooMode = false

local FrameTemplate				= UI.getChildControl(Panel_Customization_Common_Decoration, "Frame_Template")
local Frame_Content				= UI.getChildControl(FrameTemplate, "Frame_Content")
local Frame_ContentImage    	= UI.getChildControl(Frame_Content, "Frame_Content_Image")
local Frame_Scroll          	= UI.getChildControl(FrameTemplate, "Frame_Scroll")
local Static_SelectMark			= UI.getChildControl(Frame_Content, "Static_SelectMark")
local Static_PayMark 			= UI.getChildControl(Frame_Content, "Static_PayMark")

local FrameTemplateColor		= UI.getChildControl(Panel_Customization_Common_Decoration, "Frame_Template_Color")
local Static_Collision			= UI.getChildControl( Panel_Customization_Common_Decoration, "Static_Collision" )
local RadioButton_Template		= UI.getChildControl(Panel_Customization_Common_Decoration, "RadioButton_Template")

local SliderControlArr = {}
local SliderButtonArr = {}
local SliderTextArr = {}
local SliderValueArr = {}
local CheckControlArr = {}
local CheckTextArr = {}



CheckControlArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "CheckButton_Left")
CheckControlArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "CheckButton_Right")

CheckTextArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_EyeLeft")
CheckTextArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_EyeRight")

SliderControlArr[1]	= UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control1")
SliderControlArr[2]	= UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control2")
SliderControlArr[3]	= UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control3")
SliderControlArr[4]	= UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control4")
SliderControlArr[5]	= UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control5")
SliderControlArr[6]	= UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control6")
SliderControlArr[7]	= UI.getChildControl(Panel_Customization_Common_Decoration, "Slider_Control7")

SliderButtonArr[1] = UI.getChildControl(SliderControlArr[1], "Slider_GammaController_Button")
SliderButtonArr[2] = UI.getChildControl(SliderControlArr[2], "Slider_GammaController_Button")
SliderButtonArr[3] = UI.getChildControl(SliderControlArr[3], "Slider_GammaController_Button")
SliderButtonArr[4] = UI.getChildControl(SliderControlArr[4], "Slider_GammaController_Button")
SliderButtonArr[5] = UI.getChildControl(SliderControlArr[5], "Slider_GammaController_Button")
SliderButtonArr[6] = UI.getChildControl(SliderControlArr[6], "Slider_GammaController_Button")
SliderButtonArr[7] = UI.getChildControl(SliderControlArr[7], "Slider_GammaController_Button")

SliderTextArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText1")
SliderTextArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText2")
SliderTextArr[3] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText3")
SliderTextArr[4] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText4")
SliderTextArr[5] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText5")
SliderTextArr[6] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText6")
SliderTextArr[7] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderText7")

SliderValueArr[1] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue1")
SliderValueArr[2] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue2")
SliderValueArr[3] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue3")
SliderValueArr[4] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue4")
SliderValueArr[5] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue5")
SliderValueArr[6] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue6")
SliderValueArr[7] = UI.getChildControl(Panel_Customization_Common_Decoration, "StaticText_SliderValue7")
----------------
local sliderParamType = {}
local sliderParamIndex = {}
local sliderParamIndex2 = {}

local sliderParam = {}
local sliderParamMin = {}
local sliderParamMax = {}
local sliderParamDefault = {}
---------------------------------------------------- UI control 초기값 설정 -------------------------------------------------------
CheckTextArr[1]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONEYE_EYELEFT"))	-- 왼쪽 눈
CheckTextArr[2]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONEYE_EYERIGHT"))	-- 오른쪽 눈
------------------------------------------------------- Event 등록 -----------------------------------------------------
-- registerEvent
registerEvent("EventOpenCommonDecorationUi", "OpenCommonDecorationUi")
registerEvent("EventCloseCommonDecorationUi", "CloseCommonDecorationUi")
registerEvent("EventOpenEyeDecorationUi", "OpenEyeDecorationUi")
registerEvent("EventCloseEyeDecorationUi", "CloseEyeDecorationUi")
registerEvent("EventOpenTattooDecorationUi", "OpenTattooDecorationUi")
registerEvent("EventCloseTattooDecorationUi", "CloseTattooDecorationUi")
registerEvent("EventEnableDecorationSlide", "EnableDecorationSlide")

registerEvent("EventOpenCommonExpressionUi", "OpenCommonExpressionUi")
registerEvent("EventCloseCommonExpressionUi", "CloseCommonExpressionUi")

------------------------------------------------------ 필요 변수 선언 및 정의 --------------------------------------------------


--선택되는 클래스 타입
local selectedClassType			= nil
local selectedUiId				= nil

local selectedListParamType 	= nil
local selectedListParamIndex 	= nil
local selectedItemIndex 		= nil
-----------------------------------------
local ContentImage 		= {}
local PayMark			= {}
local decoGroup 		= {}
local RadioButtonGroup 	= {}

-- 선택된 화장 그룹 인덱스 
local selectedDecoGroupIdx = 0
local selectedDecoPartIdx = 0 

local luaSelectedDecoGroupIdx = 0


local contentsStartY = 0
-- 컨텐츠 컨트롤 사이 gap
local controlOffset = 10

-- 라디오 버튼 관련 위치 값들
local radioButtonStartX = 10 
local radioButtonStartY = 10
local radioButtonColumnNum = 3
local radioButtonGap = 2
local radioButtonColumnWidth = RadioButton_Template:GetSizeX() + radioButtonGap
local radioButtonColumnHeight = RadioButton_Template:GetSizeY() + radioButtonGap

-- list 컨트롤 관련 위치 값들
local imageFrameSizeY = 125
local listColumCount = 4
local listOffset = 10
local listColumnWidth = Frame_ContentImage:GetSizeX() + listOffset
local listColumnHeight = Frame_ContentImage:GetSizeY() + listOffset
local listStartX = 10
local listStartY = 10

-- slider 관련 위치 값들
local sliderOffset = 7
local sliderValueOffset = 10
local sliderHeight = SliderTextArr[ 1 ]:GetSizeY()

-- color picker 관련 위치 값들
local colorPickerStartY = 370

------------------------------------------------------- local 함수 ---------------------------------------------

-- shape 선택 마크 표시 함수 
local UpdateMarkPosition = function( shapeIdx ) 
	if( FrameTemplate:GetShow() ) then
		if shapeIdx ~= -1 then
			Static_SelectMark:SetShow(true)
			Static_SelectMark:SetPosX( shapeIdx % listColumCount * listColumnWidth+ listStartX )
			Static_SelectMark:SetPosY( math.floor( shapeIdx / listColumCount )  *listColumnHeight + listStartY )
		else
			Static_SelectMark:SetShow(false)
		end
	end
end

-- 라디오 버튼 clear 함수 
local clearRadioButtons = function()
	for _, rb in pairs( RadioButtonGroup ) do
		rb:SetShow(false)
		UI.deleteControl(rb)
	end
	RadioButtonGroup = {}
end

-- shapeImage clear함수
local clearContents = function()
	
	for _, content in pairs( ContentImage ) do
		content:SetShow(false)
		UI.deleteControl(content)
	end
	ContentImage = {}

	for _, content in pairs( PayMark ) do
		content:SetShow(false)
		UI.deleteControl(content)
	end	
	PayMark = {}	
	for index = 1, 7 do
		SliderControlArr[ index ]:SetShow(false)
		SliderTextArr[ index ]:SetShow(false)
		SliderValueArr[ index ]:SetShow(false)
	end
	
	Static_Collision:SetShow( false )
	FrameTemplate:SetShow( false ) 
	Frame_Content:SetSize(Frame_Content:GetSizeX(), 0)
end

------------------------------------------------------- Global 함수 ---------------------------------------------
-- ui open 함수
function OpenCommonDecorationUi( classType, uiId )
	clearRadioButtons()
	
	CheckControlArr[1]:SetShow( false )
	CheckControlArr[2]:SetShow( false )
	CheckTextArr[1]:SetShow( false )
	CheckTextArr[2]:SetShow( false )
	
	selectedClassType = classType
	selectedUiId = uiId
	FrameTemplateColor:SetSize( Panel_Customization_Common_Decoration:GetSizeX(), 0 )
	FrameTemplateColor:SetShow( false )
	-- contents 수에 맞춰서 radio  버튼 생성
	local contentsCount = getUiContentsCount( classType, uiId )
	if contentsCount > 1 then
		for contentsIndex = 0, contentsCount -1 do
			local luaContentsIndex = contentsIndex + 1
			
			local tempRadioButton = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, Panel_Customization_Common_Decoration, "RadioButton_"..luaContentsIndex )
			CopyBaseProperty( RadioButton_Template, tempRadioButton)

			local contentsDesc = getUiContentsDescName( classType, uiId, contentsIndex )
			tempRadioButton:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
			tempRadioButton:SetText( PAGetString( Defines.StringSheet_GAME, contentsDesc ) )
			tempRadioButton:SetPosX( radioButtonStartX + ( contentsIndex % radioButtonColumnNum) * radioButtonColumnWidth )
			tempRadioButton:SetPosY( radioButtonStartY + math.floor( contentsIndex / radioButtonColumnNum ) * radioButtonColumnHeight )
			tempRadioButton:addInputEvent("Mouse_LUp", "UpdateDecorationContents(" .. contentsIndex ..  ")" )
			tempRadioButton:SetShow( true )
			
			RadioButtonGroup[ luaContentsIndex ] = tempRadioButton		
		end
		
		local radioButtonRowCount =  1 + math.floor( (contentsCount -1) / radioButtonColumnNum )  
		contentsStartY = controlOffset + radioButtonRowCount * RadioButton_Template:GetSizeY() + controlOffset
	else
		contentsStartY = controlOffset
	end

	
	
	if contentsCount > 1 then
		RadioButtonGroup[1]:SetCheck( true )
	end
	UpdateDecorationContents( 0 )
end

function CloseCommonDecorationUi()
	EnableDecorationSlide( true )
end

function CloseEyeDecorationUi()
end

-- Contents Ui( 이미지 리스트 컨트롤, 슬라이더 컨트롤, 팔레트 컨트롤 ) 업데이트 함수
function UpdateDecorationContents( contentsIndex )
	clearContents()
	local texSize = 193/4
	local controlPosY = contentsStartY
	-- 현재는 리스트 컨트롤이 한 컨텐츠 내에 두개 이상 가지는 경우는 없다.
	local listCount = getUiListCount( selectedClassType, selectedUiId, contentsIndex )
	if listCount == 1 then
		local listIndex = 0
		local luaListIndex = listIndex + 1 
		
		local listTexture = getUiListTextureName( selectedClassType, selectedUiId, contentsIndex, listIndex )

		local listParamType = getUiListParamType( selectedClassType, selectedUiId, contentsIndex, listIndex )
		local listParamIndex = getUiListParamIndex( selectedClassType, selectedUiId, contentsIndex, listIndex )
		
		-- paramMax 만큼 이미지 리스트를 만든다.
		local paramMax = getParamMax( selectedClassType, listParamType, listParamIndex )		
		
		for itemIndex = 0, paramMax do
			local luaShapeIdx = itemIndex + 1
			local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Frame_Content, "Frame_Image_" .. itemIndex )
			CopyBaseProperty ( Frame_ContentImage, tempContentImage )
			tempContentImage:addInputEvent( "Mouse_LUp", "UpdateDecorationListMessage(" ..listParamType.. "," ..listParamIndex.. "," ..itemIndex.. ")" )
			
			local staticPayMark = nil
			if(NoCashType.eCustomizationNoCashType_Deco ==  listParamType) and (NoCashDeco.eCustomizationNoCashDeco_FaceTattoo == listParamIndex or NoCashDeco.eCustomizationNoCashDeco_BodyTattoo == listParamIndex) then
				staticPayMark = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempContentImage, "Static_PayMark_"..itemIndex )
				CopyBaseProperty ( Static_PayMark, staticPayMark )
			end
			
			
			-- 이미지 세팅
			local mod = itemIndex % listColumCount
			local divi = math.floor( itemIndex / listColumCount )
			local texUV = { x1, y1, x2, y2 }
			texUV.x1 = mod * texSize
			texUV.y1 = divi * texSize
			texUV.x2 = texUV.x1 + texSize
			texUV.y2 = texUV.y1 + texSize
			tempContentImage:ChangeTextureInfoName( listTexture )
			local x1, y1, x2, y2 = setTextureUV_Func( tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2 )
			tempContentImage:getBaseTexture():setUV( x1, y1, x2, y2 )
			tempContentImage:SetPosX( itemIndex%listColumCount * listColumnWidth + listStartX )
			tempContentImage:SetPosY( math.floor(itemIndex/listColumCount) * listColumnHeight + listStartY )
			tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
			if ((not FGlobal_IsCommercialService()) and (not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, itemIndex))) then
				tempContentImage:SetShow( false )
			else
				if(not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, itemIndex)) and (not FGlobal_IsInGameMode()) and ( isServerFixedCharge() ) then
					tempContentImage:SetShow( false )
				else
					tempContentImage:SetShow( true )
				end
			end
			
			if(NoCashType.eCustomizationNoCashType_Deco ==  listParamType) and (NoCashDeco.eCustomizationNoCashDeco_FaceTattoo == listParamIndex or NoCashDeco.eCustomizationNoCashDeco_BodyTattoo == listParamIndex) then
				if(not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, itemIndex)) then
					staticPayMark:SetShow( true )
				else
					staticPayMark:SetShow( false )
				end	
			end	
				
			ContentImage[luaShapeIdx] 	= tempContentImage
			PayMark[luaShapeIdx]		= staticPayMark
		end		
		
		local param = getParam( listParamType, listParamIndex )
		
		selectedListParamType		= listParamType
		selectedListParamIndex		= listParamIndex
		selectedItemIndex			= param

		FrameTemplate:SetShow( true ) 
		FrameTemplate:SetPosY( controlPosY )
	
		if paramMax < listColumCount then
			FrameTemplate:SetSize( FrameTemplate:GetSizeX(), imageFrameSizeY- listColumnHeight )
		else
			FrameTemplate:SetSize( FrameTemplate:GetSizeX(), imageFrameSizeY )
		end
		controlPosY = controlPosY + FrameTemplate:GetSizeY() + controlOffset
	end
	
	if( listCount > 0 ) then
		UpdateDecorationList()
	end
	
	-- 슬라이더 컨트롤 세팅
	local sliderCount = getUiSliderCount( selectedClassType, selectedUiId, contentsIndex )
	
	for sliderIndex = 0 , sliderCount - 1 do	
		local luaSliderIndex = sliderIndex + 1 		
	
		sliderParamType[ luaSliderIndex ] = 	getUiSliderParamType( selectedClassType, selectedUiId, contentsIndex, sliderIndex )
		sliderParamIndex[ luaSliderIndex ] = 	getUiSliderParamIndex( selectedClassType, selectedUiId, contentsIndex, sliderIndex )	
		
		local sliderParam = getParam( sliderParamType[ luaSliderIndex ], sliderParamIndex[ luaSliderIndex ] )
		sliderParamMin[luaSliderIndex] = getParamMin( selectedClassType, sliderParamType[ luaSliderIndex ], sliderParamIndex[ luaSliderIndex ] )
		sliderParamMax[luaSliderIndex] = getParamMax( selectedClassType, sliderParamType[ luaSliderIndex ], sliderParamIndex[ luaSliderIndex ] ) 
		sliderParamDefault[luaSliderIndex] = getParamDefault( selectedClassType, sliderParamType[ luaSliderIndex ], sliderParamIndex[ luaSliderIndex ] )	
	
		--슬라이더 값 설정
		setSliderValue( SliderControlArr[ luaSliderIndex ] , sliderParam, sliderParamMin[luaSliderIndex], sliderParamMax[luaSliderIndex] )
		SliderButtonArr[ luaSliderIndex ]:addInputEvent("Mouse_LPress", "UpdateDecorationSlider(".. sliderIndex .. ")")
		SliderControlArr[ luaSliderIndex ]:addInputEvent("Mouse_LPress", "UpdateDecorationSlider(".. sliderIndex .. ")")
		
		local sliderDesc = getUiSliderDescName( selectedClassType, selectedUiId, contentsIndex, sliderIndex )
		SliderTextArr[ luaSliderIndex ]:SetText( PAGetString(Defines.StringSheet_GAME, sliderDesc) )
		SliderTextArr[ luaSliderIndex ]:SetPosY( controlPosY )
		SliderTextArr[ luaSliderIndex ]:SetShow( true )

		SliderControlArr[ luaSliderIndex ]:SetPosY( controlPosY + sliderOffset )
		SliderControlArr[ luaSliderIndex ]:SetShow( true )
		
		SliderValueArr[ luaSliderIndex ]:SetText( sliderParam ) 
		SliderValueArr[ luaSliderIndex ]:SetPosY( controlPosY + sliderValueOffset ) 
		SliderValueArr[ luaSliderIndex ]:SetShow( true )
		
		controlPosY = controlPosY + sliderHeight
	end
	
	local paletteCount = getUiPaletteCount( selectedClassType, selectedUiId, contentsIndex )
	if paletteCount == 1 then
		-- 컬러 피커 위치 생성 및 위치 설정
		controlPosY = controlPosY + controlOffset
		
		-- 팔레트 인덱스는 현재 paramDesc 내에 정의되는데 지금으로선 획득 방법이 애매하다.
	
		local paletteParamType = getUiPaletteParamType( selectedClassType, selectedUiId, contentsIndex ) 
		local paletteParamIndex = getUiPaletteParamIndex( selectedClassType, selectedUiId, contentsIndex ) 
		local paletteIndex = getDecorationParamMethodValue( selectedClassType, paletteParamType, paletteParamIndex )
		-- 팔레트 생성
		FrameTemplateColor:SetShow( true )
		FrameTemplateColor:SetPosY( controlPosY )
		CreateCommonPalette( FrameTemplateColor, Static_Collision, selectedClassType, paletteParamType, paletteParamIndex, paletteIndex )
		
		local colorIndex = getParam( paletteParamType, paletteParamIndex )		
		-- 인덱스로 컬러 현재 선택 보여주기 추가해야함.
		UpdatePaletteMarkPosition( colorIndex )
		
		local Frame_Content_Color	= UI.getChildControl(FrameTemplateColor, "Frame_Content")
		Static_SelectMark_Color = UI.getChildControl(Frame_Content_Color, "Static_SelectMark")
		Frame_Content_Color:SetChildIndex( Static_SelectMark_Color, 9999 )
	else
		clearPalette()
	end
	Panel_Customization_Common_Decoration:SetSize( Panel_Customization_Common_Decoration:GetSizeX(), controlPosY + FrameTemplateColor:GetSizeY() + controlOffset )

	-- 커스터마이징 프레임 업데이트 
	updateGroupFrameControls( Panel_Customization_Common_Decoration:GetSizeY(), Panel_Customization_Common_Decoration )

	--UpdatePaletteMarkPosition( color )
	Panel_Customization_Common_Decoration:SetShow(true)
	FrameTemplateColor:UpdateContentScroll()
	FrameTemplateColor:UpdateContentPos()
	
	FrameTemplate:UpdateContentScroll()
	Frame_Scroll:SetControlTop()
	FrameTemplate:UpdateContentPos()
end 

function UpdateDecorationListMessage( paramType , paramIndex , itemIndex )
	selectedListParamType		= paramType
	selectedListParamIndex		= paramIndex
	selectedItemIndex			= itemIndex
	
	local fp
	
	if( isTattooMode ) then
		fp = UpdateTattooAtlasList
	else
		fp = UpdateDecorationList
	end
--{ 메시지 박스를 두개를 띄웠을 때 두번쨰 띄운 정렬이 middle로 고정되어서 allClearMessageData() 해줌.
	if Panel_Win_System:GetShow() then
		MessageBox_Empty_function()
		allClearMessageData()
	end	
--}
	if(NoCashType.eCustomizationNoCashType_Deco ==  paramType) and (NoCashDeco.eCustomizationNoCashDeco_FaceTattoo == paramIndex or NoCashDeco.eCustomizationNoCashDeco_BodyTattoo == paramIndex) then
		if ((not FGlobal_IsInGameMode()) and (not isNormalCustomizingIndex(selectedClassType, selectedListParamType, selectedListParamIndex, selectedItemIndex))) then
			local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_CASHITEM")
			local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = fp, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData, "top")
			return
		end
	end
	
	if(4 ==  paramType) then
			local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_EXPRESSION")
			local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = fp, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData, "top")
			return
	end
	
	
	if( isTattooMode ) then
		slideEnable =  getEnableTattooSlide(selectedClassType, selectedListParamType , selectedListParamIndex , selectedItemIndex)
		EnableDecorationSlide( slideEnable )
	end
	UpdateDecorationList()
end

function UpdateTattooAtlasList()
	slideEnable =  getEnableTattooSlide(selectedClassType, selectedListParamType , selectedListParamIndex , selectedItemIndex)
	EnableDecorationSlide( slideEnable )
	setParam( selectedClassType, selectedListParamType , selectedListParamIndex , selectedItemIndex )
	UpdateMarkPosition( selectedItemIndex )
end

function UpdateDecorationList()
	setParam( selectedClassType, selectedListParamType , selectedListParamIndex , selectedItemIndex )
	UpdateMarkPosition( selectedItemIndex )
end

function UpdateDecorationSlider( sliderIndex )
	local luaSliderIndex = sliderIndex + 1
	
	local value = getSliderValue( SliderControlArr[ luaSliderIndex ] , sliderParamMin[ luaSliderIndex ], sliderParamMax[ luaSliderIndex ] )
	setParam( selectedClassType, sliderParamType[ luaSliderIndex ] , sliderParamIndex[ luaSliderIndex ] , value )
	SliderValueArr[ luaSliderIndex ]:SetText( value )
end
 
function UpdateHairDecorationSlider( sliderIndex )

--	local luaSliderIndex = sliderIndex + 1
	
--	local value = getSliderValue( SliderArr[ luaSliderIndex ] , paramMin[ luaSliderIndex ], paramMax[ luaSliderIndex ] )
--	value = math.floor(value) 
--	setParam( selectedClassType, paramType[ luaSliderIndex ] , paramIndex[ luaSliderIndex ] , value )
--	StaticText_CurrentValue[ luaSliderIndex ]:SetText( value )
	-- _PA_LOG( "lua_debug" , "UpdateHairDecorationSlider("..sliderIndex.. ")" )
end


--------------------Eye
-- ui open 함수
function OpenEyeDecorationUi( classType, uiId )
	clearRadioButtons()
	
	CheckControlArr[1]:SetShow( true )
	CheckControlArr[2]:SetShow( true )
	CheckControlArr[1]:SetCheck( true )
	CheckControlArr[2]:SetCheck( true )
	CheckTextArr[1]:SetShow( true )
	CheckTextArr[2]:SetShow( true )
	contentsStartY = 0
	contentsStartY = contentsStartY + CheckControlArr[1]:GetSizeY() + controlOffset
	
	selectedClassType = classType
	selectedUiId = uiId
	FrameTemplateColor:SetSize( Panel_Customization_Common_Decoration:GetSizeX(), 1 )
	-- contents 수에 맞춰서 radio  버튼 생성
	local contentsCount = getUiContentsCount( classType, uiId ) / 2
	-- UI.debugMessage( contentsCount )
	if contentsCount > 1 then
		for contentsIndex = 0, contentsCount -1 do
			local luaContentsIndex = contentsIndex + 1
			
			local tempRadioButton = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, Panel_Customization_Common_Decoration, "RadioButton_"..luaContentsIndex )
			CopyBaseProperty( RadioButton_Template, tempRadioButton)

			local contentsDesc = getUiContentsDescName( classType, uiId, contentsIndex )
			
			tempRadioButton:SetText( PAGetString( Defines.StringSheet_GAME, contentsDesc ) )
			tempRadioButton:SetPosX( radioButtonStartX + ( contentsIndex % radioButtonColumnNum) * radioButtonColumnWidth )
			tempRadioButton:SetPosY( contentsStartY + radioButtonStartY + math.floor( contentsIndex / radioButtonColumnNum ) * radioButtonColumnHeight )
			tempRadioButton:addInputEvent("Mouse_LUp", "UpdateEyeDecorationContents(" .. contentsIndex ..  ")" )
			tempRadioButton:SetShow( true )
			
			RadioButtonGroup[ luaContentsIndex ] = tempRadioButton		
		end
		
		local radioButtonRowCount =  1 + math.floor( (contentsCount -1) / radioButtonColumnNum )  
		contentsStartY = contentsStartY + controlOffset + radioButtonRowCount * RadioButton_Template:GetSizeY() + controlOffset
	else
		contentsStartY = contentsStartY + controlOffset
	end

	
	
	if contentsCount > 1 then
		RadioButtonGroup[1]:SetCheck( true )
	end
	UpdateEyeDecorationContents( 0 )
end

-- Contents Ui( 이미지 리스트 컨트롤, 슬라이더 컨트롤, 팔레트 컨트롤 ) 업데이트 함수
function UpdateEyeDecorationContents( contentsIndex )
	clearContents()
	local texSize = 193/4
	local controlPosY = contentsStartY
	-- 현재는 리스트 컨트롤이 한 컨텐츠 내에 두개 이상 가지는 경우는 없다.
	local listCount = getUiListCount( selectedClassType, selectedUiId, contentsIndex )
	if listCount == 1 then
		local listIndex = 0
		local luaListIndex = listIndex + 1 
		
		local listTexture = getUiListTextureName( selectedClassType, selectedUiId, contentsIndex, listIndex )

		local listParamType = getUiListParamType( selectedClassType, selectedUiId, contentsIndex, listIndex )
		local listParamIndex = getUiListParamIndex( selectedClassType, selectedUiId, contentsIndex, listIndex )
		local listParamIndex2 = getUiListParamIndex( selectedClassType, selectedUiId, contentsIndex+3, listIndex )
		
		FrameTemplate:SetShow( true )
		-- paramMax 만큼 이미지 리스트를 만든다.
		local paramMax = getParamMax( selectedClassType, listParamType, listParamIndex )		
		
		for itemIndex = 0, paramMax do
			local luaShapeIdx = itemIndex + 1
			local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Frame_Content, "Frame_Image_" .. itemIndex )

			CopyBaseProperty ( Frame_ContentImage, tempContentImage )
			tempContentImage:addInputEvent( "Mouse_LUp", "UpdateEyeDecorationList(" ..listParamType.. "," ..listParamIndex.. "," .. listParamIndex2 .. "," ..itemIndex.. ")" )
			
			-- 이미지 세팅
			local mod = itemIndex % listColumCount
			local divi = math.floor( itemIndex / listColumCount )
			local texUV = { x1, y1, x2, y2 }
			texUV.x1 = mod * texSize
			texUV.y1 = divi * texSize
			texUV.x2 = texUV.x1 + texSize
			texUV.y2 = texUV.y1 + texSize
			tempContentImage:ChangeTextureInfoName( listTexture )
			local x1, y1, x2, y2 = setTextureUV_Func( tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2 )
			tempContentImage:getBaseTexture():setUV( x1, y1, x2, y2 )
			tempContentImage:SetPosX( itemIndex%listColumCount * listColumnWidth + listStartX )
			tempContentImage:SetPosY( math.floor(itemIndex/listColumCount) * listColumnHeight + listStartY )
			tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
			tempContentImage:SetShow( true )
			
			ContentImage[luaShapeIdx] = tempContentImage
		end		
		
		local param = getParam( listParamType, listParamIndex )
		UpdateMarkPosition( param )
		FrameTemplate:SetPosY( controlPosY )
		
		if paramMax < listColumCount then
			FrameTemplate:SetSize( FrameTemplate:GetSizeX(), imageFrameSizeY- listColumnHeight )
		else
			FrameTemplate:SetSize( FrameTemplate:GetSizeX(), imageFrameSizeY )
		end
		
		controlPosY = controlPosY + FrameTemplate:GetSizeY() + controlOffset
	end
	
	-- 슬라이더 컨트롤 세팅
	local sliderCount = getUiSliderCount( selectedClassType, selectedUiId, contentsIndex )
	
	for sliderIndex = 0 , sliderCount - 1 do	
		local luaSliderIndex = sliderIndex + 1 		
	
		sliderParamType[ luaSliderIndex ] = 	getUiSliderParamType( selectedClassType, selectedUiId, contentsIndex, sliderIndex )
		sliderParamIndex[ luaSliderIndex ] = 	getUiSliderParamIndex( selectedClassType, selectedUiId, contentsIndex, sliderIndex )	
		sliderParamIndex2[ luaSliderIndex ] = 	getUiSliderParamIndex( selectedClassType, selectedUiId, contentsIndex + 3, sliderIndex )	
		
		local sliderParam = getParam( sliderParamType[ luaSliderIndex ], sliderParamIndex[ luaSliderIndex ] )
		sliderParamMin[luaSliderIndex] = getParamMin( selectedClassType, sliderParamType[ luaSliderIndex ], sliderParamIndex[ luaSliderIndex ] )
		sliderParamMax[luaSliderIndex] = getParamMax( selectedClassType, sliderParamType[ luaSliderIndex ], sliderParamIndex[ luaSliderIndex ] ) 
		sliderParamDefault[luaSliderIndex] = getParamDefault( selectedClassType, sliderParamType[ luaSliderIndex ], sliderParamIndex[ luaSliderIndex ] )	
	
		--슬라이더 값 설정
		setSliderValue( SliderControlArr[ luaSliderIndex ] , sliderParam, sliderParamMin[luaSliderIndex], sliderParamMax[luaSliderIndex] )
		SliderButtonArr[ luaSliderIndex ]:addInputEvent("Mouse_LPress", "UpdateEyeDecorationSlider(".. sliderIndex .. ")")
		
		local sliderDesc = getUiSliderDescName( selectedClassType, selectedUiId, contentsIndex, sliderIndex )
		SliderTextArr[ luaSliderIndex ]:SetText( PAGetString(Defines.StringSheet_GAME, sliderDesc) )
		SliderTextArr[ luaSliderIndex ]:SetPosY( controlPosY )
		SliderTextArr[ luaSliderIndex ]:SetShow( true )

		SliderControlArr[ luaSliderIndex ]:SetPosY( controlPosY + sliderOffset )
		SliderControlArr[ luaSliderIndex ]:SetShow( true )
		
		SliderValueArr[ luaSliderIndex ]:SetText( sliderParam ) 
		SliderValueArr[ luaSliderIndex ]:SetPosY( controlPosY + sliderValueOffset ) 
		SliderValueArr[ luaSliderIndex ]:SetShow( true )
		
		controlPosY = controlPosY + sliderHeight
	end
	
	local paletteCount = getUiPaletteCount( selectedClassType, selectedUiId, contentsIndex )
	if paletteCount == 1 then
		-- 컬러 피커 위치 생성 및 위치 설정
		controlPosY = controlPosY + controlOffset
		
		-- 팔레트 인덱스는 현재 paramDesc 내에 정의되는데 지금으로선 획득 방법이 애매하다.
		local paletteParamType = getUiPaletteParamType( selectedClassType, selectedUiId, contentsIndex ) 
		local paletteParamIndex = getUiPaletteParamIndex( selectedClassType, selectedUiId, contentsIndex ) 
		local paletteParamIndex2 = getUiPaletteParamIndex( selectedClassType, selectedUiId, contentsIndex+3 ) 
		local paletteIndex = getDecorationParamMethodValue( selectedClassType, paletteParamType, paletteParamIndex )
		
		-- 팔레트 생성
		FrameTemplateColor:SetShow( true )
		FrameTemplateColor:SetPosY( controlPosY )
		CreateEyePalette( FrameTemplateColor, Static_Collision, selectedClassType, paletteParamType, paletteParamIndex, paletteParamIndex2, paletteIndex, CheckControlArr[1], CheckControlArr[2] )
		
		local colorIndex = getParam( paletteParamType, paletteParamIndex )		
		-- 인덱스로 컬러 현재 선택 보여주기 추가해야함.
		UpdatePaletteMarkPosition( colorIndex )
		
		local Frame_Content_Color	= UI.getChildControl(FrameTemplateColor, "Frame_Content")
		Static_SelectMark_Color = UI.getChildControl(Frame_Content_Color, "Static_SelectMark")
		Frame_Content_Color:SetChildIndex( Static_SelectMark_Color, 9999 )
	else
		clearPalette()
	end
	Panel_Customization_Common_Decoration:SetSize( Panel_Customization_Common_Decoration:GetSizeX(), controlPosY + FrameTemplateColor:GetSizeY() + controlOffset )

	-- 커스터마이징 프레임 업데이트 
	updateGroupFrameControls( Panel_Customization_Common_Decoration:GetSizeY(), Panel_Customization_Common_Decoration )

	--UpdatePaletteMarkPosition( color )
	Panel_Customization_Common_Decoration:SetShow(true)
	FrameTemplateColor:UpdateContentScroll()
	FrameTemplateColor:UpdateContentPos()
	
	FrameTemplate:UpdateContentScroll()
	Frame_Scroll:SetControlTop()
	FrameTemplate:UpdateContentPos()
end 

function UpdateEyeDecorationList( paramType , paramIndex, paramIndex2 , itemIndex )
	if CheckControlArr[1]:IsCheck() == true then
		setParam( selectedClassType, paramType , paramIndex , itemIndex )
	end
	
	if CheckControlArr[2]:IsCheck() == true then
		setParam( selectedClassType, paramType , paramIndex2 , itemIndex )
	end
	UpdateMarkPosition( itemIndex )
end

function UpdateEyeDecorationSlider( sliderIndex )
	local luaSliderIndex = sliderIndex + 1
	
	local value = getSliderValue( SliderControlArr[ luaSliderIndex ] , sliderParamMin[ luaSliderIndex ], sliderParamMax[ luaSliderIndex ] )
	
	if CheckControlArr[1]:IsCheck() == true then
		setParam( selectedClassType, sliderParamType[ luaSliderIndex ] , sliderParamIndex[ luaSliderIndex ] , value )
	end
	
	if CheckControlArr[2]:IsCheck() == true then
		setParam( selectedClassType, sliderParamType[ luaSliderIndex ] , sliderParamIndex2[ luaSliderIndex ] , value )
	end
	SliderValueArr[ luaSliderIndex ]:SetText( value )
end

function EnableDecorationSlide( enable )
	SliderButtonArr[1]:SetMonoTone( not enable )
	SliderButtonArr[2]:SetMonoTone( not enable )
	SliderButtonArr[3]:SetMonoTone( not enable )
	SliderButtonArr[4]:SetMonoTone( not enable )
	SliderButtonArr[5]:SetMonoTone( not enable )	
    
	local color = Defines.Color.C_FF444444
	if( enable ) then
		color = Defines.Color.C_FFFFFFFF
	end
	
	SliderControlArr[1]:SetEnable( enable )
	SliderControlArr[2]:SetEnable( enable )
	SliderControlArr[3]:SetEnable( enable )
	SliderControlArr[4]:SetEnable( enable )
	SliderControlArr[5]:SetEnable( enable )
	
	SliderTextArr[1]:SetFontColor(color)
	SliderTextArr[2]:SetFontColor(color)
	SliderTextArr[3]:SetFontColor(color)
	SliderTextArr[4]:SetFontColor(color)
	SliderTextArr[5]:SetFontColor(color)
	SliderValueArr[1]:SetFontColor(color)
	SliderValueArr[2]:SetFontColor(color)
	SliderValueArr[3]:SetFontColor(color)
	SliderValueArr[4]:SetFontColor(color)
	SliderValueArr[5]:SetFontColor(color)
end

--------------------------------------------------------------

function OpenTattooDecorationUi( classType, uiId )
	isTattooMode = true
	OpenCommonDecorationUi( classType, uiId )
	if( isTattooMode ) then
		slideEnable =  getEnableTattooSlide(selectedClassType, selectedListParamType , selectedListParamIndex , selectedItemIndex)
		EnableDecorationSlide( slideEnable )
	end
end

function CloseTattooDecorationUi()
	isTattooMode = false
	EnableDecorationSlide( true )
	CloseCommonDecorationUi()
end

function OpenCommonExpressionUi( classType, uiId )
	SetExpression()
	OpenCommonDecorationUi( classType, uiId )
end

function CloseCommonExpressionUi()
	applyExpression(-1, 1)
	CloseCommonDecorationUi()
end

function SetExpression()
	local expressionIndex = getParam(4, 0)
	local expressionWeight = getParam(4, 1)
	applyExpression(expressionIndex, expressionWeight)
end
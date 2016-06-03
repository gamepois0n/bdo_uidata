
---------------------------------------------------- UI Control 등록 ------------------------------------------------------
local FrameTemplateColor	= UI.getChildControl(Panel_CustomizationSkin, "Frame_Template_Color")
local SliderText 			= UI.getChildControl(Panel_CustomizationSkin, "StaticText_Slider_1")
local SliderControl			= UI.getChildControl(Panel_CustomizationSkin, "Slider_R_Controller")
local Button_Slider			= UI.getChildControl(SliderControl, "Slider_GammaController_Button")
local Static_Collision		= UI.getChildControl( Panel_CustomizationSkin, "Static_Collision" )
local Static_CurrentValue	= UI.getChildControl( Panel_CustomizationSkin, "Static_Text_Slider_R_Left" )

local sliderParamType = 0
local sliderParamIndex = 0
local sliderParam = 0
local sliderParamMin = 0
local sliderParamMax = 255
local sliderParamDefault = 0
---------------------------------------------------- UI control 초기값 설정 -------------------------------------------------------


------------------------------------------------------- Event 등록 -----------------------------------------------------
-- registerEvent
registerEvent("EventOpenSkinUi", "OpenSkinUi")
registerEvent("EventCloseSkinUi", "CloseSkinUi")
------------------------------------------------------ 필요 변수 선언 및 정의 --------------------------------------------------

--선택되는 클래스 타입
local selectedClassType
local selectedUiId

-- 컨텐츠 컨트롤 사이 gap
local controlOffset = 10
local contentsStartY = 0

local sliderOffset = 7
local sliderValueOffset = 10
local sliderHeight = SliderText:GetSizeY()

------------------------------------------------------- Global 함수 ---------------------------------------------

function OpenSkinUi( classType, uiId )

	selectedClassType = classType
	selectedUiId = uiId
	contentsIndex = 0

	local controlPosY = contentsStartY
	
	local paletteCount = getUiPaletteCount( selectedClassType, selectedUiId, contentsIndex )

	if paletteCount == 1 then
		-- 컬러 피커 위치 생성 및 위치 설정
		controlPosY = controlPosY + controlOffset
		-- 팔레트 인덱스는 현재 paramDesc 내에 정의되는데 지금으로선 획득 방법이 애매하다.
		local paletteParamType = getUiPaletteParamType( selectedClassType, selectedUiId, contentsIndex ) 
		local paletteParamIndex = getUiPaletteParamIndex( selectedClassType, selectedUiId, contentsIndex ) 
		local paletteIndex = getDecorationParamMethodValue( selectedClassType, paletteParamType, paletteParamIndex )

		-- 팔레트 생성
		FrameTemplateColor:SetPosY( controlPosY )
		CreateCommonPalette( FrameTemplateColor, Static_Collision, selectedClassType, paletteParamType, paletteParamIndex, paletteIndex )
		
	
		local colorIndex = getParam( paletteParamType, paletteParamIndex )		
		-- 인덱스로 컬러 현재 선택 보여주기 추가해야함.
		UpdatePaletteMarkPosition( colorIndex )
		
	
		local Frame_Content_Color	= UI.getChildControl(FrameTemplateColor, "Frame_Content")
		Static_SelectMark_Color = UI.getChildControl(Frame_Content_Color, "Static_SelectMark")
		Frame_Content_Color:SetChildIndex( Static_SelectMark_Color, 9999 )

		controlPosY = controlPosY + FrameTemplateColor:GetSizeY() + controlOffset
	end
	
	local sliderCount = getUiSliderCount( selectedClassType, selectedUiId, contentsIndex )
	
	if sliderCount == 1 then
		local sliderIndex = 0

		sliderParamType = 	getUiSliderParamType( selectedClassType, selectedUiId, contentsIndex, sliderIndex )
		sliderParamIndex = 	getUiSliderParamIndex( selectedClassType, selectedUiId, contentsIndex, sliderIndex )	
		
		local sliderParam = getParam( sliderParamType, sliderParamIndex )
		sliderParamMin = getParamMin( selectedClassType, sliderParamType, sliderParamIndex )
		sliderParamMax = getParamMax( selectedClassType, sliderParamType, sliderParamIndex ) 
		sliderParamDefault = getParamDefault( selectedClassType, sliderParamType, sliderParamIndex )	
	
		--슬라이더 값 설정
		setSliderValue( SliderControl , sliderParam, sliderParamMin, sliderParamMax )
		SliderControl:addInputEvent("Mouse_LPress", "UpdateSkinSlider()")
		Button_Slider:addInputEvent("Mouse_LPress", "UpdateSkinSlider()")
		
		local sliderDesc = getUiSliderDescName( selectedClassType, selectedUiId, contentsIndex, sliderIndex )
		
		SliderText:SetText( PAGetString(Defines.StringSheet_GAME, sliderDesc) )
		SliderText:SetPosY( controlPosY )
		SliderText:SetShow( true )

		SliderControl:SetPosY( controlPosY + sliderOffset )
		SliderControl:SetShow( true )
		
		Static_CurrentValue:SetText( sliderParam ) 
		Static_CurrentValue:SetPosY( controlPosY + sliderValueOffset ) 
		Static_CurrentValue:SetShow( true )
		
		controlPosY = controlPosY + sliderHeight
	end
	
	Panel_CustomizationSkin:SetSize( Panel_CustomizationSkin:GetSizeX(), controlPosY + controlOffset )
	-- 커스터마이징 프레임 업데이트 
	updateGroupFrameControls( Panel_CustomizationSkin:GetSizeY(), Panel_CustomizationSkin )

	--UpdatePaletteMarkPosition( color )
	Panel_CustomizationSkin:SetShow(true)
	FrameTemplateColor:UpdateContentScroll()
	FrameTemplateColor:UpdateContentPos()	
	
end

function CloseSkinUi()

end

function UpdateSkinSlider()
	local value = getSliderValue( SliderControl, sliderParamMin, sliderParamMax )
	setParam( selectedClassType, sliderParamType, sliderParamIndex, value )
	Static_CurrentValue:SetText( value ) 
end

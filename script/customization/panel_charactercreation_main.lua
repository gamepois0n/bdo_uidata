---------------------------------------------------- UI Control 등록 ------------------------------------------------------
Panel_CustomizationMain:setFlushAble(false)
Panel_CustomizationStatic:setFlushAble(false)
Panel_CustomizationMessage:setFlushAble(False)

local Line_Template			= UI.getChildControl( Panel_CustomizationMain, "Static_LineTemplate1" )
local Static_Large_Point	= UI.getChildControl( Panel_CustomizationMain, "Static_Large_Point" )
local Static_Small_Point	= UI.getChildControl( Panel_CustomizationMain, "Static_Small_Point" )
local Button_MainButton		= UI.getChildControl( Panel_CustomizationMain, "Button_MainButton" )
local Button_Group			= UI.getChildControl( Panel_CustomizationMain, "Button_Group" )
local StaticText_Main		= UI.getChildControl( Panel_CustomizationMain, "StaticText_Main" )

local RadioButton_HistoryTemp 	= UI.getChildControl( Panel_CustomizationMain, "RadioButton_HistoryTemp" );
local Button_SaveHistory		= UI.getChildControl( Panel_CustomizationMain, "Button_SaveHistory" );



local staticMainImage = {}
staticMainImage[1]	= UI.getChildControl( Panel_CustomizationMain, "Static_Weather")
staticMainImage[2]	= UI.getChildControl( Panel_CustomizationMain, "Static_Customization")
staticMainImage[3]	= UI.getChildControl( Panel_CustomizationMain, "Static_BG")
staticMainImage[4]	= UI.getChildControl( Panel_CustomizationMain, "Static_Pose")	
staticMainImage[5]	= UI.getChildControl( Panel_CustomizationMain, "Static_Constellation")	

local staticPoseImage = {}
--staticPoseImage[1] = UI.getChildControl( Panel_CustomizationMain, "StaticText_facial")
staticPoseImage[1] = UI.getChildControl( Panel_CustomizationMain, "StaticText_look")
staticPoseImage[2] = UI.getChildControl( Panel_CustomizationMain, "StaticText_costume")

local staticWeatherImage = {}
staticWeatherImage[1] = UI.getChildControl( Panel_CustomizationMain, "Static_Weather_01")
staticWeatherImage[2] = UI.getChildControl( Panel_CustomizationMain, "Static_Weather_02")
staticWeatherImage[3] = UI.getChildControl( Panel_CustomizationMain, "Static_Weather_03")
staticWeatherImage[4] = UI.getChildControl( Panel_CustomizationMain, "Static_Weather_04")
staticWeatherImage[5] = UI.getChildControl( Panel_CustomizationMain, "Static_Weather_05")
staticWeatherImage[6] = UI.getChildControl( Panel_CustomizationMain, "Static_Weather_06")
staticWeatherImage[7] = UI.getChildControl( Panel_CustomizationMain, "Static_Weather_07")

local backGroundNum = 5

local StaticText_Zodiac =  UI.getChildControl( Panel_CustomizationMain, "StaticText_Zodiac" )
local Static_ZodiacImage = UI.getChildControl( Panel_CustomizationMain, "Static_ZodiacImage" )
local StaticText_ZodiacName = UI.getChildControl( Panel_CustomizationMain, "StaticText_ZodiacName" )
local StaticText_ZodiacDescription = UI.getChildControl( Panel_CustomizationMain, "StaticText_ZodiacDescription" )
local Static_ZodiacIcon = UI.getChildControl( Panel_CustomizationMain, "Static_ZodiacIcon" )
local Static_ZodiacITooltip 	= UI.getChildControl ( Panel_CustomizationMain, "StaticText_zodiacTooltip")	--별자리 툴팁

local Button_ApplyDefaultCustomization	= UI.getChildControl( Panel_CustomizationMain, "Button_ApplyDefaultCustomization" )
local Button_Char			= UI.getChildControl( Panel_CustomizationMain, "Button_CharacterCreateStart" )
local Button_SelectClass	= UI.getChildControl( Panel_CustomizationMain, "Button_SelectClass" )
local Button_Back			= UI.getChildControl( Panel_CustomizationMain, "Button_Back" )
local Static_CharName		= UI.getChildControl( Panel_CustomizationMain, "StaticText_CharacterName" )
local Edit_CharName			= UI.getChildControl( Panel_CustomizationMain, "Edit_CharacterName" )

local btn_CharacterNameCreateRule = UI.getChildControl( Panel_CustomizationMain, "Button_CharacterNameCreateRule")

local Button_SaveCustomization = UI.getChildControl( Panel_CustomizationMain, "Button_SaveCustomization" )
local Button_LoadCustomization = UI.getChildControl( Panel_CustomizationMain, "Button_LoadCustomization" )

local staticCustom = {}
staticCustom[1]			= UI.getChildControl( Panel_CustomizationMain, "StaticText_Hair" )
staticCustom[2]			= UI.getChildControl( Panel_CustomizationMain, "StaticText_Face" )
staticCustom[3]			= UI.getChildControl( Panel_CustomizationMain, "StaticText_Form" )
staticCustom[4]			= UI.getChildControl( Panel_CustomizationMain, "StaticText_Voice" )

local CheckButton_CameraLook		= UI.getChildControl( Panel_CustomizationStatic, "CheckButton_CameraLook" )
local CheckButton_ToggleUi			= UI.getChildControl( Panel_CustomizationStatic, "CheckButton_ToggleUi" )
local CheckButton_ImagePreset		= UI.getChildControl( Panel_CustomizationStatic, "CheckButton_ImagePreset" )
local Button_ScreenShot				= UI.getChildControl( Panel_CustomizationStatic, "Static_ScreenShot" )
local Button_ScreenShotFolder		= UI.getChildControl( Panel_CustomizationStatic, "Static_ScreenShotFolder" )

-- 상단 버튼 텍스트 선언
local CheckButton_CameraLook_Title		= UI.getChildControl( Panel_CustomizationStatic, "StaticText_CameraLook" )
local CheckButton_ToggleUi_Title		= UI.getChildControl( Panel_CustomizationStatic, "StaticText_ToggleUi" )
local CheckButton_ImagePreset_Title		= UI.getChildControl( Panel_CustomizationStatic, "StaticText_ImagePreset" )
local Button_ScreenShot_Title			= UI.getChildControl( Panel_CustomizationStatic, "StaticText_ScreenShot" )
local Button_ScreenShotFolder_Title		= UI.getChildControl( Panel_CustomizationStatic, "StaticText_ScreenShotFolder" )

local StaticText_CustomizationMessage = UI.getChildControl( Panel_CustomizationMessage, "StaticText_CustomizationMessage" )
--local StaticText_CustomizationSubMessage = UI.getChildControl( Panel_CustomizationMessage, "StaticText_SubText" )

-- 가문명
local StaticText_FamilyNameTitle	= UI.getChildControl( Panel_CustomizationMain, "StaticText_FamilyNameTitle" )
local StaticText_FamilyName			= UI.getChildControl( Panel_CustomizationMain, "StaticText_FamilyName" )

--커스터마이징 정보
local StaticText_CustomizationInfo = UI.getChildControl( Panel_CustomizationMain, "StaticText_CustomizationInfo") 
local StaticText_AuthorName = UI.getChildControl( Panel_CustomizationMain, "StaticText_AuthorName")
local StaticText_AuthorTitle = UI.getChildControl( Panel_CustomizationMain, "StaticText_AuthorTitle")

-- do/undo용 버튼
local historyButtons = {}
local _classIndex
local InGameMode = false
local closeCustomizationMode = false
---------------------------------------------------- UI control 초기값 설정 -------------------------------------------------------

Button_ApplyDefaultCustomization:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_APPLYDEFAULTCUSTOMIZATION"))	-- 커스터마이징 초기화
Button_Char:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CREATEOK"))	-- 생성완료
Button_SelectClass:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_SELECTCLASS"))	-- 클래스 선택으로
Button_Back:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_SELECTCHARACTER"))	-- 캐릭터 선택으로
Static_CharName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CHARNAME"))	-- 캐릭터 이름
StaticText_Zodiac:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_ZODIAC"))	-- 별자리


Button_SaveCustomization:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERCREATION_MAIN_BUTTON_SAVECUSTOMIZATION") )	-- ("캐릭터 생성 정보 저장")
Button_LoadCustomization:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERCREATION_MAIN_BUTTON_LOADCUSTOMIZATION") )	--("캐릭터 생성 정보 읽기")
Button_SaveHistory:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERCREATION_MAIN_BUTTON_SAVEHISTORY") )	--("임시 저장")


-- 가문명 세팅
StaticText_FamilyName:SetText(getFamilyName())


-- 상단 버튼 텍스트 내용 설정
CheckButton_CameraLook_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CAMERALOOK_TITLE"))	-- 바라보기
CheckButton_ToggleUi_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_TOGGLEUI_TITLE"))	-- UI 토글
--CheckButton_ImagePreset_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CAMPRESET_TITLE"))	-- 카메라 시점
Button_ScreenShot_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERCREATION_MAIN_SCREENSHOT_TITLE") ) -- "스크린샷\n   찍기")	-- UI 토글
Button_ScreenShotFolder_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERCREATION_MAIN_SCREENSHOTFOLDER_TITLE") ) -- "스크린샷\n폴더 열기")	-- UI 토글

StaticText_CustomizationMessage:SetText("")

-- 커스터마이징 정보 관련
StaticText_CustomizationInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CUSTOMIZING_INFO")) -- 커스터마이징 정보
StaticText_AuthorTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CUSTOMIZING_AUTHOR")) -- 제작자 : 

Line_Template:SetSize( Line_Template:GetSizeX(), 28 )
Panel_CustomizationMain:RegisterUpdateFunc("MainPanel_UpdatePerFrame")

local preview_Main = true 

---------------------------------------------------------------------------------------------------------------------

local UI_TM 			= CppEnums.TextMode
local mainButtonNum = 5

local timer = 0.0
local isSubEffectPlay = false;

CheckButton_ImagePreset_Title:SetShow( false )
RadioButton_HistoryTemp:SetShow( false )

local mainText =
{
	PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_WEATHER"),
	PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CUSTOMIZE"),
	PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_BACKGROUND"),
	PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CHARACTER_ACTION"),
	PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_ZODIAC")
}


-- PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_WEATHER")	-- 날씨
-- PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CUSTOMIZE")	-- 커스터마이징
-- PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_BACKGROUND")	-- 배경
-- PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_CHARACTER_ACTION")	-- 캐릭터 행동
-- PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_ZODIAC")	-- 별자리

-- addInputEvent
---------------------------------------------------- Event 등록 --------------------------------------------------------------------
Button_ApplyDefaultCustomization:addInputEvent("Mouse_LUp",		"HandleClicked_CustomizationMain_applyDefaultCustomizationParams()")
Button_Char:addInputEvent("Mouse_LUp",		"Panel_CharacterCreateOK_NewCustomization()")
Button_SelectClass:addInputEvent("Mouse_LUp",		"HandleClicked_CustomizationMain_SelectClass()")
Button_Back:addInputEvent("Mouse_LUp",				"HandleClicked_CustomizationMain_Back()")
btn_CharacterNameCreateRule:addInputEvent("Mouse_LUp",		"HandleClicked_RuleShow()")

--Button_SaveCustomization:addInputEvent("Mouse_LUp", "saveCustomizationData()")
--Button_LoadCustomization:addInputEvent("Mouse_LUp", "loadCustomizationData()")

Button_SaveCustomization:addInputEvent("Mouse_LUp", "HandleClicked_saveCustomizationData()")
Button_LoadCustomization:addInputEvent("Mouse_LUp", "HandleClicked_loadCustomizationData()")


CheckButton_CameraLook:addInputEvent("Mouse_LUp",		"CameraLookCheck()")
CheckButton_CameraLook:addInputEvent("Mouse_On", "overToggleButton(\"" .. CheckButton_CameraLook:GetID() .. "\""  .. ")" )
CheckButton_ToggleUi:addInputEvent("Mouse_LUp",		"ToggleUi()")
CheckButton_ToggleUi:addInputEvent("Mouse_On", "overToggleButton(\"" .. CheckButton_ToggleUi:GetID() .. "\""  .. ")" )
--CheckButton_ImagePreset:addInputEvent("Mouse_LUp",		"ToggleImageUI()" )
--CheckButton_ImagePreset:addInputEvent("Mouse_On", "overToggleButton(\"" .. CheckButton_ImagePreset:GetID() .. "\""  .. ")" )

Button_ScreenShot:addInputEvent("Mouse_LUp", "TakeScreenShot()" )
Button_ScreenShot:addInputEvent("Mouse_On", "overToggleButton(\"" .. Button_ScreenShot:GetID() .. "\""  .. ")" )
Button_ScreenShotFolder:addInputEvent("Mouse_LUp", "OpenScreenShotFolder()" )
Button_ScreenShotFolder:addInputEvent("Mouse_On", "overToggleButton(\"" .. Button_ScreenShotFolder:GetID() .. "\""  .. ")" )

CheckButton_ImagePreset:SetShow(false)

Button_SaveHistory:addInputEvent( "Mouse_LUp", "HandleClicked_CustomizationAddHistory()" )
registerEvent("EventSetMainButtonPosition", "SetMainButtonPosition")
registerEvent("EventShowUpAllUI", "showAllUI")

registerEvent("EventCustomizationMessage", "CustomizationMessage" )

registerEvent("EventShowCharacterCustomization", "ShowCharacterCustomization")

registerEvent("EventinitToggleIndex", "initToggleIndex")
registerEvent("EventNotify_customizationAuthorName", "CustomizationAuthorName")
------------------------------------------------------ 필요 변수 선언 및 정의 --------------------------------------------------
local mainButtonInfo = {}
local groupTree = {}

local initialized = false


local preview_Main = true 

local UI_TM 			= CppEnums.TextMode

local timer = 0.0
local isSubEffectPlay = false;
local doScreenShot = false


---------------------------------------------- local 함수 ---------------------------------------------
local rotationPointNormalize = function( x, y, angle )
	local nX = x * math.cos(angle) + y * math.sin(angle)
	local nY = x * -math.sin(angle) + y * math.cos(angle)
	
	local normalize = math.sqrt( nX * nX + nY * nY )
	nX = nX / normalize
	nY = nY / normalize
	return nX, nY
end

local updateComputePos = function()
	CheckButton_CameraLook:ComputePos()
	CheckButton_ToggleUi:ComputePos()
	CheckButton_ImagePreset:ComputePos()
	Button_ScreenShot:ComputePos()
	Button_ScreenShotFolder:ComputePos()
	StaticText_Zodiac:ComputePos()
	StaticText_ZodiacName:ComputePos()
	StaticText_ZodiacDescription:ComputePos()
	Static_ZodiacImage:ComputePos()
	Button_ApplyDefaultCustomization:ComputePos()
	Button_Char:ComputePos()
	Button_Back:ComputePos()
	Button_SelectClass:ComputePos()
	Edit_CharName:ComputePos()
	Static_CharName:ComputePos()
	Button_SaveCustomization:ComputePos()
	Button_LoadCustomization:ComputePos()
	btn_CharacterNameCreateRule:ComputePos()
	
	StaticText_CustomizationInfo:ComputePos()
	StaticText_AuthorTitle:ComputePos()
	StaticText_AuthorName:ComputePos()
	
	Button_SaveHistory:ComputePos()
	StaticText_FamilyNameTitle:ComputePos()
	StaticText_FamilyName:ComputePos()
	
	StaticText_CustomizationMessage:ComputePos()
	
end

local createWeatherGroup = function( groupInfo )
	local count = getWeatherCount()
	groupInfo.treeItem:SetAsParentNode( 100, Line_Template, 0.61, math.pi/9, math.pi + math.pi/8 )
	for ii=1, count do 
		local groupItem = groupInfo.treeItem:addItem( Button_Group, "TREE_BUTTON_" .. ii, staticWeatherImage[ii] )
		groupItem.control:SetShow( true )
		groupItem.control:addInputEvent("Mouse_LUp", "applyWeather(" .. ii - 1 .. ")")
		groupItem.control:addInputEvent("Mouse_LDown", "clickSubButton()")
		local name = groupItem.control:GetID()
		local parentName = groupInfo.button:GetID()
		groupItem.control:addInputEvent("Mouse_On", "overSubButton(\"" .. parentName .. "\",\"" .. name .. "\""  .. ")" )
	end
end

local createCustomizationGroup = function( groupInfo )
	groupInfo.treeItem:SetAsParentNode( 100, Line_Template, 0.61 , math.pi/5, -math.pi/2 )
	for ii=1, 4 do 
		local groupItem;
		groupItem = groupInfo.treeItem:addItem( Button_Group, "TREE_BUTTON_" .. ii, staticCustom[ii] )
		groupItem.control:SetShow( true )
		groupItem.control:addInputEvent("Mouse_LDown", "clickSubButton()")
		
		if( ii ~= 4 ) then
			groupItem.control:addInputEvent("Mouse_LUp", "SelectCustomizationGroup(" .. ii - 1 .. ")")
		else
			groupItem.control:addInputEvent("Mouse_LUp", "SelectCustomizationVoice()")
		end
		
		local name = groupItem.control:GetID()
		local parentName = groupInfo.button:GetID()
		groupItem.control:addInputEvent("Mouse_On", "overSubButton(\"" .. parentName .. "\",\"" .. name .. "\""  .. ")" )
	end
end

local createPoseGroup = function( groupInfo )
	groupInfo.treeItem:SetAsParentNode( 100, Line_Template, 0.61, math.pi/5, -math.pi/5 )
	
	
	-- zezzeg : 이번 2차 cbt에는 expression은 제외
	for ii=1, 2 do 
		local groupItem = groupInfo.treeItem:addItem( Button_Group, "TREE_BUTTON_" .. ii, staticPoseImage[ii] )
		groupItem.control:SetShow( true )
		
		if ii ~= 2 then
			groupItem.control:addInputEvent("Mouse_LUp", "SelectPoseControl(" .. ii .. ")")
		else
			groupItem.control:addInputEvent("Mouse_LUp", "SelectPoseControl(" .. ii .. ")")
		end
		groupItem.control:addInputEvent("Mouse_LDown", "clickSubButton()")
		local name = groupItem.control:GetID()
		local parentName = groupInfo.button:GetID()
		groupItem.control:addInputEvent("Mouse_On", "overSubButton(\"" .. parentName .. "\",\"" .. name .. "\""  .. ")" )
	end
end

local createBackgroundGroup = function( groupInfo )

	groupInfo.treeItem:SetAsParentNode( 100, Line_Template, 0.61, math.pi*2/5, math.pi*5/4 )
	for ii=1, backGroundNum do  
		local groupItem = groupInfo.treeItem:addItem( Button_Group, "TREE_BUTTON_" .. ii, staticWeatherImage[ii] )
		groupItem.control:SetShow( true )
		groupItem.control:addInputEvent("Mouse_LUp", "applyBackground(" .. ii - 1 .. ")")
		groupItem.control:addInputEvent("Mouse_LDown", "clickSubButton()")
		local name = groupItem.control:GetID()
		local parentName = groupInfo.button:GetID()
		groupItem.control:addInputEvent("Mouse_On", "overSubButton(\"" .. parentName .. "\",\"" .. name .. "\""  .. ")" )
	end
end

function SelectZodiac ( zodiacIndex )
	local zodiacInfo = getZodiac( zodiacIndex )
	
	local zodiacName = zodiacInfo:getZodiacName()
	if zodiacName ~= nil then
		StaticText_ZodiacName:SetText( zodiacName )
	end
	
	local zodiacDescription = zodiacInfo:getZodiacDescription()
	if zodiacDescription ~= nil then
		StaticText_ZodiacDescription:SetTextMode( UI_TM.eTextMode_AutoWrap )
		StaticText_ZodiacDescription:SetText( zodiacDescription )
	end
	
	local zodiacImagePath = zodiacInfo:getZodiacImagePath()
	if zodiacImagePath ~= nil then
		Static_ZodiacImage:SetShow( true )
		Static_ZodiacImage:ChangeTextureInfoName( zodiacImagePath )
		Static_ZodiacImage:getBaseTexture():setUV( 0, 0, 1, 1 )	
		Static_ZodiacImage:setRenderTexture(Static_ZodiacImage:getBaseTexture())
	end
	
	local zodiacKey = zodiacInfo:getZodiacKey()
	applyZodiac( zodiacKey )
end

local createZodiacGroup = function( groupInfo )
	
	local tempStatic_ZodiacIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMain, "StaticText_Zodiac_Copied" )
	CopyBaseProperty ( Static_ZodiacIcon, tempStatic_ZodiacIcon )
	
	Line_Template:SetSize( Line_Template:GetSizeX(), 53 )
	local count = getZodiacCount()
	groupInfo.treeItem:SetAsParentNode( 130, Line_Template, 0.59, math.pi , -math.pi*5/6)
	for ii=1, count do 
		local zodiacInfo = getZodiac( ii-1 )
		local zodiacIconPath = zodiacInfo:getZodiacIconPath()
		tempStatic_ZodiacIcon:ChangeTextureInfoName( zodiacIconPath )
		tempStatic_ZodiacIcon:getBaseTexture():setUV( 0, 0, 1, 1 )	
		
		--local x1, y1, x2, y2 = setTextureUV_Func( tempStatic_ZodiacIcon, 8, 8, 72, 72 )
		--tempStatic_ZodiacIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
		--tempStatic_ZodiacIcon:SetSize(64, 64)
		
		tempStatic_ZodiacIcon:setRenderTexture(tempStatic_ZodiacIcon:getBaseTexture())
		local groupItem = groupInfo.treeItem:addItem( Button_Group, "TREE_BUTTON_" .. ii, tempStatic_ZodiacIcon )
		groupItem.control:SetShow( true )
		groupItem.control:addInputEvent("Mouse_LUp", "SelectZodiac(" .. ii - 1 .. ")")
		local name = groupItem.control:GetID()
		local parentName = groupInfo.button:GetID()
		
		-- 별자리 이름 툴팁을 위해 다른 함수를 씀  복사/수정한  다른 함수를 씀.  3번째 인자에 별자리 ID를 넘김.
		-- 원래 함수는 overSubButton이고, 3번째 인자가 없음.
		groupItem.control:addInputEvent("Mouse_LDown", "clickSubButton_Zodiac()")
		groupItem.control:addInputEvent("Mouse_On", "overSubButton_Zodiac(\"" .. parentName .. "\",\"" .. name .. "\",\"" .. ( ii - 1 )  .. "\"" .. ")" )
		groupItem.control:addInputEvent("Mouse_Out", "outSubButton_Zodiac(\"" .. ( ii - 1 )  .. "\"" .. ")" )
	end
	
end

local createUI = function()
	for idx=1, mainButtonNum do
		if( idx ~= 3 ) then
			mainButtonInfo[idx] = 
			{
				line		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMain, "STATIC_LINE_" .. idx ),
				point		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMain, "STATIC_POINT_" .. idx ),
				smallPoint	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMain, "STATIC_SMALL_POINT_" .. idx ),
				tree		= TreeMenu.new_Button( 'TreeMenu_Button' .. idx, Panel_CustomizationMain),
				static		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMain, "STATIC_IMAGE_" .. idx ),
				staticText	= UI.createControl(  CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CustomizationMain, "STATICTEXT_MAIN_" .. idx ),
				isOpen		= true,
				button		= nil
			}
			
			mainButtonInfo[idx].treeItem = mainButtonInfo[idx].tree:getRootItem()
			mainButtonInfo[idx].button = mainButtonInfo[idx].treeItem.control

			CopyBaseProperty( Button_MainButton, mainButtonInfo[idx].button )
			CopyBaseProperty( Static_Large_Point, mainButtonInfo[idx].point )
			CopyBaseProperty( Line_Template, mainButtonInfo[idx].line )
			CopyBaseProperty( Static_Small_Point, mainButtonInfo[idx].smallPoint )
			CopyBaseProperty( staticMainImage[idx], mainButtonInfo[idx].static )
			CopyBaseProperty( StaticText_Main, mainButtonInfo[idx].staticText )

			
			
			mainButtonInfo[idx].button:addInputEvent("Mouse_On", "overMainButton(" .. idx .. ")")
			mainButtonInfo[idx].button:SetShow( true )
			mainButtonInfo[idx].line:SetShow( true )
			mainButtonInfo[idx].point:SetShow( true )
			mainButtonInfo[idx].smallPoint:SetShow( true )
			
			mainButtonInfo[idx].staticText:SetText( mainText[idx] )
			mainButtonInfo[idx].staticText:SetShow( true )
			
			if idx == 2 then -- 커스터마이징
				createCustomizationGroup( mainButtonInfo[idx] )
			elseif idx == 1 then -- 날씨
				createWeatherGroup( mainButtonInfo[idx] )				
			elseif idx == 4 then -- 포즈 에디팅
				createPoseGroup( mainButtonInfo[idx] )
			elseif idx == 3 then
				--createBackgroundGroup( mainButtonInfo[idx] )
			elseif idx == 5 then	
				createZodiacGroup( mainButtonInfo[idx] )
			end
			
			mainButtonInfo[idx].tree:collapseAll()
			mainButtonInfo[idx].isOpen = false
		end
		staticMainImage[idx]:SetShow( false )
	end

	--setProjectionTexture(0, Button_Char)
	--Button_Char:getBaseTexture():setUV(  0, 0, 1, 1  )
	--Button_Char:setRenderTexture( Button_Char:getBaseTexture() )
	--SlideMenuCreateUI()
	
	--OpenTextureUi()
end

local InitZodiac = function()
	Static_ZodiacImage:SetShow( false )
	StaticText_ZodiacName:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CUSTOMIZATIONMAIN_NONEZODIAC") )	-- 선택되지 않았습니다.
	StaticText_ZodiacDescription:SetText( "" )
end

local isShow_CustomizationMessage, isShow_CustomizationCloth, isShow_CustomizationMotion, isShow_CustomizationFrame, isShow_CustomizationMain
function TakeScreenShot()
	
	isShow_CustomizationMessage		= StaticText_CustomizationMessage:GetShow()
	isShow_CustomizationCloth		= Panel_CustomizationCloth:GetShow()
	isShow_CustomizationMotion		= Panel_CustomizationMotion:GetShow()
	isShow_CustomizationFrame		= Panel_CustomizationFrame:GetShow()
	isShow_CustomizationMain		= Panel_CustomizationMain:GetShow()
	
	StaticText_CustomizationMessage:SetShow( false )
	Panel_CustomizationCloth:SetShow( false )
	Panel_CustomizationMotion:SetShow( false )
	Panel_CustomizationFrame:SetShow( false )
	Panel_CustomizationMain:SetShow( false )
	
	doScreenShot = true
end

local function _takeScreenShot()
	ToClient_Capture()
	
	StaticText_CustomizationMessage	:SetShow( isShow_CustomizationMessage )
	Panel_CustomizationCloth		:SetShow( isShow_CustomizationCloth )
	Panel_CustomizationMotion		:SetShow( isShow_CustomizationMotion )
	Panel_CustomizationFrame		:SetShow( isShow_CustomizationFrame )
	Panel_CustomizationMain			:SetShow( isShow_CustomizationMain )
end

local timerForSS = 0
function OpenScreenShotFolder()
	ToClient_OpenDirectory( CppEnums.OpenDirectoryType.DirectoryType_ScreenShot )
end

function CustomizationStatic_UpdatePerFrame( deltaTime )
	if doScreenShot then
		if 0.3 < timerForSS then
			timerForSS = 0
			doScreenShot = false
			_takeScreenShot()
		else
			timerForSS = timerForSS + deltaTime
		end
	end
end

Panel_CustomizationStatic:RegisterUpdateFunc("CustomizationStatic_UpdatePerFrame")

---------------------------------------------- global 함수 ---------------------------------------------
function MainPanel_UpdatePerFrame( deltaTime )
	if( initialized == true ) then
		for index = 1 , mainButtonNum do
			if( index ~= 3 ) then
			
				mainButtonInfo[ index ].tree:update()
				local x = mainButtonInfo[index].button:GetPosX() + mainButtonInfo[index].button:GetSizeX()/2
				local y = mainButtonInfo[index].button:GetPosY() + mainButtonInfo[index].button:GetSizeY()/2
				local x2 = getMousePosX()
				local y2 = getMousePosY()
				local distance = math.sqrt(math.pow((x-x2), 2)+math.pow((y-y2),2))
				if( true == mainButtonInfo[index].isOpen ) then
					if( distance > 170 ) then
						mainButtonInfo[index].button:EraseAllEffect()
						mainButtonInfo[index].tree:collapseAll()
						mainButtonInfo[index].isOpen = false
					end
				end
			end
		end
	end
	
	if isSubEffectPlay == false then
		if timer > 0.2 then
			isSubEffectPlay = true
			timer = 0.0
		else
			timer = timer + deltaTime
		end
	end
end


function overToggleButton( name )
	local control = UI.getChildControl( Panel_CustomizationStatic , name )
	control:EraseAllEffect()
	control:AddEffect("UI_Customize_Button01_Mini", false, 0, 0)
	-- 사운드 마우스오버 토글버튼
end

function clickSubButton()
	-- 사운드 마우스클릭 별자리를 제외한 모든서버버튼
end

function overSubButton( parent, name )
	-- 사운드 마우스오버 별자리를 제외한 모든서브버튼
	if( isSubEffectPlay == true ) then
		local controlParent = UI.getChildControl( Panel_CustomizationMain, parent )
		local control = UI.getChildControl( controlParent , name )
		--subMenu Effect
		control:EraseAllEffect()
		control:AddEffect("UI_Customize_Button01_Mini", false, 0, 0)
	end
end

-- 마우스 오버하면 별자리 이름도 나오게 한다.
local selected_zodiacIndex
function overSubButton_Zodiac( parent, name , zodiacIndex)

	-- 사운드 마우스오버 별자리버튼
	selected_zodiacIndex = zodiacIndex

	local zodiacInfo = getZodiac( zodiacIndex )
	local zodiacName = zodiacInfo:getZodiacName()
	-- UI.debugMessage("별자리 이름 : " .. zodiacName)

	-- 별자리 아이콘이 생성된 것이기 때문에, 툴팁 인덱스를 강제로 올려야 한다.
	Panel_CustomizationMain:SetChildIndex(Static_ZodiacITooltip, 9999 )
	Static_ZodiacITooltip:SetText( zodiacName )
	Static_ZodiacITooltip:SetPosX( getMousePosX() )
	Static_ZodiacITooltip:SetPosY( getMousePosY() + 30 )
	Static_ZodiacITooltip:SetShow( true )

	-- 이 아래는 원래 있던 이팩트.
	if( isSubEffectPlay == true ) then
		local controlParent = UI.getChildControl( Panel_CustomizationMain, parent )
		local control = UI.getChildControl( controlParent , name )
		--subMenu Effect
		control:EraseAllEffect()
		control:AddEffect("UI_Customize_Button01_Mini", false, 0, 0)
	end
end

function clickSubButton_Zodiac()
	-- 사운드 마우스클릭 별자리버튼
end

-- 마우스가 빠지면 툴팁을 끈다.
function outSubButton_Zodiac( zodiacIndex )
	if( selected_zodiacIndex == zodiacIndex ) then
		Static_ZodiacITooltip:SetShow( false )	
	end
end

function overMainButton( idx )
	-- 사운드 메인버튼들 마우스 오버
	if mainButtonInfo[idx].isOpen == false then
		mainButtonInfo[idx].tree:update()
		mainButtonInfo[idx].tree:expandAll()
		mainButtonInfo[idx].isOpen = true
		isSubEffectPlay = false
		--이펙트
		mainButtonInfo[idx].button:EraseAllEffect()
		mainButtonInfo[idx].button:AddEffect("UI_Customize_Button01", false, 0, 0)
		mainButtonInfo[idx].static:SetAlpha(0.5)
		UIAni.AlphaAnimation( 1, mainButtonInfo[idx].static, 0.0, 0.2 )

		--if idx ~= 5 then
			--SlideMenuFilter( idx )
		--end
	end
	
	for mainIndex = 1, mainButtonNum do
		if ( mainIndex ~= idx and mainIndex ~= 3 ) then
			mainButtonInfo[mainIndex].button:EraseAllEffect()
			mainButtonInfo[mainIndex].tree:collapseAll()
			mainButtonInfo[mainIndex].isOpen = false
			mainButtonInfo[idx].static:SetAlpha(1)
			UIAni.AlphaAnimation( 0.5, mainButtonInfo[mainIndex].static, 0.0, 0.2 )
		end
	end
end

function mouseOnGroupButton( control )
	control:EraseAllEffect()
	control:AddEffect("UI_Customize_Button01", false, 0, 0)
end

function SetMainButtonPosition( index, x, y, buttonRelativeX, buttonRelativeY )
	if( InGameMode == true ) and ( index == 5 ) then
		return
	end
	
	if( index ~= 3 ) then	
		local buttonPosX = buttonRelativeX * getScreenSizeX();
		local buttonPosY = buttonRelativeY * getScreenSizeY();

		if( index == 1 ) then
			x = buttonPosX - 45
			y = buttonPosY - 30
		elseif ( index == 5 ) then
			x = buttonPosX - 45
			y = buttonPosY + 30
		end
		
		offsetX = buttonPosX - x
		offsetY = buttonPosY - y
		
		local control = mainButtonInfo[index]
		local lineLength = math.sqrt( math.abs(math.pow( x-(offsetX+x), 2 )) + math.abs(math.pow( y-(offsetY+y), 2 )) )
		local angle = math.atan2( (offsetX+0) * -1 - (offsetY+-1) * 0, (offsetX+0) * 0 + (offsetY*-1) * -1 )
		
		control.line:SetRotate( angle )
		
		if math.abs(angle) > (3.14/2) then
			control.line:SetPosY( y + offsetY - (((lineLength)- math.abs(offsetY))/2))
		else
			control.line:SetPosY( y - (((lineLength) - math.abs(offsetY))/2) )
		end

		control.line:SetPosX( x + offsetX/2 )
		control.line:SetSize(control.line:GetSizeX(), lineLength )
		
		local nX, nY = rotationPointNormalize( 0, -1, angle )
		nX = nX * control.static:GetSizeX()/2;
		nY = nY * control.static:GetSizeY()/2;
		

		control.button:SetPosX( x + offsetX - (control.button:GetSizeX()/2) + nX  )
		control.button:SetPosY( y + offsetY - (control.button:GetSizeX()/2) - nY  )
		
		control.smallPoint:SetPosX( x + offsetX - (control.smallPoint:GetSizeX()/2)+1)
		control.smallPoint:SetPosY( y + offsetY - (control.smallPoint:GetSizeY()/2))
		
		control.static:SetPosX( x + offsetX - (control.static:GetSizeX()/2) + nX  )
		control.static:SetPosY( y + offsetY - (control.static:GetSizeX()/2) - nY  )
		
		control.point:SetPosX( x - control.point:GetSizeX()/2 )
		control.point:SetPosY( y - control.point:GetSizeY()/2 )
		
		control.staticText:SetPosX( control.button:GetPosX() + control.button:GetSizeX()/2 - control.staticText:GetSizeX()/2 )
		control.staticText:SetPosY(  control.button:GetPosY() + control.button:GetSizeY()  )
	end
end

function SelectCustomizationGroup( idx )
	selectCustomizationControlGroup( idx )
	CustomizationMainUIShow( false )
	
	-- FileEXplorer.lua ( Explorer Close )
	closeExplorer()	
end

function SelectCustomizationVoice()
	CustomizationMainUIShow( false )
	createVoiceList(InGameMode, selectedClassType)
	showVoiceUI(true)
	
	-- FileEXplorer.lua ( Explorer Close )
	closeExplorer()
end

function SelectPoseControl( idx )
	selectPoseControl( idx )
	CustomizationMainUIShow( false )
	
	-- FileEXplorer.lua ( Explorer Close )
	closeExplorer()
end

function FGlobal_IsInGameMode()
	return InGameMode
end

function InitCustomizationMainUI()
	if( initialized == false ) then
		Panel_CustomizationMain:SetSize( getScreenSizeX(), getScreenSizeY() )
		--Panel_CustomizationMainSlide:SetSize( getScreenSizeX(), getScreenSizeY() )
		createUI()
		initialized = true
	end
-- StaticText_FamilyNameTitle:SetPosY( Static_CharName:GetPosY() + 250 )
-- StaticText_FamilyName:SetPosY( Static_CharName:GetPosY() + 250 )
	updateComputePos()
	CreateHistoryButton()
	ClearFocusEdit()
	InitZodiac()
	Edit_CharName:SetMaxInput( getGameServiceTypeCharacterNameLength() )
	Edit_CharName:RegistReturnKeyEvent( "Panel_CharacterCreateOK_NewCustomization()" )
	CheckButton_CameraLook:SetCheck(true)
	showAllUI(false)	--	초기 설정시 전체 UI를 Hide 상태로 한다. (CheckButton_ToggleUi 를 false함)
end

function showAllUI( show )
	CheckButton_ToggleUi:SetCheck(show)
	ToggleUi()
	showStaticUI(show)
end

function CustomizationMainUIShow( show )

	if( false == closeCustomizationMode ) then
		if( show == true ) then
			Panel_CustomizationMain:SetShow( true )
			Panel_CustomizationMain:SetAlpha(0)
			UIAni.AlphaAnimation( 1, Panel_CustomizationMain, 0.0, 0.2 )
			
			if( initialized == true )then
				for idx=1, mainButtonNum do
					if( idx ~= 3 ) then
						UIAni.AlphaAnimation( 0.5, mainButtonInfo[idx].static, 0.0, 0.2 )
					end
				end
			end
			--CustomizationSlideUIShow( false )
			
		else
			local aniInfo = UIAni.AlphaAnimation( 0, Panel_CustomizationMain, 0.0, 0.2 )
			aniInfo:SetHideAtEnd(true)
			--CustomizationSlideUIShow( true )
		end
	end
end

function CameraLookCheck()
	setCharacterLookAtCamera( CheckButton_CameraLook:IsCheck() )
end

function CameraLookEnable( lookEnable )
	setCharacterLookAtCamera( lookEnable )
	CheckButton_CameraLook:SetCheck( lookEnable )
end

local hideUIIndex = 0		-- ToggleUI 에서 Hide 시킨 UI패널을 인덱싱해서 저장해 놓음. Show 할때 쓰게..
function ToggleUi()

	if CheckButton_ToggleUi:IsCheck() then		--	on
		StaticText_CustomizationMessage:SetShow(true)

		-- if 2 == hideUIIndex then		--	expression
			-- Panel_CustomizationExpression:SetShow( true )
		-- else
		if 2 == hideUIIndex then		--	cloth
			Panel_CustomizationCloth:SetShow( true )
		elseif 3 == hideUIIndex then	--	motion
			Panel_CustomizationMotion:SetShow(true)
		elseif 1 == hideUIIndex then			--	frame
			toggleShowFrameUI(true)
		else									--	main
			if( InGameMode == true ) then
				if( Panel_Cash_Customization:IsShow() == false ) then
					CashCustomization_Open()
				end
			end
			Panel_CustomizationMain:SetShow( true )
			Panel_CustomizationMain:SetAlpha(0)
			UIAni.AlphaAnimation( 1, Panel_CustomizationMain, 0.0, 0.2 )	
			for idx=1, mainButtonNum do
				if( idx ~= 3 ) then
					UIAni.AlphaAnimation( 0.5, mainButtonInfo[idx].static, 0.0, 0.2 )
				end
			end			
		end	
		
		hideUIIndex = 0
		
	else	-- off
		StaticText_CustomizationMessage:SetShow(false)
	--	StaticText_CustomizationSubMessage:SetShow(false)
		-- if Panel_CustomizationExpression:GetShow() then		--	expression
			-- Panel_CustomizationExpression:SetShow(false)
			-- hideUIIndex = 2
		-- else
		if Panel_CustomizationCloth:GetShow() then		--	cloth
			Panel_CustomizationCloth:SetShow(false)
			hideUIIndex = 2
		elseif Panel_CustomizationMotion:GetShow() then		--	motion
			Panel_CustomizationMotion:SetShow(false)
			hideUIIndex = 3
		elseif Panel_CustomizationFrame:GetShow() then	--	frame
			toggleShowFrameUI(false)
			hideUIIndex = 1
		else									--	main
			local aniInfo = UIAni.AlphaAnimation( 0, Panel_CustomizationMain, 0.0, 0.2 )
			aniInfo:SetHideAtEnd(true)
			hideUIIndex = 0
		end	
		
	end
	
end

function ToggleImageUI()
	if(	Panel_CustomizationImage:IsShow() ) then
		CloseTextureUi()
	else
		OpenTextureUi()	
	end
end

function initToggleIndex()
	if(	Panel_CustomizationImage:IsShow() ) then
		CloseTextureUi()
	end
	hideUIIndex = 0
	CheckButton_ToggleUi:SetCheck(true)
	StaticText_CustomizationMessage:SetShow(true)
end

function showStaticUI( show )
	--CheckButton_CameraLook:SetShow(show)
	--CheckButton_ToggleUi:SetShow(show)
	
	if( show == true ) then
		Panel_CustomizationStatic:SetShow( true, false )
		CheckButton_CameraLook:SetShow( true )
		CheckButton_CameraLook:SetAlpha(0)
		UIAni.AlphaAnimation( 1, CheckButton_CameraLook, 0.0, 0.2 )
		
		CheckButton_ToggleUi:SetShow( true )
		CheckButton_ToggleUi:SetAlpha(0)
		UIAni.AlphaAnimation( 1, CheckButton_ToggleUi, 0.0, 0.2 )
		
		--CheckButton_ImagePreset:SetShow( true )
		--CheckButton_ImagePreset:SetAlpha(0)
		--UIAni.AlphaAnimation( 1, CheckButton_ImagePreset, 0.0, 0.2 )
		
		Button_ScreenShot:SetShow( true )
		Button_ScreenShot:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Button_ScreenShot, 0.0, 0.2 )
		
		Button_ScreenShotFolder:SetShow( true )
		Button_ScreenShotFolder:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Button_ScreenShotFolder, 0.0, 0.2 )
		
		-- 상단 버튼 텍스트
		CheckButton_CameraLook_Title:SetShow( true )
		CheckButton_CameraLook_Title:SetAlpha(0)
		UIAni.AlphaAnimation( 1, CheckButton_CameraLook_Title, 0.0, 0.2 )
		
		CheckButton_ToggleUi_Title:SetShow( true )
		CheckButton_ToggleUi_Title:SetAlpha(0)
		UIAni.AlphaAnimation( 1, CheckButton_ToggleUi_Title, 0.0, 0.2 )
		
		--CheckButton_ImagePreset_Title:SetShow( true )
		--CheckButton_ImagePreset_Title:SetAlpha(0)
		--UIAni.AlphaAnimation( 1, CheckButton_ImagePreset_Title, 0.0, 0.2 )
		
		Button_ScreenShot_Title:SetShow( true )
		Button_ScreenShot_Title:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Button_ScreenShot_Title, 0.0, 0.2 )
		
		Button_ScreenShotFolder_Title:SetShow( true )
		Button_ScreenShotFolder_Title:SetAlpha(0)
		UIAni.AlphaAnimation( 1, Button_ScreenShotFolder_Title, 0.0, 0.2 )
	else
		local aniInfo_cam = UIAni.AlphaAnimation( 0, CheckButton_CameraLook, 0.0, 0.2 )
		aniInfo_cam:SetHideAtEnd(true)
		
		local aniInfo_ui = UIAni.AlphaAnimation( 0, CheckButton_ToggleUi, 0.0, 0.2 )
		aniInfo_ui:SetHideAtEnd(true)
		
		--local aniInfo_camPreset = UIAni.AlphaAnimation( 0, CheckButton_ImagePreset, 0.0, 0.2 )
		--aniInfo_camPreset:SetHideAtEnd(true)

		local aniInfo_ScreenShot = UIAni.AlphaAnimation( 0, Button_ScreenShot, 0.0, 0.2 )
		aniInfo_ui:SetHideAtEnd(true)
		
		local aniInfo_ScreenShotFolder = UIAni.AlphaAnimation( 0, Button_ScreenShotFolder, 0.0, 0.2 )
		aniInfo_ui:SetHideAtEnd(true)
		
		-- 상단 버튼 텍스트
		local aniInfo_cam_Title = UIAni.AlphaAnimation( 0, CheckButton_CameraLook_Title, 0.0, 0.2 )
		aniInfo_cam_Title:SetHideAtEnd(true)
		
		local aniInfo_ui_Title = UIAni.AlphaAnimation( 0, CheckButton_ToggleUi_Title, 0.0, 0.2 )
		aniInfo_ui_Title:SetHideAtEnd(true)
		
		--local aniInfo_camPreset_Title = UIAni.AlphaAnimation( 0, CheckButton_ImagePreset_Title, 0.0, 0.2 )
		--aniInfo_camPreset_Title:SetHideAtEnd(true)
		
		local aniInfo_ScreenShot_Title = UIAni.AlphaAnimation( 0, Button_ScreenShot_Title, 0.0, 0.2 )
		aniInfo_ui_Title:SetHideAtEnd(true)
		
		local aniInfo_ScreenShotFolder_Title = UIAni.AlphaAnimation( 0, CheckButton_ToggleUi, 0.0, 0.2 )
		aniInfo_ui_Title:SetHideAtEnd(true)
	end
	
end

local	currentCameraIndex = -1
function SetPresetCamNext()
	--currentCameraIndex = (currentCameraIndex + 1) % 5	--	프리셋4개 + 프리캠 해서 총 5개
	--SetPresetCam(currentCameraIndex)
end

function SetPresetCam(index)
	--setPresetCamera(index)	--	클라이언트 bind Func
	--SetPresetCamText(index)
end

function SetPresetCamText(index)
	if -1 == index then
		CheckButton_ImagePreset:SetText('user')
	elseif 0 == index then
		CheckButton_ImagePreset:SetText('cam 1')
	elseif 1 == index then
		CheckButton_ImagePreset:SetText('cam 2')
	elseif 2 == index then
		CheckButton_ImagePreset:SetText('cam 3')
	elseif 3 == index then
		CheckButton_ImagePreset:SetText('cam 4')
	elseif 4 == index then
		CheckButton_ImagePreset:SetText('freecam')
	end
end

function CustomizationMessage( message )
	if message ~= nil then
		StaticText_CustomizationMessage:SetText(message)
		StaticText_CustomizationMessage:SetSize( (StaticText_CustomizationMessage:GetTextSizeX() + 10 ) + StaticText_CustomizationMessage:GetSpanSize().x, 25 )
		StaticText_CustomizationMessage:SetSpanSize( 0, 0 )
		StaticText_CustomizationMessage:SetShow(true)
	--	if FGlobal_IsCommercialService() and (not InGameMode) then
	--		StaticText_CustomizationSubMessage:SetShow(true)
	--	end
	else
		StaticText_CustomizationMessage:SetText("")
		StaticText_CustomizationMessage:SetShow(false)
	--	if FGlobal_IsCommercialService() then
	--		StaticText_CustomizationSubMessage:SetShow(false)
	--	end
	end
end

-- History ( Do/Undo )
function CreateHistoryButton()
	for _, v in pairs(historyButtons) do
		v:SetShow( false )
		UI.deleteControl(v)
	end
	historyButtons = {}

	local count = getHistoryCount()
	for index=0, 9 do
		local tempButton = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_CustomizationMain, "BT_HISTORY_" .. index )
		local PosX = Button_SaveHistory:GetPosX()
		local PosY = Button_SaveHistory:GetPosY()
		CopyBaseProperty( RadioButton_HistoryTemp, tempButton )
		tempButton:SetPosX( PosX + Button_SaveHistory:GetSizeX() + 10 + ( tempButton:GetSizeX() + 2 ) * (index) )
		tempButton:SetPosY( PosY )
		tempButton:SetShow( true )
		if ( count > index ) then
			tempButton:addInputEvent( "Mouse_LUp", "HandleClicked_ApplyHistory(" .. index .. ")" )
		else
			local x1, y1, x2, y2 = setTextureUV_Func( tempButton, 124, 1, 153, 30 )
			tempButton:getBaseTexture():setUV( x1, y1, x2, y2 )
			tempButton:setRenderTexture( tempButton:getBaseTexture() )
			tempButton:SetIgnore( true )
		end
		
		historyButtons[index+1] = tempButton
		
	end
end

local historyIndex = 0
function HandleClicked_ApplyHistory( index )
	historyIndex = index
	local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_APPLY")
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = ApplyHistory, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function ApplyHistory()
	applyHistory(historyIndex)
end

function CustomizationAddHistory()
	addHistory()
	CreateHistoryButton()
end

function HandleClicked_CustomizationAddHistory()
	if( getHistoryCount() > 9 ) then
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_ADD_PRESET")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = CustomizationAddHistory, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		CustomizationAddHistory()
	end	
end
---------------------

function CloseCharacterCustomization()
	closeCustomizationMode = true
	CheckButton_ToggleUi:SetCheck(false)
	-- if Panel_CustomizationExpression:GetShow() then		--	expression
		-- closeExpressionUI()
	-- else
	
	if Panel_CustomizationCloth:GetShow() then		--	cloth
		closeClothUI()
	elseif Panel_CustomizationMotion:GetShow() then		--	motion
		closeMotionUi()
	elseif Panel_CustomizationFrame:GetShow() then	--	frame
		CloseFrame()
	end
	Panel_CustomizationMain:SetShow(false)	
end

function ShowCharacterCustomization( customizationData, classIndex, isInGame )
	closeCustomizationMode = false
	InGameMode = isInGame
	_classIndex = classIndex
	
	if( isInGame == true ) then
		mainButtonNum = 4
		Button_Char:SetShow( false )
		Button_SelectClass:SetShow( false )
		Button_Back:SetShow( false )
		btn_CharacterNameCreateRule:SetShow( false )
		Static_CharName:SetShow( false )
		Edit_CharName:SetShow( false )
		staticMainImage[5]:SetShow( false )
		
		StaticText_Zodiac:SetShow( false )
		Static_ZodiacImage:SetShow( false )
		StaticText_ZodiacName:SetShow( false )
		StaticText_ZodiacDescription:SetShow( false )
		Static_ZodiacIcon:SetShow( false )
		Static_ZodiacITooltip:SetShow( false )
		StaticText_FamilyNameTitle:SetShow(false)
		StaticText_FamilyName:SetShow(false)
		
	else
		mainButtonNum = 5
		Button_Char:SetShow( true )
		Button_SelectClass:SetShow( true )
		Button_Back:SetShow( true )
		btn_CharacterNameCreateRule:SetShow( true )
		Static_CharName:SetShow( true )
		Edit_CharName:SetShow( true )
		
		StaticText_Zodiac:SetShow( true )
		Static_ZodiacImage:SetShow( true )
		StaticText_ZodiacName:SetShow( true )
		StaticText_ZodiacDescription:SetShow( true )
		StaticText_FamilyNameTitle:SetShow(true)
		StaticText_FamilyName:SetShow(true)
		
	end
	

	if isGameTypeEnglish() then
		btn_CharacterNameCreateRule:SetShow( true )
	else
		btn_CharacterNameCreateRule:SetShow( false )
	end
	InitializeCustomizationData( customizationData, classIndex )
--	Panel_CustomizationMain:SetShow( true, false )
--	Panel_CustomizationStatic:SetShow( true, false )
	Panel_CustomizationMessage:SetShow( true, false )
--	Panel_CustomizationFrame:SetShow( false, false )
--	Panel_CustomizationMotion:SetShow( false, false )
--	Panel_CustomizationExpression:SetShow( false, false )
--	Panel_CustomizationCloth:SetShow( false, false )
--	Panel_Customization_Control:SetShow(true, false)
--	Panel_CustomizationMesh:SetShow( false, false )
	InitCustomizationMainUI()
	StaticText_CustomizationInfo:SetShow(true)
	StaticText_AuthorName:SetShow(true)
	StaticText_AuthorTitle:SetShow(true)
end
function EventApplyDefaultParams()
	applyDefaultCustomizationParams()
end

function EventSelectClass()
	restoreUIScale()
	changeCreateCharacterMode_SelectClass()
end

function EventSelectBack()
	showStaticUI(false)
	Panel_CustomizationMain:SetShow(false)
	restoreUIScale()
	characterCreateCancel()
end

function HandleClicked_CustomizationMain_applyDefaultCustomizationParams()
	local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLYDEFAULTPARAMS")
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = EventApplyDefaultParams, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function HandleClicked_CustomizationMain_SelectClass()
	local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_CANCEL")
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = EventSelectClass, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
	
	-- FileEXplorer.lua ( Explorer Close )
	closeExplorer()
end

function HandleClicked_CustomizationMain_Back()
	local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_CANCEL")
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = EventSelectBack, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
	
	-- FileEXplorer.lua ( Explorer Close )
	closeExplorer()
end

function HandleClicked_saveCustomizationData()
	-- 2016. 01. 11 // Charactor CustomizeData 저장 방식을 FileExplorer(탐색기 UI)를 사용하여 저장 하도록 변경 합니다.
	OpenExplorerSaveCustomizing()	-- FileExplorer_Customization.lua
	
	--[[
	if isExistCustomizationFile() then
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_SAVE")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = saveCustomizationData, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		saveCustomizationData()
	end
	]]--
end

function HandleClicked_RuleShow()
	local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_EN")
	local	messageBoxData = { title = PAGetString(Defines.StringSheet_RESOURCE, "COMMON_CHARACTERCREATEPOLICY_TITLE_EN"), content = messageBoxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData, "top")
end

function HandleClicked_loadCustomizationData()
	-- 2016. 01. 11 // Charactor CustomizeData 읽기 방식을 FileExplorer(탐색기 UI)를 사용하여 불러오기 하도록 변경 합니다.
	OpenExplorerLoadCustomizing()	-- FileExplorer_Customization.lua
	
	-- if not isExistCustomizationFile() then
		-- local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_LOAD_FAILED")
		-- local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		-- MessageBox.showMessageBox(messageBoxData)
	-- else
		-- local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MESSAGEBOX_APPLY")
		-- local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = loadCustomizationData, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		-- MessageBox.showMessageBox(messageBoxData)
	-- end
end

function CustomizationAuthorName( authorName )
	StaticText_AuthorName:SetText(authorName)
end
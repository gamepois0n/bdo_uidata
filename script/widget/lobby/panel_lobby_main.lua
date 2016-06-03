-------------------------------
-- Panel Init
-------------------------------
local UI_color			= Defines.Color
local UI_TM 			= CppEnums.TextMode
local UI_PUCT 			= CppEnums.PA_UI_CONTROL_TYPE
local ePcWorkingType 	= CppEnums.PcWorkType
local UI_Class			= CppEnums.ClassType

local const_64			= Defines.s64_const

local UCT_BUTTON 		= CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON
local UCT_RADIOBUTTON 	= CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON
local UCT_STATICTEXT 	= CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
local UCT_STATIC 		= CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC

-------------------------------
-- Control Regist & Init
-------------------------------
Panel_CharacterSelect:SetShow(false,false)
local CCSC_Frame		= UI.getChildControl( Panel_CharacterCreateSelectClass, "Frame_CharacterSelect")
local _frameContents	= UI.getChildControl( CCSC_Frame, "Frame_1_Content")

local _frameScroll		= UI.getChildControl( CCSC_Frame, "Frame_1_VerticalScroll")
-- local _frameScrollBtn	= UI.getChildControl( Panel_Lobby_UI._frameScroll, "VerticalScroll_CtrlButton")

-- 클래스 별 필요한 데이터
local Panel_Lobby_ClassUI = {
	ClassButtons = {},
	ClassNames = {},
	ClassStatus = {},
}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 													클래스 추가시 지정할 이미지 버튼 및 텍스트 컨트롤 직접 지정해줘야한다.

Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Warrior] 			= UI.getChildControl( _frameContents, "RadioButton_Select_Warrior" )
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Ranger] 			= UI.getChildControl( _frameContents, "RadioButton_Select_Ranger")
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Sorcerer] 			= UI.getChildControl( _frameContents, "RadioButton_Select_Sorcer")
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Giant] 				= UI.getChildControl( _frameContents, "RadioButton_Select_Giant")
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Tamer] 				= UI.getChildControl( _frameContents, "RadioButton_Select_Tamer")
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_BladeMaster] 		= UI.getChildControl( _frameContents, "RadioButton_Select_BladeMaster")
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_BladeMasterWomen] 	= UI.getChildControl( _frameContents, "RadioButton_Select_BladeMasterWomen")
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Valkyrie] 			= UI.getChildControl( _frameContents, "RadioButton_Select_Valkyrie")	
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Wizard] 			= UI.getChildControl( _frameContents, "RadioButton_Select_Wizard")
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_WizardWomen] 		= UI.getChildControl( _frameContents, "RadioButton_Select_WizardWomen") 
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_NinjaWomen] 		= UI.getChildControl( _frameContents, "RadioButton_Select_NinjaWomen") 
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_NinjaMan] 			= UI.getChildControl( _frameContents, "RadioButton_Select_Kunoichi") 
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_ShyWomen] 			= UI.getChildControl( _frameContents, "RadioButton_Select_ShyWomen") 
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Shy] 				= UI.getChildControl( _frameContents, "RadioButton_Select_Shy")
Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Temp] 				= UI.getChildControl( _frameContents, "RadioButton_Select_Temp")
-- Panel_Lobby_ClassUI.ClassButtons[UI_Class.ClassType_Kunoichi] 			= UI.getChildControl( _frameContents, "RadioButton_Select_Kunoichi")
	
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Warrior] 				= UI.getChildControl( _frameContents, "StaticText_WarriorName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Ranger] 				= UI.getChildControl( _frameContents, "StaticText_RangerName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Sorcerer] 			= UI.getChildControl( _frameContents, "StaticText_SorcerName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Giant] 				= UI.getChildControl( _frameContents, "StaticText_GiantName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Tamer] 				= UI.getChildControl( _frameContents, "StaticText_TamerName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_BladeMaster] 			= UI.getChildControl( _frameContents, "StaticText_BladeMasterName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_BladeMasterWomen] 	= UI.getChildControl( _frameContents, "StaticText_BladeMasterWomenName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Valkyrie] 			= UI.getChildControl( _frameContents, "StaticText_ValkyrieName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Wizard] 				= UI.getChildControl( _frameContents, "StaticText_WizardName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_WizardWomen] 			= UI.getChildControl( _frameContents, "StaticText_WizardWomenName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_NinjaWomen] 			= UI.getChildControl( _frameContents, "StaticText_NinjaWomenName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_NinjaMan] 			= UI.getChildControl( _frameContents, "StaticText_KunoichiName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_ShyWomen] 			= UI.getChildControl( _frameContents, "StaticText_ShyWomenName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Shy] 					= UI.getChildControl( _frameContents, "StaticText_ShyName")
Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Temp] 					= UI.getChildControl( _frameContents, "StaticText_TempName")
-- Panel_Lobby_ClassUI.ClassNames[UI_Class.ClassType_Kunoichi] 			= UI.getChildControl( _frameContents, "StaticText_KunoichiName")

Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Warrior]				= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Warrior")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Ranger]				= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Ranger")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Sorcerer]			= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Sorcerer")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Giant]				= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Giant")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Tamer]				= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_BeastMaster")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_BladeMaster]			= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_BladerMaster")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_BladeMasterWomen]	= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_BladerMasterWomen")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Valkyrie]			= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Valkyrie")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Wizard]				= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Wizard")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_WizardWomen]			= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Wizard")
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_NinjaWomen]			= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_NinjaWomen") -- 쿠노이치, 남자 닌자랑 동일.
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_NinjaMan]			= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_NinjaWomen") -- 쿠노이치, 남자 닌자랑 동일.
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_ShyWomen]			= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_NinjaWomen") -- 샤이족은 둘다 동일.
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Shy]					= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_NinjaWomen") -- 샤이족은 둘다 동일.
Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Temp]				= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Temp") -- 샤이족은 둘다 동일.
-- Panel_Lobby_ClassUI.ClassStatus[UI_Class.ClassType_Kunoichi]			= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Stat_Wizard") -- 변경 해주세요.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Panel_Lobby_UI = {

	--Create Character
	CC_CharacterCreateText			= UI.getChildControl( Panel_CharacterCreate, "StaticText_CharacterCreate"),
	CC_CharacterNameEdit			= UI.getChildControl( Panel_CharacterCreate, "Edit_CharacterName"),
	CC_CreateButton					= UI.getChildControl( Panel_CharacterCreate, "Button_CharacterCreateStart"),
	CC_BackButton					= UI.getChildControl( Panel_CharacterCreate, "Button_Back"),
	CC_DumiText1					= UI.getChildControl( Panel_CharacterCreate, "StaticText_1"),
	CC_characterCreateBG			= UI.getChildControl( Panel_CharacterCreate, "Static_BG"),
	CC_DumiText3					= UI.getChildControl( Panel_CharacterCreate, "StaticText_3"),
	CC_DumiText4					= UI.getChildControl( Panel_CharacterCreate, "StaticText_4"),

	CC_FrameHead					= UI.getChildControl( Panel_CharacterCreate, "Frame_Head"),
	CC_FrameHead_Content			= nil,
	CC_FrameHead_Content_Image		= nil,
	CC_FrameHead_Scroll				= nil,
	CC_FrameHair					= UI.getChildControl( Panel_CharacterCreate, "Frame_Hair"),
	CC_FrameHair_Content			= nil,
	CC_FrameHair_Content_Image		= nil,
	CC_FrameHair_Scroll				= nil,
	CC_SelectClassButton			= UI.getChildControl( Panel_CharacterCreate, "Button_SelectClass"),
	CC_CBTText						= UI.getChildControl( Panel_CharacterCreate, "StaticText_CBT"),


	-- 클래스 선택창 (Create Character - Select Class)
	CCSC_CreateTitle				= UI.getChildControl( Panel_CharacterCreateSelectClass, "StaticText_Title"),
	CCSC_ClassName					= UI.getChildControl( Panel_CharacterCreateSelectClass, "StaticText_ClassName"),
	CCSC_PartLine					= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_PartLine"),
	CCSC_ClassDescBG				= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_Desc_BG"),
	CCSC_ClassDesc					= UI.getChildControl( Panel_CharacterCreateSelectClass, "StaticText_Description"),
	CCSC_CreateButton				= UI.getChildControl( Panel_CharacterCreateSelectClass, "Button_CharacterCreateStart"),
	CCSC_CreateBG					= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_BG"),
	-- CCSC_ClassMovie					= UI.getChildControl( Panel_CharacterCreateSelectClass, "Static_MovieSize"),

	CCSC_ClassMovie					= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_CharacterCreateSelectClass, 'Static_ClassMovie'),
	
	CCSC_BackButton					= UI.getChildControl(Panel_CharacterCreateSelectClass, "Button_Back"),
	CCSC_SelectClassButton			= UI.getChildControl(Panel_CharacterCreateSelectClass, "Button_SelectClass"),
	
	-- 새 커스터 마이징 시 사용하는 edit text , 기존 name edit 와 해당 edit 둘 중 하나를 없애야 함.
	CM_StaticText_CharacterName		= UI.getChildControl(Panel_CustomizationMain, "StaticText_CharacterName"),
	CM_Edit_CharacterName			= UI.getChildControl(Panel_CustomizationMain, "Edit_CharacterName"),
}


local Character_Status = {
	
	_stat_Ctrl						= UI.getChildControl( Panel_CharacterCreateSelectClass, "StaticText_Stat_Ctrl"),
	_stat_Att						= UI.getChildControl( Panel_CharacterCreateSelectClass, "StaticText_Stat_Att"),
	_stat_Def						= UI.getChildControl( Panel_CharacterCreateSelectClass, "StaticText_Stat_Def"),
	_stat_Evd						= UI.getChildControl( Panel_CharacterCreateSelectClass, "StaticText_Stat_Evd"),
	_stat_Cmb						= UI.getChildControl( Panel_CharacterCreateSelectClass, "StaticText_Stat_Cmb"),
}

local Panel_Lobby_Global_Variable = {
	UIList							= {},
	UiMaker							= nil,
	characterSelect					= -1,
	notClearValueCharacterSelect	= -1,
	characterSelectType				= -1,
	selectRegionInfo				= nil,
	isWaitLine						= false,
	selectCharacterLevel			= -1,
	--lastTicketNoByRegion = const_64.s64_0,		-- 자신이 선택한 캐릭터에 접속하기 위한 region(령) 내에서의 대기 순번
}

local Panel_Lobby_Enum = {
	--create character scene / View control
	eRotate_Left					= 0,
	eRotate_Right					= 1,
	eDistance_Far					= 2,
	eDistance_Near					= 3,
	eArrow_Up						= 4,
	eArrow_Down						= 5,
	eArrow_Left						= 6,
	eArrow_Right					= 7,

	eCharacterCustomization_HeadMesh = 0,
	eCharacterCustomization_HairMesh = 1,
}

local sortCharacterCount = 1
local columnCountByRaw = 4
local columnCount = 0
local rowCount = 0
local classNameStartX = 18
local classNameStartY = 120
local classNameGapX = 17
local classNameGapY = 130
local classButtonStartX = 15
local classButtonGapX = 10
local classButtonGapY = 5

-- 하단부 현재 진행 상황
local _CharInfo_BG 		= UI.getChildControl ( Panel_CharacterSelect, "Static_CharInfo_BG" )
_CharInfo_BG:setGlassBackground( false )

local Panel_CharacterDoing =
{
	_CharInfo_Name 			= UI.getChildControl ( Panel_CharacterSelect, "StaticText_CharInfo_Name" ),
	_CharInfo_GaugeBG 		= UI.getChildControl ( Panel_CharacterSelect, "Static_CharInfo_GaugeBG" ),
	_CharInfo_Gauge 		= UI.getChildControl ( Panel_CharacterSelect, "Progress2_CharInfo_Gauge" ),
	_CharInfo_DoText 		= UI.getChildControl ( Panel_CharacterSelect, "StaticText_CharInfo_Do" ),
	_CharInfo_NowPos 		= UI.getChildControl ( Panel_CharacterSelect, "StaticText_CharInfo_NowPos" ),
	_CharInfo_WhereText 	= UI.getChildControl ( Panel_CharacterSelect, "StaticText_CharInfo_Where" ),
	_ticketNoByRegion		= UI.getChildControl ( Panel_CharacterSelect, "StaticText_TicketNoByRegion" ),
}

-- 캐릭터 버튼에 있는 미니미한 애들
local characterSelect_DoWork =
{
	_doWork_BG 			= UI.getChildControl ( Panel_CharacterSelect, "Static_Work_BG" ),
	_doWork_GaugeBG 	= UI.getChildControl ( Panel_CharacterSelect, "Static_Work_GaugeBG" ),
	_doWork_Gauge 		= UI.getChildControl ( Panel_CharacterSelect, "Static_Work_Gauge" ),
	_doWork_Icon 		= UI.getChildControl ( Panel_CharacterSelect, "Static_Work_Icon" ),
}

local Panel_Customization = {
	group = {},
}
local Panel_Lobby_LDownCheck_ViewControl = {}
local _headContentImage = {}
local _hairContentImage = {}

local characterTicketAbleUI = {}

-------------------------------
-- 구현부
-------------------------------
local Panel_Lobby_Function_Initialize = function()

	UI.ASSERT(nil ~= Panel_CharacterCreateSelectClass				,"createCharacter_SelectClass	nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CCSC_ClassName					,"CCSC_ClassName				nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CCSC_PartLine					,"CCSC_PartLine					nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CCSC_ClassDescBG				,"CCSC_ClassDescBG				nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CCSC_ClassDesc					,"CCSC_ClassDesc				nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CCSC_CreateButton				,"CCSC_CreateButton				nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CCSC_ClassMovie					,"CCSC_ClassMovie				nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CCSC_BackButton					,"CCSC_BackButton				nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CCSC_SelectClassButton			,"CCSC_SelectClassButton		nil")
	
	UI.ASSERT(nil ~= Panel_CharacterCreate							,"createCharacter			nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CC_CharacterCreateText			,"CC_CharacterCreateText	nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CC_CharacterNameEdit			,"CC_CharacterNameEdit		nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CC_CreateButton					,"CC_CreateButton			nil")
	UI.ASSERT(nil ~= Panel_Lobby_UI.CC_BackButton					,"CC_BackButton				nil")

	UI.ASSERT(nil ~= Panel_Lobby_UI.CC_SelectClassButton			,"CC_SelectClassButton		nil")	

	if isGameServiceTypeKor() then
		Panel_Lobby_UI.CC_CharacterNameEdit:SetMaxInput( 15 )
	elseif isGameServiceTypeDev() then
		Panel_Lobby_UI.CC_CharacterNameEdit:SetMaxInput( 15 )
	else
		Panel_Lobby_UI.CC_CharacterNameEdit:SetMaxInput( 30 )
	end
	
	Panel_Lobby_UI.CC_FrameHead_Content 		= UI.getChildControl(Panel_Lobby_UI.CC_FrameHead, "Frame_Head_Content")
	Panel_Lobby_UI.CC_FrameHead_Content_Image 	= UI.getChildControl(Panel_Lobby_UI.CC_FrameHead_Content, "Frame_Head_Content_Image")
	Panel_Lobby_UI.CC_FrameHead_Scroll 			= UI.getChildControl(Panel_Lobby_UI.CC_FrameHead, "Frame_Head_Scroll")

	Panel_Lobby_UI.CC_FrameHair_Content 		= UI.getChildControl(Panel_Lobby_UI.CC_FrameHair, "Frame_Hair_Content")
	Panel_Lobby_UI.CC_FrameHair_Content_Image 	= UI.getChildControl(Panel_Lobby_UI.CC_FrameHair_Content, "Frame_Hair_Content_Image")
	Panel_Lobby_UI.CC_FrameHair_Scroll 			= UI.getChildControl(Panel_Lobby_UI.CC_FrameHair, "Frame_Hair_Scroll")

	--시작시 모두 하이드
	-- Panel_CharacterSelect				:SetShow(false,false)
	Panel_CharacterCreate					:SetShow(false,false)
	Panel_CharacterCreateSelectClass		:SetShow(false,false) -- 클래스 선택창

	Panel_Lobby_UI.CCSC_CreateBG:SetSize(450, getScreenSizeY())

	Panel_Lobby_UI.CC_characterCreateBG:setGlassBackground(true)
	Panel_Lobby_UI.CCSC_CreateBG:setGlassBackground(true)

	-- 캐릭터 생성_클래스 선택화면
	Panel_Lobby_UI.CCSC_ClassName				:addInputEvent("Mouse_LUp", "")
	Panel_Lobby_UI.CCSC_PartLine				:addInputEvent("Mouse_LUp", "")
	Panel_Lobby_UI.CCSC_ClassDescBG				:addInputEvent("Mouse_LUp", "")
	Panel_Lobby_UI.CCSC_ClassDesc				:addInputEvent("Mouse_LUp", "")
	Panel_Lobby_UI.CCSC_CreateButton			:addInputEvent("Mouse_LUp", "changeCreateCharacterMode()")
	Panel_Lobby_UI.CCSC_BackButton				:addInputEvent("Mouse_LUp", "Panel_CharacterCreateCancel()")
	Panel_Lobby_UI.CCSC_SelectClassButton		:addInputEvent("Mouse_LUp", "")
	
	-- 클래스 별 선택 버튼 event 연결
	for index = 0 , UI_Class.ClassType_Count - 1 do
		if Panel_Lobby_ClassUI.ClassButtons[index] ~= nil then
			Panel_Lobby_ClassUI.ClassButtons[index]:addInputEvent("Mouse_LUp",	"Panel_Lobby_function_SelectClassType(" .. index .. ", true)"	)
			Panel_Lobby_ClassUI.ClassButtons[index]:addInputEvent("Mouse_On",	"Panel_Lobby_SelectClass_MouseEvent(" .. index .. ", true)"		)
			Panel_Lobby_ClassUI.ClassButtons[index]:addInputEvent("Mouse_Out",	"Panel_Lobby_SelectClass_MouseEvent(" .. index .. ", false)"	)
		end
	end
--{	생성 가능한 클래스에 따라서 버튼, 네임택 위치를 잡아준다.
	local count = getPossibleClassCount()
	for index = 0, count -1 do
		local classType		= getPossibleClassTypeFromIndex(index)
		local classButton	= Panel_Lobby_ClassUI.ClassButtons[ classType ]
		local className		= Panel_Lobby_ClassUI.ClassNames[ classType ]
		if classButton ~= nil and classButton:GetShow() then
			className		:SetPosX( (classNameStartX+className:GetPosX())+(className:GetSizeX()+classNameGapX)*columnCount )
			className		:SetPosY( (classNameStartY+className:GetPosY())+(className:GetSizeY()+classNameGapY)*rowCount )
			classButton		:SetPosX( (classButtonStartX+classButton:GetPosX())+(classButton:GetSizeX()+classButtonGapX)*columnCount )
			classButton		:SetPosY( classButton:GetPosY()+(classButton:GetSizeY()+classButtonGapY)*rowCount )
			
			if ( 0 == sortCharacterCount % columnCountByRaw ) then	-- 유료화 처리용 posIndex
				columnCount = 0
				rowCount		= rowCount + 1
			else
				columnCount		= columnCount + 1
			end
			sortCharacterCount	= sortCharacterCount + 1
		end
	end
--}

	--케릭터 생성화면
	Panel_Lobby_UI.CC_SelectClassButton			:addInputEvent("Mouse_LUp", "changeCreateCharacterMode_SelectClass()")

	Panel_Lobby_UI.CC_CreateButton				:addInputEvent("Mouse_LUp",		"Panel_CharacterCreateOk()")
	Panel_Lobby_UI.CC_BackButton				:addInputEvent("Mouse_LUp",		"Panel_CharacterCreateCancel()")
	
	-- 영상 임시 만들기
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_Lobby_UI.CCSC_ClassMovie:SetPosX( scrX - 441 )
	Panel_Lobby_UI.CCSC_ClassMovie:SetPosY( scrY - 372 )
	Panel_Lobby_UI.CCSC_ClassMovie:SetUrl(422, 237, "coui://UI_Data/UI_Html/Class_Movie.html")
	Panel_Lobby_UI.CCSC_ClassMovie:SetSize(422, 237)
	Panel_Lobby_UI.CCSC_ClassMovie:SetSpanSize(-1,0)
	Panel_Lobby_UI.CCSC_ClassMovie:SetShow(true)

end

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Processor별 Active 함수

-- 클래스 선택창
local Panel_Lobby_function_StartUp_CreateCharacter_SelectClass = function()
	Panel_Lobby_function_SelectClassType(UI_Class.ClassType_Warrior)
	Panel_Lobby_Global_Variable.UiMaker = Panel_CharacterCreateSelectClass
	Panel_Lobby_Global_Variable.UiMaker:SetSize(getScreenSizeX(), getScreenSizeY())
	Panel_CharacterCreateSelectClass:SetShow(true, false)
	Panel_CharacterCreateSelectClass:SetSize ( getScreenSizeX(), getScreenSizeY() )
	
	-----------------------------------------------
	--			스테이터스 보여주기
	-----------------------------------------------
	_frameContents:ComputePos()

	for _, value in pairs ( Character_Status ) do
		value:ComputePos()
	end
	
	for _, value in pairs ( Panel_Lobby_UI ) do
		value:ComputePos()
	end

	CCSC_Frame:ComputePos()
	CCSC_Frame:GetVScroll():SetControlTop()
	CCSC_Frame:UpdateContentPos()		-- 이 것을 빼면 버튼 내용을 제대로 불러오지 못한다.
	CCSC_Frame:UpdateContentScroll()	-- 이 것을 빼면 버튼 내용을 제대로 불러오지 못한다.
--{	캐릭터 얼굴 아이콘 프레임 사이즈 계산.
	local scrSizeY = getScreenSizeY()
	local sumSizeY = scrSizeY - (Panel_Lobby_UI.CCSC_ClassName:GetSizeY() + Panel_Lobby_UI.CCSC_ClassMovie:GetSizeY() + Panel_Lobby_UI.CCSC_ClassDescBG:GetSizeY() + 72)
	CCSC_Frame:SetSize( _frameContents:GetSizeX(), sumSizeY )
	if sumSizeY < _frameContents:GetSizeY() then
		_frameScroll:SetShow( true )
	else
		_frameScroll:SetShow( false )
	end
--}
	for classIndex = 0 , UI_Class.ClassType_Count - 1 do
		local classButton = Panel_Lobby_ClassUI.ClassButtons[ classIndex ] 
		local className = Panel_Lobby_ClassUI.ClassNames[ classIndex ] 
		local classStatus = Panel_Lobby_ClassUI.ClassStatus[ classIndex ] 
		
		if classButton ~= nil then
			classButton:SetShow( false )
			classButton:ComputePos()
		end 
		if className ~= nil then
			className:SetShow( false )
			className:ComputePos()
		end 
		
		if classStatus ~= nil then
			classStatus:ComputePos()
		end 
	end

	local ClassBtn_Show = function( classIndex )
		local classButton = Panel_Lobby_ClassUI.ClassButtons[ classIndex ]
		local className = Panel_Lobby_ClassUI.ClassNames[ classIndex ]
		
		if classButton ~= nil then 
			classButton:SetShow( true )
		end
		
		if className ~= nil then 
			className:SetShow( true )
		end
		
		-- if classButton ~= nil and classButton:GetShow() then
		-- 	className		:SetPosX( (classNameStartX+className:GetPosX())+(className:GetSizeX()+classNameGapX)*columnCount )
		-- 	className		:SetPosY( (classNameStartY+className:GetPosY())+(className:GetSizeY()+classNameGapY)*rowCount )
		-- 	classButton		:SetPosX( (classButtonStartX+classButton:GetPosX())+(classButton:GetSizeX()+classButtonGapX)*columnCount )
		-- 	classButton		:SetPosY( classButton:GetPosY()+(classButton:GetSizeY()+classButtonGapY)*rowCount )
			
		-- 	if ( 0 == sortCharacterCount % columnCountByRaw ) then	-- 유료화 처리용 posIndex
		-- 		columnCount = 0
		-- 		rowCount = rowCount + 1
		-- 	else
		-- 		columnCount = columnCount + 1
		-- 	end
		-- 	sortCharacterCount = sortCharacterCount + 1
		-- end
	end
	
	local count = getPossibleClassCount()
	for index = 0, count -1 do
		classType = getPossibleClassTypeFromIndex(index)
		ClassBtn_Show(classType)
	end
end


function Panel_Lobby_Function_showCharacterCreate_SelectClass()
	FGlobal_CharacterSelect_Close()	-- 캐릭터 선택창을 닫는다.

	Panel_Lobby_function_DeleteButton()
	Panel_Lobby_function_ClearData()
	Panel_Lobby_function_StartUp_CreateCharacter_SelectClass()
	Panel_CharacterCreate:SetShow(false,false)
	Panel_Customization_Control:SetShow(false, false)
	
	Panel_CustomizationMotion:SetShow( false, false )
	Panel_CustomizationExpression:SetShow( false, false )
	Panel_CustomizationCloth:SetShow( false, false )
	Panel_CustomizationTest:SetShow(false, false)
	Panel_CharacterCreateSelectClass:SetShow(true,false)
	Panel_CustomizationMesh:SetShow( false, false )
	Panel_CustomizationMain:SetShow( false, false )
	Panel_CustomizationStatic:SetShow( false, false )
	Panel_CustomizationMessage:SetShow( false, false )
	Panel_CustomizationFrame:SetShow( false, false )
	
	Panel_CharacterCreateSelectClass:SetSize( getScreenSizeY(), getScreenSizeX() )
end

function Panel_Lobby_Function_showCharacterCustomization( customizationData )
	Panel_Lobby_function_DeleteButton()
	Panel_CharacterCreateSelectClass:SetShow(false, false)
	Panel_Lobby_UI.CM_Edit_CharacterName:SetEditText('')

	resizeUIScale()
	ShowCharacterCustomization( customizationData, Panel_Lobby_Global_Variable.characterSelectType, false )
	viewCharacterCreateMode( Panel_Lobby_Global_Variable.characterSelectType )
end
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- 케릭터 선택화면 관련 함수들
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
function Panel_Lobby_function_ClearData()
	Panel_Lobby_Global_Variable.characterSelect = -1
	Panel_Lobby_Global_Variable.characterSelectType = -1
	Panel_Lobby_Global_Variable.selectRegionInfo = nil
end

---------------------------------------------------------------
--					클래스를 선택했다!!
---------------------------------------------------------------
function Panel_Lobby_function_SelectClassType( index, isOn )
	--_PA_LOG("lua_log", "Panel_Lobby_function_SelectClassType( index : "..index..")")
	if ( index < UI_Class.ClassType_Count ) then
		for key, value in pairs ( Panel_Lobby_ClassUI.ClassButtons ) do
			value:SetMonoTone( true )
			value:SetVertexAniRun( "Ani_Color_Reset", true )
			value:EraseAllEffect()
		end
		
		--------------------------------------
		--  선택한 클래스는 모노톤을 꺼주자
		Panel_Lobby_ClassUI.ClassButtons[index]:SetMonoTone( false )
		Panel_Lobby_ClassUI.ClassButtons[index]:AddEffect( "UI_CharactorSelcect_Line", true, 10, 4 )

		---------------------------------------------
		--			클래스별 영상을 켜준다
		local movieName = getClassMovie(index)

		if movieName ~= nil  then
			Panel_Lobby_UI.CCSC_ClassMovie:TriggerEvent("PlayMovie", "coui://" .. movieName)
		end
		viewCharacterCreateSelectClassMode(index )
		Panel_Lobby_Global_Variable.characterSelectType = index

		Panel_Lobby_UI.CCSC_ClassName:SetText( getClassName(index) )
		Panel_Lobby_UI.CCSC_ClassDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		Panel_Lobby_UI.CCSC_ClassDesc:SetText( getClassDescription(index) )
		
		-----------------------------------------------
		--			스테이터스 보여주기
		-----------------------------------------------
		for _, value in pairs ( Panel_Lobby_ClassUI.ClassStatus ) do
			value:SetShow(false)
		end
		Panel_Lobby_ClassUI.ClassStatus[index]:SetShow(true)
	end
end

function Panel_Lobby_SelectClass_MouseEvent( index, isOn )
	--_PA_LOG("lua_log", "Panel_Lobby_SelectClass_MouseEvent( index : "..index..")")
	local classButton = Panel_Lobby_ClassUI.ClassButtons[index]
	if classButton ~= nil then 
		if ( isOn == true ) then
			classButton:SetVertexAniRun( "Ani_Color_Bright", true )
		else
			classButton:ResetVertexAni()
		end
	end
end

function Panel_CharacterCreateOk()
	chracterCreate( Panel_Lobby_Global_Variable.characterSelectType, Panel_Lobby_UI.CC_CharacterNameEdit:GetEditText() )
end

-- 기존의 캐릭터 생성 함수 대체 Panel_CharacterCreateOK 차 후 기존 함수는 삭제해주자
function Panel_CharacterCreateOK_NewCustomization()
	chracterCreate( Panel_Lobby_Global_Variable.characterSelectType, Panel_Lobby_UI.CM_Edit_CharacterName:GetEditText() )
	ClearFocusEdit()
end

function Panel_CharacterCreateCancel()
	Panel_CharacterCreateSelectClass:SetShow(false) 
	characterCreateCancel()
end

function Panel_Lobby_function_DeleteButton( )
	if ( nil == Panel_Lobby_Global_Variable.UiMaker ) then
		return
	end

	for _, value in pairs(Panel_Lobby_Global_Variable.UIList) do
		UI.deleteControl(value)
	end

	Panel_Lobby_Global_Variable.UIList = {}
	Panel_Lobby_Global_Variable.UiMaker = nil
end


------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Initialize
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
Panel_Lobby_Function_Initialize()
registerEvent("EventChangeLobbyStageToCharacterCreate_SelectClass", "Panel_Lobby_Function_showCharacterCreate_SelectClass") -- 클래스 선택창

-- zezzeg : 커스터마이징 테스트 시 아래의 함수가 호출된다.
registerEvent("EventCharacterCustomizationInitUi", "Panel_Lobby_Function_showCharacterCustomization")

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

Panel_CharacterSelectNew:SetShow( false )

-------------------------------
-- Control Regist & Init
-------------------------------
local SelectCharacter = {
	panelTitle					= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_CharacterSelect"),		-- 좌측 상단 타이틀
	btn_EmptySlot				= UI.getChildControl( Panel_CharacterSelectNew, "Button_CreateSlot" ),				-- 빈 슬롯
	btn_CharacterSlot			= UI.getChildControl( Panel_CharacterSelectNew, "Button_Character0" ),				-- 캐릭터 슬롯
	static_CharacterState		= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_Character0"),			-- 캐릭터명 아래 상태 표시
	static_ConnectionState		= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_UserCount" ),			-- 연결 할 수 있는지
	static_CharacterLevel		= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_CharLevel" ),			-- 캐릭터 레벨
	btn_Create					= UI.getChildControl( Panel_CharacterSelectNew, "Button_CharacterCreate"),			-- 생성 버튼
	btn_Delete					= UI.getChildControl( Panel_CharacterSelectNew, "Button_CharacterDelete"),			-- 삭제 버튼
	btn_StartGame				= UI.getChildControl( Panel_CharacterSelectNew, "Button_Start"),					-- 게임 접속 버튼

	static_PenelBG				= UI.getChildControl( Panel_CharacterSelectNew, "Static_BG"),						-- 우측 BG
	static_FamilyName			= UI.getChildControl( Panel_CharacterSelectNew, "FamilyName" ),					-- 맨위 가문명
	btn_ServerSelect			= UI.getChildControl( Panel_CharacterSelectNew, "Button_BackServerSelect" ),
	btn_EndGame					= UI.getChildControl( Panel_CharacterSelectNew, "Button_EndGame" ),

	static_DeleteCancelTitle	= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_DeleteTitle" ),		-- 삭제 정보
	static_DeleteCancelDate		= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_DeleteDate" ),			-- 삭제 대기 시간
	btn_DeleteCancel			= UI.getChildControl( Panel_CharacterSelectNew, "Button_CharacterDeleteCancel"),
	static_DeleteBox			= UI.getChildControl( Panel_CharacterSelectNew, "Static_DeleteBox"),
	
	
	static_CharacterInfoBG		= UI.getChildControl( Panel_CharacterSelectNew, "Static_CharInfo_BG" ),
	btn_ChaInfoStart			= UI.getChildControl( Panel_CharacterSelectNew, "Button_StartCharacter"),
	btn_ChaInfoDelete			= UI.getChildControl( Panel_CharacterSelectNew, "Button_DeleteCharacter"),
	static_ChaInfoName			= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_CharInfo_Name"),
	static_ChaInfoProgressBG	= UI.getChildControl( Panel_CharacterSelectNew, "Static_CharInfo_GaugeBG"),
	static_ChaInfoProgress		= UI.getChildControl( Panel_CharacterSelectNew, "Progress2_CharInfo_Gauge"),
	static_ChaInfoProgressText	= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_CharInfo_Do"),
	static_ChaInfo_DoRemainTime	= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_CharInfo_RemainTime" ),
	static_ChaInfoNowLoc		= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_CharInfo_NowPos"),
	static_ChaInfoNowLocValue	= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_CharInfo_Where"),
	static_ticketNoByRegion		= UI.getChildControl( Panel_CharacterSelectNew, "StaticText_TicketNoByRegion" ),
	
	_scroll						= UI.getChildControl( Panel_CharacterSelectNew, "Scroll_SlotList"),

	--UIPOOL----------------------------------------------------------------------------------------------------------
}
SelectCharacter._ScrollBtn		= UI.getChildControl( SelectCharacter._scroll, "Scroll_CtrlButton")
local configData = {
	maxSlot				= 0,
	maxCountSlot		= 0,
	maxScrollCount		= 0,
	freeCount			= 0,
	haveCount			= 0,
	useAbleCount		= 0,
	_startIndex			= 0,
	_listCount			= 9,
	_initList			= 12,
	selectCaracterIdx 	= -1,
	isWaitLine			= false,
	slotUiPool			= {}
}


local getCharacterMaxSlotData = function( )
	local maxcount = 0;
	if( getCharacterDataCount() <= getCharacterSlotMaxCount() ) then
		maxcount		= getCharacterSlotLimit()+1 
	else
		maxcount		= getCharacterDataCount()
	end

	return maxcount;
end

local getMaxCharacsterCount = function()
	local characterMaxCount = 0
	local scrSizeY = getScreenSizeY()
	if getCharacterDataCount() < getCharacterSlotMaxCount() then
		characterMaxCount = getCharacterSlotMaxCount()
	else
		characterMaxCount = getCharacterDataCount()
	end
	
	return characterMaxCount
end

local SelectCharacter_Init = function()
	Panel_CharacterSelectNew:SetShow(true)
	Panel_CharacterSelectNew:SetSize( getScreenSizeX(), getScreenSizeY() )

	-- { 캐릭터 리스트
		SelectCharacter.static_PenelBG			:AddChild		( SelectCharacter.btn_ServerSelect )
		SelectCharacter.static_PenelBG			:AddChild		( SelectCharacter.btn_EndGame )
		SelectCharacter.static_PenelBG			:AddChild		( SelectCharacter.static_FamilyName )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.btn_ServerSelect )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.btn_EndGame )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_FamilyName )
		SelectCharacter.static_PenelBG			:SetSize		( SelectCharacter.static_PenelBG:GetSizeX(), getScreenSizeY() )

		SelectCharacter.static_PenelBG			:ComputePos()
		SelectCharacter.static_FamilyName		:ComputePos()
		SelectCharacter.btn_ServerSelect		:ComputePos()
		SelectCharacter.btn_EndGame				:ComputePos()
		SelectCharacter.btn_DeleteCancel		:ComputePos()
		SelectCharacter._scroll					:ComputePos()

		SelectCharacter.btn_ServerSelect		:addInputEvent("Mouse_LUp", "CharacterSelect_Back()")
		SelectCharacter.btn_EndGame				:addInputEvent("Mouse_LUp", "CharacterSelect_ExitGame()")
		SelectCharacter.btn_DeleteCancel		:addInputEvent("Mouse_LUp", "CharacterSelect_DeleteCancelCharacter()")
	--}

	-- { 선택 캐릭터 정보
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.btn_ChaInfoStart )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.btn_ChaInfoDelete )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.static_ChaInfoName )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.static_ChaInfoProgressBG )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.static_ChaInfoProgress )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.static_ChaInfoProgressText )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.static_ChaInfoNowLoc )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.static_ChaInfoNowLocValue )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.static_ticketNoByRegion )
		SelectCharacter.static_CharacterInfoBG	:AddChild		( SelectCharacter.static_ChaInfo_DoRemainTime )
		
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.btn_ChaInfoStart )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.btn_ChaInfoDelete )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_ChaInfoName )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_ChaInfoProgressBG )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_ChaInfoProgress )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_ChaInfoProgressText )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_ChaInfoNowLoc )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_ChaInfoNowLocValue )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_ticketNoByRegion )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_ChaInfo_DoRemainTime )

		SelectCharacter.static_CharacterInfoBG	:ComputePos()
		SelectCharacter.static_CharacterInfoBG	:SetSpanSize( SelectCharacter.static_PenelBG:GetSizeX() + 15, 5 )
		SelectCharacter.static_CharacterInfoBG	:SetShow( false )

		SelectCharacter.static_ticketNoByRegion	:SetShow( true )

		SelectCharacter.btn_ChaInfoStart		:addInputEvent("Mouse_LUp", "CharacterSelect_SelectEnterToGame()")
		SelectCharacter.btn_ChaInfoDelete		:addInputEvent("Mouse_LUp", "CharacterSelect_DeleteCharacter()")
	-- }

	-- { 삭제 정보
		SelectCharacter.static_DeleteBox		:AddChild		( SelectCharacter.static_DeleteCancelTitle )
		SelectCharacter.static_DeleteBox		:AddChild		( SelectCharacter.static_DeleteCancelDate )
		SelectCharacter.static_DeleteBox		:AddChild		( SelectCharacter.btn_DeleteCancel )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_DeleteCancelTitle )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.static_DeleteCancelDate )
		Panel_CharacterSelectNew				:RemoveControl	( SelectCharacter.btn_DeleteCancel )

		SelectCharacter.static_DeleteBox		:ComputePos()
		SelectCharacter.static_DeleteBox		:SetSpanSize( -(SelectCharacter.static_PenelBG:GetSizeX()/2), 0 )
		SelectCharacter.static_DeleteBox		:SetShow( false )
	-- }

	local scrSizeY = getScreenSizeY()
	local scrSizeSumY = scrSizeY - SelectCharacter.static_FamilyName:GetSizeY() - SelectCharacter.btn_EndGame:GetSizeY()
	local btnSizeY = SelectCharacter.btn_Create:GetSizeY() + 15

	local _btnCount = math.floor(scrSizeSumY / btnSizeY)
	SelectCharacter._scroll:SetSize( SelectCharacter._scroll:GetSizeX(), btnSizeY*_btnCount )
	configData._listCount = _btnCount
	
	local self = SelectCharacter
	for slotIdx = 0, configData._listCount-1 do
		local slot = {}
		slot._btn_Slot	= UI.createAndCopyBasePropertyControl( Panel_CharacterSelectNew, "Button_CreateSlot",		self.static_PenelBG,	"SelectCharacter_EmptySlot_"	.. slotIdx )
		slot._ChaStat	= UI.createAndCopyBasePropertyControl( Panel_CharacterSelectNew, "StaticText_Character0",	slot._btn_Slot,			"SelectCharacter_ChaStat_"	.. slotIdx )	-- StaticText_Character0		-- 캐릭터명 아래 상태 표시
		slot._ContStat	= UI.createAndCopyBasePropertyControl( Panel_CharacterSelectNew, "StaticText_UserCount",	slot._btn_Slot,			"SelectCharacter_ContStat_"	.. slotIdx )	-- StaticText_UserCount			-- 연결 할 수 있는지
		slot._ChaLev	= UI.createAndCopyBasePropertyControl( Panel_CharacterSelectNew, "StaticText_CharLevel",	slot._btn_Slot,			"SelectCharacter_ChaLev_"	.. slotIdx )	-- StaticText_CharLevel			-- 캐릭터 레벨
		slot._btnCreate	= UI.createAndCopyBasePropertyControl( Panel_CharacterSelectNew, "Button_CharacterCreate",	slot._btn_Slot,			"SelectCharacter_btnCreate_"	.. slotIdx )	-- Button_CharacterCreate		-- 생성 버튼
		slot._btnStart	= UI.createAndCopyBasePropertyControl( Panel_CharacterSelectNew, "Button_Start",			slot._btn_Slot,			"SelectCharacter_btnStart_"	.. slotIdx )	-- Button_Start		-- 시작 버튼
		-- slot._btnDelete	= UI.createAndCopyBasePropertyControl( Panel_CharacterSelectNew, "Button_CharacterDelete",	slot._btn_Slot,			"SelectCharacter_btnDelete_"	.. slotIdx )	-- Button_CharacterDelete		-- 삭제 버튼

		slot._btn_Slot:SetText( "" )

		slot._btn_Slot	:SetPosX( 12 )
		slot._btn_Slot	:SetPosY( (SelectCharacter.static_FamilyName:GetSizeY() + 5) + ((slot._btn_Slot:GetSizeY() + 5) * slotIdx) )
		slot._ChaStat	:SetPosX( 300 )
		slot._ChaStat	:SetPosY( 15 )
		slot._ContStat	:SetPosX( 300 )
		slot._ContStat	:SetPosY( 20 )
		slot._ChaLev	:SetPosX( 65 )
		slot._ChaLev	:SetPosY( 35 )
		slot._btnCreate	:SetPosX( 280 )
		slot._btnCreate	:SetPosY( 5 )
		slot._btnStart	:SetPosX( 280 )
		slot._btnStart	:SetPosY( 5 )

		slot._btn_Slot	:SetShow( false )
		slot._ChaStat	:SetShow( false )
		slot._ContStat	:SetShow( false )
		slot._ChaLev	:SetShow( false )
		slot._btnCreate	:SetShow( false )
		slot._btnStart	:SetShow( false )
		slot._btn_Slot	:addInputEvent("Mouse_UpScroll",	"SelectCharacter_ScrollEvent( true )")
		slot._btn_Slot	:addInputEvent("Mouse_DownScroll",	"SelectCharacter_ScrollEvent( false )")
		slot._btnStart	:addInputEvent("Mouse_UpScroll",	"SelectCharacter_ScrollEvent( true )")
		slot._btnStart	:addInputEvent("Mouse_DownScroll",	"SelectCharacter_ScrollEvent( false )")

		configData.slotUiPool[slotIdx] = slot
	end
	SelectCharacter.static_PenelBG			:addInputEvent(	"Mouse_UpScroll",	"SelectCharacter_ScrollEvent( true )"	)
	SelectCharacter.static_PenelBG			:addInputEvent(	"Mouse_DownScroll",	"SelectCharacter_ScrollEvent( false )"	)

	UIScroll.InputEvent( SelectCharacter._scroll,				"SelectCharacter_ScrollEvent" )
	UIScroll.InputEventByControl( SelectCharacter._scroll,		"SelectCharacter_ScrollEvent" )
end

local CharacterView = function( index, classType )
	if classType == UI_Class.ClassType_Warrior then	-- 워리어
		viewCharacter(index, -50, -40, -65, 0.15)
		viewCharacterPitchRoll(0.0, 0.0)
		viewCharacterFov(0.75)	-- 0.0 ~ 6.28 사이값
		setWeatherTime(8 ,1)
		
	elseif classType == UI_Class.ClassType_Ranger then	-- 레인저
		viewCharacter(index, -40, -10, -40, 0.45)
		viewCharacterPitchRoll(-0.05, 0.0)
		viewCharacterFov(0.55)	-- 0.0 ~ 6.28 사이값
		setWeatherTime(8 ,0)
		
	elseif classType == UI_Class.ClassType_Sorcerer then	-- 소서러
		viewCharacter(index, -40, -30, -75, 0.55)
		viewCharacterPitchRoll(-0.0, -0.0)
		setWeatherTime(8 ,9)
		viewCharacterFov(0.55)
		
	elseif classType == UI_Class.ClassType_Giant then	-- 자이언트
		viewCharacter(index, -50, -25, -94, -0.6)
		viewCharacterPitchRoll(0.2, 0.0)
		setWeatherTime(8 ,3)
		
	elseif classType == UI_Class.ClassType_Tamer then	-- 금수랑
		viewCharacter(index, -30, -50, -94, -0.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		setWeatherTime(8 ,17)
		viewCharacterFov(0.55)
		
	elseif classType == UI_Class.ClassType_BladeMaster then	-- 무사
		viewCharacter(index, -20, -45, -94, -0.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		setWeatherTime(8 ,21)
		viewCharacterFov(0.75)
	elseif classType == UI_Class.ClassType_BladeMasterWomen then	-- 매화(여자 무사)
		viewCharacter(index, -20, -25, -114, -0.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		setWeatherTime(8 ,23)
		viewCharacterFov(0.75)
	elseif classType == UI_Class.ClassType_Valkyrie then	-- 발키리
		viewCharacter(index, -20, -20, -94, 1.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		viewCharacterFov(0.65)	-- 0.0 ~ 6.28 사이값
		setWeatherTime(8 ,20)

	elseif classType == UI_Class.ClassType_Wizard then	-- 법사남
		viewCharacter(index, -20, -20, -94, 1.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		setWeatherTime(8 ,19)
		viewCharacterFov(0.55)
		
	elseif classType == UI_Class.ClassType_WizardWomen then	-- 법사여
		viewCharacter(index, -20, -20, -94, 1.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		setWeatherTime(8 ,21)
		viewCharacterFov(0.55)

	elseif classType == UI_Class.ClassType_NinjaWomen then	-- 쿠노이치
		viewCharacter(index, -25, -25, -94, 1.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		setWeatherTime(8 ,18)
		viewCharacterFov(0.55)

	elseif classType == UI_Class.ClassType_NinjaMan then -- 닌자
		viewCharacter(index, -20, -20, -100, 1.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		setWeatherTime(8 ,18)
		viewCharacterFov(0.55)
	elseif classType == UI_Class.ClassType_ShyWomen then -- 샤이족 여자
		-- 작업해주세요.
	elseif classType == UI_Class.ClassType_Shy then -- 샤이족 남자
		-- 작업해주세요.
	elseif classType == UI_Class.ClassType_Temp then -- 매화 임시
		viewCharacter(index, -20, -45, -114, -0.1)
		viewCharacterPitchRoll(-0.0, 0.0)
		setWeatherTime(8 ,23)
		viewCharacterFov(0.75)
	elseif classType == UI_Class.ClassType_Kunoichi then -- ?????
		-- 작업해주세요.
	else
		viewCharacter(index, 0, 0, 0, 0)
		viewCharacterPitchRoll(3.14, 0.0)
	end
end

local ChangeTexture_Class = function( control, classType )
	if ( classType == UI_Class.ClassType_Warrior ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		
		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )

	elseif ( classType == UI_Class.ClassType_Ranger ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )

	elseif ( classType == UI_Class.ClassType_Sorcerer ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 367, 458, 427 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 428, 458, 488 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )

	elseif ( classType == UI_Class.ClassType_Giant ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )

	elseif ( classType == UI_Class.ClassType_Tamer ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_BladeMaster ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_BladeMasterWomen ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_Valkyrie ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_Wizard ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_WizardWomen ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_NinjaWomen ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 184, 458, 244 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_06.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	elseif ( classType == UI_Class.ClassType_NinjaMan ) then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())

		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV( x1, y1, x2, y2 )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_07.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV( x1, y1, x2, y2 )

	else
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )
		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 367, 458, 427 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )
	end
end

local ChangeTexture_Slot = function( isFree, control )
	if true == isFree then
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/lobby_classselect_btn_01.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 245, 458, 305 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		
		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/lobby_classselect_btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 306, 458, 366 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/lobby_classselect_btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 367, 458, 427 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )
	else
		control:ChangeTextureInfoName("New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_03.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 1, 458, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		
		control:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_03.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 62, 458, 122 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )

		control:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Window/Lobby/Lobby_ClassSelect_Btn_03.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 2, 123, 458, 183 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )
	end
end

local What_R_U_Doing_Now = function()
	local characterData	= getCharacterDataByIndex( configData.selectCaracterIdx )
	local workName		= "-"
	local progressRate	= 0

	if nil ~= characterData then
		local characterName			= getCharacterName( characterData )
		local removeTime			= getCharacterDataRemoveTime( configData.selectCaracterIdx )
		local pcDeliveryRegionKey	= characterData._arrivalRegionKey
		local serverUtc64			= getServerUtc64()
		local whereIs				= "-"
		local regionInfo			= nil

		if 0 ~= characterData._currentPosition.x and 0 ~= characterData._currentPosition.y and 0 ~= characterData._currentPosition.z then
			-- 0 이라면 생성만하고 접속을 한번도 하지 않은 캐릭터이다. text를 보여주지 않는다.
			if 0 ~= pcDeliveryRegionKey:get() and characterData._arrivalTime < serverUtc64 then
				regionInfo	= getRegionInfoByRegionKey( pcDeliveryRegionKey )
				local retionInfoArrival = getRegionInfoByRegionKey( pcDeliveryRegionKey )
				whereIs		= retionInfoArrival:getAreaName()
			else
				regionInfo	= getRegionInfoByPosition( characterData._currentPosition )
				whereIs		= regionInfo:getAreaName()
			end
		end

		SelectCharacter.static_ChaInfo_DoRemainTime:SetShow( false )	-- 일단 끄고.
		if 0 ~= pcDeliveryRegionKey:get() then
			if serverUtc64 < characterData._arrivalTime then
				local remainTime = characterData._arrivalTime - serverUtc64
				local strTime  = convertStringFromDatetime( remainTime )
				SelectCharacter.static_ChaInfo_DoRemainTime:SetShow( true )
				SelectCharacter.static_ChaInfo_DoRemainTime:SetText( strTime )
			end
			workName = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_DELIVERY" )	-- 캐릭터 이동 중
		else
			if ePcWorkingType.ePcWorkType_Empty == characterData._pcWorkingType or ePcWorkingType.ePcWorkType_Play == characterData._pcWorkingType then
				workName = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_NONE" )
			elseif ePcWorkingType.ePcWorkType_RepairItem == characterData._pcWorkingType then
				workName = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_REPAIRITEM" )
			elseif ePcWorkingType.ePcWorkType_Relax == characterData._pcWorkingType then
				workName = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_RELEX" )
			elseif ePcWorkingType.ePcWorkType_ReadBook == characterData._pcWorkingType then
				local totalWorkingTime = characterData._workingStartCompletingDate - characterData._workingStartDate
				local workedTime = serverUtc64 - characterData._workingStartDate
				progressRate = string.format( "%.1f", (Int64toInt32(workedTime) / Int64toInt32(totalWorkingTime) * 100 ) )
				workName = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_READBOOK" )
			else
				_PA_ASSERT(false, "캐릭터 작업 타입이 추가 되었습니다. Lobby_New.lua 에도 추가해 주어야 합니다.")
			end
		end

		SelectCharacter.static_ChaInfoName			:SetText( characterName )
		SelectCharacter.static_ChaInfoProgress		:SetProgressRate( progressRate )
		SelectCharacter.static_ChaInfoProgressText	:SetText( workName )
		SelectCharacter.static_ChaInfoNowLocValue	:SetText( whereIs )
		SelectCharacter.static_ticketNoByRegion		:SetText( whereIs )
		
		if nil ~= removeTime then
			SelectCharacter.static_DeleteCancelDate:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_DELETE") .. " ( " .. removeTime .. " )" )
			SelectCharacter.static_DeleteBox:SetShow( true )
			SelectCharacter.btn_ChaInfoDelete:SetShow( false )
			SelectCharacter.btn_ChaInfoStart:SetShow( false )
			SelectCharacter.static_ticketNoByRegion:SetShow( false )	-- 바로 접속 가능 (삭제중인 캐릭터는 안보이게)
			SelectCharacter.static_ChaInfoProgressText:SetText( PAGetString( Defines.StringSheet_GAME, "CHARACTER_DELETING" ) )	-- 삭제중인 캐릭터는 "대기 중 -> 삭제중"
		else
			SelectCharacter.static_DeleteBox:SetShow( false )
			SelectCharacter.btn_ChaInfoDelete:SetShow( true )
			SelectCharacter.btn_ChaInfoStart:SetShow( true )
			SelectCharacter.static_ticketNoByRegion:SetShow( true )
		end

		if 0 == progressRate then
			SelectCharacter.static_ChaInfoProgress		:SetShow( false )
			SelectCharacter.static_ChaInfoProgressBG	:SetShow( false )
		else
			SelectCharacter.static_ChaInfoProgress		:SetShow( true )
			SelectCharacter.static_ChaInfoProgressBG	:SetShow( true )
		end
		
		SelectCharacter.static_ChaInfoName			:SetShow( true )
		SelectCharacter.static_ChaInfoProgressText	:SetShow( true )
		SelectCharacter.static_ChaInfoNowLoc		:SetShow( true )
		SelectCharacter.static_ChaInfoNowLocValue	:SetShow( true )

		SelectCharacter.static_CharacterInfoBG		:SetShow( true )
	end
end

local CharacterCustomization_Close = function()
	Panel_Customization_Control			:SetShow( false, false )
	Panel_CustomizationTest				:SetShow( false, false )
	Panel_CharacterCreateSelectClass	:SetShow( false, false )
	Panel_CustomizationTransform		:SetShow( false, false )
	Panel_CustomizationMesh				:SetShow( false, false )
	Panel_CustomizationMain				:SetShow( false, false )
	Panel_CustomizationStatic			:SetShow( false, false )
	Panel_CustomizationMessage			:SetShow( false, false )
	Panel_CustomizationFrame			:SetShow( false, false )
	Panel_CustomizationMotion			:SetShow( false, false )
	Panel_CustomizationExpression		:SetShow( false, false )
	Panel_CustomizationCloth			:SetShow( false, false )
end


local getMaxCharacsterScrollCount = function()
	--[[
	local characterMaxCount = 0
	local scrSizeY = getScreenSizeY()
	if getCharacterDataCount() < getCharacterSlotMaxCount() then
		characterMaxCount = getCharacterSlotMaxCount()
	else
		local scrSizeSumY = scrSizeY - SelectCharacter.static_FamilyName:GetSizeY() - SelectCharacter.btn_EndGame:GetSizeY()
		local btnSizeY = SelectCharacter.btn_Create:GetSizeY() + 15

		local _btnCount = math.floor(scrSizeSumY / btnSizeY)
		if _btnCount <= getCharacterDataCount() then
			characterMaxCount = _btnCount
		else
			characterMaxCount = getCharacterDataCount()
		end
	end
	
	return characterMaxCount
	]]--
	
	
	local scrSizeY = getScreenSizeY()
	local scrSizeSumY = scrSizeY - SelectCharacter.static_FamilyName:GetSizeY() - SelectCharacter.btn_EndGame:GetSizeY()
	local btnSizeY = SelectCharacter.btn_Create:GetSizeY() + 15
	local _btnCount = math.floor(scrSizeSumY / btnSizeY)
	
	local characterCount = getCharacterDataCount()
	local useableSlotCount = getCharacterSlotLimit()
	local maxSlotCount = getCharacterSlotMaxCount()
	
	local scrollCount	= 0
	
	-- 존재하는 캐릭터 출력
	scrollCount	= scrollCount + characterCount
		
	-- 캐릭 생성가능 첫번째 슬롯 출력
	if characterCount < useableSlotCount then
		scrollCount	= scrollCount + 1
	end

	-- 캐릭 생성가능 두번째 이상 슬롯 출력
	if (characterCount+1) < useableSlotCount then
		scrollCount	= scrollCount + (useableSlotCount - (characterCount+1))
	end
	
	-- 확장가능한 슬롯 출력. 단, 서버통합으로 이미 캐릭터가 초과할 수 있다.
	if (characterCount < maxSlotCount) and (useableSlotCount < maxSlotCount) then
		scrollCount = scrollCount + 1
	end
	
	-- 시작 index & 최대개수 반영
	scrollCount	= scrollCount - configData._startIndex
	if _btnCount < scrollCount then
		scrollCount = _btnCount
	end
	
	return scrollCount
end

-- getCharacterSlotMaxCount() : 캐릭터 슬롯 제한 수 (ContentsOption)
-- getCharacterSlotLimit()    : 기본 캐릭터 슬롯 + 확장권으로 늘린 슬롯 수

function scrollTotalCount()
	local characterCount = getCharacterDataCount()
	local useableSlotCount = getCharacterSlotLimit()
	local maxSlotCount = getCharacterSlotMaxCount()
	
	local maxCount = characterCount
	if(characterCount < useableSlotCount) then
		maxCount = maxCount + (useableSlotCount - characterCount)
	end

	if(maxCount < maxSlotCount) then
		maxCount = maxCount + 1
	end
	
	return maxCount
end


local CharacterList_Update = function()
	-- if( getCharacterDataCount() < getCharacterSlotLimit() ) then
		-- configData.maxSlot		= getCharacterSlotLimit()+1 
	-- else
		-- configData.maxSlot		= getCharacterDataCount()
	-- end
	
	configData.maxSlot			= getCharacterMaxSlotData() -- getCharacterSlotMaxCount()		-- 최대 생성 가능한 캐릭터 슬롯 수
	configData.maxCountSlot		= getMaxCharacsterCount()
	configData.maxScrollCount	= getMaxCharacsterScrollCount()
	configData.freeCount		= getCharacterSlotDefaultCount()	-- 무료 생성 가능한 캐릭터 슬롯 수 (현재 3)
	configData.haveCount		= getCharacterDataCount()			-- 만들어진 캐릭터 수
	configData.useAbleCount 	= getCharacterSlotLimit()			-- 쓸 수 있는 카운트
	-- { 초기화
		for slotIdx = 0, configData._listCount-1 do			-- 초기화
			local slot = configData.slotUiPool[slotIdx]
			slot._btn_Slot	:SetShow( false )
			slot._ChaStat	:SetShow( false )
			slot._ContStat	:SetShow( false )
			slot._ChaLev	:SetShow( false )
			slot._btnCreate	:SetShow( false )
			slot._btnStart	:SetShow( false )

			slot._btn_Slot	:SetIgnore( false )
		end
		SelectCharacter.static_ChaInfoName				:SetText( "Lv. 0" )
		SelectCharacter.static_ChaInfoProgressText		:SetText( "-" )
		SelectCharacter.static_ChaInfoNowLocValue		:SetText( "" )
		SelectCharacter.static_ticketNoByRegion			:SetText( "" )
	-- }


	SelectCharacter.static_FamilyName:SetText( getFamilyName() )	-- 가문명 설정.

	if -1 == configData.selectCaracterIdx then	-- 로그인 할 때는 -1로 온다.
		configData.selectCaracterIdx = 0
	end
	local scrollListIndex = 0
	local maxCharacter = getMaxCharacsterScrollCount()

	local iii = 0
	for slotIdx = configData._startIndex, (maxCharacter + configData._startIndex) - 1 do
		--[[
		if configData._listCount <= iii then
			break
		end
		]]--

		local slot = configData.slotUiPool[iii]
		iii = iii + 1
		slot._btn_Slot	:SetTextHorizonLeft()
		slot._btn_Slot	:SetTextVerticalTop()
		slot._btn_Slot	:SetTextSpan( 70, 7 )
		-- 슬롯 기본 텍스쳐 처리.
		if slotIdx < configData.freeCount then
			ChangeTexture_Slot( true, slot._btn_Slot )
		else
			if slotIdx < configData.useAbleCount then
				ChangeTexture_Slot( true, slot._btn_Slot )
			else
				ChangeTexture_Slot( false, slot._btn_Slot )
			end
		end
		
		-- 열린 슬롯 처리.
		if slotIdx < configData.haveCount then
			local characterData		= getCharacterDataByIndex( slotIdx )
			local characterName		= getCharacterName( characterData )
			local classType			= getCharacterClassType( characterData )
			local characterLevel	= string.format( "Lv. %d", characterData._level )
			local regionInfo		= nil
			local removeTime		= getCharacterDataRemoveTime( slotIdx )
			if	nil ~= removeTime then
				characterName	= ( characterName .. " " .. PAGetString(Defines.StringSheet_GAME, "CHARACTER_DELETING") )
			end

			-- { 캐릭터 직업 텍스쳐 변경}
				ChangeTexture_Class( slot._btn_Slot, classType )
			-- }

			slot._btn_Slot	:SetText( characterName )
			slot._ChaLev	:SetText( characterLevel )

			if configData.selectCaracterIdx == slotIdx then	-- 번호에 맞춰 캐릭터를 그린다.
				CharacterView( configData.selectCaracterIdx, classType )
				slot._btn_Slot:SetCheck( true )
			else
				slot._btn_Slot:SetCheck( false )
			end

			slot._btn_Slot	:addInputEvent( "Mouse_LUp", "CharacterSelect_selected( " .. slotIdx .. " )" )
			slot._btnStart	:addInputEvent( "Mouse_LUp", "CharacterSelect_PlayGame( " .. slotIdx .. " )" )
			-- slot._btnCreate	:addInputEvent( "Mouse_LUp", "" )

			slot._btn_Slot	:SetShow( true )
			slot._ChaStat	:SetShow( false )
			slot._ContStat	:SetShow( false )
			slot._ChaLev	:SetShow( true )
			slot._btnCreate	:SetShow( false )

			if	nil ~= removeTime then
				slot._btnStart	:SetShow( false )
			else
				slot._btnStart	:SetShow( true )
			end

			slot._btn_Slot	:SetIgnore( false )
		else
			slot._btn_Slot	:addInputEvent( "Mouse_LUp", "CharacterSelect_CreateNewCharacter()" )
			slot._btnStart	:addInputEvent( "Mouse_LUp", "" )

			slot._btn_Slot	:SetShow( true )
			slot._ChaStat	:SetShow( false )
			slot._ContStat	:SetShow( false )
			slot._ChaLev	:SetShow( false )
			slot._btnCreate	:SetShow( false )
			slot._btnStart	:SetShow( false )

			slot._btn_Slot	:SetIgnore( false )

			if configData.haveCount == slotIdx then	-- 다음 슬롯에서 생성할 수 있다.
				slot._btn_Slot	:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CREATENEWCHARACTER_BTN" ) ) -- "캐릭터 생성"

				slot._btn_Slot	:SetTextHorizonCenter()
				slot._btn_Slot	:SetTextVerticalCenter()
				slot._btn_Slot	:SetTextSpan( 50, 0 )

				slot._btn_Slot	:SetEnable		( true )
				slot._btn_Slot	:SetMonoTone	( false )
				slot._btnCreate	:SetShow		( false )

				if configData.freeCount <= slotIdx and configData.useAbleCount <= slotIdx then
					slot._btn_Slot	:SetIgnore	( true )
					slot._btn_Slot	:SetText( "" )
					slot._btnCreate	:SetShow	( false )
				end
			else
				if configData.freeCount <= slotIdx and configData.useAbleCount <= slotIdx then
					slot._btn_Slot	:SetText( "" )
				end
				slot._btn_Slot	:SetText( "" )
				slot._btn_Slot	:SetIgnore		( true )
				slot._btn_Slot	:SetEnable		( false )
				slot._btn_Slot	:SetMonoTone	( true )
				slot._btnCreate	:SetShow		( false )
			end
		end
		scrollListIndex = scrollListIndex + 1
	end

	UIScroll.SetButtonSize			( SelectCharacter._scroll, configData.maxScrollCount, scrollTotalCount() )

	-- { 선택된 캐릭터 처리.
		What_R_U_Doing_Now()
		local selectedCharacterData = getCharacterDataByIndex( configData.selectCaracterIdx )
		if nil ~= selectedCharacterData then
			CharacterSelect_setUpdateTicketNo( selectedCharacterData )
		end
	-- }
end

function SelectCharacter_ScrollEvent( isUp )
	local	self		= SelectCharacter
	
	configData._startIndex	= UIScroll.ScrollEvent( self._scroll, isUp, configData.maxScrollCount, scrollTotalCount(), configData._startIndex, 1 )
	CharacterList_Update()
end

function CharacterSelect_selected( index )
	configData.selectCaracterIdx = index
	CharacterList_Update()
end

function CharacterSelect_PlayGame( index )
	configData.selectCaracterIdx = index
	local characterData = getCharacterDataByIndex( index )
	local characterCount = getCharacterDataCount()
	local serverUtc64 = getServerUtc64()
	-- Panel_Lobby_Global_Variable.characterSelect = index
	if ( nil ~= characterData ) then
		if (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT)
			or (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_OBT)
			or (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Commercial)
		then
			if 1 == characterData._level and 1 == characterCount then
				FGlobal_FirstLogin_Open( index )
			else
				local pcDeliveryRegionKey = characterData._arrivalRegionKey
				if (ePcWorkingType.ePcWorkType_Empty ~= characterData._pcWorkingType and ePcWorkingType.ePcWorkType_Play ~= characterData._pcWorkingType) or (0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime) then
					if 0 ~= pcDeliveryRegionKey:get() then
					--if ePcWorkingType.ePcWorkType_Delivery == characterData._pcWorkingType then
					-- if ePcWorkingType.ePcWorkType_Delivery == characterData._pcWorkingType then
						contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_CHANGE_Q") .. PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_MAIN_MOVECHARACTER_MSG")
					elseif ePcWorkingType.ePcWorkType_ReadBook == characterData._pcWorkingType then
						contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_READ_BOOK")--"캐릭터가 책을 읽는 중입니다. 교체하실 경우 책읽기가 취소됩니다"
					elseif ePcWorkingType.ePcWorkType_RepairItem == characterData._pcWorkingType then
						contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_REPAIR")
					end

					local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE"), content = contentString, functionYes = CharacterSelect_SelectEnterToGame, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW } -- "캐릭터 이동중 입니다.. 교체하겠습니까?"
					MessageBox.showMessageBox( messageboxData )
				else
					selectCharacter( configData.selectCaracterIdx )
				end
			end
		else
			local titleText = PAGetString( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY" )
			local messageboxData = { title = titleText, content = PAGetString(Defines.StringSheet_GAME, "PANEL_LOBBY_PREDOWNLOAD"), functionApply = MessageBox_Empty_function , priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW, exitButton = false }
			MessageBox.showMessageBox(messageboxData)
		
		end
	end
end

function CharacterSelect_SelectEnterToGame()
	selectCharacter( configData.selectCaracterIdx )
end

function CharacterSelect_Open( characterIndex )	-- 열린다.
	if -1 == characterIndex then
		configData.selectCaracterIdx = 0
	elseif -2 == characterIndex then
			configData.selectCaracterIdx = configData.selectCaracterIdx
	else
		configData.selectCaracterIdx = characterIndex
	end

	CharacterCustomization_Close()	-- 커마에서 넘어오면 꺼줘야 한다.
	
	CharacterList_Update()
	Panel_CharacterSelectNew:SetShow( true )
end

function CharacterSelect_ExitGame()
	local do_Exit = function()
		disConnectToGame()	
		GlobalExitGameClient()
	end
	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_TITLE"), content = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_MEMO"), functionYes = do_Exit, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function CharacterSelect_Back()
	Panel_CharacterSelectNew:SetShow( false )
	backServerSelect()
end

function CharacterSelect_DeleteCharacter()
	if ( -1 ~= configData.selectCaracterIdx ) then
		local do_Delete = function()
			deleteCharacter( configData.selectCaracterIdx )
		end

		local characterData = getCharacterDataByIndex( configData.selectCaracterIdx )
		if ( nil == characterData ) then
			return
		end
		
		local removeTimeCheckLevel 	= getCharacterRemoveTimeCheckLevel()
		local removeTime 			= convertStringFromDatetime( getCharacterRemoveTime() )
		
		local messageContent	= ""
		if(characterData._level < removeTimeCheckLevel) then
			messageContent	= PAGetStringParam1(Defines.StringSheet_GAME, "CHARACTER_IMMEDIATE_DELETE_MESSAGEBOX_MEMO", "character_name", getCharacterName(characterData) )
		else
			messageContent	= PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_DELETE") -- 캐릭터 삭제는 일정 시간이 필요합니다. 자세한 내용은 공지사항을 확인해주세요.\n※삭제된 캐릭터는 복구가 불가합니다.

			--PAGetStringParam3(Defines.StringSheet_GAME, "CHARACTER_LATER_DELETE_MESSAGEBOX_MEMO", "character_removeLevel", removeTimeCheckLevel, "character_removeTime", removeTime, "character_name", getCharacterName(characterData) )
		end
		
		local messageboxData	= { title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_DELETE_MESSAGEBOX_TITLE"), content = messageContent, functionYes = do_Delete, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData, "top")
	end
end

function CharacterSelect_DeleteCancelCharacter()
	if ( -1 ~= configData.selectCaracterIdx ) then
		deleteCancelCharacter( configData.selectCaracterIdx )
	end
	
	-- Panel_Lobby_UI.SC_CharacterDeleteCancelButton:SetShow(false)
	-- Panel_Lobby_UI.SC_CharacterDeleteCancelTitle:SetShow(false)
	-- Panel_Lobby_UI.SC_CharacterDeleteCancelDate:SetShow(false)
end

function FGlobal_CharacterSelect_Close()
	Panel_CharacterSelectNew:SetShow( false )
end

function CharacterSelect_CreateNewCharacter()
	if Panel_Win_System:GetShow() then
		return
	end

	local do_Create = function()
		changeCreateCharacterMode_SelectClass()
	end

	local messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CREATENEWCHARACTER_NOTIFY" )
	-- "새로운 캐릭터를 만드시겠습니까?"
	local messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERSELECT_CREATENEWCHARACTER_BTN" ), content = messageContent, functionYes = do_Create, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData, "middle")
end


-- { 대기열 처리
	function CharacterSelect_setUpdateTicketNo( characterData )
		local firstTicketNo					= getFirstTicketNoByAll()
		local currentTicketNo				= getCurrentTicketNo()
		local ticketCountByRegion			= characterData._lastTicketNoByRegion
		local myRegionWaitingPlayerCount	= currentTicketNo - ticketCountByRegion
		local serverPlayingCount			= currentTicketNo - firstTicketNo

		if const_64.s64_m1 ~= firstTicketNo or const_64.s64_m1 ~= ticketCountByRegion then
			SelectCharacter.static_ticketNoByRegion:SetFontColor( Defines.Color.C_FFD20000 )
			SelectCharacter.static_ticketNoByRegion:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NOT_ENTER_TO_FIELD") )
		else
			SelectCharacter.static_ticketNoByRegion:SetFontColor( Defines.Color.C_FF96D4FC )
			SelectCharacter.static_ticketNoByRegion:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENTER_TO_FIELD") )
		end
	end

	-- 대기열 창을 닫기 응답이 왔을 경우 호출된다.
	function cancelEnterWaitingLine()
		if true == configData.isWaitLine then
			MessageBox_HideAni()
			configData.isWaitLine = false
		end
	end

	-- 대기열 표시
	function makeEnterWaitingUserMsg( receiveTicketNoMyRegion )
		local ticketCountByRegion = receiveTicketNoMyRegion						-- 해당 region의 티켓 번호
		local waitingLineCancelCount = getCancelCount()
		if -1 == ticketCountByRegion then
			local selectedCharacterData	= getCharacterDataByIndex( configData.selectCaracterIdx )
			local regionInfo			= getRegionInfoByPosition(selectedCharacterData._currentPosition)
			local regionGroupKey		= 1	-- 기본값 벨리아
			if nil ~= regionInfo then
				regionGroupKey = regionInfo:getRegionGroupKey()
			end

			ticketCountByRegion = getTicketCountByRegion( regionGroupKey )
		end

		local currentTicketNo				= getCurrentTicketNo()			-- 나의 티켓번호
		local firstTicketNoByAll			= getFirstTicketNoByAll()		-- 서버 최초 티켓번호 ( -1 : 은 현재 대기자 없음 )
		
		local totalWaitingPlayerCount		= getAllWaitingLine() - getAllCancelCount() --currentTicketNo - firstTicketNoByAll
		local myRegionWaitingPlayerCount	= getMyWaitingLine() - getCancelCount()	--currentTicketNo - waitingLineCancelCount -- ticketCountByRegion

		if totalWaitingPlayerCount < 0 then
			totalWaitingPlayerCount = 0
		end
		
		if myRegionWaitingPlayerCount <= 0 then
			myRegionWaitingPlayerCount = 0
		end
		local waitMsg		= PAGetString( Defines.StringSheet_GAME, "CHARACTER_WAIT_MESSAGE" )
		local serverWaitStr = PAGetStringParam1( Defines.StringSheet_GAME, "CHARACTER_SERVER_WAIT_COUNT", "iCount", tostring( totalWaitingPlayerCount ) )
		local regionWaitStr = PAGetStringParam1( Defines.StringSheet_GAME, "CHARACTER_REGION_WAIT_COUNT", "iCount", tostring( myRegionWaitingPlayerCount ) )
		local emptyStr = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WAITING_PLAYER_EMPTY")
			
		if const_64.s64_m1 == firstTicketNoByAll and const_64.s64_m1 ~= ticketCountByRegion then
			strWaitingMsg = waitMsg .. "\n\n" .. regionWaitStr
		elseif (const_64.s64_m1 == ticketCountByRegion and const_64.s64_m1 ~= firstTicketNoByAll) or (const_64.s64_m1 ~= ticketCountByRegion and 0 == myRegionWaitingPlayerCount) then
			strWaitingMsg = waitMsg .. "\n\n" .. serverWaitStr .. "\n\n" .. PAGetString( Defines.StringSheet_GAME, "CHARACTER_REGION_WAIT_TEXT" ) .. emptyStr
		else
			strWaitingMsg = waitMsg .. "\n\n" .. serverWaitStr .. "\n\n" .. regionWaitStr
		end
		
		return strWaitingMsg
	end

	-- 대기열 수신
	function receiveEnterWaiting()
		configData.isWaitLine = true
		local characterData = getCharacterDataByIndex( configData.selectCaracterIdx )
		if ( nil == characterData ) then
			UI.ASSERT( false, "캐릭터 선택이 되지 않았나...?" )
			return
		end

		SelectCharacter.static_ticketNoByRegion:SetFontColor( Defines.Color.C_FFD20000 )
		SelectCharacter.static_ticketNoByRegion:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NOT_ENTER_TO_FIELD") )
		
		local strWaitingMsg = makeEnterWaitingUserMsg( characterData._lastTicketNoByRegion )
		local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_ENTER_WAITING_TITLE"), content = strWaitingMsg, functionCancel = click_EnterWaitingCancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m }	--functionYes = Panel_Lobby_function_SelectEnterToGame, 
		MessageBox.showMessageBox( messageboxData )
	end

	-- 대기중 갱신
	function setEnterWaitingUserCount()
		if false == configData.isWaitLine then
			return
		end
		local strWaitingMsg = makeEnterWaitingUserMsg( -1 )

		local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "CHARACTER_ENTER_WAITING_TITLE"), content = strWaitingMsg, functionCancel = click_EnterWaitingCancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1m }	--functionYes = Panel_Lobby_function_SelectEnterToGame, 
		if true == MessageBox.doHaveMessageBoxData( messageboxData.title ) then
			setCurrentMessageData( messageboxData )
		else
			MessageBox.showMessageBox( messageboxData )
		end
	end

	function click_EnterWaitingCancel()
		if true == configData.isWaitLine then
			sendEnterWaitingCancel()
		end
	end
--}

SelectCharacter_Init()

registerEvent("EventChangeLobbyStageToCharacterSelect", "CharacterSelect_Open")

-- { 대기열 처리
	registerEvent( "EventCancelEnterWating", "cancelEnterWaitingLine" )
	registerEvent( "EventReceiveEnterWating" , "receiveEnterWaiting" )
	registerEvent( "EventSetEnterWating" , "setEnterWaitingUserCount" )
-- }
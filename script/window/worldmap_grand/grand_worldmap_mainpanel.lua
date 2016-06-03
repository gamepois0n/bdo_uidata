local IM 				= CppEnums.EProcessorInputMode
local UI_color 			= Defines.Color
local UI_ST				= CppEnums.SpawnType
local UI_TM				= CppEnums.TextMode
local UI_ANI_ADV		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV				= CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT				= CppEnums.PAUI_TEXTURE_TYPE
local currentTownMode	= false
local eWorldmapState 	= CppEnums.WorldMapState;
local eCheckState 		= CppEnums.WorldMapCheckState; 

local worldmapGrand = {
	ui			= {
		ModeBG					= UI.getChildControl( Panel_WorldMap_Main, "Mode_Bg"),
		
		MainMenuBG				= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Bg"),
		edit_NodeName			= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Edit_NodeName"),
		btn_SearchNodeName		= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Button_NodeSearch"),
		edit_ItemName			= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Edit_ItemName"),
		btn_SearchItemName		= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Button_ItemSearch"),
		edit_UseType			= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Edit_UseType"),
		btn_SearchUseType		= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Button_UseTypeSearch"),
		
		searchPartLine			= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Static_Partline"),
		explorePointBG			= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Static_ExplorePoint_Bg"),
		explorePointIcon		= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_ExplorePoint_Icon"),
		explorePointValue		= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_StaticText_ExplorePoint_Value"),
		explorePointProgressBG	= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Static_ExplorePoint_Progress_BG"),
		explorePointProgress	= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Static_ExplorePoint_Progress"),
		explorePointHelp		= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Static_ExplorePoint_Help"),
		
		ListBG					= UI.getChildControl( Panel_WorldMap_Main, "List_Bg"),
		list_Title				= UI.getChildControl( Panel_WorldMap_Main, "List_Title"),
		list_KeyWord			= UI.getChildControl( Panel_WorldMap_Main, "List_KeyWord"),
		list_SearchBG			= UI.getChildControl( Panel_WorldMap_Main, "List_SearchListBG"),
		list_scroll				= UI.getChildControl( Panel_WorldMap_Main, "Scroll_List"),
	},

	searchResultUiPool	= {},

	template	= {
		templateButton	= UI.getChildControl( Panel_WorldMap_Main, "Mode_Button" ),			-- 메뉴용
		templateCheck	= UI.getChildControl( Panel_WorldMap_Main, "Mode_ToggleButton"),	-- 모드 선택용
		templateRadio	= UI.getChildControl( Panel_WorldMap_Main, "MainMenu_Button_1" ),	-- 노드 타입용
	},

	config = {
		searchingResultMaxCount	= 6,
		searchingResultCount	= 0,
		searchType				= 0,
		selectNodeType			= 0,
		scrollStartIdx			= 0,
		searchDefaultNodeName	= PAGetString(Defines.StringSheet_GAME, "LUA_GRANDWORLDMAP_SEARCHDEFAULT_NODENAME"), -- "거점명"
		searchDefaultItemName	= PAGetString(Defines.StringSheet_GAME, "LUA_GRANDWORLDMAP_SEARCHDEFAULT_ITEMNAME"), -- "제작 아이템명"
		searchDefaultUseType	= PAGetString(Defines.StringSheet_GAME, "LUA_GRANDWORLDMAP_SEARCHDEFAULT_USETYPE"), -- "용도명"
	}
}
worldmapGrand.ui.list_scrollBtn = UI.getChildControl( worldmapGrand.ui.list_scroll, "Scroll_CtrlButton")


function isWorldMapGrandOpen()
	return true
end

Panel_WorldMap_Main:SetShow(false, false);
worldmapGrand.template.templateButton	:SetShow(false)
worldmapGrand.template.templateCheck	:SetShow(false)
worldmapGrand.template.templateRadio	:SetShow(false)

local worldMapState			= {}	-- 우측 하단 버튼
local worldMapCheckState	= {}	-- 우측 상단 체크버튼
local worldMapNodeListType	= {}	-- 좌측 상단 노드 타입 라디오 버튼

local worldMapCheckStateInMode = {
	[eWorldmapState.eWMS_EXPLORE_PLANT] 		= {},
	[eWorldmapState.eWMS_REGION]				= {},	
	[eWorldmapState.eWMS_LOCATION_INFO_WATER]	= {},	
	[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]	= {},
	[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]= {},	
	[eWorldmapState.eWMS_GUILD_WAR]				= {},
	[eWorldmapState.eWMS_SIMPLE]				= {},	
	[eWorldmapState.eWMS_QUEST]					= {},
	[eWorldmapState.eWMS_TRADE]					= {},
}

local modeTexture = {
	[eWorldmapState.eWMS_EXPLORE_PLANT] 		= { [0] = { 97, 6, 126, 35 },		[1] = { 127, 6, 156, 35 },		[2] = { 157, 6, 186, 35 } },
	[eWorldmapState.eWMS_REGION]				= { [0] = { 97, 36, 126, 65 },		[1] = { 127, 36, 156, 65 },		[2] = { 157, 36, 186, 65 } },
	[eWorldmapState.eWMS_LOCATION_INFO_WATER]	= { [0] = { 97, 66, 126, 95 },		[1] = { 127, 66, 156, 95 },		[2] = { 157, 66, 186, 95 } },
	[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]	= { [0] = { 97, 96, 126, 125 },		[1] = { 127, 96, 156, 125 },	[2] = { 157, 96, 186, 125 } },
	[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]= { [0] = { 97, 126, 126, 155 },	[1] = { 127, 126, 156, 155 },	[2] = { 157, 126, 186, 155 } },
	[eWorldmapState.eWMS_GUILD_WAR]				= { [0] = { 97, 156, 126, 185 },	[1] = { 127, 156, 156, 185 },	[2] = { 157, 156, 186, 185 } },
	[eWorldmapState.eWMS_SIMPLE]				= { [0] = { 187, 246, 216, 275 },	[1] = { 217, 246, 246, 275 },	[2] = { 247, 246, 276, 275 } },
	[eWorldmapState.eWMS_QUEST]					= { [0] = { 187, 6, 216, 35 },		[1] = { 217, 6, 246, 35 },		[2] = { 247, 6, 276, 35 } },
	[eWorldmapState.eWMS_TRADE]					= { [0] = { 6, 126, 35, 155 },		[1] = { 36, 126, 65, 155 },		[2] = { 66, 126, 95, 155 } },
}

local changeModeTexture = function( modeType )
	local control	= worldMapState[modeType]
	local posArray	= modeTexture[modeType]

	control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WorldMap/WorldMap_Etc_05.dds" )

	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[0][1], posArray[0][2], posArray[0][3], posArray[0][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[1][1], posArray[1][2], posArray[1][3], posArray[1][4] )
	control:getOnTexture():setUV(  x1, y1, x2, y2  )
	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[2][1], posArray[2][2], posArray[2][3], posArray[2][4] )
	control:getClickTexture():setUV(  x1, y1, x2, y2  )

	control:setRenderTexture(control:getBaseTexture())
end


local modeFilterTexture = {
	[eCheckState.eCheck_Quest] 			= { [0] = { 187, 6, 216, 35 },		[1] = { 217, 6, 246, 35 },		[2] = { 247, 6, 276, 35 } },
	[eCheckState.eCheck_Knowledge] 		= { [0] = { 187, 36, 216, 65 },		[1] = { 217, 36, 246, 65 },		[2] = { 247, 36, 276, 65 } },
	[eCheckState.eCheck_FishnChip] 		= { [0] = { 187, 66, 216, 95 },		[1] = { 217, 66, 246, 95 },		[2] = { 247, 66, 276, 95 } },
	[eCheckState.eCheck_Node] 			= { [0] = { 187, 186, 216, 215 },	[1] = { 217, 186, 246, 215 },	[2] = { 247, 186, 276, 215 } },
	[eCheckState.eCheck_Way] 			= { [0] = { 187, 96, 216, 125 },	[1] = { 217, 96, 246, 125 },	[2] = { 247, 96, 276, 125 } },
	[eCheckState.eCheck_Postions] 		= { [0] = { 187, 126, 216, 155 },	[1] = { 217, 126, 246, 155 },	[2] = { 247, 126, 276, 155 } },
	[eCheckState.eCheck_Trade] 			= { [0] = { 187, 216, 216, 245 },	[1] = { 217, 216, 246, 245  },	[2] = { 247, 216, 276, 245 } },
	[eCheckState.eCheck_Wagon] 			= { [0] = { 187, 156, 216, 185 },	[1] = { 217, 156, 246, 185 },	[2] = { 247, 156, 276, 185 } },
}

local changeModeFilterTexture = function( modeFilterType )
	local control	= worldMapCheckState[modeFilterType]
	local posArray	= modeFilterTexture[modeFilterType]

	control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WorldMap/WorldMap_Etc_05.dds" )

	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[0][1], posArray[0][2], posArray[0][3], posArray[0][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[1][1], posArray[1][2], posArray[1][3], posArray[1][4] )
	control:getOnTexture():setUV(  x1, y1, x2, y2  )
	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[2][1], posArray[2][2], posArray[2][3], posArray[2][4] )
	control:getClickTexture():setUV(  x1, y1, x2, y2  )

	control:setRenderTexture(control:getBaseTexture())
end


local worldMapNodeType = {			-- 노드타입
	normal			= 0,	--  노드
	viliage			= 1,	--  마을
	city			= 2,	--  도시
	gate			= 3,	--  관문
	-- farm			= 4,	--  농장
	trade			= 5,	--  무역
	-- collect			= 6,	--  채집장
	-- quarry			= 7,	--  채석장
	-- logging			= 8,	--  벌목장
	dangerous		= 9,	--  위험 지역
	-- finance			= 10,	--  금융 거래소
	-- fishTrap		= 11,	--  통발
	-- minorFinance	= 12,	--  마이너 자산 관리소 ( 1등이 아니라도 쓸수 있음 )
	-- monopolyFarm	= 13,	--  직영농장
	-- note			= 14,	-- 위치 메모(클라에는 없음.)
}

local nodeList = {
	[0] = worldMapNodeType.normal,
	[1] = worldMapNodeType.viliage,
	[2] = worldMapNodeType.city,
	[3] = worldMapNodeType.gate,
	[4] = worldMapNodeType.trade,
	[5] = worldMapNodeType.dangerous,
	-- [6] = worldMapNodeType.note,
}
local nodeListCount = 6	-- 늘어나면 수정해야 한다.

local nodeTexture = {
	[worldMapNodeType.normal]		= { [0] = { 6, 6, 35, 35 },		[1] = { 36, 6, 65, 35 },	[2] = { 66, 6, 95, 35 } },
	[worldMapNodeType.viliage]		= { [0] = { 6, 36, 35, 65 },	[1] = { 36, 36, 65, 65 },	[2] = { 66, 36, 95, 65 } },
	[worldMapNodeType.city]			= { [0] = { 6, 66, 35, 95 },	[1] = { 36, 66, 65, 95 },	[2] = { 66, 66, 95, 95 } },
	[worldMapNodeType.gate]			= { [0] = { 6, 96, 35, 125 },	[1] = { 36, 96, 65, 125 },	[2] = { 66, 96, 95, 125 } },
	[worldMapNodeType.trade]		= { [0] = { 6, 126, 35, 155 },	[1] = { 36, 126, 65, 155 },	[2] = { 66, 126, 95, 155 } },
	[worldMapNodeType.dangerous]	= { [0] = { 6, 156, 35, 185 },	[1] = { 36, 156, 65, 185 },	[2] = { 66, 156, 95, 185 } },
}

local worldMapNodeType_String = {
	[worldMapNodeType.normal]		= PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_NORMAL"),	-- "거점",
	[worldMapNodeType.viliage]		= PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_VILIAGE"),	-- "마을",
	[worldMapNodeType.city]			= PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_CITY"),		-- "도시",
	[worldMapNodeType.gate]			= PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_GATE"),		-- "관문",
	[worldMapNodeType.trade]		= PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_TRADE"),	-- "무역",
	[worldMapNodeType.dangerous]	= PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_DANGEROUS"),-- "위험 지역",
	-- [worldMapNodeType.farm]			= "농장",
	-- [worldMapNodeType.collect]		= "채집장",
	-- [worldMapNodeType.quarry]		= "채석장",
	-- [worldMapNodeType.logging]		= "벌목장",
	-- [worldMapNodeType.finance]		= "금괴 거래소",
	-- [worldMapNodeType.fishTrap]		= "통발",
	-- [worldMapNodeType.minorFinance]	= "마이너 자산 관리소",
	-- [worldMapNodeType.monopolyFarm]	= "직영농장",
	-- [worldMapNodeType.note]			= "메모",
}

local worldmapGrand_SearchType = {
	nodeName	= 0,
	itemName	= 1,
	nodeType	= 2,
	UseType		= 3,
}

local WORLDMAP_RENDERTYPE	= CppEnums.WorldMapState
local _isGuildWarMode		= false;
local _currentRenderMode	= WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT


--function FromClient_WorldMapOpen()
--end

local MakeModeButton = function()			-- 우상단 모드 라디오 생성
	local radioControl = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON
	worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT] 			= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Explore" );
	worldMapState[eWorldmapState.eWMS_REGION]					= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Region" );
	worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER]		= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Water" );
	worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]	= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Celcius" );
	worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]	= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Humidity" );
	worldMapState[eWorldmapState.eWMS_GUILD_WAR]				= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Guildwar" );
	worldMapState[eWorldmapState.eWMS_SIMPLE]					= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Simple" );
	-- worldMapState[eWorldmapState.eWMS_QUEST]					= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Quest" );
	-- worldMapState[eWorldmapState.eWMS_TRADE]					= UI.createControl(radioControl, Panel_WorldMap_Main, "Mode_Button_Trade" );

	for modeIndex,value in pairs(worldMapState) do
		CopyBaseProperty( worldmapGrand.template.templateButton ,worldMapState[modeIndex] )
		worldMapState[modeIndex]:addInputEvent( "Mouse_LUp", 	"WorldMapStateChange(" .. modeIndex ..")" )
		worldMapState[modeIndex]:addInputEvent( "Mouse_On",		"WorldMapStateChange_SimpleTooltips(true," .. modeIndex ..")")
		worldMapState[modeIndex]:addInputEvent( "Mouse_Out",	"WorldMapStateChange_SimpleTooltips( false )")
		worldMapState[modeIndex]:setTooltipEventRegistFunc( "WorldMapStateChange_SimpleTooltips(true," .. modeIndex .. ")" )
		worldMapState[modeIndex]:SetShow(true)
		worldMapState[modeIndex]:SetEnable(true)
		worldMapState[modeIndex]:SetGroup(0)

		changeModeTexture( modeIndex )
	end
end

local MakeModeChekcState = function()		-- 우상단 모드 필터 생성
	worldMapCheckState[eCheckState.eCheck_Quest] 		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Panel_WorldMap_Main, "CheckButton_Quest" )
	worldMapCheckState[eCheckState.eCheck_Knowledge] 	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Panel_WorldMap_Main, "CheckButton_Knowledge" )
	worldMapCheckState[eCheckState.eCheck_FishnChip] 	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Panel_WorldMap_Main, "CheckButton_Fishnchip")
	worldMapCheckState[eCheckState.eCheck_Node] 		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Panel_WorldMap_Main, "CheckButton_Node")
	worldMapCheckState[eCheckState.eCheck_Trade] 		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Panel_WorldMap_Main, "CheckButton_Trade")
	worldMapCheckState[eCheckState.eCheck_Way] 			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Panel_WorldMap_Main, "CheckButton_WayGuide")
	worldMapCheckState[eCheckState.eCheck_Postions] 	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Panel_WorldMap_Main, "CheckButton_Positions")
	worldMapCheckState[eCheckState.eCheck_Wagon] 		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Panel_WorldMap_Main, "CheckButton_Carriage" )
	
	for checkIndex,value in pairs(worldMapCheckState) do
		CopyBaseProperty( worldmapGrand.template.templateCheck ,worldMapCheckState[checkIndex] )
		worldMapCheckState[checkIndex]:addInputEvent( "Mouse_LUp", "WorldMapCheckListChange(" .. checkIndex ..")")
		worldMapCheckState[checkIndex]:addInputEvent( "Mouse_On", "WorldMapCheckListToolTips( true," .. checkIndex ..")")
		worldMapCheckState[checkIndex]:addInputEvent( "Mouse_Out", "WorldMapCheckListToolTips( false )")
		worldMapCheckState[checkIndex]:SetShow(true)
		worldMapCheckState[checkIndex]:SetEnable(true)

		changeModeFilterTexture( checkIndex )
	end
end

local changeNodeTexture = function( nodeType )		-- 노드 텍스쳐 변경
	local control	= worldMapNodeListType[nodeType]
	local posArray	= nodeTexture[nodeType]

	control:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/WorldMap/WorldMap_Etc_05.dds" )

	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[0][1], posArray[0][2], posArray[0][3], posArray[0][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[1][1], posArray[1][2], posArray[1][3], posArray[1][4] )
	control:getOnTexture():setUV(  x1, y1, x2, y2  )
	local x1, y1, x2, y2 = setTextureUV_Func( control, posArray[2][1], posArray[2][2], posArray[2][3], posArray[2][4] )
	control:getClickTexture():setUV(  x1, y1, x2, y2  )

	control:setRenderTexture(control:getBaseTexture())
end

local MakeNodeListType	= function()		-- 좌상단 노드 필터 생성
	worldMapNodeListType[worldMapNodeType.normal]		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Normal" )
	worldMapNodeListType[worldMapNodeType.viliage]		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Viliage" )
	worldMapNodeListType[worldMapNodeType.city]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_City" )
	worldMapNodeListType[worldMapNodeType.gate]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Gate" )
	-- worldMapNodeListType[worldMapNodeType.farm]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Farm" )
	worldMapNodeListType[worldMapNodeType.trade]		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Trade" )
	-- worldMapNodeListType[worldMapNodeType.collect]		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Collect" )
	-- worldMapNodeListType[worldMapNodeType.quarry]		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Quarry" )
	-- worldMapNodeListType[worldMapNodeType.logging]		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Logging" )
	worldMapNodeListType[worldMapNodeType.dangerous]	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Dangerous" )
	-- worldMapNodeListType[worldMapNodeType.finance]		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Finance" )
	-- worldMapNodeListType[worldMapNodeType.fishTrap]		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_FishTrap" )
	-- worldMapNodeListType[worldMapNodeType.minorFinance]	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_MinorFinance" )
	-- worldMapNodeListType[worldMapNodeType.monopolyFarm]	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_MonopolyFarm" )
	-- worldMapNodeListType[worldMapNodeType.note]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Note" )

	for checkIndex,value in pairs(worldMapNodeListType) do
		CopyBaseProperty( worldmapGrand.template.templateRadio ,worldMapNodeListType[checkIndex] )
		worldMapNodeListType[checkIndex]:addInputEvent( "Mouse_LUp",	"HandleClicked_GrandWorldMap_SearchNodeType(" .. checkIndex ..")")
		worldMapNodeListType[checkIndex]:addInputEvent( "Mouse_On",		"worldmapGrand_nodeTypeTooltip( true," .. checkIndex ..")")
		worldMapNodeListType[checkIndex]:addInputEvent( "Mouse_Out",	"worldmapGrand_nodeTypeTooltip( false )")
		worldMapNodeListType[checkIndex]:setTooltipEventRegistFunc( "worldmapGrand_nodeTypeTooltip( true," .. checkIndex ..")" )
		-- worldMapNodeListType[checkIndex]:SetText( checkIndex + 1 )
		worldMapNodeListType[checkIndex]:SetShow(true)
		worldMapNodeListType[checkIndex]:SetEnable(true)
	end
end

local nodeControl_SetTexture = function()	-- 노드타입 텍스쳐 변경
	for checkIndex = 0, nodeListCount -1 do	-- 카운트가 늘어나면 변수 값 수정 필요.
		local value = nodeList[checkIndex]
		changeNodeTexture(value)
	end
end

local MakeSearchResultPool = function()		-- 검색 결과 리스트 생성
	for idx = 0, worldmapGrand.config.searchingResultMaxCount -1 do
		worldmapGrand.searchResultUiPool[idx] = UI.createAndCopyBasePropertyControl( Panel_WorldMap_Main, "List_itemName",	worldmapGrand.ui.list_SearchBG,	"WorldmapGrand_SearchResultList_" .. idx )
		worldmapGrand.searchResultUiPool[idx]:SetPosX( 4 )
		worldmapGrand.searchResultUiPool[idx]:SetPosY( 5 + ((worldmapGrand.searchResultUiPool[idx]:GetSizeY()+3) * idx) )
		worldmapGrand.searchResultUiPool[idx]:SetText( "" )
		worldmapGrand.searchResultUiPool[idx]:SetShow( false )
	end
end

local AlignButtonPosition = function()		-- 각 버튼 위치 지정
	local offsetX =	worldmapGrand.ui.ModeBG:GetPosX() + 5
	local offsetY = worldmapGrand.ui.ModeBG:GetPosY()

	-- 모드 관련 정렬
	for modeIndex,value in pairs(worldMapState) do
		worldMapState[modeIndex]:SetPosX( offsetX + ( (worldMapState[modeIndex]:GetSizeX() + 2 ) * (modeIndex - 1)) );
		worldMapState[modeIndex]:SetPosY( offsetY + 5 );
	end
	
	-- 필터 관련 정렬
	for checkIndex,value in pairs(worldMapCheckState) do
		worldMapCheckState[checkIndex]:SetPosX( offsetX + ( (worldMapCheckState[checkIndex]:GetSizeX() + 2 ) * (checkIndex)) );
		worldMapCheckState[checkIndex]:SetPosY( 45 );
	end	

	-- 타입 관련 정렬
	local colsCount	= 6
	local xGap		= 8
	local yGap		= 45
	for checkIndex = 0, nodeListCount -1 do	-- 카운트가 늘어나면 변수 값 수정 필요.
		local value = nodeList[checkIndex]
		worldMapNodeListType[value]:SetPosX( xGap + ( (checkIndex % colsCount) * worldMapNodeListType[value]:GetSizeX() ) )
		worldMapNodeListType[value]:SetPosY( yGap + ( worldMapNodeListType[value]:GetSizeY() * ( math.floor(checkIndex/colsCount) ) ) )
	end

	-- 타입 하단 위치 및 크기 조절
	local uiControl = worldmapGrand.ui
	local seachBoxStartPosY = worldMapNodeListType[nodeList[nodeListCount -1]]:GetPosY() + worldMapNodeListType[nodeList[nodeListCount -1]]:GetSizeY() + 15
	uiControl.edit_NodeName				:SetPosY( seachBoxStartPosY )
	uiControl.btn_SearchNodeName		:SetPosY( seachBoxStartPosY )
	uiControl.edit_ItemName				:SetPosY( uiControl.edit_NodeName:GetPosY() + uiControl.edit_NodeName:GetSizeY() + 3 )
	uiControl.btn_SearchItemName		:SetPosY( uiControl.edit_NodeName:GetPosY() + uiControl.edit_NodeName:GetSizeY() + 3 )
	uiControl.edit_UseType				:SetPosY( uiControl.edit_ItemName:GetPosY() + uiControl.edit_ItemName:GetSizeY() + 3 )
	uiControl.btn_SearchUseType			:SetPosY( uiControl.edit_ItemName:GetPosY() + uiControl.edit_ItemName:GetSizeY() + 3 )
	uiControl.searchPartLine			:SetPosY( uiControl.edit_UseType:GetPosY() + uiControl.edit_UseType:GetSizeY() + 3 )
	uiControl.explorePointBG			:SetPosY( uiControl.searchPartLine:GetPosY() + uiControl.searchPartLine:GetSizeY() + 3 )
	uiControl.explorePointIcon			:SetPosY( uiControl.explorePointBG:GetPosY() + 8 )
	uiControl.explorePointValue			:SetPosY( uiControl.explorePointBG:GetPosY() + 8 )
	uiControl.explorePointProgressBG	:SetPosY( uiControl.explorePointBG:GetPosY() + 14 )
	uiControl.explorePointProgress		:SetPosY( uiControl.explorePointBG:GetPosY() + 15 )
	uiControl.explorePointHelp			:SetPosY( uiControl.explorePointBG:GetPosY() + 8 )
	uiControl.MainMenuBG				:SetSize( uiControl.MainMenuBG:GetSizeX(), uiControl.explorePointBG:GetPosY() + uiControl.explorePointBG:GetSizeY() )
end

local worldmapGrand_OpenSet = function()	-- 에디트 박스 기본 세팅
	local uiControl = worldmapGrand.ui
	uiControl.edit_NodeName	:SetEditText( worldmapGrand.config.searchDefaultNodeName, true )
	uiControl.edit_ItemName	:SetEditText( worldmapGrand.config.searchDefaultItemName, true )
	uiControl.edit_UseType	:SetEditText( worldmapGrand.config.searchDefaultUseType, true )
end

local ResetGuildMode = function()			-- 길드 모드 초기화
	_isGuildWarMode = false;
	ToClient_SetGuildMode( _isGuildWarMode )
	handleGuildModeChange( _isGuildWarMode )
end

local CheckStateByChangeMode = function()	-- 필터 체크
	for checkIndex,value in pairs(worldMapCheckStateInMode[_currentRenderMode]) do
		worldMapCheckState[checkIndex]:SetCheck(value);
		ToClient_WorldmapCheckState(checkIndex, value);
	end
end

function worldmapGrand:UpdateList()
	if worldmapGrand_SearchType.nodeName == self.config.searchType then		-- 노드 이름검색
		self.ui.list_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_NODE") )	-- "거점 목록"
		self.ui.list_KeyWord:SetText( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHKEYWORD", "keyword", self.ui.edit_NodeName:GetEditText(), "count", self.config.searchingResultCount ) )	-- 검색어 : {keyword}({count}개)
	elseif worldmapGrand_SearchType.nodeType == self.config.searchType then	-- 노트 타입
		self.ui.list_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_NODE") )	-- "거점 목록"
		self.ui.list_KeyWord:SetText( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPEKEYWORD", "keyword", worldMapNodeType_String[self.config.selectNodeType], "count", self.config.searchingResultCount ) )	-- {keyword} : {count}개
	elseif worldmapGrand_SearchType.itemName == self.config.searchType then	-- 아이템명 검색
		self.ui.list_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_HOUSE") )
		self.ui.list_KeyWord:SetText( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHKEYWORD", "keyword", self.ui.edit_ItemName:GetEditText(), "count", self.config.searchingResultCount ) )	-- 검색어 : {keyword}({count}개)
	else	-- 용도명 검색
		self.ui.list_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_USETYPE") )	-- "용도 목록"
		self.ui.list_KeyWord:SetText( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHKEYWORD", "keyword", self.ui.edit_UseType:GetEditText(), "count", self.config.searchingResultCount ) )
	end

	for idx = 0, self.config.searchingResultMaxCount -1 do
		self.searchResultUiPool[idx]:SetText( "" )
		self.searchResultUiPool[idx]:SetShow( false )
		self.searchResultUiPool[idx]:addInputEvent( "Mouse_LUp", "" )
	end

	local resultUiCount = 0
	for resultIdx = self.config.scrollStartIdx, self.config.searchingResultCount -1 do
		if self.config.searchingResultMaxCount <= resultUiCount then
			break
		end

		local resultString	= ""
		if worldmapGrand_SearchType.nodeName == self.config.searchType then		-- 거점 이름 검색
			resultString	= ToClient_getFindResultNameByIndex( resultIdx )
		elseif worldmapGrand_SearchType.nodeType == self.config.searchType then	-- 거점 타입 검색
			resultString	= ToClient_getFindResultNameByIndex( resultIdx )
		elseif worldmapGrand_SearchType.itemName == self.config.searchType then	-- 아이템명 검색
			local HouseInfoStaticStatusWrapper	= ToClient_getHouseInfoWrapperByIndex( resultIdx )
			resultString	= HouseInfoStaticStatusWrapper:getName()
		else
			local HouseInfoStaticStatusWrapper	= ToClient_getHouseInfoWrapperByHouseUseTypeNameIndex( resultIdx )
			resultString	= HouseInfoStaticStatusWrapper:getName()
		end
		
		local slot			= self.searchResultUiPool[resultUiCount]
		slot:addInputEvent( "Mouse_LUp", 			"HandleClicked_GrandWorldMap_GotoNodeFocus( " .. resultIdx .. " )" )
		slot:addInputEvent( "Mouse_UpScroll", 		"GrandWorldMap_Scroll( true )")
		slot:addInputEvent( "Mouse_DownScroll", 	"GrandWorldMap_Scroll( false )")
		slot:SetText( resultString )
		slot:SetShow( true )

		resultUiCount = resultUiCount + 1
	end

	UIScroll.SetButtonSize( self.ui.list_scroll, self.config.searchingResultMaxCount, self.config.searchingResultCount)
end

function worldmapGrand:UpdateExplorePoint()			-- 공헌도 업데이트
	local territoryKeyRaw 	= getDefaultTerritoryKey()
	local explorePoint		= getExplorePointByTerritoryRaw( territoryKeyRaw )
	local cont_expRate		= Int64toInt32(explorePoint:getExperience_s64()) / Int64toInt32(getRequireExplorationExperience_s64()) 

	self.ui.explorePointValue		:SetText( tostring(explorePoint:getRemainedPoint()) .." / " .. tostring(explorePoint:getAquiredPoint()) )
	self.ui.explorePointProgress	:SetProgressRate( cont_expRate * 100 )
end

function FGlobal_WorldMapOpenForMain()
	AlignButtonPosition()
	worldmapGrand_OpenSet()

	Panel_WorldMap_Main:SetShow(true,false)

	for index, checkArray in pairs(worldMapCheckStateInMode) do		-- 필터 기본 값 세팅.
		for checkIndex,value in pairs(worldMapCheckState) do
			if index == eWorldmapState.eWMS_EXPLORE_PLANT or index == eWorldmapState.eWMS_SIMPLE then
				checkArray[checkIndex] = true
			elseif index == eWorldmapState.eWMS_GUILD_WAR then
				if (checkIndex == eCheckState.eCheck_Knowledge) or (checkIndex == eCheckState.eCheck_FishnChip) or (checkIndex == eCheckState.eCheck_Trade) or (checkIndex == eCheckState.eCheck_Node) then
					checkArray[checkIndex] = true
				else
					checkArray[checkIndex] = false
				end
			else
				checkArray[checkIndex] = false
			end
		end
	end

	for checkIndex,value in pairs(worldMapCheckState) do
		worldMapCheckState[checkIndex]:SetCheck( ToClient_isWorldmapCheckState(checkIndex) )
		worldMapCheckStateInMode[_currentRenderMode][checkIndex] = worldMapCheckState[checkIndex]:IsCheck()
	end

	for	idx, value in pairs( worldMapNodeListType ) do	-- 필터 초기화
		worldMapNodeListType[idx]:SetCheck( false )
	end

	-- { 기본 선택 필터
		local defaultSelectFilter = worldMapNodeType.city
		HandleClicked_GrandWorldMap_SearchNodeType( defaultSelectFilter )
		worldMapNodeListType[defaultSelectFilter]:SetCheck( true )
	-- }

	CheckStateByChangeMode();
	worldMapState[_currentRenderMode]:SetCheck(true);	-- 라디오 버튼

	worldmapGrand:UpdateExplorePoint() 					-- 공헌도 업데이트
	FGlobal_WorldmapGrand_Bottom_MenuSet()				-- 하단 메뉴 활성화 처리

	worldmapGrand.ui.list_scroll				:SetControlPos(0)
	worldmapGrand.config.scrollStartIdx			= 0
end

function FGlobal_WorldmapGrand_Main_UpdateExplorePoint()
	worldmapGrand:UpdateExplorePoint()
end


function FGlobal_resetGuildWarMode()
	_isGuildWarMode = false;
end

function FGlobal_isGuildWarMode()
	return _isGuildWarMode;
end

function WorldMapStateChange( state )
	_currentRenderMode = state;
	local renderState = state;
	if( WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT == state ) then
		ResetGuildMode()
	elseif( WORLDMAP_RENDERTYPE.eWMS_GUILD_WAR == state ) then
		renderState = WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT

		_isGuildWarMode = true;
		ToClient_SetGuildMode( _isGuildWarMode )
		handleGuildModeChange( _isGuildWarMode )
	elseif( WORLDMAP_RENDERTYPE.eWMS_SIMPLE == state ) then
		renderState = WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT
		ResetGuildMode()
	elseif( WORLDMAP_RENDERTYPE.eWMS_QUEST == state ) then
		renderState = WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT
		ResetGuildMode()
	elseif( WORLDMAP_RENDERTYPE.eWMS_TRADE == state ) then
		renderState = WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT
		ResetGuildMode()
	end
	ToClient_WorldmapStateChange( renderState )
	CheckStateByChangeMode()
end

function WorldMapCheckListChange( checkState )
	ToClient_WorldmapCheckState(checkState, worldMapCheckState[checkState]:IsCheck() )
	worldMapCheckStateInMode[_currentRenderMode][checkState] = worldMapCheckState[checkState]:IsCheck();
end


--[[
	@Date		2015/04/24
	@Author		who1310
	@Breif		길드 모드 변경 될 시에, 렌더 상태 변경
]]--
function handleGuildModeChange( isGuildMode )
	ToClient_reloadNodeLine(isGuildMode, WaypointKeyUndefined)
end

--[[
	@Date		2015/04/16
	@Author		goni
	@Breif		월드맵의 상태 변경 버튼 툴팁
]]--

function WorldMapStateChange_SimpleTooltips( isShow, tipType )
	local name, desc, control = nil, nil, nil

	if eWorldmapState.eWMS_EXPLORE_PLANT == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_PLANT_NAME") -- "일반 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_PLANT_DESC") -- "탐험한 지역과 거점 및 의뢰 그리고 지식 정보가 표시됩니다."
		control = worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT]
	elseif eWorldmapState.eWMS_REGION == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_REGION_NAME") -- "영지 자원 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_REGION_DESC") -- "영지 지역별 자원 및 민심의 정보가 막대로 표시됩니다."
		control = worldMapState[eWorldmapState.eWMS_REGION]
	elseif eWorldmapState.eWMS_LOCATION_INFO_WATER == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WATER_NAME") -- "지하수 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WATER_DESC") -- "땅 밑에 매장되어 있는 지하수량의 범위를 표시합니다."
		control = worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER]
	elseif eWorldmapState.eWMS_LOCATION_INFO_CELCIUS == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CELCIUS_NAME") -- 온도 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CELCIUS_DESC") -- 각 지역의 온도차를 범위화하여 표시합니다."
		control = worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS]
	elseif eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_HUMIDITY_NAME") -- "습도 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_HUMIDITY_DESC") -- "각 지역의 습도량을 범위화하여 표시합니다."
		control = worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY]
	elseif eWorldmapState.eWMS_GUILD_WAR == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_GUILDWAR_NAME") -- "거점전 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_GUILDWAR_DESC") -- "거점전 가능한 지역의 거점 점령 현황을 표시합니다."
		control = worldMapState[eWorldmapState.eWMS_GUILD_WAR]
	elseif eWorldmapState.eWMS_SIMPLE == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_USERFILTER")				-- "사용자 지정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_USERFILTER_DESC")			-- "필요한 필터를 지정하여 이용할 수 있습니다."
		control = worldMapState[eWorldmapState.eWMS_SIMPLE]
	else
		control = nil;
	end

	if isShow == true and nil ~= control then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function WorldMapCheckListToolTips( isShow, checkType )
	if checkType == eCheckState.eCheck_Quest then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_QUEST_NAME") -- "의뢰"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_QUEST_DESC") -- "월드맵에서의 의뢰 지역 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckState[eCheckState.eCheck_Quest]
	elseif checkType == eCheckState.eCheck_Knowledge then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_KNOWLEDGE_NAME") -- "지식"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_KNOWLEDGE_DESC") -- "월드맵에서의 지식, NPC 위치를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckState[eCheckState.eCheck_Knowledge]
	elseif checkType == eCheckState.eCheck_FishnChip then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_FISH_NAME") -- "낚시/채집 지식"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_FISH_DESC") -- "월드맵에서의 낚시/채집 지식 위치를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckState[eCheckState.eCheck_FishnChip]
	elseif checkType == eCheckState.eCheck_Node then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_NODE_NAME") -- "거점"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_NODE_DESC") -- "월드맵에서의 거점 연결 지역 위치를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckState[eCheckState.eCheck_Node]
	elseif checkType == eCheckState.eCheck_Trade then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_TRADE_NAME") -- "무역"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_TRADE_DESC") -- "월드맵에서의 무역 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckState[eCheckState.eCheck_Trade]
	elseif checkType == eCheckState.eCheck_Way then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_DIRECTION_NAME") -- "방향 정보"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_DIRECTION_DESC") -- "월드맵에서의 방향 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckState[eCheckState.eCheck_Way]
	elseif checkType == eCheckState.eCheck_Postions then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WHERE_NAME") -- "위치 아이콘"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WHERE_DESC") -- "월드맵에서의 도적, 탑승물 등의 위치 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckState[eCheckState.eCheck_Postions]
	elseif checkType == eCheckState.eCheck_Wagon then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_PANEL_TOOLTIP_WAGON")		-- "운송 수단"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_PANEL_TOOLTIP_WAGON_DESC")	-- "월드맵의 마차, 배 등 운송 수단 위치 정보를 켜고 끌 수 있습니다."
		uiControl = worldMapCheckState[eCheckState.eCheck_Wagon]
	end

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function worldmapGrand_nodeTypeTooltip( isShow, typeIdx )
	local uiControl = worldMapNodeListType[typeIdx]
	local name		= worldMapNodeType_String[typeIdx]
	local desc		= nil

	if true == isShow then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function HandleClicked_GrandWorldMap_SearchNode()
	worldmapGrand.ui.edit_ItemName	:SetEditText( worldmapGrand.config.searchDefaultItemName, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_UseType	:SetEditText( worldmapGrand.config.searchDefaultUseType, true )	-- 반대쪽 초기화

	local searchString = worldmapGrand.ui.edit_NodeName:GetEditText()
	worldmapGrand.config.searchType	= worldmapGrand_SearchType.nodeName
	ClearFocusEdit()
	-- 월드맵 모드로 변경
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	SetUIMode( Defines.UIMode.eUIMode_WorldMap )

	worldmapGrand.config.searchingResultCount = ToClient_FindNodeByName( tostring(searchString) )
	worldmapGrand.ui.list_scroll				:SetControlPos(0)
	worldmapGrand.config.scrollStartIdx			= 0

	worldmapGrand:UpdateList()
end

function HandleClicked_GrandWorldMap_SearchItem()
	worldmapGrand.ui.edit_NodeName	:SetEditText( worldmapGrand.config.searchDefaultNodeName, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_UseType	:SetEditText( worldmapGrand.config.searchDefaultUseType	, true )	-- 반대쪽 초기화

	local searchString = worldmapGrand.ui.edit_ItemName:GetEditText()
	worldmapGrand.config.searchType	= worldmapGrand_SearchType.itemName
	ClearFocusEdit()
	-- 월드맵 모드로 변경
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	SetUIMode( Defines.UIMode.eUIMode_WorldMap )

	worldmapGrand.config.searchingResultCount = ToCleint_findHouseByItemName( tostring(searchString) )
	worldmapGrand.ui.list_scroll				:SetControlPos(0)
	worldmapGrand.config.scrollStartIdx			= 0
	
	worldmapGrand:UpdateList()
end

function HandleClicked_GrandWorldMap_SearchUseType()
	worldmapGrand.ui.edit_ItemName	:SetEditText( worldmapGrand.config.searchDefaultItemName, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_NodeName	:SetEditText( worldmapGrand.config.searchDefaultNodeName, true )	-- 반대쪽 초기화

	local searchString = worldmapGrand.ui.edit_UseType:GetEditText()
	worldmapGrand.config.searchType	= worldmapGrand_SearchType.UseType
	ClearFocusEdit()
	-- 월드맵 모드로 변경
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	SetUIMode( Defines.UIMode.eUIMode_WorldMap )

	worldmapGrand.config.searchingResultCount = ToClient_findHouseByHouseUseTypeName( tostring(searchString) )	-- 용도변경으로 바꿔야 함.
	worldmapGrand.ui.list_scroll				:SetControlPos(0)
	worldmapGrand.config.scrollStartIdx			= 0
	
	worldmapGrand:UpdateList()
end

function HandleClicked_GrandWorldMap_SearchNode_ResetString()
	worldmapGrand.ui.edit_ItemName	:SetEditText( worldmapGrand.config.searchDefaultItemName, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_UseType	:SetEditText( worldmapGrand.config.searchDefaultUseType	, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_NodeName	:SetEditText( "", true )
	
	-- 인풋모드로 변경
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)	-- 방식 확인을 해야 한다.
	SetUIMode( Defines.UIMode.eUIMode_WoldMapSearch )
end

function HandleClicked_GrandWorldMap_SearchItem_ResetString()
	worldmapGrand.ui.edit_NodeName	:SetEditText( worldmapGrand.config.searchDefaultNodeName, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_UseType	:SetEditText( worldmapGrand.config.searchDefaultUseType	, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_ItemName	:SetEditText( "", true )

	-- 인풋모드로 변경
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)	-- 방식 확인을 해야 한다.
	SetUIMode( Defines.UIMode.eUIMode_WoldMapSearch )
end

function HandleClicked_GrandWorldMap_SearchUseType_ResetString()
	worldmapGrand.ui.edit_NodeName	:SetEditText( worldmapGrand.config.searchDefaultNodeName, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_ItemName	:SetEditText( worldmapGrand.config.searchDefaultItemName, true )	-- 반대쪽 초기화
	worldmapGrand.ui.edit_UseType	:SetEditText( "", true )

	-- 인풋모드로 변경
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)	-- 방식 확인을 해야 한다.
	SetUIMode( Defines.UIMode.eUIMode_WoldMapSearch )
end

function HandleClicked_GrandWorldMap_SearchNodeType( typeIndex )
	if worldMapNodeType.note == typeIndex then
		-- Proc_ShowMessage_Ack("노트는 하지 않는다.")
		return
	end

	worldmapGrand.ui.edit_NodeName	:SetEditText( worldmapGrand.config.searchDefaultNodeName, true )
	worldmapGrand.ui.edit_ItemName	:SetEditText( worldmapGrand.config.searchDefaultItemName, true )
	worldmapGrand.ui.edit_UseType	:SetEditText( worldmapGrand.config.searchDefaultUseType	, true )	-- 반대쪽 초기화

	worldmapGrand.config.searchType				= worldmapGrand_SearchType.nodeType
	worldmapGrand.config.selectNodeType			= typeIndex
	worldmapGrand.config.searchingResultCount	= ToClient_FindNodeByType( typeIndex )

	worldmapGrand.ui.list_scroll				:SetControlPos(0)
	worldmapGrand.config.scrollStartIdx			= 0

	worldmapGrand:UpdateList()
end

function HandleClicked_GrandWorldMap_GotoNodeFocus( resultIdx )
	if worldmapGrand_SearchType.nodeName == worldmapGrand.config.searchType or worldmapGrand_SearchType.nodeType == worldmapGrand.config.searchType then	-- 노드 이름검색
		ToCleint_gotoFindTown( resultIdx ) -- 누르면 그리 이동함.		-- 월드맵 포커스를 이동 시킴
	elseif worldmapGrand_SearchType.itemName == worldmapGrand.config.searchType then	-- 아이템명 검색
		ToClient_gotoHouseNode( resultIdx ) -- 누르면 그리 이동함.	-- 월드맵 포커스를 이동 시킴
	else	-- 용도명 검색
		ToClient_gotoHouseNodeHouseUseType( resultIdx )
	end
end

function GrandWorldMap_Scroll( isUp )
	worldmapGrand.config.scrollStartIdx = UIScroll.ScrollEvent( worldmapGrand.ui.list_scroll, isUp, worldmapGrand.config.searchingResultMaxCount, worldmapGrand.config.searchingResultCount, worldmapGrand.config.scrollStartIdx, 1 )
	worldmapGrand:UpdateList()
end

function HandleClicked_GrandWorldMap_ScrollPress()								-- 스크롤 버튼을 누른채 움직인다. 스크롤을 누른다.
	local config			= worldmapGrand.config
	local scrollPos			= worldmapGrand.ui.list_scroll:GetControlPos()			-- 스크롤 위치를 구하고
	local resultCount		= config.searchingResultCount							-- 검색 결과 수
	local maxViewCount		= config.searchingResultMaxCount						-- 화면 최대 수(맨 아래일 때 처리를 위해)
	config.scrollStartIdx 	= math.ceil(( resultCount - maxViewCount ) * scrollPos)	-- 현재 인덱스를 적용.
	worldmapGrand:UpdateList()																
end

function HandleOnout_GrandWorldMap_explorePointHelp( isShow )
	local control = worldmapGrand.ui.explorePointHelp
	if isShow then
		local name = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_EXPLORERPOINT" )	-- "보유 공헌도"
		local desc = nil
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function FGlobal_GrandWorldMap_SearchToWorldMapMode()
	ClearFocusEdit()
	-- 월드맵 모드로 변경
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	SetUIMode( Defines.UIMode.eUIMode_WorldMap )
end

function worldmapGrand_OnScreenResize()
	Panel_WorldMap_Main:SetSize( getScreenSizeX(), getScreenSizeY() )
	worldmapGrand.ui.ModeBG:ComputePos()
end

function FromClient_RenderStateChange( state )
	for checkIndex,value in pairs(worldMapCheckState) do
		worldMapCheckState[checkIndex]:SetCheck( ToClient_isWorldmapCheckState(checkIndex) )
	end
end

function worldmapGrand:registEventHandler()
	local ui = self.ui
	ui.ListBG				:addInputEvent( "Mouse_UpScroll", 		"GrandWorldMap_Scroll( true )")
	ui.ListBG				:addInputEvent( "Mouse_DownScroll", 	"GrandWorldMap_Scroll( false )")

	ui.btn_SearchNodeName	:addInputEvent( "Mouse_LUp",	"HandleClicked_GrandWorldMap_SearchNode()" )
	ui.btn_SearchItemName	:addInputEvent( "Mouse_LUp",	"HandleClicked_GrandWorldMap_SearchItem()" )
	ui.btn_SearchUseType	:addInputEvent( "Mouse_LUp",	"HandleClicked_GrandWorldMap_SearchUseType()" )
	
	ui.edit_NodeName		:addInputEvent( "Mouse_LUp",	"HandleClicked_GrandWorldMap_SearchNode_ResetString()" )
	ui.edit_NodeName		:RegistReturnKeyEvent(			"HandleClicked_GrandWorldMap_SearchNode()" )
	ui.edit_ItemName		:addInputEvent( "Mouse_LUp",	"HandleClicked_GrandWorldMap_SearchItem_ResetString()" )
	ui.edit_ItemName		:RegistReturnKeyEvent(			"HandleClicked_GrandWorldMap_SearchItem()" )
	ui.edit_UseType			:addInputEvent( "Mouse_LUp",	"HandleClicked_GrandWorldMap_SearchUseType_ResetString()" )
	ui.edit_UseType			:RegistReturnKeyEvent(			"HandleClicked_GrandWorldMap_SearchUseType()" )

	ui.list_scrollBtn		:addInputEvent( "Mouse_LPress", "HandleClicked_GrandWorldMap_ScrollPress()" )
	ui.list_scroll			:addInputEvent( "Mouse_LUp",	"HandleClicked_GrandWorldMap_ScrollPress()" )

	ui.explorePointHelp		:addInputEvent( "Mouse_On", 	"HandleOnout_GrandWorldMap_explorePointHelp( true )")
	ui.explorePointHelp		:addInputEvent( "Mouse_Out", 	"HandleOnout_GrandWorldMap_explorePointHelp( false )")
	ui.explorePointHelp		:setTooltipEventRegistFunc(		"HandleOnout_GrandWorldMap_explorePointHelp( true )")
end


MakeModeButton();
MakeModeChekcState();
MakeSearchResultPool()
MakeNodeListType()
nodeControl_SetTexture()

worldmapGrand:registEventHandler()

registerEvent( "onScreenResize", "worldmapGrand_OnScreenResize" )
registerEvent("FromClient_RenderStateChange",			"FromClient_RenderStateChange")
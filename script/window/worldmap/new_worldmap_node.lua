local UI_TYPE		= CppEnums.PA_UI_CONTROL_TYPE
local ENT 			= CppEnums.ExplorationNodeType
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM 		= CppEnums.TextMode
local UI_PP 		= CppEnums.PAUIMB_PRIORITY
local UI_TT			= CppEnums.PAUI_TEXTURE_TYPE

--[[ Panel_Node 변수]]--
--Global 변수
-- WORLDMAP_NODE_POSITION 	= {
-- 	x = 0,
-- 	y = 0 
-- };

local nodeStaticStatus 	= nil
local _wayPointKey		= nil
local isProgressReset	= false

-- local nodeWarClicked = false

Panel_NodeName:RegisterShowEventFunc( true, "Panel_NodeName_ShowAni()" )
Panel_NodeName:RegisterShowEventFunc( false, "Panel_NodeName_HideAni()" )

-- 노드 정보창의 닫기 버튼
local closeButton			= UI.getChildControl ( Panel_NodeMenu, "Button_Close" )
local _buttonQuestion		= UI.getChildControl ( Panel_NodeMenu, "Button_Question" )	
closeButton:addInputEvent("Mouse_LUp", "FGlobal_CloseNodeMenu()" )
_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"NodeMenu\" )" )	-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"NodeMenu\", \"true\")" )	-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"NodeMenu\", \"false\")" )	-- 물음표 마우스아웃
local nodeInfoButton =
{
	Invest				= UI.getChildControl( Panel_NodeMenu, "nodeMenu_button_invest" ),		-- 노드 투자 버튼
	RequireItem			= UI.getChildControl( Panel_NodeMenu, "nodeMenu_requireItem" ),			-- "투자 조건" : 노드 투자 필요한 조건 표시 영역의 Title명
	Upgrade				= UI.getChildControl( Panel_NodeMenu, "button_nodeUpgrade" ),			-- 노드 업그레이드 버튼 (현재 사용 안함)
	ManageWorker		= UI.getChildControl( Panel_NodeMenu, "button_manageWorker" ),			-- 일꾼 관리 버튼 (현재 사용 안함)
	Transport			= UI.getChildControl( Panel_NodeMenu, "button_manageTransport" ),		-- 운송 버튼 (현재 사용 안함)
	Warehouse			= UI.getChildControl( Panel_NodeMenu, "button_warehouse" ),				-- 창고 보기 버튼 (현재 사용 안함)
	ManageProduct		= UI.getChildControl( Panel_NodeMenu, "button_manageProduct" ),			-- 작업 관리 버튼
	HouseManageProduct	= UI.getChildControl( Panel_NodeMenu, "button_manageHouseProduct" ),	-- 제작 관리 버튼 (현재 사용 안함??)
	Withdraw			= UI.getChildControl( Panel_NodeMenu, "nodeMenu_button_withdraw" ),		-- 투자 회수 버튼
	NearNode			= UI.getChildControl( Panel_NodeMenu, "nodeMenu_checknearNode" ),		-- 투자 회수 버튼
	-- ItemMarket			= UI.getChildControl( Panel_NodeMenu, "Button_ItemMarket" ),			-- 아이템 마켓 버튼
	
--	ManageRegionCorp	= UI.getChildControl( Panel_NodeMenu, "button_manageRegionCorp" ),		-- 영주 관리 생산 	(현재 사용 안함)
--	ManageRegionFishing	= UI.getChildControl( Panel_NodeMenu, "button_manageRegionFishing" ),	-- 영주 관리 물고기 (현재 사용 안함)
--	ManageRegionLoyalty	= UI.getChildControl( Panel_NodeMenu, "button_manageRegionLoyalty" ),	-- 영주 관리 충성도 (현재 사용 안함)
}

local nodeBg			= UI.getChildControl( Panel_NodeMenu, "Static_NodeBG" )
local nodeBg2			= UI.getChildControl( Panel_NodeMenu, "Static_NodeBG2" )
local nodeIcon_0		= UI.getChildControl( Panel_NodeMenu, "Static_NodeMenuIcon_0" )
local nodeIcon_1		= UI.getChildControl( Panel_NodeMenu, "Static_NodeMenuIcon_1" )
local nodeIcon_2		= UI.getChildControl( Panel_NodeMenu, "Static_NodeMenuIcon_2" )
local nodeIcon_3		= UI.getChildControl( Panel_NodeMenu, "Static_NodeMenuIcon_3" )
local contributeText	= UI.getChildControl( Panel_NodeMenu, "StaticText_ContributionPoint" )
local contributeIcon	= UI.getChildControl( Panel_NodeMenu, "Static_NodeMenuIcon_5" )
local template =
{
-- 노드 정보창의 투자 조건 정보의 Text 표시용 Control의 속성을 PreSet한 것 (이 Control의 속성만 Copy하여 필요에 따라 개별 Control을 생성한다.)
	NodeMenuRequireItem		= UI.getChildControl( Panel_NodeMenu, "nodeMenu_requireItemName" ),	
}

--{ 거점전 정보를 위한 창
	local nodeWar_PanelBG		= UI.getChildControl( Panel_NodeGuildWarMenu, "Static_NodeBG")
	local nodeWar_Ing			= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_NodeWar_Ing")
	local nodeWar_Count			= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_JoingNodeWar")
	local nodeWar_Free			= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_NodeWarFree")

	local nodeWarGuildMarkBg	= UI.getChildControl( Panel_NodeGuildWarMenu, "Static_GuildMarkBG")
	local nodeWarGuildMark		= UI.getChildControl( Panel_NodeGuildWarMenu, "Static_GuildMark")				-- 길드 마크
	local nodeWarGuildName		= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_GuildNameValue")		-- 길드 이름
	local nodeWarPeriod			= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_NodeWarPeriod")		-- 점령일
	local nodeWarPeriodValue	= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_NodeWarPeriodValue")		-- 점령일
	local nodeWarMasterName		= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_GuildMaster")
	local nodeWarGuildMaster	= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_GuildMasterValue")	-- 길드 마스터
	local nodeWarBenefits		= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_Benefits")
	local nodeWarGuildBenefis	= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_BenefitsValue")		-- 점유 길드 혜택

	local nodeWarBottomDesc		= UI.getChildControl( Panel_NodeGuildWarMenu, "StaticText_NodeWarDesc")
Panel_NodeGuildWarMenu:SetShow( false )
--}

-- 노드 레벨업을 위한 패널 정보
local nodeLv_Name			= UI.createAndCopyBasePropertyControl( Panel_NodeMenu, "nodeLv_Name", nodeBg2, "nodeBg2_nodeLv_Name" )
local nodeLv_NmLevel		= UI.createAndCopyBasePropertyControl( Panel_NodeMenu, "nodeLv_NmLevel", nodeBg2, "nodeBg2_nodeLv_NmLevel" )
local nodeLv_Level			= UI.createAndCopyBasePropertyControl( Panel_NodeMenu, "nodeLv_Level", nodeBg2, "nodeBg2_nodeLv_Level" )
local nodeLv_NmExp			= UI.createAndCopyBasePropertyControl( Panel_NodeMenu, "nodeLv_NmExp", nodeBg2, "nodeBg2_nodeLv_NmExp" )
local nodeLv_progressBG		= UI.createAndCopyBasePropertyControl( Panel_NodeMenu, "Static_NodeExp_BG", nodeBg2, "nodeBg2_NodeExp_BG" )
local nodeLv_progress		= UI.createAndCopyBasePropertyControl( Panel_NodeMenu, "Progress_NodeExp", nodeBg2, "nodeBg2_Progress_NodeExp" )
local nodeLv_NmLvEffect		= UI.createAndCopyBasePropertyControl( Panel_NodeMenu, "nodeLv_NmLvEffect", nodeBg2, "nodeBg2_nodeLv_NmLvEffect" )
local Button_NodeLvUp		= UI.createAndCopyBasePropertyControl( Panel_NodeMenu, "Button_NodeLvUp", nodeBg2, "nodeBg2_Button_NodeLvUp" )
Button_NodeLvUp:SetAutoDisableTime(0.3)

local nodeButtonTextSwitchCaseList = {
	[ENT.eExplorationNodeType_Normal] 		= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_EMPTY" ),			
	[ENT.eExplorationNodeType_Viliage]		= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_VILIAGE" ),		
	[ENT.eExplorationNodeType_City]			= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_CITY" ),			
	[ENT.eExplorationNodeType_Gate]			= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_GATE" ),			
	[ENT.eExplorationNodeType_Farm]			= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_FARM" ),			
	[ENT.eExplorationNodeType_Trade]	    = PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_FILTRATION" ),	
	[ENT.eExplorationNodeType_Collect]		= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_COLLECT" ),		
	[ENT.eExplorationNodeType_Quarry]		= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_QUARRY" ),		
	[ENT.eExplorationNodeType_Logging]		= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_LOGGING" ),		
	[ENT.eExplorationNodeType_Dangerous]	= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_DECOTREE" ),		
	[ENT.eExplorationNodeType_Finance]		= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_FINANCE" ),		
	[ENT.eExplorationNodeType_FishTrap]     = PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_FISHTRAP" ),		
	[ENT.eExplorationNodeType_MinorFinance]	= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_MINORFINANCE" ),
	[ENT.eExplorationNodeType_MonopolyFarm]	= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_MONOPOLYFARM" ),
}

local NodeMenu =
{
	-- 노드 정보창의 정보
	Type					= UI.getChildControl( Panel_NodeMenu, "nodeMenu_nodeType" ),
	Name					= UI.getChildControl( Panel_NodeMenu, "nodeMenu_nodeName" ),

	TypeGuild				= UI.getChildControl( Panel_NodeMenu, "StaticText_GuildName" ),
}
NodeMenu.Name:SetShow( false )

local nodeName				= UI.getChildControl( Panel_NodeName, "StaticText_NodeName" )
local L_Line				= UI.getChildControl( Panel_NodeName, "Static_L_Line" )
local R_Line				= UI.getChildControl( Panel_NodeName, "Static_R_Line" )
L_Line:SetIgnore( true )
R_Line:SetIgnore( true )

local NodeTextType = {
	NODE_DESCRIPTION			=	0,
	NODE_NATIONAL_TITLE			=	1,
	NODE_NATIONAL_TEXT			=	2,
	NODE_TERRITORY_TITLE		=	3,
	NODE_TERRITORY_TEXT			=	4,
	NODE_AFFILIATEDTOWN_TITLE	=	5,
	NODE_AFFILIATEDTOWN_TEXT	=	6,
	NODE_MANAGER_TITLE			=	7,
	NODE_MANAGER_TEXT			=	8,
	NODE_POINT_TEXT				=	9,
	NODE_SUPPORT_TEXT			=	10,
	NODE_MONEY_TEXT				=	11,
	NODE_ITEM1_TEXT				=	12,
	NODE_ITEM2_TEXT				=	13,
	NODE_ITEM3_TEXT				=	14,
	NODE_FINDMANGER_TEXT		=	15,
	NODE_UNUPGRADE_TEXT			=	16,
	NODE_UNWITHDRAW_TEXT		=	17,
	
	NODE_LAST					=	18,
}

local NodeTextColor = {
	[NodeTextType.NODE_DESCRIPTION]				= UI_color.C_FFFFFFFF,	
	[NodeTextType.NODE_NATIONAL_TITLE]			= UI_color.C_FFC4BEBE,
	[NodeTextType.NODE_NATIONAL_TEXT]			= UI_color.C_FFFAE696,
	[NodeTextType.NODE_TERRITORY_TITLE]			= UI_color.C_FFC4BEBE,
	[NodeTextType.NODE_TERRITORY_TEXT]			= UI_color.C_FFFAE696,
	[NodeTextType.NODE_AFFILIATEDTOWN_TITLE]	= UI_color.C_FFC4BEBE,
	[NodeTextType.NODE_AFFILIATEDTOWN_TEXT]		= UI_color.C_FFFAE696,
	[NodeTextType.NODE_MANAGER_TITLE]			= UI_color.C_FFC4BEBE,
	[NodeTextType.NODE_MANAGER_TEXT]			= UI_color.C_FF6DC6FF,
	[NodeTextType.NODE_POINT_TEXT]				= UI_color.C_FFFF7C67,
	[NodeTextType.NODE_SUPPORT_TEXT]			= UI_color.C_FFFF7C67,
	[NodeTextType.NODE_MONEY_TEXT]				= UI_color.C_FF67FFA4,
	[NodeTextType.NODE_ITEM1_TEXT]				= UI_color.C_FF67FFA4,
	[NodeTextType.NODE_ITEM2_TEXT]				= UI_color.C_FF67FFA4,
	[NodeTextType.NODE_ITEM3_TEXT]				= UI_color.C_FF67FFA4,
	[NodeTextType.NODE_FINDMANGER_TEXT]			= UI_color.C_FF6DC6FF,
	[NodeTextType.NODE_UNUPGRADE_TEXT]			= UI_color.C_FFFF4729,
	[NodeTextType.NODE_UNWITHDRAW_TEXT]			= UI_color.C_FF88DF00,
}

local NodeTextString = {	
	[NodeTextType.NODE_NATIONAL_TITLE]			= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_NATIONAL" ),
	[NodeTextType.NODE_TERRITORY_TITLE]			= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TERRITORY" ),	
	[NodeTextType.NODE_MANAGER_TITLE]			= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_MANAGER" ),
	[NodeTextType.NODE_AFFILIATEDTOWN_TITLE]	= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_AFFILIATEDTOWN" ),
	[NodeTextType.NODE_POINT_TEXT]				= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_CONTRIBUTIVENESS" ),
	[NodeTextType.NODE_MONEY_TEXT]				= PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_GOLD" ),
	[NodeTextType.NODE_FINDMANGER_TEXT]			= PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_FINDNODEMANAGER" ),
}

local NodeTextControl = {}			-- 노드 텍스트 버튼


function Panel_NodeName_ShowAni()
	nodeName:EraseAllEffect()
	-- nodeName:AddEffect ( "UI_ImperialLight", false, 0, 15 )
	-- nodeName:AddEffect ( "fUI_ImperialStart", false, 0, -10 )
	
	local FadeMaskAni = Panel_NodeName:addTextureUVAnimation (0.0, 1.28, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.6, 0 )
	FadeMaskAni:SetEndUV ( 0.0, 0.1, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.6, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.1, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 3 )

	Panel_NodeName:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = Panel_NodeName:addColorAnimation( 0.0, 0.50, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo8 = Panel_NodeName:addColorAnimation( 0.45, 1.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
	
end
function Panel_NodeName_HideAni()
end

--[[ Panel_Node 지역 함수 ]]--

--[[
	@date	2014/07/03
	@author	최대호
	@brief	주변 노드 확인 버튼을 누를 시 호출
]]--
function OnNearNodeClick( nodeKey )

	local param = NavigationGuideParam();
	param._isSetRenderPath = false;
	ToClient_WorldMapFindNearNode( nodeKey, param );

	audioPostEvent_SystemUi(00,14);
	
	FGlobal_WorldMapWindowEscape();
end

--[[
	@date	2014/07/03
	@author	최대호
	@brief	투자하기 버튼을 누를 시 호출
]]--
function OnNodeUpgradeClick( nodeKey )
	isProgressReset = true
	ToClient_WorldMapRequestUpgradeExplorationNode(nodeKey)
end

--[[
	@date	2014/07/03
	@author	최대호
	@brief	투자회수 버튼을 누를시 호출
]]--
function OnNodeWithdrawClick( nodeKey )
	local NodeWithdrawExecute = function()
		ToClient_WorldMapRequestWithdrawPlant(nodeKey)	-- 순차적으로 다음 이벤트가 호출된다.
	end

	if Panel_Plant_WorkManager:GetShow() then
		WorldMapPopupManager:popPanel()
	end

	local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_WORLDMAP_NODE_WITHDRAWCONFIRM")
	local messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = NodeWithdrawExecute, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData, "top")

	--WorldMapWindow_CloseAllSubPanel()
end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	선택한 노드의 날씨 상태를 문자열로 만든다
			문자열의 형태는 [구름량/강수량/기온] 의 형태로 만들어진다.
]]--
local function MakeNodeWeatherStatus(nodeKey)
	-- 구름 비율
	local fWeatherCloudRate	= getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CLOUD_RATE, nodeKey)	
	
	-- 강수량
	local fWeatherRainAmount = getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_RAIN_AMOUNT, nodeKey)
	
	-- 기온
	local fWeatherCelsius = getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CELSIUS, nodeKey)
	
	local strWeatherCloudRate		-- 구름 비율 문자열
	local strWeatherRainAmount		-- 강수량 문자열
	local strWeatherCelsius			-- 기온 문자열
	
	
	if( fWeatherCloudRate > 0.6 ) then
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_HIGH" );
	elseif( fWeatherCloudRate > 0.3 ) then
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_MID" );
	else
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_LOW" )
	end	
	
	if( fWeatherRainAmount > 0.6 ) then
		strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_HIGH" );
	elseif( fWeatherRainAmount > 0.3 ) then
		strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_MID" );
	else
		strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_LOW" )
	end
	
	if( fWeatherCelsius > 30.0 ) then
		strWeatherCelsius = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CELSIUS_HIGH" );
	elseif( fWeatherCelsius > 0 ) then
		strWeatherCelsius = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CELSIUS_MID" );
	else
		strWeatherCelsius = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CELSIUS_LOW" )
	end	
	
	return "[" .. strWeatherCloudRate .. "/" .. strWeatherRainAmount .. "/" .. strWeatherCelsius .. "]"	 
end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	소속된 마을의 경우 마을 정보를 채운다
]]--
local function FillAffiliatedTownInfo( nodeStaticStatus, nodeKey )
	
	-- 지역 타이틀	
	NodeTextControl[NodeTextType.NODE_NATIONAL_TITLE]:SetText( NodeTextString[NodeTextType.NODE_NATIONAL_TITLE] )
	NodeTextControl[NodeTextType.NODE_NATIONAL_TITLE]:SetFontColor( NodeTextColor[NodeTextType.NODE_NATIONAL_TITLE] )
	NodeTextControl[NodeTextType.NODE_NATIONAL_TITLE]:SetShow(true)
	
	--지역 텍스트	
	NodeTextControl[NodeTextType.NODE_NATIONAL_TEXT]:SetText( getNodeNationalName(nodeStaticStatus) )
	NodeTextControl[NodeTextType.NODE_NATIONAL_TEXT]:SetFontColor( NodeTextColor[NodeTextType.NODE_NATIONAL_TEXT] )
	NodeTextControl[NodeTextType.NODE_NATIONAL_TEXT]:SetShow(true)
	
	-- 영토 타이틀	
	NodeTextControl[NodeTextType.NODE_TERRITORY_TITLE]:SetText( NodeTextString[NodeTextType.NODE_TERRITORY_TITLE] )
	NodeTextControl[NodeTextType.NODE_TERRITORY_TITLE]:SetFontColor( NodeTextColor[NodeTextType.NODE_TERRITORY_TITLE] )
	NodeTextControl[NodeTextType.NODE_TERRITORY_TITLE]:SetShow(true)
	
	-- 영토 텍스트	
	NodeTextControl[NodeTextType.NODE_TERRITORY_TEXT]:SetText( getNodeTerritoryName(nodeStaticStatus) )
	NodeTextControl[NodeTextType.NODE_TERRITORY_TEXT]:SetFontColor( NodeTextColor[NodeTextType.NODE_TERRITORY_TEXT] )
	NodeTextControl[NodeTextType.NODE_TERRITORY_TEXT]:SetShow(true)
end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	메인 노드의 정보를 채운다
]]--
local function FillMainNodeInfo( nodeStaticStatus, nodeKey )
--[[
	-- 메인노드의 소속 타이틀
	_PA_LOG("최대호", "소속 : " ..NodeTextString[NodeTextType.NODE_AFFILIATEDTOWN_TITLE])
	NodeTextControl[NodeTextType.NODE_AFFILIATEDTOWN_TITLE]:SetText( NodeTextString[NodeTextType.NODE_AFFILIATEDTOWN_TITLE] )
	NodeTextControl[NodeTextType.NODE_AFFILIATEDTOWN_TITLE]:SetFontColor( NodeTextColor[NodeTextType.NODE_AFFILIATEDTOWN_TITLE] )
	NodeTextControl[NodeTextType.NODE_AFFILIATEDTOWN_TITLE]:SetShow(true)
	
	-- 메인노드의 소속 텍스트	
	_PA_LOG("최대호", "소속 : " ..getNodeAreaName(nodeStaticStatus))
	NodeTextControl[NodeTextType.NODE_AFFILIATEDTOWN_TEXT]:SetText( getNodeAreaName(nodeStaticStatus) )
	NodeTextControl[NodeTextType.NODE_AFFILIATEDTOWN_TEXT]:SetFontColor( NodeTextColor[NodeTextType.NODE_AFFILIATEDTOWN_TEXT] )
	NodeTextControl[NodeTextType.NODE_AFFILIATEDTOWN_TEXT]:SetShow(true)
]]--	-- 지역 타이틀	
	NodeTextControl[NodeTextType.NODE_NATIONAL_TITLE]:SetText( NodeTextString[NodeTextType.NODE_NATIONAL_TITLE] )
	NodeTextControl[NodeTextType.NODE_NATIONAL_TITLE]:SetFontColor( NodeTextColor[NodeTextType.NODE_NATIONAL_TITLE] )
	NodeTextControl[NodeTextType.NODE_NATIONAL_TITLE]:SetShow(true)
	
	--지역 텍스트	
	NodeTextControl[NodeTextType.NODE_NATIONAL_TEXT]:SetText( getNodeNationalName(nodeStaticStatus) )
	NodeTextControl[NodeTextType.NODE_NATIONAL_TEXT]:SetFontColor( NodeTextColor[NodeTextType.NODE_NATIONAL_TEXT] )
	NodeTextControl[NodeTextType.NODE_NATIONAL_TEXT]:SetShow(true)

	-- 영토 타이틀	
	NodeTextControl[NodeTextType.NODE_TERRITORY_TITLE]:SetText( NodeTextString[NodeTextType.NODE_TERRITORY_TITLE] )
	NodeTextControl[NodeTextType.NODE_TERRITORY_TITLE]:SetFontColor( NodeTextColor[NodeTextType.NODE_TERRITORY_TITLE] )
	NodeTextControl[NodeTextType.NODE_TERRITORY_TITLE]:SetShow(true)
	
	-- 영토 텍스트	
	NodeTextControl[NodeTextType.NODE_TERRITORY_TEXT]:SetText( getNodeTerritoryName(nodeStaticStatus) )
	NodeTextControl[NodeTextType.NODE_TERRITORY_TEXT]:SetFontColor( NodeTextColor[NodeTextType.NODE_TERRITORY_TEXT] )
	NodeTextControl[NodeTextType.NODE_TERRITORY_TEXT]:SetShow(true)
	
	if PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_KALPEON") == tostring(getNodeNationalName(nodeStaticStatus)) then
		nodeIcon_1:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_1, 418, 71, 436, 90 )
		nodeIcon_1:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_1:setRenderTexture(nodeIcon_1:getBaseTexture())
	elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_BALENCIA") == tostring(getNodeNationalName(nodeStaticStatus)) then
		nodeIcon_1:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_1, 456, 71, 474, 90 )
		nodeIcon_1:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_1:setRenderTexture(nodeIcon_1:getBaseTexture())
	elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_MEDIA") == tostring(getNodeNationalName(nodeStaticStatus)) then
		nodeIcon_1:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_1, 437, 71, 455, 90 )
		nodeIcon_1:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_1:setRenderTexture(nodeIcon_1:getBaseTexture())
	else
		nodeIcon_1:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_1, 418, 71, 436, 90 )
		nodeIcon_1:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_1:setRenderTexture(nodeIcon_1:getBaseTexture())
	end

	nodeIcon_2:SetShow( true )
	if ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENOS") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		nodeIcon_2:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_2, 399, 71, 417, 90 )
		nodeIcon_2:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_2:setRenderTexture(nodeIcon_2:getBaseTexture())
	elseif ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_SERENDIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		nodeIcon_2:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_2, 380, 71, 398, 90 )
		nodeIcon_2:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_2:setRenderTexture(nodeIcon_2:getBaseTexture())
	elseif ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_KALPEON") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		nodeIcon_2:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_2, 418, 71, 436, 90 )
		nodeIcon_2:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_2:setRenderTexture(nodeIcon_2:getBaseTexture())
	elseif ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MEDIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		nodeIcon_2:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_2, 437, 71, 455, 90 )
		nodeIcon_2:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_2:setRenderTexture(nodeIcon_2:getBaseTexture())
	elseif ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENCIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		nodeIcon_2:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_2, 456, 71, 474, 90 )
		nodeIcon_2:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_2:setRenderTexture(nodeIcon_2:getBaseTexture())
	else
		nodeIcon_2:SetShow( false )
	end
	
end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	선택한 노드의 정보를 패널에 채운다
]]--
local function FillExploreUpgradable( nodeStaticStatus, nodeKey )	
	local recipeItems	= getPlantInvestItemList(nodeStaticStatus)	
	local needPoint		= getPlantNeedPoint()
	local supportPoint	= getPlantNeedSupportPoint()
	local needMoney		= getPlantNeedMoney()
	
	if( needPoint > 0 ) then		
		if (requestCheckExplorationNodeExplorePoint(nodeKey)) then
			NodeTextControl[NodeTextType.NODE_POINT_TEXT]:SetFontColor(NodeTextColor[NodeTextType.NODE_MONEY_TEXT])
			contributeText:SetFontColor(NodeTextColor[NodeTextType.NODE_MONEY_TEXT])
		else
			NodeTextControl[NodeTextType.NODE_POINT_TEXT]:SetFontColor(NodeTextColor[NodeTextType.NODE_POINT_TEXT])
			contributeText:SetFontColor(NodeTextColor[NodeTextType.NODE_POINT_TEXT])
		end
		
		NodeTextControl[NodeTextType.NODE_POINT_TEXT]:SetText(NodeTextString[NodeTextType.NODE_POINT_TEXT].." : " .. tostring(needPoint))
		NodeTextControl[NodeTextType.NODE_POINT_TEXT]:SetShow(true)
		contributeText:SetText(NodeTextString[NodeTextType.NODE_POINT_TEXT].." : " .. tostring(needPoint))
	end
	
	if ( 0 < supportPoint ) then
		if (requestCheckExplorationNodeSupportPoint(nodeKey)) then
			NodeTextControl[NodeTextType.NODE_SUPPORT_TEXT]:SetFontColor(NodeTextColor[NodeTextType.NODE_MONEY_TEXT])
		else
			NodeTextControl[NodeTextType.NODE_SUPPORT_TEXT]:SetFontColor(NodeTextColor[NodeTextType.NODE_SUPPORT_TEXT])
		end

		local supportPointText
		
		if ( 1 == supportPoint ) then
			supportPointText = PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_STRANGE" )
		elseif ( 2 == supportPoint ) then
			supportPointText = PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_CLOSE" )
		elseif ( 3 == supportPoint ) then
			supportPointText = PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_RELIABLE" )
		elseif ( 4 <= supportPoint ) then
			supportPointText = PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_FAMOUS" )
		end
		
		NodeTextControl[NodeTextType.NODE_SUPPORT_TEXT]:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_SUPPORT" ) .. " : " .. supportPointText .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER" ))
		NodeTextControl[NodeTextType.NODE_SUPPORT_TEXT]:SetShow(true)
	end
	
	if( 0 < needMoney )then		
		NodeTextControl[NodeTextType.NODE_MONEY_TEXT]:SetFontColor(NodeTextColor[NodeTextType.NODE_MONEY_TEXT])
		NodeTextControl[NodeTextType.NODE_MONEY_TEXT]:SetText(PAGetString( NodeTextString[NodeTextType.NODE_MONEY_TEXT] .." : " .. tostring(needMoney)) )
		NodeTextControl[NodeTextType.NODE_MONEY_TEXT]:SetShow(true)
	end
	
	if ( 0 < recipeItems ) then
		for i = 0, recipeItems - 1, 1 do
			local needItemInfo = getPlantNeedtemByIndex(i);
			local needItemName = getItemName(needItemInfo:getItemStaticStatus());

			NodeTextControl[NodeTextType.NODE_ITEM1_TEXT+i]:SetFontColor(NodeTextColor[NodeTextType.NODE_ITEM1_TEXT+i])			
			
			NodeTextControl[NodeTextType.NODE_ITEM1_TEXT+i]:SetText( needItemName .. 'x' .. tostring(needItemInfo._itemCount_s64) )
			NodeTextControl[NodeTextType.NODE_ITEM1_TEXT+i]:SetShow(true)			
		end		
	end

	if ToClient_isAbleInvestnWithdraw(nodeKey) then
		nodeInfoButton.Invest:SetShow(true)
		nodeInfoButton.Invest:addInputEvent("Mouse_LUp",	"OnNodeUpgradeClick(" .. tostring(nodeKey) .. ")");
	else
		NodeTextControl[NodeTextType.NODE_FINDMANGER_TEXT]:SetAutoResize( true )
		NodeTextControl[NodeTextType.NODE_FINDMANGER_TEXT]:SetTextMode( UI_TM.eTextMode_AutoWrap )		
		
		NodeTextControl[NodeTextType.NODE_FINDMANGER_TEXT]:SetFontColor(NodeTextColor[NodeTextType.NODE_FINDMANGER_TEXT])				
		NodeTextControl[NodeTextType.NODE_FINDMANGER_TEXT]:SetText(NodeTextString[NodeTextType.NODE_FINDMANGER_TEXT])
		NodeTextControl[NodeTextType.NODE_FINDMANGER_TEXT]:SetShow(true)
	end
end

function HandledMouseEvent_FillNodeInfo(isShow, nodeType, nodeKey)
	local name, desc, control = nil, nil, nil

	if nil ~= nodeType and nil ~= nodeKey then
		name = nodeButtonTextSwitchCaseList[nodeType].." - ".. MakeNodeWeatherStatus(nodeKey)
		control = NodeMenu.Type
	end

	if true == isShow then
		-- registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	선택한 노드의 정보를 패널에 채운다
]]--
local function FillNodeInfo( nodeStaticStatus, nodeKey, isAffiliated, isMaxLevel )	
	-- 노드 이름 설정
	NodeMenu.Type:SetShow( true )
	NodeMenu.TypeGuild:SetShow ( false )
	-- NodeMenu.Name:SetText( getExploreNodeName(nodeStaticStatus) )			-- 노드 이름 분리
	nodeName:SetText( getExploreNodeName(nodeStaticStatus) )
	if (7 == getGameServiceType() or 8 == getGameServiceType()) then
		NodeMenu.Type:SetTextMode( CppEnums.TextMode.eTextMode_LimitText )
		NodeMenu.Type:addInputEvent("Mouse_On", "HandledMouseEvent_FillNodeInfo(true, " .. nodeStaticStatus._nodeType .. ", " .. nodeKey .. ")")
		NodeMenu.Type:addInputEvent("Mouse_Out", "HandledMouseEvent_FillNodeInfo(false)")
		NodeMenu.Type:SetIgnore( false )
	else
		NodeMenu.Type:SetIgnore( true )
	end
	NodeMenu.Type:SetText( nodeButtonTextSwitchCaseList[nodeStaticStatus._nodeType].." - ".. MakeNodeWeatherStatus(nodeKey) )
	nodeIcon_0:SetShow( true )
	
	if 0 == tonumber(nodeStaticStatus._nodeType) then					-- 연결로
		nodeIcon_0:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/worldmap_icon_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_0, 171, 203, 340, 399 )
		nodeIcon_0:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_0:setRenderTexture(nodeIcon_0:getBaseTexture())
	elseif 1 == tonumber(nodeStaticStatus._nodeType) then				-- 마을
		nodeIcon_0:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/worldmap_icon_02.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_0, 0, 203, 168, 399 )
		nodeIcon_0:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_0:setRenderTexture(nodeIcon_0:getBaseTexture())
	elseif 2 == tonumber(nodeStaticStatus._nodeType) then				-- 도시(중심마을)
		nodeIcon_0:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/worldmap_icon_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_0, 344, 203, 511, 399 )
		nodeIcon_0:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_0:setRenderTexture(nodeIcon_0:getBaseTexture())
	elseif 3 == tonumber(nodeStaticStatus._nodeType) then				-- 관문
		nodeIcon_0:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/worldmap_icon_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_0, 0, 203, 168, 399 )
		nodeIcon_0:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_0:setRenderTexture(nodeIcon_0:getBaseTexture())
	elseif 5 == tonumber(nodeStaticStatus._nodeType) then				-- 무역
		nodeIcon_0:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/worldmap_icon_03.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_0, 344, 203, 511, 399 )
		nodeIcon_0:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_0:setRenderTexture(nodeIcon_0:getBaseTexture())
	elseif 9 == tonumber(nodeStaticStatus._nodeType) then				-- 위험
		nodeIcon_0:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/worldmap_icon_04.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_0, 0, 203, 167, 398 )
		nodeIcon_0:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_0:setRenderTexture(nodeIcon_0:getBaseTexture())
	else
		nodeIcon_0:SetShow( false )
	end
	
	-- 공통적으로 보여야 하는 것들
	local description = requestPlantZoneDescription( nodeKey )
	if ( 0 < #description ) then		
		-- _PA_LOG("최대호", "description".. description )
		NodeTextControl[NodeTextType.NODE_DESCRIPTION]:SetText( description )
		NodeTextControl[NodeTextType.NODE_DESCRIPTION]:SetFontColor( NodeTextColor[NodeTextType.NODE_DESCRIPTION] )
		NodeTextControl[NodeTextType.NODE_DESCRIPTION]:SetShow(true)	
	end	
	
	local nodeManagerName = requestNodeManagerName( nodeKey )
	if ( 0 < #nodeManagerName ) then
		NodeTextControl[NodeTextType.NODE_MANAGER_TITLE]:SetText( NodeTextString[NodeTextType.NODE_MANAGER_TITLE] )
		NodeTextControl[NodeTextType.NODE_MANAGER_TITLE]:SetFontColor( NodeTextColor[NodeTextType.NODE_MANAGER_TITLE] )
		NodeTextControl[NodeTextType.NODE_MANAGER_TITLE]:SetShow(true)
		-- _PA_LOG("최대호", "nodeManagerName".. nodeManagerName )		
		NodeTextControl[NodeTextType.NODE_MANAGER_TEXT]:SetText( nodeManagerName )
		NodeTextControl[NodeTextType.NODE_MANAGER_TEXT]:SetFontColor( NodeTextColor[NodeTextType.NODE_MANAGER_TEXT] )
		NodeTextControl[NodeTextType.NODE_MANAGER_TEXT]:SetShow(true)
		
		nodeIcon_3:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( nodeIcon_3, 399, 51, 417, 70 )
		nodeIcon_3:getBaseTexture():setUV( x1, y1, x2, y2 )
		nodeIcon_3:setRenderTexture(nodeIcon_3:getBaseTexture())
		nodeIcon_3:SetShow(true)
	else
		nodeIcon_3:SetShow(false)
	end
	
	
	-- 조건에 따라 보여야 하는 정보
	-- @Date : 2014/12/02
	-- @Desc : 월드맵에서 일꾼들이 마을이 아니라, 지역으로 분류 되면서 정보의 분류가 필요가 없어졌다.
	-- 		   일괄적으로 같은 정보를 보여준다.
--	if(true == isAffiliated ) then
--		FillAffiliatedTownInfo( nodeStaticStatus, nodeKey )
--	elseif(true == nodeStaticStatus._isMainNode ) then
	FillMainNodeInfo( nodeStaticStatus, nodeKey )
--	end	
	
	local recipeItems	= getPlantInvestItemList(nodeStaticStatus)
	local needPoint		= getPlantNeedPoint()
	local supportPoint	= getPlantNeedSupportPoint()
	local needMoney		= getPlantNeedMoney()
	if( isExploreUpgradable( nodeKey ) ) then		
	-- _PA_LOG("최대호", "1234")
		if (isMaxLevel == false ) then
			FillExploreUpgradable( nodeStaticStatus, nodeKey )
		else
			if ( isWithdrawablePlant(nodeKey) ) then
				nodeInfoButton.Withdraw:SetShow(true)
				nodeInfoButton.Withdraw:addInputEvent("Mouse_LUp",	"OnNodeWithdrawClick( " .. tostring(nodeKey) .. ")")
			elseif ( needPoint > 0 or supportPoint > 0 or needMoney > 0 or recipeItems > 0 )then				
				NodeTextControl[NodeTextType.NODE_UNWITHDRAW_TEXT]:SetFontColor(NodeTextColor[NodeTextType.NODE_UNWITHDRAW_TEXT])	
				NodeTextControl[NodeTextType.NODE_UNWITHDRAW_TEXT]:SetAutoResize( true );
				NodeTextControl[NodeTextType.NODE_UNWITHDRAW_TEXT]:SetTextMode( UI_TM.eTextMode_AutoWrap );
				if ( workerManager_CheckWorkingOtherChannel() ) then
					NodeTextControl[NodeTextType.NODE_UNWITHDRAW_TEXT]:SetText(workerManager_getWorkingOtherChannelMsg())
				else
					NodeTextControl[NodeTextType.NODE_UNWITHDRAW_TEXT]:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTWITHDRAW" ))
				end
				NodeTextControl[NodeTextType.NODE_UNWITHDRAW_TEXT]:SetShow(true)
			end
		end
	else		
		-- _PA_LOG("최대호", "0000")
		NodeTextControl[NodeTextType.NODE_UNUPGRADE_TEXT]:SetFontColor(NodeTextColor[NodeTextType.NODE_UNUPGRADE_TEXT])		
		NodeTextControl[NodeTextType.NODE_UNUPGRADE_TEXT]:SetAutoResize( true );
		NodeTextControl[NodeTextType.NODE_UNUPGRADE_TEXT]:SetTextMode( UI_TM.eTextMode_AutoWrap );
		if ( true == nodeStaticStatus._isMainNode ) then
			-- _PA_LOG("최대호", "ismainnode"..PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE" ) )
			NodeTextControl[NodeTextType.NODE_UNUPGRADE_TEXT]:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE" ))
			nodeInfoButton.NearNode:SetShow(true)
			nodeInfoButton.NearNode:addInputEvent("Mouse_LUp",	"OnNearNodeClick(" .. tostring(nodeKey) .. ")")			
		elseif ( false == nodeStaticStatus._isMainNode ) then
			-- _PA_LOG("최대호", "isnotmainnode"..PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE_SUB" ) )
			NodeTextControl[NodeTextType.NODE_UNUPGRADE_TEXT]:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE_SUB" ))
		end
		
		NodeTextControl[NodeTextType.NODE_UNUPGRADE_TEXT]:SetShow(true)
	end
	
	--local regionInfo = nodeStaticStatus:getStaticStatus():getRegion() -- regionInfo를 가져온다
	--local regionKey = regionInfo._regionKey -- 리전 키 
	--local taxRate = regionInfo:getDropGroupRerollCountOfSieger() -- tax
	--SiegeWrapper ToClient_GetSiegeWrapperByRegionKey(regionKey) -- SiegeWrapper
	
end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	선택한 노드의 위치를 맞춘다
]]--
local function Align_NodeMenuControl( nodeStaticStatus, node )
	contributeText:SetShow( false )
	contributeIcon:SetShow( false )

	local posY = NodeMenu.Type:GetPosY() + NodeMenu.Type:GetSizeY() + 15
	for i = 0, NodeTextType.NODE_LAST - 1, 1 do
		if( NodeTextControl[i]:GetShow() ) then
			NodeTextControl[i]:SetPosX( (Panel_NodeMenu:GetSizeX() * 0.5) - ( NodeTextControl[i]:GetSizeX() * 0.5 ) + 20 )
			NodeTextControl[i]:SetPosY( posY )
			
			posY = posY + NodeTextControl[i]:GetSizeY() + 3
			
			if NodeTextType.NODE_POINT_TEXT == i then
				if true == NodeTextControl[NodeTextType.NODE_POINT_TEXT]:GetShow() then
					NodeTextControl[NodeTextType.NODE_POINT_TEXT]:SetShow(false)
					contributeText:SetShow( true )
					contributeIcon:SetShow( true )
					contributeText:SetPosY(posY - 20)
					contributeIcon:SetPosY(posY - 20)
					posY = posY + 10
				else
					contributeText:SetShow( false )
					contributeIcon:SetShow( false )
				end
			end
			
			if( i % 2 == 0 ) then
				posY = posY + 10
			end
		end
	end
	
	if( nodeInfoButton.NearNode:GetShow() ) then
		nodeInfoButton.NearNode:SetPosX( (Panel_NodeMenu:GetSizeX() * 0.5) - ( nodeInfoButton.Invest:GetSizeX() * 0.5 ) )
		nodeInfoButton.NearNode:SetPosY( posY )
		posY = posY + nodeInfoButton.NearNode:GetSizeY()
	end
	if( nodeInfoButton.Invest:GetShow() ) then
		nodeInfoButton.Invest:SetPosX((Panel_NodeMenu:GetSizeX() * 0.5) - ( nodeInfoButton.Invest:GetSizeX() * 0.5 ) )
		nodeInfoButton.Invest:SetPosY( posY )
		posY = posY + nodeInfoButton.Invest:GetSizeY()
	end
	if( nodeInfoButton.Withdraw:GetShow() ) then
		nodeInfoButton.Withdraw:SetPosX((Panel_NodeMenu:GetSizeX() * 0.5) - ( nodeInfoButton.Withdraw:GetSizeX() * 0.5 ) )
		nodeInfoButton.Withdraw:SetPosY( posY )	
		posY = posY + nodeInfoButton.Withdraw:GetSizeY()
	end
	nodeBg:SetSize( nodeBg:GetSizeX(), posY - 30 )
	nodeBg2:SetPosY ( nodeBg:GetSizeY() + nodeBg:GetPosX() + 40 )

	local _plantKey	= node:getPlantKey()
	local plant		= getPlant(_plantKey)
	local nodeKey	= _plantKey:getWaypointKey()
	local isSubNode	= false

	if (plant ~= nil) then
		isSubNode = plant:isSatellitePlant()	-- 서브 노드인지 체크
	end

	local regionInfo	= nodeStaticStatus:getMinorSiegeRegion() -- regionInfo를 가져온다
	if nil ~= regionInfo then
		local regionKey			= regionInfo._regionKey -- 리전 키
		local regionWrapper 	= getRegionInfoWrapper( regionKey:get() )
		local minorSiegeWrapper	= regionWrapper:getMinorSiegeWrapper()
		local siegeWrapper		= ToClient_GetSiegeWrapperByRegionKey( regionKey:get() )	-- SiegeWrapper
		local paDate			= siegeWrapper:getOccupyingDate()							-- 점령 시간
		local siegeTentCount	= ToClient_GetCompleteSiegeTentCount( regionKey:get() )
		--{ 거점전 혜택( 세금혜택, 생산 혜택 둘 중 하나만 혜택을 볼 수 있다. 즉, 둘중 하나의 값은 0이다.)
		local dropType				= regionInfo:getDropGroupRerollCountOfSieger()	-- 생산노드 혜택
		local nodeTaxType			= regionInfo:getVillageTaxLevel()				-- 세금 혜택
		--}
		local year				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()) )
		local month				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()) )
		local day				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()) )
		local hour				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()) )

		if true == minorSiegeWrapper:isSiegeBeing() then		-- 거점전이 진행중이라면
			Panel_NodeGuildWarMenu	:SetShow( true )
			FGlobal_NodeWarSetPosition()
			nodeWar_Ing				:SetShow( true )			-- 거점전 진행중
			local minorSiegeDoing	= ToClient_doMinorSiegeInTerritory( regionWrapper:getTerritoryKeyRaw() )
			if minorSiegeDoing then
				nodeWar_Count		:SetShow( true )			-- xx개의 길드가 참여중
			else
				nodeWar_Count		:SetShow( false )
			end
			nodeWar_Count			:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_COUNT", "siegeTentCount", siegeTentCount ) ) -- siegeTentCount .. "개 길드가 참여중입니다.
			nodeWar_Free			:SetShow( false )
			nodeWarMasterName		:SetShow( false )
			nodeWarBenefits			:SetShow( true )
			nodeWarGuildMarkBg		:SetShow( false )
			nodeWarGuildMark		:SetShow( false )
			nodeWarGuildName		:SetShow( false )
			nodeWarGuildMaster		:SetShow( false )
			nodeWarPeriod			:SetShow( false )
			nodeWarPeriodValue		:SetShow( false )
			nodeWarGuildBenefis		:SetShow( true )
			if 0 == dropType and 1 <= nodeTaxType then	-- 세금 혜택
				dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxType ) -- "세금 혜택(" .. nodeTaxType .. " 단계)"
			elseif 1 <= dropType and 0 == nodeTaxType then
				dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType+1 ) -- "생산량 혜택(" .. dropType .. " 단계)"
			elseif 1 <= dropType and 1 <= nodeTaxType then
				dropTypeValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxType), "dropType", tostring(dropType+1) ) -- "세금 혜택 : " .. tostring(nodeTaxType) .. "단계 / 생산량 혜택 : " .. tostring(dropType) .. "배수"
			else
				dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT") -- 혜택이 없습니다.
			end
			nodeWarGuildBenefis	:SetText( dropTypeValue )
		else
			if true == siegeWrapper:doOccupantExist() then		-- ture면 점령자가 있다.
				-- nodeWarClicked = true
				Panel_NodeGuildWarMenu	:SetShow( true )
				nodeWar_Ing				:SetShow( false )			-- 거점전 진행중
				nodeWar_Count			:SetShow( false )			-- xx개의 길드가 참여중
				nodeWar_Free			:SetShow( false )			-- 점령 길드가 없습니다.
				nodeWarMasterName		:SetShow( true )
				nodeWarGuildMarkBg		:SetShow( true )
				nodeWarGuildMark		:SetShow( true )
				nodeWarGuildName		:SetShow( true )
				nodeWarGuildMaster		:SetShow( true )
				nodeWarPeriod			:SetShow( true )
				nodeWarPeriodValue		:SetShow( true )
				nodeWarBenefits			:SetShow( true )
				nodeWarGuildBenefis		:SetShow( true )
				FGlobal_NodeWarSetPosition()

				local isSet = setGuildTextureByGuildNo( siegeWrapper:getGuildNo(), nodeWarGuildMark )
				if (not isSet) then
					nodeWarGuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
					local x1, y1, x2, y2 = setTextureUV_Func( nodeWarGuildMark, 183, 1, 188, 6 )
					nodeWarGuildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
					nodeWarGuildMark:setRenderTexture(nodeWarGuildMark:getBaseTexture())
				end
				nodeWarGuildName	:SetText( siegeWrapper:getGuildName() )
				nodeWarGuildMaster	:SetText( siegeWrapper:getGuildMasterName() )
				nodeWarPeriodValue	:SetText( year .. " " .. month .. " " .. day .. " " .. hour )

				if 0 == dropType and 1 <= nodeTaxType then	-- 세금 혜택
					dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxType ) -- "세금 혜택(" .. nodeTaxType .. " 단계)"
				elseif 1 <= dropType and 0 == nodeTaxType then
					dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType+1 ) -- "생산량 혜택(" .. dropType .. " 단계)"
				elseif 1 <= dropType and 1 <= nodeTaxType then
					dropTypeValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxType), "dropType", tostring(dropType+1) ) -- "세금 혜택 : " .. tostring(nodeTaxType) .. "단계 / 생산량 혜택 : " .. tostring(dropType) .. "배수"
				else
					dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT") -- 혜택이 없습니다.
				end
				nodeWarGuildBenefis	:SetText( dropTypeValue )
			else
				Panel_NodeGuildWarMenu:SetShow( true )
				FGlobal_NodeWarSetPosition()
				nodeWar_Free			:SetShow( true )
				nodeWar_Ing				:SetShow( false )
				nodeWar_Count			:SetShow( false )
				nodeWarMasterName		:SetShow( false )
				nodeWarBenefits			:SetShow( true )
				nodeWarGuildMarkBg		:SetShow( false )
				nodeWarGuildMark		:SetShow( false )
				nodeWarGuildName		:SetShow( false )
				nodeWarGuildMaster		:SetShow( false )
				nodeWarPeriod			:SetShow( false )
				nodeWarPeriodValue		:SetShow( false )
				nodeWarGuildBenefis		:SetShow( true )

				if 0 == dropType and 1 <= nodeTaxType then	-- 세금 혜택
					dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxType ) -- "세금 혜택(" .. nodeTaxType .. " 단계)"
				elseif 1 <= dropType and 0 == nodeTaxType then
					dropTypeValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType+1 ) -- "생산량 혜택(" .. dropType .. " 단계)"
				elseif 1 <= dropType and 1 <= nodeTaxType then
					dropTypeValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxType), "dropType", tostring(dropType+1) ) -- "세금 혜택 : " .. tostring(nodeTaxType) .. "단계 / 생산량 혜택 : " .. tostring(dropType) .. "배수"
				else
					dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT") -- 혜택이 없습니다.
				end
				nodeWarGuildBenefis	:SetText( dropTypeValue )
			end
		end
	end

	if ( 1 <= ToClient_GetNodeLevel(nodeKey) ) then		-- 노드 활성화 후
		if isSubNode then	-- 서브 노드라면 (농장, 광산등..)
			nodeLv_progress:SetProgressRate( 0.0 )
			nodeBg2:SetShow( false )
			Panel_NodeMenu:SetSize( Panel_NodeMenu:GetSizeX(), posY + 20)
		else
			nodeBg2:SetShow( true )
			nodeLv_progress:SetShow( true )
			nodeBg2:SetSize( nodeBg2:GetSizeX(), 182 )
			Panel_NodeMenu:SetSize( Panel_NodeMenu:GetSizeX(), posY + nodeBg2:GetSizeY() + 30 )
		end
	else																				-- 노드 활성화 전
		nodeLv_progress:SetProgressRate( 0.0 )
		nodeBg2:SetShow( false )
		Panel_NodeMenu:SetSize( Panel_NodeMenu:GetSizeX(), posY + 20)
	end
	-- 도시만 아이템 거래소 버튼을 보여준다!! (결정사항)
	-- if ENT.eExplorationNodeType_City == nodeStaticStatus._nodeType then
		-- nodeInfoButton.ItemMarket:SetPosY( Panel_NodeMenu:GetSizeY() + 10)
		-- nodeInfoButton.ItemMarket:SetShow( true )
	-- else
		-- --nodeInfoButton.ItemMarket:SetPosY( Panel_NodeMenu:GetSizeY() )
		-- nodeInfoButton.ItemMarket:SetShow( false )
	-- end
end

-- function FGlobal_NodeClickedReturn()
-- 	return nodeWarClicked
-- end	

function FGlobal_NodeWarSetPosition()
	-- Panel_NodeGuildWarMenu:SetShow( true )
	-- nodeWarClicked = false
	Panel_NodeGuildWarMenu:SetPosX( Panel_NodeMenu:GetPosX() + Panel_NodeMenu:GetSizeX() + 10 )
	Panel_NodeGuildWarMenu:SetPosY( Panel_NodeMenu:GetPosY() )
end

function WorldMap_ItemMarket_Open( territoryKeyRaw )
	
	-- local confirmFunction = function()	
		FGlobal_ItemMarket_Open_ForWorldMap( territoryKeyRaw )
	-- end
	-- local messageBoxMemo = "월드맵에서 거래소를 살펴보는데 일부 기운이 소모되게 됩니다. 진행하시겠습니까?" 
	-- local messageBoxData = { title = "거래소 살펴보기", content = messageBoxMemo, functionYes = confirmFunction, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	-- MessageBox.showMessageBox(messageBoxData)

end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	정보를 초기화 한다
]]--
local function ClearNodeInfo()
	for i = 0, NodeTextType.NODE_LAST - 1, 1 do
		NodeTextControl[i]:SetShow(false)
		-- NodeInfomation[i] = nil
	end
	
	nodeInfoButton.Invest:SetShow(false)
	nodeInfoButton.NearNode:SetShow(false)
	nodeInfoButton.Withdraw:SetShow(false)
	nodeInfoButton.HouseManageProduct:SetShow(false)
end

local function Init_NodeMenu()
	for i = 0, NodeTextType.NODE_LAST - 1, 1 do
		if( nil == NodeTextControl[i] ) then
			NodeTextControl[i] = UI.createControl( UI_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_NodeMenu, "StaticText_NodeMenu"..tostring(i) );
			CopyBaseProperty( template.NodeMenuRequireItem, NodeTextControl[i]);

		end
	end
end

--[[ Panel_NodeMenu 전역 함수 ]]--

function  FGlobal_ShowInfoNodeMenuPanel( node )
	if(	false == ToClient_WorldMapIsShow() ) then
		return
	end
	local plantKey				= node:getPlantKey()
	local nodeKey				= plantKey:getWaypointKey()
	local wayPlant				= ToClient_getPlant(plantKey)
	local affiliatedTownKey		= 0;
	if (plantKey:get() == CppEnums.MiniGameParam.eMiniGameParamLoggiaCorn or  plantKey:get() == CppEnums.MiniGameParam.eMiniGameParamLoggiaFarm or  plantKey:get() == CppEnums.MiniGameParam.eMiniGameParamAlehandroHoney or  plantKey:get() == CppEnums.MiniGameParam.eMiniGameParamImpCave) and true == node:isMaxLevel() then 
		FGlobal_MiniGame_RequestPlantInvest(plantKey:get()) -- 퀘스트 : 거점 투자 (로기아 농장 - 옥수수 재배)
	end

	nodeStaticStatus = node:getStaticStatus()
	if( nil ~= wayPlant ) then
		affiliatedTownKey 	= ToClinet_getPlantAffiliatedWaypointKey(wayPlant)
	end
	Panel_NodeMenu:SetPosX( 5 );
	Panel_NodeMenu:SetPosY( 45 );
	ClearNodeInfo()

	FillNodeInfo(node:getStaticStatus(), nodeKey, nodeKey == affiliatedTownKey, node:isMaxLevel() )
	Align_NodeMenuControl( node:getStaticStatus(), node )
	
	_wayPointKey = nodeKey
	local nodeLv		= ToClient_GetNodeLevel( _wayPointKey )
	local nodeExp		= Int64toInt32(ToClient_GetNodeExperience_s64 ( _wayPointKey ))
	local nodeExpMax	= Int64toInt32(ToClient_GetNeedExperienceToNextNodeLevel_s64( _wayPointKey ))
	local nodeExpPercent= (nodeExp/nodeExpMax) * 100
	nodeLv_Level	:SetText(nodeLv)
		
	if isProgressReset then
		nodeLv_progress:SetProgressRate( 0.0 )
		isProgressReset = false
	else
		nodeLv_progress:SetProgressRate( nodeExpPercent )
	end

	Button_NodeLvUp	:addInputEvent("Mouse_LUp", "ToClient_RequestIncreaseExperienceNode( ".. _wayPointKey ..", 10 )")
end

function NodeMenu_ShowToggle( isShow )
	if isShow then
		NodeName_Show()
	else
		NodeName_Hide()
	end
end

function NodeName_Show()
	Panel_NodeName:SetShow( true, true )
	Panel_NodeName:SetPosX( getScreenSizeX()/2 - Panel_NodeName:GetPosY()/2 )
	Panel_NodeName:SetPosY( getScreenSizeY()/6 )
	L_Line:SetSize( getScreenSizeX() / 2 - 278, 11 )
	R_Line:SetSize( getScreenSizeX() / 2 - 278, 11 )
	L_Line:SetPosX ( Panel_NodeName:GetPosX() * (-1) )
	R_Line:SetPosX ( getScreenSizeX() - (getScreenSizeX() / 2) + 278 - Panel_NodeName:GetPosX())

	L_Line:SetPosY ( 15 )
	R_Line:SetPosY ( 15 )
end

function NodeName_Hide()
	nodeName:EraseAllEffect()
	Panel_NodeName:SetShow( false )
end

function FGlobal_CloseNodeMenu()
	ClearNodeInfo()
	Panel_NodeMenu:SetShow(false)
	FGlobal_WorldMapWindowEscape()
end

function FromClient_RClickedWorldMapNode( nodeBtn )
	local node = nodeBtn:FromClient_getExplorationNodeInClient()
	if( nil == node ) then
		return
	end
	
	local nodeStaticStatus = node:getStaticStatus()
	local position = ToClient_getNodeManagerPosition(nodeStaticStatus)
	if 0 == position.x and 0 == position.y and 0 == position.z then
		position = nodeStaticStatus:getPosition()
	end


	FromClient_RClickWorldmapPanel( position, true )
end


local buildingActorKey = nil;
function FGlobal_ShowBuildingInfo( nodeBtn )	
	ClearNodeInfo();
	nodeBg2:SetShow( false )
	Panel_NodeMenu:SetPosX( 125 );
	Panel_NodeMenu:SetPosY( 270 );
	

	buildingActorKey 		= nodeBtn:ToClient_getActorKey();
	local	buildingSS		= ToClient_getBuildingInfo( buildingActorKey ); 

	if( nil == buildingSS ) then
		return;
	end

	nodeTypeText = PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_CONSTRUCTURE" )	-- "건축물"
	NodeMenu.TypeGuild:SetShow( true )
	NodeMenu.Type:SetShow(false)
	NodeMenu.TypeGuild:SetText( ToClient_getBuildingOwnerName( buildingSS ) ); -- 길드 이름
	NodeMenu.Name:SetText(  ToClient_getBuildTypeName( buildingSS )); -- 건축물 종류

	local workableCount = ToClient_getBuildingWorkableListCount( buildingSS );
	
	local buttonBasePosY	= NodeMenu.Type:GetPosY() + NodeMenu.Type:GetSizeY() + 10
	local buttonPosY		= buttonBasePosY	
	
	if( 0 < workableCount ) then
		-- nodeInfoButton.HouseManageProduct:SetPosX((Panel_NodeMenu:GetSizeX() * 0.5) - ( nodeInfoButton.HouseManageProduct:GetSizeX() * 0.5 ) );
		-- nodeInfoButton.HouseManageProduct:SetPosY( buttonPosY );
		-- nodeInfoButton.HouseManageProduct:SetShow(true);
		-- nodeInfoButton.HouseManageProduct:addInputEvent("Mouse_LUp",	"FGlobal_OnClickBuildingManage()");
		-- buttonPosY = buttonPosY + nodeInfoButton.HouseManageProduct:GetSizeY();
		FGlobal_OnClickBuildingManage()
	end

	-- Panel_NodeMenu:SetSize(Panel_NodeMenu:GetSizeX(), buttonPosY + (buttonPosY/2))
	Panel_NodeMenu:SetSize(Panel_NodeMenu:GetSizeX(), buttonPosY+30 )
	nodeBg:SetSize( nodeBg:GetSizeX(), Panel_NodeMenu:GetSizeY()/2 )
	Panel_NodeMenu:SetShow(true);
	closeButton:SetShow( false )
	nodeIcon_0:SetShow( false )
	nodeIcon_1:SetShow( false )
	nodeIcon_2:SetShow( false )
	nodeIcon_3:SetShow( false )
	nodeInfoButton.Invest:SetShow( false )
	-- nodeInfoButton.ItemMarket:SetShow( false )
	contributeText:SetShow( false )
	contributeIcon:SetShow( false )

	
end
--[[
local function Check_Builing_Progress(buildingSS)
	if nil == buildingSS then
		return
	end
	
	local workCount				= ToClient_getBuildingWorkableListCount(buildingSS)
	local workingCout			= ToClient_getBuildingWorkingList( buildingSS )	
	if workingCout > 0 then
		return false
	end	
	for index = 1, workCount do
		local buildingStaticStatus 	= ToClient_getBuildingWorkableBuildingSourceUnitByIndex(buildingSS ,index - 1)
		local count_Total 			= buildingStaticStatus._needBuildProgressPoint
		local count_Current 		= ToClient_getWorkableCurrentBuildingPoint(buildingSS, index - 1)
		if (count_Total - count_Current) > 0 then
			return false
		end
	end
	
	-- 건축이 이미 완료되었다!
	local workName = ToClient_getBuildingName( buildingSS )
	Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_COMPLETED_BUILDING", "workName", workName) )	
	return true
end
--]]
function FGlobal_OnClickBuildingManage()
	-- FGlobal_OpenMultipleWorkManager(buildingSS,CppEnums.NpcWorkingType.eNpcWorkingType_PlantBuliding);  
	-- local isComplete = Check_Builing_Progress(buildingSS)
	-- if true == isComplete then
		-- return
	-- end
	local	buildingSS		= ToClient_getBuildingInfo( buildingActorKey ); 

	if( nil == buildingSS ) then
		return
	end
		
	if( false == ToClient_isMyBuilding( buildingSS ) ) then
		return;
	end
	if 1 <= buildingSS:getBuildingProgress() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_CLICK_COMPLETED_BUILDING") )
	else
		FGlobal_Building_WorkManager_Reset_Pos()
		FGlobal_Building_WorkManager_Open(buildingActorKey)
		WorldMapPopupManager:increaseLayer();
		WorldMapPopupManager:push( Panel_NodeMenu, true );
		WorldMapPopupManager:push( Panel_Building_WorkManager, true )
	end
end
		
function FromClient_BuildingNodeRClick( nodeBtn )
	local buildInfoSS =	nodeBtn:ToClient_getBuildingStaticStatus();

	if( nil ~= buildInfoSS ) then
		FromClient_RClickWorldmapPanel( ToClient_getBuildingPosition(buildInfoSS), true )
	end
end

function FGlobal_OnClickTradeIcon( territoryKeyRaw )
	WorldMap_ItemMarket_Open( territoryKeyRaw );
end

local nodeBtnArray = {}

function CreateNodeIconForTradeIcon_ShowTooltip( wayPointKey, isShow )
	if isLuaLoadingComplete then
		if true == isShow then
			local name = PAGetString(Defines.StringSheet_GAME, "GAME_ITEM_MARKET_NAME") -- "아이템 거래소"
			if( nil ~= nodeBtnArray[wayPointKey]) then				
				local tradeIcon = nodeBtnArray[wayPointKey]:FromClient_getTradeIcon();
				TooltipSimple_Show( tradeIcon,  name )
			end			
		else
			TooltipSimple_Hide()
		end
	end
end

function FGlobal_ExplorationNode ( WaypointKey, ExplorationLevel, TExperience )
	local nodeExp		= Int64toInt32(TExperience)
	local nodeExpMax	= Int64toInt32(ToClient_GetNeedExperienceToNextNodeLevel_s64( WaypointKey ))
	local nodeExpPercent= (nodeExp/nodeExpMax) * 100
	
	nodeLv_Level	:SetText(ExplorationLevel)
	nodeLv_progress:SetProgressRate( nodeExpPercent )
end

function worldmapNodeIcon_GuildWarSet( nodeBtn )
	local explorationInfo		= nodeBtn:FromClient_getExplorationNodeInClient();
	local nodeStaticStatus		= explorationInfo:getStaticStatus()
	local regionInfo			= nodeStaticStatus:getMinorSiegeRegion() -- regionInfo를 가져온다
	
	local warStateIcon 			= nodeBtn:FromClient_getWarStateIcon()
	local guildModeGuildMark	= nodeBtn:FromClient_getNodeGuildIcon()	-- 노드에 붙어있는 길드마크 아이콘.

	if nil ~= regionInfo then
		local regionKey			= regionInfo._regionKey -- 리전 키
		local regionWrapper 	= getRegionInfoWrapper( regionKey:get() )
		local minorSiegeWrapper	= regionWrapper:getMinorSiegeWrapper()
		local siegeWrapper		= ToClient_GetSiegeWrapperByRegionKey( regionKey:get() ) -- SiegeWrapper
		local guildMark			= nodeBtn:FromClient_getGuildMark()
		local guildMarkBG		= nodeBtn:FromClient_getGuildMarkBG()
		
		if ToClient_doMinorSiegeInTerritory( nodeBtn:FromClient_getTerritoryKey() )
			and minorSiegeWrapper:isSiegeBeing() then
--		if minorSiegeWrapper:isSiegeBeing() then	-- 점령전 중이다.
			warStateIcon	:setUpdateTextureAni( true )
			warStateIcon	:SetShow( true )

			guildMark		:SetShow( false )
			guildMarkBG		:SetShow( false )
		else
			warStateIcon:setUpdateTextureAni( false )
			if true == siegeWrapper:doOccupantExist() then	-- 소유 길드가 있다.
				-- 마크를 가져온다.
				local isSet = setGuildTextureByGuildNo( siegeWrapper:getGuildNo(), guildMark )
				if ( false == isSet ) then
					guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
					local x1, y1, x2, y2 = setTextureUV_Func( guildMark, 183, 1, 188, 6 )
					guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
				else
					guildMark:getBaseTexture():setUV(  0, 0, 1, 1  )
				end
				guildMark:setRenderTexture(guildMark:getBaseTexture())

				warStateIcon	:SetShow( false )
				guildMark		:SetShow( true )
				guildMarkBG		:SetShow( true )
			else
				warStateIcon	:SetShow( true )
				guildMark		:SetShow( false )
				guildMarkBG		:SetShow( false )
			end
		end
		guildModeGuildMark:SetShow( false )
	end
end

function FromClient_CreateNodeIcon( nodeBtn )	
	worldmapNodeIcon_GuildWarSet( nodeBtn )

	local tradeIcon 		= nodeBtn:FromClient_getTradeIcon();
	local explorationInfo	= nodeBtn:FromClient_getExplorationNodeInClient();
	local plantKey			= explorationInfo:getPlantKey();
	local wayPointKey		= plantKey:getWaypointKey();

	-- TODO : 반드시 수정할 것
	local territoryKeyRaw =	nodeBtn:FromClient_getTerritoryKey();
	if( wayPointKey  == 301			-- 하이델
		or wayPointKey == 1			-- 벨리아
		or wayPointKey == 601 		-- 칼페온
		or wayPointKey == 1101 ) then 	-- 알티노바
		tradeIcon:SetSpanSize( -10, 20 )

		tradeIcon:SetShow(true);
		nodeBtnArray[wayPointKey] = nodeBtn;
		tradeIcon:addInputEvent("Mouse_LUp", 	"FGlobal_handleOpenItemMarket(" ..territoryKeyRaw..")" );
		tradeIcon:addInputEvent("Mouse_On",		"CreateNodeIconForTradeIcon_ShowTooltip(" .. wayPointKey ..", true )" );
		tradeIcon:addInputEvent("Mouse_Out",	"CreateNodeIconForTradeIcon_ShowTooltip(" .. wayPointKey ..", false )" );
	end
end

function FromClient_StartMinorSiege( nodeBtn )
	local warStateIcon	= nodeBtn:FromClient_getWarStateIcon()
	warStateIcon		:setUpdateTextureAni( true )
	warStateIcon		:SetShow( true )

	local guildMark		= nodeBtn:FromClient_getGuildMark()
	local guildMarkBG	= nodeBtn:FromClient_getGuildMarkBG()
	guildMark			:SetShow( false )
	guildMarkBG			:SetShow( false )
end

function FromClient_EndMinorSiege( nodeBtn )
	worldmapNodeIcon_GuildWarSet( nodeBtn )
end

function FromClient_OnVillageSiegeBuildingNodeGroup( nodeBtn )
	nodeBtn:EraseAllEffect()
	nodeBtn:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
end

function FromClient_OutVillageSiegeBuildingNodeGroup( nodeBtn )
	nodeBtn:EraseAllEffect()
end

function FromClient_SetGuildModeeWorldMapNodeIcon( nodeBtn )
	if( FGlobal_isGuildWarMode() ) then
		local warStateIcon 	= nodeBtn:FromClient_getWarStateIcon()
		local guildMark		= nodeBtn:FromClient_getGuildMark()
		local guildMarkBG	= nodeBtn:FromClient_getGuildMarkBG()
		warStateIcon		:SetShow( false )
		guildMark			:SetShow( false )
		guildMarkBG			:SetShow( false )
	else
		worldmapNodeIcon_GuildWarSet( nodeBtn )
	end	
end


function FGlobal_WayPointKey_Return()
	return _wayPointKey
end

Init_NodeMenu()

registerEvent("FromClient_CreateWorldMapNodeIcon",					"FromClient_CreateNodeIcon")
registerEvent("FromClient_FillNodeInfo",							"FGlobal_ShowInfoNodeMenuPanel")
registerEvent("FromClient_RClickedWorldMapNode",					"FromClient_RClickedWorldMapNode")
registerEvent("FromClient_ShowBuildingInfo",						"FGlobal_ShowBuildingInfo")
registerEvent("FromClient_BuildingNodeRClick",						"FromClient_BuildingNodeRClick")
registerEvent("WorldMap_NodeWithdraw",								"FGlobal_ShowInfoNodeMenuPanel")
registerEvent("FromClint_EventIncreaseExperienceExplorationNode",	"FGlobal_ExplorationNode")

registerEvent("FromClient_StartMinorSiege",							"FromClient_StartMinorSiege")
registerEvent("FromClient_EndMinorSiege",							"FromClient_EndMinorSiege")

registerEvent("FromClient_SetGuildModeeWorldMapNodeIcon",			"FromClient_SetGuildModeeWorldMapNodeIcon")

registerEvent("FromClient_OnVillageSiegeBuildingNodeGroup",			"FromClient_OnVillageSiegeBuildingNodeGroup")
registerEvent("FromClient_OutVillageSiegeBuildingNodeGroup",		"FromClient_OutVillageSiegeBuildingNodeGroup")

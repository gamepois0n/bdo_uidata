local UI_TYPE		= CppEnums.PA_UI_CONTROL_TYPE
local ENT 			= CppEnums.ExplorationNodeType
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM 		= CppEnums.TextMode
local UI_PP 		= CppEnums.PAUIMB_PRIORITY
local UI_TT			= CppEnums.PAUI_TEXTURE_TYPE

local nodeStaticStatus	= nil
local _wayPointKey		= nil
local isProgressReset	= false

-- 노드 레벨업을 위한 패널 정보

local Txt_Node_Title		= UI.getChildControl( Panel_NodeMenu, "MainMenu_Title" );
local Txt_NodeManager		= UI.getChildControl( Panel_NodeMenu, "MainMenu_StaticText_NodeManager");
local static_NodeManagerBG	= UI.getChildControl( Panel_NodeMenu, "MainMenu_Bg");

local Txt_NodeManager_Name	= UI.getChildControl( Panel_NodeMenu, "MainMenu_StaticText_NodeManager_Value");
local Txt_Node_Desc			= UI.getChildControl( Panel_NodeMenu, "MainMenu_StaticText_NodeLinkStatus");

local Tex_NeedExplorePoint	= UI.getChildControl( Panel_NodeMenu, "MainMenu_NeedExplorePoint_LinkIcon");
local Txt_NeedExplorePoint	= UI.getChildControl( Panel_NodeMenu, "MainMenu_NeedExplorePoint_Link_Value");

local Btn_NodeLink			= UI.getChildControl( Panel_NodeMenu, "MainMenu_Button_NodeLink");
local Btn_NearNode			= UI.getChildControl( Panel_NodeMenu, "MainMenu_Button_NearNode");
local Btn_NodeUnlink		= UI.getChildControl( Panel_NodeMenu, "MainMenu_Button_NodeUnLink");

local NodeLevelGroup = {
	Tex_NodeLevBG			= UI.getChildControl( Panel_NodeMenu, "MainMenu_Static_NodeLev_Bg"),
	Btn_NodeLev				= UI.getChildControl( Panel_NodeMenu, "MainMenu_Button_NodeLev"),
	Txt_NodeLevel			= UI.getChildControl( Panel_NodeMenu, "MainMenu_CurrentNodeLevel"),
	Tex_ProgressBG			= UI.getChildControl( Panel_NodeMenu, "MainMenu_ProgressBg_NodeLev"),
	Progress_NodeLevel		= UI.getChildControl( Panel_NodeMenu, "MainMenu_Progress_NodeLev"),
	Btn_NodeLevHelp			= UI.getChildControl( Panel_NodeMenu, "MainMenu_NodelLev_Help"),
}

local savedisMaxLevel = false

local NodeWarGroup = {
	
}

local SelfExplorePointGroup = {
	Tex_Explore_Partline		= UI.getChildControl( Panel_NodeMenu, "MainMenu_Static_Partline"),
	Tex_ExplorePoint_BG			= UI.getChildControl( Panel_NodeMenu, "MainMenu_ExplorePoint_Bg"),
	Tex_ExplorePoint_Icon		= UI.getChildControl( Panel_NodeMenu, "MainMenu_ExplorePoint_Icon"),
	Txt_ExplorePoint_Value		= UI.getChildControl( Panel_NodeMenu, "MainMenu_ExplorePoint_Value"),
	Tex_ExplorePoint_PrgressBG	= UI.getChildControl( Panel_NodeMenu, "MainMenu_ExplorePoint_Progress_BG"),
	Progress_ExplorePoint		= UI.getChildControl( Panel_NodeMenu, "MainMenu_ExplorePoint_Progress"),
	Btn_ExplorePoint_Help		= UI.getChildControl( Panel_NodeMenu, "MainMenu_ExplorePoint_Help")
}

local nodeMenu_init = function()
	NodeLevelGroup.Btn_NodeLevHelp				:addInputEvent( "Mouse_On", 	"HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( true, " .. 0 .. " )")
	NodeLevelGroup.Btn_NodeLevHelp				:addInputEvent( "Mouse_Out", 	"HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( false, " .. 0 .. " )")
	NodeLevelGroup.Btn_NodeLevHelp				:setTooltipEventRegistFunc(		"HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( true, " .. 0 .. " )")

	SelfExplorePointGroup.Btn_ExplorePoint_Help	:addInputEvent( "Mouse_On", 	"HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( true, " .. 1 .. " )")
	SelfExplorePointGroup.Btn_ExplorePoint_Help	:addInputEvent( "Mouse_Out", 	"HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( false, " .. 1 .. " )")
	SelfExplorePointGroup.Btn_ExplorePoint_Help	:setTooltipEventRegistFunc(		"HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( true, " .. 1 .. " )")
end


local IconType = {
	Country 	= 0,
	Territory	= 1,
	NodeType	= 2,
	Weather		= 3,
}

local NodeIconArray = {
	[IconType.Country]		= UI.getChildControl( Panel_NodeMenu, "MainMenu_Contry"),
	[IconType.Territory]	= UI.getChildControl( Panel_NodeMenu, "MainMenu_City"),
	[IconType.NodeType]		= UI.getChildControl( Panel_NodeMenu, "MainMenu_NodeType"),
	-- [IconType.Weather]		= UI.getChildControl( Panel_NodeMenu, "MainMenu_Weather_Icon")
}

NodeLevelGroup.Btn_NodeLev:SetAutoDisableTime(0.3)

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

--[[ Panel_Node 지역 함수 ]]--
local SetFontColorAndText = function( uiControl, text, color )
	uiControl:SetText(text);
	uiControl:SetFontColor( color );
end

--[[
	@date	2014/07/03
	@author	최대호
	@brief	주변 노드 확인 버튼을 누를 시 호출
]]--
function OnNearNodeClick( nodeKey )
	ToClient_DeleteNaviGuideByGroup(0);
	ToClient_WorldMapFindNearNode( nodeKey, NavigationGuideParam() )
	audioPostEvent_SystemUi(00,14)
	FGlobal_WorldMapWindowEscape()
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
	
	
	if( 0.6 < fWeatherCloudRate ) then
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_HIGH" );
	elseif( 0.3 < fWeatherCloudRate ) then
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_MID" );
	else
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_LOW" )
	end	
	
	if( 0.6 < fWeatherRainAmount ) then
		if fWeatherCelsius < 0.0 then
			strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_SNOWAMOUNT_HIGH" );
		else
			strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_HIGH" );
		end
	elseif( 0.3 < fWeatherRainAmount ) then
		if fWeatherCelsius < 0.0 then
			strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_SNOWAMOUNT_MID" );
		else
			strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_MID" );
		end
	else
		strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_LOW" )
	end

	if( 30.0 < fWeatherCelsius ) then
		strWeatherCelsius = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CELSIUS_HIGH" );
	elseif( 0 < fWeatherCelsius ) then
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
local function FillContryInfo( nodeStaticStatus )
	local countryIcon	= NodeIconArray[IconType.Country]
	if PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_KALPEON") == tostring(getNodeNationalName(nodeStaticStatus)) then
		countryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( countryIcon, 418, 71, 436, 90 )
		countryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_BALENCIA") == tostring(getNodeNationalName(nodeStaticStatus)) then
		countryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( countryIcon, 456, 71, 474, 90 )
		countryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_MEDIA") == tostring(getNodeNationalName(nodeStaticStatus)) then
		countryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( countryIcon, 437, 71, 455, 90 )
		countryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	else
		countryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( countryIcon, 418, 71, 436, 90 )
		countryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	end

	countryIcon:setRenderTexture(countryIcon:getBaseTexture())

	-- 국가 정보
	countryIcon:SetText( getNodeNationalName(nodeStaticStatus) )
	countryIcon:SetFontColor( NodeTextColor[NodeTextType.NODE_NATIONAL_TEXT] )
end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	메인 노드의 정보를 채운다
]]--
local function FillTerritoryInfo( nodeStaticStatus )
	local territoryIcon	= NodeIconArray[IconType.Territory]
	territoryIcon:SetShow( true )
	if ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENOS") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		territoryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( territoryIcon, 399, 71, 417, 90 )
		territoryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	elseif ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_SERENDIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		territoryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( territoryIcon, 380, 71, 398, 90 )
		territoryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	elseif ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_KALPEON") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		territoryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( territoryIcon, 418, 71, 436, 90 )
		territoryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	elseif ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MEDIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		territoryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( territoryIcon, 437, 71, 455, 90 )
		territoryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	elseif ( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENCIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) ) then
		territoryIcon:ChangeTextureInfoName( "new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( territoryIcon, 456, 71, 474, 90 )
		territoryIcon:getBaseTexture():setUV( x1, y1, x2, y2 )
	else
		-- territoryIcon:SetShow( false )
	end
	territoryIcon:setRenderTexture(territoryIcon:getBaseTexture())

	-- 영토 정보
	territoryIcon:SetText( getNodeTerritoryName(nodeStaticStatus) )
	territoryIcon:SetFontColor( NodeTextColor[NodeTextType.NODE_TERRITORY_TEXT] )
end

--[[
	@date	2014/07/02
	@author	최대호
	@brief	선택한 노드의 정보를 패널에 채운다
]]--
local FillExploreUpgradeAble = function( nodeStaticStatus, nodeKey )
	local needPoint		= getPlantNeedPoint()
	if( needPoint > 0 ) then
		local contributeText = NodeTextString[NodeTextType.NODE_POINT_TEXT].." : " .. tostring(needPoint);
		if (requestCheckExplorationNodeExplorePoint(nodeKey)) then
			SetFontColorAndText( Txt_NeedExplorePoint,  contributeText, NodeTextColor[NodeTextType.NODE_MONEY_TEXT] )
		else
			SetFontColorAndText( Txt_NeedExplorePoint,  contributeText, NodeTextColor[NodeTextType.NODE_POINT_TEXT] )
		end
	end

	local recipeItems	= getPlantInvestItemList(nodeStaticStatus)	
	local needPoint		= getPlantNeedPoint()
	local supportPoint	= getPlantNeedSupportPoint()
	local needMoney		= getPlantNeedMoney()
	if ToClient_isAbleInvestnWithdraw(nodeKey) then
		Btn_NodeLink:SetShow(true)
		Btn_NodeLink:addInputEvent("Mouse_LUp",	"OnNodeUpgradeClick(" .. tostring(nodeKey) .. ")");
	else
		Txt_Node_Desc:SetAutoResize(true);
		Txt_Node_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap );

		Txt_Node_Desc:SetFontColor(NodeTextColor[NodeTextType.NODE_FINDMANGER_TEXT])				
		Txt_Node_Desc:SetText(NodeTextString[NodeTextType.NODE_FINDMANGER_TEXT])
		Txt_Node_Desc:SetShow(true)
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
	@date	2015/06/25
	@author	최대호
	@brief	선택한 노드의 정보를 패널에 채운다
]]--

local SetNodeType = function( nodeType )
	local uiControl = NodeIconArray[IconType.NodeType]
	uiControl:SetShow( true )

	if 0 == tonumber(nodeType) then					-- 연결로
		uiControl:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( uiControl, 1, 253, 20, 272 )
		uiControl:getBaseTexture():setUV( x1, y1, x2, y2 )
		uiControl:setRenderTexture(uiControl:getBaseTexture())
	elseif 1 == tonumber(nodeType) then				-- 마을
		uiControl:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( uiControl, 21, 253, 40, 272 )
		uiControl:getBaseTexture():setUV( x1, y1, x2, y2 )
		uiControl:setRenderTexture(uiControl:getBaseTexture())
	elseif 2 == tonumber(nodeType) then				-- 도시(중심마을)
		uiControl:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( uiControl, 41, 253, 60, 272 )
		uiControl:getBaseTexture():setUV( x1, y1, x2, y2 )
		uiControl:setRenderTexture(uiControl:getBaseTexture())
	elseif 3 == tonumber(nodeType) then				-- 관문
		uiControl:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( uiControl, 61, 253, 80, 272 )
		uiControl:getBaseTexture():setUV( x1, y1, x2, y2 )
		uiControl:setRenderTexture(uiControl:getBaseTexture())
	elseif 5 == tonumber(nodeType) then				-- 무역
		uiControl:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( uiControl, 81, 253, 100, 272 )
		uiControl:getBaseTexture():setUV( x1, y1, x2, y2 )
		uiControl:setRenderTexture(uiControl:getBaseTexture())
	elseif 9 == tonumber(nodeType) then				-- 위험
		uiControl:ChangeTextureInfoName( "new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( uiControl, 101, 253, 120, 272 )
		uiControl:getBaseTexture():setUV( x1, y1, x2, y2 )
		uiControl:setRenderTexture(uiControl:getBaseTexture())
	else
		uiControl:SetShow( false )
	end
end

local SetNodeCountryAndTerritory = function( nodeStaticStatus )
end

local SetWeatherAndNodeTypeIcon = function( nodeKey )
	-- 구름 비율
	local fWeatherCloudRate		= getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CLOUD_RATE, nodeKey)	
	-- 강수량
	local fWeatherRainAmount	= getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_RAIN_AMOUNT, nodeKey)
	-- 기온
	local fWeatherCelsius		= getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CELSIUS, nodeKey)

	local strWeatherCloudRate	= ""	-- 구름 비율 문자열
	local strWeatherRainAmount	= ""	-- 강수량 문자열
	local strWeatherCelsius		= ""	-- 기온 문자열
	
	if( fWeatherCloudRate > 0.6 ) then
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_HIGH" );
	elseif( fWeatherCloudRate > 0.3 ) then
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_MID" );
	else
		strWeatherCloudRate = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_LOW" )
	end	
	
	if( fWeatherRainAmount > 0.6 ) then
		if fWeatherCelsius < 0.0 then
			strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_SNOWAMOUNT_HIGH" );
		else
			strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_HIGH" );
		end
	elseif( fWeatherRainAmount > 0.3 ) then
		if fWeatherCelsius < 0.0 then
			strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_SNOWAMOUNT_MID" );
		else
			strWeatherRainAmount = PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_MID" );
		end
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
	
	local string = "[" .. strWeatherCloudRate .. "/" .. strWeatherRainAmount .. "/" .. strWeatherCelsius .. "]"
	NodeIconArray[IconType.NodeType]:SetText( string )
end


local GenerateNodeInfo = function( nodeStaticStatus, nodeKey, isAffiliated, isMaxLevel )
	FillContryInfo( nodeStaticStatus )		-- 국가 정보
	FillTerritoryInfo( nodeStaticStatus )	-- 영토 정보
	SetWeatherAndNodeTypeIcon( nodeKey )		-- 거점 타입/날씨
	SetNodeType( nodeStaticStatus._nodeType )		-- 거점 타입 텍스쳐

	-- 노드 이름 설정
	Txt_Node_Title:SetText( getExploreNodeName(nodeStaticStatus) );
	
	local nodeManagerName = requestNodeManagerName( nodeKey )
	Txt_NodeManager			:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_MANAGER" ) .. " : " )
	if ( "" ~= nodeManagerName ) then
		-- 노드 관리자
		Txt_NodeManager			:SetShow( true )
		Txt_NodeManager_Name	:SetShow( true )
		SetFontColorAndText( Txt_NodeManager, NodeTextString[NodeTextType.NODE_MANAGER_TITLE], NodeTextColor[NodeTextType.NODE_MANAGER_TITLE] );
		SetFontColorAndText( Txt_NodeManager_Name, nodeManagerName, NodeTextColor[NodeTextType.NODE_MANAGER_TEXT] );
	else
		Txt_NodeManager			:SetShow( false )
		Txt_NodeManager_Name	:SetShow( false )
	end
end

local Align_NodeControls = function()
	local nextSpanY = 115

	if Txt_NodeManager:GetShow() then
		Txt_NodeManager:SetSpanSize( Txt_NodeManager:GetSpanSize().x, nextSpanY )
		nextSpanY = Txt_NodeManager:GetSpanSize().y + Txt_NodeManager:GetSizeY() + 5
	end
	if Txt_NodeManager_Name:GetShow() then
		Txt_NodeManager_Name:SetSpanSize( Txt_NodeManager_Name:GetSpanSize().x, nextSpanY )
		nextSpanY = Txt_NodeManager_Name:GetSpanSize().y + Txt_NodeManager_Name:GetSizeY() + 5
	end

	if Txt_Node_Desc:GetShow() then												-- 거점 설명
		Txt_Node_Desc:SetSpanSize( Txt_Node_Desc:GetSpanSize().x, nextSpanY )
		nextSpanY = Txt_Node_Desc:GetSpanSize().y + Txt_Node_Desc:GetSizeY() + 5
	end
	if Tex_NeedExplorePoint:GetShow() then										-- 공헌도 아이콘
		Tex_NeedExplorePoint:SetSpanSize( Tex_NeedExplorePoint:GetSpanSize().x, nextSpanY + 8 )
		Txt_NeedExplorePoint:SetSpanSize( Txt_NeedExplorePoint:GetSpanSize().x, nextSpanY + 8 )
		nextSpanY = Tex_NeedExplorePoint:GetSpanSize().y + Tex_NeedExplorePoint:GetSizeY() + 5
	end

	if Btn_NodeLink:GetShow() then												-- 공헌도 투자
		Btn_NodeLink:SetSpanSize( Btn_NodeLink:GetSpanSize().x, nextSpanY )
		nextSpanY = Btn_NodeLink:GetSpanSize().y + Btn_NodeLink:GetSizeY() + 5
	end
	if Btn_NodeUnlink:GetShow() then											-- 공헌도 회수
		Btn_NodeUnlink:SetSpanSize( Btn_NodeUnlink:GetSpanSize().x, nextSpanY )
		nextSpanY = Btn_NodeUnlink:GetSpanSize().y + Btn_NodeUnlink:GetSizeY() + 5
	end
	if Btn_NearNode:GetShow() then												-- 연결되는 선행 거점
		Btn_NearNode:SetSpanSize( Btn_NearNode:GetSpanSize().x, nextSpanY )
		nextSpanY = Btn_NearNode:GetSpanSize().y + Btn_NearNode:GetSizeY() + 5
	end

	if NodeLevelGroup.Tex_NodeLevBG:GetShow() then								-- 거점 레벨 BG
		NodeLevelGroup.Tex_NodeLevBG:SetSpanSize( NodeLevelGroup.Tex_NodeLevBG:GetSpanSize().x, nextSpanY )
		nextSpanY = NodeLevelGroup.Tex_NodeLevBG:GetSpanSize().y + 5	-- 내부 정렬을 위해 크기를 더하지 않음.
	end
	if NodeLevelGroup.Txt_NodeLevel:GetShow() then								-- 거점 레벨
		NodeLevelGroup.Txt_NodeLevel:SetSpanSize( NodeLevelGroup.Txt_NodeLevel:GetSpanSize().x, nextSpanY )
		NodeLevelGroup.Tex_ProgressBG:SetSpanSize( NodeLevelGroup.Tex_ProgressBG:GetSpanSize().x, nextSpanY + 7 )			-- 거점 경험치BG
		NodeLevelGroup.Progress_NodeLevel:SetSpanSize( NodeLevelGroup.Progress_NodeLevel:GetSpanSize().x, nextSpanY + 7 )	-- 거점 경험치
		NodeLevelGroup.Btn_NodeLevHelp:SetSpanSize( NodeLevelGroup.Btn_NodeLevHelp:GetSpanSize().x, nextSpanY )				-- 거점 도움말 아이콘

		nextSpanY = NodeLevelGroup.Txt_NodeLevel:GetSpanSize().y + NodeLevelGroup.Txt_NodeLevel:GetSizeY() + 5
	end
	if NodeLevelGroup.Btn_NodeLev:GetShow() then								-- 거점 기운 투자
		NodeLevelGroup.Btn_NodeLev:SetSpanSize( NodeLevelGroup.Btn_NodeLev:GetSpanSize().x, nextSpanY )
		nextSpanY = NodeLevelGroup.Btn_NodeLev:GetSpanSize().y + NodeLevelGroup.Btn_NodeLev:GetSizeY() + 15	-- 파트라인 처리 때문에 추가로 더한다.
	end

	if SelfExplorePointGroup.Tex_Explore_Partline:GetShow() then				-- 현재 공헌도 구분선
		SelfExplorePointGroup.Tex_Explore_Partline:SetSpanSize( SelfExplorePointGroup.Tex_Explore_Partline:GetSpanSize().x, nextSpanY )
		nextSpanY = SelfExplorePointGroup.Tex_Explore_Partline:GetSpanSize().y + SelfExplorePointGroup.Tex_Explore_Partline:GetSizeY() + 5	-- 파트라인 처리 때문에 추가로 더한다.
	end
	if SelfExplorePointGroup.Tex_ExplorePoint_BG:GetShow() then					-- 공헌도 BG
		SelfExplorePointGroup.Tex_ExplorePoint_BG:SetSpanSize( SelfExplorePointGroup.Tex_ExplorePoint_BG:GetSpanSize().x, nextSpanY )
		SelfExplorePointGroup.Tex_ExplorePoint_Icon:SetSpanSize( SelfExplorePointGroup.Tex_ExplorePoint_Icon:GetSpanSize().x, nextSpanY + 8 )
		SelfExplorePointGroup.Txt_ExplorePoint_Value:SetSpanSize( SelfExplorePointGroup.Txt_ExplorePoint_Value:GetSpanSize().x, nextSpanY + 8 )
		SelfExplorePointGroup.Tex_ExplorePoint_PrgressBG:SetSpanSize( SelfExplorePointGroup.Tex_ExplorePoint_PrgressBG:GetSpanSize().x, nextSpanY + 15 )
		SelfExplorePointGroup.Progress_ExplorePoint:SetSpanSize( SelfExplorePointGroup.Progress_ExplorePoint:GetSpanSize().x, nextSpanY + 15 )
		SelfExplorePointGroup.Btn_ExplorePoint_Help:SetSpanSize( SelfExplorePointGroup.Btn_ExplorePoint_Help:GetSpanSize().x, nextSpanY + 8 )

		nextSpanY = SelfExplorePointGroup.Tex_ExplorePoint_BG:GetSpanSize().y + SelfExplorePointGroup.Tex_ExplorePoint_BG:GetSizeY() + 5
	end

	static_NodeManagerBG:SetSize( static_NodeManagerBG:GetSizeX(), nextSpanY )
end

local update_ExplorePoint = function()
	local territoryKeyRaw 	= getDefaultTerritoryKey()
	local explorePoint		= getExplorePointByTerritoryRaw( territoryKeyRaw )
	local cont_expRate		= Int64toInt32(explorePoint:getExperience_s64()) / Int64toInt32(getRequireExplorationExperience_s64()) 
	SelfExplorePointGroup.Txt_ExplorePoint_Value	:SetText( tostring(explorePoint:getRemainedPoint()) .." / " .. tostring(explorePoint:getAquiredPoint()) )
	SelfExplorePointGroup.Progress_ExplorePoint		:SetProgressRate( cont_expRate * 100 )
end

local function FillNodeInfo( nodeStaticStatus, nodeKey, isAffiliated, isMaxLevel )	
	GenerateNodeInfo( nodeStaticStatus, nodeKey, isAffiliated, isMaxLevel )
	NodeLevelGroup:SetShow( false );

	savedisMaxLevel = isMaxLevel

	Txt_Node_Desc:SetAutoResize(true);
	Txt_Node_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap );
	Txt_Node_Desc:SetShow(false);

	local recipeItems	= getPlantInvestItemList(nodeStaticStatus)
	local needPoint		= getPlantNeedPoint()
	local supportPoint	= getPlantNeedSupportPoint()
	local needMoney		= getPlantNeedMoney()
	if( isExploreUpgradable( nodeKey ) ) then -- 노드가 연결이 되었거나, 투자가 이미 되었다.	
			NodeLevelGroup:SetNodeLevel( nodeKey );
		if (isMaxLevel == false ) then -- 투자가 되지 않았다.
			FillExploreUpgradeAble( nodeStaticStatus, nodeKey )
			Tex_NeedExplorePoint:SetShow( true )
			Txt_NeedExplorePoint:SetShow( true )
		else
			NodeLevelGroup:SetShow( true );
			Tex_NeedExplorePoint:SetShow( false )
			Txt_NeedExplorePoint:SetShow( false )
			if ( isWithdrawablePlant(nodeKey) ) then
		 		Txt_Node_Desc:SetShow(false);
				Btn_NodeUnlink:SetShow(true)
				Btn_NodeUnlink:addInputEvent("Mouse_LUp",	"OnNodeWithdrawClick( " .. tostring(nodeKey) .. ")")
			elseif ( needPoint > 0 or supportPoint > 0 or needMoney > 0 or recipeItems > 0 )then				
				if ( workerManager_CheckWorkingOtherChannel() ) then
					SetFontColorAndText( Txt_Node_Desc, workerManager_getWorkingOtherChannelMsg(), NodeTextColor[NodeTextType.NODE_UNWITHDRAW_TEXT] );
				else
					SetFontColorAndText( Txt_Node_Desc, PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTWITHDRAW" ), NodeTextColor[NodeTextType.NODE_UNWITHDRAW_TEXT] )
				end
				Txt_Node_Desc:SetShow(true)
			end
		end
	else		
		if ( true == nodeStaticStatus._isMainNode ) then
			SetFontColorAndText( Txt_Node_Desc, PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE" ), NodeTextColor[NodeTextType.NODE_UNUPGRADE_TEXT] )
			Btn_NearNode:SetShow(true);
			Btn_NearNode:addInputEvent("Mouse_LUp",	"OnNearNodeClick(" .. tostring(nodeKey) .. ")")
			Tex_NeedExplorePoint:SetShow( false )
			Txt_NeedExplorePoint:SetShow( false )
		elseif ( false == nodeStaticStatus._isMainNode ) then
			SetFontColorAndText( Txt_Node_Desc, PAGetString( Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE_SUB" ), NodeTextColor[NodeTextType.NODE_UNUPGRADE_TEXT] )
		end
		
		Txt_Node_Desc:SetShow(true)
	end

	--local regionInfo = nodeStaticStatus:getStaticStatus():getRegion() -- regionInfo를 가져온다
	--local regionKey = regionInfo._regionKey -- 리전 키 
	--local taxRate = regionInfo:getDropGroupRerollCountOfSieger() -- tax
	--SiegeWrapper ToClient_GetSiegeWrapperByRegionKey(regionKey) -- SiegeWrapper

	-- 공헌도 업데이트
	update_ExplorePoint()

	-- 컨트롤 위치 조정
	Align_NodeControls()
end


function WorldMap_ItemMarket_Open( territoryKeyRaw )
	FGlobal_ItemMarket_Open_ForWorldMap( territoryKeyRaw )
end


--[[
	@date	2014/07/02
	@author	최대호
	@brief	정보를 초기화 한다
]]--
local function ClearNodeInfo()
	Btn_NodeLink:SetShow(false);
	Btn_NodeUnlink:SetShow(false);
	Btn_NearNode:SetShow(false);
	NodeLevelGroup.Btn_NodeLev:SetShow(false);
end


------------------------------------------------------------------
-- NodeLevel 구간
function NodeLevelGroup:SetNodeLevel( nodeKey )
	local nodeLv		= ToClient_GetNodeLevel( nodeKey )
	local nodeExp		= Int64toInt32(ToClient_GetNodeExperience_s64 ( nodeKey ))
	local nodeExpMax	= Int64toInt32(ToClient_GetNeedExperienceToNextNodeLevel_s64( nodeKey ))
	local nodeExpPercent= (nodeExp/nodeExpMax) * 100
	self.Txt_NodeLevel:SetText( "Lv. " .. tostring( nodeLv) )
		
	if isProgressReset then
		self.Progress_NodeLevel:SetProgressRate(0.0)
		isProgressReset = false
	else
		self.Progress_NodeLevel:SetProgressRate( nodeExpPercent )
	end
end

function NodeLevelGroup:SetShow( isShow )
	self.Tex_NodeLevBG		:SetShow( isShow )		
    self.Btn_NodeLev		:SetShow( isShow )
    self.Txt_NodeLevel		:SetShow( isShow )
    self.Tex_ProgressBG		:SetShow( isShow )
    self.Progress_NodeLevel	:SetShow( isShow )
    self.Btn_NodeLevHelp	:SetShow( isShow )	

end
---------------------------------------------------------------------------------------------------------
--[[ Panel_NodeMenu 전역 함수 ]]--

function  FGlobal_ShowInfoNodeMenuPanel( node )
	if(	false == ToClient_WorldMapIsShow() ) then
		return
	end

	local plantKey				= node:getPlantKey()
	_wayPointKey 				= plantKey:getWaypointKey();
	--	local nodeKey				= plantKey:getWaypointKey()
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
	Panel_NodeMenu:SetPosY( 5 );
	ClearNodeInfo()

	FillNodeInfo(node:getStaticStatus(), _wayPointKey, _wayPointKey == affiliatedTownKey, node:isMaxLevel() )
	--	Align_NodeMenuControl( node:getStaticStatus(), node )
	FGlobal_nodeOwnerInfo_SetInfo( node:getStaticStatus() )	-- 거점 소유 정보 업데이트
	NodeLevelGroup.Btn_NodeLev:addInputEvent("Mouse_LUp", "ToClient_RequestIncreaseExperienceNode( ".. _wayPointKey ..", 10 )")

	-- TownMode
	FromClient_WorldMap_HouseNaviShow()
	-- Panel_NodeName
	FGlobal_SetNodeName(getExploreNodeName(nodeStaticStatus))

	-- 좌측 공헌도를 갱신한다.
	if isWorldMapGrandOpen() then
		FGlobal_WorldMapGrand_NodeExplorePoint_Update()
		FGlobal_WorldmapGrand_Main_UpdateExplorePoint()
	end
end

function FGlobal_CloseNodeMenu()
	ClearNodeInfo()
	Panel_NodeMenu:SetShow(false)
	-- FGlobal_WorldMapWindowEscape()
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


local buildingActorKey	= nil
function FGlobal_ShowBuildingInfo( nodeBtn )
	buildingActorKey 	= nodeBtn:ToClient_getActorKey();
	local buildingSS	= ToClient_getBuildingInfo( buildingActorKey ); 

	if( nil == buildingSS ) then
		return;
	end

	local workableCount = ToClient_getBuildingWorkableListCount( buildingSS );
	
	if( 0 < workableCount ) then
		FGlobal_OnClickBuildingManage()
	end
end

function FGlobal_OnClickBuildingManage()
	local buildingSS	= ToClient_getBuildingInfo( buildingActorKey ); 

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
	NodeLevelGroup:SetNodeLevel( WaypointKey );
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

		if minorSiegeWrapper:isSiegeBeing() then	-- 점령전 중이다.
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
	if	301		== wayPointKey	or			-- 하이델
		1		== wayPointKey	or			-- 벨리아
		601		== wayPointKey	or			-- 칼페온
		1101	== wayPointKey	or			-- 알티노바
		1301	== wayPointKey	then		-- 수도 발렌시아
		tradeIcon:SetSpanSize( -10, 20 )

		tradeIcon:SetShow(true);
		nodeBtnArray[wayPointKey] = nodeBtn;
		tradeIcon:addInputEvent("Mouse_LUp", 	"FGlobal_handleOpenItemMarket(" ..territoryKeyRaw..")" );
		tradeIcon:addInputEvent("Mouse_On",		"CreateNodeIconForTradeIcon_ShowTooltip(" .. wayPointKey ..", true )" );
		tradeIcon:addInputEvent("Mouse_Out",	"CreateNodeIconForTradeIcon_ShowTooltip(" .. wayPointKey ..", false )" );
	end
end

function FGlobal_handleOpenItemMarket( territoryKey )
	FGlobal_ItemMarket_Open_ForWorldMap(1)	
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

function FGlobal_LoadWorldMap_WarehouseOpen()
	if nil ~= _wayPointKey then
		local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint( _wayPointKey )
		if ( nil ~= regionInfoWrapper ) and ( regionInfoWrapper:get():isMainOrMinorTown() ) then
			if ( regionInfoWrapper:get():hasWareHouseNpc() ) then
				-- 창고를 연다
				Warehouse_OpenPanelFromWorldmap(_wayPointKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap )
			end
		end
	end
end

function FGlobal_WorldMapGrand_NodeExplorePoint_Update()
	update_ExplorePoint()
end


function HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( isShow, buttonType )
	if isShow then
		local control	= nil
		local name		= ""
		local desc		= nil

		if 0 == buttonType then
			control	= NodeLevelGroup.Btn_NodeLevHelp
			name	= PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_NODELEVEL" )	-- "거점 투자 레벨"
		else
			control	= SelfExplorePointGroup.Btn_ExplorePoint_Help
			name	= PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_EXPLORERPOINT" )	-- "보유 공헌도"
		end

		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function nodeMenu_OnScreenResize()
	Panel_NodeMenu:SetSize( getScreenSizeX(), getScreenSizeY() )
end

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
registerEvent("onScreenResize",										"nodeMenu_OnScreenResize" )


nodeMenu_init()
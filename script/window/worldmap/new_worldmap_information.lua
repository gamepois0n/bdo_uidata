--------------------------------------------
--				메뉴판들
local infoDescTitle	        = UI.getChildControl( Panel_Worldmap_Information, "StaticText_InfoDesc_Title");
local infoDescBG            = UI.getChildControl( Panel_Worldmap_Information, "Static_InfoDesc_BG");
local infoDesc              = UI.getChildControl( Panel_Worldmap_Information, "StaticText_InfoDesc");

local waterGraph	        = UI.getChildControl( Panel_Worldmap_Information, "Static_Graph_0");
local temperatureGraph	    = UI.getChildControl( Panel_Worldmap_Information, "Static_Graph_1");
local humidityGraph	        = UI.getChildControl( Panel_Worldmap_Information, "Static_Graph_2");

local gaugeWater		    = UI.getChildControl( Panel_Worldmap_Information, "Static_Gauge_Water");
local gaugeTemper	        = UI.getChildControl( Panel_Worldmap_Information, "Static_Gauge_Temperature");
local gagueHumidity         = UI.getChildControl( Panel_Worldmap_Information, "Static_Gauge_Humidity");

local txtLow	            = UI.getChildControl( Panel_Worldmap_Information, "StaticText_Low");
local txtHigh               = UI.getChildControl( Panel_Worldmap_Information, "StaticText_High");


local infoCity              = UI.getChildControl( Panel_Worldmap_Information, "StaticText_Info_Node_City");
local infoVillage           = UI.getChildControl( Panel_Worldmap_Information, "StaticText_Info_Node_Village");
local infoGate              = UI.getChildControl( Panel_Worldmap_Information, "StaticText_Info_Node_Gate");
local infoTrade             = UI.getChildControl( Panel_Worldmap_Information, "StaticText_Info_Node_Trade");
local infoDangerous         = UI.getChildControl( Panel_Worldmap_Information, "StaticText_Info_Node_Dangerous");
local infoEmpty             = UI.getChildControl( Panel_Worldmap_Information, "StaticText_Info_Node_Empty");

------------------------------------------------------------------------------------------------
-- 위치 잡기 위해 WorldMap Panel 정보를 가져옴
local worldMapPanelBG 		= UI.getChildControl( Panel_WorldMap, "Static_ButtonBG");

local WORLDMAP_RENDERTYPE  = CppEnums.WorldMapState
------------------------------------------------------------------
--초기화 코드
infoDesc:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
infoDesc:SetAutoResize( true )

function FromClient_InfomationInitialize( infomationUI )		
--[[
	informationBG		= infomationUI:FromClient_getInfomationBG();
	infoDescTitle		= infomationUI:FromClient_getInfomationTitle();
	infoDescTitle		:SetSpanSize(0, 30)
	infoDescBG			=infomationUI:FromClient_getInfomationDescBG();
	infoDescBG			:SetSpanSize(7, 36)
	infoDesc			= infomationUI:FromClient_getInfomationDesc()
	infoDesc			:SetSpanSize(14, 39)
	
	waterGraph 			= infomationUI:FromClient_getWaterGraph() 
	waterGraph  		:SetSpanSize(15, 90)
	temperatureGraph	= infomationUI:FromClient_getTemperatureGraph( )
	temperatureGraph	:SetSpanSize(15, 90)
	humidityGraph		= infomationUI:FromClient_getHumidityGraph( )
	humidityGraph		:SetSpanSize(15, 90)
	
	gaugeWater			=infomationUI:FromClient_getGaugeWater( )
	gaugeWater			:SetSpanSize(35, 90)
	gaugeTemper			= infomationUI:FromClient_getGaugeTemperature( )
	gaugeTemper			:SetSpanSize(35, 90)
	gagueHumidity		= infomationUI:FromClient_getGaugeHumidity( )
	gagueHumidity		:SetSpanSize(35, 90)
	
	txtLow				= infomationUI:FromClient_getLow( )
	txtLow				:SetSpanSize(10, 98)
	txtHigh				= infomationUI:FromClient_getHigh( )
	txtHigh				:SetSpanSize(140, 98)
	
	infoCity 			=infomationUI:FromClient_getInfoCity( )
	infoCity 			:SetSpanSize(12, 0)
	infoVillage			=infomationUI:FromClient_getInfoVillage( )
	infoVillage			:SetSpanSize(100, 0)
	infoGate			=infomationUI:FromClient_getInfoGate( )
	infoGate			:SetSpanSize(12, 24)
	infoTrade			=infomationUI:FromClient_getInfoTrade( )
	infoTrade			:SetSpanSize(100, 24)
	infoDangerous		= infomationUI:FromClient_getInfoDangerous( )
	infoDangerous		:SetSpanSize(12, 48)
	infoEmpty			= infomationUI:FromClient_getInfoInterconnection( )
	infoEmpty			:SetSpanSize(100, 48)
]]--
	FromClient_RenderStateInformationChange( WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT )
end

function FromClient_RenderStateInformationChange( state )
	Panel_Worldmap_Information:SetPosX( worldMapPanelBG:GetSizeX() * 1.05 )
	Panel_Worldmap_Information:SetPosY( worldMapPanelBG:GetPosY() )
	local gapY = 0;

	if( WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT == state ) then
		gapY = 0;
		gaugeWater:SetShow( false )
		gaugeTemper:SetShow( false )
		gagueHumidity:SetShow( false )
		txtLow:SetShow( false )
		txtHigh:SetShow( false )
		waterGraph:SetShow( false )
		temperatureGraph:SetShow( false )
		humidityGraph:SetShow( false )
		infoCity:SetShow( true )
		infoVillage:SetShow( true )
		infoGate:SetShow( true )
		infoTrade:SetShow( true )
		infoDangerous:SetShow( true )
		infoEmpty:SetShow( true )
		
		infoDescTitle	:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_TITLE_0" ) )
		--infoDesc		:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_INFO_0" ) )	-- 플레이어가 탐험한 지역과 노드의 정보, 퀘스트 정보가 표시된다
		infoDesc		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_INFOMATION_INFODESC") ) -- "탐험한 지역과 거점, 의뢰 및 지식 정보가 표시됩니다." )
		infoDesc		:SetSize( infoDesc:GetSizeX(), infoDesc:GetSizeY() )
		infoDescBG		:SetSize( infoDescBG:GetSizeX(), infoDesc:GetSizeY() + 10 )
		gapY = infoDescBG:GetSpanSize().y + infoDescBG:GetSizeY() + 15
		
		infoCity 		:SetSpanSize( infoCity:GetSpanSize().x, gapY)
		infoVillage 	:SetSpanSize( infoVillage:GetSpanSize().x, gapY)
		infoGate 		:SetSpanSize( infoGate:GetSpanSize().x, gapY + 30)
		infoTrade 		:SetSpanSize( infoTrade:GetSpanSize().x, gapY + 30)
		infoDangerous 	:SetSpanSize( infoDangerous:GetSpanSize().x, gapY + 60)
		infoEmpty 		:SetSpanSize( infoEmpty:GetSpanSize().x, gapY + 60)		
		
		gapY = infoEmpty:GetSpanSize().y + infoEmpty:GetSizeY()
		Panel_Worldmap_Information:SetSize( Panel_Worldmap_Information:GetSizeX(), gapY + 5 )			
		Panel_Worldmap_Information:SetShow(true);

	elseif( WORLDMAP_RENDERTYPE.eWMS_REGION == state ) then
		gapY = 0
		gaugeWater:SetShow( false )
		gaugeTemper:SetShow( false )
		gagueHumidity:SetShow( false )
		txtLow:SetShow( false )
		txtHigh:SetShow( false )
		waterGraph:SetShow( true )
		temperatureGraph:SetShow( true )
		humidityGraph:SetShow( true )
		infoCity:SetShow( false )
		infoGate:SetShow( false )
		infoVillage:SetShow( false )
		infoTrade:SetShow( false )
		infoDangerous:SetShow( false )
		infoEmpty:SetShow( false )
		
		infoDescTitle	:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_TITLE_1" ) )
		infoDesc:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_INFO_1" ) )	-- 각 영지 지역별 자원 및 민심의 정보가 그래프로 표시된다
		infoDesc:SetSize( infoDesc:GetSizeX(), infoDesc:GetSizeY() )
		infoDescBG:SetSize( infoDescBG:GetSizeX(), infoDesc:GetSizeY() + 10 )
		
		gapY = infoDescBG:GetSpanSize().y + infoDescBG:GetSizeY()
				
		waterGraph:SetSpanSize( waterGraph:GetSpanSize().x, gapY + 10 )
		gapY = gapY + 10 + waterGraph:GetSizeY()
		
		temperatureGraph:SetSpanSize( temperatureGraph:GetSpanSize().x, gapY + 10 )
		gapY = gapY + 10 + temperatureGraph:GetSizeY()
		
		humidityGraph:SetSpanSize( humidityGraph:GetSpanSize().x, gapY + 10 )
		gapY = gapY + 10 + humidityGraph:GetSizeY()
		
		Panel_Worldmap_Information:SetSize( Panel_Worldmap_Information:GetSizeX(), gapY + 5)
		Panel_Worldmap_Information:SetShow(true);

	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_WATER == state ) then
		gapY = 0
		gaugeWater:SetShow( true )
		gaugeTemper:SetShow( false )
		gagueHumidity:SetShow( false )
		txtLow:SetShow( true )
		txtHigh:SetShow( true )
		waterGraph:SetShow( false )
		temperatureGraph:SetShow( false )
		humidityGraph:SetShow( false )
		infoCity:SetShow( false )
		infoGate:SetShow( false )
		infoVillage:SetShow( false )
		infoTrade:SetShow( false )
		infoDangerous:SetShow( false )
		infoEmpty:SetShow( false )
		
		infoDescTitle	:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_TITLE_2" ) )
		infoDesc:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_INFO_2" ) )	-- 땅 밑에 매장되어 있는 지하수량의 범위를 표시한다
		infoDesc:SetSize( infoDesc:GetSizeX(), infoDesc:GetSizeY() )
		infoDescBG:SetSize( infoDescBG:GetSizeX(), infoDesc:GetSizeY() + 10 )
		
		gapY = infoDescBG:GetSpanSize().y + infoDescBG:GetSizeY()
				
		gaugeWater:SetSpanSize( gaugeWater:GetSpanSize().x, gapY + 7 )
			gapY = gapY + 7 + gaugeWater:GetSizeY()
		txtLow:SetSpanSize( txtLow:GetSpanSize().x, gapY + 2 )
		txtHigh:SetSpanSize( txtHigh:GetSpanSize().x, gapY + 2 )
		
		gapY = gapY + 2 + txtLow:GetSizeY()
		Panel_Worldmap_Information:SetSize( Panel_Worldmap_Information:GetSizeX(), gapY + 5 )
		Panel_Worldmap_Information:SetShow(true);

	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_CELCIUS == state ) then
		gapY = 0
		gaugeWater:SetShow( false )
		gaugeTemper:SetShow( true )
		gagueHumidity:SetShow( false )
		txtLow:SetShow( true )
		txtHigh:SetShow( true )
		waterGraph:SetShow( false )
		temperatureGraph:SetShow( false )
		humidityGraph:SetShow( false )
		infoCity:SetShow( false )
		infoGate:SetShow( false )
		infoVillage:SetShow( false )
		infoTrade:SetShow( false )
		infoDangerous:SetShow( false )
		infoEmpty:SetShow( false )
		
		infoDescTitle	:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_TITLE_3" ) )
		infoDesc:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_INFO_3" ) )	-- 각 지역의 온도차를 범위화 하여 표시한다
		infoDesc:SetSize( infoDesc:GetSizeX(), infoDesc:GetSizeY() )
		infoDescBG:SetSize( infoDescBG:GetSizeX(), infoDesc:GetSizeY() + 10 )
			gapY = infoDescBG:GetSpanSize().y + infoDescBG:GetSizeY()
				
		gaugeTemper:SetSpanSize( gaugeTemper:GetSpanSize().x, gapY + 7 )
			gapY = gapY + 7 + gaugeTemper:GetSizeY()
		txtLow:SetSpanSize( txtLow:GetSpanSize().x, gapY + 2 )
		txtHigh:SetSpanSize( txtHigh:GetSpanSize().x, gapY + 2 )
			gapY = gapY + 2 + txtLow:GetSizeY()
		Panel_Worldmap_Information:SetSize( Panel_Worldmap_Information:GetSizeX(), gapY + 5)
		Panel_Worldmap_Information:SetShow(true);

	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_HUMIDITY == state ) then
		gapY = 0
		gaugeWater:SetShow( false )
		gaugeTemper:SetShow( false )
		gagueHumidity:SetShow( true )
		txtLow:SetShow( true )
		txtHigh:SetShow( true )
		waterGraph:SetShow( false )
		temperatureGraph:SetShow( false )
		humidityGraph:SetShow( false )
		infoCity:SetShow( false )
		infoGate:SetShow( false )
		infoVillage:SetShow( false )
		infoTrade:SetShow( false )
		infoDangerous:SetShow( false )
		infoEmpty:SetShow( false )
		
		infoDescTitle	:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_TITLE_4" ) )
		infoDesc:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_MENU_INFO_4" ) )	-- 각 지역의 온도차를 범위화 하여 표시한다
		infoDesc:SetSize( infoDesc:GetSizeX(), infoDesc:GetSizeY() )
		infoDescBG:SetSize( infoDescBG:GetSizeX(), infoDesc:GetSizeY() + 10 )
			gapY = infoDescBG:GetSpanSize().y + infoDescBG:GetSizeY()
				
		gagueHumidity:SetSpanSize( gagueHumidity:GetSpanSize().x, gapY + 7 )
		gapY = gapY + 7 + gagueHumidity:GetSizeY()
		txtLow:SetSpanSize( txtLow:GetSpanSize().x, gapY + 2 )
		txtHigh:SetSpanSize( txtHigh:GetSpanSize().x, gapY + 2 )
		gapY = gapY + 2 + txtLow:GetSizeY()
		Panel_Worldmap_Information:SetSize( Panel_Worldmap_Information:GetSizeX(), gapY + 5)
		Panel_Worldmap_Information:SetShow(true);
	end

	-- WORLDMAP_NODE_POSITION.x = Panel_Worldmap_Information:GetPosX();
	-- WORLDMAP_NODE_POSITION.y = Panel_Worldmap_Information:GetPosY() + Panel_Worldmap_Information:GetSizeX();
end


registerEvent("FromClient_WorldMapOpen", "FromClient_InfomationInitialize")
registerEvent("FromClient_RenderStateChange", "FromClient_RenderStateInformationChange")

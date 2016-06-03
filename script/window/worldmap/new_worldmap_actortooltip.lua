local UI_Class		= CppEnums.ClassType

local nodeIconName			= UI.getChildControl( Panel_WorldMap_Tooltip, "StaticText_IconName") ;
local nodeResultIconName	= UI.getChildControl( Panel_WorldMap_Tooltip, "StaticText_IconName_ResultName");
local nodeResultIconBG		= UI.getChildControl( Panel_WorldMap_Tooltip, "StaticText_IconName_ResultIconBG");
local nodeResultIcon		= UI.getChildControl( Panel_WorldMap_Tooltip, "StaticText_IconName_ResultIcon");
local nodeHelpBG			= UI.getChildControl( Panel_WorldMap_Tooltip, "StaticText_NodeIconHelp_BG");
local nodeHelpMouseL		= UI.getChildControl( Panel_WorldMap_Tooltip, "Static_Help_MouseL");
local nodeHelpMouseR		= UI.getChildControl( Panel_WorldMap_Tooltip, "Static_Help_MouseR");
local partyMemberName		= UI.getChildControl( Panel_WorldMap_PartyMemberTooltip, "StaticText_PartyMemberName")
local partyMemberClassIconBG= UI.getChildControl( Panel_WorldMap_PartyMemberTooltip, "Static_PartyClassIconBG")
local partyMemberClassIcon	= UI.getChildControl( Panel_WorldMap_PartyMemberTooltip, "Static_PartyClassIcon")
local partyMemberLevel		= UI.getChildControl( Panel_WorldMap_PartyMemberTooltip, "StaticText_PartyLevel")

local villageWar = {
	title				= UI.getChildControl( Panel_NodeSiegeTooltip, "StaticText_GuildWarTitle"),
	guildMarkBg			= UI.getChildControl( Panel_NodeSiegeTooltip, "Static_GuildMarkBG"),
	guildMark			= UI.getChildControl( Panel_NodeSiegeTooltip, "Static_GuildMark"),
	guildName			= UI.getChildControl( Panel_NodeSiegeTooltip, "StaticText_GuildName"),
	guildMasterName		= UI.getChildControl( Panel_NodeSiegeTooltip, "StaticText_GuildMaster"),
	guildOption			= UI.getChildControl( Panel_NodeSiegeTooltip, "StaticText_Benefits"),
	nodeState			= UI.getChildControl( Panel_NodeSiegeTooltip, "StaticText_NodeState"),
	nodeStateDesc		= UI.getChildControl( Panel_NodeSiegeTooltip, "StaticText_StateDesc"),
	nodeWarJoinCount	= UI.getChildControl( Panel_NodeSiegeTooltip, "MultilineText_JoinNodeWarCount"),
}

---------------------------------------------------------------------------------------------------------
--  초기화
--------------------------------------------------------------------------------------------------------
local tooltipHide = function()
	nodeIconName			:SetShow( false )
	nodeResultIconName		:SetShow( false )
	nodeResultIconBG		:SetShow( false )
	nodeResultIcon			:SetShow( false )
	nodeHelpBG				:SetShow( false )
	nodeHelpMouseL			:SetShow( false )
	nodeHelpMouseR			:SetShow( false )
	partyMemberName			:SetShow( false )
	partyMemberClassIcon	:SetShow( false )
	partyMemberClassIconBG	:SetShow( false )
	partyMemberLevel		:SetShow( false )
end

local sizeGap = 10;
-- 공통 옵션 --
function FromClient_WorldmapIconTooltipInit( commonOverUI )
		--[[
	overUI = commonOverUI:FromClient_getNodeNameBG();
	nodeIconName = commonOverUI:FromClient_getNodeIconName();
	nodeResultIconName = commonOverUI:FromClient_getNodeResultIconName();
	nodeResultIconBG = commonOverUI:FromClient_getNodeResultIconBG();
	nodeResultIcon = commonOverUI:FromClient_getNodeResultIcon();
	nodeHelpBG 	   = commonOverUI:FromClient_getNodeHelpBG();
	nodeHelpMouseL = commonOverUI:FromClient_getNodeHelpMouseL();
	nodeHelpMouseR = commonOverUI:FromClient_getNodeHelpMouseR();
]]--
	nodeIconName:SetAutoResize();
	nodeResultIconName:SetAutoResize();
end

function FGlobal_ClearWorldmapIconTooltip()
	Panel_WorldMap_Tooltip:SetShow(false);
	Panel_WorldMap_PartyMemberTooltip:SetShow( false )
	nodeIconName:SetShow(false);
	nodeResultIconName:SetShow(false);
	nodeResultIconBG:SetShow(false);
	nodeResultIcon:SetShow(false);
	nodeHelpBG:SetShow(false);
	nodeHelpMouseL:SetShow(false);
	nodeHelpMouseR:SetShow(false);
end
--[[ 노드 메뉴 툴팁 ]]--
local On_waypointKey = nil
function FromClient_OnWorldMapNode( nodeBtn )
	tooltipHide()

	FGlobal_ClearWorldmapIconTooltip()
	local nodeInfo 			= nodeBtn:FromClient_getExplorationNodeInClient()
	local plantKey 			= nodeInfo:getPlantKey()
	local exploreLevel		= nodeInfo:getLevel()
	local plant				= getPlant(plantKey)

	local waypointKey 		= plantKey:getWaypointKey()
	On_plantKey				= waypointKey
	local houseCountObject 	= ToClient_getHouseCountObject( waypointKey );
	
	local regionInfo = ToClient_getRegionInfoWrapperByWaypoint(waypointKey);
	if (regionInfo ~= nil) then
		ToClient_createBuildingLineInVillageSiege( regionInfo:getRegionKey() );
	end
	
	local nodeName = "";

	nodeName = ToClient_getNodeName( nodeInfo );

	local nodeNameOri = nodeName
	
	if( nil ~= houseCountObject ) then
		nodeName = nodeName .. "<PAColor0xFFe6e0c6> (" .. houseCountObject:getCurrentCount() .."/" .. houseCountObject:getMaxCount() ..")<PAOldColor>";
	end
	
	local nodeX = nodeBtn:GetPosX();
	local nodeY = nodeBtn:GetPosY();
	local sizeX = nodeBtn:GetSizeX();
	local sizeY = nodeBtn:GetSizeY();

	nodeIconName:SetText( nodeName );

	local tooltipSizeX = nodeIconName:GetPosX() + nodeIconName:GetTextSizeX();
	local tooltipSizeY = nodeIconName:GetPosY() + nodeIconName:GetSizeY();
	if exploreLevel > -1 and plant ~= nil and plant:getType() == CppEnums.PlantType.ePlantType_Zone then
		local workCnt = ToClinet_getPlantWorkListCount(waypointKey, 0)

		if( 0 < workCnt ) then
			local itemSS = ToClient_getPlantWorkableItemExchangeByIndex( plantKey, 0 );
			local itemStatic = itemSS:getFirstDropGroup():getItemStaticStatus();

			local workName = getItemName( itemStatic );
			local itemPath = "icon/"..getItemIconPath( itemStatic );

			nodeResultIconName:SetText( workName );
			nodeResultIcon:ChangeTextureInfoName( itemPath );

			nodeResultIconName:SetShow( true );
			nodeResultIcon:SetShow(true);
			nodeResultIconBG:SetShow(true);
			
			local totalSizeX = nodeResultIconName:GetPosX() + nodeResultIconName:GetTextSizeX();
			local totalSizeY = nodeResultIconName:GetPosY() + nodeResultIconName:GetSizeY();

			--	nodeResultIconBG:SetSize( totalSizeX, totalSizeY );

			if( tooltipSizeX < totalSizeX ) then
				tooltipSizeX = totalSizeX;
			end

			if( tooltipSizeY < totalSizeY ) then
				tooltipSizeY = totalSizeY;
			end
		end
	end
	Panel_WorldMap_Tooltip:SetSize( tooltipSizeX + sizeGap, tooltipSizeY + sizeGap );

	local overUISizeX = Panel_WorldMap_Tooltip:GetSizeX()
	local overUIPosX = nodeX + ( sizeX - overUISizeX ) / 2;
	local overUIPosY = nodeY -  Panel_WorldMap_Tooltip:GetSizeY() - sizeGap;

	if( overUIPosX + overUISizeX > getScreenSizeX() ) then
		overUIPosX = getScreenSizeX() - overUISizeX;
	end

	Panel_WorldMap_Tooltip:SetPosX( overUIPosX );
	Panel_WorldMap_Tooltip:SetPosY( overUIPosY ); 

	Panel_WorldMap_Tooltip:SetShow( true );
	nodeIconName:SetShow(true);

	-- 노드 오버시 마우스 툴팁 노출
	nodeHelpBG:SetShow( true )
	nodeHelpMouseL:SetShow( true )
	nodeHelpMouseR:SetShow( true )
	nodeHelpBG:SetPosX( nodeBtn:GetSizeX() )
	nodeHelpBG:SetPosY( nodeBtn:GetSizeY() )
	nodeHelpMouseL:SetPosX( nodeHelpBG:GetPosX() )
	nodeHelpMouseL:SetPosY( nodeHelpBG:GetPosY() + 2 ) 
	nodeHelpMouseR:SetPosX( nodeHelpBG:GetPosX() )
	nodeHelpMouseR:SetPosY( nodeHelpMouseL:GetPosY() + nodeHelpMouseL:GetSizeY() + 2 )
	local txtSizeMouseL = nodeHelpMouseL:GetTextSizeX()
	local txtSizeMouseR = nodeHelpMouseR:GetTextSizeX()
	if txtSizeMouseL < txtSizeMouseR then
		nodeHelpBG:SetSize( txtSizeMouseR+35, 68 )
	else
		nodeHelpBG:SetSize( txtSizeMouseL+35, 68 )
	end

	-- { 거점점령 정보
		local nodeStaticStatus	= nodeInfo:getStaticStatus()
		local regionInfo		= nodeStaticStatus:getMinorSiegeRegion() -- regionInfo를 가져온다
		if nil ~= regionInfo then
			local regionKey			= regionInfo._regionKey -- 리전 키
			local regionWrapper 	= getRegionInfoWrapper( regionKey:get() )
			local minorSiegeWrapper	= regionWrapper:getMinorSiegeWrapper()
			local siegeWrapper		= ToClient_GetSiegeWrapperByRegionKey( regionKey:get() ) -- SiegeWrapper

			villageWar.title:SetText( nodeNameOri )


			if minorSiegeWrapper:isSiegeBeing() then	-- 점령전 중이다.
				local siegeTentCount = ToClient_GetCompleteSiegeTentCount( regionKey:get() )

				villageWar.guildMarkBg		:SetShow( false )
				villageWar.guildMark		:SetShow( false )
				villageWar.guildName		:SetShow( false )
				villageWar.guildMasterName	:SetShow( false )
				villageWar.guildOption		:SetShow( false )
				villageWar.guildMasterName	:SetText( "" )
				villageWar.guildName		:SetText( "" )
				villageWar.guildMasterName	:SetText( "")

				villageWar.nodeState		:SetShow( true )
				villageWar.nodeStateDesc	:SetShow( true )
				villageWar.nodeWarJoinCount	:SetShow( false )

				villageWar.nodeState:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MINUSIEGETOOLTIP_ISBEIGN" )  )
				-- "거점전 진행중"
				local minorSiegeDoing	= ToClient_doMinorSiegeInTerritory( regionWrapper:getTerritoryKeyRaw() )
				-- local isMainChannel		= getCurrentChannelServerData()._isMain
				if minorSiegeDoing then
					villageWar.nodeStateDesc:SetShow( true )
				else
					villageWar.nodeStateDesc:SetShow( false )
				end
				villageWar.nodeStateDesc:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MINUSIEGETOOLTIP_JOINGUILD", "count", siegeTentCount ) )
			else
				if true == siegeWrapper:doOccupantExist() then	-- 점령중인 길드가 있나?
					-- { 길드마크/길드명
						villageWar.guildMarkBg	:SetShow( true )
						villageWar.guildMark	:SetShow( true )
						villageWar.guildName	:SetShow( true )
						if ( false == isSet ) then
							villageWar.guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
							local x1, y1, x2, y2 = setTextureUV_Func( villageWar.guildMark, 183, 1, 188, 6 )
							villageWar.guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
						else
							villageWar.guildMark:getBaseTexture():setUV(  0, 0, 1, 1  )
						end
						villageWar.guildMark:setRenderTexture(villageWar.guildMark:getBaseTexture())
						villageWar.guildName:SetText( siegeWrapper:getGuildName() )

						local siegeTentCount = ToClient_GetCompleteSiegeTentCount( regionKey:get() )
						if 0 == siegeTentCount then
							villageWar.nodeWarJoinCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_ACTORTOLTIP_JOINNODEWAR_NO") ) -- 현재 거점 성채를 건설한\n길드가 없습니다.
						else
							villageWar.nodeWarJoinCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_ACTORTOLTIP_JOINNODEWAR_COUNT", "siegeTentCount", siegeTentCount ) ) -- 건설된 거점 성채 : " .. siegeTentCount .. "개"
						end
				
						local isSet = setGuildTextureByGuildNo( siegeWrapper:getGuildNo(), villageWar.guildMark )
						villageWar.nodeState		:SetShow( false )
						villageWar.nodeStateDesc	:SetShow( false )
					--}
					
					-- { 길드명
						villageWar.guildMasterName:SetShow( true )
						villageWar.guildMasterName:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MINUSIEGETOOLTIP_GUILDMASTER", "name", siegeWrapper:getGuildMasterName() ) ) -- "길드대장 : " .. siegeWrapper:getGuildMasterName()
					-- }

					-- { 점령일
						villageWar.guildOption:SetShow( true )
						local paDate	= siegeWrapper:getOccupyingDate()
						local year		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()) )
						local month		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()) )
						local day		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()) )
						local hour		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()) )
						local d_date	= year .. month .. day .. hour
						villageWar.guildOption:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MINUSIEGETOOLTIP_OCCUPYINGDATE", "date", d_date ) ) -- "점령일 : " .. date
					-- }
				else
					local siegeTentCount = ToClient_GetCompleteSiegeTentCount( regionKey:get() )
					if 0 == siegeTentCount then
						villageWar.nodeWarJoinCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_ACTORTOLTIP_JOINNODEWAR_NO") )
					else
						villageWar.nodeWarJoinCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_ACTORTOLTIP_JOINNODEWAR_COUNT", "siegeTentCount", siegeTentCount ) )
					end
					villageWar.guildMarkBg		:SetShow( false )
					villageWar.guildMark		:SetShow( false )
					villageWar.guildName		:SetShow( false )
					villageWar.guildMasterName	:SetShow( false )
					villageWar.guildOption		:SetShow( false )
					villageWar.guildName		:SetText( "" )
					villageWar.guildMasterName	:SetText( "" )
					villageWar.guildOption		:SetText( "" )

					villageWar.nodeState		:SetShow( true )
					villageWar.nodeStateDesc	:SetShow( false )
					villageWar.nodeState		:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MINUSIEGETOOLTIP_NOTYETOCCUPY" ) )
					-- villageWar.nodeStateDesc:SetText( "" )
				end
			end

			Panel_NodeSiegeTooltip:SetShow( true )
			Panel_NodeSiegeTooltip:SetPosX( nodeBtn:GetPosX() + nodeBtn:GetSizeX() + 10 )
			Panel_NodeSiegeTooltip:SetPosY( nodeBtn:GetPosY() )
		end
	-- }
end

function FromClient_OutWorldMapNode( nodeBtn )
	local nodeInfo 			= nodeBtn:FromClient_getExplorationNodeInClient()
	local plantKey 			= nodeInfo:getPlantKey()
	local waypointKey 		= plantKey:getWaypointKey()

	local isSubNode = false

	local plant				= getPlant(plantKey)
	if nil ~= plant then
		isSubNode			= plant:isSatellitePlant()
	end

	ToClient_clearBuildingLineInVillageSiege();

	if On_plantKey ~= waypointKey then
		return
	end
	FGlobal_ClearWorldmapIconTooltip();

	--{ 거점점령정보
	if false == isSubNode then
		Panel_NodeGuildWarMenu:SetShow( false )
	end
	--}
	Panel_NodeSiegeTooltip:SetShow( false )
end

-- 파티 툴팁 --
function FromClient_PartyIconOn( index )
	if ( isShow ) then
		local memberData = RequestParty_getPartyMemberAt(index)
		if ( nil == memberData ) then
			return
		end

		WorldMap_IconName.save_partyIndex = index
		WorldMap_IconName.tooltipType = eTooltipType.party
		WorldMap_IconName.text_Name = memberData:name()
		WorldMap_IconName:Set_Name()
	else
	end
end

function FromClient_PartyIconOut()
	FGlobal_ClearWorldmapIconTooltip()
end

-- 집 툴팁 --
local houseKey_ToolTip = nil
function FromClient_OnWorldMapHouse( houseBtn, commonOverUI )
	FGlobal_ClearWorldmapIconTooltip();
	houseKey_ToolTip = houseBtn:FromClient_getStaticStatus():getHouseKey()
	local houseInClientWrapper = houseBtn:FromClient_getStaticStatus();
	nodeIconName:SetText( houseInClientWrapper:getName() );

	local nodeX = houseBtn:GetPosX();
	local nodeY = houseBtn:GetPosY();
	local sizeX = houseBtn:GetSizeX();
	local sizeY = houseBtn:GetSizeY();	

	local tooltipSizeX = nodeIconName:GetTextSizeX() + 10;
	local tooltipSizeY = nodeIconName:GetTextSizeY() + 5;
	
	Panel_WorldMap_Tooltip:SetSize( tooltipSizeX + sizeGap, tooltipSizeY + sizeGap );
	
	local overUISizeX = Panel_WorldMap_Tooltip:GetSizeX()
	local overUIPosX = nodeX + ( sizeX - overUISizeX ) / 2;
	local overUIPosY = nodeY -  Panel_WorldMap_Tooltip:GetSizeY() - sizeGap;

	if( overUIPosX + overUISizeX > getScreenSizeX() ) then
		overUIPosX = getScreenSizeX() - overUISizeX;
	end

	Panel_WorldMap_Tooltip:SetPosX( overUIPosX );
	Panel_WorldMap_Tooltip:SetPosY( overUIPosY ); 	
	nodeIconName:SetShow(true);
	Panel_WorldMap_Tooltip:SetShow(true)
	houseBtn:setRenderTexture( houseBtn:getOnTexture() );
end

function FromClient_OutWorldMapHouse( houseBtn, commonOverUI )
	if houseKey_ToolTip ~= houseBtn:FromClient_getStaticStatus():getHouseKey() then
		return
	end
	FGlobal_ClearWorldmapIconTooltip();	
	houseBtn:setRenderTexture( houseBtn:getBaseTexture() );
	houseKey_ToolTip = nil
end

function FromClient_WorldMapAuctionHouseOn( guildHouseBtn, commonOverUI )
	FGlobal_ClearWorldmapIconTooltip();
	local auctionHouseWrapper = guildHouseBtn:FromClient_getAuctionHouseInfoWrapper()
	
	if nil == auctionHouseWrapper then
		return
	end

	local ownerName;
	
	if( auctionHouseWrapper:isFixedHouse() ) then
		ownerName	= auctionHouseWrapper:getOwnerGuildName();
	elseif( auctionHouseWrapper:isVilla() ) then
		ownerName	= auctionHouseWrapper:getOwnerUserNickname();
	end

	local houseName = auctionHouseWrapper:getHouseName()

	if( nil ~= ownerName ) then
		houseName =	houseName .. " - " ..ownerName
	end
	nodeIconName:SetText( houseName );

	local nodeX = guildHouseBtn:GetPosX();
	local nodeY = guildHouseBtn:GetPosY();
	local sizeX = guildHouseBtn:GetSizeX();
	local sizeY = guildHouseBtn:GetSizeY();	

	local tooltipSizeX = nodeIconName:GetTextSizeX() + 10;
	local tooltipSizeY = nodeIconName:GetTextSizeY() + 5;
	
	Panel_WorldMap_Tooltip:SetSize( tooltipSizeX + sizeGap, tooltipSizeY + sizeGap );
	
	local overUISizeX = Panel_WorldMap_Tooltip:GetSizeX()
	local overUIPosX = nodeX + ( sizeX - overUISizeX ) / 2;
	local overUIPosY = nodeY -  Panel_WorldMap_Tooltip:GetSizeY() - sizeGap;

	if( overUIPosX + overUISizeX > getScreenSizeX() ) then
		overUIPosX = getScreenSizeX() - overUISizeX;
	end

	Panel_WorldMap_Tooltip:SetPosX( overUIPosX );
	Panel_WorldMap_Tooltip:SetPosY( overUIPosY ); 	
	nodeIconName:SetShow(true);
	Panel_WorldMap_Tooltip:SetShow(true)
end

function FromClient_WorldMapAuctionHouseOut()
	FGlobal_ClearWorldmapIconTooltip();
end

function FromClient_WorldMapAuctionHouseRClick( position )
	FromClient_RClickWorldmapPanel( position, true );
end

function FromClient_RClickActorIcon( actorIcon, pos3D )
	FromClient_RClickWorldmapPanel( pos3D, true );
end

--[[
function FromClient_OnBuildingNode( buildingBtn, commonOverUI )
	FGlobal_ClearWorldmapIconTooltip();
	if( nil == buildingBtn ) then
		return;
	end

	local buildingName = ToClient_getBuildingName( buildingBtn:ToClient_getBuildingStaticStatus() );
	nodeIconName:SetText( buildingName );

	local nodeX = buildingBtn:GetPosX();
	local nodeY = buildingBtn:GetPosY();
	local sizeX = buildingBtn:GetSizeX();
	local sizeY = buildingBtn:GetSizeY();	

	local tooltipSizeX = nodeIconName:GetTextSizeX();
	local tooltipSizeY = nodeIconName:GetTextSizeY();
	
	Panel_WorldMap_Tooltip:SetSize( tooltipSizeX + sizeGap, tooltipSizeY + sizeGap );
	
	local overUISizeX = Panel_WorldMap_Tooltip:GetSizeX()
	local overUIPosX = nodeX + ( sizeX - overUISizeX ) / 2;
	local overUIPosY = nodeY -  Panel_WorldMap_Tooltip:GetSizeY() - sizeGap;

	if( overUIPosX + overUISizeX > getScreenSizeX() ) then
		overUIPosX = getScreenSizeX() - overUISizeX;
	end

	Panel_WorldMap_Tooltip:SetPosX( overUIPosX );
	Panel_WorldMap_Tooltip:SetPosY( overUIPosY ); 	
	nodeIconName:SetShow(true);
	Panel_WorldMap_Tooltip:SetShow(true)
end

function FromClient_OutBuildingNode( buildingBtn, overUI )
	FGlobal_ClearWorldmapIconTooltip()
end
]]--

function FromClient_OnBuildingNode( buildingBtn, commonOverUI )
	if( nil == buildingBtn ) then
		return;
	end
	local position = ToClient_getBuildingPosition( buildingBtn:ToClient_getBuildingStaticStatus() );
	
	local regionInfoWrapper = ToClient_getVillageSiegeRegionInfoWrapperByPosition( position );
	if regionInfoWrapper == nil then
		return;
	end
	ToClient_createBuildingLineInVillageSiege( regionInfoWrapper:getRegionKey() );
end
function FromClient_OutBuildingNode( buildingBtn, commonOverUI )
	ToClient_clearBuildingLineInVillageSiege();
end

function FromClient_LClickDeliveryVehicle( deliveryIcon )

	local	objectID		= deliveryIcon:FromClient_GetObjectID( )
	local	delivererType	= deliveryIcon:FromClient_getDelivererType()
	if(		delivererType == CppEnums.DelivererType.WagonForPerson
		or	delivererType == CppEnums.DelivererType.OfferingCarrier )	then
		return
	end
	
	DeliveryCarriageInformationWindow_Open( objectID )
end


function FromClient_SetTownModeToActorTooltip()
		Panel_WorldMap_Tooltip:SetShow(false);
end

function FromClient_PartyIconOn( partyMemberIcon, partyMemberProxy )
	tooltipHide()
	local partyActorName	= partyMemberProxy:name()
	local partyActorLevel	= partyMemberProxy._level

	local posX = partyMemberIcon:GetPosX() + partyMemberIcon:GetSizeX()
	local posY = partyMemberIcon:GetPosY()

--{ 파티 클래스 아이콘
	if ( partyMemberProxy:classType() == UI_Class.ClassType_Warrior ) then	-- 워리어
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 77, 25, 107, 55 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())

	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_Ranger ) then	-- 레인저
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 108, 25, 138, 55 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())
		
	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_Sorcerer ) then	-- 소서러
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 139, 25, 169, 55 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())
		
	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_Giant ) then	-- 자이언트
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 170, 25, 200, 55 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())

	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_Tamer ) then	-- 금수랑
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 167, 56, 197, 86 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())

	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_BladeMaster ) then	-- 무사
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 198, 56, 228, 86 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())

	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_BladeMasterWomen ) then	-- 매화(여자 무사)
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 198, 87, 228, 117 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())

	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_Valkyrie ) then	-- 발키리
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 167, 87, 197, 117 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())

	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_Wizard ) then	-- 위자드
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 198, 118, 228, 148 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())


	elseif ( partyMemberProxy:classType() == UI_Class.ClassType_WizardWomen ) then	-- 위치(여자 위자드)
	classTypeTexture = "new_ui_common_forlua/widget/party/Party_00.dds"
	partyMemberClassIcon:ChangeTextureInfoName(classTypeTexture)
		local x1, y1, x2, y2 = setTextureUV_Func( partyMemberClassIcon, 198, 149, 228, 179 )
		partyMemberClassIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		partyMemberClassIcon:setRenderTexture(partyMemberClassIcon:getBaseTexture())

	end
--}

	Panel_WorldMap_PartyMemberTooltip:SetShow( true )
	partyMemberClassIconBG:SetShow( true )
	partyMemberClassIcon:SetShow( true )
	partyMemberName:SetShow( true )
	partyMemberLevel:SetShow( true )
	partyMemberName:SetText( partyActorName )
	partyMemberLevel:SetText( partyActorLevel )

	partyMemberClassIcon:SetPosX( partyMemberName:GetPosX() - partyMemberName:GetSizeX() )

	Panel_WorldMap_PartyMemberTooltip:SetPosX( posX-15 )
	Panel_WorldMap_PartyMemberTooltip:SetPosY( posY+20 )
end

function FromClient_PartyIconOut()
	Panel_WorldMap_PartyMemberTooltip:SetShow( false )
end

registerEvent("FromClient_OnWorldMapNode",				"FromClient_OnWorldMapNode")
registerEvent("FromClient_OutWorldMapNode",				"FromClient_OutWorldMapNode")
registerEvent("FromClient_WorldmapIconTooltipInit",		"FromClient_WorldmapIconTooltipInit")
registerEvent("FromClient_OnWorldMapHouse",				"FromClient_OnWorldMapHouse")
registerEvent("FromClient_OutWorldMapHouse",			"FromClient_OutWorldMapHouse");
registerEvent("FromClient_OnBuildingNode",				"FromClient_OnBuildingNode");
registerEvent("FromClient_OutBuildingNode",				"FromClient_OutBuildingNode");
registerEvent("FromClient_WorldMapAuctionHouseOn",		"FromClient_WorldMapAuctionHouseOn");
registerEvent("FromClient_WorldMapAuctionHouseOut",		"FromClient_WorldMapAuctionHouseOut");
registerEvent("FromClient_WorldMapAuctionHouseRClick",	"FromClient_WorldMapAuctionHouseRClick");
registerEvent("FromClient_RClickActorIcon",				"FromClient_RClickActorIcon");
registerEvent("FromClient_LClickDeliveryVehicle",		"FromClient_LClickDeliveryVehicle");
registerEvent("FromClient_SetTownMode",					"FromClient_SetTownModeToActorTooltip")
registerEvent("FromClient_PartyIconOn",					"FromClient_PartyIconOn")
registerEvent("FromClient_PartyIconOut",				"FromClient_PartyIconOut")

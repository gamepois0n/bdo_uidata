
------------------------------------------------------
-- Territory Tooltip
------------------------------------------------------
--local   panel			= Panel_CastleInfo

--local   ocuppyInfo		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_Ocuppy" )
--local   castleName		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_CastleName" )
--local	guildName		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_CastleGuild" )
--local	masterName		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_CastleMaster" )
--local   castleTime		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_CastleTime" )
--local	notice			= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_Notice" )

--local explorationUI 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_ExploreTerritory")
--local supportUI 			= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_SupportPoint")
--local affiliatedUserRateUI 	= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_AffiliatedUserRate")
--local guildWar 				= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_GuildWar")

local const_lineGap = 5;

local territoryName 	= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_Title" )
local territoryInfoScetion = 
{
		territoryTitle 	= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_SiteInfoTItle"),		-- "영지 정보"
		territoryIcon 	= UI.getChildControl( Panel_Worldmap_Territory, "Static_SiteIcon"),					-- 영지 아이콘
		cityName 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_CityName"),				-- "도시 : 하이델"
		userRate 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_UserRate"),				-- "주민 밀도 : 인구부족(00%)"
		taxTitle 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_TaxRateInfoTitle"),		-- "세율 정보"

-- 소득세, 소비세, 관세 현재는 사용하지 않는다.
--[[		
		taxExcise 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_TaxExcise"),			-- "소비세 : 00%"

		taxIncome 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_TaxIncome"),			-- "소득세 : 00%"
		taxTariff 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_TaxTariff"),			-- "관세 : 00%"
]]--

		taxTransfer 	= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_TransferTax"),
		-- BackGround Image( On/off ) 를 위해
		sectionBG 		= UI.getChildControl( Panel_Worldmap_Territory, "Static_TerritoryInfoBG"),
}

local occupyGuildSection =
{
		sectionTitle 	= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_OccupiersInfoTitle"),	-- "점령 정보"
		guildIcon 		= UI.getChildControl( Panel_Worldmap_Territory, "Static_GuildIcon"),				-- 길드 아이콘
		guildIconBG 	= UI.getChildControl( Panel_Worldmap_Territory, "Static_GuildIconBG"),				-- 길드 아이콘 BG
		guildName 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_OccupationGuild"),		-- "점령 길드"
		guildOwner 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_OccupationOwner"),		-- "점령 길드장"
		occupyDate 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_OccupationDate"),		-- "점령 기간"

		-- BackGround Image( On/off ) 를 위해
		sectionBG 		= UI.getChildControl( Panel_Worldmap_Territory, "Static_OccupiersInfoBG"),			-- 해당 BG
}

local commonInfoSection =
{
		playerInfoTitle	= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_PlayerInfoTitle"),		-- "플레이어 정보"
		playerPopular 	= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_Reputation"),			-- "평판 : 초보모험가"

		warInfoTitle 	= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_OccupationInfoTitle"),	-- "점령전 정보"
		warInfo 		= UI.getChildControl( Panel_Worldmap_Territory, "StaticText_WarInfo"),				-- "00개의 길드가 참전 중"

		-- BackGround Image( On/off ) 를 위해
		sectionBG 		= UI.getChildControl( Panel_Worldmap_Territory, "Static_InformationBG")
}


-----------------------------------------------------------------------------------------------
-- 영지 정보 관련 부분
------------------------------------------------------------------------------------------------

function territoryInfoScetion:SetShow( isShow )
	self.territoryTitle:SetShow(isShow);
	self.territoryIcon:SetShow(isShow);
	self.cityName:SetShow(isShow);
	self.userRate:SetShow(isShow);
	self.taxTitle:SetShow(isShow);
	self.taxTransfer:SetShow(isShow);
	self.sectionBG:SetShow(isShow);
end

function territoryInfoScetion:SetInfo( territoryInfo, territoryKeyRaw )
	-- 영지 아이콘 설정
	local imagePath =	ToClient_getTerritoryImageName(	territoryInfo );
	self.territoryIcon:ChangeTextureInfoName(imagePath)

	-- 도시 이름 설정
	local siegeWrapper = ToClient_GetSiegeWrapper(territoryKeyRaw)

	if ( nil ~= siegeWrapper ) then
		self.cityName:SetText( siegeWrapper:getRegionAreaName() );
	end

	-- 주민 밀도 설정
	local affiliatedUserRate 		= ToClient_getAffiliatedUserRate( territoryInfo );
	local affiliatedUserRateStr 	= PAGetString ( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_POPULATIONDENSITY")
		
	if (0 <= affiliatedUserRate and affiliatedUserRate <= 20) then
		affiliatedUserRateStr 	= affiliatedUserRateStr.." <PAColor0xFFFF4C4C>"..PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_LACK").."<PAOldColor> ("..string.format( "%d", affiliatedUserRate).."%)"
	elseif (20 < affiliatedUserRate and affiliatedUserRate <= 40) then
		affiliatedUserRateStr 	= affiliatedUserRateStr.." <PAColor0xFFFF874C>"..PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_LOW").."<PAOldColor> ("..string.format( "%d", affiliatedUserRate).."%)"
	elseif (40 < affiliatedUserRate and affiliatedUserRate <= 60) then
		affiliatedUserRateStr 	= affiliatedUserRateStr.." <PAColor0xFFAEFF9B>"..PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_NORMAL").."<PAOldColor> ("..string.format( "%d", affiliatedUserRate).."%)"
	elseif (60 < affiliatedUserRate and affiliatedUserRate <= 80) then
		affiliatedUserRateStr 	= affiliatedUserRateStr.." <PAColor0xFF9B9BFF>"..PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_HIGH").."<PAOldColor> ("..string.format( "%d", affiliatedUserRate).."%)"
	elseif (80 < affiliatedUserRate and affiliatedUserRate <= 100) then
		affiliatedUserRateStr 	= affiliatedUserRateStr.." <PAColor0xFF8737FF>"..PAGetString ( Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_EXPLOSION").."<PAOldColor> ("..string.format( "%d", affiliatedUserRate).."%)"
	end

	self.userRate:SetText(affiliatedUserRateStr)
	self.userRate:SetShow( false )

	-- 거래세
	local taxrate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)

	self.taxTransfer:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_TERRITORY_LOCAL_TAX") .. " : " .. string.format( "%d", taxrate ) .. "%" ); 

	-- 소비세
	--self.taxExcise:SetText();
	-- 소득세
	--self.taxIncome:SetText();
	--관세
	--self.taxTariff:SetText();
end

-----------------------------------------------------------------------------------------------------
-- 영지 정보 관련 끝
------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------
-- 점령 정보 
------------------------------------------------------------------------------------------------------
function occupyGuildSection:SetShow( isShow )
	self.sectionTitle:SetShow( isShow );
	self.guildIcon:SetShow( isShow );
	self.guildIconBG:SetShow( isShow );
	self.guildName:SetShow( isShow );
	self.guildOwner:SetShow( isShow );
	self.occupyDate:SetShow( isShow );

	self.sectionBG:SetShow( isShow );
end

function occupyGuildSection:SetInfo( territoryInfo, territoryKeyRaw )
	local siegeWrapper = ToClient_GetSiegeWrapper( territoryKeyRaw );
	
	-- 길드 마크 설정
	local isSet = ToClient_setGuildTexture( territoryInfo, self.guildIcon );	
	if( isSet ) then
		self.guildIcon:SetAlpha( 1 );
	else
		-- todo 이게 좋은 방법이 아닌것 같다.
		self.guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlankGuildMark.dds");
		self.guildIcon:SetAlpha(0);
	end

	-- 길드 이름 설정
	self.guildName:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_GUILD" ).. " : " .. siegeWrapper:getGuildName() );

	-- 길드장 설정
	self.guildOwner:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MASTER" ).. " : " .. siegeWrapper:getGuildMasterName() );

	-- 점령 기간 설정
	local paDate = siegeWrapper:getOccupyingDate()
	local year = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()) )
	local month = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()) )
	local day = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()) )
	local hour = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()) )
	self.occupyDate:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_TIME" ).. " : " .. year .. month .. day .. hour )
	
end

-----------------------------------------------------------------------------------------------------
-- 점령 정보 끝
------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------
-- Player 정보 
------------------------------------------------------------------------------------------------------
function commonInfoSection:SetShow( isShow )
	self.playerInfoTitle:SetShow( isShow );
	self.playerPopular:SetShow( isShow );
	self.warInfoTitle:SetShow( isShow );
	self.warInfo:SetShow( isShow );

	self.sectionBG:SetShow( isShow );
end

function commonInfoSection:SetInfo( territoryInfo, territoryKeyRaw )
	-- 여기서만 위치 조절을 하는 이유는, 맨 아래에 있는 이 정보창만 위 아래로 움직이면 되기 때문.	

	-- BG Span 설정

	-- 평판 정보
	local supportPoint			= ToClient_getRemainSurportPointByTerritory(territoryInfo);
	local supportExpRate 		= ToClient_getCurrentExpRate( territoryInfo );
	
	if ( 0 == supportPoint ) then
		supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ROOKIE" ) .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER" ) .. "<PAOldColor>"
	elseif ( 1 == supportPoint ) then
		supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_STRANGE" ) .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER" ) .. "<PAOldColor>"
	elseif ( 2 == supportPoint ) then
		supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_CLOSE" ) .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER" ) .. "<PAOldColor>"
	elseif ( 3 == supportPoint ) then
		supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_RELIABLE" ) .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER" ) .. "<PAOldColor>"
	elseif ( 4 <= supportPoint ) then
		supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_FAMOUS" ) .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER" ) .. "<PAOldColor>"
	end	

	self.playerPopular:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_FAME" ) .. " : " .. supportPointText ) -- .. " ("..string.format( "%d", supportExpRate).."%)")

	local isWar = isSiegeBeing( territoryKeyRaw );
	local joinGuildCount = getCompleteKingOrLordTentCount( territoryKeyRaw )
	if( isWar ) then
		-- 전쟁정보
		self.warInfo:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WOLRDMAP_TERRITORYTOOLTIP_TEXT_GUILDWAR", "joinGuildCount", joinGuildCount ) ) -- "점령전 : " .. joinGuildCount .. "개 길드 참전"
		
	else
		self.warInfo:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYTOOLTIP_JOINGUILDCOUNT", "joinGuildCount", joinGuildCount ) ) -- "건설된 성채 : " .. joinGuildCount .. "개" ) -- 현재는 전쟁 중이 아닙니다
	end

	local siegeWrapper = ToClient_GetSiegeWrapper( territoryKeyRaw );
	

	if( nil ~= siegeWrapper and siegeWrapper:doOccupantExist() )	then
		self.sectionBG:SetSpanSize( 0, 400 )
		self.playerInfoTitle:SetSpanSize( 0, 410 )
		self.playerPopular:SetSpanSize( 30, 440 )
		self.warInfoTitle:SetSpanSize( 0, 480 );
		self.warInfo:SetSpanSize( 30, 510 );	
	else
		self.sectionBG:SetSpanSize( 0, 240 )
		self.playerInfoTitle:SetSpanSize( 0, 250 )
		self.playerPopular:SetSpanSize( 30, 280 )
		self.warInfoTitle:SetSpanSize( 0, 320 );
		self.warInfo:SetSpanSize( 30, 350 );		
	end
end

-----------------------------------------------------------------------------------------------------
-- Player 정보 끝
------------------------------------------------------------------------------------------------------

function FromClient_TerritoryUICreate( territoryUI )
	local territoryInfo =	territoryUI:FromClient_getTerritoryInfo();
	local guildMark = territoryUI:FromClient_getGuildMark();
	guildMark:SetSize( 32, 32 )
	guildMark:SetSpanSize( 0, 118 )
	guildMark:SetHorizonCenter()
	guildMark:SetVerticalTop()
	guildMark:SetIgnore(true)
	guildMark:SetShow(false)
	guildMark:SetTexturePreload(false)

	local isSet = ToClient_setGuildTexture( territoryInfo, guildMark )

	if ( false == isSet ) then
		guildMark			:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlankGuildMark.dds")
		guildMark			:SetTexturePreload(false)
		guildMark			:SetAlpha(0)
	else
		guildMark			:SetAlpha(1)
	end
end

function FromClient_updateGuildmark( territoryUI )
    local territoryInfo =	territoryUI:FromClient_getTerritoryInfo();
	local guildMark = territoryUI:FromClient_getGuildMark();
	local isSet = ToClient_setGuildTexture( territoryInfo, guildMark )
	if ( false == isSet ) then
		guildMark			:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlankGuildMark.dds")
		guildMark			:SetTexturePreload(false)
		guildMark			:SetAlpha(0)
	else
    	guildMark			:SetAlpha(1)
	end
end

function FromClient_OnTerritoryTooltipShow( territoryUI, territoryInfo, territoryKeyRaw)
	if( nil == territoryInfo ) then
		return
	end

	panelHeight = 0;
	Panel_Worldmap_Territory:SetShow(true)
	local siegeWrapper = ToClient_GetSiegeWrapper( territoryKeyRaw );

	-- 지역 타이틀 설정
	territoryName:SetText( ToClient_getTerritoryName( territoryInfo ) ); 

	territoryInfoScetion:SetShow(true);
	territoryInfoScetion:SetInfo( territoryInfo, territoryKeyRaw );

	local panelHeight = territoryInfoScetion.sectionBG:GetSizeY() + const_lineGap;

	if( nil ~= siegeWrapper and siegeWrapper:doOccupantExist() ) then
		occupyGuildSection:SetShow(true);
		occupyGuildSection:SetInfo( territoryInfo, territoryKeyRaw );

		panelHeight = panelHeight + occupyGuildSection.sectionBG:GetSizeY() + const_lineGap;
	else
		occupyGuildSection:SetShow(false);
	end

	commonInfoSection:SetShow(true);
	commonInfoSection:SetInfo( territoryInfo, territoryKeyRaw );

	Panel_Worldmap_Territory:SetSize( Panel_Worldmap_Territory:GetSizeX() ,commonInfoSection.sectionBG:GetPosY() + commonInfoSection.sectionBG:GetSizeY() + 20 );

	local posX = territoryUI:GetPosX();
	local posY = territoryUI:GetPosY();
	local screenSizeX = getScreenSizeX();
	local screenSizeY = getScreenSizeY();

	if( ( posX / screenSizeX ) > 0.5 ) then
		posX = posX - Panel_Worldmap_Territory:GetSizeX();
	else
		posX = posX + territoryUI:GetSizeX();
	end

	if( ( posY / screenSizeY > 0.5 ) ) then
		posY = posY - Panel_Worldmap_Territory:GetSizeY();
	end

	Panel_Worldmap_Territory:SetPosX( posX );
	Panel_Worldmap_Territory:SetPosY( posY );

	-- _PA_LOG("최대호", tostring(posX).." : " .. tostring(posY) )

end

function FromClient_OnTerritoryTooltipHide()
	Panel_Worldmap_Territory:SetShow(false)
end

registerEvent("FromClient_WorldMapTerritoryNodeCreate",	 "FromClient_TerritoryUICreate")
registerEvent("FromClient_WorldMapTerritoryNodeGuildMarkUpdate", "FromClient_updateGuildmark")
registerEvent("FromClient_TerritoryTooltipShow", "FromClient_OnTerritoryTooltipShow")
registerEvent("FromClient_TerritoryTooltipHide", "FromClient_OnTerritoryTooltipHide")

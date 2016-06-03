Panel_WorldMapTooltipHouse:SetShow( false, false )
Panel_WorldMapTooltipHouse:setGlassBackground(true)

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
local houseTooltip =
{
	controls =
	{
		houseName	= UI.getChildControl( Panel_WorldMapTooltipHouse, "Static_Text_Title" ),
		ownerInfo	= UI.getChildControl( Panel_WorldMapTooltipHouse, "Static_Text_ItemList" ),
		houseInfo	= UI.getChildControl( Panel_WorldMapTooltipHouse, "Static_Text_ItemPrice" )
	},
	lastHouseCharacterKey = 0
}

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local checkValid = function()
	local controls = houseTooltip.controls

	UI.ASSERT( nil ~= controls.houseName and 'PAUIStatic' == controls.houseName.__name,		'houseName	is nil' )
	UI.ASSERT( nil ~= controls.ownerInfo and 'PAUIStatic' == controls.ownerInfo.__name,		'ownerInfo	is nil' )
	UI.ASSERT( nil ~= controls.houseInfo and 'PAUIStatic' == controls.houseInfo.__name,		'houseInfo	is nil' )
end

local floor = math.floor
function FromClient_OnWorldMapHouse( houseBtn, mouseX, mouseY )
	-- 같은 데이터를 다시 세팅할 필요가 없다.
	local houseInClientWrapper = houseBtn:FromClient_getStaticStatus()
	local houseCharacterKey = houseInClientWrapper:getHouseKey();
	if houseTooltip.lastHouseCharacterKey == houseCharacterKey then
		return
	end

	houseTooltip.lastHouseCharacterKey = houseCharacterKey
	local controls = houseTooltip.controls
	controls.houseName:SetText( houseInClientWrapper:getName() )
--	if houseInClientWrapper:hasOwnerUser() then
--		local minute = houseInClientWrapper:getExpirationDateInMinute()
--		local hour = floor( minute / 60 )
--		local day = floor( hour / 24 )

--		controls.ownerInfo:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_OWNERINFO" ) .. " : " .. houseInClientWrapper:getOwnerUserNickname() )
--		if 0 < day then
--			controls.houseInfo:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_EXPIRATION" ) .. " : " .. day .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_DAY" ) .. hour .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_HOUR" ) )
--		else
--			controls.houseInfo:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_EXPIRATION" ) .. " : " .. hour .. PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_HOUR" ) .."["..PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_DEADLINE" ).."]" )
--		end
--	else
--		controls.ownerInfo:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WORLD_MAP_HOUSE_NO_OWNER" ) )
--		controls.houseInfo:SetText( '' )
--	end
	Panel_WorldMapTooltipHouse:SetPosX( mouseX + 30 )
	Panel_WorldMapTooltipHouse:SetPosY( mouseY )
	Panel_WorldMapTooltipHouse:SetShow( true, false )
end

function WorldMap_HouseTooltip_Hide()
	houseTooltip.lastHouseCharacterKey = 0
	Panel_WorldMapTooltipHouse:SetShow( false, false )
end


checkValid()		-- 서비스 버전에서는 제거해도 되는 함수이다!

--registerEvent("FromClient_OnWorldMapHouse",			"FromClient_OnWorldMapHouse")

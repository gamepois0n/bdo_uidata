Panel_TradeMarket_EventInfo:setMaskingChild(true)
Panel_TradeMarket_EventInfo:setGlassBackground(true)
Panel_TradeMarket_EventInfo:SetShow( false )

Panel_TradeMarket_EventInfo:RegisterShowEventFunc( true, "Panel_TradeMarket_EventInfo_ShowAni()" )
Panel_TradeMarket_EventInfo:RegisterShowEventFunc( false, "Panel_TradeMarket_EventInfo_HideAni()" )

function Panel_TradeMarket_EventInfo_ShowAni()
end
function Panel_TradeMarket_EventInfo_HideAni()
end

local btnClose		= UI.getChildControl( Panel_TradeMarket_EventInfo, "Button_Close" )
btnClose:addInputEvent( "Mouse_LUp", "TradeEventInfo_Close()" )
-- 이벤트 관련
local eventNavi		= UI.getChildControl( Panel_TradeMarket_EventInfo, "Button_TradeEvent_Navi" )
local evnetBg		= UI.getChildControl( Panel_TradeMarket_EventInfo, "Static_TradeEventDescBG" )
local eventDesc		= UI.getChildControl( Panel_TradeMarket_EventInfo, "StaticText_TradeEventDesc" )
local eventAlert	= UI.getChildControl( Panel_TradeMarket_EventInfo, "StaticText_TradeEventAlert" )
eventDesc:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
eventNavi:addInputEvent( "Mouse_LUp", "Find_TradeEvnetNpc()" )

-- 황실 납품 관련
local supplyBg		= UI.getChildControl( Panel_TradeMarket_EventInfo, "Static_TerritorySupplyBG" )
local supplyTown	= UI.getChildControl( Panel_TradeMarket_EventInfo, "StaticText_TerritorySupply_Town" )
local supplyNavi	= UI.getChildControl( Panel_TradeMarket_EventInfo, "Button_Supply_Navi" )
local itemSlot		= UI.getChildControl( Panel_TradeMarket_EventInfo, "Static_ItemPanel" )
local slotBg		= UI.getChildControl( Panel_TradeMarket_EventInfo, "Static_SlotBG" )
local supplyAlert	= UI.getChildControl( Panel_TradeMarket_EventInfo, "StaticText_TerritorySupplyAlert" )

-- 변수
local slotConfig =
{
	createIcon		= true,
	createBorder	= true,
	createCount		= true,
}

-- 황실납품 NPC가 속해 있는 리전키(npc 배치 변경 시 같이 바꿔줘야 함!)
local territorySupplyNpcRegionKey =
{
	[0] = 5,				-- 벨리아 마을
	[1] = 32,				-- 하이델
	[2] = 310,				-- 칼페온
	[3] = 202,				-- 알티노바
	[4] = 229,				-- 발렌시아
}

-- 무역 이벤트 NPC가 속해 있는 리전키
local tradeEvnetNpcRegionKey =
{
	[40010] = 5,				-- 벨리아 마을(바하르)
	[40028] = 9,				-- 서부 캠프(루크)
	[40715] = 88,				-- 올비아 마을(롤리)
	[41051] = 32,				-- 하이델(시우타)
	[41090] = 52,				-- 글리시(라크)
	[42005] = 310,				-- 칼페온 빈민가(하덴)
	[42013] = 311,				-- 칼페온 시장(린지아나 허바)
	[42026] = 312,				-- 칼페온 공방(울프강)
	[42301] = 120,				-- 에페리아(올리비노 그롤린)
	[43010] = 107,				-- 케플란(하미어)
	[44010] = 202,				-- 알티노바(쿠이나)
	[44110] = 221,				-- 타리프(브로룸)
	[40025] = 16,				-- 바탈리 농장(엠마)
	[41223] = 56,				-- 중앙 경비 캠프(제니안스)
	[43449] = 313,				-- 베르니안토 농장(베르니안토)
	[50418] = 110,				-- 마르니 동굴길(헨지 바토)
	[50493] = 212,				-- 오마르 용암 동굴(하칸 데르크)	>>	확인필요
}

local isCalpheon, isMedia, isValencia, terrCount = 2, 3, 4
if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, isValencia ) then			-- 발렌시아 오픈?
	terrCount = 5
elseif ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, isMedia ) then			-- 메디아 오픈?
	terrCount = 4
elseif ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, isCalpheon ) then		-- 칼페온 오픈?
	terrCount = 3
else
	terrCount = 2
end

local territoryName =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_1"),	-- "- 발레노스 자치령",
	PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_2"), 			-- "- 세렌디아 자치령",
	PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_3"),			-- "- 칼페온 직할령",
	PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_4"),			-- "- 메디아 직할령",
	PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_5"),			-- "- 발렌시아 직할령"
}

local maxTerritoryCount = #territoryName + 1
local maxSlotCount = 6
local eventBgSizeY = evnetBg:GetSizeY()
local bgSizeY = supplyBg:GetSizeY()
local gapX, gapY = 58, 80

local _townName = {}
local _btnNavi = {}
local _slotBg = {}
local _itemSlot = {}
function TradeEventInfo_Init()
	for terrIndex = 0, terrCount - 1 do
		local temp1 = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_TradeMarket_EventInfo, "Static_TerritorySupplyTownName_" .. terrIndex )
		CopyBaseProperty( supplyTown, temp1 )
		temp1:SetText( territoryName[terrIndex] )
		temp1:SetPosY( supplyTown:GetPosY() + terrIndex * gapY )
		temp1:SetShow( false )
		_townName[terrIndex] = temp1
		
		local tempNavi = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_TradeMarket_EventInfo, "Button_TerritorySupplyNavi_" .. terrIndex )
		CopyBaseProperty( supplyNavi, tempNavi )
		tempNavi:SetPosX( temp1:GetPosX() + temp1:GetTextSizeX() + 5 )
		tempNavi:SetPosY( temp1:GetPosY() )
		tempNavi:SetShow( false )
		tempNavi:addInputEvent( "Mouse_LUp", "Find_TerritorySupplyNPC(" .. terrIndex .. ")" )
		_btnNavi[terrIndex] = tempNavi
		
		_slotBg[terrIndex] = {}
		_itemSlot[terrIndex] = {}
		for supplyIndex = 0, maxSlotCount - 1 do
			local temp2 = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_TradeMarket_EventInfo, "Static_TerritorySupplySlotBg" .. terrIndex .. "_" .. supplyIndex )
			CopyBaseProperty( slotBg, temp2 )
			temp2:SetPosX( slotBg:GetPosX() + supplyIndex * gapX )
			temp2:SetPosY( slotBg:GetPosY() + terrIndex * gapY )
			temp2:SetShow( false )
			_slotBg[terrIndex][supplyIndex] = temp2
			
			local temp3 = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_TradeMarket_EventInfo, "Static_TerritorySupplySlot" .. terrIndex .. "_" .. supplyIndex )
			CopyBaseProperty( itemSlot, temp3 )
			temp3:SetPosX( itemSlot:GetPosX() + supplyIndex * gapX )
			temp3:SetPosY( itemSlot:GetPosY() + terrIndex * gapY )
			temp3:SetShow( true )
			
			local slotNo = terrIndex * terrCount + supplyIndex
			local slot = {}
			SlotItem.new( slot, "TradeSupply_Icon_" .. slotNo, slotNo, temp3, slotConfig )
			slot:createChild()
			slot.icon:addInputEvent( "Mouse_On", "Tooltip_Item_Show_TerrSupply(" .. supplyIndex .. ", " .. terrIndex .. ", true)" )
			slot.icon:addInputEvent( "Mouse_Out", "Tooltip_Item_Show_TerrSupply(" .. supplyIndex .. ", " .. terrIndex .. ", false)" )
			slot.icon:SetIgnore( true )
			
			_itemSlot[terrIndex][supplyIndex] = slot
		end
	end
end
TradeEventInfo_Init()

local tradeSupplyCount = {}
local tradeSupplyItemGroup = {}
function TradeEventInfo_Set()
	local eventInfo = FGlobal_TradeEventInfo()
	if nil == eventInfo then
		eventDesc:SetShow( false )
		eventAlert:SetShow( true )
		eventAlert:SetText( "\n\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_6").. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_7")) -- "※무역상이 판매하지 않는 무역품은 최대 시세에 제한을 받습니다." ) -- "- 아직 거대 상단의 움직임을 포착하지 못했습니다." )
		eventNavi:SetShow( false )
	else
		eventDesc:SetText( eventInfo .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_7")) -- "※무역상이 판매하지 않는 무역품은 최대 시세에 제한을 받습니다." )
		eventDesc:SetShow( true )
		eventAlert:SetShow( false )
		eventNavi:SetShow( true )
	end
	
	local curChannelData	= getCurrentChannelServerData()
	local isMain			= curChannelData._isMain
	local supplyStart		= false
	tradeSupplyItemGroup	= {}
	for terrIndex = 0, terrCount - 1 do
		tradeSupplyCount[terrIndex] = ToClient_worldmap_getTradeSupplyCount( terrIndex )
		if 0 < tradeSupplyCount[terrIndex] then
			tradeSupplyItemGroup[terrIndex] = {}
			_townName[terrIndex]:SetShow( true )
			_townName[terrIndex]:SetText( territoryName[terrIndex] .. Show_TerritorySupplyNpcName(terrIndex) )
			-- if ( isMain ) or ( CppEnums.GameServiceType.eGameServiceType_DEV == getGameServiceType() ) then		-- 1채널 및 개발버전만 내비버튼 표시
				_btnNavi[terrIndex]:SetShow( true )
				_btnNavi[terrIndex]:SetPosX( _townName[terrIndex]:GetPosX() + _townName[terrIndex]:GetTextSizeX() + 5 )
			-- else
				-- _btnNavi[terrIndex]:SetShow( false )
			-- end
			
			for supplyIndex = 0, tradeSupplyCount[terrIndex] - 1 do
				_slotBg[terrIndex][supplyIndex]:SetShow( true )
				local slot = _itemSlot[terrIndex][supplyIndex]
				local supplyItemWrapper = ToClient_worldmap_getTradeSupplyItem( terrIndex, supplyIndex )
				if nil == supplyItemWrapper then
					return
				end
				local supplyItemSSW = supplyItemWrapper:getStaticStatus()
				-- local itemKey = supplyItemSSW:get()._key:get()
				-- local tradeItemWrapper = npcShop_getTradeItem( itemKey )				-- 일단 이놈들은 실행이 안된다~. 나중에 필요해지면 바운딩 요청
				-- if nil ~= tradeItemWrapper then
					-- local leftCount = Int64toInt32(tradeItemWrapper:getLeftCount())
					-- slot.count:SetText(leftCount)
				-- end
				
				slot.icon:SetIgnore( false )
				slot:setItemByStaticStatus( supplyItemSSW )
				Panel_Tooltip_Item_SetPosition( supplyIndex, slot, "tradeEventInfo")
				table.insert( tradeSupplyItemGroup[terrIndex], supplyItemSSW:get()._key:get() )
			end
			supplyStart = true
		end
	end
	
	if supplyStart then
		supplyAlert:SetShow( false )
		supplyBg:SetSize( supplyBg:GetSizeX(), terrCount * gapY + 10 )
	else
		supplyAlert:SetShow( true )
		supplyBg:SetSize( supplyBg:GetSizeX(), bgSizeY )
	end
	Panel_TradeMarket_EventInfo:SetSize( Panel_TradeMarket_EventInfo:GetSizeX(), supplyBg:GetPosY() + supplyBg:GetSizeY() + 25 )
end

-- 해당 아이템키의 무역품이 황실납품중인지 체크
function FGlobal_TradeSupplyItemInfo_Compare( itemKey )
	TradeEventInfo_Set()
	for terrIndex = 0, terrCount - 1 do
		if nil ~= tradeSupplyItemGroup[terrIndex] then
			for i = 1, #tradeSupplyItemGroup[terrIndex] do
				if tradeSupplyItemGroup[terrIndex][i] == itemKey then
					return terrIndex
				end
			end
		end
	end
	return nil
end

function Find_TerritorySupplyNPC( territoryKey )
	if ToClient_IsShowNaviGuideGroup(0) then
		ToClient_DeleteNaviGuideByGroup(0)
	end
	local regionKeyRaw	= territorySupplyNpcRegionKey[territoryKey]
	local spawnType		= CppEnums.SpawnType.eSpawnType_TerritorySupply
	local count = npcList_getNpcCount(regionKeyRaw)
	for idx = 0 , count - 1 do
		local npcData = npcList_getNpcInfo(idx)
		if npcData:getSpawnType() == spawnType then
			local npcPosition	= npcData:getPosition()
			ToClient_WorldMapNaviStart( npcPosition, NavigationGuideParam(), false, false )
			break
		end
	end	
	
	audioPostEvent_SystemUi(00,14)
end

function Show_TerritorySupplyNpcName( territoryKey )
	local regionKeyRaw	= territorySupplyNpcRegionKey[territoryKey]
	local spawnType		= CppEnums.SpawnType.eSpawnType_TerritorySupply
	local count			= npcList_getNpcCount(regionKeyRaw)
	local npcName		= ""
	for idx = 0 , count - 1 do
		local npcData = npcList_getNpcInfo(idx)
		if npcData:getSpawnType() == spawnType then
			npcName = " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_NPC", "npcName", npcData:getName())
			return npcName
		end
	end
	return npcName
end

function Find_TradeEvnetNpc()
	local npcKey = FGlobal_TradeEvent_Npckey_Return()
	if nil ~= npcKey then
		if ToClient_IsShowNaviGuideGroup(0) then
			ToClient_DeleteNaviGuideByGroup(0)
		end
		
		local regionKeyRaw = tradeEvnetNpcRegionKey[npcKey]
		if nil == regionKeyRaw then
			return nil
		end
		
		local count = npcList_getNpcCount(regionKeyRaw)
		for idx = 0 , count - 1 do
			local npcData = npcList_getNpcInfo(idx)
			if npcData:getKeyRaw() == npcKey then
				local npcPosition	= npcData:getPosition()
				ToClient_WorldMapNaviStart( npcPosition, NavigationGuideParam(), false, false )
				break
			end
		end	
	end
end


function Tooltip_Item_Show_TerrSupply( slotNo, territoryKey, isOn )
	Panel_Tooltip_Item_Show_GeneralStatic( slotNo, "tradeEventInfo", isOn, territoryKey )
end

function TradeEventInfo_Show()
	if not Panel_TradeMarket_EventInfo:GetShow() then
		Panel_TradeMarket_EventInfo:SetShow( true )
		TradeEventInfo_Resize()
		TradeEventInfo_Set()
		audioPostEvent_SystemUi(01,08)
	else
		TradeEventInfo_Close()
	end
end

function TradeEventInfo_Close()
	Panel_TradeMarket_EventInfo:SetShow( false )
end

function TradeEventInfo_Resize()
	Panel_TradeMarket_EventInfo:SetPosX( getScreenSizeX()/2 - Panel_TradeMarket_EventInfo:GetSizeX()/2 )
	Panel_TradeMarket_EventInfo:SetPosY( getScreenSizeY()/2 - Panel_TradeMarket_EventInfo:GetSizeY()/3*2 )
end

registerEvent( "FromClient_NotifyVariableTradeItemMsg", 	"TradeEventInfo_Set" )
registerEvent( "onScreenResize",							"TradeEventInfo_Resize" )
Panel_Window_PartyInventory:SetShow(false, false)
Panel_Window_PartyInventory:ActiveMouseEventEffect(true)
Panel_Window_PartyInventory:setMaskingChild(true)
Panel_Window_PartyInventory:setGlassBackground(true)

partyInven = {
	-- _slot	= UI.getChildControl( Panel_Window_PartyInventory, "Static_Slot" ),
	itemSlot				= UI.getChildControl( Panel_Window_PartyInventory, "Static_Slot0" ),

--{
	-- invenWeight				= UI.getChildControl( Panel_Window_PartyInventory, "Progress2_Weight" ),	-- 가방 내 아이템 무게
	invenWeightTxt			= UI.getChildControl( Panel_Window_PartyInventory, "Static_Text_Weight" ),
--}

	slotBackground			= Array.new(),
	slots					= Array.new(),
	_listPool				= {},
--{
	slotCount				= 10,
	_slotsCols				= 5,
	_slotsRows				= 0,	-- 계산될거임 아래에서...
	slotStartX				= 10,
	slotStartY				= 10,
	slotGapX				= 42,
	slotGapY				= 47,
--}
	_slotConfig = {	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon		= true,
		createBorder	= true,
		createCount		= true,
	}
}

local btnPartyInven		= UI.getChildControl( Panel_Party, "Button_PartyInven" )						-- 파티 가방
local btnClose			= UI.getChildControl( Panel_Window_PartyInventory, "Button_Win_Close" )
local btnQuestion		= UI.getChildControl( Panel_Window_PartyInventory, "StaticText_Desc" )

function partyInven:Init()
	for listIdx=0, self.slotCount-1 do
		local slot = {}
		-- slot.empty = UI.createAndCopyBasePropertyControl( Panel_Window_PartyInventory, "Static_Slot0", Panel_Window_PartyInventory, "PartyInvenSlot0_" .. listIdx )
		slot.empty	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,	Panel_Window_PartyInventory,	"PartyInventory_Slot_Base_"	.. listIdx )
		CopyBaseProperty( self.itemSlot, slot.empty	)
		slot.empty:SetShow( true )

		local row = math.floor( listIdx / self._slotsCols )
		local col = listIdx % self._slotsCols

		slot.empty:SetPosX( self.slotStartX + self.slotGapX * col )
		slot.empty:SetPosY( self.slotStartY + self.slotGapY * row )

		self.slotBackground[listIdx] = slot
	end

	for ii=0, self.slotCount -1 do
		local slot = {}
		SlotItem.new( slot, "ItemIcon_" .. ii, ii, Panel_Window_PartyInventory, self._slotConfig )
		slot:createChild()

		local row = math.floor( ii / self._slotsCols )
		local col = ii % self._slotsCols
		slot.icon:SetPosX( self.slotStartX + self.slotGapX * col )
		slot.icon:SetPosY( self.slotStartY + self.slotGapY * row )
		slot.icon:SetSize( 35,35 )
		slot.border:SetSize( 35,35 )
		slot.count:SetHorizonRight()
		slot.count:SetVerticalBottom()
		slot.count:SetSpanSize(5,2)

		self.slots[ii] = slot

	end

	btnQuestion:SetEnableArea(0, 0, 130, 20)
end

function partyInven:Clear()
	for listIdx = 0, self.slotCount-1 do	-- 리스트 초기화.
		local slot = self.slots[listIdx]
		slot:clearItem()
	end
end

function partyInven:Update()

	for listIdx = 0, self.slotCount-1 do	-- 리스트 초기화.
		local slot = self.slots[listIdx]
		slot:clearItem()
	end

	for slotIndex=0, self.slotCount-1 do
		local itemWrapper	= ToClient_GetPartyInventory( slotIndex )
		local getPossible	= ToClient_IsLootable( slotIndex ) -- 획득 가능한 아이템인지 체크.
		if nil ~= itemWrapper then

			local slot = self.slots[slotIndex]
			slot:setItem( itemWrapper )

			if getPossible then
				slot.icon:SetMonoTone( false )
			else
				slot.icon:SetMonoTone( true )
			end

			slot.icon:addInputEvent("Mouse_RUp",	"partyInven_slotItemRClick( " .. slotIndex .. ", " .. tostring(getPossible) .. " )")
			slot.icon:addInputEvent("Mouse_On",		"partyInven_slotItemOn( " .. slotIndex .. " )")
			slot.icon:addInputEvent("Mouse_Out",	"partyInven_slotItemOff()")
		end
	end
	local currentWeight = ToClient_GetCurrentWeight()
	-- self.invenWeight:SetProgressRate((currentWeight/10000 * 100)/50)

	self.invenWeightTxt:SetText( string.format( "%.0f", currentWeight/10000 ) .. "/50LT" )
end

function FromClient_ChangePartyInventory()
	btnPartyInven:EraseAllEffect()
	btnPartyInven:AddEffect("fUI_Party_Inventory_01A", false, 0, 0)
	partyInven:Update()
end

function partyInven_slotItemRClick( slotNo, getType )
	local itemWrapper	= ToClient_GetPartyInventory( slotNo )
	if nil == itemWrapper then
		return
	end

	local getPcInven = function( slotNo, itemCount )
		ToClient_GetPartyItem(itemCount, slotNo)
		partyInven:Update()
	end

	if not getType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTYINVENTORY_ACCESS_ACK"), 3 ) -- 해당 아이템은 습득 당시 해당 위치로부터 먼 거리에 있었기에 꺼내기가 제한됩니다.
		return
	end

	local itemCount_s64		= itemWrapper:get():getCount_s64()
	if( 1 ~=  itemCount_s64 ) then
		Panel_NumberPad_Show( true, itemCount_s64, slotNo, getPcInven) 
	else
		ToClient_GetPartyItem(1, slotNo)
		partyInven:Update()
	end
end

function partyInven_slotItemOn( slotNo )
	local self = partyInven
	local slot = self.slots[slotNo]
	local itemWrapper	= ToClient_GetPartyInventory( slotNo )
	if nil == itemWrapper then
		return
	end
	Panel_Tooltip_Item_Show(itemWrapper, slot.icon, false, true, nil)	-- Wrapper, uiBase, isStaticWrapper, isItemWrapper, nil
end

function partyInven_slotItemOff()
	Panel_Tooltip_Item_hideTooltip()
end

function FGlobal_PartyInventoryOpen()
	local partyNum = RequestParty_getPartyMemberCount()
	if 0 == partyNum then
		return
	end

	local lootType = RequestParty_getPartyLootType()
	if 4 ~= lootType then
		return
	end

	Panel_Window_PartyInventory:SetShow( true )

	-- Panel_Window_PartyInventory:SetPosX( btnPartyInven:GetSizeX() + (btnPartyInven:GetPosX() *2) )
	-- Panel_Window_PartyInventory:SetPosY( btnPartyInven:GetSizeY() + (btnPartyInven:GetPosY()*2) )
	-- Panel_Window_PartyInventory:SetSpanSize( 200, 230 )
	partyInven:Update()
end

function FGlobal_PartyInventoryClose()
	Panel_Window_PartyInventory:SetShow( false )
end

function PartyInventorySimpleTooltip( isShow )
	local name, desc, uiControl = nil, nil, nil

	name = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYINVENTORY_TOOLTIP_NAME") -- "파티 가방 도움말"
	desc = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYINVENTORY_TOOLTIP_DESC") -- "1. 파티가 해산되면, 파티 가방은 제거되며 안의 내용물은 복구가 불가능합니다.\n2. 파티 가방 내 아이템은 파티장과 일정 거리 이내일 때에만 찾기가 가능합니다.\n3. 파티 가방이 꽉 차면, 더이상 아이템을 습득할 수 없으니 주의하여야 합니다."
	uiControl = btnQuestion

	if isShow == true then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function partyInven:registEventHandler()
	btnPartyInven		:addInputEvent("Mouse_LUp", "FGlobal_PartyInventoryOpen()")				-- 파티 가방 열기
	btnClose			:addInputEvent("Mouse_LUp", "FGlobal_PartyInventoryClose()")
	btnQuestion			:addInputEvent("Mouse_On", "PartyInventorySimpleTooltip( true )")
	btnQuestion			:addInputEvent("Mouse_Out", "PartyInventorySimpleTooltip( false )")
	btnQuestion			:setTooltipEventRegistFunc("PartyInventorySimpleTooltip( true )")
end

function partyInven:registMessageHandler()
	registerEvent("FromClient_ChangePartyInventory", "FromClient_ChangePartyInventory")
end

partyInven:Init()
partyInven:registEventHandler()
partyInven:registMessageHandler()
--[[
 파티 인벤토리 slotNo에 맞는 아이템을 가져온다.
  - ItemWrapper ToClient_GetPartyInventory( int slotNo )

 해당 아이템을 내 인벤토리로 가져오도록 요청 
  - ToClient_GetPartyItem(int slotNo, int count)
--]]
Panel_Window_NpcShop:SetShow(false, false)
Panel_Window_NpcShop:ActiveMouseEventEffect(true)
Panel_Window_NpcShop:setGlassBackground(true)

local UI_TM		= CppEnums.TextMode
local UI_color 	= Defines.Color
local npcShop	=
{
	-- 설정
	slotConfig =
	{
		createIcon	= true,
		createBorder= true,
		createCount	= false,
		createCash	= true,
		createEnduranceIcon = true,
	},
	config =
	{
		slotCount = 14,
		slotCols = 2,
		slotRows = 0,			-- 초기화 시에 계산됨
		slotStartX = 30,
		slotStartY = 92,
		slotGapX = 13,
		slotGapY = 4,
		pricePosX = 268,
		pricePosY = 27,
		remainCountPosX = 40,
		remainCountPosY = 27,
		trendPosX = 285,
		trendPosY = 20,
		iconPosX = 6,
		iconPosY = 6,
		invenCountX = 257,
		invenCountY = 7,
		--enterCartX = 160,
		--enterCartY = 23
	},
	commandText =
	{
		[0] =PAGetString(Defines.StringSheet_GAME, "NPCSHOP_BUY")
			,PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SELL")
			,PAGetString(Defines.StringSheet_GAME, "NPCSHOP_REPURCHASE")
	},
	template =
	{
		panel				= UI.getChildControl(Panel_Window_NpcShop, "blackpanel"),
		button				= UI.getChildControl(Panel_Window_NpcShop, "Button_List"),
		buttonSelected		= UI.getChildControl(Panel_Window_NpcShop, "Button_List_Effect"),
		staticCurrentPrice	= UI.getChildControl(Panel_Window_NpcShop, "StaticText_CurrentPrice"),
		staticRemainCount	= UI.getChildControl(Panel_Window_NpcShop, "StaticText_RemainCount"),
		staticTrend			= UI.getChildControl(Panel_Window_NpcShop, "StaticText_Trend"),
		staticInvenCount	= UI.getChildControl(Panel_Window_NpcShop, "StaticText_InventoryCount"),
		inputCart			= UI.getChildControl(Panel_Window_NpcShop, "Button_InputCart")
	},
	
	tabIndexBuy = 0,
	tabIndexSell = 1,
	tabIndexRepurchase = 2,
	
	-- 컨텐츠 관련 변수
	lastTabIndex = nil,
	selectedSlotIndex = nil,
	lastSelectedSlotIndex = nil,
	selectedSlotKeyValue = nil,
	lastScrollValue = 0,
	lastStartSlotNo = 0,
	_itemListSize	= 0,
	_startSlotIndex	= 0,
	_inputNumber	= 0,
	
	-- 슬롯
	slots = {},
	
	-- 컨트롤들
	radioButtons =
	{
		[0] = UI.getChildControl(Panel_Window_NpcShop, "RadioButton_Tab_Buy"),
		UI.getChildControl(Panel_Window_NpcShop, "RadioButton_Tab_Sell"),
		UI.getChildControl(Panel_Window_NpcShop, "RadioButton_Tab_Repurchase")
	},
	windowTitle					= UI.getChildControl(Panel_Window_NpcShop,	"Static_Text_Title"),
	buttonClose					= UI.getChildControl(Panel_Window_NpcShop,	"Button_Win_Close"),
	buttonQuestion				= UI.getChildControl(Panel_Window_NpcShop,	"Button_Question"),			-- 물음표 버튼
	buttonBuy					= UI.getChildControl(Panel_Window_NpcShop,	"Button_Command"),
	buttonBuySome				= UI.getChildControl(Panel_Window_NpcShop,	"Button_BuySome"),
	buttonSellAll				= UI.getChildControl(Panel_Window_NpcShop,	"Button_SellAll"),
	scroll						= UI.getChildControl(Panel_Window_NpcShop,	"Scroll_Slot_List"),
	-- staticMoneyTitle			= UI.getChildControl(Panel_Window_NpcShop,	"StaticText_Icon_Money"),
	staticMoney					= UI.getChildControl(Panel_Window_NpcShop,	"Static_Text_Money"),
	-- staticWarehouseMoneyTitle	= UI.getChildControl(Panel_Window_NpcShop,	"StaticText_Icon_Money2"),
	staticWarehouseMoney		= UI.getChildControl(Panel_Window_NpcShop,	"Static_Text_Money2"),
	
	checkButton_Inventory		= UI.getChildControl(Panel_Window_NpcShop,	"RadioButton_Money"),
	checkButton_Warehouse		= UI.getChildControl(Panel_Window_NpcShop,	"RadioButton_Money2"),
}

local orgButtonBuySome	= UI.getChildControl(Panel_Window_NpcShop, "Button_BuySome")		
local floor				= math.floor
local _npcShopHelp_BG	= UI.getChildControl( Panel_Window_NpcShop, "Static_NpcShopDesc_BG" )
local _npcShopHelp		= UI.getChildControl( Panel_Window_NpcShop, "StaticText_NpcShopDesc" )
local inventxt			= UI.getChildControl(Panel_Window_NpcShop,	"StaticText_Inven")
local warehousetxt		= UI.getChildControl(Panel_Window_NpcShop,	"StaticText_Warehouse")

local npcShop_BuyBtn_PosX = npcShop.radioButtons[npcShop.tabIndexBuy]:GetPosX()
local npcShop_SellBtn_PosX = npcShop.radioButtons[npcShop.tabIndexSell]:GetPosX()

Panel_Window_NpcShop.npcShop = npcShop

-- 초기화 함수
function npcShop:init()
	self.config.slotRows = self.config.slotCount / self.config.slotCols
	self.lastTabIndex = self.tabIndexBuy
	
	_npcShopHelp:SetTextMode( UI_TM.eTextMode_AutoWrap )
	_npcShopHelp:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_NPCSHOP_HELPDESC" ) )		
	-- 원본 : 상인 NPC가 사고 파는 물품의 종류는 '친밀도' 및 '주변 탐험 거점'의 상태에 따라 달라질 수 있습니다.\n<PAColor0xFFFF8888>※ 내구도나 세율에 따라 판매/매입 가격이 변동됩니다.<PAOldColor>\n<PAColor0xFFB5FF6D>주거지로 설정된 곳에서는 세율 감면의 혜택을 받습니다.<PAOldColor>
end

local _const = Defines.s64_const
-- 슬롯 생성
function npcShop:createSlot()
	local index = 1
	for ii = 1, self.config.slotRows do
		for jj = 1, self.config.slotCols do
			-- 1 <= index <= row * col
			index = (ii - 1) * self.config.slotCols + jj

			local strId = ''..ii.."_"..jj

			local slot =
			{
				selected = false,
				slotNo = 0,
				keyValue = -1,			-- 슬롯 목록이 변경되었을 때, 같은 슬롯인지 검증하기 위한 변수. ItemEnchantKey 가 들어갈 것임!
				showInvenCount = false,
				isStackable = false
			}
			
			slot.slotNo = index - 1
			slot.button = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Window_NpcShop, "NpcShop_Button_"..strId)
			CopyBaseProperty( self.template.button, slot.button )
			slot.button:addInputEvent( "Mouse_LUp", "NpcShop_OnSlotClicked(".. index ..")" )
			slot.button:addInputEvent( "Mouse_RUp", "NpcShop_OnRSlotClicked(".. index ..")" )
			slot.button:addInputEvent("Mouse_UpScroll","NpcShop_ScrollEvent( true )" )
			slot.button:addInputEvent("Mouse_DownScroll","NpcShop_ScrollEvent( false )" )
			npcShop.template.panel:addInputEvent("Mouse_UpScroll","NpcShop_ScrollEvent( true )" )
			npcShop.template.panel:addInputEvent("Mouse_DownScroll","NpcShop_ScrollEvent( false )" )

			slot.price = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_Price_"..strId)
			CopyBaseProperty( self.template.staticCurrentPrice, slot.price )

			slot.remainCount = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_RemainCount_"..strId)
			CopyBaseProperty( self.template.staticRemainCount, slot.remainCount )

			slot.trend = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_Trend_"..strId)
			CopyBaseProperty( self.template.staticTrend, slot.trend )

			slot.icon = {}
			SlotItem.new( slot.icon, 'ShopItem_' .. index, index, Panel_Window_NpcShop, self.slotConfig )
			slot.icon:createChild()

			slot.selectEffect = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_NpcShop, "Button_Effect_"..strId)
			CopyBaseProperty( self.template.buttonSelected, slot.selectEffect )

			slot.invenCount = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_NpcShop, "StaticText_InventoryCount"..strId)
			CopyBaseProperty( self.template.staticInvenCount, slot.invenCount )

			function slot:setPos( posX, posY, param )
				self.button:SetPosX( posX )
				self.button:SetPosY( posY )

				self.price:SetPosX( posX + param.pricePosX )
				self.price:SetPosY( posY + param.pricePosY )

				self.remainCount:SetPosX( posX + param.remainCountPosX +20 )
				self.remainCount:SetPosY( posY + param.remainCountPosY )

				self.trend:SetPosX( posX + param.trendPosX )
				self.trend:SetPosY( posY + param.trendPosY )

				self.icon.icon:SetPosX( posX + param.iconPosX )
				self.icon.icon:SetPosY( posY + param.iconPosY )

				self.selectEffect:SetPosX( posX )
				self.selectEffect:SetPosY( posY )

				self.invenCount:SetPosX( posX + param.invenCountX )
				self.invenCount:SetPosY( posY + param.invenCountY )
			end

			-- trend 는 문자열이다!!! nil 일수 있다!
			function slot:setItem( itemStaticWrapper, s64_stackCount, s64_price, s64_invenCount, Intimacy, disable )
				-- stackCount 가 음수이면 무제한, 양수이면 남은 개수이다.
				-- 0 이 아니면 항상 사거나 팔수 있다.
				local talker		= dialog_getTalker()
				local characterKey	= talker:getCharacterKey()
				local count			= getIntimacyInformationCount( characterKey )
				local intimacyValue	= talker:getIntimacy()
				local enable		= (_const.s64_0 ~= s64_stackCount) and (not disable)

				self.button:SetText( itemStaticWrapper:getName() )
				self.button:SetTextMode( UI_TM.eTextMode_AutoWrap )
				if enable then
					self.button:SetFontColor(  UI_color.C_FFFFFFFF )
				else
					self.button:SetFontColor( UI_color.C_FFAAAAAA )
				end

				self.icon:setItemByStaticStatus( itemStaticWrapper )
				self.icon.icon:SetMonoTone( not enable )

				self.price:SetText( makeDotMoney(s64_price) )

				local strCount = string.format( "%d", Int64toInt32(s64_stackCount) )
				self.remainCount:SetFontColor( UI_color.C_FF3BD3FF )
				self.remainCount:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_REMAIN_COUNT", "count", strCount ) )

				if s64_stackCount < _const.s64_0 then	-- 0 보다 작으면 무제한이다!
					self.remainCount:SetText( PAGetString(Defines.StringSheet_GAME, "NPCSHOP_SOLDOUT") )
					self.icon.icon:SetMonoTone( false )
					self.trend:SetMonoTone( false )
					self.price:SetMonoTone( false )
					self.remainCount:SetMonoTone( false )
				end

				if nil ~= Intimacy and 0 < Intimacy then
					self.remainCount:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_NEED_INTIMACY", "intimacy", Intimacy ) )	-- 필요 친밀도 : XX
					if intimacyValue < Intimacy then
						self.icon.icon:SetMonoTone( true )
						self.trend:SetMonoTone( true )
						self.price:SetMonoTone( true )
						self.remainCount:SetMonoTone( true )
					end
				end

				-- 조건이 있는지 확인한다.
				local craftType = nil
				local gather = 0; fishing = 1; hunting = 2; cooking = 3; alchemy = 4; manufacture = 5; training = 6; trade = 7;
				local lifeminLevel = 0
				local lifeType = {
									[0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GATHERING"),
									[1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_FISHING"),
									[2] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HUNTING"),
									[3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_COOKING"),
									[4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_ALCHEMY"),
									[5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PROCESSING"),
									[6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_OBEDIENCE"),
									[7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE")
								}

				local craftType = itemStaticWrapper:get():getLifeExperienceType() -- 조건이 여러 개 붙으면 이 부분 array로 수정해야 함
				local lifeminLevel = itemStaticWrapper:get():getLifeMinLevel( craftType )
				if ( 0 < lifeminLevel ) then
					local myLifeLevel = getSelfPlayer():get():getLifeExperienceLevel(craftType)
					self.remainCount:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_NPCSHOP_USELIMIT_LEVEL_VALUE", "craftType", lifeType[craftType], "lifeminLevel", FGlobal_CraftLevel_Replace(lifeminLevel, craftType) ) )	-- ??레벨 ?급 Lv.?부터 착용가능
					if ( myLifeLevel < lifeminLevel ) then
						self.remainCount:SetFontColor( UI_color.C_FFF26A6A )
					else
						self.remainCount:SetFontColor( UI_color.C_FF3BD3FF )
					end
				end

				local itemStatic = itemStaticWrapper:get()
				--itemStatic:isForJustTrade()
				--self.remainCount:SetText( tostring( itemStatic:isStackableXXX() ) )
				self.isStackable = itemStatic:isStackableXXX();
				-- if itemStatic:isForJustTrade() then
					-- self.enterCart:SetShow( true )
				-- else
					-- self.enterCart:SetShow( false )
				-- end

				--local itemStatic = itemStaticWrapper:get()
				if nil ~= s64_invenCount then
					if self.isStackable == true then
						local strCount = string.format( "%d", Int64toInt32(s64_invenCount) )
						self.invenCount:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "NPCSHOP_HAVE_COUNT", "count", strCount ) )
						self.invenCount:SetShow( true )
						self.showInvenCount = true
					else
						self.invenCount:SetShow( false )
						self.showInvenCount = false
					end
				else
					self.invenCount:SetShow( false )
					self.showInvenCount = false
				end

				self.keyValue = itemStatic._key:get()		-- slotNo 가 변경되었을때, 내용도 바뀌었는지 확인하기 위해 TItemEnchantKey 를 caching 해둔다

				self:setShow( true )
			end

			function slot:setShow( bShow )
				bShow = bShow or false
				self.button:SetShow(bShow)
				self.price:SetShow(bShow)
				self.remainCount:SetShow(bShow)
				-- self.trend:SetShow(bShow)
				self.trend:SetShow( false )
				self.icon.icon:SetShow(bShow)
				self.selectEffect:SetShow(bShow and self.selected)
				self.invenCount:SetShow(bShow and self.showInvenCount)
				--self.enterCart:SetShow( bShow )
			end

			function slot:setSelect( bSelect )
				self.selectEffect:SetShow( bSelect )
				self.selected = bSelect
			end

			function slot:clearItem()
				self:setSelect(false)
				self:setShow(false)
				self.keyValue = -1
			end

			local posX = self.config.slotStartX + (slot.button:GetSizeX() + self.config.slotGapX) * (jj-1)
			local posY = self.config.slotStartY + (slot.button:GetSizeY() + self.config.slotGapY) * (ii-1)
			slot:setPos( posX, posY, self.config )
			self.slots[index] = slot
		end
	end
end

function SellAll_ShowToggle()	-- 모두 팔기 버튼 토글
	local self = npcShop
	if self.tabIndexSell == self.lastTabIndex then
		npcShop.buttonSellAll:SetShow(true)		-- 켜준다
	else
		npcShop.buttonSellAll:SetShow(false)		-- 꺼준다
	end
end

function BuySome_ShowToggle()	-- 다수 구매 버튼 토글
	local self = npcShop
	if self.tabIndexBuy == self.lastTabIndex then
		self.buttonBuySome:SetShow(true)		-- 켜준다
		self.buttonBuySome:SetEnable( false )
		self.buttonBuySome:SetMonoTone( true )
	else
		self.buttonBuySome:SetShow(false)		-- 꺼준다
	end
end

-- 컨트롤 상태 초기화. 창이 열릴때마다 수행
function npcShop:controlInit()
	self.radioButtons[self.tabIndexBuy]:SetCheck( true )
	self.radioButtons[self.tabIndexSell]:SetCheck( false )
	self.radioButtons[self.tabIndexRepurchase]:SetCheck( false )
	self.radioButtons[self.tabIndexBuy]:EraseAllEffect()
	self.radioButtons[self.tabIndexBuy]:AddEffect( "UI_Shop_Button", true, 0.0, 0.0 )
	self.radioButtons[self.tabIndexSell]:EraseAllEffect()
	self.radioButtons[self.tabIndexRepurchase]:EraseAllEffect()
	self.lastTabIndex = self.tabIndexBuy

	NpcShop_OnSlotClicked()		-- 선택된 Slot 의 선택을 취소!
	-- self.scroll:SetControlPos( 0 )	-- 맨 위로 올림!
	self.lastScrollValue = 0
	self.lastStartSlotNo = 0
	self._startSlotIndex = 0

	for _,slot in pairs(self.slots) do
		slot:clearItem()
	end
	SellAll_ShowToggle()
	BuySome_ShowToggle()
	
	-- NPC 기능 체크. 판매하기 기능이 없다면 버튼을 꺼준다.
	local talker		= dialog_getTalker()
	if nil ~= talker then
		local actorProxyWrapper = getNpcActor(talker:getActorKey())
		
		if nil ~= actorProxyWrapper then
			local characterSSW = actorProxyWrapper:getCharacterStaticStatusWrapper()
			-- local actorProxy = actorProxyWrapper:get()
			-- local characterStaticStatus = actorProxy:getCharacterStaticStatusWrapper()
			if characterSSW:isSellingNormalShop() then			-- 팔기 기능이 있나?
				self.radioButtons[self.tabIndexSell]:SetShow( true )
				self.radioButtons[self.tabIndexRepurchase]:SetShow( true )
				self.radioButtons[self.tabIndexBuy]:SetPosX(npcShop_BuyBtn_PosX)
			else
				self.radioButtons[self.tabIndexSell]:SetShow( false )
				self.radioButtons[self.tabIndexRepurchase]:SetShow( false )
				self.radioButtons[self.tabIndexBuy]:SetPosX(npcShop_SellBtn_PosX)
			end
		end
	end
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()

	if screenSizeY <= 800 then
		Panel_Window_NpcShop:SetPosY( screenSizeY/2 - Panel_Window_NpcShop:GetSizeY()/2 - 30 )
	else
		Panel_Window_NpcShop:SetPosY( screenSizeY/2 - Panel_Window_NpcShop:GetSizeY()/2 - 100 )
	end
	-- npcShop.buttonBuy:SetShow( false )		
	-- npcShop.buttonBuySome:SetShow( false )
end

-- 스크롤 값에 의해, 뿌려야 할 아이템들을 결정하고, 뿌려준다!
function npcShop:updateContent( updateForce )
	local self = npcShop
	updateForce = updateForce or true
	
	-- tabIndex 가 이러면 안되는데;;;;
	if	(nil == self.lastTabIndex) or
		(self.lastTabIndex < self.tabIndexBuy) or
		(self.lastTabIndex > self.tabIndexRepurchase) then
		UI.ASSERT( false, "======== [LOVELYK2] =======\nWrong NpcShop Tab Index!! : " .. self.lastTabIndex )
		return
	end

-- 사운드 추가 필요
	Panel_Window_NpcShop:SetShow( true, false )	-- UI.debugMessage('SetShow')

	--itemListSize = 0
	if self.tabIndexBuy == self.lastTabIndex then		-- 구매탭
		self._itemListSize	= npcShop_getBuyCount()
	elseif self.tabIndexSell == self.lastTabIndex then	-- 판매탭
		self._itemListSize = npcShop_getSellCount()
	else -- if self.tabIndexRepurchase == self.lastTabIndex then	-- 재구매탭
		self._itemListSize = npcShop_getRepurchaseCount()
	end
	
	self.buttonBuy:SetText(self.commandText[self.lastTabIndex])

	-- 뿌릴 아이템이 없다.
	if self._itemListSize <= 0 then
		-- 슬롯을 다 숨겨주자!
		for _,slot in pairs(self.slots) do
			slot:clearItem()
		end
		NpcShop_OnSlotClicked()		-- 선택되어있던 슬롯의 선택을 취소한다
		-- 스크롤도 사용못하게 만들어버리자!
		self.scroll:SetEnable(false)
		self.scroll:SetMonoTone(true)
		self.scroll:SetShow(false)
		return
	end

	-- 강제로 데이터를 바꿔야 하는 상황이거나
	-- 스크롤 값 변경에 의해 뿌려야 할 아이템의 리스트가 바뀌면
	if updateForce or (self._startSlotIndex ~= self.lastStartSlotNo) then
		if self.tabIndexBuy ~= self.lastTabIndex then
			if ((self._itemListSize) >= (self.config.slotRows)) and ((self._itemListSize) < (self._startSlotIndex + self.config.slotRows)) then
				self._startSlotIndex = self._startSlotIndex - 1
				self.scroll:SetControlBottom( )	-- 맨 아래로 보냄
			end
		end	
		
		self.lastStartSlotNo = self._startSlotIndex

		local newSelectSlot = nil
		-- 이전에 선택되어 있던 슬롯이 있으면, 선택된 슬롯을 유지시켜준다
		if nil ~= self.selectedSlotIndex and self.tabIndexRepurchase ~= self.lastTabIndex then
			local maxSlotNo = math.min(self._startSlotIndex + self.config.slotCount, self._itemListSize)
			local lastSelectedSlotNo = self.slots[ self.selectedSlotIndex ].slotNo
			if (self._startSlotIndex <= lastSelectedSlotNo) and (lastSelectedSlotNo < maxSlotNo) then
				-- 새로 뿌릴 범위 이내에 이전에 선택되었던 슬롯이 존재!
				-- 슬롯 인덱스는 1 부터 시작하므로 +1 을 해줘야 한다
				-- 슬롯을 세팅한 후에, newSelectSlot 을 선택한다.
				newSelectSlot = lastSelectedSlotNo - self._startSlotIndex + 1
			end
			NpcShop_OnSlotClicked()
		end

		local inventory = getSelfPlayer():get():getInventory()

		-- 슬롯 세팅
		for ii = 1, self.config.slotCount do
			local slot = self.slots[ii]
			slot.slotNo = self._startSlotIndex + ii - 1		-- slotNo 는 0 부터 시작하므로, 1 을 빼줘야 한다.

			if slot.slotNo < self._itemListSize then
				-- 데이터가 있다!!!
				local shopItemWrapper
				local s64_inventoryItemCount = nil
				if self.tabIndexBuy == self.lastTabIndex then		-- 구매탭
					shopItemWrapper = npcShop_getItemBuy( slot.slotNo )
				elseif self.tabIndexSell == self.lastTabIndex then	-- 판매탭
					shopItemWrapper = npcShop_getItemSell( slot.slotNo )	-- 상점의 slot 번호가 아니다!
					s64_inventoryItemCount = inventory:getItemCount_s64( shopItemWrapper:getStaticStatus():get()._key )
				else --if self.tabIndexRepurchase == self.lastTabIndex then	-- 재구매
					slot.slotNo = self._itemListSize - self._startSlotIndex - ii
					shopItemWrapper = npcShop_getItemRepurchase( slot.slotNo )
				end
				
				if( nil ~= shopItemWrapper ) then
					local shopItem = shopItemWrapper:get()
					if self.tabIndexSell == self.lastTabIndex then
						slot:setItem( shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, shopItem.sellpriceToNpc_s64, s64_inventoryItemCount )
					else
						slot:setItem( shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, shopItem.price_s64, s64_inventoryItemCount, shopItem:getNeedIntimacy() )
					end
					
					if (self.tabIndexBuy == self.lastTabIndex) and (_const.s64_0 == shopItem.leftCount_s64) then
						slot.button:addInputEvent( "Mouse_LUp", "" )
						slot.button:addInputEvent( "Mouse_RUp", "" )
					else
						slot.button:addInputEvent( "Mouse_LUp", "NpcShop_OnSlotClicked(".. ii ..")" )
						slot.button:addInputEvent( "Mouse_RUp", "NpcShop_OnRSlotClicked(".. ii ..")" )
					end
					
					slot.button:addInputEvent( "Mouse_On",	"Panel_Tooltip_Item_Show_GeneralStatic(".. slot.slotNo ..",\"shop\", true)")
					slot.button:addInputEvent( "Mouse_Out",	"Panel_Tooltip_Item_Show_GeneralStatic(".. slot.slotNo ..",\"shop\", false)")

					Panel_Tooltip_Item_SetPosition( slot.slotNo, slot.icon, "shop" )
				end

				-- 돈이 없으면, 가격색을 붉게!
				local itemPrice_s64			= shopItemWrapper:get().price_s64
				local moneyItemWrapper		= getInventoryItemByType( CppEnums.ItemWhereType.eInventory, getMoneySlotNo() )

				local myInvenMoney_s64		= toInt64(0, 0)
				if nil ~= moneyItemWrapper then
					myInvenMoney_s64		=  moneyItemWrapper:get():getCount_s64() 
				end

				local myWareHouseMoney_s64	=  warehouse_moneyFromNpcShop_s64() 

				if npcShop_isGuildShopContents() then
					local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
					if nil ~= myGuildListInfo then
						if ( self.tabIndexBuy == self.lastTabIndex ) and myGuildListInfo:getGuildBusinessFunds_s64() < itemPrice_s64 then
							slot.price:SetFontColor( UI_color.C_FFD20000 )
						else
							slot.price:SetFontColor( UI_color.C_FFE7E7E7 )
						end
					else
						slot.price:SetFontColor( UI_color.C_FFD20000 )
					end
				else
					if ( self.tabIndexBuy == self.lastTabIndex ) and myInvenMoney_s64 < itemPrice_s64 and myWareHouseMoney_s64 < itemPrice_s64 then --  
						slot.price:SetFontColor( UI_color.C_FFD20000 )
					else
						slot.price:SetFontColor( UI_color.C_FFE7E7E7 )
					end
				end

			else
				-- 데이터가 없다!!!
				slot:clearItem()
			end
		end

		if nil ~= newSelectSlot then
			-- 스크롤 되면서 이전 선택된 슬롯을 변경된 위치에 복원시켜준다!
			NpcShop_OnSlotClicked( newSelectSlot )
		elseif self.selectedSlotIndex then
			-- 스크롤이 변경되어 슬롯을 업데이트 하는게 아닌데, 선택된 슬롯의 아이템 키값이 변경되었다면!
			-- 그냥 선택을 취소시켜버린다!
			local lastSelectedSlot = self.slots[self.selectedSlotIndex]
			if lastSelectedSlot.keyValue ~= self.selectedSlotKeyValue then
				NpcShop_OnSlotClicked()
			end
		end

		local dialogData = ToClient_GetCurrentDialogData()
		if (nil == dialogData) then
			npcShop.windowTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_WINDOWTITLE") ) -- "상 점" )
			return
		end
		local npcTitle = dialogData:getContactNpcTitle()
		local npcName = dialogData:getContactNpcName()
		npcShop.windowTitle:SetText( npcTitle .. " " .. npcName )
	end
	
	-- scroll 설정
	UIScroll.SetButtonSize( self.scroll, self.config.slotCount, self._itemListSize )
	
	if (self._itemListSize) == (self._startSlotIndex + self.config.slotRows) then
		self.scroll:SetControlBottom( )	-- 맨 아래로 보냄
	end

end

-- 슬롯이 클릭됬을 때! 1 <= slotIdx <= config.slotCount
function NpcShop_OnSlotClicked( slotIdx )
	local self = npcShop
	local slot
	
	if (self.lastSelectedSlotIndex ~= slotIdx) then
		Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);
	end
	self.lastSelectedSlotIndex = slotIdx
	

	self.selectedSlotKeyValue = -1
	if nil ~= self.selectedSlotIndex then
		slot = self.slots[ self.selectedSlotIndex ]
		slot:setSelect( false )
		self.buttonBuy:SetEnable( false )		-- 슬롯 선택이 취소되면, 구매 버튼을 비활성화 한다.
		self.buttonBuy:SetMonoTone( true )
		self.buttonSellAll:SetEnable( false )
		self.buttonSellAll:SetMonoTone( true )
		self.buttonBuySome:SetEnable( false )
		self.buttonBuySome:SetMonoTone( true )
	end
	if nil ~= slotIdx then
		-- UI.debugMessage( 'ON ' .. slotIdx )
		slot = self.slots[ slotIdx ]
		slot:setSelect( true )
		self.selectedSlotKeyValue = slot.keyValue
		self.buttonBuy:SetEnable( true )		-- 슬롯이 선택되면, 구매 버튼을 활성화 한다.
		self.buttonBuy:SetMonoTone( false )
		self.buttonSellAll:SetEnable( true )		-- 슬롯이 선택되면, 구매 버튼을 활성화 한다.
		self.buttonSellAll:SetMonoTone( false )
		
		self.buttonBuy:SetShow( true )				
		self.buttonBuySome:SetEnable( false )
		self.buttonBuySome:SetMonoTone( true )
		
		--slot.remainCount:SetText( tostring( slot.isStackable ) )
		
		if slot.isStackable == false then
			self.buttonBuySome:SetShow( false )
			self.buttonSellAll:SetEnable( false )
			self.buttonSellAll:SetMonoTone( true )
			--self.buttonBuySome:SetEnable( false )
			--self.buttonBuySome:SetMonoTone( true )
		else 
			if self.tabIndexBuy == self.lastTabIndex then
				CopyBaseProperty( orgButtonBuySome, self.buttonBuySome)
				self.buttonBuySome:SetShow( true )
				self.buttonBuySome:SetEnable( true )
				self.buttonBuySome:SetMonoTone( false )
				self.buttonSellAll:SetEnable( true )
				self.buttonSellAll:SetMonoTone( false )
			end
			--self.buttonBuySome:SetEnable( true )
			--self.buttonBuySome:SetMonoTone( false )
		end
		--CopyBaseProperty( slot.button, npcShop.template.button )
	end
	self.selectedSlotIndex = slotIdx
end

function NpcShop_OnRSlotClicked(slotIdx)
	NpcShop_OnSlotClicked( slotIdx )
	NpcShop_BuyOrSellItem()
end

-- function NpcShop_enterCart( index )
	-- --UI.debugMessage( "enterCart" .. index )
	-- local slot = self.slots[index]
	-- global_enterBasketInShop( slot.keyValue, index )
-- end

-- 구매 / 판매 Tab 버튼이 눌렸을 때!
function NpcShop_TabButtonClick( tabIndex )
	local self = npcShop
	if tabIndex ~= self.lastTabIndex then
		--_PA_LOG("Lua", "NpcShop_TabButtonClick")
		NpcShop_OnSlotClicked()			-- 선택된 Slot 의 선택을 취소!
		self.lastTabIndex = tabIndex
		if 0 == tabIndex then
			self.radioButtons[self.tabIndexBuy]:EraseAllEffect()
			self.radioButtons[self.tabIndexBuy]:AddEffect( "UI_Shop_Button", true, 0.0, 0.0 )
			self.radioButtons[self.tabIndexSell]:EraseAllEffect()
			self.radioButtons[self.tabIndexRepurchase]:EraseAllEffect()
		elseif 1 == tabIndex then
			self.radioButtons[self.tabIndexSell]:EraseAllEffect()
			self.radioButtons[self.tabIndexSell]:AddEffect( "UI_Shop_Button", true, 0.0, 0.0 )
			self.radioButtons[self.tabIndexBuy]:EraseAllEffect()
			self.radioButtons[self.tabIndexRepurchase]:EraseAllEffect()
		elseif 2 == tabIndex then
			self.radioButtons[self.tabIndexRepurchase]:EraseAllEffect()
			self.radioButtons[self.tabIndexRepurchase]:AddEffect( "UI_Shop_Button", true, 0.0, 0.0 )
			self.radioButtons[self.tabIndexBuy]:EraseAllEffect()
			self.radioButtons[self.tabIndexSell]:EraseAllEffect()
			
			---------------------------------------------------------------------------
			-------------------- 재구매시 목록 갱신 패킷 전송 -------------------------
			---------------------------------------------------------------------------
			ToClient_NpcShop_UpdateRepurchaseList()			
		end
		-- 클릭되서 온 것이니까, RadioButton 은 자동으로 변경되었을 것임!
		self.scroll:SetControlPos( 0 )		-- 맨 위로 올림!
		self.lastStartSlotNo = 0		-- 처음부터 시작한다!
		self._startSlotIndex = 0
		self:updateContent( true )	-- 데이터를 채운다!

	end
	SellAll_ShowToggle()
	BuySome_ShowToggle()
	NpcShop_CheckInit()
end

-- 스크롤 이벤트 처리!
function NpcShop_ScrollEvent( isUpScroll )
	local self = npcShop
	
	self._startSlotIndex	= UIScroll.ScrollEvent( self.scroll, isUpScroll, self.config.slotRows, self._itemListSize, self._startSlotIndex, self.config.slotCols )
	if self._startSlotIndex < self.config.slotCols then
		self._startSlotIndex	= self._startSlotIndex * self.config.slotCols
	end
	Panel_Tooltip_Item_hideTooltip()
	self:updateContent( false )
end


function NpcShop_UpdateContent()
	local talker		= dialog_getTalker()
	
	if nil == talker then
		return
	end
	
	-- 무역템 판매후 esc 를 거의 동시에 누를 경우 
	local actorProxyWrapper = getNpcActor(talker:getActorKey())
	
	if nil ~= actorProxyWrapper then
		local actorProxy = actorProxyWrapper:get()
		local characterStaticStatus = actorProxy:getCharacterStaticStatus()

		if true == characterStaticStatus:isTradeMerchant() then
			return
		end
	end
	
	if true == global_IsTrading then
		return
	end
	NpcShop_WindowShow()
	
	npcShop.scroll:SetControlPos( 0 )
	npcShop:updateContent( true )
	Inventory_SetFunctor( Panel_NpcShop_InvenFilter_IsExchangeItem, Panel_NpcShop_InvenRClick, NpcShop_WindowClose, nil );
	NpcShop_UpdateMoney()			-- 이게 오면 돈도 같이 바꿔준다
	NpcShop_UpdateMoneyWarehouse()
end

function NpcShop_UpdateMoney()
	npcShop.buttonBuy:SetEnable( true )
	npcShop.buttonBuy:SetMonoTone( false )
		
	if( npcShop_isGuildShopContents() ) then
		-- npcShop.staticMoneyTitle		:SetShow(false)
		npcShop.staticMoney				:SetShow(false)
		npcShop.checkButton_Inventory	:SetShow(false)
		npcShop.checkButton_Warehouse	:SetShow(false)
	else
		-- npcShop.staticMoneyTitle		:SetShow(true)
		npcShop.staticMoney				:SetShow(true)
		npcShop.staticMoney				:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
		npcShop.checkButton_Inventory	:SetShow(true)
		npcShop.checkButton_Inventory	:SetEnableArea( 0, 0, 230, npcShop.checkButton_Inventory:GetSizeY())
		npcShop.checkButton_Warehouse	:SetShow(true)
		npcShop.checkButton_Warehouse	:SetEnableArea( 0, 0, 230, npcShop.checkButton_Warehouse:GetSizeY())
	end
	
end

function NpcShop_UpdateMoneyWarehouse()
	if( npcShop_isGuildShopContents() ) then
		npcShop.checkButton_Warehouse:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_GUILDMONEY") ) -- "길드 자금" )
		local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
		if nil == myGuildListInfo then
			npcShop.staticWarehouseMoney:SetText( ": 0" )
			return
		end
		npcShop.staticWarehouseMoney:SetText( makeDotMoney(myGuildListInfo:getGuildBusinessFunds_s64()) )
	else
		npcShop.checkButton_Warehouse:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_WAREHOUSE_IN_MONEY") ) -- "창고에 보유하고 있는 금액" )
		npcShop.staticWarehouseMoney:SetText( makeDotMoney(warehouse_moneyFromNpcShop_s64()) )
	end
end

-- 구매/판매 버튼을 눌렀을 때!
function	NpcShop_BuyOrSellItem()
	local self = npcShop
	if nil ~= self.selectedSlotIndex then
		local slot = self.slots[self.selectedSlotIndex]
		if self.tabIndexBuy == self.lastTabIndex then			-- 구매
			local	fromWhereType	= 0
			if( self.checkButton_Warehouse:IsCheck() )	then
				fromWhereType	= 2
			end
			if( npcShop_isGuildShopContents() ) then
				fromWhereType	= CppEnums.ItemWhereType.eGuildWarehouse -- 길드 상점일 경우 길드 자금만 사용한다.
				if not npcShop_GuildCheckByBuy() then
					return
				end
			end

			npcShop_doBuy( slot.slotNo, 1, fromWhereType, 0 )			-- slotNo 는 상점의 슬롯 번호이다!
			--self.buttonBuy:SetEnable( false )		-- 구매 버튼이 눌려지면, 상점 정보가 갱신되기 전까지
			--self.buttonBuy:SetMonoTone( false )		-- 구매 버튼을 비활성화 한다!
		elseif self.tabIndexSell == self.lastTabIndex then		-- 판매
			local shopItemWrapper			= npcShop_getItemSell( slot.slotNo )
			local shopItem					= shopItemWrapper:get()
			local shopItemSSW				= npcShop_getItemWrapperByShopSlotNo( slot.slotNo )
			local shopItemEndurance			= shopItemSSW:get():getEndurance()
			local pricePiece				= Int64toInt32(shopItem.sellpriceToNpc_s64)

			local toWhereType	= 0
			if( self.checkButton_Warehouse:IsCheck() )	then
				toWhereType	= 2
			end
			if( npcShop_isGuildShopContents() ) then
				if not npcShop_GuildCheckByBuy() then
					return
				end
				toWhereType	= CppEnums.ItemWhereType.eGuildWarehouse -- 길드 상점일 경우 길드 자금만 사용한다.
			else	
				if( self.checkButton_Warehouse:IsCheck() ) or ( 500000 <= ( pricePiece ) ) then
					toWhereType	= 2
				end
			end

			local sellDoit = function()
				local itemSSW = npcShop_getItemWrapperByShopSlotNo( slot.slotNo )
				local isSocketed = false
				local sellConfirm = function()	npcShop_doSellByItemNo( slot.slotNo, 1, toWhereType )	end
				for jewelIndex = 0, 5 do
					local itemEnchantSSW = itemSSW:getPushedItem( jewelIndex )
					if ( nil ~= itemEnchantSSW ) then
						isSocketed = true
					end
				end
				if true == isSocketed then					-- 소켓에 보석이 박혀있다면
					local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_1")
					local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"), content = messageBoxMemo, functionYes = sellConfirm, functionNo = donSell, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
					MessageBox.showMessageBox(messageBoxData)
				else
					npcShop_doSellByItemNo( slot.slotNo, 1, toWhereType )		-- slotNo 는 상점의 slotNo 가 아니다. 인벤토리에 존재하는 아이템 목록에 대한 상점 슬롯 목록의 index 이다.
					-- UI.debugMessage('asdf');
					self.buttonBuy:SetEnable( false )
					self.buttonBuy:SetMonoTone( false )
					self.buttonSellAll:SetEnable( false )
					self.buttonSellAll:SetMonoTone( false )
				end

				if 500000 <= pricePiece then
					Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(pricePiece)) , 6 )
				end
			end
			
			local itemKeyForTradeInfo = shopItemWrapper:getStaticStatus():get()._key:get()
			local tradeMasterInfo	= getItemMarketMasterByItemEnchantKey( itemKeyForTradeInfo )
			if nil ~= tradeMasterInfo and 0 ~= shopItemEndurance then
				local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ITEMMARKET_USE_MSGMEMO") -- "<PAColor0xffd0ee68>아이템 거래소를 이용하면 더 많은 이익을 <PAOldColor>\n거둘 수 있습니다. 그래도 판매하시겠습니까?"
				local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"), content = messageBoxMemo, functionYes = sellDoit, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
				MessageBox.showMessageBox(messageBoxData)
			else
				sellDoit()			
			end

		elseif self.tabIndexRepurchase == self.lastTabIndex then		-- 재구매
			local	fromWhereType	= 0
			if( self.checkButton_Warehouse:IsCheck() )	then
				fromWhereType	= 2
			end
			if( npcShop_isGuildShopContents() ) then
				fromWhereType	= CppEnums.ItemWhereType.eGuildWarehouse -- 길드 상점일 경우 길드 자금만 사용한다.
				if not npcShop_GuildCheckByBuy() then
					return
				end
			end
			
			npcShop_doRepurchase( slot.slotNo, fromWhereType)
			self.buttonBuy:SetEnable( false )
			self.buttonBuy:SetMonoTone( false )
		end
	end
	DragManager:clearInfo()
end

-- 모두 판매 버튼 클릭
function	NpcShop_SellItemAll()
	local	self	= npcShop
	if	(nil ~= self.selectedSlotIndex)	then
		local	slot					= self.slots[self.selectedSlotIndex]
		local	shopItemWrapper			= npcShop_getItemSell( slot.slotNo )
		local	shopItem				= shopItemWrapper:get()
		local	inventory				= getSelfPlayer():get():getInventory()
		local	s64_inventoryItemCount	= inventory:getItemCount_s64( shopItemWrapper:getStaticStatus():get()._key )
		local	itemCount				= Int64toInt32(s64_inventoryItemCount)
		local	pricePiece				= Int64toInt32(shopItem.sellpriceToNpc_s64)
		local	toWhereType				= 0
		local	sellPrice				= pricePiece * itemCount

		local sellAllDoit = function()
			if( npcShop_isGuildShopContents() ) then
				toWhereType	= CppEnums.ItemWhereType.eGuildWarehouse -- 길드 상점일 경우 길드 자금만 사용한다.
			else			
				if( self.checkButton_Warehouse:IsCheck() ) or ( 500000 <= sellPrice ) then
					toWhereType	= 2
				end
			end

			local itemSSW			= npcShop_getItemWrapperByShopSlotNo( slot.slotNo )
			local shopItemEndurance	= itemSSW:get():getEndurance()
			local isSocketed = false
			local sellConfirm = function()	npcShop_doSellAll( slot.keyValue, toWhereType )	end
			for jewelIndex = 0, 5 do
				local itemEnchantSSW = itemSSW:getPushedItem( jewelIndex )
				if ( nil ~= itemEnchantSSW ) then
					isSocketed = true
				end
			end
			if true == isSocketed then					-- 소켓에 보석이 박혀있다면
				local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_1")
				local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"), content = messageBoxMemo, functionYes = sellConfirm, functionNo = donSell, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
				MessageBox.showMessageBox(messageBoxData)
			else
				npcShop_doSellAll( slot.keyValue, toWhereType )

				if 500000 <= sellPrice then
					Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(sellPrice) ), 6 )
				end
			end
		end

		local itemKeyForTradeInfo = shopItemWrapper:getStaticStatus():get()._key:get()
		local tradeMasterInfo	= getItemMarketMasterByItemEnchantKey( itemKeyForTradeInfo )
		if nil ~= tradeMasterInfo and 0 ~= shopItemEndurance then
			local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ITEMMARKET_USE_MSGMEMO") -- "<PAColor0xffd0ee68>아이템 거래소를 이용하면 더 많은 이익을 <PAOldColor>\n거둘 수 있습니다. 그래도 판매하시겠습니까?"
			local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"), content = messageBoxMemo, functionYes = sellAllDoit, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData)
		else
			sellAllDoit()			
		end

		
	end
	DragManager:clearInfo()
end

-- 복수 구매 버튼 클릭
function	NpcShop_BuySome()
	local	self			= npcShop
	local	shopItemWrapper	= npcShop_getItemBuy( self._startSlotIndex + self.selectedSlotIndex - 1 )
	local	shopItem		= shopItemWrapper:get()
	local	money_s64		= getSelfPlayer():get():getInventory():getMoney_s64()
	local myGuildListInfo	= ToClient_GetMyGuildInfoWrapper()

	if( self.checkButton_Warehouse:IsCheck() )	then
		money_s64			= warehouse_moneyFromNpcShop_s64()
	end
	if( npcShop_isGuildShopContents() ) then
		money_s64			= myGuildListInfo:getGuildBusinessFunds_s64()
	end
	local	s64_maxNumber	= money_s64 / shopItem.price_s64
	
	if 0 < shopItem:getNeedIntimacy() then					-- 친밀도가 필요한 아이템이라면,
		local talker		= dialog_getTalker()
		local intimacyValue	= talker:getIntimacy()
		local reduceIntimacyValue = math.abs( shopItem:getItemIntimacy() )		-- 값이 마이너스로 들어오므로 절대값으로 저장
		local maxNumber = toInt64(0, math.floor(intimacyValue / reduceIntimacyValue))
		if maxNumber < s64_maxNumber then
			s64_maxNumber = maxNumber
		end
	end
	
	Panel_NumberPad_Show(true, s64_maxNumber, param, NpcShop_BuySome_ConfirmFunction)
end

function NpcShop_BuySome_ConfirmFunction(inputNumber, param)
	local	self				= npcShop
	self._inputNumber	= inputNumber
	local	slot			= self.slots[self.selectedSlotIndex]
	local	buyCount		= self._inputNumber
	local	fromWhereType	= CppEnums.ItemWhereType.eInventory
	if( self.checkButton_Warehouse:IsCheck() )	then
		fromWhereType	= CppEnums.ItemWhereType.eWarehouse
	end
	
	if( npcShop_isGuildShopContents() ) then
		fromWhereType	= CppEnums.ItemWhereType.eGuildWarehouse	--길드 상점일 경우 길드 자금만 사용한다.
		if not npcShop_GuildCheckByBuy() then
			return
		end
	end

	local shopItemWrapper	= npcShop_getItemBuy( slot.slotNo )
	local shopItem			= shopItemWrapper:get()
	local selectItem		= shopItemWrapper:getStaticStatus():getName()	
	local totalPrice		= shopItem.price_s64 * inputNumber
	local titleString		= PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_BUY_ALERT_TITLE")
	local contentString		= PAGetStringParam3(Defines.StringSheet_GAME, "LUA_NPCSHOP_BUY_ALERT_1", "item", tostring(selectItem), "number", tostring(self._inputNumber), "price", makeDotMoney(totalPrice) )
	local messageboxData	= { title = titleString, content = contentString, functionYes = NpcShop_BuySome_Do, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	
	if (toInt64(0, 499) < self._inputNumber) or ( toInt64(0, 99999) < totalPrice ) then		
		MessageBox.showMessageBox(messageboxData)
	else
		npcShop_doBuy( slot.slotNo, buyCount, fromWhereType, 0 )
	end	
	
	self.buttonBuy:SetEnable( false )
	self.buttonBuy:SetMonoTone( true )
end


function NpcShop_BuySome_Do()
	local	self			= npcShop
	local	buyCount		= self._inputNumber
	local	slot			= self.slots[self.selectedSlotIndex]
	local	fromWhereType	= CppEnums.ItemWhereType.eInventory
	
	if( self.checkButton_Warehouse:IsCheck() )	then
		fromWhereType	= CppEnums.ItemWhereType.eWarehouse		
	end
	
	if( npcShop_isGuildShopContents() ) then
		fromWhereType	= CppEnums.ItemWhereType.eGuildWarehouse	--길드 상점일 경우 길드 자금만 사용한다.
		if not npcShop_GuildCheckByBuy() then
			return
		end
	end
	
	npcShop_doBuy( slot.slotNo, buyCount, fromWhereType, 0 )
end

-- 마우스 입력 등록
function npcShop:registEventHandler()
	self.buttonClose:addInputEvent(				"Mouse_LUp",	"handleClickedNpcShow_WindowClose()" )
				
	self.buttonQuestion:addInputEvent(			"Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"NpcShop\" )" )	-- 물음표 좌클릭
	self.buttonQuestion:addInputEvent(			"Mouse_On",		"HelpMessageQuestion_Show( \"NpcShop\", \"true\")" )	-- 물음표 마우스오버
	self.buttonQuestion:addInputEvent(			"Mouse_Out",	"HelpMessageQuestion_Show( \"NpcShop\", \"false\")" )	-- 물음표 마우스아웃	
			
	self.buttonBuy:addInputEvent(				"Mouse_LUp",	"NpcShop_BuyOrSellItem()" )
	self.buttonBuySome:addInputEvent(			"Mouse_LUp",	"NpcShop_BuySome()" )
	self.buttonSellAll:addInputEvent(			"Mouse_LUp",	"NpcShop_SellItemAll()" )
	
	self.checkButton_Inventory:addInputEvent(	"Mouse_LUp",	"NpcShop_CheckFromMoney( 0 )" )
	self.checkButton_Inventory:addInputEvent(	"Mouse_On", 	"CheckButton_Inventory_ShowText()" )
	self.checkButton_Inventory:addInputEvent(	"Mouse_Out", 	"CheckButton_Inventory_HideText()" )
	self.checkButton_Warehouse:addInputEvent(	"Mouse_LUp",	"NpcShop_CheckFromMoney( 1 )" )
	self.checkButton_Warehouse:addInputEvent(	"Mouse_On", 	"CheckButton_Warehouse_ShowText()" )
	self.checkButton_Warehouse:addInputEvent(	"Mouse_Out", 	"CheckButton_Warehouse_HideText()" )

	UIScroll.InputEvent( self.scroll, "NpcShop_ScrollEvent" )

	-- Panel_Window_NpcShop:addInputEvent("Mouse_UpScroll","NpcShop_ScrollEvent( true )" )
	-- Panel_Window_NpcShop:addInputEvent("Mouse_DownScroll","NpcShop_ScrollEvent( false )" )
	Panel_Window_NpcShop:addInputEvent("Mouse_UpScroll","" )
	Panel_Window_NpcShop:addInputEvent("Mouse_DownScroll","" )

	for idx,btn in pairs(self.radioButtons) do
		btn:addInputEvent(			"Mouse_LUp",		"NpcShop_TabButtonClick("..idx..")" )
	end
end

function CheckButton_Inventory_ShowText()
	inventxt:SetShow( true )
end
function CheckButton_Inventory_HideText()
	inventxt:SetShow( false )
end
function CheckButton_Warehouse_ShowText()
	warehousetxt:SetShow( true )
end
function CheckButton_Warehouse_HideText()
	warehousetxt:SetShow( false )
end

-- 상점 패널 닫을 때
function NpcShop_WindowClose()
	if Panel_Window_NpcShop:GetShow() then
		Panel_Window_NpcShop:SetShow(false, false)
		InventoryWindow_Close()
		--Inventory_PosLoadMemory()
		audioPostEvent_SystemUi(01,01)
	end
end

-- 닫기 버튼 누를시에 사용합니다.
function handleClickedNpcShow_WindowClose()
	if Panel_Window_NpcShop:GetShow() then
		Panel_Window_NpcShop:SetShow(false, false)
		InventoryWindow_Close()
		--Inventory_PosLoadMemory()
		audioPostEvent_SystemUi(01,01)
		ReqeustDialog_retryTalk()
	end
end

-- NPC 대화에서, 상점 버튼이 눌렸을 때!!!
function	NpcShop_WindowShow()
	if not Panel_Window_NpcShop:GetShow() then
		npcShop:controlInit()
		-- Inventory_PosSaveMemory()	-- 인벤 위치 저장은 Panel_Dialog_Main에서 한다.
		--UIAni.fadeInSCRDialog_Left(Panel_Window_Inventory)
		InventoryWindow_Show()
		audioPostEvent_SystemUi(01,00)
		-- npcShop_requestList()	-- 서버에 상점 목록을 요청! NpcDialog 안쪽에서 이미 수행하고 있는데 그쪽을 제거하고 이 코드를 활성화 해야 한다.
		NpcShop_CheckInit()
	end
end

-- \\remark @param slotNo : gc::TInventorySlotNo
function Panel_NpcShop_InvenFilter_IsExchangeItem(slotNo, itemWrapper)
	if nil == itemWrapper then
		return true
	end
	local isVested			= itemWrapper:get():isVested()
	local isPersonalTrade	= itemWrapper:getStaticStatus():isPersonalTrade()

	if (isUsePcExchangeInLocalizingValue()) then
		local isFilter = ( isVested and isPersonalTrade )
		if( isFilter ) then
			return isFilter
		end
	end

	local isAble = npcShop_IsItemExchangeWithSystem(itemWrapper:get():getKey())
	return (not isAble);
end

local itemCount = nil;
function Panel_NpcShop_InvenRClick(slotNo)
	local itemWrapper = getInventoryItem( slotNo )

	itemCount = itemWrapper:get():getCount_s64()
	if( Defines.s64_const.s64_1 ==  itemCount ) then
		Panel_NpcShop_InvenRClick_SellItem(1, slotNo)
	else
		Panel_NumberPad_Show(true, itemCount, slotNo, Panel_NpcShop_InvenRClick_SellItem) 
	end
end

function donSell()
end

function Panel_NpcShop_InvenRClick_SellItem(itemCount, slotNo)
	local self			= npcShop
	local playerWrapper = getSelfPlayer()
	local itemWrapper	= getInventoryItem( slotNo )
	local itemSSW		= itemWrapper:getStaticStatus()
	local itemEndurance	= itemWrapper:get():getEndurance()
	local sellPrice_64	= itemSSW:get()._sellPriceToNpc_s64
	local sellPrice_32	= Int64toInt32(sellPrice_64)
	local itemCount_32	= Int64toInt32(itemCount)
	local sellPrice		= sellPrice_32 * itemCount_32
	
	-- 상점에서 팔때 인벤의 것만 판다.
	local fromWhereType = CppEnums.ItemWhereType.eInventory
	
	-- 상점 타입에 따라 넣는 돈이 다르다.
	local toWhereType	= CppEnums.ItemWhereType.eInventory
	if( npcShop_isGuildShopContents() ) then
		if not npcShop_GuildCheckByBuy() then
			return
		end
		toWhereType	= CppEnums.ItemWhereType.eGuildWarehouse -- 길드 상점일 경우 길드 자금만 사용한다.
	else
		if ( self.checkButton_Warehouse:IsCheck() ) or 500000 <= sellPrice then
			toWhereType	= CppEnums.ItemWhereType.eWarehouse
		else
			toWhereType	= CppEnums.ItemWhereType.eInventory
		end
	end

	local sellDoit = function()
		local isSocketed = false
		local sellConfirm = function()	playerWrapper:get():requestSellItem(slotNo, itemCount, fromWhereType, toWhereType)	end
		for jewelIndex = 0, 5 do
			local itemEnchantSSW = itemWrapper:getPushedItem( jewelIndex )
			if ( nil ~= itemEnchantSSW ) then
				isSocketed = true
			end
		end
		if true == isSocketed then					-- 소켓에 보석이 박혀있다면
			local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_1")
			local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"), content = messageBoxMemo, functionYes = sellConfirm, functionNo = donSell, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData)
		else
			playerWrapper:get():requestSellItem(slotNo, itemCount, fromWhereType, toWhereType)
		end

		if 500000 <= sellPrice and toWhereType ~= CppEnums.ItemWhereType.eGuildWarehouse then
			Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_MONEYFORWAREHOUSE_ACK", "getMoney", makeDotMoney(sellPrice) ), 6 )
		end
	end

	local itemKeyForTradeInfo	= itemWrapper:getStaticStatus():get()._key:get()
	local tradeMasterInfo		= getItemMarketMasterByItemEnchantKey( itemKeyForTradeInfo )
	if nil ~= tradeMasterInfo and 0 ~= itemEndurance then
		local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_ITEMMARKET_USE_MSGMEMO") -- "<PAColor0xffd0ee68>아이템 거래소를 이용하면 더 많은 이익을 <PAOldColor>\n거둘 수 있습니다. 그래도 판매하시겠습니까?"
		local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_NPCSHOP_SELL_ALERT_2"), content = messageBoxMemo, functionYes = sellDoit, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		sellDoit()			
	end
end

-- 이벤트 등록
function npcShop:registMessageHandler()
	registerEvent("EventNpcShopUpdate",			"NpcShop_UpdateContent")
	registerEvent("FromClient_InventoryUpdate",	"NpcShop_UpdateMoney")
	registerEvent("EventWarehouseUpdate",		"NpcShop_UpdateMoneyWarehouse")
end

function	NpcShop_CheckInit()
	local	self	= npcShop
	if	( self.checkButton_Inventory:IsCheck() )	then
		return
	end

	self.checkButton_Inventory:SetCheck(true)
	self.checkButton_Warehouse:SetCheck(false)
end

function	NpcShop_CheckFromMoney( check )
	local	self	= npcShop
	if(	0 == check)	then
		if	( self.checkButton_Inventory:IsCheck() )	then
			self.checkButton_Warehouse:SetCheck(false)
		else
			self.checkButton_Warehouse:SetCheck(true)
		end
	else
		if( self.checkButton_Warehouse:IsCheck() )	then
			self.checkButton_Inventory:SetCheck(false)
		else
			self.checkButton_Inventory:SetCheck(true)
		end
	end
end

function npcShop_GuildCheckByBuy()
	
	local myGuildInfo	= ToClient_GetMyGuildInfoWrapper()
	if( nil == myGuildInfo ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_NPCSHOP_GUILD1") ) --"길드가 없습니다.")
		return false;
	end
	local guildGrade	= myGuildInfo:getGuildGrade()
	if 0 == guildGrade then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_NPCSHOP_GUILD2") ) --"길드 등급만 이용할 수 있습니다.")
		return false;
	end
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()

	if not isGuildMaster and not isGuildSubMaster then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_NPCSHOP_GUILD3") ) --"길드 대장 혹은 부대장만 이용할 수 있습니다.")
		return false;
	end

	return true
end

npcShop:init()
npcShop:createSlot()
npcShop:registEventHandler()
npcShop:registMessageHandler()

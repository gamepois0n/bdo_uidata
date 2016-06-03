local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_BUFFTYPE	= CppEnums.UserChargeType

Panel_Window_ItemMarket_ItemSet:SetShow( false )
Panel_Window_ItemMarket_ItemSet:SetDragEnable( true )

Panel_Window_ItemMarket_ItemSet:RegisterShowEventFunc( true, 'ItemMarketItemSetShowAni()' )
Panel_Window_ItemMarket_ItemSet:RegisterShowEventFunc( false, 'ItemMarketItemSetHideAni()' )

function ItemMarketItemSetShowAni()
end
function ItemMarketItemSetHideAni()
end

local ItemMarketItemSet 	= {
	panelBG					= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Static_PanelBG"),
	btn_Close				= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Button_Win_Close"),
	btn_Question			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Button_Question"),
	btn_RegistItem			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Button_RegistItem"),
	registItemCount			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"StaticText_RegistItemCount_Value"),
	saleItemCount			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"StaticText_SaleItemCount_Value"),
	RegistDelayNotify		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"StaticText_RegistDelayNotify"),
	waitingCount			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"StaticText_WaitingCount_Value"),

	-- 돈 지불 방법.
	invenMoney				= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Static_Text_Money"),
	warehouseMoney			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Static_Text_Money2"),
	-- radioBtn_Inven			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"RadioButton_Inventory"),
	-- radioBtn_Warehouse		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"RadioButton_Warehouse"),
	btn_Inven				= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"RadioButton_Icon_Money"),
	btn_Warehouse			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"RadioButton_Icon_Money2"),
	
	scroll					= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Scroll_ItemMarket_ItemSet"),
	scrollInverVal			= 0,
	nowScrollPos			= 0,

	startIdx				= 0,
	totalCount				= 0,
	ItemListUiPool			= {},
	ItemListMaxCount		= 7,
	slotConfing			= {
		createIcon		= true,
		createBorder	= true,
		createCount		= true,
		createEnchant	= true,
		createCash		= true,
	},

	_buttonQuestion 		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet, 	"Button_Question" ),		-- 물음표 버튼
	escMenuSaveValue = false,
}
ItemMarketItemSet.scrollCtrlBTN = UI.getChildControl( ItemMarketItemSet.scroll,		"Scroll_CtrlButton")

local bgTexture = {
	[0] =	{ [0] = {134, 2, 198, 60},		{110, 265, 174, 323},	{110, 325, 174, 383} }, -- 판매완료
			{ [0] = {1, 123, 65, 181},		{68, 123, 65, 181},		{134, 123, 198, 181} }, -- 중간정산
			{ [0] = {310, 440, 374, 498},	{377, 440, 441, 498},	{444, 440, 508, 498} }, -- 판매취소 및 등록대기
}

local Template				= {
	ItemBG					= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_ItemBG"),
	ItemPeriodEndBG			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_ItemBG_PeriodEnd"),
	SlotBG					= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_SlotBG"),
	Slot					= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_Slot"),
	ItemName				= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_StaticText_ItemName"),
	AveragePrice_Title		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_AveragePrice_TitleIcon"),
	AveragePrice_Value		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_StaticText_AveragePrice_Value"),
	SoldOut					= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_StaticText_SoldOut"),
	RecentPrice_Title		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_RecentPrice_TitleIcon"),
	RecentPrice_Value		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_StaticText_RecentPrice_Value"),
	SellPrice_Title			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_SellPrice_TitleIcon"),
	SellPrice_Value			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_StaticText_SellPrice_Value"),
	RegistPeriod_Title		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_RegistPeriod_TitleIcon"),
	RegistPeriod_Value		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_StaticText_RegistPeriod_Value"),
	BTN_RegistCancle		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Button_RegistCancle"),
	BTN_Withdrawals			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Button_Withdrawals"),
	BTN_Settlement			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Templete_Button_Settlement"),
	RegistTerritoryText		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"MultilineText_RegistTerritoryText" ),
	SellCountIcon			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_SellCountIcon"),
	SellCountValue			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_StaticText_SellCountValue"),
	SellCompleteIcon		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_SellCompleteIcon"),
	SellCompleteValue		= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_StaticText_SellCompleteValue"),
	DivisionLine1			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_Line_1"),
	DivisionLine2			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"Template_Static_Line_2"),
}

local territoryKey =
{
	[0]	= tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),				-- 발레노스령
	[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),				-- 세렌디아령
	[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),				-- 칼페온령
	[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3")),				-- 메디아령
	[4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENCIA_NAME")),		-- 발렌시아령
}

function ItemMarketItemSet:Initialize()
	self.panelBG:setGlassBackground( true )
	self.panelBG:ActiveMouseEventEffect( true )
	-- 아이템 리스트 생성
	local itemList_PosY = 80
	for itemList_Idx = 0, self.ItemListMaxCount - 1 do
		local tempSlot = {}
		local Created_ItemBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.panelBG, 'ItemMarketSetItem_ItemBG_' .. itemList_Idx )
		CopyBaseProperty( Template.ItemBG, Created_ItemBG )
		Created_ItemBG:SetPosX( 10 )
		Created_ItemBG:SetPosY( itemList_PosY )
		Created_ItemBG:addInputEvent("Mouse_DownScroll",	"ItemMarketItemSet_ScrollUpdate( true )")
		Created_ItemBG:addInputEvent("Mouse_UpScroll",		"ItemMarketItemSet_ScrollUpdate( fasle )")
		Created_ItemBG:SetShow( false )
		tempSlot.itemBG = Created_ItemBG

		local Created_ItemBG_PeriodEnd = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_ItemPeriodEndBG_' .. itemList_Idx )
		CopyBaseProperty( Template.ItemPeriodEndBG, Created_ItemBG_PeriodEnd)
		Created_ItemBG_PeriodEnd:SetPosX( 0 )
		Created_ItemBG_PeriodEnd:SetPosY( 0 )
		Created_ItemBG_PeriodEnd:addInputEvent("Mouse_DownScroll",	"ItemMarketItemSet_ScrollUpdate( true )")
		Created_ItemBG_PeriodEnd:addInputEvent("Mouse_UpScroll",	"ItemMarketItemSet_ScrollUpdate( false )")
		Created_ItemBG_PeriodEnd:SetShow( false )
		tempSlot.itemPeriodEndBG = Created_ItemBG_PeriodEnd

		local Created_ItemSlotBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_SlotBG_' .. itemList_Idx )
		CopyBaseProperty( Template.SlotBG, Created_ItemSlotBG )
		Created_ItemSlotBG:SetPosX( 10 )
		Created_ItemSlotBG:SetPosY( 7 )
		Created_ItemSlotBG:SetShow( true )
		tempSlot.SlotBG = Created_ItemSlotBG

		local createSlot = {}
		SlotItem.new( createSlot, 'ItemMarketSetItem_SlotItem_' .. itemList_Idx, 0, Created_ItemSlotBG, self.slotConfing )
		createSlot:createChild()
		tempSlot.Slot = createSlot


		local Created_ItemName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemBG, 'ItemMarketSetItem_ItemName_' .. itemList_Idx )
		CopyBaseProperty( Template.ItemName, Created_ItemName )
		Created_ItemName:SetPosX( 60 )
		Created_ItemName:SetPosY( 7 )
		Created_ItemName:SetTextMode( UI_TM.eTextMode_AutoWrap )
		Created_ItemName:SetShow( true )
		tempSlot.itemName = Created_ItemName
		-- 평균 등록가 / 최근 등록가
		local Created_AveragePrice_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_AveragePrice_Title_' .. itemList_Idx )
		CopyBaseProperty( Template.AveragePrice_Title, Created_AveragePrice_Title )
		Created_AveragePrice_Title:SetPosX( 210 )
		Created_AveragePrice_Title:SetPosY( 10 )
		Created_AveragePrice_Title:SetShow( true )
		tempSlot.averagePrice_Title = Created_AveragePrice_Title

		local Created_AveragePrice_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemBG, 'ItemMarketSetItem_AveragePrice_Value_' .. itemList_Idx )
		CopyBaseProperty( Template.AveragePrice_Value, Created_AveragePrice_Value )
		Created_AveragePrice_Value:SetPosX( 270 )
		Created_AveragePrice_Value:SetPosY( 10 )
		Created_AveragePrice_Value:SetShow( true )
		tempSlot.averagePrice_Value = Created_AveragePrice_Value

		local Created_SoldOut = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemBG, 'ItemMarketSetItem_SoldOut_' .. itemList_Idx )
		CopyBaseProperty( Template.SoldOut, Created_SoldOut )
		Created_SoldOut:SetPosX( 245 )
		Created_SoldOut:SetPosY( 20 )
		Created_SoldOut:SetShow( false )
		tempSlot.SoldOut = Created_SoldOut

		local Created_RecentPrice_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_RecentPrice_Title_' .. itemList_Idx )
		CopyBaseProperty( Template.RecentPrice_Title, Created_RecentPrice_Title )
		Created_RecentPrice_Title:SetPosX( 210 )
		Created_RecentPrice_Title:SetPosY( 32 )
		Created_RecentPrice_Title:SetShow( true )
		tempSlot.recentPrice_Title = Created_RecentPrice_Title

		local Created_RecentPrice_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemBG, 'ItemMarketSetItem_RecentPrice_Value_' .. itemList_Idx )
		CopyBaseProperty( Template.RecentPrice_Value, Created_RecentPrice_Value )
		Created_RecentPrice_Value:SetPosX( 270 )
		Created_RecentPrice_Value:SetPosY( 32 )
		Created_RecentPrice_Value:SetShow( true )
		tempSlot.recentPrice_Value = Created_RecentPrice_Value
		-- 구분 라인 1
		local Created_DivisionLine1 = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_Division_FirstLine_' .. itemList_Idx )
		CopyBaseProperty( Template.DivisionLine1, Created_DivisionLine1 )
		Created_DivisionLine1:SetPosX( 385 )
		Created_DivisionLine1:SetPosY( 12 )
		Created_DivisionLine1:SetShow( true )
		tempSlot.divisionLine1 = Created_DivisionLine1
		-- 판매 갯수 / 만료일
		local Created_SellCountIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_SellCountIcon_' .. itemList_Idx )
		CopyBaseProperty( Template.SellCountIcon, Created_SellCountIcon )
		Created_SellCountIcon:SetPosX( 410 )
		Created_SellCountIcon:SetPosY( 8 )
		Created_SellCountIcon:SetShow( true )
		tempSlot.sellCountIcon = Created_SellCountIcon

		local Created_SellCountValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemBG, 'ItemMarketSetItem_SellCountValue_' .. itemList_Idx )
		CopyBaseProperty( Template.SellCountValue, Created_SellCountValue )
		Created_SellCountValue:SetPosX( 430 )
		Created_SellCountValue:SetPosY( 8 )
		Created_SellCountValue:SetShow( true )
		tempSlot.sellCountValue = Created_SellCountValue

		local Created_RegistPeriod_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_RegistPeriod_Title_' .. itemList_Idx )
		CopyBaseProperty( Template.RegistPeriod_Title, Created_RegistPeriod_Title )
		Created_RegistPeriod_Title:SetPosX( 410 )
		Created_RegistPeriod_Title:SetPosY( 31 )
		Created_RegistPeriod_Title:SetShow( true )
		tempSlot.registPeriod_Title = Created_RegistPeriod_Title

		local Created_RegistPeriod_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemBG, 'ItemMarketSetItem_RegistPeriod_Value_' .. itemList_Idx )
		CopyBaseProperty( Template.RegistPeriod_Value, Created_RegistPeriod_Value )
		Created_RegistPeriod_Value:SetPosX( 430 )
		Created_RegistPeriod_Value:SetPosY( 30 )
		Created_RegistPeriod_Value:SetShow( true )
		tempSlot.registPeriod_Value = Created_RegistPeriod_Value
		-- 구분 라인 2
		local Created_DivisionLine2 = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_Division_SecondLine_' .. itemList_Idx )
		CopyBaseProperty( Template.DivisionLine2, Created_DivisionLine2 )
		Created_DivisionLine2:SetPosX( 540 )
		Created_DivisionLine2:SetPosY( 12 )
		Created_DivisionLine2:SetShow( true )
		tempSlot.divisionLine2 = Created_DivisionLine2
		--판매 등록가 / 판매 완료가
		local Created_SellPrice_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_SellPrice_Title_' .. itemList_Idx )
		CopyBaseProperty( Template.SellPrice_Title, Created_SellPrice_Title )
		Created_SellPrice_Title:SetPosX( 560 )
		Created_SellPrice_Title:SetPosY( 10 )
		Created_SellPrice_Title:SetShow( true )
		tempSlot.sellPrice_Title = Created_SellPrice_Title

		local Created_SellPrice_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemBG, 'ItemMarketSetItem_SellPrice_Value_' .. itemList_Idx )
		CopyBaseProperty( Template.SellPrice_Value, Created_SellPrice_Value )
		Created_SellPrice_Value:SetPosX( 620 )
		Created_SellPrice_Value:SetPosY( 8 )
		Created_SellPrice_Value:SetShow( true )
		tempSlot.sellPrice_Value = Created_SellPrice_Value

		local Created_SellCompleteIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemBG, 'ItemMarketSetItem_SellCompleteIcon_' .. itemList_Idx )
		CopyBaseProperty( Template.SellCompleteIcon, Created_SellCompleteIcon )
		Created_SellCompleteIcon:SetPosX( 560 )
		Created_SellCompleteIcon:SetPosY( 31 )
		Created_SellCompleteIcon:SetShow( true )
		tempSlot.sellCompleteIcon = Created_SellCompleteIcon

		local Created_SellCompleteValue = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemBG, 'ItemMarketSetItem_SellCompleteValue_' .. itemList_Idx )
		CopyBaseProperty( Template.SellCompleteValue, Created_SellCompleteValue )
		Created_SellCompleteValue:SetPosX( 620 )
		Created_SellCompleteValue:SetPosY( 30 )
		Created_SellCompleteValue:SetShow( true )
		tempSlot.sellCompleteValue = Created_SellCompleteValue
		-----버튼
		local Created_CancleBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ItemBG, 'ItemMarketSetItem_BTN_Cancle_' .. itemList_Idx )
		CopyBaseProperty( Template.BTN_RegistCancle, Created_CancleBTN )
		Created_CancleBTN:SetPosX( 730 )
		Created_CancleBTN:SetPosY( 9 )
		Created_CancleBTN:SetShow( true )
		tempSlot.BTN_Cancle = Created_CancleBTN

		local Created_WithdrawalsBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ItemBG, 'ItemMarketSetItem_BTN_Withdrawals_' .. itemList_Idx )
		CopyBaseProperty( Template.BTN_Withdrawals, Created_WithdrawalsBTN )
		Created_WithdrawalsBTN:SetPosX( 730 )
		Created_WithdrawalsBTN:SetPosY( 9 )
		Created_WithdrawalsBTN:SetShow( true )
		tempSlot.BTN_Withdrawals = Created_WithdrawalsBTN

		local Created_SettlementBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ItemBG, 'ItemMarketSetItem_BTN_Settlement_' .. itemList_Idx )
		CopyBaseProperty( Template.BTN_Settlement, Created_SettlementBTN )
		Created_SettlementBTN:SetPosX( 730 )
		Created_SettlementBTN:SetPosY( 9 )
		Created_SettlementBTN:SetShow( true )
		tempSlot.BTN_Settlement = Created_SettlementBTN
		-- 영지명 출력
		local Created_RegistTerrText = UI.createControl( UI_PUCT.PA_UI_CONTROL_MULTILINETEXT, Created_ItemBG, 'ItemMarketSetItem_RegistTerritory_' .. itemList_Idx )
		CopyBaseProperty( Template.RegistTerritoryText, Created_RegistTerrText )
		Created_RegistTerrText:SetPosX( 750 )
		Created_RegistTerrText:SetPosY( 12 )
		Created_RegistTerrText:SetShow( true )
		tempSlot.RegistTerritoryText = Created_RegistTerrText

		itemList_PosY	= itemList_PosY + Created_ItemBG:GetSizeY() + 2
		self.ItemListUiPool[itemList_Idx] = tempSlot
	end
end

function ItemMarketItemSet:SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_Window_ItemMarket_ItemSet:GetSizeX()
	local panelSizeY 	= Panel_Window_ItemMarket_ItemSet:GetSizeY()

	Panel_Window_ItemMarket_ItemSet:SetPosX( (scrSizeX / 2) - (panelSizeX / 2) )
	Panel_Window_ItemMarket_ItemSet:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) )
end

function ItemMarketItemSet_ScrollUpdate( isDown )
	ItemMarketItemSet.startIdx = UIScroll.ScrollEvent( ItemMarketItemSet.scroll, not isDown, ItemMarketItemSet.ItemListMaxCount, ItemMarketItemSet.totalCount, ItemMarketItemSet.startIdx, 1 )
	ItemMarketItemSet:Update()
end

local currentMyTerritoryKey = function()
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return -1
	end	
	return regionInfoWrapper:getTerritoryKeyRaw()
end

function ItemMarketItemSet:Update()
	local currentTerritoryKey = currentMyTerritoryKey()
	local itemCount = getItemMarketMyItemsCount();
	local countryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTDELAYNOTIFY", "forPremium", requestGetRefundPercentForPremiumPackage() )
	if (5 == getGameServiceType() or 6 == getGameServiceType()) then
		countryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTDELAYNOTIFY_JP", "forPcRoom", requestGetRefundPercentForPcRoom() )
	elseif isGameTypeEnglish() then
		countryTypeSet = ""
	else
		countryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTDELAYNOTIFY", "forPremium", requestGetRefundPercentForPremiumPackage() )
	end

	self.registItemCount	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTITEMCOUNT", "itemCount", itemCount ) ) -- " "..itemCount.. " 건"
	self.RegistDelayNotify	:SetText( countryTypeSet )

	for ui_Idx = 0, self.ItemListMaxCount-1 do
		local UiBase = self.ItemListUiPool[ui_Idx]
		UiBase.itemBG:SetShow( false )
	end
	
	-- 판매 중 건수
	local saleCount = 0;
	self.totalCount = getItemMarketMyItemsCount();
	for idx = 0, self.totalCount-1 do
		local myItemInfo = getItemMarketMyItemByIndex( idx );
		if( nil ~= myItemInfo ) then
			if myItemInfo:isTraded() and (0 == Int64toInt32( myItemInfo:getTotalPrice() )) then
				saleCount = saleCount+1
			end
		end
	end

	--판매 대기 건수
	local waitingCount = 0
	for idx = 0, self.totalCount-1 do
		local myItemInfo = getItemMarketMyItemByIndex( idx )
		if ( nil ~= myItemInfo ) then
			if myItemInfo:isWaiting() == true then
				waitingCount = waitingCount + 1
			end
		end
	end
	self.saleItemCount:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTITEMCOUNT", "itemCount", tostring(saleCount)) ); -- tostring(saleCount).." 건"
	self.waitingCount:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTITEMCOUNT", "itemCount", tostring(waitingCount)) )

	UIScroll.SetButtonSize( self.scroll, self.ItemListMaxCount, self.totalCount)
	
	for ui_Idx = 0, self.ItemListMaxCount-1 do
		itemMarketSummaryInfo = getItemMarketSummaryInClientByIndex( self.curItemClassify, ui_Idx )
		local UiBase = self.ItemListUiPool[ui_Idx]
			
		local itemList_Idx = self.startIdx + ui_Idx
		local myItemInfo = getItemMarketMyItemByIndex( itemList_Idx );
		if( nil ~= myItemInfo ) then
			
			UiBase.itemBG:SetShow( true )
			local iess = myItemInfo:getItemEnchantStaticStatusWrapper()
			_PA_ASSERT( nil ~= iess, "myItemInfo 아이템 고정정보가 꼭 있어야합니다")
			
			if (nil ~= iess) then
				local nameColorGrade	= iess:getGradeType()
				local nameColor			= nil
				if ( 0 == nameColorGrade ) then
					nameColor = UI_color.C_FFEFEFEF
				elseif ( 1 == nameColorGrade ) then
					nameColor = 4284350320
				elseif ( 2 == nameColorGrade ) then
					nameColor = 4283144191
				elseif ( 3 == nameColorGrade ) then
					nameColor = 4294953010
				elseif ( 4 == nameColorGrade ) then
					nameColor = 4294929408
				else
					nameColor = UI_color.C_FFFFFFFF
				end
				UiBase.itemName:SetFontColor( nameColor )

				local enchantLevel = iess:get()._key:getEnchantLevel()
				if 1 == iess:getItemType() and 15 < enchantLevel then -- 장비이고, 강화수치가 15보다 크면
					UiBase.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. iess:getName() )	-- 아이템 이름
				elseif 0 < enchantLevel and CppEnums.ItemClassifyType.eItemClassify_Accessory == iess:getItemClassify() then
					UiBase.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel+15) .. " " .. iess:getName() )	-- 아이템 이름
				else
					UiBase.itemName:SetText( iess:getName() )															-- 아이템 이름
				end

				-- UiBase.itemName:SetText( iess:getName() )
				--UiBase.itemName:SetText( "성공하는 사람들의\n다양한 습관 모음집" )
				
				UiBase.Slot					:setItemByStaticStatus( iess, myItemInfo:getCount(), -1, false  )
				UiBase.Slot.icon			:addInputEvent("Mouse_On",	"_ItemMarketItemSet_ShowToolTip( " .. ui_Idx .. " )")
				UiBase.Slot.icon			:addInputEvent("Mouse_Out",	"_ItemMarketItemSet_HideToolTip()")
				UiBase.averagePrice_Title	:addInputEvent("Mouse_On",	"ItemMarketItemSet_ToolTip( true, " .. ui_Idx .. ", 0 )")
				UiBase.averagePrice_Title	:addInputEvent("Mouse_Out",	"ItemMarketItemSet_ToolTip( false )")
				UiBase.recentPrice_Title	:addInputEvent("Mouse_On",	"ItemMarketItemSet_ToolTip( true, " .. ui_Idx .. ", 1 )")
				UiBase.recentPrice_Title	:addInputEvent("Mouse_Out",	"ItemMarketItemSet_ToolTip( false )")
				UiBase.sellPrice_Title		:addInputEvent("Mouse_On",	"ItemMarketItemSet_ToolTip( true, " .. ui_Idx .. ", 2 )")
				UiBase.sellPrice_Title		:addInputEvent("Mouse_Out",	"ItemMarketItemSet_ToolTip( false )")
				UiBase.registPeriod_Title	:addInputEvent("Mouse_On",	"ItemMarketItemSet_ToolTip( true, " .. ui_Idx .. ", 3 )")
				UiBase.registPeriod_Title	:addInputEvent("Mouse_Out",	"ItemMarketItemSet_ToolTip( false )")
				UiBase.sellCountIcon		:addInputEvent("Mouse_On",	"ItemMarketItemSet_ToolTip( true, " .. ui_Idx .. ", 4 )")
				UiBase.sellCountIcon		:addInputEvent("Mouse_Out",	"ItemMarketItemSet_ToolTip(false)")
				UiBase.sellCompleteIcon		:addInputEvent("Mouse_On",	"ItemMarketItemSet_ToolTip( true, " .. ui_Idx .. ", 5 )")
				UiBase.sellCompleteIcon		:addInputEvent("Mouse_Out",	"ItemMarketItemSet_ToolTip( false )")

				UiBase.BTN_Withdrawals		:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketItemSet_ItemWithdrawals( " ..iess:get()._key:get()..",".. itemList_Idx .. " )")
				-- UiBase.registPeriod_Title	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TEXT_REGISTPERIOD") ) -- "만료일"
				-- UiBase.SoldOut				:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TEXT_SOLDOUT") ) -- "판매완료"
				UiBase.registPeriod_Value:SetFontColor( Defines.Color.C_FF6C7DE4 )
				local periodSecond = ItemMarketSecondTimeConvert( myItemInfo:getDisplayedEndDate() )
				if toInt64(0,0) == periodSecond then
					UiBase.registPeriod_Value:SetFontColor( Defines.Color.C_FFD20000 )
					UiBase.itemPeriodEndBG:SetShow( true )
				else
					UiBase.registPeriod_Value:SetFontColor( Defines.Color.C_FF6C7DE4 )
					UiBase.itemPeriodEndBG:SetShow( false )
				end
				UiBase.registPeriod_Value	:SetText( converStringFromLeftDateTime( myItemInfo:getDisplayedEndDate() ) )
				UiBase.sellCountValue		:SetText( Int64toInt32( myItemInfo:getTotalCount() ) )
				UiBase.sellCompleteValue	:SetText( makeDotMoney( myItemInfo:getTradedTotalPrice() ) )
				UiBase.BTN_Cancle			:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketItemSet_RegistCancle( " ..iess:get()._key:get()..",".. itemList_Idx .. " )")
				UiBase.BTN_Settlement		:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketItemSet_ItemSettlement( " ..iess:get()._key:get()..",".. itemList_Idx .. " )")

				local leftBeginDate_s64	= converStringFromLeftDateTime( myItemInfo:getDisplayedBeginDate() )
				if myItemInfo:isTraded() and (0 == Int64toInt32( myItemInfo:getTotalPrice() )) then -- 판매완료 -- myItemInfo:isTraded() and 0 == Int64toInt32( myItemInfo:getTradedTotalPrice() ) then
					_ItemMarketItemSet_ChangeBgTexture( 1, ui_Idx ) -- 판매 완료 BG텍스쳐를 바꾼다.
					UiBase.itemPeriodEndBG:SetShow( false )
					UiBase.BTN_Cancle			:SetShow( false )
					UiBase.BTN_Withdrawals		:SetShow( true )
					UiBase.BTN_Settlement		:SetShow( false )

					UiBase.BTN_Withdrawals:SetFontColor(UI_color.C_FF96D4FC)
				elseif myItemInfo:isTraded() and 0 < Int64toInt32( myItemInfo:getTradedTotalPrice() ) and 0 < Int64toInt32( myItemInfo:getTotalPrice() ) then -- 중간 정산
					_ItemMarketItemSet_ChangeBgTexture( 0, ui_Idx ) -- 중간 정산 BG텍스쳐를 바꾼다.

					UiBase.BTN_Settlement	:SetShow( true )
					UiBase.BTN_Cancle		:SetShow( false )
					UiBase.BTN_Withdrawals	:SetShow( false )

					UiBase.BTN_Settlement:SetFontColor(UI_color.C_FFFAE696)
				else -- 등록 취소, 등록 대기 취소
					_ItemMarketItemSet_ChangeBgTexture( 2, ui_Idx ) -- 등록 취소, 등록 대기 취소 BG텍스쳐를 바꾼다.

					UiBase.BTN_Cancle			:SetShow( true )
					UiBase.BTN_Withdrawals		:SetShow( false )
					UiBase.BTN_Settlement		:SetShow( false )
					local highItemPrice = requestDoBroadcastRegister( myItemInfo:getTotalPrice() )	-- 5분간 대기 취소 물품인지 검증한다.
					local waitingItem	= myItemInfo:isWaiting()
					if waitingItem == false then
						UiBase.BTN_Cancle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTCANCEL") ) -- "등록 취소" )
						UiBase.BTN_Cancle:SetFontColor(UI_color.C_FFF03838)
					else
						UiBase.BTN_Cancle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTWAITCANCEL") ) -- "등록 대기 취소" )
						UiBase.BTN_Cancle:SetFontColor(UI_color.C_FFEF5378)
					end
					--{ 5분간 취소 못하는 아이템 검증.
						-- if true == highItemPrice and true == waitingItem then
						-- 	UiBase.BTN_Cancle:SetShow( false )
						-- else
						-- 	UiBase.BTN_Cancle:SetShow( true )
						-- end
					--{
				end
				
				local summaryInfo = getItemMarketSummaryInClientByItemEnchantKey( iess:get()._key:get() )
				_PA_ASSERT( nil ~= summaryInfo, "summaryInfo 정보가 꼭 있어야합니다")
				local temp_recentPrice = nil			
				if nil ~= summaryInfo then
					temp_recentPrice = summaryInfo:getLastTradedOnePrice()
				end

				-- 시세
				local masterInfo		= getItemMarketMasterByItemEnchantKey( iess:get()._key:get() )
				local marketConditions	= nil
				if nil ~= masterInfo then
					marketConditions = (masterInfo:getMinPrice() + masterInfo:getMaxPrice()) / toInt64(0,2)
				end

				local replaceCount = function( num )
					if nil ~= num then
						local count = Int64toInt32( num )
						if 0 == count then
							count = "-"
						else
							count = makeDotMoney( num )
						end
						return count
					else
						return "-"
					end
				end
				
				UiBase.averagePrice_Value	:SetText( replaceCount( marketConditions ) )
				UiBase.recentPrice_Value	:SetText( replaceCount( temp_recentPrice ) )
				UiBase.sellPrice_Value		:SetText( replaceCount( myItemInfo:getTotalPrice()) )
				-- UiBase.sellCountValue		:SetText( makeDotMoney( summaryInfo:getDisplayedTotalAmount() ) )

				-- 월드맵에서 열었거나 등록지가 현재 있는 곳과 다를 경우 등록 취소 버튼 대신 등록지를 표시해준다!
				-- 거래소 통합으로 판매금 수령은 어디서든 가능하게 20150122 - 정승철
				-- local _isSelfTerritory = true
				local _isSelfTerritory = false;
				local _territoryKey = myItemInfo:getTerritoryKey()
				
				if( currentTerritoryKey == _territoryKey ) then
					_isSelfTerritory = true
				end

				if ( true == ToClient_WorldMapIsShow() ) or ( false == _isSelfTerritory ) or ItemMarketItemSet.escMenuSaveValue then
					UiBase.BTN_Cancle			:SetShow( false )	-- 등록 취소
					UiBase.BTN_Withdrawals		:SetShow( false )	-- 판매금 수령
					UiBase.BTN_Settlement		:SetShow( false )	-- 중간정산

					local _territoryKey = myItemInfo:getTerritoryKey()
					local registTerritoryName = nil
					registTerritoryName = ""
					
					for i = 0, 4 do
						if ( i == _territoryKey ) then
							registTerritoryName = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TEXT_REGISTTERRITORY", "territoryKey", territoryKey[i] ) -- territoryKey[i] .. " 등록품"
							-- registTerritoryName = "등록품"
						end
					end
					UiBase.RegistTerritoryText	:SetText( registTerritoryName )
					if (5 == getGameServiceType() or 6 == getGameServiceType()) then
						UiBase.RegistTerritoryText	:SetSize( 140, 20 )
						UiBase.RegistTerritoryText	:SetHorizonRight()
						UiBase.RegistTerritoryText	:SetSpanSize( 5, 10 )					
					end
					UiBase.RegistTerritoryText	:SetShow( true )

					if myItemInfo:isTraded() and (0 == Int64toInt32( myItemInfo:getTotalPrice() )) then	-- 판매 됐다면 버튼을 켠다.
						if true == ToClient_WorldMapIsShow() or ItemMarketItemSet.escMenuSaveValue then
							UiBase.RegistTerritoryText	:SetPosY( 18 )
							UiBase.RegistTerritoryText	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_SELLCOMPLETE") ) -- "판매 완료" )
						else
							UiBase.RegistTerritoryText	:SetShow( false )
							UiBase.BTN_Withdrawals		:SetShow( true )
						end
					end
				else
					UiBase.RegistTerritoryText	:SetShow( false )
				end
			end
		end
	end

	-- 스크롤바 보여주고 안보여주고
	if itemCount <= self.ItemListMaxCount then
		self.scroll:SetShow( false )
	else
		self.scroll:SetShow( true )
	end
end

--------------------------------------------------------------------------------
----- 기존 converStringFromLeftDateTime 함수는 XX일, XX시간 등 
----- 스트링을 뒤에 붙이기 때문에 시간(숫자) 데이터값만 가져올 수 있도록 별도 작성.
--------------------------------------------------------------------------------
function ItemMarketSecondTimeConvert( s64_datetime )
	local leftDate = getLeftSecond_TTime64( s64_datetime )

	local s64_dayCycle 		= toInt64(0, (24*60*60) );
	local s64_hourCycle 	= toInt64(0, (60*60) );
	local s64_minuteCycle	= toInt64(0, 60);
	
	local s64_day			= leftDate / s64_dayCycle;
	local s64_hour			= (leftDate - (s64_dayCycle*s64_day)) / s64_hourCycle;
	local s64_minute		= (leftDate - (s64_dayCycle*s64_day) - ( s64_hourCycle*s64_hour ) ) / s64_minuteCycle;
	local s64_Second		= (leftDate - (s64_dayCycle*s64_day) - ( s64_hourCycle*s64_hour ) - ( s64_minuteCycle*s64_minute ) );

	local	strDate	= "";
	if( Defines.s64_const.s64_0 < s64_day ) and ( Defines.s64_const.s64_0 < s64_hour ) then
		strDate	= s64_day + s64_hour
	elseif( Defines.s64_const.s64_0 < s64_day ) then
		strDate	= s64_day
	elseif( Defines.s64_const.s64_0 < s64_hour ) then
		strDate	= s64_hour + s64_minute
	elseif( Defines.s64_const.s64_0 < s64_minute ) then
		strDate	= s64_minute + s64_Second
	elseif( Defines.s64_const.s64_0 <= s64_Second ) then
		strDate	= s64_Second
	end

	return strDate
end

function ItemMarketItemSet:Open( escMenu )
	-- 자신의 물품 요청
	ItemMarketItemSet.escMenuSaveValue = escMenu
	if( ToClient_WorldMapIsShow() or escMenu ) then
		requestItemMarketMyItems( true, false )
	else
		requestItemMarketMyItems( false, false )
	end
		
	ItemMarketItemSet.startIdx = 0
	ItemMarketItemSet.scroll:SetControlTop()
	ItemMarketItemSet:SetPosition()
	ItemMarketItemSet:Update()
	Panel_Window_ItemMarket_ItemSet:SetShow( true, true )
end

--------------------------------------------------------------------------------
-- 내부 이벤트
--------------------------------------------------------------------------------
function _ItemMarketItemSet_ShowToolTip( ui_Idx )
	local self				= ItemMarketItemSet
	local startIdx			= self.startIdx
	local itemList_Idx		= startIdx + ui_Idx
	local myItemInfo 		= getItemMarketMyItemByIndex( itemList_Idx )
	local UiBase			= self.ItemListUiPool[ui_Idx].Slot.icon
	local itemWrapper		= nil
	if myItemInfo:isTraded() then
		itemWrapper = getItemMarketMyItemByIndex( itemList_Idx ):getItemEnchantStaticStatusWrapper()
		Panel_Tooltip_Item_Show( itemWrapper, UiBase, true, false, nil )
	else
		itemWrapper = getItemMarketMyItemByIndex( itemList_Idx ):getItemWrapper()
		Panel_Tooltip_Item_Show( itemWrapper, UiBase, false, true, nil )
	end
end
function _ItemMarketItemSet_HideToolTip()
	Panel_Tooltip_Item_hideTooltip()
	ItemMarketItemSet_ToolTip( false )
end

--------------------------------------------------------------------------------
-- 물품 리스트 BG텍스쳐 변경
--------------------------------------------------------------------------------
function _ItemMarketItemSet_ChangeBgTexture( bgType, ui_Idx )
	local self		= ItemMarketItemSet
	local control	= self.ItemListUiPool[ui_Idx]

	control.itemBG:ChangeTextureInfoName( "New_UI_Common_forLua/Window/ItemMarket/ItemMarket_00.dds" )
	control.itemBG:ChangeOnTextureInfoName( "New_UI_Common_forLua/Window/ItemMarket/ItemMarket_00.dds" )
	control.itemBG:ChangeClickTextureInfoName( "New_UI_Common_forLua/Window/ItemMarket/ItemMarket_00.dds" )

	local x1, y1, x2, y2 = setTextureUV_Func( control.itemBG, bgTexture[bgType][0][1], bgTexture[bgType][0][2], bgTexture[bgType][0][3], bgTexture[bgType][0][4] )
	control.itemBG:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control.itemBG:setRenderTexture( control.itemBG:getBaseTexture() )

	local x1, y1, x2, y2 = setTextureUV_Func( control.itemBG, bgTexture[bgType][1][1], bgTexture[bgType][1][2], bgTexture[bgType][1][3], bgTexture[bgType][1][4] )
	control.itemBG:getOnTexture():setUV(  x1, y1, x2, y2  )

	local x1, y1, x2, y2 = setTextureUV_Func( control.itemBG, bgTexture[bgType][2][1], bgTexture[bgType][2][2], bgTexture[bgType][2][3], bgTexture[bgType][2][4] )
	control.itemBG:getClickTexture():setUV(  x1, y1, x2, y2  )
end

--------------------------------------------------------------------------------
-- 클릭 이벤트
--------------------------------------------------------------------------------
function HandleClicked_ItemMarketItemSet_RegistCancle( itemEnchantKeyRaw, index )	-- 거래서 물품 등록취소
	if Panel_Win_System:GetShow() then	-- 확인창이 뜬 상태에서는 버튼을 누를 수 없다.
		return
	end

	local self = ItemMarketItemSet
	self.nowScrollPos = self.scroll:GetControlPos()
	local doCancel = function()
		requestCancelMyRegistedItemForItemMarket( itemEnchantKeyRaw, index)
		ItemMarketItemSet_ScrollUpdate()
		return
	end

	local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
	local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTCANCEL_DO") -- 등록을 취소하시겠습니까?
	local	messageBoxData	= { title = messageBoxTitle, content = messageBoxMemo, functionYes = doCancel, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData, "middle")
end

local withdrawalsItemKey	= -1
local withdrawalsIndex		= -1
function HandleClicked_ItemMarketItemSet_ItemWithdrawals( itemEnchantKeyRaw, index )
	if Panel_Win_System:GetShow() then	-- 확인창이 뜬 상태에서는 버튼을 누를 수 없다.
		return
	end
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local	self					= ItemMarketItemSet
	local	temporaryWrapper		= getTemporaryInformationWrapper()
	local	isPcRoom				= temporaryWrapper:isPcRoom()
	local	left_premiumTime		= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_PremiumPackage )
	local	left_SecretDealsTime	= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_StarterPackage )
	local	isPremiumUser			= false
	local	isSecretDealsUser		= false

	if left_premiumTime then
		isPremiumUser = true
	end
	if left_SecretDealsTime then
		isSecretDealsUser = true
	end

	local myItemInfo		= getItemMarketMyItemByIndex( index );
	local itemTotalPrice	= myItemInfo:getTradedTotalPrice()
	local isCountryTypeSet	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO", "forPremium", requestGetRefundPercentForPremiumPackage() )

	if (5 == getGameServiceType() or 6 == getGameServiceType()) then
		isCountryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO_JP", "pcRoom", requestGetRefundPercentForPcRoom() )
	else
		isCountryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO", "forPremium", requestGetRefundPercentForPremiumPackage() )
	end

	--{	messagebox에서 인자값을 못받아와서 내부 로컬함수로 수정.
		local ItemWithdrawalsExecute = function()
			local	self		= ItemMarketItemSet
			local	toWhereType	= CppEnums.ItemWhereType.eInventory
			if( self.btn_Warehouse:IsCheck() or toInt64(0,500000) <= itemTotalPrice )	then
				toWhereType	= CppEnums.ItemWhereType.eWarehouse
			end
			
			requestWithdrawSellingItemMoneyForItemMarket( withdrawalsItemKey, withdrawalsIndex, toWhereType )
			withdrawalsItemKey	= -1
			withdrawalsIndex	= -1

			ItemMarketItemSet_ScrollUpdate()
		end
	--}

	withdrawalsItemKey	= itemEnchantKeyRaw
	withdrawalsIndex	= index
	if false == isPremiumUser then --or false == isPcRoom then
		local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
		local	messageBoxMemo	= isCountryTypeSet
		if false == isSecretDealsUser then
			messageBoxMemo = messageBoxMemo	--  .. PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_SECRETDEALSNOTIFY_1")	-- "\n은밀한 거래 버프 적용 시 펄 상품에 한하여 세금이 면제됩니다."
		end
		local	messageBoxData	= { title = messageBoxTitle, content = messageBoxMemo, functionYes = ItemWithdrawalsExecute, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData, "middle")
	else
		local doWithdrawals = function()
			local	toWhereType	= CppEnums.ItemWhereType.eInventory
			if( self.btn_Warehouse:IsCheck() or toInt64(0,500000) <= itemTotalPrice )	then
				toWhereType	= CppEnums.ItemWhereType.eWarehouse
			end
		
			requestWithdrawSellingItemMoneyForItemMarket( itemEnchantKeyRaw, index, toWhereType )
			withdrawalsItemKey	= -1
			withdrawalsIndex	= -1
		end

		-- if false == isSecretDealsUser then
		-- 	local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
		-- 	local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_SECRETDEALSNOTIFY_2")	-- "\n은밀한 거래 버프 적용 시 펄 상품에 한하여 세금이 면제됩니다.\n\n<PAColor0xffddcd82>지금 판매금 수령을 하시겠습니까?<PAOldColor>"
		-- 	local	messageBoxData	= { title = messageBoxTitle, content = messageBoxMemo, functionYes = doWithdrawals, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		-- MessageBox.showMessageBox(messageBoxData, "top")
		-- else
			doWithdrawals()
		-- end
	end
end

function ItemMarketSetItem_ItemWithdrawalsExecute()
	local	self		= ItemMarketItemSet
	local	toWhereType	= CppEnums.ItemWhereType.eInventory

	if( self.btn_Warehouse:IsCheck() )	then
		toWhereType	= CppEnums.ItemWhereType.eWarehouse
	end
	
	requestWithdrawSellingItemMoneyForItemMarket( withdrawalsItemKey, withdrawalsIndex, toWhereType )
	withdrawalsItemKey	= -1
	withdrawalsIndex	= -1

	ItemMarketItemSet_ScrollUpdate()
end

function HandleClicked_ItemMarketItemSet_ItemSettlement( itemEnchantKeyRaw, index )
	if Panel_Win_System:GetShow() then	-- 확인창이 뜬 상태에서는 버튼을 누를 수 없다.
		return
	end
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	
	local	self		= ItemMarketItemSet
	local	left_SecretDealsTime	= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_StarterPackage )
	local	left_premiumTime		= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_PremiumPackage )
	local	isPremiumUser			= false
	local	isSecretDealsUser		= false

	if left_premiumTime then
		isPremiumUser = true
	end
	if left_SecretDealsTime then
		isSecretDealsUser = true
	end

	local isCountryTypeSet	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO", "forPremium", requestGetRefundPercentForPremiumPackage() )

	if ( isGameTypeJapan() ) then
		isCountryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO_JP", "pcRoom", requestGetRefundPercentForPcRoom() )
	else
		isCountryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_PCROOMMEMO", "forPremium", requestGetRefundPercentForPremiumPackage() )
	end

	local doSettlement = function()
		local	toWhereType	= CppEnums.ItemWhereType.eInventory

		local myItemInfo		= getItemMarketMyItemByIndex( index );
		local itemTotalPrice	= myItemInfo:getTradedTotalPrice()

		if( self.btn_Warehouse:IsCheck() or toInt64(0,500000) <= itemTotalPrice )	then
			toWhereType	= CppEnums.ItemWhereType.eWarehouse
		end
		requestCancelRegistedItemAndWithdrawMoneyForItemMarket( itemEnchantKeyRaw, index, toWhereType )
	end

	if false == isPremiumUser then
		local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
		local	messageBoxMemo	= isCountryTypeSet
		if false == isSecretDealsUser then
			messageBoxMemo = messageBoxMemo	--  .. PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_SECRETDEALSNOTIFY_1")	-- "\n은밀한 거래 버프 적용 시 펄 상품에 한하여 세금이 면제됩니다."
		end
		local	messageBoxData	= { title = messageBoxTitle, content = messageBoxMemo, functionYes = doSettlement, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData, "middle")
	else
		doSettlement()
	end


	ItemMarketItemSet_ScrollUpdate()
end
function HandleClicked_ItemMarketRegistItem_Open()
	FGlobal_ItemMarketRegistItem_Open()
end
function HandleClicked_ItemMarketItemSet_Close()
	
	FGlobal_ItemMarketItemSet_Close()
end
function HandleClicked_ItemMarketItemSet_SetScrollIndexByLClick()
	local self				= ItemMarketItemSet
	local pos				= ItemMarketItemSet.scroll:GetControlPos()
	self.startIdx			= math.ceil( (self.totalCount - self.ItemListMaxCount) * pos )
	self:Update()
end

function ItemMarketItemSet_ToolTip( isShow, ui_Idx, iconType )
	local name = ""
	local desc = ""
	local uiControl = nil
	local UiBase = ItemMarketItemSet.ItemListUiPool[ui_Idx]

	if 0 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_AVGPRICE_NAME") -- "현재 시세"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_AVGPRICE_DESC") -- "해당 아이템의 현재 시세를 기준으로 등록 최저가와 최고가가 결정됩니다."
		uiControl = UiBase.averagePrice_Title
	elseif 1 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_RECENTPRICE_NAME") -- "최근 거래가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_RECENTPRICE_DESC") -- "해당 물품의 최근 거래가격입니다."
		uiControl = UiBase.recentPrice_Title
	elseif 2 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLPRICE_NAME") -- "남은 판매가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLPRICE_DESC") -- "남아 있는 물품이 팔렸을 때 받을 수 있는 금액입니다."
		uiControl = UiBase.sellPrice_Title
	elseif 3 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_REGISTPERIOD_NAME") -- "만료일"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_REGISTPERIOD_DESC") -- "해당 물품의 판매가 끝나기까지 남은 시간입니다."
		uiControl = UiBase.registPeriod_Title
	elseif 4 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLCOUNTITEM_NAME") -- "판매 등록 개수"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLCOUNTITEM_DESC") -- "처음 등록한 물품의 개수입니다."
		uiControl = UiBase.sellCountIcon
	elseif 5 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLCOMPLETE_NAME") -- "판매된 물품 가격"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_TOOLTIP_SELLCOMPLETE_DESC") -- "중간 정산으로 수령할 수 있는 금액입니다."
		uiControl = UiBase.sellCompleteIcon
	end

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end	
end

--------------------------------------------------------------------------------
-- 글로벌 이벤트
--------------------------------------------------------------------------------
function FGlobal_ItemMarketMyItems_Update()
	local self = ItemMarketItemSet
	self:SetPosition()
	if 0 < self.startIdx then			-- 첫 진입시는 -1 시키지 않음, 정상적으로 삭제될 경우만 idx -1
		self.startIdx = self.startIdx-1
	else
		self.startIdx = 0
	end
	
	self:Update( self.startIdx )
end

function FGlobal_ItemMarketItemSet_Open()
	local	self	= ItemMarketItemSet
	if Panel_Window_ItemMarket_ItemSet:GetShow() then
		return
	end
	
	if Panel_Window_ItemMarket:GetShow() then
		FGolbal_ItemMarket_Close()
	end

	if Panel_ItemMarket_AlarmList:GetShow() then
		FGlobal_ItemMarketAlarmList_Close()
	end
	
	if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
		FGlobal_ItemMarket_BuyConfirm_Close()
	end

	if Panel_Window_ItemMarket_RegistItem:GetShow() then
		FGlobal_ItemMarketRegistItem_Close()
	end
	
	--{
		self.invenMoney:SetShow(true)
		self.warehouseMoney:SetShow(true)
		-- self.radioBtn_Inven:SetShow(true)
		-- self.radioBtn_Warehouse:SetShow(true)
		self.btn_Inven:SetShow(true)
		self.btn_Inven:SetEnableArea( 0, 0, 215, self.btn_Inven:GetSizeY())
		self.btn_Warehouse:SetShow(true)
		self.btn_Warehouse:SetEnableArea( 0, 0, 215, self.btn_Warehouse:GetSizeY())
		
		self.btn_Inven:SetCheck(true)
		self.btn_Warehouse:SetCheck(false)
	--}
	
	self.btn_RegistItem:SetShow(true)
	
	self:SetPosition()
	self:Open()
end

function FGlobal_ItemMarketItemSet_Open_ForWorldMap( escMenu )
	local	self	= ItemMarketItemSet
	if Panel_Window_ItemMarket_ItemSet:GetShow() then
		return
	end
	
	if Panel_Window_ItemMarket:GetShow() then
		FGolbal_ItemMarket_Close()
	end
	
	if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
		FGlobal_ItemMarket_BuyConfirm_Close()
	end
	
	--{
		self.invenMoney:SetShow(false)
		self.warehouseMoney:SetShow(false)
		-- self.radioBtn_Inven:SetShow(false)
		-- self.radioBtn_Warehouse:SetShow(false)
		self.btn_Inven:SetShow(false)
		self.btn_Warehouse:SetShow(false)
	--}
	
	self.btn_RegistItem:SetShow(false)

	self:SetPosition()
	self:Open( escMenu )
end

function ItemMarketItemSet_SimpleToolTips( tipType, isShow )
	local name, desc, control = nil, nil, nil
	local self = ItemMarketItemSet

	if 0 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_DESC")
		control = self.btn_Inven
	elseif 1 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_DESC")
		control = self.btn_Warehouse
	end

	if true == isShow then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function FGlobal_ItemMarketItemSet_Close()
	_ItemMarketItemSet_HideToolTip()
	Panel_Window_ItemMarket_ItemSet:SetShow( false, false )
end

function	ItemMarketItemSet_UpdateMoney()
	-- 창욱씨 추가해주세요.!
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_UPDATEMONEY_ACK"), 5 ) -- 판매금은 창고로 송금되었습니다.
end

function	ItemMarketItemSet_UpdateMoneyByWarehouse()
	ItemMarketItemSet.invenMoney:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
	ItemMarketItemSet.warehouseMoney:SetText( makeDotMoney(warehouse_moneyFromNpcShop_s64()) )
end

function ItemMarketItemSet:registEventHandler()
	self.btn_Close			:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarketItemSet_Close()")
	self.btn_RegistItem		:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarketRegistItem_Open()")
	self.panelBG			:addInputEvent("Mouse_DownScroll",	"ItemMarketItemSet_ScrollUpdate( true )")
	self.panelBG			:addInputEvent("Mouse_UpScroll",	"ItemMarketItemSet_ScrollUpdate( fasle )")
	self.scroll				:addInputEvent("Mouse_DownScroll",	"ItemMarketItemSet_ScrollUpdate( true )")
	self.scroll				:addInputEvent("Mouse_UpScroll",	"ItemMarketItemSet_ScrollUpdate( fasle )")
	self.scroll				:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarketItemSet_SetScrollIndexByLClick()")
	self.scrollCtrlBTN		:addInputEvent("Mouse_LPress",		"HandleClicked_ItemMarketItemSet_SetScrollIndexByLClick()")

	self._buttonQuestion	:addInputEvent( "Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"ItemMarket\" )" )								-- 물음표 좌클릭
	self._buttonQuestion	:addInputEvent( "Mouse_On",			"HelpMessageQuestion_Show( \"ItemMarket\", \"true\")" )				-- 물음표 마우스오버
	self._buttonQuestion	:addInputEvent( "Mouse_Out",		"HelpMessageQuestion_Show( \"ItemMarket\", \"false\")" )			-- 물음표 마우스오버

	self.btn_Inven		:addInputEvent("Mouse_On",			"ItemMarketItemSet_SimpleToolTips( 0, true )")
	self.btn_Inven		:addInputEvent("Mouse_Out",			"ItemMarketItemSet_SimpleToolTips( false )")
	self.btn_Warehouse	:addInputEvent("Mouse_On",			"ItemMarketItemSet_SimpleToolTips( 1, true )")
	self.btn_Warehouse	:addInputEvent("Mouse_Out",			"ItemMarketItemSet_SimpleToolTips( false )")

	self.btn_Inven		:setTooltipEventRegistFunc("ItemMarketItemSet_SimpleToolTips( 0, true )")
	self.btn_Warehouse	:setTooltipEventRegistFunc("ItemMarketItemSet_SimpleToolTips( 1, true )")

end
function ItemMarketItemSet:registMessageHandler()
	registerEvent("FromClient_InventoryUpdate",			"ItemMarketItemSet_UpdateMoneyByWarehouse")
	registerEvent("EventWarehouseUpdate",				"ItemMarketItemSet_UpdateMoneyByWarehouse")
	registerEvent("FromClient_WarehousePushMoney",		"ItemMarketItemSet_UpdateMoney")
end

ItemMarketItemSet:Initialize()
ItemMarketItemSet:registEventHandler()
ItemMarketItemSet:registMessageHandler()
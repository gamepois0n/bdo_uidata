---------------------------
-- Panel Init
---------------------------
Panel_Window_Exchange:SetShow(false, false);
Panel_Window_Exchange:setMaskingChild(true)
Panel_Window_Exchange:setGlassBackground(true)
Panel_Window_Exchange:RegisterShowEventFunc( true, 'ExchangeShowAni()' )
Panel_Window_Exchange:RegisterShowEventFunc( false, 'ExchangeHideAni()' )


--
-- 개인 거래 관련
--[[
const ge::wrapper::ItemWrapper*			tradePC_GetOtherItem( slotIndex )
const char*								tradePC_GetOtherName( ) 
int64									tradePC_GetOtherMoney( ) 
const char*								tradePC_GetOtherInfo( )
bool									tradePC_GetOtherLock( )

const ge::wrapper::ItemWrapper*			tradePC_GetMyItem( slotIndex ) 
const char*								tradePC_GetMyName( ) 
int64									tradePC_GetMyMoney( )
const char*								tradePC_GetMyInfo( ) 
bool									tradePC_GetMyLock( ) 
void									tradePC_Request() 
void									tradePC_Response()
void									tradePC_Cancel()
void									tradePC_RegisterItem( invenSlotNo, count )
void									tradePC_PopItem( slotIndex )
void									tradePC_ChangeMoney( money ) 
void									tradePC_Lock() 
void									tradePC_Confirm()


--]]


---------------------------
-- Local Variables
---------------------------
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local exchangePC =
{
	-- 여기서만 사용하는 변수및 함수를 정의 하기 위해서 사용.
	MAX_SLOT_COUNT = 12,
	slotConfig =
	{
		-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon		= true,
		createBorder	= true,
		createCount		= true,
		createEnchant	= true,
		createCash		= true,
	},
	mySlotConfig =
	{
		-- 이 값들은 추후에 메시지로 빼어내어 세팅해야 한다!
		slotCount = MAX_SLOT_COUNT,
		slotCols = 6,
		slotRows = 2,	-- 계산되는 값
		slotStartX = 11,
		slotStartY = 275,
		slotGapX = 48,
		slotGapY = 48,
		slotEnchantX = 13,
		slotEnchantY = 13,
	},
	otherSlotConfig =
	{
		-- 이 값들은 추후에 메시지로 빼어내어 세팅해야 한다!
		slotCount = MAX_SLOT_COUNT,
		slotCols = 6,
		slotRows = 2,	-- 계산되는 값
		slotStartX = 11,
		slotStartY = 80,
		slotGapX = 48,
		slotGapY = 48,
		slotEnchantX = 13,
		slotEnchantY = 13,
	},
	-- 공용
	_btnClose,
	_btnLock,
	_btnExchange,
	
	-- 상대방
	_otherSlots		= Array.new(),
	_otherSlotsBG	= Array.new(),
	_textOtherName,
	_textOtherSlotCount,
	_textOtherMoney,
	_textOtherWeight,
	_textOtherInfo,
	_textureOtherLock,
	_textureOtherUnLock,
	
	-- 내 정보
	_mySlots	= Array.new(),
	_mySlotsBG	= Array.new(),
	_textMyName,
	_textMySlotCount,
	_textMyMoney,
	_textMyWeight,
	_textMyInfo,
	_textureMyLock,
	_textureMyUnLock,
	_btnMyMoney	
}

-- local otherSlotBG = 
-- 	{
-- 		[0] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_0" ),
-- 		[1] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_1" ),
-- 		[2] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_2" ),
-- 		[3] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_3" ),
-- 		[4] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_4" ),
-- 		[5] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_5" ),
-- 		[6] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_6" ),
-- 		[7] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_7" ),
-- 		[8] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_8" ),
-- 		[9] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_9" ),
-- 		[10] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_10" ),
-- 		[11] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Another_11" ),
-- }

-- local mySlotBG = 
-- 	{
-- 		[0] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_0" ),
-- 		[1] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_1" ),
-- 		[2] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_2" ),
-- 		[3] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_3" ),
-- 		[4] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_4" ),
-- 		[5] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_5" ),
-- 		[6] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_6" ),
-- 		[7] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_7" ),
-- 		[8] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_8" ),
-- 		[9] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_9" ),
-- 		[10] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_10" ),
-- 		[11] = UI.getChildControl( Panel_Window_Exchange, "Static_Icon_Player_11" ),
-- }

---------------------------
-- Functions
---------------------------
function ExchangeShowAni()
	UIAni.fadeInSCR_Down(Panel_Window_Exchange)
	Inventory_updateSlotData()			-- 인벤 필터 꺼주기용
end

function ExchangeHideAni()
	Panel_Window_Exchange:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_Exchange:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)

	local aniInfo2 = Panel_Window_Exchange:addScaleAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(0.97)
	aniInfo2.AxisX = 416
	aniInfo2.AxisY = 294
	aniInfo2.IsChangeChild = true
	Inventory_Filter_Init()				-- 인벤 필터 초기화
end

function exchangePC:Init()
	-- 공용
	exchangePC._btnClose =  UI.getChildControl(Panel_Window_Exchange, "Button_Close");
	exchangePC._btnClose:addInputEvent( "Mouse_LUp", "Panel_ExchangePC_BtnClose_Mouse_Click()" );
	exchangePC._buttonQuestion =  UI.getChildControl(Panel_Window_Exchange, "Button_Question");		-- 물음표 버튼
	exchangePC._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelExchangeWithPC\" )" );		--물읖묘 좌클릭
	exchangePC._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelExchangeWithPC\", \"true\")" );		--물음표 마우스오버
	exchangePC._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelExchangeWithPC\", \"false\")" );		--물음표 마우스아웃
	
	exchangePC._btnLock =  UI.getChildControl(Panel_Window_Exchange, "Button_Lock");
	exchangePC._btnLock:addInputEvent( "Mouse_LUp", "Panel_ExchangePC_BtnLock_Mouse_Click()" );
	exchangePC._btnExchange =  UI.getChildControl(Panel_Window_Exchange, "Button_Exchange");
	exchangePC._btnExchange:addInputEvent( "Mouse_LUp", "Panel_ExchangePC_BtnExchange_Mouse_Click()" );
	exchangePC._EnchantText = UI.getChildControl(Panel_Window_Exchange, "Static_Text_Slot_Enchant_value");
	exchangePC._UselessSlot = UI.getChildControl(Panel_Window_Exchange, "Static_UselessSlot")
	exchangePc._LockedSlot = UI.getChildControl(Panel_Window_Exchange, "Static_LockedSlot")
	
	-- 상대방
	--_otherSlots = Array.new();
	exchangePC._textOtherName 		= UI.getChildControl(Panel_Window_Exchange, "Static_Name_Trader");
	exchangePC._textOtherSlotCount = UI.getChildControl(Panel_Window_Exchange, "Static_Slot_No_Trader");
	exchangePC._textOtherMoney 	= UI.getChildControl(Panel_Window_Exchange, "Static_Money_Trader");
	exchangePC._textOtherWeight 	= UI.getChildControl(Panel_Window_Exchange, "Static_Weight_Trader");
	exchangePC._textOtherInfo 		= UI.getChildControl(Panel_Window_Exchange, "Static_Info_Trader");
	exchangePC._textureOtherLock 	= UI.getChildControl(Panel_Window_Exchange, "Static_Lock_Trader");
	exchangePC._textureOtherUnLock = UI.getChildControl(Panel_Window_Exchange, "Static_Unlock_Trader");
	
	for ii = 1, exchangePC.MAX_SLOT_COUNT do
		local slotNo = ii - 1
		local slotBG = {}
		local slot = {};

		slotBG.BG	= UI.createAndCopyBasePropertyControl( Panel_Window_Exchange, "Static_Icon_Another_0", Panel_Window_Exchange, "Exchange_Another_BG_" .. slotNo )

		SlotItem.new( slot, 'Icon_Other_' .. slotNo, slotNo, Panel_Window_Exchange, exchangePC.slotConfig);
		slot:createChild();
		CopyBaseProperty( exchangePC._EnchantText, slot.enchantText )
		slot.enchantText:SetSize( slot.icon:GetSizeX(), slot.icon:GetSizeY() )
		slot.enchantText:SetPosX( 0 )
		slot.enchantText:SetPosY( 0 )
		slot.enchantText:SetTextHorizonCenter()
		slot.enchantText:SetTextVerticalCenter()


		-- position Set
		local row = math.floor( (slotNo) / exchangePC.otherSlotConfig.slotCols );
		local col = (slotNo) % exchangePC.otherSlotConfig.slotCols;
		slot.icon:SetPosX( exchangePC.otherSlotConfig.slotStartX + exchangePC.otherSlotConfig.slotGapX * col );
		slot.icon:SetPosY( exchangePC.otherSlotConfig.slotStartY + exchangePC.otherSlotConfig.slotGapY * row );
		slot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. (slotNo) .. ", \"exchangeOther\", true)" );
		slot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. (slotNo) .. ", \"exchangeOther\", false)" );
		slot.icon:SetIgnore(false);
		slot.icon:SetSize(35, 35);
		slot.border:SetSize( 41, 41 )
		slotBG.BG:SetPosX( exchangePC.otherSlotConfig.slotStartX + exchangePC.otherSlotConfig.slotGapX * col )
		slotBG.BG:SetPosY( exchangePC.otherSlotConfig.slotStartY + exchangePC.otherSlotConfig.slotGapY * row )
		Panel_Tooltip_Item_SetPosition(slotNo, slot, "exchangeOther")
		
		exchangePC._otherSlots[ii] = slot;
		exchangePC._otherSlotsBG[slotNo] = slotBG
	end
	
	-- 내 정보
	--_mySlots = Array.new(),
	exchangePC._textMyName 		= UI.getChildControl(Panel_Window_Exchange, "Static_Name_User");
	exchangePC._textMySlotCount 	= UI.getChildControl(Panel_Window_Exchange, "Static_Slot_No_User");
	exchangePC._textMyMoney 		= UI.getChildControl(Panel_Window_Exchange, "Static_Money_User");
	exchangePC._textMyWeight 		= UI.getChildControl(Panel_Window_Exchange, "Static_Weight_User");
	exchangePC._textMyInfo 		= UI.getChildControl(Panel_Window_Exchange, "Static_Info_User");
	exchangePC._textureMyLock 		= UI.getChildControl(Panel_Window_Exchange, "Static_Lock_User");
	exchangePC._textureMyUnLock	= UI.getChildControl(Panel_Window_Exchange, "Static_Unlock_User");
	
	exchangePC._btnMyMoney			= UI.getChildControl(Panel_Window_Exchange, "Button_Money");
	exchangePC._btnMyMoney:SetIgnore( true )	-- 실버 거래는 안된다.
	-- exchangePC._btnMyMoney:addInputEvent( "Mouse_LUp", "Panel_ExchangePC_BtnMyMoney_Mouse_Click()" );

	for ii = 1, exchangePC.MAX_SLOT_COUNT do
		local slotNo = ii - 1
		local slotBG = {}
		local slot = {};

		slotBG.BG	= UI.createAndCopyBasePropertyControl( Panel_Window_Exchange, "Static_Icon_Player_0", Panel_Window_Exchange, "Exchange_Player_BG_" .. slotNo )

		SlotItem.new( slot, 'Icon_My_' .. slotNo, slotNo, Panel_Window_Exchange, exchangePC.slotConfig);
		slot:createChild();
		CopyBaseProperty( exchangePC._EnchantText, slot.enchantText )
		slot.enchantText:SetSize( slot.icon:GetSizeX(), slot.icon:GetSizeY() )
		slot.enchantText:SetPosX( 0 )
		slot.enchantText:SetPosY( 0 )
		slot.enchantText:SetTextHorizonCenter()
		slot.enchantText:SetTextVerticalCenter()

		-- set Event Handler
		-- position Set
		local row = math.floor( (slotNo) / exchangePC.mySlotConfig.slotCols );
		local col = (slotNo) % exchangePC.mySlotConfig.slotCols;
		slot.icon:SetPosX( exchangePC.mySlotConfig.slotStartX + exchangePC.mySlotConfig.slotGapX * col );
		slot.icon:SetPosY( exchangePC.mySlotConfig.slotStartY + exchangePC.mySlotConfig.slotGapY * row );
		slot.icon:addInputEvent( "Mouse_RUp", "Panel_ExchangePC_MySlotRClick(" .. (slotNo) .. ")" );
		slot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. (slotNo) .. ", \"exchangeSelf\", true)" );
		slot.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. (slotNo) .. ", \"exchangeSelf\", false)" );
		slot.icon:SetIgnore(false);
		slot.icon:SetSize(35, 35);
		slot.border:SetSize( 41, 41 )

		slotBG.BG:SetPosX( exchangePC.mySlotConfig.slotStartX + exchangePC.mySlotConfig.slotGapX * col )
		slotBG.BG:SetPosY( exchangePC.mySlotConfig.slotStartY + exchangePC.mySlotConfig.slotGapY * row )

		Panel_Tooltip_Item_SetPosition(slotNo, slot, "exchangeSelf")
		exchangePC._mySlots[ii]		= slot;
		exchangePC._mySlotsBG[slotNo]	= slotBG
	end
	
	exchangePC._EnchantText:SetShow(false)
	
end

----------------------------------------------------------------------------
-- 지역 함수
-----------------------------------------------------------------------------


----------------------------------------------------------------------------
-- 전역 함수
-----------------------------------------------------------------------------
function Panel_ExchangePC_Update_Slot()

	-- 상대방
	local otherSlotCount = 0;
	local _otherSlot = {}
	for ii=1, exchangePC.MAX_SLOT_COUNT do
		local slot = exchangePC._otherSlots[ii];
		local itemWrapper = tradePC_GetOtherItem(ii-1);
		local slotNo = ii-1;	
		if nil ~= itemWrapper then
			slot:setItem( itemWrapper );
			otherSlotCount = otherSlotCount + 1;
			_otherSlot[ii] = 1
		else
			slot:clearItem();
			_otherSlot[ii] = 0
		end
	end

	local otherName = tradePC_GetOtherName();
	exchangePC._textOtherName:SetText( tradePC_GetOtherName() );

	exchangePC._textOtherSlotCount:SetText( otherSlotCount .. "/" .. exchangePC.MAX_SLOT_COUNT);
		
	local otherMoney 	= tostring(tradePC_GetOtherMoney_s64());
	exchangePC._textOtherMoney:SetText( otherMoney );
	
	local otherWeight	= tradePC_GetOtherWeight_s64()
	otherWeight			= Int64toInt32( otherWeight ) / 10000
	exchangePC._textOtherWeight:SetText( string.format( "%.1f", otherWeight ).." LT" );
	
	local otherInfo		= tradePC_GetOtherInfo();
	if(  1 == otherInfo ) then
		exchangePC._textOtherInfo:SetText( PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_TRADE" ) );
	elseif( 2 == otherInfo ) then
		exchangePC._textOtherInfo:SetText( PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_LOCK" ) );	
	elseif( 3 == otherInfo ) then
		exchangePC._textOtherInfo:SetText( PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_FINAL_CHECK" ) );
	else
		exchangePC._textOtherInfo:SetText( PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_ERROR" ) );
	end
	
	local isOtherLock	=  tradePC_GetOtherLock();
	exchangePC._textureOtherLock:SetShow( isOtherLock );
	exchangePC._textureOtherUnLock:SetShow( not isOtherLock );
	
	for ii=1, exchangePC.MAX_SLOT_COUNT do
		if ( true == isOtherLock ) then
			if ( 0 == _otherSlot[ii] ) then
				exchangePC._otherSlotsBG[ii-1].BG:ChangeTextureInfoName( "new_ui_common_forlua/default/useless_slot.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( exchangePC._otherSlotsBG[ii-1].BG, 5, 5, 36, 36 )
				exchangePC._otherSlotsBG[ii-1].BG:getBaseTexture():setUV(  x1, y1, x2, y2  )
				exchangePC._otherSlotsBG[ii-1].BG:setRenderTexture(exchangePC._otherSlotsBG[ii-1].BG:getBaseTexture())
			end
		else
			exchangePC._otherSlotsBG[ii-1].BG:ChangeTextureInfoName( "new_ui_common_forlua/default/UI_Item_LootingWin_Slot.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( exchangePC._otherSlotsBG[ii-1].BG, 0, 0, 47, 47 )
			exchangePC._otherSlotsBG[ii-1].BG:getBaseTexture():setUV(  x1, y1, x2, y2  )
			exchangePC._otherSlotsBG[ii-1].BG:setRenderTexture(exchangePC._otherSlotsBG[ii-1].BG:getBaseTexture())
		end
	end
	
	-- 자신
	local mySlotCount = 0;
	local _mySlot = {}
	for ii=1, exchangePC.MAX_SLOT_COUNT do
		local slot = exchangePC._mySlots[ii];
		local itemWrapper = tradePC_GetMyItem(ii-1);		
		local slotNo = ii-1;	
		if nil ~= itemWrapper then
			slot:setItem( itemWrapper );
			mySlotCount = mySlotCount + 1;
			_mySlot[ii] = 1
		else
			slot:clearItem();
			_mySlot[ii] = 0
		end
	end
	
	local myName =  tostring(tradePC_GetMyName());
	exchangePC._textMyName:SetText( tradePC_GetMyName() );
	
	exchangePC._textMySlotCount:SetText( mySlotCount .. "/" .. exchangePC.MAX_SLOT_COUNT );
	
	local s64_myMoney 	= tradePC_GetMyMoney_s64();
	exchangePC._textMyMoney:SetText( tostring(s64_myMoney) );
	
	local txt_SizeX = - exchangePC._textMyMoney:GetTextSizeX()
	exchangePC._btnMyMoney:SetEnableArea(txt_SizeX - 5, 0, exchangePC._btnMyMoney:GetSizeX(), exchangePC._btnMyMoney:GetSizeY())
	
	
	local s64_myWeight 	= tradePC_GetMyWeight_s64();
	s64_myWeight		= Int64toInt32( s64_myWeight ) / 10000
	exchangePC._textMyWeight:SetText( string.format( "%.1f", s64_myWeight ).." LT" )
	
	local myInfo	= tradePC_GetMyInfo();
	if(  1 == myInfo ) then
		exchangePC._textMyInfo:SetText( PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_TRADE" ) );
	elseif( 2 == myInfo ) then
		exchangePC._textMyInfo:SetText( PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_LOCK" ) );	
	elseif( 3 == myInfo ) then
		exchangePC._textMyInfo:SetText( PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_FINAL_CHECK" ) );
	else
		exchangePC._textMyInfo:SetText( PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_STATE_ERROR" ) );
	end
	
	local isMyLock	=  tradePC_GetMyLock();
	exchangePC._textureMyLock:SetShow( isMyLock );
	exchangePC._textureMyUnLock:SetShow( not isMyLock );

	for ii=1, exchangePC.MAX_SLOT_COUNT do
		if ( true == isMyLock ) then
			if ( 0 == _mySlot[ii] ) then
				exchangePC._mySlotsBG[ii-1].BG:ChangeTextureInfoName( "new_ui_common_forlua/default/useless_slot.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( exchangePC._mySlotsBG[ii-1].BG, 5, 5, 36, 36 )
				exchangePC._mySlotsBG[ii-1].BG:getBaseTexture():setUV(  x1, y1, x2, y2  )
				exchangePC._mySlotsBG[ii-1].BG:setRenderTexture(exchangePC._mySlotsBG[ii-1].BG:getBaseTexture())
			end
		else
			exchangePC._mySlotsBG[ii-1].BG:ChangeTextureInfoName( "new_ui_common_forlua/default/UI_Item_LootingWin_Slot.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( exchangePC._mySlotsBG[ii-1].BG, 0, 0, 47, 47 )
			exchangePC._mySlotsBG[ii-1].BG:getBaseTexture():setUV(  x1, y1, x2, y2  )
			exchangePC._mySlotsBG[ii-1].BG:setRenderTexture(exchangePC._mySlotsBG[ii-1].BG:getBaseTexture())
		end
	end
	ExChangePC_UpdateFilter()
end

function ExChangePC_UpdateFilter()
	for ii=1, exchangePC.MAX_SLOT_COUNT do
		Inventory_EraseEffect_While_Exchange( ii-1 )
	end

	for ii=1, exchangePC.MAX_SLOT_COUNT do
		local slot = exchangePC._mySlots[ii];
		local itemWrapper = tradePC_GetMyItem(ii-1);		
		if nil ~= itemWrapper then
			local slotNo = tradePC_GetMyItemInvenSlotNo( ii-1 )
			Inventory_AddEffect_While_Exchange( slotNo )
		end
	end
end

function ExchangePC_MessageBox_RequestConfirm()	
	tradePC_Request(true);
end

function ExchangePC_MessageBox_RequestCancel()
	tradePC_Request(false);
end

function ExchangePC_MessageBox_ResponseConfirm()
	tradePC_Response();
	InventoryWindow_Close()
	Inventory_SetFunctor( ExchangePC_InventoryFilter, ExchangePC_InventoryRClick, nil, nil );
	InventoryWindow_Show();

	if Panel_Equipment:GetShow() then
		FGlobal_Equipment_SetHide( false )
	end
	
	if( false == Panel_Window_Exchange:IsShow() ) then
		Panel_Window_Exchange:SetShow(true, true);
	end
	
	Panel_ExchangePC_Update_Slot()
end

function ExchangePC_InventoryFilter( slotNo, itemWrapper, inventoryType )
	if nil == itemWrapper then
		return true
	end
	local itemEnchantSSW		= itemWrapper:getStaticStatus()
	local itemEnchantKey		= itemEnchantSSW:get()._key

	local itemPersonalTradeItem	= itemEnchantSSW:isPersonalTrade()
	local isAble				= isPersonalTradeByItemEnchantKey(itemEnchantKey)
	local isVested				= itemWrapper:get():isVested()
	local isCheck = isAble and itemPersonalTradeItem and isUsePcExchangeInLocalizingValue() and (not isVested)
	
	-- local isAble				= isPersonalTradeByItemEnchantKey(itemEnchantKey)

	return (not isCheck);
end

function ExchangePC_InventoryRClick( slotNo, itemWrapper, itemCount, inventoryType )
	if( Defines.s64_const.s64_1 ==  itemCount ) then
		Panel_ExchangePC_InteractionFromNumberWindow( 1, slotNo, inventoryType )
	else
		Panel_NumberPad_Show(  true, itemCount, slotNo , Panel_ExchangePC_InteractionFromNumberWindow, nil , inventoryType ) 
	end
end

function ExchangePC_MessageBox_ResponseCancel()
	tradePC_Cancel();
	InventoryWindow_Close();
	Inventory_SetFunctor( nil, nil, nil, nil );
	
	if( Panel_Window_Exchange:IsShow() ) then
		Panel_Window_Exchange:SetShow(false, true);
	end

end

function ExchangePc_MessageBox_CloseConfirm()

	tradePC_Cancel();	
	
	InventoryWindow_Close();
	Inventory_SetFunctor( nil, nil, nil, nil );
	
	Interaction_Reset()
	
	if( Panel_Window_Exchange:IsShow() ) then
		Panel_Window_Exchange:SetShow(false, true);
	end

end

-- inputNumber는 int64이다.
function ExChangePC_ChangeMoney( inputNumber, param )
	tradePC_ChangeMoney( inputNumber )
end

----------------------------------------------------------------------------
-- 이벤트, inputhandler
-----------------------------------------------------------------------------

function EventTradePC_MessageBoxToRequest( actorName )
	local contentString = PAGetStringParam1( Defines.StringSheet_GAME, "EXCHANGE_TEXT_TRADE_REQUEST", "actorName", tostring(actorName) );
	local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_TRADE_REQUEST_TITLE" ), content = contentString, functionYes = ExchangePC_MessageBox_RequestConfirm, functionCancel = ExchangePC_MessageBox_RequestCancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	
	local isExist = MessageBox.doHaveMessageBoxData( messageboxData.title );
	if( false == isExist ) then
		MessageBox.showMessageBox(messageboxData);	
	end
end

function EventTradePC_ReceiveToMyRequest( )	
	InventoryWindow_Close()
	Inventory_SetFunctor( ExchangePC_InventoryFilter, ExchangePC_InventoryRClick, nil, nil );
	InventoryWindow_Show();

	if Panel_Equipment:GetShow() then
		FGlobal_Equipment_SetHide( false )
	end
	
	if( false == Panel_Window_Exchange:IsShow() ) then
		Panel_Window_Exchange:SetShow(true, true);
	end
		
	Panel_ExchangePC_Update_Slot();
end

function EventTradePC_ReceiveOtherPlayerRequest( actorName )
	local contentString = PAGetStringParam1( Defines.StringSheet_GAME, "EXCHANGE_TEXT_TRADE_ACCEPT", "actorName", tostring(actorName) );
	local messageboxData = { title = PAGetString( Defines.StringSheet_RESOURCE, "EXCHANGE_TEXT_TITLE" ), content = contentString, functionYes = ExchangePC_MessageBox_ResponseConfirm, functionCancel = ExchangePC_MessageBox_ResponseCancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
end

function EventTradePC_ReceiveCancel( reason )
	InventoryWindow_Close();
	Inventory_SetFunctor( nil, nil, nil, nil );

	if( Panel_Window_Exchange:IsShow() ) then
		Panel_Window_Exchange:SetShow(false, true);
	end
	
	local contentString = reason; -- "이유로 거래를 취소하였습니다.";
	local messageboxData = { title = PAGetString( Defines.StringSheet_RESOURCE, "EXCHANGE_TEXT_TITLE" ), content = contentString, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
end

function Panel_ExchangePC_Complete()
	InventoryWindow_Close();
	Inventory_SetFunctor( nil, nil, nil, nil );

	if( Panel_Window_Exchange:IsShow() ) then
		Panel_Window_Exchange:SetShow(false, true);
	end
	
	local contentString = PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_COMPLETE" );
	local messageboxData = { title = PAGetString( Defines.StringSheet_RESOURCE, "EXCHANGE_TEXT_TITLE" ), content = contentString, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
end

function EventTradePC_IsAbleTradingWithPlayer()
	
	
	return true;
end

function Panel_ExchangePC_BtnClose_Mouse_Click()
	local contentString = PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_CANCEL" );
	local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "EXCHANGE_TEXT_TITLE" ), content = contentString, functionYes = ExchangePc_MessageBox_CloseConfirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
end

function Panel_ExchangePC_BtnLock_Mouse_Click()
	
	tradePC_Lock();
end

function Panel_ExchangePC_BtnExchange_Mouse_Click()
	
	tradePC_Confirm();
end

function Panel_ExchangePC_BtnMyMoney_Mouse_Click()
	return

	-- 게임머니 관련 숫자창
	-- local s64_MaxMoney = getSelfPlayer():get():getInventory():getMoney_s64();
	
	-- Panel_NumberPad_Show(  true, s64_MaxMoney, 0 , ExChangePC_ChangeMoney, true ) ;	
end

local _slot = {}
local _slotIndex = 0
function Panel_ExchangePC_MySlotRClick( slotIndex )

	tradePC_PopItem( slotIndex ); 

	Inventory_EraseEffect_While_Exchange( slotIndex )
	_slot[slotIndex] = nil
	if ( slotIndex == _slotIndex ) and ( 0 < _slotIndex )then
		_slotIndex = _slotIndex - 1
	end

end

-- function Panel_ExchangePC_InteractionFromInventory( invenSlotNo, itemWrapper, s64_itemCount, inventoryType )	-- 필터 우클릭.
-- 	--1개인 아이템일 경우 숫자창을 띄워줄필요는 없다.
-- 	if( Defines.s64_const.s64_1 == s64_itemCount ) then
-- 		Panel_ExchangePC_InteractionFromNumberWindow( 1, invenSlotNo, inventoryType )
-- 	else
-- 		Panel_NumberPad_Show(  true, s64_itemCount, invenSlotNo , Panel_ExchangePC_InteractionFromNumberWindow, nil , inventoryType ) 
-- 	end
-- end



-- inputNumber 는 64비트이다.
function Panel_ExchangePC_InteractionFromNumberWindow( inputNumber, invenSlotNo, whereType)
	Inventory_AddEffect_While_Exchange( invenSlotNo )
	tradePC_RegisterItem( whereType, invenSlotNo, inputNumber );

	if ( 0 == _slotIndex ) then
		_slot[0] = invenSlotNo
		_slotIndex = _slotIndex + 1
	else
		for i = 0, _slotIndex do
			if ( nil == _slot[i] ) then
				_slot[i] = invenSlotNo
				aaa = true
				break
			end
		end
		_slotIndex = _slotIndex + 1
		_slot[_slotIndex] = invenSlotNo
	end

	Panel_ExchangePC_Update_Slot();
end

registerEvent("EventTradePCMessageBoxToRequest", 		"EventTradePC_MessageBoxToRequest" );
registerEvent("EventTradePCReceiveToMyRequest", 		"EventTradePC_ReceiveToMyRequest" );
registerEvent("EventTradePCReceiveOtherPlayerRequest", 	"EventTradePC_ReceiveOtherPlayerRequest" );
registerEvent("EventTradePCReceiveCancel", 				"EventTradePC_ReceiveCancel" );
registerEvent("EventTradePCUpdateSlots", 				"Panel_ExchangePC_Update_Slot" );
registerEvent("EventTradePCComplete", 					"Panel_ExchangePC_Complete" );

registerEvent("Event_IsAbleTradingWithPlayer", "EventTradePC_IsAbleTradingWithPlayer");
----------------------------------------------------------------------------
-- 초기화
-----------------------------------------------------------------------------
exchangePC:Init();
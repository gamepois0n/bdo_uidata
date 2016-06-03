local UI_TM				= CppEnums.TextMode
local UI_PUCT			= CppEnums.PA_UI_CONTROL_TYPE
local UI_color			= Defines.Color
local UI_ANI_ADV		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local ItemClassify		= CppEnums.ItemClassifyType
local ItemClassifyName	= CppEnums.ItemClassifyTypeName
local IM 				= CppEnums.EProcessorInputMode
local registMarket		= true -- ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 64 )		-- 파티분배옵션
local specialStockTic	= ToClient_GetSpecialStockTic()
local specialStockRate 	= ToClient_GetSpecialStockRate() 


Panel_Window_ItemMarket:setGlassBackground( true )
Panel_Window_ItemMarket:ActiveMouseEventEffect( true )
Panel_Window_ItemMarket:SetShow( false )

Panel_Window_ItemMarket:RegisterShowEventFunc( true, 'ItemMarketShowAni()' )
Panel_Window_ItemMarket:RegisterShowEventFunc( false, 'ItemMarketHideAni()' )

local shopType = {
	eShopType_Potion	= 1,	-- 물약상인
	eShopType_Weapon	= 2,	-- 무기상인
	eShopType_Jewel		= 3,	-- 보석상인
	eShopType_Furniture = 4,	-- 가구상인
	eShopType_Collect 	= 5,	-- 재료상인
	eShopType_Cook		= 9,	-- 요리상인
	eShopType_PC		= 10,	-- pc방 상인
}


local ItemMarket = {
	panelTitle					= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_Title"),
	panelBG						= UI.getChildControl( Panel_Window_ItemMarket,	"Static_BG"),
	btn_Close					= UI.getChildControl( Panel_Window_ItemMarket,	"Button_Win_Close"),

	btn_Search					= UI.getChildControl( Panel_Window_ItemMarket,	"Button_Search"),
	btn_ResetSearch				= UI.getChildControl( Panel_Window_ItemMarket,	"Button_SearchReset"),

	txt_Sort_Parent				= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_SortTitle"),
	btn_Sort_ItemName			= UI.getChildControl( Panel_Window_ItemMarket,	"Button_SortItemName"),
	btn_Sort_RecentPrice		= UI.getChildControl( Panel_Window_ItemMarket,	"Button_SortRecentPrice"),
	btn_Sort_RegistItemCount	= UI.getChildControl( Panel_Window_ItemMarket,	"Button_SortRegistItemCount"),
	btn_Sort_AverageTradePrice	= UI.getChildControl( Panel_Window_ItemMarket,	"Button_SortAverageTradePrice"),
	btn_Sort_RecentRegistDate	= UI.getChildControl( Panel_Window_ItemMarket,	"Button_SortRecentRegistDate"),
	btn_MyList					= UI.getChildControl( Panel_Window_ItemMarket,	"Button_MyList"),
	btn_BackPage				= UI.getChildControl( Panel_Window_ItemMarket,	"Button_BackPage"),
	btn_SetAlarm				= UI.getChildControl( Panel_Window_ItemMarket,	"Button_SetAlarm"),
	btn_Refresh					= UI.getChildControl( Panel_Window_ItemMarket,	"Button_Refresh"),
	btn_RegistItem				= UI.getChildControl( Panel_Window_ItemMarket,	"Button_RegistItem" ),
	selectCategory				= 0,
	selectItemSort				= 0,																							-- 정렬 방법(이름,최근,개수,평균거래,최근등록일)
	static_ListHeadBG			= UI.getChildControl( Panel_Window_ItemMarket,	"Static_ListHeadBG"),
	static_SlotBg				= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_Static_SlotBG"),
	static_Slot					= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_Static_Slot"),
	selectSingleSlot			= {},
	txt_SpecialGoodsName		= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_SpecialGoods_Name" ),
	txt_SpecialGoodsDesc		= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_SpecialGoods_Desc" ),
	
	txt_ItemName				= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_ItemName"),
	txt_ItemNameBackPage		= "",
	averagePrice_Title			= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_AveragePrice_Title"),
	txt_AveragePrice_Value		= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_AveragePrice_Value"),
	recentPrice_Title			= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RecentPrice_Title"),
	txt_RecentPrice_Value		= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RecentPrice_Value"),
	registHighPrice_Title		= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RegistHighPrice_Title"),
	txt_RegistHighPrice_Value	= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RegistHighPrice_Value"),
	registLowPrice_Title		= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RegistLowPrice_Title"),
	txt_RegistLowPrice_Value	= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RegistLowPrice_Value"),
	registListCount_Title		= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RegistListCount_Title"),
	txt_RegistListCount_Value	= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RegistListCount_Value"),
	registItemCount_Title		= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RegistItemCount_Title"),
	txt_RegistItemCount_Value	= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_RegistItemCount_Value"),
	_txt_price_dash				= UI.getChildControl( Panel_Window_ItemMarket,	"Selected_StaticText_dash"),

	static_CategoryBG			= UI.getChildControl( Panel_Window_ItemMarket,	"Static_CategoryBG"),
	static_FilterBG				= UI.getChildControl( Panel_Window_ItemMarket,	"Static_FilterBG"),
	static_ItemListBG			= UI.getChildControl( Panel_Window_ItemMarket,	"Static_ItemListBG"),
	edit_ItemName				= UI.getChildControl( Panel_Window_ItemMarket,	"Edit_ItemName"),

	-- 돈 지불 방법.
	invenMoney					= UI.getChildControl( Panel_Window_ItemMarket,	"Static_Text_Money"),
	invenMoneyTit				= UI.getChildControl( Panel_Window_ItemMarket,	"RadioButton_Icon_Money"),
	warehouseMoney				= UI.getChildControl( Panel_Window_ItemMarket,	"Static_Text_Money2"),
	warehouseMoneyTit			= UI.getChildControl( Panel_Window_ItemMarket,	"RadioButton_Icon_Money2"),
	invenDesc					= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_Inven"),
	warehouseDesc				= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_Warehouse"),
	-- static_Inven				= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"StaticText_Icon_Money"),
	-- static_Warehouse			= UI.getChildControl( Panel_Window_ItemMarket_ItemSet,	"StaticText_Icon_Money2"),

	iconTooltip					= nil,

	scroll						= UI.getChildControl( Panel_Window_ItemMarket,	"Scroll_ItemMarket"),
	nowScrollPos				= 0,
	scrollInverVal				= 0,
	nowStartIdx					= 0,
	
	curItemClassify				= ItemClassify.eItemClassify_Etc,
	curFilterIndex				= -1,
	curClassType				= -1,
	curServantType				= -1,

	categoryUiPool				= {},
	filterUiPool				= {},
	itemList_MaxCount			= 7,
	itemGroupUiPool				= {},	-- itemListUiPool
	itemSingleUiPool			= {},

	isGrouplist					= true,
	
	sellInfoItemEnchantKeyRaw	= 0,
	curSummaryItemIndex			= 0,
	curTerritoryKeyRaw			= 0,
	specialItemEnchantKeyRaw	= 0,
	curSpecialItemIndex			= 0,
	isWorldMapOpen				= false,

	itemmarketClassCount		= 10,	-- 신규 클래스가 나오면 해당카운트를 수정해주어야한다. 필터 버튼 setcheck(false) 해주는 함수에 일본 국가 체크가있으니 신경 써야함.

	isSort_ItemName				= true,
	isSort_RecentPrice			= true,
	isSort_RegistItemCount		= true,
	isSort_AverageTradePrice	= true,
	isSort_RecentRegistDate		= true,
	
	isChangeSort				= false,
	curSortTarget				= -1,
	curSortValue				= false,
	
	isSearch					= false,	

	buyItemKeyraw				= 0,
	buyItemSlotidx				= 0,

	slotGroupConfing			= {
		createIcon			= true,
		createBorder		= true,
		createCount			= false,
		createEnchant		= true,
		createCash			= true,
		createClassEquipBG	= true,
	},
	slotSingleConfing			= {
		createIcon			= true,
		createBorder		= true,
		createCount			= true,
		createEnchant		= true,
		createCash			= true,
		createClassEquipBG	= true,
	},
	
	_buttonQuestion = UI.getChildControl( Panel_Window_ItemMarket, "Button_Question" ),		-- 물음표 버튼
	escMenuSaveValue = false,
}

ItemMarket.scrollCtrlBTN		= UI.getChildControl( ItemMarket.scroll,		"Scroll_CtrlButton")
ItemMarket.txt_SpecialGoodsDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
ItemMarket.txt_SpecialGoodsDesc:SetText( ItemMarket.txt_SpecialGoodsDesc:GetText() )

-- 북미 텍스트 길이 관련 처리(2016.03.02)
	local isAsia = (CppEnums.ContryCode.eContryCode_KOR == getContryTypeLua()) or (CppEnums.ContryCode.eContryCode_JAP == getContryTypeLua())
	local helpIconGapRate = 2
	if  false == isAsia then
		ItemMarket.btn_MyList:SetTextMode( UI_TM.eTextMode_Limit_AutoWrap )
		ItemMarket.btn_MyList:SetSize( ItemMarket.btn_MyList:GetSizeX(), (ItemMarket.btn_MyList:GetSizeY() * 1.5) )
		helpIconGapRate = 1.5
	end

	ItemMarket.btn_MyList:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_BTN_MYLIST") )

	local helpIcon = {
		[0]	= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_RegistListCount_Help"),
		[1]	= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_RegistHighPrice_Help"),
		[2]	= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_AveragePrice_Help"),
		[3]	= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_RegistItemCount_Help"),
		[4]	= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_RegistLowPrice_Help"),
		[5]	= UI.getChildControl( Panel_Window_ItemMarket,	"StaticText_RecentPrice_Help"),
	}
	helpIcon[0]:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_REGISTLISTCOUNT_HELP") )
	helpIcon[1]:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_REGISTHIGHPRICE_HELP") )
	helpIcon[2]:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_AVERAGEPRICE_HELP") )
	helpIcon[3]:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_REGISTITEMCOUNT_HELP") )
	helpIcon[4]:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_REGISTLOWPRICE_HELP") )
	helpIcon[5]:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_RECETNPRICE_HELP") )
	local langSize = 0
	for i = 0, 5 do
		if langSize < helpIcon[i]:GetTextSizeX() then
			langSize = helpIcon[i]:GetTextSizeX()
		end
	end
	for i = 0, 5 do
		if i <= 2 then
			helpIcon[i]:SetPosX(Panel_Window_ItemMarket:GetSizeX() - ( (langSize*helpIconGapRate) * (i+1) ))
		else
			helpIcon[i]:SetPosX(Panel_Window_ItemMarket:GetSizeX() - ( (langSize*helpIconGapRate) * (i+1-3) ))
		end
	end


local TemplateItemMarket = {
	btn_category				= UI.getChildControl( Panel_Window_ItemMarket,	"Template_RadioButton_Category"),
	btn_Filter					= UI.getChildControl( Panel_Window_ItemMarket,	"Template_RadioButton_Filter"),

	btn_ItemList				= UI.getChildControl( Panel_Window_ItemMarket,	"Template_Button_ItemList"),
	static_SlotBg				= UI.getChildControl( Panel_Window_ItemMarket,	"Template_Static_SlotBG"),
	static_Slot					= UI.getChildControl( Panel_Window_ItemMarket,	"Template_Static_Slot"),
	static_BiddingMark			= UI.getChildControl( Panel_Window_ItemMarket,	"Template_Static_BiddingMark"),
	txt_ItemName				= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_ItemName"),
	txt_AveragePrice_Title		= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_AveragePrice_Title"),
	txt_AveragePrice_Value		= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_AveragePrice_Value"),
	txt_RecentPrice_Title		= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RecentPrice_Title"),
	txt_RecentPrice_Value		= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RecentPrice_Value"),
	txt_RegistHighPrice_Title	= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistHighPrice_Title"),
	txt_RegistHighPrice_Value	= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistHighPrice_Value"),
	txt_RegistLowPrice_Title	= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistLowPrice_Title"),
	txt_RegistLowPrice_Value	= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistLowPrice_Value"),
	txt_RegistListCount_Title	= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistListCount_Title"),
	txt_RegistListCount_Value	= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistListCount_Value"),
	txt_RegistItemCount_Title	= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistItemCount_Title"),
	txt_RegistItemCount_Value	= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistItemCount_Value"),
	static_Line_1				= UI.getChildControl( Panel_Window_ItemMarket,	"Template_Static_Line_1" ),
	static_Line_2				= UI.getChildControl( Panel_Window_ItemMarket,	"Template_Static_Line_2" ),

	static_SingleSlotBg			= UI.getChildControl( Panel_Window_ItemMarket,	"Template_Static_SingleItemBG"),
	txt_SellPrice_Title			= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_SellPrice_Title"),
	txt_SellPrice_Value			= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_SellPrice_Value"),
	txt_RegistPeriod_Title		= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistPeriod_Title"),
	txt_RegistPeriod_Value		= UI.getChildControl( Panel_Window_ItemMarket,	"Template_StaticText_RegistPeriod_Value"),
	btn_BuyItem					= UI.getChildControl( Panel_Window_ItemMarket,	"Template_Button_BuyItem"),

	iconTooltip					= UI.getChildControl ( Panel_CheckedQuest, 		"StaticText_Notice_1")
}

--[[
CppEnums.ItemClassifyType =
{
	eItemClassify_Etc			=	0	,	-- 잡화
	eItemClassify_MainWeapon	=	1	,	-- 주무기
	eItemClassify_SubWeapon		=	2	,	-- 보조무기
	eItemClassify_Armor			=	3	,	-- 방어구
	eItemClassify_Accessory		=	4 	,	-- 악세사리
	eItemClassify_BlackStone	=	5	,	-- 블랙스톤
	eItemClassify_Jewel			=	6	,	-- 보석
	eItemClassify_Potion		=	7 	,	-- 물약
	eItemClassify_Cook			=	8	,	-- 요리
	eItemClassify_PearlGoods	=	9	,	-- 펄 상품
	eItemClassify_Housing		=	10	,	-- 하우징
	
	TypeCount			= 11,
}
]]--

local DummyData = {
	Category	= {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_1"), -- "잡화",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_13"), -- 광석
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_14"), -- 나무
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_15"), -- 씨앗&열매
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_16"), -- 가죽
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_17"), -- 어류
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_2"), -- "주 무기",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_3"), -- "보조 무기",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_4"), -- "방어구",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_5"), -- "액세서리",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_6"), -- "블랙스톤",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_7"), -- "보석",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_8"), -- "물약",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_9"), -- "요리",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_10"), -- "펄 상품",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_18"), -- "염색약",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_11"), -- "하우징",
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_CATEGORY_12"), -- "탈것 / 펫",
		[99] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_SPECIALITEM"), -- 특가상품
	},
	Filter		= {
		[0] = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_1"), 	-- "워리어",		--	0	0
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_2"), 			-- "레인저",		--  1	4
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_3"), 			-- "소서러",		--  2	8
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_4"), 			-- "자이언트",		--  3	12
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_5"), 			-- "금수랑",		--  4	16
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_17"),			-- "무사",          --  5	20
		CppEnums.ClassType2String[CppEnums.ClassType.ClassType_BladeMasterWomen],	-- 매화				--	6	21
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_18"),			-- "발키리",   		--  7	24
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_19"),			-- "쿠노이치",      --  8	25
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_20"),			-- "위자드",        --  9	28
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_21"),			-- "여자 위자드"	--	10	31
		PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_22"),			-- 닌자				--	11	31
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_6"), 			-- "말",			--  11	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_7"), 			-- "낙타",			--  12	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_8"), 			-- "당나귀",		--  13	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_9"), 			-- "코끼리",        --  14	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_10"),			-- "이륜마차",		--  15	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_11"), 			-- "사륜마차",		--  16	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_12"), 			-- "나룻배",		--  17	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_13"), 			-- "고양이",		--  18	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_14"), 			-- "개",			--  19	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_15"), 			-- "산양",			--  20	
		-- PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_FILTER_16") 			-- "뗏목",          --  21	
	},
	ClassFilter	= { [0]	= 0, 4, 8, 12, 16, 20, 21, 24, 25, 28, 31 }						-- 위 Filter 배열과 classType 매칭을 위해 셋트로 움직여야함. 
	--ClassFilter	= { [0]	= 0, 4, 8, 12, 16, 20, 21, 24, 28, 30, 31 }						-- 위 Filter 배열과 classType 매칭을 위해 셋트로 움직여야함. (CppEnums.ClassType 값과 동일함)
}

local _categoryTexture = {
	[0] =	{ [0] = { 368, 100, 410, 142 },	{ 368, 241, 410, 283 },	{ 368, 382, 410, 424 } },	-- 잡화(임시)	-- 0
			{ [0] = { 50, 135, 92, 177 },	{ 50, 181, 92, 223 }, 	{ 50, 227, 92, 269 } },		-- 광석			-- 12
			{ [0] = { 192, 135, 234, 177 },	{ 192, 181, 234, 223 }, { 192, 227, 234, 269 } },	-- 나무			-- 13
			{ [0] = { 3, 135, 45, 177 },	{ 3, 181, 45, 223 }, 	{ 3, 227, 45, 269 } },		-- 씨앗&열매	-- 14
			{ [0] = { 97, 135, 139, 177 },	{ 97, 181, 139, 223 }, 	{ 97, 227, 139, 269 } },	-- 가죽			-- 15
			{ [0] = { 145, 135, 187, 177 },	{ 145, 181, 187, 223 }, { 145, 227, 187, 269 } },	-- 어류			-- 16
			
			{ [0] = { 321, 6, 363, 48 },	{ 321, 147, 363, 189 },	{ 321, 288, 363, 330 } },	-- 주무기		-- 1
			{ [0] = { 368, 6, 410, 48 },	{ 368, 147, 410, 189 },	{ 368, 288, 410, 330 } },	-- 보조무기		-- 2
			{ [0] = { 415, 6, 457, 48 },	{ 415, 147, 457, 189 },	{ 415, 288, 457, 330 } 	},	-- 방어구		-- 3
			{ [0] = { 463, 6, 505, 48 },	{ 463, 147, 505, 189 },	{ 463, 288, 505, 330 } },	-- 악세사리		-- 4
			{ [0] = { 321, 53, 363, 95 },	{ 321, 194, 363, 236 },	{ 321, 335, 363, 377 } },	-- 블랙스톤		-- 5
			{ [0] = { 368, 53, 410, 95 },	{ 368, 194, 410, 236 },	{ 368, 335, 410, 377 } },	-- 보석			-- 6
			{ [0] = { 415, 53, 457, 95 },	{ 415, 194, 457, 236 },	{ 415, 335, 457, 377 } },	-- 물약			-- 7
			{ [0] = { 463, 53, 505, 95 },	{ 463, 194, 505, 236 },	{ 463, 335, 505, 377 } },	-- 요리			-- 8
			{ [0] = { 321, 100, 363, 142 },	{ 321, 241, 363, 283 },	{ 321, 382, 363, 424 } },	-- 펄 상품		-- 9
			{ [0] = { 50, 274, 92, 316 },	{ 50, 320, 92, 362 },	{ 50, 366, 92, 408 } },		-- 염색약		-- 17
			{ [0] = { 415, 100, 457, 142 },	{ 415, 241, 457, 283 },	{ 415, 382, 457, 424 } },	-- 하우징(임시)	-- 10
			{ [0] = { 463, 100, 505, 142 },	{ 463, 241, 505, 283 }, { 463, 382, 505, 424 } },	-- 탈것 / 펫	-- 11
	[99] = 	{ [0] = { 145, 274, 187, 316 },	{ 145, 320, 187, 362 }, { 145, 366, 187, 408 } },	-- 특가상품		-- 12
}



-- 나무노말
-- 192;135 / 234;177

-- 나무오버
-- 192;181 / 234;223

-- 나무클릭
-- 192;227 / 234;269

local _sortTexture = {
	[0] = { -- 이름 정렬
		[0] = { 
			[0] = {57, 137, 111, 169}, 
			{57, 171, 111, 203},
			{57, 137, 111, 169} 
		},
		{ 
			[0] = {1, 137, 55, 169}, 
			{1, 171, 55, 203},
			{1, 137, 55, 169}
		}
	},
	{ 	-- 최근 거래가
		[0] = { 
			[0] = {57, 1, 111, 33}, 
			{57, 35, 111, 67},
			{57, 1, 111, 33}
		},
		{ 
			[0] = {1, 1, 55, 33}, 
			{1, 35, 55, 67},
			{1, 1, 55, 33}
		}
	},
	{ 	-- 등록 개수
		[0] = { 
			[0] = {169, 1, 223, 33}, 
			{169, 35, 223, 67},
			{169, 1, 223, 33}
		},
		{ 
			[0] = {113, 1, 167, 33}, 
			{113, 35, 167, 67},
			{113, 1, 167, 33}
		}
	},
	{ 	-- 평균 거래가
		[0] = { 
			[0] = {57, 69, 111, 101}, 
			{57, 103, 111, 135},
			{57, 69, 111, 101}
		},
		{ 
			[0] = {1, 69, 55, 101}, 
			{1, 103, 55, 135},
			{1, 69, 55, 101}
		}
	},
	{ 	-- 최근 등록일
		[0] = { 
			[0] = {169, 69, 223, 101}, 
			{169, 103, 223, 135},
			{169, 69, 223, 101}
		},
		{ 
			[0] = {113, 69, 167, 101}, 
			{113, 103, 167, 135},
			{113, 69, 167, 101}
		}
	},
}

local territoryKey =
{
	[0]	= tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),		-- 발레노스령
	[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),		-- 세렌디아령
	[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),		-- 칼페온령
	[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3")),		-- 메디아령
}
-- _sortTexture[sortId][isCheck][0]

function convertFilterIndexToClassType( filterIndex  )
	local temp = -1
	if( 0 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_Warrior
	elseif( 1 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_Ranger
	elseif( 2 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_Sorcerer
	elseif( 3 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_Giant
	elseif( 4 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_Tamer
	elseif( 5 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_BladeMaster
	elseif( 6 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_BladeMasterWomen
	elseif( 7 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_Valkyrie
	elseif( 8 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_Wizard
	elseif( 9 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_WizardWomen
	elseif( 10 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_Kunoichi
	elseif( 11 == filterIndex ) then
		temp = CppEnums.ClassType.ClassType_NinjaMan
	else	
		_PA_ASSERT(false, "클래스 추가되었다면 작업해주세요" )
	end
	
	return temp
end

-- function convertFilterIndexToServanType(  filterIndex  )
	
-- 	--[[
-- 	enum ServantKind	: byte
-- 	{
-- 		eServantKind_Horse	= 0,			// 말
-- 		eServantKind_Camel,					// 낙타
-- 		eServantKind_Donkey,				// 당나귀
-- 		eServantKind_Elephant,				// 코끼리
-- 		eServantKind_TwoWheelCarrage,		// 이륜 마차
-- 		eServantKind_FourWheeledCarriage,	// 사륜 마차
-- 		eServantKind_Ship,					// 배
-- 		eServantKind_Cat,					// 고양이
-- 		eServantKind_Dog,					// 개
-- 		eServantKind_MountainGoat,			// 산양
-- 		eServantKind_Raft,					// 뗏목
-- 		eServantKind_Count,
-- 	};
-- 	]]--
	
-- 	local temp = -1
-- 	if( 21 < filterIndex ) then
-- 		_PA_ASSERT(false, "servantKind 추가되었다면 작업해주세요" )
-- 		return;
-- 	end
-- 	temp = filterIndex - 11 -- 위의 말번호
-- 	return temp
-- end

function ItemMarketShowAni()
	local self = ItemMarket
	local aniInfo1 = Panel_Window_ItemMarket:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.05)
	aniInfo1.AxisX = Panel_Window_ItemMarket:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_ItemMarket:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_ItemMarket:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.05)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_ItemMarket:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_ItemMarket:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end
function ItemMarketHideAni()
	local aniInfo1 = Panel_Window_ItemMarket:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

function ItemMarket_ScrollUpdate( isDown )
	local self	= ItemMarket
	
	-- local itemCount = 0;
	-- if( self.isGrouplist ) then
		-- itemCount = getItemMarketSummaryInClientCount();
	-- else
		-- itemCount = getItemMarketSellInfoInClientCount( self.curTerritoryKeyRaw , self.sellInfoItemEnchantKeyRaw )
	-- end
	
	local index	= self.nowStartIdx
	if true == isDown then
		if index < self.scrollInverVal then
			self.scroll:ControlButtonDown()
			index = index + 1
		else
			return
		end
	else
		if 0 < index then
			self.scroll:ControlButtonUp()
			index = index - 1
		else
			return
		end
	end
	
	self.nowStartIdx = index
	
	if self.categoryUiPool[99]:IsCheck() then			-- 특가상품?
		self:SpecialGoodsUpdate( index )
		return
	end
	self:Update( index )
end
function ItemMarket:SetScroll()
	local itemCount = 0
	if( self.isGrouplist ) then
		itemCount = getItemMarketSummaryInClientCount()
		self.scroll:SetSize( self.scroll:GetSizeX(), 450 )
		self.static_ItemListBG:SetSize( self.static_ItemListBG:GetSizeX(), 440 )
	else
		itemCount = getItemMarketSellInfoInClientCount( self.curTerritoryKeyRaw , self.sellInfoItemEnchantKeyRaw )
		self.scroll:SetSize( self.scroll:GetSizeX(), 390 )
		self.static_ItemListBG:SetSize( self.static_ItemListBG:GetSizeX(), 380 )	
	end

	if self.categoryUiPool[99]:IsCheck() then
		if ( self.isGrouplist ) then
			itemCount = ToClient_requestGetSummaryCount()
		else
			itemCount = ToClient_requestGetItemCountByItemEnchantKeyRaw( self.specialItemEnchantKeyRaw )
		end
	end
	
	local _itemListMaxCount = self.itemList_MaxCount
	if not self.isGrouplist then
		_itemListMaxCount = self.itemList_MaxCount - 1
	end
	
	local interval =  itemCount - _itemListMaxCount

	if interval < 0 then
		interval = 0
		self.scroll:SetShow(false)
	else
		self.scroll:SetShow(true)
	end

	local dataCount			= itemCount
	local viewCount			= _itemListMaxCount
	
	local pagePercent		= (viewCount / dataCount) * 100
	local scrollSizeY		= self.scroll:GetSizeY()
	local btn_scrollSizeY	= ( scrollSizeY / 100 ) * pagePercent
	if btn_scrollSizeY < 40 then
		btn_scrollSizeY = 65
	end

	if scrollSizeY  < btn_scrollSizeY then
		btn_scrollSizeY = scrollSizeY
	end

	UIScroll.SetButtonSize( self.scroll, viewCount, itemCount)
	
	-- self.scrollCtrlBTN:SetSize( self.scrollCtrlBTN:GetSizeX(), btn_scrollSizeY )
	self.scrollInverVal	= interval
	self.scroll:SetInterval( self.scrollInverVal )
end
function ItemMarket:Initialize()
	self.panelBG:setGlassBackground( true )

	self.txt_Sort_Parent		:AddChild( self.btn_Sort_ItemName )
	self.txt_Sort_Parent		:AddChild( self.btn_Sort_RecentPrice )
	self.txt_Sort_Parent		:AddChild( self.btn_Sort_RegistItemCount )
	self.txt_Sort_Parent		:AddChild( self.btn_Sort_AverageTradePrice )
	self.txt_Sort_Parent		:AddChild( self.btn_Sort_RecentRegistDate )
	self.txt_Sort_Parent		:AddChild( self.btn_Search )
	self.txt_Sort_Parent		:AddChild( self.btn_ResetSearch )
	self.txt_Sort_Parent		:AddChild( self.edit_ItemName )

	Panel_Window_ItemMarket		:RemoveControl( self.btn_Sort_ItemName )
	Panel_Window_ItemMarket		:RemoveControl( self.btn_Sort_RecentPrice )
	Panel_Window_ItemMarket		:RemoveControl( self.btn_Sort_RegistItemCount )
	Panel_Window_ItemMarket		:RemoveControl( self.btn_Sort_AverageTradePrice )
	Panel_Window_ItemMarket		:RemoveControl( self.btn_Sort_RecentRegistDate )
	Panel_Window_ItemMarket		:RemoveControl( self.btn_Search )
	Panel_Window_ItemMarket		:RemoveControl( self.btn_ResetSearch )
	Panel_Window_ItemMarket		:RemoveControl( self.edit_ItemName )
	self.txt_Sort_Parent		:SetShow( true )

	self.static_SlotBg			:AddChild( self.static_Slot )
	self.static_SlotBg			:AddChild( self.txt_ItemName )
	self.static_SlotBg			:AddChild( self.averagePrice_Title )
	self.static_SlotBg			:AddChild( self.txt_AveragePrice_Value )
	self.static_SlotBg			:AddChild( self.recentPrice_Title )
	self.static_SlotBg			:AddChild( self.txt_RecentPrice_Value )
	self.static_SlotBg			:AddChild( self.registHighPrice_Title )
	self.static_SlotBg			:AddChild( self.txt_RegistHighPrice_Value )
	self.static_SlotBg			:AddChild( self.registLowPrice_Title )
	self.static_SlotBg			:AddChild( self.txt_RegistLowPrice_Value )
	self.static_SlotBg			:AddChild( self.registListCount_Title )
	self.static_SlotBg			:AddChild( self.txt_RegistListCount_Value )
	self.static_SlotBg			:AddChild( self.registItemCount_Title )
	self.static_SlotBg			:AddChild( self.txt_RegistItemCount_Value )
	self.static_SlotBg			:AddChild( self._txt_price_dash )
	
	Panel_Window_ItemMarket		:RemoveControl( self.static_Slot )
	Panel_Window_ItemMarket		:RemoveControl( self.txt_ItemName )
	Panel_Window_ItemMarket		:RemoveControl( self.averagePrice_Title )
	Panel_Window_ItemMarket		:RemoveControl( self.txt_AveragePrice_Value )
	Panel_Window_ItemMarket		:RemoveControl( self.recentPrice_Title )
	Panel_Window_ItemMarket		:RemoveControl( self.txt_RecentPrice_Value )
	Panel_Window_ItemMarket		:RemoveControl( self.registHighPrice_Title )
	Panel_Window_ItemMarket		:RemoveControl( self.txt_RegistHighPrice_Value )
	Panel_Window_ItemMarket		:RemoveControl( self.registLowPrice_Title )
	Panel_Window_ItemMarket		:RemoveControl( self.txt_RegistLowPrice_Value )
	Panel_Window_ItemMarket		:RemoveControl( self.registListCount_Title )
	Panel_Window_ItemMarket		:RemoveControl( self.txt_RegistListCount_Value )
	Panel_Window_ItemMarket		:RemoveControl( self.registItemCount_Title )
	Panel_Window_ItemMarket		:RemoveControl( self.txt_RegistItemCount_Value )
	Panel_Window_ItemMarket		:RemoveControl( self._txt_price_dash )
	self.static_SlotBg			:SetShow( false )

	self.edit_ItemName			:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
	ItemMarket.txt_SpecialGoodsDesc:SetText( PAGetStringParam2(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_SPECIALPRODUCT_DESC", "ticktime", tostring(specialStockTic), "descpercent", tostring(specialStockRate)))
	
	
	local createSingleSlot = {}
	SlotItem.new( createSingleSlot, 'ItemMarket_ItemSingleSlotItem', 0, self.static_SlotBg, self.slotGroupConfing )
	createSingleSlot:createChild()
	self.selectSingleSlot = createSingleSlot

	local isAblePearlProduct = requestCanRegisterPearlItemOnMarket()

	-- 카테고리 버튼 생성
	local btn_Category_PosX = 10
	for category_Idx = 0, #DummyData.Category do
		local CreatedCategoryBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, self.static_CategoryBG, 'ItemMarket_CategoryBTN_' .. category_Idx )
		category_Match_Idx = ItemClassify[ItemClassifyName[category_Idx]]
		CopyBaseProperty( TemplateItemMarket.btn_category, CreatedCategoryBTN )
		CreatedCategoryBTN:SetPosX( btn_Category_PosX )
		CreatedCategoryBTN:SetPosY( 4 )
		CreatedCategoryBTN:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarket_SelectCategory( " .. category_Match_Idx .. ", 1 ,"..category_Idx.." )")
		CreatedCategoryBTN:addInputEvent( "Mouse_On", "ShowTooltip_ItemMarket_Category( true, " .. category_Idx .. ")" )
		CreatedCategoryBTN:addInputEvent( "Mouse_Out", "ShowTooltip_ItemMarket_Category( false )" )
		CreatedCategoryBTN:setTooltipEventRegistFunc("ShowTooltip_ItemMarket_Category( true, " .. category_Idx .. ")")
		CreatedCategoryBTN:SetShow( true )

		if (9 == category_Match_Idx) and ( not FGlobal_IsCommercialService() or isServerFixedCharge() ) then		-- 유료 서비스 기간이 아니면, 펄 상점 탭 숨김.
			CreatedCategoryBTN:SetShow( false )
			btn_Category_PosX = btn_Category_PosX
		elseif (9 == category_Match_Idx) and false == isAblePearlProduct then	-- 펄 상품을 등록할 수 없다면, 펄 탭을 나타내지 않는다.
			CreatedCategoryBTN:SetShow( false )
			btn_Category_PosX = btn_Category_PosX
		else
			btn_Category_PosX = btn_Category_PosX + CreatedCategoryBTN:GetSizeX() + 5
		end
		self.categoryUiPool[category_Idx] = CreatedCategoryBTN
		_itemMarket_ChangeTextureByCategory( category_Idx )	-- 텍스쳐를 바꾼다.
	end
	
	local CreatedSpecialCategoryBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, self.static_CategoryBG, 'ItemMarket_CategoryBTN_' .. 99 )
	CopyBaseProperty( TemplateItemMarket.btn_category, CreatedSpecialCategoryBTN )
	CreatedSpecialCategoryBTN:SetPosX( btn_Category_PosX )
	CreatedSpecialCategoryBTN:SetPosY( 4 )
	self.categoryUiPool[99] = CreatedSpecialCategoryBTN
	CreatedSpecialCategoryBTN:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarket_SelectCategory( 99, 1 , 99 )")
	CreatedSpecialCategoryBTN:addInputEvent( "Mouse_On", "ShowTooltip_ItemMarket_Category( true, 99 )" )
	CreatedSpecialCategoryBTN:addInputEvent( "Mouse_Out", "ShowTooltip_ItemMarket_Category( false )" )
	CreatedSpecialCategoryBTN:setTooltipEventRegistFunc("ShowTooltip_ItemMarket_Category( true, 99 )")
	CreatedSpecialCategoryBTN:SetShow( registMarket )
	_itemMarket_ChangeTextureByCategory( 99 )	-- 텍스쳐를 바꾼다.
	

	-- 필터 버튼 생성
	local btn_Filter_PosY = 40
	local maxClassCount = getCharacterClassCount()
	for filter_Idx = 0, maxClassCount-1 do
		local CreatedFilterBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, self.static_FilterBG, 'ItemMarket_FilterBTN_' .. filter_Idx )
		CopyBaseProperty( TemplateItemMarket.btn_Filter, CreatedFilterBTN )

		local	classType	= getCharacterClassTypeByIndex( filter_Idx )
		local	className	= getCharacterClassName( classType )

		CreatedFilterBTN:SetPosX( 10 )
		CreatedFilterBTN:SetPosY( btn_Filter_PosY )
		CreatedFilterBTN:SetText( className )
		CreatedFilterBTN:SetEnableArea( 0, 0, 100, CreatedFilterBTN:GetSizeY() )
		CreatedFilterBTN:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarket_SelectFilter( " .. filter_Idx .. " )")

		-- if filter_Idx < 11 then	-- 10 이하는 클래스 선택
		-- 	local isClass = _getIsClassTypeByFilter( filter_Idx )	-- 실제 사용되고 있는 클래스인지 검증
		-- 	if isClass then
		if ( nil ~= className ) and ( "" ~= className ) and ( " " ~= className ) then
			CreatedFilterBTN:SetShow( true )
			btn_Filter_PosY	= btn_Filter_PosY + CreatedFilterBTN:GetSizeY() + 4
		-- else
		-- 	CreatedFilterBTN:SetShow( false )
		-- end
		-- 	else
		-- 		CreatedFilterBTN:SetShow( false )
		-- 	end

		-- elseif 12 == filter_Idx or 14 == filter_Idx or 18 == filter_Idx or 19 == filter_Idx or 20 == filter_Idx then
		-- 	CreatedFilterBTN:SetShow( false )

		-- else
		-- 	CreatedFilterBTN:SetShow( true )
		-- 	btn_Filter_PosY	= btn_Filter_PosY + CreatedFilterBTN:GetSizeY() + 4
		end
		self.filterUiPool[filter_Idx]	= CreatedFilterBTN
	end
	
	-- 아이템 리스트 생성.
	local itemList_PosY = 5
	for itemList_Idx = 0, self.itemList_MaxCount - 1 do
		------------------------------------------------------------------------
		-- 그룹 시작
		------------------------------------------------------------------------
		local tempGroupSlot ={}
		local Created_ItemListBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, self.static_ItemListBG, 'ItemMarket_ItemListBTN_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.btn_ItemList, Created_ItemListBTN )
		Created_ItemListBTN:SetPosX( 5 )
		Created_ItemListBTN:SetPosY( itemList_PosY )
		Created_ItemListBTN:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
		Created_ItemListBTN:addInputEvent("Mouse_UpScroll",		"ItemMarket_ScrollUpdate( false )")
		Created_ItemListBTN:SetShow( false )
		tempGroupSlot.itemBTN = Created_ItemListBTN

		local Created_ItemSlotBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemListBTN, 'ItemMarket_ItemListSlotBG_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.static_SlotBg, Created_ItemSlotBG )
		Created_ItemSlotBG:SetPosX( 10 )
		Created_ItemSlotBG:SetPosY( 7 )
		Created_ItemSlotBG:SetShow( true )
		tempGroupSlot.itemSlotBG = Created_ItemSlotBG

		local createSlot = {}
		SlotItem.new( createSlot, 'ItemMarket_ItemGroupListSlotItem_' .. itemList_Idx, 0, Created_ItemSlotBG, self.slotGroupConfing )
		createSlot:createChild()
		tempGroupSlot.SlotItem = createSlot

		local Created_ItemName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListItemName_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.txt_ItemName, Created_ItemName )
		Created_ItemName:SetPosX( 60 )
		Created_ItemName:SetPosY( 7 )
		Created_ItemName:SetTextMode( UI_TM.eTextMode_AutoWrap )
		Created_ItemName:SetShow( true )
		tempGroupSlot.itemName = Created_ItemName

		local Created_AveragePrice_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListAveragePrice_Title_' .. itemList_Idx )				-- 평균 거래가
		CopyBaseProperty( TemplateItemMarket.txt_AveragePrice_Title, Created_AveragePrice_Title )
		Created_AveragePrice_Title:SetPosX( 460 )
		Created_AveragePrice_Title:SetPosY( 10 )
		Created_AveragePrice_Title:SetShow( true )
		Created_AveragePrice_Title:SetEnableArea(0, 0, 100, Created_AveragePrice_Title:GetSizeY())
		Created_AveragePrice_Title:addInputEvent("Mouse_On", "_itemMarket_ShowIconToolTip( true, " .. 0 .. ", " .. 0 .. ", " .. itemList_Idx .. " )")
		Created_AveragePrice_Title:addInputEvent("Mouse_Out", "_itemMarket_ShowIconToolTip( false )")
		tempGroupSlot.averagePrice_Title = Created_AveragePrice_Title

		local Created_AveragePrice_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListAveragePrice_Value_' .. itemList_Idx )				-- 평균 거래가
		CopyBaseProperty( TemplateItemMarket.txt_AveragePrice_Value, Created_AveragePrice_Value )
		Created_AveragePrice_Value:SetPosX( 480 )
		Created_AveragePrice_Value:SetPosY( 8 )
		Created_AveragePrice_Value:SetShow( true )
		tempGroupSlot.averagePrice_Value = Created_AveragePrice_Value

		local Created_RecentPrice_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRecentPrice_Title_' .. itemList_Idx )				-- 최근 거래가
		CopyBaseProperty( TemplateItemMarket.txt_RecentPrice_Title, Created_RecentPrice_Title )
		Created_RecentPrice_Title:SetPosX( 460 )
		Created_RecentPrice_Title:SetPosY( 32 )
		Created_RecentPrice_Title:SetShow( true )
		Created_RecentPrice_Title:SetEnableArea(0, 0, 100, Created_RecentPrice_Title:GetSizeY())
		Created_RecentPrice_Title:addInputEvent("Mouse_On", "_itemMarket_ShowIconToolTip( true, " .. 0 .. ", " .. 1 .. ", " .. itemList_Idx .. " )")
		Created_RecentPrice_Title:addInputEvent("Mouse_Out", "_itemMarket_ShowIconToolTip( false )")
		tempGroupSlot.recentPrice_Title = Created_RecentPrice_Title

		local Created_RecentPrice_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRecentPrice_Value_' .. itemList_Idx )				-- 최근 거래가
		CopyBaseProperty( TemplateItemMarket.txt_RecentPrice_Value, Created_RecentPrice_Value )
		Created_RecentPrice_Value:SetPosX( 480 )
		Created_RecentPrice_Value:SetPosY( 30 )
		Created_RecentPrice_Value:SetShow( true )
		tempGroupSlot.recentPrice_Value = Created_RecentPrice_Value

		local Created_RegistHighPrice_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRegistHighPrice_Title_' .. itemList_Idx )			-- 등록 최고가
		CopyBaseProperty( TemplateItemMarket.txt_RegistHighPrice_Title, Created_RegistHighPrice_Title )
		Created_RegistHighPrice_Title:SetPosX( 345 )
		Created_RegistHighPrice_Title:SetPosY( 7 )
		Created_RegistHighPrice_Title:SetShow( true )
		Created_RegistHighPrice_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_HIGHPRICE") ) -- "최고가" )
		Created_RegistHighPrice_Title:SetTextSpan( 30, 0 )
		Created_RegistHighPrice_Title:SetEnableArea( 0, 0, 70, Created_RegistHighPrice_Title:GetSizeY())
		Created_RegistHighPrice_Title:addInputEvent("Mouse_On", "_itemMarket_ShowIconToolTip( true, " .. 0 .. ", " .. 2 .. ", " .. itemList_Idx .. " )")
		Created_RegistHighPrice_Title:addInputEvent("Mouse_Out", "_itemMarket_ShowIconToolTip( false )")
		tempGroupSlot.registHighPrice_Title = Created_RegistHighPrice_Title

		local Created_RegistHighPrice_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRegistHighPrice_Value_' .. itemList_Idx )			-- 등록 최고가
		CopyBaseProperty( TemplateItemMarket.txt_RegistHighPrice_Value, Created_RegistHighPrice_Value )
		Created_RegistHighPrice_Value:SetPosX( 345 )
		Created_RegistHighPrice_Value:SetPosY( 30 )
		Created_RegistHighPrice_Value:SetShow( true )
		Created_RegistHighPrice_Value:SetTextHorizonCenter()
		tempGroupSlot.registHighPrice_Value = Created_RegistHighPrice_Value

		local Created_RegistLowPrice_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRegistLowPrice_Title_' .. itemList_Idx )				-- 등록 최저가
		CopyBaseProperty( TemplateItemMarket.txt_RegistLowPrice_Title, Created_RegistLowPrice_Title )
		Created_RegistLowPrice_Title:SetPosX( 225 )
		Created_RegistLowPrice_Title:SetPosY( 7 )
		Created_RegistLowPrice_Title:SetShow( true )
		Created_RegistLowPrice_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_LOWPRICE") ) -- "최저가" )
		Created_RegistLowPrice_Title:SetTextSpan( 30, 0 )
		Created_RegistLowPrice_Title:SetEnableArea( 0, 0, 70, Created_RegistLowPrice_Title:GetSizeY())
		Created_RegistLowPrice_Title:addInputEvent("Mouse_On", "_itemMarket_ShowIconToolTip( true, " .. 0 .. ", " .. 3 .. ", " .. itemList_Idx .. " )")
		Created_RegistLowPrice_Title:addInputEvent("Mouse_Out", "_itemMarket_ShowIconToolTip( false )")
		tempGroupSlot.registLowPrice_Title = Created_RegistLowPrice_Title

		local Created_RegistLowPrice_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRegistLowPrice_Value_' .. itemList_Idx )				-- 등록 최저가
		CopyBaseProperty( TemplateItemMarket.txt_RegistLowPrice_Value, Created_RegistLowPrice_Value )
		Created_RegistLowPrice_Value:SetPosX( 225 )
		Created_RegistLowPrice_Value:SetPosY( 30 )
		Created_RegistLowPrice_Value:SetShow( true )
		Created_RegistLowPrice_Value:SetTextHorizonCenter()
		tempGroupSlot.registLowPrice_Value = Created_RegistLowPrice_Value

		local Created_RegistListCount_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRegistListCount_Title_' .. itemList_Idx )			-- 등록 건수
		CopyBaseProperty( TemplateItemMarket.txt_RegistListCount_Title, Created_RegistListCount_Title )
		Created_RegistListCount_Title:SetPosX( 580 )
		Created_RegistListCount_Title:SetPosY( 10 )
		Created_RegistListCount_Title:SetShow( true )
		Created_RegistListCount_Title:SetEnableArea( 0, 0, 60, Created_RegistListCount_Title:GetSizeY())
		Created_RegistListCount_Title:addInputEvent("Mouse_On", "_itemMarket_ShowIconToolTip( true, " .. 0 .. ", " .. 4 .. ", " .. itemList_Idx .. " )")
		Created_RegistListCount_Title:addInputEvent("Mouse_Out", "_itemMarket_ShowIconToolTip( false )")
		tempGroupSlot.registListCount_Title = Created_RegistListCount_Title

		local Created_RegistListCount_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRegistListCount_Value_' .. itemList_Idx )			-- 누적 거래량
		CopyBaseProperty( TemplateItemMarket.txt_RegistListCount_Value, Created_RegistListCount_Value )
		Created_RegistListCount_Value:SetPosX( 585 )
		Created_RegistListCount_Value:SetPosY( 8 )
		Created_RegistListCount_Value:SetShow( true )
		tempGroupSlot.registListCount_Value = Created_RegistListCount_Value

		local Created_RegistItemCount_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRegistItemCount_Title_' .. itemList_Idx )			-- 등록 개수
		CopyBaseProperty( TemplateItemMarket.txt_RegistItemCount_Title, Created_RegistItemCount_Title )
		Created_RegistItemCount_Title:SetPosX( 580 )
		Created_RegistItemCount_Title:SetPosY( 32 )
		Created_RegistItemCount_Title:SetShow( true )
		Created_RegistItemCount_Title:SetEnableArea( 0, 0, 60, Created_RegistItemCount_Title:GetSizeY())
		Created_RegistItemCount_Title:addInputEvent("Mouse_On", "_itemMarket_ShowIconToolTip( true, " .. 0 .. ", " .. 5 .. ", " .. itemList_Idx .. " )")
		Created_RegistItemCount_Title:addInputEvent("Mouse_Out", "_itemMarket_ShowIconToolTip( false )")
		tempGroupSlot.registItemCount_Title = Created_RegistItemCount_Title

		local Created_RegistItemCount_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, 'ItemMarket_ItemListRegistItemCount_Value_' .. itemList_Idx )			-- 등록 개수
		CopyBaseProperty( TemplateItemMarket.txt_RegistItemCount_Value, Created_RegistItemCount_Value )
		Created_RegistItemCount_Value:SetPosX( 585 )
		Created_RegistItemCount_Value:SetPosY( 30 )
		Created_RegistItemCount_Value:SetShow( true )
		tempGroupSlot.registItemCount_Value = Created_RegistItemCount_Value

		local Created_Static_Line_1 = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemListBTN, 'ItemMarket_Static_Line_1_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.static_Line_1, Created_Static_Line_1 )
		Created_Static_Line_1:SetPosX( 445 )
		Created_Static_Line_1:SetPosY( 10 )
		Created_Static_Line_1:SetShow( true )
		tempGroupSlot.registItem_Line_1 = Created_Static_Line_1

		local Created_Static_Line_2 = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ItemListBTN, 'ItemMarket_Static_Line_2_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.static_Line_2, Created_Static_Line_2 )
		Created_Static_Line_2:SetPosX( 572 )
		Created_Static_Line_2:SetPosY( 10 )
		Created_Static_Line_2:SetShow( true )
		tempGroupSlot.registItem_Line_2 = Created_Static_Line_2

		local Created_Static_Dash = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ItemListBTN, "ItemMarket_Static_Dash_" .. itemList_Idx )
		CopyBaseProperty( ItemMarket._txt_price_dash, Created_Static_Dash )
		Created_Static_Dash:SetPosX( 295 )
		Created_Static_Dash:SetPosY( 30 )
		Created_Static_Dash:SetShow( true )
		tempGroupSlot.static_Dash = Created_Static_Dash

		self.itemGroupUiPool[itemList_Idx]	= tempGroupSlot

		------------------------------------------------------------------------
		-- 싱글 시작
		------------------------------------------------------------------------

		local tempSingleSlot = {}
		local Created_SingleItemBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.static_ItemListBG, 'ItemMarket_SingleItemBG_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.static_SingleSlotBg, Created_SingleItemBG )
		Created_SingleItemBG:SetPosX( 5 )
		Created_SingleItemBG:SetPosY( itemList_PosY )
		Created_SingleItemBG:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
		Created_SingleItemBG:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
		Created_SingleItemBG:SetShow( false )
		tempSingleSlot.itemBG = Created_SingleItemBG

		local Created_SingleItemSlotBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_SingleItemBG, 'ItemMarket_SingleItemSlotBG_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.static_SlotBg, Created_SingleItemSlotBG )
		Created_SingleItemSlotBG:SetPosX( 10 )
		Created_SingleItemSlotBG:SetPosY( 7 )
		Created_SingleItemSlotBG:SetShow( true )
		tempSingleSlot.itemSlotBG = Created_SingleItemSlotBG

		local createSlot = {}
		SlotItem.new( createSlot, 'ItemMarket_ItemSingleListSlotItem_' .. itemList_Idx, 0, Created_SingleItemSlotBG, self.slotSingleConfing )
		createSlot:createChild()
		tempSingleSlot.SlotItem = createSlot

		local Created_SingleItemBiddingMark = UI.createControl (UI_PUCT.PA_UI_CONTROL_STATIC, Created_SingleItemBG, 'ItemMarket_SingleItemBiddingMark_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.static_BiddingMark, Created_SingleItemBiddingMark )
		Created_SingleItemBiddingMark:SetPosX( 5 )
		Created_SingleItemBiddingMark:SetPosY( 3 )
		Created_SingleItemBiddingMark:SetShow( false )
		tempSingleSlot.biddingMark = Created_SingleItemBiddingMark

		local Created_SingleItemName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_SingleItemBG, 'ItemMarket_SingleItemName_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.txt_ItemName, Created_SingleItemName )
		Created_SingleItemName:SetPosX( 60 )
		Created_SingleItemName:SetPosY( 7 )
		Created_SingleItemName:SetTextMode( UI_TM.eTextMode_AutoWrap )
		Created_SingleItemName:SetShow( true )
		tempSingleSlot.itemName = Created_SingleItemName

		local Created_SingleSellPrice_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_SingleItemBG, 'ItemMarket_SingleSellPrice_Title_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.txt_SellPrice_Title, Created_SingleSellPrice_Title )
		Created_SingleSellPrice_Title:SetPosX( 240 )
		Created_SingleSellPrice_Title:SetPosY( 20 )
		Created_SingleSellPrice_Title:SetShow( true )
		tempSingleSlot.singleSellPrice_Title = Created_SingleSellPrice_Title

		local Created_SingleSellPrice_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_SingleItemBG, 'ItemMarket_SingleSellPrice_Value_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.txt_SellPrice_Value, Created_SingleSellPrice_Value )
		Created_SingleSellPrice_Value:SetPosX( 320 )
		Created_SingleSellPrice_Value:SetPosY( 20 )
		Created_SingleSellPrice_Value:SetShow( true )
		tempSingleSlot.singleSellPrice_Value = Created_SingleSellPrice_Value

		local Created_SingleRegistPeriod_Title = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_SingleItemBG, 'ItemMarket_SingleRegistPeriod_Title_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.txt_RegistPeriod_Title, Created_SingleRegistPeriod_Title )
		Created_SingleRegistPeriod_Title:SetPosX( 430 )
		Created_SingleRegistPeriod_Title:SetPosY( 20 )
		Created_SingleRegistPeriod_Title:SetShow( true )
		tempSingleSlot.singleRegistPeriod_Title = Created_SingleRegistPeriod_Title

		local Created_SingleRegistPeriod_Value = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_SingleItemBG, 'ItemMarket_SingleRegistPeriod_Value_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.txt_RegistPeriod_Value, Created_SingleRegistPeriod_Value )
		Created_SingleRegistPeriod_Value:SetPosX( 500 )
		Created_SingleRegistPeriod_Value:SetPosY( 20 )
		Created_SingleRegistPeriod_Value:SetShow( true )
		tempSingleSlot.singleRegistPeriod_Value = Created_SingleRegistPeriod_Value

		local Created_SingleItemBuyItemBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_SingleItemBG, 'ItemMarket_SingleItemBuyItemBTN_' .. itemList_Idx )
		CopyBaseProperty( TemplateItemMarket.btn_BuyItem, Created_SingleItemBuyItemBTN )
		Created_SingleItemBuyItemBTN:SetPosX( 620 )
		Created_SingleItemBuyItemBTN:SetPosY( 10 )
		Created_SingleItemBuyItemBTN:SetShow( true )
		tempSingleSlot.buyItemBTN = Created_SingleItemBuyItemBTN

		-- btn_BuyItem
		self.itemSingleUiPool[itemList_Idx]	= tempSingleSlot
		itemList_PosY	= itemList_PosY + Created_ItemListBTN:GetSizeY() + 2
	end

	local iconTooltips	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Window_ItemMarket, "ItemMarket_PriceTitleToolTip" )
	CopyBaseProperty( TemplateItemMarket.iconTooltip, iconTooltips )
	iconTooltips:SetColor( ffffffff )
	iconTooltips:SetAlpha( 1.0 )
	iconTooltips:SetFontColor( UI_color.C_FFC4BEBE )
	iconTooltips:SetAutoResize( true )
	iconTooltips:SetSize( 120, iconTooltips:GetSizeY() )
	iconTooltips:SetTextMode( UI_TM.eTextMode_AutoWrap )
	iconTooltips:SetTextHorizonCenter()
	iconTooltips:SetShow( false )

	self.iconTooltip = iconTooltips
end

function _getIsClassTypeByFilter( idx )
	local maxClassCount = getCharacterClassCount()

	if maxClassCount -1 < idx then
		return false
	end

	local	classType	= getCharacterClassTypeByIndex( idx )
	local	className	= getCharacterClassName( classType )
	-- if in_array ( idx, {24,28,30} ) then	className = nil  end
	if ( nil ~= className ) and ( "" ~= className ) and ( " " ~= className ) then
		return true
	end

	return false
end

function ItemMarket:Update( startIndex )
	if false == Panel_Window_ItemMarket:GetShow() then		-- 창이 열려 있지 않으면 리턴
		return
	end
	
	if self.categoryUiPool[99]:IsCheck() then			-- 특가상품이 체크돼 있으면 특가상품 업데이트
		self:SpecialGoodsUpdate( startIndex )
		return
	end

	if nil == startIndex then
		startIndex = 0
	end

	if true == self.isGrouplist then
		self.txt_Sort_Parent:SetShow( true )
		self.static_SlotBg:SetShow( false )
	else
		self.txt_Sort_Parent:SetShow( false )
		self.static_SlotBg:SetShow( true )
	end

	--초기화
	for category_Idx = 0, #DummyData.Category do
		local categoryButton = self.categoryUiPool[category_Idx]
		categoryButton:SetShow( true )
		categoryButton:SetCheck( false )
	end
	local categoryButton = self.categoryUiPool[99]
	categoryButton:SetShow( registMarket )
	categoryButton:SetCheck( false )
	
	self.categoryUiPool[self.curItemClassify]:SetCheck( true )
	for idx = 0, self.itemList_MaxCount - 1 do
		self.itemGroupUiPool[idx].SlotItem	:clearItem()
		self.itemSingleUiPool[idx].SlotItem	:clearItem()
		self.itemGroupUiPool[idx].itemBTN	:SetShow( false )
		self.itemSingleUiPool[idx].itemBG	:SetShow( false )
	end
	
	local itemInfoCount = 0;
	if( self.isGrouplist ) then
		itemInfoCount = getItemMarketSummaryInClientCount( self.curItemClassify )
	else
		itemInfoCount = getItemMarketSellInfoInClientCount( self.curTerritoryKeyRaw , self.sellInfoItemEnchantKeyRaw )
	end

	local replaceCount = function( num )
		local count = Int64toInt32( num )
		if 0 == count then
			count = "-"
		else
			count = makeDotMoney( num )
		end
		return count
	end
	
	self.txt_SpecialGoodsName:SetShow( false )
	self.txt_SpecialGoodsDesc:SetShow( false )

	-- 종합 정보 보기
	if self.isGrouplist then
		local uiPoolIdx = 0
		for ui_Idx = 0, self.itemList_MaxCount - 1 do	
			local item_idx = startIndex + ui_Idx	
			local itemMarketSummaryInfo = getItemMarketSummaryInClientByIndex( self.curItemClassify, item_idx )
			if( nil ~= itemMarketSummaryInfo ) then
				--if(0 < itemMarketSummaryInfo:getDisplayedTotalCount()) then
					local UiBase = self.itemGroupUiPool[uiPoolIdx]
					local iess = itemMarketSummaryInfo:getItemEnchantStaticStatusWrapper()
					_PA_ASSERT( nil ~= iess, "itemMarketSummaryInfo 아이템 고정정보가 꼭 있어야합니다")
					
					local enchantLevel = iess:get()._key:getEnchantLevel()
					local itemEnchantKeyRaw = iess:get()._key:get()

					local nameColorGrade	= iess:getGradeType()
					
					-- 네임 컬러
					local nameColor = self:SetNameColor( nameColorGrade )

					UiBase.itemName:SetFontColor( nameColor )

					-- 아이템명 + 인챈트 레벨
					local enchantLevel = iess:get()._key:getEnchantLevel()
					local itemNameStr = self:SetNameAndEnchantLevel( enchantLevel, iess:getItemType(), iess:getName(), iess:getItemClassify() )
					UiBase.itemName:SetText( itemNameStr )					-- 아이템 이름

					UiBase.SlotItem:setItemByStaticStatus( iess, 1, -1, false  )
					UiBase.SlotItem.icon			:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarket_GroupItem( " .. item_idx .. ",".. itemEnchantKeyRaw .." )" )
					UiBase.SlotItem.icon			:addInputEvent("Mouse_On",	"_itemMarket_ShowToolTip( " .. item_idx .. ", " .. ui_Idx .. "  )")
					UiBase.SlotItem.icon			:addInputEvent("Mouse_Out",	"_itemMarket_HideToolTip()")
					UiBase.SlotItem.icon			:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
					UiBase.SlotItem.icon			:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
					UiBase.averagePrice_Title		:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
					UiBase.averagePrice_Title		:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
					UiBase.registHighPrice_Title	:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
					UiBase.registHighPrice_Title	:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
					UiBase.registLowPrice_Title		:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
					UiBase.registLowPrice_Title		:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
					UiBase.registListCount_Title	:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
					UiBase.registListCount_Title	:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
					UiBase.registItemCount_Title	:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
					UiBase.registItemCount_Title	:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
					UiBase.recentPrice_Title		:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
					UiBase.recentPrice_Title		:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
					-- UiBase.itemSlot:ChangeTextureInfoName( "Icon/" .. iess:getIconPath() )
					
					-- 특가 상품은 등록 개수 제외 모두 꺼준다
					UiBase.averagePrice_Title		:SetShow( true )
					UiBase.averagePrice_Value		:SetShow( true )
					UiBase.registListCount_Title	:SetShow( true )
					UiBase.registListCount_Value	:SetShow( true )
					UiBase.recentPrice_Title		:SetShow( true )
					UiBase.recentPrice_Value		:SetShow( true )
					UiBase.registItem_Line_1		:SetShow( true )
					UiBase.registItem_Line_2		:SetShow( true )
					UiBase.registItemCount_Title	:SetPosY( 32 )
					UiBase.registItemCount_Value	:SetPosY( 30 )

					UiBase.registHighPrice_Value	:SetText( replaceCount( itemMarketSummaryInfo:getDisplayedHighestOnePrice()  ) )
					UiBase.registLowPrice_Value		:SetText( replaceCount( itemMarketSummaryInfo:getDisplayedLowestOnePrice() ) )

					local masterInfo		= getItemMarketMasterByItemEnchantKey( itemEnchantKeyRaw )
					local marketConditions	= (masterInfo:getMinPrice() + masterInfo:getMaxPrice()) / toInt64(0,2)

					UiBase.averagePrice_Value		:SetText( replaceCount( marketConditions ) )	-- 시세 평균
					UiBase.recentPrice_Value		:SetText( replaceCount( itemMarketSummaryInfo:getLastTradedOnePrice() ) )
					UiBase.registListCount_Value	:SetText( replaceCount( itemMarketSummaryInfo:getTradedTotalAmount() ) )	 -- 누적 거래량
					UiBase.registItemCount_Value	:SetText( replaceCount( itemMarketSummaryInfo:getDisplayedTotalAmount() ) )
					
					UiBase.itemBTN:addInputEvent( "Mouse_LUp", "HandleClicked_ItemMarket_SetScrollIndexByLClick(); HandleClicked_ItemMarket_GroupItem( " .. item_idx .. ",".. itemEnchantKeyRaw .." )" )	-- 매물 클릭
					UiBase.itemBTN:SetShow( true )

					if 0 == Int64toInt32(itemMarketSummaryInfo:getDisplayedTotalAmount()) then
						UiBase.itemBTN:SetMonoTone( true )
					else
						UiBase.itemBTN:SetMonoTone( false )
					end
					
					uiPoolIdx = uiPoolIdx + 1
				--end	
			end		
			self.btn_Sort_ItemName			:SetShow( true )
			self.btn_Sort_RecentPrice		:SetShow( true )
			self.btn_Sort_RegistItemCount	:SetShow( true )
			self.btn_Sort_AverageTradePrice	:SetShow( true )
			self.btn_Sort_RecentRegistDate	:SetShow( true )
			self.btn_Search					:SetShow( true )
			self.btn_ResetSearch			:SetShow( true )
			self.edit_ItemName				:SetShow( true )
		end
		self:SetScroll()

		if itemInfoCount <= self.itemList_MaxCount then
			self.scroll:SetShow( false )
		else
			self.scroll:SetShow( true )
		end

	else -- 구입 정보 보기 (뷰페이지)
		-- 선택된 아이템의 종합정보
		local summaryInfo = getItemMarketSummaryInClientByItemEnchantKey( self.sellInfoItemEnchantKeyRaw )
		if( nil == summaryInfo ) then
			_PA_ASSERT( false, "summaryInfo 아이템 종합정보가 꼭 있어야합니다")
			return;
		end
		
		local summaryIess = summaryInfo:getItemEnchantStaticStatusWrapper()
		_PA_ASSERT( nil ~= summaryIess, "summaryInfo 아이템 고정정보가 꼭 있어야합니다")
			
		local enchantLevel		= summaryIess:get()._key:getEnchantLevel()
		local itemEnchantKeyRaw	= summaryIess:get()._key:get()

		local nameColorGrade	= summaryIess:getGradeType()
		-- 네임 컬러
		local nameColor = self:SetNameColor( nameColorGrade )
		self.txt_ItemName				:SetFontColor( nameColor )

		local enchantLevel = summaryIess:get()._key:getEnchantLevel()
		local itemNameStr = self:SetNameAndEnchantLevel( enchantLevel, summaryIess:getItemType(), summaryIess:getName(), summaryIess:getItemClassify() )
		self.txt_ItemName:SetTextMode( UI_TM.eTextMode_AutoWrap )
		self.txt_ItemName:SetText( itemNameStr )						-- 아이템 이름

		-- self.txt_ItemName				:SetText( summaryIess:getName()  )
		self.selectSingleSlot			:setItemByStaticStatus( summaryIess, 1, -1, false )
		self.selectSingleSlot.icon		:addInputEvent("Mouse_On",	"_itemMarket_ShowToolTip( " .. 0 .. ", " .. 0 .. ", true )")
		self.selectSingleSlot.icon		:addInputEvent("Mouse_Out",	"_itemMarket_HideToolTip()")

		self.averagePrice_Title			:SetShow( true )
		self.recentPrice_Title			:SetShow( true )
		self.registListCount_Title		:SetShow( true )
		self.registItemCount_Title		:SetShow( true )
		self.txt_AveragePrice_Value		:SetShow( true )
		self.txt_RecentPrice_Value		:SetShow( true )
		self.txt_RegistListCount_Value	:SetShow( true )
		self.txt_RegistItemCount_Value	:SetShow( true )
		
		local masterInfo		= getItemMarketMasterByItemEnchantKey( itemEnchantKeyRaw )
		local marketConditions	= (masterInfo:getMinPrice() + masterInfo:getMaxPrice()) / toInt64(0,2)

		self.txt_AveragePrice_Value		:SetText( replaceCount( marketConditions ) )	-- 시세로 수정 필요.
		self.txt_RecentPrice_Value		:SetText( replaceCount( summaryInfo:getLastTradedOnePrice() ) )
		self.txt_RegistHighPrice_Value	:SetText( replaceCount( summaryInfo:getDisplayedHighestOnePrice() ) )
		self.txt_RegistLowPrice_Value	:SetText( replaceCount( summaryInfo:getDisplayedLowestOnePrice() ) )
		self.txt_RegistListCount_Value	:SetText( replaceCount( summaryInfo:getTradedTotalAmount() ) )
		self.txt_RegistItemCount_Value	:SetText( replaceCount( summaryInfo:getDisplayedTotalAmount() ) )
		
		for ui_Idx = 0, self.itemList_MaxCount - 2 do
			local item_idx = startIndex + ui_Idx	
			-- 선택된 아이템의 sellList
			local sellInfo = getItemMarketSellInfoInClientByIndex( self.curTerritoryKeyRaw , self.sellInfoItemEnchantKeyRaw, item_idx )
			local itemAmount	= summaryInfo:getDisplayedTotalAmount()
			if( nil ~= sellInfo ) then
				
				local UiBase = self.itemSingleUiPool[ui_Idx]
				
				local iess = sellInfo:getItemEnchantStaticStatusWrapper()
				_PA_ASSERT( nil ~= iess, "sellInfo 아이템 고정정보가 꼭 있어야합니다")
				
				local enchantLevel	= iess:get()._key:getEnchantLevel()
				UiBase.itemName:SetFontColor( nameColor )

				local isBiddingItem	= sellInfo:isBiddingItem() -- 아이템 입찰제 여부 (true 입찰제 / false 입찰제 아님)
				local isBuyItem		= sellInfo:isBuyItem() -- 버튼 활성 여부 (true 활성 / false 비활성)
				if isBiddingItem then
					UiBase.biddingMark:SetShow( true )
				else
					UiBase.biddingMark:SetShow( false )
				end

				-- 아이템명 처리.
				local itemNameStr = self:SetNameAndEnchantLevel( enchantLevel, iess:getItemType(), iess:getName(), iess:getItemClassify() )
				UiBase.itemName:SetText( itemNameStr )

				-- _PA_LOG("luadebug", " ItemMarket:Update( " ..item_idx .. tostring(sellInfo:getCount())  );

				UiBase.SlotItem:setItemByStaticStatus( iess, sellInfo:getCount(), -1, false )
				UiBase.SlotItem.icon:addInputEvent("Mouse_On",	"_itemMarket_ShowToolTip( " .. item_idx .. ", " .. ui_Idx .. ", false  )")
				UiBase.SlotItem.icon:addInputEvent("Mouse_Out",	"_itemMarket_HideToolTip()")
				UiBase.SlotItem.icon:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
				UiBase.SlotItem.icon:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
				-- if true == UiBase.SlotItem.count:GetShow() then
					-- UiBase.SlotItem.count:EraseAllEffect()
					-- UiBase.SlotItem.count:AddEffect("UI_Item_MenuAura02",true, 10, 0)	-- 아이템 갯수 부분에 이펙트 삽입
				-- end

				local itemEnchantKeyRaw =	iess:get()._key:get()
				local sumSinglePrice = sellInfo:getTotalPrice() / sellInfo:getCount()				
				UiBase.singleSellPrice_Value:SetText( makeDotMoney( sumSinglePrice ) )
				UiBase.singleRegistPeriod_Value:SetText( converStringFromLeftDateTime( sellInfo:getDisplayedEndDate() ) ) 
				UiBase.singleRegistPeriod_Title:SetShow( true )
				UiBase.singleRegistPeriod_Value:SetShow( true )
				
				if(  true == ToClient_WorldMapIsShow() or ItemMarket.escMenuSaveValue ) then
					UiBase.buyItemBTN:SetShow(false)
				else
					UiBase.buyItemBTN:SetShow(true)
					if true == isBuyItem then
						UiBase.buyItemBTN:SetEnable( true )
						UiBase.buyItemBTN:SetMonoTone( false )
						UiBase.buyItemBTN:SetFontColor( Defines.Color.C_FFEFEFEF )
					else
						UiBase.buyItemBTN:SetEnable( false )
						UiBase.buyItemBTN:SetMonoTone( true )
						UiBase.buyItemBTN:SetFontColor( Defines.Color.C_FF626262 )
					end
					UiBase.buyItemBTN:addInputEvent( "Mouse_LUp", "HandleClicked_ItemMarket_SingleItem( " .. item_idx ..",".. self.sellInfoItemEnchantKeyRaw .. ")" )
				end
				UiBase.buyItemBTN:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
				UiBase.buyItemBTN:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
				UiBase.itemBG:SetShow( true )

			end
		end	
		-- self.scroll:SetSize( self.scroll:GetSizeX(), 390 )
		-- self.static_ItemListBG:SetSize( self.static_ItemListBG:GetSizeX(), 380 )

		if itemInfoCount <= self.itemList_MaxCount -1 then
			self.scroll:SetShow( false )
		else
			self.scroll:SetShow( true )
		end
	end
end

function ItemMarket:SetNameColor( nameColorGrade )	-- 아이템명 색상 적용.
	local nameColor			= nil
	if ( 0 == nameColorGrade ) then
		nameColor = UI_color.C_FFFFFFFF
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
	return nameColor
end

function ItemMarket:SetNameAndEnchantLevel( enchantLevel, itemType, itemName, itemClassify )	-- 아이템명 + 인챈트 레벨
	local nameStr = ""
	if 1 == itemType and 15 < enchantLevel then -- 장비이고, 강화수치가 14보다 크면
		nameStr = ( HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemName )	-- 아이템 이름
	elseif 0 < enchantLevel and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then
		nameStr = ( HighEnchantLevel_ReplaceString(enchantLevel+15) .. " " .. itemName )	-- 아이템 이름
	else
		nameStr = ( itemName )															-- 아이템 이름
	end
	return nameStr
end

function ItemMarket:SpecialGoodsUpdate( startIndex )
	if false == Panel_Window_ItemMarket:GetShow() then		-- 창이 열려 있지 않으면 리턴
		return
	end
	
	if not self.categoryUiPool[99]:IsCheck() then			-- 특가상품이 체크돼 있지 않으면 리턴
		return
	end
	
	if nil == startIndex then
		startIndex = 0
	end
	
	if self.isGrouplist then
		self.txt_Sort_Parent:SetShow( true )
		self.static_SlotBg:SetShow( false )
	else
		self.txt_Sort_Parent:SetShow( false )
		self.static_SlotBg:SetShow( true )
	end

	--초기화
	for category_Idx = 0, #DummyData.Category do
		local categoryButton = self.categoryUiPool[category_Idx]
		categoryButton:SetShow( true )
		categoryButton:SetCheck( false )
	end
	local categorySpecialButton = self.categoryUiPool[99]
	categorySpecialButton:SetShow( registMarket )
	categorySpecialButton:SetCheck( false )

	self.categoryUiPool[99]:SetCheck( true )
	
	for idx = 0, self.itemList_MaxCount - 1 do
		self.itemGroupUiPool[idx].SlotItem	:clearItem()
		self.itemSingleUiPool[idx].SlotItem	:clearItem()
		self.itemGroupUiPool[idx].itemBTN	:SetShow( false )
		self.itemSingleUiPool[idx].itemBG	:SetShow( false )
	end
	
	local itemCount = ToClient_requestGetSummaryCount()
	
	local replaceCount = function( num )
		local count = Int64toInt32( num )
		if 0 == count then
			count = "-"
		else
			count = makeDotMoney( num )
		end
		return count
	end
	
	self.btn_SetAlarm:SetShow( false )
	self.btn_Refresh:SetShow( false )
	
	if self.isGrouplist then
		self.btn_BackPage:SetShow( false )
		local uiPoolIdx = 0
		for ui_Idx = 0, self.itemList_MaxCount - 1 do
			local item_idx = startIndex + ui_Idx
			local itemMarketSummaryInfo = ToClient_requestGetItemEnchantStaticStatusWrapperByIndex( item_idx )
			if nil ~= itemMarketSummaryInfo then
				local UiBase = self.itemGroupUiPool[uiPoolIdx]
				
				local enchantLevel = itemMarketSummaryInfo:get()._key:getEnchantLevel()
				local itemEnchantKeyRaw = itemMarketSummaryInfo:get()._key:get()

				local nameColorGrade	= itemMarketSummaryInfo:getGradeType()
				local nameColor			= nil
				if ( 0 == nameColorGrade ) then
					nameColor = UI_color.C_FFFFFFFF
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

				local enchantLevel = itemMarketSummaryInfo:get()._key:getEnchantLevel()
				if 1 == itemMarketSummaryInfo:getItemType() and 15 < enchantLevel then					-- 장비이고, 강화수치가 14보다 크면
					UiBase.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemMarketSummaryInfo:getName() )	-- 아이템 이름
				elseif 0 < enchantLevel and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemMarketSummaryInfo:getItemClassify() then
					UiBase.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel+15) .. " " .. itemMarketSummaryInfo:getName() )	-- 아이템 이름
				else
					UiBase.itemName:SetText( itemMarketSummaryInfo:getName() )															-- 아이템 이름
				end

				UiBase.SlotItem:setItemByStaticStatus( itemMarketSummaryInfo, 1, -1, false  )
				UiBase.SlotItem.icon			:addInputEvent("Mouse_LUp", "HandleClicked_SpecialGoods_GroupItem( " .. item_idx .. ",".. itemEnchantKeyRaw .." )" )
				UiBase.SlotItem.icon			:addInputEvent("Mouse_On",	"_specialGoods_ShowToolTip( " .. item_idx .. ", " .. ui_Idx .. "  )")
				UiBase.SlotItem.icon			:addInputEvent("Mouse_Out",	"_itemMarket_HideToolTip()")
				UiBase.SlotItem.icon			:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
				UiBase.SlotItem.icon			:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
				UiBase.registHighPrice_Title	:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
				UiBase.registHighPrice_Title	:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
				UiBase.registLowPrice_Title		:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
				UiBase.registLowPrice_Title		:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
				UiBase.registItemCount_Title	:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
				UiBase.registItemCount_Title	:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")

				UiBase.registHighPrice_Value	:SetText( replaceCount( ToClient_requestGetDisplayedHighestOnePriceByItemEnchantKeyRaw(itemEnchantKeyRaw)))
				UiBase.registLowPrice_Value		:SetText( replaceCount( ToClient_requestGetDisplayedLowestOnePriceByItemEnchantKeyRaw(itemEnchantKeyRaw)))

				-- 특가 상품은 등록 개수 제외 모두 꺼준다
				UiBase.averagePrice_Title		:SetShow( false )
				UiBase.averagePrice_Value		:SetShow( false )
				UiBase.registListCount_Title	:SetShow( false )
				UiBase.registListCount_Value	:SetShow( false )
				UiBase.recentPrice_Title		:SetShow( false )
				UiBase.recentPrice_Value		:SetShow( false )
				UiBase.registItem_Line_1		:SetShow( false )
				UiBase.registItem_Line_2		:SetShow( false )
				UiBase.registItemCount_Value	:SetText( replaceCount( ToClient_requestGetItemCountByItemEnchantKeyRaw(itemEnchantKeyRaw)))
				UiBase.itemBTN:addInputEvent( "Mouse_LUp", "HandleClicked_ItemMarket_SetScrollIndexByLClick(); HandleClicked_SpecialGoods_GroupItem( " .. item_idx .. ",".. itemEnchantKeyRaw .." )" )	-- 매물 클릭
				UiBase.itemBTN:SetShow( true )
				UiBase.registItemCount_Title	:SetPosY( 22 )
				UiBase.registItemCount_Value	:SetPosY( 20 )
				

				if 0 == ToClient_requestGetItemCountByItemEnchantKeyRaw(itemEnchantKeyRaw) then
					UiBase.itemBTN:SetMonoTone( true )
				else
					UiBase.itemBTN:SetMonoTone( false )
				end
				
				uiPoolIdx = uiPoolIdx + 1
			end		
			self.btn_Sort_ItemName			:SetShow( false )
			self.btn_Sort_RecentPrice		:SetShow( false )
			self.btn_Sort_RegistItemCount	:SetShow( false )
			self.btn_Sort_AverageTradePrice	:SetShow( false )
			self.btn_Sort_RecentRegistDate	:SetShow( false )
			self.btn_Search					:SetShow( false )
			self.btn_ResetSearch			:SetShow( false )
			self.edit_ItemName				:SetShow( false )
		end
		-- self.scroll:SetSize( self.scroll:GetSizeX(), 450 )
		-- self.static_ItemListBG:SetSize( self.static_ItemListBG:GetSizeX(), 440 )
		self:SetScroll()
		self.txt_SpecialGoodsName:SetShow( true )
		self.txt_SpecialGoodsDesc:SetShow( true )
				
	else
		local itemMarketSummaryInfo = getItemEnchantStaticStatus( ItemEnchantKey(self.specialItemEnchantKeyRaw) )
		local itemEnchantKeyRaw = itemMarketSummaryInfo:get()._key:get()
		local enchantLevel		= itemMarketSummaryInfo:get()._key:getEnchantLevel()
		itemCount = ToClient_requestGetItemCountByItemEnchantKeyRaw(itemEnchantKeyRaw)

		local nameColorGrade	= itemMarketSummaryInfo:getGradeType()
		local nameColor			= nil
		if ( 0 == nameColorGrade ) then
			nameColor = UI_color.C_FFFFFFFF
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

		self.txt_ItemName				:SetFontColor( nameColor )

		local enchantLevel = itemMarketSummaryInfo:get()._key:getEnchantLevel()
			self.txt_ItemName				:SetTextMode( UI_TM.eTextMode_AutoWrap )
		if 1 == itemMarketSummaryInfo:getItemType() and 15 < enchantLevel then -- 장비이고, 강화수치가 14보다 크면
			self.txt_ItemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemMarketSummaryInfo:getName() )	-- 아이템 이름
		elseif 0 < enchantLevel and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemMarketSummaryInfo:getItemClassify() then
			self.txt_ItemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel+15) .. " " .. itemMarketSummaryInfo:getName() )	-- 아이템 이름
		else
			self.txt_ItemName:SetText( itemMarketSummaryInfo:getName() )															-- 아이템 이름
		end

		self.selectSingleSlot			:setItemByStaticStatus( itemMarketSummaryInfo, 1, -1, false )
		self.txt_RegistHighPrice_Value	:SetText( replaceCount( ToClient_requestGetDisplayedHighestOnePriceByItemEnchantKeyRaw(itemEnchantKeyRaw)))
		self.txt_RegistLowPrice_Value	:SetText( replaceCount( ToClient_requestGetDisplayedLowestOnePriceByItemEnchantKeyRaw(itemEnchantKeyRaw)))
		
		self.averagePrice_Title			:SetShow( false )
		self.recentPrice_Title			:SetShow( false )
		self.registListCount_Title		:SetShow( false )
		self.registItemCount_Title		:SetShow( false )
		self.txt_AveragePrice_Value		:SetShow( false )
		self.txt_RecentPrice_Value		:SetShow( false )
		self.txt_RegistListCount_Value	:SetShow( false )
		self.txt_RegistItemCount_Value	:SetShow( false )
		
		self.selectSingleSlot.icon		:addInputEvent("Mouse_On",	"_specialGoodsSingle_ShowToolTip( " .. itemEnchantKeyRaw .. ")" )
		self.selectSingleSlot.icon		:addInputEvent("Mouse_Out",	"_itemMarket_HideToolTip()")
		
		
		local maxCount = math.min( itemCount - 1, self.itemList_MaxCount - 2 )
		for ui_Idx = 0, maxCount do
			local item_idx = startIndex + ui_Idx	
			if( nil ~= itemMarketSummaryInfo ) then
				
				local UiBase = self.itemSingleUiPool[ui_Idx]
				UiBase.itemName:SetFontColor( nameColor )

				if 1 == itemMarketSummaryInfo:getItemType() and 15 < enchantLevel then -- 장비이고, 강화수치가 14보다 크면
					UiBase.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemMarketSummaryInfo:getName() )	-- 아이템 이름
				elseif 0 < enchantLevel and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemMarketSummaryInfo:getItemClassify() then
					UiBase.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel+15) .. " " .. itemMarketSummaryInfo:getName() )	-- 아이템 이름
				else
					UiBase.itemName:SetText( itemMarketSummaryInfo:getName() )															-- 아이템 이름
				end

				UiBase.SlotItem:setItemByStaticStatus( itemMarketSummaryInfo, 1, -1, false )
				UiBase.SlotItem.icon:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
				UiBase.SlotItem.icon:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
				UiBase.SlotItem.icon:addInputEvent("Mouse_On",	"_specialGoodsSingle_ShowToolTip( " .. itemEnchantKeyRaw .. ", " .. ui_Idx .. "  )")
				UiBase.SlotItem.icon:addInputEvent("Mouse_Out",	"_itemMarket_HideToolTip()")
				UiBase.singleSellPrice_Value:SetText( makeDotMoney(  ToClient_requestGetItemPrice(itemEnchantKeyRaw, item_idx) ) )
				
				UiBase.singleRegistPeriod_Title:SetShow( false )
				UiBase.singleRegistPeriod_Value:SetShow( false )
				
				if(  true == ToClient_WorldMapIsShow() or ItemMarket.escMenuSaveValue ) then
					UiBase.buyItemBTN:SetShow(false)
				else
					UiBase.buyItemBTN:SetShow(true)
					UiBase.buyItemBTN:SetEnable( true )
					UiBase.buyItemBTN:SetMonoTone( false )
					UiBase.buyItemBTN:SetFontColor( Defines.Color.C_FFEFEFEF )
					UiBase.buyItemBTN:addInputEvent( "Mouse_LUp", "HandleClicked_ItemMarket_SpecialItem( " .. item_idx ..",".. itemEnchantKeyRaw .. ")" )
				end
				UiBase.buyItemBTN:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
				UiBase.buyItemBTN:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
				UiBase.itemBG:SetShow( true )

			end
		end	
		-- self.scroll:SetSize( self.scroll:GetSizeX(), 390 )
		-- self.static_ItemListBG:SetSize( self.static_ItemListBG:GetSizeX(), 380 )	
		self.txt_SpecialGoodsName:SetShow( false )
		self.txt_SpecialGoodsDesc:SetShow( false )
	
	end
	-- if itemCount <= self.itemList_MaxCount then
		-- self.scroll:SetShow( false )
	-- else
		-- self.scroll:SetShow( true )
	-- end

end

function ItemMarket:ResetFilterBtn()
	self.curFilterIndex = -1;

	-- 신규 클래스가 나오면 해당카운트를 수정해주어야한다.
	if isGameTypeJapan() then
		self.itemmarketClassCount = 11
	elseif isGameTypeRussia() then
		self.itemmarketClassCount = 6
	elseif isGameTypeEnglish() then
		self.itemmarketClassCount = 8
	end

	for filter_Idx = 0, self.itemmarketClassCount-1 do
		ItemMarket.filterUiPool[filter_Idx]:SetCheck(false)
	end
end

function ItemMarket:SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_Window_ItemMarket:GetSizeX()
	local panelSizeY 	= Panel_Window_ItemMarket:GetSizeY()

	Panel_Window_ItemMarket:SetPosX( (scrSizeX / 2) - (panelSizeX / 2) )
	Panel_Window_ItemMarket:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) )
end

function _itemMarket_doSortList( sortTarget, sortValue, isResetScroll )
	local self = ItemMarket
	
	local isNum = 0;
	if( true == sortValue ) then
		isNum  = 1
	end
	selectSort( sortTarget, isNum )
	
	if nil == isResetScroll or isResetScroll then
		self.nowStartIdx = 0	
		self.scroll:SetControlTop()
	end
	
	self:SetScroll()
	self:Update( self.nowStartIdx )
end
function _itemMarket_ChangeTextureByCategory( categoryIdx )
	local self		= ItemMarket
	local control	= self.categoryUiPool[categoryIdx]
	control:ChangeTextureInfoName( "New_UI_Common_forLua/Window/ItemMarket/ItemMarket_02.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, _categoryTexture[categoryIdx][0][1], _categoryTexture[categoryIdx][0][2], _categoryTexture[categoryIdx][0][3], _categoryTexture[categoryIdx][0][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture( control:getBaseTexture() )

	local x1, y1, x2, y2 = setTextureUV_Func( control, _categoryTexture[categoryIdx][1][1], _categoryTexture[categoryIdx][1][2], _categoryTexture[categoryIdx][1][3], _categoryTexture[categoryIdx][1][4] )
	control:getOnTexture():setUV(  x1, y1, x2, y2  )

	local x1, y1, x2, y2 = setTextureUV_Func( control, _categoryTexture[categoryIdx][2][1], _categoryTexture[categoryIdx][2][2], _categoryTexture[categoryIdx][2][3], _categoryTexture[categoryIdx][2][4] )
	control:getClickTexture():setUV(  x1, y1, x2, y2  )
end
function _itemMarket_ChangeTextureBySort( control, sortTarget, sortValue )
	local self		= ItemMarket
	if true == sortValue then
		sortValue = 0
	else
		sortValue = 1
	end
	control:ChangeTextureInfoName( "New_UI_Common_forLua/Window/ItemMarket/ItemMarket_01.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, _sortTexture[sortTarget][sortValue][0][1], _sortTexture[sortTarget][sortValue][0][2], _sortTexture[sortTarget][sortValue][0][3], _sortTexture[sortTarget][sortValue][0][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture( control:getBaseTexture() )

	local x1, y1, x2, y2 = setTextureUV_Func( control, _sortTexture[sortTarget][sortValue][1][1], _sortTexture[sortTarget][sortValue][1][2], _sortTexture[sortTarget][sortValue][1][3], _sortTexture[sortTarget][sortValue][1][4] )
	control:getOnTexture():setUV(  x1, y1, x2, y2  )

	local x1, y1, x2, y2 = setTextureUV_Func( control, _sortTexture[sortTarget][sortValue][2][1], _sortTexture[sortTarget][sortValue][2][2], _sortTexture[sortTarget][sortValue][2][3], _sortTexture[sortTarget][sortValue][2][4] )
	control:getClickTexture():setUV(  x1, y1, x2, y2  )
end
function _itemMarket_ShowToolTip( item_idx, ui_Idx, isSelected )
	local self					= ItemMarket
	local itemStaticStatus		= nil
	local UiBase				= nil
	if nil == isSelected then
		local itemMarketSummaryInfo = getItemMarketSummaryInClientByIndex( self.curItemClassify, item_idx )
		itemStaticStatus			= itemMarketSummaryInfo:getItemEnchantStaticStatusWrapper()
		UiBase 						= self.itemGroupUiPool[ui_Idx].SlotItem.icon
		Panel_Tooltip_Item_Show( itemStaticStatus, UiBase, true, false, nil )
	elseif true == isSelected then
		local summaryInfo	= getItemMarketSummaryInClientByIndex( self.curItemClassify, self.curSummaryItemIndex )
		itemStaticStatus	= summaryInfo:getItemEnchantStaticStatusWrapper()
		UiBase 				= self.selectSingleSlot.icon
		Panel_Tooltip_Item_Show( itemStaticStatus, UiBase, true, false, nil )
	elseif false == isSelected then
		local sellInfo		= getItemMarketSellInfoInClientByIndex( self.curTerritoryKeyRaw , self.sellInfoItemEnchantKeyRaw, item_idx )
		itemWrapper			= sellInfo:getItemWrapper()
		UiBase				= self.itemSingleUiPool[ui_Idx].SlotItem.icon
		Panel_Tooltip_Item_Show( itemWrapper, UiBase, false, true, nil, nil, true )
	end
end
function _specialGoods_ShowToolTip( item_idx, ui_Idx )
	local self					= ItemMarket
	local itemStaticStatus		= nil
	local UiBase				= nil
	itemStaticStatus			= ToClient_requestGetItemEnchantStaticStatusWrapperByIndex(item_idx)
	UiBase 						= self.itemGroupUiPool[ui_Idx].SlotItem.icon
	Panel_Tooltip_Item_Show( itemStaticStatus, UiBase, true, false, nil )
end
function _specialGoodsSingle_ShowToolTip( enchantKey, ui_Idx )
	local self					= ItemMarket
	local itemStaticStatus		= getItemEnchantStaticStatus( ItemEnchantKey(enchantKey) )
	local UiBase				= nil
	if nil ~= itemStaticStatus then
		if nil == ui_Idx then
			UiBase 				= self.selectSingleSlot.icon
		else
			UiBase				= self.itemGroupUiPool[ui_Idx].SlotItem.icon
		end
		Panel_Tooltip_Item_Show( itemStaticStatus, UiBase, true, false, nil )
	end
end
function _itemMarket_HideToolTip()
	Panel_Tooltip_Item_hideTooltip()
end
function _itemMarket_ShowIconToolTip( isShow, listType, iconType, uiIdx )
	local self		= ItemMarket
	local UiBase	= nil

	if 0 == listType then
		UiBase = self.itemGroupUiPool[uiIdx]
	else
		UiBase = self
	end

	if iconType == 0 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_AVG_NAME") -- "현재 시세"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_AVG_DESC") -- "해당 아이템의 현재 시세를 기준으로 등록 최저가와 최고가가 결정됩니다."
		uiControl = UiBase.averagePrice_Title
	elseif 1 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_RECENT_NAME") -- "최근 거래가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_RECENT_DESC") -- "해당 아이템의 최근 거래가격입니다."
		uiControl = UiBase.recentPrice_Title
	elseif 2 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_REGISTHIGHPRICE_NAME") -- "등록 최고가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_REGISTHIGHPRICE_DESC") -- "해당 아이템이 거래된 최고가입니다."
		uiControl = UiBase.registHighPrice_Title
	elseif 3 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_REGISTLOWPRICE_NAME") -- "등록 최저가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_REGISTLOWPRICE_DESC") -- "해당 아이템이 거래된 최저가입니다."
		uiControl = UiBase.registLowPrice_Title
	elseif 4 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_REGISTLISTCOUNT_NAME") -- "누적 거래량"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_REGISTLISTCOUNT_DESC") -- "해당 아이템의 누적된 거래량입니다."
		uiControl = UiBase.registListCount_Title
	elseif 5 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_REGISTITEMCOUNT_NAME") -- "등록 개수"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_REGISTITEMCOUNT_DESC") -- "해당 아이템이 현재 등록되어있는 수량입니다."
		uiControl = UiBase.registItemCount_Title
	elseif 10 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_ITEMNAME_NAME") -- "이름 정렬"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_ITEMNAME_DESC") -- "가나다 아이템 이름 순서대로 정렬할 수 있습니다."
		uiControl = self.btn_Sort_ItemName
	elseif 11 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_RECENTPRICE_NAME") -- "최근거래가 정렬"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_RECENTPRICE_DESC") -- "최근 거래가 순서대로 정렬됩니다."
		uiControl = self.btn_Sort_RecentPrice
	elseif 12 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_REGISTITEMCOUNT_NAME") -- "아이템 개수 정렬"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_REGISTITEMCOUNT_DESC") -- "등록한 아이템 개수 순서로 정렬할 수 있습니다."
		uiControl = self.btn_Sort_RegistItemCount
	elseif 13 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_AVGTRADEITEM_NAME") -- "평균거래가격 정렬"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_AVGTRADEITEM_DESC") -- "평균 거래가격 순서로 정렬할 수 있습니다."
		uiControl = self.btn_Sort_AverageTradePrice
	elseif 14 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_RECENTREGISTDATE_NAME") -- "최근등록일 정렬"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_SORT_RECENTREGISTDATE_DESC") -- "최근 등록일 순서대로 정렬할 수 있습니다."
		uiControl = self.btn_Sort_RecentRegistDate
	elseif 15 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_BACKPAGE_NAME") -- "이전 페이지"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_BACKPAGE_DESC") -- "뒤로 가기 (BackSpace)"
		uiControl = self.btn_BackPage
	end

	if isShow == true then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function _itemMarket_MoneyToolTip( isShow, tipType )
	local self = ItemMarket
	if true == isShow then
		if 0 == tipType then
			self.invenDesc:SetShow( true )
		elseif 1 == tipType then
			self.warehouseDesc:SetShow( true )
		end
	else
		self.invenDesc:SetShow( false )
		self.warehouseDesc:SetShow( false )
	end
end

function _itemMarket_Search( bScrollReset )

	local self = ItemMarket
	local text = self.edit_ItemName:GetEditText()
	if( nil == text or "" == text or PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME") == text ) then
		return ;
	end
	self.txt_ItemNameBackPage = text	-- backpage 를 위한 검색어 저장
	searchFilteredVector( self.curItemClassify , text );

	self:SetScroll()
	
	self.isSearch = true
	
	if nil == bScrollReset or bScrollReset then
		self.nowStartIdx = 0	
		self.scroll:SetControlTop()
	end
	
	self:Update( self.nowStartIdx )
end

function HandleClicked_ItemMarket_SetAlarm( itemEnchantKeyRaw )	
	-- 이미 등록된 아이템키인지 먼저 검색
	local totalItemCount			= toClient_GetItemMarketFavoriteItemListSize()
	if nil ~= itemEnchantKeyRaw then
		-- 메시지 처리에서 해야하지만 래퍼이기 때문에, 체크를 위해 위에서도 한 번 한다.
		local clickItem_SSW	= getItemEnchantStaticStatus( ItemEnchantKey(itemEnchantKeyRaw) )
		if clickItem_SSW == nil then
			return
		end
		local clickItem_enchantLevel = clickItem_SSW:get()._key:getEnchantLevel()

		for index = 0, totalItemCount - 1 do
			local enchantItemKey	= toClient_GetItemMarketFavoriteItem( index )
			local itemSSW			= getItemEnchantStaticStatus( enchantItemKey )
			local itemkey			= itemSSW:get()._key:getItemKey()
			local enchantLevel		= itemSSW:get()._key:getEnchantLevel()

			if itemEnchantKeyRaw == enchantItemKey:get() and enchantLevel == clickItem_enchantLevel then
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ALREADYREGIST") ) -- 이미 등록된 아이템입니다.
				return
			end
		end
	
		toClient_AddItemMarketFavoriteItem( itemEnchantKeyRaw )

		-- { 메시지 처리
			local clickItem_SSW	= getItemEnchantStaticStatus( ItemEnchantKey(itemEnchantKeyRaw) )
			if clickItem_SSW == nil then
				return
			end
			local itemName			= clickItem_SSW:getName()
			local enchantLevel		= clickItem_SSW:get()._key:getEnchantLevel()
			local isCash			= clickItem_SSW:get():isCash()
			local strParam1			= ""

			if 0 < enchantLevel and 4 ~= clickItem_SSW:getItemClassify() then
				strParam1 = "+" .. enchantLevel .. " " .. itemName
			end
			if 16 <= enchantLevel then	-- 15강 이상일 때.
				local enchantString = ""
				if 16 == enchantLevel then
					enchantString = "I"
				elseif 17 == enchantLevel then
					enchantString = "II"
				elseif 18 == enchantLevel then
					enchantString = "III"
				elseif 19 == enchantLevel then
					enchantString = "IV"
				elseif 20 == enchantLevel then
					enchantString = "V"
				-- elseif 20 == param1 then
				-- 	enchantString = "VI"
				end
				strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString( enchantLevel ) .. " " .. itemName
			elseif 0 < enchantLevel and enchantLevel < 16 and 4 ~= clickItem_SSW:getItemClassify() then -- 15강 미만일 때
				if true == isCash then
					strParam1 = itemName
				else
					strParam1 = "+" .. enchantLevel .. " " .. itemName
				end
			elseif 4 == clickItem_SSW:getItemClassify() then
				local enchantString = ""
				if 1 == enchantLevel then
					enchantString = "I"
				elseif 2 == enchantLevel then
					enchantString = "II"
				elseif 3 == enchantLevel then
					enchantString = "III"
				elseif 4 == enchantLevel then
					enchantString = "IV"
				elseif 5 == enchantLevel then
					enchantString = "V"
				end

				if 0 == enchantLevel then
					strParam1 = itemName
				else
					strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString( enchantLevel+15 ) .. " " .. itemName
				end
			else	-- 강화가 없을 때.
				strParam1 = itemName
			end

			Proc_ShowMessage_Ack( strParam1 .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ALARMREGISTCOMPLETE") )
		-- }
	end
end

function HandleClicked_ItemMarket_GroupItem( itemIdx, itemEnchantKeyRaw )
	local self = ItemMarket

	-- 해당 아이템의 sellInfo 요청
	if( ToClient_WorldMapIsShow() or ToClient_CheckExistSummonMaid() or ItemMarket.escMenuSaveValue ) then
		requestItemMarketSellInfo( self.curTerritoryKeyRaw  , itemEnchantKeyRaw, true );
	else
		requestItemMarketSellInfo( self.curTerritoryKeyRaw  , itemEnchantKeyRaw, false );
	end
			
	self.isGrouplist = false
	self.nowStartIdx = 0
	self.sellInfoItemEnchantKeyRaw 	= itemEnchantKeyRaw
	self.curSummaryItemIndex		= itemIdx
	
	-- _PA_LOG("유흥신", "HandleClicked_ItemMarket_GroupItem " ..itemEnchantKeyRaw )
	
	self:SetScroll()
	self.scroll:SetControlTop()
	self:Update( self.nowStartIdx )
	self.btn_BackPage:SetShow( true )
	self.btn_BackPage:addInputEvent("Mouse_LUp",	"FGlobal_HandleClicked_ItemMarketBackPage()")
	
	self.btn_SetAlarm:SetShow( true )
	self.btn_Refresh:SetShow( true )

	if isGameTypeRussia() then
		self.btn_SetAlarm:SetSize( 235, 32 )
		self.btn_SetAlarm:SetPosX( 640 )
		self.btn_Refresh:SetSize( 135, 32 )
		self.btn_Refresh:SetPosX( 500 )
	else
		self.btn_SetAlarm:SetSize( 135, 32 )
		self.btn_SetAlarm:SetPosX( 730 )
		self.btn_Refresh:SetSize( 135, 32 )
		self.btn_Refresh:SetPosX( 595 )
	end
	self.btn_SetAlarm:addInputEvent("Mouse_LUp", 		"HandleClicked_ItemMarket_SetAlarm( " .. itemEnchantKeyRaw .. " )" )

	if Panel_Tooltip_Item:GetShow() or Panel_Tooltip_Item_equipped:GetShow() then
		Panel_Tooltip_Item_hideTooltip()
	end
end

function HandleClicked_SpecialGoods_GroupItem( itemIdx, itemEnchantKeyRaw )
	local self = ItemMarket

	-- 해당 아이템의 sellInfo 요청
	local isIgnoreNpc = ToClient_WorldMapIsShow() or ToClient_CheckExistSummonMaid() or ItemMarket.escMenuSaveValue
	ToClient_requestListSellInfo( isIgnoreNpc )
			
	self.isGrouplist = false
	self.nowStartIdx = 0
	self.specialItemEnchantKeyRaw 	= itemEnchantKeyRaw
	self.curSpecialItemIndex		= itemIdx
	
	self:SetScroll()
	self.scroll:SetControlTop()
	self:SpecialGoodsUpdate( self.nowStartIdx )
	self.btn_BackPage:SetShow( true )
	self.btn_BackPage:addInputEvent("Mouse_LUp",	"HandleClicked_ItemMarket_SelectCategory( 99, 1 , 99 )")
	-- self.btn_SetAlarm:SetShow( true )

	if isGameTypeRussia() then
		self.btn_SetAlarm:SetSize( 235, 32 )
		self.btn_Refresh:SetSize( 135, 32 )
	else
		self.btn_SetAlarm:SetSize( 135, 32 )
		self.btn_Refresh:SetSize( 135, 32 )
	end
	self.btn_SetAlarm:addInputEvent("Mouse_LUp", 		"HandleClicked_ItemMarket_SetAlarm( " .. itemEnchantKeyRaw .. " )" )

	if Panel_Tooltip_Item:GetShow() or Panel_Tooltip_Item_equipped:GetShow() then
		Panel_Tooltip_Item_hideTooltip()
	end
end

function HandleClicked_ItemMarket_SingleItem( slotidx , itemEnchantKeyRaw )
	local self = ItemMarket
	local itemCount	= self._registerCount
	self.buyItemKeyraw	= itemEnchantKeyRaw
	self.buyItemSlotidx	= slotidx

	local sellInfo			= getItemMarketSellInfoInClientByIndex( self.curTerritoryKeyRaw , self.sellInfoItemEnchantKeyRaw, slotidx )

	local masterInfo	= getItemMarketMasterByItemEnchantKey( itemEnchantKeyRaw )
	local itemName		= ""
	local itemBuyCount	= sellInfo:getCount()
	local sumSinglePrice = sellInfo:getTotalPrice() / sellInfo:getCount()
	if(nil ~= masterInfo) then
		itemName = masterInfo:getItemEnchantStaticStatusWrapper():getName()
	end
	-- UI.debugMessage( Int64toInt32(itemBuyCount) )
	if Int64toInt32(itemBuyCount) == 1 then
		if true == isItemMarketSecureCode() then
			FGlobal_ItemMarket_BuyConfirm_Open( itemName, itemBuyCount, true, sumSinglePrice )
		else
			local messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_MESSAGEBOX_ALERT")
			local messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_MESSAGEBOX_BUYCONFIRM", "itemName", itemName ) -- itemName.. " 아이템을 구입하시겠습니까?"
			local messageBoxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = ItemMarket_SingleItemBuy, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData)
			-- FGlobal_HandleClicked_ItemMarket_SingleItem_Do( Int64toInt32(itemBuyCount) )
		end
	else
		
		FGlobal_ItemMarket_BuyConfirm_Open( itemName, itemBuyCount, false, sumSinglePrice)
	end
end

function ItemMarket_SingleItemBuy()
	FGlobal_HandleClicked_ItemMarket_SingleItem_Do( 1 )
end

local isOpenByMaid = false
function ItemMarket_UpdateMoneyByWarehouse()
	local	self	= ItemMarket
	
	self.invenMoney:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
	self.warehouseMoney:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_WAREHOUSE_HAVE_MONEY") ) -- "창고에 보유하고 있는 금액" )
	self.warehouseMoney:SetText( makeDotMoney(warehouse_moneyFromNpcShop_s64()) )
	
	if isOpenByMaid then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()
		self.warehouseMoney:SetText( makeDotMoney(warehouse_moneyFromRegionKey_s64( myAffiliatedTownRegionKey )) )
	end
end

function FGlobal_HandleClicked_ItemMarket_SingleItem_Do( itemCount )
	local	self			= ItemMarket
	local	fromWhereType	= CppEnums.ItemWhereType.eInventory
	if( self.warehouseMoneyTit:IsCheck() )	then
		fromWhereType	= CppEnums.ItemWhereType.eWarehouse
	end
	
	if ToClient_CheckExistSummonMaid() then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		
		if checkMaid_SubmitMarket(true) then
			requestBuyItemForItemMarketByMaid( fromWhereType, self.buyItemKeyraw, self.buyItemSlotidx, itemCount )
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME")) -- "재사용 대기중입니다." )
			return
		end
	else
		requestBuyItemForItemMarket( fromWhereType, self.buyItemKeyraw, self.buyItemSlotidx, itemCount )
	end
	if Panel_Window_ItemMarket_BuyConfirm:IsShow() then
		-- Proc_ShowMessage_Ack("아이템이 구입되었습니다.")
		FGlobal_ItemMarket_BuyConfirm_Close()
	end
end

local _specialGoodsIndex = nil
local _specialGoodsEnchantKeyRaw = nil
function HandleClicked_ItemMarket_SpecialItem( index, enchantKeyRaw )
	local self = ItemMarket
	local	fromWhereType	= CppEnums.ItemWhereType.eInventory
	if( self.warehouseMoneyTit:IsCheck() )	then
		fromWhereType	= CppEnums.ItemWhereType.eWarehouse
	end
	
	if ToClient_CheckExistSummonMaid() then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		
		if checkMaid_SubmitMarket(true) then
			ToClient_requestBuyItemAtItemMarketByPartyByMaid(fromWhereType, enchantKeyRaw, index)
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME")) -- "재사용 대기중입니다." )
			return
		end
	else
		ToClient_requestBuyItemAtItemMarketByParty(fromWhereType, enchantKeyRaw, index)
	end
	
	_specialGoodsIndex = self.curSpecialItemIndex
	_specialGoodsEnchantKeyRaw = enchantKeyRaw
	-- HandleClicked_SpecialGoods_GroupItem( self.curSpecialItemIndex, enchantKeyRaw )
end

function FromClient_notifyItemMarketMessage( msgType, strParam1, param1, param2, param3, param4 )
	--[[
		msgType 0 : 아이템 구입 / param 없음
		msgType 1 : 아이템 최저가 등록 시, 유저들에게 알림 / strParam1 : 없음 , param1 : TItemEnchantKey, param2 : TerritoryKey, param3 : 가격, param4 : 유료템 여부
		msgType 2 : 내 물품 판매 / strParam1 : 아이템 이름, param1 : 판매된 수량, param2 : 아이템의 스택 가능 여부
		msgType 3 : 아이템 등록 성공 / param 없음
		msgType 4 : 입찰 실패.
	]]--
	local self = ItemMarket
	if 0 == msgType then
		if 0 == param1 then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCOMPLETEITEM") ) -- "아이템이 구입되었습니다.")
		elseif 1 == param1 then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYBIDDINGITEM") ) -- "아이템 구입에 성공하였습니다." )
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCOMPLETEITEM") ) -- "아이템이 구입되었습니다.")
		end
	elseif 1 == msgType then
		local territoryNameArray = {
			[0]	= tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),		-- 발레노스령
			[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),		-- 세렌디아령
			[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),		-- 칼페온령
			[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3")),		-- 메디아령
			--[4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_")),		-- 발렌시아령(미정)
		}
		
		if param2 < 0 or 4 <= param2 then
			return
		end
		
		local territoryName = territoryNameArray[param2]
		
		local issw =  getItemEnchantStaticStatus( ItemEnchantKey(param1) )
		
		if issw == nil then
			return
		end
		
		local itemName = issw:getName()
		local enchantLevel = issw:get()._key:getEnchantLevel()
		local isCash = issw:get():isCash()

		if 0 < enchantLevel and 4 ~= issw:getItemClassify() then
			strParam1 = "+" .. enchantLevel .. " " .. itemName
		end
		if 16 <= enchantLevel then	-- 15강 이상일 때.
			local enchantString = ""
			if 16 == enchantLevel then
				enchantString = "I"
			elseif 17 == enchantLevel then
				enchantString = "II"
			elseif 18 == enchantLevel then
				enchantString = "III"
			elseif 19 == enchantLevel then
				enchantString = "IV"
			elseif 20 == enchantLevel then
				enchantString = "V"
			-- elseif 20 == param1 then
			-- 	enchantString = "VI"
			end
			strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString( enchantLevel ) .. " " .. itemName
		elseif 0 < enchantLevel and enchantLevel < 16 and 4 ~= issw:getItemClassify() then -- 15강 미만일 때
			if true == isCash then
				strParam1 = itemName
			else
				strParam1 = "+" .. enchantLevel .. " " .. itemName
			end
		elseif 4 == issw:getItemClassify() then
			local enchantString = ""
			if 1 == enchantLevel then
				enchantString = "I"
			elseif 2 == enchantLevel then
				enchantString = "II"
			elseif 3 == enchantLevel then
				enchantString = "III"
			elseif 4 == enchantLevel then
				enchantString = "IV"
			elseif 5 == enchantLevel then
				enchantString = "V"
			end

			if 0 == enchantLevel then
				strParam1 = itemName
			else
				strParam1 = enchantString .. " " .. HighEnchantLevel_ReplaceString( enchantLevel+15 ) .. " " .. itemName
			end
		else	-- 강화가 없을 때.
			strParam1 = itemName
		end

		local subStr = nil
		if param4 then
			subStr = "LUA_ITEMMARKET_REGIST_ITEMMARKET"
		else
			subStr = "LUA_ITEMMARKET_STANDBY_ITEMMARKET"
		end

		local message = {main = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_ITEMMARKET_NOTIFYITEMMARKETMSG_MAIN", "strParam1", strParam1, "param3", makeDotMoney(param3) ), sub = PAGetString(Defines.StringSheet_GAME, subStr) }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 5, 19 )

	elseif 2 == msgType then
		local message = ""
		if param2 == 1 then
			message = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLITEM", "strParam1", strParam1, "param1", param1 ) -- "[ " .. strParam1 .. " ] 아이템이 [ " .. param1 .. "개 ] 판매되었습니다."
		else
			message = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLITEMONE", "strParam1", strParam1 ) -- "[ " .. strParam1 .. " ] 아이템이 판매되었습니다."
		end
		Proc_ShowMessage_Ack( message )
	elseif 3 == msgType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_AFTERREGIST_ACK") )
	elseif 4 == msgType then
		self:Update()
	elseif 5 == msgType then
		-- 관심 아이템인지 검증후 메세지를 처리해준다.
		
		local issw =  getItemEnchantStaticStatus( ItemEnchantKey(param1) )
		
		if issw == nil then
			return
		end

		local itemName = issw:getName()
		local enchantLevel = issw:get()._key:getEnchantLevel()

		FGlobal_ItemMarketAlarm_Open( ItemEnchantKey(param1) )
		_PA_LOG("유흥신", " ItemMarket 관심 아이템 메세지 응답 처리 " .. itemName .. " " .. tostring(enchantLevel) )
		
	end
	
end

function HandleClicked_ItemMarket_UnSetGroupItem()
	local self = ItemMarket
	if not self.static_SlotBg:GetShow() then
		return
	end
	self.btn_BackPage:SetShow( false )
	self.btn_SetAlarm:SetShow( false )
	self.btn_Refresh:SetShow( false )
	self.isGrouplist = true
	self.nowStartIdx = 0

	self:SetScroll()
	self.scroll:SetControlTop()
	self:Update( self.nowStartIdx )

	if Panel_Tooltip_Item:GetShow() or Panel_Tooltip_Item_equipped:GetShow() then
		Panel_Tooltip_Item_hideTooltip()
	end
end

function HandleClicked_ItemMarket_SelectCategory( categoryIdx, isBackPage, realCategory_Idx )
	TooltipSimple_Hide()
	
	local self = ItemMarket
	if true == self.btn_BackPage:GetShow() then
		self.btn_BackPage:SetShow( false )
		self.btn_SetAlarm:SetShow( false )
		self.btn_Refresh:SetShow( false )
	end
	FGlobal_ItemMarket_BuyConfirm_Close()	-- 구입창 꺼주기
	self.selectCategory = categoryIdx
	_itemMarket_ResetTextureBySort( self )
	
	if 99 == categoryIdx then
		ToClient_requestListSellInfo( self.isWorldMapOpen or ToClient_CheckExistSummonMaid() )
	else
		requestItemMarketSummaryInfo(self.curTerritoryKeyRaw, self.isWorldMapOpen, true)
	end
	
	self.curItemClassify = realCategory_Idx;
	self.isGrouplist = true

	self.curClassType		= -1;
	self.curServantType		= -1;
	
	if( -1 < self.curFilterIndex ) then
		local maxClassCount = getCharacterClassCount()
		for filter_Idx = 0, maxClassCount-1 do
			local	classType	= getCharacterClassTypeByIndex( filter_Idx )
			local	className	= getCharacterClassName( classType )
			if ( nil ~= className ) and ( "" ~= className ) and ( " " ~= className ) then
				self.curClassType = classType
			end
		end
	end
	
	if 99 ~= categoryIdx then
		selectCategory( categoryIdx )
	end
	--makeFilteredVector( self.curItemClassify , self.curClassType, self.curServantType )
	-- self:SetPosition()
	self:SetScroll()
	self.scroll:SetControlTop()

	self:ResetFilterBtn()

	self.nowStartIdx = 0
	self.edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
	if (isBackPage == 1) then
		self.txt_ItemNameBackPage = ""
	end
	
	if 99 == categoryIdx then
		ItemMarket:SpecialGoodsUpdate()
	else
		self:Update( self.nowStartIdx )
	end
end
function ShowTooltip_ItemMarket_Category( isShow, index )
	local self = ItemMarket
		name = DummyData.Category[index]
		desc = nil
		uiControl = self.categoryUiPool[index]

	if isShow == true then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function HandleClicked_ItemMarket_SelectFilter( filterIdx )
	local self = ItemMarket
	if self.categoryUiPool[99]:IsCheck() then			-- 특가상품?
		return
	end
	
	self.btn_BackPage:SetShow( false )
	self.btn_SetAlarm:SetShow( false )
	self.btn_Refresh:SetShow( false )

	if( self.curFilterIndex == filterIdx ) then
		ItemMarket.filterUiPool[filterIdx]:SetCheck(false)
		self.curFilterIndex = -1
	else	
		self.curFilterIndex = filterIdx
	end
		
	local classType		= -1;
	local servantType	= -1;
	
	if( -1 < self.curFilterIndex ) then
		local	getClassType	= getCharacterClassTypeByIndex( filterIdx )
		local	className	= getCharacterClassName( getClassType )
		if ( nil ~= className ) and ( "" ~= className ) and ( " " ~= className ) then
			classType = getClassType
		end
	end
	
	self.isGrouplist = true
	selectFilter( classType, servantType )
	
	self.edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
	self.txt_ItemNameBackPage = ""
	
	self:SetScroll()
	self.scroll:SetControlTop()

	self.nowStartIdx = 0
	self:Update( self.nowStartIdx )
end

function HandleClicked_ItemMarket_ItemSort( sortTarget )
	local self = ItemMarket
	self.selectItemSort = sortTarget
-- {텍스쳐 초기화.	-- todo : 구조 변경이 필요함. 150122 창욱
	_itemMarket_ChangeTextureBySort( self.btn_Sort_ItemName,			0, true )
	_itemMarket_ChangeTextureBySort( self.btn_Sort_RecentPrice,			1, true )
	_itemMarket_ChangeTextureBySort( self.btn_Sort_RegistItemCount,		2, true )
	_itemMarket_ChangeTextureBySort( self.btn_Sort_AverageTradePrice,	3, true )
	_itemMarket_ChangeTextureBySort( self.btn_Sort_RecentRegistDate,	4, true )
-- }
	
	local sortValue = false
	local control	= nil
	
	if 0 == sortTarget then
		self.isSort_ItemName			= not self.isSort_ItemName
		self.isSort_RecentPrice			= true
		self.isSort_RegistItemCount		= true
		self.isSort_AverageTradePrice	= true
		self.isSort_RecentRegistDate	= true

		sortValue						= self.isSort_ItemName
		control							= self.btn_Sort_ItemName
	elseif 1 == sortTarget then
		self.isSort_ItemName			= true
		self.isSort_RecentPrice			= not self.isSort_RecentPrice
		self.isSort_RegistItemCount		= true
		self.isSort_AverageTradePrice	= true
		self.isSort_RecentRegistDate	= true

		sortValue						= self.isSort_RecentPrice
		control							= self.btn_Sort_RecentPrice
	elseif 2 == sortTarget then
		self.isSort_ItemName			= true
		self.isSort_RecentPrice			= true
		self.isSort_RegistItemCount		= not self.isSort_RegistItemCount
		self.isSort_AverageTradePrice	= true
		self.isSort_RecentRegistDate	= true

		sortValue						= self.isSort_RegistItemCount
		control							= self.btn_Sort_RegistItemCount
	elseif 3 == sortTarget then
		self.isSort_ItemName			= true
		self.isSort_RecentPrice			= true
		self.isSort_RegistItemCount		= true
		self.isSort_AverageTradePrice	= not self.isSort_AverageTradePrice
		self.isSort_RecentRegistDate	= true

		sortValue						= self.isSort_AverageTradePrice
		control							= self.btn_Sort_AverageTradePrice
	elseif 4 == sortTarget then
		self.isSort_ItemName			= true
		self.isSort_RecentPrice			= true
		self.isSort_RegistItemCount		= true
		self.isSort_AverageTradePrice	= true
		self.isSort_RecentRegistDate	= not self.isSort_RecentRegistDate

		sortValue						= self.isSort_RecentRegistDate
		control							= self.btn_Sort_RecentRegistDate
	end
	
	self.isChangeSort	= true
	self.curSortTarget	= sortTarget
	self.curSortValue	= sortValue

	_itemMarket_doSortList( sortTarget, sortValue )
	_itemMarket_ChangeTextureBySort( control, sortTarget, sortValue )
end

function _itemMarket_ResetTextureBySort( control )	-- 정렬 텍스쳐 및 변수 초기화
	local self = control
	self.curSortValue 				= false
	self.isSort_ItemName			= true
	self.isSort_RecentPrice			= true
	self.isSort_RegistItemCount		= true
	self.isSort_AverageTradePrice	= true
	self.isSort_RecentRegistDate	= true
-- {텍스쳐 초기화.	-- todo : 구조 변경이 필요함. 150122 창욱
	_itemMarket_ChangeTextureBySort( self.btn_Sort_ItemName,			0, true )
	_itemMarket_ChangeTextureBySort( self.btn_Sort_RecentPrice,			1, true )
	_itemMarket_ChangeTextureBySort( self.btn_Sort_RegistItemCount,		2, true )
	_itemMarket_ChangeTextureBySort( self.btn_Sort_AverageTradePrice,	3, true )
	_itemMarket_ChangeTextureBySort( self.btn_Sort_RecentRegistDate,	4, true )
-- }
end

function HandleClicked_ItemMarket_Close()
	FGolbal_ItemMarket_Close()
end
function HandleClicked_ItemMarket_Search()
	_itemMarket_Search()
end
function HandleClicked_ItemMarket_ResetSearch()	-- 검색 초기화.
	toClient_ResetSearch()
	ItemMarket.edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), true)
	ClearFocusEdit()
	ItemMarket.txt_ItemNameBackPage = ""
	ItemMarket:Update( ItemMarket.nowStartIdx )
end
function HandleClicked_ItemMarket_RefreshList()	-- 싱글 리스트 새로고침
	HandleClicked_ItemMarket_GroupItem( ItemMarket.curSummaryItemIndex, ItemMarket.sellInfoItemEnchantKeyRaw )
end
function HandleClicked_ItemMarket_SetScrollIndexByLClick()
	local self				= ItemMarket
	local maxInterval		= self.scrollInverVal
	local posByInterval		= 1 / maxInterval

	local currentInterval	= math.floor( (self.scroll:GetControlPos() / posByInterval) + 0.5 )
	self.nowStartIdx		= currentInterval
	self:Update( self.nowStartIdx )
	self.nowScrollPos		= self.scroll:GetControlPos( 0 )
end
function HandleClicked_ItemMarket_EditText()
	local self				= ItemMarket
	self.edit_ItemName:SetEditText("", true)
	SetFocusEdit( self.edit_ItemName )

	if( ToClient_WorldMapIsShow() ) then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)	-- 방식 확인을 해야 한다.
		SetUIMode( Defines.UIMode.eUIMode_WoldMapSearch )
	elseif ItemMarket.escMenuSaveValue then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		SetUIMode( Defines.UIMode.eUIMode_WoldMapSearch )
	end
end

function FGolbal_ItemMarket_Search()
	_itemMarket_Search()
	ClearFocusEdit()

	if( ToClient_WorldMapIsShow() ) then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		SetUIMode( Defines.UIMode.eUIMode_WorldMap )
	elseif ItemMarket.escMenuSaveValue then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		SetUIMode( Defines.UIMode.eUIMode_Default )
	end
end

function HandleClicked_ItemMarket_RegistItem()
	Warehouse_OpenPanelFromMaid()
	HandleClicked_WhItemMarketRegistItem_Open( true )
	Panel_Window_ItemMarket:SetShow( false, false )
end

-- 거래소 오픈
function FGlobal_ItemMarket_Open()
	local self = ItemMarket
	
	if true == Panel_Window_ItemMarket:GetShow() then
		return
	end
	
	if Panel_Window_ItemMarket_ItemSet:GetShow() then
		FGlobal_ItemMarketItemSet_Close()
	end

	if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
		FGlobal_ItemMarket_BuyConfirm_Close()
	end

	if Panel_ItemMarket_AlarmList:GetShow() then
		FGlobal_ItemMarketAlarmList_Close()
	end
	
	if Panel_Window_ItemMarket_RegistItem:GetShow() then
		FGlobal_ItemMarketRegistItem_Close()
	end
	
	--창고 돈을 보여 줘야 함으로, UI를 열때 정보를 요청한다.
	--{
		warehouse_requestInfoFromNpc()
		self.invenMoney			:SetShow(true)
		self.invenMoneyTit		:SetShow(true)
		self.invenMoneyTit		:SetEnableArea( 0, 0, 200, self.invenMoneyTit:GetSizeY())
		self.warehouseMoney		:SetShow(true)
		self.warehouseMoneyTit	:SetShow(true)
		self.warehouseMoneyTit	:SetEnableArea( 0, 0, 200, self.warehouseMoneyTit:GetSizeY())
		
		self.invenMoneyTit:SetCheck(true)
		self.warehouseMoneyTit:SetCheck(false)
	--}

	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	self.btn_MyList:SetShow( false )
	self.btn_BackPage:SetShow( false )
	self.btn_SetAlarm:SetShow( false )
	self.btn_Refresh:SetShow( false )

	Panel_Window_ItemMarket:SetShow( true, true )
	
	-- 영지 키 입력
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGIONINFO_NIL") ) -- "플레이어의 현재위치가 비정상적입니다")
		return
	end	
	
	self.curTerritoryKeyRaw = regionInfoWrapper:getTerritoryKeyRaw()

	self.panelTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_NAMING") ) -- "아이템 거래소" )
	
	self.curItemClassify = ItemClassify.eItemClassify_Etc
	self.curClassType	= -1
	self.curServantType	= -1
	self.curFilterIndex	= -1
	self.isGrouplist = true
	self.nowStartIdx = 0
	self.isWorldMapOpen	= false
	self.isChangeSort	= false
	self.curSortTarget	= -1
	self.curSortValue	= false
	self.isSearch		= false
	
	requestOpenItemMarket()
	requestItemMarketSummaryInfo(self.curTerritoryKeyRaw, false, false); -- 종합 정보를 같이 요ㄱ청
	
	self.edit_ItemName:SetEditText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false )
	self.txt_ItemNameBackPage = ""
	ClearFocusEdit()

	self:ResetFilterBtn()
	self:SetPosition()
	self:SetScroll()
	self.scroll:SetControlTop()
	self:Update( self.nowStartIdx )
	
	_itemMarket_ResetTextureBySort(self)
	self.btn_RegistItem:SetShow( false )
end

-- 거래소 오픈
function FGlobal_ItemMarket_Open_ForWorldMap( territoryKeyRaw, escMenu )
	local self = ItemMarket
	ItemMarket.escMenuSaveValue = escMenu
	-- if true == Panel_Window_ItemMarket:GetShow() then		-- WorldMapPopupManager에서 열리는 처리를 한다.
	-- 	return
	-- end

	if true == Panel_Window_ItemMarket_ItemSet:GetShow() then
		FGlobal_ItemMarketItemSet_Close()
	end

	if Panel_Window_ItemMarket_RegistItem:GetShow() then
		FGlobal_ItemMarketRegistItem_Close()
	end
	
	if( ToClient_WorldMapIsShow() ) then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_Window_ItemMarket, true )
	end

	--월드맵을 통한 거래소는 구매가 현재 지원되지 않음으로 UI를 안보여준다.
	--{
		self.invenMoney			:SetShow(false)
		self.invenMoneyTit		:SetShow(false)
		self.warehouseMoney		:SetShow(false)
		self.warehouseMoneyTit	:SetShow(false)
	--}
	
	-- 영지 키 입력
	self.curTerritoryKeyRaw = territoryKeyRaw
	self.isWorldMapOpen = true
	
	local rv = requestItemMarketSummaryInfo(self.curTerritoryKeyRaw, true, false); -- 종합 정보를 같이 요ㄱ청
	if( 0 ~= rv ) then
		return
	end
	
	self.curItemClassify = ItemClassify.eItemClassify_Etc
	self.curClassType	= -1
	self.curServantType	= -1
	self.curFilterIndex	= -1
	self.isGrouplist = true
	self.nowStartIdx = 0
	self.isChangeSort	= false
	self.curSortTarget	= -1
	self.curSortValue	= false
	self.isSearch		= false
	
	-- 출력해줄 리스트 만들기
	requestOpenItemMarket()
	
	ClearFocusEdit()
	
	-- 월드맵 모드이면 내 목록을 보이게 한다.
	self.txt_ItemNameBackPage = ""
	self.btn_MyList			:SetShow( true )
	self.edit_ItemName		:SetEditText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false )
	self.panelTitle			:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_NAMING") ) -- "아이템 거래소" )
	Panel_Window_ItemMarket	:SetShow( true, true )
	
	self:ResetFilterBtn()
	self:SetPosition()
	self:SetScroll()
	self.scroll:SetControlTop()
	self.btn_BackPage:SetShow( false )
	self.btn_SetAlarm:SetShow( false )
	self.btn_Refresh:SetShow( false )
	self:Update( self.nowStartIdx )
	self.btn_RegistItem:SetShow( false )
end

-- 메이드 통해 거래소 오픈
function FGlobal_ItemMarket_OpenByMaid()
	local self = ItemMarket
	
	if true == Panel_Window_ItemMarket:GetShow() then
		return
	end
	
	if true == Panel_Window_ItemMarket_ItemSet:GetShow() then
		FGlobal_ItemMarketItemSet_Close()
	end
	
	if Panel_Window_ItemMarket_RegistItem:GetShow() then
		FGlobal_ItemMarketRegistItem_Close()
	end
	
	--창고 돈을 보여 줘야 함으로, UI를 열때 정보를 요청한다.
	--{
	SetUIMode(Defines.UIMode.eUIMode_ItemMarket)
	isOpenByMaid = true
	
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	if nil == regionInfo then
		return
	end
	local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()
	local regionInfoWrapper = getRegionInfoWrapper( myAffiliatedTownRegionKey )						-- 내가 있는 곳의 소속 영지 래퍼
	local wayPointKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()				-- 소속 영지의 웨이포인트키	
	
		warehouse_requestInfo( wayPointKey )
		self.invenMoney			:SetShow(true)
		self.invenMoneyTit		:SetShow(true)
		self.invenMoneyTit		:SetEnableArea( 0, 0, 200, self.invenMoneyTit:GetSizeY())
		self.warehouseMoney		:SetShow(true)
		self.warehouseMoneyTit	:SetShow(true)
		self.warehouseMoneyTit	:SetEnableArea( 0, 0, 200, self.warehouseMoneyTit:GetSizeY())
		
		self.invenMoneyTit:SetCheck(true)
		self.warehouseMoneyTit:SetCheck(false)
	--}

	-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	self.btn_MyList:SetShow( false )
	self.btn_BackPage:SetShow( false )
	self.btn_SetAlarm:SetShow( false )
	self.btn_Refresh:SetShow( false )

	Panel_Window_ItemMarket:SetShow( true, true )
	
	-- 영지 키 입력
	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGIONINFO_NIL") ) -- "플레이어의 현재위치가 비정상적입니다")
		return
	end	
	
	self.curTerritoryKeyRaw = regionInfoWrapper:getTerritoryKeyRaw()

	self.panelTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_NAMING") ) -- "아이템 거래소" )
	
	self.curItemClassify = ItemClassify.eItemClassify_Etc
	self.curClassType	= -1
	self.curServantType	= -1
	self.curFilterIndex	= -1
	self.isGrouplist = true
	self.nowStartIdx = 0
	self.isWorldMapOpen	= false
	self.isChangeSort	= false
	self.curSortTarget	= -1
	self.curSortValue	= false
	self.isSearch		= false
	
	requestOpenItemMarket()
	requestItemMarketSummaryInfo(self.curTerritoryKeyRaw, false, false); -- 종합 정보를 같이 요ㄱ청

	self.edit_ItemName:SetEditText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false )
	self.txt_ItemNameBackPage = ""
	ClearFocusEdit()

	self:ResetFilterBtn()
	self:SetPosition()
	self:SetScroll()
	self.scroll:SetControlTop()
	self:Update( self.nowStartIdx )
	
	_itemMarket_ResetTextureBySort(self)
	self.btn_RegistItem:SetShow( true )
end

-- 패널 꺼주기
function FGolbal_ItemMarket_Close()
	if false == Panel_Window_ItemMarket:GetShow() then
		return
	end

	_itemMarket_ShowIconToolTip( false )
	ClearFocusEdit()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	_itemMarket_HideToolTip()
	Panel_Window_ItemMarket:SetShow( false, false )
	
	-- 메이드를 통해 거래소 열었는지 체크
	if not Panel_Window_ItemMarket_Function:GetShow() and true == isOpenByMaid then
		SetUIMode(Defines.UIMode.eUIMode_Default)
		ToClient_CallHandlerMaid("_maidLogOut")
		isOpenByMaid = false
		ItemMarket.btn_RegistItem:SetShow( false )
		FGlobal_ReturnIsByMaid()
	end

	if not Panel_Window_ItemMarket_Function:GetShow() and true == ItemMarket.escMenuSaveValue then
		SetUIMode(Defines.UIMode.eUIMode_Default)
		ItemMarket.escMenuSaveValue = false
	end

	if ( ToClient_WorldMapIsShow() ) then
		WorldMapPopupManager:pop()
	end
end


-------------------------------------------------------
-- 서버에서의 응답
----------------------------------------------------------
function 	Update_ItemMarketMasterInfo()
	local self = ItemMarket
	if self.categoryUiPool[99]:IsCheck() then			-- 특가상품?
		self:SpecialGoodsUpdate( self.nowStartIdx )
		return
	end
	ItemMarket:Update(self.nowStartIdx);
end

function	Update_ItemMarketSummaryInfo()
	local self = ItemMarket
	
	if self.categoryUiPool[99]:IsCheck() then			-- 특가상품?
		self:SpecialGoodsUpdate( self.nowStartIdx )
		return
	end
	
	local text =  self.txt_ItemNameBackPage
	if( nil ~= text or "" ~= text or PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME") ~= text ) then			-- 검색어가 있다면 검색 리스트 적용
		searchFilteredVector( self.curItemClassify , text );
		self:SetScroll()
	end
	
	ItemMarket:Update(self.nowStartIdx);
end

function	Update_ItemMarketSellInfo()
	-- 컨트롤들의 정보만 업데이트 
	local self = ItemMarket
	
	self.nowStartIdx = 0
	self:SetScroll()
	self.scroll:SetControlTop()
	
	if self.categoryUiPool[99]:IsCheck() then			-- 특가상품?
		self:SpecialGoodsUpdate( self.nowStartIdx )
		return
	end
	self:Update( self.nowStartIdx )
end

-------------------------------------------------------------
-- FromClient_NotifyItemMarketByParty(notifyType, param0, param1)
-- - notifyType 0 : 아이템 리스트 갱신 / param0, param1 : 의미 없음
-- - notifyType 1 : 아이템 구매 성공 / param0 : summary 페이지로 돌아가는지 여부(false면 summary 출력), param1 : 의미없음
-- - notifyType 2 : 아이템 구매 실패 / param0 : summary 페이지로 돌아가는지 여부(false면 summary 출력), param1 : 의미없음
-- - notifyType 3 : 내 파티의 아이템 리스트 갱신 / param0, param1 : 의미 없음
-- - notifyType 4 : 내 파티의 아이템 등록 / param0 : itemEnchantKeyRaw, param1 : 등록된 수량
-- - notifyType 5 : 내 파티의 아이템 주사위 굴림 / param0, param1 : 의미 없음
-- - notifyType 6 : 내 파티의 아이템 주사위 완료 / param0, param1 : 의미 없음
--------------------------------------------------------------
function FromClient_NotifyItemMarketByParty( notifyType, param0, param1 )
	if 0 == notifyType then
		if Panel_Window_ItemMarket:GetShow() then
			ItemMarket:SpecialGoodsUpdate()
		end
	elseif 1 == notifyType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYBIDDINGITEM") )
		if Panel_Window_ItemMarket:GetShow() then
			if param0 then
				HandleClicked_SpecialGoods_GroupItem( _specialGoodsIndex, _specialGoodsEnchantKeyRaw )
			else
				ItemMarket.isGrouplist = true
				ItemMarket:SpecialGoodsUpdate()
			end
		end
	elseif 2 == notifyType then
		if Panel_Window_ItemMarket:GetShow() then
			if param0 then
				HandleClicked_SpecialGoods_GroupItem( _specialGoodsIndex, _specialGoodsEnchantKeyRaw )
			else
				ItemMarket.isGrouplist = true
				ItemMarket:SpecialGoodsUpdate()
			end
		end
	elseif 3 == notifyType then
		-- FGlobal_PartyItemList_Update()
	elseif 4 == notifyType then
		-- FGlobal_PartyItemList_Update()
		
		local itemEnchantKeyRaw = param0
		local count = param1
		local itemSSW = getItemEnchantStaticStatus( ItemEnchantKey(itemEnchantKeyRaw) )
		
		if nil ~= itemSSW then
			Proc_ShowMessage_Ack( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_ITEMMARKET_SPECIALITEM_REGIST_MSG", "getName", tostring(itemSSW:getName()), "count", tostring(count) ) ) -- "거래소 특가상품 등록 : " .. tostring(itemSSW:getName()) .. " " .. tostring(count) .."개" )
		end
	elseif 5 == notifyType then
	elseif 6 == notifyType then
	

	end
	FGlobal_PartyItemList_Update()	
end

function ItemMarket_SimpleToolTips( isShow, sortType )
	local name, desc, uiControl = nil, nil, nil

	registTooltipControl(uiControl, Panel_Tooltip_SimpleText)

	if isShow == true then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function FGlobal_HandleClicked_ItemMarketBackPage()								-- 이전 페이지로 돌리기
	local self = ItemMarket

	TooltipSimple_Hide()												-- '뒤로' 툴팁 끄기
	
	self.btn_BackPage:SetShow( false )
	self.btn_SetAlarm:SetShow( false )
	self.btn_Refresh:SetShow( false )
	self.isGrouplist = true
	
	local text =  self.txt_ItemNameBackPage
	if( nil ~= text or "" ~= text or PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME") ~= text ) then			-- 검색어가 있다면 검색 리스트 적용
		ClearFocusEdit()
		SetFocusEdit(self.edit_ItemName)
		searchFilteredVector( self.curItemClassify , text );
		self:SetScroll()
	end
	
	self:Update( self.nowStartIdx )
	self.scroll:SetControlPos( self.nowScrollPos )						-- 스크롤 되돌리기
	HandleClicked_ItemMarket_SetScrollIndexByLClick()					-- 스크롤 포지션 다시 잡기
end

function FGlobal_isOpenItemMarketBackPage()
	local self = ItemMarket
	return self.btn_BackPage:GetShow()
end

-------------------------------------------------------------
function ItemMarket:registEventHandler()
	self.static_ItemListBG			:addInputEvent("Mouse_DownScroll",	"ItemMarket_ScrollUpdate( true )")
	self.static_ItemListBG			:addInputEvent("Mouse_UpScroll",	"ItemMarket_ScrollUpdate( false )")
	self.selectSingleSlot.icon		:addInputEvent("Mouse_RUp",			"HandleClicked_ItemMarket_UnSetGroupItem()")
	self.static_ListHeadBG			:addInputEvent("Mouse_RUp",			"HandleClicked_ItemMarket_UnSetGroupItem()")

	self.edit_ItemName				:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_EditText()")
	self.edit_ItemName				:RegistReturnKeyEvent( "FGolbal_ItemMarket_Search()" )

	self.btn_Sort_ItemName			:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_ItemSort( " .. 0 .. " )")
	self.btn_Sort_RecentPrice		:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_ItemSort( " .. 1 .. " )")
	self.btn_Sort_RegistItemCount	:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_ItemSort( " .. 2 .. " )")
	self.btn_Sort_AverageTradePrice	:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_ItemSort( " .. 3 .. " )")
	self.btn_Sort_RecentRegistDate	:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_ItemSort( " .. 4 .. " )")
	
	self.btn_Close					:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_Close()")
	self.btn_Search					:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_Search()")
	self.btn_ResetSearch			:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_ResetSearch()")
	self.btn_Refresh				:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_RefreshList()")

	self.averagePrice_Title			:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 0 .. ")")
	self.averagePrice_Title			:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.recentPrice_Title			:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 1 .. ")")
	self.recentPrice_Title			:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.registHighPrice_Title		:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 2 .. ")")
	self.registHighPrice_Title		:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.registLowPrice_Title		:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 3 .. ")")
	self.registLowPrice_Title		:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.registListCount_Title		:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 4 .. ")")
	self.registListCount_Title		:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.registItemCount_Title		:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 5 .. ")")
	self.registItemCount_Title		:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")

	self.averagePrice_Title			:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 0 .. ")")
	self.recentPrice_Title			:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 1 .. ")")
	self.registHighPrice_Title		:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 2 .. ")")
	self.registLowPrice_Title		:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 3 .. ")")
	self.registListCount_Title		:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 4 .. ")")
	self.registItemCount_Title		:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 5 .. ")")

	self.scrollCtrlBTN				:addInputEvent("Mouse_LPress",		"HandleClicked_ItemMarket_SetScrollIndexByLClick()")
	self.scroll						:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_SetScrollIndexByLClick()")
	self.scroll						:addInputEvent("Mouse_DownScroll",	"HandleClicked_ItemMarket_SetScrollIndexByLClick()")
	self.scroll						:addInputEvent("Mouse_UpScroll",	"HandleClicked_ItemMarket_SetScrollIndexByLClick()")
	self.btn_MyList					:addInputEvent("Mouse_LUp", 		"FGlobal_ItemMarketItemSet_Open_ForWorldMap( true )" )
	self.btn_BackPage				:addInputEvent("Mouse_LUp", 		"FGlobal_HandleClicked_ItemMarketBackPage()" )
	self.btn_RegistItem				:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarket_RegistItem()" )
	
	self._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ItemMarket\" )" )					-- 물음표 좌클릭
	self._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"ItemMarket\", \"true\")" )				-- 물음표 마우스오버
	self._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"ItemMarket\", \"false\")" )			-- 물음표 마우스오버

	self.btn_Sort_ItemName			:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 10 .. " )")
	self.btn_Sort_ItemName			:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.btn_Sort_RecentPrice		:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 11 .. " )")
	self.btn_Sort_RecentPrice		:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.btn_Sort_RegistItemCount	:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 12 .. " )")
	self.btn_Sort_RegistItemCount	:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.btn_Sort_AverageTradePrice	:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 13 .. " )")
	self.btn_Sort_AverageTradePrice	:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.btn_Sort_RecentRegistDate	:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 14 .. " )")
	self.btn_Sort_RecentRegistDate	:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.btn_BackPage				:addInputEvent("Mouse_On",	"_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 15 .. " )")
	self.btn_BackPage				:addInputEvent("Mouse_Out",	"_itemMarket_ShowIconToolTip( false )")
	self.invenMoneyTit				:addInputEvent("Mouse_On",	"_itemMarket_MoneyToolTip( true, 0 )")
	self.invenMoneyTit				:addInputEvent("Mouse_Out",	"_itemMarket_MoneyToolTip( false )")
	self.warehouseMoneyTit			:addInputEvent("Mouse_On",	"_itemMarket_MoneyToolTip( true, 1 )")
	self.warehouseMoneyTit			:addInputEvent("Mouse_Out",	"_itemMarket_MoneyToolTip( false )")

	self.btn_Sort_ItemName			:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 10 .. " )")
	self.btn_Sort_RecentPrice		:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 11 .. " )")
	self.btn_Sort_RegistItemCount	:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 12 .. " )")
	self.btn_Sort_AverageTradePrice	:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 13 .. " )")
	self.btn_Sort_RecentRegistDate	:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 14 .. " )")
	self.btn_BackPage				:setTooltipEventRegistFunc("_itemMarket_ShowIconToolTip( true, " .. 1 .. ", " .. 15 .. " )")
	
end
function ItemMarket:registMessageHandler()
	registerEvent("FromClient_notifyItemMarketMessage", "FromClient_notifyItemMarketMessage")
	registerEvent("FromClient_InventoryUpdate",			"ItemMarket_UpdateMoneyByWarehouse")
	registerEvent("EventWarehouseUpdate",				"ItemMarket_UpdateMoneyByWarehouse")
	registerEvent("FromClient_NotifyItemMarketByParty",	"FromClient_NotifyItemMarketByParty" )
end

ItemMarket:Initialize()
ItemMarket:registEventHandler()
ItemMarket:registMessageHandler()

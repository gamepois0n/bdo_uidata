local UI_TM     = CppEnums.TextMode
local UI_PUCT   = CppEnums.PA_UI_CONTROL_TYPE
local UI_color  = Defines.Color
local UI_PLT    = CppEnums.CashPurchaseLimitType
local UI_CCC    = CppEnums.CashProductCategory


Panel_IngameCashShop:SetShow(false, false)

local   inGameShop  =   {
	_config =
	{
		_slot   =
		{
			_startX     = 15,
			_startY     = 238,
			_gapY       = 70,
		},
		
		_tab    =
		{
			_startX     = 719,
			_startY     = 0,
			_gapY       = 56,
			_gapYY      = 65,
		},
		_item	= 
		{
			_startX		= 0,
			_startY		= 25,
			_gapX		= 35,
		},
		_relatedItem = 
		{
			_startX		= 0,
			_startY		= 25,
			_gapX		= 35,
		},
		_desc = 
		{
			_startY		= 140,
			_gapY		= 25,
		},
	},
	
	_const  =
	{
		_sortTypeAsc    = 1,
		_sortTypeDesc   = 2,
	},
	
	_static_TopLineBG           = UI.getChildControl( Panel_IngameCashShop, "Static_TopLineBG"),
	_static_PromotionBanner     = UI.getChildControl( Panel_IngameCashShop, "Static_PromotionBanner"),
	_static_GradationTop        = UI.getChildControl( Panel_IngameCashShop, "Static_Gradation_Top"),
	_static_GradationBottom     = UI.getChildControl( Panel_IngameCashShop, "Static_Gradation_Bottom"),
	_staticText_CashCount       = UI.getChildControl( Panel_IngameCashShop, "StaticText_NowCashCount"),
	_staticText_PearlCount      = UI.getChildControl( Panel_IngameCashShop, "StaticText_NowPearlCount"),
	_staticText_SilverCount     = UI.getChildControl( Panel_IngameCashShop, "StaticText_SilverCount"),
	_staticText_MileageCount    = UI.getChildControl( Panel_IngameCashShop, "StaticText_MileageCount"),
	_static_SideLineLeft        = UI.getChildControl( Panel_IngameCashShop, "Static_SideLineLeft"),
	_static_SideLineRight       = UI.getChildControl( Panel_IngameCashShop, "Static_SideLineRight"),
	_scroll_IngameCash          = UI.getChildControl( Panel_IngameCashShop, "Scroll_IngameCash"),
	_static_ScrollArea          = UI.getChildControl( Panel_IngameCashShop, "Static_ScrollArea"),
	_static_ScrollArea1			= UI.getChildControl( Panel_IngameCashShop, "Static_ScrollArea_1"),
	_static_ScrollArea2			= UI.getChildControl( Panel_IngameCashShop, "Static_ScrollArea_2"),

	_static_Construction        = UI.getChildControl( Panel_IngameCashShop, "Static_Construction"),
	

	_edit_Search                = UI.getChildControl( Panel_IngameCashShop, "Edit_GoodsName"),
	_button_Search              = UI.getChildControl( Panel_IngameCashShop, "Button_Search"),
	
	
	_combo_Class                = UI.getChildControl( Panel_IngameCashShop, "Combobox_ClassSort"),
	_combo_Sort                 = UI.getChildControl( Panel_IngameCashShop, "Combobox_PriceSort"),
	_combo_SubFilter            = UI.getChildControl( Panel_IngameCashShop, "Combobox_SubFilter"),

	_haveCashBoxBG              = UI.getChildControl( Panel_IngameCashShop, "Static_HaveCashBoxBG"),
	_pearlBox                   = UI.getChildControl( Panel_IngameCashShop, "Static_PearlBox"),
	_nowPearlIcon               = UI.getChildControl( Panel_IngameCashShop, "Static_NowPearlIcon"),
	_silverBox                  = UI.getChildControl( Panel_IngameCashShop, "Static_SilverBox"),
	_silver             	    = UI.getChildControl( Panel_IngameCashShop, "Static_SilverIcon"),
	_mileageBox                 = UI.getChildControl( Panel_IngameCashShop, "Static_MileageBox"),
	_mileage                    = UI.getChildControl( Panel_IngameCashShop, "Static_MileageIcon"),
	_cashBox                    = UI.getChildControl( Panel_IngameCashShop, "Static_CashBox"),
	_nowCash                    = UI.getChildControl( Panel_IngameCashShop, "Static_CashIcon"),
	_btn_BuyPearl               = UI.getChildControl( Panel_IngameCashShop, "Button_BuyPearl"),
	_btn_BuyDaum                = UI.getChildControl( Panel_IngameCashShop, "Button_BuyDaum"),
	_btn_RefreshCash            = UI.getChildControl( Panel_IngameCashShop, "Button_RefreshCash"),

	desc = 
	{
		-- 그룹 상품 관련
		_static_ItemNameCombo		= nil,

		-- 상품 기본 정보
		_staticText_Title			= nil,
		_static_SlotBG				= nil,
		_static_Slot				= nil,
		_static_Desc				= nil,
		-- 상품 추가 정보
		_staticText_PurchaseLimit	= nil,
		_static_VestedDesc			= nil,
		_static_TradeDesc			= nil,
		_static_ClassDesc			= nil,
		_static_WarningDesc			= nil,
		_static_DiscountPeriodDesc	= nil,
		_static_ItemListTitle		= nil,
		-- 관련 상품
		_static_RelatedItemTitle	= nil,
	},

	_itemCount					= 10,
	_items						= Array.new(),
	_relatedItems				= Array.new(),
	_comboList					= Array.new(),
	_listComboCount				= 1,
	itemDescDetailSize			= 0,

	_openFunction               = false,
	_openProductKeyRaw          = -1,
	_categoryWeb                = nil,
	_promotionWeb               = nil,
	_promotionSizeY             = 0,
	_promotionTab               = {},
	_myCartTab                  = {},

	_tabCount                   = getCashCategoryCount(),
	_slotCount                  = 30,
	_sortCount                  = 3,
	
	_slots                      = Array.new(),
	_tabs                       = Array.new(),
	_list                       = Array.new(),
	_listCount                  = 1,
	
	_currentTab                 = nil,
	_currentClass               = nil,
	_search                     = nil,
	_currentSort                = nil,
	_currentSubFilter			= nil,

	_openByEventAlarm           = false,
	_currentPos					= 0,
	_position					= 0,
	_maxDescSize				= 200,
}
inGameShop._scrollBTN_IngameCash    = UI.getChildControl( inGameShop._scroll_IngameCash,    "Scroll_CtrlButton")
inGameShop._combo_ClassList         = UI.getChildControl( inGameShop._combo_Class,          "Combobox_List")
inGameShop._combo_SubFilterList     = UI.getChildControl( inGameShop._combo_SubFilter,      "Combobox_List")
inGameShop._combo_SortList          = UI.getChildControl( inGameShop._combo_Sort,           "Combobox_List")
inGameShop._goodDescBG				= UI.getChildControl( inGameShop._static_ScrollArea,    "Static_GoodsDescBG")



local tabId = {
	pearlBox		= 0,
	mileage			= 1,
	convenience		= 2,
	avatar			= 3,
	furniture		= 4,
	vehicle			= 5,
	pet				= 6,
	customization	= 7,
	dye				= 8,
	hotNew			= 9,
	avatar2			= 10,
}

local tabIconTexture = {
	[0] = -- 노멀, 오버, 클릭
		{ [0] = {149,1,187,39},     {190,1,228,39},     {231,1,275,44}      },          -- 펄상자 0
		{ [0] = {149,44,187,82},    {190,44,228,82},    {231,47,275,90}     },          -- 마일리지 1
		{ [0] = {149,87,187,125},   {190,87,228,125},   {231,93,275,136}    },          -- 편의/기능 2
		{ [0] = {149,130,187,168},  {190,130,228,168},  {231,139,275,182}   },          -- 의상 3
		{ [0] = {149,173,187,211},  {190,173,228,211},  {231,186,275,229}   },          -- 가구 4
		{ [0] = {149,216,187,254},  {190,216,228,254},  {231,232,275,275}   },          -- 말 관련 5
		{ [0] = {278,1,316,39},     {319,1,357,39},     {360,1,404,44}      },          -- 애완동물 관련 6
		{ [0] = {278,44,316,82},    {319,44,357,82},    {360,47,404,90}     },          -- 뷰티 7
		{ [0] = {278,87,316,125},   {319,87,357,125},   {360,93,404,136}    },          -- 염색 8 
		{ [0] = {278,130,316,168},  {319,130,357,168},  {360,139,404,182}   },          -- Hot&New 9
		{ [0] = {278,259,316,297},  {319,259,357,297},  {407,47,451,90}	   	},          -- 의상2 10
		{ [0] = {278,173,316,211},  {319,173,357,211},  {360,186,404,229}   },          -- 프로모션 11
		{ [0] = {278,216,316,254},  {319,216,357,254},  {360,232,404,275}   },          -- 장바구니 12
}

if isGameTypeEnglish() then	-- 2번째 의상 슬롯 아이콘 북미는 다르게.
	tabIconTexture[10] = { [0] = {149,259,187,297},  {190,259,228,297},  {407,1,451,44} }
end

local tagTexture = {
	[0] =	{0, 0, 0, 0}, 			-- 기본
			{4, 3, 238, 67},    	-- New
			{4, 70, 238, 134},  	-- Hot
			{4, 137, 238, 201}, 	-- Best
			{4, 204, 238, 268}, 	-- Event
			{274, 443, 508, 507},	-- Limited
}

local contry = {
	kr = 0,
	jp = 1,
	ru = 2,
	cn = 3,
}

local cashIconType = {
	cash	= 0,
	pearl	= 1,
	mileage	= 2,
	silver	= 3,
}

local cashIconTexture = {
	[cashIconType.cash] = {
		[0] =	{310,	479,	329,	498},	-- 한국
				{267,	479,	286,	498},	-- 일본
				{310,	479,	329,	498},	-- 러시아
				{310,	479,	329,	498},	-- 중국
	},
	[cashIconType.pearl] = {
		[0] =	{287,	479,	307,	498},	-- 한국
				{287,	479,	307,	498},	-- 일본
				{287,	479,	307,	498},	-- 러시아
				{287,	479,	307,	498},	-- 중국
	},
	[cashIconType.mileage] = {
		[0] =	{333, 	479, 	351, 	498},	-- 한국
				{333, 	479, 	351, 	498},	-- 일본
				{333, 	479, 	351, 	498},	-- 러시아
				{333, 	479, 	351, 	498},	-- 중국
	},
	[cashIconType.silver] = {
		[0] =	{0,		0,		30,		30},	-- 한국
				{0,		0,		30,		30},	-- 일본
				{0,		0,		30,		30},	-- 러시아
				{0,		0,		30,		30},	-- 중국
	},
}

local subFilterList = {
	furnitureSet		= 0,
	furnitureOnePiece	= 1,
	Chandelier			= 2,
	floor				= 3,
	wall				= 4,
	furnitureEtc		= 5,
	avartarSet			= 6,
	avartarOnePiece		= 7,
	underWear			= 8,
	accessoryHead		= 9,
	accessoryEyes		= 10,
	accessoryMouse		= 11,
}
local subFilterCount = 12

local subFilterListReplace = {	-- id는 DataSheet_CashProduct.xlsm DisplayFilter에서 정의한다.
	[subFilterList.furnitureSet]		= { id = 1,		str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE_FURNITURESET")	},	-- "가구 세트"
	[subFilterList.furnitureOnePiece]	= { id = 2,		str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_TAB_4")	},	-- "가구"	
	[subFilterList.Chandelier]			= { id = 3,		str = PAGetString(Defines.StringSheet_GAME, "HOUSINGMODE_OBJECT_CHANDELIER") },	-- "샹들리에"
	[subFilterList.floor]				= { id = 4,		str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE_FLOOR")	},	-- "바닥"				
	[subFilterList.wall]				= { id = 5,		str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE_WALL")	},	-- "벽"				
	[subFilterList.furnitureEtc]		= { id = 6,		str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE_FURNITUREETC")	}, 	-- "기타 가구"			
	[subFilterList.avartarSet]			= { id = 11,	str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_AVARTAR_AVARTARSET")	},	-- "의상 세트"			
	[subFilterList.avartarOnePiece]		= { id = 12,	str = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_AVARTAR_AVARTAR_PIECE")	},	-- "의상"				
	[subFilterList.underWear]			= { id = 13,	str = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_UNDERWEAR")	},	-- "속옷"				
	[subFilterList.accessoryHead]		= { id = 14,	str = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_HEAD")	},	-- "액세서리(머리, 귀)"	
	[subFilterList.accessoryEyes]		= { id = 15,	str = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_EYES")	},	-- "액세서리(눈)"		
	[subFilterList.accessoryMouse]		= { id = 16,	str = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_MOUSE")	}, 	-- "액세서리(입, 턱)"	
}

local eCountryType		= CppEnums.CountryType
local gameServiceType	= getGameServiceType()
local isKorea			= (eCountryType.NONE == gameServiceType) or (eCountryType.DEV == gameServiceType) or (eCountryType.KOR_ALPHA == gameServiceType) or (eCountryType.KOR_REAL == gameServiceType) or (eCountryType.KOR_TEST == gameServiceType)
local isNaver			= ( CppEnums.MembershipType.naver == getMembershipType() )


local nilIconPath			= "New_Icon/03_ETC/item_unknown.dds"
local nilProductIconPath	= "New_Icon/09_Cash/03_Product/00021034.dds"

local disCountSetUse = false	-- 미국이면 true 그외 국가면 false
function InGameShop_GameTypeCheck()
	if isGameTypeEnglish() then
		disCountSetUse = true
	else
		disCountSetUse = false
	end
end

local tag_changeTexture = function( slot, tagType )
	local control = slot.tag
	control:ChangeTextureInfoName( "new_ui_common_forlua/window/ingamecashshop/CashShop_03.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, tagTexture[tagType][1], tagTexture[tagType][2], tagTexture[tagType][3], tagTexture[tagType][4] )
	control:getBaseTexture():setUV( x1, y1, x2, y2 )
	control:setRenderTexture(control:getBaseTexture())
end

function cashIcon_changeTexture( control, contry )
	control:ChangeTextureInfoName( "new_ui_common_forlua/window/ingamecashshop/CashShop_01.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, cashIconTexture[cashIconType.cash][contry][1], cashIconTexture[cashIconType.cash][contry][2], cashIconTexture[cashIconType.cash][contry][3], cashIconTexture[cashIconType.cash][contry][4] )
	control:getBaseTexture():setUV( x1, y1, x2, y2 )
	control:setRenderTexture(control:getBaseTexture())
end

function cashIcon_changeTextureForList( control, contry, iconType )
	local cashIconPath = ""
	if cashIconType.cash == iconType or cashIconType.pearl == iconType or cashIconType.mileage == iconType then
		cashIconPath = "new_ui_common_forlua/window/ingamecashshop/CashShop_01.dds"
	elseif cashIconType.silver == iconType then
		cashIconPath = "new_ui_common_forlua/window/inventory/silver.dds"
	end
	control:ChangeTextureInfoName( cashIconPath )
	local x1, y1, x2, y2 = setTextureUV_Func( control, cashIconTexture[iconType][contry][1], cashIconTexture[iconType][contry][2], cashIconTexture[iconType][contry][3], cashIconTexture[iconType][contry][4] )

	control:getBaseTexture():setUV( x1, y1, x2, y2 )
	control:setRenderTexture(control:getBaseTexture())
end

function    inGameShop:init()
	local   tabConfig       = self._config._tab
	local   slotConfig      = self._config._slot
	local   maxSlotCount    = self._slotCount
	
	-- Filter Combo List
	--{
		local   count       = 0
		local   classCount  = getCharacterClassCount()
		self._combo_Class:DeleteAllItem()
		self._combo_Class:AddItemWithKey( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_CLASSBASE"), getCharacterClassCount() )
		for ii = 0, classCount -1 do
			local   classType   = getCharacterClassTypeByIndex(ii)
			local   className   = getCharacterClassName( classType )
			if ( nil ~= className ) and ( "" ~= className ) and ( " " ~= className ) then
				self._combo_Class:AddItemWithKey( className, classType )
				count   = count + 1
			end
		end
		self._combo_ClassList:SetSize( self._combo_ClassList:GetSizeX(), count * 25 )
		self._combo_ClassList:SetEnableArea(0,0,self._combo_ClassList:GetSizeX(), count * 25)
		local classControl = self._combo_Class:GetListControl()
		classControl:SetItemQuantity( count + 1 )


		self._combo_SubFilter:DeleteAllItem()	-- 서브 필터
		for idx = 0, subFilterCount-1 do
			self._combo_SubFilter:AddItemWithKey( subFilterListReplace[idx].str, subFilterListReplace[idx].id )
		end
		self._combo_SubFilterList:SetSize( self._combo_SubFilterList:GetSizeX(), subFilterCount * 20 )
		self._combo_SubFilterList:SetEnableArea(0,0,self._combo_SubFilterList:GetSizeX(), subFilterCount * 20)
		local subFilterControl = self._combo_SubFilter:GetListControl()
		subFilterControl:SetItemQuantity( subFilterCount )

		
		self._combo_Sort:DeleteAllItem()
		for ii = 0, self._sortCount -1 do
			self._combo_Sort:AddItemWithKey( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_SORT_" .. ii), ii )
		end
		self._combo_SortList:SetSize( self._combo_SortList:GetSizeX(), self._sortCount * 20 )
		self._combo_SortList:SetEnableArea(0,0,self._combo_SortList:GetSizeX(), self._sortCount * 20)
		local sortControl = self._combo_Sort:GetListControl()
		sortControl:SetItemQuantity( self._sortCount )
	--}

	-- Tab Init
	for ii = 0, self._tabCount  do
		local   tab     = {}
		-- 펄은 다른 탭으로 만든다.
		if tabId.pearlBox == ii then
			tab.static  = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "RadioButton_CategoryTab2",			Panel_IngameCashShop,   "InGameShop_Tab_"                   .. ii )
			tab.text	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "StaticText_Category2",				tab.static,				"InGameShop_Text_"                  .. ii )
		elseif tabId.hotNew == ii then
			tab.static  = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "RadioButton_CategoryTab_HotAndNew",	Panel_IngameCashShop,   "InGameShop_Tab_"                   .. ii )
			tab.text	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "StaticText_CategoryHotAndNew",		tab.static,				"InGameShop_Text_"                  .. ii )
		else
			tab.static	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "RadioButton_CategoryTab",				Panel_IngameCashShop,   "InGameShop_Tab_"                   .. ii )
			tab.text	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "StaticText_Category",					tab.static,				"InGameShop_Text_"                  .. ii )
		end

		tab.text:SetTextMode( UI_TM.eTextMode_AutoWrap )
		tab.static:SetText( "" )
		tab.icon    = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, tostring("Static_ButtonIcon_" .. ii),  tab.static,             "InGameShop_Tab_Icon_"              .. ii )
		_ingameCash_SetTabIconTexture( tab.icon, ii, 0 )    -- 컨트롤, 탭아이콘넘버, 상태
		
		-- 리사이즈 문제로 위치는 업데이트에서 한다.(2015.06.19 김창욱)
		tab.text:SetText( PAGetString(Defines.StringSheet_GAME, tostring("LUA_INGAMESHOP_TAB_" .. ii) ) )
		tab.static:addInputEvent(   "Mouse_LUp",    "InGameShop_TabEvent(" .. ii .. ")" )
		tab.static:addInputEvent(   "Mouse_On",     "_inGameShop_TabOnOut_ChangeTexture( true, " .. ii .. ")" )
		tab.static:addInputEvent(   "Mouse_Out",    "_inGameShop_TabOnOut_ChangeTexture( false, " .. ii .. ")" )
		tab.static:SetShow(true)

		-- 강제 : 노출 탭 버튼 수정.
		-- if tabId.dye == ii or tabId.avatar2 == ii then
		if tabId.dye == ii then
			tab.static:SetShow(false)
		end

		self._tabs[ii]  = tab
	end

	-- 프로모션 탭 생성
	local promotionTab  = {}
	promotionTab.static = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "RadioButton_CategoryTab", Panel_IngameCashShop,       "InGameShop_PromotionTab" )
	promotionTab.icon   = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "Static_ButtonIcon_0",     promotionTab.static,    "InGameShop_PromotionTab_Icon" )
	promotionTab.static:SetPosX( tabConfig._startX )
	promotionTab.static:SetPosY( 5 )
	promotionTab.static:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_PROMOTIONTAB_FIRST") )-- "처음")
	_ingameCash_SetTabIconTexture( promotionTab.icon, self._tabCount+1, 0 )   -- 컨트롤, 탭아이콘넘버, 상태
	promotionTab.static:SetShow( true )

	self._promotionTab  = promotionTab

	-- 상품 리스트 생성
	for ii = 0, maxSlotCount -1 do
		local   slot        = {}
		
		slot.productNoRaw   = nil
		slot.static         = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Static_GoodsBG",                 self._static_ScrollArea,    "InGameShop_Slot_"                  .. ii )
		slot.productIcon    = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Static_ProductImage",            slot.static,                "InGameShop_Slot_ProductIcon_"      .. ii )
		slot.tag            = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Static_GoodsHighlightLine",      slot.static,                "InGameShop_Slot_Tag_"              .. ii )
		slot.iconBG         = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Static_SlotBG",                  slot.static,                "InGameShop_Slot_IconBG_"           .. ii )
		slot.icon           = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Static_Slot",                    slot.iconBG,                "InGameShop_Slot_Icon_"             .. ii )
		slot.name           = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_StaticText_ItemName",            slot.static,                "InGameShop_Slot_Name_"             .. ii )
		slot.discount       = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_StaticText_DiscountPeriod",      slot.static,                "InGameShop_Slot_DiscountPeriod_"   .. ii )
		slot.pearlIcon      = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Static_PearlIcon",               slot.static,                "InGameShop_Slot_PearlIcon_"        .. ii )
		slot.originalPrice  = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_StaticText_ItemOriginalPrice",   slot.pearlIcon,             "InGameShop_Slot_OriginalPrice_"    .. ii )
		slot.price          = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_StaticText_ItemPrice",           slot.pearlIcon,             "InGameShop_Slot_Price_"            .. ii )
		slot.buttonBuy      = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Button_Buy",                     slot.static,                "InGameShop_Slot_Buy_"              .. ii )
		slot.buttonGift     = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Button_Gift",                    slot.static,                "InGameShop_Slot_Gift_"             .. ii )
		slot.buttonCart     = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "TemplateList_Button_Cart",                    slot.static,                "InGameShop_Slot_Cart_"             .. ii )
		
		-- 좌표 설정.
		--{
			slot.static     :SetPosX( 0 )
			slot.static     :SetPosY( slotConfig._gapY * ii )
		--}
		slot.discount       :SetTextMode( UI_TM.eTextMode_Limit_AutoWrap )
		slot.name           :SetTextMode( UI_TM.eTextMode_Limit_AutoWrap )
		slot.productIcon    :addInputEvent( "Mouse_LUp",        "IngameCashShop_SelectedItem("  .. ii .. ")")
		slot.productIcon    :addInputEvent( "Mouse_UpScroll",   "InGameShop_ScrollEvent( true )"    )
		slot.productIcon    :addInputEvent( "Mouse_DownScroll", "InGameShop_ScrollEvent( false )"   )
		slot.static         :addInputEvent( "Mouse_UpScroll",   "InGameShop_ScrollEvent( true )"    )
		slot.static         :addInputEvent( "Mouse_DownScroll", "InGameShop_ScrollEvent( false )"   )
		slot.static         :addInputEvent( "Mouse_LUp",        "IngameCashShop_SelectedItem("  .. ii .. ")")
		slot.buttonCart     :addInputEvent( "Mouse_LUp",        "IngameCashShop_CartItem("      .. ii .. ")")
		slot.buttonGift     :addInputEvent( "Mouse_LUp",        "IngameCashShop_GiftItem("      .. ii .. ")")
		slot.buttonBuy      :addInputEvent( "Mouse_LUp",        "IngameCashShop_BuyItem("       .. ii .. ")")

		slot.originalPrice  :SetPosX( slot.pearlIcon:GetSizeX() + 3 )
		slot.originalPrice  :SetPosY(-1)
		slot.originalPrice  :SetLineRender( true )
		slot.originalPrice  :SetFontColor( UI_color.C_FF626262 )
		slot.price          :SetPosX( slot.pearlIcon:GetSizeX() - 3 )
		slot.price          :SetPosY( -3 )

		slot.tag            :SetShow( true )
		slot.static         :SetShow( false )
	
		self._slots[ii] = slot
	end

	-- 장바구니 탭 생성
	local myCartTab = {}
	myCartTab.static    = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "RadioButton_CartTab", Panel_IngameCashShop,       "InGameShop_MyCartTab" )
	myCartTab.icon  = UI.createAndCopyBasePropertyControl( Panel_IngameCashShop, "Static_ButtonIcon_0",     myCartTab.static,   "InGameShop_MyCartTab_Icon" )
	myCartTab.static:SetPosX( tabConfig._startX )
	myCartTab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * self._slotCount) + tabConfig._gapY )
	myCartTab.static:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MYCARTTAB") )-- "장바구니( <PAColor0xFFFFBC1A>0<PAOldColor> )")
	myCartTab.static:SetShow( true )
	_ingameCash_SetTabIconTexture( myCartTab.icon, self._tabCount+2, 0 )      -- 컨트롤, 탭아이콘넘버, 상태
	self._myCartTab = myCartTab
	
	-- 콤보 박스를 위로
	Panel_IngameCashShop:SetChildIndex(self._combo_Class, 9999 )
	Panel_IngameCashShop:SetChildIndex(self._combo_Sort, 9999 )
	Panel_IngameCashShop:SetChildIndex(self._combo_SubFilter, 9999 )

	-- Slot Init
	-- 처음과 끝 그라데이션 좌표 설정.
	--{
		self._static_GradationTop:SetPosX( slotConfig._startX )
		self._static_GradationTop:SetPosY( slotConfig._startY )
		
		self._static_GradationBottom:SetPosX( slotConfig._startX )
		self._static_GradationBottom:SetPosY( self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - self._static_GradationBottom:GetSizeY() )

		-- Panel_IngameCashShop:SetChildIndex(self._static_GradationTop, 8888 )
		-- Panel_IngameCashShop:SetChildIndex(self._static_GradationBottom, 8888 )
	--}

	FGlobal_Init_IngameCashShop_NewCart( slotConfig._gapY )


	local scrSizeY      = getScreenSizeY()
	
	self._promotionWeb = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_IngameCashShop, 'IngameCashShop_PromotionWebLink' )
	self._promotionWeb:SetShow( true )
	self._promotionWeb:SetPosX( 0 )
	self._promotionWeb:SetPosY( 0 )
	self._promotionWeb:SetSize( 709, scrSizeY - 95 )
	self._promotionWeb:ResetUrl()
	Panel_IngameCashShop:SetChildIndex(self._promotionWeb, 9999 ) 

	self._categoryWeb = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._static_PromotionBanner, 'IngameCashShop_CategoryWebLink' )
	self._categoryWeb:SetShow( true )
	self._categoryWeb:SetPosX( 0 )
	self._categoryWeb:SetPosY( 0 )
	self._categoryWeb:SetSize( 686, 178 )
	self._categoryWeb:ResetUrl()
	self._categoryWeb:addInputEvent(    "Mouse_Out",    "ToClient_CategoryWebFocusOut()" )
	
	self._static_PromotionBanner:SetChildIndex(self._categoryWeb, 9999 )

	-- 국가에 따라, 캐시 아이콘을 달리 한다.
	if 0 == gameServiceType or 1 == gameServiceType or 2 == gameServiceType or 3 == gameServiceType or 4 == gameServiceType then
		-- 한국
		cashIcon_changeTexture( self._nowCash, contry.kr )
	elseif 5 == gameServiceType or 6 == gameServiceType then
		-- 일본
		cashIcon_changeTexture( self._nowCash, contry.jp )
	elseif 7 == gameServiceType or 8 == gameServiceType then
		-- 러시아
		cashIcon_changeTexture( self._nowCash, contry.ru )
	elseif 9 == gameServiceType or 10 == gameServiceType then
		-- 중국
		cashIcon_changeTexture( self._nowCash, contry.cn )
	else	-- 그외
		cashIcon_changeTexture( self._nowCash, contry.kr )
	end
	

	self._scroll_IngameCash:SetShow( false )
	FGlobal_ClearCandidate()
end

function inGameShop:RemakeSubFilter( tabIdx )	-- 서브 필터를 다시 만든다.
	local condition		= false
	local defaultName	= ""

	local conditionCheck = function( idx )
		if 3 == tabIdx then		-- 의상탭
			condition = (10 < idx) and (idx < 21)
			defaultName = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_AVARTAR")	-- "의상 필터"	
		elseif 4 == tabIdx then	-- 가구탭
			condition = (0 < idx) and (idx < 11)
			defaultName = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE")	-- "가구 필터"
		else
			condition = false
			defaultName = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_DONTUSE")	-- "사용불가"
		end
		return condition
	end

	inGameShop._combo_SubFilter:DeleteAllItem()
	local uiCount = 0
	for idx = 0, subFilterCount-1 do
		if conditionCheck( subFilterListReplace[idx].id ) then
			inGameShop._combo_SubFilter:AddItemWithKey( subFilterListReplace[idx].str, subFilterListReplace[idx].id )
			uiCount = uiCount + 1
		end
	end
	inGameShop._combo_SubFilterList:SetSize( inGameShop._combo_SubFilterList:GetSizeX(), uiCount * 20 )
	inGameShop._combo_SubFilterList:SetEnableArea(0,0,inGameShop._combo_SubFilterList:GetSizeX(), uiCount * 20)
	inGameShop._combo_SubFilter:SetText( defaultName )
	local subFilterControl = inGameShop._combo_SubFilter:GetListControl()
	subFilterControl:SetItemQuantity( uiCount )
end

function    inGameShop:updateMoney()
	local   selfProxy   = getSelfPlayer():get()
	
	-- 캐시, 펄, 마일리지
	--{
		local   cash    = selfProxy:getCash()
		local   pearl   = Defines.s64_const.s64_0
		local   mileage = Defines.s64_const.s64_0
		local	money	= Defines.s64_const.s64_0
		local	moneyItemWrapper	= getInventoryItemByType( CppEnums.ItemWhereType.eInventory, getMoneySlotNo() )
		if	( nil ~= moneyItemWrapper )	then
			money	= moneyItemWrapper:get():getCount_s64()
		end
		
		local   pearlItemWrapper    = getInventoryItemByType( CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo() )
		if  ( nil ~= pearlItemWrapper ) then
			pearl   = pearlItemWrapper:get():getCount_s64()
		end
		
		
		local   mileageItemWrapper  = getInventoryItemByType( CppEnums.ItemWhereType.eCashInventory, getMileageSlotNo() )
		if  ( nil ~= mileageItemWrapper )   then
			mileage = mileageItemWrapper:get():getCount_s64()
		end
		
		self._staticText_CashCount:SetText( makeDotMoney(cash) )
		self._staticText_PearlCount:SetText( makeDotMoney(pearl) )
		self._staticText_MileageCount:SetText( makeDotMoney(mileage) )
		self._staticText_SilverCount:SetText( makeDotMoney(money) )
	--}
	return cash, pearl, mileage, money
end

function inGameShop:getMaxPosition()
	if ( -1 ~= self._openProductKeyRaw ) and ( nil ~= self._openProductKeyRaw ) then
		return ( self._listCount - 2 ) * self._config._slot._gapY + self._slots[0].static:GetSizeY() - self._static_ScrollArea:GetSizeY() + self._goodDescBG:GetSizeY()
	else
		return ( self._listCount - 2 ) * self._config._slot._gapY + self._slots[0].static:GetSizeY() - self._static_ScrollArea:GetSizeY()
	end
	
end

function inGameShop:isSelectProductGroup(productNoRaw)
	if ( self._openProductKeyRaw == productNoRaw ) then
		return true
	end
	for key, value in pairs(self._comboList) do
		if ( value == productNoRaw ) then
			return true
		end
	end
	return false
end

function inGameShop:setElement(index, productNoRaw, slot)
	local   maxSlotCount= self._slotCount
	
	local   cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
	if  ( nil == cashProduct )  then
		return false
	end

	-- 배경을 바꿔야 한다.
	if self:isSelectProductGroup(productNoRaw) then
		InGameShop_ProductListContent_ChangeTexture( slot, true )
	else
		InGameShop_ProductListContent_ChangeTexture( slot, false )
	end
	slot.productNoRaw       = productNoRaw
	if nil == cashProduct:getPackageIcon() then
		slot.productIcon    :ChangeTextureInfoName( nilProductIconPath )
	else
		slot.productIcon    :ChangeTextureInfoName( cashProduct:getPackageIcon() )
	end
	
	tag_changeTexture( slot, cashProduct:getTag() )    -- 태그 이미지 적용.

	if nil == cashProduct:getIconPath() then
		slot.icon           :ChangeTextureInfoName( "Icon/" .. nilIconPath )
	else
		slot.icon           :ChangeTextureInfoName( "Icon/" .. cashProduct:getIconPath() )
	end
	slot.icon           :addInputEvent("Mouse_On",  "InGameShop_ProductShowToolTip( " .. slot.productNoRaw .. ", " .. index .. " )")
	slot.icon           :addInputEvent("Mouse_Out", "FGlobal_CashShop_GoodsTooltipInfo_Close()")

	slot.name           :SetText( cashProduct:getDisplayName() )
	slot.price          :SetText( makeDotMoney(cashProduct:getPrice()) )
	slot.originalPrice  :SetShow( false )
					
	-- 할인기간중이면 할인기간을 표시, 아니면 기본 정보를 표시한다.
	slot.discount:SetText( cashProduct:getDescription() )

	if  ( cashProduct:isApplyDiscount() )   then
		local   startDiscountTimeValue  = PATime( cashProduct:getStartDiscountTime():get_s64() )
		local   endDiscountTimeValue    = PATime( cashProduct:getEndDiscountTime():get_s64() )
		local   startDiscountTime       = tostring( startDiscountTimeValue:GetYear() )  .. "." .. tostring( startDiscountTimeValue:GetMonth() ) .. "." .. tostring( startDiscountTimeValue:GetDay() )
		local   endDiscountTime         = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring( endDiscountTimeValue:GetYear() ), "GetMonth", tostring( endDiscountTimeValue:GetMonth() ), "GetDay", tostring( endDiscountTimeValue:GetDay() )) .. " " .. string.format( "%.02d", endDiscountTimeValue:GetHour() ) .. ":" .. string.format( "%.02d", endDiscountTimeValue:GetMinute() )
		local countryKind = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring( endDiscountTimeValue:GetYear() ), "GetMonth", tostring( endDiscountTimeValue:GetMonth() ), "GetDay", tostring( endDiscountTimeValue:GetDay() )) .. " " .. string.format( "%.02d", endDiscountTimeValue:GetHour() ) .. ":" .. string.format( "%.02d", endDiscountTimeValue:GetMinute() )
		local remainTime = convertStringFromDatetime(cashProduct:getRemainDiscountTime())
		if (true == disCountSetUse) then
			countryKind = remainTime
		else
			countryKind = endDiscountTime
		end
		-- local remainTime = convertStringFromDatetime(cashProduct:getRemainDiscountTime())

		slot.discount:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DISCOUNT", "endDiscountTime", countryKind) )-- "<PAColor0xfface400>할인 기간 : " .. endDiscountTime .. "까지<PAOldColor>" 
		slot.originalPrice  :SetText( makeDotMoney(cashProduct:getOriginalPrice()) .. " <PAColor0xffefefef>→<PAOldColor> " )
		slot.originalPrice  :SetShow( true )
	end

	-- 펄 아이콘을 바꾼다.
	InGameShop_ProductListContent_ChangeMoneyIconTexture( slot, cashProduct:getCategory(), cashProduct:isMoneyPrice() )
	local limitType = cashProduct:getCashPurchaseLimitType()
	if UI_CCC.eCashProductCategory_Pearl == cashProduct:getCategory() or UI_CCC.eCashProductCategory_Mileage == cashProduct:getCategory() then
		slot.buttonBuy  :SetMonoTone( false )
		slot.buttonGift :SetMonoTone( true )
		slot.buttonCart :SetMonoTone( true )
						
		slot.buttonBuy  :SetEnable( true )
		slot.buttonGift :SetEnable( false )
		slot.buttonCart :SetEnable( false )
	else
		if UI_PLT.None ~= limitType then
			local limitCount    = cashProduct:getCashPurchaseCount()
			local mylimitCount  = getIngameCashMall():getRemainingLimitCount( cashProduct:getNoRaw() )
			if 0 < limitCount then
				slot.buttonBuy  :SetMonoTone( false )
				slot.buttonGift :SetMonoTone( true )
				slot.buttonCart :SetMonoTone( false )
								
				slot.buttonBuy  :SetEnable( true )
				slot.buttonGift :SetEnable( false )
				slot.buttonCart :SetEnable( true )

				if mylimitCount <= 0 then
					slot.buttonBuy  :SetMonoTone( true )
					slot.buttonCart :SetMonoTone( true )

					slot.buttonBuy  :SetEnable( false )
					slot.buttonCart :SetEnable( false )
				end
			else
				slot.buttonBuy  :SetMonoTone( true )
				slot.buttonGift :SetMonoTone( true )
				slot.buttonCart :SetMonoTone( true )
								
				slot.buttonBuy  :SetEnable( false )
				slot.buttonGift :SetEnable( false )
				slot.buttonCart :SetEnable( false )
			end
		else
			slot.buttonBuy:SetMonoTone( false )
			slot.buttonGift:SetMonoTone( true )
			slot.buttonCart:SetMonoTone( false )

			slot.buttonBuy:SetEnable( true )
			slot.buttonGift:SetEnable( false )
			slot.buttonCart:SetEnable( true )
		end
	end
					
	slot.static:SetShow(true)
	if self._currentPos <= 0 then   -- 0이면 위화살표 노출 안함.
		self._static_GradationTop:SetShow( false )
	else
		self._static_GradationTop:SetShow( true )
	end

	if (self:getMaxPosition()) <= (self._currentPos) then  -- 마지막까지 나오면 아래화살표 노출 안함.
		self._static_GradationBottom:SetShow( false )
	else
		self._static_GradationBottom:SetShow( true )
	end
	return true
end

function inGameShop:updateSlot()
	local   maxSlotCount	= self._slotCount
	local   index			= 0
	local	pos				= 0
	local	areaSizeY		= self._static_ScrollArea:GetSizeY()
	local	slotSize		= self._slots[0].static:GetSizeY()
	local	gapBetweenList  = self._config._slot._gapY
	local	gap  = self._config._slot._gapY - slotSize

	for ii = 0, self._listCount - 1 do
		local   productNoRaw= self._list[ii+1]
		local   slot		= self._slots[index]
		if ( nil == slot ) then
			return
		end

		slot.static:SetShow(false)
		if ( self._currentPos + areaSizeY < pos ) then
			
		elseif ( self._currentPos < pos + slotSize ) then
			if ( self:setElement(index, productNoRaw, slot) ) then
				slot.static:SetPosY( pos - self._currentPos )
				index   = index + 1
			end
		end

		
		if ( self:isSelectProductGroup(productNoRaw) ) then
			self._goodDescBG:SetShow(false)
			if ( self._goodDescBG:GetSizeY() < self._maxDescSize ) and ( self._position + areaSizeY < pos + slot.static:GetSizeY() + self._goodDescBG:GetSizeY() ) then
				self._position = pos + slot.static:GetSizeY() + self._goodDescBG:GetSizeY() - areaSizeY
				self._scroll_IngameCash:SetControlPos(self._position / self:getMaxPosition())
			end
			if ( self._currentPos < pos + slot.static:GetSizeY() + self._goodDescBG:GetSizeY() ) and ( pos + slot.static:GetSizeY() < self._currentPos + areaSizeY ) then
				self._goodDescBG:SetPosY( pos - self._currentPos + slot.static:GetSizeY() )
				self._goodDescBG:SetShow(true)
			end

			pos = pos + self._goodDescBG:GetSizeY()
		end

		pos = pos + gapBetweenList
	end
end

function    inGameShop:update()
	if Panel_IngameCashShop_NewCart:GetShow() then
		FGlobal_Close_IngameCashShop_NewCart()
	end

	--{
		self:updateMoney()
	--}

	--{ 탭 위치
		for ii = 0, self._tabCount  do
			local tabConfig = self._config._tab
			local tab       = self._tabs[ii]
			if tabId.avatar < ii then
				if ( tabId.hotNew == ii ) then
					tab.static:SetPosX( tabConfig._startX )
					tab.static:SetPosY( tabConfig._startY )
				else
					if isGameTypeEnglish() then
						if tabId.avatar2 == ii then
							tab.static:SetPosX( tabConfig._startX )
							tab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * (tabId.avatar+1)) + tabConfig._gapY )
						elseif tabId.furniture == ii then
							tab.static:SetPosX( tabConfig._startX )
							tab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * (tabId.avatar+2)) + tabConfig._gapY )
						elseif tabId.vehicle == ii then
							tab.static:SetPosX( tabConfig._startX )
							tab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * (tabId.avatar+3)) + tabConfig._gapY )
						elseif tabId.pet == ii then
							tab.static:SetPosX( tabConfig._startX )
							tab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * (tabId.avatar+4)) + tabConfig._gapY )
						elseif tabId.customization == ii then
							tab.static:SetPosX( tabConfig._startX )
							tab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * (tabId.avatar+5)) + tabConfig._gapY )
						else
							tab.static:SetPosX( tabConfig._startX )
							tab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * (ii)) + tabConfig._gapY )
						end
					else
						tab.static:SetPosX( tabConfig._startX )
						tab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * (ii)) + tabConfig._gapY )
					end
				end
			else
				tab.static:SetPosX( tabConfig._startX )
				tab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * ii) + tabConfig._gapY )
			end
			tab.text:SetPosX( 50 )
			tab.text:SetPosY( 5 )
		end
	--}

	--{ 초기화
		local initMaxCount  = 30
		for ii = 0, initMaxCount -1 do
			local slot  = self._slots[ii]
			
			slot.productNoRaw   = nil
			
			slot.static:SetShow(false)
		end
	--}

	--{ 실제 처리.
		self:updateSlot()
	--}
end

function    inGameShop:registMessageHandler()
	Panel_IngameCashShop:RegisterUpdateFunc("InGameCashshopUpdatePerFrame")

	self._static_ScrollArea             :addInputEvent( "Mouse_UpScroll",   "InGameShop_ScrollEvent( true  )"   )
	self._static_ScrollArea             :addInputEvent( "Mouse_DownScroll", "InGameShop_ScrollEvent( false )"   )
	self._button_Search                 :addInputEvent( "Mouse_LUp",        "InGameShop_Search()"               )
	self._edit_Search                   :addInputEvent( "Mouse_LUp",        "InGameShop_ResetSearchText()"              )
	-- self._button_BuyAll                  :addInputEvent( "Mouse_LUp",        "InGameShop_BuyAll()"               )

	self._scrollBTN_IngameCash          :addInputEvent("Mouse_LPress",      "HandleClicked_InGameShop_SetScrollIndexByLClick()")
	self._scrollBTN_IngameCash          :addInputEvent("Mouse_LUp",         "HandleClicked_InGameShop_SetScrollIndexByLClick()")
	self._scroll_IngameCash             :addInputEvent("Mouse_LUp",         "HandleClicked_InGameShop_SetScrollIndexByLClick()")
	
	self._combo_Class                   	:addInputEvent( "Mouse_LUp",        "InGameShop_OpenClassList()")
	self._combo_Sort                    	:addInputEvent( "Mouse_LUp",        "InGameShop_OpenSorList()"  )
	self._combo_SubFilter               	:addInputEvent( "Mouse_LUp",        "InGameShop_OpenSubFilterList()"  )
	self._combo_Class:GetListControl()  	:addInputEvent( "Mouse_LUp",        "InGameShop_SelectClass()"  )
	self._combo_Sort:GetListControl()   	:addInputEvent( "Mouse_LUp",        "InGameShop_SelectSort()"   )
	self._combo_SubFilter:GetListControl()  :addInputEvent( "Mouse_LUp",        "InGameShop_SelectSubFilter()"   )

	inGameShop.desc._static_ItemNameCombo					:addInputEvent(	"Mouse_LUp",	"HandleClicked_IngameCashShop_ShowSubList()"	)
	inGameShop.desc._static_ItemNameCombo:GetListControl()	:addInputEvent( "Mouse_LUp",	"HandleClicked_IngameCashShop_SelectedSubList()"	)
	inGameShop._goodDescBG:addInputEvent( "Mouse_UpScroll",   "InGameShop_ScrollEvent( true )" )
	inGameShop._goodDescBG:addInputEvent( "Mouse_DownScroll", "InGameShop_ScrollEvent( false )" )

	self._promotionTab.static           :addInputEvent("Mouse_LUp",         "InGameShop_Promotion_Open()")
	self._promotionTab.static           :addInputEvent("Mouse_On",          "InGameShop_ShowSimpleToolTip( true, " .. 0 .. " )")
	self._promotionTab.static           :addInputEvent("Mouse_Out",         "InGameShop_ShowSimpleToolTip( false, " .. 0 .. "  )")

	self._myCartTab.static              :addInputEvent("Mouse_LUp",         "InGameShop_CartToggle()")
	self._myCartTab.static              :addInputEvent("Mouse_On",          "InGameShop_ShowSimpleToolTip( true, " .. 1 .. " )")
	self._myCartTab.static              :addInputEvent("Mouse_Out",         "InGameShop_ShowSimpleToolTip( false, " .. 1 .. "  )")

	self._btn_BuyDaum                   :addInputEvent("Mouse_LUp",         "InGameShop_BuyDaumCash()")
	self._btn_RefreshCash               :addInputEvent("Mouse_LUp",         "InGameShop_RefreshCash()")
	self._btn_BuyPearl                  :addInputEvent("Mouse_LUp",         "InGameShop_BuyPearl()")
end

function    inGameShop:registEventHandler()
	registerEvent( "onScreenResize",                        "InGameShop_Resize"             )
	registerEvent( "FromClient_UpdateCashShop",             "InGameShop_UpdateCashShop"     )
	registerEvent( "FromClient_UpdateCash",                 "InGameShop_UpdateCash"         )
	registerEvent( "EventSelfPlayerPreDead",                "InGameShop_OuterEventForDead"  )   -- 죽을때 꺼주자.
	registerEvent( "ToClient_RequestShowProduct",           "ToClient_RequestShowProduct"   )
	registerEvent( "FromClient_InventoryUpdate",            "InGameShop_UpdateCash"         )
end


----------------------------------------------------------------------------------------------------
-- Data Setting
function    inGameShop:initData()
	self._list      = Array.new()
	self._listCount = 1
	local   count       = getIngameCashMall():getCashProductStaticStatusListCount()
	for ii=0, count -1 do
		local   cashProduct = getIngameCashMall():getCashProductStaticStatusByIndex(ii)
		if  nil ~= cashProduct  then
			if  self:filterData( cashProduct )  then
				self._list[self._listCount] = cashProduct:getNoRaw()
				self._listCount     = self._listCount + 1
			end
		end
	end
	self:sortData()
	-- 스크롤 설정을 한다.
	InGameShop_SetScroll()
end

function    inGameShop:filterData( cashProduct )
	if  ( not CheckCashProduct(cashProduct) )   then
		return (false)
	end
	
	-- Main 아이템만 노출하자.
	if  ( not cashProduct:isMainProduct() ) then
		return (false)
	end
	
	-- tag
	if  ( nil ~= self._currentTab ) then
		if tabId.customization == self._currentTab then
			if cashProduct:getCategory() == tabId.dye or cashProduct:getCategory() == tabId.customization then
				return	(true)
			else
				return	(false)
			end
		elseif  ( cashProduct:getCategory() ~= self._currentTab )   then
			return (false)
		end
	else
		if  ( ( 1 ~= cashProduct:getTag() ) and ( 2 ~= cashProduct:getTag() ) ) then
			return (false)
		end
	end
		
	-- class
	if  ( nil ~= self._currentClass )   then
		if( cashProduct:doHaveDisplayClass() )  then
			if( not cashProduct:isClassTypeUsable(self._currentClass) )     then
				return(false)
			end
		end
	end

	-- _currentSubFilter
	if ( nil ~= self._currentSubFilter )	then
		if ( self._currentSubFilter == cashProduct:getDisplayFilterKey()) then
			return (true)
		else
			return (false)
		end
	end
	
	-- search
	if  (nil ~= self._search )  then
		if  ( nil == cashProduct:getName():find(self._search) ) then
			return (false)
		end
	end

	return(true)
end

function    CheckCashProduct( cashProduct )
	-- 샵에 노출 되지 않는 아이템
	if  ( not cashProduct:isMallDisplayable() ) then
		return(false)
	end
	
	-- 판매 가능 할 때에만 노출한다.
	if  ( not cashProduct:isBuyable() ) then
		return(false)
	end
	
	return(true)
end

function    InGameShop_SortCash( lhs, rhs )
	local   self    = inGameShop
	local   lhsPrice= Defines.s64_const.s64_0
	local   rhsPrice= Defines.s64_const.s64_0
	local   lhsOrder= 0
	local   rhsOrder= 0
	local   lhsNo   = nil
	local   rhsNo   = nil
		
	local   lhsWrapper  = getIngameCashMall():getCashProductStaticStatusByProductNoRaw( lhs )
	if  ( nil ~= lhsWrapper )   then
		lhsPrice    = lhsWrapper:getPrice()
		lhsOrder    = lhsWrapper:getOrder()
		lhsNo       = lhsWrapper:getNoRaw()
	end
	
	local   rhsWrapper  = getIngameCashMall():getCashProductStaticStatusByProductNoRaw( rhs )
	if  ( nil ~= rhsWrapper )   then
		rhsPrice    = rhsWrapper:getPrice()
		rhsOrder    = rhsWrapper:getOrder()
		rhsNo       = rhsWrapper:getNoRaw()
	end
	
	if  (nil == self._currentSort)  then
		if ( lhsOrder == rhsOrder ) then
			return( lhsNo > rhsNo )
		else
			return( lhsOrder < rhsOrder )
		end
	elseif  ( self._const._sortTypeAsc == self._currentSort )   then
		return(lhsPrice > rhsPrice)
	else
		return(lhsPrice < rhsPrice)
	end
end

function    inGameShop:sortData()
	table.sort( self._list, InGameShop_SortCash )
end

----------------------------------------------------------------------------------------------------
-- Function
function    InGameShop_TabEvent( tab )
	if nil == tab then
		return
	end

	local   self    = inGameShop
	FGlobal_IngameCashShop_SelectedItemReset()
	if self._tabs[tab] then -- 클릭한 탭을 맨 위로 올린다.
		Panel_IngameCashShop:SetChildIndex(self._tabs[tab].static, 9999 )
	end

	for ii = 0, self._tabCount  do
		_ingameCash_SetTabIconTexture( self._tabs[ii].icon, ii, 0 ) -- 컨트롤, 탭아이콘넘버, 상태
	end

	-- 마지막은 전체이다.
	if  tab == tabId.hotNew   then
		self._currentTab    = nil
	elseif tab == tabId.avatar2 then
		self._currentTab    = 9
	else
		self._currentTab    = tab
	end

	-- 카테고리를 누르면 다른 필터링 초기화.
	self._currentPos	= 0
	self._position		= 0
	self._scroll_IngameCash:SetControlPos(0)
	self._search        = nil
	self._currentClass  = nil
	self._currentSort   = nil
	self._currentSubFilter	= nil
	self._combo_Class	:SetSelectItemIndex(0)		-- 지우면 수현씨가 찾아 옴.
	self._combo_Sort	:SetSelectItemIndex(0)
	ClearFocusEdit()

	self:RemakeSubFilter( tab )	-- 서브 필터를 새로 만든다.

	if tabId.avatar == tab or tabId.avatar2 == tab then	-- 의상은 자기 클래스를 기본으로 한다.
		local classCount	= getCharacterClassCount()
		local selfClassType = getSelfPlayer():getClassType()
		local myClassIndex		= -1
		for ii = 0, classCount -1 do
			local   classType   = getCharacterClassTypeByIndex( ii )
			if selfClassType == classType then
				myClassIndex = ii
				break
			end
		end
		if -1 ~= myClassIndex then
			self._combo_Class	:SetSelectItemIndex( myClassIndex+1 )
			self._combo_Class	:SetText( getCharacterClassName( selfClassType ) )
			self._currentClass	= selfClassType
		end
	end
	
	self:initData()
	self:update()

	if not self._promotionTab.static:IsCheck() then
		_ingameCash_SetTabIconTexture( self._promotionTab.icon, self._tabCount+1, 0 )
		_ingameCash_SetTabIconTexture( self._tabs[tab].icon, tab, 2 )   -- 컨트롤, 탭아이콘넘버, 상태
		InGameShop_Promotion_Close()
	end

	if not self._myCartTab.static:IsCheck() then
		_ingameCash_SetTabIconTexture( self._myCartTab.icon, self._tabCount+2, 0 )
	end

	if (not self._categoryWeb:GetShow()) then
		self._categoryWeb:SetShow( true )
	end
end

function InGameShop_SetScroll()
	local self              = inGameShop
	local scrollSizeY       = self._scroll_IngameCash:GetSizeY()
	local pagePercent       = (self._slotCount / (self._listCount - 1) ) * 100
	local btn_scrollSizeY   = ( scrollSizeY / 100 ) * pagePercent

	if btn_scrollSizeY < 10 then
		btn_scrollSizeY = 10
	end

	if scrollSizeY <= btn_scrollSizeY then
		btn_scrollSizeY = scrollSizeY * 0.99
	end
	if btn_scrollSizeY < 20 then
		btn_scrollSizeY = 50
	end

	if not self._openFunction then  -- 프로모션 페이지에서는 스크롤을 꺼야 한다.
		if self._slotCount < (self._listCount - 1) then
			self._scroll_IngameCash:SetShow( true )
		else
			self._scroll_IngameCash:SetShow( false )
		end
	end

	self._openFunction = false

	self._scrollBTN_IngameCash:SetSize( self._scrollBTN_IngameCash:GetSizeX(), btn_scrollSizeY )
	self._scroll_IngameCash:SetInterval( self._listCount - self._slotCount - 1 )
	self._scroll_IngameCash:SetControlTop()
end

function inGameShop:RadioReset()
	self._promotionTab.static:SetCheck( false )
	for ii = 0, self._tabCount  do
		local tabConfig = self._config._tab
		local tab       = self._tabs[ii]
		tab.static:SetCheck( false )
	end
	self._myCartTab.static:SetCheck( false )
end

function InGameShop_BuyPearl()
	local   self    = inGameShop
	Panel_IngameCashShop:SetChildIndex(self._tabs[0].static, 9999 )
	FGlobal_IngameCashShop_SelectedItemReset()

	self._currentTab    = 0
	
	-- 카테고리를 누르면 다른 필터링 초기화.
	self._currentPos	= 0
	self._position		= 0
	self._scroll_IngameCash:SetControlPos(0)
	self._search        = nil
	self._currentClass  = nil
	self._currentSort   = nil
	self._currentSubFilter	= nil

	-- 라디오 버튼을 초기화 한다.
	inGameShop:RadioReset()
	self._tabs[0].static:SetCheck( true )

	if self._promotionWeb:GetShow() then
		InGameShop_Promotion_Close()
	end
	if Panel_IngameCashShop_NewCart:GetShow() then
		FGlobal_Close_IngameCashShop_NewCart()
	end

	self:initData()
	self:update()
end

function InGameShop_ReShowByHideUI()
	local   self    = inGameShop
	-- 라디오 버튼을 초기화 한다.
	self:RadioReset()
	self._tabs[self._tabCount].static:SetCheck( true )
	InGameShop_TabEvent( self._tabCount )
end

function InGameShop_BuyDaumCash()   -- 다음 캐시 충전 버튼!
	-- FromClient_AcceptGeneralConditions()
	FGlobal_BuyDaumCash()
end

function    InGameShop_RefreshCash()
	local   selfProxy   = getSelfPlayer():get()
	local   cash        = selfProxy:setRefreshCash()
	
	if not isNaver then
		cashShop_requestCash()
	end
end

function    InGameShop_Search()
	local   self    = inGameShop
	local   search  = self._edit_Search:GetEditText()

	if  (nil == search) or ("" == search) or ( PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_SERACHWORD") == search) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SEARCH_ACK") )-- "검색어를 입력해야 합니다.")
		return
	end
	
	self._edit_Search:SetEditText( search, true )
	ClearFocusEdit()        -- 포커스는 풀어준다.
	self._currentPos	= 0
	self._position		= 0
	self._search        = search
	
	FGlobal_IngameCashShop_SelectedItemReset()
	self:initData()
	self:update()
end
function InGameShop_ResetSearchText()
	local self  = inGameShop
	local search    = self._edit_Search:GetEditText()
	
	if  (nil == search) or (PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_SERACHWORD") == search) then
		self._edit_Search:SetEditText( "", true )
	end
end

function    InGameShop_CartToggle()
	local   self    = inGameShop
	if ( FGlobal_IsShow_IngameCashShop_NewCart() ) then
		FGlobal_Close_IngameCashShop_NewCart()
		InGameShop_TabEvent( self._currentTab )
	else
		if self._promotionWeb:GetShow() then
			self._promotionWeb:SetShow( false )
		end
		
		if Panel_IngameCashShop_GoodsDetailInfo:GetShow() then
			InGameShopDetailInfo_Close()
		end

		for ii = 0, self._tabCount  do
			_ingameCash_SetTabIconTexture( self._tabs[ii].icon, ii, 0 ) -- 컨트롤, 탭아이콘넘버, 상태
		end
		if not self._promotionTab.static:IsCheck() then
			_ingameCash_SetTabIconTexture( self._promotionTab.icon, 10, 0 )
		end
		if not self._myCartTab.static:IsCheck() then
			_ingameCash_SetTabIconTexture( self._myCartTab.icon, self._tabCount+2, 0 )
		else
			_ingameCash_SetTabIconTexture( self._myCartTab.icon, self._tabCount+2, 2 )
		end

		FGlobal_Open_IngameCashShop_NewCart()
		Panel_IngameCashShop:SetChildIndex(self._myCartTab.static, 9999 )
		self._scroll_IngameCash:SetShow( false )
	end
end

function    InGameShop_ScrollEvent( isUp )
	local   self        = inGameShop
	local   maxCount    = self._listCount - 1
	
	if  (isUp)  then
		self._position = self._position - self._config._slot._gapY
		if ( self._position < 0 ) then
			self._position = 0
		end
	else
		local listSize = self:getMaxPosition()
		if ( listSize < 0 ) then
			return
		end

		self._position = self._position + self._config._slot._gapY
		if ( listSize < self._position ) then
			self._position = listSize
		end
	end

	self._scroll_IngameCash:SetControlPos(self._position / self:getMaxPosition())
	self:update()
end

function InGameShop_ProductShowToolTip( productKeyRaw, uiIdx )
	local self      = inGameShop
	local slotIcon  = self._slots[uiIdx].icon
	FGlobal_CashShop_GoodsTooltipInfo_Open( productKeyRaw, slotIcon )
end

function InGameShop_ShowSimpleToolTip( isShow, buttonType )
	local self = inGameShop
	local name = ""
	local desc = ""
	local uiControl = nil
	local tabIdx = nil
	
	if 0 == buttonType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TOOLTIPS_PROMOTION") -- "프로모션"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TOOLTIPS_PROMOTION_DESC") -- "인기 상품을 정리한 페이지입니다."
		uiControl = self._promotionTab.static
		tabIdx = 10
	elseif 1 == buttonType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TOOLTIPS_MYCART") -- "장비구니"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_TOOLTIPS_MYCART_DESC") -- "플레이어가 선택하여 담은 상품이 모인 페이지입니다."
		uiControl = self._myCartTab.static
		tabIdx = 11
	end

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
		_inGameShop_TabOnOut_ChangeTexture( true, tabIdx )
	else
		TooltipSimple_Hide()
		_inGameShop_TabOnOut_ChangeTexture( false, tabIdx )
	end
end

function InGameShop_Promotion_Open()
	local self          = inGameShop
	local scrSizeX      = getScreenSizeX()
	local scrSizeY      = getScreenSizeY()

	Panel_IngameCashShop:SetChildIndex(self._promotionTab.static, 9999 ) 
	Panel_IngameCashShop:SetChildIndex(self._promotionTab.icon, 9999 ) 

	self._promotionWeb:SetPosX( 5 )
	self._promotionWeb:SetPosY( 5 )
	self._promotionWeb:SetSize( self._promotionWeb:GetSizeX(), self._promotionSizeY )
	self._promotionWeb:SetShow( true )
	
	self._scroll_IngameCash:SetShow( false )

	for ii = 0, self._tabCount  do
		_ingameCash_SetTabIconTexture( self._tabs[ii].icon, ii, 0 ) -- 컨트롤, 탭아이콘넘버, 상태
	end
	_ingameCash_SetTabIconTexture( self._promotionTab.icon, self._tabCount+1, 2 ) -- 컨트롤, 탭아이콘넘버, 상태

	if Panel_IngameCashShop_NewCart:GetShow() then
		FGlobal_Close_IngameCashShop_NewCart()
	end
end

function InGameShop_Promotion_Close()
	local self = inGameShop
	self._promotionWeb:SetShow( false )
	self._openFunction = false
end

function InGameShop_ProductListContent_ChangeTexture( slot, isSelected )
	slot.static:ChangeTextureInfoName( "new_ui_common_forlua/window/ingamecashshop/cashshop_01.dds" )
	local x1, y1, x2, y2 = 0, 0, 0, 0

	if true == isSelected then
		x1, y1, x2, y2 = setTextureUV_Func( slot.static, 193, 410, 268, 476 )
	else
		x1, y1, x2, y2 = setTextureUV_Func( slot.static, 47, 5, 122, 71 )
	end
	slot.static:getBaseTexture():setUV( x1, y1, x2, y2 )
	slot.static:setRenderTexture(slot.static:getBaseTexture())
end

function InGameShop_ProductListContent_ChangeMoneyIconTexture( slot, categoryIdx, isEnableSilver )
	local serviceContry = nil
	local iconType		= nil
	-- 국가에 따라, 캐시 아이콘을 달리 한다.
	if eCountryType.NONE == gameServiceType or eCountryType.DEV == gameServiceType or eCountryType.KOR_ALPHA == gameServiceType or eCountryType.KOR_REAL == gameServiceType or eCountryType.KOR_TEST == gameServiceType then
		serviceContry = contry.kr
	elseif eCountryType.JPN_ALPHA == gameServiceType or eCountryType.JPN_REAL == gameServiceType then
		serviceContry = contry.jp
	elseif eCountryType.RUS_ALPHA == gameServiceType or eCountryType.RUS_REAL == gameServiceType then
		serviceContry = contry.ru
	elseif eCountryType.CHI_ALPHA == gameServiceType or eCountryType.CHI_REAL == gameServiceType then
		serviceContry = contry.cn
	else
		serviceContry = contry.kr
	end

	-- 일단은 카테고리에 맞춰 출력한다.
	if UI_CCC.eCashProductCategory_Pearl == categoryIdx then
		iconType = cashIconType.cash
	elseif UI_CCC.eCashProductCategory_Mileage == categoryIdx then
		iconType = cashIconType.mileage
	else
		local isRussia		= ( isGameTypeRussia() or eCountryType.DEV == gameServiceType )
		local isFixedServer	= isServerFixedCharge()
		if true == isRussia and true == isFixedServer then
			if isEnableSilver then
				iconType = cashIconType.silver
			else
				iconType = cashIconType.pearl
			end
		else
			iconType = cashIconType.pearl
		end
	end
	cashIcon_changeTextureForList( slot.pearlIcon, serviceContry, iconType )
end

function HandleClicked_InGameShop_SetScrollIndexByLClick()
	local self      = inGameShop
	self._position	= self._scroll_IngameCash:GetControlPos() * self:getMaxPosition()
	self:update()
end

function FGlobal_InGameShop_IsSelectedSearchName()
	local self  = inGameShop
	local selectedEditControll = UI.getFocusEdit()

	return (nil ~= selectedEditControll) and (selectedEditControll:GetKey() == self._edit_Search:GetKey()) 
end

function FGlobal_InGameCashShop_GetSearchEdit()
	return inGameShop._edit_Search
end

function _ingameCash_SetTabIconTexture( control, tabIdx, status )
	local self = inGameShop
	control:ChangeTextureInfoName( "new_ui_common_forlua/window/ingamecashshop/CashShop_02.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( control, tabIconTexture[tabIdx][status][1], tabIconTexture[tabIdx][status][2], tabIconTexture[tabIdx][status][3], tabIconTexture[tabIdx][status][4] )
	control:getBaseTexture():setUV( x1, y1, x2, y2 )
	control:setRenderTexture(control:getBaseTexture())
end

function _inGameShop_TabOnOut_ChangeTexture( isOn, tabIdx )
	local self = inGameShop
	local control = nil

	if tabIdx < self._tabCount+1 then
		control = self._tabs[tabIdx]
	elseif self._tabCount+1 == tabIdx then
		control = self._promotionTab
	elseif self._tabCount+2 == tabIdx then
		control = self._myCartTab
	else
		return
	end

	local controlBeforState = not control.static:IsCheck()

	if isOn then
		_ingameCash_SetTabIconTexture( control.icon, tabIdx, 1 )    -- 컨트롤, 탭아이콘넘버, 상태
	else
		if controlBeforState then
			_ingameCash_SetTabIconTexture( control.icon, tabIdx, 0 )    -- 컨트롤, 탭아이콘넘버, 상태
		else
			_ingameCash_SetTabIconTexture( control.icon, tabIdx, 2 )    -- 컨트롤, 탭아이콘넘버, 상태
		end
	end
end

function FGlobal_InGameShop_UpdateByBuy()
	inGameShop:update()
end

function FGlobal_InGameShop_OpenByEventAlarm()
	ToClient_SaveUiInfo( true )
	if( isFlushedUI() ) then
		return
	end

	-- 상용화 체크
	if  ( not FGlobal_IsCommercialService() )   then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTUSE") ) --"아직 이용할 수 없습니다."
		return
	end
	
	if not IsSelfPlayerWaitAction() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_CASHSHOP") )
		return
	end
	
	if  ( Panel_IngameCashShop:GetShow() )  then
		return
	end
	
	if ( nil == getIngameCashMall() ) then
		return false
	end

	if ( getIngameCashMall():isShow() ) then
		return
	end

	if ( not getIngameCashMall():show() ) then
		return
	end
	
	audioPostEvent_SystemUi(01,39)
	--서버 요청
	--{ 
		if not isNaver then
			cashShop_requestCash()
		end
		cashShop_requestCashShopList()
	--}
	
	--{
		SetUIMode(Defines.UIMode.eUIMode_InGameCashShop)
		UI.flushAndClearUI()
	--}
	
	-- 창 오픈 시 효과음

	getIngameCashMall():clearEquipViewList()    -- 장비 슬롯에 착용하고 있는 것을 벗는다.
	getIngameCashMall():changeViewMyCharacter() -- 내 캐릭터를 세팅한다.

	local self              = inGameShop

	_ingameCashShop_SetViewListCount()  -- 가용 가능 세로 사이즈, 나올 수 있는 리스트 개수 구함.

	-- 미리보기
	--{
		cashShop_Controller_Open()
		FGlobal_CashShop_SetEquip_Open()
	--}
	
	-- 탭 초기화
	for ii = 0, self._tabCount  do
		self._tabs[ii].static:SetCheck( false )
	end

	self._openFunction = true
	self._static_Construction:ComputePos()
	self._static_Construction:SetShow( true )

	Panel_IngameCashShop:SetShow(true)

	-- self._promotionTab.static:SetCheck( true )
	self._scroll_IngameCash:SetShow( false )
	
	local scrSizeY      = getScreenSizeY()
	local categoryUrl   = ""
	local promotionUrl  = ""
	if isServerFixedCharge() then		-- 러시아 P2P(정액제)
		promotionUrl    = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_P2P")
		categoryUrl     = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_P2P")
	else
		promotionUrl    = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL")
		categoryUrl     = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL")
	end

	FGlobal_SetCandidate()

	self._categoryWeb:SetUrl( self._categoryWeb:GetSizeX(), self._categoryWeb:GetSizeY(), categoryUrl)
	self._categoryWeb:SetShow( true )
	self._categoryWeb:SetIME()

	self._promotionWeb:SetUrl( self._promotionWeb:GetSizeX(),  self._promotionSizeY , promotionUrl ) 
	self._promotionWeb:SetIME()

	self._openByEventAlarm = true
end

function FGlobal_InGameShop_OpenInventory()
	Inventory_SetFunctor( IngameCashShop_PearlBoxFilter, IngameCashShop_PearlBox_Open, nil, nil )
	InventoryWindow_Show( true, true )
end

function IngameCashShop_PearlBoxFilter( slotNo, itemWrapper, count, inventoryType )
	if itemWrapper:getStaticStatus():isPearlBox() then
		return false
	else
		return true
	end
	--[[
	local itemKey = itemWrapper:get():getKey():getItemKey()
	if 17051 <= itemKey and itemKey <= 17057 then   -- 펄상자.
		return false
	else
		return true
	end
	]]--
end

function IngameCashShop_PearlBox_Open( slotNo, itemWrapper, count, inventoryType )
	local doOpen = function()
		Inventory_UseItemTargetSelf( inventoryType, slotNo, nil )
		-- FGlobal_UpdateInventorySlotData()
	end

	local messageTitle  = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE") -- "알 림"
	local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_OPEN_PEARLBOX") -- "본 상품을 <PAColor0xFFFFCE22>개봉하면, 청약철회가 불가능<PAOldColor>합니다.\n사용하시겠습니까?"

	local messageBoxData = { title = messageTitle, content = messageBoxMemo, functionYes = doOpen, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

----------------------------------------------------------------------------------------------------
-- Cash Function
function	IngameCashShop_Descinit()
	local self = inGameShop.desc

	-- 그룹 상품 관련
	self._static_ItemNameCombo		= UI.getChildControl( inGameShop._goodDescBG, "Combobox_ItemNameByGroup"	)

	-- 상품 기본 정보
	self._staticText_Title			= UI.getChildControl( inGameShop._goodDescBG, "StaticText_GoodsTitle"		)
	self._static_SlotBG				= UI.getChildControl( inGameShop._goodDescBG, "Static_GoodsSlotBG"			)
	self._static_Slot				= UI.getChildControl( inGameShop._goodDescBG, "Static_GoodsSlot"			)
	self._static_Desc				= UI.getChildControl( inGameShop._goodDescBG, "StaticText_GoodsDesc"		)
	-- 상품 추가 정보
	self._staticText_PurchaseLimit	= UI.getChildControl( inGameShop._goodDescBG, "StaticText_PurchaseLimit"	)
	self._static_VestedDesc			= UI.getChildControl( inGameShop._goodDescBG, "StaticText_VestedDesc"		)
	self._static_TradeDesc			= UI.getChildControl( inGameShop._goodDescBG, "StaticText_TradeDesc"		)
	self._static_ClassDesc			= UI.getChildControl( inGameShop._goodDescBG, "StaticText_ClassDesc"		)
	self._static_WarningDesc		= UI.getChildControl( inGameShop._goodDescBG, "StaticText_WarningDesc"		)
	self._static_DiscountPeriodDesc	= UI.getChildControl( inGameShop._goodDescBG, "StaticText_DiscountPeriod"	)
	self._static_ItemListTitle		= UI.getChildControl( inGameShop._goodDescBG, "StaticText_ItemListTitle"	)
	self._static_RelatedItemTitle	= UI.getChildControl( inGameShop._goodDescBG, "StaticText_RelatedItemTitle"	)

	self._staticText_Title				:SetAutoResize( true )
	self._static_Desc					:SetAutoResize( true )
	
	self._staticText_Title				:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._static_Desc					:SetTextMode( UI_TM.eTextMode_AutoWrap )

	self._static_Desc					:SetFontColor( UI_color.C_FFC4A68A )
	self._staticText_PurchaseLimit		:SetFontColor( UI_color.C_FF748CAB )
	self._static_VestedDesc				:SetFontColor( UI_color.C_FF748CAB )
	self._static_TradeDesc				:SetFontColor( UI_color.C_FFF26A6A )
	self._static_ClassDesc				:SetFontColor( UI_color.C_FF999999 )
	self._static_WarningDesc			:SetFontColor( UI_color.C_FFF26A6A )
	self._static_DiscountPeriodDesc		:SetFontColor( UI_color.C_FF748CAB )
	
	-- 구성 아이템 목록
	--{
		local	itemConfig	= inGameShop._config._item
		for	ii = 0, inGameShop._itemCount-1	do
			local	slot		= {}
			slot.iconBG	= UI.createAndCopyBasePropertyControl( inGameShop._goodDescBG, "Static_ItemSlotBG",	self._static_ItemListTitle,	"InGameShopDetailInfo_Item_"		.. ii )
			slot.icon	= UI.createAndCopyBasePropertyControl( inGameShop._goodDescBG, "Static_ItemSlot",	slot.iconBG,				"InGameShopDetailInfo_Item_Icon_"	.. ii )
			
			-- 좌표 설정.
			--{
				slot.iconBG	:SetPosX( itemConfig._startX + itemConfig._gapX * ii )
				slot.iconBG	:SetPosY( itemConfig._startY )
			--}
			
			inGameShop._items[ii]	=	slot
		end
	--}


	-- 관련 아이템 목록
	--{
		-- local	itemConfig	= inGameShop._config._relatedItem
		-- for	ii = 0, inGameShop._itemCount-1	do
		-- 	local	slot		= {}
		-- 	slot.iconBG	= UI.createAndCopyBasePropertyControl( inGameShop._goodsDesc, "Static_RelatedItemSlotBG",	self._static_RelatedItemTitle,	"InGameShopDetailInfo_RelatedItem_"		.. ii )
		-- 	slot.icon	= UI.createAndCopyBasePropertyControl( inGameShop._goodsDesc, "Static_RelatedItemSlot",		slot.iconBG,				"InGameShopDetailInfo_RelatedItem_Icon_"	.. ii )
			
		-- 	-- 좌표 설정.
		-- 	--{
		-- 		slot.iconBG	:SetPosX( itemConfig._startX + itemConfig._gapX * ii )
		-- 		slot.iconBG	:SetPosY( itemConfig._startY )
		-- 		slot.icon	:SetPosX( 0 )
		-- 		slot.icon	:SetPosY( 0 )
		-- 	--}
			
		-- 	inGameShop._relatedItems[ii]	=	slot
		-- end
	--}
end

function	IngameCashShop_DescUpdate()
	local self = inGameShop.desc
	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( inGameShop._openProductKeyRaw )
	if	( nil == cashProduct )	then
		return
	end
	
	--초기화
	--{
		-- 구성 아이템
		for	ii = 0, inGameShop._itemCount-1	do
			local	slot	= inGameShop._items[ii]
			slot.iconBG:SetShow(false)
		end
	--}

	--{	구성 아이템
		local	itemCount	= cashProduct:getItemListCount()
		local	itemConfig	= inGameShop._config._relatedItem

		if itemCount < 10 then
			itemConfig._startX	= 0
			itemConfig._gapX	= 35
		else
			itemConfig._startX	= -7
			itemConfig._gapX	= 33
		end
		
		for ii = 0, itemCount - 1 do
			local	slot		= inGameShop._items[ii]
			local	item		= cashProduct:getItemByIndex( ii )
			local	itemCount	= cashProduct:getItemCountByIndex( ii )
			local	itemGrade	= item:getGradeType()

			slot.iconBG	:SetPosX( itemConfig._startX + itemConfig._gapX * ii )
			slot.iconBG	:SetPosY( itemConfig._startY )
			
			slot.icon	:ChangeTextureInfoName( "icon/" .. item:getIconPath() )
			slot.icon	:SetText( tostring(itemCount) )
			slot.icon	:addInputEvent( "Mouse_On", "InGameShop_ShowItemToolTip( true, " .. ii .. " )" )
			slot.icon	:addInputEvent( "Mouse_Out", "InGameShop_ShowItemToolTip( false, " .. ii .. " )" )
			slot.iconBG	:SetShow(true)
		end
	--}

	--{ 관련 아이템
		-- local	relatedItemCount	= cashProduct:getCashRelatedCount()
		-- if 0 < relatedItemCount then
		-- 	for ii = 0, relatedItemCount - 1 do
		-- 		local	slot		= inGameShop._relatedItems[ii]
		-- 		local	item		= cashProduct:getCashRelatedItemByIndex( ii )
		-- 		slot.icon	:ChangeTextureInfoName( "icon/" .. item:getIconPath() )
		-- 		slot.iconBG	:SetShow(true)
		-- 	end
			self._static_RelatedItemTitle:SetShow( false )
		-- end
	--}

	--{
		local	descCount	= 0
		local	descConfig	= inGameShop._config._desc
		
		self._static_VestedDesc			:SetShow( false )
		self._static_TradeDesc			:SetShow( false )
		self._static_ClassDesc			:SetShow( false )
		self._static_WarningDesc		:SetShow( false )
		self._static_DiscountPeriodDesc	:SetShow( false )
		
		self._static_Slot				:ChangeTextureInfoName( "Icon/" .. cashProduct:getIconPath() )

		self._staticText_Title			:SetText( cashProduct:getName() )
		self._static_Desc				:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_STATIC_DESC", "getDes", cashProduct:getDescription() ) )-- "- 상품 설명 : " .. cashProduct:getDescription() 
		-- self._static_Price				:SetText( makeDotMoney(cashProduct:getPrice()) )

		local list				= self._static_ItemNameCombo:GetListControl()
		local _scroll			= list:GetScroll()
		local listCount			= list:GetItemQuantity()
		local listTotalCount	= list:GetItemSize()

		if listCount <= listTotalCount then
			_scroll:SetShow( true )
		else
			_scroll:SetShow( false )
		end

		-- 상품 카테고리에 따라 펄 아이콘을 변경.
		InGameShop_ProductInfo_ChangeMoneyIconTexture( cashProduct:getCategory(), cashProduct:isMoneyPrice() )

		local optionDesc_PosY = descConfig._startY + self._static_Desc:GetTextSizeY() + 35	-- desc 길이에 따른 대응

		-- 구매 횟수 제한
		self._staticText_PurchaseLimit	:SetShow( false )
		local limitType		= cashProduct:getCashPurchaseLimitType()
		if UI_PLT.None ~= limitType then
			local limitCount	= cashProduct:getCashPurchaseCount()
			local mylimitCount	= getIngameCashMall():getRemainingLimitCount( inGameShop._openProductKeyRaw )
			local typeString = ""
			if UI_PLT.AtCharacter == limitType then
				typeString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_CHARACTER") -- "캐릭터"
			elseif UI_PLT.AtAccount == limitType then
				typeString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_FAMILY") -- "가문"
			end
			self._staticText_PurchaseLimit	:SetText( PAGetStringParam3( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_PURCHASELIMIT", "typeString", typeString, "limitCount", limitCount, "mylimitCount", mylimitCount ) )-- "- 구입 제한 : " .. typeString .. " 당 " .. limitCount .. "개(" .. mylimitCount .."개 남음)" 
			self._staticText_PurchaseLimit:SetFontColor( UI_color.C_FFF26A6A )	-- 붉은색
			
			self._staticText_PurchaseLimit	:SetShow( true )
			self._staticText_PurchaseLimit	:SetPosY( optionDesc_PosY + descConfig._gapY * descCount )
			descCount	= descCount + 1
		end

		local	vestedDesc	= IngameShopDetailInfo_ConvertFromCategoryToVestedDesc( cashProduct )
		if(	nil ~= vestedDesc )	then
			self._static_VestedDesc:SetText(vestedDesc)
			self._static_VestedDesc:SetShow(true)
			
			self._static_VestedDesc:SetPosY( optionDesc_PosY + descConfig._gapY * descCount)
			descCount	= descCount + 1
		end
		
		local	tradeDesc	= IngameShopDetailInfo_ConvertFromCategoryToTradeDesc( cashProduct )
		if(	nil ~= tradeDesc )	then
			self._static_TradeDesc	:SetText(tradeDesc)
			self._static_TradeDesc	:SetShow(true)
			self._static_TradeDesc	:SetPosY( optionDesc_PosY + descConfig._gapY * descCount)
			descCount	= descCount + 1
		end
	
		local	classDesc	= IngameShopDetailInfo_ConvertFromCategoryToClassDesc( cashProduct )
		if(	nil ~= classDesc )	then
			self._static_ClassDesc	:SetText(classDesc)
			self._static_ClassDesc	:SetShow(true)
			self._static_ClassDesc	:SetPosY( optionDesc_PosY + descConfig._gapY * descCount)
			descCount	= descCount + 1
		end
		
		-- 세일기간이면 끝나는 날짜만 보여준다.
		if ( cashProduct:isApplyDiscount() ) then
			local	startDiscountTimeValue	= PATime( cashProduct:getStartDiscountTime():get_s64() )
			local	endDiscountTimeValue	= PATime( cashProduct:getEndDiscountTime():get_s64() )
			local	startDiscountTime		= tostring( startDiscountTimeValue:GetYear() )	.. "." .. tostring( startDiscountTimeValue:GetMonth() ) .. "." .. tostring( startDiscountTimeValue:GetDay()	)
			local	endDiscountTime			= PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring( endDiscountTimeValue:GetYear() ), "GetMonth", tostring( endDiscountTimeValue:GetMonth() ), "GetDay", tostring( endDiscountTimeValue:GetDay())) .. " " .. string.format( "%.02d", endDiscountTimeValue:GetHour() ) .. ":" .. string.format( "%.02d", endDiscountTimeValue:GetMinute() ) -- tostring( endDiscountTimeValue:GetYear() )	.. "년" .. tostring( endDiscountTimeValue:GetMonth() )	.. "월" .. tostring( endDiscountTimeValue:GetDay() .. "일 "
			if (true == disCountSetUse) then
				endDiscountTime = convertStringFromDatetime(cashProduct:getRemainDiscountTime())
			else
				endDiscountTime = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring( endDiscountTimeValue:GetYear() ), "GetMonth", tostring( endDiscountTimeValue:GetMonth() ), "GetDay", tostring( endDiscountTimeValue:GetDay())) .. " " .. string.format( "%.02d", endDiscountTimeValue:GetHour() ) .. ":" .. string.format( "%.02d", endDiscountTimeValue:GetMinute() )
			end
			self._static_DiscountPeriodDesc:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTPERIODDESC", "endDiscountTime", endDiscountTime) )-- "<PAColor0xfface400>- 할인 기간 : " .. endDiscountTime .. "까지<PAOldColor>"
			self._static_DiscountPeriodDesc:SetShow( true )
			self._static_DiscountPeriodDesc:SetPosY( optionDesc_PosY + descConfig._gapY * descCount)

			-- self._static_Price				:SetText( "<PAColor0xFF626262>" .. makeDotMoney(cashProduct:getOriginalPrice()) .. "<PAOldColor> <PAColor0xffefefef>→ " .. makeDotMoney(cashProduct:getPrice()) .. "<PAOldColor>" )

			descCount	= descCount + 1
		end

		self._static_ItemListTitle		:SetPosY( (optionDesc_PosY + descConfig._gapY * descCount) )
		descCount	= descCount + 1
		optionDesc_PosY = optionDesc_PosY + inGameShop._items[0].iconBG:GetSizeY() + 20	-- 패키지 아이템 사이즈를 더해야 한다.
		inGameShop.itemDescDetailSize = optionDesc_PosY + descConfig._gapY * descCount

		inGameShop._maxDescSize = inGameShop.itemDescDetailSize
		-- self._static_PiceBG				:SetPosY( (optionDesc_PosY + descConfig._gapY * descCount) )
		-- descCount	= descCount + 1
		-- optionDesc_PosY = optionDesc_PosY + 15										-- 펄 배경 높이를 더해야 한다.

		-- if self._static_RelatedItemTitle:GetShow() then
		-- 	self._static_RelatedItemTitle	:SetPosY( (optionDesc_PosY + descConfig._gapY * descCount) )
		-- 	descCount	= descCount + 1
		-- end
	--}
	
	--크기 및 사이즈 조절
	--{
		-- Panel_IngameCashShop_GoodsDetailInfo:SetSize( Panel_IngameCashShop_GoodsDetailInfo:GetSizeX(), panel_SizeY )
	--}
end

function	IngameCashShop_initDescData()
	local self = inGameShop.desc
	inGameShop._comboList		= Array.new()
	inGameShop._listComboCount	= 1
	local	count		= getIngameCashMall():getCashProductStaticStatusListCount()
	for ii=0, count -1 do
		local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByIndex(ii)
		if	nil ~= cashProduct	then
			if	IngameCashShop_filterData( cashProduct )	then
				inGameShop._comboList[inGameShop._listComboCount]	= cashProduct:getNoRaw()
				inGameShop._listComboCount		= inGameShop._listComboCount + 1
			end
		end
	end
	
	IngameCashShop_sortData()
	
	self._static_ItemNameCombo:DeleteAllItem()
	self._static_ItemNameCombo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_ITEMNAMECOMBO") )-- "선택 옵션이 없습니다."
	self._static_ItemNameCombo:SetMonoTone( true )
	self._static_ItemNameCombo:SetEnable( false )
	
	for ii=inGameShop._listComboCount-1, 0, -1 do
		local subProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( inGameShop._comboList[ii] )
		if	( nil ~= subProduct )	then
			self._static_ItemNameCombo:AddItemWithKey( subProduct:getName(), subProduct:getNoRaw() )
			self._static_ItemNameCombo:SetMonoTone( false )
			self._static_ItemNameCombo:SetEnable( true )
		end
	end

	if	( 0 < count )	then
		self._static_ItemNameCombo:SetSelectItemIndex( 0 )
	end
end

function	IngameCashShop_filterData( cashProduct )
	local self = inGameShop
	if	( not CheckCashProduct(cashProduct) )	then
		return(false)
	end
	
	local	currentCashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._openProductKeyRaw )
	if	( nil == currentCashProduct )	then
		return(false)
	end
		
	-- OfferGroup
	if	( 0 == cashProduct:getOfferGroup() )	then
		return(false)
	end
	
	if	( cashProduct:getOfferGroup() ~= currentCashProduct:getOfferGroup() )	then
		return(false)
	end
	
	return(true)
end

function	IngameCashShop_SortCash( lhs, rhs )
	local	self	= inGameShop
	local	lhsNo	= nil
	local	rhsNo	= nil
		
	local	lhsWrapper	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( lhs )
	if	( nil ~= lhsWrapper )	then
		lhsNo		= lhsWrapper:getNoRaw()
	end
	
	local	rhsWrapper	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( rhs )
	if	( nil ~= rhsWrapper )	then
		rhsNo		= rhsWrapper:getNoRaw()
	end
	
	return( lhsNo > rhsNo )
end

function	IngameCashShop_sortData()
	local self = inGameShop
	table.sort( self._comboList, IngameCashShop_SortCash )
end

function HandleClicked_IngameCashShop_ShowSubList()
	local self	= inGameShop.desc
	Panel_IngameCashShop:SetChildIndex(self._static_ItemNameCombo, 9999 )

	local list	= self._static_ItemNameCombo:GetListControl()
	self._static_ItemNameCombo:ToggleListbox()
end

function HandleClicked_IngameCashShop_SelectedSubList()
	local	self		= inGameShop.desc
	local	selectIndex	= self._static_ItemNameCombo:GetSelectIndex()
	local	selectKey	= self._static_ItemNameCombo:GetSelectKey()


	if -1 == selectIndex then
		return
	end
	inGameShop._openProductKeyRaw		= selectKey
	-- inGameShop._selectIndex				= selectIndex
	self._static_ItemNameCombo:SetSelectItemIndex( selectIndex )
	-- IngameCashShop_initDescData()
	IngameCashShop_DescUpdate()
	-- FGlobal_InGameSHopDetailInfo_Open( selectKey, selectIndex )
end

function InGameShop_ShowItemToolTip( isShow, index )
	local self			= inGameShop
	if true == isShow then
		local cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._openProductKeyRaw )
		local itemWrapper	= cashProduct:getItemByIndex( index )
		local slotIcon		= self._items[index].icon
		Panel_Tooltip_Item_Show( itemWrapper, slotIcon, true, false, nil )
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

function    IngameCashShop_SelectedItem( index )
	local   self    = inGameShop
	local   slot    = self._slots[index]

	local prevIndex = -1

	if self._openProductKeyRaw == slot.productNoRaw then
		return
	end
	audioPostEvent_SystemUi(01,00)
	IngameCashShop_SelectedItemXXX(slot.productNoRaw, false)
end
	
function    IngameCashShop_SelectedItemXXX( productNoRaw, isForcePositionSet )
	local   self    = inGameShop
	local   cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw( productNoRaw )
	if  ( nil == cashProduct )  then
		return
	end

	local	prevPos			= 0
	local 	prevKeyRaw		= self._openProductKeyRaw

	for ii = 0, self._listCount - 1 do
		local   productNoRawInList= self._list[ii+1]

		if ( self:isSelectProductGroup(productNoRaw) or productNoRawInList == productNoRaw ) then
			prevPos = prevPos - self._position
			break
		end

		if ( self:isSelectProductGroup(productNoRawInList) ) then
			prevPos = prevPos + self._goodDescBG:GetSizeY()
		end

		prevPos = prevPos + self._config._slot._gapY
	end	

	
	self._openProductKeyRaw = productNoRaw -- 배경 변경을 위해
	self._goodDescBG:SetShow(true)
	IngameCashShop_initDescData()
	if ( isForcePositionSet ) then
		local	pos				= 0
	
		for ii = 0, self._listCount - 1 do
			local   productNoRaw= self._list[ii+1]

			if ( self:isSelectProductGroup(productNoRaw) ) then
				if ( 100 < pos ) then
					pos = pos - 100
				end
				if ( prevPos < pos ) then
					pos = pos - self._goodDescBG:GetSizeY()
				end

				self._position = pos
				self._currentPos = self._position

				self._scroll_IngameCash:SetControlPos(self._position / self:getMaxPosition())
				break
			end
	
			pos = pos + self._config._slot._gapY
		end	
	else
		local	pos				= 0
	
		for ii = 0, self._listCount - 1 do
			local   productNoRaw= self._list[ii+1]

			if ( self:isSelectProductGroup(productNoRaw) ) then

				if ( -1 == prevKeyRaw ) then
					break
				end

				
				pos = pos - prevPos

				local listSize = self:getMaxPosition()
				if ( listSize < 0 ) or ( pos < 0 ) then
					self._position = 0
				else
					self._position = pos

					if ( listSize < self._position ) then
						self._position = listSize
					end

					self._currentPos = self._position

					self._scroll_IngameCash:SetControlPos(self._position / self:getMaxPosition())
				end
				break
			end
	
			pos = pos + self._config._slot._gapY
		end	
	end

	self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
	IngameCashShop_DescUpdate()

	-- FGlobal_InGameSHopDetailInfo_Open( productNoRaw, 0 )
	FGlobal_CashShop_SetEquip_Update( productNoRaw )
	self:update()
end

function FGlobal_IngameCashShop_SelectedItemReset()
	local   self    = inGameShop
	self._openProductKeyRaw = -1
	self._goodDescBG:SetShow(false)
	self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
	local listSize = self:getMaxPosition()
	if ( self._static_ScrollArea:GetSizeY() <= listSize ) and ( listSize < self._currentPos ) then
		self._position = self:getMaxPosition()
		self._scroll_IngameCash:SetControlPos(1)
	end
	self:update()
end

function FGlobal_Update_IngameCashShop_CartEffect()
	local   self    = inGameShop
	-- 장바구니 작업
	self._myCartTab.static:EraseAllEffect()
	self._myCartTab.static:AddEffect("UI_CashShop_BasketButton", false, 0, 0)
end

function    IngameCashShop_CartItem( index )
	local   self    = inGameShop
	local   slot    = self._slots[index]

	local tempSaveProductKeyRaw = slot.productNoRaw
	if ( -1 ~= inGameShop._openProductKeyRaw ) then
		if (inGameShop._openProductKeyRaw == slot.productNoRaw) then
			tempSaveProductKeyRaw = slot.productNoRaw
		else
			if ( self:isSelectProductGroup(slot.productNoRaw) ) then
				tempSaveProductKeyRaw = self._openProductKeyRaw
			else
				tempSaveProductKeyRaw = slot.productNoRaw
			end
		end
	else
		tempSaveProductKeyRaw = slot.productNoRaw
	end

	local   cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(tempSaveProductKeyRaw)
	if  ( nil == cashProduct )  then
		return
	end
	if ( false == getIngameCashMall():checkPushableInCart( tempSaveProductKeyRaw, 1) ) then
		return
	end

	local doAnotherClassItem = function()
		Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_ACK", "getName", cashProduct:getName()) )-- cashProduct:getName() .. " 상품이 장바구니에 담겼습니다." )
		FGlobal_PushCart_IngameCashShop_NewCart( tempSaveProductKeyRaw, 1)
		return
	end

	-- { 직업 비교 처리.
		if cashProduct:doHaveDisplayClass() and not cashProduct:isClassTypeUsable(getSelfPlayer():getClassType()) then
			local messageBoxTitle   = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_ALERT") -- "알  림"
			local messageBoxMemo    = "<PAColor0xffd0ee68>[" .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_MATHCLASS") .. "]\n" .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_MSGMEMO", "getName", cashProduct:getName() ) -- cashProduct:getName() .. " 상품<PAOldColor>을 장바구니에 담으시겠습니까?"
			messageBoxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = doAnotherClassItem, functionNo = _InGameShopBuy_Confirm_Cancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData)
		else
			Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_ACK", "getName", cashProduct:getName()) )-- cashProduct:getName() .. " 상품이 장바구니에 담겼습니다." )
			FGlobal_PushCart_IngameCashShop_NewCart( tempSaveProductKeyRaw, 1)
		end
	-- }
end

function    IngameCashShop_GiftItem( index )
	local   self    = inGameShop
	local   slot    = self._slots[index]
	local selfplayer	= getSelfPlayer()
	if nil == selfplayer then
		return
	end
	local limitLevel = 30
	local myLevel = selfplayer:get():getLevel()
	if myLevel < limitLevel and isGameTypeEnglish() then	-- 북미일 경우 신용카드 도용으로 선물하기 문제가 있어서 레벨 제한을 둔다.
		Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_LIMIT_20LEVEL", "level", limitLevel ) ) -- "20레벨부터 선물하기가 가능합니다.")
		return
	end


	local   cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(slot.productNoRaw)
	if  ( nil == cashProduct )  then
		return
	end
	local tempSaveProductKeyRaw = slot.productNoRaw
	if ( -1 ~= inGameShop._openProductKeyRaw ) then
		if (inGameShop._openProductKeyRaw == slot.productNoRaw) then
			tempSaveProductKeyRaw = slot.productNoRaw
		else
			if ( self:isSelectProductGroup(slot.productNoRaw) ) then
				tempSaveProductKeyRaw = self._openProductKeyRaw
			else
				tempSaveProductKeyRaw = slot.productNoRaw
			end
		end
	else
		tempSaveProductKeyRaw = slot.productNoRaw
	end
	FGlobal_InGameShopBuy_Open( tempSaveProductKeyRaw, true )
end

function    IngameCashShop_BuyItem( index )
	local   self    = inGameShop
	local   slot    = self._slots[index]
	
	local   cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(slot.productNoRaw)
	if  ( nil == cashProduct )  then
		return
	end

	local tempSaveProductKeyRaw = slot.productNoRaw
	if ( -1 ~= inGameShop._openProductKeyRaw ) then
		if (inGameShop._openProductKeyRaw == slot.productNoRaw) then
			tempSaveProductKeyRaw = slot.productNoRaw
		else
			if ( self:isSelectProductGroup(slot.productNoRaw) ) then
				tempSaveProductKeyRaw = self._openProductKeyRaw
			else
				tempSaveProductKeyRaw = slot.productNoRaw
			end
		end
	else
		tempSaveProductKeyRaw = slot.productNoRaw
	end

	local isPearlTab		= (0 == self._currentTab)
	if true == isPearlTab and true == isKorea and true == isNaver then	-- 네이버 링크를 띄운다.
		local naverLink = "http://black.game.naver.com/black/billing/shop/index.daum"
		ToClient_OpenChargeWebPage( naverLink, true )
	else
		FGlobal_InGameShopBuy_Open( tempSaveProductKeyRaw, false )
	end
end


----------------------------------------------------------------------------------------------------
-- Combo List
function    InGameShop_OpenClassList()
	local   self    = inGameShop
	local   list    = self._combo_Class:GetListControl()

	audioPostEvent_SystemUi(00,00)
	self._combo_Class:ToggleListbox()
end

function    InGameShop_SelectClass()
	local   self        = inGameShop
	local   selectIndex = self._combo_Class:GetSelectIndex()
	if -1 == selectIndex then
		return
	end

	self._goodDescBG:SetShow( false )
	
	if  ( getCharacterClassCount() == self._combo_Class:GetSelectKey() and 0 == self._combo_Class:GetSelectIndex() )    then
		self._currentClass  = nil
	else
		self._currentClass  = self._combo_Class:GetSelectKey()
	end

	audioPostEvent_SystemUi(00,00)
	self._combo_Class:SetSelectItemIndex( selectIndex )

	self._currentPos = 0
	self._position = 0
	self._scroll_IngameCash:SetControlPos(0)
	self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
	self:initData()
	self:update()
end

function    InGameShop_OpenSorList()
	local   self    = inGameShop
	local   list    = self._combo_Sort:GetListControl()

	audioPostEvent_SystemUi(00,00)
	self._combo_Sort:ToggleListbox()
end

function    InGameShop_SelectSort()
	local   self        = inGameShop
	local   selectIndex = self._combo_Sort:GetSelectIndex()
	if -1 == selectIndex then
		return
	end
	self._goodDescBG:SetShow( false )
	audioPostEvent_SystemUi(00,00)
	self._combo_Sort:SetSelectItemIndex( selectIndex )
	if  ( 0 == self._combo_Sort:GetSelectKey() )    then
		self._currentSort   = nil
	else
		self._currentSort   = self._combo_Sort:GetSelectKey()
	end 
	
	self._currentPos = 0
	self._position = 0
	self._scroll_IngameCash:SetControlPos(0)
	self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
	self:initData()
	self:update()
end

function InGameShop_OpenSubFilterList()
	local   self    = inGameShop
	local   list    = self._combo_SubFilter:GetListControl()

	audioPostEvent_SystemUi(00,00)
	self._combo_SubFilter:ToggleListbox()
end
function InGameShop_SelectSubFilter()
	local   self        = inGameShop
	local   selectIndex = self._combo_SubFilter:GetSelectIndex()
	if -1 == selectIndex then
		return
	end
	self._goodDescBG:SetShow( false )
	audioPostEvent_SystemUi(00,00)
	self._combo_SubFilter:SetSelectItemIndex( selectIndex )
	if  ( 0 == self._combo_SubFilter:GetSelectKey() )    then
		self._currentSubFilter   = nil
	else
		self._currentSubFilter   = self._combo_SubFilter:GetSelectKey()
	end 
	
	self._currentPos = 0
	self._position = 0
	self._scroll_IngameCash:SetControlPos(0)
	self._goodDescBG:SetSize(self._goodDescBG:GetSizeX(), 1)
	self:initData()
	self:update()
end


----------------------------------------------------------------------------------------------------
-- From Client
function    InGameShop_UpdateCashShop()
	-- 전체 탭 보여주기
	local self = inGameShop
	self._static_Construction:SetShow( false )

	if self._openByEventAlarm then
		InGameShop_TabEvent( 1 )
	else
		InGameShop_TabEvent( self._tabCount )
		Panel_IngameCashShop:SetChildIndex(self._promotionTab.static, 9999 ) 	-- 처음 열릴 때는 프로모션이 가장 위여야 한다.
	end
end

function    InGameShop_UpdateCash()
	local   self        = inGameShop
	local   cash, pearl, mileage, money = self:updateMoney()

	return cash, pearl, mileage, money
end

function    InGameShop_OuterEventByAttacked()
	
	-- 데미지 받을때만다 들어온다. 캐시샵이 열려있을때만 닫게 한다.
	if( Panel_IngameCashShop:GetShow() ) then
		InGameShop_Close()
	end
	
end

function    InGameShop_OuterEventForDead()
	InGameShop_Close()
end



----------------------------------------------------------------------------------------------------
-- Window Resize
function    InGameShop_Resize()
	local self          = inGameShop
	local slotConfig    = self._config._slot
	local tabConfig     = self._config._tab
	local scrSizeX      = getScreenSizeX()
	local scrSizeY      = getScreenSizeY()
	local panelSizeX    = Panel_IngameCashShop:GetSizeX()
	local panelSizeY    = Panel_IngameCashShop:GetSizeY()
	
	Panel_IngameCashShop        :SetPosX( 40 )
	-- Panel_IngameCashShop     :SetPosY( (scrSizeY/2) - (panelSizeY/2) - 55 )
	Panel_IngameCashShop        :SetPosY( 0 )
	Panel_IngameCashShop        :SetSize( Panel_IngameCashShop:GetSizeX(), scrSizeY )
	self._static_SideLineLeft   :SetSize( self._static_SideLineLeft:GetSizeX(), scrSizeY )
	self._static_SideLineRight  :SetSize( self._static_SideLineRight:GetSizeX(), scrSizeY )

	-- self._button_BuyAll              :ComputePos()
	-- self._button_CartClose           :ComputePos()
	self._staticText_CashCount      :ComputePos()
	self._staticText_PearlCount     :ComputePos()
	self._staticText_SilverCount	:ComputePos()
	self._staticText_MileageCount   :ComputePos()
	self._haveCashBoxBG             :ComputePos()
	self._pearlBox                  :ComputePos()
	self._nowPearlIcon              :ComputePos()
	self._btn_BuyPearl              :ComputePos()
	self._silverBox					:ComputePos()
	self._silver					:ComputePos()
	self._mileageBox                :ComputePos()
	self._mileage                   :ComputePos()

	self._cashBox                   :ComputePos()
	self._nowCash                   :ComputePos()
	self._btn_BuyDaum               :ComputePos()
	self._btn_RefreshCash           :ComputePos()

	-- { 네이버면 끈다
		if true == isKorea and true == isNaver then
			self._staticText_CashCount      :SetShow( false )
			self._cashBox                   :SetShow( false )
			self._nowCash                   :SetShow( false )
			self._btn_BuyDaum               :SetShow( false )
			self._btn_RefreshCash           :SetShow( false )
		end
	-- }

	-- 탭위치
	tabConfig._startY = self._promotionTab.static:GetPosY() + self._promotionTab.static:GetSizeY() - 20     -- 다른 탭
	self._myCartTab.static:SetPosY( tabConfig._startY + ( tabConfig._gapY * (self._tabCount-1) ) + tabConfig._gapY )                -- 카트 탭
	-- 장바구니 위치 강제 줄임. 원본 : tabConfig._startY + ( tabConfig._gapY * self._tabCount ) + tabConfig._gapY 

	local remainingSizeY = _ingameCashShop_SetViewListCount()   -- 가용 가능 세로 사이즈, 나올 수 있는 리스트 개수 구함.

	-- 하단 그라데이션 배경 위치
	self._static_GradationBottom:SetPosX( slotConfig._startX )
	self._static_GradationBottom:SetPosY( self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY()-50 )

	-- 스크롤 및 스크롤 영역 크기
	self._scroll_IngameCash:SetSize( self._scroll_IngameCash:GetSizeX(), ( remainingSizeY*0.98 ) )
	self._static_ScrollArea:SetSize( self._static_ScrollArea:GetSizeX(), ( remainingSizeY*0.98 ) )
	self._static_ScrollArea1:SetPosY(0)
	self._static_ScrollArea1:SetSize(self._static_ScrollArea1:GetSizeX(), self._static_ScrollArea:GetPosY())
	self._static_ScrollArea2:SetPosY(self._static_ScrollArea:GetPosY() + self._static_ScrollArea:GetSizeY())
	self._static_ScrollArea2:SetSize(self._static_ScrollArea2:GetSizeX(), 1000)

	-- 카트 위치와 크기
	local cartPosX = Panel_IngameCashShop:GetPosX() + slotConfig._startX
	local cartPosY = Panel_IngameCashShop:GetPosY() + slotConfig._startY
	FGlobal_InitPos_IngameCashShop_NewCart( cartPosX, cartPosY, remainingSizeY, ( self._static_TopLineBG:GetSizeY() + self._haveCashBoxBG:GetSpanSize().y ) )
	
	-- 프로모션 배너 
	self._promotionWeb:SetSize( self._promotionWeb:GetSizeX(), self._promotionSizeY )
	self._static_GradationTop:SetPosX( slotConfig._startX )
	self._static_GradationTop:SetPosY( slotConfig._startY )
		
	self._static_GradationBottom:SetPosX( slotConfig._startX )
	self._static_GradationBottom:SetPosY( self._static_ScrollArea:GetSizeY() + self._static_ScrollArea:GetPosY() - self._static_GradationBottom:GetSizeY() )

	-- Panel_IngameCashShop:SetChildIndex(self._static_GradationTop, 8888 )
	-- Panel_IngameCashShop:SetChildIndex(self._static_GradationBottom, 8888 )
	Panel_IngameCashShop:SetChildIndex(self._promotionWeb, 9999 ) 
end

function _ingameCashShop_SetViewListCount()
	local self              = inGameShop
	local scrSizeY          = getScreenSizeY()
	local areaPosY			= self._static_ScrollArea:GetPosY()

	local banner            = self._static_PromotionBanner:GetPosY() + self._static_PromotionBanner:GetSizeY()
																						-- 프로모션 배너까지
	local bannerEndGap      = ( self._static_TopLineBG:GetPosY() - (self._static_PromotionBanner:GetPosY() + self._static_PromotionBanner:GetSizeY()) )                                         -- 프로모션 배너 끝에서 필터 시작 사이
	local filterFize        = self._static_TopLineBG:GetSizeY() + ( self._static_TopLineBG:GetPosY() - (self._static_PromotionBanner:GetPosY() + self._static_PromotionBanner:GetSizeY()) )     -- 필터 크기
	local endGap            = areaPosY - ( self._static_TopLineBG:GetPosY() + self._static_TopLineBG:GetSizeY() )									                                            -- 충전 영역 전과 리스트 마지막 사이 간격
	local chargeSize        = ( (self._haveCashBoxBG:GetSpanSize().y ) + self._haveCashBoxBG:GetSizeY() )                                                                                       -- 충전 BG 시작부터 끝까지

	local fixedHeight       = banner + bannerEndGap + filterFize + endGap + chargeSize

	self._promotionSizeY    = scrSizeY - endGap - chargeSize - self._static_PromotionBanner:GetPosY()   -- 프로모션 페이지 사이즈.
	
	local gapBetweenList    = self._config._slot._gapY
	local remainingSizeY    = scrSizeY - fixedHeight

	local possiableList     = math.floor( remainingSizeY / gapBetweenList )

	self._slotCount = possiableList + 1

	return remainingSizeY
end

local cumulatedTime = 0
function InGameCashshopUpdatePerFrame( deltaTime )
	if (true == disCountSetUse) then
		cumulatedTime = cumulatedTime + deltaTime 
		if( 1.0 < cumulatedTime ) then
			cumulatedTime = 0
			CashShopUpdateRamainedTimePerSecond()
		end
	end

	InGameCashshopDescUpdate( deltaTime )
end
-- 북미 전용 함수.
function CashShopUpdateRamainedTimePerSecond()
	local self = inGameShop
	local   cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._openProductKeyRaw)
	if nil == cashProduct then
		return
	end
	local	itemCount	= cashProduct:getItemListCount()
	for ii = 0, itemCount - 1 do
		local remainTime = cashProduct:getRemainDiscountTime()

		if cashProduct:isApplyDiscount() then
			self.desc._static_DiscountPeriodDesc:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTPERIODDESC", "endDiscountTime", convertStringFromDatetime(remainTime)) )
		end
	end

end


function InGameCashshopDescUpdate( deltaTime )
	local self = inGameShop

	if ( self._position == self._currentPos ) and (self._maxDescSize == self._goodDescBG:GetSizeY()) then
		return
	end

	self._currentPos = self._currentPos + (self._position - self._currentPos) * deltaTime * 15

	if ( math.abs(self._position - self._currentPos) < 1 ) then
		self._currentPos = self._position
	end

	if ( -1 ~= self._openProductKeyRaw ) then
		self._goodDescBG:SetSize( self._goodDescBG:GetSizeX(), self._goodDescBG:GetSizeY() + ( self._maxDescSize - self._goodDescBG:GetSizeY() ) * deltaTime * 3)
		if ( self._maxDescSize - self._goodDescBG:GetSizeY() < 1 ) then
			self._goodDescBG:SetSize( self._goodDescBG:GetSizeX(), self._maxDescSize )
		end
		
	end

	self:updateSlot()
	-- if ( self._goodDescBG:GetShow() ) then
	-- 	IngameCashShop_DescUpdate()
	-- 	for _, control in pairs( inGameShop.desc ) do
	-- 		if ( control:GetShow() ) then
	-- 			control:SetShow( control:GetPosY() + control:GetSizeY() < self._goodDescBG:GetSizeY() )
	-- 		end
	-- 	end
	-- end

	for _, control in pairs( inGameShop.desc ) do
		-- IngameCashShop_Descinit()
		control:SetShow( control:GetPosY() + control:GetSizeY() < self._goodDescBG:GetSizeY() )
		IngameCashShop_DescUpdate()
	end
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
function    InGameShop_Open()
	ToClient_SaveUiInfo( true )
	if( isFlushedUI() ) then
		return
	end
	-- FGlobal_IngameCashShop_SelectedItemReset()
	local terraintype = selfPlayerNaviMaterial()	-- 물이나 공중에서 열 수 없다.
	if 8 == terraintype or 9 == terraintype then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DONTOPEN_INWATER") ) -- "물 속에서 이용할 수 없습니다." )
		return
	end

	-- 상용화 체크
	if  ( not FGlobal_IsCommercialService() )   then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTUSE") ) --"아직 이용할 수 없습니다."
		return
	end
	
	-- if not IsSelfPlayerWaitAction() then
	-- 	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_CASHSHOP") )
	-- 	return
	-- end
	
	if  ( Panel_IngameCashShop:GetShow() )  then
		return
	end
	
	if ( nil == getIngameCashMall() ) then
		return false
	end

	if ( getIngameCashMall():isShow() ) then
		return
	end

	if ( not getIngameCashMall():show() ) then
		return
	end
	
	audioPostEvent_SystemUi(01,39)
	--서버 요청
	--{ 
		if not isNaver then
			cashShop_requestCash()
		end
		cashShop_requestCashShopList()
	--}
	
	--{
		SetUIMode(Defines.UIMode.eUIMode_InGameCashShop)
		UI.flushAndClearUI()
	--}
	
	-- 창 오픈 시 효과음

	getIngameCashMall():clearEquipViewList()    -- 장비 슬롯에 착용하고 있는 것을 벗는다.
	getIngameCashMall():changeViewMyCharacter() -- 내 캐릭터를 세팅한다.

	local self              = inGameShop

	_ingameCashShop_SetViewListCount()  -- 가용 가능 세로 사이즈, 나올 수 있는 리스트 개수 구함.

	-- 미리보기
	--{
		cashShop_Controller_Open()
		FGlobal_CashShop_SetEquip_Open()
	--}
	
	-- 탭 초기화
	for ii = 0, self._tabCount  do
		self._tabs[ii].static:SetCheck( false )
	end

	self._openFunction = true
	self._static_Construction:ComputePos()
	self._static_Construction:SetShow( true )

	Panel_IngameCashShop:SetShow(true)

	self._promotionTab.static:SetCheck( true )
	-- Panel_IngameCashShop:SetChildIndex(self._promotionTab.static, 9999 ) 	-- 선택되어 있으니, 맨위로 올린다.

	self._scroll_IngameCash:SetShow( false )
	
	
	local scrSizeY      = getScreenSizeY()
	
	local categoryUrl   = ""
	local promotionUrl  = ""
	--if isGameServiceTypeKorReal() then
	if isServerFixedCharge() then		-- 러시아 P2P(정액제)
		promotionUrl    = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL_P2P")
		categoryUrl     = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL_P2P")
	else
		promotionUrl    = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_PROMOTIONURL")
		categoryUrl     = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_URL_CATEGORYURL")
	end
	--else
	--  promotionUrl    = "http://dev.pub.game.daum.net/black/internal/shop/index.daum"
	--  categoryUrl     = "http://dev.pub.game.daum.net/black/internal/shop/detail/index.daum"
	--end
	--url = "coui://UI_Data/UI_Html/Window/CashShop/PromotionBanner.html"

	
	FGlobal_SetCandidate()
	self._categoryWeb:SetUrl( self._categoryWeb:GetSizeX(), self._categoryWeb:GetSizeY(), categoryUrl)
	self._categoryWeb:SetShow( false )
	self._categoryWeb:SetIME()
	
	self._promotionWeb:SetUrl( self._promotionWeb:GetSizeX(),  self._promotionSizeY , promotionUrl ) 
	self._promotionWeb:SetIME()
	InGameShop_Promotion_Open()
end

function    InGameShop_Close()
	local self  = inGameShop
	if ( nil ~= getIngameCashMall() ) then
		getIngameCashMall():clearEquipViewList()    -- 장비 슬롯에 착용하고 있는 것을 벗는다.
		getIngameCashMall():changeViewMyCharacter() -- 내 캐릭터를 세팅한다.
		getIngameCashMall():hide()
	end
	
	if  (   not Panel_IngameCashShop:GetShow() 
		and not Panel_IngameCashShop_BuyOrGift:GetShow() 
		and not Panel_IngameCashShop_NewCart:GetShow()
		and not Panel_IngameCashShop_GoodsDetailInfo:GetShow()
		and not Panel_IngameCashShop_Password:GetShow()
		and not Panel_IngameCashShop_SetEquip:GetShow()
		and not Panel_IngameCashShop_Controller:GetShow()
		)   then
		return
	end
	-- 미리보기
	--{
		FGlobal_CashShop_SetEquip_Close()
		cashShop_Controller_Close()
	--}

	--{
		SetUIMode(Defines.UIMode.eUIMode_Default)
		UI.restoreFlushedUI()
	--}
	if Panel_QnAWebLink:GetShow() then
		FGlobal_QnAWebLink_Close()
	end

	if Panel_Window_Inventory:GetShow() then
		InventoryWindow_Close()
		Inventory_SetFunctor( nil, nil, nil, nil )
		if Panel_Equipment:GetShow() then
			EquipmentWindow_Close()
		end
	end

	if Panel_ChangeWeapon:GetShow() then
		WeaponChange_Close()
	end

	if Panel_ChangeWeapon:GetShow() then
		WeaponChange_Close()
	end
	
	self._promotionWeb  :ResetUrl()
	self._promotionWeb  :SetShow( false )
	self._categoryWeb   :ResetUrl()
	self._categoryWeb   :SetShow( false )

	self._openFunction = false
	self._openByEventAlarm  = false

	-- FGlobal_MovieGuide_Reposition()
	
	ClearFocusEdit()
	Panel_IngameCashShop:SetShow(false)
	FGlobal_ClearCandidate()
	
	reloadGameUI()
end

function    InGameShop_UpdateCartButton()
	local cartListCount = getIngameCashMall():getCartListCount()
	-- local stringValue = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CartButtonText", "count", cartListCount )
	inGameShop._myCartTab.static:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_UPDATECART", "cartListCount", cartListCount) )-- "장바구니( <PAColor0xFFFFBC1A>"  .. cartListCount .. "<PAOldColor> )" )
end

function ToClient_RequestShowProduct(productNo, price)
	local   self    = inGameShop
	local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNo)
	if  ( nil ~= cashProduct )  then
		local category = cashProduct:getCategory()
		if ( 9 <= category ) then
			category = category + 1
		end
		InGameShop_TabEvent(category)
		self._promotionWeb:SetShow( false )
		self._combo_Class	:SetSelectItemIndex(0)
		self._currentClass  = nil
		InGameShop_SelectClass()
		self:RadioReset()
		if(nil ~= self._tabs[category]) then
			self._tabs[category].static:SetCheck( true )
		end 
		
		IngameCashShop_SelectedItemXXX( productNo, true )
	end
end

function ToClient_CategoryWebFocusOut()
	local   self    = inGameShop
	self._categoryWeb:FocusOut()
end

-- InGameShop_Close()
inGameShop:init()
InGameShop_GameTypeCheck()
IngameCashShop_Descinit()
inGameShop:registEventHandler()
inGameShop:registMessageHandler()

local UI_TM = CppEnums.TextMode

local _const = Defines.u64_const
local u64_hour = toUint64(0, 3600)
local u64_minute = toUint64(0, 60)
local UI_color 		= Defines.Color
local UI_RewardType	= CppEnums.RewardType

local isGrowthContents = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 35 ) -- 성장형 아이템 컨텐츠 옵션(연금석, 토템 등)

local normalTooltip = {
	mainPanel						= Panel_Tooltip_Item,
	itemName						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Name"),						-- 아이템 이름
	itemIcon						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Icon"),						-- 아이템 아이콘
	enchantLevel					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Enchant_value"),				-- 아이콘에 붙는 강화 레벨
	itemType						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Type"),						-- 아이템 타입
	dying							= UI.getChildControl(Panel_Tooltip_Item, "StaticText_Dying"),						-- 염색 여부
	isEnchantable					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_isEnchantable"),				-- 강화 가능/불가
	isSealed						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_isSealed"),					-- 각인
	-- disassembleType					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DisassembleType"),			-- 분해 가능/불가
	bindType						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_BindType"),					-- 귀속 아이템

	useDyeColorTitle				= UI.getChildControl(Panel_Tooltip_Item, "StaticText_DyeColorInfo"),				-- 염색 가능 여부
	-- useDyeColorText_Part1			= UI.getChildControl(Panel_Tooltip_Item, "StaticText_DyeColor_Part1"),
	-- useDyeColorText_Part2			= UI.getChildControl(Panel_Tooltip_Item, "StaticText_DyeColor_Part2"),
	-- useDyeColorText_Part3			= UI.getChildControl(Panel_Tooltip_Item, "StaticText_DyeColor_Part3"),
	useDyeColorIcon_Part			= {
								[0]	=	UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part1"),			-- 염색 정보 슬롯
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part2"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part3"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part4"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part5"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part6"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part7"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part8"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part9"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part10"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part11"),
										UI.getChildControl(Panel_Tooltip_Item, "Static_DyeColorIcon_Part12"),
	},

	useLimit_category				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_category"),				-- 
	useLimit_panel					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_panel"),				-- 레벨 제한 BG
	useLimit_level					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_level"),				-- 레벨 제한 타이틀
	useLimit_level_value			= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_level_value"),			-- 레벨 제한 값
	useLimit_extendedslot			= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_extendedslot"),			-- 확장점유 슬롯 설명(추가)
	useLimit_extendedslot_value		= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_extendedslot_value"),	-- 확장점유 슬롯 설명(추가)
	useLimit_class					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_class"),				-- 
	useLimit_class_value			= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_class_value"),			-- 

	useLimit_Exp					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_Exp"),					-- 
	useLimit_Exp_gage				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_Exp_gage"),				-- 
	useLimit_Exp_gage_value			= UI.getChildControl(Panel_Tooltip_Item, "Progress_UseLimit_Exp_gage_value"),			-- 
	useLimit_Exp_value				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_Exp_value"),

	useLimit_endurance				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_endurance"),			-- 
	useLimit_endurance_gage			= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_endurance_gage"),		-- 
	useLimit_endurance_gage_value	= UI.getChildControl(Panel_Tooltip_Item, "Progress_UseLimit_endurance_gage_value"),		-- 
	useLimit_dynamic_endurance_gage_value	= UI.getChildControl(Panel_Tooltip_Item, "Progress2_MaxEndurance"),				-- 
	useLimit_endurance_value		= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_endurance_value"),
	-- usableTime						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_usableTime"),
	-- useableTime_value				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_usableTime_value"),
	remainTime						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_remainTime"),
	remainTime_value				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_remainTime_value"),
	
	expireIcon_white				= UI.getChildControl(Panel_Tooltip_Item, "Static_Expire_Icon1"),							-- 흰색 시계 표시 
	expireIcon_red					= UI.getChildControl(Panel_Tooltip_Item, "Static_Expire_Icon2"),							-- 붉은색 시계 표시
	expireIcon_end					= UI.getChildControl(Panel_Tooltip_Item, "Static_Expire_Icon3"),							-- 붉은색 엑스 표시

	defaultEffect_category			= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_category"),
	defaultEffect_panel				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_panel"),
	attack							= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack"),
	attack_value					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack_value"),
	attack_diffValue				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attackDiff_value"),
	isMeleeAttack					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack_isMeleeAttack"),
	isRangeAttack					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack_isRangeAttack"),
	isMagicAttack					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attack_isMagicAttack"),
	defense							= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_defense"),
	defense_value					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_defense_value"),
	defense_diffValue				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_defenseDiff_value"),
	weight							= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_weight"),
	weight_value					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_weight_value"),
	weight_diffValue				= UI.getChildControl(Panel_Tooltip_Item, "StaticText_DefaultEffect_weightDiff_value" ),

	-- soketOption_category			= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_category"),
	soketOption_panel				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_panel"),

	--소켓 기능
	soketSlot							= {},
	soketName							= {},
	soketEffect							= {},

	itemProducedPlace				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ProducedPlace"),
	itemDescription					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_Description"),

	itemPrice_panel					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_panel"),
	itemPrice_transportBuy			= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_transportBuy"),
	itemPrice_transportBuy_value	= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_transportBuy_value"),
	itemPrice_storeSell				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_storeSell"),
	itemPrice_storeSell_value		= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ItemPrice_storeSell_value"),

	grapeSize						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_endurance_value"):GetSizeX(),
	panelSize						= Panel_Tooltip_Item:GetSizeY(),
	socketSize						= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_panel"):GetSizeY(),
	-- useLimitClassPosY				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_class_value"):GetPosY(),
	-- useLimitClassSizeY				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_class_value"):GetSizeY(),
	deltaTime						= 0,
	att_Value						= 0,
	def_Value						= 0,
	wei_Value						= 0,

	tradeInfo_Panel					= UI.getChildControl(Panel_Tooltip_Item, "Static_TradeInfoPanel"),
	tradeInfo_Title					= UI.getChildControl(Panel_Tooltip_Item, "StaticText_TradePriceTitle"),
	tradeInfo_Value					= UI.getChildControl(Panel_Tooltip_Item, "StaticText_TradePriceValue"),
	equipSlotName					= UI.getChildControl(Panel_Tooltip_Item, "StaticText_EquipTypeName"),
	productNotify					= UI.getChildControl(Panel_Tooltip_Item, "Static_ProductNotify"),
	personalTrade					= UI.getChildControl(Panel_Tooltip_Item, "StaticText_IsPersnalTrade"),
	exchangeTitle					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ExchangeTitle"),
	exchangeDesc					= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_ExchangeDescription"),
}

local equippedTooltip = {
	equippedTag						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_nowEquiped_tag"),

	mainPanel						= Panel_Tooltip_Item_equipped,
	itemName						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Name"),
	itemIcon						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Icon"),
	enchantLevel					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Enchant_value"),
	itemType						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Type"),
	dying							= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_Dying"),
	isEnchantable					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_isEnchantable"),
	isSealed						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_isSealed"),					-- 각인
	-- disassembleType					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DisassembleType"),
	bindType						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_BindType"),

	useDyeColorTitle				= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_DyeColorInfo"),
	-- useDyeColorText_Part1			= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_DyeColor_Part1"),
	-- useDyeColorText_Part2			= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_DyeColor_Part2"),
	-- useDyeColorText_Part3			= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_DyeColor_Part3"),
	useDyeColorIcon_Part			= {
								[0]	=	UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part1"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part2"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part3"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part4"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part5"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part6"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part7"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part8"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part9"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part10"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part11"),
										UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_DyeColorIcon_Part12"),
	},

	useLimit_category				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_category"),
	useLimit_panel					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_panel"),
	useLimit_level					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_level"),
	useLimit_level_value			= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_level_value"),
	useLimit_extendedslot			= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_extendedslot"),			-- 확장점유 슬롯 설명(추가)
	useLimit_extendedslot_value		= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_extendedslot_value"),		-- 확장점유 슬롯 설명(추가)
	useLimit_class					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_class"),
	useLimit_class_value			= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_class_value"),

	useLimit_Exp					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_Exp"),					-- 
	useLimit_Exp_gage				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_Exp_gage"),				-- 
	useLimit_Exp_gage_value			= UI.getChildControl(Panel_Tooltip_Item_equipped, "Progress_UseLimit_Exp_gage_value"),			-- 
	useLimit_Exp_value				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_Exp_value"),

	useLimit_endurance				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_endurance"),
	useLimit_endurance_gage			= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_endurance_gage"),
	useLimit_endurance_gage_value	= UI.getChildControl(Panel_Tooltip_Item_equipped, "Progress_UseLimit_endurance_gage_value"),
	useLimit_dynamic_endurance_gage_value	= UI.getChildControl(Panel_Tooltip_Item_equipped, "Progress2_MaxEndurance"),
	useLimit_endurance_value		= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_endurance_value"),

	--usableTime						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_usableTime"),
	--useableTime_value				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_usableTime_value"),
	remainTime						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_remainTime"),
	remainTime_value				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_remainTime_value"),

	defaultEffect_category			= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_category"),
	defaultEffect_panel				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_panel"),
	attack							= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack"),
	attack_value					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack_value"),
	attack_diffValue				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_attackDiff_value"),
	isMeleeAttack					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack_isMeleeAttack"),
	isRangeAttack					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack_isRangeAttack"),
	isMagicAttack					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_attack_isMagicAttack"),
	defense							= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_defense"),
	defense_value					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_defense_value"),
	defense_diffValue				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_DefaultEffect_defenseDiff_value"),
	weight							= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_weight"),
	weight_value					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_DefaultEffect_weight_value"),
	weight_diffValue				= UI.getChildControl(Panel_Tooltip_Item, "StaticText_DefaultEffect_weightDiff_value" ),

	-- soketOption_category			= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_category"),
	soketOption_panel				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_panel"),

	soketSlot						= {},
	soketName						= {},
	soketEffect						= {},

	itemProducedPlace				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ProducedPlace"),
	itemDescription					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_Description"),

	itemPrice_panel					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_panel"),
	itemPrice_transportBuy			= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_transportBuy"),
	itemPrice_transportBuy_value	= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_transportBuy_value"),
	itemPrice_storeSell				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_storeSell"),
	itemPrice_storeSell_value		= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ItemPrice_storeSell_value"),
	
	arrow							= UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_Arrow"),
	arrow_L							= UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_Arrow_L"),

	grapeSize						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_endurance_value"):GetSizeX(),
	panelSize						= Panel_Tooltip_Item:GetSizeY(),
	socketSize						= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_panel"):GetSizeY(),
	-- useLimitClassPosY				= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_UseLimit_class_value"):GetPosY(),
	-- useLimitClassSizeY				= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_UseLimit_class_value"):GetSizeY(),
	deltaTime						= 0,
	
	att_Value						= 0,
	def_Value						= 0,
	wei_Value						= 0,

	tradeInfo_Panel					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_TradeInfoPanel"),
	tradeInfo_Title					= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_TradePriceTitle"),
	tradeInfo_Value					= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_TradePriceValue"),
	equipSlotName					= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_EquipTypeName"),
	productNotify					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Static_ProductNotify"),
	personalTrade					= UI.getChildControl(Panel_Tooltip_Item_equipped, "StaticText_IsPersnalTrade"),
	exchangeTitle					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ExchangeTitle"),
	exchangeDesc					= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_ExchangeDescription"),
}

local chattingLinkedItemTooltip = {
	mainPanel						= Panel_Tooltip_Item_chattingLinkedItem,
	itemName						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Name"),						-- 아이템 이름
	itemIcon						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Icon"),						-- 아이템 아이콘
	closeBtn						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Button_Win_Close"),						-- close button
	enchantLevel					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Enchant_value"),				-- 아이콘에 붙는 강화 레벨
	itemType						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Type"),						-- 아이템 타입
	dying							= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_Dying"),						-- 염색 여부
	isEnchantable					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_isEnchantable"),				-- 강화 가능/불가
	isSealed						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_isSealed"),					-- 각인
	-- disassembleType					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DisassembleType"),			-- 분해 가능/불가
	bindType						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_BindType"),					-- 귀속 아이템

	useDyeColorTitle				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_DyeColorInfo"),				-- 염색 가능 여부
	-- useDyeColorText_Part1			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_DyeColor_Part1"),
	-- useDyeColorText_Part2			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_DyeColor_Part2"),
	-- useDyeColorText_Part3			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_DyeColor_Part3"),
	useDyeColorIcon_Part			= {
								[0]	=	UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part1"),			-- 염색 정보 슬롯
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part2"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part3"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part4"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part5"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part6"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part7"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part8"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part9"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part10"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part11"),
										UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_DyeColorIcon_Part12"),
	},

	useLimit_category				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_category"),				-- 
	useLimit_panel					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_panel"),				-- 레벨 제한 BG
	useLimit_level					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_level"),				-- 레벨 제한 타이틀
	useLimit_level_value			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_level_value"),			-- 레벨 제한 값
	useLimit_extendedslot			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_extendedslot"),			-- 확장점유 슬롯 설명(추가)
	useLimit_extendedslot_value		= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_extendedslot_value"),	-- 확장점유 슬롯 설명(추가)
	useLimit_class					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_class"),				-- 
	useLimit_class_value			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_class_value"),			-- 

	useLimit_Exp					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_Exp"),					-- 
	useLimit_Exp_gage				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_Exp_gage"),				-- 
	useLimit_Exp_gage_value			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Progress_UseLimit_Exp_gage_value"),			-- 
	useLimit_Exp_value				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_Exp_value"),

	useLimit_endurance				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_endurance"),			-- 
	useLimit_endurance_gage			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_endurance_gage"),		-- 
	useLimit_endurance_gage_value	= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Progress_UseLimit_endurance_gage_value"),		-- 
	useLimit_dynamic_endurance_gage_value	= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Progress2_MaxEndurance"),	-- 
	useLimit_endurance_value		= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_endurance_value"),

	-- usableTime						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_usableTime"),
	-- useableTime_value				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_usableTime_value"),
	remainTime						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_remainTime"),
	remainTime_value				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_remainTime_value"),
	
	expireIcon_white				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_Expire_Icon1"),							-- 흰색 시계 표시 
	expireIcon_red					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_Expire_Icon2"),							-- 붉은색 시계 표시
	expireIcon_end					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_Expire_Icon3"),							-- 붉은색 엑스 표시

	defaultEffect_category			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_category"),
	defaultEffect_panel				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_panel"),
	attack							= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack"),
	attack_value					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack_value"),
	attack_diffValue				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attackDiff_value"),
	isMeleeAttack					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack_isMeleeAttack"),
	isRangeAttack					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack_isRangeAttack"),
	isMagicAttack					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_attack_isMagicAttack"),
	defense							= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_defense"),
	defense_value					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_defense_value"),
	defense_diffValue				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_defenseDiff_value"),
	weight							= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_weight"),
	weight_value					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_DefaultEffect_weight_value"),
	weight_diffValue				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_DefaultEffect_weightDiff_value" ),

	-- soketOption_category			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_category"),
	soketOption_panel				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_panel"),

	--소켓 기능
	soketSlot							= {},
	soketName							= {},
	soketEffect							= {},

	itemProducedPlace				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ProducedPlace"),
	itemDescription					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_Description"),

	itemPrice_panel					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_panel"),
	itemPrice_transportBuy			= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_transportBuy"),
	itemPrice_transportBuy_value	= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_transportBuy_value"),
	itemPrice_storeSell				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_storeSell"),
	itemPrice_storeSell_value		= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ItemPrice_storeSell_value"),

	grapeSize						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_endurance_value"):GetSizeX(),
	panelSize						= Panel_Tooltip_Item_chattingLinkedItem:GetSizeY(),
	socketSize						= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_panel"):GetSizeY(),
	-- useLimitClassPosY				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_class_value"):GetPosY(),
	-- useLimitClassSizeY				= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_UseLimit_class_value"):GetSizeY(),
	deltaTime						= 0,
	att_Value						= 0,
	def_Value						= 0,
	wei_Value						= 0,

	tradeInfo_Panel					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_TradeInfoPanel"),
	tradeInfo_Title					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_TradePriceTitle"),
	tradeInfo_Value					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_TradePriceValue"),
	equipSlotName					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_EquipTypeName"),
	productNotify					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Static_ProductNotify"),
	personalTrade					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "StaticText_IsPersnalTrade"),
	exchangeTitle					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ExchangeTitle"),
	exchangeDesc					= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_ExchangeDescription"),
}

local Panel_Tooltip_Item_DataObject =
{
	slotData		= {},
	currentSlotNo	= -1,
	currentSlotType = "",
	index			= -1,
	isNormal		= false,
	isSkill			= false,
	itemMarket		= false,
	inventory		= false,
}

function Panel_Tooltip_Item_Initialize()
	Panel_Tooltip_Item:SetShow(false, false)
	Panel_Tooltip_Item:setMaskingChild(true)
	Panel_Tooltip_Item:SetIgnore(true)
	Panel_Tooltip_Item:SetIgnoreChild(true)
	Panel_Tooltip_Item:setGlassBackground(true)

	Panel_Tooltip_Item_equipped:SetShow(false, false)
	Panel_Tooltip_Item_equipped:setMaskingChild(true)
	Panel_Tooltip_Item_equipped:SetIgnore(true)
	Panel_Tooltip_Item_equipped:SetIgnoreChild(true)
	Panel_Tooltip_Item_equipped:setGlassBackground(true)
	
	Panel_Tooltip_Item_chattingLinkedItem:SetShow(false, false)
	Panel_Tooltip_Item_chattingLinkedItem:setMaskingChild(true)
	Panel_Tooltip_Item_chattingLinkedItem:SetIgnore(true)
	Panel_Tooltip_Item_chattingLinkedItem:SetIgnoreChild(true)
	Panel_Tooltip_Item_chattingLinkedItem:setGlassBackground(true)
	
	chattingLinkedItemTooltip.closeBtn:addInputEvent( "Mouse_LUp", "Panel_Tooltip_Item_chattingLinkedItem_hideTooltip()" )
	
	for idx = 1, 6 do
		normalTooltip.soketSlot[idx]	= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_soketSlot" .. idx)
		normalTooltip.soketName[idx]	= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_soketName" .. idx)
		normalTooltip.soketEffect[idx]	= UI.getChildControl(Panel_Tooltip_Item, "Tooltip_Item_SoketOption_soketEffect" .. idx)
	
		equippedTooltip.soketSlot[idx]	= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_soketSlot" .. idx)
		equippedTooltip.soketName[idx]	= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_soketName" .. idx)
		equippedTooltip.soketEffect[idx]= UI.getChildControl(Panel_Tooltip_Item_equipped, "Tooltip_Item_SoketOption_soketEffect" .. idx)
		
		chattingLinkedItemTooltip.soketSlot[idx]	= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_soketSlot" .. idx)
		chattingLinkedItemTooltip.soketName[idx]	= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_soketName" .. idx)
		chattingLinkedItemTooltip.soketEffect[idx]	= UI.getChildControl(Panel_Tooltip_Item_chattingLinkedItem, "Tooltip_Item_SoketOption_soketEffect" .. idx)
	end


	local SetTextWrap = function(control)
		if ( nil == control ) then
			UI.ASSERT(false, "SetTextWrap(control) , control nil")
			return
		end

		control:SetTextMode(UI_TM.eTextMode_AutoWrap)
		control:SetAutoResize(true)
	end

	local InitControls = function( target )
		--텍스트 렙
		SetTextWrap(target.itemType)
		SetTextWrap(target.isEnchantable)
		SetTextWrap(target.isSealed)
		-- SetTextWrap(target.disassembleType)
		--SetTextWrap(target.bindType)
		
		SetTextWrap(target.useLimit_category)
		SetTextWrap(target.useLimit_level)
		--SetTextWrap(target.useLimit_level_value)
		SetTextWrap(target.useLimit_extendedslot)			-- 추가
		SetTextWrap(target.useLimit_extendedslot_value)		-- 추가
		SetTextWrap(target.useLimit_class)
		SetTextWrap(target.useLimit_class_value)
		SetTextWrap(target.useLimit_Exp)
		SetTextWrap(target.useLimit_Exp_value)
		SetTextWrap(target.useLimit_endurance)
		SetTextWrap(target.useLimit_endurance_value)
		--SetTextWrap(target.usableTime)
		--SetTextWrap(target.useableTime_value)
		SetTextWrap(target.remainTime)
		SetTextWrap(target.remainTime_value)
		SetTextWrap(target.defaultEffect_category)
		SetTextWrap(target.attack)
		SetTextWrap(target.attack_value)
		SetTextWrap(target.attack_diffValue)
		SetTextWrap(target.defense)
		SetTextWrap(target.defense_value)
		SetTextWrap(target.defense_diffValue)
		SetTextWrap(target.weight)
		SetTextWrap(target.weight_value)
		SetTextWrap(target.weight_diffValue)
		-- SetTextWrap(target.soketOption_category)
		SetTextWrap(target.itemProducedPlace)
		SetTextWrap(target.itemDescription)
		SetTextWrap(target.tradeInfo_Title)
		SetTextWrap(target.tradeInfo_Value)
		SetTextWrap(target.equipSlotName)
		SetTextWrap(target.exchangeDesc)

		
		for idx = 1 , 6 do
			SetTextWrap(target.soketName[idx])
			SetTextWrap(target.soketEffect[idx])
		end
	end
	InitControls( normalTooltip )
	InitControls( equippedTooltip )
	InitControls( chattingLinkedItemTooltip )


	local skillTooltipFunctionList = {
		GetParentPosX = function()
			local slot = Panel_Tooltip_Item_DataObject.skillSlot
			return slot.icon:GetParentPosX()
		end,
		GetParentPosY = function()
			local slot = Panel_Tooltip_Item_DataObject.skillSlot
			return slot.icon:GetParentPosY()
		end,
		GetSizeX = function()
			local slot = Panel_Tooltip_Item_DataObject.skillSlot
			return slot.icon:GetSizeX()
		end,
		GetSizeY = function()
			local slot = Panel_Tooltip_Item_DataObject.skillSlot
			return slot.icon:GetSizeY()
		end,
	}

	Panel_SkillTooltip_SetPosition( 1, skillTooltipFunctionList, "itemToSkill" )
end

local GetBottomPos = function(control)
	if ( nil == control ) then
		UI.ASSERT(false, "GetBottomPos(control) , control nil")
		return
	end
	return control:GetPosY() + control:GetSizeY()
end

function Panel_Tooltip_Item_SetPosition( slotNo, slot, slotType )
	if ( nil == Panel_Tooltip_Item_DataObject.slotData[slotType] ) then
		Panel_Tooltip_Item_DataObject.slotData[slotType] = {}
	end
	Panel_Tooltip_Item_DataObject.slotData[slotType][slotNo] = slot
end

-- 특수화 아이템 툴팁 --------------------------------------------------------------------------------------------------------------------
function Panel_Tooltip_Item_GetCurrentSlotType()
	return Panel_Tooltip_Item_DataObject.currentSlotType
end

function Panel_Tooltip_Item_Refresh()
	if ( Panel_Tooltip_Item_DataObject.currentSlotNo == -2 ) then
		return
	elseif ( Panel_Tooltip_Item_DataObject.currentSlotNo ~= -1 ) then
		if ( Panel_Tooltip_Item_DataObject.isNormal ) then
			Panel_Tooltip_Item_Show_GeneralNormal( Panel_Tooltip_Item_DataObject.currentSlotNo, Panel_Tooltip_Item_DataObject.currentSlotType, true, Panel_Tooltip_Item_DataObject.index )
		else
			Panel_Tooltip_Item_Show_GeneralStatic( Panel_Tooltip_Item_DataObject.currentSlotNo, Panel_Tooltip_Item_DataObject.currentSlotType, true, Panel_Tooltip_Item_DataObject.index )
		end
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

-- 정보받아 나오는 툴팁 
function Panel_Tooltip_Item_Show( itemStaticStatus,  uiBase, isSSW, isItemWrapper, chattingLinkedItem, index, isItemMarket )
	Panel_Tooltip_Item_DataObject.itemMarket = isItemMarket	-- 아이템 마켓에서 열 때 처리를 위해.
	Panel_Tooltip_Item_DataObject.inventory = nil	-- 인벤에서 뜬 것을 처리하기 위해
	showTooltip_Item(normalTooltip, itemStaticStatus, isSSW, isItemWrapper, chattingLinkedItem, index )
	Panel_Tooltip_Item_Set_Position(uiBase)
end

function Panel_Tooltip_Item_Show_ForQuest( itemEnchantKey, isSSW, isItemWrapper )
	Panel_Tooltip_Item_DataObject.itemMarket = nil	-- 아이템 마켓에서 열 때 처리를 위해.
	Panel_Tooltip_Item_DataObject.inventory = nil	-- 인벤에서 뜬 것을 처리하기 위해
	local itemStaticStatus = getItemEnchantStaticStatus( ItemEnchantKey(itemEnchantKey) )
	showTooltip_Item(normalTooltip, itemStaticStatus, isSSW, isItemWrapper)
	Panel_Tooltip_Item_Set_Position(Panel_QuestInfo)
	Panel_Tooltip_Item_DataObject.currentSlotNo = -2
end

function Panel_Tooltip_Item_Show_ForChattingLinkedItem( itemStaticStatus, uiBase, isSSW, isItemWrapper, chattingLinkedItem )
	Panel_Tooltip_Item_DataObject.itemMarket = nil	-- 아이템 마켓에서 열 때 처리를 위해.
	Panel_Tooltip_Item_DataObject.inventory = nil	-- 인벤에서 뜬 것을 처리하기 위해
	chattingLinkedItemTooltip.closeBtn:SetIgnore( false )
	showTooltip_Item(chattingLinkedItemTooltip, itemStaticStatus, isSSW, isItemWrapper, chattingLinkedItem, index)
	Panel_Tooltip_Item_chattingLinkedItem_Set_Position(uiBase)
end

function Panel_Tooltip_Item_Show_GeneralNormal( slotNo, slotType, isOn, index )

	Panel_Tooltip_Item_DataObject.itemMarket = nil	-- 아이템 마켓에서 열 때 처리를 위해.
	
	if ( false == Panel_Tooltip_Item_Show_General( slotNo, slotType, isOn, true, index ) ) then
		return
	end

	local	slot	= Panel_Tooltip_Item_DataObject.slotData[slotType][slotNo]
	local	parent	= false
	if slotType == "servant_inventory" then
		if getServantInventorySize(ServantInventory_GetActorKeyRawFromIndex(0)) <= slotNo then
			return;
		end
		parent	= true
	elseif ( "inventory" == slotType ) then
		Panel_Tooltip_Item_DataObject.inventory = true	-- 인벤에서 뜬 것을 처리하기 위해
		local selfPlayerWrapper = getSelfPlayer()
		if nil == selfPlayerWrapper then
			return
		end
		
		local selfPlayer	= selfPlayerWrapper:get()
		if nil == selfPlayer then
			return
		end
		
		local	inventory		= Inventory_GetCurrentInventory()
		local	inventorySlotNo	= slotNo + Inventory_GetStartIndex() + inventorySlotNoUserStart()
		if	(inventory:sizeXXX() <= inventorySlotNo)	then
			return
		end
	elseif ( "Auction" == slotType ) then
		local myAuctionInfo = RequestGetAuctionInfo()
		local auctionType = myAuctionInfo:getAuctionType()
		local itemCount = 0
		
		if(auctionType == 0) then
			itemCount = myAuctionInfo:getItemAuctionListCount()
		elseif(auctionType == 4)then
			itemCount = myAuctionInfo:getMySellingItemAuctionCount()
		elseif(auctionType == 6)then
			itemCount = myAuctionInfo:getMyItemBidListCount()
		end		
		
		if itemCount < slotNo then
			return;
		end
	end

	local itemWrapper		= nil
	local isEquipOn			= false
	local isServantEquipOn	= false
	if	("servant_inventory"== slotType)	then
		itemWrapper	= getServantInventoryItemBySlotNo( ServantInventory_GetActorKeyRawFromIndex(index), slotNo )
	elseif ( "QuickSlot" == slotType ) then
		local quickSlotInfo = getQuickSlotItem( slotNo )
		if ( nil == quickSlotInfo ) then
			return
		end
		
		local selfPlayerWrapper = getSelfPlayer()
		if nil == selfPlayerWrapper then
			return
		end
		
		local selfPlayer	= selfPlayerWrapper:get()
		if nil == selfPlayer then
			return
		end
		
		local	whereType	= QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
		local	inventory	= selfPlayer:getInventoryByType(whereType)
		local	invenSlotNo = inventory:getSlot( quickSlotInfo._itemKey )
		if	( inventory:sizeXXX() <= invenSlotNo )	then
			return
		end
		
		itemWrapper	= getInventoryItemByType( whereType, invenSlotNo )
		
	elseif ( "inventory" == slotType ) then
		itemWrapper	= Inventory_GetToopTipItem()
	elseif ( "Enchant" == slotType ) then
		if	(0 == slotNo)	then
			itemWrapper	= EnchantItem_ToItemWrapper()
		else
			itemWrapper	= EnchantItem_FromItemWrapper()
		end
	elseif ( "SocketItem" == slotType ) then
		itemWrapper	= SocketItem_FromItemWrapper()
		isEquipOn = true
	elseif ( "WareHouse" == slotType ) then
		itemWrapper	= Warehouse_GetToopTipItem()
	elseif ( "looting" == slotType ) then
		itemWrapper = looting_getItem(slotNo)
	elseif ( "equipment" == slotType ) then
		itemWrapper = getEquipmentItem(slotNo)
		isEquipOn = true
	elseif ( "disassemble_source" == slotType ) then
		itemWrapper	= disassemble_GetSourceItem( slotNo )
	elseif ( "disassemble_result" == slotType ) then
		itemWrapper	= disassemble_GetResultItem( slotNo )
	elseif ( "product_recipe" == slotType ) then
		itemWrapper	= product_GetRecipeItem( 0 )
	elseif ( "product_result" == slotType ) then
		itemWrapper	= product_GetResultItem( slotNo )
	elseif ( "ServantEquipment" == slotType ) then -- 지상 탑승물 정보창 아이템 툴팁		
		local	servantWrapper		= getServantInfoFromActorKey( Servant_GetActorKeyFromItemToolTip() )
		if	(nil ~= servantWrapper)	then
			itemWrapper		= servantWrapper:getEquipItem( slotNo )
		end
		
		isEquipOn		= true
		isServantEquipOn= false
	elseif ( "ServantShipEquipment" == slotType ) then -- 수상 탑승물 정보창 아이템 툴팁
		local	servantWrapper		= getServantInfoFromActorKey( Servant_GetActorKeyFromItemToolTip() )
		if	(nil ~= servantWrapper)	then
			itemWrapper		= servantWrapper:getEquipItem( slotNo )
		end
		
		isEquipOn		 = true
		isServantEquipOn = true
	elseif ( "StableEquipment" == slotType )then
		local	servantInfo		= stable_getServant( StableList_SelectSlotNo() )
		if	nil ~= servantInfo	then
			itemWrapper = servantInfo:getEquipItem( slotNo )
		end
	elseif ( "exchangeOther" == slotType ) then
		itemWrapper = tradePC_GetOtherItem( slotNo )
	elseif ( "tradeMarket_Sell" == slotType ) then
		itemWrapper	= npcShop_getItemWrapperByShopSlotNo( slotNo )				-- itemWrapper를 주도록 바꿔야 한다. 그래야 원산지 정보 표시를 할수 있다.
	elseif ( "tradeMarket_VehicleSell" == slotType ) then
		itemWrapper = npcShop_getVehicleItemWrapper( slotNo )
	elseif( "exchangeSelf" == slotType ) then
		itemWrapper = tradePC_GetMyItem( slotNo )
	elseif( "DeliveryInformation" == slotType )	then
		local	deliverySlotNo	= DeliveryInformation_SlotIndex( slotNo )
		local	deliveryList	= delivery_list( DeliveryInformation_WaypointKey() )
		if	nil ~= deliveryList	then
			if	deliverySlotNo < deliveryList:size()	then
				local	deliveryInfo= deliveryList:atPointer(deliverySlotNo)
				if	nil ~= deliveryInfo	then
					itemWrapper	= deliveryInfo:getItemWrapper(deliverySlotNo)
				end
			end
		end
	elseif( "DeliveryCarriageInformation" == slotType )	then
		local	deliverySlotNo	= DeliveryCarriageInformation_SlotIndex( slotNo )
		local	deliveryList	= deliveryCarriage_dlieveryList( DeliveryCarriageInformation_ObjectID() )
		if	nil ~= deliveryList	then
			if	deliverySlotNo < deliveryList:size()	then
				local	deliveryInfo= deliveryList:atPointer(deliverySlotNo)
				if	nil ~= deliveryInfo	then
					itemWrapper	= deliveryInfo:getItemWrapper(deliverySlotNo)
				end
			end
		end
	elseif( "DeliveryRequest" == slotType )	then
		itemWrapper	= delivery_packItem(slotNo)
	elseif( "Auction" == slotType )	then
		local myAuctionInfo = RequestGetAuctionInfo()
		local auctionType = myAuctionInfo:getAuctionType()
		local itemAuctionData
		
		if(auctionType == 0) then
			itemAuctionData = myAuctionInfo:getItemAuctionListAt(slotNo-1)
		elseif(auctionType == 4)then
			itemAuctionData = myAuctionInfo:getMySellingItemAuctionAt(slotNo-1)
		elseif(auctionType == 6)then
			itemAuctionData = myAuctionInfo:getMyItemBidListAt(slotNo-1)
		end		

		
		if (nil ~= itemAuctionData) then
			itemWrapper = itemAuctionData:getItem()
		end	
	elseif( "AuctionRegister" == slotType )	then
		slotNo = Auction_GetSeletedItemSlot()
		if (-1 ~= slotNo) then
			itemWrapper = getInventoryItem( slotNo )
		end	
	elseif ( "Socket" == slotType ) then
		slotNo = Socket_GetSlotNo()
		if (-1 ~= slotNo) then
			itemWrapper = getInventoryItem(slotNo)	
		end
	elseif ( "HousingMode" == slotType ) then
		local realSlotNo = Panel_Housing_SlotNo(slotNo)
		if (-1 ~= realSlotNo) then
			itemWrapper = getInventoryItem(realSlotNo)
		end

	elseif ( "FixEquip" == slotType ) then
		local slotNumber = 0
		if slotNo == 0 then
			slotNumber = FixEquip_GetMainSlotNo()
			if (nil ~= slotNumber) then
				itemWrapper = getInventoryItem(slotNumber)	
			end
		else
			slotNumber = FixEquip_GetSubSlotNo()
			if (nil ~= slotNumber) then
				itemWrapper = getInventoryItem(slotNumber)	
			end
		end
	elseif ( "DailyStamp" == slotType ) then
		itemWrapper = ToClient_getRewardItem( slotNo )
	else
		UI.ASSERT(false, "showTooltip(normal)으로 정의되지 않은 slot타입(" .. slotType .. ")이 들어왔습니다. 확인해주세요.")
		return
	end

	if ( nil == itemWrapper ) then
		return
	end
	local isEquipalbeItem = false
	local servantItem = false

	local skillKey = SkillKey()
	Panel_Tooltip_Item_DataObject.isSkill = false
	if ( itemWrapper:getStaticStatus():isSkillBook(skillKey) ) then
		--스킬북이면 스킬툴팁으로 넘긴다.

		Panel_Tooltip_Item_DataObject.skillSlot = slot

		Panel_SkillTooltip_Show(skillKey:getSkillNo(), false, "itemToSkill", false)
		Panel_Tooltip_Item_DataObject.isSkill = true
		return	
	elseif ( not isEquipOn ) then
		local itemSSW = itemWrapper:getStaticStatus()
		if not itemSSW:isEquipable() then
			isEquipalbeItem, servantItem = showTooltip_Item(normalTooltip, itemWrapper, false, true, nil, nil )
		else
			isEquipalbeItem, servantItem = showTooltip_Item(normalTooltip, itemWrapper, false, true, nil, slotNo)
		end
	else
		showTooltip_Item(equippedTooltip, itemWrapper, false, true)
	end

	if ( isEquipalbeItem ) and ( not isEquipOn ) then
		local equipItemWrapper = nil
		if ( servantItem ) or ( isServantEquipOn ) then
			local	temporaryWrapper= getTemporaryInformationWrapper()
			if	(nil ~= temporaryWrapper)	then
				local	servantWrapper	= temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
				if( nil ~= servantWrapper )	then
					local	servantKind = servantWrapper:getServantKind()
					if(	itemWrapper:getStaticStatus():get():isServantTypeUsable( servantKind ) )	then
						equipItemWrapper = servantWrapper:getEquipItem( itemWrapper:getStaticStatus():getEquipSlotNo() )
					end
				end
			end
		else
			equipItemWrapper = getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo())
		end

		if ( nil ~= equipItemWrapper ) then	-- 장비이고, 장비창에 장착한게 아니다.
			if "Enchant" ~= slotType then	-- 인챈트 창에서 열린 것이면.
				showTooltip_Item(equippedTooltip, equipItemWrapper, false, true)

				-- 화살표 원래대로
				equippedTooltip.arrow:ChangeTextureInfoName("new_ui_common_forlua/widget/tooltip/tooltip_00.dds")
				local x1, y1, x2, y2 = setTextureUV_Func( equippedTooltip.arrow, 38, 43, 74, 109 )
				equippedTooltip.arrow:getBaseTexture():setUV( x1, y1, x2, y2 )
				equippedTooltip.arrow:setRenderTexture(equippedTooltip.arrow:getBaseTexture())
			end
		end

		if "Enchant" == slotType then	-- 인챈트 창에서 열린 것이면.
			-- 다음 인챈트 값을 나타내어야 한다.
			local isCash = itemWrapper:getStaticStatus():get():isCash()
			if false == isCash then -- 캐쉬템이 아니면
				showTooltip_Item(equippedTooltip, itemWrapper, false, true, nil, nil, true)
			end

			-- 화살표 반대로
			equippedTooltip.arrow:ChangeTextureInfoName("new_ui_common_forlua/widget/tooltip/tooltip_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( equippedTooltip.arrow, 1, 43, 37, 109 )
			equippedTooltip.arrow:getBaseTexture():setUV( x1, y1, x2, y2 )
			equippedTooltip.arrow:setRenderTexture(equippedTooltip.arrow:getBaseTexture())
		end

	end

	Panel_Tooltip_Item_Set_Position(slot.icon, parent)
end

function Panel_Tooltip_Item_Show_GeneralStatic( slotNo , slotType, isOn, index )
	Panel_Tooltip_Item_DataObject.itemMarket = nil	-- 아이템 마켓에서 열 때 처리를 위해.
	Panel_Tooltip_Item_DataObject.inventory = nil	-- 인벤에서 뜬 것을 처리하기 위해
	if ( false == Panel_Tooltip_Item_Show_General( slotNo, slotType, isOn, false, index ) ) then
		return
	end
	local isSSW = true
	local isItemWrapper = false
	
	local slot = Panel_Tooltip_Item_DataObject.slotData[slotType][slotNo]

	local itemSSW = nil
	if ( "QuestReward_Base" == slotType ) or ( "QuestReward_Select" == slotType ) or ( "Dialog_QuestReward_Base" == slotType ) or ( "Dialog_QuestReward_Select" == slotType ) then
		itemSSW = getItemEnchantStaticStatus( ItemEnchantKey(slot._item) )
	elseif ( "shop" == slotType ) then
		local shopItemWrapper = nil
		if ( 0 == Panel_Window_NpcShop.npcShop.lastTabIndex ) or ( nil == Panel_Window_NpcShop.npcShop.lastTabIndex ) then
			shopItemWrapper = npcShop_getItemBuy(slotNo)
			if ( nil ~= shopItemWrapper ) then
				itemSSW = shopItemWrapper:getStaticStatus()
			end
		elseif ( 1 == Panel_Window_NpcShop.npcShop.lastTabIndex )then-- 팔기
			--shopItemWrapper = npcShop_getItemSell(slotNo)
			itemSSW = npcShop_getItemWrapperByShopSlotNo(slotNo)
			isSSW = false
		else	--재구매
			itemSSW = npcShop_getItemRepurchaseForToolTip(slotNo)
			isItemWrapper = true
			isSSW		  = false
		end
	elseif("workListMilibogi" == slotType ) then
		itemSSW = HouseControl_getItemStaticStatusByIndex(slotNo)
	elseif ("tradeMarket" == slotType ) then
		itemSSW = global_TradeMarketGraph_StaticStatus(slotNo)
	elseif ( "tradeMarket_Buy" == slotType ) then
		itemSSW	= npcShop_getItemBuy( slotNo ):getStaticStatus()
	elseif ( "tradeSupply" == slotType ) then
		local shopItemWrapper = ToClient_worldmap_getTradeSupplyItem( TradeNpcItemInfo_getTerritoryKey(), slotNo - 1 )
		if nil ~= shopItemWrapper then
			itemSSW = shopItemWrapper:getStaticStatus()
		end
	elseif ( "tradeEventInfo" == slotType ) then
		local shopItemWrapper = ToClient_worldmap_getTradeSupplyItem( index, slotNo )
		if nil ~= shopItemWrapper then
			itemSSW = shopItemWrapper:getStaticStatus()
		 end
	elseif ("product_source" == slotType ) then
		local informationWrapper = product_GetSourceItem(slotNo)
		if ( nil ~= informationWrapper ) then
			itemSSW = informationWrapper:getStaticStatus()
			if ( nil ~= itemSSW ) then
				showTooltip_Item(normalTooltip, itemSSW, true, false)
			end
		end
	elseif ( "Socket_Insert" == slotType ) then
		local mainSlotNo = Socket_GetSlotNo()
		local invenItemWrapper = getInventoryItem(mainSlotNo)
		if ( nil ~= invenItemWrapper ) then
			itemSSW = invenItemWrapper:getPushedItem( slotNo - 1 )
		end
	elseif ( "popupItem" == slotType ) then
		local ESSWrapper =	getPopupIteWrapper()
		if nil ~= ESSWrapper then
			itemSSW = ESSWrapper:getPopupItemAt(slotNo-1)
		end
	elseif ( "TerritoryAuth_Auction" == slotType ) then
		local myAuctionInfo = RequestGetAuctionInfo()
		itemSSW = myAuctionInfo:getTerritoryTradeitem( slotNo )
	elseif ( "Dialog_ChallengeReward_Base" == slotType ) or ( "Dialog_ChallengeReward_Select" == slotType ) then
		itemSSW = getItemEnchantStaticStatus( ItemEnchantKey(slot._item) )
	elseif ( "Dialog_ChallengePcroomReward_Base" == slotType ) or ( "Dialog_ChallengePcroomReward_Select" == slotType ) then
		itemSSW = getItemEnchantStaticStatus( ItemEnchantKey(slot._item) )
	elseif ( "DailyStamp" == slotType ) then
		itemSSW = getItemEnchantStaticStatus( ItemEnchantKey(slotNo) )
	else
		UI.ASSERT(false, "showTooltip(static)으로 정의되지 않은 slot타입(" .. slotType .. ")이 들어왔습니다. 확인해주세요.")
		return
	end

	if ( nil == itemSSW ) then
		return
	end

	local skillKey = SkillKey()
	local isSkillBook = false
	if ( true == isSSW ) and ( false == isItemWrapper ) then
		isSkillBook = itemSSW:isSkillBook(skillKey)
	else
		isSkillBook = itemSSW:getStaticStatus():isSkillBook(skillKey)
	end
	if ( isSkillBook ) then
		--스킬북이면 스킬툴팁으로 넘긴다.
		Panel_Tooltip_Item_DataObject.isSkill = true
		Panel_Tooltip_Item_DataObject.skillSlot = slot

		Panel_SkillTooltip_Show(skillKey:getSkillNo(), false, "itemToSkill", false)
		return
	end
	Panel_Tooltip_Item_DataObject.isSkill = false

	local isEquipalbeItem, servantItem = showTooltip_Item(normalTooltip, itemSSW, isSSW, isItemWrapper)
	if ( isEquipalbeItem ) then
		local equipItemWrapper = nil

		if ( servantItem ) then
			local temporaryWrapper = getTemporaryInformationWrapper()
			if	(nil ~= temporaryWrapper) and (temporaryWrapper:isSelfVehicle())	then
				if isItemWrapper or (not isSSW) then
					equipItemWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle):getEquipItem( itemSSW:getStaticStatus():getEquipSlotNo() )
				else
					equipItemWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle):getEquipItem( itemSSW:getEquipSlotNo() )
				end	
			end
		else
			if isItemWrapper or (not isSSW) then
				equipItemWrapper = getEquipmentItem(itemSSW:getStaticStatus():getEquipSlotNo())
			else
				equipItemWrapper = getEquipmentItem(itemSSW:getEquipSlotNo())
			end
		end

		if ( nil ~= equipItemWrapper ) then
			showTooltip_Item(equippedTooltip, equipItemWrapper, false, true)
		end
	end
	Panel_Tooltip_Item_Set_Position(slot.icon)
end

function Panel_Tooltip_Item_Show_General( slotNo, slotType, isOn, isNormal, index )
	Panel_Tooltip_Item_DataObject.itemMarket = nil	-- 아이템 마켓에서 열 때 처리를 위해.
	Panel_Tooltip_Item_DataObject.inventory = nil	-- 인벤에서 뜬 것을 처리하기 위해
	if ( true ~= isOn ) then
		if ( Panel_Tooltip_Item_DataObject.currentSlotNo == slotNo ) then
			Panel_Tooltip_Item_hideTooltip()
			Panel_Tooltip_Item_DataObject.currentSlotNo		= -1
			Panel_Tooltip_Item_DataObject.currentSlotType	= ""
			Panel_Tooltip_Item_DataObject.index				= -1
		end
		return false
	end

	if ( slotNo < 0 ) then
		return false
	end

	--초기화
	Panel_Tooltip_Item_hideTooltip()
	Panel_Tooltip_Item_DataObject.currentSlotNo		= slotNo
	Panel_Tooltip_Item_DataObject.currentSlotType	= slotType
	Panel_Tooltip_Item_DataObject.index				= index
	Panel_Tooltip_Item_DataObject.isNormal			= isNormal
	normalTooltip.deltaTime = 0
	equippedTooltip.deltaTime = 0
	
	local	slot	= Panel_Tooltip_Item_DataObject.slotData[slotType][slotNo]
	
	if ( nil == slot ) then
		return false;
	end
	
	if ( nil ~= slot._type ) then 
		if (UI_RewardType.RewardType_Exp==slot._type) or (UI_RewardType.RewardType_SkillExp==slot._type) or (UI_RewardType.RewardType_ProductExp==slot._type) then
			return false
		end
	end
	
	return true
end

function Panel_Tooltip_Item_chattingLinkedItem_Set_Position( positionData, parent )
	local chattingLinkedItemShow	= Panel_Tooltip_Item_chattingLinkedItem:GetShow()
	
	if (not chattingLinkedItemShow) then
		return
	end
	
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	
	local itemLinkedPosX = Panel_Tooltip_Item_chattingLinkedItem:GetSizeX()
	local itemLinkedPosY = Panel_Tooltip_Item_chattingLinkedItem:GetSizeY()
	
	local posX = positionData:GetParentPosX()
	local posY = positionData:GetParentPosY()
	if	parent	then
		posX = positionData:getParent():GetParentPosX()
		posY = positionData:getParent():GetParentPosY() - 500
	end
	
	local isLeft= (screenSizeX / 2) < posX
	local isTop	= (screenSizeY / 2) < posY
	
	if not isLeft then
		posX = posX + positionData:GetSizeX()
	end

	if isTop then
		posY = posY + positionData:GetSizeY()
		local yDiff = posY - itemLinkedPosY
		if yDiff < 0 then
			posY = posY - yDiff
		end
	else
		local yDiff = screenSizeY - ( posY + itemLinkedPosY )
		if yDiff < 0 then
			posY = posY + yDiff
		end
	end


	if Panel_Tooltip_Item_chattingLinkedItem:GetShow() then
		if isLeft then
			posX = posX - itemLinkedPosX
		end

		local yTmp = posY
		if isTop then
			yTmp = yTmp - itemLinkedPosY
		end

		Panel_Tooltip_Item_chattingLinkedItem:SetPosX(posX)
		Panel_Tooltip_Item_chattingLinkedItem:SetPosY(yTmp)
	end
	
end

function Panel_Tooltip_Item_Set_Position( positionData, parent )
	local itemShow					= Panel_Tooltip_Item:GetShow()
	local equipItemShow				= Panel_Tooltip_Item_equipped:GetShow()

	if ( not itemShow ) and ( not equipItemShow ) then
		return
	end

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	
	local itemPosX = Panel_Tooltip_Item:GetSizeX()
	local itemPosY = Panel_Tooltip_Item:GetSizeY()
	local itemEquipPosX = Panel_Tooltip_Item_equipped:GetSizeX()
	local itemEquipPosY = Panel_Tooltip_Item_equipped:GetSizeY()

	local posX = positionData:GetParentPosX()
	local posY = positionData:GetParentPosY()
	if	parent	then
		posX = positionData:getParent():GetParentPosX()
		posY = positionData:getParent():GetParentPosY() - 500
	end
	

	local isLeft= (screenSizeX / 2) < posX
	local isTop	= (screenSizeY / 2) < posY

	local tooltipSize			= { width = 0, height = 0 }
	local tooltipEquipped		= { width = 0, height = 0 }
	local sumSize				= { width = 0, height = 0 }

	if ( Panel_Tooltip_Item:GetShow() ) then
		tooltipSize.width	= Panel_Tooltip_Item:GetSizeX()
		tooltipSize.height	= Panel_Tooltip_Item:GetSizeY()

		sumSize.width	= sumSize.width + tooltipSize.width
		sumSize.height	= math.max( sumSize.height, tooltipSize.height )
	end
	if ( Panel_Tooltip_Item_equipped:GetShow() ) then
		tooltipEquipped.width	= Panel_Tooltip_Item_equipped:GetSizeX()
		tooltipEquipped.height	= Panel_Tooltip_Item_equipped:GetSizeY()

		sumSize.width	= sumSize.width + tooltipEquipped.width
		sumSize.height	= math.max( sumSize.height, tooltipEquipped.height )
	end

	if not isLeft then
		posX = posX + positionData:GetSizeX()
	end

	if isTop then
		posY = posY + positionData:GetSizeY()
		local yDiff = posY - sumSize.height
		if yDiff < 0 then
			posY = posY - yDiff
		end
	else
		local yDiff = screenSizeY - (posY + sumSize.height)
		if yDiff < 0 then
			posY = posY + yDiff
		end
	end


	if Panel_Tooltip_Item:GetShow() then
		if isLeft then
			posX = posX - tooltipSize.width
		end

		local yTmp = posY
		if isTop then
			yTmp = yTmp - tooltipSize.height
		end

		Panel_Tooltip_Item:SetPosX(posX)
		Panel_Tooltip_Item:SetPosY(yTmp)
	end

	if Panel_Tooltip_Item_equipped:GetShow() then
		if isLeft then
			posX = posX - tooltipEquipped.width
		else
			posX = posX + tooltipSize.width
		end

		local yTmp = posY
		if isTop then
			yTmp = yTmp - tooltipEquipped.height
		end

		Panel_Tooltip_Item_equipped:SetPosX(posX)
		Panel_Tooltip_Item_equipped:SetPosY(yTmp)
	end

	if ( equippedTooltip.mainPanel:GetShow() and normalTooltip.mainPanel:GetShow() ) then
		local arrow = equippedTooltip.arrow
		if ( Panel_Tooltip_Item:GetPosX() < Panel_Tooltip_Item_equipped:GetPosX() ) then
			equippedTooltip.arrow:SetShow(false)
			arrow = equippedTooltip.arrow_L
			arrow:SetShow( true )
			arrow:SetPosY( (equippedTooltip.mainPanel:GetSizeY() - arrow:GetSizeY()) / 2 )
			arrow:SetPosX( - arrow:GetSizeX() /2 )
		else
			equippedTooltip.arrow_L:SetShow(false)
			arrow = equippedTooltip.arrow
			arrow:SetShow( true )
			arrow:SetPosY( (equippedTooltip.mainPanel:GetSizeY() - arrow:GetSizeY()) / 2 )
			arrow:SetPosX( equippedTooltip.mainPanel:GetSizeX() - arrow:GetSizeX() /2 )
		end
	else
		equippedTooltip.arrow:SetShow(false)
		equippedTooltip.arrow_L:SetShow(false)
	end
end

-- 일반 아이템 툴팁 --------------------------------------------------------------------------------------------------------------------
function Panel_Tooltip_Item_hideTooltip()

	if ( Panel_Tooltip_Item_DataObject.isSkill ) then
		Panel_SkillTooltip_Hide()
		return
	end
	-- ♬ 툴팁이 닫힐 때 사운드 추가
	-- audioPostEvent_SystemUi(01,14)
	
	if Panel_Tooltip_Item:IsShow() then
		Panel_Tooltip_Item:SetShow( false, false )
		Panel_Tooltip_Item_DataObject.currentSlotNo = -1
	end
	
	if Panel_Tooltip_Item_equipped:IsShow() then
		Panel_Tooltip_Item_equipped:SetShow( false, false )
		Panel_Tooltip_Item_DataObject.currentSlotNo = -1
	end	
end

function Panel_Tooltip_Item_chattingLinkedItem_hideTooltip()
	if Panel_Tooltip_Item_chattingLinkedItem:IsShow() then
		Panel_Tooltip_Item_chattingLinkedItem:SetShow( false, false )
	end
end

function _toolTip_ChangeDyeInfoTexture( target, bEmpty, dyeingPart_Index, dyeingPartColor )
	local texturePath	= "New_UI_Common_forLua/Widget/ToolTip/ToolTip_00.dds"
	local control		= target.useDyeColorIcon_Part[dyeingPart_Index]
	if not bEmpty then
		control:ChangeTextureInfoName ( texturePath )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 75, 43, 93, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		control:SetAlphaIgnore( true )
		control:SetColor( dyeingPartColor )
	else
		control:ChangeTextureInfoName ( texturePath )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 98, 43, 116, 61 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture(control:getBaseTexture())
		control:SetAlphaIgnore( true )
		control:SetColor( UI_color.C_FFFFFFFF )
	end
end

function Panel_Tooltip_Item_ShowInfo(target, inputValue, isSSW, isItemWrapper, chattingLinkedItem, index, isNextEnchantInfo )
	-- 잔존시간 앞에 시계아이콘 표시 초기화
	normalTooltip.expireIcon_white:SetShow( false )
	normalTooltip.expireIcon_red:SetShow( false )
	normalTooltip.expireIcon_end:SetShow( false )
	
	local itemSSW = nil
	local itemWrapper = nil
	local item = nil
	local itemKeyForTradeInfo = nil
	if ( isSSW and not isItemWrapper) then
		itemSSW = inputValue
		if ( nil == itemSSW ) then
			target.mainPanel:SetShow(false, false)
			return false, false
		end
		item = itemSSW:get()
		itemKeyForTradeInfo = itemSSW:get()._key:get()
	else
		itemWrapper = inputValue
		if ( nil == itemWrapper ) then
			target.mainPanel:SetShow(false, false)
			return false, false
		end
		itemSSW = itemWrapper:getStaticStatus()
		item = itemWrapper:get()
		itemKeyForTradeInfo = itemSSW:get()._key:get()
	end

	if equippedTooltip == target and true == isNextEnchantInfo then
		equippedTooltip.equippedTag:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_NEXT_ENCHANT") ) -- "다음 강화 정보")

		local nextEnchantLevel 	= itemSSW:get()._key:getEnchantLevel()+1;	-- +1을 해줘야 다음 인첸트 정보를 가져올 수 있다.
		local enchantItemKey	= ItemEnchantKey( itemSSW:get()._key:getItemKey(), nextEnchantLevel )
		enchantItemKey:set( itemSSW:get()._key:getItemKey(), nextEnchantLevel )
		
		itemSSW					= getItemEnchantStaticStatus( enchantItemKey )	-- 아이템 정보 래퍼.
		itemKeyForTradeInfo	 	= itemSSW:get()._key:get()	-- 상/하한가 처리.

		if nil == itemSSW:get() then
			target.mainPanel:SetShow(false, false)
			return false, false
		end
	else
		equippedTooltip.equippedTag:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_CURRENT_EQUIP") ) -- "현재 장착 중인 아이템")
	end

	-- { 거래소 정보 세팅
		local tradeInfo = nil
		local tradeSummaryInfo	= getItemMarketSummaryInClientByItemEnchantKey( itemKeyForTradeInfo )
		local tradeMasterInfo	= getItemMarketMasterByItemEnchantKey( itemKeyForTradeInfo )

		if nil ~= tradeSummaryInfo then
			tradeInfo = tradeSummaryInfo
		elseif nil ~= tradeMasterInfo then
			tradeInfo = tradeMasterInfo
		else
			tradeInfo = nil
		end

		if nil ~= tradeInfo then
			local tradeMasterItemName	= tradeInfo:getItemEnchantStaticStatusWrapper():getName()
			if nil ~= tradeSummaryInfo and ( toInt64(0,0) ~= tradeSummaryInfo:getDisplayedTotalAmount() ) then
				target.tradeInfo_Value:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_TRADEINFO_REGISTPRICE", "highestOnePrice", makeDotMoney( tradeInfo:getDisplayedHighestOnePrice() ), "LowestOnePrice", makeDotMoney( tradeInfo:getDisplayedLowestOnePrice() ) ) ) -- "등록가 : <PAColor0xff985551>" .. makeDotMoney( tradeInfo:getDisplayedLowestOnePrice() ) .. " 은화<PAOldColor> ~ <PAColor0xff447a5b>" .. makeDotMoney( tradeInfo:getDisplayedHighestOnePrice() ) .. " 은화<PAOldColor>"
			else
				target.tradeInfo_Value:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_TRADEINFO_HIGHANDLOWPRICE", "getMaxPrice", makeDotMoney(tradeMasterInfo:getMaxPrice()), "getMinPrice", makeDotMoney(tradeMasterInfo:getMinPrice()) ) ) -- "상/하한가 : <PAColor0xff985551>" .. makeDotMoney(tradeMasterInfo:getMinPrice()) .. " 은화<PAOldColor> ~ <PAColor0xff447a5b>" .. makeDotMoney(tradeMasterInfo:getMaxPrice()) .. " 은화<PAOldColor>"
			end
			target.tradeInfo_Panel:SetShow( true )
			target.tradeInfo_Title:SetShow( true )
			target.tradeInfo_Value:SetShow( true )
		else
			target.tradeInfo_Panel:SetShow( false )
			target.tradeInfo_Title:SetShow( false )
			target.tradeInfo_Value:SetShow( false )
		end
	-- }

	--{ 장신구 일때
		target.equipSlotName:SetShow( false )
		if 1 == itemSSW:getItemType() then
			local EquipslotNo = itemSSW:getEquipSlotNo()
			if 21 == EquipslotNo then
				target.equipSlotName:SetShow( true )
				target.equipSlotName:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPSLOTNAME_HEAD") ) -- "<PAColor0xffffebbc>- 착용 부위 :<PAOldColor> <PAColor0xffc4bebe>머리, 귀<PAOldColor>" )
			elseif 22 == EquipslotNo then
				target.equipSlotName:SetShow( true )
				target.equipSlotName:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPSLOTNAME_EYES") ) -- "<PAColor0xffffebbc>- 착용 부위 :<PAOldColor> <PAColor0xffc4bebe>눈, 코<PAOldColor>" )
			elseif 23 == EquipslotNo then
				target.equipSlotName:SetShow( true )
				target.equipSlotName:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPSLOTNAME_MOUSE") ) -- "<PAColor0xffffebbc>- 착용 부위 :<PAOldColor> <PAColor0xffc4bebe>입, 턱<PAOldColor>" )
			end
		end
	--}


	local classType = getSelfPlayer():getClassType()
	--데이터입력

	-- { 아이템의 등급에 따라 아이템명에 색상으로 구분
		local nameColorGrade = itemSSW:getGradeType()
		if ( 0 == nameColorGrade ) then
			target.itemName:SetFontColor(UI_color.C_FFFFFFFF)
		elseif ( 1 == nameColorGrade ) then
			target.itemName:SetFontColor(4284350320)
		elseif ( 2 == nameColorGrade ) then
			target.itemName:SetFontColor(4283144191)
		elseif ( 3 == nameColorGrade ) then
			target.itemName:SetFontColor(4294953010)
		elseif ( 4 == nameColorGrade ) then
			target.itemName:SetFontColor(4294929408)
		else
			target.itemName:SetFontColor(UI_color.C_FFFFFFFF)
		end
	-- }
	
	target.itemIcon:ChangeTextureInfoName( "icon/" .. itemSSW:getIconPath() )								-- 아이템 아이콘

	-- { 인챈트 레벨 처리	
		local enchantLevel = itemSSW:get()._key:getEnchantLevel()
		if 0 < enchantLevel and enchantLevel < 16 then
			target.enchantLevel:SetText( "+" .. tostring(enchantLevel) )										-- 인챈트 수치
			target.enchantLevel:SetShow(true)
		elseif 16 == enchantLevel then
			target.enchantLevel:SetText( "I" )		-- 인챈트 수치
			target.enchantLevel:SetShow(true)
		elseif 17 == enchantLevel then
			target.enchantLevel:SetText( "II" )		-- 인챈트 수치
			target.enchantLevel:SetShow(true)
		elseif 18 == enchantLevel then
			target.enchantLevel:SetText( "III" )		-- 인챈트 수치
			target.enchantLevel:SetShow(true)
		elseif 19 == enchantLevel then
			target.enchantLevel:SetText( "IV" )		-- 인챈트 수치
			target.enchantLevel:SetShow(true)
		elseif 20 == enchantLevel then
			target.enchantLevel:SetText( "V" )		-- 인챈트 수치
			target.enchantLevel:SetShow(true)
		-- elseif 20 <= enchantLevel then
		-- 	target.enchantLevel:SetText( "VI" )		-- 인챈트 수치
		-- 	target.enchantLevel:SetShow(true)
		else
			target.enchantLevel:SetShow(false)
		end
		-- { 액세서리일 경우 인챈트 표기를 달리 해준다!
			if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
				if 1 == enchantLevel then
					target.enchantLevel:SetText( "I" )		-- 인챈트 수치
					target.enchantLevel:SetShow(true)
				elseif 2 == enchantLevel then
					target.enchantLevel:SetText( "II" )		-- 인챈트 수치
					target.enchantLevel:SetShow(true)
				elseif 3 == enchantLevel then
					target.enchantLevel:SetText( "III" )		-- 인챈트 수치
					target.enchantLevel:SetShow(true)
				elseif 4 == enchantLevel then
					target.enchantLevel:SetText( "IV" )		-- 인챈트 수치
					target.enchantLevel:SetShow(true)
				elseif 5 == enchantLevel then
					target.enchantLevel:SetText( "V" )		-- 인챈트 수치
					target.enchantLevel:SetShow(true)
				end
			end
		-- }
	-- }
	
	-- { 캐시 아이템은 강화 수치를 표시하지 않음!!
		if itemSSW:get():isCash() then
			target.enchantLevel:SetShow( false )
		end
	-- }

	-- { 아이템 이름 처리
		target.itemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
		if 1 == itemSSW:getItemType() and 15 < enchantLevel then -- 장비이고, 강화수치가 14보다 크면
			target.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemSSW:getName() )		-- 아이템 이름
		elseif 0 < enchantLevel and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then -- 액세서리이고, 강화수치가 0보다 크면
			target.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel+15) .. " " .. itemSSW:getName() )		-- 아이템 이름
		else
			target.itemName:SetText( itemSSW:getName() )															-- 아이템 이름
		end
		
		local changeItemNamePos = 25
		if (1 < target.itemName:GetLineCount()) then
			changeItemNamePos = (target.itemName:GetLineCount() * 11) + 25
		end
	-- }

	-- { 아이템 타입
		local item_type = itemSSW:getItemType()
		local isTradeItem = itemSSW:isTradeAble()
		if item_type == 1 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIPMENT" ) )				-- "장착류"
		elseif item_type == 2 then
			if isTradeItem == true then
				target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM" ) )			-- "무역품"
			else
				target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_CONSUME" ) )				--"소모성"
			end
		elseif item_type == 3 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_TENT_TOOL" ) )				--"텐트도구"
		elseif item_type == 4 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_INSTALL_TOOL" ) )			-- "설치도구"
		elseif item_type == 5 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_SOCKET_ITEM" ) )				-- "소켓 아이템"
		elseif item_type == 6 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_CANNONBALL" ) )				-- "포 탄"
		elseif item_type == 7 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_LICENCE" ) )					-- "등록증"
		elseif item_type == 8 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCTION" ) )				-- "제작재료"
		elseif item_type == 9 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_ENTER_AIR" ) ) 				-- "공간진입"
		elseif item_type == 10 then
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_SPECIAL_PRODUCTION" ) )		-- "특수상품"
		elseif true == itemSSW:get():isForJustTrade() then				-- 일반 아이템 중 무역이 가능한 아이템(금주화 등)
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOMAL" ) .. "/" .. PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM" ))
		else
			target.itemType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOMAL" ) ) 					-- "일반"
		end

		if (item_type == 8) and (true == itemSSW:get():isForJustTrade()) then	-- 제작 재료 중 무역을 할 수 있으면. 
			target.itemType:SetText( target.itemType:GetText() .. "/" .. PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM" ) )
		end
	-- }

	--local isPossibleToEnchant = itemSSW:get():isEnchantable()
	
	-- 장비 아이템만 강화 표시
	--[[
	if itemSSW:isEquipable() then
		if isPossibleToEnchant == false then
			target.isEnchantable:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_ENCHANT" ) )			-- "강화 불가"
		else
			if ( not isSSW ) then
				if ( itemWrapper:get():isEnchantable() ) then
					target.isEnchantable:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_ABLE_ENCHANT" ) )	-- "강화 가능"
				else
					target.isEnchantable:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_ENCHANT" ) )
				end
			else
				target.isEnchantable:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_ABLE_ENCHANT" ) )		-- "강화 가능"-- 강화 여부
			end
		end
		target.isEnchantable:SetShow( true )
	else
		target.isEnchantable:SetShow( false )
	end
	]]--
	
	-- { 장비 아이템만 각인 표시
		target.isSealed:SetShow(false)
		if itemSSW:isEquipable() and (not isSSW) then
			if item:isSealed() then
				target.isSealed:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_ISEQUIPSEAL") ) -- "각인" )
				target.isSealed:SetShow( true )
			end
		end
	-- }

	-- { 강화 가능 여부
		target.isEnchantable:SetShow( false )
		local isPossibleToEnchant = itemSSW:get():isEnchantable()
		if itemSSW:isEquipable() then	-- 장비 아이템만 강화 불가능 메시지
			if isPossibleToEnchant == false then
				target.isEnchantable:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_ENCHANT" ) )			-- "강화 불가"
				target.isEnchantable:SetShow( true )
			else
				target.isEnchantable:SetShow( false )
			end
		end
	-- }

	-- { 설치도구면 인테리어 포인트 표시
		local interiorPoint = 0
		if itemSSW:get():isItemInstallation() then
			interiorPoint = itemSSW:getCharacterStaticStatus():getObjectStaticStatus():getInteriorSensPoint()
			if ( 0 < interiorPoint ) then
				target.isEnchantable:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_INTERIOR_POINT" ) .. interiorPoint .. " Point" )
				target.isEnchantable:SetShow( true )
			end
		elseif not target.isEnchantable:GetShow() then
			target.isEnchantable:SetShow( false )
		end
	-- }

	-- local disassembled = itemSSW:get():isDisassembleItem()																-- 분해 가능 여부
	-- if disassembled == true then
		-- target.disassembleType:SetText( " " )			-- 분해 가능
	-- else
		-- target.disassembleType:SetText( " " )				-- 분해 불가
	-- end

	-- { 귀속 처리
		local itemBindType = itemSSW:get()._vestedType:getItemKey()															-- 귀속 여부
		if ( not isSSW ) and ( item:isVested() ) then
			if itemSSW:isUserVested() then
				target.bindType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_HOLDED_FAMILYACOUNT" ) )	-- - 귀속됨(가문)
			else
				-- target.bindType:SetText(  )
				target.bindType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_HOLDED" ) ) 				-- 귀속됨(캐릭터)
			end
			target.bindType:SetShow(true)
		else
			if itemBindType == 1 then -- 획득시 귀속
				if ( isSSW ) and ( itemSSW:isUserVested() ) then
					target.bindType:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_GETBIND_FAMILY") ) -- "- 획득시 귀속(가문)")
					target.bindType:SetShow( true )
				else
					target.bindType:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_GETBIND_CHARACTER") ) -- "- 획득시 귀속(캐릭터)")
					target.bindType:SetShow( true )
				end
				-- target.bindType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_GETTIME_HOLDED" ) )			-- 획득시 귀속
				-- target.bindType:SetShow(true)
			elseif itemBindType == 2 then -- 장착시 귀속
				if ( isSSW ) and ( itemSSW:isUserVested() ) then
					target.bindType:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPBIND_FAMILY") ) -- "- 장착시 귀속(가문)" )
					target.bindType:SetShow( true )
				else
					target.bindType:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPBIND_CHARACTER") ) -- "- 장착시 귀속(캐릭터)" )
					target.bindType:SetShow( true )
				end
				-- target.bindType:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIPTIME_HOLDED" ) )		-- 장착시 귀속
				-- target.bindType:SetShow(true)
			else
				target.bindType:SetShow(false)
			end
		end
	-- }

	-- { 개인 거래 가능 여부
		target.personalTrade:SetShow( false )	-- 기본은 꺼둔다.
		if isUsePcExchangeInLocalizingValue() or CppEnums.CountryType.DEV == getGameServiceType() then	-- 개발이거나 개인거래가 가능한 국가이면
			target.personalTrade:SetShow( true )
			if nil ~= itemWrapper then
				if itemSSW:isPersonalTrade() and not itemWrapper:get():isVested() then	-- item
					target.personalTrade:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_PERSONALTRADE_ENABLE") )
				else
					target.personalTrade:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_PERSONALTRADE_DISABLE") )
				end
			elseif nil ~= itemSSW then
				if itemSSW:isPersonalTrade() then	-- item
					target.personalTrade:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_PERSONALTRADE_ENABLE") )
				else
					target.personalTrade:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_PERSONALTRADE_DISABLE") )
				end
			end
		end
	-- }

	-- 염색 정보는 방어구와 무기에만 노출한다.
	-- local isDyeAbleItem     = false
	-- if itemSSW:isEquipable() and itemSSW:isDyeable() then
	-- 	isDyeAbleItem	= true
	-- end

	-- { 염색 정보
		target.useDyeColorTitle:SetShow( false )
		target.useDyeColorIcon_Part[0]:SetShow( false )
		target.useDyeColorIcon_Part[1]:SetShow( false )
		target.useDyeColorIcon_Part[2]:SetShow( false )
		target.useDyeColorIcon_Part[3]:SetShow( false )
		target.useDyeColorIcon_Part[4]:SetShow( false )
		target.useDyeColorIcon_Part[5]:SetShow( false )
		target.useDyeColorIcon_Part[6]:SetShow( false )
		target.useDyeColorIcon_Part[7]:SetShow( false )
		target.useDyeColorIcon_Part[8]:SetShow( false )
		target.useDyeColorIcon_Part[9]:SetShow( false )
		target.useDyeColorIcon_Part[10]:SetShow( false )
		target.useDyeColorIcon_Part[11]:SetShow( false )

		target.dying:SetShow( false )
		if nil ~= itemWrapper or nil ~= chattingLinkedItem then
			local dyeAble = itemSSW:isDyeable()
			if itemSSW:isEquipable() then
				local dyeingPartCount = 0
				if nil ~= itemWrapper then
					dyeingPartCount = itemWrapper:getDyeingPartCount()
				elseif nil ~= chattingLinkedItem then
					dyeingPartCount = chattingLinkedItem:getDyeingPartCount()
				end
				if true == dyeAble then
					for dyeingPart_Index = 0, dyeingPartCount-1, 1 do
						local bEmpty = false

						if nil ~= itemWrapper then
							bEmpty = itemWrapper:isEmptyDyeingPartColorAt( dyeingPart_Index )
							if not itemWrapper:isAllreadyDyeingSlot( dyeingPart_Index ) then
								bEmpty = true
							end
						elseif nil ~= chattingLinkedItem then
							bEmpty = chattingLinkedItem:isEmptyDyeingPartColorAt( dyeingPart_Index )
							if not chattingLinkedItem:isAllreadyDyeingSlot( dyeingPart_Index ) then
								bEmpty = true
							end
						end
						
						if not bEmpty then
							target.dying:SetShow( true )
							
							local dyeingPartColor = nil
							if nil ~= itemWrapper then
								dyeingPartColor = itemWrapper:getDyeingPartColorAt( dyeingPart_Index )
							elseif nil ~= chattingLinkedItem then
								dyeingPartColor = chattingLinkedItem:getDyeingPartColorAt( dyeingPart_Index )
							end
							_toolTip_ChangeDyeInfoTexture( target, bEmpty, dyeingPart_Index, dyeingPartColor )
						else
							_toolTip_ChangeDyeInfoTexture( target, bEmpty, dyeingPart_Index, UI_color.C_FFFFFFFF )
						end
						target.useDyeColorIcon_Part[dyeingPart_Index]:SetShow( true )
					end
					if 0 < dyeingPartCount then
						local isPearlPallete	= ""
						if nil ~= itemWrapper then
							if itemWrapper:isExpirationDyeing() then
								isPearlPallete = "(" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_DYEINGPACKEAGE_TITLE") .. ")"
							end
						end
						
						target.useDyeColorTitle:SetShow( true )
						target.useDyeColorTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_DYE_DYEINFO") .. isPearlPallete ) -- "- 염색 정보" )
					end
				else
					target.useDyeColorTitle:SetShow( true )
					target.useDyeColorTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_DYE_DYEIMPOSSIBLE") ) --  "- 염색 불가" )
				end
			else
				-- target.useDyeColorTitle:SetShow( true )
				-- target.useDyeColorTitle:SetText( "- 염색 불가" )
				-- if true == dyeAble then
				-- 	local dyeingPartCount = 0
				-- 	if nil ~= itemWrapper then
				-- 		dyeingPartCount = itemWrapper:getDyeingPartCount()
				-- 	elseif nil ~= chattingLinkedItem then
				-- 		dyeingPartCount = chattingLinkedItem:getDyeingPartCount()
				-- 	end
				-- 	if 0 < dyeingPartCount then
				-- 		target.useDyeColorTitle:SetShow( true )
				-- 		target.useDyeColorTitle:SetText( "- 염색 정보" )
				-- 	end
				-- end
			end
		end
	-- }

	-- { 사용 제한
		local useLimitShow = false -- 이값으로 틀전체를 보여줄지 말지 확인한다.

		local minLevel			= itemSSW:get()._minLevel
		local isExistMaxLevel	= itemSSW:get():isMaxLevelRestricted()
		local myInfo			= getSelfPlayer()
		local myLevel			= myInfo:get():getLevel()
		local minLevelString	= tostring(minLevel)
		local jewelLevel		= 0
		local maxLevel			= itemSSW:get()._maxLevel
		local maxLevelString	= tostring(maxLevel)

		if ( not isSSW ) then
			jewelLevel = item:getJewelValidLevel()
			if ( 0 ~= jewelLevel) then
				minLevelString = minLevelString .. "(" .. tostring( minLevel + jewelLevel ) .. ")"
			end
		end

		if isExistMaxLevel == true then
			if ( not isSSW ) and (0 ~= jewelLevel) then
				maxLevelString = maxLevelString .. "(" .. tostring( maxLevel + jewelLevel ) .. ")"
			end
			--target.useLimit_level_value:SetText( minLevelString .. " 레벨부터 " .. maxLevelString .. " 레벨까지 사용가능" )		-- 아이템 사용 레벨 제한
			target.useLimit_level_value:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "PANEL_TOOLTIP_USEITEM_LIMIT", "minLevel", minLevelString, "maxLevel", maxLevelString ) ) -- minLevelString .. " 레벨부터 " ..  maxLevelString .. " 레벨까지 사용가능" 		-- 아이템 사용 레벨 제한
			target.useLimit_level_value:SetShow(true)
			target.useLimit_level:SetShow(true)
			useLimitShow = true

			if maxLevel > myLevel then
				-- target.itemName:SetFontColor( UI_color.C_FFC4BEBE )
				target.useLimit_level_value:SetFontColor( UI_color.C_FFC4BEBE )
			end
		else
			if ( 1 < minLevel  ) then
				if myLevel < minLevel then
					target.useLimit_level_value:SetFontColor( UI_color.C_FFF26A6A )								-- 0xffbf6464 (빨간색)
				else
					target.useLimit_level_value:SetFontColor( UI_color.C_FFC4BEBE )
				end
				target.useLimit_level_value:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "PANEL_TOOLTIP_USEITEM_FROM", "limitLevel", minLevelString ) )	--minLevelString .. " 레벨부터 사용가능"
				target.useLimit_level_value:SetShow(true)
				target.useLimit_level:SetShow(true)
				useLimitShow = true
			else
				target.useLimit_level_value:SetShow(false)
				target.useLimit_level:SetShow(false)
			end
		end

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
							[7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE"),
							[8] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GROWTH"),
						}

		local craftType = itemSSW:get():getLifeExperienceType()								-- 조건이 여러 개 붙으면 이 부분 array로 수정해야 함
		local lifeminLevel = itemSSW:get():getLifeMinLevel( craftType )
		
		if ( 0 < lifeminLevel ) then
			local myLifeLevel = myInfo:get():getLifeExperienceLevel(craftType)
			target.useLimit_level_value:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "PANEL_TOOLTIP_USELIMIT_LEVEL_VALUE", "craftType", lifeType[craftType], "lifeminLevel", FGlobal_CraftLevel_Replace(lifeminLevel, craftType) ) )  -- "- " .. lifeType[craftType] .. " 레벨 " .. craftLevel_Replace(lifeminLevel) .. " 부터 착용 가능"
			target.useLimit_level_value:SetShow(true)
			target.useLimit_level:SetShow(true)
			useLimitShow = true

			if ( lifeminLevel > myLifeLevel ) then
				-- target.itemName:SetFontColor( UI_color.C_FFC4BEBE )
				target.useLimit_level_value:SetFontColor( UI_color.C_FFF26A6A )
			else
				target.useLimit_level_value:SetFontColor( UI_color.C_FFC4BEBE )
			end
		end
	-- }

	-- { 확장 슬롯 설명
		local item_type = itemSSW:getItemType()
		local equip = {
				slotNoId = 
					{
						[0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_MAINHAND"),
						[1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_SUBHAND"),
						[2] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_PICKINGTOOLS"),
				
						[3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_UPPERBODY"),
						[4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_GLOVES"),
						[5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_BOOTS"),
						[6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_HELM"),
					
						[7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_NECKLACE"),
						[8] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_RING"),
						[9] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_RING"),
						[10] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EARRING"),
						[11] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EARRING"),
						[12] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_WAISTBAND"),
						[13] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_LANTERN"),
					
						[14] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_UPPERBODY"),
						[15] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_GLOVES"),
						[16] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_BOOTS"),
						[17] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_HELM"),

						[18] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_MAINHAND"),
						[19] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_SUBHAND"),
					},
		
				-- 컨트롤들
				extendedSlotInfoArray = {},
				checkExtendedSlot = 0,
		}
		
		target.useLimit_extendedslot_value:SetShow(false)
		
		if ( 1 == item_type ) then
			local itemName = itemSSW:getName()
			local slotNoMax = itemSSW:getExtendedSlotCount()
			local extendedSlotString = ""
			local compareSlot = {}
			for i = 1, slotNoMax do
				local extendSlotNo = itemSSW:getExtendedSlotIndex(i-1)		
				if( slotNoMax ~= extendSlotNo ) then
					equip.extendedSlotInfoArray[extendSlotNo] = i
					equip.checkExtendedSlot = 1
					compareSlot[i] = extendSlotNo
					local compareCheck = false
					if ( 1 == i ) then
						extendedSlotString = extendedSlotString .. ", " .. equip.slotNoId[extendSlotNo]
					elseif ( 1 < i ) then
						--for compareIndex = 1, i-1 do
							--if ( compareSlot[compareIndex] == extendSlotNo ) then
								--compareCheck = true
							--end
						--end
						--if ( false == compareCheck ) then
							extendedSlotString = extendedSlotString .. ", " .. equip.slotNoId[extendSlotNo]
						--end
					end
				end
			end
			if ( 1 == equip.checkExtendedSlot ) then
				local selfSlotNo = itemSSW:getEquipSlotNo()
				equip.extendedSlotInfoArray[selfSlotNo] = selfSlotNo
				target.useLimit_extendedslot_value:SetText ( PAGetStringParam2( Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EXTENDEDSLOT", "selfSlotNo", equip.slotNoId[selfSlotNo], "extendedSlotString", extendedSlotString ) )
				target.useLimit_extendedslot_value:SetShow(true)
				useLimitShow = true
			else
				target.useLimit_extendedslot_value:SetShow(false)
			end
		end
	-- }
	
	-- { 클래스 제한
		local isAllClass = true
		local classNameList = nil
		for idx = 0, getCharacterClassCount() -1 do
		    local classType = getCharacterClassTypeByIndex(idx)
			local className = getCharacterClassName(classType)
			if ( nil ~= className ) and ( "" ~= className ) and ( " " ~= className ) then
				if ( itemSSW:get()._usableClassType:isOn(classType) ) then
					if ( nil == classNameList ) then
						classNameList = className
					else
						classNameList = classNameList .. ", " .. className
					end
				else
					isAllClass = false
				end
			end
		end

		if ( isAllClass ) or ( nil == classNameList ) then
			target.useLimit_class_value:SetShow(false)
			target.useLimit_class:SetShow(false)
		else
			useLimitShow = true
			target.useLimit_class_value:SetTextMode(UI_TM.eTextMode_AutoWrap)
			target.useLimit_class_value:SetShow(true)
			target.useLimit_class:SetShow(true)
			
			
			-- target.useLimit_class_value:SetPosY(target.useLimitClassPosY)
			
			-- UI.debugMessage(target.useLimitClassPosY)

			local isUsableClass = itemSSW:get()._usableClassType:isOn(classType)
			if isUsableClass == false then
				target.useLimit_class_value:SetFontColor( UI_color.C_FFF26A6A )																				-- 자기가 해당 안되면 빨간색 표시
			else
				target.useLimit_class_value:SetFontColor( UI_color.C_FFC4BEBE )
			end

			if ( nil ~= classNameList ) then
				target.useLimit_class_value:SetText("- "..classNameList .." ".. PAGetString( Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_CLASSONLY" ) )
			else
				target.useLimit_class_value:SetText(" ")
			end
		end
	-- }

	-- { 가격 보증 기간/유효기간 처리
		if ( not isSSW ) then
			-- TickCount 는 1/1000 초 단위. uint64
			if item:getExpirationDate():isIndefinite() then
				target.remainTime_value:SetShow(false)
				target.remainTime:SetShow(false)
				-- useLimitShow = false
			else
				-- TTime64 는 초단위. int64
				local s64_remainingTime = getLeftSecond_s64( item:getExpirationDate() );
				local fontColor			= UI_color.C_FFC4BEBE -- 회색
				local itemExpiration = item:getExpirationDate()
				local leftPeriod = FromClient_getTradeItemExpirationDate( itemExpiration, itemWrapper:getStaticStatus():get()._expirationPeriod )
				
				if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
					target.remainTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_REMAINTIME_PRICEREMAIN") ) -- "- 가격 보증 기간 : " )
				else
					target.remainTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_REMAINTIME_REMAINTIME") ) -- "- 유효 기간 : " )
				end

				if	Defines.s64_const.s64_0 == s64_remainingTime	then
					if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
						target.remainTime_value:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_REMAIN_TIME" ) .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") .. " : " .. leftPeriod/10000 .. " %)" )
					else
						target.remainTime_value:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_REMAIN_TIME" ) )
					end
					fontColor = UI_color.C_FFF26A6A	-- 기간이 다 됐다! 빨간색
				else
					if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
						target.remainTime_value:SetText( convertStringFromDatetime( s64_remainingTime )  .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") .." : ".. leftPeriod/10000 .. " %)" )
					else
						target.remainTime_value:SetText( convertStringFromDatetime( s64_remainingTime ) )
					end
				end
				
				target.remainTime_value:SetFontColor(fontColor);
				target.remainTime_value:SetShow(true)
				target.remainTime:SetShow(true)
				useLimitShow = true
				-- else

				-- 	target.remainTime_value:SetShow(false)
				-- 	target.remainTime:SetShow(false)
				-- 	-- useLimitShow = false
				-- end
			end
		else
			target.remainTime_value:SetShow(false)
			target.remainTime:SetShow(false)
		end
		target.useLimit_category:SetShow(false)
		target.useLimit_panel:SetShow(useLimitShow)
	-- }

	-- { 공격력 / 방어력
		local attackShow = false
		local defenseShow = false

		local attackString = ""
		local minAttack = 0
		local maxAttack = 0
		for idx = 0 , 2 do	-- 능력 차이를 보여주는???
			local currentMin = itemSSW:getMinDamage(idx)
			if ( minAttack < currentMin ) then
				minAttack = currentMin
			end

			local currentMax = itemSSW:getMaxDamage(idx)
			if ( maxAttack < currentMax ) then
				maxAttack = currentMax
			end

			--공격력 타입 아이콘 표시 (클베버전 주석 처리)
			-- if ( 0 == idx ) then
				-- target.isMeleeAttack:SetShow( currentMin ~= 0 or currentMax ~= 0 )
			-- elseif ( 1 == idx ) then
				-- target.isRangeAttack:SetShow( currentMin ~= 0 or currentMax ~= 0 )
			-- elseif ( 2 == idx ) then
				-- target.isMagicAttack:SetShow( currentMin ~= 0 or currentMax ~= 0 )
			-- end
		end
		if ( 0 ~= maxAttack ) and ( 0 ~= minAttack ) then
			attackShow = true
		end

		-- 무사용 각궁은 0번으로 써야 한다.
		if 1 == itemSSW:getItemType() and 36 == itemSSW:getEquipType() then -- getEquipType() , getItemType()
			minAttack = itemSSW:getMinDamage(0)
			maxAttack = itemSSW:getMaxDamage(0)
		end
		
		attackString = tostring(minAttack) .. " ~ " .. tostring(maxAttack)
		target.attack_value:SetText( attackString )														-- 공격력
		target.attack_value:SetShow( attackShow )
		target.attack:SetShow( attackShow )
		target.att_Value = (maxAttack + minAttack) / 2
		
		local defenseString = ""
		local def_value = 0
		if ( item_type == 1 ) then
			for idx = 0, 2 do
				local currentdef_value = itemSSW:getDefence(idx)
				if ( def_value < currentdef_value ) then
					def_value = currentdef_value
				end
			end
		end
		if ( 0 ~= def_value ) then
			defenseShow = true
		end
		defenseString = tostring(def_value)
		target.defense_value:SetText( defenseString )													-- 방어력
		target.defense_value:SetShow( defenseShow )
		target.defense:SetShow( defenseShow )
		target.def_Value = def_value
		
		local gotWeight = itemSSW:get()._weight
		-- if ( gotWeight <= 899  ) then
			-- target.weight		:SetShow( false )
			-- target.weight_value	:SetShow( false )
		-- elseif 10000

		if 99 < gotWeight then
			target.weight		:SetShow( true )
			target.weight_value	:SetShow( true )
			local calcWeight = gotWeight / 10000
			target.weight_value	:SetText( string.format("%.2f", calcWeight) .. " LT")																				-- 무게
		else
			target.weight		:SetShow( true )
			target.weight_value	:SetShow( true )
			local calcWeight = gotWeight / 10000
			target.weight_value	:SetText( string.format("%.2f", calcWeight) .. " LT")
		end
		target.wei_Value = gotWeight / 10000

		if itemSSW:get():isCash() then
			target.weight		:SetShow( false )
			target.weight_value	:SetShow( false )
		end

		-- 장비 아이템 비교해 수치 차이 표시
		-- 장비 비교 창이 뜰 때만 비교해준다. 단, 채집 장비 예외
		if Panel_Tooltip_Item_equipped:GetShow() then
			local _weightPoint = 0
			local _offencePoint = 0
			local _defencePoint = 0
			
			if ( 0 == normalTooltip.att_Value ) then
				_offencePoint = 0
			else
				_offencePoint = normalTooltip.att_Value - equippedTooltip.att_Value
			end
			if ( 0 == normalTooltip.def_Value ) then
				_defencePoint = 0
			else
				_defencePoint = normalTooltip.def_Value - equippedTooltip.def_Value
			end
			_weightPoint = normalTooltip.wei_Value - equippedTooltip.wei_Value
			
			if ( 0 < _weightPoint ) then
				_weightPoint = "<PAColor0xFFFF0000>▲" .. string.format("%.2f", _weightPoint) .. "<PAOldColor>"
			elseif	( 0 > _weightPoint ) then
				_weightPoint = "<PAColor0xFFFFCE22>▼" .. string.format("%.2f", _weightPoint * (-1)) .. "<PAOldColor>"
			end
				
			if ( 0 ~= _offencePoint ) and ( 0 == _defencePoint ) then
				if ( 0 < _offencePoint ) then
					_offencePoint = "<PAColor0xFFFFCE22>▲" .. _offencePoint .. "<PAOldColor>"
				elseif ( 0 > _offencePoint ) then
					_offencePoint = "<PAColor0xFFFF0000>▼" .. _offencePoint * (-1) .. "<PAOldColor>"
				end
				attackString = "(" .. _offencePoint .. " )"
				normalTooltip.attack_diffValue:SetText( attackString )													-- 공격력
				normalTooltip.attack_diffValue:SetShow( true )
				normalTooltip.defense_diffValue:SetText( "" )
				normalTooltip.defense_diffValue:SetShow( false )
			elseif ( 0 ~= _offencePoint ) and ( 0 ~= _defencePoint ) then
				if ( 0 < _offencePoint ) then
					_offencePoint = "<PAColor0xFFFFCE22>▲" .. _offencePoint .. "<PAOldColor>"
				elseif ( 0 > _offencePoint ) then
					_offencePoint = "<PAColor0xFFFF0000>▼" .. _offencePoint * (-1) .. "<PAOldColor>"
				end
				if ( 0 < _defencePoint ) then
					_defencePoint = "<PAColor0xFFFFCE22>▲" .. _defencePoint .. "<PAOldColor>"
				elseif ( 0 > _defencePoint ) then
					_defencePoint = "<PAColor0xFFFF0000>▼" .. _defencePoint * (-1) .. "<PAOldColor>"
				end
				attackString = "(" .. _offencePoint .. " )"
				normalTooltip.attack_diffValue:SetText( attackString )													-- 공격력
				defenseString = "(" .. _defencePoint .. " )"
				normalTooltip.defense_diffValue:SetText( defenseString )													-- 방어력
				normalTooltip.attack_diffValue:SetShow( true )
				normalTooltip.defense_diffValue:SetShow( true )
			elseif( 0 == _offencePoint ) and ( 0 ~= _defencePoint ) then
				if ( 0 < _defencePoint ) then
					_defencePoint = "<PAColor0xFFFFCE22>▲" .. _defencePoint .. "<PAOldColor>"
				elseif ( 0 > _defencePoint ) then
					_defencePoint = "<PAColor0xFFFF0000>▼" .. _defencePoint * (-1) .. "<PAOldColor>"
				end
				defenseString = "(" .. _defencePoint .. " )"
				normalTooltip.defense_diffValue:SetText( defenseString )													-- 방어력
				normalTooltip.attack_diffValue:SetText( "" )
				normalTooltip.attack_diffValue:SetShow( false )
				normalTooltip.defense_diffValue:SetShow( true )
			else
				normalTooltip.attack_diffValue:SetShow( false )
				normalTooltip.defense_diffValue:SetShow( false )
			end
			if ( 0 ~= _weightPoint ) then
				normalTooltip.weight_diffValue:SetText( " (" .. _weightPoint .. " )" )		-- 무게
				normalTooltip.weight_diffValue:SetShow( true )
			end
			if ( 0 == normalTooltip.att_Value ) and ( 0 == normalTooltip.def_Value ) then
				normalTooltip.attack_diffValue:SetShow( false )
				normalTooltip.defense_diffValue:SetShow( false )
				normalTooltip.weight_diffValue:SetShow( false )
			end
		else
			normalTooltip.attack_diffValue:SetShow( false )
			normalTooltip.defense_diffValue:SetShow( false )
			normalTooltip.weight_diffValue:SetShow( false )
		end
	-- }
	
	-- { 소켓 정보
		local soketCount = 0
		if ( false == itemSSW:get()._enchant:empty() ) then
			soketCount = itemSSW:get()._enchant._socketCount
		end
		local itemEnchantSSW = nil
		if ( not isSSW ) then
			soketCount = item:getUsableItemSocketCount()
		end
		
		for jewelIdx = 0 , 5 do
			if ( not isSSW ) then
				itemEnchantSSW = itemWrapper:getPushedItem(jewelIdx)                	 --박힌 소켓정보
			else
				itemEnchantSSW = nil
				if isItemWrapper or nil ~= chattingLinkedItem then
					local pushedKey = nil
					if isItemWrapper then
						pushedKey = item:getPushedKey(jewelIdx)
					elseif nil ~= chattingLinkedItem then
						pushedKey = chattingLinkedItem:getPushedKey(jewelIdx)
					end
					
					if (pushedKey ~= nil and 0 <pushedKey:get()) then
						itemEnchantSSW =  getItemEnchantStaticStatus(pushedKey)
					end
				end
			end

			if nil ~= Panel_Tooltip_Item_DataObject.itemMarket then	-- 아이템 마켓에서 열리면 소켓 정보를 초기화한다.
				itemEnchantSSW = nil
			end

			if ( soketCount <= jewelIdx ) then
				target.soketName[jewelIdx +1]:SetShow(false)
				target.soketEffect[jewelIdx +1]:SetShow(false)
				target.soketSlot[jewelIdx +1]:SetShow(false)
			elseif ( nil ~= itemEnchantSSW ) then
				target.soketName[jewelIdx +1]:SetShow(true)
				target.soketEffect[jewelIdx +1]:SetShow(true)
				target.soketSlot[jewelIdx +1]:SetShow(true)

				target.soketName[jewelIdx +1]:SetText(itemEnchantSSW:getName())
				target.soketSlot[jewelIdx +1]:ChangeTextureInfoName( "icon/" .. itemEnchantSSW:getIconPath() )
				local x1, y1, x2, y2 = setTextureUV_Func( target.soketSlot[jewelIdx +1], 0, 0, 42, 42 )
				target.soketSlot[jewelIdx +1]:getBaseTexture():setUV(  x1, y1, x2, y2  )
				target.soketSlot[jewelIdx +1]:setRenderTexture(target.soketSlot[jewelIdx +1]:getBaseTexture())
				local skillSSW = itemEnchantSSW:getSkillByIdx(classType)      --소켓의 스킬정보 받기
				if ( nil == skillSSW ) then
					target.soketEffect[jewelIdx +1]:SetText(" ")
				else
					local buffList = ""
					for buffIdx = 0, skillSSW:getBuffCount() -1 do                          -- 버프 카운트
						local desc = skillSSW:getBuffDescription(buffIdx)
						if ( nil == desc ) or ( "" == desc ) then
							break
						end
						if ( nil == buffList ) or ( "" == buffList ) then
							buffList = desc
						else
							buffList = buffList .. " / " .. desc -- (#소켓) 버프의 효과
						end
					
					end
					target.soketEffect[jewelIdx +1]:SetText(buffList)
				end

			else
				target.soketName[jewelIdx +1]:SetShow(true)
				target.soketEffect[jewelIdx +1]:SetShow(true)
				target.soketSlot[jewelIdx +1]:SetShow(true)

				target.soketName[jewelIdx +1]:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_EMPTY_SLOT" ))	--"빈 슬롯"
				target.soketEffect[jewelIdx +1]:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_EMPTY_SLOT_DESC" ) )
				target.soketSlot[jewelIdx +1]:ChangeTextureInfoName( " " )
			end
		end

		-- target.soketOption_category:SetShow(( 0 ~= soketCount ))
		target.soketOption_panel:SetShow(( 0 ~= soketCount ))
	-- }

	-- { 경험치 표시
		target.useLimit_Exp				:SetShow( false )
		target.useLimit_Exp_gage		:SetShow( false )
		target.useLimit_Exp_gage_value	:SetShow( false )
		target.useLimit_Exp_value		:SetShow( false )
		
		if isGrowthContents then	-- 성장형 아이템(연금석, 토템 등) 컨텐츠 옵션 체크.
			if nil ~= itemWrapper and (32 == itemSSW:get():getContentsEventType() or 37 == itemSSW:get():getContentsEventType())	then	-- 연금석이다.
				local alchemystoneExp = itemWrapper:getExperience() / 10000
				target.useLimit_Exp				:SetShow( true )
				target.useLimit_Exp_gage		:SetShow( true )
				target.useLimit_Exp_gage_value	:SetShow( true )
				target.useLimit_Exp_value		:SetShow( true )

				target.useLimit_Exp_value		:SetText( string.format( "%.2f", alchemystoneExp ) .. "%" )
				target.useLimit_Exp_gage_value	:SetCurrentProgressRate( alchemystoneExp )
				target.useLimit_Exp_gage_value	:SetProgressRate( alchemystoneExp )
				target.useLimit_Exp_gage_value	:SetAniSpeed(0.0)
			end
		end
	-- }
	
	-- { 내구도 표시
		local maxEndurance = 32767
		local dynamicMaxEndurance = 32767
		if ( false == itemSSW:get():isUnbreakable() ) then
			maxEndurance = itemSSW:get()._enchant._maxEndurance
		end
	
		if ( not isSSW ) then
			-- maxEndurance = itemSSW:get()._enchant._maxEndurance
			dynamicMaxEndurance = item:getMaxEndurance();
		end
	
		-- UI.debugMessage(tostring(itemSSW:get()._enchant._maxEndurance))
		local currentEndurance = maxEndurance
		if ( not isSSW ) then
			currentEndurance = item:getEndurance()
		end
		local calcEndurance = ( currentEndurance / maxEndurance )
		local calcDynamicEndurance = ( dynamicMaxEndurance / maxEndurance )

		target.useLimit_endurance_gage_value:SetCurrentProgressRate(calcEndurance * 100)
		target.useLimit_endurance_gage_value:SetProgressRate(calcEndurance * 100)
		target.useLimit_endurance_gage_value:SetAniSpeed(0.0)
		target.useLimit_dynamic_endurance_gage_value:SetCurrentProgressRate(calcDynamicEndurance * 100)
		target.useLimit_dynamic_endurance_gage_value:SetProgressRate(calcDynamicEndurance * 100)
		target.useLimit_dynamic_endurance_gage_value:SetAniSpeed(0.0)

		if ( 32767 ~= dynamicMaxEndurance ) then
			target.useLimit_endurance_value:SetText( currentEndurance .. " / " ..  dynamicMaxEndurance .. "  [" .. maxEndurance .."]" )		-- 내구도 수치
			target.useLimit_endurance:SetShow(true)
			target.useLimit_endurance_value:SetShow(true)
			target.useLimit_endurance_gage_value:SetShow(true)
			target.useLimit_dynamic_endurance_gage_value:SetShow(true)
			target.useLimit_endurance_gage:SetShow(true)
			-- useLimitShow = true
		elseif ( 32767 ~= maxEndurance ) then
			target.useLimit_endurance_value:SetText( currentEndurance .. " / " ..  maxEndurance )		-- 내구도 수치
			target.useLimit_endurance:SetShow(true)
			target.useLimit_endurance_value:SetShow(true)
			target.useLimit_endurance_gage_value:SetShow(true)
			target.useLimit_dynamic_endurance_gage_value:SetShow(false)
			target.useLimit_endurance_gage:SetShow(true)
		else
			target.useLimit_endurance:SetShow(false)
			target.useLimit_endurance_value:SetShow(false)
			target.useLimit_endurance_gage_value:SetShow(false)
			target.useLimit_dynamic_endurance_gage_value:SetShow(false)
			target.useLimit_endurance_gage:SetShow(false)
		end

		if Panel_House_InstallationMode:GetShow() then
			target.useLimit_endurance:SetShow(false)
			target.useLimit_endurance_value:SetShow(false)
			target.useLimit_endurance_gage_value:SetShow(false)
			target.useLimit_dynamic_endurance_gage_value:SetShow(false)
			target.useLimit_endurance_gage:SetShow(false)
		end

		local check_fishingRod = function( itemKey )	-- 캐시템은 낚싯대만 내구도가 나온다.
			if 17591 == itemKey or 17592 == itemKey or 17596 == itemKey or 17612 == itemKey or 17613 == itemKey or 17669 == itemKey then
				return true
			else
				return false
			end
		end
		if nil ~= itemWrapper then
			local isCash = itemWrapper:getStaticStatus():get():isCash()
			if (true == isCash) and false == check_fishingRod( itemSSW:get()._key:getItemKey() ) then -- 아이템이 캐시템이고, 특정 아이템이 아니면 내구도를 나타내지 않는다.
				target.useLimit_endurance:SetShow(false)
				target.useLimit_endurance_value:SetShow(false)
				target.useLimit_endurance_gage_value:SetShow(false)
				target.useLimit_dynamic_endurance_gage_value:SetShow(false)
				target.useLimit_endurance_gage:SetShow(false)
			end
		elseif ( nil ~= itemSSW ) then
			local isCash = itemSSW:get():isCash()
			if (true == isCash) and false == check_fishingRod( itemSSW:get()._key:getItemKey() ) then -- 아이템이 캐시템이고, 특정 아이템이 아니면 내구도를 나타내지 않는다.
				target.useLimit_endurance:SetShow(false)
				target.useLimit_endurance_value:SetShow(false)
				target.useLimit_endurance_gage_value:SetShow(false)
				target.useLimit_dynamic_endurance_gage_value:SetShow(false)
				target.useLimit_endurance_gage:SetShow(false)
			end
		end
	-- }
	

	--창 위치 맞추기
	target.mainPanel:SetSize( target.mainPanel:GetSizeX(), target.panelSize - 30 * ( 6 - soketCount -1 ) )
	target.soketOption_panel:SetSize( target.soketOption_panel:GetSizeX() ,target.socketSize - 30 * ( 6 - soketCount ) )
	target.itemProducedPlace:ComputePos()
	target.itemDescription:ComputePos()
	target.itemPrice_panel:ComputePos()
	target.itemPrice_transportBuy:ComputePos()
	target.itemPrice_transportBuy_value:ComputePos()
	target.itemPrice_storeSell:ComputePos()
	target.itemPrice_storeSell_value:ComputePos()

	if true == itemSSW:get():isForJustTrade() and not isSSW then
		-- 원산지가 연결되어 있지 않으면, 연결이 필요하다고 알려야 한다.
		target.itemProducedPlace:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCT_PLACE" ) .. " : " ..itemWrapper:getProductionRegion() )	--"원산지 : "
	else
		target.itemProducedPlace:SetText( "" )
	end

	target.itemDescription:SetTextMode(UI_TM.eTextMode_AutoWrap)
	target.itemDescription:SetAutoResize(true)

	-- { 아이템 설명
		local _desc = PAGetString( Defines.StringSheet_GAME, "LUA_TOOLTIP_DESC_TITLE" ) .. " " .. itemSSW:getDescription()
		if (item_type == 2) and (true == itemSSW:get():isForJustTrade()) then		-- 소모품이면서 무역을 할 수 있으면. 무역품 설명 추가
			_desc = _desc .. "\n" .. PAGetString( Defines.StringSheet_GAME, "LUA_TOOLTIP_DESC_TRADEITEM" )
		end
		if ( "" ~= itemSSW:getEnchantDescription() ) then									-- 강화 시 적용 효과
			_desc = _desc .. "\n\n- " .. itemSSW:getEnchantDescription()
		end

		target.itemDescription:SetText( _desc )
	-- }

	-- { 잡템 교환 설명 처리
		local isExchangeItem	= itemSSW:isExchangeItem()
		local exchangeDesc		= ""
		if isExchangeItem then
			target.exchangeTitle:SetShow( true ) 
			target.exchangeDesc:SetShow( true ) 
			target.exchangeDesc:SetText( itemSSW:getExchangeDescription() )
		else
			target.exchangeTitle:SetShow( false ) 
			target.exchangeDesc:SetShow( false ) 
			target.exchangeDesc:SetText("")
		end
	-- }

	local _const = Defines.s64_const
	local isTradeItem = itemSSW:isTradeAble()
	if isTradeItem == true and not isSSW then	-- 무역 아이템이면,
		if item:getBuyingPrice_s64() > _const.s64_0 then	-- 구매 가격이 0G 이상이면,
			target.itemPrice_transportBuy_value:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT" ) .. " " .. tostring(makeDotMoney(item:getBuyingPrice_s64())) )														-- 무역구매가
		else
			target.itemPrice_transportBuy_value:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOTHING" ) )	-- "없음"
		end
		target.itemPrice_transportBuy:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_BUY_PRICE" ) .. " : ") -- "무역 구입가"
		target.itemPrice_transportBuy:SetFontColor(4287137928)
		target.itemPrice_transportBuy:SetShow(true)
		target.itemPrice_transportBuy_value:SetShow(true)
		target.itemPrice_panel:SetSize( target.itemPrice_panel:GetSizeX(), 50 )
		target.itemPrice_transportBuy_value:SetSpanSize( target.itemPrice_transportBuy:GetTextSizeX()+20, 0 )
	else										-- 무역 아이템이 아니면 표시 안함
		target.itemPrice_transportBuy:SetText( "" )		-- "세율 적용 물품" PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_TEX_APPLY" )
		target.itemPrice_transportBuy:SetFontColor(4290733156)
		target.itemPrice_transportBuy:SetShow(true)
		target.itemPrice_transportBuy_value:SetShow(false)
		target.itemPrice_panel:SetSize( target.itemPrice_panel:GetSizeX(), 25 )
		target.itemPrice_transportBuy_value:SetSpanSize( target.itemPrice_transportBuy:GetTextSizeX()+20, 0 )
	end
	
	local s64_originalPrice = itemSSW:get()._originalPrice_s64
	local s64_sellPrice = itemSSW:get()._sellPriceToNpc_s64
	if ( isTradeItem ) then
		target.itemPrice_storeSell:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ORIGINAL_PRICE" )..":" )	-- "원가:"
		if s64_originalPrice > _const.s64_0 and 0 == enchantLevel then				-- 판매 가격이 0G 이상이면,
			target.itemPrice_storeSell_value:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT" ) .. " " .. tostring(makeDotMoney(s64_originalPrice)) )																-- 판매가
			target.itemPrice_storeSell_value:SetFontColor(4292726146)
		else
			target.itemPrice_storeSell_value:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_SELLING_ITEM" ) )	-- "판매불가"
			target.itemPrice_storeSell_value:SetFontColor(4290733156)		-- 판매 불가 아이템은 빨간색 표시
		end
	else
		target.itemPrice_storeSell:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_SELL_PRICE" ).. " : " ) -- "판매가 :"
		if s64_sellPrice > _const.s64_0 and 0 == enchantLevel then				-- 판매 가격이 0G 이상이면,
			target.itemPrice_storeSell_value:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT" ) .. " " .. tostring(makeDotMoney(s64_sellPrice)) )																-- 판매가
			target.itemPrice_storeSell_value:SetFontColor(4292726146)
		else
			target.itemPrice_storeSell_value:SetText( PAGetString( Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_SELLING_ITEM" ) )	-- "판매불가"
			target.itemPrice_storeSell_value:SetFontColor(4290733156)		-- 판매 불가 아이템은 빨간색 표시
		end
	end
	target.itemPrice_storeSell_value:SetSpanSize( target.itemPrice_storeSell:GetTextSizeX()+20, 0 )

	-- 데이터 수정
	local elementBiggap = 10
	local elementgap = 2
	local TooltipYPos = 10
	if ( target.mainPanel == Panel_Tooltip_Item_equipped ) then
	end

	-- 아이콘
	target.itemIcon:SetPosY( 30 + changeItemNamePos )
	target.itemType:SetPosY( 8 )
	chattingLinkedItemTooltip.itemType:SetPosX(175)	-- 채팅창에 링크된 아이템은 타입을 닫기 버튼 앞으로
	
	target.dying:SetPosY( 50 + changeItemNamePos )
	local iconPosY = target.itemIcon:GetPosY()
	local iconSizeY = target.itemIcon:GetSizeY()
	
	-- 공격력/방어력
	if ( attackShow == true ) and ( defenseShow == false ) then
		target.attack:SetPosY( 31 + changeItemNamePos )
		target.attack_value:SetPosY( 22 + changeItemNamePos)
		target.attack_value:SetAutoResize( true )
		TooltipYPos = GetBottomPos(target.attack) + elementgap
		
		target.weight:SetPosY( TooltipYPos )
		target.weight_value:SetPosY( TooltipYPos )
		TooltipYPos = GetBottomPos(target.weight_value) + elementgap
	elseif ( defenseShow == true ) and ( attackShow == true ) then
		target.attack:SetPosY( 31 + changeItemNamePos)
		target.attack_value:SetPosY( 22 + changeItemNamePos)
		target.defense:SetPosY( 53 + changeItemNamePos)
		target.defense_value:SetPosY( 45 + changeItemNamePos)
		TooltipYPos = GetBottomPos(target.defense) + elementgap
		
		target.weight:SetPosY( TooltipYPos )
		target.weight_value:SetPosY( TooltipYPos )
		TooltipYPos = GetBottomPos(target.weight_value) + elementgap
	elseif ( defenseShow == true ) and ( attackShow == false ) then
		target.defense:SetPosY( 31 + changeItemNamePos)
		target.defense_value:SetPosY( 22 + changeItemNamePos)
		TooltipYPos = GetBottomPos(target.defense) + elementgap
		
		target.weight:SetPosY( TooltipYPos )
		target.weight_value:SetPosY( TooltipYPos )
		TooltipYPos = GetBottomPos(target.weight_value) + elementgap
	elseif ( attackShow == false ) and ( defenseShow == false ) then
		target.weight:SetPosY( iconPosY + iconSizeY - 15 )
		target.weight_value:SetPosY( iconPosY + iconSizeY - 15 )
		TooltipYPos = GetBottomPos(target.weight_value) + elementgap
	end
	
	-- 장비 비교 수치
	if normalTooltip.attack_diffValue:GetShow() then
		normalTooltip.attack_diffValue:SetPosX( normalTooltip.attack_value:GetPosX() + normalTooltip.attack_value:GetTextSizeX() + 10 )
		normalTooltip.attack_diffValue:SetPosY( normalTooltip.attack_value:GetPosY() + 7 )
	end
	if normalTooltip.defense_diffValue:GetShow() then
		normalTooltip.defense_diffValue:SetPosX( normalTooltip.defense_value:GetPosX() + normalTooltip.defense_value:GetTextSizeX() + 10 )
		normalTooltip.defense_diffValue:SetPosY( normalTooltip.defense_value:GetPosY() + 7 )
	end
	if normalTooltip.weight_diffValue:GetShow() then
		normalTooltip.weight_diffValue:SetPosX( normalTooltip.weight_value:GetPosX() + normalTooltip.weight_value:GetTextSizeX() + 10 )
		normalTooltip.weight_diffValue:SetPosY( normalTooltip.weight_value:GetPosY() )
	end
	
	-- 강화/분해/귀속
	if target.isEnchantable:GetShow() then
		target.isEnchantable:SetPosY( TooltipYPos + 5 )
		TooltipYPos = GetBottomPos(target.isEnchantable) + elementgap
	-- else
		-- TooltipYPos = GetBottomPos(target.isEnchantable) - elementgap * 5
	end
	-- 각인
	if target.isSealed:GetShow() then
		target.isSealed:SetPosY( TooltipYPos + 5 )
		TooltipYPos = GetBottomPos(target.isSealed) + elementgap
	end

	-- target.disassembleType	:SetPosY( TooltipYPos + 20 )
	if target.bindType:GetShow() then
		target.bindType:SetPosY( TooltipYPos )
		TooltipYPos = GetBottomPos(target.bindType) + elementgap
	end

	if target.personalTrade:GetShow() then
		target.personalTrade:SetPosY( TooltipYPos )
		TooltipYPos = GetBottomPos(target.personalTrade) + elementgap
	end

	if target.tradeInfo_Panel:GetShow() then
		target.tradeInfo_Panel:SetPosY( TooltipYPos )
		target.tradeInfo_Title:SetPosY( TooltipYPos + 5 )
		target.tradeInfo_Value:SetPosY( TooltipYPos + target.tradeInfo_Title:GetSizeY() + 5 )
		TooltipYPos = GetBottomPos(target.tradeInfo_Panel) + elementgap
	end

	if target.useDyeColorTitle:GetShow() then
		target.useDyeColorTitle:SetPosY( TooltipYPos + 11 )
		TooltipYPos = GetBottomPos(target.useDyeColorTitle) + elementgap
	end

	if itemSSW:isEquipable() and itemSSW:isDyeable() then
		local dyeingPartCount = 0
		if nil ~= itemWrapper then
			dyeingPartCount = itemWrapper:getDyeingPartCount()
		elseif nil ~= chattingLinkedItem then
			dyeingPartCount = chattingLinkedItem:getDyeingPartCount()
		end
		if 0 < dyeingPartCount then
			for dyeingPart_Index = 0, dyeingPartCount-1, 1 do
				target.useDyeColorIcon_Part[dyeingPart_Index]:SetPosY( TooltipYPos )
				if 0 == dyeingPart_Index then
					target.useDyeColorIcon_Part[dyeingPart_Index]:SetPosX( 15 )
				else
					target.useDyeColorIcon_Part[dyeingPart_Index]:SetPosX( target.useDyeColorIcon_Part[dyeingPart_Index-1]:GetPosX() + target.useDyeColorIcon_Part[dyeingPart_Index]:GetSizeX() + 6 )
				end
			end
			TooltipYPos = GetBottomPos(target.useDyeColorIcon_Part[0]) + elementgap + 10
		end
	end

	--3단계 사용 제한 카테고리 , 패널, 레벨제한, 가능 클래스, 내구도 , 사용가능 시간, 잔존 시간
	if ( useLimitShow == true ) then
		target.useLimit_category:SetShow(true)
		if ( target.useLimit_category:GetShow() ) then
			target.useLimit_panel:SetPosY( TooltipYPos )
			target.useLimit_category:SetPosY( TooltipYPos )
			TooltipYPos = TooltipYPos + elementgap
			
			-- 사용 가능 클래스
			if target.useLimit_class_value:GetShow() then
				target.useLimit_class_value:SetPosY( TooltipYPos + 4 )
				TooltipYPos = GetBottomPos(target.useLimit_class_value) + elementgap
			end

			-- 아이템 사용 가능 레벨
			if ( target.useLimit_level_value:GetShow() ) then
				target.useLimit_level_value:SetPosY( TooltipYPos + 4 )
				TooltipYPos = GetBottomPos(target.useLimit_level_value) + elementgap
			end

			-- 확장 슬롯 표시
			if ( target.useLimit_extendedslot_value:GetShow() ) then
				target.useLimit_extendedslot_value:SetPosY( TooltipYPos )
				TooltipYPos = GetBottomPos(target.useLimit_extendedslot_value) + elementgap
			end

			-- 아이템 잔존 시간
			if ( target.remainTime:GetShow() ) then
				target.remainTime:SetPosY( TooltipYPos )
				target.remainTime_value:SetPosY( TooltipYPos )
				TooltipYPos = GetBottomPos(target.remainTime_value) + elementgap

				-- 잔존 시간 앞에 시계 아이콘 표시	
				local s64_remainingTime = getLeftSecond_s64( item:getExpirationDate() )
				if Defines.s64_const.s64_0 == s64_remainingTime then
					normalTooltip.expireIcon_end:SetShow( true )		-- 엑스 표시 
					normalTooltip.expireIcon_end:SetPosX( normalTooltip.remainTime_value:GetPosX() - 15 )
					normalTooltip.expireIcon_end:SetPosY( TooltipYPos - 17 )
				elseif Int64toInt32(s64_remainingTime) <= 7200 then
					normalTooltip.expireIcon_red:SetShow( true )		-- 붉은색 시계 표시
					normalTooltip.expireIcon_red:SetPosX( normalTooltip.remainTime_value:GetPosX() - 15 )
					normalTooltip.expireIcon_red:SetPosY( TooltipYPos - 17 )
				else
					normalTooltip.expireIcon_white:SetShow( true )		-- 흰색 시계 표시
					normalTooltip.expireIcon_white:SetPosX( normalTooltip.remainTime_value:GetPosX() - 15 )
					normalTooltip.expireIcon_white:SetPosY( TooltipYPos - 17 )
				end
			else
				normalTooltip.expireIcon_white:SetShow( false )
				normalTooltip.expireIcon_red:SetShow( false )
				normalTooltip.expireIcon_end:SetShow( false )
			end

			target.useLimit_panel:SetSize( target.useLimit_panel:GetSizeX(), TooltipYPos - target.useLimit_panel:GetPosY() + elementBiggap /2)
			TooltipYPos = GetBottomPos(target.useLimit_panel) + elementBiggap /2	
		end
	end

	--4단계 소켓 카테고리, 패널, 슬롯아이콘, 제목, 내용
	-- if ( target.soketOption_category:GetShow() ) then
	-- 	target.soketOption_category:SetPosY( TooltipYPos - 23 )
	-- 	TooltipYPos = GetBottomPos(target.soketOption_category) + elementgap
	if target.soketOption_panel:GetShow() then
		target.soketOption_panel:SetPosY( TooltipYPos )
		TooltipYPos = TooltipYPos + elementgap
		for idx = 1, 6 do
			if ( target.soketSlot[idx]:GetShow() ) then
				target.soketSlot[idx]:SetPosY( TooltipYPos + 1 )

				target.soketName[idx]:SetPosY( TooltipYPos )
				TooltipYPos = GetBottomPos(target.soketName[idx]) + elementgap

				target.soketEffect[idx]:SetPosY( TooltipYPos)
				TooltipYPos = GetBottomPos(target.soketEffect[idx]) + elementgap
				TooltipYPos = TooltipYPos + elementBiggap
			end
		end
		target.soketOption_panel:SetSize( target.soketOption_panel:GetSizeX(), TooltipYPos - target.soketOption_panel:GetPosY() - elementBiggap /2)
		TooltipYPos = GetBottomPos(target.soketOption_panel) + elementBiggap
	end
	
	
	if true == itemSSW:get():isForJustTrade() and not isSSW then
		target.itemProducedPlace:SetPosY( TooltipYPos )
		TooltipYPos = GetBottomPos(target.itemProducedPlace) + elementBiggap
	end

	target.itemDescription:SetPosY( TooltipYPos + 10 )
	TooltipYPos = GetBottomPos(target.itemDescription) + elementgap

	if target.exchangeTitle:GetShow() then
		target.exchangeTitle:SetPosY( TooltipYPos + 10 )
		TooltipYPos = GetBottomPos(target.exchangeTitle) + elementgap

		target.exchangeDesc:SetPosY( TooltipYPos )
		TooltipYPos = GetBottomPos(target.exchangeDesc) + elementgap
	end

	-- 착용 타입 표시
	if ( target.equipSlotName:GetShow() ) then
		target.equipSlotName:SetPosY( TooltipYPos )
		TooltipYPos = GetBottomPos(target.equipSlotName) + elementgap
	end

	target.itemPrice_panel:SetPosY( TooltipYPos )
	TooltipYPos = TooltipYPos + elementgap *2

	target.itemPrice_transportBuy:SetPosY( TooltipYPos+20 )
	target.itemPrice_transportBuy_value:SetPosY( TooltipYPos+20 )
	target.itemPrice_storeSell:SetPosY( TooltipYPos )
	target.itemPrice_storeSell_value:SetPosY( TooltipYPos )
	TooltipYPos = GetBottomPos(target.itemPrice_storeSell_value) + elementBiggap

	TooltipYPos = GetBottomPos(target.itemPrice_panel) + elementBiggap /2

	-- 경험치(연금석)
	if target.useLimit_Exp:GetShow() then
		target.useLimit_Exp:SetPosY( TooltipYPos + elementgap )
		target.useLimit_Exp_gage:SetPosY( TooltipYPos + 15 )
		target.useLimit_Exp_gage_value:SetPosY( TooltipYPos + 20 )
		target.useLimit_Exp_value:SetPosY( TooltipYPos + 15 + (target.useLimit_Exp_gage:GetSizeY() - target.useLimit_Exp_value:GetSizeY()) /2 )
		TooltipYPos = GetBottomPos(target.useLimit_Exp) + elementBiggap
	end

	-- 내구도
	if ( target.useLimit_endurance:GetShow() ) then
		target.useLimit_endurance:SetPosY( TooltipYPos + elementgap )
		target.useLimit_endurance_gage:SetPosY( TooltipYPos + 15 )
		target.useLimit_endurance_value:SetPosY( TooltipYPos + 15 )
		target.useLimit_endurance_gage_value:SetPosY( TooltipYPos + 15 + (target.useLimit_endurance_gage:GetSizeY() - target.useLimit_endurance_gage_value:GetSizeY()) /2 )
		target.useLimit_dynamic_endurance_gage_value:SetPosY( TooltipYPos + 15 + (target.useLimit_endurance_gage:GetSizeY() - target.useLimit_dynamic_endurance_gage_value:GetSizeY()) /2 )
		TooltipYPos = GetBottomPos(target.useLimit_endurance) + elementBiggap
	end

	if normalTooltip == target and true == Panel_Tooltip_Item_DataObject.inventory then
		if ( isGameTypeKorea() or isGameTypeJapan() or isGameTypeRussia() ) and getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_CBT then
			target.productNotify:SetShow( true )
		else
			target.productNotify:SetShow( false )
		end
	else
		target.productNotify:SetShow( false )
	end

	if target.productNotify:GetShow() then
		target.productNotify:SetPosY( TooltipYPos + elementgap )
		TooltipYPos = GetBottomPos(target.productNotify) + elementgap
	end

	target.mainPanel:SetSize( target.mainPanel:GetSizeX(), TooltipYPos + elementBiggap / 2)
	
	-- 각인 메시지
	--[[
	if false == ( isSSW and not isItemWrapper) then
		if item:isSealed() then
			target.bindType:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_BINDTYPE", "getText", target.bindType:GetText() ) )
		end
	end
	]]--
	
	return ( item_type == 1 ), (itemSSW:isUsableServant()) --장착류
end

function showTooltip_Item( target, itemWrapper, isSSW, isItemWrapper, chattingLinkedItem, index, isNextEnchantInfo )
	-- ♬ 툴팁이 열릴 때 사운드 추가
	audioPostEvent_SystemUi(01,13)
	
	-- 툴팁의 표시 및 위치 설정
	target.mainPanel:SetShow(true, false)
	return Panel_Tooltip_Item_ShowInfo(target, itemWrapper, isSSW, isItemWrapper, chattingLinkedItem, index, isNextEnchantInfo)
end



-- 초기화 --------------------------------------------------------------------------------------------------------------------
Panel_Tooltip_Item_Initialize()
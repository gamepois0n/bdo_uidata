local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local CT			= CppEnums.ClassType
local UI_BUFFTYPE	= CppEnums.UserChargeType

Panel_Dye_New:SetShow( false )

local awakenWeapon = 
{
	[CT.ClassType_Warrior]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 901 ),		-- 워리어
	[CT.ClassType_Ranger]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 902 ),		-- 레인저
	[CT.ClassType_Sorcerer]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 903 ),		-- 소서러
	[CT.ClassType_Giant]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 904 ),		-- 자이언트
	[CT.ClassType_Tamer]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 905 ),		-- 금수랑
	[CT.ClassType_BladeMaster]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 906 ),		-- 무사
	[CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 907 ),		-- 매화
	[CT.ClassType_Valkyrie]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 908 ),		-- 발키리
	[CT.ClassType_Wizard]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 909 ),		-- 위자드
	[CT.ClassType_WizardWomen]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 910 ),		-- 위치
	[CT.ClassType_NinjaMan]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 911 ),		-- 닌자
	[CT.ClassType_NinjaWomen]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 912 ),		-- 쿠노이치
}
local classType = getSelfPlayer():getClassType()
local awakenWeaponContentsOpen = awakenWeapon[classType]			-- 해당 직업의 각성 무기가 열려 있나 체크

local DyeNew = {
	panelTitle					= UI.getChildControl( Panel_Dye_New, "StaticText_Title"),
	leftBG						= UI.getChildControl( Panel_Dye_New, "Static_BG"),
	scroll						= UI.getChildControl( Panel_Dye_New, "Scroll_DyeNew"),
	_buttonQuestion				= UI.getChildControl( Panel_Dye_New, "Button_Question"),
	targetCharacter				= {
		[0] = UI.getChildControl( Panel_Dye_New, "RadioButton_CharacterType_0"),
		UI.getChildControl( Panel_Dye_New, "RadioButton_CharacterType_1"),
		UI.getChildControl( Panel_Dye_New, "RadioButton_CharacterType_2"),
		UI.getChildControl( Panel_Dye_New, "RadioButton_CharacterType_3"),
		UI.getChildControl( Panel_Dye_New, "RadioButton_CharacterType_4"),
		UI.getChildControl( Panel_Dye_New, "RadioButton_CharacterType_5"),
		UI.getChildControl( Panel_Dye_New, "RadioButton_CharacterType_6"),
		},

	btn_Dodye					= UI.getChildControl( Panel_Dye_New, "Button_DoDye"),

	static_SetOptionBG			= UI.getChildControl( Panel_Dye_New, "Static_SetOptionBG"),
	txt_Endurance				= UI.getChildControl( Panel_Dye_New, "StaticText_Endurance"),
	btn_ShowUnderwear			= UI.getChildControl( Panel_Dye_New, "CheckButton_ShowUnderWear"),
	btn_HideAvatar				= UI.getChildControl( Panel_Dye_New, "CheckButton_HideAvatar"),
	btn_HairHide				= UI.getChildControl( Panel_Dye_New, "CheckButton_HideHair"),
	btn_HelmHide				= UI.getChildControl( Panel_Dye_New, "CheckButton_HideHelm"),
	btn_OpenHelm				= UI.getChildControl( Panel_Dye_New, "CheckButton_OpenHelm"),
	btn_AwakenWeapon			= UI.getChildControl( Panel_Dye_New, "CheckButton_AwakenWeapon"),
	Slider_Endurance			= UI.getChildControl( Panel_Dye_New, "Slider_Endurance"),

	titleLineUIPool				= {},
	titleLineSting				= {
		[0] = PAGetString(Defines.StringSheet_GAME, "LUA_DYE_NEW_TITLELINESTRING_DESTINATION"),
		PAGetString(Defines.StringSheet_GAME, "LUA_DYE_NEW_TITLELINESTRING_ITEMSELECT"),
		PAGetString(Defines.StringSheet_GAME, "LUA_DYE_NEW_TITLELINESTRING_ITEMPARTSSELECT"),
		PAGetString(Defines.StringSheet_GAME, "LUA_DYE_NEW_TITLELINESTRING_DYESELECT"),
	},
	targetCharacterSlotCount	= 7,
	lastCharacterSlotNo			= 3,
	characterTypeUIPoll			= {},
	selected_characterType		= 0,

	targetEuipSlotCount			= 19,
	equipSlotUIPoll				= {},
	selectedEquipSlotNo			= 0,
	isSelectedEquipSlot			= false,

	partSlotMaxCount			= 8,
	partIdxMaxCount				= 3,
	partClientCount				= 12,
	partSlotUIPoll				= {},
	isPartClick					= false,
	selectedPart				= { slotId = -1, partId = -1, uiIdx = -1 },

	isHideAvatar				= false,
	isShowUnderwear				= false,
	isHideBattleHelmet			= false,
	isOpenBattleHelmet			= false,

	ampuleSlotMaxCount			= 28,
	ampuleSlotUseCount			= 28,
	ampuleSlotBGUIPoll			= {},
	ampuleSlotUIPoll			= {},
	ampuleSlotConfig			= {	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon		= true,
		createBorder	= true,
		createCount		= true,
		createCash		= true,
		createEnchant	= true,
	},
	selectedampuleIdx			= -1,
	dyeStepCount				= 4,

	palette = {
		ui		= {
			_btn_TabAll		= UI.getChildControl( Panel_Dye_New, "RadioButton_Tab_ALL"),
			_btn_TabMy		= UI.getChildControl( Panel_Dye_New, "RadioButton_Tab_My"),
			_btn_TabPearl	= UI.getChildControl( Panel_Dye_New, "RadioButton_Tab_Pearl"),
			_btn_Material	= {
				[0]	= UI.getChildControl( Panel_Dye_New, "RadioButton_Material_0"),
				[1]	= UI.getChildControl( Panel_Dye_New, "RadioButton_Material_1"),
				[2]	= UI.getChildControl( Panel_Dye_New, "RadioButton_Material_2"),
				[3]	= UI.getChildControl( Panel_Dye_New, "RadioButton_Material_3"),
				[4]	= UI.getChildControl( Panel_Dye_New, "RadioButton_Material_4"),
				[5]	= UI.getChildControl( Panel_Dye_New, "RadioButton_Material_5"),
				[6]	= UI.getChildControl( Panel_Dye_New, "RadioButton_Material_6"),
				[7]	= UI.getChildControl( Panel_Dye_New, "RadioButton_Material_7"),
			},
		},
		config	= {
			scrollStartIdx		= 0,
			maxSlotRowsCount	= 3,
			resizeSlotRowsCount	= 3,
			maxSlotColsCount	= 7,
			colorTotalRows		= 0,
			selectedColorIdx	= 0,
			selectedCategoryIdx	= 0,
			isShowAll			= false,
			isPearlPallete		= false,
			beforPearPallete	= false,
			startPosX			= 10,
			startPosY			= 45,
			cellSpan			= 2,
		},
		slot	= {},
	}
}
DyeNew.scrollCTRLBTN			= UI.getChildControl( DyeNew.scroll, 			"Scroll_CtrlButton")
DyeNew.Endurance_SliderCtrlBTN	= UI.getChildControl( DyeNew.Slider_Endurance,	"Slider_Endurance_Button")
DyeNew.btn_AwakenWeapon:SetShow( awakenWeaponContentsOpen )

local Template = {
	titleLine		= UI.getChildControl( Panel_Dye_New, "Template_StaticText_DyeTarget_Title"),
	areaBG			= UI.getChildControl( Panel_Dye_New, "Template_Static_DyeTarget_BG"),
	slotBG			= UI.getChildControl( Panel_Dye_New, "Template_Static_SlotBG"),
	slotSelectBG	= UI.getChildControl( Panel_Dye_New, "Template_Static_SlotSelectBG"),
	slot			= UI.getChildControl( Panel_Dye_New, "Template_Static_Slot"),

	BTN_part		= UI.getChildControl( Panel_Dye_New, "Template_Radiobutton_PartColor"),
	BTN_resetPart	= UI.getChildControl( Panel_Dye_New, "Template_Button_PartSLotReset"),
	SlotPartBG		= UI.getChildControl( Panel_Dye_New, "Template_Static_SlotPartColorBG"),
	SlotPartName	= UI.getChildControl( Panel_Dye_New, "Template_Static_SlotPartColorName"),	
}

local equipSlotNo	= {
	[0] = {
		0,		-- 'Static_Slot_RightHand',
		1,		-- 'Static_Slot_LeftHand',
		3,		-- 'Static_Slot_Chest',
		4,		-- 'Static_Slot_Glove',
		5,		-- 'Static_Slot_Boots',
		6,		-- 'Static_Slot_Helm',
		7,		-- '',

		18,		-- 'Static_Slot_Avatar_RightHand',
		19,		-- 'Static_Slot_Avatar_LeftHand',
		14,		-- 'Static_Slot_Avatar_Chest',
		15,		-- 'Static_Slot_Avatar_Gloves',
		16,		-- 'Static_Slot_Avatar_Boots',
		17,		-- 'Static_Slot_Avatar_Helm',
		20,		-- 'Static_Slot_Avatar_UnderWear',
		21,		-- 'Static_Slot_Avatar_UnderWear',
		22,		-- 'Static_Slot_Avatar_UnderWear',
		23,		-- 'Static_Slot_Avatar_UnderWear',
		29,		-- 대검
		30,		-- 대검 아바타
	},
	{
		3,		-- 마갑
		4,		-- 등자
		5,		-- 안장
		6,		-- 마면
		12,		-- 편자.
		0,		-- 사용안함.
		1,		-- 사용안함.

		14,		-- 마갑
		15,		-- 등자
		16,		-- 안장
		17,		-- 마면
		18,		-- 사용안함.
		19,		-- 사용안함.
		20,		-- 사용안함.
	},
	{
		3,		-- 차체
		4,		-- 바퀴
		5,		-- 깃발
		6,		-- 휘장
		13,		-- 램프
		25,		-- 덮개
		0,		-- 사용안함.

		14,		-- 차체
		15,		-- 바퀴
		16,		-- 깃발
		17,		-- 휘장
		26,		-- 덮개
		20,		-- 사용안함.
		21,		-- 사용안함.
	},
	{
		3,		-- 낙타 마갑
		4,		-- 낙타 등자
		5,		-- 낙타 안장
		6,		-- 낙타 마면
		12,		-- 낙타 편자.
		0,		-- 사용안함.
		1,		-- 사용안함.

		14,		-- 낙타 마갑
		15,		-- 낙타 등자
		16,		-- 낙타 안장
		17,		-- 낙타 마면
		18,		-- 사용안함.
		19,		-- 사용안함.
		20,		-- 사용안함.
	},
}
local equipSlotIcon = {
	[0] = {
		[0] = { 166, 123, 194, 151 },			-- 주무기
		[1] = { 197, 123, 225, 151 },			-- 보조무기
		[3] = { 42, 123, 70, 151 },				-- 갑옷
		[4] = { 135, 123, 163, 151 },			-- 장갑
		[5] = { 104, 123, 132, 151 },			-- 신발
		[6] = { 11, 123, 39, 151 },				-- 투구
		[7] = { 0, 0, 0, 0 },					-- 목걸이(안쓴다)

		[18] = { 166, 154, 194, 182 },			-- 주무기(아바타)
		[19] = { 197, 154, 225, 182 },			-- 보조무기(아바타)
		[14] = { 42, 154, 70, 182 },			-- 갑옷(아바타)
		[15] = { 135, 154, 163, 182 },			-- 장갑(아바타)
		[16] = { 104, 154, 132, 182 },			-- 신발(아바타)
		[17] = { 11, 154, 39, 182 },			-- 투구(아바타)
		[20] = { 73, 154, 101, 182 },			-- 속옷(아바타)

		[21] = { 228, 123, 256, 151 },			-- 얼굴 악세-상단(아바타)
		[22] = { 259, 154, 287, 182 },			-- 얼굴 악세-하단(아바타)
		[23] = { 228, 154, 256, 182 },			-- 얼굴 악세-귀(아바타)
		[29] = { 228, 93, 256, 121 },
		[30] = { 259, 93, 287, 121 },
	},
	{
		[3] = { 136,	147,	164,	175 },	-- 마갑
		[4] = { 105,	147,	133,	175 },	-- 등자
		[5] = { 198,	147,	226,	175 },	-- 안장
		[6] = { 74,		147,	102,	175 },	-- 마면
		[12] = { 167,	147,	195,	175 },	-- 편자.
		[0] = { 0, 0, 0, 0 },	-- 사용안함.
		[1] = { 0, 0, 0, 0 },	-- 사용안함.

		[14] = { 136,	177,	164,	205 },	-- 마갑
		[15] = { 105,	177,	133,	205 },	-- 등자
		[16] = { 198,	177,	226,	205 },	-- 안장
		[17] = { 74,	177,	102,	205 },	-- 마면
		[18] = { 0, 0, 0, 0 },	-- 사용안함.
		[19] = { 0, 0, 0, 0 },	-- 사용안함.
		[20] = { 0, 0, 0, 0 },	-- 사용안함.
	},
	{
		[3] = { 136,	147,	164,	175 },	-- 차체
		[4] = { 105,	147,	133,	175 },	-- 바퀴
		[5] = { 198,	147,	226,	175 },	-- 깃발
		[6] = { 74,		147,	102,	175 },	-- 휘장
		[13] = { 167,	147,	195,	175 },	-- 램프
		[25] = { 0, 0, 0, 0 },	-- 덮개
		[0] = { 0, 0, 0, 0 },	-- 사용안함.

		[14] = { 136,	177,	164,	205 },	-- 차체
		[15] = { 105,	177,	133,	205 },	-- 바퀴
		[16] = { 198,	177,	226,	205 },	-- 깃발
		[17] = { 74,	177,	102,	205 },	-- 휘장
		[26] = { 0, 0, 0, 0 },	-- 덮개
		[20] = { 0, 0, 0, 0 },	-- 사용안함.
		[21] = { 0, 0, 0, 0 },	-- 사용안함.
	},
	{
		[3] = { 136,	147,	164,	175 },	-- 낙타 마갑
		[4] = { 105,	147,	133,	175 },	-- 낙타 등자
		[5] = { 198,	147,	226,	175 },	-- 낙타 안장
		[6] = { 74,		147,	102,	175 },	-- 낙타 마면
		[12] = { 167,	147,	195,	175 },	-- 낙타 편자.
		[0] = { 0, 0, 0, 0 },	-- 사용안함.
		[1] = { 0, 0, 0, 0 },	-- 사용안함.

		[14] = { 136,	177,	164,	205 },	-- 낙타 마갑
		[15] = { 105,	177,	133,	205 },	-- 낙타 등자
		[16] = { 198,	177,	226,	205 },	-- 낙타 안장
		[17] = { 74,	177,	102,	205 },	-- 낙타 마면
		[18] = { 0, 0, 0, 0 },	-- 사용안함.
		[19] = { 0, 0, 0, 0 },	-- 사용안함.
		[20] = { 0, 0, 0, 0 },	-- 사용안함.
	},
}
local equipSlotDyeInfo = {
	[0] = {
		[0]		= {},
		[1]		= {},
		[3]		= {},
		[4]		= {},
		[5]		= {},
		[6]		= {},
		[7]		= {},

		[18]	= {},
		[19]	= {},
		[14]	= {},
		[15]	= {},
		[16]	= {},
		[17]	= {},
		[20]	= {},
		[21]	= {},
		[22]	= {},
		[23]	= {},
		[29]	= {},
		[30]	= {},
	},
	{
		[3] = {},	-- 마갑
		[4] = {},	-- 등자
		[5] = {},	-- 안장
		[6] = {},	-- 마면
		[12] = {},	-- 편자
		[0] = {},	-- 사용안함.
		[1] = {},	-- 사용안함.

		[14] = {},	-- 마갑
		[15] = {},	-- 등자
		[16] = {},	-- 안장
		[17] = {},	-- 마면
		[18] = {},	-- 사용안함.
		[19] = {},	-- 사용안함.
		[20] = {},	-- 사용안함.
	},
	{
		[3] = {},	-- 차체
		[4] = {},	-- 바퀴
		[5] = {},	-- 깃발
		[6] = {},	-- 휘장
		[13] = {},	-- 램프
		[25] = {},	-- 덮개
		[0] = {},	-- 사용안함.

		[14] = {},	-- 차체
		[15] = {},	-- 바퀴
		[16] = {},	-- 깃발
		[17] = {},	-- 휘장
		[26] = {},	-- 덮개
		[20] = {},	-- 사용안함.
		[21] = {},	-- 사용안함.
	},
	{
		[3] = {},	-- 낙타 마갑
		[4] = {},	-- 낙타 등자
		[5] = {},	-- 낙타 안장
		[6] = {},	-- 낙타 마면
		[12] = {},	-- 낙타 편자
		[0] = {},	-- 사용안함.
		[1] = {},	-- 사용안함.

		[14] = {},	-- 낙타 마갑
		[15] = {},	-- 낙타 등자
		[16] = {},	-- 낙타 안장
		[17] = {},	-- 낙타 마면
		[18] = {},	-- 사용안함.
		[19] = {},	-- 사용안함.
		[20] = {},	-- 사용안함.
	},
}
local partSlotno = {
		[0] = 	{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
}

local selectedDyePart = nil
local dyePartString =
{
	[0] = {
		[0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_MAINHAND"),			-- "주무기"
		[1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_SUBHAND"),				-- "보조무기"
		[3] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CHARACTER_ARMOR"),		-- "갑옷"
		[4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_GLOVES"),				-- "장갑"
		[5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_BOOTS"),				-- "신발"
		[6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_HELM"),				-- "투구"
		-- [7] = "목걸이", -- (안쓴다)

		[18] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_MAINHAND"),	-- "주무기(아바타)",
		[19] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_SUBHAND"),		-- "보조무기(아바타)",
		[14] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BODY"),		-- "갑옷(아바타)",
		[15] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HANDS"),		-- "장갑(아바타)",
		[16] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BOOTS"),		-- "신발(아바타)",
		[17] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HELM"),		-- "투구(아바타)",
		[20] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_UNDERWEAR"),	-- "속옷(아바타)",

		[21] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CHARACTER_ACC_0"),		-- "얼굴 액세서리-상단(아바타)",
		[22] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CHARACTER_ACC_1"),		-- "얼굴 액세서리-하단(아바타)",
		[23] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CHARACTER_ACC_2"),		-- "얼굴 액세서리-귀(아바타)",
		[29] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_awakenWeapon"),	-- "각성 무기",
		[30] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_avatarAwakenWeapon"),	-- "각성 무기(의상)",
	},
	{
		[3]		= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"),		-- "마갑",
		[4]		= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"),		-- "등자",
		[5]		= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"),		-- "안장",
		[6]		= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"),	-- "마면",
		[12]	= PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_FOOT"),			-- "편자",
		-- [0] = { 0, 0, 0, 0 },	-- 사용안함.
		-- [1] = { 0, 0, 0, 0 },	-- 사용안함.

		[14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_ARMOR"),		-- "마갑(아바타)",
		[15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_STIRRUP"),	-- "등자(아바타)",
		[16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_SADDLE"),		-- "안장(아바타)",
		[17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_FACE"),		-- "마면(아바타)",
		-- [18] = { 0, 0, 0, 0 },	-- 사용안함.
		-- [19] = { 0, 0, 0, 0 },	-- 사용안함.
		-- [20] = { 0, 0, 0, 0 },	-- 사용안함.
	},
	{
		[3] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_BODY"),			-- "차체",
		[4] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_TIRE"),			-- "바퀴",
		[5] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_FLAG"),			-- "깃발",
		[6] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_INSIGNIA"),		-- "휘장",
		[13] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_LAMP"),			-- "램프",
		[25] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_CORVER"),			-- "덮개",
		-- [0] = { 0, 0, 0, 0 },	-- 사용안함.

		[14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_BODY"),	-- "차체(아바타)"
		[15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_TIRE"),	-- "바퀴(아바타)"
		[16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_FLAG"),	-- "깃발(아바타)"
		[17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_INSIGNIA"),-- "휘장(아바타)"
		[26] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_CORVER"),	-- "덮개(아바타)"
		-- [20] = { 0, 0, 0, 0 },	-- 사용안함.
		-- [21] = { 0, 0, 0, 0 },	-- 사용안함.
	},
	{
		[3]		= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"),		-- "마갑", -- 낙타
		[4]		= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"),		-- "등자", -- 낙타
		[5]		= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"),		-- "안장", -- 낙타
		[6]		= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"),	-- "마면", -- 낙타
		[12]	= PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_FOOT"),			-- "편자", -- 낙타
		-- [0] = { 0, 0, 0, 0 },	-- 사용안함.
		-- [1] = { 0, 0, 0, 0 },	-- 사용안함.

		[14]	= PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_ARMOR"),	-- "마갑(아바타)",	-- 낙타
		[15]	= PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_STIRRUP"),	-- "등자(아바타)",	-- 낙타
		[16]	= PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_SADDLE"),	-- "안장(아바타)",	-- 낙타
		[17]	= PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_FACE"),	-- "마면(아바타)",	-- 낙타
		-- [18] = { 0, 0, 0, 0 },	-- 사용안함.
		-- [19] = { 0, 0, 0, 0 },	-- 사용안함.
		-- [20] = { 0, 0, 0, 0 },	-- 사용안함.
	},
}

function DyeNew:Initialize()
	self:SetPosition()

	-- 타이틀 라인 생성
	local titleLineStartPosY = 5
	for title_Idx = 0, self.dyeStepCount - 1 do
		local tempArray = {}
		local created_TitleLine = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.leftBG, 'Dye_New_TitleLine_' .. title_Idx )
		CopyBaseProperty( Template.titleLine, created_TitleLine )
		created_TitleLine:SetText( self.titleLineSting[title_Idx] )
		created_TitleLine:SetShow( false )
		tempArray.title = created_TitleLine

		local created_AreaBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, created_TitleLine, 'Dye_New_AreaBgByTitle_' .. title_Idx )
		CopyBaseProperty( Template.areaBG, created_AreaBG )
		created_AreaBG:SetPosX( 5 )
		created_AreaBG:SetPosY( created_TitleLine:GetSizeY() + 5 )
		created_AreaBG:SetShow( true )
		tempArray.AreaBG = created_AreaBG

		self.titleLineUIPool[title_Idx] = tempArray
	end

	-- 염색 대상 생성
	local dyeTargetSlot_StartPosX = 5
	for characterType_Idx = 0, self.targetCharacterSlotCount - 1 do
		local tempArray = {}
		local created_SlotBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.titleLineUIPool[0].AreaBG, 'Dye_New_characterTypeSlotBG_' .. characterType_Idx )
		CopyBaseProperty( Template.slotBG, created_SlotBG )
		created_SlotBG:SetShow( false )
		tempArray.SlotBG = created_SlotBG

		-- 미리 만들어 놓은 걸 연결함.
		created_SlotBG:AddChild( self.targetCharacter[characterType_Idx] )
		Panel_Dye_New:RemoveControl( self.targetCharacter[characterType_Idx] )
		local linked_SlotBTN = self.targetCharacter[characterType_Idx]
		linked_SlotBTN:SetShow( true )
		if self.lastCharacterSlotNo < characterType_Idx then	-- 사람, 말, 마차, 낙타
			-- 일단은 누를 수 없습니다!
			linked_SlotBTN:SetShow( false )
			linked_SlotBTN:SetMonoTone( true )
			linked_SlotBTN:SetEnable( false )
			linked_SlotBTN:SetIgnore( true )
		else
			linked_SlotBTN:SetMonoTone( false )
			linked_SlotBTN:SetEnable( true )
			linked_SlotBTN:SetIgnore( false )
		end
		linked_SlotBTN:SetPosX( 1 )
		linked_SlotBTN:SetPosY( 1 )
		linked_SlotBTN:addInputEvent("Mouse_LUp", "HandleClicked_DeyNew_SelectCharacterType( " .. characterType_Idx .. " )")
		tempArray.SlotBTN = linked_SlotBTN

		self.characterTypeUIPoll[characterType_Idx] = tempArray
	end

	-- 장비 선택 생성
	for equipSlot_Idx = 0, self.targetEuipSlotCount - 1 do
		local tempArray = {}
		local created_SlotBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.titleLineUIPool[1].AreaBG, 'Dye_New_equipSlotBG_' .. equipSlot_Idx )
		CopyBaseProperty( Template.slotBG, created_SlotBG )
		created_SlotBG:SetShow( false )
		tempArray.SlotBG = created_SlotBG

		local created_SlotIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, created_SlotBG, 'Dye_New_equipSlotIcon_' .. equipSlot_Idx )
		CopyBaseProperty( Template.slot, created_SlotIcon )
		created_SlotIcon:SetSize( 28, 28 )
		created_SlotIcon:SetPosX( 8 )
		created_SlotIcon:SetPosY( 8 )
		created_SlotIcon:SetShow( true )
		tempArray.SlotIcon = created_SlotIcon

		local created_SlotSelectBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, created_SlotBG, 'Dye_New_equipSlotSelectBG_' .. equipSlot_Idx )
		CopyBaseProperty( Template.slotSelectBG, created_SlotSelectBG )
		created_SlotSelectBG:SetPosX( 0 )
		created_SlotSelectBG:SetPosY( 0 )
		created_SlotSelectBG:SetShow( false )
		tempArray.SlotSelectBG = created_SlotSelectBG

		local equipSlot = {}
		SlotItem.new( equipSlot, 'Dye_New_equipSlotItem_' .. equipSlot_Idx, 0, created_SlotBG, self.ampuleSlotConfig )
		equipSlot:createChild()
		equipSlot.icon	:SetPosX( 0 )
		equipSlot.icon	:SetPosY( 0 )
		equipSlot.icon	:SetShow( true )
		tempArray.SlotItem = equipSlot

		self.equipSlotUIPoll[equipSlot_Idx] = tempArray
	end

	-- 장비 부위 선택 생성
	local partSlotBGMaxCount	= 4

	local partSlotBGStartX		= 5
	local partSlotBGStartY		= 5
	local partSlotBGGapX		= 85
	local partSlotBGGapY		= 38
	local partSlotBGCols		= 4
	local partSlotBGRows		= ( partSlotBGMaxCount - 1 ) / partSlotBGCols
	for partSlot_idx = 0, self.partSlotMaxCount - 1 do
		local tempArray = {}

		local partSlotBGcol			= partSlot_idx % partSlotBGCols
		local partSlotBGrow			= math.floor( partSlot_idx / partSlotBGCols )
		local partSlotBGposX		= partSlotBGStartX + partSlotBGGapX * partSlotBGcol
		local partSlotBGposY		= partSlotBGStartY + partSlotBGGapY * partSlotBGrow

		local created_PartSlotBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.titleLineUIPool[2].AreaBG, 'Dye_New_partSlotBG_' .. partSlot_idx )
		CopyBaseProperty( Template.SlotPartBG, created_PartSlotBG )
		created_PartSlotBG:SetPosX( partSlotBGposX )
		created_PartSlotBG:SetPosY( partSlotBGposY )
		created_PartSlotBG:SetShow( false )
		tempArray.PartSlotBG	= created_PartSlotBG

		local partBTNPosX = 2
		tempArray.PartSlotBGElement	= {}
		for part_Idx = 0, self.partIdxMaxCount - 1 do
			local partArray	= {}
			local created_PartBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, created_PartSlotBG, 'Dye_New_partBTN_' .. partSlot_idx .. "_" .. part_Idx )
			CopyBaseProperty( Template.BTN_part, created_PartBTN )
			created_PartBTN:SetPosX( partBTNPosX )
			created_PartBTN:SetPosY( 2 )
			created_PartBTN:SetText( part_Idx + 1 )
			created_PartBTN:SetShow( false )
			created_PartBTN:SetAlphaIgnore( true )
			partArray.partBTN	= created_PartBTN

			local created_PartResetBTN = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, created_PartBTN, 'Dye_New_partResetBTN_' .. partSlot_idx .. "_" .. part_Idx )
			CopyBaseProperty( Template.BTN_resetPart, created_PartResetBTN )
			created_PartResetBTN:SetSpanSize( -3, -4 )
			created_PartResetBTN:SetShow( false )
			partArray.partResetBTN	= created_PartResetBTN		

			tempArray.PartSlotBGElement[part_Idx] = partArray

			partBTNPosX	= partBTNPosX + created_PartBTN:GetSizeX() -5
		end

		self.partSlotUIPoll[partSlot_idx] = tempArray
	end

	-- { 팔레트
		for slotRowsIdx = 0, self.palette.config.maxSlotRowsCount -1 do
			self.palette.slot[slotRowsIdx] = {}
			for slotColsIdx = 0, self.palette.config.maxSlotColsCount -1 do
				self.palette.slot[slotRowsIdx][slotColsIdx] = {}
				local slot = self.palette.slot[slotRowsIdx][slotColsIdx]
				slot.bg		= UI.createAndCopyBasePropertyControl( Panel_Dye_New, "Static_PaletteSlotBG",			self.titleLineUIPool[3].AreaBG,	"DyeNew_PaletteSlotBG_"			.. slotColsIdx .. "_" .. slotRowsIdx )
				slot.color	= UI.createAndCopyBasePropertyControl( Panel_Dye_New, "Static_PaletteColor",			slot.bg	,						"DyeNew_PaletteSlot_Color_"			.. slotColsIdx .. "_" .. slotRowsIdx )
				slot.count	= UI.createAndCopyBasePropertyControl( Panel_Dye_New, "StaticText_PaletteColorCount",	slot.bg	,						"DyeNew_PaletteSlot_Count_"		.. slotColsIdx .. "_" .. slotRowsIdx )
				slot.btn	= UI.createAndCopyBasePropertyControl( Panel_Dye_New, "RadioButton_PaletteSlot",		slot.bg	,						"DyeNew_PaletteSlot_ColorBtn_"	.. slotColsIdx .. "_" .. slotRowsIdx )

				local slotPosX = ((slot.bg:GetSizeX()+self.palette.config.cellSpan) * slotColsIdx) + self.palette.config.startPosX
				local slotPosY = ((slot.bg:GetSizeY()+self.palette.config.cellSpan) * slotRowsIdx) + self.palette.config.startPosY
				slot.color	:SetAlphaIgnore( true )

				slot.bg		:SetPosX( slotPosX )
				slot.bg		:SetPosY( slotPosY )
				slot.color	:SetPosX( 0 )
				slot.color	:SetPosY( 0 )
				slot.count	:SetPosX( 0 )
				slot.count	:SetPosY( 25 )
				slot.btn	:SetPosX( 0 )
				slot.btn	:SetPosY( 0 )

				slot.btn	:addInputEvent( "Mouse_UpScroll", 		"dye_New_Ampule_ScrollUpdate( true )")
				slot.btn	:addInputEvent( "Mouse_DownScroll",		"dye_New_Ampule_ScrollUpdate( false )")
			end
		end
	-- }


	self.titleLineUIPool[3].AreaBG	:SetIgnore( false )
	self.titleLineUIPool[3].AreaBG	:addInputEvent("Mouse_UpScroll",	"dye_New_Ampule_ScrollUpdate( true )")
	self.titleLineUIPool[3].AreaBG	:addInputEvent("Mouse_DownScroll",	"dye_New_Ampule_ScrollUpdate( false )")

	self.titleLineUIPool[3].AreaBG	:AddChild( self.scroll )
	Panel_Dye_New					:RemoveControl( self.scroll )
	self.scroll						:SetControlTop()

	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_TabAll )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_TabMy )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_TabPearl )
	
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_Material[0] )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_Material[1] )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_Material[2] )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_Material[3] )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_Material[4] )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_Material[5] )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_Material[6] )
	self.titleLineUIPool[3].AreaBG	:AddChild( self.palette.ui._btn_Material[7] )

	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_TabAll )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_TabMy )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_TabPearl )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_Material[0] )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_Material[1] )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_Material[2] )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_Material[3] )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_Material[4] )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_Material[5] )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_Material[6] )
	Panel_Dye_New					:RemoveControl( self.palette.ui._btn_Material[7] )

	-- { 기타 설정
		self.static_SetOptionBG			:AddChild( self.txt_Endurance )
		self.static_SetOptionBG			:AddChild( self.btn_ShowUnderwear )
		self.static_SetOptionBG			:AddChild( self.btn_HideAvatar )
		self.static_SetOptionBG			:AddChild( self.Slider_Endurance )
		self.static_SetOptionBG			:AddChild( self.btn_Dodye )
		self.static_SetOptionBG			:AddChild( self.btn_HairHide )
		self.static_SetOptionBG			:AddChild( self.btn_HelmHide )
		self.static_SetOptionBG			:AddChild( self.btn_OpenHelm )
		self.static_SetOptionBG			:AddChild( self.btn_AwakenWeapon )
		Panel_Dye_New					:RemoveControl( self.txt_Endurance )
		Panel_Dye_New					:RemoveControl( self.btn_ShowUnderwear )
		Panel_Dye_New					:RemoveControl( self.btn_HideAvatar )
		Panel_Dye_New					:RemoveControl( self.Slider_Endurance )
		Panel_Dye_New					:RemoveControl( self.btn_Dodye )
		Panel_Dye_New					:RemoveControl( self.btn_HairHide )
		Panel_Dye_New					:RemoveControl( self.btn_HelmHide )
		Panel_Dye_New					:RemoveControl( self.btn_OpenHelm )
		Panel_Dye_New					:RemoveControl( self.btn_AwakenWeapon )

		self.txt_Endurance				:SetPosX(5)
		self.txt_Endurance				:SetPosY(8)
		self.Slider_Endurance			:SetPosX( self.txt_Endurance:GetPosX() + self.txt_Endurance:GetSizeX() + 5 )
		self.Slider_Endurance			:SetPosY( 15 )
		self.btn_ShowUnderwear			:SetPosX( self.Slider_Endurance:GetPosX() + self.Slider_Endurance:GetSizeX() + 5 )
		self.btn_ShowUnderwear			:SetPosY( 3 )
		self.btn_HideAvatar				:SetPosX( self.btn_ShowUnderwear:GetPosX() + self.btn_ShowUnderwear:GetSizeX() )
		self.btn_HideAvatar				:SetPosY( 3 )
		self.btn_HairHide				:SetPosX( self.btn_HideAvatar:GetPosX() + self.btn_HideAvatar:GetSizeX() )
		self.btn_HairHide				:SetPosY( 3 )
		self.btn_HelmHide				:SetPosX( self.btn_HairHide:GetPosX() + self.btn_HairHide:GetSizeX() )
		self.btn_HelmHide				:SetPosY( 3 )
		self.btn_OpenHelm				:SetPosX( self.btn_HelmHide:GetPosX() + self.btn_HelmHide:GetSizeX() )
		self.btn_OpenHelm				:SetPosY( 3 )
		self.btn_AwakenWeapon			:SetPosX( self.btn_OpenHelm:GetPosX() + self.btn_OpenHelm:GetSizeX() )
		self.btn_AwakenWeapon			:SetPosY( 3 )

		self.btn_Dodye					:SetPosX( 100 )
		self.btn_Dodye					:SetPosY( 40 )

		self.panelTitle					:ComputePos()
		self.Slider_Endurance			:SetInterval( 99 )
	-- }
end

function DyeNew:UpdatePosition()
	-- 스텝 단위 타이틀/배경 켬
	for title_Idx = 0, self.dyeStepCount - 1 do
		local contentGroup = self.titleLineUIPool[title_Idx]
		contentGroup.title:SetPosX( 5 )
		contentGroup.title:SetShow( true )
	end
	----------------------------------------------------------------------------
	-- 염색 대상 타이틀 포지션
	----------------------------------------------------------------------------
	local characterTypeContentUI = self.titleLineUIPool[0]
	characterTypeContentUI.title:SetPosY( 5 )

	-- 염색 대상 켬
	local characterTypePosX			= 5
	local characterTypeContentPosY	= 0
	for characterType_Idx = 0, self.targetCharacterSlotCount - 1 do
		local areaBG = self.titleLineUIPool[0].AreaBG
		local UiBase = self.characterTypeUIPoll[characterType_Idx]
		UiBase.SlotBG:SetPosX( characterTypePosX )
		UiBase.SlotBG:SetPosY( 5 )
		UiBase.SlotBG:SetShow( true )
		UiBase.SlotBTN:SetCheck( false )
		if self.selected_characterType == characterType_Idx then
			UiBase.SlotBTN:SetCheck( true )
		end
		if 3 < characterType_Idx then
			UiBase.SlotBTN:SetShow( false )
		end
		characterTypePosX			= characterTypePosX + UiBase.SlotBG:GetSizeX() + 3
		characterTypeContentPosY	= UiBase.SlotBG:GetPosY() + UiBase.SlotBG:GetSizeY() +  5
	end
	
	characterTypeContentUI.AreaBG:SetSize( characterTypeContentUI.AreaBG:GetSizeX(), characterTypeContentPosY )

	-- 장비 선택
	----------------------------------------------------------------------------
	-- 장비 선택 타이틀 포지션
	----------------------------------------------------------------------------
	local equipSlotContentUI = self.titleLineUIPool[1]
	equipSlotContentUI.title:SetPosY( characterTypeContentUI.title:GetPosY() + characterTypeContentUI.title:GetSizeY() + 5 + characterTypeContentUI.AreaBG:GetSizeY() + 5 )
	-- 초기화
	for equipSlot_Idx = 0, self.targetEuipSlotCount - 1 do
		local UiBase = self.equipSlotUIPoll[equipSlot_Idx]
		UiBase.SlotBG:SetShow( false )
	end	

	local maxEquipSlotCount = 7
	if 0 == self.selected_characterType then
		maxEquipSlotCount = 14
	end

	local equipSlotStartX	= 5
	local equipSlotStartY	= 5
	local equipSlotGapX		= 47
	local equipSlotGapY		= 47
	local equipSlotCols		= 7
	local equipSlotRows		= (self.targetEuipSlotCount - 1) / equipSlotCols
	local equipContentPosY	= 0
	local tempSlotIdx	= 0
	for idx,value in pairs(equipSlotNo[self.selected_characterType]) do
		local col		= tempSlotIdx % equipSlotCols
		local row		= math.floor( tempSlotIdx / equipSlotCols )
		local posX		= equipSlotStartX + equipSlotGapX * col
		local posY		= equipSlotStartY + equipSlotGapY * row

		local UiBase = self.equipSlotUIPoll[tempSlotIdx]
		UiBase.SlotBG:SetPosX( posX )
		UiBase.SlotBG:SetPosY( posY )
		UiBase.SlotBG:SetShow( true )

		-- 아이콘을 변환시킴
		-- UiBase.SlotIcon:SetShow( true )
		_dye_ReplaceEquipBGIcon( value )

		equipContentPosY = posY + UiBase.SlotBG:GetSizeY() + 5
		tempSlotIdx = tempSlotIdx + 1
	end
	equipSlotContentUI.AreaBG:SetSize( equipSlotContentUI.AreaBG:GetSizeX(), equipContentPosY )
	if not awakenWeaponContentsOpen then
		self.equipSlotUIPoll[self.targetEuipSlotCount - 2].SlotBG:SetShow( awakenWeaponContentsOpen )
		self.equipSlotUIPoll[self.targetEuipSlotCount - 1].SlotBG:SetShow( awakenWeaponContentsOpen )
	end
	

	----------------------------------------------------------------------------
	-- 장비 부위 선택
	----------------------------------------------------------------------------
	local equipPartsContentUI = self.titleLineUIPool[2]
	equipPartsContentUI.title:SetPosY( equipSlotContentUI.title:GetPosY() + equipSlotContentUI.title:GetSizeY() + 5 + equipSlotContentUI.AreaBG:GetSizeY() + 5 )

	local partSlotCount = 0
	for partSlot_idx = 0, self.partSlotMaxCount - 1 do
		local UiBase = self.partSlotUIPoll[partSlot_idx]
		if UiBase.PartSlotBG:GetShow() then
			partSlotCount = partSlotCount + 1
		end
	end
	equipPartsContentUI.AreaBG:SetSize( equipSlotContentUI.AreaBG:GetSizeX(), (self.partSlotUIPoll[0].PartSlotBG:GetSizeY() * 2) + 15 )


	----------------------------------------------------------------------------
	-- 팔레트
	----------------------------------------------------------------------------
	local ampuleContentUI = self.titleLineUIPool[3]
	ampuleContentUI.title:SetPosY( equipPartsContentUI.title:GetPosY() + equipPartsContentUI.title:GetSizeY() + 5 + equipPartsContentUI.AreaBG:GetSizeY() + 5 )

	local ampuleSlotPosY = 195	-- 팔레트 사이즈 임시
	if getScreenSizeY() < 900 then
		ampuleSlotPosY = 145
	end
	ampuleContentUI.AreaBG:SetSize( equipSlotContentUI.AreaBG:GetSizeX(), ampuleSlotPosY )

	self.leftBG		:SetSize( self.leftBG:GetSizeX(), ampuleContentUI.title:GetPosY() + ampuleContentUI.AreaBG:GetPosY() + ampuleContentUI.AreaBG:GetSizeY() + 10 )
	self.panelTitle	:ComputePos()
end
function DyeNew:Update_EquipItem()
	local equipSlotNos = self.selectedEquipSlotNo

	-- 선택한 장비에 BG를 켠다.
	for idx,equipSlotIdx in pairs(equipSlotNo[self.selected_characterType]) do
		local UiBase = self.equipSlotUIPoll[idx-1]
		UiBase.SlotSelectBG:SetShow( false )
		if equipSlotNos == equipSlotIdx then
			UiBase.SlotSelectBG:SetShow( true )
		end
	end

	-- SlotIcon이 bg 아이콘이다. SlotItem

	----------------------------------------------------------------------------
	-- 아래부터는 장착 부위 쪽 설정을 위한 세팅.
	-- 초기화
	for UIPoolidx = 0, self.partSlotMaxCount -1 do
		local UiBase = self.partSlotUIPoll[UIPoolidx]
		UiBase.PartSlotBG	:SetShow( false )
		for partSlot_Idx = 0, 2 do
			UiBase.PartSlotBGElement[partSlot_Idx].partBTN:SetShow( false )
			UiBase.PartSlotBGElement[partSlot_Idx].partBTN:addInputEvent( "Mouse_LUp", "" )
		end	
	end

	-- 파트 제어용.
	dye_resetPartSlotNoArray()	-- 배열에 저장된 파트 슬롯 넘버를 초기화 한다.

	-- 배열을 만든다.
	local tempUiIdx = 0
	for partIdx = 0, self.partClientCount -1 do
		local partSlot = equipSlotDyeInfo[self.selected_characterType][equipSlotNos][partIdx]
		if nil ~= partSlot then
			local slotCount = ToClient_RequestGetPartDyeingSlotCount( equipSlotNos, partIdx )
			for partSlot_Idx = 0, slotCount - 1 do
				local clientSlotNo	= ToClient_RequestGetPartDyeingSlotNo( equipSlotNos, partIdx, partSlot_Idx)
				-- 배열에 저장한다.
				partSlotno[partIdx][partSlot_Idx].slotNo	= clientSlotNo
				partSlotno[partIdx][partSlot_Idx].uiIdx		= tempUiIdx
			end
			tempUiIdx = tempUiIdx + 1
		end
	end

	self:Update_Part()
	self:UpdatePosition()
end

function DyeNew:ResetPartArray()	-- 파트 배열 초기화
	-- 파트 제어용.
	dye_resetPartSlotNoArray()	-- 배열에 저장된 파트 슬롯 넘버를 초기화 한다.

	-- 배열을 만든다.
	local equipSlotNos = self.selectedEquipSlotNo
	local tempUiIdx = 0
	for partIdx = 0, self.partClientCount -1 do
		local partSlot = equipSlotDyeInfo[self.selected_characterType][equipSlotNos][partIdx]
		if nil ~= partSlot then
			local slotCount = ToClient_RequestGetPartDyeingSlotCount( equipSlotNos, partIdx )
			for partSlot_Idx = 0, slotCount - 1 do
				local clientSlotNo	= ToClient_RequestGetPartDyeingSlotNo( equipSlotNos, partIdx, partSlot_Idx)
				-- 배열에 저장한다.
				partSlotno[partIdx][partSlot_Idx].slotNo	= clientSlotNo
				partSlotno[partIdx][partSlot_Idx].uiIdx		= tempUiIdx
			end
			tempUiIdx = tempUiIdx + 1
		end
	end
end

function DyeNew:Update_Part()
	local equipSlotNo	= self.selectedEquipSlotNo
	local partId		= self.selectedPart.partId
	local slotId		= self.selectedPart.slotId
	local uiIdx			= self.selectedPart.uiIdx

	-- 라디오 버튼 초기화.
	for UIPoolidx = 0, self.partSlotMaxCount -1 do
		local UiBase = self.partSlotUIPoll[UIPoolidx]
		for partSlot_Idx = 0, 2 do
			UiBase.PartSlotBGElement[partSlot_Idx].partBTN:SetShow( false )
			UiBase.PartSlotBGElement[partSlot_Idx].partBTN:SetCheck(false)
			UiBase.PartSlotBGElement[partSlot_Idx].partResetBTN:SetShow( false )
		end	
	end

	-- 누른 것을 처리한다.
	if true == self.isPartClick then
		local UiBase = self.partSlotUIPoll[uiIdx]
		local partBTN = UiBase.PartSlotBGElement[slotId].partBTN
		partBTN:SetCheck( true )
		--partBTN:setRenderTexture( partBTN:getClickTexture() )
	end

	-- 정보를 세팅한다.
	local tempUiIdx = 0
	for partIdx = 0, self.partClientCount -1 do
		local partSlot = equipSlotDyeInfo[self.selected_characterType][equipSlotNo][partIdx]
		if nil ~= partSlot then
			local UiBase = self.partSlotUIPoll[tempUiIdx]
			UiBase.PartSlotBG	:SetShow( true )

			-- 슬롯이 몇개가 있나?
			local slotCount = ToClient_RequestGetPartDyeingSlotCount( equipSlotNo, partIdx )	--가급적 안쓰는게 좋은데?
			for partSlot_Idx = 0, slotCount - 1 do
				local clientSlotNo	= ToClient_RequestGetPartDyeingSlotNo( equipSlotNo, partIdx, partSlot_Idx)
				UiBase.PartSlotBGElement[partSlot_Idx].partBTN:SetText( clientSlotNo )
				UiBase.PartSlotBGElement[partSlot_Idx].partBTN:SetShow( true )
				UiBase.PartSlotBGElement[partSlot_Idx].partBTN:addInputEvent( "Mouse_LUp", " dye_New_SelectPart( " .. partIdx .. ", " .. partSlot_Idx .. ", " .. tempUiIdx .. " )" )

				-- 컬러가 입혀져 있으면 나온다.
				local getColorInfo = ToClient_RequestGetUsedPartColor( equipSlotNo, partIdx, partSlot_Idx )
				UiBase.PartSlotBGElement[partSlot_Idx].partBTN:SetColor( getColorInfo )
				local isReset = ToClient_RequestIsResetDyeingPartSlot( equipSlotNo, partIdx, partSlot_Idx )
				if isReset then
					UiBase.PartSlotBGElement[partSlot_Idx].partResetBTN:SetShow( true )
					UiBase.PartSlotBGElement[partSlot_Idx].partResetBTN:addInputEvent( "Mouse_LUp", " dye_New_ResetPartColor( " .. equipSlotNo .. ", " .. partIdx .. ", " .. partSlot_Idx .. ", " .. tempUiIdx .. " )" )
				else
					UiBase.PartSlotBGElement[partSlot_Idx].partResetBTN:SetShow( false )
				end
			end
			tempUiIdx = tempUiIdx + 1
		end
	end

	if -1 == partId then
		return
	end
	-- 같은 slotNo를 쓰는 것을 찾기 위해
	local checkslotCount	= ToClient_RequestGetPartDyeingSlotCount( equipSlotNo, self.selected_characterType )	-- 정보가 없는 것을 필터하기 위해.	
	--가급적 안쓰는게 좋은데?
	local arraySlotNo		= partSlotno[partId][slotId].slotNo
	local selectedSlotNo	= ToClient_RequestGetPartDyeingSlotNo( equipSlotNo, partId, slotId)

	if -1 == arraySlotNo then
		if 0 == checkslotCount then
			-- _PA_ASSERT(false, "기본 파트 설정이 없다. 데이터 확인 필요함.")
		else
			-- _PA_ASSERT(false, "염색 정보 임시 배열에 저장된 값이 없다0!")
		end
		return
	end

	-- 슬롯 넘버가 같은 것을 체크 해줘야 한다.
	local tempUiIdx = 0
	for partIdx = 0, self.partClientCount -1 do
		local partSlot = equipSlotDyeInfo[self.selected_characterType][equipSlotNo][partIdx]
		if nil ~= partSlot then
			local slotCount = ToClient_RequestGetPartDyeingSlotCount( equipSlotNo, partIdx )
			for partSlot_Idx = 0, slotCount - 1 do
				local savedUiIdx	= partSlotno[partIdx][partSlot_Idx].uiIdx
				local savedSlotNo	= partSlotno[partIdx][partSlot_Idx].slotNo
				if -1 == savedSlotNo or -1 == savedUiIdx then
					-- _PA_ASSERT(false, "염색 정보 임시 배열에 저장된 값이 없다1!")
					return
				end
				if selectedSlotNo == savedSlotNo and tempUiIdx == savedUiIdx then
					local UiBase	= self.partSlotUIPoll[tempUiIdx]
					UiBase.PartSlotBGElement[partSlot_Idx].partBTN:SetCheck( true )
				end
			end
			tempUiIdx = tempUiIdx + 1
		end
	end
end

function DyeNew:PaletteChangeTexture( isFill, rowsIdx, colsIdx )
		local slot	= self.palette.slot[rowsIdx][colsIdx].color
		local x1, y1, x2, y2 = nil, nil, nil, nil
		if true == isFill then	-- 색이 있다.
			slot:ChangeTextureInfoName("DyeSlot_n.dds")
			slot:getBaseTexture():setUV( 0, 0, 1, 1 )
			slot:setRenderTexture(slot:getBaseTexture())
		else
			slot:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Buttons_02.dds")
			slot:getBaseTexture():setUV( setTextureUV_Func( slot, 55, 209, 99, 253 ) )
			slot:setRenderTexture(slot:getBaseTexture())
		end
	end	

function DyeNew:Update_AmpuleList()		-- 팔레트 업데이트
	local paletteConfig				= self.palette.config
	local category					= paletteConfig.selectedCategoryIdx
	local isShowAll					= paletteConfig.isShowAll
	local isPearl					= paletteConfig.isPearlPallete

	-- 소유 버튼
	self.palette.ui._btn_TabAll		:SetCheck( isShowAll and not isPearl )
	self.palette.ui._btn_TabMy		:SetCheck( not isShowAll and not isPearl )
	self.palette.ui._btn_TabPearl	:SetCheck( isShowAll and isPearl )
	for idx = 0, 7 do		-- 재질 타입 버튼 처리.
		if idx == category then
			DyeNew.palette.ui._btn_Material[idx]:SetCheck( true )
		else
			DyeNew.palette.ui._btn_Material[idx]:SetCheck( false )
		end
	end

	-- { 초기화
		for slotRowsIdx = 0, paletteConfig.maxSlotRowsCount -1 do
			for slotColsIdx = 0, paletteConfig.maxSlotColsCount -1 do
				local slot			= self.palette.slot[slotRowsIdx][slotColsIdx]
				local clearColor	= 16777215
				self:PaletteChangeTexture( false, slotRowsIdx, slotColsIdx )	-- 텍스쳐 변경
				slot.bg		:SetShow( false )
				slot.color	:SetColor( clearColor )
				slot.count	:SetText( "0" )
				slot.count	:SetShow( false )
				slot.btn	:SetCheck( false )

				slot.btn	:addInputEvent( "Mouse_LUp",	"")
				slot.btn	:addInputEvent( "Mouse_On",		"")
				slot.btn	:addInputEvent( "Mouse_Out",	"")
				slot.btn	:setTooltipEventRegistFunc( "" )
			end
		end
	-- }
	
	local DyeingPaletteCategoryInfo	= ToClient_requestGetPaletteCategoryInfo( category, isShowAll )
	if nil ~= DyeingPaletteCategoryInfo then
		-- { 염색약 업데이트
			local colorCount				= DyeingPaletteCategoryInfo:getListSize()
			paletteConfig.colorTotalRows	= math.ceil((colorCount / paletteConfig.maxSlotColsCount))
			local uiIndex = 0
			for slotRowsIdx = 0, paletteConfig.resizeSlotRowsCount -1 do
				for slotColsIdx = 0, paletteConfig.maxSlotColsCount -1 do
					local slot		= self.palette.slot[slotRowsIdx][slotColsIdx]
					local dataIdx	= uiIndex + ( (paletteConfig.scrollStartIdx * paletteConfig.maxSlotColsCount) )
					slot.bg		:SetShow( true )
					
					if dataIdx < colorCount then
						local colorValue		= DyeingPaletteCategoryInfo:getColor( dataIdx )
						local itemEnchantKey	= DyeingPaletteCategoryInfo:getItemEnchantKey( dataIdx )
						local isDyeUI			= true
						local ampuleCount		= DyeingPaletteCategoryInfo:getCount( dataIdx, isDyeUI )

						self:PaletteChangeTexture( true, slotRowsIdx, slotColsIdx )	-- 텍스쳐 변경						
						slot.color	:SetColor( colorValue  )
						if not isPearl then
							slot.count	:SetText( tostring(ampuleCount) )
							slot.count	:SetShow( true )
						end

						if dataIdx == paletteConfig.selectedColorIdx then	-- 눌린 것을 눌린 처리.
							slot.btn	:SetCheck( true )
						end

						slot.btn	:addInputEvent( "Mouse_LUp",	"HandleClicked_DeyNew_Palette_SelectColor( " .. dataIdx .. " )")
						slot.btn	:addInputEvent( "Mouse_On",		"HandleOnOut_DeyNew_Palette_Color( true, " .. itemEnchantKey .. ", " .. slotRowsIdx .. ", " .. slotColsIdx .. " )")
						slot.btn	:addInputEvent( "Mouse_Out",	"HandleOnOut_DeyNew_Palette_Color( false, " .. itemEnchantKey .. ", " .. slotRowsIdx .. ", " .. slotColsIdx .. " )")
						slot.btn	:setTooltipEventRegistFunc( "HandleOnOut_DeyNew_Palette_Color( true, " .. itemEnchantKey .. ", " .. slotRowsIdx .. ", " .. slotColsIdx .. " )" )
						uiIndex = uiIndex + 1
					end
				end
			end
		-- }
	end
	UIScroll.SetButtonSize( self.scroll, paletteConfig.resizeSlotRowsCount, paletteConfig.colorTotalRows)

	if self.scrollCTRLBTN:GetSizeY() < 20 then	-- 더 작아지는 경우를 막는다.
		self.scrollCTRLBTN:SetSize( self.scrollCTRLBTN:GetSizeX(), 20 )
	end
end

function DyeNew:SetPosition()
	self.panelTitle					:SetSize( Panel_Dye_New:GetSizeX()-15, self.panelTitle:GetSizeY() )
	self.leftBG						:SetPosX( 23 )
	self.leftBG						:SetPosY( 60 )
	self.static_SetOptionBG			:SetPosX( self.leftBG:GetPosX() + ((self.leftBG:GetSizeX()/2) - (self.static_SetOptionBG:GetSizeX()/2) )  )
	self.static_SetOptionBG			:SetPosY( self.leftBG:GetPosY() + self.leftBG:GetSizeY() + 10 )
	self.static_SetOptionBG			:SetSize( Panel_Dye_New:GetSizeX() - 50, self.static_SetOptionBG:GetSizeY() )
	Panel_Dye_New					:SetSize( Panel_Dye_New:GetSizeX(), self.leftBG:GetSizeY() + 165 )
end

function DyeNew:Open()
	-- 변수 초기화
	dye_resetPartSlotNoArray()
	dye_resetEquipDATAArray()

	self.selected_characterType	= 0
	self.selectedEquipSlotNo	= 0	-- !!!
	self.isPartClick			= false
	self.selectedPart.partId	= -1
	self.selectedPart.slotId	= -1
	self.selectedPart.uiIdx		= -1
	self.isSelectedEquipSlot	= false

	local isHairHide = ToClient_getFaceViewHair()
	self.btn_HairHide:SetCheck( isEyeSee )

	self.isHideBattleHelmet = true
	self.btn_HelmHide		:SetCheck( true )
	self.btn_OpenHelm		:SetCheck( false )
	self.btn_AwakenWeapon	:SetCheck( ToClient_GetAwakenWeaponShow() )

	self.Slider_Endurance	:SetControlPos(100)
	self.btn_ShowUnderwear	:SetCheck(false)
	self.btn_HideAvatar		:SetCheck(false)

	ToClient_DyeingManagerShow()
	ToClient_RequestSetTargetType( self.selected_characterType )
	ToClient_RequestPrepareDyeing()			-- 장비에 맞춰 세팅한다. 업데이트보다 나중에 해야 한다.

	self:Update_EquipItem()
	self:Update_Part()

	-- 앰플 리스트를 만들어야 한다.
	dye_New_AmpuleScrollSet()										-- 염료에 대한 스크롤을 세팅한다.

	self.palette.config.isShowAll			= false
	self.palette.config.isPearlPallete		= false
	self.palette.config.selectedCategoryIdx	= 0
	self.palette.config.scrollStartIdx		= 0
	self.scroll:SetControlTop()
	self:Update_AmpuleList()										-- 팔레트 업데이트

	self:UpdatePosition()
	self:SetPosition()
	Panel_Dye_New:SetShow( true )
	audioPostEvent_SystemUi(01,23)
	
	selectedDyePart = {}
end

function DyeNew:Close()
	audioPostEvent_SystemUi(01,23)
	-- FGlobal_MovieGuide_Reposition()
	Panel_Dye_New:SetShow( false )

	if Panel_ChangeWeapon:GetShow() then
		WeaponChange_Close()
	end

	if Panel_ChangeWeapon:GetShow() then
		WeaponChange_Close()
	end
end

function DyeNew:IsShow()
	return Panel_Dye_New:IsShow()
end



--------------------------------------------------------------------------------
-- 내부 함수
--------------------------------------------------------------------------------
function _dye_ReplaceEquipBGIcon( characterType )
	local self = DyeNew
	for equipSlot_Idx = 0, 13 do
		local UiBase = self.equipSlotUIPoll[equipSlot_Idx]
		UiBase.SlotIcon:ChangeTextureInfoName("")
	end

	-- local maxEquipSlotCount = 7
	-- if 0 == self.selected_characterType then
	-- 	maxEquipSlotCount = 14
	-- end

	-- for equipSlot_Idx = 0, maxEquipSlotCount - 1 do
	local slotIdx = 0
	for idx,equipSlotIdx in pairs(equipSlotNo[self.selected_characterType]) do
		local UiBase = self.equipSlotUIPoll[slotIdx]
		__dye_ReplaceEquipBGIcon( UiBase.SlotIcon, self.selected_characterType, equipSlotIdx  )
		slotIdx = slotIdx + 1
	end
end
function __dye_ReplaceEquipBGIcon( control, characterType, equipSlotIdx )
	if 0 == characterType then
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Window/Dye/Dye_New_00.dds" )
	elseif 1 == characterType or 3 == characterType then
		control:ChangeTextureInfoName ( "New_UI_Common_forLua/Window/Dye/Dye_New_01.dds" )

	end

	local x1, y1, x2, y2 = setTextureUV_Func( control, equipSlotIcon[characterType][equipSlotIdx][1], equipSlotIcon[characterType][equipSlotIdx][2], equipSlotIcon[characterType][equipSlotIdx][3], equipSlotIcon[characterType][equipSlotIdx][4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture(control:getBaseTexture())
end

function dye_New_UpdateEquipSlot( equipSlotNo, itemWrapper, UiIdx )	-- 장비 슬롯을 세팅.
	local self		= DyeNew
	local UiBase	= self.equipSlotUIPoll[UiIdx]
	if nil ~= itemWrapper and itemWrapper:isDyeable() then
		UiBase.SlotItem:setItem( itemWrapper )
		UiBase.SlotItem.icon:addInputEvent( "Mouse_LUp",	"dye_New_SelectEquipItem( " .. equipSlotNo .. " )" )
		UiBase.SlotItem.icon:addInputEvent( "Mouse_RUp",	"dye_New_ClearEquipItem( " .. equipSlotNo .. " ) " )
		UiBase.SlotItem.icon:addInputEvent( "Mouse_On",		"dye_New_Equip_ShowToolTip( true, " .. equipSlotNo .. ", " .. UiIdx .. " )" )
		UiBase.SlotItem.icon:addInputEvent( "Mouse_Out",	"dye_New_Equip_ShowToolTip( false, " .. equipSlotNo .. ", " .. UiIdx .. " )" )
	else
		UiBase.SlotItem:clearItem()
		UiBase.SlotItem.icon:addInputEvent( "Mouse_LUp",	"" )
		UiBase.SlotItem.icon:addInputEvent( "Mouse_RUp",	"" )
		UiBase.SlotItem.icon:addInputEvent( "Mouse_On",		"" )
		UiBase.SlotItem.icon:addInputEvent( "Mouse_Out",	"" )
	end
end
function dye_resetPartSlotNoArray()
	partSlotno = {
		[0] = 	{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
				{ [0] = { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1}, { slotNo = -1, uiIdx = -1} },
	}
end
function dye_resetEquipDATAArray()
	equipSlotDyeInfo = {
	[0] = {
		[0]		= {},
		[1]		= {},
		[3]		= {},
		[4]		= {},
		[5]		= {},
		[6]		= {},
		[7]		= {},
		
		[18]	= {},
		[19]	= {},
		[14]	= {},
		[15]	= {},
		[16]	= {},
		[17]	= {},
		[20]	= {},
		[21]	= {},
		[22]	= {},
		[23]	= {},
		[29]	= {},
		[30]	= {},
	},
	{
		[3] 	= {},	-- 마갑
		[4] 	= {},	-- 등자
		[5] 	= {},	-- 안장
		[6] 	= {},	-- 마면
		[12] 	= {},	-- 편자.
		[0] 	= {},	-- 사용안함.
		[1] 	= {},	-- 사용안함.

		[14] 	= {},	-- 마갑
		[15] 	= {},	-- 등자
		[16] 	= {},	-- 안장
		[17] 	= {},	-- 마면
		[18] 	= {},	-- 사용안함.
		[19] 	= {},	-- 사용안함.
		[20] 	= {},	-- 사용안함.
	},
	{
		[3] 	= {},	-- 차체
		[4] 	= {},	-- 바퀴
		[5] 	= {},	-- 깃발
		[6] 	= {},	-- 휘장
		[13] 	= {},	-- 램프
		[25] 	= {},	-- 덮개
		[0] 	= {},	-- 사용안함.

		[14] 	= {},	-- 차체
		[15] 	= {},	-- 바퀴
		[16] 	= {},	-- 깃발
		[17] 	= {},	-- 휘장
		[26] 	= {},	-- 덮개
		[20] 	= {},	-- 사용안함.
		[21] 	= {},	-- 사용안함.
	},
	{
		[3] 	= {},	-- 낙타 마갑
		[4] 	= {},	-- 낙타 등자
		[5] 	= {},	-- 낙타 안장
		[6] 	= {},	-- 낙타 마면
		[12] 	= {},	-- 낙타 편자.
		[0] 	= {},	-- 사용안함.
		[1] 	= {},	-- 사용안함.

		[14] 	= {},	-- 낙타 마갑
		[15] 	= {},	-- 낙타 등자
		[16] 	= {},	-- 낙타 안장
		[17] 	= {},	-- 낙타 마면
		[18] 	= {},	-- 사용안함.
		[19] 	= {},	-- 사용안함.
		[20] 	= {},	-- 사용안함.
	},
}
end
function dye_New_Equip_ShowToolTip( isShow, equipSlotNo, UiIdx )
	local self			= DyeNew
	if true == isShow then
		local itemWrapper	= ToClient_RequestGetDyeingTargetItemWrapper( equipSlotNo )
		local SlotIcon		= self.equipSlotUIPoll[UiIdx].SlotItem.icon
		Panel_Tooltip_Item_Show( itemWrapper, SlotIcon, false, true )
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

function FromClient_NotifySelectedEquipSlotNo( equipSlotNo )
	dye_New_SelectEquipItem( equipSlotNo )
end


function dye_New_SelectEquipItem( equipSlotNos )
	local self			= DyeNew
	self.selectedEquipSlotNo = equipSlotNos
	self.isPartClick			= false
	self.selectedPart.partId	= 0
	self.selectedPart.slotId	= 0
	self.selectedPart.uiIdx		= 0
	self.isSelectedEquipSlot	= true

	self:Update_EquipItem()
	
	if 20 == equipSlotNos then
		self.btn_ShowUnderwear:SetCheck( true )
	else
		self.btn_ShowUnderwear:SetCheck( false )
	end
	
	if Dye_New_IsAvatar( equipSlotNos ) then
		self.btn_HideAvatar:SetCheck( false )
		self.isHideAvatar = false
	else
		self.btn_HideAvatar:SetCheck( true )
		self.isHideAvatar = true
	end
	
	ToClient_RequestSelectedEquipItem( equipSlotNos )
	dye_New_SelectPart(0, 0, 0)
	-- 속옷 여부를 알리는 함수를 넣어야 한다.
end

function dye_New_ClearEquipItem( equipSlotNo )
	Panel_Tooltip_Item_hideTooltip()
	ToClient_RequestClearDyeingTargetSlot( equipSlotNo )
end

function Dye_New_IsAvatar( equipSlotNo )
	local self = DyeNew
	if 0 == self.selected_characterType then
		if 14 == equipSlotNo or 15 == equipSlotNo or 16 == equipSlotNo or 17 == equipSlotNo or 18 == equipSlotNo or 19 == equipSlotNo or 30 == equipSlotNo then
			return true
		end
	elseif 1 == self.selected_characterType then
		if 14 == equipSlotNo or 15 == equipSlotNo or 16 == equipSlotNo or 17 == equipSlotNo then
			return true
		end
	end
	
	return false
end

function Dye_New_IsNormal( equipSlotNo )
	local self = DyeNew
	if 0 == self.selected_characterType then
		if 0 == equipSlotNo or 1 == equipSlotNo or 3 == equipSlotNo or 4 == equipSlotNo or 5 == equipSlotNo or 6 == equipSlotNo or 29 == equipSlotNo then
			return true
		end
	elseif 1 == self.selected_characterType then
		if 3 == equipSlotNo or 4 == equipSlotNo or 5 == equipSlotNo or 6 == equipSlotNo or 12 == equipSlotNo then
			return true
		end
	end
	
	return false
end

function FGlobal_Panel_DyeNew_InventoryFilter( InvenSlotNo, itemWrapper, currentWhereType )
	local self = DyeNew

	if nil == itemWrapper then
		return true
	end
	
	local isServantUseable = itemWrapper:getStaticStatus():isUsableServant()
	if 0 == self.selected_characterType and isServantUseable then
		return true
	elseif (1 == self.selected_characterType or 3 == self.selected_characterType) and not isServantUseable then
		return true
	end

	if itemWrapper:isDyeable() then
		return false
	end

	local equipSlotNo = itemWrapper:getStaticStatus():getEquipSlotNo()
	if Dye_New_IsDyeableEquipment( equipSlotNo ) then
		if itemWrapper:isDyeable() then
			return false
		else
			return true
		end
	end
	
	return true
end

function Dye_New_IsDyeableEquipment( equipSlotNo )
	local self = DyeNew
	if Dye_New_IsAvatar( equipSlotNo ) then -- 아바타 장비
		return true
	elseif Dye_New_IsNormal( equipSlotNo ) then -- 일반 장비
		return true
	elseif 20 == equipSlotNo and ( 0 == self.selected_characterType )  then -- 속옷, 사람만
		return true
	elseif (21 == equipSlotNo or 22 == equipSlotNo or 23 == equipSlotNo ) and ( 0 == self.selected_characterType ) then -- 얼굴 장착 슬롯, 사람만,
		return true
	end
	
	return false
end

function FGlobal_Panel_DyeNew_Interaction_FromInventory( invenSlotNo, itemWrapper, count_s64, inventoryType )
	ToClient_RequestSetDyeTargetSlotByInventorySlotNo( Inventory_GetCurrentInventoryType(), invenSlotNo )
end

function dye_New_SelectPart( partId, slotId, uiIdx )
	local self					= DyeNew
	self.isPartClick			= true
	self.selectedPart.partId	= partId
	self.selectedPart.slotId	= slotId
	self.selectedPart.uiIdx		= uiIdx
	
	ToClient_RequestSelectedDyeingPartSlot(self.selectedEquipSlotNo, partId, slotId)
	self:Update_Part()
end
function dye_New_ResetPartColor( equipSlotNo, partId, slotId, uiIdx )
	local self 				= DyeNew
	
	local UiBase = self.partSlotUIPoll[uiIdx]
	local resetBtn = UiBase.PartSlotBGElement[slotId].partBTN
	--resetBtn:setRenderTexture( resetBtn:getBaseTexture() )
	
	--ToClient_RequestClearUsedColorAmpule( equipSlotNo, partId, slotId )
	ToClient_RequestClearUsedDyeingPalette( equipSlotNo, partId, slotId )

	table.remove( selectedDyePart, equipSlotNo )
	self:Update_Part()
end

function dye_New_AmpuleScrollSet()	-- 염색 스크롤 세팅
	-- 해상도(높이)에 따라 노출되는 염색앰플 수 결정
	if getScreenSizeY() < 900 then
		DyeNew.palette.config.resizeSlotRowsCount	= 2
		DyeNew.scroll:SetSize( DyeNew.scroll:GetSizeX(), 96 )
	else
		DyeNew.palette.config.resizeSlotRowsCount	= 3
		DyeNew.scroll:SetSize( DyeNew.scroll:GetSizeX(), 145 )
	end
end

function dye_New_Ampule_ScrollUpdate( isScrollUp )
	local paletteConfig				= DyeNew.palette.config
	paletteConfig.scrollStartIdx = UIScroll.ScrollEvent( DyeNew.scroll, isScrollUp, paletteConfig.resizeSlotRowsCount, paletteConfig.colorTotalRows, paletteConfig.scrollStartIdx, 1 )
	DyeNew:Update_AmpuleList()
end

function dye_setposition()
	DyeNew:UpdatePosition()
	DyeNew:SetPosition()
end

--------------------------------------------------------------------------------
-- 클릭 함수
--------------------------------------------------------------------------------
function HandleClicked_DeyNew_SelectCharacterType( idx )
	local self = DyeNew
	if self.lastCharacterSlotNo < idx then
		return
	end
	
	local bChangeSelectedCharacterType = ToClient_RequestSetTargetType( idx )
	if bChangeSelectedCharacterType then
		self.selected_characterType = idx	-- 선택한 캐릭터 타입. 인벤 필터에서 쓰임
		
		if 0 == idx then	
			self.selectedEquipSlotNo = 0
		elseif 1 == idx or 3 == idx then
			self.selectedEquipSlotNo = 3
		end	
		
		Inventory_SetFunctor( FGlobal_Panel_DyeNew_InventoryFilter, FGlobal_Panel_DyeNew_Interaction_FromInventory, nil, nil )

		FromClient_updateDyeingTargetList()

		self:Update_EquipItem()
		self:Update_Part()

		-- 앰플 리스트를 만들어야 한다.
		dye_New_AmpuleScrollSet()										-- 염료에 대한 스크롤을 세팅한다.
		
		-- self.palette.ui._btn_TabAll		:SetCheck( true )
		-- self.palette.ui._btn_TabMy		:SetCheck( false )

		self.palette.config.isShowAll			= false
		self.palette.config.isPearlPallete		= false
		self.palette.config.selectedCategoryIdx	= 0
		self.palette.config.scrollStartIdx		= 0
		self.scroll:SetControlTop()
		self:Update_AmpuleList()				-- 인벤에 있는 염료를 가져온다.

		self:UpdatePosition()
		selectedDyePart = {}
	else
		self.targetCharacter[self.selected_characterType]:SetCheck( true )
		self.targetCharacter[idx]:SetCheck( false )
	end

	-- 포즈, 바라보기, 내구도, 속옷, 올림 머리 활성화
	_deyNew_AddonButtonSet_ByCharacterType( idx )

	self.btn_HideAvatar:SetCheck( false )	-- 꼬이지 않게! 초기화
	self.isHideAvatar = false	-- 꼬이지 않게! 초기화
	self.isSelectedEquipSlot = false
end

function _deyNew_AddonButtonSet_ByCharacterType( idx )
	-- 포즈, 바라보기, 내구도, 속옷, 올림 머리 활성화
	local self = DyeNew
	local setControl = function( set )
		self.btn_ShowUnderwear:SetEnable( set )
		self.btn_ShowUnderwear:SetMonoTone( not set )
		-- self.btn_HideAvatar:SetEnable( set )
		-- self.btn_HideAvatar:SetMonoTone( not set )
		self.btn_HairHide:SetEnable( set )
		self.btn_HairHide:SetMonoTone( not set )
		self.Slider_Endurance:SetEnable( set )
		self.Slider_Endurance:SetMonoTone( not set )
		self.Endurance_SliderCtrlBTN:SetEnable( set )
		self.Endurance_SliderCtrlBTN:SetMonoTone( not set )
	end
	if 0 == idx then
		setControl( true )
		FGlobal_DeyNew_CharacterController_AddonButtonSet_ByCharacterType( true )
	elseif 1 == idx then
		setControl( false )
		FGlobal_DeyNew_CharacterController_AddonButtonSet_ByCharacterType( false )
	end
end


local ampuleCountCheck = false
function HandleClicked_DeyNew_Palette_SelectColor( dataIdx )
	local paletteConfig				= DyeNew.palette.config
	paletteConfig.selectedColorIdx	= dataIdx

	local DyeingPaletteCategoryInfo	= ToClient_requestGetPaletteCategoryInfo( paletteConfig.selectedCategoryIdx, paletteConfig.isShowAll )
	local isDyeUI					= false
	local ampuleCount				= DyeingPaletteCategoryInfo:getCount( paletteConfig.selectedColorIdx, isDyeUI )
	if ampuleCount <= toInt64(0,0) then
		if false == DyeNew.palette.config.isPearlPallete then
			ampuleCountCheck = true
		else
			ampuleCountCheck = false
		end
	else
		ampuleCountCheck = false
	end

	ToClient_RequestSelectedDyeingPalette( DyeNew.selectedEquipSlotNo, DyeNew.selectedPart.partId, DyeNew.selectedPart.slotId, paletteConfig.selectedCategoryIdx, paletteConfig.selectedColorIdx, paletteConfig.isShowAll )

	if 0 < ToClient_RequestGetPartDyeingSlotCount( DyeNew.selectedEquipSlotNo, 0 ) then		-- 염색이 가능한 아이템인지 체크
		table.insert( selectedDyePart, DyeNew.selectedEquipSlotNo )
	end

	DyeNew:Update_Part()

	Panel_Tooltip_Item_hideTooltip()
end

function HandleOnOut_DeyNew_Palette_Color( isShow, itemEnchantKey, rowsIdx, colsIdx )
	local uiControl				= DyeNew.palette.slot[rowsIdx][colsIdx].bg
	local itemEnchantSSW		= getItemEnchantStaticStatus( ItemEnchantKey( itemEnchantKey ) )
	local itemEnchantSS 		= itemEnchantSSW:get()
	local itemName				= getItemName( itemEnchantSS )
	local desc 					= nil
	registTooltipControl(uiControl, Panel_Tooltip_SimpleText)

	if true == isShow then
		TooltipSimple_Show( uiControl, itemName, desc )
	else
		TooltipSimple_Hide()
	end
end

function HandleClicked_DeyNew_DoDye()
	local self = DyeNew
	
	if -1 == DyeNew.palette.config.selectedColorIdx then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DYE_NEW_FIRSTSELECTDYENOGETITEM") )
		return
	end
	if ampuleCountCheck then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DYE_AMPULEALERT") ) --"염색약이 부족해 염색할 수 없습니다." )
		return
	end

	local _dyePartString = ""
	table.sort( selectedDyePart )
	for index, value in pairs ( selectedDyePart ) do
		if "" == _dyePartString then
			_dyePartString = "<" .. dyePartString[self.selected_characterType][selectedDyePart[index]] .. ">"
		elseif selectedDyePart[index] ~= selectedDyePart[index-1] then
			_dyePartString = _dyePartString .. ", <" .. dyePartString[self.selected_characterType][selectedDyePart[index]] .. ">"
		end
	end

	local noAction = function()
		return
	end

	local doDye = function()
		ToClient_RequestDye( self.palette.config.isPearlPallete )
		FGlobal_Panel_DyeNew_Hide()
	end

	local askDoDye = function()
		local messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")	-- "알 림"
		local messageBoxMemo	= PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_DYENEW_SURE_DYE_THIS_PART", "partString", _dyePartString)
								-- _dyePartString .. " 부위를 염색합니다. 계속 하시겠습니까?"
		local messageBoxData	= { title = messageBoxTitle, content = messageBoxMemo, functionYes = doDye, functionNo = noAction, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
		return
	end	
	
	local alreadyPearlDye = function()
		local messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")	-- "알 림"
		local messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_ALREADY_PEARLCOLOR")	-- "마르지 않는 팔레트 염색이 초기화 됩니다. 그래도 하시겠습니까?"
		local messageBoxData	= { title = messageBoxTitle, content = messageBoxMemo, functionYes = askDoDye, functionNo = noAction, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
		return
	end

	local equipSlotNo		= self.selectedEquipSlotNo
	if self.palette.config.isPearlPallete then	-- 기간제 염색인 경우 기존 염색을 체크해 얼럿

		local isAlreadyDye		= ToClient_isAllreadyDyeing( equipSlotNo )
		if true == isAlreadyDye then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_ALREADY_NORMALCOLOR") )	-- "아이템에 일반 염색이 되어 있습니다. 탈색 후 이용해야합니다."
			return
		else
			if "" == _dyePartString then
				doDye()
			else
				askDoDye()
			end
		end
	else
		local isAlreadyPearlDye = ToClient_isExpirationDyeing( equipSlotNo )
		if true == isAlreadyPearlDye then
			alreadyPearlDye()
		else
			if "" == _dyePartString then
				doDye()
			else
				askDoDye()
			end
		end
	end
end

function HandleClicked_DyeNew_Palette_SelectedType( isShowAll, isPearl )
	local selfPlayer = getSelfPlayer()
	if isShowAll and isPearl then
		local dyeingPackageTime	= selfPlayer:get():isApplyChargeSkill( UI_BUFFTYPE.eUserChargeType_DyeingPackage )
		if (not dyeingPackageTime) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_MUST_ACTIVE_PEARLCOLOR") ) -- "마르지 않는 팔레트를 활성화해야 합니다.")
			return
		end
	end

	DyeNew.palette.config.beforPearPallete = DyeNew.palette.config.isPearlPallete
	if isPearl ~= DyeNew.palette.config.beforPearPallete then
		ToClient_RequestClearDyeingSlot( DyeNew.selectedEquipSlotNo )
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DYE_NEW_PALETTE_PREVIEW_ACK") ) -- "같이 사용할 수 없는 팔레트입니다. 미리보기 염색 정보가 초기화됩니다."
	end	

	DyeNew.palette.config.isShowAll				= isShowAll
	DyeNew.palette.config.isPearlPallete		= isPearl
	DyeNew.palette.config.selectedCategoryIdx	= 0
	DyeNew.palette.config.selectedColorIdx		= 0
	DyeNew.palette.config.scrollStartIdx		= 0
	DyeNew.scroll:SetControlPos( 0 )

	DyeNew:Update_AmpuleList()
end
function HandleClicked_DyeNew_Palette_SelectedCategory( categoryIdx )
	for idx = 0, 7 do
		if idx == categoryIdx then
			DyeNew.palette.ui._btn_Material[idx]:SetCheck( true )
		else
			DyeNew.palette.ui._btn_Material[idx]:SetCheck( false )
		end
	end

	DyeNew.palette.config.selectedCategoryIdx	= categoryIdx
	DyeNew.palette.config.selectedColorIdx		= 0
	DyeNew.palette.config.scrollStartIdx		= 0
	DyeNew.scroll:SetControlPos( 0 )

	DyeNew:Update_AmpuleList()
end

function HandleClicked_DeyNew_SetCharacterRotate_BTN( isRight )
	if true == isRight then
		ToClient_RequestUpdateDyeVaryRotation( 0.1 , 0 )
	else
		ToClient_RequestUpdateDyeVaryRotation( -0.1 , 0 )
	end
end

function HandleClicked_dyeNew_SetFaceViewHair()
	local self = DyeNew
	ToClient_setFaceViewHair( self.btn_HairHide:IsCheck() )
end

function HandleClicked_DeyNew_SetShowUI()
	local self = DyeNew
	if Panel_Dye_New:GetShow() then
		Panel_Dye_New:SetShow( false )
		Panel_Window_Inventory:SetShow( false )
	else
		Panel_Dye_New:SetShow( true )
		Panel_Window_Inventory:SetShow( true )
	end
end

function HandleClicked_DeyNew_SetEndurance()
	local self		= DyeNew
	local index		= self.Slider_Endurance:GetSelectIndex()
	ToClient_RequestChangeEndurance(index)
end

function HandleClicked_DeyNew_SetShowUnderwear()
	local self		= DyeNew
	self.isShowUnderwear = not self.isShowUnderwear
	ToClient_RequestToggleShowUnderwear()
	-- 속옷을 보이게 한다.
end

function HandleClicked_DyeNew_SetHideAvatar()
	local self		= DyeNew
	self.isHideAvatar = not self.isHideAvatar
	ToClient_RequestToggleHideAvatar()

	-- 초기화
	if 0 == self.selected_characterType then
		if false == self.isHideAvatar then
			self.selectedEquipSlotNo	= 18
		else
			self.selectedEquipSlotNo	= 0
		end
	elseif 1 == self.selected_characterType then
		if false == self.isHideAvatar then
			self.selectedEquipSlotNo	= 14
		else
			self.selectedEquipSlotNo	= 3
		end
	end

	self.isPartClick						= false
	self.selectedPart.partId				= -1
	self.selectedPart.slotId				= -1
	self.selectedPart.uiIdx					= -1

	self:Update_EquipItem()
	self:Update_Part()
	dye_New_AmpuleScrollSet()										-- 염료에 대한 스크롤을 세팅한다.

	self.palette.config.isShowAll			= false
	self.palette.config.isPearlPallete		= false
	self.palette.config.selectedCategoryIdx	= 0
	self.palette.config.scrollStartIdx		= 0	
	self.scroll:SetControlTop()
	self:Update_AmpuleList()				-- 인벤에 있는 염료를 가져온다.

	self:UpdatePosition()
end

function HandleClicked_DyeNew_SetHideHelmet() 
	DyeNew.isHideBattleHelmet = not DyeNew.isHideBattleHelmet
	ToClient_RequestHideHelmet(DyeNew.isHideBattleHelmet)
end

function HandleClicked_DyeNew_SetOpenHelm()
	DyeNew.isOpenBattleHelmet = not DyeNew.isOpenBattleHelmet
	ToClient_RequestHideBattleHelmet(DyeNew.isOpenBattleHelmet)
end

function HandleClicked_DyeNew_SetAwakenWeapon()
	local isCheck = DyeNew.btn_AwakenWeapon:IsCheck()
	ToClient_SetAwakenWeaponShow( isCheck )
end

function HandleClicked_DeyNew_PressAmpuleScroll()
	local paletteConfig				= DyeNew.palette.config
	paletteConfig.scrollStartIdx	= math.ceil( (paletteConfig.colorTotalRows - paletteConfig.resizeSlotRowsCount) * DyeNew.scroll:GetControlPos() )

	DyeNew:Update_AmpuleList()
end

function HandleOnOut_DyeNew_Palette_BtnTooltip( isOn, btnType )
	local control	= nil
	local name		= ""
	local desc		= nil
	if true == isOn then
		if 0 == btnType then
			control = DyeNew.palette.ui._btn_TabAll
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_ALL")
		elseif 1 == btnType then
			control = DyeNew.palette.ui._btn_TabMy
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MY")
		elseif 2 == btnType then
			control = DyeNew.palette.ui._btn_Material[0]
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_0")
		elseif 3 == btnType then
			control = DyeNew.palette.ui._btn_Material[1]
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_1")
		elseif 4 == btnType then
			control = DyeNew.palette.ui._btn_Material[2]
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_2")
		elseif 5 == btnType then
			control = DyeNew.palette.ui._btn_Material[3]
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_3")
		elseif 6 == btnType then
			control = DyeNew.palette.ui._btn_Material[4]
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_4")
		elseif 7 == btnType then
			control = DyeNew.palette.ui._btn_Material[5]
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_5")
		elseif 8 == btnType then
			control = DyeNew.palette.ui._btn_Material[6]
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_6")
		elseif 9 == btnType then
			control = DyeNew.palette.ui._btn_Material[7]
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_7")
		elseif 10 == btnType then
			control = DyeNew.palette.ui._btn_TabPearl
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_DYEINGPACKEAGE_TITLE")	-- "마르지 않는 팔레트"
		end
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end


local isInventoryOpen = false
--------------------------------------------------------------------------------
-- 외부 함수
--------------------------------------------------------------------------------
function FGlobal_Panel_DyeNew_Show()
	ToClient_SaveUiInfo( true )
	
	if ( isGameTypeRussia() ) and ((getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT) or (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_OBT)) then
		return
	end

	if( isFlushedUI() ) then
		return
	end
	local isShow = ToClient_DyeingManagerIsShow()
	if ( true == isShow ) then
		return
	end

	local isShowable = ToClient_DyeingManagerIsShowable()
	if ( false == isShowable ) then
		return
	end
	
    if not IsSelfPlayerWaitAction() then
        Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_DYE") )
        return
    end

	isInventoryOpen = Panel_Window_Inventory:IsShow()
	SetUIMode(Defines.UIMode.eUIMode_DyeNew)
	UI.flushAndClearUI()

	-- UI Show 처리 추가하시면 되요.
	DyeNew:Open()
	FGlobal_DyeNew_CharacterController_Open()
	
	Inventory_SetFunctor( FGlobal_Panel_DyeNew_InventoryFilter, FGlobal_Panel_DyeNew_Interaction_FromInventory, nil, nil )
	InventoryWindow_Show()
	
	return true
end
function FGlobal_Panel_DyeNew_Hide()
	local isShow = ToClient_DyeingManagerHide()
	if ( false == isShow ) then
		return
	end

	if false == Panel_Dye_New:GetShow() and false == Panel_DyeNew_CharacterController:GetShow() then
		return
	end
	
	SetUIMode(Defines.UIMode.eUIMode_Default)
	UI.restoreFlushedUI()

	if false == isInventoryOpen then
		InventoryWindow_Close()
		FGlobal_Equipment_SetHide( false )
	else
		Inventory_SetFunctor( nil, nil, nil, nil )
		Inventory_SetShow( true )	-- 인벤토리 하단 버튼 활성화
	end

	if Panel_ChangeWeapon:GetShow() then
		WeaponChange_Close()
	end

	if Panel_ChangeWeapon:GetShow() then
		WeaponChange_Close()
	end
	
	isInventoryOpen = false
	
	-- UI Hide 처리 추가하시면 되요.
	ToClient_DyeingManagerHide()
	FGlobal_DyeNew_CharacterController_Close()
	DyeNew:Close()
	return true
end

function FGlobal_Panel_DyeNew_Reset_SetFunctor()
	Inventory_SetFunctor( FGlobal_Panel_DyeNew_InventoryFilter, FGlobal_Panel_DyeNew_Interaction_FromInventory, nil, nil )
end
function FGlobal_Panel_DyeNew_updateColorAmpuleList()
	DyeNew:Update_AmpuleList()
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function FromClient_updateDyeingTargetList()
	local self = DyeNew
	local tempSlotIdx = 0
	
	dye_resetEquipDATAArray()
	local haveNormalEquip	= nil
	local haveAvartarEquip	= nil
	for idx, equipSlotNo in pairs(equipSlotNo[self.selected_characterType]) do
		-- 초기화
		local UiBase = self.equipSlotUIPoll[tempSlotIdx]
		-- UiBase.SlotItem:clearItem()

		local itemWrapper	= ToClient_RequestGetDyeingTargetItemWrapper( equipSlotNo )
		local isDyeAble 	= false

		if nil ~= itemWrapper then
			isDyeAble = itemWrapper:isDyeable()
		end

		dye_New_UpdateEquipSlot( equipSlotNo, itemWrapper, tempSlotIdx )
		if nil ~= itemWrapper and isDyeAble then
			UiBase.SlotIcon:SetShow( false )
			-- 여기에서 선택 기본 값을 구한다.
			haveNormalEquip, haveAvartarEquip = _haveFirstEquipNo( haveNormalEquip, haveAvartarEquip, equipSlotNo )

			for partIdx = 0, self.partClientCount -1 do
				local isPart = ToClient_RequestIsPart(equipSlotNo, partIdx)
				if true == isPart then
					local partSlotCount = ToClient_RequestGetPartDyeingSlotCount( equipSlotNo, partIdx )
					equipSlotDyeInfo[self.selected_characterType][equipSlotNo][partIdx] = {}
					equipSlotDyeInfo[self.selected_characterType][equipSlotNo][partIdx].partSlotCount	= partSlotCount
					for partSlotIdx = 0, partSlotCount - 1 do
						local partSlotNo = ToClient_RequestGetPartDyeingSlotNo( equipSlotNo, partIdx, partSlotIdx)
						equipSlotDyeInfo[self.selected_characterType][equipSlotNo][partIdx][partSlotIdx]	= partSlotNo
					end
				end
			end
		elseif nil == itemWrapper then
			UiBase.SlotIcon:SetShow( true )
		else	-- nil이 아닌데, 염색을 할 수 없는 아이템.
			UiBase.SlotIcon:SetShow( true )
		end
		tempSlotIdx = tempSlotIdx + 1
	end

	if false == self.isSelectedEquipSlot then
		if (nil ~= haveNormalEquip and nil ~= haveAvartarEquip) or (nil == haveNormalEquip and nil ~= haveAvartarEquip) then
			self.selectedEquipSlotNo = haveAvartarEquip
		elseif nil == haveAvartarEquip or ( nil == haveNormalEquip and nil == haveAvartarEquip )then
			if 0 == self.selected_characterType then
				self.selectedEquipSlotNo = 0
			elseif 1 == self.selected_characterType then
				self.selectedEquipSlotNo = 3
			end
		else
			self.selectedEquipSlotNo = haveNormalEquip
		end
	end
	self:ResetPartArray()
	self:Update_Part()	-- 이건 맞는거 같은데;;
end

function _haveFirstEquipNo( haveNormalEquip, haveAvartarEquip, equipSlotNo )	-- 착용중인 장비를 판별하여 첫 번째를 구하는데 쓰임.
	local self = DyeNew
	if 0 == self.selected_characterType then
		if equipSlotNo <= 7 or 29 == equipSlotNo then
			if nil == haveNormalEquip then
				haveNormalEquip = equipSlotNo
			end
		elseif (7 < equipSlotNo and equipSlotNo < 20) or (30 == equipSlotNo) then
			if nil == haveAvartarEquip then
				haveAvartarEquip = equipSlotNo
			end
		end
	elseif 1 == self.selected_characterType then
		if equipSlotNo <= 12 then
			if nil == haveNormalEquip then
				haveNormalEquip = equipSlotNo
			end
		else
			if nil == haveAvartarEquip then
				haveAvartarEquip = equipSlotNo
			end
		end
	end
	
	return	haveNormalEquip, haveAvartarEquip
end

function HandleOver_DyeNew_SimpleTooltipCheckbutton( isShow, tipType )
	local name, desc, control = nil, nil, nil
	if 0 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SHOWUNDERWEAR") -- "속옷보기"
		control	= DyeNew.btn_ShowUnderwear
	elseif 1 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDEAVATAR") -- "의상 숨기기"
		control	= DyeNew.btn_HideAvatar
	elseif 2 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDEHELM") -- "투구 감추기"
		control	= DyeNew.btn_HelmHide
	elseif 3 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_AWAKENWEAPON") -- "각성 무기 보이기" 
		control	= DyeNew.btn_AwakenWeapon
	elseif 4 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDHAIR") -- "올림 머리로 보기"
		control	= DyeNew.btn_HairHide
	elseif 5 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_OPENHELM") -- "안면 보호대 열기"
		control	= DyeNew.btn_OpenHelm
	end

	registTooltipControl(control, Panel_Tooltip_SimpleText)
	if isShow == true then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function FromClient_updateColorAmpuleList()
	DyeNew:Update_AmpuleList()
end
function FromClient_updateDyeingPartList()
	DyeNew:ResetPartArray()
	DyeNew:Update_Part()
end
function FromClient_setTotalPage()
	-- body
end

function FromClient_Dyeing_AddDamage()
	FGlobal_Panel_DyeNew_Hide()
end

function DyeNew:registEventHandler()
	self.btn_Dodye					:addInputEvent("Mouse_LUp",			"HandleClicked_DeyNew_DoDye()")
	self.Slider_Endurance			:addInputEvent("Mouse_LUp",			"HandleClicked_DeyNew_SetEndurance()")
	self.Endurance_SliderCtrlBTN	:addInputEvent("Mouse_LPress",		"HandleClicked_DeyNew_SetEndurance()")
	self.btn_HairHide				:addInputEvent("Mouse_LUp",			"HandleClicked_dyeNew_SetFaceViewHair()")
	self.btn_HairHide				:addInputEvent("Mouse_On",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( ture, 4)")
	self.btn_HairHide				:addInputEvent("Mouse_Out",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( false, 4)")
	self.btn_HairHide				:setTooltipEventRegistFunc("HandleOver_DyeNew_SimpleTooltipCheckbutton( true, 4 )")
	self.btn_ShowUnderwear			:addInputEvent("Mouse_LUp",			"HandleClicked_DeyNew_SetShowUnderwear()")
	self.btn_ShowUnderwear			:addInputEvent("Mouse_On",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( ture, 0)")
	self.btn_ShowUnderwear			:addInputEvent("Mouse_Out",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( false, 0)")
	self.btn_ShowUnderwear			:setTooltipEventRegistFunc("HandleOver_DyeNew_SimpleTooltipCheckbutton( true, 0 )")
	self.btn_HideAvatar				:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_SetHideAvatar()")
	self.btn_HideAvatar				:addInputEvent("Mouse_On",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( ture, 1)")
	self.btn_HideAvatar				:addInputEvent("Mouse_Out",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( false, 1)")
	self.btn_HideAvatar				:setTooltipEventRegistFunc("HandleOver_DyeNew_SimpleTooltipCheckbutton( true, 1 )")
	self.btn_HelmHide				:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_SetHideHelmet()")
	self.btn_HelmHide				:addInputEvent("Mouse_On",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( ture, 2)")
	self.btn_HelmHide				:addInputEvent("Mouse_Out",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( false, 2)")
	self.btn_HelmHide				:setTooltipEventRegistFunc("HandleOver_DyeNew_SimpleTooltipCheckbutton( true, 2 )")
	self.btn_OpenHelm				:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_SetOpenHelm()")
	self.btn_OpenHelm				:addInputEvent("Mouse_On",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( ture, 5)")
	self.btn_OpenHelm				:addInputEvent("Mouse_Out",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( false, 5)")
	self.btn_OpenHelm				:setTooltipEventRegistFunc("HandleOver_DyeNew_SimpleTooltipCheckbutton( true, 5 )")
	self.btn_AwakenWeapon			:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_SetAwakenWeapon()")
	self.btn_AwakenWeapon			:addInputEvent("Mouse_On",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( ture, 3)")
	self.btn_AwakenWeapon			:addInputEvent("Mouse_Out",			"HandleOver_DyeNew_SimpleTooltipCheckbutton( false, 3)")
	self.btn_AwakenWeapon			:setTooltipEventRegistFunc("HandleOver_DyeNew_SimpleTooltipCheckbutton( true, 3 )")
	
	self.scrollCTRLBTN				:addInputEvent("Mouse_LPress",		"HandleClicked_DeyNew_PressAmpuleScroll()")
	self.scroll						:addInputEvent("Mouse_LUp",			"HandleClicked_DeyNew_PressAmpuleScroll()")
	self._buttonQuestion			:addInputEvent("Mouse_LUp",			"Panel_WebHelper_ShowToggle( \"Dye\" )" )
	self._buttonQuestion			:addInputEvent("Mouse_On",			"HelpMessageQuestion_Show( \"Dye\", \"true\")" )
	self._buttonQuestion			:addInputEvent("Mouse_Out",			"HelpMessageQuestion_Show( \"Dye\", \"false\")" )

	self.palette.ui._btn_TabAll		:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedType( true, false )" )
	self.palette.ui._btn_TabMy		:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedType( false, false )" )
	self.palette.ui._btn_TabPearl	:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedType( true, true )" )
	self.palette.ui._btn_Material[0]:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedCategory( " .. 0 .. ")" )
	self.palette.ui._btn_Material[1]:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedCategory( " .. 1 .. ")" )
	self.palette.ui._btn_Material[2]:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedCategory( " .. 2 .. ")" )
	self.palette.ui._btn_Material[3]:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedCategory( " .. 3 .. ")" )
	self.palette.ui._btn_Material[4]:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedCategory( " .. 4 .. ")" )
	self.palette.ui._btn_Material[5]:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedCategory( " .. 5 .. ")" )
	self.palette.ui._btn_Material[6]:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedCategory( " .. 6 .. ")" )
	self.palette.ui._btn_Material[7]:addInputEvent("Mouse_LUp",			"HandleClicked_DyeNew_Palette_SelectedCategory( " .. 7 .. ")" )

	self.palette.ui._btn_TabAll		:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 0 .. ")" )
	self.palette.ui._btn_TabAll		:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 0 .. ")" )
	self.palette.ui._btn_TabAll		:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 0 .. ")" )
	self.palette.ui._btn_TabMy		:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 1 .. ")" )
	self.palette.ui._btn_TabMy		:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 1 .. ")" )
	self.palette.ui._btn_TabMy		:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 1 .. ")" )
	self.palette.ui._btn_TabPearl	:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 10 .. ")" )
	self.palette.ui._btn_TabPearl	:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 10 .. ")" )
	self.palette.ui._btn_TabPearl	:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 10 .. ")" )
	self.palette.ui._btn_Material[0]:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 2 .. ")" )
	self.palette.ui._btn_Material[0]:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 2 .. ")" )
	self.palette.ui._btn_Material[0]:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 2 .. ")" )
	self.palette.ui._btn_Material[1]:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 3 .. ")" )
	self.palette.ui._btn_Material[1]:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 3 .. ")" )
	self.palette.ui._btn_Material[1]:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 3 .. ")" )
	self.palette.ui._btn_Material[2]:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 4 .. ")" )
	self.palette.ui._btn_Material[2]:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 4 .. ")" )
	self.palette.ui._btn_Material[2]:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 4 .. ")" )
	self.palette.ui._btn_Material[3]:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 5 .. ")" )
	self.palette.ui._btn_Material[3]:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 5 .. ")" )
	self.palette.ui._btn_Material[3]:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 5 .. ")" )
	self.palette.ui._btn_Material[4]:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 6 .. ")" )
	self.palette.ui._btn_Material[4]:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 6 .. ")" )
	self.palette.ui._btn_Material[4]:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 6 .. ")" )
	self.palette.ui._btn_Material[5]:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 7 .. ")" )
	self.palette.ui._btn_Material[5]:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 7 .. ")" )
	self.palette.ui._btn_Material[5]:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 7 .. ")" )
	self.palette.ui._btn_Material[6]:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 8 .. ")" )
	self.palette.ui._btn_Material[6]:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 8 .. ")" )
	self.palette.ui._btn_Material[6]:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 8 .. ")" )
	self.palette.ui._btn_Material[7]:addInputEvent("Mouse_On",			"HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 9 .. ")" )
	self.palette.ui._btn_Material[7]:addInputEvent("Mouse_Out",			"HandleOnOut_DyeNew_Palette_BtnTooltip( false, " .. 9 .. ")" )
	self.palette.ui._btn_Material[7]:setTooltipEventRegistFunc( "HandleOnOut_DyeNew_Palette_BtnTooltip( true, " .. 9 .. ")" )

end
function DyeNew:registMessageHandler()
	registerEvent("FromClient_updateDyeingTargetList",		"FromClient_updateDyeingTargetList")	-- 열 때, 장비를 리턴한다.
	registerEvent("FromClient_updateColorAmpuleList",		"FromClient_updateColorAmpuleList")		-- 염료 리스트 리턴.
	registerEvent("FromClient_updateDyeingPartList",		"FromClient_updateDyeingPartList")		-- 장비 부위 리턴.
	registerEvent("onScreenResize",							"dye_setposition")
	-- registerEvent("addDamage",								"FromClient_Dyeing_AddDamage")			-- 대미지를 받으면 염색창 꺼주자
	--registerEvent("FromClient_NotifySelectedEquipSlotNo",	"FromClient_NotifySelectedEquipSlotNo")			-- 인벤에서 
end


DyeNew:Initialize()
DyeNew:registEventHandler()
DyeNew:registMessageHandler()

CppEnums = {}

-- pa::VirtualKeyCode
CppEnums.VirtualKeyCode =
{
	KeyCode_LBUTTON = 0x01,
	KeyCode_RBUTTON = 0x02,
	KeyCode_CANCEL = 0x03,
	KeyCode_MBUTTON = 0x04,

	KeyCode_BACK = 0x08,
	KeyCode_TAB = 0x09,

	KeyCode_CLEAR = 0x0C,
	KeyCode_RETURN = 0x0D,

	KeyCode_SHIFT = 0x10,
	KeyCode_CONTROL = 0x11,
	KeyCode_MENU = 0x12,		-- ALT
	KeyCode_PAUSE = 0x13,
	KeyCode_CAPITAL = 0x14,

	KeyCode_ESCAPE = 0x1B,

	KeyCode_SPACE = 0x20,
	KeyCode_PGUP = 0x21,	-- page up (PGUP)
	KeyCode_PGDN = 0x22,		-- page down (PGDN)
	KeyCode_END = 0x23,
	KeyCode_HOME = 0x24,
	KeyCode_LEFT = 0x25,
	KeyCode_UP = 0x26,
	KeyCode_RIGHT = 0x27,
	KeyCode_DOWN = 0x28,
	KeyCode_SELECT = 0x29,
	KeyCode_PRINT = 0x2A,
	KeyCode_EXECUTE = 0x2B,
	KeyCode_SNAPSHOT = 0x2C,
	KeyCode_INSERT = 0x2D,
	KeyCode_DELETE = 0x2E,
	KeyCode_HELP = 0x2F,

	KeyCode_0 = 0x30,
	KeyCode_1 = 0x31,
	KeyCode_2 = 0x32,
	KeyCode_3 = 0x33,
	KeyCode_4 = 0x34,
	KeyCode_5 = 0x35,
	KeyCode_6 = 0x36,
	KeyCode_7 = 0x37,
	KeyCode_8 = 0x38,
	KeyCode_9 = 0x39,
	KeyCode_A = 0x41,
	KeyCode_B = 0x42,
	KeyCode_C = 0x43,
	KeyCode_D = 0x44,
	KeyCode_E = 0x45,
	KeyCode_F = 0x46,
	KeyCode_G = 0x47,
	KeyCode_H = 0x48,
	KeyCode_I = 0x49,
	KeyCode_J = 0x4A,
	KeyCode_K = 0x4B,
	KeyCode_L = 0x4C,
	KeyCode_M = 0x4D,
	KeyCode_N = 0x4E,
	KeyCode_O = 0x4F,
	KeyCode_P = 0x50,
	KeyCode_Q = 0x51,
	KeyCode_R = 0x52,
	KeyCode_S = 0x53,
	KeyCode_T = 0x54,
	KeyCode_U = 0x55,
	KeyCode_V = 0x56,
	KeyCode_W = 0x57,
	KeyCode_X = 0x58,
	KeyCode_Y = 0x59,
	KeyCode_Z = 0x5A,

	KeyCode_NUMPAD0 = 0x60,
	KeyCode_NUMPAD1 = 0x61,
	KeyCode_NUMPAD2 = 0x62,
	KeyCode_NUMPAD3 = 0x63,
	KeyCode_NUMPAD4 = 0x64,
	KeyCode_NUMPAD5 = 0x65,
	KeyCode_NUMPAD6 = 0x66,
	KeyCode_NUMPAD7 = 0x67,
	KeyCode_NUMPAD8 = 0x68,
	KeyCode_NUMPAD9 = 0x69,
	KeyCode_MULTIPLY = 0x6A,
	KeyCode_ADD = 0x6B,
	KeyCode_SEPARATOR = 0x6C,
	KeyCode_SUBTRACT = 0x6D,
	KeyCode_DECIMAL = 0x6E,
	KeyCode_DIVIDE = 0x6F,
	KeyCode_F1 = 0x70,
	KeyCode_F2 = 0x71,
	KeyCode_F3 = 0x72,
	KeyCode_F4 = 0x73,
	KeyCode_F5 = 0x74,
	KeyCode_F6 = 0x75,
	KeyCode_F7 = 0x76,
	KeyCode_F8 = 0x77,
	KeyCode_F9 = 0x78,
	KeyCode_F10 = 0x79,
	KeyCode_F11 = 0x7A,
	KeyCode_F12 = 0x7B,
	KeyCode_F13 = 0x7C,
	KeyCode_F14 = 0x7D,
	KeyCode_F15 = 0x7E,
	KeyCode_F16 = 0x7F,
	KeyCode_F17 = 0x80,
	KeyCode_F18 = 0x81,
	KeyCode_F19 = 0x82,
	KeyCode_F20 = 0x83,
	KeyCode_F21 = 0x84,
	KeyCode_F22 = 0x85,
	KeyCode_F23 = 0x86,
	KeyCode_F24 = 0x87,

	KeyCode_OEM_2 = 0xBF,	-- [ /? ]
	KeyCode_OEM_3 = 0xC0,	-- [ `~ ]
	KeyCode_OEM_7 = 0xDE,	-- [ '" ]
}

CppEnums.CommandGuideKeyType =
{
	CommandGuideKeyType_Mouse0 	= 0,
	CommandGuideKeyType_Mouse1 	= 1,
	CommandGuideKeyType_W 		= 2,
	CommandGuideKeyType_A		= 3,
	CommandGuideKeyType_S		= 4,
	CommandGuideKeyType_D		= 5,
	CommandGuideKeyType_Q		= 6,
	CommandGuideKeyType_E		= 7,
	CommandGuideKeyType_R		= 8,
	CommandGuideKeyType_F		= 9,
	CommandGuideKeyType_Z		= 10,
	CommandGuideKeyType_X		= 11,
	CommandGuideKeyType_C		= 12,
	CommandGuideKeyType_V		= 13,
	CommandGuideKeyType_Shift	= 14,
	CommandGuideKeyType_Space	= 15,
	CommandGuideKeyType_Tab		= 16,
	CommandGuideKeyType_T		= 17
}

-- ge::ActionInputType
CppEnums.ActionInputType =
{
	ActionInputType_MoveFront		= 0,
	ActionInputType_MoveBack		= 1,
	ActionInputType_MoveLeft		= 2,
	ActionInputType_MoveRight		= 3,
	ActionInputType_Attack1			= 4,
	ActionInputType_Attack2			= 5,
	ActionInputType_Dash			= 6,
	ActionInputType_Jump			= 7,
	ActionInputType_Interaction		= 8,
	ActionInputType_AutoRun			= 9,
	ActionInputType_WeaponInOut		= 10,
	ActionInputType_CameraReset		= 11,

	ActionInputType_CrouchOrSkill	= 12,
	ActionInputType_GrabOrGuard		= 13,
	ActionInputType_Kick			= 14,

	ActionInputType_ServantOrder1	= 15,
	ActionInputType_ServantOrder2	= 16,
	ActionInputType_ServantOrder3	= 17,
	ActionInputType_ServantOrder4	= 18,

	ActionInputType_QuickSlot1		= 19,
	ActionInputType_QuickSlot2		= 20,
	ActionInputType_QuickSlot3		= 21,
	ActionInputType_QuickSlot4		= 22,
	ActionInputType_QuickSlot5		= 23,
	ActionInputType_QuickSlot6		= 24,
	ActionInputType_QuickSlot7		= 25,
	ActionInputType_QuickSlot8		= 26,
	ActionInputType_QuickSlot9		= 27,
	ActionInputType_QuickSlot10		= 28,

	ActionInputType_QuickSlot11		= 29,
	ActionInputType_QuickSlot12		= 30,
	ActionInputType_QuickSlot13		= 31,
	ActionInputType_QuickSlot14		= 32,
	ActionInputType_QuickSlot15		= 33,
	ActionInputType_QuickSlot16		= 34,
	ActionInputType_QuickSlot17		= 35,
	ActionInputType_QuickSlot18		= 36,
	ActionInputType_QuickSlot19		= 37,
	ActionInputType_QuickSlot20		= 38,

	ActionInputType_Complicated0	= 39,
	ActionInputType_Complicated1	= 40,
	ActionInputType_Complicated2	= 41,
	ActionInputType_Complicated3	= 42,
	
	ActionInputType_WalkMode		= 43,
	
	ActionInputType_Undefined		= 44,
}

-- ge::UiInputType
CppEnums.UiInputType =
{
	UiInputType_CursorOnOff		= 0,

	UiInputType_Help			= 1,		-- 도움말
	UiInputType_MentalKnowledge	= 2,		-- 지식
	UiInputType_Inventory		= 3,		-- 인벤토리
	UiInputType_BlackSpirit		= 4,		-- 흑정령
	UiInputType_Chat			= 5,		-- 채팅
	UiInputType_PlayerInfo		= 6,		-- 플레이어 정보
	UiInputType_Skill			= 7,		-- 스킬
	UiInputType_WorldMap		= 8,		-- 월드맵
	UiInputType_Dyeing			= 9,		-- 소켓
	UiInputType_ProductionNote	= 10,		-- 강화
	UiInputType_Manufacture		= 11,		-- 가공
	UiInputType_Guild			= 12,		-- 길
	UiInputType_Mail			= 13,		-- 우편
	UiInputType_FriendList		= 14,		-- 친구
	UiInputType_Present			= 15,		-- 특별 보상
	UiInputType_QuestHistory	= 16,		-- 퀘스트 로그
	UiInputType_Cancel			= 17,		-- 취소
	UiInputType_CashShop		= 18,		-- 캐쉬샵
	UiInputType_BeautyShop		= 19,		-- 뷰티샵
	UiInputType_AlchemySton		= 20,		-- 연금석

	UiInputType_Undefined		= 21,
}

-- cns::ActorType::Type
CppEnums.ActorType =
{
	ActorType_Player		= 0,
	ActorType_Monster		= 1,
	ActorType_Npc			= 2,
	ActorType_Vehicle		= 3,
	ActorType_Gate			= 4,
	ActorType_Alterego		= 5,
	ActorType_Collect		= 6,
	ActorType_Household		= 7,
	ActorType_Installation	= 8,
	ActorType_Deadbody		= 9
}

---------------------------------------------------
-- gc Enums
---------------------------------------------------
-- gc::ChatType
CppEnums.ChatType =
{
	Undefine 		= 0,		-- 미정의
	Notice 			= 1,		-- 서버 공지
	World 			= 2,		-- 월드 채팅
	Public 			= 3,		-- 일반 채팅( 인접 섹터 )
	Private 		= 4,		-- 개인 채팅( 귓속말 )
	System 			= 5,		-- 시스템 메시지
	Party 			= 6,		-- 파티
	Guild 			= 7,		-- 길드
	Client		 	= 8,		-- 클라 전용 메시지
	Alliance 		= 9,		-- 연합
	Friend 			= 10,		-- 친구
	GameInfo3 		= 11,		--
	WorldWithItem	= 12,		-- 아이템을 사용한 월드 채팅
	Battle			= 13,		-- 전투 관련 메시지
	LocalWar		= 14,		-- 붉은 전장
	RolePlay		= 15,		-- 롤 플레이(북미 전용)
	Count    		= 16	
}

CppEnums.EChatNoticeType =
{
	Normal 			= 0,		-- 일반 공지
	Campaign 		= 1,		-- 캠페인 공지
	Emergency 		= 2,		-- 긴급 공지
	Tip 			= 3,		-- Tip 공지
	-- GMChatting		= 4,		-- 운영자의 일반 채팅
	GuildBoss		= 4,		-- 길드 보스 공지
	OfferingCarrier	= 5,		-- 공물마차 공지
	Defence			= 6,		-- 무한대전 공지
	KeepNotify		= 7,		-- 공지유지(아직 안씀)
	ClearKeepNotify	= 8,		-- 유지된거 클리어(아직 안씀)
	HuntingStart	= 9,		-- 수렵용
	HuntingEnd		= 10,		-- 수렵 종료 통보용
	Kzarka			= 11,		-- 크자카 등장
	Nuberu			= 12,		-- 누베르 등장
	
	Count    		= 13
	
}

-- gc::ItemType::Type
CppEnums.ItemType =
{
	Normal 			= 0,		-- 일반
	Equip			= 1,		-- 장착류
	Skill 			= 2,		-- 소모(스킬)
	Tent 			= 3,		-- 텐트(필드 내 배치)
	Installation 	= 4,		-- 설치오브젝트(하우스홀드 내 배치)
	Jewel 			= 5,		-- 보석류
	CannonBall 		= 6,		-- 대포알
	Mapae 			= 7,		-- 구 마패(->말 교환권, 말 등록증, 말 면허증)
	Material 		= 8,		-- 제작재료
	Interaction 	= 9,		-- 주변과 상호작용(미션이나, 퀘스트 수행 중 사용이 필요한 아이템)
	ContentsEvent 	= 10,		-- 컨텐츠이용을 위한 특수한 아이템들( 예: 스킬초기화 )
	ToVehicle		= 11,		-- 탈것 먹이(스킬)
}

-- gc::EquipSlotNo
--[[
CppEnums.EquipSlotNo =
{
	rightHand	= 0,
	leftHand	= 1,
	_UNUSED_01_	= 2,
	_UNUSED_02_	= 3,
	chest		= 4,
	pants		= 5,
	glove		= 6,
	boots		= 7,
	helm		= 8,
	shoulder	= 9,
	necklace	= 10,
	ring1		= 11,
	ring2		= 12,
	earing1		= 13,
	earing2		= 14,
	belt		= 15,
	lantern		= 16,

	avatarChest		= 17,
	avatarPants		= 18,
	avatarGlove		= 19,
	avatarBoots		= 20,
	avatarHelm		= 21,
	avatarShoulder	= 22,
	avatarWeapon	= 23,
	avatarSubWeapon	= 24,

	installation0	= 25,
	installation1	= 26,
	installation2	= 27,
	installation3	= 28,
	installation4	= 29
}
]]

CppEnums.EquipSlotNo =
{
	rightHand	= 0,
	leftHand	= 1,
	subTool		= 2,
	chest		= 3,
	glove		= 4,
	boots		= 5,
	helm		= 6,
	
	necklace	= 7,
	ring1		= 8,
	ring2		= 9,
	earing1		= 10,
	earing2		= 11,
	belt		= 12,
	lantern		= 13,

	avatarChest		= 14,
	avatarGlove		= 15,
	avatarBoots		= 16,
	avatarHelm		= 17,
	
	avatarWeapon	= 18,
	avatarSubWeapon	= 19,
	avatarUnderWear	= 20,

	faceDecoration1	= 21,
	faceDecoration2	= 22,
	faceDecoration3	= 23,
	installation4	= 24,
	
	body			= 25,
	avatarBody		= 26,
	
	alchemyStone	= 27,
	
	explorationBonus0= 28, -- 공헌도를 위한 가상의 슬롯(실제 아이템이 존재하는것이 아님)
	
	awakenWeapon	= 29,	-- 각성무기
	avatarAwakenWeapon	= 30,	-- 각성무기 아바타
	
	equipSlotNoCount = 31
}

CppEnums.EquipSlotNoString =
{
	[CppEnums.EquipSlotNo.rightHand] 		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_RightHand" ),
	[CppEnums.EquipSlotNo.leftHand] 		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_LeftHand" ),
	[CppEnums.EquipSlotNo.subTool] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_SubTool" ),
	
	[CppEnums.EquipSlotNo.chest] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Chest" ),
	[CppEnums.EquipSlotNo.glove] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Glove" ),
	[CppEnums.EquipSlotNo.boots] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Boots" ),
	[CppEnums.EquipSlotNo.helm] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Helm" ),
	
	[CppEnums.EquipSlotNo.necklace] 		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Necklace" ),
	[CppEnums.EquipSlotNo.ring1] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Ring1" ),
	[CppEnums.EquipSlotNo.ring2] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Ring2" ),
	[CppEnums.EquipSlotNo.earing1] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Earing1" ),
	[CppEnums.EquipSlotNo.earing2] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Earing2" ),
	[CppEnums.EquipSlotNo.belt] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Belt" ),
	[CppEnums.EquipSlotNo.lantern] 			= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Lantern" ),
	
	[CppEnums.EquipSlotNo.avatarChest] 		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_AvatarChest" ),
	[CppEnums.EquipSlotNo.avatarGlove] 		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_AvatarGlove" ),
	[CppEnums.EquipSlotNo.avatarBoots] 		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_AvatarBoots" ),
	[CppEnums.EquipSlotNo.avatarHelm] 		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_AvatarHelm" ),
	
	[CppEnums.EquipSlotNo.avatarWeapon] 	= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_AvatarWeapon" ),
	[CppEnums.EquipSlotNo.avatarSubWeapon] 	= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_AvatarSubWeapon" ),
	
	[CppEnums.EquipSlotNo.faceDecoration1] 	= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_FaceDecoration1" ),
	[CppEnums.EquipSlotNo.faceDecoration2] 	= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_FaceDecoration2" ),
	[CppEnums.EquipSlotNo.faceDecoration3] 	= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_FaceDecoration3" ),
	[CppEnums.EquipSlotNo.installation4] 	= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_Installation4" ),
	[CppEnums.EquipSlotNo.body]				= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_body" ),	-- "바디"
	[CppEnums.EquipSlotNo.avatarBody]		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_avatarBody" ),	-- "아바타바디"
	[CppEnums.EquipSlotNo.alchemyStone]		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_alchemyStone" ),	-- "연금석"
	[CppEnums.EquipSlotNo.awakenWeapon]		= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_awakenWeapon" ),	-- "각성무기"
	[CppEnums.EquipSlotNo.avatarAwakenWeapon]	= PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_avatarAwakenWeapon" ),	-- "각성무기 아바타"
	[CppEnums.EquipSlotNo.explorationBonus0] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_ExplorationBonus0" ),
}

-- gc::ClassType::Type
CppEnums.ClassType =
{
	ClassType_Warrior			= 0,
	ClassType_Ranger			= 4,
	ClassType_Sorcerer			= 8,
	ClassType_Giant				= 12,
	ClassType_Tamer				= 16,
	ClassType_ShyWomen			= 17,
	ClassType_Shy				= 18,
	ClassType_BladeMaster		= 20,
	ClassType_BladeMasterWomen	= 21,
	ClassType_Temp				= 22, -- 임시 클래스타입(매화)
	ClassType_Valkyrie			= 24,
	ClassType_NinjaWomen		= 25,
	ClassType_NinjaMan			= 26,
	ClassType_Wizard			= 28,
	ClassType_Kunoichi			= 30,
	ClassType_WizardWomen		= 31,
	ClassType_Count				= 32,
}

-- CppEnums.ClassType 와 크기가 동일해야 한다!!!!
CppEnums.ClassType2String =
{	
	[CppEnums.ClassType.ClassType_Warrior]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WARRIOR" ),
	[CppEnums.ClassType.ClassType_Ranger]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_RANGER" ),
	[CppEnums.ClassType.ClassType_Sorcerer]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_SORCERER" ),
	[CppEnums.ClassType.ClassType_Giant]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_GIANT" ),
	[CppEnums.ClassType.ClassType_Tamer]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_TAMER" ),
	[CppEnums.ClassType.ClassType_BladeMaster]		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTER" ),
	[CppEnums.ClassType.ClassType_BladeMasterWomen]	= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTERWOMAN" ),
	[CppEnums.ClassType.ClassType_Valkyrie]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_VALKYRIE" ),
	[CppEnums.ClassType.ClassType_NinjaWomen]		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAWOMEN"),
	[CppEnums.ClassType.ClassType_NinjaMan]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAMAN"),
	[CppEnums.ClassType.ClassType_Wizard]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARD" ),
	[CppEnums.ClassType.ClassType_Kunoichi]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_KUNOICHI" ),
	[CppEnums.ClassType.ClassType_WizardWomen]		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARDWOMAN" ),
	[CppEnums.ClassType.ClassType_Count] 			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_COUNT" )
}

-- gc::PartyLootType
CppEnums.PartyLootType =
{
	LootType_Free			= 0,
	LootType_Shuffle		= 1,
	LootType_Random			= 2,
	LootType_Master			= 3,
	LootType_PartyInven		= 4,
	LootType_Bound			= 5,
}

-- CppEnums.PartyLootType 가 변경되면 여기도 수정해야 한다!!!!
CppEnums.PartyLootType2String =
{	
	[CppEnums.PartyLootType.LootType_Free]			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_FREE"),
	[CppEnums.PartyLootType.LootType_Shuffle]		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_SHUFFLE"),
	[CppEnums.PartyLootType.LootType_Random]		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_RANDOM"),
	[CppEnums.PartyLootType.LootType_Master]		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_MASTER"),
	[CppEnums.PartyLootType.LootType_PartyInven]	= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_LOOTTYPE_PARTYINVEN"),
}

-- gc::CharacterGradeType::Type
CppEnums.CharacterGradeType =
{
	CharacterGradeType_Normal		= 0,
	CharacterGradeType_Elite		= 1,
	CharacterGradeType_Hero			= 2,
	CharacterGradeType_Legend		= 3,
	CharacterGradeType_Boss			= 4,
	CharacterGradeType_Assistant	= 5
}

-- gc::PlantType
CppEnums.PlantType =
{
	ePlantType_Town			= 0,
	ePlantType_Zone			= 1,
	ePlantType_Household	= 2,
	ePlantType_Count		= 3
}

-- gc::PlantLevelType
CppEnums.PlantLevelType =
{
	ePlantLevelType_Explore 				= 0,		-- 탐험 레벨		(_subType : 사용안함)					(_value : 탐험 레벨)
	ePlantLevelType_PlantTown				= 1,		-- 마을				(_subType : PlantTownLevelType)			(_value : 업그레이드 레벨)
	ePlantLevelType_PlantZoneEfficiency		= 2,		-- 농장 효율		(_subType : PlantZoneLevelType)			(_value : 효율 레벨)
	ePlantLevelType_PlantZoneProductGrade	= 3,		-- 농장 생산물 레벨	(_subType : gc::PlantExchangeGroupKey)	(_value : 생산물 레벨)
	ePlantLevelType_PlantZoneProductAmount	= 4,		-- 농장 생산물 개수	(_subType : gc::PlantExchangeGroupKey)	(_value : 최대 개수)
	ePlantLevelType_Count					= 5			--
}

-- gc::PlantTownLevelType
CppEnums.PlantTownLevelType =
{
	ePlantTownLevelType_Warehouse			= 0,		-- 마을 창고 레벨
	ePlantTownLevelType_WorkerCapacity		= 1,		-- 마을 일꾼수용량 레벨
	ePlantTownLevelType_Count				= 2			--
}

-- gc::PlantZoneLevelType
CppEnums.PlantZoneLevelType =
{
	ePlantZoneLevelType_GeneralEfficiency	= 0,		-- 농장 일반효율 레벨
	ePlantZoneLevelType_LuckEfficiency		= 1,		-- 농장 운효율 레벨
	ePlantZoneLevelType_Count				= 2			--
}

-- gc::ExplorationNodeType
CppEnums.ExplorationNodeType =
{
	eExplorationNodeType_Normal			= 0,    -- 노드
	eExplorationNodeType_Viliage		= 1,    -- 마을
	eExplorationNodeType_City			= 2,    -- 도시
	eExplorationNodeType_Gate			= 3,    -- 관문
	eExplorationNodeType_Farm			= 4,    -- 농장
	eExplorationNodeType_Trade			= 5,    -- 무역
	eExplorationNodeType_Collect		= 6,    -- 채집장
	eExplorationNodeType_Quarry			= 7,    -- 채석장
	eExplorationNodeType_Logging		= 8,    -- 벌목장
	eExplorationNodeType_Dangerous		= 9,    -- 위험 지역
	eExplorationNodeType_Finance		= 10,   -- 금융 거래소
	eExplorationNodeType_FishTrap		= 11,   -- 통발
	eExplorationNodeType_MinorFinance	= 12,	-- 마니어 금융거래소
	eExplorationNodeType_MonopolyFarm	= 13,	-- 독점운영농장

	
	eExplorationNodeType_Count			= 14
}

CppEnums.InstantLineRenderType =
{
	InstantLineRenderType_Default			=	0,	-- 일반적인 선
	InstantLineRenderType_AllwaysShow		=	1,	-- 언제나 보임. 색반전등으로 설정함. (현재 디폴트로 작동함 )
	InstantLineRenderType_WorldMapAttach	=	2,	-- 월드맵 라인에 붙여줌.

	InstantLineRenderType_Count				=	3
};

CppEnums.TInventorySlotNoUndefined	= 0xFF
CppEnums.WaypointKeyUndefined		= 0

-- gc::InstallationType
CppEnums.InstallationType =
{
	eType_Default			= 0,						
	eType_Carpenter			= 1,	--설비 도구			
	eType_Alchemy1			= 2,	--연금술 도구		
	eType_Founding			= 3,	--주조물 도구		
	eType_Cooking			= 4,	--요리 도구			
	eType_Forging			= 5,	--모루 도구			
	eType_Treasure			= 6,	--보물함 교환기		
	eType_Smithing			= 7,	--세공 도구			
	eType_Weaving			= 8,	--방직기 도구		
	eType_Bed				= 9,	--침대				
	eType_Havest			= 10,	--밭때기			
	eType_Mortar			= 11,	-- 절구
	eType_Anvil				= 12,	-- 모루
	eType_Stump				= 13,	-- 그루터기
	eType_FireBowl			= 14,	-- 화로
	eType_VendingMachine	= 15,	-- 자판기
	eType_ConsignmentSale	= 16,	-- 위탁판매
	eType_Buff				= 17, 	-- 버프 가능 도구
	eType_RoomServiceTable	= 18,	-- 룹서비스용 테이블
	eType_Bookcase	 		= 19,	-- 책장 
	eType_WarehouseBox		= 20,	-- 창고 박스.
	eType_Alchemy			= 21,	-- 연금술2
	eType_JukeBox			= 22,	-- 쥬크박스
	eType_Pet				= 23,	-- 애완동물
	eType_WallPaper			= 24,	-- 벽지
	eType_FloorMaterial		= 25,	-- 바닥
	eType_Chandelier		= 26,	-- 상들리에
	eType_Curtain			= 27,	-- 커튼
	eType_Scarecrow			= 28,	-- 허수아비
	eType_Waterway			= 29,	-- 수로
	eType_Maid				= 30,	-- 메이드
	eType_Curtain_Tied		= 31,	-- 커튼 front 
	eType_LivestockHarvest	= 32,	-- 가축 재배

	TypeCount				= 33,
}

_PA_ASSERT( CppEnums.InstallationType.TypeCount == getMaxInstallationCount(), "루아의 InstallationType 개수와 클라이언트 코드의 InstallationType 의 개수가 다릅니다. 맞춰주세요" );


-- gc::CollectToolType
CppEnums.CollectToolType =
{
	eType_BareHands			= 0,		-- 맨손					
	eType_EmptyBottle		= 1,		-- 빈병		
	eType_Axe				= 2,		-- 벌목용 도끼		
	eType_Syringe			= 3,		-- 주사기
	eType_Hoe				= 4,		-- 호미
	eType_ButcheryKnife		= 5,		-- 도축용 칼(고기)
	eType_SkinKnife			= 6,		-- 가죽용 칼(가죽)
	eType_Pickax			= 7,		-- 곡괭이
	eType_Tweezers			= 8,		-- 집게(핀셋, 쪽집게 )		
	eType_Pray				= 9,		-- 죽은자의 명복을 비는 도구		
	eType_MagnifyingLens	= 10,		-- 확대경, 돋보기 (조사도구)

	TypeCount			= 11
}

CppEnums.CollectToolTypeName = 
{
	[ CppEnums.CollectToolType.eType_BareHands ] 		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_BAREHANDS"),		 -- 맨손
	[ CppEnums.CollectToolType.eType_EmptyBottle ] 		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_EMPTYBOTTLE"),	 -- 빈병
	[ CppEnums.CollectToolType.eType_Axe ] 				= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_AXE"),			 -- 벌목 도끼
	[ CppEnums.CollectToolType.eType_Syringe ] 			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_SYRINGE"),		 -- 수액 채취 도구
	[ CppEnums.CollectToolType.eType_Hoe ] 				= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_HOE"),			 -- 호미
	[ CppEnums.CollectToolType.eType_ButcheryKnife ] 	= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_BUTCHERYKNIFE"),	 -- 도축용 칼
	[ CppEnums.CollectToolType.eType_SkinKnife ] 		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_SKINKNIFE"),		 -- 무두질용 칼
	[ CppEnums.CollectToolType.eType_Pickax ] 			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_PICKAX"),			 -- 곡괭이
	[ CppEnums.CollectToolType.eType_Tweezers ] 		= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_TWEEZERS"),		 -- 집게
	[ CppEnums.CollectToolType.eType_Pray ] 			= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_PRAY"),			 -- 명복을 비는 도구
	[ CppEnums.CollectToolType.eType_MagnifyingLens ] 	= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_DEFINE_CPP_ENUM_ETYPE_MAGNIFYINGLENS"),	 -- 확대
}

_PA_ASSERT( CppEnums.CollectToolType.TypeCount == getMaxCollectToolTypeCount(), "루아의 CollectToolType 개수와 클라이언트 코드의 CollectToolType의 개수가 다릅니다. 맞춰주세요" );

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
	eItemClassify_Housing		=	10	,   -- 하우징
	eItemClassify_Vehicle		=	11	,   -- 탈것
	eItemClassify_Mine			=	12	,   -- 광석
	eItemClassify_Wood			=	13	,   -- 나무
	eItemClassify_Seed			=	14	,   -- 씨앗&열매
	eItemClassify_Leather		=	15	,   -- 가죽
	eItemClassify_Fish			=	16	,   -- 어류
	eItemClassify_DyeAmpule		=	17	,   -- 염색약

	TypeCount			= 18,
}

CppEnums.ItemClassifyTypeName =
{
	[0] = "eItemClassify_Etc"	,	-- 잡화
	"eItemClassify_Mine"		,   -- 광석
	"eItemClassify_Wood"		,   -- 나무
	"eItemClassify_Seed"		,   -- 씨앗&열매
	"eItemClassify_Leather"		,   -- 가죽
	"eItemClassify_Fish"		,   -- 어류
	"eItemClassify_MainWeapon"	,	-- 주무기
	"eItemClassify_SubWeapon"	,	-- 보조무기
	"eItemClassify_Armor"		,	-- 방어구
	"eItemClassify_Accessory"	,	-- 악세사리
	"eItemClassify_BlackStone"	,	-- 블랙스톤
	"eItemClassify_Jewel"		,	-- 보석
	"eItemClassify_Potion"		,	-- 물약
	"eItemClassify_Cook"		,	-- 요리
	"eItemClassify_PearlGoods"	,	-- 펄 상품
	"eItemClassify_DyeAmpule"	,   -- 염색약
	"eItemClassify_Housing"		,   -- 하우징
	"eItemClassify_Vehicle"		,   -- 탈것
	"eItemClassify_SpecialGoods",	-- 특가상품
}

_PA_ASSERT( CppEnums.ItemClassifyType.TypeCount == getItemClassifyCount(), "루아의 itemClassify 개수와 클라이언트 코드의 itemClassify 의 개수가 다릅니다. 맞춰주세요" );

CppEnums.ContentsEventType =
{
	ContentsType_Housing							= 0,
	ContentsType_SkillInitialize					= 1,
	ContentsType_NpcWorker							= 2,			-- 일꾼 등록
	ContentsType_Mail								= 3,			-- 메일 보내기
	ContentsType_GuildMark							= 4,			-- 길드 마크
	ContentsType_Campfire							= 5,
	ContentsType_ItemBox							= 6,
	ContentsType_ChangeServantName					= 7,			-- Servant 이름 변경
	ContentsType_ChangeServantSkill					= 8,			-- Servant 스킬 변경
	ContentsType_CollectByTool						= 9,
	ContentsType_CarveSeal							= 10,			-- 아이템 각인
	ContentsType_ResetSeal							= 11,			-- 아이템 각이 해제
	ContentsType_PetRegister						= 12,
	ContentsType_PetFeed							= 13,
	ContentsType_ClearVested						= 14,			-- 귀속 해제(장착시 귀속 아이템만)
	ContentsType_Respawn							= 15,
	ContentsType_OrderToServant						= 16,			-- 탈것에게 명령을 내린다.
	ContentsType_NpcWorkerRecovery					= 17,			-- 일꾼 회복
	ContentsType_ChangeNickName						= 18,			-- 가문명 변경
	ContentsType_ClearServantDeadCount				= 19,			-- Servant 죽은 횟수 초기화
	ContentsType_ClearServantMatingCount			= 20,			-- Servant 교배 횟수 초기화 or 추가
	ContentsType_ImprintServant						= 21,			-- Servant 각인.
	ContentsType_Roulette							= 22,
	ContentsType_RemoveKnowledge					= 23,
	ContentsType_HelpReward							= 24,
	ContentsType_SummonCharacter					= 25,
	ContentsType_ReleaseImprintServant				= 26,			-- Servant 각인 해제
	ContentsType_HelpEndurance						= 27,			-- 내구도 복구 도움
	ContentsType_TransferLifeExperience				= 28,			-- 생활 경험치 이전
	ContentsType_ChangeFormServant					= 29,			-- 말 외형 변경.
	ContentsType_ItemChange							= 30,			-- 아이템 교환
	ContentsType_CustomizedItemBox					= 31,			-- 맞춤형 아이템 상자
	ContentsType_Stone								= 32,			-- 현자의 돌
	ContentsType_ServantSkillExpTraining			= 33,			-- 말 숙련도 훈련
	ContentsType_ConvertEnchantFailCountToItem		= 34,			-- 인첸트 실패 카운트를 아이템으로 변환
	ContentsType_ConvertEnchantFailItemToCount		= 35,			-- 인첸트 실패 아이템을 카운트로 변환
	ContentsType_ForgetServantSkill					= 36,			-- 말 스킬 삭제
	ContentsType_Rubbing							= 37,						-- 어탁
	ContentsType_ItemExchangeToClass				= 38,			-- 아이템 교환 ( 자기클래스로 )
	ContentsType_AddGuildQuestReward				= 39,			-- 추가 길드 퀘스트 보상
	ContentsType_Count
}


---------------------------------------------------
-- UI Enums
---------------------------------------------------
-- PAUITypeDefine.h => PA_UI_CONTROL_TYPE
CppEnums.PA_UI_CONTROL_TYPE =
{
	PA_UI_CONTROL_PANEL					= 0,
	PA_UI_CONTROL_STATIC				= 1,
	PA_UI_CONTROL_STATICTEXT			= 2,
	PA_UI_CONTROL_BUTTON				= 3,
	PA_UI_CONTROL_CHECKBUTTON			= 4,
	PA_UI_CONTROL_EDIT					= 5,
	PA_UI_CONTROL_RADIOBUTTON			= 6,
	PA_UI_CONTROL_SLIDER				= 7,
	PA_UI_CONTROL_PROGRESS				= 8,
	PA_UI_CONTROL_PROGRESS2				= 9,
	PA_UI_CONTROL_CIRCULAR_PROGRESS		= 10,
	PA_UI_CONTROL_COMBOBOX				= 11,
	PA_UI_CONTROL_LIST					= 12,
	PA_UI_CONTROL_SCROLL				= 13,
	PA_UI_CONTROL_CHAT					= 14,
	PA_UI_CONTROL_SCROLLWND				= 15,
	PA_UI_CONTROL_SCROLLWND2			= 16,
	PA_UI_CONTROL_POPUP					= 17,
	PA_UI_CONTROL_TREE					= 18,
	PA_UI_CONTROL_FRAME					= 19,
	PA_UI_CONTROL_FRAME_CONTENT			= 20,
	PA_UI_CONTROL_NUMSTATIC				= 21,
	PA_UI_CONTROL_SLIDESTATIC			= 22,
	PA_UI_CONTROL_GROUPLIST				= 23,
	PA_UI_CONTROL_MOVIECLIP				= 24,
	PA_UI_CONTROL_WEBCONTROL			= 25,
	PA_UI_CONTROL_MULTILINETEXT			= 26,
}

CppEnums.PAGameUIType =
{
	PAGameUIPanel_SelfPlayer_ExpGage	= 2,		-- 경험치 바
	PAGameUIPanel_UIMenu				= 3,		-- 메뉴 바
	PAGameUIPanel_RadarMap				= 9,		-- 미니맵
	PAGameUIPanel_QuickSlot				= 12,		-- 퀵슬롯
	PAGameUIPanel_MainStatusBar			= 13,		-- HP/MP
	PAGameUIPanel_Party					= 15,		-- 파티
	PAGameUIPanel_CheckedQuest			= 21,		-- 진행 중 퀘스트
	PAGameUIPanel_MyHouseNavi 			= 22,		-- 주거지/울타리 아이콘
	PAGameUIPanel_ChattingWindow		= 32,		-- 채팅
	PAGameUIPanel_ServantWindow			= 55,		-- 탑승물 아이콘
	PAGameUIPanel_NewEquipment			= 82,		-- 새장비
	PAGameUIPanel_CurrentGuildQuest		= 83,		-- 진행 중인 길드 퀘스트
	PAGameUIPanel_PvpMode				= 84,		-- PVP 모드
	PAGameUIPanel_Adrenallin			= 85,		-- 흑정령의 분노
	PAGameUIPanel_GameTips				= 86,		-- 게임팁
	PAGameUIPanel_TimeBar				= 87,		-- 시간
	PAGameUIPanel_SkillCommand			= 88,		-- 스킬 커맨드
	PAGameUIPanel_ClassResource			= 89,		-- 어둠의 조각 UI

	PAGameUIPanel_NewQuickSlot_1		= 91,
	PAGameUIPanel_NewQuickSlot_2		= 92,
	PAGameUIPanel_NewQuickSlot_3		= 93,
	PAGameUIPanel_NewQuickSlot_4		= 94,
	PAGameUIPanel_NewQuickSlot_5		= 95,
	PAGameUIPanel_NewQuickSlot_6		= 96,
	PAGameUIPanel_NewQuickSlot_7		= 97,
	PAGameUIPanel_NewQuickSlot_8		= 98,
	PAGameUIPanel_NewQuickSlot_9		= 99,
	PAGameUIPanel_NewQuickSlot_0		= 100,
	PAGameUIPanel_NewQuickSlot_11		= 101,
	PAGameUIPanel_NewQuickSlot_12		= 102,
	PAGameUIPanel_NewQuickSlot_13		= 103,
	PAGameUIPanel_NewQuickSlot_14		= 104,
	PAGameUIPanel_NewQuickSlot_15		= 105,
	PAGameUIPanel_NewQuickSlot_16		= 106,
	PAGameUIPanel_NewQuickSlot_17		= 107,
	PAGameUIPanel_NewQuickSlot_18		= 108,
	PAGameUIPanel_NewQuickSlot_19		= 109,
	PAGameUIPanel_NewQuickSlot_10		= 110,

	PAGameUIPanel_KeyViewer				= 124,
}

CppEnums.PanelSaveType =
{
	PanelSaveType_PanelIndex			= 0,		-- 패널 인덱스
	PanelSaveType_IsSaved				= 1,		-- 저장 여부
	PanelSaveType_IsShow				= 2,		-- 노출 여부
	PanelSaveType_PositionX 			= 3,		-- X 좌표 
	PanelSaveType_PositionY				= 4,		-- Y 좌표 
	PanelSaveType_SizeX					= 5,		-- X축 크기
	PanelSaveType_SizeY					= 6,		-- Y축 크기
	PanelSaveType_Alpha					= 7,		-- Alpha값
}


-- PAUIManager.h => PAUIMB_PRIORITY
CppEnums.PAUIMB_PRIORITY =
{
	PAUIMB_PRIORITY_0	= 10,			--최우선 메세지. error message 등을 이것으로 정의 (접속종료 등 발생시)
	PAUIMB_PRIORITY_1m	= 99,			--대기열 창으로 아래 맵이동 메시지를 지우고 발생되어야 한다.(20140326 : juicepia)
	PAUIMB_PRIORITY_1	= 100,			--맵이동등의 우선 메세지(버튼이 없거나 하는 등의 메세지)
	PAUIMB_PRIORITY_2	= 200,			--카운트가 필요한 메세지들의 경우 일부 설정.
	PAUIMB_PRIORITY_LOW	= 1000			--일반적인 메세지
}

-- PAUIManager.h => PAUI_SHOW_FADE_TYPE
CppEnums.PAUI_SHOW_FADE_TYPE =
{
	PAUI_ANI_TYPE_NONE		= 0,
	PAUI_ANI_TYPE_FADE_IN	= 1,
	PAUI_ANI_TYPE_FADE_OUT	= 2
}

-- PAUIManager.h => enOtherListType
CppEnums.OtherListType =
{
	OtherPanelType_TagName	= 0,
	OtherPanelType_Damage	= 1,
	OtherPanelType_Wiki		= 2,
}

-- PAUITypeDefine.h => PAUI_ANIM_ADVANCE_TYPE
CppEnums.PAUI_ANIM_ADVANCE_TYPE =
{
	PAUI_ANIM_ADVANCE_LINEAR		= 0,
	PAUI_ANIM_ADVANCE_LINEAR_2		= 1,
	PAUI_ANIM_ADVANCE_SQUARE		= 2,
	PAUI_ANIM_ADVANCE_SIN_HALF_PI	= 3,
	PAUI_ANIM_ADVANCE_SIN_PI		= 4,
	PAUI_ANIM_ADVANCE_COS_HALF_PI	= 5,
}

-- PAUITypeDefine.h => PAUI_SCALE_ANIM_TYPE
CppEnums.PAUI_SCALE_ANIM_TYPE =
{
	PAUI_ANIM_TYPE_SCALE_X_Y	= 0,
	PAUI_ANIM_TYPE_SCALE_X		= 1,
	PAUI_ANIM_TYPE_SCALE_Y		= 2
}

-- PAUITypeDefine.h => PA_UI_ALIGNHORIZON
CppEnums.PA_UI_ALIGNHORIZON =
{
	PA_UI_HORIZON_NONE		= 0,
	PA_UI_HORIZON_RIGHT		= 1,
	PA_UI_HORIZON_CENTER	= 2,
	PA_UI_HORIZON_LEFT		= 3
}

-- PAUITypeDefine.h => PA_UI_ALIGNVERTICAL
CppEnums.PA_UI_ALIGNVERTICAL =
{
	PA_UI_VERTICAL_NONE		= 0,
	PA_UI_VERTICAL_MIDDLE	= 1,
	PA_UI_VERTICAL_BOTTOM	= 2,
	PA_UI_VERTICAL_TOP		= 3
}

-- PAUITypeDefine.h => PA_UI_CLIP_OPERATOR
CppEnums.PA_UI_CLIP_OPERATOR =
{
	PA_UI_CLIP_NONE			= 0,		-- 클립 없음
	PA_UI_CLIP_RECTANGLE	= 1,		-- 사각 클립
	PA_UI_CLIP_CIRCULAR		= 2,		-- 원형 클립
	PA_UI_CLIP_FAN			= 3,		-- 부채꼴 클립
}

-- PAUITypeDefine.h => PAUI_TEXTURE_TYPE
CppEnums.PAUI_TEXTURE_TYPE =
{
	PAUI_TEXTURE_TYPE_BASE	= 0,
	PAUI_TEXTURE_TYPE_ON	= 1,
	PAUI_TEXTURE_TYPE_CLICK	= 2,
	PAUI_TEXTURE_TYPE_MASK	= 3
}

-- PAUIStatic::TextMode
CppEnums.TextMode =
{
	eTextMode_None = 0,
	eTextMode_LimitText = 1,
	eTextMode_AutoWrap = 2,
	eTextMode_Limit_AutoWrap = 3
}

---------------------------------------------------
-- ge Enums
---------------------------------------------------
-- ge::EProcessorInputMode
CppEnums.EProcessorInputMode =
{
	eProcessorInputMode_GameMode 			= 0,	-- Character Control Mode
	eProcessorInputMode_UiMode				= 1, 	-- Ui Control Mode
	eProcessorInputMode_ChattingInputMode	= 2,	-- 채팅
	eProcessorInputMode_MailInputMode		= 3,	-- 편지 보내기
	--#ifdef _PAWORK_LOGIN_PROCESS_SEPARATION_
	eProcessorInputMode_Lobby				= 4,
	--#endif//#ifdef _PAWORK_LOGIN_PROCESS_SEPARATION_
	eProcessorInputMode_KeyCustom			= 5,
	eProcessorInputMode_KeyCustomizing		= 6,
	eProcessorInputMode_UiModeNotInput		= 7,		-- w,a,s,d 마우스 클릭 사용 불가로 만듬 특정 ui가 떳을 경우 움직이면 안될때 사용하자( 기본적으로는 채팅과 같다 )
	eProcessorInputMode_UiControlMode		= 8,
	eProcessorInputMode_Undefined			= 9,		-- Default Value And Count
}

-- ge::MiniGameType
CppEnums.MiniGameType =
{
	MiniGameType_0		= 0,		-- 중심 맞추기 (Gradient)
	MiniGameType_1		= 1,		-- 낚시 (SinGauge)
	MiniGameType_2		= 2,		-- 커맨드 (Command)
	MiniGameType_3		= 3,		-- 피리 (Rhythm)
	MiniGameType_4		= 4,		-- 배틀 (BattleGauge)
	MiniGameType_5		= 5,		-- 채우기 (FillGauge)
	MiniGameType_6		= 6,		-- 중심 맞추기 Y (Gradient Y)
	MiniGameType_7		= 7,		-- 타이밍 맞추기 (Timing)
	MiniGameType_8		= 8,		-- 드래그 게임 (Drag)
	MiniGameType_9		= 9,		-- 튜토리얼 (게임이 아님!!!) - 삭제 금지
	MiniGameType_10		= 10,		-- 사냥용 피리 (Rhythm)
	MiniGameType_11		= 11,		-- 허브 머신 (타이밍)
	MiniGameType_12		= 12,		-- 부표 (타이밍)
	MiniGameType_13		= 13,		-- 주머니 도둑
	MiniGameType_14		= 14,		-- 파워 컨트롤( 소 젖짜기 )
	MiniGameType_15		= 15,		-- 낚시 작살
	MiniGameType_16		= 16,		-- 리듬게임( 드럼 )
}

-- ge::MiniGameKeyType
CppEnums.MiniGameKeyType =
{
	MiniGameKeyType_W		= 0,
	MiniGameKeyType_S		= 1,
	MiniGameKeyType_A		= 2,
	MiniGameKeyType_D		= 3,
	MiniGameKeyType_Space	= 4,
	MiniGameKeyType_M0		= 5,
	MiniGameKeyType_M1		= 6,
}

---------------------------------------------------
-- luaBindFunc Enums
---------------------------------------------------
-- luaBindFunc::VisibleCharacterMode
-- ActorProxyFactory::VisibleCharacterMode 와 같아야한다.
CppEnums.VisibleCharacterMode =
{
	eVisibleCharacterMode_None				= 0,		-- 자신을 제외한 모든 케릭터를 표시하지 않는다.
	eVisibleCharacterMode_All				= 1,		-- 모든 케릭터를 표시한다.
	eVisibleCharacterMode_Intimaciable		= 2,		-- 자신과 친밀도관련 NPC를 표시한다.
	eVisibleCharacterMode_Interactable		= 3,		-- 자신과 상대중인 NPC만 표시한다.
	eVisibleCharacterMode_Cutscene			= 4,
	eVisibleCharacterMode_Cutscene_With_SelfPlayer = 5,
	eVisibleCharacterMode_Housing			= 6,
	eVisibleCharacterMode_Count				= 7
}



CppEnums.OverheadUIType =
{
	OverheadUIType_Interaction				= 0,		
	OverheadUIType_BubbleBox				= 1,		
	OverheadUIType_Quest					= 2,		
	OverheadUIType_FirstTalk				= 3
}


CppEnums.RewardType =
{
	RewardType_Exp				= 0,		
	RewardType_SkillExp			= 1,		
	RewardType_ProductExp		= 2,		
	RewardType_Item				= 3,
	RewardType_Intimacy			= 4
}




CppEnums.TreeItemType =
{
	PA_TREE_ITEM_ROOT			= 0,		
	PA_TREE_ITEM_CHILD			= 1,
}



CppEnums.BuffType =
{
	BuffType_CurrentHpVariationAmount		= 1,	-- 현재 HP 증감 모듈
	BuffType_MaxHpVariationAmount			= 2,	-- 최대 HP 증감 모듈	
	BuffType_RegenHpVariationAmount			= 3,	-- 리젠 HP 증감 모듈	
	BuffType_CurrentMpVariationAmount		= 4,	-- 현재 MP 증감 모듈	
	BuffType_MaxMpVariationAmount			= 5,    -- 최대 MP 증감 모듈
	BuffType_RegenMpVariationAmount			= 6     -- 리젠 MP 증감 모듈
}
-- 코드의 gc::ServantStateType 이다.
-- 수정시 코드도 수정되야 한다.
CppEnums.ServantStateType	=
{
	Type_Stable				= 0,	-- 마구간
	Type_Field				= 1,	-- 필드
	Type_RegisterMarket		= 2,	-- 마시장 등록
	Type_RegisterMating		= 3,	-- 교배시장 등록
	Type_Mating				= 4,	-- 교배중
	Type_Coma				= 5,	-- 빈사 상태
	Type_SkillTraining		= 6		-- 스킬 숙련도 훈련중
}

CppEnums.ServantToRewardType	=
{
	Type_Money				= 0,	-- 돈
	Type_Experience			= 1		-- 경험치
}

CppEnums.VehicleType	=
{
	Type_Horse			= 0,	-- 말
	Type_Cannon			= 1,	-- 대포
	Type_Camel			= 2,	-- 낙타
	Type_Donkey			= 3,	-- 당나귀
	Type_Elephant		= 4,	-- 코끼리
	Type_Bomb			= 5,	-- 폭탄
	Type_Ladder			= 7,	-- 사다리
	Type_Carriage		= 9,	-- 마차
	Type_Boat			= 18,	-- 나룻배
	Type_Cow			= 26,	-- 젖소
	Type_CowCarriage	= 28,	-- 우마차
	Type_Raft			= 29,	-- 뗏목
	Type_Cat			= 30,	-- 고양이
	Type_Dog			= 31,	-- 강아지
	Type_MountainGoat	= 32,	-- 산양
	Type_FishingBoat	= 33,	-- 어선
	Type_SailingBoat	= 34,	-- 범선
	Type_Train			= 35,	-- 전차
	Type_BabyElephant	= 36,	-- 아기코끼리
}

-- gc::ServantKind
CppEnums.ServantKind	=
{
	Type_Horse				= 0, -- 말
	Type_Camel				= 1, -- 낙타
	Type_Donkey				= 2, -- 당나귀
	Type_Elephant			= 3, -- 코끼리
	Type_TwoWheelCarriage	= 4, -- 이륜 마차
	Type_FourWheeledCarriage= 5, -- 사륜 마차
	Type_Ship				= 6, -- 배
	Type_Cat				= 7, -- 고양이
	Type_Dog				= 8, -- 개
	Type_MountainGoat		= 9, -- 산양
	Type_Raft				= 10,-- 뗏목
	Type_FishingBoat		= 11,-- 어선

	Type_Count				= 12,
}


CppEnums.ServantType	=
{
	Type_Vehicle	= 0,	-- 지상 탈것
	Type_Ship		= 1,	-- 수상 탈것
	Type_Pet		= 2,	-- 애완 동물
	Type_Count		= 3,
}

CppEnums.ServantStatType	=
{
	Type_Acceleration	= 0,	-- 가속도
	Type_MaxMoveSpeed	= 1,	-- 속도
	Type_CorneringSpeed	= 2,	-- 회전력
	Type_BrakeSpeed		= 3,	-- 제동
}

CppEnums.WEATHER_SYSTEM_FACTOR_TYPE	=
{
	-- 서버에서만 사용함 (표시를 해주게 된다면 문제가 달라진다.)
	eWSFT_HUMIDITY		= 0,		-- 습도, 비가 안오면 늘어나고, 비구름 스폰할때 줄어듬, 지역고정 + 최대최소		-- 습도가 높은 곳에 선별적으로 비구름을 스폰할 것이다.
	eWSFT_CELSIUS		= 1,		-- 섭씨 온도 (0이면 0도, 100이면 100도 이다.), 지역고정 + 랜덤 => 평균화		-- 0보다 낮은지로 눈 / 비를 구분할 것 (고도 100미터당 평균 0.7도의 온도 하락이 있다고 함)

	-- DynamicFactor에 의해 반영됨
	eWSFT_CLOUD_RATE	= 2,		-- 운량,		(0~1)															-- 구름의 양으로, 클라이언트 렌더링용으로 사용할 것이다.
	eWSFT_RAIN_AMOUNT	= 3,		-- 강수량,		(0~1)															-- 비의 양으로 클라이언트 렌더링용으로 사용할 것이다.

	-- 자체 생성 데이터				-- RandomSeed를 통해 복원 동기화된다.
	eWSFT_WIND_DIR		= 4,		-- 풍향(radian), 일괄 램덤후 평균화하여 자동생산 됨								-- gc::calculateDirection으로 실제 방향벡터로 만들어 사용할 것!
	eWSFT_WIND_FORCE	= 5,		-- 풍향(radian), 일괄 램덤후 평균화하여 자동생산 됨								-- gc::calculateDirection으로 실제 방향벡터로 만들어 사용할 것!

	-- 클라로 데려갈 추가자원 데이터 (DynamicFactor로 누적데이터 이므로 로그인시점에 복원할 수가 없다.)
	-- Raw로 통채로 전송할경우 : 한 종류당 (160 * 160 섹터 * Float 4Byte = 100KB) 씩 넘어가게 된다.
	eWSFT_WATER			= 6,		-- 지하수량, 온도가 높으면 이것이 습도를 높이게 된다.(0~1)
	eWSFT_OIL			= 7,		-- 석유(흑유) 매장량
	eWSFT_GRASS			= 8,		-- 목초 성장률(0~1)

	eWSFT_MAX			= 9
};

CppEnums.NpcWorkingType =
{
	eNpcWorkingType_PlantZone 					= 0, -- 농장 생산
	eNpcWorkingType_Upgrade						= 1, -- 승급
	eNpcWorkingType_PlantRentHouse				= 2, -- rentHouse 제작
	eNpcWorkingType_ChangeTown					= 3, -- 전출
	eNpcWorkingType_PlantBuliding				= 4, -- 건설
	eNpcWorkingType_RegionManaging				= 5, -- 영지관리
	eNpcWorkingType_PlantRentHouseLargeCraft	= 6, -- RentHouse 대량제작
	eNpcWorkingType_HouseParty					= 7, -- 집에서 파티
	eNpcWorkingType_GuildHouseLargeCraft		= 8, -- 길드 하우스 대량생산
	eNpcWorkingType_HarvestWorking				= 9, -- 텃밭관리

	eNpcWorkingType_Count						= 10
};

CppEnums.NpcWorkingState = 
{
	eNpcWorkingState_Undefined				= -1,	-- 아무런상태를 안쓰는 일종류인 경우 이상태를 씁니다.

	eNpcWorkingState_HarvestWorking_MoveTo	= 900,	-- 일꾼이 텃밭으로 이동중 ( 이때는 텃밭의 작물이 보호받지 못함. )
	eNpcWorkingState_HarvestWorking_Working	= 901,	-- 일꾼이 텃밭에서 일하는 상태
	eNpcWorkingState_HarvestWorking_Return	= 902,	-- 일꾼이 텃밭에서 집으로 돌아가는 상태 ( 이때는 텃밭의 작물이 보호받지 못함. 접속해제, 행동력소모, 유저요청 등으로 해당상태로 넘어옴. )
}

CppEnums.RegionManagingType =
{
	eRegionManagingType_Loyalty	= 0,	-- 충성도
	eRegionManagingType_Farming = 1,	-- 농장 생산
	eRegionManagingType_Fishing = 2,	-- 낚시
	eRegionManagingType_Count	= 3,
};

CppEnums.ContentsType	=
{
	 Contents_Quest				= 0		-- 퀘스트
	,Contents_NewQuest			= 1		-- 새로운 퀘스트
	,Contents_Shop				= 2		-- 상점
	,Contents_Skill				= 3		-- 스킬
	,Contents_Repair			= 4		-- 수리
	,Contents_Auction			= 5		-- 경매
	,Contents_Inn				= 6		-- 여관
	,Contents_Warehouse			= 7		-- 창고
	,Contents_IntimacyGame		= 8		-- 이야기 교류
	,Contents_Stable			= 9		-- 마구간
	,Contents_Transfer			= 10	-- 무역
	,Contents_Guild				= 11	-- 길드
	,Contents_Explore			= 12	-- 탐험
	,Contents_DeliveryPerson	= 13 	-- 정류장
	,Contents_Enchant			= 14 	-- 강화
	,Contents_Socket			= 15 	-- 보석 장착
	,Contents_Awaken			= 16 	-- 각성
	,Contents_ReAwaken			= 17 	-- 재 각성
	,Contents_LordMenu			= 18	-- 영주정보
	,Contents_Extract			= 19	-- 추출
	,Contents_TerritoryTrade	= 20	-- 영지 무역
	,Contents_TerritorySupply	= 21	-- 영지 납품
	,Contents_GuildShop			= 22	-- 길드 상점
	,Contents_ItemMarket		= 23	-- 아이템 판매소
	,Contents_Knowledge			= 24	-- 지식관리
	,Contents_HelpDesk			= 25	-- 길잡이
	,Contents_SupplyShop		= 26	-- 납품 상점( 황실 납품이 아니다 )
	,Contents_MinorLordMenu		= 27  	-- 마이너 공성 세금
	,Contents_FishSupplyShop	= 28  	-- 물고기 납품 상점
	,Contents_Join				= 29  	-- 결전
	,Contents_GuildSupplyShop 	= 30	-- 길드 납품 상점
	--,Contents_RandomShop		= 25	-- 랜덤 상점
};

CppEnums.TransferType	=
{
	 TransferType_Normal= 0		-- 일반
	,TransferType_Self	= 1		-- 자신
	,TransferType_Guild	= 2		-- 길드
	,TransferType_Count	= 3
}

CppEnums.AuctionType	=
{
	 AuctionGoods_Item						= 0	-- 아이템
	,AuctionGoods_WorkerNpc					= 1	-- 용병
	,AuctionGoods_House						= 2	-- 집
	,AuctionGoods_ServantMating				= 3	-- 말 교배
	,AuctionGoods_ServantMarket				= 4	-- 말 시장
	,AuctionGoods_TerritoryTradeAuthority	= 5	-- 황실 무역 권한
	,AuctionGoods_Villa						= 6	-- 빌라 경매
	,AuctionGoods_Count						= 7
};

CppEnums.AuctionTabType =
{
	AuctionTab_SellItem 		= 0
	,AuctionTab_SellHouse		= 1
	,AuctionTab_BuyItem			= 2
	,AuctionTab_MySellPage		= 3
	,AuctionTab_MyBuyPage		= 4
	,AuctionTab_MyBidPage		= 5
	,AuctionTab_tradeTapRate	= 6
	,AuctionTab_ServantMating	= 7 
	,AuctionTab_ServantMarket	= 8
	,AuctionTab_MyServantMating = 9
	,AuctionTab_MyServantMarket = 10
	,AuctionTab_TerritoryTradeAuthority = 11
	,AuctionTab_Worker 			= 12
	,AuctionTab_MyWorker 		= 13
	,AuctionTab_SellVilla 		= 14
	,AuctionTab_Pet 			= 15
	,AuctionTab_MyPet 			= 16
	,AuctionTab_Count 			= 17
};

CppEnums.WaitWorkerSortMethod = {
	eSortWorkSpeed 		= 0,
	eSortMoveSpeed 		= 1,
	eSortLuck		 	= 2,
	eSortActionPoint	= 3,
	eSortMax			= 4,
};

CppEnums.QuestType =
{
	QuestType_Progress 			= 0,	-- 진행 중
	QuestType_Normal_Cleared 	= 1,	-- 연계 퀘스트	
	QuestType_Sub_Cleared 		= 2,    -- 서브 퀘스트
	QuestType_DoGuide 			= 3     -- 가이드 퀘스트(진행 가능 퀘스트)
}

CppEnums.NaviMaterialType =
{
	NaviMaterialType_Normal 	= 0,
	NaviMaterialType_Road 		= 1,	-- 길
	NaviMaterialType_Snow 		= 2,	-- 눈
	NaviMaterialType_Desert 	= 3,	-- 사막
	NaviMaterialType_Swamp 		= 4,	-- 늪
	NaviMaterialType_Object 	= 5,    -- 지형물
	NaviMaterialType_Water 		= 6,    -- 물
	NaviMaterialType_Grass 		= 7,    -- 풀
	NaviMaterialType_UnderWater = 8     -- 물 속
}

-- gc::ClientSpawnType
CppEnums.SpawnType =
{
	eSpawnType_NormalNpc		= 0,	--	일반
	eSpawnType_SkillTrainer		= 1,	--	스킬 트레이너
	eSpawnType_ItemRepairer		= 2,	--	수리
	eSpawnType_ShopMerchant		= 3,	--	일반 상점
	eSpawnType_ImportantNpc		= 4,	--	중요 대화
	eSpawnType_TradeMerchant	= 5,	--	무역 상점
	eSpawnType_WareHouse		= 6,	--	창고
	eSpawnType_Stable			= 7,	--	마굿간
	eSpawnType_Wharf			= 8,	--	선착장
	eSpawnType_transfer			= 9,	--	운송
	eSpawnType_intimacy			= 10,	--	이야기교류
	eSpawnType_guild			= 11,	--	길드
	eSpawnType_explorer			= 12,	--	탐험
	eSpawnType_inn				= 13,	--	여관
	eSpawnType_auction			= 14,	--	경매
	eSpawnType_mating			= 15,	--	상단 행수
	
    eSpawnType_Potion			= 16,	--  물약상인
    eSpawnType_Weapon			= 17,	--  무기상인
    eSpawnType_Jewel			= 18,	--  보석상인
    eSpawnType_Furniture		= 19,	--  가구상인
    eSpawnType_Collect			= 20,	--  재료상인
    eSpawnType_Fish	    		= 21,	--  물고기상인
    eSpawnType_Worker		    = 22,	--  작업감독관
    eSpawnType_Alchemy		    = 23,	--  연금술사
	
	eSpawnType_GuildShop		= 24,	--	길드 상점
	eSpawnType_ItemMarket		= 25,	--	아이템 거래소
	eSpawnType_TerritorySupply	= 26,	--	황실납품
	eSpawnType_TerritoryTrade	= 27,	--	황실무역
	eSpawnType_Smuggle			= 28,	-- 	밀무역
	eSpawnType_Cook				= 29,	--	요리상인
	eSpawnType_PC				= 30,	--	PC방 상인
	eSpawnType_Grocery			= 31,	--	잡화상인
	eSpawnType_RandomShop		= 32,	-- 	랜덤 상점
	eSpawnType_SupplyShop		= 33,	-- 	납품 상점( 황실납품 아님 )
	eSpawnType_RandomShopDay	= 34,	-- 	랜덤 상점 낮
	eSpawnType_FishSupplyShop	= 35,	-- 	물고기 납품 상점
	eSpawnType_GuildSupplyShop	= 36,	-- 	길드 납품 상점
	eSpawnType_GuildStable		= 37,	-- 	길드마굿간

	eSpawnType_Count			= 38,
}

CppEnums.RegionType =
{
	eRegionType_MinorTown			= 0,			-- 일반마을
	eRegionType_MainTown			= 1,			-- 영주/성주가 사는 마을
	eRegionType_Hunting				= 2,			-- 일반 사냥터
	eRegionType_Siege				= 3,			-- 공성지역
	eRegionType_Fortress			= 4,			-- 성채지역
	eRegionType_CastleInSiege		= 5,			-- 공성지역중 성지역(이곳에는 텐트 설치불가능)
	eRegionType_Arena				= 6,			-- 공성전 타입
	eRegionType_Count				= 7
}

CppEnums.DialogState =
{
	eDialogState_ReContact			= "0",		-- 다시 말걸기?
	eDialogState_QuestComplete		= "1",		-- NPC 퀘스트 완료(보상 받기)
	eDialogState_QuestList			= "2",		-- 퀘스트 목록 보는중
	eDialogState_DisplayQuest		= "3",		-- 퀘스트 받는중
	eDialogState_AcceptQuest		= "4",		-- 퀘스트 받기
	eDialogState_RefuseQuest		= "5",		-- 퀘스트 거절
	eDialogState_ProgressQuest		= "6",		-- 진행중일때 
	eDialogState_RestartQuest		= "7",		-- 재입장
	eDialogState_Function			= "8",		-- Npc기능
	eDialogState_Talk				= "9",		-- 대사
	eDialogState_Count				= "10"
}

CppEnums.WarehoouseFromType =
{
	eWarehoouseFromType_Npc				= 0,	-- Npc를 통해 창고를 열었을때
	eWarehoouseFromType_Worldmap		= 1,	-- 월드맵에서 창고를 열었을때
	eWarehoouseFromType_Installation	= 2,	-- 설치물을 통해 창고를 열었을때
	eWarehoouseFromType_GuildHouse		= 3,	-- 길드하우스를 통해 길드 창고를 열었을때
	eWarehoouseFromType_Maid			= 4,	-- 메이드를 통해 창고를 열었을때
	eWarehoouseFromType_Manufacture		= 5,	-- 메이드를 통해 창고를 열었을때
	eWarehoouseFromType_Count			= 6
}

CppEnums.PcWorkType =
{
	ePcWorkType_Empty				= 0,		-- 아무것도 안함
	ePcWorkType_Play				= 1,		-- 유저가 Play중
	ePcWorkType_RepairItem			= 2,		-- 아이템 수리
	ePcWorkType_Delivery			= 3,		-- 이동
	ePcWorkType_Relax				= 4,		-- 휴식
	ePcWorkType_ReadBook			= 5,		-- 책읽기
	ePcWorkType_Count				= 6,
}


CppEnums.MatchType = 
{
	Pvp		= 0,
	Race	= 1,
}


-- gc::ItemWhereType 과 연결된다.
CppEnums.ItemWhereType	=
{
	eInventory			= 0,
	eEquip				= 1,
	eWarehouse			= 2,
	eServantInventory	= 4,
	eServantEquip		= 5,
	eGuildWarehouse		= 14,
	eCashInventory		= 17,
	eCount				= 19,
}

-- gc::QuickSlotDataType 와 연결된다.
CppEnums.QuickSlotType =
{
	eEmpty 		= 0,
	eItem 		= 1,
	eSkill 		= 2,
	eCashItem	= 3,
}

-- gc::CharacterInfoDisplayType 와 연결된다.
CppEnums.CharacterInfoDisplayType =
{
	eCharacterInfoDisplayType_None 		= 0,
	eCharacterInfoDisplayType_Bandit 	= 1,
	eCharacterInfoDisplayType_Whale 	= 2,
	eCharacterInfoDisplayType_Count		= 3,
}

--	CppEnums.ServantType 의 말, 배, 애완동물이 0,1,2 임으로 같은 순서로 기재 하였다.
CppEnums.MoveItemToType =
{
	Type_Vehicle	= 0,	-- 말, 마차
	Type_Ship		= 1,	-- 배
	Type_Pet		= 2,	-- 애완동물
	Type_Player		= 3,	-- Player
	Type_Warehouse	= 4,	-- 창고
	Type_Count		= 5,
}

-- ItemDropType
CppEnums.DropType =
{
	Type_DeadBodyActor	= 0,	--0 = 시체에서 나옴
	Type_CollectInfo	= 1,	--1 = 채집물에서 나옴
	Type_Fishing		= 2,	--2 = 낚시에서 나옴
	Type_Harvest		= 3,	--3 = 재배작물에서 나옴
	Type_Steal			= 4,	--4 = 훔치기물에서 나옴
	Type_CollectUseTool	= 5,	--5 = 훔치기물에서 나옴
}

CppEnums.TaxType =
{
	eTaxType_BuyItemFromSystem			= 0,		-- (무역템포함)아이템을 시스템으로부터 구매할때 구매자에게 징수함. (소비세)
	eTaxType_BuyItemFromConsignment		= 1,		-- 위탁판매기에서 아이템을 구매할때 위탁판매기주인 에게 징수함. (소득세)
	eTaxType_BuyHorseFromServantMarket	= 2,		-- 말 시장에서 말을 구매할때 판매자에게 징수함. (소득세)
	eTaxType_BuyHorseFromServantMating	= 3,		-- 말 교배장에서 말을 구매할때 판매자에게 징수함. (소득세)
	eTaxType_DeliverItemByPublicWagon	= 4,		-- 공용마차에 아이템 운송요청시 요청자에게 징수함. (관세)
	eTaxTypeSellItemToItemMarket		= 5,		-- 아이템거래소에 아이템을 팔렸을때 판매자에게 징수함. (거래세)
	eTaxType_Count						= 6
}

CppEnums.QuestButtonType =
{
	eQuest_BlackSpirit				= 0, 			-- 흑정령 의뢰
	eQuest_Story					= 1, 			-- 스토리(주요 의뢰)
	eQuest_Normal					= 2, 			-- 마을 의뢰(일반 의뢰)
	eQuest_Explore					= 3, 			-- 탐험 의뢰
	eQuest_Trading					= 4,	 		-- 무역 의뢰
	eQuest_Product					= 5, 			-- 생산 의뢰
	eQuest_Repeat					= 6,			-- 반복 의뢰
	eQuest_Count					= 7
}

CppEnums.DialogQuestButtonType =
{
	eDialogButton_QuestBlackSpirit	= 0, 			-- 흑정령 의뢰
	eDialogButton_QuestStory		= 1, 			-- 스토리(주요 의뢰)
	eDialogButton_QuestNormal		= 2, 			-- 마을 의뢰(일반 의뢰)
	eDialogButton_QuestExplore		= 3, 			-- 탐험 의뢰		 
	eDialogButton_QuestTrading		= 4, 			-- 무역 의뢰
	eDialogButton_QuestProduct		= 5, 			-- 생산 의뢰
	eDialogButton_QuestRepeat		= 6, 			-- 반복 의뢰
	eDialogButton_QuestCount		= 7 
}

CppEnums.DialogButtonType =
{
	eDialogButton_Normal			= 0, 			--일반 대화 
	eDialogButton_Knowledge			= 1, 			--지식 주는 대화
	eDialogButton_Function			= 2, 			--기능 있는 대화
	eDialogButton_CutScene			= 3, 			--컷씬 있는 대화
	eDialogButton_Exchange			= 4, 			--아이템 교환 있는 대화
	eDialogButton_ExceptExchange	= 5,			--'R'키로 교환이 되지 않게 하기 위한 아이템 교환 있는 대화
	eDialogButton_Count				= 6
}

CppEnums.PositionGuideActorType = 
{
	ePositionGuideActorType_isGuildMember 		= 0,		-- 길드 멤버
	ePositionGuideActorType_isGuildMaster		= 1,		-- 길드장
	ePositionGuideActorType_isGuildMine			= 2,		-- 길드원 본인
	ePositionGuideActorType_isPartyMember		= 3,		-- 파티 멤버
	ePositionGuideActorType_isPartyMine			= 4,		-- 파티원 본인
	ePositionGuideActorType_Count				= 5
}

-- gc::NpcWorkerState
CppEnums.NpcWorkerState =
{
    NWS_IDLE    = 0,
    NWS_GOWORK  = 1,
    NWS_WORKING = 2,
    NWS_GOHOME  = 3,
    
    NWS_COUNT   = 4,
}

CppEnums.MouseCursorType =
{
	eMouseCursorType_Null = 0,
	eMouseCursorType_Default = 1,
	eMouseCursorType_Item = 2,
	eMouseCursorType_ItemHold = 3,
	eMouseCursorType_Time = 4,
	eMouseCursorType_Repair = 5,
	eMouseCursorType_Interaction = 6,
	eMouseCursorType_Interaction_Looting = 7,
	eMouseCursorType_Attack = 8,

	eMouseCursorType_Count = 9,
}

-- gc::TribeType
CppEnums.TribeType =
{
	eTribe_Human		=0,	-- 인간형
	eTribe_Ain			=1,	-- 아인종
	eTribe_Animal		=2,	-- 동물
	eTribe_Undead		=3,	-- 언데드
	eTribe_Reptile		=4,	-- 파충류
	eTribe_Untribe		=5,	-- 종족없음
	eTribe_Hunting		=6,	-- 수렵형

	eTribe_Count		=7,	-- 총 갯수
}

CppEnums.HouseGroupLocationType =
{
    eHouseGroupLocationType_onlyOne = 0, -- 단층집
    eHouseGroupLocationType_bottom  = 1, -- 복층의 최하층
    eHouseGroupLocationType_center  = 2, -- 3층이상의 복층집중 중간집들
    eHouseGroupLocationType_top     = 3, -- 복층의 최상층
    
    eHouseGroupLocationType_Count   = 4, -- enum 갯수
}

-- 인터렉션 타입
-- gc::InteractionType
CppEnums.InteractionType = 
{
	InteractionType_GamePlay				= 0,	-- 게임 플레이와 관련된 행동(트리거 작동, 돼지치기 등등)		
	InteractionType_ShowCharacterInfo		= 1,	-- 케릭터 정보 보기(Player 전용)
	InteractionType_ExchangeItem			= 2,	-- 아이템 거래(Player 전용)
	InteractionType_InvitedParty			= 3,	-- 파티 초대(Player 전용)
	InteractionType_Talk					= 4,	-- 대화(Dialog Scene, NPC 또는 설치물 전용)
	InteractionType_Ride					= 5,	-- 탈것 타기
	InteractionType_Control					= 6,	-- 조작(대포, 폭탄, 성문크랭크, 사다리 등)
	InteractionType_Looting					= 7,	-- 루팅. (Deadbody 전용)
	InteractionType_Collect					= 8,	-- 채집(채집 Object 전용)
	InteractionType_OpenDoor				= 9,	-- (고정집문) 열기
	InteractionType_GuildWarehouse			= 10,	-- 길드 창고 열기
	InteractionType_RebuildTent				= 11,	-- 텐트 재설치
	InteractionType_InstallationMode		= 12,	-- 설치 모드 변경
	InteractionType_ShowHouseInfo			= 13,	-- (고정집 하우스) 정보 보기
	InteractionType_Havest					= 14,	-- 농작물 수확
	InteractionType_ParkingHorse			= 15,	-- 탈것 주차	텐트 -> 말뚝
	InteractionType_EquipInstallation		= 16,	-- 설치물 장착(활성화)
	InteractionType_UnequipInstallation		= 17,	-- 설치물 해체(비활성화)
	InteractionType_InventoryOpen			= 18,	-- 인벤토리 열기
	InteractionType_ShowServantInformation	= 19,	-- 탈것 정보 보기.
	InteractionType_HouseBussiness			= 20,	-- 설치물 사업자 정보
	InteractionType_GuildInvite				= 21,	-- 길드 초대(Player 전용)
	InteractionType_GuildAllianceInvite		= 22,	-- 연합 초대(Player 전용)
	InteractionType_UseItem					= 23,	-- 아이템 사용
	
	InteractionType_UnbuildPersonalTent		= 24,	-- 텐트 해체

	InteractionType_Manufacture				= 25,	-- 가공 - 생산 활동 
	InteractionType_Greet					= 26,	-- 인사하기 
	InteractionType_Steal					= 27,	-- 소매치기
	InteractionType_Lottery					= 28,	-- 응모하기
	InteractionType_SeedHavest				= 29,	-- 농작물 씨앗 수확
	InteractionType_InstallationPresent		= 30,	-- 설비도구 선물 -> 꾸며주기
	InteractionType_RankerHouseList			= 31,	-- 인테리어 점수 랭크
	InteractionType_HavestLop				= 32,	-- 농작물 가지치기
	InteractionType_HavestKillBug			= 33,	-- 농작물 벌레잡기
	InteractionType_UninstallTrap			= 34,	-- 함정제거
	InteractionType_Sympathetic				= 35,	-- 교감하기
	InteractionType_Observer				= 36,	-- 관전하기
	InteractionType_HarvestInformation		= 37,	-- 작물 정보 보기
	
	InteractionType_ClanInvite				= 38,	-- 클랜 초대
	InteractionType_OpenSiegeGate			= 39,	-- 성문 열기
	InteractionType_UnbuildKingOrLordTent	= 40,	-- 성채 및 지휘소 해체
	InteractionType_Eavesdrop				= 41,	-- 엿듣기
	InteractionType_WaitComment				= 42,	-- 엿듣기
	InteractionType_TakedownCannon			= 43,	-- 대포회수
	InteractionType_OpenWindow				= 44,	-- 창문열기
	InteractionType_ChangeLook				= 45,	-- 외모변경
	InteractionType_ChangeName				= 46,	-- 이름 변경
	InteractionType_UninstallBarricade		= 47,	-- 바리케이트 해체
	InteractionType_RepairKingOrLordTent	= 48,	-- 성채 수리
	InteractionType_UserIntroduction		= 49,	-- 자기소개 보기
	InteractionType_FollowActor				= 50, 	-- 따라가기
	InteractionType_Upgrade					= 51, 	-- 건축물 업그레이드
	
	InteractionType_Count					= 52
}

--gc::DlgCommonCondition::OperatorType
CppEnums.DlgCommonConditionOperatorType = 
{
	Equal				= 0,
	Large				= 1,
	Small				= 2,

    Count               = 3,
}
--gc::CashPurchaseLimitType
CppEnums.CashPurchaseLimitType = 
{
	None				= 0,	--제한 없음
	AtCharacter			= 1,	--케릭터 제한
	AtAccount			= 2,	--계정 제한

    Count               = 3,
}

--ge::InGameCashShopPreviewType
CppEnums.InGameCashShopPreviewType =
{
	SelfPlayer				= 0,	-- SelfPlayer를 View로 보여주고있음
	NormalPlayerCharacter	= 1,	-- 일반플레이어 케릭터를 View로 보여주고있음
	SelflVehicleCharacter	= 2,	-- SelfPlayer가 소환한 탈것을 View로 보여주고 있음
	NormalVehicleCharacter	= 3,	-- 일반 탈것을 View로 보여주고 있음
	Others					= 4,	-- 그외의 아이템으로 소환할 수있는것을 보여주고있음 ( ex 마패, 팻소환서, 가구소환서 )

	Count					= 5,
}


------------------------------------------------------------------------------------------
-- 여기 변수 변경시에 GameCommonForward.h에 변수를 같이 변경 해 주어야 합니다.
------------------------------------------------------------------------------------------
CppEnums.MiniGame =
{
	eMiniGameTutorial						= 2,				-- 기본기의 이해
	eMiniGameHerbMachine					= 3,				-- 약탕기 점프뛰기
	eMiniGameBuoy							= 4,				-- 추출장 부표 흔들어 추출하기
	eMiniGameBuyHouse						= 1000,				-- 집 구매하기
	eMiniGameInvestPlant					= 1001,				-- 거점 투자
	eMiniGamePowerControl					= 1003,				-- 소 젖짜기
	eMiniGameExtraction						= 1007,				-- 강화석 추출
	eMiniGameEditingHouse					= 1008,				-- 집 꾸미기
	eTutorialSitDown						= 9001,				-- 앉기
	eTutorialLean							= 9002,				-- 기대기
}

CppEnums.MiniGameParam =
{
	eMiniGameParamDefault					= 0,				-- 기본값
	eMiniGameParamLoggiaCorn 				= 151,				-- 로기아 농장 - 감자 재배
	eMiniGameParamLoggiaFarm 				= 26,				-- 로기아 농장
	eMiniGameParamAlehandroHoney 			= 432,				-- 알렉한드로 농장 -식용벌꿀
	eMiniGameParamImpCave 					= 25,				-- 임프 동굴
} 

CppEnums.CashProductCategory =
{
	eCashProductCategory_Pearl	 		= 0,
	eCashProductCategory_Mileage		= 1,
	eCashProductCategory_Normal			= 2,
	eCashProductCategory_Costumes		= 3,
	eCashProductCategory_Furniture		= 4,
	eCashProductCategory_Servant		= 5,
	eCashProductCategory_Pet			= 6,
	eCashProductCategory_Customize		= 7,
	eCashProductCategory_Dye			= 8,
	eCashProductCategory_Count			= 9,
	
}

CppEnums.ItemProductCategory =
{
	eItemProductCategory_None	 		= 0,				-- 없음
	eItemProductCategory_Customize		= 1,				-- 커스터마이징
	eItemProductCategory_Revival		= 2,				-- 부활

	eItemProductCategory_Count			= 3,
}

--gc::ProductCategory
CppEnums.ProductCategory =
{
	ProductCategory_Undefined		= 0,	-- 사용하지 않지만, 이전 Excel 데이터와 호환성 때문에 정의.
	ProductCategory_Disassemble		= 1,	-- 분해
	
	-- 생산아이템
	ProductCategory_Farm			= 2,	-- 농장
	ProductCategory_Mine			= 3,	-- 광산
	ProductCategory_LumberCamp		= 4,	-- 벌목장
	
	-- 제작아이템
	ProductCategory_UseRecipe		= 5,	-- 레시피 이용 생산
	ProductCategory_DynamicPlant	= 6,	-- 건축물
	ProductCategory_RegionManager	= 7,	-- 영지관리
	ProductCategory_LargeCraft		= 8,	-- 대량생산
	ProductCategory_Count			= 9,
}

CppEnums.BuyItemReqTrType =
{
	eBuyItemReqTrType_None				= 0,				-- 없음
	eBuyItemReqTrType_ImmediatelyUse	= 1,				-- 구매 아이템 즉시 사용
	eBuyItemReqTrType_UiUpdate			= 2,				-- 화면 업데이트
	eBuyItemReqTrType_CashShopCart		= 3,

	eBuyItemReqTrType_Count				= 4,
}

CppEnums.ContentsServiceType = 
{
	eContentsServiceType_Closed			= 0,				-- 비공개
	eContentsServiceType_CBT			= 1,				-- Closed Beta Test
	eContentsServiceType_Pre			= 2,				-- 사전 다운로드 기간 (커스터마이징만 오픈)
	eContentsServiceType_OBT			= 3,				-- Open Beta Test
	eContentsServiceType_Commercial		= 4,				-- 상용화

	eContentsServiceType_Count			= 5,	
}

-- PA_GAME_SERVICE_TYPE
CppEnums.GameServiceType = 
{
	eGameServiceType_NONE		= 0,
	eGameServiceType_DEV		= 1,
	eGameServiceType_KOR_ALPHA	= 2,
	eGameServiceType_KOR_REAL	= 3,
	eGameServiceType_KOR_TEST	= 4,
	eGameServiceType_JPN_ALPHA	= 5,
	eGameServiceType_JPN_REAL	= 6,
	eGameServiceType_RUS_ALPHA	= 7,
	eGameServiceType_RUS_REAL	= 8,
	eGameServiceType_CHI_ALPHA	= 9,
	eGameServiceType_CHI_REAL	= 10,
	eGameServiceType_NA_ALPHA	= 11,
	eGameServiceType_NA_REAL	= 12,

	eGameServiceType_Count		= 13,	
}

CppEnums.ContryCode = 
{
	eContryCode_KOR		= 0,
	eContryCode_JAP		= 1,
	eContryCode_RUS		= 2,
	eContryCode_CHI		= 3,
	eContryCode_NA		= 4,

	eContryCode_Count	= 5,
}
	
CppEnums.CustomizationNoCashType =
{
	eCustomizationNoCashType_Voice 		= 0,
	eCustomizationNoCashType_Mesh		= 1,
	eCustomizationNoCashType_Deco		= 2,
} 

CppEnums.CustomizationNoCashMesh =
{
	eCustomizationNoCashMesh_Face		= 0,
	eCustomizationNoCashMesh_Hair		= 1,
} 

CppEnums.CustomizationNoCashDeco =
{
	eCustomizationNoCashDeco_FaceTattoo	= 0,
	eCustomizationNoCashDeco_BodyTattoo	= 1,
} 

CppEnums.CustomizationNoCashVoice =
{
	eCustoimzationNoCashVoice_Type	= 0,
} 

CppEnums.ServantRegist	=
{
	eEventType_Inventory		= 0,	-- 아이템
	eEventType_Taming			= 1,	-- 길들이기
	eEventType_Mating			= 2,	-- 교배 보상
	eEventType_ChangeName		= 3,	-- 이름변경
	eEventType_RegisterMarket	= 4,	-- 거래 시장
	eEventType_RegisterMating	= 5,	-- 교배 시장
}

CppEnums.FishEncyclopediaCategory =
{
	eFishEncyclopediaCategory_Etc				= 0,	-- 기타
	eFishEncyclopediaCategory_FreshWaterFish	= 1,	-- 민물고기
	eFishEncyclopediaCategory_SeaFish			= 2,	-- 바다물고기
	eFishEncyclopediaCategory_Crustacea			= 3,    -- 갑각류
	
}

------------------------------------------------------------------------------------------

-- 변경시 클라이언트도 수정 되어야 한다.
CppEnums.WorldMapState = 
{
	eWMS_GLOBAL 						= 0,				-- 사용하지 말 것
	eWMS_EXPLORE_PLANT 					= 1,				-- 노드 탐험 모드
	eWMS_REGION							= 2,				-- 영지관리 상태
	eWMS_LOCATION_INFO_WATER 			= 3,				-- 수자원
	eWMS_LOCATION_INFO_CELCIUS 			= 4,				-- 온도
	eWMS_LOCATION_INFO_HUMIDITY			= 5,				-- 습도
	-- 이 아래로는 클라이언트에 없는 버전이다. 클라이언트에 버전이 추가 되었다면 이 위에 추가해야 한다.
	eWMS_SIMPLE							= 6,
	eWMS_GUILD_WAR						= 7,				-- 거점 전쟁( 클라에는 없는 버전이다! 나중에 모드가 추가 되면 가장 마지막이 되야한다!)
	eWMS_QUEST							= 8,
	eWMS_TRADE							= 9,

}

-- 변경시 클라이언트도 수정 되어야 한다. [WorldMapManagement.h (line : 44)]
CppEnums.WorldMapCheckState = {
	eCheck_Quest 		= 0,
	eCheck_Knowledge 	= 1,
	eCheck_FishnChip 	= 2,
	eCheck_Node 		= 3,
	eCheck_Way 			= 4,
	eCheck_Postions 	= 5,
	eCheck_Trade 		= 6,
	eCheck_Wagon 		= 7,
	eCheck_MAX 			= 8,
}

--gc::WeatherKind
CppEnums.WeatherKind = {
    WeatherKind_Undefined       = 0             ,
    WeatherKind_Water           = 1,			-- 누적 강수량
    WeatherKind_Temperature     = 2,			-- 온도
    WeatherKind_Humidity        = 3,			-- 습도
    WeatherKind_NeedLop         = 4,			-- 가지치기 발생 여부
    WeatherKind_BirdsAttack     = 5,			-- 새들의 서리
    
    WeatherKind_Count           = 6,
}

--gc::HarvestGrowRateKind
CppEnums.HarvestGrowRateKind = {
	HarvestGrowRateKind_Nutrient	= 0,		-- 비료
	HarvestGrowRateKind_Water		= 1,		-- 누적 강수량
	HarvestGrowRateKind_Temperature = 2,		-- 온도

	HarvestGrowRateKind_Count		= 3,
}

CppEnums.GuildGrade = {
	GuildGrade_Clan = 0,
	GuildGrade_Guild = 1,

	GuildGrade_Count = 2,
}

--ge::WorldMapHouseManagement::OWNER_FILTER
CppEnums.HouseOwnerFilter = {
	HOUSE_OWNER_ALL		= 0,
	HOUSE_OWNER_MINE	= 1,
	HOUSE_OWNER_MINE_AT	= 2,
	HOUSE_OWNER_EMPTY	= 3,

	HOUSE_OWNER_COUNT	= 4,
}

CppEnums.HouseUseableFilter = {
	HOUSE_USEABLE_ALL		= 0,
	HOUSE_USEABLE_UPGRADE	= 1,
	HOUSE_USEABLE_CRAFT		= 2,
}

CppEnums.CheckedQuestSortMethod = {
	eCheckedQuestSort_TargetDistance 	= 0,
	eCheckedQuestSort_Type				= 1,
	eCheckedQuestSort_AcceptDate		= 2,
	eCheckedQuestSort_Max				= 3,
}

CppEnums.eHouseUseType = {
	Empty						= 0,	-- 아무것도 아닌타입
	Lodging						= 1,	-- 일꾼 숙소
	Depot						= 2,	-- 창고
	Ranch						= 3,	-- 목장
	WeaponForgingWorkshop		= 4,	-- 무기 단조 공방
	ArmorForgingWorkshop		= 5,	-- 갑주 단조 공방
	HandMadeWorkshop			= 6,	-- 수공예 공방
	WoodCraftWorkshop			= 7,	-- 목공예 공방
	JewelryWorkshop				= 8,	-- 세공소
	ToolWorkshop				= 9,	-- 도구 공방
	Refinery					= 10,	-- 정제소
	ImproveWorkshop				= 11,	-- 개량소
	CannonWorkshop				= 12,	-- 대포 제작 공방
	Shipyard					= 13,	-- 조선소
	CarriageWorkshop			= 14,	-- 마차 제작소
	HorseArmorWorkshop			= 15,	-- 마구 제작소
	FurnitureWorkshop			= 16,	-- 가구 공방
	LocalSpecailtiesWorkshop	= 17,	-- 특산물 가공소
	Wardrobe					= 18,	-- 의상실
	SiegeWeapons				= 19,	-- 공성무기
	ShipParts					= 20,	-- 선박부품
	WagonParts					= 21,	-- 마차부품

	Count						= 22,
}

CppEnums.DelivererType = {
	NotDeliverer	= 0, --개인마차
	Wagon			= 1, -- 공용 아이템 운송 마차
	TransportShip	= 2, -- 공용 아이템 운송 수송선(작은 배)
	TradingShip		= 3, -- 공용 아이템 운송 교역선(큰 배)
	WagonForPerson	= 4, --	공용 사람 운송 마차
	OfferingCarrier	= 5, -- 공물 마차
	TypeCount		= 6 
}

CppEnums.eDeliveryProduct = {
	eDeliveryProduct_Empty			= 0,
	eDeliveryProduct_Item			= 1,
	eDeliveryProduct_Person			= 2,
	eDeliveryProduct_Both			= 3,
}

CppEnums.VisibleNameTagType = {
	eVisibleNameTagType_AllwaysShow		= 0,
	eVisibleNameTagType_ImportantShow	= 1,
	eVisibleNameTagType_NoShow			= 2,
	eVisibleNameTagType_Count			= 3,
}



CppEnums.PetVisibleType = {
	ePetVisibleType_All		= 0,
	ePetVisibleType_Mine	= 1,
	ePetVisibleType_Hide	= 2,
}

CppEnums.NavPathEffectType = {
	eNavPathEffectType_None			= 0,
	eNavPathEffectType_Arrow		= 1,
	eNavPathEffectType_PathEffect	= 2,
	eNavPathEffectType_Fairy		= 3,
}

-- pa::enum PA_SERVICE_RESOURCE_TYPE : byte
CppEnums.ServiceResourceType = {
	eServiceResourceType_Dev	= 0,
	eServiceResourceType_KR		= 1,
	eServiceResourceType_EN		= 2,
	eServiceResourceType_JP		= 3,
	eServiceResourceType_CN		= 4,
	eServiceResourceType_RU		= 5,
	eServiceResourceType_FR		= 6,
	eServiceResourceType_DE		= 7,
	eServiceResourceType_ES		= 8,

	eServiceResourceTypeCount	= 9,
}

-- gc::ApplyWorkingType
CppEnums.ApplyWorkingType = {
	eApplyWorkingType_All				= 0,
	eApplyWorkingType_Cutting			= 1,	-- 세공
	eApplyWorkingType_LargeCraft		= 2,	-- 대량제작
	eApplyWorkingType_WorkShop			= 3,	-- 공방
	eApplyWorkingType_Tools				= 4,	-- 도구
	eApplyWorkingType_Furniture			= 5,	-- 가구
	eApplyWorkingType_Improve			= 6,	-- 개량
	eApplyWorkingType_Wardrobe			= 7,	-- 의상
	eApplyWorkingType_Normal			= 8,	-- 일반
	eApplyWorkingType_SiegeWeapons		= 9,	-- 공성
	eApplyWorkingType_WagonParts		= 10,	-- 탈것
	eApplyWorkingType_Zone				= 11,	-- 농장
	eApplyWorkingType_Building			= 12,	-- 건설
	eApplyWorkingType_Monopoly			= 13,	-- 자산관리
	eApplyWorkingType_Upgrade			= 14,	-- 일꾼 업그레이드
	eApplyWorkingType_HouseParty		= 15,	-- 일꾼 집에서 파티를 즐기자요
	eApplyWorkingType_HarvestWorking	= 16,	-- 일꾼이 텃밭에서 일함
	
	eApplyWorkingType_Count				= 17,
}

CppEnums.ContentsGroupType = {
	CondtionGroupKey					= 0,
	ItemGroupKey						= 1,
	CharacterGroupKey					= 2,
	ExchangeGroupKey					= 3,
	QuestGroupKey						= 4,
	MentalCardGroupKey					= 5,
	TitleGroupKey						= 6,
	ContentsGroupKey					= 7,
}

--gc::InstantCashType
CppEnums.InstantCashType = {
	eInstant_ChangeHouseUseType			= 0,
	eInstant_CompleteServantMating		= 1,	-- 교배 즉시 완료.
	eInstant_CompleteNpcWorking			= 2,	-- 일꾼 일시키기 즉시완료.
	eInstant_CompleteNpcWorkerUpgrade	= 3,	-- 일꾼 승급 즉시완료.

	eInstant_Count						= 4,

}

CppEnums.CountryType = {
	NONE		= 0,
	DEV			= 1,	-- 개발 버전
	KOR_ALPHA	= 2,	-- 다음 사내 테스트용
	KOR_REAL	= 3,	-- 다음 서비스
	KOR_TEST	= 4,	-- 다음 테스트 서버용?(필요할까?)
	JPN_ALPHA	= 5,	-- 일본 사내 테스트용
	JPN_REAL	= 6,	-- 일본 서비스
	RUS_ALPHA	= 7,	-- 러시아 사내 테스트용
	RUS_REAL	= 8,	-- 러시아 서비스
	CHI_ALPHA	= 9,	-- 중국 사내 테스트용
	CHI_REAL	= 10,	-- 중국 서비스
	NA_ALPHA	= 11,   -- 북미 사내 테스트용
  	NA_REAL		= 12,   -- 북미 서비스
}

CppEnums.GuildWarType = {
	GuildWarType_Normal = 0,		-- 일방 전투
	GuildWarType_Both	= 1,  		-- 쌍방 전투
	GuildWarType_Count	= 2,
}

CppEnums.ServantWhereType = {
	ServantWhereTypeUser	= 0,	-- 유저 마구간
	ServantWhereTypeGuild	= 1,	-- 길드 마구간
	ServantWhereTypeCount	= 2,
}

CppEnums.BattleSoundType = {
	Sound_NotUse	= 0,		-- 나오지 않음
	Sound_Always	= 1,		-- 전투 시에 전투 음이 항상 나옴
	Sound_Nomal		= 2,		-- 전투 시에 자신보다 몬스터의 레벨이 자신보다 낮을 경우 나오지 않음.
}

CppEnums.GlobalUIOptionType = {
	NewQuickSlot	= 0,
	DefaultShortCut	= 1,
	PetAllSeal0		= 2,
	PetAllSeal1		= 3,
	PetAllSeal2		= 4,
	PetAllSeal3		= 5,
	PetAllSeal4		= 6,
	PetAllSeal5		= 7,
	PetAllSeal6		= 8,
	PetAllSeal7		= 9,
	PetAllSeal8		= 10,
	PetAllSeal9		= 11,
	AlchemyStone	= 12,
	ColorBlindMode	= 13,
}

CppEnums.MembershipType = {
	default = 0,
	daum	= 1,
	naver	= 2,
}

CppEnums.PartIndex = {
	PartIndex_None				= 0,	-- 해당 파트가 없는 장비슬롯의 경우 여기

	PartIndex_RightHandWeapon	= 1,	-- 주무기
	PartIndex_LeftHandWeapon	= 2,	-- 보조무기
	PartIndex_AwakenWeapon		= 3,	-- 각성무기
	PartIndex_UpperBody			= 4,	-- 갑옷
	PartIndex_Hand				= 5,	-- 장갑
	PartIndex_Foot				= 6,	-- 신발
	PartIndex_Helm				= 7,	-- 투구
	PartIndex_Necklace			= 8,	-- 목걸이
	PartIndex_Ring				= 9,	-- 반지
	PartIndex_EarRing			= 10,	-- 귀걸이
	PartIndex_Lantern			= 11,	-- 랜턴
	PartIndex_Underwear			= 12,	-- 속옷
	PartIndex_FaceDecoration0	= 13,	-- 얼굴데코0
	PartIndex_FaceDecoration1	= 14,	-- 얼굴데코1
	PartIndex_FaceDecoration2	= 15,	-- 얼굴데코2
	PartIndex_Body00			= 16,	-- ?

	PartIndex_Max				= 17,	-- PartIndex 醫낅쪟 ??+ 1 ?꾩뿉 ?좎쓽
}

-- 버프 타입
CppEnums.UserChargeType = {
	eUserChargeType_StarterPackage			= 0,
	eUserChargeType_PremiumPackage			= 1,
	eUserChargeType_PearlPackage			= 2,
	eUserChargeType_PcRoom					= 3,	-- PC는 기존방식대로 사용한다.
	eUserChargeType_CustomizationPackage	= 4,
	eUserChargeType_DyeingPackage			= 5,
	eUserChargeType_Kamasilve				= 6,
	eUserChargeType_Count					= 7,
}

-- enum OPEN_DIRECTORY_TYPE
-- type에 따른 해당 경로 폴더 열기
CppEnums.OpenDirectoryType = {
	DirectoryType_ScreenShot		= 0,		-- 스크린샷 폴더 경로
	DirectoryType_Customization		= 1,		-- 커스터마이즈 폴더 경로
	DirectoryType_UserCache			= 1,		-- 유저캐시	폴더 경로
	DirectoryType_Count				= 3,
}

----------------------------------------------------------------------------------------------------
-- 위에 추가하세요.
function	getNameSize()
	if	isGameServiceTypeKor() or isGameServiceTypeJp()	then
		return( 10 )
	elseif	isGameServiceTypeDev()	then
		return( 10 )
	else
		return( 16 )
	end
end

function	ConvertFromGradeToColor( grade, printType )
	local returnValue = nil
	if nil == printType then
		if ( 0 == grade ) then
			returnValue = Defines.Color.C_FFC4BEBE
		elseif ( 1 == grade ) then
			returnValue = Defines.Color.C_FF5DFF70
		elseif ( 2 == grade ) then
			returnValue = Defines.Color.C_FF4B97FF
		elseif ( 3 == grade ) then
			returnValue = Defines.Color.C_FFFFC832
		elseif ( 4 == grade ) then
			returnValue = Defines.Color.C_FFFF6C00
		else
			returnValue = Defines.Color.C_FFC4BEBE
		end
	else
		if ( 0 == grade ) then
			returnValue = "<PAColor0xffc4bebe>"
		elseif ( 1 == grade ) then
			returnValue = "<PAColor0xFF5DFF70>"
		elseif ( 2 == grade ) then
			returnValue = "<PAColor0xFF4B97FF>"
		elseif ( 3 == grade ) then
			returnValue = "<PAColor0xFFFFC832>"
		elseif ( 4 == grade ) then
			returnValue = "<PAColor0xFFFF6C00>"
		else
			returnValue = "<PAColor0xffc4bebe>"
		end
	end

	return	returnValue
end

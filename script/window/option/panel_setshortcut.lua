Panel_SetShortCut:SetShow( false )

local UI_color 		= Defines.Color

local newShortCut = {
	ui = {
		key_ESC						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_ESC" ),
		key_F1						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F1" ),
		key_F2						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F2" ),
		key_F3						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F3" ),
		key_F4						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F4" ),
		key_F5						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F5" ),
		key_F6						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F6" ),
		key_F7						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F7" ),
		key_F8						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F8" ),
		key_F9						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F9" ),
		key_F10						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F10" ),
		key_F11						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F11" ),
		key_F12						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F12" ),
		key_Wave					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Wave" ),
		key_1						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_1" ),
		key_2						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_2" ),
		key_3						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_3" ),
		key_4						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_4" ),
		key_5						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_5" ),
		key_6						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_6" ),
		key_7						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_7" ),
		key_8						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_8" ),
		key_9						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_9" ),
		key_0						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_0" ),
		key_Minus					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Minus" ),
		key_Plus					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Plus" ),
		key_BackSpace				= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_BackSpace" ),
		key_Tab						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Tab" ),
		key_Q						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Q" ),
		key_W						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_W" ),
		key_E						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_E" ),
		key_R						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_R" ),
		key_T						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_T" ),
		key_Y						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Y" ),
		key_U						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_U" ),
		key_I						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_I" ),
		key_O						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_O" ),
		key_P						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_P" ),
		key_MiddilParenthesisLeft	= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_MiddilParenthesisLeft" ),
		key_MiddilParenthesisRight	= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_MiddilParenthesisRight" ),
		key_ReverseSlash			= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_ReverseSlash" ),
		key_Caps					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Caps" ),
		key_A						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_A" ),
		key_S						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_S" ),
		key_D						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_D" ),
		key_F						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_F" ),
		key_G						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_G" ),
		key_H						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_H" ),
		key_J						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_J" ),
		key_K						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_K" ),
		key_L						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_L" ),
		key_Colon					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Colon" ),
		key_DubbleQuotes			= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_DubbleQuotes" ),
		key_Enter					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Enter" ),
		key_ShiftLeft				= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_ShiftLeft" ),
		key_Z						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Z" ),
		key_X						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_X" ),
		key_C						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_C" ),
		key_V						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_V" ),
		key_B						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_B" ),
		key_N						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_N" ),
		key_M						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_M" ),
		key_Comma					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Comma" ),
		key_Dot						= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Dot" ),
		key_Question				= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Question" ),
		key_ShiftRight				= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_ShiftRight" ),
		key_CtrlLeft				= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_CtrlLeft" ),
		key_WinLeft					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_WinLeft" ),
		key_AltLeft					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_AltLeft" ),
		key_Space					= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_Space" ),
		key_AltRight				= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_AltRight" ),
		key_WinRight				= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_WinRight" ),
		key_CtrlRight				= UI.getChildControl ( Panel_SetShortCut, "StaticText_Key_CtrlRight" ),
		guideMsg					= UI.getChildControl ( Panel_SetShortCut, "Static_NotifyText" ),
		noneSetKeyBG				= UI.getChildControl ( Panel_SetShortCut, "Static_BotBG" ),
		noneSetKeyScroll			= UI.getChildControl ( Panel_SetShortCut, "Scroll_List" ),
		btn_Close					= UI.getChildControl ( Panel_SetShortCut, "Button_Win_Close" ),
		btn_Question				= UI.getChildControl ( Panel_SetShortCut, "Button_Question" ),
		btn_UnSet					= UI.getChildControl ( Panel_SetShortCut, "Button_Key_Unset" ),
	},

	noneSetPool			= {},
	noneSetDataArray	= {},

	config = {
		-- actionKeyCount	= 17,
		tempKey					= -1,
		tempType				= false,
		noneSetCount			= 0,
		noneSetUiCount			= 6,
		noneSetUiGapX			= 230,
		noneSetImportantCount	= 0,
		noneSetStartIdx			= 0,
	},
}

local keyMatching = {
	[CppEnums.VirtualKeyCode.KeyCode_ESCAPE]	=	{  ui = newShortCut.ui.key_ESC,			isEnable = false	},		
	[CppEnums.VirtualKeyCode.KeyCode_F1]		=	{  ui = newShortCut.ui.key_F1,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_F2]		=	{  ui = newShortCut.ui.key_F2,			isEnable = true		},		-- 제작노트
	[CppEnums.VirtualKeyCode.KeyCode_F3]		=	{  ui = newShortCut.ui.key_F3,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_F4]		=	{  ui = newShortCut.ui.key_F4,			isEnable = true		},		-- 뷰티샵
	[CppEnums.VirtualKeyCode.KeyCode_F5]		=	{  ui = newShortCut.ui.key_F5,			isEnable = true		},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F6]		=	{  ui = newShortCut.ui.key_F6,			isEnable = true		},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F7]		=	{  ui = newShortCut.ui.key_F7,			isEnable = true		},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F8]		=	{  ui = newShortCut.ui.key_F8,			isEnable = true		},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F9]		=	{  ui = newShortCut.ui.key_F9,			isEnable = true		},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F10]		=	{  ui = newShortCut.ui.key_F10,			isEnable = true		},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F11]		=	{  ui = newShortCut.ui.key_F11,			isEnable = true		},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F12]		=	{  ui = newShortCut.ui.key_F12,			isEnable = true		},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_OEM_3]		=	{  ui = newShortCut.ui.key_Wave,		isEnable = false	},		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_1]			=	{  ui = newShortCut.ui.key_1,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_2]			=	{  ui = newShortCut.ui.key_2,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_3]			=	{  ui = newShortCut.ui.key_3,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_4]			=	{  ui = newShortCut.ui.key_4,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_5]			=	{  ui = newShortCut.ui.key_5,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_6]			=	{  ui = newShortCut.ui.key_6,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_7]			=	{  ui = newShortCut.ui.key_7,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_8]			=	{  ui = newShortCut.ui.key_8,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_9]			=	{  ui = newShortCut.ui.key_9,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_0]			=	{  ui = newShortCut.ui.key_0,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_SUBTRACT]	=	{  ui = newShortCut.ui.key_Minus,		isEnable = false	},		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_ADD]		=	{  ui = newShortCut.ui.key_Plus,		isEnable = false	},		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_BACK]		=	{  ui = newShortCut.ui.key_BackSpace,	isEnable = false	},		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_TAB]		=	{  ui = newShortCut.ui.key_Tab,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_Q]			=	{  ui = newShortCut.ui.key_Q,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_W]			=	{  ui = newShortCut.ui.key_W,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_E]			=	{  ui = newShortCut.ui.key_E,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_R]			=	{  ui = newShortCut.ui.key_R,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_T]			=	{  ui = newShortCut.ui.key_T,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_Y]			=	{  ui = newShortCut.ui.key_Y,			isEnable = true		},		-- PC방 특별 선물
	[CppEnums.VirtualKeyCode.KeyCode_U]			=	{  ui = newShortCut.ui.key_U,			isEnable = true		},		-- ?
	[CppEnums.VirtualKeyCode.KeyCode_I]			=	{  ui = newShortCut.ui.key_I,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_O]			=	{  ui = newShortCut.ui.key_O,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_P]			=	{  ui = newShortCut.ui.key_P,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_CAPITAL]	=	{  ui = newShortCut.ui.key_Caps,		isEnable = false	},		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_A]			=	{  ui = newShortCut.ui.key_A,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_S]			=	{  ui = newShortCut.ui.key_S,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_D]			=	{  ui = newShortCut.ui.key_D,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_F]			=	{  ui = newShortCut.ui.key_F,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_G]			=	{  ui = newShortCut.ui.key_G,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_H]			=	{  ui = newShortCut.ui.key_H,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_J]			=	{  ui = newShortCut.ui.key_J,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_K]			=	{  ui = newShortCut.ui.key_K,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_L]			=	{  ui = newShortCut.ui.key_L,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_OEM_7]		=	{  ui = newShortCut.ui.key_DubbleQuotes,isEnable = false	},		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_RETURN]	=	{  ui = newShortCut.ui.key_Enter,		isEnable = false	},		
	[CppEnums.VirtualKeyCode.KeyCode_Z]			=	{  ui = newShortCut.ui.key_Z,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_X]			=	{  ui = newShortCut.ui.key_X,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_C]			=	{  ui = newShortCut.ui.key_C,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_V]			=	{  ui = newShortCut.ui.key_V,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_B]			=	{  ui = newShortCut.ui.key_B,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_N]			=	{  ui = newShortCut.ui.key_N,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_M]			=	{  ui = newShortCut.ui.key_M,			isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_OEM_2]		=	{  ui = newShortCut.ui.key_Question,	isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_SHIFT]		=	{  ui = newShortCut.ui.key_ShiftLeft,	isEnable = true		},		
	[CppEnums.VirtualKeyCode.KeyCode_CONTROL]	=	{  ui = newShortCut.ui.key_CtrlLeft,	isEnable = false	},		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_MENU]		=	{  ui = newShortCut.ui.key_AltLeft,		isEnable = false	},		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_SPACE]		=	{  ui = newShortCut.ui.key_Space,		isEnable = true		},		
}

local keyString = {
	[CppEnums.VirtualKeyCode.KeyCode_ESCAPE]	=	"ESC",		
	[CppEnums.VirtualKeyCode.KeyCode_F1]		=	"F1",		
	[CppEnums.VirtualKeyCode.KeyCode_F2]		=	"F2",		-- 제작노트
	[CppEnums.VirtualKeyCode.KeyCode_F3]		=	"F3",		
	[CppEnums.VirtualKeyCode.KeyCode_F4]		=	"F4",		-- 뷰티샵
	[CppEnums.VirtualKeyCode.KeyCode_F5]		=	"F5",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F6]		=	"F6",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F7]		=	"F7",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F8]		=	"F8",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F9]		=	"F9",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F10]		=	"F10",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F11]		=	"F11",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_F12]		=	"F12",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_OEM_3]		=	"OEM_3",		-- 미사용
	[CppEnums.VirtualKeyCode.KeyCode_1]			=	"1",		
	[CppEnums.VirtualKeyCode.KeyCode_2]			=	"2",		
	[CppEnums.VirtualKeyCode.KeyCode_3]			=	"3",		
	[CppEnums.VirtualKeyCode.KeyCode_4]			=	"4",		
	[CppEnums.VirtualKeyCode.KeyCode_5]			=	"5",		
	[CppEnums.VirtualKeyCode.KeyCode_6]			=	"6",		
	[CppEnums.VirtualKeyCode.KeyCode_7]			=	"7",		
	[CppEnums.VirtualKeyCode.KeyCode_8]			=	"8",		
	[CppEnums.VirtualKeyCode.KeyCode_9]			=	"9",		
	[CppEnums.VirtualKeyCode.KeyCode_0]			=	"0",		
	[CppEnums.VirtualKeyCode.KeyCode_SUBTRACT]	=	"SUBTRACT",		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_ADD]		=	"ADD",		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_BACK]		=	"BACK",		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_TAB]		=	"TAB",		
	[CppEnums.VirtualKeyCode.KeyCode_Q]			=	"Q",		
	[CppEnums.VirtualKeyCode.KeyCode_W]			=	"W",		
	[CppEnums.VirtualKeyCode.KeyCode_E]			=	"E",		
	[CppEnums.VirtualKeyCode.KeyCode_R]			=	"R",		
	[CppEnums.VirtualKeyCode.KeyCode_T]			=	"T",		
	[CppEnums.VirtualKeyCode.KeyCode_Y]			=	"Y",		-- PC방 특별 선물
	[CppEnums.VirtualKeyCode.KeyCode_U]			=	"U",		-- ?
	[CppEnums.VirtualKeyCode.KeyCode_I]			=	"I",		
	[CppEnums.VirtualKeyCode.KeyCode_O]			=	"O",		
	[CppEnums.VirtualKeyCode.KeyCode_P]			=	"P",		
	[CppEnums.VirtualKeyCode.KeyCode_CAPITAL]	=	"CAPITAL",		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_A]			=	"A",		
	[CppEnums.VirtualKeyCode.KeyCode_S]			=	"S",		
	[CppEnums.VirtualKeyCode.KeyCode_D]			=	"D",		
	[CppEnums.VirtualKeyCode.KeyCode_F]			=	"F",		
	[CppEnums.VirtualKeyCode.KeyCode_G]			=	"G",		
	[CppEnums.VirtualKeyCode.KeyCode_H]			=	"H",		
	[CppEnums.VirtualKeyCode.KeyCode_J]			=	"J",		
	[CppEnums.VirtualKeyCode.KeyCode_K]			=	"K",		
	[CppEnums.VirtualKeyCode.KeyCode_L]			=	"L",		
	[CppEnums.VirtualKeyCode.KeyCode_OEM_7]		=	"\'",		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_RETURN]	=	"ENTER",		
	[CppEnums.VirtualKeyCode.KeyCode_SHIFT]		=	"SHIFT",		
	[CppEnums.VirtualKeyCode.KeyCode_Z]			=	"Z",		
	[CppEnums.VirtualKeyCode.KeyCode_X]			=	"X",		
	[CppEnums.VirtualKeyCode.KeyCode_C]			=	"C",		
	[CppEnums.VirtualKeyCode.KeyCode_V]			=	"V",		
	[CppEnums.VirtualKeyCode.KeyCode_B]			=	"B",		
	[CppEnums.VirtualKeyCode.KeyCode_N]			=	"N",		
	[CppEnums.VirtualKeyCode.KeyCode_M]			=	"M",		
	[CppEnums.VirtualKeyCode.KeyCode_OEM_2]		=	"/",		
	[CppEnums.VirtualKeyCode.KeyCode_SHIFT]		=	"SHIFT",		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_CONTROL]	=	"CONTROL",		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_MENU]		=	"MENU",		-- 사용불가?
	[CppEnums.VirtualKeyCode.KeyCode_SPACE]		=	"SPACE",		
}

local actionString = {
	[CppEnums.ActionInputType.ActionInputType_MoveFront]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_0"), -- "앞으로 이동",
	[CppEnums.ActionInputType.ActionInputType_MoveBack]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_1"), -- "뒤로 이동",
	[CppEnums.ActionInputType.ActionInputType_MoveLeft]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_2"), -- "왼쪽 이동",
	[CppEnums.ActionInputType.ActionInputType_MoveRight]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_3"), -- "오른쪽 이동",
	[CppEnums.ActionInputType.ActionInputType_Attack1]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_4"), -- "주 공격",
	[CppEnums.ActionInputType.ActionInputType_Attack2]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_5"), -- "보조 공격",
	[CppEnums.ActionInputType.ActionInputType_Dash]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_6"), -- "회피",
	[CppEnums.ActionInputType.ActionInputType_Jump]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_7"), -- "점프",
	[CppEnums.ActionInputType.ActionInputType_Interaction]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_8"), -- "상호작용",
	[CppEnums.ActionInputType.ActionInputType_AutoRun]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_9"), -- "자동 달리기",
	[CppEnums.ActionInputType.ActionInputType_WeaponInOut]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_10"), -- "무기 넣기/꺼내기",
	[CppEnums.ActionInputType.ActionInputType_CameraReset]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_11"), -- "카메라 초기화",
	[CppEnums.ActionInputType.ActionInputType_CrouchOrSkill]= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_12"), -- "특수행동1",
	[CppEnums.ActionInputType.ActionInputType_GrabOrGuard]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_13"), -- "특수행동2",
	[CppEnums.ActionInputType.ActionInputType_Kick]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_14"), -- "특수행동3",
	[CppEnums.ActionInputType.ActionInputType_ServantOrder1]= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_15"), -- "소환수/용병 명령1",
	[CppEnums.ActionInputType.ActionInputType_ServantOrder2]= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_16"), -- "소환수/용병 명령2",
	[CppEnums.ActionInputType.ActionInputType_ServantOrder3]= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_17"), -- "소환수/용병 명령3",
	[CppEnums.ActionInputType.ActionInputType_ServantOrder4]= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_18"), -- "소환수/용병 명령4",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot1]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_19"), -- "퀵슬롯1",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot2]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_20"), -- "퀵슬롯2",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot3]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_21"), -- "퀵슬롯3",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot4]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_22"), -- "퀵슬롯4",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot5]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_23"), -- "퀵슬롯5",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot6]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_24"), -- "퀵슬롯6",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot7]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_25"), -- "퀵슬롯7",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot8]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_26"), -- "퀵슬롯8",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot9]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_27"), -- "퀵슬롯9",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot10]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_28"), -- "퀵슬롯10",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot11]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_29"), -- "퀵슬롯11",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot12]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_30"), -- "퀵슬롯12",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot13]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_31"), -- "퀵슬롯13",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot14]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_32"), -- "퀵슬롯14",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot15]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_33"), -- "퀵슬롯15",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot16]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_34"), -- "퀵슬롯16",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot17]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_35"), -- "퀵슬롯17",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot18]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_36"), -- "퀵슬롯18",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot19]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_37"), -- "퀵슬롯19",
	[CppEnums.ActionInputType.ActionInputType_QuickSlot20]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_38"), -- "퀵슬롯20",
	[CppEnums.ActionInputType.ActionInputType_Complicated0]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_39"), -- "펑션1",
	[CppEnums.ActionInputType.ActionInputType_Complicated1]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_40"), -- "펑션1",
	[CppEnums.ActionInputType.ActionInputType_Complicated2]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_41"), -- "펑션1",
	[CppEnums.ActionInputType.ActionInputType_Complicated3]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_42"), -- "펑션1",
	[CppEnums.ActionInputType.ActionInputType_WalkMode]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_43"), -- "펑션1",
	[CppEnums.ActionInputType.ActionInputType_Undefined]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_00"), -- "미확인 액션",
}

local uiString = {
	[CppEnums.UiInputType.UiInputType_CursorOnOff]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_0"), -- "마우스 커서 보이기/숨기기",
	[CppEnums.UiInputType.UiInputType_Help]				= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_1"), -- "도움말",
	[CppEnums.UiInputType.UiInputType_MentalKnowledge]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_2"), -- "지식",
	[CppEnums.UiInputType.UiInputType_Inventory]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_3"), -- "가방",
	[CppEnums.UiInputType.UiInputType_BlackSpirit]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_4"), -- "흑정령",
	[CppEnums.UiInputType.UiInputType_Chat]				= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_5"), -- "채팅",
	[CppEnums.UiInputType.UiInputType_PlayerInfo]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_6"), -- "플레이어 정보",
	[CppEnums.UiInputType.UiInputType_Skill]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_7"), -- "기술",
	[CppEnums.UiInputType.UiInputType_WorldMap]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_8"), -- "월드맵",
	[CppEnums.UiInputType.UiInputType_Dyeing]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_9"), -- "염색",
	[CppEnums.UiInputType.UiInputType_ProductionNote]	= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_10"), -- "제작노트",
	[CppEnums.UiInputType.UiInputType_Manufacture]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_11"), -- "가공",
	[CppEnums.UiInputType.UiInputType_Guild]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_12"), -- "길드",
	[CppEnums.UiInputType.UiInputType_Mail]				= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_13"), -- "우편",
	[CppEnums.UiInputType.UiInputType_FriendList]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_14"), -- "친구 목록",
	[CppEnums.UiInputType.UiInputType_Present]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_15"), -- "특별 보상",
	[CppEnums.UiInputType.UiInputType_QuestHistory]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_16"), -- "의뢰",
	[CppEnums.UiInputType.UiInputType_Cancel]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_17"), -- "취소",
	[CppEnums.UiInputType.UiInputType_CashShop]			= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_18"), -- "펄상점",
	[CppEnums.UiInputType.UiInputType_BeautyShop]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_19"), -- "뷰티샵",
	[CppEnums.UiInputType.UiInputType_AlchemySton]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_20"), -- "연금석",
	[CppEnums.UiInputType.UiInputType_Undefined]		= PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_00"), -- "미확인 UI",
}

local shortCutType	= {
	action	= 0,
	ui		= 1,
}
local defaultShortCut = {
	[CppEnums.ContryCode.eContryCode_KOR]	= {
		[shortCutType.action]	= {
			[CppEnums.ActionInputType.ActionInputType_MoveFront]	= CppEnums.VirtualKeyCode.KeyCode_W,
			[CppEnums.ActionInputType.ActionInputType_MoveBack]		= CppEnums.VirtualKeyCode.KeyCode_S,
			[CppEnums.ActionInputType.ActionInputType_MoveLeft]		= CppEnums.VirtualKeyCode.KeyCode_A,
			[CppEnums.ActionInputType.ActionInputType_MoveRight]	= CppEnums.VirtualKeyCode.KeyCode_D,
			[CppEnums.ActionInputType.ActionInputType_Attack1]		= CppEnums.VirtualKeyCode.KeyCode_LBUTTON,
			[CppEnums.ActionInputType.ActionInputType_Attack2]		= CppEnums.VirtualKeyCode.KeyCode_RBUTTON,
			[CppEnums.ActionInputType.ActionInputType_Dash]			= CppEnums.VirtualKeyCode.KeyCode_SHIFT,
			[CppEnums.ActionInputType.ActionInputType_Jump]			= CppEnums.VirtualKeyCode.KeyCode_SPACE,
			[CppEnums.ActionInputType.ActionInputType_Interaction]	= CppEnums.VirtualKeyCode.KeyCode_R,
			[CppEnums.ActionInputType.ActionInputType_AutoRun]		= CppEnums.VirtualKeyCode.KeyCode_T,
			[CppEnums.ActionInputType.ActionInputType_WeaponInOut]	= CppEnums.VirtualKeyCode.KeyCode_TAB,
			[CppEnums.ActionInputType.ActionInputType_CameraReset]	= nil,
			[CppEnums.ActionInputType.ActionInputType_CrouchOrSkill]= CppEnums.VirtualKeyCode.KeyCode_Q,
			[CppEnums.ActionInputType.ActionInputType_GrabOrGuard]	= CppEnums.VirtualKeyCode.KeyCode_E,
			[CppEnums.ActionInputType.ActionInputType_Kick]			= CppEnums.VirtualKeyCode.KeyCode_F,
			[CppEnums.ActionInputType.ActionInputType_ServantOrder1]= CppEnums.VirtualKeyCode.KeyCode_Z,
			[CppEnums.ActionInputType.ActionInputType_ServantOrder2]= CppEnums.VirtualKeyCode.KeyCode_X,
			[CppEnums.ActionInputType.ActionInputType_ServantOrder3]= CppEnums.VirtualKeyCode.KeyCode_C,
			[CppEnums.ActionInputType.ActionInputType_ServantOrder4]= CppEnums.VirtualKeyCode.KeyCode_V,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot1]	= CppEnums.VirtualKeyCode.KeyCode_0,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot2]	= CppEnums.VirtualKeyCode.KeyCode_1,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot3]	= CppEnums.VirtualKeyCode.KeyCode_2,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot4]	= CppEnums.VirtualKeyCode.KeyCode_3,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot5]	= CppEnums.VirtualKeyCode.KeyCode_4,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot6]	= CppEnums.VirtualKeyCode.KeyCode_5,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot7]	= CppEnums.VirtualKeyCode.KeyCode_6,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot8]	= CppEnums.VirtualKeyCode.KeyCode_7,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot9]	= CppEnums.VirtualKeyCode.KeyCode_8,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot10]	= CppEnums.VirtualKeyCode.KeyCode_9,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot11]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot12]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot13]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot14]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot15]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot16]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot17]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot18]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot19]	= nil,
			[CppEnums.ActionInputType.ActionInputType_QuickSlot20]	= nil,
		},
		[shortCutType.ui]		= {
			[CppEnums.UiInputType.UiInputType_CursorOnOff]			= CppEnums.VirtualKeyCode.KeyCode_CONTROL,
			[CppEnums.UiInputType.UiInputType_Help]					= CppEnums.VirtualKeyCode.KeyCode_F1,		-- 도움말
			[CppEnums.UiInputType.UiInputType_MentalKnowledge]		= CppEnums.VirtualKeyCode.KeyCode_H,		-- 지식
			[CppEnums.UiInputType.UiInputType_Inventory]			= CppEnums.VirtualKeyCode.KeyCode_I,		-- 인벤토리 
			[CppEnums.UiInputType.UiInputType_BlackSpirit]			= CppEnums.VirtualKeyCode.KeyCode_OEM_2,		-- 흑정령
			[CppEnums.UiInputType.UiInputType_Chat]					= CppEnums.VirtualKeyCode.KeyCode_RETURN,		-- 채팅
			[CppEnums.UiInputType.UiInputType_PlayerInfo]			= CppEnums.VirtualKeyCode.KeyCode_P,		-- 플레이어 정보
			[CppEnums.UiInputType.UiInputType_Skill]				= CppEnums.VirtualKeyCode.KeyCode_K,		-- 스킬
			[CppEnums.UiInputType.UiInputType_WorldMap]				= CppEnums.VirtualKeyCode.KeyCode_M,		-- 월드맵
			[CppEnums.UiInputType.UiInputType_Dyeing]				= CppEnums.VirtualKeyCode.KeyCode_J,		-- 염색
			[CppEnums.UiInputType.UiInputType_ProductionNote]		= CppEnums.VirtualKeyCode.KeyCode_F2,		-- 제작노트
			[CppEnums.UiInputType.UiInputType_Manufacture]			= CppEnums.VirtualKeyCode.KeyCode_L,		-- 가공
			[CppEnums.UiInputType.UiInputType_Guild]				= CppEnums.VirtualKeyCode.KeyCode_G,		-- 길드
			[CppEnums.UiInputType.UiInputType_Mail]					= CppEnums.VirtualKeyCode.KeyCode_B,		-- 우편
			[CppEnums.UiInputType.UiInputType_FriendList]			= CppEnums.VirtualKeyCode.KeyCode_N,		-- 친구
			[CppEnums.UiInputType.UiInputType_Present]				= CppEnums.VirtualKeyCode.KeyCode_Y,		-- 특별 보상
			[CppEnums.UiInputType.UiInputType_QuestHistory]			= CppEnums.VirtualKeyCode.KeyCode_O,		-- 퀘스트 로그
			[CppEnums.UiInputType.UiInputType_Cancel]				= CppEnums.VirtualKeyCode.KeyCode_ESCAPE,		-- 취소
			[CppEnums.UiInputType.UiInputType_CashShop]				= CppEnums.VirtualKeyCode.KeyCode_F3,		-- 캐쉬샵
			[CppEnums.UiInputType.UiInputType_BeautyShop]			= CppEnums.VirtualKeyCode.KeyCode_F4,		-- 뷰티샵
			[CppEnums.UiInputType.UiInputType_AlchemySton]			= CppEnums.VirtualKeyCode.KeyCode_U,		-- 연금석
		},
	},
	[CppEnums.ContryCode.eContryCode_JAP]	= {
		[shortCutType.action]	= {},
		[shortCutType.ui]		= {},
	},
	[CppEnums.ContryCode.eContryCode_RUS]	= {
		[shortCutType.action]	= {},
		[shortCutType.ui]		= {},
	},
	[CppEnums.ContryCode.eContryCode_CHI]	= {
		[shortCutType.action]	= {},
		[shortCutType.ui]		= {},
	},
	[CppEnums.ContryCode.eContryCode_NA]	= {
		[shortCutType.action]	= {},
		[shortCutType.ui]		= {},
	},
}

local myKey = {
	action	= {},
	ui		= {},
}

function newShortCut:SetDefaultKey()
	for key, value in pairs( keyMatching ) do
		local isDefine = keyCustom_IsDefine( key )
		if false == isDefine then
			-- 미지정
		else
			local actionKey = keyCustom_getDefineAction( key )
			if actionKey <= CppEnums.ActionInputType.ActionInputType_Undefined then
				-- 액션키
				myKey.action = { enums = actionKey, virtualKeyCode = key }
			else
				local uiKey = keyCustom_getDefineUI( key )
				if uiKey <= CppEnums.UiInputType.UiInputType_Undefined then
					-- ui키
					myKey.ui = { enums = actionKey, virtualKeyCode = key }
				else
					-- 오류
				end
			end
		end
	end
end
-- newShortCut:SetDefaultKey()



function newShortCut:Init()
	for noneSetIdx = 0, self.config.noneSetUiCount -1 do
		local tempArray = {}
		tempArray.keyDesc		= UI.createAndCopyBasePropertyControl( Panel_SetShortCut, "StaticText_SelectValue",	self.ui.noneSetKeyBG, "SetShortCut_noneSetKeyDesc_" .. noneSetIdx )
		tempArray.btn			= UI.createAndCopyBasePropertyControl( Panel_SetShortCut, "StaticText_SelectButton",tempArray.keyDesc, "SetShortCut_noneSetKeyBtn_" .. noneSetIdx )
		tempArray.keyDesc	:SetPosX( 10 + ( (noneSetIdx % 2) * self.config.noneSetUiGapX ) )
		tempArray.keyDesc	:SetPosY( 33 + ( (tempArray.keyDesc:GetSizeY() + 5) * ( math.floor(noneSetIdx/2) ) ) )
		tempArray.btn		:SetPosX( 145 )
		tempArray.btn		:SetPosY( 0 )

		tempArray.keyDesc	:addInputEvent( "Mouse_UpScroll",	"newShortCut_NoneSetScroll( true )" )
		tempArray.keyDesc	:addInputEvent( "Mouse_DownScroll",	"newShortCut_NoneSetScroll( false )" )
		tempArray.btn		:addInputEvent( "Mouse_UpScroll",	"newShortCut_NoneSetScroll( true )" )
		tempArray.btn		:addInputEvent( "Mouse_DownScroll",	"newShortCut_NoneSetScroll( false )" )

		self.noneSetPool[noneSetIdx] = tempArray
	end

	newShortCut:Update() -- 한 번 해야 함.
end


function newShortCut:Update()
	for key, value in pairs( keyMatching ) do
		local isDefine = keyCustom_IsDefine( key )
		if false == isDefine then
			value.ui:SetFontColor( UI_color.C_FFEFEFEF )
		else
			local actionKey = keyCustom_getDefineAction( key )
			if actionKey <= CppEnums.ActionInputType.ActionInputType_Undefined then
				value.ui:SetFontColor( UI_color.C_FFEF5378 )
				value.ui:addInputEvent( "Mouse_On",		"HandleOnOut_newShortCut_ActionKeyToolTip( true, true, " .. actionKey .. ", " .. key .. " )" )
				value.ui:addInputEvent( "Mouse_Out",	"HandleOnOut_newShortCut_ActionKeyToolTip( false, true, " .. actionKey .. ", " .. key .. " )" )
				value.ui:setTooltipEventRegistFunc( "HandleOnOut_newShortCut_ActionKeyToolTip( true, true, " .. actionKey .. ", " .. key .. " )" )
			else
				local uiKey = keyCustom_getDefineUI( key )
				if uiKey <= CppEnums.UiInputType.UiInputType_Undefined then
					value.ui:SetFontColor( UI_color.C_FF8EBD00 )
					value.ui:addInputEvent( "Mouse_On",		"HandleOnOut_newShortCut_ActionKeyToolTip( true, false, " .. uiKey .. ", " .. key .. " )" )
					value.ui:addInputEvent( "Mouse_Out",	"HandleOnOut_newShortCut_ActionKeyToolTip( false, false, " .. uiKey .. ", " .. key .. " )" )
					value.ui:setTooltipEventRegistFunc( "HandleOnOut_newShortCut_ActionKeyToolTip( true, false, " .. uiKey .. ", " .. key .. " )" )
				else
					_PA_ASSERT( true, "최대호 : 키가 설정되어 있다면, 액션이나 UI 중 하나여야 하는데 ???" )
				end
			end
		end
		
		if value.isEnable then
			value.ui:SetEnable( true )
		else
			value.ui:SetEnable( false )
			value.ui:SetFontColor( UI_color.C_FF888888 )
		end
	end

	-- { 미설정 키 업데이트
		self:UpdateNoneSetKey()
	-- }
end

function newShortCut:UpdateNoneSetKey()
	-- { 초기화
		for idx = 0, self.config.noneSetUiCount -1 do
			local slot = self.noneSetPool[idx]
			slot.keyDesc:SetShow( false )
		end
	-- }

	-- { 미설정 키 확인
		self.noneSetDataArray				= {}
		self.config.noneSetCount			= 0
		self.config.noneSetImportantCount	= 0
		for idx = 0, CppEnums.ActionInputType.ActionInputType_Undefined -1 do
			local checkValue = keyCustom_GetString_ActionKey( idx )
			if "" == checkValue then
				local isImportant = self:CheckImportantShortCut( true, idx )
				if 1 == isImportant then
					self.config.noneSetImportantCount = self.config.noneSetImportantCount + 1
				end
				self.noneSetDataArray[self.config.noneSetCount] = {
					isAction	= true,
					idx			= idx,
					important	= isImportant,
				}
				self.config.noneSetCount = self.config.noneSetCount + 1
			end
		end

		for idx = 0, CppEnums.UiInputType.UiInputType_Undefined -1 do
			local checkValue = keyCustom_GetString_UiKey( idx )
			if "" == checkValue then
				local isImportant = self:CheckImportantShortCut( false, idx )
				if 1 == isImportant then
					self.config.noneSetImportantCount = self.config.noneSetImportantCount + 1
				end
				self.noneSetDataArray[self.config.noneSetCount] = {
					isAction	= false,
					idx			= idx,
					important	= isImportant
				}
				self.config.noneSetCount = self.config.noneSetCount + 1
			end
		end
	-- }

	local noneSetKetSort = function( a, b )
		if b.important < a.important then
			return true
		else
			return false
		end
	end

	table.sort( self.noneSetDataArray, noneSetKetSort )

	-- { 미설정 키 업데이트
		local uiIdx = 0
		for idx = self.config.noneSetStartIdx, self.config.noneSetCount -1 do
			if self.config.noneSetUiCount <= uiIdx then
				 break
			end

			local data = self.noneSetDataArray[idx]
			local string = ""
			if data.isAction then
				string = actionString[data.idx]
			else
				string = uiString[data.idx]
			end
			local slot = self.noneSetPool[uiIdx]
			if 1 == data.important then
				slot.keyDesc:SetFontColor( UI_color.C_FFF26A6A )
				slot.btn	:SetFontColor( UI_color.C_FFF26A6A )
				string = PAGetString(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_NECESSARY") .. " " .. string
			else
				slot.keyDesc:SetFontColor( UI_color.C_FFEFEFEF )
				slot.btn	:SetFontColor( UI_color.C_FFEFEFEF )
			end
			slot.keyDesc:SetText( string )
			slot.keyDesc:SetShow( true )

			slot.btn	:addInputEvent( "Mouse_LUp", "HandleClicked_NewShortCut_SetImportantKey( " .. idx .. ", " .. data.idx .. " )" )

			uiIdx = uiIdx + 1
		end
		UIScroll.SetButtonSize( self.ui.noneSetKeyScroll, self.config.noneSetUiCount/2, self.config.noneSetCount/2 )
	-- }

	if 6 < self.config.noneSetCount then
		self.ui.noneSetKeyScroll:SetShow( true )
	else
		self.ui.noneSetKeyScroll:SetShow( false )
	end
end

function newShortCut:CheckImportantShortCut( isAction, key )
	if isAction then
		if key == CppEnums.ActionInputType.ActionInputType_MoveFront
			or key == CppEnums.ActionInputType.ActionInputType_MoveBack
			or key == CppEnums.ActionInputType.ActionInputType_MoveLeft
			or key == CppEnums.ActionInputType.ActionInputType_MoveRight
			or key == CppEnums.ActionInputType.ActionInputType_Attack1
			or key == CppEnums.ActionInputType.ActionInputType_Attack2
			or key == CppEnums.ActionInputType.ActionInputType_Dash
			or key == CppEnums.ActionInputType.ActionInputType_Jump
			or key == CppEnums.ActionInputType.ActionInputType_Interaction
			or key == CppEnums.ActionInputType.ActionInputType_CrouchOrSkill
			or key == CppEnums.ActionInputType.ActionInputType_GrabOrGuard
			or key == CppEnums.ActionInputType.ActionInputType_Kick
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot1
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot2
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot3
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot4
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot5
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot6
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot7
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot8
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot9
			or key == CppEnums.ActionInputType.ActionInputType_QuickSlot10 then
			return 1
		end
	else
		if key == CppEnums.UiInputType.UiInputType_Inventory
			or key == CppEnums.UiInputType.UiInputType_BlackSpirit
			or key == CppEnums.UiInputType.UiInputType_Chat
			or key == CppEnums.UiInputType.UiInputType_PlayerInfo
			or key == CppEnums.UiInputType.UiInputType_Skill
			or key == CppEnums.UiInputType.UiInputType_WorldMap
			or key == CppEnums.UiInputType.UiInputType_Manufacture
			or key == CppEnums.UiInputType.UiInputType_Guild
			or key == CppEnums.UiInputType.UiInputType_Mail
			or key == CppEnums.UiInputType.UiInputType_FriendList
			or key == CppEnums.UiInputType.UiInputType_QuestHistory
			or key == CppEnums.UiInputType.UiInputType_Cancel
			or key == CppEnums.UiInputType.UiInputType_CashShop 
			or key == CppEnums.UiInputType.UiInputType_BeautyShop
			or key == CppEnums.UiInputType.UiInputType_AlchemySton then
			return 1
		end
	end

	return 0
end

function newShortCut:Open()
	Panel_SetShortCut:SetShow( true )
	self:Update()
end
function newShortCut:Close()
	self.config.tempKey		= -1
	self.config.tempType	= false

	-- if 0 < self.config.noneSetImportantCount then
	-- 	Proc_ShowMessage_Ack( "필수 키를 설정해야 합니다." )
	-- 	return
	-- end

	if Panel_Tooltip_SimpleText:GetShow() then
		TooltipSimple_Hide()
	end

	Panel_SetShortCut:SetShow( false )
end

function FGlobal_NewShortCut_SetQuickSlot( actionKey, isActionType )	-- 퀵슬롯 : 화면에 아이템이나 스킬을 드래그 했을 때, 열린다.
	newShortCut.config.tempKey	= actionKey
	newShortCut.config.tempType	= isActionType

	newShortCut:Open()
	newShortCut:Update()

	local targetKeyString = ""
	if newShortCut.config.tempType then
		targetKeyString = actionString[newShortCut.config.tempKey]
	else
		targetKeyString = uiString[newShortCut.config.tempKey]
	end

	newShortCut.ui.guideMsg:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_SELECTKEY", "key", targetKeyString ) ) -- "[" .. targetKeyString .. "]키의 단축키를 선택해주세요."
end

function FGlobal_NewShortCut_Close()
	newShortCut:Close()
end

function HandleClicked_NewShortCut_Close()
	newShortCut:Close()
end

function HandleClicked_NewShortCut_SetImportantKey( dataIdx, index )
	local data		= newShortCut.noneSetDataArray[dataIdx]
	local string	= ""
	if data.isAction then
		string = actionString[data.idx]
	else
		string = uiString[data.idx]
	end

	newShortCut.config.tempKey	= data.idx
	newShortCut.config.tempType	= data.isAction

	newShortCut.ui.guideMsg:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_SELECTKEY", "key", string ) ) -- "[" .. string .. "]키의 단축키를 선택해주세요."
end
function HandleOnOut_newShortCut_ActionKeyToolTip( isShow, isAction, keyIdx, uiIdx )
	local keyString = ""	-- keyCustom_GetString_ActionKey( keyIdx )
	if isAction then
		keyString = actionString[keyIdx]
	else
		keyString = uiString[keyIdx]
	end

	local control	= keyMatching[uiIdx].ui
	if isShow then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, keyString, nil )
	else
		TooltipSimple_Hide()
	end
end

function HandleClicked_NewShortCutPushed( virtualKeyCode )	-- 키보드를 눌렀다.
	if -1 ~= newShortCut.config.tempKey then

		local doSetKey = function()
			_NewShortCutPushed( virtualKeyCode )
		end

		local pressedKeyString = keyString[virtualKeyCode]

		local targetKeyString = ""
		if newShortCut.config.tempType then
			targetKeyString = actionString[newShortCut.config.tempKey]
		else
			targetKeyString = uiString[newShortCut.config.tempKey]
		end

		local	messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_SURETHISKEY", "press", pressedKeyString, "string", targetKeyString ) -- "[" .. pressedKeyString .. "]키에 [" .. targetKeyString .. "] 액션을 설정하시겠습니까?"

		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = doSetKey, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
end

function HandleClicked_NewShortCut_Unset()	-- 단축키를 지워버린다.
	local string = ""
	if true == newShortCut.config.tempType then
		string = actionString[newShortCut.config.tempKey]
	else
		string = uiString[newShortCut.config.tempKey]
	end

	local doUnSet = function()
		if true == newShortCut.config.tempType then
			keyCustom_clearActionVirtualKeyCode( newShortCut.config.tempKey )
		else
			keyCustom_clearUIVirtualKeyCode( newShortCut.config.tempKey )
		end
		Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_DELETEKEY", "key", string ) ) -- "[" .. string .. "]키의 단축키가 삭제됐습니다.")
		newShortCut:Close()
	end

	local	messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SETSHORTCUT_SUREDELETEKEY", "key", string )	-- "[" .. string .. "]키에 정의된 단축키를 삭제하시겠습니까?"
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = doUnSet, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
end

function _NewShortCutPushed( virtualKeyCode )
	if true == newShortCut.config.tempType then
		keyCustom_CheckAndSet_ActionKeyUseVirtualKeyCode( newShortCut.config.tempKey, virtualKeyCode )
	else
		keyCustom_CheckAndSet_UiKeyUseVirtualKeyCode( newShortCut.config.tempKey, virtualKeyCode )
	end
	keyCustom_applyChange()	-- 클라에 저장 요청

	newShortCut:Update()
	FGlobal_NewQuickSlot_Update()	-- 퀵슬롯 키스트링 업데이트를 위해.

	Proc_ShowMessage_Ack( PAGetString ( Defines.StringSheet_GAME, "LUA_SETSHORTCUT_COMPLETESETKEY") ) -- "퀵슬롯 단축키 설정이 완료됐습니다."
	newShortCut.config.tempKey = -1

	-- if 0 < newShortCut.config.noneSetImportantCount then
	-- 	Proc_ShowMessage_Ack( "필수 단축키 설정이 필요합니다. " )
	-- 	newShortCut.ui.guideMsg:SetText( "창 아래 필수 키를 설정해주세요." )
	-- else
		newShortCut:Close()
	-- end
end

function newShortCut_NoneSetScroll( isScrollUp )
	newShortCut.config.noneSetStartIdx = UIScroll.ScrollEvent( newShortCut.ui.noneSetKeyScroll, isScrollUp, newShortCut.config.noneSetUiCount/2, newShortCut.config.noneSetCount, newShortCut.config.noneSetStartIdx, 2 )
	newShortCut:UpdateNoneSetKey()
end

function newShortCut:registEventHandler()
	for key, value in pairs( keyMatching ) do
		if value.isEnable then
			value.ui:addInputEvent( "Mouse_LUp", "HandleClicked_NewShortCutPushed( " .. key .. " )" )
		end
	end
	
	self.ui.noneSetKeyBG	:addInputEvent( "Mouse_UpScroll",	"newShortCut_NoneSetScroll( true )")
	self.ui.noneSetKeyBG	:addInputEvent( "Mouse_DownScroll", "newShortCut_NoneSetScroll( false )")
	self.ui.btn_UnSet		:addInputEvent( "Mouse_LUp",		"HandleClicked_NewShortCut_Unset()" )
	self.ui.btn_Close		:addInputEvent( "Mouse_LUp",		"HandleClicked_NewShortCut_Close()" )
	if isGameTypeEnglish() then
		self.ui.btn_Question	:addInputEvent( "Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"QuickSlot\" )" )
	end
end


newShortCut:Init()
newShortCut:registEventHandler()
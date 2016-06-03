local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode
local UI_color 		= Defines.Color
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM			= CppEnums.TextMode
local UCT 			= CppEnums.PA_UI_CONTROL_TYPE
local UI_RewardType	= CppEnums.RewardType

Panel_Window_Challenge:SetShow( false )

local	shortClearCount			=	UI.getChildControl( Panel_Window_Challenge, "StaticText_ShortClearCount_Value" )	-- 단기 과제 클리어 횟수
local	dailyChallengeValue		=	UI.getChildControl( Panel_Window_Challenge, "StaticText_DailyChallenge_Value" )		-- 일일 과제
local	clearCount				=	UI.getChildControl( Panel_Window_Challenge, "StaticText_ClearCountValue" )			-- 완료 과제
local	remainRewardCountValue	=	UI.getChildControl( Panel_Window_Challenge, "StaticText_RemailRewardCount" )		-- 남은 도전과제 보상 수
local	btnRewardShow			=	UI.getChildControl( Panel_Window_Challenge, "Button_ChallengeReward_Show" )			-- 보상 받기 창 오픈 버튼

local	contentBody				=	UI.getChildControl( Panel_Window_Challenge, "Static_CallengeBodyBG" )
local	contentBG				=	UI.getChildControl( Panel_Window_Challenge, "Static_ChallengeContent_BG" )
local	contentTitle			=	UI.getChildControl( Panel_Window_Challenge, "StaticText_ChallengeContent_Title" )
local	contentDesc				=	UI.getChildControl( Panel_Window_Challenge, "StaticText_ChallengeContent_Desc" )
local	contentIcon				=	UI.getChildControl( Panel_Window_Challenge, "Static_ChallengeContent_Icon" )
local	contentComplete			=	UI.getChildControl( Panel_Window_Challenge, "Static_ChallengeCompleteIcon" )

-- 보상 슬롯 전용
local	normalText				=	UI.getChildControl( Panel_Window_Challenge, "StaticText_NormalReward" )
local	selectText				=	UI.getChildControl( Panel_Window_Challenge, "StaticText_SelectReward" )
local	rewardBG				=	UI.getChildControl( Panel_Window_Challenge, "Static_RewardBG" )
local	itemSlotBG0				=	UI.getChildControl( Panel_Window_Challenge, "Static_ResultSlot0" )
local	itemSlotBG1				=	UI.getChildControl( Panel_Window_Challenge, "Static_ResultSlot1" )
local	itemSlotBG2				=	UI.getChildControl( Panel_Window_Challenge, "Static_ResultSlot2" )
local	itemSlotBG3				=	UI.getChildControl( Panel_Window_Challenge, "Static_ResultSlot3" )

local	itemIcon0				=	UI.getChildControl( Panel_Window_Challenge, "Static_SlotIcon0" )
local	itemIcon1				=	UI.getChildControl( Panel_Window_Challenge, "Static_SlotIcon1" )
local	itemIcon2				=	UI.getChildControl( Panel_Window_Challenge, "Static_SlotIcon2" )
local	itemIcon3				=	UI.getChildControl( Panel_Window_Challenge, "Static_SlotIcon3" )
--
local	selectSlotBG0			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectSlot0" )
local	selectSlotBG1			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectSlot1" )
local	selectSlotBG2			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectSlot2" )
local	selectSlotBG3			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectSlot3" )
local	selectSlotBG4			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectSlot4" )
local	selectSlotBG5			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectSlot5" )

local	selectSlotBGCover		=	UI.getChildControl( Panel_Window_Challenge, "Template_Static_SlotSelectBG" )

local	selectItemIcon0			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectItemIcon0" )
local	selectItemIcon1			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectItemIcon1" )
local	selectItemIcon2			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectItemIcon2" )
local	selectItemIcon3			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectItemIcon3" )
local	selectItemIcon4			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectItemIcon4" )
local	selectItemIcon5			=	UI.getChildControl( Panel_Window_Challenge, "Static_SelectItemIcon5" )

local	explainBG				=	UI.getChildControl( Panel_Window_Challenge, "Static_ChallengeExplainBG" )
-- local	explainTxt				=	UI.getChildControl( Panel_Window_Challenge, "StaticText_ChallengeExplain" )

local	_scroll					=	UI.getChildControl( Panel_Window_Challenge,	"VerticalScroll" )
local	_scrollCtrlBtn			=	UI.getChildControl( _scroll,				"VerticalScroll_CtrlButton" )
local	_scrollIndex			=	0

local	isInit					=	true
local	currentRewardCount		=	0

local	expTooltipBase 				= UI.getChildControl ( Panel_CheckedQuest, 		"StaticText_Notice_2")
local	expTooltip					= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_Challenge, "expTooltip" )
CopyBaseProperty( expTooltipBase, expTooltip )
expTooltip:SetColor( ffffffff )
expTooltip:SetAlpha( 1.0 )
expTooltip:SetFontColor( UI_color.C_FFFFFFFF )
expTooltip:SetAutoResize( true )
expTooltip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
expTooltip:SetTextHorizonCenter()
expTooltip:SetShow( false )


Panel_ChallengeReward_Alert:SetShow( false )
-- local challengeRewardAlert_icon = UI.getChildControl( Panel_ChallengeReward_Alert,	"Static_Icon" )
-- challengeRewardAlert_icon:addInputEvent("Mouse_LUp", "HandleClicked_challengeRewardAlert_Open()")

function HandleClicked_challengeRewardAlert_Open()
	CharacterInfoWindow_Show()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
end



-- 탭 메뉴 생성
local	tapCount		=	5			-- 탭 개수
if isGameTypeKorea() then
	tapCount = 5
elseif isGameTypeRussia() then
	tapCount = 4
elseif isGameTypeEnglish() then
	tapCount = 4
elseif isGameTypeJapan() then
	tapCount = 5
else
	tapCount = 5
end
local	tapMenu			=
{
	[0]	=	PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_SHORT"),
	[1]	=	PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_DAILY"),
	[2]	=	PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_COMPLETE"),
	[3]	=	PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_EVENT"),
	[4]	=	PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_PCROOM"),
}

local tabTexture = {
	[0] =  {	-- 단기
		[0] = { 211, 5, 311, 40 },
		[1] = { 211, 43, 311, 78 },
		[2] = { 211, 81, 311, 116 },
	},
	[1] =  {	-- 일일
		[0] = { 211, 119, 311, 154 },
		[1] = { 211, 157, 311, 192 },
		[2] = { 211, 195, 311, 230 },
	},
	[2] =  {	-- 완료
		[0] = { 211, 233, 311, 268 },
		[1] = { 211, 271, 311, 306 },
		[2] = { 211, 309, 311, 344 },
	},
	[3] =  {	-- 이벤트
		[0] = { 211, 5, 311, 40 },
		[1] = { 211, 43, 311, 78 },
		[2] = { 211, 81, 311, 116 },
	},
	[4] =  {	-- PC방
		[0] = { 5, 182, 105, 217 },
		[1] = { 108, 182, 208, 217 },
		[2] = { 211, 346, 311, 381 },
	},
}

local	_tapMenu		=	{}
local	_tapIcon		=	{}
local	_tapValue		=	0
local	_menuTextspan	=	7

local	_selectedReward_ChallengeIndex	= nil		-- 완료된 선택 보상 저장용.
local	_selectedReward_SlotIndex		= nil		-- 완료된 선택 보상 저장용.

local	radioBtn_TapMenu	=	UI.getChildControl( Panel_Window_Challenge, "RadioButton_Tap" )
local	tapPosX			=	radioBtn_TapMenu:GetPosX()
local	tapSizeX		=	radioBtn_TapMenu:GetSizeX()
function	Challenge_TapMenu_Create()
	for index = 0, tapCount -1 do					
		_tapMenu[index]	=	{}
		_tapMenu[index]	=	UI.createControl( UCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Window_Challenge, "Challenge_Tapmenu_" .. index )
		CopyBaseProperty( radioBtn_TapMenu,	_tapMenu[index] )
		_tapMenu[index]	:	addInputEvent( "Mouse_LUp", "HandleClickedTapButton(".. index .. ")" )
		_tapMenu[index]	:	SetText( tapMenu[index] )
		_tapMenu[index]	:	SetTextSpan( _tapMenu[index]:GetSizeX()/2 - _tapMenu[index]:GetTextSizeX()/2 + _menuTextspan )
		_tapMenu[index]	:	SetShow( true )
		_tapMenu[index]	:	SetPosX( tapPosX + (tapSizeX - 4) * index )
		
		local texturePath = "new_ui_common_forlua/window/itemmarket/itemmarket_00.dds"

		_tapMenu[index]:ChangeTextureInfoName( texturePath )
		local x1, y1, x2, y2 = setTextureUV_Func( _tapMenu[index], tabTexture[index][0][1], tabTexture[index][0][2], tabTexture[index][0][3], tabTexture[index][0][4] )
		_tapMenu[index]:getBaseTexture():setUV( x1, y1, x2, y2 )
		
		_tapMenu[index]:ChangeOnTextureInfoName ( texturePath )
		local x1, y1, x2, y2 = setTextureUV_Func( _tapMenu[index], tabTexture[index][1][1], tabTexture[index][1][2], tabTexture[index][1][3], tabTexture[index][1][4] )
		_tapMenu[index]:getOnTexture():setUV(  x1, y1, x2, y2  )
		
		_tapMenu[index]:ChangeClickTextureInfoName ( texturePath )
		local x1, y1, x2, y2 = setTextureUV_Func( _tapMenu[index], tabTexture[index][2][1], tabTexture[index][2][2], tabTexture[index][2][3], tabTexture[index][2][4] )
		_tapMenu[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

		_tapMenu[index]:setRenderTexture(_tapMenu[index]:getBaseTexture())
		
	end
end

function FGlobal_TapButton_Complete()
	HandleClickedTapButton(2)
end

function	HandleClickedTapButton( index )
	for i = 0, tapCount-1 do
		_tapMenu[i]:SetCheck( false )
	end
	_tapValue	=	index
	_tapMenu[index]		:	SetCheck( true )
	_scroll:SetControlPos(0)
	_scrollIndex = 0
	Fglobal_Challenge_UpdateData()
end

local	_content			=	{}
local	_baseReward			=	{}
local	_selectReward		=	{}
local	sizeY				=	contentBG:GetSizeY() + 7
local	controlCount		=	4				-- 한 화면에 보여지는 컨트롤 수
function	Challenge_Initialize()

	-- 컨트롤 리셋
	-- contentBody:DestroyAllChild()
	
	for index = 0, controlCount -1 do
		_content[index]					=	{}
		_content[index].BG				=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,		contentBody,			"Challenge_content_BG_" .. index )
		_content[index].Title			=	UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	_content[index].BG,		"Challenge_content_Title_" .. index )
		_content[index].Desc			=	UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	_content[index].BG,		"Challenge_content_Desc_" .. index )

		_content[index].Icon			=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,		_content[index].BG,		"Challenge_content_Icon_" .. index )
		_content[index].btnGetReward	=	UI.createControl( UCT.PA_UI_CONTROL_BUTTON,		_content[index].BG,		"Challenge_content_btnGetReward_" .. index )
		
		_content[index].normalText		=	UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	_content[index].BG,	"StaticText_NormalReward_" .. index )
		_content[index].selectText		=	UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	_content[index].BG,	"StaticText_SelectReward_" .. index )
		_content[index].rewardBG		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_RewardBG_" .. index )
		_content[index].itemSlotBG0		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_ResultSlot0_" .. index )
		_content[index].itemSlotBG1		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_ResultSlot1_" .. index )
		_content[index].itemSlotBG2		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_ResultSlot2_" .. index )
		_content[index].itemSlotBG3		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_ResultSlot3_" .. index )
		
		_content[index].itemIcon0		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_ItemIcon0_" .. index )
		_content[index].itemIcon1		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_ItemIcon1_" .. index )
		_content[index].itemIcon2		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_ItemIcon2_" .. index )
		_content[index].itemIcon3		=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_ItemIcon3_" .. index )
		
		_content[index].selectSlotBG0	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectSlot0_" .. index )
		_content[index].selectSlotBG1	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectSlot1_" .. index )
		_content[index].selectSlotBG2	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectSlot2_" .. index )
		_content[index].selectSlotBG3	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectSlot3_" .. index )
		_content[index].selectSlotBG4	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectSlot4_" .. index )
		_content[index].selectSlotBG5	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectSlot5_" .. index )
	
		_content[index].selectItemIcon0	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectItemIcon0_" .. index )
		_content[index].selectItemIcon1	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectItemIcon1_" .. index )
		_content[index].selectItemIcon2	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectItemIcon2_" .. index )
		_content[index].selectItemIcon3	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectItemIcon3_" .. index )
		_content[index].selectItemIcon4	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectItemIcon4_" .. index )
		_content[index].selectItemIcon5	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,	_content[index].BG,		"Challenge_Static_SelectItemIcon5_" .. index )

		_content[index].contentComplete	=	UI.createControl( UCT.PA_UI_CONTROL_STATIC,		_content[index].BG,		"Challenge_content_Complete_" .. index )

		
		CopyBaseProperty( contentBG,		_content[index].BG )
		CopyBaseProperty( contentTitle,		_content[index].Title )
		CopyBaseProperty( contentDesc,		_content[index].Desc )
		CopyBaseProperty( contentIcon,		_content[index].Icon )

		CopyBaseProperty( btnRewardShow,	_content[index].btnGetReward )
		CopyBaseProperty( normalText,		_content[index].normalText )
		CopyBaseProperty( selectText,		_content[index].selectText )
		CopyBaseProperty( rewardBG,			_content[index].rewardBG )
		CopyBaseProperty( itemSlotBG0,		_content[index].itemSlotBG0 )
		CopyBaseProperty( itemSlotBG1,		_content[index].itemSlotBG1 )
		CopyBaseProperty( itemSlotBG2,		_content[index].itemSlotBG2 )
		CopyBaseProperty( itemSlotBG3,		_content[index].itemSlotBG3 )
		
		CopyBaseProperty( itemIcon0,		_content[index].itemIcon0 )
		CopyBaseProperty( itemIcon1,		_content[index].itemIcon1 )
		CopyBaseProperty( itemIcon2,		_content[index].itemIcon2 )
		CopyBaseProperty( itemIcon3,		_content[index].itemIcon3 )
		
		CopyBaseProperty( selectSlotBG0,	_content[index].selectSlotBG0 )
		CopyBaseProperty( selectSlotBG1,	_content[index].selectSlotBG1 )
		CopyBaseProperty( selectSlotBG2,	_content[index].selectSlotBG2 )
		CopyBaseProperty( selectSlotBG3,	_content[index].selectSlotBG3 )
		CopyBaseProperty( selectSlotBG4,	_content[index].selectSlotBG4 )
		CopyBaseProperty( selectSlotBG5,	_content[index].selectSlotBG5 )
		
		CopyBaseProperty( selectItemIcon0,	_content[index].selectItemIcon0 )
		CopyBaseProperty( selectItemIcon1,	_content[index].selectItemIcon1 )
		CopyBaseProperty( selectItemIcon2,	_content[index].selectItemIcon2 )
		CopyBaseProperty( selectItemIcon3,	_content[index].selectItemIcon3 )
		CopyBaseProperty( selectItemIcon4,	_content[index].selectItemIcon4 )
		CopyBaseProperty( selectItemIcon5,	_content[index].selectItemIcon5 )

		CopyBaseProperty( contentComplete,	_content[index].contentComplete )
		
		_content[index].BG				:	SetShow( false )
		_content[index].Title			:	SetShow( false )
		_content[index].Desc			:	SetShow( false )

		_content[index].Icon			:	SetShow( false )
		_content[index].contentComplete	:	SetShow( false )
		_content[index].btnGetReward	:	SetShow( false )
		_content[index].btnGetReward	:	SetAutoDisableTime(0.5)
		_content[index].normalText		:	SetShow( false )
		_content[index].selectText		:	SetShow( false )
		_content[index].rewardBG		:	SetShow( false )
		_content[index].itemSlotBG0		:	SetShow( false )
		_content[index].itemSlotBG1		:	SetShow( false )
		_content[index].itemSlotBG2		:	SetShow( false )
		_content[index].itemSlotBG3		:	SetShow( false )
		
		_content[index].itemIcon0		:	SetShow( false )
		_content[index].itemIcon1		:	SetShow( false )
		_content[index].itemIcon2		:	SetShow( false )
		_content[index].itemIcon3		:	SetShow( false )
		
		_content[index].selectSlotBG0		:	SetShow( false )
		_content[index].selectSlotBG1		:	SetShow( false )
		_content[index].selectSlotBG2		:	SetShow( false )
		_content[index].selectSlotBG3		:	SetShow( false )
		_content[index].selectSlotBG4		:	SetShow( false )
		_content[index].selectSlotBG5		:	SetShow( false )
		
		_content[index].selectItemIcon0		:	SetShow( false )
		_content[index].selectItemIcon1		:	SetShow( false )
		_content[index].selectItemIcon2		:	SetShow( false )
		_content[index].selectItemIcon3		:	SetShow( false )
		_content[index].selectItemIcon4		:	SetShow( false )
		_content[index].selectItemIcon5		:	SetShow( false )

		if ( 0 == index ) then
			_content[index].BG		:	SetPosY ( 7 )
		else
			_content[index].BG		:	SetPosY ( _content[index -1].BG:GetPosY() + sizeY )
		end
		
		_content[index].Icon			:	SetPosY( 0 )
		_content[index].contentComplete	:	SetPosY( 5 )

		_content[index].btnGetReward	:	SetPosX( 350 )
		_content[index].btnGetReward	:	SetPosY( 2 )
		
		_baseReward[index] = {}
		_baseReward[index][0] = _content[index].itemIcon0
		_baseReward[index][1] = _content[index].itemIcon1
		_baseReward[index][2] = _content[index].itemIcon2
		_baseReward[index][3] = _content[index].itemIcon3
		
		_selectReward[index] = {}
		_selectReward[index][0] = _content[index].selectItemIcon0
		_selectReward[index][1] = _content[index].selectItemIcon1
		_selectReward[index][2] = _content[index].selectItemIcon2
		_selectReward[index][3] = _content[index].selectItemIcon3
		_selectReward[index][4] = _content[index].selectItemIcon4
		_selectReward[index][5] = _content[index].selectItemIcon5
		
		-- _content[index].itemSlotBG0		:	SetPosY( 5 )
		-- _content[index].itemSlotBG1		:	SetPosY( 5 )
		-- _content[index].itemSlotBG2		:	SetPosY( 5 )
		Challenge_SlotSetting( index )

		explainBG:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHALLENGE_EXPLAIN") )
		explainBG:SetTextMode( UI_TM.eTextMode_LimitText )

		_content[index].BG			:	addInputEvent( "Mouse_UpScroll",	"Challenge_Scroll( true )"	)
		_content[index].BG			:	addInputEvent( "Mouse_DownScroll",	"Challenge_Scroll( false )"	)
	end
end

local _maxBaseSlotCount = 4
local _maxSelectSlotCount = 6
local _uiBackBaseReward = {}
local _listBaseRewardSlots = {}
local _uiButtonSelectRewardSlots = {}
local _listSelectRewardSlots = {}
local _challengerewardSlotConfig =
{
	createIcon	= true,
	createBorder= true,
	createCount	= true,
	createClassEquipBG = true,
	createCash	= true,
}
local baseRewardPosY = 0
function Challenge_SlotSetting( index )
	_uiBackBaseReward[index] = {}
	_listBaseRewardSlots[index] = {}

	-- 기본 보상 ( 슬롯 세팅 )
	for ii = 0, _maxBaseSlotCount-1, 1 do
		_baseReward[index][ii]:SetIgnore(true)
		_uiBackBaseReward[index][ii] = _baseReward[index][ii]

		local slot = {}
		SlotItem.new( slot, 'BaseReward_' .. ii, ii, _baseReward[index][ii], _challengerewardSlotConfig )
		slot:createChild()
		slot.icon:SetSize( 42, 42 )
		slot.icon:SetPosX(0)
		slot.icon:SetPosY(0)
		slot.border:SetSize( 42, 42 )
		slot.border:SetPosX(1)
		slot.border:SetPosY(1)
		_listBaseRewardSlots[index][ii] = slot
		-- Panel_Tooltip_Item_SetPosition( ii, slot, "Dialog_ChallengeReward_Base" )
	end
	

	_uiButtonSelectRewardSlots[index] = {}
	_listSelectRewardSlots[index] = {}
	-- 선택 보상 ( 슬롯 세팅 )
	for jj = 0, _maxSelectSlotCount-1, 1 do
		_uiButtonSelectRewardSlots[index][jj] = _selectReward[index][jj]
	
		local slot = {}
		SlotItem.new( slot, 'SelectReward_' .. jj, jj, _selectReward[index][jj], _challengerewardSlotConfig )
		slot:createChild()
		slot.icon:SetPosX(0)
		slot.icon:SetPosY(0)
		slot.icon:SetSize( 30, 30 )
		slot.icon:SetIgnore(false)
		slot.border:SetSize( 30, 30 )
		slot.count: SetPosX(-10)
		slot.count: SetPosY(8)
		slot.classEquipBG:SetHorizonRight()
		slot.classEquipBG:SetVerticalBottom()
		slot.classEquipBG:SetSpanSize(2,2)

		slot.selectedSatic = UI.createControl( UCT.PA_UI_CONTROL_STATIC, _selectReward[index][jj], "Challenge_Static_SelectedSlot_" .. index .."_" .. jj )
		CopyBaseProperty( selectSlotBGCover, slot.selectedSatic )
		slot.selectedSatic:SetPosX( -2 )
		slot.selectedSatic:SetPosY( -2 )
		slot.selectedSatic:SetSize( 32, 32 )
		slot.selectedSatic:SetShow( false )
		slot.selectedSatic:SetIgnore( true )
	
		_listSelectRewardSlots[index][jj] = slot
	
		-- Panel_Tooltip_Item_SetPosition( jj, slot, "Dialog_ChallengeReward_Select" )
	end
end

function Challenge_clearRewardSlot( index )
	-- 기본 보상 ( 슬롯 세팅 )
	for ii = 0, _maxBaseSlotCount-1, 1 do
		local slot = _listBaseRewardSlots[index][ii]
		slot:clearItem()
		slot.icon:addInputEvent("Mouse_On", "")
		slot.icon:addInputEvent("Mouse_Out", "")
	end

	for jj = 0, _maxSelectSlotCount-1, 1 do
		local slot = _listSelectRewardSlots[index][jj]
		slot:clearItem()
		slot.icon:addInputEvent("Mouse_On", "")
		slot.icon:addInputEvent("Mouse_Out", "")
	end
end

function Challenge_clearSlot( list_Idx )
	_content[list_Idx].BG				:SetShow( false )
	_content[list_Idx].btnGetReward		:SetShow( false )
end

local	controlValueCount			=	0										-- 진행 중인 과제 수
local	_count						=	0

local	specialRewardWrapper		=	{}
local	normalRewardWrapper			=	{}

local challengeType = 0

local challengeWrapper = nil
local baseCount = 0

function	Fglobal_Challenge_UpdateData()
	-- if not Panel_Window_CharInfo_Status:GetShow() then
	-- 	return
	-- end

	_selectedReward_ChallengeIndex		= nil
	_selectedReward_SlotIndex			= nil
	-- Challenge_Initialize()
	_tapMenu[_tapValue]			:	SetCheck( true )
	local totalCompleteCount 	= ToClient_GetCompletedChallengeCount()
	local totalProgressCount 	= ToClient_GetProgressChallengeCount( 1 ) + ToClient_GetProgressChallengeCount( 2 ) + ToClient_GetProgressChallengeCount( 3 )
	clearCount					:	SetText( totalCompleteCount .. " / " .. totalCompleteCount + totalProgressCount )			-- 완료된 과제

	shortClearCount			:	SetText( "" )				-- 단기 과제 완료수(안씀?)
	dailyChallengeValue		:	SetText( "" )				-- 일일 과제(안씀?)


	-- 획득할 수 있는 보상이 남아 있으면 버튼 활성화
	local	remainRewardCount	=	ToClient_GetChallengeRewardInfoCount()		-- 아직 받지 않은 보상 수
	if ( remainRewardCount <= 0 ) then
		remainRewardCountValue		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARDCOUNTVALUE_EMPTY") )
		remainRewardCountValue		:SetFontColor( UI_color.C_FF888888 )
		Panel_ChallengeReward_Alert	:SetShow( false )
	else
		remainRewardCountValue		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARDCOUNTVALUE_HAVE", "remainRewardCount", remainRewardCount ) )
		remainRewardCountValue		:SetFontColor( UI_color.C_FFFFFFFF )
		if (7 == getGameServiceType() or 8 == getGameServiceType()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT then
			Panel_ChallengeReward_Alert	:SetShow( false )
		else
			Panel_ChallengeReward_Alert	:SetShow( true )
		end
	end


	-- 초기화
	local viewCount = 4

	for list_Idx = 0, viewCount - 1 do
		_content[list_Idx].itemSlotBG0		:SetShow( false )
		_content[list_Idx].itemSlotBG1		:SetShow( false )
		_content[list_Idx].itemSlotBG2		:SetShow( false )
		_content[list_Idx].selectSlotBG0	:SetShow( false )
		_content[list_Idx].selectSlotBG1	:SetShow( false )
		_content[list_Idx].selectSlotBG2	:SetShow( false )
		_content[list_Idx].selectSlotBG3	:SetShow( false )
		_content[list_Idx].selectSlotBG4	:SetShow( false )
		_content[list_Idx].selectSlotBG5	:SetShow( false )
		_baseReward[list_Idx][0]			:SetShow( false )
		_baseReward[list_Idx][1]			:SetShow( false )
		_baseReward[list_Idx][2]			:SetShow( false )
		_selectReward[list_Idx][0]			:SetShow( false )
		_selectReward[list_Idx][1]			:SetShow( false )
		_selectReward[list_Idx][2]			:SetShow( false )
		_selectReward[list_Idx][3]			:SetShow( false )
		_selectReward[list_Idx][4]			:SetShow( false )
		_selectReward[list_Idx][5]			:SetShow( false )
		_content[list_Idx].BG				:SetShow( false )
		_content[list_Idx].Title			:SetShow( false )
		_content[list_Idx].Desc				:SetShow( false )
		_content[list_Idx].Icon				:SetShow( false )
		_content[list_Idx].normalText		:SetShow( false )
		_content[list_Idx].selectText		:SetShow( false )
		_content[list_Idx].rewardBG			:SetShow( false )
		_content[list_Idx].contentComplete	:SetShow( false )
	end

	for list_Idx = 0, viewCount - 1 do
		Challenge_clearRewardSlot( list_Idx )
		Challenge_clearSlot( list_Idx )
		if(0 == _tapValue) then
			challengeType = 1
		elseif(1 == _tapValue) then
			challengeType = 2
		elseif(3 == _tapValue) then
			challengeType = 3
		elseif(4 == _tapValue) then
			challengeType = 4
		end

		if 2 == _tapValue then
			challengeWrapper	= ToClient_GetCompletedChallengeAt( list_Idx + _scrollIndex )
			if nil ~= challengeWrapper then
				baseCount		 	= challengeWrapper:getBaseRewardCount()
			end
		else
			challengeWrapper	= ToClient_GetProgressChallengeAt( challengeType, list_Idx + _scrollIndex )
			if nil ~= challengeWrapper then
				baseCount			= challengeWrapper:getBaseRewardCount()
			end
		end

		if (3 < baseCount) then
			-- 보상이 3보다 많을 때
			_content[list_Idx].itemSlotBG3		:SetShow( true )
			_baseReward[list_Idx][3]			:SetShow( true )
			_content[list_Idx].itemSlotBG0		:SetSpanSize( 155, 8 )
			_content[list_Idx].itemSlotBG1		:SetSpanSize( 105, 8 )
			_content[list_Idx].itemSlotBG2		:SetSpanSize( 55, 8 )
			_content[list_Idx].itemSlotBG3		:SetSpanSize( 5, 8 )
			_baseReward[list_Idx][0]			:SetSpanSize( 155, 8 )
			_baseReward[list_Idx][1]			:SetSpanSize( 105, 8 )
			_baseReward[list_Idx][2]			:SetSpanSize( 55, 8 )
			_baseReward[list_Idx][3]			:SetSpanSize( 5, 8 )
		else
			_content[list_Idx].itemSlotBG3		:SetShow( false )
			_baseReward[list_Idx][3]			:SetShow( false )
			_content[list_Idx].itemSlotBG0		:SetSpanSize( 125, 8 )
			_content[list_Idx].itemSlotBG1		:SetSpanSize( 75, 8 )
			_content[list_Idx].itemSlotBG2		:SetSpanSize( 25, 8 )
			_content[list_Idx].itemSlotBG3		:SetSpanSize( -25, 8 )
			_baseReward[list_Idx][0]			:SetSpanSize( 125, 8 )
			_baseReward[list_Idx][1]			:SetSpanSize( 75, 8 )
			_baseReward[list_Idx][2]			:SetSpanSize( 25, 8 )
			_baseReward[list_Idx][3]			:SetSpanSize( -25, 8 )
		end

		_content[list_Idx].itemSlotBG0		:SetShow( true )
		_content[list_Idx].itemSlotBG1		:SetShow( true )
		_content[list_Idx].itemSlotBG2		:SetShow( true )
		_content[list_Idx].selectSlotBG0	:SetShow( true )
		_content[list_Idx].selectSlotBG1	:SetShow( true )
		_content[list_Idx].selectSlotBG2	:SetShow( true )
		_content[list_Idx].selectSlotBG3	:SetShow( true )
		_content[list_Idx].selectSlotBG4	:SetShow( true )
		_content[list_Idx].selectSlotBG5	:SetShow( true )
		_baseReward[list_Idx][0]			:SetShow( true )
		_baseReward[list_Idx][1]			:SetShow( true )
		_baseReward[list_Idx][2]			:SetShow( true )
		_selectReward[list_Idx][0]			:SetShow( true )
		_selectReward[list_Idx][1]			:SetShow( true )
		_selectReward[list_Idx][2]			:SetShow( true )
		_selectReward[list_Idx][3]			:SetShow( true )
		_selectReward[list_Idx][4]			:SetShow( true )
		_selectReward[list_Idx][5]			:SetShow( true )
		
		_content[list_Idx].BG		:ChangeTextureInfoName( "new_ui_common_forlua/default/default_etc_01.dds" )
		local x1, y1, x2, y2		=	setTextureUV_Func( _content[list_Idx].BG, 206, 1, 230, 25 )
		_content[list_Idx].BG		:getBaseTexture():setUV(  x1, y1, x2, y2  )
		_content[list_Idx].BG		:setRenderTexture(_content[list_Idx].BG:getBaseTexture())
		_content[list_Idx].BG		:SetIgnore( false )
	end

	for i = 0, tapCount -1 do
		if ( true == _tapMenu[i]	:IsChecked() ) then
			_tapMenu[i]				:SetFontColor( UI_color.C_FFFFFFFF )
		else
			_tapMenu[i]				:SetFontColor( UI_color.C_FF888888 )
		end
	end

	if( 2 ~= _tapValue ) then
		-- local challengeType = 0
		if(0 == _tapValue) then
			challengeType = 1
		elseif(1 == _tapValue) then
			challengeType = 2
		elseif(3 == _tapValue) then
			challengeType = 3
		elseif(4 == _tapValue) then
			challengeType = 4
		end
		
		controlValueCount	=	ToClient_GetProgressChallengeCount( challengeType )					-- 진행 중인 과제 수
		UIScroll.SetButtonSize( _scroll, controlCount, controlValueCount )
		if ( 0 < controlValueCount )	then
			if ( controlValueCount < controlCount ) then
				_count = controlValueCount
			else
				_count = controlCount
			end

			local uiIdx = 0
			for i = 0, _count -1 do
				local dataIdx		= i + _scrollIndex
				local progressInfo	=	ToClient_GetProgressChallengeAt( challengeType, dataIdx )
				-- local baseCount 	= progressInfo:getBaseRewardCount()

				-- if 3 < baseCount then
				-- 	-- _content[uiIdx].BG:SetSpanSize( 155, 8 )
				-- 	_content[0].Icon:SetSpanSize( 155, 8 )
				-- else
				-- 	_content[0].Icon:SetSpanSize( 125, 8 )
				-- end
				_content[uiIdx].Title		:SetText( progressInfo:getName() )
				_content[uiIdx].Desc		:SetTextMode( UI_TM.eTextMode_AutoWrap )
				_content[uiIdx].Desc		:SetText( progressInfo:getDesc() )
				_content[uiIdx].BG			:SetShow( true )
				_content[uiIdx].Title		:SetShow( true )
				_content[uiIdx].Desc		:SetShow( true )
				_content[uiIdx].Icon		:SetShow( true )
				_content[uiIdx].Icon		:ChangeTextureInfoName( "new_ui_common_forlua/window/itemmarket/itemmarket_00.dds" )
				local x1, y1, x2, y2	=	setTextureUV_Func( _content[uiIdx].Icon, 1, 386, 104, 481 )
				_content[uiIdx].Icon		:getBaseTexture():setUV(  x1, y1, x2, y2  )
				_content[uiIdx].Icon		:setRenderTexture(_content[uiIdx].Icon:getBaseTexture())
				_content[uiIdx].normalText	:SetShow( true )
				_content[uiIdx].selectText	:SetShow( true )
				_content[uiIdx].rewardBG	:SetShow( true )
					
				ChallengeReward_Update( progressInfo, dataIdx, uiIdx )
				_content[uiIdx].contentComplete	:SetShow( false )
				uiIdx = uiIdx + 1
			end
		end
	elseif ( 2 == _tapValue ) then			-- 완료 과제
		controlValueCount			=	totalCompleteCount					-- 완료한 과제 수
		UIScroll.SetButtonSize( _scroll, controlCount, controlValueCount )
		if ( 0 < controlValueCount ) then
			if ( controlValueCount < controlCount ) then
				_count = controlValueCount
			else
				_count = controlCount
			end
			local viewCount = 4
			for challenge_Idx = 0, controlValueCount - 1 do
				local	completeInfo	=	ToClient_GetCompletedChallengeAt( challenge_Idx + _scrollIndex )
				_content[challenge_Idx].Title		:	SetText( completeInfo:getName() )
				_content[challenge_Idx].Desc		:	SetTextMode( UI_TM.eTextMode_AutoWrap )
				_content[challenge_Idx].Desc		:	SetText( completeInfo:getDesc() )
				_content[challenge_Idx].BG			:	SetShow( true )
				_content[challenge_Idx].Title		:	SetShow( true )
				_content[challenge_Idx].Desc		:	SetShow( true )
				
				local existRewardCount = completeInfo:getExistRewardCount()
				if 0 < existRewardCount then
					-- 보상 받기 전..
					_content[challenge_Idx].contentComplete	:SetShow( false )
					_content[challenge_Idx].normalText		:SetShow( true )
					_content[challenge_Idx].selectText		:SetShow( true )
					_content[challenge_Idx].rewardBG		:SetShow( true )
					_content[challenge_Idx].btnGetReward	:SetShow( true )
					_content[challenge_Idx].btnGetReward	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHALLENGE_BTNGETREWARD", "existRewardCount", existRewardCount ) ) -- "보상 받기(" .. existRewardCount .. "개)" )
					_content[challenge_Idx].btnGetReward	:addInputEvent( "Mouse_LUp", "HandleClicked_Reward_Show( " .. challenge_Idx + _scrollIndex .. " )" )
					_content[challenge_Idx].BG				:SetIgnore( false )
				else	
					-- 보상을 받았다! 모든게 끝났어!
					_content[challenge_Idx].BG		:	ChangeTextureInfoName( "new_ui_common_forlua/default/default_etc_01.dds" )
					local x1, y1, x2, y2			=	setTextureUV_Func( _content[challenge_Idx].BG, 206, 26, 230, 50 )
					_content[challenge_Idx].BG		:	getBaseTexture():setUV(  x1, y1, x2, y2  )
					_content[challenge_Idx].BG		:	setRenderTexture(_content[challenge_Idx].BG:getBaseTexture())
					
					_content[challenge_Idx].btnGetReward	:	SetShow( false )
					_content[challenge_Idx].contentComplete	:	SetShow( true )
					_content[challenge_Idx].normalText		:	SetShow( false )
					_content[challenge_Idx].selectText		:	SetShow( false )
					_content[challenge_Idx].rewardBG		:	SetShow( true )
					_content[challenge_Idx].BG				:SetIgnore( true )
				end

				ChallengeReward_Update( completeInfo, challenge_Idx + _scrollIndex, challenge_Idx )
				if challenge_Idx == (viewCount - 1)  then
					return
				end
			end
		end
	end
end

function	HandleClicked_Challenge_ProgressReward( index )
	local progressInfo	=	ToClient_GetProgressChallengeAt( index )
	ChallengeReward_Update( progressInfo, index, index )
end

function	HandleClicked_Challenge_CompleteReward( completeInfo, index )
	local completeInfo	=	ToClient_GetCompletedChallengeAt( index )
	ChallengeReward_Update( completeInfo, index, index )
end

function	HandleClicked_Reward_Show( challenge_Idx )
	local selectedRewardSlotIndex	= _selectedReward_SlotIndex
	local challengeWrapper			= ToClient_GetCompletedChallengeAt( challenge_Idx )
	local selectRewardCount 		= challengeWrapper:getSelectRewardCount()

	if ( 0 ~= selectRewardCount and nil == selectedRewardSlotIndex ) then
		Proc_ShowMessage_Ack_WithOut_ChattingMessage( PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_YOUCANSELECTITEM") ) -- "보상을 선택해야 합니다.")
		return
	end
	
	if nil == challengeWrapper then
		Proc_ShowMessage_Ack_WithOut_ChattingMessage( PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGINFOCHALLENGE") ) -- "도전과제 정보가 올바르지 않습니다.")
		return
	end

	if (0 ~= selectRewardCount) and (selectRewardCount - 1) < selectedRewardSlotIndex then
		Proc_ShowMessage_Ack_WithOut_ChattingMessage( PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGSELECTVALUE") ) -- "선택 값이 올바르지 않습니다.")
		return
	end

	if 0 == selectRewardCount or nil == selectedRewardSlotIndex then
		selectedRewardSlotIndex = selectRewardCount
	end

	local challengeKey = challengeWrapper:getKey()
	ToClient_AcceptReward_ButtonClicked( challengeKey, selectedRewardSlotIndex )
end

-- 보상 정보를 받아와 보상창으로 넘겨준다.
function ChallengeReward_Update( challengeWrapper, challenge_Idx, uiIdx )
	if( nil == challengeWrapper ) then
		return
	end
	local baseCount 	= challengeWrapper:getBaseRewardCount()
	local _baseReward	= {}
	for idx = 1, baseCount do
		local baseReward = challengeWrapper:getBaseRewardAt( idx - 1 )
		_baseReward[idx] = {}
		_baseReward[idx]._type = baseReward._type
		if (CppEnums.RewardType.RewardType_Exp == baseReward._type) then
			_baseReward[idx]._exp = baseReward._experience
		elseif (CppEnums.RewardType.RewardType_SkillExp == baseReward._type) then
			_baseReward[idx]._exp = baseReward._skillExperience
		elseif (CppEnums.RewardType.RewardType_ProductExp == baseReward._type) then
			_baseReward[idx]._exp = baseReward._productExperience
		elseif (CppEnums.RewardType.RewardType_Item	 == baseReward._type) then
			_baseReward[idx]._item = baseReward:getItemEnchantKey()
			_baseReward[idx]._count = baseReward._itemCount
		elseif (CppEnums.RewardType.RewardType_Intimacy	 == baseReward._type) then
			_baseReward[idx]._character = baseReward:getIntimacyCharacter()
			_baseReward[idx]._value = baseReward._intimacyValue
		end
	end
		
	local selectCount 	= challengeWrapper:getSelectRewardCount()
	local _selectReward = {}
	
	if ( 0 < selectCount ) then
		for idx = 1, selectCount do
			local selectReward = challengeWrapper:getSelectRewardAt( idx - 1 )
			_selectReward[idx] = {}
			_selectReward[idx]._type = selectReward._type
			if (CppEnums.RewardType.RewardType_Exp == selectReward._type) then
				_selectReward[idx]._exp = selectReward._experience
			elseif (CppEnums.RewardType.RewardType_SkillExp == selectReward._type) then
				_selectReward[idx]._exp = selectReward._skillExperience
			elseif (CppEnums.RewardType.RewardType_ProductExp == selectReward._type) then
				_selectReward[idx]._exp = selectReward._productExperience
			elseif (CppEnums.RewardType.RewardType_Item	 == selectReward._type) then
				_selectReward[idx]._item = selectReward:getItemEnchantKey()
				_selectReward[idx]._count = selectReward._itemCount
				local selfPlayer = getSelfPlayer()
				if nil ~= selfPlayer then
					local classType = selfPlayer:getClassType() 
					_selectReward[idx]._isEquipable = selectReward:isEquipable(classType)
				end
			elseif (CppEnums.RewardType.RewardType_Intimacy	 == selectReward._type) then
				_selectReward[idx]._character = selectReward:getIntimacyCharacter()
				_selectReward[idx]._value = selectReward._intimacyValue
			end
		end
	end
	SetChallengeRewardList( _baseReward, _selectReward, challenge_Idx, uiIdx )
	--_PA_LOG("이문종", "도전과제 == " .. tostring(challengeWrapper:getName()))
	--_PA_LOG("이문종", "index == " .. index )
end


-- 보상 설정 ( 기본보상과 선택보상 )
function	SetChallengeRewardList( baseReward, selectReward, challenge_Idx, uiIdx )
	_baseRewardCount	= #baseReward
	for ii = 0, _maxBaseSlotCount-1, 1 do
		_uiBackBaseReward[uiIdx][ii]:EraseAllEffect()
		if ii < _baseRewardCount then
			setChallengeRewardShow( _listBaseRewardSlots[uiIdx][ii], baseReward[ii + 1], uiIdx, ii, "main" )
			_uiBackBaseReward[uiIdx][ii]:SetShow(true)
		else
			_uiBackBaseReward[uiIdx][ii]:SetShow(false)
		end
	end
	
	------------------------------------
	-- 	기본적으로 체크를 풀어준다!
	local	_selectRewardCount = #selectReward
	for ii = 0, _maxSelectSlotCount-1, 1 do
		if ii < _selectRewardCount then
			setChallengeRewardShow(	_listSelectRewardSlots[uiIdx][ii], selectReward[ii + 1], uiIdx, ii, "sub" )
			_uiButtonSelectRewardSlots[uiIdx][ii]:SetShow(true)
			_listSelectRewardSlots[uiIdx][ii].icon:addInputEvent("Mouse_LUp", "_challengeSelectReward_Set( " .. challenge_Idx .. ", " .. uiIdx .. ", " .. ii .. " )")
		else
			_uiButtonSelectRewardSlots[uiIdx][ii]:SetShow(false)
		end
	end
end

function _challengeSelectReward_Set( challenge_Idx, uiIdx, slot_Idx )
	_selectedReward_ChallengeIndex	= challenge_Idx
	_selectedReward_SlotIndex		= slot_Idx

	for ui_idx = 0, controlCount - 1 do
		for idx = 0, _maxSelectSlotCount - 1 do
			_listSelectRewardSlots[ui_idx][idx].selectedSatic:SetShow( false )
		end
	end
	_listSelectRewardSlots[uiIdx][slot_Idx].selectedSatic:SetShow( true )

	local challengeWrapper	= ToClient_GetCompletedChallengeAt( challenge_Idx )
	local selectRewardCount = challengeWrapper:getSelectRewardCount()
	if 0 == selectRewardCount then
		_selectedReward_SlotIndex = 0
	end
end

function ChallengeRewardTooltip( type, show, questtype, index, uiIdx )
	if true == show then
		if "Exp" == type then
			expTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP") )
		elseif "SkillExp" == type then
			expTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP") )
		elseif "ProductExp" == type then
			expTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP") )
		elseif "Intimacy" == type then
			expTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY") )
		end

		if "main" == questtype then
			expTooltip:SetPosX( _uiBackBaseReward[uiIdx][index]:GetPosX() - (expTooltip:GetSizeX()/2) )
			expTooltip:SetPosY( _uiBackBaseReward[uiIdx][index]:GetPosY() - expTooltip:GetSizeY() - 10 )
		else
			expTooltip:SetPosX( _uiButtonSelectRewardSlots[uiIdx][index]:GetPosX() - (expTooltip:GetSizeX()/2) )
			expTooltip:SetPosY( _uiButtonSelectRewardSlots[uiIdx][index]:GetPosY() - expTooltip:GetSizeY() )
		end
		registTooltipControl(expTooltip, Panel_CheckedQuest)
		expTooltip:SetShow( true )
	else
		expTooltip:SetShow( false )
	end
end

-- 보상 아이콘 설정 
function	setChallengeRewardShow( uiSlot, reward, uiIdx, index, questType )
	uiSlot._type = reward._type
	if	UI_RewardType.RewardType_Exp ==	reward._type then						-- 경험치			{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "ChallengeRewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "ChallengeRewardTooltip( \"Exp\", false, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )

		uiSlot.icon:setTooltipEventRegistFunc( "ChallengeRewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )
	elseif	UI_RewardType.RewardType_SkillExp == reward._type then				-- 스킬 경험치	{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "ChallengeRewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "ChallengeRewardTooltip( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )

		uiSlot.icon:setTooltipEventRegistFunc( "ChallengeRewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )
	elseif	UI_RewardType.RewardType_ProductExp == reward._type then			-- 생산 경험치	{type=%#, exp=%#}
		uiSlot.count:SetText( '' )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "ChallengeRewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "ChallengeRewardTooltip( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )

		uiSlot.icon:setTooltipEventRegistFunc( "ChallengeRewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )
	elseif	UI_RewardType.RewardType_Item == reward._type then				-- 아이템		{type=%#, item=%#, count=%#}
		local itemStatic = getItemEnchantStaticStatus( ItemEnchantKey(reward._item) );
		uiSlot:setItemByStaticStatus( itemStatic, reward._count );
		uiSlot._item = reward._item
		if "main" == questType then
			uiSlot.icon:addInputEvent( "Mouse_On", "Challenge_RewardTooltipShow( true, " .. uiIdx ..", " .. index .. ", \"" .. questType .."\" )" )
			uiSlot.icon:addInputEvent( "Mouse_Out", "Challenge_RewardTooltipShow( false, " .. uiIdx ..", " .. index .. ", \"" .. questType .."\" )" )

			uiSlot.icon:setTooltipEventRegistFunc( "Challenge_RewardTooltipShow( true, " .. uiIdx ..", " .. index .. ", \"" .. questType .."\" )" )
		else
			uiSlot.icon:addInputEvent( "Mouse_On", "Challenge_RewardTooltipShow( true, " .. uiIdx ..", " .. index .. ", \"" .. questType .."\" )" )
			uiSlot.icon:addInputEvent( "Mouse_Out", "Challenge_RewardTooltipShow( false, " .. uiIdx ..", " .. index .. ", \"" .. questType .."\" )" )

			uiSlot.icon:setTooltipEventRegistFunc( "Challenge_RewardTooltipShow( true, " .. uiIdx ..", " .. index .. ", \"" .. questType .."\" )" )
		end
		return reward._isEquipable
	elseif	UI_RewardType.RewardType_Intimacy == reward._type then				-- 친밀도		{type=%#, character=%#, value=%#}
		uiSlot.count:SetText( tostring(reward._value) )
		uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
		uiSlot.icon:addInputEvent( "Mouse_On", "ChallengeRewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "ChallengeRewardTooltip( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )

		uiSlot.icon:setTooltipEventRegistFunc( "ChallengeRewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. ", " .. uiIdx .. " )" )
	else
		uiSlot.icon:addInputEvent( "Mouse_On", "" )
		uiSlot.icon:addInputEvent( "Mouse_Out", "" )
	end
	return false;
end

function	Challenge_Scroll( isUp )
	_scrollIndex = UIScroll.ScrollEvent( _scroll, isUp, controlCount, controlValueCount, _scrollIndex, 1 )
	Fglobal_Challenge_UpdateData()
	
	for ui_idx = 0, controlCount - 1 do
		for idx = 0, _maxSelectSlotCount - 1 do
			_listSelectRewardSlots[ui_idx][idx].selectedSatic:SetShow( false )
		end
	end
end

UIScroll.InputEvent	(	_scroll, 	"Challenge_Scroll" )
contentBody			:	addInputEvent( "Mouse_UpScroll",	"Challenge_Scroll( true )"	)
contentBody			:	addInputEvent( "Mouse_DownScroll",	"Challenge_Scroll( false )"	)

--------------------------------------------------------------------------------

function Challenge_RewardTooltipShow( isShow, uiIdx, slotNo, rewardType )
	local passTooltipType	= nil
	local uiSlot			= nil
	if "main" == rewardType then
		passTooltipType = "Dialog_ChallengeReward_Base"
		uiSlot = _listBaseRewardSlots[uiIdx][slotNo]
	else
		passTooltipType = "Dialog_ChallengeReward_Select"
		uiSlot = _listSelectRewardSlots[uiIdx][slotNo]
	end

	Panel_Tooltip_Item_SetPosition( slotNo, uiSlot, passTooltipType )

	if true == isShow then
		Panel_Tooltip_Item_Show_GeneralStatic( slotNo, passTooltipType, true )
	elseif false == isShow then
		Panel_Tooltip_Item_hideTooltip()
	end
end

function FromClient_ChallengeReward_UpdateText()
	_scroll:SetControlPos(0)
	_scrollIndex = 0
	Fglobal_Challenge_UpdateData()
end

registerEvent("FromClient_ChallengeReward_UpdateText",	"FromClient_ChallengeReward_UpdateText")			-- 도전 과제 갱신 시 실행

Challenge_Initialize()
Challenge_TapMenu_Create()
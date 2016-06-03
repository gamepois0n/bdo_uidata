local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM			= CppEnums.EProcessorInputMode

Panel_Window_PetListNew:SetShow( false )
Panel_Window_PetListNew:setGlassBackground( true )
Panel_Window_PetListNew:ActiveMouseEventEffect( true )
Panel_Window_PetCompose:SetShow( false )
Panel_Window_PetCompose:setGlassBackground( true )
Panel_Window_PetCompose:ActiveMouseEventEffect( true )

Panel_Window_PetListNew:RegisterShowEventFunc( true, 'PetNewListShowAni()' )
Panel_Window_PetListNew:RegisterShowEventFunc( false, 'PetNewListHideAni()' )

function PetNewListShowAni()
end
function PetNewListHideAni()
end

local marketTest = false 	-- ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 46 )	-- 펫 거래소
local petSkillPlus = true	-- 펫 스킬 중복 들어가면 염
local petComposeChange = true		-- 펫 교환 변경되면 들어감

-- 카운트 체크용이라 스트링 처리 안해도 됨!
local petRaceCount =
{
	[1] = "고양이",
	[2] = "개",
	[3] = "매",
	[4] = "펭귄",
	[5] = "사막여우",
	[6] = "고슴도치",	-- 일본
	[7] = "눈사람",
	[8] = "고슴도치",	-- 한국
	[9] = "오목눈이",
	[10] = "렛서팬더",
	[11] = "앵무새",
}

local checkUnSealList = {}
local maxskillTypeCount = 15
local skillTypeString =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_0"), 			-- "- 성향 회복 증가 +",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_1"), 			-- "- 전투 경험치 증가 +",
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_2"), 			-- "- 채집 경험치 증가 +",
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_3"), 			-- "- 사망 페널티 감소 +",
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_4"), 			-- "- 낚시 경험치 증가 +",
	[5] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_5"), 			-- "- 수렵 경험치 증가 +",
	[6] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_6"),	 		-- "- 요리 경험치 증가 +",
	[7] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_7"), 			-- "- 연금 경험치 증가 +",
	[8] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_8"), 			-- "- 가공 경험치 증가 +",
	[9] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_9"), 			-- "- 조련 경험치 증가 +",
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_10"), 		-- "- 무역 경험치 증가 +",
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_11"), 		-- "- 재배 경험치 증가 +",
	[12] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_12"), 		-- "- 잠재력 행운 증가 +",
	[13] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_13"), 		-- "- 잠재력 낚시 증가 +",
	[14] = PAGetString(Defines.StringSheet_GAME, "LUA_PETSKILLTYPE_14"), 		-- "- 잠재력 채집 증가 +",
}
local plusPoint =
{
	[0] = 7,
	[1] = 5,
	[2] = 3,
	[4] = 4
}
local skillInfo =
{
	plusCount = {},
	skillTypeCount = {}
}

local petSkillList =
{
	window		= UI.getChildControl( Panel_Window_PetListNew, "Static_SkillListWindow" ),
	title		= UI.getChildControl( Panel_Window_PetListNew, "StaticText_SkillListTitle" ),
	subTitle	= UI.getChildControl( Panel_Window_PetListNew, "StaticText_SkillList_Title" ),
	bg1			= UI.getChildControl( Panel_Window_PetListNew, "Static_SkillListBG" ),
	textList	= UI.getChildControl( Panel_Window_PetListNew, "StaticText_SkillList" ),
	bg2			= UI.getChildControl( Panel_Window_PetListNew, "Static_SkillListBG2" ),
	desc		= UI.getChildControl( Panel_Window_PetListNew, "StaticText_SkillListDesc" ),
}

function petSkillList_Show()
	if not petSkillPlus then
		return
	end
	for key, control in pairs ( petSkillList ) do
		control:SetShow( true )
	end
end
function petSkillList_Close()
	for key, control in pairs ( petSkillList ) do
		control:SetShow( false )
	end
end
petSkillList_Close()

-- 펫 최대 소환수는 ContentsOption에서 가져와서 사용한다
local maxUnsealCount = ToClient_getPetUseMaxCount()

local composableCheck = false
local petComposeNo =
{
	[0]	= nil,
	[1] = nil
}
local composePetTier = 0			-- 기본 펫 티어 초기화
local PetList = {
	panelBG			= UI.getChildControl( Panel_Window_PetListNew, "Static_BG" ),
	scroll			= UI.getChildControl( Panel_Window_PetListNew, "Scroll_PetListNew" ),
	BTN_Close		= UI.getChildControl( Panel_Window_PetListNew, "Button_Win_Close" ),
	noneUnsealPet	= UI.getChildControl( Panel_Window_PetListNew, "StaticText_NoneUnsealPet" ),
	-- BTN_UnSeal		= UI.getChildControl( Panel_Window_PetListNew, "Button_UnSeal"),
	BTN_Compose		= UI.getChildControl( Panel_Window_PetListNew, "Button_Compose" ),
	BTN_AllUnSeal	= UI.getChildControl( Panel_Window_PetListNew, "Button_AllUnSeal"),	-- 모두 맡기기
	BTN_AllSeal		= UI.getChildControl( Panel_Window_PetListNew, "Button_AllSeal"),	-- 모두 찾기
	BTN_Market		= UI.getChildControl( Panel_Window_PetListNew, "Button_Market" ),

	TXT_HungryAlert	= UI.getChildControl( Panel_Window_PetControl, "StaticText_HungryAlert"),

	scrollInterval	= 0,
	startIndex		= 0,
	listMaxCount	= 5,
	listUIPool		= {},
	SealDATACount	= 0,
	UnSealDataCount	= 0,
}
PetList.scrollCtrBTN	= UI.getChildControl( PetList.scroll, "Scroll_CtrlButton" )

PetList.BTN_AllSeal:addInputEvent("Mouse_On", "PetListNew_SimpleTooltip( true )")
PetList.BTN_AllSeal:addInputEvent("Mouse_Out", "PetListNew_SimpleTooltip( false )")
PetList.BTN_AllSeal:setTooltipEventRegistFunc("PetListNew_SimpleTooltip( true )")

PetList.BTN_AllUnSeal:SetShow( not marketTest )
PetList.BTN_Market:SetShow( marketTest )

local Template = {
	static_ListContentBG		= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_ListContentBG" ),
	static_IconPetBG			= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_IconPetBG" ),
	static_IconPet				= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_IconPet" ),
	staticText_PetName			= UI.getChildControl( Panel_Window_PetListNew, "Template_StaticText_PetName" ),
	staticText_Level			= UI.getChildControl( Panel_Window_PetListNew, "Template_StaticText_Level" ),
	staticText_Hungry			= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_HungryIcon" ),
	static_Progress_Hungry_BG	= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_Progress_Hungry_BG" ),
	static_Progress_Hungry		= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_Progress_Hungry" ),
	staticText_Lovely			= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_LovelyIcon" ),
	static_Progress_Lovely_BG	= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_Progress_Lovely_BG" ),
	static_Progress_Lovely		= UI.getChildControl( Panel_Window_PetListNew, "Template_Static_Progress_Lovely" ),
	staticText_State			= UI.getChildControl( Panel_Window_PetListNew, "StaticText_State" ),
	button_Info					= UI.getChildControl( Panel_Window_PetListNew, "Template_Button_Info" ),
	button_Regist				= UI.getChildControl( Panel_Window_PetListNew, "Template_Button_Regist" ),
	button_Seal					= UI.getChildControl( Panel_Window_PetListNew, "Template_Button_Seal" ),
	button_UnSeal				= UI.getChildControl( Panel_Window_PetListNew, "Template_Button_Unseal"),
	button_UnSealAll			= UI.getChildControl( Panel_Window_PetListNew, "Template_Button_UnsealAll"),
	button_Fusion				= UI.getChildControl( Panel_Window_PetListNew, "Template_Button_Fusion" ),
	check_AllSeal				= UI.getChildControl( Panel_Window_PetListNew, "Template_CheckButton_AllSeal"),
}

for v, control in pairs(Template) do
	control:SetShow(false)
end

local 	_buttonQuestion	= UI.getChildControl( Panel_Window_PetListNew, "Button_Question" )						-- 물음표 버튼
	_buttonQuestion:	addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Pet\" )" )					-- 물음표 좌클릭
	_buttonQuestion:	addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"Pet\", \"true\")" )				-- 물음표 마우스오버
	_buttonQuestion:	addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"Pet\", \"false\")" )			-- 물음표 마우스아웃

local petCompose =
{
	icon_1			= UI.getChildControl( Panel_Window_PetCompose, "Static_Icon_1" ),
	icon_2			= UI.getChildControl( Panel_Window_PetCompose, "Static_Icon_2" ),
	icon_3			= UI.getChildControl( Panel_Window_PetCompose, "Static_Icon_3" ),
	icon_question	= UI.getChildControl( Panel_Window_PetCompose, "StaticText_QuestionMark" ),
	editName		= UI.getChildControl( Panel_Window_PetCompose, "Edit_Naming" ),
	
	desc			= UI.getChildControl( Panel_Window_PetCompose, "StaticText_Desc" ),
	descBg			= UI.getChildControl( Panel_Window_PetCompose, "Static_DescBg" ),
		
	btn_Yes			= UI.getChildControl( Panel_Window_PetCompose, "Button_Yes" ),
	btn_No			= UI.getChildControl( Panel_Window_PetCompose, "Button_No" ),
	
	btn_Question	= UI.getChildControl( Panel_Window_PetCompose, "Button_Question" ),
	
	radioBtn_PetSkill_1		= UI.getChildControl( Panel_Window_PetCompose, "RadioButton_Skill_1" ),
	radioBtn_PetSkill_2		= UI.getChildControl( Panel_Window_PetCompose, "RadioButton_Skill_2" ),
	radioBtn_PetSkill_3		= UI.getChildControl( Panel_Window_PetCompose, "RadioButton_Skill_3" ),
	
	radioBtn_PetLook_1		= UI.getChildControl( Panel_Window_PetCompose, "RadioButton_Look_1" ),
	radioBtn_PetLook_2		= UI.getChildControl( Panel_Window_PetCompose, "RadioButton_Look_2" ),
	radioBtn_PetLook_3		= UI.getChildControl( Panel_Window_PetCompose, "RadioButton_Look_3" ),
	
	skillSlotBg			=
	{
		[1] = 
		{
			[1] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_1_1" ),
			[2] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_1_2" ),
			[3] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_1_3" ),
		},
		[2] = 
		{
			[1] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_2_1" ),
			[2] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_2_2" ),
			[3] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_2_3" ),
		},
		[3] = 
		{
			[1] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_3_1" ),
			[2] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_3_2" ),
			[3] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillSlotBg_3_3" ),
		},
	},
	skillSlot		=
	{
		[1] =
		{
			[1] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_1_1" ),
			[2] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_1_2" ),
			[3] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_1_3" ),
		},
		[2] =
		{
			[1] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_2_1" ),
			[2] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_2_2" ),
			[3] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_2_3" ),
		},
		[3] =
		{
			[1] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_3_1" ),
			[2] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_3_2" ),
			[3] = UI.getChildControl( Panel_Window_PetCompose, "Static_SkillPetSlot_3_3" ),
		},
	},
	

	skillNoList		= { [0] = nil, nil, nil, nil, nil, nil },
	preserveSkillNo	= nil,
	petComposeNo	= { [1] = nil, nil },
	race			= nil,
}

petCompose.radioBtn_PetSkill_1:addInputEvent( "Mouse_LUp", "PetCompose_UpdatePetSkillList()" )
petCompose.radioBtn_PetSkill_2:addInputEvent( "Mouse_LUp", "PetCompose_UpdatePetSkillList()" )
petCompose.radioBtn_PetSkill_3:addInputEvent( "Mouse_LUp", "PetCompose_UpdatePetSkillList()" )

petCompose.radioBtn_PetLook_1:addInputEvent( "Mouse_LUp", "PetCompose_UpdatePetSkillList()" )
petCompose.radioBtn_PetLook_2:addInputEvent( "Mouse_LUp", "PetCompose_UpdatePetSkillList()" )
petCompose.radioBtn_PetLook_3:addInputEvent( "Mouse_LUp", "PetCompose_UpdatePetSkillList()" )

petCompose.btn_Question	:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Pet\" )" )					-- 물음표 좌클릭
petCompose.btn_Question	:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"Pet\", \"true\")" )				-- 물음표 마우스오버
petCompose.btn_Question	:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"Pet\", \"false\")" )			-- 물음표 마우스아웃
petCompose.btn_Yes		:addInputEvent( "Mouse_LUp", "Confirm_PetCompose()" )
petCompose.btn_No		:addInputEvent( "Mouse_LUp", "Panel_Window_PetCompose_Close()" )
petCompose.editName		:addInputEvent( "Mouse_LUp", "HandleClicked_PetCompose_ClearEdit()" )

local petComposeString	= PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_NAME")			-- "애완동물 이름을 정해주세요"
local petComposeDesc	= PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_DESC")
-- if not petComposeChange then
	-- petComposeDesc = "1. 애완동물 두 마리를 교환하여 새로운 애완동물로 교환 가능합니다.\n2. 교환한 애완동물은 기존 두 마리의 외형을 물려받습니다.\n3. 교환할 애완동물의 레벨이 높을수록 높은 등급의 결과물이 잘 나옵니다.\n4. 다른 종의 애완동물끼리 교환은 불가능 합니다.\n<PAColor0xFFDB2B2B>5. 효과와 수치가 동일한 기술은 애완동물끼리 중복 적용 받을 수 없습니다.<PAOldColor>\n<PAColor0xFFDB2B2B>6. 교환시 애완동물이 보유한 특기와 기술은 변동될 수 있습니다.<PAOldColor>"
-- end

-- 1. 애완동물 두 마리를 좀 더 유용한 애완동물 한 마리로 교환할 수 있습니다.\n2. 교환한 애완동물은 기존 두 마리의 외형을 물려받습니다.\n3. 또한 스킬 사용이 가능해 좀 더 유용합니다.\n4. 교환할 애완동물의 레벨이 높을수록 높은 등급의 결과물이 잘 나옵니다.
petCompose.desc:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
if petCompose.desc ~= nil then
	petCompose.desc			:SetText( petComposeDesc )
end

local panelSizeY	= Panel_Window_PetCompose:GetSizeY()
local descBgSizeY	= petCompose.descBg:GetSizeY()
-- 설명 문구 줄넘어갈 때 처리
if 120 < petCompose.desc:GetTextSizeY() then
	Panel_Window_PetCompose	:SetSize( Panel_Window_PetCompose:GetSizeX(), panelSizeY + petCompose.desc:GetTextSizeY() - 119 )
	petCompose.descBg		:SetSize( petCompose.descBg:GetSizeX(), descBgSizeY + petCompose.desc:GetTextSizeY() - 119 )
end
petCompose.btn_Yes		:ComputePos()
petCompose.btn_No		:ComputePos()

function PetList:Initialize()
	local itemList_PosY = 5
	for listIdx	= 0, self.listMaxCount - 1 do
		local tempSlot = {}
		local Created_ListContentBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.panelBG, 'PetListNew_ListContentBG_' .. listIdx )
		CopyBaseProperty( Template.static_ListContentBG, Created_ListContentBG )
		Created_ListContentBG:SetPosX( 9 )
		Created_ListContentBG:SetPosY( itemList_PosY )
		Created_ListContentBG:addInputEvent("Mouse_DownScroll",		"PetListNew_ScrollEvent( true )")
		Created_ListContentBG:addInputEvent("Mouse_UpScroll",		"PetListNew_ScrollEvent( false )")
		Created_ListContentBG:SetShow( false )
		tempSlot.ListContentBG = Created_ListContentBG

		local Created_PetIconBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ListContentBG, 'PetListNew_PetIconBG_' .. listIdx )
		CopyBaseProperty( Template.static_IconPetBG, Created_PetIconBG )
		Created_PetIconBG:SetPosX( 5 )
		Created_PetIconBG:SetPosY( 5 )
		Created_PetIconBG:SetShow( false )
		tempSlot.PetIconBG = Created_PetIconBG

		local Created_PetIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_PetIconBG, 'PetListNew_PetIcon_' .. listIdx )
		CopyBaseProperty( Template.static_IconPet, Created_PetIcon )
		Created_PetIcon:SetPosX( 0 )
		Created_PetIcon:SetPosY( 0 )
		Created_PetIcon:SetShow( false )
		tempSlot.PetIcon = Created_PetIcon

		local Created_PetLev = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ListContentBG, 'PetListNew_PetLevel_' .. listIdx )
		CopyBaseProperty( Template.staticText_Level, Created_PetLev )
		Created_PetLev:SetPosX( 70 )
		Created_PetLev:SetPosY( 10 )
		Created_PetLev:SetShow( false )
		tempSlot.PetLev = Created_PetLev

		local Created_PetName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ListContentBG, 'PetListNew_PetName_' .. listIdx )
		CopyBaseProperty( Template.staticText_PetName, Created_PetName )
		Created_PetName:SetPosX( 110 )
		Created_PetName:SetPosY( 10 )
		Created_PetName:SetShow( false )
		tempSlot.PetName = Created_PetName

		local Created_PetHungry = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ListContentBG, 'PetListNew_PetHungry_' .. listIdx )
		CopyBaseProperty( Template.staticText_Hungry, Created_PetHungry )
		Created_PetHungry:SetPosX( 70 )
		Created_PetHungry:SetPosY( 30 )
		Created_PetHungry:SetShow( false )
		tempSlot.PetHungry = Created_PetHungry

		local Created_PetHungryProgressBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ListContentBG, 'PetListNew_PetHungryProgressBG_' .. listIdx )
		CopyBaseProperty( Template.static_Progress_Hungry_BG, Created_PetHungryProgressBG )
		Created_PetHungryProgressBG:SetPosX( 105 )
		Created_PetHungryProgressBG:SetPosY( 37 )
		Created_PetHungryProgressBG:SetShow( false )
		tempSlot.PetHungryProgressBG = Created_PetHungryProgressBG

		local Created_PetHungryProgress = UI.createControl( UI_PUCT.PA_UI_CONTROL_PROGRESS2, Created_PetHungryProgressBG, 'PetListNew_PetHungryProgress_' .. listIdx )
		CopyBaseProperty( Template.static_Progress_Hungry, Created_PetHungryProgress )
		Created_PetHungryProgress:SetPosX( 1 )
		Created_PetHungryProgress:SetPosY( 1 )
		Created_PetHungryProgress:SetCurrentProgressRate( 100 )
		Created_PetHungryProgress:SetProgressRate( 80 )
		Created_PetHungryProgress:SetShow( false )
		tempSlot.PetHungryProgress = Created_PetHungryProgress
		------------------------------ 애정도 임시 숨김.
		local Created_PetLovely = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ListContentBG, 'PetListNew_PetLovely_' .. listIdx )
		CopyBaseProperty( Template.staticText_Lovely, Created_PetLovely )
		Created_PetLovely:SetPosX( 185 )
		Created_PetLovely:SetPosY( 30 )
		Created_PetLovely:SetShow( false )
		tempSlot.PetLovely = Created_PetLovely

		local Created_PetLovelyProgressBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Created_ListContentBG, 'PetListNew_PetLovelyProgressBG_' .. listIdx )
		CopyBaseProperty( Template.static_Progress_Lovely_BG, Created_PetLovelyProgressBG )
		Created_PetLovelyProgressBG:SetPosX( 220 )
		Created_PetLovelyProgressBG:SetPosY( 37 )
		Created_PetLovelyProgressBG:SetShow( false )
		tempSlot.PetLovelyProgressBG = Created_PetLovelyProgressBG

		local Created_PetLovelyProgress = UI.createControl( UI_PUCT.PA_UI_CONTROL_PROGRESS2, Created_PetLovelyProgressBG, 'PetListNew_PetLovelyProgress_' .. listIdx )
		CopyBaseProperty( Template.static_Progress_Lovely, Created_PetLovelyProgress )
		Created_PetLovelyProgress:SetPosX( 1 )
		Created_PetLovelyProgress:SetPosY( 1 )
		Created_PetLovelyProgress:SetCurrentProgressRate( 100 )
		Created_PetLovelyProgress:SetProgressRate( 80 )
		Created_PetLovelyProgress:SetShow( false )
		tempSlot.PetLovelyProgress = Created_PetLovelyProgress
		------------------------------ 애정도 임시 숨김.
		
		local petState = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Created_ListContentBG, "PetListNew_State_" .. listIdx )
		CopyBaseProperty( Template.staticText_State, petState )
		petState:SetShow( false )
		tempSlot.petState = petState
		
		local Created_BTNInfo = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ListContentBG, 'PetListNew_PetBTNInfo_' .. listIdx )
		CopyBaseProperty( Template.button_Info, Created_BTNInfo )
		Created_BTNInfo:SetPosX( 300 )
		Created_BTNInfo:SetPosY( 10 )
		Created_BTNInfo:SetShow( false )
		tempSlot.BTNInfo = Created_BTNInfo
		
		local Created_BTNRegist = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ListContentBG, 'PetListNew_PetBTNRegist_' .. listIdx )
		CopyBaseProperty( Template.button_Regist, Created_BTNRegist )
		Created_BTNRegist:SetPosX( 300 )
		Created_BTNRegist:SetPosY( 10 )
		Created_BTNRegist:SetShow( false )
		tempSlot.BTNRegist = Created_BTNRegist

		local Created_BTNSeal = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ListContentBG, 'PetListNew_PetBTNSeal_' .. listIdx )
		CopyBaseProperty( Template.button_Seal, Created_BTNSeal )
		Created_BTNSeal:SetPosX( 340 )
		Created_BTNSeal:SetPosY( 10 )
		Created_BTNSeal:SetShow( false )
		tempSlot.BTNSeal = Created_BTNSeal
		
		local Created_BTNUnSeal = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ListContentBG, 'PetListNew_PetBTNUnSeal_' .. listIdx )
		CopyBaseProperty( Template.button_UnSeal, Created_BTNUnSeal )
		Created_BTNUnSeal:SetPosX( 340 )
		Created_BTNUnSeal:SetPosY( 10 )
		Created_BTNUnSeal:SetShow( false )
		tempSlot.BTNUnSeal = Created_BTNUnSeal
		
		local Created_BTNUnSealAll = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ListContentBG, 'PetListNew_PetBTNUnSealAll_' .. listIdx )
		CopyBaseProperty( Template.button_UnSealAll, Created_BTNUnSealAll )
		Created_BTNUnSealAll:SetPosX( 340 )
		Created_BTNUnSealAll:SetPosY( 10 )
		Created_BTNUnSealAll:SetShow( false )
		tempSlot.BTNUnSealAll = Created_BTNUnSealAll
		
		local Created_BTNFusion = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, Created_ListContentBG, 'PetListNew_PetBTNFusion_' .. listIdx )
		CopyBaseProperty( Template.button_Fusion, Created_BTNFusion )
		Created_BTNFusion:SetPosX( 300 )
		Created_BTNFusion:SetPosY( 10 )
		Created_BTNFusion:SetShow( false )
		tempSlot.BTNFusion = Created_BTNFusion

		local Created_CHKAllSeal = UI.createControl( UI_PUCT.PA_UI_CONTROL_CHECKBUTTON, Created_ListContentBG, 'PetListNew_PetCHKAllSeal_' .. listIdx )
		CopyBaseProperty( Template.check_AllSeal, Created_CHKAllSeal )
		Created_CHKAllSeal:SetPosX( 5 )
		Created_CHKAllSeal:SetPosY( 32 )
		Created_CHKAllSeal:SetShow( false )
		tempSlot.CHKAllSeal = Created_CHKAllSeal
		
		itemList_PosY	= itemList_PosY + Created_ListContentBG:GetSizeY() + 5
		
		if marketTest then
			Created_BTNInfo:SetPosX( 260 )
			Created_BTNUnSeal:SetPosX( 300 )
			Created_BTNFusion:SetPosX( 260 )
		end
		
		self.listUIPool[listIdx] = tempSlot
	end



		local btnComposeSizeX			= PetList.BTN_Compose:GetSizeX()+23
		local btnComposeTextPosX		= (btnComposeSizeX - (btnComposeSizeX/2) - ( PetList.BTN_Compose:GetTextSizeX() / 2 ))
		local btnAllUnSealSizeX			= PetList.BTN_AllUnSeal:GetSizeX()+23
		local btnAllUnSealTextPosX		= (btnAllUnSealSizeX - (btnAllUnSealSizeX/2) - ( PetList.BTN_AllUnSeal:GetTextSizeX() / 2 ))
		local btnAllSealSizeX			= PetList.BTN_AllSeal:GetSizeX()+23
		local btnAllSealTextPosX		= (btnAllSealSizeX - (btnAllSealSizeX/2) - ( PetList.BTN_AllSeal:GetTextSizeX() / 2 ))


		PetList.BTN_Compose				:SetTextSpan( btnComposeTextPosX, 5 )
		PetList.BTN_AllUnSeal			:SetTextSpan( btnAllUnSealTextPosX, 5 )
		PetList.BTN_AllSeal				:SetTextSpan( btnAllSealTextPosX, 5 )
		PetList.BTN_Compose:SetShow( true )
		PetList.BTN_Compose		:SetSpanSize( -120, 7 )
		PetList.BTN_AllUnSeal	:SetSpanSize( 0, 7 )
		PetList.BTN_AllSeal		:SetSpanSize( 120, 7 )
end

function PetList:SetScroll()
	local listCount = 0
	if 0 == ToClient_getPetUnsealedList() then
		listCount			= ToClient_getPetSealedList() + ToClient_getPetUnsealedList() + 1
	else
		listCount			= ToClient_getPetSealedList() + ToClient_getPetUnsealedList()
	end

	local pagePercent		= ( self.listMaxCount / listCount ) * 100

	local scroll_Interval	= listCount - self.listMaxCount
	local scrollSizeY		= self.scroll:GetSizeY()
	local btn_scrollSizeY	= ( scrollSizeY / 100 ) * pagePercent

	if btn_scrollSizeY < 50 then
		btn_scrollSizeY = 50
	end
	if scrollSizeY <= btn_scrollSizeY then
		btn_scrollSizeY = scrollSizeY * 0.99
	end

	self.scrollCtrBTN:SetSize( self.scrollCtrBTN:GetSizeX(), btn_scrollSizeY )
	self.scrollInterval	= scroll_Interval
	self.scroll:SetInterval( self.scrollInterval )
end

function PetList:Update( startIdx )
	self.UnSealDATACount	= ToClient_getPetUnsealedList()					-- 찾은 펫 카운트(최대 3개)
	self.SealDATACount		= ToClient_getPetSealedList()					-- 맡긴 펫 카운트
	local havePetCount		= self.UnSealDATACount + self.SealDATACount		-- 등록한 펫 카운트
	local petControlCount	= havePetCount									-- 보여줄 펫 리스트 콘트롤 수
	local isScroll			= false
	local petData			= {}
	
	-- 꺼낸 펫이 0이면서 가진 펫(꺼낸 펫 + 안꺼낸 펫) 수가 5 이상이거나, 꺼낸 펫이 있으면서 가진 펫 수가 6 이상일 때 스크롤 보여줌
	if ( 0 == ToClient_getPetUnsealedList() and self.listMaxCount < havePetCount + 1 ) or ( 0 < ToClient_getPetUnsealedList() and self.listMaxCount < havePetCount ) then
		self.scroll:SetShow( true )
	else
		self.scroll:SetShow( false )
	end
	
	for index = 0, self.listMaxCount -1 do
		for v, control in pairs ( self.listUIPool[index] ) do
			control:SetShow( false )
		end
	end
	
	-- startIdx가 0일 때만, 첫 번째 리스트콘트롤에 아래의 문구가 들어간 콘트롤을 넣어줌
	if 0 == startIdx then
		if 0 == havePetCount then
			self.noneUnsealPet					:SetShow( true )
			self.noneUnsealPet					:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TEXT_HAVENOTPET") ) -- "찾은 애완동물이 없습니다."
			self.listUIPool[0].ListContentBG	:SetShow( true )
			petSkillList_Close()
			return											-- 가진 펫이 없으므로 리턴
		elseif 0 == self.UnSealDATACount then
			self.noneUnsealPet					:SetShow( true )
			self.noneUnsealPet					:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_TEXT_NOGETPET") ) -- "찾은 애완동물이 없습니다."
			for v, control in pairs (self.listUIPool[0]) do
				control:SetShow( false )
			end
			self.listUIPool[0].ListContentBG	:SetShow( true )
			petControlCount = havePetCount + 1				-- 펫 정보 이외의 콘트롤이 하나 생성되므로 +1을 해줌
			petSkillList_Close()
		else
			self.noneUnsealPet					:SetShow( false )
		end
	else
		self.noneUnsealPet					:SetShow( false )
	end

	local limitIndex = havePetCount
	if self.listMaxCount <= limitIndex then
		limitIndex = self.listMaxCount
	end

	local hungryAlert = false
	for petIndex = 0, limitIndex - 1 do
		local uiIndex			= 0
		local unSealPetCheck	= 0
		if havePetCount < petControlCount then					-- 꺼낸 펫이 없는 경우
			uiIndex = petIndex + 1								-- 컨트롤이 하나 생성돼 있으므로, 펫 정보를 표시해줄 인덱스에 +1 해줌
			unSealPetCheck = 1
			if self.listMaxCount + startIdx == uiIndex then		-- 스크롤 오작동 방지용
				return
			end
		else
			uiIndex = petIndex
			unSealPetCheck = 0
			if self.listMaxCount + startIdx + 1 == uiIndex then	-- 스크롤 오작동 방지용
				return
			end
		end
		
		local unsealPetIndex = 0
		local petStaticStatus, iconPath, petNo_s64, petName, petLevel, petLovely, pethungry, petMaxLevel, petMaxHungry, petRace, petTier, petState
		if self.UnSealDATACount <= petIndex + unSealPetCheck + startIdx then
			if 0 == self.UnSealDATACount and 0 ~= startIdx then
				petData[petIndex]	= ToClient_getPetSealedDataByIndex( petIndex - self.UnSealDATACount + startIdx - 1 )	-- ToClient 함수 인덱스가 startIdx부터 시작돼야 함
				unsealPetIndex = petIndex - self.UnSealDATACount + startIdx - 1
			else
				petData[petIndex]	= ToClient_getPetSealedDataByIndex( petIndex - self.UnSealDATACount + startIdx )		-- ToClient 함수 인덱스가 startIdx부터 시작돼야 함
				unsealPetIndex = petIndex - self.UnSealDATACount + startIdx
			end
			if nil == petData[petIndex] then
				return
			end
			petStaticStatus		= petData[petIndex]:getPetStaticStatus()
			iconPath			= petData[petIndex]:getIconPath()
			petNo_s64			= petData[petIndex]._petNo
			petName				= petData[petIndex]:getName()
			petLevel			= petData[petIndex]._level
			petLovely			= petData[petIndex]._lovely
			pethungry			= petData[petIndex]._hungry
			petState			= petData[petIndex]._petState
			petMaxLevel			= petStaticStatus._maxLevel
			petMaxHungry		= petStaticStatus._maxHungry
			petRace				= petStaticStatus:getPetRace()				-- 고양이, 개 구별
			petTier				= petStaticStatus:getPetTier() + 1			-- 0세대부터 시작하므로 +1을 해준다
		else
			petData[petIndex]	= ToClient_getPetUnsealedDataByIndex( petIndex + startIdx )		-- ToClient 함수 인덱스가 startIdx부터 시작돼야 함
			if nil == petData[petIndex] then
				return
			end
			petStaticStatus		= petData[petIndex]:getPetStaticStatus()
			iconPath			= petData[petIndex]:getIconPath()
			petNo_s64			= petData[petIndex]:getPcPetNo()
			petName				= petData[petIndex]:getName()
			petLevel			= petData[petIndex]:getLevel()
			petLovely			= petData[petIndex]:getLovely()
			pethungry			= petData[petIndex]:getHungry()
			petState			= petData[petIndex]:getPetState()
			petMaxLevel			= petStaticStatus._maxLevel
			petMaxHungry		= petStaticStatus._maxHungry
			petRace				= petStaticStatus:getPetRace()				-- 고양이, 개 구별
			petTier				= petStaticStatus:getPetTier() + 1			-- 0세대부터 시작하므로 +1을 해준다
			
			if ( pethungry / petMaxHungry ) * 100 <= 10 then
				hungryAlert = true
			end
		end
		
		if 0 == ToClient_getPetUnsealedList() then
			hungryAlert = false
		end
		
		-- 펫 애정도
		local lovelyPercent		= 0
		if 0 ~= petLovely then
			lovelyPercent		= ( petLovely / 100 ) * 100
		end
		
		-- 펫 헝그리
		local hungryPercent		= ( pethungry / petMaxHungry ) * 100
		
		local UiBase = self.listUIPool[uiIndex]
		UiBase.ListContentBG		:SetShow( true )
		UiBase.PetIconBG			:SetShow( true )
		UiBase.PetIcon				:SetShow( true )
		UiBase.PetLev				:SetShow( true )
		UiBase.PetName				:SetShow( true )
		UiBase.PetHungry			:SetShow( true )
		UiBase.PetHungryProgressBG	:SetShow( true )
		UiBase.PetHungryProgress	:SetShow( true )
		UiBase.CHKAllSeal			:SetShow( false )
		
		UiBase.PetIcon				:ChangeTextureInfoName( iconPath )
		UiBase.PetLev				:SetText( "Lv." .. petLevel )
		UiBase.PetName				:SetText( petName .. " (" .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", petTier) .. ")" )
		UiBase.PetHungryProgress	:SetProgressRate( hungryPercent )
		UiBase.PetLovelyProgress	:SetProgressRate( lovelyPercent )
		
		if self.UnSealDATACount < petIndex + 1 + startIdx then
			UiBase.BTNInfo		:SetShow( false )
			UiBase.BTNUnSeal	:SetShow( false )
			UiBase.BTNUnSealAll	:SetShow( false )
			UiBase.BTNSeal		:SetShow( true and not Panel_Window_PetCompose:GetShow() )
			UiBase.BTNRegist	:SetShow( marketTest )
			UiBase.BTNFusion	:SetShow( false )
			UiBase.CHKAllSeal	:SetShow( true )

			if nil == checkUnSealList[Int64toInt32(petNo_s64)] then
				checkUnSealList[Int64toInt32(petNo_s64)] = false
			end

			local isCheck = checkUnSealList[Int64toInt32(petNo_s64)]
			UiBase.CHKAllSeal:SetCheck( isCheck )

			local petComposable = math.abs(petTier - composePetTier) < 2			-- 2티어 이상 차이나는 펫은 교배할 수 없다
			if nil ~= petComposeNo[1] then
				UiBase.BTNFusion	:SetShow( false )
			elseif petNo_s64 ~= petComposeNo[0] and nil ~= petComposeNo[0] and ( petCompose._race == petRace ) and petComposable then
				UiBase.BTNFusion	:SetShow( true )
			elseif nil == petComposeNo[0] and true == CheckCompose() and ( petRace <= #petRaceCount ) then 
				UiBase.BTNFusion	:SetShow( true )
			end
		else
			UiBase.BTNInfo		:SetShow( true )
			UiBase.BTNUnSeal	:SetShow( true )
			UiBase.BTNUnSealAll	:SetShow( marketTest )
			UiBase.BTNSeal		:SetShow( false )
			UiBase.BTNFusion	:SetShow( false )
			UiBase.BTNRegist	:SetShow( false )
			UiBase.CHKAllSeal	:SetShow( false )
		end

		-- PetList.BTN_AllSeal				:SetIgnore( Panel_Window_PetCompose:GetShow() )
		-- PetList.BTN_AllSeal				:SetMonoTone( Panel_Window_PetCompose:GetShow() )
		-- PetList.BTN_AllUnSeal			:SetIgnore( Panel_Window_PetCompose:GetShow() )
		-- PetList.BTN_AllUnSeal			:SetMonoTone( Panel_Window_PetCompose:GetShow() )
			
		-- UiBase.BTNUnregister	:SetShow( false ) 				-- 고양이는 유료캐쉬템이기 때문에 놓아주기 버튼을 노출시키지 않는다.
		UiBase.BTNInfo			:addInputEvent( "Mouse_LUp", "petListNew_ShowInfo	( \"" .. tostring(petNo_s64) .. "\" )" )
		UiBase.BTNUnSeal		:addInputEvent( "Mouse_LUp", "petListNew_Seal		( \"" .. tostring(petNo_s64) .. "\" ," .. uiIndex .. ")" )
		UiBase.BTNUnSealAll		:addInputEvent( "Mouse_LUp", "FGlobal_HandleClicked_petControl_AllUnSeal()")
		UiBase.BTNSeal			:addInputEvent( "Mouse_LUp", "petListNew_UnSeal		( \"" .. tostring(petNo_s64) .. "\" )" )		-- petNo
		UiBase.BTNRegist		:addInputEvent( "Mouse_LUp", "petListNew_Regist		( \"" .. tostring(petNo_s64) .. "\" )" )		-- petNo
		UiBase.BTNFusion		:addInputEvent( "Mouse_LUp", "petListNew_Compose_Set( \"" .. tostring(petNo_s64) .. "\" ," .. petRace .. ", " .. unsealPetIndex .. " )" )		-- petNo
		UiBase.CHKAllSeal		:addInputEvent( "Mouse_LUp", "petListNew_AllSealCheck( " .. Int64toInt32(petNo_s64) .. "," .. uiIndex .. ")" )		-- petNo
		
		-- if 2 == petState then		-- 거래소 등록 중이면(아직 거래소가 출시안됬지만 라이브에 거래소 등록중 노출되는 버그가 있어서 주석처리한다.2015-11-08)
		-- 	UiBase.BTNInfo		:SetShow( false )
		-- 	UiBase.BTNUnSeal	:SetShow( false )
		-- 	UiBase.BTNUnSealAll	:SetShow( false )
		-- 	UiBase.BTNSeal		:SetShow( false )
		-- 	UiBase.BTNFusion	:SetShow( false )
		-- 	UiBase.BTNRegist	:SetShow( false )
		-- 	UiBase.petState		:SetShow( true )
		-- else
		-- 	UiBase.petState		:SetShow( false )
		-- end
	end
	
	-- 꺼낸 펫 중 한 마리라도 배고픔 게이지 텍스트를 켜줄 조건을 만족시키면 켜줌
	FGlobal_PetHungryAlert( hungryAlert )
	-- if true == hungryAlert then
		-- self.TXT_HungryAlert:SetShow( true )
		-- Panel_Party:SetSpanSize( 10, 310 )
	-- else
		-- self.TXT_HungryAlert:SetShow( false )
		-- Panel_Party:SetSpanSize( 10, 280 )
	-- end
	
	-- 펫 스킬 수치 합산
	skillTypeCount_Init()
	if not CheckCompose() then
		AmountPetSkill_Attribute( self.UnSealDATACount )
	end
end

function AmountPetSkill_Attribute( count )
	local skillMaxCount = ToClient_getPetEquipSkillMax()
	if 0 < count then
		for index = 0, count - 1 do
			local PcPetData = ToClient_getPetUnsealedDataByIndex( index )
			if nil == PcPetData then
				return
			end
			for skill_idx = 0, skillMaxCount - 1 do
				local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus( skill_idx )
				local isLearn = PcPetData:isPetEquipSkillLearned( skill_idx )
				if true == isLearn and nil ~= skillStaticStatus then
					local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
					if nil ~= skillTypeStaticWrapper then
						PetSkillTypeCheck1( skill_idx )
					end
				end
			end
		end
	
		local petSkillGrade = ""
		local petSkillGradeText = ""
		local hasSkill = false
		for skillTypeIndex = 0, maxskillTypeCount -1 do
			if 0 < skillInfo.plusCount[skillTypeIndex] then
				if skillTypeIndex < 12 then
					petSkillGrade = "%"
				else
					petSkillGrade = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_POTENLEVEL")	 -- "단계"
				end
				if "" == petSkillGradeText then
					petSkillGradeText = skillTypeString[skillTypeIndex] .. skillInfo.plusCount[skillTypeIndex] .. petSkillGrade
				else
					petSkillGradeText = petSkillGradeText .. "\n" .. skillTypeString[skillTypeIndex] .. skillInfo.plusCount[skillTypeIndex] .. petSkillGrade
				end
				hasSkill = true
			end
		end
		
		if hasSkill then
			local self = petSkillList
			petSkillList_Show()
			self.textList:SetText( petSkillGradeText )
			local textSizeY = self.textList:GetTextSizeY()
			self.bg1:SetSize( self.bg1:GetSizeX(), textSizeY + 10 )
			self.bg2:SetPosY( self.bg1:GetPosY() + textSizeY + 15 )
			self.desc:SetPosY( self.bg1:GetPosY() + textSizeY + 30 )
			self.window:SetSize( self.window:GetSizeX(), self.bg2:GetPosY() + 60 )
		else
			petSkillList_Close()
		end
	else
		petSkillList_Close()
	end
	
end

-- 0 성향치, 1 전투 경험치, 2 채집 경험치, 3 사망 페널티, 4 낚시 경험치, 5 수렵 경험치, 6 요리 경험치, 7 연금 경험치, 8 가공 경험치, 9 조련 경험치, 10 무역 경험치, 11 재배 경험치
-- % 맥스는 15, 단계는 1단계가 최대!!!
local maxPercentage = ToClient_MaxPetSkillRate()/10000		-- 꺼낸 펫들의 최대 중첩 스킬 적용치(한국은 일단 20%, 국가별로 다름. 컨텐츠옵션 localizingoption에 있음)
local maxGrade = 5			-- 잠재력 중첩 가능
function PetSkillTypeCheck1( skillIndex )
	local self = skillInfo
	local skillType = nil
	if 0 <= skillIndex and skillIndex < 3 then
		skillType = 0
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex], maxPercentage)
	elseif 3 <= skillIndex and skillIndex < 6 then
		skillType = 1
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex%3], maxPercentage)
	elseif 6 <= skillIndex and skillIndex < 9 then
		skillType = 2
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[skillIndex%3], maxPercentage)
	elseif 12 == skillIndex then
		skillType = 3
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[0], maxPercentage)
	elseif 13 == skillIndex then
		skillType = 3
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[4], maxPercentage)
	elseif 14 <= skillIndex and skillIndex < 17 then
		skillType = 4
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex+1)%3], maxPercentage)
	elseif 17 <= skillIndex and skillIndex < 20 then
		skillType = 5
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex+1)%3], maxPercentage)
	elseif 20 <= skillIndex and skillIndex < 23 then
		skillType = 6
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex+1)%3], maxPercentage)
	elseif 23 <= skillIndex and skillIndex < 26 then
		skillType = 7
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex+1)%3], maxPercentage)
	elseif 26 <= skillIndex and skillIndex < 29 then
		skillType = 8
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex+1)%3], maxPercentage)
	elseif 29 <= skillIndex and skillIndex < 32 then
		skillType = 9
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex+1)%3], maxPercentage)
	elseif 32 <= skillIndex and skillIndex < 35 then
		skillType = 10
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex+1)%3], maxPercentage)
	elseif 35 <= skillIndex and skillIndex < 38 then
		skillType = 11
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + plusPoint[(skillIndex+1)%3], maxPercentage)
	elseif 9 == skillIndex then
		skillType = 12			-- 행운
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + 1, maxGrade)
		-- skillTypeString[skillType] = "행운 " .. self.plusCount[skillType] .. "단계 증가"
	elseif 10 == skillIndex then
		skillType = 13			-- 낚시
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + 1, maxGrade)
		-- skillTypeString[skillType] = "낚시 " .. self.plusCount[skillType] .. "단계 증가"
	elseif 11 == skillIndex then
		skillType = 14			-- 채집
		self.plusCount[skillType] = math.min(self.plusCount[skillType] + 1, maxGrade)
		-- skillTypeString[skillType] = "채집 " .. self.plusCount[skillType] .. "단계 증가"
	end
	self.skillTypeCount[skillType] = self.skillTypeCount[skillType] + 1
	return skillType
end
function skillTypeCount_Init()
	for index = 0, maxskillTypeCount - 1 do
		skillInfo.plusCount[index] = 0
		skillInfo.skillTypeCount[index] = 0
	end
	petSkillList.desc:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SKILLINHERIT_DESC" ))	-- "※ 꺼낸 애완동물 기술의 효과 목록을 표시합니다.\n※ 중첩 효과는 최대 " .. maxPercentage .. "%까지만 적용됩니다." )
	petSkillList_Close()
end

function PetList:SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_Window_PetListNew:GetSizeX()
	local panelSizeY 	= Panel_Window_PetListNew:GetSizeY()

	Panel_Window_PetListNew:SetPosX( (scrSizeX / 2) - (panelSizeX) - 50 )
	Panel_Window_PetListNew:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) - 100 )
end

function PetList:Open()
	self.scroll:SetControlTop()
	self:SetPosition()
	self:SetScroll()						-- 데이터를 카운트 해 인터벌을 정함.
	-- UI.debugMessage(self.startIndex)
	self.startIndex = 0
	PetCompose_Init()
	self:Update( self.startIndex )
	
	Panel_Window_PetListNew:SetShow( true, true )
	petComposeNo[0] = nil
	petComposeNo[1] = nil
	
	if Panel_Window_PetMarket:GetShow() then
		PetMarket_Close()
	end
	
	if Panel_Window_PetCompose:GetShow() then
		Panel_Window_PetCompose_Close()
	end
	
	if Panel_Window_PetMarketRegist:GetShow() then
		PetMarketRegist_Close()
	end
end

function PetList:Close()
	self.scroll:SetControlTop()
	self.startIndex = 0
	Panel_Window_PetListNew:SetShow( false, false )
end

function PetListNew_ScrollEvent( isDown )
	local self		= PetList
	local index		= self.startIndex
	local dataCount = self.SealDATACount + self.UnSealDATACount
	
	if true == isDown then
		if ( dataCount - self.listMaxCount + 1 ) < index then
			return
		end

		if index < self.scrollInterval then
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
	self.startIndex = index
	self:Update( index )
end

function HandleClicked_PetList_ScrollBtn()
	local self				= PetList
	local listCount = 0
	if 0 == ToClient_getPetUnsealedList() then
		listCount			= ToClient_getPetSealedList() + ToClient_getPetUnsealedList() + 1
	else
		listCount			= ToClient_getPetSealedList() + ToClient_getPetUnsealedList()
	end
	local posByIndex		= 1 / ( listCount - self.listMaxCount )
	local currentIndex		= math.floor( self.scroll:GetControlPos() / posByIndex )
	self.startIndex	= currentIndex
	self:Update( self.startIndex )
end

function petListNew_ShowInfo( petNoStr )
	audioPostEvent_SystemUi(01,40)
	FGlobal_PetInfoNew_Open( tonumber64(petNoStr) )
end

-- 거래소 등록
function petListNew_Regist( petNoStr )
	FGlobal_PetMarketRegist_Show( petNoStr )
	FGlobal_PetListNew_Close()
end

function petListNew_Seal( petNoStr, index )
	audioPostEvent_SystemUi(01,40)

	local self = PetList
	local petNo_s64 = tonumber64(petNoStr)
	FGlobal_PetControl_SealPet( index )	-- 컨트롤 초기화
	ToClient_requestPetSeal( petNo_s64 )
	self.startIndex = 0
	self.scroll:SetControlTop()
	self:Update( self.startIndex )	-- 나중엔 빼야 한다.

	FGlobal_AllSealButtonPosition( self.UnSealDATACount, false )

	-- Panel_MovieGuideButton:SetShow( true )	-- 펫을 보유하고 있지 않으므로 원래 위치로 고정.
	-- Panel_MovieGuideButton:SetPosX( 20 )		-- 펫을 보유하고 있지 않으므로 원래 위치로 고정.
	-- Panel_MovieGuideButton:SetPosX( self.Btn_IconPet:GetSizeX() + 20 ) -- 펫을 보유하고 있으므로 이 위치에 무비버튼을 고정.
	-- Panel_Window_NoPetIcon:SetShow( true )
	-- Panel_Window_NoPetIcon:SetPosX( 10 )
	-- Panel_Window_NoPetIcon:SetPosY( Panel_SelfPlayerExpGage:GetSizeY() * 2 )
	-- FGlobal_PetListNew_NoPet()
end

function FGlobal_petListNew_Seal( petNo, index )
	petListNew_Seal( petNo, index )
end

function petListNew_UnSeal( petNoStr )
	audioPostEvent_SystemUi(01,40)
	
	local self = PetList
	local petNo_s64 = tonumber64(petNoStr)
	
	if maxUnsealCount <= self.UnSealDATACount then		-- 이미 맥스치만큼 뽑았다면 더 이상 못 뽑게 한다!
		Proc_ShowMessage_Ack_WithOut_ChattingMessage( PAGetString(Defines.StringSheet_GAME, "LUA_UNABLE_SUMMON_PET"))
		return
	end

	ToClient_requestPetUnseal( petNo_s64 )
	FGlobal_PetContorl_HungryGaugeUpdate( petNo_s64 )
	self.startIndex = 0
	self.scroll:SetControlTop()
	self:Update( self.startIndex )	-- 나중엔 빼야 한다.

	-- Panel_Window_NoPetIcon:SetShow(false)
	-- FGlobal_PetListNew_NoPet()
	FGlobal_AllSealButtonPosition( self.UnSealDATACount, true )
end
function petListNew_UnRegister( petNoStr )
	audioPostEvent_SystemUi(01,40)

	local self = PetList
	local petNo_s64 = tonumber64(petNoStr)
	ToClient_requestPetUnregister( petNo_s64 )

	self.startIndex = 0
	self.scroll:SetControlTop()
	self:Update( self.startIndex )	-- 나중엔 빼야 한다.
end

function PetListNew_Compose()
	PetCompose_Open()
	composableCheck = true
	PetListNew_IgnoreAllSealButton( true )
	PetList:Update( PetList.startIndex )
end

local composePetNo = function( petNo )
	for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
		local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
		local _petNo = petData._petNo
		
		if petNo == _petNo then
			local petSS = petData:getPetStaticStatus()
			local petTier = petSS:getPetTier() + 1
			return petTier
		end
	end
end

function petListNew_Compose_Set( petNoStr, petRace, sealPetIndex )
	if nil == petComposeNo[0] then
		petComposeNo[0] = tonumber64( petNoStr )
		petImgChange( petComposeNo[0], 0 )
		petCompose._race = petRace
		PetCompose_UpdatePetSkillList()
		composePetTier = composePetNo( petComposeNo[0] )
		PetCompose_SkillSet( sealPetIndex, 1 )
	elseif nil == petComposeNo[1] then
		petComposeNo[1] = tonumber64( petNoStr )
		petImgChange( petComposeNo[1], 1 )
		PetCompose_UpdatePetSkillList()
		PetCompose_SkillSet( sealPetIndex, 2 )
	end
	PetList:Update( PetList.startIndex )
end

local petSkillCheck
function PetCompose_SkillSet( petIndex, uiIndex )
	local self = petCompose
	local petData = ToClient_getPetSealedDataByIndex( petIndex )
	if nil == petData then
		return
	end
	
	local skillMaxCount = ToClient_getPetEquipSkillMax()
	petCompose.skillNoList[0] = nil
	skillLearnCount = 0
	petSkillCheck = {}		-- 겹치는 스킬이 생기면 tooltip이 꼬이므로 제외해준다.
	for skill_idx = 0, skillMaxCount - 1 do
		local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus( skill_idx )
		local isLearn = petData:isPetEquipSkillLearned( skill_idx )
		if true == isLearn and nil ~= skillStaticStatus and true ~= petSkillCheck[skill_idx] then
			skillLearnCount = skillLearnCount + 1
			petSkillCheck[skill_idx] = true

			local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
			if nil ~= skillTypeStaticWrapper and skillLearnCount <= #petCompose.skillSlot then
				local skillNo = skillStaticStatus:getSkillNo()
				petCompose.skillNoList[skillLearnCount] = skill_idx
				petCompose.skillSlot[uiIndex][skillLearnCount]:SetShow( true )		--
				petCompose.skillSlot[uiIndex][skillLearnCount]:SetIgnore( false )
				petCompose.skillSlot[uiIndex][skillLearnCount]:ChangeTextureInfoName( "Icon/" .. skillTypeStaticWrapper:getIconPath() )
				petCompose.skillSlot[uiIndex][skillLearnCount]:addInputEvent( "Mouse_On",	"PetCompose_ShowSkillToolTip( " .. skill_idx .. ", " .. skillLearnCount .. " )" )
				petCompose.skillSlot[uiIndex][skillLearnCount]:addInputEvent( "Mouse_Out",	"PetCompose_HideSkillToolTip()" )
			
				Panel_SkillTooltip_SetPosition(skillNo, petCompose.skillSlot[uiIndex][skillLearnCount], "PetSkill")
			end
		end
	end
	

end

function petListNew_AllSealCheck( petNo_s32 )
	if (nil == checkUnSealList[petNo_s32] or false == checkUnSealList[petNo_s32]) then
		checkUnSealList[petNo_s32] = true
	else
		checkUnSealList[petNo_s32] = false
	end
	petListNew_Save()
	PetList:Update( PetList.startIndex )
end

function petListNew_Save()
	local sealPetCount		= ToClient_getPetSealedList()	-- 맡긴 펫 갯수 리턴

	local maxCount = math.min(9, maxUnsealCount)
	local idx = 0
	for petIndex = 0, sealPetCount-1 do
		local petData	= ToClient_getPetSealedDataByIndex( petIndex )
		local petNo_s32 = Int64toInt32(petData._petNo)
		-- _PA_LOG("LUA", tostring(checkUnSealList[petNo_s32]))
		if checkUnSealList[petNo_s32] then
			-- _PA_LOG("LUA", "PetAllSeal"..tostring(idx))
			ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(CppEnums.GlobalUIOptionType["PetAllSeal"..tostring(idx)], petNo_s32 )
			idx = idx + 1
			if 9 <= idx then
				return
			end
		end
	end
	for index=idx, maxCount do
		ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(CppEnums.GlobalUIOptionType["PetAllSeal"..index], 0)
	end
end

function petListNew_Load()
	checkUnSealList = {}
	local maxCount = 9

	for idx=0, maxCount do
		local petNo_s32 = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType["PetAllSeal"..idx])
		if 0 ~= petNo_s32 then
			checkUnSealList[petNo_s32] = true
		end
	end
	
end

function petListNew_CehckThis( petNo )
	local checkValue = false
	for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
		local petData	= ToClient_getPetSealedDataByIndex(sealPetIndex)
		local _petNo	= petData._petNo

		if petNo == _petNo then
			checkValue = true
		else
			checkValue = false
		end
	end
	return checkValue
end

function petImgChange( petNo, index )
	for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
		local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
		local _petNo = petData._petNo
		
		if petNo == _petNo then
			local petSS = petData:getPetStaticStatus()
			local iconPath = petData:getIconPath()
			if 0 == index then
				-- petCompose.composePetSlot_1:ChangeTextureInfoName( iconPath )
				-- petCompose.composePetSlot_1:SetShow( true )
				petCompose.icon_1:ChangeTextureInfoName( iconPath )
				petCompose.icon_1:SetShow( true )
			elseif 1 == index then
				-- petCompose.composePetSlot_2:ChangeTextureInfoName( iconPath )
				-- petCompose.composePetSlot_2:SetShow( true )
				petCompose.icon_2:ChangeTextureInfoName( iconPath )
				petCompose.icon_2:SetShow( true )
			end
		end
	end
end

function HandleClicked_PetCompose_ClearEdit()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	petCompose.editName:SetMaxInput( getGameServiceTypePetNameLength() )
	SetFocusEdit( petCompose.editName )
	petCompose.editName:SetEditText( "", true )
end

function Confirm_PetCompose()
	ClearFocusEdit( petCompose.editName )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)

	local petName = petCompose.editName:GetEditText()
	if "" == petName or petComposeString == petName then
		Proc_ShowMessage_Ack( petComposeString )
		return
	-- elseif then
	end

	if nil ~= petComposeNo[1] then
		local confirm_compose = function()
			if petCompose.preserveSkillNo == nil then
				petCompose.preserveSkillNo = ToClient_getPetEquipSkillMax()
			end
			
			local isInherit = 0
			local isLookChange = 0
			local petNo_1 = petComposeNo[0]
			local petNo_2 = petComposeNo[1]
			if petCompose.radioBtn_PetSkill_1:IsCheck() then
				isInherit = 2
			elseif petCompose.radioBtn_PetSkill_2:IsCheck() then
				isInherit = 1
			end
			if petCompose.radioBtn_PetLook_1:IsCheck() then
				isLookChange = 2
			elseif petCompose.radioBtn_PetLook_2:IsCheck() then
				isLookChange = 1
			end
			
			ToClient_requestPetFusion( petName, petNo_1, petNo_2, isInherit, isLookChange )	-- 4번째 인자가 0 : 계승 안함, 1 : 오른쪽펫, 2 : 왼쪽펫
			PetList.scroll:SetControlTop()
			Panel_Window_PetCompose_Close()
		end
		
		local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_MSGCONTENT")	-- "교환에 사용한 애완동물은 사라지고, 새로운 애완동물 한 마리가 생성됩니다. 계속하시겠습니까?"
		local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "PANEL_SERVANTMIX_TITLE"), content = messageBoxMemo, functionYes = confirm_compose, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_REGIST"))
		return
	end
	
end

function Panel_Window_PetCompose_Close()
	PetCompose_Init()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	Panel_Window_PetCompose:SetShow( false )
	PetList:Update( PetList.startIndex )
	
	PetListNew_IgnoreAllSealButton( false )
end

function PetCompose_Init()
	petComposeNo[0] = nil
	petComposeNo[1] = nil
	petCompose._race = nil
	petCompose.icon_1:ChangeTextureInfoName( "" )
	petCompose.icon_2:ChangeTextureInfoName( "" )
	petCompose.icon_3:ChangeTextureInfoName( "" )
	petCompose.icon_1:SetShow( false )
	petCompose.icon_2:SetShow( false )
	petCompose.icon_3:SetShow( false )
	composableCheck = false
	petCompose.preserveSkillNo	= nil
	ClearFocusEdit( petCompose.editName )
	petCompose.radioBtn_PetSkill_1:SetCheck( false )
	petCompose.radioBtn_PetSkill_2:SetCheck( false )
	petCompose.radioBtn_PetSkill_3:SetCheck( true )
	petCompose.radioBtn_PetLook_1:SetCheck( false )
	petCompose.radioBtn_PetLook_2:SetCheck( false )
	petCompose.radioBtn_PetLook_3:SetCheck( true )
	
	for index = 1, 3 do
		petCompose.skillSlotBg[index][1]:SetShow( true )
		petCompose.skillSlotBg[index][2]:SetShow( true )
		petCompose.skillSlotBg[index][3]:SetShow( true )
		petCompose.skillSlot[index][1]:SetShow( false )
		petCompose.skillSlot[index][2]:SetShow( false )
		petCompose.skillSlot[index][3]:SetShow( false )
	end
	PetCompose_UpdatePetSkillList()
end

function CheckCompose()
	return composableCheck
end

local petSkillCheck
function PetCompose_UpdatePetSkillList()
	local petNo0 = petComposeNo[0]
	local petNo1 = petComposeNo[1]
	
	PetComposeSkill_Init()
	petCompose.skillNoList[0] = nil

	petSkillCheck = {}		-- 겹치는 스킬이 생기면 tooltip이 꼬이므로 제외해준다.
	
	local havePetSkillCheck = function( petNo )
		if petNo ~= nil then
			local skillLearnCount = 0
			local skillMaxCount = ToClient_getPetEquipSkillMax()
			for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
				local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
				local _petNo = petData._petNo
				if _petNo ~= nil and petNo == _petNo then
					for skill_idx = 0, skillMaxCount - 1 do
						local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus( skill_idx )
						local isLearn = petData:isPetEquipSkillLearned( skill_idx )
						if true == isLearn and nil ~= skillStaticStatus and true ~= petSkillCheck[skill_idx] then
							skillLearnCount = skillLearnCount + 1
							petSkillCheck[skill_idx] = true

							local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
							if nil ~= skillTypeStaticWrapper and skillLearnCount <= #petCompose.skillSlot then
								local skillNo = skillStaticStatus:getSkillNo()
								petCompose.skillNoList[skillLearnCount] = skill_idx
								-- petCompose.skillSlotBg[3][skillLearnCount]:SetShow( true )	--
								petCompose.skillSlot[3][skillLearnCount]:SetShow( true )		--
								petCompose.skillSlot[3][skillLearnCount]:SetIgnore( false )
								petCompose.skillSlot[3][skillLearnCount]:ChangeTextureInfoName( "Icon/" .. skillTypeStaticWrapper:getIconPath() )
								petCompose.skillSlot[3][skillLearnCount]:addInputEvent( "Mouse_On",	"PetCompose_ShowSkillToolTip( " .. skill_idx .. ", " .. skillLearnCount .. " )" )
								petCompose.skillSlot[3][skillLearnCount]:addInputEvent( "Mouse_Out",	"PetCompose_HideSkillToolTip()" )
							
								Panel_SkillTooltip_SetPosition(skillNo, petCompose.skillSlot[3][skillLearnCount], "PetSkill")
							end
						end
					end
				end
			end
		end
	end
	
	if petCompose.radioBtn_PetSkill_1:IsCheck() and nil ~= petNo0 then
		havePetSkillCheck( petNo0 )
	elseif petCompose.radioBtn_PetSkill_2:IsCheck() and nil ~= petNo1 then
		havePetSkillCheck( petNo1 )
	end
	
	local petIconChange = function( petNo )
		for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
			local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
			local _petNo = petData._petNo
			if _petNo == petNo then
				local iconPath = petData:getIconPath()
				petCompose.icon_3:ChangeTextureInfoName( iconPath )
				petCompose.icon_3:SetShow( true )
			end
		end
	end
	
	petCompose.icon_question:SetShow( false )
	if petCompose.radioBtn_PetLook_1:IsCheck() and nil ~= petNo0 then
		petIconChange( petNo0 )
	elseif petCompose.radioBtn_PetLook_2:IsCheck() and nil ~= petNo1 then
		petIconChange( petNo1 )
	else
		petCompose.icon_question:SetShow( true )
	end
end

function PetComposeSkill_Init()
	for ii, aSkillSlot in pairs( petCompose.skillSlot[3] ) do
		aSkillSlot:SetShow( false )
		aSkillSlot:addInputEvent( "Mouse_On", "" )
		aSkillSlot:addInputEvent( "Mouse_Out", "" )
	end
end

function PetCompose_ShowSkillToolTip( skill_idx, uiIdx )
	local skillStaticStatus			= ToClient_getPetEquipSkillStaticStatus( skill_idx )
	local skillTypeStaticWrapper	= skillStaticStatus:getSkillTypeStaticStatusWrapper()
	local petSkillNo				= skillStaticStatus:getSkillNo()
	local uiBase					= petCompose.skillSlot[uiIdx]

	Panel_SkillTooltip_Show(petSkillNo, false, "PetSkill")
end

function PetCompose_HideSkillToolTip()
	Panel_SkillTooltip_Hide()
end

function PetListNew_SimpleTooltip( isShow )
	local name, desc, control = nil, nil, nil

	name	= PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLISTNEW_ALLSEAL")
	desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PETLIST_ALLSEAL_MAX4_DESC")
	control	= PetList.BTN_AllSeal

	registTooltipControl(control, Panel_Tooltip_SimpleText)
	if isShow == true then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function FGlobal_CheckEditBox_PetCompose( uiEditBox )
	return ( nil ~= uiEditBox ) and ( nil ~= petCompose.editName ) and ( uiEditBox:GetKey() == petCompose.editName:GetKey() )
end
function FGlobal_EscapeEditBox_PetCompose( bool )
	-- petCompose.editName:OutEditInputMode( bool )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	ClearFocusEdit( petCompose.editName )
end

function PetCompose_Open()
	Panel_Window_PetCompose:SetShow( true )
	Panel_Window_PetCompose:SetPosX( Panel_Window_PetListNew:GetPosX() + Panel_Window_PetListNew:GetSizeX() + 10 )
	Panel_Window_PetCompose:SetPosY( Panel_Window_PetListNew:GetPosY() )
	PetCompose_Init()
	petCompose.editName:SetEditText( petComposeString )
	PetList:Update( PetList.startIndex )
	petSkillList_Close()
	composePetTier = 0
end

function FGlobal_PetListNew_Open()
	PetList:Open()
	-- PetList:SetScroll()
end

function FGlobal_PetListNew_Close()
	PetList:Close()
	Panel_Window_PetCompose_Close()
	PetListNew_IgnoreAllSealButton( false )
end

function PetListNew_IgnoreAllSealButton( isShow )
	PetList.BTN_AllSeal:SetIgnore( isShow )
	PetList.BTN_AllSeal:SetMonoTone( isShow )	
end

function FGlobal_PetListNew_Toggle()
	if Panel_Window_PetListNew:GetShow() then
		PetList:Close()
		Panel_Window_PetCompose_Close()
	else
		PetList:Open()
		audioPostEvent_SystemUi(01,40)
		-- 창고 정보를 갱신해주자
	
		local regionInfoWrapper = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfoWrapper then
			return
		end
		local myAffiliatedTownRegionKey = regionInfoWrapper:getAffiliatedTownRegionKey()
		local mainTownRegionWrapper = getRegionInfoWrapper(myAffiliatedTownRegionKey)
		local wayPointKey = mainTownRegionWrapper:getPlantKeyByWaypointKey():getWaypointKey()
		warehouse_requestInfo(wayPointKey)
	end
end

function FGlobal_HandleClicked_PetMarket_Show()
	PetAuction_Open()
	requestPetList()
	if Panel_Window_PetListNew:GetShow() then
		FGlobal_PetListNew_Close()
	end
	--PetMarket_Show()
end
-- 펫 모두 찾기
function FGlobal_HandleClicked_petControl_AllSeal()
	local sealPetCount		= ToClient_getPetSealedList()	-- 맡긴 펫 갯수 리턴
	local unSealPetCount	= ToClient_getPetUnsealedList() -- 찾은 펫 갯수 리턴
	if maxUnsealCount <= unSealPetCount then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_UNABLE_SUMMON_PET") ) -- "더 이상 애완동물을 찾을 수 없습니다."
	end
	if 0 == sealPetCount then
		return
	end
	for petIndex = 0, sealPetCount-1 do
		local petData	= ToClient_getPetSealedDataByIndex( petIndex )
		local petNo_s64	= petData._petNo
		if checkUnSealList[Int64toInt32(petNo_s64)] then
			petListNew_UnSeal( tostring(petNo_s64) )
		end
	end
end

function FromClient_PetUpdate()
	PetList:Update( PetList.startIndex )
	if 5 ~= getGameServiceType() and 6 ~= getGameServiceType() then
		PetInfoInit_ByPetNo()
	end
	FGlobal_PetControl_CheckUnSealPet()
	PetList:SetScroll()
end

function FromClient_PetUpdate_ButtonShow( petNo )
	PetList:Update( PetList.startIndex )
	PetInfoInit_ByPetNo()
	FGlobal_PetControl_CheckUnSealPet( petNo )
	PetList:SetScroll()
	PetControl_Show()
end

function FGlobal_PetListNew_NoPet()
	if isFlushedUI() then
		return
	end
	
	local petCount			= ToClient_getPetSealedList()	-- 맡겨진 펫 갯수 리턴
	local unSealPetCount	= ToClient_getPetUnsealedList() -- 찾은 펫 갯수 리턴
	local PcPetData 		= ToClient_getPetUnsealedDataByIndex( 0 )
	
	if 0 == unSealPetCount then
		FGlobal_PetHungryAlert( false )
	end
	
	-- if 0 == petCount and nil ~= PcPetData then		-- 등록한 펫이 1개인데 찾은 상태일 때(펫을 1개만 등록한 상태)
		-- Panel_Window_PetIcon:SetShow( false )
	-- elseif 0 < petCount and nil == PcPetData then	-- 등록한 펫이 있지만 펫이 맡겨진 상태일 때(등록한 펫이 있을 때)
		-- Panel_Window_PetIcon:SetShow( true )
		-- Panel_Window_PetIcon:SetPosX( 10 )
		-- Panel_Window_PetIcon:SetPosY( Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15 )
		-- Panel_MovieGuideButton:SetPosX( 67 )
	-- elseif 0 < petCount and nil ~= PcPetData then		-- 등록한 펫도 있고 찾은 펫도 있을 때(펫이 2마리 이상 보유했을 때)
		-- Panel_Window_PetIcon:SetShow( false )
	if 0 == petCount and nil == PcPetData then	-- 찾은말도 등록한 말도 없는 펫 미보유일 때( 펫이 아예 없을 때 )
		Panel_Window_PetIcon:SetShow( false )
	else
		Panel_Window_PetIcon:SetShow( true )
		local iconCount = FGlobal_HouseIconCount() + FGlobal_ServantIconCount()
		local posX, posY
		if 0 < FGlobal_HouseIconCount() and Panel_MyHouseNavi:GetShow() then
			posX = Panel_MyHouseNavi:GetPosX() + 60 * FGlobal_HouseIconCount() - 3
			posY = Panel_MyHouseNavi:GetPosY() - 2
		elseif 0 < FGlobal_ServantIconCount() and Panel_Window_Servant:GetShow() then
			posX = Panel_Window_Servant:GetPosX() + 60 * FGlobal_ServantIconCount() - 3
			posY = Panel_Window_Servant:GetPosY() - 2
		else
			posX = 10
			posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
		end
		Panel_Window_PetIcon:SetPosX( posX )
		Panel_Window_PetIcon:SetPosY( posY )
	end
	FGlobal_MaidIcon_SetPos()
end
Panel_MyHouseNavi_Update( true )

function PetList:registEventHandler()
	self.panelBG		:addInputEvent("Mouse_DownScroll",		"PetListNew_ScrollEvent( true )")
	self.panelBG		:addInputEvent("Mouse_UpScroll",		"PetListNew_ScrollEvent( false )")
	self.scrollCtrBTN	:addInputEvent("Mouse_DownScroll",		"PetListNew_ScrollEvent( true )")
	self.scrollCtrBTN	:addInputEvent("Mouse_UpScroll",		"PetListNew_ScrollEvent( false )")
	self.scroll			:addInputEvent("Mouse_DownScroll",		"PetListNew_ScrollEvent( true )")
	self.scroll			:addInputEvent("Mouse_UpScroll",		"PetListNew_ScrollEvent( false )")

	self.BTN_Close		:addInputEvent("Mouse_LUp",				"FGlobal_PetListNew_Close()")
	self.scrollCtrBTN	:addInputEvent("Mouse_LPress",			"HandleClicked_PetList_ScrollBtn()")
	self.scroll			:addInputEvent("Mouse_LUp",				"HandleClicked_PetList_ScrollBtn()")
	self.BTN_Compose	:addInputEvent("Mouse_LUp",				"PetListNew_Compose()" )
	self.BTN_AllUnSeal	:addInputEvent("Mouse_LUp",				"FGlobal_HandleClicked_petControl_AllUnSeal()")
	self.BTN_AllSeal	:addInputEvent("Mouse_LUp",				"FGlobal_HandleClicked_petControl_AllSeal()")
	self.BTN_Market		:addInputEvent("Mouse_LUp",				"FGlobal_HandleClicked_PetMarket_Show()")
end

function PetList:registMessageHandler()
	registerEvent("FromClient_PetAddSealedList",		"FromClient_PetUpdate")	-- 인자 petNo
	registerEvent("FromClient_PetDelSealedList",		"FromClient_PetUpdate_ButtonShow")	-- 인자 petNo
	registerEvent("FromClient_PetAddList",				"FromClient_PetUpdate")	-- 인자 petNo
	registerEvent("FromClient_PetDelList",				"FromClient_PetUpdate")	-- 인자 petNo
	registerEvent("FromClient_InputPetName",			"FromClient_PetUpdate")	-- 인자 ( fromWhereType, fromSlotNo )	petregister에서 써야 함.
	registerEvent("FromClient_PetAddSealedList",		"FGlobal_PetListNew_NoPet")
	registerEvent("FromClient_PetInfoChanged",			"FGlobal_PetListNew_NoPet")
	registerEvent("FromClient_PetInfoChanged",			"FromClient_PetUpdate")
	registerEvent("FromClient_PetAddList",				"FGlobal_PetListNew_NoPet")
end


PetList:Initialize()
petListNew_Load()
FGlobal_PetListNew_NoPet()
PetList:registEventHandler()
PetList:registMessageHandler()
UI.addRunPostRestorFunction( FGlobal_PetListNew_NoPet )

-- getPetSealedList : 맡겨져있는 펫 리스트데이타 (리턴 : 갯수)
-- getPetSealedDataByIndex : 인덱스로 실제 데이터 뺴오기(리턴 PetSealData : _characterKey)
	-- getCharacterStaticStatus
	-- getPetStaticStatus
-- getPetUnsealedList : 찾아져있는 펫리스트(리턴:갯수)
-- getPetUnsealedDataByIndex : 인덱스에 해당하는 찾아져있는 펫 데이터(리턴 : PcPetData)

-- PcPetData : getCharacterKey()
-- getPetStaticStatus()
-- getCharacterStaticStatus()
-- getPcPetNo()
-- getLevel()
-- getExperience()
-- getMaxExperience()
-- getLovely() - 애정도
-- getHungry() - 배고픔
-- isPetActionLearned(0~9) 까지 펫 고유액션 배웠는지여부

-- - PetStaticStatus : 
--  _type, 
--  _level
--  isPassiveSkill()
--  getCoolTime()
 
-- requestPetUnegister(petNo) : 방생
-- requestPetSeal(petNo) : 맡기기
-- requestPetUnseal(petNo) : 찾기

-- ToClient_callHandlerToPet("handleDefenceMode") 이런식으로... 

-- 따라와,     (handlePetFollowMaster)
-- 기다려      (handlePetWaitMaster)
-- 주워,      (handlePetGetItemOn)
-- 주워,      (handlePetGetItemOff)
-- 찾아,      (handlePetFindThatOn)
-- 찾아,      (handlePetFindThatOff)
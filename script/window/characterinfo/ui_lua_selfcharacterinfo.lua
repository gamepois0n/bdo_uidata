local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode
local UI_color 		= Defines.Color
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM			= CppEnums.TextMode

--------------------------------------------
-- 패널 초기화
--------------------------------------------
Panel_Window_CharInfo_Status:SetShow(false)
Panel_Window_CharInfo_Status:setMaskingChild(true)
Panel_Window_CharInfo_Status:ActiveMouseEventEffect(true)
Panel_Window_CharInfo_Status:setGlassBackground(true)
Panel_Window_CharInfo_Status:SetDragEnable(true)

Panel_Window_CharInfo_Status:RegisterShowEventFunc( true, 'CharInfoStatusShowAni()' )
Panel_Window_CharInfo_Status:RegisterShowEventFunc( false, 'CharInfoStatusHideAni()' )

Panel_Window_CharInfo_BasicStatus:SetShow( false )


local CharacterInfo =
{
	_frameDefaultBG_Basic				= UI.getChildControl(Panel_Window_CharInfo_Status,		"Static_BasicInfo"),
	_frameDefaultBG_Title				= UI.getChildControl(Panel_Window_CharInfo_Status,		"Static_TitleInfo"),
	_frameDefaultBG_History				= UI.getChildControl(Panel_Window_CharInfo_Status,		"Static_HistoryInfo"),
	_frameDefaultBG_Challenge			= UI.getChildControl(Panel_Window_CharInfo_Status,		"Static_ChallengeInfo"),

	BTN_Tab_Basic						= UI.getChildControl(Panel_Window_CharInfo_Status,		"RadioButton_Tab_CharacterInfo"),
	BTN_Tab_Title						= UI.getChildControl(Panel_Window_CharInfo_Status,		"RadioButton_Tab_CharacterTitle"),
	BTN_Tab_History						= UI.getChildControl(Panel_Window_CharInfo_Status,		"RadioButton_Tab_CharacterHistory"),
	BTN_Tab_Challenge					= UI.getChildControl(Panel_Window_CharInfo_Status,		"RadioButton_Tab_Challenge"),
	
	txt_BaseInfo_Title					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Title_Base_Title"),

	txt_CharinfoDesc					= UI.getChildControl(Panel_Window_CharInfo_Status,		"StaticText_CharinfoDesc"),
	txt_TitleDesc						= UI.getChildControl(Panel_Window_CharInfo_Status,		"StaticText_TitleDesc"),
	txt_HistoryDesc						= UI.getChildControl(Panel_Window_CharInfo_Status,		"StaticText_HistoryDesc"),
	txt_ChallengeDesc					= UI.getChildControl(Panel_Window_CharInfo_Status,		"StaticText_ChallengeDesc"),

	_familyname 						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FamilyName_Value"),
	_charactername 						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CharacterName_Value"),
	_zodiac		 						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Zodiac_Value"),
	_tendency			 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Tendency_Value"),
	_mental				 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Mental_Value"),
	_contribution		 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Contribution_Value"),
	_characterlevel		 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_BattleLevel_Value"),
	_progress2_characterlevel			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_BattleLevel_Gauge"),
	
	_hpTitle							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HP_Title"),
	_hpvalue							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HP_Value"),
	_progress2_hp						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_HP_Gauge"),
	_mpTitle			 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_MP_Title"),
	_mpvalue			 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_MP_value"),
	_progress2_mp						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_MP_Gauge"),
	_weightTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Weight_Title"),
	_weightvalue		 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Weight_Value"),
	_progress2_weightvalue_Money		= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Weight_Money"),
	_progress2_weightvalue_Equip		= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Weight_Equip"),
	_progress2_weightvalue_Inventory	= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Weight_Inventory"),
	_stungaugeTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_StunGauge_TItle"),
	_stungauge			 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_StunGauge_Value"),
	_stungaugeBG						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_StunGaugeBG"),
	_progress2_stungauge				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_StunGauge_Gauge"),
	_attackTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AttackPower_Title"),
	_attack				 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AttackPower_Value"),
	_defenceTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Defence_Title"),
	_defence			 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Defence_Value"),
	_staminaTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Stamina_Title"),
	_stamina			 				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Stamina_Value"),

--{ Regist
	_stunTitle							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ResistStun_Title"),
	_downTitle							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ResistDown_Title"),
	_captureTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ResistCapture_Title"),
	_knockBackTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ResistKnockback_Title"),
--}

--{ Regist_Percent
	_stunPercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RegistStun_Percent"),
	_downPercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RegistDown_Percent"),
	_capturePercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RegistCapture_Percent"),
	_knockBackPercent					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_RegistKnockBack_Percent"),
--}

	_gatherTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GatheringLevel_Title"),
	_gather					 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GatheringLevel_Value"),
	_gatherPercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GatheringPercent_Value"),
	_progress2_gather					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_GatheringLevel_Gauge"),
	_manufactureTitle					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ManufactureLevel_Title"),
	_manufacture						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ManufactureLevel_Value"),
	_manufacturePercent					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_ManufacturePercent_Value"),
	_progress2_manufacture				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ManufactureLevel_Gauge"),
	_cookingTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CookingLevel_Title"),
	_cooking				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CookingLevel_Value"),
	_cookingPercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CookingPercent_Value"),
	_progress2_cooking					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_CookingLevel_Gauge"),
	_alchemyTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AlchemyLevel_Title"),
	_alchemy				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AlchemyLevel_Value"),
	_alchemyPercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_AlchemyPercent_Value"),
	_progress2_alchemy					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_AlchemyLevel_Gauge"),
	_fishingTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FishingLevel_Title"),
	_fishing				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FishingLevel_Value"),
	_fishingPercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FishingPercent_Value"),
	_progress2_fishing					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_FishingLevel_Gauge"),
	_huntingTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HuntingLevel_Title"),
	_hunting				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HuntingLevel_Value"),
	_huntingPercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HuntingPercent_Value"),
	_progress2_hunting					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_HuntingLevel_Gauge"),
	_trainingTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_TrainingLevel_Title"),
	_training				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_TrainingLevel_Value"),
	_trainingPercent					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_TrainingPercent_Value"),
	_progress2_training					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_TrainingLevel_Gauge"),
	_tradeTitle							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Trade"),
	_trade					 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Trade_Value"),
	_tradePercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_TradePercent_Value"),
	_progress2_trade					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Trade"),
	_growthTitle						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GrowthLevel_Title"),
	_growth								= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GrowthLevel_Value"),
	_growthPercent						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_GrowthPercent_Value"),
	_progress2_growth					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_GrowthLevel_Gauge"),


	-- Templete
	attackspeed				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_AttackSpeed_Title"),
	_asttackspeed		 	 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_AttackSpeed_Value"),
	castspeed				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_CastingSpeed_Title"),
	_castspeed		 		 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_CastingSpeed_Value"),
	movespeed				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_MoveSpeed_Title"),
	_movespeed	 			 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_MoveSpeed_Value"),
	critical				 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_Critical_Title"),
	_critical	 			 			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Potential_Critical_Value"),
	fishTime							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Poten_FishTime"),
	_fishTime	 						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_FishTime_Grade"),
	product								= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Poten_Product"),
	_product		 					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Product_Grade"),
	dropChance							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Poten_DropChance"),
	_dropChance		 					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_DropChance_Grade"),

	-- Templete
	_potentialSlot						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_PotentialSlot"),
	_potentialMinusSlot					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_PotentialMinusSlot"),
	_potentialSlotBG					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_PotentialSlotBG"),
	
	_title_stamina						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Stamina_Title" ),
	_title_strength						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Strength_Title" ),
	_title_health						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Health_Title" ),
	_progress2_stamina					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Fitness_Stamina_Gauge"),
	_progress2_strength					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Fitness_Strength_Gauge"),
	_progress2_health					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_Fitness_Health_Gauge"),
	_value_stamina						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Stamina_Value"),
	_value_strength						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Strength_Value"),
	_value_health						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Fitness_Health_Value"),

	_progress2_resiststun				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ResistStun_Gauge"),
	_progress2_resistdown				= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ResistDown_Gauge"),
	_progress2_resistcapture			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ResistCapture_Gauge"),	
	_progress2_resistknockback			= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Progress2_ResistKnockback_Gauge"),
	
	_hpRegen							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_HpRegen"),
	_mpRegen							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_MpRegen"),
	_weightTooltip						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Weight_Tooltip"),
	_potenHelp							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Poten_Help"),	-- 잠재력 툴팁
	
	_buttonClose						= UI.getChildControl(Panel_Window_CharInfo_Status, "Button_Close"),	
	_buttonQuestion						= UI.getChildControl(Panel_Window_CharInfo_Status, "Button_Question"),			--	물음표 버튼

	_selfTimer							= UI.getChildControl(Panel_Window_CharInfo_Status, "StaticText_SelfTimer"),		--	캐릭터 누적 플레이 시간
	_selfTimerIcon						= UI.getChildControl(Panel_Window_CharInfo_Status, "Static_SelfTimerIcon"),		--	흑정령 머리
	_PcRoomTimer						= UI.getChildControl(Panel_Window_CharInfo_Status, "StaticText_PCRoomTimer"),	--	PC방 타이머

	_lifeTitle							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_CraftLevel_Title"),
	_ranker								= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_Ranker"),
	
	-- 자기 소개
	_btnIntroduce						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus,	"Button_Introduce" ),
	_introduce							=
	{
		_bg								= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_IntroduceBg"),
		_title							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "StaticText_Title_Introduce"),
		_textBg							= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Static_MultilineTextBg"),
		_editText						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "MultilineEdit_Introduce"),
		_btnSetIntro					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_SetIntroduce"),
		_btnResetIntro					= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_ResetIntroduce"),
		_closeIntro						= UI.getChildControl(Panel_Window_CharInfo_BasicStatus, "Button_CloseIntroduce"),
	},

	attackspeed_SlotBG					= {},
	attackspeed_Slot					= {},
	attackspeed_MinusSlot				= {},
	castspeed_SlotBG					= {},
	castspeed_Slot						= {},
	castspeed_MinusSlot					= {},
	movespeed_SlotBG					= {},
	movespeed_Slot						= {},
	movespeed_MinusSlot					= {},
	critical_SlotBG						= {},
	critical_Slot						= {},
	critical_MinusSlot					= {},
	fishTime_SlotBG						= {},
	fishTime_Slot						= {},
	fishTime_MinusSlot					= {},
	product_SlotBG						= {},
	product_Slot						= {},
	product_MinusSlot					= {},
	dropChance_SlotBG					= {},
	dropChance_Slot						= {},
	dropChance_MinusSlot				= {},
}

CharacterInfo._potenHelp:SetShow( false )

local potenTooltip = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_CharInfo_Status, "PotenTooltip" )
CopyBaseProperty( CharacterInfo._potenHelp, potenTooltip )
potenTooltip:SetColor( ffffffff )
potenTooltip:SetAlpha( 1.0 )
potenTooltip:SetFontColor( UI_color.C_FFFFFFFF )
potenTooltip:SetAutoResize( true )
potenTooltip:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
potenTooltip:SetShow( false )
potenTooltip:SetNotAbleMasking( true )
local potenCheck = false

local fitnessTooltip = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_CharInfo_Status, "FitnessTooltip" )
CopyBaseProperty( CharacterInfo._potenHelp, fitnessTooltip )
fitnessTooltip:SetColor( ffffffff )
fitnessTooltip:SetAlpha( 1.0 )
fitnessTooltip:SetFontColor( UI_color.C_FFFFFFFF )
fitnessTooltip:SetAutoResize( true )
fitnessTooltip:SetTextMode( CppEnums.TextMode.eTextMode_None )
fitnessTooltip:SetShow( false )
fitnessTooltip:SetNotAbleMasking( true )

local currentPotencial =
	{
		[0] = "Attack_Speed",					-- 공격 속도
		[1] = "Casting_Speed",					-- 시전 속도
		[2] = "Move_Speed",						-- 이동 속도
		[3] = "Critical_Rate",					-- 치명타 확률
		[4] = "Fishing_Rate",					-- 낚시 운
		[5] = "Product_Rate",					-- 채집 운
		[6] = "Drop_Item_Rate",					-- 드롭 아이템 운
	}
	
function CharInfoStatusShowAni()
	-- UIAni.fadeInSCR_Right( Panel_Window_CharInfo_Status )

	local aniInfo1 = Panel_Window_CharInfo_Status:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.12)
	aniInfo1.AxisX = Panel_Window_CharInfo_Status:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_CharInfo_Status:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_CharInfo_Status:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.12)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_CharInfo_Status:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_CharInfo_Status:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end
function CharInfoStatusHideAni()
	-- audioPostEvent_SystemUi(01,01)
	
	-- Panel_Window_CharInfo_Status:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_CharInfo_Status:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

function FGlobal_CharInfoStatusShowAni()
	CharInfoStatusShowAni()
end

function CharacterInfo:Init()
	-- 기본 정보를 컨트롤에 붙힌다.
	self._frameDefaultBG_Basic:MoveChilds(self._frameDefaultBG_Basic:GetID(), Panel_Window_CharInfo_BasicStatus)
	UI.deletePanel(Panel_Window_CharInfo_BasicStatus:GetID())

	self._frameDefaultBG_Title:MoveChilds(self._frameDefaultBG_Title:GetID(), Panel_Window_CharInfo_TitleInfo)
	UI.deletePanel(Panel_Window_CharInfo_TitleInfo:GetID())

	self._frameDefaultBG_History:MoveChilds(self._frameDefaultBG_History:GetID(), Panel_Window_CharInfo_HistoryInfo)
	UI.deletePanel(Panel_Window_CharInfo_HistoryInfo:GetID())

	self._frameDefaultBG_Challenge:MoveChilds(self._frameDefaultBG_Challenge:GetID(), Panel_Window_Challenge)
	UI.deletePanel(Panel_Window_Challenge:GetID())

	self._gatherTitle		:SetIgnore( false )
	self._manufactureTitle	:SetIgnore( false )
	self._cookingTitle		:SetIgnore( false )
	self._alchemyTitle		:SetIgnore( false )
	self._trainingTitle		:SetIgnore( false )
	self._tradeTitle		:SetIgnore( false )
	self._growthTitle		:SetIgnore( false )

	-- 순위 버튼 위치가 타이틀 길이에 대응하도록 수정.
	self._lifeTitle			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_SUBTITLE_CRAFT") )
	self._ranker			:SetPosX( self._lifeTitle:GetTextSizeX() + 35, 438 )

	-- if isGameTypeJapan() then
		-- self._stungaugeBG			:SetShow( true )
		-- self._stungaugeTitle		:SetShow( true )
		-- self._stungauge				:SetShow( true )
		-- self._progress2_stungauge	:SetShow( true )
		-- self._attackTitle			:SetSpanSize( 385, 132 )
		-- self._attack				:SetSpanSize( 605, 127 )
		-- self._defenceTitle			:SetSpanSize( 385, 157 )
		-- self._defence				:SetSpanSize( 605, 152 )
		-- self._staminaTitle			:SetSpanSize( 385, 182 )
		-- self._stamina				:SetSpanSize( 605, 177 )
	-- else
		self._stungaugeBG			:SetShow( false )
		self._stungaugeTitle		:SetShow( false )
		self._stungauge				:SetShow( false )
		self._progress2_stungauge	:SetShow( false )
		self._attackTitle			:SetSpanSize( 385, 107 )
		self._attack				:SetSpanSize( 605, 102 )
		self._defenceTitle			:SetSpanSize( 385, 132 )
		self._defence				:SetSpanSize( 605, 127 )
		self._staminaTitle			:SetSpanSize( 385, 157 )
		self._stamina				:SetSpanSize( 605, 152 )
	-- end

	self._potentialSlotBG:SetSize( 46, self._potentialSlotBG:GetSizeY() )
	self._potentialSlot:SetSize( 44, self._potentialSlot:GetSizeY() )
	for idx = 0, 6, 1 do
		-- 공격속도 프로그레스 만들기
		self.attackspeed_SlotBG[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.attackspeed, "attackSpeed_SlotBG_" .. idx)
		CopyBaseProperty(self._potentialSlotBG, self.attackspeed_SlotBG[idx])
		self.attackspeed_SlotBG[idx]:SetShow( false )
		if 0 == idx then
			self.attackspeed_SlotBG[idx]:SetPosX( 0 )			
		else
			self.attackspeed_SlotBG[idx]:SetPosX( self.attackspeed_SlotBG[idx-1]:GetPosX() + self.attackspeed_SlotBG[idx-1]:GetSizeX() )
		end
		self.attackspeed_SlotBG[idx]:SetPosY( 21 )

		self.attackspeed_Slot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.attackspeed, "attackSpeed_Slot_" .. idx)
		CopyBaseProperty(self._potentialSlot, self.attackspeed_Slot[idx])
		self.attackspeed_Slot[idx]:SetShow( false )
		if 0 == idx then
			self.attackspeed_Slot[idx]:SetPosX( 0 )
		else
			self.attackspeed_Slot[idx]:SetPosX( self.attackspeed_Slot[idx-1]:GetPosX() + self.attackspeed_Slot[idx-1]:GetSizeX() + 2 )
		end
		self.attackspeed_Slot[idx]:SetPosY( 22 )

		self.attackspeed_MinusSlot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.attackspeed, "attackSpeed_MinusSlot_" .. idx)
		CopyBaseProperty(self._potentialMinusSlot, self.attackspeed_MinusSlot[idx])
		self.attackspeed_MinusSlot[idx]:SetShow( false )
		if 0 == idx then
			self.attackspeed_MinusSlot[idx]:SetPosX( 0 )
		else
			self.attackspeed_MinusSlot[idx]:SetPosX( self.attackspeed_MinusSlot[idx-1]:GetPosX() + self.attackspeed_MinusSlot[idx-1]:GetSizeX() + 2 )
		end
		self.attackspeed_MinusSlot[idx]:SetPosY( 22 )

		-- 시전속도 프로그레스 만들기		CastingSpeed
		self.castspeed_SlotBG[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.castspeed, "castspeed_SlotBG_" .. idx)
		CopyBaseProperty(self._potentialSlotBG, self.castspeed_SlotBG[idx])
		self.castspeed_SlotBG[idx]:SetShow( false )
		if 0 == idx then
			self.castspeed_SlotBG[idx]:SetPosX( 0 )
		else
			self.castspeed_SlotBG[idx]:SetPosX( self.castspeed_SlotBG[idx-1]:GetPosX() + self.castspeed_SlotBG[idx-1]:GetSizeX() )
		end
		self.castspeed_SlotBG[idx]:SetPosY( 21 )

		self.castspeed_Slot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.castspeed, "castspeed_Slot_" .. idx)
		CopyBaseProperty(self._potentialSlot, self.castspeed_Slot[idx])
		self.castspeed_Slot[idx]:SetShow( false )
		if 0 == idx then
			self.castspeed_Slot[idx]:SetPosX( 0 )
		else
			self.castspeed_Slot[idx]:SetPosX( self.castspeed_Slot[idx-1]:GetPosX() + self.castspeed_Slot[idx-1]:GetSizeX() + 2 )
		end
		self.castspeed_Slot[idx]:SetPosY( 22 )

		self.castspeed_MinusSlot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.castspeed, "castspeed_MinusSlot_" .. idx)
		CopyBaseProperty(self._potentialMinusSlot, self.castspeed_MinusSlot[idx])
		self.castspeed_MinusSlot[idx]:SetShow( false )
		if 0 == idx then
			self.castspeed_MinusSlot[idx]:SetPosX( 0 )
		else
			self.castspeed_MinusSlot[idx]:SetPosX( self.castspeed_MinusSlot[idx-1]:GetPosX() + self.castspeed_MinusSlot[idx-1]:GetSizeX() + 2 )
		end
		self.castspeed_MinusSlot[idx]:SetPosY( 22 )

		-- 이동속도 프로그레스 만들기		MoveSpeed
		self.movespeed_SlotBG[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.movespeed, "movespeed_SlotBG_" .. idx)
		CopyBaseProperty(self._potentialSlotBG, self.movespeed_SlotBG[idx])
		self.movespeed_SlotBG[idx]:SetShow( false )
		if 0 == idx then
			self.movespeed_SlotBG[idx]:SetPosX( 0 )
		else
			self.movespeed_SlotBG[idx]:SetPosX( self.movespeed_SlotBG[idx-1]:GetPosX() + self.movespeed_SlotBG[idx-1]:GetSizeX() )
		end
		self.movespeed_SlotBG[idx]:SetPosY( 21 )

		self.movespeed_Slot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.movespeed, "movespeed_Slot_" .. idx)
		CopyBaseProperty(self._potentialSlot, self.movespeed_Slot[idx])
		self.movespeed_Slot[idx]:SetShow( false )
		if 0 == idx then
			self.movespeed_Slot[idx]:SetPosX( 0 )
		else
			self.movespeed_Slot[idx]:SetPosX( self.movespeed_Slot[idx-1]:GetPosX() + self.movespeed_Slot[idx-1]:GetSizeX() + 2 )
		end
		self.movespeed_Slot[idx]:SetPosY( 22 )

		self.movespeed_MinusSlot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.movespeed, "movespeed_MinusSlot_" .. idx)
		CopyBaseProperty(self._potentialMinusSlot, self.movespeed_MinusSlot[idx])
		self.movespeed_MinusSlot[idx]:SetShow( false )
		if 0 == idx then
			self.movespeed_MinusSlot[idx]:SetPosX( 0 )
		else
			self.movespeed_MinusSlot[idx]:SetPosX( self.movespeed_MinusSlot[idx-1]:GetPosX() + self.movespeed_MinusSlot[idx-1]:GetSizeX() + 2 )
		end
		self.movespeed_MinusSlot[idx]:SetPosY( 22 )

		-- 치명타 프로그레스 만들기			CriticalRate
		self.critical_SlotBG[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.critical, "critical_SlotBG_" .. idx)
		CopyBaseProperty(self._potentialSlotBG, self.critical_SlotBG[idx])
		self.critical_SlotBG[idx]:SetShow( false )
		if 0 == idx then
			self.critical_SlotBG[idx]:SetPosX( 0 )
		else
			self.critical_SlotBG[idx]:SetPosX( self.critical_SlotBG[idx-1]:GetPosX() + self.critical_SlotBG[idx-1]:GetSizeX() )
		end
		self.critical_SlotBG[idx]:SetPosY( 21 )

		self.critical_Slot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.critical, "critical_Slot_" .. idx)
		CopyBaseProperty(self._potentialSlot, self.critical_Slot[idx])
		self.critical_Slot[idx]:SetShow( false )
		if 0 == idx then
			self.critical_Slot[idx]:SetPosX( 0 )
		else
			self.critical_Slot[idx]:SetPosX( self.critical_Slot[idx-1]:GetPosX() + self.critical_Slot[idx-1]:GetSizeX() + 2 )
		end
		self.critical_Slot[idx]:SetPosY( 22 )

		self.critical_MinusSlot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.critical, "critical_MinusSlot_" .. idx)
		CopyBaseProperty(self._potentialMinusSlot, self.critical_MinusSlot[idx])
		self.critical_MinusSlot[idx]:SetShow( false )
		if 0 == idx then
			self.critical_MinusSlot[idx]:SetPosX( 0 )
		else
			self.critical_MinusSlot[idx]:SetPosX( self.critical_MinusSlot[idx-1]:GetPosX() + self.critical_MinusSlot[idx-1]:GetSizeX() + 2 )
		end
		self.critical_MinusSlot[idx]:SetPosY( 22 )

		-- 낚시능력 프로그레스 만들기		FishingRate
		self.fishTime_SlotBG[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.fishTime, "fishTime_SlotBG_" .. idx)
		CopyBaseProperty(self._potentialSlotBG, self.fishTime_SlotBG[idx])
		self.fishTime_SlotBG[idx]:SetShow( false )
		if 0 == idx then
			self.fishTime_SlotBG[idx]:SetPosX( 0 )
		else
			self.fishTime_SlotBG[idx]:SetPosX( self.fishTime_SlotBG[idx-1]:GetPosX() + self.fishTime_SlotBG[idx-1]:GetSizeX() )
		end
		self.fishTime_SlotBG[idx]:SetPosY( 21 )

		self.fishTime_Slot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.fishTime, "fishTime_Slot_" .. idx)
		CopyBaseProperty(self._potentialSlot, self.fishTime_Slot[idx])
		self.fishTime_Slot[idx]:SetShow( false )
		if 0 == idx then
			self.fishTime_Slot[idx]:SetPosX( 0 )
		else
			self.fishTime_Slot[idx]:SetPosX( self.fishTime_Slot[idx-1]:GetPosX() + self.fishTime_Slot[idx-1]:GetSizeX() + 2 )
		end
		self.fishTime_Slot[idx]:SetPosY( 22 )

		self.fishTime_MinusSlot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.fishTime, "fishTime_MinusSlot_" .. idx)
		CopyBaseProperty(self._potentialMinusSlot, self.fishTime_MinusSlot[idx])
		self.fishTime_MinusSlot[idx]:SetShow( false )
		if 0 == idx then
			self.fishTime_MinusSlot[idx]:SetPosX( 0 )
		else
			self.fishTime_MinusSlot[idx]:SetPosX( self.fishTime_MinusSlot[idx-1]:GetPosX() + self.fishTime_MinusSlot[idx-1]:GetSizeX() + 2 )
		end
		self.fishTime_MinusSlot[idx]:SetPosY( 22 )

		-- 채집능력 프로그레스 만들기		ProductRate
		self.product_SlotBG[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.product, "product_SlotBG_" .. idx)
		CopyBaseProperty(self._potentialSlotBG, self.product_SlotBG[idx])
		self.product_SlotBG[idx]:SetShow( false )
		if 0 == idx then
			self.product_SlotBG[idx]:SetPosX( 0 )
		else
			self.product_SlotBG[idx]:SetPosX( self.product_SlotBG[idx-1]:GetPosX() + self.product_SlotBG[idx-1]:GetSizeX() )
		end
		self.product_SlotBG[idx]:SetPosY( 21 )

		self.product_Slot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.product, "product_Slot_" .. idx)
		CopyBaseProperty(self._potentialSlot, self.product_Slot[idx])
		self.product_Slot[idx]:SetShow( false )
		if 0 == idx then
			self.product_Slot[idx]:SetPosX( 0 )
		else
			self.product_Slot[idx]:SetPosX( self.product_Slot[idx-1]:GetPosX() + self.product_Slot[idx-1]:GetSizeX() + 2 )
		end
		self.product_Slot[idx]:SetPosY( 22 )

		self.product_MinusSlot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.product, "product_MinusSlot_" .. idx)
		CopyBaseProperty(self._potentialMinusSlot, self.product_MinusSlot[idx])
		self.product_MinusSlot[idx]:SetShow( false )
		if 0 == idx then
			self.product_MinusSlot[idx]:SetPosX( 0 )
		else
			self.product_MinusSlot[idx]:SetPosX( self.product_MinusSlot[idx-1]:GetPosX() + self.product_MinusSlot[idx-1]:GetSizeX() + 2 )
		end
		self.product_MinusSlot[idx]:SetPosY( 22 )

		-- 행운 프로그레스 만들기			DropItemRate
		self.dropChance_SlotBG[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.dropChance, "dropChance_SlotBG_" .. idx)
		CopyBaseProperty(self._potentialSlotBG, self.dropChance_SlotBG[idx])
		self.dropChance_SlotBG[idx]:SetShow( false )
		if 0 == idx then
			self.dropChance_SlotBG[idx]:SetPosX( 0 )
		else
			self.dropChance_SlotBG[idx]:SetPosX( self.dropChance_SlotBG[idx-1]:GetPosX() + self.dropChance_SlotBG[idx-1]:GetSizeX() )
		end
		self.dropChance_SlotBG[idx]:SetPosY( 21 )

		self.dropChance_Slot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.dropChance, "dropChance_Slot_" .. idx)
		CopyBaseProperty(self._potentialSlot, self.dropChance_Slot[idx])
		self.dropChance_Slot[idx]:SetShow( false )
		if 0 == idx then
			self.dropChance_Slot[idx]:SetPosX( 0 )
		else
			self.dropChance_Slot[idx]:SetPosX( self.dropChance_Slot[idx-1]:GetPosX() + self.dropChance_Slot[idx-1]:GetSizeX() + 2 )
		end
		self.dropChance_Slot[idx]:SetPosY( 22 )

		self.dropChance_MinusSlot[idx] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self.dropChance, "dropChance_MinusSlot_" .. idx)
		CopyBaseProperty(self._potentialMinusSlot, self.dropChance_MinusSlot[idx])
		self.dropChance_MinusSlot[idx]:SetShow( false )
		if 0 == idx then
			self.dropChance_MinusSlot[idx]:SetPosX( 0 )
		else
			self.dropChance_MinusSlot[idx]:SetPosX( self.dropChance_MinusSlot[idx-1]:GetPosX() + self.dropChance_MinusSlot[idx-1]:GetSizeX() + 2 )
		end
		self.dropChance_MinusSlot[idx]:SetPosY( 22 )
	end

end

function FGlobal_CraftLevel_Replace( lev, lifeType )
	if 1 <= lev and lev <= 10 then
		lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_1") .. lev			-- 초급
	elseif 11 <= lev and lev <= 20 then
		lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_2") .. lev - 10		-- 견습
	elseif 21 <= lev and lev <= 30 then
		lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_3") .. lev - 20		-- 숙련
	elseif 31 <= lev and lev <= 40 then
		lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_4") .. lev - 30		-- 전문
	elseif 41 <= lev and lev <= 50 then
		lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_5") .. lev - 40		-- 장인
	elseif 51 <= lev and lev <= 80 then
		lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_6") .. lev - 50		-- 명장
	elseif 81 <= lev and lev <= 100 then
		lev = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFTLEVEL_GROUP_7") .. lev - 80		-- 도인
	end
	return lev
end

function FGlobal_CraftLevelColor_Replace( lev )
	if 1 <= lev and lev <= 10 then
		levColor = UI_color.C_FFC4C4C4		-- 초급
	elseif 11 <= lev and lev <= 20 then
		levColor = UI_color.C_FF76B24D		-- 견습
	elseif 21 <= lev and lev <= 30 then
		levColor = UI_color.C_FF3B8BBE		-- 숙련
	elseif 31 <= lev and lev <= 40 then
		levColor = UI_color.C_FFEBC467		-- 전문
	elseif 41 <= lev and lev <= 50 then
		levColor = UI_color.C_FFD04D47		-- 장인
	elseif 51 <= lev and lev <= 80 then
		levColor = UI_color.C_FFB23BC7		-- 명장
	elseif 81 <= lev and lev <= 100 then
		levColor = UI_color.C_FF6E5846		-- 도인
	end
	return levColor
end

function FGlobal_CraftType_ReplaceName( typeNo )
	local typeName = nil
	if		0 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_GATHER") -- "채집"
	elseif	1 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FISH") -- "낚시"
	elseif	2 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_HUNT") -- "수렵"
	elseif	3 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_COOK") -- "요리"
	elseif	4 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_ALCHEMY") -- "연금"
	elseif	5 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_MANUFACTURE") -- "가공"
	elseif	6 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_OBEDIENCE") -- "조련"
	elseif	7 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_TRADE") -- "무역"
	elseif	8 == typeNo	then	typeName = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_GROWTH") -- "재배"
	else						typeName = "???"
	end
	return typeName
end

-------------------------------------------------------------------
-- 캐릭터 정보 중 변경 되지 않는 정보 -----------------------------
-------------------------------------------------------------------
function SelfCharacterInfo_UpdateCharacterBasicInfo()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	
	local playerGet = player:get()
	local UI_classType = CppEnums.ClassType
	
	-- (1) 계정명
	local FamiName = player:getUserNickname()	
	CharacterInfo._familyname 					:SetText(tostring(FamiName))
	
	-- (2) 캐릭터명 & 별자리
	local ChaName = player:getOriginalName()
	CharacterInfo._charactername 				:SetText(tostring(ChaName))	
	
	-- (3) 별자리
	if nil ~= player:getZodiacSignOrderStaticStatusWrapper() then
		local ZodiacName = player:getZodiacSignOrderStaticStatusWrapper():getZodiacName()			
		CharacterInfo._zodiac		 				:SetText(tostring(ZodiacName))
	end
end


-------------------------------------------------------------------
-- 소속 영지 -----------------------------
-------------------------------------------------------------------
function SelfCharacterInfo_UpdateAffiliatedTerritory()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	
	local temporaryWrapper = getTemporaryInformationWrapper()
	local affiliatedTerritoryKey = temporaryWrapper:getAffiliatedTerritoryKeyRaw()
	local territoryInfoWrapper = getTerritoryInfoWrapper(affiliatedTerritoryKey)
	local affiliatedterritoryName = PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_AFFILIATEDTERRITORY" )
	if ( nil ~= territoryInfoWrapper ) then
		affiliatedterritoryName = territoryInfoWrapper:getTerritoryName()
	end
	CharacterInfo._affiliatedterritory 			:SetText(tostring(affiliatedterritoryName))
end

-------------------------------------------------------------------
-- 기운 -----------------------------
-------------------------------------------------------------------
function SelfCharacterInfo_UpdateWp()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	
	local Wp = player:getWp()
	local maxWp = player:getMaxWp()
	
	CharacterInfo._mental				 		:SetText( tostring(Wp).." / "..tostring(maxWp) )
end

function SelfCharacterInfo_UpdateExplorePoint()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end

	local territoryKeyRaw 			= getDefaultTerritoryKey()
	local explorePoint				= getExplorePointByTerritoryRaw( territoryKeyRaw )
	
	CharacterInfo._contribution					:SetText ( tostring(explorePoint:getRemainedPoint()) .." / " .. tostring(explorePoint:getAquiredPoint()) ) 
end

function SelfCharacterInfo_UpdateLevel()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	local playerGet = player:get()
	
	local ChaLevel = playerGet:getLevel()
	CharacterInfo._characterlevel		 		:SetText( tostring(ChaLevel) )
	
	local needExp = playerGet:getNeedExp_s64()
	local currentExp = playerGet:getExp_s64()	
	local _const = Defines.s64_const
	local expRate = 0
	
	if _const.s64_10000 < needExp then
		expRate = Int64toInt32( currentExp / ( needExp / _const.s64_100 ))
	elseif _const.s64_0 ~= needExp then
		expRate = Int64toInt32( (currentExp * _const.s64_100) / needExp )
	end
	
	CharacterInfo._progress2_characterlevel		:SetProgressRate( expRate )
end

function SelfCharacterInfo_UpdateMainStatus()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	
	local playerGet = player:get()
	local UI_classType = CppEnums.ClassType
	
	-- HP
	local hp = playerGet:getHp()
	local maxHp = playerGet:getMaxHp()
	local hpRate = hp / maxHp * 100
	
	CharacterInfo._hpvalue						:SetText ( makeDotMoney(hp) .." / " .. makeDotMoney(maxHp) ) 		
	CharacterInfo._progress2_hp					:SetProgressRate( hpRate )
	
	-- MP
	-----------------------------------------
	-- 클래스에 따른 전투 자원 소모명 변경 --
	-----------------------------------------
	if UI_classType.ClassType_Ranger == player:getClassType() then
		CharacterInfo._mpTitle:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_EP" ) )				-- EP
		CharacterInfo._progress2_mp:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Gauges.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( CharacterInfo._progress2_mp, 2, 71, 232, 76 )
		CharacterInfo._progress2_mp:getBaseTexture():setUV(  x1, y1, x2, y2  )
		CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
	elseif (UI_classType.ClassType_Warrior == player:getClassType()) or (UI_classType.ClassType_Giant == player:getClassType() )
		or (UI_classType.ClassType_BladeMaster == player:getClassType()) or (UI_classType.ClassType_BladeMasterWomen == player:getClassType())
		or (UI_classType.ClassType_NinjaWomen == player:getClassType()) or (UI_classType.ClassType_NinjaMan == player:getClassType()) then
		CharacterInfo._mpTitle:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_FP" ) )	 			-- FP
		CharacterInfo._progress2_mp:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Gauges.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( CharacterInfo._progress2_mp, 2, 57, 232, 62 )
		CharacterInfo._progress2_mp:getBaseTexture():setUV(  x1, y1, x2, y2  )
		CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
	elseif UI_classType.ClassType_Sorcerer == player:getClassType() or UI_classType.ClassType_Tamer == player:getClassType() or UI_classType.ClassType_Wizard == player:getClassType() or UI_classType.ClassType_WizardWomen == player:getClassType() then
		CharacterInfo._mpTitle:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MP" ) )				-- MP(정신력)
		CharacterInfo._progress2_mp:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Gauges.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( CharacterInfo._progress2_mp, 2, 64, 232, 69 )
		CharacterInfo._progress2_mp:getBaseTexture():setUV(  x1, y1, x2, y2  )
		CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
	elseif UI_classType.ClassType_Valkyrie == player:getClassType() then
		CharacterInfo._mpTitle:SetText ( PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_BP") )				-- BP(신성력)
		CharacterInfo._progress2_mp:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Gauges.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( CharacterInfo._progress2_mp, 2, 250, 232, 255 )
		CharacterInfo._progress2_mp:getBaseTexture():setUV(  x1, y1, x2, y2  )
		CharacterInfo._progress2_mp:setRenderTexture(CharacterInfo._progress2_mp:getBaseTexture())
	end
	
	local mp = playerGet:getMp()
	local maxMp = playerGet:getMaxMp()		
	local MpRate = mp / maxMp * 100	
	
	CharacterInfo._mpvalue:SetText( makeDotMoney(mp).." / "..makeDotMoney(maxMp) )
	CharacterInfo._progress2_mp:SetProgressRate( MpRate )	
	
	-- 캐릭터 누적 플레이 시간 갱신
	local totalPlayTime = Util.Time.timeFormatting_Minute( Int64toInt32( ToClient_GetCharacterPlayTime() ) )
	CharacterInfo._selfTimer:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	CharacterInfo._selfTimer:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CONTRACT_TIME_BLACKSPIRIT" ) .. "<PAColor0xFFFFC730> " .. totalPlayTime .. "<PAOldColor> " ..
									  PAGetString( Defines.StringSheet_GAME, "LUA_CONTRACT_TIME_ELAPSED" ) )
	-- CharacterInfo._selfTimer:SetSize( CharacterInfo._selfTimer:GetTextSizeX(), CharacterInfo._selfTimer:GetSizeY() )
	CharacterInfo._selfTimer:ComputePos()
	CharacterInfo._selfTimerIcon:SetPosX( CharacterInfo._selfTimer:GetPosX() - CharacterInfo._selfTimerIcon:GetSizeX() )

	local temporaryPCRoomWrapper	= getTemporaryInformationWrapper()
	local isPremiumPcRoom			= temporaryPCRoomWrapper:isPremiumPcRoom()
	if isPremiumPcRoom and ( isGameTypeKorea() or isGameTypeJapan() ) then
		CharacterInfo._PcRoomTimer:SetShow( true )
	else
		CharacterInfo._PcRoomTimer:SetShow( false )
	end
	CharacterInfo._PcRoomTimer:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_PCROOMTIME", "getPcRoomPlayTime", convertStringFromDatetime(ToClient_GetPcRoomPlayTime()) ) ) -- "오늘의 프리미엄 PC방 이용시간 : <PAColor0xFFFFC730>" .. convertStringFromDatetime(ToClient_GetPcRoomPlayTime()) .. "<PAOldColor>" )
	CharacterInfo._PcRoomTimer:ComputePos()
end

CharacterInfo._selfTimer:addInputEvent( "Mouse_LUp", "HandleClicked_SelfTimer_BlackAnimation()" )
function HandleClicked_SelfTimer_BlackAnimation()
	CharacterInfo._selfTimerIcon:ResetVertexAni()
	CharacterInfo._selfTimerIcon:SetVertexAniRun( "Ani_Rotate_New", true )
end

function SelfCharacterInfo_UpdateMainStatusRegen()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end

	local playerGet = player:get()
	local UI_classType = CppEnums.ClassType

	CharacterInfo._hpRegen:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_HPREGEN" ) .. " : " .. tostring(playerGet:getRegenHp()) )
	CharacterInfo._hpRegen:SetSize( CharacterInfo._hpRegen:GetTextSizeX()+10, 30 )

	if UI_classType.ClassType_Ranger == player:getClassType() then
		CharacterInfo._mpRegen:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_EPREGEN" ) .. " : " .. tostring(playerGet:getRegenMp()) )
	elseif (UI_classType.ClassType_Sorcerer == player:getClassType()) or (UI_classType.ClassType_Tamer == player:getClassType())
		or (UI_classType.ClassType_Wizard == player:getClassType()) or (UI_classType.ClassType_WizardWomen == player:getClassType()) then
		CharacterInfo._mpRegen:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MPREGEN" ) .. " : " .. tostring(playerGet:getRegenMp()) )
	elseif UI_classType.ClassType_Valkyrie == player:getClassType() then
		CharacterInfo._mpRegen:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_BPREGEN" ) .. " : " .. tostring(playerGet:getRegenMp()) )
	elseif (UI_classType.ClassType_Warrior == player:getClassType()) or (UI_classType.ClassType_Giant == player:getClassType())
	or (UI_classType.ClassType_BladeMaster == player:getClassType()) or (UI_classType.ClassType_BladeMasterWomen == player:getClassType())
	or (UI_classType.ClassType_NinjaWomen == player:getClassType()) or (UI_classType.ClassType_NinjaMan == player:getClassType()) then
		CharacterInfo._mpRegen:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_FPREGEN" ) .. " : " .. tostring(playerGet:getRegenMp()) )
	end
	CharacterInfo._mpRegen:SetSize( CharacterInfo._mpRegen:GetTextSizeX()+10, 30 )
end

function SelfCharacterInfo_UpdateWeight()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end	
	local _const = Defines.s64_const
	local selfPlayer			= player:get()

	local s64_moneyWeight		= selfPlayer:getInventory():getMoneyWeight_s64()
	local s64_equipmentWeight	= selfPlayer:getEquipment():getWeight_s64()
	local s64_allWeight			= selfPlayer:getCurrentWeight_s64()
	local s64_maxWeight			= selfPlayer:getPossessableWeight_s64()

	local s64_allWeight_div		= s64_allWeight / _const.s64_100
	local s64_maxWeight_div		= s64_maxWeight / _const.s64_100
	
	-- 소수점 1째 자리까지 출력하기 위해 100 으로 나누고 Int32 로 변경해서 100 을 더 나눈다.
	local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 100 )
	local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 100 )
	
	if ( s64_allWeight_div <= s64_maxWeight_div ) then
		CharacterInfo._progress2_weightvalue_Money		:SetProgressRate( Int64toInt32(s64_moneyWeight / s64_maxWeight_div) )
		CharacterInfo._progress2_weightvalue_Equip		:SetProgressRate( Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_maxWeight_div) )
		CharacterInfo._progress2_weightvalue_Inventory	:SetProgressRate( Int64toInt32(s64_allWeight / s64_maxWeight_div) )
	else
		CharacterInfo._progress2_weightvalue_Money		:SetProgressRate( Int64toInt32(s64_moneyWeight / s64_allWeight_div) )
		CharacterInfo._progress2_weightvalue_Equip		:SetProgressRate( Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_allWeight_div) )
		CharacterInfo._progress2_weightvalue_Inventory	:SetProgressRate( Int64toInt32(s64_allWeight / s64_allWeight_div) )
	end
	CharacterInfo._weightvalue						:SetText( tostring(str_AllWeight) .. " / " .. tostring(str_MaxWeight) .." LT" )
end

function SelfCharacterInfo_UpdateStun(rawKey, stun, maxStun)
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	
	local playerGet = player:get()
	
	local currentStunGauge = playerGet:getStun()
	local maxStunGauge = playerGet:getMaxStun()
	local stungaugeRate = currentStunGauge / maxStunGauge * 100
	
	CharacterInfo._stungauge			 	:SetText( tostring(currentStunGauge) .. " / " .. tostring(maxStunGauge) )	
	CharacterInfo._progress2_stungauge		:SetProgressRate( stungaugeRate )
end

function SelfCharacterInfo_UpdateAttackStat()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end

	updateAttackStat()	-- 공격력, 방어력 계산
	
	-- 공격력
	local ChaAttack = getOffence()
	CharacterInfo._attack						:SetText( tostring(ChaAttack) )
	
	-- 방어력
	local ChaDefence = getDefence()
	CharacterInfo._defence						:SetText( tostring(ChaDefence) )
end

function SelfCharacterInfo_UpdateTendency()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	

	local playerGet = player:get()
	local ChaTendency = playerGet:getTendency()

	CharacterInfo._tendency 			:SetText( tostring(ChaTendency) )
end


function SelfCharacterInfo_UpdateStamina()
	CharacterInfo._stamina	 			:SetText( makeDotMoney(getSelfPlayer():get():getStamina():getMaxSp()) )
end

function SelfCharacterInfo_UpdateCraftLevel()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	
	local playerGet = player:get()
	
	-- 2. 생산 등급 : (1) 채집
	local craftType = 
	{
		gather		= 0, -- 채집
		fishing		= 1, -- 낚시
		hunting		= 2, -- 수렵
		cooking		= 3, -- 요리
		alchemy		= 4, -- 연금
		manufacture	= 5, -- 가공
		training	= 6, -- 조련
		trade		= 7, -- 무역
		growth		= 8, -- 재배
		levelText	= PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL"),
	}
	
	local gatherLevel 		= playerGet:getLifeExperienceLevel(craftType.gather)
	local gatherCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.gather)
	local gatherMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.gather)
	local gatherExpRate		= Int64toInt32(gatherCurrentExp * toInt64(0,100) / gatherMaxExp)

	CharacterInfo._gather						:SetText( FGlobal_CraftLevel_Replace( gatherLevel, craftType.gather ) )
	CharacterInfo._gather						:SetFontColor( FGlobal_CraftLevelColor_Replace( gatherLevel ) )
	CharacterInfo._progress2_gather				:SetProgressRate(gatherExpRate)
	CharacterInfo._gatherPercent				:SetText( gatherExpRate .."%" )
	CharacterInfo._gatherPercent				:SetFontColor( FGlobal_CraftLevelColor_Replace( gatherLevel ) )

	-- 2. 생산 등급 : (2) 가공
	local manufatureLevel 		= playerGet:getLifeExperienceLevel(craftType.manufacture)
	local manufatureCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.manufacture)
	local manufatureMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.manufacture)
	local manufatureExpRate		= Int64toInt32(manufatureCurrentExp * toInt64(0,100) / manufatureMaxExp)
		
	CharacterInfo._manufacture					:SetText( FGlobal_CraftLevel_Replace( manufatureLevel, craftType.manufacture ) )
	CharacterInfo._manufacture					:SetFontColor( FGlobal_CraftLevelColor_Replace( manufatureLevel ) )
	CharacterInfo._progress2_manufacture		:SetProgressRate(manufatureExpRate)
	CharacterInfo._manufacturePercent			:SetText( manufatureExpRate .. "%" )
	CharacterInfo._manufacturePercent			:SetFontColor( FGlobal_CraftLevelColor_Replace( manufatureLevel ) )

	-- 2. 생산 등급 : (3) 요리
	local cookingLevel 			= playerGet:getLifeExperienceLevel(craftType.cooking)
	local cookingCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.cooking)
	local cookingMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.cooking)
	local cookingExpRate		= Int64toInt32(cookingCurrentExp * toInt64(0,100) / cookingMaxExp)
		
	CharacterInfo._cooking				 		:SetText( FGlobal_CraftLevel_Replace(cookingLevel, craftType.cooking) )
	CharacterInfo._cooking						:SetFontColor( FGlobal_CraftLevelColor_Replace( cookingLevel ) )
	CharacterInfo._progress2_cooking			:SetProgressRate(cookingExpRate)
	CharacterInfo._cookingPercent				:SetText( cookingExpRate .. "%" )
	CharacterInfo._cookingPercent				:SetFontColor( FGlobal_CraftLevelColor_Replace( cookingLevel ) )

	-- 2. 생산 등급 : (4) 연금
	local alchemyLevel 			= playerGet:getLifeExperienceLevel(craftType.alchemy)
	local alchemyCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.alchemy)
	local alchemyMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.alchemy)
	local alchemyExpRate		= Int64toInt32(alchemyCurrentExp * toInt64(0,100) / alchemyMaxExp)
		
	CharacterInfo._alchemy				 		:SetText( FGlobal_CraftLevel_Replace(alchemyLevel, craftType.alchemy) )
	CharacterInfo._alchemy						:SetFontColor( FGlobal_CraftLevelColor_Replace( alchemyLevel ) )
	CharacterInfo._progress2_alchemy			:SetProgressRate(alchemyExpRate)
	CharacterInfo._alchemyPercent				:SetText( alchemyExpRate .. "%" )
	CharacterInfo._alchemyPercent				:SetFontColor( FGlobal_CraftLevelColor_Replace( alchemyLevel ) )

	-- 2. 생산 등급 : (5)낚시
	local fishingLevel 			= playerGet:getLifeExperienceLevel(craftType.fishing)
	local fishingCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.fishing)
	local fishingMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.fishing)
	local fishingExpRate		= Int64toInt32(fishingCurrentExp * toInt64(0,100) / fishingMaxExp)
	
	CharacterInfo._fishing				 		:SetText( FGlobal_CraftLevel_Replace(fishingLevel, craftType.fishing) )
	CharacterInfo._fishing						:SetFontColor( FGlobal_CraftLevelColor_Replace( fishingLevel ) )
	CharacterInfo._progress2_fishing			:SetProgressRate(fishingExpRate)
	CharacterInfo._fishingPercent				:SetText( fishingExpRate .. "%" )
	CharacterInfo._fishingPercent				:SetFontColor( FGlobal_CraftLevelColor_Replace( fishingLevel ) )

	-- 2. 생산 등급 : (6)수렵
	local huntingLevel 			= playerGet:getLifeExperienceLevel(craftType.hunting)
	local huntingCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.hunting)
	local huntingMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.hunting)
	local huntingExpRate		= Int64toInt32( huntingCurrentExp * toInt64(0,100) / huntingMaxExp )
		
	CharacterInfo._hunting				 		:SetText( FGlobal_CraftLevel_Replace(huntingLevel, craftType.hunting) )
	CharacterInfo._hunting						:SetFontColor( FGlobal_CraftLevelColor_Replace( huntingLevel ) )
	CharacterInfo._progress2_hunting			:SetProgressRate(huntingExpRate)
	CharacterInfo._huntingPercent				:SetText( huntingExpRate .. "%" )
	CharacterInfo._huntingPercent				:SetFontColor( FGlobal_CraftLevelColor_Replace( huntingLevel ) )

	-- 2. 생산 등급 : (7)조련
	local trainingLevel 		= playerGet:getLifeExperienceLevel(craftType.training)
	local trainingCurrentExp 	= playerGet:getCurrLifeExperiencePoint(craftType.training)
	local trainingMaxExp 		= playerGet:getDemandLifeExperiencePoint(craftType.training)
	local trainingExpRate		= Int64toInt32( trainingCurrentExp * toInt64(0,100) / trainingMaxExp )
		
	CharacterInfo._training				 		:SetText( FGlobal_CraftLevel_Replace(trainingLevel, craftType.training) )
	CharacterInfo._training						:SetFontColor( FGlobal_CraftLevelColor_Replace( trainingLevel ) )
	CharacterInfo._progress2_training			:SetProgressRate(trainingExpRate)
	CharacterInfo._trainingPercent				:SetText( trainingExpRate .. "%" )
	CharacterInfo._trainingPercent				:SetFontColor( FGlobal_CraftLevelColor_Replace( trainingLevel ) )

	-- 2. 생산 등급 : (8)무역
	local tradeLevel 			= playerGet:getLifeExperienceLevel(craftType.trade)
	local tradeCurrentExp 		= playerGet:getCurrLifeExperiencePoint(craftType.trade)
	local tradeMaxExp 			= playerGet:getDemandLifeExperiencePoint(craftType.trade)
	local tradeExpRate			= Int64toInt32( tradeCurrentExp * toInt64(0,100) / tradeMaxExp )

	CharacterInfo._trade				 		:SetText( FGlobal_CraftLevel_Replace(tradeLevel, craftType.trade) )
	CharacterInfo._trade						:SetFontColor( FGlobal_CraftLevelColor_Replace( tradeLevel ) )
	CharacterInfo._progress2_trade				:SetProgressRate(tradeExpRate)
	CharacterInfo._tradePercent					:SetText( tradeExpRate .. "%" )
	CharacterInfo._tradePercent					:SetFontColor( FGlobal_CraftLevelColor_Replace( tradeLevel ) )

	-- 2. 생산 등급 : (9)재배
	local growthLevel			= playerGet:getLifeExperienceLevel(craftType.growth)
	local growthCurrentExp		= playerGet:getCurrLifeExperiencePoint(craftType.growth)
	local growthMaxExp			= playerGet:getDemandLifeExperiencePoint(craftType.growth)
	local growthExpRate			= Int64toInt32( growthCurrentExp * toInt64(0,100) / growthMaxExp )

	CharacterInfo._growth				 		:SetText( FGlobal_CraftLevel_Replace(growthLevel, craftType.growth) )
	CharacterInfo._growth						:SetFontColor( FGlobal_CraftLevelColor_Replace( growthLevel ) )
	CharacterInfo._progress2_growth				:SetProgressRate(growthExpRate)
	CharacterInfo._growthPercent				:SetText( growthExpRate .. "%" )
	CharacterInfo._growthPercent				:SetFontColor( FGlobal_CraftLevelColor_Replace( growthLevel ) )
end

function SelfCharacterInfo_UpdatePotenGradeInfo()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	
	local playerGet = player:get()
	
	-- 3. 잠재력 : (1) 공격 속도	
	local potentialType = 
	{
		move	= 0,  -- 이동 속도
		attack	= 1,  -- 공격 속도
		cast	= 2,  -- 시전 속도
		levelText = PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_POTENLEVEL"),
	}

	-- 장비 포인트 계산 ( MaxPoint : 15 / 치명타 피해 확률 : 0부터 / 이외는 기본 5분터 시작 ) 
		
	local currentAttackSpeedPoint = player:characterStatPointSpeed(potentialType.attack)
	local limitAttackSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.attack)

	if (limitAttackSpeedPoint < currentAttackSpeedPoint) then
		currentAttackSpeedPoint = limitAttackSpeedPoint 
	end
	
	local equipedAttackSpeedPoint = currentAttackSpeedPoint - 5
	local maxAttackSpeedPoint = limitAttackSpeedPoint - 5

	for Idx = 0, 6, 1 do	-- 초기화
		CharacterInfo.attackspeed_SlotBG[Idx]:SetShow( false )
		CharacterInfo.attackspeed_Slot[Idx]:SetShow( false )
		CharacterInfo.attackspeed_MinusSlot[Idx]:SetShow( false )
	end
	for bg_Idx = 0, maxAttackSpeedPoint - 1, 1 do	-- BG켜기
		CharacterInfo.attackspeed_SlotBG[bg_Idx]:SetShow( true )
	end
	if 0 < equipedAttackSpeedPoint then
		for slot_Idx = 0, equipedAttackSpeedPoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.attackspeed_Slot[slot_Idx]:SetShow( true )
		end
	else
		local minus_equipedAttackSpeedPoint = -(equipedAttackSpeedPoint)
		for slot_Idx = 0, minus_equipedAttackSpeedPoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.attackspeed_MinusSlot[slot_Idx]:SetShow( true )
		end
	end

	CharacterInfo._asttackspeed					:SetText( tostring(equipedAttackSpeedPoint) .." ".. potentialType.levelText )	
	currentPotencial[0] = equipedAttackSpeedPoint
	
	-- 3. 잠재력 : (2) 시전 속도	
	local currentCastingSpeedPoint = player:characterStatPointSpeed(potentialType.cast)
	local limitCastingSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.cast)
	
	if (limitCastingSpeedPoint < currentCastingSpeedPoint) then
		currentCastingSpeedPoint = limitCastingSpeedPoint 
	end
	
	local equipedCastingSpeedPoint = currentCastingSpeedPoint - 5
	local maxCastingSpeedPoint = limitCastingSpeedPoint - 5
	
	for Idx = 0, 6, 1 do	-- 초기화
		CharacterInfo.castspeed_SlotBG[Idx]:SetShow( false )
		CharacterInfo.castspeed_Slot[Idx]:SetShow( false )
		CharacterInfo.castspeed_MinusSlot[Idx]:SetShow( false )
	end
	for bg_Idx = 0, maxCastingSpeedPoint - 1, 1 do	-- BG켜기
		CharacterInfo.castspeed_SlotBG[bg_Idx]:SetShow( true )
	end
	if 0 < equipedCastingSpeedPoint then
		for slot_Idx = 0, equipedCastingSpeedPoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.castspeed_Slot[slot_Idx]:SetShow( true )
		end
	else
		local minus_equipedCastingSpeedPoint = -(equipedCastingSpeedPoint)
		for slot_Idx = 0, minus_equipedCastingSpeedPoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.castspeed_MinusSlot[slot_Idx]:SetShow( true )
		end
	end
		
	CharacterInfo._castspeed				 	:SetText( tostring(equipedCastingSpeedPoint) .." ".. potentialType.levelText )
	currentPotencial[1] = equipedCastingSpeedPoint
	
	-- 3. 잠재력 : (3) 이동 속도	
	local currentMoveSpeedPoint = player:characterStatPointSpeed(potentialType.move)
	local limitMoveSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.move)
	if (limitMoveSpeedPoint < currentMoveSpeedPoint) then
		currentMoveSpeedPoint = limitMoveSpeedPoint 
	end
	
	local equipedMoveSpeedPoint = currentMoveSpeedPoint - 5
	local maxMoveSpeedPoint = limitMoveSpeedPoint - 5
	
	for Idx = 0, 6, 1 do	-- 초기화
		CharacterInfo.movespeed_SlotBG[Idx]:SetShow( false )
		CharacterInfo.movespeed_Slot[Idx]:SetShow( false )
		CharacterInfo.movespeed_MinusSlot[Idx]:SetShow( false )
	end
	for bg_Idx = 0, maxMoveSpeedPoint - 1, 1 do	-- BG켜기
		CharacterInfo.movespeed_SlotBG[bg_Idx]:SetShow( true )
	end
	if 0 < equipedMoveSpeedPoint then
		for slot_Idx = 0, equipedMoveSpeedPoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.movespeed_Slot[slot_Idx]:SetShow( true )
		end
	else
		local minus_equipedMoveSpeedPoint = -(equipedMoveSpeedPoint)
		for slot_Idx = 0, minus_equipedMoveSpeedPoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.movespeed_MinusSlot[slot_Idx]:SetShow( true )
		end
	end
	CharacterInfo._movespeed				 	:SetText( tostring(equipedMoveSpeedPoint) .." ".. potentialType.levelText )
	currentPotencial[2] = equipedMoveSpeedPoint
	
	-- 3. 잠재력 : (4) 치명타
	local currentCriticalRatePoint = player:characterStatPointCritical()
	local limitCriticalRatePoint = player:characterStatPointLimitedCritical()
	
	if (limitCriticalRatePoint < currentCriticalRatePoint) then
		currentCriticalRatePoint = limitCriticalRatePoint 
	end
	
	local equipedCriticalRatePoint = currentCriticalRatePoint
	local maxCriticalRatePoint = limitCriticalRatePoint
	
	for Idx = 0, 6, 1 do	-- 초기화
		CharacterInfo.critical_SlotBG[Idx]:SetShow( false )
		CharacterInfo.critical_Slot[Idx]:SetShow( false )
		CharacterInfo.critical_MinusSlot[Idx]:SetShow( false )
	end
	for bg_Idx = 0, maxCriticalRatePoint - 1, 1 do	-- BG켜기
		CharacterInfo.critical_SlotBG[bg_Idx]:SetShow( true )
	end
	if 0 < equipedCriticalRatePoint then
		for slot_Idx = 0, equipedCriticalRatePoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.critical_Slot[slot_Idx]:SetShow( true )
		end
	else
		local minus_equipedCriticalRatePoint = -(equipedCriticalRatePoint)
		for slot_Idx = 0, minus_equipedCriticalRatePoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.critical_MinusSlot[slot_Idx]:SetShow( true )
		end
	end
	
	CharacterInfo._critical				 		:SetText( tostring(equipedCriticalRatePoint) .." ".. potentialType.levelText )
	currentPotencial[3] = equipedCriticalRatePoint
	
	-- 3. 잠재력 : (5) 낚시 운
	local currentFishingRatePoint = player:getCharacterStatPointFishing()
	local limitFishingRatePoint = player:getCharacterStatPointLimitedFishing()
	
	if (limitFishingRatePoint < currentFishingRatePoint) then
		currentFishingRatePoint = limitFishingRatePoint 
	end
	
	local equipedFishingRatePoint = currentFishingRatePoint
	local maxFishingRatePoint = limitFishingRatePoint

	for Idx = 0, 6, 1 do	-- 초기화
		CharacterInfo.fishTime_SlotBG[Idx]:SetShow( false )
		CharacterInfo.fishTime_Slot[Idx]:SetShow( false )
		CharacterInfo.fishTime_MinusSlot[Idx]:SetShow( false )
	end
	for bg_Idx = 0, maxFishingRatePoint - 1, 1 do	-- BG켜기
		CharacterInfo.fishTime_SlotBG[bg_Idx]:SetShow( true )
	end
	if 0 < equipedFishingRatePoint then
		for slot_Idx = 0, equipedFishingRatePoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.fishTime_Slot[slot_Idx]:SetShow( true )
		end
	else
		local minus_equipedFishingRatePoint = -(equipedFishingRatePoint)
		for slot_Idx = 0, minus_equipedFishingRatePoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.fishTime_MinusSlot[slot_Idx]:SetShow( true )
		end
	end

	CharacterInfo._fishTime				 		:SetText( tostring(equipedFishingRatePoint) .." ".. potentialType.levelText )
	currentPotencial[4] = equipedFishingRatePoint
	
	-- 3. 잠재력 : (5) 채집 운
	local currentProductRatePoint = player:getCharacterStatPointCollection()
	local limitProductRatePoint = player:getCharacterStatPointLimitedCollection()
	
	if (limitProductRatePoint < currentProductRatePoint) then
		currentProductRatePoint = limitProductRatePoint 
	end
	
	local equipedProductRatePoint = currentProductRatePoint
	local maxProductRatePoint = limitProductRatePoint

	for Idx = 0, 6, 1 do	-- 초기화
		CharacterInfo.product_SlotBG[Idx]:SetShow( false )
		CharacterInfo.product_Slot[Idx]:SetShow( false )
		CharacterInfo.product_MinusSlot[Idx]:SetShow( false )
	end
	for bg_Idx = 0, maxProductRatePoint - 1, 1 do	-- BG켜기
		CharacterInfo.product_SlotBG[bg_Idx]:SetShow( true )
	end
	if 0 < equipedProductRatePoint then
		for slot_Idx = 0, equipedProductRatePoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.product_Slot[slot_Idx]:SetShow( true )
		end
	else
		local minus_equipedProductRatePoint = -(equipedProductRatePoint)
		for slot_Idx = 0, minus_equipedProductRatePoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.product_MinusSlot[slot_Idx]:SetShow( true )
		end
	end
	
	CharacterInfo._product				 		:SetText( tostring(equipedProductRatePoint) .." ".. potentialType.levelText )
	currentPotencial[5] = equipedProductRatePoint
	
	-- 3. 잠재력 : (5) 행운
	local currentDropItemRatePoint = player:getCharacterStatPointDropItem()
	local limitDropItemRatePoint = player:getCharacterStatPointLimitedDropItem()
	
	if (limitDropItemRatePoint < currentDropItemRatePoint) then
		currentDropItemRatePoint = limitDropItemRatePoint 
	end
	
	local equipedDropItemRatePoint = currentDropItemRatePoint
	local maxDropItemRatePoint = limitDropItemRatePoint

	for Idx = 0, 6, 1 do	-- 초기화
		CharacterInfo.dropChance_SlotBG[Idx]:SetShow( false )
		CharacterInfo.dropChance_Slot[Idx]:SetShow( false )
		CharacterInfo.dropChance_MinusSlot[Idx]:SetShow( false )
	end
	for bg_Idx = 0, maxDropItemRatePoint - 1, 1 do	-- BG켜기
		CharacterInfo.dropChance_SlotBG[bg_Idx]:SetShow( true )
	end
	if 0 < equipedDropItemRatePoint then
		for slot_Idx = 0, equipedDropItemRatePoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.dropChance_Slot[slot_Idx]:SetShow( true )
		end
	else
		local minus_equipedDropItemRatePoint = -(equipedDropItemRatePoint)
		for slot_Idx = 0, minus_equipedDropItemRatePoint - 1, 1 do	-- 슬롯켜기
			CharacterInfo.dropChance_Slot[slot_Idx]:SetShow( true )
		end
	end
	
	CharacterInfo._dropChance				 	:SetText( tostring(equipedDropItemRatePoint) .." ".. potentialType.levelText )
	currentPotencial[6] = equipedDropItemRatePoint
end

function CharacterInfoWindowUpdate()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end
	
	local playerGet = player:get()
	local UI_classType = CppEnums.ClassType
	
	-- 1. 기본 정보 : (1) 계정명 (2) 캐릭터명 (3) 별자리
	SelfCharacterInfo_UpdateCharacterBasicInfo()
		
	-- 1. 기본 정보 : (4) 소속 영지명
	-- SelfCharacterInfo_UpdateAffiliatedTerritory()

	-- 1. 기본 정보 : (4) 성향
	SelfCharacterInfo_UpdateTendency()
	
	-- 1. 기본 정보 : (5) 기운
	SelfCharacterInfo_UpdateWp()
	
	-- 1. 기본 정보 : (6) 공헌도
	SelfCharacterInfo_UpdateExplorePoint()	

	-- 1. 기본 정보 : (7) 캐릭터 레벨
	SelfCharacterInfo_UpdateLevel()	
	
	-- 1. 기본 정보 : (8) HP & MP
	SelfCharacterInfo_UpdateMainStatus()

	-- 1. 기본 정보 : (8) HP, MP 회복력 -- HP, MP 오버 시
	SelfCharacterInfo_UpdateMainStatusRegen()
	
	-- 1. 기본 정보 : (10) 무게
	SelfCharacterInfo_UpdateWeight()
	
	-- 1. 기본 정보 : (11) 스턴게이지
	if isGameTypeKorea() or isGameTypeJapan() then
		SelfCharacterInfo_UpdateStun()
	end
	
	-- 1. 기본 정보 : (12) 공격력 (13) 방어력
	SelfCharacterInfo_UpdateAttackStat()
	
	-- 1. 기본 정보 : (14) 스태미나
	SelfCharacterInfo_UpdateStamina()
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------
	SelfCharacterInfo_UpdateTolerance()
	SelfCharacterInfo_UpdateCraftLevel()
	SelfCharacterInfo_UpdatePotenGradeInfo()
	
	-- 4. 내성 : (1) 스턴	
	--local resistStunRate = player:getStunResistance()
	--CharacterInfo._progress2_resiststun			:SetProgressRate(math.floor(resistStunRate / 10000))
	
	-- 4. 내성 : (2) 다운
	--local resistDownRate = player:getKnockdownResistance()
	--CharacterInfo._progress2_resistdown			:SetProgressRate(math.floor(resistDownRate / 10000))
	
	-- 4. 내성 : (3) 잡기
	--local resistCaptureRate = player:getCatchResistance()
	--CharacterInfo._progress2_resistcapture		:SetProgressRate(math.floor(resistCaptureRate / 10000))
	
	-- 4. 내성 : (4) 넉백
	--local resistKnockbackRate = player:getKnockbackResistance()
	--CharacterInfo._progress2_resistknockback	:SetProgressRate(math.floor(resistKnockbackRate / 10000))
end


function HandleClicked_CharacterInfo_Tab( index )
	if nil == index then
		return
	end
	
	IntroduceMyself_ShowToggle( false )

	local self = CharacterInfo
	self._frameDefaultBG_Basic		:SetShow( false )
	self._frameDefaultBG_Title		:SetShow( false )
	self._frameDefaultBG_History	:SetShow( false )
	self._frameDefaultBG_Challenge	:SetShow( false )

	CharacterInfo.BTN_Tab_Basic		:SetCheck( false )
	CharacterInfo.BTN_Tab_Title		:SetCheck( false )
	CharacterInfo.BTN_Tab_History	:SetCheck( false )
	CharacterInfo.BTN_Tab_Challenge	:SetCheck( false )

	if 0 == index then
		self._frameDefaultBG_Basic		:SetShow( true )
		CharacterInfo.BTN_Tab_Basic		:SetCheck( true )
		CharacterInfo.BTN_Tab_Title		:SetCheck( false )
		CharacterInfo.BTN_Tab_History	:SetCheck( false )
		CharacterInfo.BTN_Tab_Challenge	:SetCheck( false )
		FromClientFitnessUp( 0, 0, 0, 0 )
	elseif 1 == index then
		self._frameDefaultBG_Title		:SetShow( true )
		CharacterInfo.BTN_Tab_Basic		:SetCheck( false )
		CharacterInfo.BTN_Tab_Title		:SetCheck( true )
		CharacterInfo.BTN_Tab_History	:SetCheck( false )
		CharacterInfo.BTN_Tab_Challenge	:SetCheck( false )
		-- 타이틀 오픈 함수.
		TitleInfo_Open()
	elseif 2 == index then
		self._frameDefaultBG_History	:SetShow( true )
		CharacterInfo.BTN_Tab_Basic		:SetCheck( false )
		CharacterInfo.BTN_Tab_Title		:SetCheck( false )
		CharacterInfo.BTN_Tab_History	:SetCheck( true )
		CharacterInfo.BTN_Tab_Challenge	:SetCheck( false )
		MyHistory_DataUpdate()
	elseif 3 == index then
		self._frameDefaultBG_Challenge	:SetShow( true )
		CharacterInfo.BTN_Tab_Basic		:SetCheck( false )
		CharacterInfo.BTN_Tab_Title		:SetCheck( false )
		CharacterInfo.BTN_Tab_History	:SetCheck( false )
		CharacterInfo.BTN_Tab_Challenge	:SetCheck( true )
		Fglobal_Challenge_UpdateData()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
-- 내성
function SelfCharacterInfo_UpdateTolerance()
	local player = getSelfPlayer()
	if( nil == player ) then
		return;
	end

	-- (1) 스턴
	local resistStunRate = player:getStunResistance()
	CharacterInfo._progress2_resiststun			:SetProgressRate(math.floor(resistStunRate / 10000))
	CharacterInfo._stunPercent:SetText( math.floor(resistStunRate / 10000) .. "%" )
	-- (2) 다운
	local resistDownRate = player:getKnockdownResistance()
	CharacterInfo._progress2_resistdown			:SetProgressRate(math.floor(resistDownRate / 10000))
	CharacterInfo._downPercent:SetText( math.floor(resistDownRate / 10000) .. "%" )
	-- (3) 잡기
	local resistCaptureRate = player:getCatchResistance()
	CharacterInfo._progress2_resistcapture		:SetProgressRate(math.floor(resistCaptureRate / 10000))
	CharacterInfo._capturePercent:SetText( math.floor(resistCaptureRate / 10000) .. "%" )
	
	-- (4) 넉백
	local resistKnockbackRate = player:getKnockbackResistance()
	CharacterInfo._progress2_resistknockback	:SetProgressRate(math.floor(resistKnockbackRate / 10000))
	CharacterInfo._knockBackPercent:SetText( math.floor(resistKnockbackRate / 10000) .. "%" )
end

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. 단련
local fitness =
{
		stamina		= 0,
		strength	= 1,
		health		= 2,
}

local staminaLevel	= 1
local strengthLevel	= 1
local healthLevel	= 1

if ( nil ~= getSelfPlayer() ) then
	staminaLevel	= getSelfPlayer():get():getFitnessLevel(fitness.stamina)
	strengthLevel	= getSelfPlayer():get():getFitnessLevel(fitness.strength)
	healthLevel		= getSelfPlayer():get():getFitnessLevel(fitness.health)
else
	-- _PA_LOG("Lua", "UI_Lua_SelfCharacterInfo.lua 에 getSelfPlayer() 값이 닐이다!!")
end

function FromClientFitnessUp( addSp, addWeight, addHp, addMp )
	local selfPlayerGet = getSelfPlayer():get()
	--  0. 지구력
	local currStamina	= Int64toInt32(selfPlayerGet:getCurrFitnessExperiencePoint(fitness.stamina))
	local maxStamina	= Int64toInt32(selfPlayerGet:getDemandFItnessExperiencePoint(fitness.stamina))
	local staminaRate	= currStamina / maxStamina * 100
	local currStaminaLv	= selfPlayerGet:getFitnessLevel(fitness.stamina)

	CharacterInfo._progress2_stamina	:SetProgressRate(staminaRate)
	CharacterInfo._value_stamina		:SetText( " Lv." .. tostring(currStaminaLv) )
	
	-- 1. 힘
	local currStrength	= Int64toInt32(selfPlayerGet:getCurrFitnessExperiencePoint(fitness.strength))
	local maxStrength	= Int64toInt32(selfPlayerGet:getDemandFItnessExperiencePoint(fitness.strength))
	local strengthRate	= currStrength / maxStrength * 100
	local currStrengthLv= selfPlayerGet:getFitnessLevel(fitness.strength)

	CharacterInfo._progress2_strength	:SetProgressRate(strengthRate)
	CharacterInfo._value_strength		:SetText( " Lv." .. tostring(currStrengthLv) )
	
	-- 2. 건강
	local currHealth	= Int64toInt32(selfPlayerGet:getCurrFitnessExperiencePoint(fitness.health))
	local maxHealth		= Int64toInt32(selfPlayerGet:getDemandFItnessExperiencePoint(fitness.health))
	local healthRate	= currHealth / maxHealth * 100
	local currHealthLv	= selfPlayerGet:getFitnessLevel(fitness.health)
	
	CharacterInfo._progress2_health		:SetProgressRate(healthRate)
	CharacterInfo._value_health			:SetText( " Lv." .. tostring(currHealthLv) )

	if ( staminaLevel < currStaminaLv ) then					-- 기력 레벨업 시 
		FGlobal_FitnessLevelUp( addSp, addWeight, addHp, addMp, fitness.stamina )
		staminaLevel = currStaminaLv
		SelfCharacterInfo_UpdateStamina()
	elseif ( strengthLevel < currStrengthLv ) then				-- 힘 레벨업 시
		FGlobal_FitnessLevelUp( addSp, addWeight, addHp, addMp, fitness.strength )
		strengthLevel = currStrengthLv
		SelfCharacterInfo_UpdateWeight()
	elseif ( healthLevel < currHealthLv ) then					-- 건강 레벨업 시
		FGlobal_FitnessLevelUp( addSp, addWeight, addHp, addMp, fitness.health )
		healthLevel = currHealthLv
		SelfCharacterInfo_UpdateMainStatus()
		Panel_MainStatus_User_Bar_CharacterInfoWindowUpdate()
	end
end

------------------------------------------------------------------------
--			체력, 마력에 마우스 올렸을 때 regen 을 보여준다
function CharInfo_MouseOverEvent( sourceType, isOn )
	----------------------------------------------
	-- 글자 수에 따른 ENABLE AREA 사이즈 조정
	if ( isOn == true ) then
		if ( sourceType == 0 ) then
			registTooltipControl(CharacterInfo._hpRegen, Panel_Window_CharInfo_BasicStatus)
			CharacterInfo._hpRegen:SetSize( CharacterInfo._hpRegen:GetTextSizeX()+20, CharacterInfo._hpRegen:GetSizeY() )
			CharacterInfo._hpRegen:SetShow( true )

		elseif ( sourceType == 1 ) then
			registTooltipControl(CharacterInfo._mpRegen, Panel_Window_CharInfo_BasicStatus)
			CharacterInfo._mpRegen:SetSize( CharacterInfo._mpRegen:GetTextSizeX()+20, CharacterInfo._mpRegen:GetSizeY() )
			CharacterInfo._mpRegen:SetShow( true )

		elseif ( sourceType == 2 ) then
			registTooltipControl(CharacterInfo._weightTooltip, Panel_Window_CharInfo_BasicStatus)
			CharacterInfo._weightTooltip:SetSize( CharacterInfo._weightTooltip:GetTextSizeX()+20, CharacterInfo._weightTooltip:GetSizeY() )
			CharacterInfo._weightTooltip:SetShow( true )

		end
	else
		CharacterInfo._hpRegen:SetShow( false )
		CharacterInfo._mpRegen:SetShow( false )
		CharacterInfo._weightTooltip:SetShow( false )
	end
end

function Fitness_MouseOverEvent( _type )
	if nil == _type then
		fitnessTooltip:SetShow( false )
		return
	end
	
	local posX = 0
	local posY = 0
	local msg = ""
	if fitness.stamina == _type then
		posX = CharacterInfo._title_stamina:GetSpanSize().x + 70
		posY = CharacterInfo._title_stamina:GetSpanSize().y + 80
		msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_STAMINA_MSG", "type", tostring(ToClient_GetFitnessLevelStatus(_type)) ) -- "기력 증가 +" .. tostring(ToClient_GetFitnessLevelStatus( _type ))
	elseif fitness.strength == _type then
		posX = CharacterInfo._title_strength:GetSpanSize().x + 70
		posY = CharacterInfo._title_strength:GetSpanSize().y + 80
		msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_STRENGTH_MSG", "type", tostring(ToClient_GetFitnessLevelStatus(_type)/10000) ) -- "최대 무게 증가 +" .. tostring(ToClient_GetFitnessLevelStatus( _type )/10000)
	elseif fitness.health == _type then
		posX = CharacterInfo._title_health:GetSpanSize().x + 70
		posY = CharacterInfo._title_health:GetSpanSize().y + 80
		msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_HEALTH_MSG", "type", tostring(ToClient_GetFitnessLevelStatus(_type)) ) -- "HP 증가 +" .. tostring(ToClient_GetFitnessLevelStatus( _type ))
	else
		return
	end
	fitnessTooltip:SetPosX( posX )
	fitnessTooltip:SetPosY( posY )
	fitnessTooltip:SetText( msg )
	fitnessTooltip:SetSize( fitnessTooltip:GetTextSizeX() + 20, fitnessTooltip:GetSizeY() )
	registTooltipControl(fitnessTooltip, Panel_Window_CharInfo_BasicStatus)
	fitnessTooltip:SetShow( true )
	
end

function Poten_MouseOverEvent( sourceType, isOn )

	if ( isOn == true ) then
		if ( sourceType == 0 ) then
			potenTooltip:SetPosX( CharacterInfo.attackspeed:GetSpanSize().x + 70 )
			potenTooltip:SetPosY( CharacterInfo.attackspeed:GetSpanSize().y + 40 )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_0") )	-- 단계가 오르면 전투 시 공격 속도가 올라갑니다

		elseif ( sourceType == 1 ) then
			potenTooltip:SetPosX( CharacterInfo.castspeed:GetSpanSize().x + 70 )
			potenTooltip:SetPosY( CharacterInfo.castspeed:GetSpanSize().y + 40 )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_1") )	-- 단계가 오르면 스킬의 시전 속도가 줄어듭니다

		elseif ( sourceType == 2 ) then
			potenTooltip:SetPosX( CharacterInfo.movespeed:GetSpanSize().x + 70 )
			potenTooltip:SetPosY( CharacterInfo.movespeed:GetSpanSize().y + 40 )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_2") )	-- 단계가 오르면 이동 속도가 빨라집니다

		elseif ( sourceType == 3 ) then
			potenTooltip:SetPosX( CharacterInfo.critical:GetSpanSize().x + 70 )
			potenTooltip:SetPosY( CharacterInfo.critical:GetSpanSize().y + 40 )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_3") )	-- 단계가 오르면 치명타 확률이 올라갑니다

		elseif ( sourceType == 4 ) then
			potenTooltip:SetPosX( CharacterInfo.fishTime:GetSpanSize().x + 70 )
			potenTooltip:SetPosY( CharacterInfo.fishTime:GetSpanSize().y + 40 )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_4") )	-- 단계가 오르면 낚시 소요시간이 줄어듭니다

		elseif ( sourceType == 5 ) then
			potenTooltip:SetPosX( CharacterInfo.product:GetSpanSize().x + 70 )
			potenTooltip:SetPosY( CharacterInfo.product:GetSpanSize().y + 40 )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_5") )	-- 단계가 오르면 모든 채집시간이 줄어듭니다

		elseif ( sourceType == 6 ) then
			potenTooltip:SetPosX( CharacterInfo.dropChance:GetSpanSize().x + 70 )
			potenTooltip:SetPosY( CharacterInfo.dropChance:GetSpanSize().y + 40 )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_DESC_6") )	-- 단계가 오르면 아이템 획득 확률이 올라갑니다
		end
		registTooltipControl(potenTooltip, Panel_Window_CharInfo_BasicStatus)
		potenTooltip:SetShow( true )
	else
		potenTooltip:SetShow( false )
	end
end

function Craft_MouseOverEvent( sourceType, isOn )
	if ( true == isOn ) then
		if ( 0 == sourceType ) then
			potenTooltip:SetPosX( CharacterInfo._gatherTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._gatherTitle:GetPosY() )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_1") )
		elseif ( 1 == sourceType ) then
			potenTooltip:SetPosX( CharacterInfo._manufactureTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._manufactureTitle:GetPosY() )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2") )
		elseif ( 2 == sourceType ) then
			potenTooltip:SetPosX( CharacterInfo._cookingTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._cookingTitle:GetPosY() )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2") )
		elseif ( 3 == sourceType ) then
			potenTooltip:SetPosX( CharacterInfo._alchemyTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._alchemyTitle:GetPosY() )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2") )
		elseif ( 4 == sourceType ) then
			potenTooltip:SetPosX( CharacterInfo._trainingTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._trainingTitle:GetPosY() )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_3") )
		elseif ( 5 == sourceType ) then
			potenTooltip:SetPosX( CharacterInfo._tradeTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._tradeTitle:GetPosY() )
			potenTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_4") )
		elseif ( 6 == sourceType ) then
			potenTooltip:SetPosX( CharacterInfo._fishingTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._fishingTitle:GetPosY() )
			potenTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_5") )
		elseif ( 7 == sourceType ) then
			potenTooltip:SetPosX( CharacterInfo._huntingTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._huntingTitle:GetPosY() )
			potenTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_6") )
		elseif ( 8 == sourceType) then
			potenTooltip:SetPosX( CharacterInfo._growthTitle:GetPosX() + 40 )
			potenTooltip:SetPosY( CharacterInfo._growthTitle:GetPosY() )
			potenTooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_7") )
		end
		registTooltipControl(potenTooltip, Panel_Window_CharInfo_BasicStatus)
		potenTooltip:SetShow( true )
	else
		potenTooltip:SetShow( false )
	end
end

function Regist_MouseOverEvent( tipType, isShow )
	local name, desc, control = nil, nil, nil
	local self = CharacterInfo

	if 0 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_STUN_TOOLTIP_NAME") -- 기절/경직/빙결 저항
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_STUN_TOOLTIP_DESC") -- 기절/경직/빙결 저항 확률입니다.\nPvP 시에는 최대 60%까지만 적용됩니다.
		control = self._stunTitle
	elseif 1 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_DOWN_TOOLTIP_NAME") -- 넉다운/바운드 저항
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_DOWN_TOOLTIP_DESC") -- 넉다운/바운드 저항 확률입니다.\nPvP 시에는 최대 60%까지만 적용됩니다.
		control = self._downTitle
	elseif 2 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_CAPTURE_TOOLTIP_NAME") -- 잡기 저항
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_CAPTURE_TOOLTIP_DESC") -- 잡기 저항 확률입니다.\nPvP 시에는 최대 60%까지만 적용됩니다.
		control = self._captureTitle
	elseif 3 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_KNOCKBACK_TOOLTIP_NAME") -- 넉백/띄우기 저항
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TXT_REGIST_KNOCKBACK_TOOLTIP_DESC") -- 넉백/띄우기 저항 확률입니다.\nPvP 시에는 최대 60%까지만 적용됩니다.
		control = self._knockBackTitle
	end

	if isShow == true then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

local initProgress = function()
	CharacterInfo._progress2_characterlevel				    :SetProgressRate(0)
	CharacterInfo._progress2_hp						 		:SetProgressRate(0)	
	CharacterInfo._progress2_mp	 			                :SetProgressRate(0)
	CharacterInfo._progress2_weightvalue_Money	            :SetProgressRate(0)
	CharacterInfo._progress2_weightvalue_Equip	            :SetProgressRate(0)
	CharacterInfo._progress2_weightvalue_Inventory	 		:SetProgressRate(0)	
	CharacterInfo._progress2_stungauge                      :SetProgressRate(0)
	CharacterInfo._progress2_gather	                        :SetProgressRate(0)
	CharacterInfo._progress2_manufacture		            :SetProgressRate(0)
	CharacterInfo._progress2_cooking	                    :SetProgressRate(0)
	CharacterInfo._progress2_alchemy	                    :SetProgressRate(0)
	-- CharacterInfo._progress2_fishing                        :SetProgressRate(0)
	-- CharacterInfo._progress2_asttackspeed	                :SetProgressRate(0)
	-- CharacterInfo._progress2_castspeed	                    :SetProgressRate(0)
	-- CharacterInfo._progress2_movespeed	                    :SetProgressRate(0)
	-- CharacterInfo._progress2_critical                       :SetProgressRate(0)
	CharacterInfo._progress2_resiststun			            :SetProgressRate(0)
	CharacterInfo._progress2_resistdown				        :SetProgressRate(0)
	CharacterInfo._progress2_resistcapture		            :SetProgressRate(0)
	CharacterInfo._progress2_resistknockback		        :SetProgressRate(0)
	CharacterInfo._progress2_stamina						:SetProgressRate(0)
	CharacterInfo._progress2_strength						:SetProgressRate(0)
	CharacterInfo._progress2_health							:SetProgressRate(0)
end

function CharacterInfoWindow_Show()
	-- 켜준다
	Panel_Window_CharInfo_Status:SetShow(true, true)
	CharacterInfoWindowUpdate()
	HandleClicked_CharacterInfo_Tab( 0 )	-- 툴팁 인식 문제로 실행해 준다.
	CharacterInfo.BTN_Tab_Basic:SetCheck( true )
	CharacterInfo.BTN_Tab_Title:SetCheck( false )

	-- CharacterInfo.BTN_Tab_Title:SetMonoTone( false )
	-- CharacterInfo.BTN_Tab_Title:SetEnable( true )
	-- CharacterInfo.BTN_Tab_Challenge:SetMonoTone( false )
	-- CharacterInfo.BTN_Tab_Challenge:SetEnable( true )
	CharacterInfo.BTN_Tab_History:SetCheck( false )
	CharacterInfo.BTN_Tab_Challenge:SetCheck( false )
	FromClientFitnessUp( 0, 0, 0, 0 )
--	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	-- audioPostEvent_SystemUi(01,00)
	
	CharacterInfo._btnIntroduce:EraseAllEffect()
	local msg = ToClient_GetUserIntroduction()
	if nil == msg or "" == msg then
		-- 이펙트 들어갈 자리(켜기)
		CharacterInfo._btnIntroduce:AddEffect("fUI_SelfCharacterInfo_01A", true, 0, 0)
	end
	CharacterInfo._btnIntroduce:SetPosX( CharacterInfo.txt_BaseInfo_Title:GetTextSizeX()+30 )
end

function CharacterInfoWindow_Hide()
	-- 꺼준다
	if CharacterInfo._frameDefaultBG_Challenge:GetShow() then
		CharacterInfoWindowUpdate()
		HandleClicked_CharacterInfo_Tab( 0 )
		FromClientFitnessUp( 0, 0, 0, 0 )
		CharacterInfo.BTN_Tab_Basic:SetCheck( true )
		CharacterInfo.BTN_Tab_Title:SetCheck( false )
		CharacterInfo.BTN_Tab_History:SetCheck( false )
		CharacterInfo.BTN_Tab_Challenge:SetCheck( false )
	else
		Panel_Window_CharInfo_Status:SetShow(false, false)
		initProgress()
		HelpMessageQuestion_Out()		-- 물음표 버튼 툴팁 끄기
	end

	-- audioPostEvent_SystemUi(01,01)
--	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)

	if( AllowChangeInputMode() ) then
		ClearFocusEdit()
		if( check_ShowWindow() ) then
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
		else
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
end

function FGlobal_Challenge_Show()
	Panel_Window_CharInfo_Status:SetShow( true, true )
	HandleClicked_CharacterInfo_Tab( 3 )
	FGlobal_TapButton_Complete()
	CharacterInfo.BTN_Tab_Basic:SetCheck( false )
	CharacterInfo.BTN_Tab_Title:SetCheck( false )
	CharacterInfo.BTN_Tab_History:SetCheck( false )
	CharacterInfo.BTN_Tab_Challenge:SetCheck( true )
end
function FGlobal_Challenge_Hide()
	if CharacterInfo._frameDefaultBG_Basic:GetShow() then
		HandleClicked_CharacterInfo_Tab( 3 )
		CharacterInfo.BTN_Tab_Basic:SetCheck( false )
		CharacterInfo.BTN_Tab_Title:SetCheck( false )
		CharacterInfo.BTN_Tab_History:SetCheck( false )
		CharacterInfo.BTN_Tab_Challenge:SetCheck( true )
	else
		Panel_Window_CharInfo_Status:SetShow(false, false)
	end

	if( AllowChangeInputMode() ) then
		ClearFocusEdit()
		if( check_ShowWindow() ) then
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
		else
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
end

-- 정보창 켜고 끄기
function CharacterInfoWindow_ShowToggle()
	if Panel_Window_CharInfo_Status:GetShow() then
		CharacterInfoWindow_Hide()
		audioPostEvent_SystemUi(01,00)
		CraftLevInfo_Show()
	else
		CharacterInfoWindow_Show()
		audioPostEvent_SystemUi(01,01)
		CraftLevInfo_Hide()
	end
end

-- 자기소개
function MyIntroduce_Init()
	local self = CharacterInfo._introduce
	self._editText:SetMaxEditLine( 6 )
	self._editText:SetMaxInput( 120 )
	
	self._closeIntro		:addInputEvent( "Mouse_LUp",	"IntroduceMyself_ShowToggle(false)" )
	self._editText			:addInputEvent( "Mouse_LUp",  	"HandleClicked_IntroduceMyself()" )
	self._btnSetIntro		:addInputEvent( "Mouse_LUp",	"HandleClicked_SetIntroduce()" )
	self._btnResetIntro	:addInputEvent( "Mouse_LUp",	"HandleClicked_ResetIntroduce()" )
end

function IntroduceMyself_ShowToggle( isShow )
	local self = CharacterInfo._introduce
	
	if nil == isShow then
		isShow = true
	end
	
	if self._bg:GetShow() then
		isShow = false
	end
	
	for _, control in pairs ( self ) do
		control:SetShow( isShow )
	end
	
	if not isShow then
		FGlobal_MyIntroduceClearFocusEdit()
	end
	
	local msg = ToClient_GetUserIntroduction()
	CharacterInfo._introduce._editText:SetEditText( msg )
end

function HandleClicked_IntroduceMyself()
	local self = CharacterInfo._introduce
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	SetFocusEdit( self._editText )
	self._editText:SetEditText(self._editText:GetEditText(), true)
end

function HandleClicked_SetIntroduce()
	local self = CharacterInfo._introduce
	local msg = self._editText:GetEditText()
	ToClient_RequestSetUserIntroduction( msg )
	ClearFocusEdit()
	IntroduceMyself_ShowToggle( false )
	
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_MYINTRODUCE_REGIST") ) -- 자기 소개가 등록되었습니다.
	
	-- 이펙트 들어갈 자리(켜기)
	CharacterInfo._btnIntroduce:EraseAllEffect()
	if nil == msg or "" == nil then
		CharacterInfo._btnIntroduce:AddEffect("fUI_SelfCharacterInfo_01A", true, 0, 0)
	end
end

function HandleClicked_ResetIntroduce()
	local self = CharacterInfo._introduce
	local msg = ""
	self._editText:SetEditText( msg )
	ToClient_RequestSetUserIntroduction( msg )
	ClearFocusEdit()
	
	-- 이펙트 들어갈 자리(켜기)
	CharacterInfo._btnIntroduce:EraseAllEffect()
	CharacterInfo._btnIntroduce:AddEffect("fUI_SelfCharacterInfo_01A", true, 0, 0)
end

function FGlobal_MyIntroduceClearFocusEdit()
	ClearFocusEdit()
	if ( AllowChangeInputMode() ) then
		if( UI.checkShowWindow() ) then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode) 
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
end

function FGlobal_CheckMyIntroduceUiEdit(targetUI)
	return ( nil ~= targetUI ) and ( targetUI:GetKey() == CharacterInfo._introduce._editText:GetKey() )
end

function CharacterInfo:registEventHandler()
	self._hpTitle			:addInputEvent( "Mouse_On", 	"CharInfo_MouseOverEvent( 0, true )" )
	self._hpTitle			:addInputEvent( "Mouse_Out", 	"CharInfo_MouseOverEvent( 0, false )" )
	self._mpTitle			:addInputEvent( "Mouse_On", 	"CharInfo_MouseOverEvent( 1, true )" )
	self._mpTitle			:addInputEvent( "Mouse_Out", 	"CharInfo_MouseOverEvent( 1, false )" )
	self._weightTitle		:addInputEvent( "Mouse_On", 	"CharInfo_MouseOverEvent( 2, true )" )
	self._weightTitle		:addInputEvent( "Mouse_Out", 	"CharInfo_MouseOverEvent( 2, false )" )
	self.attackspeed		:addInputEvent( "Mouse_On", 	"Poten_MouseOverEvent( 0, true )" )
	self.attackspeed		:addInputEvent( "Mouse_Out", 	"Poten_MouseOverEvent( 0, false )" )
	self.castspeed			:addInputEvent( "Mouse_On", 	"Poten_MouseOverEvent( 1, true )" )
	self.castspeed			:addInputEvent( "Mouse_Out", 	"Poten_MouseOverEvent( 1, false )" )
	self.movespeed			:addInputEvent( "Mouse_On", 	"Poten_MouseOverEvent( 2, true )" )
	self.movespeed			:addInputEvent( "Mouse_Out", 	"Poten_MouseOverEvent( 2, false )" )
	self.critical			:addInputEvent( "Mouse_On", 	"Poten_MouseOverEvent( 3, true )" )
	self.critical			:addInputEvent( "Mouse_Out", 	"Poten_MouseOverEvent( 3, false )" )
	self.fishTime			:addInputEvent( "Mouse_On", 	"Poten_MouseOverEvent( 4, true )" )
	self.fishTime			:addInputEvent( "Mouse_Out", 	"Poten_MouseOverEvent( 4, false )" )
	self.product			:addInputEvent( "Mouse_On", 	"Poten_MouseOverEvent( 5, true )" )
	self.product			:addInputEvent( "Mouse_Out", 	"Poten_MouseOverEvent( 5, false )" )
	self.dropChance			:addInputEvent( "Mouse_On", 	"Poten_MouseOverEvent( 6, true )" )
	self.dropChance			:addInputEvent( "Mouse_Out", 	"Poten_MouseOverEvent( 6, false )" )
	self._gatherTitle		:addInputEvent( "Mouse_On", 	"Craft_MouseOverEvent( 0, true )" )
	self._gatherTitle		:addInputEvent( "Mouse_Out", 	"Craft_MouseOverEvent( 0, false )" )
	self._manufactureTitle	:addInputEvent( "Mouse_On", 	"Craft_MouseOverEvent( 1, true )" )
	self._manufactureTitle	:addInputEvent( "Mouse_Out", 	"Craft_MouseOverEvent( 1, false )" )
	self._cookingTitle		:addInputEvent( "Mouse_On", 	"Craft_MouseOverEvent( 2, true )" )
	self._cookingTitle		:addInputEvent( "Mouse_Out", 	"Craft_MouseOverEvent( 2, false )" )
	self._alchemyTitle		:addInputEvent( "Mouse_On", 	"Craft_MouseOverEvent( 3, true )" )
	self._alchemyTitle		:addInputEvent( "Mouse_Out", 	"Craft_MouseOverEvent( 3, false )" )
	self._trainingTitle		:addInputEvent( "Mouse_On", 	"Craft_MouseOverEvent( 4, true )" )
	self._trainingTitle		:addInputEvent( "Mouse_Out", 	"Craft_MouseOverEvent( 4, false )" )
	self._tradeTitle		:addInputEvent( "Mouse_On", 	"Craft_MouseOverEvent( 5, true )" )
	self._tradeTitle		:addInputEvent( "Mouse_Out", 	"Craft_MouseOverEvent( 5, false )" )
	self._fishingTitle		:addInputEvent( "Mouse_On", 	"Craft_MouseOverEvent( 6, true )" )
	self._fishingTitle		:addInputEvent( "Mouse_Out", 	"Craft_MouseOverEvent( 6, false )" )
	self._huntingTitle		:addInputEvent( "Mouse_On", 	"Craft_MouseOverEvent( 7, true )" )
	self._huntingTitle		:addInputEvent( "Mouse_Out", 	"Craft_MouseOverEvent( 7, false )" )
	self._growthTitle		:addInputEvent( "Mouse_On",		"Craft_MouseOverEvent( 8, true )" )
	self._growthTitle		:addInputEvent( "Mouse_Out",	"Craft_MouseOverEvent( 8, false )" )

	self._stunTitle			:addInputEvent( "Mouse_On",		"Regist_MouseOverEvent( 0, true)")
	self._stunTitle			:addInputEvent( "Mouse_Out",	"Regist_MouseOverEvent( false)")
	self._downTitle			:addInputEvent( "Mouse_On",		"Regist_MouseOverEvent( 1, true)")
	self._downTitle			:addInputEvent( "Mouse_Out",	"Regist_MouseOverEvent( false)")
	self._captureTitle		:addInputEvent( "Mouse_On",		"Regist_MouseOverEvent( 2, true)")
	self._captureTitle		:addInputEvent( "Mouse_Out",	"Regist_MouseOverEvent( false)")
	self._knockBackTitle	:addInputEvent( "Mouse_On",		"Regist_MouseOverEvent( 3, true)")
	self._knockBackTitle	:addInputEvent( "Mouse_Out",	"Regist_MouseOverEvent( false)")

	self._hpTitle			:setTooltipEventRegistFunc( "CharInfo_MouseOverEvent( 0, true )" )
	self._mpTitle			:setTooltipEventRegistFunc( "CharInfo_MouseOverEvent( 1, true )" )
	self._weightTitle		:setTooltipEventRegistFunc( "CharInfo_MouseOverEvent( 2, true )" )
	self.attackspeed		:setTooltipEventRegistFunc( "Poten_MouseOverEvent( 0, true )" )
	self.castspeed			:setTooltipEventRegistFunc( "Poten_MouseOverEvent( 1, true )" )
	self.movespeed			:setTooltipEventRegistFunc( "Poten_MouseOverEvent( 2, true )" )
	self.critical			:setTooltipEventRegistFunc( "Poten_MouseOverEvent( 3, true )" )
	self.fishTime			:setTooltipEventRegistFunc( "Poten_MouseOverEvent( 4, true )" )
	self.product			:setTooltipEventRegistFunc( "Poten_MouseOverEvent( 5, true )" )
	self.dropChance			:setTooltipEventRegistFunc( "Poten_MouseOverEvent( 6, true )" )
	self._gatherTitle		:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 0, true )" )
	self._manufactureTitle	:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 1, true )" )
	self._cookingTitle		:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 2, true )" )
	self._alchemyTitle		:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 3, true )" )
	self._trainingTitle		:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 4, true )" )
	self._tradeTitle		:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 5, true )" )
	self._fishingTitle		:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 6, true )" )
	self._huntingTitle		:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 7, true )" )
	self._growthTitle		:setTooltipEventRegistFunc( "Craft_MouseOverEvent( 8, true )" )

	self._stunTitle			:setTooltipEventRegistFunc(" Regist_MouseOverEvent( 0, true) " )
	self._downTitle			:setTooltipEventRegistFunc(" Regist_MouseOverEvent( 1, true) " )
	self._captureTitle		:setTooltipEventRegistFunc(" Regist_MouseOverEvent( 2, true) " )
	self._knockBackTitle	:setTooltipEventRegistFunc(" Regist_MouseOverEvent( 3, true) " )

	self.BTN_Tab_Basic		:addInputEvent( "Mouse_LUp", 	"HandleClicked_CharacterInfo_Tab(" .. 0 .. ")" )
	self.BTN_Tab_Title		:addInputEvent( "Mouse_LUp", 	"HandleClicked_CharacterInfo_Tab(" .. 1 .. ")" )
	self.BTN_Tab_History	:addInputEvent( "Mouse_LUp", 	"HandleClicked_CharacterInfo_Tab(" .. 2 .. ")" )
	self.BTN_Tab_Challenge	:addInputEvent( "Mouse_LUp", 	"HandleClicked_CharacterInfo_Tab(" .. 3 .. ")" )

	self._btnIntroduce		:addInputEvent( "Mouse_LUp",	"IntroduceMyself_ShowToggle()" )
	self._ranker			:addInputEvent( "Mouse_LUp",	"FGlobal_LifeRanking_Open()" )
	
	self._title_stamina		:addInputEvent( "Mouse_On", 	"Fitness_MouseOverEvent(" .. 0 .. ")" )
	self._title_stamina		:addInputEvent( "Mouse_Out", 	"Fitness_MouseOverEvent()" )
	self._title_strength	:addInputEvent( "Mouse_On", 	"Fitness_MouseOverEvent(" .. 1 .. ")" )
	self._title_strength	:addInputEvent( "Mouse_Out", 	"Fitness_MouseOverEvent()" )
	self._title_health		:addInputEvent( "Mouse_On", 	"Fitness_MouseOverEvent(" ..  2 .. ")" )
	self._title_health		:addInputEvent( "Mouse_Out", 	"Fitness_MouseOverEvent()" )

	self._title_stamina		:setTooltipEventRegistFunc("Fitness_MouseOverEvent(" .. 0 .. ")")
	self._title_strength	:setTooltipEventRegistFunc("Fitness_MouseOverEvent(" .. 1 .. ")")
	self._title_health		:setTooltipEventRegistFunc("Fitness_MouseOverEvent(" .. 2 .. ")")
	
	-- self.BTN_Tab_Basic		:addInputEvent( "Mouse_On", 	"HandleMouseEvent_TabButtonDesc(" .. 0 .. ", true )" )
	-- self.BTN_Tab_Title		:addInputEvent( "Mouse_On", 	"HandleMouseEvent_TabButtonDesc(" .. 1 .. ", true )" )
	-- self.BTN_Tab_History	:addInputEvent( "Mouse_On", 	"HandleMouseEvent_TabButtonDesc(" .. 2 .. ", true )" )
	-- self.BTN_Tab_Challenge	:addInputEvent( "Mouse_On", 	"HandleMouseEvent_TabButtonDesc(" .. 3 .. ", true )" )
	
	-- self.BTN_Tab_Basic		:addInputEvent( "Mouse_Out", 	"HandleMouseEvent_TabButtonDesc(" .. 0 .. ", false )" )
	-- self.BTN_Tab_Title		:addInputEvent( "Mouse_Out", 	"HandleMouseEvent_TabButtonDesc(" .. 1 .. ", false )" )
	-- self.BTN_Tab_History	:addInputEvent( "Mouse_Out", 	"HandleMouseEvent_TabButtonDesc(" .. 2 .. ", false )" )
	-- self.BTN_Tab_Challenge	:addInputEvent( "Mouse_Out", 	"HandleMouseEvent_TabButtonDesc(" .. 3 .. ", false )" )


	-- 닫기 버튼 이벤트 함수 등록
	self._buttonClose		:addInputEvent("Mouse_LUp", "CharacterInfoWindow_Hide()")

	-- 물음표 버튼 이벤트 함수 등록
	self._buttonQuestion	:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"SelfCharacterInfo\" )" )					-- 물음표 좌클릭
	self._buttonQuestion	:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"SelfCharacterInfo\", \"true\")" )				-- 물음표 마우스오버
	self._buttonQuestion	:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"SelfCharacterInfo\", \"false\")" )			-- 물음표 마우스아웃
end

function HandleMouseEvent_TabButtonDesc( descType, isOn )
	if ( descType == 0 ) and ( isOn == true ) then
		CharacterInfo.txt_CharinfoDesc:SetAlpha( 0 )
		CharacterInfo.txt_CharinfoDesc:SetFontAlpha( 0 )
		CharacterInfo.txt_CharinfoDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, CharacterInfo.txt_CharinfoDesc, 0.0, 0.15 )
		CharacterInfo.txt_CharinfoDesc:SetShow( true )

	elseif ( descType == 1 ) and ( isOn == true ) then
		CharacterInfo.txt_TitleDesc:SetAlpha( 0 )
		CharacterInfo.txt_TitleDesc:SetFontAlpha( 0 )
		CharacterInfo.txt_TitleDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, CharacterInfo.txt_TitleDesc, 0.0, 0.15 )
		CharacterInfo.txt_TitleDesc:SetShow( true )
		
	elseif ( descType == 2 ) and ( isOn == true ) then
		CharacterInfo.txt_HistoryDesc:SetAlpha( 0 )
		CharacterInfo.txt_HistoryDesc:SetFontAlpha( 0 )
		CharacterInfo.txt_HistoryDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, CharacterInfo.txt_HistoryDesc, 0.0, 0.15 )
		CharacterInfo.txt_HistoryDesc:SetShow( true )
		
	elseif ( descType == 3 ) and ( isOn == true ) then
		CharacterInfo.txt_ChallengeDesc:SetAlpha( 0 )
		CharacterInfo.txt_ChallengeDesc:SetFontAlpha( 0 )
		CharacterInfo.txt_ChallengeDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, CharacterInfo.txt_ChallengeDesc, 0.0, 0.15 )
		CharacterInfo.txt_ChallengeDesc:SetShow( true )
	end
	
	if ( descType == 0 ) and ( isOn == false ) then
		CharacterInfo.txt_CharinfoDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 0, CharacterInfo.txt_CharinfoDesc, 0.0, 0.1 )
		AniInfo:SetHideAtEnd( true )
		
	elseif ( descType == 1 ) and ( isOn == false ) then
		CharacterInfo.txt_TitleDesc:ResetVertexAni()
		local AniInfo1 = UIAni.AlphaAnimation( 0, CharacterInfo.txt_TitleDesc, 0.0, 0.1 )
		AniInfo1:SetHideAtEnd( true )
		
	elseif ( descType == 2 ) and ( isOn == false ) then
		CharacterInfo.txt_HistoryDesc:ResetVertexAni()
		local AniInfo2 = UIAni.AlphaAnimation( 0, CharacterInfo.txt_HistoryDesc, 0.0, 0.1 )
		AniInfo2:SetHideAtEnd( true )
		
	elseif ( descType == 3 ) and ( isOn == false ) then
		CharacterInfo.txt_ChallengeDesc:ResetVertexAni()
		local AniInfo3 = UIAni.AlphaAnimation( 0, CharacterInfo.txt_ChallengeDesc, 0.0, 0.1 )
		AniInfo3:SetHideAtEnd( true )
	end
end

function FGlobal_MaxWeightChanged()
	SelfCharacterInfo_UpdateWeight()
end

function CharacterInfo:registMessageHandler()
	-- 캐릭터정보 업데이트 이벤트 함수 등록

	--registerEvent("EventCharacterInfoUpdate",			"CharacterInfoWindowUpdate");
	--registerEvent("FromClient_InventoryUpdate",		"CharacterInfoWindowUpdate");			--인벤의 무게가 바뀌면 캐릭터창의 무게도 바뀌어야 한다.!

	--Panel_Window_CharInfo_Status:RegisterUpdateFunc("CharacterInfoWindowUpdate") -- 나중에 켜자

	-- 성능 이슈로 인해 registerUpdateFunc 대신 각각 이벤트를 받는 형식으로 변경
	-- HP, MP
	registerEvent("FromClient_SelfPlayerHpChanged", "SelfCharacterInfo_UpdateMainStatus")
	registerEvent("FromClient_SelfPlayerMpChanged", "SelfCharacterInfo_UpdateMainStatus")
	-- HP, MP regen
	registerEvent("FromClient_SelfPlayerMainStatusRegenChanged", "SelfCharacterInfo_UpdateMainStatusRegen")
	-- 기운
	registerEvent("FromClient_WpChanged", "SelfCharacterInfo_UpdateWp")
	-- 공헌도
	registerEvent("FromClient_UpdateExplorePoint", "SelfCharacterInfo_UpdateExplorePoint")
	-- Level
	registerEvent("FromClient_SelfPlayerExpChanged", "SelfCharacterInfo_UpdateLevel")
	registerEvent("EventSelfPlayerLevelUp", "SelfCharacterInfo_UpdateLevel")
	-- 무게
	registerEvent("FromClient_InventoryUpdate", "SelfCharacterInfo_UpdateWeight")
	registerEvent("FromClient_WeightChanged", "SelfCharacterInfo_UpdateWeight")
	-- 스턴수치
	if isGameTypeKorea() or isGameTypeJapan() then
		registerEvent("stunChanged", "SelfCharacterInfo_UpdateStun")
	end
	-- 공격력, 방어력 (공격력, 방어력은 장비와 관련이 있으므로 장비창 변경될 때, 이벤트를 받는다.)
	registerEvent("EventEquipmentUpdate", "SelfCharacterInfo_UpdateAttackStat")
	-- 성향
	registerEvent("FromClient_SelfPlayerTendencyChanged", "SelfCharacterInfo_UpdateTendency")
	-- 잠재력
	registerEvent("FromClient_UpdateSelfPlayerStatPoint", "SelfCharacterInfo_UpdatePotenGradeInfo")
	--단련
	registerEvent("FromClientFitnessUp", "FromClientFitnessUp" )
	-- 소속 영지명
	--registerEvent("", "SelfCharacterInfo_UpdateAffiliatedTerritory")
	-- 생산등급
	registerEvent("FromClient_UpdateSelfPlayerLifeExp", "SelfCharacterInfo_UpdateCraftLevel")
	-- 내성
	registerEvent("FromClient_UpdateTolerance", "SelfCharacterInfo_UpdateTolerance")
	-- 스태미너 변경 시
	registerEvent("EventStaminaUpdate", "SelfCharacterInfo_UpdateStamina")

	registerEvent("onScreenResize", 		"CharacterInfo_onScreenResize" )
end


CharacterInfo:Init()
CharacterInfoWindowUpdate()

CharacterInfo:registEventHandler()
CharacterInfo:registMessageHandler()
MyIntroduce_Init()

function CharacterInfo_onScreenResize()
	Panel_Window_CharInfo_Status:SetPosX( 5 )
	Panel_Window_CharInfo_Status:SetPosY( (getScreenSizeY()/2) -  (Panel_Window_CharInfo_Status:GetSizeY()/2) )
end

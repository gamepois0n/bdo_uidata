Panel_Window_StableMarket:SetShow(false, false)
Panel_Window_StableMarket:setMaskingChild(true)
Panel_Window_StableMarket:ActiveMouseEventEffect(true)
Panel_Window_StableMarket:SetDragEnable( true )

Panel_Window_StableMarket:RegisterShowEventFunc( true,	"StableMarketShowAni()" )
Panel_Window_StableMarket:RegisterShowEventFunc( false,	"StableMarketHideAni()" )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

function	StableMarketShowAni()
	local	isShow	= Panel_Window_StableMarket:IsShow()

	if	( isShow )	then
	-- 꺼준다
		Panel_Window_StableMarket:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
		local aniInfo1 = Panel_Window_StableMarket:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
		aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
		aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
		aniInfo1:SetStartIntensity( 3.0 )
		aniInfo1:SetEndIntensity( 1.0 )
		aniInfo1.IsChangeChild = true
		aniInfo1:SetHideAtEnd(true)
		aniInfo1:SetDisableWhileAni(true)
	else
		UIAni.fadeInSCR_Down(Panel_Window_StableMarket)
		Panel_Window_StableMarket:SetShow(true, false)
	end
end

function	StableMarketHideAni()
	Panel_Window_StableMarket:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_StableMarket:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

function	StableMarket_Resize()
	screenX	= getScreenSizeX()
	screenY	= getScreenSizeY()
end

local	stableMarket	= {
	_config	=
	{
		-- 슬롯 위치
		slot	=
		{
			startX			= 0,
			startY			= 10,
			gapY			= 127,
		},
		
		-- 슬롯_아이콘 위치
		icon	=
		{
			startX			= 15,
			startY			= 10,
			startValueX		= 0,
			startValueY		= 0,
			startKindX		= -15,
			startKindY		= -10,
			startMatingX	= 0,
			startMatingY	= 90,
			gapMatingX		= 100,
			size			= 150,
		},
		
		-- 슬롯_스탯 위치
		stat	=
		{
			startX			= 120,
			startY			= 10,
			startValueX		= 10,
			startValueY		= 0,
			startMoneyX		= 0,
			startMoneyY		= 0,
			gapX			= 50,
			gapY			= 20,
		},
		
		-- 슬롯_스킬 위치
		skill	=
		{
			startX			= 330,
			startY			= 10,
			iconX			= 10,
			iconY			= 15,
			textX			= -3,
			textY			= 55,
			gapX			= 69,
				
			count			= 5
		},	
			
		-- 슬롯_버튼 위치	
		button	=	
		{	
			startX			= 710,
			startY			= 10,
		},
		
		slotCount			= 4,
	},

	_mainBG						= UI.getChildControl( Panel_Window_StableMarket,	"Static_MainBG" ),				-- 슬롯이 들어갈 프레임

	_buttonQuestion				= UI.getChildControl( Panel_Window_StableMarket,	"Button_Question" ),			-- 물음표 버튼
	_buttonClose				= UI.getChildControl( Panel_Window_StableMarket,	"Button_Close" ),				-- 페이지 끄기
		
	_staticPageNo				= UI.getChildControl( Panel_Window_StableMarket, 	"Static_PageNo" ),				-- 현제 페이지
	_buttonNext					= UI.getChildControl( Panel_Window_StableMarket, 	"Button_Next" ),				-- 다음 페이지
	_buttonPrev					= UI.getChildControl( Panel_Window_StableMarket,	"Button_Prev" ),				-- 전 페이지
	
	_buttonTabMarket			= UI.getChildControl( Panel_Window_StableMarket,	"RadioButton_List" ),			-- 시장 리스트
	_buttonTabMy				= UI.getChildControl( Panel_Window_StableMarket,	"RadioButton_ListMy" ),			-- 내 리스트
	
	_buttonBuy					= UI.getChildControl( Panel_Window_StableMarket,	"Button_Buy" ),					-- 구매 버튼
	_buttonCancel				= UI.getChildControl( Panel_Window_StableMarket,	"Button_Cancel" ),				-- 취소 버튼
	_buttonReceive				= UI.getChildControl( Panel_Window_StableMarket,	"Button_Receive" ),				-- 수령 버튼
	_buttonEnd					= UI.getChildControl( Panel_Window_StableMarket,	"Button_End" ),					-- 만료 버튼
	
	_radioInven					= UI.getChildControl( Panel_Window_StableMarket,	"RadioButton_Icon_Money"),
	_radioWarehouse				= UI.getChildControl( Panel_Window_StableMarket,	"RadioButton_Icon_Money2"),
	_staticInven				= UI.getChildControl( Panel_Window_StableMarket,	"Static_Text_Money"),
	_staticWarehouse			= UI.getChildControl( Panel_Window_StableMarket,	"Static_Text_Money2"),

	_comboGenFilter				= UI.getChildControl( Panel_Window_StableMarket,	"Combobox_FilterGen"),
	_comboBox_SkillFilter		= UI.getChildControl( Panel_Window_StableMarket,	"Combobox_Skill" ),

	_slots						= Array.new(),
	
	_selectSlotNo				= nil,																				-- 선택된 슬롯 번호
	_selectPage					= 0,																				-- 현제 페이지.
	_selectMaxPage				= 0,																				-- 최대 페이시.
	_isTabMy					= false,																			-- 내 등록 목록 or 마켓 목록
}

local stableServantGen = {
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_0"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_1"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_2"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_3"),
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_4"),
	[5] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_5"),
	[6] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_6"),
	[7] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_7"),
	[8] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_8"),
}

-- local skillFilter = { 3, 4, 8, 9, 10, 18 }		-- 드리프트, 전력질주, 순간가속, 돌진, 측면이동, 연: 순간가속

stableMarket._comboBox_SkillFilter:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_SKILL") )
stableMarket._comboBox_SkillFilter:addInputEvent( "Mouse_LUp", "HandleClicked_StableMarket_SkillFilter()" )
stableMarket._comboBox_SkillFilter:GetListControl():addInputEvent( "Mouse_LUp", "StableMarket_SetSkillFilter()"  )
Panel_Window_StableMarket:SetChildIndex(stableMarket._comboBox_SkillFilter, 9999 )



local selectFilterNo = 0

----------------------------------------------------------------------------------------------------
-- Init Function
function stableMarket:init()
	for	ii = 0, self._config.slotCount-1	do
		local	slot					= {}
		slot._slotNo					= ii
		slot._panel						= Panel_Window_StableMarket
		slot._startSlotIndex			= 0
		slot._learnSkillCount			= 0

		slot._baseSlot					= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Slot",				self._mainBG,		"ServantMarket_Slot_"					.. ii )
		slot._iconBack					= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_IconBack",			slot._baseSlot,		"ServantMarket_Slot_IconBack_"			.. ii )
		slot._icon						= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Icon",				slot._iconBack,		"ServantMarket_Slot_Icon_"				.. ii )
		slot._grade						= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "StaticText_Grade",			slot._iconBack,		"ServantMarket_Slot_Grade_"				.. ii )
		slot._iconMale					= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Male",				slot._iconBack,		"ServantMarket_Slot_Male_"				.. ii )
		slot._iconFemale				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Female",				slot._iconBack,		"ServantMarket_Slot_Female_"			.. ii )
		slot._statusBack				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_StatusBack",			slot._baseSlot,		"ServantMarket_Slot_StatusBack_"		.. ii )
		slot._staticCountBG				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_CountBG",				slot._statusBack,	"ServantMarket_Slot_CountBG"			.. ii )
		slot._staticMatingCount			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_MatingCount",			slot._statusBack,	"ServantMarket_Slot_Count_"				.. ii )
		slot._staticMatingCountValue	= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_MatingCountValue",	slot._statusBack,	"ServantMarket_Slot_CountValue_"		.. ii )
		slot._staticLv					= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Lv",					slot._statusBack,	"ServantMarket_Slot_StatusLv_"			.. ii )
		slot._staticLvValue				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_LvValue",				slot._statusBack,	"ServantMarket_Slot_StatusLvValue_"		.. ii )
		slot._staticHp					= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Hp",					slot._statusBack,	"ServantMarket_Slot_StatusHp_"			.. ii )
		slot._staticHpValue				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_HpValue",				slot._statusBack,	"ServantMarket_Slot_StatusHpValue_"		.. ii )
		slot._staticStamina				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Stamina",				slot._statusBack,	"ServantMarket_Slot_StatusStamina_"		.. ii )
		slot._staticStaminaValue		= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_StaminaValue",		slot._statusBack,	"ServantMarket_Slot_StatusStaminaValue_".. ii )
		slot._staticWeight				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Weight",				slot._statusBack,	"ServantMarket_Slot_StatusWeight_"		.. ii )
		slot._staticWeightValue			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_WeightValue",			slot._statusBack,	"ServantMarket_Slot_StatusWeightValue_"	.. ii )
		slot._staticPrice				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Price",				slot._statusBack,	"ServantMarket_Slot_StatusPrice_"		.. ii )		
		slot._staticPriceValue			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_PriceValue",			slot._statusBack,	"ServantMarket_Slot_StatusPriceValue_"	.. ii )
		slot._staticMoveSpeed			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_MoveSpeed",			slot._statusBack,	"ServantMarket_Slot_MoveSpeed"			.. ii )
		slot._staticMoveSpeedValue		= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_MoveSpeedValue",		slot._statusBack,	"ServantMarket_Slot_MoveSpeedValue"		.. ii )
		slot._staticAcceleration		= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Acceleration",		slot._statusBack,	"ServantMarket_Slot_Acceleration"		.. ii )
		slot._staticAccelerationValue	= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_AccelerationValue",	slot._statusBack,	"ServantMarket_Slot_AccelerationValue"	.. ii )
		slot._staticCornering			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Cornering",			slot._statusBack,	"ServantMarket_Slot_Cornering"			.. ii )
		slot._staticCorneringValue		= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_CorneringValue",		slot._statusBack,	"ServantMarket_Slot_CorneringValue"		.. ii )		
		slot._staticBrake				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Brake",				slot._statusBack,	"ServantMarket_Slot_Brake"				.. ii )
		slot._staticBrakeValue			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_BrakeValue",			slot._statusBack,	"ServantMarket_Slot_BrakeValue"			.. ii )		
		slot._staticDeadCount			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "StaticText_DeadCount",		slot._statusBack,	"ServantMarket_Slot_DeadCount_"			.. ii )
		slot._staticDeadCountValue		= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "StaticText_DeadCountValue",	slot._statusBack,	"ServantMarket_Slot_DeadCountValue_"	.. ii )
		
		slot._skillBack					= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_SkillBack",			slot._baseSlot,		"ServantMarket_Slot_SkillBack_"			.. ii )

		slot._skillNextPage				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Button_NextPage",			slot._skillBack,	"ServantMarket_Slot_SkillNextPage_"		.. ii )
		slot._skillPrevPage				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Button_PrevPage",			slot._skillBack,	"ServantMarket_Slot_SkillPrevPage_"		.. ii )
		slot._skillPageValue			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "StaticText_PageValue",		slot._skillBack,	"ServantMarket_Slot_Skill_PageValue_"	.. ii )


		slot._skill						= Array.new()
		for jj=0, self._config.skill.count-1	do
			local	skill				= {}
			skill._expBG		= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_Texture_Learn_Background",	slot._skillBack,	"ServantMarket_Slot_SkillExpBG_"	.. ii .. "_" .. jj )
			skill._exp			= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "SkillLearn_Gauge",					slot._skillBack,	"ServantMarket_Slot_SkillExp_"		.. ii .. "_" .. jj )
			skill._skillIcon	= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_SkillIcon",					slot._skillBack,	"ServantMarket_Slot_SkillIcon_"		.. ii .. "_" .. jj )
			skill._skillText	= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Static_SkillText",					slot._skillBack,	"ServantMarket_Slot_SkillText_"		.. ii .. "_" .. jj )
			skill._expText		= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "SkillLearn_PercentString",			slot._skillBack,	"ServantMarket_Slot_SkillExpStr_"	.. ii .. "_" .. jj )

			slot._skill[jj]				= skill
		end
		
		slot._buttonBuy					= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Button_Buy",					slot._baseSlot,		"ServantMarket_Buy_"					.. ii )		
		slot._buttonCancel				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Button_Cancel",				slot._baseSlot,		"ServantMarket_Cancel_"					.. ii )
		slot._buttonReceive				= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Button_Receive",				slot._baseSlot,		"ServantMarket_Receive_"				.. ii )
		slot._buttonEnd					= UI.createAndCopyBasePropertyControl( Panel_Window_StableMarket, "Button_End",					slot._baseSlot,		"ServantMarket_End_"					.. ii )
		
		-- 좌표 설정.
		local	slotConfig	= self._config.slot
		slot._baseSlot:SetPosX(	slotConfig.startX )
		slot._baseSlot:SetPosY(	slotConfig.startY + slotConfig.gapY * ii )
		
		local	iconConfig	= self._config.icon
		slot._iconBack:SetPosX(					iconConfig.startX								)
		slot._iconBack:SetPosY(					iconConfig.startY								)
		slot._icon:SetPosX(						iconConfig.startValueX							)
		slot._icon:SetPosY(						iconConfig.startValueY							)
		slot._grade:SetPosX(					iconConfig.startKindX + 80						)
		slot._grade:SetPosY(					iconConfig.startKindY + 5						)
		slot._iconMale:SetPosX(					iconConfig.startKindX							)
		slot._iconMale:SetPosY(					iconConfig.startKindY							)
		slot._iconFemale:SetPosX(				iconConfig.startKindX							)
		slot._iconFemale:SetPosY(				iconConfig.startKindY							)

		local	statConfig	= self._config.stat
		slot._statusBack:SetPosX(				statConfig.startX							 )
		slot._statusBack:SetPosY(				statConfig.startY							 )
		slot._staticLv:SetPosX( 				statConfig.startValueX + statConfig.gapX * 0 )
		slot._staticLv:SetPosY( 				statConfig.startValueY + statConfig.gapY * 0 )
		slot._staticHp:SetPosX( 				statConfig.startValueX + statConfig.gapX * 0 )
		slot._staticHp:SetPosY( 				statConfig.startValueY + statConfig.gapY * 1 )
		slot._staticStamina:SetPosX(			statConfig.startValueX + statConfig.gapX * 0 )
		slot._staticStamina:SetPosY(			statConfig.startValueY + statConfig.gapY * 2 )
		slot._staticWeight:SetPosX(				statConfig.startValueX + statConfig.gapX * 0 )
		slot._staticWeight:SetPosY(				statConfig.startValueY + statConfig.gapY * 3 )
		
		slot._staticLvValue:SetPosX(			statConfig.startValueX + statConfig.gapX * 1 )
		slot._staticLvValue:SetPosY(			statConfig.startValueY + statConfig.gapY * 0 )
		slot._staticHpValue:SetPosX(			statConfig.startValueX + statConfig.gapX * 1 )
		slot._staticHpValue:SetPosY(			statConfig.startValueY + statConfig.gapY * 1 )
		slot._staticStaminaValue:SetPosX(		statConfig.startValueX + statConfig.gapX * 1 )
		slot._staticStaminaValue:SetPosY(		statConfig.startValueY + statConfig.gapY * 2 )
		slot._staticWeightValue:SetPosX(		statConfig.startValueX + statConfig.gapX * 1 )
		slot._staticWeightValue:SetPosY(		statConfig.startValueY + statConfig.gapY * 3 )
		                                                               
		slot._staticMoveSpeed:SetPosX(			statConfig.startValueX + statConfig.gapX * 2 )
		slot._staticMoveSpeed:SetPosY(			statConfig.startValueY + statConfig.gapY * 0 )
		slot._staticAcceleration:SetPosX(		statConfig.startValueX + statConfig.gapX * 2 )
		slot._staticAcceleration:SetPosY(		statConfig.startValueY + statConfig.gapY * 1 )
		slot._staticCornering:SetPosX(			statConfig.startValueX + statConfig.gapX * 2 )
		slot._staticCornering:SetPosY(			statConfig.startValueY + statConfig.gapY * 2 )
		slot._staticBrake:SetPosX(				statConfig.startValueX + statConfig.gapX * 2 )
		slot._staticBrake:SetPosY(				statConfig.startValueY + statConfig.gapY * 3 )

		slot._staticMoveSpeedValue:SetPosX(		statConfig.startValueX + statConfig.gapX * 3 )
		slot._staticMoveSpeedValue:SetPosY(		statConfig.startValueY + statConfig.gapY * 0 )
		slot._staticAccelerationValue:SetPosX(	statConfig.startValueX + statConfig.gapX * 3 )
		slot._staticAccelerationValue:SetPosY(	statConfig.startValueY + statConfig.gapY * 1 )
		slot._staticCorneringValue:SetPosX(		statConfig.startValueX + statConfig.gapX * 3 )
		slot._staticCorneringValue:SetPosY(		statConfig.startValueY + statConfig.gapY * 2 )
		slot._staticBrakeValue:SetPosX(			statConfig.startValueX + statConfig.gapX * 3 )
		slot._staticBrakeValue:SetPosY(			statConfig.startValueY + statConfig.gapY * 3 )
		
		slot._staticCountBG:SetPosX(			statConfig.startValueX + statConfig.gapX * -0.2)
		slot._staticCountBG:SetPosY(			statConfig.startValueY + statConfig.gapY * 4 )

		slot._staticDeadCount:SetPosX(			statConfig.startValueX + statConfig.gapX * 0.3 )
		slot._staticDeadCount:SetPosY(			statConfig.startValueY + statConfig.gapY * 4.1 )
		slot._staticDeadCountValue:SetPosX(		statConfig.startValueX + statConfig.gapX * 1.8 )
		slot._staticDeadCountValue:SetPosY(		statConfig.startValueY + statConfig.gapY * 4.1 )

		slot._staticMatingCount:SetPosX(		statConfig.startValueX + statConfig.gapX * 4.3 )
		slot._staticMatingCount:SetPosY(		statConfig.startValueY + statConfig.gapY * 4.1 )
		slot._staticMatingCountValue:SetPosX(	statConfig.startValueX + statConfig.gapX * 6.4 )
		slot._staticMatingCountValue:SetPosY(	statConfig.startValueY + statConfig.gapY * 4.1 )

		slot._staticPrice:SetPosX(				statConfig.startValueX + statConfig.gapX * 8.3 )
		slot._staticPrice:SetPosY(				statConfig.startValueY + statConfig.gapY * 4.3 )
		slot._staticPriceValue:SetPosX(			statConfig.startValueX + statConfig.gapX * 9.35 )
		slot._staticPriceValue:SetPosY(			statConfig.startValueY + statConfig.gapY * 4.2 )

		local	skillConfig	= self._config.skill
		slot._skillBack			:SetPosX(	skillConfig.startX	)
		slot._skillBack			:SetPosY(	skillConfig.startY	)

		slot._skillPrevPage		:SetPosX(	slot._skillBack:GetSizeX()	)
		slot._skillPrevPage		:SetPosY(	skillConfig.startY	)
		slot._skillPageValue	:SetPosX(	slot._skillBack:GetSizeX()	)
		slot._skillPageValue	:SetPosY(	skillConfig.startY + slot._skillPrevPage:GetSizeY()	)
		slot._skillNextPage		:SetPosX(	slot._skillBack:GetSizeX()	)
		slot._skillNextPage		:SetPosY(	slot._skillPageValue:GetPosY() + slot._skillPageValue:GetSizeY()	)

		for jj=0, self._config.skill.count-1	do
			slot._skill[jj]._expBG		:SetPosX( (skillConfig.iconX + skillConfig.gapX * jj) - 5 )
			slot._skill[jj]._expBG		:SetPosY( (skillConfig.iconY) - 5 )
			slot._skill[jj]._exp		:SetPosX( (skillConfig.iconX + skillConfig.gapX * jj) - 3 )
			slot._skill[jj]._exp		:SetPosY( (skillConfig.iconY) - 3 )
			slot._skill[jj]._skillIcon	:SetPosX( skillConfig.iconX + skillConfig.gapX * jj )
			slot._skill[jj]._skillIcon	:SetPosY( skillConfig.iconY )
			slot._skill[jj]._skillText	:SetPosX( skillConfig.textX + skillConfig.gapX * jj )
			slot._skill[jj]._skillText	:SetPosY( skillConfig.textY )
			slot._skill[jj]._expText	:SetPosX( (skillConfig.iconX + skillConfig.gapX * jj) + 20 )
			slot._skill[jj]._expText	:SetPosY( (skillConfig.iconY) + 30 )
			slot._skill[jj]._skillIcon:addInputEvent(	"Mouse_UpScroll",	"StableMarket_ScrollEvent("	.. ii .. ", true)"	)
			slot._skill[jj]._skillIcon:addInputEvent(	"Mouse_DownScroll",	"StableMarket_ScrollEvent("	.. ii .. ", false)"	)
		end
		
		local	buttonConfig	= self._config.button
		slot._buttonBuy:SetPosX(				buttonConfig.startX )
		slot._buttonBuy:SetPosY(				buttonConfig.startY )
		slot._buttonCancel:SetPosX(				buttonConfig.startX )
		slot._buttonCancel:SetPosY(				buttonConfig.startY )
		slot._buttonReceive:SetPosX(			buttonConfig.startX )
		slot._buttonReceive:SetPosY(			buttonConfig.startY )
		slot._buttonEnd:SetPosX(				buttonConfig.startX )
		slot._buttonEnd:SetPosY(				buttonConfig.startY )

		slot._buttonBuy:addInputEvent(		"Mouse_LUp",		"StableMarket_Buy("			.. ii .. ")"		)
		slot._buttonCancel:addInputEvent(	"Mouse_LUp",		"StableMarket_Cancel("		.. ii .. ")"		)
		slot._buttonReceive:addInputEvent(	"Mouse_LUp",		"StableMarket_Receive("		.. ii .. ")"		)
		slot._buttonEnd:addInputEvent(		"Mouse_LUp",		"StableMarket_Cancel("		.. ii .. ")"		)
		
		slot._baseSlot:addInputEvent(		"Mouse_UpScroll",	"StableMarket_ScrollEvent("	.. ii .. ", true)"	)
		slot._baseSlot:addInputEvent(		"Mouse_DownScroll",	"StableMarket_ScrollEvent("	.. ii .. ", false)"	)
		
		slot._buttonBuy:SetAutoDisableTime( 4.0 )
		slot._buttonCancel:SetAutoDisableTime( 4.0 )
		slot._buttonReceive:SetAutoDisableTime( 4.0 )
		slot._buttonEnd:SetAutoDisableTime( 4.0 )		
		
		slot._baseSlot:SetShow(false)
		
		self._slots[ii]	= slot
	end
end

function StableMarket_SimpleTooltips( tipType, isShow )
	local name, desc, control = nil, nil, nil
	local self = stableMarket

	if 0 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_DESC")
		control = self._radioInven
	elseif 1 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_DESC")
		control = self._radioWarehouse
	end

	if true == isShow then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function	stableMarket:registEventHandler()
	self._buttonTabMarket	:addInputEvent(	"Mouse_LUp",	"StableMarket_TabEvent( false )")
	self._buttonTabMy		:addInputEvent(	"Mouse_LUp",	"StableMarket_TabEvent( true )" )
										
	self._buttonNext		:addInputEvent(	"Mouse_LUp",	"StableMarket_NextPage()" )
	self._buttonPrev		:addInputEvent(	"Mouse_LUp",	"StableMarket_PrevPage()" )

	self._comboGenFilter	:addInputEvent( "Mouse_LUp",	"StableMarket_ShowGenFilter()")
	self._comboGenFilter:GetListControl():addInputEvent( "Mouse_LUp", "StableMarket_SetGenFilter()"  )
	
	-- self._comboBox_SkillFilter	:addInputEvent( "Mouse_LUp",	"StableMarket_SkillFilter()")
	-- self._comboBox_SkillFilter:GetListControl():addInputEvent( "Mouse_LUp", "StableMarket_SetSkillFilter()"  )
	
	
	self._buttonQuestion	:addInputEvent(	"Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"PanelWindowStableMarket\" )"			)			-- 물음표 좌클릭
	self._buttonQuestion	:addInputEvent(	"Mouse_On",		"HelpMessageQuestion_Show( \"PanelWindowStableMarket\", \"true\")"	)			-- 물음표 마우스오버
	self._buttonQuestion	:addInputEvent(	"Mouse_Out",	"HelpMessageQuestion_Show( \"PanelWindowStableMarket\", \"false\")"	)			-- 물음표 마우스아웃
	self._buttonClose		:addInputEvent(	"Mouse_LUp",	"StableMarket_Close()"												)		
	
	self._radioInven		:addInputEvent( "Mouse_On",		"StableMarket_SimpleTooltips( 0, true )"	)
	self._radioInven		:addInputEvent( "Mouse_Out",	"StableMarket_SimpleTooltips( false )"		)
	self._radioWarehouse	:addInputEvent( "Mouse_On",		"StableMarket_SimpleTooltips( 1, true )"	)
	self._radioWarehouse	:addInputEvent( "Mouse_Out",	"StableMarket_SimpleTooltips( false )"		)

	self._radioInven		:setTooltipEventRegistFunc("StableMarket_SimpleTooltips( 0, true )")
	self._radioWarehouse	:setTooltipEventRegistFunc("StableMarket_SimpleTooltips( 1, true )")

	self._buttonTabMarket	:SetAutoDisableTime(	4.0 )
	self._buttonTabMy		:SetAutoDisableTime(		4.0 )
	self._buttonNext		:SetAutoDisableTime(		4.0 )
	self._buttonPrev		:SetAutoDisableTime(		4.0 )
end

function	stableMarket:registMessageHandler()
	registerEvent("FromClient_AuctionServantList",			"StableMarket_UpdateSlotData")
	registerEvent("FromClient_ServantRegisterToAuction",	"StableMarket_TabEventFromRegister")
	registerEvent("FromClient_InventoryUpdate",				"StableMarket_UpdateMoney")
	registerEvent("EventWarehouseUpdate",					"StableMarket_UpdateMoney")
	registerEvent("onScreenResize",							"StableMarket_Resize" )
end

function	stableMarket:update( isClear )

	-- 플레이어의 소지금을 갱신한다.
	--{
		StableMarket_UpdateMoney()
	--}
	
	--전체 disable
	for	ii = 0, self._config.slotCount-1	do
		local	slot	= self._slots[ii]
		if	( isClear )	then
			slot._learnSkillCount	= 0
			slot._startSlotIndex	= 0
		end
		slot._baseSlot			:SetShow(false)
		slot._skillPrevPage		:SetShow(false)
		slot._skillPageValue	:SetShow(false)
		slot._skillNextPage		:SetShow(false)
	end
	
	local	myAuctionInfo	= RequestGetAuctionInfo()
	local	startSlotNo		= 0
	local	endSlotNo		= 0
	if	( StableMarket_IsTabMy() )	then
		startSlotNo			= self._selectPage * self._config.slotCount
		endSlotNo			= startSlotNo + self._config.slotCount - 1
		local	maxCount	= myAuctionInfo:getServantAuctionListCount()
		self._selectMaxPage	= math.floor( maxCount / self._config.slotCount ) - 1
		if	0 < (maxCount % self._config.slotCount)	then
			self._selectMaxPage	= self._selectMaxPage + 1
		end
	else
		startSlotNo	= 0
		endSlotNo	= myAuctionInfo:getServantAuctionListCount() - 1
	end
	
	local	slotNo		= 0
	for ii=startSlotNo, endSlotNo	do
		local	auctionServantInfo	= myAuctionInfo:getServantAuctionListAt( ii )
		if	nil ~= auctionServantInfo	then
			local slot	= self._slots[slotNo]
			
			-- 아이콘
			slot._icon:ChangeTextureInfoName( auctionServantInfo:getIconPath1() )
			
			-- 교배 횟수(말일 때만 보여준다!)
			if auctionServantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
				slot._staticMatingCount:SetShow(true)
				slot._staticMatingCountValue:SetShow(true)
				if auctionServantInfo:doClearCountByMating() then
					slot._staticMatingCountValue:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", auctionServantInfo:getMatingCount() ) ) -- auctionServantInfo:getMatingCount().. "(초기화 가능)")
				else
					slot._staticMatingCountValue:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", auctionServantInfo:getMatingCount() ) ) -- auctionServantInfo:getMatingCount().. "(초기화 불가)")
				end
				
			else
				slot._staticMatingCount:SetShow(false)
				slot._staticMatingCountValue:SetShow(false)
			end
			
			-- 수컷, 암컷을 구분해준다
			if auctionServantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
				if	( auctionServantInfo:isMale() ) then
					slot._iconMale:SetShow( true )
					slot._iconFemale:SetShow( false )
				else
					slot._iconMale:SetShow( false )
					slot._iconFemale:SetShow( true )
				end
				slot._grade:SetShow( true )
				slot._grade:SetText(PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", auctionServantInfo:getTier())) -- auctionServantInfo:getTier() .. "등급")
			else
				slot._grade:SetShow( false )
				slot._iconMale:SetShow( false )
				slot._iconFemale:SetShow( false )
			end
			
			-- 스텟
			slot._staticLvValue:SetText( auctionServantInfo:getLevel() )
			slot._staticHpValue:SetText( auctionServantInfo:getMaxHp() )
			slot._staticStaminaValue:SetText( auctionServantInfo:getMaxMp() )
			slot._staticWeightValue:SetText( tostring(auctionServantInfo:getMaxWeight_s64()/Defines.s64_const.s64_10000) )
			
			slot._staticMoveSpeedValue:SetText(		string.format( "%.1f", (auctionServantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed)		/ 10000)) .. "%" ) -- 속도
			slot._staticAccelerationValue:SetText(	string.format( "%.1f", (auctionServantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration)		/ 10000)) .. "%" ) -- 가속도
			slot._staticCorneringValue:SetText(		string.format( "%.1f", (auctionServantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed)	/ 10000)) .. "%" ) -- 코너링
			slot._staticBrakeValue:SetText(			string.format( "%.1f", (auctionServantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed)		/ 10000)) .. "%" ) -- 브레이크
						
			-- 가격
			slot._staticPriceValue:SetText( makeDotMoney(auctionServantInfo:getAuctoinPrice_s64()) ) 
			
			--죽은 횟수
			local deadCount = auctionServantInfo:getDeadCount()
			if auctionServantInfo:doClearCountByDead() then
				deadCount = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", deadCount ) -- deadCount .. " (초기화 가능)"
			else
				deadCount = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", deadCount ) -- deadCount .. " (초기화 불가)"
			end
			slot._staticDeadCountValue:SetText( deadCount )

			-- 스킬
			--{
				for ii=0, self._config.skill.count-1	do
					slot._skill[ii]._expBG		:SetShow( false )
					slot._skill[ii]._skillIcon	:SetShow( false )
					slot._skill[ii]._skillText	:SetShow( false )
					slot._skill[ii]._exp		:SetShow( false )
					slot._skill[ii]._expText	:SetShow( false )
				end
		
				slot._learnSkillCount	= 0
				local	tempIndex		= 0
				local	slotIndex		= 0
				local	learnSkillCount	= vehicleSkillStaticStatus_skillCount()
				for	jj=1, learnSkillCount-1	do
					local	skillWrapper= auctionServantInfo:getSkill(jj)
					if	nil ~=	skillWrapper	then
						if	slotIndex < self._config.skill.count	then
							if	slot._startSlotIndex <= tempIndex	then
								local expTxt = tonumber(string.format( "%.0f", ( auctionServantInfo:getSkillExp(jj) / (skillWrapper:get()._maxExp/100) ) ))
								if 100 <= expTxt then
									expTxt = 100
								end
								slot._skill[slotIndex]._skillIcon:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
								slot._skill[slotIndex]._skillText:SetText( skillWrapper:getName() )
		
								slot._skill[slotIndex]._exp:SetProgressRate( auctionServantInfo:getSkillExp(jj) / (skillWrapper:get()._maxExp/100) ) -- 숙련도
								slot._skill[slotIndex]._expText:SetText( expTxt .. "%")
		
								slot._skill[slotIndex]._expBG	:SetShow( true )
								slot._skill[slotIndex]._exp		:SetShow( true )
								slot._skill[slotIndex]._expText	:SetShow( true )
								slot._skill[slotIndex]._skillIcon	:SetShow( true )
								slot._skill[slotIndex]._skillText	:SetShow( true )
								slotIndex	= slotIndex + 1
							end
							tempIndex	= tempIndex + 1
						end
						slot._learnSkillCount	= slot._learnSkillCount + 1
					end
				end

				if 5 < slot._learnSkillCount then

					slot._skillPageValue	:SetText( string.format( "%.0f", (slot._startSlotIndex / self._config.skill.count)) + 1 )
					slot._skillPrevPage		:addInputEvent("Mouse_LUp", "StableMarket_ScrollEvent( " .. ii .. ", true )")
					slot._skillNextPage		:addInputEvent("Mouse_LUp", "StableMarket_ScrollEvent( " .. ii .. ", false )")

					slot._skillPrevPage		:SetShow( true )
					slot._skillPageValue	:SetShow( true )
					slot._skillNextPage		:SetShow( true )
				end
			--}
			
			-- 내 말 목록에서는 취소 or 수령.
			slot._buttonBuy:SetShow( false )
			slot._buttonCancel:SetShow( false )
			slot._buttonReceive:SetShow( false )
			slot._buttonEnd:SetShow( false )
			
			if	( StableMarket_IsTabMy() )	then
				-- 내 등록 목록이 면 남은  교배수를 끈다.
				slot._staticMatingCount:SetShow(true)
				slot._staticMatingCountValue:SetShow(true)
				
				local	isAuctionEnd	= auctionServantInfo:isAuctionEnd()
				local	servantInfo		= stable_getServantByServantNo( auctionServantInfo:getServantNo() )
				if	(nil ~= servantInfo)	then
					if	( CppEnums.ServantStateType.Type_RegisterMarket == servantInfo:getStateType() )	then
						if	( isAuctionEnd )	then
							slot._buttonEnd:SetShow( true )
						else
							slot._buttonCancel:SetShow( true )
						end
					else
						slot._buttonReceive:SetShow( true )
					end
				else
					slot._buttonReceive:SetShow( true )
				end
			else
				slot._buttonBuy:SetShow( true )
			end
			
			slot._baseSlot:SetShow(true)
			slotNo	= slotNo + 1
		end
	end
	
	if	StableMarket_IsTabMy()	then
		self._staticPageNo:SetText( self._selectPage + 1 )
	else
		self._staticPageNo:SetText( myAuctionInfo:getCurrentPage() + 1 )	
	end
	
end

----------------------------------------------------------------------------------------------------
-- Common
function	StableMarket_IsTabMy()
	local	self	= stableMarket
	
	return( self._isTabMy )
end

----------------------------------------------------------------------------------------------------
-- From Client Event
function	StableMarket_UpdateSlotData()
	local	self	= stableMarket
	
	self:update( true )
end

function	StableMarket_TabEventFromRegister()
	if	not Panel_Window_StableMarket:GetShow() then
		return
	end
	
	local	self	= stableMarket
	StableMarket_TabEventXXX( StableMarket_IsTabMy() )
end

function	StableMarket_UpdateMoney()
	local	self	= stableMarket
	
	self._staticInven:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
	self._staticWarehouse:SetText( makeDotMoney(warehouse_moneyFromNpcShop_s64()) )
end

----------------------------------------------------------------------------------------------------
-- Button Function
function	StableMarket_TabEvent( isTabMy )
	local	self	= stableMarket
	if	StableMarket_IsTabMy() == isTabMy	then
		return
	end
	
	StableMarket_TabEventXXX( isTabMy )
end

function	StableMarket_TabEventXXX( isTabMy )	
	local	self	= stableMarket
	self._selectPage	= 0
	self._selectMaxPage	= 200
	self._isTabMy		= isTabMy
	
	if	StableMarket_IsTabMy()	then
		requestMyServantMarketList()
		stableMarket._comboBox_SkillFilter:SetShow( false )
		stableMarket._comboGenFilter:SetShow( false )
		-- stableMarket._comboBox_Sex:SetShow( false )
	else
		RequestAuctionListPage( CppEnums.AuctionType.AuctionGoods_ServantMarket )		
		stableMarket._comboBox_SkillFilter:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_SKILL") )
		stableMarket._comboBox_SkillFilter:SetShow( true )
		stableMarket._comboGenFilter:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL") )
		stableMarket._comboGenFilter:SetShow( true )
		-- stableMarket._comboBox_Sex:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_SEXFILTER") )
		-- stableMarket._comboBox_Sex:SetShow( true )
		setAuctionServantSkillFilter( 0 )
		SetAuctionServantTierFilter( 0 )
		-- setAuctionServantSexFilter( 2 )
	end
end

function	StableMarket_NextPage()
	audioPostEvent_SystemUi(00,00)

	local	self	= stableMarket
	
	if	self._selectMaxPage <= self._selectPage	then
		return
	end

	self._selectPage	= self._selectPage + 1
	if	StableMarket_IsTabMy()	then
		self:update( true )
	else
		RequestAuctionNextPage()
	end
end

function	StableMarket_PrevPage()
	audioPostEvent_SystemUi(00,00)
	local	self	= stableMarket
	
	if	0 < self._selectPage	then
		self._selectPage	= self._selectPage - 1
	end
		
	if	StableMarket_IsTabMy()	then
		self:update( true )
	else
		RequestAuctionPrevPage()
	end
end

function	StableMarket_Buy( slotNo )
	local	self		= stableMarket
	self._selectSlotNo	= slotNo
	
	local	titleString		= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
	local	contentString	= PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_BUY_NOTIFY")
	local	messageboxData	= { title = titleString, content = contentString, functionYes = StableMarket_BuyXXX, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function	StableMarket_BuyXXX()
	local	self			= stableMarket
	local	fromWhereType	= CppEnums.ItemWhereType.eInventory
	if( self._radioWarehouse:IsCheck() )	then
		fromWhereType	= CppEnums.ItemWhereType.eWarehouse
	end
	
	stable_requestBuyItNowServant( self._selectSlotNo, fromWhereType )
	
	self._selectSlotNo	= nil
end

function	StableMarket_Cancel( slotNo )
	local stableMarket_CancelDo = function()
		local	selectSlotNo	= (stableMarket._selectPage * stableMarket._config.slotCount) + slotNo
		stable_cancelServantFromSomeWhereElse( selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket )
	end
	
	local	titleString		= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
	local	contentString	= PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_ITEMSET_REGISTCANCEL_DO")
	local	messageboxData	= { title = titleString, content = contentString, functionYes = stableMarket_CancelDo, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function	StableMarket_Receive( slotNo )
	local	self			= stableMarket
	local	selectSlotNo	= (self._selectPage * self._config.slotCount) + slotNo
	local	toWhereType	= CppEnums.ItemWhereType.eInventory
	if( self._radioWarehouse:IsCheck() )	then
		toWhereType	= CppEnums.ItemWhereType.eWarehouse
	end
	
	stable_popServantPrice( selectSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket, toWhereType )
end

function	StableMarket_ScrollEvent( slotNo, isUp )	
	local	self		= stableMarket
	local	slot		= self._slots[slotNo]
	
	local	maxSlotNo	= slot._learnSkillCount - self._config.skill.count
	
	if	( isUp )	then
		if	(0 < slot._startSlotIndex )	then
			slot._startSlotIndex	=  slot._startSlotIndex - self._config.skill.count
		end
	else
		if	(slot._startSlotIndex < maxSlotNo )	then
			slot._startSlotIndex	=  slot._startSlotIndex + self._config.skill.count
		end
	end
	
	self:update( false )
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	StableMarket_Open()
	local	self	= stableMarket
	
	-- 창을 해상도에 맞춰 화면 중앙에 위치 시킨다.
	Panel_Window_StableMarket:SetPosX( (getScreenSizeX()/2) - (Panel_Window_StableMarket:GetSizeX()/2) )
	Panel_Window_StableMarket:SetPosY( (getScreenSizeY()/2) - (Panel_Window_StableMarket:GetSizeY()/2) - 20 )
	
	if	Panel_Window_StableMarket:GetShow()	then
		return
	end

	if Panel_Window_StableMating:GetShow() then
		StableMating_Close()
	end

	if Panel_Window_StableMix:GetShow() then
		StableMix_Close()
	end
	
	--창고 돈을 보여 줘야 함으로, UI를 열때 정보를 요청한다.
	--{
		warehouse_requestInfoFromNpc()
		
		self._radioInven:SetEnableArea( 0, 0, 230, self._radioInven:GetSizeY())
		self._radioWarehouse:SetEnableArea( 0, 0, 230, self._radioWarehouse:GetSizeY())

		self._radioInven:SetCheck(true)
		self._radioWarehouse:SetCheck(false)
	--}	
	
	self._selectSlotNo	= nil
	self._selectPage	= 0
	self._selectMaxPage	= 100
	self._isTabMy		= true
	self._buttonTabMy:SetCheck( false )
	self._buttonTabMarket:SetCheck( true )
	
	setAuctionServantSkillFilter( 0 )
	stableMarket._comboBox_SkillFilter:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_SKILL") )
	SetAuctionServantTierFilter( 0 )
	stableMarket._comboGenFilter:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL") )
	StableMarket_TabEvent( false )
	
	Panel_Window_StableMarket:SetShow(true)
end

function	StableMarket_Close()
	if	(not Panel_Window_StableMarket:IsShow() )	then
		return
	end
	
	Panel_Window_StableMarket:SetShow(false)
end

----------------------------------------------------------------------------------------------------
-- Filter
function StableMarket_CreateFilter()
	local self = stableMarket
	for ii = 0, 8  do
		self._comboGenFilter:AddItem( stableServantGen[ii], ii )
	end
end
StableMarket_CreateFilter()

local filterGeneSelectedId	= 0
local filterGen_id			= 0
function StableMarket_ShowGenFilter()
	local self = stableMarket

------------------------------

	Panel_Window_StableMarket:SetChildIndex(self._comboGenFilter, 9999 )
	local	list = self._comboGenFilter:GetListControl()
	list:addInputEvent( "Mouse_LUp", "StableMarket_ToggleFilterGenSelect()" )

	self._comboGenFilter:SetSelectItemKey( filterGeneSelectedId )

	local tmp = self._comboGenFilter:GetListControl()
	local listCount = tmp:GetItemSize()
	tmp:SetSize( tmp:GetSizeX(), listCount*20 )
	-- filter_Zone_Scroll:SetSize( filter_QuestType_Scroll:GetSizeX(), tmp:GetSizeY() )
	tmp:SetItemQuantity(listCount)
	self._comboGenFilter:ToggleListbox()
end

function StableMarket_ToggleFilterGenSelect()
	local self = stableMarket
	local	selectIndex		= self._comboGenFilter:GetSelectIndex()
	if		0 ==	selectIndex	then	filterGen_id = 0;	filterGeneSelectedId = 0
	elseif	1 ==	selectIndex then	filterGen_id = 1;	filterGeneSelectedId = 1
	elseif	2 ==	selectIndex then	filterGen_id = 2;	filterGeneSelectedId = 2
	elseif	3 ==	selectIndex then	filterGen_id = 3;	filterGeneSelectedId = 3
	elseif	4 ==	selectIndex then	filterGen_id = 4;	filterGeneSelectedId = 4
	elseif	5 ==	selectIndex then	filterGen_id = 5;	filterGeneSelectedId = 5
	elseif	6 ==	selectIndex then	filterGen_id = 6;	filterGeneSelectedId = 6
	elseif	7 ==	selectIndex then	filterGen_id = 7;	filterGeneSelectedId = 7
	elseif	8 ==	selectIndex then	filterGen_id = 8;	filterGeneSelectedId = 8
	else
		filterGen_id = 0;	filterGeneSelectedId = 0
	end
	SetAuctionServantTierFilter( filterGen_id )
	self._comboGenFilter:SetSelectItemKey( filterGeneSelectedId )
	StableMarket_ShowGenFilter()
end

function StableMarket_SetGenFilter( index )
	local self = stableMarket
	if nil == index then
		self._comboGenFilter:SetSelectItemIndex(self._comboGenFilter:GetSelectIndex())
		selectFilterNo = self._comboGenFilter:GetSelectIndex()
	else
		self._comboGenFilter:SetSelectItemIndex( index )
	end
	
	local territoryKey = self._comboGenFilter:GetSelectIndex()
	self._comboGenFilter:SetText( stableServantGen[territoryKey] )
	self._comboGenFilter:ToggleListbox()
end

function HandleClicked_StableMarket_SkillFilter()
	stableMarket._comboBox_SkillFilter:DeleteAllItem()
	stableMarket._comboBox_SkillFilter:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL"), 1 )
	
	for index = 1, 19 do		-- 말 기술 개수
		local skillWrapper = getVehicleSkillStaticStatus( index )
		local skillKey = skillWrapper:getKey()
		stableMarket._comboBox_SkillFilter:AddItem( skillWrapper:getName(), index )
	end
	stableMarket._comboBox_SkillFilter:ToggleListbox()
end

function StableMarket_SetSkillFilter()
	local selectSkillIndex = stableMarket._comboBox_SkillFilter:GetSelectIndex()
	stableMarket._comboBox_SkillFilter:ToggleListbox()
	if 0 < selectSkillIndex then
		setAuctionServantSkillFilter( selectSkillIndex )
		stableMarket._comboBox_SkillFilter:SetText( getVehicleSkillStaticStatus(selectSkillIndex):getName() )
	else
		setAuctionServantSkillFilter( 0 )
		stableMarket._comboBox_SkillFilter:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL") )
	end
end

----------------------------------------------------------------------------------------------------
-- Init

stableMarket:init()
stableMarket:registEventHandler()
stableMarket:registMessageHandler()

StableMarket_Resize()
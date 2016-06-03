Panel_Window_StableInfo:SetShow(false, false)
Panel_Window_StableInfo:setMaskingChild(true)
Panel_Window_StableInfo:ActiveMouseEventEffect(true)
Panel_Window_StableInfo:SetDragEnable( true )

Panel_Window_StableInfo:RegisterShowEventFunc( true,	'StableInfoShowAni()' )
Panel_Window_StableInfo:RegisterShowEventFunc( false,	'StableInfoHideAni()' )

local UI_ANI_ADV 		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 			= Defines.Color
local isContentsEnable	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 60 ) -- 말 기술 훈련

UI.getChildControl( Panel_Window_StableInfo, "Stable_Info_Ability"):setGlassBackground(true)
UI.getChildControl( Panel_Window_StableInfo, "Panel_Skill"):setGlassBackground(true)

function	StableInfoShowAni()
	Panel_Window_StableInfo:SetShow(true, false)

	UIAni.fadeInSCR_Right(Panel_Window_StableInfo)
	local aniInfo3 = Panel_Window_StableInfo:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = false
end

function	StableInfoHideAni()
	Panel_Window_StableInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_StableInfo:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)

	-- local aniInfo2 = Panel_Window_StableInfo:addScaleAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	-- aniInfo2:SetStartScale(1.0)
	-- aniInfo2:SetEndScale(0.97)
	-- aniInfo2.AxisX = 200
	-- aniInfo2.AxisY = 295
	-- aniInfo2.IsChangeChild = true
end

local stableInfo	=
{
	_config	=
	{
		slot	=
		{
			startX			= 5,
			startY			= 5,
			startBGX		= 10,
			startBGY		= 38,
			startScrollX	= 319,
			startScrollY	= 13,
			buttonSizeX		= 60,
			halfButtonSizeY	= 28,
			
			gapY			= 66,
			
			count			= 4,
		},
		
		skill	=
		{
			startIconX	= 5,
			startIconY	= 7,
			startNameX	= 59,
			startNameY	= 7,
			startDecX	= 59,
			startDecY	= 28,
			startExpBGX	= 0,
			startExpBGY	= 2,
			startExpX	= 2,
			startExpY	= 4,
			startButtonX= 251,
			startButtonY= 4,			
		},
	},
	----------------------------------------------------------------------
	-- 기본 정보
	_maleIcon						= UI.getChildControl( Panel_Window_StableInfo,	"Static_MaleIcon"					),	-- 수컷 아이콘
	_femaleIcon						= UI.getChildControl( Panel_Window_StableInfo,	"Static_FemaleIcon"					),	-- 암컷 아이콘
	
	_staticName						= UI.getChildControl(Panel_Window_StableInfo,	"StaticText_Name"					),
	_staticLevel					= UI.getChildControl(Panel_Window_StableInfo,	"Static_Text_Level"					),
	
	_staticHpGauge					= UI.getChildControl(Panel_Window_StableInfo,	"HP_GaugeBar"						),
	_staticMpGauge					= UI.getChildControl(Panel_Window_StableInfo,	"MP_GaugeBar"						),
	_staticExpGauge					= UI.getChildControl(Panel_Window_StableInfo,	"EXP_GaugeBar"						),
	_staticWeightGauge				= UI.getChildControl(Panel_Window_StableInfo,	"Weight_GaugeBar"					),

	_staticHPTitle					= UI.getChildControl(Panel_Window_StableInfo,	"HP"								),
	_staticMPTitle					= UI.getChildControl(Panel_Window_StableInfo,	"MP"								),
	
	_staticHP						= UI.getChildControl( Panel_Window_StableInfo,	"HP_CountData"						),
	_staticMP						= UI.getChildControl( Panel_Window_StableInfo,	"MP_CountData"						),
	_staticEXP						= UI.getChildControl( Panel_Window_StableInfo,	"EXP_CountData"						),
	_staticWeight					= UI.getChildControl( Panel_Window_StableInfo,	"WHT_CountData"						),

	_staticTitleMaxMoveSpeed		= UI.getChildControl( Panel_Window_StableInfo,	"MaxMoveSpeed"						),
	_staticTitleAcceleration		= UI.getChildControl( Panel_Window_StableInfo,	"Acceleration"						),
	_staticTitleCorneringSpeed		= UI.getChildControl( Panel_Window_StableInfo,	"CorneringSpeed"					),
	_staticTitleBrakeSpeed			= UI.getChildControl( Panel_Window_StableInfo,	"BrakeSpeed"						),
	
	_staticMoveSpeed				= UI.getChildControl(Panel_Window_StableInfo,	"MaxMoveSpeedValue"					),
	_staticAcceleration				= UI.getChildControl(Panel_Window_StableInfo,	"AccelerationValue"					),
	_staticCornering				= UI.getChildControl(Panel_Window_StableInfo,	"CorneringSpeedValue"				),
	_staticBrakeSpeed				= UI.getChildControl(Panel_Window_StableInfo,	"BrakeSpeedValue"					),
	
	_staticMatingCount				= UI.getChildControl( Panel_Window_StableInfo,	"Static_MatingCount"				),
	_staticMatingCountValue			= UI.getChildControl( Panel_Window_StableInfo,	"Static_MatingCountValue"			),
	_staticMatingtime				= UI.getChildControl( Panel_Window_StableInfo,	"Static_MatingTime"					),
	_staticMatingtimeValue			= UI.getChildControl( Panel_Window_StableInfo,	"Static_MatingTimeValue"			),
	_staticTrainingTime				= UI.getChildControl( Panel_Window_StableInfo,	"Static_TrainingTime"				),
	_staticTrainingTimeValue		= UI.getChildControl( Panel_Window_StableInfo,	"Static_TrainingTimeValue"			),
	_btnMatingImmediately			= UI.getChildControl( Panel_Window_StableInfo,	"Button_MatingImmediately"			),
	_staticLife						= UI.getChildControl( Panel_Window_StableInfo,	"Static_LifeCount"					),
	_staticLifeValue				= UI.getChildControl( Panel_Window_StableInfo,	"Static_LifeCountValue"				),
	_staticImprint					= UI.getChildControl( Panel_Window_StableInfo,	"Static_Imprint"					),
	_staticImprintValue				= UI.getChildControl( Panel_Window_StableInfo,	"Static_ImprintValue"				),
	
	_staticSkillPanel				= UI.getChildControl( Panel_Window_StableInfo,	"Panel_Skill"						),

	_deadCount						= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_DeadCount"				),
	_deadCountValue					= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_DeadCountValue"			),
	
	panel_abillity					= UI.getChildControl( Panel_Window_StableInfo,	"Stable_Info_Ability"				),
	
	_staticWantSkillBG				= UI.getChildControl( Panel_Window_StableInfo,	"Static_WantSkillBG"				),
	_staticChangeBG					= UI.getChildControl( Panel_Window_StableInfo,	"Static_ChangeSkillBG"				),
	_staticChangeTitle				= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_ChangeSkillTitle"		),
	_staticSkillTargetName			= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_ChangeSkillName"		),
	_staticSkillTargetIcon			= UI.getChildControl( Panel_Window_StableInfo,	"Static_ChangeSkillIcon"			),
	_staticSkillTargetCount			= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_ChangeSkillCount"		),
	_staticTextChangeDesc			= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_ChangeSkillDesc"		),
	
	_startSlotIndex					= 0,
	_temporaySlotCount				= 0,
	_temporayLearnSkillCount		= 0,
	currentServantType				= nil,
	_skill							= Array.new(),
	
	-- 스킬 슬롯 번호 임시 저장 변수 초기화
	_fromSkillKey					= nil,
	_toSkillKey						= nil,
}

local carrageInfo = 
{
	_panel							= UI.getChildControl( Panel_Window_StableInfo,	"Carriage_Info" ),
	_title							= UI.getChildControl( Panel_Window_StableInfo,	"Static_CarriageInfo_Title" ),
	_bg								= UI.getChildControl( Panel_Window_StableInfo,	"Static_AddHorseBG" ),
	_maxCount						= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_CarriageSlotMaxCount" ),
	_maxCountValue					= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_MaxCountValue" ),
	
	_horseSlot						= UI.getChildControl( Panel_Window_StableInfo,	"Static_CarriageHorse" ),
	_name							= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_CarriageHorse_Name" ),
	_level							= UI.getChildControl( Panel_Window_StableInfo,	"StaticText_Horse_Level" ),
	_btnRelease						= UI.getChildControl( Panel_Window_StableInfo,	"Button_ReleaseHorse" ),
	_expText						= UI.getChildControl( Panel_Window_StableInfo,	"Horse_EXP_CountData" ),
	_expBg							= UI.getChildControl( Panel_Window_StableInfo,	"Horse_EXP_Bg" ),
	_expGauge						= UI.getChildControl( Panel_Window_StableInfo,	"Horse_EXP_GaugeBar" ),
	
	slotCount = 4,	-- 현재 4두마차까지
	gapY = 68,
	baseSlot = {}
}

function carrageInfo:init()
	for index = 0, self.slotCount - 1 do
		local temp = {}
		temp._horseSlot	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_StableInfo, "Static_HorseSlot_" .. index )
		CopyBaseProperty( self._horseSlot, temp._horseSlot )
		temp._horseSlot:SetPosY( self._horseSlot:GetPosY() + self.gapY * index )
	
		temp._name	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_StableInfo, "StaticText_CarriageHorse_Name_" .. index )
		CopyBaseProperty( self._name, temp._name )
		temp._name:SetPosY( self._name:GetPosY() + self.gapY * index )

		temp._level	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_StableInfo, "StaticText_Horse_Level_" .. index )
		CopyBaseProperty( self._level, temp._level )
		temp._level:SetPosY( self._level:GetPosY() + self.gapY * index )

		temp._btnRelease	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_Window_StableInfo, "Button_ReleaseHorse_" .. index )
		CopyBaseProperty( self._btnRelease, temp._btnRelease )
		temp._btnRelease:SetPosY( self._btnRelease:GetPosY() + self.gapY * index )

		temp._expText	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_StableInfo, "Horse_EXP_CountData_" .. index )
		CopyBaseProperty( self._expText, temp._expText )
		temp._expText:SetPosY( self._expText:GetPosY() + self.gapY * index )

		temp._expBg	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_StableInfo, "Horse_EXP_Bg_" .. index )
		CopyBaseProperty( self._expBg, temp._expBg )
		temp._expBg:SetPosY( self._expBg:GetPosY() + self.gapY * index )

		temp._expGauge	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_StableInfo, "Horse_EXP_GaugeBar_" .. index )
		CopyBaseProperty( self._expGauge, temp._expGauge )
		temp._expGauge:SetPosY( self._expGauge:GetPosY() + self.gapY * index )
		
		self.baseSlot[index] = temp
	end
end
carrageInfo:init()



function carrageInfo_Check( carriageNo )
	stableInfo._staticSkillPanel:SetShow(false)
	carrageInfo:open()
	
	local servantInfo = stable_getServantByServantNo( carriageNo )
	-- if 0 == carriageNo then
		-- local temporaryWrapper	= getTemporaryInformationWrapper()
		-- servantInfo		= temporaryWrapper:getUnsealVehicle( stable_getServantType() )
	-- else
		-- servantInfo = stable_getServantByServantNo( carriageNo )
	-- end
	
	if nil == servantInfo then
		return
	end
	
	carrageInfo._maxCountValue:SetText( servantInfo:getCurrentLinkCount() .. " / " .. servantInfo:getLinkCount() )
	
	local servantCount = stable_count()
	local linkedCount = 0
	for index = 0, servantCount -1 do
		local sInfo = stable_getServant( index )
		if nil ~= sInfo then
			if sInfo:isLink() then
				if carriageNo == sInfo:getOwnerServantNo_s64() then
					for v, control in pairs (carrageInfo.baseSlot[linkedCount]) do
						control:SetShow( true )
					end
					
					-- 붙은 말 정보 세팅
					local linkedHorse		= carrageInfo.baseSlot[linkedCount]
					linkedHorse._horseSlot	:ChangeTextureInfoName( sInfo:getIconPath1() )
					linkedHorse._name		:SetText( sInfo:getName() )
					linkedHorse._level		:SetText( "Lv."..tostring(sInfo:getLevel()) )
					linkedHorse._expText	:SetText( makeDotMoney(sInfo:getExp_s64()).." / "..makeDotMoney(sInfo:getNeedExp_s64()) )
					
					-- 경험치
					local s64_exp			= sInfo:getExp_s64()
					local s64_needexp		= sInfo:getNeedExp_s64()
					local s64_exp_percent	= Defines.s64_const.s64_0
					if	Defines.s64_const.s64_0 < s64_exp	then
						s64_exp_percent	= ( 190 / 100 ) * ( (Int64toInt32(s64_exp) / Int64toInt32(s64_needexp)) * 100 )
					end
					linkedHorse._expGauge	:SetSize( s64_exp_percent, 6 )
					
					if nil == StableList_SelectSlotNo() then
						linkedHorse._btnRelease:addInputEvent( "Mouse_LUp", "ReleaseFromCarriage()" )
					else
						linkedHorse._btnRelease:addInputEvent( "Mouse_LUp", "ReleaseFromCarriage(" .. index .. ", " .. StableList_SelectSlotNo() .. ")" )
					end
					
					linkedCount = linkedCount + 1
				end
			end
		end
	end
	
end

function ReleaseFromCarriage( servantSlotNo, CarriageSlotNo )
	if nil == servantSlotNo then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT") )
		return
	end

	local releaseCarriage = function()
		stable_link( servantSlotNo, CarriageSlotNo, false )
		FGlobal_StableList_Update()
	end

	local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_CARRIAGE_UNLINK_ALERT")
	local messageBoxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_CARRIAGE_UNLINK"), content = messageBoxMemo, functionYes = releaseCarriage, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function carrageInfo:open()
	if self._panel:GetShow() then
		return
	end

	self._panel:SetShow( true )
	self._title:SetShow( true )
	self._bg:SetShow( true )
	self._maxCount:SetShow( true )
	self._maxCountValue:SetShow( true )
end

function carrageInfo:close()
	if not self._panel:GetShow() then
		return
	end
	
	self._panel:SetShow( false )
	self._title:SetShow( false )
	self._bg:SetShow( false )
	self._maxCount:SetShow( false )
	self._maxCountValue:SetShow( false )
	
	for index = 0, 3 do
		for v, control in pairs (carrageInfo.baseSlot[index]) do
			control:SetShow( false )
		end
	end
end

function	stableInfo:clear()
	self._fromSkillKey	= nil
	self._toSkillKey	= nil
end

function	stableInfo:init()

	self._staticSkillTitle	= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Skill_Title",						self._staticSkillPanel,	"StableInfo_SkillTitle"		)
	self._staticSkillBG		= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Static_SkillBG",					self._staticSkillPanel,	"StableInfo_SkillBG"		)	
	self._scrollSkill		= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Scroll_Skill",						self._staticSkillBG,	"StableInfo_SkillScroll"	)
	
	local	slotConfig	= self._config.slot
	self._staticSkillBG:SetPosX(slotConfig.startBGX		)
	self._staticSkillBG:SetPosY(slotConfig.startBGY		)
	self._scrollSkill:SetPosX(	slotConfig.startScrollX	)
	self._scrollSkill:SetPosY(	slotConfig.startScrollY	)
	
	self._staticSkillBG:addInputEvent(	"Mouse_UpScroll",		"StableInfo_ScrollEvent( true )"	)
	self._staticSkillBG:addInputEvent(	"Mouse_DownScroll",		"StableInfo_ScrollEvent( false )"	)
	
	for ii=0, (self._config.slot.count-1)	do
		local slot	= {}
		
		slot.base			= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Button_Skill",					self._staticSkillBG,	"StableInfo_Skill_"			.. ii )
		slot.expBG			= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Static_SkillExpBG",			slot.base,				"StableInfo_SkillExpBG_"	.. ii )
		slot.exp			= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Gauge_SkillExp",				slot.base,				"StableInfo_SkillExp_"		.. ii )
		slot.icon			= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Static_SkillIcon",				slot.base,				"StableInfo_SkillIcon"		.. ii )
		slot.expStr			= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"SkillLearn_PercentString",		slot.base,				"StableInfo_SkillExpStr_"	.. ii )
		slot.name			= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Static_Text_SkillName",		slot.base,				"StableInfo_SkillName_"		.. ii )
		slot.dec			= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Static_Text_SkillCondition",	slot.base,				"StableInfo_SkillDec_"		.. ii )
		slot.button			= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Button_SkillChange",			slot.base,				"StableInfo_SkillButton_"	.. ii )
		slot.buttonDel		= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Button_SkillDelete",			slot.base,				"StableInfo_SkillDelButton_"	.. ii )
		slot.buttonLock		= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Button_SkillLock",				slot.base,				"StableInfo_SkillLock_"		.. ii )
		slot.buttonTarget	= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Button_SkillTarget",			slot.base,				"StableInfo_SkillTarget_"	.. ii )
		slot.buttonTraining	= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Button_SkillTraining",			slot.base,				"StableInfo_SkillTraining_"	.. ii )

		slot.base:SetPosX( slotConfig.startX )
		slot.base:SetPosY( slotConfig.startY + slotConfig.gapY * ii )
		
		local	skillConfig	= self._config.skill
		slot.icon	:SetPosX(	skillConfig.startIconX	)
		slot.icon	:SetPosY(	skillConfig.startIconY	)
		slot.name	:SetPosX(	skillConfig.startNameX	)
		slot.name	:SetPosY(	skillConfig.startNameY	)
		slot.dec	:SetPosX(	skillConfig.startDecX	)
		slot.dec	:SetPosY(	skillConfig.startDecY	)
		slot.expBG	:SetPosX(	skillConfig.startExpBGX	)
		slot.expBG	:SetPosY(	skillConfig.startExpBGY	)
		slot.exp	:SetPosX(	skillConfig.startExpX	)
		slot.exp	:SetPosY(	skillConfig.startExpY	)
		slot.expStr	:SetPosX(	(skillConfig.startIconX) + 10	)
		slot.expStr	:SetPosY(	(skillConfig.startIconY) + 30	)
		slot.button	:SetPosX(skillConfig.startButtonX + 10)
		slot.button	:SetPosY(skillConfig.startButtonY)
		slot.buttonDel	:SetPosX(skillConfig.startButtonX + 10)
		slot.buttonDel	:SetPosY(skillConfig.startButtonY + 30 )
		slot.buttonLock:SetPosX(skillConfig.startButtonX + 10)
		slot.buttonLock:SetPosY(skillConfig.startButtonY)
		slot.buttonTarget:SetPosX(skillConfig.startButtonX + 10)
		slot.buttonTarget:SetPosY(skillConfig.startButtonY)
		slot.buttonTraining:SetPosX(skillConfig.startButtonX - 42)
		slot.buttonTraining:SetPosY(skillConfig.startButtonY)
		
		slot.base:addInputEvent(		"Mouse_UpScroll",		"StableInfo_ScrollEvent( true )"	)
		slot.base:addInputEvent(		"Mouse_DownScroll",		"StableInfo_ScrollEvent( false )"	)
		slot.button:addInputEvent(		"Mouse_LUp",			"Button_SkillChange("..ii..")"		)
		slot.buttonDel:addInputEvent(	"Mouse_LUp",			"Button_Skill_Delete(" .. ii .. ")"	)
		slot.buttonTarget:addInputEvent("Mouse_LUp",			"Button_SkillTarget("..ii..")"		)
		slot.buttonTraining:addInputEvent("Mouse_LUp",			"Button_SkillTraining("..ii..")"	)
		
		slot.key	= 0
		self._skill[ii]	= slot
	end
	-- 스킬을 덮어야 하기 때문에 아래서 선언함.
	self._staticSkillEffect	= UI.createAndCopyBasePropertyControl( Panel_Window_StableInfo,	"Static_SkillIChange_EffectPanel",	self._staticSkillBG,	"StableInfo_SkillEffect"	)
end

function FGlobal_StableList_UnsealInfo( unsealType )
	StableInfo_Open( unsealType )
end

function	stableInfo:update( unsealType )
	-- unsealtype : nil or 0 >> sealpet이 선택된 상황
	-- unsealtype : 1 >> unsealpet이 선택된 상황
	-- unsealtype : 2 >> tamingpet이 선택된 상황(이 땐 업데이트하지 않음)
	
	if nil == unsealType and nil ~= StableList_SelectSlotNo() then
		unsealType = 0
	end
	
	if nil == StableList_SelectSlotNo() then
		unsealType = 1
	end
	
	local servantInfo		= nil
	if 1 == unsealType then
		local temporaryWrapper	= getTemporaryInformationWrapper()
		if nil == temporaryWrapper then
			return
		end
		servantInfo		= temporaryWrapper:getUnsealVehicle( stable_getServantType() )
	elseif 2 == unsealType then
		-- servantInfo		= 
	else
		servantInfo		= stable_getServant( StableList_SelectSlotNo() )
	end

	if	( nil == servantInfo )	then
		StableInfo_Close()
		return
	end

	if servantInfo:getVehicleType() ~= CppEnums.VehicleType.Type_Horse then
		self._staticWantSkillBG:SetShow( false )
		self._staticChangeBG:SetShow( false )
		self._staticChangeTitle:SetShow( false )
		self._staticSkillTargetName:SetShow( false )
		self._staticSkillTargetIcon:SetShow( false )
		self._staticSkillTargetCount:SetShow( false )
		self._staticTextChangeDesc:SetShow( false )
	end

	self._staticName:SetText(	servantInfo:getName()																)
	self._staticLevel:SetText(	"Lv."..tostring(servantInfo:getLevel())												)

	self._staticHP:SetText(		makeDotMoney(servantInfo:getHp()).. " / " ..makeDotMoney(servantInfo:getMaxHp())				)
	self._staticMP:SetText(		makeDotMoney(servantInfo:getMp()).. " / " ..makeDotMoney(servantInfo:getMaxMp())				)
	self._staticWeight:SetText(	makeDotMoney(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000)				)
	self._staticEXP:SetText(	makeDotMoney(servantInfo:getExp_s64()).." / "..makeDotMoney(servantInfo:getNeedExp_s64())	)
	
	self._staticHpGauge:SetSize(250 / 100 * (( servantInfo:getHp() / servantInfo:getMaxHp())*100)	,6)
	self._staticMpGauge:SetSize(250 / 100 * (( servantInfo:getMp() / servantInfo:getMaxMp())*100)	,6)
	-- 경험치
	local	s64_exp			= servantInfo:getExp_s64()
	local	s64_needexp		= servantInfo:getNeedExp_s64()
	local	s64_exp_percent	= Defines.s64_const.s64_0
	if	Defines.s64_const.s64_0 < s64_exp	then
		s64_exp_percent	= ( 250 / 100 ) * ( (Int64toInt32(s64_exp) / Int64toInt32(s64_needexp)) * 100 )
	end
	self._staticExpGauge:SetSize( s64_exp_percent, 6 )
	
	-- 스텟 입력
	-- if ( servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse ) then
		self._staticMoveSpeed:SetText(		string.format( "%.1f",((servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed))/10000))	.. "%" )	-- 속도
		self._staticAcceleration:SetText(	string.format( "%.1f",((servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration))/10000))	.. "%" )	-- 가속도
		self._staticCornering:SetText(		string.format( "%.1f",((servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed))/10000))	.. "%" )	-- 코너링
		self._staticBrakeSpeed:SetText(		string.format( "%.1f",((servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed))/10000))		.. "%" )	-- 브레이크
		self._staticTitleMaxMoveSpeed:SetShow( true )
		self._staticTitleAcceleration:SetShow( true )
		self._staticTitleCorneringSpeed:SetShow( true )
		self._staticTitleBrakeSpeed:SetShow( true )
		self._staticMoveSpeed:SetShow( true )
		self._staticAcceleration:SetShow( true )
		self._staticCornering:SetShow( true )
		self._staticBrakeSpeed:SetShow( true )
	-- else
		-- self._staticMoveSpeed:SetText("")
		-- self._staticAcceleration:SetText("")
		-- self._staticCornering:SetText("")
		-- self._staticBrakeSpeed:SetText("")
		-- self._staticTitleMaxMoveSpeed:SetShow( false )
		-- self._staticTitleAcceleration:SetShow( false )
		-- self._staticTitleCorneringSpeed:SetShow( false )
		-- self._staticTitleBrakeSpeed:SetShow( false )
		-- self._staticMoveSpeed:SetShow( false )
		-- self._staticAcceleration:SetShow( false )
		-- self._staticCornering:SetShow( false )
		-- self._staticBrakeSpeed:SetShow( false )
	-- end

	-- 죽은 횟수
	self._deadCount:SetShow( false )
	self._deadCountValue:SetShow( false )

	self._deadCount:SetShow( true )
	self._deadCountValue:SetShow( true )

	local deadCount = servantInfo:getDeadCount()		
	if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
		self._deadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_KILLCOUNT") ) -- "죽은 횟수")
	elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage then
		self._deadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT") ) -- "파괴 횟수")
	elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
		self._deadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT") ) -- "파괴 횟수")
	end

	if servantInfo:doClearCountByDead() then
		deadCount = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", deadCount ) -- deadCount .. " (초기화 가능)"
	else
		deadCount = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", deadCount ) -- deadCount .. " (초기화 불가)"
	end
	self._deadCountValue:SetText( deadCount )

	-- 수명 입력
	if	( servantInfo:isPeriodLimit() )	then
		self._staticLifeValue:SetText( convertStringFromDatetime(servantInfo:getExpiredTime()) )
	else
		self._staticLifeValue:SetText( PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE") )
	end	
	
	if ( servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage ) or ( servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage ) then
		self._staticHPTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_DURABILITY") )
		self._staticMPTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_LIFE") )
		self._staticLife:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_PERIOD") )
	else
		self._staticHPTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_NAME") )
		self._staticMPTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_STAMINA") )
	end
	
	-- 교배 정보
	--{
		self._maleIcon:SetShow(false)
		self._femaleIcon:SetShow(false)
		self._staticMatingCount:SetShow(false)
		self._staticMatingCountValue:SetShow(false)
		self._staticMatingtime:SetShow(false)
		self._staticMatingtimeValue:SetShow(false)
		self._btnMatingImmediately:SetShow(false)
		self._staticTrainingTime:SetShow(false)
		self._staticTrainingTimeValue:SetShow(false)

		-- 말 일 경우 성별 아이콘 표시 (캐쉬말 때문에 doMating() 이전에 설정) --------------------------
		if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
			if ( servantInfo:isMale() ) then
				self._maleIcon	:SetShow( true )
				self._femaleIcon:SetShow( false )
			else
				self._maleIcon	:SetShow( false )
				self._femaleIcon:SetShow( true )
			end
		else
			self._maleIcon		:SetShow( false )
			self._femaleIcon	:SetShow( false )
		end
		------------------------------------------------------------------------------------------------
		
		if servantInfo:doMating() then		
			-- 교배 남은 횟수
			local	matingCount	= servantInfo:getMatingCount()
			if servantInfo:doClearCountByMating() then
				matingCount = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETOK", "deadCount", matingCount ) -- matingCount .. " (초기화 가능)"
			else
				matingCount = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLEINFO_RESETNO", "deadCount", matingCount ) -- matingCount .. " (초기화 불가)"
			end
			self._staticMatingCountValue:SetText( matingCount )
			self._staticMatingCount:SetShow(true)
			self._staticMatingCountValue:SetShow( true )

			-- 즉시 완료
			if	( CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() )	then
				if	( not servantInfo:isMatingComplete() )	then
					self._staticMatingtimeValue:SetText( convertStringFromDatetime( servantInfo:getMatingTime() ) )
					self._staticMatingtime:SetShow( true )
					self._staticMatingtimeValue:SetShow( true )
					if	( FGlobal_IsCommercialService() )	then
						if	( not servantInfo:isMale() )	then
							self._btnMatingImmediately:SetShow( true )
						end
					end
				end
			end
			
			-- 교배 표시 여부에 따라 '각인' 텍스트 위치 조정
			self._staticImprint:SetSpanSize( -10, 220 )
			self._staticImprintValue:SetTextHorizonRight()
			self._staticImprintValue:SetSpanSize( 50, 220 )
		else
			self._staticImprint:SetSpanSize( -215, 220 )
			self._staticImprintValue:SetTextHorizonLeft()
			self._staticImprintValue:SetSpanSize( -117, 220 )
		end
	--}
	
	-- 각인 여부(생명력 있는 탑승물만 각인 가능함.)
	if (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse) or (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel) or (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey) or (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant) then
		stableInfo.panel_abillity:SetSize( 350, 250 )
	else
		stableInfo.panel_abillity:SetSize( 350, 225 )
	end
	
	self._staticImprint:SetShow( false )
	self._staticImprintValue:SetShow( false )
	if ( servantInfo:isImprint() ) then
		self._staticImprint:SetShow( true )
		self._staticImprintValue:SetShow( true )
		self._staticImprintValue:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTING") ) -- "사용중" )
		--Panel_Window_StableInfo:SetSpanSize(  )
	elseif (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse) or (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel) or (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey) or (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant) then
		self._staticImprint:SetShow( true )
		self._staticImprintValue:SetShow( true )
		self._staticImprintValue:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTPOSSIBLE") ) -- "가능" )
		--Panel_Window_StableInfo:SetSpanSize(  )
	end

	-- to_do 공격력 방어력 둘다 표시안되고 있음	
	
	-- 스킬
	self:updateSkill( unsealType )
end

function FGlobal_StableInfoUpdate()
	-- if stableIdx == 1 then
	-- 	stable_recovery( StableList_SelectSlotNo() )
	-- elseif stableIdx == 2 then
	-- 	stable_revive( StableList_SelectSlotNo() )
	-- end

	local self = stableInfo
	local servantInfo		= stable_getServant( StableList_SelectSlotNo() )
	if nil ~= servantInfo then
		return
	end
	
	self._staticHP:SetText(		tostring(servantInfo:getHp()).. " / " ..tostring(servantInfo:getMaxHp()) )
	self._staticMP:SetText(		tostring(servantInfo:getMp()).. " / " ..tostring(servantInfo:getMaxMp()) )
	self._staticHpGauge:SetSize(250 / 100 * (( servantInfo:getHp() / servantInfo:getMaxHp())*100) ,6)
	self._staticMpGauge:SetSize(250 / 100 * (( servantInfo:getMp() / servantInfo:getMaxMp())*100) ,6)
end

function	stableInfo:updateSkill( unsealType )
	self.currentServantType = unsealType
	
	local servantInfo		= nil
	if 1 == unsealType then
		local temporaryWrapper	= getTemporaryInformationWrapper()
		if nil ~= temporaryWrapper then
			servantInfo		= temporaryWrapper:getUnsealVehicle( stable_getServantType() )
		end
	elseif 2 == unsealType then
		-- servantInfo		= 
	else
		servantInfo		= stable_getServant( StableList_SelectSlotNo() )
	end
	
	for ii=0, (self._config.slot.count-1)	do
		local	slot	= self._skill[ii]
		slot.base:SetShow(false)
		slot.button:SetShow(false)
		slot.buttonDel:SetShow(false)
		slot.buttonLock:SetShow(false)
		slot.buttonTarget:SetShow(false)
		slot.exp:SetShow(false)
		slot.expStr:SetShow(false)
		slot.buttonTraining:SetShow(false)
	end
	
	carrageInfo:close()
	
	if nil == servantInfo then
		return
	end
	
	if	( not servantInfo:doHaveVehicleSkill() )	then
		if ( servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage ) then
			local carriageNo = servantInfo:getServantNo()
			carrageInfo_Check( carriageNo )
		else
			self._staticSkillPanel:SetShow(true)
			self._scrollSkill:SetShow(false)
		end
		return
	end

	-- 업데이트
	local	temporarySlotIndex		= 0
	local	slotNo					= 0
	self._temporayLearnSkillCount	= 0	--배운 스킬 갯수
	self._temporaySlotCount			= servantInfo:getSkillCount()

	local	regionInfo		= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local	regionName		= regionInfo:getAreaName()
	local	servantRegionName = servantInfo:getRegionName()
	
	if servantInfo:getStateType() == CppEnums.ServantStateType.Type_SkillTraining then
		if not stable_isSkillExpTrainingComplete( StableList_SelectSlotNo() ) then
			self._staticTrainingTime:SetShow(true)
			self._staticTrainingTimeValue:SetShow(true)
			self._staticTrainingTimeValue:SetText( convertStringFromDatetime( servantInfo:getSkillTrainingTime() ))
		else
			self._staticTrainingTime:SetShow(false)
			self._staticTrainingTimeValue:SetShow(false)
		end
	end
	
	for	ii=1, (self._temporaySlotCount - 1)	do
		local	skillWrapper= servantInfo:getSkill(ii)
		if	(nil ~=	skillWrapper)	then
			if	slotNo < self._config.slot.count	then
				if	self._startSlotIndex <= temporarySlotIndex	then
					local	slot	= self._skill[slotNo]
					slot.key		= ii
					slot.icon:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
					slot.name:SetText( skillWrapper:getName() )
					slot.dec:SetText( skillWrapper:getDescription() )
					
					-- 스킬 경험치
					slot.exp:SetProgressRate( servantInfo:getSkillExp(ii) / (skillWrapper:getMaxExp() / 100) ) -- 숙련도
					slot.exp:SetAniSpeed(0.0)
					local	expTxt = tonumber(string.format( "%.0f", (servantInfo:getSkillExp(ii) / (skillWrapper:getMaxExp() / 100)) ) )
					if	(100 <= expTxt)	then
						expTxt = 100
					elseif regionName == servantRegionName then
						if isContentsEnable then -- 말 기술 훈련 컨텐츠 옵션 60번.
							if ( servantInfo:isSeized() )
							or ( CppEnums.ServantStateType.Type_RegisterMarket == servantInfo:getStateType() )
							or ( CppEnums.ServantStateType.Type_RegisterMating == servantInfo:getStateType() )
							or ( CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() )
							or ( servantInfo:isMatingComplete() )
							or ( CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() )
							or ( CppEnums.ServantStateType.Type_SkillTraining == servantInfo:getStateType() )
							or ( servantInfo:isLink() ) then
								slot.buttonTraining:SetShow(false)
							else
								slot.buttonTraining:SetShow(false)
								if CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType() then
									slot.buttonTraining:SetShow(true)
								end
							end
						end
					end
					slot.expStr:SetText( expTxt .. "%" )
					slot.exp:SetShow(true)
					slot.expStr:SetShow(true)

					-- 스킬 변경 관련 버튼들.
					if	FGlobal_IsCommercialService()	then
						if	( servantInfo:isSkillLock(ii) )	then
							if servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining then
								slot.buttonLock:SetShow(true)
							end
						else
							if ( servantInfo:isSeized() )
							-- or ( CppEnums.ServantStateType.Type_RegisterMarket == servantInfo:getStateType() )
							-- or ( CppEnums.ServantStateType.Type_RegisterMating == servantInfo:getStateType() )
							-- or ( CppEnums.ServantStateType.Type_Mating == servantInfo:getStateType() )
							-- or ( servantInfo:isMatingComplete() )
							-- or ( CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() )
							or ( CppEnums.ServantStateType.Type_SkillTraining == servantInfo:getStateType() ) then
							-- or ( servantInfo:isLink() ) then
								-- slot.button:SetShow(false)												-- 상태 이상 또는 마차 연결중일 땐 변경 불가
							else
								slot.button:SetShow(false)
								slot.buttonDel:SetShow(false)

								if CppEnums.VehicleType.Type_Horse ==servantInfo:getVehicleType() then
									slot.button:SetShow(true)
									slot.buttonDel:SetShow(true)
								end
								
							end
						end
					end
					
					slot.base:SetShow(true)

					slotNo	 = slotNo + 1
				end
				temporarySlotIndex	 = temporarySlotIndex + 1
			end
			self._temporayLearnSkillCount	= self._temporayLearnSkillCount + 1		-- 스킬 갯수 증가
		end
	end
	
	-- 배울 수 있는 스킬들.
	--{
		for	ii=1, (self._temporaySlotCount - 1)	do
			local	skillWrapper= servantInfo:getSkillXXX(ii)
			if	(nil ~=	skillWrapper)	and servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining then
				if	slotNo < self._config.slot.count	then
					if	self._startSlotIndex <= temporarySlotIndex	then
						local	slot	= self._skill[slotNo]
						slot.key		= ii
						slot.icon:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
						slot.name:SetText( skillWrapper:getName() )
						slot.dec:SetText( skillWrapper:getDescription() )

						slot.buttonTarget:SetShow(false)
						if	FGlobal_IsCommercialService()	then
							if CppEnums.VehicleType.Type_Horse ==servantInfo:getVehicleType() then
								slot.buttonTarget:SetShow(true)
							end
						end
						
						slot.base:SetShow(true)
		
						slotNo	 = slotNo + 1
					end
					temporarySlotIndex	 = temporarySlotIndex + 1
				end
				self._temporayLearnSkillCount	= self._temporayLearnSkillCount + 1		-- 스킬 갯수 증가
			end
		end
	--}
	
	-- 스킬 변경시 희망 스킬 
	self._staticWantSkillBG:SetShow(false)
	self._staticChangeBG:SetShow(false)
	self._staticChangeTitle:SetShow(false)
	self._staticSkillTargetIcon:SetShow(false)
	self._staticSkillTargetName:SetShow(false)
	self._staticSkillTargetCount:SetShow(false)
	self._staticTextChangeDesc:SetShow(false)
	if	( nil ~= self._toSkillKey )	then
		local	skillWrapper= servantInfo:getSkillXXX(self._toSkillKey)
		if	( nil ~=	skillWrapper )	then
			self._staticSkillTargetIcon:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
			self._staticSkillTargetName:SetText( skillWrapper:getName() )
			self._staticSkillTargetCount:SetText( servantInfo:getSkillFailedCount() )
			self._staticWantSkillBG:SetShow(true)
			self._staticChangeBG:SetShow(true)
			self._staticChangeTitle:SetShow(true)
			self._staticSkillTargetIcon:SetShow(true)
			self._staticSkillTargetName:SetShow(true)
			self._staticSkillTargetCount:SetShow(true)
			self._staticTextChangeDesc:SetShow(true)
		end
	end

	-- 스크롤 설정
	if	( 0 < self._temporayLearnSkillCount )	then
		self._staticSkillPanel:SetShow(true)

		UIScroll.SetButtonSize( self._scrollSkill, self._config.slot.count, self._temporayLearnSkillCount )
	end
end

function	stableInfo:registEventHandler()
	self._staticSkillPanel:addInputEvent(		"Mouse_UpScroll",	"StableInfo_ScrollEvent( true )"		)
	self._staticSkillPanel:addInputEvent(		"Mouse_DownScroll",	"StableInfo_ScrollEvent( false )"		)
	self._btnMatingImmediately:addInputEvent(	"Mouse_LUp",		"StableInfo_MatingImmediately_Confirm()")
	UIScroll.InputEvent( self._scrollSkill,							"StableInfo_ScrollEvent"				)
end

function	stableInfo:registMessageHandler()
	registerEvent( "onScreenResize",					"StableInfo_Resize"				)
	registerEvent( "FromClient_ServantChangeSkill",		"ServantChangeSkill_Complete"	)		-- 스킬이 변경 되었을 때, FromClient_ServantChangeSkill( oldSkillKey, newSkillKey )
	registerEvent( "FromClient_ForgetServantSkill",		"FromClient_ForgetServantSkill" )
end

function	StableInfo_Resize()
	-- screenX = getScreenSizeX()
	-- screenY = getScreenSizeY()

	Panel_Window_StableInfo:SetSpanSize( 20, 30 )
	Panel_Window_StableInfo:ComputePos()
end
----------------------------------------------------------------------------------------------------
-- Button Function
function	Button_SkillTarget( slotNo )
	if Panel_Win_System:GetShow() then
		return
	end
	if nil == StableList_SelectSlotNo() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT") )
		return
	end
	local	self		= stableInfo
	local	servantInfo	= stable_getServant( StableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	
	local	skillKey	= self._skill[slotNo].key
	if	( not servantInfo:isLearnSkill(skillKey) )	then
		return
	end
	
	self._toSkillKey	= skillKey
	
	self:updateSkill()
end

local deleteSkillName = nil
function	Button_Skill_Delete( slotNo )
	if Panel_Win_System:GetShow() then
		return
	end
	if nil == StableList_SelectSlotNo() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT") )
		return
	end
	local	self		= stableInfo
	local	servantInfo	= stable_getServant( StableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	local	servantNo	= servantInfo:getServantNo()
	local	skillKey	= self._skill[slotNo].key
	local	skillWrapper	= servantInfo:getSkill( skillKey )
	if	nil ==	skillWrapper	then								--스킬이있으면?
		return
	end

	local deleteServantSkill = function()
		deleteSkillName = skillWrapper:getName()
		stable_forgetServantSkill( StableList_SelectSlotNo(), skillKey )
	end
	
	local	messageBoxTitle	= PAGetString( Defines.StringSheet_GAME, "LUA_SERVANT_SKILLINFO_1" )		-- "말 기술 삭제"
	local	messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_SKILLINFO_2", "skillName", skillWrapper:getName() )			-- "<말 기술 삭제권>을 1장 소모해 <" .. skillWrapper:getName() .. "> 기술을\n삭제합니다. 계속하시겠습니까?"
	local	messageboxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = deleteServantSkill, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
	
end


function	Button_SkillTraining( slotNo )
	if nil == StableList_SelectSlotNo() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT") )
		return
	end
	
	local	servantInfo	= stable_getServant( StableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	
	if Panel_Win_System:GetShow() then
		return
	end
	
	local trainHorse = function()
		local	skillKey	= stableInfo._skill[slotNo].key
		stable_startServantSkillExpTraining( StableList_SelectSlotNo(), skillKey )
	end
	
	local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_SKILLTRAININGTITLE") -- "말 기술 훈련"
	local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_SKILLTRAININGCONTENT") -- "말 훈련장에서 기술 숙련도를 높입니다.\n훈련에는 <말 기술 위탁 훈련권>이 1장 소모됩니다.\n계속하시겠습니까?"
	local	messageboxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = trainHorse, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
	
end

function	Button_SkillChange( slotNo )
	if nil == StableList_SelectSlotNo() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT") )
		return
	end
	local	self		= stableInfo
	local	servantInfo	= stable_getServant( StableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	
	if Panel_Win_System:GetShow() then
		return
	end
	
	local	skillKey		= self._skill[slotNo].key
	local	skillWrapper	= servantInfo:getSkill( skillKey )
	if	nil ==	skillWrapper	then								--스킬이있으면?
		return
	end
	
	if	nil == self._toSkillKey	then
		local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
		local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_CHANGESKILL_BTN")
  		local	messageboxData = { title = messageBoxTitle, content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
  		MessageBox.showMessageBox(messageboxData)

  		return
	end
	
	self._fromSkillKey	= skillKey

	-- 확인창 시작	
	local	titleString       = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
	local	contentString     = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SKILLCHANGE_MSG", "skillname", skillWrapper:getName() )
	local	messageboxData    = { title = titleString, content = contentString, functionYes = Button_SkillChangeXXX, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function Button_SkillChangeXXX()
	audioPostEvent_SystemUi(03,19)

	local	self		= stableInfo
	stable_changeSkill( StableList_SelectSlotNo(), self._fromSkillKey, self._toSkillKey )
end

function	StableInfo_ScrollEvent( isScrollUp )
	local	self		= stableInfo
	self._startSlotIndex= UIScroll.ScrollEvent( self._scrollSkill, isScrollUp, self._config.slot.count, self._temporayLearnSkillCount, self._startSlotIndex, 1 )
	if nil ~= self.currentServantType then
		self:update( self.currentServantType )
	else
		self:update()
	end
end

----------------------------------------------------------------------------------------------------
-- MatingImmediately
function	StableInfo_MatingImmediately_Confirm()
	local	self		= stableInfo
	
	local	servantInfo	= stable_getServant( StableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	
	-- 확인창 시작	
	local	titleString       = PAGetString(Defines.StringSheet_GAME, "LUA_IMMDEDIATELY_MSGBOX_TITLE") -- "즉시 완료"
	local	contentString     = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_IMMDEDIATELY_MSGBOX_SERVANT_MEMO", "pearl", tostring( servantInfo:getCompleteMatingFromPearl_s64() ) ) -- tostring( servantInfo:getCompleteMatingFromPearl_s64() ) .. "펄이 소모됩니다"
	local	messageboxData    = { title = titleString, content = contentString, functionYes = StableInfo_MatingImmediatelyYes, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function	StableInfo_MatingImmediatelyYes()
	local	self		= stableInfo
	local	servantInfo	= stable_getServant( StableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	stable_requestCompleteServantMating( StableList_SelectSlotNo(), servantInfo:getCompleteMatingFromPearl_s64() )
end

-- From Client Call Function
function	ServantChangeSkill_Complete( oldSkillKey, newSkillKey )
	local	self				= stableInfo
	local	temporaryWrapper	= getTemporaryInformationWrapper()
	local	servantInfo			= stable_getServant( StableList_SelectSlotNo() )
	local	skillWrapper		= servantInfo:getSkill(newSkillKey)
	local	oldSkillWrapper		= servantInfo:getSkillXXX(oldSkillKey)
	if nil ~= servantInfo then
		if nil ~= skillWrapper and nil~= oldSkillWrapper then
			local msg = { main = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_STABLE_CHANGESKILL_MSG_MAIN_CHANGESKILL", "oldSkill", oldSkillWrapper:getName(), "newSkill", skillWrapper:getName() ), sub = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_CHANGESKILL_MSG_SUB_CONGRATULATION") }
			Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6, 32)
		end
	end
	Panel_StableInfo_EffectFunc()
		
	self:update()
end

function	Panel_StableInfo_EffectFunc()
	local	self	= stableInfo
	self._staticSkillEffect:EraseAllEffect()
	self._staticSkillEffect:AddEffect("UI_Horse_SkillChangeEffect01",false,195,-172)
end

function	FromClient_ForgetServantSkill( servantNo, skillKey )
	-- local servantInfo = stable_getServantByServantNo( servantNo )
	-- if nil == servantInfo then
		-- return
	-- end
	
	-- local	skillWrapper	= servantInfo:getSkill( skillKey )
	-- if	nil ==	skillWrapper	then								--스킬이있으면?
		-- return
	-- end
	
	local msg
	if nil ~= deleteSkillName then
		msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_SKILLINFO_3", "deleteSkillName", deleteSkillName )		-- "<" .. deleteSkillName .. "> 기술이 정상적으로 삭제되었습니다."
	else
		msg = PAGetString( Defines.StringSheet_GAME, "LUA_SERVANT_SKILLINFO_4" ) 		-- "말 기술이 정상적으로 삭제되었습니다."
	end
	Proc_ShowMessage_Ack_WithOut_ChattingMessage( msg )
	deleteSkillName = nil
	
	local	self		= stableInfo
	if nil ~= self.currentServantType then
		self:update( self.currentServantType )
	else
		self:update()
	end
end

----------------------------------------------------------------------------------------------------
-- Window Open / Close
function StableInfo_Open( unsealType )	
	if	not ( Panel_Window_StableInfo:GetShow() )	then
		Panel_Window_StableInfo:SetShow(true)	
	end
	if nil == unsealType then
		unsealType = 0
	end
	self	= stableInfo
	self:clear()
	self._scrollSkill:SetControlPos( 0 )	-- 맨 위로 올림!
	self:update( unsealType )

end

function	StableInfo_Close()
	if	( not Panel_Window_StableInfo:GetShow() )	then
		-- return
	end
	
	Panel_Window_StableInfo:SetShow(false)
end
----------------------------------------------------------------------------------------------------
-- Init
stableInfo:init()
stableInfo:registEventHandler()
stableInfo:registMessageHandler()
StableInfo_Resize()
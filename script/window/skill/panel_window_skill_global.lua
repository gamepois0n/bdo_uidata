local UI_TM 		= CppEnums.TextMode

PaGlobal_Skill = {
	slotConfig =
	{
		-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon 			= true,
		createEffect 		= true,
		createFG 			= true,
		createFGDisabled 	= true,
		createFG_Passive 	= true,
		createMinus 		= true,
		createLevel 		= true,
		createLearnButton 	= true,
		createTestimonial 	= true,

		-- 스킬 아이콘 Template
		template =
		{
			effect 			= UI.getChildControl( Panel_Window_Skill, "Static_Icon_Skill_Effect" ),
			iconFG 			= UI.getChildControl( Panel_Window_Skill, "Static_Icon_FG" ),
			iconFGDisabled 	= UI.getChildControl( Panel_Window_Skill, "Static_Icon_FG_DISABLE" ),
			iconFG_Passive 	= UI.getChildControl( Panel_Window_Skill, "Static_Icon_BG" ),
			iconMinus		= UI.getChildControl( Panel_Window_Skill, "Static_Icon_Skill_EffectMinus" ),
			learnButton 	= UI.getChildControl( Panel_Window_Skill, "Button_Skill_Point" ),
			testimonial		= UI.getChildControl( Panel_Window_Skill, "Static_Skill_Effect" ),
		}
	},
	config =
	{
		slotStartX 	= 6,
		slotStartY 	= 6,
		slotGapX 	= 42,
		slotGapY 	= 42,
		emptyGapX 	= 22,
		emptyGapY 	= 18
	},
	-- 컨트롤들
	slots =
	{
		[0] = {},	-- combat!
			  {}	-- awaken
	},

	staticBottomBox,
	learnableSlotShowMaxCount 	= 8,
	learnableSlots 				= {},
	learnableSlotCount 			= 0,
	learnableSlotsSortList 		= {},
	learnableSlotsSortListCount = 0,
	skillNoSlot 				= {},

	-- tab Index
	combatTabIndex = 0,
	awakenTabIndex = 1,
	
	-- Cache Data!!!
	lastTabIndex 		= 0,		-- 0 == Combat
	lastLearnMode 		= false,
	controlInitialize 	= false,

	-- 상단
	radioButtons =
	{
		[0] = 	UI.getChildControl( Panel_Window_Skill, "RadioButton_Tab_Combat" ),
				UI.getChildControl( Panel_Window_Skill, "RadioButton_Tab_Product" )
	},
	-- 우측 상단
	staticRemainPoint 	= UI.getChildControl( Panel_Window_Skill, "Static_Text_RemainSkillPoint" ),
	buttonClose 		= UI.getChildControl( Panel_Window_Skill, "Button_Close" ),
	_buttonQuestion 	= UI.getChildControl( Panel_Window_Skill, "Button_Question" ),		-- 물음표 버튼
	-- 하단
	staticSkillLevel 	= UI.getChildControl( Panel_Window_Skill, "Static_Text_Skill_Level" ),
	textSkillPoint 		= UI.getChildControl( Panel_Window_Skill, "Static_Text_SkillPoint" ),
	progressSkillExp 	= UI.getChildControl( Panel_Window_Skill, "Progress2_SkillExpGage" ),
	-- 중앙
	frames =
	{
		[0] = 	UI.getChildControl( Panel_Window_Skill, "Frame_Combat" ),
				UI.getChildControl( Panel_Window_Skill, "Frame_Awaken" )
	},

	-- GuideLine Template
	template_guideLine =
	{
		-- 수평으로 넓은 것
		h =
		{
			[3]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_LT" ),
			[4]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_CT" ),
			[5]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_RT" ),
                 
			[6]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_LM" ),
			[7]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_CM" ),
			[8]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_RM" ),

			[9]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_LB" ),
			[10] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_CB" ),
			[11] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_RB" ),

			[12] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_HORI" ),
			[13] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_VERTI" )
		},
		-- 수직으로 긴 것
		v =
		{
			[3]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_LT" ),
			[4]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_CT" ),
			[5]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_RT" ),
                 
			[6]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_LM" ),
			[7]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_CM" ),
			[8]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_RM" ),
                 
			[9]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_LB" ),
			[10] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_CB" ),
			[11] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_RB" ),

			[12] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_HORI" ),
			[13] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_VERTI" )
		},
		-- 큰것
		l =
		{
			[3]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_LT" ),
			[4]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_CT" ),
			[5]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_RT" ),
                 
			[6]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_LM" ),
			[7]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_CM" ),
			[8]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_RM" ),
                 
			[9]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_LB" ),
			[10] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_CB" ),
			[11] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_RB" ),

			[12] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_HORI" ),
			[13] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_VERTI" )
		},
		-- 작은 것
		s =
		{
			[3]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_LT" ),
			[4]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_CT" ),
			[5]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_RT" ),
                 
			[6]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_LM" ),
			[7]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_CM" ),
			[8]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_RM" ),
                 
			[9]  = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_LB" ),
			[10] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_CB" ),
			[11] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_RB" ),

			[12] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_HORI" ),
			[13] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_VERTI" )
		}
	},
	
	_btn_MovieToolTip 			= UI.getChildControl( Panel_Window_Skill, "Button_MovieTooltip" ),
	_btn_MovieToolTip2 			= UI.getChildControl( Panel_Window_Skill, "Button_MovieTooltip_SpacialCombo" ),
	learnedSkillList			= Array.new(), -- 배운 스킬목록 : 처음 스킬창 켰을때 이펙트띄워주기 용도임.
	isPartsSkillReset			= false,
	saved_isLearnMode			= true,
	scrollPos					= 0,
	skillNoCache 				= 0,
	slotTypeCache 				= 0,
	tooltipcacheCount 			= 0,
}

function PaGlobal_Skill:initialize()
	Panel_Window_Skill:setMaskingChild( true )
	Panel_Window_Skill:ActiveMouseEventEffect( true )
	Panel_Window_Skill:setGlassBackground( true )
	
	self:initControl()
	self:initSkillLearnableSlot()
end

function PaGlobal_Skill:initControl()
	for _,control in pairs(self.slotConfig.template) do
		control:SetShow( false )
	end	
		
	local _frame_Combat 		= UI.getChildControl ( Panel_Window_Skill, "Frame_Combat" )
	local _frame_scroll_Combat 	= UI.getChildControl ( _frame_Combat, "Frame_1_Scroll" )
	local _txt_ResourceSaveDesc	= UI.getChildControl ( Panel_Window_Skill, "StaticText_ResourceSaveDesc" )

	_txt_ResourceSaveDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	_txt_ResourceSaveDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_RESOURCESAVEDESC") )
	
	-- 새로운 스킬이 있을 때 녀석들
	local _btn_NewSkill 			= UI.getChildControl( Panel_Window_Skill, "Button_NewSkill" )
	local _btn_MovieToolTipBG 		= UI.getChildControl( Panel_Window_Skill, "Static_MovieBG" )
	local _btn_MovieToolTipDesc		= UI.getChildControl( Panel_Window_Skill, "StaticText_MovieToolTip" )
	
	self._btn_MovieToolTip2:SetMonoTone( true )
	
	--{ 서비스 할 나라 구분(일본 지역에서만 안보여줌.)
	local countryType = true
	if (isGameTypeJapan()) then
		_btn_MovieToolTipDesc	:SetHorizonLeft()
		_btn_MovieToolTipDesc	:SetSpanSize(self._btn_MovieToolTip:GetPosX() + 35, 49)
	end
	if ((isGameTypeJapan() or isGameTypeEnglish()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT ) then
		self._btn_MovieToolTip		:SetShow( false )
		 _btn_MovieToolTipBG		:SetShow( false )
		_btn_MovieToolTipDesc		:SetShow( false )
	else
		self._btn_MovieToolTip		:SetShow( true )
		_btn_MovieToolTipBG			:SetShow( true )
		_btn_MovieToolTipDesc		:SetShow( true )
	end
	--}
end

function PaGlobal_Skill:initTabControl( cellTable, parent, container )
	local cols = cellTable:capacityX()
	local rows = cellTable:capacityY()

	local startY = self.config.slotStartY
	for row = 0, rows - 1 do
		local startX = self.config.slotStartX
		local isSlotRow = (0 == (row % 2))
		if ( isSlotRow ) then
			startY = startY + self.config.emptyGapY
		else
			startY = startY + self.config.slotGapY
		end

		for col = 0, cols - 1 do
			-- UI.debugMessage( 'Row : ' .. row .. ' / Col : ' .. col )
			local cell = cellTable:atPointer( col, row )
			local skillNo = cell._skillNo

			local isSlotColumn = (0 == (col % 2))
			
			if ( isSlotColumn ) then
				startX = startX + self.config.emptyGapX
			else
				startX = startX + self.config.slotGapX
			end

			if cell:isSkillType() then
				-- create skill Slot
				-- UI.debugMessage( 'Cell Skill Type' )
				local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
				-- UI.debugMessage( 'Cell get SkillTypeSS Wrapper' )
				
				if( nil ~= skillTypeStaticWrapper  ) then
					if skillTypeStaticWrapper:isValidLocalizing() then
						-- Active 스킬일때만 사용하는 컨트롤!
						local skillTypeStatic = skillTypeStaticWrapper:get()
						-- UI.debugMessage( 'Cell get SkillTypeSS' )
						self.slotConfig.createFG = skillTypeStatic:isActiveSkill() and skillTypeStatic._isSettableQuickSlot
						self.slotConfig.createFGDisabled = self.slotConfig.createFG
						self.slotConfig.createFG_Passive = not self.slotConfig.createFG
						
						--self.slotConfig.createTestimonial = skillTypeStatic:isTestimonialSkill()

						local slot = {}
						-- UI.debugMessage( 'Skill Slot create' )
						SlotSkill.new( slot, skillNo, parent, self.slotConfig )
						slot:setPos( startX, startY )

						-- set Event Handler
						if nil ~= slot.learnButton then
							slot.learnButton:SetIgnore( true )
						end
												
						if ( nil ~= slot.icon ) then
							slot.icon:addInputEvent( "Mouse_LUp", 	"HandleMLUp_SkillWindow_LearnButtonClick("..skillNo..")" )
							slot.icon:addInputEvent( "Mouse_On", 	"HandleMOver_SkillWindow_ToolTipShow(" .. skillNo .. ",false, \"SkillBox\")" )
							slot.icon:addInputEvent( "Mouse_Out", 	"HandleMOver_SkillWindow_ToolTipHide(" .. skillNo .. ",\"SkillBox\")" )
							Panel_SkillTooltip_SetPosition( skillNo, slot.icon, "SkillBox" )
						end

						-- Set Skill Data
						-- UI.debugMessage( 'Skill Slot setPos' )
						slot:setSkillTypeStatic( skillTypeStaticWrapper )

						-- UI.debugMessage( 'Skill Slot add to Container' )
						container[ skillNo ] = slot
					end
				else
					_PA_ASSERT("스킬트리", "skillTypeStaticStatus 매니져에 없는 스킬이 있습니다." );
				end
				
				
			elseif cell:isLineType() then
				-- UI.debugMessage( 'Cell Line Type' )
				local template = self:getLineTemplate( isSlotColumn, isSlotRow, cell._cellType )
				if nil ~= template then
					local line = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, parent, 'Static_Line_' .. col .. '_' .. row )
					CopyBaseProperty( template, line )
					line:SetPosX( startX )
					line:SetPosY( startY )
					line:SetIgnore( true )
					line:SetShow( true )
				end
			end
		end
	end
end

-- 전투 스킬 Tab
function PaGlobal_Skill:initTabControl_Combat()
	local targetFrame = self.frames[self.combatTabIndex]
	self.slots[self.combatTabIndex] = {}
	local classType = getSelfPlayer():getClassType()
	if 0 <= classType then
		local cellTable = getCombatSkillTree( classType )
		self:initTabControl( cellTable, targetFrame:GetFrameContent(), self.slots[self.combatTabIndex] )
	end
	targetFrame:UpdateContentScroll()
end

-- 각성무기 스킬 Tab
function PaGlobal_Skill:initTabControl_AwakeningWeapon()
	local targetFrame = self.frames[self.awakenTabIndex]
	self.slots[self.awakenTabIndex] = {}

	local classType = getSelfPlayer():getClassType()
	if 0 <= classType then
		local cellTable = getAwakeningWeaponSkillTree( classType )
		self:initTabControl( cellTable, targetFrame:GetFrameContent(), self.slots[self.awakenTabIndex] )
	end
	targetFrame:UpdateContentScroll()
end

function PaGlobal_Skill:initSkillLearnableSlot()

	self.staticBottomBox = UI.getChildControl( Panel_Window_Skill, "Static_BottomBox" )
			
	for index=0, self.learnableSlotShowMaxCount-1 do

		local slot = {}
		SlotSkill.new( slot, "Learnable_"..index, self.staticBottomBox, self.slotConfig )
		
		if ( nil ~= slot.learnButton ) then
			slot.learnButton:SetIgnore( true )
		end
			
		if ( nil ~= slot.icon ) then
			slot:clearSkill()
		end			
					
		self.learnableSlots[index] = slot
	end
end

function PaGlobal_Skill:getLineTemplate( isSlotColumn, isSlotRow, lineType )
	local lineDef = nil
	-- Line Type 정하기
	if isSlotColumn and isSlotRow then
		lineDef = self.template_guideLine.l
	elseif not isSlotColumn and isSlotRow then
		lineDef = self.template_guideLine.v
	elseif isSlotColumn and not isSlotRow then
		lineDef = self.template_guideLine.h
	else
		lineDef = self.template_guideLine.s
	end

	return lineDef[lineType]
end

function PaGlobal_Skill:Skill_ScrollMove(moveDirection)
	if ("up" == moveDirection) then
		self.frames[0]:GetVScroll():SetCtrlPosByInterval(-1)
	elseif ("down" == moveDirection) then
		self.frames[0]:GetVScroll():SetCtrlPosByInterval(1)
	end
	self.frames[0]:UpdateContentPos()
	HandleMScroll_SkillWindow_ScrollEvent(true)
end

function PaGlobal_Skill:SkillCalcPosYByRow( row )
	if ( 0 == row % 2 ) then
		return ( row / 2 ) * ( self.config.slotGapY + self.config.emptyGapY ) + self.config.emptyGapY + self.config.slotStartY
	else
		return ( ( row +1 ) / 2 ) * ( self.config.slotGapY + self.config.emptyGapY ) + self.config.slotStartY
	end
end

function PaGlobal_Skill:SkillCalcPosYByColumn( col )
	if ( 0 == col % 2 ) then
		return ( col / 2 ) * ( self.config.slotGapX + self.config.emptyGapX ) + self.config.emptyGapX + self.config.slotStartX
	else
		return ( ( col +1 ) / 2 ) * ( self.config.slotGapX + self.config.emptyGapX ) + self.config.slotStartX
	end
end

function PaGlobal_Skill:Skill_WindowPosSet( pos )
	local vScroll = PaGlobal_Skill.frames[0]:GetVScroll()
	local contentUseSize = ( PaGlobal_Skill.frames[0]:GetFrameContent():GetSizeY() - PaGlobal_Skill.frames[0]:GetSizeY() )
	local posPercents = ( pos - PaGlobal_Skill.frames[0]:GetSizeY() / 2 ) / contentUseSize
	vScroll:SetControlPos( math.max( math.min(posPercents,1), 0) )

	PaGlobal_Skill.frames[0]:UpdateContentPos()
end

function PaGlobal_Skill:SkillWindowEffect( row, col, skillNo )
	local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	if skillTypeStaticWrapper:isValidLocalizing() then	-- 컨텐츠 타입에서 열려야 처리한다.
		local posX, posY = self:SkillCalcPosYByColumn(col), self:SkillCalcPosYByRow(row)
		self:Skill_WindowPosSet( posY )
		
		self.slots[self.combatTabIndex][skillNo].learnButton:EraseAllEffect()
		self.slots[self.combatTabIndex][skillNo].learnButton:AddEffect( "UI_LimitMetastasis_Box02", false, 0, 0 )
		self.slots[self.combatTabIndex][skillNo].learnButton:AddEffect( "UI_LimitMetastasis_Box01", false, 0, 0 )
		self.slots[self.combatTabIndex][skillNo].learnButton:AddEffect( "UI_Inventory_EmptySlot", false, 0, 0 )
	end
end

function PaGlobal_Skill:SkillWindow_UpdateClearData()
	self.isPartsSkillReset = true
	local isNewSkillBtn = self.radioButtons[self.awakenTabIndex]:IsCheck()
	local isOldSkillBtn = self.radioButtons[self.combatTabIndex]:IsCheck()
	local slots = nil
	if isNewSkillBtn then
		slots = self.slots[self.awakenTabIndex]
	else
		slots = self.slots[self.combatTabIndex]
	end

	if nil == slots then
		return
	end
	
	for skillNo,slot in pairs(slots) do
		slot:clearSkill()										-- clearSkill을하면 해당 아이콘의 Alpha값을 0으로 만든다.
		slot.icon:SetAlpha(1)
		slot.skillNo = skillNo

		local isFGDisable = true
		if nil ~= slot.iconFGDisabled then
			slot.iconFGDisabled:SetShow(true)
		end
		
		if nil ~= slot.iconFG_Passive then
			isFGDisable = false
			slot.iconFG_Passive:SetShow(true)
		end
		
		local skillLevelInfo = getSkillLevelInfo( skillNo )
		if nil == skillLevelInfo then
			return
		end
		
		if skillLevelInfo._usable then
			local skillStaticWrapper = getSkillStaticStatus( skillNo, 1 )
			if nil == skillStaticWrapper then
				return
			end
			
			if (not skillStaticWrapper:isAutoLearnSkillByLevel()) and (not skillStaticWrapper:isLearnSkillByItem()) and (skillStaticWrapper:isLastSkill()) then
				slot.iconMinus:SetShow(true)
				slot.icon:addInputEvent("Mouse_LUp", "HandleMLUp_SkillWindow_ClearButtonClick(".. skillNo ..")")
				
				if isFGDisable then
					slot.iconFGDisabled:SetShow(false)
				else
					slot.iconFG_Passive:SetShow(false)
				end
			end
		end	
	end
	
	-- 스킬 포인트 갱신
	local skillPointInfo = getSkillPointInfo( self.combatTabIndex )
	if nil ~= skillPointInfo then
		self.staticRemainPoint:SetText( tostring(skillPointInfo._remainPoint))
	end	
end

function PaGlobal_Skill:SkillWindow_PlayerLearnableSkill()
	-- 하나라도 배울 것이 있다면 true 리턴
	local slots = self.slots[self.combatTabIndex]
	for skillNo,slot in pairs(slots) do
		local skillLevelInfo = getSkillLevelInfo( skillNo )
		if( nil ~= skillLevelInfo ) then
			if( skillLevelInfo._learnable ) and ( false == skillLevelInfo._isLearnByQuest ) then
				return true
			end	
		else
			return false
		end
	end

	return false
end

function PaGlobal_Skill:SkillWindow_LearnButtonClick( skillNo )
	if ( false == self.saved_isLearnMode ) then
		return
	end
	local skillLevelInfo = getSkillLevelInfo( skillNo )
	if ( nil == skillLevelInfo ) then
		return
	end
	if ( false == skillLevelInfo._learnable ) then
		return
	end
	
	local isSuccess = skillWindow_DoLearn( skillNo )
	audioPostEvent_SystemUi(00,00)
	
	if ( isSuccess ) then
		-- ♬ 스킬 배웠을 때 소리 들어가야함
		audioPostEvent_SystemUi(04,02)
		
		self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
		self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
		self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill_Loop01", true, 0, 0)
		self.learnedSkillList:push_back(skillNo)
	end
	
	if ( nil == self.skillNoSlot[skillNo].icon ) then
		return
	end
	
	UI_MAIN_checkSkillLearnable()

	if ( isSkillLearnTutorialClick_check() ) then	-- 튜토리얼 중 눌렀다면. 꺼준다.
		HandleMLUp_SkillWindow_Close()
	end
end

function PaGlobal_Skill:UpdateLearnableSlots()
	self:ClearLearnableSlots()
end

function PaGlobal_Skill:ClearLearnableSlots()
	for index, skillSlot in pairs( self.learnableSlots ) do
		skillSlot.icon:SetShow(false);
		skillSlot:clearSkill();
	end

	self.learnableSlotCount = 0
end

function PaGlobal_Skill:SkillWindow_Show()
	HandleMLUp_SkillWindow_OpenForLearn() -- 테스트용

	local vScroll = self.frames[0]:GetVScroll()
	vScroll:SetControlPos(self.scrollPos)
	self.frames[0]:UpdateContentPos()
	HandleMLUp_SkillWindow_UpdateData()
	
	--이펙트뿌려주고 다시 켜면 안보이게 어레이 정리
	for index = 1, #self.learnedSkillList do
		local skillNo = self.learnedSkillList[index]
		self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
		self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
		self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill_Loop01", true, 0, 0)
	end
	self.learnedSkillList = Array.new()
	
	local classType = getSelfPlayer():getClassType()
	if PaGlobal_AwakenSkill.isAwakenWeaponContentsOpen then
		self.radioButtons[self.awakenTabIndex]:SetMonoTone( false )
		self.radioButtons[self.awakenTabIndex]:SetEnable( true )
	else
		self.radioButtons[self.awakenTabIndex]:SetMonoTone( true )
		self.radioButtons[self.awakenTabIndex]:SetEnable( false )
	end
end
runLua("UI_Data/Script/Window/Skill/Panel_Window_Skill_Global.lua")
runLua("UI_Data/Script/Window/Skill/Panel_Window_Skill_Awaken.lua")
runLua("UI_Data/Script/Window/Skill/Panel_Window_Skill_Animation.lua")
runLua("UI_Data/Script/Window/Skill/Panel_Window_Skill_Event.lua")

-- local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
-- local UI_color		= Defines.Color
-- local IM			= CppEnums.EProcessorInputMode
-- local UI_TM 		= CppEnums.TextMode
-- local CT			= CppEnums.ClassType

-- Panel_Window_Skill:setMaskingChild( true )
-- Panel_Window_Skill:ActiveMouseEventEffect( true )
-- Panel_Window_Skill:setGlassBackground( true )
-- Panel_Window_Skill:RegisterShowEventFunc( true, 'SkillShowAni()' )
-- Panel_Window_Skill:RegisterShowEventFunc( false, 'SkillHideAni()' )

-- --{ 각성 무기 열림 체크
-- local awakenWeapon = 
-- {
	-- [CT.ClassType_Warrior]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 901 ),		-- 워리어
	-- [CT.ClassType_Ranger]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 902 ),		-- 레인저
	-- [CT.ClassType_Sorcerer]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 903 ),		-- 소서러
	-- [CT.ClassType_Giant]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 904 ),		-- 자이언트
	-- [CT.ClassType_Tamer]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 905 ),		-- 금수랑
	-- [CT.ClassType_BladeMaster]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 906 ),		-- 무사
	-- [CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 907 ),	-- 매화
	-- [CT.ClassType_Valkyrie]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 908 ),		-- 발키리
	-- [CT.ClassType_Wizard]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 909 ),		-- 위자드
	-- [CT.ClassType_WizardWomen]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 910 ),		-- 위치
	-- [CT.ClassType_NinjaMan]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 911 ),		-- 닌자
	-- [CT.ClassType_NinjaWomen]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 912 ),		-- 쿠노이치
-- }
-- local classType = getSelfPlayer():getClassType()
-- local awakenWeaponContentsOpen = awakenWeapon[classType]			-- 해당 직업의 각성 무기가 열려 있나 체크
-- --}

-- -- 새로운 스킬이 있을 때 녀석들
-- local _btn_NewSkill 			= UI.getChildControl( Panel_Window_Skill, "Button_NewSkill" )
-- local _btn_MovieToolTip 		= UI.getChildControl( Panel_Window_Skill, "Button_MovieTooltip" )
-- local _btn_MovieToolTipBG 		= UI.getChildControl( Panel_Window_Skill, "Static_MovieBG" )
-- local _btn_MovieToolTipDesc		= UI.getChildControl( Panel_Window_Skill, "StaticText_MovieToolTip" )
-- local _btn_MovieToolTip2 		= UI.getChildControl( Panel_Window_Skill, "Button_MovieTooltip_SpacialCombo" )
-- _btn_MovieToolTip2:SetMonoTone( true )
-- _btn_MovieToolTip:addInputEvent( "Mouse_LUp", "Panel_Window_SkillGuide_ShowToggle()" )
-- _btn_MovieToolTip2:addInputEvent( "Mouse_LUp", "Panel_Window_SkillGuide_ShowToggle()" )

-- local scrollPos = 0
-- local isPartsSkillReset = false

-- --{ 서비스 할 나라 구분(일본 지역에서만 안보여줌.)
-- local countryType = true
-- if (isGameTypeJapan()) then
	-- _btn_MovieToolTipDesc	:SetHorizonLeft()
	-- _btn_MovieToolTipDesc	:SetSpanSize(_btn_MovieToolTip:GetPosX() + 35, 49)
-- end
-- if ((isGameTypeJapan() or isGameTypeEnglish()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT ) then
-- -- if getGameServiceType() == 5 or getGameServiceType() == 6 then
	-- _btn_MovieToolTip		:SetShow( false )
	-- _btn_MovieToolTipBG		:SetShow( false )
	-- _btn_MovieToolTipDesc	:SetShow( false )
-- else
	-- _btn_MovieToolTip		:SetShow( true )
	-- _btn_MovieToolTipBG		:SetShow( true )
	-- _btn_MovieToolTipDesc	:SetShow( true )
-- end
-- --}

-- local skill = {
	-- slotConfig =
	-- {
		-- -- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		-- createIcon = true,
		-- createEffect = true,
		-- createFG = true,
		-- createFGDisabled = true,
		-- createFG_Passive = true,
		-- createMinus = true,
		-- createLevel = true,
		-- createLearnButton = true,
		-- createTestimonial = true,
		-- -- createReservationButton = true,

		-- -- 스킬 아이콘 Template
		-- template =
		-- {
			-- effect 			= UI.getChildControl( Panel_Window_Skill, "Static_Icon_Skill_Effect" ),
			-- iconFG 			= UI.getChildControl( Panel_Window_Skill, "Static_Icon_FG" ),
			-- iconFGDisabled 	= UI.getChildControl( Panel_Window_Skill, "Static_Icon_FG_DISABLE" ),
			-- iconFG_Passive 	= UI.getChildControl( Panel_Window_Skill, "Static_Icon_BG" ),
			-- iconMinus		= UI.getChildControl( Panel_Window_Skill, "Static_Icon_Skill_EffectMinus" ),
			-- learnButton 	= UI.getChildControl( Panel_Window_Skill, "Button_Skill_Point" ),
			-- testimonial		= UI.getChildControl( Panel_Window_Skill, "Static_Skill_Effect" ),
			-- -- reservationButton 	= UI.getChildControl( Panel_Window_Skill, "Button_Reservation" ),
			-- -- reserve_Helper 	= UI.getChildControl( Panel_Window_Skill, "StaticText_ReserveHelper" ),
		-- }
	-- },
	-- config =
	-- {
		-- slotStartX = 6,
		-- slotStartY = 6,
		-- slotGapX = 42,
		-- slotGapY = 42,
		-- emptyGapX = 22,
		-- emptyGapY = 18
	-- },
	-- -- 컨트롤들
	-- slots =
	-- {
		-- [0] = {},	-- combat!
		-- {},			-- item
		-- {},			-- product
		-- {}			-- guild
	-- },

	-- staticBottomBox,
	-- learnableSlotShowMaxCount = 8,
	-- learnableSlots = {},
	-- learnableSlotCount = 0,
	-- learnableSlotsSortList = {},
	-- learnableSlotsSortListCount = 0,
	
	-- skillNoSlot = {},

	-- -- tab Index
	-- combatTabIndex = 0,
	-- itemTabIndex = 1,
	-- productTabIndex = 2,
	-- guildTabIndex = 3,

	-- -- Cache Data!!!
	-- lastTabIndex = 0,		-- 0 == Combat
	-- lastLearnMode = false,
	-- controlInitialize = false,

	-- -- 상단
	-- radioButtons =
	-- {
		-- [0] = 	UI.getChildControl( Panel_Window_Skill, "RadioButton_Tab_Combat" ),
				-- UI.getChildControl( Panel_Window_Skill, "RadioButton_Tab_Item" ),
				-- UI.getChildControl( Panel_Window_Skill, "RadioButton_Tab_Product" ),
				-- UI.getChildControl( Panel_Window_Skill, "RadioButton_Tab_Guild" )
	-- },
	-- -- 우측 상단
	-- staticRemainPoint 	= UI.getChildControl( Panel_Window_Skill, "Static_Text_RemainSkillPoint" ),
	-- buttonClose 		= UI.getChildControl( Panel_Window_Skill, "Button_Close" ),
	-- _buttonQuestion = UI.getChildControl( Panel_Window_Skill, "Button_Question" ),		-- 물음표 버튼
	-- -- 하단
	-- staticSkillLevel 	= UI.getChildControl( Panel_Window_Skill, "Static_Text_Skill_Level" ),
	-- textSkillPoint 		= UI.getChildControl( Panel_Window_Skill, "Static_Text_SkillPoint" ),
	-- progressSkillExp 	= UI.getChildControl( Panel_Window_Skill, "Progress2_SkillExpGage" ),
	-- -- 중앙
	-- frames =
	-- {
		-- [0] = UI.getChildControl( Panel_Window_Skill, "Frame_Combat" ),
		-- UI.getChildControl( Panel_Window_Skill, "Frame_Item" ),
		-- UI.getChildControl( Panel_Window_Skill, "Frame_Product" ),
		-- UI.getChildControl( Panel_Window_Skill, "Frame_Guild" )
	-- },

	-- -- GuideLine Template
	-- template_guideLine =
	-- {
		-- -- 수평으로 넓은 것
		-- h =
		-- {
			-- [3] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_LT" ),
			-- [4] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_CT" ),
			-- [5] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_RT" ),

			-- [6] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_LM" ),
			-- [7] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_CM" ),
			-- [8] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_RM" ),

			-- [9] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_LB" ),
			-- [10] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_CB" ),
			-- [11] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_RB" ),

			-- [12] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_HORI" ),
			-- [13] = UI.getChildControl( Panel_Window_Skill, "Static_TypeH_VERTI" )
		-- },
		-- -- 수직으로 긴 것
		-- v =
		-- {
			-- [3] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_LT" ),
			-- [4] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_CT" ),
			-- [5] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_RT" ),

			-- [6] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_LM" ),
			-- [7] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_CM" ),
			-- [8] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_RM" ),

			-- [9] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_LB" ),
			-- [10] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_CB" ),
			-- [11] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_RB" ),

			-- [12] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_HORI" ),
			-- [13] = UI.getChildControl( Panel_Window_Skill, "Static_TypeV_VERTI" )
		-- },
		-- -- 큰것
		-- l =
		-- {
			-- [3] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_LT" ),
			-- [4] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_CT" ),
			-- [5] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_RT" ),

			-- [6] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_LM" ),
			-- [7] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_CM" ),
			-- [8] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_RM" ),

			-- [9] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_LB" ),
			-- [10] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_CB" ),
			-- [11] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_RB" ),

			-- [12] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_HORI" ),
			-- [13] = UI.getChildControl( Panel_Window_Skill, "Static_TypeL_VERTI" )
		-- },
		-- -- 작은 것
		-- s =
		-- {
			-- [3] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_LT" ),
			-- [4] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_CT" ),
			-- [5] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_RT" ),

			-- [6] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_LM" ),
			-- [7] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_CM" ),
			-- [8] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_RM" ),

			-- [9] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_LB" ),
			-- [10] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_CB" ),
			-- [11] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_RB" ),

			-- [12] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_HORI" ),
			-- [13] = UI.getChildControl( Panel_Window_Skill, "Static_TypeS_VERTI" )
		-- }
	-- },
	-- template_arrow_to_left 	= UI.getChildControl( Panel_Window_Skill, "Static_Arrow_HORI_LEFT" ),
	-- template_arrow_to_right = UI.getChildControl( Panel_Window_Skill, "Static_Arrow_HORI_RIGHT" ),
	-- template_arrow_to_top 	= UI.getChildControl( Panel_Window_Skill, "Static_Arrow_VERTI_TOP" ),
	-- template_arrow_to_bottom = UI.getChildControl( Panel_Window_Skill, "Static_Arrow_VERTI_BOTTOM" )
-- }

-- skill.radioButtons[skill.productTabIndex]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_AWAKEN_WEAPONS") ) -- 각성무기
-- if awakenWeaponContentsOpen then
	-- skill.radioButtons[skill.productTabIndex]:SetShow( true )
-- else
	-- skill.radioButtons[skill.productTabIndex]:SetShow( false )
-- end

-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- local _frame_Combat 		= UI.getChildControl ( Panel_Window_Skill, "Frame_Combat" )
-- local _frame_content_Combat = UI.getChildControl ( Panel_Window_Skill, "Frame_Combat" )
-- local _frame_scroll_Combat 	= UI.getChildControl ( _frame_Combat, "Frame_1_Scroll" )
-- local _frame_sldBtn_Combat 	= UI.getChildControl ( _frame_scroll_Combat, "Frame_1_Scroll_CtrlButton" )

-- local _txt_ResourceSaveDesc	= UI.getChildControl ( Panel_Window_Skill, "StaticText_ResourceSaveDesc" )

-- _txt_ResourceSaveDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
-- _txt_ResourceSaveDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_RESOURCESAVEDESC") )

-- local saved_isLearnMode = true

-- local learnedSkillList = Array.new() -- 배운 스킬목록 : 처음 스킬창 켰을때 이펙트띄워주기 용도임.

-- function SkillCalcPosYByRow( row )
	-- if ( 0 == row % 2 ) then
		-- return ( row / 2 ) * ( skill.config.slotGapY + skill.config.emptyGapY ) + skill.config.emptyGapY + skill.config.slotStartY
	-- else
		-- return ( ( row +1 ) / 2 ) * ( skill.config.slotGapY + skill.config.emptyGapY ) + skill.config.slotStartY
	-- end
-- end

-- function SkillCalcPosYByColumn( col )
	-- if ( 0 == col % 2 ) then
		-- return ( col / 2 ) * ( skill.config.slotGapX + skill.config.emptyGapX ) + skill.config.emptyGapX + skill.config.slotStartX
	-- else
		-- return ( ( col +1 ) / 2 ) * ( skill.config.slotGapX + skill.config.emptyGapX ) + skill.config.slotStartX
	-- end
-- end

-- function SkillShowAni()
	-- UIAni.fadeInSCR_Down( Panel_Window_Skill )
-- end

-- function SkillHideAni()
	-- Panel_Window_Skill:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	-- local skillHideAni = Panel_Window_Skill:addColorAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	-- skillHideAni:SetStartColor( UI_color.C_FFFFFFFF )
	-- skillHideAni:SetEndColor( UI_color.C_00FFFFFF )
	-- skillHideAni:SetStartIntensity( 3.0 )
	-- skillHideAni:SetEndIntensity( 1.0 )
	-- skillHideAni.IsChangeChild = true
	-- skillHideAni:SetHideAtEnd(true)
	-- skillHideAni:SetDisableWhileAni(true)
-- end

-- -- 초기화 함수
-- function skill:InitSkillLearnableSlot()

	-- skill.staticBottomBox = UI.getChildControl( Panel_Window_Skill, "Static_BottomBox" )
			
	-- for index=0, skill.learnableSlotShowMaxCount-1 do

		-- local slot = {}
		-- SlotSkill.new( slot, "Learnable_"..index, skill.staticBottomBox, skill.slotConfig )
		
		-- if ( nil ~= slot.learnButton ) then
			-- slot.learnButton:SetIgnore( true )
		-- end
			
		-- if ( nil ~= slot.icon ) then
			-- slot:clearSkill()
		-- end			
					
		-- skill.learnableSlots[index] = slot
	-- end
		
-- end

-- function UpdateLearnableSlots()
	-- ClearLearnableSlots()
-- end

-- function ClearLearnableSlots()
	
	-- for index, skillSlot in pairs( skill.learnableSlots ) do
		-- skillSlot.icon:SetShow(false);
		-- skillSlot:clearSkill();
	-- end

	-- skill.learnableSlotCount = 0
-- end


-- function skill:initControl()
	-- for _,control in pairs(self.slotConfig.template) do
		-- control:SetShow( false )
	-- end
	
	-- skill.frames[0]:addInputEvent("Mouse_UpScroll", 	"Skill_ScrollEvent(true)")
	-- skill.frames[0]:addInputEvent("Mouse_DownScroll",	"Skill_ScrollEvent(true)")
	-- skill.frames[0]:addInputEvent("Mouse_On", 			"Skill_ScrollEvent(true)")
	-- skill.frames[0]:addInputEvent("Mouse_Out", 			"Skill_ScrollEvent(false)")
	
	-- local vScroll = skill.frames[0]:GetVScroll()
	-- vScroll:addInputEvent("Mouse_LDown", "Skill_ScrollEvent(true)" )

-- end

-- function skill:getLineTemplate( isSlotColumn, isSlotRow, lineType )
	-- local lineDef = nil
	-- -- Line Type 정하기
	-- if isSlotColumn and isSlotRow then
		-- lineDef = self.template_guideLine.l
	-- elseif not isSlotColumn and isSlotRow then
		-- lineDef = self.template_guideLine.v
	-- elseif isSlotColumn and not isSlotRow then
		-- lineDef = self.template_guideLine.h
	-- else
		-- lineDef = self.template_guideLine.s
	-- end

	-- return lineDef[lineType]
-- end

-- function skill:initTabControl( cellTable, parent, container )
	-- local cols = cellTable:capacityX()
	-- local rows = cellTable:capacityY()

	-- local startY = self.config.slotStartY
	-- for row = 0, rows - 1 do
		-- local startX = self.config.slotStartX
		-- local isSlotRow = (0 == (row % 2))
		-- if ( isSlotRow ) then
			-- startY = startY + self.config.emptyGapY
		-- else
			-- startY = startY + self.config.slotGapY
		-- end

		-- for col = 0, cols - 1 do
			-- -- UI.debugMessage( 'Row : ' .. row .. ' / Col : ' .. col )
			-- local cell = cellTable:atPointer( col, row )
			-- local skillNo = cell._skillNo

			-- local isSlotColumn = (0 == (col % 2))
			
			-- if ( isSlotColumn ) then
				-- startX = startX + self.config.emptyGapX
			-- else
				-- startX = startX + self.config.slotGapX
			-- end

			-- if cell:isSkillType() then
				-- -- create skill Slot
				-- -- UI.debugMessage( 'Cell Skill Type' )
				-- local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
				-- -- UI.debugMessage( 'Cell get SkillTypeSS Wrapper' )
				
				-- if( nil ~= skillTypeStaticWrapper  ) then
					-- if skillTypeStaticWrapper:isValidLocalizing() then
						-- -- Active 스킬일때만 사용하는 컨트롤!
						-- local skillTypeStatic = skillTypeStaticWrapper:get()
						-- -- UI.debugMessage( 'Cell get SkillTypeSS' )
						-- self.slotConfig.createFG = skillTypeStatic:isActiveSkill() and skillTypeStatic._isSettableQuickSlot
						-- self.slotConfig.createFGDisabled = self.slotConfig.createFG
						-- self.slotConfig.createFG_Passive = not self.slotConfig.createFG
						
						-- --self.slotConfig.createTestimonial = skillTypeStatic:isTestimonialSkill()

						-- local slot = {}
						-- -- UI.debugMessage( 'Skill Slot create' )
						-- SlotSkill.new( slot, skillNo, parent, self.slotConfig )
						-- slot:setPos( startX, startY )

						-- -- set Event Handler
						-- if nil ~= slot.learnButton then
							-- slot.learnButton:SetIgnore( true )
						-- end
						
						-- -- if nil ~= slot.reservationButton then
							-- -- slot.reservationButton:SetIgnore(false)
							-- -- slot.reservationButton:addInputEvent( "Mouse_LUp", "SkillWindow_SetReservationButtonClick("..skillNo..")" )
							-- -- slot.reservationButton:addInputEvent( "Mouse_On", "SkillWindow_Reservation_HelpFunc( true )" )
							-- -- slot.reservationButton:addInputEvent( "Mouse_Out", "SkillWindow_Reservation_HelpFunc( false )" )
						-- -- end
						
						-- if ( nil ~= slot.icon ) then
							-- slot.icon:addInputEvent( "Mouse_LUp", "HandleClickedSkillWindow_LearnButtonClick("..skillNo..")" )
							-- slot.icon:addInputEvent( "Mouse_On", "Skill_OverEvent(" .. skillNo .. ",false, \"SkillBox\")" )
							-- slot.icon:addInputEvent( "Mouse_Out", "Skill_OverEventHide(" .. skillNo .. ",\"SkillBox\")" )
							-- Panel_SkillTooltip_SetPosition( skillNo, slot.icon, "SkillBox" )
						-- end

						-- -- Set Skill Data
						-- -- UI.debugMessage( 'Skill Slot setPos' )
						-- slot:setSkillTypeStatic( skillTypeStaticWrapper )

						-- -- UI.debugMessage( 'Skill Slot add to Container' )
						-- container[ skillNo ] = slot
					-- end
				-- else
					-- _PA_ASSERT("스킬트리", "skillTypeStaticStatus 매니져에 없는 스킬이 있습니다." );
				-- end
				
				
			-- elseif cell:isLineType() then
				-- -- UI.debugMessage( 'Cell Line Type' )
				-- local template = self:getLineTemplate( isSlotColumn, isSlotRow, cell._cellType )
				-- if nil ~= template then
					-- local line = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, parent, 'Static_Line_' .. col .. '_' .. row )
					-- CopyBaseProperty( template, line )
					-- line:SetPosX( startX )
					-- line:SetPosY( startY )
					-- line:SetIgnore( true )
					-- line:SetShow( true )
				-- end
			-- end
		-- end
	-- end
-- end

-- function SkillWindow_Reservation_HelpFunc( isOn )
	-- local mouse_posX = getMousePosX()
	-- local mouse_posY = getMousePosY()
	
	-- local panel_posX = Panel_Window_Skill:GetPosX()
	-- local panel_posY = Panel_Window_Skill:GetPosY()
	
	
	-- if ( isOn == true ) then
		-- skill.slotConfig.template.reserve_Helper:SetShow( true )
		-- skill.slotConfig.template.reserve_Helper:SetPosX( mouse_posX - panel_posX  )
		-- skill.slotConfig.template.reserve_Helper:SetPosY( mouse_posY - panel_posY + 15 )
	-- else
		-- skill.slotConfig.template.reserve_Helper:SetShow( false )
	-- end
-- end


-- -- 전투 스킬 Tab
-- function skill:initTabControl_Combat()
	-- local targetFrame = self.frames[self.combatTabIndex]
	-- self.slots[self.combatTabIndex] = {}
	-- local classType = getSelfPlayer():getClassType()
	-- if 0 <= classType then
		-- local cellTable = getCombatSkillTree( classType )
		-- self:initTabControl( cellTable, targetFrame:GetFrameContent(), self.slots[self.combatTabIndex] )
	-- end
	-- targetFrame:UpdateContentScroll()
-- end

-- -- 아이템 스킬 Tab
-- function skill:initTabControl_Item()
	-- local targetFrame = self.frames[self.itemTabIndex]
	-- self.slots[self.itemTabIndex] = {}

	-- local classType = getSelfPlayer():getClassType()
	-- if 0 <= classType then
		-- local cellTable = getItemSkillTree( classType )
		-- self:initTabControl( cellTable, targetFrame:GetFrameContent(), self.slots[self.itemTabIndex] )
	-- end
	-- targetFrame:UpdateContentScroll()
-- end

-- -- 생산 스킬 Tab
-- function skill:initTabControl_Product()
	-- local targetFrame = self.frames[self.productTabIndex]
	-- self.slots[self.productTabIndex] = {}

	-- local cellTable = getProductSkillTree()
	-- self:initTabControl( cellTable, targetFrame:GetFrameContent(), self.slots[self.productTabIndex] )
	-- targetFrame:UpdateContentScroll()
-- end

-- -- 길드 스킬 Tab
-- function skill:initTabControl_Guild()
	-- local targetFrame = self.frames[self.guildTabIndex]
	-- self.slots[self.guildTabIndex] = {}

	-- local cellTable = getGuildSkillTree()
	-- self:initTabControl( cellTable, targetFrame:GetFrameContent(), self.slots[self.guildTabIndex] )
	-- targetFrame:UpdateContentScroll()
-- end

-- -- 각성무기 스킬 Tab
-- function skill:initTabControl_AwakeningWeapon()
	-- local targetFrame = self.frames[self.productTabIndex]
	-- self.slots[self.productTabIndex] = {}

	-- -- local cellTable = getProductSkillTree()
	-- -- self:initTabControl( cellTable, targetFrame:GetFrameContent(), self.slots[self.productTabIndex] )
	-- -- targetFrame:UpdateContentScroll()

	-- local classType = getSelfPlayer():getClassType()
	-- if 0 <= classType then
		-- local cellTable = getAwakeningWeaponSkillTree( classType )
		-- self:initTabControl( cellTable, targetFrame:GetFrameContent(), self.slots[self.productTabIndex] )
	-- end
	-- targetFrame:UpdateContentScroll()
-- end


-- function SkillWindow_OpenForLearn()
	-- saved_isLearnMode = true
	-- local self = skill
	-- local screenSizeX = getScreenSizeX()
	-- local screenSizeY = getScreenSizeY()
	-- if not Panel_Window_Skill:IsShow() then
		-- UIAni.fadeInSCRDialog_Down(Panel_Window_Skill)
		-- Panel_Window_Skill:SetShow(true, IsAniUse())
		-- if screenSizeX <= 1400 then
			-- Panel_Window_Skill:SetPosX( ( screenSizeX / 2 ) - ( Panel_Window_Skill:GetSizeX() / 2 ) - 100 )
		-- else
			-- Panel_Window_Skill:SetPosX( ( screenSizeX / 2 ) - ( Panel_Window_Skill:GetSizeX() / 2 ) )
		-- end
		-- Panel_Window_Skill:SetPosY( ( screenSizeY / 2 ) - ( Panel_Window_Skill:GetSizeY() / 2 ) )
		-- EnableSkillShowFunc()
		-- Panel_EnableSkill_SetPosition()
		-- --UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		-- -- audioPostEvent_SystemUi(01,00)
		
		-- local aniInfo1 = Panel_Window_Skill:addScaleAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		-- aniInfo1:SetStartScale(0.5)
		-- aniInfo1:SetEndScale(1.1)
		-- aniInfo1.AxisX = Panel_Window_Skill:GetSizeX() / 2
		-- aniInfo1.AxisY = Panel_Window_Skill:GetSizeY() / 2
		-- aniInfo1.ScaleType = 2
		-- aniInfo1.IsChangeChild = true
		
		-- local aniInfo2 = Panel_Window_Skill:addScaleAnimation( 0.12, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		-- aniInfo2:SetStartScale(1.1)
		-- aniInfo2:SetEndScale(1.0)
		-- aniInfo2.AxisX = Panel_Window_Skill:GetSizeX() / 2
		-- aniInfo2.AxisY = Panel_Window_Skill:GetSizeY() / 2
		-- aniInfo2.ScaleType = 2
		-- aniInfo2.IsChangeChild = true
	-- end
	-- SkillWindow_UpdateData( self.combatTabIndex, true )
	-- -- self.radioButtons[self.combatTabIndex]:SetCheck( true )		--탭 초기화
	-- self.radioButtons[self.itemTabIndex]:SetCheck( false )
	-- -- self.radioButtons[self.productTabIndex]:SetCheck( false )
	-- self.radioButtons[self.guildTabIndex]:SetCheck( false )
	-- local combatCheck = self.radioButtons[self.combatTabIndex]:IsCheck()
	-- if combatCheck then
		-- self.radioButtons[self.combatTabIndex]:SetCheck( true )
		-- self.radioButtons[self.productTabIndex]:SetCheck( false )
		-- SkillWindow_UpdateData( self.combatTabIndex )
	-- else
		-- self.radioButtons[self.combatTabIndex]:SetCheck( false )
		-- self.radioButtons[self.productTabIndex]:SetCheck( true )
		-- SkillWindow_UpdateData( self.productTabIndex )
	-- end
	-- FGlobal_SetUrl_Tooltip_SkillForLearning()
-- end


-- -- 이벤트 핸들러들
-- function SkillWindow_Show()
	-- SkillWindow_OpenForLearn() -- 테스트용
	-- -- Panel_Window_Skill:SetShow(true, true)
	-- -- Panel_Window_Skill:SetPosX( ( getScreenSizeX() / 2 ) - ( Panel_Window_Skill:GetSizeX() / 2 ) )
	-- -- Panel_Window_Skill:SetPosY( ( getScreenSizeY() / 2 ) - ( Panel_Window_Skill:GetSizeY() / 2 ) - 70 )
	-- -- EnableSkillShowFunc()
	-- -- Panel_EnableSkill_SetPosition()
	-- -- audioPostEvent_SystemUi(01,00)
	-- local vScroll = skill.frames[0]:GetVScroll()
	-- vScroll:SetControlPos(scrollPos)
	-- skill.frames[0]:UpdateContentPos()
	-- SkillWindow_UpdateData()
	
	-- --이펙트뿌려주고 다시 켜면 안보이게 어레이 정리
	-- for index = 1, #learnedSkillList do
		-- local skillNo = learnedSkillList[index]
		-- skill.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
		-- skill.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
		-- skill.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill_Loop01", true, 0, 0)
	-- end
	-- learnedSkillList = Array.new()
	-- local classType = getSelfPlayer():getClassType()
	-- if awakenWeaponContentsOpen then
		-- skill.radioButtons[skill.productTabIndex]:SetMonoTone( false )
		-- skill.radioButtons[skill.productTabIndex]:SetEnable( true )
	-- else
		-- skill.radioButtons[skill.productTabIndex]:SetMonoTone( true )
		-- skill.radioButtons[skill.productTabIndex]:SetEnable( false )
	-- end
-- end

-- function SkillWindow_Close( isManualClick )
	-- if Panel_Window_Skill:IsShow() then
		-- isPartsSkillReset = false
		-- -- if isFlushedUI() and getSelfPlayer():get():getLevel() < 6 and ( true == isManualClick ) then
		-- -- 	Proc_ShowMessage_Ack( "튜토리얼 진행 중에는 스킬 창을 임의로 닫을 수 없습니다." )
		-- -- 	return
		-- -- end

		-- local self = skill
		-- self.lastLearnMode = true
		-- saved_isLearnMode = true
		-- Panel_SkillTooltip_Hide()
		-- UIMain_SkillPointUpdateRemove()
		-- Panel_Window_Skill:SetShow(false, true)
		-- EnableSkillShowFunc()
		-- Panel_Scroll:SetShow(false, false)
		-- --UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		-- -- audioPostEvent_SystemUi(01,01)
		
		-- if ( Panel_EnableSkill:IsShow() ) then
			-- EnableSkillShowFunc()
		-- end
	-- end
	
	-- for _, value in pairs( skill.skillNoSlot ) do
		-- value.icon:EraseAllEffect()
	-- end
	
	-- HelpMessageQuestion_Out()		-- 물음표 버튼 툴팁 끄기
	-- local vScroll = skill.frames[0]:GetVScroll()
	-- scrollPos = vScroll:GetControlPos()
	
	-- FGlobal_ResetUrl_Tooltip_SkillForLearning()
-- end


-- function skill:registEventHandler()
	-- self.buttonClose:addInputEvent( "Mouse_LUp", "SkillWindow_Close( true )" )
	-- self._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowSkill\" )" )									-- 물음표 좌클릭
	-- self._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowSkill\", \"true\")" )				-- 물음표 마우스오버
	-- self._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowSkill\", \"false\")" )				-- 물음표 마우스오버

	-- self.radioButtons[self.combatTabIndex]:addInputEvent( "Mouse_LUp", "SkillWindow_UpdateData(" .. self.combatTabIndex .. ")" )
	-- self.radioButtons[self.itemTabIndex]:addInputEvent( "Mouse_LUp", "SkillWindow_UpdateData(" .. self.itemTabIndex .. ")" )
	-- self.radioButtons[self.productTabIndex]:addInputEvent( "Mouse_LUp", "SkillWindow_UpdateData(" .. self.productTabIndex .. ")" )
	-- self.radioButtons[self.guildTabIndex]:addInputEvent( "Mouse_LUp", "SkillWindow_UpdateData(" .. self.guildTabIndex .. ")" )
-- end

-- -- 메시지 핸들러들
-- function SkillWindow_ControlInitialize()
	-- local self = skill
	-- if self.controlInitialize then
		-- return
	-- end

	-- -- 스킬 탭 별 이니셜라이징
	-- self:initTabControl_Combat()
-- --{ 사용안함....
	-- --self:initTabControl_Item()
	-- self:initTabControl_AwakeningWeapon()
-- --}
	-- self:initTabControl_Guild()

	-- -- Template 컨트롤 숨기기!
	-- self.slotConfig.template.effect:SetShow( false )
	-- self.slotConfig.template.iconFG:SetShow( false )
	-- self.slotConfig.template.iconFGDisabled:SetShow( false )
	-- --self.slotConfig.template.textLevel:SetShow( false )
	-- self.slotConfig.template.learnButton:SetShow( false )
	-- -- self.slotConfig.template.reservationButton:SetShow( false )
	
	-- -- Tab RadioButton 초기화
	-- self.radioButtons[self.combatTabIndex]:SetCheck( true )
	-- self.radioButtons[self.itemTabIndex]:SetCheck( false )
	-- self.radioButtons[self.productTabIndex]:SetCheck( false )
	-- self.radioButtons[self.guildTabIndex]:SetCheck( false )

	-- SkillWindow_GuildInfoChanged()

	-- SkillWindow_UpdateData( self.combatTabIndex, false, true )

	-- self.controlInitialize = true
-- end

-- --[[기본값 정의 :: tabIndex = '마지막tabIndex', isLearnMode = false, doForce = false]]
-- function SkillWindow_UpdateData( tabIndex, isLearnMode, doForce )
	-- local self = skill
	-- -- 기본값 설정
	-- tabIndex = tabIndex or self.lastTabIndex
	-- isLearnMode = isLearnMode or self.lastLearnMode
	-- doForce = doForce or false

	-- if (not doForce) and (not Panel_Window_Skill:GetShow()) then
		-- return
	-- end
	-- self.lastTabIndex = tabIndex
	-- self.lastLearnMode = isLearnMode

	-- -- 선택한 Tab 을 제외하고는 모두 숨긴다!
	-- for index, frame in pairs(self.frames) do
		-- if tabIndex == index then
			-- frame:SetShow( true )
		-- else
			-- frame:SetShow( false )
		-- end
	-- end

	-- local reservedLearningSkillNo = 0; 
	-- if ( getSelfPlayer():get():getReservedLearningSkillKey():isDefined() ) then
		-- reservedLearningSkillNo = getSelfPlayer():get():getReservedLearningSkillKey():getSkillNo()
	-- end
	
	-- -- 선택한 Tab 에 포함되어 있는 스킬 슬롯 컨트롤들
	-- -- Table< SkillNo, SkillSlot >
	-- skill.learnableSlotsSortList = {};
	-- skill.learnableSlotsSortListCount = 0;
	
	-- local slots = self.slots[tabIndex]
	-- for skillNo,slot in pairs(slots) do
		-- slot.iconMinus:SetShow(false)
		-- slot.icon:addInputEvent( "Mouse_LUp", "HandleClickedSkillWindow_LearnButtonClick("..skillNo..")" )
		-- slot.icon:EraseAllEffect()
		
		-- local skillLevelInfo = getSkillLevelInfo( skillNo )
		-- if nil ~= skillLevelInfo then
			-- saved_isLearnMode = isLearnMode
			-- local resultAble = slot:setSkill( skillLevelInfo, isLearnMode )
			-- if( resultAble ) then
				-- skill.learnableSlotsSortList[skill.learnableSlotsSortListCount] = skillNo
				-- skill.learnableSlotsSortListCount = skill.learnableSlotsSortListCount + 1
			-- end
		
			-- local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
			-- if false == skillLevelInfo._learnable and skillLevelInfo._usable and skillTypeStaticWrapper:get()._isSettableQuickSlot then
				-- slot.icon:addInputEvent( "Mouse_PressMove", "SkillWindow_StartDrag("..skillNo..")" )
				-- slot.icon:SetEnableDragAndDrop(true)
			-- else
				-- slot.icon:addInputEvent( "Mouse_PressMove", "" )
				-- slot.icon:SetEnableDragAndDrop(false)
			-- end
		-- end
		
		-- -- 배우기 예약 스킬로 등록한 스킬.
		-- if( skillNo == reservedLearningSkillNo ) then
			-- slot.effect:SetShow(true)
		-- else	
			-- slot.effect:SetShow(false)
		-- end
		
		-- self.skillNoSlot[skillNo] = slot

	-- end
	
	-- UpdateLearnableSlots()

	-- -- 스킬 포인트 및 스킬 경험치 값을 갱신한다!
	-- local selfPlayer = getSelfPlayer()
	-- if (nil == selfPlayer) then -- or (tabIndex < self.combatTabIndex) or (self.guildTabIndex < tabIndex) then
		-- self.staticRemainPoint:SetShow(false)
		-- self.staticSkillLevel:SetShow(false)
		-- self.progressSkillExp:SetShow(false)
	-- else
		-- self.textSkillPoint:SetShow(true)
		-- self.staticRemainPoint:SetShow(true)
		-- self.staticSkillLevel:SetShow(false)
		-- self.progressSkillExp:SetShow(false)

		-- self.textSkillPoint:SetSize( self.textSkillPoint:GetTextSizeX()+10, self.textSkillPoint:GetSizeY() )
		-- local skillPointInfo = getSkillPointInfo( 0 ) -- tabIndex가 들어가있었지만 0으로 고정했다.(각성무기 때문에...)
		-- if nil ~= skillPointInfo then
			-- self.staticRemainPoint:SetText( tostring(skillPointInfo._remainPoint))
			-- self.staticRemainPoint:SetSpanSize( (self.textSkillPoint:GetPosX() + self.textSkillPoint:GetSizeX() + 5), self.staticRemainPoint:GetSpanSize().y )
		-- end
	-- end

	-- if isPartsSkillReset then
		-- SkillWindow_UpdateClearData()
	-- end
-- end

-- function SkillWindow_UpdateClearData()
	-- isPartsSkillReset = true
	-- local isNewSkillBtn = skill.radioButtons[skill.productTabIndex]:IsCheck()
	-- local isOldSkillBtn = skill.radioButtons[skill.combatTabIndex]:IsCheck()
	-- local slots = nil
	-- if isNewSkillBtn then
		-- slots = skill.slots[skill.productTabIndex]
	-- else
		-- slots = skill.slots[skill.combatTabIndex]
	-- end
	-- -- local slots = skill.slots[skill.combatTabIndex]
	-- if nil == slots then
		-- return
	-- end
	
	-- for skillNo,slot in pairs(slots) do
		-- slot:clearSkill()		-- clearSkill을하면 해당 아이콘의 Alpha값을 0으로 만든다.
		-- slot.icon:SetAlpha(1)
		-- slot.skillNo = skillNo

		-- local isFGDisable = true
		-- if nil ~= slot.iconFGDisabled then
			-- slot.iconFGDisabled:SetShow(true)
		-- end
		
		-- if nil ~= slot.iconFG_Passive then
			-- isFGDisable = false
			-- slot.iconFG_Passive:SetShow(true)
		-- end
		
		-- local skillLevelInfo = getSkillLevelInfo( skillNo )
		-- if nil == skillLevelInfo then
			-- return
		-- end
		
		-- if skillLevelInfo._usable then
			-- local skillStaticWrapper = getSkillStaticStatus( skillNo, 1 )
			-- if nil == skillStaticWrapper then
				-- return
			-- end
			
			-- if (not skillStaticWrapper:isAutoLearnSkillByLevel()) and (not skillStaticWrapper:isLearnSkillByItem()) and (skillStaticWrapper:isLastSkill()) then
				-- slot.iconMinus:SetShow(true)
				-- slot.icon:addInputEvent("Mouse_LUp", "SkillWindow_ClearButtonClick(".. skillNo ..")")
				
				-- if isFGDisable then
					-- slot.iconFGDisabled:SetShow(false)
				-- else
					-- slot.iconFG_Passive:SetShow(false)
				-- end
			-- end
		-- end	
	-- end
	
	-- -- 스킬 포인트 갱신
	-- local skillPointInfo = getSkillPointInfo( skill.combatTabIndex )
	-- if nil ~= skillPointInfo then
		-- skill.staticRemainPoint:SetText( tostring(skillPointInfo._remainPoint))
	-- end	
-- end

-- function SkillWindow_ClearButtonClick( skillNo )
	-- ToClient_RequestClearSkillPartly( skillNo )
	-- isPartsSkillReset = false
-- end

-- -- function SkillWindow_SetReservationButtonClick( skillNo )
	-- -- -- ♬ 스킬 예약 했을 때 사운드 추가
	-- -- audioPostEvent_SystemUi(01,09)
	-- -- skillWindow_SetReservedLearningSkill(skillNo)
	-- -- skill.slotConfig.template.reserve_Helper:SetShow( false )
-- -- end

-- -- function SkillWindow_ClearReservationButtonClick( )
	-- -- skillWindow_ClearReservedLearningSkill()
-- -- end

-- function HandleClickedSkillWindow_LearnButtonClick( skillNo )
	-- local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	-- if (nil == skillTypeStaticWrapper) then
		-- return
	-- end
	-- local skillLevelInfo = getSkillLevelInfo( skillNo )
	-- if ( nil == skillLevelInfo ) then
		-- return
	-- end
	-- if ( false == skillLevelInfo._learnable ) then
		-- return
	-- end

	-- local DolearnSkill = function()
		-- SkillWindow_LearnButtonClick( skillNo )
	-- end

	-- local skillType = skillTypeStaticWrapper:requiredEquipType()
	-- if 55 == skillType then -- 스킬 필요 장비가 수리검이면
		-- local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_SKILLTYPE_MEMO1")
		-- local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = DolearnSkill, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	-- MessageBox.showMessageBox(messageBoxData)
	-- elseif 56 == skillType then -- 스킬 필요 장비가 표창이면
		-- local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_SKILLTYPE_MEMO2")
		-- local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = DolearnSkill, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	-- MessageBox.showMessageBox(messageBoxData)
	-- else
		-- DolearnSkill()
	-- end
-- end

-- function SkillWindow_LearnButtonClick( skillNo )
	-- if ( false == saved_isLearnMode ) then
		-- return
	-- end
	-- local skillLevelInfo = getSkillLevelInfo( skillNo )
	-- if ( nil == skillLevelInfo ) then
		-- return
	-- end
	-- if ( false == skillLevelInfo._learnable ) then
		-- return
	-- end

	-- local self = skill
	-- local isSuccess = skillWindow_DoLearn( skillNo )
	-- audioPostEvent_SystemUi(00,00)
	
	-- if ( isSuccess ) then
		-- -- ♬ 스킬 배웠을 때 소리 들어가야함
		-- audioPostEvent_SystemUi(04,02)
		
		-- self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
		-- self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
		-- self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill_Loop01", true, 0, 0)
		-- learnedSkillList:push_back(skillNo)
	-- end
	
	-- if ( nil == self.skillNoSlot[skillNo].icon ) then
		-- return
	-- end
	
	-- UI_MAIN_checkSkillLearnable()

	-- if ( isSkillLearnTutorialClick_check() ) then	-- 튜토리얼 중 눌렀다면. 꺼준다.
		-- SkillWindow_Close()
	-- end
-- end

-- function SkillWindow_LearnQuest( skillNo )
	-- local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	-- if false == skillTypeStaticWrapper:isValidLocalizing() then	-- 컨텐츠 타입에서 열려야 처리한다.
		-- return
	-- end

	-- local self = skill
	-- audioPostEvent_SystemUi(00,00)
	
	-- if nil ~= self.skillNoSlot[skillNo] then
		-- -- ♬ 스킬 배웠을 때 소리 들어가야함
		-- audioPostEvent_SystemUi(04,02)
		
		-- self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
		-- self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
		-- self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill_Loop01", true, 0, 0)
	-- end

	-- if ( nil == self.skillNoSlot[skillNo].icon ) then
		-- return
	-- end
	
	-- UI_MAIN_checkSkillLearnable()
-- end


-- function SkillWindow_StartDrag( skillNo )
	-- if Defines.UIMode.eUIMode_NpcDialog == GetUIMode() then
		-- return
	-- end
	-- local skillLevelInfo = getSkillLevelInfo( skillNo )
	-- local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	-- if (nil ~= skillLevelInfo) and (nil ~= skillTypeStaticWrapper) then
		-- DragManager:setDragInfo(Panel_Window_Skill, nil, skillLevelInfo._skillKey:get(), "Icon/" .. skillTypeStaticWrapper:getIconPath(), Skill_GroundClick, nil )
	-- end
-- end


-- function Skill_GroundClick( whereType, skillKey )
	-- if isUseNewQuickSlot() then
		-- FGlobal_SetNewQuickSlot_BySkillGroundClick( skillKey )
	-- end
-- end


-- function SkillWindow_GuildInfoChanged()
	-- local self = skill
	-- local isGuildMember = getSelfPlayer():get():isGuildMember()

	-- self.radioButtons[self.guildTabIndex]:SetEnable( isGuildMember )
	-- self.radioButtons[self.guildTabIndex]:SetMonoTone( not isGuildMember )
	-- if (not isGuildMember) and (self.guildTabIndex == self.lastTabIndex) then
		-- self.radioButtons[self.guildTabIndex]:SetCheck(false)
		-- self.radioButtons[self.combatTabIndex]:SetCheck(true)
		-- SkillWindow_UpdateData( self.combatTabIndex, nil, true )	-- learnMode 를 지정하지 않고 nil 로 가면 현재값을 사용한다.
	-- end
-- end

-- function skill:registMessageHandler()
	-- registerEvent("EventSkillWindowInit",				"SkillWindow_ControlInitialize")
	-- registerEvent("EventSkillWindowUpdate",				"SkillWindow_UpdateData")
	-- registerEvent("EventSkillWindowShowForLearn",		"SkillWindow_OpenForLearn")
	-- registerEvent("EventlearnedSkill",					"SkillWindow_LearnQuest")
	-- registerEvent("EventSkillWindowClearSkill",			"Event_SkillWindowClearSkill")
	-- --registerEvent("EventSkillWindowClearSkillByPoint",	"Event_SkillWindowClearSkillByPoint")
	-- registerEvent("EventReservedLearningSkill",			"Event_ReservedLearningSkill")
	-- registerEvent("FromClient_ClearSkillsByPoint",		"FromClient_ClearSkillsByPoint")
	-- registerEvent("FromClient_SkillWindowClose",		"SkillWindow_Close")
-- end

-- function FromClient_ClearSkillsByPoint()
	-- saved_isLearnMode = false
	-- isPartsSkillReset = true
	-- if Panel_Window_Skill:IsShow() then
		-- Panel_Window_Skill:SetShow(false)
		-- Panel_EnableSkill:SetShow(false)
	-- end
	
	-- UIAni.fadeInSCRDialog_Down(Panel_Window_Skill)
	-- Panel_Window_Skill:SetShow(true, IsAniUse())
	-- Panel_Window_Skill:SetPosX( ( getScreenSizeX() / 2 ) - ( Panel_Window_Skill:GetSizeX() / 2 ) )
	-- Panel_Window_Skill:SetPosY( ( getScreenSizeY() / 2 ) - ( Panel_Window_Skill:GetSizeY() / 2 ) - 70 )
	-- SkillWindow_UpdateClearData()
-- end

-- function Event_SkillWindowClearSkill( skillPointType )
	
	-- local strTemp1
	-- local strTemp2
	-- if( 0 ==  skillPointType) then
		-- strTemp1 = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_COMBAT_SKILL_TITLE" )
		-- strTemp2 = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_COMBAT_SKILL_MESSAGE" )
	-- else
		-- strTemp1 = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_PRODUCT_SKILL_TITLE" )
		-- strTemp2 = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_PRODUCT_SKILL_MESSAGE" )
	-- end
	
	-- local messageboxData = { title = strTemp1, content = strTemp2, functionYes = SkillWindow_ClearSkill_ConfirmFromMessageBox , functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	-- MessageBox.showMessageBox(messageboxData);
-- end

-- function SkillWindow_ClearSkill_ConfirmFromMessageBox()
	-- skillWindow_ClearSkill();
	
	-- if Panel_Window_Skill:IsShow() then
		-- Panel_Window_Skill:SetShow(false)
		-- Panel_EnableSkill:SetShow(false)
	-- end
-- end

-- local skillNoCache = 0
-- local slotTypeCache = 0
-- local tooltipcacheCount = 0

-- function Skill_OverEventHide( skillNo, SlotType )
	-- if ( skillNoCache == skillNo ) and ( slotTypeCache == SlotType ) then
		-- tooltipcacheCount = tooltipcacheCount - 1
	-- else
		-- tooltipcacheCount = 0
	-- end

	-- if ( tooltipcacheCount <= 0 ) then
		-- Panel_SkillTooltip_Hide()
	-- end
-- end
-- function Skill_OverEvent( skillNo, isShowNextLevel, SlotType )
	-- if ( skillNoCache == skillNo ) and ( slotTypeCache == SlotType ) then
		-- tooltipcacheCount = tooltipcacheCount + 1
	-- else
		-- skillNoCache = skillNo
		-- slotTypeCache = SlotType
		-- tooltipcacheCount = 1
	-- end
	-- Panel_SkillTooltip_Show(skillNo, false, SlotType)
	-- skill.skillNoSlot[skillNo].icon:EraseAllEffect()
	
	-- if ("SkillBoxBottom" == SlotType) then
		-- local selectedSlot = UI.getChildControl ( skill.frames[0]:GetFrameContent(), 'StaticSkill_' .. skillNo )

		-- Skill_WindowPosSet( selectedSlot:GetPosY() )
	-- end
-- end

-- function Event_SkillWindowClearSkillByPoint( skillPointType )

-- end

-- function Skill_WindowPosSet( pos )
	-- local vScroll = skill.frames[0]:GetVScroll()

	-- local contentUseSize = ( skill.frames[0]:GetFrameContent():GetSizeY() - skill.frames[0]:GetSizeY() )
	-- local posPercents = ( pos - skill.frames[0]:GetSizeY() / 2 ) / contentUseSize
	-- vScroll:SetControlPos( math.max( math.min(posPercents,1), 0) )

	-- --vScroll:SetControlPos(pos/(skill.frames[0]:GetFrameContent():GetSizeY()-vScroll:GetControlButton():GetSizeY()))
	-- skill.frames[0]:UpdateContentPos()
-- end

-- function SkillWindowEffect( row, col, skillNo )
	-- local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	-- if skillTypeStaticWrapper:isValidLocalizing() then	-- 컨텐츠 타입에서 열려야 처리한다.
		-- local posX, posY = SkillCalcPosYByColumn(col), SkillCalcPosYByRow(row)
		-- Skill_WindowPosSet( posY )
		
		-- local contents = skill.frames[0]:GetFrameContent()
		-- --local effectSizeX, effectSizeY = 21, 21
		-- --contents:AddEffect( "UI_Inventory_EmptySlot", false, posX - contents:GetSizeX() / 2 + effectSizeX, posY - contents:GetSizeY() / 2 + effectSizeY )
		-- skill.slots[skill.combatTabIndex][skillNo].learnButton:EraseAllEffect()
		-- skill.slots[skill.combatTabIndex][skillNo].learnButton:AddEffect( "UI_LimitMetastasis_Box02", false, 0, 0 )
		-- skill.slots[skill.combatTabIndex][skillNo].learnButton:AddEffect( "UI_LimitMetastasis_Box01", false, 0, 0 )
		-- skill.slots[skill.combatTabIndex][skillNo].learnButton:AddEffect( "UI_Inventory_EmptySlot", false, 0, 0 )
	-- end
-- end

-- function Event_ReservedLearningSkill( operationType, reason )

	-- local isShow  = Panel_Window_Skill:IsShow();
	-- if isShow then
		-- SkillWindow_UpdateData( )
	-- end
	
	-- if ( 0 == operationType ) then --set의 응답
		-- ExpGauge_SetReservedLearningSkill();
	-- elseif ( 1 == operationType ) then -- clear의 응답
		-- ExpGague_ClearReservedLearningSkill();
	-- elseif ( 2 == operationType ) then	-- 예약 스킬을 배웠을때의 응답
		-- ExpGague_ClearReservedLearningSkill();
	-- elseif ( 3 == operationType ) then	-- 플레이어가 로그인했을때
		-- ExpGauge_SetReservedLearningSkill();
	-- else	-- 에러에 의한 실패	
		-- Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SKILL_RESERVEDLEARNINGSKILL_FAIL_ACK", "reason", reason ) ) -- "스킬의 예약 배우기가 실패하였습니다. " .. reason )
	-- end

-- end

-- function Skill_ScrollEvent(isShow)
	-- local vScroll = skill.frames[0]:GetVScroll()
	-- if isShow then
		-- -- UIScrollButton.ScrollButtonEvent(true, Panel_Window_Skill, skill.frames[0],  vScroll)
	-- else
		-- UIScrollButton.ScrollButtonEvent(false, Panel_Window_Skill, skill.frames[0], vScroll)
	-- end
-- end

-- function Skill_ScrollMove(moveDirection)
	-- if ("up" == moveDirection) then
		-- skill.frames[0]:GetVScroll():SetCtrlPosByInterval(-1)
	-- elseif ("down" == moveDirection) then
		-- skill.frames[0]:GetVScroll():SetCtrlPosByInterval(1)
	-- end
	-- skill.frames[0]:UpdateContentPos()
	-- Skill_ScrollEvent(true)
-- end

-- function SkillWindow_PlayerLearnableSkill()
-- -- 	return bool 해줘야한다.
	-- local self = skill
	
	-- -- 하나라도 배울 것이 있다면 true 리턴
	-- local slots = self.slots[self.combatTabIndex]
	-- for skillNo,slot in pairs(slots) do
		-- local skillLevelInfo = getSkillLevelInfo( skillNo )
		-- if( nil ~= skillLevelInfo ) then
			-- if( skillLevelInfo._learnable ) and ( false == skillLevelInfo._isLearnByQuest ) then
				-- return true
			-- end	
		-- else
			-- return false
			-- -- _PA_ASSERT(false, "skillLevelInfo(" .. skillNo ..")가 존재하지 않습니다.");
		-- end
	-- end

	-- return false
-- end


-- ----------------------------------------------------------------------------------------------------------
-- -- 									배울 수 있는 스킬이 있다!
-- ----------------------------------------------------------------------------------------------------------
-- -- local isChecked_EnableSkill = false
-- -- function EnableSkillCheck_Func()	-- 버튼을 사용하지 않음.
-- -- 	local isLearnable = SkillWindow_PlayerLearnableSkill()
-- -- 	if ( isLearnable ) then
-- -- 		_btn_NewSkill:EraseAllEffect()
-- -- 		-- _btn_NewSkill:AddEffect("UI_ButtonLineRight_Blue", false, -75.0, -3.0)
-- -- 		_btn_NewSkill:SetShow( false )	-- 버튼을 사용하지 않음.
-- -- 		_btn_NewSkill:SetEnableArea ( -_btn_NewSkill:GetTextSizeX()-10, 0, _btn_NewSkill:GetSizeX(), _btn_NewSkill:GetSizeY() )
-- -- 	else
-- -- 		_btn_NewSkill:EraseAllEffect()
-- -- 		_btn_NewSkill:SetShow( false )
-- -- 	end
-- -- end

-- -- _btn_NewSkill:addInputEvent( "Mouse_LUp", "EnableSkillShowFunc()" )


-- -- 초기화 코드
-- skill:initControl()
-- skill:InitSkillLearnableSlot()
-- skill:registEventHandler()
-- skill:registMessageHandler()
-- -- 슬롯 정보 갱신. 한번에 전체를 모두 갱신한다.!
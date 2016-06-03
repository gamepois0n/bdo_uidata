
-- 루아파일이 모두 로드되고 난 이후 초기화를 진행함
function LoadComplete_SkillWindow_Initialize()
	PaGlobal_Skill:initialize()
	PaGlobal_AwakenSkill:initalize()
	Skill_RegistEventHandler()
end

function SkillEvent_SkillWindow_ControlInitialize()
	local self = PaGlobal_Skill
	if self.controlInitialize then
		return
	end

	-- 스킬 탭 별 이니셜라이징
	self:initTabControl_Combat()
	self:initTabControl_AwakeningWeapon()

	-- Template 컨트롤 숨기기!
	self.slotConfig.template.effect:SetShow( false )
	self.slotConfig.template.iconFG:SetShow( false )
	self.slotConfig.template.iconFGDisabled:SetShow( false )
	self.slotConfig.template.learnButton:SetShow( false )
	
	-- Tab RadioButton 초기화
	self.radioButtons[self.combatTabIndex]:SetCheck( true )
	self.radioButtons[self.awakenTabIndex]:SetCheck( false )

	HandleMLUp_SkillWindow_UpdateData( self.combatTabIndex, false, true )

	self.controlInitialize = true
end

function SkillEvent_SkillWindow_LearnQuest( skillNo )
	local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	if false == skillTypeStaticWrapper:isValidLocalizing() then	-- 컨텐츠 타입에서 열려야 처리한다.
		return
	end

	local self = PaGlobal_Skill
	audioPostEvent_SystemUi(00,00)
	
	if nil ~= self.skillNoSlot[skillNo] then
		-- ♬ 스킬 배웠을 때 소리 들어가야함
		audioPostEvent_SystemUi(04,02)
		
		self.skillNoSlot[skillNo].icon:AddEffect("UI_NewSkill01", false, 0, 0)
		self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill01", false, 0, 0)
		self.skillNoSlot[skillNo].icon:AddEffect("fUI_NewSkill_Loop01", true, 0, 0)
	end

	if ( nil == self.skillNoSlot[skillNo].icon ) then
		return
	end
	
	UI_MAIN_checkSkillLearnable()
end

function SkillEvent_SkillWindow_ClearSkill( skillPointType )
	local strTemp1
	local strTemp2
	if( 0 ==  skillPointType) then
		strTemp1 = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_COMBAT_SKILL_TITLE" )
		strTemp2 = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_COMBAT_SKILL_MESSAGE" )
	else
		strTemp1 = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_PRODUCT_SKILL_TITLE" )
		strTemp2 = PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_PRODUCT_SKILL_MESSAGE" )
	end
	
	local messageboxData = { title = strTemp1, content = strTemp2, functionYes = Skill_ClearSkill_ConfirmFromMessageBox , functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
end

function SkillEvent_SkillWindow_ClearSkillsByPoint()
	PaGlobal_Skill.saved_isLearnMode = false
	PaGlobal_Skill.isPartsSkillReset = true
	if Panel_Window_Skill:IsShow() then
		Panel_Window_Skill:SetShow(false)
		Panel_EnableSkill:SetShow(false)
	end
	
	UIAni.fadeInSCRDialog_Down(Panel_Window_Skill)
	Panel_Window_Skill:SetShow(true, IsAniUse())
	Panel_Window_Skill:SetPosX( ( getScreenSizeX() / 2 ) - ( Panel_Window_Skill:GetSizeX() / 2 ) )
	Panel_Window_Skill:SetPosY( ( getScreenSizeY() / 2 ) - ( Panel_Window_Skill:GetSizeY() / 2 ) - 70 )
	PaGlobal_Skill:SkillWindow_UpdateClearData()
end

--[[기본값 정의 :: tabIndex = '마지막tabIndex', isLearnMode = false, doForce = false]]
function HandleMLUp_SkillWindow_UpdateData( tabIndex, isLearnMode, doForce )
	local self = PaGlobal_Skill
	-- 기본값 설정
	tabIndex = tabIndex or self.lastTabIndex
	isLearnMode = isLearnMode or self.lastLearnMode
	doForce = doForce or false

	if (not doForce) and (not Panel_Window_Skill:GetShow()) then
		return
	end
	self.lastTabIndex = tabIndex
	self.lastLearnMode = isLearnMode

	-- 선택한 Tab 을 제외하고는 모두 숨긴다!
	for index, frame in pairs(self.frames) do
		if tabIndex == index then
			frame:SetShow( true )
		else
			frame:SetShow( false )
		end
	end

	-- 선택한 Tab 에 포함되어 있는 스킬 슬롯 컨트롤들
	-- Table< SkillNo, SkillSlot >
	self.learnableSlotsSortList = {};
	self.learnableSlotsSortListCount = 0;
	
	local slots = self.slots[tabIndex]
	for skillNo,slot in pairs(slots) do
		slot.iconMinus:SetShow(false)
		slot.icon:addInputEvent( "Mouse_LUp", "HandleMLUp_SkillWindow_LearnButtonClick("..skillNo..")" )
		slot.icon:EraseAllEffect()
		
		local skillLevelInfo = getSkillLevelInfo( skillNo )
		if nil ~= skillLevelInfo then
			self.saved_isLearnMode = isLearnMode
			local resultAble = slot:setSkill( skillLevelInfo, isLearnMode )
			if( resultAble ) then
				self.learnableSlotsSortList[self.learnableSlotsSortListCount] = skillNo
				self.learnableSlotsSortListCount = self.learnableSlotsSortListCount + 1
			end
		
			local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
			if false == skillLevelInfo._learnable and skillLevelInfo._usable and skillTypeStaticWrapper:get()._isSettableQuickSlot then
				slot.icon:addInputEvent( "Mouse_PressMove", "HandleMLUp_SkillWindow_StartDrag("..skillNo..")" )
				slot.icon:SetEnableDragAndDrop(true)
			else
				slot.icon:addInputEvent( "Mouse_PressMove", "" )
				slot.icon:SetEnableDragAndDrop(false)
			end
		end
				
		self.skillNoSlot[skillNo] = slot

	end
	
	self:UpdateLearnableSlots()

	-- 스킬 포인트 및 스킬 경험치 값을 갱신한다!
	local selfPlayer = getSelfPlayer()
	if (nil == selfPlayer) then
		self.staticRemainPoint:SetShow(false)
		self.staticSkillLevel:SetShow(false)
		self.progressSkillExp:SetShow(false)
	else
		self.textSkillPoint:SetShow(true)
		self.staticRemainPoint:SetShow(true)
		self.staticSkillLevel:SetShow(false)
		self.progressSkillExp:SetShow(false)

		self.textSkillPoint:SetSize( self.textSkillPoint:GetTextSizeX()+10, self.textSkillPoint:GetSizeY() )
		local skillPointInfo = getSkillPointInfo( 0 ) -- tabIndex가 들어가있었지만 0으로 고정했다.(각성무기 때문에...)
		if nil ~= skillPointInfo then
			self.staticRemainPoint:SetText( tostring(skillPointInfo._remainPoint))
			self.staticRemainPoint:SetSpanSize( (self.textSkillPoint:GetPosX() + self.textSkillPoint:GetSizeX() + 5), self.staticRemainPoint:GetSpanSize().y )
		end
	end

	if self.isPartsSkillReset then
		self:SkillWindow_UpdateClearData()
	end
end

function HandleMLUp_SkillWindow_OpenForLearn()
	local self = PaGlobal_Skill
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	self.saved_isLearnMode = true
	
	if not Panel_Window_Skill:IsShow() then
		UIAni.fadeInSCRDialog_Down(Panel_Window_Skill)
		Panel_Window_Skill:SetShow(true, IsAniUse())
		if screenSizeX <= 1400 then
			Panel_Window_Skill:SetPosX( ( screenSizeX / 2 ) - ( Panel_Window_Skill:GetSizeX() / 2 ) - 100 )
		else
			Panel_Window_Skill:SetPosX( ( screenSizeX / 2 ) - ( Panel_Window_Skill:GetSizeX() / 2 ) )
		end
		Panel_Window_Skill:SetPosY( ( screenSizeY / 2 ) - ( Panel_Window_Skill:GetSizeY() / 2 ) )
		EnableSkillShowFunc()
		Panel_EnableSkill_SetPosition()
		self:OpenLearnAni1()
		self:OpenLearnAni2()
	end
	HandleMLUp_SkillWindow_UpdateData( self.combatTabIndex, true )

	local combatCheck = self.radioButtons[self.combatTabIndex]:IsCheck()
	if combatCheck then
		self.radioButtons[self.combatTabIndex]:SetCheck( true )
		self.radioButtons[self.awakenTabIndex]:SetCheck( false )
		HandleMLUp_SkillWindow_UpdateData( self.combatTabIndex )
	else
		self.radioButtons[self.combatTabIndex]:SetCheck( false )
		self.radioButtons[self.awakenTabIndex]:SetCheck( true )
		HandleMLUp_SkillWindow_UpdateData( self.awakenTabIndex )
	end
	FGlobal_SetUrl_Tooltip_SkillForLearning()
end

function HandleMLUp_SkillWindow_Close( isManualClick )
	if Panel_Window_Skill:IsShow() then
		PaGlobal_Skill.isPartsSkillReset = false

		local self = PaGlobal_Skill
		self.lastLearnMode = true
		self.saved_isLearnMode = true
		Panel_SkillTooltip_Hide()
		UIMain_SkillPointUpdateRemove()
		Panel_Window_Skill:SetShow(false, true)
		EnableSkillShowFunc()
		Panel_Scroll:SetShow(false, false)
		
		if ( Panel_EnableSkill:IsShow() ) then
			EnableSkillShowFunc()
		end
	end
	
	for _, value in pairs( PaGlobal_Skill.skillNoSlot ) do
		value.icon:EraseAllEffect()
	end
	
	HelpMessageQuestion_Out()		-- 물음표 버튼 툴팁 끄기
	local vScroll = PaGlobal_Skill.frames[0]:GetVScroll()
	PaGlobal_Skill.scrollPos = vScroll:GetControlPos()
	
	FGlobal_ResetUrl_Tooltip_SkillForLearning()
end

function HandleMOver_SkillWindow_ToolTipHide( skillNo, SlotType )
	if ( PaGlobal_Skill.skillNoCache == skillNo ) and ( PaGlobal_Skill.slotTypeCache == SlotType ) then
		PaGlobal_Skill.tooltipcacheCount = PaGlobal_Skill.tooltipcacheCount - 1
	else
		PaGlobal_Skill.tooltipcacheCount = 0
	end

	if ( PaGlobal_Skill.tooltipcacheCount <= 0 ) then
		Panel_SkillTooltip_Hide()
	end
end

function HandleMOver_SkillWindow_ToolTipShow( skillNo, isShowNextLevel, SlotType )
	if ( PaGlobal_Skill.skillNoCache == skillNo ) and ( PaGlobal_Skill.slotTypeCache == SlotType ) then
		PaGlobal_Skill.tooltipcacheCount = PaGlobal_Skill.tooltipcacheCount + 1
	else
		PaGlobal_Skill.skillNoCache = skillNo
		PaGlobal_Skill.slotTypeCache = SlotType
		PaGlobal_Skill.tooltipcacheCount = 1
	end
	Panel_SkillTooltip_Show(skillNo, false, SlotType)
	PaGlobal_Skill.skillNoSlot[skillNo].icon:EraseAllEffect()
	
	if ("SkillBoxBottom" == SlotType) then
		local selectedSlot = UI.getChildControl ( PaGlobal_Skill.frames[0]:GetFrameContent(), 'StaticSkill_' .. skillNo )

		PaGlobal_Skill:Skill_WindowPosSet( selectedSlot:GetPosY() )
	end
end

function HandleMLUp_SkillWindow_LearnButtonClick( skillNo )
	local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	if (nil == skillTypeStaticWrapper) then
		return
	end
	local skillLevelInfo = getSkillLevelInfo( skillNo )
	if ( nil == skillLevelInfo ) then
		return
	end
	if ( false == skillLevelInfo._learnable ) then
		return
	end

	local DolearnSkill = function()
		PaGlobal_Skill:SkillWindow_LearnButtonClick( skillNo )
	end

	local skillType = skillTypeStaticWrapper:requiredEquipType()
	if 55 == skillType then -- 스킬 필요 장비가 수리검이면
		local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_SKILLTYPE_MEMO1")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = DolearnSkill, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
	elseif 56 == skillType then -- 스킬 필요 장비가 표창이면
		local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_SKILLTYPE_MEMO2")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = DolearnSkill, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
	else
		DolearnSkill()
	end
end

function HandleMLUp_SkillWindow_ClearButtonClick( skillNo )
	ToClient_RequestClearSkillPartly( skillNo )
	PaGlobal_Skill.isPartsSkillReset = false
end

function HandleMLUp_SkillWindow_StartDrag( skillNo )
	if Defines.UIMode.eUIMode_NpcDialog == GetUIMode() then
		return
	end
	local skillLevelInfo = getSkillLevelInfo( skillNo )
	local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
	if (nil ~= skillLevelInfo) and (nil ~= skillTypeStaticWrapper) then
		DragManager:setDragInfo(Panel_Window_Skill, nil, skillLevelInfo._skillKey:get(), "Icon/" .. skillTypeStaticWrapper:getIconPath(), Skill_GroundClick, nil )
	end
end

function HandleMScroll_SkillWindow_ScrollEvent(isShow)
	local vScroll = PaGlobal_Skill.frames[0]:GetVScroll()
	if isShow then
		-- UIScrollButton.ScrollButtonEvent(true, Panel_Window_Skill, PaGlobal_Skill.frames[0],  vScroll)
	else
		UIScrollButton.ScrollButtonEvent(false, Panel_Window_Skill, PaGlobal_Skill.frames[0], vScroll)
	end
end

function Skill_GroundClick( whereType, skillKey )
	if isUseNewQuickSlot() then
		FGlobal_SetNewQuickSlot_BySkillGroundClick( skillKey )
	end
end

function Skill_ClearSkill_ConfirmFromMessageBox()
	skillWindow_ClearSkill();
	
	if Panel_Window_Skill:IsShow() then
		Panel_Window_Skill:SetShow(false)
		Panel_EnableSkill:SetShow(false)
	end
end

function Skill_RegistEventHandler()
	local vScroll = PaGlobal_Skill.frames[0]:GetVScroll()
	vScroll:addInputEvent("Mouse_LDown", 							"HandleMScroll_SkillWindow_ScrollEvent(true)" )
	PaGlobal_Skill.buttonClose:addInputEvent( "Mouse_LUp", 			"HandleMLUp_SkillWindow_Close( true )" )
	PaGlobal_Skill._buttonQuestion:addInputEvent( "Mouse_LUp", 		"Panel_WebHelper_ShowToggle( \"PanelWindowSkill\" )" )						-- 물음표 좌클릭
	PaGlobal_Skill._buttonQuestion:addInputEvent( "Mouse_On", 		"HelpMessageQuestion_Show( \"PanelWindowSkill\", \"true\")" )				-- 물음표 마우스오버
	PaGlobal_Skill._buttonQuestion:addInputEvent( "Mouse_Out", 		"HelpMessageQuestion_Show( \"PanelWindowSkill\", \"false\")" )				-- 물음표 마우스오버
	PaGlobal_Skill.frames[0]:addInputEvent("Mouse_UpScroll", 		"HandleMScroll_SkillWindow_ScrollEvent(true)")
	PaGlobal_Skill.frames[0]:addInputEvent("Mouse_DownScroll",		"HandleMScroll_SkillWindow_ScrollEvent(true)")
	PaGlobal_Skill.frames[0]:addInputEvent("Mouse_On", 				"HandleMScroll_SkillWindow_ScrollEvent(true)")
	PaGlobal_Skill.frames[0]:addInputEvent("Mouse_Out", 			"HandleMScroll_SkillWindow_ScrollEvent(false)")	
	PaGlobal_Skill._btn_MovieToolTip:addInputEvent( "Mouse_LUp", 	"Panel_Window_SkillGuide_ShowToggle()" )
	PaGlobal_Skill._btn_MovieToolTip2:addInputEvent( "Mouse_LUp", 	"Panel_Window_SkillGuide_ShowToggle()" )
	
	PaGlobal_Skill.radioButtons[PaGlobal_Skill.combatTabIndex]:addInputEvent( "Mouse_LUp", "HandleMLUp_SkillWindow_UpdateData(" .. PaGlobal_Skill.combatTabIndex .. ")" )
	PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:addInputEvent( "Mouse_LUp", "HandleMLUp_SkillWindow_UpdateData(" .. PaGlobal_Skill.awakenTabIndex .. ")" )

	Panel_Window_Skill:RegisterShowEventFunc( true, 'Skill_ShowAni()' )
	Panel_Window_Skill:RegisterShowEventFunc( false, 'Skill_HideAni()' )
end

function Skill_RegistMessageHandler()
	registerEvent("FromClient_luaLoadComplete",			"LoadComplete_SkillWindow_Initialize")
	registerEvent("EventSkillWindowInit",				"SkillEvent_SkillWindow_ControlInitialize")
	registerEvent("EventlearnedSkill",					"SkillEvent_SkillWindow_LearnQuest")
	registerEvent("EventSkillWindowClearSkill",			"SkillEvent_SkillWindow_ClearSkill")
	registerEvent("FromClient_ClearSkillsByPoint",		"SkillEvent_SkillWindow_ClearSkillsByPoint")
	
	registerEvent("EventSkillWindowUpdate",				"HandleMLUp_SkillWindow_UpdateData")
	registerEvent("EventSkillWindowShowForLearn",		"HandleMLUp_SkillWindow_OpenForLearn")
	registerEvent("FromClient_SkillWindowClose",		"HandleMLUp_SkillWindow_Close")	
end

Skill_RegistMessageHandler()
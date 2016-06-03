local UI_classType = CppEnums.ClassType
local IM = CppEnums.EProcessorInputMode
runLua("UI_Data/Script/Tutorial/KeyTutorial.lua")

-----------------------------------
-- function startTutorial()
	-- KeyTutorial:Start()
-- end

isClearedQuest = false

---------------------------------------------------------------------
---------------------------------------------------------------------
registerEvent("executeLuaFunc", "executeLuaFunc")
local moveTutorialFisrtCall = true
local findWay_tutorialFirstCall = true
local openInven_tutorialFirstCall = true
local callBlackSpiritCheck = false
local callSpiritTutorialCheck = false
local isFirstSummonBoss = false
function executeLuaFunc(funcText)
	local classType = getSelfPlayer():getClassType()
	
	if isIntroMoviePlaying then
		return
	end
	
	local charLevel = getSelfPlayer():get():getLevel()
	
	-- 기본 이동 튜토리얼
		-- _PA_LOG("LUA", tostring(funcText))
	if funcText == "move_tutorial1" or funcText == "move_tutorial2" then
		if ( moveTutorialFisrtCall ) then
			moveTutorialFisrtCall = false
			if check_ShowWindow() then
				close_WindowPanelList()
			else
				FGlobal_HideDialog()--Panel_hideDialog(true)
			end
	
			getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP1")
			Panel_WelcomeToTheWorld_Start()
			Panel_NewQuest_Alarm:SetShow( false )
		end
	-- 기본 공격 튜토리얼
	elseif funcText == "attack_tutorial" then
		if 10 <= charLevel then
			FGlobal_MiniGame_Tutorial()
			Panel_MainStatus_User_Bar:SetShow( true )
			Panel_SelfPlayerExpGage:SetShow( true )
			Panel_Chat0:SetShow( true )
			Panel_QuickSlot:SetShow( true )
			
			--Panel_Radar:SetShow( true )
			--Panel_RadarRealLine.panel:SetShow( true )
			FGlobal_Panel_Radar_Show( true )
			FGlobal_Panel_RadarRealLine_Show( true )
			
			Panel_SkillCommand:SetShow( true )
			Panel_TimeBar:SetShow( true )
			return
		end
		-- getSelfPlayer():setActionChart("WAIT")
		Panel_Tutorial_Battle_Start()
		-- Panel_MovieTheater_LowLevel_WindowClose()
		
		if nil ~= getSelfPlayer() then
			if CppEnums.ClassType.ClassType_Sorcerer == getSelfPlayer():getClassType() then		 -- 소서러만 어둠의 조각 카운트 UI를 켜줌
				Panel_ClassResource:SetShow( true  )
			else
				Panel_ClassResource:SetShow( false )
			end
		end
		
	-- 위치 찾기 이펙트처리
	elseif funcText == "findWay_tutorial" then
		if 10 <= charLevel then
			return
		end
		-- 채팅창
		local chattingPanelCount = ToClient_getChattingPanelCount()
		for panelIndex = 0, chattingPanelCount - 1, 1 do
			local chatPanel		= ToClient_getChattingPanel( panelIndex )
			if ( chatPanel:isOpen() ) then
				local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
				chatPanelUI:SetShow(false)
			end
		end		
		Panel_Chat0:SetShow( false )
		isClearedQuest = true
		
		-- if ( findWay_tutorialFirstCall ) then
			if check_ShowWindow() then
				close_WindowPanelList()
			else
				FGlobal_HideDialog()	--Panel_hideDialog(true)
			end
			Panel_Tutorial_NaviCtrl_Start()
			-- Panel_LowLevelGuide_MoviePlayCheck_Func()
		-- end
		
	-- 인벤토리 열기 이펙트처리
	elseif funcText == "openInventory_tutorial" then
		if 10 <= charLevel then
			return
		end
	-- 채팅창
		local chattingPanelCount = ToClient_getChattingPanelCount()
		for panelIndex = 0, chattingPanelCount - 1, 1 do
			local chatPanel		= ToClient_getChattingPanel( panelIndex )
			if ( chatPanel:isOpen() ) then
				local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
				chatPanelUI:SetShow(false)
			end
		end		
		Panel_Chat0:SetShow( false )
		-- if ( openInven_tutorialFirstCall ) then
			-- openInven_tutorialFirstCall = false
			
			if check_ShowWindow() then
				close_WindowPanelList()
			else
				FGlobal_HideDialog()--Panel_hideDialog(true)
			end
			
			Panel_MovieTheater_LowLevel_WindowClose()
			Tutorial_InventoryOpen()
			Panel_Tutorial_OpenInventory_Start()
		-- end

	elseif funcText == "closeDialog" then
		-- _PA_LOG ("LUA", "close Dialogue" )
		close_WindowPanelList()
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		
	elseif funcText == "PVP_Notice" then
		close_WindowPanelList()
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		local	messageBoxMemo	= PAGetString( Defines.StringSheet_GAME, "LUA_NOWYOUCANKILLANYONE" )	-- 이제부터 PVP가 가능합니다. 화면 중앙 하단에 있는 칼과 방패 아이콘을 누르면 이제부터 PVP가 가능합니다. 다른 사람을 죽이면 성향이 떨어져 불이익을 받을 수 있습니다.
		local	messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "LUA_WARNING" ), content = messageBoxMemo, functionYes = pvpMode_changedMode, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
	
	elseif funcText == "manufacture" then
		Panel_WebHelper_ShowToggle( "PanelManufacture" )

	elseif funcText == "gathering" then
		Panel_WebHelper_ShowToggle( "Gathering" )

	elseif funcText == "trade" then
		Panel_WebHelper_ShowToggle( "PanelTradeMarketGraph" )

	elseif funcText == "node" then
		Panel_WebHelper_ShowToggle( "NodeMenu" )

	elseif funcText == "housing" then
		Panel_WebHelper_ShowToggle( "PanelHouseControl" )

	elseif funcText == "tent" then
		Panel_WebHelper_ShowToggle( "PanelWindowTent" )

	elseif funcText == "alchemy" then
		Panel_WebHelper_ShowToggle( "PanelAlchemy" )

	elseif funcText == "cook" then
		Panel_WebHelper_ShowToggle( "PanelCook" )

	elseif funcText == "pet" then
		Panel_WebHelper_ShowToggle( "Pet" )

	elseif funcText == "servant" then
		Panel_WebHelper_ShowToggle( "PanelServantinfo" )
	
	elseif funcText == "stable" then
		Panel_WebHelper_ShowToggle( "PanelWindowStableShop" )

	elseif funcText == "selectQuest" then
		FGlobal_HideDialog()
		FGlobal_FirstLogin_InGameOpen()

	elseif funcText == "findWayMovieGuide" then
		-- 채팅창
		local chattingPanelCount = ToClient_getChattingPanelCount()
		for panelIndex = 0, chattingPanelCount - 1, 1 do
			local chatPanel		= ToClient_getChattingPanel( panelIndex )
			if ( chatPanel:isOpen() ) then
				local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
				chatPanelUI:SetShow(false)
			end
		end	
		Panel_Chat0:SetShow( false )
		FGlobal_Panel_LowLevelGuide_MovePlay_FindWay()
		
	elseif funcText == "findTargetMovieGuide" then
		-- 채팅창
		local chattingPanelCount = ToClient_getChattingPanelCount()
		for panelIndex = 0, chattingPanelCount - 1, 1 do
			local chatPanel		= ToClient_getChattingPanel( panelIndex )
			if ( chatPanel:isOpen() ) then
				local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
				chatPanelUI:SetShow(false)
			end
		end		
		Panel_Chat0:SetShow( false )
		FGlobal_Panel_LowLevelGuide_MovePlay_FindTarget()
		
		-- Panel_Radar:SetShow( true )								-- 레이더 오픈
		FGlobal_Panel_Radar_Show_AddEffect()
		--Panel_RadarRealLine.panel:SetShow( true )
		FGlobal_Panel_RadarRealLine_Show( true )
		
		Panel_TimeBar:SetShow( true )
		Panel_SkillCommand:SetShow( false )
		
	elseif funcText == "learnSkillMovieGuide" then
		FGlobal_Panel_LowLevelGuide_MovePlay_LearnSkill()
		FGlobal_FirstLearnSkill_WindowShow()					-- 첫 스킬 퀘스트 받으면 스킬창 오픈
		Panel_SkillCommand:SetShow( false )
		
	elseif funcText == "acceptQuestMovieGuide" then
		FGlobal_Panel_LowLevelGuide_MovePlay_AcceptQuest()
		Panel_SkillCommand:SetShow( false )

	elseif funcText == "callBlackSpiritMovieGuide" then			-- 흑정령 소환
		FGlobal_Panel_LowLevelGuide_MovePlay_BlackSpirit()
		Panel_SkillCommand:SetShow( false )
	
	elseif funcText == "callActionGuide" then					-- 족제비 지식 확인 퀘
		Panel_SkillCommand:SetShow( false )						-- 액션 가이드 오픈
		FGlobal_Panel_LowLevelGuide_MovePlay_Battle( getSelfPlayer():getClassType() )

	elseif funcText == "callSkilSlot" then						-- 여우 퀘
		callBlackSpiritCheck = true
		UiOpen_TutorialClear()
		FGlobal_Panel_LowLevelGuide_MovePlay_Battle( getSelfPlayer():getClassType() )
		-- FGlobal_Tutorial_CallSpirit()
	elseif funcText == "callSpirit" then						-- 족제비 지식 확인퀘 컴플리트 시
		FGlobal_Tutorial_CallSpirit()
	
	elseif funcText == "summonBoss1" then						-- 보스 소환퀘를 갖고, 소환 영역에 들어가면
		FGlobal_BossSummon_Alert( 0 )
		isFirstSummonBoss = true
		
	elseif funcText == "summonBoss2" then						-- 보스 소환퀘를 갖고, 소환 영역에 들어가면
		FGlobal_BossSummon_Alert( 1 )
		isFirstSummonBoss = true
		
	elseif funcText == "arousal_attack_tutorial" then
		FGlobal_Tutorial_Close()
		FGlobal_CharacterSkill_Tutorial()
	
	elseif funcText == "baseSkill_tutorial" then
		FGlobal_BaseSkill_Tutorial()
	
	end

end

function isFirstSummonTutorial()
	return isFirstSummonBoss
end

function FGlobal_CallBlackSpiritCheck()						-- 흑정령 퀘 체크
	return callBlackSpiritCheck
end

function FGlobal_UiRestoreInTutorial()						-- 아직 덜 켜진 UI를 모두 복원

	Panel_MyHouseNavi:SetShow( true )
	Panel_GameTips:SetShow( true )
	Panel_GameTipMask:SetShow( true )
	Panel_SkillCommand:SetShow( true )
	FGlobal_QuickSlot_Show()
	
	local chattingPanelCount = ToClient_getChattingPanelCount()
	for panelIndex = 0, chattingPanelCount - 1, 1 do
		local chatPanel		= ToClient_getChattingPanel( panelIndex )
		if ( chatPanel:isOpen() ) then
			local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
			chatPanelUI:SetShow(true)
		end
	end
	FromClient_CompleteBenefitReward()			-- 특별 선물 알림 체크
	FromClient_CompleteChallengeReward()		-- 도전과제 보상 알림을 체크한다.
	-- check_CashShop_PossibleBuyEventItem()		-- 새 신상이 있으면 켠다.
	
	callBlackSpiritCheck = false
end

-- 7레벨이 되면 튜토리얼 진행여부에 상관 없이 모든 ui를 오픈해준다.
local isDialogOpen = false
function UiOpen_All()
	if Panel_Npc_Dialog:GetShow() then
		isDialogOpen = true
		return
	end
	if ( 7 == getSelfPlayer():get():getLevel()) then			-- 7레벨이 되면 모든 UI 오픈
		Panel_CheckedQuest:SetShow( true )
		Panel_MainStatus_User_Bar:SetShow( true )
		Panel_SelfPlayerExpGage:SetShow( true )
		
		--Panel_Radar:SetShow( true )
		--Panel_RadarRealLine.panel:SetShow( true )
		FGlobal_Panel_Radar_Show( true )
		FGlobal_Panel_RadarRealLine_Show( true )
		
		Panel_TimeBar:SetShow( true )
		Panel_UIMain:SetShow( true )
		Panel_MyHouseNavi:SetShow( true )
		Panel_GameTips:SetShow( true )
		Panel_GameTipMask:SetShow( true )
		Panel_SkillCommand:SetShow( true )
		FGlobal_PetControl_CheckUnSealPet()
		Panel_QuickSlot:SetShow( true, true )
		if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) or isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_JAP ) then
			FGlobal_MovieGuideButton_Position()
		end
		
		if isPvpEnable() then	-- PVP버튼 활성 조건을 만족해야 켠다.
			Panel_PvpMode:SetShow( true )
		else
			Panel_PvpMode:SetShow( false )
		end

		if CppEnums.ClassType.ClassType_Sorcerer == getSelfPlayer():getClassType() then -- 소서러만 어둠의 조각 카운트 UI를 켜줌
			Panel_ClassResource:SetShow( true  )
		else
			Panel_ClassResource:SetShow( false )
		end

		-- 채팅창
		local chattingPanelCount = ToClient_getChattingPanelCount()
		for panelIndex = 0, chattingPanelCount - 1, 1 do
			local chatPanel		= ToClient_getChattingPanel( panelIndex )
			if ( chatPanel:isOpen() ) then
				local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
				chatPanelUI:SetShow(true)
			end
		end
		
		-- Panel_NewQuest:SetShow( true )
		Panel_SkillCommand:SetShow( true )
		Panel_MyHouseNavi:SetShow( true )
		-- Panel_NewKnowledge:SetShow( true )
		Panel_GameTips:SetShow( true )
		Panel_GameTipMask:SetShow( true )

		-- 생산 정보 위젝 켜기
		CraftLevInfo_Show()
		PotenGradeInfo_Show()

		FromClient_CompleteBenefitReward()			-- 특별 선물 알림 체크
		FromClient_CompleteChallengeReward()		-- 도전과제 보상 알림을 체크한다.
		-- check_CashShop_PossibleBuyEventItem()		-- 새 신상이 있으면 켠다.
		
		ToClient_SaveUiInfo( true )	-- 위치를 잡고 저장해야 한다.
	end
		
end

function IsDialogOpen()
	return isDialogOpen
end

function Tutorial_UiRestore()
	isDialogOpen = false
end

function UiOpen_TutorialClear()
	Panel_CheckedQuest:SetShow( true )
	Panel_MainStatus_User_Bar:SetShow( true )
	Panel_SelfPlayerExpGage:SetShow( true )
	Panel_UIMain:SetShow( true )
	
	--Panel_Radar:SetShow( true )
	--Panel_RadarRealLine.panel:SetShow( true )	
	FGlobal_Panel_Radar_Show( true )
	FGlobal_Panel_RadarRealLine_Show( true )
	
	Panel_MyHouseNavi:SetShow( true )
	Panel_GameTips:SetShow( true )
	Panel_GameTipMask:SetShow( true )
	Panel_SkillCommand:SetShow( true )
	FGlobal_QuickSlot_Show()
	FGlobal_PetControl_CheckUnSealPet()
	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) or isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_JAP ) then
		FGlobal_MovieGuideButton_Position()
	end

	if isPvpEnable() then	-- PVP버튼 활성 조건을 만족해야 켠다.
		Panel_PvpMode:SetShow( true )
	else
		Panel_PvpMode:SetShow( false )
	end

	if CppEnums.ClassType.ClassType_Sorcerer== classType then -- 소서러만 어둠의 조각 카운트 UI를 켜줌
		Panel_ClassResource:SetShow( true  )
	else
		Panel_ClassResource:SetShow( false )
	end

	-- 채팅창
	local chattingPanelCount = ToClient_getChattingPanelCount()
	for panelIndex = 0, chattingPanelCount - 1, 1 do
		local chatPanel		= ToClient_getChattingPanel( panelIndex )
		if ( chatPanel:isOpen() ) then
			local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
			chatPanelUI:SetShow(true)
		end
	end
	
	-- Panel_NewQuest:SetShow( true )
	Panel_SkillCommand:SetShow( true )
	Panel_TimeBar:SetShow( true )
	Panel_MyHouseNavi:SetShow( true )
	-- Panel_NewKnowledge:SetShow( true )
	Panel_GameTips:SetShow( true )
	Panel_GameTipMask:SetShow( true )

	-- 생산 정보 위젝 켜기
	CraftLevInfo_Show()
	PotenGradeInfo_Show()

	FromClient_CompleteBenefitReward()			-- 특별 선물 알림 체크
	FromClient_CompleteChallengeReward()		-- 도전과제 보상 알림을 체크한다.
	-- check_CashShop_PossibleBuyEventItem()		-- 새 신상이 있으면 켠다.
	
end



registerEvent( "ToClient_SelfPlayerLevelUp", "UiOpen_All" )
---------------------------------------------------------------------

-- TestCode
--MoveTutorial:Start();
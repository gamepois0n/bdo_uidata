local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE

local isClickControlKey = 0		--	controlKey 관련

--  esc 눌렀을 경우 패널이 사라져야 하는 패널을 등록해 주는 부분
local panel_WindowList =
{
	Panel_Window_ServantInfo,
	Panel_PartyOption,			
	Panel_Alchemy,									
	Panel_Window_StableFunction,
	Panel_Window_StableList,			-- 5
	Panel_Window_StableInfo,
	Panel_Window_StableEquipInfo,
	Panel_Window_StableShop,						
	Panel_Window_StableMating,
	Panel_Window_StableRegister,		-- 10
	Panel_Servant_Market_Input,
	Panel_Window_WharfFunction,
	Panel_Window_WharfList,
	Panel_Window_WharfInfo,							
	Panel_Window_WharfRegister,			-- 15
	Panel_Window_Exchange_Number,
	Panel_Win_System,
	Panel_Window_Delivery_Request,
	Panel_Window_Delivery_Information,
	Panel_Window_Delivery_CarriageInformation,	-- 20
	Panel_Window_Guild,
	Panel_Mail_Detail,
	Panel_Mail_Send,
	Panel_CreateClan,
	Panel_IntroMovie,							-- 25
	Panel_Window_Repair,
	Panel_Scroll,
	Panel_SkillAwaken,
	Panel_Popup_MoveItem,
	Panel_LordMenu,								-- 30
	Panel_CarriageInfo,
	Panel_FixEquip,
	Panel_Dialogue_Itemtake,
	Panel_CreateGuild,
	Panel_EnableSkill,							-- 35
	Panel_HelpMessage,
	Panel_WebControl,								
	Panel_Window_Quest_New,							
	Panel_ChatOption,
	Panel_Interaction_HouseRank,				-- 40
	Panel_ColorBalance,								
	Panel_CheckedQuestInfo,
	Panel_ProductNote,
	Panel_Window_Quest_History,
	Panel_Tooltip_Common, 						-- 45
	Panel_ShipInfo,
	Panel_Window_PetListNew,
	Panel_Window_PetInfoNew,
	-- Panel_AgreementGuild,
	Panel_AgreementGuild_Master,				-- 50
	Panel_Housing_FarmInfo_New,
	Panel_Window_ItemMarket,
	Panel_Window_ItemMarket_ItemSet,
	Panel_ClanList,
	Panel_CarveSeal,							-- 55
	Panel_ResetSeal,
	Panel_ClearVested,
	Panel_Window_CharInfo_Status,
	Panel_Chatting_Input,
	Panel_Window_GameTips,						-- 60
	Panel_Window_SkillGuide,
	Panel_MovieTheater_320,
	Panel_MovieTheater_640,
	Panel_MovieTheater_SkillGuide_640,
	Panel_NewKnowledge,							-- 65
	Panel_Menu,
	Panel_QuestInfo,
	Panel_MovieGuide,
	Panel_Window_PetRegister,
	Panel_FishEncyclopedia,						-- 70
	Panel_Tooltip_Item_chattingLinkedItem,
	Panel_Window_ItemMarket_BuyConfirm,
	Panel_Tooltip_SimpleText,
	Panel_Window_DailyStamp,
	Panel_EventNotify,							-- 75
	Panel_EventNotifyContent,
	Panel_Event_100Day,
	Panel_HousingList,
	Panel_LifeRanking,
	Panel_RecommandName,						-- 80
	Panel_Interaction_FriendHouseList,
	Panel_GuildWarInfo,
	Panel_GuildWarScore,
	Panel_KnowledgeManagement,
	Panel_Window_StableMix,						-- 85
	Panel_RecentCook,
	Panel_KeyboardHelp,
	Panel_Window_PetCompose,
	Panel_GuildWebInfo,
	Panel_Guild_Rank,							-- 90
	Panel_TransferLifeExperience,
	Panel_WorkerManager,	
	--Panel_RecentMemory,
	Panel_LinkedHorse_Skill,
	Panel_Window_MaidList,
	Panel_Window_WorkerRandomSelect,			-- 95
	Panel_Worker_Auction,
	Panel_Window_UnknownRandomSelect,
	Panel_NodeWarMenu,
	-- Panel_Maid_ChangeName,
	Panel_RallyRanking,
	Panel_Window_Warehouse,						-- 100
	Panel_Manufacture,
	Panel_EnchantExtraction,
	Panel_TradeMarket_EventInfo,
	Panel_Join,
	Panel_Window_PetMarket,						-- 105
	Panel_Window_PetMarketRegist,
	Panel_Window_GuildStableFunction,
	Panel_Window_GuildStable_List,
	Panel_Window_GuildStable_Info,
	Panel_Window_GuildStableRegister,			-- 110
	Panel_ChangeWeapon,
	Panel_WorkerChangeSkill,
	Panel_GuildServantList,
	Panel_DyePalette,
	Panel_SetShortCut,							-- 115
	Panel_ExitConfirm,
	Panel_ChannelSelect,
	Panel_Party_ItemList,
	Panel_Harvest_WorkManager,
	Panel_HarvestList,							-- 120
	Panel_GuildDuel,
	Panel_Window_PetLookChange,
	Panel_Win_Check,
	Panel_Window_BlackSpiritAdventure,			-- 125
	Panel_Chatting_Filter,
}

local panel_SoundedWindowList =
{
	Panel_Window_Inventory,
	Panel_Equipment,
	Panel_Window_Skill,
	Panel_Window_Enchant,				-- 5
	-- Panel_Looting,
	Panel_Window_ServantInventory,	
	Panel_Window_Warehouse,
	--Panel_Inn,
	Panel_Mail_Main,					-- 9
	Panel_Window_Option,
	Panel_Manufacture,
	Panel_Window_Socket,
	Panel_FriendList,
	Panel_Housing_SettingVendingMachine,-- 14
	Panel_Housing_VendingMachineList,
	Panel_Housing_SettingConsignmentSale,
	Panel_Housing_RegisterConsignmentSale,
	Panel_Housing_ConsignmentSale,
	Panel_SkillAwaken,					-- 19
	Panel_MyVendor_List,
	Panel_Challenge_Reward,
}

local panel_MinigameList =
{
	Panel_Minigame_Gradient,
	Panel_SinGauge,
	Panel_Command,
	Panel_RhythmGame,
	Panel_BattleGauge,
	Panel_FillGauge,
	Panel_MiniGame_Gradient_Y,
	Panel_MiniGame_Timing,
	Panel_MiniGame_Drag,
	Panel_MiniGame_PowerControl,
	Panel_RhythmGame_ForAction,
	Panel_MiniGame_Steal,
	Panel_MiniGame_PowerControl,
	Panel_MiniGame_Jaksal,
	Panel_RhythmGame_Drum,
}

local panel_ExceptionWindowList =
{
	Panel_Npc_Quest_Reward,
}

local _panelCloseAni = UIAni.closeAni

function check_ShowWindow()	
	local panel = nil
	for idx = 1, #panel_WindowList do
		panel = panel_WindowList[idx]

		if (nil == panel) then
			_PA_ASSERT(false, "GlobalUIManager WindowList에서 "..tostring(idx).."번째 Panel이 nil 입니다. 지워주세요")
		else
			if panel:IsShow() then		
				return true
			end
		end
	end
	
	for idx = 1, #panel_SoundedWindowList do
		panel = panel_SoundedWindowList[idx]

		if (nil == panel) then
			_PA_ASSERT(false, "GlobalUIManager SoundedWindowList에서 "..tostring(idx).."번째 Panel이 nil 입니다. 지워주세요")
		else
			if panel:IsShow() then		
				audioPostEvent_SystemUi(01,01)				
				return true
			end
		end
	end
	
	for idx = 1, #panel_ExceptionWindowList do
		panel = panel_ExceptionWindowList[idx]

		if (nil == panel) then
			_PA_ASSERT(false, "GlobalUIManager SoundedWindowList에서 "..tostring(idx).."번째 Panel이 nil 입니다. 지워주세요")
		else
			if panel:IsShow() then		
				audioPostEvent_SystemUi(01,01)				
				return true
			end
		end
	end
	
	return false
end

local Panel_LowLevelGuide_Value_IsCheckMoviePlay = Panel_LowLevelGuide_Value_IsCheckMoviePlay
isComboMovieClosedCount = 0		-- 스킬 연계 가이드 영상 전용 조건
function close_WindowPanelList()
	------------------------------------------------------------------
	-- 스킬 연계 가이드 영상 전용 조건들!!! 		
	-- !! 문제될 시 채효석 에게 문의해주세요 !! ※※※ 절대 지우면 안됨!! ※※※
	if ( Panel_MovieTheater_320:IsShow() == false ) then
		value_Panel_MovieTheater_320_IsCheckedShow = false
	end
	
	if ( value_Panel_MovieTheater_320_IsCheckedShow == true ) then
		isComboMovieClosedCount = isComboMovieClosedCount + 1
		if ( isComboMovieClosedCount >= 3 ) then
			Panel_MovieTheater320_MessageBox()
			Panel_MovieTheater_MessageBox:SetShow( true )
		else
			Panel_MovieTheater320_ResetMessageBox()
		end
	end
	------------------------------------------------------------------
	
	Panel_Tooltip_Item_hideTooltip()
	Panel_SkillTooltip_Hide()

	if Panel_IngameCashShop_GoodsTooltip:IsShow() then
		Panel_IngameCashShop_GoodsTooltip:SetShow( false )
	end

	Panel_Knowledge_Hide()

	if Panel_Window_Warehouse:GetShow() then
		Warehouse_Close()
	end
	
	if Panel_Window_Skill:IsShow() then
		-- if isFlushedUI() and getSelfPlayer():get():getLevel() < 6 then
		-- 	Proc_ShowMessage_Ack( "튜토리얼 진행 중에는 스킬 창을 임의로 닫을 수 없습니다." )
		-- 	return
		-- end
		HandleMLUp_SkillWindow_Close();
	end

	if Panel_WorkerChangeSkill:GetShow() then
		FGlobal_workerChangeSkill_Close()
	end

	if Panel_WorkerManager:GetShow() and not Panel_WorldMap:GetShow() then
		workerManager_Close()
		FGlobal_HideWorkerTooltip()
		return
	end

	if Panel_Worker_Auction:GetShow() then
		if Panel_WorkerResist_Auction:GetShow() then
			FGlobal_ResistWorkerToAuction_Close()
			return
		end
		if Panel_WorkerList_Auction:GetShow() then
			MyworkerList_Close()
			return
		end
		WorkerAuction_Close()
	end

	if Panel_Window_Exchange:GetShow() then
		Panel_ExchangePC_BtnClose_Mouse_Click()
		return
	end

	if Panel_TransferLifeExperience:GetShow() then
		FGlobal_TransferLife_Close()
		return
	end

	if Panel_DyePalette:GetShow() then	-- 팔레트는 인벤보다 먼저, 함수로 인벤과 함께 닫아야 한다.
		FGlobal_DyePalette_Close()
	end

	if Panel_SetShortCut:GetShow() then
		FGlobal_NewShortCut_Close()
		return	-- 인벤이 순차적으로 꺼지도록 리턴한다.
	end
	
	if Panel_Window_Inventory:IsShow() then	-- 인벤토리는 닫기 전에 필터를 클리어 해줘야 한다!
		InventoryWindow_Close()
		if Panel_Equipment:GetShow() then
			Equipment_SetShow( false )
		end
	end
	
	if Panel_Window_Exchange_Number:IsShow() then
		Panel_NumberPad_Show( false, Defines.s64_const.s64_0, 0, nil);
	end

	if Panel_Window_Option:IsShow() then
		GameOption_Cancel()
		TooltipSimple_Hide()
	end

	if Panel_CarveSeal:IsShow() then
		FromClient_SealWindowHide()
	end

	if Panel_GuildWebInfo:GetShow() then
		FGlobal_GuildWebInfoClose()
		return
	end

	if Panel_Guild_Rank:GetShow() then
		FGlobal_guildRanking_Close()
		return
	end

	if Panel_ChangeWeapon:GetShow() then
		WeaponChange_Close()
		return
	end
	

	--MessageBox
	messageBox_CloseButtonUp()

	if Panel_Looting:IsShow() == true then
		
	end
	
	if Panel_FriendList:IsShow() then
		FriendList_hide()
	end

	if Panel_KnowledgeManagement:GetShow() then
		FGlobal_KnowledgeClose()
	end

	if Panel_Window_Quest_New:GetShow() then
		Panel_Window_QuestNew_Show( false )
	end

	if Panel_CheckedQuestInfo:GetShow() then
		-- FGlobal_QuestInfoDetail_ResetInfo()
		FGlobal_QuestInfoDetail_Close()
	end

	if Panel_IntroMovie:IsShow() then
		CloseIntroMovie()
		return true
	end
	
	if Panel_Window_Delivery_Request:GetShow() then
		DeliveryRequestWindow_Close()
	end

	if Panel_Window_Guild:GetShow() then
		if Panel_AgreementGuild_Master:GetShow() then
			agreementGuild_Master_Close()
			return
		elseif Panel_GuildIncentive:GetShow() then
			FGlobal_GuildIncentive_Close()
			return
		elseif Panel_GuildDuel:GetShow() then
			FGlobal_GuildDuel_Close()
			return
		end
		audioPostEvent_SystemUi(01,31)
		GuildManager:Hide()
	end

	if Panel_AgreementGuild:GetShow() then
		if ( AllowChangeInputMode() ) then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode) 
		else
			SetFocusChatting()
		end
		audioPostEvent_SystemUi(01,31)
		FGlobal_AgreementGuild_Close()
		return
	end

	if Panel_Window_GameTips:IsShow() then
		FGlobal_GameTipsHide()
	end

	if Panel_Window_PetInfoNew:IsShow() then
		TooltipSimple_Hide()
	end
	
	if Panel_ProductNote:IsShow() then
		Panel_ProductNote_ShowToggle()
	end
	
	if Panel_WebControl:IsShow() then
		Panel_WebHelper_ShowToggle()
	end
	
	if Panel_KeyboardHelp:IsShow() then
		FGlobal_KeyboardHelpShow()
	end

	if Panel_Event_100Day:IsShow() then
		FGlobal_Event_100Day_Close()
		return
	end
	
	if Panel_WorkerManager:GetShow() then
		workerManager_Close()
		if Panel_Worker_Tooltip:GetShow() then
			FGlobal_HideWorkerTooltip()
		end
	end

	if Panel_ChangeItem:GetShow() then
		ItemChange_Close()
	end
	
	if Panel_MovieGuide:IsShow() then
		Panel_MovieGuide_ShowToggle()
	end

	if Panel_Window_ItemMarket_RegistItem:GetShow() then
		FGlobal_ItemMarketRegistItem_Close()
	end

	if Panel_AlchemyStone:GetShow() then
		FGlobal_AlchemyStone_Close()
	end

	if Panel_AlchemyFigureHead:GetShow() then
		FGlobal_AlchemyFigureHead_Close()
	end
	
	if Panel_MovieTheater_320:IsShow() then
		Panel_MovieTheater320_JustClose()
	end
	if Panel_Window_ItemMarket:GetShow() then
		FGolbal_ItemMarket_Close()
	end
	
	for _,loopPanel in ipairs(panel_WindowList) do		
		loopPanel:SetShow(false, false)
		--_panelCloseAni(loopPanel)
	end

	for _,loopPanel in ipairs(panel_SoundedWindowList) do
		loopPanel:SetShow(false, false)
		--_panelCloseAni(loopPanel)
	end

	if not Panel_Npc_Dialog:GetShow() then	
		for _,loopPanel in ipairs(panel_ExceptionWindowList) do
			loopPanel:SetShow(false, false)
		end
	end
	
	AcquireDirecteReShowUpdate()
	
	if( isFocusInChatting() ) then
		Panel_Chatting_Input:SetShow(true, false );
	end
	
	if ( Panel_LowLevelGuide_Value_IsCheckMoviePlay == 1 ) then
		FGlobal_Panel_LowLevelGuide_MovePlay_FindWay()
	elseif ( Panel_LowLevelGuide_Value_IsCheckMoviePlay == 2 ) then
		FGlobal_Panel_LowLevelGuide_MovePlay_LearnSkill()
	elseif ( Panel_LowLevelGuide_Value_IsCheckMoviePlay == 3 ) then
		FGlobal_Panel_LowLevelGuide_MovePlay_FindTarget()
	elseif ( Panel_LowLevelGuide_Value_IsCheckMoviePlay == 4 ) then
		FGlobal_Panel_LowLevelGuide_MovePlay_AcceptQuest()
	elseif ( Panel_LowLevelGuide_Value_IsCheckMoviePlay == 99 ) then
		FGlobal_Panel_LowLevelGuide_MovePlay_BlackSpirit()
	end
end

function close_WindowMinigamePanelList()
	for _,loopPanel in ipairs(panel_MinigameList) do
		loopPanel:SetShow(false, false)
	end
end

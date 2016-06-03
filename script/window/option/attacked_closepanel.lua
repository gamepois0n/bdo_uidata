function FromClient_CancelByAttacked()
	if not AllowChangeInputMode() then
		return
	end

	if	( Panel_Window_StableFunction:GetShow() )	then
		StableFunction_Close()
	end

	if	( Panel_Window_WharfFunction:GetShow() )	then
		WharfFunction_Close()
	end
	
	ToClient_PopBlackSpiritFlush()

	if Panel_Npc_Trade_Market:IsShow() then
		closeNpcTrade_Basket()
	end
	
	if Panel_Win_System:GetShow() then
		MessageBox_Empty_function()
	end
	
	if Panel_Window_ItemMarket_Function:GetShow() then
		FGolbal_ItemMarket_Function_Close()
	end
	if Panel_Window_ItemMarket_ItemSet:GetShow() then
		FGlobal_ItemMarketItemSet_Close()
	end
	if Panel_Window_ItemMarket_RegistItem:GetShow() then
		FGlobal_ItemMarketRegistItem_Close()
	end
	if Panel_Window_ItemMarket:GetShow() then
		FGolbal_ItemMarket_Close()
	end
	if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
		FGlobal_ItemMarket_BuyConfirm_Close()
	end
	if Panel_Window_ItemMarket:GetShow() then
		FGolbal_ItemMarket_Close()
	end
	if Panel_Npc_Dialog:IsShow() then
		FGlobal_HideDialog()				--Panel_hideDialog(true)
	end	
	
	-- 포토모드 시 공격당하면 효과음 뿌려줌
	if isPhotoMode() then
		audioPostEvent_SystemUi(08,14)
	end

	local npcKey = dialog_getTalkNpcKey()	-- 대화 중 dialogScene이 있다면 닫아 준다.
	if 0 ~= npcKey then
		-- closeClientChangeScene( npcKey )
		-- UI.restoreFlushedUI()
		-- FGlobal_HideDialog()
		global_setTrading( false )
	end
	
	Panel_Knowledge_Hide()
	FGlobal_PopCloseWorldMap()
	
	close_WindowMinigamePanelList()
	
	-- Panel_Npc_Dialog:SetShow(false)		--  마구간, 선착장, 애완동물로 인해 열린 대화창을 닫는다. >> 마구간에서 잘 닫히는 거 확인해서 막아둠! - 문종

	if Panel_GameExit:GetShow()  then
		GameExitShowToggle( true )
		FGlobal_ChannelSelect_Hide()
		Panel_GameExit_sendGameDelayExitCancel()
	end
	
	InGameShop_OuterEventByAttacked()
	IngameCustomize_Hide()

	HandleClicked_HouseInstallation_Exit_ByAttacked()
	
	FGlobal_UiSet_Close()	-- 맞으면 UI세팅모드 끈다.

	FGlobal_AgreementGuild_Close()	-- 맞으면 길드 초대를 끈다.

	FGlobal_Gacha_Roulette_Close()

	if Panel_PcRoomNotify:GetShow() then
		PcRoomNotify_Close()	-- PC방 닫힘.
	end

	if Panel_EventNotify:GetShow() then
		EventNotify_Close()	-- 이벤트 공지창.
	end

	if Panel_SetShortCut:GetShow() then	-- 단축키 설정창
		FGlobal_NewShortCut_Close()
	end

	if Panel_Dye_New:GetShow() then
		FGlobal_Panel_DyeNew_Hide()
	end

	if Panel_ChatOption:GetShow() then
		ChattingOption_Close()
	end

	if Panel_RecommandName:GetShow() then
		FGlobal_SendMailForHelpClose()
	end

	if Panel_Chatting_Filter:GetShow() then
		FGlobal_ChattingFilterList_Close()
	end

	-- 친구 메신저 채팅창 포커스 때문에 공격을 맞으면 focus를 게임모드로 바꿔준다.
	FriendMessanger_KillFocusEdit()

	if Panel_LocalWarInfo:GetShow() then
		FGlobal_LocalWarInfo_Close()
	end

	-- 이 위로 추가하세요
	----------------------------------------------------------------------------------
	if (GameOption_GetHideWindow()) then
		close_WindowPanelList()
	end
end


registerEvent("progressEventCancelByAttacked", "FromClient_CancelByAttacked")

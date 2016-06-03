local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode

local UIMode = Defines.UIMode
local _uiMode = UIMode.eUIMode_Default
local escHandle = false;
local isRunClosePopup = false
local mouseKeyTable = {};

function GlobalKeyBinder_MouseKeyMap( uiInputType )
	mouseKeyTable[uiInputType] = true
end

local GlobalKeyBinder_CheckKeyPressed = function( keyCode )
	return isKeyDown_Once( keyCode )
end

local GlobalKeyBinder_CheckCustomKeyPressed = function( uiInputType )	
	return (keyCustom_IsDownOnce_Ui( uiInputType ) or mouseKeyTable[uiInputType]) and (not GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_MENU)) and (not isPhotoMode())
end

local GlobalKeyBinder_CheckProgress = function()
	if (Panel_Collect_Bar:GetShow() or Panel_Product_Bar:GetShow() or Panel_Enchant_Bar:GetShow()) then
		return true
	end
	return false
end	

function GlobalKeyBinder_CheckProgress_chk()
	return GlobalKeyBinder_CheckProgress()
end

-- 
local GlobalKeyBinder_Clear = function()
	mouseKeyTable = {};
end

-----------------------------------
-- 게임 모드 전용
-----------------------------------
local _keyBinder_GameMode = function()
	DragManager:clearInfo()
end

-----------------------------------
-- UI 모드 전용
-----------------------------------
local _keyBinder_UIMode = function()
end

-----------------------------------
-- Chatting 모드 전용
-----------------------------------
local _keyBinder_Chatting = function()
	uiEdit = GetFocusEdit()
	
	if ( WaitComment_CheckCurrentUiEdit(uiEdit) ) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
			settingWaitCommentConfirm()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			--settingWaitCommentLaunch(true)
		end
		return true
	elseif (FGlobal_CheckEditBox_IngameCashShop_NewCart(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_EscapeEditBox_IngameCashShop_NewCart(false)
		end
		return true
	elseif (FGlobal_CheckEditBox_PetCompose(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) or GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
			FGlobal_EscapeEditBox_PetCompose(false)
		end
		return true
	-- elseif (FGlobal_CheckEditBox_AgreementGuild(uiEdit)) then
	-- 	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
	-- 		FGlobal_AgreementGuild_Confirm()
	-- 	elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
	-- 		FGlobal_AgreementGuild_Refuse()
	-- 	end
	-- 	return true
	elseif ( NpcNavi_CheckCurrentUiEdit(uiEdit) ) then
		-- Npc Navi 입력창
		-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
		-- 	NpcNavi_OutInputMode(true)
		-- else
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			NpcNavi_OutInputMode(false)
		end		
		return true
	elseif ( ChatInput_CheckCurrentUiEdit(uiEdit) ) then
		-- 채팅 입력창
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
--			if( ToClient_isComposition() ) then
--				return;
--			end
--			
--			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
--			ChatInput_CancelAction()
--			ChatInput_SendMessage()
--			ChatInput_Close()
--			ClearFocusEdit()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_UP ) then
			if( ToClient_isComposition() ) then
				return;
			end
			ChatInput_PressedUp()
		elseif isKeyPressed( VCK.KeyCode_MENU ) then
			ChatInput_CheckReservedKey()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_TAB ) then
			ChatInput_ChangeInputFocus()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			if( ToClient_isComposition() ) then
				return;
			end
			
			ChatInput_CancelAction()
			ChatInput_CancelMessage()
			ChatInput_Close()
			ClearFocusEdit()
			friend_clickAddFriendClose()
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) then
			ChatInput_CheckInstantCommand()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_BACK ) or isKeyPressed( VCK.KeyCode_BACK ) then
			ChatInput_CheckRemoveLinkedItem()
		end
	--elseif ( ChatMacro_CheckCurrentUiEdit(uiEdit) ) then
	--	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_BACK ) then
	--		ChatMacro_CheckRemoveLinkedItem()
	--	end
	--	return true
	elseif (AddFriendInput_CheckCurrentUiEdit(uiEdit)) then
		-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
		-- 	friend_clickAddFriend()
		-- else
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			friend_clickAddFriendClose()
		end
		return true
	elseif (FriendMessanger_CheckCurrentUiEdit(uiEdit)) then
		-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
		-- 	friend_sendMessageByKey()
		-- else
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			friend_killFocusMessangerByKey()
		end
		return true
	elseif (FGlobal_CheckCurrentVendingMachineUiEdit(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_VendingMachineClearFocusEdit(uiEdit)
		end
		return true
	elseif (FGlobal_CheckCurrentConsignmentSaleUiEdit(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_ConsignmentSaleClearFocusEdit()
		end
		return true
	elseif (FGlobal_CheckGuildLetsWarUiEdit(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_GuildLetsWarClearFocusEdit()
		end
		return true
	elseif (FGlobal_CheckGuildNoticeUiEdit(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_GuildNoticeClearFocusEdit()
		end
		return true
	elseif (FGlobal_CheckGuildIntroduceUiEdit(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_GuildIntroduceClearFocusEdit()
		end
		return true
	elseif (FGlobal_CheckMyIntroduceUiEdit(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_MyIntroduceClearFocusEdit()
		end
		return true
	elseif (FGlobal_ChattingFilter_UiEdit(uiEdit)) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_ChattingFilter_ClearFocusEdit()
		end
		return true

	elseif (Panel_Knowledge_CheckCurrentUiEdit(uiEdit)) then
		-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
		-- 	Panel_Knowledge_OutInputMode(true)
		-- else
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			Panel_Knowledge_OutInputMode(false)
		end
		return true
	
	end

	return false
end

-----------------------------------
-- Mail 모드 전용
-----------------------------------
local _keyBinder_Mail = function()
	if	GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN )	then
		MailSend_PressedDown()
	elseif	GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_UP )	then
		MailSend_PressedUp()
	elseif	GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE )	then
		MailSend_Close()
	end
end

-----------------------------------
-- UiModeNotInput 모드 전용
-----------------------------------
local _keyBinder_UiModeNotInput = function()
	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		Alchemy_Close()
	end
end


-----------------------------------
-- 이하는 컨텐츠 관련 별도 Key 처리 로직
-----------------------------------

local fastPinDelta = 0.0;

local _keyBinder_UIMode_CommonWindow = function( deltaTime )
	if true == FGlobal_GetFirstTutorialState() then
		return
	end
    
--지식 (H)
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_H ) then
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_MentalKnowledge ) then
		Panel_Knowledge_Show()
		return
	end
	
	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_OEM_3 ) then
		local isGuild = (false == isKeyPressed( VCK.KeyCode_SHIFT ));
		local targetPosition = crossHair_GetTargetPosition();
		if( true == ToClient_IsViewSelfPlayer( targetPosition ) ) then
			if ( fastPinDelta < 0.5 ) then
				ToClient_RequestSendPositionGuide(isGuild, true, false, targetPosition );
				fastPinDelta = 10.0;
			else
				ToClient_RequestSendPositionGuide(isGuild, false, false, targetPosition );
				fastPinDelta = 0.0;
			end
		end
	end
	fastPinDelta = fastPinDelta + deltaTime;
	if (fastPinDelta > 10.0) then
		fastPinDelta = 10.0;
	end
	

	if isKeyPressed( VCK.KeyCode_SHIFT ) and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_OEM_7 ) then	-- " 로 답장 귓말 보내기.
		if FGlobal_ChatInput_CheckReply() then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
			ChatInput_Show()
			ChatInput_CheckInstantCommand()
			FGlobal_ChatInput_Reply( true )
			ChatInput_ChangeChatType_Immediately( 4 )
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHATTINGINPUT_NONEREPLYTARGET") )	-- 답장을 보낼 대상이 없습니다.
		end
		return
	end
	
	if Panel_Interaction:IsShow() then
		local buttonCount = FGlobal_InteractionButtonCount()
		if keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_Interaction ) then
			local camBlur 				= getCameraBlur();
			local interactableActor		= interaction_getInteractable()
			if (interactableActor ~= nil) and ((not interactableActor:get():isPlayer()) or (interactableActor:get():isSelfPlayer())) and camBlur <= 0.0 then
				local interactionType = interactableActor:getSettedFirstInteractionType()
				Interaction_ButtonPushed( interactionType )
				DragManager:clearInfo()				-- 드래그후 대화를 하거나 하면 아이콘이 남는 문제 해결을 위해
				GlobalKeyBinder_Clear()
				return
			end

		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F1 ) then
			if 2 <= buttonCount then
				FGlobal_InteractionButtonActionRun( 1 )
				DragManager:clearInfo()				-- 드래그후 대화를 하거나 하면 아이콘이 남는 문제 해결을 위해
				GlobalKeyBinder_Clear()
				return
			end
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F2 ) then
			if 3 <= buttonCount then
				FGlobal_InteractionButtonActionRun( 2 )
				DragManager:clearInfo()				-- 드래그후 대화를 하거나 하면 아이콘이 남는 문제 해결을 위해
				GlobalKeyBinder_Clear()
				return
			end
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F3 ) then
			if 4 <= buttonCount then
				FGlobal_InteractionButtonActionRun( 3 )
				DragManager:clearInfo()				-- 드래그후 대화를 하거나 하면 아이콘이 남는 문제 해결을 위해
				GlobalKeyBinder_Clear()
				return
			end
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F4 ) then
			if 5 <= buttonCount then
				FGlobal_InteractionButtonActionRun( 4 )
				DragManager:clearInfo()				-- 드래그후 대화를 하거나 하면 아이콘이 남는 문제 해결을 위해
				GlobalKeyBinder_Clear()
				return
			end
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F5 ) then
			if 6 <= buttonCount then
				FGlobal_InteractionButtonActionRun( 5 )
				DragManager:clearInfo()				-- 드래그후 대화를 하거나 하면 아이콘이 남는 문제 해결을 위해
				GlobalKeyBinder_Clear()
				return
			end
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F6 ) then
			if 7 <= buttonCount then
				FGlobal_InteractionButtonActionRun( 6 )
				DragManager:clearInfo()				-- 드래그후 대화를 하거나 하면 아이콘이 남는 문제 해결을 위해
				GlobalKeyBinder_Clear()
				return
			end
		end
	end
	
	-- 캐시 상점
	if (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Commercial) then
		if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_CashShop ) and (not GlobalKeyBinder_CheckProgress()) and ( Panel_Tutorial:IsShow() == false ) then
			InGameShop_Open()
			return
		end
	end
	
	-- '/' 키 처리 - 흑요석 정령
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local playerLevel = selfPlayer:get():getLevel()
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_BlackSpirit ) and ( false == Panel_Window_Exchange:GetShow() ) then
		if not IsSelfPlayerWaitAction() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT") )
			return
		end

		if Panel_Tutorial:GetShow() then
			FGlobal_Tutorial_Close()
		end
		
		ToClient_AddBlackSpiritFlush();
		return
	end
	
	-- 채팅 입력창
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Chat ) then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		ChatInput_Show()
		return
	end

	-- R 키 처리(루팅)
	if keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_Interaction ) then
		-- 루팅창이 열려있을때 일괄습득
		if Panel_Looting:IsShow() then
			Panel_Looting_buttonLootAll_Mouse_Click( false )
			Panel_Tooltip_Item_hideTooltip()			
			QuestInfoData.questDescHideWindow()
		end
	end

	-- ESC 키에 창 모두 닫기!
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		if( ToClient_WorldMapIsShow() ) then
			FGlobal_WorldMapWindowEscape();
			return
		end
		
		if Panel_EventNotify:GetShow() then
			close_WindowPanelList()
			FGlobal_NpcNavi_Hide()
			EventNotify_Close()
			return
		end
		
		if check_ShowWindow() then		-- 켜져있는 창이 있으면!
			close_WindowPanelList()
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
			FGlobal_NpcNavi_Hide()
			return;
		end	

		if check_ShowWindow() and FGlobal_NpcNavi_IsShowCheck() then		-- 켜져있는 창이 있고, NPC찾기 창이 열려있으면!
			close_WindowPanelList()
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
			FGlobal_NpcNavi_Hide()
			return;
		elseif not check_ShowWindow() and FGlobal_NpcNavi_IsShowCheck() then		-- 켜져있는 창이 없고, NPC찾기 창이 닫혀있으면!
			FGlobal_NpcNavi_Hide()
			return;
		elseif check_ShowWindow() and not FGlobal_NpcNavi_IsShowCheck() then		-- 켜져있는 창이 있고, NPC찾기 창이 닫혀있으면!
			close_WindowPanelList()
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
			return;
		-- elseif check_ShowWindow() and Panel_UIControl:GetShow() then
		-- 	FGlobal_Panel_Menu_Close()
		-- 	return;
		else
			-- if Panel_UIControl:IsShow() then	-- 컨트롤 창이 켜 있으면!
			-- 	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)		-- UIControl은 확실하게 해주자
			-- 	Panel_UIControl_SetShow( false )								-- 컨트롤 창 끄기
			-- 	Panel_Menu_ShowToggle()
			-- 	return;
			-- else

			if IM.eProcessorInputMode_UiMode == getInputMode() then
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				if( Panel_Menu_ShowToggle() ) then
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
				end
				return
			else
				if( Panel_Menu_ShowToggle() ) then
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
				else
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				end
				return
			end
				
			-- 	Panel_UIControl_SetShow( true )									-- 컨트롤 창 켜기
			-- 	Panel_Menu_ShowToggle()
			-- 	return;
			-- end
		end
	end

	-- O 키 처리 - 말 종합 정보
	-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_O ) then
		-- local	temporaryWrapper= getTemporaryInformationWrapper()
		-- if	(nil ~= temporaryWrapper) and temporaryWrapper:isSelfVehicle()	then
			-- if Panel_ServantInfo:IsShow() then
				-- ServantInfoWindow_Hide()
			-- else
				-- ServantInfoWindow_Show()
				-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			-- end
		-- end
		--return
	-- end

	--도움말_키보드 (F1)
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Help ) then
		if nil ~= Panel_KeyboardHelp then
			if(	FGlobal_KeyboardHelpShow() ) then
				UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
			else
				if( false == check_ShowWindow() ) then
					UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode )
				end
			end
		end
		return
	end

	-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F5 ) then
	-- 	if not Panel_Window_ItemMarket:GetShow() then
	-- 		FGolbal_ItemMarket_Function_Open()
	-- 	else
	-- 		FGolbal_ItemMarket_Function_Close()
	-- 	end
	-- end

	
	-- 제작 노트 임시 코드 (키 값이 정해지면 함수를 변경해야 합니다. by. 노남권) !! U
	-- 한국 서비스이거나 일본서비스이면서 CBT가 아닐 때
	if ((isGameTypeKorea() or isGameTypeJapan() or isGameTypeRussia() or isGameTypeEnglish()) and getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_CBT ) then
		if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_ProductionNote ) then
			if nil ~= Panel_ProductNote then
				if( Panel_ProductNote_ShowToggle() ) then
					UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode );
				else
					if( false == check_ShowWindow() ) then
						UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode );
					end
				end
			end
			return
		end
	end
	
	-- P 키 처리
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_P ) then
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_PlayerInfo ) then
		if Panel_Window_CharInfo_Status ~= nil then
			if Panel_Window_CharInfo_Status:GetShow() then
				-- ♬ 창 끌 때 소리난다요
				audioPostEvent_SystemUi(01,31)
				CharacterInfoWindow_Hide()
				if false == check_ShowWindow() then		--	게임 옵션에 따라 마우스 커서 남길지 안남길지...
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				end
			else
				-- 창을 켜야 하는데, 서번트 인포가 켜 있으면 그것만 한다.
				if Panel_Window_ServantInfo:GetShow() or Panel_CarriageInfo:GetShow() or Panel_ShipInfo:GetShow() then
					ServantInfo_Close()
					CarriageInfo_Close()
					ShipInfo_Close()
					-- ServantInventory_Close()
					Panel_Tooltip_Item_hideTooltip()
					TooltipSimple_Hide()
					return
				end

				-- ♬ 창 켤 때 소리난다요
				audioPostEvent_SystemUi(01,30)
				CharacterInfoWindow_Show()
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			end
		end

		local	selfProxy		= selfPlayer:get()
		if nil ~= selfProxy  then
			local	actorKeyRaw		= selfProxy:getRideVehicleActorKeyRaw()
			local	temporaryWrapper= getTemporaryInformationWrapper()
			-- local	servantInfo		= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
			-- local	servantShipInfo	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship )
			-- local	unsealCacheData	= temporaryWrapper:getUnsealVehicleByActorKeyRaw( actorKeyRaw )
			local	unsealCacheData	= getServantInfoFromActorKey( actorKeyRaw )
			if	nil ~= unsealCacheData	then
				local	inventory		= unsealCacheData:getInventory()
				local	invenSize		= inventory:size()
				if 0 ~= actorKeyRaw then -- selfProxy:doRideMyVehicle()	then	-- 탑승물에 탑승 중이라면
					if Panel_Window_ServantInfo:GetShow() or Panel_CarriageInfo:GetShow() or Panel_ShipInfo:GetShow() then
						ServantInfo_Close()
						CarriageInfo_Close()
						ShipInfo_Close()
						Panel_Tooltip_Item_hideTooltip()
						TooltipSimple_Hide()
						if false == check_ShowWindow() then		--	게임 옵션에 따라 마우스 커서 남길지 안남길지...
							UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
						end
						-- if Panel_Window_ServantInventory:GetShow() then
						-- 	-- ServantInventory_Close()
						-- 	TooltipSimple_Hide()
						-- 	Panel_Tooltip_Item_hideTooltip()
						-- end
					else
						requestInformationFromServant()
						ServantInfo_BeforOpenByActorKeyRaw( actorKeyRaw )	-- 말 정보창을 켠다.
						UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
						-- if 0 ~= invenSize then
						-- 	ServantInventory_OpenAll()
						-- end
					end
				end
			end
		end
		return
	end

	-- 스킬 (K)
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_K ) then
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Skill ) then
		if nil ~= Panel_Window_Skill then
			if Panel_Window_Skill:IsShow() then
				-- ♬ 창 끌 때 소리난다요
				audioPostEvent_SystemUi(01,17)
				HandleMLUp_SkillWindow_Close()
				if( false == check_ShowWindow() ) then
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				end
			else
				-- ♬ 창 켤 때 소리난다요
				audioPostEvent_SystemUi(01,18)
				PaGlobal_Skill:SkillWindow_Show()
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			end
		end
		return
	end

	-- 인벤토리 & 장착 (I)
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_I ) then
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Inventory ) then
		local isInvenOpen		= Panel_Window_Inventory:IsShow()
		local isEquipOpen		= Panel_Equipment:IsShow()
		local temporaryWrapper	= getTemporaryInformationWrapper()
		local servantInfo		= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
		local servantShipInfo	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship )
		if isInvenOpen == false and isEquipOpen == false then
			-- if true == FGlobal_isContinueGrindJewel() then
				-- Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_CONTINUEGRIND_ACK") ) -- "연속 빻기 중에는 가방을 열 수 없습니다."
				-- return
			-- end

			if isEquipOpen == false then
				Equipment_SetShow(true)
			end
			-- ♬ 창 켤 때 소리난다요
			audioPostEvent_SystemUi(01,16)
			InventoryWindow_Show( true )
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)

			if Panel_Window_ServantInventory:GetShow() then
				-- ServantInventory_Close()
				TooltipSimple_Hide()
				Panel_Tooltip_Item_hideTooltip()
			end

			-- 탑승물 인벤토리 단축키로 열리는 것 막음(임시) by 태곤(20150206)
			-- if nil ~= servantInfo or nil ~= servantShipInfo then
			-- 	Panel_Window_ServantInventory:SetPosX( getScreenSizeX() - Panel_Equipment:GetSizeX() - Panel_Equipment:GetPosX() )
			-- 	Panel_Window_ServantInventory:SetPosY( getScreenSizeY() - Panel_Equipment:GetSizeY() - Panel_Equipment:GetPosY() )

			-- 	ServantInventory_OpenAll()
			-- end

		else	-- if Panel_Window_Inventory ~= nil and Panel_Equipment ~= nil then
			if Panel_Window_Exchange:GetShow() then
				Panel_ExchangePC_BtnClose_Mouse_Click()
				return
			end

			Equipment_SetShow(false)
			-- ♬ 창 끌 때 소리난다요
			audioPostEvent_SystemUi(01,15)
			InventoryWindow_Close()
			ServantInventory_Close()
			TooltipSimple_Hide()
			-- CharacterInfoWindow_Hide()
			if false == check_ShowWindow() then
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
			end
		end
		return
	end


	-- 염색창 띄우기 (J)
	-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_J ) then
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Dyeing ) and (not GlobalKeyBinder_CheckProgress()) and ( Panel_Tutorial:IsShow() == false )  then
		if ( MiniGame_Manual_Value_FishingStart == true ) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_FISHING_ACK") ) -- "낚시 중에는 이용할 수 없습니다." )
			return
		else
			if ( not Panel_Dye_New:GetShow() ) then
			-- ♬ 창 켤 때 소리난다요
				audioPostEvent_SystemUi(01,24)
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
				FGlobal_Panel_DyeNew_Show()
			end
		end
		return
	end
	
	-- 강화 (U)
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_U ) then
	-- if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_ProductionNote ) then
		-- if Panel_Window_Enchant ~= nil and Panel_Window_Inventory ~= nil then
			-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			-- -- 인벤의 필터가 상호작용하는 UI에 따라 동작하려면 인벤토리를 먼저 열어주어야합니다.
			-- local isInvenOpen = Panel_Window_Inventory:IsShow()
			-- local isEnchantOpen = Panel_Window_Enchant:IsShow()
			-- if isEnchantOpen == false or isInvenOpen == false then
				-- if isInvenOpen == false then	
					-- InventoryWindow_Show()
				-- end	
				-- if isEnchantOpen == false then	
					-- Enchant_Show()
				-- end
			-- else
				-- InventoryWindow_Close()
				-- Panel_Window_Enchant:SetShow(false, false)
				-- if UI.isGameOptionMouseMode() then
					-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				-- end
			-- end
		-- end
		-- return
	-- end

	-- 연금술 (Y)
	-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_Y ) and IsSelfPlayerWaitAction()  then
		-- if Panel_Alchemy ~= nil and Panel_Window_Inventory ~= nil and IsSelfPlayerWaitAction() then
			-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			-- -- 인벤의 필터가 상호작용하는 UI에 따라 동작하려면 인벤토리를 먼저 열어주어야합니다.
			-- local isInvenOpen = Panel_Window_Inventory:IsShow()
			-- local isAlchemyOpen = Panel_Alchemy:IsShow()
			-- if isAlchemyOpen == false or isInvenOpen == false then
				-- InventoryWindow_Show()
				-- Alchemy_Show()
			-- else
				-- InventoryWindow_Close()
				-- Alchemy_Close()
				-- if UI.isGameOptionMouseMode() then
					-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				-- end
			-- end
		-- end
		-- return
	-- end
	
	-- 특별 보상 (U)
	-- if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_U ) then
		-- 	if Panel_MyVendor_List:IsShow() then
		-- 		-- ♬ 창을 끌 때 소리
		-- 		audioPostEvent_SystemUi(01,31)
		-- 		FGlobal_CloseMyVendorList()
		-- 	else
		-- 		-- ♬ 창을 켤 때 소리
		-- 		audioPostEvent_SystemUi(01,34)
		-- 		FGlobal_ShowMyVendorList()
		-- 	end
		-- 	return
	-- end
	
	-- 도전 과제
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Present ) then
		if not Panel_Window_CharInfo_Status:GetShow() then
			-- ♬ 창을 켤 때 소리
			audioPostEvent_SystemUi(01,34)
			-- 받을 보상이 있다.
			FGlobal_Challenge_Show()

		else
			-- ♬ 창을 끌 때 소리
			audioPostEvent_SystemUi(01,31)

			-- 받을 보상이 없다.
			FGlobal_Challenge_Hide()
		end
		return
	end

	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_Y ) and IsSelfPlayerWaitAction()  then
		--if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_QuestHistory ) and IsSelfPlayerWaitAction() then
		--	if Panel_KeyCustom_Action:IsShow() then
		--		KeyCustom_Action_Close()
		--	else
		--		KeyCustom_Action_Show()
		--	end
	--end
	
	-- 가공 (L)
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_L ) then
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Manufacture ) then
		if ( MiniGame_Manual_Value_FishingStart == true ) then
			return
		else
			if not IsSelfPlayerWaitAction() then
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE") )
				return
			end
			if Panel_Manufacture ~= nil and Panel_Window_Inventory ~= nil then
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
				-- 인벤의 필터가 상호작용하는 UI에 따라 동작하려면 인벤토리를 먼저 열어주어야합니다.
				local isInvenOpen = Panel_Window_Inventory:GetShow()
				local isManufactureOpen = Panel_Manufacture:GetShow()
				if isManufactureOpen == false or isInvenOpen == false then
					-- ♬ 창 켤 때 소리난다요
					audioPostEvent_SystemUi(01,26)
					Manufacture_Show( nil, CppEnums.ItemWhereType.eInventory, true)
				else
					-- ♬ 창 끌 때 소리난다요
					audioPostEvent_SystemUi(01,25)
					Manufacture_Close()
					if false == check_ShowWindow() then
						UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
					end
				end
			end
			return
		end
	end
	
	-- 길드 (G)
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_G ) then
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Guild ) then
		local guildWrapper = ToClient_GetMyGuildInfoWrapper()
		if nil ~= guildWrapper then
			local guildGrade = guildWrapper:getGuildGrade()
			if 0 == guildGrade then
				-- 인벤의 필터가 상호작용하는 UI에 따라 동작하려면 인벤토리를 먼저 열어주어야합니다.
				if ( false == Panel_ClanList:IsShow() )then
					-- ♬ 창 켤 때 소리난다요
					audioPostEvent_SystemUi(01,36)
					FGlobal_ClanList_Open()
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
				else
					-- ♬ 창 끌 때 소리난다요
					audioPostEvent_SystemUi(01,31)
					FGlobal_ClanList_Close()
					if( false == check_ShowWindow() ) then
						UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
					end
				end
			else
				-- 인벤의 필터가 상호작용하는 UI에 따라 동작하려면 인벤토리를 먼저 열어주어야합니다.
				if ( false == Panel_Window_Guild:IsShow() )then
					-- ♬ 창 켤 때 소리난다요
					audioPostEvent_SystemUi(01,36)
					GuildManager:Show()--FGlobal_guildWindow_Show()
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
				else
					-- ♬ 창 끌 때 소리난다요
					audioPostEvent_SystemUi(01,31)
					GuildManager:Hide()--FGlobal_guildWindow_Hide()
					if( false == check_ShowWindow() ) then
						UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
					end
				end
			end
		else
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_NO_GUILD" ) )
		end
		return
	end
	
	-- 우편 (B)
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Mail ) then
		if Panel_Mail_Main ~= nil and Panel_Mail_Detail ~= nil then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			local isMailMain = Panel_Mail_Main:IsShow()
			if	isMailMain == false then
				-- ♬ 창 켤 때 소리난다요
				audioPostEvent_SystemUi(01,22)
				Mail_Open()
			else
				-- ♬ 창 끌 때 소리난다요
				audioPostEvent_SystemUi(01,21)
				Mail_Close()
				if( false == check_ShowWindow() ) then
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				end
			end			
		end
		return
	end
	
	-- 친구목록
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_FriendList ) then
		if Panel_FriendList ~= nil then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			local isFriendList = Panel_FriendList:IsShow()
			if isFriendList == false then
				FriendList_show();	
				-- ♬ 창 켤 때 소리난다요
				audioPostEvent_SystemUi(01,28)
			else
				FriendList_hide()
				-- ♬ 창 끌 때 소리난다요
				audioPostEvent_SystemUi(01,27)
				if( false == check_ShowWindow() ) then
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				end
			end			
		end
		return
	end
	
	-- 퀘스트 (O)
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_QuestHistory ) then
			if Panel_Window_Quest_History:GetShow() then
				-- ♬ 창 끌 때 소리난다요
				audioPostEvent_SystemUi(01,27)
				Panel_Window_QuestNew_Show( false )
				FGlobal_QuestHistoryClose()
				
				if false == check_ShowWindow() then
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
				end
			else
				-- ♬ 창 켤 때 소리난다요
				audioPostEvent_SystemUi(01,29)
				Panel_Window_QuestNew_Show( true )
				FGlobal_QuestHistoryOpen()
				UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
			end
		return
	end
	
	-- PVP모드 (ALT + C)
	if isKeyPressed( VCK.KeyCode_MENU ) and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_C ) then
		if not isPvpEnable() then
			return
		else
			requestTogglePvP()
			return
		end
	end
	
	-- 뷰티샵(F4)
	if getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
		if (not isKeyPressed( VCK.KeyCode_MENU ))and GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_BeautyShop ) and (not GlobalKeyBinder_CheckProgress()) and ( Panel_Tutorial:IsShow() == false )  then
			-- if (FGlobal_IsCommercialService()) then
				if ( not getCustomizingManager():isShow() ) then
				    IngameCustomize_Show()
					return
				end
			-- end
		end
	end
	-- M 키 처리 - 월드맵
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_M ) and (not GlobalKeyBinder_CheckProgress()) and IsSelfPlayerAction() then
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_M ) and (not GlobalKeyBinder_CheckProgress()) then
	
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_WorldMap ) and (not GlobalKeyBinder_CheckProgress()) and ( Panel_Tutorial:IsShow() == false ) then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		if not Panel_Global_Manual:GetShow() then
			FGlobal_PushOpenWorldMap()
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_MINIGAMING_NOT_WORLDMAP") ) -- 미니게임 중에는 월드맵을 이용할 수 없습니다.
			return
		end
	end
end

local _keyBinder_UIMode_NpcDialog = function( deltaTime )
	-- 다이얼로그 SPACE BAR로 다음 넘어가기
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) thenr
	if keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_Interaction ) then
		if Panel_Window_NpcShop:GetShow() then
			return
		end

		local _uiNextButton	= UI.getChildControl( Panel_Npc_Dialog, "Button_Next")
		if Panel_DetectPlayer:GetShow() then
			return
		end
		if Panel_CreateGuild:GetShow() then
			return
		end
		if Panel_GuildHouse_Auction:GetShow() then
			return
		end
		--local _SpacebarIcon	= UI.getChildControl( Panel_Npc_Dialog, "StaticText_Spacebar")		-- 계속 버튼일 때 아이콘 띄워져 있는지 체크
		if _uiNextButton:GetShow() then
			HandleClickedDialogNextButton()
			audioPostEvent_SystemUi(00,00)
		elseif isShowReContactDialog() then
			HandleClickedDialogButton(0)		-- 계속 버튼
			audioPostEvent_SystemUi(00,00)
		elseif isShowDialogFunctionQuest() then
			HandleClickedFuncButton(0)			-- 새로운 퀘스트 펑션 버튼
			audioPostEvent_SystemUi(00,00)
			return
		elseif ( -1 < questDialogIndex()) then
			HandleClickedDialogButton(questDialogIndex())
			audioPostEvent_SystemUi(00,00)
		elseif ( -1 < exchangalbeButtonIndex() ) then
			HandleClickedDialogButton(exchangalbeButtonIndex())
			audioPostEvent_SystemUi(00,00)
		end
		return
	end
	
	-- 길드 창설
	if ( FGlobal_CehckedGuildEditUI( GetFocusEdit() ) )then
		-- if( GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) ) then
		-- 	handleClicked_GuildCreateApply()
		-- else
		if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			handleClicked_GuildCreateCancel()	
		end
		return
	end

	-- 창이 떠 있으면 닫고, 없으면 대화 종료
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		-- Panel_Dialog_CheckedButtonSet()
		-- _PA_LOG("LUA", "esc로 종료")
		local playerLevel = getSelfPlayer():get():getLevel()
		if ( nil == dialog_getTalker() ) and ( playerLevel == 1 ) then
			return
		elseif check_ShowWindow() then
			close_WindowPanelList()
			if Panel_Npc_Quest_Reward:GetShow() then
				FGlobal_HideDialog()
			end
		else
			FGlobal_HideDialog()--Panel_hideDialog(true)
		end

		-- 대화창을 나올 때는 탑승물 정보창, 탑승물 인벤토리를 닫는다.
		ServantInfo_Close()
		CarriageInfo_Close()
		ServantInventory_Close()
		return
	end

	
	--if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_I ) then
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Inventory ) then
		if getAuctionState() then
			local isInvenOpen = Panel_Window_Inventory:IsShow()
			if isInvenOpen == false then
				InventoryWindow_Show()
				Inventory_SetFunctor( nil , nil, nil, nil)
				return 	
			end
					
			if Panel_Window_Inventory ~= nil then
				InventoryWindow_Close()
				return
			end
		end	
	end

	if Panel_Dialog_Search:GetShow() then
		if isKeyPressed( VCK.KeyCode_A ) then
			searchView_PushLeft()
		elseif isKeyPressed( VCK.KeyCode_S ) then
			searchView_PushBottom()
		elseif isKeyPressed( VCK.KeyCode_D ) then
			searchView_PushRight()
		elseif isKeyPressed( VCK.KeyCode_W ) then
			searchView_PushTop()
		elseif isKeyPressed( VCK.KeyCode_Q ) then
			searchView_ZoomIn()
		elseif isKeyPressed( VCK.KeyCode_E ) then
			searchView_ZoomOut()
		end
	end

	
end

local _keyBinder_UIMode_WorldMap = function( deltaTime )
	if (GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE )) then
		if Panel_Window_Quest_New:GetShow() then
			Panel_Window_QuestNew_Show( false )
			return
		end
		if Panel_Window_ItemMarket:GetShow() then	-- 월드맵에서 아이템거래소 띄운 후 ESC 키
			FGolbal_ItemMarket_Close()
			return
		end
		if Panel_Window_ItemMarket_ItemSet:GetShow() then
			FGlobal_ItemMarketItemSet_Close()
			return
		end
		if isWorldMapGrandOpen() then
			if Panel_WorldMap_MovieGuide:GetShow() then
				Panel_Worldmap_MovieGuide_Close()		-- 영상 도움말
				return
			end
		end

		FGlobal_WorldMapWindowEscape()
	elseif ( FGlobal_AskCloseWorldMap() ) then
		FGlobal_PopCloseWorldMap()
--			if UI.isGameOptionMouseMode() then
--				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
--			end		
--	elseif Panel_Window_ItemMarket:GetShow() then -- and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) 
		-- FGolbal_ItemMarket_Search()
--		return

--  월드맵에 작업할 시, 이 아래로 추가 할 것
	elseif GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Chat ) then
		if not Panel_Window_ItemMarket:GetShow() then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
			ChatInput_Show()
			return
		else
			return
		end
	elseif (GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_WorldMap )) then
--			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		FGlobal_CloseWorldmapForLuaKeyHandling()
		return
	end
		
	if FGlobal_isOpenItemMarketBackPage() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_BACK ) and false == FGlobal_isItemMarketBuyConfirm() then		-- 거래소 뒤로가기 버튼이 활성화되어있나
		FGlobal_HandleClicked_ItemMarketBackPage()	-- 이전 페이지로 돌리기 실행
	end

	-- 월드맵에서 제작 노트 팝업
	if ((isGameTypeKorea() or isGameTypeJapan() or isGameTypeRussia() ) and getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_CBT )  then
		if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_ProductionNote ) then
			if nil ~= Panel_ProductNote then
				Panel_ProductNote_ShowToggle()
			end
			return
		end
	end
	
	if( isKeyPressed( VCK.KeyCode_CONTROL ) ) then
		ToClient_showWorldmapKeyGuide(true)
	elseif( isKeyPressed( VCK.KeyCode_SHIFT ) ) then
		ToClient_showWorldmapKeyGuide(true)	
	elseif( isKeyPressed( VCK.KeyCode_MENU ) ) then
		ToClient_showWorldmapKeyGuide(true)
	else
		ToClient_showWorldmapKeyGuide(false)
	end
end

local _keyBinder_WorldMapSearch = function( deltaTime )	-- 월드맵 검색 상태
	if (GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE )) then
		ClearFocusEdit()
		-- 월드맵 모드로 변경
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		SetUIMode( Defines.UIMode.eUIMode_WorldMap )
	end
end

local _keyBinder_UIMode_Housing = function( deltaTime )

	if Panel_Housing_FarmInfo_New:GetShow() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		PAHousing_FarmInfo_Close()
		return
	elseif Panel_House_InstallationMode_ObjectControl:GetShow() and housing_isBuildMode() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		-- FGlobal_HouseInstallationControl_Cancel()
		FGlobal_HouseInstallationControl_Move()
		return
	elseif Panel_House_InstallationMode_ObjectControl:GetShow() and not housing_isBuildMode() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		FGlobal_HouseInstallationControl_Close()
		-- FGlobal_HouseInstallationControl_Move()
		return
	elseif Panel_House_InstallationMode_ObjectControl:GetShow() and not housing_isBuildMode() and true == FGlobal_HouseInstallationControl_IsConfirmStep() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) then	
		FGlobal_HouseInstallationControl_Confirm()
		return
	elseif not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		Panel_Housing_CancelModeFromKeyBinder()
		return
	end
	 
	-- 여기를 채워야 한다!
end

local _keyBinder_UIMode_Mental = function( deltaTime )
	if not escHandle and (GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) or GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_MentalKnowledge )) then
		Panel_Knowledge_Hide()
		if UI.isGameOptionMouseMode() then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		end
	end
end

local _keyBinder_UIMode_MentalGame = function( deltaTime )
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		MentalGame_Hide()
		SetUIMode(Defines.UIMode.eUIMode_NpcDialog)	
	end
end

local _keyBinder_UIMode_InGameCustomize = function( deltaTime )
	if Panel_CustomizationMain:IsShow() and ( Panel_CustomizationMain:GetAlpha() == 1.0 ) then
		if not escHandle and ( GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) or GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F4 ) ) then
			IngameCustomize_Hide()
		end
	end
end

local prevPressControl = nil;
local _keyBinder_UIMode_InGameCashShop = function( delataTime )
	if	(GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_CashShop) )	then
		InGameShop_Close()
		Panel_Tooltip_Item_hideTooltip()
	end

	if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_ESCAPE) then
		if ( Panel_Window_Inventory:IsShow() ) then
			Panel_Window_Inventory:SetShow(false)
		elseif	( Panel_IngameCashShop_BuyOrGift:GetShow() )	then
			InGameShopBuy_Close()
		elseif	( Panel_IngameCashShop_GoodsDetailInfo:GetShow() )	then
			InGameShopDetailInfo_Close()
			Panel_Tooltip_Item_hideTooltip()
		elseif	( Panel_QnAWebLink:GetShow() )	then
			FGlobal_QnAWebLink_Close()
		elseif ( Panel_IngameCashShop_MakePaymentsFromCart:GetShow() ) then
			FGlobal_IngameCashShop_MakePaymentsFromCart_Close()
		else
			InGameShop_Close()
		end
	end

	if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RETURN) and FGlobal_InGameShop_IsSelectedSearchName() then
		InGameShop_Search()	-- 검색한다.
	end

	if( FGlobal_InGameShop_IsSelectedSearchName() ) then
		local pressControl = getPressControl();
		if( nil == pressControl ) then
			pressControl = prevPressControl
		end
		local searchEdit = FGlobal_InGameCashShop_GetSearchEdit()
		prevPressControl = pressControl
		if( pressControl:GetKey() ~= searchEdit:GetKey() )then
			ClearFocusEdit()
		else
			return
		end
	end

	if not Panel_IngameCashShop_BuyOrGift:GetShow() and GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Inventory ) then
		 if Panel_Window_Inventory:IsShow() then
			 InventoryWindow_Close()
		 else
			 FGlobal_InGameShop_OpenInventory()
		 end
	end
	
	-- InGameShop_Close()
end

local _keyBinder_UIMode_Dye = function( delataTime )
	if ( not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) ) or ( GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Dyeing ) ) then

		audioPostEvent_SystemUi(01,23)
		FGlobal_Panel_DyeNew_Hide()
		
		if false == check_ShowWindow() then				
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		end
		SetUIMode(Defines.UIMode.eUIMode_Default)
	end
end

local _keyBinder_UIMode_ItemMarket = function( delataTime )
	if ( not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) ) then
		if Panel_Window_ItemMarket_ItemSet:GetShow() then
			FGlobal_ItemMarketItemSet_Close()
		elseif Panel_Window_ItemMarket_RegistItem:GetShow() then
			FGlobal_ItemMarketRegistItem_Close()
		elseif Panel_Window_ItemMarket:GetShow() then
			if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
				FGlobal_ItemMarket_BuyConfirm_Close()
			elseif Panel_ItemMarket_AlarmList:GetShow() then
				FGlobal_ItemMarketAlarmList_Close()
			else
				FGolbal_ItemMarket_Close()
			end
		else
			FGolbal_ItemMarket_Function_Close()
		end
		
		-- 메이드 닫는 이벤트 핸들러 들어감
		if ToClient_CheckExistSummonMaid() then
			ToClient_CallHandlerMaid("_maidLogOut")
			-- SetUIMode(Defines.UIMode.eUIMode_Default)
		end		
		
	end

	if FGlobal_isOpenItemMarketBackPage() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_BACK ) and false == FGlobal_isItemMarketBuyConfirm() then		-- 거래소 뒤로가기 버튼이 활성화되어있고, Confirm창이 닫혀있나
		FGlobal_HandleClicked_ItemMarketBackPage()	-- 이전 페이지로 돌리기 실행
	end
	
	if Panel_Window_ItemMarket:GetShow() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
		FGolbal_ItemMarket_Search()
	end

	if Panel_Window_ItemMarket_RegistItem:GetShow() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
		FGlobal_ItemMarketRegistItem_RegistDO()
	end
end

local _keyBinder_UIMode_Trade = function( deltaTime )
	-- 창이 떠 있으면 닫고, 없으면 대화 종료
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		closeNpcTrade_Basket()
		TooltipSimple_Hide()
	-- elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_I ) then
		-- if Panel_Window_Inventory:IsShow() then
			-- InventoryWindow_Close()
		-- else
			-- InventoryWindow_Show()
		-- end
	end
	
	-- if Panel_Window_Inventory:IsShow() then
		-- InventoryWindow_Close()
	-- end
end

local	_keyBinder_UIMode_Stable = function( deltaTime )
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		if	( CppEnums.ServantType.Type_Vehicle == stable_getServantType() )	then
			StableFunction_Close()
			GuildStableFunction_Close()
		elseif	( CppEnums.ServantType.Type_Ship == stable_getServantType() )	then
			WharfFunction_Close()
		-- elseif	( CppEnums.ServantType.Type_Pet == stable_getServantType() )	then
		-- 	PetFunction_Close()
		else

		end
	end
end

local	_keyBinder_UIMode_GameExit = function( deltaTime )
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		if true == Panel_Window_DeliveryForGameExit:GetShow() then		-- 운송창이 떠있으면 먼저 닫기
			FGlobal_DeliveryForGameExit_Show( false )
			return
		elseif true == Panel_Event_100Day:GetShow() then		-- 종료팝업 떠있으면 먼저 닫기
			FGlobal_Event_100Day_Close()
		elseif true == Panel_ChannelSelect:GetShow() then		-- 종료팝업 떠있으면 먼저 닫기
			FGlobal_ChannelSelect_Hide()
		else
			GameExitShowToggle( false )
		end
		--searchView_Close()
	end
end

local	_keyBinder_UIMode_DeadMessage = function( deltaTime )
	if GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Chat ) then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		ChatInput_Show()
		return
	elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_TAB ) then
		ChatInput_ChangeInputFocus()
	elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_UP ) then
		if( ToClient_isComposition() ) then		-- 타 국가에서 문자 조합형식을 사용할때 방향키를 사용 못하도록 처리.(프로그래머 대호씨)
			return;
		end
		ChatInput_PressedUp()
	elseif isKeyPressed( VCK.KeyCode_MENU ) then
		ChatInput_CheckReservedKey()
	elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) then
		ChatInput_CheckInstantCommand()
	elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		if Panel_Chatting_Input:GetShow() then
			if( ToClient_isComposition() ) then
				return;
			end
			ChatInput_CancelAction()
			ChatInput_CancelMessage()
			ChatInput_Close()
			friend_clickAddFriendClose()

			if( check_ShowWindow() ) then
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			end
		end
		return
	end
end

local _keyBinder_UIMode_MiniGame = function( deltaTime )
	local MiniGame_BattleGauge_Space = Panel_BattleGauge:IsShow()
	local MiniGame_FillGauge_Mouse = Panel_FillGauge:IsShow()
	
	-- if ( MiniGame_BattleGauge_Space == true ) then
		-- if ( GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE )  ) then
			-- BattleGauge_UpdateGauge(deltaTime)
		-- end
	-- end
	
	if ( MiniGame_FillGauge_Mouse ) then
		if ( GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_LBUTTON )  ) then
			FillGauge_UpdateGauge(deltaTime, true)
		elseif ( GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RBUTTON )  ) then
			FillGauge_UpdateGauge(deltaTime, false)
		end
	end
end

local _keyBinder_UIMode_PreventMoveNSkill = function( deltaTime )
end

local _keyBinder_UIMode_Movie = function( deltaTime )
	-- ESC 키에 창 모두 닫기!
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		if check_ShowWindow() then		-- 켜져있는 창이 있으면!
			close_WindowPanelList()
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
			return;
		else
			if Panel_UIControl:IsShow() then	-- 컨트롤 창이 켜 있으면!
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)	-- UIControl은 확실하게 해주자
				Panel_UIControl_SetShow( false )					-- 컨트롤 창 끄기
				Panel_Menu_ShowToggle()
				return;
			else
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiControlMode)		-- UIControl은 확실하게 해주자
				Panel_UIControl_SetShow( true )					-- 컨트롤 창 켜기
				Panel_Menu_ShowToggle()
				return;
			end
		end
	end
end

local	_keyBinder_UIMode_Repair = function( deltaTime )
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		if Panel_FixEquip:GetShow() then
			FixEquip_Close()
		else
			RepairExitBtn_LUp()
		end
	-- elseif GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Inventory ) then
	-- 	 if Panel_Window_Inventory:IsShow() then
	-- 		 InventoryWindow_Close()
	-- 	 else
	-- 		 InventoryWindow_Show()
	-- 	 end
	end
end

-- 추출 ESC
local	_keyBinder_UIMode_Extraction = function( deltaTime )
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		if Panel_Window_Extraction:GetShow() then
			Extraction_OpenPanel( false )
		 end
	end
end

local	_keyBinder_UIMode_KeyCustom_ActionKey = function( deltaTime )

	local isEnd = false
	local inputType = KeyCustom_Action_GetInputType()

	if isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_ESCAPE ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Action_Key 취소... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_" .. inputType ) .. ")" )
	elseif isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_DELETE ) then
		keyCustom_Clear_ActionKey( inputType )
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Action_Key 제거... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_" .. inputType ) .. ")" )
	elseif keyCustom_CheckAndSet_ActionKey( inputType ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Action_Key 수정 완료... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_" .. inputType ) .. ")" )
	end

	if isEnd then
		SetUIMode( UIMode.eUIMode_KeyCustom_Wait );
		KeyCustom_Action_UpdateButtonText_Key()
		KeyCustom_Action_KeyButtonCheckReset( inputType )
	end
end

local	_keyBinder_UIMode_KeyCustom_ActionPad = function( deltaTime )

	local isEnd = false
	local inputType = KeyCustom_Action_GetInputType()

	if isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_ESCAPE ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Action_Pad 취소... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_" .. inputType ) .. ")" )
	elseif isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_DELETE ) then
		keyCustom_Clear_ActionPad( inputType )
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Action_Pad 제거... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_" .. inputType ) .. ")" )
	elseif keyCustom_CheckAndSet_ActionPad( inputType ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Action_Pad 수정 완료... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Action_" .. inputType ) .. ")" )
	end

	if isEnd then
		SetUIMode( UIMode.eUIMode_KeyCustom_Wait );
		KeyCustom_Action_UpdateButtonText_Pad()
		KeyCustom_Action_PadButtonCheckReset( inputType )
	end
end

local	_keyBinder_UIMode_KeyCustom_UiKey = function( deltaTime )

	local isEnd = false
	local inputType = KeyCustom_Ui_GetInputType()
	if isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_ESCAPE ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Ui_Key 취소... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_" .. inputType ) .. ")" )
	elseif isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_DELETE ) then
		keyCustom_Clear_UiKey( inputType )
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Ui_Key 제거... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_" .. inputType ) .. ")" )
	elseif keyCustom_CheckAndSet_UiKey( inputType ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Ui_Key 수정 완료... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_" .. inputType ) .. ")" )
	end

	if isEnd then
		SetUIMode( UIMode.eUIMode_KeyCustom_Wait );
		KeyCustom_Ui_UpdateButtonText_Key()
		KeyCustom_Ui_KeyButtonCheckReset( inputType )
	end
end

local	_keyBinder_UIMode_KeyCustom_UiPad = function( deltaTime )

	local isEnd = false
	local inputType = KeyCustom_Ui_GetInputType()

	if isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_ESCAPE ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Ui_Pad 취소... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_" .. inputType ) .. ")" )
	elseif isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_DELETE ) then
		keyCustom_Clear_UiPad( inputType )
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Ui_Pad 제거... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_" .. inputType ) .. ")" )
	elseif keyCustom_CheckAndSet_UiPad( inputType ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom_Ui_Pad 수정 완료... (" .. PAGetString( Defines.StringSheet_GAME, "Lua_KeyCustom_Ui_" .. inputType ) .. ")" )
	end

	if isEnd then
		SetUIMode( UIMode.eUIMode_KeyCustom_Wait );
		KeyCustom_Ui_UpdateButtonText_Pad()
		KeyCustom_Ui_PadButtonCheckReset( inputType )
	end
end

local	_keyBinder_UIMode_KeyCustom_ActionPadFunc1 = function( deltaTime )

	local isEnd = false

	if isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_ESCAPE ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom__ActionPadFunc1 취소... " )
	elseif isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_DELETE ) then
		keyCustom_Clear_ActionPadFunc1( inputType )
		isEnd = true
		-- UI.debugMessage( "KeyCustom__ActionPadFunc1 제거..." )
	elseif keyCustom_CheckAndSet_ActionPadFunc1( inputType ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom__ActionPadFunc1 수정 완료..." )
	end

	if isEnd then
		SetUIMode( UIMode.eUIMode_KeyCustom_Wait );
		KeyCustom_Action_UpdateButtonText_Pad()
		KeyCustom_Action_FuncPadButtonCheckReset( 0 )
	end
end

local	_keyBinder_UIMode_KeyCustom_ActionPadFunc2 = function( deltaTime )

	local isEnd = false

	if isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_ESCAPE ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom__ActionPadFunc2 취소... " )
	elseif isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_DELETE ) then
		keyCustom_Clear_ActionPadFunc2( inputType )
		isEnd = true
		-- UI.debugMessage( "KeyCustom__ActionPadFunc2 제거..." )
	elseif keyCustom_CheckAndSet_ActionPadFunc2( inputType ) then
		isEnd = true
		-- UI.debugMessage( "KeyCustom__ActionPadFunc2 수정 완료..." )
	end

	if isEnd then
		SetUIMode( UIMode.eUIMode_KeyCustom_Wait );
		KeyCustom_Action_UpdateButtonText_Pad()
		KeyCustom_Action_FuncPadButtonCheckReset( 1 )
	end
end

local _keyBinder_UIMode_PopupItem = function()
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		Panel_UseItem_ShowToggle_Func()
	end
end

local _keyBinder_UIMode_ProductNote = function( deltaTime )
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		Panel_ProductNote_ShowToggle();
	end
end
local _keyBinder_UIMode_QnAWebLink = function( deltaTime )
	if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		if( false == Panel_QnAWebLink_ShowToggle() ) then
			if( AllowChangeInputMode() ) then
				if( check_ShowWindow() ) then
					UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
				else
					UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
				end
			else
				SetFocusChatting()
			end
		end
	end
end
local _KeyBinder_UIMode_TradeGame = function ( deltaTime )
	if isKeyUpFor( CppEnums.VirtualKeyCode.KeyCode_ESCAPE ) then
		Fglobal_TradeGame_Close()
		return
	end
	--if not escHandle and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		global_Update_TradeGame( deltaTime )
	--end
end

local _KeyBinder_UIMode_CutSceneMode = function( deltaTime )
	-- cutscene popup처리
	if( ToClient_cutsceneIsPlay() ) then
		if not MessageBox.isPopUp() then
			if( isKeyDown_Once( CppEnums.VirtualKeyCode.KeyCode_ESCAPE ) and false == isRunClosePopup ) then
				local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "CUTSCENE_EXIT_MESSAGEBOX_MEMO" )
				local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = messageBoxMemo, functionYes = ToClient_CutsceneStop, functionNo = MessageBox_Empty_function, exitButton = true, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
				MessageBox.showMessageBox(messageBoxData)
			end
		end
		-- if Panel_MovieTheater_LowLevel:GetShow() then
			Panel_MovieTheater_LowLevel_WindowClose()
		-- end
		return
	end
end
local _KeyBinder_UIMode_UiSetting = function ( deltaTime )
	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		FGlobal_UiSet_Close()	-- 닫기
		return
	end
end

local _KeyBinder_UIMode_Gacha_Roulette = function ( deltaTime )
	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) then
		FGlobal_gacha_Roulette_OnPressSpace()
	elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		FGlobal_gacha_Roulette_OnPressEscape()
	end	
	return
end

local _KeyBinder_UIMode_EventNotify = function( deltaTime )
	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		EventNotifyContent_Close()
		if( AllowChangeInputMode() ) then
			if( check_ShowWindow() ) then
				UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
			else
				UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
			end
		else
			SetFocusChatting()
		end
		
		SetUIMode( Defines.UIMode.eUIMode_Default )
	end
end

function SetUIMode( uiMode )
	if 0 <= uiMode and uiMode < UIMode.eUIMode_Count then
		_uiMode = uiMode
	end

end

function GetUIMode()
	return _uiMode
end

-- Bubble, 상호작용 창이 떠야하는 조건 ( UI Mode 관련 )
function IsBubbleAndInterActionShowCondition()
	return (_uiMode == UIMode.eUIMode_Default)
end

function IsWaitCommentAndInterActionShowCondition()
	return (_uiMode == UIMode.eUIMode_Default)
end


function IsCharacterNameTagShowCondition()
	return (_uiMode == UIMode.eUIMode_Default) or (_uiMode == UIMode.eUIMode_Housing)
end


local GlobalKeyBinder_MouseDragEvent = function()
	if DragManager:isDragging() and GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		DragManager:clearInfo()
		escHandle = true
	else
		escHandle = false
	end
end

local _ChattingMacro_Process = function()
	if( false == isKeyPressed( VCK.KeyCode_MENU ) )then
		return false
	end

	if( false == isKeyPressed( VCK.KeyCode_SHIFT ) )then
		return false
	end

	if 		( isKeyDown_Once( VCK.KeyCode_1 ) and "" ~= ToClient_getMacroChatMessage(0) )	then	ToClient_executeChatMacro(0)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_2 ) and "" ~= ToClient_getMacroChatMessage(1) )	then	ToClient_executeChatMacro(1)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_3 ) and "" ~= ToClient_getMacroChatMessage(2) )	then	ToClient_executeChatMacro(2)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_4 ) and "" ~= ToClient_getMacroChatMessage(3) )	then	ToClient_executeChatMacro(3)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_5 ) and "" ~= ToClient_getMacroChatMessage(4) )	then	ToClient_executeChatMacro(4)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_6 ) and "" ~= ToClient_getMacroChatMessage(5) )	then	ToClient_executeChatMacro(5)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_7 ) and "" ~= ToClient_getMacroChatMessage(6) )	then	ToClient_executeChatMacro(6)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_8 ) and "" ~= ToClient_getMacroChatMessage(7) )	then	ToClient_executeChatMacro(7)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_9 ) and "" ~= ToClient_getMacroChatMessage(8) )	then	ToClient_executeChatMacro(8)	return true
	elseif	( isKeyDown_Once( VCK.KeyCode_0 ) and "" ~= ToClient_getMacroChatMessage(9) )	then	ToClient_executeChatMacro(9)	return true
	end
	return false
end

local _SkillkeyBinder_UIMode_CommonWindow = function( deltaTime )
	if isUseNewQuickSlot() then
		if keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot1 )		then	HandleClicked_NewQuickSlot_Use( 0 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot2 )	then	HandleClicked_NewQuickSlot_Use( 1 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot3 )	then	HandleClicked_NewQuickSlot_Use( 2 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot4 )	then	HandleClicked_NewQuickSlot_Use( 3 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot5 )	then	HandleClicked_NewQuickSlot_Use( 4 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot6 )	then	HandleClicked_NewQuickSlot_Use( 5 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot7 )	then	HandleClicked_NewQuickSlot_Use( 6 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot8 )	then	HandleClicked_NewQuickSlot_Use( 7 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot9 )	then	HandleClicked_NewQuickSlot_Use( 8 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot10 )	then	HandleClicked_NewQuickSlot_Use( 9 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot11 )	then	HandleClicked_NewQuickSlot_Use( 10 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot12 )	then	HandleClicked_NewQuickSlot_Use( 11 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot13 )	then	HandleClicked_NewQuickSlot_Use( 12 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot14 )	then	HandleClicked_NewQuickSlot_Use( 13 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot15 )	then	HandleClicked_NewQuickSlot_Use( 14 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot16 )	then	HandleClicked_NewQuickSlot_Use( 15 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot17 )	then	HandleClicked_NewQuickSlot_Use( 16 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot18 )	then	HandleClicked_NewQuickSlot_Use( 17 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot19 )	then	HandleClicked_NewQuickSlot_Use( 18 )
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot20 )	then	HandleClicked_NewQuickSlot_Use( 19 )
		end
	else
		if keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot1 )		then	QuickSlot_Click("0")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot2 )	then	QuickSlot_Click("1")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot3 )	then	QuickSlot_Click("2")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot4 )	then	QuickSlot_Click("3")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot5 )	then	QuickSlot_Click("4")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot6 )	then	QuickSlot_Click("5")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot7 )	then	QuickSlot_Click("6")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot8 )	then	QuickSlot_Click("7")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot9 )	then	QuickSlot_Click("8")
		elseif	keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_QuickSlot10 )	then	QuickSlot_Click("9")
		end
	end
end

-----------------------------------
-- 전역 Key Event Main 함수!!!
-----------------------------------
local noInputElapsedTime = 0.0		-- 해당 시간 동안 키 입력을 막는다.
function GlobalKeyBinder_Update( deltaTime )	-- 계속 돌면서 체크한다.
	-- UIMode일 경우에만 사용해야 합니다. eProcessorInputMode_UiMode 로 설정합니다.
	if 0.0 < noInputElapsedTime then
		noInputElapsedTime = noInputElapsedTime - deltaTime
		
		if noInputElapsedTime <= 0.0 then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		end
	end
	isRunClosePopup = false
	if isIntroMoviePlaying then
		SetUIMode( UIMode.eUIMode_Movie )
	end

	GlobalKeyBinder_MouseDragEvent()
	
	local inputMode = UI.Get_ProcessorInputMode()

	if MessageBox.isPopUp() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) or GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) then	--  점프와 겹치는 문제를 수정할 수 없음.
			MessageBox.keyProcessEnter()
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)
			noInputElapsedTime = 0.5
			GlobalKeyBinder_Clear()
			return;
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			MessageBox.keyProcessEscape()
			isRunClosePopup = true
			GlobalKeyBinder_Clear()
			return;
		end
		
	elseif Panel_UseItem:IsShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
			Click_Panel_UserItem_Yes()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			Panel_UseItem_ShowToggle_Func()
		end
		GlobalKeyBinder_Clear()
		return		
	elseif Panel_ExitConfirm:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
			Panel_GameExit_MinimizeTray()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE )then
			Panel_ExitConfirm:SetShow( false )
		end
		GlobalKeyBinder_Clear()
		return
	elseif Panel_NumberPad_IsPopUp() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_F ) then
			Panel_NumberPad_ButtonAllSelect_Mouse_Click()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) or GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) or keyCustom_IsDownOnce_Action( CppEnums.ActionInputType.ActionInputType_Interaction ) then
			
			Panel_NumberPad_ButtonConfirm_Mouse_Click()

			if( GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) ) then
				setInputMode( IM.eProcessorInputMode_UiModeNotInput )
				noInputElapsedTime = 0.5
			end

		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			Panel_NumberPad_ButtonCancel_Mouse_Click()
		end
		Panel_NumberPad_NumberKey_Input()
		GlobalKeyBinder_Clear()
		return;
	elseif Panel_Chatting_Macro:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_Chatting_Macro_ShowToggle()
			FGlobal_Chatting_Macro_SetCHK( false )
			-- 
			if( AllowChangeInputMode() ) then
				if( check_ShowWindow() ) then
					UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
				else
					UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
				end
			else
				SetFocusChatting()
			end
			
			return;
		end
	elseif Panel_Chat_SocialMenu:GetShow() then
	 	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
		
			if Panel_Chatting_Input:GetShow() then
				--FGlobal_SocialAction_ShowToggle()
				--FGlobal_SocialAction_SetCHK( false )

				ChatInput_CancelAction()
				ChatInput_CancelMessage()
				ChatInput_Close()
				friend_clickAddFriendClose()

				if( check_ShowWindow() ) then
					UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
				end
				-- 채팅창이 켜져 있다고 가정한다.
			else
				FGlobal_SocialAction_SetCHK( false )
				FGlobal_SocialAction_ShowToggle()
				if( not AllowChangeInputMode() ) then
					SetFocusChatting();	
				else
					if( check_ShowWindow() ) then
						UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
					else
						UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
					end
				end
			end
	 		return;
	 	end
	elseif Panel_Chat_SubMenu:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			if Panel_Chatting_Block_GoldSeller:GetShow() then
				FGlobal_reportSeller_Close()
				return
			end

			Panel_Chat_SubMenu:SetShow( false )
			return
		end

	elseif Panel_GuildIncentive:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) and not FGlobal_CheckSaveGuildMoneyUiEdit( GetFocusEdit() ) then
			FGlobal_SaveGuildMoney_Send()
			return
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_GuildIncentive_Close()
			return
		end
		FGlobal_GuildDeposit_InputCheck()
		GlobalKeyBinder_Clear()
		return

	elseif GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_AlchemySton ) and false == isKeyPressed( VCK.KeyCode_CONTROL ) then -- 포토모드와 키가 겹친다.
		if inputMode == IM.eProcessorInputMode_GameMode then
			FGlobal_AlchemyStone_Use()
			return
		elseif inputMode == IM.eProcessorInputMode_UiMode or inputMode == IM.eProcessorInputMode_UiControlMode then
			if UIMode.eUIMode_Default == _uiMode then
				FGlobal_AlchemyStone_Use()
				return
			end
		end

	elseif Panel_PcRoomNotify:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) or GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_PcRoomNotifyClose()
			GlobalKeyBinder_Clear()
			return
		end

	elseif Panel_Introduction:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_Introcution_TooltipHide()
			return
		end

	elseif Panel_ChallengePresent:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
			FGlobal_ChallengePresent_AcceptReward()
			GlobalKeyBinder_Clear()
			return
		end

	elseif Panel_Win_Check:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) or GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) then	--  점프와 겹치는 문제를 수정할 수 없음.
			MessageBoxCheck.keyProcessEnter()
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)
			GlobalKeyBinder_Clear()
			return;
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			MessageBoxCheck.keyProcessEscape()
			GlobalKeyBinder_Clear()
			return;
		end

	elseif Panel_Window_Guild:GetShow() then
		if FGolbal_Guild_Recruitment_SelectPlayerCheck() then
			if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
				FGolbal_Guild_Recruitment_SelectPlayerClose()
				GlobalKeyBinder_Clear()
				return
			end
		-- elseif (not Panel_Chatting_Input:GetShow()) and (GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) or GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_Guild )) then
		-- 	-- ♬ 창 끌 때 소리난다요
		-- 	audioPostEvent_SystemUi(01,31)
		-- 	GuildManager:Hide()--FGlobal_guildWindow_Hide()
		-- 	if( false == check_ShowWindow() ) then
		-- 		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		-- 	end
		-- 	GlobalKeyBinder_Clear()
		-- 	return
		end

	elseif ( nil ~= getSelfPlayer() and getSelfPlayer():get():isShowWaitComment() ) then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			EventSelfPlayerWaitCommentClose();
			return;
		end

	elseif UIMode.eUIMode_Housing == _uiMode then
		--UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_Housing( deltaTime )		
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_Mental == _uiMode then
	    if ( inputMode == IM.eProcessorInputMode_ChattingInputMode ) then
			_keyBinder_Chatting( deltaTime )
			GlobalKeyBinder_Clear()
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			_keyBinder_UIMode_Mental( deltaTime )
			GlobalKeyBinder_Clear()
		end
		return;
	elseif UIMode.eUIMode_MentalGame == _uiMode then
		if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_LEFT) or GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_A) then
			MentalKnowledge_CardRotation_Left()
		elseif GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_RIGHT) or GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_D) then
			MentalKnowledge_CardRotation_Right()
		end
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_MentalGame( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_InGameCustomize == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_InGameCustomize( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_InGameCashShop == _uiMode then
		if ( inputMode == IM.eProcessorInputMode_ChattingInputMode ) then
			_keyBinder_Chatting( deltaTime )
			GlobalKeyBinder_Clear()
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			_keyBinder_UIMode_InGameCashShop( deltaTime )
			GlobalKeyBinder_Clear()
		end
		return;
	elseif UIMode.eUIMode_DyeNew == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_Dye( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_ItemMarket == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)
		_keyBinder_UIMode_ItemMarket( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_NpcDialog == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_NpcDialog( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_NpcDialog_Dummy == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		-- do Nothing!!
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_Trade == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_Trade( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_Stable == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_Stable( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_WorldMap == _uiMode then
	    if ( inputMode == IM.eProcessorInputMode_ChattingInputMode and not Panel_Window_ItemMarket:GetShow()) then	-- 월드맵, 거래소가 안열린상태
			_keyBinder_Chatting( deltaTime )
			GlobalKeyBinder_Clear()
		else
    		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			_keyBinder_UIMode_WorldMap( deltaTime )
			GlobalKeyBinder_Clear()
		end
		return;

	elseif UIMode.eUIMode_WoldMapSearch == _uiMode then
			_keyBinder_WorldMapSearch( deltaTime )
			GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_MiniGame == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		_keyBinder_UIMode_MiniGame( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_DeadMessage == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_DeadMessage( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_PreventMoveNSkill == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_PreventMoveNSkill( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_Movie == _uiMode then	
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		_keyBinder_UIMode_Movie( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_GameExit == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)
		--UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_GameExit( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_Repair == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_Repair( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_Extraction== _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_Extraction( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_KeyCustom_Wait == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_KeyCustom)
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_KeyCustom_ActionKey == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_KeyCustomizing)
		_keyBinder_UIMode_KeyCustom_ActionKey( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_KeyCustom_ActionPad == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_KeyCustomizing)
		_keyBinder_UIMode_KeyCustom_ActionPad( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_KeyCustom_UiKey == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_KeyCustomizing)
		_keyBinder_UIMode_KeyCustom_UiKey( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_KeyCustom_UiPad == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_KeyCustomizing)
		_keyBinder_UIMode_KeyCustom_UiPad( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_KeyCustom_ActionPadFunc1 == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_KeyCustomizing)
		_keyBinder_UIMode_KeyCustom_ActionPadFunc1( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_KeyCustom_ActionPadFunc2 == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_KeyCustomizing)
		_keyBinder_UIMode_KeyCustom_ActionPadFunc2( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_PopupItem == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_keyBinder_UIMode_PopupItem()
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_ProductNote == _uiMode then
		--UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		_keyBinder_UIMode_ProductNote( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_QnAWebLink == _uiMode then
		--UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		_keyBinder_UIMode_QnAWebLink( deltaTime )
		GlobalKeyBinder_Clear()
		return;
	elseif UIMode.eUIMode_TradeGame == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_KeyBinder_UIMode_TradeGame( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_Cutscene == _uiMode then
		_KeyBinder_UIMode_CutSceneMode( deltaTime );
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_UiSetting == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		_KeyBinder_UIMode_UiSetting( deltaTime )
		GlobalKeyBinder_Clear()
		return
	-- elseif Panel_MovieTheater_LowLevel:GetShow() then
	-- 	Panel_MovieTheater_LowLevel_WindowClose()
	-- 	GlobalKeyBinder_Clear()
	-- 	return
	elseif UIMode.eUIMode_EventNotify == _uiMode then
		_KeyBinder_UIMode_EventNotify( deltaTime )
		GlobalKeyBinder_Clear()
		return
	elseif UIMode.eUIMode_Gacha_Roulette == _uiMode then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)	-- 스페이스바를 먹는다.
		_KeyBinder_UIMode_Gacha_Roulette( deltaTime )
		GlobalKeyBinder_Clear()
		return
	end
	
	if Panel_RecentMemory:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			RecentMemory_Close()
			return
		end
	end
	
	if Panel_Party_ItemList:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			Panel_Party_ItemList_Close()
			return
		end
	end

	if Panel_LocalWarInfo:IsShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			FGlobal_LocalWarInfo_Close()
			return
		end
	end
	
	if(true == _ChattingMacro_Process()) then
		return 
	end
	
	if inputMode == IM.eProcessorInputMode_GameMode then
		-- GameMode 일때 컨트롤 창이 켜져 있으면 끄기!
		if Panel_UIControl:IsShow() then
			-- breakPointfuncForCpp(Panel_UIControl)
			Panel_UIControl_SetShow( false 	)			-- 컨트롤 창 끄기
			Panel_Menu_ShowToggle()			
		elseif Panel_PartyOption:GetShow() then
			PartyOption_Hide()
		end
		
		_keyBinder_GameMode( deltaTime )
		_keyBinder_UIMode_CommonWindow( deltaTime )
		_SkillkeyBinder_UIMode_CommonWindow( deltaTime )

	elseif inputMode == IM.eProcessorInputMode_UiMode or inputMode == IM.eProcessorInputMode_UiControlMode then
		_keyBinder_UIMode( deltaTime )

		if UIMode.eUIMode_Default == _uiMode then
			_keyBinder_UIMode_CommonWindow( deltaTime )
			_SkillkeyBinder_UIMode_CommonWindow( deltaTime )
		end

	elseif	inputMode == IM.eProcessorInputMode_ChattingInputMode then
		_keyBinder_Chatting( deltaTime )
	elseif	inputMode == IM.eProcessorInputMode_MailInputMode then
		_keyBinder_Mail( deltaTime )
	elseif	inputMode == IM.eProcessorInputMode_UiModeNotInput then
		_keyBinder_UiModeNotInput( deltaTime )
	end
	GlobalKeyBinder_Clear()
end

registerEvent("EventGlobalKeyBinder",	"GlobalKeyBinder_Update")

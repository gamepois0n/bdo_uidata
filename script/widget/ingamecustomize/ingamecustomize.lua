function IngameCustomize_Show()
	ToClient_SaveUiInfo( true )
	
	if( isFlushedUI() ) then
		return
	end
	
	local terraintype = selfPlayerNaviMaterial()	-- 물이나 공중에서 열 수 없다.
	if 8 == terraintype or 9 == terraintype then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DONTOPEN_INWATER") ) -- "물 속에서 이용할 수 없습니다." )
		return
	end

	-- 상용화 체크
	if not FGlobal_IsCommercialService() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTUSE") ) -- "아직 이용할 수 없습니다.")
		return
	end
	
	-- if not IsSelfPlayerWaitAction() then
	-- 	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_CUSTOMIZING") )
	-- 	return
	-- end
	if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
		return
	end
	if ( nil == getCustomizingManager() ) then
		return
	end

	if ( true == getCustomizingManager():isShow() ) then
		return
	end

	local isShowSuccess = getCustomizingManager():show()
	if ( false == isShowSuccess ) then
		return
	end

	audioPostEvent_SystemUi(01,02)
	SetUIMode(Defines.UIMode.eUIMode_InGameCustomize)
	UI.flushAndClearUI()
end

function IngameCustomize_Hide()
	if ( nil == getCustomizingManager() ) then
		return
	end

	if ( false == getCustomizingManager():isShow() ) then
		return
	end

	if( true == isChangedCustomizationData() ) then
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_INGAMECUSTOMIZATION_MSGBOX_CANCEL")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = HandleClicked_CloseIngameCustomization, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		HandleClicked_CloseIngameCustomization()
	end
end

function HandleClicked_CloseIngameCustomization()
	CloseCharacterCustomization()
	getCustomizingManager():hide()
	UI.restoreFlushedUI()
	-- FGlobal_MovieGuide_Reposition()
	SetUIMode(Defines.UIMode.eUIMode_Default)	
	Panel_Chat0:SetShow( true )
end

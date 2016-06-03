----------------------------------------------------------------------------------------------------
-- Common

----------------------------------------------------------------------------------------------------
-- Dialog Scene Function
function	Servant_SceneOpen( panel )
	SetUIMode( Defines.UIMode.eUIMode_Stable )
	setIgnoreShowDialog( true )
	
	UIAni.fadeInSCR_Down( panel )
	
	Panel_Npc_Dialog:SetShow( false )
		
	local	npcKey	= dialog_getTalkNpcKey()
	if	( 0 == npcKey)	then
		return
	end
	
	openClientChangeScene( npcKey, 1 )

	local	funcCameraName	= Dialog_getFuncSceneCameraName()
	changeCameraScene( funcCameraName, 0.5 )
	
	panel:SetShow( true )
end

function	Servant_SceneClose( panel )
	SetUIMode( Defines.UIMode.eUIMode_NpcDialog )
	setIgnoreShowDialog( false )
	
	UIAni.fadeInSCR_Down( panel )
	
	panel:SetShow( false )
	
	local	npcKey	= dialog_getTalkNpcKey()
	if	( 0 ~= npcKey )	then
		closeClientChangeScene( npcKey )
	end
	
	local	mainCameraName	= Dialog_getMainSceneCameraName()
	changeCameraScene( mainCameraName, 0.5 )
	
	Panel_Npc_Dialog:SetShow(true)
end
--------
--------------------------------------------------------------------------------------------
-- Dialog Scene Object Function
function	Servant_ScenePushObject( servantInfo, beforeSceneIndex )
	if	nil == servantInfo	then
		return
	end

	local	characterKeyRaw = servantInfo:getCharacterKeyRaw()
	local	afterSceneIndex	= getIndexByCharacterKey(characterKeyRaw)

	if	( beforeSceneIndex == afterSceneIndex )	then
		return(beforeSceneIndex)
	end
		
	if	( -1 ~= beforeSceneIndex )	then
		showSceneCharacter( beforeSceneIndex, false )
	end
	
	if	( -1 ~= afterSceneIndex )	then
		showSceneCharacter( afterSceneIndex, true )
		
		if	( not isGuildStable() )	then
			stable_previewEquipItem( afterSceneIndex )
		end
	end
	
	return(afterSceneIndex)
end

function	Servant_ScenePopObject( sceneIndex )
	if	( -1 ~= sceneIndex )	then
		showSceneCharacter( sceneIndex, false )
	end
end

----------------------------------------------------------------------------------------------------
-- Inventory Function
function	Servant_InventoryClose()
	Inventory_SetFunctor( nil )
end

function	InvenFiler_Mapae( slotNo, itemWrapper )
	if nil == itemWrapper then
		return( true )
	end
	local itemSSW = itemWrapper:getStaticStatus()
	if nil == itemSSW then
		return
	end
	local returnValue = true
	local isMapae = itemSSW:get():isMapae()
	local itemKey = itemWrapper:get():getKey():getItemKey()

	-- 길드 마구간과 일반 마구간에서의 마패 필터링 구분. 50007은 코끼리 마패의 아이템키값.
	if isGuildStable() then
		if isMapae and 50007 == itemKey then
			returnValue = true
		else
			returnValue = false
		end
	else
		if isMapae and 50007 ~= itemKey then
			returnValue = true
		else
			returnValue = false
		end
	end
	return(not returnValue)
end
function	EffectFilter_Mapae( slotNo, itemWrapper )
	if nil == itemWrapper then
		return( true )
	end
	local itemSSW = itemWrapper:getStaticStatus()
	if nil == itemSSW then
		return
	end
	local returnValue = true
	local isMapae = itemSSW:get():isMapae()
	local itemKey = itemWrapper:get():getKey():getItemKey()

	-- 길드 마구간과 일반 마구간에서의 마패 필터링 구분. 50007은 코끼리 마패의 아이템키값.
	if isGuildStable() then
		if isMapae and 50007 == itemKey then
			returnValue = true
		else
			returnValue = false
		end
	else
		if isMapae and 50007 ~= itemKey then
			returnValue = true
		else
			returnValue = false
		end
	end
	return(not returnValue)
end

----------------------------------------------------------------------------------------------------
-- Message Box Confirm
function	Servant_Confirm( strTitle, strMessage, functionYes, functionNo )
	local messageboxData	= { title = strTitle, content = strMessage, functionYes = functionYes, functionCancel = functionNo, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData, "top")
end

----------------------------------------------------------------------------------------------------
-- Effect
function	Mapae_SetEffect()
	return( "fUI_HorseNameCard01" )
end

-- Auto Use Servant Item
--

-- registerEvent("EventSelfServantUpdate",			"OnEventSelfServantUpdate")
-- registerEvent("EventSelfPlayerRideOn",			"OnEventSelfServantUpdate"	)
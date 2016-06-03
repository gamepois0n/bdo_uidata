Panel_Working_Progress:setMaskingChild(true)
Panel_Working_Progress:setGlassBackground(true)
Panel_Working_Progress:TEMP_UseUpdateListSwap(true)

--[[
getPlantByRawKey( plantKeyRaw ) -- 숫자(raw) ==>> plant


plant:getType()  -- 제대로 작동할지 ...( 의문 )
    - 0 : 타운
    - 1 : 존
    - 2 : 하우스
    

getWorkingList( plant )
	- 일하고있는 일꾼 숫자 반환 ( 먼저 콜해야됨 )
	
getWorkingByIndex(index)  ==>> "NpcWorkerWorking"   .workerNo 있음
	
	local count = getWorkingList()
	for index =  ... 
	    local workingWorker = getWorkingByIndex( index )


getWorkingIcon( workerNo ) -- 일하고있는 아이콘 패스
getWorkingProgress( workerNo ) --일하고있는 진행률 ( 0~1 ) 잘못된 데이터 입력시 -1반환

]]

local UI_TM 		= CppEnums.TextMode
local UI_PP 		= CppEnums.PAUIMB_PRIORITY
local VCK 			= CppEnums.VirtualKeyCode

local isFale_Init = false
local waitingCancelWorkerNo = {}
eWorkType = 
{
	plant				= 1,
	craft				= 2,
	changeHouseUseType	= 3,
	largeCraft			= 4,
}

local WorkingProgress =
{
	_itemicon 			= UI.getChildControl( Panel_Working_Progress, "Static_Resource_Icon" ),
	_itemicon_BG		= UI.getChildControl( Panel_Working_Progress, "Static_IconBG" ),
	_progressGauge 		= UI.getChildControl( Panel_Working_Progress, "Progress2_H_Cons_Gauge" ),
	_progressText	 	= UI.getChildControl( Panel_Working_Progress, "StaticText_Progress" ),
	_remainTimeText	 	= UI.getChildControl( Panel_Working_Progress, "StaticText_leftTime_Vlaue" ),	
	_txt_WorkName	 	= UI.getChildControl( Panel_Working_Progress, "StaticText_WorkName" ),
	_btnClose		 	= UI.getChildControl( Panel_Working_Progress, "Button_Close" ),
	_btnCancelWork	 	= UI.getChildControl( Panel_Working_Progress, "Button_cancelWork" ),
	_btnImmediately		= UI.getChildControl( Panel_Working_Progress, "Button_Immediately" ),
	_workerName			= UI.getChildControl( Panel_Working_Progress, "StaticText_Worker" ),
	
	_workType			= nil,
	_worker				= nil,
	_workerNo			= nil,
	_node				= nil,
	_saveProgress		= 0,
	_saveIcon			= nil,
	_workingProgress	= 0,
	_remainTime			= 0,
	_updateCount 		= 0,
	
	_itemKey_Tooltip	= nil,
}

WorkingProgress._btnImmediately:SetShow(false)		-- 상용화가 아닌데 켜져 있음. 일단 막음 (who1310)
WorkingProgress._txt_WorkName:SetTextMode( UI_TM.eTextMode_LimitText )

function WorkingProgress_Init()
	local node			= WorkingProgress._node
	local workType		= WorkingProgress._workType
	local workingcnt	= -1

	if ( eWorkType.plant == workType ) then
		workingcnt = ToClient_getPlantWorkingList( node:getPlantKey() )
	elseif ( eWorkType.craft == workType ) then
		workingcnt 		= ToClient_getHouseWorkingWorkerList( node )
	end
		
	if workingcnt == 0 then
		isFale_Init = true
	end
		
	for idx = 0 , workingcnt - 1 , 1 do
		local worker 		= nil
		local workerNo 		= nil
		local workingIcon 	= "";
		local workName 		= "";
		
		if ( eWorkType.plant == workType ) then
			local exploreLevel	= node:getLevel()
			local plantKey	= node:getPlantKey()
			local plant		= ToClient_getPlant(plantKey)
			local nod_Key 		= plantKey:get()
			local PlantType = CppEnums.PlantType
			if exploreLevel > 0 and plant ~= nil and plant:getType() == PlantType.ePlantType_Zone then
				worker = ToClient_getPlantWorkingWorkerByIndex( node:getPlantKey(), idx ).workerNo
				workerNo = worker:get_s64()
				local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
				if esSSW:isSet() then
					workingIcon = esSSW:getIcon()
					if 0 < ToClient_getNpcWorkerWorkingCount( workerNo ) then
						workName 	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKING_PROGRESS_WORKNAME", "getDescription", esSSW:getDescription(), "workerNo", ToClient_getNpcWorkerWorkingCount(workerNo) ) -- esSSW:getDescription() .. " (" .. ToClient_getNpcWorkerWorkingCount( workerNo ) .. "회 남음)"
					else
						workName 	= esSSW:getDescription()
					end
				end

				local explorationSSW = ToClient_getExplorationStaticStatusWrapper(nod_Key)
				if ( explorationSSW:get():isFinance() ) then
					WorkingProgress._txt_WorkName		:SetText(workName)
					WorkingProgress._itemicon			:addInputEvent("Mouse_On","Craft_Show_Tooltip_Work(" .. idx .. ")")
					WorkingProgress._itemicon			:addInputEvent("Mouse_Out","Craft_Hide_Tooltip_Work(" .. idx .. ")")

					--자산관리는 노드의 기본성질로 인해 한명밖에 일꾼 처리가 안됨 고로 아래 코드를 그냥 넣음.
					Panel_Working_Progress_ImmediatelyShowUpdate(true)
				else
					local esSS		= ToClient_getPlantWorkableItemExchangeByIndex(node:getPlantKey(), idx)
					WorkingProgress._txt_WorkName		:SetText(workName)
					WorkingProgress._itemKey_Tooltip = esSS:getFirstDropGroup()._itemKey

					WorkingProgress._itemicon			:addInputEvent("Mouse_On","Plant_Tooltip_Item_Show()")
					WorkingProgress._itemicon			:addInputEvent("Mouse_Out","Panel_Tooltip_Item_hideTooltip()")
					Panel_Working_Progress_ImmediatelyShowUpdate(false)
				end			
			end
		elseif ( eWorkType.craft == workType ) then
			worker = ToClient_getHouseWorkingWorkerByIndex( node, idx ).workerNo
			workerNo = worker:get_s64()
			local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
			if esSSW:isSet() then
				workingIcon = esSSW:getIcon()
				workName 	= esSSW:getDescription()
				
				WorkingProgress._txt_WorkName		:SetText(workName)
				WorkingProgress._itemicon			:addInputEvent("Mouse_On","Craft_Show_Tooltip_Work(" .. idx .. ")")
				WorkingProgress._itemicon			:addInputEvent("Mouse_Out","Craft_Hide_Tooltip_Work(" .. idx .. ")")
			end
		end

		WorkingProgress._itemicon			:ChangeTextureInfoName("icon/" .. workingIcon)
		WorkingProgress._saveIcon = workingIcon
		WorkingProgress._worker = worker
		WorkingProgress._workerNo = workerNo
	end		
end

function WorkingProgressUpdate()
	local node = WorkingProgress._node
	local workType = WorkingProgress._workType
	local workingcnt = -1
	WorkingProgress._updateCount = WorkingProgress._updateCount + 1

	if ( eWorkType.plant == workType ) then
		workingcnt = ToClient_getPlantWorkingList( node:getPlantKey() )
	elseif ( eWorkType.craft == workType ) then				
		workingcnt 	= ToClient_getHouseWorkingWorkerList( node )
	else
		--WorldMapWindow_CloseNodeMenu()
		return
	end
	
	if isFale_Init == true and workingcnt > 0 then
		WorkingProgress_Init()
		isFale_Init = false
	end
	
	--WorldMap_NodeIcon_WorkProgress_Hide(nodeKey)
	
	if ( nil == node ) then
		--WorldMapWindow_CloseNodeMenu()
		return
	end

	if	( 0 == workingcnt) and ( 0 ~= WorkingProgress._saveProgress) then
		local complete = 100
		WorkingProgress._progressText		:SetText(string.format("%3.1f%%", complete  ));
		WorkingProgress._progressGauge		:SetProgressRate(complete);
		WorkingProgress._itemicon			:ChangeTextureInfoName("icon/" .. WorkingProgress._saveIcon);	
		-- WorkingProgress._txt_ItemName		:SetText();	
		WorkingProgress._remainTimeText		:SetText( "--" );
		return
	elseif ( 0 == workingcnt) and ( 0 == WorkingProgress._saveProgress) then
		if ( 10 < WorkingProgress._updateCount ) then
			--WorldMapWindow_CloseNodeMenu()
		end		
		return
	elseif ( 5 > WorkingProgress._updateCount ) then  -- 초기 workingcnt 가 쓰레기 값으로 1이 들어간 경우를 걸러낸다.
		return
	end
	
	for idx = 0 , workingcnt - 1 , 1 do
		local worker = nil;
		
		if ( eWorkType.plant == workType ) then
			worker = ToClient_getPlantWorkingWorkerByIndex( node:getPlantKey(), idx ).workerNo
		elseif ( eWorkType.craft == workType ) then		
			worker = ToClient_getHouseWorkingWorkerByIndex( node, idx ).workerNo
		end
		
		local workerNo = worker:get_s64()
		local workStringNo = tostring(workerNo)
		if true == waitingCancelWorkerNo[workStringNo] then
			WorkingProgress._btnCancelWork:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKING_PROGRESS_CANCELRESERVE") ) -- "취소예약")
			WorkingProgress._btnCancelWork:SetEnable( false )
			WorkingProgress._btnCancelWork:SetMonoTone( true )
		else
			waitingCancelWorkerNo[workStringNo] = nil
			WorkingProgress._btnCancelWork:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKING_PROGRESS_WORKCANCEL") ) -- "작업취소")
			WorkingProgress._btnCancelWork:SetEnable( true )
			WorkingProgress._btnCancelWork:SetMonoTone( false )
		end

		local workerDATA			= ToClient_getNpcWorkerByWorkerNo( workerNo )
		local workerStaticStatus	= workerDATA:get():getWorkerStaticStatus()
		local workerName			= workerDATA:getName()
		local workerGrade			= workerStaticStatus:getCharacterStaticStatus()._gradeType:get()
		local workerLev				= "Lv."..workerDATA:get():getLevel()

		WorkingProgress._workingProgress = ToClient_getWorkingProgress( workerNo ) * 100000	 	-- 작업 시작 시 받는 getWorkingProgress() 값은 항상 쓰레기 값이 온다! (Fix가 필요함!)
		WorkingProgress._remainTime = Util.Time.timeFormatting( ToClient_getLeftWorkingTime( workerNo ) )
		WorkingProgress._workerName			:SetText( workerLev .. " " .. ConvertFromGradeToColor(workerGrade, true) .. workerName .. "<PAOldColor>" )
		WorkingProgress._progressText		:SetText(string.format("%3.1f%%", WorkingProgress._workingProgress  ) )
		WorkingProgress._progressGauge		:SetProgressRate(WorkingProgress._workingProgress)
		WorkingProgress._remainTimeText		:SetPosX( WorkingProgress._progressText:GetPosX() + WorkingProgress._progressText:GetTextSizeX() )
		WorkingProgress._remainTimeText		:SetText( "<PAColor0xFFC4BEBE>: <PAOldColor>" .. WorkingProgress._remainTime )

		WorkingProgress._workerName			:addInputEvent("Mouse_On",	"WorkingProgress_WorkerTooltip( true )")
		WorkingProgress._workerName			:addInputEvent("Mouse_Out",	"WorkingProgress_WorkerTooltip( false )")

		WorkingProgress._saveProgress = WorkingProgress._workingProgress
	end	
end

function WorkingProgress_WorkerTooltip( isShow )
	if true == isShow then
		local workType = WorkingProgress._workType
		local node = WorkingProgress._node

		if ( eWorkType.plant == workType ) then
			worker = ToClient_getPlantWorkingWorkerByIndex( node:getPlantKey(), 0 ).workerNo
		elseif ( eWorkType.craft == workType ) then
			worker = ToClient_getHouseWorkingWorkerByIndex( node, 0 ).workerNo
		end
		local workerNo		= worker:get_s64()
		local workerDATA	= ToClient_getNpcWorkerByWorkerNo( workerNo )

		FGlobal_ShowWorkerTooltipByWorkerNoRaw( workerNo, WorkingProgress._workerName )
		-- FGlobal_ShowWorkerTooltip( workerDATA:get(), WorkingProgress._workerName )
	else
		FGlobal_HideWorkerTooltip()
	end
end

function Plant_Tooltip_Item_Show()
	local itemKey = WorkingProgress._itemKey_Tooltip
	if itemKey == nil then
		return
	end
	local staticStatusWrapper = getItemEnchantStaticStatus( itemKey )
	local uiBase = WorkingProgress._itemicon_BG
	Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end

function Craft_Show_Tooltip_Work(idx)
	if isKeyPressed( VCK.KeyCode_CONTROL ) then
		Keep_Tooltip_Work = true
		return
	end
	
	local node = WorkingProgress._node
	local workType = WorkingProgress._workType
	local esSSW = nil
	if ( eWorkType.plant == workType ) then
			worker = ToClient_getPlantWorkingWorkerByIndex( node:getPlantKey(), idx ).workerNo
			workerNo = worker:get_s64()
			esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
	elseif ( eWorkType.craft == workType ) then
			worker = ToClient_getHouseWorkingWorkerByIndex( node, idx ).workerNo
			workerNo = worker:get_s64()
			esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
	end
	
	if esSSW:isSet() then
		local uiBase = WorkingProgress._itemicon_BG
		FGlobal_Show_Tooltip_Work(esSSW, uiBase, nil, nil, node:getPlantKey())
	end
end

function Craft_Hide_Tooltip_Work(idx)
	if isKeyPressed( VCK.KeyCode_CONTROL ) then
		return
	end
	FGlobal_Hide_Tooltip_Work(idx, true)
end

function WorkingProgress_CancelWork()
	local node				= WorkingProgress._node
	local plantKey			= node:getPlantKey()
	local nod_Key			= plantKey:get()
	local explorationSSW	= ToClient_getExplorationStaticStatusWrapper(nod_Key)
	local worker			= WorkingProgress._worker
	local _workerNo 		= worker:get_s64()

	if explorationSSW:get():isFinance() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKING_PROGRESS_FINANCE_ACK") ) -- "자산 관리소는 작업을 취소할 수 없습니다." )
		return
	end

	local _leftWorkCount	= ToClient_getNpcWorkerWorkingCount(_workerNo)
	if _leftWorkCount < 1 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_WORKING_PROGRESS_LEFTWORKCOUNT_ACK") ) -- "1회 작업은 취소할 수 없습니다." )
		return
	else
		local esSSW 	= ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(_workerNo)
		local workName 	= esSSW:getDescription()
		
		local cancelWorkContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CANCELWORK_CONTENT", "workName", workName)
		local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CANCELWORK_TITLE" ), content = cancelWorkContent , functionYes = WorkingProgress_CancelWork_Continue, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData, "middle")
	end
end

function WorkingProgress_CancelWork_Continue()
	ToClient_requestCancelNextWorking(WorkingProgress._worker)

	-- local isSuccess = ToClient_requestStopPlantWorking(WorkingProgress._worker)
end

function WorkingProgress_Immediately()
	local worker = WorkingProgress._worker
	local workerNo = worker:get_s64()
	local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
	if esSSW:isSet() then
		local workName 	= esSSW:getDescription()
		local _remainTimeInt = ToClient_getWorkingTime( workerNo )
		local _needPearl = ToClient_GetUsingPearlByRemainingPearl(CppEnums.InstantCashType.eInstant_CompleteNpcWorking, _remainTimeInt)
		local messageboxTitle	= PAGetString( Defines.StringSheet_GAME, "LUA_HOUSECONTROL_IMMEDIATELYCOMPLETE_MSGBOX_TITLE" )
		local messageBoxMemo	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORLDMAP_WORKDING_PROGRESS_IMMEDIATELY", "workName", workName, "needPearl", tostring(_needPearl) ) -- "[ ".. workName .. " ]\n" .. tostring(_needPearl) .. " 펄을 사용해서 즉시 완료 하시겠습니까?"
		local messageboxData = { title = messageboxTitle, content = messageBoxMemo , functionYes = WorkingProgress_ImmediatelyYes, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData, "middle")
	end
end

function WorkingProgress_ImmediatelyYes()
	local worker = WorkingProgress._worker
	local workerNo = worker:get_s64()
	local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
	if esSSW:isSet() then
		local _remainTimeInt = ToClient_getWorkingTime( workerNo )
		local _needPearl = ToClient_GetUsingPearlByRemainingPearl(CppEnums.InstantCashType.eInstant_CompleteNpcWorking, _remainTimeInt)

		ToClient_requestQuickComplete(WorkingProgress._worker, _needPearl)
	end
end
	    
function WorkingProgress_After_CancelWork(workerNo, isUserRequest)
	if WorkingProgress._workerNo ~= workerNo or false == Panel_Working_Progress:GetShow() then
		return
	end
	
	local node = WorkingProgress._node
	local workType = WorkingProgress._workType

	HideWorkingProgress()
	if workType == eWorkType.plant then	-- 취소한 일꾼은 리스트에 표시가 안된다. (Refresh 하는 Event가 필요하다!)
		local exploreLevel	= node:getLevel()
		local plantKey	= node:getPlantKey()
		local plant		= ToClient_getPlant(plantKey)
		local nod_Key 		= plantKey:get()
		local PlantType = CppEnums.PlantType
		if exploreLevel > 0 and plant ~= nil and plant:getType() == PlantType.ePlantType_Zone then
			local explorationSSW = ToClient_getExplorationStaticStatusWrapper(nod_Key)
			if ( explorationSSW:get():isFinance() ) then
				FGlobal_Finance_WorkManager_Open(FGlobal_SelectedNode())
			else
				FGlobal_Plant_WorkManager_Open(FGlobal_SelectedNode())
			end
		end
	end
end

function FGlobal_ShowWorkingProgress(nodeInfo, workType)
	if workerManager_CheckWorkingOtherChannel() then
		return
	end
	
	if ( nil == nodeInfo ) then
		return
	end
	WorldMapPopupManager:push( Panel_Working_Progress, true )
	
	WorkingProgress._node = nodeInfo
	WorkingProgress._workingProgress = 0
	WorkingProgress._saveProgress = 0
	WorkingProgress._updateCount = 0
	WorkingProgress._workType = workType

	if WorkingProgress._workType == eWorkType.plant or WorkingProgress._workType == eWorkType.craft then
		WorkingProgress._btnCancelWork:SetShow(true)
	elseif WorkingProgress._workType == eWorkType.changeHouseUseType then
		WorkingProgress._btnCancelWork:SetShow(false)
	end
	
	isFale_Init = false
	WorkingProgress_Init()
	WorkingProgressUpdate()
	Panel_Working_Progress:SetShow(true,false)
end

function	HideWorkingProgress()
	Panel_Working_Progress					:SetShow(false)
	WorkingProgress._workType = nil
	WorkingProgress._itemKey_Tooltip = nil
	WorkingProgress._node = nil
	WorkingProgress._saveProgress = 0
	WorkingProgress._updateCount = 0
	isFale_Init = false
end

function	Panel_Working_Progress_ImmediatelyShowUpdate( isForceOff )
	-- 상용화 기간 체크
	if ( false )  then
		WorkingProgress._btnImmediately:SetShow( not isForceOff and FGlobal_IsCommercialService() )
	end
end

function FromClient_changeLeftWorkingProgress( workerNo )
	local workStringNo = tostring(workerNo)
	waitingCancelWorkerNo[workStringNo] = true
end

function FromClient_WorkerDataUpdate_Reflesh(explorationNode, workerNoRaw)
	--강제로 횟수 리플래쉬 하기위해서 코드 넣음.
	isFale_Init = true
	workingcnt = 1
	local workStringNo = tostring(workerNoRaw)
	waitingCancelWorkerNo[workStringNo] = nil
end

Panel_Working_Progress_ImmediatelyShowUpdate( false )
WorkingProgress._btnClose		:addInputEvent("Mouse_LUp","HideWorkingProgress()");
WorkingProgress._btnCancelWork	:addInputEvent("Mouse_LUp","WorkingProgress_CancelWork()");
WorkingProgress._btnImmediately	:addInputEvent("Mouse_LUp","WorkingProgress_Immediately()");
Panel_Working_Progress			:RegisterUpdateFunc("WorkingProgressUpdate")
registerEvent("WorldMap_StopWorkerWorking",		"WorkingProgress_After_CancelWork")
registerEvent("FromClient_changeLeftWorking",	"FromClient_changeLeftWorkingProgress")
registerEvent("WorldMap_WorkerDataUpdate",		"FromClient_WorkerDataUpdate_Reflesh")

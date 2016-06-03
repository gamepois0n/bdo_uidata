Panel_WorkerManager:SetShow( false )
Panel_WorkerManager:setGlassBackground( true )
Panel_WorkerManager:ActiveMouseEventEffect( true )

local UI_TM 	= CppEnums.TextMode
local UI_PP 	= CppEnums.PAUIMB_PRIORITY
local UI_Color 	= Defines.Color
-- local UI_PD		+ CppEnums.Padding

local workerManager = {
	plantKey			= nil,
	slotFixMaxCount		= 6,
	slotMaxCount		= 6,
	slot				= {},
	startPosY			= 5,
	_startIndex			= 1,
	_listCount			= 0,

	penelTitle			= UI.getChildControl( Panel_WorkerManager, "titlebar_manageWorker" ),
	workerListBg		= UI.getChildControl( Panel_WorkerManager, "Static_WorkerList_BG" ),
	_scroll				= UI.getChildControl( Panel_WorkerManager, "WorkerList_ScrollBar" ),
	_btnClose			= UI.getChildControl( Panel_WorkerManager, "Button_Close" ),
	_btnFire			= UI.getChildControl( Panel_WorkerManager, "button_doWorkerFire" ),
	_btnUpgradeNow		= UI.getChildControl( Panel_WorkerManager, "button_UpgradeNow" ),
	_restoreAll			= UI.getChildControl( Panel_WorkerManager, "Button_Restore_All" ),
	_reDoAll			= UI.getChildControl( Panel_WorkerManager, "Button_ReDo_All" ),
	
	restoreItemMaxCount	= 5,
	restoreItemHasCount	= 0,
	restoreItemSlot		= {},
	selectedRestoreWorkerIdx	= 0,
	selectedUiIndex		= -1,
	sliderStartIdx		= 0,
	upgradeWokerNoRaw	= -1,

	restoreItemBG		= UI.getChildControl( Panel_WorkerManager, "Static_Restore_Item_BG" ),
	btn_restoreItemClose= UI.getChildControl( Panel_WorkerManager, "Button_Close_Item" ),
	_slider				= UI.getChildControl( Panel_WorkerManager, "Slider_Restore_Item" ),
	guideRestoreAll		= UI.getChildControl( Panel_WorkerManager, "StaticText_Guide_RestoreAll" ),

	desc				= UI.getChildControl( Panel_WorkerManager, "StaticText_Description"),

	slotConfig			= {
		createIcon		= true,
		createBorder	= false,
		createCount		= true,
		createCash		= true
	},
}
workerManager._scrollBtn            = UI.getChildControl( workerManager._scroll, "Frame_ScrollBar_thumb" )
workerManager._sliderBtn			= UI.getChildControl( workerManager._slider, "Slider_Restore_Item_Button" )
local workerArray	= Array.new()

function workerManager:registEventHandler()
	self._btnClose	         	 :addInputEvent("Mouse_LUp", 		"workerManager_Close()")
	self._btnFire				:addInputEvent("Mouse_LUp", 		"HandleClicked_workerManager_WaitWorkerFire()")
	self._btnUpgradeNow			:addInputEvent("Mouse_LUp", 		"HandleClicked_workerManager_WorkerUpgradeNow()")
	self._restoreAll			:addInputEvent("Mouse_LUp", 		"HandleClicked_workerManager_RestoreAll()")
	self._reDoAll				:addInputEvent("Mouse_LUp", 		"HandleClicked_workerManager_ReDoAll()")
	self.btn_restoreItemClose	:addInputEvent("Mouse_LUp", 		"HandleClicked_WorkerManager_RestoreItemClose()")
	self.restoreItemBG			:addInputEvent("Mouse_UpScroll",	"workerManager_SliderScroll( true )" )
	self.restoreItemBG			:addInputEvent("Mouse_DownScroll",	"workerManager_SliderScroll( false )" )
	self._slider				:addInputEvent("Mouse_LUp", 		"HandleLPress_WorkerManager_RestoreItemSlider()")

	Panel_WorkerManager:RegisterUpdateFunc("workerManager_FrameUpdate")
end
function workerManager:registMessageHandler()
	registerEvent("onScreenResize", 							"workerManager_ResetPos" )
	registerEvent("WorldMap_WorkerDataUpdate",					"FromClient_WorkerDataAllUpdate")
	registerEvent("WorldMap_StopWorkerWorking",					"Push_Worker_StopWork_Message")

	registerEvent("WorldMap_WorkerDataUpdate",					"FromClient_WorkerDataUpdate_HeadingPlant")
	registerEvent("WorldMap_WorkerDataUpdateByHouse",			"FromClient_WorkerDataUpdate_HeadingHouse")
	registerEvent("WorldMap_WorkerDataUpdateByBuilding",		"FromClient_WorkerDataUpdate_HeadingBuilding")
	registerEvent("WorldMap_WorkerDataUpdateByRegionManaging",	"FromClient_WorkerDataUpdate_HeadingRegionManaging")
	registerEvent("FromClient_UpdateLastestWorkingResult",		"Push_Work_ResultItem_Message")

	registerEvent("FromClient_changeLeftWorking",				"FromClient_changeLeftWorking")

	registerEvent("FromClient_AppliedChangeUseType", 			"FromClient_WorkerDataAllUpdate")
	registerEvent("FromClient_ReceiveReturnHouse", 				"FromClient_WorkerDataAllUpdate")

	registerEvent("FromClient_ChangeWorkerSkillNoOne", 			"FromClient_ChangeWorkerSkillNoOne")
	registerEvent("FromClient_ChangeWorkerSkillNo", 			"FromClient_ChangeWorkerSkillNo")
end

local workedWorker		= {}	-- 작업 완료 일꾼 배열
local workerCheckList	= {}	-- 일꾼 해고용 배열.
local workType			= {
	_HouseCraft = 0,
	_LargeCraft = 1,
	_PlantWork	= 2,
	_Building	= 3,
	_RegionWork	= 4,
	_upgrade	= 5,
	_harvest	= 6,
--	_Party		= 6,
}
local restoreWorkerNo = nil

local workerGrade =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_0"),			-- "어수룩한",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_1"),			-- "일반",
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_2"),			-- "숙련",
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_3"),			-- "전문",
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_4"),			-- "장인"
}


local workerManager_Initiallize = function()
	local self = workerManager
	-- 일꾼 슬롯
	for slotIdx = 0, self.slotMaxCount -1 do
		local tempSlot = {}
		tempSlot.bg				= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Static_workerBG",				self.workerListBg,	"workerManager_WorkerSlotBG_"							.. slotIdx )
		tempSlot.picture		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Static_WorkerPicture",			tempSlot.bg,		"workerManager_WorkerSlot_Picture_"						.. slotIdx )
		tempSlot.workerCheck	= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "button_worker_checkBox",		tempSlot.bg,		"workerManager_WorkerSlot_WorkerCheck_"					.. slotIdx )
		tempSlot.workerHpBG		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Static_RestorePointBG",		tempSlot.bg,		"workerManager_WorkerSlot_WorkerHpBG_"					.. slotIdx )
		tempSlot.workerRestorePT= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Progress2_RestorePoint",		tempSlot.bg,		"workerManager_WorkerSlot_WorkerRestorePT_"				.. slotIdx )
		tempSlot.workerCurrentPT= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Progress2_CurrentPoint",		tempSlot.bg,		"workerManager_WorkerSlot_WorkerCurrentPT_"				.. slotIdx )
		tempSlot.workerName		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "workerManage_workerName",		tempSlot.bg,		"workerManager_WorkerSlot_WorkerName_"					.. slotIdx )
		tempSlot.workerNodeName	= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "workerManage_workerNodeName",	tempSlot.bg,		"workerManager_WorkerSlot_WorkerNodeName_"				.. slotIdx )
		tempSlot.progressBg		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Static_ProgressBG",			tempSlot.bg,		"workerManager_WorkerSlot_ProgressBg_"					.. slotIdx )
		tempSlot.progress		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Progress2_RemainTime",			tempSlot.bg,		"workerManager_WorkerSlot_Progress_"					.. slotIdx )
		tempSlot.workingName	= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "workerManage_workingName",		tempSlot.bg,		"workerManager_WorkerSlot_WorkingName_"					.. slotIdx )
		tempSlot.btn_Restore	= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Button_WorkRestore",			tempSlot.bg,		"workerManager_WorkerSlot_BTN_WorkerRestore_"			.. slotIdx )
		tempSlot.btn_Upgrade	= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Button_WorkerUpgrade",			tempSlot.bg,		"workerManager_WorkerSlot_BTN_WorkerUpgrade_"			.. slotIdx )
		tempSlot.btn_ChangeSkill= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Button_WorkerChangeSkill",		tempSlot.bg,		"workerManager_WorkerSlot_BTN_WorkerChangeSkill_"		.. slotIdx )
		tempSlot.btn_Stop		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Button_WorkStop",				tempSlot.bg,		"workerManager_WorkerSlot_BTN_WorkStop_"				.. slotIdx )
		tempSlot.btn_Repeat		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Button_RepeatWork",			tempSlot.bg,		"workerManager_WorkerSlot_BTN_WorkRepeat_"				.. slotIdx )
		
		tempSlot.bg				:SetPosX( 5 )
		tempSlot.bg				:SetPosY( self.startPosY + ((tempSlot.bg:GetSizeY()+5) * slotIdx) )
		tempSlot.workerCheck	:SetPosX( 35 )
		tempSlot.workerCheck	:SetPosY( 32 )
		tempSlot.picture		:SetPosX( 5 )
		tempSlot.picture		:SetPosY( 3 )
		tempSlot.workerName		:SetPosX( 60 )
		tempSlot.workerName		:SetPosY( 3 )
		tempSlot.workerNodeName	:SetPosX( 185 )
		tempSlot.workerNodeName	:SetPosY( 2 )
		tempSlot.workerHpBG		:SetPosX( 58 )
		tempSlot.workerHpBG		:SetPosY( tempSlot.workerName:GetSizeY() + 1.5 )
		tempSlot.workerRestorePT:SetPosX( 58 )
		tempSlot.workerRestorePT:SetPosY( tempSlot.workerName:GetSizeY() + 5 )
		tempSlot.workerCurrentPT:SetPosX( 58 )
		tempSlot.workerCurrentPT:SetPosY( tempSlot.workerName:GetSizeY() + 5 )

		tempSlot.progressBg		:SetPosX( 58 )
		tempSlot.progressBg		:SetPosY( tempSlot.workerRestorePT:GetPosY() + tempSlot.workerRestorePT:GetSizeY()+ 7 )
		tempSlot.progress		:SetPosX( 58 )
		tempSlot.progress		:SetPosY( tempSlot.workerRestorePT:GetPosY() + tempSlot.workerRestorePT:GetSizeY()+ 8 )
		tempSlot.workingName	:SetPosX( 62 )
		tempSlot.workingName	:SetPosY( tempSlot.progressBg:GetPosY() - 2 )

		tempSlot.btn_Restore	:SetPosX( tempSlot.progressBg:GetPosX() + tempSlot.progressBg:GetSizeX() )
		tempSlot.btn_Restore	:SetPosY( (tempSlot.progressBg:GetPosY() + tempSlot.workerHpBG:GetPosY()) / 2.5 )

		tempSlot.btn_Stop		:SetPosX( tempSlot.btn_Restore:GetPosX() + tempSlot.btn_Restore:GetSizeX() + 2 )
		tempSlot.btn_Stop		:SetPosY( (tempSlot.progressBg:GetPosY() + tempSlot.workerHpBG:GetPosY()) / 2.5 )

		tempSlot.btn_Repeat		:SetPosX( tempSlot.btn_Restore:GetPosX() + tempSlot.btn_Restore:GetSizeX() + 2 )
		tempSlot.btn_Repeat		:SetPosY( (tempSlot.progressBg:GetPosY() + tempSlot.workerHpBG:GetPosY()) / 2.5 )

		tempSlot.btn_Upgrade	:SetPosX( tempSlot.btn_Repeat:GetPosX() + tempSlot.btn_Repeat:GetSizeX() )
		tempSlot.btn_Upgrade	:SetPosY( (tempSlot.progressBg:GetPosY() + tempSlot.workerHpBG:GetPosY()) / 2.5 )

		tempSlot.btn_ChangeSkill:SetPosX( tempSlot.btn_Upgrade:GetPosX() + tempSlot.btn_Upgrade:GetSizeX() + 2 )
		tempSlot.btn_ChangeSkill:SetPosY( (tempSlot.progressBg:GetPosY() + tempSlot.workerHpBG:GetPosY()) / 2.5 )

		tempSlot.bg				:addInputEvent(	"Mouse_UpScroll",	"workerManager_ScrollEvent( true )"		)
		tempSlot.bg				:addInputEvent(	"Mouse_DownScroll",	"workerManager_ScrollEvent( false )"	)
		tempSlot.workerName		:addInputEvent(	"Mouse_UpScroll",	"workerManager_ScrollEvent( true )"		)
		tempSlot.workerName		:addInputEvent(	"Mouse_DownScroll",	"workerManager_ScrollEvent( false )"	)
		tempSlot.workingName	:addInputEvent(	"Mouse_UpScroll",	"workerManager_ScrollEvent( true )"		)
		tempSlot.workingName	:addInputEvent(	"Mouse_DownScroll",	"workerManager_ScrollEvent( false )"	)
		tempSlot.progressBg		:addInputEvent(	"Mouse_UpScroll",	"workerManager_ScrollEvent( true )"		)
		tempSlot.progressBg		:addInputEvent(	"Mouse_DownScroll",	"workerManager_ScrollEvent( false )"	)
		tempSlot.progress		:addInputEvent(	"Mouse_UpScroll",	"workerManager_ScrollEvent( true )"		)
		tempSlot.progress		:addInputEvent(	"Mouse_DownScroll",	"workerManager_ScrollEvent( false )"	)
		tempSlot.btn_ChangeSkill:addInputEvent( "Mouse_UpScroll",	"workerManager_ScrollEvent( true )"		)
		tempSlot.btn_ChangeSkill:addInputEvent( "Mouse_DownScroll",	"workerManager_ScrollEvent( false )"	)

		self.slot[slotIdx] = tempSlot
	end
	self.workerListBg			:addInputEvent(	"Mouse_UpScroll",	"workerManager_ScrollEvent( true )"		)
	self.workerListBg			:addInputEvent(	"Mouse_DownScroll",	"workerManager_ScrollEvent( false )"	)

	UIScroll.InputEvent( workerManager._scroll, "workerManager_ScrollEvent" )

	-- 회복 음식 슬롯
	for resIdx = 0, self.restoreItemMaxCount - 1 do
		local tempItemSlot = {}
		tempItemSlot.slotBG			= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Static_Restore_Item_Icone_BG",			self.restoreItemBG,		"workerManager_restoreSlotBG_" .. resIdx )
		tempItemSlot.slotIcon		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "Static_Restore_Item_Icone",			tempItemSlot.slotBG,	"workerManager_restoreSlot_" .. resIdx )
		tempItemSlot.itemCount		= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "StaticText_Item_Count",				tempItemSlot.slotIcon,	"workerManager_restoreItemCount_" .. resIdx )
		tempItemSlot.restorePoint	= UI.createAndCopyBasePropertyControl( Panel_WorkerManager, "StaticText_Item_Restore_Value",		tempItemSlot.slotIcon,	"workerManager_restorePoint_" .. resIdx )

		tempItemSlot.slotBG			:SetPosX( 5 + (tempItemSlot.slotBG:GetSizeX() * resIdx) )
		tempItemSlot.slotBG			:SetPosY( 23 )
		tempItemSlot.slotIcon		:SetPosX( 5 )
		tempItemSlot.slotIcon		:SetPosY( 5 )
		tempItemSlot.itemCount		:SetPosX( tempItemSlot.slotIcon:GetSizeX() - 9 )
		tempItemSlot.itemCount		:SetPosY( tempItemSlot.slotIcon:GetSizeY() - 10 )
		tempItemSlot.restorePoint	:SetPosX( 3 )
		tempItemSlot.restorePoint	:SetPosY( 2 )

		tempItemSlot.slotIcon		:addInputEvent( "Mouse_UpScroll",	"workerManager_SliderScroll( true )" )
		tempItemSlot.slotIcon		:addInputEvent( "Mouse_DownScroll",	"workerManager_SliderScroll( false )" )

		self.restoreItemSlot[resIdx] = tempItemSlot
	end

	self.restoreItemBG			:AddChild( self.btn_restoreItemClose )
	self.restoreItemBG			:AddChild( self._slider )
	self.restoreItemBG			:AddChild( self.guideRestoreAll )
	Panel_WorkerManager			:RemoveControl( self.btn_restoreItemClose )
	Panel_WorkerManager			:RemoveControl( self._slider )
	Panel_WorkerManager			:RemoveControl( self.guideRestoreAll )
	self.btn_restoreItemClose	:ComputePos()
	self._slider				:ComputePos()
	self.guideRestoreAll		:ComputePos()

	self.desc					:SetTextMode( UI_TM.eTextMode_AutoWrap)
	self.desc					:SetAutoResize( true )
	self.desc					:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_DESCRIPTION") )
	self.desc					:ComputePos()

	self.btn_restoreItemClose	:SetShow( true )

	-- self.desc:setPadding( UI_PD.ePadding_Left, 10 )
	-- self.desc:setPadding( UI_PD.ePadding_Right, 10 )
end

local comboBox =
{
	town			= UI.getChildControl( Panel_WorkerManager, "Combobox_Town" ),
	grade			= UI.getChildControl( Panel_WorkerManager, "Combobox_Grade" ),
}

local townList	= UI.getChildControl( comboBox.town,	"Combobox_List" )
local gradeList	= UI.getChildControl( comboBox.grade,	"Combobox_List" )

comboBox.town:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FILTER_TOWN") ) -- 마을별 보기
comboBox.town:addInputEvent( "Mouse_LUp", "HandleClicked_WorkerManager_Town()" )
comboBox.town:GetListControl():addInputEvent( "Mouse_LUp", "WorkerManager_SetTown()"  )
Panel_WorkerManager:SetChildIndex(comboBox.town, 9999 )

comboBox.grade:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FILTER_GRADE") ) -- 등급별
comboBox.grade:addInputEvent( "Mouse_LUp", "HandleClicked_WorkerManager_Grade()" )
comboBox.grade:GetListControl():addInputEvent( "Mouse_LUp", "WorkerManager_SetGrade()"  )
Panel_WorkerManager:SetChildIndex(comboBox.grade, 9999 )

--------------------------------------------------------------------------------
-- 일꾼 목록 업데이트
--------------------------------------------------------------------------------

local townSort			= {}
local gradeSort			= {}
local filteredArray		= {}
local selectHomeWayPointIndex = -1
local selectWorkerGrade = -1
local workerManager_UpdateMain = function()
	local self = workerManager
	local plantArray	= Array.new()
	workerArray			= Array.new()
	if nil ~= workerManager.plantKey then
		plantArray:push_back( workerManager.plantKey )
	else
		-- 일꾼을 등록할 수 있는 거점키를 구한다.
		local plantConut = ToCleint_getHomePlantKeyListCount()
		for plantIdx = 0, plantConut -1 do
			local plantKeyRaw = ToCleint_getHomePlantKeyListByIndex( plantIdx )
			local plantKey = PlantKey()
			plantKey:setRaw( plantKeyRaw )
			plantArray:push_back( plantKey )
		end
	end

	-- 마을 정렬
	local plantSort_do = function( a, b )
		return a:get() < b:get()
	end
	table.sort( plantArray, plantSort_do )
	
	local totalWorkerCount = 0
	local totalWorkerCapacity = 0

	for plantRawIdx = 1, #plantArray do
		local plantKey = plantArray[plantRawIdx]

		local plantWorkerCount	= ToClient_getPlantWaitWorkerListCount( plantKey, 0 )
		local workerHouseCount	= ToClient_getTownWorkerMaxCapacity( plantKey )
		if workerHouseCount < plantWorkerCount then
			plantWorkerCount = workerHouseCount
		end

		for workerIdx = 0, plantWorkerCount -1 do
			local workerNoRaw	= ToClient_getPlantWaitWorkerNoRawByIndex( plantKey, workerIdx )
			workerArray:push_back( workerNoRaw )
		end

		totalWorkerCapacity = totalWorkerCapacity + workerHouseCount
		totalWorkerCount = totalWorkerCount + plantWorkerCount
		
	end
	
	-- "일꾼목록(" .. self._listCount .. "명)"
	local title		= ""
	if nil ~= workerManager.plantKey then
		title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERCOUNT", "Count", totalWorkerCount .. "/" .. totalWorkerCapacity )
	else
		title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_ALLWORKERCOUNT", "Count", totalWorkerCount )
	end

	self._listCount = totalWorkerCount
	self.penelTitle:SetText( title )

	townSort = { [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL") }		-- 마을 콤보박스용 배열 초기화
	gradeSort = { [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL") }		-- 등급 콤보박스용 배열 초기화
	local hasUpgradeWoker	= false
	for worker_Index = 1, #workerArray do	-- 승급 여부 체크용
		local workerWrapperLua = getWorkerWrapper(workerArray[worker_Index], false)
		if nil ~= workerWrapperLua then
			if CppEnums.NpcWorkingType.eNpcWorkingType_Upgrade == workerWrapperLua:getWorkingType() then	-- 
				hasUpgradeWoker = true
				self.upgradeWokerNoRaw = workerArray[worker_Index]
			end
			
			-- 일꾼이 있는 마을 저장
			local worker_HomeWayPoint	= workerWrapperLua:getHomeWaypoint()
			if nil == townSort[1] then
				table.insert( townSort, worker_HomeWayPoint )
			else
				local townCheck = true
				for n = 1, #townSort do
					if worker_HomeWayPoint == townSort[n] then
						townCheck = false
					end
				end
				if townCheck then
					table.insert( townSort, worker_HomeWayPoint )
				end
			end
			
			-- 가진 일꾼들의 등급 저장
			local worker_Grade = workerWrapperLua:getGrade()
			if nil == gradeSort[1] then
				table.insert( gradeSort, worker_Grade )
			else
				local townCheck = true
				for n = 1, #gradeSort do
					if worker_Grade == gradeSort[n] then
						townCheck = false
					end
				end
				if townCheck then
					table.insert( gradeSort, worker_Grade )
				end
			end
		end
	end
	
	-- 일꾼 등급 정렬
	local gradeSort_do = function( a, b )
		return a < b
	end
	table.sort( gradeSort, gradeSort_do )
	
	self._btnUpgradeNow	:SetShow( false )
	
	local count = 0
	filteredArray = {}
	for worker_Index = 1, #workerArray do
		local workerWrapperLua = getWorkerWrapper(workerArray[worker_Index], false)
		if nil ~= workerWrapperLua then
			if 0 < selectHomeWayPointIndex then				-- 마을 필터 선택했나??
				if workerWrapperLua:getHomeWaypoint() == townSort[selectHomeWayPointIndex] then
					if 0 <= selectWorkerGrade then			-- 일꾼 필터 선택했나?
						if workerWrapperLua:getGrade() == selectWorkerGrade then
							count = count + 1
							filteredArray[count] = workerArray[worker_Index]
						end
					else
						count = count + 1
						filteredArray[count] = workerArray[worker_Index]
					end
				end
			else
				if 0 <= selectWorkerGrade then				-- 일꾼 필터 선택했나?
					if workerWrapperLua:getGrade() == selectWorkerGrade then
						count = count + 1
						filteredArray[count] = workerArray[worker_Index]
					end
				else
					count = count + 1
					filteredArray[count] = workerArray[worker_Index]
				end
			end
		end
	end
	
	local limitCount = 0
	for worker_Index = self._startIndex, #filteredArray do
		if self.slotMaxCount <= limitCount then
			break
		end

		local slot	= self.slot[limitCount]
		slot.btn_Restore	:SetMonoTone( true )
		slot.btn_Stop		:SetMonoTone( true )

		slot.btn_Stop		:SetShow( false )
		slot.btn_Repeat		:SetShow( false )
		slot.btn_Repeat		:SetEnable( false )
		slot.btn_Repeat		:SetMonoTone( true )

		slot.btn_Restore	:SetEnable( false )
		slot.btn_Stop		:SetEnable( false )

		slot.btn_Upgrade	:SetEnable( false )
		slot.btn_Upgrade	:SetMonoTone( true )
		slot.btn_ChangeSkill:SetEnable( false )
		slot.btn_ChangeSkill:SetMonoTone( true )

		slot.btn_Restore	:addInputEvent( "Mouse_On",		"WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 0 )" )
		slot.btn_Restore	:addInputEvent( "Mouse_Out",	"WorkerManager_ButtonSimpleToolTip( false,	" .. limitCount .. ", 0 )" )
		slot.btn_Upgrade	:addInputEvent( "Mouse_On",		"WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 1 )" )
		slot.btn_Upgrade	:addInputEvent( "Mouse_Out",	"WorkerManager_ButtonSimpleToolTip( false,	" .. limitCount .. ", 1 )" )
		slot.btn_Repeat		:addInputEvent( "Mouse_On",		"WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 2 )" )
		slot.btn_Repeat		:addInputEvent( "Mouse_Out",	"WorkerManager_ButtonSimpleToolTip( false,	" .. limitCount .. ", 2 )" )
		slot.btn_Stop		:addInputEvent( "Mouse_On",		"WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 3 )" )
		slot.btn_Stop		:addInputEvent( "Mouse_Out",	"WorkerManager_ButtonSimpleToolTip( false,	" .. limitCount .. ", 3 )" )
		slot.btn_ChangeSkill:addInputEvent( "Mouse_On",		"WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 4 )" )
		slot.btn_ChangeSkill:addInputEvent( "Mouse_Out",	"WorkerManager_ButtonSimpleToolTip( false,	" .. limitCount .. ", 4 )" )
		slot.btn_Restore	:setTooltipEventRegistFunc("WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 0 )" )
		slot.btn_Upgrade	:setTooltipEventRegistFunc("WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 1 )" )
		slot.btn_Repeat		:setTooltipEventRegistFunc("WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 2 )" )
		slot.btn_Stop		:setTooltipEventRegistFunc("WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 3 )" )
		slot.btn_ChangeSkill:setTooltipEventRegistFunc("WorkerManager_ButtonSimpleToolTip( true,	" .. limitCount .. ", 4 )" )

		local workerWrapperLua	= getWorkerWrapper(filteredArray[worker_Index], false)	-- 데이터 가져오기
		local workerNoRaw		= filteredArray[worker_Index]
		
		local setWorker = function()
			local workerUpgradeCount	= workerWrapperLua:getUpgradePoint()
			local worker_Name			= ""
			if 0 < workerUpgradeCount and workerWrapperLua:isUpgradable() then
				worker_Name			= workerWrapperLua:getName()
				slot.btn_Upgrade	:SetText( workerWrapperLua:getUpgradePoint() )
				slot.btn_Upgrade	:SetShow( true )
				slot.btn_Upgrade	:SetEnable( true )
				slot.btn_Upgrade	:SetMonoTone( false )
			else
				slot.btn_Upgrade	:SetText( "" )
				slot.btn_Upgrade	:SetEnable( false )
				slot.btn_Upgrade	:SetMonoTone( true )
				worker_Name			= workerWrapperLua:getName()
			end

			if workerWrapperLua:checkPossibleChangesSkillKey() then
				slot.btn_ChangeSkill:SetShow( true )
				slot.btn_ChangeSkill:SetEnable( true )
				slot.btn_ChangeSkill:SetMonoTone( false )
				slot.btn_ChangeSkill:addInputEvent( "Mouse_LUp", "workerChangeSkill_Open( " .. worker_Index  .. " )" )
				-- if slot.btn_Upgrade:GetShow() then
				-- 	slot.btn_ChangeSkill:SetPosX( slot.btn_Upgrade:GetPosX() - slot.btn_ChangeSkill:GetSizeX() )
				-- 	slot.btn_ChangeSkill:SetPosY( slot.btn_Upgrade:GetPosY() + 1 )
				-- else
				-- 	slot.btn_ChangeSkill:SetPosX( slot.btn_Restore:GetPosX() - slot.btn_ChangeSkill:GetSizeX() )
				-- 	slot.btn_ChangeSkill:SetPosY( slot.btn_Restore:GetPosY() + 1 )
				-- end
			else
				slot.btn_ChangeSkill:SetEnable( false )
				slot.btn_ChangeSkill:SetMonoTone( true )
				slot.btn_ChangeSkill:addInputEvent( "Mouse_LUp", "" )
			end

			local worker_Lev			= workerWrapperLua:getLevel()
			local worker_HomeWayPoint	= workerWrapperLua:getHomeWaypoint()
			local workerNo_64			= workerNoRaw
			slot.btn_Repeat		:SetShow( false )
			slot.btn_Repeat		:SetEnable( false )
			slot.btn_Repeat		:SetMonoTone( true )
			slot.btn_Stop		:SetShow( true )
			
			if workerWrapperLua:isWorking() then
				local workingLeftPercent = workerWrapperLua:currentProgressPercents()
				slot.progress:SetProgressRate( workingLeftPercent )
				slot.progress:SetCurrentProgressRate( workingLeftPercent )

				slot.progressBg		:SetShow( true )
				slot.progress		:SetShow( true )

				slot.btn_Restore	:SetMonoTone( true )
				slot.btn_Restore	:SetEnable( false )
				slot.btn_Restore	:addInputEvent( "Mouse_LUp", "" )

				slot.btn_Repeat		:SetShow( false )
				slot.btn_Repeat		:SetEnable( false )
				slot.btn_Repeat		:SetMonoTone( true )
				slot.btn_Stop		:SetShow( true )
				slot.btn_Stop		:SetMonoTone( false )
				slot.btn_Stop		:SetEnable( true )
				slot.btn_Stop		:addInputEvent( "Mouse_LUp", "HandleClicked_WorkerManager_StopWorking( " .. worker_Index .. " )" )

				slot.btn_Upgrade	:SetMonoTone( true )
				slot.btn_Upgrade	:SetEnable( false )
				slot.btn_Upgrade	:addInputEvent( "Mouse_LUp", "" )
			else	-- 쉬고 있다.
				slot.progressBg		:SetShow( true )
				slot.progress		:SetShow( false )

				slot.btn_Restore	:SetMonoTone( false )
				slot.btn_Restore	:SetEnable( true )
				slot.btn_Restore	:addInputEvent( "Mouse_LUp", "HandleClicked_WorkerManager_RestoreWorker( " .. worker_Index .. ", " .. limitCount .. " )" )								

				slot.btn_Repeat		:SetShow( true )
				slot.btn_Repeat		:SetEnable( false )
				slot.btn_Repeat		:SetMonoTone( true )
				slot.btn_Stop		:SetShow( false )
				slot.btn_Stop		:SetMonoTone( true )
				slot.btn_Stop		:SetEnable( false )
				slot.btn_Stop		:addInputEvent( "Mouse_LUp", "" )

				-- slot.btn_Upgrade	:SetMonoTone( false )
				-- slot.btn_Upgrade	:SetEnable( true )
				slot.btn_Upgrade	:addInputEvent( "Mouse_LUp", "HandleClicked_WorkerManager_UpgradeWorker( " .. worker_Index .. " )" )

				local currentActionPoint = workerWrapperLua:getActionPoint()
				local maxActionPoint	 = workerWrapperLua:getMaxActionPoint()
				
				if currentActionPoint == maxActionPoint then
					slot.btn_Restore	:SetFontColor( 4286743170 )
					slot.btn_Restore	:SetMonoTone( true )
					slot.btn_Restore	:SetEnable( false )
					slot.btn_Restore	:addInputEvent( "Mouse_LUp", "" )
					if restoreWorkerNo == workerNo_64 then
						HandleClicked_WorkerManager_RestoreItemClose()
					end
				end

				if workerWrapperLua:isWorkerRepeatable() and 0 < currentActionPoint then	-- 작업 내역이 있다면, 반복!
					slot.btn_Repeat	:SetShow( true )
					slot.btn_Repeat	:SetEnable( true )
					slot.btn_Repeat	:SetMonoTone( false )
					slot.btn_Stop	:SetShow( false )
					slot.btn_Stop	:SetMonoTone( false )
					slot.btn_Stop	:SetEnable( true )
					slot.btn_Repeat	:addInputEvent( "Mouse_LUp", "HandleClicked_ReDoWork( " .. worker_Index .. " )" )
				end
			end

			local actionPointPer		= workerWrapperLua:getActionPointPercents()
			slot.workerRestorePT:SetProgressRate( actionPointPer )
			slot.workerCurrentPT:SetProgressRate( actionPointPer )

			if nil == workerCheckList[Int64toInt32(workerNo_64)] then
				workerCheckList[Int64toInt32(workerNo_64)] = false
			end
			local isCheck = ( workerCheckList[Int64toInt32(workerNo_64)] )
			slot.workerCheck	:SetCheck( isCheck )

			-- slot.workerName		:SetFontColor(  )	-- workerWrapperLua:getGradeToColorString()
			slot.workerName		:SetText( "Lv." .. worker_Lev .. " " .. workerWrapperLua:getGradeToColorString() .. worker_Name .. "<PAOldColor>" )
			slot.workerNodeName	:SetText( workerWrapperLua:getWorkingNodeDesc() )
			slot.workingName	:SetTextMode( CppEnums.TextMode.eTextMode_LimitText )
			slot.workingName	:SetText( workerWrapperLua:getWorkString() )

			slot.picture		:ChangeTextureInfoName( workerWrapperLua:getWorkerIcon() )

			slot.bg				:SetShow( true )
			slot.workerName		:SetShow( true )
			slot.workingName	:SetShow( true )

			if true == hasUpgradeWoker then	-- 승급 중인 일꾼이 있으면, 승급 버튼을 죽인다.
				if isGameTypeKorea() or isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_JAP ) then		-- 한국과 일본은 즉시완료 버튼 노출
					self._btnUpgradeNow	:SetShow( true )
				end	
				
				slot.btn_Upgrade	:SetMonoTone( true )
				slot.btn_Upgrade	:SetEnable( false )
				slot.btn_Upgrade	:addInputEvent( "Mouse_LUp", "" )
			end

			slot.bg				:addInputEvent(	"Mouse_On",		"workerManager_ToolTip( true,	" .. worker_Index .. ", " .. limitCount .. " )"		)
			slot.bg				:addInputEvent(	"Mouse_Out",	"workerManager_ToolTip( false,	" .. worker_Index .. ", " .. limitCount .. " )"		)
			slot.workerCheck	:addInputEvent(	"Mouse_LUp",	"HandleClicked_workerManager_CheckWorker( " .. Int64toInt32(workerNo_64) .. " )"	)

			if true == workerWrapperLua:getIsAuctionInsert() then	-- 거래소에 등록된 놈이면.
				slot.btn_Restore	:SetMonoTone( true )
				slot.btn_Restore	:SetEnable( false )
				slot.btn_Restore	:SetFontColor( 4286743170 )

				slot.btn_Repeat		:SetShow( true )
				slot.btn_Repeat		:SetEnable( false )
				slot.btn_Repeat		:SetMonoTone( true )
				slot.btn_Stop		:SetShow( false )
				slot.btn_Stop		:SetMonoTone( true )
				slot.btn_Stop		:SetEnable( false )

				slot.btn_Upgrade	:SetMonoTone( true )
				slot.btn_Upgrade	:SetEnable( false )
				slot.btn_Upgrade	:addInputEvent( "Mouse_LUp", "")
			end

			limitCount = limitCount + 1
		end
		
		-- 필터 적용
		if nil ~= workerWrapperLua then
			if 0 < selectHomeWayPointIndex then				-- 마을 필터 선택했나??
				if workerWrapperLua:getHomeWaypoint() == townSort[selectHomeWayPointIndex] then
					if 0 <= selectWorkerGrade then			-- 일꾼 필터 선택했나?
						if workerWrapperLua:getGrade() == selectWorkerGrade then
							setWorker()
						end
					else
						setWorker()
					end
				end
			else
				if 0 <= selectWorkerGrade then				-- 일꾼 필터 선택했나?
					if workerWrapperLua:getGrade() == selectWorkerGrade then
						setWorker()
					end
				else
					setWorker()
				end
			end
		end
	end

	
	-- self._listCount = limitCount + count + self._startIndex - 1
	self._listCount = count
	UIScroll.SetButtonSize( self._scroll, self.slotMaxCount, self._listCount )
end
local workerManager_Update = function()
	local self = workerManager
	for slotIdx = 0, self.slotFixMaxCount -1 do
		local slot = self.slot[slotIdx]
		slot.bg				:SetShow( false )
		slot.workerName		:SetShow( false )
		slot.workingName	:SetShow( false )
		slot.progressBg		:SetShow( true )
		slot.progress		:SetShow( false )
	end

	workerManager_UpdateMain()	-- 업데이트 메인
	
	-- 배경 사이즈
	self.workerListBg:SetSize( self.workerListBg:GetSizeX(), (self.slot[0].bg:GetSizeY() + 5) * self.slotMaxCount )
	
	-- 스크롤 사이즈
	self._scroll:SetSize( self._scroll:GetSizeX(), (self.slot[0].bg:GetSizeY() + 5) * self.slotMaxCount )

	-- 패널 사이즈
	Panel_WorkerManager:SetSize( Panel_WorkerManager:GetSizeX(), ((self.slot[0].bg:GetSizeY() + 5) * self.slotMaxCount) + 80 + self._btnFire:GetSizeY() + (self.desc:GetSizeY()+10) )
	self._btnFire		:ComputePos()
	self._restoreAll	:ComputePos()
	self._reDoAll		:ComputePos()
	self._btnUpgradeNow	:ComputePos()
	self.desc			:ComputePos()

	UIScroll.SetButtonSize( self._scroll, self.slotMaxCount, self._listCount )
end


function HandleClicked_WorkerManager_Town()
	comboBox.town:DeleteAllItem()
	comboBox.town:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL"), 1 )
	for ii = 1, #townSort do
		comboBox.town:AddItem( ToClient_GetNodeNameByWaypointKey(townSort[ii]), ii+1 )
	end
	
	comboBox.town:ToggleListbox()
end

function WorkerManager_SetTown()
	local selectTownIndex = comboBox.town:GetSelectIndex()
	selectHomeWayPointIndex = selectTownIndex
	comboBox.town:SetSelectItemIndex( selectTownIndex )
	if 0 < selectTownIndex then
		comboBox.town:SetText( ToClient_GetNodeNameByWaypointKey(townSort[selectTownIndex]) )
	else
		comboBox.town:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL") )
	end
	comboBox.town:ToggleListbox()
	workerManager._scroll:SetControlPos(0)
	workerManager._startIndex = 1
	workerManager_Update()
end

function HandleClicked_WorkerManager_Grade()
	comboBox.grade:DeleteAllItem()
	comboBox.grade:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL"), 1 )
	for ii = 1, #gradeSort do
		comboBox.grade:AddItem( workerGrade[gradeSort[ii]], ii+1 )
	end
	
	comboBox.grade:ToggleListbox()
end

function WorkerManager_SetGrade()
	local selectGradeIndex = comboBox.grade:GetSelectIndex()
	comboBox.grade:SetSelectItemIndex( selectGradeIndex )
	if 0 < selectGradeIndex then
		comboBox.grade:SetText( workerGrade[gradeSort[selectGradeIndex]])
		selectWorkerGrade = gradeSort[selectGradeIndex]
	else
		comboBox.grade:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL") )
		selectWorkerGrade = -1
	end
	
	comboBox.grade:ToggleListbox()
	workerManager._scroll:SetControlPos(0)
	workerManager._startIndex = 1
	workerManager_Update()
end


--------------------------------------------------------------------------------
-- 회복 아이템 업데이트
--------------------------------------------------------------------------------
local restoreItem_update = function()	
	local self		= workerManager
	for itemIdx = 0, self.restoreItemMaxCount - 1 do	-- 초기화
		local slot = self.restoreItemSlot[itemIdx]
		slot.slotBG		:SetShow( false )
		slot.slotIcon	:addInputEvent("Mouse_RUp", "")
	end

	self.restoreItemHasCount = ToClient_getNpcRecoveryItemList()
	if self.restoreItemHasCount <= 0 then
		self.restoreItemBG:SetShow( false )
	end
	local uiIdx = 0
	for itemIdx = self.sliderStartIdx, self.restoreItemHasCount - 1 do
		if self.restoreItemMaxCount <= uiIdx then	-- 초과하면 멈춘다.
			break
		end

		local slot = self.restoreItemSlot[uiIdx]
		slot.slotBG		:SetShow( true )
		
		local recoveryItem	= ToClient_getNpcRecoveryItemByIndex( itemIdx )
		local itemStatic	= recoveryItem:getItemStaticStatus()
		slot.slotIcon		:ChangeTextureInfoName("icon/" .. getItemIconPath( itemStatic ) )
		slot.itemCount		:SetText( tostring(recoveryItem._itemCount_s64) )
		slot.restorePoint	:SetText( "+" .. tostring(recoveryItem._contentsEventParam1) )

		slot.slotIcon		:addInputEvent("Mouse_RUp", "HandleClicked_WorkerManager_RestoreItem( " .. itemIdx .. " )")		
		slot.slotIcon		:addInputEvent("Mouse_On", 	"HandleOnOut_WorkerManager_RestoreItem( true,	" .. itemIdx .. " )")
		slot.slotIcon		:addInputEvent("Mouse_Out", "HandleOnOut_WorkerManager_RestoreItem( false,	" .. itemIdx .. " )")
		uiIdx = uiIdx + 1
	end
	
	if self.restoreItemMaxCount < self.restoreItemHasCount then
		self._slider:SetShow( true )
		local sliderSize	= self._slider:GetSizeX()
		local targetPercent	= ( self.restoreItemMaxCount / self.restoreItemHasCount )*100
		local sliderBtnSize = sliderSize * ( targetPercent / 100 )

		self._sliderBtn:SetSize( sliderBtnSize, self._sliderBtn:GetSizeY() )
		self._slider:SetInterval( self.restoreItemHasCount - self.restoreItemMaxCount )
		self._sliderBtn:addInputEvent("Mouse_LPress", "HandleLPress_WorkerManager_RestoreItemSlider()")
	else
		self._slider:SetShow( false )
	end
end

--------------------------------------------------------------------------------
-- 작업 취소
--------------------------------------------------------------------------------
function HandleClicked_WorkerManager_StopWorking( workerIdx )
	local workerWrapperLua	= getWorkerWrapper(filteredArray[workerIdx], false)	-- 데이터 가져오기
	local workerNoRaw		= filteredArray[workerIdx]

	if nil ~= workerWrapperLua then
		local workerNo		= workerNoRaw
		local leftWorkCount	= workerWrapperLua:getWorkingCount()
		
		local workingState = workerWrapperLua:getWorkingStateXXX()
		if ( CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Working == workingState ) then
			ToClient_requestChangeWorkingState(WorkerNo(workerNo), CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return)
			FGlobal_HarvestList_Update()
			return
		elseif ( CppEnums.NpcWorkingState.eNpcWorkingState_HarvestWorking_Return == workingState ) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_MESSAGE_GOHOME"))	-- "작업을 마치고 귀가중입니다." )
			return
		end		
		
		if leftWorkCount < 1 then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_ONLYONEWORK") ) -- "1회 작업은 취소할 수 없습니다." )
			return
		else
			local cancelDoWork = function()
				ToClient_requestCancelNextWorking( WorkerNo(workerNo) )
			end
			local workName 	= workerWrapperLua:getWorkString()
			local cancelWorkContent = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TOWN_WORKERMANAGE_CONFIRM_WORKCANCEL", "workName", workName )
			-- "[" .. workName .. "]\n예약된 작업을 취소하시겠습니까?\n현재 진행중인 작업은 취소할 수 없습니다.\n\n※ 작업에 사용된 아이템은 복구되지 않습니다."
			local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_WORKINGPROGRESS_CANCELWORK_TITLE" ), content = cancelWorkContent , functionYes = cancelDoWork, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
			MessageBox.showMessageBox(messageboxData, "top")
		end
	end
end

--------------------------------------------------------------------------------
-- 회복 관련
--------------------------------------------------------------------------------
function workerManager_SliderScroll( isUp )
	local self = workerManager
	if true == isUp then
		if self.sliderStartIdx <= 0 then
			self.sliderStartIdx = 0
			return
		end
		self.sliderStartIdx = self.sliderStartIdx - 1
	else
		if self.restoreItemHasCount <= ( self.sliderStartIdx + self.restoreItemMaxCount ) then
			return
		end
		self.sliderStartIdx = self.sliderStartIdx + 1
	end

	local currentPos = ( self.sliderStartIdx / (self.restoreItemHasCount-self.restoreItemMaxCount) ) * 100
	if 100 < currentPos then
		currentPos = 100
	elseif currentPos < 0 then
		currentPos = 0
	end
	self._slider:SetControlPos( currentPos )
	restoreItem_update()
end
function HandleLPress_WorkerManager_RestoreItemSlider()
	local self		= workerManager
	local pos		= self._slider:GetControlPos()
	local posIdx	= math.floor((self.restoreItemHasCount - self.restoreItemMaxCount) * pos)
	if self.restoreItemHasCount - self.restoreItemMaxCount < posIdx then
		return
	end
	self.sliderStartIdx = posIdx
	local currentPos = ( self.sliderStartIdx / (self.restoreItemHasCount - self.restoreItemMaxCount) ) * 100
	if 100 < currentPos then
		currentPos = 100
	elseif currentPos < 0 then
		currentPos = 0
	end
	self._slider:SetControlPos( currentPos )
	restoreItem_update()
end
function HandleClicked_WorkerManager_RestoreWorker( workerIdx, uiIdx )
	local self						= workerManager
	self.selectedUiIndex			= uiIdx
	local slot						= self.slot[self.selectedUiIndex]
	self.selectedRestoreWorkerIdx	= workerIdx
	local restoreItemCount = ToClient_getNpcRecoveryItemList()
	local workerWrapperLua	= getWorkerWrapper(filteredArray[workerIdx], false)	-- 데이터 가져오기

	local actionPointPer	= workerWrapperLua:getActionPointPercents()
	
	if restoreItemCount <= 0 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_NOITEM") )
		return	
	elseif 100 == actionPointPer then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE_MAX") )
		return
	end
	self.restoreItemBG:SetShow( true )
	self.restoreItemBG:SetPosX( slot.btn_Restore:GetPosX() - ( self.restoreItemBG:GetSizeX() * 0.95 ) )
	self.restoreItemBG:SetPosY( slot.bg:GetPosY() + ( slot.bg:GetSizeY() * 1.75 ) )

	restoreItem_update()
end
function HandleClicked_WorkerManager_RestoreItem( itemIdx )
	local self			= workerManager
	local workerIndex	= self.selectedRestoreWorkerIdx
	
	local workerWrapperLua	= getWorkerWrapper(filteredArray[workerIndex], false)
	local workerNoRaw		= filteredArray[workerIndex]

	if nil ~= workerWrapperLua then
		local workerNo			= workerNoRaw
		local recoveryItem		= ToClient_getNpcRecoveryItemByIndex( itemIdx )
		local recoveryItemCount = Int64toInt32(recoveryItem._itemCount_s64		)
		local slotNo			= recoveryItem._slotNo
		local restorePoint		= recoveryItem._contentsEventParam1
		local maxPoint			= workerWrapperLua:getMaxActionPoint()
		local currentPoint		= workerWrapperLua:getActionPoint()
		local actionPointPer	= workerWrapperLua:getActionPointPercents()

		if 100 <= actionPointPer then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_RESTORE_MAX") )
			return
		end 
		
		if isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_SHIFT) then
			local restoreItemCount = ToClient_getNpcRecoveryItemList()			
			local restoreActionPoint = maxPoint - currentPoint
			local itemNeedCount = restoreActionPoint / restorePoint
			local currentItemCount = recoveryItemCount			
			for itemUseCount = 1, itemNeedCount + 1 do
				if currentPoint ~= maxPoint and 0 ~= currentItemCount then
					restoreWorkerNo = workerNo
					requestRecoveryWorker( WorkerNo(workerNo), slotNo )
					currentItemCount = currentItemCount - 1
				else
					return			
				end					
			end
			return
		end
		restoreWorkerNo = workerNo
		requestRecoveryWorker( WorkerNo(workerNo), slotNo )
	end
end
function HandleOnOut_WorkerManager_RestoreItem( isSet, itemIdx )
	local self			= workerManager
	local workerIndex	= self.selectedRestoreWorkerIdx

	local workerWrapperLua	= getWorkerWrapper(filteredArray[workerIndex], false)

	if nil ~= workerWrapperLua then
		local maxPoint			= workerWrapperLua:getMaxActionPoint()
		local currentPoint		= workerWrapperLua:getActionPoint()
		local actionPointPer	= workerWrapperLua:getActionPointPercents()

		local recoveryItem		= ToClient_getNpcRecoveryItemByIndex( itemIdx )
		local slotNo			= recoveryItem._slotNo
		local restorePoint		= recoveryItem._contentsEventParam1
		local workerSlot		= self.slot[self.selectedUiIndex]

		local actionPointPrePer	= ( (currentPoint + restorePoint) / maxPoint ) * 100

		if true == isSet then
			workerSlot.workerRestorePT:SetProgressRate( actionPointPrePer )
		else
			workerSlot.workerRestorePT:SetProgressRate( actionPointPer )
		end
	end
end
function HandleClicked_WorkerManager_RestoreItemClose()
	local self = workerManager
	self.restoreItemBG:SetShow( false )
	restoreWorkerNo = nil
end

--------------------------------------------------------------------------------
-- 승급
--------------------------------------------------------------------------------
function HandleClicked_WorkerManager_UpgradeWorker( workerIdx )
	local workerWrapperLua	= getWorkerWrapper(filteredArray[workerIdx], false)	-- 데이터 가져오기
	local do_Upgrade_Worker = function()
		workerWrapperLua:requestUpgrade()
		workerManager_UpdateMain()
	end
	
	local workerName		= workerWrapperLua:getName()
	local workingTime	= workerWrapperLua:getLeftWorkingTime()

	local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")	-- "알 림"
	local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_UPGRADEDESC", "name", workerName)
	-- "승급 시험은 하루 동안 진행됩니다.\n 시험동안 다른 일꾼은 시험이 불가능합니다.\n" .. wokerName .. "의 승급 시험을 치루겠습니까?"
	local messageboxData = { title = messageTitle, content = messageContent , functionYes = do_Upgrade_Worker, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
			MessageBox.showMessageBox(messageboxData, "top")
end

--------------------------------------------------------------------------------
-- 승급 즉시 완료
--------------------------------------------------------------------------------
function HandleClicked_workerManager_WorkerUpgradeNow()
	local self				= workerManager
	local workerNoRaw		= self.upgradeWokerNoRaw
	local remainTimeInt 	= ToClient_getWorkingTime( workerNoRaw )
	local needPearl 		= ToClient_GetUsingPearlByRemainingPearl( CppEnums.InstantCashType.eInstant_CompleteNpcWorkerUpgrade, remainTimeInt )

	local doUpgradeNow = function()
		ToClient_requestQuickComplete( WorkerNo(workerNoRaw), needPearl )
		self.upgradeWokerNoRaw = -1
	end

	local messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_IMMEDIATELYCOMPLETE_MSGBOX_TITLE") -- "즉시 완료"
	local messageBoxMemo	= PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_UPGRADENOW_CONFIRM", "pearl", tostring(needPearl))
	-- {pearl} 펄을 사용해 승급을 즉시 완료하시겠습니까?
	local messageboxData = { title = messageboxTitle, content = messageBoxMemo , functionYes = doUpgradeNow, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData, "middle")
end

--------------------------------------------------------------------------------
-- 창이 새로 열릴 때마다 체크 해제
--------------------------------------------------------------------------------
function WorkerManager_WorkerCheck_Init()
	local self = workerManager
	for index = 1, #filteredArray do
		local workerNoRaw = filteredArray[index]
		workerCheckList[Int64toInt32(workerNoRaw)] = false
	end
end

--------------------------------------------------------------------------------
-- 해고용 선택
--------------------------------------------------------------------------------
function HandleClicked_workerManager_CheckWorker( workerNo_64 )
	if nil == workerCheckList[workerNo_64] or false == workerCheckList[workerNo_64] then
		workerCheckList[workerNo_64] = true
	else
		workerCheckList[workerNo_64] = false
	end
	workerManager_UpdateMain()
end
--------------------------------------------------------------------------------
-- 해고
--------------------------------------------------------------------------------
function HandleClicked_workerManager_WaitWorkerFire()
	local self			= workerManager

	local do_CheckedWorker_Fire = function()
		for idx=1, self._listCount do
			local workerNoRaw		= filteredArray[idx]
			if workerCheckList[Int64toInt32(workerNoRaw)] then
				ToClient_requestDeleteMyWorker( WorkerNo(workerNoRaw) )
			end
		end
	end

	local checkCount = 0
	for idx=1, self._listCount do
		local workerNoRaw		= filteredArray[idx]
		if workerCheckList[Int64toInt32(workerNoRaw)] then
			for index = 1, #filteredArray do
				if workerNoRaw == filteredArray[index] then
					checkCount = checkCount + 1
				end
			end
		end
	end
	
	if 0 == checkCount then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FIREWORKERSELECT") ) -- "해고할 일꾼을 선택해주세요." )
		return
	end
	
	-- 일꾼 해고 시 회복창을 열 때 계산한 일꾼 배열이 꼬이므로, 회복창이 열려있다면 닫아준다!
	if Panel_WorkerRestoreAll:GetShow() then
		workerRestoreAll_Close()
	end

	local selectFilterString = ""
	local selectTownIndex = comboBox.town:GetSelectIndex()
	local selectGradeIndex = comboBox.grade:GetSelectIndex()
	if 0 < selectTownIndex then
		selectFilterString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_DESTINATIONTOWN") .. ToClient_GetNodeNameByWaypointKey(townSort[selectTownIndex])
	else
		selectFilterString = PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_DESTINATIONTOWN_ALL") -- 대상 마을 : 전체
	end
	
	if 0 < selectGradeIndex then
		selectFilterString = selectFilterString .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE") .. workerGrade[gradeSort[selectGradeIndex]]
	else
		selectFilterString = selectFilterString .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERGRADE_ALL") -- | 일꾼 등급 : 전체
	end
	
	selectFilterString = "( " .. selectFilterString .. " )"
	
	local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")	-- "알 림"
	local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_FIREWORKERDESC", "count", checkCount) .. "\n" .. selectFilterString-- "총 " .. checkCount .. "명의 일꾼을 해고하시겠습니까?"
	local messageboxData = { title = messageTitle, content = messageContent , functionYes = do_CheckedWorker_Fire, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
			MessageBox.showMessageBox(messageboxData, "middle")
end


function HandleClicked_workerManager_RestoreAll()
	local self			= workerManager
	local restoreItemCount = ToClient_getNpcRecoveryItemList()
	if restoreItemCount <= 0 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_NOITEM") )
		return
	end
	FGlobal_WorkerRestoreAll_Open( self._listCount, filteredArray )
end

function HandleClicked_workerManager_ReDoAll()
	local self	= workerManager
	
	for worker_Index = 1, #filteredArray do
		HandleClicked_ReDoWork ( worker_Index )
	end
	
end


--------------------------------------------------------------------------------
-- 프레임 이벤트
--------------------------------------------------------------------------------
local elapsedTime = 0
function workerManager_FrameUpdate( deltaTime )
	elapsedTime = elapsedTime + deltaTime

	-- if workerManager.restoreItemBG:GetShow() then
	-- 	return
	-- end
	
	if 1 < elapsedTime then
	-- {
		local self = workerManager
		for slotIdx = 0, self.slotFixMaxCount -1 do
			local slot = self.slot[slotIdx]
			slot.bg				:SetShow( false )
			slot.workerName		:SetShow( false )
			slot.workingName	:SetShow( false )
			slot.progressBg		:SetShow( true )
			slot.progress		:SetShow( false )
		end

		workerManager_UpdateMain()
	-- }
		elapsedTime = 0
	end
end


--------------------------------------------------------------------------------
-- 스크롤
--------------------------------------------------------------------------------
function workerManager_ScrollEvent( isUp )
	local	self		= workerManager
	self._startIndex	= UIScroll.ScrollEvent( self._scroll, isUp, self.slotMaxCount, self._listCount, self._startIndex - 1, 1 ) + 1
	
	if self.restoreItemBG:GetShow() then
		HandleClicked_WorkerManager_RestoreItemClose()
	end

	workerManager_Update()
end

function workerManager_CheckWorkingOtherChannel()
	if 0 ~= getSelfPlayer():get():checkWorkerWorkingServerNo() then
		return true
	else
		return false
	end
end

function workerManager_getWorkingOtherChannelMsg()
	if workerManager_CheckWorkingOtherChannel() then
		local workingServerNo 	= getSelfPlayer():get():getWorkerWorkingServerNo()
		local temporaryWrapper	= getTemporaryInformationWrapper()
		local worldNo			= temporaryWrapper:getSelectedWorldServerNo()
		local channelName		= getChannelName(worldNo, workingServerNo )
		
		return PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERWORKINGOTHERCHANNEL", "channelName", channelName)
	else
		return ""
	end
end

function workerManager_CheckWorkingOtherChannelAndMsg()
	if workerManager_CheckWorkingOtherChannel() then
		Proc_ShowMessage_Ack( workerManager_getWorkingOtherChannelMsg() )
		return true
	else
		return false
	end
end
--------------------------------------------------------------------------------
-- 온/오프
--------------------------------------------------------------------------------
function FGlobal_WorkerManger_ShowToggle()
	if Panel_WorkerManager:GetShow() then
		Panel_WorkerManager:SetShow( false )
		return
	end

	workerManager_Open()
end
function workerManager_Open()
	if workerManager_CheckWorkingOtherChannel() then
		local workingServerNo 	= getSelfPlayer():get():getWorkerWorkingServerNo()

		local temporaryWrapper	= getTemporaryInformationWrapper()
		local worldNo			= temporaryWrapper:getSelectedWorldServerNo()
		-- local channelNo			= temporaryWrapper:getSelectedChannelServerNo()
		local channelName		= getChannelName(worldNo, workingServerNo )

		Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_WORKERWORKINGOTHERCHANNEL", "channelName", channelName) )
		return
	end

	local self = workerManager
	if Panel_WorkerManager:GetShow() then
		Panel_WorkerManager:SetShow( false )
	end
	
	workerManager.slotMaxCount		= 6
	workerManager.sliderStartIdx	= 0
	workerManager.plantKey			= nil

	audioPostEvent_SystemUi(01,28)
	Panel_WorkerManager:SetShow( true )
	workerManager_ResetPos()
	workerManager_Update()	-- 크기 처리 때문에 해야 한다. 창욱 15.10.21
	-- WorkerManager_WorkerCheck_Init()

	if self.restoreItemBG:GetShow() then
		HandleClicked_WorkerManager_RestoreItemClose()
	end

	if	( ToClient_WorldMapIsShow() )	then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_WorkerManager, true, nil, workerRestoreAll_Close )
	end
end
function FGlobal_workerManager_OpenWorldMap()
	if workerManager_CheckWorkingOtherChannel() then
		return
	end

	local self = workerManager
	if Panel_WorkerManager:GetShow() then
		Panel_WorkerManager:SetShow( false )
	end

	workerManager.slotMaxCount		= 6
	workerManager.sliderStartIdx	= 0
	workerManager.plantKey			= nil

	audioPostEvent_SystemUi(01,28)
	Panel_WorkerManager:SetShow( true )
	workerManager_ResetPos()
	-- WorkerManager_WorkerCheck_Init()
	workerManager_Update()

	if self.restoreItemBG:GetShow() then
		HandleClicked_WorkerManager_RestoreItemClose()
	end

	if	( ToClient_WorldMapIsShow() )	then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_WorkerManager, true, nil, workerRestoreAll_Close )
	end
end
function FGlobal_workerManager_UpdateNode( plantKey )
	if workerManager_CheckWorkingOtherChannel() then
		return
	end

	local self = workerManager
	workerManager.plantKey			= plantKey

	workerManager.slotMaxCount		= 6
	workerManager.sliderStartIdx	= 0
	workerManager._startIndex		= 1

	workerManager._scroll:SetControlPos(0)
	workerManager._slider:SetControlPos(0)

	audioPostEvent_SystemUi(01,28)
	Panel_WorkerManager:SetShow( true )
	workerManager_ResetPos()
	-- WorkerManager_WorkerCheck_Init()
	workerManager_Update()

	if self.restoreItemBG:GetShow() then
		HandleClicked_WorkerManager_RestoreItemClose()
	end

	if	( ToClient_WorldMapIsShow() )	then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_WorkerManager, true, nil, workerRestoreAll_Close )
	end
end
function FGlobal_workerManager_ResetPlantKey()
	workerManager.plantKey			= nil
	workerManager._startIndex		= 1
	workerManager.sliderStartIdx	= 0
	workerManager._scroll:SetControlPos(0)
	workerManager._slider:SetControlPos(0)
	workerManager_Update()
end

function FGlobal_WorkerManager_GetWorkerNoRaw( worker_Index )
	return filteredArray[worker_Index]
end

function workerManager_Close()
	Panel_WorkerManager:SetShow( false )
	Panel_WorkerRestoreAll:SetShow( false )
	FGlobal_HideWorkerTooltip()
	TooltipSimple_Hide()

	if( ToClient_WorldMapIsShow() ) then
		WorldMapPopupManager:pop()
	end
end
function workerManager_Toggle()
	if Panel_WorkerManager:GetShow() then
		workerManager_Close()
	else
		workerManager_Open()
	end
end

--------------------------------------------------------------------------------
-- 포지션
--------------------------------------------------------------------------------
function workerManager_ResetPos( isWorldMap )
	local posX = 0
	local posY = 0

	if nil ~= isWorldMap then
		posX = getScreenSizeX() - Panel_WorkerManager:GetSizeX() - 10
		posY = 50
	else
		posX = getScreenSizeX() - Panel_WorkerManager:GetSizeX() - 10
		posY = FGlobal_Panel_Radar_GetSizeY()
	end

	Panel_WorkerManager:SetPosX( posX )
	Panel_WorkerManager:SetPosY( posY )
end
function workerManager_ResetPos_WorldMapClose()		-- 인자를 전달할 방법이 없어서 이렇게 쓴다.
	if not Panel_WorldMap:GetShow() then
		workerManager.slotMaxCount = 6
		workerManager_Update()

		Panel_WorkerManager:SetPosX( getScreenSizeX() - Panel_WorkerManager:GetSizeX() - 10 )
		Panel_WorkerManager:SetPosY( FGlobal_Panel_Radar_GetSizeY() )
	end
end
UI.addRunPostRestorFunction( workerManager_ResetPos_WorldMapClose )

--------------------------------------------------------------------------------
-- 반복
--------------------------------------------------------------------------------
function FGlobal_RedoWork( _workType, _houseInfoSS, _selectedWorker, _plantKey, _workKey, _selectedSubwork, _workingCount, _itemNoRaw, _houseHoldNo, _homeWaypoint)
	local plantKey			= ToClient_convertWaypointKeyToPlantKey(_homeWaypoint)
	local waitWorkerCount	= ToClient_getPlantWaitWorkerListCount(plantKey, 0)
	local maxWorkerCount	= ToClient_getTownWorkerMaxCapacity(plantKey)
	
	workedWorker[Int64toInt32(_selectedWorker:get_s64())] = {
		_workType			= _workType,
		_houseInfoSS		= _houseInfoSS,
		_selectedWorker		= _selectedWorker,
		_plantKey			= _plantKey,
		_workKey			= _workKey,
		_selectedSubwork	= _selectedSubwork,
		_workingCount		= _workingCount,
		_itemNoRaw			= _itemNoRaw,
		_houseHoldNo		= _houseHoldNo,
		_redoWork			= true
	}
	-- reCall_RedoWork = true	
end
function HandleClicked_ReDoWork( workerIndex )
	local workerWrapperLua	= getWorkerWrapper(filteredArray[workerIndex], false)		
	local workerNoRaw		= filteredArray[workerIndex]
	local currentActionPoint = workerWrapperLua:getActionPoint()
	
	local workerWorkingPrimitiveWrapper = workerWrapperLua:getWorkerRepeatableWorkingWrapper()
	if nil == workerWorkingPrimitiveWrapper then
		return
	end
	
	if workerWrapperLua:isWorkerRepeatable() then
		if (CppEnums.NpcWorkingType.eNpcWorkingType_HarvestWorking == workerWorkingPrimitiveWrapper:getType()) then		-- 텃밭이면 횟수는 1로!
			ToClient_requestRepeatWork(WorkerNo(workerNoRaw), 1)
			FGlobal_HarvestList_Update()
		elseif 0 < currentActionPoint then					-- 작업 내역이 있다면, 반복!
			ToClient_requestRepeatWork(WorkerNo(workerNoRaw), currentActionPoint)
		end
	end
end

--------------------------------------------------------------------------------
-- 일꾼 툴팁
--------------------------------------------------------------------------------
function workerManager_ToolTip( isShow, workerIndex, uiIndex )
	local self = workerManager
	if isShow then
		local slot				= self.slot[uiIndex]
		local workerNoRaw		= filteredArray[workerIndex]
		if nil ~= workerNoRaw then
			FGlobal_ShowWorkerTooltipByWorkerNoRaw( workerNoRaw, slot.bg )
		else
			FGlobal_HideWorkerTooltip()
		end
	else
		FGlobal_HideWorkerTooltip()
	end
	TooltipSimple_Hide()
end

--------------------------------------------------------------------------------
-- 클라이언트 이벤트
--------------------------------------------------------------------------------
function FromClient_WorkerDataAllUpdate()
	workerManager_Update()
	restoreItem_update()
	if Panel_WorkerRestoreAll:GetShow() then
		FGlobal_restoreItem_update()
	end
end

function Push_Work_Start_Message(workerNo, _workType, buildingInfoSS)
	if _workType == workType._HouseCraft then
		local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
		if esSSW:isSet() then
			local workName		= esSSW:getDescription()
			Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_START_CRAFT", "workName", workName) )			
		end
	elseif _workType == workType._LargeCraft then 
		local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
		if esSSW:isSet() then
			local workName						= esSSW:getDescription()
			local esSS							= esSSW:get()
			local eSSCount 						= getExchangeSourceNeedItemList(esSS, true)
			local resourceIndex 				= ToClient_getLargeCraftWorkIndexByWorker(workerNo)
			local itemStaticInfomationWrapper 	= getExchangeSourceNeedItemByIndex(resourceIndex)
			local itemStaticWrapper 			= itemStaticInfomationWrapper:getStaticStatus()
			local itemStatic 					= itemStaticWrapper:get()
			local subWorkName					= tostring(getItemName( itemStatic ))  -- 추후 수정 필요!
			Proc_ShowMessage_Ack( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_START_LARGECRAFT", "workName", workName, "subWorkName", subWorkName) )
		end
	elseif _workType == workType._PlantWork then
		local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
		if nil ~= esSSW and esSSW:isSet() then
			local workName		= esSSW:getDescription()
			Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_START_PLANTWORK", "workName", workName) )
		end
	elseif _workType == workType._Building then
		if nil == buildingInfoSS then
			return
		end
		local workName				= ToClient_getBuildingName( buildingInfoSS )
		local subWorkIndex 			= ToClient_getBuildingWorkingIndex(workerNo)
		local workCount				= ToClient_getBuildingWorkableListCount(buildingInfoSS)
		local buildingStaticStatus 	= ToClient_getBuildingWorkableBuildingSourceUnitByIndex(buildingInfoSS ,subWorkIndex)
		local itemStatic 			= buildingStaticStatus:getItemStaticStatus();
		local subWorkName			= getItemName(itemStatic) -- 추후 수정 필요!
		Proc_ShowMessage_Ack( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_START_BUILDING", "workName", workName, "subWorkName", subWorkName) )			
	elseif _workType == workType._upgrade then
		-- 추가 필요
	elseif _workType == workType._RegionWork then
		-- 추가 필요
	--elseif _workType == workType._Party then
	--	local workerWrapperLua = getWorkerWrapper(workerNo, false)
	--	local workerName = workerWrapperLua:getName()
	--	Proc_ShowMessage_Ack( "[" .. workerName .. "]이(가) 파티를 즐기러 가고 있습니다." )
	end
end

function Push_Worker_StopWork_Message(workerNo, isUserRequest, working)
	local npcWorkerWrapper 	= ToClient_getNpcWorkerByWorkerNo(workerNo)
	local workerName		= npcWorkerWrapper:getName()
	local workingArea		= working:getWorkingNodeName()
	local workingName		= working:getWorkingName()
	if true == isUserRequest then
		Proc_ShowMessage_Ack( PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_FINISHWORK_2", "workerName", workerName, "workingArea", workingArea, "workingName", workingName) )
	elseif false == isUserRequest then		
		if ( working:isType(CppEnums.NpcWorkingType.eNpcWorkingType_PlantZone) ) then
			Proc_ShowMessage_Ack( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_FINISHWORK_3", "workerName", workerName, "workingArea", workingArea) )
		else
			Proc_ShowMessage_Ack( PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_FINISHWORK_1", "workerName", workerName, "workingArea", workingArea, "workingName", workingName) )
		end
	end
end

function Push_Work_ResultItem_Message(WorkerNoRaw)
	local result_Count = ToClient_getLastestWorkingResultCount(WorkerNoRaw)
		for idx = 1, result_Count do
		local itemWrapper = ToClient_getLastestWorkingResult( WorkerNoRaw, idx - 1 )
		if itemWrapper:isSet() then
			local ItemEnchantSSW = itemWrapper:getStaticStatus()
			local name	= ItemEnchantSSW:getName()
			local count = Int64toInt32(itemWrapper:get():getCount_s64())
			Proc_ShowMessage_Ack( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLD_MAP_TOWN_WORKER_GOT_RESULT", "name", name, "count", count) )	
		end
	end
end

function WorkerManager_ButtonSimpleToolTip( isShow, limitCount, tipType )
	local self = workerManager
	local name, desc, control = nil, nil, nil
	local slot	= self.slot[limitCount]

	if 0 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_RESTORE_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_RESTORE_DESC")
		control	= slot.btn_Restore
	elseif 1 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_UPGRADE_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_UPGRADE_DESC")
		control	= slot.btn_Upgrade
	elseif 2 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_REPEAT_DESC")
		control	= slot.btn_Repeat
	elseif 3 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_STOP_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_STOP_DESC")
		control	= slot.btn_Stop
	elseif 4 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_CHANGESKILL_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERMANAGER_TOOLTIP_CHANGESKILL_DESC")
		control	= slot.btn_ChangeSkill
	else
		name	= ""
		desc	= ""
		control	= slot.btn_Restore
	end

	registTooltipControl(control, Panel_Tooltip_SimpleText)
	if isShow == true then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function FromClient_WorkerDataUpdate_HeadingPlant(ExplorationNode, workerNo)
	if 0 ~= Int64toInt32(workerNo) and false == ExplorationNode:getStaticStatus():getRegion():isMainOrMinorTown() then -- 작업 시작 시에만 workerNo가 제대로 들어온다!
		Push_Work_Start_Message(workerNo, workType._PlantWork) 
	end
	
	local _plantKey 		= ExplorationNode:getPlantKey()
	local wayPlant 			= ToClient_getPlant(_plantKey)
	local plant             = getPlant(_plantKey)
	local affiliatedTownKey = ToClinet_getPlantAffiliatedWaypointKey(wayPlant)
	
	if _plantKey:get() == 151 then
		FGlobal_MiniGame_RequestPlantWorking() -- 퀘스트 : 거점 생산 일 시키기 (로기아 농장 - 옥수수 재배)
	end

	if plantKey == nil then
		return	-- 최초 로딩 시에도 Event가 들어오므로 nil Check를 해야 한다.
	end
	workerManager_UpdateMain()
end

function FromClient_WorkerDataUpdate_HeadingHouse(rentHouseWrapper, workerNo)
	if 0 ~= Int64toInt32(workerNo) then -- 작업 시작 시에만 workerNo가 제대로 들어온다!
		local UseGroupType		= rentHouseWrapper:getHouseUseType()
		if UseGroupType == 12 or UseGroupType == 13 or UseGroupType == 14 then
			Push_Work_Start_Message(workerNo, workType._LargeCraft)
		--elseif UseGroupType == 0 then
		--	Push_Work_Start_Message(workerNo, workType._Party)
		else
			Push_Work_Start_Message(workerNo, workType._HouseCraft)
		end	
	end
	
	if plantKey == nil then
		return
	end
	local houseInfoSS 		= rentHouseWrapper:getStaticStatus():get()
	local affiliatedTownKey = ToClient_getHouseAffiliatedWaypointKey( houseInfoSS )
	workerManager_UpdateMain()
end

function FromClient_WorkerDataUpdate_HeadingBuilding(buildingInfoSS, workerNo)
	if 0 ~= Int64toInt32(workerNo) then -- 작업 시작 시에만 workerNo가 제대로 들어온다!
		Push_Work_Start_Message(workerNo, workType._Building, buildingInfoSS) 
	end
	
	if plantKey == nil then
		return
	end

	local affiliatedTownKey	= ToClient_getBuildingAffiliatedWaypointKey(buildingInfoSS)
	workerManager_UpdateMain()
end

function FromClient_WorkerDataUpdate_HeadingRegionManaging(regionGroupInfo, workerNo)
	if 0 ~= Int64toInt32(workerNo) then -- 작업 시작 시에만 workerNo가 제대로 들어온다!
		Push_Work_Start_Message(workerNo, workType._RegionWork) 
	end
	workerManager_UpdateMain()
end

function FromClient_changeLeftWorking( workerNo )
	-- _PA_LOG("김창욱", "취소를 예약했다.")
end

function FromClient_ChangeWorkerSkillNoOne( workerNoRaw )
	-- body
end

function FromClient_ChangeWorkerSkillNo( workerNoRaw )
	-- body
end

workerManager_Initiallize()
workerManager:registEventHandler()
workerManager:registMessageHandler()



-- FromClient_ChangeWorkerSkillNoOne( workerNoRaw )
-- FromClient_ChangeWorkerSkillNo( workerNoRaw )
-- ToClient_requestChangeSkillNoOne( workerNoRaw, prevWorkerSkillKeyRaw )

-- function workerWrapper:checkPossibleChangesSkillKey()
-- function workerWrapper:getNeedExperienceByChangeSkill()
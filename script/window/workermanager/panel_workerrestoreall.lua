Panel_WorkerRestoreAll:SetShow( false )
Panel_WorkerRestoreAll:setGlassBackground( true )
Panel_WorkerRestoreAll:ActiveMouseEventEffect( true )

local UI_TM 	= CppEnums.TextMode
local UI_PP 	= CppEnums.PAUIMB_PRIORITY
local UI_Color 	= Defines.Color

local workerRestoreAll = {
	
	slot				= {},
	startPosY			= 5,
	_startIndex			= 0,
	_listCount			= 0,

	_panelTitle			= UI.getChildControl( Panel_WorkerRestoreAll, "titlebar_RestoreAll" ),
	_itemListBG			= UI.getChildControl( Panel_WorkerRestoreAll, "Static_ItemList_BG" ),
	_selectItemGuide	= UI.getChildControl( Panel_WorkerRestoreAll, "StaticText_Select_Item_Guide" ),
	_workerStatusBG		= UI.getChildControl( Panel_WorkerRestoreAll, "Static_WorkerStatusBG" ),
	_workernPoint		= UI.getChildControl( Panel_WorkerRestoreAll, "StaticText_Worker" ),
	_workernPointValue	= UI.getChildControl( Panel_WorkerRestoreAll, "StaticText_WorkerValue" ),
	_restorePoint		= UI.getChildControl( Panel_WorkerRestoreAll, "StaticText_RestorePoint" ),
	_restorePointValue	= UI.getChildControl( Panel_WorkerRestoreAll, "StaticText_RestorePoint_Value" ),
	_slider				= UI.getChildControl( Panel_WorkerRestoreAll, "Slider_Restore_Item" ),
	
	
	_btnWinClose		= UI.getChildControl( Panel_WorkerRestoreAll, "Button_Close" ),
	_btnConfirm			= UI.getChildControl( Panel_WorkerRestoreAll, "Button_Restore" ),
	_btnCancel			= UI.getChildControl( Panel_WorkerRestoreAll, "Button_Cancel" ),
	
	
	restoreItemMaxCount	= 5,
	restoreItemHasCount	= 0,
	restoreItemSlot		= {},
	selectedRestoreWorkerIdx	= 0,
	selectedItemIdx		= 0,
	selectedUiIndex		= -1,
	sliderStartIdx		= 0,
	upgradeWokerIdx		= -1,

}
workerRestoreAll._sliderBtn			= UI.getChildControl( workerRestoreAll._slider, "Slider_Restore_Item_Button" )

local itemSelectList = {}
local workerListCount = 0
local workerArray	= Array.new()

local workerRestoreAll_Init = function()
	local self = workerRestoreAll
	for resIdx = 0, self.restoreItemMaxCount - 1 do
		local tempItemSlot = {}
		tempItemSlot.slotBG			= UI.createAndCopyBasePropertyControl( Panel_WorkerRestoreAll, "Static_Restore_Item_Icon_BG",		self._itemListBG,		"workerManager_restoreSlotBG_" .. resIdx )
		tempItemSlot.slotIcon		= UI.createAndCopyBasePropertyControl( Panel_WorkerRestoreAll, "Static_Restore_Item_Icon",			tempItemSlot.slotBG,	"workerManager_restoreSlot_" .. resIdx )
		tempItemSlot.selectIcon		= UI.createAndCopyBasePropertyControl( Panel_WorkerRestoreAll, "Static_Selected_Item_Icon",			tempItemSlot.slotBG,	"workerManager_selectedSlot_" .. resIdx )
		tempItemSlot.itemCount		= UI.createAndCopyBasePropertyControl( Panel_WorkerRestoreAll, "StaticText_Item_Count",				tempItemSlot.slotIcon,	"workerManager_restoreItemCount_" .. resIdx )
		tempItemSlot.restorePoint	= UI.createAndCopyBasePropertyControl( Panel_WorkerRestoreAll, "StaticText_Item_Restore_Value",		tempItemSlot.slotIcon,	"workerManager_restorePoint_" .. resIdx )

		tempItemSlot.slotBG			:SetPosX( 5 + (tempItemSlot.slotBG:GetSizeX() * resIdx) )
		tempItemSlot.slotBG			:SetPosY( 23 )
		tempItemSlot.slotIcon		:SetPosX( 5 )
		tempItemSlot.slotIcon		:SetPosY( 5 )
		tempItemSlot.selectIcon		:SetPosX( 2 )
		tempItemSlot.selectIcon		:SetPosY( 2 )
		tempItemSlot.itemCount		:SetPosX( tempItemSlot.slotIcon:GetSizeX() - 9 )
		tempItemSlot.itemCount		:SetPosY( tempItemSlot.slotIcon:GetSizeY() - 10 )
		tempItemSlot.restorePoint	:SetPosX( 3 )
		tempItemSlot.restorePoint	:SetPosY( 2 )

		tempItemSlot.slotBG			:addInputEvent( "Mouse_UpScroll",	"workerRestoreAll_SliderScroll( true )" )
		tempItemSlot.slotBG			:addInputEvent( "Mouse_DownScroll",	"workerRestoreAll_SliderScroll( false )" )
		tempItemSlot.slotIcon		:addInputEvent( "Mouse_UpScroll",	"workerRestoreAll_SliderScroll( true )" )
		tempItemSlot.slotIcon		:addInputEvent( "Mouse_DownScroll",	"workerRestoreAll_SliderScroll( false )" )
		tempItemSlot.selectIcon		:addInputEvent( "Mouse_UpScroll",	"workerRestoreAll_SliderScroll( true )" )
		tempItemSlot.selectIcon		:addInputEvent( "Mouse_DownScroll",	"workerRestoreAll_SliderScroll( false )" )

		self.restoreItemSlot[resIdx] = tempItemSlot
	end	
	
	self._itemListBG			:AddChild( self._slider )
	self._itemListBG			:addInputEvent("Mouse_UpScroll",	"workerRestoreAll_SliderScroll( true )" )
	self._itemListBG			:addInputEvent("Mouse_DownScroll",	"workerRestoreAll_SliderScroll( false )" )	
	self._btnCancel				:addInputEvent("Mouse_LUp",			"workerRestoreAll_Close()" )
	self._btnWinClose			:addInputEvent("Mouse_LUp",			"workerRestoreAll_Close()" )
	self._slider				:SetPosX( 10 )
	self._slider				:SetPosY( 75 )
	
	Panel_WorkerRestoreAll		:RemoveControl( self._slider )
end

local restoreItem_update = function()	
	local self		= workerRestoreAll
	for itemIdx = 0, self.restoreItemMaxCount - 1 do	-- 초기화
		local slot = self.restoreItemSlot[itemIdx]
		slot.slotBG		:SetShow( false )
		slot.slotIcon	:addInputEvent("Mouse_RUp", "")
		slot.selectIcon :addInputEvent("Mouse_RUp", "")
		slot.selectIcon :SetShow( false )
	end

	self.restoreItemHasCount = ToClient_getNpcRecoveryItemList()
	if self.restoreItemHasCount <= 0 then
		Panel_WorkerRestoreAll:SetShow( false )
	end
	local uiIdx = 0
	for itemIdx = self.sliderStartIdx, self.restoreItemHasCount - 1 do
		if self.restoreItemMaxCount <= uiIdx then	-- 초과하면 멈춘다.
			break
		end

		local slot = self.restoreItemSlot[uiIdx]
		slot.slotBG		:SetShow( true )
		if itemSelectList[itemIdx] then
			slot.selectIcon:SetShow( true )
		elseif false == itemSelectList[itemIdx] then
			slot.selectIcon:SetShow( false )
		end
		
		local recoveryItem	= ToClient_getNpcRecoveryItemByIndex( itemIdx )
		local itemStatic	= recoveryItem:getItemStaticStatus()
		slot.slotIcon		:ChangeTextureInfoName("icon/" .. getItemIconPath( itemStatic ) )
		slot.itemCount		:SetText( tostring(recoveryItem._itemCount_s64) )
		slot.restorePoint	:SetText( "+" .. tostring(recoveryItem._contentsEventParam1) )
		slot.slotIcon		:addInputEvent("Mouse_LUp",		"HandleClicked_restoreAll_SelectItem(" .. itemIdx .. ")")
		
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
	
	local workerCount = 0
	local totalPoint = 0
	local selectItem			= ToClient_getNpcRecoveryItemByIndex( self.selectedItemIdx )	
	local selectItemCount		= Int64toInt32( selectItem._itemCount_s64 )	
	local selectItemPoint		= selectItem._contentsEventParam1	
	local totalselectItemPoint  = selectItemCount * selectItemPoint
	for idx = 1, workerListCount do -- 회복 대상 일꾼
		local workerNoRaw		= workerArray[idx]
		local workerWrapperLua	= getWorkerWrapper(workerNoRaw, false)
		local maxPoint			= workerWrapperLua:getMaxActionPoint()
		local currentPoint		= workerWrapperLua:getActionPoint()		
		local restoreActionPoint = maxPoint - currentPoint
		if not workerWrapperLua:isWorking() then
			if currentPoint < maxPoint then
				workerCount = workerCount + 1
				totalPoint = totalPoint + restoreActionPoint			
			end
		end
	end
	
	self._workernPointValue:SetText(PAGetStringParam2( Defines.StringSheet_GAME, "LUA_WORKERRESTORE_TOTALPOINT", "count", tostring( workerCount ), "point", tostring( totalPoint ))) -- tostring( workerCount ) .. " 명/" .. tostring( totalPoint )
	if totalPoint <= totalselectItemPoint then
		self._restorePointValue:SetText( tostring( totalPoint ) )
	elseif totalselectItemPoint < totalPoint then
		self._restorePointValue:SetText( tostring( totalselectItemPoint ) )
	end
	
end

function HandleClicked_restoreAll_SelectItem( itemIdx ) -- 아이템 선택	
	local self	= workerRestoreAll
	for idx = 0, self.restoreItemHasCount - 1 do
		itemSelectList[idx] = false		
	end
	if nil == itemSelectList[itemIdx] or false == itemSelectList[itemIdx] then		
		itemSelectList[itemIdx] = true
		self.selectedItemIdx = itemIdx
	else
		itemSelectList[itemIdx] = false	
	end	
	self._btnConfirm			:addInputEvent("Mouse_LUp",			"workerRestoreAll_Confirm(" .. self.selectedItemIdx .. ")" )
	restoreItem_update()
end

function workerRestoreAll_SliderScroll( isUp ) -- 스크롤 관리
	local self = workerRestoreAll
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
	local self		= workerRestoreAll
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

function workerRestoreAll_Confirm( itemIdx )	
	local self	= workerRestoreAll	
	local recoveryItem		= ToClient_getNpcRecoveryItemByIndex( itemIdx )	
	local recoveryItemCount = Int64toInt32( recoveryItem._itemCount_s64 )	
	local restorePoint		= recoveryItem._contentsEventParam1	
	local slotNo			= recoveryItem._slotNo	
	local selectCheckCount	= 0	
	for ii = 0, self.restoreItemHasCount - 1 do		
		if true == itemSelectList[ii] then			
			selectCheckCount	= selectCheckCount + 1
		end
	end
	if 0 == selectCheckCount then		
		Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_NOSELECTITEM")) -- "선택한 아이템이 없습니다."
		return
	end		
	
	for idx = 1, workerListCount do
		local workerNoRaw		= workerArray[idx]
		local workerWrapperLua	= getWorkerWrapper(workerNoRaw, false)
		local maxPoint			= workerWrapperLua:getMaxActionPoint()
		local currentPoint		= workerWrapperLua:getActionPoint()		
		if not workerWrapperLua:isWorking() then
			if currentPoint < maxPoint then			
				local restoreItemCount = ToClient_getNpcRecoveryItemList()			
				local restoreActionPoint = maxPoint - currentPoint
				local itemNeedCount = restoreActionPoint / restorePoint
				local currentItemCount = recoveryItemCount
				for itemUseCount = 1, itemNeedCount + 1 do				
					if currentPoint ~= maxPoint and 0 ~= currentItemCount then										
						requestRecoveryWorker( WorkerNo(workerNoRaw), slotNo )
						currentItemCount = currentItemCount - 1
					elseif 0 == currentItemCount then
						Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERRESTORE_NORESTOREITEM")) -- "회복 아이템이 부족합니다."
						return
					end				
				end
			end		
		end
	end	
end

function FGlobal_restoreItem_update()
	restoreItem_update()
end


function FGlobal_WorkerRestoreAll_Open ( listCount, workerNoRaw )
	Panel_WorkerRestoreAll:SetPosX( getScreenSizeX() - Panel_WorkerManager:GetSizeX() - Panel_WorkerRestoreAll:GetSizeX() - 10 )
	Panel_WorkerRestoreAll:SetPosY( Panel_WorkerManager:GetPosY() )
	
	if ToClient_WorldMapIsShow() then
		WorldMapPopupManager:push( Panel_WorkerRestoreAll, true )	
	else
		Panel_WorkerRestoreAll:SetShow( true )
	end

	workerListCount	= listCount
	workerArray = workerNoRaw
	self.sliderStartIdx = 0
	HandleClicked_restoreAll_SelectItem( 0 )
end

function workerRestoreAll_Close()
	if ToClient_WorldMapIsShow() then
	-- 	WorldMapPopupManager:pop()
	-- else
		Panel_WorkerRestoreAll:SetShow( false )
	end
end

workerRestoreAll_Init()
WorldMapMode = {
		WORLDMAP_EXPLORATION = 0,
		WORLDMAP_TOWN = 1,
		WORLDMAP_WORKING = 2,
}
WorldMapPopupManager = {
	_currentMode = -1,
	_scenePopupArray = {},
	_scenePopupFunctionList = {},
	_backtown = {}
}

local emptyFunctionList = {}
function emptyFunctionList:beforePop()
end
function emptyFunctionList:afterPop()
end


function WorldMapPopupManager:increaseLayer(isAdd, functionList)
	local beforeMode =	self._currentMode
	self._currentMode = beforeMode + 1;
	if( 0 > beforeMode ) then
		return
	end
	
	if ( nil ~= functionList ) then
		self._scenePopupFunctionList[self._currentMode] = functionList
	else
		self._scenePopupFunctionList[self._currentMode] = emptyFunctionList
	end


	local popArray = self._scenePopupArray[beforeMode] 
	if true == isAdd then
		return	-- 이전 창을 닫지 않는 경우!
	end
	if( 0 ~= popArray:length() ) then
		for key, value in pairs( popArray ) do
			value._panel:SetShow(false);
		end
	end

end

function WorldMapPopupManager:push( panel, isShow , openFunc, closeFunc )
	
	local mode = self._currentMode;
	if( nil == self._scenePopupArray[mode] ) then
		self._scenePopupArray[mode] = Array.new()
	end
	local popArray = self._scenePopupArray[mode];
			
	for key, value in pairs( popArray ) do
		if( panel == value ) then
			return
		end
	end
	if panel == Panel_HouseControl or panel == Panel_RentHouse_WorkManager or panel == Panel_LargeCraft_WorkManager or panel == Panel_Window_Warehouse then
		panel:SetShow(isShow, true)
	else
		panel:SetShow(isShow)
	end

	local item = {
			_panel 		= panel,
			_show 		= isShow,
			_openFunc 	= openFunc,
			_cloSefunc 	= closeFunc
	}
	self._scenePopupArray[self._currentMode]:push_back( item );
end

function WorldMapPopupManager:popPanel()
	local value = self._scenePopupArray[self._currentMode]:pop_back();
	value._panel:SetShow(false)
	if( nil ~= value._cloSefunc ) then
		value._cloSefunc();
	end
end

function WorldMapPopupManager:pop()
	if( 0 > self._currentMode ) then
		return false
	end
	local mode = self._currentMode

	if( nil == self._scenePopupArray[mode] ) then
		self._currentMode = self._currentMode - 1;
	end

	local popArray = self._scenePopupArray[mode] 
	if ( nil ~= self._scenePopupFunctionList[mode] ) and ( nil ~= self._scenePopupFunctionList[mode].beforePop ) then
		self._scenePopupFunctionList[mode]:beforePop()
	end

	local postWareHouseOn = false
	local check_Panel = nil
	if( 0 ~= popArray:length() ) then
		for key, value in pairs( popArray ) do			
			check_Panel = value._panel			
			if value._panel == Panel_HouseControl or value._panel == Panel_RentHouse_WorkManager  or value._panel == Panel_LargeCraft_WorkManager or value._panel == Panel_Window_Warehouse then
				value._panel:SetShow(false, true)				
			else
				value._panel:SetShow(false)				-- 기존 패널을 꺼준다.
			end

			if( nil ~= value._cloSefunc ) then
				value._cloSefunc();
			end

			if value._panel == Panel_HouseControl then
				clear_HouseSelectedAni_byHouse()
			elseif value._panel == Panel_House_SellBuy_Condition then
				clear_HouseSelectedAni_bySellBuy()
			elseif value._panel == Worldmap_Grand_GuildHouseControl then
				postWareHouseOn = true
			end				
		end
	end

	FGlobal_ClearWorldmapIconTooltip()
	self._scenePopupArray[mode] = Array.new()
	self._scenePopupFunctionList[mode] = emptyFunctionList
	self._currentMode = self._currentMode - 1;

	if( 0 <= self._currentMode ) then
		if (nil ~= self._scenePopupFunctionList[self._currentMode] ) and ( nil ~= self._scenePopupFunctionList[self._currentMode].afterPop ) then
			self._scenePopupFunctionList[self._currentMode]:afterPop()
		end
		popArray = self._scenePopupArray[ self._currentMode ];
		for key, value in pairs( popArray ) do
			if value._panel == Panel_HouseControl or value._panel == Panel_RentHouse_WorkManager  or value._panel == Panel_LargeCraft_WorkManager or value._panel == Panel_Window_Warehouse then
				value._panel:SetShow(value._show, true)
			else
				value._panel:SetShow( value._show )		-- 때에 따라 다른 패널들을 켜준다.
			end			
			if( false == value._show and nil ~= value._cloSefunc ) then
				value._cloSefunc();
			elseif( true == value._show and nil ~= value._openFunc ) then
				value._openFunc()
			end
			if value._panel == Panel_HouseControl then
				show_HouseSelectedAni_byHouse()
				if check_Panel == Panel_LargeCraft_WorkManager then
					HouseProgressSection_Set(eWorkType.largeCraft)
					FGlobal_Set_HousePanelPos(check_Panel)
				elseif check_Panel == Panel_RentHouse_WorkManager then
					FGlobal_Set_HousePanelPos(check_Panel)
				end
			elseif value._panel == Panel_Window_Warehouse then
				FromClient_WarehouseUpdate()
			end
		end
	end
	
	-- 툴팁 초기화
	Panel_Tooltip_Item_hideTooltip()
	FGlobal_InitWorkerTooltip()
	FGlobal_Hide_Tooltip_Work(workIndex, true)
	if ( postWareHouseOn ) then
		FGlobal_LoadWorldMap_WarehouseOpen()	-- 창고를 다시 켜기 위해.
	end

	return true;
end

function WorldMapPopupManager:clear()
	if( self._currentMode < 0 ) then
			return
	end
	for mode = 0, self._currentMode do
		local popArray = self._scenePopupArray[mode];

		for key, value in pairs( popArray ) do
			value._panel:SetShow(false);
		end
		self._scenePopupArray[mode] = Array.new();
	end	
	self._currentMode = -1
end

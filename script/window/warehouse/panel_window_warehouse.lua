Panel_Window_Warehouse:SetShow( false, false )
Panel_Window_Warehouse:setMaskingChild(true)
Panel_Window_Warehouse:ActiveMouseEventEffect(true)
Panel_Window_Warehouse:setGlassBackground(true)

Panel_Window_Warehouse:RegisterShowEventFunc( true, 'WarehouseShowAni()' )
Panel_Window_Warehouse:RegisterShowEventFunc( false, 'WarehouseHideAni()' )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local isOpenSellOff	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 58 )		-- 창고 정리 컨텐츠 열렸는지 체크

function WarehouseShowAni()
	Panel_Window_Warehouse:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_Window_Warehouse, 0.0, 0.15 )
	audioPostEvent_SystemUi(01,00)
end

function WarehouseHideAni()
	Panel_Window_Warehouse:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_Warehouse:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	
	audioPostEvent_SystemUi(01,00)
end
	
local effectScene = {
	newItem = {}
}

local _wareHouse_HelpMovie 			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Window_Warehouse, 'Static_ClassMovie' )
local _wareHouse_HelpMovie_Btn		= UI.getChildControl( Panel_Window_Warehouse, "Static_MoviePlayButton" )
local _wareHouseHelp				= UI.getChildControl( Panel_Window_Warehouse, "StaticText_LoaderHelp" )

local warehouse = {
	slotConfig =
	{
		-- 일단 아이콘, 테두리, 카운트숫자) 만 적용한다!
		createIcon			= true,
		createBorder		= true,
		createCount			= true,
		createEnchant		= true,
		createCash			= true,
		createEnduranceIcon = true,
		createCheckBox		= true,
	},
	
	config = 
	{
		-- 이 값들은 추후에 메시지로 빼어내어 세팅해야 한다!
		slotCount	= 64,		--UI 크기에 맞췄다
		slotCols	= 8,
		slotRows	= 0,		-- 계산되는 값	
		slotStartX	= 19,		--10
		slotStartY	= 64,		--64
		slotGapX	= 47,		--47
		slotGapY	= 47,		--47
	},
	
	-- 컨트롤들
	blankSlots		= Array.new(),
	slots			= Array.new(),
	slotNilEffect	= {},
	slotFilterEffect= {},
	
	staticTitle		= UI.getChildControl( Panel_Window_Warehouse, "Static_Text_Title"			),
	staticCapacity	= UI.getChildControl( Panel_Window_Warehouse, "Static_Text_Capacity"		),
	staticWeight	= UI.getChildControl( Panel_Window_Warehouse, "Static_Text_Weight"			),
	staticMoney		= UI.getChildControl( Panel_Window_Warehouse, "Static_Text_Money"			),
	buttonMoney		= UI.getChildControl( Panel_Window_Warehouse, "Button_Money"				),	-- 창고 돈
	buttonMoney2	= UI.getChildControl( Panel_Window_Warehouse, "Button_Money_2"				),	-- 자산가치 돈
	buttonClose		= UI.getChildControl( Panel_Window_Warehouse, "Button_Win_Close"			),
	buttonQuestion 	= UI.getChildControl( Panel_Window_Warehouse, "Button_Question"				),	-- 물음표 버튼
	checkSort		= UI.getChildControl( Panel_Window_Warehouse, "CheckButton_ItemSort"		),
	BtnMarketRegist	= UI.getChildControl( Panel_Window_Warehouse, "Button_ItemMarketRegist"		),	-- 거래소 등록
	BtnManufacture	= UI.getChildControl( Panel_Window_Warehouse, "Button_Manufacture"			),	-- 가공
	BtnSellOff		= UI.getChildControl( Panel_Window_Warehouse, "Button_SellOff"				),	-- 잡템 처분
	BtnSellCheck	= UI.getChildControl( Panel_Window_Warehouse, "Button_SellCheck"			),	-- 잡템 정리
	_buttonDelivery	= UI.getChildControl( Panel_Window_Warehouse, "Button_DeliveryInformation"	),	-- 운송
	BtnGuildUpdate	= UI.getChildControl( Panel_Window_Warehouse, "Button_GuildUpdate"	),			-- 길드 업데이트

	_scroll			= UI.getChildControl( Panel_Window_Warehouse, "Scroll_WareHouse"			),
	
	moneyTitle		= UI.getChildControl( Panel_Window_Warehouse, "StaticText_MoneyTitle" 		),
	
	bottomBG		= UI.getChildControl( Panel_Window_Warehouse, "Static_BlackPanel_Bottom1"	),	-- 실버, 자산가치 배경

	assetBG			= UI.getChildControl( Panel_Window_Warehouse, "Static_BlackPanel_Bottom2"	),	-- 자산 가치 배경
	assetTitle		= UI.getChildControl( Panel_Window_Warehouse, "StaticText_AssetValueTitle"	),	-- 자산 가치 타이틀
	assetValue		= UI.getChildControl( Panel_Window_Warehouse, "StaticText_AssetValue"		),	-- 자산 가치 값

	
	_currentWaypointKey			= 0,															--현재 마을 키
	_currentRegionName			= 'None',														--현재 마을 이름
	_fromType					= CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap,		--창고를 접근한 타입 ( 월드, npc, 설치물 )
	_installationActorKeyRaw	= 0,															--창고를 접근한 설치물 ActorKeyRaw
	_targetActorKeyRaw			= nil,															--이동 할 ActorKey ( 탈것 or 플레이어 )
	_deleteSlotNo				= nil,
	_s64_deleteCount			= Defines.s64_const.s64_0,
	_startSlotIndex				= 0,
	_tooltipSlotNo				= nil,
	_myAsset					= toInt64(0,0),

	itemMarketFilterFunc		= nil,
	itemMarketRclickFunc		= nil,
	
	manufactureFilterFunc		= nil,
	manufactureRclickFunc		= nil,
	
	addSizeY					= 30,
	sellCheck					= false,
}

----------------------------------------------------------------------------
--	Init
----------------------------------------------------------------------------
function	warehouse:init()
	_wareHouse_HelpMovie_Btn:addInputEvent( "Mouse_On",		"Panel_WareHouse_MovieHelpFunc( true )"	)
	_wareHouse_HelpMovie_Btn:addInputEvent( "Mouse_Out",	"Panel_WareHouse_MovieHelpFunc( false )")

	self.config.slotRows	= self.config.slotCount / self.config.slotCols

	for ii = 0, self.config.slotCount-1 do
		local	slotNo	= ii+1
		local	slot	= {}

		slot.empty	= UI.createAndCopyBasePropertyControl( Panel_Window_Warehouse, "Static_Slot",			Panel_Window_Warehouse,	"Warehouse_Slot_Base_"		.. ii )
		slot.lock	= UI.createAndCopyBasePropertyControl( Panel_Window_Warehouse, "Static_LockedSlot",		Panel_Window_Warehouse,	"Warehouse_Slot_Lock_"		.. ii )

		UIScroll.InputEventByControl(	slot.empty,	"Warehouse_Scroll"	)

		-- position Set
		local row	= math.floor( ii / self.config.slotCols )
		local column= ii % self.config.slotCols
		
		slot.empty:SetPosX( self.config.slotStartX	+ self.config.slotGapX * column	)
		slot.empty:SetPosY( self.config.slotStartY	+ self.config.slotGapY * row	)
		slot.lock:SetPosX( self.config.slotStartX	+ self.config.slotGapX * column	)
		slot.lock:SetPosY( self.config.slotStartY	+ self.config.slotGapY * row	)
		
		slot.empty:SetShow( false )
		slot.lock:SetShow( true )

		self.blankSlots[ii] = slot
	end

	for ii = 0, self.config.slotCount-1 do
		local	slot	= {}

		SlotItem.new( slot, 'ItemIcon_' .. ii, ii, Panel_Window_Warehouse, self.slotConfig )
		slot:createChild()
		-- Panel_Window_Warehouse:SetChildIndex(slot.empty:GetKey(), 9990 )
		-- Panel_Window_Warehouse:SetChildIndex(slot.lock:GetKey(), 9990 )
		-- Panel_Window_Warehouse:SetChildIndex(slot.useless:GetKey(), 9990 )
		-- Panel_Window_Warehouse:SetChildIndex(slot.icon:GetKey(), 9999 )

		-- position Set
		local row	= math.floor( ii / self.config.slotCols )
		local column= ii % self.config.slotCols
		slot.icon:SetPosX( self.config.slotStartX	+ self.config.slotGapX * column	)
		slot.icon:SetPosY( self.config.slotStartY	+ self.config.slotGapY * row	)
		
		slot.icon:SetEnableDragAndDrop(true)
		slot.icon:SetAutoDisableTime( 0.5 )
		
		slot.icon:addInputEvent("Mouse_RUp",				"HandleClickedWarehouseItem("	.. ii .. ")"	)
		slot.icon:addInputEvent("Mouse_LUp",				"Warehouse_DropHandler("		.. ii .. ")"	)
		slot.icon:addInputEvent("Mouse_PressMove",			"Warehouse_SlotDrag("			.. ii .. ")"	)
		slot.icon:addInputEvent("Mouse_On",					"Warehouse_IconOver("			.. ii .. ")"	)
		slot.icon:addInputEvent("Mouse_Out",				"Warehouse_IconOut("			.. ii .. ")"	)
		
		UIScroll.InputEventByControl(	slot.icon,	"Warehouse_Scroll"	)
			
		Panel_Tooltip_Item_SetPosition( ii, slot, "WareHouse" )
		
		self.slots[ii] = slot	
	end
	
	self.BtnManufacture		:addInputEvent("Mouse_LUp", "HandleClicked_ManufactureOpen()")	
	self.BtnMarketRegist	:addInputEvent("Mouse_LUp",	"HandleClicked_WhItemMarketRegistItem_Open()")
	self.BtnMarketRegist	:SetShow( false )
	self.BtnSellOff			:addInputEvent("Mouse_LUp", "HandleClicked_SellOff()")
	self.BtnSellCheck		:addInputEvent("Mouse_LUp", "HandleClicked_SellCheck()" )
	self.BtnGuildUpdate		:addInputEvent("Mouse_LUp", "HandleClicked_GuildWareHouseUpdate()")	

	self._scroll:SetShow( true )
	--_wareHouse_HelpMovie:SetUrl(320, 240, "coui://UI_Data/UI_Html/UI_Guide_Movie.html")
	_wareHouse_HelpMovie:SetSize(320, 240)
	_wareHouse_HelpMovie:SetSpanSize(-1,0)
	_wareHouse_HelpMovie:SetShow(false)	
	
	self.BtnManufacture		:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_BTNTEXT_1" )) -- "가공" )
	self.BtnMarketRegist	:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_BTNTEXT_2" )) -- "거래소" )
	self.BtnSellOff			:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_BTNTEXT_3" )) -- "창고처분" )
	self.BtnSellCheck		:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_BTNTEXT_4" )) -- "창고정리" )
end

local btnMarketRegSpanSizeY = warehouse.BtnMarketRegist:GetSpanSize().y
function	warehouse:update()
	local	warehouseWrapper	= self:getWarehouse()
	if	( nil == warehouseWrapper )	then
		return
	end
	
	local addSizeY = 0
	if warehouse:isNpc() then
		addSizeY = self.addSizeY
	end

	local	useStartSlot= 1	--inventorySlotNoUserStart()
	local	itemCount	= warehouseWrapper:getSize()						-- 아이템 갯수
	local	useMaxCount	= warehouseWrapper:getUseMaxCount() 				-- 최대 (현재 뚫려있는) 슬롯 개수 -1(돈)
	local	freeCount	= warehouseWrapper:getFreeCount()					-- 넣을 수 있는 아이템 개수
	local	money_s64	= warehouseWrapper:getMoney_s64()
	local	maxCount	= warehouseWrapper:getMaxCount()					-- 최대 뚫을 수 있는 슬롯 개수 -1(돈)

	-- 개수 설정
	--	창고에  소지한 아이템 갯수가 최대치를 넘어서면 붉은 색으로 바꾼다.
	--{
		if	( (useMaxCount - useStartSlot) < itemCount )	then
			self.staticCapacity:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "Lua_WareHouse_OverCapacity",	"HaveCount", tostring(itemCount), "FullCount", tostring(useMaxCount - useStartSlot) ) )
		else
			self.staticCapacity:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "Lua_WareHouse_Capacity",		"HaveCount", tostring(itemCount), "FullCount", tostring(useMaxCount - useStartSlot) ) )
		end
		self.staticMoney:SetText( makeDotMoney(money_s64) )
	--}
	
	--{
		local	slotNoList	= Array.new()
		slotNoList:fill( useStartSlot, maxCount - 1 )
	--}

	-- 아이템 정렬
	--{
		if self.checkSort:IsCheck() then
			local	sortList	= Array.new()
			sortList:fill( useStartSlot , useMaxCount - 1 )	-- 2 ~ 17
			sortList:quicksort( Warehouse_ItemComparer )
			
			for	ii = 1, useMaxCount - 1	do
				slotNoList[ii]	= sortList[ii]
			end
		end
	--}
	
	
	--Empty & Lock Slot
	--{
		for	ii = 0, self.config.slotCount -1	do
			local	slot	= self.blankSlots[ii]
			
			slot.empty:SetShow( false )
			slot.lock:SetShow( false )
			
			if( ii < (useMaxCount - useStartSlot - self._startSlotIndex) )	then
				slot.empty:SetShow( true )
			else
				slot.lock:SetShow( true )
			end
		end
	--}

	-- 스크롤
	--{
		UIScroll.SetButtonSize( self._scroll, self.config.slotCount, (maxCount - useStartSlot) )
	--}
	
	--{ 슬롯 초기화
		for ii = 0, self.config.slotCount-1	do
			local	slot	= self.slots[ii]
			
			slot:clearItem()
			slot.icon:SetEnable( true )
			slot.icon:SetMonoTone( true )
		end
	--}

	--{ 자산 가치 업데이트, 전체 슬롯 대상이다.
		if not self:isGuildHouse() then
			self._myAsset	= toInt64(0,0)	-- 자산 초기화.
			if 2 <= useMaxCount then
				for ii = 0, useMaxCount-2	do
					-- local slot			= self.slots[ii]
					local slotNo		= slotNoList[1 + ii + 0]
					local itemWrapper	= warehouseWrapper:getItem( slotNo )
					if	nil ~= itemWrapper	then
						local itemSSW			= itemWrapper:getStaticStatus()
						local itemEnchantKey	= itemSSW:get()._key:get()
						local itemCount_s64		= itemWrapper:get():getCount_s64()
						local npcSellPrice_s64	= itemSSW:get()._sellPriceToNpc_s64
						local tradeInfo			= nil
						local tradeSummaryInfo	= getItemMarketSummaryInClientByItemEnchantKey( itemEnchantKey )
						local tradeMasterInfo	= getItemMarketMasterByItemEnchantKey( itemEnchantKey )

						if nil ~= tradeSummaryInfo then
							tradeInfo = tradeSummaryInfo
						elseif nil ~= tradeMasterInfo then
							tradeInfo = tradeMasterInfo
						else
							tradeInfo = nil
						end
						if nil ~= tradeInfo then
							if nil ~= tradeSummaryInfo and ( toInt64(0,0) ~= tradeSummaryInfo:getDisplayedTotalAmount() ) then
								self._myAsset = self._myAsset + (((tradeInfo:getDisplayedLowestOnePrice() + tradeInfo:getDisplayedHighestOnePrice()) / toInt64(0,2)) * itemCount_s64 )
							else
								self._myAsset = self._myAsset + (((tradeMasterInfo:getMinPrice() + tradeMasterInfo:getMaxPrice()) / toInt64(0,2)) * itemCount_s64 )
							end
						else	-- 판매가로 가져옴.
							self._myAsset = self._myAsset + (npcSellPrice_s64 * itemCount_s64 )
						end
					end
				end
			end
			self.assetTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_WAREHOUSE_ASSETS") ) -- "거래소 기준 자산 가치" )
			self.assetValue:SetText( makeDotMoney( self._myAsset + money_s64 ) )
			-- self.assetValue:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WAREHOUSE_MYSILVER", "myAsset", makeDotMoney( self._myAsset + money_s64 ) ) ) -- makeDotMoney( self._myAsset + money_s64 ) .. " 은화" )
		end
	-- }

	--{ 슬롯 업데이트 하는 곳
		for ii = 0, self.config.slotCount-1	do
			local	slot	= self.slots[ii]
			local	slotNo	= slotNoList[1 + ii + self._startSlotIndex ]
			slot.slotNo	= slotNo
			
			-- position Set
			local	row		= math.floor( ii / self.config.slotCols )
			local	column	= ii % self.config.slotCols
			slot.icon:SetPosX( self.config.slotStartX + self.config.slotGapX * column	)
			slot.icon:SetPosY( self.config.slotStartY + self.config.slotGapY * row		)
			
			slot.icon:SetMonoTone(false)
			slot.count:SetShow(false)
			
			-- _PA_LOG("유흥신", "warehouseslotNo : " ..tostring(slotNo) .." "..tostring(ii) .." "..tostring(self._startSlotIndex) );
		
			local	itemExist	= false
			local	itemWrapper	= warehouseWrapper:getItem( slotNo )
			
			if	(nil ~= itemWrapper)	then
				slot:setItem( itemWrapper )
				if nil ~= self.itemMarketFilterFunc then
					if false == self.itemMarketFilterFunc( slot.icon, itemWrapper ) then
						if self.slotFilterEffect[ii] then
							slot.icon:EraseEffect(self.slotFilterEffect[ii])
							self.slotFilterEffect[ii] = nil
						end
						self.slotFilterEffect[ii] = slot.icon:AddEffect( "UI_Inventory_Filtering" , true, 0, 0)
						slot.icon:SetMonoTone( false )
						slot.icon:SetEnable( true )
						slot.icon:SetIgnore( false )
					else
						if self.slotFilterEffect[ii] then
							slot.icon:EraseEffect(self.slotFilterEffect[ii])
							self.slotFilterEffect[ii] = nil
						end
						slot.icon:SetMonoTone( true )
						slot.icon:SetEnable( false )
						slot.icon:SetIgnore( true )
					end
					
				elseif nil ~= self.manufactureFilterFunc then
					if false == self.manufactureFilterFunc( slot.slotNo, itemWrapper ) then
						if self.slotFilterEffect[ii] then
							slot.icon:EraseEffect(self.slotFilterEffect[ii])
							self.slotFilterEffect[ii] = nil
						end
						self.slotFilterEffect[ii] = slot.icon:AddEffect( "UI_Inventory_Filtering" , true, 0, 0)
						slot.icon:SetMonoTone( false )
						slot.icon:SetEnable( true )
						slot.icon:SetIgnore( false )
					else
						if self.slotFilterEffect[ii] then
							slot.icon:EraseEffect(self.slotFilterEffect[ii])
							self.slotFilterEffect[ii] = nil
						end
						slot.icon:SetMonoTone( true )
						slot.icon:SetEnable( false )
						slot.icon:SetIgnore( true )
					end
					
				else
					if self.slotFilterEffect[ii] then
						slot.icon:EraseEffect(self.slotFilterEffect[ii])
						self.slotFilterEffect[ii] = nil
					end
					slot.icon:SetMonoTone( false )
					slot.icon:SetEnable( true )
					slot.icon:SetIgnore( false )
				end

				if nil ~= self.itemMarketRclickFunc then
					-- self.itemMarketRclickFunc( slot.slotNo, slot.icon, itemWrapper, itemWrapper:get():getCount_s64() )
				end

				if nil == self.itemMarketFilterFunc then	-- 아이템 거래소가 아닐경우만 수송 모노톤 처리
					local	packingCount_s64 = delivery_getPackItemCount( slotNo )
					if	(Defines.s64_const.s64_0 == itemWrapper:get():getCount_s64() )	then -- 운송 시킨 아이템이 1개라도 있으면.
						slot.icon:SetMonoTone( true )
					else
						slot.count:SetShow( true )
					end
				end
				
				itemExist = true
				if self.sellCheck then
					-- 거래소에 올릴 수 있냐? 캐시 아이템이 아니냐? 상점에서 팔지 않는 아이템이냐?
					if (not warehouse_itemMarketFilterFunc( nil, itemWrapper )) and (not itemWrapper:isCash()) and (itemWrapper:getStaticStatus():isDisposalWareHouse()) then
						local isCheck = warehouseWrapper:isSellToSystem( slotNo )
						slot.checkBox:SetShow( true )
						slot.checkBox:SetCheck( isCheck )
						slot.checkBox:addInputEvent( "Mouse_LUp", "Warehouse_CheckBoxSet(" .. slotNo .. ")" )
						slot.icon:SetMonoTone( false )
					else
						slot.icon:SetMonoTone( true )
					end
				else
					slot.checkBox:SetShow( false )
				end
			else
				if nil ~= self.slotFilterEffect[ii] then
					slot.icon:EraseEffect(self.slotFilterEffect[ii])
					self.slotFilterEffect[ii] = nil
				end
				slot.icon:SetMonoTone( false )
				slot.icon:SetEnable( true )
				slot.icon:SetIgnore( false )
			end
			
			if not itemExist then
				slot:clearItem()
				slot.icon:SetEnable( true )
				slot.icon:SetMonoTone( true )
				slot.icon:SetIgnore( false )
			end
		end
	--}

	-- { 길드 창고가 아닐 때는 자산 가치를 보이지 않게 한다
		if not self:isGuildHouse() then	-- 길드 창고가 아니다.
			-- 패널 사이즈
			-- Panel_Window_Warehouse:SetSize( Panel_Window_Warehouse:GetSizeX(), 550 )
			
			-- 자산가치 관련 컨트롤
			self.bottomBG	:SetSize( self.bottomBG:GetSizeX(), 85 )
			self.assetBG	:SetShow( true )
			self.assetTitle	:SetShow( true )
			self.assetValue	:SetShow( true )
		else
			-- 패널 사이즈
			-- Panel_Window_Warehouse:SetSize( Panel_Window_Warehouse:GetSizeX(), 520 )

			-- 자산가치 관련 컨트롤
			self.bottomBG	:SetSize( self.bottomBG:GetSizeX(), 55 )
			self.assetBG	:SetShow( false )
			self.assetTitle	:SetShow( false )
			self.assetValue	:SetShow( false )
		end
	-- }
	
	WareHouse_PanelSize_Change( warehouse:isNpc() )
end

function	warehouse:isNpc()
	return( CppEnums.WarehoouseFromType.eWarehoouseFromType_Npc == self._fromType )
end

function	warehouse:isInstallation()
	return( CppEnums.WarehoouseFromType.eWarehoouseFromType_Installation == self._fromType )
end

function	warehouse:isWorldMapNode()
	return( CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap == self._fromType )
end

function	warehouse:isGuildHouse()
	return( CppEnums.WarehoouseFromType.eWarehoouseFromType_GuildHouse == self._fromType )
end

function	warehouse:isMaid()
	return( CppEnums.WarehoouseFromType.eWarehoouseFromType_Maid == self._fromType )
end

function	warehouse:isManufacture()
	return( CppEnums.WarehoouseFromType.eWarehoouseFromType_Manufacture == self._fromType )
end

function	warehouse:isDeliveryWindow()
	return( Panel_Window_Delivery_Request:GetShow() )
end

function	warehouse:getWarehouse()
	local	warehouseWrapper	= nil
	if( warehouse:isGuildHouse() ) then
		warehouseWrapper	= warehouse_getGuild()
	else
		warehouseWrapper	= warehouse_get( self._currentWaypointKey )
	end
	
	return (warehouseWrapper)
end

----------------------------------------------------------------------------
--							영상 설명 전용 함수
----------------------------------------------------------------------------
function Panel_WareHouse_MovieHelpFunc( isOn )
	_wareHouse_HelpMovie:SetPosX(Panel_Window_Warehouse:GetSizeX() )
	_wareHouse_HelpMovie:SetPosY( 70 )
	_wareHouseHelp:SetPosX( _wareHouse_HelpMovie:GetPosX() )
	_wareHouseHelp:SetPosY( _wareHouse_HelpMovie:GetPosY() - _wareHouseHelp:GetSizeY() )
	
	if ( isOn == true ) then
		_wareHouseHelp:SetShow( true )
		-- _wareHouseHelp:SetAutoResize( true )
		_wareHouseHelp:SetSize( 320, 40 )
		_wareHouseHelp:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_wareHouseHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_WAREHOUSE_HELP" )) -- <PAColor0xFFFFD649>적재소<PAOldColor>가 늘어날수록 창고 슬롯이 더 많이 개방됩니다.
		
		_wareHouse_HelpMovie:SetShow( true )
		_wareHouse_HelpMovie:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/WareHouse_AddSlot_KR.webm" )
	else
		_wareHouseHelp:SetShow( false )
		_wareHouse_HelpMovie:SetShow( false )
	end
end



----------------------------------------------------------------------------
--	FromClient 이벤트
----------------------------------------------------------------------------
function	warehouse:registMessageHandler()
	registerEvent("FromClient_WarehouseOpenByInstallation",	"FromClient_WarehouseOpenByInstallation")
	registerEvent("EventWarehouseUpdate",					"FromClient_WarehouseUpdate")
	registerEvent("FromClient_WarehouseClose",				"FromClient_WarehouseClose")
	registerEvent("EventGuildWarehouseUpdate",				"FromClient_GuildWarehouseUpdate")
end

----------------------------------------------------------------------------
-- Control 이벤트
----------------------------------------------------------------------------
function warehouse:registEventHandler()
	UIScroll.InputEvent(			self._scroll,			"Warehouse_Scroll"	)
	UIScroll.InputEventByControl(	Panel_Window_Warehouse,	"Warehouse_Scroll"	)
	self.buttonClose:addInputEvent(				"Mouse_LUp",		"Warehouse_Close()" 				)
	self.buttonMoney:addInputEvent(				"Mouse_LUp",		"HandleClickedWarehousePopMoney()"	)
		
	self.buttonQuestion:addInputEvent(			"Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"WareHouse\" )" )	-- 물음표 좌클릭
	self.buttonQuestion:addInputEvent(			"Mouse_On",			"HelpMessageQuestion_Show( \"WareHouse\", \"true\")" )	-- 물음표 마우스오버
	self.buttonQuestion:addInputEvent(			"Mouse_Out",		"HelpMessageQuestion_Show( \"WareHouse\", \"false\")" )	-- 물음표 마우스아웃	
	self._buttonDelivery:addInputEvent(			"Mouse_LUp",		"Warehouse_OpenDelivery()" )
	self.checkSort:addInputEvent(				"Mouse_LUp",		"Warehouse_CheckSort()" )
	--UI.debugMessage( "등록" )
end

----------------------------------------------------------------------------
--	Global Function
----------------------------------------------------------------------------
function	FGlobal_Warehouse_IsMoveItem()
	local	self	= warehouse
	if self:isNpc() or self:isInstallation() or not self:isWorldMapNode() or self:isDeliveryWindow() or self:isGuildHouse() or self:isMaid() then
		return(true)
	end
	
	return(false)
end

function	FromClient_WarehouseUpdate()
	if	not Panel_Window_Warehouse:GetShow()	then
		return
	end
	
	local	self	= warehouse
	self:update()
end

function	FromClient_WarehouseClose()
	Warehouse_Close()
end

function FromClient_GuildWarehouseUpdate( bForcedOpen, bForcedClose )
	if Worldmap_Grand_GuildHouseControl:GetShow() or Worldmap_Grand_GuildCraft:GetShow() then
		-- 길드 제작창이 열려 있을 때는 업데이트하지 않는다.
		return
	end

	-- 길드 상점이 열려있는 경우 물건을 팔면 길드 창고의 길드 자금으로 들어오기에 이 함수가 호출이 된다.
	if Panel_Window_NpcShop:IsShow() then
		NpcShop_UpdateContent();
		return;
	end
	
	if( false == bForcedOpen ) then
		if(  false == Panel_Window_Warehouse:GetShow() ) then
			return;
		end
	end
	
	if( true == bForcedClose ) then
		Warehouse_Close()
		return;
	end
	
	local	self	= warehouse
	self._currentWaypointKey	= 0
	self._fromType				= CppEnums.WarehoouseFromType.eWarehoouseFromType_GuildHouse;
	self._currentRegionName		= PAGetString(Defines.StringSheet_GAME, "Lua_WareHouse_CurrentRegionName") -- '길드 하우스의 창고'
	self.staticTitle:SetText( self._currentRegionName )

	self:update()
	
	if	FGlobal_Warehouse_IsMoveItem()	then
		self.buttonMoney:SetIgnore(false)
	else
		self.buttonMoney:SetIgnore(true)
	end

	-- 길드 창고는 운송, 가공, 거래소 버튼이 나타나지 않는다.
	warehouse.BtnMarketRegist	:SetShow( false )
	warehouse.BtnManufacture	:SetShow( false )
	warehouse._buttonDelivery	:SetShow( false )
	warehouse.BtnGuildUpdate	:SetShow( true )

	-- 길드 창고는 실버를 옮길 수 없다.
	Warehouse_SetIgnoreMoneyButton( true )

	
	-- if	not Panel_Window_Warehouse:GetShow()	then
		Panel_Window_Warehouse:ChangeSpecialTextureInfoName("")
		Panel_Window_Warehouse:SetAlphaExtraChild(1)
		Panel_Window_Warehouse:SetShow( true, true )
	-- end
	
	Warehouse_OpenWithInventory()
end

---------------------------------------
-- 패널 사이즈 및 컨트롤 포지션 수정 --
---------------------------------------
local panelSizeY = Panel_Window_Warehouse:GetSizeY()
local bg1_y = warehouse.bottomBG:GetSizeY()
local bg2_y = warehouse.assetBG:GetSizeY()
local assetTitlePosY = warehouse.assetTitle:GetPosY()
local assetValuePosY = warehouse.assetValue:GetPosY()
local staticCapacityPosY = warehouse.staticCapacity:GetPosY()
local moneyValuePosY = warehouse.staticMoney:GetPosY()
function WareHouse_PanelSize_Change( isNpc )
	local self = warehouse
	local bigSizeY
	if isNpc and isOpenSellOff then
		bigSizeY = self.addSizeY
		self.moneyTitle:SetShow( true )
		if self.BtnManufacture:GetShow() or self.BtnMarketRegist:GetShow() then
			self.staticCapacity:SetPosY( staticCapacityPosY - 14 )
		else
			self.staticCapacity:SetPosY( staticCapacityPosY + bigSizeY )
		end
	else
		bigSizeY = 0
		self.moneyTitle:SetShow( false )
		self.staticCapacity:SetPosY( staticCapacityPosY + bigSizeY )
	end
	
	if not self:isGuildHouse() then	-- 길드 창고가 아니다.
		Panel_Window_Warehouse:SetSize( Panel_Window_Warehouse:GetSizeX(), panelSizeY + bigSizeY )
	else
		Panel_Window_Warehouse:SetSize( Panel_Window_Warehouse:GetSizeX(), panelSizeY - bigSizeY )
	end
	
	self.bottomBG:SetSize( self.bottomBG:GetSizeX(), bg1_y + bigSizeY )
	self.assetBG:SetSize( self.assetBG:GetSizeX(), bg2_y + bigSizeY )
	self.assetTitle:SetPosY( assetTitlePosY + bigSizeY )
	self.assetValue:SetPosY( assetValuePosY + bigSizeY )
	self.staticMoney:SetPosY( moneyValuePosY + bigSizeY )
	self.buttonMoney:SetSpanSize( self.staticMoney:GetTextSizeX() + self.buttonMoney:GetSizeX() + 2, self.staticMoney:GetSpanSize().y - 7 )
	self.buttonMoney2:SetSpanSize( self.assetValue:GetTextSizeX() + self.buttonMoney2:GetSizeX() + 5, self.assetValue:GetSpanSize().y - 7 )
end

----------------------------------------------------------------------------
--	Control Function
----------------------------------------------------------------------------
function	Warehouse_ItemComparer( ii, jj )
	return	Global_ItemComparer( ii, jj, Warehouse_GetItem )
end

function	Warehouse_CheckSort()
	local self = warehouse
	if self.sellCheck then
		-- WareHouse_SellOff_Init()
	end
	-- ♬ SORT 버튼을 눌렀을 때 사운드 추가 (XML에서 CLICKSOUND가 동작하지 않음)
	audioPostEvent_SystemUi(00,00)
	
	local isSorted	= self.checkSort:IsCheck()
	ToClient_SetSortedWarehouse( isSorted )
	
	FromClient_WarehouseUpdate()
end

function	Warehouse_OpenDelivery()
	local	self			= warehouse
	DeliveryInformation_OpenPanelFromWorldmap( self._currentWaypointKey )
end

function	HandleClickedWarehousePopMoney()
	local	self		= warehouse
	local	slotNo		= getMoneySlotNo()
	if	(not FGlobal_Warehouse_IsMoveItem() )	then
		return
	end
	
	HandleClickedWarehouseItemXXX( slotNo )
end

function	HandleClickedWarehouseItem( index )
	if	( Warehouse_DropHandler(index) )	then
		return
	end
	
	if	(not FGlobal_Warehouse_IsMoveItem() )	then
		return
	end
	
	if FGlobal_Selloff_CondCheck() then
		return
	end

	local	self			= warehouse
	local	slotNo			= self.slots[index].slotNo
	if (nil == self.itemMarketRclickFunc) and (nil == self.manufactureRclickFunc) then
		HandleClickedWarehouseItemXXX( slotNo )
	else
		local	warehouseWrapper	= self:getWarehouse()
		local	itemWrapper			= warehouseWrapper:getItem( slotNo )
		if nil ~= self.manufactureRclickFunc then
			self.manufactureRclickFunc(slotNo, itemWrapper, itemWrapper:get():getCount_s64())
		else
			warehouse_itemMarketRclickFunc( slotNo, itemWrapper, itemWrapper:get():getCount_s64() )
		end
	end
end
	
function	HandleClickedWarehouseItemXXX( slotNo )
	local	self			= warehouse
	local	warehouseWrapper= self:getWarehouse()
	local	itemWrapper		= warehouseWrapper:getItem( slotNo )
	if	(nil == itemWrapper)	then
		return
	end

	if Defines.s64_const.s64_0 == itemWrapper:get():getCount_s64() then
		return
	end
	
	FGlobal_PopupMoveItem_Init( nil, slotNo, CppEnums.MoveItemToType.Type_Warehouse, nil, true )
end

function	HandleClicked_WhItemMarketRegistItem_Open( byMaid )
	local self = warehouse
	if self.sellCheck then
		Proc_ShowMessage_Ack( "정리 해제 후 사용해주세요." )
		return
	end
	
	local isOpenWarehouse = true
	Inventory_SetFunctor( nil, nil, nil, nil )
	-- InventoryWindow_Close()

	FGlobal_ItemMarketRegistItem_Open( isOpenWarehouse, byMaid )
	-- 창고 슬롯을 업데이트 해야 한다.
	self.itemMarketFilterFunc = warehouse_itemMarketFilterFunc
	self.itemMarketRclickFunc = warehouse_itemMarketRclickFunc

	Panel_Window_Warehouse:SetPosX( 0 )

	self:update()
end

function	HandleClicked_ManufactureOpen()
	local self = warehouse
	if self.sellCheck then
		Proc_ShowMessage_Ack( "정리 해제 후 사용해주세요." )
		return
	end
	Manufacture_Show(nil, CppEnums.ItemWhereType.eWarehouse, true, nil, self._currentWaypointKey )
end

function Warehouse_CheckBoxSet( slotNo )
	warehouse_checkSellToSystem( slotNo )
	
	local self = warehouse
	local warehouseWrapper = self:getWarehouse()
	
	local isCheck = warehouseWrapper:isSellToSystem( slotNo )
	self.slots[slotNo-1].checkBox:SetCheck( isCheck )
	self:update()
end

function HandleClicked_SellCheck()
	local self = warehouse
	self.sellCheck = not self.sellCheck
	if self.sellCheck then
		self.BtnSellCheck:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_BTNTEXT_5" )) -- "정리해제" )
		WareHouse_SellOff_Init()
	else
		self.BtnSellCheck:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_BTNTEXT_4" )) -- "창고정리" )
		warehouse_clearSellToSystem()
	end
	
	self:update()
end

function	HandleClicked_SellOff()
	local	self				= warehouse
	if not self.sellCheck then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_SELLOFF_TEXT_1" )) -- "창고정리 버튼을 눌러 정리할 아이템을 선택하세요." )
		return
	end
	
	local	useStartSlot		= 1
	local	warehouseWrapper	= warehouse:getWarehouse()
	local	maxCount			= warehouseWrapper:getMaxCount()					-- 최대 뚫을 수 있는 슬롯 개수 -1(돈)
	local	useMaxCount			= warehouseWrapper:getUseMaxCount()
	local	count 				= 0
	--{
		local	slotNoList	= Array.new()
		slotNoList:fill( useStartSlot, maxCount - 1 )
	--}

	-- 아이템 정렬
	--{
		if self.checkSort:IsCheck() then
			local	sortList	= Array.new()
			sortList:fill( useStartSlot , useMaxCount - 1 )	-- 2 ~ 17
			sortList:quicksort( Warehouse_ItemComparer )
			
			for	ii = 1, useMaxCount - 1	do
				slotNoList[ii]	= sortList[ii]
			end
		end
	--}
	
	for ii = 0, useMaxCount-1	do
		local slotNo = slotNoList[1 + ii]
		if warehouseWrapper:isSellToSystem( slotNo ) then
			count = count + 1
		end
	end
	
	if 10 < count then
		Proc_ShowMessage_Ack( "최대 10개의 슬롯까지만 처분할 수 있습니다. " )
		return
	end
	
	if 0 < count then
		local minPrice = warehouse_getSellToSystemMin()
		local maxPrice = warehouse_getSellToSystemMax()
		
		local _title = PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_SELLOFF_TEXT_2" ) -- "창고 아이템 처분"
		local _content = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_WAREHOUSE_SELLOFF_TEXT_3", "minPrice", makeDotMoney(minPrice), "maxPrice", makeDotMoney(maxPrice), "count", count ) .. "\n<PAColor0xFFDB2B2B>(처분한 아이템은 재구매 및 복구가 불가능합니다.)<PAOldColor>"
		-- "선택된 아이템을 다음의 가격으로 처분합니다.\n<PAColor0xFFFFBC3A>" .. makeDotMoney(minPrice) .. "<PAOldColor> ~ <PAColor0xFFFFBC3A>" .. makeDotMoney(maxPrice) .. "<PAOldColor> 실버\n\n<PAColor0xFFFFBC3A>" .. count .. "<PAOldColor>개의 슬롯이 선택되었습니다. 계속 하시겠습니까?\n<PAColor0xFFDB2B2B>※창고 정리에는 창고 정리 아이템이 필요합니다.<PAOldColor>"
		local messageboxData = { title = _title, content = _content, functionYes = warehouse_sellToSystem, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox( messageboxData )
	else
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_SELLOFF_TEXT_4" )) -- "선택된 아이템이 없습니다." )
		return
	end
end

function	WareHouse_SellOff_Init()
	local	self				= warehouse
	if not self.sellCheck then
		return
	end
	
	local	useStartSlot		= 1
	local	warehouseWrapper	= self:getWarehouse()
	local	maxCount			= warehouseWrapper:getMaxCount()					-- 최대 뚫을 수 있는 슬롯 개수 -1(돈)
	local	useMaxCount			= warehouseWrapper:getUseMaxCount() 				-- 최대 (현재 뚫려있는) 슬롯 개수 -1(돈)
	--{
		local	slotNoList	= Array.new()
		slotNoList:fill( useStartSlot, maxCount - 1 )
	--}

	-- 아이템 정렬
	--{
		if self.checkSort:IsCheck() then
			local	sortList	= Array.new()
			sortList:fill( useStartSlot , useMaxCount - 1 )	-- 2 ~ 17
			sortList:quicksort( Warehouse_ItemComparer )
			
			for	ii = 1, useMaxCount - 1	do
				slotNoList[ii]	= sortList[ii]
			end
		end
	--}
	
	-- 처음에는 모두 체크
	for ii = 0, useMaxCount-1	do
		local slotNo		= slotNoList[1 + ii]
		local itemWrapper	= warehouseWrapper:getItem( slotNo )
		
		if not warehouse_itemMarketFilterFunc( nil, itemWrapper ) and (not itemWrapper:isCash()) then	-- 거래소에 올릴 수 있냐? 캐시 아이템이 아니냐?
			-- warehouse_checkSellToSystem( slotNo )
		end
	end
end

function	warehouse_itemMarketFilterFunc( slot, itemWrapper )
	if nil == itemWrapper then
		return true
	end

	local isAble = requestIsRegisterItemForItemMarket(itemWrapper:get():getKey());
	return (not isAble);
end

function	warehouse_itemMarketRclickFunc( slotNo, itemWrapper, s64_count )
	if(Defines.s64_const.s64_1 == s64_count) then
		FGlobal_ItemMarketRegistItemFromInventory(1, slotNo, CppEnums.ItemWhereType.eWarehouse )
	else
		-- 최대 갯수는 마스터 정보의 갯수
		local masterInfo	= getItemMarketMasterByItemEnchantKey( itemWrapper:get():getKey():get() )
		if masterInfo ~= nil then
			if masterInfo:getMaxRegisterCount() < s64_count then
				s64_count = masterInfo:getMaxRegisterCount()
			end
		end
		
		Panel_NumberPad_Show(true, s64_count, slotNo,  FGlobal_ItemMarketRegistItemFromInventory, nil, CppEnums.ItemWhereType.eWarehouse )
	end 
end

function 	HandleClicked_WhItemMarketItemSet_Close()
	
	FGlobal_WareHouseItemMarketRegistItem_Close()
end

function	HandleClicked_GuildWareHouseUpdate()
	warehouse_requestGuildWarehouseInfo()
end
----------------------------------------------------------------------------
-- Item Push Function
----------------------------------------------------------------------------
function	Warehouse_PushFromInventoryItem( s64_count, whereType, slotNo, fromActorKeyRaw )

	local	self			= warehouse
	self._targetActorKeyRaw	= fromActorKeyRaw
	
	Panel_NumberPad_Show( true, s64_count, slotNo, Warehouse_PushFromInventoryItemXXX, nil, whereType )
end

function	Warehouse_PushFromInventoryItemXXX( s64_count, slotNo, whereType )
	local	self		= warehouse
	-- _PA_LOG( "luadebug", "Warehouse_PushFromInventoryItemXXX 11 " );
		
	if( self:isNpc() )	then
		-- _PA_LOG( "luadebug", "Warehouse_PushFromInventoryItemXXX 11 " );
		warehouse_pushFromInventoryItemByNpc(whereType, slotNo, s64_count, self._targetActorKeyRaw)	
	elseif( self:isInstallation() )	then
		-- _PA_LOG( "luadebug", "Warehouse_PushFromInventoryItemXXX 22 " );
		warehouse_pushFromInventoryItemByInstallation( self._installationActorKeyRaw, whereType, slotNo, s64_count, self._targetActorKeyRaw )

	elseif( self:isGuildHouse() ) then	
	
		-- _PA_LOG( "luadebug", "Warehouse_PushFromInventoryItemXXX 33 " );
		warehouse_pushFromInventoryItemByGuildHouse(whereType, slotNo, s64_count, self._targetActorKeyRaw)	
	
	elseif ( self:isMaid() ) then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		local warehouseInMaid = checkMaid_WarehouseIn( true )
		
		if warehouseInMaid then
			warehouse_pushFromInventoryItemByMaid(whereType, slotNo, s64_count, self._targetActorKeyRaw)
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME")) -- "재사용 대기중입니다." )
		end
		-- FGlobal_MaidIcon_SetPos()
	end
end

----------------------------------------------------------------------------
-- Item Pop Function
----------------------------------------------------------------------------
function	Warehouse_PopToSomewhere( s64_count, slotNo, toActorKeyRaw )
	local	self			= warehouse
	self._targetActorKeyRaw	= toActorKeyRaw
	
	Panel_NumberPad_Show( true, s64_count, slotNo, Warehouse_PopToSomewhereXXX )
end

function	Warehouse_PopToSomewhereXXX( s64_count, slotNo )
	local	self		= warehouse
	
	if	Panel_Window_Inventory:GetShow()	then
		if( self:isNpc() ) then
			warehouse_popToInventoryByNpc(slotNo, s64_count, self._targetActorKeyRaw)
		elseif( self:isInstallation() )	then
			warehouse_popToInventoryByInstallation( self._installationActorKeyRaw, slotNo, s64_count, self._targetActorKeyRaw )
		elseif( self:isGuildHouse() ) then	
			warehouse_popToInventoryByGuildHouse(slotNo, s64_count, self._targetActorKeyRaw)	
		elseif ( self:isMaid() ) then
			local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
			if nil == regionInfo then
				return
			end
			local warehouseOutMaid = checkMaid_WarehouseOut( true )
			
			if warehouseOutMaid then
				warehouse_popToInventoryByMaid(slotNo, s64_count, self._targetActorKeyRaw)
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME")) -- "재사용 대기중입니다." )
			end
			
		end
	elseif	Panel_Window_Delivery_Request:GetShow()	then
		DeliveryRequest_PushPackingItem(slotNo, s64_count)
	end
end	
----------------------------------------------------------------------------
-- Control Event
----------------------------------------------------------------------------
function	Warehouse_Scroll( isUp )
	local	self				= warehouse
	local	useStartSlot		= 1	--inventorySlotNoUserStart()
	local	warehouseWrapper	= self:getWarehouse()
	if	( nil == warehouseWrapper )	then
		return
	end
	
	local	maxSize				= warehouseWrapper:getMaxCount() - useStartSlot
	self._startSlotIndex		= UIScroll.ScrollEvent( self._scroll, isUp, self.config.slotRows, maxSize, self._startSlotIndex, self.config.slotCols )
	
	--local	useCount			= warehouseWrapper:getUseMaxCount()
	--self._startSlotIndex		= UIScroll.ScrollEvent( self._scroll, isUp, self.config.slotRows, useCount, self._startSlotIndex, self.config.slotCols )
	
	self:update()
end

----------------------------------------------------------------------------
-- Drag 관련 함수
----------------------------------------------------------------------------
function	Warehouse_SlotDrag( index )
	local	self			= warehouse
	local	slotNo			= self.slots[index].slotNo
	local	warehouseWrapper= self:getWarehouse()
	local	itemWrapper		= warehouseWrapper:getItem( slotNo )
	if	(nil == itemWrapper)	then
		return
	end
	
	if Defines.s64_const.s64_0 == itemWrapper:get():getCount_s64() then
		return
	end
	
	if FGlobal_Selloff_CondCheck() then
		return
	end

	DragManager:setDragInfo( Panel_Window_Warehouse, nil, slotNo, "Icon/" .. itemWrapper:getStaticStatus():getIconPath(), Warehouse_GroundClick, nil )
end

function	Warehouse_DropHandler( index )
	local	self	= warehouse
	
	if FGlobal_Selloff_CondCheck() then
		local slotNo = self.slots[index].slotNo
		Warehouse_CheckBoxSet( slotNo )
	end
	
	if nil == DragManager.dragStartPanel then
		return(false)
	end
	
	return( DragManager:itemDragMove( CppEnums.MoveItemToType.Type_Warehouse, nil ) )
end

function	Warehouse_GroundClick( whereType, slotNo ) 
	if	(false == Panel_Window_Warehouse:GetShow()) then
		return
	end

	local	self			= warehouse
	local	warehouseWrapper= self:getWarehouse()
	local	itemWrapper		= warehouseWrapper:getItem( slotNo )
	if	(nil == itemWrapper)	then
		return
	end
	
	s64_count	= itemWrapper:get():getCount_s64()
	itemName	= itemWrapper:getStaticStatus():getName()
	if( Defines.s64_const.s64_1 == s64_count ) then
		Warehouse_GroundClick_Message( Defines.s64_const.s64_1, slotNo)
	else
		Panel_NumberPad_Show(  true, s64_count, slotNo, Warehouse_GroundClick_Message) 
	end

end

function 	Warehouse_GroundClick_Message(s64_count, slotNo )
	local	self			= warehouse
	self._deleteSlotNo		= slotNo
	self._s64_deleteCount	= s64_count

	local luaDeleteItemMsg	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETEITEM_MSG", "itemName", itemName, "itemCount", tostring(s64_count) )
	local luaDelete			= PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETE")
	
	local messageContent	= luaDeleteItemMsg
	local messageboxData	= { title = luaDelete, content = messageContent, functionYes = Warehouse_Delete_Yes, functionNo = Warehouse_Delete_No, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox( messageboxData )
end


function	Warehouse_Delete_Yes()
	local	self			= warehouse
	if	(nil == self._deleteSlotNo)	then
		return
	end
	
	local	warehouseWrapper= self:getWarehouse()
	local	itemWrapper		= warehouseWrapper:getItem( self._deleteSlotNo )
	if	(nil == itemWrapper)	then
		return
	end
	
	if	( itemWrapper:isCash() )	then
		PaymentPassword( Warehouse_Delete_YesXXX )
		return
	end
	
	Warehouse_Delete_YesXXX()
end

function	Warehouse_Delete_YesXXX()
	local	self	= warehouse
	if( self:isNpc() )	then
		warehouse_deleteItemByNpc(self._deleteSlotNo, self._s64_deleteCount)
	elseif( self:isInstallation() )	then
		warehouse_deleteItemByInstallation( self._installationActorKeyRaw, self._deleteSlotNo, self._s64_deleteCount )
	end
	
	self._deleteSlotNo		= nil
	self._s64_deleteCount	= Defines.s64_const.s64_0
	DragManager:clearInfo()
end

function	Warehouse_Delete_No()
	local	self			= warehouse
	self._deleteSlotNo		= nil
	self._s64_deleteCount	= Defines.s64_const.s64_0
end

----------------------------------------------------------------------------
-- 툴팁
----------------------------------------------------------------------------
function	Warehouse_IconOver( index )
	local	self	= warehouse
	local	slot	= self.slots[index]
	
	-- slot.icon:EraseAllEffect()
	if self.slotNilEffect[index] then
		slot.icon:EraseEffect(self.slotNilEffect[index])
		self.slotNilEffect[index] = slot.icon:AddEffect( "UI_Inventory_EmptySlot", false, -1.5, -1.5 )
	else
		self.slotNilEffect[index] = slot.icon:AddEffect( "UI_Inventory_EmptySlot", false, -1.5, -1.5 )
	end
	
	self._tooltipSlotNo	= slot.slotNo

	Panel_Tooltip_Item_Show_GeneralNormal(index, "WareHouse", true)
end

function	Warehouse_IconOut( index )
	local	self	= warehouse
	local	slot	= self.slots[index]
	
	self._tooltipSlotNo		= nil
	
	Panel_Tooltip_Item_Show_GeneralNormal( index, "WareHouse", false)
end

function	Warehouse_GetToopTipItem()
	local	self				= warehouse
	local	warehouseWrapper	= self:getWarehouse()
	if	( nil == warehouseWrapper )	then
		return(nil)
	end

	if	( nil == self._tooltipSlotNo )	then
		return(nil)
	end
	
	return( warehouseWrapper:getItem( self._tooltipSlotNo ) )
end

function	Warehouse_GetItem( slotNo )
	local	self				= warehouse
	local	warehouseWrapper	= self:getWarehouse()
	if	( nil == warehouseWrapper )	then
		return(nil)
	end

	return( warehouseWrapper:getItem( slotNo ) )
end
------------------------------------------------------------
-- 					실버 버튼 막는 함수
------------------------------------------------------------
function Warehouse_SetIgnoreMoneyButton( setIgnore )
	local	self	= warehouse
	if ( setIgnore == true ) then
		self.buttonMoney:SetIgnore( true )
		--self.buttonMoney:SetColor( UI_color.C_FFD20000 )
		--self.buttonMoney:SetFontColor( UI_color.C_FFF26A6A )
			-- _PA_LOG("LUA", "여기가 버튼 막는 곳")
	else
		self.buttonMoney:SetIgnore( false )
		--self.buttonMoney:SetColor( UI_color.C_FFFFFFFF )
		--self.buttonMoney:SetFontColor( UI_color.C_FFC4BEBE )
			-- _PA_LOG("LUA", "버튼 다시 풀어주기")
	end
end

----------------------------------------------------------------------------
--	Window Open / Close
--	월드맵에서 접근시 < 확인 >
--	설치물 or Npc를 통해 접근시에는 <확인, 이동>
----------------------------------------------------------------------------
function	FromClient_WarehouseOpenByInstallation( actorKeyRaw, waypointKey )
	local	self					= warehouse
	self._installationActorKeyRaw	= actorKeyRaw
	
	Warehouse_OpenPanel( waypointKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Installation )
	Warehouse_SetIgnoreMoneyButton( false )

	Warehouse_OpenWithInventory()
end

function	Warehouse_OpenPanelFromDialog()
	local	self	= warehouse
	self.sellCheck	= false
	self.BtnSellCheck:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_BTNTEXT_4" ) )
	warehouse_clearSellToSystem()
	
	Warehouse_OpenPanel( getCurrentWaypointKey(), CppEnums.WarehoouseFromType.eWarehoouseFromType_Npc )
	Warehouse_SetIgnoreMoneyButton( false )

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()

	if not ToClient_WorldMapIsShow() then
		Panel_Window_Warehouse:SetVerticalMiddle()
		Panel_Window_Warehouse:SetHorizonCenter()
		if screenSizeX <= 1400 then
			Panel_Window_Warehouse:SetSpanSize((screenSizeX/2) - (Panel_Window_Warehouse:GetPosX()/2) - 490 ,-30)
		else
			Panel_Window_Warehouse:SetSpanSize((screenSizeX/2) - (Panel_Window_Warehouse:GetPosX()/2) - 400,-30)
		end
	end
	
	Warehouse_OpenWithInventory()
	
	if Panel_Window_ItemMarket_RegistItem:GetShow() then
		FGlobal_ItemMarketRegistItem_Close()
	end
end

function	Warehouse_OpenPanelFromDialogWithoutInventory( waypointKey, fromType )
	local	self					= warehouse
	Warehouse_OpenPanel( waypointKey, fromType )
	Warehouse_SetIgnoreMoneyButton( true )

	if( ToClient_WorldMapIsShow() ) then
		Panel_Window_Warehouse:SetVerticalMiddle()
		Panel_Window_Warehouse:SetHorizonCenter()
		Panel_Window_Warehouse:SetSpanSize(100,0)
	end
end

function	Warehouse_OpenPanelFromWorldmap( waypointKey, fromType )
	local	self	=	warehouse

	if ToClient_WorldMapIsShow() then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_Window_Warehouse, true )		

		if isWorldMapGrandOpen() then
			Panel_Window_Warehouse:SetHorizonRight()
			Panel_Window_Warehouse:SetVerticalMiddle()
		else
			Panel_Window_Warehouse:SetHorizonRight()
			Panel_Window_Warehouse:SetVerticalBottom()
			Panel_Window_Warehouse:SetPosY(Panel_Window_Warehouse:GetPosY()-50)
		end
	end
	
	Warehouse_OpenPanel( waypointKey, fromType )
	Warehouse_SetIgnoreMoneyButton( true )

	--창고 관리 눌렀을떄!
	if( not FGlobal_Warehouse_IsMoveItem() )	then
		DeliveryRequestWindow_Close()
		DeliveryInformationWindow_Close()
	end
end

function	Warehouse_OpenPanelFromMaid()
	local self = warehouse
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	if nil == regionInfo then
		return
	end
	local regionInfoWrapper = getRegionInfoWrapper( regionInfo:getAffiliatedTownRegionKey() )		-- 내가 있는 곳의 소속 영지 래퍼
	local regionKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()					-- 소속 영지의 웨이포인트키
	
	Warehouse_OpenPanel( regionKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Maid )
	Warehouse_SetIgnoreMoneyButton( true )

	Warehouse_OpenWithInventory()
end

local btnMarketRegistSizeX = warehouse.BtnMarketRegist:GetSizeX()
local btnSellOffPosY = warehouse.BtnSellOff:GetSpanSize().y
local btnSellCheckPosY = warehouse.BtnSellCheck:GetSpanSize().y
function	Warehouse_OpenPanel( waypointKey, fromType )
	local	self	= warehouse
	self._currentWaypointKey	= waypointKey
	self._fromType				= fromType
	self._currentRegionName		= getRegionNameByWaypointKey( self._currentWaypointKey )
	self.staticTitle:SetText( self._currentRegionName )
	
	local isSorted = ToClient_IsSortedWarehouse()
	self.checkSort:SetCheck( isSorted )
	
	self._buttonDelivery:SetShow( false )
	if( self:isWorldMapNode() )	then			-- 월드맵
		local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint( waypointKey )
		if nil ~= regionInfoWrapper then
			if regionInfoWrapper:get():hasDeliveryNpc() then		-- 해당 리전에 수송 기능 NPC가 있냐?
				self._buttonDelivery:SetShow( true )
			end
		end		
	end

	clearDeliveryPack()

	-- NPC 를 통해서 접근한 창고에서만 가공이 가능하다!!
	self.BtnManufacture:SetShow(false)
	if CppEnums.WarehoouseFromType.eWarehoouseFromType_Npc == self._fromType or CppEnums.WarehoouseFromType.eWarehoouseFromType_Manufacture == self._fromType then
		if ToClient_isPossibleManufactureAtWareHouse() then
			self.BtnManufacture:SetShow(true)
		end
	end
	
	-- 거래소를 열 수 있는 창고인가?
	local myRegionInfo	= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local hasItemMarket = myRegionInfo:get():hasItemMarketNpc()
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	if hasItemMarket and nil ~= dialog_getTalker() and dialog_isTalking() and not self:isGuildHouse() then
		self.BtnMarketRegist:SetShow( true )
	else
		self.BtnMarketRegist:SetShow( false )
	end
	
	-- self:update()
	
	if	FGlobal_Warehouse_IsMoveItem()	then
		self.buttonMoney:SetIgnore(false)
	else
		self.buttonMoney:SetIgnore(true)
	end

	-- 일반 창고에서는 업데이트 버튼을 노출하지 않는다.
	warehouse.BtnGuildUpdate	:SetShow( false )

	WareHouse_PanelSize_Change( warehouse:isNpc() )
	-- NPC를 통해서만 창고정리 버튼이 노출돼야 한다!!
	
	self.BtnSellOff:SetShow( isOpenSellOff )
	self.BtnSellCheck:SetShow( isOpenSellOff )
	if CppEnums.WarehoouseFromType.eWarehoouseFromType_Npc == self._fromType and isOpenSellOff then
		if self.BtnMarketRegist:GetShow() then
			if self.BtnManufacture:GetShow() then
				self.BtnMarketRegist:SetSize( btnMarketRegistSizeX - 30, self.BtnMarketRegist:GetSizeY() )
				self.BtnManufacture:SetSize( btnMarketRegistSizeX - 30, self.BtnMarketRegist:GetSizeY() )
				self.BtnSellOff:SetSize( btnMarketRegistSizeX - 30, self.BtnMarketRegist:GetSizeY() )
				self.BtnSellCheck:SetSize( btnMarketRegistSizeX - 30, self.BtnMarketRegist:GetSizeY() )
				self.BtnMarketRegist:SetSpanSize( 25 + self.BtnManufacture:GetSizeX() + 5, btnMarketRegSpanSizeY + self.addSizeY )
			else
				self.BtnMarketRegist:SetSize( btnMarketRegistSizeX, self.BtnMarketRegist:GetSizeY() )
				self.BtnManufacture:SetSize( btnMarketRegistSizeX, self.BtnMarketRegist:GetSizeY() )
				self.BtnSellOff:SetSize( btnMarketRegistSizeX, self.BtnMarketRegist:GetSizeY() )
				self.BtnSellCheck:SetSize( btnMarketRegistSizeX, self.BtnMarketRegist:GetSizeY() )
				self.BtnMarketRegist:SetSpanSize( 25, btnMarketRegSpanSizeY + self.addSizeY )
			end
			
			self.BtnSellOff:SetSpanSize( self.BtnMarketRegist:GetSpanSize().x + self.BtnMarketRegist:GetSizeX() + 5, btnSellOffPosY + self.addSizeY )
			self.BtnSellCheck:SetSpanSize( self.BtnSellOff:GetSpanSize().x + self.BtnSellOff:GetSizeX() + 5, btnSellOffPosY + self.addSizeY )
		elseif self.BtnManufacture:GetShow() then
			self.BtnSellOff:SetSpanSize( self.BtnManufacture:GetSpanSize().x + self.BtnManufacture:GetSizeX() + 5, btnSellOffPosY + self.addSizeY )
			self.BtnSellCheck:SetSpanSize( self.BtnSellOff:GetSpanSize().x + self.BtnSellOff:GetSizeX() + 5, btnSellOffPosY + self.addSizeY )
		else
			self.BtnSellOff:SetSpanSize( 25, 60 + self.addSizeY )
			self.BtnSellCheck:SetSpanSize( self.BtnSellOff:GetSpanSize().x + self.BtnSellOff:GetSizeX() + 5, btnSellOffPosY + self.addSizeY )
		end
	else
		self.BtnSellOff:SetShow( false )
		self.BtnSellCheck:SetShow( false )
	end
	
	self.BtnManufacture		:SetTextSpan( (self.BtnManufacture:GetSizeX()+26)/2 - self.BtnManufacture:GetTextSizeX()/2, self.BtnManufacture:GetSizeY()/2 - self.BtnManufacture:GetTextSizeY()/2 )
	self.BtnMarketRegist	:SetTextSpan( (self.BtnMarketRegist:GetSizeX()+26)/2 - self.BtnMarketRegist:GetTextSizeX()/2, self.BtnMarketRegist:GetSizeY()/2 - self.BtnMarketRegist:GetTextSizeY()/2 )
	self.BtnSellOff			:SetTextSpan( (self.BtnSellOff:GetSizeX()+26)/2 - self.BtnSellOff:GetTextSizeX()/2, self.BtnSellOff:GetSizeY()/2 - self.BtnSellOff:GetTextSizeY()/2 )
	self.BtnSellCheck		:SetTextSpan( (self.BtnSellCheck:GetSizeX()+26)/2 - self.BtnSellCheck:GetTextSizeX()/2, self.BtnSellCheck:GetSizeY()/2 - self.BtnSellCheck:GetTextSizeY()/2 )
	
	-- if	not Panel_Window_Warehouse:GetShow()	then
		Panel_Window_Warehouse:ChangeSpecialTextureInfoName("")
		Panel_Window_Warehouse:SetAlphaExtraChild(1)
		Panel_Window_Warehouse:SetShow( true, true )
	-- end
	self._startSlotIndex = 0
	self._scroll:SetControlTop()
	self._scroll:SetControlPos( 0 )
	warehouse_requestInfo(self._currentWaypointKey)
	
	if CppEnums.WarehoouseFromType.eWarehoouseFromType_Maid == fromType then
		Panel_Window_Warehouse:SetPosX( getScreenSizeX() - Panel_Window_Inventory:GetSizeX() - Panel_Window_Warehouse:GetSizeX() )
		Panel_Window_Warehouse:SetPosY( getScreenSizeY()/2 - Panel_Window_Warehouse:GetSizeY()/2 )
	elseif CppEnums.WarehoouseFromType.eWarehoouseFromType_Manufacture == fromType then
		Panel_Window_Warehouse:SetPosX( Panel_Manufacture:GetPosX() + Panel_Manufacture:GetSizeX() - 20 )
		Panel_Window_Warehouse:SetPosY( Panel_Manufacture:GetPosY() )
	end
	
	self:update()
end

function	Warehouse_OpenWithInventory()
	local self	= warehouse
	Inventory_SetFunctor( nil, FGlobal_PopupMoveItem_InitByInventory, Warehouse_Close, nil )
	InventoryWindow_Show()
	self._startSlotIndex = 0
	self._scroll:SetControlTop()
	ServantInventory_OpenAll()
end

function	Warehouse_Close()
	local	self	= warehouse
	self._fromType	= CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap
	
	if Panel_Window_Warehouse:GetShow() then
		if Panel_Window_Delivery_Information:GetShow() then
			DeliveryInformationWindow_Close()
		end
		if Panel_Window_Delivery_Request:GetShow() then
			DeliveryRequestWindow_Close()
		end
		if Panel_Window_Inventory:GetShow() then
			InventoryWindow_Close()
		end
	end

	if nil ~= self.itemMarketFilterFunc then
		self.itemMarketFilterFunc = nil
		self.itemMarketRclickFunc = nil
	end
	if nil ~= self.manufactureRclickFunc then
		self.manufactureFilterFunc = nil
		self.manufactureRclickFunc = nil
	end
	
	if( ToClient_WorldMapIsShow() ) then
		WorldMapPopupManager:pop()
	else
		Panel_Window_Warehouse:SetShow( false, false )
	end
	Panel_Window_Warehouse:ChangeSpecialTextureInfoName("")
	ServantInventory_Close()
	
	-- 메이드 닫는 이벤트 핸들러
	if ToClient_CheckExistSummonMaid() then
		ToClient_CallHandlerMaid("_maidLogOut")
	end
end

function	Warehouse_GetWarehouseWarpper()
	local self = warehouse
	return self:getWarehouse()
end

function	Warehouse_updateSlotData()
	FromClient_WarehouseUpdate()
end

-- bool filterFunc( slotNo, itemWrapper )
-- void rClickFunc( slotNo, itemWrapper, stackCount )
function Warehouse_SetFunctor( filterFunc, rClickFunc )
	local self = warehouse
	if (nil ~= filterFunc) and ('function' ~= type(filterFunc)) then
		filterFunc = nil
		UI.ASSERT( false, 'Param 1 must be Function type' )
	end
	
	if (nil ~= rClickFunc) and ('function' ~= type(rClickFunc)) then
		rClickFunc = nil
		UI.ASSERT( false, 'Param 2 must be Function type' )
	end
	
	warehouse.manufactureFilterFunc = filterFunc
	warehouse.manufactureRclickFunc = rClickFunc
end

function FGlobal_Warehouse_ResetFilter()
	local	self	= warehouse
	
	if nil ~= self.itemMarketFilterFunc then
		self.itemMarketFilterFunc = nil
		self.itemMarketRclickFunc = nil
	end
	self:update()
end

function Warehouse_OpenPanelFromManufacture()
	Warehouse_OpenPanel( getCurrentWaypointKey(), CppEnums.WarehoouseFromType.eWarehoouseFromType_Manufacture )
end

function FGlobal_Selloff_CondCheck()
	local	sellOffBtnOn	= ( PAGetString( Defines.StringSheet_GAME, "LUA_WAREHOUSE_BTNTEXT_5" ) == warehouse.BtnSellCheck:GetText() ) and warehouse.BtnSellCheck:GetShow()
	return warehouse:isNpc() and sellOffBtnOn
end

----------------------------------------------------------------------------
-- 초기화
----------------------------------------------------------------------------
warehouse:init()
warehouse:registEventHandler()
warehouse:registMessageHandler()

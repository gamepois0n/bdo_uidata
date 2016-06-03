Panel_Window_Delivery_Information:ActiveMouseEventEffect(true)
Panel_Window_Delivery_Information:setMaskingChild(true)
Panel_Window_Delivery_Information:setGlassBackground(true)

Panel_Window_Delivery_Information:RegisterShowEventFunc( true,	'DeliveryInformationShowAni()' )
Panel_Window_Delivery_Information:RegisterShowEventFunc( false,	'DeliveryInformationHideAni()' )

local UI_color 		= Defines.Color
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

function	DeliveryInformationShowAni()
	Panel_Window_Delivery_Information:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_Window_Delivery_Information, 0.05, 0.15 )

	local aniInfo1 = Panel_Window_Delivery_Information:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.0)
	aniInfo1.AxisX = Panel_Window_Delivery_Information:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_Delivery_Information:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_Delivery_Information:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_Delivery_Information:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_Delivery_Information:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function	DeliveryInformationHideAni()
	-- Hide 시에 Special Texture 를 리셋해준다!
	Panel_Window_Delivery_Information:ChangeSpecialTextureInfoName("")

	Panel_Window_Delivery_Information:SetAlpha( 1 )
	UIAni.AlphaAnimation( 0, Panel_Window_Delivery_Information, 0.0, 0.1 )
end

local	deliveryInformation	= {
	slotConfig	=
	{
		-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon			= true,
		createBorder		= true,
		createCount			= true,
		createEnchant		= true,
		createCash			= true,
		createEnduranceIcon = true,
	},
	
	config	=
	{
		-- 이 값들은 추후에 메시지로 빼어내어 세팅해야 할까?
		slotCount	= 7,
		slotStartX	= 10,
		slotStartY	= 70,
		slotGapY	= 70,
		
		slotIconStartX			= 5,
		slotIconStartY			= 8,
		slotCarriageTypeStartX	= 88,
		slotCarriageTypeStartY	= 8,
		slotDepartureStartX		= 65,
		slotDepartureStartY		= 31,
		slotDestinationStartX	= 215,
		slotDestinationStartY	= 31,
		slotArrowStartX			= 180,
		slotArrowStartY			= 34,
		slotButtonStartX		= 320,
		slotButtonStartY		= 5
	},
	
	const	=
	{
		deliveryProgressTypeRequest	= 0,
		deliveryProgressTypeIng		= 1,
		deliveryProgressTypeComplete= 2,
	},
	
	panel_Background		= UI.getChildControl( Panel_Window_Delivery_Information,	"Static_Bakcground"),
	button_Close			= UI.getChildControl( Panel_Window_Delivery_Information,	"Button_Win_Close"),
	_buttonQuestion			= UI.getChildControl( Panel_Window_Delivery_Information,	"Button_Question"),						-- 물음표 버튼
	button_Request			= UI.getChildControl( Panel_Window_Delivery_Information,	"Button_Send" ),
	button_Information		= UI.getChildControl( Panel_Window_Delivery_Information,	"Button_Cancel_Recieve" ),
	button_ReceiveAll		= UI.getChildControl( Panel_Window_Delivery_Information,	"Button_ReceiveAll" ),

	button_Refresh			= UI.getChildControl( Panel_Window_Delivery_Information,	"Button_Refresh" ),

	--	관리
	check_Cancel			= UI.getChildControl( Panel_Window_Delivery_Information,	"CheckButton_Cancel" ),					-- 취소 체크박스 text
	check_Recieve			= UI.getChildControl( Panel_Window_Delivery_Information,	"CheckButton_Recieve" ),				-- 수령 체크박스 text
	
	empty_List				= UI.getChildControl( Panel_Window_Delivery_Information,	"StaticText_Empty_List"	),				-- 리스트가 비어있을 때, 알람 문구
	scroll					= UI.getChildControl( Panel_Window_Delivery_Information,	"Scroll_1"				),
	
	slots					= Array.new(),
	
	startSlotNo				= 0,	-- scroll 관련
	currentWaypointKey		= 0		-- 운송창을 띄운 마을 키
}



--이벤트 등록 < client -> lua >
function	deliveryInformation:registMessageHandler()
	registerEvent("FromClient_MoveDeliveryItem", "DeliveryInformation_UpdateSlotData")
end

-- 버튼 이벤트 등록
function	deliveryInformation:registEventHandler()
	Panel_Window_Delivery_Information:addInputEvent(	"Mouse_UpScroll",	"DeliveryInformation_ScrollEvent( true )"	)
	Panel_Window_Delivery_Information:addInputEvent(	"Mouse_DownScroll",	"DeliveryInformation_ScrollEvent( false )"	)
	self.panel_Background:addInputEvent(				"Mouse_UpScroll",	"DeliveryInformation_ScrollEvent( true )"	)
	self.panel_Background:addInputEvent(				"Mouse_DownScroll",	"DeliveryInformation_ScrollEvent( false )"	)
	self.button_Request:addInputEvent(					"Mouse_LUp",		"DeliveryRequestWindow_Open()"				)
	self.button_Close:addInputEvent(					"Mouse_LUp",		"DeliveryInformationWindow_Close()"			)
	self._buttonQuestion:addInputEvent(					"Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"DeliveryInformation\" )" )																-- 물음표 좌클릭
	self.button_Refresh:addInputEvent(					"Mouse_LUp",		"DeliveryInformation_Refresh()")
	self.button_ReceiveAll:addInputEvent(				"Mouse_LUp",		"Delivery_Receive_All()")
	self._buttonQuestion:addInputEvent(					"Mouse_On",			"HelpMessageQuestion_Show( \"DeliveryInformation\", \"true\")" )			-- 물음표 마우스오버
	self._buttonQuestion:addInputEvent(					"Mouse_Out",		"HelpMessageQuestion_Show( \"DeliveryInformation\", \"false\")" )			-- 물음표 마우스아웃
	self.check_Cancel:addInputEvent(					"Mouse_LUp",		"DeliveryInformation_UpdateSlotData()" )
	self.check_Recieve:addInputEvent(					"Mouse_LUp",		"DeliveryInformation_UpdateSlotData()" )
	self.check_Recieve:SetAutoDisableTime( 4.0 )
	
	UIScroll.InputEvent( self.scroll, "DeliveryInformation_ScrollEvent" )
end

-- 초기화 함수
function	deliveryInformation:init()
	for ii = 0, self.config.slotCount-1	do
		local	slot= {}
		slot.slotNo	= ii
		slot.panel	= Panel_Window_Delivery_Information
		
		-- Slot
		slot.base			= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_Information, "Static_Slot",				Panel_Window_Delivery_Information,	"Delivery_Slot_"				.. ii )
		slot.carriageType	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_Information, "StaticText_CarriageType",	slot.base,							"Delivery_Slot_CarriageType_"	.. ii )
		slot.departure		= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_Information, "StaticText_Departure",		slot.base,							"Delivery_Slot_Departure_"		.. ii )
		slot.destination	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_Information, "StaticText_Destination",		slot.base,							"Delivery_Slot_Destination_"	.. ii )
		slot.static_Arrow	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_Information, "Static_Arrow",				slot.base,							"Delivery_Slot_Arrow_"			.. ii )
		slot.button_Cancel	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_Information, "Button_Cancel",				slot.base,							"Delivery_Slot_Cancel_"			.. ii )
		slot.button_Receive	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_Information, "Button_Receive",				slot.base,							"Delivery_Slot_Receive_"		.. ii )
		
		-- Icon
		slot.icon = {}
		SlotItem.new( slot.icon, 'Delivery_Slot_Icon_' .. slot.slotNo, slot.slotNo, slot.base, self.slotConfig )
		slot.icon:createChild()
		
		-- 위치
		--{
			slot.base:SetPosX( self.config.slotStartX )
			slot.base:SetPosY( self.config.slotStartY + (self.config.slotGapY * slot.slotNo) )
		
			slot.icon.icon:SetPosX( self.config.slotIconStartX )
			slot.icon.icon:SetPosY( self.config.slotIconStartY )
						
			slot.carriageType:SetPosX( self.config.slotCarriageTypeStartX )
			slot.carriageType:SetPosY( self.config.slotCarriageTypeStartY )
			
			slot.departure:SetPosX( self.config.slotDepartureStartX )
			slot.departure:SetPosY( self.config.slotDepartureStartY )
			
			slot.destination:SetPosX( self.config.slotDestinationStartX )
			slot.destination:SetPosY( self.config.slotDestinationStartY )
			
			slot.static_Arrow:SetPosX( self.config.slotArrowStartX )
			slot.static_Arrow:SetPosY( self.config.slotArrowStartY )
			
			slot.button_Cancel:SetPosX( self.config.slotButtonStartX )
			slot.button_Cancel:SetPosY( self.config.slotButtonStartY )
			slot.button_Receive:SetPosX( self.config.slotButtonStartX)
			slot.button_Receive:SetPosY( self.config.slotButtonStartY)
		--}
		
		self.check_Cancel:SetCheck(true)
		self.check_Recieve:SetCheck(true)
		
		--slot.base:SetShow(true)
		--slot.icon.icon:SetEnable(true)
		--slot.icon.icon:SetShow(true)
		--slot.carriageType:SetShow(true)
		--slot.departure:SetShow(true)
		--slot.destination:SetShow(true)
		--slot.static_Arrow:SetShow(true)
		--slot.button_Cancel:SetShow(true)
		--slot.button_Receive:SetShow(true)
		
		-- 이벤트
		--{
			slot.base:addInputEvent(			"Mouse_UpScroll",	"DeliveryInformation_ScrollEvent( true )"	)
			slot.base:addInputEvent(			"Mouse_DownScroll",	"DeliveryInformation_ScrollEvent( false )"	)
			slot.icon.icon:addInputEvent(		"Mouse_UpScroll",	"DeliveryInformation_ScrollEvent( true )"	)
			slot.icon.icon:addInputEvent(		"Mouse_DownScroll",	"DeliveryInformation_ScrollEvent( false )"	)
			slot.icon.icon:addInputEvent(		"Mouse_On",			"Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryInformation\",true)" );
			slot.icon.icon:addInputEvent(		"Mouse_Out",		"Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryInformation\",false)" );
			
			slot.button_Cancel:addInputEvent(	'Mouse_LUp',		'Delivery_Cancel(' .. ii .. ')' )
			slot.button_Cancel:addInputEvent(	"Mouse_UpScroll",	"DeliveryInformation_ScrollEvent( true )"	)
			slot.button_Cancel:addInputEvent(	"Mouse_DownScroll",	"DeliveryInformation_ScrollEvent( false )"	)
			
			slot.button_Receive:addInputEvent(	'Mouse_LUp',		'Delivery_Receive(' .. ii .. ')' )
			slot.button_Receive:addInputEvent(	"Mouse_UpScroll",	"DeliveryInformation_ScrollEvent( true )"	)
			slot.button_Receive:addInputEvent(	"Mouse_DownScroll",	"DeliveryInformation_ScrollEvent( false )"	)
		--}
		
		Panel_Tooltip_Item_SetPosition( ii, slot.icon, "DeliveryInformation")

		slot.deliveryIndex	= 0
		self.slots[ii] = slot
	end

	if (7 == getGameServiceType() or 8 == getGameServiceType()) then
		self.check_Recieve:SetSpanSize( 100, 35 )
		self.check_Cancel:SetSpanSize( 100, 53 )
	else
		self.check_Recieve:SetSpanSize( 60, 35 )
		self.check_Cancel:SetSpanSize( 60, 53 )
	end
end

function	deliveryInformation:updateSlot()
	for ii = 0, self.config.slotCount-1	do
		local	slot		= self.slots[ii]
		slot.base:SetShow(false)
	end
	
	local	deliveryList= delivery_list( DeliveryInformation_WaypointKey() )
	if	nil == deliveryList	then
		self.empty_List:SetShow(true)
		return
	else
		self.empty_List:SetShow(false)
	end
	
	local	deliveryCount = deliveryList:size()
	if	0 == deliveryCount	then
		self.empty_List:SetShow(true)
		return
	else
		self.empty_List:SetShow(false)
	end
	
	local	showCount	= 0
	if	self.check_Cancel:IsCheck()	then
		showCount	= showCount + deliveryList:sizeByProgress(self.const.deliveryProgressTypeRequest)
	end
	
	if	self.check_Recieve:IsCheck()	then
		showCount	= showCount + deliveryList:sizeByProgress(self.const.deliveryProgressTypeComplete)
	end
	
	if	7 >= deliveryCount then
		self.startSlotNo = 0
	end
		
	local	showSlot		= 0
	for ii = self.startSlotNo, deliveryCount-1	do
		if	(showSlot < self.config.slotCount) and (showSlot<showCount)	then
			local	deliveryInfo= deliveryList:atPointer(ii)
			if	nil ~= deliveryInfo	then
				if	( self.check_Cancel:IsCheck() and (self.const.deliveryProgressTypeRequest == deliveryInfo:getProgressType()) ) or ( self.check_Recieve:IsCheck() and (self.const.deliveryProgressTypeComplete == deliveryInfo:getProgressType()) )	then
					local	itemWrapper	= deliveryInfo:getItemWrapper()
					if	nil ~= itemWrapper	then
						local	slot	= self.slots[showSlot]
						slot.icon:setItem(itemWrapper)
					
						slot.departure:SetText( deliveryInfo:getFromRegionName() )
						slot.destination:SetText( deliveryInfo:getToRegionName() )
						
						if	1 == deliveryInfo:getCarriageType()	then
							slot.carriageType:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_carriage") )
						elseif 2 == deliveryInfo:getCarriageType()	then
							slot.carriageType:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_Transport") )
						elseif 3 == deliveryInfo:getCarriageType()	then
							slot.carriageType:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_TradeShip") )
						else
							slot.carriageType:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_DeliveryInformation_carriageType_carriage") )
						end
	
						if	0 == deliveryInfo:getProgressType()	then
							slot.button_Receive:SetShow(false)
							slot.button_Cancel:SetShow(true)
						else
							slot.button_Cancel:SetShow(false)
							slot.button_Receive:SetShow(true)
						end
						slot.deliveryIndex	= ii
						slot.base:SetShow(true)
						showSlot= showSlot + 1
					end
				end
			end
		end
	end
	UIScroll.SetButtonSize( self.scroll, self.config.slotCount, deliveryCount )		-- 스크롤 컨트롤들 , UI에서 보여주는 최대개수 , 실제 리스트의 수
	if self.startSlotNo + 7 == deliveryCount then
		self.scroll:SetControlPos( 1 )
	end
end

---------------------------------------------------------------------------------------------------------------------------
function	DeliveryInformation_WaypointKey()
	local	self	= deliveryInformation
	return( self.currentWaypointKey )
end

function	DeliveryInformation_SlotIndex( slotNo )
	local	self	= deliveryInformation
	return(self.slots[slotNo].deliveryIndex)	
end

---------------------------------------------------------------------------------------------------------------------------
function	DeliveryInformation_ScrollEvent( isScrollUp )
	local	self		= deliveryInformation
	local	deliveryList= delivery_list( DeliveryInformation_WaypointKey() )
	
	if	nil == deliveryList	then
		return
	end
	
	self.scroll:SetShow( false )
	local	deliveryCount = deliveryList:size()
	if ( 7 < deliveryCount ) then
		self.scroll:SetShow( true )
		self.startSlotNo	= UIScroll.ScrollEvent( self.scroll, isScrollUp, self.config.slotCount, deliveryCount, self.startSlotNo, 1 )
	end
	
	self:updateSlot()
end
---------------------------------------------------------------------------------------------------------------------------

--Update Panel ( 슬롯 -취소, 수령- 업데이트 )
function	DeliveryInformation_UpdateSlotData()
	if	not Panel_Window_Delivery_Information:IsShow()	then
		return
	end
	
	local	self		= deliveryInformation
	-- self.startSlotNo	= 0

	if nil ~= DeliveryInformation_WaypointKey() then
		deliveryList	= delivery_list( DeliveryInformation_WaypointKey() )
	end
	if nil ~= deliveryList then
		if 7 < deliveryList:size() and deliveryList:size() < self.startSlotNo + 7 then
			self.startSlotNo = self.startSlotNo - 1
			self.scroll:SetControlPos( self.startSlotNo / deliveryList:size() - 7 )
		end
	end
	self:updateSlot()
end
---------------------------------------------------------------------------------------------------------------------------
function	DeliveryInformationWindow_Open()
	DeliveryRequestWindow_Close()
	Warehouse_SetIgnoreMoneyButton( true )
	
	if	not Panel_Window_Delivery_Information:IsShow()	then
		-- Panel_Window_Delivery_Information:ChangeSpecialTextureInfoName("")
		Panel_Window_Delivery_Information:SetAlphaExtraChild(1)
		Panel_Window_Delivery_Information:SetShow( true, true )
		delivery_requsetList()
		if( ToClient_WorldMapIsShow()) then
			WorldMapPopupManager:increaseLayer(true)
			WorldMapPopupManager:push( Panel_Window_Delivery_Information, true );
		end
	end

	local	self		= deliveryInformation
	self.startSlotNo	= 0
	self:updateSlot()
	self.scroll:SetControlPos(0)

	Panel_Window_Delivery_Information:SetPosX( Panel_Window_Warehouse:GetPosX() - Panel_Window_Delivery_Information:GetSizeX() )
	Panel_Window_Delivery_Information:SetPosY( Panel_Window_Warehouse:GetPosY() - 40)
	Panel_Window_Delivery_Request:SetPosX( Panel_Window_Warehouse:GetPosX() - Panel_Window_Delivery_Information:GetSizeX() )
	Panel_Window_Delivery_Request:SetPosY( Panel_Window_Warehouse:GetPosY() - 40)
end

function	DeliveryInformationWindow_Close()
	if( ToClient_WorldMapIsShow() ) then
		if( Panel_Window_Delivery_Information:GetShow() ) then
			WorldMapPopupManager:pop()
		end
	else
		if	Panel_Window_Delivery_Information:GetShow()	then
			Panel_Window_Delivery_Information:ChangeSpecialTextureInfoName("")
			Panel_Window_Delivery_Information:SetShow(false, false)
		end
	end
end

function DeliveryInformation_Refresh()
	delivery_refreshClear()
	delivery_requsetList()
end

--WorldMap에서 운송창 열기
function	DeliveryInformation_OpenPanelFromWorldmap( waypointKey )
	local	self			= deliveryInformation
	self.currentWaypointKey	= waypointKey
	
	-- 창고 창 열어주기.!
	--Warehouse_OpenPanelFromWorldmap( DeliveryInformation_WaypointKey(), CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap )
	WorldMapPopupManager:increaseLayer(true)
	WorldMapPopupManager:push( Panel_Window_Delivery_Information, true )
	DeliveryInformationWindow_Open()
end

--Dialog에서 운송창 열기
function	DeliveryInformation_OpenPanelFromDialog()
	local	self			= deliveryInformation
	self.currentWaypointKey	= getCurrentWaypointKey()
	
	Warehouse_OpenPanelFromDialogWithoutInventory( getCurrentWaypointKey(), CppEnums.WarehoouseFromType.eWarehoouseFromType_Npc )
	Panel_Window_Warehouse:SetVerticalMiddle()
	Panel_Window_Warehouse:SetHorizonCenter()
	Panel_Window_Warehouse:SetSpanSize(100,0)


	DeliveryInformationWindow_Open()
end

--운송 퀴소 버튼 클릭
function	Delivery_Cancel( slotNo )
	local self			= deliveryInformation
	delivery_cancel( DeliveryInformation_WaypointKey(), self.slots[slotNo].deliveryIndex )
end
--운송 수령 버튼 클릭
function	Delivery_Receive( slotNo )
	local self			= deliveryInformation
	delivery_receive( DeliveryInformation_WaypointKey(), self.slots[slotNo].deliveryIndex )
end

-- 처음 물품부터 7개씩 받기
function	Delivery_Receive_All()
	local	deliveryList = delivery_list( DeliveryInformation_WaypointKey() )
	if	nil == deliveryList	then
		_PA_LOG("이문종", "받을 수 있는 물품이 없다!" )
		return
	end
	
	local warehouseWrapper	= warehouse_get( DeliveryInformation_WaypointKey() )
	if	( nil == warehouseWrapper )	then
		return
	end
	local	freeCount	= warehouseWrapper:getFreeCount()
	if 0 == freeCount then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERTY_RECEIVEALL_NOSLOT") )
		return
	end
	
	local receiveAll = function()
		local index = 0
		local recieveCount = 0
		for index = 0, deliveryList:size() - 1 do
			if ( index < deliveryList:size() ) then			-- 마지막 인덱스까지 반복
				local	deliveryInfo = deliveryList:atPointer(index)
				if 2 == deliveryInfo:getProgressType() then		-- 받을 수 있는 아이템만 수령
					delivery_receive( DeliveryInformation_WaypointKey(), index )
					recieveCount = recieveCount + 1
				end
			end
		end
	end
	
	if freeCount < deliveryList:size() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERTY_RECEIVEALL_SHORTAGESLOT") )
	else
		receiveAll()
	end
end

deliveryInformation:init()
deliveryInformation:registEventHandler()
deliveryInformation:registMessageHandler()

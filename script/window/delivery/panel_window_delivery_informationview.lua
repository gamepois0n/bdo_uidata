Panel_Window_Delivery_InformationView:ActiveMouseEventEffect(true)
Panel_Window_Delivery_InformationView:setMaskingChild(true)
Panel_Window_Delivery_InformationView:setGlassBackground(true)

local UI_color 		= Defines.Color
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

local	deliveryInformationView	= {
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
	
	_staticBackground	= UI.getChildControl( Panel_Window_Delivery_InformationView,	"Static_Bakcground"),
	_buttonClose		= UI.getChildControl( Panel_Window_Delivery_InformationView,	"Button_Win_Close"),
	_buttonQuestion		= UI.getChildControl( Panel_Window_Delivery_InformationView,	"Button_Question"),						-- 물음표 버튼		
	_buttonRefresh		= UI.getChildControl( Panel_Window_Delivery_InformationView,	"Button_Refresh" ),
	_textCount			= UI.getChildControl( Panel_Window_Delivery_InformationView,	"StaticText_DeliveryCount" ),
	_defaultNotify		= UI.getChildControl( Panel_Window_Delivery_InformationView,	"StaticText_Empty_List" ),				-- 리스트가 비어있을 때, 알람 문구
	_scroll				= UI.getChildControl( Panel_Window_Delivery_InformationView,	"Scroll_1" ),
	_slots				= Array.new(),
	
	_startSlotNo		= 0,
	_slotMaxSize		= 100
}

local scrollCtrlBtn		= UI.getChildControl( deliveryInformationView._scroll,			"Scroll_1_CtrlButton" )
scrollCtrlBtn			: addInputEvent( "Mouse_LPress",								"HandleClicked_Delivery_ScrollBtn()" )

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Init
function	deliveryInformationView:registMessageHandler()
	registerEvent("EventDeliveryInfoUpdate",			"DeliveryInformationView_Update")
	registerEvent("FromClient_MoveDeliveryItem", 		"DeliveryInformationView_Update")
end

function	deliveryInformationView:registEventHandler()
	Panel_Window_Delivery_InformationView:addInputEvent(	"Mouse_UpScroll",	"DeliveryInformationView_ScrollEvent( true )"	)
	Panel_Window_Delivery_InformationView:addInputEvent(	"Mouse_DownScroll",	"DeliveryInformationView_ScrollEvent( false )"	)
	self._staticBackground:addInputEvent(					"Mouse_UpScroll",	"DeliveryInformationView_ScrollEvent( true )"	)
	self._staticBackground:addInputEvent(					"Mouse_DownScroll",	"DeliveryInformationView_ScrollEvent( false )"	)
	self._buttonClose:addInputEvent(						"Mouse_LUp",		"DeliveryInformationView_Close()"				)
	self._buttonRefresh:addInputEvent(						"Mouse_LUp",		"DeliveryInformationView_Refresh()"				)
	self._buttonQuestion:addInputEvent(						"Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"DeliveryInformation\" )" )
	self._buttonQuestion:addInputEvent(						"Mouse_On",			"HelpMessageQuestion_Show( \"DeliveryInformation\", \"true\")" )
	self._buttonQuestion:addInputEvent(						"Mouse_Out",		"HelpMessageQuestion_Show( \"DeliveryInformation\", \"false\")" )
end


function	deliveryInformationView:init()
	for ii = 0, self.config.slotCount-1	do
		local	slot= {}
		slot.slotNo	= ii
		slot.panel	= Panel_Window_Delivery_InformationView
		
		-- Slot
		slot.base			= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_InformationView, "Static_Slot",				Panel_Window_Delivery_InformationView,	"DeliveryView_Slot_"				.. ii )
		slot.carriageType	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_InformationView, "StaticText_CarriageType",	slot.base,								"DeliveryView_Slot_CarriageType_"	.. ii )
		slot.departure		= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_InformationView, "StaticText_Departure",		slot.base,								"DeliveryView_Slot_Departure_"		.. ii )
		slot.destination	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_InformationView, "StaticText_Destination",		slot.base,								"DeliveryView_Slot_Destination_"	.. ii )
		slot.static_Arrow	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_InformationView, "Static_Arrow",				slot.base,								"DeliveryView_Slot_Arrow_"			.. ii )
		slot.buttonReady	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_InformationView, "Button_Ready",				slot.base,								"DeliveryView_Slot_Ready_"			.. ii )
		slot.buttonIng		= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_InformationView, "Button_Ing",					slot.base,								"DeliveryView_Slot_Ing_"			.. ii )
		slot.buttonComplete	= UI.createAndCopyBasePropertyControl( Panel_Window_Delivery_InformationView, "Button_Complete",			slot.base,								"DeliveryView_Slot_Complete_"		.. ii )
		
		-- Icon
		slot.icon = {}
		SlotItem.new( slot.icon, 'DeliveryView_Slot_Icon_' .. slot.slotNo, slot.slotNo, slot.base, self.slotConfig )
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
			
			slot.buttonReady:SetPosX( self.config.slotButtonStartX )
			slot.buttonReady:SetPosY( self.config.slotButtonStartY )
			slot.buttonIng:SetPosX( self.config.slotButtonStartX )
			slot.buttonIng:SetPosY( self.config.slotButtonStartY )
			slot.buttonComplete:SetPosX( self.config.slotButtonStartX)
			slot.buttonComplete:SetPosY( self.config.slotButtonStartY)
		--}
				
		-- 이벤트
		--{
			slot.base:addInputEvent(			"Mouse_UpScroll",	"DeliveryInformationView_ScrollEvent( true )"	)
			slot.base:addInputEvent(			"Mouse_DownScroll",	"DeliveryInformationView_ScrollEvent( false )"	)
			slot.icon.icon:addInputEvent(		"Mouse_UpScroll",	"DeliveryInformationView_ScrollEvent( true )"	)
			slot.icon.icon:addInputEvent(		"Mouse_DownScroll",	"DeliveryInformationView_ScrollEvent( false )"	)
			--slot.icon.icon:addInputEvent(		"Mouse_On",			"Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryInformation\",true)" );
			--slot.icon.icon:addInputEvent(		"Mouse_Out",		"Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryInformation\",false)" );
		--}
		
		--Panel_Tooltip_Item_SetPosition( ii, slot.icon, "DeliveryInformation")

		slot.deliveryIndex	= 0
		self._slots[ii] = slot
	end
end

function	deliveryInformationView:update()

	-- 일단 다 비워준다.
	for ii = 0, self.config.slotCount-1	do
		local	slot		= self._slots[ii]
		slot.base:SetShow(false)
	end
	
	-- 없으면 기본 공지 노출
	self._defaultNotify:SetShow(true)
	local	deliveryList= delivery_listAll()
	if	nil == deliveryList	then
		return
	end
	
	local	deliveryCount = deliveryList:size()
	self._textCount:SetText( "(" .. deliveryCount .. "/" .. self._slotMaxSize .. ")" )
	if	0 == deliveryCount	then
		return
	end
	
	self._defaultNotify:SetShow(false)
		
	local	slotIndex		= 0
	for ii = self._startSlotNo, deliveryCount-1	do
		if	(slotIndex < self.config.slotCount)	then
			local	deliveryInfo= deliveryList:atPointer(ii)
			if	nil ~= deliveryInfo	then
				local	itemWrapper	= deliveryInfo:getItemWrapper()
				if	nil ~= itemWrapper	then
					local	slot	= self._slots[slotIndex]
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
	
					slot.buttonReady:SetShow(false)
					slot.buttonIng:SetShow(false)
					slot.buttonComplete:SetShow(false)
					
					if	self.const.deliveryProgressTypeRequest == deliveryInfo:getProgressType()	then
						slot.buttonReady:SetShow(true)
					elseif	self.const.deliveryProgressTypeIng == deliveryInfo:getProgressType()	then
						slot.buttonIng:SetShow(true)
					else
						slot.buttonComplete:SetShow(true)
					end
					
					slot.deliveryIndex	= ii
					slot.base:SetShow(true)
					slotIndex= slotIndex + 1
				end
			end
		end
	end
	UIScroll.SetButtonSize( self._scroll, self.config.slotCount, deliveryCount )		-- 스크롤 컨트롤들 , UI에서 보여주는 최대개수 , 실제 리스트의 수
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Function
function	DeliveryInformationView_Refresh()
	delivery_refreshClear()
	delivery_requsetList()
end

function	DeliveryInformationView_ScrollEvent( isScrollUp )
	local	self		= deliveryInformationView
	local	deliveryList= delivery_listAll()
	if	nil == deliveryList	then
		return
	end
	
	self._scroll:SetShow( false )
	local	deliveryCount = deliveryList:size()
	if ( 5 <= deliveryCount ) then
		self._scroll:SetShow( true )
		self._startSlotNo	= UIScroll.ScrollEvent( self._scroll, isScrollUp, self.config.slotCount, deliveryCount, self._startSlotNo, 1 )
	else
		self._scroll:SetShow( false )
	end
	
	self:update()
end

function HandleClicked_Delivery_ScrollBtn()
	local	deliveryList = delivery_listAll()
	if	nil == deliveryList	then
		return
	end
	
	local	deliveryCount = deliveryList:size()
	if	0 == deliveryCount	then
		return
	end
	
	local self = deliveryInformationView

	local posByIndex	= 1 / ( deliveryCount - self.config.slotCount )
	local currentIndex	= math.floor( self._scroll:GetControlPos() / posByIndex )
	self._startSlotNo	= currentIndex
	self:update()
end

function	DeliveryInformationView_Update()
	local	self	= deliveryInformationView
	
	self._scroll:SetControlPos(0)
	self._startSlotNo	= 0
	self:update()
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Open / Close
function	DeliveryInformationView_Open()
	local	self		= deliveryInformationView
	if	Panel_Window_Delivery_InformationView:GetShow()	then
		return
	end
	
	delivery_requsetList()
	
	if	( ToClient_WorldMapIsShow() )	then
		WorldMapPopupManager:increaseLayer(true)
		WorldMapPopupManager:push( Panel_Window_Delivery_InformationView, true )

		if isWorldMapGrandOpen() then
			Panel_Window_Delivery_InformationView:SetPosX( getScreenSizeX() - Panel_Window_Delivery_InformationView:GetSizeX() - 10 )
			Panel_Window_Delivery_InformationView:SetPosY( (getScreenSizeY()/2) - (Panel_Window_Delivery_InformationView:GetSizeY()/2) )
		end
	end

	DeliveryInformationView_Update()
	
	Panel_Window_Delivery_InformationView:SetAlphaExtraChild(1)
	Panel_Window_Delivery_InformationView:SetShow( true, true )
end

function	DeliveryInformationView_Close()
	if( not Panel_Window_Delivery_InformationView:GetShow() ) then
		return
	end

	if( ToClient_WorldMapIsShow() ) then
		WorldMapPopupManager:pop()
	end
		
	Panel_Window_Delivery_InformationView:ChangeSpecialTextureInfoName("")
	Panel_Window_Delivery_InformationView:SetShow(false, false)
end

deliveryInformationView:init()
deliveryInformationView:registEventHandler()
deliveryInformationView:registMessageHandler()
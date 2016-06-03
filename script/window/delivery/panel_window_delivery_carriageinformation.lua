Panel_Window_Delivery_CarriageInformation:ActiveMouseEventEffect(true)
Panel_Window_Delivery_CarriageInformation:setMaskingChild(true)
Panel_Window_Delivery_CarriageInformation:setGlassBackground(true)

Panel_Window_Delivery_CarriageInformation:RegisterShowEventFunc( true,	'DeliveryCarriageInformationShowAni()' )
Panel_Window_Delivery_CarriageInformation:RegisterShowEventFunc( false,	'DeliveryCarriageInformationHideAni()' )

local UI_color 		= Defines.Color
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

function	DeliveryCarriageInformationShowAni()
	Panel_Window_Delivery_CarriageInformation:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_Window_Delivery_CarriageInformation, 0.0, 0.15 )

	local aniInfo1 = Panel_Window_Delivery_CarriageInformation:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_Window_Delivery_CarriageInformation:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_Delivery_CarriageInformation:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_Delivery_CarriageInformation:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_Delivery_CarriageInformation:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_Delivery_CarriageInformation:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function	DeliveryCarriageInformationHideAni()
	-- Hide 시에 Special Texture 를 리셋해준다!
	Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")

	Panel_Window_Delivery_CarriageInformation:SetAlpha( 1 )
	UIAni.AlphaAnimation( 0, Panel_Window_Delivery_CarriageInformation, 0.0, 0.1 )
end

local	deliveryCarriageInformation	= {
	slotConfig	=
	{
		-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon		= true,
		createBorder	= true,
		createCount		= true,
		createEnchant	= true,
		createCash		= true
	},
	
	config	=
	{
		-- 이 값들은 추후에 메시지로 빼어내어 세팅해야 할까?
		slotCount	= 4,
		slotStartX	= 7,
		slotStartY	= 37,
		slotGapY	= 65,
		
		slotIconStartX			= 5,
		slotIconStartY			= 8,
		slotCarriageTypeStartX	= 88,
		slotCarriageTypeStartY	= 8,
		slotDepartureStartX		= 65,
		slotDepartureStartY		= 21,
		slotDestinationStartX	= 215,
		slotDestinationStartY	= 21,
		slotArrowStartX			= 180,
		slotArrowStartY			= 23,
		slotButtonStartX		= 330,
		slotButtonStartY		= 5
	},
	
	const	=
	{
		deliveryProgressTypeRequest	= 0,
		deliveryProgressTypeIng		= 1,
		deliveryProgressTypeComplete= 2,
	},
	
	panel_Background		= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"Static_Bakcground"),
	button_Close			= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"Button_Close"),
	_buttonQuestion			= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"Button_Question"),						-- 물음표 버튼
	empty_List				= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"StaticText_Empty_List" ),				-- 리스트가 비어있을 때, 알람 문구
	scroll					= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"Scroll_1" ),
	slots					= Array.new(),
	startSlotNo				= 0									-- scroll 관련
}

local _slide = UI.getChildControl ( Panel_Window_Delivery_Information, "Scroll_1" )

--이벤트 등록 < client -> lua >
function	deliveryCarriageInformation:registMessageHandler()
end

-- 버튼 이벤트 등록
function	deliveryCarriageInformation:registEventHandler()
	UIScroll.InputEvent( self.scroll,							"DeliveryCarriageInformation_ScrollEvent")
	UIScroll.InputEventByControl( self.panel_Background,		"DeliveryCarriageInformation_ScrollEvent" )
	self.button_Close:addInputEvent(		"Mouse_LUp",		"DeliveryCarriageInformationWindow_Close()" )
	self._buttonQuestion:addInputEvent(		"Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"DeliveryCarriageinformation\" )" )		-- 물음표 좌클릭
	self._buttonQuestion:addInputEvent(		"Mouse_On",		"HelpMessageQuestion_Show( \"DeliveryCarriageinformation\", \"true\")" )		-- 물음표 마우스오버
	self._buttonQuestion:addInputEvent(		"Mouse_Out",		"HelpMessageQuestion_Show( \"DeliveryCarriageinformation\", \"false\")" )		-- 물음표 마우스아웃
end

-- 초기화 함수
function	deliveryCarriageInformation:init()
	local	static_Slot				= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"Static_Slot" )				-- 기본 슬롯
	local	static_Item				= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"Static_ItemIcon" )					-- 아이템
	local	static_Arrow			= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"Static_Arrow" )					-- 화살표
	local	staticText_Departure	= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"StaticText_Departure" )			-- 출발
	local	staticText_Destination	= UI.getChildControl( Panel_Window_Delivery_CarriageInformation,	"StaticText_Destination" )			-- 도착
	
	-- 기본
	UI.ASSERT( nil ~= self.panel_Background		and 'number' ~= type(self.panel_Background),				"Static_Bakcground")
	UI.ASSERT( nil ~= self.button_Close			and 'number' ~= type(self.button_Close),					"Button_Close")
	UI.ASSERT( nil ~= self.scroll				and 'number' ~= type(self.scroll),							"Scroll_1")
	-- 사용하고 삭제
	UI.ASSERT( nil ~= static_Slot				and 'number' ~= type(static_Slot),							"Static_Slot" )						-- 백그라운드
	UI.ASSERT( nil ~= static_Item				and 'number' ~= type(static_Item),							"Static_ItemIcon" )					-- 아이템
	UI.ASSERT( nil ~= static_Arrow				and 'number' ~= type(static_Arrow),							"Static_Arrow" )					-- 화살표
	UI.ASSERT( nil ~= staticText_Departure		and 'number' ~= type(staticText_Departure),					"StaticText_Departure" )			-- 출발
	UI.ASSERT( nil ~= staticText_Destination	and 'number' ~= type(staticText_Destination),				"StaticText_Destination" )			-- 도착

	-- 관리창
	for ii = 0, self.config.slotCount-1	do
		local	slot= {}
		slot.slotNo	= ii
		slot.panel	= Panel_Window_Delivery_CarriageInformation
		
		-- Slot
		slot.base			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_Delivery_CarriageInformation, "Delivery_Slot_" .. slot.slotNo )
		CopyBaseProperty( static_Slot, slot.base )
		
		-- 출발지
		slot.departure		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.base, "Delivery_Slot_Departure_" .. slot.slotNo )
		CopyBaseProperty( staticText_Departure, slot.departure )
		
		-- 도착지
		slot.destination	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.base, "Delivery_Slot_Destination_" .. slot.slotNo )
		CopyBaseProperty( staticText_Destination, slot.destination )

		-- 화살표
		slot.static_Arrow	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, slot.base, "Delivery_Slot_Arrow_" .. slot.slotNo )
		CopyBaseProperty( static_Arrow, slot.static_Arrow )
		
		-- Icon
		slot.icon = {}
		SlotItem.new( slot.icon, 'Delivery_Slot_Icon_' .. slot.slotNo, slot.slotNo, slot.base, self.slotConfig )
		slot.icon:createChild()
		
		slot.base:SetPosX( self.config.slotStartX )
		slot.base:SetPosY( self.config.slotStartY + (self.config.slotGapY * slot.slotNo) )
		
		slot.icon.icon:SetPosX( self.config.slotIconStartX )
		slot.icon.icon:SetPosY( self.config.slotIconStartY )
		
		slot.departure:SetPosX( self.config.slotDepartureStartX )
		slot.departure:SetPosY( self.config.slotDepartureStartY )
		
		slot.destination:SetPosX( self.config.slotDestinationStartX )
		slot.destination:SetPosY( self.config.slotDestinationStartY )
		
		slot.static_Arrow:SetPosX( self.config.slotArrowStartX )
		slot.static_Arrow:SetPosY( self.config.slotArrowStartY )
		
		slot.static_Arrow:SetIgnore(true)
		slot.base:SetShow(true)
		slot.icon.icon:SetShow(true)
		slot.icon.icon:SetEnable( true )
		slot.departure:SetShow(true)
		slot.destination:SetShow(true)
		slot.static_Arrow:SetShow(true)
		
		UIScroll.InputEventByControl( slot.base,				"DeliveryCarriageInformation_ScrollEvent" )
		UIScroll.InputEventByControl( slot.icon.icon,			"DeliveryCarriageInformation_ScrollEvent" )
		
		slot.icon.icon:addInputEvent(		"Mouse_On",			"Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryCarriageInformation\",true)" );
		slot.icon.icon:addInputEvent(		"Mouse_Out",		"Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryCarriageInformation\",false)" );
				
		Panel_Tooltip_Item_SetPosition( ii, slot.icon, "DeliveryCarriageInformation")
		
		slot.base:SetShow(false)
		
		self.slots[ii] = slot
	end

	self.scroll:SetControlPos( 0 )	-- 맨 위로 올림!

end

function	deliveryCarriageInformation:updateSlot()

	for ii = 0, self.config.slotCount-1	do
		local	slot= self.slots[ii]
		slot.slotNo	= -1
		slot.base:SetShow(false)
	end
	
	local	deliveryList= deliveryCarriage_dlieveryList( self.objectID )
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
		
	local	showSlot	= 0
	for ii = self.startSlotNo, deliveryCount-1	do
		if	showSlot < self.config.slotCount	then
			local	deliveryInfo= deliveryList:atPointer(ii)
			if	nil ~= deliveryInfo	then
				local	itemWrapper	= deliveryInfo:getItemWrapper(ii)
				if	nil ~= itemWrapper	then
					local	slot	= self.slots[showSlot]
					slot.icon:setItem(itemWrapper)
					slot.slotNo	= ii
					slot.departure:SetText( deliveryInfo:getFromRegionName(ii) )
					slot.destination:SetText( deliveryInfo:getToRegionName(ii) )
					slot.base:SetShow(true)
					showSlot= showSlot + 1
				end
			end
		end
	end
	-- scroll 설정
	UIScroll.SetButtonSize( self.scroll, self.config.slotCount, deliveryCount )
	-- self.scroll:UpdateContentScroll()		-- 스크롤 감도 동일하게	
end

---------------------------------------------------------------------------------------------------------------------------
function	DeliveryCarriageInformation_ScrollEvent( isScrollUp )
	local	self		= deliveryCarriageInformation
	local	deliveryList= deliveryCarriage_dlieveryList( self.objectID )
	if	nil == deliveryList	then
		return
	end
	
	local	deliveryCount = deliveryList:size()
	self.startSlotNo= UIScroll.ScrollEvent( self.scroll, isScrollUp, self.config.slotCount, deliveryCount, self.startSlotNo, 1 )
	
	self:updateSlot()
end

function	DeliveryCarriageInformationWindow_Open( objectID )
	
	if	Panel_Window_Delivery_CarriageInformation:GetShow()	then
		-- _PA_LOG("최대호", "에이?")
		return
	end
	
	local	deliveryList= deliveryCarriage_dlieveryList( objectID )
	if	nil == deliveryList	then
		-- _PA_LOG("최대호", "여기임?")
		return
	end
	
	Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")
	Panel_Window_Delivery_CarriageInformation:SetAlphaExtraChild(1)
	Panel_Window_Delivery_CarriageInformation:SetShow(true, false)
	
	local	self			= deliveryCarriageInformation
	self.startSlotNo		= 0
	self.objectID			= objectID;
	self:updateSlot()
	
	_slide:SetControlPos(0)
end

function	DeliveryCarriageInformationWindow_Close()
	if	Panel_Window_Delivery_CarriageInformation:GetShow()	then
		Panel_Window_Delivery_CarriageInformation:ChangeSpecialTextureInfoName("")
		Panel_Window_Delivery_CarriageInformation:SetShow(false, false)	
	end
end


function	DeliveryCarriageInformation_SlotIndex( slotNo )
	local	self			= deliveryCarriageInformation
	return(self.slots[slotNo].slotNo)
end

function	DeliveryCarriageInformation_ObjectID()
	local	self			= deliveryCarriageInformation
	return(self.objectID)
end

deliveryCarriageInformation:init()
deliveryCarriageInformation:registEventHandler()
deliveryCarriageInformation:registMessageHandler()

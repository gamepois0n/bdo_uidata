local UI_TM 		= CppEnums.TextMode
local UI_color 		= Defines.Color
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT 			= CppEnums.PA_UI_CONTROL_TYPE

Panel_Window_Delivery_Request:ActiveMouseEventEffect(true)
Panel_Window_Delivery_Request:setMaskingChild(true)
Panel_Window_Delivery_Request:setGlassBackground(true)
Panel_Window_Delivery_Request:RegisterShowEventFunc( true,	'DeliveryRequestShowAni()' )
Panel_Window_Delivery_Request:RegisterShowEventFunc( false,	'DeliveryRequestHideAni()' )


function	DeliveryRequestShowAni()
	UIAni.fadeInSCR_Down(Panel_Window_Delivery_Request)
end

function	DeliveryRequestHideAni()
	-- Hide 시에 Special Texture 를 리셋해준다!
	Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")

	Panel_Window_Delivery_Request:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_Delivery_Request:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)

	--local aniInfo2 = Panel_Window_Delivery_Request:addScaleAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	--aniInfo2:SetStartScale(1.0)
	--aniInfo2:SetEndScale(0.92)
	--aniInfo2.AxisX = 200
	--aniInfo2.AxisY = 295
	--aniInfo2.IsChangeChild = true
end

local	deliveryRequest	= {
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
		slotCount	= 40,
		slotCols 	= 8,
		slotRows	= 0,	-- 계산되는 값
		slotStartX	= 9,
		slotStartY	= 189,
		slotGapX	= 48,
		slotGapY	= 48,
		
		fontColor	= UI_color.C_FFFFFFFF
	},
	slotBG						= UI.getChildControl ( Panel_Window_Delivery_Request, 	"Static_SlotBG" ),
	
	staticText_RequestTitle		= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_Title" ),
	button_Close				= UI.getChildControl( Panel_Window_Delivery_Request,	"Button_Close"),
	_buttonQuestion				= UI.getChildControl( Panel_Window_Delivery_Request,	"Button_Question"),		-- 물음표 버튼
	
	button_Information			= UI.getChildControl( Panel_Window_Delivery_Request,	"Button_Cancel_Recieve" ),
	                            
	--	요청		            
	static_RequestBakcground	= UI.getChildControl( Panel_Window_Delivery_Request,	"Static_Sample_Background" ),
	-- staticText_Fee_Title		= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_Title_Fee" ),
	-- staticText_Fee				= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_Value_Fee" ),					-- 기본 수수료값
	-- staticText_FeeTrade			= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_Value_Fee_Trade" ),				-- 기분 수수료값 ( 무역 )
	staticGoldIcon				= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_Gold_Icon_Total_Charge" ),
	staticText_WayPointPenalty	= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_WayPointPenalty" ),
			                    
	staticText_Total_Title		= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_Title_TotalCount" ),
	staticText_TotalCount		= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_Value_Total_Count" ),			-- 총 갯수
	staticText_TotalFee			= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_Value_Total_Fee" ),				-- 총 수수료
	button_Send					= UI.getChildControl( Panel_Window_Delivery_Request,	"Button_Send" ),							-- 보내기 버튼
	comboBox_Destination		= UI.getChildControl( Panel_Window_Delivery_Request,	"Combobox_Destination" ),					-- 도착지 콤보박스
	comboBox_Carriage			= UI.getChildControl( Panel_Window_Delivery_Request,	"Combobox_Carriage" ),						-- 마차 종류 콤보 박스
	
	deliveryHelpBG				= UI.getChildControl( Panel_Window_Delivery_Request,	"Static_HelpBG" ),
	deliveryHelpDesc			= UI.getChildControl( Panel_Window_Delivery_Request,	"StaticText_HelpDesc" ),
	
	slots						= Array.new(),
	slotbgs						= Array.new(),
	
	selectWaypointKey		= 0,	-- 운송 보낼 마을 키
	selectCarriageKeyRaw	= 0,	-- 물건 태울 마차 타입 키
	distance				= 0		-- 거리
}
--이벤트 등록 < client -> lua >
function deliveryRequest:registMessageHandler()
	registerEvent("FromClient_MoveDeliveryItem", "FromClient_DeliveryItemState")
end

-- 버튼 이벤트 등록
function deliveryRequest:registEventHandler()
	self.button_Close:addInputEvent(			"Mouse_LUp",	"DeliveryRequestWindow_Close()" )
	self._buttonQuestion:addInputEvent(			"Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"DeliveryRequest\" )" )			-- 물음표 좌클릭
	self._buttonQuestion:addInputEvent(			"Mouse_On",		"HelpMessageQuestion_Show( \"DeliveryRequest\", \"true\")" )			-- 물음표 마우스오버
	self._buttonQuestion:addInputEvent(			"Mouse_Out",	"HelpMessageQuestion_Show( \"DeliveryRequest\", \"false\")" )			-- 물음표 마우스아웃
	self.button_Information:addInputEvent(		"Mouse_LUp",	"ShowInformationWindow()" )
	self.comboBox_Destination:addInputEvent(	"Mouse_LUp",	"DeliveryRequest_ShowToWaypointKey()" )
	self.comboBox_Carriage:addInputEvent(		"Mouse_LUp",	"DeliveryRequest_ShowToCarriage()" )
	self.button_Send:addInputEvent(				"Mouse_LUp",	"DeliveryRequest_Send_CheckNode()" )
end

-- 초기화 함수
function deliveryRequest:init()
	-- 기본
	UI.ASSERT( nil ~= self.staticText_RequestTitle			and 'number' ~= type(self.staticText_RequestTitle),			"StaticText_Title" )
	UI.ASSERT( nil ~= self.button_Close						and 'number' ~= type(self.button_Close),					"Button_Close")
	UI.ASSERT( nil ~= self.button_Information				and 'number' ~= type(self.button_Information),				"Button_Cancel_Recieve" )
	UI.ASSERT( nil ~= self.static_RequestBakcground			and 'number' ~= type(self.static_RequestBakcground),		"Static_Sample_Background" )
	-- 요청
	-- UI.ASSERT( nil ~= self.staticText_Fee					and 'number' ~= type(self.staticText_Fee),					"StaticText_Value_Fee" )-- 개당 수수료값
	-- UI.ASSERT( nil ~= self.staticText_FeeTrade				and 'number' ~= type(self.staticText_FeeTrade),				"StaticText_Value_Fee_Trade" )-- 개당 수수료값
	
	UI.ASSERT( nil ~= self.staticText_TotalCount			and 'number' ~= type(self.staticText_TotalCount),			"StaticText_Value_Total_Count" )		-- 총 갯수
	UI.ASSERT( nil ~= self.staticText_TotalFee				and 'number' ~= type(self.staticText_TotalFee),				"StaticText_Value_Total_Fee" )			-- 총 수수료
	UI.ASSERT( nil ~= self.button_Send						and 'number' ~= type(self.button_Send),						"Button_Send" )							-- 보내기 버튼
	UI.ASSERT( nil ~= self.comboBox_Destination				and 'number' ~= type(self.comboBox_Destination),			"Combobox_Destination" )				-- 도착지 콤보박스
	UI.ASSERT( nil ~= self.comboBox_Carriage				and 'number' ~= type(self.comboBox_Carriage),				"Combobox_Carriage" )					-- 마차 종류 콤보 박스

	self.config.slotRows = self.config.slotCount / self.config.slotCols
	
	-- 요청창
	for ii = 0, self.config.slotCount-1	do
		self.slotbgs[ii]= UI.createControl( UCT.PA_UI_CONTROL_STATIC, 	Panel_Window_Delivery_Request, 'StaticSlotBG_' .. ii )
		CopyBaseProperty(self.slotBG, self.slotbgs[ii])
		
		local	slot= {}
		slot.slotNo	= ii
		local row = math.floor( slot.slotNo / self.config.slotCols )
		local col = slot.slotNo % self.config.slotCols
		slot.panel	= Panel_Window_Delivery_Request
		self.slotbgs[ii]:SetPosX( self.config.slotStartX + self.config.slotGapX * col )
		self.slotbgs[ii]:SetPosY( self.config.slotStartY + self.config.slotGapY * row )
		
		slot.base	= {}
		SlotItem.new( slot.base, 'ItemSlot_' .. slot.slotNo, slot.slotNo, self.slotbgs[ii], self.slotConfig )
		slot.base:createChild()
		
		-- slot.base.icon:SetPosX( self.config.slotStartX + self.config.slotGapX * col )
		-- slot.base.icon:SetPosY( self.config.slotStartY + self.config.slotGapY * row )
		slot.base.icon:SetVerticalMiddle()
		slot.base.icon:SetHorizonCenter()
		slot.base.icon:addInputEvent(	"Mouse_RUp",	"DeliveryRequest_SlotRClick(" .. ii .. ")" )
		slot.base.icon:addInputEvent(	"Mouse_On",		"Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryRequest\",true)" );
		slot.base.icon:addInputEvent(	"Mouse_Out",	"Panel_Tooltip_Item_Show_GeneralNormal(" .. ii .. ", \"DeliveryRequest\",false)" );
		slot.base.icon:SetIgnore(false)
		slot.base.icon:SetShow(true)
		Panel_Tooltip_Item_SetPosition( ii, slot.base, "DeliveryRequest")
		
		self.slots[ii]		= slot
	end
	UI.deleteControl( self.slotBG )
	self.slotBG = nil
end

function	deliveryRequest:update()
	local	basePrice				= 0
	local	baseTradePrice			= 0
	local	totalCount				= 0
	local	tatalPrice				= 0
	local	packingItemCount		= delivery_packCountType( false )
	local	packingTradeItemCount	= delivery_packCountType( true )
		
	if	0 ~= self.selectCarriageKeyRaw	then
		basePrice		= delivery_baseFee( DeliveryInformation_WaypointKey(), self.selectWaypointKey, self.selectCarriageKeyRaw, false )
		baseTradePrice	= delivery_baseFee( DeliveryInformation_WaypointKey(), self.selectWaypointKey, self.selectCarriageKeyRaw, true )
		tatalPrice		= (packingItemCount * basePrice) + (packingTradeItemCount * baseTradePrice)
		totalCount		= packingItemCount + packingTradeItemCount
	end
	
	-- self.staticText_Fee:SetText( '' .. tostring(basePrice) )
	-- self.staticText_FeeTrade:SetText( '' .. tostring(baseTradePrice) )
	self.staticText_TotalCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_DeliveryRequest_packingCount", "packingCount", tostring(totalCount) ) )
	self.staticText_TotalFee:SetText( '' .. makeDotMoney(tatalPrice) )

	if 0 ~= self.selectWaypointKey then
		if (not delivery_linkedWayPoint( DeliveryInformation_WaypointKey(), self.selectWaypointKey )) then
			self.staticText_WayPointPenalty:SetShow( true )
		else
			self.staticText_WayPointPenalty:SetShow( false )
		end
	else
		self.staticText_WayPointPenalty:SetShow( false )
	end

	self.staticGoldIcon:ComputePos()
	self.staticText_Total_Title:ComputePos()
	self.staticText_TotalCount:ComputePos()
	self.staticText_TotalFee:ComputePos()
	
	self:clearSlot()
	
	for ii = 0, self.config.slotCount-1	do
		local	itemWrapper	= delivery_packItem(ii)

		if	(nil ~= itemWrapper)	then
			-- self.slots[ii].base:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
			self.slots[ii].base:setItem( itemWrapper )
		end
	end
end

function	deliveryRequest:updateDestination()
	self.comboBox_Destination:DeleteAllItem()
	
	local	waypointKeyList		= delivery_listWaypointKey( DeliveryInformation_WaypointKey(), false )
	local	size				= waypointKeyList:size()
	
	if	size == 0	then
		self.comboBox_Destination:SetSelectItemIndex(0);
		self.comboBox_Destination:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_NOT_CONNECT_REGION") )	--'연결된 지역 없음'
		return
	end
	
	for ii=0, size-1	do
		self.comboBox_Destination:AddItem( waypointKeyList:atPointer(ii):getName() )
	end

	--self.comboBox_Destination:SetSelectItemIndex(0);
end

function	deliveryRequest:updateCarriageTypeList()
	self.comboBox_Carriage:DeleteAllItem()
	
	local	carriageList		= delivery_listCarriage( DeliveryInformation_WaypointKey(), self.selectWaypointKey, false)
	local	size				= carriageList:size()
	
	if	size == 0	then
		self.comboBox_Carriage:SetSelectItemIndex(0);
		self.comboBox_Carriage:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_SELECT_REGION") )		--	'마을을 선택해 주세요' )
		return
	end
	
	for ii=0, size-1	do
		self.comboBox_Carriage:AddItem( carriageList:atPointer(ii):getName() )
	end

	-- self.comboBox_Carriage:SetSelectItemIndex(0);
end

--packing------------------------------------------------------------------------------------------------------------------------------------------------------
--ui slot 초기화
function	deliveryRequest:clearSlot()	
	for ii = 0,  self.config.slotCount-1	do
		self.slots[ii].base:clearItem()
	end
end


--창고 아이템 팩킹
function	DeliveryRequest_PushPackingItem( warehouseSlotNo, s64_count )
	if	s64_count < Defines.s64_const.s64_1	then
		return
	end
	
	local	self= deliveryRequest
	
	delivery_pushPack( warehouseSlotNo, s64_count )
	self:update()
	FromClient_WarehouseUpdate()
end
-- 보낸것 삭제
function	DeliveryRequest_UpdateRequestSlotData()
	local	self= deliveryRequest
	self:update()
end
--packing end------------------------------------------------------------------------------------------------------------------------------------------------------
--전부 보내기.
function DeliveryRequest_Send_CheckNode()
	local	self					= deliveryRequest
	local	packingItemCount		= delivery_packCountType( false )
	local	packingTradeItemCount	= delivery_packCountType( true )
	
	if	((packingItemCount + packingTradeItemCount) < 1)	then
		return
	end
	-- 옵션이 선택되어 있는지 확인을 먼저.
	local selected_Destination	= self.comboBox_Destination:GetSelectIndex()
	local selected_Carriage		= self.comboBox_Carriage:GetSelectIndex()
	if (-1 == selected_Destination) or (-1 == selected_Carriage) then
		local	messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
		local	messageboxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_PLZSELECT_DESTINATION")
		local	messageboxData	= { title = messageboxTitle, content = messageboxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
		return
	end

	if	( not delivery_linkedWayPoint( DeliveryInformation_WaypointKey(), self.selectWaypointKey ))	then
		local	messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_NOTLINKEDWAYPOINT_TITLE")
		local	messageboxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_NOTLINKEDWAYPOINT_MSG")
		local 	messageboxData	= { title = messageboxTitle, content = messageboxMemo, functionYes = DeliveryRequest_Send, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData)
	else
		DeliveryRequest_Send()
	end
end

function	DeliveryRequest_Send()
	local	self= deliveryRequest
	delivery_request( DeliveryInformation_WaypointKey(), self.selectWaypointKey, self.selectCarriageKeyRaw )
end

--도착지 선택
function DeliveryRequest_ShowToWaypointKey()
	local	self		= deliveryRequest
	local	waypointList= self.comboBox_Destination:GetListControl();
	waypointList:addInputEvent( "Mouse_LUp", "DeliveryRequest_SelectToWaypointKey()" )
	self.comboBox_Destination:ToggleListbox();
end

function DeliveryRequest_SelectToWaypointKey()
	local	self			= deliveryRequest
	local	waypointKeyList	= delivery_listWaypointKey( DeliveryInformation_WaypointKey(), false )
	local	size			= waypointKeyList:size()
	local	selectIndex		= self.comboBox_Destination:GetSelectIndex()
	local	waypoint		= waypointKeyList:atPointer(selectIndex)
	if	( nil == waypoint )	then
		return
	end
 	self.comboBox_Carriage:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_DELIVERER") )	--"운송수단"
	self.comboBox_Destination:SetSelectItemIndex( selectIndex )
	self.selectWaypointKey	= waypointKeyList:atPointer(selectIndex):getWaypointKey()
	--self.distance			= delivery_distance( DeliveryInformation_WaypointKey(), self.selectWaypointKey)
	self.comboBox_Destination:ToggleListbox()
	self:updateCarriageTypeList()
	self:update()
end

--운송할 마차 선택
function	DeliveryRequest_ShowToCarriage()
	local	self		= deliveryRequest
	local	carriageList= self.comboBox_Carriage:GetListControl();
	carriageList:addInputEvent( "Mouse_LUp", "DeliveryRequest_SelectCarriageType()" )
	self.comboBox_Carriage:ToggleListbox();
end


function	DeliveryRequest_SelectCarriageType()
	if -1 == deliveryRequest.comboBox_Destination:GetSelectIndex() then
		return
	end
	
	local	self				= deliveryRequest
	local	carriageList		= delivery_listCarriage( DeliveryInformation_WaypointKey(), self.selectWaypointKey, false)
	if	( nil == carriageList )	then
		return
	end
	
	local	size				= carriageList:size()
	local	selectIndex			= self.comboBox_Carriage:GetSelectIndex()
	if -1 == selectIndex then
		return
	end
	self.comboBox_Carriage:SetSelectItemIndex( selectIndex )
	self.selectCarriageKeyRaw	= carriageList:atPointer(selectIndex):getCharacterKeyRaw()
	self.comboBox_Carriage:ToggleListbox();
	
	self:update()
end

---------------------------------------------------------------------
-- 					운송 보내기 창 열기
---------------------------------------------------------------------
function	DeliveryRequestWindow_Open()
	Warehouse_SetIgnoreMoneyButton( true )		-- 창고에서 실버 버튼을 막아주자
	
	-- 도움말
	deliveryRequest.deliveryHelpDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	deliveryRequest.deliveryHelpDesc:SetText( PAGetString ( Defines.StringSheet_GAME, "Lua_DELIVERY_HELPDESC") ) -- - 원하는 발송지 노드에 투자가 되어있지 않아도 발송은 가능하다. 단, 그럴 시에는 운송비를 3배로 내야한다.\n- 노드가 발견되어있지 않을 경우 목적지 리스트에 노출되지 않는다.\n(※ 마을 발견이 되지 않으면 창고 이용이 불가능하기 때문이다.)
	deliveryRequest.deliveryHelpBG:SetSize( 385, deliveryRequest.deliveryHelpDesc:GetTextSizeY() + 5 )
	
	deliveryRequest.staticText_Total_Title	:SetPosY( deliveryRequest.deliveryHelpBG:GetPosY() + deliveryRequest.deliveryHelpBG:GetSizeY() + 5 )
	deliveryRequest.staticText_TotalCount	:SetPosY( deliveryRequest.deliveryHelpBG:GetPosY() + deliveryRequest.deliveryHelpBG:GetSizeY() + 5 )
	deliveryRequest.staticText_TotalFee		:SetPosY( deliveryRequest.staticText_Total_Title:GetPosY() + deliveryRequest.staticText_Total_Title:GetSizeY() )
	-- deliveryRequest.staticText_Fee_Title	:SetPosY( deliveryRequest.staticText_Total_Title:GetPosY() + deliveryRequest.staticText_Total_Title:GetSizeY() )
	deliveryRequest.staticGoldIcon			:SetPosY( deliveryRequest.staticText_Total_Title:GetPosY() + deliveryRequest.staticText_Total_Title:GetSizeY() + 3 )
	
	deliveryRequest.button_Send				:SetPosY( deliveryRequest.deliveryHelpBG:GetPosY() + deliveryRequest.deliveryHelpBG:GetSizeY() + 10 )
	
	Panel_Window_Delivery_Request:SetSize( Panel_Window_Delivery_Request:GetSizeX(), deliveryRequest.button_Send:GetPosY() + deliveryRequest.button_Send:GetSizeY() + 7 )
	
	DeliveryInformationWindow_Close()
	if	not Panel_Window_Delivery_Request:IsShow()	then
		Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")
		Panel_Window_Delivery_Request:SetAlphaExtraChild(1)
		Panel_Window_Delivery_Request:SetShow(true, IsAniUse() )
		if( ToClient_WorldMapIsShow()) then
			WorldMapPopupManager:increaseLayer(true)
			WorldMapPopupManager:push( Panel_Window_Delivery_Request, true );
		end
	end
	
	local	self= deliveryRequest
	self.comboBox_Destination:DeleteAllItem()
	self.comboBox_Destination:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_SELECT_TO_REGION") )	--"목적지"
	self.comboBox_Destination:SetSelectItemIndex(0)
	
	self.comboBox_Carriage:DeleteAllItem()
	self.comboBox_Carriage:AddItem( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_DELIVERER") )	--"운송수단"
	self.comboBox_Carriage:SetSelectItemIndex(0)
	
	self.selectCarriageKeyRaw	= 0
	self.selectWaypointKey		= 0
	--self.distance				= 0		-- 거리
	
	clearDeliveryPack()
	
	self:clearSlot()
	self:updateDestination()
	self:update()
end

function	DeliveryRequestWindow_Close()
	--Warehouse_SetIgnoreMoneyButton( false ) 	-- 창고에서 돈 버튼을 다시 활성화!
	clearDeliveryPack()
	if ( ToClient_WorldMapIsShow() ) then
		if( Panel_Window_Delivery_Request:GetShow() ) then
			WorldMapPopupManager:pop()
		end
	else
		if	Panel_Window_Delivery_Request:GetShow()	then
			Panel_Window_Delivery_Request:ChangeSpecialTextureInfoName("")
			Panel_Window_Delivery_Request:SetShow(false, IsAniUse() )
			FromClient_WarehouseUpdate()
		end
	end
end


-- 정보창 열기
function	ShowInformationWindow()
	DeliveryInformationWindow_Open()
end
--packing 취소하기
function	DeliveryRequest_SlotRClick( slotNo )
	local	self	= deliveryRequest
	
	delivery_popPack( slotNo )
	self:update()
	FromClient_WarehouseUpdate()
end

function	FromClient_DeliveryItemState( state )
	if 0 == state then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_WAIT") ) -- "운송 대기중입니다.")
	elseif 1 == state then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_START") ) -- "운송을 시작합니다.")
	elseif 2 == state then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_REQUEST_DELIVERYITEMSTATE_COMPLETE") ) -- "운송이 완료됐습니다.")
	end
end

deliveryRequest:init()
deliveryRequest:registEventHandler()
deliveryRequest:registMessageHandler()

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TT			= CppEnums.PAUI_TEXTURE_TYPE
local IM 			= CppEnums.EProcessorInputMode
local UI_color 		= Defines.Color

Panel_Window_Socket:SetShow(false, false)
Panel_Window_Socket:setMaskingChild(true)
Panel_Window_Socket:setGlassBackground(true)
Panel_Window_Socket:SetDragEnable(true)
Panel_Window_Socket:SetDragAll(true)

Panel_Window_Socket:RegisterShowEventFunc( true, 'SocketShowAni()' )
Panel_Window_Socket:RegisterShowEventFunc( false, 'SocketHideAni()' )

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
local socket =
{
	slotConfig =
	{
		createIcon		= false,
		createBorder	= true,
		createCount		= true,
		createEnchant 	= true,
		createCash		= true
	},
	config =
	{
		socketSlotCount = 3,
		curSlotCount = 3
	},
	control =
	{
		staticEnchantItem = UI.getChildControl( Panel_Window_Socket, "Static_Equip_Socket" ),
		
		staticSocket =
		{
			UI.getChildControl( Panel_Window_Socket, "Static_Socket_1" ),
			UI.getChildControl( Panel_Window_Socket, "Static_Socket_2" ),
			UI.getChildControl( Panel_Window_Socket, "Static_Socket_3" ),
		},
		
		staticSocketName =
		{
			UI.getChildControl( Panel_Window_Socket, "StaticText_NameTag_1" ),
			UI.getChildControl( Panel_Window_Socket, "StaticText_NameTag_2" ),
			UI.getChildControl( Panel_Window_Socket, "StaticText_NameTag_3" ),
		},
		
		staticSocketDesc =
		{
			UI.getChildControl( Panel_Window_Socket, "StaticText_List_1" ),
			UI.getChildControl( Panel_Window_Socket, "StaticText_List_2" ),
			UI.getChildControl( Panel_Window_Socket, "StaticText_List_3" ),
		},
		
		staticSocketBackground =
		{
			UI.getChildControl( Panel_Window_Socket, "Static_Socket_1_Background" ),
			UI.getChildControl( Panel_Window_Socket, "Static_Socket_2_Background" ),
			UI.getChildControl( Panel_Window_Socket, "Static_Socket_3_Background" ),
		},
	},
	
	text =
	{
		[1] = PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_EMPTYSLOT" ),
	},
	desc =
	{
		[1] = PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_EMPTYSLOT_DESC" ),
	},
	
	slotMain			= nil,
	slotSocket			= Array.new(),
	_indexSocket		= nil,
	
	_jewelInvenSlotNo	= nil,
}

local 	_buttonQuestion = UI.getChildControl( Panel_Window_Socket, "Button_Question" )			-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Socket\" )" )									-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"Socket\", \"true\")" )					-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"Socket\", \"false\")" )					-- 물음표 마우스오버

local onlySocketListBG =
{
	[1] = UI.getChildControl( Panel_Window_Socket, "Static_SocketBG_0" ),
	[2] = UI.getChildControl( Panel_Window_Socket, "Static_SocketBG_1" ),
	[3] = UI.getChildControl( Panel_Window_Socket, "Static_SocketBG_2" ),
}



------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function socket:init()
	for _, control in ipairs(self.control.staticSocketName) do
		control:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )	-- Auto Wrap
	end
	for _, control in ipairs(self.control.staticSocketDesc) do
		control:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )	-- Auto Wrap
	end
	Panel_Window_Socket:SetEnableArea(0,0,500,25)
end


--------------------------------------------------------------------------------------
--							소켓 개수대로 만들어주자
--------------------------------------------------------------------------------------
function socket:createControl()
	local slotMain = {}
	slotMain.icon = self.control.staticEnchantItem
	SlotItem.new( slotMain, 'Equip_Socket', 0, Panel_Window_Socket, self.slotConfig )
	slotMain:createChild()
	slotMain.icon:addInputEvent( "Mouse_RUp", "Socket_EquipSlotRClick()" )
	slotMain.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(0, \"Socket\", true)" )
	slotMain.icon:addInputEvent( "Mouse_Out","Panel_Tooltip_Item_Show_GeneralNormal(0, \"Socket\", false)" )
	Panel_Tooltip_Item_SetPosition(0, slotMain, "Socket")
	
	slotMain.empty			= true
	self.slotMain			= slotMain
	self.slotMain.whereType	= nil
	self.slotMain.slotNo	= nil
	
	for ii = 1, self.config.socketSlotCount do
		slotSocket =
		{
			icon 		= self.control.staticSocket[ii],
			iconBg 		= self.control.staticSocketBackground[ii],
			name	 	= self.control.staticSocketName[ii],
			desc	 	= self.control.staticSocketDesc[ii],
		}
		
		function slotSocket:setShow( bShow )
			self.icon:SetShow( bShow )
			self.iconBg:SetShow( bShow )
			self.name:SetShow( bShow )
			self.desc:SetShow( bShow )
		end
		
		onlySocketListBG[ii]:SetShow( true )
		
		local indexSocket = ii - 1;
		SlotItem.new( slotSocket, 'Socket_' .. ii, ii, Panel_Window_Socket, self.slotConfig )
		slotSocket:createChild()

		slotSocket.icon:addInputEvent( "Mouse_RUp", 		"Socket_SlotRClick(" .. indexSocket .. ")" )
		slotSocket.icon:addInputEvent( "Mouse_LUp", 		"Socket_SlotLClick(" .. indexSocket .. ")" )
		slotSocket.icon:addInputEvent( "Mouse_PressMove", 	"Socket_SlotDrag(" .. indexSocket .. ")" )
		slotSocket.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. ii .. ", \"Socket_Insert\", true)" )
		slotSocket.icon:addInputEvent( "Mouse_Out","Panel_Tooltip_Item_Show_GeneralStatic(" .. ii .. ", \"Socket_Insert\", false)" )

		Panel_Tooltip_Item_SetPosition(ii, slotSocket, "Socket_Insert")
		
		slotSocket.empty = true
		self.slotSocket:push_back( slotSocket )
	end
end

function socket:clearData( uiOnly )
	self.slotMain:clearItem()
	self.slotMain.empty		= true
	self.slotMain.whereType	= nil
	self.slotMain.slotNo	= nil
	self.slotMain.icon:SetShow( false )

	
	for ii = 1, self.config.socketSlotCount do
		--onlySocketListBG[ii]:SetMonoTone( true )

		local socketBG_1 = onlySocketListBG[ii]:addColorAnimation( 0.0, 0.50, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		socketBG_1:SetStartColor( UI_color.C_FFFFFFFF )
		socketBG_1:SetEndColor( UI_color.C_FF626262 )
		
		onlySocketListBG[ii]:EraseAllEffect()
		
		self.slotSocket[ii]:setShow( false )
		self.slotSocket[ii].empty = true
	end

	if not uiOnly then
		getSocketInformation():clearData()
	end
	
	
	
	Panel_Tooltip_Item_hideTooltip()	
end

function socket:registEventHandler()
	-- self.control.buttonClose:addInputEvent( "Mouse_LUp", "Socket_Window_Hide()" )
end

function socket:updateSocket()
	if self.slotMain.empty then
		UI.ASSERT(false, 'Must not be EMPTY!!!!')
		return
	end

	local invenItemWrapper	= getInventoryItemByType(self.slotMain.whereType, self.slotMain.slotNo)
	local maxCount			= invenItemWrapper:get():getUsableItemSocketCount()

	local classType = getSelfPlayer():getClassType()
	for ii = 1, maxCount do
		local socketSlot = self.slotSocket[ii]
		local itemStaticWrapper = invenItemWrapper:getPushedItem( ii - 1 )

		socketSlot:setShow( true )


		onlySocketListBG[ii]:EraseAllEffect()

		if nil == itemStaticWrapper then
			---------------------------------------------------------------------------------------
			-- 						보석 박기 가능한 녀석들을 표시해준다
			---------------------------------------------------------------------------------------
			-- 색 변경
			if ( ii == 1 ) then
				local socketBG_1 = onlySocketListBG[1]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_1:SetStartColor( UI_color.C_FF626262 )
				socketBG_1:SetEndColor( UI_color.C_FFFFFFFF )
				
				onlySocketListBG[2]:SetColor( UI_color.C_FF626262 )
				onlySocketListBG[3]:SetColor( UI_color.C_FF626262 )

			elseif ( ii == 2 ) then
				local socketBG_1 = onlySocketListBG[1]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_1:SetStartColor( UI_color.C_FF626262 )
				socketBG_1:SetEndColor( UI_color.C_FFFFFFFF )
				
				local socketBG_2 = onlySocketListBG[2]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_2:SetStartColor( UI_color.C_FF626262 )
				socketBG_2:SetEndColor( UI_color.C_FFFFFFFF )
				
				onlySocketListBG[3]:SetColor( UI_color.C_FF626262 )
				
			elseif ( ii == 3 ) then
				local socketBG_1 = onlySocketListBG[1]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_1:SetStartColor( UI_color.C_FF626262 )
				socketBG_1:SetEndColor( UI_color.C_FFFFFFFF )
				
				local socketBG_2 = onlySocketListBG[2]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_2:SetStartColor( UI_color.C_FF626262 )
				socketBG_2:SetEndColor( UI_color.C_FFFFFFFF )
				
				local socketBG_3 = onlySocketListBG[3]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_3:SetStartColor( UI_color.C_FF626262 )
				socketBG_3:SetEndColor( UI_color.C_FFFFFFFF )
			end
			
			socketSlot:clearItem()
			socketSlot.empty = true
			socketSlot.name:SetText( self.text[1] )
			socketSlot.desc:SetText( self.desc[1] )
			self.slotMain.icon:AddEffect("UI_ItemJewel", false, 0.0, 0.0)
		else
			---------------------------------------------------------------------------------------
			-- 									보석이 박혀있다!
			---------------------------------------------------------------------------------------
			-- 색 변경
			if ( ii == 1 ) then
				local socketBG_1 = onlySocketListBG[1]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_1:SetStartColor( UI_color.C_FF626262 )
				socketBG_1:SetEndColor( UI_color.C_FFFFFFFF )
				
				onlySocketListBG[2]:SetColor( UI_color.C_FF626262 )
				onlySocketListBG[3]:SetColor( UI_color.C_FF626262 )
				
				-- ♬ 첫번째 보석이 박혀있을 때
				audioPostEvent_SystemUi(05,06)
				onlySocketListBG[1]:AddEffect( "UI_LimitMetastasis_TopLoop", true, -222, 40 )

			elseif ( ii == 2 ) then
				local socketBG_1 = onlySocketListBG[1]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_1:SetStartColor( UI_color.C_FF626262 )
				socketBG_1:SetEndColor( UI_color.C_FFFFFFFF )
				
				local socketBG_2 = onlySocketListBG[2]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_2:SetStartColor( UI_color.C_FF626262 )
				socketBG_2:SetEndColor( UI_color.C_FFFFFFFF )
				
				onlySocketListBG[3]:SetColor( UI_color.C_FF626262 )
				
				-- ♬ 두번째 보석이 박혀있을 때
				audioPostEvent_SystemUi(05,06)
				onlySocketListBG[2]:AddEffect( "UI_LimitMetastasis_MidLoop", true, -217, 0 )
				
			elseif ( ii == 3 ) then
				local socketBG_1 = onlySocketListBG[1]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_1:SetStartColor( UI_color.C_FF626262 )
				socketBG_1:SetEndColor( UI_color.C_FFFFFFFF )
				
				local socketBG_2 = onlySocketListBG[2]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_2:SetStartColor( UI_color.C_FF626262 )
				socketBG_2:SetEndColor( UI_color.C_FFFFFFFF )
				
				local socketBG_3 = onlySocketListBG[3]:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
				socketBG_3:SetStartColor( UI_color.C_FF626262 )
				socketBG_3:SetEndColor( UI_color.C_FFFFFFFF )
				
				-- ♬ 세번째 보석이 박혀있을 때
				audioPostEvent_SystemUi(05,06)
				onlySocketListBG[3]:AddEffect( "UI_LimitMetastasis_BotLoop", true, -212, -30 ) 
			end
			
			socketSlot:setItemByStaticStatus(itemStaticWrapper, 0)
			socketSlot.empty = false
			
			-- 수정의 이름을 박아준다
			local text = itemStaticWrapper:getName()
			local desc = ""
			socketSlot.name:SetText( text )
			
			local jewelSkillStaticWrapper = itemStaticWrapper:getSkillByIdx( classType )		-- 소켓의 스킬정보 받기
			if nil ~= jewelSkillStaticWrapper then

				for buffIdx = 0, jewelSkillStaticWrapper:getBuffCount() - 1 do					-- 버프 카운트
					local descCurrent = jewelSkillStaticWrapper:getBuffDescription( buffIdx )
					
					if ( nil == descCurrent ) or ( "" == descCurrent ) then
						break
					end
					
					if( desc == "" ) then
						desc = descCurrent
					else
						desc = desc.. "\n".. descCurrent
					end
					
				end
			end
			socketSlot.desc:SetText( desc )
		end
	end
	for ii = maxCount + 1, self.config.socketSlotCount do
		local socketSlot = self.slotSocket[ii]
		socketSlot:setShow( false )
	end
end


------------------------------------------------------------------------------
-- 							무기에서 수정 빼버릴때
------------------------------------------------------------------------------
local Socket_Pop_Confirm = function()
	getSocketInformation():handlePopJewelFromSocket(socket._indexSocket, CppEnums.ItemWhereType.eCount, CppEnums.TInventorySlotNoUndefined )
end
------------------------------------------------------------------------------
-- 							무기에 수정을 박았을 때
------------------------------------------------------------------------------
local Socket_Push_Confirm = function()
	local self = socket
	local socketInfo = getSocketInformation()
	local index = socketInfo._indexPush
	local socketSlot = self.slotSocket[index + 1]

	socketSlot.iconBg:AddEffect("UI_ItemJewel02", false, 0, 0 )				-- 아이콘 테두리 이펙트
	socketSlot.desc:AddEffect("UI_ItemJewel03", false, 0, 0 )				-- 전체 테두리 이펙트

	socketSlot.iconBg:AddEffect("fUI_ItemJewel01", false, -1, -1 )			-- 수정장착에 성공하면 아이템과 수정이 같이 빛난다.
	self.slotMain.icon:AddEffect("fUI_ItemJewel01", false, -1, -1 )			-- 수정장착에 성공하면 아이템과 수정이 같이 빛난다.
	
	self.slotMain.icon:AddEffect("UI_LimitMetastasis_Box01", false, -1, -1 )-- 수정장착에 성공하면 아이템에 모이는 느낌
	socketSlot.icon:AddEffect("UI_LimitMetastasis_Box02", false, -1, -1 )	-- 수정장착에 성공하면 수정에서 퍼지는 느낌
	
	Socket_ConfirmPushJewel( true )
	-- 무기에서 소켓 박을때

	if ( index == 0 ) then
		-- ♬ 첫번째 보석을 박을 때
		audioPostEvent_SystemUi(00,07)
		self.slotMain.icon:AddEffect("UI_LimitMetastasis_Top01", false, -1, -1 ) -- 첫번째 수정을 장착하면 나오는 빨간색 라인
	elseif ( index == 1 ) then
		-- ♬ 두번째 보석을 박을 때
		audioPostEvent_SystemUi(00,07)
		self.slotMain.icon:AddEffect("UI_LimitMetastasis_Mid01", false, -1, -1 ) -- 두번째 수정을 장착하면 나오는 초록색 라인
	elseif ( index == 2 ) then
		-- ♬ 세번째 보석을 박을 때
		audioPostEvent_SystemUi(00,07)
		self.slotMain.icon:AddEffect("UI_LimitMetastasis_Bot01", false, -1, -1 ) -- 세번째 수정을 장착하면 나오는 파란색 라인
	end
end


local Socket_OverWrite_Confirm = function()
	local self = socket
	
	local rv = Socket_OverWriteToSocket( self.slotMain.whereType, self.slotMain.slot, self._indexSocket )
	if( 0 ~= rv ) then
		self:clearData()
		Inventory_SetFunctor( Socket_InvenFiler_EquipItem, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil)
	end
end

local Socket_Deny = function()
	Socket_ConfirmPushJewel( false )
--	getSocketInformation():confirmPushJewel(false)
end

-- return true will be grayscale and disable!
local Socket_InvenFiler_EquipItem = function( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end

	-- 소켓이 없으면 true 를 리턴
	return(not itemWrapper:getStaticStatus():get():doHaveSocket())
end

local Socket_InvenFiler_Jewel = function( slotNo, itemWrapper, whereType )
	if nil == itemWrapper then
		return true
	end

	if CppEnums.ItemWhereType.eCashInventory == whereType then
		return true
	end
	
	--return(not itemWrapper:getStaticStatus():get():isPushableToSocket())
	-- 가능하다면 true 임
	local isAble = getSocketInformation():isFilterJewelEquipType( whereType, slotNo )
	return(not isAble )
end

function SocketItem_FromItemWrapper()
	local	self			= socket
	if	( nil == self.slotMain.slotNo )	then
		return(nil)
	end

	return( getInventoryItemByType(self.slotMain.whereType, self.slotMain.slotNo) )
end

function Socket_SlotRClick( indexSocket )
	local self = socket
	
	if( true == self.slotSocket[indexSocket + 1].empty ) then
		return
	end
	
	socket._indexSocket 	= indexSocket
	local titleString 		= PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_TITLE" )
	local contentString 	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_MESSAGE", "socketNum", string.format( "%d", indexSocket+1 ) )
	local messageboxData 	= { title = titleString, content = contentString, functionYes = Socket_Pop_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

------------------------------------------------------------------------------
-- 							슬롯에서 무기를 뺐다!
------------------------------------------------------------------------------
function Socket_EquipSlotRClick( )
	getSocketInformation():popEquip()
	socket:clearData()
	Inventory_SetFunctor( Socket_InvenFiler_EquipItem, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil)
end

function Socket_SlotLClick( indexSocket )
	if DragManager.dragStartPanel ~= Panel_Window_Inventory then
		return
	end

	local self = socket

	local	whereType	= DragManager.dragWhereTypeInfo
	local	slotNo		= DragManager.dragSlotInfo
	local	itemWrapper = getInventoryItemByType( whereType, slotNo )
	if( nil == itemWrapper ) then
		UI.ASSERT( false, 'Item Is Null?!?!?!' )
		return
	end

	local index = indexSocket + 1

	-- 빈곳은 넣고
	if( true == self.slotSocket[index].empty ) then
		local success = ( 0 == Socket_SetItemHaveSocket(whereType, slotNo) )
		if not success then
			--UI.ASSERT( false, 'Socket set FAIL' )
			return
		end

		local titleString = PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_TITLE" )
		local contentString = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_MESSAGE", "socketNum", string.format( "%d", index ), "itemName", itemWrapper:getStaticStatus():getName() )
		local messageboxData = { title = titleString, content = contentString, functionYes = Socket_Push_Confirm, functionCancel = Socket_Deny, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
		return
	else -- 있는 곳은 패스
		local titleString	= PAGetString( Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE" )
		local contentString	= PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_ALREADYCRYSTAL" )
		local messageboxData = { title = titleString, content = contentString, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
	
		-- socket._jewelInvenSlotNo = invenSlotNo
		-- socket._indexSocket = indexSocket
		-- local titleString = PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_CHANGE_TITLE" )
		-- local contentString = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SOCKET_CHANGE_MESSAGE", "socketNum", string.format( "%d", index ), "itemName", itemWrapper:getStaticStatus():getName() )
		-- local messageboxData = { title = titleString, content = contentString, functionYes = Socket_OverWrite_Confirm, functionCancel = Socket_Deny, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		-- MessageBox.showMessageBox(messageboxData)
		return
	end

	DragManager.clearInfo()
end

function Panel_Socket_InteractortionFromInventory( slotNo, itemWrapper, count_s64, inventoryType )
	local self		= socket
	local socketInfo= getSocketInformation()

	-- UI.debugMessage( slotNo )
	local success = (0 == Socket_SetItemHaveSocket(inventoryType, slotNo))
	if not success then
		--UI.ASSERT( false, 'Socket set FAIL' )
		self:clearData()
		Inventory_SetFunctor( Socket_InvenFiler_EquipItem, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil)
		return
	end

	local itemWrapper = getInventoryItemByType( inventoryType, slotNo )
	UI.ASSERT( nil ~= itemWrapper, 'Item Is Null?!?!?!' )
	
	if socketInfo._setEquipItem then
		-- 아이템 세팅
		self.slotMain.empty		= false
		self.slotMain.whereType	= inventoryType
		self.slotMain.slotNo	= slotNo
		self.slotMain:setItem( itemWrapper )
		self.slotMain.icon:SetShow( true )
		self.slotMain.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", 'SocketItem', true)" )
		self.slotMain.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", 'SocketItem', false)" )
		-- UI.debugMessage("EquipItem Set")

		Panel_Tooltip_Item_SetPosition(slotNo, self.slotMain, "SocketItem")
		-- 이미 박혀있는 보석 세팅
		self:updateSocket()

		-- INVENTORY_FILTER ON SOCKET_JEWEL_ITEM
		Inventory_SetFunctor( Socket_InvenFiler_Jewel, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil )
	else
		local rv = socketInfo:checkPushJewelToEmptySoket( inventoryType, slotNo )
		if( 0 == rv ) then
			local index = socketInfo._indexPush
			local titleString = PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_TITLE" )
			local contentString = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_MESSAGE", "socketNum", string.format( "%d", index+1 ), "itemName", itemWrapper:getStaticStatus():getName() )
			local messageboxData = { title = titleString, content = contentString, functionYes = Socket_Push_Confirm, functionCancel = Socket_Deny, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageboxData)
		end
	end
end

function Socket_Result()
	
	if( Panel_Window_Socket:GetShow() ) then
		socket:updateSocket()
	else
		ExtractionCrystal_Result();	
	end

end

--------------------------------------------------------------------------------
--								전이 창 껐다 켰다
--------------------------------------------------------------------------------

local Socket_fadeInSCR_Down = function( panel )
	local FadeMaskAni = panel:addTextureUVAnimation (0.0, 0.28, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI )
	FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)

	FadeMaskAni:SetStartUV ( 0.0, 0.6, 0 )
	FadeMaskAni:SetEndUV ( 0.0, 0.1, 0 )

	FadeMaskAni:SetStartUV ( 1.0, 0.6, 1 )
	FadeMaskAni:SetEndUV ( 1.0, 0.1, 1 )

	FadeMaskAni:SetStartUV ( 0.0, 1.0, 2 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 2 )

	FadeMaskAni:SetStartUV ( 1.0, 1.0, 3 )
	FadeMaskAni:SetEndUV ( 0.0, 0.4, 3 )

	panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)

	local aniInfo3 = panel:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )

	-- 소켓 배경 따로 관리해준다
	for key, value in pairs(onlySocketListBG) do
		local socketBG_1 = value:addColorAnimation( 0.0, 0.50, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		socketBG_1:SetStartColor( UI_color.C_00626262 )
		socketBG_1:SetEndColor( UI_color.C_FF626262 )
	end

	local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )

end


-- 보여주기 애니메이션
function SocketShowAni()
	local aniInfo1 = Panel_Window_Socket:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.13)
	aniInfo1.AxisX = Panel_Window_Socket:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_Socket:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_Socket:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.13)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_Socket:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_Socket:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true

	audioPostEvent_SystemUi(01,00)
end
-- 끄기 애니메이션
function SocketHideAni()
	local socketHide = UIAni.AlphaAnimation( 0, Panel_Window_Socket, 0.0, 0.2 )
	socketHide:SetHideAtEnd(true)
	audioPostEvent_SystemUi(01,01)
end

function Socket_WindowClose()
	-- 꺼준다
	Inventory_SetFunctor( nil , nil, nil, nil )
	Panel_Window_Socket:SetShow( false, false )
	InventoryWindow_Close()
	Equipment_PosLoadMemory()	-- 이전 위치를 불러온다.
	Panel_Equipment:SetShow( false, false )
	ToClient_BlackspiritEnchantClose()
end

function Socket_Window_Show()
	if Panel_Window_Enchant:GetShow() then
		Panel_Window_Enchant:SetShow( false, false )
		-- ToClient_BlackspiritEnchantClose()
	elseif Panel_SkillAwaken:GetShow() then
		Panel_SkillAwaken:SetShow( false, false )
	end
	Panel_Window_Socket:SetShow( true, true )
	
	Inventory_SetFunctor( Socket_InvenFiler_EquipItem, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil )
	socket:clearData()
	InventoryWindow_Show()
	Equipment_PosSaveMemory() -- 이전 위치를 저장한다.
	Panel_Equipment:SetShow(true, true)
	Panel_Equipment:SetPosX(10)
	Panel_Equipment:SetPosY( getScreenSizeY() - (getScreenSizeY()/2) - (Panel_Equipment:GetSizeY()/2) ) -- 모르겠지만, 시간 지연
	SkillAwaken_Close()
	Panel_Join_Close()
	FGlobal_LifeRanking_Close()
	
	-- if false == Panel_Equipment:IsShow() then
	-- 	Panel_Equipment:SetShow(false, false)
	-- end
	-- DefaultEquipmentPosX = Panel_Equipment:GetPosX()
	-- Panel_Equipment:SetPosX(15)
	-- Panel_Equipment:SetShow(true, true)
end

-- 잠재력 전이 SHOW 토글
function Socket_ShowToggle()
	if Panel_Window_Socket:GetShow() then
		Socket_WindowClose()
	else
		Socket_Window_Show()
		InventoryWindow_Show()
	end
end

function Socket_OnScreenEvent()
	local sizeX = getScreenSizeX()
	local sizeY = getScreenSizeY()

	Panel_Window_Socket:SetPosX( (sizeX/2) - (Panel_Window_Socket:GetSizeX()/2) )
	Panel_Window_Socket:SetPosY( sizeY/3.5 )

	Panel_Window_Socket:ComputePos()
end

--------------------------------------------------------------------------------
--									이벤트 함수
--------------------------------------------------------------------------------
function socket:registMessageHandler()
	registerEvent("EventSocketResult", "Socket_Result")
	registerEvent( "onScreenResize", "Socket_OnScreenEvent" )
end

function Socket_GetSlotNo()
	return socket.slotMain.slotNo
end


---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
socket:init()
socket:createControl()
socket:registEventHandler()
socket:registMessageHandler()
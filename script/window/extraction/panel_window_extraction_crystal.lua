-- 보석 추출
Panel_Window_Extraction_Crystal:SetShow(false, false)
Panel_Window_Extraction_Crystal:setMaskingChild(true)
Panel_Window_Extraction_Crystal:setGlassBackground(true)
Panel_Window_Extraction_Crystal:RegisterShowEventFunc( true, 'ExtractionShowAni()' )
Panel_Window_Extraction_Crystal:RegisterShowEventFunc( false, 'ExtractionHideAni()' )

local UI_ANI_ADV                        = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color                          = Defines.Color
local UI_PUCT 							= CppEnums.PA_UI_CONTROL_TYPE
local screenX                           = nil
local screenY                           = nil

Panel_Window_Extraction_Result:SetSize( getScreenSizeX(), getScreenSizeY() )
Panel_Window_Extraction_Result:SetPosX( 0 )
Panel_Window_Extraction_Result:SetPosY( 0 )
Panel_Window_Extraction_Result:SetColor( UI_color.C_00FFFFFF )
Panel_Window_Extraction_Result:SetIgnore(true)
Panel_Window_Extraction_Result:SetShow(false)

local ResultMsgBG	= UI.getChildControl(Panel_Window_Extraction_Result, "Static_Finish")
ResultMsgBG:SetSize( (getScreenSizeX() + 40), 90 )
ResultMsgBG:SetPosX( -20 )
ResultMsgBG:ComputePos()

local ResultMsg		= UI.getChildControl(Panel_Window_Extraction_Result, "StaticText_Finish")
ResultMsg:SetSize( getScreenSizeX(), 90 )
ResultMsg:ComputePos()

-- 보석 추출용
local extractionEquipSocket =
{
	slotConfig =
	{
		createIcon		= false,
		createBorder	= true,
		createCount		= true,
		createEnchant	= true,
		createCash		= true,
	},
	config =
	{
		socketSlotCount = 3,
		curSlotCount = 3
	},
	control =
	{
		staticEnchantItem = UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_ExtractionEquip_Socket" ),
		
		staticSocket =
		{
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_Socket_1" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_Socket_2" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_Socket_3" ),
		},
		
		staticSocketName =
		{
			UI.getChildControl( Panel_Window_Extraction_Crystal, "StaticText_NameTag_1" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "StaticText_NameTag_2" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "StaticText_NameTag_3" ),
		},
		
		staticSocketDesc =
		{
			UI.getChildControl( Panel_Window_Extraction_Crystal, "StaticText_List_1" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "StaticText_List_2" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "StaticText_List_3" ),
		},
		
		staticSocketBackground =
		{
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_Socket_1_Background" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_Socket_2_Background" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_Socket_3_Background" ),
		},

		staticSocketExtractionButton =
		{
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Button_Extraction_Socket_1" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Button_Extraction_Socket_2" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Button_Extraction_Socket_3" ),
		},

		staticStuffSlotBG =
		{
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_StuffSlot_1_Background" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_StuffSlot_2_Background" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_StuffSlot_3_Background" ),
		},

		staticStuffSlot =
		{
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_StuffSlot_1" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_StuffSlot_2" ),
			UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_StuffSlot_3" ),
		},
		

	},
	
	text =
	{
		[1] = PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_EMPTYSLOT" ),
	},
	desc =
	{
		[1] = PAGetString( Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_SLOT_EMPTY" ),
	},
	
	ExtractionEquipMain = nil,
	slotSocket = Array.new(),
	slotExtractionMaterial = Array.new(),
	_indexSocket,
	_extractionType,
	_jewelInvenSlotNo,
	
	-- 흑정령의 정수 인벤 타입과 슬롯 넘버
	_stuffInvenType,
	_stuffSlotNo,
	
	_extractionGuide			= UI.getChildControl ( Panel_Window_Extraction_Crystal, "Static_ExtractionGuide" ),	-- 설명
	_enchantNumber				= UI.getChildControl ( Panel_Window_Extraction_Crystal, "StaticText_Enchant_value" ),
}

extractionEquipSocket._enchantNumber:SetShow( false )

local onlySocketListBG =
{
	[1] = UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_SocketBG_0" ),
	[2] = UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_SocketBG_1" ),
	[3] = UI.getChildControl( Panel_Window_Extraction_Crystal, "Static_SocketBG_2" ),
}

local ExtractionUse_Slot = { [1] = false, [2] = false, [3] = false }
local tmp_ExtractionMateria_Slot_status = 0
local save_ExtractionMateria_Slot_status = 0

local 	_buttonQuestion = UI.getChildControl( Panel_Window_Extraction_Crystal, "Button_Question" )			-- 물음표 버튼
	_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowExtractionCrystal\" )" )									-- 물음표 좌클릭
	_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowExtractionCrystal\", \"true\")" )				-- 물음표 마우스오버
	_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowExtractionCrystal\", \"false\")" )				-- 물음표 마우스아웃

-- 초기화
function extractionEquipSocket:init()
	for _, control in ipairs(self.control.staticSocketName) do
		control:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap ) -- Auto Wrap
	end
	for _, control in ipairs(self.control.staticSocketDesc) do
		control:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap ) -- Auto Wrap
	end
	self._extractionGuide:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )											-- 흑정령 정수
	self._extractionGuide:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACTIONGUIDE") )			-- 설명( <PAColor0xFFDB2B2B>  ※ 수정을 추출하기 위해서는 흑정령의 정수가 필요합니다.<PAOldColor> )

end

-- 수정 추출 UI 만들기
function extractionEquipSocket:createControl()
	local ExtractionEquipMain = {}
	ExtractionEquipMain.icon = self.control.staticEnchantItem
	SlotItem.new( ExtractionEquipMain, 'ExtractionEquip_Socket', 0, Panel_Window_Extraction_Crystal, self.slotConfig )
	ExtractionEquipMain:createChild()
	ExtractionEquipMain.icon:addInputEvent( "Mouse_RUp", "Socket_ExtractionCrystalEquipSlotRClick()" )
	Panel_Tooltip_Item_SetPosition(0, ExtractionEquipMain, "Socket")
	
	CopyBaseProperty( self._enchantNumber, ExtractionEquipMain.enchantText )
	ExtractionEquipMain.enchantText:SetSize( ExtractionEquipMain.icon:GetSizeX(), ExtractionEquipMain.icon:GetSizeY() )
	ExtractionEquipMain.enchantText:SetPosX( 0 )
	ExtractionEquipMain.enchantText:SetPosY( 0 )
	ExtractionEquipMain.enchantText:SetTextHorizonCenter()
	ExtractionEquipMain.enchantText:SetTextVerticalCenter()
	ExtractionEquipMain.enchantText:SetShow( true )

	ExtractionEquipMain.empty = true
	self.ExtractionEquipMain = ExtractionEquipMain
	self.ExtractionEquipMain.slotNo = - 1

	local slot_ExtractionMaterial = {}
	
	for ii = 1, self.config.socketSlotCount do
		slotSocket =
		{
			icon            = self.control.staticSocket[ii],
			iconBg          = self.control.staticSocketBackground[ii],
			name            = self.control.staticSocketName[ii],
			desc            = self.control.staticSocketDesc[ii],
			extraction_button   = self.control.staticSocketExtractionButton[ii],
			staticStuffSlotBG   = self.control.staticStuffSlotBG[ii],
		}

		function slotSocket:setShow( bShow )
			self.icon:SetShow( bShow )
			self.iconBg:SetShow( bShow )
			self.name:SetShow( bShow )
			self.desc:SetShow( bShow )
			self.extraction_button:SetShow( bShow )
			self.staticStuffSlotBG:SetShow( bShow )
		end
		
		slotSocket.name:SetText( "" )
		slotSocket.desc:SetText( "" )

		onlySocketListBG[ii]:SetShow( true )
		-- onlySocketListBG[ii]:SetMonoTone( true )
		
		local indexSocket = ii - 1;
		SlotItem.new( slotSocket, 'Socket_' .. ii, ii, Panel_Window_Extraction_Crystal, self.slotConfig )
		slotSocket:createChild()

		slotSocket.icon:addInputEvent( "Mouse_RUp",	"Panel_Socket_ExtractionCrystal_DeleteCrystal( " .. indexSocket .. " )" )
		slotSocket.icon:addInputEvent( "Mouse_On",	"Panel_Tooltip_Item_Show_GeneralStatic(" .. ii .. ", \"Socket_Insert\", true)" )
		slotSocket.icon:addInputEvent( "Mouse_Out",	"Panel_Tooltip_Item_Show_GeneralStatic(" .. ii .. ", \"Socket_Insert\", false)" )

		-- 추출 버튼이다.
		slotSocket.extraction_button:addInputEvent( "Mouse_LUp", "DoExtractionCrystal_SlotRClick(" .. indexSocket .. ")" )
		slotSocket.empty = true
		self.slotSocket:push_back( slotSocket )

		-- 재료 슬롯 관련
		slot_ExtractionMaterial = 
		{
			staticStuffSlot   = self.control.staticStuffSlot[ii]
		}		
		SlotItem.new( slot_ExtractionMaterial, 'CreateStuffSlot_' .. ii, ii, Panel_Window_Extraction_Crystal, self.slotConfig )
		slot_ExtractionMaterial:createChild()
		slot_ExtractionMaterial.empty = true
		self.slotExtractionMaterial:push_back( slot_ExtractionMaterial )
	end
end

-- 인벤 필터 : 수정 추출 > 수정이 장착된 장비
function Socket_Extraction_InvenFiler_EquipItem( slotNo, itemWrapper, WhereType )
	if nil == itemWrapper then
		return true
	end
	local invenItemWrapper = getInventoryItemByType( WhereType, slotNo)
	local maxCount = itemWrapper:get():getUsableItemSocketCount()
	local blankSlot_Count = maxCount
	for sock_idx = 1, maxCount, 1 do
		local itemStaticWrapper = itemWrapper:getPushedItem( sock_idx - 1 )
		if nil == itemStaticWrapper then
			blankSlot_Count = blankSlot_Count - 1
		end
	end
	-- 소켓이 없고, 보석이 안 박혀있으면 true 를 리턴
	return not ( itemWrapper:getStaticStatus():get():doHaveSocket() and  (0 ~= blankSlot_Count) )
end

-- 인벤 필터 : 수정 추출 > 장비 장착 > 재료(현재는 수정인데 재료로 바꿔야 함)
function Socket_Extraction_InvenFiler_Stuff ( slotNo, itemWrapper, whereType )
	if nil == itemWrapper then
		return true
	end
	
	-- 가능하다면 true 임
	local isAble = getSocketInformation():isExtractionSource( whereType, slotNo )
	return(not isAble )
end


-- 수정 추출, 인벤 필터에서 우클릭용
function Panel_Socket_ExtractionCrystal_InteractortionFromInventory( slotNo, itemWrapper, count_s64, inventoryType )
	local self = extractionEquipSocket
	local socketInfo = getSocketInformation()
	local success = (0 == Socket_SetItemHaveSocket(inventoryType, slotNo))

	if not success then
		--UI.ASSERT( false, 'Socket set FAIL' )
		self:clearData()
		Inventory_SetFunctor( Socket_Extraction_InvenFiler_EquipItem, Panel_Socket_ExtractionCrystal_InteractortionFromInventory, Socket_ExtractionCrystal_WindowClose, nil)
		return
	end

	local itemWrapper = getInventoryItemByType( inventoryType, slotNo ) -- getInventoryItem( slotNo )

	UI.ASSERT( nil ~= itemWrapper, 'Item Is Null?!?!?!' )

	if socketInfo._setEquipItem then
		-- 아이템 세팅
		self.ExtractionEquipMain.empty			= false
		self.ExtractionEquipMain.slotNo			= slotNo
		self.ExtractionEquipMain.invenType		= inventoryType
		self.ExtractionEquipMain:setItem( itemWrapper )
		self.ExtractionEquipMain.icon:SetShow( true )
		self.ExtractionEquipMain.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", 'SocketItem', true)" )
		self.ExtractionEquipMain.icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", 'SocketItem', false)" )

		Panel_Tooltip_Item_SetPosition(slotNo, self.ExtractionEquipMain, "SocketItem")
		-- 이미 박혀있는 보석 세팅
		self:updateSocket()

		-- 장비 선택 후 필터 걸기
		Inventory_SetFunctor( Socket_Extraction_InvenFiler_Stuff, Click_ExtractionCrystal_Stuff, Socket_ExtractionCrystal_WindowClose, nil )

	else
		local rv = socketInfo:checkPushJewelToEmptySoket( slotNo )
		if( 0 == rv ) then
			local index = socketInfo._indexPush
			local titleString = PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_TITLE" )
			local contentString = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_MESSAGE", "socketNum", string.format( "%d", index+1 ), "itemName", itemWrapper:getStaticStatus():getName() )
			local messageboxData = { title = titleString, content = contentString, functionYes = Socket_Push_Confirm, functionCancel = Socket_Deny, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageboxData)
		end
	end
end


-- 흑정령의  정수 우클릭 함수.
function Click_ExtractionCrystal_Stuff( slotNo, itemWrapper, count_s64, inventoryType )
	local self = extractionEquipSocket
	local socketInfo = getSocketInformation()
	
	local invenItemWrapper	= getInventoryItemByType( self.ExtractionEquipMain.invenType,  self.ExtractionEquipMain.slotNo)
	local maxCount			= invenItemWrapper:get():getUsableItemSocketCount()

	local _IsMaterial = socketInfo:isExtractionSource( inventoryType, slotNo )
	local itemWrapper = getInventoryItemByType( inventoryType, slotNo )
	UI.ASSERT( nil ~= itemWrapper, 'Item Is Null?!?!?!' )

	-- 생성된 슬롯의 위치
	local slotExtractionMaterial_Pos = {
		[1] = { ["X"] = 397, ["Y"] = 58 },
		[2] = { ["X"] = 397, ["Y"] = 133 },
		[3] = { ["X"] = 397, ["Y"] = 208 }
		}

	if _IsMaterial then	-- 선택한 것이 추출 재료인가? bool
		-- 보석이 있는 곳에 꼽힌다.
		
		self._stuffSlotNo = slotNo
		self._stuffInvenType = inventoryType
		
		for ii = 1, maxCount do
			if (true == ExtractionUse_Slot[ii]) then
				self.slotExtractionMaterial[ii]:setItem( itemWrapper )
				self.control.staticStuffSlot[ii]:SetShow(true)
				self.slotExtractionMaterial[ii].icon:SetPosX( slotExtractionMaterial_Pos[ii]["X"] )
				self.slotExtractionMaterial[ii].icon:SetPosY( slotExtractionMaterial_Pos[ii]["Y"] )
				self.control.staticSocketExtractionButton[ii]:SetShow(true)
				self.control.staticSocketExtractionButton[ii]:SetIgnore(false)
				self.control.staticSocketExtractionButton[ii]:SetMonoTone(false)
			else
				self.control.staticStuffSlot[ii]:SetShow(false)
				self.control.staticSocketExtractionButton[ii]:SetShow(false)
				self.control.staticSocketExtractionButton[ii]:SetIgnore(true)
				self.control.staticSocketExtractionButton[ii]:SetMonoTone(true)
			end
		end		
		self:updateSocket()	-- 갱신
	end
end

function Panel_Socket_ExtractionCrystal_DeleteCrystal( indexSocket )
	local self = extractionEquipSocket
	
	if( true == self.slotSocket[indexSocket + 1].empty ) then
		return
	end

	local delete_crystal_do = function()
		getSocketInformation():handlePopJewelFromSocket( indexSocket, CppEnums.ItemWhereType.eCount, CppEnums.TInventorySlotNoUndefined )
	end
	self._extractionType	= 1
	local titleString 		= PAGetString( Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_TITLE" )
	local contentString 	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_MESSAGE", "socketNum", string.format( "%d", indexSocket+1 ) )
	local messageboxData 	= { title = titleString, content = contentString, functionYes = delete_crystal_do, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end


function extractionEquipSocket:updateSocket()
	if self.ExtractionEquipMain.empty then
		UI.ASSERT(false, 'Must not be EMPTY!!!!')
		return
	end

	local invenItemWrapper = getInventoryItemByType(self.ExtractionEquipMain.invenType, self.ExtractionEquipMain.slotNo)
	local maxCount = invenItemWrapper:get():getUsableItemSocketCount()

	-- 추출을 한 흔적이 있으면, 초기화 시킨다.
	if 0 ~= save_ExtractionMateria_Slot_status then
		for ii = 1, maxCount do
			self.slotExtractionMaterial[ii]:clearItem()
			self.control.staticStuffSlot[ii]:SetShow(false)
			self.control.staticSocketExtractionButton[ii]:SetShow(false)
			self.control.staticSocketExtractionButton[ii]:SetIgnore(true)
			self.control.staticSocketExtractionButton[ii]:SetMonoTone(true)
		end
	end
	save_ExtractionMateria_Slot_status = 0

	local classType = getSelfPlayer():getClassType()
	for ii = 1, maxCount do

		local socketSlot = self.slotSocket[ii]
		local itemStaticWrapper = invenItemWrapper:getPushedItem( ii - 1 )
		socketSlot:setShow( true )

		onlySocketListBG[ii]:EraseAllEffect()

		if nil == itemStaticWrapper then
			---------------------------------------------------------------------------------------
			--                      보석 박기 가능한 녀석들을 표시해준다
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
			self.ExtractionEquipMain.icon:AddEffect("UI_ItemJewel", false, 0.0, 0.0)
			
			ExtractionUse_Slot[ii] = false
		else
			---------------------------------------------------------------------------------------
			--                                  보석이 박혀있다!
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
				onlySocketListBG[1]:AddEffect( "UI_LimitMetastasis_TopLoop", true, -217, 40 )

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
			
			local jewelSkillStaticWrapper = itemStaticWrapper:getSkillByIdx( classType )        -- 소켓의 스킬정보 받기
			if nil ~= jewelSkillStaticWrapper then

				for buffIdx = 0, jewelSkillStaticWrapper:getBuffCount() - 1 do                  -- 버프 카운트
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
				ExtractionUse_Slot[ii] = true
			end

			socketSlot.desc:SetText( desc )

		end

	end
	for ii = maxCount + 1, self.config.socketSlotCount do
		local socketSlot = self.slotSocket[ii]
		socketSlot:setShow( false )
	end
end

function ExtractionCrystal_Result()
	ExtractionCrystal_resultShow()
	extractionEquipSocket:updateSocket()
end

--추출 확인창 승인
local ExtractionCrystal_Pop_Confirm = function()
	
	save_ExtractionMateria_Slot_status = 1
	
	local self = extractionEquipSocket;
	
	getSocketInformation():handlePopJewelFromSocket(extractionEquipSocket._indexSocket, self._stuffInvenType, self._stuffSlotNo )
end


-- 데이터를 초기화 한다.
function extractionEquipSocket:clearData( uiOnly )
	self.ExtractionEquipMain:clearItem()
	self.ExtractionEquipMain.empty = true
	self.ExtractionEquipMain.slotNo = - 1
	self.ExtractionEquipMain.icon:SetShow( false )
	
	for ii = 1, self.config.socketSlotCount do
		local socketBG_1 = onlySocketListBG[ii]:addColorAnimation( 0.0, 0.50, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		socketBG_1:SetStartColor( UI_color.C_FFFFFFFF )
		socketBG_1:SetEndColor( UI_color.C_FF626262 )
		
		onlySocketListBG[ii]:EraseAllEffect()
		
		self.slotSocket[ii]:setShow( false )
		self.slotSocket[ii].empty = true

		self.slotExtractionMaterial[ii]:clearItem()
		self.control.staticStuffSlot[ii]:SetShow(false)
		self.control.staticStuffSlot[ii].empty = true
		self.control.staticSocketExtractionButton[ii]:SetShow(false)
		self.control.staticSocketExtractionButton[ii]:SetIgnore(true)
		self.control.staticSocketExtractionButton[ii]:SetMonoTone(true)
	end

	if not uiOnly then
		getSocketInformation():clearData()
	end

	self._stuffInvenType 	= -1;
	self._stuffSlotNo		= -1; 
	
	Panel_Tooltip_Item_hideTooltip()    
end

function Socket_ExtractionCrystal_Show( isShow )
	if( isShow ) then
		extractionEquipSocket:clearData();
		Panel_Window_Extraction_Crystal:SetShow(true, true)
		Panel_Window_Extraction_Crystal:SetPosY( getScreenSizeY() - ( getScreenSizeY() / 2 ) - ( Panel_Window_Extraction_Crystal:GetSizeY() / 2 ) - 20 )
		Panel_Window_Extraction_Crystal:SetPosX( getScreenSizeX() - ( getScreenSizeX() / 2 ) - ( Panel_Window_Extraction_Crystal:GetSizeX() / 2 ))
	else
		Socket_ExtractionCrystal_WindowClose()
	end
end

function Socket_ExtractionCrystal_WindowClose()
	-- 꺼준다
	Inventory_SetFunctor( nil )
	Panel_Window_Extraction_Crystal:SetShow(false, false)
	extractionEquipSocket:clearData()
end

function Socket_ExtractionCrystalEquipSlotRClick( )
	getSocketInformation():popEquip()
	extractionEquipSocket:clearData()
	Inventory_SetFunctor( Socket_Extraction_InvenFiler_EquipItem, Panel_Socket_ExtractionCrystal_InteractortionFromInventory, Socket_ExtractionCrystal_WindowClose, nil )
end

function DoExtractionCrystal_SlotRClick( indexSocket )
	
	local self = extractionEquipSocket
	if( true == self.slotSocket[indexSocket + 1].empty ) then
		return
	end

	self._indexSocket     	= indexSocket
	self._extractionType	= 0
	local titleString       = PAGetString( Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACT" )
	local contentString     = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SOCKET_EXTRACTION_MESSAGE", "socketNum", string.format( "%d", indexSocket+1 ) )
	local messageboxData    = { title = titleString, content = contentString, functionYes = ExtractionCrystal_Pop_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

local  ResultMsg_ShowTime = 0
function ExtractionCrystal_resultShow()
	local self = extractionEquipSocket
	if false == Panel_Window_Extraction_Result:GetShow() then
		Panel_Window_Extraction_Result:SetShow(true)
		if 0 == self._extractionType then
			ResultMsg:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACT_DONE" ) )
		else
			ResultMsg:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_REMOVE_DONE" ) )
		end
		ExtractionResult_TimerReset()
	end
end

function FGlobal_ExtractionCrystal_ClearData()
	extractionEquipSocket:clearData()
end

function Socket_ExtractionCrysta_GetSlotNo()
	return socket.ExtractionEquipMain.slotNo
end


extractionEquipSocket:init()
extractionEquipSocket:createControl()
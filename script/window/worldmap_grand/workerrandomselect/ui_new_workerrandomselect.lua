local IM 			= CppEnums.EProcessorInputMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local ENT 			= CppEnums.ExplorationNodeType
local UI_color 		= Defines.Color
local UI_TYPE		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM 		= CppEnums.TextMode
local VCK 			= CppEnums.VirtualKeyCode

Panel_Window_WorkerRandomSelect:ActiveMouseEventEffect( true )
Panel_Window_WorkerRandomSelect:setGlassBackground( true )

local _selectSlotNo = -1

local _selectWorkPrice = 0

local panelBG	= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "Static_WorkerRandomSelectBG" )		-- 패널 배경
panelBG:ActiveMouseEventEffect( true )
panelBG:setGlassBackground( true )
	
local _workerPicture 			= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "Static_WorkerPicture" )		-- 일꾼 사진

-- value 값
-- local _workerValue 				= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_WorkerPrice" )		-- 일꾼의 가치
local _workerActionCount		= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_ActionValue" )		-- 행동력
local _workerMoveSpeed 			= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_MoveSpeedValue" )	-- 이속
local _workerWorkingSpeed 		= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_WorkSpeedValue" )	-- 작업 속도
local _workerLucky				= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_LuckyValue" )		-- 행운
local _workerPrice				= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_WorkerPriceValue" ) -- 일꾼 가격
local _workerRandomName			= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_WokerRandomSelectName1" )	-- 일꾼 이름
local _workerLevel				= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_Lev" )	-- 일꾼 레벨

local _workerCountEmployment	= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_WorkerEmployment" )	-- 현재 고용 가능한 일꾼
local _workerCountValue			= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_WorkerEmploymentValue")  -- 현재 고용 가능한 일꾼 수 
-- _workerCountEmployment:SetShow( false )

local _workerInventoryMoney				= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_MyMoney" )		-- 보유 금액
local _workerWareHouseInventoryMoney 	= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "StaticText_MyWareHouseMoney" )		-- 창고 금액

local _workerButtonReSelect		= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "Button_WorkerReSelect" )					-- 다시 뽑기
local _workerButtonSelect		= UI.getChildControl ( Panel_Window_WorkerRandomSelect, "Button_WorkerSelect" )						-- 일꾼 고용하기

local _workerInventoryMoneyButton			= UI.getChildControl( Panel_Window_WorkerRandomSelect, "RadioButton_InventoryMoney" ) -- 인벤토리 소지 금액
local _workerWareHouseInventoryMoneyButton	= UI.getChildControl( Panel_Window_WorkerRandomSelect, "RadioButton_WareHouseMoney" ) -- 창고 소지 금액

_workerInventoryMoneyButton:SetCheck( true )
_workerInventoryMoneyButton:SetEnableArea( 0, 0, 300, _workerInventoryMoneyButton:GetSizeY() )
_workerWareHouseInventoryMoneyButton:SetCheck( false )
_workerWareHouseInventoryMoneyButton:SetEnableArea( 0, 0, 300, _workerWareHouseInventoryMoneyButton:GetSizeY() )

function workerRandomShopShow( workerShopSlotNo )
	local sellCount = npcShop_getBuyCount()

	local selfPlayer = getSelfPlayer()
	local pcPosition = selfPlayer:get():getPosition()
	local regionInfo = getRegionInfoByPosition(pcPosition)
	local MyWp = selfPlayer:getWp()

	local regionPlantKey = regionInfo:getPlantKeyByWaypointKey()
	local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(regionPlantKey, 0)
	local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(regionPlantKey)

	for ii = 0, sellCount - 1 do
		local itemwrapper = npcShop_getItemBuy(ii)			-- 고용일꾼은 현재 하나의 캐릭터만 구매할 수 있다.
		local shopItem = itemwrapper:get()

		--_PA_LOG( "EEE", "shopItem.shopSlotNo : " .. tostring ( shopItem.shopSlotNo ) )
		if workerShopSlotNo == shopItem.shopSlotNo then
			_selectSlotNo		= shopItem.shopSlotNo
			_selectWorkPrice	= shopItem.price_s64
			plantWorkerSS		= itemwrapper:getPlantWorkerStaticStatus()
			efficiency			= plantWorkerSS:getEfficiency( 2, ItemExchangeKey(0) )

			local plantWorkerGrade = plantWorkerSS:getCharacterStaticStatus()._gradeType:get()	-- 일꾼 등급 구하기 (0, 1, 2, 3......)
			
			if ( CppEnums.CharacterGradeType.CharacterGradeType_Normal == plantWorkerGrade ) then
				workerColorSet = "<PAColor0xffc4bebe>"
			elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Elite == plantWorkerGrade ) then
				workerColorSet = "<PAColor0xFF5DFF70>"
			elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Hero == plantWorkerGrade ) then
				workerColorSet = "<PAColor0xFF4B97FF>"
			elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Legend == plantWorkerGrade ) then
				workerColorSet = "<PAColor0xFFFFC832>"
			elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Boss == plantWorkerGrade ) then
				workerColorSet = "<PAColor0xFFFF6C00>"
			elseif ( CppEnums.CharacterGradeType.CharacterGradeType_Assistant == plantWorkerGrade ) then
				workerColorSet = "<PAColor0xffc4bebe>"
			else
				workerColorSet = "<PAColor0xffc4bebe>"
			end
			
			if nil ~= plantWorkerSS then
				local workerIconPath = getWorkerIcon( plantWorkerSS )
				_workerPicture:ChangeTextureInfoName(workerIconPath)
				_workerActionCount:SetText( plantWorkerSS._actionPoint )
				_workerLucky:SetText( plantWorkerSS._luck / 10000 )
				_workerMoveSpeed:SetText( plantWorkerSS._moveSpeed / 100 )
				_workerWorkingSpeed:SetText( efficiency / 1000000 )
				_workerPrice:SetText( makeDotMoney(shopItem.price_s64) )
				_workerRandomName:SetText( workerColorSet .. getWorkerName( plantWorkerSS ) .. "<PAOldColor>" )
				local myInvenMoney		= Int64toInt32(selfPlayer:get():getInventory():getMoney_s64())
				local myWareHouseMoney	= Int64toInt32(warehouse_moneyFromNpcShop_s64())
				
				_workerInventoryMoney:SetText( makeDotMoney( myInvenMoney ) )
				_workerWareHouseInventoryMoney:SetText( makeDotMoney( myWareHouseMoney ) )

				--_PA_LOG( "BBB", "myInvenMoney : " .. tostring( myInvenMoney ) .. "myWareHouseMoney : " .. tostring( myWareHouseMoney ) .. "region._waypointKey : " .. tostring(region._waypointKey) .. "waitWorkerCount : " .. waitWorkerCount .. " / " .. maxWorkerCount )
			end				
		end
	end

	_workerCountValue:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORKERRANDOMSELECT_WORKERCOUNTVALUE", "value", maxWorkerCount - waitWorkerCount ) ) -- maxWorkerCount - waitWorkerCount .. " 명" ) -- 고용 가능한 일꾼 수
	--_PA_LOG( "AAA", "sellCount : " .. sellCount .. " name : " .. itemStatus:getName() .. "plantWorkerSS:_actionPoint : " .. plantWorkerSS._actionPoint ) -- .. "shopItem._contentsEventParam1 : " .. shopItem._contentsEventParam1
	if MyWp < 10 then
		_workerButtonReSelect:SetEnable( false )
		_workerButtonReSelect:SetMonoTone( true )
	else
		_workerButtonReSelect:SetEnable( true )
		_workerButtonReSelect:SetMonoTone( false )
	end

	workerRandomSelectShow()
end

-- 일꾼 상점 열기
function workerRandomSelectShow()
	Panel_Window_WorkerRandomSelect:SetShow( true )
end

function workerRandomSelectHide()
	Panel_Window_WorkerRandomSelect:SetShow( false )
end

-- 일꾼 랜덤 다시 돌리기
function click_WorkerReSelect()
	local pcPosition = getSelfPlayer():get():getPosition()
	local regionInfo = getRegionInfoByPosition(pcPosition)
	
	local region = regionInfo:get()

	local regionPlantKey = regionInfo:getPlantKeyByWaypointKey()
	local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(regionPlantKey, 0)
	local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(regionPlantKey)

	if waitWorkerCount == maxWorkerCount then
		local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_ReSelect"), content = PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ" ),  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox( messageboxData )
		return
	end


	local contentString	= PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_ReSelect_Question") .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORKERRANDOMSELECT_NOWWP", "getWp", getSelfPlayer():getWp() ) -- "\n현재 기운 : " .. getSelfPlayer():getWp()

	local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_ReSelect"), content = contentString, functionYes = Worker_RequestShopList,  functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox( messageboxData )
end

-- 다시 요청한다는 것은 상점을 다시 열도록 하자
function Worker_RequestShopList()
	local myWp = getSelfPlayer():getWp()

	if myWp < 5 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORKERRANDOMSELECT_SHORTAGE_WP_ACK") ) -- "기운이 부족합니다." )
		workerRandomSelectHide()
	else
		npcShop_requestList( CppEnums.ContentsType.Contents_Shop )
		if myWp < 5 then -- 일꾼뽑기 창을 띄울때 소모되는 wp가 소모된채로 오지 않고 그대로 넘어와서 +5한 수치로 계산하였음.
			_workerButtonReSelect:SetEnable( false )
			_workerButtonReSelect:SetMonoTone( true )
		else
			_workerButtonReSelect:SetEnable( true )
			_workerButtonReSelect:SetMonoTone( false )
		end
	end
end

-- 선택한 아이템을 구매 요청하자
function click_WorkerSelect()
	local selfPlayer		= getSelfPlayer()
	local myInvenMoney		= selfPlayer:get():getInventory():getMoney_s64()
	local myWareHouseMoney	= warehouse_moneyFromNpcShop_s64()

	-- 일꾼 가격이 내 가방 보유 은화나 창고 보유은화보다 크면 구입을 막는다.
	if (myInvenMoney < _selectWorkPrice and _workerInventoryMoneyButton:IsCheck()) or (myWareHouseMoney < _selectWorkPrice and _workerWareHouseInventoryMoneyButton:IsCheck()) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_ACK_MAKEBOOK") ) -- 보유 은화가 부족합니다.
	else
		local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_Employ"), content = PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_Employ_Question"), functionYes = Worker_RequestDoBuy,  functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox( messageboxData )
	end
end

function Worker_RequestDoBuy()
	local	fromWhereType	= 0
	if( _workerWareHouseInventoryMoneyButton:IsCheck() )	then
		fromWhereType	= 2
	end

	npcShop_doBuy( _selectSlotNo, 1, fromWhereType, 0 )
	
	Panel_MyHouseNavi_Update(true)
	-- if 0 == rv then
	_selectSlotNo = -1
	Panel_Window_WorkerRandomSelect:SetShow( false )
	-- end
	-- Panel_Window_WorkerRandomSelect:SetShow( false )
	--FGlobal_HideDialog()
end

function workerShop_GuildCheckByBuy()
	local isPass = true
	local myGuildInfo	= ToClient_GetMyGuildInfoWrapper()
	if( nil == myGuildInfo ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_NPCSHOP_GUILD1") )-- "길드가 없습니다.")
		isPass = false
	end
	local guildGrade	= myGuildInfo:getGuildGrade()
	if 0 == guildGrade then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_NPCSHOP_GUILD2") )-- "길드 등급만 이용할 수 있습니다.")
		isPass = false
	end
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()

	if not isGuildMaster and not isGuildSubMaster then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_NPCSHOP_GUILD3") )-- "길드 대장 혹은 부대장만 이용할 수 있습니다.")
		isPass = false
	end

	return isPass
end

function workerShop_registEventHandler()
	_workerButtonReSelect					:addInputEvent( "Mouse_LUp", "click_WorkerReSelect()" )
	_workerButtonSelect						:addInputEvent( "Mouse_LUp", "click_WorkerSelect()" )
	_workerInventoryMoneyButton				:addInputEvent(	"Mouse_LUp",	"WorkerShop_CheckFromMoney( 0 )" )
	_workerWareHouseInventoryMoneyButton	:addInputEvent(	"Mouse_LUp",	"WorkerShop_CheckFromMoney( 1 )" )

	_workerInventoryMoneyButton				:addInputEvent( "Mouse_On", "workerShop_SimpleTooltips( 0, true )")
	_workerInventoryMoneyButton				:addInputEvent( "Mouse_Out", "workerShop_SimpleTooltips( false )")
	_workerWareHouseInventoryMoneyButton	:addInputEvent( "Mouse_On", "workerShop_SimpleTooltips( 1, true )")
	_workerWareHouseInventoryMoneyButton	:addInputEvent( "Mouse_Out", "workerShop_SimpleTooltips( false )")

	_workerInventoryMoneyButton				:setTooltipEventRegistFunc("workerShop_SimpleTooltips( 0, true )")
	_workerWareHouseInventoryMoneyButton	:setTooltipEventRegistFunc("workerShop_SimpleTooltips( 1, true )")
end

function	WorkerShop_CheckFromMoney( check )
	if(	0 == check)	then
		if	( _workerInventoryMoneyButton:IsCheck() )	then
			_workerWareHouseInventoryMoneyButton:SetCheck(false)
		else
			_workerWareHouseInventoryMoneyButton:SetCheck(true)
		end
	else
		if( _workerWareHouseInventoryMoneyButton:IsCheck() )	then
			_workerInventoryMoneyButton:SetCheck(false)
		else
			_workerInventoryMoneyButton:SetCheck(true)
		end
	end
end

function workerShop_SimpleTooltips( tipType, isShow )
	local name, desc, control = nil, nil, nil

	if 0 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_DESC")
		control = _workerInventoryMoneyButton
	elseif 1 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_WAREHOUSE_DESC")
		control = _workerWareHouseInventoryMoneyButton
	end

	if isShow == true then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function FromClient_EventRandomShopShow_Worker( shoType, slotNo )
	-- local dialogData = ToClient_GetCurrentDialogData()
	-- if (nil == dialogData) then
	-- 	return
	-- end

	-- local shopType = dialogData:getShopType()
	
	-- 7 : 일꾼 상점	12 : 랜덤 상점	-- ... 으흠...
	if 7 == shoType then
		workerRandomShopShow( slotNo )
	end
end

-- registerEvent("FromClient_InventoryUpdate",				"WorkerShop_MoneyUpdate")
-- registerEvent("EventWarehouseUpdate",					"WorkerShop_MoneyUpdate")
registerEvent("FromClient_EventRandomShopShow", "FromClient_EventRandomShopShow_Worker")
workerShop_registEventHandler()
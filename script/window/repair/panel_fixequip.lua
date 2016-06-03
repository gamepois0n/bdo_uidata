local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM			= CppEnums.TextMode

Panel_FixEquip:setMaskingChild(true)
Panel_FixEquip:RegisterShowEventFunc( true, 'FixEquip_ShowAni()' )
Panel_FixEquip:RegisterShowEventFunc( false, 'FixEquip_HideAni()' )

-- Panel_FixEquip:SetShow( true )		--삭제해야함 테스트용

-- local _enchantEffect 			= UI.getChildControl ( Panel_FixEquip, "Static_AddEffect" )

local fixEquip =
{
	slotConfig =
	{
		createIcon		= false,
		createBorder	= true,
		createCount		= true,
		createEnchant	= true,
		createCash		= true,
	},
	control =
	{
		buttonApply 	= UI.getChildControl( Panel_FixEquip, "Button_Apply" ),
		buttonApplyCash	= UI.getChildControl( Panel_FixEquip, "Button_CashItemUse" ),
		staticDesc 		= UI.getChildControl( Panel_FixEquip, "Static_Text_Description" ),
		enchantNumber	= UI.getChildControl( Panel_FixEquip, "Static_Text_Slot_Enchant_value" ),
		fixHelp			= UI.getChildControl( Panel_FixEquip, "StaticText_HelpDesc" ),
		-- moneyFix		= UI.getChildControl( Panel_FixEquip, "RadioButton_MoneyRecovery"),
		itemFix			= UI.getChildControl( Panel_FixEquip, "RadioButton_OnlyItem"),
		moneyItemFix	= UI.getChildControl( Panel_FixEquip, "RadioButton_ItemMoneyRecovery"),

		equipPrice		= UI.getChildControl( Panel_FixEquip, "StaticText_EquipPrice"),
		streamRecovery	= UI.getChildControl( Panel_FixEquip, "CheckButton_StreamRecovery"),
	},

	slotMain= nil,
	slotSub	= nil
}

fixEquip.control.streamRecovery:SetShow( true )
fixEquip.control.streamRecovery:SetCheck( false )

local onlyMoneyCheck	= false
local onlyItemCheck		= fixEquip.control.itemFix:IsCheck()
local moneyItemCheck	= false

local FixEquip_FixHelp = function()
	fixEquip.control.fixHelp:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )	-- Auto Wrap
	-- fixEquip.control.fixHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_REPAIR_TEXT_HELP") ) -- "잦은 잠재력 돌파로 인해 손상된 내구도를 복구할 수 있습니다. 손상된 무기와 같은 무기를 하나 더 올려놓아 최대 내구도를 복구하세요."
	fixEquip.control.fixHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_FIXHELP") ) -- "- 동일한 장비를 재료로 사용해 최대 내구도를 복구합니다.\n- 최대 내구도를 복구할 장비를 먼저 선택한 뒤 재료로 사용할 장비를 선택합니다.\n- 재료로 복구하기는 별도의 비용이 필요하지 않습니다.\n- 최대 내구도가 10 <PAColor0xFF00C0D7>상승<PAOldColor>되며, 재료로 사용된 장비는 <PAColor0xFFF26A6A>파괴<PAOldColor>됩니다." )
end

local uiHelp =
{
	_slot_0_Notice = UI.getChildControl ( Panel_FixEquip, "StaticText_Notice_Slot_0" ),
	_slot_1_Notice = UI.getChildControl ( Panel_FixEquip, "StaticText_Notice_Slot_1" ),
}

local tmpEnchantLevel = 0
local ENCAHNT_PROGRESS_TIME = 4.0		-- 진행되는 초를 설정한다 (Progress Bar)
local checked_EnchantItemType = 0		-- 0: 무기, 1: 방어구

local 	_buttonQuestion = UI.getChildControl( Panel_FixEquip, "Button_Question" )			-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelFixEquip\" )" )									-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelFixEquip\", \"true\")" )					-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelFixEquip\", \"false\")" )				-- 물음표 마우스아웃

-----------------------------------------------------------------------------------------
--					마우스 이벤트로 슬롯에 있는 아이템을 뺄 수 있다!
-----------------------------------------------------------------------------------------
local FixEquip_MouseEvent_OutSlots_Done = function( isDone )
	if ( isDone == true ) then
		fixEquip.slotMain.icon:addInputEvent( "Mouse_RUp", "FixEquip_OutSlots( true )" )
		fixEquip.slotSub.icon:addInputEvent( "Mouse_RUp", "FixEquip_OutSlots( false )" )
	else
		-- fixEquip.slotMain.icon:addInputEvent( "Mouse_RUp", "" )
		fixEquip.slotSub.icon:addInputEvent( "Mouse_RUp", "FixEquip_OutSlots( false )" )
	end
end

-----------------------------------------------------------------------------------------
--						기본 데이터를 클리어 해주는 함수!
-----------------------------------------------------------------------------------------
local FixEquip_clearData = function()
	local self = fixEquip
	
	self.slotMain:clearItem()
	self.slotMain.empty		= true
	self.slotMain.whereType	= nil
	self.slotMain.slotNo	= nil
	self.slotMain.itemKey	= nil
	
	self.slotSub:clearItem()
	self.slotSub.empty		= true
	self.slotSub.whereType	= nil
	self.slotSub.slotNo		= nil
	self.slotSub.itemKey	= nil

	-- Panel_FixEquip:EraseAllEffect()
	-- self.control.buttonApply:EraseAllEffect()
	self.control.buttonApply:SetIgnore( true )
	self.control.buttonApply:SetMonoTone( true )
	self.control.buttonApply:SetEnable( false )
	self.control.buttonApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_REPAIR_MAXENDURANCE" ))		-- 최대 내구도 수리, 돌파!
	self.control.buttonApply:SetAlpha( 0.85 )

	-- self.control.buttonApplyCash:SetIgnore( true )
	self.control.buttonApplyCash:SetMonoTone( true )
	-- self.control.buttonApplyCash:SetEnable( false )
	self.control.buttonApplyCash:SetAlpha( 0.85 )
	
	FixEquip_MouseEvent_OutSlots_Done( true )		-- 슬롯에 있던 아이템을 우클릭으로 뺀다!
end

local FixEquip_clearDataOnlySub = function()
	local self = fixEquip
	
	-- self.slotMain:clearItem()
	-- self.slotMain.empty		= true
	-- self.slotMain.whereType	= nil
	-- self.slotMain.slotNo	= nil
	-- self.slotMain.itemKey	= nil
	
	self.slotSub:clearItem()
	self.slotSub.empty		= true
	self.slotSub.whereType	= nil
	self.slotSub.slotNo		= nil
	self.slotSub.itemKey	= nil

	self.control.buttonApply:SetIgnore( true )
	self.control.buttonApply:SetMonoTone( true )
	self.control.buttonApply:SetEnable( false )
	self.control.buttonApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_REPAIR_MAXENDURANCE" ))		-- 최대 내구도 수리, 돌파!
	self.control.buttonApply:SetAlpha( 0.85 )

	self.control.buttonApplyCash:SetMonoTone( true )
	self.control.buttonApplyCash:SetAlpha( 0.85 )
	
	FixEquip_MouseEvent_OutSlots_Done( false )		-- 슬롯에 있던 아이템을 우클릭으로 뺀다!
end

-----------------------------------------------------------------------------------------
--							컨트롤을 만들어주도록 하자
-----------------------------------------------------------------------------------------
local	slotMain= {}
local	slotSub	= {}
local FixEquip_createControl = function()
	slotMain.icon = UI.getChildControl( Panel_FixEquip, "Static_Slot_0" )
	SlotItem.new( slotMain, 'Slot_0', 0, Panel_FixEquip, fixEquip.slotConfig )
	slotMain:createChild()
	slotMain.empty = true
	slotMain.icon:addInputEvent( "Mouse_On", "Panel_FixEquipMouseOnEvent(0, \"FixEquip\", true)" )
	slotMain.icon:addInputEvent( "Mouse_Out","Panel_FixEquipMouseOnEvent(0, \"FixEquip\", false)" )
	Panel_Tooltip_Item_SetPosition(0, slotMain, "FixEquip")
	
	fixEquip.slotMain = slotMain
	
	slotSub.icon = UI.getChildControl( Panel_FixEquip, "Static_Slot_1" )
	SlotItem.new( slotSub, 'Slot_1', 1, Panel_FixEquip, fixEquip.slotConfig )
	slotSub:createChild()
	slotSub.empty = true
	slotSub.icon:addInputEvent( "Mouse_On", "Panel_FixEquipMouseOnEvent(1, \"FixEquip\", true)" )
	slotSub.icon:addInputEvent( "Mouse_Out","Panel_FixEquipMouseOnEvent(1, \"FixEquip\", false)" )
	Panel_Tooltip_Item_SetPosition(1, slotSub, "FixEquip")
	
	fixEquip.slotSub = slotSub

	if isGameTypeEnglish() then
		fixEquip.control.streamRecovery	:SetSpanSize( 140, 200 )
		fixEquip.control.itemFix		:SetSpanSize( -165, 220 )
		fixEquip.control.moneyItemFix	:SetSpanSize( -165, 245 )
	else
		fixEquip.control.streamRecovery	:SetSpanSize( 100, 200 )
		fixEquip.control.itemFix		:SetSpanSize( -20, 210 )
		fixEquip.control.moneyItemFix	:SetSpanSize( -20, 240 )
	end

	fixEquip.control.itemFix:SetCheck( true )
	FixEquip_clearData()
end

function Panel_FixEquipMouseOnEvent( index, type, isMouseOn )
	if ( slotMain.empty ) then
		if ( index == 0 ) then
			--왼쪽거
			if ( isMouseOn == true ) then
				uiHelp._slot_1_Notice:SetShow( true )
				uiHelp._slot_1_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
				uiHelp._slot_1_Notice:SetAutoResize( true )
				uiHelp._slot_1_Notice:SetSize( 220, 86 )
				uiHelp._slot_1_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_REPAIR_MAXENDURANCE_GUIDE1" )) -- 최대 내구도를 수리할 아이템을 넣으세요.
				uiHelp._slot_1_Notice:SetSize ( uiHelp._slot_1_Notice:GetSizeX() + 5, uiHelp._slot_1_Notice:GetSizeY() + 30 )
			else
				uiHelp._slot_1_Notice:SetShow(false)
			end
		end
	else
		Panel_Tooltip_Item_Show_GeneralNormal( index, type, isMouseOn )
	end
	
	if ( slotSub.empty ) then
		if ( index == 1 ) then
			--오른쪽거
			if ( isMouseOn == true ) then
				uiHelp._slot_0_Notice:SetShow( true )
				uiHelp._slot_0_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
				uiHelp._slot_0_Notice:SetAutoResize( true )
				uiHelp._slot_0_Notice:SetSize( 220, 86 )
				uiHelp._slot_0_Notice:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_GETITEM") ) -- "재료로 쓸 아이템을 넣으세요." )
				uiHelp._slot_0_Notice:SetSize ( uiHelp._slot_0_Notice:GetSizeX() + 5, uiHelp._slot_0_Notice:GetSizeY() + 30 )
			else
				uiHelp._slot_0_Notice:SetShow(false)
			end
		end
	else
		Panel_Tooltip_Item_Show_GeneralNormal( index, type, isMouseOn )
	end
end

-- 
function IsReadyToReapirMaxEndurance()
	local	self	= fixEquip
	if	(nil == self.slotMain.slotNo)	then
		return(false)
	end
	
	if	(nil == self.slotSub.slotNo)	then
		return(false)
	end
	
	return(true)
end

-- 아이템 배치
local fixEquipData = { slotNoMain, whereTypeMain, whereTypeSub, itemKeySub }
function Panel_FixEquip_InteractortionFromInventory( slotNo, itemWrapper, count, inventoryType )
	local self = fixEquip

	local	itemWrapper	= getInventoryItemByType(inventoryType, slotNo)
	if( nil == itemWrapper )	then
		return
	end
	
	if	(self.slotMain.empty)	then
		-- 들어오는대로 이펙트를 뿌려준다
		-- if ( self.slotMain.icon ) then
			-- self.slotMain.icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
		-- end

		self.slotMain:setItem( itemWrapper )
		
		self.slotMain.empty		= false
		self.slotMain.whereType	= inventoryType
		self.slotMain.slotNo	= slotNo
		self.slotMain.itemKey	= itemWrapper:get():getKey()
		
		-- INVENTORY_FILTER ON ENCHANT_SUB_ITEM
		Inventory_SetFunctor( FixEquip_InvenFiler_SubItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_Close, nil )
		self.control.equipPrice:SetShow( false )
	elseif	(self.slotSub.empty)	then
	
		-- _enchantEffect:AddEffect( "fUI_Gauge_Blue", true, 0, 0 )
		-- self.slotSub.icon:EraseAllEffect()
		-- self.slotSub.icon:AddEffect( "fUI_DarkstoneAura02", false, 0, 0 )
		-- self.slotSub.icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
		-- checked_EnchantItemType = 0
		
		self.slotSub:setItem( itemWrapper )
		
		self.slotSub.empty		= false
		self.slotSub.whereType	= inventoryType
		self.slotSub.slotNo		= slotNo
		self.slotSub.itemKey	= itemWrapper:get():getKey():getItemKey()

		if moneyItemCheck then
			local fixEquipPrice = itemWrapper:getMoneyToRepairItemMaxEndurance( self.slotMain.itemKey )
			self.control.equipPrice:SetShow( true )
			self.control.equipPrice:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_FIXEQUIP_NEEDMONEY", "fixEquipPrice", makeDotMoney(fixEquipPrice) ) ) -- "현재 내구도를 복구하기 위해서는 추가로 <PAColor0xFF66CC33>" .. makeDotMoney(fixEquipPrice) .. "<PAOldColor> 은화가 필요합니다." )
		else
			self.control.equipPrice:SetShow( false )
		end
	else
		-- _enchantEffect:EraseAllEffect()
		UI.ASSERT( false, 'Client data, UI data is Mismatch!!!!!' )
		return
	end

	self.control.buttonApplyCash:EraseAllEffect()
	-- self.control.buttonApplyCash:SetIgnore( false )
	self.control.buttonApplyCash:SetMonoTone( true )
	-- self.control.buttonApplyCash:SetEnable( false )
	self.control.buttonApplyCash:SetAlpha( 0.85 )
	self.control.buttonApplyCash:addInputEvent( "Mouse_LUp", "" )

	local isReady = IsReadyToReapirMaxEndurance()
	if ( isReady == true ) then
		self.control.buttonApply:AddEffect( "UI_Equip_Repair", true, 0, 0 )
		self.control.buttonApply:SetIgnore( false )
		self.control.buttonApply:SetMonoTone( false )
		self.control.buttonApply:SetEnable( true )
		self.control.buttonApply:SetAlpha( 1.0 )
		self.control.buttonApply:addInputEvent( "Mouse_LUp", "FixEquip_ApplyButton( false )" )

		local hasCashItem = doHaveContentsItem( 27, 0, false )

		if true == hasCashItem then	-- 유료 아이템을 가지고 있는가?	-- and 44195 ~= self.slotSub.itemKey
			self.control.buttonApplyCash:AddEffect( "UI_Equip_Repair", true, 0, 0 )
			-- self.control.buttonApplyCash:SetIgnore( false )
			self.control.buttonApplyCash:SetMonoTone( false )
			-- self.control.buttonApplyCash:SetEnable( true )
			self.control.buttonApplyCash:SetAlpha( 1.0 )
			self.control.buttonApplyCash:addInputEvent( "Mouse_LUp", "FixEquip_ApplyButton( true )" )
		end
	else
		self.control.buttonApply:EraseAllEffect()
		self.control.buttonApply:SetIgnore( true )
		self.control.buttonApply:SetMonoTone( true )
		self.control.buttonApply:SetEnable( false )
		self.control.buttonApply:SetAlpha( 0.85 )
		self.control.buttonApply:addInputEvent( "Mouse_LUp", "" )
	end

	

	FixEquip_MouseEvent_OutSlots_Done( true )		-- 슬롯에 있던 아이템을 우클릭으로 뺀다!
end

function FixEquip_ItemRecoveryPrice()
	local self			= fixEquip
	local repairItemKey = self.slotMain.itemKey

	local mainWrapper	= getInventoryItemByType(self.slotSub.whereType, self.slotSub.slotNo)
end

-----------------------------------------------------------------------------------------
-- 					
-----------------------------------------------------------------------------------------
local	s64_allWeight
local	useCash
function FixEquip_ApplyButton( isHelpRepair )
	local self = fixEquip
	local funcYesExe = nil
	-- _enchantEffect:EraseAllEffect()
	--{
		local dontFix = function()
			FGlobal_closeFix()
			return
		end
		
		local doFixEquipMaxEndurance = function() -- 아이템 끼리만 사용할 때
			fixEquipData.slotNoMain		= self.slotMain.slotNo
			fixEquipData.whereTypeMain	= self.slotMain.whereType
			fixEquipData.whereTypeSub	= self.slotSub.whereType
			fixEquipData.itemKeySub		= self.slotSub.itemKey
			s64_allWeight				= getSelfPlayer():get():getCurrentWeight_s64()
			useCash						= isHelpRepair
			repair_MaxEndurance( self.slotMain.whereType, self.slotMain.slotNo, self.slotSub.whereType, self.slotSub.slotNo, isHelpRepair )
			-- FGlobal_closeFix()
			return
		end

		local doFixEquipOnlyMoney = function() -- 돈으로만 사용할 때
			repair_MaxEndurance( self.slotMain.whereType, self.slotMain.slotNo, 0, 0, isHelpRepair )
			FGlobal_closeFix()
			return
		end

		local doFixEquipMoneyItem = function() -- 아이템이랑 돈이랑 같이 사용할 때
			repair_MaxEndurance( self.slotMain.whereType, self.slotMain.slotNo, self.slotSub.whereType, self.slotSub.slotNo, isHelpRepair )
			FGlobal_closeFix()
			return
		end
	--}
	
	if onlyItemCheck then
		funcYesExe = doFixEquipMaxEndurance
	elseif onlyMoneyCheck then
		funcYesExe = doFixEquipOnlyMoney
	elseif moneyItemCheck then
		funcYesExe = doFixEquipMoneyItem
	end

	local self = fixEquip
	if ( nil ~= self.slotMain.slotNo and nil ~= self.slotSub.slotNo ) then

		local hasCashItem = doHaveContentsItem( 27, 0, false )
		if false == hasCashItem and true == isHelpRepair then
			self.control.buttonApplyCash:EraseAllEffect()
			self.control.buttonApplyCash:SetMonoTone( true )
			self.control.buttonApplyCash:SetAlpha( 0.85 )
			self.control.buttonApplyCash:addInputEvent( "Mouse_LUp", "" )
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_USECASHALL") ) -- 장인의 기억을 모두 사용하였습니다.
			return
		end

		if onlyItemCheck then
			contentString	= PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ONLYITEMCHECK_CONTENTSTRING") -- "최대 내구도 복구 시 재료로 사용된 아이템은 파괴됩니다.\n이대로 진행하시겠습니까?"
		elseif moneyItemCheck then
			contentString	= PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_MONEYITEMCHECK_CONTENTSTRING") -- "최대 내구도 복구 시 재료로 사용된 아이템은 파괴되고 일정 은화가 소진됩니다."
		end

		local itemWrapper	= getInventoryItemByType( self.slotMain.whereType, self.slotMain.slotNo )
		local maxEndurance	= nil
		local currentEndurance = itemWrapper:get():getEndurance()
		if ( false == itemWrapper:getStaticStatus():get():isUnbreakable() ) then
			maxEndurance = itemWrapper:getStaticStatus():get()._enchant._maxEndurance
		end

		if true == isHelpRepair and ( maxEndurance - currentEndurance < 15 ) then
			contentString = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_DURABILITY_SHORTAGE") .. contentString
		end

		local titleString	= PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
		local messageboxData= { title = titleString
							, content = contentString, functionYes = funcYesExe, functionCancel = dontFix, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
	else
		FGlobal_closeFix()
	end
end

function UseCashBtnEffectDelete()
	local self = fixEquip
	self.control.buttonApplyCash:EraseAllEffect()
	-- self.control.buttonApplyCash:SetIgnore( false )
	self.control.buttonApplyCash:SetMonoTone( true )
	-- self.control.buttonApplyCash:SetEnable( false )
	self.control.buttonApplyCash:SetAlpha( 0.85 )
	self.control.buttonApplyCash:addInputEvent( "Mouse_LUp", "" )

	local isReady = IsReadyToReapirMaxEndurance()
	if ( isReady == true ) then
		self.control.buttonApply:AddEffect( "UI_Equip_Repair", true, 0, 0 )
		self.control.buttonApply:SetIgnore( false )
		self.control.buttonApply:SetMonoTone( false )
		self.control.buttonApply:SetEnable( true )
		self.control.buttonApply:SetAlpha( 1.0 )
		self.control.buttonApply:addInputEvent( "Mouse_LUp", "FixEquip_ApplyButton( false )" )

		local hasCashItem = doHaveContentsItem( 27, 0, false )

		if true == hasCashItem then	-- 유료 아이템을 가지고 있는가?	-- and 44195 ~= self.slotSub.itemKey
			self.control.buttonApplyCash:AddEffect( "UI_Equip_Repair", true, 0, 0 )
			-- self.control.buttonApplyCash:SetIgnore( false )
			self.control.buttonApplyCash:SetMonoTone( false )
			-- self.control.buttonApplyCash:SetEnable( true )
			self.control.buttonApplyCash:SetAlpha( 1.0 )
			self.control.buttonApplyCash:addInputEvent( "Mouse_LUp", "FixEquip_ApplyButton( true )" )
		end
	else
		self.control.buttonApply:EraseAllEffect()
		self.control.buttonApply:SetIgnore( true )
		self.control.buttonApply:SetMonoTone( true )
		self.control.buttonApply:SetEnable( false )
		self.control.buttonApply:SetAlpha( 0.85 )
		self.control.buttonApply:addInputEvent( "Mouse_LUp", "" )
	end
end

function isFixEquip_SubSlotItemKey()
	return fixEquipData.itemKeySub
end

function isRepeatRepair()
	return fixEquip.control.streamRecovery:IsCheck()
end

function FGlobal_FixEquipContinue( slotNo )
	local self = fixEquipData
	local mainItemWrapper = getInventoryItemByType(self.whereTypeMain, self.slotNoMain)
	if nil == mainItemWrapper then
		return
	end
	
	if useCash then -- 장인의 기억 사용을 클릭했냐?
		local doHaveCashItem = doHaveContentsItem( 27, 0, false )
		if not doHaveCashItem and useCash then -- 유료템 장인의 기억 체크.
			fixEquip.control.buttonApplyCash:EraseAllEffect()
			fixEquip.control.buttonApplyCash:SetMonoTone( true )
			fixEquip.control.buttonApplyCash:SetAlpha( 0.85 )
			fixEquip.control.buttonApplyCash:addInputEvent( "Mouse_LUp", "" )
			return
		end
	end

	-- 아이템이 실제로 감소했는지 체크는 무게로 한다! 
	-- 잦은 인벤 업데이트로 실제 갱신되기 전에 여러 번 들어오기도 하기 때문!
	if getSelfPlayer():get():getCurrentWeight_s64() < s64_allWeight then
		s64_allWeight = getSelfPlayer():get():getCurrentWeight_s64()
	else
		return	
	end
	
	if mainItemWrapper:checkToRepairItemMaxEndurance() then
		repair_MaxEndurance( self.whereTypeMain, self.slotNoMain, self.whereTypeSub, slotNo, useCash )
	else
		fixEquipData_Clear()
	end
end

function fixEquipData_Clear()
	fixEquipData.slotNoMain		= nil
	fixEquipData.whereTypeMain	= nil
	fixEquipData.whereTypeSub	= nil
	fixEquipData.itemKeySub		= nil
	s64_allWeight				= nil
	useCash						= nil
end

function FGlobal_closeFix()
	local self = fixEquip

	if true == Panel_FixEquip:GetShow() then
		self.control.buttonApply:EraseAllEffect()
		local savedSubSlotNo	= self.slotSub.slotNo
		local savedMainSlotNo	= self.slotMain.slotNo
		local itemMainWrapper	= getInventoryItem( savedMainSlotNo )
		local mainSlotEndurance = FixEquip_InvenFiler_MainItem( self.slotMain.slotNo, itemMainWrapper )

		if true == mainSlotEndurance and nil ~= savedMainSlotNo then
			FixEquip_clearData()
			Inventory_SetFunctor( FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil  )
			return
		end


		if nil == savedSubSlotNo then
			return
		end
		-- FixEquip_clearData()

		local inventory			= getSelfPlayer():get():getInventory()
		local inventoryType		= Inventory_GetCurrentInventoryType()
		local itemWrapper		= getInventoryItem( savedSubSlotNo )
		if nil ~= itemWrapper then
			local itemSSW			= itemWrapper:getStaticStatus()
			local itemKey			= itemSSW:get()._key
			local itemCount			= inventory:getItemCount_s64( itemKey )

			self.slotSub:setItem( itemWrapper )

			-- FixEquip_clearDataOnlySub()
			-- Inventory_SetFunctor( FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil  )
		else
			self.slotSub:clearItem()
			self.slotSub.empty		= true
			FixEquip_clearDataOnlySub()
		end
	end
end

function FGlobal_returnSlotNo()
	return fixEquip.slotSub.slotNo
end

function FixEquip_InvenFiler_MainItem( slotNo, itemWrapper )
	local self = fixEquip
	if nil == itemWrapper then
		return true
	end

	isAble = itemWrapper:checkToRepairItemMaxEndurance();	-- 민우씨 이부분을 수정해야 합니다.

	return (not isAble);
end

-- return true will be grayscale and disable!
function	FixEquip_InvenFiler_SubItem( slotNo, itemWrapper, inventoryType )
	if nil == itemWrapper then
		return true
	end

	local self = fixEquip
	local isAble = false;
	local repairItemKey = self.slotMain.itemKey
	
	if nil == repairItemKey then
		return true
	end

	if moneyItemCheck then
		if ( itemWrapper:checkToRepairItemMaxEnduranceWithMoneyAndItem(repairItemKey) ) then
			if( self.slotMain.slotNo ~= slotNo or self.slotMain.whereType ~= inventoryType ) then
				isAble = true
			end
		end
	else
		if ( itemWrapper:checkToRepairItemMaxEnduranceWithSameItem(repairItemKey) ) then
			if( self.slotMain.slotNo ~= slotNo or self.slotMain.whereType ~= inventoryType ) then
				isAble = true
			end
		end
	end
	
	

	return( not isAble )
end

function FixEquip_GetMainSlotNo()
	return fixEquip.slotMain.slotNo
end

function FixEquip_GetSubSlotNo()
	return fixEquip.slotSub.slotNo
end

-----------------------------------------------------------------------------------------
--							우클릭으로 아이템을 뺐다!
-----------------------------------------------------------------------------------------
function FixEquip_OutSlots( outSlotType )
	local self = fixEquip
	if true == outSlotType then
		FixEquip_clearData()								-- 데이터 클리어
		Inventory_SetFunctor( FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil  )			-- INVENTORY_FILTER ON ENCHANT_MAIN_ITEM
	else
		FixEquip_clearDataOnlySub()
	end
	fixEquip.control.equipPrice:SetShow( false )
	
end


-----------------------------------------------------------------------------------------
--								최대 내구도 수리
-----------------------------------------------------------------------------------------
function FixEquip_Show()
	FixEquip_clearData()
	if ( Panel_FixEquip:IsShow() == false ) then
		Panel_FixEquip:SetShow(true, false)
		Inventory_SetFunctor( FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil  )
		InventoryWindow_Show();
		FixEquip_FixHelp()
		audioPostEvent_SystemUi(01,00)
	else
		FixEquip_Close()
	end
	fixEquip.control.streamRecovery:SetCheck( false )
	fixEquipData_Clear()
end

function FixEquip_Close()

	-- 꺼준다
	if ( false == Panel_FixEquip:IsShow() ) then		
		return ;
	end
		
	Panel_FixEquip:SetShow( false, true )
	Inventory_SetFunctor( nil, nil, nil, nil )
	
	FixEquip_clearData()
	fixEquip.control.itemFix:SetCheck( true )
	fixEquip.control.moneyItemFix:SetCheck( false )
	fixEquipData_Clear()
end

function FixEquip_HideAni()
	UIAni.AlphaAnimation( 0, Panel_FixEquip, 0.0, 0.15 ):SetHideAtEnd(true)
	audioPostEvent_SystemUi(01,01)
end

function FixEquip_GetSlotNo(slotType)
	if (1 == slotType) then
		return fixEquip.slotSub.slotNo
	else
		return fixEquip.slotMain.slotNo
	end
end


-----------------------------------------------------------------------------------------
--								취소 버튼
-----------------------------------------------------------------------------------------
function FixEquip_CancelButton()
	FixEquip_clearData()								-- 데이터 클리어
	Inventory_SetFunctor( FixEquip_InvenFiler_MainItem, Panel_FixEquip_InteractortionFromInventory, FixEquip_CloseButton, nil  )			-- INVENTORY_FILTER ON ENCHANT_MAIN_ITEM
end

function FixEquipItemBtn_LUp()
	
	if( true == Panel_FixEquip:GetShow() ) then
		onlyItemCheck	= true
		moneyItemCheck	= false
		FixEquip_Close()
	else
		onlyItemCheck	= true
		moneyItemCheck	= false
		fixEquip.control.equipPrice:SetShow( false )
		FixEquip_Show()
	end

end

function FixEquipItem_registEventHandler()
	local self = fixEquip.control

	-- self.moneyFix		:addInputEvent("Mouse_LUp", "HandleClicked_FixType( 0 )")
	self.itemFix		:addInputEvent("Mouse_LUp", "HandleClicked_FixType( 1 )")
	self.moneyItemFix	:addInputEvent("Mouse_LUp", "HandleClicked_FixType( 2 )")

	self.moneyItemFix	:addInputEvent("Mouse_On",	"FixEquip_SimpleTooltips( true, 0 )")
	self.moneyItemFix	:addInputEvent("Mouse_Out",	"FixEquip_SimpleTooltips( false )")
	self.itemFix		:addInputEvent("Mouse_On",	"FixEquip_SimpleTooltips( true, 1 )")
	self.itemFix		:addInputEvent("Mouse_Out",	"FixEquip_SimpleTooltips( false )")

	self.buttonApplyCash:addInputEvent("Mouse_On",	"FixEquip_SimpleTooltips( true, 2 )")
	self.buttonApplyCash:addInputEvent("Mouse_Out",	"FixEquip_SimpleTooltips( false )")

	self.streamRecovery	:addInputEvent("Mouse_On",	"FixEquip_SimpleTooltips( true, 3 )")
	self.streamRecovery	:addInputEvent("Mouse_Out",	"FixEquip_SimpleTooltips( false )")

	self.moneyItemFix	:setTooltipEventRegistFunc("FixEquip_SimpleTooltips( true, 0 )")
	self.itemFix		:setTooltipEventRegistFunc("FixEquip_SimpleTooltips( true, 1 )")
	self.buttonApplyCash:setTooltipEventRegistFunc("FixEquip_SimpleTooltips( true, 2 )")
	self.streamRecovery	:setTooltipEventRegistFunc("FixEquip_SimpleTooltips( true, 3 )")
end

function HandleClicked_FixType( fixType )
	local self = fixEquip.control

	-- 0 : 돈만 사용 / 1 : 아이템만 사용 / 2 : 아이템과 돈 같이 사용
	-- if 0 == fixType then
	-- 	onlyMoneyCheck	= self.moneyFix:IsCheck()
	-- 	onlyItemCheck	= false
	-- 	moneyItemCheck	= false
	-- 	FixEquip_CancelButton()
	-- else
	if 1 == fixType then
		onlyItemCheck	= self.itemFix:IsCheck()
		onlyMoneyCheck	= false
		moneyItemCheck	= false
		fixEquip.control.fixHelp:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
		fixEquip.control.fixHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_ITEMFIX_HELP") ) -- "- 동일한 장비를 재료로 사용해 최대 내구도를 복구합니다.\n- 최대 내구도를 복구할 장비를 먼저 선택한 뒤 재료로 사용할 장비를 선택합니다.\n- 재료로 복구하기는 별도의 비용이 필요하지 않습니다.\n- 최대 내구도가 10 <PAColor0xFF00C0D7>상승<PAOldColor>되며, 재료로 사용된 장비는 <PAColor0xFFF26A6A>파괴<PAOldColor>됩니다." )
		fixEquip.control.streamRecovery:SetCheck( false )
		FixEquip_CancelButton()
	elseif 2 == fixType then
		moneyItemCheck = self.moneyItemFix:IsCheck()
		onlyMoneyCheck	= false
		onlyItemCheck	= false
		fixEquip.control.fixHelp:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
		fixEquip.control.fixHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_MONEYITEMFIX_HELP") ) -- "- 한 단계 아래 등급의 장비를 재료로 사용해 최대 내구도를 복구합니다.\n- 내구도 복구를 하려면 일정량의 은화가 필요합니다.\n- 같은 등급의 장비는 재료로 사용할 수 없습니다.\n- 최대 내구도가 10 <PAColor0xFF00C0D7>상승<PAOldColor>되며, 재료로 사용된 장비는 <PAColor0xFFF26A6A>파괴<PAOldColor>됩니다." )
		fixEquip.control.streamRecovery:SetCheck( false )
		FixEquip_CancelButton()
	end
end

function FixEquip_SimpleTooltips( isShow, fixType )
	local self = fixEquip.control
	local name, desc, uiControl = nil, nil, nil

	if 0 == fixType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_MONEYITEM_NAME") -- "재료와 은화로 복구"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_MONEYITEM_DESC") -- "복구하려는 아이템의 하급 아이템으로 복구할 수 있습니다. 이 때 일정 은화가 소진됩니다."
		uiControl = self.moneyItemFix
	elseif 1 == fixType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_ONLYITEM_NAME") -- "재료만으로 복구"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_ONLYITEM_DESC") -- "복구하려는 아이템과 동일한 아이템으로 복구합니다."
		uiControl = self.itemFix
	elseif 2 == fixType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_APPLYCASH_NAME") -- "장인의 기억"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_TOOLTIP_APPLYCASH_DESC") -- "아이템의 최대 내구도 복구에 장인의 기억을 함께 사용하여, 5만큼 더 복구합니다."
		uiControl = self.buttonApplyCash
	elseif 3 == fixType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_STREAMRECOVERY_TOOLTIP_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_FIXEQUIP_STREAMRECOVERY_TOOLTIP_DESC")
		uiControl = self.streamRecovery
	end

	if isShow == true then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end
-----------------------------------------------------------------------------------------
--								일단 초기화 시켜주자
-----------------------------------------------------------------------------------------
FixEquip_FixHelp()
FixEquip_createControl()
FixEquipItem_registEventHandler()
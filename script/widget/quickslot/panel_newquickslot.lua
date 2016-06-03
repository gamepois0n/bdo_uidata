local UI_TM			= CppEnums.TextMode
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TISNU 		= CppEnums.TInventorySlotNoUndefined
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 		= Defines.Color

Panel_NewQuickSlot:SetShow( false )

local NewQuickSlot = {
	panelPool = {},
	config = {
		maxPanelCount = 20,
		isPressMove = false,
	},

	slotConfig_Item =
	{
		createIcon			= true,
		createBorder		= false,
		createCount			= true,
		createCooltime		= true,
		createCooltimeText	= true,
		createCash			= true,
	},
	slotConfig_Skill =
	{
		createIcon 			= true,
		createEffect 		= true,
		createFG 			= false,
		createFGDisabled 	= false,
		createLevel 		= false,
		createLearnButton 	= false,
		createCooltime 		= true,
		createCooltimeText	= true,
		
		-- 스킬 아이콘 Template
		template =
		{
			effect = UI.getChildControl( Panel_Window_Skill, "Static_Icon_Skill_Effect" )
		}
	},

	slotKey = {
		[0] = CppEnums.ActionInputType.ActionInputType_QuickSlot1,
		[1] = CppEnums.ActionInputType.ActionInputType_QuickSlot2,
		[2] = CppEnums.ActionInputType.ActionInputType_QuickSlot3,
		[3] = CppEnums.ActionInputType.ActionInputType_QuickSlot4,
		[4] = CppEnums.ActionInputType.ActionInputType_QuickSlot5,
		[5] = CppEnums.ActionInputType.ActionInputType_QuickSlot6,
		[6] = CppEnums.ActionInputType.ActionInputType_QuickSlot7,
		[7] = CppEnums.ActionInputType.ActionInputType_QuickSlot8,
		[8] = CppEnums.ActionInputType.ActionInputType_QuickSlot9,
		[9] = CppEnums.ActionInputType.ActionInputType_QuickSlot10,
		[10] = CppEnums.ActionInputType.ActionInputType_QuickSlot11,
		[11] = CppEnums.ActionInputType.ActionInputType_QuickSlot12,
		[12] = CppEnums.ActionInputType.ActionInputType_QuickSlot13,
		[13] = CppEnums.ActionInputType.ActionInputType_QuickSlot14,
		[14] = CppEnums.ActionInputType.ActionInputType_QuickSlot15,
		[15] = CppEnums.ActionInputType.ActionInputType_QuickSlot16,
		[16] = CppEnums.ActionInputType.ActionInputType_QuickSlot17,
		[17] = CppEnums.ActionInputType.ActionInputType_QuickSlot18,
		[18] = CppEnums.ActionInputType.ActionInputType_QuickSlot19,
		[19] = CppEnums.ActionInputType.ActionInputType_QuickSlot20,
	}
}

local NewQuickSlot_PanelList = {
	[0]		= Panel_NewQuickSlot_0,
	[1]		= Panel_NewQuickSlot_1,
	[2]		= Panel_NewQuickSlot_2,
	[3]		= Panel_NewQuickSlot_3,
	[4]		= Panel_NewQuickSlot_4,
	[5]		= Panel_NewQuickSlot_5,
	[6]		= Panel_NewQuickSlot_6,
	[7]		= Panel_NewQuickSlot_7,
	[8]		= Panel_NewQuickSlot_8,
	[9]		= Panel_NewQuickSlot_9,
	[10]	= Panel_NewQuickSlot_10,
	[11]	= Panel_NewQuickSlot_11,
	[12]	= Panel_NewQuickSlot_12,
	[13]	= Panel_NewQuickSlot_13,
	[14]	= Panel_NewQuickSlot_14,
	[15]	= Panel_NewQuickSlot_15,
	[16]	= Panel_NewQuickSlot_16,
	[17]	= Panel_NewQuickSlot_17,
	[18]	= Panel_NewQuickSlot_18,
	[19]	= Panel_NewQuickSlot_19,
}

local NewQuickSlot_PanelID = {
	[0]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_0,
	[1]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_1,
	[2]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_2,
	[3]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_3,
	[4]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_4,
	[5]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_5,
	[6]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_6,
	[7]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_7,
	[8]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_8,
	[9]		= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_9,
	[10]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_10,
	[11]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_11,
	[12]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_12,
	[13]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_13,
	[14]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_14,
	[15]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_15,
	[16]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_16,
	[17]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_17,
	[18]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_18,
	[19]	= CppEnums.PAGameUIType.PAGameUIPanel_NewQuickSlot_19,
}

local NewQuickSlot_Lock = {
	[NewQuickSlot_PanelList[0]] = false,
	[NewQuickSlot_PanelList[1]] = false,
	[NewQuickSlot_PanelList[2]] = false,
	[NewQuickSlot_PanelList[3]] = false,
	[NewQuickSlot_PanelList[4]] = false,
	[NewQuickSlot_PanelList[5]] = false,
	[NewQuickSlot_PanelList[6]] = false,
	[NewQuickSlot_PanelList[7]] = false,
	[NewQuickSlot_PanelList[8]] = false,
	[NewQuickSlot_PanelList[9]] = false,
	[NewQuickSlot_PanelList[10]] = false,
	[NewQuickSlot_PanelList[11]] = false,
	[NewQuickSlot_PanelList[12]] = false,
	[NewQuickSlot_PanelList[13]] = false,
	[NewQuickSlot_PanelList[14]] = false,
	[NewQuickSlot_PanelList[15]] = false,
	[NewQuickSlot_PanelList[16]] = false,
	[NewQuickSlot_PanelList[17]] = false,
	[NewQuickSlot_PanelList[18]] = false,
	[NewQuickSlot_PanelList[19]] = false,
}

local potionData = {		-- 회복제가 추가되면 여기에 등록해야 한다.
	hp = {
		[0] = 502,			-- 생명력 회복제(초보자)
		[1] = 513,			-- 생명력 순간 회복제(소형)
		[2] = 514,			-- 생명력 순간 회복제(중형)
		[3] = 517,			-- 생명력 회복제(소형)
		[4] = 518,			-- 생명력 회복제(중형)
		[5] = 519,			-- 생명력 회복제(대형)
		[6] = 524,			-- 생명력 회복제(초대형)
		[7] = 525,			-- 생명력 회복제(특대형)
		[8] = 528,			-- 생명력 순간 회복제(대형)
		[9] = 529,			-- 생명력 순간 회복제(초대형)
		[10] = 530,			-- 생명력 순간 회복제(특대형)
		[11] = 538,			-- 생명력 회복제(지속형)
		[12] = 551,			-- [길드] 생명력 회복제(소형)
		[13] = 552,			-- [길드] 생명력 회복제(중형)
		[14] = 553,			-- [길드] 생명력 회복제(대형)
		[15] = 554,			-- [길드] 생명력 회복제(초대형)
		[16] = 555,			-- [길드] 생명력 회복제(특대형)
		[17] = 17568,		-- 생명력 회복제(초대형)
		[18] = 17569,		-- 생명력 회복제(특대형)
		[19] = 19932,		-- [이벤트] 초대형 생명력 회복제
		[20] = 19933,		-- [PC방] 생명력 회복제(소형)
		[21] = 19934,		-- [PC방] 생명력 회복제(중형)
		[22] = 19935,		-- [PC방] 생명력 회복제(대형)
	},
	mp = {
		[0] = 503,			-- 정신력 회복제(초보자)
		[1] = 520,			-- 정신력 회복제(소형)
		[2] = 521,			-- 정신력 회복제(중형)
		[3] = 522,			-- 정신력 회복제(대형)
		[4] = 526,			-- 정신력 회복제(초대형)
		[5] = 527,			-- 정신력 회복제(특대형)
		[6] = 515,			-- 정신력 순간 회복제(소형)
		[7] = 516,			-- 정신력 순간 회복제(중형)
		[8] = 531,			-- 정신력 순간 회복제(대형)
		[9] = 532,			-- 정신력 순간 회복제(초대형)
		[10] = 533,			-- 정신력 순간 회복제(특대형)
	},
}

function FGlobal_NewQuickSlot_InitPos(updateByServer)
	for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		local slot = NewQuickSlot.panelPool[panelIdx]
		slot.Panel:SetPosX( (getScreenSizeX() * 0.35) + ( (slot.Panel:GetSizeX() + 5) * panelIdx ) )
		slot.Panel:SetPosY( getScreenSizeY() - slot.Panel:GetSizeY() - 5 )
		if ( updateByServer ) then
			changePositionBySever( slot.Panel, NewQuickSlot_PanelID[panelIdx], false, true, false )	-- 서버 저장 값을 따른다.
		end
	end
end

function NewQuickSlot:Init()
	for panelIdx = 0, self.config.maxPanelCount -1 do
		self.panelPool[panelIdx]  = {}
		local slot = self.panelPool[panelIdx]
		slot.Panel = NewQuickSlot_PanelList[panelIdx]	-- UI.createPanel( "NewQuickSlot_" .. panelIdx, Defines.UIGroup.PAGameUIGroup_MainUI )
		-- slot.Panel:SetSize( 50, 65 )

		slot.Panel:SetIgnore( false )
		slot.Panel:SetShow( false )

		slot.PanelPosX = slot.Panel:GetPosX()
		slot.PanelPosY = slot.Panel:GetPosY()

		slot.Handle			= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "Static_Handle",		slot.Panel, "NewQuickSlot_" .. panelIdx .. "_Handle" )
		slot.MenuBtn		= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "Button_Menu",		slot.Panel, "NewQuickSlot_" .. panelIdx .. "_MenuBtn" )
		slot.DeleteBtn		= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "Button_Delete",		slot.Panel, "NewQuickSlot_" .. panelIdx .. "_DeleteBtn" )
		slot.ResetKeyBtn	= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "Button_Reset",		slot.Panel, "NewQuickSlot_" .. panelIdx .. "_ResetBtn" )
		slot.LockBtn		= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "CheckButton_Lock",	slot.Panel, "NewQuickSlot_" .. panelIdx .. "_LockBtn" )
		slot.LockIcon		= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "Static_Lock",		slot.Panel, "NewQuickSlot_" .. panelIdx .. "_LockIcon" )

		slot.SlotBG			= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "Static_SlotBG",		slot.Panel, "NewQuickSlot_" .. panelIdx .. "_SlotBG" )
		slot.Help			= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "Static_BubbleBox",	slot.Panel, "NewQuickSlot_" .. panelIdx .. "_SlotHelp" )

		local itemSlot = {}
		SlotItem.new( itemSlot, 'NewQuickSlot_' .. panelIdx, panelIdx, slot.SlotBG, NewQuickSlot.slotConfig_Item )
		itemSlot:createChild()
		itemSlot.icon:addInputEvent( "Mouse_LUp",		"HandleClicked_NewQuickSlot_Use( "..panelIdx.." )" )
		itemSlot.icon:addInputEvent( "Mouse_PressMove",	"NewQuickSlot_DragStart("..panelIdx..")" )
		itemSlot.icon:SetEnableDragAndDrop(true)
		itemSlot.icon:SetIgnore( false )
		slot.item = itemSlot

		local skillSlot = {}
		SlotSkill.new( skillSlot, panelIdx, slot.SlotBG, NewQuickSlot.slotConfig_Skill )
		skillSlot.icon:addInputEvent( "Mouse_LUp",			"HandleClicked_NewQuickSlot_Use( "..panelIdx.." )" )
		skillSlot.icon:addInputEvent( "Mouse_PressMove",	"NewQuickSlot_DragStart("..panelIdx..")" )
		skillSlot.icon:SetEnableDragAndDrop(true)
		slot.skill = skillSlot

		slot.SlotKey	= UI.createAndCopyBasePropertyControl( Panel_NewQuickSlot, "StaticText_Key",	slot.Panel, "NewQuickSlot_" .. panelIdx .. "_SlotKey" )

		slot.Handle		:ComputePos()

		slot.DeleteBtn	:SetShow( false )	-- 메뉴를 눌러야 켜짐
		slot.ResetKeyBtn:SetShow( false )	-- 메뉴를 눌러야 켜짐
		slot.LockBtn	:SetShow( false )	-- 메뉴를 눌러야 켜짐
		slot.MenuBtn	:SetShow( false )	-- 마우스를 올리면 켜게 하자.
		slot.LockIcon	:SetShow( false )	-- 마우스를 올리면 켜게 하자.
		slot.Handle		:SetShow( false )	-- 마우스를 올리면 켜게 하자.


		slot.keyValue = nil

		slot.MenuBtn	:addInputEvent( "Mouse_LUp",	"HandleClick_NewQuickSlot_OpenSlotMenu( " .. panelIdx .. ")" )
		slot.DeleteBtn	:addInputEvent( "Mouse_LUp",	"HandleClick_NewQuickSlot_UnSet( " .. panelIdx .. ")" )
		slot.ResetKeyBtn:addInputEvent( "Mouse_LUp",	"HandleClick_NewQuickSlot_ResetKey( " .. panelIdx .. ")" )
		slot.LockBtn	:addInputEvent( "Mouse_LUp",	"HandleClick_NewQuickSlot_LockSlot( " .. panelIdx .. ")" )
		
		slot.Panel		:addInputEvent( "Mouse_LPress",	"NewQuickSlot_PanelDrag( " .. panelIdx .. " )" )
		slot.Panel		:addInputEvent( "Mouse_LDown",	"NewQuickSlot_PanelGetlock( " .. panelIdx .. " )" )
		slot.Panel		:addInputEvent( "Mouse_LUp",	"NewQuickSlot_PanelDragEnd()" )

		slot.MenuBtn	:addInputEvent( "Mouse_On",		"HandleOnOut_NewQuickSlot_ShowHandle( true,		" .. panelIdx .. " )" )
		slot.MenuBtn	:addInputEvent( "Mouse_Out",	"HandleOnOut_NewQuickSlot_ShowHandle( false,	" .. panelIdx .. " )" )
		slot.Panel		:addInputEvent( "Mouse_On",		"HandleOnOut_NewQuickSlot_ShowHandle( true,		" .. panelIdx .. " )" )
		slot.Panel		:addInputEvent( "Mouse_Out",	"HandleOnOut_NewQuickSlot_ShowHandle( false,	" .. panelIdx .. " )" )
	end
	FGlobal_NewQuickSlot_InitPos(true)
end
NewQuickSlot:Init()

function _NewQuickSlot_LockSlot_ChangeTexture( panelIdx, isLock )
	local slot = NewQuickSlot.panelPool[panelIdx]
	slot.LockIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/Dialogue_Etc_00.dds")

	local x1, y1, x2, y2 = 0, 0, 0, 0
	if isLock then
		x1, y1, x2, y2 = setTextureUV_Func( slot.LockIcon, 366, 342, 382, 358 )	
	else
		x1, y1, x2, y2 = setTextureUV_Func( slot.LockIcon, 366, 359, 382, 375 )	
	end
	slot.LockIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
	slot.LockIcon:setRenderTexture(slot.LockIcon:getBaseTexture())
end

function NewQuickSlot_SetLockState()
	for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		NewQuickSlot_Lock[panelIdx] = ToClient_getSplitQuickSlotHold( NewQuickSlot_PanelList[panelIdx] )
		_NewQuickSlot_LockSlot_ChangeTexture( panelIdx, NewQuickSlot_Lock[panelIdx] )
	end
end
NewQuickSlot_SetLockState()

function NewQuickSlot:UpdateMain()
	if Defines.UIMode.eUIMode_Default ~= GetUIMode() then	-- 일반 모드에서만 켜지도록.
		return
	end

	for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		local slot	= NewQuickSlot.panelPool[panelIdx]
		slot.Panel	:SetShow( false )
		slot.item.icon	:addInputEvent( "Mouse_On",		"" )
		slot.item.icon	:addInputEvent( "Mouse_Out",	"" )
		slot.skill.icon	:addInputEvent( "Mouse_On",		"" )
		slot.skill.icon	:addInputEvent( "Mouse_Out",	"" )
	end

	if not isUseNewQuickSlot() then	-- 새 퀵슬롯을 쓰지 않는다면, 업데이트 하지 않는다.
		return
	end

	for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		local quickSlotKey	= panelIdx
		local quickSlotInfo	= getQuickSlotItem( quickSlotKey )
		local slot			= NewQuickSlot.panelPool[panelIdx]

		slot.Panel		:SetShow( true )
		slot.Help		:SetShow( false )	-- 도움말은 기본 꺼둔다.

		slot.item.icon	:SetIgnore( true )
		slot.skill.icon	:SetIgnore( true )

		slot.SlotKey	:SetText( keyCustom_GetString_ActionKey(self.slotKey[panelIdx]) )		-- 스트링을 받아오는 방식으로 변경
		slot.item		:clearItem()
		slot.skill		:clearSkill()

		if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type ) then
			-- 비어 있음
			slot.Panel		:SetShow( false )
			slot.SlotKey	:SetFontColor( UI_color.C_FF626262 )
			slot.keyValue	= nil
		elseif ( CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type) then
			-- 아이템이나 캐시 아이템일 때
			NewQuickSlot:UpdateItem( panelIdx, quickSlotInfo )
		elseif ( CppEnums.QuickSlotType.eSkill == quickSlotInfo._type ) then
			-- 스킬일 때
			NewQuickSlot:UpdateSkill( panelIdx, quickSlotInfo )
		end

		-- { 화면 벗어나기 방지
			NewQuickSlot:SafetyPosition( panelIdx )
		-- }
	end
end

function NewQuickSlot:SafetyPosition( panelIdx )	-- 화면 벗어남 방지
	local slot			= NewQuickSlot.panelPool[panelIdx]
	local isLeftOut		= slot.Panel:GetPosX() < 0
	local isRightOut	= getScreenSizeX() - slot.Panel:GetSizeX() < slot.Panel:GetPosX()
	local isTopOut		= slot.Panel:GetPosY() < 0
	local isBottomOut	= getScreenSizeY() - slot.Panel:GetSizeY() < slot.Panel:GetPosY()

	if isLeftOut then	-- 왼쪽으로 사라짐
		slot.Panel:SetPosX( 0 )
	end
	if isRightOut then	-- 오른쪽으로 사라짐
		slot.Panel:SetPosX( getScreenSizeX() - slot.Panel:GetSizeX() )
	end
	if isTopOut then	-- 윗쪽으로 사라짐
		slot.Panel:SetPosY( 0 )
	end
	if isBottomOut then	-- 아래쪽으로 사라짐
		slot.Panel:SetPosY( getScreenSizeY() - slot.Panel:GetSizeY() )
	end

	--if isLeftOut or isRightOut or isTopOut or isBottomOut then
	--	ToClient_SaveUiInfo( true )	-- 벗어난 적이 있으면 당기고 저장.
	--end
end

function NewQuickSlot:UpdateItem( panelIdx, quickSlotInfo )
	local slot				= NewQuickSlot.panelPool[panelIdx]
	local selfPlayer		= getSelfPlayer():get()
	local inventoryType		= QuickSlot_GetInventoryTypeFrom( quickSlotInfo._type )
	local inventory			= selfPlayer:getInventoryByType( inventoryType )
	local invenSlotNo		= inventory:getSlot( quickSlotInfo._itemKey )
	local itemStaticWrapper	= getItemEnchantStaticStatus( quickSlotInfo._itemKey )
	local itemName			= itemStaticWrapper:getName()
	local _const			= Defines.s64_const
	local s64_stackCount	= _const.s64_0
	if	CppEnums.TInventorySlotNoUndefined ~= invenSlotNo	then
		s64_stackCount = getInventoryItemByType( inventoryType, invenSlotNo ):get():getCount_s64()
	end

	slot.item		:setItemByStaticStatus( itemStaticWrapper, s64_stackCount )
	slot.item.icon	:SetMonoTone( _const.s64_0 == s64_stackCount )
	slot.SlotKey	:SetFontColor( UI_color.C_FF88DF00 )
	slot.keyValue	= invenSlotNo

	slot.item.icon	:SetIgnore( false )
	slot.item.icon	:addInputEvent( "Mouse_On",			"HandleOnOut_NewQuickSlot_ItemTooltip( true, " .. panelIdx .. " )" )
	slot.item.icon	:addInputEvent( "Mouse_Out",		"HandleOnOut_NewQuickSlot_ItemTooltip( fasle, " .. panelIdx .. " )" )
	slot.item.icon	:setTooltipEventRegistFunc( "HandleOnOut_NewQuickSlot_ItemTooltip( true, " .. panelIdx .. " )" )

	if ( 2 < getSelfPlayer():get():getLevel() and 40 > getSelfPlayer():get():getLevel()) then	-- 지정된 레벨인데, 퀵슬롯에 물약 갯수가 0이라면 알림.
		if toInt64(0,0) == s64_stackCount then	-- 0개라면. 
			local itemKey		= quickSlotInfo._itemKey:get()
			local hasNotPosion	= false
			for hpIdx = 0, #potionData.hp -1 do
				if itemKey == potionData.hp[hpIdx] then
					hasNotPosion = true
					break
				end
			end
			if hasNotPosion then
				-- 도움말을 켠다.
				slot.Help:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION_2", "itemName", itemName ) ) -- itemName .. "이\n 떨어졌습니다. 리필해주세요."
				slot.Help:SetSize( slot.Help:GetTextSizeX() + 25, slot.Help:GetTextSizeY() + 40  )
				slot.Help:SetPosX( 0 )
				slot.Help:SetPosY( slot.Help:GetSizeY() * -1 )
				slot.Help:SetShow( true )
			end
		end
	end
end

function NewQuickSlot:UpdateSkill( panelIdx, quickSlotInfo )
	local slot						= NewQuickSlot.panelPool[panelIdx]
	local skillNo					= quickSlotInfo._skillKey:getSkillNo()
	local skillTypeStaticWrapper	= getSkillTypeStaticStatus( skillNo )

	slot.skill		:setSkillTypeStatic( skillTypeStaticWrapper )
	slot.SlotKey	:SetFontColor( UI_color.C_FF40D7FD )
	slot.keyValue	= quickSlotInfo._skillKey

	slot.skill.icon	:SetIgnore( false )
	slot.skill.icon	:addInputEvent( "Mouse_On",			"HandleOnOut_NewQuickSlot_SkillTooltip( true, " .. panelIdx .. " )" )
	slot.skill.icon	:addInputEvent( "Mouse_Out",		"HandleOnOut_NewQuickSlot_SkillTooltip( false, " .. panelIdx .. " )" )
	slot.skill.icon	:setTooltipEventRegistFunc( "HandleOnOut_NewQuickSlot_SkillTooltip( true, " .. panelIdx .. " )" )
	Panel_SkillTooltip_SetPosition( panelIdx, slot.skill.icon, "QuickSlot" )
end

function NewQuickSlot_PanelGetlock( panelIdx )
	local panel = NewQuickSlot_PanelList[panelIdx]
	NewQuickSlot_Lock[panelIdx] = ToClient_getSplitQuickSlotHold( panel )
end

function NewQuickSlot_PanelDrag( panelIdx )	-- 슬롯을 들고 드래그 하면 인접한 슬롯에 붙는다.
	NewQuickSlot.config.isPressMove = true	-- LPress 동안 툴팁이 나타나지 않게.

	if NewQuickSlot_Lock[panelIdx] then
		return
	end

	local slot		= NewQuickSlot.panelPool[panelIdx]
	local posX		= getMousePosX() - ( slot.Panel:GetSizeX() * 0.5 )
	local posY		= getMousePosY() - ( slot.Panel:GetSizeY() * 0.3 )
	slot.PanelPosX	= posX
	slot.PanelPosY	= posY
	slot.Panel		:SetPosX( posX )
	slot.Panel		:SetPosY( posY )
	local pickUpPanelPosX = slot.Panel:GetPosX()
	local pickUpPanelPosY = slot.Panel:GetPosY()

	--[[ 다른 패널의 위치를 체크한다.	일단 삭제.
	for orderPanelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		if panelIdx ~= orderPanelIdx then
			local orderlSlot		= NewQuickSlot.panelPool[orderPanelIdx]
			local orderPanelPosX	= orderlSlot.Panel:GetPosX()
			local orderPanelPosY	= orderlSlot.Panel:GetPosY()
			if orderlSlot.Panel:GetShow() then
				local isNearHorizon		= ( orderPanelPosX - (orderlSlot.Panel:GetSizeX()*1.3) < pickUpPanelPosX and pickUpPanelPosX < orderPanelPosX + (orderlSlot.Panel:GetSizeX()*1.3) )
				local isNearVertical	= ( orderPanelPosY - (orderlSlot.Panel:GetSizeY()*1.3) < pickUpPanelPosY and pickUpPanelPosY < orderPanelPosY + (orderlSlot.Panel:GetSizeY()*1.3) )

				if isNearHorizon and isNearVertical then	-- 들고 있는 패널이 다른 패널 근처로 간다면!
					local leftGap		= math.floor(pickUpPanelPosX - ( orderPanelPosX - (orderlSlot.Panel:GetSizeX()*1.3) ))
					local rightGap		= math.floor(( orderPanelPosX + (orderlSlot.Panel:GetSizeX()*1.3) ) - pickUpPanelPosX)
					local topGap		= math.floor(pickUpPanelPosY - ( orderPanelPosY - (orderlSlot.Panel:GetSizeY()*1.3) ))
					local bottomGap		= math.floor(( orderPanelPosY + (orderlSlot.Panel:GetSizeY()*1.3) ) - pickUpPanelPosY)

					if (leftGap < rightGap) and (leftGap < topGap) and (leftGap < bottomGap) then			-- 왼쪽으로 붙이기
						slot.Panel		:SetPosX( orderPanelPosX - orderlSlot.Panel:GetSizeX() )
						slot.Panel		:SetPosY( orderPanelPosY )
					elseif (rightGap < leftGap ) and (rightGap < topGap) and (rightGap < bottomGap) then	-- 오른쪽으로 붙이기
						slot.Panel		:SetPosX( orderPanelPosX + orderlSlot.Panel:GetSizeX() )
						slot.Panel		:SetPosY( orderPanelPosY )
					elseif (topGap < leftGap ) and (topGap < rightGap) and (topGap < bottomGap) then		-- 위로 붙이기
						slot.Panel		:SetPosX( orderPanelPosX )
						slot.Panel		:SetPosY( orderPanelPosY - (orderlSlot.Panel:GetSizeY() + 3) )
					elseif (bottomGap < leftGap ) and (bottomGap < rightGap) and (bottomGap < topGap) then	-- 아래로 붙이기
						slot.Panel		:SetPosX( orderPanelPosX )
						slot.Panel		:SetPosY( orderPanelPosY + (orderlSlot.Panel:GetSizeY() + 3) )
					end
					-- break
				end
			end
		end
	end
	--]]
end

function NewQuickSlot_PanelDragEnd()		-- LPress 동안 툴팁이 나타나지 않게.
	ToClient_SaveUiInfo( true )
	NewQuickSlot.config.isPressMove = false
end

function HandleOnOut_NewQuickSlot_ShowHandle( isShow, panelIdx )
	if isCharacterCameraRotateMode() then
		return
	end

	local slot = NewQuickSlot.panelPool[panelIdx]
	
	if isShow then
		slot.MenuBtn	:SetShow( true )
		slot.LockIcon	:SetShow( true )
		slot.Handle		:SetShow( true )
	else
		local panelPosX		= slot.Panel:GetPosX()
		local panelPosY		= slot.Panel:GetPosY()
		local panelSizeX	= slot.Panel:GetSizeX()
		local panelSizeY	= slot.Panel:GetSizeY()
		local mousePosX		= getMousePosX()
		local mousePosY		= getMousePosY()

		if (panelPosX < mousePosX and mousePosX < panelPosX + panelSizeX)
			and (panelPosY < mousePosY and mousePosY < panelPosY + panelSizeY) then
			return
		end

		slot.MenuBtn	:SetShow( false )
		slot.LockIcon	:SetShow( false )
		slot.Handle		:SetShow( false )
		slot.DeleteBtn	:SetShow( false )
		slot.ResetKeyBtn:SetShow( false )
		slot.LockBtn	:SetShow( false )
		NewQuickSlot.config.isPressMove = false	-- LPress 동안 툴팁이 나타나지 않게.(간혹 인식 못하는 버그 차단용)
	end
end

function HandleClick_NewQuickSlot_OpenSlotMenu( panelIdx )
	local slot = NewQuickSlot.panelPool[panelIdx]
	local isShow = slot.DeleteBtn:GetShow()
	slot.DeleteBtn	:SetShow( not isShow )	-- 메뉴를 눌러야 켜짐
	slot.ResetKeyBtn:SetShow( not isShow )	-- 메뉴를 눌러야 켜짐
	slot.LockBtn	:SetShow( not isShow )	-- 메뉴를 눌러야 켜짐
end

function HandleClick_NewQuickSlot_UnSet( panelIdx )
	local clearSlot = function()
		quickSlot_Clear( panelIdx )
	end

	local messageContent = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUICKSLOT_UNSET", "slotNo", panelIdx+1 )
	local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE" ), content = messageContent, functionYes = clearSlot, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function HandleClick_NewQuickSlot_ResetKey( panelIdx )
	local unsetKey = function()
		-- keyCustom_clearActionVirtualKeyCode( panelIdx + 19 )
		local isActionType = true
		FGlobal_NewShortCut_SetQuickSlot( panelIdx + 19, isActionType )
	end
	
	local messageContent = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUICKSLOT_RESETKEY", "slotNo", panelIdx+1 )
	local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE" ), content = messageContent, functionYes = unsetKey, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)

	-- keyCustom_clearUIVirtualKeyCode()
	-- 키 설정 창에서 차리해야 함.
end

function HandleClick_NewQuickSlot_LockSlot( panelIdx )
	NewQuickSlot_Lock[panelIdx] = not NewQuickSlot_Lock[panelIdx]
	ToClient_setSplitQuickSlotHold(NewQuickSlot_PanelList[panelIdx], NewQuickSlot_Lock[panelIdx])
	_NewQuickSlot_LockSlot_ChangeTexture( panelIdx, NewQuickSlot_Lock[panelIdx] )
end


function HandleOnOut_NewQuickSlot_ItemTooltip( isShow, panelIdx )
	if isShow and ( false == NewQuickSlot.config.isPressMove ) then
		local slot				= NewQuickSlot.panelPool[panelIdx]
		local selfPlayer		= getSelfPlayer():get()
		local quickSlotInfo		= getQuickSlotItem( panelIdx )
		local itemStaticWrapper	= getItemEnchantStaticStatus( quickSlotInfo._itemKey )

		registTooltipControl(slot.item.icon, Panel_Tooltip_Item)
		Panel_Tooltip_Item_Show( itemStaticWrapper,  slot.item.icon, true, false, nil, nil, nil )
	else
		Panel_Tooltip_Item_hideTooltip()
	end

	HandleOnOut_NewQuickSlot_ShowHandle( isShow, panelIdx )
end

function HandleOnOut_NewQuickSlot_SkillTooltip( isShow, panelIdx )
	if isShow and ( false == NewQuickSlot.config.isPressMove ) then
		local slot				= NewQuickSlot.panelPool[panelIdx]
		registTooltipControl(slot.skill.icon, Panel_Tooltip_Skill)
		Panel_SkillTooltip_Show( panelIdx, false, "QuickSlot" )
	else
		Panel_SkillTooltip_Hide()
	end

	HandleOnOut_NewQuickSlot_ShowHandle( isShow, panelIdx )
end

function HandleClicked_NewQuickSlot_Use( panelIdx )
	local slot			= NewQuickSlot.panelPool[panelIdx]
	local quickSlotKey	= panelIdx
	local quickSlotInfo	= getQuickSlotItem( quickSlotKey )
	local tempDragInfo	= nil

	if nil ~= DragManager.dragStartPanel then	-- 들고 있는게 있다면. 세팅
		local isAutoSetup = false
		NewQuickSlot_DropHandler( panelIdx, isAutoSetup )
	else	-- 들고 있는게 없다면, 사용.
		if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type ) then
			-- 비어 있음
		elseif ( CppEnums.QuickSlotType.eItem == quickSlotInfo._type or CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type) then
			-- 아이템이나 캐시 아이템일 때
			slot.item.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
			slot.item.icon:AddEffect("UI_SkillButton01", false, 0, 0)

			local	whereType		= QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
			-- 모닥불 체크.
			if ( nil ~= slot.item.item ) then
				if isNearFusionCore() and isFusionItem( whereType, slot.keyValue ) then	-- 모닥불 가까이!
						audioPostEvent_SystemUi(8,2)
						burnItemToActor( whereType, slot.keyValue, 1 )
					return
				end
			end
			
			local	inventory	= getSelfPlayer():get():getInventoryByType(whereType)
			local	invenSlotNo = inventory:getSlot( quickSlotInfo._itemKey )
			if	( inventory:sizeXXX() <= invenSlotNo )	then
				return
			end
			
			local itemWrapper	= getInventoryItemByType( whereType, invenSlotNo )
			local itemEnchantWrapper = itemWrapper:getStaticStatus()
			if	(2 == itemEnchantWrapper:get()._vestedType:getItemKey()) and (false == itemWrapper:get():isVested())	then	-- 착용하지 않았던 장착 시 귀속 아이템이라면,
				local bindingItemUse = function()
					audioPostEvent_SystemUi(8,2)
					quickSlot_UseSlot( panelIdx )
				end
				
				local	messageContent	= nil
				if	itemEnchantWrapper:isUserVested()	then
					messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT_USERVESTED" )		-- "해당 아이템 장착 시 아이템 거래소 이용이 불가능해집니다. 장착하시겠습니까?"
				else
					messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT" )				-- "해당 아이템 장착 시 아이템 거래소 및 창고 이용이 불가능해집니다. 장착하시겠습니까?"
				end

				local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE" ), content = messageContent, functionYes = bindingItemUse, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
				MessageBox.showMessageBox(messageboxData)
			else
				audioPostEvent_SystemUi(8,2)
				quickSlot_UseSlot( panelIdx )
			end
		elseif ( CppEnums.QuickSlotType.eSkill == quickSlotInfo._type ) then
			-- 스킬일 때
			if not slot.skill.cooltime:GetShow() then
				local skillStaticWrapper = getSkillTypeStaticStatus( quickSlotInfo._skillKey:getSkillNo() )
				if( skillStaticWrapper:getUiDisplayType() )then					
					SpiritGuide_Show()
				end
				audioPostEvent_SystemUi(8,2)
				slot.skill.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
				slot.skill.icon:AddEffect("UI_SkillButton01", false, 0, 0)
				quickSlot_UseSlot( panelIdx )
			end
		end
	end
end

function NewQuickSlot_DragStart( panelIdx )
	local quickSlotInfo		= getQuickSlotItem( panelIdx )
	local slot				= NewQuickSlot.panelPool[panelIdx]

	-- 아이콘 드래그 복사
	if	(CppEnums.QuickSlotType.eItem == quickSlotInfo._type) or (CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type)	then
		local itemStaticWrapper = getItemEnchantStaticStatus( quickSlotInfo._itemKey )
		DragManager:setDragInfo(slot.Panel, nil, panelIdx, "Icon/" .. itemStaticWrapper:getIconPath(), NewQuickSlot_DropGround, nil)
	elseif	CppEnums.QuickSlotType.eSkill == quickSlotInfo._type	then
		local skillTypeStaticWrapper = getSkillTypeStaticStatus( quickSlotInfo._skillKey:getSkillNo() )
		DragManager:setDragInfo(slot.Panel, nil, panelIdx, "Icon/" .. skillTypeStaticWrapper:getIconPath(), NewQuickSlot_DropGround, nil)
	end
end

function NewQuickSlot_DropHandler( panelIdx, isAutoSetup )
	if nil == DragManager.dragStartPanel then
		return false
	end

	local slot		= NewQuickSlot.panelPool[panelIdx]
	local posX		= getMousePosX() - ( slot.Panel:GetSizeX() * 0.5 )
	local posY		= getMousePosY() - ( slot.Panel:GetSizeY() * 0.5 )
	slot.PanelPosX	= posX
	slot.PanelPosY	= posY

	local setSuccess = false
	if DragManager.dragStartPanel == Panel_Window_Inventory then
		local itemWrapper = getInventoryItemByType( DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo )
		if nil ~= itemWrapper then
			if		itemWrapper:getStaticStatus():get():isContentsEvent() 
				or	itemWrapper:getStaticStatus():get():isItemSkill() 
				or	itemWrapper:getStaticStatus():get():isItemInterAction() 
				or	itemWrapper:getStaticStatus():get():isUseToVehicle() 
				or	itemWrapper:getStaticStatus():get():isEquipable() 
				or	itemWrapper:getStaticStatus():get():isItemTent() then
				quickSlot_RegistItem( panelIdx, DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo )
				
				if isAutoSetup then
					slot.Panel		:SetPosX( posX )
					slot.Panel		:SetPosY( posY )
				end
				setSuccess = true
			end
		end
	elseif DragManager.dragStartPanel == Panel_Window_Skill then
		quickSlot_RegistSkill( panelIdx, DragManager.dragSlotInfo )
		if isAutoSetup then
			slot.Panel		:SetPosX( posX )
			slot.Panel		:SetPosY( posY )
		end
		setSuccess = true
	elseif DragManager.dragStartPanel == NewQuickSlot_PanelList[0]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[1]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[2]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[3]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[4]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[5]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[6]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[7]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[8]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[9]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[10]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[11]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[12]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[13]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[14]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[15]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[16]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[17]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[18]
		or DragManager.dragStartPanel == NewQuickSlot_PanelList[19] then
		if panelIdx ~= DragManager.dragSlotInfo then
			quickSlot_Swap( panelIdx, DragManager.dragSlotInfo )
			setSuccess = true
		end
	end

	audioPostEvent_SystemUi(0,8)
	DragManager:clearInfo()

	return setSuccess
end

function NewQuickSlot_DropGround( whereType, panelIdx )
	DragManager:clearInfo()
end

function FGlobal_SetNewQuickSlot_ByGroundClick( s64_itemCount, slotNo, whereType )
	local itemWrapper	= getInventoryItemByType(whereType, slotNo)
	local emptySlotIdx	= nil

	for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		local quickSlotKey	= panelIdx
		local quickSlotInfo	= getQuickSlotItem( quickSlotKey )
		if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type ) then
			emptySlotIdx = panelIdx
			break
		end
	end

	if nil ~= emptySlotIdx then
		local isAutoSetup	= true
		local setSuccess	= NewQuickSlot_DropHandler( emptySlotIdx, isAutoSetup )
		local isActionType	= true
		if setSuccess then
			FGlobal_NewShortCut_SetQuickSlot( emptySlotIdx + 19, isActionType )	-- 사용할 단축키 설정. CppEnums.ActionInputType이 퀵슬롯은 19부터 시작한다.
		else
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_NEWQUICKSLOT_DONTSET" ) ) -- "퀵슬롯에 등록할 수 없습니다.")

		end
	else
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_NEWQUICKSLOT_NOTHAVEEMPTY" ) ) -- "비어 있는 슬롯이 없습니다."
	end
	DragManager:clearInfo()
end

function FGlobal_SetNewQuickSlot_BySkillGroundClick( skillKey )
	for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		local quickSlotKey	= panelIdx
		local quickSlotInfo	= getQuickSlotItem( quickSlotKey )
		if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type ) then
			emptySlotIdx = panelIdx
			break
		end
	end
	if nil ~= emptySlotIdx then
		local isAutoSetup = true
		NewQuickSlot_DropHandler( emptySlotIdx, isAutoSetup )
		local isActionType	= true
		FGlobal_NewShortCut_SetQuickSlot( emptySlotIdx + 19, isActionType )	-- 사용할 단축키 설정. CppEnums.ActionInputType이 퀵슬롯은 19부터 시작한다.
	else
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_NEWQUICKSLOT_NOTHAVEEMPTY" ) ) -- "비어 있는 슬롯이 없습니다."
	end
	DragManager:clearInfo()
end

function FGlobal_NewQuickSlot_Update()
	NewQuickSlot:UpdateMain()
end

function FGlobal_NewQuickSlot_CheckAndSetPotion( slotNo, itemType )
	local itemWrapper = getInventoryItem( slotNo )

	if 0 == itemType then
		for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
			local	quickSlotInfo	= getQuickSlotItem( panelIdx )
			local	quickType		= quickSlotInfo._type
			if	(CppEnums.QuickSlotType.eItem == quickType)	or (CppEnums.QuickSlotType.eCashItem == quickType)	then
				local itemKey		= quickSlotInfo._itemKey:get()
				for hpIdx = 0, #potionData.hp -1 do
					if itemKey == potionData.hp[hpIdx] then
						return	true	-- 회복제가 있으니까 리턴 시킨다.
					end
				end
			end
		end

		local emptySlotIndex = _newQuickSlot_EmptySlot_Check()
		if ( nil ~= emptySlotIndex ) then
			quickSlot_RegistItem( emptySlotIndex, 0, slotNo )	-- 첫 번째 빈 슬롯에 꼽는다.
		end
	else
		for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
			local	quickSlotInfo	= getQuickSlotItem( panelIdx )
			local	quickType		= quickSlotInfo._type
			if	(CppEnums.QuickSlotType.eItem == quickType)	or (CppEnums.QuickSlotType.eCashItem == quickType)	then
				local itemKey		= quickSlotInfo._itemKey:get()
				for mpIdx = 0, #potionData.mp -1 do
					if itemKey == potionData.mp[mpIdx] then
						return	true	-- 회복제가 있으니까 리턴 시킨다.
					end
				end
			end
		end

		local emptySlotIndex = _newQuickSlot_EmptySlot_Check()
		if ( nil ~= emptySlotIndex ) then
			quickSlot_RegistItem( emptySlotIndex, 0, slotNo )	-- 첫 번째 빈 슬롯에 꼽는다.
		end
	end

	return false
end
function _newQuickSlot_EmptySlot_Check()
	local emptySlotNo = nil
	for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		local quickSlotInfo = getQuickSlotItem( panelIdx )
		if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type ) then
			emptySlotNo = panelIdx
			break
		end
	end
	return emptySlotNo
end


function FromClient_NewQuickSlot_Update()
	NewQuickSlot:UpdateMain()
end

function Panel_NewQuickSlot_PositionReset()
	FGlobal_NewQuickSlot_InitPos(true)
end

local onEffectTime = 0
function NewQuickSlot_UpdatePerFrame( fDeltaTime )
	if not isUseNewQuickSlot() then	-- 새 퀵슬롯을 쓰지 않는다면, 업데이트 하지 않는다.
		return
	end

	if Defines.UIMode.eUIMode_Default ~= GetUIMode() then	-- 일반 모드에서만 켜지도록.
		return
	end
	
	if fDeltaTime <= 0 then
		return
	end
	onEffectTime = onEffectTime + fDeltaTime

	for panelIdx = 0, NewQuickSlot.config.maxPanelCount -1 do
		local quickSlotKey	= panelIdx
		local quickSlotInfo	= getQuickSlotItem( quickSlotKey )
		local slot			= NewQuickSlot.panelPool[panelIdx]

		if nil == quickSlotInfo then 
		  break
		end

		if slot.Panel:GetShow() then
			if	(CppEnums.QuickSlotType.eItem == quickSlotInfo._type) or (CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type)	then
				if (nil == slot.item) then
					break
				end
				local	remainTime		= 0
				local	itemReuseTime	= 0
				local	realRemainTime	= 0
				local	intRemainTime 	= 0
				local	whereType		= QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
				if ( UI_TISNU ~= slot.keyValue ) then
					remainTime		= getItemCooltime( whereType, slot.keyValue )
					itemReuseTime	= getItemReuseCycle( whereType, slot.keyValue ) / 1000
					realRemainTime	= remainTime * itemReuseTime
					intRemainTime	= realRemainTime - realRemainTime % 1 + 1
				end

				if isNearFusionCore() and isFusionItem( whereType, slot.keyValue ) then	-- 모닥불 가까이!
					if 3 < onEffectTime then
						slot.item.icon:EraseAllEffect()
						slot.item.icon:AddEffect("UI_ItemInstall_Gold", false, 0, 0)
					end
				end
			
				if ( 0 < remainTime ) then
					slot.item.cooltime:UpdateCoolTime( remainTime )
					slot.item.cooltime:SetShow( true )
					slot.item.cooltimeText:SetText( Time_Formatting_ShowTop(intRemainTime) )
					if ( intRemainTime <= itemReuseTime ) then
						slot.item.cooltimeText:SetShow( true )
					else
						slot.item.cooltimeText:SetShow( false )
					end
				else
					if ( slot.item.cooltime:GetShow() ) then
						------------------------------------------------
						-- 	  		퀵 슬롯에서 쿨타임 해제!
						------------------------------------------------
						slot.item.cooltime:SetShow( false )
						slot.item.cooltimeText:SetShow( false )

						local skillSlotItemPosX = slot.item.cooltime:GetParentPosX()
						local skillSlotItemPosY = slot.item.cooltime:GetParentPosY()
							
						Panel_CoolTime_Effect_Item_Slot:SetShow( true, true )
						Panel_CoolTime_Effect_Item_Slot:SetIgnore(true)
						
						-- ♬ 쿨타임이 다 찼을 때 사운드 추가
						Panel_CoolTime_Effect_Item_Slot:AddEffect( "fUI_Skill_Cooltime01", false, 2.5, 7.0 )
						Panel_CoolTime_Effect_Item_Slot:SetPosX( skillSlotItemPosX - 7 )
						Panel_CoolTime_Effect_Item_Slot:SetPosY( skillSlotItemPosY - 10 )
					end
				end
			elseif	CppEnums.QuickSlotType.eSkill == quickSlotInfo._type	then
				if (nil == slot.skill) then
					break
				end
				local skillStaticWrapper = getSkillStaticStatus( quickSlotInfo._skillKey:getSkillNo(), quickSlotInfo._skillKey:getLevel() )
				if ( nil ~= skillStaticWrapper ) then	
					if (skillStaticWrapper:isUsableSkill()) then
						slot.skill.icon:SetMonoTone( false )
					else
						slot.skill.icon:SetMonoTone( true )
					end
				end
				
				local remainTime = getSkillCooltime( slot.keyValue:get() )
				local skillReuseTime = skillStaticWrapper:get()._reuseCycle / 1000
				local realRemainTime = remainTime * skillReuseTime
				local intRemainTime = realRemainTime - realRemainTime % 1 + 1
				if ( 0 < remainTime ) then
					slot.skill.cooltime:UpdateCoolTime( remainTime )
					slot.skill.cooltime:SetShow( true )
					slot.skill.cooltimeText:SetText( Time_Formatting_ShowTop(intRemainTime) )
					if ( intRemainTime <= skillReuseTime ) then
						slot.skill.cooltimeText:SetShow( true )
					else
						slot.skill.cooltimeText:SetShow( false )
					end
				else
					if ( slot.skill.cooltime:GetShow() ) then
						------------------------------------------------
						-- 	  	캐릭터 우측에 뜨는 쿨타임 해제!
						------------------------------------------------
						slot.skill.cooltime:SetShow( false )
						slot.skill.cooltimeText:SetShow( false )
						
						local skillSlotPosX = slot.skill.cooltime:GetParentPosX()
						local skillSlotPosY = slot.skill.cooltime:GetParentPosY()
						
						Panel_CoolTime_Effect_Slot:SetShow( true, true )
						Panel_CoolTime_Effect_Slot:SetIgnore(true)
						
						-- ♬ 쿨타임이 다 찼을 때 사운드 추가
						Panel_CoolTime_Effect_Slot:AddEffect( "fUI_Skill_Cooltime01", false, 2.5, 7.0 )
						Panel_CoolTime_Effect_Slot:SetPosX( skillSlotPosX - 7 )
						Panel_CoolTime_Effect_Slot:SetPosY( skillSlotPosY - 8 )
					end
				end
			end
		end
	end

	if 3 < onEffectTime then
		onEffectTime = 0
	end
end

Panel_Chat0:RegisterUpdateFunc("NewQuickSlot_UpdatePerFrame")


registerEvent("refreshQuickSlot_ack",		"FromClient_NewQuickSlot_Update")
registerEvent("FromClient_InventoryUpdate",	"FromClient_NewQuickSlot_Update")
registerEvent("onScreenResize", 			"Panel_NewQuickSlot_PositionReset")
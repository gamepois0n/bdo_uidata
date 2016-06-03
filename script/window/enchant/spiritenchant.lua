local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM			= CppEnums.TextMode
local UI_TT			= CppEnums.PAUI_TEXTURE_TYPE

Panel_Window_Enchant:setMaskingChild(true)
Panel_Window_Enchant:setGlassBackground(true)
Panel_Window_Enchant:SetDragEnable(true)
Panel_Window_Enchant:SetDragAll(true)

Panel_Window_Enchant:RegisterShowEventFunc( true, 'Enchant_ShowAni()' )
Panel_Window_Enchant:RegisterShowEventFunc( false, 'Enchant_HideAni()' )

local enchantCountValue 			= 0
local	Xgap						= 7
local enchantEquipTypeValue			= nil
local enchantClassifyValue			= nil
local enchantPerfectEnduranceValue	= 3
local isEnchantSafeTypeValue		= 0		-- 안전 인첸트 타입
local isItemKey						= nil
local isCash						= nil
local isEnchantLevel				= 0
local perfectNeedCount				= 0

local isContentsEnable 				= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 74 ) -- 크론석 컨텐츠.

----------------------------------------------------------------------------------
-- 단순 핼프 메시지
local EnchantHelpMessage = 
{
	_helpTargetItem 		= UI.getChildControl ( Panel_Window_Enchant, "StaticText_Notice_Slot_0" ),
	_helpEnchantItem 		= UI.getChildControl ( Panel_Window_Enchant, "StaticText_Notice_Slot_1" ),
	_helpEnchantBtn			= UI.getChildControl ( Panel_Window_Enchant, "StaticText_Notice_Enchant" ),
	_helpPerfectEnchant		= UI.getChildControl ( Panel_Window_Enchant, "StaticText_Notice_GoGoGo" ),
	_helpEnchantFailCnt		= UI.getChildControl ( Panel_Window_Enchant, "StaticText_EnchantFailCount" ),
	_enchantFailDesc		= UI.getChildControl ( Panel_Window_Enchant, "StaticText_EnchantFailDesc" ),
	_enchantPackFailCnt		= UI.getChildControl ( Panel_Window_Enchant, "StaticText_EnchantFailPackCount" ),
	_enchantPcroomFailCnt	= UI.getChildControl ( Panel_Window_Enchant, "StaticText_EnchantFailPcroomCount" ),
	_enchantBottomDesc		= UI.getChildControl ( Panel_Window_Enchant, "StaticText_Comment"),
}

local _buttonQuestion = UI.getChildControl ( Panel_Window_Enchant, "Button_Question" )		-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp",  "Panel_WebHelper_ShowToggle( \"SpiritEnchant\" )" )								-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"SpiritEnchant\", \"true\")" )		-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"SpiritEnchant\", \"false\")" )		-- 물음표 마우스아웃

local Enchant_fadeInSCR_Down = function( panel )
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
	-- for key, value in pairs(onlySocketListBG) do
	-- 	local socketBG_1 = value:addColorAnimation( 0.0, 0.50, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	-- 	socketBG_1:SetStartColor( UI_color.C_00626262 )
	-- 	socketBG_1:SetEndColor( UI_color.C_FF626262 )
	-- end

	local aniInfo8 = panel:addColorAnimation( 0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 3.0 )
	aniInfo8:SetEndIntensity( 1.0 )
end

-- 보여주기 애니메이션
function Enchant_ShowAni()
	-- Enchant_fadeInSCR_Down(Panel_Window_Enchant)
	audioPostEvent_SystemUi(01,00)
	local aniInfo1 = Panel_Window_Enchant:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.13)
	aniInfo1.AxisX = Panel_Window_Enchant:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_Enchant:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_Enchant:addScaleAnimation( 0.08, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.13)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_Enchant:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_Enchant:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end
-- 끄기 애니메이션
function Enchant_HideAni()
	local enchantHide = UIAni.AlphaAnimation( 0, Panel_Window_Enchant, 0.0, 0.2 )
	enchantHide:SetHideAtEnd(true)
	audioPostEvent_SystemUi(01,01)
end

local btnMouseOnCount = 0
local enchantHelpDesc = ""
function HandleOn_ShowHelpDesc( isShow )

	if 16 <= enchantCountValue then
		return
	end

	-- if ( 0 == btnMouseOnCount%3 ) then
	-- 	enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_1" )		-- 블랙스톤 하나를 소모해 장비를 강화할 수 있어.
	-- elseif ( 1 == btnMouseOnCount%3 ) then
	-- 	enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_2" )		-- 무기는 +7까지, 방어구는 +5까지 실패없이 안전하게 강화할 수 있어.
	-- else
	-- 	enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_3" )		-- 돌파에 실패하면 장비의 최대 내구도가 떨어지니 주의해!
	-- end

------------------------------------------------
---- 안전 인첸트 타입이 어떤 것인가!?(isEnchantSafeTypeValue)
---- 0 :: 안전 강화 구간
---- 1 :: 위험 구간(인첸트 실패할 경우)
---- 2 :: 파괴 확률 있음(장신규, 채집복)
---- 3 :: 하락 확률 있음(손 화포[인첸트 실패와는 다름.])
---- 4 :: 하락하거나 파괴될 확률 있음(아직 미사용?)
------------------------------------------------
	--{ 잠재력 돌파에 인첸트 시킬 아이템을 올렸을 때 뿌려줄 툴팁 DESC
		if 0 == isEnchantSafeTypeValue then
			if 1 == enchantClassifyValue or 2 == enchantClassifyValue then	-- 무기, 보조무기
				if ( 0 == btnMouseOnCount%3 ) then
					enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_1" )		-- 블랙스톤 하나를 소모해 장비를 강화할 수 있어.
				elseif ( 1 == btnMouseOnCount%3 ) then
					if (10073 == isItemKey) or (10273 == isItemKey) or (10473 == isItemKey) or (10673 == isItemKey) or (13273 == isItemKey) or (13373 == isItemKey)	or (14473 == isItemKey)  then -- 초보자용 아이템
						enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_NEWBIEWEAPONE" )
					else
						enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_WEAPONE" )
					end
				else
					if isCash then
						enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_4")
					else
						enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_1" )		-- 블랙스톤 하나를 소모해 장비를 강화할 수 있어.
					end
				end
			elseif 3 == enchantClassifyValue then	-- 방어구
				if ( 0 == btnMouseOnCount%3 ) then
					enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_1" )		-- 블랙스톤 하나를 소모해 장비를 강화할 수 있어.
				elseif ( 1 == btnMouseOnCount%3 ) then
					enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_ARMOR" )
				end
			else
				if isCash then
					enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_4") -- 이 아이템은 '흑정령의 발톱'으로 강화할 수 있어.
				else
					enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DESC_1" )		-- 블랙스톤 하나를 소모해 장비를 강화할 수 있어.
				end
			end
		elseif 1 == isEnchantSafeTypeValue then
			enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_FAIL") -- 지금 올린 아이템은 돌파할 때 <PAColor0xFFF26A6A>실패<PAOldColor>할 확률이 있어!
		elseif 2 == isEnchantSafeTypeValue then
			enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_DESTORYED") -- 지금 올린 아이템은 돌파할 때 <PAColor0xFFF26A6A>실패하면 파괴<PAOldColor>되니 주의해!
		elseif 3 == isEnchantSafeTypeValue then
			enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_COUNTDOWN") -- 지금 올린 아이템은 돌파할 때 <PAColor0xFFF26A6A>실패하면 강화 하락<PAOldColor>하니까 주의해!
		elseif 4 == isEnchantSafeTypeValue then
			enchantHelpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_DESTORYED_AND_COUNTDOWN") -- 지금 올린 아이템은 돌파할 때 <PAColor0xFFF26A6A>실패하면 강화 하락하거나 파괴<PAOldColor>되니 주의해!
		end
	--}
	local self = EnchantHelpMessage
	self._helpEnchantBtn:SetShow( isShow )
	self._helpEnchantBtn:SetNotAbleMasking( true )
	self._helpEnchantBtn:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._helpEnchantBtn:SetAutoResize( true )
	self._helpEnchantBtn:SetText( enchantHelpDesc )
	local boxSizeY = self._helpEnchantBtn:GetTextSizeY() + 30
	if boxSizeY < 70 then
		boxSizeY = 70
	end
	self._helpEnchantBtn:SetSize( self._helpEnchantBtn:GetSizeX(), boxSizeY )

	if true == isShow then
		btnMouseOnCount = btnMouseOnCount + 1
		-- self._helpPerfectEnchant:SetShow( false )
	end
end

function EnchantHelpMessage:setNeedPerfectEnchantItemCount(needCount)
	if(0 < needCount) then
		self._helpPerfectEnchant:SetShow( true )
		self._helpPerfectEnchant:SetNotAbleMasking( true )
		self._helpPerfectEnchant:SetTextMode( UI_TM.eTextMode_AutoWrap )
		self._helpPerfectEnchant:SetAutoResize( true )
		self._helpPerfectEnchant:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_BLACKSTONE_COUNT", "needCount", needCount) .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_DECREASEENDURANCE_PERFECTENCHANT", "enchantPerfectEnduranceValue", enchantPerfectEnduranceValue ) )
		local boxSizeY	= self._helpPerfectEnchant:GetTextSizeY() + 30
		if boxSizeY < 70 then
			boxSizeY = 70
		end
		self._helpPerfectEnchant:SetSize( self._helpPerfectEnchant:GetSizeX() + Xgap, boxSizeY )
	else
		self._helpPerfectEnchant:SetShow( false )
		self._helpPerfectEnchant:SetSize( 220, 70 )
	end
end

------------------------------------------------------------------------------------
local EnchantManager =
{
	_constEnchantProgressTime 	= 4.0,		-- 진행되는 초를 설정한다 (Progress Bar)
	_enchantItemType 			= 0,				-- 0: 무기, 1: 방어구
	_slotConfig =
	{
		createIcon 		= false,
		createBorder 	= true,
		createCount 	= true,
		createEnchant 	= true,
		createCash		= true
	},
	
	_buttonApply 		= UI.getChildControl( Panel_Window_Enchant, "Button_Apply" ),		-- 강화
	_buttonSureSuccess	= UI.getChildControl( Panel_Window_Enchant, "Button_GoGoGo" ),		-- 무조건 강화
	_enchantEffect 		= UI.getChildControl( Panel_Window_Enchant, "Static_AddEffect" ),
	_skipEnchant		= UI.getChildControl( Panel_Window_Enchant, "CheckButton_SkipEnchant"),	-- 강화 이펙트 생략

	-- { 강화 수치 하락 보호
		_protectItem_BG		= UI.getChildControl( Panel_Window_Enchant, "Static_ProtectItemBG"),
		_protectItem_Icon	= UI.getChildControl( Panel_Window_Enchant, "Static_ProtectItemSlot"),
		_protectItem_Count	= UI.getChildControl( Panel_Window_Enchant, "StaticText_ProtectItemCount"),
		_protectItem_Name	= UI.getChildControl( Panel_Window_Enchant, "StaticText_ProtectItemName"),
		_protectItem_Desc	= UI.getChildControl( Panel_Window_Enchant, "StaticText_ProtectItemDesc"),
		_protectItem_Btn	= UI.getChildControl( Panel_Window_Enchant, "CheckButton_ProtectItem"),
		_protectItem_SlotNo	= nil,
	-- }	

	_slotTargetItem		= {},
	_slotEnchantItem	= {},
	
	_isStartEnchantNormal		= false,
	_isStartEnchantSureSuccess	= false,
	_currentTime				= 0,
	_isDoingEnchant				= false,
}

function EnchantManager:clear()
	EnchantHelpMessage._helpPerfectEnchant:SetShow( false )
	EnchantHelpMessage._helpPerfectEnchant:SetSize( 220, 60 )
	self._slotTargetItem:clearItem()
	self._slotTargetItem.empty			= true
	self._slotTargetItem.slotNo			= nil
	self._slotTargetItem.inventoryType	= nil
	
	self._slotEnchantItem:clearItem()
	self._slotEnchantItem.empty			= true
	self._slotEnchantItem.slotNo		= nil
	self._slotEnchantItem.inventoryType	= nil

	--self._slotTargetItem.icon:EraseAllEffect()
	self._slotEnchantItem.icon:EraseAllEffect()
	--self._enchantEffect:EraseAllEffect()
	self._buttonApply:EraseAllEffect()
	
	-- self._skipEnchant:SetCheck(false)
	self._buttonApply:SetIgnore(true);
	-- self._buttonApply:SetMonoTone(true);
	self._buttonSureSuccess:SetIgnore(true);
	self._buttonSureSuccess:SetShow(true)
	
	self._isStartEnchantNormal		= false;
	self._isStartEnchantSureSuccess	= false;
	self._isDoingEnchant			= false;
	self._buttonApply:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ENCHANT_DOENCHANT" ) )		-- 돌파!	
	
	getEnchantInformation():clearData()
end
function EnchantManager:isStartEnchant()
	return (self._isStartEnchantNormal or self._isStartEnchantSureSuccess)
end
function EnchantManager:isDoingEnchant()
	return self._isDoingEnchant;
end

-- local DefaultEquipmentPosX = nil
function EnchantManager:show()
	-- INVENTORY_FILTER ON ENCHANT_MAIN_ITEM
	self._slotTargetItem.icon:EraseAllEffect()
	self._slotEnchantItem.icon:EraseAllEffect()
	self._enchantEffect:EraseAllEffect()
	self._protectItem_Btn:SetCheck( false )
	self:clear()
	
	Inventory_SetFunctor( Enchant_InvenFiler_MainItem, HandleEnchant_InteractortionFromInventory, FGlobalEnchant_Hide, nil  )
	FGlobal_SetInventoryDragNoUse(Panel_Window_Enchant)
	EnchantHelpMessage._enchantFailDesc:SetShow( false )
	Panel_Window_Enchant:SetShow( true, true )
	-- ♬ 창을 열 때 사운드 추가
	audioPostEvent_SystemUi(01,00)

	-- 인벤토리와 장비창을 연다.
	InventoryWindow_Show()
	Equipment_PosSaveMemory() -- 이전 위치를 저장한다.
	Panel_Equipment:SetShow(true, true)
	Panel_Equipment:SetPosX(10)
	Panel_Equipment:SetPosY( getScreenSizeY() - (getScreenSizeY()/2) - (Panel_Equipment:GetSizeY()/2) ) -- 모르겠지만, 시간 지연
	btnMouseOnCount = 0
	enchantHelpDesc = ""

	Panel_Window_Enchant:SetEnableArea(0,0,530,25)

	if isContentsEnable then
		EnchantManager:SetProtectItem()	-- 강화 수치 하락 슬롯을 세팅한다.
	end
	EnchantManager._protectItem_BG		:SetShow( isContentsEnable )
	EnchantManager._protectItem_Icon	:SetShow( isContentsEnable )
	EnchantManager._protectItem_Name	:SetShow( isContentsEnable )
	EnchantManager._protectItem_Desc	:SetShow( isContentsEnable )
	EnchantManager._protectItem_Count	:SetShow( isContentsEnable )
	EnchantManager._protectItem_Btn		:SetShow( isContentsEnable )

	if isContentsEnable then
		EnchantHelpMessage._enchantFailDesc:SetSpanSize( EnchantHelpMessage._enchantFailDesc:GetSpanSize().x, 120 )
	else
		EnchantHelpMessage._enchantFailDesc:SetSpanSize( EnchantHelpMessage._enchantFailDesc:GetSpanSize().x, 170 )
	end
end

function EnchantManager:hide()
	Equipment_PosLoadMemory()	-- 이전 위치를 불러온다.
	Panel_Window_Enchant:SetShow( false, false )
	ToClient_BlackspiritEnchantClose()
	
	--Inventory_SetFunctor( Enchant_InvenFiler_MainItem, HandleEnchant_InteractortionFromInventory, FGlobalEnchant_Hide  )
	
	self:clear()
	-- end
	local self = EnchantHelpMessage
	self._helpEnchantBtn:SetShow( false )
end


-- { 강화 수치 하락 보호
	function EnchantManager:ProtectItemCount()
		local selfPlayerWrapper	= getSelfPlayer()
		local selfPlayer		= selfPlayerWrapper:get()
		local useStartSlot		= inventorySlotNoUserStart()
		local normalInventory	= selfPlayer:getInventoryByType( CppEnums.ItemWhereType.eInventory )
		local invenUseSize		= selfPlayer:getInventorySlotCount( false )	-- 열려있는 일반 인벤토리 사이즈
		local protectItemSSW	= FromClient_getPreventDownGradeItem()
		if nil ~= protectItemSSW then
			local protectItemName	= protectItemSSW:getName()
			local protectItemSlotNo	= nil
			local protectItemCount	= 0
			for idx = useStartSlot, invenUseSize -2 do
				local itemWrapper	= getInventoryItemByType( CppEnums.ItemWhereType.eInventory, idx )
				if nil ~= itemWrapper then
					local itemSSW		= itemWrapper:getStaticStatus()
					local itemName		= itemSSW:getName()
					if protectItemName == itemName then
						protectItemSlotNo	= idx
						protectItemCount	= getInventoryItemByType( CppEnums.ItemWhereType.eInventory, idx ):get():getCount_s64()
						break
					end
				end
			end
			if nil ~= protectItemSlotNo then
				return protectItemSlotNo, protectItemCount
			else
				return protectItemSlotNo, toInt64(0,0)
			end
		end
	end

	function EnchantManager:SetProtectItem( itemKey, enchantLevel )	-- 강화 수치 보호 세팅
		local itemSSW	= FromClient_getPreventDownGradeItem()
		if nil ~= itemSSW then
			local name		= itemSSW:getName()
			self._protectItem_Icon	:ChangeTextureInfoName( "Icon/" .. itemSSW:getIconPath() )
			self._protectItem_Icon	:SetMonoTone( false )

			local needCount			= toInt64(0,0)
			local haveCount			= toInt64(0,0)
			if nil ~= itemKey then
				needCount	= getEnchantInformation():getNeedCountPreventDownGradeItem( itemKey )
			end

			self._protectItem_SlotNo, haveCount = EnchantManager:ProtectItemCount()
			self._protectItem_Btn	:SetIgnore( true )
			self._protectItem_Btn	:SetMonoTone( true )

			if haveCount < needCount then
				haveCount = "<PAColor0xFFF26A6A>" .. tostring(haveCount) .. "<PAOldColor>"	-- C_FFF26A6A
				if self._protectItem_Btn:IsCheck() then
					self._protectItem_Btn:SetCheck( false )
				end
			end

			if nil ~= enchantLevel then
				if 15 < enchantLevel then
					self._protectItem_Icon	:SetMonoTone( false )
					self._protectItem_Btn	:SetIgnore( false )
					self._protectItem_Btn	:SetMonoTone( false )
				else
					self._protectItem_Icon	:SetMonoTone( true )
					self._protectItem_Btn	:SetIgnore( true )
					self._protectItem_Btn	:SetMonoTone( true )
				end
			end

			self._protectItem_Count		:SetText( tostring(haveCount) .. "/" .. tostring(needCount) )
			self._protectItem_Icon		:addInputEvent("Mouse_On",	"HandleOnOut_protectItemToolTip( true )")
			self._protectItem_Icon		:addInputEvent("Mouse_Out",	"HandleOnOut_protectItemToolTip( false )")
			self._protectItem_Icon		:setTooltipEventRegistFunc( "HandleOnOut_protectItemToolTip( true )" )
		end
	end

	function HandleOnOut_protectItemToolTip( isShow )
		local itemSSW	= FromClient_getPreventDownGradeItem()
		if isShow then
			registTooltipControl(EnchantManager._protectItem_Icon, Panel_Tooltip_Item)
			Panel_Tooltip_Item_Show( itemSSW,  EnchantManager._protectItem_Icon, true, false, nil, nil, nil )
		else
			Panel_Tooltip_Item_hideTooltip()
		end
	end
-- }

--------------------------------------------------------
--					강화 시작할 때
--------------------------------------------------------
function EnchantManager:startEnchant( isSureSuccess )
	-- ♬ 강화를 시작했다
	audioPostEvent_SystemUi(05,06)
	audioPostEvent_SystemUi(05,09)	
	self._currentTime = 0
	self._isStartEnchantNormal	= (false == isSureSuccess)
	self._isStartEnchantSureSuccess	= isSureSuccess
	
	self._slotTargetItem.icon:EraseAllEffect()
	self._slotEnchantItem.icon:EraseAllEffect()
	self._enchantEffect:EraseAllEffect()
	
	self._isDoingEnchant = true;
		
	self._slotTargetItem.icon:AddEffect( "fUI_LimitOver01A", false, 0, 0 )
	self._slotEnchantItem.icon:AddEffect( "fUI_LimitOver01A", false, 0, 0 )
	self._enchantEffect:AddEffect("fUI_LimitOver02A", true, 0, 0)
			
	if ( self._enchantItemType == 0 ) then			-- 무기
		self._enchantEffect:AddEffect( "UI_LimitOverLine", false, 0, 0 )
		self._enchantEffect:AddEffect( "fUI_LimitOver_Spark", false, 0, 0 )
	elseif ( self._enchantItemType == 1 ) then		-- 방어구
		self._enchantEffect:AddEffect( "UI_LimitOverLine_Red", false, 0, 0 )
		self._enchantEffect:AddEffect( "fUI_LimitOver_Spark", false, 0, 0 )
	end		
	-----------------------------------------------------
	-- 			돌파 중 취소버튼으로 바꿔준다
	-----------------------------------------------------
	self._buttonSureSuccess:SetIgnore( true )

	-- self._buttonApply:SetEnable( true )

	self._buttonApply:EraseAllEffect()
	self._buttonApply:SetAlpha( 1.0 )
	self._buttonApply:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ENCHANT_CANCEL" ) )		-- 돌파 취소
	self._buttonApply:SetFontColor( UI_color.C_FFC4BEBE )

	ToClient_BlackspiritEnchantStart()		-- 흑정령 애니메이션 시작해라/ 애니는 한번만!
end
function EnchantManager:doEnchant()
	EnchantManager._isDoingEnchant = false;
	getEnchantInformation():doEnchant(self._isStartEnchantSureSuccess);
end

function HandleClickedSkipEnchant()	
	EnchantManager._isDoingEnchant = false;
	getEnchantInformation():doEnchant( false );
end
function HandleClickedSkipPerfectEnchant()
	EnchantManager._isDoingEnchant = false;
	getEnchantInformation():doEnchant( true );
end
function EnchantManager:cancelEnchant()
	EnchantManager:clear()
	Inventory_SetFunctor( Enchant_InvenFiler_MainItem, HandleEnchant_InteractortionFromInventory, FGlobalEnchant_Hide, nil  )
	self._slotTargetItem.icon:EraseAllEffect()
	self._slotEnchantItem.icon:EraseAllEffect()
	self._enchantEffect:EraseAllEffect()

	self._buttonSureSuccess	:SetFontColor( UI_color.C_FF626262 )
	self._buttonApply		:SetFontColor( UI_color.C_FF626262 )
	self._protectItem_Btn	:SetIgnore( false )
	self._protectItem_Btn	:SetCheck( false )

	ToClient_BlackspiritEnchantCancel();
end
function EnchantManager:successEnchant()
	render_setChromaticBlur( 40, 1.0 )
	render_setPointBlur( 0.05, 0.045 )
	render_setColorBypass( 0.85, 0.08 )
				
	ToClient_BlackspiritEnchantSuccess()
	self._buttonApply:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ENCHANT_DOENCHANT" ) )		-- 돌파!
	EnchantFailCount()
end
function EnchantManager:failEnchant()
	ToClient_BlackspiritEnchantFail();
	self._buttonApply:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ENCHANT_DOENCHANT" ) )		-- 돌파!
	EnchantFailCount()
end
function EnchantManager:initialize()
	EnchantHelpMessage._helpPerfectEnchant:SetShow( false )
	EnchantHelpMessage._helpPerfectEnchant:SetSize( 220, 60 )
	EnchantHelpMessage._enchantFailDesc:SetShow( false )
	EnchantHelpMessage._enchantFailDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	EnchantHelpMessage._enchantFailDesc:SetText( PAGetString(Defines.StringSheet_RESOURCE, "UI_SPRITENCHANT_DESC") )

	self._buttonApply		:addInputEvent( "Mouse_LUp", "HandleClickedEnchantApplyButton()" )
	self._buttonSureSuccess	:addInputEvent( "Mouse_LUp", "HandleClickedSureSuccessButton()" )

	self._buttonSureSuccess:SetShow( true )
	self._skipEnchant:SetCheck(false)
	self._skipEnchant:SetEnableArea( 0, 0, self._skipEnchant:GetSizeX()+60, self._skipEnchant:GetSizeY() )

	self._slotTargetItem.icon = UI.getChildControl( Panel_Window_Enchant, "Static_Slot_0" )
	SlotItem.new( self._slotTargetItem, 'Slot_0', 0, Panel_Window_Enchant, self._slotConfig )
	self._slotTargetItem:createChild()
	self._slotTargetItem.empty = true
	
	Panel_Tooltip_Item_SetPosition(0, self._slotTargetItem, "Enchant")

	self._slotEnchantItem.icon = UI.getChildControl( Panel_Window_Enchant, "Static_Slot_1" )
	SlotItem.new( self._slotEnchantItem, 'Slot_1', 1, Panel_Window_Enchant, self._slotConfig )
	self._slotEnchantItem:createChild()
	self._slotEnchantItem.empty = true
	
	self._currentTime = 0
	
	Panel_Tooltip_Item_SetPosition(1, self._slotEnchantItem, "Enchant")
	
	self._slotEnchantItem.icon:addInputEvent("Mouse_RUp", "HandleClickedEnchantSlotCancel()")
	self._slotTargetItem.icon:addInputEvent("Mouse_RUp", "HandleClickedEnchantSlotCancel()")

	EnchantManager._buttonApply:addInputEvent( "Mouse_On", "HandleOn_ShowHelpDesc(true)" )
	EnchantManager._buttonApply:addInputEvent( "Mouse_Out", "HandleOn_ShowHelpDesc(false)" )

	EnchantManager._buttonSureSuccess:addInputEvent( "Mouse_On", "HandleOnSureSuccessButton()" )
	EnchantManager._buttonSureSuccess:addInputEvent( "Mouse_Out", "HandleOutSureSuccessButton()" )
	
	EnchantManager._slotTargetItem.icon:addInputEvent( "Mouse_On",	"EnchantManager_HandleOnEnchantItem()" )
	EnchantManager._slotTargetItem.icon:addInputEvent( "Mouse_Out",	"EnchantManager_HandleOutEnchantItem()" )
	
	EnchantManager._slotEnchantItem.icon:addInputEvent( "Mouse_On",	"EnchantManager_HandleOnTargetItem()" )
	EnchantManager._slotEnchantItem.icon:addInputEvent( "Mouse_Out","EnchantManager_HandleOutTargetItem()" )

	EnchantManager._skipEnchant:addInputEvent( "Mouse_On", "EnchantManager_SimpleTooltips(true)" )
	EnchantManager._skipEnchant:addInputEvent( "Mouse_Out", "EnchantManager_SimpleTooltips(false)" )

	if (5 == getGameServiceType() or 6 == getGameServiceType()) then
		EnchantHelpMessage._enchantBottomDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_PCROOMENCHANT_DESC_JP") )
	else
		EnchantHelpMessage._enchantBottomDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_PCROOMENCHANT_DESC") )
	end

	EnchantFailCount()
end

function HandleClickedEnchantSlotCancel()
	EnchantManager:cancelEnchant()
	HandleOn_ShowHelpDesc( false )
	EnchantManager._protectItem_Btn:SetCheck( false )
	if isContentsEnable then
		EnchantManager:SetProtectItem()
	end
	-- EnchantManager._buttonSureSuccess:SetText( "강제돌파" )
end

-----------------------------------------------------
-----------------------------------------------------
function HandleClickedEnchantApplyButton()
	if (EnchantManager:isDoingEnchant()) then
		EnchantManager:cancelEnchant()
	else
		local isProtect = EnchantManager._protectItem_Btn:IsCheck()
		if isProtect then
			getEnchantInformation():setPreventDownGradeItem( CppEnums.ItemWhereType.eInventory, EnchantManager._protectItem_SlotNo )
		else
			getEnchantInformation():setPreventDownGradeItem( CppEnums.ItemWhereType.eInventory, 255 )
		end

		local skipCheck = EnchantManager._skipEnchant:IsCheck()
		if skipCheck then
			HandleClickedSkipEnchant()
		else
			EnchantManager:startEnchant( false )
		end
	end
end
function HandleClickedSureSuccessButton()
	local skipCheck = EnchantManager._skipEnchant:IsCheck()
	
	if skipCheck then
		if (EnchantManager:isDoingEnchant()) then
			EnchantManager:cancelEnchant()
		else
			HandleClickedSkipPerfectEnchant()
		end
	else
		if(EnchantManager:isDoingEnchant()) then
			EnchantManager:cancelEnchant()
		else
			EnchantManager:startEnchant( true )
		end
	end

end

function EnchantFailCount()
	local self				= EnchantHelpMessage
	local selfPlayer		= getSelfPlayer():get()
	local failCount			= selfPlayer:getEnchantFailCount()		-- 일반적인 실패 카운팅
	-- local failCountPcroom	= selfPlayer:getEnchantPcRoomCount()	-- PC방 추가 스택
	local failCountPack		= selfPlayer:getEnchantValuePackCount()	-- 유료 아이템 구매 추가 스택
	-- 일반 잠재력 돌파 스택
	self._helpEnchantFailCnt:SetShow( true )
	self._helpEnchantFailCnt:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_HELP", "failCount", failCount ) )
	-- 프리미엄 PC방 스택 삭제 >> 발크스 외침으로 변경!! 2015.08.19
	if isGameTypeJapan() then
		self._enchantPcroomFailCnt:SetShow( true )
	elseif isGameTypeRussia() then	
		self._enchantPcroomFailCnt:SetShow( true )
	elseif isGameTypeKorea() then
		self._enchantPcroomFailCnt:SetShow( true )
	elseif isGameTypeEnglish() then
		self._enchantPcroomFailCnt:SetShow( false )
	end
	
	-- self._enchantPcroomFailCnt:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_PCROOMENCHANTCOUNT", "pcCount", math.floor(failCountPcroom/6)))
	self._enchantPcroomFailCnt:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_VALKSCOUNT", "count", failCountPack))
	-- 유료 아이템 구매 추가 스택
	-- if 0 < failCountPack then
		-- self._helpEnchantFailCnt:SetSpanSize( -25, 210 )
		-- self._enchantPackFailCnt:SetShow( true )	-- 사용하지 않음.
	-- else
		self._helpEnchantFailCnt:SetSpanSize( 0, 48 ) -- 0, 210 )
		-- self._enchantPackFailCnt:SetShow( false )
	-- end
	self._enchantPackFailCnt:SetText( "( <PAColor0xffffbc1a>+" .. failCountPack .. "<PAOldColor> )" )
end

-----------------------------------------------------
-- 				160초 후에 계속 됩니다.
-----------------------------------------------------
function Enchant_InvenFiler_MainItem( slotNo, notUse_itemWrappers, whereType )
	local itemWrapper = getInventoryItemByType( whereType, slotNo )
	if nil == itemWrapper then
		return true
	end
	-- 강화 불가능이면 true 를 리턴, 가능하면 false
	return( false == itemWrapper:checkToEnchantItem(false) )
end
function Enchant_InvenFiler_SubItem( slotNo, notUse_itemWrappers, whereType )
	local itemWrapper = getInventoryItemByType( whereType, slotNo )
	if nil == itemWrapper then
		return true
	end

	-- 현재 의상 강화 재료 아이템이 펄 가방에 들어있지 않기 때문에,
	-- 재료 슬롯 등록할 때 캐쉬 가방 필터를 막지만 나중엔 풀어야할 수도 있다. 2015-09-16 태곤.
	if CppEnums.ItemWhereType.eCashInventory == whereType then
		return true
	end

	local returnValue = true


	local self = EnchantManager
	-- 유효하지 않은 재료 아이템이면 true 를 리턴
	-- 동일한 아이템을 올려놓지 못하게 필터를 건다.	
	if 0 ~= getEnchantInformation():checkIsValidSubItem( slotNo ) then
		returnValue = true
	else
		returnValue = false
		if self._slotTargetItem.slotNo == slotNo and (CppEnums.ItemWhereType.eInventory ~= whereType) then
			returnValue = true
		end
	end

	return returnValue
end


function HandleEnchant_InteractortionFromInventory( slotNo, itemWrapper, count, inventoryType )
	local	self			= EnchantManager
	local	enchantInfo		= getEnchantInformation()
	local	rv				= enchantInfo:SetEnchantSlot( inventoryType, slotNo )
	if( 0 ~= rv )	then
		return
	end
	if ( self._slotTargetItem.empty ) then
		-- 들어오는대로 이펙트를 뿌려준다
		if ( self._slotTargetItem.icon ) then
			-- ♬ 아이템을 박았다
			audioPostEvent_SystemUi(00,16)
			self._slotTargetItem.icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
		end
		self._slotTargetItem.empty			= false
		self._slotTargetItem.slotNo			= slotNo
		self._slotTargetItem.inventoryType	= inventoryType
		itemWrapper = getInventoryItemByType( inventoryType, slotNo )
		local enchantSSW				= itemWrapper:getStaticStatus()
		local perfectEnchantLevel 		= enchantSSW:get()._key:getEnchantLevel()+1;	-- +1을 해줘야 다음 인첸트에 해당하는 최대 내구도 소모값을 가져온다.
		local enchantItemKey			= ItemEnchantKey( enchantSSW:get()._key:getItemKey(), perfectEnchantLevel )
		enchantItemKey:set( enchantSSW:get()._key:getItemKey(), perfectEnchantLevel )
		local perfectEnchantSSW			= getItemEnchantStaticStatus( enchantItemKey )
		local enchantPerfectEndurance	= perfectEnchantSSW:get():getReduceMaxEnduranceAtPerfectEnchant()
		local isEnchantSafeType			= perfectEnchantSSW:getEnchantType()
		local enchantEquipType			= itemWrapper:getStaticStatus():getEquipType()
		local enchantItemClassify		= itemWrapper:getStaticStatus():getItemClassify()
		local isCashItem				= itemWrapper:getStaticStatus():get():isCash()
		local enchantCount				= itemWrapper:get():getKey():getEnchantLevel()

		enchantEquipTypeValue			= enchantEquipType
		enchantClassifyValue			= enchantItemClassify
		enchantPerfectEnduranceValue	= enchantPerfectEndurance
		isEnchantSafeTypeValue			= isEnchantSafeType
		isItemKey						= enchantSSW:get()._key:getItemKey()
		isCash							= isCashItem
		isEnchantLevel					= enchantCount

		if 15 <= enchantCount then	-- +15 인챈트 부터.
			EnchantHelpMessage._enchantFailDesc:SetShow( true )
			HandleOn_ShowHelpDesc( false )
			enchantCountValue = enchantCount
			-- EnchantManager._buttonSureSuccess:SetText( "강제돌파(-)" )
		else
			EnchantHelpMessage._enchantFailDesc:SetShow( false )
			HandleOn_ShowHelpDesc( true )
			enchantCountValue = enchantCount
			EnchantHelpMessage:setNeedPerfectEnchantItemCount( itemWrapper:getNeedEnchantItem(true) )
			-- EnchantManager._buttonSureSuccess:SetText( "강제돌파(" .. tostring(itemWrapper:getNeedEnchantItem(true)) .. ")" )
		end
		if isContentsEnable then
			self:SetProtectItem( enchantSSW:get()._key, enchantCount )	-- 강화 수치 하락 보호
		end

		itemWrapper = getInventoryItemByType( inventoryType, slotNo )	-- SetProtectItem 때문에 다시 해야 한다.
		self._slotTargetItem:setItem( itemWrapper )
		
		-- INVENTORY_FILTER ON ENCHANT_SUB_ITEM
		Inventory_SetFunctor( Enchant_InvenFiler_SubItem, HandleEnchant_InteractortionFromInventory, FGlobalEnchant_Hide, nil )
		
	elseif self._slotEnchantItem.empty then

		self._slotEnchantItem.empty			= false
		self._slotEnchantItem.slotNo		= slotNo
		self._slotEnchantItem.inventoryType	= inventoryType
		itemWrapper = getInventoryItemByType( inventoryType, slotNo )
		self._slotEnchantItem:setItem( itemWrapper )

		self._slotEnchantItem.icon:EraseAllEffect()
		-- ♬ 블랙스톤을 박았다
		audioPostEvent_SystemUi(00,07)
		if ( 16002 == itemWrapper:get():getKey():getItemKey() ) then				-- 무기 블랙스톤일 경우
			self._enchantEffect:AddEffect( "fUI_Gauge_Blue", true, 0, 0 )			
			self._slotEnchantItem.icon:AddEffect( "fUI_DarkstoneAura02", false, 0, 0 )
			self._slotEnchantItem.icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
			self._enchantItemType = 0

		elseif ( 16001 == itemWrapper:get():getKey():getItemKey() ) then			-- 방어구 블랙스톤일 경우
			self._enchantEffect:AddEffect("fUI_Gauge_Red", true, 0, 0)
			self._slotEnchantItem.icon:AddEffect("fUI_DarkstoneAura01", true, 0, 0)
			self._slotEnchantItem.icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
			self._enchantItemType = 1
			
		elseif ( 16004 == itemWrapper:get():getKey():getItemKey() ) then			-- 응축된 무기 스톤일 경우
			HandleOn_ShowHelpDesc( false )
		elseif ( 16005 == itemWrapper:get():getKey():getItemKey() ) then			-- 응축된 방어구 스톤일 경우
			HandleOn_ShowHelpDesc( false )
		end

	else
		UI.ASSERT( false, 'Client data, UI data is Mismatch!!!!!' )
		return
	end
	
	-- 잠재력 돌파 가능하다!!
	local enchantable			= (0 == enchantInfo:IsReadyEnchant())
	local enchantablePerfect	= (0 == enchantInfo:IsReadyPerfectEnchant())

	if ( true == enchantable ) then
		self._buttonApply:SetFontColor( UI_color.C_FF96D4FC )
	else
		self._buttonApply:SetFontColor( UI_color.C_FF626262 )
	end

	if(true == enchantablePerfect) then
		self._buttonSureSuccess:SetFontColor( UI_color.C_FFFF8957 )
	else
		self._buttonSureSuccess:SetFontColor( UI_color.C_FF626262 )
	end

	-- { 강제 돌파 여부 처리(사용안함)
		-- local ItemEnchantStaticStatus = getInventoryItemByType( inventoryType, slotNo ):getStaticStatus():get()
		-- if ItemEnchantStaticStatus:isEquipable() then
		-- 	local needCount_Perfect = itemWrapper:getNeedEnchantItem(true)
		-- 	perfectNeedCount = needCount_Perfect
		-- 	if 0 < needCount_Perfect then
		-- 		self._buttonSureSuccess:SetShow(true)
		-- 	else
		-- 		self._buttonSureSuccess:SetShow(true)
		-- 	end
		-- end
	-- }

	self._buttonApply		:SetIgnore( false == enchantable )
	self._buttonSureSuccess	:SetIgnore( false == enchantablePerfect )

	if ( true == enchantable ) then
		HandleOn_ShowHelpDesc( true )
	end

	if 16 <= isEnchantLevel and 3 == isEnchantSafeTypeValue then
		self._protectItem_Btn:SetIgnore( false )
	else
		self._protectItem_Btn:SetCheck( false )
		self._protectItem_Btn:SetIgnore( true )
	end
end

-- 
function UpdateFunc_DoingEnchant( deltaTime )
	local self = EnchantManager
	if (true == EnchantManager:isDoingEnchant() ) then
		EnchantManager._currentTime = EnchantManager._currentTime + deltaTime
		if ( 6 <= EnchantManager._currentTime ) then
			EnchantManager:doEnchant()
		end
		self._protectItem_Btn:SetIgnore( true )
	end
end


function FromClient_EnchantResultShow( resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo )
	local self = EnchantManager
	Inventory_SetFunctor( Enchant_InvenFiler_MainItem, HandleEnchant_InteractortionFromInventory, FGlobalEnchant_Hide, nil  )

	if( 0 == resultType ) then	-- 강화 성공
		-- ♬ 강화를 성공했다
		EnchantManager:successEnchant();
		self._slotTargetItem.icon:AddEffect("UI_ItemEnchant01", false, -6.0, -6.0)
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_SUCCESSENCHANT") ) -- "잠재력 돌파에 성공하였습니다.")
	elseif( 1 == resultType ) then	-- 강화 실패 파괴
		EnchantManager:failEnchant();
	elseif( 2 == resultType ) then	-- 강화 실패 강화 수치 다운
		EnchantManager:failEnchant();
	elseif( 3 == resultType ) then	-- 강화 실패, 변화 없음
		EnchantManager:failEnchant();
	else 
		EnchantManager:failEnchant();
	end
	
	self:clear();
	
	--{
		local	mainInventory = getSelfPlayer():get():getInventoryByType(mainWhereType)
		if false == mainInventory:empty( mainSlotNo ) then
			HandleEnchant_InteractortionFromInventory( mainSlotNo, nil, 0, mainWhereType )
		end
	--}
		
	--{
		local	subInventory = getSelfPlayer():get():getInventoryByType(subWhereType)
		if false == subInventory:empty( subSlotNo ) then
			HandleEnchant_InteractortionFromInventory( subSlotNo, nil, 0, subWhereType )	
		end
	--}
end




function FGlobalEnchant_Show()
	if Panel_Window_Socket:GetShow() then
		Panel_Window_Socket:SetShow( false, false )
	elseif Panel_SkillAwaken:GetShow() then
		Panel_SkillAwaken:SetShow( false, false )
	end
	EnchantFailCount()
	SkillAwaken_Close()
	Panel_Join_Close()
	FGlobal_LifeRanking_Close()
	EnchantManager:show()
	EnchantManager._skipEnchant:SetCheck(false)
end
function FGlobalEnchant_Hide()
	EnchantManager:hide()
	-- if Panel_Equipment:IsShow() then
	-- 	Panel_Equipment:SetShow(false, false)
	-- end
	-- Panel_Equipment:SetPosX(DefaultEquipmentPosX)
	-- DefaultEquipmentPosX = nil
	InventoryWindow_Close()
	Equipment_PosLoadMemory()	-- 이전 위치를 불러온다.
	Panel_Equipment:SetShow( false, false )	
	ToClient_BlackspiritEnchantClose()
end


------------------------------
function HandleOnSureSuccessButton()
	EnchantHelpMessage._helpPerfectEnchant:SetShow( true )
	EnchantHelpMessage._helpEnchantBtn:SetShow( false )
	EnchantHelpMessage._helpPerfectEnchant:SetSize( 220, 75 )
end

function HandleOutSureSuccessButton()
	EnchantHelpMessage._helpPerfectEnchant:SetShow( false )
	-- EnchantHelpMessage._helpPerfectEnchant:SetSize( 220, 60 )
end

function	EnchantItem_FromItemWrapper()
	local	self			= EnchantManager
	if	( nil == self._slotEnchantItem.slotNo )	then
		return(nil)
	end

	return( getInventoryItemByType(self._slotEnchantItem.inventoryType, self._slotEnchantItem.slotNo) )
end

function	EnchantItem_ToItemWrapper()
	local	self			= EnchantManager
	if	( nil == self._slotTargetItem.slotNo )	then
		return(nil)
	end
	
	return( getInventoryItemByType(self._slotTargetItem.inventoryType, self._slotTargetItem.slotNo) )
end

function	EnchantManager_HandleOnTargetItem()
	if ( true == EnchantManager._slotEnchantItem.empty ) then
		EnchantHelpMessage._helpTargetItem:SetShow(true)
		EnchantHelpMessage._helpTargetItem:SetTextMode( UI_TM.eTextMode_AutoWrap )
		EnchantHelpMessage._helpTargetItem:SetAutoResize( true )
		EnchantHelpMessage._helpTargetItem:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_HELPMESSAGE1" )) -- "먼저 장비를 올려놓았다면, 네가 가지고 있는 블랙 스톤을 장비 타입에 맞게 올려놓도록 해. 
		EnchantHelpMessage._helpTargetItem:SetSize( EnchantHelpMessage._helpTargetItem:GetSizeX() + Xgap, EnchantHelpMessage._helpTargetItem:GetSizeY() + 30 )
	else
		Panel_Tooltip_Item_Show_GeneralNormal( 1, "Enchant", true )
	end
end

function	EnchantManager_HandleOutTargetItem()
	if ( true == EnchantManager._slotEnchantItem.empty ) then
		EnchantHelpMessage._helpTargetItem:SetShow(false)
		EnchantHelpMessage._helpTargetItem:SetSize( 220, 60 )
	else
		Panel_Tooltip_Item_Show_GeneralNormal( 1, "Enchant", false )
	end
end

function	EnchantManager_HandleOnEnchantItem()
	if ( true == EnchantManager._slotTargetItem.empty ) then
		EnchantHelpMessage._helpEnchantItem:SetShow( true )
		EnchantHelpMessage._helpEnchantItem:SetTextMode( UI_TM.eTextMode_AutoWrap )
		EnchantHelpMessage._helpEnchantItem:SetAutoResize( true )
		EnchantHelpMessage._helpEnchantItem:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_HELPMESSAGE2" )) -- 블랙 스톤을 넣기 전에 잠재력을 돌파시킬 장비를 하나 올려놓도록 해.
		EnchantHelpMessage._helpEnchantItem:SetSize( EnchantHelpMessage._helpEnchantItem:GetSizeX() + Xgap, EnchantHelpMessage._helpEnchantItem:GetSizeY() + 30 )
	else
		Panel_Tooltip_Item_Show_GeneralNormal( 0, "Enchant", true )
	end
end

function	EnchantManager_HandleOutEnchantItem()
	if ( true == EnchantManager._slotTargetItem.empty ) then
		EnchantHelpMessage._helpEnchantItem:SetShow(false)
		EnchantHelpMessage._helpEnchantItem:SetSize( 220, 60 )
	else
		Panel_Tooltip_Item_Show_GeneralNormal( 0, "Enchant", false )
	end
end

function EnchantManager_OnScreenEvent()
	local sizeX = getScreenSizeX()
	local sizeY = getScreenSizeY()

	Panel_Window_Enchant:SetPosX( (sizeX/2) - (Panel_Window_Enchant:GetSizeX()/2) )
	Panel_Window_Enchant:SetPosY( sizeY - Panel_Window_Enchant:GetPosY() - Panel_Window_Enchant:GetSizeY() )

	Panel_Window_Enchant:ComputePos()
	EnchantHelpMessage._enchantFailDesc:ComputePos()
end

function EnchantManager_SimpleTooltips( isShow )
	local name, desc, control = nil, nil, nil

	name = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPENCHANT_TOOLTIP_NAME")
	desc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPENCHANT_TOOLTIP_DESC")
	control = EnchantManager._skipEnchant

	if isShow == true then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

-----------------------------------------------------------------------------------------
--								일단 초기화 시켜주자
-----------------------------------------------------------------------------------------
EnchantManager:initialize();
Panel_Window_Enchant:RegisterUpdateFunc( "UpdateFunc_DoingEnchant" )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--					결과를 보여준다
registerEvent("EventEnchantResultShow", "FromClient_EnchantResultShow")
registerEvent( "onScreenResize", "EnchantManager_OnScreenEvent" )
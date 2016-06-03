Panel_QuickSlot:SetShow(false, false)
Panel_QuickSlot:SetPosX( (getScreenSizeX() - Panel_QuickSlot:GetSizeX()) / 2 )
Panel_QuickSlot:SetPosY( getScreenSizeY() - Panel_QuickSlot:GetSizeY())

function isUseNewQuickSlot()	-- GlobalUIOption에서 새 퀵슬롯 사용 여부 값을 구한다.
	return	ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(CppEnums.GlobalUIOptionType.NewQuickSlot)
end


-- Panel_quickSlot:ActiveMouseEventEffect( true );
local UI_TM = CppEnums.TextMode

Panel_QuickSlot:RegisterShowEventFunc( true, 'QuickSlot_ShowAni()' )
Panel_QuickSlot:RegisterShowEventFunc( false, 'QuickSlot_HideAni()' )

Panel_CoolTime_Effect_Item_Slot:RegisterShowEventFunc( true, 'QuickSlot_ItemCoolTimeEffect_HideAni()' )
Panel_CoolTime_Effect_Slot:RegisterShowEventFunc( true, 'QuickSlot_SkillCoolTimeEffect_HideAni()' )

local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TISNU 		= CppEnums.TInventorySlotNoUndefined
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 		= Defines.Color

local quickSlotBg			= UI.getChildControl ( Panel_QuickSlot, "Static_Main_BG" )
local quickSlotText			= UI.getChildControl ( Panel_QuickSlot, "StaticText_quickSlot" )
local quickSlot =
{
	-- 설정
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
	config =
	{
		slotCount 			= 10,
		slotInitStartX 		= -5,
		slotInitStartY 		= 13,
		slotInitGapX 		= 55,
		slotInitGapY 		= 0
	},
	template =
	{
		slotBackground = UI.getChildControl(Panel_QuickSlot, "StaticText_Slot_BG_Txt")
	},
	-------------------------------------------------------
	-- 					컨텐츠 관련 변수
	-------------------------------------------------------
	
	slots = {},			-- 슬롯
	
	numberNames =
	{
		"Static_No_1",
		"Static_No_2",
		"Static_No_3",
		"Static_No_4",
		"Static_No_5",
		"Static_No_6",
		"Static_No_7",
		"Static_No_8",
		"Static_No_9",
		"Static_No_10"
	},
	quickSlotInit = false,
	initPosX = Panel_QuickSlot:GetPosX(),
	initPosY = Panel_QuickSlot:GetPosY()
}

-- 쿨타임 변수
-- local burnItemTime = -1

-- 초기화 함수
function quickSlot:init()
	-- for _, value in pairs ( self.numberNames ) do
		-- value:SetColor( UI_color.C_FF626262 )			-- 디폴트 숫자색을 바꿔준다 (회색)
	-- end
end

function QuickSlot_ShowAni()
	-- Panel_QuickSlot:SetShow ( true, true )
	Panel_QuickSlot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	
	local QuickSlotOpen_Alpha = Panel_QuickSlot:addColorAnimation( 0.0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	QuickSlotOpen_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	QuickSlotOpen_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	QuickSlotOpen_Alpha.IsChangeChild = true
end

function QuickSlot_HideAni()
	Panel_QuickSlot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local QuickSlotClose_Alpha = Panel_QuickSlot:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	QuickSlotClose_Alpha:SetStartColor( UI_color.C_FFFFFFFF )
	QuickSlotClose_Alpha:SetEndColor( UI_color.C_00FFFFFF )
	QuickSlotClose_Alpha.IsChangeChild = true
	QuickSlotClose_Alpha:SetHideAtEnd(true)
	QuickSlotClose_Alpha:SetDisableWhileAni(true)
end

------------------------------------------------------------------
--					아이템 쿨타임 in Slot
------------------------------------------------------------------
function QuickSlot_ItemCoolTimeEffect_HideAni()
	-- ♬ 스킬 쿨타임 다 찼을 때 사운드 추가
	audioPostEvent_SystemUi(02,04)
	
	Panel_CoolTime_Effect_Item_Slot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local coolTime_Item_Slot = Panel_CoolTime_Effect_Item_Slot:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	coolTime_Item_Slot:SetStartColor( UI_color.C_FFFFFFFF )
	coolTime_Item_Slot:SetEndColor( UI_color.C_00FFFFFF )
	coolTime_Item_Slot:SetStartIntensity( 3.0 )
	coolTime_Item_Slot:SetEndIntensity( 1.0 )
	coolTime_Item_Slot.IsChangeChild = true
	coolTime_Item_Slot:SetHideAtEnd(true)
	coolTime_Item_Slot:SetDisableWhileAni(true)
end
------------------------------------------------------------------
--					스킬 쿨타임 in Slot
------------------------------------------------------------------
function QuickSlot_SkillCoolTimeEffect_HideAni()
	-- ♬ 스킬 쿨타임 다 찼을 때 사운드 추가
	audioPostEvent_SystemUi(02,00)
	
	Panel_CoolTime_Effect_Slot:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local coolTime_Slot = Panel_CoolTime_Effect_Slot:addColorAnimation( 0.0, 3.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	coolTime_Slot:SetStartColor( UI_color.C_FFFFFFFF )
	coolTime_Slot:SetEndColor( UI_color.C_00FFFFFF )
	coolTime_Slot:SetStartIntensity( 3.0 )
	coolTime_Slot:SetEndIntensity( 1.0 )
	coolTime_Slot.IsChangeChild = true
	coolTime_Slot:SetHideAtEnd(true)
	coolTime_Slot:SetDisableWhileAni(true)
end

-- 슬롯 생성
function quickSlot:createSlot()
	for ii = 1, self.config.slotCount do
		-- 슬롯 정보 초기화
		local slot =
		{
			index	= ii,																		-- Lua 에서의 Slot Index. QuickSlotNo 와는 다르다!
			slotType= CppEnums.QuickSlotType.eEmpty,												
			keyValue= nil,																		-- Empty 일때는 nil, Item 일때는 TInventorySlotNo, Skill 일때는 SkillKey
			posX	= self.config.slotInitStartX + (ii - 0.73 ) * self.config.slotInitGapX,
			posY	= self.config.slotInitStartY + (ii - 1) * self.config.slotInitGapY,
			item	= nil,																		-- Item 일때는 이 변수가 itemSlot 이 된다. 그 외에는 nil
			skill	= nil,																		-- Skill 일때는 이 변수가 skillSlot 이 된다. 그 외에는 nil

			background	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_QuickSlot, 'Static_Slot_BG_' .. ii ),
			number		= UI.getChildControl(Panel_QuickSlot, self.numberNames[ii]),
		}
		CopyBaseProperty( self.template.slotBackground, slot.background )
	
		slot.background:SetShow( true )
		slot.background:SetAlpha(0.0)
		
		-- 버블 정렬
		function slot:rearrangeControl()
			local list = Array.new()
			if	(CppEnums.QuickSlotType.eItem == self.slotType) or (CppEnums.QuickSlotType.eCashItem == self.slotType)	then
				UI.ASSERT( slot.item, 'Item is Null!!!' )
				list:push_back( self.background )
				list:push_back( self.item.icon )
				list:push_back( self.number )
			elseif CppEnums.QuickSlotType.eSkill == self.slotType then
				UI.ASSERT( nil ~= slot.skill )

				list:push_back( self.background )
				list:push_back( self.skill.icon )
				list:push_back( self.skill.effect )
				list:push_back( self.number )
			else
				list:push_back( self.background )
				list:push_back( self.number )
			end
			for ii = 1, list:length() - 1 do
				for jj = ii + 1, list:length() do
					local first = list[ii]
					local second = list[jj]
					UI.ASSERT( (nil ~= first) and (nil ~= second) and (first ~= second) )
					Panel_QuickSlot:SetChildOrder( list[ii]:GetKey(), list[jj]:GetKey() )
				end
			end
		end

		-- background 기준 위치로 다른 컨트롤 위치를 조정함
		function slot:setPos( posX, posY )
			local tmp
			
			tmp = self.background
			tmp:SetSize ( 50, 50 )
			tmp:SetPosX( posX )
			tmp:SetPosY( posY )
			-- tmp:SetAlpha(0.0)

			local bgSizeX = tmp:GetSizeX()
			local bgSizeY = tmp:GetSizeY()

			if	(CppEnums.QuickSlotType.eItem == self.slotType) or (CppEnums.QuickSlotType.eCashItem == self.slotType)	then
				tmp = self.item.icon
				tmp:SetSize (42, 42)
				local iconPosX = posX + (bgSizeX - tmp:GetSizeX())  / 2
				local iconPosY = posY + (bgSizeY - tmp:GetSizeY())  / 2
				tmp:SetPosX( iconPosX )
				tmp:SetPosY( iconPosY )

			elseif CppEnums.QuickSlotType.eSkill == self.slotType then		--	스킬이다
				tmp = self.skill.icon
				tmp:SetSize (42, 42)
				local iconPosX = posX + (bgSizeX - tmp:GetSizeX()) / 2
				local iconPosY = posY + (bgSizeY - tmp:GetSizeY()) / 2
				-- UI.debugMessage( 'Skill Icon X Pos : ' .. posX )
				tmp:SetPosX( iconPosX )
				tmp:SetPosY( iconPosY )

				tmp = self.skill.cooltime
				tmp:SetPosX( iconPosX )
				tmp:SetPosY( iconPosY )
				
				tmp = self.skill.cooltimeText
				tmp:SetPosX( iconPosX )
				tmp:SetPosY( iconPosY )

				tmp = self.skill.effect
				tmp:SetPosX( posX + (bgSizeX - tmp:GetSizeX()) / 2 )
				tmp:SetPosY( posY + (bgSizeY - tmp:GetSizeY()) / 2 )
			end

			tmp = self.number
			tmp:SetPosX( posX + (bgSizeX - tmp:GetSizeX()) / 2 )
			tmp:SetPosY( posY - tmp:GetSizeY() / 2  )
		end

		--------------------------------------------------------------------------
		--						아이템을 슬롯에 올려놓았다!
		--------------------------------------------------------------------------
		function slot:setItem( slotNo, quickSlotInfo )
			if	(CppEnums.QuickSlotType.eItem ~= self.slotType) and (CppEnums.QuickSlotType.eCashItem ~= self.slotType)	then
					if CppEnums.QuickSlotType.eSkill == self.slotType then
						-- 스킬 컨트롤을 삭제
						self.skill:destroyChild()
						Panel_SkillTooltip_Hide()
						self.skill = nil
					end

				self.slotType = quickSlotInfo._type
				
				-- 아이템 컨트롤을 생성
				local itemSlot = {}
				SlotItem.new( itemSlot, 'QuickSlot_' .. slotNo, slotNo, Panel_QuickSlot, quickSlot.slotConfig_Item )
				itemSlot:createChild()
				itemSlot.icon:addInputEvent( "Mouse_LUp",		"QuickSlot_Click("..(self.index-1)..")" )
				itemSlot.icon:addInputEvent( "Mouse_PressMove",	"QuickSlot_DragStart("..(self.index-1)..")" )
				itemSlot.icon:SetEnableDragAndDrop(true)
				self.background:SetIgnore( true )
	
				self.number:AddEffect( "UI_SkillButton01", false, 0, 0 )
				self.number:AddEffect( "fUI_Repair01", false, 0, 0 )
				self.background:AddEffect( "fUI_Light", false, 0, 0 )
				
				-- 숫자의 색을 바꿔준다
				if ( slotNo == 0 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 1, 17, 16, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 1 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 17, 17, 32, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 2 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 33, 17, 48, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 3 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 49, 17, 64, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 4 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 65, 17, 80, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 5 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 81, 17, 96, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 6 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 97, 17, 112, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 7 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 113, 17, 128, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 8 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 129, 17, 144, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 9 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 145, 17, 160, 32 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
				end

				self.item = itemSlot
				self:rearrangeControl()
				self:setPos( self.background:GetPosX(), self.background:GetPosY() )
			end
			
			self.slotType = quickSlotInfo._type
			
			-- 데이터들을 설정
			local	selfPlayer			= getSelfPlayer():get()
			local	inventoryType		= QuickSlot_GetInventoryTypeFrom(self.slotType)
			local	inventory			= selfPlayer:getInventoryByType( inventoryType )
			local	invenSlotNo			= inventory:getSlot( quickSlotInfo._itemKey )
			local	itemStaticWrapper	= getItemEnchantStaticStatus( quickSlotInfo._itemKey )
			local	_const = Defines.s64_const
			local	s64_stackCount = _const.s64_0
			
			if	UI_TISNU ~= invenSlotNo	then
				s64_stackCount = getInventoryItemByType( inventoryType, invenSlotNo ):get():getCount_s64()
			end

			slot.background:SetTextMode ( UI_TM.eTextMode_AutoWrap )
			
			
			self.keyValue				= invenSlotNo
			self.item:setItemByStaticStatus( itemStaticWrapper, s64_stackCount )
			self.item.icon:SetMonoTone( _const.s64_0 == s64_stackCount )

			local	itemSlot	= self.item
			itemSlot.icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(".. slotNo ..", \"QuickSlot\", true)" )
			itemSlot.icon:addInputEvent( "Mouse_Out","Panel_Tooltip_Item_Show_GeneralNormal(".. slotNo ..", \"QuickSlot\", false)" )
			Panel_Tooltip_Item_SetPosition( slotNo, itemSlot, "QuickSlot" )
		end

		--------------------------------------------------------------------------
		--						스킬을 슬롯에 올려놓았다!
		--------------------------------------------------------------------------
		function slot:setSkill( slotNo, quickSlotInfo )
				if CppEnums.QuickSlotType.eSkill ~= self.slotType then
					if	(CppEnums.QuickSlotType.eItem == self.slotType) or (CppEnums.QuickSlotType.eCashItem == self.slotType)	then
						UI.ASSERT( nil ~= self.item )
						-- 아이템 컨트롤을 삭제
						-- self.item:destroyChild()  -- Child 까지 지워주므로 icon 만 삭제하면 된다!
						UI.deleteControl( self.item.icon )
						Panel_Tooltip_Item_hideTooltip()
						self.item = nil
					end

				self.slotType = CppEnums.QuickSlotType.eSkill

				-- 스킬 컨트롤을 생성
				local skillSlot = {}
				SlotSkill.new( skillSlot, slotNo, Panel_QuickSlot, quickSlot.slotConfig_Skill )
				skillSlot.icon:addInputEvent( "Mouse_LUp",			"QuickSlot_Click("..(self.index-1)..")" )
				skillSlot.icon:addInputEvent( "Mouse_PressMove",	"QuickSlot_DragStart("..(self.index-1)..")" )
				skillSlot.icon:SetEnableDragAndDrop(true)
				
				-- ♬ 슬롯에 올려놓았을 때 사운드 추가
				self.number:AddEffect( "UI_SkillButton01", false, 0, 0 )
				self.number:AddEffect( "fUI_Repair01", false, 0, 0 )
				self.background:AddEffect( "fUI_Light", false, 0, 0 )
				
				-- 숫자의 색을 바꿔준다
				if ( slotNo == 0 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 1, 33, 16, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 1 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 17, 33, 32, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 2 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 33, 33, 48, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 3 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 49, 33, 64, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 4 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 65, 33, 80, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 5 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 81, 33, 96, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 6 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 97, 33, 112, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 7 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 113, 33, 128, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 8 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 129, 33, 144, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
					
				elseif ( slotNo == 9 ) then
					self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( self.number, 145, 33, 160, 48 )
					self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.number:setRenderTexture(self.number:getBaseTexture())
				end
				
				self.skill = skillSlot
				self:rearrangeControl()
				self.background:SetIgnore( true )
				self:setPos( self.background:GetPosX(), self.background:GetPosY() )
			end

			-- 데이터들을 설정
			local skillNo = quickSlotInfo._skillKey:getSkillNo()
			local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillNo )
			
			self.skill.skillNo = skillNo
			
			slot.background:SetTextMode ( UI_TM.eTextMode_AutoWrap )
			
			UI.ASSERT( skillTypeStaticWrapper, 'get Fail - Skill Type Static Status ' )
			self.keyValue = quickSlotInfo._skillKey
			self.skill:setSkillTypeStatic( skillTypeStaticWrapper )

			self.skill.icon:addInputEvent( "Mouse_LUp",			"QuickSlot_Click("..(self.index - 1)..")" )
			self.skill.icon:addInputEvent( "Mouse_PressMove",	"QuickSlot_DragStart("..(self.index - 1)..")" )
			self.skill.icon:addInputEvent( "Mouse_On",			"Panel_SkillTooltip_Show(" .. slotNo .. ", false, \"QuickSlot\")" )
			self.skill.icon:addInputEvent( "Mouse_Out",			"Panel_SkillTooltip_Hide()" )
			Panel_SkillTooltip_SetPosition( slotNo, self.skill.icon, "QuickSlot" )
		end

		function slot:setEmpty()
			if	(CppEnums.QuickSlotType.eItem == self.slotType) or (CppEnums.QuickSlotType.eCashItem == self.slotType)	then
				-- 아이템 컨트롤을 삭제
				UI.ASSERT( nil ~= self.item )
				-- self.item:destroyChild()
				UI.deleteControl( self.item.icon )
				Panel_Tooltip_Item_hideTooltip()
				self.item = nil
				audioPostEvent_SystemUi(0,2)
			elseif CppEnums.QuickSlotType.eSkill == self.slotType then
				-- 스킬 컨트롤을 삭제
				UI.ASSERT( nil ~= self.skill )
				self.skill:destroyChild()
				Panel_SkillTooltip_Hide()
				Panel_Tooltip_Item_hideTooltip()
				self.skill = nil
				audioPostEvent_SystemUi(0,9)
			end

			-- 디폴트 숫자색을 바꿔준다 (회색)
			local index = self.index - 1
			if ( index == 0 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 1, 1, 16, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 1 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 17, 1, 32, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 2 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 33, 1, 48, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 3 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 49, 1, 64, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 4 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 65, 1, 80, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 5 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 81, 1, 96, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 6 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 97, 1, 112, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 7 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 113, 1, 128, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 8 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 129, 1, 144, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
				
			elseif ( index == 9 ) then
				self.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.number, 145, 1, 160, 16 )
				self.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.number:setRenderTexture(self.number:getBaseTexture())
			end

			
			slot.background:SetText ( "" )
			self.background:SetIgnore( false )
			self.background:addInputEvent( "Mouse_LUp", "QuickSlot_DropHandler("..(self.index-1)..")" )

			self.slotType = CppEnums.QuickSlotType.eEmpty
			self.keyValue = nil
		end

		slot:setPos( slot.posX, slot.posY )
		slot:rearrangeControl()
		self.slots[ii] = slot
	end
end

-- 드래그 된 것이 있으면 처리한다.
function	QuickSlot_DropHandler( slotIndex )
	if nil == DragManager.dragStartPanel then
		return(false)
	end
		
	if DragManager.dragStartPanel == Panel_Window_Inventory then
		local itemWrapper = getInventoryItemByType( DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo )
		if nil ~= itemWrapper then
			if		itemWrapper:getStaticStatus():get():isContentsEvent() 
				or	itemWrapper:getStaticStatus():get():isItemSkill() 
				or	itemWrapper:getStaticStatus():get():isItemInterAction() 
				or	itemWrapper:getStaticStatus():get():isUseToVehicle() 
				or	itemWrapper:getStaticStatus():get():isEquipable() 
				or	itemWrapper:getStaticStatus():get():isItemTent() 
				then
				quickSlot_RegistItem( slotIndex, DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo )
			end
		end
	elseif DragManager.dragStartPanel == Panel_Window_Skill then
		quickSlot_RegistSkill( slotIndex, DragManager.dragSlotInfo )
	elseif DragManager.dragStartPanel == Panel_QuickSlot then
		if slotIndex ~= DragManager.dragSlotInfo then
			quickSlot_Swap( slotIndex, DragManager.dragSlotInfo )
		end
	end
	
	-- ♬ 슬롯에 올려놓았을 때 사운드 추가
	audioPostEvent_SystemUi(0,8)
	DragManager:clearInfo()
	return(true)
end

function	QuickSlot_GroundClick( whereType, slotIndex )
	local itemSlot = quickSlot.slots[slotIndex + 1]
	-- itemSlot.number:SetColor( UI_color.C_FF626262 )
	quickSlot_Clear( slotIndex )
	
	-- 디폴트 숫자색을 바꿔준다 (회색)
	if ( slotIndex == 0 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 1, 1, 14, 14 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 1 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 15, 1, 28, 14 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 2 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 29, 1, 42, 14 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 3 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 43, 1, 56, 14 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 4 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 1, 15, 14, 28 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 5 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 15, 15, 28, 28 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 6 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 29, 15, 42, 28 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 7 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 43, 15, 56, 28 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 8 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 1, 29, 14, 42 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
		
	elseif ( slotIndex == 9 ) then
		itemSlot.number:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/QuickSlot/QuickSlot_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( itemSlot.number, 15, 29, 28, 42 )
		itemSlot.number:getBaseTexture():setUV(  x1, y1, x2, y2  )
		itemSlot.number:setRenderTexture(itemSlot.number:getBaseTexture())
	end
end

-- 클릭 됬을 때
function QuickSlot_Click( slotIndex )
	local quickSlotInfo = getQuickSlotItem( slotIndex )
	local itemKey = quickSlotInfo._itemKey:getItemKey()
	
	if 502 == itemKey then
		FGlobal_FirstPotionUse()
	end

	local itemSlot = quickSlot.slots[slotIndex + 1]

		if ( nil ~= itemSlot ) then
			if ( nil ~= itemSlot.item ) then
				if not itemSlot.item.cooltime:GetShow() then
					-- ♬ 퀵슬롯을 클릭했을 때 사운드 추가
					audioPostEvent_SystemUi(8,2)
					itemSlot.item.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
					itemSlot.item.icon:AddEffect("UI_SkillButton01", false, 0, 0)
				end	
			end
			if ( nil ~= itemSlot.skill ) then
				if not itemSlot.skill.cooltime:GetShow() then
					-- ♬ 퀵슬롯을 클릭했을 때 사운드 추가
					audioPostEvent_SystemUi(8,2)
					itemSlot.skill.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
					itemSlot.skill.icon:AddEffect("UI_SkillButton01", false, 0, 0)	
					local skillStaticWrapper = getSkillTypeStaticStatus( itemSlot.skill.skillNo )
					if( skillStaticWrapper:getUiDisplayType() )then					
						SpiritGuide_Show()
					end
				end
			end
		end
		
	if not QuickSlot_DropHandler( slotIndex ) then
		-- 모닥불 체크.
		if ( nil ~= itemSlot.item ) then
			local	quickSlotInfo	= getQuickSlotItem( slotIndex )
			local	whereType		= QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
			if isNearFusionCore() and isFusionItem( whereType, itemSlot.keyValue ) then	-- 모닥불 가까이!
			
				----------- check
				--if( -1 == burnItemTime  ) then
					burnItemToActor( whereType, itemSlot.keyValue, 1 )
				--	burnItemTime = 0;
				--else
				--	Proc_ShowMessage_Ack( "잠시후에 다시 태우세요" );					
				--end
						
				return
			end

			local	whereType	= QuickSlot_GetInventoryTypeFrom(quickSlotInfo._type)
			local	inventory	= getSelfPlayer():get():getInventoryByType(whereType)
			local	invenSlotNo = inventory:getSlot( quickSlotInfo._itemKey )
			if	( inventory:sizeXXX() <= invenSlotNo ) then
				return
			end
			
			local itemWrapper	= getInventoryItemByType( whereType, invenSlotNo )
			local itemEnchantWrapper = itemWrapper:getStaticStatus()
			if	(2 == itemEnchantWrapper:get()._vestedType:getItemKey()) and (false == itemWrapper:get():isVested())	then	-- 착용하지 않았던 장착 시 귀속 아이템이라면,
				local bindingItemUse = function()
					quickSlot_UseSlot( slotIndex )
				end
				
				local	messageContent	= nil
				if	itemEnchantWrapper:isUserVested()	then
					messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT_USERVESTED" )		-- "해당 아이템 장착 시 아이템 거래소 이용이 불가능해집니다. 장착하시겠습니까?"
				else
					messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT" )				-- "해당 아이템 장착 시 아이템 거래소 및 창고 이용이 불가능해집니다. 장착하시겠습니까?"
				end

				local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_TITLE" ), content = messageContent, functionYes = bindingItemUse, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
				MessageBox.showMessageBox(messageboxData)
			else
				quickSlot_UseSlot( slotIndex )
			end
		else
			quickSlot_UseSlot( slotIndex )
		end
		
		
	end
end

function SpiritGuide_Show()
	local isShow = FGlobal_SpiritGuide_IsShow()
	if false == isShow then
		return
	end

	Panel_MovieTheater320_ShowToggle()
end

function QuickSlot_DragStart( slotIndex )
	local	self			= quickSlot
	local	quickSlotInfo	= getQuickSlotItem( slotIndex )

	-- 아이콘 드래그 복사
	if	(CppEnums.QuickSlotType.eItem == quickSlotInfo._type) or (CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type)	then
		local itemStaticWrapper = getItemEnchantStaticStatus( quickSlotInfo._itemKey )
		DragManager:setDragInfo(Panel_QuickSlot, nil, slotIndex, "Icon/" .. itemStaticWrapper:getIconPath(), QuickSlot_GroundClick, nil)
	elseif	CppEnums.QuickSlotType.eSkill == quickSlotInfo._type	then
		local skillTypeStaticWrapper = getSkillTypeStaticStatus( quickSlotInfo._skillKey:getSkillNo() )
		DragManager:setDragInfo(Panel_QuickSlot, nil, slotIndex, "Icon/" .. skillTypeStaticWrapper:getIconPath(), QuickSlot_GroundClick, nil)
	end
end

-- 매 프레임 호출되는 함수

local onEffectTime = 0
function	QuickSlot_UpdatePerFrame( fDeltaTime )
	if fDeltaTime <= 0 then
		return
	end
	if isUseNewQuickSlot() then	-- 새 퀵슬롯을 쓴다면, 업데이트 하지 않는다.
		return
	end

	onEffectTime = onEffectTime + fDeltaTime

	local self = quickSlot
	if not self.quickSlotInit then
		return
	end

	for idx,slot in ipairs(self.slots) do
		local	quickSlotKey	= idx - 1
		local	quickSlotInfo	= getQuickSlotItem( quickSlotKey )
		if nil == quickSlotInfo then
		  return
		end

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

	if 3 < onEffectTime then
		onEffectTime = 0
	end
	
	-- 아이템 태우기 쿨타임 주기
	--[[
	if( 0 <= burnItemTime ) then
		burnItemTime = burnItemTime + fDeltaTime
		--_PA_LOG( "luaDebug", " burnItemTime : " ..tostring( burnItemTime ) )
		if ( 4 < burnItemTime ) then
			--_PA_LOG( "luaDebug", " burnItemTime 3초 완~ " ..tostring( burnItemTime ) )
			-- -1은 사용가능하다는 것임
			burnItemTime = -1 
		end		
	end
	--]]
	
end


-- 마우스 입력 등록
function quickSlot:registEventHandler()
	Panel_QuickSlot:RegisterUpdateFunc('QuickSlot_UpdatePerFrame')
end


--------------------------------------------------
-- 			회복제가 인벤에 들어왔다?		-- HP, MP 회복제를 먹으면, 회복제가 등록되어 있지 않은 경우 비어 있는 첫 번째 슬롯에 등록해준다.
--------------------------------------------------
function FGlobal_Potion_InvenToQuickSlot( inventoryType, slotNo, itemType )
	local itemWrapper = getInventoryItemByType( inventoryType, slotNo )
	
	if nil ~= itemWrapper then
		if itemWrapper:getStaticStatus():get():isItemSkill() or itemWrapper:getStaticStatus():get():isUseToVehicle() then
			if ( itemType == 0 ) then

				if isUseNewQuickSlot() then
					-- 새 퀵슬롯용
					local hasPotion = FGlobal_NewQuickSlot_CheckAndSetPotion( slotNo, itemType )
					if hasPotion then
						return
					end
				else
					for index = quickSlot.config.slotCount-1, 0, -1 do
						local	quickSlotInfo	= getQuickSlotItem( index )
						local	quickType		= quickSlotInfo._type
						if	(CppEnums.QuickSlotType.eItem == quickType)	or (CppEnums.QuickSlotType.eCashItem == quickType)	then
							local itemKey		= quickSlotInfo._itemKey:get()
							if ( 517 == itemKey ) 
							or ( 518 == itemKey )
							or ( 519 == itemKey )
							or ( 524 == itemKey )
							or ( 525 == itemKey )
							or ( 513 == itemKey )
							or ( 514 == itemKey )
							or ( 528 == itemKey )
							or ( 529 == itemKey )
							or ( 530 == itemKey )
							or ( 502 == itemKey ) then
								return	-- 회복제가 있으니까 리턴 시킨다.
							end
						end
					end

					local emptySlotIndex = EmptySlot_Check()
					if ( nil ~= emptySlotIndex ) then
						quickSlot_RegistItem( emptySlotIndex, 0, slotNo )	-- 첫 번째 빈 슬롯에 꼽는다.
					end
				end
			elseif ( itemType == 1 ) then
				if isUseNewQuickSlot() then
					-- 새 퀵슬롯용
					local hasPotion = FGlobal_NewQuickSlot_CheckAndSetPotion( slotNo, itemType )
					if not hasPotion then
						return
					end
				else
					for index = quickSlot.config.slotCount-1, 0, -1 do
						local	quickSlotInfo	= getQuickSlotItem( index )
						local	quickType		= quickSlotInfo._type
						if	(CppEnums.QuickSlotType.eItem == quickType)	or (CppEnums.QuickSlotType.eCashItem == quickType)	then
							local itemKey		= quickSlotInfo._itemKey:get()
							if ( 503 == itemKey )
							or ( 520 == itemKey )
							or ( 521 == itemKey )
							or ( 522 == itemKey )
							or ( 526 == itemKey )
							or ( 527 == itemKey )
							or ( 515 == itemKey )
							or ( 516 == itemKey )
							or ( 531 == itemKey )
							or ( 532 == itemKey )
							or ( 533 == itemKey ) then
								return
							end
						end
					end
					
					local emptySlotIndex = EmptySlot_Check()
					if ( nil ~= emptySlotIndex ) then
						quickSlot_RegistItem( emptySlotIndex, 0, slotNo )
					end
				end
			end
		end
	end
	
	if isUseNewQuickSlot() then
		-- 새 퀵슬롯용
		FGlobal_NewQuickSlot_Update()
	else
		QuickSlot_UpdateData()
	end
end

function EmptySlot_Check()
	local emptySlot = nil
	for index = quickSlot.config.slotCount-1, 0, -1 do
		local quickSlotInfo = getQuickSlotItem( index )
		if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type ) then
			emptySlot = index
		end
	end
	return emptySlot
end

-- 해당 slotNo가 비어있지 않으면 오른쪽으로 한 칸씩 밀어서 빈 자리를 만든다.
function HP_Push_NextSlot( slotNo )
	local quickSlotInfo = getQuickSlotItem( slotNo )
	if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type ) then
		return
	end
	
	if (( quickSlot.config.slotCount - 1 ) == slotNo ) then
		return
	end
	
	local quickSlotInfo2 = getQuickSlotItem( slotNo + 1 )
	if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo2._type ) then
		quickSlot_Swap( slotNo, slotNo + 1 )
		if ( 0 == slotNo ) then
			return
		end
		HP_Push_NextSlot( slotNo - 1 )

	else
		HP_Push_NextSlot( slotNo + 1 )
	end
end

function MP_Push_NextSlot( slotNo )
	local quickSlotInfo = getQuickSlotItem( slotNo )
	if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo._type ) then
		return
	end
	
	if (( quickSlot.config.slotCount - 1 ) == slotNo ) then
		return
	end
	
	local quickSlotInfo2 = getQuickSlotItem( slotNo + 1 )
	if ( CppEnums.QuickSlotType.eEmpty == quickSlotInfo2._type ) then
		quickSlot_Swap( slotNo, slotNo + 1 )
		if ( 1 == slotNo ) then
			return
		end
		MP_Push_NextSlot( slotNo - 1 )

	else
		MP_Push_NextSlot( slotNo + 1 )
	end
end


--------------------------------------------------
--		퀵슬롯의 상태를 항상 업데이트 한다
--------------------------------------------------
function	QuickSlot_UpdateData()
	if ( GetUIMode() ~= Defines.UIMode.eUIMode_Default ) then
		return
	end

	if isUseNewQuickSlot() then	-- 새 퀵슬롯을 쓴다면, 업데이트 하지 않는다.
		Panel_QuickSlot:SetShow(false, false)
		return
	end

	changePositionBySever(Panel_QuickSlot, CppEnums.PAGameUIType.PAGameUIPanel_QuickSlot, false, true, false)

	if not Panel_QuickSlot:GetShow() then
		Panel_QuickSlot:SetShow(true, true)
	end

	-- UI.debugMessage('QuickSlot Update')
	local self = quickSlot

	for idx,slot in ipairs(self.slots) do
		local quickSlotKey	= idx - 1
		local quickSlotInfo	= getQuickSlotItem( quickSlotKey )

		if	(CppEnums.QuickSlotType.eItem == quickSlotInfo._type)	or (CppEnums.QuickSlotType.eCashItem == quickSlotInfo._type)	then
			slot:setItem( quickSlotKey, quickSlotInfo )
			if ( nil ~= slot.icon ) then
				slot.icon:SetEnable( true )
			end
		elseif	CppEnums.QuickSlotType.eSkill == quickSlotInfo._type	then
			slot:setSkill( quickSlotKey, quickSlotInfo )
			if ( nil ~= slot.icon ) then
				slot.icon:SetEnable( true )
			end
		else -- Empty
			slot:setEmpty()
			if ( nil ~= slot.icon ) then
				slot.icon:SetEnable( false )
			end
		end
	end
	if ( "QuickSlot" == Panel_Tooltip_Item_GetCurrentSlotType() ) then
		Panel_Tooltip_Item_Refresh()
	end
	if ( "QuickSlot" == Panel_SkillTooltip_GetCurrentSlotType() ) then
		Panel_SkillTooltip_Refresh()
	end

	self.quickSlotInit = true
	-- UI.debugMessage('QuickSlot Update Complete')
	
	if ( 2 < getSelfPlayer():get():getLevel() and 40 > getSelfPlayer():get():getLevel()) then
		NoPotion_Alert()
	end
end


-- 이벤트 등록
function quickSlot:registMessageHandler()
	registerEvent("refreshQuickSlot_ack",		"QuickSlot_UpdateData")
	registerEvent("FromClient_InventoryUpdate",	"QuickSlot_UpdateData")
end


-- 드래그 처리 함수~~!
Panel_QuickSlot:addInputEvent( "Mouse_On", "QuickSlot_ChangeTexture_On()" )
Panel_QuickSlot:addInputEvent( "Mouse_Out", "QuickSlot_ChangeTexture_Off()" )
Panel_QuickSlot:addInputEvent( "Mouse_LUp", "ResetPos_WidgetButton()" )			--메인UI위젯 위치 초기화

function QuickSlot_ChangeTexture_On()
	if Panel_UIControl:IsShow() then
		Panel_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
		quickSlotText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_QUICKSLOT_QUICKSLOT" ) .. "-".. PAGetString( Defines.StringSheet_GAME, "PANEL_QUICKSLOT_MOVE_DRAG" ) )		-- "퀵 슬롯 - 드래그해서 옮기세요."
	end
end

function QuickSlot_ChangeTexture_Off()
	if Panel_UIControl:IsShow() then
		Panel_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
		quickSlotText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_QUICKSLOT_QUICKSLOT" ))	--"퀵 슬롯"
	else
		Panel_QuickSlot:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	end
end

function Panel_QuickSlot_ShowToggle()
	if getSelfPlayer():get():getLevel() < 4 then
		return
	end

	if isUseNewQuickSlot() then	-- 새 퀵슬롯을 쓴다면, 켜거나 끄지 않는다.
		return
	end

	local isShow = Panel_QuickSlot:IsShow()

	if isShow then
		Panel_QuickSlot:SetShow(false, false)
	else
		-- Panel_QuickSlot:SetPosX(quickSlot.initPosX)		-- ON/OFF 버튼을 눌러도 위젯 위치 초기화 되지 않도록 주석처리함.
		-- Panel_QuickSlot:SetPosY(quickSlot.initPosY)		
		Panel_QuickSlot:SetShow( true, true )
	end
end

function FGlobal_QuickSlot_Show()
	if getSelfPlayer():get():getLevel() < 4 then
		return
	end

	if isUseNewQuickSlot() then	-- 새 퀵슬롯을 쓴다면, 켜거나 끄지 않는다.
		return
	end

	Panel_QuickSlot:SetShow( true, true )
	-- quickSlotBg:AddEffect("fUI_Tuto_Skill_01A", false, 0, 0)
	local itemSlot = quickSlot.slots[1]

	if ( nil ~= itemSlot ) then
		if ( nil ~= itemSlot.item ) then
			itemSlot.item.icon:AddEffect("fUI_Tuto_Skill_01A", false, 250, 0)
		end
		if ( nil ~= itemSlot.skill ) then
			itemSlot.skill.icon:AddEffect("fUI_Tuto_Skill_01A", false, 250, 0)
		end
	end
		

end

function QuickSlot_ShowBackGround()
	local self = quickSlot
	for idx,slot in ipairs(self.slots) do
		slot.background:ChangeTextureInfoName("new_ui_common_forlua/default/blackpenel_series.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( slot.background, 5, 5, 50, 50 )
			slot.background:getBaseTexture():setUV(  x1, y1, x2, y2  )
			slot.background:setRenderTexture(slot.background:getOnTexture())
		slot.background:SetAlpha(0.8)
	end
end

function QuickSlot_HideBackGround()
	local self = quickSlot
	for idx,slot in ipairs(self.slots) do
		slot.background:ChangeTextureInfoName("")
		slot.background:SetAlpha(0.0)
	end
end

--여기부터 추가
function QuickSlot_Empty()
	local self = quickSlot
	for idx,slot in ipairs(self.slots) do
		if CppEnums.QuickSlotType.eEmpty == slot.slotType then
			slot.background:ChangeOnTextureInfoName("new_ui_common_forlua/default/blackpenel_series.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( slot.background, 5, 5, 50, 50 )
			slot.background:getOnTexture():setUV(  x1, y1, x2, y2  )
			slot.background:setRenderTexture(slot.background:getBaseTexture())
			slot.background:SetAlpha(1.0)
		end
	end
end
--여기까지 추가

--------------------------------------------------
--		퀵슬롯에 물약이 없거나 다 소진됐을 경우 아래 실행( 5레벨부터 40레벨까지만 보이도록 설정)
--------------------------------------------------
local halfScreenSize = getScreenSizeX() / 2 - Panel_QuickSlot:GetPosX()
local potionAlert = true												-- 인벤에 물약이 있으면 true / 없으면 false
local potionPosInit = false												-- 단축키에 물약이 있으면 true / 없으면 false
local potionRefill = false												-- 단축키에 물약 있으나 해당 물약은 모두 소진, 다른 물약이 남아 있으면 true / 아니면 false
local potion_bubble = UI.getChildControl( Panel_QuickSlot, "StaticText_Bubble")
local potion_bubble2 = UI.getChildControl( Panel_QuickSlot, "StaticText_Bubble2")
potion_bubble:SetShow( false )
potion_bubble2:SetShow( false )
potion_bubble2:SetPosX ( -85 )
potion_bubble2:SetPosY ( -50 )
potion_bubble:SetPosY( -50 )

-- 인벤에 HP물약이 없을 때 말풍선 노출
function NoPotion_Alert()
	local invenSize = getSelfPlayer():get():getInventory():size() - 1
	Potion_Pos_Init()
	for index=1, invenSize do
		local itemWrapper = getInventoryItem( index )
		
		if ( nil ~= itemWrapper ) then
			local itemKey = itemWrapper:get():getKey():getItemKey()
		--local itemName = itemWrapper:getStaticStatus():getName()
			--local hp_potion = string.sub(itemName, 1, 9)
			if ( 517 == itemKey ) 
			or ( 518 == itemKey )
			or ( 519 == itemKey )
			or ( 524 == itemKey )
			or ( 525 == itemKey )
			or ( 513 == itemKey )
			or ( 514 == itemKey )
			or ( 528 == itemKey )
			or ( 529 == itemKey )
			or ( 530 == itemKey )
			or ( 502 == itemKey ) then
				potionAlert = true										-- 인벤에 물약이 있으면 potionAlert는 true
				if ( false == potionPosInit ) then						-- 단축키에 물약이 등록되지 않았다면
					potion_bubble2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUICKSLOT_ADD_POTION"))	-- "HP 회복 물약을 단축키에\n 등록해주세요."
					Potion_Bubble_Show( false )
				elseif ( true == potionRefill ) then					-- 물약이 다 소진된 단축키가 있다면 초기화 안함
					return
				else
					potion_bubble:SetShow( false )						-- 인벤에 물약이 있고, 단축키 등록도 돼 있고, 리필할 물약이 없으면 초기화
					potion_bubble2:SetShow( false )
				end
				return
			end
		end
	end
	potion_bubble:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION"))	
	potion_bubble2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION"))	-- "HP 회복 물약이 모두 소진\n됐습니다. 새로 구입해주세요."
	potionAlert = false
end

-- 단축키에 포션이 있는지 확인. 포션 단축키가 여러 개일 경우 가장 앞에 있는 포션을 기본위치로 함
function Potion_Pos_Init()
	potionPosInit = false
	potionRefill = false
	for index = quickSlot.config.slotCount-1, 0, -1 do
		local	quickType	= getQuickSlotItem( index )._type
		if	(CppEnums.QuickSlotType.eItem == quickType)	or (CppEnums.QuickSlotType.eCashItem == quickType)	then
			local quickSlotInfo = getQuickSlotItem( index )
			local invenSlotNo = getSelfPlayer():get():getInventory():getSlot( quickSlotInfo._itemKey )
			local itemStaticWrapper = getItemEnchantStaticStatus( quickSlotInfo._itemKey )	-- 여기선 아이템ID를 가져올 수 없다! 그래서 name으로 비교
			local itemKey = quickSlotInfo._itemKey:getItemKey()
			
			if ( 502 == itemKey ) 
			or ( 513 == itemKey )
			or ( 514 == itemKey )
			or ( 517 == itemKey )
			or ( 518 == itemKey )
			or ( 519 == itemKey )
			or ( 524 == itemKey )
			or ( 525 == itemKey )
			or ( 528 == itemKey )
			or ( 529 == itemKey )
			or ( 530 == itemKey )
			or ( 538 == itemKey )
			or ( 551 == itemKey )
			or ( 552 == itemKey )
			or ( 553 == itemKey )
			or ( 554 == itemKey )
			or ( 555 == itemKey )
			or ( 17568 == itemKey )
			or ( 17569 == itemKey )
			or ( 19932 == itemKey )
			or ( 19933 == itemKey )
			or ( 19934 == itemKey )
			or ( 19935 == itemKey )	then
				potionPosInit = true
				if ( 255 == invenSlotNo ) then						-- 물약이 다 소진된(빈슬롯 No는 255임) 단축키가 있다면,
					Potion_Alert( index )
					--Potion_Bubble_Locate( index )
					potionRefill = true
				end
			end
		end
	end
	if ( false == potionRefill ) then
		potion_bubble:SetShow( false )
		potion_bubble2:SetShow( false )
	end
	if ( false == potionPosInit ) then								-- 단축키에 등록이 안돼 있다면, 1번 단축키에 포지션
		potion_bubble2:SetPosX( -85 )
		Potion_Bubble_Show( false )
	end
end

-- HP물약 떨어졌을 때 말풍선 노출
function Potion_Alert( slotNo )
	local quickSlotInfo = getQuickSlotItem( slotNo )
	local invenSlotNo = getSelfPlayer():get():getInventory():getSlot( quickSlotInfo._itemKey )
	local itemStaticWrapper = getItemEnchantStaticStatus( quickSlotInfo._itemKey )
	local itemName = itemStaticWrapper:getName()
	local hp_potion = string.sub(itemName, 1, 2)

	--_PA_LOG("이문종", slotNo+1 .. "번째 슬롯에 " .. tostring(itemName) .. " 빈 슬롯이 있다!")

	Potion_Bubble_Locate( slotNo )
	potion_bubble:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION_2", "itemName", itemName ) ) -- itemName .. "이\n 떨어졌습니다. 리필해주세요."
	potion_bubble2:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_QUICKSLOT_HAVENT_POTION_2", "itemName", itemName ) )

	if ( false == potionAlert ) then								-- 인벤에 물약이 없으면 리턴
		return
	end
end

function Potion_Bubble_Locate ( slotNo )		-- 스크린 사이즈 계산해서 어떤 컨트롤 사용할지 결정
	local posX = slotNo * 55 + 10
	if ( posX < halfScreenSize ) then
		potion_bubble2:SetPosX( posX - 95 )
		Potion_Bubble_Show( false )
	else
		potion_bubble:SetPosX( posX )
		Potion_Bubble_Show( true )
	end
end

function Potion_Bubble_Show( bool )
	if ( true == bool ) then
		potion_bubble:SetShow( true )
		potion_bubble2:SetShow( false )
	else
		potion_bubble:SetShow( false )
		potion_bubble2:SetShow( true )
	end
end

function Time_Formatting_ShowTop(second)				-- 인트형 second를 분과 시간으로 변환
	if second > 3600 then
		local	recalc_time	= second / 3600
		local	strHour		= string.format( "%d", Int64toInt32(recalc_time) )
		return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_HOUR", "time_hour", strHour )

	elseif second > 60 then
		local	recalc_time = second / 60
		local	strMinute	= string.format( "%d", Int64toInt32(recalc_time) )
		return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", strMinute )

	else
		local	recalc_time	= second
		local	strSecond	= string.format( "%d", Int64toInt32(recalc_time) )
		return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_SECOND", "time_second", strSecond )

	end			
end

function	QuickSlot_GetInventoryTypeFrom( quickType )
	if	( CppEnums.QuickSlotType.eItem == quickType )	then
		return( CppEnums.ItemWhereType.eInventory )
	end
	
	return( CppEnums.ItemWhereType.eCashInventory )
end

function QuickSlot_OnscreenResize()
	Panel_QuickSlot:SetPosX( (getScreenSizeX() - Panel_QuickSlot:GetSizeX()) / 2 )
	Panel_QuickSlot:SetPosY( getScreenSizeY() - Panel_QuickSlot:GetSizeY())
	
	changePositionBySever(Panel_QuickSlot, CppEnums.PAGameUIType.PAGameUIPanel_QuickSlot, false, true, false)
end

registerEvent("onScreenResize",	"QuickSlot_OnscreenResize")

UI.addRunPostRestorFunction(QuickSlot_OnscreenResize)	-- 플러시를 나올 때, 포지션을 다시 잡아야 한다.펄상점/뷰티샵에서 스케일 조정을 하기 때문.


----------------------------------------------------------------------------
--	Init
----------------------------------------------------------------------------

quickSlot:init()
quickSlot:createSlot()
quickSlot:registEventHandler()
quickSlot:registMessageHandler()

if not isUseNewQuickSlot() then	-- 새 퀵슬롯을 쓴다면, 켜거나 끄지 않는다.
	changePositionBySever(Panel_QuickSlot, CppEnums.PAGameUIType.PAGameUIPanel_QuickSlot, false, true, false)
end

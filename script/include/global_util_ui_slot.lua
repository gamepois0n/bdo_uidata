if nil == UI then
	UI = {}
end

local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color 			= Defines.Color

---------------------------------------------------
-- SlotItem Class
---------------------------------------------------
UI.itemSlotConfig =
{
	borderTexture =
	{
		[0] = nil, -- 0 번은 어짜피 표시하지 않음!
		[1] = { texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds", x1=172, y1=44, x2=214, y2=86},
		[2] = { texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds", x1=172, y1=1, x2=214, y2=43},
		[3] = { texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds", x1=129, y1=1, x2=171, y2=43},
		[4] = { texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds", x1=129, y1=44, x2=171, y2=86}
		
		-- "UI_Win_Icon/UI_Window_Equipment_Icon_Magic.dds",
		-- "UI_Win_Icon/UI_Window_Equipment_Icon_Lair.dds",
		-- "UI_Win_Icon/UI_Window_Equipment_Icon_Unick.dds",
		-- "UI_Win_Icon/UI_Window_Equipment_Icon_Epic.dds"
	},
	
	expirationTexture =
	{
		--[0] = { texture = "new_ui_common_forlua/Default/horse.dds", x1=0, y1=0, x2=256, y2=256},
		[0] = { texture = "new_ui_common_forlua/Window/inventory/inventory_01.dds", x1=45, y1=1, x2=58, y2=14},			-- 흰색 시계 표시
		[1] = { texture = "new_ui_common_forlua/Window/inventory/inventory_01.dds", x1=45, y1=15, x2=58, y2=28},		-- 빨간색 시계표시
		[2] = { texture = "new_ui_common_forlua/Window/inventory/inventory_01.dds", x1=45, y1=29, x2=58, y2=42}			-- 빨간색 X표시
	},
	
	checkBtnTexture = 
	{
		[0] = {texture = "new_ui_common_forlua/default/default_buttons_02.dds", x1=103, y1=162, x2=130, y2=189},
		{texture = "new_ui_common_forlua/default/default_buttons_02.dds", x1=133, y1=162, x2=160, y2=189},
		{texture = "new_ui_common_forlua/default/default_buttons_02.dds", x1=163, y1=162, x2=190, y2=189},
	},

	iconSize = 42,
	borderSize = 42,
	borderPos = -1,
	countSpanSizeX = 10,
	countSpanSizeY = 4,
	
	expirationSize = 15,
	expirationPosX = 1,
	expirationPosY = 30,
	
	expirationBGSize = 43,
	expiration2hSize = 43,

	isCashSize = 28,
	isCashPosX = 0,
	isCashPosY = 0,
	
	disableClass = 12,
	
	checkBtnSize = 19,
}

SlotItem = {}
SlotItem.__index = SlotItem

function SlotItem.new( itemSlot, id, slotNo, parent, param )
	if nil == itemSlot then
		itemSlot = {}
	end
	setmetatable( itemSlot, SlotItem )

	itemSlot.slotNo = slotNo
	itemSlot.param = param
	itemSlot.id = id

	local _config = UI.itemSlotConfig

	if nil == itemSlot.icon then
		itemSlot.icon = UI.createControl( UCT.PA_UI_CONTROL_STATIC, parent, 'Static_' .. id)
	end
	itemSlot.icon:SetSize( UI.itemSlotConfig.iconSize, UI.itemSlotConfig.iconSize )
	itemSlot.icon:ActiveMouseEventEffect(true)
	itemSlot.icon:SetIgnore(false)
	
	return itemSlot
end

-- 컨트롤 생성
function SlotItem:createChild()
	local _config = UI.itemSlotConfig

	if (true == self.param.createBorder) and (nil == self.border) then
		self.border = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, 'Static_' .. self.id .. '_Border')
		self.border:SetSize( 45, 45 )
		self.border:SetPosX( _config.borderPos )
		self.border:SetPosY( _config.borderPos )
		self.border:SetIgnore(true)
	end
		-- 기간만료 2시간 전 아이템 아이콘 위에 씌울 붉은색 점멸 배경 슬롯
	if (true == self.param.createExpiration2h) and (nil == self.Expiration2h) then
		local expire2h = UI.getChildControl(Panel_Window_Inventory, "Static_Expire_2h")
		self.expiration2h = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, 'Static_' .. self.id .. 'Expiration2h')
		CopyBaseProperty( expire2h, self.expiration2h )
		self.expiration2h:SetSize( _config.expiration2hSize, _config.expiration2hSize )
		self.expiration2h:SetPosX( _config.borderPos )
		self.expiration2h:SetPosY( _config.borderPos )
		self.expiration2h:SetIgnore(true)
	end
		-- 기간만료 아이템 아이콘 위에 씌울 붉은색 배경 슬롯
	if (true == self.param.createExpirationBG) and (nil == self.ExpirationBG) then
		self.expirationBG = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, 'Static_' .. self.id .. 'ExpirationBG')
		self.expirationBG:SetSize( _config.expirationBGSize, _config.expirationBGSize )
		self.expirationBG:SetPosX( _config.borderPos )
		self.expirationBG:SetPosY( _config.borderPos )
		self.expirationBG:SetIgnore(true)
	end
	if ( true == self.param.createCount ) and ( nil == self.count )  then
		self.count = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self.icon, 'StaticText_' .. self.id .. '_Count')
		self.count:SetSize( self.icon:GetSizeX() - 3, self.icon:GetSizeY() / 2 )
		self.count:SetPosY( self.icon:GetSizeY() / 2 - 1 )
		self.count:SetTextHorizonRight()
		self.count:SetTextVerticalBottom()
		self.count:SetIgnore(true)
	end
	if (true == self.param.createEnchant) and (nil == self.enchantText) then
		self.enchantText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self.icon, 'StaticText_' .. self.id .. '_Enchant')
		local enchantNumber	= UI.getChildControl( Panel_Window_Inventory, "Static_Text_Slot_Enchant_value" )
		CopyBaseProperty( enchantNumber, self.enchantText )
		self.enchantText:SetSize( self.icon:GetSizeX(), self.icon:GetSizeY() )
		self.enchantText:SetPosX( 0 )
		self.enchantText:SetPosY( 0 )
		self.enchantText:SetTextHorizonCenter()
		self.enchantText:SetTextVerticalCenter()
		self.enchantText:SetIgnore(true)
	end
	if (true == self.param.createCooltime) and (nil == self.cooltime) then
		self.cooltime = UI.createCustomControl('StaticCooltime', self.icon, 'StaticCooltime_' .. self.id)
		self.cooltime:SetSize( self.icon:GetSizeX(), self.icon:GetSizeY() )
		self.cooltime:SetIgnore(true)
		self.cooltime:SetShow(false)
	end
	
	-- 유통기한 아이콘
	if (true == self.param.createExpiration) and (nil == self.expiration ) then
		self.expiration = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, 'Static_' .. self.id .. '_expiration')
		self.expiration:SetSize( _config.expirationSize, _config.expirationSize )
		self.expiration:SetPosX( _config.expirationPosX )
		self.expiration:SetPosY( _config.expirationPosY )
		self.expiration:SetIgnore(true)
	end

	-- 캐시 아이콘
	if (true == self.param.createCash) and (nil == self.isCash ) then
		self.isCash = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, 'Static_' .. self.id .. '_isCash')
		self.isCash:SetSize( _config.isCashSize, _config.isCashSize )
		self.isCash:SetPosX( _config.isCashPosX )
		self.isCash:SetPosY( _config.isCashPosY )
		self.isCash:SetIgnore(true)
	end
	
	-- 클래스 제한 장비 표시
	if (true == self.param.createClassEquipBG) and (nil == self.classEquipBG) then
		self.classEquipBG = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, 'Static_classEquipBG_' .. self.id)
		self.classEquipBG:SetSize( _config.disableClass, _config.disableClass )
		self.classEquipBG:SetPosX( _config.iconSize - _config.disableClass )
		self.classEquipBG:SetPosY( _config.iconSize - _config.disableClass )
		self.classEquipBG:SetIgnore(true)
	end
	
	-- 내구도 0인 장비 표시
	if (true == self.param.createEnduranceIcon) and (nil == self.enduranceIcon ) then
		self.enduranceIcon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, 'Static_' .. self.id .. '_enduranceIcon')
		self.enduranceIcon:SetSize( _config.iconSize + 1, _config.iconSize + 1 )
		self.enduranceIcon:SetPosX( 0 )
		self.enduranceIcon:SetPosY( 0 )
		self.enduranceIcon:SetIgnore(true)
	end
	
	if (true == self.param.createCooltimeText) and (nil == self.cooltimeText) then
		self.cooltimeText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self.icon, 'StaticText_' .. self.id .. '_Cooltime')
		self.cooltimeText:SetSize( _config.iconSize, _config.iconSize )
		self.cooltimeText:SetIgnore(true)
		self.cooltimeText:SetShow(false)
		self.cooltimeText:SetPosX( 0 )
		self.cooltimeText:SetPosY( 0 )
		self.cooltimeText:SetTextHorizonCenter()
		self.cooltimeText:SetTextVerticalCenter()
	end
	
	-- 체크 박스 표시
	if (true == self.param.createCheckBox) and (nil == self.checkBox ) then
		self.checkBox = UI.createControl(UCT.PA_UI_CONTROL_CHECKBUTTON, self.icon, 'CheckButton_' .. self.id)
		self.checkBox:SetSize( _config.checkBtnSize, _config.checkBtnSize )
		self.checkBox:SetPosX( 23 )
		self.checkBox:SetPosY( 1 )
		self.checkBox:SetIgnore(false)
		self.checkBox:SetShow(false)
	end
end

-- 컨트롤 삭제
function SlotItem:destroyChild()
	-- 아이콘 제거.
	self.icon:ReleaseTexture()
	if nil ~= self.border then
		UI.deleteControl( self.border )
		self.border = nil
	end

	if nil ~= self.count then
		UI.deleteControl( self.count )
		self.count = nil
	end

	if nil ~= self.enchantText then
		UI.deleteControl( self.enchantText )
		self.enchantText = nil
	end

	if nil ~= self.cooltime then
		UI.deleteControl( self.cooltime )
		self.cooltime = nil
	end
	
	if nil ~= self.expiration then
		UI.deleteControl( self.expiration )
		self.expiration = nil
	end

	if nil ~= self.isCash then
		UI.deleteControl( self.isCash )
		self.isCash = nil
	end
	
	if nil ~= self.expiration2h then
		UI.deleteControl( self.expiration2h )
		self.expiration2h = nil
	end

	if nil ~= self.expirationBG then
		UI.deleteControl( self.expirationBG )
		self.expirationBG = nil
	end
	
	if nil ~= self.classEquipBG then
		UI.deleteControl( self.classEquipBG )
		self.classEquipBG = nil
	end
	
	if nil ~= self.enduranceIcon then
		UI.deleteControl( self.enduranceIcon )
		self.enduranceIcon = nil
	end
	
	if nil ~= self.cooltimeText then
		UI.deleteControl( self.cooltimeText )
		self.cooltimeText = nil
	end
	
	if nil ~= self.checkBox then
		UI.deleteControl( self.checkBox )
		self.checkBox = nil
	end
end

-- data 함수
function SlotItem:setItem( itemWrapper )
	local itemExpiration = itemWrapper:getExpirationDate()
	local expirationIndex = -1				-- 표시 하지 않음
	--local expirationRate = 0.0
	if (nil ~= itemExpiration) and (false == itemExpiration:isIndefinite()) then
		local s64_Time = itemExpiration:get_s64()
		local s64_remainTime = getLeftSecond_s64( itemExpiration )
		local remainTimePercent = Int64toInt32(s64_remainTime) / (itemWrapper:getStaticStatus():get()._expirationPeriod*60) * 100
		
		if Defines.s64_const.s64_0 == s64_remainTime then
			expirationIndex = 2			-- 기한 만료
		-- elseif Int64toInt32(s64_remainTime) <= 7200 then
			-- expirationIndex = 1			-- 기한이 2시간 이하일때
		elseif remainTimePercent <= 30 then		-- 남은 기간이 30% 이하일 때 점멸
			expirationIndex = 1
		else
			expirationIndex = 0			-- 아직 기한있음
		end
	end

	local currentEndurance = itemWrapper:get():getEndurance()
	local isBroken = false
	
	if 0 == currentEndurance then
		isBroken = true
	end

	-- 캐시 아이템인가?
	local isCash	= itemWrapper:isCash()
	-- local isCash = false
	
	self:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64(), expirationIndex, isBroken, isCash )
end

function SlotItem:setItemByStaticStatus( itemStaticWrapper, s64_stackCount, expirationIndex, isBroken, isCash )
	s64_stackCount = s64_stackCount or toInt64(0,0)

	if nil ~= self.icon then
		-- 아이콘
		self.icon:ChangeTextureInfoName( "Icon/" .. itemStaticWrapper:getIconPath() )
		self.icon:SetAlpha(1)
	end

	if nil ~= self.border then
		-- 테두리
		local gradeType = itemStaticWrapper:getGradeType()
		if (0 < gradeType) and (gradeType <= #UI.itemSlotConfig.borderTexture) then
			self.border:ChangeTextureInfoName( UI.itemSlotConfig.borderTexture[gradeType].texture )
			
			local x1, y1, x2, y2 = setTextureUV_Func( self.border, UI.itemSlotConfig.borderTexture[gradeType].x1, UI.itemSlotConfig.borderTexture[gradeType].y1, UI.itemSlotConfig.borderTexture[gradeType].x2, UI.itemSlotConfig.borderTexture[gradeType].y2 )
			self.border:getBaseTexture():setUV(  x1, y1, x2, y2  )
			self.border:setRenderTexture(self.border:getBaseTexture())
			
			self.border:SetShow(true)
		else
			self.border:ReleaseTexture()
			self.border:ChangeTextureInfoName('')		-- 해제가 안되고 있었다!
		end
	end

	if nil ~= self.count then
		-- 수량
		local itemStatic = itemStaticWrapper:get()
		-- 스택 아이템인경우 개수를 표시하는데, 0개일 경우에도 표시한다 ( 운송요청시.. )
		if ( itemStatic and itemStatic._isStack )	then	--and (Defines.u64_const.u64_1 < s64_stackCount) ) then
			self.count:SetText( tostring(s64_stackCount) )
			self.count:SetShow(true)
		else
			self.count:SetText('')
		end
	end

	if nil ~= self.enchantText then
		-- 인챈트
		local itemStatic = itemStaticWrapper:get()
		if itemStatic:isEquipable() and 0 < itemStatic._key:getEnchantLevel() and itemStatic._key:getEnchantLevel() < 16 then
			self.enchantText:SetText( '+' .. tostring(itemStatic._key:getEnchantLevel()) )
			self.enchantText:SetShow(true)
		elseif itemStatic:isEquipable() and 16 == itemStatic._key:getEnchantLevel() then
			self.enchantText:SetText( "I" )
			self.enchantText:SetShow(true)
		elseif itemStatic:isEquipable() and 17 == itemStatic._key:getEnchantLevel() then
			self.enchantText:SetText( "II" )
			self.enchantText:SetShow(true)
		elseif itemStatic:isEquipable() and 18 == itemStatic._key:getEnchantLevel() then
			self.enchantText:SetText( "III" )
			self.enchantText:SetShow(true)
		elseif itemStatic:isEquipable() and 19 == itemStatic._key:getEnchantLevel() then
			self.enchantText:SetText( "IV" )
			self.enchantText:SetShow(true)
		elseif itemStatic:isEquipable() and 20 == itemStatic._key:getEnchantLevel() then
			self.enchantText:SetText( "V" )
			self.enchantText:SetShow(true)
		-- elseif itemStatic:isEquipable() and 20 <= itemStatic._key:getEnchantLevel() then
		-- 	self.enchantText:SetText( "VI" )
		-- 	self.enchantText:SetShow(true)
		else
			self.enchantText:SetText('')
		end
		
		-- 액세서리일 경우 인챈트 표기를 달리 해준다!
		if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemStaticWrapper:getItemClassify() then
			if 1 == itemStatic._key:getEnchantLevel() then
				self.enchantText:SetText( "I" )		-- 인챈트 수치
				self.enchantText:SetShow(true)
			elseif 2 == itemStatic._key:getEnchantLevel() then
				self.enchantText:SetText( "II" )		-- 인챈트 수치
				self.enchantText:SetShow(true)
			elseif 3 == itemStatic._key:getEnchantLevel() then
				self.enchantText:SetText( "III" )		-- 인챈트 수치
				self.enchantText:SetShow(true)
			elseif 4 == itemStatic._key:getEnchantLevel() then
				self.enchantText:SetText( "IV" )		-- 인챈트 수치
				self.enchantText:SetShow(true)
			elseif 5 == itemStatic._key:getEnchantLevel() then
				self.enchantText:SetText( "V" )		-- 인챈트 수치
				self.enchantText:SetShow(true)
			end
		end
		
		-- 캐시 아이템은 인챈트 표기를 꺼준다
		if itemStatic:isCash() then
			self.enchantText:SetShow( false )
		end
		
	end
	
	-- 0 : 표시하지않음 1 : 남은시간이 2시간 이하일때. 2 : 유통기한 끝								
	if nil ~= self.expiration then
		if -1 ~= expirationIndex then
			self.expiration:ChangeTextureInfoName( UI.itemSlotConfig.expirationTexture[expirationIndex].texture )
			local x1, y1, x2, y2 = setTextureUV_Func( self.expiration, UI.itemSlotConfig.expirationTexture[expirationIndex].x1
																	, UI.itemSlotConfig.expirationTexture[expirationIndex].y1
																	, UI.itemSlotConfig.expirationTexture[expirationIndex].x2
																	, UI.itemSlotConfig.expirationTexture[expirationIndex].y2 )
			self.expiration:getBaseTexture():setUV(  x1, y1, x2, y2  )
			self.expiration:setRenderTexture(self.expiration:getBaseTexture())
			self.expiration:SetShow(true)
		else
			self.expiration:SetShow(false)
		end
	end
	
	-- 남은 기간 2시간 이내 : 아이템 슬롯 붉은색 점멸 처리
	if nil ~= self.expiration2h then
		if 1 == expirationIndex then	
			--self.expiration2h:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/inventory_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( self.expiration2h, 1, 91, 44, 134 )
			self.expiration2h:getBaseTexture():setUV(  x1, y1, x2, y2  )
			self.expiration2h:setRenderTexture(self.expiration2h:getBaseTexture())
			self.expiration2h:SetShow(true)
		else
			self.expiration2h:SetShow(false)
		end
	end

	-- 펄 아이템인가.
	if nil ~= self.isCash then
		if itemStaticWrapper:get():isCash() then
			self.isCash:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/CashIcon.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( self.isCash, 1, 1, 28, 28 )
			self.isCash:getBaseTexture():setUV(  x1, y1, x2, y2  )
			self.isCash:setRenderTexture(self.isCash:getBaseTexture())
			self.isCash:SetShow(true)
		else
			self.isCash:SetShow(false)
		end
	end

	-- 기간만료 아이템 붉은색 슬롯 처리								
	if nil ~= self.expirationBG then
		if 2 == expirationIndex then	
			self.expirationBG:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/inventory_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( self.expirationBG, 1, 1, 44, 44 )
			self.expirationBG:getBaseTexture():setUV(  x1, y1, x2, y2  )
			self.expirationBG:setRenderTexture(self.expirationBG:getBaseTexture())
			self.expirationBG:SetShow(true)	
		else
			self.expirationBG:SetShow(false)
		end
	end
	
	-- 클래스 제한 장비 필터
	if nil ~= self.classEquipBG then
		self.classEquipBG:SetShow(false)
		local isUsableClass = nil
		local itemSSW = itemStaticWrapper
		local classType = getSelfPlayer():getClassType()
		
		if ( nil ~= itemSSW ) then
			if itemSSW:get():isWeapon() or itemSSW:get():isSubWeapon() then
				isUsableClass = itemSSW:get()._usableClassType:isOn( classType )
			else
				isUsableClass = true
			end
		else
			isUsableClass = false
		end
		if ( true == itemSSW:get():isEquipable() ) and ( false == isUsableClass ) then
			self.classEquipBG:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/Disable_Class.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( self.classEquipBG, 1, 1, 12, 12 )
			self.classEquipBG:getBaseTexture():setUV(  x1, y1, x2, y2  )
			self.classEquipBG:setRenderTexture(self.classEquipBG:getBaseTexture())
			self.classEquipBG:SetShow(true)

			--[[self.classEquipBG:ChangeTextureInfoName( "Icon/" .. itemSSW:getIconPath() )
			self.classEquipBG:SetColor( UI_color.C_FFF26A6A )
			self.classEquipBG:SetShow(true)--]]
		end
	end
	
	-- 내구도 0인 장비 아이콘 표시
	local equipSlotNo = itemStaticWrapper:getEquipSlotNo()
	if nil ~= self.enduranceIcon then
		self.enduranceIcon:SetShow(false)
		if true == isBroken then
			if 2 == equipSlotNo then								-- 내구도 0인 장비가 채집도구라면
				self.enduranceIcon:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/Disable_Repair.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.enduranceIcon, 1, 1, 41, 41 )
				self.enduranceIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.enduranceIcon:setRenderTexture(self.enduranceIcon:getBaseTexture())
				self.enduranceIcon:SetShow(true)			
			else
				self.enduranceIcon:ChangeTextureInfoName( "new_ui_common_forlua/window/inventory/Need_Repair.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( self.enduranceIcon, 1, 1, 41, 41 )
				self.enduranceIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.enduranceIcon:setRenderTexture(self.enduranceIcon:getBaseTexture())
				self.enduranceIcon:SetShow(true)
			end
		end
	end
	
	-- 체크 박스 표시
	if nil ~= self.checkBox then
		self.checkBox:ChangeTextureInfoName( UI.itemSlotConfig.checkBtnTexture[0].texture )
		local x1, y1, x2, y2 = setTextureUV_Func( self.checkBox,	UI.itemSlotConfig.checkBtnTexture[0].x1,
																	UI.itemSlotConfig.checkBtnTexture[0].y1,
																	UI.itemSlotConfig.checkBtnTexture[0].x2,
																	UI.itemSlotConfig.checkBtnTexture[0].y2	)
		self.checkBox:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.checkBox:setRenderTexture(self.checkBox:getBaseTexture())
		
		self.checkBox:ChangeOnTextureInfoName( UI.itemSlotConfig.checkBtnTexture[1].texture )
		local x1, y1, x2, y2 = setTextureUV_Func( self.checkBox,	UI.itemSlotConfig.checkBtnTexture[1].x1,
																	UI.itemSlotConfig.checkBtnTexture[1].y1,
																	UI.itemSlotConfig.checkBtnTexture[1].x2,
																	UI.itemSlotConfig.checkBtnTexture[1].y2	)
		self.checkBox:getOnTexture():setUV(  x1, y1, x2, y2  )
		
		self.checkBox:ChangeClickTextureInfoName( UI.itemSlotConfig.checkBtnTexture[2].texture )
		local x1, y1, x2, y2 = setTextureUV_Func( self.checkBox,	UI.itemSlotConfig.checkBtnTexture[2].x1,
																	UI.itemSlotConfig.checkBtnTexture[2].y1,
																	UI.itemSlotConfig.checkBtnTexture[2].x2,
																	UI.itemSlotConfig.checkBtnTexture[2].y2	)
		self.checkBox:getClickTexture():setUV(  x1, y1, x2, y2  )
		self.checkBox:SetShow(false)
		self.checkBox:SetCheck( true )
	end
	
end

function SlotItem:setItemByCashProductStaticStatus( cashProductStaticWrapper, s64_stackCount )
	s64_stackCount = s64_stackCount or toInt64(0,0)

	if nil ~= self.icon then
		-- 아이콘
		self.icon:ChangeTextureInfoName( "Icon/" .. cashProductStaticWrapper:getIconPath() )
		self.icon:SetAlpha(1)
	end
	
	if nil ~= self.count then
		if toInt64(0,0) < s64_stackCount then 
			self.count:SetText( tostring(s64_stackCount) )
			self.count:SetShow(true)
		else
			self.count:SetText('')
		end
	end
	
end

function SlotItem:clearItem()
	if nil ~= self.icon then
		-- 아이콘
		self.icon:ReleaseTexture()
		self.icon:ChangeTextureInfoName("")
		self.icon:SetAlpha(0)
	end

	if nil ~= self.border then
		-- 테두리
		self.border:ReleaseTexture()
		self.border:SetShow(false)
	end

	if nil ~= self.count then
		-- 수량
		self.count:SetShow(false)
	end

	if nil ~= self.enchantText then
		-- 수량
		self.enchantText:SetShow(false)
	end

	if nil ~= self.cooltime then
		-- 쿨타임
		self.cooltime:SetShow(false)
	end
	
	if nil ~= self.expiration then
		self.expiration:SetShow( false )
	end

	if nil ~= self.isCash then
		self.isCash:SetShow( false )
	end
	
	-- 기간만료 2시간 전 아이템의 슬롯 붉은색 점멸 배경
	if nil ~= self.expiration2h then
		self.expiration2h:SetShow( false )
	end

	-- 기간만료 아이템의 슬롯 붉은색 배경
	if nil ~= self.expirationBG then
		self.expirationBG:SetShow( false )
	end
	
	if nil ~= self.classEquipBG then
		self.classEquipBG:SetShow( false )
	end
	
	if nil ~= self.enduranceIcon then
		self.enduranceIcon:SetShow( false )
	end
	
	if nil ~= self.cooltimeText then
		self.cooltimeText:SetShow(false)
	end

	if nil ~= self.checkBox then
		self.checkBox:SetShow(false)
	end
end


------------------------------------------------------------------------------------------------------
-- 										스킬 컨트롤
------------------------------------------------------------------------------------------------------
UI.skillSlotConfig =
{
	iconSize = 42,
	levelPosX = -15,
	levelPosY = -11,
	learnBtnSpanSize = -2
}

SlotSkill = {}
SlotSkill.__index = SlotSkill

function SlotSkill.new( skillSlot, skillNo, parent, param )
	if nil == skillSlot then
		skillSlot = {}
	end
	setmetatable( skillSlot, SlotSkill )
	
	if( 'number' == type(skillNo) ) then
		skillSlot.skillNo = skillNo	
	end
	
	skillSlot.param = param

	local _config = UI.skillSlotConfig

	-- 컨트롤 생성
	if (true == param.createIcon) and (nil == skillSlot.icon) then
		skillSlot.icon = UI.createControl( UCT.PA_UI_CONTROL_STATIC, parent, 'StaticSkill_' .. skillNo)
		skillSlot.icon:SetSize( _config.iconSize, _config.iconSize )
		skillSlot.icon:ActiveMouseEventEffect(true)
		skillSlot.icon:SetIgnore(false)
	end

	if (true == param.createEffect) and (nil == skillSlot.effect) then
		skillSlot.effect = UI.createControl( UCT.PA_UI_CONTROL_STATIC, parent, 'StaticSkill_Effect_' .. skillNo)
		CopyBaseProperty( param.template.effect, skillSlot.effect )
		skillSlot.effect:SetIgnore(true)
	end

	if (true == param.createFG) and (nil == skillSlot.iconFG) then
		skillSlot.iconFG = UI.createControl( UCT.PA_UI_CONTROL_STATIC, parent, 'StaticSkill_Foreground_' .. skillNo)
		CopyBaseProperty( param.template.iconFG, skillSlot.iconFG )
		skillSlot.iconFG:SetIgnore(true)
	end

	if (true == param.createFGDisabled) and (nil == skillSlot.iconFGDisabled) then
		skillSlot.iconFGDisabled = UI.createControl( UCT.PA_UI_CONTROL_STATIC, parent, 'StaticSkill_Foreground_Disable' .. skillNo)
		CopyBaseProperty( param.template.iconFGDisabled, skillSlot.iconFGDisabled )
		skillSlot.iconFGDisabled:SetIgnore(true)
	end
	
	if (true == param.createFG_Passive) and (nil == skillSlot.iconFG_Passive) then
		skillSlot.iconFG_Passive = UI.createControl( UCT.PA_UI_CONTROL_STATIC, parent, 'StaticSkill_Foreground_Passive' .. skillNo)
		CopyBaseProperty( param.template.iconFG_Passive, skillSlot.iconFG_Passive )
		skillSlot.iconFG_Passive:SetIgnore(true)
	end
	
	if (true == param.createMinus) and (nil == skillSlot.iconMinus) then
		skillSlot.iconMinus = UI.createControl( UCT.PA_UI_CONTROL_STATIC, parent, 'StaticSkill_Minus' .. skillNo)
		CopyBaseProperty( param.template.iconMinus, skillSlot.iconMinus )
		skillSlot.iconMinus:SetIgnore(true)
		skillSlot.iconMinus:SetShow(false)
	end

	-- if (true == param.createLevel) and (nil == skillSlot.textLevel) then
		-- skillSlot.textLevel = UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, parent, 'StaticSkill_Level_' .. skillNo)
		-- CopyBaseProperty( param.template.textLevel, skillSlot.textLevel )
		-- skillSlot.textLevel:SetIgnore(true)
	-- end

	if (true == param.createLearnButton) and (nil == skillSlot.learnButton) then
		skillSlot.learnButton = UI.createControl( UCT.PA_UI_CONTROL_BUTTON, parent, 'StaticSkill_Learn_' .. skillNo)
		CopyBaseProperty( param.template.learnButton, skillSlot.learnButton )
		skillSlot.learnButton:SetIgnore(false)
		skillSlot.learnButton:SetShow(false)
	end
	
	if (true == param.createReservationButton) and (nil == skillSlot.reservationButton) then
		skillSlot.reservationButton = UI.createControl( UCT.PA_UI_CONTROL_BUTTON, parent, 'StaticSkill_Reservation_' .. skillNo)
		CopyBaseProperty( param.template.reservationButton, skillSlot.reservationButton )
		skillSlot.reservationButton:SetIgnore(false)
		skillSlot.reservationButton:SetShow(false)
	end

	if (true == param.createCooltime) and (nil == skillSlot.cooltime) then
		skillSlot.cooltime = UI.createCustomControl('StaticCooltime', parent, 'StaticCooltime_' .. skillNo)
		skillSlot.cooltime:SetMonoTone(true)
		skillSlot.cooltime:SetSize( _config.iconSize, _config.iconSize )
		skillSlot.cooltime:SetIgnore(true)
		skillSlot.cooltime:SetShow(false)
	end
	
	if (true == param.createTestimonial) and (nil == skillSlot.testimonial) then
		skillSlot.testimonial = UI.createControl( UCT.PA_UI_CONTROL_STATIC, parent, 'StaticSkill_testimonial_' .. skillNo)
		CopyBaseProperty( param.template.testimonial, skillSlot.testimonial )
		skillSlot.testimonial:SetIgnore(true)
		skillSlot.testimonial:SetShow(false)
	end
	
	if (true == param.createCooltimeText) and (nil == skillSlot.cooltimeText) then
		skillSlot.cooltimeText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, parent, 'StaticText_' .. skillNo .. '_Cooltime')
		skillSlot.cooltimeText:SetSize( _config.iconSize, _config.iconSize )
		skillSlot.cooltimeText:SetIgnore(true)
		skillSlot.cooltimeText:SetShow(false)
		skillSlot.cooltimeText:SetTextHorizonCenter()
		skillSlot.cooltimeText:SetTextVerticalCenter()
	end
	-- End Of 컨트롤 생성

	return skillSlot
end

function SlotSkill:setPos( posX, posY )
	local _config = UI.skillSlotConfig
	local iconSizeX, iconSizeY
	iconSizeX = _config.iconSize	-- 일단 기본값으로 설정
	iconSizeY = _config.iconSize

	if nil ~= self.icon then
		-- UI.debugMessage(' Icon Set Pos ' )
		self.icon:SetPosX( posX )
		self.icon:SetPosY( posY )
		iconSizeX = self.icon:GetSizeX()
		iconSizeY = self.icon:GetSizeY()
	end

	if nil ~= self.effect then
		-- UI.debugMessage(' Effect Set Pos ' )
		self.effect:SetPosX( posX + (iconSizeX - self.effect:GetSizeX()) / 2 )
		self.effect:SetPosY( posY + (iconSizeY - self.effect:GetSizeY()) / 2 )
	end

	if nil ~= self.iconFG then
		-- UI.debugMessage(' Fg Set Pos ' )
		self.iconFG:SetPosX( posX + (iconSizeX - self.iconFG:GetSizeX()) / 2 )
		self.iconFG:SetPosY( posY + (iconSizeY - self.iconFG:GetSizeY()) / 2 )
	end

	if nil ~= self.iconFGDisabled then
		-- UI.debugMessage(' FGD Set Pos ' )
		self.iconFGDisabled:SetPosX( posX + (iconSizeX - self.iconFGDisabled:GetSizeX()) / 2 )
		self.iconFGDisabled:SetPosY( posY + (iconSizeY - self.iconFGDisabled:GetSizeY()) / 2 )
	end

	if nil ~= self.iconFG_Passive then
		-- UI.debugMessage(' passive Set Pos ' )
		self.iconFG_Passive:SetPosX( posX + (iconSizeX - self.iconFG_Passive:GetSizeX()) / 2 )
		self.iconFG_Passive:SetPosY( posY + (iconSizeY - self.iconFG_Passive:GetSizeY()) / 2 )
	end
	
	if nil ~= self.iconMinus then
		-- UI.debugMessage(' passive Set Pos ' )
		self.iconMinus:SetPosX( posX + (iconSizeX - self.iconMinus:GetSizeX()) / 2 )
		self.iconMinus:SetPosY( posY + (iconSizeY - self.iconMinus:GetSizeY()) / 2 )
	end

	-- if nil ~= self.textLevel then
		-- UI.debugMessage(' text Set Pos ' )
		-- self.textLevel:SetPosX( posX + _config.levelPosX )
		-- self.textLevel:SetPosY( posY + _config.levelPosY )
	-- end

	if nil ~= self.learnButton then
		-- UI.debugMessage(' button Set Pos ' )
		self.learnButton:SetPosX( posX + iconSizeX - ( self.learnButton:GetSizeX() - 9 ) )
		self.learnButton:SetPosY( posY + iconSizeY - ( self.learnButton:GetSizeY() - 9 ) )
		-- UI.debugMessage(' button Set Pos End' )
	end
	
	if nil ~= self.reservationButton then
		self.reservationButton:SetPosX( posX + iconSizeX - (self.reservationButton:GetSizeX() + _config.learnBtnSpanSize) )
		self.reservationButton:SetPosY( posY + iconSizeY - (self.reservationButton:GetSizeY() + _config.learnBtnSpanSize) )
	end

	if nil ~= self.cooltime then
		-- UI.debugMessage(' Cooltime Set Pos ' )
		self.cooltime:SetPosX( posX )
		self.cooltime:SetPosY( posY )
	end
	
	if nil ~= self.testimonial then
		self.testimonial:SetPosX( posX + (iconSizeX - self.testimonial:GetSizeX()) / 2 )
		self.testimonial:SetPosY( posY + (iconSizeY - self.testimonial:GetSizeY()) / 2 )
	end
	
	if nil ~= self.cooltimeText then
		self.cooltimeText:SetPosX( posX )
		self.cooltimeText:SetPosY( posY )
	end
	
end

-- 컨트롤 삭제
function SlotSkill:destroyChild()
	-- 아이콘 제거.
	if nil ~= self.icon then
		UI.deleteControl( self.icon )
		self.icon = nil
	end

	if nil ~= self.effect then
		UI.deleteControl( self.effect )
		self.effect = nil
	end

	if nil ~= self.iconFG then
		UI.deleteControl( self.iconFG )
		self.iconFG = nil
	end

	if nil ~= self.iconFGDisabled then
		UI.deleteControl( self.iconFGDisabled )
		self.iconFGDisabled = nil
	end

	if nil ~= self.iconFG_Passive then
		UI.deleteControl( self.iconFG_Passive )
		self.iconFG_Passive = nil
	end
	
	if nil ~= self.iconMinus then
		UI.deleteControl( self.iconMinus )
		self.iconMinus = nil
	end

	-- if nil ~= self.textLevel then
		-- UI.deleteControl( self.textLevel )
		-- self.textLevel = nil
	-- end

	if nil ~= self.learnButton then
		UI.deleteControl( self.learnButton )
		self.learnButton = nil
	end

	if nil ~= self.reservationButton then
		UI.deleteControl( self.reservationButton)
		self.reservationButton = nil
	end

	if nil ~= self.cooltime then
		UI.deleteControl( self.cooltime )
		self.cooltime = nil
	end
	
	if nil ~= self.testimonial then
		UI.deleteControl( self.testimonial )
		self.testimonial = nil
	end

	if nil ~= self.cooltimeText then
		UI.deleteControl( self.cooltimeText )
		self.cooltimeText = nil
	end
end

-- data 함수
function SlotSkill:setSkillTypeStatic( skillTypeStaticWrapper, skillNo )
	if nil ~= self.icon then
		-- 아이콘
		self.icon:ChangeTextureInfoName( "Icon/" .. skillTypeStaticWrapper:getIconPath() )
		self.icon:SetAlpha(1)
	end
	
	if nil ~= skillNo then	
		self.skillNo = skillNo	
	end
end

function SlotSkill:setSkill( skillLevelInfo, isLearnMode )

	if( self.skillNo ~= skillLevelInfo._skillKey:getSkillNo() ) then
		-- _PA_LOG( "lua_debug", "이미 설정된 스킬No와 SlotSkill:setSkill()의 스킬No가 다릅니다."..tostring(self.skillNo).." "..tostring(skillLevelInfo._skillKey:getSkillNo()) );
		local skillTypeStaticWrapper = getSkillTypeStaticStatus( skillLevelInfo._skillKey:getSkillNo() )
		self:setSkillTypeStatic( skillTypeStaticWrapper, skillLevelInfo._skillKey:getSkillNo() );
	end
	
	if nil ~= self.icon then
		-- 배우기 모드일때는 배울 수 있는 것만, 아닐때는 사용할 수 있는 것만 강조한다!
		if isLearnMode then
			-- self.icon:SetMonoTone(not skillLevelInfo._learnable)
		else
			-- self.icon:SetMonoTone(not skillLevelInfo._usable)
		end
	end

	-- self.iconFG 은 처음에 컨트롤 생성시에, Skill 이 Active 인지 아닌지에 따라 생성 되거나, 생성되지 않았다!
	-- 존재하지 않으면 Active 스킬이 아닌 것으로 간주해도 무방하다!
	if nil ~= self.iconFG then
		self.iconFG:SetShow(skillLevelInfo._usable)
	end
	
	if nil ~= self.iconFGDisabled then
		self.iconFGDisabled:SetShow(not skillLevelInfo._usable)
	end
	
	if nil ~= self.iconFG_Passive then
		self.iconFG_Passive:SetShow(not skillLevelInfo._usable)
	end

	if( nil ~= self.reservationButton ) then
		self.reservationButton:SetShow( isLearnMode and skillLevelInfo._isReservedLearning )
	end
	
	if( nil ~= self.testimonial ) then
		self.testimonial:SetShow( skillLevelInfo._isTestimonial )
	end
	
	local resultAble = false;
	if nil ~= self.learnButton then
		local skillStatic = getSkillStaticStatus(skillLevelInfo._skillKey:getSkillNo(), 1)
		local enableLearn = true 
		if (nil ~= skillStatic) then
			local needLvLearning = skillStatic:get()._needCharacterLevelForLearning
			if (0 == needLvLearning) then
				enableLearn = false
			end
		end
		
		resultAble = isLearnMode and skillLevelInfo._learnable and enableLearn
		self.learnButton:SetShow( resultAble )
	end
	return resultAble
end

function SlotSkill:clearSkill()

	self.skillNo = nil

	if nil ~= self.icon then
		-- 아이콘
		self.icon:ReleaseTexture()
		self.icon:SetAlpha(0)
	end

	if nil ~= self.effect then
		self.effect:SetShow(false)
	end

	if nil ~= self.iconFG then
		self.iconFG:SetShow(false)
	end

	if nil ~= self.iconFGDisabled then
		self.iconFGDisabled:SetShow(false)
	end

	if nil ~= self.iconFG_Passive then
		self.iconFG_Passive:SetShow(false)
	end
	
	if nil ~= self.iconMinus then
		self.iconMinus:SetShow(false)
	end

	-- if nil ~= self.textLevel then
		-- self.textLevel:SetShow(false)
	-- end

	if nil ~= self.learnButton then
		self.learnButton:SetShow(false)
	end
	
	if nil ~= self.reservationButton then
		self.reservationButton:SetShow(false)
	end

	if nil ~= self.cooltime then
		self.cooltime:SetShow(false)
	end
	
	if nil ~= self.testimonial then
		self.testimonial:SetShow(false)
	end

	if nil ~= self.cooltimeText then
		self.cooltimeText:SetShow(false)
	end
end

function HighEnchantLevel_ReplaceString( enchantLevel )
	if 16 == enchantLevel then
		return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_16") -- 장 :
	elseif 17 == enchantLevel then
		return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_17") -- 광 :
	elseif 18 == enchantLevel then
		return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_18") -- 고 :
	elseif 19 == enchantLevel then
		return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_19") -- 유 :
	elseif 20 == enchantLevel then
		return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_20") -- 동 :
	else
		return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_20") -- 동 :
	end
end
local UI_TM			= CppEnums.TextMode
local UI_color		= Defines.Color
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_ItemMarket_AlarmList:RegisterShowEventFunc( true, 'ItemMarketAlarmList_ShowAni()' )
Panel_ItemMarket_AlarmList:RegisterShowEventFunc( false, 'ItemMarketAlarmList_HideAni()' )

Panel_ItemMarket_AlarmList:SetShow( false, false )
Panel_ItemMarket_AlarmList:ActiveMouseEventEffect(true)
Panel_ItemMarket_AlarmList:setGlassBackground(true)

local ItemMarketAlarm	= {
	ui = {
		btn_Close			= UI.getChildControl( Panel_ItemMarket_AlarmList,	"Button_Win_Close"),
		bg					= UI.getChildControl( Panel_ItemMarket_AlarmList,	"Static_BG"),

		temp_SlotBG	 			= UI.getChildControl( Panel_ItemMarket_AlarmList,	"Static_SlotBG"),
		temp_Slot_IconBG		= UI.getChildControl( Panel_ItemMarket_AlarmList,	"Static_Slot_IconBG"),
		temp_Slot_Icon	 		= UI.getChildControl( Panel_ItemMarket_AlarmList,	"Static_Slot_Icon"),
		temp_Slot_ItemName		= UI.getChildControl( Panel_ItemMarket_AlarmList,	"StaticText_Slot_ItemName"),
		temp_Button_UnSelect	= UI.getChildControl( Panel_ItemMarket_AlarmList,	"Button_UnSelect"),

		scroll				= UI.getChildControl( Panel_ItemMarket_AlarmList,	"Scroll_List"),
	},
	config	= {
		maxSlotCount	= 6,
		totalItemCount	= 0,
		startIndex		= 0,
	},
	uiPool	= {},
}

local _buttonQuestion = UI.getChildControl( Panel_ItemMarket_AlarmList, "Button_Question" )						-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"ItemMarket\" )" )					-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On",	"HelpMessageQuestion_Show( \"ItemMarket\", \"true\")" )				-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out",	"HelpMessageQuestion_Show( \"ItemMarket\", \"false\")" )			-- 물음표 마우스오버

function ItemMarketAlarm:Init()
	for slotIdx = 0, self.config.maxSlotCount -1 do
		self.uiPool[slotIdx] = {}
		local slot = self.uiPool[slotIdx]
		slot.slotBG		= UI.createAndCopyBasePropertyControl( Panel_ItemMarket_AlarmList, "Static_SlotBG",					self.ui.bg,	"ItemMarket_AlarmList_SlotBG_"			.. slotIdx )
		slot.iconBG		= UI.createAndCopyBasePropertyControl( Panel_ItemMarket_AlarmList, "Static_Slot_IconBG",			slot.slotBG	,	"ItemMarket_AlarmList_SlotIconBG_"		.. slotIdx )
		slot.icon		= UI.createAndCopyBasePropertyControl( Panel_ItemMarket_AlarmList, "Static_Slot_Icon",				slot.iconBG	,	"ItemMarket_AlarmList_SlotIcon_"		.. slotIdx )
		slot.enchantLevel	= UI.createAndCopyBasePropertyControl( Panel_ItemMarket_AlarmList, "StaticText_EnchantLevel",	slot.iconBG	,	"ItemMarket_AlarmList_SlotEnchantLevel_"	.. slotIdx )
		slot.itemName	= UI.createAndCopyBasePropertyControl( Panel_ItemMarket_AlarmList, "StaticText_Slot_ItemName",		slot.slotBG	,	"ItemMarket_AlarmList_SlotItemName_"	.. slotIdx )
		slot.unSetBtn	= UI.createAndCopyBasePropertyControl( Panel_ItemMarket_AlarmList, "Button_UnSelect",				slot.slotBG	,	"ItemMarket_AlarmList_SlotUnSetBtn_"	.. slotIdx )

		slot.slotBG		:SetPosX( 5 )
		slot.slotBG		:SetPosY( 5 + ( (slot.slotBG:GetSizeY() + 5) * slotIdx ) )
		slot.iconBG		:SetPosX( 5 )
		slot.iconBG		:SetPosY( 5 )
		slot.icon		:SetPosX( 0 )
		slot.icon		:SetPosY( 0 )
		slot.enchantLevel:SetPosX( 5 )
		slot.enchantLevel:SetPosY( 10 )
		slot.itemName	:SetPosX( 55 )
		slot.itemName	:SetPosY( 15 )
		slot.unSetBtn	:SetPosX( 325 )
		slot.unSetBtn	:SetPosY( 5 )

		slot.slotBG		:SetShow( false )

		slot.slotBG		:addInputEvent( "Mouse_UpScroll", 		"Scroll_ItemMarketAlarmList( true )")
		slot.slotBG		:addInputEvent( "Mouse_DownScroll",		"Scroll_ItemMarketAlarmList( false )")
		slot.icon		:addInputEvent( "Mouse_UpScroll", 		"Scroll_ItemMarketAlarmList( true )")
		slot.icon		:addInputEvent( "Mouse_DownScroll",		"Scroll_ItemMarketAlarmList( false )")
		slot.itemName	:addInputEvent( "Mouse_UpScroll", 		"Scroll_ItemMarketAlarmList( true )")
		slot.itemName	:addInputEvent( "Mouse_DownScroll",		"Scroll_ItemMarketAlarmList( false )")
		slot.unSetBtn	:addInputEvent( "Mouse_UpScroll", 		"Scroll_ItemMarketAlarmList( true )")
		slot.unSetBtn	:addInputEvent( "Mouse_DownScroll",		"Scroll_ItemMarketAlarmList( false )")

		-- {템플릿용 UI 끄기
			self.ui.temp_SlotBG			:SetShow( false )
			self.ui.temp_Slot_IconBG	:SetShow( false )
			self.ui.temp_Slot_Icon		:SetShow( false )
			self.ui.temp_Slot_ItemName	:SetShow( false )
			self.ui.temp_Button_UnSelect:SetShow( false )
		-- }
	end

	toClient_LoadItemMarketFavoriteItem()	-- 정보를 로드한다.
end
ItemMarketAlarm:Init()


function ItemMarketAlarm:Update()
	-- 초기화
	for slotIdx = 0, self.config.maxSlotCount -1 do
		local slot = self.uiPool[slotIdx]
		slot.slotBG			:SetShow( false )
		slot.unSetBtn		:addInputEvent( "Mouse_LUp", "" )
		slot.enchantLevel	:SetShow(false)
	end

	-- 업데이트
	self.config.totalItemCount = toClient_GetItemMarketFavoriteItemListSize()
	local uiCount	= 0
	if 0 < self.config.totalItemCount then
		for slotIdx = self.config.startIndex, self.config.totalItemCount -1 do
			if self.config.maxSlotCount <= uiCount then
				break
			end

			local slot				= self.uiPool[uiCount]
			local enchantItemKey	= toClient_GetItemMarketFavoriteItem( slotIdx )
			local itemSSW			= getItemEnchantStaticStatus( enchantItemKey )
			local itemName			= itemSSW:getName()
			local enchantLevel		= itemSSW:get()._key:getEnchantLevel()
			local enchantLevelValue	= ""
			local iconPath			= itemSSW:getIconPath()
			local isCash			= itemSSW:get():isCash()

			local nameColorGrade	= itemSSW:getGradeType()
			if ( 0 == nameColorGrade ) then
				slot.itemName:SetFontColor(UI_color.C_FFFFFFFF)
			elseif ( 1 == nameColorGrade ) then
				slot.itemName:SetFontColor(4284350320)
			elseif ( 2 == nameColorGrade ) then
				slot.itemName:SetFontColor(4283144191)
			elseif ( 3 == nameColorGrade ) then
				slot.itemName:SetFontColor(4294953010)
			elseif ( 4 == nameColorGrade ) then
				slot.itemName:SetFontColor(4294929408)
			else
				slot.itemName:SetFontColor(UI_color.C_FFFFFFFF)
			end

			-- { 아이템 아이콘 레벨 표기
				if 0 < enchantLevel and enchantLevel < 16 then
					if true == isCash then
						slot.enchantLevel:SetShow(false)
					else
						slot.enchantLevel:SetText( "+" .. tostring(enchantLevel) )										-- 인챈트 수치
						slot.enchantLevel:SetShow(true)
					end
				elseif 16 == enchantLevel then
					slot.enchantLevel:SetText( "I" )		-- 인챈트 수치
					slot.enchantLevel:SetShow(true)
				elseif 17 == enchantLevel then
					slot.enchantLevel:SetText( "II" )		-- 인챈트 수치
					slot.enchantLevel:SetShow(true)
				elseif 18 == enchantLevel then
					slot.enchantLevel:SetText( "III" )		-- 인챈트 수치
					slot.enchantLevel:SetShow(true)
				elseif 19 == enchantLevel then
					slot.enchantLevel:SetText( "IV" )		-- 인챈트 수치
					slot.enchantLevel:SetShow(true)
				elseif 20 == enchantLevel then
					slot.enchantLevel:SetText( "V" )		-- 인챈트 수치
					slot.enchantLevel:SetShow(true)
				-- elseif 20 <= enchantLevel then
				-- 	slot.enchantLevel:SetText( "VI" )		-- 인챈트 수치
				-- 	slot.enchantLevel:SetShow(true)
				end
			-- }


			-- { 액세서리일 경우 인챈트 표기를 달리 해준다!
				if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
					if 1 == enchantLevel then
						slot.enchantLevel:SetText( "I" )		-- 인챈트 수치
						slot.enchantLevel:SetShow(true)
					elseif 2 == enchantLevel then
						slot.enchantLevel:SetText( "II" )		-- 인챈트 수치
						slot.enchantLevel:SetShow(true)
					elseif 3 == enchantLevel then
						slot.enchantLevel:SetText( "III" )		-- 인챈트 수치
						slot.enchantLevel:SetShow(true)
					elseif 4 == enchantLevel then
						slot.enchantLevel:SetText( "IV" )		-- 인챈트 수치
						slot.enchantLevel:SetShow(true)
					elseif 5 == enchantLevel then
						slot.enchantLevel:SetText( "V" )		-- 인챈트 수치
						slot.enchantLevel:SetShow(true)
					end
				end
			-- }

			slot.slotBG		:SetShow( true )
			slot.itemName	:SetText( itemName )
			slot.icon		:ChangeTextureInfoName( "Icon/" .. iconPath )

			slot.unSetBtn	:addInputEvent( "Mouse_LUp", "HandleClicked_ItemMarketAlarm_UnSet( " .. enchantItemKey:get() .. " )" )

			uiCount = uiCount + 1
		end
		UIScroll.SetButtonSize( self.ui.scroll, self.config.maxSlotCount, self.config.totalItemCount)
	end
	
	if self.config.maxSlotCount < self.config.totalItemCount then
		self.ui.scroll:SetShow( true )
	else
		self.ui.scroll:SetShow( false )
	end
end


function ItemMarketAlarm:Open()
	if Panel_Window_ItemMarket:GetShow() then
		FGolbal_ItemMarket_Close()
	end

	if Panel_Window_ItemMarket_ItemSet:GetShow() then
		FGlobal_ItemMarketItemSet_Close()
	end

	if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
		FGlobal_ItemMarket_BuyConfirm_Close()
	end

	if Panel_Window_ItemMarket_RegistItem:GetShow() then
		FGlobal_ItemMarketRegistItem_Close()
	end

	Panel_ItemMarket_AlarmList:SetShow( true, true )

	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_ItemMarket_AlarmList:GetSizeX()
	local panelSizeY 	= Panel_ItemMarket_AlarmList:GetSizeY()

	Panel_ItemMarket_AlarmList:SetPosX( (scrSizeX / 2) - (panelSizeX / 2) )
	Panel_ItemMarket_AlarmList:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) )

	self.ui.scroll:SetControlPos( 0 )
	self.config.startIndex		= 0
	self.config.totalItemCount	= 0

	self:Update()
end

function ItemMarketAlarm:Close()
	Panel_ItemMarket_AlarmList:SetShow( false, false )
	self.ui.scroll:SetControlPos( 0 )
	self.config.startIndex		= 0
	self.config.totalItemCount	= 0

	toClient_SaveItemMarketFavoriteItem()	-- 정보를 저장한다.
end


function ItemMarketAlarmList_ShowAni()
	local aniInfo1 = Panel_ItemMarket_AlarmList:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.12)
	aniInfo1.AxisX = Panel_ItemMarket_AlarmList:GetSizeX() / 2
	aniInfo1.AxisY = Panel_ItemMarket_AlarmList:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_ItemMarket_AlarmList:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.12)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_ItemMarket_AlarmList:GetSizeX() / 2
	aniInfo2.AxisY = Panel_ItemMarket_AlarmList:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end
function ItemMarketAlarmList_HideAni()
	local aniInfo1 = Panel_ItemMarket_AlarmList:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
		aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
		aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
		aniInfo1:SetStartIntensity( 3.0 )
		aniInfo1:SetEndIntensity( 1.0 )
		aniInfo1.IsChangeChild = true
		aniInfo1:SetHideAtEnd(true)
		aniInfo1:SetDisableWhileAni(true)
end


function Scroll_ItemMarketAlarmList( isScrollUp )
	ItemMarketAlarm.config.startIndex = UIScroll.ScrollEvent( ItemMarketAlarm.ui.scroll, isScrollUp, ItemMarketAlarm.config.maxSlotCount, ItemMarketAlarm.config.totalItemCount, ItemMarketAlarm.config.startIndex, 1 )
	ItemMarketAlarm:Update()
end


function HandleClicked_ItemMarketAlarm_UnSet( enchantItemKey )
	if nil ~= enchantItemKey then
		toClient_EraseItemMarketFavoriteItem( enchantItemKey )
	end
	ItemMarketAlarm:Update()
	-- toClient_SaveItemMarketFavoriteItem()	-- 정보를 저장한다. 클라에서 처리한다.
end

function HandleClicked_ItemMarketAlarmList_Close()
	ItemMarketAlarm:Close()
end

function FGlobal_ItemMarketAlarmList_Open()
	ItemMarketAlarm:Open()
end

function FGlobal_ItemMarketAlarmList_Close()
	ItemMarketAlarm:Close()
end

function ItemMarketAlarm:registEventHandler()
	self.ui.btn_Close			:addInputEvent("Mouse_LUp", 			"HandleClicked_ItemMarketAlarmList_Close()")

	self.ui.bg					:addInputEvent( "Mouse_UpScroll", 		"Scroll_ItemMarketAlarmList( true )")
	self.ui.bg					:addInputEvent( "Mouse_DownScroll",		"Scroll_ItemMarketAlarmList( false )")

	UIScroll.InputEvent( self.ui.scroll, "Scroll_ItemMarketAlarmList" )
end
function ItemMarketAlarm:registMessageHandler()
	-- registerEvent("FromClient_responseItemMarkgetInfo", "FromClient_responseItemMarkgetInfo")
end

ItemMarketAlarm:registEventHandler()
ItemMarketAlarm:registMessageHandler()
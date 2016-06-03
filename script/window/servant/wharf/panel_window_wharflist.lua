Panel_Window_WharfList:SetShow(false, false)
Panel_Window_WharfList:setMaskingChild(true)
Panel_Window_WharfList:ActiveMouseEventEffect(true)
Panel_Window_WharfList:setGlassBackground(true)

Panel_Window_WharfList:RegisterShowEventFunc( true,		"WharfListShowAni()" )
Panel_Window_WharfList:RegisterShowEventFunc( false,	"WharfListHideAni()" )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local wharfInvenAlert = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_WITHITEM_MSG") -- "\n\n<PAColor0xFFDB2B2B>(※해당 탈것의 가방 안에 있는 아이템은<PAOldColor>\n<PAColor0xFFDB2B2B>모두 사라집니다.)<PAOldColor>"

function	WharfListShowAni()
	local isShow	= Panel_Window_WharfList:IsShow()
	
	-- 꺼준다
	if isShow == true then
		Panel_Window_WharfList:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
		
		local aniInfo1 = Panel_Window_WharfList:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
		aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
		aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
		aniInfo1:SetStartIntensity( 3.0 )
		aniInfo1:SetEndIntensity( 1.0 )
		aniInfo1.IsChangeChild = true
		aniInfo1:SetHideAtEnd(true)
		aniInfo1:SetDisableWhileAni(true)

		-- local aniInfo2 = Panel_Window_WharfList:addScaleAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
		-- aniInfo2:SetStartScale(1.0)
		-- aniInfo2:SetEndScale(0.97)
		-- aniInfo2.AxisX = 200
		-- aniInfo2.AxisY = 295
		-- aniInfo2.IsChangeChild = true
		-- aniInfo2:SetDisableWhileAni(true)
	else
		UIAni.fadeInSCR_Down(Panel_Window_WharfList)
		Panel_Window_WharfList:SetShow(true, false)
	end
end

function	WharfListHideAni()
	Inventory_SetFunctor( nil )
	
	Panel_Window_WharfList:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	
	local aniInfo1 = Panel_Window_WharfList:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)

	-- local aniInfo2 = Panel_Window_WharfList:addScaleAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	-- aniInfo2:SetStartScale(1.0)
	-- aniInfo2:SetEndScale(0.97)
	-- aniInfo2.AxisX = 200
	-- aniInfo2.AxisY = 295
	-- aniInfo2.IsChangeChild = true
	-- aniInfo2:SetDisableWhileAni(true)
	
	WharfList_ButtonClose()
	-- Panel_Window_WharfList:SetShow(false, false);
	-- UI.debugMessage('hide')
end

local	wharfList	= {
	_const	=
	{
		eTypeSealed		= 0,
		eTypeUnsealed	= 1,
		-- eTypeTaming		= 2,
	},
	_config	=
	{
		slot	=
		{
			startX		= 15,
			startY		= 15,
			gapY		= 158,
		},
		
		icon	=
		{
			startX		= 0,
			startY		= 0,
			startNameX	= 5,
			startNameY	= 120,
			startEffectX= -1,
			startEffectY= -1,
		},
		
		unseal	=
		{
			startX		= 230,
			startY		= 0,
			startButtonX= 25,
			startButtonY= 25,
			startIconX	= 25,
			startIconY	= 35,
		},
		
		button	=
		{
			startX		= 180,
			startY		= 0,
			startButtonX= 15,
			startButtonY= 10,
			gapY		= 40,
			sizeY		= 40,
			sizeYY		= 10,
		},
		
		slotCount		= 4,
	},
	
	_staticListBG			= UI.getChildControl( Panel_Window_WharfList, 	"Static_ListBG"				),	-- list BackGround	
	_staticButtonListBG		= UI.getChildControl( Panel_Window_WharfList, 	"Static_ButtonBG"			),	-- button BackGround
	_staticUnsealBG			= UI.getChildControl( Panel_Window_WharfList, 	"Static_UnsealBG"			),	-- unseal Vehicle BackGround
	
	_staticNoticeText		= UI.getChildControl( Panel_Window_WharfList, 	"StaticText_Notice" 		),	-- button List Notice ( 아무것도 없을 때 )
	_staticSlotCount		= UI.getChildControl( Panel_Window_WharfList, 	"StaticText_Slot_Count"		),	-- 슬롯 개수 '1/5'
	
	_scroll					= UI.getChildControl( Panel_Window_WharfList,	"Scroll_Slot_List"			),
	
	-- init에서 생성.
	--_buttonSeal			= nil,
	--_buttonCompulsionSeal	= nil,
	--_buttonUnseal			= nil,
	--_buttonRepair			= nil,
	--_buttonSell			= nil,
	--_buttonChangeName		= nil,
	
	_slots					= Array.new(),
	_selectSlotNo			= 0,														-- 선택된 슬롯 번호
	_startSlotIndex			= 0,														-- 현재 스크롤 시작 번호.
	_selectSceneIndex		= -1,
	_unseal					= {},
}

----------------------------------------------------------------------------------------------------
-- Init Function
function	wharfList:init()
	for	ii = 0, self._config.slotCount-1	do
		local	slot		= {}
		slot.slotNo			= ii
		slot.panel			= Panel_Window_WharfList
					
		slot.button			= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Static_Button",				self._staticListBG,	"WharfList_Slot_"			.. ii )
		slot.effect			= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Static_Button_Effect",		slot.button,		"WharfList_Slot_Effect_"	.. ii )
		slot.icon			= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Static_Icon",				slot.button,		"WharfList_Slot_Icon_"		.. ii )
		slot.name			= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "StaticText_Name",			slot.button,		"WharfList_Slot_Name_"		.. ii )
		slot.stateComa		= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "StaticText_Coma",			slot.button,		"WharfList_Slot_StateComa_"	.. ii )
		slot.isSeized		= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "StaticText_Attachment",		slot.button,		"WharfList_Slot_Seize_"		.. ii )
		
		-- 좌표 설정.
		local	slotConfig	= self._config.slot
		slot.button:SetPosX( slotConfig.startX )
		slot.button:SetPosY( slotConfig.startY + slotConfig.gapY * ii )
		
		local	iconConfig	= self._config.icon
		slot.icon:SetPosX(	iconConfig.startX )
		slot.icon:SetPosY(	iconConfig.startY )
		slot.name:SetPosX(	iconConfig.startNameX )
		slot.name:SetPosY(	iconConfig.startNameY )
		slot.stateComa:SetPosX( iconConfig.startX )
		slot.stateComa:SetPosY( iconConfig.startY )
		slot.isSeized:SetPosX(	iconConfig.startX )
		slot.isSeized:SetPosY(	iconConfig.startY )
		slot.effect:SetPosX(iconConfig.startEffectX )
		slot.effect:SetPosY(iconConfig.startEffectY )

		slot.icon:ActiveMouseEventEffect(true)
		
		slot.button:addInputEvent(	"Mouse_LUp",	"WharfList_SlotSelect(" .. (ii) .. ")" )
		
		UIScroll.InputEventByControl( slot.button,	"WharfList_ScrollEvent" )
		
		self._slots[ii]	= slot
	end

	-- 찾은 탈것 정보
	--{
		self._unseal._button		= UI.createAndCopyBasePropertyControl(	Panel_Window_WharfList, "Static_Button",	self._staticUnsealBG,	"WharfList_Unseal_Button"		)
		self._unseal._icon			= UI.createAndCopyBasePropertyControl(	Panel_Window_WharfList, "Static_Icon",		self._staticUnsealBG,	"WharfList_Unseal_Icon"			)
		
		-- 좌표 설정.
		local	unsealConfig			= self._config.unseal
		self._unseal._button:SetPosX(	unsealConfig.startButtonX	)
		self._unseal._button:SetPosY(	unsealConfig.startButtonY	)
		self._unseal._icon:SetPosX(		unsealConfig.startIconX		)
		self._unseal._icon:SetPosY(		unsealConfig.startIconY		)
		
		self._unseal._icon:SetIgnore( true )
		
		self._unseal._button:addInputEvent( "Mouse_LUp",	"WharfList_ButtonOpen( 1, 0 )" )
	--}
	
	-- 버튼
	--{
		self._buttonSeal				= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Button_Seal",			self._staticButtonListBG,	"WharfList_Button_Seal"				)
		self._buttonCompulsionSeal		= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Button_CompulsionSeal",	self._staticButtonListBG,	"WharfList_Button_CompulsionSeal"	)
		
		self._buttonUnseal				= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Button_Unseal",			self._staticButtonListBG,	"WharfList_Button_Unseal"			)
		self._buttonRepair				= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Button_Repair",			self._staticButtonListBG,	"WharfList_Button_Repair"			)
		self._buttonSell				= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Button_Sell",			self._staticButtonListBG,	"WharfList_Button_Sell"				)
		self._buttonChangeName			= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Button_ChangeName",		self._staticButtonListBG,	"WharfList_Button_ChangeName"		)
		self._buttonClearDeadCount		= UI.createAndCopyBasePropertyControl( Panel_Window_WharfList, "Button_KillReset",		self._staticButtonListBG,	"WharfList_DeadCountReset" )
	--}	
	self._scroll:SetControlPos( 0 )	-- 맨 위로 올림!
	
	-- 우선 순위 설정
	Panel_Window_WharfList:SetChildIndex( self._staticButtonListBG, 9999)
end

function	wharfList:update()
	local	servantCount	= stable_count()
	
	-- 비어있으면 notice 출력.
	if 0 == servantCount then
		self._staticNoticeText:SetShow(true)
	else
		self._staticNoticeText:SetShow(false)
		wharfList_SortDataupdate()
	end
	
	-- 축사 슬롯 개수 표시
	self._staticSlotCount:SetText( stable_currentSlotCount() .. " / " .. stable_maxSlotCount() )
	
	--전체 disable
	for	ii = 0, (self._config.slotCount-1)	do
		local	slot	= self._slots[ii]
		slot.index		= -1
		slot.button:SetShow(false)
	end
	
	local	regionInfo		= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local	regionName		= regionInfo:getAreaName()
	local	slotNo	= 0
	for	ii = self._startSlotIndex, (servantCount-1)	do
		local	sortIndex		= wharfList_SortByWayPointKey( ii )
		local	servantInfo		= stable_getServant( sortIndex )
		local	servantRegionName = servantInfo:getRegionName()
		if	( nil ~= servantInfo )	then
			if	(slotNo <= self._config.slotCount-1)	then
				local	slot	= self._slots[slotNo]
				slot.name:SetText( servantInfo:getName(ii) .. '\n(' .. servantInfo:getRegionName(ii) .. ')' )
				slot.icon:ChangeTextureInfoName( servantInfo:getIconPath1() )
				
				slot.stateComa:SetShow(false)
				slot.isSeized:SetShow(false)
				
				if (servantInfo:isSeized())	then
					slot.isSeized:SetShow(true)
				elseif	( CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() )	then
					slot.stateComa:SetShow(true)
				end
				
				slot.button:SetShow(true)
				slot.index	= ii
				slotNo		= slotNo + 1
				
				if regionName == servantRegionName then
					slot.button:SetMonoTone( false )
				else
					slot.button:SetMonoTone( true )
				end
			end
		end
	end
	
	-- 찾은 탈것
	self._staticUnsealBG:SetShow(false)
	local	temporaryWrapper	= getTemporaryInformationWrapper()
	local	servantInfo	= temporaryWrapper:getUnsealVehicle( stable_getServantType() )
	if	( nil ~= servantInfo )	then
		self._unseal._icon:ChangeTextureInfoName( servantInfo:getIconPath1() )
			
		self._staticUnsealBG:SetShow(true)
	end
	
	-- scroll 설정
	UIScroll.SetButtonSize( self._scroll, self._config.slotCount, servantCount )
end

function	wharfList:registEventHandler()
	UIScroll.InputEvent( self._scroll,			"WharfList_ScrollEvent"									)
	Panel_Window_WharfList:addInputEvent(		"Mouse_UpScroll",	"WharfList_ScrollEvent( true  )"	)
	Panel_Window_WharfList:addInputEvent(		"Mouse_DownScroll",	"WharfList_ScrollEvent( false )"	)
	
	self._buttonSeal:addInputEvent(				"Mouse_LUp",		"WharfList_Seal( false )"			)
	self._buttonCompulsionSeal:addInputEvent(	"Mouse_LUp",		"WharfList_Seal( true  )"			)
	self._buttonUnseal:addInputEvent(			"Mouse_LUp",		"WharfList_Unseal()"				)
	self._buttonRepair:addInputEvent(			"Mouse_LUp",		"WharfList_Recovery()" 				)
	self._buttonSell:addInputEvent(				"Mouse_LUp",		"WharfList_SellToNpc()" 			)
	self._buttonChangeName:addInputEvent(		"Mouse_LUp",		"WharfList_ChangeName()" 			)
	self._buttonClearDeadCount:addInputEvent(	"Mouse_LUp",		"WharfList_ClearDeadCount()"		)
end

function	wharfList:registMessageHandler()
	registerEvent("onScreenResize",					"WharfList_Resize" )
	registerEvent("FromClient_ServantUpdate",		"WharfList_updateSlotData")
	registerEvent("FromClient_GroundMouseClick",	"WharfList_ButtonClose")
	-- registerEvent("FromClient_ServantSeal",			"FromClient_WharfServantSeal")				-- 말을 맡겼을 때
	-- registerEvent("FromClient_ServantUnseal",		"FromClient_WharfServantUnseal")			-- 찾기 시 호출
	-- registerEvent("FromClient_ServantToReward",		"FromClient_WharfServantToReward")			-- 판매 or 놓아주기
	-- registerEvent("FromClient_ServantChangeName",	"FromClient_WharfServantChangeName")		-- 이름 변경
	-- registerEvent("FromClient_ServantRecovery",		"FromClient_WharfServantRecovery")				-- 회복시 호출
end

function	WharfList_Resize()
	local	screenX	= getScreenSizeX()
	local	screenY	= getScreenSizeY()
	local	self	= wharfList
	
	local	panelSize	= 0
	local	panelBGSize	= 0
	local	scrollSize	= 0
	local	slotCount	= 4
	if	( 1000 < screenY )	then
		panelSize	= 700
		panelBGSize	= 660
		scrollSize	= 660
		slotCount	= 4
		if (nil ~= self._slots[3]) then
			self._slots[3].button:SetShow(true)
		end
	else
		panelSize	= 540
		panelBGSize	= 500
		scrollSize	= 500
		slotCount	= 3
		if (nil ~= self._slots[3]) then
			self._slots[3].button:SetShow(false)
		end
	end
	
	Panel_Window_WharfList:SetSize(Panel_Window_WharfList:GetSizeX(), panelSize)

	self._staticListBG:SetSize(self._staticListBG:GetSizeX(), panelBGSize)
	self._scroll:SetSize(self._scroll:GetSizeX(), scrollSize)
	self._config.slotCount	= slotCount
end
----------------------------------------------------------------------------------------------------
-- Popup Function
function	WharfList_ButtonOpen( eType, slotNo )
	local	self		= wharfList
	-- local	iconConfig	= self._config.icon
	
	-- if	( not isUnsealServantSelect )	then
	-- 	audioPostEvent_SystemUi(01,00)
	-- end
	
	self._buttonSeal:SetShow(false)
	self._buttonCompulsionSeal:SetShow(false)
	
	self._buttonUnseal:SetShow(false)
	self._buttonRepair:SetShow(false)
	self._buttonSell:SetShow(false)
	self._buttonChangeName:SetShow(false)
	self._buttonClearDeadCount:SetShow( false )
	
	local	buttonList		= {}
	local	button_Index	= 0
	local	buttonConfig	= self._config.button
	local	positionX		= 0
	local	positionY		= 0

	local	regionInfo		= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local	regionName		= regionInfo:getAreaName()
	
	if ( eType == self._const.eTypeSealed ) then
		local	index 		= WharfList_SelectSlotNo()
		local	servantInfo	= stable_getServant( index )
		if	(nil == servantInfo)	then
			return
		end
	
		WharfList_SlotSound( slotNo )

		local	servantRegionName = servantInfo:getRegionName()
		
		local getState		= servantInfo:getStateType()
		local nowHp			= servantInfo:getHp()
		local maxHp			= servantInfo:getMaxHp()
		local nowMp			= servantInfo:getMp()
		local maxMp			= servantInfo:getMaxMp()
		
		if regionName == servantRegionName then
			-- 나오는 순서 : 찾기, 판매, 회복, 이름변경, 죽은 횟수 초기화
			buttonList[button_Index]		= self._buttonUnseal
			buttonList[button_Index + 1]	= self._buttonSell
			button_Index = button_Index + 2
		
			if ( nowHp < maxHp )then
				buttonList[button_Index]	= self._buttonRepair
				button_Index = button_Index + 1
			end

			if FGlobal_IsCommercialService() then
				buttonList[button_Index]	= self._buttonChangeName
			end

			if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
				self._buttonClearDeadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_KILLCOUNTRESET") ) -- "죽은 횟수 초기화")
			elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Carriage or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_CowCarriage then
				self._buttonClearDeadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_DESTROYCOUNTRESET") ) -- "파괴 횟수 초기화")
			elseif servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
				self._buttonClearDeadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_DESTROYCOUNTRESET") ) -- "파괴 횟수 초기화")
			end

			if FGlobal_IsCommercialService() then
				buttonList[button_Index+1]	= self._buttonClearDeadCount
			end
		else
			if ( 0 == nowHp )then
				buttonList[button_Index]	= self._buttonRepair
				button_Index = button_Index + 1
			end
		end

		positionX = self._slots[slotNo].button:GetPosX() + buttonConfig.startX
		positionY = self._slots[slotNo].button:GetPosY() + buttonConfig.startY
	elseif	( eType == self._const.eTypeUnsealed )	then
		buttonList[button_Index]	= self._buttonSeal
		buttonList[button_Index+1]	= self._buttonCompulsionSeal
		button_Index	= button_Index + 2
				
		positionX = self._staticUnsealBG:GetPosX() + self._staticUnsealBG:GetSizeX()
		positionY = self._staticUnsealBG:GetPosY() + 20
	end

	local	sizeX	= self._staticButtonListBG:GetSizeX()
	local	sizeY	= buttonConfig.sizeYY
	if 0 < #buttonList then
		for index, button in pairs(buttonList) do
			button:SetShow( true )
			button:SetPosX( buttonConfig.startButtonX								)
			button:SetPosY( buttonConfig.startButtonY + buttonConfig.gapY * index	)
			sizeY	= sizeY + buttonConfig.sizeY
		end
		self._staticButtonListBG:SetPosX( positionX	)
		self._staticButtonListBG:SetPosY( positionY	)
		self._staticButtonListBG:SetSize( sizeX, sizeY )
		self._staticButtonListBG:SetShow(true)
	else
		self._staticButtonListBG:SetShow(false)
	end
	button_Index = 0
end

function	WharfList_ButtonClose()
	local	self		= wharfList
	if	( not self._staticButtonListBG:GetShow() )	then
		return
	end
	
	self._staticButtonListBG:SetShow(false)
end
----------------------------------------------------------------------------------------------------
-- Button Function
function	WharfList_SlotSelect( slotNo )
	if not Panel_Window_WharfList:GetShow() then
		return
	end
	audioPostEvent_SystemUi(00,00)
	
	local	self		= wharfList
	if (self._config.slotCount <= slotNo)	then
		self._startSlotIndex = slotNo - self._config.slotCount
		self:update()
		return
	end
	
	if	-1 == self._slots[slotNo].index	then
		return
	end
	
	-- effect 초기화
	for ii = 0, self._config.slotCount-1	do
		self._slots[ii].effect:SetShow(false)
	end
	
	self._slots[slotNo].effect:SetShow(true)
	self._selectSlotNo		= self._slots[slotNo].index
	
	local	servantInfo	= stable_getServant( WharfList_SelectSlotNo() )
	if( nil == servantInfo )	then
		return
	end

	self._selectSceneIndex	= Servant_ScenePushObject( servantInfo, self._selectSceneIndex )

	WharfInfo_Open()
	WharfList_ButtonOpen( self._const.eTypeSealed, slotNo )
end

function	WharfList_UnsealSlotSelect()
	WharfList_ButtonClose()
	WharfList_ButtonOpen( 0, slotNo )
end

function	WharfList_Seal( isCompulsionSeal )
	local self = wharfList
	audioPostEvent_SystemUi(00,00)
	WharfList_ButtonClose()
	if	( isCompulsionSeal )	then
		local needGold			= tostring(getServantCompulsionSealPrice())
		local messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_MESSAGEBOX_TITLE" )
		local messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_COMPULSIONSEAL_MESSAGE1" ) .. needGold .. PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_COMPULSIONSEAL_MESSAGE2" )
		
		Servant_Confirm( messageBoxTitle, messageBoxMemo, WharfList_Button_CompulsionSeal, MessageBox_Empty_function )
	else
		stable_seal( false )
	end

	Servant_ScenePopObject( self._selectSceneIndex )
	WharfList_SlotSelect( 0 )
end

function	WharfList_Button_CompulsionSeal()
	stable_seal( true )
end

function	WharfList_Unseal()
	-- ♬ 배를 맡긴다.
	audioPostEvent_SystemUi(00,00)
	
	stable_unseal( WharfList_SelectSlotNo() )
	WharfList_ButtonClose()

	-- 말을 바꾸면, 말 피격시 이팩트 출력을 위한 _servant_BeforHP 값을 새로 바꿔준다.
	-- local	servantInfo		= stable_getServant( WharfList_SelectSlotNo() )
	-- if	nil == servantInfo	then
	-- 	return
	-- end
	--reset_ServantHP( servantInfo:getHp() )
end

function	WharfList_Recovery()
	local	servantInfo		= stable_getServant( WharfList_SelectSlotNo() )
	if	( nil == servantInfo )	then
		return
	end
	
	local	needMoney		= 0
	local	confirmFunction	= nil
	if	0 == servantInfo:getHp()	then
		needMoney		= Int64toInt32( servantInfo:getReviveCost_s64() )
		confirmFunction	= WharfList_ReviveXXX
	else
		needMoney		= Int64toInt32( servantInfo:getRecoveryCost_s64() )
		confirmFunction	= WharfList_RecoveryXXX
	end
	
	Servant_Confirm( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_TITLE"), PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_CARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", needMoney ), confirmFunction, MessageBox_Empty_function )
end

function	WharfList_RecoveryXXX()
	audioPostEvent_SystemUi(05,07)
	
	WharfList_ButtonClose()
	stable_recovery( WharfList_SelectSlotNo() )
end

function	WharfList_ReviveXXX()
	WharfList_ButtonClose()
	stable_revive( WharfList_SelectSlotNo() )
	end

function	WharfList_SellToNpc()
	local	servantInfo		= stable_getServant( WharfList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	
	local	resultMoney		= makeDotMoney(servantInfo:getSellCost_s64())
	Servant_Confirm( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_TITLE"), PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_MSG", "resultMoney", resultMoney ) .. wharfInvenAlert, WharfList_SellToNpcXXX, MessageBox_Empty_function )
end

function	WharfList_SellToNpcXXX()
	WharfList_ButtonClose()
	stable_changeToReward( WharfList_SelectSlotNo(), CppEnums.ServantToRewardType.Type_Money )
end

function	WharfList_ChangeName()
	WharfList_ButtonClose()
	WharfRegister_OpenByChangeName()
end

function WharfList_ClearDeadCount()
	WharfList_ButtonClose()
	audioPostEvent_SystemUi(00,00)

	local clearDeadCountDo = function()
		stable_clearDeadCount( WharfList_SelectSlotNo() )
	end

	local messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_KILLCOUNTRESET_ALLRECOVERY") -- "이 탑승물의 죽은 횟수를 초기화 하시겠습니까? 초기화와 함께 탑승물의 생명력이 회복됩니다."
	local messageBoxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = messageBoxMemo, functionYes = clearDeadCountDo, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end
----------------------------------------------------------------------------------------------------
-- Common Function
function	WharfList_SelectSlotNo()
	local	self	= wharfList
	return( wharfList_SortByWayPointKey( self._selectSlotNo ))
end

function	WharfList_SlotSound(slotNo)
	if	( isFirstSlot )	then
		isFirstSlot = false
	else
		audioPostEvent_SystemUi(01,00)
	end
end

function	WharfList_ScrollEvent( isScrollUp )
	local	self		= wharfList
	local	servantCount= stable_count()
	
	self._startSlotIndex= UIScroll.ScrollEvent( self._scroll, isScrollUp, self._config.slotCount, servantCount, self._startSlotIndex, 1 )
	
	self:update()
	self._staticButtonListBG:SetShow(false)
end

-- 소팅 룰
-- 1. 배열에 클라에서 뿌려주는 순서를 저장
-- 2. 익스플로어키에 맞게 오름차순 정렬
-- 3. 현재 자신의 익스플로어키와 같은 말들은 가장 상위로 올라가도록 재정렬
-- 4. 현재 자신의 테리토리키에 맞게 테리토리별 정렬
-- 5. 서번트No로 비교해 변경된 인덱스값 리턴
local sortByExploreKey = {}
function wharfList_ServantCountInit( nums )
	for i = 1, nums do
		sortByExploreKey[i] = {
			_index		= nil,
			_servantNo	= nil,
			_exploreKey	= nil,
			_areaName	= nil,
		}
	end
end

function	wharfList_SortDataupdate()
	-- 우선 기존 인덱스에 해당하는 익스플로어키를 저장합시다.
	local maxWharfServantCount = stable_count()
	wharfList_ServantCountInit( maxWharfServantCount )
	for ii = 1, maxWharfServantCount do
		local	servantInfo		= stable_getServant( ii-1 )
		if	nil ~= servantInfo	then
			local regionKey = servantInfo:getRegionKeyRaw()
			local regionInfoWrapper = getRegionInfoWrapper(regionKey)
			sortByExploreKey[ii]._index			= ii - 1
			sortByExploreKey[ii]._servantNo		= servantInfo:getServantNo()
			sortByExploreKey[ii]._exploreKey	= regionInfoWrapper:getExplorationKey()
			sortByExploreKey[ii]._areaName		= regionInfoWrapper:getAreaName()
		end
	end
	
	-- 익스플로어키 오름차순 정렬
	local sortExplaoreKey = function ( a, b )
		if a._exploreKey < b._exploreKey then
			return true
		end
		return false
	end
	table.sort( sortByExploreKey, sortExplaoreKey )
	
	-- 기준으로 삼을 현재의 익스플로어키를 가져옵니다.
	local myRegionKey = getSelfPlayer():getRegionKey():get()
	local myRegionInfoWrapper = getRegionInfoWrapper( myRegionKey )
	local myWayPointKey = myRegionInfoWrapper:getExplorationKey()
	local areaName = myRegionInfoWrapper:getAreaName()
	
	-- 현재 마구간 exploerKey를 최우선 순위로 올려둡니다.
	local matchCount = 0
	local areaSortCount = 0
	local temp = {}
	local temp1 = {}
	for i = 1, maxWharfServantCount do
		if myWayPointKey == sortByExploreKey[i]._exploreKey then
			temp1[matchCount] = sortByExploreKey[i]
			matchCount = matchCount + 1
		end
	end
	
	-- 같은 exploerKey일 땐, 이름으로 다시 정렬!
	for ii = 0, matchCount-1 do
		if areaName == temp1[ii]._areaName then
			temp[areaSortCount] = temp1[ii]
			areaSortCount = areaSortCount + 1
		end
	end
	for ii = 0, matchCount-1 do
		if areaName ~= temp1[ii]._areaName then
			temp[areaSortCount] = temp1[ii]
			areaSortCount = areaSortCount + 1
		end
	end
	
	for i = 1, maxWharfServantCount do
		if myWayPointKey ~= sortByExploreKey[i]._exploreKey then
			temp[matchCount] = sortByExploreKey[i]
			matchCount = matchCount + 1
		end
	end
	
	for i = 1, maxWharfServantCount do
		sortByExploreKey[i] = temp[i-1]
	end
	
	-- 익스플로어키를 기준으로 테리토리키를 가져옵니다.
	local affiliatedTerritory = function( exploerKey )
		local territoryKey = -1
		if 0 < exploerKey and exploerKey <= 300 then
			territoryKey = 0
		elseif 300 < exploerKey and exploerKey <= 600 then
			territoryKey = 1
		elseif 600 < exploerKey and exploerKey <= 1100 then
			territoryKey = 2
		elseif 1100 < exploerKey and exploerKey <= 1300 then
			territoryKey = 3
		elseif 1300 < exploerKey then
			territoryKey = 4
		end
		
		return territoryKey
	end
	
	-- 테리토리별로 정렬
	local sIndex = 0
	local sortByTerritory = function( territoryKey )
		for servantIndex = 1, maxWharfServantCount do
			if affiliatedTerritory(sortByExploreKey[servantIndex]._exploreKey) == territoryKey then
				temp[sIndex] = sortByExploreKey[servantIndex]
				sIndex = sIndex + 1
			end
		end
	end
	
	local myTerritoriKey = affiliatedTerritory( myWayPointKey )
	if 0 == myTerritoriKey then
		sortByTerritory(0)
		sortByTerritory(1)
		sortByTerritory(2)
		sortByTerritory(3)
		-- sortByTerritory(4)

	-- 세렌디아 영지 작업관리
	elseif 1 == myTerritoriKey then
		sortByTerritory(1)
		sortByTerritory(0)
		sortByTerritory(2)
		sortByTerritory(3)
		-- sortByTerritory(4)

	-- 칼페온 영지 작업관리
	elseif 2 == myTerritoriKey then
		sortByTerritory(2)
		sortByTerritory(1)
		sortByTerritory(0)
		sortByTerritory(3)
		-- sortByTerritory(4)

	-- 메디아 영지 작업관리
	elseif 3 == myTerritoriKey then
		sortByTerritory(3)
		sortByTerritory(1)
		sortByTerritory(0)
		sortByTerritory(2)
		-- sortByTerritory(4)
	
	-- 발렌시아 영지 작업관리
	-- elseif 4 == myTerritoriKey then
		-- sortByTerritory(4)
		-- sortByTerritory(3)
		-- sortByTerritory(1)
		-- sortByTerritory(0)
		-- sortByTerritory(2)
	end
	
	for i = 1, maxWharfServantCount do
		sortByExploreKey[i] = temp[i-1]
	end
end

function wharfList_SortByWayPointKey( index )
	if nil == index then
		return nil
	else
		return sortByExploreKey[index+1]._index
	end
end

----------------------------------------------------------------------------------------------------
-- From Client Event Function
function	WharfList_updateSlotData()
	if	(not Panel_Window_WharfList:GetShow() )	then
		return
	end
	local	self	= wharfList
	self:update()
	-- WharfList_SlotSelect( WharfList_SelectSlotNo() )
	-- 판매 등으로 servant가 없어지면 먼저 Scene에서 지워줘야 한다.!
	-- Servant_ScenePopObject( self._selectSceneIndex )
end

-- function	FromClient_WharfServantSeal( servantNo ) -- 맡기기 시 호출
-- 	local	servantInfo		= stable_getServantByServantNo( servantNo )
-- 	if nil == servantInfo then
-- 		return
-- 	end

-- 	Proc_ShowMessage_Ack("탑승물을 맡겼습니다.")
-- end

-- function FromClient_WharfServantUnseal( servantNo )
-- 	local servantInfo = stable_getServantByServantNo( servantNo )
-- 	if nil == servantInfo then
-- 		return
-- 	end

-- 	Proc_ShowMessage_Ack("탑승물을 찾았습니다.")
-- end

-- function FromClient_WharfServantToReward( servantNo )
-- 	local servantInfo = stable_getServantByServantNo( servantNo )
-- 	if nil == servantInfo then
-- 		return
-- 	end

-- 	Proc_ShowMessage_Ack("판매 하였습니다.")
-- end

-- function FromClient_WharfServantChangeName( servantNo )
-- 	local servantInfo = stable_getServantByServantNo( servantNo )
-- 	if nil == servantInfo then
-- 		return
-- 	end

-- 	Proc_ShowMessage_Ack("탑승물의 이름을 변경하였습니다.")
-- end

-- function FromClient_WharfServantRecovery( servantNo )
-- 	local servantInfo = stable_getServantByServantNo( servantNo )
-- 	if nil == servantInfo then
-- 		return
-- 	end

-- 	Proc_ShowMessage_Ack("탑승물이 수리되었습니다.")
-- end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	WharfList_Open()
	if	 Panel_Window_WharfList:IsShow()	then
		return
	end
	
	local	self		= wharfList	
	self._selectSlotNo	= 0
	self._startSlotIndex= 0
	self:update()
	
	Panel_Window_WharfList:SetShow(true)
	
	-- WharfList_SlotSelect( 0 )
	for ii = 0, self._config.slotCount-1	do
		self._slots[ii].effect:SetShow(false)
	end
	
	if	( not Panel_Window_WharfList:GetShow() )	then
		Panel_Window_WharfList:SetShow(true)
	end
	
	self._selectSceneIndex = -1
end

function	WharfList_Close()
	if	 not Panel_Window_WharfList:GetShow()	then
		return
	end
	
	local	self		= wharfList	
	
	Servant_ScenePopObject( self._selectSceneIndex )
	WharfList_ButtonClose()
	WharfInfo_Close()
	WharfRegister_Close()
	
	Panel_Window_WharfList:SetShow(false, false)
end

----------------------------------------------------------------------------------------------------
-- Init
wharfList:init()
wharfList:registEventHandler()
wharfList:registMessageHandler()
WharfList_Resize()

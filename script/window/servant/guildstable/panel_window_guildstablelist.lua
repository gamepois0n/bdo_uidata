Panel_Window_GuildStable_List:SetShow(false, false)
Panel_Window_GuildStable_List:setMaskingChild(true)
Panel_Window_GuildStable_List:ActiveMouseEventEffect(true)
Panel_Window_GuildStable_List:setGlassBackground(true)

Panel_Window_GuildStable_List:RegisterShowEventFunc( true,	'StableListShowAni()' )
Panel_Window_GuildStable_List:RegisterShowEventFunc( false,	'StableListHideAni()' )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_SW			= CppEnums.ServantWhereType
local servantInvenAlert = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_WITHITEM_MSG")
-- "\n\n<PAColor0xFFDB2B2B>(※해당 탈것의 가방 안에 있는 아이템은<PAOldColor>\n<PAColor0xFFDB2B2B>모두 사라집니다.)<PAOldColor>"

function	GuildStableListShowAni()
	local isShow	= Panel_Window_GuildStable_List:IsShow()
	
	if	( isShow )	then
	-- 꺼준다
		Panel_Window_GuildStable_List:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
		local aniInfo1 = Panel_Window_GuildStable_List:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
		aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
		aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
		aniInfo1:SetStartIntensity( 3.0 )
		aniInfo1:SetEndIntensity( 1.0 )
		aniInfo1.IsChangeChild = true
		aniInfo1:SetHideAtEnd(true)
		aniInfo1:SetDisableWhileAni(true)
	else
		UIAni.fadeInSCR_Down(Panel_Window_GuildStable_List)
		Panel_Window_GuildStable_List:SetShow(true, false)
	end
end

function	GuildStableListHideAni()
	Inventory_SetFunctor( nil )
	Panel_Window_GuildStable_List:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_GuildStable_List:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

local	guildStableList	= {
	_const	=
	{
		eTypeSealed		= 0,
		eTypeUnsealed	= 1,
		eTypeTaming		= 2,
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
			startX			= 0,
			startY			= 0,
			startNameX		= 5,
			startNameY		= 120,
			startEffectX	= -1,
			startEffectY	= -1,
			startSexIconX	= 0,
			startSexIconY	= 0,
			startStateX		= 23,
			startStateY		= 3,
		},
		
		unseal	=
		{
			startX		= 230,
			startY		= 0,
			startTitleX	= -15,
			startTitleY	= 0,
			startButtonX= 25,
			startButtonY= 25,
			startIconX	= 25,
			startIconY	= 35,
			startEffectX	= -1,
			startEffectY	= -1,
		},
		
		taming	=
		{
			startX		= 230,
			startY		= 50,
			startTitleX	= 30,
			startTitleY	= 0,
			startButtonX= 25,
			startButtonY= 25,
			startIconX	= 25,
			startIconY	= 35,
			startEffectX	= -1,
			startEffectY	= -1,
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
		
	_staticListBG			= UI.getChildControl( Panel_Window_GuildStable_List, 	"Static_ListBG"				),	
	_staticButtonListBG		= UI.getChildControl( Panel_Window_GuildStable_List, 	"Static_PopupBG"			),
	
	_staticNotice			= UI.getChildControl( Panel_Window_GuildStable_List, 	"StaticText_Notice" 		),
	_staticSlotCount		= UI.getChildControl( Panel_Window_GuildStable_List, 	"StaticText_Slot_Count"		),		-- 슬롯개수
	
	_scroll					= UI.getChildControl( Panel_Window_GuildStable_List,	"Scroll_Slot_List"			),

	_slots					= Array.new(),
	_selectSlotNo			= nil,																				-- 선택된 슬롯 번호
	_startSlotIndex			= 0,																				-- 현재 스크롤 시작 번호.	
	_selectSceneIndex		= -1,
	_unseal					= {},																				-- 찾은 탈것
	_taming					= {},																				-- 길들인 탈것
	_servantMaxLevel		= 30,
}

local sellCheck = true

----------------------------------------------------------------------------------------------------
-- Init Function
function	guildStableList:init()
	
	for	ii = 0, (self._config.slotCount-1)	do
		local	slot		= {}
		slot.slotNo			= ii
		slot.panel			= Panel_Window_GuildStable_List
			
		slot.button			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Static_Button",				self._staticListBG,	"StableList_Slot_"				.. ii )
		slot.effect			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Static_Button_Effect",		slot.button,		"StableList_Slot_Effect_"		.. ii )
		slot.icon			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Static_Icon",				slot.button,		"StableList_Slot_Icon_"			.. ii )
		slot.name			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Static_Name",				slot.button,		"StableList_Slot_Name_"			.. ii )
		slot.maleIcon		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Static_MaleIcon",			slot.button,		"StableList_Slot_IconMale_"		.. ii )
		slot.femaleIcon		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Static_FemaleIcon",			slot.button,		"StableList_Slot_IconFemale_"	.. ii )
		slot.coma			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "StaticText_Coma",			slot.button,		"ServantList_Slot_Coma_"		.. ii )
		slot.grade			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "StaticText_HorseGrade",		slot.button,		"ServantList_Slot_Grade_"		.. ii )
		slot.isSeized		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "StaticText_Attachment",		slot.button,		"ServantList_Slot_Seized"		.. ii )
		slot.unSeal			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "StaticText_SealServant",		slot.button,		"ServantList_Slot_UnSeal_"		.. ii )
		
		-- 좌표 설정.
		local	slotConfig	= self._config.slot
		slot.button:SetPosX( 		slotConfig.startX )
		slot.button:SetPosY( 		slotConfig.startY + slotConfig.gapY * ii )
		
		local	iconConfig	= self._config.icon
		slot.icon		:SetPosX( iconConfig.startX )
		slot.icon		:SetPosY( iconConfig.startY )
		slot.name		:SetPosX( iconConfig.startNameX )
		slot.name		:SetPosY( iconConfig.startNameY )
		slot.effect		:SetPosX( iconConfig.startEffectX )
		slot.effect		:SetPosY( iconConfig.startEffectY )
		slot.maleIcon	:SetPosX( iconConfig.startSexIconX )
		slot.maleIcon	:SetPosY( iconConfig.startSexIconY )
		slot.femaleIcon	:SetPosX( iconConfig.startSexIconX )
		slot.femaleIcon	:SetPosY( iconConfig.startSexIconY )
		
		slot.coma		:SetPosX( iconConfig.startStateX )
		slot.coma		:SetPosY( iconConfig.startStateY )
		slot.grade		:SetPosY( iconConfig.startStateY )
		slot.isSeized	:SetPosX( iconConfig.startStateX )
		slot.isSeized	:SetPosY( iconConfig.startStateY )
		slot.unSeal		:SetPosX( iconConfig.startStateX )
		slot.unSeal		:SetPosY( iconConfig.startStateY )
		
		slot.icon:ActiveMouseEventEffect(true)
		
		slot.button:addInputEvent( "Mouse_LUp",		"GuildStableList_SlotSelect(" .. (ii) .. ")"	)
		
		UIScroll.InputEventByControl( slot.button,	"GuildStableList_ScrollEvent"				)

		self._slots[ii]	= slot
	end
	
	-- 길들인말 정보
	--{
		self._taming._bg		= UI.createAndCopyBasePropertyControl(	Panel_Window_GuildStable_List, "Static_BG",				Panel_Window_GuildStable_List,	"StableList_Taming_BG"		)
		self._taming._title		= UI.createAndCopyBasePropertyControl(	Panel_Window_GuildStable_List, "StaticText_SubTitle",	self._taming._bg,				"StableList_Taming_Title"	)
		self._taming._button	= UI.createAndCopyBasePropertyControl(	Panel_Window_GuildStable_List, "Static_Button",			self._taming._bg,				"StableList_Taming_Button"	)
		self._taming._icon		= UI.createAndCopyBasePropertyControl(	Panel_Window_GuildStable_List, "Static_Icon",			self._taming._bg,				"StableList_Taming_Icon"	)
		self._taming._effect	= UI.createAndCopyBasePropertyControl(	Panel_Window_GuildStable_List, "Static_Button_Taming_Effect",	self._taming._bg,		"StableList_Taming_Effect"	)
		self._taming._title:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILDSTABLELIST_TAME_VEHICLE") )
		
		local	taminglConfig	= self._config.taming
		self._taming._bg:SetPosX(		taminglConfig.startX		)
		self._taming._bg:SetPosY(		taminglConfig.startY		)
		self._taming._title:SetPosX(	taminglConfig.startTitleX	)
		self._taming._title:SetPosY(	taminglConfig.startTitleY	)
		self._taming._button:SetPosX(	taminglConfig.startButtonX	)
		self._taming._button:SetPosY(	taminglConfig.startButtonY	)
		self._taming._icon:SetPosX(		taminglConfig.startIconX	)
		self._taming._icon:SetPosY(		taminglConfig.startIconY	)
		self._taming._effect:SetPosX(	taminglConfig.startButtonX -2	)
		self._taming._effect:SetPosY(	taminglConfig.startButtonY -2	)
		
		self._taming._button:addInputEvent( "Mouse_LUp",	"GuildStableList_ButtonOpen( 2, 0 )" )
	--}

	-- 버튼
	--{
		self._buttonRegister		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Button_Register",		self._staticButtonListBG,	"GuildStableList_Button_Register"					)
		self._buttonSeal			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Button_Seal",			self._staticButtonListBG,	"GuildStableList_Button_Seal"			)
		self._buttonCompulsionSeal	= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Button_CompulsionSeal",	self._staticButtonListBG,	"GuildStableList_Button_CompulsionSeal"	)
		self._buttonUnseal			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Button_Unseal",			self._staticButtonListBG,	"GuildStableList_Button_Unseal"			)
		self._buttonRepair			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Button_Repair",			self._staticButtonListBG,	"GuildStableList_Button_Repair"			)
		self._buttonRecovery		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Button_Recovery",		self._staticButtonListBG,	"GuildStableList_Button_Recovery"		)
		self._buttonRelease			= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_List, "Button_Release",			self._staticButtonListBG,	"GuildStableList_Button_Release"		)
	--}	
	self._scroll:SetControlPos( 0 )	-- 맨 위로 올림!
	
	-- 우선 순위 설정
	Panel_Window_GuildStable_List:SetChildIndex( self._staticButtonListBG, 9999)
end

function	guildStableList:clear()
	self._selectSlotNo	= 0
	self._startSlotIndex= 0
end

-- local unlinkServentSlot = {}
function	guildStableList:update()
	local	servantCount	= guildStable_count()
	
	-- 비어있으면 notice 출력.
	if 0 == servantCount then
		guildStableList._staticNotice:SetShow(true)
	else
		guildStableList._staticNotice:SetShow(false)
	end
	
	-- 축사 슬롯 개수 표시
	self._staticSlotCount:SetText( guildStable_currentSlotCount() .. " / " .. guildStable_maxSlotCount() )
	
	--전체 disable
	for ii = 0, self._config.slotCount-1	do
		local slot	= self._slots[ii]
		slot.index	= -1
		slot.button:SetShow(false)
	end
	
	-- 업데이트 시마다 정렬을 해주자!
	if( 0 < servantCount )	then
		GuildStableList_ServantCountInit( servantCount )				-- 정렬하기 위한 초기화
		GuildStable_SortDataupdate()
	end
	
	local	slotNo	= 0
	local	regionInfo		= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local	regionName		= regionInfo:getAreaName()
	
	for ii = self._startSlotIndex, (servantCount-1)	do
		local	sortIndex				= GuildStable_SortByWayPointKey(ii)
		local	servantInfo				= guildStable_getServant( sortIndex ) -- (태곤) 작업 필요
		if	nil ~= servantInfo	then			-- 마차에 연결된 말은 표시하지 않는다!!
			local servantRegionName			= servantInfo:getRegionName()
			local currentServantRegionName	= servantInfo:getRegionName( ii )
			local regionKey					= servantInfo:getRegionKeyRaw()
			local regionInfoWrapper			= getRegionInfoWrapper(regionKey)
			local exploerKey				= regionInfoWrapper:getExplorationKey()
			local getState					= servantInfo:getStateType()
			local vehicleType				= servantInfo:getVehicleType()			
			
			if	(slotNo <= self._config.slotCount-1)	then
				local slot	= self._slots[slotNo]

				-- 초기화
				slot.maleIcon		:SetShow(false)
				slot.femaleIcon		:SetShow(false)
				slot.isSeized		:SetShow(false)
				slot.unSeal			:SetShow(false)
				slot.coma			:SetShow(false)
				slot.grade			:SetShow(false)

				slot.name:SetText( servantInfo:getName(ii) .. '\n(' .. servantInfo:getRegionName(ii) .. ')' )
				slot.icon:ChangeTextureInfoName( servantInfo:getIconPath1() )

				slot.button:SetMonoTone( false )
				---- 타 지역에서 사망한 말의 경우
				if ( 0 == servantInfo:getHp() ) and (CppEnums.VehicleType.Type_Elephant == vehicleType) then
					slot.button:SetMonoTone( true )
				else
					slot.button:SetMonoTone( false )
				end
				
				slot.isSeized:SetShow( false )
				slot.coma:SetShow( false )
				slot.unSeal:SetShow( false )
				if	( servantInfo:isSeized() )	then		-- 압류 체크
					slot.isSeized:SetShow(true)
				elseif	( CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() )	then
					slot.coma:SetShow(true)
				elseif ( CppEnums.ServantStateType.Type_Field == servantInfo:getStateType() ) then
					slot.unSeal:SetShow(true)
					slot.unSeal:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTING") )
				end

				-- 말 일 경우 성별 아이콘 표시 (캐쉬말 성별 미표시로 인해 수정 ------------------------------------------
				if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
					if ( servantInfo:isMale() ) then
						slot.maleIcon	:SetShow( true )
						slot.femaleIcon	:SetShow( false )
					else
						slot.maleIcon	:SetShow( false )
						slot.femaleIcon	:SetShow( true )
					end
					slot.grade:SetShow( true )
					slot.grade:SetText(PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier())) -- servantInfo:getTier() .. "등급")
				else
					slot.grade		:SetShow( false )
					slot.maleIcon	:SetShow( false )
					slot.femaleIcon	:SetShow( false )
				end
				---------------------------------------------------------------------------------------------------------				
				slot.button:SetShow( true )
				slot.index	= ii
				slotNo		= slotNo + 1
			end
		end
	end
	-- 길들인 코끼리 보여주기
	self._taming._bg:SetShow(false)
	local	characterKey	= stable_getTamingServantCharacterKey()	-- 길들인 코끼리가 있으면, 길들인 코끼리 창을 띄운다.
	if	(nil ~= characterKey)	then
		local	servantInfo	= stable_getServantByCharacterKey( characterKey, 1 )
		if(	nil ~= servantInfo )	then
			self._taming._icon:ChangeTextureInfoName( servantInfo:getIconPath1() )
			self._taming._bg:SetShow(true)
			self._taming._bg:SetPosY(self._config.taming.startButtonY)
		end
	end

	-- scroll 설정
	UIScroll.SetButtonSize( self._scroll, self._config.slotCount, servantCount )
	
	-- 아이템 관련 출력
	FGlobal_NeedGuildStableRegistItem_Print()
end

function FGlobal_GuildStableList_CloseTamingBg()
	local self = guildStableList
	self._taming._bg:SetShow(false)
end

function	guildStableList:registEventHandler()
	UIScroll.InputEvent( self._scroll,			"GuildStableList_ScrollEvent"								)
	
	Panel_Window_GuildStable_List:addInputEvent("Mouse_UpScroll",	"GuildStableList_ScrollEvent( true )"	)
	Panel_Window_GuildStable_List:addInputEvent("Mouse_DownScroll",	"GuildStableList_ScrollEvent( false )"	)
	
	self._buttonSeal:addInputEvent(				"Mouse_LUp",		"GuildStableList_Seal( false )"			)
	self._buttonCompulsionSeal:addInputEvent(	"Mouse_LUp",		"GuildStableList_Seal( true )"			)

	self._buttonRegister:addInputEvent(			"Mouse_LUp",		"GuildStableList_RegisterFromTaming()"	)

	self._buttonRelease:addInputEvent(			"Mouse_LUp",		"GuildStableList_Release()"				)
	self._buttonUnseal:addInputEvent(			"Mouse_LUp",		"GuildStableList_Unseal()"				)
	self._buttonRepair:addInputEvent(			"Mouse_LUp",		"GuildStableList_Recovery()"			)
	self._buttonRecovery:addInputEvent(			"Mouse_LUp",		"GuildStableList_Recovery()" 			)
	-- self._buttonRecoveryUnseal:addInputEvent("Mouse_LUp",		"GuildStableList_RecoveryUnseal()" 		)
	-- self._buttonRepairUnseal:addInputEvent(	"Mouse_LUp",		"GuildStableList_RecoveryUnseal()"		)
end

function	guildStableList:registMessageHandler()
	registerEvent("onScreenResize",							"GuildStableList_Resize" )
	registerEvent("FromClient_ServantUnseal",				"GuildStableList_ServantUnseal" )
	registerEvent("FromClient_ServantSeal",					"GuildStableList_ServantSeal" )
	registerEvent("FromClient_ServantRecovery",				"GuildStableList_ServantRecovery" )
	registerEvent("FromClient_ServantUpdate",				"GuildStableList_UpdateSlotData")
	registerEvent("FromClient_GroundMouseClick",			"GuildStableList_ButtonClose")
	registerEvent("FromClient_RegisterServantFail",			"GuildStableList_PopMessageBox")
	-- registerEvent("FromClient_ServantTaming",				"GuildStableList_UpdateSlotData")
	registerEvent("FromClient_ServantToReward",				"GuildStableList_ServantToReward")			-- 판매 or 놓아주기
end

function	GuildStableList_Resize()
	local	screenX	= getScreenSizeX()
	local	screenY	= getScreenSizeY()
	local	self	= guildStableList
	
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
	
	Panel_Window_GuildStable_List:SetSize(Panel_Window_GuildStable_List:GetSizeX(), panelSize)
	
	self._staticListBG:SetSize(self._staticListBG:GetSizeX(), panelBGSize)
	self._scroll:SetSize(self._scroll:GetSizeX(), scrollSize)
	self._config.slotCount	= slotCount
end
----------------------------------------------------------------------------------------------------
-- Popup Function
function	GuildStableList_ButtonOpen( eType, slotNo )
	if Panel_Window_StableMix:GetShow() then
		return
	end

	local	self		= guildStableList
	
	self._buttonSeal:SetShow(false)
	self._buttonCompulsionSeal:SetShow(false)
	-- self._buttonRecoveryUnseal:SetShow(false)
	-- self._buttonRepairUnseal:SetShow(false)
	self._buttonRegister:SetShow(false)
	self._buttonUnseal:SetShow(false)
	self._buttonRepair:SetShow(false)
	self._buttonRecovery:SetShow(false)
	self._buttonRelease:SetShow(false)
	
	local	buttonList		= {}
	local	buttonConfig	= self._config.button
	local	positionX		= 0
	local	positionY		= 0
	local	buttonSlotNo	= 0
	local	regionInfo		= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local	regionName		= regionInfo:getAreaName()
	
	if	( eType == self._const.eTypeSealed )	then
		local	index		= GuildStableList_SelectSlotNo()
		local	servantInfo	= guildStable_getServant( index ) -- (태곤) 작업 필요
		if	nil == servantInfo	then
			return
		end
		local	vehicleType			= servantInfo:getVehicleType()
		local	servantRegionName	= servantInfo:getRegionName( index )
		local	servantLevel		= servantInfo:getLevel()
		local	getState			= servantInfo:getStateType()
		if ( regionName == servantRegionName ) then
			audioPostEvent_SystemUi(01,00)
			if	( CppEnums.ServantStateType.Type_Stable == servantInfo:getStateType() )	then
				buttonList[buttonSlotNo]	= self._buttonUnseal
				buttonSlotNo	= buttonSlotNo + 1

				buttonList[buttonSlotNo]	= self._buttonRelease
				buttonSlotNo	= buttonSlotNo + 1

				if	(( servantInfo:getHp() < servantInfo:getMaxHp() ) or ( servantInfo:getMp() < servantInfo:getMaxMp() )) and (servantInfo:getHp() ~= servantInfo:getMaxHp())	then
					buttonList[buttonSlotNo]	= self._buttonRecovery
					buttonSlotNo	= buttonSlotNo + 1
				end

			elseif	( CppEnums.ServantStateType.Type_Coma == servantInfo:getStateType() )	then
				buttonList[buttonSlotNo]	= self._buttonRecovery
				buttonSlotNo	= buttonSlotNo + 1
			end
		end

		if	( CppEnums.ServantStateType.Type_Field == servantInfo:getStateType() )	then
			buttonList[buttonSlotNo]	= self._buttonSeal
			buttonSlotNo	= buttonSlotNo + 1
				
			buttonList[buttonSlotNo]	= self._buttonCompulsionSeal
			buttonSlotNo	= buttonSlotNo + 1
		end

		positionX	= self._slots[slotNo].button:GetPosX() + buttonConfig.startX
		positionY	= self._slots[slotNo].button:GetPosY() + buttonConfig.startY
	else
		buttonList[buttonSlotNo]	= self._buttonRegister
		buttonSlotNo	= buttonSlotNo + 1
		
		positionX	= self._taming._bg:GetPosX() + buttonConfig.startX
		positionY	= self._taming._bg:GetPosY() + buttonConfig.startY
	end

	local	sizeX	= self._staticButtonListBG:GetSizeX()
	local	sizeY	= buttonConfig.sizeYY
	for index, button in pairs(buttonList) do
		button:SetShow( true )
		button:SetPosX( buttonConfig.startButtonX								)
		button:SetPosY( buttonConfig.startButtonY + buttonConfig.gapY * index	)
		sizeY	= sizeY + buttonConfig.sizeY
	end
	if 0 ~= buttonSlotNo then
		self._staticButtonListBG:SetPosX( positionX	)
		self._staticButtonListBG:SetPosY( positionY	)
		self._staticButtonListBG:SetSize( sizeX, sizeY )
		self._staticButtonListBG:SetShow(true)
	else
		self._staticButtonListBG:SetShow(false)
	end
end

function	GuildStableList_ButtonClose()
	local	self	= guildStableList
	if	( not self._staticButtonListBG:GetShow() )	then
		return
	end
	
	self._staticButtonListBG:SetShow(false)
end
----------------------------------------------------------------------------------------------------
-- Slot Function
function	GuildStableList_SlotSelect( slotNo )
	local	self	= guildStableList
	if	nil == slotNo	then
		return
	end
	
	if GuildStable_WindowOpenCheck() or not Panel_Window_GuildStable_List:GetShow() then
		return
	end
	audioPostEvent_SystemUi(00,00)

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
	-- self._unseal._effect:SetShow( false )
	-- self._taming._effect:SetShow( false )
	
	self._slots[slotNo].effect:SetShow(true)
	self._selectSlotNo		= self._slots[slotNo].index
	
	local servantInfo = guildStable_getServant( GuildStableList_SelectSlotNo() )
	if nil == servantInfo then
		return
	end
	
	self._selectSceneIndex	= Servant_ScenePushObject( servantInfo, self._selectSceneIndex ) -- (태곤) 작업 필요?
	
	if nil ~= servantInfo:getActionIndex() then
		showSceneCharacter( self._selectSceneIndex, false )
		showSceneCharacter( self._selectSceneIndex, true, servantInfo:getActionIndex() )		
	end

	GuildStableInfo_Open()
	-- StableEquipInfo_Open() -- 14.12.04 요청으로 인하여 꺼줌.
	GuildStableList_ButtonOpen( self._const.eTypeSealed, slotNo )
end

----------------------------------------------------------------------------------------------------
-- Button Function
function	GuildStableList_Seal( isCompulsion )
	local	self	= guildStableList
	
	GuildStableList_ButtonClose()
	
	audioPostEvent_SystemUi(00,00)
	
	local	servantInfo		= guildStable_getServant( GuildStableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	
	guildStable_seal( servantInfo:getServantNo(), isCompulsion )
	GuildStableList_UpdateSlotData()
	FGlobal_Window_Servant_Update()
end

function	GuildStableList_Unseal()
	local	self	= guildStableList

	GuildStableList_ButtonClose()

	-- ♬ 말을 맡긴다.
	audioPostEvent_SystemUi(00,00)
	
	-- 말을 바꾸면, 말 피격시 이팩트 출력을 위한 _servant_BeforHP 값을 새로 바꿔준다.
	local	servantInfo		= guildStable_getServant( GuildStableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	
	guildStable_unseal( servantInfo:getServantNo() )
	
	-- reset_ServantHP( servantInfo:getHp() )
	GuildStableList_UpdateSlotData()
	guildStableList._scroll:SetControlTop()
	FGlobal_Window_Servant_Update()
	self._startSlotIndex = 0
end

function	GuildStableList_RecoveryUnseal()
	GuildStableList_ButtonClose()
	local	temporaryWrapper= getTemporaryInformationWrapper()
	local	servantWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
	if	( nil == servantWrapper )	then
		return
	end

	local	needMoney		= makeDotMoney( servantWrapper:getRecoveryCost_s64() )
	if( servantWrapper:getRecoveryOriginalCost_s64() <= Defines.s64_const.s64_1 )	then
		return
	end

	guildStableList._scroll:SetControlTop()
	_startSlotIndex = 0
end

function	GuildStableList_Recovery()
	GuildStableList_ButtonClose()

	local	servantInfo		= guildStable_getServant( GuildStableList_SelectSlotNo() )
	if	( nil == servantInfo )	then
		return
	end

	local GuildStableList_RecoveryXXX = function()
		audioPostEvent_SystemUi(05,07)
		guildStable_recovery( servantInfo:getServantNo() ) -- (태곤) 작업 필요
		-- FGlobal_StableInfoUpdate()
		GuildStableInfo_Open()
	end

	local GuildStableList_ReviveXXX = function()
		audioPostEvent_SystemUi(05,07)
		guildStable_revive( servantInfo:getServantNo() ) -- (태곤) 작업 필요
		-- FGlobal_StableInfoUpdate()
		GuildStableInfo_Open()
	end

	local	needMoney		= 0
	local	confirmFunction	= nil
	local	vehicleType	= servantInfo:getVehicleType()
	if	0 == servantInfo:getHp()	then
		needMoney		= makeDotMoney( servantInfo:getReviveCost_s64() )
		confirmFunction	= GuildStableList_ReviveXXX
	else
		needMoney		= makeDotMoney( servantInfo:getRecoveryCost_s64() )
		confirmFunction	= GuildStableList_RecoveryXXX
	end
	if (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant) then
		Imprint_Notify_Title = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_GUILDSTABEL_RECOVERY_NOTIFY_MSG", "needMoney", needMoney )
	end

	local Recovery_Notify_Title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_TITLE")


	if ( CppEnums.VehicleType.Type_Carriage == vehicleType ) or ( CppEnums.VehicleType.Type_CowCarriage == vehicleType ) or ( CppEnums.VehicleType.Type_Boat == vehicleType ) or ( CppEnums.VehicleType.Type_Raft == vehicleType ) then
		-- Servant_Confirm( "탈 것 회복", "해당 탑승물의 HP와 스태미너 회복에 총"..needMoney.."실버가 필요합니다.\n회복 하시겠습니까?", confirmFunction, MessageBox_Empty_function )
		Servant_Confirm( Recovery_Notify_Title, PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_CARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", needMoney ), confirmFunction, MessageBox_Empty_function )
	else
		Servant_Confirm( Recovery_Notify_Title, Imprint_Notify_Title, confirmFunction, MessageBox_Empty_function )
	end
end

-- function	GuildStableList_RecoveryXXX()
-- 	audioPostEvent_SystemUi(05,07)
-- 	guildStable_recovery( GuildStableList_SelectSlotNo() ) -- (태곤) 작업 필요
-- 	-- FGlobal_StableInfoUpdate()
-- 	GuildStableInfo_Open()
-- end

-- function	GuildStableList_ReviveXXX()
-- 	audioPostEvent_SystemUi(05,07)
-- 	guildStable_revive( GuildStableList_SelectSlotNo() ) -- (태곤) 작업 필요
-- 	-- FGlobal_StableInfoUpdate()
-- 	GuildStableInfo_Open()
-- end

-- 놓아주기
function	GuildStableList_Release()
	GuildStableList_ButtonClose()
	
	local	servantInfo		= guildStable_getServant( GuildStableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	
	Servant_Confirm( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RELEASE_NOTIFY_TITLE"), PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RELEASE_NOTIFY_MSG") .. servantInvenAlert .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_LETOUT_MSG"), GuildStableList_ReleaseXXX, MessageBox_Empty_function )
end

function	GuildStableList_ReleaseXXX()
	local	servantInfo		= guildStable_getServant( GuildStableList_SelectSlotNo() )
	if	nil == servantInfo	then
		return
	end
	local servantNo = servantInfo:getServantNo()
	guildStable_changeToReward( servantNo, CppEnums.ServantToRewardType.Type_Money )
	sellCheck = false
end

function	GuildStableList_RegisterCancel()
	GuildStableList_ButtonClose()
	
	GuildStableMating_Cancel( GuildStableList_SelectSlotNo() )
end

function FGlobal_GuildStableList_Update()
	guildStableList:update()
end
----------------------------------------------------------------------------------------------------
-- Common Function
function GuildStableList_SelectSlotNo()
	local	self	= guildStableList
	
	-- return( stable_SortByWayPointKey( self._selectSlotNo ) )
	return( GuildStable_SortByWayPointKey(self._selectSlotNo) )
end

function	GuildStableList_ScrollEvent( isScrollUp )
	local	self		= guildStableList
	local	servantCount= stable_count()
	
	self._startSlotIndex = UIScroll.ScrollEvent( self._scroll, isScrollUp, self._config.slotCount, servantCount, self._startSlotIndex, 1 )
	self:update()
	
	GuildStableList_ButtonClose()
end

function	GuildStable_SlotSound(slotNo)
	if isFirstSlot == true then
		GuildStableList_SlotLClick(slotNo)
		isFirstSlot = false
	else
		audioPostEvent_SystemUi(01,00)
		GuildStableList_SlotLClick(slotNo)
	end
end

function	GuildStable_WindowOpenCheck()
	if Panel_Win_System:GetShow() or Panel_Window_StableRegister:GetShow() then
		return true
	end
	
	return false
end

function	GuildStableList_RegisterFromTaming()
	GuildStableList_ButtonClose()
	audioPostEvent_SystemUi(00,00)
	
	GuildStableRegister_OpenByTaming()
	
	Panel_FrameLoop_Widget:SetShow(false)
end

-- 소팅 룰
-- 1. 배열에 클라에서 뿌려주는 순서를 저장
-- 2. 익스플로어키에 맞게 오름차순 정렬
-- 3. 현재 자신의 익스플로어키와 같은 말들은 가장 상위로 올라가도록 재정렬
-- 4. 현재 자신의 테리토리키에 맞게 테리토리별 정렬
-- 5. 서번트No로 비교해 변경된 인덱스값 리턴
local sortByExploreKey = {}
function GuildStableList_ServantCountInit( nums )
	for i = 1, nums do
		sortByExploreKey[i] = {
			_index		= nil,
			_servantNo	= nil,
			_exploreKey	= nil
		}
	end
end

function	GuildStable_SortDataupdate()
	-- 우선 기존 인덱스에 해당하는 익스플로어키를 저장합시다.
	local maxStableServantCount = guildStable_count()
	for ii = 1, maxStableServantCount do
		local	servantInfo		= guildStable_getServant( ii-1 )
		if	nil ~= servantInfo	then
			local regionKey = servantInfo:getRegionKeyRaw()
			local regionInfoWrapper = getRegionInfoWrapper(regionKey)
			sortByExploreKey[ii]._index			= ii - 1
			sortByExploreKey[ii]._servantNo		= servantInfo:getServantNo()
			sortByExploreKey[ii]._exploreKey	= regionInfoWrapper:getExplorationKey()
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
	
	-- 현재 마구간 exploerKey를 최우선 순위로 올려둡니다.
	local matchCount = 0
	local temp = {}
	for i = 1, maxStableServantCount do
		if myWayPointKey == sortByExploreKey[i]._exploreKey then
			temp[matchCount] = sortByExploreKey[i]
			matchCount = matchCount + 1
		end
	end
	
	for i = 1, maxStableServantCount do
		if myWayPointKey ~= sortByExploreKey[i]._exploreKey then
			temp[matchCount] = sortByExploreKey[i]
			matchCount = matchCount + 1
		end
	end
	
	for i = 1, maxStableServantCount do
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
		for servantIndex = 1, maxStableServantCount do
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
	elseif 4 == myTerritoriKey then
		sortByTerritory(4)
		sortByTerritory(3)
		sortByTerritory(1)
		sortByTerritory(0)
		sortByTerritory(2)
	end
	
	for i = 1, maxStableServantCount do
		sortByExploreKey[i] = temp[i-1]
	end
end

function GuildStable_SortByWayPointKey( index )
	if nil == index then
		return nil
	else
		return sortByExploreKey[index+1]._index
	end
end

----------------------------------------------------------------------------------------------------
-- From Client Function
function	GuildStableList_UpdateSlotData()
	if	(not Panel_Window_GuildStable_List:GetShow() )	then
		return
	end
	local	self		= guildStableList
	-- self:clear()
	self:update()
	
	for ii = 0, self._config.slotCount-1	do
		self._slots[ii].effect:SetShow(false)
	end
	
	GuildStableInfo_Close()			-- 서번트의 정보가 갱신되어도 정보창을 끄지 않고 갱신
	if nil == GuildStableList_SelectSlotNo() then
		GuildStableInfo_Open( 1 )
	else
		GuildStableInfo_Open()
	end

	-- self:update()
	GuildStableList_ButtonClose()
	GuildStableList_ScrollEvent( true )
end

function	GuildStableList_PopMessageBox( possibleTime_s64 )
	local	stringText		= convertStringFromDatetime( possibleTime_s64 )
	local	messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_STABLELIST_POPMSGBOX_MEMO", "stringText", stringText ) -- stringText .. ' 후에 등록 가능합니다.'
	local	messageBoxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function GuildStableList_ServantToReward( servantNo, servantWhereType )
	if not Panel_Window_GuildStable_List:GetShow() then
		return
	end
	if UI_SW.ServantWhereTypeUser == servantWhereType then
		return
	end
	Servant_ScenePopObject( self._selectSceneIndex )
	GuildStableList_UpdateSlotData()
	FGlobal_Window_Servant_Update()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_LOOSE_SERVANT_ACK") ) -- "탑승물을 놓아주었습니다.")
end

function GuildStableList_ServantUnseal( servantNo, servantWhereType )
	if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
		return
	end
	GuildStableList_UpdateSlotData()
	FGlobal_Window_Servant_Update()
	if Panel_Window_GuildStable_List:GetShow() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GET_SERVANT_ACK") ) -- "탑승물을 찾았습니다.")
	end
end

function GuildStableList_ServantSeal( servantNo, regionKey, servantWhereType )
	local	self			= guildStableList
	if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
		return
	end

	self:clear()
	GuildStableList_UpdateSlotData()
	Servant_ScenePopObject( self._selectSceneIndex )
	GuildStableList_SlotSelect( 0 )
	FGlobal_Window_Servant_Update()
	if Panel_Window_GuildStable_List:GetShow() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_GIVE_SERVANT_ACK") ) -- "탑승물을 맡겼습니다.")
	end
end

function GuildStableList_ServantRecovery( servantNo, servantWhereType )
	if UI_SW.ServantWhereTypeGuild ~= servantWhereType then
		return
	end
	GuildStableList_UpdateSlotData()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_RECOVERY_ACK") ) -- "탑승물이 회복되었습니다.")
end

-- ( "FromClient_ServantUnseal" )					-- 찾기 시 호출
-- ( "FromClient_ServantToReward" )					-- 판매 or 놓아주기
-- ( "FromClient_ServantRecovery" )					-- 회복시 호출
-- ( "FromClient_ServantChangeName" )				-- 이름 변경
-- ( "FromClient_ServantRegisterAuction" )			-- 교배 및 거래시장 등록
-- ( "FromClient_ServantCancelAuction" )			-- 교배 및 거래시장 취소
-- ( "FromClient_ServantReceiveAuction" )			-- 교배 및 거래시장 수령
-- ( "FromClient_ServantBuyMarket" )				-- 거래시장 구매
-- ( "FromClient_ServantStartMating" )				-- 교배시장 시작
-- ( "FromClient_ServantChildMating" )				-- 교배시장 말 수령
----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	GuildStableList_Open()
	local	self	= guildStableList	
	self:clear()
	self:update()
	
	UIAni.fadeInSCR_Down(Panel_Window_GuildStable_List)
	
	for ii = 0, self._config.slotCount-1	do
		self._slots[ii].effect:SetShow(false)
	end
	
	if	( not Panel_Window_GuildStable_List:GetShow() )	then
		Panel_Window_GuildStable_List:SetShow(true)
	end

	GuildStableList_SlotSelect(0)
end

function	GuildStableList_Close()
	if	( not Panel_Window_GuildStable_List:GetShow() )	then
		return
	end
	
	local	self		= guildStableList	
	
	Servant_ScenePopObject( self._selectSceneIndex )
	
	self._scroll:SetControlTop()
	self._startSlotIndex = 0
	GuildStableInfo_Close()
	-- GuildStableRegister_Close()
	GuildStableList_ButtonClose()
	Panel_Window_GuildStable_List:SetShow(false)
	
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
guildStableList:init()
guildStableList:registEventHandler()
guildStableList:registMessageHandler()
GuildStableList_Resize()

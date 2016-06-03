local UI_VT			= CppEnums.VehicleType

Panel_HorseMp:SetShow(false, false)
local staminaAlert		= UI.getChildControl( Panel_HorseMp, "StaticText_AlertStamina")
local repair_AutoNavi	= UI.getChildControl( Panel_HorseMp, "CheckButton_Repair_AutoNavi" )
local repair_Navi		= UI.getChildControl( Panel_HorseMp, "Checkbox_Repair_Navi" )
staminaAlert:SetShow( false )
repair_AutoNavi:SetShow( false )
repair_Navi:SetShow( false )


local servantMpBar	= {
	_staticBarBG		= UI.getChildControl( Panel_HorseMp, "Static_3"),
	_staticBar			= UI.getChildControl( Panel_HorseMp, "HorseMpBar" ),
	_staticText			= UI.getChildControl( Panel_HorseMp, "StaticText_Mp" ),
	_actorKeyRaw		= 0,
	_button_AutoCarrot	= UI.getChildControl( Panel_HorseMp, "CheckButton_AutoCarrot" ),
}

------ 자동 당근 사용 당근 키

-- 말
local horseCarrotItemKey	= {
	[0]	= 19945,	-- PC방 당근
	[1]	= 54001,	-- 당근
	[2]	= 54004,	-- 고급 당근
	[3]	= 54005,	-- 특상품 당근
}
-- 낙타
local camelCarrotItemKey	= {
	[0]	= 54012,	-- 마른 가시나무
	[1]	= 54020,	-- 아카시아 잎
	[2]	= 54021,	-- 고급 아카시아 잎
	[3]	= 54022,	-- 특상품 아카시아 잎
}

repair_AutoNavi	:addInputEvent(	"Mouse_LUp", "HandleClick_Horse_Repair_Navi(true)" )
repair_Navi		:addInputEvent(	"Mouse_LUp", "HandleClick_Horse_Repair_Navi(false)" )

servantMpBar._button_AutoCarrot:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 2, nil )")
servantMpBar._button_AutoCarrot:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 2, nil )")
servantMpBar._button_AutoCarrot:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 2 )")

function HorseMP_init()
	Panel_HorseMp:ComputePos()
	servantMpBar._button_AutoCarrot:SetShow(false)
end


function	HorseMP_Update()
	local	self				= servantMpBar
	local	vehicleProxy		= getVehicleActor( self._actorKeyRaw )

	if	(nil == vehicleProxy)	then
		return
	end
	local vehicleType = vehicleProxy:get():getVehicleType()

	-- 탈것 스태미너 알림
	local staminaPercent = nil
	local alertText = ""

	if ( CppEnums.VehicleType.Type_Carriage == vehicleType ) or ( vehicleType == CppEnums.VehicleType.Type_CowCarriage ) then
		alertText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STAMINA_ALERT_1")		-- 수명이 얼마 남지 않았습니다.\n마구간에서 폐기해야 합니다.
	elseif ( CppEnums.VehicleType.Type_Boat == vehicleType ) or ( vehicleType == CppEnums.VehicleType.Type_Raft ) or ( vehicleType == CppEnums.VehicleType.Type_FishingBoat ) or ( vehicleType == CppEnums.VehicleType.Type_SailingBoat ) then
		alertText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STAMINA_ALERT_3")		-- 수명이 얼마 남지 않았습니다.\n선착장에서 폐기해야 합니다.
	else
		alertText = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STAMINA_ALERT_2")		-- 기력이 얼마 남지 않아 속도가 느려집니다.\n당근을 먹이거나 마구간에 들러 회복시켜 주세요.
	end
	staminaAlert:SetAutoResize()
	staminaAlert:SetText( alertText )
	staminaPercent = vehicleProxy:get():getMp() / vehicleProxy:get():getMaxMp() * 100
	repair_AutoNavi:SetShow( true )
	repair_Navi:SetShow( true )

	if ( CppEnums.VehicleType.Type_Carriage ~= vehicleProxy:get():getVehicleType() ) or ( vehicleProxy:get():getVehicleType() ~= CppEnums.VehicleType.Type_CowCarriage ) or ( vehicleProxy:get():getVehicleType() ~= CppEnums.VehicleType.Type_Boat ) or ( vehicleProxy:get():getVehicleType() ~= CppEnums.VehicleType.Type_Raft ) then
		if 10 > staminaPercent then			-- 10% 미만이 되면 경고문을 띄워준다!!
			-- staminaAlert:SetShow( true )
			self._staticBarBG:EraseAllEffect()
			self._staticBarBG:AddEffect("fUI_Horse_Gauge01", true, 0, 0)
			repair_AutoNavi:SetShow( true )
			repair_Navi:SetShow( true )
		else
			-- staminaAlert:SetShow( false )
			self._staticBarBG:EraseAllEffect()
			repair_AutoNavi:SetShow( false )
			repair_Navi:SetShow( false )
		end
	end
	if (UI_VT.Type_Ladder == vehicleType) or (UI_VT.Type_Cow == vehicleType) or (UI_VT.Type_Bomb == vehicleType) then
		HorseMP_Close()
		return
	end
	self._staticBar	:SetProgressRate( vehicleProxy:get():getMp() / vehicleProxy:get():getMaxMp() * 100 )	
	if (UI_VT.Type_Horse == vehicleType) or (UI_VT.Type_Camel == vehicleType)
		or (UI_VT.Type_Donkey == vehicleType) or (UI_VT.Type_MountainGoat == vehicleType) then
		self._staticText:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SERVANT_MPBAR_LIFE", "getMp", makeDotMoney(vehicleProxy:get():getMp()), "getMaxMp", makeDotMoney(vehicleProxy:get():getMaxMp()) ) )-- "지구력 : " .. tostring(vehicleProxy:get():getMp()) .. "/" .. tostring(vehicleProxy:get():getMaxMp())
		self._staticBar:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 0, " .. staminaPercent .. ")")
		self._staticBar:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 0 )")
		self._staticBar:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 0, " .. staminaPercent .. ")")
	else
		self._staticText:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SERVANT_MPBAR_MACHINE", "getMp", makeDotMoney(vehicleProxy:get():getMp()), "getMaxMp", makeDotMoney(vehicleProxy:get():getMaxMp()) ) ) -- "수명 : " .. tostring(vehicleProxy:get():getMp()) .. "/" .. tostring(vehicleProxy:get():getMaxMp())
		if (UI_VT.Type_Elephant == vehicleType) then
			self._staticBar:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 3, " .. staminaPercent .. ")")
			self._staticBar:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 3 )")
			self._staticBar:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 3, " .. staminaPercent .. ")")
		else
			self._staticBar:addInputEvent("Mouse_On", "HorseMP_SimpleTooltips( true, 1, " .. staminaPercent .. ")")
			self._staticBar:addInputEvent("Mouse_Out", "HorseMP_SimpleTooltips( false, 1 )")
			self._staticBar:setTooltipEventRegistFunc("HorseMP_SimpleTooltips( true, 1, " .. staminaPercent .. ")")
		end
	end

	if (getSelfPlayer():isNavigationLoop()) and (getSelfPlayer():isNavigationMoving()) then	-- 자동 당근 사용 버튼 노출
		if		UI_VT.Type_Boat		== vehicleType or UI_VT.Type_Raft		== vehicleType or UI_VT.Type_FishingBoat	== vehicleType
			or	UI_VT.Type_Carriage	== vehicleType or UI_VT.Type_CowCarriage== vehicleType or UI_VT.Type_Cannon			== vehicleType
			or UI_VT.Type_Elephant	== vehicleType or UI_VT.Type_BabyElephant	== vehicleType then
			servantMpBar._button_AutoCarrot:SetShow( false )
		else
			servantMpBar._button_AutoCarrot:SetShow( true )
		end
	else
		servantMpBar._button_AutoCarrot:SetShow(false)
	end
	
	---- MP가 10% 미만이고 자동 순환 이동이면 당근 먹기 함수를 호출한다 --------------------
	if (staminaPercent <= 10) and (true == servantMpBar._button_AutoCarrot:IsCheck()) and (getSelfPlayer():isNavigationLoop()) and (getSelfPlayer():isNavigationMoving()) then
		-- 탑승물 종류별로 다른 아이템 키 사용
		if (UI_VT.Type_Horse == vehicleType) or (UI_VT.Type_Donkey == vehicleType) then
			HorseAutoCarrotFunc( horseCarrotItemKey )
		elseif (UI_VT.Type_Camel == vehicleType) then
			HorseAutoCarrotFunc( camelCarrotItemKey )
		end
	end
end


function HorseAutoCarrotFunc(carrotItemKey)	-- 자동 당근 메인 함수

	------ 자동 당근 당근 먹이기 지역 함수
	local useAutoCarrot = function( invenSlot )
		local itemWrapper	= getInventoryItemByType( CppEnums.ItemWhereType.eInventory, invenSlot )
		local itemStatic	= itemWrapper:getStaticStatus():get()
		local selfProxy		= getSelfPlayer():get()
		if nil == selfProxy then
			return
		end
	
		if selfProxy:doRideMyVehicle() and itemStatic:isUseToVehicle() then
			local equipSlotNo	= itemWrapper:getStaticStatus():getEquipSlotNo()
			local carrotName	= itemWrapper:getStaticStatus():getName()
			inventoryUseItem( CppEnums.ItemWhereType.eInventory, invenSlot, equipSlotNo, false )	-- 당근사용
			Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_AUTO_USE_CARROT", "carrotName", carrotName))	-- "자동으로 carrotName을 사용했습니다."
		end
	end
	-------------------------------------
	
	local inventory			= getSelfPlayer():get():getInventory()
	local invenSize			= inventory:sizeXXX()
	local carrotItemSlot	= {
		[0] = { slot = "", key ="" },
		[1] = { slot = "", key ="" },
		[2] = { slot = "", key ="" },
		[3] = { slot = "", key ="" },
	}
	------ 가방에서 당근 검색 및 배열에 추가
	for invenidx = 2, invenSize - 1 do
		local itemWrapper = getInventoryItemByType( CppEnums.ItemWhereType.eInventory, invenidx )
		if nil ~= itemWrapper then
			local itemKey	= itemWrapper:get():getKey():getItemKey()
		
			if (carrotItemKey[0] == itemKey) or (carrotItemKey[1] == itemKey) or (carrotItemKey[2] == itemKey) or (carrotItemKey[3] == itemKey) then
				local carrotCoolTime = getItemCooltime( CppEnums.ItemWhereType.eInventory, invenidx )
		
				if 0 == carrotCoolTime then
					for idx = 0, 3 do
						if carrotItemKey[idx] == itemKey then
							carrotItemSlot[idx].slot	= invenidx
							carrotItemSlot[idx].key		= itemKey
						end
					end
				else
					return
				end
			end
		end
	end
	------ 낮은 등급 당근부터 존재하면 사용
	if ("" ~= carrotItemSlot[0].slot) and (carrotItemKey[0] == carrotItemSlot[0].key) then
		useAutoCarrot(carrotItemSlot[0].slot)		-- 각 등급의 당근 먹이기 지역 함수 호출
		return
	elseif ("" ~= carrotItemSlot[1].slot) and (carrotItemKey[1] == carrotItemSlot[1].key) then
		useAutoCarrot(carrotItemSlot[1].slot)
		return
	elseif ("" ~= carrotItemSlot[2].slot) and (carrotItemKey[2] == carrotItemSlot[2].key) then
		useAutoCarrot(carrotItemSlot[2].slot)
		return
	elseif ("" ~= carrotItemSlot[3].slot) and (carrotItemKey[3] == carrotItemSlot[3].key) then
		useAutoCarrot(carrotItemSlot[3].slot)
		return
	end
end

function HandleOn_HorseMp_Bar()
	-- _PA_LOG("LUA","HandleOn_HorseMp_Bar")
	servantMpBar._staticText:SetShow(true)
end

function HandleOut_HorseMp_Bar()
-- _PA_LOG("LUA","HandleOut_HorseMp_Bar")
	servantMpBar._staticText:SetShow(false)
end

function	HorseMP_OpenByInteraction()
	local	self		= servantMpBar
	local	selfPlayer		= getSelfPlayer()
	local	selfProxy		= selfPlayer:get()
	local	actorKeyRaw		= selfProxy:getRideVehicleActorKeyRaw()
	local	vehicleProxy	= getVehicleActor( actorKeyRaw )

	if	(nil == vehicleProxy)	then
		return
	end
		
	self._actorKeyRaw	= actorKeyRaw
		
	HorseMP_Open()
	
	-- 말 탈 때 말 아이콘 이펙트 꺼줌
	FGlobal_ServantIcon_IsNearMonster_Effect( false )
end

function HorseMP_SimpleTooltips( isShow, servantTooltipType, staminaStatus )
	local name, desc, uiControl = nil, nil, nil

	if 0 == servantTooltipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEMP_NAME") -- "지구력"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEMP_DESC") -- "탑승물의 지구력을 나타냅니다."
		uiControl = Panel_HorseHp
	elseif 1 == servantTooltipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEMP_NAME") -- "수명"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEMP_DESC") -- "탑승물의 수명을 나타냅니다."
		uiControl = Panel_HorseHp
	elseif 2 == servantTooltipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEMP_TOOLTIP_AUTO_USE_CARROT_NAME") -- "자동으로 당근 사용"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEMP_TOOLTIP_AUTO_USE_CARROT_DESC") -- "탑승물의 지구력이 10% 이하일 때 플레이어의\n가방에 있는 당근을 자동으로 사용합니다."
		uiControl = servantMpBar._button_AutoCarrot
	elseif 3 == servantTooltipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEMP_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_ELEPHANTMP_DESC")
		uiControl = Panel_HorseMp
	end

	if isShow == true and nil ~= staminaStatus then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
		HandleOn_HorseMp_Bar()
		if staminaStatus < 30 then
			staminaAlert:SetShow( true )
		else
			staminaAlert:SetShow( false )
		end
	elseif isShow == true and nil == staminaStatus then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
		HandleOut_HorseMp_Bar()
		staminaAlert:SetShow( false )
	end
end

function	HorseMP_Open()
	if	( Panel_HorseMp:GetShow() )	then
		return
	end

	if Panel_WorldMap:GetShow() then
		return
	end

	local	selfPlayer		= getSelfPlayer()
	local	selfProxy		= selfPlayer:get()
	local	isDriver		= selfProxy:isVehicleDriver()

	if false == isDriver then
		return
	end

	Panel_HorseMp:SetShow( true )
	HorseMP_Update()
end

function	HorseMP_Close()
	if	( not Panel_HorseMp:GetShow() )	then
		return
	end
	
	Panel_HorseMp:SetShow( false )
end

function HandleClick_Horse_Repair_Navi( isAuto )
	local player	= getSelfPlayer()
	if nil == player then
		return
	end

 	-- 네비 세팅
	ToClient_DeleteNaviGuideByGroup(0);
	
	if(	ToClient_IsShowNaviGuideGroup(0) ) then
		if true == isAuto and true == repair_AutoNavi:IsCheck() then
			repair_Navi		:SetCheck(true)
			repair_AutoNavi	:SetCheck(true)
		else
			repair_Navi		:SetCheck(false)
			repair_AutoNavi	:SetCheck(false)
			audioPostEvent_SystemUi(00,15)
			return
		end
	else
		if true == isAuto then
			repair_Navi		:SetCheck(true)
			repair_AutoNavi	:SetCheck(true)
		else
		    repair_Navi		:SetCheck(true)
			repair_AutoNavi	:SetCheck(false)
		end
	end

	local position		= player:get3DPos() -- 기준이 되는 위치
	local spawnType 	= CppEnums.SpawnType.eSpawnType_Stable -- 마굿간 NPC
	
	local nearNpcInfo 	= getNearNpcInfoByType( spawnType, position )
	if nil ~=  nearNpcInfo then
		local pos = nearNpcInfo:getPosition()
		local repairNaviKey = ToClient_WorldMapNaviStart( pos, NavigationGuideParam(), isAuto, true )
		audioPostEvent_SystemUi(00,14)
		
		local selfPlayer = getSelfPlayer():get()
		selfPlayer:setNavigationMovePath(repairNaviKey)
		selfPlayer:checkNaviPathUI(repairNaviKey)
	end
end

registerEvent("EventSelfServantUpdate",			"HorseMP_Update")
registerEvent("EventSelfPlayerRideOff",			"HorseMP_Close")
registerEvent("EventSelfPlayerRideOn",			"HorseMP_OpenByInteraction")
HorseMP_init()

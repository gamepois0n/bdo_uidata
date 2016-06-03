local UI_VT			= CppEnums.VehicleType

Panel_HorseHp:SetShow(false, false)

local	servantHpBar	= {
	_staticBar		= UI.getChildControl( Panel_HorseHp, "HorseHpBar" ),
	_staticText		= UI.getChildControl( Panel_HorseHp, "StaticText_Hp" ),
	_actorKeyRaw	= 0
}

function HorseHP_init()
	Panel_HorseHp	:ComputePos()
end

function HorseHP_Update()
	local	self				= servantHpBar
	local	vehicleProxy		= getVehicleActor( self._actorKeyRaw )
	 -- _PA_LOG("asdf", "vehicleProxy:" .. tostring( vehicleProxy:get():getHp() ) .. "vehicleProxy:getVehicleType : " .. tostring( vehicleProxy:get():getVehicleType()) )

	if	(nil == vehicleProxy)	then
		return
	end
	local vehicleType = vehicleProxy:get():getVehicleType()
	if (UI_VT.Type_Ladder == vehicleType) or (UI_VT.Type_Cow == vehicleType) or (UI_VT.Type_Bomb == vehicleType) then
		HorseHP_Close()
		return
	end
	self._staticBar	:SetProgressRate( (vehicleProxy:get():getHp() / vehicleProxy:get():getMaxHp()) * 100 )	
	if (UI_VT.Type_Horse == vehicleType) or (UI_VT.Type_Camel == vehicleType)
		or (UI_VT.Type_Donkey == vehicleType) or (UI_VT.Type_MountainGoat == vehicleType) then
		self._staticText:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SERVANT_HPBAR_LIFE", "getHp", makeDotMoney(vehicleProxy:get():getHp()), "getMaxHp", makeDotMoney(vehicleProxy:get():getMaxHp()) ) ) -- "생명력 : " ..  tostring(vehicleProxy:get():getHp()) .. "/" .. tostring(vehicleProxy:get():getMaxHp())
		Panel_HorseHp:addInputEvent("Mouse_On", "HorseHP_SimpleTooltips( true, 0 )")
		Panel_HorseHp:addInputEvent("Mouse_Out", "HorseHP_SimpleTooltips( false, 0 )")
		Panel_HorseHp:setTooltipEventRegistFunc("HorseHP_SimpleTooltips( true, 0 )")
	else
		self._staticText:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_SERVANT_HPBAR_MACHINE", "getHp", makeDotMoney(vehicleProxy:get():getHp()), "getMaxHp", makeDotMoney(vehicleProxy:get():getMaxHp()) ) ) -- "내구도 : " ..  tostring(vehicleProxy:get():getHp()) .. "/" .. tostring(vehicleProxy:get():getMaxHp())
		if (UI_VT.Type_Elephant == vehicleType) then
			Panel_HorseHp:addInputEvent("Mouse_On", "HorseHP_SimpleTooltips( true, 2 )")
			Panel_HorseHp:addInputEvent("Mouse_Out", "HorseHP_SimpleTooltips( false, 2 )")
			Panel_HorseHp:setTooltipEventRegistFunc("HorseHP_SimpleTooltips( true, 2 )")
		else
			Panel_HorseHp:addInputEvent("Mouse_On", "HorseHP_SimpleTooltips( true, 1 )")
			Panel_HorseHp:addInputEvent("Mouse_Out", "HorseHP_SimpleTooltips( false, 1 )")
			Panel_HorseHp:setTooltipEventRegistFunc("HorseHP_SimpleTooltips( true, 1 )")
		end
	end
end

servantHpBar._staticBar:addInputEvent("Mouse_On",			"HandleOn_HorseHp_Bar()")
servantHpBar._staticBar:addInputEvent("Mouse_Out",			"HandleOut_HorseHp_Bar()")

function	HandleOn_HorseHp_Bar()
	servantHpBar._staticText:SetShow(true)
end

function	HandleOut_HorseHp_Bar()
	servantHpBar._staticText:SetShow(false)
end

function	HorseHP_OpenByInteraction()
	local	self			= servantHpBar
	local	selfPlayer		= getSelfPlayer()
	local	selfProxy		= selfPlayer:get()
	local	actorKeyRaw		= selfProxy:getRideVehicleActorKeyRaw()
	self._actorKeyRaw	= actorKeyRaw

	local	vehicleProxy	= getVehicleActor( actorKeyRaw )
	 -- _PA_LOG("asdf", "vehicleProxy:" .. tostring( vehicleProxy:get():getHp() ) .. "vehicleProxy:getVehicleType : " .. tostring( vehicleProxy:get():getVehicleType()) )

	if	( nil == vehicleProxy )	then
		return
	end
	
	HorseHP_Open()
end

function HorseHP_SimpleTooltips( isShow, servantTooltipType )
	local name, desc, uiControl = nil, nil, nil

	if 0 == servantTooltipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_NAME") -- "생명력"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_DESC") -- "탑승물의 생명력을 나타냅니다."
	elseif 1 == servantTooltipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEHP_NAME") -- "내구도"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEHP_DESC") -- "탑승물의 내구도를 나타냅니다."
	elseif 2 == servantTooltipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_NAME")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_ELEPHANTMP_DESC")
	end
	uiControl = Panel_HorseHp

	registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
	if isShow == true then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function	HorseHP_Open()
	if	( Panel_HorseHp:GetShow() ) then
		return
	end

	if Panel_MiniGame_PowerControl:GetShow() then
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

	Panel_HorseHp:SetShow( true )
	HorseHP_Update()
end

function	HorseHP_Close()
	if	( not Panel_HorseHp:GetShow() ) then
		return
	end
	Panel_HorseHp:SetShow( false )
end

registerEvent("EventSelfServantUpdate",			"HorseHP_Update"			)
registerEvent("EventSelfPlayerRideOff",			"HorseHP_Close"				)
registerEvent("EventSelfPlayerRideOn",			"HorseHP_OpenByInteraction"	)
HorseHP_init()
local UI_color 			= Defines.Color
local UI_VT				= CppEnums.VehicleType

local horse					= {}
local horseEquipNo			= {}
local horseBroken			= {}
local horseColorKey			= {}
local horseItemEquiped		= {}

local carriage				= {}
local carriageEquipNo		= {}
local carriageBroken		= {}
local carriageColorKey		= {}
local carriageItemEquiped	= {}

local ship					= {}
local shipEquipNo			= {}
local shipBroken			= {}
local shipColorKey			= {}
local shipItemEquiped		= {}

local servantEquipNo		= nil
local servantColorKey		= nil
local servantType			= nil
local servantBroken			= nil
local servantItemEquiped	= nil

local PcEnduranceCheck		= false
local isMouseOn				= false

local noticeEndurance 	= UI.getChildControl ( Panel_Endurance,			"StaticText_NoticeEndurance" )
local _chk_repair		= UI.getChildControl ( Panel_Endurance,			"Checkbox_Repair_Navi" )
local horseEffectBG		= UI.getChildControl ( Panel_HorseEndurance,	"Static_HorseEffect")
local carriageEffectBG	= UI.getChildControl ( Panel_CarriageEndurance, "Static_CarriageEffect")
local shipEffectBG		= UI.getChildControl ( Panel_ShipEndurance,		"Static_ShipEffect")
-- repair_AutoNavi	:addInputEvent(	"Mouse_LUp","HandleClick_Repair_Navi(true, " .. servantType .. ")")
-- repair_Navi		:addInputEvent(	"Mouse_LUp","HandleClick_Repair_Navi(false, " .. servantType .. ")")
local horseNoticeEndurance			= UI.getChildControl(Panel_HorseEndurance, "StaticText_NoticeEndurance")
local carriageNoticeEndurance 		= UI.getChildControl(Panel_CarriageEndurance, "StaticText_NoticeEndurance")
local shipNoticeEndurance 			= UI.getChildControl(Panel_ShipEndurance, "StaticText_NoticeEndurance")

horseNoticeEndurance	:SetText( PAGetString(Defines.StringSheet_RESOURCE, "ENDURANCE_TXT_NOTICE") )
carriageNoticeEndurance	:SetText( PAGetString(Defines.StringSheet_RESOURCE, "ENDURANCE_TXT_NOTICE") )
shipNoticeEndurance		:SetText( PAGetString(Defines.StringSheet_RESOURCE, "ENDURANCE_TXT_NOTICE") )

local	servantEnduaranceInfo =
{
	brokenRate = 10,
}

local init = function()
	-- 말 내구도
	horse.panel						= Panel_HorseEndurance
	horse.head						= UI.getChildControl(horse.panel, "Static_Horse_Head")
	horse.body						= UI.getChildControl(horse.panel, "Static_Horse_Body")
	horse.riderFoot					= UI.getChildControl(horse.panel, "Static_Horse_RiderFoot")
	horse.saddle					= UI.getChildControl(horse.panel, "Static_Horse_Saddle")
	horse.horseFoot					= UI.getChildControl(horse.panel, "Static_Horse_HorseFoot")

	horse.noticeEndurance 				= UI.getChildControl(horse.panel, "StaticText_NoticeEndurance")
	horse.repair_AutoNavi 				= UI.getChildControl(horse.panel, "CheckButton_Repair_AutoNavi")
	horse.repair_Navi 					= UI.getChildControl(horse.panel, "Checkbox_Repair_Navi")

	horse.panel						:SetShow( false )
	horse.head						:SetShow( false )
	horse.body						:SetShow( false )
	horse.riderFoot					:SetShow( false )
	horse.saddle					:SetShow( false )
	horse.horseFoot					:SetShow( false )

	horseEquipNo.head				= 6		--마면
	horseEquipNo.body				= 3		--마갑
	horseEquipNo.riderFoot			= 5		--등자
	horseEquipNo.saddle				= 4		--안장
	horseEquipNo.horseFoot			= 12	--편자

	horseBroken.head				= false
	horseBroken.body				= false
	horseBroken.riderFoot			= false
	horseBroken.saddle				= false
	horseBroken.horseFoot			= false

	horseColorKey.head				= UI_color.C_FF000000
	horseColorKey.body				= UI_color.C_FF000000
	horseColorKey.riderFoot			= UI_color.C_FF000000
	horseColorKey.saddle			= UI_color.C_FF000000
	horseColorKey.horseFoot			= UI_color.C_FF000000

	horseItemEquiped.head			= false
	horseItemEquiped.body			= false
	horseItemEquiped.riderFoot		= false
	horseItemEquiped.saddle			= false
	horseItemEquiped.horseFoot		= false

	-- 마차 내구도
	carriage.panel					= Panel_CarriageEndurance
	carriage.flag					= UI.getChildControl(carriage.panel, "Static_Carriage_Flag")
	carriage.cover					= UI.getChildControl(carriage.panel, "Static_Carriage_Cover")
	carriage.wheel					= UI.getChildControl(carriage.panel, "Static_Carriage_Wheel")
	carriage.curtain				= UI.getChildControl(carriage.panel, "Static_Carriage_Curtain")
	carriage.lamp					= UI.getChildControl(carriage.panel, "Static_Carriage_Lamp")

	carriage.noticeEndurance 			= UI.getChildControl(carriage.panel, "StaticText_NoticeEndurance")
	carriage.repair_AutoNavi 			= UI.getChildControl(carriage.panel, "CheckButton_Repair_AutoNavi")
	carriage.repair_Navi 				= UI.getChildControl(carriage.panel, "Checkbox_Repair_Navi")

	carriage.panel					:SetShow( false )
	carriage.flag					:SetShow( false )
	carriage.cover					:SetShow( false )
	carriage.wheel					:SetShow( false )
	carriage.curtain				:SetShow( false )
	carriage.lamp					:SetShow( false )

	carriageEquipNo.flag			= 5		-- 깃발
	carriageEquipNo.cover			= 25	-- 덮개
	carriageEquipNo.wheel			= 4		-- 바퀴
	carriageEquipNo.curtain			= 6		-- 휘장
	carriageEquipNo.lamp			= 13	-- 램프

	carriageBroken.flag				= false
	carriageBroken.cover			= false
	carriageBroken.wheel			= false
	carriageBroken.curtain			= false
	carriageBroken.lamp				= false

	carriageColorKey.flag			= UI_color.C_FF000000
	carriageColorKey.cover			= UI_color.C_FF000000
	carriageColorKey.wheel			= UI_color.C_FF000000
	carriageColorKey.curtain		= UI_color.C_FF000000
	carriageColorKey.lamp			= UI_color.C_FF000000

	carriageItemEquiped.flag		= false
	carriageItemEquiped.cover		= false
	carriageItemEquiped.wheel		= false
	carriageItemEquiped.curtain		= false
	carriageItemEquiped.lamp		= false

	-- 배 내구도
	ship.panel						= Panel_ShipEndurance
	ship.main						= UI.getChildControl(ship.panel, "Static_Ship_Main")
	ship.head						= UI.getChildControl(ship.panel, "Static_Ship_Head")
	ship.deco						= UI.getChildControl(ship.panel, "Static_Ship_Deco")
	ship.goods						= UI.getChildControl(ship.panel, "Static_Ship_Goods")

	ship.noticeEndurance 			= UI.getChildControl(ship.panel, "StaticText_NoticeEndurance")
	ship.repair_AutoNavi 			= UI.getChildControl(ship.panel, "CheckButton_Repair_AutoNavi")
	ship.repair_Navi 				= UI.getChildControl(ship.panel, "Checkbox_Repair_Navi")

	ship.panel						:SetShow( false )
	ship.main						:SetShow( false )
	ship.head						:SetShow( false )
	ship.deco						:SetShow( false )
	ship.goods						:SetShow( false )

	shipEquipNo.head				= 4		-- 장식
	shipEquipNo.deco				= 25	-- 뱃머리
	shipEquipNo.goods				= 5		-- 화물칸

	-- shipBroken.main					= false
	shipBroken.head					= false
	shipBroken.deco					= false
	shipBroken.goods				= false

	shipColorKey.head				= UI_color.C_FF000000
	shipColorKey.deco				= UI_color.C_FF000000
	shipColorKey.goods				= UI_color.C_FF000000

	shipItemEquiped.head			= false
	shipItemEquiped.deco			= false
	shipItemEquiped.goods			= false

	horse.panel:SetShow( true )
	carriage.panel:SetShow( true )
	ship.panel:SetShow( true )
end

-------------------------------------------------------------
--			항상 실시간으로 내구도를 검사하자
-------------------------------------------------------------
function Panel_ServantEndurance_UpdatePerFrame( deltaTime )
	-- UI.debugMessage( 'Panel_ServantEndurance_UpdatePerFrame' )
	if ( isFlushedUI() ) then
		return
	end

	if true == isMouseOn then
		return
	end

	local self = servantEnduaranceInfo

	-- init()
	local temporaryWrapper	= getTemporaryInformationWrapper()
	if nil == temporaryWrapper then
		return
	end
	-- local selfProxy			= getSelfPlayer():get()
	-- if nil == selfProxy then
	-- 	return
	-- end

	-- if not selfProxy:doRideMyVehicle()	then
	-- 	-- for index, value in pairs( servantEquipNo ) do
	-- 		horse.panel					:SetShow( false )
	-- 		carriage.panel				:SetShow( false )
	-- 		ship.panel					:SetShow( false )
	-- 		horse.noticeEndurance		:SetShow( false )
	-- 		horse.repair_AutoNavi		:SetShow( false )
	-- 		horse.repair_Navi			:SetShow( false )
	-- 		carriage.noticeEndurance	:SetShow( false )
	-- 		carriage.repair_AutoNavi	:SetShow( false )
	-- 		carriage.repair_Navi		:SetShow( false )
	-- 		ship.noticeEndurance		:SetShow( false )
	-- 		ship.repair_AutoNavi		:SetShow( false )
	-- 		ship.repair_Navi			:SetShow( false )
	-- 		ship.main					:SetShow( false ) -- 수상 탈 것은 선체(몸통) 아이템이 없어서 기본 이미지가 별도 존재.
	-- 	-- end
	-- 	return
	-- end

	-- local actorKeyRaw		= selfProxy:getRideVehicleActorKeyRaw()
	-- if (nil == actorKeyRaw) or ( 0 == actorKeyRaw ) then
	-- 	return
	-- end

	--{
		horse.panel					:SetShow( false )
		horse.noticeEndurance		:SetShow( false )
		horse.repair_AutoNavi		:SetShow( false )
		horse.repair_Navi			:SetShow( false )

		carriage.panel				:SetShow( false )
		carriage.noticeEndurance	:SetShow( false )
		carriage.repair_AutoNavi	:SetShow( false )
		carriage.repair_Navi		:SetShow( false )
		
		local servantWrapper		= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
		if nil ~= servantWrapper then
			local vehicleType		= servantWrapper:getVehicleType()
			if (UI_VT.Type_Horse == vehicleType) or (UI_VT.Type_Camel == vehicleType) or (UI_VT.Type_Donkey == vehicleType) or (UI_VT.Type_Elephant == vehicleType) or (UI_VT.Type_BabyElephant == vehicleType) or (UI_VT.Type_MountainGoat == vehicleType) then -- 생명력 있는 지상 탑승물
				servantEquipNo		= horseEquipNo
				servantColorKey		= horseColorKey
				servantType			= horse
				servantBroken		= horseBroken
				servantItemEquiped	= horseItemEquiped
				-- if vehicleType == nil then
				-- 	servantType.panel:SetShow(false)
				-- end
			elseif (UI_VT.Type_Carriage == vehicleType) or (UI_VT.Type_CowCarriage == vehicleType) then -- 생명력 없는 지상 탑승물
				servantEquipNo		= carriageEquipNo
				servantColorKey		= carriageColorKey
				servantType			= carriage
				servantBroken		= carriageBroken
				servantItemEquiped	= carriageItemEquiped
			end
			
			Panel_ServantEndurance_UpdatePerFrameXXX( servantWrapper )
		end
	--}

	--{
		ship.panel					:SetShow( false )
		ship.noticeEndurance		:SetShow( false )
		ship.repair_AutoNavi		:SetShow( false )
		ship.repair_Navi			:SetShow( false )
		ship.main					:SetShow( false ) -- 수상 탈 것은 선체(몸통) 아이템이 없어서 기본 이미지가 별도 존재.
		local seaVehicleWrapper		= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship )
		if nil ~= seaVehicleWrapper then
			local seaVehicleType		= seaVehicleWrapper:getVehicleType()
			if (UI_VT.Type_Boat == seaVehicleType) or (UI_VT.Type_Raft == seaVehicleType) or (UI_VT.Type_FishingBoat == seaVehicleType) or (UI_VT.Type_SailingBoat == seaVehicleType) then -- 		어선 종류
				servantEquipNo		= shipEquipNo
				servantColorKey		= shipColorKey
				servantType			= ship
				servantBroken		= shipBroken
				servantItemEquiped	= shipItemEquiped
			end
			
			Panel_ServantEndurance_UpdatePerFrameXXX( seaVehicleWrapper )
		end
	--}

	if (horse.panel:GetShow() or carriage.panel:GetShow()) and ship.panel:GetShow() then
		carriage.noticeEndurance:SetShow( false )
		carriage.repair_AutoNavi:SetShow( false )
		carriage.repair_Navi:SetShow( false )
		horse.noticeEndurance:SetShow( false )
		horse.repair_AutoNavi:SetShow( false )
		horse.repair_Navi:SetShow( false )
	end

	if horse.panel:GetShow() or carriage.panel:GetShow() or ship.panel:GetShow() then
		-- FGlobal_PcEnduranceNaviShow()
	end
end


local isShipEffectShow		= false
local isCarriageEffectShow	= false
local isHorseEffectShow		= false
function	Panel_ServantEndurance_UpdatePerFrameXXX( servantWrapper )
	local self = servantEnduaranceInfo
	local enduranceCheck = 0
	local isChange = false

	if	nil == servantWrapper	then
		return
	end

	for	index, value in pairs( servantEquipNo ) do
		local itemWrapper	= servantWrapper:getEquipItem( value )
		local colorKey		= UI_color.C_FF444444
		local isBroken		= false
		local itemEquip		= false

		if nil ~= itemWrapper then
			-- servantType.noticeEndurance		:SetShow( true )
			servantType.repair_AutoNavi		:SetShow( true )
			servantType.repair_Navi			:SetShow( true )
			local endurance		= itemWrapper:get():getEndurance()
			local maxEndurance	= itemWrapper:get():getMaxEndurance()

			local currentEndurance = (endurance / maxEndurance) * 100
			-- UI.debugMessage( "현재내구도 : " .. endurance .. " / 최대내구도 : " .. maxEndurance  )

			if currentEndurance <= 0 then -- 내구도가 0 이하일 경우
				colorKey = UI_color.C_FFFF0000 -- 빨간색으로 표시한다.
				isBroken = true
				enduranceCheck = endurance + 1
				servantType.panel:SetShow( true )
			elseif currentEndurance <= self.brokenRate then -- 현재 내구도가 10% 이하일 경우
				colorKey = UI_color.C_FFFF8957	-- 주황색으로 표시한다.
				isBroken = true
				enduranceCheck = endurance + 1
			end

			itemEquip = true
			if ( servantColorKey[index] ~= colorKey ) then
				servantType[index]:SetColor(colorKey)
				servantColorKey[index] = colorKey
				isChange = true
			end
			if ( servantBroken[index] ~= isBroken ) then
				servantBroken[index] = isBroken
				isChange = true
			end
		else
			colorKey = UI_color.C_FF000000
			servantType[index]:SetColor(colorKey)
			servantColorKey[index] = colorKey

			servantBroken[index] = false
			isChange = false
			itemEquip = false
		end

		if ( servantItemEquiped[index] ~= itemEquip ) then
			isChange = true
			servantItemEquiped[index] = itemEquip
		end
	end

	if ( isChange ) then
		local isBroken = false
		for index, value in pairs( servantBroken ) do
			isbroken = isbroken or value
		end
	end

	if ( 0 < enduranceCheck ) then
		servantType.panel:SetShow( true )
		for index, value in pairs( servantEquipNo ) do
			servantType[index]:SetShow( true )
			if servantType == ship then
				ship.main:SetShow( true )
			else
				ship.main:SetShow( false )
			end
		end

		if horse == servantType and false == isHorseEffectShow then
			horseEffectBG:EraseAllEffect()
			horseEffectBG:AddEffect( "fUI_Horse_Armor_01A", true,  -0.5, -1.5 )
			isHorseEffectShow = true
		elseif carriage == servantType and false == isCarriageEffectShow then
			carriageEffectBG:EraseAllEffect()
			carriageEffectBG:AddEffect( "fUI_Cart_Armor_01A", true, 0, -5 )
			isCarriageEffectShow = true
		elseif ship == servantType and false == isShipEffectShow then
			shipEffectBG:EraseAllEffect()
			shipEffectBG:AddEffect( "fUI_Vessel_Armor_01A", true, 0, 0 )
			isShipEffectShow = true
		else
			servantType.panel:EraseAllEffect()
		end
	else
		servantType.panel:SetShow( false )
		if horse == servantType then
			horseEffectBG:EraseAllEffect()
			isHorseEffectShow = false
		elseif carriage == servantType then
			carriageEffectBG:EraseAllEffect()
			isCarriageEffectShow = false
		elseif ship == servantType then
			shipEffectBG:EraseAllEffect()
			isShipEffectShow = false
		end
		
		for index, value in pairs( servantEquipNo ) do
			servantType[index]:SetShow( false )
		end
		horse.noticeEndurance		:SetShow( false )
		horse.repair_AutoNavi		:SetShow( false )
		horse.repair_Navi			:SetShow( false )
		carriage.noticeEndurance	:SetShow( false )
		carriage.repair_AutoNavi	:SetShow( false )
		carriage.repair_Navi		:SetShow( false )
		ship.noticeEndurance		:SetShow( false )
		ship.repair_AutoNavi		:SetShow( false )
		ship.repair_Navi			:SetShow( false )
		ship.main					:SetShow( false )
	end
end

function PcEndurance_isShowToggle()
	return _chk_repair:GetShow()
end

function Panel_HorseEndurance_Position()
	if FGlobal_Panel_Radar_GetShow() then
		-- servantType.panel:SetPosX( getScreenSizeX() - Panel_Radar:GetSizeX() - (servantType.panel:GetSizeX()) )
		horse.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (horse.panel		:GetSizeX()*1.7) )
		carriage.panel	:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (carriage.panel	:GetSizeX()*1.7) )
		if horse.panel:GetShow() or carriage.panel:GetShow() then
			ship.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (ship.panel		:GetSizeX()*3.1) )
		else
			ship.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (ship.panel		:GetSizeX()*1.9) )
		end
		horse.panel		:SetPosY( FGlobal_Panel_Radar_GetSizeY() - (FGlobal_Panel_Radar_GetSizeY()/1.5) )
		carriage.panel	:SetPosY( FGlobal_Panel_Radar_GetSizeY() - (FGlobal_Panel_Radar_GetSizeY()/1.5) )
		ship.panel		:SetPosY( FGlobal_Panel_Radar_GetSizeY() - (FGlobal_Panel_Radar_GetSizeY()/1.4) )
	else
		horse.panel		:SetPosX( getScreenSizeX() - horse.panel	:GetSizeX() )
		carriage.panel	:SetPosX( getScreenSizeX() - carriage.panel	:GetSizeX() )
		ship.panel		:SetPosX( getScreenSizeX() - ship.panel		:GetSizeX() )
		horse.panel		:SetPosY( 30 )
		carriage.panel	:SetPosY( 30 )
		ship.panel		:SetPosY( 35 )
	end
	
	if Panel_Widget_TownNpcNavi:GetShow() then
		horse.panel		:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 10 )
		carriage.panel	:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 10 )
		ship.panel		:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 15 )
	end
end

function Panel_HorseEndurance_Resize()
	if FGlobal_Panel_Radar_GetShow() then
		horse.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (horse.panel		:GetSizeX()*1.7) )
		carriage.panel	:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (carriage.panel	:GetSizeX()*1.7) )
		if horse.panel:GetShow() or carriage.panel:GetShow() then
			ship.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (ship.panel		:GetSizeX()*3.1) )
		else
			ship.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (ship.panel		:GetSizeX()*1.9) )
		end
		horse.panel		:SetPosY( FGlobal_Panel_Radar_GetSizeY() - (FGlobal_Panel_Radar_GetSizeY()/1.35) )
		carriage.panel	:SetPosY( FGlobal_Panel_Radar_GetSizeY() - (FGlobal_Panel_Radar_GetSizeY()/1.35) )
		ship.panel		:SetPosY( FGlobal_Panel_Radar_GetSizeY() - (FGlobal_Panel_Radar_GetSizeY()/1.4) )
	else
		horse.panel		:SetPosX( getScreenSizeX() - horse.panel	:GetSizeX() )
		carriage.panel	:SetPosX( getScreenSizeX() - carriage.panel	:GetSizeX() )
		ship.panel		:SetPosX( getScreenSizeX() - ship.panel		:GetSizeX() )
		horse.panel		:SetPosY( 30 )
		carriage.panel	:SetPosY( 30 )
		ship.panel		:SetPosY( 35 )
	end

	if Panel_Widget_TownNpcNavi:GetShow() then
		horse.panel		:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 10 )
		carriage.panel	:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 10 )
		ship.panel		:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 15 )
	end
	shipNoticeEndurance:ComputePos()
	-- servantType.panel:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - servantType.panel:GetSizeX() - 10 )
end

function PcEndurance_isShow()
	if FGlobal_Panel_Radar_GetShow() then

		horse.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - horse.panel:GetSizeX() )
		carriage.panel	:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - carriage.panel:GetSizeX() )
		if horse.panel:GetShow() or carriage.panel:GetShow() then
			ship.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (ship.panel		:GetSizeX()*2.2) )
		else
			ship.panel		:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - (ship.panel		:GetSizeX()*1.1) )
		end
		horse.panel		:SetPosY( (FGlobal_Panel_Radar_GetSizeY()/1.5) )
		carriage.panel	:SetPosY( (FGlobal_Panel_Radar_GetSizeY()/1.5) )
		ship.panel		:SetPosY( (FGlobal_Panel_Radar_GetSizeY()/1.4) )
	else
		horse.panel		:SetPosX( getScreenSizeX() - horse.panel	:GetSizeX() )
		carriage.panel	:SetPosX( getScreenSizeX() - carriage.panel	:GetSizeX() )
		ship.panel		:SetPosX( getScreenSizeX() - ship.panel		:GetSizeX() )
		horse.panel		:SetPosY( 28 )
		carriage.panel	:SetPosY( 30 )
		ship.panel		:SetPosY( 35 )
	end

	if Panel_Widget_TownNpcNavi:GetShow() then
		horse.panel		:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 10 )
		carriage.panel	:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 10 )
		ship.panel		:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 15 )
	end
end

function HorseEndurance_registMessageHandler()
	registerEvent("EventServantEquipmentUpdate",		"Panel_ServantEndurance_UpdatePerFrame"	)
	registerEvent("EventServantEquipItem",				"Panel_ServantEndurance_UpdatePerFrame"	)
end

function HandleMouseOn_NoticeShow( isShow )

	horseNoticeEndurance	:SetShow( isShow )
	carriageNoticeEndurance	:SetShow( isShow )
	shipNoticeEndurance		:SetShow( isShow )

	if ( horse.panel:GetShow() or carriage.panel:GetShow() ) and ship.panel:GetShow() then
		horseNoticeEndurance	:SetShow( false )
		carriageNoticeEndurance	:SetShow( false )
	end

	isMouseOn = isShow
end

function HorseEndurance_registEventHandler()
	horse.repair_AutoNavi		:addInputEvent(	"Mouse_LUp", "HandleClick_ServantRepair_Navi( true )")
	carriage.repair_AutoNavi	:addInputEvent(	"Mouse_LUp", "HandleClick_ServantRepair_Navi( true )")
	ship.repair_AutoNavi		:addInputEvent(	"Mouse_LUp", "HandleClick_ServantRepair_Navi( true )")
	horse.repair_Navi			:addInputEvent(	"Mouse_LUp", "HandleClick_ServantRepair_Navi( false )")
	carriage.repair_Navi		:addInputEvent(	"Mouse_LUp", "HandleClick_ServantRepair_Navi( false )")
	ship.repair_Navi			:addInputEvent(	"Mouse_LUp", "HandleClick_ServantRepair_Navi( false )")

	horseEffectBG		:addInputEvent( "Mouse_On",		"HandleMouseOn_NoticeShow( true )")
	horseEffectBG		:addInputEvent( "Mouse_Out",	"HandleMouseOn_NoticeShow( false )")
	carriageEffectBG	:addInputEvent( "Mouse_On",		"HandleMouseOn_NoticeShow( true )")
	carriageEffectBG	:addInputEvent( "Mouse_Out",	"HandleMouseOn_NoticeShow( false )")
	shipEffectBG		:addInputEvent( "Mouse_On",		"HandleMouseOn_NoticeShow( true )")
	shipEffectBG		:addInputEvent( "Mouse_Out",	"HandleMouseOn_NoticeShow( false )")
end

-- local servantNavi = function( naviType )
-- 	if naviType == 1 then
-- 		panelType = horse.panel
-- 	elseif naviType == 2 then
-- 		panelType = ship.panel
-- 	end

-- 	noticeEndurance 	= UI.getChildControl ( panelType, "StaticText_NoticeEndurance" )
-- 	repair_AutoNavi 	= UI.getChildControl ( panelType, "CheckButton_Repair_AutoNavi" )
-- 	repair_Navi 		= UI.getChildControl ( panelType, "Checkbox_Repair_Navi" )
-- }

-- repair_AutoNavi	:addInputEvent(	"Mouse_LUp","HandleClick_Repair_Navi(true, )")
-- repair_Navi		:addInputEvent(	"Mouse_LUp","HandleClick_Repair_Navi(false, )")

function HandleClick_ServantRepair_Navi( isAuto )
	local player	= getSelfPlayer()
	if nil == player then
		return
	end

 	-- 네비 세팅
	ToClient_DeleteNaviGuideByGroup(0);
	
	if(	ToClient_IsShowNaviGuideGroup(0) ) then
		if true == isAuto and true == servantType.repair_AutoNavi:IsCheck() then
			servantType.repair_Navi		:SetCheck(true)
			servantType.repair_AutoNavi	:SetCheck(true)
		else
			servantType.repair_Navi		:SetCheck(false)
			servantType.repair_AutoNavi	:SetCheck(false)
			audioPostEvent_SystemUi(00,15)
			return
		end
	else
		if true == isAuto then
			servantType.repair_Navi		:SetCheck(true)
			servantType.repair_AutoNavi	:SetCheck(true)
		else
		    servantType.repair_Navi		:SetCheck(false)
			servantType.repair_AutoNavi	:SetCheck(false)
		end
	end


	local position = player:get3DPos() -- 기준이 되는 위치
	-- if servantType == 0 then
	-- 	local spawnType = CppEnums.SpawnType.eSpawnType_Stable -- 마구간 NPC
	-- elseif servantType == 1 then
	-- 	local spawnType = CppEnums.SpawnType.eSpawnType_Fish -- 나루터(?) NPC 다시 한번 확인해보자...
	-- end
	spawnType = CppEnums.SpawnType.eSpawnType_ItemRepairer -- 수리상인( 마구간 or 나루터에서 수리 가능하기전까지는 임시적으로 적용한다.)
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

function ServantEnduaranceInfo_Update()
	Panel_ServantEndurance_UpdatePerFrame()
	Panel_HorseEndurance_Position()
	registerEvent("onScreenResize", "Panel_HorseEndurance_Resize")
end

-- 탈 것의 MP바가 생성되면 실행한다.
function FGlobal_ServantEnduaranceInfo_PerFrameUpdate()
	local selfProxy			= getSelfPlayer():get()
	if nil == selfProxy then
		return
	end
	horse.panel		:RegisterUpdateFunc( "Panel_ServantEndurance_UpdatePerFrame" )
	carriage.panel	:RegisterUpdateFunc( "Panel_ServantEndurance_UpdatePerFrame" )
	ship.panel		:RegisterUpdateFunc( "Panel_ServantEndurance_UpdatePerFrame" )
	ServantEnduaranceInfo_Update()
end

init()
ServantEnduaranceInfo_Update()
Panel_HorseEndurance_Position()
FGlobal_ServantEnduaranceInfo_PerFrameUpdate()
HorseEndurance_registMessageHandler()
HorseEndurance_registEventHandler()
UI.addRunPostRestorFunction(Panel_HorseEndurance_Position)
UI.addRunPostRestorFunction(Panel_HorseEndurance_Resize)
-- registMessageHandler()
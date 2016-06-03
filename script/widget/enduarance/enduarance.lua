local UI_color 			= Defines.Color

local ui = {}
local enumEquipNo = {}
local enduranceBroken = {}
local colorKeyList = {}
local itemEquiped = {}
local isOnEffect = false

local noticeEndurance 	= UI.getChildControl ( Panel_Endurance, "StaticText_NoticeEndurance" )
local repair_AutoNavi 	= UI.getChildControl ( Panel_Endurance, "CheckButton_Repair_AutoNavi" )
local repair_Navi 		= UI.getChildControl ( Panel_Endurance, "Checkbox_Repair_Navi" )

local effectBG			= UI.getChildControl ( Panel_Endurance, "Static_Effect")

repair_AutoNavi	:addInputEvent(	"Mouse_LUp","HandleClick_Repair_Navi(true)")
repair_Navi		:addInputEvent(	"Mouse_LUp","HandleClick_Repair_Navi(false)")


local init = function()
	ui.panel		= Panel_Endurance
	ui.armor		= UI.getChildControl(ui.panel, "Static_Armor")
	ui.helm			= UI.getChildControl(ui.panel, "Static_Helm")
	ui.glove		= UI.getChildControl(ui.panel, "Static_Glove")
	ui.boots		= UI.getChildControl(ui.panel, "Static_Boots")
	ui.weaponR		= UI.getChildControl(ui.panel, "Static_WeaponR")
	ui.weaponL		= UI.getChildControl(ui.panel, "Static_WeaponL")
	ui.earingR		= UI.getChildControl(ui.panel, "Static_Earing1")
	ui.earingL		= UI.getChildControl(ui.panel, "Static_Earing2")
	ui.belt			= UI.getChildControl(ui.panel, "Static_Belt")
	ui.necklace		= UI.getChildControl(ui.panel, "Static_Necklace")
	ui.ringR		= UI.getChildControl(ui.panel, "Static_Ring1")
	ui.ringL		= UI.getChildControl(ui.panel, "Static_Ring2")
	ui.awaken		= UI.getChildControl(ui.panel, "Static_AwakenWeapon")
	ui.weight		= UI.getChildControl(ui.panel, "StaticText_WeightOver")
	ui.weightText	= UI.getChildControl(ui.panel, "StaticText_NoticeWeight")
	
	ui.armor		:SetShow(false)
	ui.helm			:SetShow(false)
	ui.glove		:SetShow(false)
	ui.boots		:SetShow(false)
	ui.weaponR		:SetShow(false)
	ui.weaponL		:SetShow(false)
	ui.earingR		:SetShow(false)
	ui.earingL		:SetShow(false)
	ui.belt			:SetShow(false)
	ui.necklace		:SetShow(false)
	ui.ringR		:SetShow(false)
	ui.ringL		:SetShow(false)
	ui.awaken		:SetShow(false)
	ui.weight		:SetShow(false)
	ui.weightText	:SetShow(false)
	noticeEndurance	:SetShow(false)
	repair_AutoNavi	:SetShow(false)
	repair_Navi		:SetShow(false)

	enumEquipNo.armor		= 3			-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.helm		= 6			-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.glove		= 4			-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.boots		= 5			-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.weaponR		= 0			-- EquipSlotNo 과 매핑되어있음. 
	enumEquipNo.weaponL		= 1			-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.earingR		= 10		-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.earingL		= 11		-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.belt		= 12		-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.necklace	= 7			-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.ringR		= 8			-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.ringL		= 9			-- EquipSlotNo 과 매핑되어있음.
	enumEquipNo.awaken		= 29		-- EquipSlotNo 과 매핑되어있음.

	enduranceBroken.armor		= false
	enduranceBroken.helm		= false
	enduranceBroken.glove		= false
	enduranceBroken.boots		= false
	enduranceBroken.weaponR		= false
	enduranceBroken.weaponL		= false
	enduranceBroken.earingR		= false
	enduranceBroken.earingL		= false
	enduranceBroken.belt		= false
	enduranceBroken.necklace	= false
	enduranceBroken.ringR		= false
	enduranceBroken.ringL		= false
	enduranceBroken.awaken		= false

	colorKeyList.armor		= Defines.Color.C_FF000000
	colorKeyList.helm		= Defines.Color.C_FF000000
	colorKeyList.glove		= Defines.Color.C_FF000000
	colorKeyList.boots		= Defines.Color.C_FF000000
	colorKeyList.weaponR	= Defines.Color.C_FF000000 
	colorKeyList.weaponL	= Defines.Color.C_FF000000
	colorKeyList.earingR	= Defines.Color.C_FF000000
	colorKeyList.earingL	= Defines.Color.C_FF000000
	colorKeyList.belt		= Defines.Color.C_FF000000
	colorKeyList.necklace	= Defines.Color.C_FF000000
	colorKeyList.ringR		= Defines.Color.C_FF000000
	colorKeyList.ringL		= Defines.Color.C_FF000000
	colorKeyList.awaken		= Defines.Color.C_FF000000

	itemEquiped.armor		= false
	itemEquiped.helm		= false
	itemEquiped.glove		= false
	itemEquiped.boots		= false
	itemEquiped.weaponR		= false
	itemEquiped.weaponL		= false
	itemEquiped.earingR		= false
	itemEquiped.earingL		= false
	itemEquiped.belt		= false
	itemEquiped.necklace	= false
	itemEquiped.ringR		= false
	itemEquiped.ringL		= false
	itemEquiped.awaken		= false


	registerEvent("onScreenResize", "Panel_Endurance_Resize")
	ui.panel:RegisterUpdateFunc( "Panel_Endurance_UpdatePerFrame" )

	if FGlobal_Panel_Radar_GetShow() then
		ui.panel:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - ui.panel:GetSizeX() )
		ui.panel:SetPosY( FGlobal_Panel_Radar_GetPosY() )
	else
		ui.panel:SetPosX( getScreenSizeX() - ui.panel:GetSizeX() )
		ui.panel:SetPosY( 30 )
	end

	if Panel_Widget_TownNpcNavi:GetShow() then
		ui.panel:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 10 )
	end

	ui.panel:SetShow(true)
	if not repair_Navi:GetShow() then
		effectBG:EraseAllEffect()
	end
end

Panel_Endurance:RegisterShowEventFunc( true, 'Panel_Endurance_ShowAni()' )
Panel_Endurance:RegisterShowEventFunc( false, 'Panel_Endurance_HideAni()' )

function Panel_Endurance_ShowAni()
	-- ♬ 고쳐야될 아이템이 있다!!
	-- audioPostEvent_SystemUi(08,06)
end
function Panel_Endurance_HideAni()
end


-------------------------------------------------------------
--			항상 실시간으로 내구도를 검사하자
-------------------------------------------------------------
local isEffectSound	= false
local isEffectShow	= false
function Panel_Endurance_UpdatePerFrame( deltaTime )
	local isUpdate = ( Defines.UIMode.eUIMode_Default == GetUIMode() ) --전체화면 모드가 아닐때만 update를 걸수 있다.
	if ( not isUpdate ) then
		return
	end

	local enduranceCheck = 0
	local isChange = false
	local isFishing = false
	for key , value in pairs( enumEquipNo ) do
		local equipItemWrapper = getEquipmentItem( value )
		local colorKey = Defines.Color.C_FF444444
		local isBroken = false
		local itemEquip = false
		if ( nil ~= equipItemWrapper ) then
			local endurance = equipItemWrapper:get():getEndurance()
			local maxEndurance = equipItemWrapper:get():getMaxEndurance()

			if ( endurance <= 0 ) then
				colorKey = Defines.Color.C_FFFF0000
				isBroken = true
				enduranceCheck = endurance + 1				
				if ( key == "weaponR" ) then
					local currentMin = equipItemWrapper:getStaticStatus():getMinDamage(idx)
					local currentMax = equipItemWrapper:getStaticStatus():getMaxDamage(idx)
					if ( 0 == currentMin ) and ( 0 == currentMax ) then
						isFishing = true
					end
				end
			elseif ( endurance <= maxEndurance/10 or 1 == endurance) then
				colorKey = 4294936919	-- argb : ff ff 89 57
				isBroken = true
				enduranceCheck = endurance + 1
				if ( key == "weaponR" ) then
					local currentMin = equipItemWrapper:getStaticStatus():getMinDamage(idx)
					local currentMax = equipItemWrapper:getStaticStatus():getMaxDamage(idx)
					if ( 0 == currentMin ) and ( 0 == currentMax ) then
						isFishing = true
					end
				end
			end
			itemEquip = true
			if ( colorKeyList[key] ~= colorKey ) then
				ui[key]:SetColor(colorKey)
				colorKeyList[key] = colorKey
				isChange = true
			end
			if ( enduranceBroken[key] ~= isBroken ) then
				enduranceBroken[key] = isBroken
				isChange = true
			end
		else
			enduranceBroken[key] = false
			isChange = false
			itemEquip = false
		end
		if ( itemEquiped[key] ~= itemEquip ) then
			isChange = true
			itemEquiped[key] = itemEquip
		end
	end

	if ( isChange ) then
		local isbroken = false
		for key, value in pairs( enduranceBroken ) do
			isbroken = isbroken or value
		end
	end

	if ( 0 < enduranceCheck ) then
		for key , value in pairs( enumEquipNo ) do
			ui[key]:SetShow( true )
		end

		if false == isEffectSound then
			isEffectSound = true
			audioPostEvent_SystemUi(08,06)
		end

		if false == isEffectShow then
			isEffectShow = true
			effectBG:EraseAllEffect()
			effectBG:AddEffect("fUI_PC_Armor_01A", true, -5.5, -0.45)
		end

		-- 주무기의 공격력이 0 이면! 낚싯대 or 화승총.. (타입 구분을 할 수가 없다! 생기면 교체) / 유일하게 주무기만 깨져있다면,
		if ( 4 == enduranceCheck or 1 == enduranceCheck ) and ( true == isFishing ) then
			noticeEndurance:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ENDURANCE_NOTICEENDURACNE1") )-- "낚싯대와 화승총은 수리가 불가능합니다.\n(내구도 0이 되면 기능을 사용할 수 없으니\n교체해주세요.)")
		elseif ( true == isFishing ) then								-- 다른 장비도 깨졌다면
			noticeEndurance:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ENDURANCE_NOTICEENDURACNE2") )-- "가까운 마을에서 수리할 수 있습니다.\n(낚싯대와 화승총은 수리가 불가능합니다.)")
		else															-- 일반 장비만 깨졌다면,
			noticeEndurance:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ENDURANCE_NOTICEENDURACNE3") ) -- "가까운 마을에서 수리할 수 있습니다.\n(내구도 0이 되면 어떤 기능도 낼 수 없습니다.)")
		end

		-- local selfProxy			= getSelfPlayer():get()
		-- if nil == selfProxy then
		-- 	return
		-- end

		-- if selfProxy:doRideMyVehicle() then
			-- noticeEndurance	:SetShow( false )
			-- repair_AutoNavi	:SetShow( false )
			-- repair_Navi		:SetShow( false )
		-- else
			-- noticeEndurance	:SetShow( true )
			repair_AutoNavi	:SetShow( true )
			repair_Navi		:SetShow( true )
		-- end
	else
		for key , value in pairs( enumEquipNo ) do
			ui[key]:SetShow( false )
		end
		isEffectSound	= false
		isEffectShow	= false
		effectBG:EraseAllEffect()
		noticeEndurance	:SetShow( false )
		repair_AutoNavi	:SetShow( false )
		repair_Navi		:SetShow( false )
	end

	if ( not repair_AutoNavi:GetShow() ) then
		PcEndurance_isShow()
	else
		Panel_HorseEndurance_Position()
		PcEnduranceToggle()
	end
	inEnduarance_WeightCheck()
	-- FGlobal_PcEnduranceShowCheck()
end

-------------------------------------------------------
--		가방 무게가 점점 꽉 들어차고 있다..
-------------------------------------------------------
function inEnduarance_WeightCheck()
	local _const = Defines.s64_const
	local selfPlayerWrapper		= getSelfPlayer()
	local selfPlayer			= selfPlayerWrapper:get()

	local s64_allWeight			= selfPlayer:getCurrentWeight_s64()
	local s64_maxWeight			= selfPlayer:getPossessableWeight_s64()
	
	local allWeight				= Int64toInt32( s64_allWeight ) / 10000
	local maxWeight				= Int64toInt32( s64_maxWeight ) / 10000

	local playerWeightPercent	= (allWeight / maxWeight) * 100

	-- 토탈 % 용
	local s64_moneyWeight		= selfPlayer:getInventory():getMoneyWeight_s64()
	local s64_equipmentWeight	= selfPlayer:getEquipment():getWeight_s64()
	local s64_allWeight			= selfPlayer:getCurrentWeight_s64()
	local s64_maxWeight			= selfPlayer:getPossessableWeight_s64()

	local moneyWeight			= Int64toInt32( s64_moneyWeight ) / 10000
	local equipmentWeight		= Int64toInt32( s64_equipmentWeight ) / 10000
	local allWeight				= Int64toInt32( s64_allWeight ) / 10000
	local maxWeight				= Int64toInt32( s64_maxWeight ) / 10000
	
	local invenWeight			= allWeight - equipmentWeight - moneyWeight
	-- local totalWeight = ( string.format( "%.0f", (invenWeight/maxWeight)*100) + string.format( "%.0f", (moneyWeight/maxWeight)*100) + string.format( "%.0f", (equipmentWeight/maxWeight)*100) )
	local sumtotalWeight		= (allWeight / maxWeight) * 100
	local totalWeight			= string.format( "%.0f", sumtotalWeight )

	
	if 90 <= sumtotalWeight then
		if repair_AutoNavi:GetShow() then
			ui.weight:SetPosY(ui.panel:GetSizeY() + 50)
		else

			ui.weight:SetPosY(5)
		end
		if Panel_HorseEndurance:GetShow() or Panel_CarriageEndurance:GetShow() or Panel_ShipEndurance:GetShow() then
			ui.weight:SetPosY(ui.panel:GetSizeY() + 35)
		end
		ui.weight:SetShow( true )
		ui.weight: SetAlpha(0.8)
		ui.weight:SetText( totalWeight .. "%" )
		-- ui.weightText:SetShow( true )
		-- ui.weightText:SetPosX( ui.weight:GetPosX() - ui.weightText:GetTextSizeX() - 25 )
		-- ui.weightText:SetPosY( ui.weight:GetPosY() - 4 )
		
		if ( sumtotalWeight >= 100 ) then
			ui.weight:SetFontColor( UI_color.C_FFF26A6A )
		elseif ( 99 >= sumtotalWeight ) then
			ui.weight:SetFontColor( UI_color.C_FFC4BEBE )
		end
	else
		ui.weight:SetShow( false )
		ui.weightText:SetShow( false )
	end

	if 100 <= sumtotalWeight and false == isOnEffect then
		ui.weight:EraseAllEffect()
		ui.weight:AddEffect( "fUI_Weight_01A", true, -0.5, -1.3 )
		isOnEffect = true
	elseif sumtotalWeight < 100 then
		ui.weight:EraseAllEffect()
		isOnEffect = false
	end
end

function FGlobal_Inventory_WeightCheck()
	inEnduarance_WeightCheck()
end

registerEvent("FromClient_WeightPenaltyChanged", "inEnduarance_WeightCheck")
--registerEvent("EventCharacterInfoUpdate", "inEnduarance_WeightCheck")

function Panel_Endurance_Resize()
	-- if Panel_Radar:GetShow() then
		-- ui.panel:SetPosX( getScreenSizeX() - Panel_Radar:GetSizeX() - ui.panel:GetSizeX() )
	-- else
		-- ui.panel:SetPosX( getScreenSizeX() - ui.panel:GetSizeX() )
		-- ui.panel:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 15 )
	-- end
	Panel_Endurance:SetPosX( getScreenSizeX() - FGlobal_Panel_Radar_GetSizeX() - Panel_Endurance:GetSizeX() - 10 )
	Panel_Endurance:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 15 )

	-- if Panel_Widget_TownNpcNavi:GetShow() then
		-- ui.panel:SetPosY( Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 15 )
	-- end
end

-------------------------------------------------------
--		장비 수리 NPC로 안내하자!
-------------------------------------------------------

function HandleClick_Repair_Navi(isAuto)
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
	local spawnType 	= CppEnums.SpawnType.eSpawnType_ItemRepairer -- 수리 NPC
	
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

function FGlobal_PcEnduranceNaviShow()
	noticeEndurance	:SetShow( false )
	repair_AutoNavi	:SetShow( false )
	repair_Navi		:SetShow( false )
end

-- function FGlobal_PcEnduranceShowCheck()
	-- FGlobal_Panel_HorseEndurance_Position()
-- end

function HandleMouseOn_PcWeightOver( isShow )
	if true == isShow then
		ui.weightText:SetShow( true )
		ui.weightText:SetPosX( ui.weight:GetPosX() - ui.weightText:GetTextSizeX() - 25 )
		ui.weightText:SetPosY( ui.weight:GetPosY() - 4 )
	else
		ui.weightText:SetShow( false )
	end
end

function HandleMouseOn_PcEnduranceNotice( isShow )
	if not repair_AutoNavi:GetShow() then
		return
	end
	noticeEndurance:SetShow( isShow )
end

function PcWeight_registEventHandler()
	ui.weight:addInputEvent("Mouse_On", "HandleMouseOn_PcWeightOver( true )")
	ui.weight:addInputEvent("Mouse_Out", "HandleMouseOn_PcWeightOver( false )")
	effectBG:addInputEvent("Mouse_On", "HandleMouseOn_PcEnduranceNotice( true )")
	effectBG:addInputEvent("Mouse_Out", "HandleMouseOn_PcEnduranceNotice( false )")
end

init()
PcWeight_registEventHandler()
UI.addRunPostRestorFunction(Panel_Endurance_Resize)
UI.addRunPostRestorFunction(init)
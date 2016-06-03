local UI_color		= Defines.Color

Panel_HouseName:SetShow( false )
Panel_HouseName:SetIgnore( true )


Panel_HouseName:RegisterShowEventFunc( true, 'Panel_HouseName_ShowAni()' )
Panel_HouseName:RegisterShowEventFunc( false, 'Panel_HouseName_HideAni()' )

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
local ui = {
	_houseName				=	UI.getChildControl ( Panel_HouseName, "StaticText_HouseName" ),
	_hosueIcon				=	UI.getChildControl ( Panel_HouseName, "Static_HouseIcon" ),
	_btnInstallationMode 	= 	UI.getChildControl ( Panel_HouseName, "Button_Install" ),
	_btnNoticeLighting	 	= 	UI.getChildControl ( Panel_HouseName, "StaticText_NoticeLighting" ),
	_btnInstallGift			=	UI.getChildControl ( Panel_HouseName, "Button_InstallGift" ),
	_btnShowRank		 	= 	UI.getChildControl ( Panel_HouseName, "Button_ShowRank" ),
	_btnScreenShot		 	= 	UI.getChildControl ( Panel_HouseName, "Button_Capture" ),
	_btnSetUnderWear	 	= 	UI.getChildControl ( Panel_HouseName, "Button_SetUnderwear" ),
	-- _btnSetWorkerParty	 	= 	UI.getChildControl ( Panel_HouseName, "Button_WorkerParty" ),
}

ui._btnSetUnderWear		:addInputEvent(	"Mouse_LUp",	"HandleClicked_SetShowUnderWearToggle()"	)
ui._btnSetUnderWear		:addInputEvent(	"Mouse_On",		"HouseName_ButtonTooltip( true, " .. 0 .. " )"	)
ui._btnSetUnderWear		:addInputEvent(	"Mouse_Out",	"HouseName_ButtonTooltip( false )"	)

ui._btnInstallationMode	:addInputEvent(	"Mouse_LUp",	"HouseName_Click_InstallationMode()" )
ui._btnInstallationMode	:addInputEvent(	"Mouse_On",		"HouseName_ButtonTooltip( true, " .. 1 .. " )"	)
ui._btnInstallationMode	:addInputEvent(	"Mouse_Out",	"HouseName_ButtonTooltip( false )"	)
ui._btnInstallationMode	:SetShow( false )

ui._btnInstallGift		:addInputEvent(	"Mouse_LUp",	"HouseName_Click_InstallationMode()" )
ui._btnInstallGift		:addInputEvent(	"Mouse_On",		"HouseName_ButtonTooltip( true, " .. 3 .. " )"	)
ui._btnInstallGift		:addInputEvent(	"Mouse_Out",	"HouseName_ButtonTooltip( false )"	)
ui._btnInstallGift		:SetShow( false )

ui._btnShowRank			:addInputEvent(	"Mouse_LUp",	"Housename_Click_ShowRank()"	)
ui._btnShowRank			:addInputEvent(	"Mouse_On",		"HouseName_ButtonTooltip( true, " .. 2 .. " )"	)
ui._btnShowRank			:addInputEvent(	"Mouse_Out",	"HouseName_ButtonTooltip( false )"	)
ui._btnShowRank			:SetShow( false ) -- 원래 true 임시로 막음.

-- ui._btnSetWorkerParty	:addInputEvent(	"Mouse_LUp",	"HandleClicked_LetsWorkerParty()"	)
-- ui._btnSetWorkerParty	:addInputEvent(	"Mouse_On",		"HouseName_ButtonTooltip( true, " .. 2 .. " )"	)
-- ui._btnSetWorkerParty	:addInputEvent(	"Mouse_Out",	"HouseName_ButtonTooltip( false )"	)
-- ui._btnSetWorkerParty	:SetShow( false )

ui._btnSetUnderWear		:setTooltipEventRegistFunc("HouseName_ButtonTooltip( true, " .. 0 .. " )")
ui._btnInstallationMode	:setTooltipEventRegistFunc("HouseName_ButtonTooltip( true, " .. 1 .. " )")
ui._btnInstallGift		:setTooltipEventRegistFunc("HouseName_ButtonTooltip( true, " .. 3 .. " )")
ui._btnShowRank			:setTooltipEventRegistFunc("HouseName_ButtonTooltip( true, " .. 2 .. " )")

ui._btnScreenShot:addInputEvent(	"Mouse_LUp",	""	)	
ui._btnScreenShot:SetShow( false )

local _isMyHouse = false;
local updateTime = 0.0
local isAlertHouseLighting = false

function HouseName_ButtonTooltip( isShow, buttonNo )
	local control	= nil
	local name		= nil
	local desc		= nil

	if 0 == buttonNo then
		control = ui._btnSetUnderWear
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_TITLE_UNDERWEAR") -- "속옷보기"
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_DESC_UNDERWEAR") -- "캐릭터가 착용중인 속옷(의상) 확인 가능"
	elseif 1 == buttonNo then
		control = ui._btnInstallationMode
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_TITLE_INSTALLATIONMODE") -- "배치 모드"
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_DESC_INSTALLATIONMODE") -- "주거지 가구 및 설비 도구를 배치하는 모드로 전환"
	elseif 2 == buttonNo then
		control = ui._btnShowRank
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_TITLE_SHOWRANK") -- "집 순위 보기"
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_DESC_SHOWRANK") -- "이 집을 주거지로 사용하는 다른 모험가 중 인테리어 점수가 가장 높은 10명의 목록"
	elseif 3 == buttonNo then
		control = ui._btnInstallGift
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_TITLE_INSTALLGIFT") -- "꾸며주기"
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_DESC_INSTALLGIFT") -- "친구의 집에 입장하여 펄 상점에서 판매하는 가구를 설치해 줄 수 있는 모드로 전환"
	end

	if true == isShow then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end


------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

function HouseName_Click_InstallationMode()
	FGlobal_House_InstallationMode_Open()
end

function Housename_Click_ShowRank()
	toClient_RequestHouseRankerList()
end

function HandleClicked_LetsWorkerParty()
	local currentWayPointKey	= getCurrentWaypointKey()
	local plantKey				= ToClient_convertWaypointKeyToPlantKey( currentWayPointKey )
	local workerCount			= ToClient_getPlantWaitWorkerListCount( plantKey, 0 )
	if 0 < workerCount then
		local houseWrapper	= housing_getHouseholdActor_CurrentPosition()
		if nil ~= houseWrapper then
			local characterKeyRaw = houseWrapper:getStaticStatusWrapper():getCharacterKey()
			local housePlantKey = PlantKey()
			housePlantKey:setHouseKeyRaw( characterKeyRaw )
			ToClient_requestStartHousePartyAll( housePlantKey )
		end
	end
end

function HandleClicked_SetShowUnderWearToggle()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	if selfPlayer:get():getUnderwearModeInhouse() then
		selfPlayer:get():setUnderwearModeInhouse( false )
		Toclient_setShowAvatarEquip()
	else
		selfPlayer:get():setUnderwearModeInhouse( true )
	end
	-- FromClient_ChangeUnderwearModeInHouse( isUnderwearModeInHouse )
end

function FromClient_ChangeUnderwearModeInHouse( isUnderwearModeInHouse )
	ui._btnSetUnderWear:SetCheck( isUnderwearModeInHouse )
end

------------------------------------------------------------------------------------------------
--									켜고 끄는 함수들
------------------------------------------------------------------------------------------------
function Panel_HouseName_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_HouseName, 0.0,1.0 )
end

function Panel_HouseName_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_HouseName, 0.0, 0.35 )
	aniInfo:SetHideAtEnd(true)
end

function Panel_HouseName_Resize()
	Panel_HouseName:SetPosX( ( getScreenSizeX() / 2 ) - ( Panel_HouseName:GetSizeX() / 2 ) )
end

------------------------------------------------------------------------------------------------
--				어떠한 조건이 날아오면 플레이어 이름과 주소를 출력해준다
------------------------------------------------------------------------------------------------
function EventHousingShowVisitHouse( isShow, houseName, userNickname , point, isMine )

	local isShowUnderwear = getSelfPlayer():get():getUnderwearModeInhouse()
	ui._btnSetUnderWear:SetCheck( isShowUnderwear )

	-- 데이터는 업데이트 되어야한다. 보이는것은 밑에서 함
	local houseWrapper	= housing_getHouseholdActor_CurrentPosition()
	if nil == houseWrapper then
		Panel_HouseName:SetShow( false, false )
		FGlobal_AlertHouseLightingReset()
		ui._btnNoticeLighting:SetShow( false )
		return
	end

	_isMyHouse = isMine;
	local isInnRoom		= houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
	local isFixedHouse	= houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse()
	if isFixedHouse then
		ui._btnShowRank:SetShow( false )
		ui._btnInstallationMode:SetShow( false )
		ui._btnInstallGift:SetShow( false )
		-- ui._btnSetWorkerParty:SetShow( false )
		return;
	elseif isInnRoom then
		ui._btnShowRank:SetShow( false ) -- 원래 true 임시로 막음
		-- ui._btnSetWorkerParty:SetShow( false )
		if isMine then
			ui._btnInstallationMode:SetShow( true )
			ui._btnInstallGift:SetShow( false )

			-- 일꾼이 1명이라도 있으면 파티 버튼을 노출한다.
			-- local currentWayPointKey	= getCurrentWaypointKey()
			-- local plantKey				= ToClient_convertWaypointKeyToPlantKey(currentWayPointKey)
			-- local workerCount			= ToClient_getPlantWaitWorkerListCount( plantKey, 0 )
			-- if 0 < workerCount then
			-- 	-- ui._btnSetWorkerParty:SetShow( true )
			-- end
		else
			ui._btnInstallationMode:SetShow( false )
			if FGlobal_IsCommercialService() then
				ui._btnInstallGift:SetShow( true )
			else
				ui._btnInstallGift:SetShow( false )
			end
		end
	else
		ui._btnShowRank:SetShow( false )
		ui._btnInstallationMode:SetShow( false )
		ui._btnInstallGift:SetShow( false )
	end
	
	local desc = ( "<PAColor0xFFFFD649>" .. userNickname.. "<PAOldColor> " .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_HOUSENAME_LIVING" ) .. "( " ..houseName.. " ) " ..tostring(point) )
	ui._houseName:SetText( desc )

	if Panel_Housing:IsShow() then
		return;
	end
	
	-- 입출입에 실행된다.
	if Panel_House_InstallationMode:GetShow() then
		return
	end
	
	-- 입출입에 실행된다.
	if Panel_Interaction_HouseRank:GetShow() then
		Panel_Interaction_HouseRanke_Close()
	end
	
	Panel_HouseName:SetShow(isShow, true)
end

function EventHousingShowChangeTopRanker( houseName, userNo, userNickname, point )
	--[[
	if( nil ~= userNickname ) then
		local text = tostring(userNickname);
		if( 0 < string.len(text) ) then		
			local text = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_HOUSINGNAME_SHOWCHANGETOPRANKER", "houseName", houseName, "userNickname", userNickname ) -- houseName .. "의 인테리어 점수 1위가 " ..tostring(userNickname).."님으로 바뀌었습니다.";
			Proc_ShowMessage_Ack( text, 4.6 );
		end
	end
	--]]
end

function HouseLightingCheck(deltaTime)	-- 조명이 설치되어있다면 안내 메시지 노출 (진입 후 5초 후 한번만 호출)
	updateTime = updateTime + deltaTime
	if false == isAlertHouseLighting and 5 == math.ceil(updateTime) then
		local houseWrapper = housing_getHouseholdActor_CurrentPosition()
		local isHaveLightInstallation = houseWrapper:isHaveLightInstallation()
		
		if true == isHaveLightInstallation then
			ui._btnNoticeLighting:SetShow( false )
		else
			ui._btnNoticeLighting:SetShow( true )
		end
		isAlertHouseLighting = true
	end
end

function FGlobal_AlertHouseLightingReset()	-- 조명설치 안내 메시지 관련 변수 초기화
	updateTime = 0.0
	isAlertHouseLighting = false
end

function Panel_HouseName_CheckHouse()
	if Panel_HouseName:GetShow() then
		local houseWrapper	= housing_getHouseholdActor_CurrentPosition()
		if nil == houseWrapper then
			Panel_HouseName:SetShow( false, false )
		end
	end
end

UI.addRunPostRestorFunction( Panel_HouseName_CheckHouse )	-- 플러시를 나올 때, 집이 아니면 주거지 메뉴를 꺼야 한다.


registerEvent("EventHousingShowVisitHouse",				"EventHousingShowVisitHouse")
registerEvent("FromClient_ChangeUnderwearModeInHouse",	"FromClient_ChangeUnderwearModeInHouse")
registerEvent("EventHousingShowChangeTopRanker",		"EventHousingShowChangeTopRanker")
registerEvent("onScreenResize", 						"Panel_HouseName_Resize" )

Panel_HouseName:RegisterUpdateFunc("HouseLightingCheck")
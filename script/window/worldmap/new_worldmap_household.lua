local HGLT = CppEnums.HouseGroupLocationType
local HouseButtonSetBaseTextureUV = function(pData, pPath, pX1, pY1, pX2, pY2)
	pData:ChangeTextureInfoName( pPath )
	local x1, y1, x2, y2 = setTextureUV_Func( pData, pX1, pY1, pX2, pY2 )
	pData:getBaseTexture():setUV(  x1, y1, x2, y2  )
end
	
local HouseButtonSetOnTextureUV = function(pData, pPath, pX1, pY1, pX2, pY2)	
	pData:ChangeOnTextureInfoName ( pPath )	
	x1, y1, x2, y2 = setTextureUV_Func( pData, pX1, pY1, pX2, pY2 )
	pData:getOnTexture():setUV(  x1, y1, x2, y2  )
end

local houseInfo = nil
local houseKey = nil
local temp_houseEffectArray = Array.new()

local controlNameList = {
	[-1]			= "Static_Empty",		-- 빈집
	[CppEnums.eHouseUseType.Empty						] = "Static_LiveHouse",		-- 주거지
	[CppEnums.eHouseUseType.Lodging						] = "Static_Inn",			-- 숙소
	[CppEnums.eHouseUseType.Depot						] = "Static_WareHouse",		-- 창고
	[CppEnums.eHouseUseType.Ranch						] = "Static_Horse",			-- 마구간
	[CppEnums.eHouseUseType.WeaponForgingWorkshop		] = "Static_Weapon",		-- 무기 단조 공방
	[CppEnums.eHouseUseType.ArmorForgingWorkshop		] = "Static_Guard",			-- 갑주 단조 공방
	[CppEnums.eHouseUseType.HandMadeWorkshop			] = "Static_HandMade",		-- 수공예 공방
	[CppEnums.eHouseUseType.WoodCraftWorkshop			] = "Static_Carpenter",		-- 목공예 공방
	[CppEnums.eHouseUseType.JewelryWorkshop				] = "Static_Jewel",			-- 세공소
	[CppEnums.eHouseUseType.ToolWorkshop				] = "Static_Tools",			-- 도구 공방
	[CppEnums.eHouseUseType.Refinery					] = "Static_Blackstone",	-- 정제소
	[CppEnums.eHouseUseType.ImproveWorkshop				] = "Static_Upgrade",		-- 개량소
	[CppEnums.eHouseUseType.CannonWorkshop				] = "Static_Cannon",		-- 대포 제작 공방
	[CppEnums.eHouseUseType.Shipyard					] = "Static_Ships",			-- 조선소
	[CppEnums.eHouseUseType.CarriageWorkshop			] = "Static_Carriage",		-- 마차 제작소
	[CppEnums.eHouseUseType.HorseArmorWorkshop			] = "Static_HorseGoods",	-- 마구 제작소
	[CppEnums.eHouseUseType.FurnitureWorkshop			] = "Static_Furniture",		-- 가구 공방
	[CppEnums.eHouseUseType.LocalSpecailtiesWorkshop	] = "Static_Special",		-- 특산물 가공소
	[CppEnums.eHouseUseType.Wardrobe					] = "Static_MakeCustomize",	-- 의상실
	[CppEnums.eHouseUseType.SiegeWeapons				] = "Static_MakeCannon",	-- 공성무기
	[CppEnums.eHouseUseType.ShipParts					] = "Static_MakeShip",		-- 선박부품
	[CppEnums.eHouseUseType.WagonParts					] = "Static_MakeCarriage",	-- 마차부품

	_changeUseType	= "Static_Const",		-- 용도 변경 중
	_crafting		= "Static_Change",		-- 제작 중
	_noPurchasable	= "Static_Working",		-- 구매불가
}
function FGlobal_HouseHoldButtonSetBaseTexture( houseBtn )	
	-- if(1)then
	-- return
	-- end
	
	if( nil == houseBtn ) then
		return
	end	
	
    local houseInfo = houseBtn:FromClient_getStaticStatus()
	local houseKey = houseInfo:getHouseKey()
	local workingcnt = ToClient_getHouseWorkingWorkerList( houseInfo:get() )
	local rentHouseWrapper = ToClient_GetRentHouseWrapper(houseKey)

    local houselocationType = houseInfo:getHouseLocationType()

	local stringName = controlNameList[-1]

	local isShowConstructionAni = false
	
	if true == ToClient_IsMyHouse(houseKey) then		-- 내 집을 검사한다(주거지)
		if ( ToClient_GetProgressRateChangeHouseUseType( houseKey ) < 100 ) then
			-- 용도 변경 중
			stringName = controlNameList._changeUseType
			isShowConstructionAni = true
			
		elseif ( workingcnt >= 1) then
			-- 제작 중
			stringName = controlNameList._crafting
			isShowConstructionAni = true
		else
			if ( nil == rentHouseWrapper ) then
				return
			end	

			local useType = rentHouseWrapper:getHouseUseType()
			if false == ToClient_IsMyLiveHouse( houseKey ) and 0 == useType then
				useType = -1
			end

			stringName = controlNameList[useType]
			if nil == stringName then
				--못찾으면 기본으로 표기함. ( 빈집은 아니니까 주거지로 함. )
				stringName = controlNameList[0]
			end
			
		end
	else
		if( false == houseInfo:isPurchasable(CppEnums.eHouseUseType.Depot) ) then
			stringName = controlNameList[-1]
		else		
			-- 구매불가
			stringName = controlNameList._noPurchasable
		end
	end

	-- '작업중상태' 컨트롤 표시여부
	local constructionAni 	= houseBtn:FromClient_getConstructionAni()
	local guageBG 			= houseBtn:FromClient_getConstructionGuageBG();
	local guage 			= houseBtn:FromClient_getConstructionGauge();
	local remainTime 		= houseBtn:FromClient_getRemainTime()
	if ( nil ~= constructionAni ) then
		constructionAni:SetShow(isShowConstructionAni)
		guageBG:SetShow( isShowConstructionAni )
		guage:SetShow( isShowConstructionAni )
		remainTime:SetShow( isShowConstructionAni )
	end
	
	--집 구조에따라 이미지를 바꿔준다.
	if ( HGLT.eHouseGroupLocationType_onlyOne		== houselocationType ) then
		--noop;
	elseif ( HGLT.eHouseGroupLocationType_bottom	== houselocationType ) then
		stringName = stringName .. "_3F"--이미지가 뒤집어져있습니다.... ㅠ.ㅠ
	elseif ( HGLT.eHouseGroupLocationType_center	== houselocationType ) then
		stringName = stringName .. "_2F"--이미지가 뒤집어져있습니다.... ㅠ.ㅠ
	elseif ( HGLT.eHouseGroupLocationType_top		== houselocationType ) then
		stringName = stringName .. "_1F"--이미지가 뒤집어져있습니다.... ㅠ.ㅠ
    end

	houseBtn:EraseAllEffect()
	local posX = houseBtn:GetPosX()
	local posY = houseBtn:GetPosY()
	local scale = houseBtn:GetScale()
	local isShow = houseBtn:GetShow()
	
	houseBtn:SetScale(1,1)
	CopyBaseProperty(UI.getChildControl(Panel_HouseIcon, stringName), houseBtn )
	if false == ToClient_IsMyHouse(houseKey) and ( true == houseInfo:isPurchasable(CppEnums.eHouseUseType.Depot) ) then
		-- houseBtn:ResetVertexAni()
		houseBtn:SetVertexAniRun( "Ani_Color_New", true )
	end
	houseBtn:SetPosX(posX)
	houseBtn:SetPosY(posY)
	houseBtn:SetScale(scale.x, scale.y)
	houseBtn:setRenderTexture(houseBtn:getBaseTexture())
	houseBtn:SetShow(isShow)
end

function FromClient_LClickedWorldMapHouse(houseBtn)
	houseInfo = houseBtn:FromClient_getStaticStatus()
	if (nil == houseInfo) then
		return
	end
	
	clear_HouseSelectedAni_byHouse()		
	houseKey = houseInfo:getHouseKey()
	
	local IsUsable = ToClient_IsUsable( houseKey )

	if false == Panel_HouseControl:GetShow() and false == Panel_House_SellBuy_Condition:GetShow() then
		clear_HouseSelectedAni_bySellBuy()
		if true == Panel_RentHouse_WorkManager:GetShow() then
			if true == Panel_Select_Inherit:GetShow() then
				WorldMapPopupManager:pop()
			end
			WorldMapPopupManager:pop()
			if false == Panel_HouseControl:GetShow() then
				WorldMapPopupManager:increaseLayer()
				WorldMapPopupManager:push(	Panel_HouseControl, true  )
			end
		elseif true == Panel_Building_WorkManager:GetShow() or true == Panel_LargeCraft_WorkManager:GetShow() or true == Panel_Plant_WorkManager:GetShow() then
			WorldMapPopupManager:pop()
			if false == Panel_HouseControl:GetShow() then
				WorldMapPopupManager:increaseLayer()
				WorldMapPopupManager:push(	Panel_HouseControl, true  )
			end
		else
			WorldMapPopupManager:increaseLayer()
			WorldMapPopupManager:push(	Panel_HouseControl, true  )
		end
	elseif true == Panel_House_SellBuy_Condition:GetShow() then
		--[[
		local isListed = check_SellBuyList(houseKey)					
		if true == isListed then
			show_HouseSelectedAni_bySellBuy()
			if false == Panel_HouseControl:GetShow() then
				WorldMapPopupManager:push(	Panel_HouseControl, true  )
			end
		elseif false == isListed then
			WorldMapPopupManager:pop()
			clear_HouseSelectedAni_bySellBuy()
			if false == Panel_HouseControl:GetShow() then
				WorldMapPopupManager:increaseLayer()
				WorldMapPopupManager:push(	Panel_HouseControl, true  )
			end
		end	
		--]]
		WorldMapPopupManager:pop()
		if false == Panel_HouseControl:GetShow() then
			WorldMapPopupManager:increaseLayer()
			WorldMapPopupManager:push(	Panel_HouseControl, true  )
		end		
	end
	
	show_HouseSelectedAni_byHouse()
	
	FGlobal_UpdateHouseControl(houseInfo)
	FGlobal_Reset_HousePanelPos()
	
end

function show_HouseSelectedAni_byHouse()
	local _HouseBtn 	= ToClient_findHouseButtonByKey(houseKey)
	if _HouseBtn ~= nil then
		local _selectedAni = _HouseBtn:FromClient_getSelectedAni()
		_selectedAni:SetShow(true)
		_selectedAni:SetHorizonCenter()
		_selectedAni:SetVerticalMiddle()
		-- _HouseBtn:ResetVertexAni()
		_HouseBtn:SetVertexAniRun( "Ani_Color_New", true )
	end
end

function clear_HouseSelectedAni_byHouse()
	local _HouseBtn 	= ToClient_findHouseButtonByKey(houseKey)
	if _HouseBtn ~= nil then
		local _selectedAni 	= _HouseBtn:FromClient_getSelectedAni()
		_selectedAni:SetShow(false)
		_HouseBtn:ResetVertexAni()
		if false == ToClient_IsMyHouse(houseKey) and ( true == ToClient_GetHouseInfoStaticStatusWrapper(houseKey):isPurchasable(CppEnums.eHouseUseType.Depot) ) then
			_HouseBtn:SetVertexAniRun( "Ani_Color_New", true )
		end
	end
end


function FromClient_RClickedWorldMapHouse( houseBtn )
	local houseInfo = houseBtn:FromClient_getStaticStatus()
	if( nil == houseInfo ) then
		return
	end
	
	FromClient_RClickWorldmapPanel( houseInfo:getPosition(), false, true )
	-- ToClient_DeleteNaviGuideByGroup(0);
	-- ToClient_WorldMapNaviStart( houseInfo:getPosition(), NavigationGuideParam(), false, true )
	
	-- audioPostEvent_SystemUi(00,14)
end


--local tooltipHouseKey = 0;
--function FromClient_OnWorldMapHouse( houseBtn, mouseX, mouseY )
--
--	local houseStaticStatus = houseBtn:FromClient_getStaticStatus();
--	local houseKey = houseStaticStatus:getHouseKey();
--
--	if( tooltipHouseKey == houseKey ) then
--			return;
--	end
--
--	ToClient_showNodeName( houseStaticStatus:getName(), houseBtn );
--end
--
--function FromClient_OutWorldMapHouse(houseBtn, mouseX, mouseY )
--		ToClient_hideNodeName();
--end
--

function FGlobal_SelectedHouseInfo(_houseKey)
	local houseInfoSSW = ToClient_findHouseButtonByKey(_houseKey):FromClient_getStaticStatus()
	return houseInfoSSW;
end

function FromClient_AppliedChangeUseType_Ack(houseInfoSSWrapper)
	local _houseKey = houseInfoSSWrapper:getHouseKey()
	local houseName = houseInfoSSWrapper:getName()
	
	local rentHouse = ToClient_GetRentHouseWrapper(_houseKey)
	local currentUseType = rentHouse:getType()	
	local realIndex = houseInfoSSWrapper:getIndexByReceipeKey(currentUseType)
	local houseInfoCraftWrapper = houseInfoSSWrapper:getHouseCraftWrapperByIndex(realIndex)
	local useType_Name = houseInfoCraftWrapper:getReciepeName()
	
	local currentHouseLevel = rentHouse:getLevel()
	
	if currentHouseLevel > 1 then
		Proc_ShowMessage_Ack( houseName .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_ONCHANGE_END_1", "typeName", useType_Name, "typeLevel", currentHouseLevel) )
	elseif currentHouseLevel == 1 then
		Proc_ShowMessage_Ack( houseName .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_ONCHANGE_END_2", "typeName", useType_Name) )
	end
end


-- 하우스 필터용.
function FGlobal_FilterClear()
	temp_houseEffectArray = Array.new()
end
function FGlobal_FilterEffectClear()
	for idx = 1, temp_houseEffectArray:length() do
		temp_houseEffectArray[idx]:EraseAllEffect()
	end

	FGlobal_FilterClear()
end

local houseEffectArray_Key = 0
function FromClient_HouseFilterOn( house_btn )
	local btn = house_btn
	btn:AddEffect( "UI_ArrowMark_Diagonal01", true, 70, 80 )
	temp_houseEffectArray:push_back( btn )
end

--[[
if houseInfo:isFixedHouse() or houseInfo:isInnRoom() then
		WorldMapWindow.infoNodeKeyType = WorldMapWindow.EnumInfoNodeKeyType.eInfoNodeKeyType_FixedHouseListIdx
else
		WorldMapWindow.infoNodeKeyType = WorldMapWindow.EnumInfoNodeKeyType.eInfoNodeKeyType_HouseListIdx
end
]]--

registerEvent("FromClient_LClickedWorldMapHouse",	"FromClient_LClickedWorldMapHouse")
registerEvent("FromClient_SetHouseTexture",			"FGlobal_HouseHoldButtonSetBaseTexture")
registerEvent("FromClient_AppliedChangeUseType",	"FromClient_AppliedChangeUseType_Ack")
registerEvent("FromClient_RClickedWorldMapHouse",	"FromClient_RClickedWorldMapHouse")

registerEvent("FromClient_HouseFilterOn",			"FromClient_HouseFilterOn")

--registerEvent("FromClient_OutWorldMapHouse",		"FromClient_OutWorldMapHouse")

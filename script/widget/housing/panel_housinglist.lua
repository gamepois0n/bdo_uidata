local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_HousingList:SetShow( false )
Panel_HousingList:setGlassBackground( true )
Panel_HousingList:ActiveMouseEventEffect( true )

Panel_HousingList:RegisterShowEventFunc( true, 'Panel_HousingList_ShowAni()' )
Panel_HousingList:RegisterShowEventFunc( false, 'Panel_HousingList_HideAni()' )

local isBeforeShow 				= false
local _naviCurrentInfo			= nil			-- 네비 체크 전달을 위한 변수

local HOUSE_CONTROL_COUNT 		= 9;

function Panel_HousingList_ShowAni()
	UIAni.fadeInSCR_Down( Panel_HousingList )
	
	local aniInfo1 = Panel_HousingList:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_HousingList:GetSizeX() / 2
	aniInfo1.AxisY = Panel_HousingList:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_HousingList:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_HousingList:GetSizeX() / 2
	aniInfo2.AxisY = Panel_HousingList:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_HousingList_HideAni()
	Panel_HousingList:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_HousingList, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local HousingList = {
	_Static_BG		= UI.getChildControl( Panel_HousingList,	"Static_BG" ),
	_Territory		= UI.getChildControl( Panel_HousingList,	"StaticText_Territory" ),
	_TownName		= UI.getChildControl( Panel_HousingList,	"StaticText_TownName" ),
	_Address		= UI.getChildControl( Panel_HousingList,	"StaticText_Address" ),
	_Navi			= UI.getChildControl( Panel_HousingList,	"Button_Navi" ),
	_btn_Close 		= UI.getChildControl( Panel_HousingList,	"Button_Close" ),
	_frame			= UI.getChildControl( Panel_HousingList,	"Frame_HousingList"),
	_housePos		= {}
}
HousingList.frameContent = UI.getChildControl( HousingList._frame,	"Frame_1_Content")
HousingList.frameScroll	 = UI.getChildControl ( HousingList._frame, "Frame_1_VerticalScroll" )
HousingList.frameScroll:SetIgnore(false);

--HousingList.frameContent:SetSize( HousingList._frame:GetSizeX(), HousingList._frame:GetSizeY() )
--_PA_LOG( "유흥신" , "HousingList.frameContent:SetSize" ..tostring( HousingList._frame:GetSizeX() ).. " " ..tostring( HousingList._frame:GetSizeY() ) )

function HousingList:Panel_HousingList_Initialize()
	
	self.frameContent:DestroyAllChild()

	self.listArray = {}
	
	HOUSE_CONTROL_COUNT =  ToClient_getMyDwellingCount();
	
	local guildHouseStaticStatusWrapper = ToClient_getMyGuildHouse()
	if( nil ~= guildHouseStaticStatusWrapper ) then
		HOUSE_CONTROL_COUNT = HOUSE_CONTROL_COUNT + 1
	end
	HOUSE_CONTROL_COUNT = HOUSE_CONTROL_COUNT + ToClient_getMyVillaCount() 
	
	for idx = 0 , HOUSE_CONTROL_COUNT do
		local listArr = {}
		listArr._Territory 	= UI.createAndCopyBasePropertyControl( Panel_HousingList, "StaticText_Territory",	self.frameContent,	"HousingList_StaticText_Territory_"	.. idx )
		listArr._TownName 	= UI.createAndCopyBasePropertyControl( Panel_HousingList, "StaticText_TownName",	self.frameContent,	"HousingList_StaticText_TownName_"	.. idx )
		listArr._Address 	= UI.createAndCopyBasePropertyControl( Panel_HousingList, "StaticText_Address",		self.frameContent,	"HousingList_StaticText_Address_"	.. idx )
		listArr._Navi 		= UI.createAndCopyBasePropertyControl( Panel_HousingList, "Button_Navi",			self.frameContent,	"HousingList_Button_Navi_"	.. idx )
	
		--[[
		listArr._Address:SetIgnore(false);
		listArr._Address	:addInputEvent( "Mouse_DownScroll",		"HousingList_ScrollEvent( true )")
		listArr._Address	:addInputEvent( "Mouse_UpScroll",		"HousingList_ScrollEvent( false )")
		--]]
		
		self.listArray[idx] = listArr
	end
	
	for idx = 0, #self.listArray do
		self.listArray[idx]._Territory:SetShow( false )
		self.listArray[idx]._TownName:SetShow( false )
		self.listArray[idx]._Address:SetShow( false )
		self.listArray[idx]._Navi:SetShow( false )
	end

	self.frameContent:SetIgnore(false);
	self.frameContent:addInputEvent( "Mouse_DownScroll",		"HousingList_ScrollEvent( true )")
	self.frameContent:addInputEvent( "Mouse_UpScroll",		"HousingList_ScrollEvent( false )")

	
	-- self.frameScroll:SetShow(true)
	self.frameScroll:SetControlTop()
	--self.frameScroll:SetInterval(3)
	
	self._frame:UpdateContentScroll()
	self._frame:UpdateContentPos()
end

function HousingList_ScrollEvent( isDown )
	
	local self = HousingList

	if( isDown ) then
		self.frameScroll:ControlButtonDown()
	else
		self.frameScroll:ControlButtonUp()
	end
	
	self._frame:UpdateContentScroll()	
end

function Panel_HousingList_Update()
	
	-- 컨트롤 새로 만들기
	HousingList:Panel_HousingList_Initialize()

	local self = HousingList
	local _myDwellingCount = ToClient_getMyDwellingCount()
	local _PosY = 0
	if 0 < _myDwellingCount then
		for idx = 0 , _myDwellingCount-1 do
			local characterStaticStatusWrapper = ToClient_getMyDwelling(idx)
			if nil ~= characterStaticStatusWrapper then
				if characterStaticStatusWrapper:getName() ~= nil then
					local houseX	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosX()
					local houseY	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosY()
					local houseZ	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosZ()
					local housePos	= float3(houseX, houseY, houseZ)
					self._housePos[idx]	= housePos
					local regionWrapper = ToClient_getRegionInfoWrapperByPosition(housePos)
					if idx ~= 0 then _PosY = (self._Territory:GetSizeY()+7)+_PosY end
					self.listArray[idx]._Territory:SetText(regionWrapper:getTerritoryName())
					self.listArray[idx]._Territory:SetPosX(13)
					self.listArray[idx]._Territory:SetPosY(_PosY)
					self.listArray[idx]._Territory:SetShow( true )
					self.listArray[idx]._TownName:SetText(regionWrapper:getAreaName())
					self.listArray[idx]._TownName:SetPosX(126)
					self.listArray[idx]._TownName:SetPosY(_PosY)
					self.listArray[idx]._TownName:SetShow( true )
					self.listArray[idx]._Address:SetText(characterStaticStatusWrapper:getName())
					self.listArray[idx]._Address:SetPosX(256)
					self.listArray[idx]._Address:SetPosY(_PosY)
					self.listArray[idx]._Address:SetShow( true )
					self.listArray[idx]._Navi:SetPosX(457)
					self.listArray[idx]._Navi:SetPosY(_PosY+2)
					self.listArray[idx]._Navi:SetShow( true )
					self.listArray[idx]._Navi:addInputEvent("Mouse_LUp", "_HousingListNavigatorStart(" .. idx .. ",".. _myDwellingCount ..")")
				end
			end
		end
	end

	-- 길드 하우스는 한채만 가질 수 있다.
	local idx = _myDwellingCount
	local guildHouseStaticStatusWrapper = ToClient_getMyGuildHouse()
	if( nil ~= guildHouseStaticStatusWrapper ) then
		if nil ~= guildHouseStaticStatusWrapper then
			if guildHouseStaticStatusWrapper:getName() ~= nil then
				local houseX	= guildHouseStaticStatusWrapper:getObjectStaticStatus():getHousePosX()
				local houseY	= guildHouseStaticStatusWrapper:getObjectStaticStatus():getHousePosY()
				local houseZ	= guildHouseStaticStatusWrapper:getObjectStaticStatus():getHousePosZ()
				local housePos	= float3(houseX, houseY, houseZ)
				self._housePos[idx]	= housePos
				local regionWrapper = ToClient_getRegionInfoWrapperByPosition(housePos)
				if idx ~= 0 then _PosY = (self._Territory:GetSizeY()+7)+_PosY end
				self.listArray[idx]._Territory:SetText(regionWrapper:getTerritoryName())
				self.listArray[idx]._Territory:SetPosX(13)
				self.listArray[idx]._Territory:SetPosY(_PosY)
				self.listArray[idx]._Territory:SetShow( true )
				self.listArray[idx]._TownName:SetText(regionWrapper:getAreaName())
				self.listArray[idx]._TownName:SetPosX(126)
				self.listArray[idx]._TownName:SetPosY(_PosY)
				self.listArray[idx]._TownName:SetShow( true )
				self.listArray[idx]._Address:SetText(guildHouseStaticStatusWrapper:getName())
				self.listArray[idx]._Address:SetPosX(256)
				self.listArray[idx]._Address:SetPosY(_PosY)
				self.listArray[idx]._Address:SetShow( true )
				self.listArray[idx]._Navi:SetPosX(457)
				self.listArray[idx]._Navi:SetPosY(_PosY+2)
				self.listArray[idx]._Navi:SetShow( true )
				self.listArray[idx]._Navi:addInputEvent("Mouse_LUp", "_HousingListNavigatorStart_GuildHouse(".. idx ..")" )
			end
		end
	end
	
	-- 다음 컨트롤 인덱스
	idx = idx + 1;
	
	-- 빌라는 여러채 가질 수 있다.
	local _myVillaCount = ToClient_getMyVillaCount()
	if 0 < _myVillaCount then
		for villaIdx = 0 , _myVillaCount-1 do
			local characterStaticStatusWrapper = ToClient_getMyVilla(villaIdx)
			if nil ~= characterStaticStatusWrapper then
				if characterStaticStatusWrapper:getName() ~= nil then
					local houseX	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosX()
					local houseY	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosY()
					local houseZ	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosZ()
					local housePos	= float3(houseX, houseY, houseZ)
					self._housePos[idx]	= housePos
					local regionWrapper = ToClient_getRegionInfoWrapperByPosition(housePos)
					if idx ~= 0 then _PosY = (self._Territory:GetSizeY()+7)+_PosY end
					self.listArray[idx]._Territory:SetText(regionWrapper:getTerritoryName())
					self.listArray[idx]._Territory:SetPosX(13)
					self.listArray[idx]._Territory:SetPosY(_PosY)
					self.listArray[idx]._Territory:SetShow( true )
					self.listArray[idx]._TownName:SetText(regionWrapper:getAreaName())
					self.listArray[idx]._TownName:SetPosX(126)
					self.listArray[idx]._TownName:SetPosY(_PosY)
					self.listArray[idx]._TownName:SetShow( true )
					self.listArray[idx]._Address:SetText(characterStaticStatusWrapper:getName())
					self.listArray[idx]._Address:SetPosX(256)
					self.listArray[idx]._Address:SetPosY(_PosY)
					self.listArray[idx]._Address:SetShow( true )
					self.listArray[idx]._Navi:SetPosX(457)
					self.listArray[idx]._Navi:SetPosY(_PosY+2)
					self.listArray[idx]._Navi:SetShow( true )
					self.listArray[idx]._Navi:addInputEvent("Mouse_LUp", "_HousingListNavigatorStart_Villa(" .. villaIdx ..")")
					idx = idx + 1
				end
			end
		end
	end
	
	if 6 < idx then
		self.frameScroll:SetShow( true )
	else
		self.frameScroll:SetShow( false )
	end
end

function _HousingListNavigatorStart(idx, _myDwellingCount)
	local self = HousingList
	ToClient_DeleteNaviGuideByGroup(0);
	
	for ii = 0, HOUSE_CONTROL_COUNT do
		self.listArray[ii]._Navi:SetCheck(false)
	end
	
	if _naviCurrentInfo ~= idx then
		local navigationGuideParam	= NavigationGuideParam()
		navigationGuideParam._isAutoErase = true
		worldmapNavigatorStart( HousingList._housePos[idx], navigationGuideParam, false, false, true)
		self.listArray[idx]._Navi:SetCheck(true)
		_naviCurrentInfo = idx
	else
		_naviCurrentInfo = nil
	end
end

function _HousingListNavigatorStart_GuildHouse( ctrlIndex )
	local self = HousingList
	ToClient_DeleteNaviGuideByGroup(0);
	
	for ii = 0, HOUSE_CONTROL_COUNT do
		self.listArray[ii]._Navi:SetCheck(false)
	end
	
	if _naviCurrentInfo ~= ctrlIndex then
		local navigationGuideParam	= NavigationGuideParam()
		navigationGuideParam._isAutoErase = true
		worldmapNavigatorStart( HousingList._housePos[ctrlIndex], navigationGuideParam, false, false, true)
		self.listArray[ctrlIndex]._Navi:SetCheck(true)
		_naviCurrentInfo = ctrlIndex
	else
		_naviCurrentInfo = nil
	end
end

function _HousingListNavigatorStart_Villa(ctrlIndex)
	local self = HousingList
	ToClient_DeleteNaviGuideByGroup(0);
	
	for ii = 0, HOUSE_CONTROL_COUNT do
		self.listArray[ii]._Navi:SetCheck(false)
	end
	
	if _naviCurrentInfo ~= ctrlIndex then
		local navigationGuideParam	= NavigationGuideParam()
		navigationGuideParam._isAutoErase = true
		worldmapNavigatorStart( HousingList._housePos[ctrlIndex], navigationGuideParam, false, false, true)
		self.listArray[ctrlIndex]._Navi:SetCheck(true)
		_naviCurrentInfo = ctrlIndex
	else
		_naviCurrentInfo = nil
	end
end
------------------------------------------------------------
--						오픈
------------------------------------------------------------
function FGlobal_HousingList_Open()
	-- ♬ 창이 켜질 때 소리
	audioPostEvent_SystemUi(13,06)

	-- Panel_HousingList:SetPosX( (getScreenSizeX()/2) - (Panel_HousingList:GetSizeX()/2) )
	-- Panel_HousingList:SetPosY( (getScreenSizeY()/2) - (Panel_HousingList:GetSizeY()/2) )
	Panel_HousingList_Update()
	Panel_HousingList:SetShow( true, true )
end

function HousingList_Close()
	-- ♬ 창이 꺼질 때 소리
	audioPostEvent_SystemUi(13,05)
	Panel_HousingList:SetShow( false, false )
end

function HandleClicked_HousingList_Close()
	HousingList_Close()
end


function HousingList:registEventHandler()
	self._btn_Close		:addInputEvent( "Mouse_LUp", "HandleClicked_HousingList_Close()" )
end

UI.addRunPostRestorFunction(Panel_HousingList_Update)
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--HousingList:Panel_HousingList_Initialize()
HousingList:registEventHandler()
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local isharvestManagement = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 72 )
Panel_HarvestList:SetShow( false )
Panel_HarvestList:setGlassBackground( true )
Panel_HarvestList:ActiveMouseEventEffect( true )

Panel_HarvestList:RegisterShowEventFunc( true, 'Panel_HarvestList_ShowAni()' )
Panel_HarvestList:RegisterShowEventFunc( false, 'Panel_HarvestList_HideAni()' )

local isBeforeShow 				= false
local _naviCurrentInfo			= nil			-- 네비 체크 전달을 위한 변수

local maxTentCount 		= 10

function Panel_HarvestList_ShowAni()
	UIAni.fadeInSCR_Down( Panel_HarvestList )
	
	local aniInfo1 = Panel_HarvestList:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_HarvestList:GetSizeX() / 2
	aniInfo1.AxisY = Panel_HarvestList:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_HarvestList:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_HarvestList:GetSizeX() / 2
	aniInfo2.AxisY = Panel_HarvestList:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_HarvestList_HideAni()
	Panel_HarvestList:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_HarvestList, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local HarvestList = {
	_Static_BG		= UI.getChildControl( Panel_HarvestList,	"Static_BG" ),
	_Territory		= UI.getChildControl( Panel_HarvestList,	"StaticText_Territory" ),
	_TownName		= UI.getChildControl( Panel_HarvestList,	"StaticText_TownName" ),
	_Address		= UI.getChildControl( Panel_HarvestList,	"StaticText_Address" ),
	_doWork			= UI.getChildControl( Panel_HarvestList,	"Button_doWork" ),
	_Navi			= UI.getChildControl( Panel_HarvestList,	"Button_Navi" ),
	_btn_Close 		= UI.getChildControl( Panel_HarvestList,	"Button_Close" ),
	_frame			= UI.getChildControl( Panel_HarvestList,	"Frame_HarvestList"),
	_tentPos		= {}
}
HarvestList.frameContent = UI.getChildControl( HarvestList._frame,	"Frame_1_Content")
HarvestList.frameScroll	 = UI.getChildControl ( HarvestList._frame, "Frame_1_VerticalScroll" )
HarvestList.frameScroll:SetIgnore(false);

function HarvestList:Panel_HarvestList_Initialize()
	
	self.frameContent:DestroyAllChild()

	self.listArray = {}
	
	for idx = 0 , maxTentCount-1 do
		local listArr = {}
		listArr._Territory 	= UI.createAndCopyBasePropertyControl( Panel_HarvestList, "StaticText_Territory",	self.frameContent,	"HarvestList_StaticText_Territory_"	.. idx )
		listArr._TownName 	= UI.createAndCopyBasePropertyControl( Panel_HarvestList, "StaticText_TownName",	self.frameContent,	"HarvestList_StaticText_TownName_"	.. idx )
		listArr._Address 	= UI.createAndCopyBasePropertyControl( Panel_HarvestList, "StaticText_Address",		self.frameContent,	"HarvestList_StaticText_Address_"	.. idx )
		listArr._doWork		= UI.createAndCopyBasePropertyControl( Panel_HarvestList, "Button_doWork",			self.frameContent,	"HarvestList_Button_doWork_"	.. idx )
		listArr._Navi 		= UI.createAndCopyBasePropertyControl( Panel_HarvestList, "Button_Navi",			self.frameContent,	"HarvestList_Button_Navi_"	.. idx )
	
		self.listArray[idx] = listArr
	end
	
	for idx = 0, #self.listArray do
		self.listArray[idx]._Territory:SetShow( false )
		self.listArray[idx]._TownName:SetShow( false )
		self.listArray[idx]._Address:SetShow( false )
		self.listArray[idx]._doWork:SetShow( false )
		self.listArray[idx]._Navi:SetShow( false )
	end

	self.frameContent:SetIgnore(false);
	self.frameContent:addInputEvent( "Mouse_DownScroll",		"HarvestList_ScrollEvent( true )")
	self.frameContent:addInputEvent( "Mouse_UpScroll",		"HarvestList_ScrollEvent( false )")

	
	self.frameScroll:SetControlTop()
	self._frame:UpdateContentScroll()
	self._frame:UpdateContentPos()
end

function HarvestList_ScrollEvent( isDown )
	
	local self = HarvestList

	if( isDown ) then
		self.frameScroll:ControlButtonDown()
	else
		self.frameScroll:ControlButtonUp()
	end
	
	self._frame:UpdateContentScroll()	
end

function Panel_HarvestList_Update()
	
	-- 컨트롤 새로 만들기
	HarvestList:Panel_HarvestList_Initialize()

	local self = HarvestList
	local temporaryWrapper = getTemporaryInformationWrapper()
	local myTentCount = temporaryWrapper:getSelfTentCount()	
	local _PosY = 0
	if 0 < myTentCount then
		for idx = 0, myTentCount - 1 do
			local householdDataWithInstallationWrapper = temporaryWrapper:getSelfTentWrapperByIndex( idx )
			local characterStaticStatusWrapper = householdDataWithInstallationWrapper:getHouseholdCharacterStaticStatusWrapper()
			if nil ~= characterStaticStatusWrapper then
				if characterStaticStatusWrapper:getName() ~= nil then
					local tentWrapper = temporaryWrapper:getSelfTentWrapperByIndex( idx )
					local tentPosX	= tentWrapper:getSelfTentPositionX()
					local tentPosY	= tentWrapper:getSelfTentPositionY()
					local tentPosZ	= tentWrapper:getSelfTentPositionZ()
					local tentPos	= float3(tentPosX, tentPosY, tentPosZ)				
					self._tentPos[idx]	= tentPos
					local regionWrapper = ToClient_getRegionInfoWrapperByPosition(tentPos)
					if idx ~= 0 then _PosY = (self._Territory:GetSizeY()+7)+_PosY end
					self.listArray[idx]._Territory:SetText(regionWrapper:getTerritoryName())
					self.listArray[idx]._Territory:SetPosX(25)
					self.listArray[idx]._Territory:SetPosY(_PosY)
					self.listArray[idx]._Territory:SetShow( true )
					self.listArray[idx]._TownName:SetText(regionWrapper:getAreaName())
					self.listArray[idx]._TownName:SetPosX(195)
					self.listArray[idx]._TownName:SetPosY(_PosY)
					self.listArray[idx]._TownName:SetShow( true )
					self.listArray[idx]._Address:SetText(characterStaticStatusWrapper:getName())
					self.listArray[idx]._Address:SetPosX(410)
					self.listArray[idx]._Address:SetPosY(_PosY)
					self.listArray[idx]._Address:SetShow( true )
					self.listArray[idx]._Navi:SetPosX(635)
					self.listArray[idx]._Navi:SetPosY(_PosY+2)
					self.listArray[idx]._Navi:SetShow( true )
					self.listArray[idx]._Navi:addInputEvent("Mouse_LUp", "_HarvestListNavigatorStart(" .. idx .. ")")
					self.listArray[idx]._doWork:SetPosX(555)
					self.listArray[idx]._doWork:SetPosY(_PosY)
					self.listArray[idx]._doWork:SetShow( true )
					
					local isShow = isWorkeOnHarvest( householdDataWithInstallationWrapper )
					if (isShow) then
						self.listArray[idx]._doWork:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HARVESTLIST_BTNWORKING"))	-- "<PAColor0xfff26a6a>작업중<PAOldColor>" )
						self.listArray[idx]._doWork:SetIgnore( true )
						self.listArray[idx]._doWork:addInputEvent("Mouse_LUp", "" )
					else
						self.listArray[idx]._doWork:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HARVESTLIST_BTNWORKERLIST"))	-- "<PAColor0xffefefef>목록<PAOldColor>" )
						self.listArray[idx]._doWork:SetIgnore( false )
						self.listArray[idx]._doWork:addInputEvent("Mouse_LUp", "HarvestList_WorkManager_Open(" .. idx .. ")")
					end
				end
			end
		end
	end
end

function isWorkeOnHarvest( hhWrapper )
	local houseHoldNo = hhWrapper:getHouseholdNo()
	if ToClient_hasWorkerWorkingInHarvest( houseHoldNo ) then
		return true
	end
	return false
end

function _HarvestListNavigatorStart(idx, myTentCount)
	local self = HarvestList
	ToClient_DeleteNaviGuideByGroup(0);
	
	for ii = 0, maxTentCount - 1 do
		self.listArray[ii]._Navi:SetCheck(false)
	end
	
	if _naviCurrentInfo ~= idx then
		local navigationGuideParam	= NavigationGuideParam()
		navigationGuideParam._isAutoErase = true
		worldmapNavigatorStart( HarvestList._tentPos[idx], navigationGuideParam, false, false, true)
		self.listArray[idx]._Navi:SetCheck(true)
		_naviCurrentInfo = idx
	else
		_naviCurrentInfo = nil
	end
end

function HarvestList_WorkManager_Open( index )
	FGlobal_Harvest_WorkManager_Open( index )
end

------------------------------------------------------------
--						오픈
------------------------------------------------------------
function FGlobal_HarvestList_Open()
	if not isharvestManagement then
		return
	end
	-- ♬ 창이 켜질 때 소리
	audioPostEvent_SystemUi(13,06)

	-- Panel_HarvestList:SetPosX( (getScreenSizeX()/2) - (Panel_HarvestList:GetSizeX()/2) )
	-- Panel_HarvestList:SetPosY( (getScreenSizeY()/2) - (Panel_HarvestList:GetSizeY()/2) )
	Panel_HarvestList_Update()
	Panel_HarvestList:SetShow( true, true )
end

function HarvestList_Close()
	-- ♬ 창이 꺼질 때 소리
	audioPostEvent_SystemUi(13,05)
	Panel_HarvestList:SetShow( false, false )
end

function HandleClicked_HarvestList_Close()
	HarvestList_Close()
end

function FGlobal_HarvestList_Update()
	Panel_HarvestList_Update()
end

function HarvestList:registEventHandler()
	self._btn_Close		:addInputEvent( "Mouse_LUp", "HandleClicked_HarvestList_Close()" )
end

UI.addRunPostRestorFunction(Panel_HarvestList_Update)
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--HarvestList:Panel_HarvestList_Initialize()
HarvestList:registEventHandler()
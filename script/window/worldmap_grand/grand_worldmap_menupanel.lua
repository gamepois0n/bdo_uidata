-- 월드맵에 관한 전체적인 처리는 이곳에서 한다.
-- 월드맵이 열려 있는 동안 항상 떠있는 패널이기 때문.
local UI_color			= Defines.Color

local ServantStable_Btn	= UI.getChildControl( Panel_WorldMap, "BottomMenu_ServantStable" )
local WareHouse_Btn		= UI.getChildControl( Panel_WorldMap, "BottomMenu_WareHouse" )
local Quest_Btn			= UI.getChildControl( Panel_WorldMap, "BottomMenu_Quest" )
local Transport_Btn		= UI.getChildControl( Panel_WorldMap, "BottomMenu_Transport" )
local ItemMarket_Btn	= UI.getChildControl( Panel_WorldMap, "BottomMenu_ItemMarket" )
local WorkerList_Btn	= UI.getChildControl( Panel_WorldMap, "BottomMenu_WorkerList" )
local HelpMenu_Btn		= UI.getChildControl( Panel_WorldMap, "BottomMenu_HelpMovie" )
local Exit_Btn			= UI.getChildControl( Panel_WorldMap, "BottomMenu_Exit" )

local currentNodeKey	= nil

local popupType = {
	stable		= 0,
	wareHouse	= 1,
	quest		= 2,
	transport	= 3,
	itemMarket	= 4,
	workerList	= 5,
	helpMovie	= 6,
}
local popupTypeCount = 7	-- 늘어나면 수정해야 한다.
local popupPanelList = {}	-- 열릴 때 생성한다.

Panel_WorldMap:SetShow(false, false);

local worldMap_Init = function()
	Exit_Btn			:SetSize( 44, 44 )
	HelpMenu_Btn		:SetSize( 44, 44 )
	WorkerList_Btn		:SetSize( 44, 44 )
	ItemMarket_Btn		:SetSize( 44, 44 )
	Transport_Btn		:SetSize( 44, 44 )
	Quest_Btn			:SetSize( 44, 44 )
	WareHouse_Btn		:SetSize( 44, 44 )
	ServantStable_Btn	:SetSize( 44, 44 )

	Exit_Btn			:SetSpanSize( 5, 5 )
	HelpMenu_Btn		:SetSpanSize( Exit_Btn:GetSpanSize().x			+ Exit_Btn:GetSizeX()		+ 3, 5 )
	WorkerList_Btn		:SetSpanSize( HelpMenu_Btn:GetSpanSize().x		+ HelpMenu_Btn:GetSizeX()	+ 3, 5 )
	ItemMarket_Btn		:SetSpanSize( WorkerList_Btn:GetSpanSize().x	+ WorkerList_Btn:GetSizeX()	+ 3, 5 )
	Transport_Btn		:SetSpanSize( ItemMarket_Btn:GetSpanSize().x	+ ItemMarket_Btn:GetSizeX()	+ 3, 5 )
	Quest_Btn			:SetSpanSize( Transport_Btn:GetSpanSize().x		+ Transport_Btn:GetSizeX()	+ 3, 5 )
	WareHouse_Btn		:SetSpanSize( Quest_Btn:GetSpanSize().x			+ Quest_Btn:GetSizeX()		+ 3, 5 )
	ServantStable_Btn	:SetSpanSize( WareHouse_Btn:GetSpanSize().x		+ WareHouse_Btn:GetSizeX()	+ 3, 5 )

	-- 버튼 이벤트 바인드
	ServantStable_Btn	:addInputEvent( "Mouse_LUp",	"BtnEvent_ServantStable()"	)
	WareHouse_Btn		:addInputEvent(	"Mouse_LUp", 	"BtnEvent_WareHouse()"		)
	Quest_Btn			:addInputEvent(	"Mouse_LUp", 	"BtnEvent_Quest()"			)
	Transport_Btn		:addInputEvent( "Mouse_LUp", 	"BtnEvent_Transport()"		)
	ItemMarket_Btn		:addInputEvent( "Mouse_LUp", 	"BtnEvent_ItemMarket()"		)
	WorkerList_Btn		:addInputEvent( "Mouse_LUp", 	"BtnEvent_WorkerList()"		)
	HelpMenu_Btn		:addInputEvent( "Mouse_LUp", 	"BtnEvent_HelpMovie()"		)
	Exit_Btn			:addInputEvent( "Mouse_LUp",	"BtnEvent_Exit()"			)

	ServantStable_Btn	:addInputEvent( "Mouse_On",		"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 0 .. " )"	)
	ServantStable_Btn	:addInputEvent( "Mouse_Out",	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 0 .. " )"	)
	ServantStable_Btn	:setTooltipEventRegistFunc( 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 0 .. " )"	)

	WareHouse_Btn		:addInputEvent(	"Mouse_On", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 1 .. " )"	)
	WareHouse_Btn		:addInputEvent(	"Mouse_Out", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 1 .. " )"	)
	WareHouse_Btn		:setTooltipEventRegistFunc( 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 1 .. " )"	)

	Quest_Btn			:addInputEvent(	"Mouse_On", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 2 .. " )"	)
	Quest_Btn			:addInputEvent(	"Mouse_Out", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 2 .. " )"	)
	Quest_Btn			:setTooltipEventRegistFunc( 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 2 .. " )"	)

	Transport_Btn		:addInputEvent( "Mouse_On", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 3 .. " )"	)
	Transport_Btn		:addInputEvent( "Mouse_Out", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 3 .. " )"	)
	Transport_Btn		:setTooltipEventRegistFunc( 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 3 .. " )"	)

	ItemMarket_Btn		:addInputEvent( "Mouse_On", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 4 .. " )"	)
	ItemMarket_Btn		:addInputEvent( "Mouse_Out", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 4 .. " )"	)
	ItemMarket_Btn		:setTooltipEventRegistFunc( 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 4 .. " )"	)

	WorkerList_Btn		:addInputEvent( "Mouse_On", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 5 .. " )"	)
	WorkerList_Btn		:addInputEvent( "Mouse_Out", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 5 .. " )"	)
	WorkerList_Btn		:setTooltipEventRegistFunc( 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 5 .. " )"	)

	HelpMenu_Btn		:addInputEvent( "Mouse_On", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 6 .. " )"	)
	HelpMenu_Btn		:addInputEvent( "Mouse_Out", 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 6 .. " )"	)
	HelpMenu_Btn		:setTooltipEventRegistFunc( 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 6 .. " )"	)

	Exit_Btn			:addInputEvent( "Mouse_On",		"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 7 .. " )"	)
	Exit_Btn			:addInputEvent( "Mouse_Out",	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( false, " .. 7 .. " )"	)
	Exit_Btn			:setTooltipEventRegistFunc( 	"HandleOnOut_WorldmapGrand_MenuButtonTooltip( true, " .. 7 .. " )"	)
end

function GrandWorldMap_CheckPopup( openPanel )
	for idx = 0, popupTypeCount -1 do
		if openPanel ~= idx then								-- 입력 받은 창이 아니다.
			if popupPanelList[idx].panelname:GetShow() then		-- 켜 있으면
				popupPanelList[idx].closeFunc()					-- 끈다.
			end
		end
	end
end

-- 버튼 이벤트 함수
function BtnEvent_ServantStable()	-- 축사 열기
	if not Panel_NodeStable:GetShow() then
		if nil ~= currentNodeKey then
			GrandWorldMap_CheckPopup( popupType.stable )
			StableOpen_FromWorldMap( currentNodeKey )
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_WRONG_STABLE") )	-- "축사가 있는 마을에서만 열 수 있습니다."
			return
		end
	else
		StableClose_FromWorldMap()
	end
end

function BtnEvent_WareHouse()		-- 창고 열기
	if Panel_Window_Warehouse:GetShow() then
		Warehouse_Close()
	else
		if nil ~= currentNodeKey then
			GrandWorldMap_CheckPopup( popupType.wareHouse )
			Warehouse_OpenPanelFromWorldmap(currentNodeKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap )	
		end
	end
end

function BtnEvent_Quest()			-- 의뢰 위젯 열기
	if Panel_CheckedQuest:GetShow() then
		FGlobal_QuestWidget_Close()
	else
		GrandWorldMap_CheckPopup( popupType.quest )
		FGlobal_QuestWidget_Open()
	end
end

function BtnEvent_Transport()		-- 수송 열기
	if(Panel_Window_Delivery_InformationView:GetShow() ) then
		DeliveryInformationView_Close()
	else
		GrandWorldMap_CheckPopup( popupType.transport )
		DeliveryInformationView_Open()
	end
end

function BtnEvent_ItemMarket()		-- 아이템 거래소 열기
	if(	Panel_Window_ItemMarket:GetShow() ) then
		FGolbal_ItemMarket_Close()
	else
		GrandWorldMap_CheckPopup( popupType.itemMarket )
		FGlobal_ItemMarket_Open_ForWorldMap(1)
	end
end

function BtnEvent_WorkerList()		-- 일꾼 목록 열기
	if Panel_WorkerManager:GetShow() then
		workerManager_Close()
	else
		GrandWorldMap_CheckPopup( popupType.workerList )
		if nil ~= currentNodeKey then
			FGlobal_workerManager_UpdateNode( ToClient_convertWaypointKeyToPlantKey(currentNodeKey) )
		else
			FGlobal_workerManager_OpenWorldMap()
		end
	end
end

function BtnEvent_HelpMovie()		-- 도움 영상 열기
	if ( true == Panel_WorldMap_MovieGuide:GetShow() ) then
		Panel_Worldmap_MovieGuide_Close()
	else
		GrandWorldMap_CheckPopup( popupType.helpMovie )
		Panel_Worldmap_MovieGuide_Open()
	end
end

function BtnEvent_Exit()			-- 끄기
	FGlobal_CloseWorldmapForLuaKeyHandling()
end

local makePopupPanelList = function()
	popupPanelList = {
		[popupType.stable]			= { panelname = Panel_NodeStable,						closeFunc = StableClose_FromWorldMap },
		[popupType.wareHouse]		= { panelname = Panel_Window_Warehouse,					closeFunc = Warehouse_Close },
		[popupType.quest]			= { panelname = Panel_CheckedQuest,						closeFunc = FGlobal_QuestWidget_Close },
		[popupType.transport]		= { panelname = Panel_Window_Delivery_InformationView,	closeFunc = DeliveryInformationView_Close },
		[popupType.itemMarket]		= { panelname = Panel_Window_ItemMarket,				closeFunc = FGolbal_ItemMarket_Close },
		[popupType.workerList]		= { panelname = Panel_WorkerManager,					closeFunc = workerManager_Close },
		[popupType.helpMovie]		= { panelname = Panel_WorldMap_MovieGuide,				closeFunc = Panel_Worldmap_MovieGuide_Close },
	}
end

--------------------------------------------------------------------------------------------------------------------------
function FGlobal_WorldMapOpenForMenu()
	ServantStable_Btn	:SetShow(true,false)
	WareHouse_Btn		:SetShow(true,false)
	Quest_Btn			:SetShow(true,false)
	Transport_Btn		:SetShow(true,false)
	ItemMarket_Btn		:SetShow(true,false)
	WorkerList_Btn		:SetShow(true,false)
	HelpMenu_Btn		:SetShow(true,false)
	Exit_Btn			:SetShow(true,false)
	makePopupPanelList()
	Panel_WorldMap:SetShow(true, false);
	Panel_Worldmap_MovieGuide_Init()
end

function WorldmapGrand_setAlpha( boolValue )
	local returnValue = ""
	if true == boolValue then
		returnValue = 1
	else
		returnValue = 0.7
	end
	return returnValue
end

function HandleOnOut_WorldmapGrand_MenuButtonTooltip( isShow, buttonType )
	if isShow then
		local control	= nil
		local name		= ""
		local desc		= nil
		if 0 == buttonType then
			control = ServantStable_Btn
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_MENUBUTTONTOOLTIP_STABLE")	-- "축사"
		elseif 1 == buttonType then
			control = WareHouse_Btn
			name	= PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_WAREHOUSE")	-- "창고"
		elseif 2 == buttonType then
			control = Quest_Btn
			name	= PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST")	-- "의뢰"
		elseif 3 == buttonType then
			control = Transport_Btn
			name	= PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_DELIVERY")	-- 수송 현황"
		elseif 4 == buttonType then
			control = ItemMarket_Btn
			name	= PAGetString(Defines.StringSheet_GAME, "GAME_ITEM_MARKET_NAME")	-- 아이템 거래소"
		elseif 5 == buttonType then
			control = WorkerList_Btn
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_WORKERTITLE")	-- 일꾼 목록"
		elseif 6 == buttonType then
			control = HelpMenu_Btn
			name	= PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_MENUBUTTONTOOLTIP_HELPMOVIE")	-- 영상 도움말"
		elseif 7 == buttonType then
			control = Exit_Btn
			name	= PAGetString(Defines.StringSheet_RESOURCE, "UICONTROL_BTN_GAMEEXIT")	-- "나가기"
		end
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function FGlobal_WorldmapGrand_Bottom_MenuSet( waypointKey )	-- 하단 메뉴 세팅
	if nil ~= waypointKey then	-- 타운모드다.
		currentNodeKey			= waypointKey
		local isStableOpen		= false
		local isWareHouseOpen	= false
		local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint( waypointKey )
		if nil ~= regionInfoWrapper then
			isStableOpen	= regionInfoWrapper:get():hasStableNpc()	-- StableOpen_FromWorldMap( _townModeWaypointKey )
			isWareHouseOpen	= regionInfoWrapper:get():hasWareHouseNpc()	-- Warehouse_OpenPanelFromWorldmap(nodeKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap )
		end
		
		ServantStable_Btn	:SetAlpha( WorldmapGrand_setAlpha(isStableOpen) )
		ServantStable_Btn	:SetIgnore( not isStableOpen )
		WareHouse_Btn		:SetAlpha( WorldmapGrand_setAlpha(isWareHouseOpen) )
		WareHouse_Btn		:SetIgnore( not isWareHouseOpen )
	else
		currentNodeKey		= nil
		ServantStable_Btn	:SetAlpha( WorldmapGrand_setAlpha(false) )
		ServantStable_Btn	:SetIgnore( true )
		WareHouse_Btn		:SetAlpha( WorldmapGrand_setAlpha(false) )
		WareHouse_Btn		:SetIgnore( true )
	end
	-- Transport_Btn		:	-- 항상 켜있는다.
	-- ItemMarket_Btn		:	-- 항상 켜있는다.
	-- WorkerList_Btn		:	-- 항상 켜있는다.
	-- HelpMenu_Btn		:	-- 항상 켜있는다.
	-- Exit_Btn			:	-- 항상 켜있는다.
end

function worldmapGrand_Base_OnScreenResize()
	Panel_WorldMap:SetSize( getScreenSizeX(), getScreenSizeY() )
	ServantStable_Btn	:ComputePos()
	WareHouse_Btn		:ComputePos()
	Quest_Btn			:ComputePos()
	Transport_Btn		:ComputePos()
	ItemMarket_Btn		:ComputePos()
	WorkerList_Btn		:ComputePos()
	HelpMenu_Btn		:ComputePos()
	Exit_Btn			:ComputePos()
end

worldMap_Init()
registerEvent( "onScreenResize", "worldmapGrand_Base_OnScreenResize" )
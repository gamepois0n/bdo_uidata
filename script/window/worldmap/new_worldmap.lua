local IM 			= CppEnums.EProcessorInputMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local ENT 			= CppEnums.ExplorationNodeType
local UI_color 		= Defines.Color
local UI_TYPE		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM 		= CppEnums.TextMode
local VCK 			= CppEnums.VirtualKeyCode

local isCloseWorldMap 			= false
local isOpenWorldMapWithHouse	= false	-- 축사창 열림 방지 변수(집 구매시, ...)

function isWorldMapGrandOpen()
	return false
end

if nil == WorldMapWindow then
	WorldMapWindow = {};
end

WorldMapWindow.EnumInfoNodeKeyType = {
	eInfoNodeKeyType_Waypoint 			= 0;
	eInfoNodeKeyType_HouseListIdx		= 1;
	eInfoNodeKeyType_Region				= 2;
	eInfoNodeKeyType_FixedHouseListIdx 	= 3;
};
ToClient_WorldmapRegisterShowEventFunc(true,	"FGlobal_WorldmapShowAni()")
ToClient_WorldmapRegisterShowEventFunc(false,	"FGlobal_WorldmapHideAni()")
------------------------------------------------------------
--				월드맵 켤 때 애니메이션
------------------------------------------------------------
function FGlobal_WorldmapShowAni()
	local worldmapRenderUI = ToClient_getWorldmapRenderBase();
	worldmapRenderUI:ResetVertexAni();
	ToClient_WorldmapSetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
	local aniInfo = worldmapRenderUI:addColorAnimation( 0.0, 1.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = false
	ToClient_WorldmapSetAlpha(0)
	audioPostEvent_SystemUi(01,02)
end

------------------------------------------------------------
--				월드맵 끌 때 애니메이션
------------------------------------------------------------
function FGlobal_WorldmapHideAni()
	local worldmapRenderUI = ToClient_getWorldmapRenderBase();
	worldmapRenderUI:ResetVertexAni();
	ToClient_WorldmapSetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)

	local aniInfo = worldmapRenderUI:addColorAnimation( 0.0, 1.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo.IsChangeChild = false
	aniInfo:SetHideAtEnd(true)
	aniInfo:SetDisableWhileAni(true)
	ToClient_WorldmapSetAlpha(0)
	audioPostEvent_SystemUi(01,03)
end

local SelectedNode = nil

function FGlobal_SelectedNode()
	return SelectedNode;
end

function FromClient_RClickWorldmapPanel( pos3D, immediately, isTopPicking )
	if( false == immediately ) then
		if (ToClient_IsShowNaviGuideGroup(0)) then
			if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
				if getSelfPlayer():get():getLevel() < 11 then
					Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TUTORIAL_ACK") ) -- "튜토리얼 진행 중에는 네비게이션을 임의로 바꾸거나 설정할 수 없습니다." )
					return
				end
			end

			if( isKeyPressed( VCK.KeyCode_MENU ) ) then
				ToClient_WorldMapNaviStart( pos3D, NavigationGuideParam(), false, isTopPicking )
			else
				ToClient_DeleteNaviGuideByGroup(0);
			end
			return;
		end
	end

	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
		if getSelfPlayer():get():getLevel() < 11 then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_TUTORIAL_ACK") ) -- "튜토리얼 진행 중에는 네비게이션을 임의로 바꾸거나 설정할 수 없습니다." )
			return
		end
	end

	if( false == isKeyPressed( VCK.KeyCode_MENU ) ) then
		ToClient_DeleteNaviGuideByGroup(0);
	end
	ToClient_WorldMapNaviStart( pos3D, NavigationGuideParam(), false, isTopPicking )
	audioPostEvent_SystemUi(00,14)
end

function FromClient_LClickedWorldMapNode(explorationNode)
	--SelectedNode = explorationNode:FromClient_getExplorationNodeInClient()
	
	--UpdateWorldMapNode( SelectedNode )

	--FGlobal_WarInfo_Close()
	--FGlobal_NodeWarInfo_Close()
end

function FromClient_KnowledgeWorldMapPath( pos3D )
	local navParam = NavigationGuideParam();
	navParam._worldmapColor		= float4( 1.0, 0.55, 0.55, 0.55 );
	navParam._worldmapBgColor	= float4( 1.0, 0.85, 0.85, 0.6 );
	
	ToClient_DeleteNaviGuideByGroup(0);
	ToClient_WorldMapNaviStart( pos3D, navParam, false, true )
	
	audioPostEvent_SystemUi(00,14)
end

function UpdateWorldMapNode(node)
	--local node = explorationNode:FromClient_getExplorationNodeInClient()
	local plantKey = node:getPlantKey()
	local nodeKey = plantKey:getWaypointKey()
	local wayPlant = ToClient_getPlant(plantKey)
	local exploreLevel		= node:getLevel()
	local affiliatedTownKey = 0	

	local nodeSSW = node:getStaticStatus()
	local regionInfo = nodeSSW:getMinorSiegeRegion()

	--이거 쓰지마세요
	--getSelfPlayer():get():getWorldMapHouseLineWrapper():open()
	--getSelfPlayer():get():getWorldMapHouseLineWrapper():updateColor()
	
	--------------------------------------------------------------------------
	--------------- 마을 Node인 경우 창고와 일꾼 관리창을 연다 ---------------
	--------------------------------------------------------------------------	
	if ( nil ~= wayPlant) then
		affiliatedTownKey = ToClinet_getPlantAffiliatedWaypointKey(wayPlant)
	end

	FGlobal_FilterClear()
	FGlobal_ShowInfoNodeMenuPanel( node )

	WorldMapPopupManager:increaseLayer()
	WorldMapPopupManager:push( Panel_NodeMenu, true )

	if nil ~= regionInfo then
		WorldMapPopupManager:push( Panel_NodeGuildWarMenu, true )
	end

	FGlobal_OpenOtherPanelWithNodeMenu(node, true)
	NodeMenu_ShowToggle( true )
end

function FGlobal_OpenOtherPanelWithNodeMenu( node, isShow )
	if ( false == ToClient_WorldMapIsShow() ) then
		return
	end

	if ( true ~= isShow ) then
		return
	end
	
	if ( false == Panel_NodeMenu:IsShow() ) then
		return
	end
	
	local plantKey = node:getPlantKey()
	local nodeKey = plantKey:getWaypointKey()
	local wayPlant = ToClient_getPlant(plantKey)
	local exploreLevel		= node:getLevel()

	if exploreLevel > 0 and wayPlant ~= nil then	
		if	wayPlant:getType() == CppEnums.PlantType.ePlantType_Zone then	
			local workingcnt = ToClient_getPlantWorkingList( plantKey )
			if 0 == workingcnt then														-- 작업 중인 일꾼이 0일 때만, 작업 관리 창을 열어준다.				
				local _plantKey 	= node:getPlantKey()
				local nod_Key 		= _plantKey:get()
                local explorationSSW = ToClient_getExplorationStaticStatusWrapper(nod_Key)
				if ( explorationSSW:get():isFinance() ) then
					FGlobal_Finance_WorkManager_Reset_Pos()
					FGlobal_Finance_WorkManager_Open(node)	-- 자산 관리
				else
					FGlobal_Plant_WorkManager_Reset_Pos()
					FGlobal_Plant_WorkManager_Open(node) -- 작업 관리				
				end
			elseif 1 == workingcnt then
				FGlobal_ShowWorkingProgress(node, 1)
				
			end				
		end
	end
end

function FromClient_WorldMapNodeFindNearNode(nodeKey)
	ToClient_DeleteNaviGuideByGroup(0);
		
	ToClient_WorldMapFindNearNode( nodeKey, NavigationGuideParam() )

	audioPostEvent_SystemUi(00,14)
end

function FromClient_WorldMapNodeFindTargetNode(nodeKey)
	local explorationSSW = ToClient_getExplorationStaticStatusWrapper(nodeKey)
	if ( nil == explorationSSW ) then
		return
	end
	ToClient_DeleteNaviGuideByGroup(0);
	ToClient_WorldMapNaviStart( explorationSSW:get():getPosition(), NavigationGuideParam(), false, false )
	audioPostEvent_SystemUi(00,14)
end

function FGlobal_LoadWorldMapTownSideWindow(nodeKey)
 	local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint( nodeKey )
	if ( nil ~= regionInfoWrapper ) and ( regionInfoWrapper:get():isMainOrMinorTown() ) then
		if ( regionInfoWrapper:get():hasWareHouseNpc() ) then
			-- 창고를 연다
			Warehouse_OpenPanelFromWorldmap(nodeKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap )
			WorldMapPopupManager:push( Panel_Window_Warehouse, true )
			if ( regionInfoWrapper:get():hasNpcWorkerNpc() ) then
				-- 일꾼 정보를 열어야 한다
				-- WorldMapWindow_OpenWaitWorkerManageByPlantKey( ToClient_convertWaypointKeyToPlantKey(nodeKey) )
				-- WorldMapPopupManager:push( Panel_manageWorker, WorldMapMode.WORLDMAP_TOWN )

				FGlobal_workerManager_UpdateNode( ToClient_convertWaypointKeyToPlantKey(nodeKey) )
				-- WorldMapPopupManager:push( Panel_WorkerManager, WorldMapMode.WORLDMAP_TOWN )
			end
		end
	end
end

function FGlobal_PushOpenWorldMap()
	if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
		return
	end
	
	FGlobal_HideDialog()
	ToClient_AddWorldMapFlush()
end


--------------- 월드맵 아이템 마켓창이 열려있으면 M(ㅡ)이눌려도 월드맵이 닫히지 않는다. - 태곤.
function FGlobal_CloseWorldmapForLuaKeyHandling()
	if Panel_Window_ItemMarket:GetShow() then
		return
	else
		FGlobal_PopCloseWorldMap()
	end
end

function FGlobal_PopCloseWorldMap()
	ToClient_PopWorldMapFlush()
	isCloseWorldMap = false
end

function FromClient_WorldMapOpen()
	ToClient_SaveUiInfo( true )
	if( ToClient_WorldMapIsShow() ) then
		FGlobal_PopCloseWorldMap();
		return;
	end
	-- 메이드를 통해 창고를 열어둔 채 월드맵을 열 경우, flush 되기 전에 강제적으로 창고를 닫아줍니다. - 문종
	-- 창고 있는 거점 클릭한 후 나올 때 창고를 pop 시키기 때문!
	if ToClient_CheckExistSummonMaid() and Panel_Window_Warehouse:GetShow() then
		Warehouse_Close()
	end
	
	Panel_MovieTheater640_Initialize()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	SetUIMode( Defines.UIMode.eUIMode_WorldMap )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
	UI.flushAndClearUI();

	ToClient_openWorldMap()
	
	setFullSizeMode( true, FullSizeMode.fullSizeModeEnum.Worldmap )
	FGlobal_NpcNavi_ShowRequestOuter()
	Panel_Npc_Dialog:SetShow(false)
--	Dialog_clickExitReq(true)
	FGlobal_QuestWidget_Open()				-- 월드맵 꺼질 때 퀘스트 위젯 켜진다.
	FGlobal_WarInfo_Open()					-- 점령전 정보
	FGlobal_NodeWarInfo_Open()				-- 거점전 정보

	FGlobal_TownfunctionNavi_SetWorldMap()	-- NPC 찾기 관련.
	FGlobal_workerManager_OpenWorldMap()	-- 일꾼 목록 켜기.

--	ToCleint_findHouseByItemName("극 아인 장검")
--	ToClient_gotoHouseNode(13)
end
--------------------------------------------------------------------------------------

function FGlobal_OpenWorldMapWithHouse()
--	if( false == ToClient_isWorldMapOpenable()) then
--		return;
--	end
--
--	if( false == FGlobal_OpenWorldMap() ) then
--		SetUIMode( Defines.UIMode.eUIMode_Default )
--		setFullSizeMode( false)
--		UI.restoreFlushedUI()
--		return;
--	end 

	isOpenWorldMapWithHouse = true	-- 축사창 열림 방지 변수(집 구매시, ...)

	FGlobal_PushOpenWorldMap()
	
	local actorWrapper = interaction_getInteractable();
	ToClient_OpenWorldMapWithHouse(actorWrapper:get());
	isCloseWorldMap = false
end

function FGlobal_WorldMapWindowEscape()
	if ToClient_WorldMapIsShow() then
		if( Panel_HouseControl:GetShow() == false 
			and Panel_LargeCraft_WorkManager:GetShow() == false 
			and Panel_RentHouse_WorkManager:GetShow() == false 
			and Panel_Building_WorkManager:GetShow() == false
			and Panel_House_SellBuy_Condition:GetShow() == false 
			and Panel_Window_Delivery_Information:GetShow() == false
			and Panel_Window_Delivery_Request:GetShow() == false 
			and Panel_Trade_Market_Graph_Window:GetShow() == false
			and Panel_TradeMarket_EventInfo:GetShow() == false
			and Worldmap_Grand_GuildHouseControl:GetShow() == false
			and Worldmap_Grand_GuildCraft:GetShow() == false
			) then
				ToClient_WorldMapPushEscape()
		end	

		FGlobal_WarInfo_Open();
		FGlobal_NodeWarInfo_Open() -- 거점전
	
		if( not WorldMapPopupManager:pop() ) then
			FGlobal_PopCloseWorldMap();
		end
	end
	
	if( 0 > WorldMapPopupManager._currentMode ) then
		FGlobal_WorldMapCloseSubPanel()
	end
end

function FromClient_ExitWorldMap()
	isCloseWorldMap = true
end

function FGlobal_AskCloseWorldMap()
	return isCloseWorldMap;
end

local IM = CppEnums.EProcessorInputMode
function FGlobal_WorldMapClose()
	if( false == ToClient_WorldMapIsShow() ) then
		return
	end

	DragManager:clearInfo()
	WorldMapPopupManager:clear();
	setFullSizeMode( false)
	UI.restoreFlushedUI()
	ToClient_closeWorldMap()
	FGlobal_NpcNavi_ShowRequestOuter()
	setShowLine(true)
	collectgarbage("collect");
	
	FGlobal_WorldMapCloseSubPanel()
	FGlobal_WarInfo_Close()		-- 점령전 정보
	FGlobal_NodeWarInfo_Close() -- 점령전 정보
	isCloseWorldMap = true

	FGlobal_QuestWidget_Open()	-- 월드맵 꺼질 때 퀘스트 위젯 켜준다.

	FGlobal_TownfunctionNavi_UnSetWorldMap()	-- NPC위치 찾기
	
	SetUIMode( Defines.UIMode.eUIMode_Default )
	if( AllowChangeInputMode() ) then
		UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode )
	else
		SetUIMode( Defines.UIMode.eUIMode_Default )
		SetFocusChatting();
	end
	
	if ToClient_IsSavedUi() then
		ToClient_SaveUiInfo( true )
		ToClient_SetSavedUi( false )
	end
	FGlobal_Panel_MovieTheater640_WindowClose()
	FGlobal_resetGuildWarMode()
	ToClient_SetGuildMode(false)
end

function FGlobal_WorldMapCloseSubPanel()
	Panel_NodeMenu:SetShow(false)
	Panel_Window_Warehouse:SetShow(false)
	Panel_manageWorker:SetShow(false)
	Panel_Working_Progress:SetShow(false)
	FGlobal_ItemMarketItemSet_Close()
	FGolbal_ItemMarket_Close()
	FromClient_OutWorldMapQuestInfo()
	FromClient_OnTerritoryTooltipHide()
	NodeMenu_ShowToggle( false )
	TradeEventInfo_Close()
end

--------------------------------------------------------------------------------------------
-- 월드맵 모드 변경
-- 
local eCheckState = CppEnums.WorldMapCheckState; 
local WORLDMAP_RENDERTYPE  = CppEnums.WorldMapState
function FromClient_RenderStateChange( state )
	if( WORLDMAP_RENDERTYPE.eWMS_EXPLORE_PLANT == state ) then
		local questShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Quest)
		local knowledgeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge)
		local fishNChipShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip)
		local nodeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Node)
		local tradeShow = ToClient_isWorldmapCheckState( eCheckState.eCheck_Trade )
		local wayShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Way)
		local positionShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Postions)
		local wagonIsShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Wagon);
	
		ToClient_worldmapNodeMangerSetShow(nodeShow)
		ToClient_worldmapBuildingManagerSetShow(true)
		ToClient_worldmapQuestManagerSetShow(questShow)
		ToClient_worldmapGuideLineSetShow(wayShow)
		ToClient_worldmapDeliverySetShow(wagonIsShow)
		ToClient_worldmapTerritoryManagerSetShow(true)
		ToClient_worldmapActorManagerSetShow(positionShow)
		ToClient_worldmapPinSetShow(positionShow)
		if isGameTypeRussia() then
			ToClient_worldmapGuildHouseSetShow( false, WaypointKeyUndefined )	-- 월드맵에서 길드하우스, 빌라 아이콘 보여주고끄기를 컨트롤 한다.
		else
			ToClient_worldmapGuildHouseSetShow( true, WaypointKeyUndefined )
		end

		ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, WaypointKeyUndefined)
		ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, WaypointKeyUndefined)
		ToClient_worldmapTradeNpcSetShow(tradeShow, WaypointKeyUndefined)
		ToClient_worldmapHouseManagerSetShow(false, WaypointKeyUndefined )

		ToClient_SetGuildMode(FGlobal_isGuildWarMode())
	elseif( WORLDMAP_RENDERTYPE.eWMS_REGION == state ) then
		ToClient_worldmapNodeMangerSetShow(false)
		ToClient_worldmapBuildingManagerSetShow(false)
		ToClient_worldmapQuestManagerSetShow(false)
		ToClient_worldmapGuideLineSetShow(false)
		ToClient_worldmapDeliverySetShow(false)
		ToClient_worldmapActorManagerSetShow(false)
		ToClient_worldmapPinSetShow(false)

		ToClient_worldmapTradeNpcSetShow(false, WaypointKeyUndefined)
		ToClient_worldmapHouseManagerSetShow(false, WaypointKeyUndefined )
		ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, WaypointKeyUndefined)
		ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, WaypointKeyUndefined)
	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_WATER == state ) then
		ToClient_worldmapNodeMangerSetShow(false)
		ToClient_worldmapBuildingManagerSetShow(false)
		ToClient_worldmapQuestManagerSetShow(false)
		ToClient_worldmapGuideLineSetShow(false)
		ToClient_worldmapDeliverySetShow(false)
		ToClient_worldmapActorManagerSetShow(false)
		ToClient_worldmapPinSetShow(false)

		ToClient_worldmapTradeNpcSetShow(false, WaypointKeyUndefined)
		ToClient_worldmapHouseManagerSetShow(false, WaypointKeyUndefined )
		ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, WaypointKeyUndefined)
		ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, WaypointKeyUndefined)
	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_CELCIUS == state ) then
		ToClient_worldmapNodeMangerSetShow(false)
		ToClient_worldmapBuildingManagerSetShow(false)
		ToClient_worldmapQuestManagerSetShow(false)
		ToClient_worldmapGuideLineSetShow(false)
		ToClient_worldmapDeliverySetShow(false)
		ToClient_worldmapActorManagerSetShow(false)
		ToClient_worldmapPinSetShow(false)

		ToClient_worldmapTradeNpcSetShow(false, WaypointKeyUndefined)
		ToClient_worldmapHouseManagerSetShow(false, WaypointKeyUndefined )
		ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, WaypointKeyUndefined)
		ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, WaypointKeyUndefined)
	elseif( WORLDMAP_RENDERTYPE.eWMS_LOCATION_INFO_HUMIDITY == state ) then
		ToClient_worldmapNodeMangerSetShow(false)
		ToClient_worldmapBuildingManagerSetShow(false)
		ToClient_worldmapQuestManagerSetShow(false)
		ToClient_worldmapGuideLineSetShow(false)
		ToClient_worldmapDeliverySetShow(false)
		ToClient_worldmapActorManagerSetShow(false)
		ToClient_worldmapPinSetShow(false)

		ToClient_worldmapTradeNpcSetShow(false, WaypointKeyUndefined)
		ToClient_worldmapHouseManagerSetShow(false, WaypointKeyUndefined )
		ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, WaypointKeyUndefined)
		ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, WaypointKeyUndefined)
	end
end

local _townModeWaypointKey = nil;
function FromClient_SetTownMode( waypointKey )
	_townModeWaypointKey = waypointKey;

	local explorationNodeInClient = ToClient_getExploratioNodeInClientByWaypointKey( waypointKey );
	if( nil ~= explorationNodeInClient ) then
		UpdateWorldMapNode( explorationNodeInClient );
	end

	FGlobal_WarInfo_Close()
	FGlobal_NodeWarInfo_Close()

	local knowledgeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge)
	local fishNChipShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip)
	local tradeShow = ToClient_isWorldmapCheckState( eCheckState.eCheck_Trade )
	
	ToClient_worldmapLifeKnowledgeSetShow( fishNChipShow, waypointKey )
	ToClient_worldmapExceptionLifeKnowledgeSetShow( knowledgeShow, waypointKey )
	ToClient_worldmapHouseManagerSetShow( true, waypointKey )
	ToClient_worldmapTradeNpcSetShow( tradeShow, waypointKey )
	if isGameTypeRussia() then
		ToClient_worldmapGuildHouseSetShow(false, waypointKey)
	else
		ToClient_worldmapGuildHouseSetShow(true, waypointKey)
	end

	ToClient_worldmapQuestManagerSetShow( false )
	ToClient_worldmapGuideLineSetShow( false )
	ToClient_worldmapDeliverySetShow( false )
	ToClient_worldmapTerritoryManagerSetShow( false )

	workerManager_Close()			-- 일꾼 목록 끄기
	FGlobal_LoadWorldMapTownSideWindow( waypointKey )
	FGlobal_QuestWidget_Close()		-- 마을맵에서는 퀘스트 위젯을 꺼준다.

	-- {보기 않좋아서 정리 중}
		Panel_WorldMap				:SetShow(false)
		Panel_Worldmap_Information	:SetShow(false)
		Panel_NodeMenu				:SetShow( true )
	-- }

	ToClient_SetGuildMode(false)
	Panel_NodeSiegeTooltip:SetShow( false )
	
	FGlobal_NodeWarSetPosition()

	------ 월드맵 축사창 --------------------------------------------------------------------------------------
	if not isOpenWorldMapWithHouse then	-- 인터렉션으로 집 구매시 열리지 않도록
		local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint( waypointKey )
		if nil ~= regionInfoWrapper then
			if( regionInfoWrapper:get():hasStableNpc() ) then
				-- 순서가 중요하다. 등록하고 나서, 축사 관련 함수를 호출 해야 한다
				-- 이유는 축사 관련 함수에서, 실제 데이터를 가지고 패널을 열고, 닫는 것을 수행하기 때문.
				WorldMapPopupManager:push( Panel_NodeStable, true, FGlobal_OpenNodeStable, StableClose_FromWorldMap )
				
				local isStableOpen = StableOpen_FromWorldMap( waypointKey )
				-- if isStableOpen then
					WorldMapPopupManager:push( Panel_NodeStableInfo, false, nodeStableInfo_Close )
					-- nodeStableInfo_Open( waypointKey, 0 )
				-- end
			end
		end
	end
end

function FGlobal_OpenNodeStable()
	if( nil == _townModeWaypointKey ) then
		return;
	end
	
	local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint( _townModeWaypointKey )
	if nil ~= regionInfoWrapper then
		if( regionInfoWrapper:get():hasStableNpc() ) then
			StableOpen_FromWorldMap( _townModeWaypointKey )
		end
	end
end

-- function FGlobal_OpenNodeStableInfo()
	-- if Panel_NodeStable:GetShow() then
		-- nodeStableInfo_Open( _townModeWaypointKey, 0 )
	-- else
		-- nodeStableInfo_Close()
	-- end
-- end
-----------------------------------------------------------------------------------------------------------

function FromClient_resetTownMode()
	
	_townModeWaypointKey = nil;
	local knowledgeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge)
	local fishNChipShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip)
	local tradeShow = ToClient_isWorldmapCheckState( eCheckState.eCheck_Trade )
	local delivererShow = ToClient_isWorldmapCheckState( eCheckState.eCheck_Wagon )
	local questShow		= ToClient_isWorldmapCheckState( eCheckState.eCheck_Quest )
	local guideLineShow	= ToClient_isWorldmapCheckState( eCheckState.eCheck_Way )
	
	ToClient_worldmapLifeKnowledgeSetShow( fishNChipShow, WaypointKeyUndefined )
	ToClient_worldmapExceptionLifeKnowledgeSetShow( knowledgeShow, waypointKey )
	ToClient_worldmapHouseManagerSetShow( false, WaypointKeyUndefined )
	ToClient_worldmapTradeNpcSetShow( tradeShow, WaypointKeyUndefined )
	if isGameTypeRussia() then
		ToClient_worldmapGuildHouseSetShow(false, WaypointKeyUndefined)
	else
		ToClient_worldmapGuildHouseSetShow(true, WaypointKeyUndefined)
	end
	ToClient_worldmapDeliverySetShow(delivererShow)

	ToClient_worldmapQuestManagerSetShow( questShow )
	ToClient_worldmapGuideLineSetShow( guideLineShow )
	ToClient_worldmapTerritoryManagerSetShow( true )

	FGlobal_QuestWidget_Open()					-- 마을 맵 나갈 때에는 다시 퀘스트 위젯을 켜준다.
	FGlobal_workerManager_OpenWorldMap()		-- 일꾼 목록 켜기.
	FGlobal_workerManager_ResetPlantKey()		-- 일꾼 목록 노드키 초기화.

	-- {보기 않좋아서 정리 중}
		Panel_WorldMap				:SetShow(true)
		Panel_Worldmap_Information	:SetShow(true)
		-- Panel_NodeMenu				:SetShow( false )
		FGlobal_CloseNodeMenu()
	-- }
	
	isOpenWorldMapWithHouse = false	-- 축사창 열림 방지 변수(집 구매시, ...)
	StableClose_FromWorldMap()		-- 축사창 닫기
	
	Panel_NodeGuildWarMenu:SetShow( false )

	ToClient_SetGuildMode(FGlobal_isGuildWarMode())
end

registerEvent("FromClient_RenderStateChange",			"FromClient_RenderStateChange")
registerEvent("FromClient_SetTownMode",					"FromClient_SetTownMode")
registerEvent("FromClient_resetTownMode",				"FromClient_resetTownMode")

registerEvent("FromClient_WorldMapOpen",				"FromClient_WorldMapOpen")
registerEvent("FromClient_ExitWorldMap",				"FromClient_ExitWorldMap")
registerEvent("FromClient_ImmediatelyCloseWorldMap",	"FGlobal_WorldMapClose")

registerEvent("FromClient_LClickedWorldMapNode",		"FromClient_LClickedWorldMapNode")
registerEvent("FromClient_WorldMapNodeUpgrade",			"UpdateWorldMapNode")
registerEvent("FromClient_FillNodeInfo",				"FGlobal_OpenOtherPanelWithNodeMenu")
registerEvent("FromClient_WorldMapNodeFindNearNode",	"FromClient_WorldMapNodeFindNearNode")
registerEvent("FromClient_WorldMapNodeFindTargetNode",	"FromClient_WorldMapNodeFindTargetNode")
registerEvent("FromClient_RClickWorldmapPanel",			"FromClient_RClickWorldmapPanel")

-- 배송
registerEvent("FromClient_DeliveryRequestAck",		"DeliveryRequest_UpdateRequestSlotData");
registerEvent("EventDeliveryInfoUpdate",			"DeliveryInformation_UpdateSlotData")

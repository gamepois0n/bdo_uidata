-- local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM			= CppEnums.TextMode
local isharvestManagement = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 72 )

Panel_MyHouseNavi:RegisterShowEventFunc( true,	'MyHouseNaviShowAni()' )
Panel_MyHouseNavi:RegisterShowEventFunc( false,	'MyHouseNaviHideAni()' )
Panel_MyHouseNavi:SetDragEnable( false )
Panel_MyHouseNavi:SetPosY( Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15 )
function	MyHouseNaviShowAni()
	UIAni.fadeInSCR_Down(Panel_MyHouseNavi)
end

function	MyHouseNaviHideAni()
	Panel_MyHouseNavi:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_MyHouseNavi:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

local isCheckTentPosition = false
local isCheckHousePosition = false

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local _houseIcon			= UI.getChildControl ( Panel_MyHouseNavi, "Static_Icon_House" )					-- 주거지 아이콘
local _houseBorder			= UI.getChildControl ( Panel_MyHouseNavi, "Static_SlotBackground" )
local _tentIcon				= UI.getChildControl ( Panel_MyHouseNavi, "Static_Icon_Tent" )					-- 텐트 아이콘
local _tentBorder			= UI.getChildControl ( Panel_MyHouseNavi, "Static_SlotBackground_Tent" )
local _territoryIcon		= UI.getChildControl ( Panel_MyHouseNavi, "Static_Icon_TerritoryAuth" )			-- 황실무역 아이콘
local _territoryBorder		= UI.getChildControl ( Panel_MyHouseNavi, "Static_SlotBackground_TerritoryAuth" )
local _workerIcon			= UI.getChildControl ( Panel_MyHouseNavi, "Static_Icon_Worker" )				-- 일꾼 아이콘
local _helpTooltip			= UI.getChildControl ( Panel_MyHouseNavi, "StaticText_Helper" )					-- 마우스오버 도움말
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-----------------------------------------------
--		패널은 이제 켜두지 않는다!!
-----------------------------------------------
Panel_MyHouseNavi	:SetShow( false )
_houseIcon			:SetShow( false )
_tentIcon			:SetShow( false )
_territoryIcon		:SetShow( false )
_houseIcon			:SetIgnore( true )
_tentIcon			:SetIgnore( true )
_territoryIcon		:SetIgnore( true )
_houseBorder		:SetShow( false )
_tentBorder			:SetShow( false )
_territoryBorder	:SetShow( false )
_helpTooltip		:SetShow( false )
_workerIcon			:SetShow( false )

------------------------------------------------
-- 초기 설정
------------------------------------------------
local posY, posX
local Panel_MyHouseNavi_Init = function()
	posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
	posX = 0
	if Panel_Window_Servant:GetShow() then
		posX = Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX()
	else
		posX = 10
	end

	local servantIconCount = FGlobal_ServantIconCount()

	-- UI 포지션이 저장되어 있지 않다면,
	if not changePositionBySever(Panel_MyHouseNavi, CppEnums.PAGameUIType.PAGameUIPanel_MyHouseNavi, false, false, false) then
		if Panel_Window_Servant:GetShow() then
			Panel_MyHouseNavi:SetPosX( posX )
			Panel_MyHouseNavi:SetPosY( Panel_Window_Servant:GetPosY() )
		else
			Panel_MyHouseNavi:SetPosX( 10 )
			Panel_MyHouseNavi:SetPosY( posY )
		end

	elseif Panel_Window_Servant:GetShow() then
		local x1 = Panel_Window_Servant:GetPosX()
		local y1 = Panel_Window_Servant:GetPosY()
		local x2 = Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX()
		local y2 = Panel_Window_Servant:GetPosY() + Panel_Window_Servant:GetSizeY()

		-- UI 포지션이 저장되어 있는데, 포지션이 겹친다면,
		-- 주거지 아이콘과 서번트 아이콘이 겹치면 새로 포지션을 잡는다!!!
		for index = 0, Panel_MyHouseNavi:GetSizeX(), 10 do
			if x1 <= Panel_MyHouseNavi:GetPosX() + index and x2 >= Panel_MyHouseNavi:GetPosX() + index then
				if y1 <= Panel_MyHouseNavi:GetPosY() and y2 >= Panel_MyHouseNavi:GetPosY()
					or y1 <= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY()/2 and y2 >= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY()/2
					or y1 <= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY() and y2 >= Panel_MyHouseNavi:GetPosY() + Panel_MyHouseNavi:GetSizeY() then
					Panel_MyHouseNavi:SetPosX( Panel_Window_Servant:GetPosX() + Panel_Window_Servant:GetSizeX() )
					Panel_MyHouseNavi:SetPosY( Panel_Window_Servant:GetPosY() )
					
				end
			end
		end
	end
	checkAndSetPosInScreen(Panel_MyHouseNavi)
end

local houseIconCount = 0
local gapX = _houseIcon:GetSizeX()
local firstLoadingCheck = true
function Panel_MyHouseNavi_Update( init, listCount )
	if (nil == init and isFlushedUI()) or isFlushedUI() then	-- 기본 게임모드에서만 아이콘이 나타난다!
		return
	end
	
	local iconNums = 0
	------------------------------------------------------------
	--				주거지가 있을 경우 체크
	local isHaveDwelling = ToClient_IsHaveDwelling()
	local panelSizeX = 0
	if ( isHaveDwelling == true ) then
		_houseIcon	:SetShow( true )
		_houseIcon	:SetIgnore( false )
		_houseIcon	:ActiveMouseEventEffect( true )

		_houseBorder:SetShow( false )
		_houseBorder:SetIgnore( true )

		_houseIcon	:addInputEvent( "Mouse_LUp", "FGlobal_HousingList_Open()" )
		_houseIcon	:addInputEvent( "Mouse_On", "HandleMouseOnTooltip( \"selfHouse\", true )" )
		_houseIcon	:addInputEvent( "Mouse_Out", "HandleMouseOnTooltip( \"selfHouse\", false )" )

		-- panelSizeX = panelSizeX + _houseIcon:GetSizeX()	-- 패널 사이즈를 더한다.
		iconNums = iconNums + 1
	else
		_houseIcon	:SetShow( false )
		_houseIcon	:SetIgnore( true )
		_houseIcon	:ActiveMouseEventEffect( false )

		_houseBorder:SetShow( false )
		_houseBorder:SetIgnore( true )
	end

	------------------------------------------------------------
	--				내 텐트가 있을 경우 체크	
	-- 위젯에서는 항상 안보이기로 함.
	local temporaryWrapper	= getTemporaryInformationWrapper()
	local tentCheck			= ( nil ~= temporaryWrapper ) and temporaryWrapper:isSelfTent()
	if	tentCheck	then
		-- if not Panel_MyHouseNavi:GetShow() then
			-- Panel_MyHouseNavi:SetShow( true, true )
		-- end
		_tentIcon	:SetShow( true )
		_tentIcon	:SetIgnore( false )
		_tentIcon	:ActiveMouseEventEffect( true )
	
		_tentBorder	:SetShow( false )
		_tentBorder	:SetIgnore( true )
				
		-- if _houseIcon:GetShow() then
			-- _tentBorder	:SetPosX( _houseIcon:GetPosX()	+ _houseIcon:GetSizeX() )
			-- _tentIcon	:SetPosX( iconNums * gapX )
		-- else
			-- _tentBorder	:SetPosX( _houseBorder:GetPosX() )
			-- _tentIcon	:SetPosX( _houseIcon:GetPosX() )
		-- end
		
		_tentIcon	:SetPosX( iconNums * gapX - 3 )
	
		if isharvestManagement then
			_tentIcon	:addInputEvent( "Mouse_LUp", "HandleClicked_TentList_ShowToggle()" )
		else
			_tentIcon	:addInputEvent( "Mouse_LUp", "" )
		end
		_tentIcon	:addInputEvent( "Mouse_RUp", "Panel_MyHouseNavi_FindWay( \"tent\" )" )
		_tentIcon	:addInputEvent( "Mouse_On", "HandleMouseOnTooltip( \"tent\", true )" )
		_tentIcon	:addInputEvent( "Mouse_Out", "HandleMouseOnTooltip( \"tent\", false )" )
	
		-- panelSizeX = panelSizeX + _tentIcon:GetSizeX() + 5	-- 패널 사이즈를 더한다.
		iconNums = iconNums + 1
	else
		_tentIcon	:SetShow( false )
		_tentIcon	:SetIgnore( true )
		_tentIcon	:ActiveMouseEventEffect( false )
	
		_tentBorder	:SetShow( false )
		_tentBorder	:SetIgnore( true )
	end
	
	-- 일꾼 아이콘 : 일꾼이 하나라도 있으면 표시
	local isNpcWorkerCount = 0
	if nil ~= listCount then
		isNpcWorkerCount = listCount
	else
		isNpcWorkerCount = ToClient_getMyNpcWorkerCount()
	end

	if 0 < isNpcWorkerCount then
		_workerIcon:SetShow( true )
		_workerIcon:ActiveMouseEventEffect( true )
		_workerIcon:SetPosX( iconNums * gapX - 3 )
		-- panelSizeX = panelSizeX + _workerIcon:GetSizeX()	-- 패널 사이즈를 더한다.
		
		_workerIcon	:addInputEvent( "Mouse_LUp", "WorkerManager_ShowToggle()" )
		_workerIcon	:addInputEvent( "Mouse_On", "HandleMouseOnTooltip( \"worker\", true )" )
		_workerIcon	:addInputEvent( "Mouse_Out", "HandleMouseOnTooltip( \"worker\", false )" )
		
		iconNums = iconNums + 1
	else
		_workerIcon:SetShow( false )
	end
	
	-- 황실 무역 아이콘
	-- 영지 번호 : 0(발레노스), 1(세렌디아), 2(칼페온), 3(메디아)
	
	if isHaveTerritoryTradeAuthority(0) or 
		isHaveTerritoryTradeAuthority(1) or 
		isHaveTerritoryTradeAuthority(2) or 
		isHaveTerritoryTradeAuthority(3) then

		-- if not Panel_MyHouseNavi:GetShow() then
			-- Panel_MyHouseNavi:SetShow( true, true )
		-- end
		_territoryIcon	:SetShow( true )
		_territoryIcon	:SetIgnore( false )
		_territoryIcon	:ActiveMouseEventEffect( true )

		_territoryBorder:SetShow( false )
		_territoryBorder:SetIgnore( true )

		_territoryIcon	:SetPosX( iconNums * gapX - 3 )
		_territoryIcon	:addInputEvent( "Mouse_On", "HandleMouseOnTooltip( \"territoryAuth\", true )" )
		_territoryIcon	:addInputEvent( "Mouse_Out", "HandleMouseOnTooltip( \"territoryAuth\", false )" )
		
		-- panelSizeX = panelSizeX + _territoryIcon:GetSizeX() + 5	-- 패널 사이즈를 더한다.
		
		-- 포지션 잡아준다
		-- if ( 0 == iconNums ) then
			-- _territoryBorder	:SetPosX( _houseBorder:GetPosX() )
			-- _territoryIcon		:SetPosX( _houseIcon:GetPosX() )
		-- elseif ( 1 == iconNums ) then
			-- _territoryBorder	:SetPosX( _houseBorder:GetPosX()	+ _houseBorder:GetSizeX()	+ 5 )
			-- _territoryIcon		:SetPosX( _houseIcon:GetPosX()		+ _houseIcon:GetSizeX()			)
		-- elseif ( 2 == iconNums ) then
			-- _territoryBorder	:SetPosX( _tentBorder:GetPosX()		+ _houseBorder:GetSizeX()	+ 5 )
			-- _territoryIcon		:SetPosX( _tentIcon:GetPosX()		+ _houseIcon:GetSizeX()			)
		-- elseif ( 3 == iconNums ) then
			-- _territoryBorder	:SetPosX( _tentBorder:GetPosX()		+ _houseBorder:GetSizeX()	+ 5 )
			-- _territoryIcon		:SetPosX( _tentIcon:GetPosX()		+ _houseIcon:GetSizeX()			)
		-- end
		iconNums = iconNums + 1
	else
		_territoryIcon	:SetShow( false )
		_territoryIcon	:SetIgnore( true )
		_territoryIcon	:ActiveMouseEventEffect( false )

		_territoryBorder:SetShow( false )
		_territoryBorder:SetIgnore( true )
	end
	--]]--
	
	panelSizeX = iconNums * gapX
	if 0 == panelSizeX then
		panelSizeX = 60
	end
	
	if 0 < iconNums then
		Panel_MyHouseNavi:SetShow( true )
		Panel_MyHouseNavi_Init()
	else
		Panel_MyHouseNavi:SetShow( false )
	end
	
	Panel_MyHouseNavi:SetSize( panelSizeX, Panel_MyHouseNavi:GetSizeY())

	--if (not isHaveDwelling) and (not tentCheck) then
	--if (not isHaveDwelling) and (not tentCheck) and (false == _territoryIcon:GetShow()) then
		--Panel_MyHouseNavi:SetShow( false, false )
	--else
		--Panel_MyHouseNavi:SetShow( true, true )
	--end	
	houseIconCount = iconNums
	if firstLoadingCheck then
		firstLoadingCheck = false
		return
	end
	
	-- if changePositionBySever(Panel_MyHouseNavi, CppEnums.PAGameUIType.PAGameUIPanel_MyHouseNavi, true, true, false) then
	-- else
		-- local servantIconCount = FGlobal_ServantIconCount()
		-- Panel_MyHouseNavi:SetPosX( 60 * icons )
		-- Panel_MyHouseNavi:SetPosY( posY )
	-- end
	
	FGlobal_PetListNew_NoPet()
end
UI.addRunPostFlushFunction( Panel_MyHouseNavi_Update )

-- 사용안함!!
function return_ServantIconNums( icons )							-- Panel_Window_Servant.lua로부터 서번트 아이콘 갯수 넘겨 받음
	if Panel_MyHouseNavi:GetPosX() <= ( 60 * icons ) then
		Panel_MyHouseNavi:SetPosX( 60 * icons )
		Panel_MyHouseNavi:SetPosY( posY )
	else
		changePositionBySever(Panel_MyHouseNavi, CppEnums.PAGameUIType.PAGameUIPanel_MyHouseNavi, true, true, false)
	end
end

function FGlobal_HouseIconCount()
	return houseIconCount
end

function WorkerManager_ShowToggle()
	FGlobal_WorkerManger_ShowToggle()
end

-------------------------------------------------------
--				마우스 오버시 도움말 툴팁
-------------------------------------------------------
function HandleMouseOnTooltip( naviType, isShow )
	local name, desc, uiControl

	if ( naviType == "selfHouse" ) then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_SELFHOUSE_NAME") -- "주거지"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_SELFHOUSE_DESC") -- "- 좌클릭 : 내 주거지 목록"
		uiControl = _houseIcon
	
	elseif ( naviType == "tent" ) then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TENT_NAME") -- "텃밭"
		if isharvestManagement then
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TENT_DESC") -- "- 좌클릭 : 텃밭 목록 열기\n- 우클릭 : 텃밭 위치 안내"
		else
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TENT_DESC_2") -- "우클릭 : 텃밭 위치 안내"
		end
		uiControl = _tentIcon

	elseif ( naviType == "worker" ) then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_WORKER_TOOLTIP_NAME") -- 일꾼
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_WORKER_TOOLTIP_DESC") -- - 좌클릭 : 일꾼 목록 열기
		uiControl = _workerIcon

	elseif ( naviType == "territoryAuth" ) then
		local territoryName = {
			[0]	= tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),		-- 발레노스
			[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),		-- 세렌디아
			[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),		-- 칼페온
			[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3")),		-- 메디아
		}
		name = PAGetString(Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TERRITORYAUTH_NAME") -- "황실무역 권한"
		desc = ""
		uiControl = _territoryIcon
		
		for territoryIndex = 0, 3 do
			if ( true == isHaveTerritoryTradeAuthority(territoryIndex) ) then
				if ( "" == desc ) then
					desc = territoryName[territoryIndex]
				else
					desc = desc .. " / " .. territoryName[territoryIndex]
				end
			end
		end
		
		if "" ~= desc then
			desc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TOOLTIP_TERRITORYAUTH_DESC", "desc", desc ) -- desc .. "의 황실무역 권한을 보유하고 있습니다."
		end
		
	end

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
		if getEnableSimpleUI() then		
			House_UpdateSimpleUI(true);
		end
	else
		TooltipSimple_Hide()
		if getEnableSimpleUI() then		
			House_UpdateSimpleUI(false);
		end
	end
end

local _houseSimpleUIAlpha = 0.7;
function House_UpdateSimpleUI( isOver )
	_houseSimpleUIAlpha = 0.7;
	if isOver then
		_houseSimpleUIAlpha = 1.0;
	end
end


--[[
function HandleMouseOnTooltip( naviType, isShow )
	_helpTooltip:SetShow( isShow )
	_helpTooltip:SetAutoResize( true )
	_helpTooltip:SetTextMode( UI_TM.eTextMode_AutoWrap )
	Panel_MyHouseNavi:SetChildIndex(_helpTooltip:GetKey(), 9999 )
	-- ♬ 집 아이콘에 마우스 올려놨을 때 Over Sound
	audioPostEvent_SystemUi(00,13)
	
	if ( false == isShow ) then
		return
	end

	if ( naviType == "selfHouse" ) then	
		-- local characterStaticStatusWrapper = ToClient_getMyDwelling(0)
		-- if nil == characterStaticStatusWrapper then
			-- return
		-- end
		-- local houseName = characterStaticStatusWrapper:getName()
		
		--_helpTooltip:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_helpTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_HOUSE" ))
		_helpTooltip:SetPosX( _houseIcon:GetPosX() - 20 )
		_helpTooltip:SetPosY( _houseIcon:GetPosY() + _houseIcon:GetSizeY() + 20 )
		--_helpTooltip:SetSize( _helpTooltip:GetSizeX(), _helpTooltip:GetSizeY() + 10 )
		
	elseif ( naviType == "tent" ) then
		_helpTooltip:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_MYHOUSENAVI_TENT" ) )
		--_helpTooltip:SetSize( 160, 30 )
		_helpTooltip:SetPosX( _tentIcon:GetPosX() - 20 )
		_helpTooltip:SetPosY( _tentIcon:GetPosY() + _houseIcon:GetSizeY() + 20 )

	elseif ( naviType == "territoryAuth" ) then
		local territoryName = {
			[0]	= tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),		-- 발레노스
			[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),		-- 세렌디아
			[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),		-- 칼페온
			[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3")),		-- 메디아
		}
		local _tooltiptxt = ""
		local terrAuth_Count = 0
		
		for territoryIndex = 0, 3 do
			if ( true == isHaveTerritoryTradeAuthority(territoryIndex) ) then
				if ( 0 == terrAuth_Count ) then
					_tooltiptxt = territoryName[territoryIndex]
				else
					_tooltiptxt = _tooltiptxt .. " / " .. territoryName[territoryIndex]
				end
				terrAuth_Count = terrAuth_Count + 1
			end
		end
		
		_helpTooltip:SetText( _tooltiptxt .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_4") )
		_helpTooltip:SetPosX( _territoryIcon:GetPosX() - 20 )
		_helpTooltip:SetPosY( _territoryIcon:GetPosY() + _houseIcon:GetSizeY() + 20 )
	else
		_helpTooltip:SetShow( false )
	end
end--]]

--------------------------------------------------------
--				길 찾기용 함수임
--------------------------------------------------------
function Panel_MyHouseNavi_FindWay( naviType )
	----------------------------------
	--		텐트 찾기를 눌렀다
	----------------------------------
	if ( naviType == "tent" ) and ( isCheckTentPosition == false ) then
		ToClient_DeleteNaviGuideByGroup(0);		-- 네비 초기화
		
		local navigationGuideParam	= NavigationGuideParam()
		navigationGuideParam._isAutoErase = true
		local temporaryWrapper		= getTemporaryInformationWrapper()
		if nil ~= temporaryWrapper then
			local myTentCount = temporaryWrapper:getSelfTentCount()
			for textIdx = 0, myTentCount - 1 do
				local tentWrapper = temporaryWrapper:getSelfTentWrapperByIndex( textIdx )
				local tentPosX	= tentWrapper:getSelfTentPositionX()
				local tentPosY	= tentWrapper:getSelfTentPositionY()
				local tentPosZ	= tentWrapper:getSelfTentPositionZ()
				local tentPos	= float3(tentPosX, tentPosY, tentPosZ)

				worldmapNavigatorStart( tentPos, navigationGuideParam, false, false, true)
			end
			
			--♬ 길찾기 버튼을 눌렀당
			audioPostEvent_SystemUi(00,14)
			
			isCheckTentPosition = true
		end
	elseif ( isCheckTentPosition == true ) or ( isCheckHousePosition == true ) then
		ToClient_DeleteNaviGuideByGroup(0);		-- 네비 초기화

		--♬ 길찾기 버튼을 눌러서 취소
		audioPostEvent_SystemUi(00,15)
		
		isCheckTentPosition = false
		isCheckHousePosition = false
		
	----------------------------------
	--		주거지 찾기를 눌렀다
	----------------------------------
	elseif ( naviType == "selfHouse" ) and ( isCheckHousePosition == false ) then
		-- 네비 초기화
		 ToClient_DeleteNaviGuideByGroup(0);

		--♬ 길찾기 버튼을 눌렀당
		audioPostEvent_SystemUi(00,14)
		 
		local characterStaticStatusWrapper = ToClient_getMyDwelling(0)
		if( nil == characterStaticStatusWrapper ) then
			_PA_ASSERT(false, "주거지 정보가 없습니다.")
			return
		end
		local houseX	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosX()
		local houseY	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosY()
		local houseZ	= characterStaticStatusWrapper:getObjectStaticStatus():getHousePosZ()
		local housePos	= float3(houseX, houseY, houseZ)
		
		
		worldmapNavigatorStart( housePos, NavigationGuideParam(), false, false, true )
		
		isCheckHousePosition = true
	end
end

function HandleClicked_TentList_ShowToggle()
	if Panel_HarvestList:GetShow() then
		HarvestList_Close()
		return
	end
	
	FGlobal_HarvestList_Open()
end

function Panel_MyHouseNavi_ShowToggle()
	if not ToClient_IsHaveDwelling() and (false == _territoryIcon:GetShow()) then
		return
	end
	
	if	Panel_MyHouseNavi:GetShow()	then
		Panel_MyHouseNavi:SetShow( false, false )
		Panel_WidgetControl_Toggle("Panel_MyHouseNavi", false)
	else
		Panel_MyHouseNavi:SetShow( true, true )
		Panel_WidgetControl_Toggle("Panel_MyHouseNavi", true)
	end
end

function PanelMyHouseNavi_RefreshPosition()
	ResetPos_WidgetButton()
end

function Panel_MyHouseNavi_PositionReset()
	Panel_MyHouseNavi_Init()
end

function Panel_MyHouseNavi:registEventHandler()
	Panel_MyHouseNavi:addInputEvent( "Mouse_PressMove",	"PanelMyHouseNavi_RefreshPosition()" )
	Panel_MyHouseNavi:addInputEvent( "Mouse_LUp",		"ResetPos_WidgetButton()" )
end

-- Panel_MyHouseNavi_Init()
-- Panel_MyHouseNavi_Update( true )
Panel_MyHouseNavi:registEventHandler()

FGlobal_PanelMove(Panel_MyHouseNavi, true)

---- 주거지 위치가 저장 안되는 이유는 아래의 저장된 값을 받아오는 함수가 빠져 있었음... (2015.06.23 이국환)
changePositionBySever(Panel_MyHouseNavi, CppEnums.PAGameUIType.PAGameUIPanel_MyHouseNavi, true, true, false)

function FGlobal_MyHouseNavi_Update()
	Panel_MyHouseNavi_Update( true )
end

-- 좌측 상단 일꾼 관리 아이콘이 캐릭터를 바꿨을 경우 나오지 않아서 별도 이벤트 처리했음.
function FromClient_ChangeWorkerCount( isInitialize, listCount )
	Panel_MyHouseNavi_Update( isInitialize, listCount )
end

registerEvent( "FromClient_ReceiveSetMyHouse",	"FGlobal_MyHouseNavi_Update" )
registerEvent( "FromClient_ReceiveReturnHouse",	"FGlobal_MyHouseNavi_Update" )
registerEvent( "FromClient_SetSelfTent",		"FGlobal_MyHouseNavi_Update" )
registerEvent( "FromClient_ResponseAuctionInfo","FGlobal_MyHouseNavi_Update" )
registerEvent( "WorldMap_WorkerDataUpdate",		"FGlobal_MyHouseNavi_Update" )
registerEvent( "onScreenResize", 				"Panel_MyHouseNavi_PositionReset")
registerEvent( "FromClient_ChangeWorkerCount", 	"FromClient_ChangeWorkerCount")

UI.addRunPostRestorFunction( Panel_MyHouseNavi_Update )
local IM = CppEnums.EProcessorInputMode

Panel_Interaction_FriendHouseList:SetShow( false )
Panel_Interaction_FriendHouseList:ActiveMouseEventEffect(true)
Panel_Interaction_FriendHouseList:setGlassBackground(true)

local FriendHouseRank = {
	_txtTitle			= UI.getChildControl( Panel_Interaction_FriendHouseList, "StaticText_Title" ),
	_btnClose			= UI.getChildControl( Panel_Interaction_FriendHouseList, "Button_Win_Close" ),
	_btnHelp			= UI.getChildControl( Panel_Interaction_FriendHouseList, "Button_Question" ),
	_scroll				= UI.getChildControl( Panel_Interaction_FriendHouseList, "Scroll_FriendList" ),
	_listBg				= UI.getChildControl( Panel_Interaction_FriendHouseList, "Static_BG" ),
	_tab 				= {
		[0]	= UI.getChildControl( Panel_Interaction_FriendHouseList, "RadioButton_Tab_Rank" ),
		[1]	= UI.getChildControl( Panel_Interaction_FriendHouseList, "RadioButton_Tab_Friend" ),
		[2]	= UI.getChildControl( Panel_Interaction_FriendHouseList, "RadioButton_Tab_Guild" ),
		[3]	= UI.getChildControl( Panel_Interaction_FriendHouseList, "RadioButton_Tab_Party" ),
	},

	_createTabCount		= 4,
	_tabPool			= {},
	
	_createListCount	= 15,
	_listPool			= {},

	_listCount			= 0,	-- 가져오는 데이터 수.
	_startIndex			= 0,

	_selectedTabIdx		= 0,

	_posConfig = {
		_tabStartPosX 	= 14,
		_tabPosXGap 	= 100,
		_listStartPosY 	= 83,
		_listPosYGap 	= 25,
	},
}

FriendHouseRank._btnHelp:SetShow( false )

function FriendHouseRank:Initialize()
	-- 탭 만들기
	-- for tabIdx = 0, self._createTabCount - 1 do
	-- 	local tab = UI.createAndCopyBasePropertyControl( Panel_Interaction_FriendHouseList, "RadioButton_Tab_Templete",	Panel_Interaction_FriendHouseList,	"FriendHouseList_Tab_"		.. tabIdx )
	-- 	tab:SetPosX( self._posConfig._tabStartPosX + ( self._posConfig._tabPosXGap * tabIdx ) )
	-- 	tab:SetPosY( 40 )
	-- 	tab:SetText( tabName[tabIdx] )
	-- 	tab:addInputEvent("Mouse_LUp", "FriendHouseRank_SelectTab( " .. tabIdx .. " )")
	-- 	self._tabPool[tabIdx] = tab
	-- end

	-- 리스트 만들기
	for listIdx = 0, self._createListCount - 1 do
		local list = {}
		list.name = UI.createAndCopyBasePropertyControl( Panel_Interaction_FriendHouseList, "StaticText_PlayerName",	Panel_Interaction_FriendHouseList,	"FriendHouseList_List_"		.. listIdx )
		list.name:SetPosX( 18 )
		list.name:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
		list.name:addInputEvent( "Mouse_UpScroll",		"FriendHouseRank_ScrollEvent( true )"	)
		list.name:addInputEvent( "Mouse_DownScroll",	"FriendHouseRank_ScrollEvent( false )"	)

		list.visitBtn = UI.createAndCopyBasePropertyControl( Panel_Interaction_FriendHouseList, "Button_Visit",			list.name,							"FriendHouseList_ListBtn_"	.. listIdx )
		list.visitBtn:SetPosX( list.name:GetSizeX() - list.visitBtn:GetSizeX() )
		list.visitBtn:SetPosY( 0 )
		list.visitBtn:addInputEvent( "Mouse_UpScroll",		"FriendHouseRank_ScrollEvent( true )"	)
		list.visitBtn:addInputEvent( "Mouse_DownScroll",	"FriendHouseRank_ScrollEvent( false )"	)

		UIScroll.InputEventByControl	( list.name,	"FriendHouseRank_ScrollEvent" )

		self._listPool[listIdx] = list
	end
end

function FriendHouseRank:registEventHandler()
	self._listBg	:addInputEvent(	"Mouse_UpScroll",	"FriendHouseRank_ScrollEvent( true )"	)
	self._listBg	:addInputEvent(	"Mouse_DownScroll",	"FriendHouseRank_ScrollEvent( false )"	)
	self._listBg	:SetIgnore(false);

	self._tab[0]	:addInputEvent("Mouse_LUp", "FriendHouseRank_SelectTab( " .. 0 .. " )")
	self._tab[1]	:addInputEvent("Mouse_LUp", "FriendHouseRank_SelectTab( " .. 1 .. " )")
	self._tab[2]	:addInputEvent("Mouse_LUp", "FriendHouseRank_SelectTab( " .. 2 .. " )")
	self._tab[3]	:addInputEvent("Mouse_LUp", "FriendHouseRank_SelectTab( " .. 3 .. " )")

	self._btnClose	:addInputEvent("Mouse_LUp", "FriendHouseRank_Close()")

	UIScroll.InputEvent( self._scroll,	"FriendHouseRank_ScrollEvent" )
end

function FriendHouseRank:registMessageHandler()
	-- body
end

function FriendHouseRank:Update()
	local self = FriendHouseRank
	for listIdx = 0, self._createListCount - 1 do	-- 리스트 초기화.
		local list = self._listPool[listIdx]
		list.name		:SetShow( false )
		list.visitBtn	:SetShow( false )
	end

	self._listCount = housing_getVisitableHouseWrapperCount()	-- 클라에서 받아온다.
	if self._listCount <= 0 then
		local list = self._listPool[0]
		list.name		:SetShow( true )
		list.name		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_FRIENDHOUSELIST_EMPTYHOUSE") ) -- "- 빈 집" )
		list.visitBtn	:SetShow( true )
		list.visitBtn	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_FRIENDHOUSELIST_VISIT") ) -- "구경" )
		list.visitBtn	:addInputEvent("Mouse_LUp", "FriendHouseRank_VisitFriend( " .. 0 .. ", false )")
	else
		local count = 0
		for listIdx = self._startIndex , self._listCount - 1 do
		
			if( self._createListCount <= count ) then
				break;
			end
		
			local list = self._listPool[count]
			local VisitableHouseWrapper = housing_getVisitableHouseWrapper( listIdx )
			list.name		:SetShow( true )
			list.name		:SetText( PAGetStringParam3( Defines.StringSheet_GAME, "LUA_INTERACTION_FRIENDHOUSELIST_HOUSERANK", "listIdx", listIdx+1, "getUserNickname", VisitableHouseWrapper:getUserNickname(), "getInteriorPoint", VisitableHouseWrapper:getInteriorPoint() ) ) -- listIdx+1 .. "위 " .. VisitableHouseWrapper:getUserNickname() .. "(" .. VisitableHouseWrapper:getInteriorPoint() .. "점)" )
			list.visitBtn	:SetShow( true )
			list.visitBtn	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_FRIENDHOUSELIST_ENTREE") ) -- "입장" )
			list.visitBtn	:addInputEvent("Mouse_LUp", "FriendHouseRank_VisitFriend( " .. listIdx .. ", true )")
			count = count + 1
		end
	end

	_PA_LOG("유흥신", " FriendHouseRank:Update() - UIScroll.SetButtonSize " .. self._createListCount .. " " ..self._listCount )
	
	UIScroll.SetButtonSize			( self._scroll, self._createListCount, self._listCount )
end

function FriendHouseRank_VisitFriend( index, isUse )
	if true == isUse then
		housing_SelectVisitableHouse(index)
	else
		housing_visitEmptyHouse()
	end
	FriendHouseRank_Close()
end

function FriendHouseRank_SelectTab( idx )
	local self = FriendHouseRank
	for listIdx = 0, self._createListCount - 1 do	-- 리스트 초기화.
		local list = self._listPool[listIdx]
		list.name		:SetShow( false )
		list.visitBtn	:SetShow( false )
	end
	self._startIndex = 0;
	UIScroll.SetButtonSize			( self._scroll, self._createListCount, 0 )
	
	-- VisitableHouseType_Rankers			= 0,	// 랭커의 집 들어가기
	-- VisitableHouseType_Friends,			= 1		// 친구집
	-- VisitableHouseType_GuildMemebers		= 2		// 길드집
	-- VisitableHouseType_Party,			= 3		// 파티
	self._selectedTabIdx = idx
	housing_SelectVisitableHouseType( self._selectedTabIdx )	-- 탭선택!
end

function FriendHouseRank_ScrollEvent( isScrollUp )
	local	self		= FriendHouseRank
	self._startIndex	= UIScroll.ScrollEvent( self._scroll, isScrollUp, self._createListCount, self._listCount, self._startIndex, 1 )
	
	_PA_LOG( "유흥신", "FriendHouseRank_ScrollEvent " .. self._startIndex );
	
	self:Update()
end

function FGlobal_FriendHouseRank_Open()
	local self		= FriendHouseRank
	local scrSizeX	= getScreenSizeX()
	local scrSizeY	= getScreenSizeY()
	local posX = scrSizeX - (scrSizeX/2) + (Panel_Interaction_FriendHouseList:GetSizeY()/3)
	local posY = scrSizeY - (scrSizeY/2) - (Panel_Interaction_FriendHouseList:GetSizeY()/2)
	
	Panel_Interaction_FriendHouseList:SetPosX( string.format( "%.0f", posX ) )
	Panel_Interaction_FriendHouseList:SetPosY( string.format( "%.0f", posY ) )

	if not Panel_Interaction_FriendHouseList:GetShow() then
		Panel_Interaction_FriendHouseList:SetShow( true )
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	end

	-- self._selectedTabIdx = 0
	-- for tabIdx = 0, self._createTabCount - 1 do
	-- 	local tab = self._tabPool[tabIdx]
	-- 	tab:SetCheck( false )
	-- end
	-- self._tabPool[0]:SetCheck( true )
	self:Update()
end

function FriendHouseRank_Close()
	if not Panel_Interaction_FriendHouseList:GetShow() then
		return
	end
	if Panel_Interaction_FriendHouseList:GetShow() then
		Panel_Interaction_FriendHouseList:SetShow( false )
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
	end
end

function FromCLient_Interaction_FriendHouseRank_Update( type )
	local self = FriendHouseRank
	self._selectedTabIdx = type
	FGlobal_FriendHouseRank_Open()
	-- self:Update()
end


registerEvent( "EventUpdateHouseRankerList",	"FGlobal_FriendHouseRank_Open" )
registerEvent( "EventUpdateVisitableHouseList",	"FromCLient_Interaction_FriendHouseRank_Update" )


FriendHouseRank:Initialize()
FriendHouseRank:registEventHandler()
FriendHouseRank:registMessageHandler()
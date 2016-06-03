local UI_TM 		= CppEnums.TextMode
local UI_color 		= Defines.Color
local UCT 			= CppEnums.PA_UI_CONTROL_TYPE

----------------------------------------------------------------------------------------------------------------
local _constGuildListMaxCount 	= 150	-- 리스트 최대 표시 갯수
local _startMemberIndex 		= 0		-- 스크롤 변경시 사용 변수
local frame_Warfare				= nil
local content_Warfare			= nil
----------------------------------------------------------------------------------------------------------------
--									길드원 현황 프레임 불러오기
----------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------
--					전쟁현황 관리
------------------------------------------------------------------
GuildWarfareInfoPage =
{	
	_frameDefaultBG_Warfare	= UI.getChildControl ( Panel_Window_Guild, "Static_Frame_WarfareBG" ),
	_scrollBar,
	-- _scrollBarCtrl,
	_list = {}
}
--[[
GuildWarfareInfoPage
	initialize()
	UpdateData()
	Show()
	Hide()
	_list : rtGuildWarfareInfo의 리스트	
		rtGuildWarfareInfo로 검색해서 맴버 확인 요망		
]]--


-- 성채 파괴
-- 지휘소 파괴
-- 성문 파괴
-- 도움 회수
-- 소환수 처리
-- 설치물 파괴
-- 대장 처치
-- 부대장 처치
-- 길드원 처치
-- 사망 회수

------------------------------------------------------------------
--				각 아이콘 설명 풍선 띄워주기
------------------------------------------------------------------
local _iconHelper 	= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_IconHelper" )

local ui_Icons = 
{
	[0]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_CommandCenter" ),
	[1]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_Tower" ),
	[2]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_CastleGate" ),
	[3]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_Help" ),
	[4]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_Summons" ),
	[5]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_Installation" ),
	[6]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_Master" ),
	[7]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_Commander" ),
	[8]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_Member" ),
	[9]  	= UI.getChildControl ( Panel_Guild_Warfare, "Static_M_Death" ),
	[10]  	= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_M_CharName" ),
}

----- 정렬 관련 변수, 배열 ------------------
local staticText_CommandCenter	= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_CommandCenter" )
local staticText_Tower			= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_Tower" )
local staticText_CastleGate		= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_CastleGate" )
local staticText_Help			= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_Help" )
local staticText_Summons		= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_Summons" )
local staticText_Installation	= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_Installation" )
local staticText_Master			= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_Master" )
local staticText_Commander		= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_Commander" )
local staticText_Member			= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_Member" )
local staticText_Death			= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_Death" )
local staticText_CharName		= UI.getChildControl ( Panel_Guild_Warfare, "StaticText_S_CharName" )

local _selectSortType = 10
local _listSort	= {
	command			= false,
	tower			= false,
	castlegate		= false,
	help			= false,
	summons			= false,
	installation	= false,
	master			= false,
	commander		= false,
	member			= false,
	death			= false,
	name			= false,
}
local tempGuildWarfareList = {}

for iconidx = 0, 10 do
	ui_Icons[iconidx]	:addInputEvent("Mouse_LUp",	"HandleClicked_GuildWarfareListSort( " .. iconidx .. " )")
end
---------------------------------------------

function Panel_Guild_Warfare_Icon_ToolTip_Func()
	for idx = 0 , 9 do
		ui_Icons[idx]:addInputEvent ( "Mouse_On", "Panel_Guild_Warfare_Icon_ToolTip_Show(".. idx ..", true )" )
		ui_Icons[idx]:addInputEvent ( "Mouse_Out", "Panel_Guild_Warfare_Icon_ToolTip_Show(".. idx ..", false )" )
	end
end

function Panel_Guild_Warfare_Icon_ToolTip_Show( iconNo, isOn )
	local mouse_posX = getMousePosX()
	local mouse_posY = getMousePosY()
	
	local panel_posX = GuildWarfareInfoPage._frameDefaultBG_Warfare:GetParentPosX()
	local panel_posY = GuildWarfareInfoPage._frameDefaultBG_Warfare:GetParentPosY()
	
	_iconHelper:SetPosX( mouse_posX - panel_posX  )
	_iconHelper:SetPosY( mouse_posY - panel_posY + 15 )
	
	if ( isOn == true ) then
		if ( iconNo == 0 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_COMMAND" ) )	-- 지휘소 파괴
			
		elseif ( iconNo == 1 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_TOWER" ) )		-- 성채 파괴
			
		elseif ( iconNo == 2 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_DOOR" ) )		-- 성문 파괴
			
		elseif ( iconNo == 3 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_HELPER" ) )		-- 도움 횟수
			
		elseif ( iconNo == 4 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_SUMMON" ) )		-- 소환수 처치
			
		elseif ( iconNo == 5 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_OBJECT" ) )		-- 설치물 파괴
			
		elseif ( iconNo == 6 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_MASTER" ) )		-- 대장 처치
			
		elseif ( iconNo == 7 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_COMMANDER" ) )	-- 부대장 처치
			
		elseif ( iconNo == 8 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_MEMBER" ) )		-- 길드원 처치
			
		elseif ( iconNo == 9 ) then
			_iconHelper:SetShow ( true )
			_iconHelper:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_DEATH" ) )		-- 사망 횟수
		end
	else
		_iconHelper:SetShow ( false )
	end
end

------------------------------------------------------------------
--		최초 초기화 해주는 함수	(Panel_Guild.lua 에서 사용)
------------------------------------------------------------------
local frameSizeY = 0
local contentSizeY = 0

function GuildWarfareInfoPage:initialize()
	Panel_Guild_Warfare_Icon_ToolTip_Func()		-- 아이콘별 설명서 띄워주기 함수
	
	local constStartY = 5

	frame_Warfare				= UI.getChildControl ( Panel_Guild_Warfare, "Frame_GuildWarfare" )
	content_Warfare				= UI.getChildControl ( frame_Warfare, 		"Frame_1_Content" )
	
	
	contentSizeY = content_Warfare:GetSizeY()
	
	local copyCharName			= UI.getChildControl ( content_Warfare, 	"StaticText_C_CharName" )
	local copyTower		 		= UI.getChildControl ( content_Warfare, 	"StaticText_C_Tower" )
	local copyCommandCenter 	= UI.getChildControl ( content_Warfare, 	"StaticText_C_CommandCenter" )
	local copyCastleGate	 	= UI.getChildControl ( content_Warfare, 	"StaticText_C_CastleGate" )
	local copyHelp			 	= UI.getChildControl ( content_Warfare, 	"StaticText_C_Help" )
	local copySummons		 	= UI.getChildControl ( content_Warfare, 	"StaticText_C_Summons" )
	local copyInstallation	 	= UI.getChildControl ( content_Warfare, 	"StaticText_C_Installation" )
	local copyMaster		 	= UI.getChildControl ( content_Warfare, 	"StaticText_C_Master" )
	local copyCommander	 		= UI.getChildControl ( content_Warfare, 	"StaticText_C_Commander" )
	local copyMember		 	= UI.getChildControl ( content_Warfare, 	"StaticText_C_Member" )
	local copyDeath		 		= UI.getChildControl ( content_Warfare, 	"StaticText_C_Death" )
	local copyPartline		 	= UI.getChildControl ( content_Warfare, 	"Static_C_PartLine" )
	
	-- 스크롤 관련 부분------------------------------------------------
	self._scrollBar 			= UI.getChildControl ( frame_Warfare, 				"VerticalScroll" )
	UIScroll.InputEvent( self._scrollBar, "GuildWarfareMouseScrollEvent" )
	
	content_Warfare:addInputEvent("Mouse_UpScroll",		"GuildWarfareMouseScrollEvent( true )" )
	content_Warfare:addInputEvent("Mouse_DownScroll",	"GuildWarfareMouseScrollEvent( false )" )
	---------------------------------------------------------------------
	
	function createWarfareInfo( pIndex )	
		local rtGuildWarfareInfo = {}
	
		rtGuildWarfareInfo._txtCharName 		= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_CharName_"..pIndex )
		rtGuildWarfareInfo._txtTower 			= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_Tower_"..pIndex )
		rtGuildWarfareInfo._txtCommandCenter 	= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_CommandCenter_"..pIndex )
		rtGuildWarfareInfo._txtCastleGate 		= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_CastleGate_"..pIndex )
		rtGuildWarfareInfo._txtHelp 			= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_Help_"..pIndex )
		rtGuildWarfareInfo._txtSummons 			= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_Summons_"..pIndex )
		rtGuildWarfareInfo._txtInstallation 	= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_Installation_"..pIndex )
		rtGuildWarfareInfo._txtMaster 			= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_Master_"..pIndex )
		rtGuildWarfareInfo._txtCommander 		= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_Commander_"..pIndex )
		rtGuildWarfareInfo._txtMember 			= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_Member_"..pIndex )
		rtGuildWarfareInfo._txtDeath 			= UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, content_Warfare, "StaticText_C_Death_"..pIndex )
		rtGuildWarfareInfo._Partline 			= UI.createControl(UCT.PA_UI_CONTROL_STATIC,	 content_Warfare, "Static_C_PartLine_"..pIndex )
		
		CopyBaseProperty( copyCharName, 		rtGuildWarfareInfo._txtCharName )
		CopyBaseProperty( copyTower, 			rtGuildWarfareInfo._txtTower )
		CopyBaseProperty( copyCommandCenter, 	rtGuildWarfareInfo._txtCommandCenter )
		CopyBaseProperty( copyCastleGate, 		rtGuildWarfareInfo._txtCastleGate )
		CopyBaseProperty( copyHelp, 			rtGuildWarfareInfo._txtHelp )
		CopyBaseProperty( copySummons, 			rtGuildWarfareInfo._txtSummons )
		CopyBaseProperty( copyInstallation, 	rtGuildWarfareInfo._txtInstallation )
		CopyBaseProperty( copyMaster, 			rtGuildWarfareInfo._txtMaster )
		CopyBaseProperty( copyCommander, 		rtGuildWarfareInfo._txtCommander )
		CopyBaseProperty( copyMember, 			rtGuildWarfareInfo._txtMember )
		CopyBaseProperty( copyDeath, 			rtGuildWarfareInfo._txtDeath )
		CopyBaseProperty( copyPartline, 		rtGuildWarfareInfo._Partline )
		
		rtGuildWarfareInfo._txtCharName			:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtTower			:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtCommandCenter	:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtCastleGate		:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtHelp				:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtSummons			:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtInstallation		:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtMaster			:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtCommander		:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtMember			:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._txtDeath			:SetPosY( constStartY + pIndex * 25 )
		rtGuildWarfareInfo._Partline			:SetPosY( pIndex * 25 )
		
		rtGuildWarfareInfo._txtCharName			:SetIgnore( false )
		rtGuildWarfareInfo._txtTower			:SetIgnore( false )
		rtGuildWarfareInfo._txtCommandCenter	:SetIgnore( false )
		rtGuildWarfareInfo._txtCastleGate		:SetIgnore( false )
		rtGuildWarfareInfo._txtHelp				:SetIgnore( false )
		rtGuildWarfareInfo._txtSummons			:SetIgnore( false )
		rtGuildWarfareInfo._txtInstallation		:SetIgnore( false )
		rtGuildWarfareInfo._txtMaster			:SetIgnore( false )
		rtGuildWarfareInfo._txtCommander		:SetIgnore( false )
		rtGuildWarfareInfo._txtMember			:SetIgnore( false )
		rtGuildWarfareInfo._txtDeath			:SetIgnore( false )
		rtGuildWarfareInfo._Partline			:SetIgnore( false )
		
		rtGuildWarfareInfo._txtCharName			:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtTower			:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtCommandCenter	:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtCastleGate		:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtHelp				:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtSummons			:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtInstallation		:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtMaster			:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtCommander		:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtMember			:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		rtGuildWarfareInfo._txtDeath			:addInputEvent( "Mouse_UpScroll", 		"GuildWarfareMouseScrollEvent(true)")
		
		rtGuildWarfareInfo._txtCharName			:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtTower			:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtCommandCenter	:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtCastleGate		:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtHelp				:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtSummons			:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtInstallation		:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtMaster			:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtCommander		:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtMember			:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")
		rtGuildWarfareInfo._txtDeath			:addInputEvent( "Mouse_DownScroll", 	"GuildWarfareMouseScrollEvent(false)")

		function rtGuildWarfareInfo:SetShow( isShow )
			rtGuildWarfareInfo._txtCharName:SetShow(isShow)
			rtGuildWarfareInfo._txtTower:SetShow(isShow)
			rtGuildWarfareInfo._txtCommandCenter:SetShow(isShow)
			rtGuildWarfareInfo._txtCastleGate:SetShow(isShow)
			rtGuildWarfareInfo._txtHelp:SetShow(isShow)
			rtGuildWarfareInfo._txtSummons:SetShow(isShow)
			rtGuildWarfareInfo._txtInstallation:SetShow(isShow)
			rtGuildWarfareInfo._txtMaster:SetShow(isShow)
			rtGuildWarfareInfo._txtCommander:SetShow(isShow)
			rtGuildWarfareInfo._txtMember:SetShow(isShow)
			rtGuildWarfareInfo._txtDeath:SetShow(isShow)
			rtGuildWarfareInfo._Partline:SetShow(isShow)
		end

		return rtGuildWarfareInfo
	end
	
	for index=0, _constGuildListMaxCount-1, 1 do
		self._list[index] = createWarfareInfo(index)
	end		
	
	UI.deleteControl( copyCharName )
	UI.deleteControl( copyTower )
	UI.deleteControl( copyCommandCenter )
	UI.deleteControl( copyCastleGate )
	UI.deleteControl( copyHelp )
	UI.deleteControl( copySummons )
	UI.deleteControl( copyInstallation )
	UI.deleteControl( copyMaster )
	UI.deleteControl( copyCommander )
	UI.deleteControl( copyMember )
	UI.deleteControl( copyDeath )
	UI.deleteControl( copyPartline )	
	
	copyCharName = nil
	copyTower = nil
	copyCommandCenter = nil
	copyCastleGate = nil
	copyHelp = nil
	copySummons = nil
	copyInstallation = nil
	copyMaster = nil
	copyCommander = nil
	copyMember = nil
	copyDeath = nil
	copyPartline = nil

	frameSizeY = frame_Warfare:GetSizeY()
	
	frame_Warfare:UpdateContentScroll()
	frame_Warfare:UpdateContentPos()
	
	self._frameDefaultBG_Warfare:MoveChilds( self._frameDefaultBG_Warfare:GetID(), Panel_Guild_Warfare )
	UI.deletePanel(Panel_Guild_Warfare:GetID())	
	Panel_Guild_Warfare = nil
end

----------------------------------------------------------------------
-- 			스크롤 버튼 사용시
----------------------------------------------------------------------
function GuildWarfareMouseScrollEvent( isUpScroll )
	local memberCount = ToClient_GetMyGuildInfoWrapper():getMemberCount()
	
	UIScroll.ScrollEvent( GuildWarfareInfoPage._scrollBar, isUpScroll, memberCount, memberCount, 0, 1 )
	GuildWarfareInfoPage:UpdateData()
end

----------------------------------------------------------------------
-- 			정렬 관련 함수
----------------------------------------------------------------------
function GuildWarfareInfoPage:TitleLineReset()	-- 정렬 아이콘 초기화 (감춤)
	staticText_CommandCenter:SetShow(false)
	staticText_Tower		:SetShow(false)
	staticText_CastleGate	:SetShow(false)
	staticText_Help			:SetShow(false)
	staticText_Summons		:SetShow(false)
	staticText_Installation	:SetShow(false)
	staticText_Master		:SetShow(false)
	staticText_Commander	:SetShow(false)
	staticText_Member		:SetShow(false)
	staticText_Death		:SetShow(false)
	staticText_CharName		:SetShow(false)
end


function GuildWarfareInfoPage:SetGuildList()
	local myGuildWarfareListInfo	= ToClient_GetMyGuildInfoWrapper()
	local memberCount				= myGuildWarfareListInfo:getMemberCount()
	
	for index = 1, memberCount do
		local myGuildMemberInfo = myGuildWarfareListInfo:getMember( index-1 )
		tempGuildWarfareList[index] = {
			idx				= index-1,
			command			= myGuildMemberInfo:commandPostCount(),
			tower			= myGuildMemberInfo:towerCount(),
			castlegate		= myGuildMemberInfo:gateCount(),
			help			= myGuildMemberInfo:assistCount(),
			summons			= myGuildMemberInfo:summonedCount(),
			installation	= myGuildMemberInfo:obstacleCount(),
			master			= myGuildMemberInfo:guildMasterCount(),
			commander		= myGuildMemberInfo:squadLeaderCount(),
			member			= myGuildMemberInfo:squadMemberCount(),
			death			= myGuildMemberInfo:deathCount(),
			name			= myGuildMemberInfo:getName(),
		}
	end
end

---- 정렬함수 2번째 인자값 -----------------------------------
local guildListCompareCommandCenter = function ( w1, w2 )
	if true == _listSort.command then
		if w1.command < w2.command then
			return true
		end
	else
		if w2.command < w1.command then
			return true
		end
	end
end
local guildListCompareTower = function ( w1, w2 )
	if true == _listSort.tower then
		if w2.tower < w1.tower then
			return true
		end
	else
		if w1.tower < w2.tower then
			return true
		end
	end
end
local guildListCompareCastleGate = function ( w1, w2 )
	if true == _listSort.castlegate then
		if w2.castlegate < w1.castlegate then
			return true
		end
	else
		if w1.castlegate < w2.castlegate then
			return true
		end
	end
end
local guildListCompareHelp = function ( w1, w2 )
	if true == _listSort.help then
		if w1.help < w2.help then
			return true
		end
	else
		if w2.help < w1.help then
			return true
		end
	end
end
local guildListCompareSummons = function ( w1, w2 )
	if true == _listSort.summons then
		if w2.summons < w1.summons then
			return true
		end
	else
		if w1.summons < w2.summons then
			return true
		end
	end
end
local guildListCompareInstallation = function ( w1, w2 )
	if true == _listSort.installation then
		if w2.installation < w1.installation then
			return true
		end
	else
		if w1.installation < w2.installation then
			return true
		end
	end
end
local guildListCompareMaster = function ( w1, w2 )
	if true == _listSort.master then
		if w2.master < w1.master then
			return true
		end
	else
		if w1.master < w2.master then
			return true
		end
	end
end
local guildListCompareCommander = function ( w1, w2 )
	if true == _listSort.commander then
		if w2.commander < w1.commander then
			return true
		end
	else
		if w1.commander < w2.commander then
			return true
		end
	end
end
local guildListCompareMember = function ( w1, w2 )
	if true == _listSort.member then
		if w2.member < w1.member then
			return true
		end
	else
		if w1.member < w2.member then
			return true
		end
	end
end
local guildListCompareDeath = function ( w1, w2 )
	if true == _listSort.death then
		if w2.death < w1.death then
			return true
		end
	else
		if w1.death < w2.death then
			return true
		end
	end
end
local guildListCompareCharName = function ( w1, w2 )
	if true == _listSort.name then
		if w2.name < w1.name then
			return true
		end
	else
		if w1.name < w2.name then
			return true
		end
	end
end


function HandleClicked_GuildWarfareListSort( sortType )
	_selectSortType = sortType
	GuildWarfareInfoPage:TitleLineReset()
	
	if 0 == sortType then
		if false == _listSort.command then
			staticText_CommandCenter:SetText("▲")
			_listSort.command = true
		else
			staticText_CommandCenter:SetText("▼")
			_listSort.command = false
		end
		staticText_CommandCenter:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareCommandCenter )	
	elseif 1 == sortType then
		if false == _listSort.tower then
			staticText_Tower:SetText("▲")
			_listSort.tower = true
		else
			staticText_Tower:SetText("▼")
			_listSort.tower = false
		end
		staticText_Tower:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareTower )	
	elseif 2 == sortType then
		if false == _listSort.castlegate then
			staticText_CastleGate:SetText("▲")
			_listSort.castlegate = true
		else
			staticText_CastleGate:SetText("▼")
			_listSort.castlegate = false
		end
		staticText_CastleGate:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareCastleGate )
	elseif 3 == sortType then
		if false == _listSort.help then
			staticText_Help:SetText("▲")
			_listSort.help = true
		else
			staticText_Help:SetText("▼")
			_listSort.help = false
		end
		staticText_Help:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareHelp )
	elseif 4 == sortType then
		if false == _listSort.summons then
			staticText_Summons:SetText("▲")
			_listSort.summons = true
		else
			staticText_Summons:SetText("▼")
			_listSort.summons = false
		end
		staticText_Summons:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareSummons )
	elseif 5 == sortType then
		if false == _listSort.installation then
			staticText_Installation:SetText("▲")
			_listSort.installation = true
		else
			staticText_Installation:SetText("▼")
			_listSort.installation = false
		end
		staticText_Installation:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareInstallation )
	elseif 6 == sortType then
		if false == _listSort.master then
			staticText_Master:SetText("▲")
			_listSort.master = true
		else
			staticText_Master:SetText("▼")
			_listSort.master = false
		end
		staticText_Master:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareMaster )		
	elseif 7 == sortType then
		if false == _listSort.commander then
			staticText_Commander:SetText("▲")
			_listSort.commander = true
		else
			staticText_Commander:SetText("▼")
			_listSort.commander = false
		end
		staticText_Commander:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareCommander )
	elseif 8 == sortType then
		if false == _listSort.member then
			staticText_Member:SetText("▲")
			_listSort.member = true
		else
			staticText_Member:SetText("▼")
			_listSort.member = false
		end
		staticText_Member:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareMember )
	elseif 9 == sortType then
		if false == _listSort.death then
			staticText_Death:SetText("▲")
			_listSort.death = true
		else
			staticText_Death:SetText("▼")
			_listSort.death = false
		end
		staticText_Death:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareDeath )	
	elseif 10 == sortType then
		if false == _listSort.name then
			staticText_CharName:SetText("▲")
			_listSort.name = true
		else
			staticText_CharName:SetText("▼")
			_listSort.name = false
		end
		staticText_CharName:SetShow(true)
		table.sort( tempGuildWarfareList, guildListCompareCharName )	
	end
	GuildWarfareInfoPage:UpdateData()
end


function GuildWarfareInfoPage:GuildListSortSet()
	GuildWarfareInfoPage:TitleLineReset()
	staticText_CharName:SetText("▲")
	_listSort.name = true
	staticText_CharName:SetShow(true)
	table.sort( tempGuildWarfareList, guildListCompareCharName )
end


function GuildWarfareInfoPage:updateSort()
	if 0 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareCommandCenter )
	elseif 1 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareTower )
	elseif 2 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareCastleGate )
	elseif 3 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareHelp )
	elseif 4 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareSummons )
	elseif 5 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareInstallation )
	elseif 6 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareMaster )
	elseif 7 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareCommander )
	elseif 8 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareMember )
	elseif 9 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareDeath )
	elseif 10 == _selectSortType then
		table.sort( tempGuildWarfareList, guildListCompareCharName )
	end
end


----------------------------------------------------------------------
-- 				업데이트 해주는 함수
----------------------------------------------------------------------
function GuildWarfareInfoPage:UpdateData()
	GuildWarfareInfoPage:SetGuildList()
	GuildWarfareInfoPage:updateSort()

	local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
	
	if nil == myGuildInfo then
		return
	end
	
	contentSizeY = 0
	for index=0, _constGuildListMaxCount-1, 1 do
		self._list[index]:SetShow(false)
	end

	local memberCount = myGuildInfo:getMemberCount()
	
	for index = 0, memberCount - 1, 1 do
		local dataIdx = tempGuildWarfareList[index+1].idx

		local myGuildMemberInfo = myGuildInfo:getMember( dataIdx )
		if( nil == myGuildMemberInfo ) then
			return
		end
		
		if myGuildMemberInfo:isOnline() then
			if myGuildMemberInfo:isSelf() then
				self._list[index]._txtCharName		:SetFontColor( UI_color.C_FFEF9C7F )
			else
				self._list[index]._txtCharName		:SetFontColor( UI_color.C_FFC4BEBE )	
			end
			self._list[index]._txtCharName			:SetText(myGuildMemberInfo:getName() .. " (" .. myGuildMemberInfo:getCharacterName() .. ")")
			self._list[index]._txtCommandCenter		:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtTower				:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtCastleGate		:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtHelp				:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtSummons			:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtInstallation		:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtMaster			:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtCommander			:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtMember			:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._txtDeath				:SetFontColor( UI_color.C_FFC4BEBE )
		else
			self._list[index]._txtCharName			:SetText(myGuildMemberInfo:getName() .. " ( - )")
			self._list[index]._txtCharName			:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtCommandCenter		:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtTower				:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtCastleGate		:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtHelp				:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtSummons			:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtInstallation		:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtMaster			:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtCommander			:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtMember			:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._txtDeath				:SetFontColor( UI_color.C_FF515151 )
		end
		
		self._list[index]._txtCommandCenter		:SetText(myGuildMemberInfo:commandPostCount())
		self._list[index]._txtTower				:SetText(myGuildMemberInfo:towerCount())
		self._list[index]._txtCastleGate		:SetText(myGuildMemberInfo:gateCount())
		self._list[index]._txtHelp				:SetText(myGuildMemberInfo:assistCount())
		self._list[index]._txtSummons			:SetText(myGuildMemberInfo:summonedCount())
		self._list[index]._txtInstallation		:SetText(myGuildMemberInfo:obstacleCount())
		self._list[index]._txtMaster			:SetText(myGuildMemberInfo:guildMasterCount())
		self._list[index]._txtCommander			:SetText(myGuildMemberInfo:squadLeaderCount())
		self._list[index]._txtMember			:SetText(myGuildMemberInfo:squadMemberCount())
		self._list[index]._txtDeath				:SetText(myGuildMemberInfo:deathCount())

		contentSizeY = contentSizeY + self._list[index]._txtCharName:GetSizeY() + 2
		content_Warfare:SetSize(content_Warfare:GetSizeX(), contentSizeY )
	end
	
	for index=0, _constGuildListMaxCount - 1, 1 do
		if (_startMemberIndex + index) < memberCount then
			self._list[index]:SetShow(true)
		else
			self._list[index]:SetShow(false)
		end
	end
	
	if ( frameSizeY >= contentSizeY ) then
		self._scrollBar:SetShow( false )
	else
		self._scrollBar:SetShow( true )
	end
	
	frame_Warfare:UpdateContentScroll()
	frame_Warfare:UpdateContentPos()
end

----------------------------------------------------------------------
-- 					길드 현황을 켜고 끄는 함수 (Panel_Guild.lua 에서 사용)
----------------------------------------------------------------------
function GuildWarfareInfoPage:Show()
	-- if false == self._frameDefaultBG_Warfare:GetShow() then
		self._frameDefaultBG_Warfare:SetShow( true )
		self._scrollBar:SetControlPos( 0 )
		self:SetGuildList()
		_selectSortType = 10
		self:GuildListSortSet()
		self:UpdateData()
	-- end
end

function GuildWarfareInfoPage:Hide()
	if true == self._frameDefaultBG_Warfare:GetShow() then
		self._frameDefaultBG_Warfare:SetShow( false )
	end
end

----------------------------------------------------------------------
--	클라이언트에서 보내는 이벤트
----------------------------------------------------------------------
registerEvent("Event_SiegeScoreUpdateData", "FromClient_GuildWarfareInfoUpdate")

function FromClient_GuildWarfareInfoUpdate()
	GuildWarfareInfoPage:UpdateData()
end
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local IM            = CppEnums.EProcessorInputMode

Panel_Guild_Rank:SetShow( false, false )

Panel_Guild_Rank:RegisterShowEventFunc( true, 'GuildRankingShowAni()' )
Panel_Guild_Rank:RegisterShowEventFunc( false, 'GuildRankingHideAni()' )

function GuildRankingShowAni()
	UIAni.fadeInSCR_Down( Panel_Guild_Rank )

	local aniInfo1 = Panel_Guild_Rank:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.2)
	aniInfo1.AxisX = Panel_Guild_Rank:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Guild_Rank:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Guild_Rank:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.2)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Guild_Rank:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Guild_Rank:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end
function GuildRankingHideAni()
	local aniInfo1 = Panel_Guild_Rank:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

local guildRanking = {
	_txtTitle			= UI.getChildControl( Panel_Guild_Rank, "StaticText_Title" ),
	_btnClose			= UI.getChildControl( Panel_Guild_Rank, "Button_Win_Close" ),
	_btnHelp			= UI.getChildControl( Panel_Guild_Rank, "Button_Question" ),
	_scroll				= UI.getChildControl( Panel_Guild_Rank, "Scroll_RankingList" ),
	_listBg				= UI.getChildControl( Panel_Guild_Rank, "Static_RankListBG" ),
	
	guildRankNum		= UI.getChildControl( Panel_Guild_Rank, "StaticText_RankNum" ),
	guildRankGuildName	= UI.getChildControl( Panel_Guild_Rank, "StaticText_GuildName" ),
	guildRankFamilyName	= UI.getChildControl( Panel_Guild_Rank, "StaticText_FamilyName" ),
	iconSerendia		= UI.getChildControl( Panel_Guild_Rank, "Static_Serendia" ),
	iconBalenos			= UI.getChildControl( Panel_Guild_Rank, "Static_Balenos" ),
	iconKalpeon			= UI.getChildControl( Panel_Guild_Rank, "Static_Kalpeon" ),
	iconMedia			= UI.getChildControl( Panel_Guild_Rank, "Static_Media" ),
	iconBalencia		= UI.getChildControl( Panel_Guild_Rank, "Static_Balencia" ),
	guildRankNode		= UI.getChildControl( Panel_Guild_Rank, "StaticText_NodeOccupation"),
	guildDuelWar		= UI.getChildControl( Panel_Guild_Rank, "StaticText_GuildDuelWar"),
	guildRankPersonnel	= UI.getChildControl( Panel_Guild_Rank, "StaticText_Personnel" ),
	guildRankPoint		= UI.getChildControl( Panel_Guild_Rank, "StaticText_GuildPoint" ),

	_createListCount	= 25,
	territoryCount		= 4,
	_listCount			= 0,
	_startIndex			= 0,
	_selectPage			= 0,
	_selectMaxPage		= 0,
	_listPool			= {},

	_posConfig = {
		_listStartPosY 	= 88,
		_iconStartPosY	= 88,
		_listPosYGap 	= 19.7,
	},
}

local _txt_page = UI.getChildControl( Panel_Guild_Rank, "Static_PageNo")
local _btn_Prev = UI.getChildControl( Panel_Guild_Rank, "Button_Prev" )
local _btn_Next = UI.getChildControl( Panel_Guild_Rank, "Button_Next" )
local _web_Desc = UI.getChildControl( Panel_Guild_Rank, "StaticText_Web_Desc" )

function guildRanking_Initionalize()

	------ 서비스타입에 따라 길드 웹페이지 연결 안내문구 노출
	if 0 == getGameServiceType() or 1 == getGameServiceType() or 2 == getGameServiceType() or 3 == getGameServiceType() or 4 == getGameServiceType() then
		_web_Desc:SetShow(true)
	else
		_web_Desc:SetShow(false)
	end
	--------------------------------------------------------
		
	local self = guildRanking
	for listIdx = 0, self._createListCount - 1 do
		local rankList = {}
		-- 순위
		rankList.rank = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_RankNum", Panel_Guild_Rank, "guildRanking_Rank_"	.. listIdx )
		rankList.rank:SetPosX( 47 )
		rankList.rank:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
		-- 길드명
		rankList.guild = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_GuildName", Panel_Guild_Rank, "guildRanking_Name_" .. listIdx )
		rankList.guild:SetPosX( 80 )
		rankList.guild:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
		rankList.guild:SetIgnore( false )
		rankList.guild:SetEnableArea( 0, 0, 190,15 )
		-- 길드대장 가문명
		rankList.familyName = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_FamilyName", Panel_Guild_Rank, "guildRanking_Guild_" .. listIdx )
		rankList.familyName:SetPosX( 260 )
		rankList.familyName:SetPosY( self._posConfig._listStartPosY + (self._posConfig._listPosYGap * listIdx ) )
	--{ 아이콘 4개 영지별(발렌시아 영지가 추가되면 추가 작업을 해주도록 하자.)발렌시
		rankList.icon1 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "Static_Serendia", Panel_Guild_Rank, "guildRanking_IconSerendia_" .. listIdx )
		rankList.icon1:SetPosX( 430 )
		rankList.icon1:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )

		rankList.icon2 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "Static_Balenos", Panel_Guild_Rank, "guildRanking_IconBalenos_" .. listIdx )
		rankList.icon2:SetPosX( 497 )
		rankList.icon2:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )

		rankList.icon3 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "Static_Kalpeon", Panel_Guild_Rank, "guildRanking_IconKalpeon_" .. listIdx )
		rankList.icon3:SetPosX( 522 )
		rankList.icon3:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )

		rankList.icon4 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "Static_Media", Panel_Guild_Rank, "guildRanking_IconMedia_" .. listIdx )
		rankList.icon4:SetPosX( 547 )
		rankList.icon4:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )

		rankList.icon5 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "Static_Balencia", Panel_Guild_Rank, "guildRanking_IconBalencia_" .. listIdx )
		rankList.icon5:SetPosX( 572 )
		rankList.icon5:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
	--}
	--{ 점령전 미점령 길드 dash(-)
		rankList.dash1 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_Dash1", Panel_Guild_Rank, "guildRanking_DashSerendia_" .. listIdx )
		rankList.dash1:SetPosX( 469 )
		rankList.dash1:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )

		-- rankList.dash2 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_Dash2", Panel_Guild_Rank, "guildRanking_DashBalenos_" .. listIdx )
		-- rankList.dash2:SetPosX( 500 )
		-- rankList.dash2:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )

		-- rankList.dash3 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_Dash3", Panel_Guild_Rank, "guildRanking_DashKalpeon_" .. listIdx )
		-- rankList.dash3:SetPosX( 525 )
		-- rankList.dash3:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )

		-- rankList.dash4 = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_Dash4", Panel_Guild_Rank, "guildRanking_DashMedia_" .. listIdx )
		-- rankList.dash4:SetPosX( 550 )
		-- rankList.dash4:SetPosY( self._posConfig._iconStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
	--}
		-- 점령 거점 수
		rankList.node = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_NodeOccupation", Panel_Guild_Rank, "guildRanking_Node_" .. listIdx )
		rankList.node:SetPosX( 550 )
		rankList.node:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
		-- 길드 결전 승/패
		rankList.duelWar = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_GuildDuelWar", Panel_Guild_Rank, "guildRanking_DuelWar_" .. listIdx )
		rankList.duelWar:SetPosX( 630 )
		rankList.duelWar:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
		-- 길드원 수
		rankList.personnel = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_Personnel", Panel_Guild_Rank, "guildRanking_Personnel_" .. listIdx )
		rankList.personnel:SetPosX( 710 )
		rankList.personnel:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
		--길드 점수
		rankList.point = UI.createAndCopyBasePropertyControl( Panel_Guild_Rank, "StaticText_GuildPoint", Panel_Guild_Rank, "guildRanking_GuildPoint_" .. listIdx )
		rankList.point:SetPosX( 785 )
		rankList.point:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )

		self._listPool[listIdx] = rankList
	end

	_btn_Next:SetAutoDisableTime(3.0)

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_Guild_Rank:SetPosX( (screenSizeX - Panel_Guild_Rank:GetSizeX()) / 2 )
	Panel_Guild_Rank:SetPosY( (screenSizeY - Panel_Guild_Rank:GetSizeY()) / 2 )
end

function guildRanking:Update()
	for listIdx = 0, self._createListCount - 1 do	-- 리스트 초기화.
		local list = self._listPool[listIdx]
		list.rank				:SetShow( false )
		list.guild				:SetShow( false )
		list.familyName			:SetShow( false )
		list.icon1				:SetShow( false )
		list.icon2				:SetShow( false )
		list.icon3				:SetShow( false )
		list.icon4				:SetShow( false )
		list.icon5				:SetShow( false )
		list.dash1				:SetShow( false )
		-- list.dash2				:SetShow( false )
		-- list.dash3				:SetShow( false )
		-- list.dash4				:SetShow( false )		
		list.node				:SetShow( false )
		list.duelWar			:SetShow( false )
		list.personnel			:SetShow( false )
		list.point				:SetShow( false )

		-- list.guild		:addInputEvent( "Mouse_LUp", "" )
	end

	local startSlotNo	= 0
	local endSlotNo		= 0
	startSlotNo			= 0 -- self._selectPage * self._createListCount
	endSlotNo			= 25 -- startSlotNo + self._createListCount
	local maxCount		= 400
	self._selectMaxPage	= math.floor( maxCount / self._createListCount ) - 1
	if	0 < (maxCount % self._createListCount)	then
		self._selectMaxPage	= self._selectMaxPage + 1
	end

	self._listCount = ToClient_GetGuildCount()	-- 클라에서 받아온다.
	local count = 0
	for listIdx = startSlotNo, self._listCount - 1 do
		local guildRanker				= ToClient_GetGuildRankingInfoAt( listIdx )
		local guildRankerGuildMark_s64	= guildRanker:getGuildNo_s64()
		local guildRankerGuild			= guildRanker:getGuildName()				-- 길드명
		local guildRankerMasterName		= guildRanker:getGuildMasterNickName()		-- 길드마스터 가문명
		local guildRankerTerritoryCount	= guildRanker:getTerritoryCount()			-- 점령 여부( -1 : 미점령 / 0 ~ 3 점령 여부 리턴 )
		local guildRankerNodeCount		= guildRanker:getSiegeCount()				-- 점령 거점 수
		local guildRankerMemberCount	= guildRanker._guildMemberCount				-- 길드 인원수
		local guildRankerAquirePorint	= guildRanker._guildAquiredPoint			-- 길드 포인트
		local guildIntroduce			= guildRanker:getGuildIntroduction()		-- 길드 소개
		local loadComplete				= guildRanker:isLoadComplete()				-- 로딩이 되었는가!?
		local guildDuelWarWin			= guildRanker:getGuildDuelWinCount()		-- 길드 결전 승리
		local guildDuelWarLose			= guildRanker:getGuildDuelLoseCount()		-- 길드 결전 패배

		if( self._createListCount <= count ) then
			break;
		end

		local list = self._listPool[count]
		list.rank		:SetShow( true )
		list.guild		:SetShow( true )
		list.familyName	:SetShow( true )
		list.dash1		:SetShow( true )
		-- list.dash2		:SetShow( false ) -- 임시
		-- list.dash3		:SetShow( false ) -- 임시
		-- list.dash4		:SetShow( false ) -- 임시
		list.node		:SetShow( true )
		list.duelWar	:SetShow( true )
		list.personnel	:SetShow( true )
		list.point		:SetShow( true )
--{		영지 아이콘은 기본 안보여줌
		list.icon1		:SetShow( false )
		list.icon2		:SetShow( false )
		list.icon3		:SetShow( false )
		list.icon4		:SetShow( false )
		list.icon5		:SetShow( false )
--}
		list.rank		:SetFontColor(UI_color.C_FFC4BEBE)
		list.guild		:SetFontColor(UI_color.C_FFC4BEBE)
		list.familyName	:SetFontColor(UI_color.C_FFC4BEBE)
		list.duelWar	:SetFontColor(UI_color.C_FFC4BEBE)
		list.personnel	:SetFontColor(UI_color.C_FFC4BEBE)
		list.point		:SetFontColor(UI_color.C_FFC4BEBE)


		-- 길드 순위
		list.rank		:SetText( (listIdx+1)+(self._selectPage*endSlotNo) )

--{		길드 마크 셋팅
		local isSet = setGuildTextureByGuildNo( guildRankerGuildMark_s64, list.guild )
		if ( false == isSet ) then
			list.guild:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( list.guild, 183, 1, 188, 6 )
			list.guild:getBaseTexture():setUV(  x1, y1, x2, y2  )
			list.guild:setRenderTexture(list.guild:getBaseTexture())
		else
			list.guild:getBaseTexture():setUV(  0, 0, 1, 1  )
			list.guild:setRenderTexture(list.guild:getBaseTexture())
		end
--}
		if loadComplete then
			list.guild		:SetText( guildRankerGuild )
		else
			list.guild		:SetText( "Loading..." )
		end
		
		list.familyName	:SetText( guildRankerMasterName )
		list.guild		:addInputEvent( "Mouse_LUp", "FGlobal_GuildWebInfo_Open( " .. listIdx .. " )" )	-- Panel_GuildWebInfo.lua 길드 홈페이지 연결 -- 다음에서 뺴달라고 요청했다.(2015-10-23)
		list.guild		:addInputEvent( "Mouse_On", "GuildRank_Tooltip(true, " .. listIdx .. ")")
		list.guild		:addInputEvent( "Mouse_Out", "GuildRank_Tooltip(false, " .. listIdx .. ")")
		-- list.guild		:addInputEvent( "Mouse_On", "guildRanking_SimpleTooltips( true, 10, " .. listIdx .. ")")	-- 길드페이지 안내툴팁
		-- list.guild		:addInputEvent( "Mouse_Out", "guildRanking_SimpleTooltips( false )")
		list.guild		:setTooltipEventRegistFunc("GuildRank_Tooltip(true, " .. listIdx .. ")")
		

		list.icon1		:SetShow( false )
		list.icon2		:SetShow( false )
		list.icon3		:SetShow( false )
		list.icon4		:SetShow( false )
		list.icon5		:SetShow( false )

		local guildRankerTerritory = -1
		local iconPosX = 430
		local occupationCount = 0		-- 자치령을 몇개를 먹었는지 체크
		for i=0, self.territoryCount-1 do
			guildRankerTerritory = guildRanker:getTerritoryKeyAt( i )

			if 0 == guildRankerTerritory then
				list.icon2		:SetShow( true )
				list.dash1		:SetShow( false )
				list.icon2		:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 0, " .. listIdx .. ")")
				list.icon2		:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
				list.icon2		:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 0, " .. listIdx .. ")")
				occupationCount = occupationCount + 1
			end
			if 1 == guildRankerTerritory then
				list.icon1		:SetShow( true )
				list.dash1		:SetShow( false )
				list.icon1		:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 1, " .. listIdx .. ")")
				list.icon1		:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
				list.icon1		:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 1, " .. listIdx .. ")")
				occupationCount = occupationCount + 1
			end
			if 2 == guildRankerTerritory then
				list.icon3		:SetShow( true )
				list.dash1		:SetShow( false )
				list.icon3		:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 2, " .. listIdx .. ")")
				list.icon3		:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
				list.icon3		:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 2, " .. listIdx .. ")")
				occupationCount = occupationCount + 1
			end
			if 3 == guildRankerTerritory then
				list.icon4		:SetShow( true )
				list.dash1		:SetShow( false )
				list.icon4		:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 3, " .. listIdx .. ")")
				list.icon4		:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
				list.icon4		:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 3, " .. listIdx .. ")")
				occupationCount = occupationCount + 1
			end
			if 4 == guildRankerTerritory then
				list.icon5		:SetShow( true )
				list.dash1		:SetShow( false )
				list.icon5		:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 4, " .. listIdx .. ")")
				list.icon5		:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
				list.icon5		:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 4, " .. listIdx .. ")")
				occupationCount = occupationCount + 1
			end
--{			몇개의 자치령을 먹었는지에 따라서 X값을 조정한다.
			if 0 == occupationCount then
				iconPosX = 470
			elseif 1 == occupationCount then
				iconPosX = 467
			elseif 2 == occupationCount then
				iconPosX = 453
			elseif 3 == occupationCount then
				iconPosX = 440
			elseif 4 == occupationCount then
				iconPosX = 430
			end
--}
--{			자치령 아이콘이 켜지는데 두개 이상을 먹었으면 위치를 보기좋게 ^^ 나란히~ 잡는다.
			if list.icon1:GetShow() then
				list.icon1:SetPosX( iconPosX )
				iconPosX = iconPosX + 25
			end
			if list.icon2:GetShow() then
				list.icon2:SetPosX( iconPosX )
				iconPosX = iconPosX + 25
			end
			if list.icon3:GetShow() then
				list.icon3:SetPosX( iconPosX )
				iconPosX = iconPosX + 25
			end
			if list.icon4:GetShow() then
				list.icon4:SetPosX( iconPosX )
				iconPosX = iconPosX + 25
			end
			if list.icon5:GetShow() then
				list.icon5:SetPosX( iconPosX )
				iconPosX = iconPosX + 25
			end
--}
		end
		list.node		:SetText( guildRankerNodeCount )
		list.duelWar	:SetText( "<PAColor0xff00c0d7>" .. guildDuelWarWin .. "<PAOldColor>" )
		list.personnel	:SetText( guildRankerMemberCount )
		list.point		:SetText( guildRankerAquirePorint )

		-- list.name		:addInputEvent( "Mouse_LUp", "guildRanking_RankerWhisper( " .. listIdx .. " )" ) -- 귓속말
		count = count + 1
	end
	if 16 == self._selectPage+1 then
		_btn_Next:SetIgnore( true )
	else
		_btn_Next:SetIgnore( false )
	end

	if 1 == self._selectPage+1 then
		_btn_Prev:SetIgnore( true )
	else
		_btn_Prev:SetIgnore( false )
	end
	_txt_page:SetText( self._selectPage + 1 )
end

function GuildRank_Tooltip( isShow, index )
	local self = guildRanking

	local	guildRanker					= ToClient_GetGuildRankingInfoAt( index )
	local	guildRankerGuildMark_s64	= guildRanker:getGuildNo_s64()
	local	guildRankerGuild			= guildRanker:getGuildName()				-- 길드명
	local	guildRankerMasterName		= guildRanker:getGuildMasterNickName()		-- 길드마스터 가문명
	local	guildRankerTerritoryCount	= guildRanker:getTerritoryCount()			-- 점령 여부( -1 : 미점령 / 0 ~ 3 점령 여부 리턴 )
	local	guildRankerNodeCount		= guildRanker:getSiegeCount()				-- 점령 거점 수
	local	guildRankerMemberCount		= guildRanker._guildMemberCount				-- 길드 인원수
	local	guildRankerAquirePorint		= guildRanker._guildAquiredPoint			-- 길드 포인트
	local	guildIntroduce				= guildRanker:getGuildIntroduction()		-- 길드 소개

	local	list						= self._listPool[index].guild

	registTooltipControl(list, Panel_Tooltip_Guild_Introduce)
	if true == isShow then
		TooltipGuild_Show( list, guildRankerGuildMark_s64, guildRankerGuild, guildRankerMasterName, guildIntroduce)
	else
		TooltipGuild_Hide()
	end
end

function FromClient_UpdateGuildRank(page)
	local guildCount	= ToClient_GetGuildCount()
	local self			= guildRanking
	if 0 == guildCount then
		self._selectPage = self._selectPage - 1
		return
	end
	self._selectPage = page
	audioPostEvent_SystemUi(01,00)
	-- Panel_Guild_Rank:SetShow( true )
	self:Update()
end

function FGlobal_guildRanking_Open()
	local self = guildRanking
	if Panel_Guild_Rank:GetShow() then
		Panel_Guild_Rank:SetShow( false, false )
	else
		Panel_Guild_Rank:SetShow( true, true )
	end
	
	ToClient_RequestGuildRanking( 0 )
	self:Update()
end

function FGlobal_guildRanking_Close()
	Panel_Guild_Rank:SetShow( false, false )
	TooltipSimple_Hide()
	TooltipGuild_Hide()
end

function guildRanking_NextBtn()
	audioPostEvent_SystemUi(00,00)
	
	local	self	= guildRanking
	if	self._selectMaxPage <= self._selectPage	then
		return
	end

	self._selectPage	= self._selectPage + 1

	ToClient_RequestGuildRanking( self._selectPage )
end

function guildRanking_PrevBtn()
	audioPostEvent_SystemUi(00,00)
	_btn_Prev:DoAutoDisableTime()
	local	self	= guildRanking
	
	if	0 < self._selectPage	then
		self._selectPage	= self._selectPage - 1
	end
	ToClient_RequestGuildRanking( self._selectPage )
end

-- function guildRanking_RankerWhisper( rankIdx )
-- 	local lifeRanker			= ToClient_GetLifeRankerAt( rankIdx )
-- 	local lifeRankerCharName	= lifeRanker:getCharacterName()

-- 	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
-- 	FGlobal_ChattingInput_ShowWhisper( lifeRankerCharName )
-- end

function guildRanking_SimpleTooltips( isShow, terriType, listIdx )
	local self = guildRanking
	local name, desc, uiControl = nil, nil, nil

	local list = self._listPool[listIdx]
	if 0 == terriType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENOS_NAME") --발레노스령
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENOS_DESC") --해당 길드가 발레노스령을 점령 중입니다.
		uiControl = list.icon1
	elseif 1 == terriType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_SERENDIA_NAME") --세렌디아령
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_SERENDIA_DESC") --해당 길드가 세렌디아령을 점령 중입니다.
		uiControl = list.icon2
	elseif 2 == terriType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_KALPEON_NAME") --칼페온령
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_KALPEON_DESC") --해당 길드가 칼페온령을 점령 중입니다.
		uiControl = list.icon3
	elseif 3 == terriType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_MEDIA_NAME") --메디아령
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_MEDIA_DESC") --해당 길드가 메디아령을 점령 중입니다.
		uiControl = list.icon4
	elseif 4 == terriType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENCIA_NAME") --메디아령
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENCIA_DESC") --해당 길드가 메디아령을 점령 중입니다.
		uiControl = list.icon5
	-- elseif 10 == terriType then	-- 길드페이지 툴팁
		------ name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_WEBPAGE_NAME")	-- "길드 페이지 열기"
		-- name = "길드 페이지 열기"
		-- desc = nil
		-- uiControl = list.guild
	end


	if isShow == true then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function GuildRank_Repos()
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_Guild_Rank:SetPosX( (screenSizeX - Panel_Guild_Rank:GetSizeX()) / 2 )
	Panel_Guild_Rank:SetPosY( (screenSizeY - Panel_Guild_Rank:GetSizeY()) / 2 )
end

function guildRanking_registEventHandler()
	local self = guildRanking

	self._btnClose	:addInputEvent("Mouse_LUp", "FGlobal_guildRanking_Close()")
	_btn_Next		:addInputEvent("Mouse_LUp", "guildRanking_NextBtn()")
	_btn_Prev		:addInputEvent("Mouse_LUp", "guildRanking_PrevBtn()")
	
	guildRanking._btnHelp:SetShow(false)	-- 도움말 추가시 삭제 및 아래 주석처리된 라인 주석 해제
	-- guildRanking._btnHelp		:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"GuildRank\" )" )			--물음표 좌클릭
	-- guildRanking._btnHelp		:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"GuildRank\", \"true\")" )		--물음표 마우스오버
	-- guildRanking._btnHelp		:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"GuildRank\", \"false\")" )	--물음표 마우스아웃
end

function guildRanking_registMessageHandler()
	registerEvent("onScreenResize", 			"GuildRank_Repos" )
	registerEvent("FromClient_UpdateGuildRank", "FromClient_UpdateGuildRank")
end


guildRanking_Initionalize()
guildRanking_registEventHandler()
guildRanking_registMessageHandler()
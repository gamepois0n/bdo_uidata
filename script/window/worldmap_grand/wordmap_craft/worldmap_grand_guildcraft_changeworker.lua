Worldmap_Grand_GuildCraft_ChangeWorker:SetShow( false )
Worldmap_Grand_GuildCraft_ChangeWorker:ActiveMouseEventEffect(true)
Worldmap_Grand_GuildCraft_ChangeWorker:setGlassBackground(true)


local GuildCraft_ChangeWorker = {
	ui = { 
		btn_close	= UI.getChildControl ( Worldmap_Grand_GuildCraft_ChangeWorker, "Button_Win_Close" ),
		scroll		= UI.getChildControl ( Worldmap_Grand_GuildCraft_ChangeWorker, "Scroll" ),
		bg			= UI.getChildControl ( Worldmap_Grand_GuildCraft_ChangeWorker, "Static_BG" ),
	},

	config = {
		maxListCount	= 5,
		totalRaw		= 0,
		startIdx		= 0,
		houseKeyRaw		= nil,
	},

	uiPool = {
		worker = {},
	},
}

local workerNoRawArray	= {}

function GuildCraft_ChangeWorker:Init()
	for listIdx = 0, self.config.maxListCount -1 do
		self.uiPool.worker[listIdx] = {}
		local list = self.uiPool.worker[listIdx]
		list.bg			= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildCraft_ChangeWorker, "Static_WorkerBG",		self.ui.bg,	"GuildCraft_ChangeWorker_WorkerBG_" .. listIdx )
		list.name		= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildCraft_ChangeWorker, "StaticText_WorkerName",	list.bg,	"GuildCraft_ChangeWorker_WorkerName_" .. listIdx )
		list.homeway	= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildCraft_ChangeWorker, "StaticText_HomeWay",	list.bg,	"GuildCraft_ChangeWorker_WorkerHomeWay_" .. listIdx )
		list.selectBtn	= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildCraft_ChangeWorker, "Button_Select",			list.bg,	"GuildCraft_ChangeWorker_SelectBtn_" .. listIdx )

		list.bg			:SetSpanSize( 5, ( (list.bg:GetSizeY() + 3) * listIdx ) + 5 )
		list.name		:SetSpanSize( 5, 5 )
		list.homeway	:SetSpanSize( 10, 25 )
		list.selectBtn	:SetSpanSize( 225, 5 )

		list.bg			:SetShow( false )
		list.bg			:SetIgnore( false )
	end

	self.ui.btn_close:addInputEvent( "Mouse_LUp", "HandleClicked_GuildCraft_ChangeWorker_Close()" )

	self.ui.bg		:addInputEvent(	"Mouse_UpScroll",	"GuildCraft_ChangeWorker_ScrollEvent( true )"	)
	self.ui.bg		:addInputEvent(	"Mouse_DownScroll",	"GuildCraft_ChangeWorker_ScrollEvent( false )"	)
	UIScroll.InputEvent( self.ui.scroll,				"GuildCraft_ChangeWorker_ScrollEvent"			)
end
GuildCraft_ChangeWorker:Init()


function GuildCraft_ChangeWorker:Update()
	-- 초기화
	workerNoRawArray	= {}
	for idx = 0, self.config.maxListCount -1 do
		local list = self.uiPool.worker[idx]
		list.bg			:SetShow( false )
		list.selectBtn	:addInputEvent( "Mouse_LUp", "" )
	end

	-- workerNoRaw 배열 생성
	local myWorkerCount		= ToClient_getMyNpcWorkerCount()						-- 나중에 바꿔야 할 수도 있다.
	local waitWorkerCount	= 0
	for workerIdx = 0, myWorkerCount -1 do
		local workerWrapper		= ToClient_getMyNpcWorkerByIndex( workerIdx )
		local workerNoRaw		= workerWrapper:get():getWorkerNo():get_s64()
		local workerWrapperLua	= getWorkerWrapper( workerNoRaw, true )

		if false == workerWrapperLua:isWorking() and false == workerWrapperLua:getIsAuctionInsert() then -- 쉬고 있다.
			workerNoRawArray[waitWorkerCount] = workerNoRaw
			waitWorkerCount = waitWorkerCount + 1
		end
	end

	self.config.totalRaw	= waitWorkerCount

	-- 실제 처리
	local uiCount = 0
	for workerIdx = self.config.startIdx, waitWorkerCount -1 do
		if self.config.maxListCount <= uiCount then
			break
		end

		local workerWrapperLua		= getWorkerWrapper( workerNoRawArray[workerIdx], true )
		local workerLev				= workerWrapperLua:getLevel()
		local workerGrade			= workerWrapperLua:getGrade()
		local workerGradeColor		= workerWrapperLua:getGradeToColorString()
		local workerName			= workerWrapperLua:getName()
		local workerCurrentAp		= workerWrapperLua:getActionPoint()
		local workerMaxAp			= workerWrapperLua:getMaxActionPoint()
		local workerHomeWayPoint	= workerWrapperLua:getHomeWaypoint()

		local guildHouseInfoSSW		= ToClient_GetGuildHouseInfoStaticStatusWrapper( self.config.houseKeyRaw )
		local parentNodeKey			= guildHouseInfoSSW:getParentNodeKey()
		local isWorkable			= workerWrapperLua:isWorkingable( parentNodeKey )
		local homeName				= ToClient_GetNodeNameByWaypointKey ( workerHomeWayPoint )

		if isWorkable then
			homeName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_GUILDCRAFT_WORKER_HOME_LINK", "HomeName", homeName )
			-- 소속 : 어디어디
		else
			homeName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_GUILDCRAFT_WORKER_HOME_UNLINK", "HomeName", homeName )
			-- 소속 : 어디어디(연결되지 않음)
		end

		local list = self.uiPool.worker[uiCount]
		list.bg			:SetShow( true )

		list.name		:SetText( "Lv." .. workerLev .. " " .. workerGradeColor .. workerName .. "<PAOldColor> (" .. workerCurrentAp .. "/" .. workerMaxAp .. ")" )
		list.homeway	:SetText( homeName )

		list.bg			:addInputEvent( "Mouse_On",			"GuildCraft_ChangeWorker_WorkerTooltip( true,	" .. uiCount .. ", " .. workerIdx .. " )" )	-- 일꾼 툴팁 띄우기
		list.bg			:addInputEvent( "Mouse_Out",		"GuildCraft_ChangeWorker_WorkerTooltip( false,	" .. uiCount .. ", " .. workerIdx .. " )" )	-- 일꾼 툴팁 끄기

		list.bg			:addInputEvent(	"Mouse_UpScroll",	"GuildCraft_ChangeWorker_ScrollEvent( true )"	)
		list.bg			:addInputEvent(	"Mouse_DownScroll",	"GuildCraft_ChangeWorker_ScrollEvent( false )"	)

		list.selectBtn	:addInputEvent( "Mouse_LUp",		"HandleClicked_GuildCraft_SetChangeWorker( " .. workerIdx .. ", " .. parentNodeKey .. " )" )
		uiCount = uiCount + 1
	end

	UIScroll.SetButtonSize( self.ui.scroll, self.config.maxListCount, self.config.totalRaw )
	-- 스크롤 버튼 사이즈 조절.
	if self.ui.scroll:GetControlButton():GetSizeY() < 20 then
		self.ui.scroll:GetControlButton():SetSize( 10, 50 )
	end

	-- 스크롤 온오프
	if self.config.maxListCount < waitWorkerCount then
		self.ui.scroll:SetShow( true )
	else
		self.ui.scroll:SetShow( false )
	end
end

function GuildCraft_ChangeWorker_ScrollEvent( isUp )
	local self = GuildCraft_ChangeWorker
	self.config.startIdx = UIScroll.ScrollEvent( self.ui.scroll, isUp, self.config.maxListCount , self.config.totalRaw, self.config.startIdx, 1 )
	self:Update()
end

function GuildCraft_ChangeWorker_WorkerTooltip( isShow, uiIdx, workerIdx )		-- 일꾼 툴팁
	local control		= GuildCraft_ChangeWorker.uiPool.worker[uiIdx].bg
	local workerNoRaw	= workerNoRawArray[workerIdx]
	if true == isShow then
		FGlobal_ShowWorkerTooltipByWorkerNoRaw( workerNoRaw, control )
	else
		FGlobal_HideWorkerTooltip()
	end
end

function HandleClicked_GuildCraft_SetChangeWorker( workerIdx )
	local workerNoRaw		= workerNoRawArray[workerIdx]
	FGlobal_GuildCraft_SetWorker( workerNoRaw )
	HandleClicked_GuildCraft_ChangeWorker_Close()
end

function FGlobal_GuildCraft_ChangeWorker_Open( houseKeyRaw )
	GuildCraft_ChangeWorker.config.houseKeyRaw	= houseKeyRaw
	GuildCraft_ChangeWorker:Update()
end

function HandleClicked_GuildCraft_ChangeWorker_Close()
	WorldMapPopupManager:pop()
	GuildCraft_ChangeWorker.config.houseKeyRaw = nil
end


function GuildCraft_ChangeWorker_onScreenResize()
	Worldmap_Grand_GuildCraft_ChangeWorker:ComputePos()
end

registerEvent( "onScreenResize", "GuildCraft_ChangeWorker_onScreenResize" )
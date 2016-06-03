Worldmap_Grand_GuildHouseControl:SetShow(false)
Worldmap_Grand_GuildHouseControl:ActiveMouseEventEffect(true)
Worldmap_Grand_GuildHouseControl:setGlassBackground(true)

local isContentsEnable = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 36 ) -- 길드 하우스 컨텐츠

local Panel_Control = {
	_win_Close				= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Button_Win_Close" ),				-- 닫기
	_buttonQuestion			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Button_Question" ),				-- 도움말

	_txt_House_Title		= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_Title" ),				-- 창제목
}

local HouseInfo_Control =	{			-- 집 정보
	_BG						= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_HouseInfo_BG" ),				-- 집 정보 BG
	_Name					= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_HouseInfo_Name" ),			-- 현재 용도명(미사용)
	_Desc					= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_HouseInfo_Desc" ),			-- 현재 용도 설명(미사용)
	_UseType_Icon			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_HouseInfo_UseType_Icon" ),		-- 현재 용도 아이콘
	_UseType_Name			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_HouseInfo_UseType_Name" ),	-- 현재 용도 이름
	_UseType_Desc			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_HouseInfo_UseType_Desc" ),	-- 현재 용도 설명
	_houseKeyRaw			= nil,
}

local HouseUseType_Control	= {			-- 용도 목록 영역
	_txt_UseType_Title		= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_UseType_Title" ),		-- 용도 목록 타이틀
	_controlBG				= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_HouseControl_BG" ),		-- 용도 목록 BG
	_scrollBar				= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Scroll_ScrollBar" ),				-- 용도 목록 스크롤바

	listCount				= 8,
	gradeCount				= 5,
	uiList					= {},
}

local HouseUseTypeState_Control =	{	-- 소유 길드 영역
	_BG						= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_CostBG" ),					-- 진행 상황 BG
		
	_WorkName               = UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_WorkName" ),			-- 길드명
	_Icon_BG                = UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_Working_IconBG" ),			-- 길드 마크 BG
	_Icon_Working           = UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_Working_Icon" ),			-- 길드 마크
	                        
	_OnGoingText            = UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_OnGoing_Text" ),		-- 길드 대장
	_OnGoingText_Vlaue      = UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_OnGoing_Value" ),		-- 길드 대장 : 값
	
	_Btn_LargCraft	        = UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Button_LargeCraft" ),				-- 제작 관리 : 버튼
}

local contributePlus		= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_ContributePlus" )
local contributeMinus		= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_ContributeMinus" )

local WorkList_Control	= {				-- 상세 용도 영역
	_Title			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Title" ),				-- 상세 용도 타이틀
	_controlBG		= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_WorkList_BG" ),					-- 상세 용도 BG
	_scrollButton	= nil,

	_iconBG			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Button_WorkList" ),						-- 만들 수 있는 아이템 배경
	_iconBorder		= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_WorkList_Border" ),				-- 만들 수 있는 아이템 배경 테두리(그레이드)
	_iconOver		= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_WorkList_Over" ),					-- 만들 수 있는 아이템 마우스 오버
	_level			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Level" ),				-- 만들 수 있는 아이템 단계 타이틀
	_level_nonCraft	= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Level_nonCraft" ),	-- 창고/숙소일 때 타이틀
	_guide			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Guide" ),				-- 창고/숙소 단계별 설명
	_guide_MyHouse	= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_MyHouse_Guide" ),				-- 주거지 설명
	_icon			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_WorkList_Icon" ),					-- 만들 수 있는 아이템 아이콘

	_scroll			= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "WorkList_ScrollBar" ),					-- 만들 수 있는 아이템 스크롤
	_startSlotIndex	= 0,
	_maxRow			= 4,
	_totalRow		= 4,

	_selecthouseKeyRaw		= nil,
	_selectRecipeKeyRaw		= nil,

	maxPoolNo		= 4,
	maxIconRow		= 5,
	titlePool		= {},
	iconPool		= {},
}


local HouseImage_Control =	{			-- 내부 구조 영역
	_Title					= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "StaticText_HouseImage_Title" ),			-- 내부 구조 타이틀
	_BG						= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_HouseImage_BG" ),					-- 내부 구조 BG
	_Image					= UI.getChildControl ( Worldmap_Grand_GuildHouseControl, "Static_HouseImage_Image" ),				-- 내부 구조 이미지
}


local guildHouse_Img = {
	[2110] = "icon/new_icon/03_etc/06_housing/2110.dds",
	[2140] = "icon/new_icon/03_etc/06_housing/2140.dds",
	[2183] = "icon/new_icon/03_etc/06_housing/2183.dds",
	[2188] = "icon/new_icon/03_etc/06_housing/2188.dds",
	[2228] = "icon/new_icon/03_etc/06_housing/2228.dds",
	[2427] = "icon/new_icon/03_etc/06_housing/2427.dds",
	[2503] = "icon/new_icon/03_etc/06_housing/2503.dds",
	[2569] = "icon/new_icon/03_etc/06_housing/2569.dds",
	[2608] = "icon/new_icon/03_etc/06_housing/2608.dds",
	[2647] = "icon/new_icon/03_etc/06_housing/2647.dds",
	[2691] = "icon/new_icon/03_etc/06_housing/2691.dds",
	[2704] = "icon/new_icon/03_etc/06_housing/2704.dds",
	[2858] = "icon/new_icon/03_etc/06_housing/2858.dds",
	[2880] = "icon/new_icon/03_etc/06_housing/2880.dds",
	[2905] = "icon/new_icon/03_etc/06_housing/2905.dds",
	[3351] = "icon/new_icon/03_etc/06_housing/3351.dds",
	[3352] = "icon/new_icon/03_etc/06_housing/3352.dds",
	[3353] = "icon/new_icon/03_etc/06_housing/3353.dds",
	[3354] = "icon/new_icon/03_etc/06_housing/3354.dds",
	[3355] = "icon/new_icon/03_etc/06_housing/3355.dds",
	[3356] = "icon/new_icon/03_etc/06_housing/3356.dds",
	[3357] = "icon/new_icon/03_etc/06_housing/3357.dds",
	[3358] = "icon/new_icon/03_etc/06_housing/3358.dds",
}

local guildHouseButton	= nil
local ownerGuildNoRaw 	= nil
local recipeData		= {}
local WorkDataRow		= {}
local isMyGuildHouse	= false

-- 패널 초기화
function Panel_Control:Init()
	self._win_Close:addInputEvent( "Mouse_LUp", "FGlobal_WorldMapWindowEscape()" )

	HouseInfo_Control._UseType_Name:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	HouseInfo_Control._UseType_Name:SetAutoResize( true )
	HouseInfo_Control._UseType_Desc:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	HouseInfo_Control._UseType_Desc:SetAutoResize( true )
	HouseInfo_Control._UseType_Name:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_GUILDHOUSE_TITLE") )	-- "길드 하우스"
	HouseInfo_Control._UseType_Desc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_GUILDHOUSE_DESC") ) -- "이 집은 길드 하우스다. 길드 하우스 경매를 통해 입찰할 수 있고, 낙찰이 되면 길드 하우스를 통해 아이템을 제작할 수 있다."
end
Panel_Control:Init()

-- 용도 목록 초기화
function HouseUseType_Control:Init()
	for typeIdx = 0, self.listCount -1 do
		self.uiList[typeIdx] = {}
		local typeList 		= self.uiList[typeIdx]
		typeList.btn		= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "Button_Smithy",			self._controlBG,"Grand_GuildHouseTypeList_Btn_" .. typeIdx )
		typeList.onUpgrade	= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "Static_A_Construction",	typeList.btn,	"Grand_GuildHouseTypeList_onUpgrade_" .. typeIdx )

		typeList.grade = {}
		for gradeIdx = 0, self.gradeCount -1 do
			typeList.grade[gradeIdx] = {}
			local upgradeBtn 	= typeList.grade[gradeIdx]
			upgradeBtn.BG		= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, 	"Button_Smithy_1",	typeList.btn,	"Grand_GuildHouseTypeList_gradeBG_" .. typeIdx .. "_" .. gradeIdx )
			upgradeBtn.Mask		= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "Static_Smithy_Mask",	typeList.btn,	"Grand_GuildHouseTypeList_gradeMask_" .. typeIdx .. "_" .. gradeIdx )

			upgradeBtn.BG	:SetSpanSize( 195 + (upgradeBtn.BG:GetSizeX() * gradeIdx), 2 )
			upgradeBtn.Mask	:SetSpanSize( 195 + (upgradeBtn.BG:GetSizeX() * gradeIdx), 2 )

			upgradeBtn.BG	:SetShow( false )
			upgradeBtn.Mask	:SetShow( false )
		end

		typeList.btn		:SetSpanSize( 0, (typeList.btn:GetSizeY() * typeIdx) + 3 )
		typeList.onUpgrade	:SetSpanSize( 0, 3 )

		typeList.btn		:SetShow( false )
		typeList.onUpgrade	:SetShow( false )
	end

	self._scrollBar:SetControlPos( 0 )
end
HouseUseType_Control:Init()

-- 

-- 길드 정보 초기화
function HouseUseTypeState_Control:Init()
	-- { 구매하지 않은 상태
		self._Btn_LargCraft			:SetShow( false )	-- 제작 관리 : 버튼
	-- }

	-- { 진행 상황
		self._WorkName				:SetShow( true )	-- 작업 이름
		self._Icon_BG				:SetShow( true )	-- 작업 아이템 아이콘 BG
		self._Icon_Working			:SetShow( true )	-- 작업 아이템 아이콘

		self._OnGoingText			:SetShow( true )	-- 길드 대장
		self._OnGoingText_Vlaue		:SetShow( true )	-- 길드 대장 : 값
	-- }

	-- {클릭 이벤트
		self._Btn_LargCraft			:addInputEvent( "Mouse_LUp", "Worldmap_Grand_GuildCraft_Open()" )
	-- }
end
HouseUseTypeState_Control:Init()

-- 상세 용도 초기화
function WorkList_Control:Init()
	for titleIdx = 0, self.maxPoolNo -1 do
		self.titlePool[titleIdx] = UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Level",	self._controlBG,"Grand_GuildHouseWorkList_LevTitle_" .. titleIdx )
		self.titlePool[titleIdx]:SetSpanSize( 0, ((self.titlePool[titleIdx]:GetSizeY() + 24) * titleIdx) + 20 )
		self.titlePool[titleIdx]:SetShow( false )
	end

	for iconRowIdx = 0, self.maxPoolNo -1 do
		self.iconPool[iconRowIdx] = {}
		for iconColIdx = 0, self.maxIconRow -1 do
			self.iconPool[iconRowIdx][iconColIdx] = {}

			local slotPool = self.iconPool[iconRowIdx][iconColIdx]
			slotPool.bg		= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "Button_WorkList",			self._controlBG,	"Grand_GuildHouseWorkList_IconBG_" .. iconRowIdx .. "_" .. iconColIdx )
			slotPool.icon	= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "Button_WorkList",			slotPool.bg,		"Grand_GuildHouseWorkList_Icon_" .. iconRowIdx .. "_" .. iconColIdx )
			slotPool.border	= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "Static_WorkList_Border",	slotPool.bg,		"Grand_GuildHouseWorkList_IconBorder_" .. iconRowIdx .. "_" .. iconColIdx )
			slotPool.over	= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "Static_WorkList_Over",	slotPool.bg,		"Grand_GuildHouseWorkList_IconOver_" .. iconRowIdx .. "_" .. iconColIdx )
			slotPool.count	= UI.createAndCopyBasePropertyControl( Worldmap_Grand_GuildHouseControl, "Static_WorkList_Count",	slotPool.bg,		"Grand_GuildHouseWorkList_Count_" .. iconRowIdx .. "_" .. iconColIdx )

			local spanSizeX = ((slotPool.bg:GetSizeX()+5) * iconColIdx) + 14
			local spanSizeY = slotPool.bg:GetSizeY() * iconRowIdx

			slotPool.bg		:SetSpanSize( spanSizeX, spanSizeY )
			slotPool.icon	:SetSpanSize( 0, 0 )
			slotPool.border	:SetSpanSize( 0, 0 )
			slotPool.over	:SetSpanSize( 0, 0 )
			slotPool.count	:SetSpanSize( 5, 5 )

			slotPool.bg		:SetShow( false )
			slotPool.icon	:SetShow( false )
			slotPool.border	:SetShow( false )
			slotPool.over	:SetShow( false )
			slotPool.count	:SetShow( false )

			slotPool.icon	:SetIgnore( false )
		end
	end

	self._scroll:SetControlPos( 0 )

	self._controlBG:addInputEvent(	"Mouse_UpScroll",	"GuildHouse_WorkList_ScrollEvent( true )"	)
	self._controlBG:addInputEvent(	"Mouse_DownScroll",	"GuildHouse_WorkList_ScrollEvent( false )"	)
end
WorkList_Control:Init()

function GuildHouse_WorkList_ScrollEvent( isScrollUp )
	WorkList_Control._startSlotIndex = UIScroll.ScrollEvent( WorkList_Control._scroll, isScrollUp, WorkList_Control._maxRow, WorkList_Control._totalRow, WorkList_Control._startSlotIndex, 1 )
	GuildHouse_WorkList_Update( WorkList_Control._selecthouseKeyRaw, WorkList_Control._selectRecipeKeyRaw )
end

-- 내부 구조 초기화
function HouseImage_Control:Init()
	-- body
	-- ToClient_getScreenShotPath(houseInfoSS, 0)
end
HouseImage_Control:Init()

function GuildHouse_WorkList_SetData()											-- 데이터 세팅
	WorkDataRow = {}
	WorkList_Control._totalRow	= 0

	local guildHouseInfoSSW	= ToClient_GetGuildHouseInfoStaticStatusWrapper( WorkList_Control._selecthouseKeyRaw )
	local recipeCount 		= guildHouseInfoSSW:getReceipeCount()
	for recipeIdx = 0, recipeCount -1 do
		local houseCraftWrapper = guildHouseInfoSSW:getHouseCraftWrapperByIndex( recipeIdx )
		local recipeKeyRaw		= houseCraftWrapper:getReceipeKeyRaw()

		if recipeKeyRaw == WorkList_Control._selectRecipeKeyRaw then	-- 해당하는 것만
			local maxLevel			= guildHouseInfoSSW:getMaxLevel( recipeKeyRaw )
			WorkDataRow[WorkList_Control._totalRow] = {}		-- 배열 초기화

			for level = 1 , maxLevel do
				WorkDataRow[WorkList_Control._totalRow] = { 	-- 데이터 넣기
					isTitle		= true,
					level		= level,
					value1		= nil,
					value2		= nil,
					receipeKey	= recipeKeyRaw
					}
				WorkList_Control._totalRow = WorkList_Control._totalRow + 1

				local exchangeCount	= guildHouseInfoSSW:getItemExchangeListCount( recipeKeyRaw, level )
				local exchangeCol	= math.ceil( (exchangeCount / WorkList_Control.maxIconRow) + 0.5 )	-- 올림.
				
				for exchangeColIdx = 0, exchangeCol -1 do
					local startIdx	= exchangeColIdx * (WorkList_Control.maxIconRow -1)
					local endIdx	= (exchangeColIdx * (WorkList_Control.maxIconRow -1)) + (WorkList_Control.maxIconRow)
					if exchangeCount < endIdx then
						endIdx = exchangeCount
					end
					WorkDataRow[WorkList_Control._totalRow] = { 	-- 데이터 넣기
						isTitle		= false,
						level		= level,
						value1		= startIdx,	-- 시작 인덱스
						value2		= endIdx,	-- 끝 인덱스
						receipeKey	= recipeKeyRaw
						}
					WorkList_Control._totalRow = WorkList_Control._totalRow + 1
				end
			end
		end
	end
end

function GuildHouse_WorkList_Update( houseKeyRaw, _recipeKeyRaw )				-- 상세 용도 갱신
	WorkList_Control._selecthouseKeyRaw		= houseKeyRaw
	WorkList_Control._selectRecipeKeyRaw	= _recipeKeyRaw

	local guildHouseInfoSSW	= ToClient_GetGuildHouseInfoStaticStatusWrapper( WorkList_Control._selecthouseKeyRaw )
	-- local recipeKeyRaw		= WorkList_Control._selectRecipeKeyRaw

	-- 데이터 세팅
	GuildHouse_WorkList_SetData()

	-- 초기화
	for titleIdx = 0, WorkList_Control.maxPoolNo -1 do
		WorkList_Control.titlePool[titleIdx]:SetShow( false )
	end
	for iconRowIdx = 0, WorkList_Control.maxPoolNo -1 do
		for iconColIdx = 0, WorkList_Control.maxIconRow -1 do
			local slotPool = WorkList_Control.iconPool[iconRowIdx][iconColIdx]
			slotPool.bg		:SetShow( false )
			slotPool.icon	:SetShow( false )
			slotPool.border	:SetShow( false )
			slotPool.over	:SetShow( false )
			slotPool.count	:SetShow( false )

			slotPool.icon	:addInputEvent("Mouse_On",	"")
			slotPool.icon	:addInputEvent("Mouse_Out", "")
		end
	end

	-- 데이터 적용
	local uiSlotNo = 0	-- row 오버 체크
	for rowNo = WorkList_Control._startSlotIndex, WorkList_Control._totalRow -1 do
		if 3 < uiSlotNo then
			break
		end

		local dataArray = WorkDataRow[rowNo]
		if true == dataArray.isTitle then
			-- 타이틀 라인이다.
			WorkList_Control.titlePool[uiSlotNo]:SetShow( true )
			WorkList_Control.titlePool[uiSlotNo]:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_RECIPEGRADE_TITLE", "grade", dataArray.level ) )
			-- dataArray.level .. "단계" )
		else
			-- 아이콘 라인이다.
			local startIdx		= dataArray.value1
			local endIdx		= dataArray.value2

			local exchangeCount	= guildHouseInfoSSW:getItemExchangeListCount( WorkList_Control._selectRecipeKeyRaw, dataArray.level )
			
			for Idx = 0, WorkList_Control.maxIconRow -1 do
				if endIdx <= (startIdx + Idx) then
					break
				end

				local dataIdx	= startIdx + Idx
				local slotPool	= WorkList_Control.iconPool[uiSlotNo][Idx]
				local itemExchangeSSW = guildHouseInfoSSW:getItemExchangeByIndex( dataIdx )
				if itemExchangeSSW:isSet() then
					slotPool.bg		:SetShow( true )
					slotPool.icon	:SetShow( true )
					slotPool.border	:SetShow( false )
					slotPool.over	:SetShow( false )

					local exchangeKeyRaw	= itemExchangeSSW:getExchangeKeyRaw()
					local itemExchangeSS	= itemExchangeSSW:get()
					local workIcon			= "icon/" .. itemExchangeSSW:getIcon()
					local itemStatic		= nil
					if false == itemExchangeSSW:getUseExchangeIcon() then
						itemStatic	= itemExchangeSS:getFirstDropGroup():getItemStaticStatus()
						workIcon	= "icon/" .. getItemIconPath( itemStatic );
					end
					slotPool.icon	:ChangeTextureInfoName(workIcon)
					slotPool.icon	:addInputEvent("Mouse_On",	"GuildHouse_WorkList_ItemToolTip( true, " .. rowNo .. ", " .. dataIdx .. ", " .. uiSlotNo .. ", " .. Idx .. " )")
					slotPool.icon	:addInputEvent("Mouse_Out", "GuildHouse_WorkList_ItemToolTip( false," .. rowNo .. ", " .. dataIdx .. ", " .. uiSlotNo .. ", " .. Idx .. " )")

					if isMyGuildHouse then
						local MyGuildHouseCraftInfoManager	= getSelfPlayer():getGuildHouseCraftInfoManager()
						local maxDailyWorkingCount			= itemExchangeSSW:getMaxDailyWorkingCount()
						local DailyWorkingCount				= MyGuildHouseCraftInfoManager:getDailyWorkingCount( exchangeKeyRaw )
						slotPool.count:SetShow( true )
						slotPool.count:SetText( tostring(DailyWorkingCount) .. "/" .. tostring(maxDailyWorkingCount) )
					end
				end
			end
		end
		uiSlotNo = uiSlotNo + 1
	end

	-- 스크롤 온오프
	local isScrollShow = false
	if 4 < WorkList_Control._totalRow then	isScrollShow = true	end
	WorkList_Control._scroll:SetShow( isScrollShow )

	-- scroll 설정
	UIScroll.SetButtonSize( WorkList_Control._scroll, WorkList_Control._maxRow, WorkList_Control._totalRow )
end

function GuildHouse_WorkList_ItemToolTip( isShow, rowNo, dataIdx, uiSlotNo, Idx )		-- 상세 용도 아이템 툴팁
	if true == isShow then
		local dataArray			= WorkDataRow[rowNo]
		local guildHouseInfoSSW	= ToClient_GetGuildHouseInfoStaticStatusWrapper( WorkList_Control._selecthouseKeyRaw )
		local exchangeCount		= guildHouseInfoSSW:getItemExchangeListCount( dataArray.receipeKey, dataArray.level )
		local itemExchangeSSW	= guildHouseInfoSSW:getItemExchangeByIndex( dataIdx )
		local control			= WorkList_Control.iconPool[uiSlotNo][Idx].icon
		if itemExchangeSSW:isSet() then
			FGlobal_Show_Tooltip_Work( itemExchangeSSW, control )
		end
	else
		local guildHouseInfoSSW	= ToClient_GetGuildHouseInfoStaticStatusWrapper( WorkList_Control._selecthouseKeyRaw )
		local itemExchangeSSW	= guildHouseInfoSSW:getItemExchangeByIndex( dataIdx )
		if itemExchangeSSW:isSet() then
			FGlobal_Hide_Tooltip_Work(itemExchangeSSW, true)
		end
	end
end

function HouseUseType_Control:Update()											-- 용도 목록 갱신
	recipeData = {}	-- 초기화

	local guildHouseInfoSSW	= ToClient_GetGuildHouseInfoStaticStatusWrapper( HouseInfo_Control._houseKeyRaw )
	local houseKeyRaw		= HouseInfo_Control._houseKeyRaw
	if nil ~= guildHouseInfoSSW then
		Worldmap_Grand_GuildHouseControl:SetShow( true )

		-- 초기화
		for typeIdx = 0, HouseUseType_Control.listCount -1 do
			local typeList = HouseUseType_Control.uiList[typeIdx]
			for gradeIdx = 0, HouseUseType_Control.gradeCount -1 do
				local upgradeBtn 	= typeList.grade[gradeIdx]
				upgradeBtn.BG	:SetShow( false )
				upgradeBtn.Mask	:SetShow( false )
			end
			typeList.btn		:SetShow(false)
			typeList.onUpgrade	:SetShow(false)
		end

		-- 하우스가 가진 레시피 목록
		local MyGuildHouseCraftInfoManager	= getSelfPlayer():getGuildHouseCraftInfoManager()
		local recipeLevelCount				= MyGuildHouseCraftInfoManager:getReceipeLevelCount()

		local recipeCount	= guildHouseInfoSSW:getReceipeCount()
		local uiCount = 0
		for recipeIdx = 0, recipeCount -1 do	
			local houseInfoCraftWrapper	= guildHouseInfoSSW:getHouseCraftWrapperByIndex( recipeIdx )
			local maxLevel				= houseInfoCraftWrapper:getLevel()
			local recipeName			= houseInfoCraftWrapper:getReciepeName()
			local recipeKeyRaw			= houseInfoCraftWrapper:getReceipeKeyRaw()

			-- 길드가 가진 레시피 정보를 쓴다.
			local currentLevel	= MyGuildHouseCraftInfoManager:getLevel( recipeKeyRaw )

			local groupType		= houseInfoCraftWrapper:getGroupType()
			if CppEnums.eHouseUseType.Depot ~= groupType then	-- 창고 타입은 나오지 않는다.
				local typeList	= HouseUseType_Control.uiList[uiCount]
				typeList.btn:SetText( recipeName )
				typeList.btn:addInputEvent("Mouse_LUp", "GuildHouse_WorkList_Update( " .. houseKeyRaw .. ", " .. recipeKeyRaw .. " )")

				for gradeIdx = 0, maxLevel -1 do
					local upgradeBtn 	= typeList.grade[gradeIdx]
					upgradeBtn.BG	:SetShow( true )
					upgradeBtn.Mask	:SetShow( false )

					-- 배운 스킬 레벨은 텍스쳐 변경
					upgradeBtn.BG	:ChangeTextureInfoName("new_ui_common_forlua/window/houseinfo/housecontrol_00.dds")
					local x1, y1, x2, y2 = nil, nil, nil, nil
					if gradeIdx+1 <= currentLevel then
						x1, y1, x2, y2 = setTextureUV_Func( upgradeBtn.BG, 1, 52, 19, 70)
					else
						x1, y1, x2, y2 = setTextureUV_Func( upgradeBtn.BG, 1, 33, 19, 51)
					end
					upgradeBtn.BG:getBaseTexture():setUV(  x1, y1, x2, y2  )
					upgradeBtn.BG:setRenderTexture(upgradeBtn.BG:getBaseTexture())
				end

				typeList.btn		:SetShow( true )
				typeList.onUpgrade	:SetShow(false)
				uiCount = uiCount + 1
			end
		end

		-- 최대갯수보다 많으면 스크롤을 켠다.
		if HouseUseType_Control.listCount < uiCount then	-- 최대갯수보다 많으면 스크롤을 켠다.
			HouseUseType_Control._scrollBar:SetShow( true )
		else
			HouseUseType_Control._scrollBar:SetShow( false )
		end
	end
end


function HouseUseTypeState_Control:Update()										-- 길드 정보 갱신
	local guildHouseInfoSSW	= ToClient_getHouseholdInfoInClientWrapper( HouseInfo_Control._houseKeyRaw )
	ownerGuildNoRaw			= guildHouseInfoSSW:getOwnerGuildNo()
	local myGuildWrapper	= ToClient_GetMyGuildInfoWrapper()
	local myGuildNoRaw		= getSelfPlayer():getGuildNo_s64()
	local guildName 		= ToClient_guild_getGuildName( ownerGuildNoRaw )
	local guildMasterName	= ToClient_guild_getGuildMasterName( ownerGuildNoRaw )

	self._WorkName			:SetText( guildName )
	self._OnGoingText_Vlaue	:SetText( guildMasterName )

	self._Icon_Working:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
	local isSet = setGuildTextureByGuildNo( ownerGuildNoRaw, self._Icon_Working )
	if ( false == isSet ) then
		local x1, y1, x2, y2 = setTextureUV_Func( self._Icon_Working, 183, 1, 188, 6 )
		self._Icon_Working:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self._Icon_Working:setRenderTexture(self._Icon_Working:getBaseTexture())
	else	
		self._Icon_Working:getBaseTexture():setUV(  0, 0, 1, 1  )
		self._Icon_Working:setRenderTexture(self._Icon_Working:getBaseTexture())
	end

	if myGuildNoRaw == ownerGuildNoRaw and (nil ~= myGuildWrapper) then
		isMyGuildHouse = true
	else
		isMyGuildHouse = false
	end
	HouseUseTypeState_Control._Btn_LargCraft:SetShow( isMyGuildHouse )

end

function FGlobal_HouseUseTypeState_Update( guildNoRaw )
	if Worldmap_Grand_GuildHouseControl:GetShow() and guildNoRaw == ownerGuildNoRaw then
		local guildName 		= ToClient_guild_getGuildName( guildNoRaw )
		local guildMasterName	= ToClient_guild_getGuildMasterName( guildNoRaw )

		HouseUseTypeState_Control._WorkName				:SetText( guildName )
		HouseUseTypeState_Control._OnGoingText_Vlaue	:SetText( guildMasterName )

		HouseUseTypeState_Control._Icon_Working:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
		local isSet = setGuildTextureByGuildNo( guildNoRaw, HouseUseTypeState_Control._Icon_Working )
		if ( false == isSet ) then
			local x1, y1, x2, y2 = setTextureUV_Func( HouseUseTypeState_Control._Icon_Working, 183, 1, 188, 6 )
			HouseUseTypeState_Control._Icon_Working:getBaseTexture():setUV(  x1, y1, x2, y2  )
			HouseUseTypeState_Control._Icon_Working:setRenderTexture(HouseUseTypeState_Control._Icon_Working:getBaseTexture())
		else	
			HouseUseTypeState_Control._Icon_Working:getBaseTexture():setUV(  0, 0, 1, 1  )
			HouseUseTypeState_Control._Icon_Working:setRenderTexture(HouseUseTypeState_Control._Icon_Working:getBaseTexture())
		end

		ownerGuildNoRaw = nil
	else
		--return false
	end
end

function HouseImage_Control:Update()											-- 길드 하우스 내부 이미지 갱신
	local guildHouseInfoSSW	= ToClient_GetGuildHouseInfoStaticStatusWrapper( HouseInfo_Control._houseKeyRaw )

	local getKeyRaw			= HouseInfo_Control._houseKeyRaw

	-- local guildHouseSS		= guildHouseWrapper:get()
	-- local houseImg			= ToClient_getScreenShotPath(guildHouseSS, 0)
	if nil ~= guildHouse_Img[getKeyRaw] then
		self._Image	:ChangeTextureInfoName( guildHouse_Img[getKeyRaw] )
	else
		self._Image	:ChangeTextureInfoName( "icon/new_icon/03_etc/06_housing/1201.dds" )
	end
end


function Worldmap_Grand_GuildHouseControl_Close()								-- 길드 제작창을 닫는다.
	local guildHouseInfoSSW	= ToClient_GetGuildHouseInfoStaticStatusWrapper( HouseInfo_Control._houseKeyRaw )
	local wayPointKey		= guildHouseInfoSSW:getParentNodeKey()
	local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(wayPointKey)
	if ( nil ~= regionInfoWrapper ) and ( regionInfoWrapper:hasWarehouseManager() ) then
		warehouse_requestInfo( wayPointKey )	-- 거점 창고로 변경.
	end
	guildHouseButton = nil
end

function Worldmap_Grand_GuildCraft_Open()										-- 제작 창을 오픈한다.
	if nil == WorkList_Control._selecthouseKeyRaw or nil == WorkList_Control._selectRecipeKeyRaw then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_PLZ_SELECT_USETYPE") )	-- "먼저 용도를 선택해야 합니다."
		return
	end
	
	-- 관련 함수
	WorldMapPopupManager:increaseLayer( false )
	WorldMapPopupManager:push( Worldmap_Grand_GuildCraft, true, nil, Worldmap_Grand_GuildCraftControl_Update )
	FGlobal_GuildCraft_Open( WorkList_Control._selecthouseKeyRaw, WorkList_Control._selectRecipeKeyRaw )
end


function Worldmap_Grand_GuildCraftControl_Update()								-- 길드 하우스 관리 창 오픈
	if Panel_Window_Warehouse:GetShow() then	-- 창고를 보이지 않는다.
		Warehouse_Close()
	end

	HouseUseType_Control:Update()			-- 용도 목록 갱신
	HouseUseTypeState_Control:Update()		-- 진행 상황 갱신
	HouseImage_Control:Update()				-- 길드 하우스 내부 이미지 갱신

	local guildHouseInfoSSW	= ToClient_GetGuildHouseInfoStaticStatusWrapper( HouseInfo_Control._houseKeyRaw )
	local houseKeyRaw		= HouseInfo_Control._houseKeyRaw
	local houseName			= guildHouseInfoSSW:getHouseName()
	Panel_Control._txt_House_Title:SetText( houseName )

	local recipeCount		= guildHouseInfoSSW:getReceipeCount()
	if 0 < recipeCount then
		local houseCraftWrapper = guildHouseInfoSSW:getHouseCraftWrapperByIndex( 0 )
		local recipeKeyRaw		= houseCraftWrapper:getReceipeKeyRaw()
		GuildHouse_WorkList_Update( houseKeyRaw, recipeKeyRaw )	-- 처음을 선택한 것으로...	

		for typeIdx = 0, HouseUseType_Control.listCount -1 do
			local typeList = HouseUseType_Control.uiList[typeIdx]
			if 0 == typeIdx then
				typeList.btn:SetCheck( true )
			else
				typeList.btn:SetCheck( false )
			end
		end
	end


	local guildHouseWrapper	= ToClient_getHouseholdInfoInClientWrapper( HouseInfo_Control._houseKeyRaw )

	if ( guildHouseWrapper:getOwnerGuildNo() == getSelfPlayer():getGuildNo_s64() ) then
		warehouse_requestGuildWarehouseInfo()		-- 길드 창고를 쓸 것이라고 선언
	end
end

function FromClient_WorldMapGuildHouseLClick( guildUIButton )					-- 길드 하우스 아이콘을 클릭!
	if not isContentsEnable then
		return
	end
	local guildHouseInfoSSW			= guildUIButton:getGuildHouseInfoStaticStatusWrapper()
	HouseInfo_Control._houseKeyRaw	= guildHouseInfoSSW:getKeyRaw()

	Worldmap_Grand_GuildCraftControl_Update()
	WorldMapPopupManager:increaseLayer( true )
	WorldMapPopupManager:push( Worldmap_Grand_GuildHouseControl, true, nil, nil )
end

function GuildCraftControl_onScreenResize()
	Worldmap_Grand_GuildHouseControl:ComputePos()
end

registerEvent( "FromClient_WorldMapGuildHouseLClick",	"FromClient_WorldMapGuildHouseLClick")
registerEvent( "onScreenResize",						"GuildCraftControl_onScreenResize" )
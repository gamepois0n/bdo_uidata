Panel_Worker_Auction:SetShow(false)
Panel_Worker_Auction:setMaskingChild(true)
Panel_Worker_Auction:ActiveMouseEventEffect(true)
Panel_Worker_Auction:SetDragEnable( true )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local auctionInfo = RequestGetAuctionInfo()

local workerList = {}


local workerAuction = {
	_config =
	{
		slot	=
		{
			startX	= 5,
			startY	= 5,
			gapY	= 115,
		},
		
		-- 슬롯_스킬 위치
		skill	=
		{			
			gapX			= 4,			
		},	
						
		slotCount			= 4,
	},
	
	_mainBG					=	UI.getChildControl( Panel_Worker_Auction,	"Static_BG" ),
	_listBG					=	UI.getChildControl( Panel_Worker_Auction,	"Static_BG_1" ),
	_topBG					=	UI.getChildControl( Panel_Worker_Auction,	"Static_BG_Top" ),
	
	_btnWinQuestion			=	UI.getChildControl( Panel_Worker_Auction,	"Button_Question" ),				-- 물음표
	_btnWinClose			=	UI.getChildControl( Panel_Worker_Auction,	"Button_Win_Close" ),				-- 창 닫음 버튼
		
	_btnTabMarket			=	UI.getChildControl( Panel_Worker_Auction,	"radioButton_MarketList" ),				-- 시장 목록
	_btnTabMine				=	UI.getChildControl( Panel_Worker_Auction,	"radioButton_MyList" ),					-- 내 등록 목록
		
	_filterBG				=	UI.getChildControl( Panel_Worker_Auction,	"Static_FilterBG" ),
	_comboFilterZone		=	UI.getChildControl( Panel_Worker_Auction,	"Combobox_Filter_Zone" ),			-- 지역 검색
	_comboFilterTribe		=	UI.getChildControl( Panel_Worker_Auction,	"Combobox_Filter_Tribe" ),			-- 종족 검색
	_comboFilterSkill		=	UI.getChildControl( Panel_Worker_Auction,	"Combobox_Filter_Skill" ),			-- 기술 검색
	
	_slots					= 	Array.new(),
			
	_btnResist				=	UI.getChildControl( Panel_Worker_Auction,	"Button_WorkerResist" ),			-- 일꾼 등록
	_btnBuy					=	UI.getChildControl( Panel_Worker_Auction,	"Button_Buy" ),						-- 구매 하기
	_btnReceive				=	UI.getChildControl( Panel_Worker_Auction,	"Button_Receive" ),					-- 판매금 받기
	_btnCancel				=	UI.getChildControl( Panel_Worker_Auction,	"Button_Cancel" ),					-- 취소 하기
	_btnEnd					=	UI.getChildControl( Panel_Worker_Auction,	"Button_End" ),						-- 만료(취소)
		
	_radioInvenMoney		=	UI.getChildControl( Panel_Worker_Auction,	"RadioButton_Inventory" ),			-- 가방 소지금 버튼
	_radioWareHouseMoney	=	UI.getChildControl( Panel_Worker_Auction,	"RadioButton_Warehouse" ),			-- 창고 소지금 버튼
	_textInvenMoney			=	UI.getChildControl( Panel_Worker_Auction,	"Static_Text_Money1" ),			-- 가방 보유 금액(텍스트)
	_textWareHouseMoney		=	UI.getChildControl( Panel_Worker_Auction,	"Static_Text_Money2" ),			-- 창고 보유 금액(텍스트)
	_staticInvenMoney		=	UI.getChildControl( Panel_Worker_Auction,	"StaticText_InventoryMoney" ),		-- 가방 소지금
	_staticWareHouseMoney	=	UI.getChildControl( Panel_Worker_Auction,	"StaticText_WareHouseMoney" ),		-- 창고 소지금
		
	_btnPrev				=	UI.getChildControl( Panel_Worker_Auction,	"Button_Prev" ),					-- 이전 페이지
	_staticPageNo			=	UI.getChildControl( Panel_Worker_Auction,	"Static_PageNo" ),					-- 현재 페이지	
	_btnNext				=	UI.getChildControl( Panel_Worker_Auction,	"Button_Next" ),					-- 다음 페이지
	
	_slotCount				=	4,	
	_skillCount				=	7,
	_selectSlotNo			=	nil,
	_selectPage				=	0,
	_selectMaxPage			=	0,
	_isTabMine				=	false,
	_plantKey				=	nil,
	_isPaging				= 	false,
	
	
}

local createAndCopyBasePropertyControlSetPosition = function( fromParent, fromStrID, parent, strID, originalParent )
	local ui = UI.createAndCopyBasePropertyControl( fromParent, fromStrID, parent, strID )
	if ( nil ~= originalParent ) then
		local originalParentUI = UI.getChildControl( Panel_Worker_Auction,	originalParent )
		local originalUI = UI.getChildControl( Panel_Worker_Auction,	fromStrID )
		ui:SetPosX( originalUI:GetPosX() - originalParentUI:GetPosX())
		ui:SetPosY( originalUI:GetPosY() - originalParentUI:GetPosY())
	else
		ui:SetPosX( ui:GetPosX() - parent:GetPosX())
		ui:SetPosY( ui:GetPosY() - parent:GetPosY())
	end
	return ui
end

function workerAuction:Init()
	for ii = 0, self._slotCount-1 do
		local slot 					=	{}
		slot.slotNo					=	ii
		slot._panel					=	Panel_Worker_Auction
		slot._startSlotIndex		=	0
		slot._learnSkillCount		= 	0
				
		slot._baseSlotBG			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_LineBG_1",				self._listBG,			"workerMarket_Slot_"					.. ii )
		
		slot._workerIconBG			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_WorkerIconBG",			slot._baseSlotBG,		"workerMarket_Slot_workerIconBG"		.. ii, "Static_LineBG_1" )
		slot._workerIcon			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_workerIcon",				slot._workerIconBG,		"workerMarket_Slot_workerIcon"			.. ii, "Static_WorkerIconBG" )

		slot._workerLv				= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_WorkerLevel",			slot._workerIconBG,		"workerMarket_Slot_workerLv"			.. ii, "Static_WorkerIconBG" )
		slot._workerName			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_Name",					slot._baseSlotBG,		"workerMarket_Slot_workerName"			.. ii, "Static_LineBG_1" )
		slot._workerZone			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_Zone",					slot._baseSlotBG,		"workerMarket_Slot_workerZone"			.. ii, "Static_LineBG_1" )
		slot._workSpeed				= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_WorkSpeed",				slot._baseSlotBG,		"workerMarket_Slot_workSpeed"			.. ii, "Static_LineBG_1" )
		slot._workSpeedValue		= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_WorkSpeedValue",			slot._baseSlotBG,		"workerMarket_Slot_workSpeedValue"		.. ii, "Static_LineBG_1" )
		slot._moveSpeed				= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_MoveSpeed",				slot._baseSlotBG,		"workerMarket_Slot_moveSpeed"			.. ii, "Static_LineBG_1" )
		slot._moveSpeedValue		= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_MoveSpeedValue",			slot._baseSlotBG,		"workerMarket_Slot_moveSpeedValue"		.. ii, "Static_LineBG_1" )
		slot._luck					= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_Luck",					slot._baseSlotBG,		"workerMarket_Slot_luck"				.. ii, "Static_LineBG_1" )
		slot._luckValue				= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_LuckValue",				slot._baseSlotBG,		"workerMarket_Slot_luckValue"			.. ii, "Static_LineBG_1" )
		slot._actionPoint			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_ActionPoint",			slot._baseSlotBG,		"workerMarket_Slot_actionPoint"			.. ii, "Static_LineBG_1" )
		slot._actionPointValue		= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_ActionPointValue",		slot._baseSlotBG,		"workerMarket_Slot_actionPointValue"	.. ii, "Static_LineBG_1" )
		slot._upgradeChance			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_UpgradeChance",			slot._baseSlotBG,		"workerMarket_Slot_upgradeChance"		.. ii, "Static_LineBG_1" )
		slot._upgradeChanceValue	= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_UpgradeChanceValue",		slot._baseSlotBG,		"workerMarket_Slot_upgradeChanceValue"	.. ii, "Static_LineBG_1" )
		slot._workerPrice			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_Price",					slot._baseSlotBG,		"workerMarket_Slot_workerPrice"			.. ii, "Static_LineBG_1" )
		slot._workerPriceValue		= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_PriceValue",				slot._baseSlotBG,		"workerMarket_Slot_workerPriceValue"	.. ii, "Static_LineBG_1" )

		slot._SkillBG				= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_WorkerSkillSlotBG",		slot._baseSlotBG,		"workerMarket_Slot_SkillBG"				.. ii, "Static_LineBG_1" )
				
		slot._skill					= 	Array.new()
		
		for jj = 0, self._skillCount-1 do
			local skill				= {}
			skill._SkillIconBG		= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_SkillIconBG_01",			slot._SkillBG,		"workerMarket_Slot_slotSkillIconBG"	.. ii .. "_" .. jj, "Static_WorkerSkillSlotBG"  )
			skill._SkillIconBG:SetPosX( ( jj * ( self._config.skill.gapX + skill._SkillIconBG:GetSizeX() ) ) ) 
			skill._SkillIcon		= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Static_SkillSlot_01",			slot._SkillBG,		"workerMarket_Slot_slotSkillIcon"		.. ii .. "_" .. jj, "Static_WorkerSkillSlotBG"  )
			skill._SkillIcon:SetPosX( ( jj * ( self._config.skill.gapX + skill._SkillIconBG:GetSizeX() ) ) )
			slot._skill[jj]			= 	skill			
		end
		
		slot._btnBuy				= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Button_Buy",					slot._baseSlotBG,		"workerMarket_Slot_buttonBuy"		.. ii, "Static_LineBG_1" )
		slot._btnReceive			= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Button_Receive",				slot._baseSlotBG,		"workerMarket_Slot_buttonReceive"	.. ii, "Static_LineBG_1" )
		slot._btnCancel				= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Button_Cancel",					slot._baseSlotBG,		"workerMarket_Slot_buttonCancel"	.. ii, "Static_LineBG_1" )
		slot._btnEnd				= 	createAndCopyBasePropertyControlSetPosition( Panel_Worker_Auction, "Button_End",					slot._baseSlotBG,		"workerMarket_Slot_buttonEnd"		.. ii, "Static_LineBG_1" )
	
		self._btnPrev:SetAutoDisableTime( 1.0 )
		self._btnNext:SetAutoDisableTime( 1.0 )
		slot._btnBuy:SetAutoDisableTime( 3.0 )
		slot._btnReceive:SetAutoDisableTime( 3.0 )
		slot._btnCancel:SetAutoDisableTime( 3.0 )
		slot._btnEnd:SetAutoDisableTime( 3.0 )
	
		-- 좌표 설정
		
		local slotConfig	= self._config.slot
		slot._baseSlotBG:SetPosX( slotConfig.startX )
		slot._baseSlotBG:SetPosY( slotConfig.startY + slotConfig.gapY * ii)		
				
		self._slots[ii]	= slot	
	end
	
	self._btnWinQuestion:SetShow( false )
	
	-- 검색 조건 숨김 처리 + 사이즈와 포지션 조정(추후 조건 검색 추가 시 삭제하면 됨)
	self._filterBG:SetShow( false )
	self._comboFilterZone:SetShow( false )
	self._comboFilterTribe:SetShow( false )
	self._comboFilterSkill:SetShow( false )	
	self._btnResist		:SetShow( true )
	
	Panel_Worker_Auction:SetSize( Panel_Worker_Auction:GetSizeX(), ( Panel_Worker_Auction:GetSizeY() - 35 ) )
	self._mainBG:SetSize( self._mainBG:GetSizeX(), 515 )
	self._listBG:SetSize( self._listBG:GetSizeX(), 465 )
	self._listBG:SetPosY( self._topBG:GetPosY() + self._topBG:GetSizeY() + 5)
	
	self._radioInvenMoney:ComputePos()
	self._radioWareHouseMoney:ComputePos()
	self._textInvenMoney:ComputePos()
	self._textWareHouseMoney:ComputePos()
	self._staticInvenMoney:ComputePos()
	self._staticWareHouseMoney:ComputePos()
		
	self._btnPrev:ComputePos()
	self._staticPageNo:ComputePos()	
	self._btnNext:ComputePos()
	
	self._btnPrev:SetEnable( false )
	self._btnNext:SetEnable( false )
	
	self._btnTabMarket:SetCheck( true )
	self._radioInvenMoney:SetCheck( true )
end

function workerAuction:registEventHandler()
	self._btnWinClose	:addInputEvent( "Mouse_LUp", "WorkerAuction_Close()" )
	self._btnTabMarket	:addInputEvent(	"Mouse_LUp", "workerAuction_TabEvent( false )")
	self._btnTabMine	:addInputEvent(	"Mouse_LUp", "workerAuction_TabEvent( true )")	
	self._btnResist		:addInputEvent( "Mouse_LUp", "FGlobal_AuctionResist_WorkerList()" )
	self._btnNext		:addInputEvent( "Mouse_LUp", "WorkerAuction_NextPage()" )
	self._btnPrev		:addInputEvent( "Mouse_LUp", "WorkerAuction_PrevPage()" )		
end


function workerAuction:Update()
	WorkerAuction_UpdateMoney() -- 소지금 계산
	
	local self 			= workerAuction	
	
	for	ii = 0, self._slotCount-1	do
		local	slot	= self._slots[ii]		
		slot._baseSlotBG		:SetShow(false)				
	end	
	
	workerList = {}
	
	-- local auctionCount 	= auctionInfo:getWorkerAuctionCount()
	local	startSlotNo		= 0
	local	endSlotNo		= 0
	
	if ( workerAuction_IsTabMine() ) then
		startSlotNo			= self._selectPage * self._slotCount
		endSlotNo			= startSlotNo + self._slotCount - 1		
		local maxCount		= auctionInfo:getWorkerAuctionCount()
		self._selectMaxPage	= math.floor( maxCount / self._slotCount) - 1
		if 0 < ( maxCount % self._slotCount ) then
			self._selectMaxPage	= self._selectMaxPage + 1
		end			
	else		
		endSlotNo			= auctionInfo:getWorkerAuctionCount()		
	end
	
	local uiIdx = 0
	for index = startSlotNo, endSlotNo do
		local workerNoRaw 			= auctionInfo:getWorkerAuction(index)
		local workerWrapper 		= getWorkerWrapperByAuction(workerNoRaw, true)					
			
		workerList[index] = workerWrapper
		
		if nil ~= workerWrapper then
			local slot	= self._slots[uiIdx]
			
			local workerIcon			= workerWrapper:getWorkerIcon()
			local workerLv				= workerWrapper:getLevel()
			local workerName			= workerWrapper:getName()
			local workerPrice			= auctionInfo:getWorkerAuctionPrice(workerNoRaw)
			
			local workerZone			= workerWrapper:getHomeWaypoint()
			local workerUpgradeCount	= workerWrapper:getUpgradePoint()
			
			local moveSpeedValue		= workerWrapper:getMoveSpeed()			
			local luckValue				= workerWrapper:getLuck()
			local actionPointValue		= workerWrapper:getActionPoint()
			local workerZoneName		= ToClient_GetNodeNameByWaypointKey ( workerZone )			
			
			local workSpeedValue = 0
			if workSpeedValue < workerWrapper:getWorkEfficiency(2) then	-- 거점생산
				workSpeedValue = workerWrapper:getWorkEfficiency(2)
			end
			if workSpeedValue < workerWrapper:getWorkEfficiency(5) then	-- 집제작
				workSpeedValue = workerWrapper:getWorkEfficiency(5)
			end
			if workSpeedValue < workerWrapper:getWorkEfficiency(6) then	-- 성채건설
				workSpeedValue = workerWrapper:getWorkEfficiency(6)
			end
			if workSpeedValue < workerWrapper:getWorkEfficiency(8) then	-- 대량생산
				workSpeedValue = workerWrapper:getWorkEfficiency(8)
			end
			
			slot._workerIcon			:ChangeTextureInfoName(workerIcon)
			slot._workerLv				:SetText ( "Lv." .. tostring( workerLv ) )
			slot._workerName			:SetText ( workerWrapper:getGradeToColorString() .. workerName .. "<PAColor0xffc4bebe> (" .. workerZoneName .. ")<PAOldColor>" )			
			slot._upgradeChanceValue	:SetText ( tostring( workerUpgradeCount ) )
			slot._moveSpeedValue		:SetText ( string.format("%.2f", (moveSpeedValue/100) ) )
			slot._workSpeedValue		:SetText ( string.format("%.2f", (workSpeedValue/1000000 )) )
			slot._luckValue				:SetText ( string.format("%.2f",( luckValue/10000 )) )
			slot._actionPointValue		:SetText ( tostring( actionPointValue ) )
			slot._workerPriceValue		:SetText ( makeDotMoney( workerPrice ) )
					
			slot._baseSlotBG			:SetShow ( true )		
			slot._workerIcon			:SetShow ( true )		
			slot._workerLv				:SetShow ( true )
			slot._workerName			:SetShow ( true )
			slot._workerZone			:SetShow ( false )
			slot._upgradeChanceValue	:SetShow ( true )
			slot._moveSpeedValue		:SetShow ( true )
			slot._workSpeedValue		:SetShow ( true )
			slot._luckValue				:SetShow ( true )
			slot._actionPointValue		:SetShow ( true )

			if 4 <= workerWrapper:getGrade() then	-- 장인 일꾼부터 승급 기회를 보여주지 않는다.					
				slot._upgradeChance	:SetMonoTone( true )
				slot._upgradeChance	:SetFontColor( UI_color.C_FF515151 )
				slot._upgradeChance	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANNOTUPGRADE"))	-- 승급 불가
				slot._upgradeChanceValue	:SetShow ( false )
			else
				slot._upgradeChance	:SetMonoTone( false )
				slot._upgradeChance	:SetFontColor( UI_color.C_FFFF7C67 )
				slot._upgradeChance	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_UPGRADECHANCE")) -- 승급 기회
				slot._upgradeChanceValue	:SetShow ( true )
			end
			
			if true == workerWrapper:isMine() then
				slot._btnBuy	:SetEnable( false )
				slot._btnBuy	:SetMonoTone( true )
				slot._btnBuy	:SetFontColor( UI_color.C_FF515151 )
				slot._btnBuy	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_MYWORKER"))	-- 본인 등록
			else
				slot._btnBuy	:SetEnable( true )
				slot._btnBuy	:SetMonoTone( false )
				slot._btnBuy	:SetFontColor( UI_color.C_FFEFEFEF )
				slot._btnBuy	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYWORKER"))	-- 구매하기
			end
			
			slot._btnBuy				:addInputEvent(	"Mouse_LUp", "WorkerAuction_Buy(" .. index .. ")"		)
			slot._btnReceive			:addInputEvent(	"Mouse_LUp", "WorkerAuction_Receive(" .. index .. ")"		)
			slot._btnCancel				:addInputEvent(	"Mouse_LUp", "WorkerAuction_Cancel(" .. index .. ")"		)
			
			-- 스킬 슬롯
			for ii = 0, self._skillCount-1 do
				slot._skill[ii]._SkillIconBG:SetShow ( false )
				slot._skill[ii]._SkillIcon:SetShow ( false )				
			end
			
			workerWrapper:foreachSkillList( 
				function(skillIdx, skillStaticStatusWrapper)			
					if ( nil == slot._skill[skillIdx] ) then
						return true
					end
					slot._skill[skillIdx]._SkillIconBG:SetShow(true)
					slot._skill[skillIdx]._SkillIcon:SetShow(true)
					slot._skill[skillIdx]._SkillIcon:ChangeTextureInfoName( skillStaticStatusWrapper:getIconPath() )
					slot._skill[skillIdx]._SkillIcon	:addInputEvent("Mouse_On",  "workerAuction_SkillTooltip( true, " .. index .. ", " .. uiIdx .. ", " .. skillIdx .. ")" )
					slot._skill[skillIdx]._SkillIcon	:addInputEvent("Mouse_Out", "workerAuction_SkillTooltip( false )" )
					return false
				end
			)
			
			slot._learnSkillCount	= 0
			local tempIndex			= 0
			local slotIndex			= 0			
			
			slot._btnBuy	:SetShow( false )
			slot._btnReceive:SetShow( false )
			slot._btnCancel	:SetShow( false )
			slot._btnEnd	:SetShow( false )
			
			if ( workerAuction_IsTabMine() ) then
				slot._btnBuy	:SetShow( false )
				local isEndAuction = auctionInfo:getWorkerAuctionEnd( workerNoRaw )				
				if true == isEndAuction then
					slot._btnReceive:SetShow( true )
				else
					slot._btnCancel	:SetShow( true )
				end				
			else
				slot._btnBuy	:SetShow( true )
			end
			
			uiIdx = uiIdx + 1
		end	
		
	end
	self._staticPageNo	:SetText( self._selectPage + 1 )	
end

function workerAuction_SkillTooltip( isShow, dataIdx, uiIdx, skillIdx )
	if true == isShow then
		local workerNoRaw 			= auctionInfo:getWorkerAuction( dataIdx )
		local workerWrapperLua 		= getWorkerWrapperByAuction( workerNoRaw, true )
		local skillSSW				= workerWrapperLua:getSkillSSW( skillIdx )

		local slot		= workerAuction._slots[uiIdx]
		local uiControl	= slot._skill[skillIdx]._SkillIcon
		local name		= skillSSW:getName()
		local desc		= skillSSW:getDescription()

		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function workerAuction_TabEvent( isTabMine )
	local	self	= workerAuction
	-- if	workerAuction_IsTabMine() == isTabMine	then
		-- return
	-- end
	
	workerAuction_TabToList( isTabMine )
end

function workerAuction_TabToList( isTabMine )
	local	self	= workerAuction
	self._selectPage	= 0
	self._selectMaxPage	= 0
	self._isTabMine		= isTabMine
	
	if	workerAuction_IsTabMine()	then
		requestMyWorkerList()
	else
		RequestAuctionListPage( CppEnums.AuctionType.AuctionGoods_WorkerNpc )		
	end
end

function workerAuction_IsTabMine()
	local self	= workerAuction
	
	return(	self._isTabMine )
end



-- 리스트 페이지 전환
function WorkerAuction_PrevPage()
	local	self	= workerAuction
	
	if workerAuction_IsTabMine() then
		if 0 < self._selectPage then
			self._selectPage	= self._selectPage - 1
			self._isPaging		= true
			workerAuction:Update()
		end
	else
		if 0 < self._selectPage then
			self._selectPage	= self._selectPage - 1
			self._isPaging		= true
			self._btnPrev:SetEnable( false )
			self._btnNext:SetEnable( false )
			RequestAuctionPrevPage()
		else
			return
		end
	end
end

function WorkerAuction_NextPage()
	local self	= workerAuction
	local workerNoRaw 			= auctionInfo:getWorkerAuction(index)
	local workerWrapper 		= getWorkerWrapperByAuction(workerNoRaw, true)	
		
	if workerAuction_IsTabMine() then
		if	self._selectMaxPage <= self._selectPage	then
			return
		end	
		self._selectPage	= self._selectPage + 1
		self._isPaging		= true
		workerAuction:Update()
	else		
		if nil == workerWrapper then
			return
		else
			self._selectPage	= self._selectPage + 1
			self._isPaging		= true
			self._btnPrev:SetEnable( false )
			self._btnNext:SetEnable( false )
			RequestAuctionNextPage()
		end
	end
end

-- 사고 받고 취소하기
function WorkerAuction_Buy( slotNo )
	local self 			= workerAuction
	self._selectSlotNo 	= slotNo
	local workerNoRaw 	= auctionInfo:getWorkerAuction( self._selectSlotNo )
	local workerWrapper 		= getWorkerWrapperByAuction(workerNoRaw, true)						
	local workerLv				= workerWrapper:getLevel()
	local workerName			= workerWrapper:getName()
	local workerPrice			= auctionInfo:getWorkerAuctionPrice(workerNoRaw)
	
	local titleString		= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCONFIRM") -- 구매 확인
	local contentString		= workerWrapper:getGradeToColorString() .. PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCONFIRM_TITLE", "level", tostring(workerLv), "name", workerName, "price", makeDotMoney(workerPrice)) -- "Lv." .. tostring(workerLv) .. " " .. workerName .. "<PAOldColor>을\n\n" .. "<PAColor0xfff0d090>" .. makeDotMoney(workerPrice) .. "<PAOldColor> 실버에 구매하시겠습니까?"
	local messageboxData	= { title = titleString, content = contentString, functionYes = WorkerAuction_BuyXXX, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData)
end

function WorkerAuction_BuyXXX()
	local self 				= workerAuction
	local workerNoRaw 		= auctionInfo:getWorkerAuction( self._selectSlotNo )
	
	local fromWhereType	= CppEnums.ItemWhereType.eInventory
	if (self._radioWareHouseMoney:IsCheck()) then
		fromWhereType	= CppEnums.ItemWhereType.eWarehouse
	end
	auctionInfo:requestBuyItNowWorker( workerNoRaw, fromWhereType )	
	self._selectSlotNo	= nil
end

function WorkerAuction_Cancel( slotNo )
	local self 				= workerAuction
	self._selectSlotNo	 	= slotNo
	local workerNoRaw 		= auctionInfo:getWorkerAuction( self._selectSlotNo )	
	local workerWrapper 	= getWorkerWrapperByAuction(workerNoRaw, true)						
	local workerLv			= workerWrapper:getLevel()
	local workerName		= workerWrapper:getName()
	
	local titleString		= PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANCELCONFIRM") -- "등록 취소 확인"
	local contentString		= workerWrapper:getGradeToColorString() .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_CANCELCONFIRM_TITLE", "level", tostring(workerLv), "name", workerName) -- "Lv." .. tostring(workerLv) .. " " .. workerName .. "<PAOldColor>을\n\n" .. "등록 취소하시겠습니까?"
	local messageboxData	= { title = titleString, content = contentString, functionYes = WorkerAuction_CancelXXX, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData)	
end

function WorkerAuction_CancelXXX()
	local self 				= workerAuction
	local workerNoRaw 		= auctionInfo:getWorkerAuction( self._selectSlotNo )	
	
	ToClient_requestCancelRegisterMyWorkerAuction( workerNoRaw )
	self._selectSlotNo	= nil	
end

function WorkerAuction_Receive( slotNo )
	local self 				= workerAuction
	self._selectSlotNo 		= slotNo
	local workerNoRaw 		= auctionInfo:getWorkerAuction( self._selectSlotNo )
	local fromWhereType		= CppEnums.ItemWhereType.eInventory
	if (self._radioWareHouseMoney:IsCheck()) then
		fromWhereType		= CppEnums.ItemWhereType.eWarehouse
	end
	auctionInfo:requestPopWorkerPrice( workerNoRaw, fromWhereType )
	self._selectSlotNo		= nil
end


-- 창 끄고 닫기
function WorkerAuction_Open()
end

function WorkerAuction_Close()
	if	(not Panel_Worker_Auction:IsShow() )	then
		return
	end
	
	Panel_Worker_Auction:SetShow(false)
	Panel_WorkerList_Auction:SetShow(false)
	Panel_WorkerResist_Auction:SetShow(false)
end


-- 돈 체크
function WorkerAuction_UpdateMoney()
	local	self	= workerAuction
	self._staticInvenMoney:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
	self._staticWareHouseMoney:SetText( makeDotMoney(warehouse_moneyFromNpcShop_s64()) )
end


-- 클라이언트 이벤트

function FromClient_ResponseWorkerAuction()	
	if Panel_Window_WorkerRandomSelect:IsShow() then
		Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_WORKERCONTRACT"))  -- "일꾼 계약을 먼저 끝내주세요." 
	else
		local totalSizeY	= ( (Panel_Npc_Dialog:GetSizeY() *2) + Panel_Worker_Auction:GetSizeY() )
		local subSizeY		= Panel_Npc_Dialog:GetSizeY() + Panel_Worker_Auction:GetSizeY()
		Panel_Worker_Auction:SetPosX( (getScreenSizeX() / 2) - (Panel_Worker_Auction:GetSizeX() / 2) )
		if totalSizeY < getScreenSizeY() then
			Panel_Worker_Auction:SetPosY( getScreenSizeY() - Panel_Npc_Dialog:GetSizeY() - Panel_Worker_Auction:GetSizeY() )			
		elseif getScreenSizeY() < subSizeY then
			Panel_Worker_Auction:SetPosY( 5 )
		else
			Panel_Worker_Auction:SetPosY( (getScreenSizeY() / 2) - (Panel_Worker_Auction:GetSizeY() / 2) )
		end
		
		Panel_Worker_Auction:SetShow( true )	
				
		local self = workerAuction
		self._btnTabMarket:SetCheck( true )
		self._btnTabMine:SetCheck( false )
		
		if true ~= self._isPaging then
			self._selectPage	= 0	
		end	
		self._isTabMine 	= false
		workerAuction:Update()
		self._isPaging		= false
		self._btnPrev:SetEnable( true )
		self._btnNext:SetEnable( true )
		
		warehouse_requestInfoFromNpc()
	end
	

	
	-- *** 개발용 코드 *** 

	-- if ( auctionCount == 0 ) then
		-- local workerNoRaw = 1
		-- local transferType = 0
		-- local price = 1
		-- local isSucces = ToClient_requestRegisterNpcWorkerAuction( workerNoRaw, transferType, price )
		-- _PA_LOG("LUA", "Insert isSucces : " .. tostring(isSucces) )
	-- else
		-- local workerNoRaw = 1
		-- local isSucces = ToClient_requestCancelRegisterMyWorkerAuction( workerNoRaw )
		-- _PA_LOG("LUA", "Cancel isSucces : " .. tostring(isSucces) )
	-- end

	-- if ( auctionCount ~= 0 ) then
		-- local workerNoRaw = 1
		-- local symNo32 = auctionInfo:requestBuyItNowWorker( workerNoRaw, CppEnums.ItemWhereType.eInventory )
		-- if ( 0 ~= symNo32 ) then
			-- _PA_LOG("LUA", "symNo32 : " .. tostring(symNo32) )
		-- end
	-- end

	-- requestMyWorkerList()
end

function FromClient_ResponseMyWorkerAuction()	
	self				= workerAuction
	if false == self._isPaging then
		self._selectPage	= 0	
	end		
	self._isTabMine 	= true
	workerAuction:Update()
	self._isPaging		= false
	
	-- local auctionCount = auctionInfo:getWorkerAuctionCount()
	-- for index = 0, auctionCount - 1 do
		-- local workerNoRaw = auctionInfo:getWorkerAuction(index)
		-- local workerWrapper = getWorkerWrapperByAuction(workerNoRaw, true)
		-- workerList[index] = workerWrapper
	-- end
	
	-- *** 개발용 코드 *** 
	--if ( auctionCount ~= 0 ) then
	--	local workerNoRaw = 1
	--	local symNo32 = auctionInfo:requestPopWorkerPrice( workerNoRaw, CppEnums.ItemWhereType.eInventory )
	--	if ( 0 ~= symNo32 ) then
	--		_PA_LOG("LUA", "symNo32 : " .. tostring(symNo32) )
	--	end
	--end
end

function FromClient_RegistAuction() -- 일꾼 등록 완료
	Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_REGISTCOMPLETE"))	--  "일꾼이 정상적으로 등록됐습니다." 
	workerAuction:Update()
	FGlobal_MyworkerList_Update()
end

function FromClient_BuyWorkerAuction() -- 일꾼 구매 완료
	Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_BUYCOMPLETE")) --  "일꾼 구매가 정상적으로 완료됐습니다." 
	workerAuction:Update()
end

function FromClient_PopWorkerPriceAuction() -- 판매 대금 수령 완료
	Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_RECEIVE_PRICE")) --  "일꾼 판매 대금을 정상적으로 수령했습니다."
	workerAuction:Update()	
end

function FromClient_CancelRegistAuction() -- 등록 취소 완료
	Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERAUCTION_COMPLETE_CANCELREGIST")) -- "일꾼을 정상적으로 등록 취소했습니다."
	workerAuction:Update()
end

registerEvent("EventWarehouseUpdate",				"WorkerAuction_UpdateMoney")
registerEvent("FromClient_ResponseWorkerAuction",	"FromClient_ResponseWorkerAuction")
registerEvent("FromClient_ResponseMyWorkerAuction", "FromClient_ResponseMyWorkerAuction")
registerEvent("FromClient_RegistAuction",			"FromClient_RegistAuction")
registerEvent("FromClient_BuyWorkerAuction",		"FromClient_BuyWorkerAuction")
registerEvent("FromClient_PopWorkerPriceAuction",	"FromClient_PopWorkerPriceAuction")
registerEvent("FromClient_CancelRegistAuction",		"FromClient_CancelRegistAuction")


workerAuction:Init()
workerAuction:registEventHandler()
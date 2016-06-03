Panel_Icon_Maid:SetShow( false )
Panel_Icon_Maid:ActiveMouseEventEffect( true )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color		= Defines.Color
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local IM			= CppEnums.EProcessorInputMode

local MaidControl = {
	buttonMaid	= UI.getChildControl( Panel_Icon_Maid, "Button_MaidIcon" )
}
MaidControl.buttonMaid:addInputEvent( "Mouse_LUp", "MaidList_Open()" )		-- 메이드 리스트 오픈
MaidControl.buttonMaid:addInputEvent( "Mouse_On", "MaidFunc_ShowTooltip( true )" )
MaidControl.buttonMaid:addInputEvent( "Mouse_Out", "MaidFunc_ShowTooltip()" )
MaidControl.buttonMaid:ActiveMouseEventEffect( true )

Panel_Window_MaidList:SetShow( false )
Panel_Window_MaidList:setGlassBackground( true )
Panel_Window_MaidList:ActiveMouseEventEffect( true )

local maidList =
{
	contentBg		= UI.getChildControl( Panel_Window_MaidList, "Static_MaidListContentBG" ),
	name			= UI.getChildControl( Panel_Window_MaidList, "StaticText_Name" ),
	town			= UI.getChildControl( Panel_Window_MaidList, "StaticText_Town" ),
	func			= UI.getChildControl( Panel_Window_MaidList, "StaticText_Func" ),
	coolTime		= UI.getChildControl( Panel_Window_MaidList, "StaticText_Cooltime" ),
	btnWarehouse	= UI.getChildControl( Panel_Window_MaidList, "Button_SummonMaid_Warehouse" ),
	btnMarket		= UI.getChildControl( Panel_Window_MaidList, "Button_SummonMaid_Market" ),
	albeCount		= UI.getChildControl( Panel_Window_MaidList, "StaticText_LeftMaidCountValue" ),
	scroll			= UI.getChildControl( Panel_Window_MaidList, "Scroll_MaidList" ),
	
	btnClose		= UI.getChildControl( Panel_Window_MaidList, "Button_Close" ),
	
	config			= {
		gapY		= 25,
		normalSizeY	= 155,
	},
	
	maidInfo		= {},
	maxShowCount	= 5,
	startIndex 		= 0,
	scrollInterval	= 0,
}

maidList.scrollCtrlBtn	= UI.getChildControl( maidList.scroll,	"Scroll_CtrlButton" )
maidList.scrollCtrlBtn	:addInputEvent( "Mouse_LPress",			"HandleClicked_MaidList_ScrollBtn()" )
maidList.btnClose		:addInputEvent( "Mouse_LUp",			"MaidList_Close()" )
maidList.contentBg		:addInputEvent( "Mouse_DownScroll",		"MaidList_ScrollEvent( true )")
maidList.contentBg		:addInputEvent( "Mouse_UpScroll",		"MaidList_ScrollEvent( false )")

function maidList:Init()
	for maidIndex = 0, self.maxShowCount - 1 do
		local temp = {}
		temp.name = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_MaidList, "StaticText_MaidName_" .. maidIndex )
		CopyBaseProperty( self.name, temp.name )
		temp.name:SetPosY( self.name:GetPosY() + ( maidIndex * self.config.gapY ))
		temp.name:SetShow( false )
		
		temp.town = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_MaidList, "StaticText_MaidTown_" .. maidIndex )
		CopyBaseProperty( self.town, temp.town )
		temp.town:SetPosY( self.town:GetPosY() + ( maidIndex * self.config.gapY ))
		temp.town:SetShow( false )
		
		temp.func = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_MaidList, "StaticText_MaidFunc_" .. maidIndex )
		CopyBaseProperty( self.func, temp.func )
		temp.func:SetPosY( self.func:GetPosY() + ( maidIndex * self.config.gapY ))
		temp.func:SetShow( false )
		
		temp.coolTime = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_MaidList, "StaticText_MaidCoolTime_" .. maidIndex )
		CopyBaseProperty( self.coolTime, temp.coolTime )
		temp.coolTime:SetPosY( self.coolTime:GetPosY() + ( maidIndex * self.config.gapY ))
		temp.coolTime:SetShow( false )
		
		self.maidInfo[maidIndex] = temp
	end
end
maidList:Init()

function MaidList_Open()
	local self = maidList
	local maidCount = getTotalMaidList()
	if self.maxShowCount < maidCount then
		self.scroll:SetShow( true )
	elseif maidCount < 1 then
		_PA_LOG("이문종", "페어리 집사가 0명이라니! 이러시면 곤란합니다!" )
		return
	else
		self.scroll:SetShow( false )
	end
	Panel_Window_MaidList:SetShow( true )
	Panel_Window_MaidList:SetPosX( Panel_Icon_Maid:GetPosX() + Panel_Icon_Maid:GetSizeX() )
	Panel_Window_MaidList:SetPosY( Panel_Icon_Maid:GetPosY() )
	
	MaidList_Set()
end

function MaidList_Close()
	if Panel_Window_MaidList:GetShow() then
		Panel_Window_MaidList:SetShow( false )
	end
end

function MaidList_Set( startIndex )
	local self = maidList
	
	if not Panel_Icon_Maid:GetShow() and 0 == getTotalMaidList() then
		Panel_Window_MaidList:SetShow( false )
		return
	end
	
	if self.maxShowCount < getTotalMaidList() then
		self.scroll:SetShow( true )
	else
		self.scroll:SetShow( false )
	end
	
	if nil == startIndex or getTotalMaidList() <= self.maxShowCount then
		self.startIndex = 0
	end
	
	if 0 == self.startIndex then
		self.scroll:SetControlPos( 0 )
	end
	
	-- local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	-- if nil == regionInfo then
		-- return
	-- end
	-- for index = 0, self.maxShowCount - 1 do
		-- if index < getTotalMaidList() then
			-- local maidInfoWrapper = getMaidDataByIndex( index + self.startIndex )
			-- if nil ~= maidInfoWrapper then
				-- self.maidInfo[index].name:SetText( maidInfoWrapper:getName() )
				-- self.maidInfo[index].name:SetShow( true )
				
				-- self.maidInfo[index].town:SetText( getRegionInfoWrapper( maidInfoWrapper:getRegionKey() ):getAreaName() )
				-- self.maidInfo[index].town:SetShow( true )
				
				-- if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
					-- self.maidInfo[index].func:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_WAREHOUSE") ) -- "원격 창고" )
				-- elseif maidInfoWrapper:isAbleSubmitMarket() then
					-- self.maidInfo[index].func:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_MARKET") ) -- "거래소" )
				-- end
				-- self.maidInfo[index].func:SetShow( true )
				
				-- self.maidInfo[index].coolTime:SetShow( true )
				-- local coolTime = maidInfoWrapper:getCoolTime()
				-- _PA_LOG("이문종", "인덱스 == " .. index .. " / " .. coolTime )
				-- if 0 < coolTime then
					-- self.maidInfo[index].coolTime:SetFontColor( Defines.Color.C_FFC4BEBE )
					-- local oneMinute = 60000		-- 1분
					-- if coolTime < oneMinute then
						-- self.maidInfo[index].coolTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_ONEMINUTELEFT") ) -- "1분 이내" )
					-- else
						-- self.maidInfo[index].coolTime:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MAIDLIST_LEFTTIME", "minute", (coolTime/oneMinute) - (coolTime/oneMinute)%1 )) -- (coolTime/oneMinute) - (coolTime/oneMinute)%1 .. "분 남음" )	-- math.ceil() 하고 같음
					-- end
				-- else
					-- self.maidInfo[index].coolTime:SetText( maidInfoWrapper:getName() )
					
					-- local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()	-- 내가 있는 곳의 소속 마을
					-- if myAffiliatedTownRegionKey == maidInfoWrapper:getRegionKey() then			-- 내가 있는 곳 소속 마을 리전키와 메이드 리전키가 같다면
						-- self.maidInfo[index].coolTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_POSSIBLE") ) -- "가능" )
						-- self.maidInfo[index].coolTime:SetFontColor( Defines.Color.C_FFC4BEBE )
					-- else
						-- self.maidInfo[index].coolTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_IMPOSSIBLE") ) -- "불가" )
						-- self.maidInfo[index].coolTime:SetFontColor( Defines.Color.C_FFF26A6A )
					-- end
				-- end
			-- end
		-- else
			-- self.maidInfo[index].name:SetShow( false )
			-- self.maidInfo[index].town:SetShow( false )
			-- self.maidInfo[index].func:SetShow( false )
			-- self.maidInfo[index].coolTime:SetShow( false )
		-- end
	-- end
	
	-- local albeWarehouseMaidCount = 0
	-- local albeMarketMaidCount = 0
	-- for index = 0, getTotalMaidList() - 1 do
		-- local maidInfoWrapper = getMaidDataByIndex( index )
		-- if nil ~= maidInfoWrapper then
			-- if 0 == maidInfoWrapper:getCoolTime() then
				-- local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()	-- 내가 있는 곳의 소속 마을
				-- if myAffiliatedTownRegionKey == maidInfoWrapper:getRegionKey() then			-- 내가 있는 곳 소속 마을 리전키와 메이드 리전키가 같다면
					-- if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
						-- albeWarehouseMaidCount = albeWarehouseMaidCount + 1
					-- end
					-- if maidInfoWrapper:isAbleSubmitMarket() then
						-- albeMarketMaidCount = albeMarketMaidCount + 1
					-- end
				-- end
			-- end
		-- end
	-- end
	
	-- if 0 < albeWarehouseMaidCount then
		-- self.btnWarehouse:SetIgnore( false )
		-- self.btnWarehouse:SetMonoTone( false )
		-- self.btnWarehouse:SetFontColor( Defines.Color.C_FFEFEFEF )
		-- self.btnWarehouse:addInputEvent( "Mouse_LUp", "FGlobal_WarehouseOpenByMaid(" .. 1 .. ")" )		-- 창고
	-- else
		-- self.btnWarehouse:SetIgnore( true )
		-- self.btnWarehouse:SetMonoTone( true )
		-- self.btnWarehouse:SetFontColor( Defines.Color.C_FFC4BEBE )
	-- end
	-- if 0 < albeMarketMaidCount then
		-- self.btnMarket:SetIgnore( false )
		-- self.btnMarket:SetMonoTone( false )
		-- self.btnMarket:SetFontColor( Defines.Color.C_FFEFEFEF )
		-- self.btnMarket:addInputEvent( "Mouse_LUp", "FGlobal_WarehouseOpenByMaid(" .. 0 .. ")" )		-- 거래소
	-- else
		-- self.btnMarket:SetIgnore( true )
		-- self.btnMarket:SetMonoTone( true )
		-- self.btnMarket:SetFontColor( Defines.Color.C_FFC4BEBE )
	-- end
	
	-- local ableMaidCount = albeWarehouseMaidCount + albeMarketMaidCount
	-- self.albeCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_5", "maidCount", ableMaidCount )) -- ableMaidCount .. "명" )
end

function MaidCoolTime_Update()
	local self = maidList
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	if nil == regionInfo then
		return
	end
	for index = 0, self.maxShowCount - 1 do
		if index < getTotalMaidList() then
			local maidInfoWrapper = getMaidDataByIndex( index + self.startIndex )
			if nil ~= maidInfoWrapper then
				self.maidInfo[index].name:SetText( maidInfoWrapper:getName() )
				self.maidInfo[index].name:SetShow( true )
				
				self.maidInfo[index].town:SetText( getRegionInfoWrapper( maidInfoWrapper:getRegionKey() ):getAreaName() )
				self.maidInfo[index].town:SetShow( true )
				
				if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
					self.maidInfo[index].func:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_WAREHOUSE") ) -- "원격 창고" )
				elseif maidInfoWrapper:isAbleSubmitMarket() then
					self.maidInfo[index].func:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_MARKET") ) -- "거래소" )
				end
				self.maidInfo[index].func:SetShow( true )
				
				self.maidInfo[index].coolTime:SetShow( true )
				local coolTime = maidInfoWrapper:getCoolTime()
				if 0 < coolTime then
					self.maidInfo[index].coolTime:SetFontColor( Defines.Color.C_FFC4BEBE )
					local oneMinute = 60000		-- 1분
					if coolTime < oneMinute then
						self.maidInfo[index].coolTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_ONEMINUTELEFT") ) -- "1분 이내" )
					else
						self.maidInfo[index].coolTime:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MAIDLIST_LEFTTIME", "minute", (coolTime/oneMinute) - (coolTime/oneMinute)%1 )) -- (coolTime/oneMinute) - (coolTime/oneMinute)%1 .. "분 남음" )	-- math.ceil() 하고 같음
					end
				else
					self.maidInfo[index].coolTime:SetText( maidInfoWrapper:getName() )
					
					local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()	-- 내가 있는 곳의 소속 마을
					if myAffiliatedTownRegionKey == maidInfoWrapper:getRegionKey() then			-- 내가 있는 곳 소속 마을 리전키와 메이드 리전키가 같다면
						self.maidInfo[index].coolTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_POSSIBLE") ) -- "가능" )
						self.maidInfo[index].coolTime:SetFontColor( Defines.Color.C_FFC4BEBE )
					else
						self.maidInfo[index].coolTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_IMPOSSIBLE") ) -- "불가" )
						self.maidInfo[index].coolTime:SetFontColor( Defines.Color.C_FFF26A6A )
					end
				end
			end
		else
			self.maidInfo[index].name:SetShow( false )
			self.maidInfo[index].town:SetShow( false )
			self.maidInfo[index].func:SetShow( false )
			self.maidInfo[index].coolTime:SetShow( false )
		end
	end
	local albeWarehouseMaidCount = 0
	local albeMarketMaidCount = 0
	for index = 0, getTotalMaidList() - 1 do
		local maidInfoWrapper = getMaidDataByIndex( index )
		if nil ~= maidInfoWrapper then
			if 0 == maidInfoWrapper:getCoolTime() then
				local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()	-- 내가 있는 곳의 소속 마을
				if myAffiliatedTownRegionKey == maidInfoWrapper:getRegionKey() then			-- 내가 있는 곳 소속 마을 리전키와 메이드 리전키가 같다면
					if maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse() then
						albeWarehouseMaidCount = albeWarehouseMaidCount + 1
					end
					if maidInfoWrapper:isAbleSubmitMarket() then
						albeMarketMaidCount = albeMarketMaidCount + 1
					end
				end
			end
		end
	end
	
	if 0 < albeWarehouseMaidCount then
		self.btnWarehouse:SetIgnore( false )
		self.btnWarehouse:SetMonoTone( false )
		self.btnWarehouse:SetFontColor( Defines.Color.C_FFEFEFEF )
		self.btnWarehouse:addInputEvent( "Mouse_LUp", "FGlobal_WarehouseOpenByMaid(" .. 1 .. ")" )		-- 창고
	else
		self.btnWarehouse:SetIgnore( true )
		self.btnWarehouse:SetMonoTone( true )
		self.btnWarehouse:SetFontColor( Defines.Color.C_FFC4BEBE )
	end
	if 0 < albeMarketMaidCount then
		self.btnMarket:SetIgnore( false )
		self.btnMarket:SetMonoTone( false )
		self.btnMarket:SetFontColor( Defines.Color.C_FFEFEFEF )
		self.btnMarket:addInputEvent( "Mouse_LUp", "FGlobal_WarehouseOpenByMaid(" .. 0 .. ")" )		-- 거래소
	else
		self.btnMarket:SetIgnore( true )
		self.btnMarket:SetMonoTone( true )
		self.btnMarket:SetFontColor( Defines.Color.C_FFC4BEBE )
	end
	
	local ableMaidCount = albeWarehouseMaidCount + albeMarketMaidCount
	self.albeCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_5", "maidCount", ableMaidCount )) -- ableMaidCount .. "명" )
end

function MaidList_SetScroll()
	local self				= maidList
	local maidCount			= getTotalMaidList()
	local pagePercent		= ( self.maxShowCount / maidCount ) * 100
	local scroll_Interval	= maidCount - self.maxShowCount
	local scrollSizeY		= self.scroll:GetSizeY()
	local btn_scrollSizeY	= ( scrollSizeY / 100 ) * pagePercent

	if btn_scrollSizeY < 10 then
		btn_scrollSizeY = 10
	end
	if scrollSizeY <= btn_scrollSizeY then
		btn_scrollSizeY = scrollSizeY * 0.99
	end

	self.scrollCtrlBtn	:SetSize( self.scrollCtrlBtn:GetSizeX(), btn_scrollSizeY )
	self.scrollInterval	= scroll_Interval
	self.scroll			:SetInterval( self.scrollInterval )
end

function MaidList_ScrollEvent( isDown )
	local self		= maidList
	local maidCount = getTotalMaidList()
	if maidCount <= self.maxShowCount then
		return
	end
	
	local index		= self.startIndex
	if true == isDown then
		if ( maidCount - self.maxShowCount + 1 ) < index then
			return
		end

		if index < self.scrollInterval then
			self.scroll:ControlButtonDown()
			index = index + 1
		else
			return
		end
	else
		if 0 < index then
			self.scroll:ControlButtonUp()
			index = index - 1
		else
			return
		end
	end	
	
	self.startIndex = index
	MaidList_Set( self.startIndex )
end

function HandleClicked_MaidList_ScrollBtn()
	local self			= maidList
	local maidCount		= getTotalMaidList()
	local posByIndex	= 1 / ( maidCount - self.maxShowCount )
	local currentIndex	= math.floor( self.scroll:GetControlPos() / posByIndex )
	self.startIndex		= currentIndex
	MaidList_Set( self.startIndex )
end

local dontGoMaid = -1
local maidType = -1			-- 0이면 거래소 / 1이면 창고
function FGlobal_WarehouseOpenByMaid( index )
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	if nil == regionInfo then
		return
	end
	local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()
	
	local warehouseInMaid = checkMaid_WarehouseIn( true )
	local warehouseOutMaid = checkMaid_WarehouseOut( true )
	local marketMaid = checkMaid_SubmitMarket( true )
	
	-- 거래소 오픈
	if 0 == index then
		if marketMaid then
			if IsSelfPlayerWaitAction() then
				FGlobal_ItemMarket_OpenByMaid()

				-- 메이드가 나와있는 상황에서 또 소환되면, 같은 installationNo로 같은 아이 호출
				if ToClient_CheckExistSummonMaid() and -1 ~= dontGoMaid then
					if 0 == maidType then			-- 거래소 메이드가 나와있다면,
						ToClient_CallHandlerMaid( "_marketMaid" )
					else							-- 창고 메이드가 나와있다면, 창고 메이드 들여보내고 거래소 메이드 소환
						for mIndex = 0, getTotalMaidList() - 1 do
							local maidInfoWrapper = getMaidDataByIndex( mIndex )
							if myAffiliatedTownRegionKey == maidInfoWrapper:getRegionKey() then
								if maidInfoWrapper:isAbleSubmitMarket() and 0 == maidInfoWrapper:getCoolTime() then
									ToClient_SummonMaid( maidInfoWrapper:getInstallationNo(), 1 )
									ToClient_CallHandlerMaid("_warehouseMaidLogOut")
									ToClient_CallHandlerMaid( "_marketMaid" )
									dontGoMaid = mIndex
									MaidList_Close()
									maidType = 0
									break
								end
							end
						end
					end
					MaidList_Close()
				else
					for mIndex = 0, getTotalMaidList() - 1 do
						local maidInfoWrapper = getMaidDataByIndex( mIndex )
						if myAffiliatedTownRegionKey == maidInfoWrapper:getRegionKey() then
							if maidInfoWrapper:isAbleSubmitMarket() and 0 == maidInfoWrapper:getCoolTime() then
								ToClient_SummonMaid( maidInfoWrapper:getInstallationNo(), 1 )
								ToClient_CallHandlerMaid( "_marketMaid" )
								dontGoMaid = mIndex
								MaidList_Close()
								maidType = 0
								break
							end
						end
					end
				end
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_ALERT") ) -- "대기 상태에서만 호출할 수 있습니다." )
			end
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			SetUIMode(Defines.UIMode.eUIMode_Default)
		end
	end
	
	-- 창고 오픈
	if 1 == index then
		if ( warehouseOutMaid or warehouseInMaid ) then
			if IsSelfPlayerWaitAction() then
				Warehouse_OpenPanelFromMaid()

				local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
				if nil == regionInfo then
					return
				end
				
				-- 메이드가 나와있는 상황에서 또 소환되면, 같은 installationNo로 같은 아이 호출
				if ToClient_CheckExistSummonMaid() and -1 ~= dontGoMaid then
					if 1 == maidType then			-- 창고 메이드가 나와있다면,
						ToClient_CallHandlerMaid( "_warehouseMaid" )
					else							-- 거래소 메이드가 나와있다면, 거래소 메이드 들여보내고 창고 메이드 소환
						for mIndex = 0, getTotalMaidList() - 1 do
							local maidInfoWrapper = getMaidDataByIndex( mIndex )
							if myAffiliatedTownRegionKey == maidInfoWrapper:getRegionKey() then
								if ( maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse()) and 0 == maidInfoWrapper:getCoolTime() then
									ToClient_SummonMaid( maidInfoWrapper:getInstallationNo(), 1 )
									ToClient_CallHandlerMaid("_marketMaidLogOut")
									ToClient_CallHandlerMaid( "_warehouseMaid" )
									dontGoMaid = mIndex
									MaidList_Close()
									maidType = 1
									break
								end
							end
						end
					end
					MaidList_Close()
				else
					for mIndex = 0, getTotalMaidList() - 1 do
						local maidInfoWrapper = getMaidDataByIndex( mIndex )
						if myAffiliatedTownRegionKey == maidInfoWrapper:getRegionKey() then
							if ( maidInfoWrapper:isAbleInWarehouse() or maidInfoWrapper:isAbleOutWarehouse()) and 0 == maidInfoWrapper:getCoolTime() then
								ToClient_SummonMaid( maidInfoWrapper:getInstallationNo(), 1 )
								ToClient_CallHandlerMaid( "_warehouseMaid" )
								dontGoMaid = mIndex
								MaidList_Close()
								maidType = 1
								break
							end
						end
					end
				end
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_ALERT") ) -- "대기 상태에서만 호출할 수 있습니다." )
			end
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
			SetUIMode(Defines.UIMode.eUIMode_Default)
		end
	end
end

function FGlobal_MaidIcon_SetPos()
	if isFlushedUI() or getSelfPlayer():get():getLevel() < 7 then
		return
	end
	
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	if nil == regionInfo then
		return
	end
	
	local warehouseInMaid = checkMaid_WarehouseIn( true )
	local warehouseOutMaid = checkMaid_WarehouseOut( true )
	local marketMaid = checkMaid_SubmitMarket( true )
	
	if 0 < getTotalMaidList() then		-- 등록된 메이드짱이 하나라도 있다면,
		Panel_Icon_Maid:SetShow( true )
		
		MaidControl.buttonMaid:EraseAllEffect()
		if warehouseInMaid or warehouseOutMaid or marketMaid then
			MaidControl.buttonMaid:AddEffect("fUI_Maid_01A", false, -1, -0.5)
		else
			MaidControl.buttonMaid:AddEffect("fUI_Maid_02A", false, -1, -0.5)
		end

		local posX, posY
		if Panel_Window_PetIcon:GetShow() then
			posX = Panel_Window_PetIcon:GetPosX() + Panel_Window_PetIcon:GetSizeX() - 3
			posY = Panel_Window_PetIcon:GetPosY()
		else
			if 0 < FGlobal_HouseIconCount() and Panel_MyHouseNavi:GetShow() then
				posX = Panel_MyHouseNavi:GetPosX() + 60 * FGlobal_HouseIconCount() - 3
				posY = Panel_MyHouseNavi:GetPosY()
			elseif 0 < FGlobal_ServantIconCount() and Panel_Window_Servant:GetShow() then
				posX = Panel_Window_Servant:GetPosX() + 60 * FGlobal_ServantIconCount() - 3
				posY = Panel_Window_Servant:GetPosY()
			else
				posX = 0
				posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 15
			end
		end
		Panel_Icon_Maid:SetPosX( posX )
		Panel_Icon_Maid:SetPosY( posY )
		MaidList_SetScroll()
		
		if Panel_Window_MaidList:GetShow() then
			maidList.startIndex = 0
			MaidList_Set( maidList.startIndex )
			maidList.scroll:SetControlPos( 0 )
		end
	else
		Panel_Icon_Maid:SetShow( false )
	end
end
Panel_MyHouseNavi_Update( true )

function MaidFunc_ShowTooltip( isShow )
	if nil == isShow then
		TooltipSimple_Hide()
		return
	end

	local name = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_NAME") -- "페어리 집사 고용"
	local desc = ""
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	if nil == regionInfo then
		return
	end
	
	local warehouseInMaid = checkMaid_WarehouseIn( true )
	local warehouseOutMaid = checkMaid_WarehouseOut( true )
	local marketMaid = checkMaid_SubmitMarket( true )
	
	if warehouseInMaid or warehouseOutMaid then
		desc = "<" .. PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_WAREHOUSE") .. ">"
	end

	if marketMaid then
		if "" == desc then
			desc = "<" .. PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_MARKET") .. ">"
		else
			desc = desc .. ", <" .. PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_MARKET") .. ">"
		end
	end
	
	local maidCount = getTotalMaidList()
	local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()					-- 내가 있는 곳의 소속 마을
	
	local cooltimeText = ""
	local maidAffiliatedTownName = ""
	local areaName = {}
	local sameAreaCoolTime = {}
	local oneMinute = 60000
	local mIndex = 0
	local usableMaidCount = 0
	for index = 0, maidCount - 1 do
		local maidInfoWrapper = getMaidDataByIndex( index )
		areaName[index] = getRegionInfoWrapper( maidInfoWrapper:getRegionKey() ):getAreaName()
		
		local sameAreaNameCheck = false
		if 0 < index then
			for ii = 0, index - 1 do
				if areaName[index] == areaName[ii] then
					sameAreaNameCheck = true
				end
			end
		end

		if "" == maidAffiliatedTownName then
			maidAffiliatedTownName = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_1") .. " " .. areaName[index]
		elseif false == sameAreaNameCheck then
			maidAffiliatedTownName = maidAffiliatedTownName .. " / " .. areaName[index]
		end
		
	end
	
	if "" == desc then
		desc = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_2", "maidCount", maidCount ) -- "현 지역에서는 페어리 집사를 호출할 수 없습니다.\n- 고용중인 페어리 집사 : " .. maidCount .. "명"
	else
		desc = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_3", "desc", desc, "maidCount", maidCount ) -- "현 지역에서 " .. desc .. " 기능을 이용할 수 있습니다.\n- 고용중인 페어리 집사 : " .. maidCount .. "명"
	end
	
	if "" ~= maidAffiliatedTownName then
		desc = desc .. "\n" .. maidAffiliatedTownName
	end
	
	if ( not warehouseInMaid and not warehouseOutMaid ) and "" ~= cooltimeText then
		desc = desc .. "\n" .. cooltimeText
	end
	
	local hotkeyDesc = PAGetString(Defines.StringSheet_GAME, "LUA_MAIDLIST_TOOLTIP_DESC_4") -- "- 좌클릭 : 페어리 집사 목록 열기"
	desc = desc .. "\n".. hotkeyDesc
	
	TooltipSimple_Show( MaidControl.buttonMaid, name, desc )
end

function LogInMaidShow()
	if 6 < getSelfPlayer():get():getLevel() then
		if 0 < getTotalMaidList() then
			-- if ToClient_CheckExistSummonMaid() then				-- 이미 나와있는 메이드가 있으면 모조리 닫아준다! reloadui 시 발생
				ToClient_CallHandlerMaid("_StrAllmaidLogOut")
			-- end
			local randomMaidIndex = math.random( getTotalMaidList() ) - 1
			local maidInfoWrapper = getMaidDataByIndex( randomMaidIndex )
			if nil ~= maidInfoWrapper then
				local installationNo = maidInfoWrapper:getInstallationNo()
				local aiVariable = 2												-- 2 : 로그인 시 2번

				ToClient_SummonMaid( installationNo, aiVariable )				-- 액션 해라~
			end
		end
	end
end
LogInMaidShow()

UI.addRunPostRestorFunction( FGlobal_MaidIcon_SetPos )
Panel_Window_MaidList:RegisterUpdateFunc("MaidCoolTime_Update")
registerEvent("selfPlayer_regionChanged", "FGlobal_MaidIcon_SetPos")		-- 지역이 바뀔 때
registerEvent("FromClient_RefreshMaidList", "FGlobal_MaidIcon_SetPos")		-- 메이드 개수가 변경될 때
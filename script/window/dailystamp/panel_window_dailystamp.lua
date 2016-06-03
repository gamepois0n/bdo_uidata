Panel_Window_DailyStamp:SetShow( false, false )
Panel_Window_DailyStamp:ActiveMouseEventEffect(true)
Panel_Window_DailyStamp:setGlassBackground(true)

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color		= Defines.Color
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE

Panel_Window_DailyStamp:RegisterShowEventFunc( true,	'DailyStampShowAni()' )
Panel_Window_DailyStamp:RegisterShowEventFunc( false,	'DailyStampHideAni()' )

function DailyStampShowAni()
end
function DailyStampHideAni()
end

local rewardSlot_Config =
{	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon			= true,
	createBorder		= true,
	createCount			= true,
	createClassEquipBG	= true,
	createCash			= true
}

local dailyStampTitle			= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_Title" )
local dailySlotBg				= UI.getChildControl( Panel_Window_DailyStamp, "Static_DailySlotBg" )
local dailySlotMark				= UI.getChildControl( Panel_Window_DailyStamp, "Static_DailySlotMark" )
local dailyStamp				= UI.getChildControl( Panel_Window_DailyStamp, "Static_Stamp" )
local textDay					= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_DayCount" )
local selectedDay				= UI.getChildControl( Panel_Window_DailyStamp, "Static_SelectedDay" )

local periodText				= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_EventPeriodValue" )
local rewardAcceptPeriodValue	= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_RewardAcceptPeriodValue" )

local rewardAreaBg				= UI.getChildControl( Panel_Window_DailyStamp, "Static_RewardAreaBg" )
	  rewardAreaBg				: addInputEvent		( "Mouse_DownScroll",	   "DailyStamp_Reward_ScrollEvent( true )")
	  rewardAreaBg				: addInputEvent		( "Mouse_UpScroll",		   "DailyStamp_Reward_ScrollEvent( false )")
local rewardConditionComplete	= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_RewardComplete" )
local eventConditionText		= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_EventDay_Alert" )
local acceptCheckIcon			= UI.getChildControl( Panel_Window_DailyStamp, "Static_AccecptedIcon" )
local rewardScroll				= UI.getChildControl( Panel_Window_DailyStamp, "Scroll_Reward" )
local scrollCtrlBtn				= UI.getChildControl( rewardScroll,			   "Scroll_CtrlButton" )
	  scrollCtrlBtn				: addInputEvent		( "Mouse_LPress",		   "HandleClicked_Reward_ScrollBtn()" )

local rewardSlotBg				= UI.getChildControl( Panel_Window_DailyStamp, "Static_RewardSlotBg" )
local btnRewardAccept			= UI.getChildControl( Panel_Window_DailyStamp, "Button_RewardAccept" )

local rewardContent				= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_RewardAcceptContent" )

local btnClose					= UI.getChildControl( Panel_Window_DailyStamp, "Button_Win_Close" )
	  btnClose					: addInputEvent		( "Mouse_LUp",			   "DailyStamp_ShowToggle()" )

local mainBg					= UI.getChildControl( Panel_Window_DailyStamp, "Static_Bg" )
local partLineX					= UI.getChildControl( Panel_Window_DailyStamp, "Static_PartLineX" )
local partLineY1				= UI.getChildControl( Panel_Window_DailyStamp, "Static_PartLineY_1" )
local partLineY2				= UI.getChildControl( Panel_Window_DailyStamp, "Static_PartLineY_2" )
local evnetPeriodBg				= UI.getChildControl( Panel_Window_DailyStamp, "Static_EventPeriodBg" )
local evnetPeriodTitle			= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_EventPeriodTitle" )
local rewardAcceptPeriodTitle	= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_RewardAcceptPeriodTitle" )
local rewardAcceptTitle			= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_RewardAcceptTitle" )
local dailyStamp_AlertText		= UI.getChildControl( Panel_Window_DailyStamp, "StaticText_EventPeriodAlert" )
local rewardSlotBg				= UI.getChildControl( Panel_Window_DailyStamp, "Static_RewardSlotBg" )
local eventBanner				= UI.getChildControl( Panel_Window_DailyStamp, "Static_DailyStamp_Event" )

local maxDayCount			= 30
local maxRewardSlotCount	= 4
local rewardItemKey_1		= 7				-- 펄 마일리지 아이템키
local rewardItemKey_2		= 15912			-- PC방 주말 대박 상자 아이템키
local dailySlot				= {}
local dayCount				= {}
local _rewardSlot			= {}
local _rewardSlotBg			= {}
local rewardCondition		= {}
local checkIcon				= {}
local slotPosX				= dailySlotBg:GetPosX()
local slotPosY				= dailySlotBg:GetPosY()
local scrollInterval		= 0
local viewableRewardCount	= 6
local startIndex			= 0
function DailyStamp_Init()
	-- 데이 카운트 슬롯 생성
	for index = 0, maxDayCount -1 do
		local slotBg = UI.createControl(  UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_DailyStamp, "Static_DailySlotBg_" .. index )
		CopyBaseProperty( dailySlotBg, slotBg )
		dailySlot[index] = slotBg
		dailySlot[index]:SetPosX( slotPosX + dailySlotBg:GetSizeX() * (index%6) )
		dailySlot[index]:SetPosY( slotPosY + dailySlotBg:GetSizeY() * (index/6 - (index/6)%1) )
		dailySlot[index]:SetShow( true )
		dailySlot[index]:SetIgnore( true )
		
		local day =  UI.createControl(  UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Window_DailyStamp, "Static_DayCount_" .. index )
		CopyBaseProperty( textDay, day )
		dayCount[index] = day
		dayCount[index]:SetText( index + 1 )
		dayCount[index]:SetPosX( textDay:GetPosX() + dailySlotBg:GetSizeX() * (index%6) )
		dayCount[index]:SetPosY( textDay:GetPosY() + dailySlotBg:GetSizeY() * (index/6 - (index/6)%1) )
		dayCount[index]:SetShow( true )
	end
	
	for rewardIndex = 0, viewableRewardCount - 1 do
		local _rewardCondition = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Window_DailyStamp, "Static_RewardCondition_" .. rewardIndex )
		CopyBaseProperty( rewardConditionComplete, _rewardCondition )
		rewardCondition[rewardIndex] = _rewardCondition
		rewardCondition[rewardIndex]:SetPosY( rewardConditionComplete:GetPosY() + (rewardConditionComplete:GetSizeY()) * rewardIndex )
		rewardCondition[rewardIndex]:SetShow( false )
		rewardCondition[rewardIndex]:addInputEvent( "Mouse_LUp", "rewardSet(" .. rewardIndex .. ")" )
		rewardCondition[rewardIndex]:ActiveMouseEventEffect( true )
		
		local chkIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, rewardCondition[rewardIndex], "Static_CheckIcon_" .. rewardIndex )
		CopyBaseProperty( acceptCheckIcon, chkIcon )
		checkIcon[rewardIndex] = chkIcon
		checkIcon[rewardIndex]:SetShow( false )
	end

	for idx = 0, maxRewardSlotCount -1 do
		local slotBg = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_DailyStamp, "Static_RewardSlotBg_" .. idx )
		CopyBaseProperty( rewardSlotBg, slotBg )
		_rewardSlotBg[idx] = slotBg
		_rewardSlotBg[idx]:SetPosX( rewardSlotBg:GetPosX() + idx * 55 )
		_rewardSlotBg[idx]:SetShow( true )
		
		local slot = {}
		SlotItem.new( slot, idx, idx, _rewardSlotBg[idx], rewardSlot_Config )
		slot:createChild()
		slot.icon:SetPosX(1)
		slot.icon:SetPosY(1)
		_rewardSlot[idx] = slot
	end
	
	eventBanner:ActiveMouseEventEffect( true )
	
end

DailyStamp_Init()

function DailyStamp_SetSeal( count )
	local stampIcon = {}
	
	if maxDayCount < count then		-- 이런 일이 발생하면 안되지만, 넘어갈 시 에러가 발생하므로 조치해둔다!
		count = maxDayCount
	end
	
	for stampIndex = 0, count -1 do
		dailySlot[stampIndex]:DestroyAllChild()
		local stamp = UI.createControl(  UI_PUCT.PA_UI_CONTROL_STATIC, dailySlot[stampIndex], "Static_Stamp_" .. stampIndex )
		CopyBaseProperty( dailyStamp, stamp )
		stampIcon[stampIndex] = stamp
		stampIcon[stampIndex]:SetPosX( 9 )
		stampIcon[stampIndex]:SetPosY( 13 )
		stampIcon[stampIndex]:SetShow( true )
		stampIcon[stampIndex]:SetIgnore( true )
	end
end

local acceptableCount = 0
local tooltipSetCheck = false
function DailyStamp_SetData( _startIndex )
	if nil == _startIndex then
		startIndex = 0
	else
		startIndex = _startIndex
	end
	
	if ToClient_isAttendanceEvent() then									-- 이벤트가 진행중이면,
		local title = ToClient_AttendanceTitle()							-- 제목
		local period = ToClient_AttendancePeriod()							-- 기간
		local attendanceCount = ToClient_getAttendanceCount()				-- 내 출석일 수 
		local recieveRewardCount = ToClient_getReceivedRewardCount()		-- 받아간 보상 숫자
		dailyStampTitle:SetText( tostring(title) )							-- 이벤트 제목 세팅
		periodText:SetText( period )
		rewardAcceptPeriodValue:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REWARD1") )
		DailyStamp_SetSeal( attendanceCount )								-- 도장 세팅
		
		local rewardCount = ToClient_getRewardItemCount()					-- 총 보상 개수
		if viewableRewardCount < rewardCount then							-- 일단 보상 표시는 6개로 제한
			rewardScroll:SetShow( true )
			-- DailyStamp_SetScroll()
		else
			rewardScroll:SetShow( false )
		end
		local acceptableRewardCount = rewardCount - startIndex				-- 받을 수 있는 보상 수
		local rewardCountIndex = startIndex
		local index = 0
		acceptableCount = 0
		for rewardIndex = 0, rewardCount - 1 do
			local rewardDay = ToClient_getRewardDay( rewardIndex ) - 1		-- 보상을 받을 수 있는 출석일
			dailySlot[rewardDay]:ChangeTextureInfoName("New_UI_Common_forLua/Default/Dailystamp_00.dds")		-- 보상이 있는 출석일은 텍스처 변경
			local x1, y1, x2, y2 = setTextureUV_Func( dailySlot[rewardDay], 272, 52, 326, 106 )
			dailySlot[rewardDay]:getBaseTexture():setUV( x1, y1, x2, y2 )
			dailySlot[rewardDay]:setRenderTexture(dailySlot[rewardDay]:getBaseTexture())
			dailySlot[rewardDay]:SetIgnore( false )
			dailySlot[rewardDay]:addInputEvent("Mouse_LUp", "HandleClicked_AttendenceDay(" .. rewardDay .. ")" )
			dailySlot[rewardDay]:ActiveMouseEventEffect( true )
			
			if rewardIndex == rewardCountIndex and viewableRewardCount + startIndex > rewardCountIndex then
				rewardCondition[index]:SetShow( true )
				rewardCondition[index]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REWARDCONDITION", "rewardDay", tostring(rewardDay+ 1) ) ) -- 출석 도장 " .. tostring(rewardDay+ 1) .. "개 보상
				rewardCondition[index]:addInputEvent("Mouse_DownScroll",	"DailyStamp_Reward_ScrollEvent( true )")
				rewardCondition[index]:addInputEvent("Mouse_UpScroll",		"DailyStamp_Reward_ScrollEvent( false )")
			
				if attendanceCount <= rewardDay then
					rewardCondition[index]:ChangeTextureInfoName("New_UI_Common_forLua/Default/Dailystamp_00.dds")
					local x1, y1, x2, y2 = setTextureUV_Func( rewardCondition[index], 66, 56, 268, 104 )
					rewardCondition[index]:getBaseTexture():setUV( x1, y1, x2, y2 )
					rewardCondition[index]:setRenderTexture(rewardCondition[index]:getBaseTexture())
					acceptableRewardCount = acceptableRewardCount - 1
					checkIcon[index]:SetShow( false )
				elseif index + startIndex < recieveRewardCount then
					rewardCondition[index]:ChangeTextureInfoName("New_UI_Common_forLua/Default/Dailystamp_00.dds")
					local x1, y1, x2, y2 = setTextureUV_Func( rewardCondition[index], 66, 5, 268, 53 )
					rewardCondition[index]:getBaseTexture():setUV( x1, y1, x2, y2 )
					rewardCondition[index]:setRenderTexture(rewardCondition[index]:getBaseTexture())
					checkIcon[index]:SetShow( true )
					acceptableCount = acceptableCount + 1
				else
					rewardCondition[index]:ChangeTextureInfoName("New_UI_Common_forLua/Default/Dailystamp_00.dds")
					local x1, y1, x2, y2 = setTextureUV_Func( rewardCondition[index], 66, 5, 268, 53 )
					rewardCondition[index]:getBaseTexture():setUV( x1, y1, x2, y2 )
					rewardCondition[index]:setRenderTexture(rewardCondition[index]:getBaseTexture())
					checkIcon[index]:SetShow( false )
					acceptableCount = acceptableCount + 1
				end
				rewardCountIndex = rewardCountIndex + 1
				index = index + 1
			end
			
		end
		
		acceptableCount = acceptableCount + startIndex
		
		-- acceptableRewardCount = acceptableRewardCount + startIndex - 1
		if recieveRewardCount == ToClient_getRewardItemCount() then		-- 모든 보상을 다 받았나?
			recieveRewardCount = recieveRewardCount - 1
		end
		if nil ~= ToClient_getRewardItem(recieveRewardCount) and false == tooltipSetCheck then
			local index = 0
			_rewardSlot[index]:clearItem()
			_rewardSlot[index]:setItem( ToClient_getRewardItem(recieveRewardCount) )
			_rewardSlot[index].icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. recieveRewardCount .. ", \"DailyStamp\",true)" )
			_rewardSlot[index].icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. recieveRewardCount .. ", \"DailyStamp\",false)" )
			Panel_Tooltip_Item_SetPosition( recieveRewardCount, _rewardSlot[index], "DailyStamp" )
			tooltipSetCheck = true
			
			rewardSet( recieveRewardCount )
			-- local content = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_DAILYSTAMP_RECIEVEREWARDCOUNT", "recieveRewardCount", ToClient_getRewardDay(recieveRewardCount) ) -- "(접속 " .. ToClient_getRewardDay(recieveRewardCount) .. "일 보상)"
			-- if recieveRewardCount < acceptableCount then				-- 받을 수 있는 보상이 받은 보상보다 크다면,
				-- btnRewardAccept:SetIgnore( false )
				-- btnRewardAccept:SetMonoTone( false )
				-- _rewardSlot[index].icon:SetMonoTone( false )
			-- elseif recieveRewardCount > acceptableCount then
				-- btnRewardAccept:SetIgnore( true )
				-- btnRewardAccept:SetMonoTone( true )
				-- content = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REWARD2")
			-- else
				-- btnRewardAccept:SetIgnore( true )
				-- btnRewardAccept:SetMonoTone( true )
				-- _rewardSlot[index].icon:SetMonoTone( false )
			-- end
			-- rewardContent:SetText( content )
			-- rewardContent:SetShow( true )
		end
		
		btnRewardAccept:addInputEvent( "Mouse_LUp", "HandleClicked_RewardAccept()" )	-- 보상 받기 이벤트 추가
		
		eventConditionText:SetShow( false )

		-- 마지막 보상까지만 스탬프를 찍을 수 있는 것처럼 보이게 한다!
		local lastRewardDay = ToClient_getRewardDay( rewardCount - 1 ) - 1
		for ii = lastRewardDay + 1, maxDayCount - 1 do
			dailySlot[ii]:SetShow( false )
			dayCount[ii]:SetShow( false )
		end
		DailyStamp_Resize( lastRewardDay )
		
	else
		eventConditionText:SetShow( true )
		rewardScroll:SetShow( false )
		dailyStampTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_NOTEVENTPERIOD"))
		periodText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_NOTEVENTPERIOD"))
		rewardContent:SetShow( false )
		btnRewardAccept:SetIgnore( true )
		btnRewardAccept:SetMonoTone( true )
		
	end
end

function HandleClicked_AttendenceDay( rewardDay )
	for index = 0, ToClient_getRewardItemCount() - 1 do
		if (rewardDay+1) == ToClient_getRewardDay(index) then
			rewardSet( index - startIndex )
			return
		end
	end
end

function rewardSet( index )
	local tooltipIndex = index + startIndex
	if ToClient_getReceivedRewardCount() < acceptableCount and ToClient_getReceivedRewardCount() == tooltipIndex then
		btnRewardAccept:SetIgnore( false )
		btnRewardAccept:SetMonoTone( false )
	else
		btnRewardAccept:SetIgnore( true )
		btnRewardAccept:SetMonoTone( true )
	end
	
	if nil ~= ToClient_getRewardItem(tooltipIndex) then
		local idx = 0
		_rewardSlot[idx]:clearItem()
		_rewardSlot[idx]:setItem( ToClient_getRewardItem(tooltipIndex) )
		_rewardSlot[idx].icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. tooltipIndex .. ", \"DailyStamp\",true)" )
		_rewardSlot[idx].icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. tooltipIndex .. ", \"DailyStamp\",false)" )
		Panel_Tooltip_Item_SetPosition( tooltipIndex, _rewardSlot[idx], "DailyStamp" )
	end

	local content
	_rewardSlot[0].icon:SetMonoTone( false )
	if ToClient_getReceivedRewardCount() ~= ToClient_getRewardItemCount() then
		if ToClient_getReceivedRewardCount() > tooltipIndex then
			content = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REWARD2")
			_rewardSlot[0].icon:SetMonoTone( true )
		else
			content = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_DAILYSTAMP_RECIEVEREWARDCOUNT", "recieveRewardCount", ToClient_getRewardDay(tooltipIndex)) -- "(접속 " .. ToClient_getRewardDay(recieveRewardCount) .. "일 보상)"
		end
	else
		content = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_REWARD3")
		_rewardSlot[0].icon:SetMonoTone( true )
	end
	rewardContent:SetText( content )
	
	selectedDay:SetShow( true )
	
	selectedDay:SetPosX( dailySlot[ToClient_getRewardDay(tooltipIndex)-1]:GetPosX() )
	selectedDay:SetPosY( dailySlot[ToClient_getRewardDay(tooltipIndex)-1]:GetPosY() )
end

function HandleClicked_EventBanner( bannerType )
	FGlobal_EventNotifyContent_Open( bannerType )
end

-- 이벤트 일수에 따라 패널 사이즈 조정
local sizeX = Panel_Window_DailyStamp:GetSizeX()
local sizeY = Panel_Window_DailyStamp:GetSizeY()
local bgSizeY = mainBg:GetSizeY()
local partLineY1_SizeY = partLineY1:GetSizeY()
local sizeGap = 30
function DailyStamp_Resize( eventDay )
	if 24 < eventDay then
		Panel_Window_DailyStamp:SetSize( sizeX, sizeY )
		mainBg:SetSize( mainBg:GetSizeX(), bgSizeY )
		partLineY1:SetSize( partLineY1:GetSizeX(), partLineY1_SizeY )
	else
		Panel_Window_DailyStamp:SetSize( sizeX, sizeY - sizeGap )
		mainBg:SetSize( mainBg:GetSizeX(), bgSizeY - sizeGap )
		partLineY1:SetSize( partLineY1:GetSizeX(), partLineY1_SizeY - sizeGap )
	end
	rewardAcceptPeriodValue	:ComputePos()
	partLineX				:ComputePos()
	partLineY1				:ComputePos()
	partLineY2				:ComputePos()
	evnetPeriodBg			:ComputePos()
	evnetPeriodTitle		:ComputePos()
	rewardAcceptPeriodTitle	:ComputePos()
	rewardAcceptTitle		:ComputePos()
	rewardSlotBg			:ComputePos()
	btnRewardAccept			:ComputePos()
	periodText				:ComputePos()
	dailyStamp_AlertText	:ComputePos()
	rewardContent			:ComputePos()
	eventBanner				:ComputePos()
	for i = 0, 3 do
		_rewardSlotBg[i]	:ComputePos()
	end
end

function DailyStamp_SetScroll()
	local rewardCount		= ToClient_getRewardItemCount()
	local pagePercent		= ( viewableRewardCount / rewardCount ) * 100
	local scroll_Interval	= rewardCount - viewableRewardCount
	local scrollSizeY		= rewardScroll:GetSizeY()
	local btn_scrollSizeY	= ( scrollSizeY / 100 ) * pagePercent

	if btn_scrollSizeY < 10 then
		btn_scrollSizeY = 10
	end
	if scrollSizeY <= btn_scrollSizeY then
		btn_scrollSizeY = scrollSizeY * 0.99
	end

	scrollCtrlBtn	:SetSize( scrollCtrlBtn:GetSizeX(), btn_scrollSizeY )
	scrollInterval	= scroll_Interval
	rewardScroll	:SetInterval( scrollInterval )
end

function HandleClicked_Reward_ScrollBtn()
	local rewardCount	= ToClient_getRewardItemCount()
	local posByIndex	= 1 / ( rewardCount - viewableRewardCount )
	local currentIndex	= math.floor( rewardScroll:GetControlPos() / posByIndex )
	startIndex	= currentIndex
	DailyStamp_SetData( startIndex )
end

function DailyStamp_Reward_ScrollEvent( isDown )
	local rewardCount = ToClient_getRewardItemCount()
	if viewableRewardCount >= rewardCount then
		return
	end
	
	local index		= startIndex
	if true == isDown then
		if ( rewardCount - viewableRewardCount + 1 ) < index then
			return
		end

		if index < scrollInterval then
			rewardScroll:ControlButtonDown()
			index = index + 1
		else
			return
		end
	else
		if 0 < index then
			rewardScroll:ControlButtonUp()
			index = index - 1
		else
			return
		end
	end	
	
	startIndex = index
	DailyStamp_SetData( startIndex )
end


function HandleClicked_RewardAccept()
	ToClient_takeRewardItem()
	startIndex = 0
	rewardScroll:SetControlPos(startIndex)
	tooltipSetCheck = false
end

function eventBanner_Set()
	local bannerType = math.random(4)
	eventBanner:ChangeTextureInfoName ( "new_ui_common_forlua/window/eventnotify/event_s0" .. bannerType .. ".dds" )
	eventBanner:addInputEvent( "Mouse_LUp",	"HandleClicked_EventBanner(" .. bannerType .. ")" )
end

function DailyStamp_ShowToggle()
	if not ToClient_isAttendanceEvent() then
		return
	end
	
	if Panel_Window_DailyStamp:GetShow() then
		Panel_Window_DailyStamp:SetShow( false, false )
		return
	end
	
	startIndex = 0
	tooltipSetCheck = false
	Panel_Window_DailyStamp:SetShow( true, true )
	DailyStamp_SetData()
	rewardScroll:SetControlPos(startIndex)
	DailyStamp_SetScroll()
	eventBanner_Set()
end

function Panel_Window_DailyStamp_RePos()
	Panel_Window_DailyStamp:SetPosX( getScreenSizeX()/2 - Panel_Window_DailyStamp:GetSizeX()/2)
	Panel_Window_DailyStamp:SetPosY( getScreenSizeY()/2 - Panel_Window_DailyStamp:GetSizeY()/2 - 100 )
end

registerEvent("FromClient_receiveAttendanceReward", "DailyStamp_SetData" )
registerEvent("onScreenResize", "Panel_Window_DailyStamp_RePos" )
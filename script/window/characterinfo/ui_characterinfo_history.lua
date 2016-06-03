local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode
local UI_color 		= Defines.Color
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM			= CppEnums.TextMode

Panel_Window_CharInfo_HistoryInfo:SetShow( false )

-- 월별 일 세팅 ( 윤년 체크는?? )
local	pastMonth_DayCount =
{
	[1] = 31,	[2] = 29,	[3] = 31,	[4]  = 30,	[5]  = 31, [6]  = 30,
	[7] = 31,	[8] = 31,	[9] = 30,	[10] = 31,	[11] = 30, [12]	= 31
}

-- 날짜 데이터 세팅
local	currentValue	=
{
	_year			=	ToClient_GetThisYear(),			-- 올해
	_month			=	ToClient_GetThisMonth(),		-- 이달
	_day			=	ToClient_GetToday(),			-- 오늘
	_myHistory		=	0,
	_guildHistory	=	1
}

local	monthValue				=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "StaticText_MainMonth" )
local	monthLine				=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "Static_HorizontalCenter" )
local	verticalLine			=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "Static_VerticalLine" )

local	dayLeftValue			=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "StaticText_DayLeft_Value" )
local	dayLeftLine				=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "Static_HorizontalLeft" )
local	dayHistoryLeftValue		=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "StaticText_HistoryLeftList" )
local	dayRightValue			=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "StaticText_DayRight_Value" )
local	dayRightLine			=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "Static_HorizontalRight" )
local	dayHistoryRightValue	=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "StaticText_HistoryRightList" )

local	_frameHistoryList		=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "Frame_HistoryList" )
local	_contentHistoryList		=	UI.getChildControl( _frameHistoryList, "Frame_1_Content" )
local	_scroll					=	UI.getChildControl( _frameHistoryList, "Frame_1_VerticalScroll" )

local	noScroll_FrameSize		=	_frameHistoryList:GetSizeY()
_frameHistoryList:SetIgnore( false )

-- 임시로 2014년 세팅
local	firstLogYearValue		=	2014						-- 처음 로그가 기록된 해(임시)
local	thisYearValue			=	currentValue._year			-- 올해
local	radioBtn_Year			=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "RadioButton_YearStic" )
local	radioBtn_YearValue		=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "StaticText_YearSticText" )
local	selectedYear			=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "StaticText_SelectYearValue" )
local	yearLeftButton			=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "Button_Year_Left" )
local	yearRightButton			=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "Button_Year_Right" )
local	yearIndex				=	{}
local	radioBtn_YearPosX		=	radioBtn_Year:GetPosX()
local	radioBtn_YearGap		=	15

-- 월 세팅
local	topMonth				=	UI.getChildControl( Panel_Window_CharInfo_HistoryInfo, "RadioButton_Month" )
local	monthIndex				=	{}
local	haveInfoMonth			=	nil

local	_monthCount = 11
for	index = 0, 11 do
	monthIndex[index]			= 	nil
	monthIndex[index]			= 	{}
	monthIndex[index]			=	UI.createControl( UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, Panel_Window_CharInfo_HistoryInfo, "RadioButton_Month_" .. index +1 )
	CopyBaseProperty( topMonth, monthIndex[index] )
	monthIndex[index]			:	SetText(PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_MONTH", "month", ( index+1 ) ) )
	monthIndex[index]			:	SetSpanSize(( monthIndex[index]:GetSizeX() + 10 ) * _monthCount + 20 )
	monthIndex[index]			:	addInputEvent( "Mouse_LUp", "HandleClicked_MyHistory_MonthCheck(" .. index .. ")" )
	monthIndex[index]			:	SetShow( true )
	_monthCount = _monthCount - 1
end

-- 툴팁용 컨트롤 생성
local helpWidget	=	nil
function helpWidget_Create()
	local tooltipBase 	=	UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_1")
	helpWidget			=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, _contentHistoryList, "HelpWindow_For_CharHistory" )
	CopyBaseProperty( tooltipBase, helpWidget )
	helpWidget	:SetColor( ffffffff )
	helpWidget	:SetAlpha( 1.0 )
	helpWidget	:SetFontColor( UI_color.C_FFC4BEBE )
	helpWidget	:SetAutoResize( true )
	helpWidget	:SetShow( false )
	_contentHistoryList:SetChildIndex( helpWidget, 9999 )
end

-- 년 월 세팅
local _firstOpenCheck = true
function	MyHistory_DataUpdate()
	-- 오늘자 세팅
	if ( _firstOpenCheck ) then
		_firstOpenCheck = false
		HandleClicked_MyHistory_YearCheck( ToClient_GetThisYear() - firstLogYearValue )
		HandleClicked_MyHistory_MonthCheck( ToClient_GetThisMonth() - 1 )
		haveInfoMonth = ToClient_GetThisMonth()
		return
	end
	ToClient_RequestJournalList( currentValue._year, currentValue._month, currentValue._myHistory )							-- 일지 리스트 로드
end

local	_dayHistoryValue	=	{}
function	FromClient_MyHistoryInfo_Update()
	_listCount	=	ToClient_GetJournalListCount( currentValue._year, currentValue._month, currentValue._myHistory )		-- 해당 일지 수

	-- 로그가 없는 월!
	if ( 0 == _listCount ) then
		if ( currentValue._year == ToClient_GetThisYear() ) and	( currentValue._month == ToClient_GetThisMonth() ) then
			-- 올해의 현재 월의 경우 로그가 없어도 뿌려준다!
		else
			for i = 0, 11 do
				if ( haveInfoMonth -1 == i ) then
					monthIndex[i]			:	SetFontColor( UI_color.C_FFFFFFFF )
				else
					monthIndex[i]			:	SetFontColor( UI_color.C_FF888888 )
				end
			end
			return
		end
	end
	_contentHistoryList		:	DestroyAllChild()		-- 생성하기 전에 기존 차일드를 파괴한다!!
	helpWidget_Create()

	-- 아직 오지 않은 월을 클릭한 경우 뿌려줄 게 없다!
	if ( 0 == currentValue._day ) then
		for i = 0, 11 do
			if ( haveInfoMonth -1 == i ) then
				monthIndex[i]			:	SetFontColor( UI_color.C_FFFFFFFF )
			else
				monthIndex[i]			:	SetFontColor( UI_color.C_FF888888 )
			end
		end
		return
	end
	_contentHistoryList:SetIgnore( true )
	
	local	frameContent	=	{
		_monthValue			=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	_contentHistoryList,	"StaticText_Month_Value" ),
		_monthLine			=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC,		_contentHistoryList,	"Static_MonthLine" ),
		_verticalLine		=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC,		_contentHistoryList,	"Static_VerticalLine" ),
	}

	CopyBaseProperty( monthValue,	frameContent._monthValue )
	CopyBaseProperty( monthLine,	frameContent._monthLine )
	CopyBaseProperty( verticalLine,	frameContent._verticalLine )
	
	frameContent._monthValue	:	SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHALLENGE_YEAR", "year", currentValue._year ) .. " " .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_MONTH", "month", currentValue._month ) )
	frameContent._monthValue	:	SetShow( true )
	frameContent._monthLine		:	SetShow( true )
	frameContent._verticalLine	:	SetShow( true )
	
	local	sizeY				=	10			-- 라인 스타트 포지션
	local	lineGap				=	30			-- 라인 간격
	local	textSizeY			=	20			-- 텍스트 간 간격
	local	_journalInfo		=	{}
	local	emptyDay			=	0
	local	_dayValue			=	{}
	local	_dayLine			=	{}
	local	dayLogCount			=	1
	local	firstDay = 0

	for dayIndex = currentValue._day, 1, -1 do
	
		_dayValue[dayIndex]		=	{}
		_dayLine[dayIndex]		=	{}
		
		-- 좌우 포지션을 따로 잡지 않기 위해 좌/우 컨트롤을 따로 만들어 하나의 컨트롤로 복사
		if ( 1 == dayLogCount % 2 ) then				-- 홀수일이면
			local	_dayLeftValue	=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	_contentHistoryList,	"StaticText_DayLeft_Value_" .. dayIndex )
			local	_dayLeftLine	=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC,		_contentHistoryList,	"Static_DayLeftLine_" .. dayIndex )
			
			CopyBaseProperty( dayLeftValue, _dayLeftValue )
			CopyBaseProperty( dayLeftLine, _dayLeftLine )
			_dayValue[dayIndex]		=	_dayLeftValue
			_dayLine[dayIndex]		=	_dayLeftLine
		else										-- 짝수일이면
			local	_dayRightValue	=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	_contentHistoryList,	"StaticText_DayRight_Value_" .. dayIndex )
			local	_dayRightLine	=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC,		_contentHistoryList,	"Static_DayRightLine" .. dayIndex )
			
			CopyBaseProperty( dayRightValue, _dayRightValue )
			CopyBaseProperty( dayRightLine, _dayRightLine )
			_dayValue[dayIndex]		=	_dayRightValue
			_dayLine[dayIndex]		=	_dayRightLine
		end

		local checkLog = false
		
		for i = _listCount -1, 0, -1 do
			_journalInfo[i] 	=	{}
			_journalInfo[i] 	=	ToClient_GetJournal( currentValue._year, currentValue._month, currentValue._myHistory, i )
			
			if ( nil ~= _journalInfo[i] ) then
				if ( dayIndex == _journalInfo[i]:getJournalDay() ) then
					if false == checkLog then
						checkLog = true
					end
				
					sizeY	=	sizeY	+	textSizeY
					
					-- 텍스트도 좌/우 포지션 계산보단 따로 생성해주고 사용
					if ( 1 == dayLogCount % 2 ) then
						local	_dayHistoryLeftValue	=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	_contentHistoryList, "StaticText_MyHistory_" .. i )
						CopyBaseProperty( dayHistoryLeftValue, _dayHistoryLeftValue )
						_dayHistoryValue[i]				=	_dayHistoryLeftValue
						_dayHistoryValue[i]	:	addInputEvent( "Mouse_On", "MyHistory_HelpWidget_Show(true," .. i .. ", true)" )
						_dayHistoryValue[i]	:	addInputEvent( "Mouse_Out", "MyHistory_HelpWidget_Show(false)" )

						_dayHistoryValue[i]	:	setTooltipEventRegistFunc("MyHistory_HelpWidget_Show(true," .. i .. ", true)")
					else
						local	_dayHistoryRightValue	=	UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	_contentHistoryList, "StaticText_MyHistory_" .. i )
						CopyBaseProperty( dayHistoryRightValue, _dayHistoryRightValue )
						_dayHistoryValue[i]				=	_dayHistoryRightValue
						_dayHistoryValue[i]	:	addInputEvent( "Mouse_On", "MyHistory_HelpWidget_Show(true," .. i .. ", false)" )
						_dayHistoryValue[i]	:	addInputEvent( "Mouse_Out", "MyHistory_HelpWidget_Show(false)" )

						_dayHistoryValue[i]	:	setTooltipEventRegistFunc("MyHistory_HelpWidget_Show(true," .. i .. ", false)")
					end

					_dayHistoryValue[i]	:	SetAutoResize( true )
					_dayHistoryValue[i]	:	SetText( tostring(_journalInfo[i]:getName()) )
					_dayHistoryValue[i]	:	SetPosY( sizeY + 30 )
					_dayHistoryValue[i]	:	SetShow( true )
					_dayHistoryValue[i]	:	SetIgnore( false )
				end
			end
		end
		if ( true == checkLog ) then
			sizeY						=	sizeY + lineGap
			_dayValue[dayIndex]			:	SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_HISTORY_DAY", "day", dayIndex ) )
			_dayValue[dayIndex]			:	SetShow( true )
			_dayLine[dayIndex]			:	SetShow( true )
			_dayValue[dayIndex]			:	SetPosY( sizeY + 30 )
			_dayLine[dayIndex]			:	SetPosY( sizeY + 20 )
			dayLogCount = dayLogCount + 1
			firstDay = dayIndex
		end
	end

	if ( 0 < firstDay ) then
		_contentHistoryList:SetSize( _contentHistoryList:GetSizeX(), _dayLine[firstDay]:GetPosY() + 50 )
		frameContent._verticalLine:SetSize( frameContent._verticalLine:GetSizeX(), _dayLine[firstDay]:GetPosY() - 20 )
		frameContent._verticalLine:SetShow(true)
		if ( noScroll_FrameSize < _dayLine[firstDay]:GetPosY() + 50 ) then
			_scroll:SetShow( true )
		else
			_scroll:SetShow( false )
		end
	else
		frameContent._verticalLine:SetSize( frameContent._verticalLine:GetSizeX(), noScroll_FrameSize )
		frameContent._verticalLine:SetShow(false)
		_contentHistoryList:SetSize( _contentHistoryList:GetSizeX(), noScroll_FrameSize )
		_scroll:SetShow( false )
	end
	
	_frameHistoryList:UpdateContentScroll()
	_scroll:SetControlTop()
	_frameHistoryList:UpdateContentPos()
	haveInfoMonth = currentValue._month
end

function	MyHistory_HelpWidget_Show( isShow, index, isLeft )
	if ( nil ~= index ) then
		local	journalInfo	=	ToClient_GetJournal( currentValue._year, currentValue._month, currentValue._myHistory, index )
		if ( nil ~= journalInfo ) then
			local	helpDesc	= PAGetStringParam3(  Defines.StringSheet_GAME
													, "LUA_CHARACTERINFO_HISTORY_TIME"
													, "hour"
													, journalInfo:getJournalHour()
													, "minute"
													, journalInfo:getJournalMinute()
													, "second"
													, journalInfo:getJournalSecond() 
													)
			helpWidget:SetText( helpDesc )
			helpWidget:SetSize( helpWidget:GetTextSizeX()+15, 20 )
		else
			helpWidget:SetShow(false)
			return
		end
		
		if ( true == isLeft ) then
			helpWidget:SetPosX( _dayHistoryValue[index]:GetPosX() - _dayHistoryValue[index]:GetTextSizeX() + 100 )
		else
			helpWidget:SetPosX( _dayHistoryValue[index]:GetPosX() + _dayHistoryValue[index]:GetTextSizeX() + 5 )
		end
		helpWidget:SetPosY( _dayHistoryValue[index]:GetPosY() - 6 )
	end
	registTooltipControl(helpWidget, Panel_CheckedQuest)
	helpWidget:SetShow( isShow )
end

function	HandleClicked_MyHistory_MonthCheck( index )
	-- 클릭한 월을 하이라이트 시키고 나머지는 월은 원상태로 복구
	for i = 0, 11 do
		if ( index == i ) then
			monthIndex[i]			:	SetFontColor( UI_color.C_FFFFFFFF )
		else
			monthIndex[i]			:	SetFontColor( UI_color.C_FF888888 )
		end
	end
	monthIndex[index]:SetCheck( true )
	currentValue._month = index + 1
	
	-- 현재 월과 클릭한 월을 비교
	-- 작년은 미래의 월 클릭 체크를 하지 않아야함 이로인해 2015년으로 넘어가면서 버그 발생했음 이를 수정함(20150101 : crazy4idea)
	if( ToClient_GetThisYear() <= currentValue._year ) then				-- 올해일때만 의미가 있는 체크
		if ( ToClient_GetThisMonth() < currentValue._month ) then		-- 미래의 월을 클릭시(보여줄 데이터가 없음)
			currentValue._day = 0	
		end
	end
	
	if ( ToClient_GetThisMonth() == currentValue._month ) then		-- 현재 월을 클릭시(오늘 일자를 대입)
		currentValue._day = ToClient_GetToday()
	else
		currentValue._day = pastMonth_DayCount[index+1]				-- 현재 월 이외의 월을 클릭시(클릭한 월의 마지막 일자를 대입)
	end
	
	MyHistory_DataUpdate()											-- 일지 목록 갱신
end

function	HandleClicked_MyHistory_YearCheck( index )
	currentValue._year	=	firstLogYearValue + index
	radioBtn_YearValue	:	SetText( currentValue._year )
	selectedYear		:	SetText( currentValue._year )
	
	if ( firstLogYearValue < currentValue._year ) then
		yearLeftButton:SetShow( true )
	else
		yearLeftButton:SetShow( false )
	end
	if ( ToClient_GetThisYear() > currentValue._year ) then
		yearRightButton:SetShow( true )
	else
		yearRightButton:SetShow( false )
	end
	
	if ( currentValue._year == ToClient_GetThisYear() ) then
		HandleClicked_MyHistory_MonthCheck( ToClient_GetThisMonth() - 1 )			-- 현재 연도를 클릭하면 이번달 출력
	else
		HandleClicked_MyHistory_MonthCheck( 11 )									-- 지난 연도를 클릭하면 12월(마지막 달) 출력
	end
	
	yearLeftButton:addInputEvent( "Mouse_LUp", "HandleClicked_MyHistory_YearCheck(" .. currentValue._year - firstLogYearValue - 1 .. ")" )
	yearRightButton:addInputEvent( "Mouse_LUp", "HandleClicked_MyHistory_YearCheck(" .. currentValue._year - firstLogYearValue + 1 .. ")" )
end

registerEvent("FromClient_JournalInfo_UpdateText", "FromClient_MyHistoryInfo_Update")

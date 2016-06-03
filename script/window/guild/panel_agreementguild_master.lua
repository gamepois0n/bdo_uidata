local IM 			= CppEnums.EProcessorInputMode
local UI_TM			= CppEnums.TextMode
local UCT 			= CppEnums.PA_UI_CONTROL_TYPE

Panel_AgreementGuild_Master:SetShow( false )

local _memberIndex			= -1;
local _isJoin				= false;
local _targetActorKeyRaw	= 0;
local _targetName			= ""
local isRenew				= false

local AgreementGuild_Master = {
	-- btn_Close			= UI.getChildControl( Panel_AgreementGuild_Master, "Button_Win_Close" ),
	btn_Send			= UI.getChildControl( Panel_AgreementGuild_Master, "Button_Confirm" ),
	btn_Refuse			= UI.getChildControl( Panel_AgreementGuild_Master, "Button_Refuse" ),
	btn_Close			= UI.getChildControl( Panel_AgreementGuild_Master, "Button_Close" ),
	title				= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_AgreementContentTitle" ),
	content				= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_AgreementContent" ),
	radioBtnPeriod		= UI.getChildControl( Panel_AgreementGuild_Master, "RadioButton_Period" ),

	penaltyCostTitle	= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_PenaltyCost"),
	dailyPaymentTitle	= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_DailyPayment"),
	remainPeriodTitle	= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_Period"),

	remainPeriod		= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_PeriodValue" ),
	dailyPayment		= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_PaymentValue" ),
	penaltyCost			= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_PenaltyCostValue" ),
	btnRenew			= UI.getChildControl( Panel_AgreementGuild_Master, "Button_Period_Renew" ),
	from				= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_From" ),
	to					= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_To" ),
	guildMark			= UI.getChildControl( Panel_AgreementGuild_Master, "Static_GuildMark" ),
	
	dailyPayment_edit 	= UI.getChildControl( Panel_AgreementGuild_Master, "Edit_Payment" ),
	penaltyCost_edit 	= UI.getChildControl( Panel_AgreementGuild_Master, "Edit_PenaltyCost" ),
	contractPeriod_edit = UI.getChildControl( Panel_AgreementGuild_Master, "Edit_ContractPeriod" ),

	memberBenefit		= 0,
	memberPenalty		= 0,
	
	maxDailyPayment 	= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_MaxPayment" ),
	maxpenaltyCost 		= UI.getChildControl( Panel_AgreementGuild_Master, "StaticText_MaxPenaltyCost" ),

	_frame				= UI.getChildControl( Panel_AgreementGuild_Master, "Frame_1"),

	usableActivity		= 0,
	maxBenefitValue		= 0,
	maxpenaltyCostValue	= 0,
}
_frame_Content	= UI.getChildControl( AgreementGuild_Master._frame, "Frame_1_Content")
_frame_Summary	= UI.getChildControl( _frame_Content, "StaticText_1")

-- 설정 기간 / 일당 / 위약금 세팅
local periodValue = {
	[0] = 0,
	[1] = 1,
	[2] = 7,
	[3] = 14,
	[4] = 30
}
-- 수당 일당 1000 씩 늘어남(이 값을 바꾸면 서버의 검증값도 바꾸어야함)
local paymentPerDay = {	
	[0] = 0,
	[1] = 1000,
	[2] = 7000,
	[3] = 14000,
	[4] = 30000
}
-- 위약금 일당 500 씩 늘어남(이 값을 바꾸면 서버의 검증값도 바꾸어야함)
local cancellationCharge = {
	[0] = 0,
	[1] = 500,
	[2] = 3500,
	[3] = 7000,
	[4] = 15000
}

-- 라디오 버튼 생성
AgreementGuild_Master._radioBtn_Period = {}
for index = 0, 4 do
	AgreementGuild_Master._radioBtn_Period[index]	=	{}
	AgreementGuild_Master._radioBtn_Period[index]	=	UI.createControl(  UCT.PA_UI_CONTROL_RADIOBUTTON, Panel_AgreementGuild_Master, "RadioButton_Period_" .. index )
	CopyBaseProperty( AgreementGuild_Master.radioBtnPeriod, AgreementGuild_Master._radioBtn_Period[index] )
	AgreementGuild_Master._radioBtn_Period[index]	:	SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_DAY", "day", periodValue[index] ) )
	AgreementGuild_Master._radioBtn_Period[index]	:	SetPosX( (AgreementGuild_Master.radioBtnPeriod:GetPosX() + 150) * index )
	AgreementGuild_Master._radioBtn_Period[index]	:	SetPosY( 480 )
	AgreementGuild_Master._radioBtn_Period[index]	:	SetShow( false )
	AgreementGuild_Master._radioBtn_Period[index]	:	addInputEvent( "Mouse_LUp", "HandleClicked_AgreementGuild_Master_SetData(".. index ..")" )
end

function HandleClicked_AgreementGuild_Master_SetData( index )
	local self = AgreementGuild_Master
	self._radioBtn_Period[index]:SetCheck( true )
	
	if( _isJoin ) then
		self.dailyPayment	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney( paymentPerDay[index] ) ) )
		self.penaltyCost	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney( cancellationCharge[index] ) ) )
	else
		local usableActivity	= self.usableActivity

		local tempBenefit32 = Int64toInt32(self.memberBenefit)
		local tempPenalty32 = Int64toInt32(self.memberPenalty)
	
		local useBenefit    = 0;
		if ( tempBenefit32 < paymentPerDay[index] ) then useBenefit = paymentPerDay[index] else useBenefit = tempBenefit32 end 
		
		local usePenalty    = 0;
		if ( tempPenalty32 < cancellationCharge[index] ) then usePenalty = cancellationCharge[index] else  usePenalty = tempPenalty32 end

		self.maxBenefitValue	= ( useBenefit	+ ( useBenefit * ( (usableActivity/100)/100 ) ) )
		self.maxpenaltyCostValue= ( usePenalty	+ ( usePenalty * ( (usableActivity/100)/100 ) ) )

		self.maxDailyPayment	:SetText( makeDotMoney( toInt64( 0, paymentPerDay[index] ) ) .." ~ " .. makeDotMoney(toInt64(0, self.maxBenefitValue)) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY") )
		self.maxpenaltyCost		:SetText( makeDotMoney( toInt64( 0, cancellationCharge[index] ) ).. " ~ " .. makeDotMoney(toInt64(0, self.maxpenaltyCostValue)) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY") )
		
		self.dailyPayment_edit	:SetEditText( tostring(self.memberBenefit) )
		self.penaltyCost_edit	:SetEditText( tostring(self.memberPenalty) )
	end
end

function AgreementGuild_Master:Initialize()
	AgreementGuild_Master:registEventHandler()

	_frame_Summary			:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	if isGameTypeEnglish() then
		self.dailyPayment_edit	:SetSpanSize( 180, self.dailyPayment_edit:GetSpanSize().y )
		self.penaltyCost_edit	:SetSpanSize( 180, self.penaltyCost_edit:GetSpanSize().y )
		self.penaltyCostTitle	:SetSpanSize( 50, self.penaltyCostTitle:GetSpanSize().y )
		self.dailyPaymentTitle	:SetSpanSize( 50, self.dailyPaymentTitle:GetSpanSize().y )
		self.remainPeriodTitle	:SetSpanSize( 50, self.remainPeriodTitle:GetSpanSize().y )
	else
		self.dailyPayment_edit	:SetSpanSize( 170, self.dailyPayment_edit:GetSpanSize().y )
		self.penaltyCost_edit	:SetSpanSize( 170, self.penaltyCost_edit:GetSpanSize().y )
		self.penaltyCostTitle	:SetSpanSize( 75, self.penaltyCostTitle:GetSpanSize().y )
		self.dailyPaymentTitle	:SetSpanSize( 75, self.dailyPaymentTitle:GetSpanSize().y )
		self.remainPeriodTitle	:SetSpanSize( 75, self.remainPeriodTitle:GetSpanSize().y )
	end
end

function AgreementGuild_Master:Update()
	local guildWrapper	= ToClient_GetMyGuildInfoWrapper()
	local guildName		= guildWrapper:getName()

	self.title				:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_CONTRACT", "guildName", guildName ) ) 	
	self.content			:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self.content			:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_3" ) )
	self.content			:SetShow( false )

	local isSet = setGuildTextureByGuildNo( guildWrapper:getGuildNo_s64(), self.guildMark )
	if ( false == isSet ) then
		self.guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( self.guildMark, 183, 1, 188, 6 )
		self.guildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.guildMark:setRenderTexture(self.guildMark:getBaseTexture())
	else
		self.guildMark:getBaseTexture():setUV(  0, 0, 1, 1  )
		self.guildMark:setRenderTexture(self.guildMark:getBaseTexture())
	end

	_frame_Summary:SetAutoResize()
	_frame_Summary:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_3") )
	_frame_Content:SetSize(_frame_Content:GetSizeX(), _frame_Summary:GetTextSizeY() )
	self._frame:UpdateContentPos()

	if _frame_Content:GetSizeY() < self._frame:GetSizeY() then
		self._frame:GetVScroll():SetShow( false )
	else
		self._frame:GetVScroll():SetShow( true )
	end
end

function AgreementGuild_Master:SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_AgreementGuild_Master:GetSizeX()
	local panelSizeY 	= Panel_AgreementGuild_Master:GetSizeY()

	Panel_AgreementGuild_Master:SetPosX( (scrSizeX / 2) - (panelSizeX / 2) )
	Panel_AgreementGuild_Master:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) )
end

function AgreementGuild_Master:SetShowContractPreSet( isShow )
	-- 재계약이면 isShow == false
	local self = AgreementGuild_Master
	local usableActivity = self.usableActivity
	-- 재계약시에는 0일을 켜지 않는다.
	local startRadioIndex = 0
	if true == _isJoin then
		startRadioIndex = 0
	else
		startRadioIndex = 1
	end

	local sumIndex = 0
	for index = startRadioIndex, #periodValue do
		self._radioBtn_Period[index]:SetPosX( self.radioBtnPeriod:GetPosX() + 80 * sumIndex )
		-- self._radioBtn_Period[index]:SetPosY(  )
		self._radioBtn_Period[index]:SetShow( true )
		self._radioBtn_Period[index]:SetCheck( false )
		sumIndex = sumIndex + 1
	end
	
	self.dailyPayment	:SetShow( true )
	self.penaltyCost	:SetShow( true )
	if( isShow ) then	
		HandleClicked_AgreementGuild_Master_SetData( #periodValue )			-- 가장 긴 날짜로 일단 설정
	end
	
	-- 직접 입력 컨트롤
	self.dailyPayment_edit		:SetShow( not isShow )
	self.penaltyCost_edit		:SetShow( not isShow )
	-- 뒤에 입력 가이드 부분.
	self.maxDailyPayment		:SetShow( not isShow )
	self.maxpenaltyCost			:SetShow( not isShow )

	self.contractPeriod_edit	:SetShow( false ) --not isShow )
end

function AgreementGuild_Master:SetHideContractControl()
	
	local self = AgreementGuild_Master

	for i=0, #periodValue do
		self._radioBtn_Period[i]:SetShow( false )
		self._radioBtn_Period[i]:SetCheck( false )
	end
	
	-- 직접 입력 컨트롤
	self.dailyPayment_edit	:SetShow( false )
	self.penaltyCost_edit	:SetShow( false )
	self.contractPeriod_edit:SetShow( false )

	self.maxDailyPayment	:SetShow( false )
	self.maxpenaltyCost		:SetShow( false )
end


-- 길드 고용 계약서는 두군데에서 호출된다.
-- 1. 길드 등급의 길드가 유져를 처음 길드 초대 할때,
-- 2. 길드원에게 고용 계약을 갱신할때
-- _isJoin 이 true 이면 1. 상황이고 false 이면 2. 상황이다.
function FGlobal_AgreementGuild_Master_Open_ForJoin( targetKeyRaw , targetName, preGuildActivity )-- 초대
	_targetActorKeyRaw = targetKeyRaw;
	_isJoin = true;
	_targetName = targetName

	local self			= AgreementGuild_Master
		
	local textTemp 		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_FORJOIN", "targetName", targetName ) -- "- 계약자 : "..targetName
	self.to				:SetText( textTemp );

	self.btn_Send:SetShow( true );	
	self.btn_Refuse:SetShow( true );
	self.btn_Close:SetShow( false )
	self.remainPeriod:SetShow( false )
	
	-- 처음부터 preset을 출력한다.
	self:SetShowContractPreSet( true );
	self.btnRenew:SetShow(false)
	
	AgreementGuild_Master:Update()
	AgreementGuild_Master:SetPosition()
	Panel_AgreementGuild_Master:SetShow( true )
end

-- 수당을 설정해봅시다!


-- ToClient_GetMyGuildInfoWrapper():getTotalActivity()				-- 토탈 활동량

-- 길드 고용 계약서는 두군데에서 호출된다.
-- 1. 길드 등급의 길드가 유져를 처음 길드 초대 할때,
-- 2. 길드원에게 고용 계약을 갱신할때
-- _isJoin 이 true 이면 1. 상황이고 false 이면 2. 상황이다.
function FGlobal_AgreementGuild_Master_Open( memberIndex , requesterMemberGrade, usableActivity )--재계약
	local self			= AgreementGuild_Master
	_isJoin = false;

	if 10000 < usableActivity then
		usableActivity = 10000
	end
	self.usableActivity = usableActivity
	
	local memberInfo 	= ToClient_GetMyGuildInfoWrapper():getMember(memberIndex);
	if( nil == memberInfo) then
		_PA_ASSERT( false , "FGlobal_AgreementGuild_Master_Open 의 멤버인덱스가 비정상입니다 " ..tostring(memberIndex) );
	end
	
	_memberIndex = memberIndex;
	
	local name			= memberInfo:getName()
	local expiration	= memberInfo:getContractedExpirationUtc()
	self.memberBenefit	= memberInfo:getContractedBenefit()
	self.memberPenalty	= memberInfo:getContractedPenalty()
	local temp1			= nil
	
	if ( 0 < Int64toInt32(getLeftSecond_TTime64(expiration)) ) then
 		temp1 = convertStringFromDatetime( getLeftSecond_TTime64(expiration) );
	else
		temp1 = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_REMAINPERIOD")
	end
	
	self:SetHideContractControl()
	
	self.remainPeriod:SetShow( true )
	self.remainPeriod:SetText( temp1 )
	
	self.dailyPayment:SetShow( true )
	self.penaltyCost:SetShow( true )
	
	self.dailyPayment	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self.memberBenefit) ) );
	self.penaltyCost	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(self.memberPenalty) ) );
	
	_targetName = name;
	local textTemp 		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_FORJOIN", "targetName", name ) -- "- 계약자 : "..name
	self.to:SetText( textTemp );
	
	self.btn_Send:SetShow( false );	
	self.btn_Refuse:SetShow( false );
	self.btn_Close:SetShow( true )
	
	isRenew = false;
	local contractAble		= memberInfo:getContractableUtc()
	local contractAbleTo	= false
	if(  0 == requesterMemberGrade ) then
		if ( Int64toInt32(getLeftSecond_TTime64(contractAble)) <= 0 ) then
			isRenew = true
		else
			isRenew = false
		end
	elseif( 1 == requesterMemberGrade ) then
		if ( Int64toInt32(getLeftSecond_TTime64(contractAble)) <= 0 ) then
			contractAbleTo = true
		else
			contractAbleTo = false
		end
		isRenew = ( 2 == memberInfo:getGrade() ) and ( contractAbleTo ) 
	else
		isRenew = false;
	end
	self.btnRenew:SetShow( isRenew )
		
	AgreementGuild_Master:Update()
	AgreementGuild_Master:SetPosition()
	Panel_AgreementGuild_Master:SetShow( true )
end

function agreementGuild_Master_Close()
	if( not Panel_AgreementGuild_Master:GetShow() ) then
		return
	end

	Panel_AgreementGuild_Master:SetShow( false )
	ClearFocusEdit()
	if ( AllowChangeInputMode() ) then
		if( UI.checkShowWindow() ) then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode) 
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
end

function agreementGuild_Master_Send()
	local self = AgreementGuild_Master
	local value_ContractPeriod	= nil
	local value_DailyPayment	= nil
	local value_PenaltyCost		= nil
	
	if( self.dailyPayment_edit:GetShow() ) then
		value_DailyPayment	= tonumber( self.dailyPayment_edit:GetEditText() )
		value_PenaltyCost	= tonumber( self.penaltyCost_edit:GetEditText() )
		
		if( nil == value_DailyPayment ) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY") ) -- "일일 수당을 입력해 주세요");
			return 
		end

		if( nil == value_PenaltyCost ) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_PENALTIES") ) -- "위약금을 입력해 주세요");
			return 
		end
	else
		for i = 0, #periodValue do
			if ( self._radioBtn_Period[i]:IsCheck() ) then
				value_ContractPeriod	= periodValue[i]
				value_DailyPayment		= paymentPerDay[i]
				value_PenaltyCost		= cancellationCharge[i]
			end
		end
	end
	
	-- 기간은 체크박스를 이용
	for i = 0, #periodValue do
		if ( self._radioBtn_Period[i]:IsCheck() ) then
			value_ContractPeriod	= periodValue[i]
		end
	end
	
	if( nil == value_ContractPeriod ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_PERIOD_EDIT") ) -- "기간을 입력해 주세요");
		return 
	end
	
	-- 처음 계약시에는 0일이 가능하다.
	if ( false == _isJoin ) then	
		if( value_ContractPeriod <= 0 )	then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_PERIOD_EDIT") ) -- "기간을 입력해 주세요");
			return;
		end
		local checkedIndex	= _AgreementGuild_Master_ReturnCheckedNum()
		if value_DailyPayment < paymentPerDay[checkedIndex] then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY_LESS") ) -- "일일 급여가 너무 적습니다.");
			return
		elseif self.maxBenefitValue < value_DailyPayment then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_DAILYMONEY_TOOMUCH") ) -- "일일 급여가 너무 많습니다.");
			return
		elseif value_PenaltyCost < cancellationCharge[checkedIndex] then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_BREACH_LESS") ) -- "위약 금액이 너무 적습니다.");
			return
		elseif self.maxpenaltyCostValue < value_PenaltyCost  then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_BREACH_TOOMUCH") ) -- "위약 금액이 너무 많습니다.");
			return
		end
	end

	-- 보낸다!
	if( _isJoin ) then
		toClient_RequestInviteGuild( _targetActorKeyRaw, value_ContractPeriod, value_DailyPayment, value_PenaltyCost)
	else
		ToClient_SuggestGuildContract( _memberIndex, value_ContractPeriod, value_DailyPayment, value_PenaltyCost );
	end
	
	agreementGuild_Master_Close()
end

function FromClient_Agreement_Result()
	local self						= AgreementGuild_Master	
	Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_ACK_MSG", "familyName", _targetName ) )
end

function HandleClicked_AgreementGuild_Master_SetEditBox( type )
	local self		= AgreementGuild_Master
	local control	= nil
	if 0 == type then
		control = self.dailyPayment_edit
	elseif 1 == type then
		control = self.penaltyCost_edit
	elseif 2 == type then
		control = self.contractPeriod_edit
	end

	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	control:SetEditText('', true)
end

function _AgreementGuild_Master_ReturnCheckedNum()
	local self				= AgreementGuild_Master
	for idx = 1, #periodValue do
		local isCheck = self._radioBtn_Period[idx]:IsCheck()
		if true == isCheck then
			return idx
		end
	end
end

function HandleClicked_AgreementGuild_Master_Renew()
	local self				= AgreementGuild_Master
	local usableActivity	= self.usableActivity

	local memberInfo 	= ToClient_GetMyGuildInfoWrapper():getMember(_memberIndex);
	if( nil == memberInfo) then
		_PA_ASSERT( false , "FGlobal_AgreementGuild_Master_Open 의 멤버인덱스가 비정상입니다 " ..tostring(memberIndex) );
	end
	
	local name			= memberInfo:getName()
	local expiration	= memberInfo:getContractedExpirationUtc()
	
	self.memberBenefit	= memberInfo:getContractedBenefit()
	self.memberPenalty	= memberInfo:getContractedPenalty()

	local temp1			= nil
	
	if ( 0 < Int64toInt32(getLeftSecond_TTime64(expiration)) ) then
 		temp1 = convertStringFromDatetime( getLeftSecond_TTime64(expiration) );
	else
		temp1 = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_REMAINPERIOD") -- "만료"
	end
	
	self.remainPeriod:SetShow( false )
	
	local tempBenefit32 = Int64toInt32(self.memberBenefit)
	local tempPenalty32 = Int64toInt32(self.memberPenalty)

	-- UI.debugMessage( tempBenefit32 )
	
	--if( 0 == tempBenefit32 ) then -- 최초계약시 preset을 사용
	--	self:SetShowContractPreSet( true );		
	--else -- 최초계약이 아닌경우 editbox 를 사용
		self:SetShowContractPreSet( false );

		-- 직접 입력 컨트롤
		-- UI.debugMessage( tostring(self.dailyPayment_edit:GetShow()) )
	-- self.dailyPayment_edit		:SetShow( not isShow )
	-- self.penaltyCost_edit		:SetShow( not isShow )
	-- 뒤에 입력 가이드 부분.
	-- self.maxDailyPayment		:SetShow( not isShow )
	-- self.maxpenaltyCost			:SetShow( not isShow )

		self.dailyPayment_edit	:SetEditText( tostring(tempBenefit32) )
		self.penaltyCost_edit	:SetEditText( tostring(tempPenalty32) )

		self._radioBtn_Period[4]:SetCheck( true )

		local checkedIndex	= _AgreementGuild_Master_ReturnCheckedNum()
		
		local useBenefit    = 0;
		if ( tempBenefit32 < paymentPerDay[checkedIndex] ) then useBenefit = paymentPerDay[checkedIndex] else useBenefit = tempBenefit32 end 
		
		local usePenalty    = 0;
		if ( tempPenalty32 < cancellationCharge[checkedIndex] ) then usePenalty = cancellationCharge[checkedIndex] else  usePenalty = tempPenalty32 end

		self.maxBenefitValue	= ( useBenefit	+ ( useBenefit	* ( (usableActivity/100)/100 ) ) )
		self.maxpenaltyCostValue= ( usePenalty	+ ( usePenalty  * ( (usableActivity/100)/100 ) ) )

		self.maxDailyPayment	:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_MAXDAILYPAYMENT", "checkedIndex", makeDotMoney(toInt64(0, paymentPerDay[checkedIndex])), "maxBenefitValue", makeDotMoney(toInt64(0, self.maxBenefitValue)) ) ) -- makeDotMoney(toInt64(0, paymentPerDay[checkedIndex])) .." ~ " .. makeDotMoney(toInt64(0, self.maxBenefitValue)) .. " 은화" )
		self.maxpenaltyCost		:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_MASTER_MAXDAILYPAYMENT", "checkedIndex", makeDotMoney(toInt64(0, cancellationCharge[checkedIndex])), "maxpenaltyCostValue", makeDotMoney(toInt64(0, self.maxpenaltyCostValue)) ) ) -- makeDotMoney(toInt64(0, cancellationCharge[checkedIndex])).. " ~ " .. makeDotMoney(toInt64(0, self.maxpenaltyCostValue)) .. " 은화" )
		-- myGuildMemberInfo:getUsableActivity()
	--end

	self.dailyPayment:SetShow( false )
	self.penaltyCost:SetShow( false )

	self.btn_Close	:SetShow( false )
	self.btnRenew	:SetShow( false )
	self.btn_Send	:SetShow( true )
	self.btn_Refuse	:SetShow( true )
end

function AgreementGuild_Master:registEventHandler()
	-- self.btn_Close			:addInputEvent("Mouse_LUp", "agreementGuild_Master_Close()")
	self.btn_Send			:addInputEvent("Mouse_LUp", "agreementGuild_Master_Send()")
	self.btn_Refuse			:addInputEvent("Mouse_LUp", "agreementGuild_Master_Close()")
	self.btn_Close			:addInputEvent("Mouse_LUp", "agreementGuild_Master_Close()")
	self.btnRenew			:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Master_Renew()" )
	self.dailyPayment_edit	:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Master_SetEditBox(" .. 0 .. ")")
	self.penaltyCost_edit	:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Master_SetEditBox(" .. 1 .. ")")
	self.contractPeriod_edit:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Master_SetEditBox(" .. 2 .. ")")
end
function AgreementGuild_Master:registMessageHandler()
	-- 성공적으로 보냈으면!! FromClient_Agreement_Result()
end

AgreementGuild_Master:Initialize()

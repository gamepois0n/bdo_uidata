Panel_AgreementGuild:SetShow( false, false )
Panel_AgreementGuild:RegisterShowEventFunc( true, 'AgreementGuildShowAni()' )
Panel_AgreementGuild:RegisterShowEventFunc( false, 'AgreementGuildHideAni()' )
Panel_AgreementGuild:SetDragAll( true )

local UIMode 	= Defines.UIMode
local IM 		= CppEnums.EProcessorInputMode

local AgreementGuild = {
	BTN_Confirm		= UI.getChildControl( Panel_AgreementGuild, "Button_Confirm" ),
	BTN_Refuse		= UI.getChildControl( Panel_AgreementGuild, "Button_Refuse" ),
	AgreementNotify	= UI.getChildControl( Panel_AgreementGuild, "StaticText_AgreementNotify" ),

	Content			= UI.getChildControl( Panel_AgreementGuild, "StaticText_AgreementContent" ),
	ContentTitle	= UI.getChildControl( Panel_AgreementGuild, "StaticText_AgreementContentTitle" ),
	SummaryTitle	= UI.getChildControl( Panel_AgreementGuild, "StaticText_AgreementSummaryTitle" ),
	SummaryFocusBG	= UI.getChildControl( Panel_AgreementGuild, "Static_AgreementSummaryFocusBG" ),
	DailyPayment	= UI.getChildControl( Panel_AgreementGuild, "StaticText_DailyPayment" ),
	Period			= UI.getChildControl( Panel_AgreementGuild, "StaticText_Period" ),
	PenaltyCost		= UI.getChildControl( Panel_AgreementGuild, "StaticText_PenaltyCost" ),
	From			= UI.getChildControl( Panel_AgreementGuild, "StaticText_From" ),
	To				= UI.getChildControl( Panel_AgreementGuild, "StaticText_To" ),
	-- ToSignature		= UI.getChildControl( Panel_AgreementGuild, "StaticText_Signature" ),
	InPutPlayerName	= UI.getChildControl( Panel_AgreementGuild, "Edit_PlayerName" ),
	
	GuildMark_Wax	= UI.getChildControl( Panel_AgreementGuild, "Static_Wax" ),
	GuildMark		= UI.getChildControl( Panel_AgreementGuild, "Static_GuildMark" ),

	_frame			= UI.getChildControl( Panel_AgreementGuild, "Frame_1"),
}
_frame_Content	= UI.getChildControl( AgreementGuild._frame, "Frame_1_Content")
_frame_Summary	= UI.getChildControl( _frame_Content, "StaticText_1")

function AgreementGuildShowAni()
end
function AgreementGuildHideAni()
end


local _inviteGuildName					= ""
local _inviteGuildMasterFamilyName		= ""
local _inviteGuildMasterCharacterName	= ""
local _dailyPayment						= 0
local _period							= 0
local _penaltyCost						= 0
local _s64_guildNo						= 0

function AgreementGuild:Initialize()
	self.Content			:SetIgnore( true )
	self.ContentTitle		:SetIgnore( true )
	self.SummaryTitle		:SetIgnore( true )
	self.SummaryFocusBG		:SetIgnore( true )
	self.DailyPayment		:SetIgnore( true )
	self.Period				:SetIgnore( true )
	self.PenaltyCost		:SetIgnore( true )
	self.From				:SetIgnore( true )
	self.To					:SetIgnore( true )
	-- self.InPutPlayerName	:SetIgnore( true )
	-- self.ToSignature		:SetIgnore( false )

	-- self.BTN_Confirm		:SetEnable( false )
	-- self.BTN_Confirm		:SetMonoTone( true )

	self.Content			:SetAutoResize( true )
	self.Content			:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	_frame_Summary			:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	_frame_Summary:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_3") )
	_frame_Content:SetSize(_frame_Content:GetSizeX(), _frame_Summary:GetTextSizeY() )
	self._frame:UpdateContentPos()

	if _frame_Content:GetSizeY() < self._frame:GetSizeY() then
		self._frame:GetVScroll():SetShow( false )
	else
		self._frame:GetVScroll():SetShow( true )
	end
end

local _signCheck	= false
local _isJoin		= false;

function AgreementGuild:SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_AgreementGuild:GetSizeX()
	local panelSizeY 	= Panel_AgreementGuild:GetSizeY()

	Panel_AgreementGuild:SetPosX( (scrSizeX / 2) - (panelSizeX / 2) )
	Panel_AgreementGuild:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) )
end

function AgreementGuild:Update()
	local inviteGuildName					= _inviteGuildName
	local inviteGuildMasterFamilyName		= _inviteGuildMasterFamilyName
	local inviteGuildMasterCharacterName	= _inviteGuildMasterCharacterName
	local period							= _period
	local dailyPayment						= _dailyPayment
	local penaltyCost						= _penaltyCost

	self.AgreementNotify	:SetText( "[" .. inviteGuildName .. "] " .. PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_1" ) )
	self.ContentTitle		:SetText( "[" .. inviteGuildName .. "] " .. PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_2" ) ) 		

	self.Content			:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_3" ) )
	self.Content			:SetShow( false )
	self.DailyPayment		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_DAILYPAYMENT", "dailyPayment", dailyPayment ) )
	-- "- 일일 급여 : " .. dailyPayment
	self.Period				:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_PERIOD", "period", period ) )
	-- "- 계약 기간 : " .. period .. "일"
	self.PenaltyCost		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_PENALTYCOST", "penaltyCost", penaltyCost ) )
	-- "- 위약 금액 : " .. penaltyCost
	self.From				:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_FROM", "inviteGuildMasterFamilyName", inviteGuildMasterFamilyName, "inviteGuildMasterCharacterName", inviteGuildMasterCharacterName ) )
	-- 가문명(캐릭터명) / 	"고용주 : " .. inviteGuildMasterFamilyName .. "(" .. inviteGuildMasterCharacterName .. ")"

	-- self.BTN_Confirm		:SetEnable( false )
	-- self.BTN_Confirm		:SetMonoTone( true )

	local isSet = setGuildTextureByGuildNo( _s64_guildNo, self.GuildMark )
	if ( false == isSet ) then
		self.GuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( self.GuildMark, 183, 1, 188, 6 )
		self.GuildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self.GuildMark:setRenderTexture(self.GuildMark:getBaseTexture())
	else
		self.GuildMark:getBaseTexture():setUV(  0, 0, 1, 1  )
		self.GuildMark:setRenderTexture(self.GuildMark:getBaseTexture())
	end

	local myNick		= getSelfPlayer():getUserNickname()
	-- if signCheck then
	-- 	self.To				:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_TO_DETAIL", "myName", myNick ) )
	-- 	-- "계약자 : " .. myName
	-- 	-- self.ToSignature	:SetShow( false )
	-- 	self.BTN_Confirm	:SetEnable( true )
	-- 	self.BTN_Confirm	:SetIgnore( false )
	-- 	self.BTN_Confirm	:SetMonoTone( false )
	-- else
		self.To				:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_TO_DETAIL", "myName", myNick ) )
		-- 가문명(캐릭터명) / "계약자 : "
	-- end
end

-- function AgreementGuild_Sign()
-- 	local self = AgreementGuild
-- 	self.InPutPlayerName:SetShow(true);
-- 	self.InPutPlayerName:SetEditText("", true);
-- 	SetFocusEdit(self.InPutPlayerName)
-- 	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode) 
-- 	signCheck = true
-- 	self:Update()
-- end

function FGlobal_AgreementGuild_Open( isJoin, hostUsername, hostname, guildName, period, benefit, penalty, s64_guildNo )
	local self = AgreementGuild
	_s64_guildNo = s64_guildNo

	if getSelfPlayer():get():isGuildMaster() then	-- 길마는 안 떠도 된다.
		return
	end
	
	_isJoin = isJoin
	_inviteGuildName = guildName
	_inviteGuildMasterFamilyName	= hostUsername
	_inviteGuildMasterCharacterName = hostname
	
	_period			=	period
	_dailyPayment 	= 	benefit
	_penaltyCost	= 	penalty
	
	signCheck = false;
	self.To:SetText("");
	-- self.InPutPlayerName:SetShow(true);
	-- self.ToSignature:SetShow(true);
	
	self:Update()

	self:SetPosition()
	
	Panel_AgreementGuild:SetShow( true, true )
end

function FGlobal_AgreementGuild_Close()
	if( not Panel_AgreementGuild:GetShow() ) then
		return;
	end

	Panel_AgreementGuild:SetShow( false, false )
	ClearFocusEdit();
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

function HandleClicked_AgreementGuild_Close()
	FGlobal_AgreementGuild_Close()
end

function HandleClicked_AgreementGuild_Confirm()
	_AgreementGuild_Confirm()
end

function FGlobal_AgreementGuild_Confirm()
	_AgreementGuild_Confirm()
end

function _AgreementGuild_Confirm()
	local self = AgreementGuild;
	
	local inputName = getSelfPlayer():getUserNickname() -- self.InPutPlayerName:GetEditText();	-- 캐릭터 이름으로 써야 함.
	-- if( getSelfPlayer():getUserNickname() ~= inputName ) then
	-- 	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENTGUILD_FAMILYNAME") ) -- "가문명을 정확히 입력해주세요." );
	-- 	return;
	-- end
	
	-- 수락한다!
	if( _isJoin ) then
		ToClient_RequestAcceptGuildInvite();
	else
		ToClient_RenewGuildContract(true);
	end	
	
	FGlobal_AgreementGuild_Close()
end

-- function FGlobal_CheckEditBox_AgreementGuild( uiEditBox )
-- 	return ( nil ~= uiEditBox ) and ( uiEditBox:GetKey() == AgreementGuild.InPutPlayerName:GetKey() )
-- end

function HandleClicked_AgreementGuild_Refuse()
	_AgreementGuild_Refuse()
end
function FGlobal_AgreementGuild_Refuse()
	_AgreementGuild_Refuse()
end

function _AgreementGuild_Refuse()
	-- 거절한다!
	if( _isJoin ) then
		ToClient_RequestRefuseGuildInvite();
	else
		ToClient_RenewGuildContract(false);
	end
	
	FGlobal_AgreementGuild_Close()
end

function AgreementGuild:registEventHandler()
	self.BTN_Confirm	:addInputEvent("Mouse_LUp", "HandleClicked_AgreementGuild_Confirm()")
	self.BTN_Refuse		:addInputEvent("Mouse_LUp",	"HandleClicked_AgreementGuild_Refuse()")
	-- self.ToSignature	:addInputEvent("Mouse_LUp", "AgreementGuild_Sign()")
end
function AgreementGuild:registMessageHandler()
end

AgreementGuild:Initialize()
AgreementGuild:registEventHandler()

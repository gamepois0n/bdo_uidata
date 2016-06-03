local UI_ANI_ADV    = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color      = Defines.Color
local IM            = CppEnums.EProcessorInputMode
local UI_classType	= CppEnums.ClassType
local UI_TM			= CppEnums.TextMode

Panel_Guild_Recruitment:SetShow( true )

----------------------------------------------------------------------------------------------------------------
--                                      공지사항 프레임 불러오기
----------------------------------------------------------------------------------------------------------------
local defaultFrameBG_Recruitment	= UI.getChildControl ( Panel_Window_Guild,		"Static_Frame_RecruitmentBG" )

local GuildRecruitment = {
	scroll				= UI.getChildControl ( Panel_Guild_Recruitment,	"Scroll_Recruitment" ),

	inviteGuildBG		= UI.getChildControl ( Panel_Guild_Recruitment,	"Static_FunctionBG" ),
	inviteGuildSubBG	= UI.getChildControl ( Panel_Guild_Recruitment,	"Static_FunctionSubBG" ),
	
	inviteGuildBtn		= UI.getChildControl ( Panel_Guild_Recruitment,	"Button_Function" ),
	inviteGuildClose	= UI.getChildControl ( Panel_Guild_Recruitment,	"Button_Close" ),
	invitePlayerName	= UI.getChildControl ( Panel_Guild_Recruitment,	"StaticText_SelectedPlayerName" ),
	
	selectedPlayer		= -1,
	maxSLotCount		= 22,
	SlotCols			= 1,

	_startIndex			= 0,

	slotPool			= {},
}

GuildRecruitment.scroll:SetShow( false )

local tooltip =
{
	_bg		= UI.getChildControl( Panel_Guild_Recruitment, "Static_TooltipBG" ),
	_name	= UI.getChildControl( Panel_Guild_Recruitment, "Tooltip_Name" ),
	_desc	= UI.getChildControl( Panel_Guild_Recruitment, "Tooltip_Description" )
}
tooltip._desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
tooltip._bg:SetIgnore( true )

local unjoinPlayerList = {}

function Guild_Recruitment_Initialize()
	local self = GuildRecruitment

	local slotStartY		= 78
	local slotGapY			= 25

	for slotIdx = 0, self.maxSLotCount - 1 do
		local posY		= slotStartY + (slotGapY * slotIdx)
		local slot = {}
		
		slot.bg		= UI.createAndCopyBasePropertyControl( Panel_Guild_Recruitment, "Template_Static_BG",	Panel_Guild_Recruitment,	"GuildRecruitment_BG_"					.. slotIdx )
		slot.bg:SetSpanSize( 0, posY )

		slot.lev	= UI.createAndCopyBasePropertyControl( Panel_Guild_Recruitment, "Template_StaticText_Level",	slot.bg,	"GuildRecruitment_Lev_"					.. slotIdx )
		slot.lev:SetSpanSize( 0, 0 )

		slot.class	= UI.createAndCopyBasePropertyControl( Panel_Guild_Recruitment, "Template_StaticText_Class",	slot.bg,	"GuildRecruitment_Class_"					.. slotIdx )
		slot.class:SetSpanSize( 45, 0 )
		slot.name	= UI.createAndCopyBasePropertyControl( Panel_Guild_Recruitment, "Template_StaticText_Name",		slot.bg,	"GuildRecruitment_Name_"					.. slotIdx )
		slot.name:SetSpanSize( 100, 0 )
		slot.intro	= UI.createAndCopyBasePropertyControl( Panel_Guild_Recruitment, "Template_StaticText_Introduce",slot.bg,	"GuildRecruitment_Intro_"					.. slotIdx )
		slot.intro:SetSpanSize( 340, 0 )

		-- slot.bg		:addInputEvent( "Mouse_UpScroll",	"GuildRecruitment_ScrollEvent( true )" )
		-- slot.bg		:addInputEvent( "Mouse_DownScroll",	"GuildRecruitment_ScrollEvent( false )" )

		self.slotPool[slotIdx] = slot
	end

	-- defaultFrameBG_Recruitment:addInputEvent( "Mouse_UpScroll",		"GuildRecruitment_ScrollEvent( true )" )
	-- defaultFrameBG_Recruitment:addInputEvent( "Mouse_DownScroll",	"GuildRecruitment_ScrollEvent( false )" )

	self.inviteGuildBG		:AddChild( self.inviteGuildSubBG )
	self.inviteGuildBG		:AddChild( self.inviteGuildBtn )
	self.inviteGuildBG		:AddChild( self.inviteGuildClose )
	self.inviteGuildBG		:AddChild( self.invitePlayerName )
	
	Panel_Guild_Recruitment	:RemoveControl( self.inviteGuildSubBG )
	Panel_Guild_Recruitment	:RemoveControl( self.inviteGuildBtn )
	Panel_Guild_Recruitment	:RemoveControl( self.inviteGuildClose )
	Panel_Guild_Recruitment	:RemoveControl( self.invitePlayerName )

	self.inviteGuildSubBG	:ComputePos()
	self.inviteGuildBtn		:ComputePos()
	self.inviteGuildClose	:ComputePos()
	self.invitePlayerName	:ComputePos()

	Panel_Guild_Recruitment:SetChildIndex(self.inviteGuildBG, 8888 )
	
	self.inviteGuildBG:SetChildIndex(self.inviteGuildClose, 9999 )
	self.inviteGuildBG:SetChildIndex(self.inviteGuildBtn, 9999 )
	
	Panel_Guild_Recruitment:SetChildIndex( tooltip._bg, 9999 )
	Panel_Guild_Recruitment:SetChildIndex( tooltip._name, 9999 )
	Panel_Guild_Recruitment:SetChildIndex( tooltip._desc, 9999 )

	defaultFrameBG_Recruitment:MoveChilds(defaultFrameBG_Recruitment:GetID(), Panel_Guild_Recruitment)
	UI.deletePanel(Panel_Guild_Recruitment:GetID())
end

function GuildRecruitment:Update()
	-- 초기화
	for slotIdx = 0, self.maxSLotCount - 1 do
		local slot = self.slotPool[slotIdx]
		slot.bg		:SetShow( false )
		slot.lev	:SetShow( false )
		slot.class	:SetShow( false )
		slot.name	:SetShow( false )
		slot.intro	:SetShow( false )
	end

	local replaceClassType = function( classNo )		-- 직업 치환
		local returnValue = ""
		if UI_classType.ClassType_Warrior == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WARRIOR") -- "워리어"
		elseif UI_classType.ClassType_Ranger == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_RANGER") -- "레인저"
		elseif UI_classType.ClassType_Sorcerer == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_SORCERER") -- "소서러"
		elseif UI_classType.ClassType_Giant == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_GIANT") -- "자이언트"
		elseif UI_classType.ClassType_Tamer == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_TAMER") -- "금수랑"
		elseif UI_classType.ClassType_BladeMaster == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTER") -- "블레이더"
		elseif UI_classType.ClassType_BladeMasterWomen == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTERWOMAN") -- 매화
		elseif UI_classType.ClassType_Valkyrie == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_VALKYRIE") -- "발키리"
		elseif UI_classType.ClassType_Wizard == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARD") -- "위자드"
		elseif UI_classType.ClassType_WizardWomen == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARDWOMAN") -- 위치
		elseif UI_classType.ClassType_Kunoichi == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_KUNOICHI") -- ""
		elseif UI_classType.ClassType_NinjaWomen == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAWOMEN") -- "쿠노이치"
		elseif UI_classType.ClassType_NinjaMan == classNo then
			returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAMAN") -- 닌자
		end

		return returnValue
	end

	local guildUnjoinedCount	= ToClient_GetGuildUnjoinedPlayerCount()
	local viewCount = 0
	if guildUnjoinedCount <= self.maxSLotCount then	-- 한 페이지만 나오게 할 것이당!
		viewCount = guildUnjoinedCount
	else
		viewCount = self.maxSLotCount
	end

	local count = 0
	for slotIdx = self._startIndex, viewCount - 1 do
		if( self.maxSLotCount <= count ) then
			break
		end
		local unjoinPlayerWrapper	= ToClient_GetGuildUnjoinedPlayerAt( slotIdx )
		if nil ~= unjoinPlayerWrapper and 5 < unjoinPlayerWrapper:getLevel() then
			local playerLevel			= unjoinPlayerWrapper:getLevel()
			local playerClass			= unjoinPlayerWrapper:getClassType()
			local playerNickName		= unjoinPlayerWrapper:getUserNickName()
			local playerName			= unjoinPlayerWrapper:getCharacterName()
			local isWant				= unjoinPlayerWrapper:doWant()
			local playerIntro			= unjoinPlayerWrapper:getUserIntroduction()

			if nil == playerIntro or "" == playerIntro then
				playerIntro = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO_NODATA") -- 자기 소개가 등록되지 않았습니다.
			end

			local slot = self.slotPool[count]

			slot.bg		:SetShow( true )
			slot.lev	:SetShow( true )
			slot.class	:SetShow( true )
			slot.name	:SetShow( true )
			slot.intro	:SetShow( true )

			slot.lev	:SetText( playerLevel )
			slot.class	:SetText( replaceClassType( playerClass ) )
			slot.name	:SetText( playerNickName .. "(" .. playerName .. ")" )
			slot.intro	:SetTextMode( CppEnums.TextMode.eTextMode_LimitText )
			slot.intro	:SetText( string.gsub(playerIntro, "\n", " ") )

			local fontColor = nil
			if true == isWant then
				fontColor = UI_color.C_FFEE7001
			else
				fontColor = UI_color.C_FFEFEFEF
			end
			slot.lev	:SetFontColor( fontColor )
			slot.class	:SetFontColor( fontColor )
			slot.name	:SetFontColor( fontColor )
			slot.intro	:SetFontColor( fontColor )

			slot.bg		:addInputEvent( "Mouse_LUp",	"GuildRecruitment_SelectPlayer( " .. slotIdx .. ", " .. count .. " )" )
			slot.bg		:addInputEvent( "Mouse_On",		"GuildRecruit_Tooltip(" .. slotIdx .. ", " .. count .. ")" )
			slot.bg		:addInputEvent( "Mouse_Out",	"GuildRecruit_Tooltip()" )

			count = count + 1
		end
	end

	-- UIScroll.SetButtonSize( self.scroll, self.maxSLotCount, #tempData )
end

-- function GuildRecruitment_ScrollEvent( isUp )
-- 	local	self		= GuildRecruitment
-- 	self._startIndex	= UIScroll.ScrollEvent( self.scroll, isUp, 22, #tempData+1, self._startIndex, 2 )
-- 	self:Update()
-- end

function GuildRecruitment_SelectPlayer( idx, uiIdx )
	local self			= GuildRecruitment
	local parentSlot	= self.slotPool[uiIdx].bg
	self.selectedPlayer	= idx

	local unjoinPlayerWrapper	= ToClient_GetGuildUnjoinedPlayerAt( idx )
	local playerNickName		= unjoinPlayerWrapper:getUserNickName()
	local playerName			= unjoinPlayerWrapper:getCharacterName()
	
	self.inviteGuildBG		:SetShow( true )
	self.inviteGuildBtn		:SetShow( true )
	self.invitePlayerName	:SetShow( true )

	self.invitePlayerName:SetText( playerNickName .. "(" .. playerName .. ")" )

	self.inviteGuildBG:SetPosX( parentSlot:GetPosX() + (parentSlot:GetSizeX()/2) )
	self.inviteGuildBG:SetPosY( parentSlot:GetPosY() )
end

local guildRecruit_TooltipHide = function()
	local self = tooltip
	self._bg:SetShow( false )
	self._name:SetShow( false )
	self._desc:SetShow( false )
end

local guildRecruit_TooltipShow = function( uiControl, name, desc )
	guildRecruit_TooltipHide()
	
	local self = tooltip
	self._bg:SetShow( true )
	self._name:SetShow( true )
	self._desc:SetShow( true )
	
	self._name:SetText( name )
	
	local nameLength = math.max( 150, self._name:GetTextSizeX())
	self._desc:SetSize( nameLength, self._desc:GetSizeY() )
	self._desc:SetText( desc )
	self._bg:SetSize( nameLength + 10, self._name:GetSizeY() + self._desc:GetTextSizeY() + 15 )
	
	local posX = uiControl:GetPosX()
	local posY = uiControl:GetPosY()
	
	self._bg:SetPosX( posX + 130 )
	self._bg:SetPosY( posY + 25 )
	self._name:SetPosX( self._bg:GetPosX() + 5 )
	self._name:SetPosY( self._bg:GetPosY() + 5 )
	self._desc:SetPosX( self._name:GetPosX() )
	self._desc:SetPosY( self._name:GetPosY() + self._name:GetSizeY() )
end

function GuildRecruit_Tooltip( index, count )
	if nil == index then
		guildRecruit_TooltipHide()
		return
	end
	
	local unjoinPlayerList = ToClient_GetGuildUnjoinedPlayerAt( index )
	local name		= unjoinPlayerList:getCharacterName() .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO") -- 님의 자기 소개
	local desc		= unjoinPlayerList:getUserIntroduction()
	local uiControl	= GuildRecruitment.slotPool[count].bg
	
	if nil == desc or "" == desc then
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO_NODATA") -- 자기 소개가 등록되지 않았습니다.
	end
	
	guildRecruit_TooltipShow( uiControl, name, desc )
end

function GuildRecruitment_InvitePlayer_Select()
	local self		= GuildRecruitment
	if -1 ~= self.selectedPlayer then
		local unjoinPlayerWrapper	= ToClient_GetGuildUnjoinedPlayerAt( self.selectedPlayer )
		local playerName			= unjoinPlayerWrapper:getCharacterName()

		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		FGlobal_ChattingInput_ShowWhisper( playerName )
		GuildRecruitment_InvitePlayer_Close()
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_NOSELECT") ) -- "선택된 플레이어가 없습니다." )
	end
end

function GuildRecruitment_InvitePlayer_Close()
	local self		= GuildRecruitment
	self.selectedPlayer = -1
	self.inviteGuildBG:SetShow( false )
end

function GuildRecruitment:registEventHandler()
	self.inviteGuildBtn		:addInputEvent( "Mouse_LUp", "GuildRecruitment_InvitePlayer_Select()" )
	self.inviteGuildClose	:addInputEvent( "Mouse_LUp", "GuildRecruitment_InvitePlayer_Close()" )

	-- UIScroll.InputEvent( self.scroll,	"GuildRecruitment_ScrollEvent" )
end

function Guild_Recruitment_Open()
	local self		= GuildRecruitment

	defaultFrameBG_Recruitment:SetShow( true )
	if self.inviteGuildBG:GetShow() then
		self.inviteGuildBG:SetShow( false )
	end

	-- ToClient_RequestGuildUnjoinedPlayerList()	-- 길드 가입하지 않은 유저 목록을 가져온다.
	GuildRecruitment:Update()
end

function FGolbal_Guild_Recruitment_SelectPlayerClose()
	GuildRecruitment_InvitePlayer_Close()
end

function FGolbal_Guild_Recruitment_SelectPlayerCheck()
	local self		= GuildRecruitment
	return self.inviteGuildBG:GetShow()
end

function Guild_Recruitment_Close()
	defaultFrameBG_Recruitment:SetShow( false )
end

-- Guild_Recruitment_Initialize()

GuildRecruitment:registEventHandler()



-- ToClient_RequestGuildUnjoinedPlayerList()
-- ToClient_GetGuildUnjoinedPlayerCount()
-- ToClient_GetGuildUnjoinedPlayerAt(index)

-- ToClient_SetJoinedMode(0 or 1)

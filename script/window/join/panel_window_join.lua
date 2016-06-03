local UIMode 		= Defines.UIMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_TM 		= CppEnums.TextMode

Panel_Join:SetShow(false, false)									-- 가급적 꺼두고 시작
Panel_Join:setMaskingChild(true)									-- 자식까지 masking 할지 여부 설정(masking 사용 시 true)
Panel_Join:ActiveMouseEventEffect(true)								-- 패널에 마우스 가져갈 때 이펙트 줄지 설정
Panel_Join:setGlassBackground( true )								-- 패널의 반투명 설정(뒤가 보임), 기본적으로 true
Panel_Join:RegisterShowEventFunc( true, 'Panel_Join_ShowAni()' )			-- 패널이 show 될 때 애니메이션
Panel_Join:RegisterShowEventFunc( false, 'Panel_Join_HideAni()' )			-- 패널이 hide 될 때 애니메이션

function Panel_Join_ShowAni()
end

function Panel_Join_HideAni()
end

local join =
{
	radioBtn = {
		[0]	= UI.getChildControl( Panel_Join, "RadioButton_LocalWar" ),			-- 국지전
		[1]	= UI.getChildControl( Panel_Join, "RadioButton_Colosseum" ),		-- 결투장
	},
	
	_index			= 0,
	_conditionCheck	= true,
	
	_mainBg			= UI.getChildControl( Panel_Join, "Static_BG" ),
		
	_title			= UI.getChildControl( Panel_Join, "StaticText_ContentTitle" ),
	_titleBg		= UI.getChildControl( Panel_Join, "Static_BG_1" ),
	_headIcon		= UI.getChildControl( Panel_Join, "Static_HeadIcon" ),
	_myRank			= UI.getChildControl( Panel_Join, "StaticText_MyRank" ),
	_myPoint		= UI.getChildControl( Panel_Join, "StaticText_MyPoint" ),
	_condition		= UI.getChildControl( Panel_Join, "StaticText_Condition" ),
		
	_ruleTitle		= UI.getChildControl( Panel_Join, "StaticText_RuleTitle" ),
	_ruleBg			= UI.getChildControl( Panel_Join, "Static_BG_2" ),
	_ruleContent	= UI.getChildControl( Panel_Join, "StaticText_RuleContent" ),
	
	_rewardTitle	= UI.getChildControl( Panel_Join, "StaticText_RewardTitle" ),
	_rewardBg		= UI.getChildControl( Panel_Join, "Static_BG_3" ),
	_rewardContent	= UI.getChildControl( Panel_Join, "StaticText_RewardContent" ),
	
	btn_Join		= UI.getChildControl( Panel_Join, "Button_Join" ),
	btn_Rank		= UI.getChildControl( Panel_Join, "Button_Rank" ),
	btn_Close		= UI.getChildControl( Panel_Join, "Button_Close" ),
}
join._ruleContent:SetTextMode( UI_TM.eTextMode_AutoWrap )
join._rewardContent:SetTextMode( UI_TM.eTextMode_AutoWrap )

local localWar =
{
	_title = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_TITLE"),		-- "※ 붉은 전장",
	_condition = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_CONDITION"),		-- "<PAColor0xFFF26A6A>- 조건 : 50Lv 이상<PAOldColor>",
	_iconTextureUrl = "New_UI_Common_ForLua/Window/Join/localwar.dds",
	
	_rule = {
		[0] = "체크용 더미",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE1"), -- "- 붉은 전장은 <PAColor0xFFF26A6A>20분 동안 팀전으로 진행<PAOldColor>되며, 시작 후 10분까지 참여할 수 있습니다.",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE2"), -- "- 데스매치 형태로 진행되며, <PAColor0xFFF26A6A>쌓인 점수를 합산해 높은 팀이 이깁니다.<PAOldColor>",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE3"), -- "- 파티 상태에서는 붉은 전장에 참여할 수 없습니다.",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE4"), -- "- 능력치(공방합)가 일정 수준에 미치지 못한 모험가는 최소 보정을 받습니다.",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE5"), -- "- 상대 팀을 죽이면 대상의 상태에 따라 점수를 얻을 수 있습니다.",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE6"), -- " :: 죽였을 때, 적 모험가 보유 점수의 1/2 획득",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE7"), -- " :: 죽었을 때, 내 점수 1/4 잃음",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE8"), -- " :: 죽거나 죽였을 때, 최소 획득 점수는 1점",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE10"), -- - 공성전 채널이 아닌 채널에서만 붉은 전장이 진행됩니다.
		-- PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE9"), -- "- <PAColor0xFFF26A6A>지고 있는 팀(200점 이상 차이)에게는 생명력 500 증가 버프가 생깁니다.<PAOldColor>",
	},
	
	_reward = {
		[0] = "체크용 더미",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_REWARD1"), -- "- <PAColor0xFFF26A6A>전장이 종료되면, 승리 팀은 <붉은 인장> 4개, 패배 팀은 1개를 받습니다.<PAOldColor>",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_REWARD_3"),
	}
}

local colosseum =
{
	_title = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_TITLE"),		-- "※ 결투장",
	_condition = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_CONDITION"),		-- "<PAColor0xFFF26A6A>- 조건 : 50Lv 이상, 3인 파티의 파티장<PAOldColor>",
	_iconTextureUrl = "New_UI_Common_ForLua/Window/Join/colosseum.dds",
	
	_rule = {
		[0] = "체크용 더미",			-- 기본 nil 대체용. 텍스트 표시는 [1]번부터 함! 그대로 놔둘 것~.
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_RULE_1"),		-- "- 결투 신청은 <PAColor0xFFffd429>3인으로 구성된 파티<PAOldColor>의 파티장만 가능합니다.",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_RULE_2"),		-- "- 결투가 시작되면 안내 메시지와 함께 결투장으로 이동되며, 결투 종료 시 기존 위치로 복귀합니다.",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_RULE_3"),		-- "- 결투는 한쪽 팀이 모두 사망하거나, 10분이 지나면 종료됩니다.",
	},
	
	_reward = {
		[0] = "체크용 더미",
		PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_REWARD_1"),		-- "- 추후 구현 예정",
	}
}

function Panel_Join_Init()
	for index, value in pairs( join.radioBtn ) do
		value:SetCheck( false )
	end
	
	join._index = 0
	join.radioBtn[join._index]:SetCheck( true )
end

function Panel_Join_Update( index )
	if nil == index then
		index = join._index
	else
		join._index = index
	end

	local self
	if 0 == index then
		self = localWar
	elseif 1 == index then
		self = colosseum
	else
		self = localWar
	end
	
	join._title:SetText( self._title )
	join._condition:SetText( self._condition )
	join._headIcon:ChangeTextureInfoName( self._iconTextureUrl )
	MyRankRangeAndPoint( index )
	
	if 0 == index and 0 < ToClient_GetMyTeamNoLocalWar() then
		local teamName
		if 1 == ToClient_GetMyTeamNoLocalWar() then
			teamName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_TITLE_1", "title", self._title )		-- self._title .. " (검은 사막팀으로 참여중)"
		else
			teamName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_TITLE_2", "title", self._title )		-- self._title .. " (붉은 사막팀으로 참여중)"
		end
		join._title:SetText( teamName )
	end
	
	local ruleCount = #self._rule
	local rewardCount = #self._reward
	local posY = join._titleBg:GetPosY() + join._titleBg:GetSizeY()
	local gapY = 5
	local textSizeY = 20
	
	if 0 < ruleCount then
		join._ruleTitle		:SetShow( true )
		join._ruleBg		:SetShow( true )
		join._ruleContent	:SetShow( true )
		local content = ""
		for i = 1, ruleCount do
			if 1 == i then
				content = self._rule[i]
			else
				content = content .. "\n" .. self._rule[i]
			end
		end
		join._ruleContent	:SetText( content )
		join._ruleBg		:SetSize( join._ruleBg:GetSizeX(), join._ruleContent:GetTextSizeY() + gapY * 2 )
		posY = join._ruleBg:GetPosY() + join._ruleBg:GetSizeY() + ( gapY * 2 )
	else
		join._ruleTitle		:SetShow( false )
		join._ruleBg		:SetShow( false )
		join._ruleContent	:SetShow( false )
		posY = posY + ( gapY * 2 )
	end
	
	if 0 < rewardCount then
		join._rewardTitle	:SetShow( true )
		join._rewardBg		:SetShow( true )
		join._rewardContent	:SetShow( true )
		join._rewardTitle	:SetPosY( posY )
		posY = posY + join._rewardTitle:GetTextSizeY() + gapY
		join._rewardBg		:SetPosY( posY )
		posY = posY + gapY
		join._rewardContent	:SetPosY( posY )
		
		local content = ""
		for i = 1, rewardCount do
			if 1 == i then
				content = self._reward[i]
			else
				content = content .. "\n" .. self._reward[i]
			end
		end
		join._rewardContent	:SetText( content )
		join._rewardBg		:SetSize( join._rewardBg:GetSizeX(), join._rewardContent:GetTextSizeY() + gapY * 2 )
		posY = join._rewardBg:GetPosY() + join._rewardBg:GetSizeY() + gapY
	else
		join._rewardTitle	:SetShow( false )
		join._rewardBg		:SetShow( false )
		join._rewardContent	:SetShow( false )
	end
	
	if 0 == index then
		if 0 == ToClient_GetMyTeamNoLocalWar() then		-- 0이면 미참가, 1은 1팀 참가, 2는 2팀 참가
			join.btn_Join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_ADMIN_1"))		-- "참 가" )
		else
			join.btn_Join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_CANCEL_1"))		-- "이 탈" )
		end
	elseif 1 == index then
		if ToClient_IsRequestedPvP() then		-- 신청 등록중이면
			join.btn_Join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_ADMIN_2"))		-- "취 소" )
		else
			join.btn_Join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_CANCEL_2"))		-- "등 록" )
		end
	end
	
	
	join._mainBg:SetSize( join._mainBg:GetSizeX(), posY - join._mainBg:GetPosY() )
	Panel_Join:SetSize( Panel_Join:GetSizeX(), join._mainBg:GetSizeY() + 125 )
	join.btn_Join:ComputePos()
	join.btn_Rank:ComputePos()
end

function MyRankRangeAndPoint( index )
	local self
	if 0 == index then
		self = localWar
	elseif 1 == index then
		self = colosseum
	else
		self = localWar
	end
	
	local myRank, myPoint, myRankRate, rankGrade
	if 1 == index then			-- 결투장
		myRank					= ToClient_GetMyMatchRank( 0 )
		local servnerUserCnt	= ToClient_GetMatchRankerUserCount( 0 )		-- 동접자수 확인할 수 있는 함수이니 절대 그냥 사용하지 말 것.(로그를 쓰더라도 커밋하기전에 삭제할 것.)
		myRankRate 				= tonumber(myRank / servnerUserCnt * 100)
		myPoint					= ToClient_GetMyMatchPoint(0)
	elseif 0 == index then		-- 붉은 전장
		myRank					= ToClient_GetContentsMyRank( 2 )
		local servnerUserCnt	= ToClient_GetContentsRankUserCount( 2 )	-- 동접자수 확인할 수 있는 함수이니 절대 그냥 사용하지 말 것.(로그를 쓰더라도 커밋하기전에 삭제할 것.)
		myRankRate 				= tonumber(myRank / servnerUserCnt * 100)
		myPoint					= ToClient_GetMyAccumulatedKillCount()
	end
	
	join._myPoint:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_MYPOINT", "point", myPoint))		-- "- 점수 : " .. myPoint )
	if 0 == myPoint then
		join._myRank:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_RANK_NONE"))	-- "- 순위 : 순위 없음" )
	else
		if myRank <= 30 then
			join._myRank:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_MYRANK", "rank", myRank ))	-- "- 순위 : " .. myRank .." 위" )
		else
			if 0 <= myRankRate and myRankRate <= 20 then
				rankGrade = "A"
			elseif 20 < myRankRate and myRankRate <= 40 then
				rankGrade = "B"
			elseif 40 < myRankRate and myRankRate <= 60 then
				rankGrade = "C"
			elseif 60 < myRankRate and myRankRate <= 80 then
				rankGrade = "D"
			elseif 80 < myRankRate and myRankRate <= 100 then
				rankGrade = "E"
			end
			join._myRank:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_GRADE", "grade", rankGrade ))	-- "- 등급 : " .. rankGrade .." 등급" )
		end
	end
end


function Join_SelectTap( index )
	join._index = index
	Panel_Join_Update( index )
end

function RankWindow_Show()
	for idx, value in pairs(join.radioBtn) do
		if join.radioBtn[idx]:IsCheck() then
			Panel_Join_Close()
			FGlobal_LifeRanking_Show( idx )
			break
		end
	end
end

function Content_Join()
	for idx, value in pairs(join.radioBtn) do
		if join.radioBtn[idx]:IsCheck() then
			if 0 == idx then
				local partyMemberCount = RequestParty_getPartyMemberCount()
				if 0 < partyMemberCount then
					join._conditionCheck = Panel_Join_PartyMasterCheck( partyMemberCount )
					if join._conditionCheck then
						for index = 0, partyMemberCount - 1 do
							local memberData = RequestParty_getPartyMemberAt(index)
							local memberLv = memberData._level
							if memberLv < 50 then
								Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_1"))	-- "50Lv을 넘지 않는 파티원이 있어 신청할 수 없습니다." )
								return
							end
						end
					end
				else
					join._conditionCheck = true
				end
				-- join._conditionCheck 는 파티 상태인 파티원일 때만 false

				if join._conditionCheck then
					if 0 == ToClient_GetMyTeamNoLocalWar() then		-- 0이면 미참가, 1은 1팀 참가, 2는 2팀 참가
						ToClient_JoinLocalWar()				-- 붉은 전장 참가 : FromClient_JoinLocalWar(int teamNo) 호출
					else
						local pcPosition = getSelfPlayer():get():getPosition()
						local regionInfo = getRegionInfoByPosition(pcPosition)
						-- if regionInfo:get():isSafeZone() then
							ToClient_UnJoinLocalWar()		-- 전장 이탈
						-- else
						-- 	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_2"))	-- "안전 지역에서만 붉은 전장을 이탈할 수 있습니다." )
						-- end
					end
				else
					if 0 == ToClient_GetMyTeamNoLocalWar() then		-- 0이면 미참가, 1은 1팀 참가, 2는 2팀 참가
						Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_3"))	-- "파티장만 전장 참가 신청을 할 수 있습니다." )
					else
						Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_4"))	-- "붉은 전장을 이탈하려면 파티를 탈퇴해야 합니다." )
					end
				end
			elseif 1 == idx then
				if 0 == ToClient_GetMyTeamNoLocalWar() then
					if ToClient_IsRequestedPvP() then		-- 결투장 신청중이면,
						ToClient_UnRequestMatchInfo()		-- 결투 신청 취소
					else
						HandleClicked_RegisterMatch()		-- 결투장 참가
					end
				else
					Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_5"))	-- "붉은 전장 참여중에는 결투장에 참여할 수 없습니다." )
				end
			end
			break
		end
	end
end

function Panel_Join_PartyMasterCheck( count )
	local isSelfMaster = false
	for index = 0, count - 1 do
		local memberData = RequestParty_getPartyMemberAt(index)
		local isMaster = memberData._isMaster
		if RequestParty_isSelfPlayer(index) and isMaster then
			isSelfMaster = true
			break
		end
	end
	
	return isSelfMaster
end

function FromClient_JoinLocalWar( teamNo )			-- teamNo는 1, 2로 들어옴
	local teamName
	if 1 == teamNo then
		teamName = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_1")		-- "검은사막군"
	else
		teamName = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_2")		-- "붉은사막군"
	end
	local msg, showRate, msgType = { main, sub, addMsg = "" }, 3, 34
	msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_WELCOME_1")		-- "붉은 전장에 오신 걸 환영합니다."
	msg.sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_WELCOME_2", "team", teamName )		-- "[" .. teamName .. "]에서 당신의 활약을 기대합니다."
	Proc_ShowMessage_Ack_For_RewardSelect( msg, showRate, msgType )
	
	-- 다이얼로그 창이 떠 있으면 국지전 창을 띄우지 않는다!! 다이얼로그 창이 닫힐 때 국지전 창을 체크하기 때문!
	if Panel_Npc_Dialog:GetShow() then
		Panel_Join_Close()
	else							-- 떠 있지 않으면 바로 열어준다!
		-- FGlobal_LocalWar_Show()
		FGlobal_NewLocalWar_Show()
	end
end

function FromClient_UnJoinLocalWar( unJoinType )
	local msg, showRate, msgType = { main = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_LEAVEMSG_1"), sub = "", addMsg = "" }, 3, 35
	
	if 1 == unJoinType then
		main.sub = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_LEAVEMSG_2")		-- "커다운 전운이 감돌아 붉은 전장이 종료됩니다."
	elseif 2 == unJoinType then
		main.sub = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_LEAVEMSG_3")		-- "붉은 전장에서 투쟁심이 자취를 감추었습니다."
	end
	Proc_ShowMessage_Ack_For_RewardSelect( msg, showRate, msgType )
	-- Proc_ShowMessage_Ack( "붉은 전장에서 이탈했습니다." )
		-- 다이얼로그 창이 떠 있으면 국지전 창을 바로 닫지 않는다!! 다이얼로그 창이 닫힐 때 국지전 창을 체크하기 때문!
	if Panel_Npc_Dialog:GetShow() then
		Panel_Join_Close()
	else							-- 떠 있지 않으면 바로 닫아준다!
		-- LocalWar_Hide()
		NewLocalWar_Hide()
	end

end

function Panel_Join_Show()
	local self = join
	if Panel_Window_Enchant:GetShow() then			-- 다른 창들이 열려 있다면 닫아준다!
		FGlobalEnchant_Hide()
		ToClient_BlackspiritEnchantClose()
	elseif Panel_Window_Socket:GetShow() then
		Socket_WindowClose()
		ToClient_BlackspiritEnchantClose()
	end
	local isSiegeChannel = ToClient_isSiegeChannel()
	FGlobal_LifeRanking_Close()
	SkillAwaken_Close()
	
	if not Panel_Join:GetShow() then
		Panel_Join:SetShow( true )
		Panel_Join_Repos()
	end

	if isSiegeChannel then	-- 공성 채널이 아닌 곳에서만 참여가 가능하다.
		self.btn_Join:SetIgnore( true )
		self.btn_Join:SetMonoTone( true )
	else
		self.btn_Join:SetIgnore( false )
		self.btn_Join:SetMonoTone( false )
	end

	Panel_Join_Init()
	Panel_Join_Update()
end

function Panel_Join_Close()
	if Panel_Join:GetShow() then
		Panel_Join:SetShow( false )
	end
end

function Panel_Join_Repos()
	Panel_Join:SetPosX( getScreenSizeX()/2 + Panel_Join:GetSizeX() )
	Panel_Join:SetPosY( getScreenSizeY()/2 - Panel_Join:GetSizeY()*2/3 - 50 )
end

function Panel_Join_RegisterEvent()
	join.btn_Close:addInputEvent( "Mouse_LUp",	"Panel_Join_Close()" )
	join.btn_Join:addInputEvent( "Mouse_LUp",	"Content_Join()" )
	join.btn_Rank:addInputEvent( "Mouse_LUp",	"RankWindow_Show()" )

	for idx, value in pairs(join.radioBtn) do
		join.radioBtn[idx]:addInputEvent("Mouse_LUp",	"Join_SelectTap( " .. idx .. " )")
		-- join.radioBtn[idx]:addInputEvent("Mouse_On",	"Join_Simpletooltips( true, " .. idx .. " )")
		-- join.radioBtn[idx]:addInputEvent("Mouse_Out",	"Join_Simpletooltips( false )")
		-- join.radioBtn[idx]:setTooltipEventRegistFunc(	"Join_Simpletooltips( true, " .. idx .. ")")
	end
	
	registerEvent( "FromClient_JoinLocalWar",		"FromClient_JoinLocalWar" )			-- 국지전 참가. 인자 1, 2 : 팀 넘버
	registerEvent( "FromClient_UnJoinLocalWar",		"FromClient_UnJoinLocalWar" )		-- 국지전 취소
end

function Join_Simpletooltips( isShow, index )
	local name, desc, uiControl
	if isShow then
		if 0 == index then
			name = "붉은 전장"
			desc = ""
			uiControl = join.radioBtn[index]
		elseif 1 == index then
			name = "결투장"
			desc = ""
			uiControl = join.radioBtn[index]
		end
		registTooltipControl( uiControl, Panel_Tooltip_SimpleText )
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end			
	
end


Panel_Join_RegisterEvent()
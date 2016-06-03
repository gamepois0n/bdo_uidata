local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

--[[ 순서 :   --]]
local MessageData	=
{
	_Msg = {}					-- 메시지 인덱스 저장
}

local curIndex				= 0			-- 세이브 인덱스
local processIndex			= 0			-- 처리 인덱스
local animationEndTime		= 2.3
local elapsedTime			= 2.3		-- 메모리용 타이머

local _text_Msg				= UI.getChildControl( Panel_RewardSelect_NakMessage, "MsgText" )
local _text_MsgSub			= UI.getChildControl( Panel_RewardSelect_NakMessage, "MsgSubText" )
local _text_AddMsg			= UI.getChildControl( Panel_RewardSelect_NakMessage, "TradeSubText" )

local bigNakMsg				= UI.getChildControl( Panel_RewardSelect_NakMessage, "Static_BigNakMsg" )					-- 도전과제 달성 메시지
local nakItemIconBG			= UI.getChildControl( Panel_RewardSelect_NakMessage, "Static_IconBG" )						-- 아이템 아이콘BG
local nakItemIcon			= UI.getChildControl( Panel_RewardSelect_NakMessage, "Static_Icon" )						-- 아이템 아이콘

local localwarMsg			= UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_Localwar" )				-- 붉은전장_텍스쳐
local localwarMsgSmallBG	= UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_LocalwarSmall" )			-- 붉은전장_작은BG(역전, 100점이상 킬)
local localwarMsgBG			= UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_LocalwarBG" )				-- 붉은전장_큰BG(승리, 패배)
local _text_localwarMsg		= UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_LocalwarText")				-- 붉은전장_텍스트

local huntingRanker =
{
	[1] = UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_Hunting_1" ),
	[2] = UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_Hunting_2" ),
	[3] = UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_Hunting_3" ),
	[4] = UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_Hunting_4" ),
	[5] = UI.getChildControl( Panel_RewardSelect_NakMessage, "StaticText_Hunting_5" )
}

bigNakMsg			:SetShow( false )
localwarMsg			:SetShow( false )
localwarMsgSmallBG	:SetShow( false )
localwarMsgBG		:SetShow( false )
_text_localwarMsg	:SetShow( false )
nakItemIconBG		:SetShow( false )
nakItemIcon			:SetShow( false )

local messageType = {
	safetyArea				= 0,
	combatArea				= 1,
	challengeComplete		= 2,
	normal					= 3,
	selectReward			= 4,
	territoryTradeEvent		= 5,	-- 영지 무역 이벤트
	npcTradeEvent			= 6,	-- NPC 무역 이벤트
	royalTrade				= 7,	-- 황실 무역 이벤트
	supplyTrade				= 8,	-- 황실 납품 이벤트
	fitnessLevelUp			= 9,
	territoryWar_Start		= 10,	-- 영지전 이벤트(시작)
	territoryWar_End		= 11,	-- 영지전 이벤트(종료)
	territoryWar_Add		= 12,	-- 영지전 이벤트(추가)
	territoryWar_Destroy	= 13,	-- 영지전 이벤트(파괴)
	territoryWar_Attack		= 14,	-- 영지전 이벤트(피격)
	guildWar_Start			= 15,	-- 길드전 이벤트
	guildWar_End			= 16,	-- 길드전 이벤트
	roulette				= 17,
	anotherPlayerGotItem	= 18,	-- 다른 플레이어 아이템 획득
	itemMarket				= 19,	-- 아이템 거래소
	inSiegeArea				= 20,	-- 점령전 지역 입장
	outSiegeArea			= 21, 	-- 점령전 지역 이탈
	guildMsg				= 22,	-- 길드 메시지
	lifeLevUp				= 23,	-- 생활 레벨 명장!
	characterHPwarning		= 24,	-- HP 20% 미만 긴급회피
	servantWarning			= 25,	-- 탑승물 피해시
	cookFail				= 26,	-- 요리 실패!
	alchemyFail				= 27,	-- 연금술 실패!
	whaleShow				= 28,	-- 고래 등장!
	whaleHide				= 29,	-- 고래 사라짐!
	defeatBoss				= 30,	-- 보스 처치!
	guildNotify				= 31,	-- 길드 공지
	changeSkill				= 32,	-- 마굿간에서 말 기술 변경했을 때!
	alchemyStoneGrowUp		= 33,	-- 연금석 경험치 올림.
	localWarJoin			= 34,	-- 국지전 참여
	localWarExit			= 35,	-- 국지전 이탈
	raceFail				= 36,	-- 말레이스 실패
	raceFinish				= 37,	-- 말레이스 종료
	raceMoveStart			= 38,	-- 말레이스 시작 장소 이동
	raceReady				= 39,	-- 말레이스 준비
	raceStart				= 40,	-- 말레이스 시작
	raceWaiting				= 41,	-- 말레이스 대기
	worldBossShow			= 42,	-- 크자카 / 누베르 등장
	raceAnother				= 43,	-- 말레이스 누가 어느 지점을 지났습니다!
	enchantFail				= 44,	-- 인첸트 실패!
	localWarWin				= 45,	-- 붉은전장 승리!
	localWarLose			= 46,	-- 붉은전장 패배!
	localWarTurnAround		= 47,	-- 붉은전장 역전!
	localWarCriticalBlack	= 48,	-- 검은사막군 100점 이상 획득!
	localWarCriticalRed		= 49,	-- 붉은사막군 100점 이상 획득!
	desertArea				= 50,	-- 사막 지역 진입
	playerKiller			= 51,	-- 사막 카오 플레이어 처치.
	huntingLandShow			= 52,	-- 육상 수렵 등장!
	huntingLandHide			= 53,	-- 육상 수렵 사라짐!

	--[[
		이 곳에 messageType을 추가할경우 NoShowMessageReturn 함수에 조건 혹은 예외처리 꼭 추가해주세요.	
	--]]
}


local messageTexture = {
	[messageType.normal]				= "New_UI_Common_forLua/Widget/NakMessage/Alert_01.dds",
	[messageType.selectReward]			= "New_UI_Common_forLua/Widget/NakMessage/NakBG_RewardAlert_01.dds",
	[messageType.combatArea]			= "New_UI_Common_forLua/Widget/NakMessage/NakBG_Combat_01.dds",
	[messageType.safetyArea]			= "New_UI_Common_forLua/Widget/NakMessage/NakBG_Safety_01.dds",
	[messageType.challengeComplete]		= "New_UI_Common_forLua/Widget/NakMessage/NakBG_RewardAlert_01.dds",
	[messageType.territoryTradeEvent]	= "New_UI_Common_forLua/Widget/NakMessage/Trade_GlobalEvent_01.dds",
	[messageType.npcTradeEvent]			= "New_UI_Common_forLua/Widget/NakMessage/Trade_LocalEvent_01.dds",
	[messageType.royalTrade]			= "New_UI_Common_forLua/Widget/NakMessage/TerritoryAuth_Message01.dds",
	[messageType.supplyTrade]			= "New_UI_Common_forLua/Widget/NakMessage/TerritoryAuth_Message01.dds",
	[messageType.fitnessLevelUp]		= "New_UI_Common_forLua/Widget/NakMessage/NakBG_Train.dds",
	[messageType.territoryWar_Start]	= "New_UI_Common_forLua/Widget/NakMessage/TerritoryWar_Start.dds",
	[messageType.territoryWar_End]		= "New_UI_Common_forLua/Widget/NakMessage/TerritoryWar_End.dds",
	[messageType.territoryWar_Add]		= "New_UI_Common_forLua/Widget/NakMessage/TerritoryWar_addGuildTent.dds",
	[messageType.territoryWar_Destroy]	= "New_UI_Common_forLua/Widget/NakMessage/TerritoryWar_destroyGuildTent.dds",
	[messageType.territoryWar_Attack]	= "New_UI_Common_forLua/Widget/NakMessage/TerritoryWar_attackGuildTent.dds",
	[messageType.guildWar_Start]		= "New_UI_Common_forLua/Widget/NakMessage/guildWar_start.dds",
	[messageType.guildWar_End]			= "New_UI_Common_forLua/Widget/NakMessage/guildWar_End.dds",
	[messageType.roulette]				= "New_UI_Common_forLua/Widget/NakMessage/NakBG_Roulette.dds",
	[messageType.anotherPlayerGotItem]	= "New_UI_Common_forLua/Widget/NakMessage/NakBG_anotherPlayerGotItem.dds",
	[messageType.itemMarket]			= "New_UI_Common_forLua/Widget/NakMessage/Alert_01.dds",
	[messageType.inSiegeArea]			= "New_UI_Common_forLua/Widget/NakMessage/TerritoryWar.dds",
	[messageType.outSiegeArea]			= "New_UI_Common_forLua/Widget/NakMessage/Non_TerritoryWar.dds",
	[messageType.guildMsg]				= "New_UI_Common_forLua/Widget/NakMessage/NakBG_Guild.dds",
	[messageType.lifeLevUp]				= "New_UI_Common_forLua/Widget/NakMessage/NakBG_RewardAlert_01.dds",	-- todo(15.02.03 김창욱) : 텍스쳐 바꿔야 함.
	[messageType.characterHPwarning]	= "New_UI_Common_forLua/Widget/NakMessage/Character_HPwarning.dds",
	[messageType.servantWarning]		= "New_UI_Common_forLua/Widget/NakMessage/Horse_Warning.dds",
	[messageType.cookFail]				= "New_UI_Common_forLua/Widget/NakMessage/Fail_Cooking.dds",
	[messageType.alchemyFail]			= "New_UI_Common_forLua/Widget/NakMessage/Fail_Alchemy.dds",
	[messageType.whaleShow]				= "New_UI_Common_forLua/Widget/NakMessage/NakBG_Hunting.dds",
	[messageType.whaleHide]				= "New_UI_Common_forLua/Widget/NakMessage/NakBG_Hunting_End.dds",
	[messageType.defeatBoss]			= "New_UI_Common_forLua/Widget/NakMessage/boss.dds",
	[messageType.guildNotify]			= "New_UI_Common_forLua/Widget/NakMessage/Guild_Call.dds",
	[messageType.changeSkill]			= "New_UI_Common_forLua/Widget/NakMessage/Horse_skillchange.dds",
	[messageType.alchemyStoneGrowUp]	= "New_UI_Common_forLua/Widget/NakMessage/NakBG_anotherPlayerGotItem.dds",
	[messageType.localWarJoin]			= "New_UI_Common_forLua/Widget/NakMessage/LocalWar_Intro.dds",
	[messageType.localWarExit]			= "New_UI_Common_forLua/Widget/NakMessage/LocalWar_Exit.dds",
	[messageType.raceFail]				= "New_UI_Common_forLua/Widget/NakMessage/RaceMatch_Fail.dds",
	[messageType.raceFinish]			= "New_UI_Common_forLua/Widget/NakMessage/RaceMatch_Finish.dds",
	[messageType.raceMoveStart]			= "New_UI_Common_forLua/Widget/NakMessage/RaceMatch_MoveStart.dds",
	[messageType.raceReady]				= "New_UI_Common_forLua/Widget/NakMessage/RaceMatch_Ready.dds",
	[messageType.raceStart]				= "New_UI_Common_forLua/Widget/NakMessage/RaceMatch_Start.dds",
	[messageType.raceWaiting]			= "New_UI_Common_forLua/Widget/NakMessage/RaceMatch_Waitting.dds",
	[messageType.worldBossShow]			= "New_UI_Common_forLua/Widget/NakMessage/WorldBoss_Show.dds",
	[messageType.raceAnother]			= "New_UI_Common_forLua/Widget/NakMessage/RaceMatch_AnotherPoint.dds",
	[messageType.enchantFail]			= "New_UI_Common_forLua/Widget/NakMessage/NakBG_FailEnchant.dds",
	[messageType.localWarWin]			= "New_UI_Common_forLua/Widget/LocalWar/LocalWar_Win.dds",					-- 붉은 전장 승리
	[messageType.localWarLose]			= "New_UI_Common_forLua/Widget/LocalWar/LocalWar_Lose.dds",					-- 붉은 전장 패배
	[messageType.localWarTurnAround]	= "New_UI_Common_forLua/Widget/NakMessage/Turnaround.dds",					-- 붉은 전장 역전
	[messageType.localWarCriticalBlack]	= "New_UI_Common_forLua/Widget/NakMessage/BlackdesertScore.dds",
	[messageType.localWarCriticalRed]	= "New_UI_Common_forLua/Widget/NakMessage/ReddesertScore.dds",
	[messageType.desertArea]			= "New_UI_Common_forLua/Widget/NakMessage/NakBG_Danger.dds",				-- 사막 지역 진입
	[messageType.playerKiller]			= "New_UI_Common_forLua/Widget/NakMessage/Kill_Murderer.dds",				-- 사막 카오 플레이어 처치.
	[messageType.huntingLandShow]		= "New_UI_Common_forLua/Widget/NakMessage/NakBG_GroundHuntingSpawn.dds",	-- 육상 수렵!
	[messageType.huntingLandHide]		= "New_UI_Common_forLua/Widget/NakMessage/NakBG_GroundHuntingKill.dds",		-- 육상 수렵!
}

-- { 무역 이벤트
	-- 영지별 이벤트 데이터
	local _territoryName =
	{
		[0]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_AREANAME_BALENOS"), -- "발레노스 영지"
		[1]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_AREANAME_SERENDIA"), -- "세렌디아 영지"
		[2]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_AREANAME_CALPHEON"), -- "칼페온 영지"
		[3]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_AREANAME_MEDIA"), -- "메디아 영지"
	}

	local npcKey =
	{
			[40715] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1"),	-- "올비아 마을",
			[40026] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2"),	-- "로기아 농장",
			[40025] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3"),	-- "바탈리 농장",
			[40024] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4"),	-- "핀토 농장",
			[40031] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5"),	-- "델루치 농장",
			[40101] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6"),	-- "마리노 농장",
			[40609] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7"),	-- "일리야 섬",
			[40028] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8"),	-- "서부 캠프",
			[40010] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9"),	-- "벨리아",
			[41090] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10"), -- "글리시 마을",
			[41223] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11"), -- "중앙 캠프",
			[41221] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12"), -- "남부 캠프",
			[41085] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13"), -- "모레티 거대 농장",
			[41032] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14"), -- "엘다 농장",
			[41030] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15"), -- "알레한드로 농장",
			[41045] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16"), -- "코스타 농장",
			[41222] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17"), -- "동부관문",
			[41225] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18"), -- "서남부 관문",
			[41224] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19"), -- "서북부 관문",
			[41051] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20"), -- 하이델
			[42301] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21"), -- "에페리아 항구 마을",
			[42205] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22"), -- "플로린 마을",
			[43433] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23"), -- "델페 기사단 성",
			[50411] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24"), -- "고립된 초소",
			[50415] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25"), -- "코헨 농장",
			[50403] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26"), -- "트롤 방어 기지",
			[43449] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27"), -- "베르니안토 농장",
			[43440] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28"), -- "북부 밀 농장",
			[43446] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29"), -- "오염된 농장지",
			[43448] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30"), -- "디아스 농장",
			[43510] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31"), -- "델페 전진 기지",
			[42026] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32"), -- "칼페온 신성 대학",
			[43010] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33"), -- "케플란",
			[43210] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34"), -- "트리나 요새",
			[50428] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35"), -- "팔르스 소농장",
			[50432] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36"), -- "오베렌 농장",
			[50430] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37"), -- "바인 농장지",
			[50433] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38"), -- "봉화대 입구 초소",
			[50418] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39"), -- "칼페온 평원",
			[50440] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40"), -- "채굴장 사잇길",
			[50434] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41"), -- "폐채굴장",
			[50437] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42"), -- "지아닌 농장",
			[50438] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43"), -- "폐쇄된 서부 관문",
			[50443] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44"), -- "데인 협곡",
			[43310] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45"), -- "트렌트 마을",
			[43402] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46"), -- "베어 마을",
			[50456] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47"), -- "가비노 농장",
			[43501] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48"), -- "북 카이아 나루",
			[50455] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49"), -- "남 카이아 나루",
			[50451] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50"), -- "루툼 감시 초소",
			[50459] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51"), -- "만샤 숲",
			[42103] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52"), -- "버려진 수도원",
			[50466] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53"), -- "포니엘 산장",
			[50461] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54"), -- "토바레 오두막",
			[43407] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55"), -- "크리오 마을",
			[42013] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56"), -- "칼페온 시장 거리",
			[42005] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57"), -- "칼페온 빈민가",
			[44613] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY58"), -- "물텀벙 마을",
			[50551] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY59"), -- "카술라 농장",
			[50493] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY60"), -- "오마르 용암 동굴",
			[50550] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY61"), -- "슈리 농장",
			[50548] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY62"), -- "동꼬리 언덕 말 목장",
			[50475] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY63"), -- "메디아 북부 관문",
			[44010] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY64"), -- "알티노바",
			[44110] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY65"), -- "타리프 마을",
			[44210] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY66"), -- "아분 마을",
			[44610] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY67"), -- "쿠샤 마을",
	}

	local _commerceType = {
		[1] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_1"), -- "잡화",
		[2] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_2"), -- "사치품",
		[3] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_3"), -- "식료품",
		[4] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_4"), -- "약품",
		[5] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_5"), -- "군수품",
		[6] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_6"), -- "성물",
		[7] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_7"), -- "의류",
		[8] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_8"), -- "어패류",
		[9] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_9"), -- "원자재",
	}
	
	local _tradeMsgType =
	{
		[0] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEMSGTYPE_0"), -- 의문의 상단
		[1] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEMSGTYPE_1"), -- 까마귀 상단
		[2] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEMSGTYPE_2"), -- 시안 상단
		[3] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEMSGTYPE_3"), -- 하이델 상인조합회
		[4] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEMSGTYPE_4"), -- 오신 상단
		[5] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEMSGTYPE_5"), -- 셴 상인회
		[6] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEMSGTYPE_6"), -- 칼페온 공방
	}
	
-- }


local huntingRankingFont =
{
	size =
	{
		[0] = "BaseFont_18_Glow",
		[1] = "SubTitleFont_14_Glow",
		[2] = "BaseFont_12_Glow",
		[3] = "BaseFont_10_Glow",
		[4] = "BaseFont_10_Glow",
	},
	
	baseColor =
	{
		[0] = 4294958334,
		[1] = 4292673503,
		[2] = 4292408319,
		[3] = 4293848814,
		[4] = 4293848814,
	},
	
	glowColor =
	{
		[0] = 4285794145,
		[1] = 4280382471,
		[2] = 4280235448,
		[3] = 4278190080,
		[4] = 4278190080,
	}
}

_text_Msg		:SetText( "" )
_text_MsgSub	:SetText( "" )

local _msgType	= nil
local passFlush = false

-- 게임 옵션에서 체크 시 보이지 않게 처리
function NoShowMessageReturn( msgType )
	-- 게임설정 -> 안전/전투/위험 지역 진입 표시
	if messageType.safetyArea == msgType or messageType.combatArea == msgType or messageType.desertArea == msgType then
		msgTypeNum = 0

	-- 게임설정 -> 영지무역, NPC무역 이벤트 표시
	elseif messageType.territoryTradeEvent == msgType or messageType.npcTradeEvent == msgType then
		msgTypeNum = 1

	-- 게임설정 -> 황실무역/납품 표시
	elseif messageType.royalTrade == msgType or messageType.supplyTrade == msgType then
		msgTypeNum = 2

	-- 게임설정 -> 단련 렙업 표시
	elseif messageType.fitnessLevelUp == msgType then
		msgTypeNum = 3

	-- 게임설정 -> 점령전 시작/종료/추가/파괴/공격/성채(지휘소)건설 가능/불가능지역 표시
	elseif messageType.territoryWar_Start == msgType or messageType.territoryWar_End == msgType or messageType.territoryWar_Add == msgType or messageType.territoryWar_Destroy == msgType or messageType.territoryWar_Attack == msgType or messageType.inSiegeArea == msgType or messageType.outSiegeArea == msgType then
		msgTypeNum = 4

	-- 게임설정 -> 길드전 시작/종료 표시
	elseif messageType.guildWar_Start == msgType or messageType.guildWar_End == msgType then
		msgTypeNum = 5

	-- 게임설정 -> 타 이용자 아이템획득 및 룰렛 돌려 획득한 아이템 표시
	elseif (messageType.roulette == msgType) or (messageType.anotherPlayerGotItem == msgType) or (messageType.enchantFail == msgType) then
		msgTypeNum = 6

	-- 게임설정 -> 아이템 거래소 등록 메시지 표시
	elseif messageType.itemMarket == msgType then
		msgTypeNum = 7

	-- 게임설정 -> 타 이용자 명장레벨이상 렙업 표시
	elseif messageType.lifeLevUp == msgType then
		msgTypeNum = 8
	end

	local showJudgment = ToClient_GetMessageFilter( msgTypeNum )

	-- msgType 중 예외 처리 선언.
	if (messageType.challengeComplete	== msgType)	or (messageType.normal				== msgType) or (messageType.selectReward		== msgType)
		or (messageType.guildMsg		== msgType)	or (messageType.guildNotify			== msgType) or (messageType.cookFail			== msgType)
		or (messageType.alchemyFail		== msgType)	or (messageType.characterHPwarning	== msgType) or (messageType.servantWarning		== msgType)
		or (messageType.changeSkill		== msgType)	or (messageType.alchemyStoneGrowUp	== msgType) or (messageType.localWarJoin		== msgType)
		or (messageType.localWarExit	== msgType) or (messageType.raceFail			== msgType) or (messageType.raceFinish			== msgType)
		or (messageType.raceMoveStart	== msgType) or (messageType.raceReady			== msgType) or (messageType.raceStart			== msgType)
		or (messageType.raceWaiting		== msgType)	or (messageType.worldBossShow		== msgType) or (messageType.raceAnother			== msgType)
		or (messageType.localWarWin		== msgType) or (messageType.localWarLose		== msgType) or (messageType.localWarTurnAround	== msgType)
		or (messageType.localWarCriticalBlack		== msgType) or (messageType.localWarCriticalRed		== msgType)
		or (messageType.playerKiller	== msgType) or (messageType.whaleShow			== msgType) or (messageType.huntingLandShow		== msgType)
		or (messageType.whaleHide		== msgType) or (messageType.huntingLandHide		== msgType) then
		showJudgment = false
	end
	return showJudgment
end

function WhaleHuntingEvent( message, noticeMsgType, noticeValue )
	local msgType
	if (CppEnums.EChatNoticeType.HuntingStart == noticeMsgType) then
		if 0 == noticeValue then
			msgType = messageType.whaleShow
		elseif 1 == noticeValue then
			msgType = messageType.huntingLandShow
		end
	elseif (CppEnums.EChatNoticeType.HuntingEnd == noticeMsgType) then
		if 0 == noticeValue then
			msgType = messageType.whaleHide
		elseif 1 == noticeValue then
			msgType = messageType.huntingLandHide
		end
		local temporaryWrapper = getTemporaryInformationWrapper()
		local killContributeCount = temporaryWrapper:getKillContributeCount()
		local huntingRankerName = {}
		for index = 0, killContributeCount - 1 do
			huntingRankerName[index] = temporaryWrapper:getKillContributeNameByIndex( index )
			if temporaryWrapper:getKillContributePartyByIndex( index ) then
				huntingRankerName[index] = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_HUNTING_RESULT_PARTY", "rankerName", huntingRankerName[index] ) -- huntingRankerName[index] .. "님의 파티"
			end
			huntingRanker[index+1]:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_HUNTING_RESULT_RANK", "rank", index+1, "rankerName", huntingRankerName[index] ) ) -- index+1 .. "위 " .. huntingRankerName[index] )
			huntingRanker[index+1]:SetFontColor( huntingRankingFont.baseColor[index] )
			huntingRanker[index+1]:useGlowFont( true, huntingRankingFont.size[index], huntingRankingFont.glowColor[index] )
		end
	end
	local msg = { main = message, sub = PAGetString(Defines.StringSheet_GAME, "LUA_HUNTING_RULE"), addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( msg, 6.0, msgType )
	FGlobal_WhaleConditionCheck()
end

function FGlobal_WorldBossShow( message, noticeType, noticeValue )
	local msg = { main = message, sub = " ", addMsg = "" }
	local msgType = messageType.worldBossShow
	Proc_ShowMessage_Ack_For_RewardSelect( msg, 6.0, msgType )
end

function Proc_ShowMessage_Ack_For_RewardSelect( message, showRate, msgType, exposure )
	Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, showRate, msgType, exposure )
	-- 아이템 거래소는 클라이언트에서 처리함
	if messageType.itemMarket == msgType then
		return
	end
	for index = 1, 5 do
		huntingRanker[index]:SetShow( false )
	end
	-- 채팅 메시지 처리 방법 정의
	if (messageType.itemMarket == msgType) or (messageType.guildMsg == msgType) or ( messageType.lifeLevUp == msgType ) or ( messageType.alchemyStoneGrowUp == msgType ) or ( messageType.territoryWar_Start <= msgType and msgType <= messageType.guildWar_End ) or ( messageType.raceAnother == msgType ) or (messageType.localWarJoin == msgType) then
		chatting_sendMessage( "", message.main .. " " .. message.sub , CppEnums.ChatType.System )
	elseif messageType.anotherPlayerGotItem == msgType then
		if "" == message.sub then
			chatting_sendMessage( "", message.main, CppEnums.ChatType.System )
		else
			chatting_sendMessage( "", message.main .. "(" .. message.sub .. ")", CppEnums.ChatType.System )
		end
	elseif messageType.enchantFail == msgType then
		if "" == message.sub then
			chatting_sendMessage( "", message.main, CppEnums.ChatType.System )
		else
			chatting_sendMessage( "", message.main .. "(" .. message.sub .. ")", CppEnums.ChatType.System )
		end
	elseif messageType.playerKiller == msgType then
		if "" == message.sub then
			chatting_sendMessage( "", message.main, CppEnums.ChatType.System )
		else
			chatting_sendMessage( "", message.main .. "(" .. message.sub .. ")", CppEnums.ChatType.System )
		end

	else
		if "" == message.sub then
			chatting_sendMessage( "", message.main , CppEnums.ChatType.System )
		else
			chatting_sendMessage( "", message.sub , CppEnums.ChatType.System )
		end
	end

	if messageType.selectReward == msgType then
		passFlush = true
	else
		passFlush = false
	end
end

function Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( message, showRate, msgType, exposure )
	if NoShowMessageReturn( msgType ) then
		return
	end
	if 0 < ToClient_GetMyTeamNoLocalWar() and ((nil == exposure) or (true == exposure)) then
		return
	end
	if nil == showRate then
		animationEndTime	= 2.3
		elapsedTime			= 2.3
	else
		animationEndTime	= showRate
		elapsedTime			= showRate
	end
	
	curIndex = curIndex + 1
	MessageData._Msg[curIndex] = {}
	MessageData._Msg[curIndex].msg	= message
	MessageData._Msg[curIndex].type	= msgType

	Panel_RewardSelect_NakMessage:SetShow(true, false)
	NakMessagePanel_Resize_For_RewardSelect()
end

function Proc_ShowMessage_FrameEvent_For_RewardSelect( messageNum )
	local msg = { main = PAGetString(Defines.StringSheet_GAME, frameEventMessageIds[ messageNum ] ), sub = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( msg, 4, 4 )
end

local tradeEvent = nil
local _npcKey = nil
local isTradeEventOpen = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 22 )		-- 황실 납품 / 제작 납품 컨텐츠 그룹
function FromClient_NotifyVariableTradeItemMsg( territoryKey, npcCharacterKey, eventIndex )	-- 무역 이벤트
	if not isTradeEventOpen then
		return
	end
	local temporaryWrapper	= getTemporaryInformationWrapper()
	local varyTradeInfo		= temporaryWrapper:getVaryTradeItemInfo( territoryKey, npcCharacterKey, eventIndex )
	
	if nil == varyTradeInfo then
		return
	end
	
	_npcKey = npcCharacterKey
	
	-- _PA_LOG("이문종", "npcCharacterKey == " .. tostring(npcCharacterKey) .. " / eventIndex == " .. tostring(eventIndex) )

	if ( -1 < varyTradeInfo._territoryKey ) then
		isTerritoryEvent = true
	elseif ( 0 < varyTradeInfo._characterKey ) then
		isTerritoryEvent = false
	end

	local commerceMsg			= ""
	local commerceMsgforChat	= ""
	local message				= ""
	local msgName				= ""
	local msgContent			= ""
	if ( true == isTerritoryEvent ) then
		return
	else
		for ii = 1, enCommerceType.enCommerceType_Max -1 do
			if ( "" == commerceMsg ) then
				if nil == npcKey[varyTradeInfo._characterKey] then
					return
				end
				if ( 0 < varyTradeInfo:getPercentByCommerceType(ii) ) then
					commerceMsg = _commerceType[ii] .. " <PAColor0xFFFFCE22>▲" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
					commerceMsgforChat = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCEMSGFORCHAT_3", "characterKey", npcKey[varyTradeInfo._characterKey], "commerceType", _commerceType[ii], "percent", varyTradeInfo:getPercentByCommerceType(ii)/10000 ) -- npcKey[varyTradeInfo._characterKey] .. " 무역품 매각 시세 두 배 폭등 : " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
				elseif ( 0 > varyTradeInfo:getPercentByCommerceType(ii) ) then
					if nil == varyTradeInfo._characterKey or nil == varyTradeInfo:getPercentByCommerceType(ii) then	-- nil이 있을 수 있나?
						return
					end
					commerceMsg = _commerceType[ii] .. " <PAColor0xFFF26A6A>▼" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
					commerceMsgforChat = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCEMSGFORCHAT_4", "characterKey", npcKey[varyTradeInfo._characterKey], "commerceType", _commerceType[ii], "percent", varyTradeInfo:getPercentByCommerceType(ii)/10000 ) -- npcKey[varyTradeInfo._characterKey] .. " 무역품 매각 시세 두 배 폭등 : " .. _commerceType[ii] .. " <PAColor0xFFF26A6A>" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
				end
			else
				if ( 0 < varyTradeInfo:getPercentByCommerceType(ii) ) then
					commerceMsg = commerceMsg .. " | " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>▲" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
					commerceMsgforChat = commerceMsgforChat .. ", " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
				elseif ( 0 > varyTradeInfo:getPercentByCommerceType(ii) ) then
					commerceMsg = commerceMsg  .. " | " ..  _commerceType[ii] .. " <PAColor0xFFF26A6A>▼" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
					commerceMsgforChat = commerceMsgforChat  .. ", " ..  _commerceType[ii] .. " <PAColor0xFFF26A6A>" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
				end
			end
		end
		
		if 1 == varyTradeInfo._eventIndex then
			message = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_MESSAGE", "characterKey", npcKey[varyTradeInfo._characterKey] )
			msgName = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_MSGNAME")
		else
			local tradeMsgType = math.random(6)
			message = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEINFO_EVENTMESSAGE", "tradeMsgType", _tradeMsgType[tradeMsgType], "eventIndex", _commerceType[varyTradeInfo._eventIndex - 1] ) -- _tradeMsgType[tradeMsgType] .. "에서 " .. _commerceType[varyTradeInfo._eventIndex - 1] .. " " .. "무한 매입"
			
			-- 의류 및 원자재면 "~를".. 아니면 "~을".. 
			if 8 == varyTradeInfo._eventIndex or 10 == varyTradeInfo._eventIndex then
				msgName = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEINFO_MSGNAME1", "tradeMsgType", _tradeMsgType[tradeMsgType], "eventIndex", _commerceType[varyTradeInfo._eventIndex - 1] ) -- _tradeMsgType[tradeMsgType] .. "에서 " .. _commerceType[varyTradeInfo._eventIndex - 1] .. "를 비싼 값에 사들이고 있다."
			else
				msgName = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_TRADEINFO_MSGNAME1", "tradeMsgType", _tradeMsgType[tradeMsgType], "eventIndex", _commerceType[varyTradeInfo._eventIndex - 1] ) -- _tradeMsgType[tradeMsgType] .. "에서 " .. _commerceType[varyTradeInfo._eventIndex - 1] .. "을 비싼 값에 사들이고 있다."
			end
		end
		
		-- message = npcTradeEvent[varyTradeInfo._characterKey][varyTradeInfo._eventIndex] .. "(" .. npcKey[varyTradeInfo._characterKey] .. ")"
		-- msgName = npcTradeEvent[varyTradeInfo._characterKey][varyTradeInfo._eventIndex + 100]
		-- message = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_MESSAGE", "characterKey", npcKey[varyTradeInfo._characterKey] ) -- "대형 상단의 무역품 무한 매입" .. "(" .. npcKey[varyTradeInfo._characterKey] .. ")"
		-- msgName = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_MSGNAME") -- "정체를 알 수 없는 상단이 무역품을 비싼 값에 사들이고 있다"
		msgContent = commerceMsg
		
		local sandMsg = { main = message, sub = msgName, addMsg = msgContent }
		Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( sandMsg, 4, 6 )
		chatting_sendMessage( "", commerceMsgforChat, CppEnums.ChatType.System )
		tradeEvent = npcKey[varyTradeInfo._characterKey] .. " : " .. message .. "\n" .. msgContent
	end
end

function FGlobal_TradeEventInfo()
	return tradeEvent
end

function FGlobal_TradeEvent_Npckey_Return()
	return _npcKey
end

function FGlobal_FitnessLevelUp( addSp, addWeight, addHp, addMp, _type )	-- 단련 이벤트
	-- 힘이나 지구력 레벨업 시 사운드
	audioPostEvent_SystemUi(03,15)
	---------------------------------------------
	local playerWrapper = getSelfPlayer()
	local classType 	= playerWrapper:getClassType()
	local set_subString	= ""

	----------------------------------------------------------
	-- 				계산해서 수치를 보여준다!
	----------------------------------------------------------
	-- 스태미너를 계산해서 보여준다
	if ( 0 < addSp ) then
		set_subString = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_LvupStatus1", "AddSp", addSp, "GetMaxSp", getSelfPlayer():get():getStamina():getMaxSp() )
	end
	
	--무게를 계산해서 보여준다
	if ( 0 < addWeight ) then
		local comma = ", "
		if "" == set_subString then
			comma	= ""
		end
		set_subString = set_subString .. comma .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_LvupStatus2", "AddWeight", ( addWeight / 10000 ), "UserWeight", Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64()) / 10000 )
		FGlobal_UpdateInventorySlotData()
		FGlobal_MaxWeightChanged()
	end

	-- HP를 계산해서 보여준다
	if ( 0 < addHp ) then
		local comma = ", "
		if "" == set_subString then
			comma	= ""
		end
		set_subString = set_subString .. comma .. PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXHPUP").."<PAColor0xFFFFBD2E>+"..( addHp ).."<PAOldColor>"
	end

	-- MP를 계산해서 보여준다
	if ( 0 < addMp ) then
		local comma = ", "
		if "" == set_subString then
			comma	= ""
		end
		if ( classType == 0 ) then
			set_subString = set_subString .. comma .. PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXFPUP").."<PAColor0xFFFFBD2E>+"..( addMp ).."<PAOldColor>"
		elseif ( classType == 4 ) then
			set_subString = set_subString .. comma .. PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP").."<PAColor0xFFFFBD2E>+"..( addMp ).."<PAOldColor>"
		elseif ( classType == 8 ) then
			set_subString = set_subString .. comma .. PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP").."<PAColor0xFFFFBD2E>+"..( addMp ).."<PAOldColor>"
		elseif ( classType == 12 ) then
			set_subString = set_subString .. comma .. PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXFPUP").."<PAColor0xFFFFBD2E>+"..( addMp ).."<PAOldColor>"
		else
			-- 등록된 직업외에는 파이터게이지를 표시를 쓴다.
			set_subString = set_subString .. comma .. PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP").."<PAColor0xFFFFBD2E>+"..( addMp ).."<PAOldColor>"
		end
	end

	local mainTitle = ""
	if 0 == _type then
		mainTitle = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_DEX") -- "지구력 상승"
	elseif 1 == _type then
		mainTitle = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_STR") -- "힘 상승"
	elseif 2 == _type then
		mainTitle = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_CON") -- "건강 상승"
	end

	local message = { main = mainTitle, sub = set_subString, addMsg = "" }

	Proc_ShowMessage_Ack_For_RewardSelect( message, 3.5, 9 )
end

-- 애니메이션
local MessageOpen = function()
	local	axisX = Panel_RewardSelect_NakMessage:GetSizeX() / 2
	local 	axisY = Panel_RewardSelect_NakMessage:GetSizeY() / 2
	-- 켜기
	local aniInfo = Panel_RewardSelect_NakMessage:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	local aniInfo1 = Panel_RewardSelect_NakMessage:addScaleAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartScale(0.85)
	aniInfo1:SetEndScale(1.0)
	aniInfo1.AxisX = axisX
	aniInfo1.AxisY = axisY
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true

	-- 남아있고
	local aniInfo2 = Panel_RewardSelect_NakMessage:addScaleAnimation( 0.15, animationEndTime - 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = axisX
	aniInfo2.AxisY = axisY
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true

	-- 꺼준다
	local aniInfo3 = Panel_RewardSelect_NakMessage:addColorAnimation( animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo4 = Panel_RewardSelect_NakMessage:addScaleAnimation( animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo4:SetStartScale(1.0)
	aniInfo4:SetEndScale(0.7)
	aniInfo4.AxisX = axisX
	aniInfo4.AxisY = axisY
	aniInfo4.ScaleType = 2
	aniInfo4.IsChangeChild = true
end

local Boss_MessageOpen = function()
	local	axisX = Panel_RewardSelect_NakMessage:GetSizeX() / 2
	local 	axisY = Panel_RewardSelect_NakMessage:GetSizeY() / 2
	-- 켜기
	local aniInfo = Panel_RewardSelect_NakMessage:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	local aniInfo1 = Panel_RewardSelect_NakMessage:addScaleAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartScale(0.85)
	aniInfo1:SetEndScale(1.0)
	aniInfo1.AxisX = axisX
	aniInfo1.AxisY = axisY
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true

	-- 남아있고
	local aniInfo2 = Panel_RewardSelect_NakMessage:addScaleAnimation( 0.15, animationEndTime - 1.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = axisX
	aniInfo2.AxisY = axisY
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true

	-- 꺼준다
	local aniInfo3 = Panel_RewardSelect_NakMessage:addColorAnimation( animationEndTime - 1.25, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo4 = Panel_RewardSelect_NakMessage:addScaleAnimation( animationEndTime - 1.25, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo4:SetStartScale(1.0)
	aniInfo4:SetEndScale(0.2)
	aniInfo4.AxisX = axisX
	aniInfo4.AxisY = axisY
	aniInfo4.ScaleType = 2
	aniInfo4.IsChangeChild = true
end



local tempMsg = nil;

function NakMessageUpdate_For_RewardSelect( updateTime )	-- 각종 사운드, 이팩트 처리. 실제 메시지 뿌리는 곳.
	--if (isFlushedUI() and not passFlush) then	-- 대화창, 월드맵이면 나타내지 않는다. 다만 보상 선택은 예외.
	--	return
	--end

	if isLuaLoadingComplete then
		if Panel_Acquire:GetShow() then	-- 어콰이어면 열지 않는다.
			return
		end
	end
	
	-- 튜토리얼을 완료하지 않은 쪼렙은 메시지를 띄우지 않는다.
	if not TutorialQuestCompleteCheck() then
		return
	end
	
	if Panel_Tutorial:GetShow() then	-- 튜토리얼이면 나타내지 않는다.
		return
	end

	if Panel_IngameCashShop:GetShow() or Panel_Cash_Customization:GetShow() or Panel_Dye_New:GetShow() then	-- 펄상점이나, 뷰티샵, 염색창에서는 나타내지 않는다.
		return
	end
	
	elapsedTime = elapsedTime + updateTime;	-- 애니메이션 타임과 메모리용 타이머를 비교하기 위한 변수
	-- 메시지 시작 이후 2.3초가 되었을 경우
	
	if animationEndTime <= elapsedTime then
		if processIndex < curIndex then
			if ( messageType.defeatBoss == MessageData._Msg[processIndex+1].type ) then										-- 탑승물 피해시
				Boss_MessageOpen()
			else
				MessageOpen()													-- 나올 때 애니메이션 (2.3초)
			end
			processIndex = processIndex + 1
			-- Panel_RewardSelect_NakMessage:SetShow(true, false)
			NakMessagePanel_Resize_For_RewardSelect()

			_text_Msg			:SetFontColor(UI_color.C_FFFFEF82)	-- 기본 설정 값
			_text_MsgSub		:SetFontColor(UI_color.C_FFFFEF82)	-- 기본 설정 값
			_text_Msg			:SetSpanSize( 0, 15 )
			_text_MsgSub		:SetSpanSize( 0, 38 )

			bigNakMsg			:EraseAllEffect()
			localwarMsg			:EraseAllEffect()
			localwarMsgSmallBG	:EraseAllEffect()
			localwarMsg			:SetShow( false )	-- 붉은 전장 전용
			localwarMsgSmallBG	:SetShow( false )	-- 붉은 전장 전용
			localwarMsgBG		:SetShow( false )
			_text_localwarMsg	:SetShow( false )	-- 붉은 전장 전용

			-- 붉은전장 승리, 패배 메시지(나크BG 사이즈가 틀리기 때문에 별도 패널 구분을 위해서 조건을 걸었다!)
			if (messageType.localWarWin == MessageData._Msg[processIndex].type) or (messageType.localWarLose == MessageData._Msg[processIndex].type) then
				localwarMsg			:SetShow( true )
				localwarMsgSmallBG	:SetShow( false )
				localwarMsgBG		:SetShow( true )
				-- _text_localwarMsg	:SetShow( true )

				bigNakMsg			:SetShow( false )
				_text_Msg			:SetShow( true )
				_text_MsgSub		:SetShow( true )
				localwarMsg			:ChangeTextureInfoName( messageTexture[MessageData._Msg[processIndex].type] )
			elseif (messageType.localWarTurnAround == MessageData._Msg[processIndex].type) then
				bigNakMsg			:SetShow( false )
				localwarMsg			:SetShow( false )
				localwarMsgSmallBG	:SetShow( true )
				_text_localwarMsg	:SetShow( true )
				localwarMsgBG		:SetShow( false )
				_text_Msg			:SetShow( false )
				_text_MsgSub		:SetShow( false )
				localwarMsgSmallBG	:ChangeTextureInfoName( messageTexture[MessageData._Msg[processIndex].type] )
			elseif (messageType.localWarCriticalBlack == MessageData._Msg[processIndex].type) or (messageType.localWarCriticalRed == MessageData._Msg[processIndex].type) then
				localwarMsg			:SetShow( false )
				localwarMsgSmallBG	:SetShow( true )
				localwarMsgBG		:SetShow( false )
				_text_localwarMsg	:SetShow( true )

				bigNakMsg			:SetShow( false )
				_text_Msg			:SetShow( true )
				_text_MsgSub		:SetShow( true )
				localwarMsgSmallBG			:ChangeTextureInfoName( messageTexture[MessageData._Msg[processIndex].type] )
			else
				bigNakMsg			:SetShow( true )
				_text_Msg			:SetShow( true )
				_text_MsgSub		:SetShow( true )
				bigNakMsg			:ChangeTextureInfoName( messageTexture[MessageData._Msg[processIndex].type] )
			end

			_text_AddMsg	:SetShow( false )	-- 무역 이벤트용
			nakItemIconBG	:SetShow( false )
			nakItemIcon		:SetShow( false )
			for index = 1, 5 do
				huntingRanker[index]:SetShow( false )
			end

			if ( messageType.safetyArea == MessageData._Msg[processIndex].type ) then										-- 안전 지역
				_text_Msg				:SetFontColor(UI_color.C_ffdeff6d)
				_text_MsgSub			:SetFontColor(UI_color.C_ffdeff6d)
				audioPostEvent_SystemUi(08,01)	-- ♬ 시스템 메시지가 나올 때 사운드 추가

			elseif ( messageType.combatArea == MessageData._Msg[processIndex].type ) then									-- 전투 지역
				_text_Msg				:SetFontColor(UI_color.C_ffff8181)
				_text_MsgSub			:SetFontColor(UI_color.C_ffff8181)
				audioPostEvent_SystemUi(08,02)

			elseif ( messageType.desertArea == MessageData._Msg[processIndex].type ) then									-- 위험 지역
				_text_Msg				:SetFontColor(UI_color.C_ffff8181)
				_text_MsgSub			:SetFontColor(UI_color.C_ffff8181)
				audioPostEvent_SystemUi(08,02)
			

			elseif ( messageType.challengeComplete == MessageData._Msg[processIndex].type ) then							-- 도전과제 달성 메시지
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				audioPostEvent_SystemUi(08,01)

			elseif ( messageType.normal == MessageData._Msg[processIndex].type ) then										-- 빅나크 달성 메시지
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				audioPostEvent_SystemUi(08,01)

			elseif ( messageType.itemMarket == MessageData._Msg[processIndex].type ) then									-- 아이템 마켓.
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				audioPostEvent_SystemUi(08,01)

			elseif ( messageType.territoryTradeEvent == MessageData._Msg[processIndex].type ) then							-- 영지 무역 이벤트
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)

				_text_AddMsg			:SetFontColor(UI_color.C_FFFFEF82)
				_text_AddMsg			:SetShow( true )
				audioPostEvent_SystemUi(08,01)

			elseif ( messageType.npcTradeEvent == MessageData._Msg[processIndex].type ) then								-- NPC 무역 이벤트
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)

				_text_AddMsg			:SetFontColor(UI_color.C_FFFFEF82)
				_text_AddMsg			:SetShow( true )
				audioPostEvent_SystemUi(08,01)

			elseif ( messageType.royalTrade == MessageData._Msg[processIndex].type ) then									-- 황실 무역
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				audioPostEvent_SystemUi(08,01)

				bigNakMsg:AddEffect ( "UI_ImperialLight",	false,	0,	15 )
				bigNakMsg:AddEffect ( "fUI_ImperialStart",	false,	0,	-10 )

			elseif ( messageType.supplyTrade == MessageData._Msg[processIndex].type ) then									-- 황실 납품
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				audioPostEvent_SystemUi(08,01)

				bigNakMsg:AddEffect ( "UI_ImperialLight",	false,	0,	15 )
				bigNakMsg:AddEffect ( "fUI_ImperialStart",	false,	0,	-10 )

			elseif messageType.territoryWar_Start == MessageData._Msg[processIndex].type then
				bigNakMsg:AddEffect ( "UI_SiegeWarfare_Win_Green", false, -2, 0 )
				bigNakMsg:AddEffect ( "fui_skillawakenboom_green", false, -2, 0 )
				-- ♬ 점령전이 시작 될 때
				audioPostEvent_SystemUi(15,00)

			elseif messageType.territoryWar_End == MessageData._Msg[processIndex].type then
				bigNakMsg:AddEffect ( "UI_SiegeWarfare_Win", false, -2, 0 )
				bigNakMsg:AddEffect ( "fUI_SkillAwakenBoom", false, -2, 0 )
				-- ♬ 점령전이 종료 될 때
				audioPostEvent_SystemUi(15,04)

			elseif messageType.territoryWar_Add == MessageData._Msg[processIndex].type then
				bigNakMsg:AddEffect ( "UI_CastlePlusLight", false, 0, 0 )
				-- ♬ 난입 할 때
				audioPostEvent_SystemUi(15,01)

			elseif messageType.territoryWar_Destroy == MessageData._Msg[processIndex].type then
				bigNakMsg:EraseAllEffect()
				bigNakMsg:AddEffect ( "UI_CastleMinusLight", false, 0, 0 )
				-- ♬ 이탈 할 때
				audioPostEvent_SystemUi(15,02)

			elseif messageType.territoryWar_Attack == MessageData._Msg[processIndex].type then
				bigNakMsg:AddEffect ( "UI_SiegeWarfare_Alarm", true, 3, -22 )
				-- ♬ 내 성채가 맞을 때
				audioPostEvent_SystemUi(15,03)

			elseif messageType.guildWar_Start == MessageData._Msg[processIndex].type then
				bigNakMsg:AddEffect ( "UI_SiegeWarfare_Win_Red", false, 3, 0 )
				bigNakMsg:AddEffect ( "fui_skillawakenboom_red", false, 3, 0 )
				-- ♬ 길드전이 시작 될 때
				audioPostEvent_SystemUi(15,04)

			elseif messageType.guildWar_End == MessageData._Msg[processIndex].type then
				bigNakMsg:AddEffect ( "UI_SiegeWarfare_Win_Red", false, 3, 0 )
				bigNakMsg:AddEffect ( "fui_skillawakenboom_red", false, 3, 0 )
				-- ♬ 길드전이 종료 될 때
				audioPostEvent_SystemUi(15,04)

			elseif messageType.roulette == MessageData._Msg[processIndex].type then
				-- ♬ 가챠를 뽑을 때
				audioPostEvent_SystemUi(11,11)
				bigNakMsg:AddEffect ( "UI_Gacha_Message", false, 0.5, 0 )

			elseif messageType.anotherPlayerGotItem == MessageData._Msg[processIndex].type then							-- 다른 유저 아이템 획득
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				nakItemIconBG			:SetShow( false )
				nakItemIcon				:SetShow( true )
				nakItemIcon				:ChangeTextureInfoName( MessageData._Msg[processIndex].msg.addMsg )
				audioPostEvent_SystemUi(08,01)
			elseif messageType.enchantFail == MessageData._Msg[processIndex].type then
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				nakItemIconBG			:SetShow( false )
				nakItemIcon				:SetShow( true )
				nakItemIcon				:ChangeTextureInfoName( MessageData._Msg[processIndex].msg.addMsg)
			elseif messageType.alchemyStoneGrowUp == MessageData._Msg[processIndex].type then							-- 연금석 경험치업
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				nakItemIconBG			:SetShow( false )
				nakItemIcon				:SetShow( true )
				nakItemIcon				:ChangeTextureInfoName( MessageData._Msg[processIndex].msg.addMsg )
				audioPostEvent_SystemUi(08,01)
			elseif ( messageType.characterHPwarning == MessageData._Msg[processIndex].type ) then						-- HP 20% 미만 긴급회피
				_text_Msg				:SetFontColor(UI_color.C_ffff8181)
				_text_MsgSub			:SetFontColor(UI_color.C_ffff8181)
				audioPostEvent_SystemUi(08,15)
			elseif ( messageType.servantWarning == MessageData._Msg[processIndex].type ) then							-- 탑승물 피해시
				_text_Msg				:SetFontColor(UI_color.C_ffff8181)
				_text_MsgSub			:SetFontColor(UI_color.C_ffff8181)
				audioPostEvent_SystemUi(08,14)				
			elseif ( messageType.defeatBoss == MessageData._Msg[processIndex].type ) then								-- 보스에게 사망?
				_text_Msg				:SetFontColor(UI_color.C_ffff8181)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				bigNakMsg:AddEffect ( "UI_SiegeWarfare_Win_Red", false, 3, 0 )
				bigNakMsg:AddEffect ( "fui_skillawakenboom_red", false, 3, 0 )
				audioPostEvent_SystemUi(15,04)
			elseif ( messageType.whaleHide == MessageData._Msg[processIndex].type ) or ( messageType.huntingLandHide == MessageData._Msg[processIndex].type ) then	-- 고래 잡았을 때,
				_text_Msg				:SetFontColor(UI_color.C_ffff8181)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				local rankCount = getTemporaryInformationWrapper():getKillContributeCount()
				
				for index = 1, rankCount do
					huntingRanker[index]:SetShow( true )
				end				
				bigNakMsg:AddEffect ( "UI_SiegeWarfare_Win_Red", false, 3, 0 )
				bigNakMsg:AddEffect ( "fui_skillawakenboom_red", false, 3, 0 )
				audioPostEvent_SystemUi(15,04)
			elseif ( messageType.localWarJoin == MessageData._Msg[processIndex].type ) then								-- 붉은 전장 참여시
				bigNakMsg:EraseAllEffect()
				bigNakMsg:AddEffect ( "UI_LocalWar_Start01", false, 3, -1 )
				audioPostEvent_SystemUi(15,01)
	
			elseif ( messageType.localWarExit == MessageData._Msg[processIndex].type ) then								-- 붉은 전장 이탈시
				bigNakMsg:EraseAllEffect()
				-- bigNakMsg:AddEffect ( "UI_LocalWar_Start01", false, 3, -1 )
				audioPostEvent_SystemUi(15,02)

			elseif ( messageType.raceFail == MessageData._Msg[processIndex].type ) then
				audioPostEvent_SystemUi(17,03)

			elseif ( messageType.raceStart == MessageData._Msg[processIndex].type ) then
				audioPostEvent_SystemUi(17,00)
			elseif ( messageType.localWarWin == MessageData._Msg[processIndex].type ) then				-- 붉은 전장 승리
				localwarMsg:EraseAllEffect()
				localwarMsg:AddEffect ( "fUI_RedWar_Win01", false, 0, 195 )
				_text_Msg	:SetFontColor( UI_color.C_FF00FFFC )
				_text_MsgSub:SetFontColor( UI_color.C_FF00FFFC )
				_text_MsgSub:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_WIN") ) -- "승 리"
				audioPostEvent_SystemUi(18,00)	-- ♬ 승리
			elseif ( messageType.localWarLose == MessageData._Msg[processIndex].type ) then				-- 붉은 전장 패배
				localwarMsg:EraseAllEffect()
				localwarMsg:AddEffect ( "fUI_RedWar_Lose01", false, 0, 195 )
				_text_Msg	:SetFontColor( UI_color.C_FFD70000 )
				_text_MsgSub:SetFontColor( UI_color.C_FFD70000 )
				_text_localwarMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_LOSE") ) -- "패 배"
				audioPostEvent_SystemUi(18,01)	-- ♬ 패배
			elseif ( messageType.localWarTurnAround == MessageData._Msg[processIndex].type ) then		-- 붉은 전장 역전
				localwarMsgSmallBG:EraseAllEffect()
				localwarMsgSmallBG:AddEffect ( "fUI_RedWar_Turnaround01", false, 0, 6 )
				_text_localwarMsg:SetFontColor( UI_color.C_FFD70000 )
				_text_localwarMsg:SetText( MessageData._Msg[processIndex].msg.main ) -- 역전
				audioPostEvent_SystemUi(18,02)	-- ♬ 역전
			elseif ( messageType.localWarCriticalBlack == MessageData._Msg[processIndex].type ) then
				localwarMsgSmallBG:EraseAllEffect()
				localwarMsgSmallBG:AddEffect ( "fUI_RedWar_BlackScore01", false, 0, 0 )
				_text_localwarMsg:SetFontColor( UI_color.C_FFD29A04 )
				_text_Msg:SetFontColor( UI_color.C_FF74CB0E )
				_text_MsgSub:SetFontColor( UI_color.C_FFD29A04 )
				_text_localwarMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_CRITICALATTACK") ) -- 치명적인 타격!
			elseif ( messageType.localWarCriticalRed == MessageData._Msg[processIndex].type ) then
				localwarMsgSmallBG:EraseAllEffect()
				localwarMsgSmallBG:AddEffect ( "fUI_RedWar_RedScore01", false, 0, 0 )
				_text_localwarMsg:SetFontColor( UI_color.C_FFE50D0D )
				_text_Msg:SetFontColor( UI_color.C_FFD29A04 )
				_text_MsgSub:SetFontColor( UI_color.C_FFE50D0D )
				_text_localwarMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_CRITICALATTACK") ) -- 치명적인 타격!
			else															-- 기타
				_text_Msg				:SetFontColor(UI_color.C_FFFFEF82)
				_text_MsgSub			:SetFontColor(UI_color.C_FFFFEF82)
				audioPostEvent_SystemUi(08,01)
			end

			tempMsg = MessageData._Msg[processIndex].msg
			_text_Msg		:SetText( MessageData._Msg[processIndex].msg.main )
			_text_MsgSub	:SetText( MessageData._Msg[processIndex].msg.sub )

			if ( messageType.characterHPwarning == MessageData._Msg[processIndex].type ) then	-- HP 20% 미만 긴급회피
				_text_Msg		:SetSpanSize( _text_Msg:GetSpanSize().x, 15 )
				_text_MsgSub	:SetSpanSize( _text_MsgSub:GetSpanSize().x, 42 )
			elseif ( messageType.localWarWin == MessageData._Msg[processIndex].type ) or ( messageType.localWarLose == MessageData._Msg[processIndex].type ) then
				_text_Msg		:SetSpanSize( 0, -375 )
				_text_MsgSub	:SetSpanSize( 0, -350 )
			elseif ( messageType.localWarTurnAround == MessageData._Msg[processIndex].type ) then
				_text_Msg		:SetSpanSize( 0, 0 )
				_text_MsgSub	:SetSpanSize( 0, 25 )
				_text_localwarMsg:SetSpanSize( 0, 80 )
			elseif ( messageType.localWarCriticalBlack == MessageData._Msg[processIndex].type ) or ( messageType.localWarCriticalRed == MessageData._Msg[processIndex].type ) then
				_text_Msg		:SetSpanSize( 0, -15 )
				_text_MsgSub	:SetSpanSize( 0, -45 )
				_text_localwarMsg:SetSpanSize( 0, 70 )
			else
				if "" == MessageData._Msg[processIndex].msg.sub then																-- 단일 메세지일때
					_text_Msg		:SetSpanSize( _text_Msg:GetSpanSize().x, 25 )
					_text_MsgSub	:SetSpanSize( _text_MsgSub:GetSpanSize().x, 38 )
				else
					_text_Msg		:SetSpanSize( _text_Msg:GetSpanSize().x, 15 )
					_text_MsgSub	:SetSpanSize( _text_MsgSub:GetSpanSize().x, 38 )
				end
			end

			_text_Msg			:ComputePos()
			_text_MsgSub		:ComputePos()

			if messageType.territoryTradeEvent == MessageData._Msg[processIndex].type or messageType.npcTradeEvent == MessageData._Msg[processIndex].type then
				_text_AddMsg	:SetText( MessageData._Msg[processIndex].msg.addMsg )
			end

			MessageData._Msg[processIndex].msg	= nil				-- 메시지 인덱스 리셋
			MessageData._Msg[processIndex].type	= nil				-- 메시지 인덱스 리셋
			elapsedTime = 0.0												-- 처리 후 애니메이션 시간 리셋
			
		else
			Panel_RewardSelect_NakMessage:SetShow(false, false)				-- 기존에 남아있던 애 꺼주기
			_text_AddMsg	:SetShow( false )	-- 무역 이벤트용
			nakItemIconBG	:SetShow( false )
			nakItemIcon		:SetShow( false )

			curIndex		= 0
			processIndex	= 0
		end
	else
		NakMessagePanel_Resize_For_RewardSelect()
		if processIndex < curIndex then

			if ( tempMsg ==  MessageData._Msg[processIndex+1].msg ) then   -- 애니메이션이 동작 중 같은 메시지가 들어오는 것 삭제
				processIndex = processIndex  + 1		
				MessageData._Msg[processIndex].msg	= nil
				MessageData._Msg[processIndex].type	= nil
			end
		end
	end
end

function NakMessagePanel_Resize_For_RewardSelect()
	if Panel_LocalWar:GetShow() then
		Panel_RewardSelect_NakMessage:SetPosY( 50 )
	else
		Panel_RewardSelect_NakMessage:SetPosY( 30 )
	end
	
	Panel_RewardSelect_NakMessage:SetPosX( ( getScreenSizeX() - Panel_RewardSelect_NakMessage:GetSizeX() ) * 0.5 )

	-- localwarMsgBG		:SetSize( getScreenSizeX(), 174 )

	localwarMsg			:ComputePos()
	localwarMsgBG		:ComputePos()
	_text_localwarMsg	:ComputePos()
end

function FGlobal_NakMessagePanel_CheckLeftMessageCount()
	return curIndex
end

-- { flush가 끝나면 다시 실행}
	function check_LeftNakMessage()
		if processIndex < curIndex then
			Panel_RewardSelect_NakMessage:SetShow(true, false)
			NakMessagePanel_Resize_For_RewardSelect()
		end
	end
	UI.addRunPostFlushFunction( check_LeftNakMessage )
	UI.addRunPostRestorFunction( check_LeftNakMessage )
-- }

function FromClient_notifyGetItem(notifyType, playerName, fromName, iconPath, param1, itemStaticWrapper)
	-- notyfyType 0 : 드랍 아이템 주움, 1 : openBox, 2 : 강화 성공, 3 : 명마 획득 4: 강화 실패, 5 : 아이템 합성
	local message		= ""
	local subMessage	= ""
	local itemIcon		= nil
	local itemName		= ""
	local itemClassify	= nil
	if nil ~= itemStaticWrapper and itemStaticWrapper:isSet() then
		itemName		= itemStaticWrapper:getName()
		itemClassify	= itemStaticWrapper:getItemClassify()
		enchantLevel	= itemStaticWrapper:get()._key:getEnchantLevel()
	end
			for index = 1, 5 do
				huntingRanker[index]:SetShow( false )
			end
	if 0 == notifyType then
		message = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_COMMON_MSG", "playerName", playerName, "itemName", itemName ) -- "[" .. playerName .. "] 님이 [" .. itemName .. "] 획득"
		subMessage = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_GETITEM_SUBMSG", "fromName", fromName ) -- "몬스터 [" .. fromName .. "] 처치"
		itemIcon = "Icon/" .. itemStaticWrapper:getIconPath()
	elseif 1 == notifyType then
		message = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_COMMON_MSG", "playerName", playerName, "itemName", itemName ) -- "[" .. playerName .. "] 님이 [" .. itemName .. "] 획득"
		subMessage = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_OPENBOX_SUBMSG", "fromName", fromName ) -- "아이템 [" .. fromName .. "] 오픈"
		itemIcon = "Icon/" .. itemStaticWrapper:getIconPath()
	elseif 2 == notifyType then
		if nil ~= Int64toInt32(param1) and 0 ~= Int64toInt32(param1) then
			if 16 <= Int64toInt32(param1) then	-- 15강 이상일 때.
				-- local enchantString = ""
				-- if 16 == Int64toInt32(param1) then
				-- 	enchantString = "I"
				-- elseif 17 == Int64toInt32(param1) then
				-- 	enchantString = "II"
				-- elseif 18 == Int64toInt32(param1) then
				-- 	enchantString = "III"
				-- elseif 19 == Int64toInt32(param1) then
				-- 	enchantString = "IV"
				-- elseif 20 == Int64toInt32(param1) then
				-- 	enchantString = "V"
				-- -- elseif 20 == Int64toInt32(param1) then
				-- -- 	enchantString = "VI"
				-- end
				itemName = HighEnchantLevel_ReplaceString( Int64toInt32(param1) ) .. " " .. itemName
			else	-- 15강 미만일 때
				if 4 == itemClassify then
					itemName = HighEnchantLevel_ReplaceString( Int64toInt32(param1)+15 ) .. " " .. itemName
				else
					itemName = "+" .. Int64toInt32(param1) .. " " .. itemName
				end
			end
		end
		message = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_COMMON_MSG", "playerName", playerName, "itemName", itemName ) -- "[" .. playerName .. "] 님이 [" .. itemName .. "] 획득"
		subMessage = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_SUCCESSENCHANT_SUBMSG") -- "잠재력 돌파 성공"
		itemIcon = "Icon/" .. itemStaticWrapper:getIconPath()
	elseif 3 == notifyType then
		message = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_GOODHORSE_MSG", "playerName", playerName ) -- "[" .. playerName .. "] 님의 마구간에서 명마 탄생"
		subMessage = ""
		itemIcon = iconPath
	elseif 4 == notifyType then
		-- 말 장비 중 편자가 악세사리(벨트)와 equipType이 겹치기 때문에 말,펫장비 모두 리턴.
		if 11 == itemClassify then
			return
		end
		if 4 == itemClassify then
			itemName = HighEnchantLevel_ReplaceString( Int64toInt32(enchantLevel+1)+15 ) .. " " .. itemName
		else
			itemName = HighEnchantLevel_ReplaceString( Int64toInt32(enchantLevel+1) ) .. " " .. itemName
		end
		message		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_ENCHANTFAIL_MSG", "playerName", playerName, "itemName", itemName ) -- "[" .. playerName .. "] 님이 [" .. itemName .. "] 획득"
		subMessage	= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_ENCHANTENCHANT_SUBMSG") -- 잠재력 돌파 실패
		itemIcon	= "Icon/" .. itemStaticWrapper:getIconPath()
		-- param1이 -1면 아이템이 파괴된 것
		-- param1 18강에서 떨어지면 17로 옴.
		-- 악세는 2강에서 강화를 실패할 경우
		-- 장비는 고(18강)에서 강화를 실패할 경우
	elseif 5 == notifyType then
		message		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_COMMON_MSG", "playerName", playerName, "itemName", itemName )
		subMessage	= PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_ITEMCOMBINATION") -- 아이템 조합으로 획득 하였습니다.
		itemIcon	= "Icon/" .. itemStaticWrapper:getIconPath()
	end

	local msg = { main = message, sub = subMessage, addMsg = itemIcon }
	if 4 == notifyType then
		Proc_ShowMessage_Ack_For_RewardSelect( msg, 5.0, messageType.enchantFail )
	else
		Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, messageType.anotherPlayerGotItem )
	end
end

--[[ *************************** 메시지 처리 *************************** --]]
Panel_RewardSelect_NakMessage:RegisterUpdateFunc("NakMessageUpdate_For_RewardSelect")

function FromClient_notifyBroadcastLifeLevelUp( _notifyType, userNickName, characterName, _param1, _param2 )
	-- 명장달성 : _param2 = 생활 타입, _param1 = 레벨
	local lifeType_s32	= Int64toInt32(_param2)
	local lifeLevel_s32	= Int64toInt32(_param1)

	local lifeType		= FGlobal_CraftType_ReplaceName( lifeType_s32 )
	local lifeLev		= FGlobal_CraftLevel_Replace( lifeLevel_s32, lifeType_s32 )
	local message 		= userNickName .. "(" .. characterName .. ")"
	local subMessage 	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NOTIFY_LIFELEVEL_SUBMSG", "lifeType", lifeType, "lifeLev", lifeLev ) -- lifeType .." ".. lifeLev .. " 달성"
	local itemIcon 		= ""
	local msg = { main = message, sub = subMessage, addMsg = itemIcon }
	
	Proc_ShowMessage_Ack_For_RewardSelect( msg, 3.0, messageType.lifeLevUp )
end

function FromClient_EventDieInstanceMonster( bossName )
	local msg = { main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NAKMESSAGE_HUNTTINGBOSS_TITLE", "bossName", bossName ), sub = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NAKMESSAGE_HUNTTINGBOSS_SUBTITLE", "territoryName", selfPlayerCurrentTerritory() ), addMsg = "" }
	Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 6.0, messageType.defeatBoss )
end

function FromClient_NoticeChatMessageUpdate( _noticeSender, _noticeContent )
	local msg = { main = _noticeContent, sub = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NAKMESSAGE_GUILDNOTIFY_SENDER", "guildMasterName", _noticeSender ), addMsg = "" }
	Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect( msg, 3.5, messageType.guildNotify )
end

function FromClient_ArrestAToB( attacker, attackee )
	-- attacker : 죽인사람
	-- attackee : 죽은사람(카오)
	local msg = { main = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_DESERTCHAOKILL_MSG_MAIN", "attacker", attacker, "attackee", attackee ), sub = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_DESERTCHAOKILL_MSG_SUB"), addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( msg, 5.0, messageType.playerKiller )
end

registerEvent( "FromClient_NotifyVariableTradeItemMsg", 		"FromClient_NotifyVariableTradeItemMsg" )				-- 무역품 시세 변화
registerEvent( "FromClient_notifyBroadcastLifeLevelUp", 		"FromClient_notifyBroadcastLifeLevelUp" )				-- 생활 레벨 50 이상 글로벌 메시지
registerEvent( "FromClient_notifyGetItem",						"FromClient_notifyGetItem")								-- 아이템 획득 or 강화 성공
registerEvent( "EventDieInstanceMonster",						"FromClient_EventDieInstanceMonster" )
registerEvent( "FromClient_NoticeChatMessageUpdate",			"FromClient_NoticeChatMessageUpdate" )					-- 길드 공지 메시지
registerEvent( "FromClient_ArrestAToB",							"FromClient_ArrestAToB" )								-- 사막 카오 감옥 이동 메시지

registerEvent( "onScreenResize",						"NakMessagePanel_Resize_For_RewardSelect" )
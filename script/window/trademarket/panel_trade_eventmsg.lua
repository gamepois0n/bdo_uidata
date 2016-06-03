Panel_Trade_EventMsg_Territory:RegisterShowEventFunc( true, 'Panel_Trade_EventMsg_TerritoryShowAni()' )
Panel_Trade_EventMsg_Territory:RegisterShowEventFunc( false, 'Panel_Trade_EventMsg_TerritoryHideAni()' )

Panel_Trade_EventMsg_Npc:RegisterShowEventFunc( true, 'Panel_Trade_EventMsg_NpcShowAni()' )
Panel_Trade_EventMsg_Npc:RegisterShowEventFunc( false, 'Panel_Trade_EventMsg_NpcHideAni()' )

function  Panel_Trade_EventMsg_TerritoryShowAni()
end
function Panel_Trade_EventMsg_TerritoryHideAni()
end
function  Panel_Trade_EventMsg_NpcShowAni()
end
function Panel_Trade_EventMsg_NpcHideAni()
end
Panel_Trade_EventMsg_Territory:SetShow( false )					-- 무역 이벤트 영지용
Panel_Trade_EventMsg_Npc:SetShow( false )						-- 무역 이벤트 npc용

--[[ 순서 :   --]]
local MessageData =
{
	_Msg = {},					-- 메시지 인덱스 저장
	_msgName = {},
	_msgContent = {}
}

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local curIndex 			= 0									-- 세이브 인덱스
local processIndex 		= 0									-- 처리 인덱스
local animationEndTime 	= 6.0								-- 플레이 타임
local elapsedTime 		= 7.0								-- 메모리용 타이머

local _textTerritory_Msg		= UI.getChildControl( Panel_Trade_EventMsg_Territory, "StaticText_Trade_EventMsg_Territory_Message" )
local _textTerritoryDesc		= UI.getChildControl( Panel_Trade_EventMsg_Territory, "StaticText_Trade_EventMsg_Desc" )
local _textTerritoryCommerce	= UI.getChildControl( Panel_Trade_EventMsg_Territory, "StaticText_CommerceType" )

local _textNpc_Msg				= UI.getChildControl( Panel_Trade_EventMsg_Npc, "StaticText_Trade_EventMsg_Npc_Message" )
local _textDesc					= UI.getChildControl( Panel_Trade_EventMsg_Npc, "StaticText_Trade_EventMsg_Desc" )
local _textCommerce				= UI.getChildControl( Panel_Trade_EventMsg_Npc, "StaticText_CommerceType" )



-- 영지별 이벤트 데이터
local _territoryName =
{
	[0]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_AREANAME_BALENOS"), -- 발레노스 영지
	[1]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_AREANAME_SERENDIA"), -- 세렌디아 영지
	[2]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_AREANAME_CALPHEON"), -- 칼페온 영지
	[3]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_AREANAME_MEDIA"), -- 메디아 영지
}

local tradeTerritoryKey = {}

tradeTerritoryKey[0] = {
	[1]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT1"), -- 전염병 창궐"
	[2]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT2"), -- 새로운 약초의 발견"
	[3]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT3"), -- 흉작"
	[4]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT4"), -- 풍작"
	[5]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT5"), -- 치어 방류"
	[6]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT6"), -- 상어 출몰"
	[7]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT7"), -- 메디아 폐잔병들의 유입"
	[8]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT8"), -- 큰 도시로 향하는 모험가들"
	[9]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT9"), -- 광산 광맥 고갈"
	[10]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT10"), -- 새로운 광맥 발견"
	[101]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT11"), -- 발레노스에 전염병이 창궐하여 많은 영지민들이 고통을 겪고 있다고 한다."
	[102]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT12"), -- 발레노스에 특정 병에 효과가 좋은 약초가 발견되어 영지민들의 병이 많이 치료되었다고 한다."
	[103]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT13"), -- 발레노스 영지에 흉작이 발생하여 식량 부족 현상이 발생했다고 한다."
	[104]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT14"), -- 발레노스 영지에 풍작이 발생하여 식량이 풍족해졌다고 한다."
	[105]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT15"), -- 발레노스만에 치어를 대량 방류 하여 어자원 증가가 기대된다고 한다."
	[106]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT16"), -- 발레노스만에 대량의 상어가 출몰하여 어획량에 영향을 끼친다고 한다."
	[107]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT17"), -- 발레노스에 메디아 폐잔병들이 유입되어 일시적으로 인구가 증가했다고 한다."
	[108]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT18"), -- 발레노스에 모험가들이 큰도시로 모험을 떠나 일시적으로 인구가 감소했다고 한다."
	[109]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT19"), -- 발레노스 산맥의 광산이 고갈되어 원자재 수급에 문제가 생겼다고 한다."
	[110]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY1_TEXT20"), -- 발레노스 산맥에 새로운 광산이 발견되어 원자재의 대량 공급이 예상된다고 한다."
}

tradeTerritoryKey[1] = {
	[1]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT1"), -- 조드라인의 전쟁 결심 소문
	[2]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT2"), -- 조르다인의 결심은 헛소문
	[3]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT3"), -- 인근 몬스터 퇴치
	[4]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT4"), -- 산적 출몰
	[5]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT5"), -- 옷감 부족
	[6]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT6"), -- 옷감 대량 생산
	[7]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT7"), -- 흉작
	[8]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT8"), -- 풍작
	[9]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT9"), -- 하이델 북부 채석장의 채굴량 감소
	[10]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT10"), -- 하이델 북부 채석장의 채굴량 증가
	[101]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT11"), -- 세렌디아의 실세인 조르다인이 전쟁을 결심했다는 소문이 돌며 영지민들이 불안에 떨고있다고 한다.
	[102]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT12"), -- "세렌디아의 실세인 조르다인의 전쟁 결심이 근거 없는 소문이라고 하여 영지민들이 안심했다고 한다.
	[103]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT13"), -- "세렌디아 인근의 괴물들이 대거 퇴치되어 세렌디아가 좀 더 살기 좋게 변했다는 소문이 돌고 있다.
	[104]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT14"), -- "세렌디아 인근에 산적들이 자주 출몰하여 영지민들의 두려움에 떨고 있다고 한다."
	[105]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT15"), -- "세렌디아의 옷감에 들어가는 재료의 생산이 감소하여 옷감이 부족한 현상이 있다고 한다."
	[106]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT16"), -- "세렌디아의 옷감에 들어가는 재료의 생산이 증가하여 옷감이 풍족해졌다고 한다."
	[107]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT17"), -- "세렌디아 영지에 흉작이 발생하여 식량 부족 현상이 발생했다고 한다."
	[108]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT18"), -- "세렌디아 영지에 풍작이 발생하여 식량이 풍족해졌다고 한다."
	[109]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT19"), -- "세렌디아 영지의 하이델 북부 채석장의 채굴량이 감소하여 원자재 생산에 어려움을 겪고 있다고 한다."
	[110]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY2_TEXT20"), -- "세렌디아 영지의 하이델 북부 채석장의 채굴량이 증가하여 원자재의 대량 유입이 예상된다고 한다."
}

tradeTerritoryKey[2] = {
	[1]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT1"), -- "귀족 파티 유행"
	[2]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT2"), -- "어느 부자의 재산 환원"
	[3]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT3"), -- "흉작"
	[4]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT4"), -- "풍작"
	[5]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT5"), -- "시위대 증가"
	[6]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT6"), -- "시위대 진압"
	[7]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT7"), -- "무기 대량 생산에 의한 수질 오염"
	[8]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT8"), -- "수질 개선용 이끼 대량 방류"
	[9]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT9"), -- "수도로 몰린 사람들"
	[10]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT10"), -- "주민들의 귀농 유행"
	[101]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT11"), -- "칼페온 귀족들 사이에서 파티가 유행하기 시작했다고 한다."
	[102]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT12"), -- "칼페온 어떤 부자가 자신이 가진 모든 사치품을 영지민들에게 환원하여 영지민들의 살림이 좋아졌다고 한다."
	[103]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT13"), -- "칼페온 영지에 흉작이 발생하여 식량 부족 현상이 발생했다고 한다."
	[104]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT14"), -- "칼페온 영지에 풍작이 발생하여 식량이 풍족해졌다고 한다."
	[105]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT15"), -- "칼페온 시위대의 규모가 커져 대모에 필요한 물건들의 수요가 늘었다고 한다."
	[106]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT16"), -- "칼페온 시위대가 대규모로 진압되어 당분간 대모는 없을 것으로 예상된다고 한다."
	[107]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT17"), -- "칼페온 군대에서 무기를 대량으로 생산하여 인근 수질이 오염됐다는 소문이 돌고 있다."
	[108]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT18"), -- "칼페온 인근 수질을 개선하기 수질 개선용 이끼를 대량으로 지하수를 대량으로 방류 했다고 한다."
	[109]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT19"), -- "칼페온 수도로 사람들의 이주가 많아지면서 인구가 들어나고있다는 소식이 들린다."
	[110]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY3_TEXT20"), -- "칼페온 주민들 사이에서 귀농이 유행하여 많은 사람들이 수도를 떠나간다고 한다."
}

tradeTerritoryKey[3] = {
	[1]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT1"), -- "알토노바 무역 활성화"
	[2]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT2"), -- "메디아를 떠나는 사람들"
	[3]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT3"), -- "식량 수입 감소"
	[4]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT4"), -- "식량 수입 증가"
	[5]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT5"), -- "먼지 덮힌 약초"
	[6]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT6"), -- "바다 건너온 약품"
	[7]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT7"), -- "사막 원정 군대 모집"
	[8]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT8"), -- "사막 괴물의 소문"
	[9]		=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT9"), -- "거대한 모래 바람"
	[10]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT10"), -- "뜨거운 태양볕"
	[101]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT11"), -- "메디아 영지에 수도인 알티노바를 통한 무역이 활발해지면서 메디아를 찾는 사람들이 늘어났다고 한다."
	[102]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT12"), -- "메디아 척박한 기후를 못 이기고 많은 영지민이 떠나간다고 한다."
	[103]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT13"), -- "메디아 식량 수입량이 정치적인 문제로 인해 감소했다고 한다."
	[104]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT14"), -- "메디아 식량 수입량이 대규모 무역으로 기존보다 증가했다고 한다."
	[105]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT15"), -- "메디아의 흙먼지 바람이 대규모 약초 저장고를 덮어 해당 창고의 약초가 모두 못 쓰게 되었다고 한다."
	[106]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT16"), -- "메디아에 다른 영지의 대형 약품 상단이 오게 되어 약품이 대규모로 시중에 나왔다고 한다."
	[107]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT17"), -- "메디아에 사막에 원정을 가기 위해 모인 대규모 군대가 주둔하기 시작했다는 소문이 돌고 있다."
	[108]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT18"), -- "메디아에 사막의 거대한 괴물의 소문이 돌면서 사막 원정을 포기하고 돌아가는 모험가들이 늘고 있다고 한다."
	[109]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT19"), -- "메디아 전역에 강력한 모래바람이 불어닥쳐 많은 이들이 메디아를 떠나가고 있다고 한다."
	[110]	=	PAGetString(Defines.StringSheet_GAME, "LUA_TRADE_EVENTMSG_TERRITORYKEY4_TEXT20"), -- "메디아 전역에 바람 없는 건조한 날씨가 지속되어 모래바람에 대한 공포가 사그라졌다고 한다."
}

local npcKey =
{
		[40715] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1"), -- 올비아 마을
		[40026] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2"), -- 로기아 농장
		[40025] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3"), -- 바탈리 농장
		[40024] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4"), -- 핀토 농장
		[40031] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5"), -- 델루치 농장
		[40101] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6"), -- 마리노 농장
		[40609] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7"), -- 일리야 섬
		[40028] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8"), -- 서부 캠프
		[40010] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9"), -- 벨리아
		[41090] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10"), -- 글리시 마을
		[41223] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11"), -- 중앙 캠프
		[41221] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12"), -- 남부 캠프
		[41085] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13"), -- 모레티 거대 농장
		[41032] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14"), -- 엘다 농장
		[41030] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15"), -- 알레한드로 농장
		[41045] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16"), -- 코스타 농장
		[41222] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17"), -- 동부관문
		[41225] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18"), -- 서남부 관문
		[41224] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19"), -- 서북부 관문
		[41051] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20"), -- 하이델 
		[42301] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21"), -- 에페리아 항구 마을
		[42205] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22"), -- 플로린 마을
		[43433] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23"), -- 델페 기사단 성
		[50411] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24"), -- 고립된 초소
		[50415] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25"), -- 코헨 농장
		[50403] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26"), -- 트롤 방어 기지
		[43449] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27"), -- 베르니안토 농장
		[43440] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28"), -- 북부 밀 농장
		[43446] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29"), -- 오염된 농장지
		[43448] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30"), -- 디아스 농장
		[43510] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31"), -- 델페 전진 기지
		[42026] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32"), -- 칼페온 신성 대학
		[43010] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33"), -- 케플란
		[43210] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34"), -- 트리나 요새
		[50428] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35"), -- 팔르스 소농장
		[50432] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36"), -- 오베렌 농장
		[50430] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37"), -- 바인 농장지
		[50433] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38"), -- 봉화대 입구 초소
		[50418] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39"), -- 칼페온 평원
		[50440] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40"), -- 채굴장 사잇길
		[50434] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41"), -- 폐채굴장
		[50437] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42"), -- 지아닌 농장
		[50438] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43"), -- 폐쇄된 서부 관문
		[50443] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44"), -- 데인 협곡
		[43310] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45"), -- 트렌트 마을
		[43402] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46"), -- 베어 마을
		[50456] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47"), -- 가비노 농장
		[43501] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48"), -- 북 카이아 나루
		[50455] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49"), -- 남 카이아 나루
		[50451] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50"), -- 루툼 감시 초소
		[50459] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51"), -- 만샤 숲
		[42103] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52"), -- 버려진 수도원
		[50466] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53"), -- 포니엘 산장
		[50461] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54"), -- 토바레 오두막
		[43407] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55"), -- 크리오 마을
		[42013] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56"), -- 칼페온 시장 거리
		[42005] = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57"), -- 칼페온 빈민가
}

local npcTradeEvent = {}

npcTradeEvent[40715] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_2"), -- 대량의 식량 수급
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_34"), -- 식량이 대량으로 생산 또는 수입되어 식료품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40030] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_2"), -- 대량의 식량 수급
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_34"), -- 식량이 대량으로 생산 또는 수입되어 식료품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_ETC_TOWN_1") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40026] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_2"), -- 대량의 식량 수급
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_34"), -- 식량이 대량으로 생산 또는 수입되어 식료품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY2") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40025] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY3") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40024] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY4") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40031] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY5") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40101] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_17"), -- 잡화 수출 외교 문제 발생
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_49"), -- 외교문제로 수출 계약이 결렬돼 잡화 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY6") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40609] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_18"), -- 인근 주민의 수입 감소
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_50"), -- 최근 인근 주민의 수입이 줄어 사치품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY7") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40028] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY8") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[40010] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY9") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41090] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY10") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41223] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_20"), -- 사라진 괴물들
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_52"), -- 최근 괴물의 위협이 사그라지면서 군수품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY11") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41221] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY12") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41085] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_2"), -- 대량의 식량 수급
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_34"), -- 식량이 대량으로 생산 또는 수입되어 식료품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY13") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41032] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_17"), -- 잡화 수출 외교 문제 발생
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_49"), -- 외교문제로 수출 계약이 결렬돼 잡화 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY14") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41030] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_2"), -- 대량의 식량 수급
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_34"), -- 식량이 대량으로 생산 또는 수입되어 식료품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY15") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41045] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_17"), -- 잡화 수출 외교 문제 발생
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_49"), -- 외교문제로 수출 계약이 결렬돼 잡화 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY16") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41222] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_17"), -- 잡화 수출 외교 문제 발생
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_49"), -- 외교문제로 수출 계약이 결렬돼 잡화 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY17") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41225] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_20"), -- 사라진 괴물들
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_52"), -- 최근 괴물의 위협이 사그라지면서 군수품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY18") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41224] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_20"), -- 사라진 괴물들
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_52"), -- 최근 괴물의 위협이 사그라지면서 군수품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY19") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[41051] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_17"), -- 잡화 수출 외교 문제 발생
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_49"), -- 외교문제로 수출 계약이 결렬돼 잡화 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY20") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[42301] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_2"), -- 대량의 식량 수급
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_34"), -- 식량이 대량으로 생산 또는 수입되어 식료품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY21") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[42205] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_2"), -- 대량의 식량 수급
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_34"), -- 식량이 대량으로 생산 또는 수입되어 식료품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY22") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43433] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY23") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50411] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY24") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50415] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY25") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50403] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY26") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43449] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY27") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43440] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY28") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43446] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY29") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43448] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY30") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43510] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY31") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[42026] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY32") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43010] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_2"), -- 대량의 식량 수급
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_34"), -- 식량이 대량으로 생산 또는 수입되어 식료품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY33") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43210] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_20"), -- 사라진 괴물들
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_52"), -- 최근 괴물의 위협이 사그라지면서 군수품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY34") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50428] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY35") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50432] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY36") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50430] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY37") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50433] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY38") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50418] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY39") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50440] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY40") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50434] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY41") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50437] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY42") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50438] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY43") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50443] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY44") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43310] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_20"), -- 사라진 괴물들
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_52"), -- 최근 괴물의 위협이 사그라지면서 군수품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY45") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43402] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY46") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50456] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY47") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43501] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY48") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50455] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY49") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50451] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_20"), -- 사라진 괴물들
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_52"), -- 최근 괴물의 위협이 사그라지면서 군수품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY50") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50459] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY51") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[42103] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY52") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50466] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY53") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[50461] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_19"), -- 사라진 전염병
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_51"), -- 최근 전염병이 잠잠해지며 약품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY54") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[43407] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY55") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[42013] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_14"), -- 원자재 생산/수입량의 증가
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_46"), -- 최근 생산/수입된 원자재의 양이 증가하여 원자재 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY56") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}
npcTradeEvent[42005] = 
{
 [1]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_16"), -- 황실의 물자 지원
 [2]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_20"), -- 사라진 괴물들
 [3]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_3"), -- 황실 특별 세금 납부
 [4]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_4"), -- 대형 상단의 잡화 매수
 [5]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_5"), -- 여행자 증가
 [6]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_6"), -- 이상 기후로 인한 식량 부족 현상
 [7]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_7"), -- 날뛰는 괴물들
 [8]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_8"), -- 철저한 방어 준비
 [9]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_9"), -- 극심한 한파 소문
 [10]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_10"), -- 지역 보수 지원금 지급
 [101]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_48"), -- 황실의 물자 지원으로 풍족해져 모든 물건의 가격이 내려갔다고 한다
 [102]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_52"), -- 최근 괴물의 위협이 사그라지면서 군수품 가격이 내려갔다고 한다
 [103]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_35"), -- 황실에서 특별 세금을 징수하여 모든 물건의 가격이 올랐다고 한다
 [104]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_36"), -- 거대 상단의 매수로 잡화의 가격이 올랐다고 한다
 [105]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_37"), -- 해당 지역에 여행객이 늘어 사치품 구매량이 늘었다고 한다
 [106]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_38"), -- 일시적인 이상 기후로 식량의 생산량과 수입량이 감소했다고 한다
 [107]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_39"), -- 괴물들이 더 흉포해져 약품의 수요가 늘었다고 한다
 [108]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_40"), -- 최근 괴물의 수가 늘고 있어 군수품을 비축한다는 소식이다
 [109]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_41"), -- 극심한 한파가 온다는 소문이 돌고 있다고 한다
 [110]  = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCKEY57") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_NPCTRADEEVENT_COMMON_42"), -- 시설 보수를 위해 황실에서 지원금을 지급한다고 한다
}


local _commerceType = {
	[1]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_1"), -- 잡화
	[2]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_2"), -- 사치품
	[3]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_3"), -- 식료품
	[4]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_4"), -- 약품
	[5]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_5"), -- 군수품
	[6]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_6"), -- 성물
	[7]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_7"), -- 의류
	[8]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_8"), -- 어패류
	[9]		= PAGetString(Defines.StringSheet_GAME, "LUA_REWARDSELECT_NAKMESSAGE_COMMERCETYPE_9"), -- 원자재
}

local isTerritoryEvent = false
-- function FromClient_NotifyVariableTradeItemMsg( territoryKey, npcCharacterKey, eventIndex )
-- 	local temporaryWrapper = getTemporaryInformationWrapper()
-- 	local varyTradeInfo = temporaryWrapper:getVaryTradeItemInfo( territoryKey, npcCharacterKey, eventIndex )
	
-- 	if nil == varyTradeInfo then
-- 		return
-- 	end

-- 	--_PA_LOG( "이문종", "varyTradeInfo._eventIndex : " .. tostring( varyTradeInfo._eventIndex) .. " / varyTradeInfo._territoryKey : " .. varyTradeInfo._territoryKey .. " / _characterKey : " .. varyTradeInfo._characterKey )
-- 	if ( -1 < varyTradeInfo._territoryKey ) then
-- 		isTerritoryEvent = true
-- 	elseif ( 0 < varyTradeInfo._characterKey ) then
-- 		isTerritoryEvent = false
-- 	--else
-- 		-- 전역 이벤트
-- 	end

-- 	local commerceMsg = ""
-- 	local commerceMsgforChat = ""
-- 	local message = ""
-- 	if ( true == isTerritoryEvent ) then
-- 		for ii = 1, enCommerceType.enCommerceType_Max -1 do
-- 			if ( "" == commerceMsg ) then
-- 				if ( 0 < varyTradeInfo:getPercentByCommerceType(ii) ) then
-- 					commerceMsg = _territoryName[varyTradeInfo._territoryKey] .. " : " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>▲" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 					commerceMsgforChat = _territoryName[varyTradeInfo._territoryKey] .. " 무역품 시세 변동 : " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>+" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 				elseif ( 0 > varyTradeInfo:getPercentByCommerceType(ii) ) then
-- 					commerceMsg = _territoryName[varyTradeInfo._territoryKey] .. " : " .. _commerceType[ii] .. " <PAColor0xFFF26A6A>▼" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 					commerceMsgforChat = _territoryName[varyTradeInfo._territoryKey] .. " 무역품 시세 변동 : " .. _commerceType[ii] .. " <PAColor0xFFF26A6A>" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 				end
-- 			else
-- 				if ( 0 < varyTradeInfo:getPercentByCommerceType(ii) ) then
-- 					commerceMsg = commerceMsg .. " | " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>▲" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 					commerceMsgforChat = commerceMsgforChat .. ", " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>+" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 				elseif ( 0 > varyTradeInfo:getPercentByCommerceType(ii) ) then
-- 					commerceMsg = commerceMsg  .. " | " ..  _commerceType[ii] .. " <PAColor0xFFF26A6A>▼" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 					commerceMsgforChat = commerceMsgforChat  .. ", " ..  _commerceType[ii] .. " <PAColor0xFFF26A6A>" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 				end
-- 			end
-- 		end
	
-- 		message = _territoryName[varyTradeInfo._territoryKey] .. "에서 이벤트 발생! [" ..  tradeTerritoryKey[varyTradeInfo._territoryKey][varyTradeInfo._eventIndex] .. "]"
-- 		msgName = tradeTerritoryKey[varyTradeInfo._territoryKey][varyTradeInfo._eventIndex + 100]
-- 		msgContent = commerceMsg
		
-- 	else
-- 		for ii = 1, enCommerceType.enCommerceType_Max -1 do
-- 			if ( "" == commerceMsg ) then
-- 				if ( 0 < varyTradeInfo:getPercentByCommerceType(ii) ) then
-- 					commerceMsg = npcKey[varyTradeInfo._characterKey] .. " : " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>▲" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 					commerceMsgforChat = npcKey[varyTradeInfo._characterKey] .. " 무역품 시세 변동 : " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>+" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 				elseif ( 0 > varyTradeInfo:getPercentByCommerceType(ii) ) then
-- 					commerceMsg = npcKey[varyTradeInfo._characterKey] .. " : " .. _commerceType[ii] .. " <PAColor0xFFF26A6A>▼" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 					commerceMsgforChat = npcKey[varyTradeInfo._characterKey] .. " 무역품 시세 변동 : " .. _commerceType[ii] .. " <PAColor0xFFF26A6A>" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 				end
-- 			else
-- 				if ( 0 < varyTradeInfo:getPercentByCommerceType(ii) ) then
-- 					commerceMsg = commerceMsg .. " | " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>▲" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 					commerceMsgforChat = commerceMsgforChat .. ", " .. _commerceType[ii] .. " <PAColor0xFFFFCE22>+" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 				elseif ( 0 > varyTradeInfo:getPercentByCommerceType(ii) ) then
-- 					commerceMsg = commerceMsg  .. " | " ..  _commerceType[ii] .. " <PAColor0xFFF26A6A>▼" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 					commerceMsgforChat = commerceMsgforChat  .. ", " ..  _commerceType[ii] .. " <PAColor0xFFF26A6A>" .. varyTradeInfo:getPercentByCommerceType(ii)/10000 .. "<PAOldColor>%"
-- 				end
-- 			end
-- 		end

-- 		message = npcKey[varyTradeInfo._characterKey] .. "에서 이벤트 발생! [" .. npcTradeEvent[varyTradeInfo._characterKey][varyTradeInfo._eventIndex] .. "]"
-- 		msgName = npcTradeEvent[varyTradeInfo._characterKey][varyTradeInfo._eventIndex + 100]
-- 		msgContent = commerceMsg
-- 	end
	
-- 	Trade_EventMsg_ShowMessage_Ack( message, msgName, msgContent )
	
-- 	chatting_sendMessage( "", commerceMsgforChat, CppEnums.ChatType.System )
-- end

function Trade_EventMsg_ShowMessage_Ack( message, msgName, msgContent )
	Trade_EventMsg_ShowMessage_Ack_WithOut_ChattingMessage( message, msgName, msgContent )
	chatting_sendMessage( "", message , CppEnums.ChatType.System )
end

function Trade_EventMsg_ShowMessage_Ack_WithOut_ChattingMessage( message, msgName, msgContent )
	curIndex = curIndex + 1
	MessageData._Msg[curIndex] = message
	MessageData._msgName[curIndex] = msgName
	MessageData._msgContent[curIndex] = msgContent
	if IsTerritoryEvent() then
		Panel_Trade_EventMsg_Territory:SetShow(true, true)
	else
		Panel_Trade_EventMsg_Npc:SetShow(true, true)
	end
end

-- 애니메이션
local MessageOpen = function( panel )
	-- 켜기
	local aniInfo = panel:addColorAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	local aniInfo1 = panel:addScaleAnimation( 0.5, 0.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.0)
	aniInfo1.AxisX = panel:GetSizeX() / 2
	aniInfo1.AxisY = panel:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true

	-- 남아있고
	local aniInfo2 = panel:addScaleAnimation( 0.15, 5.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
	aniInfo2:SetStartScale(1.0)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.IsChangeChild = true

	-- 꺼준다
	local aniInfo3 = panel:addColorAnimation( 5.0, 6.0, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true

	local aniInfo4 = panel:addScaleAnimation( 5.5, 5.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo4:SetStartScale(1.0)
	aniInfo4:SetEndScale(1.0)
	aniInfo4.AxisX = panel:GetSizeX() / 2
	aniInfo4.AxisY = panel:GetSizeY() / 2
	aniInfo4.ScaleType = 2
	aniInfo4.IsChangeChild = true
end

local tempMsg = nil;
function Trade_Event_MessageUpdate(updateTime)
	elapsedTime = elapsedTime + updateTime;					-- 애니메이션 타임과 메모리용 타이머를 비교하기 위한 변수

	-- 메시지 들어오자마자
	if elapsedTime >= animationEndTime then
		if processIndex < curIndex then
			-- ♬ 시스템 메시지가 나올 때 사운드 추가
			-- audioPostEvent_SystemUi(08,01)
			if IsTerritoryEvent() then
				panel = Panel_Trade_EventMsg_Territory
			else
				panel = Panel_Trade_EventMsg_Npc
			end
			MessageOpen( panel )
			processIndex = processIndex  + 1
			panel:SetShow(false, true)				-- 소리 재생을 위해 껐다 켜준다!
			panel:SetShow(true, true)
			tempMsg = MessageData._Msg[processIndex]
			if IsTerritoryEvent() then
				_textTerritory_Msg:SetText( MessageData._Msg[processIndex] )
				_textTerritoryDesc:SetText( MessageData._msgName[processIndex] )
				_textTerritoryCommerce:SetText( MessageData._msgContent[processIndex] )
			else
				_textNpc_Msg:SetText ( MessageData._Msg[processIndex] )
				_textDesc:SetText( MessageData._msgName[processIndex] )
				_textCommerce:SetText( MessageData._msgContent[processIndex] )
			end
			
			MessageData._Msg[processIndex] = nil							-- 메시지 인덱스 리셋
			elapsedTime = 0.0												-- 처리 후 애니메이션 시간 리셋
			
		else
			panel:SetShow(false, false)				-- 기존에 남아있던 애 꺼주기

			curIndex = 0
			processIndex = 0
		end
	else
		if processIndex < curIndex then
			if (tempMsg ==  MessageData._Msg[processIndex+1]) then   -- 애니메이션이 동작 중 같은 메시지가 들어오는 것 삭제
				processIndex = processIndex  + 1		
				MessageData._Msg[processIndex] = nil
			end
		end
	end
end

function Panel_Trade_EventMsg_Resize()
	local scrX = getScreenSizeX()
	Panel_Trade_EventMsg_Territory:SetPosX( scrX/2 - Panel_Trade_EventMsg_Territory:GetSizeX()/2 )
	Panel_Trade_EventMsg_Npc:SetPosX( scrX/2 - Panel_Trade_EventMsg_Npc:GetSizeX()/2 )
end

function IsTerritoryEvent()
	return isTerritoryEvent
end

Panel_Trade_EventMsg_Territory	:RegisterUpdateFunc("Trade_Event_MessageUpdate")
Panel_Trade_EventMsg_Npc		:RegisterUpdateFunc("Trade_Event_MessageUpdate")
registerEvent( "onScreenResize", "Panel_Trade_EventMsg_Resize" )
-- registerEvent( "FromClient_NotifyVariableTradeItemMsg", "FromClient_NotifyVariableTradeItemMsg" )
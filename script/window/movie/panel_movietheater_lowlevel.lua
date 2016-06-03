-------------------------------------------------------------------------------
-- 						튜토리얼
-------------------------------------------------------------------------------
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_MovieTheater_LowLevel:ActiveMouseEventEffect( true )
Panel_MovieTheater_LowLevel:setGlassBackground( true )

Panel_MovieTheater_LowLevel:SetShow( false, false )
		-- 초기엔 반드시 셋팅 해줘야한다!

Panel_MovieTheater_LowLevel:RegisterShowEventFunc( true, 'Panel_MovieTheater_LowLevel_ShowAni()' )
Panel_MovieTheater_LowLevel:RegisterShowEventFunc( false, 'Panel_MovieTheater_LowLevel_HideAni()' )

--{ 서비스 할 나라 구분(한국 외의 지역에선 false)
local countryType = true
-- 일본 서비스이면서 cbt일때만...
if ( ( isGameTypeJapan() or isGameTypeRussia() or isGameTypeEnglish() ) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT ) then
-- if getGameServiceType() == 5 or getGameServiceType() == 6 then
	countryType = false
else
	countryType = true
end
--}

-----------------------------------------------------------
--					창 애니메이션 처리
-----------------------------------------------------------
function Panel_MovieTheater_LowLevel_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_MovieTheater_LowLevel, 0.0, 0.15 )
	-- Panel_MovieTheater_LowLevel:SetShow(true)
	
	local aniInfo1 = Panel_MovieTheater_LowLevel:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_MovieTheater_LowLevel:GetSizeX() / 2
	aniInfo1.AxisY = Panel_MovieTheater_LowLevel:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_MovieTheater_LowLevel:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_MovieTheater_LowLevel:GetSizeX() / 2
	aniInfo2.AxisY = Panel_MovieTheater_LowLevel:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_MovieTheater_LowLevel_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_MovieTheater_LowLevel, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local _btn_Close 			= UI.getChildControl ( Panel_MovieTheater_LowLevel, "Button_Close" )
local _btn_Replay 			= UI.getChildControl ( Panel_MovieTheater_LowLevel, "Button_Replay" )
local _txt_Title 			= UI.getChildControl ( Panel_MovieTheater_LowLevel, "StaticText_Title" )
local _movieTheater_640		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieTheater_LowLevel, 'WebControl_WorldmapGuide' )

_btn_Close	:addInputEvent( "Mouse_LUp", "Panel_MovieTheater_LowLevel_WindowClose()" )
_btn_Replay	:addInputEvent( "Mouse_LUp", "Panel_MovieTheater_LowLevel_Replay()" )
_movieTheater_640:addInputEvent( "Mouse_Out", "Panel_MovieTheater_LowLevel_HideControl()" )
_movieTheater_640:addInputEvent( "Mouse_On", "Panel_MovieTheater_LowLevel_ShowControl()" )

local isMoviePlay			= false
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--					최초 초기화 함수
------------------------------------------------------------
function Panel_MovieTheater_LowLevel_Initialize()
	_movieTheater_640:SetPosX( 5 )
	_movieTheater_640:SetPosY( 38 )
	_movieTheater_640:SetSize( 450, 338 )
	_movieTheater_640:ResetUrl()
	
	Panel_MovieTheater_LowLevel:SetSize( Panel_MovieTheater_LowLevel:GetSizeX(), 417 )
	Panel_MovieTheater_LowLevel_OnScreenResize()
end



 -- - 10레벨 전까지
-- 2레벨 만족 시 - 의뢰 수행하기
-- 3레벨 만족 시 - 길 찾기
-- 4레벨 만족 시 - 전투의 기본
-- 5레벨 만족 시 - 전투의 기본

------------------------------------------------------------
--				월드맵 전용 영상 가이드
------------------------------------------------------------
local playedNo = 0
local movieDesc = {
	[0] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"), -- 캐릭터 기본 이동
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"), -- 의뢰 수행하기
			
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"), -- 길 찾기 방법
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"), -- 기술 습득 방법
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"), -- 의뢰 목표물 구분하기
			
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_5"), -- 전투의 기본 - 워리어
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_6"), -- 전투의 기본 - 레인저
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_7"), -- 전투의 기본 - 소서러
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_8"), -- 전투의 기본 - 자이언트
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_9"), -- 전투의 기본 - 금수랑
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_27"),-- 무사
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_28"),-- 발키리
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_29"),-- 여자 무사
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_30"),-- 위자드
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_31"),-- 위치(여자 위자드)
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_32"),-- 쿠노이치
			
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"), -- 채집과 가공 방법
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"), -- 공헌도 : 거점 연결 및 회수
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"), -- 공헌도 : 집 용도 변경 및 회수
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"), -- 공헌도 : 대여 아이템 활용
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"), -- 말 조련 및 마구간 등록
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"), -- 일꾼 고용 및 일 시키기
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"), -- 낚시하기
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"), -- NPC 지식 모으기
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"), -- NPC 발견 조건
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"), -- 이야기 교류 및 친밀도 상점
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"), -- 주거지 배치 및 이사 안내
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"), -- 요리 방법
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"), -- 연금술 방법
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"), -- 텃밭 설치 및 가꾸기
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"), -- 의뢰 유형 설정 방법
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"), -- NPC 찾는 방법
			PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26"), -- 흑정령의 분노 사용 방법
}

Panel_LowLevelGuide_Value_IsCheckMoviePlay = 0
function FGlobal_Panel_LowLevelGuide_MovePlay_FindWay()
	Panel_LowLevelGuide_Value_IsCheckMoviePlay = 1
	Panel_MovieTheater_LowLevel_WindowClose()
	Panel_MovieTheater_LowLevel_GameGuide_Func( 2 )	-- 길 찾기
end

function FGlobal_Panel_LowLevelGuide_MovePlay_LearnSkill()
	Panel_LowLevelGuide_Value_IsCheckMoviePlay = 2
	Panel_MovieTheater_LowLevel_WindowClose()
	Panel_MovieTheater_LowLevel_GameGuide_Func( 3 )	-- 스킬 배우기
end

function FGlobal_Panel_LowLevelGuide_MovePlay_FindTarget()
	Panel_LowLevelGuide_Value_IsCheckMoviePlay = 3
	Panel_MovieTheater_LowLevel_WindowClose()
	Panel_MovieTheater_LowLevel_GameGuide_Func( 4 )	-- 몹 찾기
end

function FGlobal_Panel_LowLevelGuide_MovePlay_AcceptQuest()
	Panel_LowLevelGuide_Value_IsCheckMoviePlay = 4
	Panel_MovieTheater_LowLevel_WindowClose()
	Panel_MovieTheater_LowLevel_GameGuide_Func( 1 )	-- 의뢰 수행하기
end

function FGlobal_Panel_LowLevelGuide_MovePlay_BlackSpirit()
	Panel_LowLevelGuide_Value_IsCheckMoviePlay = 99
	Panel_MovieTheater_LowLevel_WindowClose()
	Panel_MovieTheater_LowLevel_GameGuide_Func( 99 )	-- 의뢰 수행하기
end

function FGlobal_Panel_LowLevelGuide_MovePlay_Battle( class )
	local movieNo = nil
	if class == CppEnums.ClassType.ClassType_Warrior then
		movieNo = 5
	elseif class == CppEnums.ClassType.ClassType_Ranger then
		movieNo = 6
	elseif class == CppEnums.ClassType.ClassType_Sorcerer then
		movieNo = 7
	elseif class == CppEnums.ClassType.ClassType_Giant then
		movieNo = 8
	elseif class == CppEnums.ClassType.ClassType_Tamer then
		movieNo = 9
	elseif class == CppEnums.ClassType.ClassType_BladeMaster then
		movieNo = 10
	elseif class == CppEnums.ClassType.ClassType_Valkyrie then
		movieNo = 11
	elseif class == CppEnums.ClassType.ClassType_BladeMasterWomen then
		movieNo = 12
	elseif class == CppEnums.ClassType.ClassType_Wizard then
		movieNo = 13
	elseif class == CppEnums.ClassType.ClassType_WizardWomen then
		movieNo = 14
	elseif class == CppEnums.ClassType.ClassType_NinjaWomen then
		movieNo = 15
	end

	Panel_LowLevelGuide_Value_IsCheckMoviePlay = movieNo
	Panel_MovieTheater_LowLevel_WindowClose()
	Panel_MovieTheater_LowLevel_GameGuide_Func( movieNo )	-- 의뢰 수행하기
end

------------------------------------------------------------------
--				쪼렙용 가이드 영상 틀어주기
------------------------------------------------------------------
local prevTitleNo 	= -1
local titleNo		= 0
function Panel_MovieTheater_LowLevel_GameGuide_Func( movieNo )
	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_RUS ) then
		return
	end
	_movieTheater_640:SetUrl( 450, 338, "coui://UI_Data/UI_Html/UI_Guide_Movie_450.html")
	_movieTheater_640:SetShow(countryType)
	_txt_Title:SetText( movieDesc[movieNo] )
	titleNo = movieNo
	isMoviePlay = true
	
	Panel_MovieTheater_LowLevel:SetShow( countryType, countryType )
end

function Panel_MovieTheater_LowLevel_TriggerEvent()
	_movieTheater_640:TriggerEvent( "ControlAudio", getVolumeParam(0) / 100)
	
	if ( titleNo == 0 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_02.webm")
		playedNo = 0

	elseif ( titleNo == 1 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_01.webm")
		playedNo = 1
		
	elseif ( titleNo == 2 ) then	-- 141228 추가
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_20_FindWay.webm")
		playedNo = 2

	elseif ( titleNo == 3 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_21_LearnSkill.webm")
		playedNo = 3

	elseif ( titleNo == 4 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_22_FindTarget.webm")
		playedNo = 4
		
	elseif ( titleNo == 5 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Warrior.webm")
		playedNo = 5

	elseif ( titleNo == 6 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Ranger.webm")
		playedNo = 6

	elseif ( titleNo == 7 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Sorcer.webm")
		playedNo = 7

	elseif ( titleNo == 8 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Giant.webm")
		playedNo = 8

	elseif ( titleNo == 9 ) then -- 금수랑(테이머)
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
		playedNo = 9

	elseif ( titleNo == 10 ) then -- 무사
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
		playedNo = 10

	elseif ( titleNo == 11 ) then -- 발키리
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")
		playedNo = 11

	elseif ( titleNo == 12 ) then -- 매화
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BladerWomen.webm")
		playedNo = 12

	elseif ( titleNo == 13 ) then -- 위자드
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Wizard.webm")
		playedNo = 13

	elseif ( titleNo == 14 ) then -- 위치
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_WizardWomen.webm")
		playedNo = 14

	elseif ( titleNo == 15 ) then -- 위치
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaWomen.webm")
		playedNo = 15
		
	elseif ( titleNo == 16 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
		playedNo = 16

	elseif ( titleNo == 17 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
		playedNo = 17

	elseif ( titleNo == 18 ) then	-- 141224 추가
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
		playedNo = 18

	elseif ( titleNo == 19 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
		playedNo = 19

	elseif ( titleNo == 20 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
		playedNo = 20

	elseif ( titleNo == 21 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
		playedNo = 21

	elseif ( titleNo == 22 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
		playedNo = 22

	elseif ( titleNo == 23 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
		playedNo = 23

	elseif ( titleNo == 24 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
		playedNo = 24

	elseif ( titleNo == 25 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
		playedNo = 25

	elseif ( titleNo == 26 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
		playedNo = 26

	elseif ( titleNo == 27 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
		playedNo = 27

	elseif ( titleNo == 28 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
		playedNo = 28

	elseif ( titleNo == 29 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
		playedNo = 29

	elseif ( titleNo == 30 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
		playedNo = 30

	elseif ( titleNo == 31 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
		playedNo = 31
		
	elseif ( titleNo == 32 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
		playedNo = 32
		
	elseif ( titleNo == 99 ) then		-- 얘는 따로 리스트에 추가 안됨
		_txt_Title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_LOWLEVEL_SPRITQUEST") ) -- "흑정령의 의뢰 수락/완료" )
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_99_BlackSpirit.webm")
		playedNo = 99
	end

	prevTitleNo = titleNo
end

----------------------------------------------------------------
--				처음부터 버튼을 눌렀을 때!
----------------------------------------------------------------
function Panel_MovieTheater_LowLevel_Replay()
	_movieTheater_640:TriggerEvent( "ControlAudio", 0.3)
	
	if ( playedNo == 0 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_02.webm")

	elseif ( playedNo == 1 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_01.webm")
		
	elseif ( playedNo == 2 ) then	-- 141228 추가
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_20_FindWay.webm")

	elseif ( playedNo == 3 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_21_LearnSkill.webm")

	elseif ( playedNo == 4 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_22_FindTarget.webm")

	elseif ( playedNo == 5 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Warrior.webm")

	elseif ( playedNo == 6 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Ranger.webm")

	elseif ( playedNo == 7 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Sorcer.webm")

	elseif ( playedNo == 8 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Giant.webm")

	elseif ( playedNo == 9 ) then -- 금수랑(테이머)
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm" )

	elseif ( playedNo == 10 ) then -- 무사
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm" )

	elseif ( playedNo == 11 ) then -- 발키리
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm" )

	elseif ( playedNo == 12 ) then -- 매화
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BladerWomen.webm" )

	elseif ( playedNo == 13 ) then -- 위자드
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Wizard.webm" )

	elseif ( playedNo == 14 ) then -- 위치(여자 위자드)
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_WizardWomen.webm" )

	elseif ( playedNo == 15 ) then -- 쿠노이치
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaWomen.webm" )

	elseif ( playedNo == 16 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")

	elseif ( playedNo == 17 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")

	elseif ( playedNo == 18 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")

	elseif ( playedNo == 19 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")

	elseif ( playedNo == 20 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")

	elseif ( playedNo == 21 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")

	elseif ( playedNo == 22 ) then	-- 141224 추가
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")

	elseif ( playedNo == 23 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")

	elseif ( playedNo == 24 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")

	elseif ( playedNo == 25 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")

	elseif ( playedNo == 26 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")

	elseif ( playedNo == 27 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")

	elseif ( playedNo == 28 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")

	elseif ( playedNo == 29 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")

	elseif ( playedNo == 30 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")

	elseif ( playedNo == 31 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")

	elseif ( playedNo == 32 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")

	elseif ( playedNo == 99 ) then
		_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_99_BlackSpirit.webm")

	end
end

function Panel_MovieTheater_LowLevel_WindowClose()
	--_movieTheater_640:ResetUrl()
	Panel_MovieTheater_LowLevel:SetShow( false, true )
	_movieTheater_640:TriggerEvent("StopMovie", "test")
	isMoviePlay			= false
end

function Panel_MovieTheater_LowLevel_OnScreenResize()
	Panel_MovieTheater_LowLevel:SetPosX( 10 )
	Panel_MovieTheater_LowLevel:SetPosY( getScreenSizeY() - Panel_MovieTheater_LowLevel:GetSizeY() - 50 )
end


function ToClient_EndGuideMovie(movieId)
	if (movieId == 450) then
		Panel_MovieTheater_LowLevel_WindowClose()
	end
end

local updateTime = 0.0
function UpdateMovieTheaterLowLevel(deltaTime)
	if (not isMoviePlay) then
		return
	end

	updateTime = updateTime + deltaTime
	
	-- View가 준비 된 후 Trigger Event까지 약간의 시간이 소요됨으로 인해 0.5초 후 재생되도록 한다.
	if 0.5 < updateTime then
		if(_movieTheater_640:isReadyView()) then
			Panel_MovieTheater_LowLevel_TriggerEvent()
			isMoviePlay = false
			updateTime  = 0.0
		end
	end
	
	-- 3초가 넘도록 View가 준비되지 않으면 초기화 시킨다.
	if 3 < updateTime then
		isMoviePlay = false
		updateTime  = 0.0
	end
end

function Panel_MovieTheater_LowLevel_ShowControl()
	_movieTheater_640:TriggerEvent( "ShowControl", "true")
end

function Panel_MovieTheater_LowLevel_HideControl()
	_movieTheater_640:TriggerEvent( "ShowControl", "false")
end

Panel_MovieTheater_LowLevel_Initialize()

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
Panel_MovieTheater_LowLevel:RegisterUpdateFunc("UpdateMovieTheaterLowLevel")

registerEvent("onScreenResize", "Panel_MovieTheater_LowLevel_OnScreenResize")
registerEvent("ToClient_EndGuideMovie", "ToClient_EndGuideMovie")
-- registerEvent("EventSelfPlayerLevelUp", "Panel_LowLevelGuide_MoviePlayCheck_Func")
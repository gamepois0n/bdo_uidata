local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_MovieTheater_640:ActiveMouseEventEffect( true )
Panel_MovieTheater_640:setGlassBackground( true )

Panel_MovieTheater_640:SetShow( false, false )
		-- 초기엔 반드시 셋팅 해줘야한다!

Panel_MovieTheater_640:RegisterShowEventFunc( true, 'Panel_MovieTheater640_ShowAni()' )
Panel_MovieTheater_640:RegisterShowEventFunc( false, 'Panel_MovieTheater640_HideAni()' )
-----------------------------------------------------------
--					창 애니메이션 처리
-----------------------------------------------------------
function Panel_MovieTheater640_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_MovieTheater_640, 0.0, 0.15 )
	-- Panel_MovieTheater_640:SetShow(true)
	
	local aniInfo1 = Panel_MovieTheater_640:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_MovieTheater_640:GetSizeX() / 2
	aniInfo1.AxisY = Panel_MovieTheater_640:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_MovieTheater_640:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_MovieTheater_640:GetSizeX() / 2
	aniInfo2.AxisY = Panel_MovieTheater_640:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_MovieTheater640_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_MovieTheater_640, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local _btn_Close 			= UI.getChildControl ( Panel_MovieTheater_640, "Button_Close" )
local _btn_Replay 			= UI.getChildControl ( Panel_MovieTheater_640, "Button_Replay" )
local _txt_Title 			= UI.getChildControl ( Panel_MovieTheater_640, "StaticText_Title" )
local _movieTheater_640		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieTheater_640, 'WebControl_WorldmapGuide' )

_btn_Close:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_WindowClose()" )
_btn_Replay:addInputEvent( "Mouse_LUp", "Panel_MovieTheater640_Replay()" )
_movieTheater_640:addInputEvent( "Mouse_Out", "Panel_MovieTheater640_HideControl()" )
_movieTheater_640:addInputEvent( "Mouse_On", "Panel_MovieTheater640_ShowControl()" )

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--					최초 초기화 함수
------------------------------------------------------------
function Panel_MovieTheater640_Initialize()
	_movieTheater_640:SetPosX( 5 )
	_movieTheater_640:SetPosY( 38 )
	_movieTheater_640:SetSize( 640, 480 )
	_movieTheater_640:SetUrl(640, 480, "coui://UI_Data/UI_Html/UI_Guide_Movie_640.html")
	
	Panel_MovieTheater_640:SetSize( Panel_MovieTheater_640:GetSizeX(), 557 )
	-- setMoviePlayMode( true )
end

------------------------------------------------------------
--				월드맵 전용 영상 가이드
------------------------------------------------------------
local movieDesc = nil
local playedNo = 0
if isGameTypeKorea() or isGameTypeJapan() then
	movieDesc = {
		[0] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"), -- "캐릭터 기본 이동",   	            -- 0
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"), -- "의뢰 수행하기",						-- 1
				
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"), -- "길 찾기 방법",						-- 2
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"), -- "기술 습득 방법",						-- 3
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"), -- "의뢰 목표물 구분하기",				-- 4
				
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_5"), -- "전투의 기본 - 워리어",     			-- 5
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_6"), -- "전투의 기본 - 레인저",     			-- 6
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_7"), -- "전투의 기본 - 소서러",     			-- 7
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_8"), -- "전투의 기본 - 자이언트",   			-- 8
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_9"), -- "전투의 기본 - 금수랑",				-- 9
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_27"), -- "전투의 기본 - 무사",				-- 10
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_28"), -- "전투의 기본 - 발키리",				-- 11
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_29"), -- "전투의 기본 - 매화",				-- 12
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_30"), -- "전투의 기본 - 위자드",				-- 13
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_31"), -- "전투의 기본 - 위치",				-- 14
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_32"), -- "전투의 기본 - 쿠노이치",			-- 15
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_33"), -- "전투의 기본 - 닌자",				-- 16

				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"), -- "채집과 가공 방법",                 -- 17
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"), -- "공헌도 : 거점 연결 및 회수",       -- 18
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"), -- "공헌도 : 집 용도 변경 및 회수",    -- 19
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"), -- "공헌도 : 대여 아이템 활용",        -- 20
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"), -- "말 조련 및 마구간 등록",           -- 21
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"), -- "일꾼 고용 및 일 시키기",           -- 22
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"), -- "낚시하기",					       -- 23
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"), -- "NPC 지식 모으기",                  -- 24
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"), -- "NPC 발견 조건",                    -- 25
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"), -- "이야기 교류 및 친밀도 상점",       -- 26
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"), -- "주거지 배치 및 이사 안내",         -- 27
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"), -- "요리 방법",                        -- 28
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"), -- "연금술 방법",                      -- 29
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"), -- "텃밭 설치 및 가꾸기",              -- 30
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"), -- "의뢰 유형 설정 방법",         	   -- 31
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"), -- "NPC 찾는 방법",  				   -- 32
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26"), -- "흑정령의 분노 사용 방법",     	   -- 33

	}
elseif isGameTypeRussia() then
	movieDesc = {
		[0] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"), -- "캐릭터 기본 이동",   	            -- 0
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"), -- "의뢰 수행하기",						-- 1
				
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"), -- "길 찾기 방법",						-- 2
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"), -- "기술 습득 방법",						-- 3
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"), -- "의뢰 목표물 구분하기",				-- 4
				
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_5"), -- "전투의 기본 - 워리어",     			-- 5
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_6"), -- "전투의 기본 - 레인저",     			-- 6
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_7"), -- "전투의 기본 - 소서러",     			-- 7
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_8"), -- "전투의 기본 - 자이언트",   			-- 8
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_9"), -- "전투의 기본 - 금수랑",				-- 9
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_27"), -- "전투의 기본 - 무사",				-- 10

				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"), -- "채집과 가공 방법",                 -- 11
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"), -- "공헌도 : 거점 연결 및 회수",       -- 12
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"), -- "공헌도 : 집 용도 변경 및 회수",    -- 13
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"), -- "공헌도 : 대여 아이템 활용",        -- 14
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"), -- "말 조련 및 마구간 등록",           -- 15
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"), -- "일꾼 고용 및 일 시키기",           -- 16
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"), -- "낚시하기",					       -- 17
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"), -- "NPC 지식 모으기",                  -- 18
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"), -- "NPC 발견 조건",                    -- 19
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"), -- "이야기 교류 및 친밀도 상점",       -- 20
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"), -- "주거지 배치 및 이사 안내",         -- 21
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"), -- "요리 방법",                        -- 22
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"), -- "연금술 방법",                      -- 23
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"), -- "텃밭 설치 및 가꾸기",              -- 24
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"), -- "의뢰 유형 설정 방법",         	   -- 25
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"), -- "NPC 찾는 방법",  				   -- 26
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26"), -- "흑정령의 분노 사용 방법",     	   -- 27

	}
elseif isGameTypeEnglish() then
	movieDesc = {
		[0] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"), -- "캐릭터 기본 이동",						-- 0
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"), -- "의뢰 수행하기",						-- 1
				
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"), -- "길 찾기 방법",						-- 2
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"), -- "기술 습득 방법",						-- 3
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"), -- "의뢰 목표물 구분하기",					-- 4
				
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_5"), -- "전투의 기본 - 워리어",					-- 5
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_6"), -- "전투의 기본 - 레인저",					-- 6
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_7"), -- "전투의 기본 - 소서러",					-- 7
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_8"), -- "전투의 기본 - 자이언트",				-- 8
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_9"), -- "전투의 기본 - 금수랑",					-- 9
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_28"), -- "전투의 기본 - 발키리",				-- 10
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_30"), -- "전투의 기본 - 위자드",				-- 11
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_31"), -- "전투의 기본 - 위치",					-- 12
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_27"), -- "전투의 기본 - 무사",					-- 13
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_29"), -- "전투의 기본 - 매화",					-- 14

				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"), -- "채집과 가공 방법",					-- 15
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"), -- "공헌도 : 거점 연결 및 회수",			-- 16
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"), -- "공헌도 : 집 용도 변경 및 회수",			-- 17
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"), -- "공헌도 : 대여 아이템 활용",				-- 18
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"), -- "말 조련 및 마구간 등록",				-- 19
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"), -- "일꾼 고용 및 일 시키기",				-- 20
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"), -- "낚시하기",							-- 21
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"), -- "NPC 지식 모으기",					-- 22
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"), -- "NPC 발견 조건",					-- 23
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"), -- "이야기 교류 및 친밀도 상점",				-- 24
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"), -- "주거지 배치 및 이사 안내",				-- 25
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"), -- "요리 방법",						-- 26
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"), -- "연금술 방법",						-- 27
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"), -- "텃밭 설치 및 가꾸기",					-- 28
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"), -- "의뢰 유형 설정 방법",					-- 29
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"), -- "NPC 찾는 방법",					-- 30
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26"), -- "흑정령의 분노 사용 방법",				-- 31
	}
else
	movieDesc = {
		[0] =	PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_0"), -- "캐릭터 기본 이동",   	            -- 0
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_1"), -- "의뢰 수행하기",						-- 1
				
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_2"), -- "길 찾기 방법",						-- 2
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_3"), -- "기술 습득 방법",						-- 3
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_4"), -- "의뢰 목표물 구분하기",				-- 4
				
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_5"), -- "전투의 기본 - 워리어",     			-- 5
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_6"), -- "전투의 기본 - 레인저",     			-- 6
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_7"), -- "전투의 기본 - 소서러",     			-- 7
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_8"), -- "전투의 기본 - 자이언트",   			-- 8
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_9"), -- "전투의 기본 - 금수랑",				-- 9
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_27"), -- "전투의 기본 - 무사",				-- 10
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_28"), -- "전투의 기본 - 발키리",				-- 11
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_29"), -- "전투의 기본 - 매화",				-- 12
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_30"), -- "전투의 기본 - 위자드",				-- 13
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_31"), -- "전투의 기본 - 위치",				-- 14
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_32"), -- "전투의 기본 - 쿠노이치",			-- 15
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_33"), -- "전투의 기본 - 닌자",				-- 16

				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_10"), -- "채집과 가공 방법",                 -- 17
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_11"), -- "공헌도 : 거점 연결 및 회수",       -- 18
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_12"), -- "공헌도 : 집 용도 변경 및 회수",    -- 19
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_13"), -- "공헌도 : 대여 아이템 활용",        -- 20
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_14"), -- "말 조련 및 마구간 등록",           -- 21
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_15"), -- "일꾼 고용 및 일 시키기",           -- 22
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_16"), -- "낚시하기",					       -- 23
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_17"), -- "NPC 지식 모으기",                  -- 24
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_18"), -- "NPC 발견 조건",                    -- 25
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_19"), -- "이야기 교류 및 친밀도 상점",       -- 26
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_20"), -- "주거지 배치 및 이사 안내",         -- 27
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_21"), -- "요리 방법",                        -- 28
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_22"), -- "연금술 방법",                      -- 29
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_23"), -- "텃밭 설치 및 가꾸기",              -- 30
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_24"), -- "의뢰 유형 설정 방법",         	   -- 31
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_25"), -- "NPC 찾는 방법",  				   -- 32
				PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_640_MOVIEDESC_26"), -- "흑정령의 분노 사용 방법",     	   -- 33
	}
end

------------------------------------------------------------------
--				쪼렙용 가이드 영상 틀어주기
------------------------------------------------------------------
local prevTitleNo = -1
function Panel_MovieTheater640_GameGuide_Func( titleNo )
	if (not _movieTheater_640:isReadyView()) then
		return
	end
	
	_movieTheater_640:TriggerEvent( "ControlAudio", getVolumeParam(0) / 100)
	
	local isShow = Panel_MovieTheater_640:IsShow()
	if ( isShow == true and prevTitleNo == titleNo ) then
		Panel_MovieTheater_640:SetShow( false, true )
		prevTitleNo = -1
		return
	else
		Panel_MovieTheater_640:SetShow( true, true )
		_movieTheater_640:SetShow(true)
	end

	_txt_Title:SetText( movieDesc[titleNo] )

	if isGameTypeKorea() or isGameTypeJapan() then
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
		elseif ( titleNo == 9 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
			playedNo = 9
		elseif ( titleNo == 10 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
			playedNo = 10
		elseif ( titleNo == 11 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")
			playedNo = 11
		elseif ( titleNo == 12 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BladerWomen.webm")
			playedNo = 12
		elseif ( titleNo == 13 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Wizard.webm")
			playedNo = 13
		elseif ( titleNo == 14 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_WizardWomen.webm")
			playedNo = 14
		elseif ( titleNo == 15 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaWomen.webm")
			playedNo = 15
		elseif ( titleNo == 16 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaMan.webm")
			playedNo = 16

		elseif ( titleNo == 17 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
			playedNo = 17
		elseif ( titleNo == 18 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
			playedNo = 18
		elseif ( titleNo == 19 ) then	-- 141224 추가
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
			playedNo = 19
		elseif ( titleNo == 20 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
			playedNo = 20
		elseif ( titleNo == 21 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
			playedNo = 21
		elseif ( titleNo == 22 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
			playedNo = 22
		elseif ( titleNo == 23 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
			playedNo = 23
		elseif ( titleNo == 24 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
			playedNo = 24
		elseif ( titleNo == 25 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
			playedNo = 25
		elseif ( titleNo == 26 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
			playedNo = 26
		elseif ( titleNo == 27 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
			playedNo = 27
		elseif ( titleNo == 28 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
			playedNo = 28
		elseif ( titleNo == 29 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
			playedNo = 29
		elseif ( titleNo == 30 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
			playedNo = 30
		elseif ( titleNo == 31 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
			playedNo = 31
		elseif ( titleNo == 32 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
			playedNo = 32
		elseif ( titleNo == 33 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
			playedNo = 33
		end
	elseif isGameTypeRussia() then
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
--{	전투의 기본
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
		elseif ( titleNo == 9 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
			playedNo = 9
		elseif ( titleNo == 10 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
			playedNo = 10
		elseif ( titleNo == 11 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")
			playedNo = 11
--}
		elseif ( titleNo == 12) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
			playedNo = 12
		elseif ( titleNo == 13 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
			playedNo = 13
		elseif ( titleNo == 14 ) then	-- 141224 추가
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
			playedNo = 14
		elseif ( titleNo == 15 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
			playedNo = 15
		elseif ( titleNo == 16 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
			playedNo = 16
		elseif ( titleNo == 17 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
			playedNo = 17
		elseif ( titleNo == 18 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
			playedNo = 18
		elseif ( titleNo == 19 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
			playedNo = 19
		elseif ( titleNo == 20 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
			playedNo = 20
		elseif ( titleNo == 21 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
			playedNo = 21
		elseif ( titleNo == 22 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
			playedNo = 22
		elseif ( titleNo == 23 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
			playedNo = 23
		elseif ( titleNo == 24 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
			playedNo = 24
		elseif ( titleNo == 25 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
			playedNo = 25
		elseif ( titleNo == 26 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
			playedNo = 26
		elseif ( titleNo == 27 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
			playedNo = 27
		elseif ( titleNo == 28 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
			playedNo = 28
		end
	elseif isGameTypeEnglish() then
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
--{	전투의 기본
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
		elseif ( titleNo == 9 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
			playedNo = 9
		elseif ( titleNo == 10 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")
			playedNo = 10
		elseif ( titleNo == 11 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Wizard.webm")
			playedNo = 11
		elseif ( titleNo == 12 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_WizardWomen.webm")
			playedNo = 12
		elseif ( titleNo == 13 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
			playedNo = 13
		elseif ( titleNo == 14 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BladerWomen.webm")
			playedNo = 14
--}
		elseif ( titleNo == 15 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
			playedNo = 15
		elseif ( titleNo == 16 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
			playedNo = 16
		elseif ( titleNo == 17 ) then	-- 141224 추가
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
			playedNo = 17
		elseif ( titleNo == 18 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
			playedNo = 18
		elseif ( titleNo == 19 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
			playedNo = 19
		elseif ( titleNo == 20 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
			playedNo = 20
		elseif ( titleNo == 21 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
			playedNo = 21
		elseif ( titleNo == 22 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
			playedNo = 22
		elseif ( titleNo == 23 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
			playedNo = 23
		elseif ( titleNo == 24 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
			playedNo = 24
		elseif ( titleNo == 25 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
			playedNo = 25
		elseif ( titleNo == 26 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
			playedNo = 26
		elseif ( titleNo == 27 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
			playedNo = 27
		elseif ( titleNo == 28 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
			playedNo = 28
		elseif ( titleNo == 29 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
			playedNo = 29
		elseif ( titleNo == 30 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
			playedNo = 30
		elseif ( titleNo == 31 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
			playedNo = 31
		end
	else
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
		elseif ( titleNo == 9 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
			playedNo = 9
		elseif ( titleNo == 10 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
			playedNo = 10
		elseif ( titleNo == 11 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")
			playedNo = 11
		elseif ( titleNo == 12 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BladerWomen.webm")
			playedNo = 12
		elseif ( titleNo == 13 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Wizard.webm")
			playedNo = 13
		elseif ( titleNo == 14 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_WizardWomen.webm")
			playedNo = 14
		elseif ( titleNo == 15 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaWomen.webm")
			playedNo = 15
		elseif ( titleNo == 16 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaMan.webm")
			playedNo = 16

		elseif ( titleNo == 17 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
			playedNo = 17
		elseif ( titleNo == 18 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
			playedNo = 18
		elseif ( titleNo == 19 ) then	-- 141224 추가
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
			playedNo = 19
		elseif ( titleNo == 20 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
			playedNo = 20
		elseif ( titleNo == 21 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
			playedNo = 21
		elseif ( titleNo == 22 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
			playedNo = 22
		elseif ( titleNo == 23 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
			playedNo = 23
		elseif ( titleNo == 24 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
			playedNo = 24
		elseif ( titleNo == 25 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
			playedNo = 25
		elseif ( titleNo == 26 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
			playedNo = 26
		elseif ( titleNo == 27 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
			playedNo = 27
		elseif ( titleNo == 28 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
			playedNo = 28
		elseif ( titleNo == 29 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
			playedNo = 29
		elseif ( titleNo == 30 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
			playedNo = 30
		elseif ( titleNo == 31 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
			playedNo = 31
		elseif ( titleNo == 32 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
			playedNo = 32
		elseif ( titleNo == 33 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
			playedNo = 33
		end
	end
	prevTitleNo = titleNo
end

----------------------------------------------------------------
--				처음부터 버튼을 눌렀을 때!
----------------------------------------------------------------
function Panel_MovieTheater640_Replay()
	if (not _movieTheater_640:isReadyView()) then
		return
	end
	
	if isGameTypeKorea() or isGameTypeJapan() then
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
		elseif ( playedNo == 9 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
		elseif ( playedNo == 10 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
		elseif ( playedNo == 11 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")
		elseif ( playedNo == 12 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BladerWomen.webm")
		elseif ( playedNo == 13 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Wizard.webm")
		elseif ( playedNo == 14 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_WizardWomen.webm")
		elseif ( playedNo == 15 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaWomen.webm")
		elseif ( playedNo == 16 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaMan.webm")

		elseif ( playedNo == 17 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
		elseif ( playedNo == 18) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
		elseif ( playedNo == 19 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
		elseif ( playedNo == 20 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
		elseif ( playedNo == 21 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
		elseif ( playedNo == 22 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
		elseif ( playedNo == 23 ) then	-- 141224 추가
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
		elseif ( playedNo == 24 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
		elseif ( playedNo == 25 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
		elseif ( playedNo == 26 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
		elseif ( playedNo == 27 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
		elseif ( playedNo == 28 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
		elseif ( playedNo == 29 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
		elseif ( playedNo == 30 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
		elseif ( playedNo == 31 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
		elseif ( playedNo == 32 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
		elseif ( playedNo == 33 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
		end
	elseif isGameTypeRussia() then
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
		elseif ( playedNo == 9 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
		elseif ( playedNo == 10 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
		elseif ( playedNo == 11 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")

		elseif ( playedNo == 12 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
		elseif ( playedNo == 13) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
		elseif ( playedNo == 14 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
		elseif ( playedNo == 15 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
		elseif ( playedNo == 16 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
		elseif ( playedNo == 17 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
		elseif ( playedNo == 18 ) then	-- 141224 추가
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
		elseif ( playedNo == 19 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
		elseif ( playedNo == 20 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
		elseif ( playedNo == 21 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
		elseif ( playedNo == 22 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
		elseif ( playedNo == 23 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
		elseif ( playedNo == 24 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
		elseif ( playedNo == 25 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
		elseif ( playedNo == 26 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
		elseif ( playedNo == 27 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
		elseif ( playedNo == 28 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
		end
	elseif isGameTypeEnglish() then
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
		elseif ( playedNo == 9 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
		elseif ( playedNo == 10 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")
		elseif ( playedNo == 11 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Wizard.webm")
		elseif ( playedNo == 12 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_WizardWomen.webm")
		elseif ( playedNo == 13 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
		elseif ( playedNo == 14 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BladerWomen.webm")

		elseif ( playedNo == 15 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
		elseif ( playedNo == 16) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
		elseif ( playedNo == 17 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
		elseif ( playedNo == 18 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
		elseif ( playedNo == 19 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
		elseif ( playedNo == 20 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
		elseif ( playedNo == 21 ) then	-- 141224 추가
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
		elseif ( playedNo == 22 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
		elseif ( playedNo == 23 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
		elseif ( playedNo == 24 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
		elseif ( playedNo == 25 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
		elseif ( playedNo == 26 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
		elseif ( playedNo == 27 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
		elseif ( playedNo == 28 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
		elseif ( playedNo == 29 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
		elseif ( playedNo == 30 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
		elseif ( playedNo == 31 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
		end
	else
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
		elseif ( playedNo == 9 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BeastMaster.webm")
		elseif ( playedNo == 10 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Blader.webm")
		elseif ( playedNo == 11 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Valkyrie.webm")
		elseif ( playedNo == 12 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_BladerWomen.webm")
		elseif ( playedNo == 13 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_Wizard.webm")
		elseif ( playedNo == 14 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_WizardWomen.webm")
		elseif ( playedNo == 15 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaWomen.webm")
		elseif ( playedNo == 16 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_Combat_NinjaMan.webm")

		elseif ( playedNo == 17 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_03.webm")
		elseif ( playedNo == 18) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_04.webm")
		elseif ( playedNo == 19 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_05.webm")
		elseif ( playedNo == 20 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_06.webm")
		elseif ( playedNo == 21 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_07.webm")
		elseif ( playedNo == 22 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_08.webm")
		elseif ( playedNo == 23 ) then	-- 141224 추가
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_09_Fish.webm")
		elseif ( playedNo == 24 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_10_Wp.webm")
		elseif ( playedNo == 25 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_11_Dial.webm")
		elseif ( playedNo == 26 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_12_Intimacy.webm")
		elseif ( playedNo == 27 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_13_MoveHouse.webm")
		elseif ( playedNo == 28 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_14_Cook.webm")
		elseif ( playedNo == 29 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_15_Alchemy.webm")
		elseif ( playedNo == 30 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_16_Tent.webm")
		elseif ( playedNo == 31 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_17_QuestFilter.webm")
		elseif ( playedNo == 32 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_18_Findway.webm")
		elseif ( playedNo == 33 ) then
			_movieTheater_640:TriggerEvent( "PlayMovie", "coui://UI_Movie/Movie_Guide/World_Guide_19_BlackRage.webm")
		end
	end
end

function Panel_MovieTheater640_WindowClose()
	Panel_MovieTheater_640:SetShow( false, false )
	if Panel_WorldMap:GetShow() then
		Panel_Worldmap_MovieGuide_Close()
	end
end

function Panel_MovieTheater640_Reset()
	_movieTheater_640:ResetUrl()
end

function FGlobal_Panel_MovieTheater640_WindowClose()
	Panel_MovieTheater_640:SetShow( false, true )
	Panel_MovieTheater640_Reset()
end

function Panel_MovieTheater640_ShowControl()
	_movieTheater_640:TriggerEvent( "ShowControl", "true")
end

function Panel_MovieTheater640_HideControl()
	_movieTheater_640:TriggerEvent( "ShowControl", "false")
end

--Panel_MovieTheater640_Initialize()

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

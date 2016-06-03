local UI_TM			= CppEnums.TextMode

value_Panel_MovieTheater_SkillGuide_640_IsCheckedShow = false

Panel_MovieTheater_SkillGuide_640:ActiveMouseEventEffect( true )
Panel_MovieTheater_SkillGuide_640:setGlassBackground( true )

Panel_MovieTheater_SkillGuide_640:SetShow( false, false )
		-- 초기엔 반드시 셋팅 해줘야한다!

Panel_MovieTheater_SkillGuide_640:RegisterShowEventFunc( true, 'Panel_MovieTheater320_ShowAni()' )
Panel_MovieTheater_SkillGuide_640:RegisterShowEventFunc( false, 'PanelMovieTheater320_HideAni()' )
-----------------------------------------------------------
--					창 애니메이션 처리
-----------------------------------------------------------
function Panel_MovieTheater320_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_MovieTheater_SkillGuide_640, 0.0, 0.15 )
	Panel_MovieTheater_SkillGuide_640:SetShow(true)
end

function Panel_MovieTheater320_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_MovieTheater_SkillGuide_640, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local _btn_Close 			= UI.getChildControl ( Panel_MovieTheater_SkillGuide_640, "Button_Close" )
local _btn_Replay 			= UI.getChildControl ( Panel_MovieTheater_SkillGuide_640, "Button_Replay" )
local _txt_Title 			= UI.getChildControl ( Panel_MovieTheater_SkillGuide_640, "StaticText_Title" )
local _movieTheater_640		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieTheater_SkillGuide_640, 'WebControl_SkillGuide' )

local helpBubble			= UI.getChildControl ( Panel_MovieTheater_SkillGuide_640, "Static_HelpBubble" )
local helpMsg				= UI.getChildControl ( Panel_MovieTheater_SkillGuide_640, "StaticText_HelpMsg" )

local _comboList			= UI.getChildControl ( Panel_MovieTheater_SkillGuide_640, "StaticText_ComboList" )

local messageUI = {
	_messageBox 			= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Static_MessageBox" ),
	_message_Title 			= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Static_Text_Title" ),
	_messageText 			= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Static_Text" ),
	_btn_Yes 				= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Button_Yes" ),
	_btn_No 				= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Button_No" ),
}

_btn_Close:addInputEvent( "Mouse_LUp", "Panel_MovieTheater_SkillGuide_640_JustClose()" )
_btn_Replay:addInputEvent( "Mouse_LUp", "Panel_MovieTheater_SkillGuide_640_Replay()" )
_movieTheater_640:addInputEvent( "Mouse_Out", "Panel_MovieTheater_SkillGuide_640_HideControl()" )
_movieTheater_640:addInputEvent( "Mouse_On", "Panel_MovieTheater_SkillGuide_640_ShowControl()" )
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--					최초 초기화 함수
------------------------------------------------------------
function Panel_MovieTheater_SkillGuide_640_Initialize()
	_movieTheater_640:SetPosX( 5 )
	_movieTheater_640:SetPosY( 38 )
	_movieTheater_640:SetUrl(640, 480, "coui://UI_Data/UI_Html/UI_Guide_Movie_640.html")
	
	Panel_MovieTheater_SkillGuide_640:SetSize( Panel_MovieTheater_SkillGuide_640:GetSizeX(), 317 )
	
	Panel_MovieTheater_MessageBox:SetShow( false )
	for _, v in pairs ( messageUI ) do
		v:SetShow( false )
	end
end

------------------------------------------------------------
--						기타 변수
------------------------------------------------------------
local playedNo = 0
local warriorText 		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WARRIORTEXT") -- 워리어 :
local rangerText 		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_RANGERTEXT") -- 레인저 :
local sorcererText 		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_SORCERERTEXT") -- 소서러 :
local giantText 		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_GIANTTEXT") -- 자이언트 :
local tamerText			= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_TAMERTEXT") -- 금수랑 :
local bladerText		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_BLADERTEXT") -- 무사 :
local bladerWomenText	= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_BLADERWOMENTEXT") -- 매화 :
local valkyrieText		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_VALKYRIETEXT") -- 발키리 :
local wizardWomenText	= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WIZARDWOMENTEXT") -- 위치 :
local wizardText		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WIZARDTEXT") -- 위자드 :
local ninjaWomenText	= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_NINJAWOMENTEXT") -- 쿠노이치 :
local ninjaManText		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_NINJAMANTEXT") -- 닌자 :

---------------------------------------------------------------------------------------
local comboDesc = {
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_0"), -- "<PAColor0xFFFFD450> 강타 <PAOldColor> > <PAColor0xFFFFD450> 전진 검술<PAOldColor>",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_1"), -- "<PAColor0xFFFFD450> 잡아 메치기 <PAOldColor> > <PAColor0xFFFFD450> 전진 검술 <PAOldColor> > <PAColor0xFFFFD450> 지면 가르기<PAOldColor>",
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_2"), -- "<PAColor0xFFFFD450> 반격 태세 <PAOldColor> > <PAColor0xFFFFD450> 깊게 찌르기 <PAOldColor> > <PAColor0xFFFFD450> 돌진 찌르기 <PAOldColor> > <PAColor0xFFFFD450> 회전 가르기<PAOldColor>",
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_3"), -- "<PAColor0xFFFFD450> 반격 태세 <PAOldColor> > <PAColor0xFFFFD450> 돌개 강타<PAOldColor> > <PAColor0xFFFFD450> 돌개 가르기<PAOldColor>",
	[16] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_16"), -- "<PAColor0xFFFFD450> 방패 진공 <PAOldColor> > <PAColor0xFFFFD450> 극:찍어 차기 <PAOldColor> > <PAColor0xFFFFD450> 돌개 베기 <PAOldColor> > <PAColor0xFFFFD450> 돌개 가르기 <PAOldColor> > <PAColor0xFFFFD450> 극:깊게 찌르기 <PAOldColor> > <PAColor0xFFFFD450> 점프 찌르기 <PAOldColor> > <PAColor0xFFFFD450> 연속 점프 찌르기 <PAOldColor> > <PAColor0xFFFFD450> 방패 진공 <PAOldColor> > <PAColor0xFFFFD450> 잡아 매치기 <PAOldColor> > <PAColor0xFFFFD450> 발차기 <PAOldColor> > <PAColor0xFFFFD450> 전진 검술 2타격 <PAOldColor> > <PAColor0xFFFFD450> 회전 가르기 <PAOldColor> > <PAColor0xFFFFD450> 극:회전 가르기 <PAOldColor> > <PAColor0xFFFFD450> 점프 가르기 <PAOldColor> > <PAColor0xFFFFD450> 지면강타<PAOldColor>",
	
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_4"), -- "<PAColor0xFFFFD450> 활 숙련도 <PAOldColor> > <PAColor0xFFFFD450> 회피 사격 <PAOldColor> > <PAColor0xFFFFD450> 약점 노리기 <PAOldColor> > <PAColor0xFFFFD450> 회피 사격<PAOldColor> > <PAColor0xFFFFD450> 약점 노리기<PAOldColor> - 반복",
	[5] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_5"), -- "<PAColor0xFFFFD450> 활 숙련도 <PAOldColor> > <PAColor0xFFFFD450> 약점 노리기 <PAOldColor> > <PAColor0xFFFFD450> 바람 모아쏘기<PAOldColor>",
	[6] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_6"), -- "<PAColor0xFFFFD450> 활 숙련도 <PAOldColor> > <PAColor0xFFFFD450> 회피 사격 <PAOldColor> > <PAColor0xFFFFD450> 약점 노리기 <PAOldColor> > <PAColor0xFFFFD450> 회피 사격 <PAOldColor> > <PAColor0xFFFFD450> 약점 노리기 <PAOldColor> > <PAColor0xFFFFD450> 바람 모아쏘기<PAOldColor>",
	[7] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_7"), -- "<PAColor0xFFFFD450> 돌진 차기 <PAOldColor> > <PAColor0xFFFFD450> 반달 차기 <PAOldColor> > <PAColor0xFFFFD450> 회피 폭발사격(흐름) <PAOldColor> > <PAColor0xFFFFD450> 활 숙련도(공중)<PAOldColor>",
	[17] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_17"), -- "<PAColor0xFFFFD450> 우직한 칼날 바람 <PAOldColor> > <PAColor0xFFFFD450> 전력 질주 중 활 숙련도 <PAOldColor> > <PAColor0xFFFFD450> 수호의 검 <PAOldColor> > <PAColor0xFFFFD450> 반달 차기 <PAOldColor> > <PAColor0xFFFFD450>길을 여는 바람 (흐름)<PAOldColor>",
	
	[8] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_8"), -- "<PAColor0xFFFFD450> 해방된 어둠 <PAOldColor> > <PAColor0xFFFFD450> 어둠의 연격<PAOldColor>",
	[9] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_9"), -- "<PAColor0xFFFFD450> 어둠 가르기 <PAOldColor> > <PAColor0xFFFFD450> 하단 차기 <PAOldColor> > <PAColor0xFFFFD450> 해방된 어둠(후방) <PAOldColor> > <PAColor0xFFFFD450> 까마귀 돌진 <PAOldColor> > <PAColor0xFFFFD450> 하단 차기<PAOldColor>",
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_10"), -- "<PAColor0xFFFFD450> 사악한 기운 <PAOldColor> > <PAColor0xFFFFD450> 사악한 그림자 <PAOldColor> > <PAColor0xFFFFD450> 응축된 어둠 <PAOldColor> > <PAColor0xFFFFD450> 심연의 불꽃<PAOldColor>",
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_11"), -- "<PAColor0xFFFFD450> 긴밤 지르기 <PAOldColor> > <PAColor0xFFFFD450> 까마귀 불꽃 <PAOldColor> > <PAColor0xFFFFD450> 부리 차기 <PAOldColor> > <PAColor0xFFFFD450> 어둠의 연격<PAOldColor>",
	[18] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_18"), -- "<PAColor0xFFFFD450> 고통의 표식 <PAOldColor> > <PAColor0xFFFFD450> 조각 폭발 <PAOldColor> > <PAColor0xFFFFD450> 극:긴밤 지르기 <PAOldColor> > <PAColor0xFFFFD450> 그림자 차기 <PAOldColor> > <PAColor0xFFFFD450> 어둠의 연격 <PAOldColor> > <PAColor0xFFFFD450> 어둠의 업화 <PAOldColor> > <PAColor0xFFFFD450> 그림자 분출 <PAOldColor> > <PAColor0xFFFFD450> 극:그림자 분출 <PAOldColor> > <PAColor0xFFFFD450> 멸망의 꿈 (당겨진 멸망)<PAOldColor>",
	
	[12] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_12"), -- "<PAColor0xFFFFD450> 힘의 탄력(전진) <PAOldColor> > <PAColor0xFFFFD450> 박치기(모으기) <PAOldColor> > <PAColor0xFFFFD450> 힘의 탄력(전진) <PAOldColor> > <PAColor0xFFFFD450> 박치기<PAOldColor>",
	[13] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_13"), -- "<PAColor0xFFFFD450> 찍어 메치기 <PAOldColor> > <PAColor0xFFFFD450> 힘의 탄력(전진) <PAOldColor> > <PAColor0xFFFFD450> 맹수의 습격<PAOldColor>",
	[14] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_14"), -- "<PAColor0xFFFFD450> 박치기 <PAOldColor> > <PAColor0xFFFFD450> 맹수의 습격 <PAOldColor> > <PAColor0xFFFFD450> 날짐승 바람 가르기 <PAOldColor> > <PAColor0xFFFFD450> 힘의 탄력(전진)<PAOldColor>",
	[15] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_15"), -- "<PAColor0xFFFFD450> 회피 이동 <PAOldColor> > <PAColor0xFFFFD450> 날짐승 바람 가르기 <PAOldColor> > <PAColor0xFFFFD450> 몰아치는 벼락<PAOldColor>",
	[19] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_19"), -- "<PAColor0xFFFFD450> 힘의 탄력 (전진) <PAOldColor> > <PAColor0xFFFFD450> 박치기 <PAOldColor> > <PAColor0xFFFFD450> 맹수의 습격 <PAOldColor> > <PAColor0xFFFFD450> 맹렬한 공격 2타 <PAOldColor> > <PAColor0xFFFFD450> 박치기 2타 <PAOldColor> > <PAColor0xFFFFD450> 맹수의 습격 <PAOldColor> > <PAColor0xFFFFD450> 찍어 메치기 <PAOldColor> > <PAColor0xFFFFD450> 시체 운반자 <PAOldColor> > <PAColor0xFFFFD450> 힘의 탄력 (전진) <PAOldColor> > <PAColor0xFFFFD450> 날짐승 바람 가르기 <PAOldColor> > <PAColor0xFFFFD450> 몰아치는 벼락<PAOldColor>",
	
	[20] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_20"), -- "<PAColor0xFFFFD450> 낙엽 베기 <PAOldColor> > <PAColor0xFFFFD450> 벽력장 <PAOldColor> > <PAColor0xFFFFD450> 붕격 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 즈려밟기<PAOldColor>",
	[21] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_21"), -- "<PAColor0xFFFFD450> 회피 공격 <PAOldColor> > <PAColor0xFFFFD450> 벽력장 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 발톱 올려치기 <PAOldColor> > <PAColor0xFFFFD450> 벽력장<PAOldColor>",
	[22] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_22"), -- "<PAColor0xFFFFD450> 섬광 <PAOldColor> > <PAColor0xFFFFD450> 하늘 차기 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 땅의 벼락 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 즈려밟기<PAOldColor>",
	[23] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_23"), -- "<PAColor0xFFFFD450> 회피 이동 <PAOldColor> > <PAColor0xFFFFD450> 낙엽 베기 (전진) <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 땅의 벼락 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 즈려밟기 <PAOldColor> > <PAColor0xFFFFD450> 벽력장 <PAOldColor> > <PAColor0xFFFFD450> 붕격<PAOldColor>",
	[24] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_24"), -- "<PAColor0xFFFFD450> 회피 공격 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 할퀴기 <PAOldColor> > <PAColor0xFFFFD450> 물의 흐름 I <PAOldColor> > <PAColor0xFFFFD450> 물의 흐름 II <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 즈려밟기 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 땅의 벼락 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 즈려밟기 <PAOldColor> > <PAColor0xFFFFD450> 하늘 차기 <PAOldColor> > <PAColor0xFFFFD450> 흑랑 : 밀려오는 파도<PAOldColor>",
--{ 무사
	[25] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_25"),
	[26] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_26"),
	[27] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_27"),
	[28] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_28"),
	[29] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_29"),
--}
--{ 발키리
	[30] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_30"),
	[31] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_31"),
	[32] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_32"),
	[33] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_33"),
	[34] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIETHEATER_SKILLGUIDE_640_COMBODESC_34"),
--}
--{ 매화
	[35] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_35"),
	[36] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_36"),
	[37] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_37"),
	[38] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_38"),
	[39] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_39"),
--}
--{ 위치
	[40] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_40"),
	[41] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_41"),
	[42] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_42"),
	[43] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_43"),
	[44] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_44"),
--}
--{ 위자드
	[45] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_40"),
	[46] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_41"),
	[47] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_42"),
	[48] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_43"),
	[49] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_44"),
--}
--{ 쿠노이치
	[50] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_45"),
	[51] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_46"),
	[52] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_47"),
	[53] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_48"),
	[54] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_49"),
--}
--{ 닌자
	[55] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_45"),
	[56] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_46"),
	[57] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_47"),
	[58] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_50"),
	[59] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_51"),
--}
}

---------------------------------------------------------------------------------------

function Panel_MovieTheater_SkillGuide_640_JustClose()
	Panel_MovieTheater_SkillGuide_640:SetShow ( false )
end

function FGlobal_Panel_MovieTheater_SkillGuide_640_UrlReset()
	_movieTheater_640:ResetUrl()
end


----------------------------------------------------------------------------------------------------
-- 									영상 사이즈 크게 보기
----------------------------------------------------------------------------------------------------
function Panel_MovieTheaterSkillGuide640_ShowToggle( classNo, titleNo )
	Panel_MovieTheater_MessageBox:SetShow( false )
	for _, v in pairs ( messageUI ) do
		v:SetShow( false )
	end

	if (not _movieTheater_640:isReadyView()) then
		return
	end

	helpBubble:SetShow( false )
	helpMsg:SetShow( false )
	
	local isShow = Panel_MovieTheater_SkillGuide_640:IsShow()
	
	_movieTheater_640:SetSize( 640, 480 )
	
	if ( isShow == true ) then
		Panel_MovieTheater_SkillGuide_640:SetShow( false, false )
	else
		Panel_MovieTheater_SkillGuide_640:SetShow( true, false )
	end
	
	_comboList:SetSize( 635, _comboList:GetTextSizeY() + 7 )
	_comboList:SetTextMode( UI_TM.eTextMode_AutoWrap )
	
	if ( classNo == 0 ) then		-- 워리어
		if ( titleNo == 0 ) then
			playedNo = 100
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[0] )
		elseif ( titleNo == 1 ) then
			playedNo = 101
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[1] )
		elseif ( titleNo == 2 ) then
			playedNo = 102
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[2] )
		elseif ( titleNo == 3 ) then
			playedNo = 103
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[3] )
		elseif ( titleNo == 4 ) then
			playedNo = 104
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[16] )
		end
		
	elseif ( classNo == 4 ) then	-- 레인저
		if ( titleNo == 0 ) then
			playedNo = 200
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[4] )
		elseif ( titleNo == 1 ) then
			playedNo = 201
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[5] )
		elseif ( titleNo == 2 ) then
			playedNo = 202
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[6] )
		elseif ( titleNo == 3 ) then
			playedNo = 203
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[7] )
		elseif ( titleNo == 4 ) then
			playedNo = 204
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[17] )
		end
		
	elseif ( classNo == 8 ) then	-- 소서러
		if ( titleNo == 0 ) then
			playedNo = 300
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[8] )
		elseif ( titleNo == 1 ) then
			playedNo = 301
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[9] )
		elseif ( titleNo == 2 ) then
			playedNo = 302
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[10] )
		elseif ( titleNo == 3 ) then
			playedNo = 303
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[11] )
		elseif ( titleNo == 4 ) then
			playedNo = 304
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[18] )
		end
		
	elseif ( classNo == 12 ) then	-- 자이언트
		if ( titleNo == 0 ) then
			playedNo = 400
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[12] )
		elseif ( titleNo == 1 ) then
			playedNo = 401
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[13] )
		elseif ( titleNo == 2 ) then
			playedNo = 402
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[14] )
		elseif ( titleNo == 3 ) then
			playedNo = 403
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[15] )
		elseif ( titleNo == 4 ) then
			playedNo = 404
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[19] )
		end
		
	elseif ( classNo == 16 ) then	-- 금수랑
		if ( titleNo == 0 ) then
			playedNo = 500
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[20] )
		elseif ( titleNo == 1 ) then
			playedNo = 501
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[21] )
		elseif ( titleNo == 2 ) then
			playedNo = 502
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[22] )
		elseif ( titleNo == 3 ) then
			playedNo = 503
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[23] )
		elseif ( titleNo == 4 ) then
			playedNo = 504
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[24] )
		end
	elseif ( classNo == 20 ) then	-- 무사
		if ( titleNo == 0 ) then
			playedNo = 600
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText ) ) -- tamerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[25] )
		elseif ( titleNo == 1 ) then
			playedNo = 601
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText ) ) -- tamerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[26] )
		elseif ( titleNo == 2 ) then
			playedNo = 602
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[27] )
		elseif ( titleNo == 3 ) then
			playedNo = 603
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", bladerText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[28] )
		elseif ( titleNo == 4 ) then
			playedNo = 604
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", bladerText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[29] )
		end
	elseif ( classNo == 21 ) then	-- 매화
		if ( titleNo == 0 ) then
			playedNo = 800
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", bladerWomenText ) ) -- tamerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[35] )
		elseif ( titleNo == 1 ) then
			playedNo = 801
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", bladerWomenText ) ) -- tamerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[36] )
		elseif ( titleNo == 2 ) then
			playedNo = 802
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerWomenText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[37] )
		elseif ( titleNo == 3 ) then
			playedNo = 803
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", bladerWomenText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[38] )
		elseif ( titleNo == 4 ) then
			playedNo = 804
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", bladerWomenText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[39] )
		end
	elseif ( classNo == 24 ) then	-- 발키리
		if ( titleNo == 0 ) then
			playedNo = 700
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", valkyrieText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[30] )
		elseif ( titleNo == 1 ) then
			playedNo = 701
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", valkyrieText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[31] )
		elseif ( titleNo == 2 ) then
			playedNo = 702
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", valkyrieText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[32] )
		elseif ( titleNo == 3 ) then
			playedNo = 703
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", valkyrieText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[33] )
		elseif ( titleNo == 4 ) then
			playedNo = 704
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", valkyrieText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[34] )
		end
	elseif ( classNo == 25 ) then	-- 쿠노이치
		if ( titleNo == 0 ) then
			playedNo = 1001
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[50] )
		elseif ( titleNo == 1 ) then
			playedNo = 1002
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[51] )
		elseif ( titleNo == 2 ) then
			playedNo = 1003
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", ninjaWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[52] )
		elseif ( titleNo == 3 ) then
			playedNo = 1004
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", ninjaWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[53] )
		elseif ( titleNo == 4 ) then
			playedNo = 1005
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", ninjaWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[54] )
		end
	elseif ( classNo == 26 ) then	-- 닌자
		if ( titleNo == 0 ) then
			playedNo = 1100
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaManText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[55] )
		elseif ( titleNo == 1 ) then
			playedNo = 1101
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaManText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[56] )
		elseif ( titleNo == 2 ) then
			playedNo = 1102
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", ninjaManText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[57] )
		elseif ( titleNo == 3 ) then
			playedNo = 1103
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", ninjaManText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[58] )
		elseif ( titleNo == 4 ) then
			playedNo = 1104
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", ninjaManText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[59] )
		end
	elseif ( classNo == 28) then	-- 위치, 위자드
		if ( titleNo == 0 ) then
			playedNo = 900
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[40] )
		elseif ( titleNo == 1 ) then
			playedNo = 901
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[41] )
		elseif ( titleNo == 2 ) then
			playedNo = 902
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", wizardText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[42] )
		elseif ( titleNo == 3 ) then
			playedNo =903
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", wizardText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[43] )
		elseif ( titleNo == 4 ) then
			playedNo = 904
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", wizardText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[44] )
		end
	elseif ( classNo == 31 ) then	-- 위치, 위자드
		if ( titleNo == 0 ) then
			playedNo = 900
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[40] )
		elseif ( titleNo == 1 ) then
			playedNo = 901
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[41] )
		elseif ( titleNo == 2 ) then
			playedNo = 902
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", wizardWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[42] )
		elseif ( titleNo == 3 ) then
			playedNo = 903
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", wizardWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[43] )
		elseif ( titleNo == 4 ) then
			playedNo = 904
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", wizardWomenText ) )
			_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[44] )
		end
	end

	_comboList:SetShow( true )
	_comboList:SetSize( 635, _comboList:GetTextSizeY() + 7 )
	
	Panel_MovieTheater_SkillGuide_640:SetSize( 650, _movieTheater_640:GetSizeY() / 2 + _comboList:GetSizeY() + _btn_Replay:GetSizeY() + _comboList:GetSpanSize().y + 10 )
	
	_comboList:SetPosY( _movieTheater_640:GetSizeY() + 43 )
	_btn_Replay:SetPosY( ( Panel_MovieTheater_SkillGuide_640:GetSizeY() - _btn_Replay:GetSizeY() ) - 5 )
	
	Panel_MovieTheater_SkillGuide_640:SetPosX( ( getScreenSizeX() / 2 ) - ( Panel_MovieTheater_SkillGuide_640:GetSizeX() / 2 ) )
	Panel_MovieTheater_SkillGuide_640:SetPosY( ( getScreenSizeY() / 2 ) - ( Panel_MovieTheater_SkillGuide_640:GetSizeY() / 2 ) - 15 )
	
	_txt_Title:SetSize( Panel_MovieTheater_640:GetSizeX(), _txt_Title:GetSizeY() )
	_txt_Title:ComputePos()
	_btn_Close:ComputePos()
	_btn_Replay:SetPosX( ( Panel_MovieTheater_SkillGuide_640:GetSizeX() / 2 ) - ( _btn_Replay:GetSizeX() / 2 ) )
end


----------------------------------------------------------------
--				처음부터 버튼을 눌렀을 때!
----------------------------------------------------------------
-- function Panel_MovieTheater320_Replay()
function Panel_MovieTheater_SkillGuide_640_Replay()
	if (not _movieTheater_640:isReadyView()) then
		return
	end
	
	-- 워리어
	if ( playedNo == 100 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 101 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 102 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 103 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 104 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 레인저
	elseif ( playedNo == 200 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 201 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 202 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 203 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 204 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 소서러
	elseif ( playedNo == 300 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 301 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 302 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 303 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 304 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 자이언트
	elseif ( playedNo == 400 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 401 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 402 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 403 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 404 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	
	-- 금수랑
	elseif ( playedNo == 500 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 501 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 502 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 503 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 504 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 무사
	elseif ( playedNo == 600 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 601 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 602 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 603 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 604 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 매화
	elseif ( playedNo == 800 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 801 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 802 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 803 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 804 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 발키리
	elseif ( playedNo == 700 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 701 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 702 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 703 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 704 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 위치, 위자드
	elseif ( playedNo == 900 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 901 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 902 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 903 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 904 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 쿠노이치
	elseif ( playedNo == 1001 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1002 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1003 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1004 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1005 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 닌자
	elseif ( playedNo == 1100 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1101 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1102 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1103 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1104 ) then
		_movieTheater_640:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	end
end


function Panel_MovieTheater_SkillGuide_640_Clicked_Func( isYes )
	if ( isYes == true ) then
		value_GameOption_Check_ComboGuide:SetCheck( false )
		_currentSpiritGuideCheck = false
		
		Panel_MovieTheater_SkillGuide_640:SetShow( false )
		Panel_MovieTheater_MessageBox:SetShow( false )
	else
		Panel_MovieTheater_SkillGuide_640:SetShow( false )
		Panel_MovieTheater_MessageBox:SetShow( false )
	end
end

function Panel_MovieTheater_SkillGuide_640_ShowControl()
	_movieTheater_640:TriggerEvent( "ShowControl", "true")
end

function Panel_MovieTheater_SkillGuide_640_HideControl()
	_movieTheater_640:TriggerEvent( "ShowControl", "false")
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Panel_MovieTheater_SkillGuide_640_Initialize()
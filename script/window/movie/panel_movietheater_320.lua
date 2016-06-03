-------------------------------------------------------------------------------
-- 						퀵슬롯 스킬 연계 가이드
-------------------------------------------------------------------------------
local UI_TM			= CppEnums.TextMode

value_Panel_MovieTheater_320_IsCheckedShow = false

Panel_MovieTheater_320:ActiveMouseEventEffect( true )
Panel_MovieTheater_320:setGlassBackground( true )

Panel_MovieTheater_320:SetShow( false, false )
		-- 초기엔 반드시 셋팅 해줘야한다!

Panel_MovieTheater_320:RegisterShowEventFunc( true, 'Panel_MovieTheater320_ShowAni()' )
Panel_MovieTheater_320:RegisterShowEventFunc( false, 'PanelMovieTheater320_HideAni()' )
-----------------------------------------------------------
--					창 애니메이션 처리
-----------------------------------------------------------
function Panel_MovieTheater320_ShowAni()
	UIAni.AlphaAnimation( 1, Panel_MovieTheater_320, 0.0, 0.15 )
	Panel_MovieTheater_320:SetShow(true)
end

function Panel_MovieTheater320_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_MovieTheater_320, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local isMoviePlay			= false
local _btn_Close 			= UI.getChildControl ( Panel_MovieTheater_320, "Button_Close" )
local _btn_Replay 			= UI.getChildControl ( Panel_MovieTheater_320, "Button_Replay" )
local _btn_Nomore 			= UI.getChildControl ( Panel_MovieTheater_320, "Button_Nomore" )
local _txt_Title 			= UI.getChildControl ( Panel_MovieTheater_320, "StaticText_Title" )
local _movieTheater_320		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_MovieTheater_320, 'WebControl_SkillGuide' )

local helpBubble			= UI.getChildControl ( Panel_MovieTheater_320, "Static_HelpBubble" )
local helpMsg				= UI.getChildControl ( Panel_MovieTheater_320, "StaticText_HelpMsg" )

local _comboList			= UI.getChildControl ( Panel_MovieTheater_320, "StaticText_ComboList" )

local messageUI = {
	_messageBox 			= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Static_MessageBox" ),
	_message_Title 			= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Static_Text_Title" ),
	_messageText 			= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Static_Text" ),
	_btn_Yes 				= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Button_Yes" ),
	_btn_No 				= UI.getChildControl ( Panel_MovieTheater_MessageBox, "Button_No" ),
}

_btn_Close:addInputEvent( "Mouse_LUp", "Panel_MovieTheater320_JustClose()" )
_btn_Replay:addInputEvent( "Mouse_LUp", "Panel_MovieTheater320_Replay()" )
_btn_Nomore:addInputEvent( "Mouse_LUp", "Panel_MovieTheater320_MessageBox()" )
_movieTheater_320:addInputEvent( "Mouse_Out", "Panel_MovieTheater320_HideControl()" )
_movieTheater_320:addInputEvent( "Mouse_On", "Panel_MovieTheater320_ShowControl()" )
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--					최초 초기화 함수
------------------------------------------------------------
function Panel_MovieTheater320_Initialize()
	_movieTheater_320:SetPosX( 5 )
	_movieTheater_320:SetPosY( 38 )
	_movieTheater_320:ResetUrl()
	
	Panel_MovieTheater_320:SetSize( Panel_MovieTheater_320:GetSizeX(), 317 )
	
	Panel_MovieTheater320_ResetMessageBox()
end

function Panel_MovieTheater320_ResetMessageBox()
	Panel_MovieTheater_MessageBox:SetShow( false )
	for _, v in pairs ( messageUI ) do
		v:SetShow( false )
	end
end

-- local ComboMovieName = skillTypeSS:getComboMoviePath()

------------------------------------------------------------
--						기타 변수
------------------------------------------------------------
local playedNo = 0
local warriorText 		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WARRIORTEXT") -- 워리어
local rangerText 		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_RANGERTEXT") -- 레인저
local sorcererText 		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_SORCERERTEXT") -- 소서러
local giantText 		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_GIANTTEXT") -- 자이언트
local tamerText			= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_TAMERTEXT") -- 금수랑
local bladerText		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_BLADERTEXT") -- 무사
local valkyrieText		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_VALKYRIETEXT") -- 발키리
local bladerWomenText	= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_BLADERWOMENTEXT") -- 매화
local wizardWomenText	= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WIZARDWOMENTEXT") -- 위치
local wizardText		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_WIZARDTEXT") -- 위자드
local ninjaWomenText	= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_NINJAWOMENTEXT") -- 쿠노이치
local ninjaNanText		= PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_NINJAMANTEXT") -- 닌자

---------------------------------------------------------------------------------------
local comboDesc = {
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_0"),
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_1"),
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_2"),
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_3"),
	[16] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_16"),
	
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_4"),
	[5] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_5"),
	[6] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_6"),
	[7] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_7"),
	[17] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_17"),
	
	[8] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_8"),
	[9] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_9"),
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_10"),
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_11"),
	[18] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_18"),
	
	[12] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_12"),
	[13] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_13"),
	[14] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_14"),
	[15] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_15"),
	[19] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_19"),
	
	[20] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_20"),
	[21] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_21"),
	[22] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_22"),
	[23] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_23"),
	[24] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_24"),

	[25] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_25"),
	[26] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_26"),
	[27] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_27"),
	[28] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_28"),
	[29] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_29"),

	[30] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_30"),
	[31] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_31"),
	[32] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_32"),
	[33] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_33"),
	[34] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_34"),

	[35] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_35"),
	[36] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_36"),
	[37] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_37"),
	[38] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_38"),
	[39] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_39"),

	[40] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_40"),
	[41] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_41"),
	[42] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_42"),
	[43] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_43"),
	[44] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_44"),

	[45] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_45"),
	[46] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_46"),
	[47] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_47"),
	[48] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_48"),
	[49] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_49"),

	[50] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_45"),
	[51] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_46"),
	[52] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_47"),
	[53] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_50"),
	[54] = PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMBODESC_51"),

}


---------------------------------------------------------------------------------------

function Panel_MovieTheater320_JustClose()
	Panel_MovieTheater_320:SetShow ( false )
	_movieTheater_320:ResetUrl()
	isMoviePlay = false
end

------------------------------------------------------------
--					흑정령 위젯용 영상
------------------------------------------------------------
function Panel_MovieTheater320_ShowToggle()
	if ( Panel_MovieTheater_MessageBox:IsShow() == true ) then
		return
	end

	value_Panel_MovieTheater_320_IsCheckedShow = true
	
	local player = getSelfPlayer()
	if( nil == player ) then
		return
	end
		
	local UI_classType 	= CppEnums.ClassType
	local isWarrior 	= UI_classType.ClassType_Warrior			== player:getClassType()
	local isRanger 		= UI_classType.ClassType_Ranger				== player:getClassType()
	local isSorcerer 	= UI_classType.ClassType_Sorcerer			== player:getClassType()
	local isGiant 		= UI_classType.ClassType_Giant				== player:getClassType()
	local isTamer 		= UI_classType.ClassType_Tamer				== player:getClassType()
	local isBlader 		= UI_classType.ClassType_BladeMaster		== player:getClassType()
	local isValkyrie	= UI_classType.ClassType_Valkyrie			== player:getClassType()
	local isBladerWomen	= UI_classType.ClassType_BladeMasterWomen	== player:getClassType()
	local isWizard		= UI_classType.ClassType_Wizard				== player:getClassType()
	local isWizardWomen	= UI_classType.ClassType_WizardWomen		== player:getClassType()
	local isNinjaWomen	= UI_classType.ClassType_NinjaWomen			== player:getClassType()
	local isNinjaMan	= UI_classType.ClassType_NinjaMan			== player:getClassType()
	
	local playerGet = player:get()
	local playerLevel = playerGet:getLevel()
	local isShow = Panel_MovieTheater_320:IsShow()

	if ( 36 <= playerLevel or playerLevel <= 6 ) then
		return
	end

	if ( false == isShow ) then
		_movieTheater_320:SetUrl(320, 240, "coui://UI_Data/UI_Html/UI_Guide_Movie.html")
	end
	
	helpBubble:SetShow( true )
	helpMsg:SetShow( true )

	helpMsg:SetAutoResize( true )
	helpMsg:SetTextMode( UI_TM.eTextMode_AutoWrap )
	
	if ( isWarrior == true ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISWARRIOR") ) -- "발크스 교관 추천 교본, '전장의 불꽃 연속 기술'!\n[기술] 창에서 더 큰 영상으로 확인할 수 있습니다." )
	elseif ( isRanger == true ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISRANGER") ) -- "마가렛 교관 추천 교본, '바람 정령의 연속 기술'!\n[기술] 창에서 더 큰 영상으로 확인할 수 있습니다." )
	elseif ( isSorcerer == true ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISSORCERER") ) -- "엘라 세르빈 교관 추천 교본, '깊은 어둠의 연속 기술'!\n[기술] 창에서 더 큰 영상으로 확인할 수 있습니다." )
	elseif ( isGiant == true ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISGIANT") ) -- "타크로스 교관 추천 교본, '사나운 짐승의 연속 기술'!\n[기술] 창에서 더 큰 영상으로 확인할 수 있습니다." )
	elseif ( isTamer == true ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISTAMER") ) -- "크록서스 교관 추천 교본, '사나운 짐승의 연속 기술'!\n[기술] 창에서 더 큰 영상으로 확인할 수 있습니다." )
	elseif (isBlader == true ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISBLADER") )
	elseif (isValkyrie == true ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISVALKYRIE") )
	elseif (isBladerWomen == true ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISBLADERWOMEN") )
	elseif (true == isWizard or true == isWizardWomen ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISWIZARD") )
	elseif (true == isNinjaWomen ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISNINJAWOMEN") )
	elseif (true == isNinjaMan ) then
		helpMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_ISNINJAMAN") )
	end
	
	helpBubble:SetSize( helpBubble:GetSizeX(), ( helpMsg:GetTextSizeY() + 35 ) )

	_movieTheater_320:SetSize( 320, 240 )
	
	Panel_MovieTheater_320:SetShow( true, false )
	
	_comboList:SetSize( 315, _comboList:GetTextSizeY() + 7 )
	_comboList:SetTextMode( UI_TM.eTextMode_AutoWrap )

	_comboList:SetPosY( 283 )
	_comboList:SetSize( 315, _comboList:GetTextSizeY() + 7 )
	
	_btn_Replay:SetPosY( _comboList:GetSizeY() + _comboList:GetSpanSize().y + 3 )
	_btn_Nomore:SetPosY( _comboList:GetSizeY() + _comboList:GetSpanSize().y + 3 )
	Panel_MovieTheater_320:SetSize( 330, _comboList:GetSizeY() + _btn_Replay:GetSizeY() + _comboList:GetSpanSize().y + 10 )
	Panel_MovieTheater_320:SetPosX( getScreenSizeX() - Panel_MovieTheater_320:GetSizeX() - 7 )
	Panel_MovieTheater_320:SetPosY( getScreenSizeY() - Panel_MovieTheater_320:GetSizeY() - Panel_QuickSlot:GetSizeY() )
	
	_txt_Title:SetSize( Panel_MovieTheater_320:GetSizeX(), _txt_Title:GetSizeY() )
	_txt_Title:ComputePos()
	_btn_Close:ComputePos()
	_btn_Replay:SetPosX( ( Panel_MovieTheater_320:GetSizeX() / 2 ) - ( _btn_Replay:GetSizeX() / 2 ) + 70 )
	_btn_Replay:addInputEvent( "Mouse_LUp", "Panel_MovieTheater320_Replay()" )
	
	_btn_Nomore:SetShow( true )
	_btn_Nomore:SetPosX( ( Panel_MovieTheater_320:GetSizeX() / 2 ) - ( _btn_Replay:GetSizeX() / 2 ) - 70 )

	isMoviePlay = true
end


function Panel_MovieTheater320_TriggerEvent()	
	local player = getSelfPlayer()
	if( nil == player ) then
		return
	end
	
	local UI_classType 	= CppEnums.ClassType
	local isWarrior 	= UI_classType.ClassType_Warrior			== player:getClassType()
	local isRanger 		= UI_classType.ClassType_Ranger				== player:getClassType()
	local isSorcerer 	= UI_classType.ClassType_Sorcerer			== player:getClassType()
	local isGiant 		= UI_classType.ClassType_Giant				== player:getClassType()
	local isTamer 		= UI_classType.ClassType_Tamer				== player:getClassType()
	local isBlader 		= UI_classType.ClassType_BladeMaster		== player:getClassType()
	local isValkyrie	= UI_classType.ClassType_Valkyrie			== player:getClassType()
	local isBladerWomen	= UI_classType.ClassType_BladeMasterWomen	== player:getClassType()
	local isWizard		= UI_classType.ClassType_Wizard				== player:getClassType()
	local isWizardWomen	= UI_classType.ClassType_WizardWomen		== player:getClassType()
	local isNinjaWomen	= UI_classType.ClassType_NinjaWomen			== player:getClassType()
	local isNinjaMan	= UI_classType.ClassType_NinjaMan			== player:getClassType()
	
	local playerGet = player:get()
	local playerLevel = playerGet:getLevel()
	
	if ( isWarrior ) then		-- 워리어
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/100.webm")
			_comboList:SetText( comboDesc[0] )
			playedNo = 100
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/101.webm")
			_comboList:SetText( comboDesc[1] )
			playedNo = 101
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/102.webm")
			_comboList:SetText( comboDesc[2] )
			playedNo = 102
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/103.webm")
			_comboList:SetText( comboDesc[3] )
			playedNo = 103
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", warriorText ) ) -- warriorText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/104.webm")
			_comboList:SetText( comboDesc[16] )
			playedNo = 104
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end
		
	elseif ( isRanger ) then	-- 레인저
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/200.webm")
			_comboList:SetText( comboDesc[4] )
			playedNo = 200
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/201.webm")
			_comboList:SetText( comboDesc[5] )
			playedNo = 201
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/202.webm")
			_comboList:SetText( comboDesc[6] )
			playedNo = 202
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/203.webm")
			_comboList:SetText( comboDesc[7] )
			playedNo = 203
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", rangerText ) ) -- rangerText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/204.webm")
			_comboList:SetText( comboDesc[17] )
			playedNo = 204
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end
		
	elseif ( isSorcerer ) then	-- 소서러
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/300.webm")
			_comboList:SetText( comboDesc[8] )
			playedNo = 300
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/301.webm")
			_comboList:SetText( comboDesc[9] )
			playedNo = 301
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/302.webm")
			_comboList:SetText( comboDesc[10] )
			playedNo = 302
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/303.webm")
			_comboList:SetText( comboDesc[11] )
			playedNo = 303
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", sorcererText ) ) -- sorcererText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/304.webm")
			_comboList:SetText( comboDesc[18] )
			playedNo = 304
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end

	elseif ( isGiant ) then	-- 자이언트
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/400.webm")
			_comboList:SetText( comboDesc[12] )
			playedNo = 400
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/401.webm")
			_comboList:SetText( comboDesc[13] )
			playedNo = 401
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/402.webm")
			_comboList:SetText( comboDesc[14] )
			playedNo = 402
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/403.webm")
			_comboList:SetText( comboDesc[15] )
			playedNo = 403
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", giantText ) ) -- giantText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/404.webm")
			_comboList:SetText( comboDesc[19] )
			playedNo = 404
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end

	elseif ( isTamer ) then	-- 금수랑
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			playedNo = 500
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[20] )
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			playedNo = 501
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[21] )
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			playedNo = 502
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[22] )
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			playedNo = 503
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[23] )
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			playedNo = 504
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", tamerText ) ) -- tamerText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[24] )
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end
		
	elseif ( isBlader ) then	-- 무사
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			playedNo = 600
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText ) ) -- bladerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[25] )
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			playedNo = 601
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText ) ) -- bladerText .. "기술 연계 가이드 - 중급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[26] )
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			playedNo = 602
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerText ) ) -- bladerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[27] )
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			playedNo = 603
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", bladerText ) ) -- bladerText .. "기술 연계 가이드 - 상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[28] )
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			playedNo = 604
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", bladerText ) ) -- bladerText .. "기술 연계 가이드 - 최상급" )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[29] )
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end
		
	elseif ( isValkyrie ) then	-- 발키리
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			playedNo = 700
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", valkyrieText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[30] )
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			playedNo = 701
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", valkyrieText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[31] )
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			playedNo = 702
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", valkyrieText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[32] )
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			playedNo = 703
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", valkyrieText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[33] )
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			playedNo = 704
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", valkyrieText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[34] )
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end

	elseif ( isBladerWomen ) then	-- 매화(여자 무사)
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			playedNo = 800
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", bladerWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[35] )
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			playedNo = 801
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", bladerWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[36] )
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			playedNo = 802
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", bladerWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[37] )
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			playedNo = 803
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", bladerWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[38] )
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			playedNo = 804
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", bladerWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[39] )
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end

	elseif ( isWizard ) then	-- 위자드
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			playedNo = 900
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[40] )
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			playedNo = 901
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[41] )
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			playedNo = 902
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", wizardText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[42] )
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			playedNo = 903
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", wizardText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[43] )
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			playedNo = 904
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", wizardText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[44] )
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end

	elseif ( isWizardWomen ) then	-- 위치(여자 위자드)
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			playedNo = 900
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[40] )
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			playedNo = 901
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", wizardWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[41] )
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			playedNo = 902
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", wizardWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[42] )
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			playedNo = 903
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", wizardWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[43] )
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			playedNo = 904
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", wizardWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[44] )
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end

	elseif ( isNinjaWomen ) then	-- 쿠노이치
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			playedNo = 1001
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[45] )
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			playedNo = 1002
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[46] )
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			playedNo = 1003
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", ninjaWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[47] )
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			playedNo = 1004
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", ninjaWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[48] )
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			playedNo = 1005
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", ninjaWomenText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[49] )
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end

	elseif ( isNinjaMan ) then	-- 닌자
		if ( playerLevel <= 6 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		elseif ( playerLevel >= 7 ) and ( playerLevel <= 15 ) then
			playedNo = 1100
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaManText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo .. ".webm")
			_comboList:SetText( comboDesc[45] )
		elseif ( playerLevel >= 16 ) and ( playerLevel <= 20 ) then
			playedNo = 1101
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_LOW", "getText", ninjaManText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[46] )
		elseif ( playerLevel >= 21 ) and ( playerLevel <= 25 ) then
			playedNo = 1102
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_MIDDLE", "getText", ninjaManText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[47] )
		elseif ( playerLevel >= 26 ) and ( playerLevel <= 30 ) then
			playedNo = 1103
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGH", "getText", ninjaManText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[50] )
		elseif ( playerLevel >= 31 ) and ( playerLevel <= 35 ) then
			playedNo = 1104
			_txt_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_MOVEITHEATER_320_COMMON_LINK_HIGHTOP", "getText", ninjaManText ) )
			_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
			_comboList:SetText( comboDesc[51] )
		elseif ( playerLevel >= 36 ) then
			Panel_MovieTheater_320:SetShow( false, false )
			helpBubble:SetShow( false )
			helpMsg:SetShow( false )
		end
	end
end


----------------------------------------------------------------
--				처음부터 버튼을 눌렀을 때!
----------------------------------------------------------------
function Panel_MovieTheater320_Replay()
	-- 워리어
	if ( playedNo == 100 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 101 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 102 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 103 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 104 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 레인저
	elseif ( playedNo == 200 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 201 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 202 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 203 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 204 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 소서러
	elseif ( playedNo == 300 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 301 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 302 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 303 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 304 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 자이언트
	elseif ( playedNo == 400 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 401 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 402 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 403 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 404 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
		
	-- 금수랑
	elseif ( playedNo == 500 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 501 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 502 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 503 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 504 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 무사
	elseif ( playedNo == 600 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 601 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 602 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 603 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 604 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 발키리
	elseif ( playedNo == 700 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 701 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 702 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 703 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 704 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 매화
	elseif ( playedNo == 800 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 801 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 802 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 803 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 804 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 위자드, 위치(여자 위자드)
	elseif ( playedNo == 900 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 901 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 902 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 903 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 904 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 쿠노이치
	elseif ( playedNo == 1001 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1002 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1003 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1004 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1005 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	-- 쿠노이치
	elseif ( playedNo == 1100 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1101 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1102 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1103 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")
	elseif ( playedNo == 1104 ) then
		_movieTheater_320:TriggerEvent("PlayMovie", "coui://UI_Movie/Movie_Pc_Skill/11_Common_ComboGuide/" .. playedNo  ..".webm")

	end
end

----------------------------------------------------------------
--				7번 껐으니까, 미래를 선택하여라
----------------------------------------------------------------
function Panel_MovieTheater320_MessageBox()
	Panel_MovieTheater_320:SetShow( true )
	isComboMovieClosedCount = 0
	value_Panel_MovieTheater_320_IsCheckedShow = false
	
	Panel_MovieTheater_MessageBox:SetPosX( getScreenSizeX() - Panel_MovieTheater_MessageBox:GetSizeX() - 7 )
	Panel_MovieTheater_MessageBox:SetPosY( getScreenSizeY() - Panel_MovieTheater_320:GetSizeY() - Panel_QuickSlot:GetSizeY() )

	Panel_MovieTheater_MessageBox:SetShow( true )
	
	for _, v in pairs ( messageUI ) do
		v:SetShow( true )
		v:ComputePos()
	end

	messageUI._btn_Yes:addInputEvent( "Mouse_LUp", "Panel_MovieTheater320_Clicked_Func( true )" )
	messageUI._btn_No:addInputEvent( "Mouse_LUp", "Panel_MovieTheater320_Clicked_Func( false )" )
end

function Panel_MovieTheater320_Clicked_Func( isYes )
	if ( isYes == true ) then
		value_GameOption_Check_ComboGuide:SetCheck( false )
		setShowComboGuide( false )
		GameOption_UpdateOptionChanged()
		_currentSpiritGuideCheck = false
		saveGameOption(false)
		
		Panel_MovieTheater_320:SetShow( false )
		Panel_MovieTheater_MessageBox:SetShow( false )
	else
		Panel_MovieTheater_320:SetShow( false )
		Panel_MovieTheater_MessageBox:SetShow( false )
	end
	
	_movieTheater_320:ResetUrl()
	isMoviePlay = false
end

local updateTime = 0.0
function UpdateMovieTheater320(deltaTime)
	if (not isMoviePlay) then
		return
	end

	updateTime = updateTime + deltaTime
	
	-- View가 준비 된 후 Trigger Event까지 약간의 시간이 소요됨으로 인해 0.5초 후 재생되도록 한다.
	if 0.5 < updateTime then
		if(_movieTheater_320:isReadyView()) then
			Panel_MovieTheater320_TriggerEvent()
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

function Panel_MovieTheater320_ShowControl()
	_movieTheater_320:TriggerEvent( "ShowControl", "true")
end

function Panel_MovieTheater320_HideControl()
	_movieTheater_320:TriggerEvent( "ShowControl", "false")
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
Panel_MovieTheater320_Initialize()

Panel_MovieTheater_320:RegisterUpdateFunc("UpdateMovieTheater320")
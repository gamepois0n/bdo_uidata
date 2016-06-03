Panel_Cutscene:SetPosX( 0 )
Panel_Cutscene:SetPosY( 0 )
Panel_Cutscene:SetShow(false, false)
Panel_Cutscene:SetSize( getScreenSizeX(), getScreenSizeY() )
Panel_Cutscene:SetIgnore(true)

local Static_LatterBoxTop		= UI.getChildControl( Panel_Cutscene, "Static_LetterBoxTop" )
local Static_LatterBoxBottom	= UI.getChildControl( Panel_Cutscene, "Static_LetterBoxBottom" )
local Static_LetterBoxLeft		= UI.getChildControl( Panel_Cutscene, "Static_LetterBoxLeft" )
local Static_LetterBoxRight		= UI.getChildControl( Panel_Cutscene, "Static_LetterBoxRight" )
local Static_FadeScreen			= UI.getChildControl( Panel_Cutscene, "Static_FadeScreen" )
local Multiline_Subtitle		= UI.getChildControl( Panel_Cutscene, "MultilineText_Subtitle" )
local Static_SupportVoice		= UI.getChildControl( Panel_Cutscene, "StaticText_SupportVoice" )

local IM = CppEnums.EProcessorInputMode
local UIMode = Defines.UIMode
local prevUIMode = UIMode.eUIMode_Default;

Panel_Cutscene:RegisterUpdateFunc("Update_Subtitle")

function Update_Subtitle( deltaTime )
	if( isSubtitleDelete == false ) then
		subtitleTimer = subtitleTimer + deltaTime
		if( subtitleTimer > subtitleDeleteTime ) then
			subtitleTimer = 0.0
			subtitleDeleteTime = 0.0
			isSubtitleDelete = true
			Multiline_Subtitle:SetText("")
		end
	end
end

function FromClient_PlayCutScene( cutSceneName, isFromServer, isFlush )
	ToClient_SaveUiInfo( true )
	-- 화면 없애기
	crossHair_SetShow(false)

	prevUIMode = GetUIMode();

	SetUIMode(Defines.UIMode.eUIMode_Cutscene)
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)

	if( isFlush ) then
		UI.flushAndClearUI()
	end

	Panel_SkillCommand:SetShow(false)
	
	Panel_Cutscene:SetSize( getScreenSizeX(), getScreenSizeY() )
	Panel_Cutscene:SetShow( true )

	ToClient_CutscenePlay(cutSceneName, isFromServer)

	local latterHeight = (getScreenSizeY() -( (720.0 / 1280.0) * getScreenSizeX() ) ) / 2
	local letterWidth = (getScreenSizeX() - ( (1280.0 / 720.0) * getScreenSizeY() ) ) / 2
	
	if( latterHeight < 0 ) then
		latterHeight = 0
	end
	
	if( letterWidth < 0 ) then
		letterWidth = 0
	end

	Static_FadeScreen:SetShow( true )
	Static_FadeScreen:SetSize( getScreenSizeX(), getScreenSizeY() )
	Static_FadeScreen:ComputePos()
	
	Static_LatterBoxTop:SetShow( true )
	Static_LatterBoxTop:SetSize( getScreenSizeX(), latterHeight )
	Static_LatterBoxTop:ComputePos()

	Static_LatterBoxBottom:SetShow( true )
	Static_LatterBoxBottom:SetSize( getScreenSizeX(), latterHeight )
	Static_LatterBoxBottom:ComputePos()
	
	Static_LetterBoxLeft:SetShow( true )
	Static_LetterBoxLeft:SetSize( letterWidth, getScreenSizeX() )
	Static_LetterBoxLeft:ComputePos()
	
	Static_LetterBoxRight:SetShow( true )
	Static_LetterBoxRight:SetSize( letterWidth, getScreenSizeX() )
	Static_LetterBoxRight:ComputePos()

	-- if FGlobal_IsCommercialService() then	-- #724316 북미 이슈로 검토 후 삭제. 15년 12월 서비스 직전에 처리하고, 16년 2월 28일에 제거.
		Static_SupportVoice:SetShow( false )
	-- else
	-- 	Static_SupportVoice:SetShow( true )
	-- 	Static_SupportVoice:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CUTSCENE_SUPPORTVOICE") )
	-- end
	Static_SupportVoice:ComputePos()
	
	Multiline_Subtitle:SetText("")
	Multiline_Subtitle:SetSize( getScreenSizeX(), Multiline_Subtitle:GetSizeY() )
	Multiline_Subtitle:SetSpanSize( 0, latterHeight+10 )
	Multiline_Subtitle:ComputePos()
end

function FromClient_StopCutScene(isRestore)
	-- 연출 
	Multiline_Subtitle:SetText("")
	Static_LatterBoxTop:SetShow( false )
	Static_LatterBoxBottom:SetShow( false )
	Static_LetterBoxRight:SetShow( false )
	Static_LetterBoxLeft:SetShow( false )
	Panel_Cutscene:SetShow( false )
	Static_FadeScreen:SetShow( false )

	if( prevUIMode ~= Defines.UIMode.eUIMode_Cutscene ) then
		SetUIMode( prevUIMode )
	end
	UI.restoreFlushedUI()		 
	crossHair_SetShow(true);
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
	postProcessMessageData()
end

-- 자막 세팅
function FromClient_SetSubtitle( subtitle, Time )
	Multiline_Subtitle:SetText( subtitle )
	subtitleTimer = 0
	subtitleDeleteTime = Time
	isSubtitleDelete = false
end

function FromClient_SetScreenAlpha( value )
	Static_FadeScreen:SetAlpha( value )
end


registerEvent("FromClient_PlayCutScene", "FromClient_PlayCutScene")
registerEvent("FromClient_StopCutScene", "FromClient_StopCutScene")
registerEvent("FromClient_SetScreenAlpha", "FromClient_SetScreenAlpha")
registerEvent("FromClient_SetSubtitle", "FromClient_SetSubtitle")
Panel_Cutscene:RegisterUpdateFunc("Update_Subtitle")

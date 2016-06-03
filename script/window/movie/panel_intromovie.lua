-------------------------------
-- Panel Init
-------------------------------
Panel_IntroMovie:SetShow(false, false)

local updateTime 	= 0.0
local static_IntroMovie	= nil
local IM 			= CppEnums.EProcessorInputMode
isIntroMoviePlaying 	= false;

function InitIntroMoviePanel()
	local selfPlayerWrapper = getSelfPlayer()
	if nil == selfPlayerWrapper then
		return
	end
	local selfPlayerLevel = selfPlayerWrapper:get():getLevel()
	local selfPlayerExp = selfPlayerWrapper:get():getExp_s64()
	if (1 == selfPlayerLevel ) and ( Defines.s64_const.s64_0 == selfPlayerExp ) and ( false == isSwapCharacter() ) then
		if static_IntroMovie == nil then
			ShowableFirstExperience(false);
			--setEnableSound( false, false, false )
			--getMasterVolume()	볼륨도 셋팅해주자
			Panel_IntroMovie:SetShow(true, false)	
		    --UI.flushAndClearUI()
			local sizeX = getScreenSizeX()
			local sizeY = getScreenSizeY()
			
			local movieSizeX = sizeX
 			local movieSizeY = sizeX * 9 / 16
			
			local posX = 0
			local posY = 0
			
			if (movieSizeY <= sizeY) then
				posY = (sizeY - movieSizeY) / 2
			else
				movieSizeX = sizeY * 16 / 9
				movieSizeY = sizeY
				posX = (sizeX - movieSizeX) / 2
			end
			
			Panel_IntroMovie:SetSize(sizeX, sizeY)
			static_IntroMovie			= UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_IntroMovie, 'WebControl_Movie')
			static_IntroMovie:SetIgnore(false)
			static_IntroMovie:SetPosX(posX)
			static_IntroMovie:SetPosY(posY)
			static_IntroMovie:SetSize(movieSizeX, movieSizeY)
			static_IntroMovie:SetUrl(1280, 720, "coui://UI_Data/UI_Html/Intro_Movie.html")
			isIntroMoviePlaying = true
		end
	end
end

function CloseIntroMovie()
	if static_IntroMovie ~= nil then
		static_IntroMovie:TriggerEvent("StopMovie", "")
		static_IntroMovie:SetShow(false)
		static_IntroMovie = nil		
	end
	--setEnableSound( true, true, true )	
	Panel_IntroMovie:SetShow(false, false)
	--ShowKeyboard()
	isIntroMoviePlaying = false
	SetUIMode( Defines.UIMode.eUIMode_Default )
	setMoviePlayMode(false)
	
	ShowableFirstExperience(true);
	--UI.restoreFlushedUI()
end

local updateTime = 0.0
function UpdateIntroMovie(deltaTime)
	if(isIntroMoviePlaying) then
		updateTime = updateTime + deltaTime
		
		if(static_IntroMovie:isReadyView()) then
			ShowIntroMovie()
		end

		if 20 < updateTime then
			isIntroMoviePlaying = false
		end
	end	
end

function ShowIntroMovie()
	static_IntroMovie:TriggerEvent("PlayMovie", "")
	setMoviePlayMode(true)
end

function ToClient_EndIntroMovie(movieId)
	if (movieId == 1) then
		if Panel_IntroMovie:IsShow() then
			toClient_FadeIn(1.0);
			CloseIntroMovie()
		end
	end
end

InitIntroMoviePanel()

Panel_IntroMovie:RegisterUpdateFunc("UpdateIntroMovie")

registerEvent( "ToClient_EndGuideMovie", 			"ToClient_EndIntroMovie")
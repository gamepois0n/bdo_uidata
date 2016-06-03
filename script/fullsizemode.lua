FullSizeMode = {}

FullSizeMode.isFullSizeWindowOn	= false		--	true면 최대화 , false면 아님.
FullSizeMode.fullSizeWindow		= 0			--	fullsize윈도우를 등록한다. ( isFullSizeWindowOn == true 일때만 의미있는 값을 가진다. )

FullSizeMode.fullSizeModeEnum = {				--  setFullSizeMode를 쓰는 모든 곳에서 쓴다.
	Worldmap				= 0,
	MentalKnowledge			= 1,
	Intimacy				= 2,
	Dialog					= 3,
}

function setFullSizeMode( isFull, fullSizePanel )
	FullSizeMode.isFullSizeWindowOn = isFull
	if ( isFull ) then
		FullSizeMode.fullSizeWindow = fullSizePanel
	end
end

function isFullSizeModeAble( fullSizePanel )
	if ( not FullSizeMode.isFullSizeWindowOn ) then
		return true
	else
		return ( FullSizeMode.fullSizeWindow == fullSizePanel )
	end
end
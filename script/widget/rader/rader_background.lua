Panel_RadarRealLine =
{
	panel = nil,
	mapImage = {},
	desertMapImage = {},
	maxAlphaDesert = 0,
}

local const =
{
	imageSize = 256,
	size = 5, --홀수만 해야함.
}
local currentPosition = int3(0,0,0)
local currentRate = 0
local currentSelfPos = { x = 0, y = 0 }
local currentAlpha = 1.0


function RadarMap_Init()
	Panel_RadarRealLine.panel = Panel_Radar;

	for index = 0, const.size * const.size -1 do
		Panel_RadarRealLine.mapImage[index] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Radar, "Static_minimap_Image_".. index )
		Panel_RadarRealLine.mapImage[index]:SetShow(true)
		Panel_RadarRealLine.mapImage[index]:SetSize( const.imageSize , const.imageSize )
		Panel_RadarRealLine.mapImage[index]:SetIgnore(true)
		Panel_RadarRealLine.mapImage[index]:SetPosX( index % const.size * const.imageSize )
		Panel_RadarRealLine.mapImage[index]:SetPosY( math.floor(index / const.size) * const.imageSize )
		Panel_RadarRealLine.mapImage[index]:SetColor(Defines.Color.C_FFFFFFFF)
		Panel_RadarRealLine.mapImage[index]:SetDepth(2)
		Panel_RadarRealLine.panel:SetChildIndex( Panel_RadarRealLine.mapImage[index], index )
	end
	for index = 0, const.size * const.size -1 do
		Panel_RadarRealLine.desertMapImage[index] = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Radar, "Static_minimap_ImageDesert_".. index )
		Panel_RadarRealLine.desertMapImage[index]:SetShow(false)
		Panel_RadarRealLine.desertMapImage[index]:SetSize( const.imageSize , const.imageSize )
		Panel_RadarRealLine.desertMapImage[index]:SetIgnore(true)
		Panel_RadarRealLine.desertMapImage[index]:SetPosX( index % const.size * const.imageSize )
		Panel_RadarRealLine.desertMapImage[index]:SetPosY( math.floor(index / const.size) * const.imageSize )
		Panel_RadarRealLine.desertMapImage[index]:SetColor(Defines.Color.C_FFFFFFFF)
		Panel_RadarRealLine.desertMapImage[index]:SetDepth(1)
		Panel_RadarRealLine.panel:SetChildIndex( Panel_RadarRealLine.desertMapImage[index], index + const.size * const.size)
	end

	local selfPlayerWrapper = getSelfPlayer()
	if ( nil == selfPlayerWrapper ) then
		return
	end
	
	local regionInfoWrapper = selfPlayerWrapper:getRegionInfoWrapper()
	if ( nil == regionInfoWrapper ) then
		return
	end
	
	if ( regionInfoWrapper:isDesert() and (false == selfPlayerWrapper:isResistDesert()) ) then
		Panel_RadarRealLine.maxAlphaDesert = 1
		for key, value in pairs(Panel_RadarRealLine.desertMapImage) do
			value:SetShow(true)
			value:SetAlpha(1)
		end
	else
		Panel_RadarRealLine.maxAlphaDesert = 0
		for key, value in pairs(Panel_RadarRealLine.desertMapImage) do
			value:SetShow(false)
			value:SetAlpha(0)
		end
	end
end

local updatePanel = function()
	if getEnableSimpleUI() then
		local isUiMode = (CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode == getInputMode() or CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == getInputMode());
		
		local IsMouseOver = 	Panel_Radar:GetPosX() < getMousePosX() and getMousePosX() < Panel_Radar:GetPosX() + Panel_Radar:GetSizeX() and
								Panel_Radar:GetPosY() < getMousePosY() and getMousePosY() < Panel_Radar:GetPosY() + Panel_Radar:GetSizeY();	
		
		if isUiMode then
			isUiMode = IsMouseOver;
		end
	end
end


local updateMapImage = function( position, deltaTime )	
	local prevMaxAlpha = Panel_RadarRealLine.maxAlphaDesert
	if ( getSelfPlayer():getRegionInfoWrapper():isDesert() and (false == getSelfPlayer():isResistDesert()) ) then
		Panel_RadarRealLine.maxAlphaDesert = Panel_RadarRealLine.maxAlphaDesert + deltaTime / 2
		if ( 1 < Panel_RadarRealLine.maxAlphaDesert ) then
			Panel_RadarRealLine.maxAlphaDesert = 1
		end
		for key, value in pairs(Panel_RadarRealLine.desertMapImage) do
			value:SetShow(true)
			value:SetAlpha(Panel_RadarRealLine.maxAlphaDesert * currentAlpha)
		end
	else
		if ( 0 < Panel_RadarRealLine.maxAlphaDesert ) then
			Panel_RadarRealLine.maxAlphaDesert = Panel_RadarRealLine.maxAlphaDesert - deltaTime / 2
			if ( Panel_RadarRealLine.maxAlphaDesert < 0 ) then
				Panel_RadarRealLine.maxAlphaDesert = 0
			end
			for key, value in pairs(Panel_RadarRealLine.desertMapImage) do
				value:SetShow(true)
				value:SetAlpha(Panel_RadarRealLine.maxAlphaDesert * currentAlpha)
			end
		else
			for key, value in pairs(Panel_RadarRealLine.desertMapImage) do
				value:SetShow(false)
				value:SetAlpha(0)
			end
		end
	end

	if		( position.x == currentPosition.x ) 
		and ( position.z == currentPosition.z ) 
		and ( currentRate == RaderMap_GetDistanceToPixelRate() ) 
		and ( currentSelfPos.x == RaderMap_GetSelfPosInRader().x ) 
		and ( currentSelfPos.y == RaderMap_GetSelfPosInRader().y ) 
		and ( Panel_RadarRealLine.maxAlphaDesert == prevMaxAlpha ) 
		then
		return
	end
	currentSelfPos = { x = RaderMap_GetSelfPosInRader().x , y = RaderMap_GetSelfPosInRader().y }

	currentRate = RaderMap_GetDistanceToPixelRate()
	const.imageSize =  math.floor(currentRate * 256)

	currentPosition = position
	local currentSector = convertPosToSector(currentPosition)
	int3Value.y = 0 --y축 쓰지않음
	local inSectorPos = convertPosToInSectorPos(currentPosition)

	local startX = math.floor( -( (inSectorPos.x / 100 ) * currentRate ) * 2 - const.imageSize * 2 + currentSelfPos.x  )
	local startY = math.floor( ( inSectorPos.z / 100 * currentRate ) * 2 - const.imageSize * 3 + currentSelfPos.y )
	
	for index = 0, const.size * const.size - 1 do
		local filePath = ToClient_getRadarPath() .. "Rader_" .. currentSector.x -( math.floor(const.size / 2) ) + ( index % const.size ) .. "_" .. currentSector.z +math.floor(const.size / 2) - math.floor(index / const.size ) .. ".dds"		
		Panel_RadarRealLine.mapImage[index]:ChangeTextureInfoName(filePath)
		Panel_RadarRealLine.mapImage[index]:SetPosX( startX + index % const.size * const.imageSize )		
		Panel_RadarRealLine.mapImage[index]:SetPosY( startY + math.floor( index / const.size) * const.imageSize )
		Panel_RadarRealLine.mapImage[index]:SetSize( const.imageSize, const.imageSize)	
		Panel_RadarRealLine.mapImage[index]:SetAlpha( (1 - Panel_RadarRealLine.maxAlphaDesert) * currentAlpha );
		Panel_RadarRealLine.mapImage[index]:SetShow(true)

		local xValue = (currentSector.x + index) % const.size
		local zValue = const.size - ((currentSector.z - math.floor(index / const.size ) ) % const.size) -1

		Panel_RadarRealLine.desertMapImage[index]:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Rader/Rader_Desert_".. xValue .. "_" .. zValue .. ".dds")
		Panel_RadarRealLine.desertMapImage[index]:SetPosX( startX + index % const.size * const.imageSize )		
		Panel_RadarRealLine.desertMapImage[index]:SetPosY( startY + math.floor( index / const.size) * const.imageSize )
		Panel_RadarRealLine.desertMapImage[index]:SetSize( const.imageSize, const.imageSize)	
	end
end

function RaderBackground_updatePerFrame( deltaTime )
	local selfPlayer = getSelfPlayer()
	if ( nil == selfPlayer ) then
		return
	end

	updatePanel()
	updateMapImage(selfPlayer:get():getPosition(), deltaTime)
end

function FGlobal_Panel_RadarRealLine_Show( isShow )
	
	Panel_RadarRealLine.panel:SetShow(isShow)

end

function RaderBackground_Show()
	Panel_RadarRealLine.panel:SetShow(true)
end

function RaderBackground_Hide()
	Panel_RadarRealLine.panel:SetShow(false)
end

function RadarBackground_SetRotateMode( isRotateMode )
	for index = 0, const.size * const.size - 1 do
		Panel_RadarRealLine.mapImage[index]:SetParentRotCalc(isRotateMode)	
	end
end
function RaderMapBG_SetAlphaValue( alpha )
	local isShowFront = true
	if ( 1 <= Panel_RadarRealLine.maxAlphaDesert ) then
		isShowFront = false
	end	
	currentAlpha = alpha;
	for index = 0, const.size * const.size -1 do
		Panel_RadarRealLine.mapImage[index]:SetAlpha( (1 - Panel_RadarRealLine.maxAlphaDesert) * currentAlpha )
		Panel_RadarRealLine.mapImage[index]:SetShow(isShowFront)
	end
	
end

function RadarMapBG_EnableSimpleUI_Force_Over()
	RadarMapBG_EnableSimpleUI( true );
end
function RadarMapBG_EnableSimpleUI_Force_Out()
	RadarMapBG_EnableSimpleUI( false );
end
registerEvent( "EventSimpleUIEnable",			"RadarMapBG_EnableSimpleUI_Force_Over")
registerEvent( "EventSimpleUIDisable",			"RadarMapBG_EnableSimpleUI_Force_Out")

function RadarMapBG_EnableSimpleUI(isEnable)
	cacheSimpleUI_ShowButton = true;
end

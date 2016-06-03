local isMovableMode = false

-- 게임 모드로 변경
function FromClient_SetGameUIMode()
	SetUIMode( Defines.UIMode.eUIMode_Default )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
	Panel_SkillCommand:SetShow( false )
end

function checkAndSetPosInScreen(panel)
	local posX = panel:GetPosX()
	local posY = panel:GetPosY()
	local sizeX = panel:GetSizeX()
	local sizeY = panel:GetSizeY()
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()

	if ( posX < 0 ) then
		panel:SetPosX(0)
	elseif ( screenSizeX - sizeX < posX ) then
		panel:SetPosX(screenSizeX - sizeX)
	end

	if ( posY < 0 ) then
		panel:SetPosY(0)
	elseif ( screenSizeY - sizeY < posY ) then
		panel:SetPosY(screenSizeY - sizeY)
	end
end

-- 초기 위치를 저장된 위치로 변경
function changePositionBySever(panel, panelId, isShow, isChangePosition, isChangeSize)
	if(0 < ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)) then
		if(isShow) then
			panel:SetShow(ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
		end
		
		if(isChangePosition) then
			panel:SetPosX( ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_PositionX) )
			panel:SetPosY( ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_PositionY) )
		end
		
		if(isChangeSize) then
			panel:SetSize(ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_SizeX), ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_SizeY))
		end	

		if ( isChangePosition or isChangeSize ) then
			checkAndSetPosInScreen(panel)
		end
		return true
	end
	
	return false
end

function FGlobal_PanelMove(panel, isOnlyMovableMode)
	panel:addInputEvent( "Mouse_LPress", 		"FGlobal_SaveUiInfo("..tostring(isOnlyMovableMode)..")" )
end

function FGlobal_SaveUiInfo(isOnlyMovableMode)
	if((not isOnlyMovableMode) or isMovableMode) then
		ToClient_SaveUiInfo(false)
	end
end

function FGlobal_SetMovableMode(isMovable)
	isMovableMode = isMovable
end

function FGlobal_IsCommercialService()
	if(getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Commercial) then
		return true
	else
		return false
	end
end

function FGlobal_PanelMoveIntoScreen(panel)
	if(panel:GetPosX() < 0) then
		panel:SetPosX(0)
	elseif(getScreenSizeX() <= (panel:GetPosX() + panel:GetSizeX())) then
		panel:SetPosX(getScreenSizeX() - panel:GetSizeX())
	end
	
	if(panel:GetPosY() < 0) then
		panel:SetPosY(0)
	elseif(getScreenSizeY() <= (panel:GetPosY() + panel:GetSizeY())) then
		panel:SetPosY(getScreenSizeY() - panel:GetSizeY())
	end
end

registerEvent("FromClient_SetGameUIMode", "FromClient_SetGameUIMode")
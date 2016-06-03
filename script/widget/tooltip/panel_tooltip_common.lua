local UI_TM = CppEnums.TextMode

Panel_Tooltip_Common:SetShow(false, false)
Panel_Tooltip_Common:setGlassBackground(true)
--Panel_Tooltip_Common:setMaskingChild(true)

Panel_Tooltip_Common:SetIgnoreChild(true)

local _uiIcon			= UI.getChildControl(Panel_Tooltip_Common, "Tooltip_Common_Icon");
local _uiName			= UI.getChildControl(Panel_Tooltip_Common, "Tooltip_Common_Name");
local _uiTitle			= UI.getChildControl(Panel_Tooltip_Common, "Tooltip_Common_Title");
local _styleDesc		= UI.getChildControl(Panel_Tooltip_Common, "Tooltip_Common_Description");


local uiTextGroup = {
	_uiName			= _uiName			,
	--_uiTitle		= _uiTitle			,
	_styleDesc		= _styleDesc		,
}

-- 창의 사이즈를 구하기 위해 text들의 길이를 구해주는 함수
local getMaxRightPos = function()
	local rightPos = 0
	for _,control in pairs(uiTextGroup) do
		if ( control:GetShow() ) then
			local currentControlRight = control:GetPosX() + control:GetTextSizeX()
			if ( rightPos < currentControlRight ) then
				rightPos = currentControlRight
			end
		end
	end
	return rightPos
end

local getMaxBottomPos = function()
	local bottomPos = 0
	for _, control in pairs(uiTextGroup) do
		if ( control:GetShow() ) then
			local currentControlBottom = control:GetPosY() + control:GetTextSizeY()
			if ( bottomPos < currentControlBottom ) then
				bottomPos = currentControlBottom
			end
		end
	end
	return bottomPos
end

-- 창의 On, Out순서가 보장되지않기에 뒤집혀서 들어오는경우를 제어하기위한 변수들
local currentIndex = -1
local isShow = false


function TooltipCommon_Show( index, uiWedget, iconPath, name, title, desc )
	if ( currentIndex == index ) and ( isShow ) then
		return
	else
		currentIndex = index 
		isShow = true
	end

	if iconPath ~= nil then
		_uiIcon:ChangeTextureInfoName("icon/"..iconPath)
	else
		_uiIcon:ChangeTextureInfoName("")
	end
	_uiName:SetTextMode( UI_TM.eTextMode_AutoWrap )
	_uiName:SetText( name )
	_uiName:ComputePos()
	if ( nil == desc ) then
		_styleDesc:SetShow(false)
	else
		_styleDesc:SetText( desc )
	end
	--local nameX = _uiName:GetTextSizeX()

	local width = getMaxRightPos()
	local height = getMaxBottomPos() + 30
	if ( 0 ~= width ) and ( 0 ~= height ) then
		local posX = uiWedget:GetParentPosX() + uiWedget:GetSizeX() * 0.8
		local posY = uiWedget:GetParentPosY() - uiWedget:GetSizeY() * 1.8
		
		Panel_Tooltip_Common:SetPosX( posX )
		Panel_Tooltip_Common:SetPosY( posY )
		Panel_Tooltip_Common:SetSize( Panel_Tooltip_Common:GetSizeX(), height )
		Panel_Tooltip_Common:SetShow( true, false )
	else
		Panel_Tooltip_Common:SetShow( false, false )
	end
end

function TooltipCommon_Hide( index )
	if ( currentIndex ~= index ) or ( false == isShow ) then
		return
	else
		currentIndex = -1
		isShow = false
	end

	Panel_Tooltip_Common:SetShow(false,false)
end

function TooltipCommon_getCurrentIndex()
	return currentIndex
end
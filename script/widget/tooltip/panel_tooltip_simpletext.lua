local UI_TM = CppEnums.TextMode

Panel_Tooltip_SimpleText:SetShow( false )
Panel_Tooltip_SimpleText:setGlassBackground( true )
Panel_Tooltip_SimpleText:SetIgnoreChild( true )
Panel_Tooltip_SimpleText:SetIgnore( true )

local _uiName			= UI.getChildControl(Panel_Tooltip_SimpleText, "Tooltip_Name");
local _styleDesc		= UI.getChildControl(Panel_Tooltip_SimpleText, "Tooltip_Description");
local _mouseL			= UI.getChildControl(Panel_Tooltip_SimpleText, "Static_Help_MouseL");
local _mouseR			= UI.getChildControl(Panel_Tooltip_SimpleText, "Static_Help_MouseR");


local uiTextGroup = {
	_uiName			= _uiName			,
	_styleDesc		= _styleDesc		,
}

local TooltipSimple_SetPosition = function( parentPos, size )
	local itemShow		= Panel_Tooltip_SimpleText:GetShow()
	if ( not itemShow ) then
		return
	end

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	
	local itemPosX = Panel_Tooltip_SimpleText:GetSizeX()
	local itemPosY = Panel_Tooltip_SimpleText:GetSizeY()

	--local posX = uiControl:GetParentPosX()
	--local posY = uiControl:GetParentPosY()
	local posX = parentPos.x;
	local posY = parentPos.y;

	-- local parent = uiControl:getParent()
	-- if	parent	then
	-- 	posX = uiControl:getParent():GetParentPosX()
	-- 	posY = uiControl:getParent():GetParentPosY() - 500
	-- end

	local isLeft= (screenSizeX / 2) < posX
	local isTop	= (screenSizeY / 2) < posY

	local tooltipSize			= { width = 0, height = 0 }
	local tooltipEquipped		= { width = 0, height = 0 }
	local sumSize				= { width = 0, height = 0 }

	if ( Panel_Tooltip_SimpleText:GetShow() ) then
		tooltipSize.width	= Panel_Tooltip_SimpleText:GetSizeX()
		tooltipSize.height	= Panel_Tooltip_SimpleText:GetSizeY()

		sumSize.width	= sumSize.width + tooltipSize.width
		sumSize.height	= math.max( sumSize.height, tooltipSize.height )
	end

	if not isLeft then			-- 부모 컨트롤의 위치를 기준으로. 오른쪽이라면
		--posX = posX + uiControl:GetSizeX()
		posX = posX + size.x;
	end

	if isTop then				-- 부모 컨트롤의 위치를 기준으로. 위라면.
		--posY = posY + uiControl:GetSizeY()
		posY = posY + size.y;
		local yDiff = posY - sumSize.height
		if yDiff < 0 then
			posY = posY - yDiff
		end
	else						-- 부모 컨트롤의 위치를 기준으로. 아래라면.
		local yDiff = screenSizeY - (posY + sumSize.height)
		if yDiff < 0 then
			posY = posY + yDiff
		end
	end

	if Panel_Tooltip_SimpleText:GetShow() then
		if isLeft then
			posX = posX - tooltipSize.width
		end

		local yTmp = posY
		if isTop then
			yTmp = yTmp - tooltipSize.height
		end

		Panel_Tooltip_SimpleText:SetPosX(posX)
		Panel_Tooltip_SimpleText:SetPosY(yTmp)
	end
end

function TooltipSimple_CommonShow(name, desc)
	if Panel_Tooltip_SimpleText:GetShow() then
		Panel_Tooltip_SimpleText:SetShow( false )
	end
	
	if nil == name then
		_PA_ASSERT( false, "인자 name은 반드시 입력해야합니다." )
		return
	end

	if ( nil == desc ) and ( nil ~= name ) then
		local nameLength = string.len(name)
		-- 툴팁 짧은데 갔다가 긴 곳으로 가게되면 사이즈가 짧은데를 맞춰주기 때문에 기본값 초기화먼저 해줌.
		_uiName:SetSize( 120, _uiName:GetSizeY() )
		-- UI.debugMessage( "nameLength : " .. nameLength)
		if nameLength < 30 then
			_uiName:SetTextHorizonCenter()
			_uiName:SetText( name )
			_uiName:SetSize( ( _uiName:GetTextSizeX() + _uiName:GetSpanSize().x ), _uiName:GetSizeY() )
		elseif 30 <= nameLength and nameLength < 60 then
			_uiName:SetTextHorizonLeft()
			_uiName:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_uiName:SetSize( 120, _uiName:GetSizeY() )
			_uiName:SetText( name )
		else
			_PA_ASSERT( false, "텍스트량이 너무 많습니다. desc 인자를 이용하세요. 색상 태그 때문이라면 무시하세요." )
			_uiName:SetTextHorizonLeft()
			_uiName:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_uiName:SetSize( 120, _uiName:GetSizeY() )
			_uiName:SetText( name )
		end
		
		Panel_Tooltip_SimpleText:SetSize( (_uiName:GetSizeX() + (_uiName:GetSpanSize().x * 2) ), (_uiName:GetTextSizeY() + (_uiName:GetSpanSize().x * 2)) )
		_styleDesc:SetShow( false )
	end
	
	if ( nil ~= desc ) then
		local descLength	= string.len(desc)
		local panelWidth	= 150

		if descLength < 100 then
			_uiName		:SetSize( panelWidth - 20, _uiName:GetSizeY() )
			_styleDesc	:SetSize( panelWidth - 20, _styleDesc:GetSizeY() )
			Panel_Tooltip_SimpleText:SetSize( panelWidth, Panel_Tooltip_SimpleText:GetSizeY() )
		elseif 100 <= descLength and descLength < 400 then
			_uiName		:SetSize( panelWidth + 80, _uiName:GetSizeY() )
			_styleDesc	:SetSize( panelWidth + 80, _styleDesc:GetSizeY() )
			Panel_Tooltip_SimpleText:SetSize( panelWidth + 100, Panel_Tooltip_SimpleText:GetSizeY() )
		else
			_uiName		:SetSize( panelWidth + 120, _uiName:GetSizeY() )
			_styleDesc	:SetSize( panelWidth + 120, _styleDesc:GetSizeY() )
			Panel_Tooltip_SimpleText:SetSize( panelWidth + 140, Panel_Tooltip_SimpleText:GetSizeY() )
		end
		
		_uiName:SetTextHorizonLeft()
		_uiName:SetText( name )

		if Panel_Tooltip_SimpleText:GetSizeX() < _uiName:GetTextSizeX() + 20 then
			Panel_Tooltip_SimpleText:SetSize( _uiName:GetTextSizeX() + 20, Panel_Tooltip_SimpleText:GetSizeY() )
			_styleDesc:SetSize( Panel_Tooltip_SimpleText:GetSizeX() - 20, _styleDesc:GetSizeY())
		end

		_styleDesc:SetTextHorizonLeft()
		_styleDesc:SetAutoResize()
		_styleDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_styleDesc:SetText( desc )
		_styleDesc:SetShow( true )

		_styleDesc:SetPosY( _uiName:GetTextSizeY()+10 )

		Panel_Tooltip_SimpleText:SetSize( Panel_Tooltip_SimpleText:GetSizeX(), (_uiName:GetTextSizeY() + _styleDesc:GetTextSizeY() + (_uiName:GetSpanSize().x * 2)) )
	end
	
	Panel_Tooltip_SimpleText:SetShow(true)
end

function TooltipSimple_Show( uiControl, name, desc )
	Panel_Tooltip_SimpleText:ChangeTextureInfoName( "new_ui_common_forlua/default/blackpanel_series.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( Panel_Tooltip_SimpleText, 127, 1, 189, 63 )
	Panel_Tooltip_SimpleText:getBaseTexture():setUV( x1, y1, x2, y2 )
	Panel_Tooltip_SimpleText:setRenderTexture(Panel_Tooltip_SimpleText:getBaseTexture())

	_mouseL:SetShow( false )
	_mouseR:SetShow( false )

	TooltipSimple_CommonShow( name, desc )
	local parentPos = {
		x = uiControl:GetParentPosX(),
		y = uiControl:GetParentPosY()
	};
	local size = {
		x = uiControl:GetSizeX(),
		y = uiControl:GetSizeY()
	};
	TooltipSimple_SetPosition( parentPos, size )
end

function TooltipSimple_ShowUsePosSize( parentPos, size, name, desc )
	Panel_Tooltip_SimpleText:ChangeTextureInfoName( "new_ui_common_forlua/default/blackpanel_series.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( Panel_Tooltip_SimpleText, 127, 1, 189, 63 )
	Panel_Tooltip_SimpleText:getBaseTexture():setUV( x1, y1, x2, y2 )
	Panel_Tooltip_SimpleText:setRenderTexture(Panel_Tooltip_SimpleText:getBaseTexture())

	_mouseL:SetShow( false )
	_mouseR:SetShow( false )
	
	TooltipSimple_CommonShow( name, desc )
	TooltipSimple_SetPosition( parentPos, size)
end

function TooltipSimple_ShowMouseGuide( uiControl, onL, onR )
	if nil == uiControl then
		return
	end
	Panel_Tooltip_SimpleText:ChangeTextureInfoName( "new_ui_common_forlua/default/blackpanel_series.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( Panel_Tooltip_SimpleText, 127, 64, 189, 126 )
	Panel_Tooltip_SimpleText:getBaseTexture():setUV( x1, y1, x2, y2 )
	Panel_Tooltip_SimpleText:setRenderTexture(Panel_Tooltip_SimpleText:getBaseTexture())

	TooltipSimple_CommonShow( "                " )
	local parentPos = {
		x = uiControl:GetParentPosX(),
		y = uiControl:GetParentPosY()
	};
	local size = {
		x = uiControl:GetSizeX(),
		y = uiControl:GetSizeY()
	};

	TooltipSimple_SetPosition( parentPos, size)

	if true == onL then
		_mouseL:SetShow( true )
	else
		_mouseL:SetShow( false )
	end
	_mouseL:SetPosX( 5 )
	_mouseL:SetPosY( 5 )

	if true == onR then
		_mouseR:SetShow( true )
	else
		_mouseR:SetShow( false )
	end
	_mouseR:SetPosX( 5 )
	if _mouseL:GetShow() then
		_mouseR:SetPosY( 35 )
	else
		_mouseR:SetPosY( 5 )
	end
	
	if _mouseL:GetShow() and _mouseR:GetShow() then
		Panel_Tooltip_SimpleText:SetSize( Panel_Tooltip_SimpleText:GetSizeX(), _mouseR:GetPosY() + _mouseR:GetSizeY() + 5 )
	else
		Panel_Tooltip_SimpleText:SetSize( Panel_Tooltip_SimpleText:GetSizeX(), 38 )
	end
	
end

function TooltipSimple_Hide()
	Panel_Tooltip_SimpleText:SetShow(false)
end
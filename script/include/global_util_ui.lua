if nil == UI then
	UI = {}
end

--[[
function UI.createTextControl(parent, strID)
	return createText(parent:GetKey(), strID)
end
]]

function UI.createPanel(strID, groupID)
	tempUIBaseForLua = nil
	createPanel(strID, groupID)
	return tempUIBaseForLua;
end

function UI.createControl(uiType, parent, strID)
	tempUIBaseForLua = nil
	createControl(uiType, parent, strID)
	return tempUIBaseForLua;
end

function UI.createAndCopyBasePropertyControl( fromParent, fromStrID, parent, strID )
	local	fromControl	= UI.getChildControl(fromParent, fromStrID)
	if	( nil == fromControl )	then
		UI.ASSERT( nil ~= fromControl	and 'number' ~= type(fromControl),	fromStrID )
		return(nil)
	end
	fromControl:SetShow(false)
	
	tempUIBaseForLua = nil
	createControl(fromControl:GetType(), parent, strID)
	if	( nil == tempUIBaseForLua )	then
		UI.ASSERT( nil ~= tempUIBaseForLua	and 'number' ~= type(tempUIBaseForLua),	strID )
		return(nil)
	end
	
	CopyBaseProperty( fromControl, tempUIBaseForLua )
	tempUIBaseForLua:SetShow(true)
	
	return(tempUIBaseForLua)
end

function UI.createCustomControl(typeStr, parent, strID)
	tempUIBaseForLua = nil
	createCustomControl(typeStr, parent, strID)
	return tempUIBaseForLua;
end

function UI.deleteControl(conrol)
	deleteControl(conrol)
end

function UI.getChildControl(parent, strID)
	tempUIBaseForLua = nil
	parent:getChildControl(strID)
	if	( nil == tempUIBaseForLua )	then
		UI.ASSERT( nil ~= tempUIBaseForLua	and 'number' ~= type(tempUIBaseForLua),	strID )
		return(nil)
	end
	return tempUIBaseForLua;
end

function UI.getChildControlByIndex(parent, index)
	tempUIBaseForLua = nil
	parent:getChildControlByIndex(index)
	return tempUIBaseForLua;
end

function UI.deletePanel(strID)
	deletePanel(strID, groupID)
end

function UI.createOtherPanel(strID, groupID)
	tempUIBaseForLua = nil
	createOtherPanel(strID, groupID)
	return tempUIBaseForLua;
end

function UI.deleteOtherPanel(strID)
	deleteOtherPanel(strID);
end

function UI.deleteOtherControl(panel, control)
	deleteOtherControl(panel, control)
end

--플러쉬전에 수행시켜준다.
local preFlushFunctorList = Array.new()
local postFlushFunctorList = Array.new()
local postRestorFunctorList = Array.new()
local runPreFlushFunctions = function()
	for key, value in pairs( preFlushFunctorList ) do
		value()
	end
end

local runPostFlushFunctions = function()
	for key, value in pairs( postFlushFunctorList ) do
		value()
	end
end

local runRestorFunctions = function()
	for key, value in pairs( postRestorFunctorList ) do
		value()
	end
end

function UI.flushAndClearUI()
	runPreFlushFunctions()
	flushAndClearUI()
	runPostFlushFunctions()
--	Acquire_ProcessMessage() -- 미처 못 다 뿌려준 메시지가 있으면 뿌려준다!
end

function UI.restoreFlushedUI()
	restoreFlushedUI()
	runRestorFunctions()
--	Acquire_ProcessMessage() -- 미처 못 다 뿌려준 메시지가 있으면 뿌려준다!
	
	-- Dialog or WorldMap 등이 활성화되어 있는 상태에서, 비활성화 할 때 떠야 하는 것들이 있다.
	-- ex) 말에 탑승하기 시도 후 바로 Worldmap을 열 경우, Dialog를 통해 말을 찾을 경우.. 등 flushed list에 추가 되기 전에 먼저 열려 버리면 닫을 때 정상적으로 열리지 않는다.
	-- 그래서 수동으로 추가 했다.	( 20140914:홍민우)
	--{
		-- 말에 탑승 중이라면
		HorseHP_OpenByInteraction()
		HorseMP_OpenByInteraction()
		
		-- 탈것 찾기 시 다이얼로그에서 찾게 되면 fluashed 리스트에 정상적으로 들어가지 않기 때문에 여기서 추가 해주어야 한다.
		ServantIcon_Open()
	--}
end

function UI.isFlushedUI()
	return isFlushedUI()
end

function UI.addRunPreFlushFunction( functor )
	if ( nil == functor ) then
		return
	end
	preFlushFunctorList:push_back( functor )
end

function UI.addRunPostFlushFunction( functor )
	if ( nil == functor ) then
		return
	end
	postFlushFunctorList:push_back( functor )
end

function UI.addRunPostRestorFunction( functor )
	if ( nil == functor ) then
		return
	end
	postRestorFunctorList:push_back( functor )
end

function UI.ASSERT( test, message )
	message = message or tostring(test)
	if 'string' ~= type(message) then
		message = tostring(message)
	end
	test = (nil ~= test) and (false ~= test) and (0 ~= test)
	_PA_ASSERT( test, message )
end

function UI.Set_ProcessorInputMode( UIModeType )
	if getInputMode() ~= UIModeType then
		setInputMode(UIModeType)
		ProcessorInputModeChange()
	end
end

function UI.isGameOptionMouseMode()
	return (true == getOptionMouseMode())
end

function UI.Get_ProcessorInputMode()
	return getInputMode()
end

function setTextureUV_Func( control, pixX, pixY, pixEndX, pixEndY )
		local sizeX = control:getTextureWidth()
		local sizeY = control:getTextureHeight()
		
		if(sizeX == 0 and sizeY == 0) then
			return 0, 0, 0, 0
		end
		
		return pixX / sizeX, pixY / sizeY, pixEndX / sizeX, pixEndY / sizeY 
			
end

function UI.getFocusEdit()
	return GetFocusEdit()
end

function UI.isInPositionForLua( control, posX, posY )
	return isInPostion( control, posX, posY );
end

function UI.checkShowWindow()
	return check_ShowWindow();
end

function UI.checkIsInMouse( panel )
	local IsMouseOver = panel:GetPosX() < getMousePosX() and getMousePosX() < panel:GetPosX() + panel:GetSizeX() and panel:GetPosY() < getMousePosY() and getMousePosY() < panel:GetPosY() + panel:GetSizeY() and (CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode == UI.Get_ProcessorInputMode())
	return IsMouseOver and false == isCharacterCameraRotateMode();
end

function UI.checkIsInMouseAndEventPanel( panel )
	local isOverEvent = UI.checkIsInMouse( panel );
	local eventControl = getEventControl();
	if( nil ~= eventControl ) then
		local parentPanel = eventControl:GetParentPanel();
		--if( nil ~= parentPanel ) then
			return ( parentPanel:GetKey() == panel:GetKey() ) and isOverEvent;
--		end

--		return ( eventControl:GetKey() == panel:GetKey() ) and isOverEvent;
	end

	return isOverEvent
end

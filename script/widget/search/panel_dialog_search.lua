---------------------------
-- global Variables
---------------------------
-- 

searchClearQuest = {}

---------------------------
-- global function
---------------------------
function checkClearSearchQuest( npcCharacterKey )
	return (nil ~= searchClearQuest[npcCharacterKey])
end

---------------------------
-- Local Variables
---------------------------

local var_UI = {
	panel		= Panel_Dialog_Search,

	title		= UI.getChildControl(Panel_Dialog_Search, "StaticText_Search_Title"),
	btn_left	= UI.getChildControl(Panel_Dialog_Search, "Button_Arrow_Left"),
	btn_right	= UI.getChildControl(Panel_Dialog_Search, "Button_Arrow_Right"),
	btn_top		= UI.getChildControl(Panel_Dialog_Search, "Button_Arrow_Top"),
	btn_bottom	= UI.getChildControl(Panel_Dialog_Search, "Button_Arrow_Bottom"),
	btn_detail	= UI.getChildControl(Panel_Dialog_Search, "Button_Detail"),
	
	btn_ZoomIn 	= UI.getChildControl(Panel_Dialog_Search, "Button_ZoomIn"),
	btn_ZoomOut	= UI.getChildControl(Panel_Dialog_Search, "Button_ZoomOut"),

	StaticText_Q 	= UI.getChildControl(Panel_Dialog_Search, "StaticText_Q"),
	StaticText_W 	= UI.getChildControl(Panel_Dialog_Search, "StaticText_W"),
	StaticText_E 	= UI.getChildControl(Panel_Dialog_Search, "StaticText_E"),
	StaticText_A 	= UI.getChildControl(Panel_Dialog_Search, "StaticText_A"),
	StaticText_S 	= UI.getChildControl(Panel_Dialog_Search, "StaticText_S"),
	StaticText_D 	= UI.getChildControl(Panel_Dialog_Search, "StaticText_D"),
	
	-- btn_FreeSet1= UI.getChildControl(Panel_Dialog_Search, "Button_FreeSet_1"),
	-- btn_FreeSet2= UI.getChildControl(Panel_Dialog_Search, "Button_FreeSet_2"),
	-- btn_FreeSet3= UI.getChildControl(Panel_Dialog_Search, "Button_FreeSet_3"),
}

local variable = {
	isShow = false,
	directionIndex = 0,
	currentNpcCharacterKey = 0,
}

local additionYaw = 0.0
local additionPitch = 0.0

local yawValue = 0.02
local ptichValue = 0.02
local moveCameraDistance = 1000

-- findCondition
local findCameraDistance = 0
local findCameraAngle = 0
local moveAbleAngleUp = 60
local moveAbleAngleDown = -40

local isShowSearchObject = false
-- global
function searchView_Open()
	--SetUIMode( Defines.UIMode.eUIMode_Search )
	variable.currentNpcCharacterKey = dialog_getTalkNpcKey()
	if 0 == variable.currentNpcCharacterKey then
		-- UI.debugMessage( "npc nil" )
		return
	end
	
	if true == checkClearSearchQuest( variable.currentNpcCharacterKey ) then
		return
	end

	searchClearQuest[variable.currentNpcCharacterKey] = nil

	Panel_Dialog_Search:SetShow( true )
	
	isShowSearchObject = false
	setCutSceneCameraEditMode( true )
	openClientChangeScene( variable.currentNpcCharacterKey, 1 )
	moveCameraDistance = search_initCameraDistance()

	findCameraDistance = search_conditionDistance()
	findCameraAngle = search_conditionAngle()
	moveAbleAngleUp = search_getMoveAbleAngleUp()
	moveAbleAngleDown = search_getMoveAbleAngleDown()
	--UI.debugMessage( "findCameraAngle : " .. findCameraAngle )
	--SetUIMode( Defines.UIMode.eUIMode_Search )
	--local npcCharacter = dialog_getTalker()
	
	--if nil ~= npcCharacter then
		--search_lookAtPos( npcCharacter:get():getPosition() )
	--end
end

function searchView_Close()
	--SetUIMode( Defines.UIMode.eUIMode_Default )
	--if true == Panel_Dialog_Search:IsShow() then
		Panel_Dialog_Search:SetShow( false )

		additionYaw = 0.0
		search_additionYaw2(additionYaw)
		additionPitch = 0.0
		
		moveAbleAngleUp = 60
		moveAbleAngleDown = -40
		search_additionPitch2(additionPitch)
		
		setCutSceneCameraEditMode( false )
		-- local npcKey = dialog_getTalkNpcKey()
		-- if 0 == npcKey then
			-- UI.debugMessage( "npcKey nil => searchView Close()" )
			-- return
		-- end

		--search_LookAtPos( float3(0,0,0) )
		--setCutSceneCameraEditMode( false )
		--closeClientChangeScene( npcKey, 1 )
		--SetUIMode( Defines.UIMode.eUIMode_Default )
	--end
end

---------------------------
-- Functions
---------------------------

function searchView_ScreenResize()
	var_UI.panel:SetSize(getScreenSizeX(), getScreenSizeY())
	for _, v in pairs(var_UI) do
		v:ComputePos()
	end
end

local check_searchObject = function()
	if checkClearSearchQuest( variable.currentNpcCharacterKey ) then
		return
	end

	if findCameraDistance < moveCameraDistance then
		if true == isShowSearchObject then
			isShowSearchObject = false
			showSceneCharacter( 1, false )
		end
		return
	end

	--local actorProxy = getActorByIndex( 1 )
	local curCameraPosition = getCameraPosition()
	local objectPos = getSceneCharacterSpawnPosition( 1 )
	local objectLookPos = search_getObjectLookPos()

	--UI.debugMessage( "checkDistance : " .. checkDistance )
	-- 오브젝트가 보여야할 방향
	local objectToDir = Util.Math.calculateDirection( objectPos, objectLookPos )
	--local objectToDirNormal = Util.Math.calculateNormalVector( objectToDir )
	
	-- 오브젝트에서 카메라 방향
	local cameraToObjectDir = Util.Math.calculateDirection( objectPos, curCameraPosition )
	--local cameraToObjectNormal = Util.Math.calculateNormalVector( cameraToObject )

	local calcDot = Util.Math.calculateDot( cameraToObjectDir, objectToDir )
	local angle = math.acos( calcDot )
	
	local toDegree = angle * 180 / math.pi
	--UI.debugMessage( "result : " .. toDegree .. " calcDot : " .. calcDot )
	--_PA_LOG("혜조", "toDegree : " .. toDegree .. "angle : " .. angle .. " calcDot : " .. calcDot )
	if toDegree < findCameraAngle then
		if false == isShowSearchObject then
			showSceneCharacter( 1, true )
			isShowSearchObject = true

			if false == checkClearSearchQuest( variable.currentNpcCharacterKey ) then
				searchClearQuest[variable.currentNpcCharacterKey] = true
				click_DialogSearchObject()
				ReqeustDialog_retryTalk()			-- 조사하기 버튼 문제를 해결하기 위해 다시 말을 건다.
				searchView_Close()
			end
		end
	else
		if true == isShowSearchObject then
			isShowSearchObject = false
			showSceneCharacter( 1, false )
		end
	end
end

------------------------------------------------------------------------------

local isMoveAbleAngle = function()
	local curCameraPosition = getCameraPosition()
	local objectPos = getSceneCharacterSpawnPosition( 1 )
	local objectLookPos = search_getObjectLookPos()
	
	local noYObjectPos = float3( objectPos.x, 0, objectPos.z )
	local noYCurCameraPos = float3( curCameraPosition.x, 0, curCameraPosition.z )
	
	local noYObjectToCameraDir = Util.Math.calculateDirection( noYObjectPos, noYCurCameraPos)
	local ObjectTocameraDir = Util.Math.calculateDirection( objectPos, curCameraPosition )

	local normalaCalc = Util.Math.calculateDot( ObjectTocameraDir, noYObjectToCameraDir )
	local normalAngle = math.acos( normalaCalc )
	
	local normalToDegree = normalAngle * 180 / math.pi
	
	if curCameraPosition.y < objectPos.y then
		normalToDegree = -normalToDegree
	end
	
	-- _PA_LOG("혜조", "normalaCalc : " .. normalaCalc .. "normalAngle : " .. normalAngle .. "             normalToDegree : " .. normalToDegree )
	return normalToDegree
end

function searchView_PushLeft()
	variable.directionIndex = 0
	
	local normalToDegree = isMoveAbleAngle()
	if moveAbleAngleDown < normalToDegree and normalToDegree < moveAbleAngleUp then
		additionYaw = additionYaw + ptichValue
		search_additionYaw2(additionYaw)
		check_searchObject()
	end
end

function searchView_PushTop()
	variable.directionIndex = 1

	--if -1.4 < additionPitch then
	local normalToDegree = isMoveAbleAngle()
	if normalToDegree < moveAbleAngleUp then
		if moveAbleAngleUp < normalToDegree then
			return
		end
		additionPitch = additionPitch - yawValue
		search_additionPitch2(additionPitch)
	end

	check_searchObject()
end

function searchView_PushRight()
	variable.directionIndex = 2

	local normalToDegree = isMoveAbleAngle()
	if moveAbleAngleDown < normalToDegree and normalToDegree < moveAbleAngleUp then
		additionYaw = additionYaw - ptichValue
		search_additionYaw2(additionYaw)
		check_searchObject()
	end
end

function searchView_PushBottom()
	variable.directionIndex = 3
	
	local normalToDegree = isMoveAbleAngle()
	if moveAbleAngleDown < normalToDegree then
		if normalToDegree < moveAbleAngleDown then
			return
		end
		additionPitch = additionPitch + yawValue
		search_additionPitch2(additionPitch)
	end
	
	--UI.debugMessage( "Bottom additionPitch : " .. additionPitch )
	--_PA_LOG("혜조", "additionPitch : " .. additionPitch )
	check_searchObject()
end

function searchView_Detail()
	moveCameraDistance = moveCameraDistance - 10
	search_LookAtPosDistance(moveCameraDistance)
	check_searchObject()
end

function searchView_ZoomIn()
	if moveCameraDistance > 300 then
		moveCameraDistance = moveCameraDistance - 10
		search_LookAtPosDistance(moveCameraDistance)
	end
	
	check_searchObject()
end

function searchView_ZoomOut()
	if moveCameraDistance < 1200 then
		moveCameraDistance = moveCameraDistance + 10
		search_LookAtPosDistance(moveCameraDistance)
	end
	
	check_searchObject()
end

function searchViewMode_ShowToggle( isShow )
	if ( nil == isShow ) then
		variable.isShow = not variable.isShow
	else
		variable.isShow = isShow
	end

	if ( variable.isShow ) then
		var_UI.panel:SetShow( true )
	end
end

local Alpha_Rate_Setting = function( alpha )
	for k, v in pairs(var_UI) do
		v:SetAlpha(alpha)
		if ( k ~= "panel" ) then
			v:SetFontAlpha(alpha)
		end
	end
end

---------------------------
-- Initialize
---------------------------

local initialize = function()
	Panel_Dialog_Search:SetShow(false, false)
	--Alpha_Rate_Setting(0.0)
	searchView_ScreenResize()
	registerEvent( "onScreenResize", "searchView_ScreenResize" )
	registerEvent("EventQuestSearch", "searchView_Open");
	
	var_UI.btn_detail	:addInputEvent( "Mouse_LPress", "searchView_Detail()" )

	var_UI.btn_left		:addInputEvent( "Mouse_LPress", "searchView_PushLeft()" )
	var_UI.btn_right	:addInputEvent( "Mouse_LPress", "searchView_PushRight()" )
	var_UI.btn_top		:addInputEvent( "Mouse_LPress", "searchView_PushTop()" )
	var_UI.btn_bottom	:addInputEvent( "Mouse_LPress", "searchView_PushBottom()" )
	
	var_UI.btn_ZoomIn	:addInputEvent( "Mouse_LPress", "searchView_ZoomIn()" )
	var_UI.btn_ZoomOut	:addInputEvent( "Mouse_LPress", "searchView_ZoomOut()" )
	-- var_UI.btn_FreeSet1	:addInputEvent( "Mouse_LPress", "SearchView_PushFreeSet(1)" )
	-- var_UI.btn_FreeSet2	:addInputEvent( "Mouse_LPress", "SearchView_PushFreeSet(2)" )
	-- var_UI.btn_FreeSet3	:addInputEvent( "Mouse_LPress", "SearchView_PushFreeSet(3)" )
end

initialize()
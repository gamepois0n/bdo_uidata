
local Frame_ContentImage 		= UI.getChildControl(Panel_CustomizationMesh, "Frame_Content_Image")
local Static_PayMark 			= UI.getChildControl(Panel_CustomizationMesh, "Static_PayMark")
local Static_SelectMark 		= UI.getChildControl(Panel_CustomizationMesh, "Static_SelectMark" )


---------------------------------------------- 로컬 변수 선언 --------------------------------------------------------------
local paramValueList = {}
local ContentImage	= {}

local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local NoCashType 	= CppEnums.CustomizationNoCashType
local NoCashMesh 	= CppEnums.CustomizationNoCashMesh
local NoCashDeco 	= CppEnums.CustomizationNoCashDeco

local selectedMeshIndex = -1

local textureColumnCount = 4
local meshColumnCount = 5

local meshImageGap = 5
local columnWidth = Frame_ContentImage:GetSizeX() + meshImageGap
local columnHeight = Frame_ContentImage:GetSizeY() +meshImageGap

local contentsOffsetX = 10
local contentsOffsetY = 10

local texSize = 48

local selectedClassType 		= nil
local selectedListParamType 	= nil
local selectedListParamIndex 	= nil
local selectedItemIndex 		= nil
-----------------------------------------------------Event 등록 -----------------------------------------------------------
registerEvent("EventOpenSelectMeshUi", "OpenSelectMeshUi")
registerEvent("EventCloseSelectMeshUi", "CloseSelectMeshUi")

---------------------------------------------- 로컬 함수 정의 ---------------------------------------------------------------
local UpdateSelectedMark = function(meshUiIndex) 
	if meshUiIndex ~= -1 then
		Static_SelectMark:SetShow(true)
		Static_SelectMark:SetPosX( contentsOffsetX + meshUiIndex%meshColumnCount * columnWidth )
		Static_SelectMark:SetPosY( contentsOffsetY + math.floor(meshUiIndex/meshColumnCount)  * columnHeight )
	else
		Static_SelectMark:SetShow(false)
	end
end


local clearMeshUI = function()
	for _, v in pairs(ContentImage) do
		v:SetShow( false )
		UI.deleteControl(v)
	end
	ContentImage = {}
end

---------------------------------------------- Global 함수 정의 ---------------------------------------------------------------
function CloseSelectMeshUi()
end

function OpenSelectMeshUi( classType, uiId) 

	clearMeshUI()
	paramValueList = {}
	
	selectedClassType = classType
	local defaultContentsIndex = 0
	local listCount = getUiListCount( classType, uiId, defaultContentsIndex )
	--리스트와 추가된 디테일 리스트가 테스트 동안 공존하기 때문에 둘다 획득
	local detailListCount = getUiDetailListCount( classType, uiId, defaultContentsIndex )
	if listCount == 1 then
		local listIndex = 0
		local luaListIndex = listIndex + 1 
		
		local listTexture = getUiListTextureName( classType, uiId, defaultContentsIndex, listIndex )

		local listParamType = getUiListParamType( classType, uiId, defaultContentsIndex, listIndex )
		local listParamIndex = getUiListParamIndex( classType, uiId, defaultContentsIndex, listIndex )
		
		-- paramMax 만큼 이미지 리스트를 만든다.
		local meshCount = getParamMax( classType, listParamType, listParamIndex )	+ 1
		
		local normalLastIndex = 0
		
		for itemIndex = 0, meshCount - 1 do
			local luaShapeIdx = itemIndex + 1
			local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMesh, "Frame_Image_" .. itemIndex )
			CopyBaseProperty ( Frame_ContentImage, tempContentImage )
			tempContentImage:addInputEvent( "Mouse_LUp", "UpdateMeshIndexMessage(" ..listParamType.. "," ..listParamIndex.. "," ..itemIndex.. ")" )
			
			local staticPayMark = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempContentImage, "Static_PayMark_" .. itemIndex )
			CopyBaseProperty ( Static_PayMark, staticPayMark )
			
			-- 이미지 세팅
			local col = itemIndex % textureColumnCount
			local row = math.floor( itemIndex / textureColumnCount )
			local texUV = { x1, y1, x2, y2 }
			
			texUV.x1 = col * texSize
			texUV.y1 = row * texSize
			texUV.x2 = texUV.x1 + texSize
			texUV.y2 = texUV.y1 + texSize
			
			tempContentImage:ChangeTextureInfoName( listTexture )
			local x1, y1, x2, y2 = setTextureUV_Func( tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2 )
			tempContentImage:getBaseTexture():setUV( x1, y1, x2, y2 )
			
			tempContentImage:SetPosX( itemIndex%meshColumnCount * columnWidth + contentsOffsetX )
			tempContentImage:SetPosY( math.floor(itemIndex/meshColumnCount) * columnHeight + contentsOffsetY )
			tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
			if ( not FGlobal_IsInGameMode() ) and (not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, itemIndex)) and ( isServerFixedCharge() ) then
				tempContentImage:SetShow( false )
			else
				tempContentImage:SetShow( true )
			end
			
			if(not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, itemIndex)) then
				staticPayMark:SetShow( true )
			else
				staticPayMark:SetShow( false )
				normalLastIndex = normalLastIndex + 1
			end
			
			ContentImage[luaShapeIdx] = tempContentImage
		end		
		
		local param = getParam( listParamType, listParamIndex )
		UpdateSelectedMark( param )
		
		-- if(not FGlobal_IsCommercialService()) then
		-- 	Panel_CustomizationMesh:SetSize( Panel_CustomizationMesh:GetSizeX(), ( 1 + math.floor( (normalLastIndex-1)/meshColumnCount) ) * columnHeight - meshImageGap + 2*contentsOffsetY )
		-- else
			Panel_CustomizationMesh:SetSize( Panel_CustomizationMesh:GetSizeX(), ( 1 + math.floor( (meshCount-1)/meshColumnCount) ) * columnHeight - meshImageGap + 2*contentsOffsetY )
		-- end
	
		updateGroupFrameControls(  Panel_CustomizationMesh:GetSizeY(), Panel_CustomizationMesh )
	end
	
	if detailListCount == 1 then
		local detailListIndex = 0
		local luaDetailListIndex = detailListIndex + 1 
		
		local detailListParamType = getUiDetailListParamType( classType, uiId, defaultContentsIndex, detailListIndex )
		local detailListParamIndex = getUiDetailListParamIndex( classType, uiId, defaultContentsIndex, detailListIndex )
		
		local currentParamValue = getParam( detailListParamType, detailListParamIndex )
		local currenelementIndex
		
		-- paramMax 만큼 이미지 리스트를 만든다.
		local defaultDetailListIndex = 0
		local meshCount = getUiDetailListElementCount( classType, uiId, defauiltContentsIndex, defaultDetailListIndex  )
		
		local normalLastIndex = 0
		
		for elementIndex = 0, meshCount - 1 do
			local luaElementIndex = elementIndex + 1
			local tempContentImage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CustomizationMesh, "Frame_Image_" .. elementIndex )
			CopyBaseProperty ( Frame_ContentImage, tempContentImage )
			
			local paramValue = getUiDetailListElementParamValue( classType, uiId, defauiltContentsIndex, defaultDetailListIndex, elementIndex )
			paramValueList[luaElementIndex] = paramValue
			
			if paramValue == currentParamValue then
				currenelementIndex= elementIndex
			end
			
			tempContentImage:addInputEvent( "Mouse_LUp", "UpdateMeshIndexMessage(" ..detailListParamType.. "," ..detailListParamIndex.. "," ..elementIndex.. ")" )
			
			local staticPayMark = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempContentImage, "Static_PayMark_" .. elementIndex )
			CopyBaseProperty ( Static_PayMark, staticPayMark )
			
			-- 이미지 세팅
			local texUV = { x1, y1, x2, y2 }
			
			texUV.x1 = 1
			texUV.y1 = 1 
			texUV.x2 = texSize
			texUV.y2 = texSize
			
			local detailListElementTexture = getUiDetailListElementTextureName( classType, uiId, defauiltContentsIndex, defaultDetailListIndex, elementIndex )
			tempContentImage:ChangeTextureInfoName( detailListElementTexture )
			local x1, y1, x2, y2 = setTextureUV_Func( tempContentImage, texUV.x1, texUV.y1, texUV.x2, texUV.y2 )
			tempContentImage:getBaseTexture():setUV( x1, y1, x2, y2 )
			
			tempContentImage:SetPosX( elementIndex%meshColumnCount * columnWidth + contentsOffsetX )
			tempContentImage:SetPosY( math.floor(elementIndex/meshColumnCount) * columnHeight + contentsOffsetY )
			tempContentImage:setRenderTexture(tempContentImage:getBaseTexture())
			if ((not FGlobal_IsCommercialService()) and (not isNormalCustomizingIndex(selectedClassType, detailListParamType, detailListParamIndex, paramValue))) then
				tempContentImage:SetShow( false )
			else
				if ( not FGlobal_IsInGameMode() ) and ( not isNormalCustomizingIndex(selectedClassType, detailListParamType, detailListParamIndex, paramValue) )
					and ( isServerFixedCharge() ) then
					tempContentImage:SetShow( false )
				else
					tempContentImage:SetShow( true )
				end
			end
			
			if(not isNormalCustomizingIndex(selectedClassType, detailListParamType, detailListParamIndex, paramValue)) then
				staticPayMark:SetShow( true )
			else
				staticPayMark:SetShow( false )
				normalLastIndex = normalLastIndex + 1
			end
			
			ContentImage[luaElementIndex] = tempContentImage
		end		
		
		UpdateSelectedMark( currenelementIndex )
		
		if(not FGlobal_IsCommercialService()) then
			Panel_CustomizationMesh:SetSize( Panel_CustomizationMesh:GetSizeX(), ( 1 + math.floor( (normalLastIndex-1)/meshColumnCount) ) * columnHeight - meshImageGap + 2*contentsOffsetY )
		else
			Panel_CustomizationMesh:SetSize( Panel_CustomizationMesh:GetSizeX(), ( 1 + math.floor( (meshCount-1)/meshColumnCount) ) * columnHeight - meshImageGap + 2*contentsOffsetY )
		end
	
		updateGroupFrameControls(  Panel_CustomizationMesh:GetSizeY(), Panel_CustomizationMesh )
	end
end

function UpdateMeshIndexMessage( listParamType , listParamIndex , itemIndex )
	selectedListParamType 	= listParamType
	selectedListParamIndex 	= listParamIndex
	selectedItemIndex 		= itemIndex
	
	local luaSelectedItemIndex = selectedItemIndex +1
	local selectedParamValue = paramValueList[ luaSelectedItemIndex ]
--{ 메시지 박스를 두개를 띄웠을 때 두번쨰 띄운 정렬이 middle로 고정되어서 allClearMessageData() 해줌.
	if Panel_Win_System:GetShow() then
		MessageBox_Empty_function()
		allClearMessageData()
	end	
--}
	if ((not FGlobal_IsInGameMode()) and (not isNormalCustomizingIndex(selectedClassType, listParamType, listParamIndex, selectedParamValue))) then
		local	messageBoxMemo = PAGetString ( Defines.StringSheet_GAME, "LUA_CUSTOMIZATION_MSGBOX_APPLY_CASHITEM")
		local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = UpdateMeshIndex, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData, "top")
	else
		UpdateMeshIndex( )
	end
end

function UpdateMeshIndex( )
	local luaSelectedItemIndex = selectedItemIndex +1
	local selectedParamValue = paramValueList[ luaSelectedItemIndex ]
	
	setParam( selectedClassType, selectedListParamType, selectedListParamIndex, selectedParamValue )
	UpdateSelectedMark( selectedItemIndex )
	applyInitializeToGroupCustomizedBoneInfo()
end


-- 추출
Panel_Window_Extraction:SetShow(false, false)
Panel_Window_Extraction:setMaskingChild(true)
Panel_Window_Extraction:ActiveMouseEventEffect(true)
Panel_Window_Extraction:RegisterShowEventFunc( true, 'ExtractionShowAni()' )
Panel_Window_Extraction:RegisterShowEventFunc( false, 'ExtractionHideAni()' )

function ExtractionShowAni()
end

function ExtractionHideAni()
end

local UI_ANI_ADV								= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color									= Defines.Color
local screenX									= nil
local screenY									= nil

local _extractionBG								= UI.getChildControl( Panel_Window_Extraction, 			"ExtractionBackGround" )
local _extraction_EnchantStone_button			= UI.getChildControl ( Panel_Window_Extraction, 		"Button_Extraction_EnchantStone" )
local _extraction_Crystal_button				= UI.getChildControl ( Panel_Window_Extraction, 		"Button_Extraction_Crystal" )
local _extraction_Cloth_button					= UI.getChildControl ( Panel_Window_Extraction, 		"Button_Extraction_Cloth" )
local _extractionExitButton 					= UI.getChildControl ( Panel_Window_Extraction, 		"Button_Exit" )


_extractionBG:setGlassBackground(true)
_extractionBG:SetShow(true)
_extraction_EnchantStone_button:SetShow(true)
_extraction_Crystal_button:SetShow(true)
_extractionExitButton:SetShow(true)

_extraction_EnchantStone_button:addInputEvent		( "Mouse_LUp", "Button_ExtractionEnchantStone_Click()" )	-- 강화석 추출 버튼
_extraction_Crystal_button:addInputEvent			( "Mouse_LUp", "Button_ExtractionCrystal_Click()" )			-- 수정 추출 버튼
_extraction_Cloth_button:addInputEvent				( "Mouse_LUp", "Button_ExtractionCloth_Click()" )			-- 의상 추출 버튼
_extractionExitButton:addInputEvent					( "Mouse_LUp", "Extraction_OpenPanel( false )" )


registerEvent( "onScreenResize", "Extraction_Resize" )

function Extraction_BtnResize()
	local btnEnchantStoneSizeX				= _extraction_EnchantStone_button:GetSizeX()+23
	local btnEnchantStoneTextPosX			= (btnEnchantStoneSizeX - (btnEnchantStoneSizeX/2) - ( _extraction_EnchantStone_button:GetTextSizeX() / 2 ))
	local btnCrystalSizeX					= _extraction_Crystal_button:GetSizeX()+23
	local btnCrystalTextPosX				= (btnCrystalSizeX - (btnCrystalSizeX/2) - ( _extraction_Crystal_button:GetTextSizeX() / 2 ))
	local btnClothSizeX						= _extraction_Cloth_button:GetSizeX()+23
	local btnClothTextPosX					= (btnClothSizeX - (btnClothSizeX/2) - ( _extraction_Cloth_button:GetTextSizeX() / 2 ))
	local btnExitSizeX						= _extractionExitButton:GetSizeX()+23
	local btnExitTextPosX					= (btnExitSizeX - (btnExitSizeX/2) - ( _extractionExitButton:GetTextSizeX() / 2 ))

	_extraction_EnchantStone_button			:SetTextSpan( btnEnchantStoneTextPosX, 5 )
	_extraction_Crystal_button				:SetTextSpan( btnCrystalTextPosX, 5 )
	_extraction_Cloth_button				:SetTextSpan( btnClothTextPosX, 5 )
	_extractionExitButton					:SetTextSpan( btnExitTextPosX, 5 )
end

function Extraction_Resize()
	screenX = getScreenSizeX()
	screenY = getScreenSizeY()

	Panel_Window_Extraction:SetSize(screenX, Panel_Window_Extraction:GetSizeY() )
	Panel_Window_Extraction:ComputePos()

	_extractionBG:SetSize( screenX, _extractionBG:GetSizeY() )
	_extractionBG:ComputePos()
	
	-- 1006 한국 의상 추출 / 1007 일본 의상 추출
	if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 1006 ) or ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 1007 ) then		-- 의상 추출
		_extraction_EnchantStone_button:ComputePos()
		_extraction_Crystal_button:ComputePos()	
		_extraction_Cloth_button:ComputePos()
        _extraction_Cloth_button:SetShow( true )
	else
		_extraction_EnchantStone_button:SetPosX( getScreenSizeX()/2 - _extraction_EnchantStone_button:GetSizeX()/2 - 10 )
		_extraction_Crystal_button:SetPosX( getScreenSizeX()/2 + _extraction_Crystal_button:GetSizeX()/2 + 10 )
		_extraction_Cloth_button:SetShow( false )
	end
	_extractionExitButton:ComputePos()
end

function Extraction_OpenPanel( isShow )

	if( true == isShow ) then
		SetUIMode( Defines.UIMode.eUIMode_Extraction )
		setIgnoreShowDialog( true )
		UIAni.fadeInSCR_Down(Panel_Window_Extraction)

		Equipment_PosSaveMemory() -- 이전 위치를 저장한다.
		-- Panel_Equipment:SetShow(true, true)
		Panel_Equipment:SetPosX(10)
		Panel_Equipment:SetPosY( getScreenSizeY() - (getScreenSizeY()/2) - (Panel_Equipment:GetSizeY()/2) ) -- 모르겠지만, 시간 지연
	else
		SetUIMode( Defines.UIMode.eUIMode_NpcDialog )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
		setIgnoreShowDialog( false )
		Socket_ExtractionCrystal_WindowClose()
		ExtractionEnchantStone_WindowClose()
		ExtractionCloth_WindowClose()
		
		-- 추출 데이터 초기화.
		FGlobal_ExtractionCrystal_ClearData()
		InventoryWindow_Close()

		Equipment_PosLoadMemory()	-- 이전 위치를 불러온다.
		Panel_Equipment:SetShow( false, false )
	end
	
	Panel_Npc_Dialog:SetShow(not isShow)
	Panel_Window_Extraction:SetShow(isShow, false)
	Extraction_BtnResize()
end


function Button_ExtractionCrystal_Click()
	if false == Panel_Window_Extraction_Crystal:GetShow() then
		ExtractionEnchantStone_WindowClose()
		ExtractionCloth_WindowClose()
		Socket_ExtractionCrystal_Show( true )
		Inventory_SetFunctor( Socket_Extraction_InvenFiler_EquipItem, Panel_Socket_ExtractionCrystal_InteractortionFromInventory, Socket_ExtractionCrystal_WindowClose, nil )
		InventoryWindow_Show()
		Panel_Equipment:SetShow(true, true)
	else
		Socket_ExtractionCrystal_Show( false )
		InventoryWindow_Close()
		Panel_Equipment:SetShow(false, false)
	end
end

function Button_ExtractionEnchantStone_Click()
	if false == Panel_Window_Extraction_EnchantStone:GetShow() then
		Socket_ExtractionCrystal_WindowClose()
		ExtractionCloth_WindowClose()
		ExtractionEnchantStone_WindowOpen()
		Panel_Equipment:SetShow(true, true)
	else
		-- 강화석 초기화로 바꿔야 함.
		ExtractionEnchantStone_WindowClose()
		InventoryWindow_Close()
		Panel_Equipment:SetShow(false, false)
	end
end

function Button_ExtractionCloth_Click()
	if false == Panel_Window_Extraction_Cloth:GetShow() then
		ExtractionEnchantStone_WindowClose()
		Socket_ExtractionCrystal_WindowClose()
		ExtractionCloth_WindowOpen()
		Panel_Equipment:SetShow(true, true)
	else
		ExtractionCloth_WindowClose()
		InventoryWindow_Close()
		Panel_Equipment:SetShow(false, false)
	end
end


	
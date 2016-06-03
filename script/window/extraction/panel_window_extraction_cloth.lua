local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color

Panel_Window_Extraction_Result:SetSize( getScreenSizeX(), getScreenSizeY() )
Panel_Window_Extraction_Result:SetPosX( 0 )
Panel_Window_Extraction_Result:SetPosY( 0 )
Panel_Window_Extraction_Result:SetColor( UI_color.C_00FFFFFF )
Panel_Window_Extraction_Result:SetIgnore(true)
Panel_Window_Extraction_Result:SetShow(false)

local ResultMsgBG	= UI.getChildControl(Panel_Window_Extraction_Result, "Static_Finish")
ResultMsgBG:SetSize( (getScreenSizeX() + 40), 90 )
ResultMsgBG:SetPosX( -20 )
ResultMsgBG:ComputePos()

local ResultMsg		= UI.getChildControl(Panel_Window_Extraction_Result, "StaticText_Finish")
ResultMsg:SetSize( getScreenSizeX(), 90 )
ResultMsg:ComputePos()

-- 애니 초기화
ResultMsgBG	:ResetVertexAni()
ResultMsgBG	:SetVertexAniRun( "Ani_Scale_0", true )

-- 강화석 추출
Panel_Window_Extraction_Cloth:SetShow(false, false)
Panel_Window_Extraction_Cloth:setMaskingChild(true)
Panel_Window_Extraction_Cloth:setGlassBackground(true)
Panel_Window_Extraction_Cloth:RegisterShowEventFunc( true, 'ExtractionCloth_ShowAni()' )
Panel_Window_Extraction_Cloth:RegisterShowEventFunc( false, 'ExtractionCloth_HideAni()' )

-- 강화석 추출용
local EnchantManager =
{
	_currentTime        		= 0,
	_slotConfig =
	{
		createIcon      		= false,
		createBorder    		= false,
		createCount     		= true,
		createEnchant   		= true,
		createCash				= false
	},
	_buttonApply				= UI.getChildControl( Panel_Window_Extraction_Cloth, "Button_ExtractionCloth" ),       -- 추출 버튼
	_circleEff 					= UI.getChildControl ( Panel_Window_Extraction_Cloth, "Static_ExtractionSpinEffect" ),
	_extractionGuide			= UI.getChildControl ( Panel_Window_Extraction_Cloth, "StaticText_ExtractionGuide" ),	-- 설명
	_equipItem     				= {},

	_extracting_Effect_Step1 	= UI.getChildControl( Panel_Window_Extraction_Cloth, "Static_ExtractionEffect_Step1" ),	-- 장비 주변 (반시계방향)도는 이팩트,

	_balks						= UI.getChildControl( Panel_Window_Extraction_Cloth, "Static_Balks" ),					-- 발크스의 외침 아이콘
	_balksCount					= UI.getChildControl( Panel_Window_Extraction_Cloth, "StaticText_Balks_Count" ),		-- 발크스 외침 개수

	_doExtracting				= false,
	_extraction_TargetWhereType	= nil,
	_extraction_TargetSlotNo	= nil,
}

local _buttonQuestion = UI.getChildControl( Panel_Window_Extraction_Cloth, "Button_Question" )			-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowExtractionEnchantStone\" )" )									-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"true\")" )			-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"false\")" )			-- 물음표 마우스아웃

local extracting_Effect_Step1 	= nil
local extracting_Effect_Step2 	= nil
local extracting_Effect_Step3 	= nil
local equipItem_Effect 			= nil
local cloth_Effect 	= nil
-- 이팩트가 저장될 변수


-- 초기화
function EnchantManager:initialize()
	self._buttonApply:addInputEvent( "Mouse_LUp", "ExtractionCloth_ApplyReady()" )
	self._buttonApply:SetShow(true)

	self._equipItem.icon 		= UI.getChildControl( Panel_Window_Extraction_Cloth, "Static_Equip_Socket" )
	self._equipItem.slot_On 	= UI.getChildControl( Panel_Window_Extraction_Cloth, "Static_Equip_Socket_EffectOn" )	-- 장비 넣었을 때
	self._equipItem.slot_Nil 	= UI.getChildControl( Panel_Window_Extraction_Cloth, "Static_Equip_Socket_EffectOff" )	-- 장비 없을 때,
	
	self._extractionGuide:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	self._extractionGuide:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_1")) -- "의상을 추출하면 발크스의 외침을 획득할 수 있습니다.\n<PAColor0xFFDB2B2B>※ 추출이 완료되면 의상은 파괴됩니다.<PAOldColor>" )

	SlotItem.new( self._equipItem, 'Slot_0', 0, Panel_Window_Extraction_Cloth, self._slotConfig )
	self._equipItem:createChild()
	self._equipItem.empty = true
	self._equipItem.icon:addInputEvent( "Mouse_RUp", 	"ExtractionClothStone_EquipSlotRClick()" )

	self._balks:SetShow(false)
	self._balksCount:SetShow(false)
	
	self._enchantNumber			= UI.getChildControl ( Panel_Window_Extraction_Cloth, "StaticText_Enchant_value" )
	self._enchantNumber:SetShow( false )
end

-- 창 끄고 켜기
function ExtractionCloth_ShowAni()
	Panel_Window_Extraction_Cloth:SetShow( true )
	UIAni.fadeInSCR_Right(Panel_Window_Extraction_Cloth)
	UIAni.AlphaAnimation( 1, EnchantManager._circleEff, 0.0, 0.2 )
	EnchantManager._circleEff:SetVertexAniRun( "Ani_Color_Off", true )
	EnchantManager._circleEff:SetVertexAniRun( "Ani_Rotate_New",true )
	EnchantManager._circleEff:SetShow(true)
end

function ExtractionCloth_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Window_Extraction_Cloth, 0.0, 0.2 )
	aniInfo:SetHideAtEnd(true)

	local aniInfo1 = UIAni.AlphaAnimation( 0, EnchantManager._circleEff, 0.0, 0.2 )
	aniInfo1:SetHideAtEnd(true)
end

function EnchantManager:clear()
	self._equipItem:clearItem()
	self._equipItem.empty = true

	self._buttonApply:EraseAllEffect()
	self._buttonApply:SetIgnore(true)
	self._buttonApply:SetMonoTone(true)
	self._buttonApply:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_BUTTONAPPLY") )       -- 추출!  

	self._balks:	SetShow(false)
	self._balks:	SetMonoTone(true)
	self._balksCount:SetShow(false)
	self._balksCount:SetText( 0 )

	self._equipItem.slot_On:SetShow(false)
	self._equipItem.slot_Nil:SetShow(true)

	getEnchantInformation():clearData()
end

function	EnchantManager:registMessageHandler()
	registerEvent("FromClient_ExtractionCloth_Success", 	"ExtractionCloth_Success"	)
end

-- 강화석 추출 대상 장비 인벤 필터
function ExtractionCloth_InvenFiler_MainItem( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end

	-- 강화 레벨 0은 필터링
	local itemCount		= itemWrapper:getStaticStatus():getExtractionCount_s64()
	if nil == itemCount then
		return true
	elseif Int64toInt32(itemCount) <= 0 then
		return true
	else
		return false
	end
end

-- 강화석 추출, 인벤 필터 후 우클릭
function ExtractionCloth_InteractortionFromInventory( slotNo, itemWrapper, count_s64, inventoryType )
	local self = EnchantManager

	-- 마우스 오른 버튼을 클릭하면, 필터 내에서 교체 가능함.
	if ( self._equipItem.icon ) then
		-- ♬ 아이템을 박았다
		audioPostEvent_SystemUi(00,16)
		self._equipItem.icon:AddEffect( "UI_Button_Hide", false, 0, 0 )
		self._equipItem.slot_On:SetShow(true)
		self._equipItem.slot_Nil:SetShow(false)
		self._circleEff:ResetVertexAni()
		self._circleEff:SetVertexAniRun( "Ani_Color_On", true )
		self._circleEff:SetVertexAniRun( "Ani_Rotate_New", true )
		self._buttonApply:SetIgnore(false)
		self._buttonApply:SetMonoTone(false)
	end
	
	self._equipItem.empty				= false
	self._extraction_TargetWhereType	= inventoryType
	self._extraction_TargetSlotNo		= slotNo
	-- 인벤 넘버 저장
	local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
	-- 인벤 선택 아이템이 상단 슬롯에 꼽힘.
	self._equipItem:setItem( itemWrapper )

	-- 마우스 on 툴팁
	self._equipItem.icon:addInputEvent( "Mouse_On", 	"Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"inventory\", true)" )
	self._equipItem.icon:addInputEvent( "Mouse_Out",	"Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"inventory\", false)" )
	Panel_Tooltip_Item_SetPosition(slotNo, self._equipItem, "inventory")

	self._balks:SetShow(true)
	self._balks:SetMonoTone(true)
	self._balksCount:SetShow(true)
	local count = Int64toInt32(itemWrapper:getStaticStatus():getExtractionCount_s64())
	self._balksCount:SetText( count )
	
	Inventory_SetFunctor( ExtractionCloth_InvenFiler_MainItem, ExtractionCloth_InteractortionFromInventory, ExtractionCloth_WindowClose, nil )
end

function ExtractionCloth_EquipSlotRClick( )
	EnchantManager._circleEff:ResetVertexAni()
	EnchantManager._circleEff:SetVertexAniRun( "Ani_Color_Off",true )
	EnchantManager._circleEff:SetVertexAniRun( "Ani_Rotate_New",true )
	EnchantManager:clear()
	Inventory_SetFunctor( ExtractionCloth_InvenFiler_MainItem, ExtractionCloth_InteractortionFromInventory, ExtractionCloth_WindowClose, nil )
end

-- 추출하기 버튼을 눌렀다!
function ExtractionCloth_ApplyReady()
	-- 정말 추출할 거야?
	local messageContent	= PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_3") -- "이 의상에서 발크스의 외침을 추출하시겠습니까?\n추출한 의상은 파괴됩니다."
 	local messageboxData	= { title = PAGetString(Defines.StringSheet_RESOURCE, "UI_WINDOW_EXTRACTION_CLOTH_TITLE"), content = messageContent, functionYes = ExtractionCloth_Apply, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

-- 추출하기 버튼을 눌렀다!
function ExtractionCloth_Apply()
	local self = EnchantManager
	ToClient_RequestExtracItemFromExtractionCount(self._extraction_TargetWhereType, self._extraction_TargetSlotNo )

	-- 의상 추출 효과음~
	audioPostEvent_SystemUi(05,10)
	ExtractionCloth_Success()
end

function ExtractionCloth_CheckTime( DeltaTime )
	local self = EnchantManager
	
	self._currentTime = self._currentTime + DeltaTime
	-- 윗 서클이 돌고 주변이 환해진다.
	if (0 < self._currentTime) and (1 > self._currentTime) and (true == self._doExtracting) then
		self._extracting_Effect_Step1:SetShow(true)	-- 윗 서클
		if nil == extracting_Effect_Step1 then
			extracting_Effect_Step1 = self._extracting_Effect_Step1:AddEffect("fUI_Dress_Extraction01", false, -0.7, -4.7)
			-- extracting_Effect_Step1 = self._extracting_Effect_Step1:AddEffect("UI_ItemJewel", false, 0, 0)
			extracting_Effect_Step1 = self._extracting_Effect_Step1:AddEffect("fUI_StoneExtract_SpinSmoke01", false, 0, 0)
		end

	-- 장비가 환해지면서 사라진다.
	elseif (1 <= self._currentTime) and (1.8 > self._currentTime) and (true == self._doExtracting) then
		self._extracting_Effect_Step1:SetShow(true)
		
	-- 장비가 녹아 아래로 흐른다.
	elseif (1.8 <= self._currentTime) and (2.3> self._currentTime) and (true == self._doExtracting) then
		if nil ~= equipItem_Effect then
			self._equipItem.icon:EraseEffect( equipItem_Effect)
		end
		self._equipItem:clearItem()
		self._equipItem.slot_On:SetShow(false)
		self._equipItem.slot_Nil:SetShow(true)
		-- 장비 슬롯 이팩트 끄기. 아이템 빼기 초기화, 테두리 제거

		self._extracting_Effect_Step1:SetShow(true)

	--아랫 서클이 돌고 에너지가 뭉친다.
	elseif (2.3 <= self._currentTime) and (3 > self._currentTime) and (true == self._doExtracting) then
		self._extracting_Effect_Step1:SetShow(true)
		if (nil == cloth_Effect) then
			cloth_Effect = self._balks:AddEffect("fUI_Dress_Extraction02", false, 0, 4.2)
		end

	-- 블랙스톤이 생긴다.
	elseif (3 <= self._currentTime) and (3.8 > self._currentTime) and (true == self._doExtracting) then
		self._balks:SetMonoTone(false)
		-- 블랙 스톤 켜 줌.

	elseif (3.8 <= self._currentTime) and (4 > self._currentTime) and (true == self._doExtracting) then
		if nil ~= extracting_Effect_Step1 then
			self._extracting_Effect_Step1:EraseEffect( extracting_Effect_Step1)
			extracting_Effect_Step1 = nil
		end
		if nil ~= cloth_Effect then
			self._balks:EraseEffect( cloth_Effect )
			cloth_Effect = nil
		end
				
		ExtractionCloth_SuccessXXX()
	end
end

Panel_Window_Extraction_Cloth:RegisterUpdateFunc("ExtractionCloth_CheckTime")

-- 메시지 띄우기
function	ExtractionCloth_Success()
	local self = EnchantManager
	
	-- 이팩트 카운트 초기화
	self._currentTime  = 0
	self._doExtracting = true
end

function	ExtractionCloth_SuccessXXX()
	local self = EnchantManager
		
	-- 체크 변수 초기화		
	self._doExtracting	= false
	self._currentTime	= 0
	
	ExtractionCloth_resultShow()
	-- 결과를 알리고 
	EnchantManager:clear()
	-- 장비 슬롯 초기화
end

function ExtractionCloth_resultShow()
	if false == Panel_Window_Extraction_Result:GetShow() then
		Panel_Window_Extraction_Result:SetShow(true)
		ResultMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_2")) -- "의상이 추출되었습니다." )
		ExtractionResult_TimerReset()
	end
end

function ExtractionCloth_WindowOpen()
	Panel_Window_Extraction_Cloth:SetShow(true, true)
	Panel_Window_Extraction_Cloth:SetPosY( getScreenSizeY() - ( getScreenSizeY() / 2 ) - ( Panel_Window_Extraction_Cloth:GetSizeY() / 2 ) - 20 )
	Panel_Window_Extraction_Cloth:SetPosX( getScreenSizeX() - ( getScreenSizeX() / 2 ) - ( Panel_Window_Extraction_Cloth:GetSizeX() / 2 ))
	Inventory_SetFunctor( ExtractionCloth_InvenFiler_MainItem, ExtractionCloth_InteractortionFromInventory, ExtractionCloth_WindowClose, nil )
	InventoryWindow_Show()
	EnchantManager._doExtracting = false
end

function ExtractionCloth_WindowClose()
	-- 꺼준다
	Inventory_SetFunctor( nil )
	Panel_Window_Extraction_Cloth:SetShow(false, false)
	EnchantManager:clear()
end



EnchantManager:initialize()
EnchantManager:clear()
EnchantManager:registMessageHandler()
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
Panel_Window_Extraction_EnchantStone:SetShow(false, false)
Panel_Window_Extraction_EnchantStone:setMaskingChild(true)
Panel_Window_Extraction_EnchantStone:setGlassBackground(true)
Panel_Window_Extraction_EnchantStone:RegisterShowEventFunc( true, 'ExtractionEnchantStone_ShowAni()' )
Panel_Window_Extraction_EnchantStone:RegisterShowEventFunc( false, 'ExtractionEnchantStone_HideAni()' )

-- 강화석 추출용
local EnchantManager =
{
	_currentTime        		= 0,
	_slotConfig =
	{
		createIcon      		= false,
		createBorder    		= true,
		createCount     		= true,
		createEnchant   		= true,
		createCash				= true
	},
	_buttonApply				= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Button_Extraction_Socket_1" ),       -- 추출 버튼
	_circleEff 					= UI.getChildControl ( Panel_Window_Extraction_EnchantStone, "Static_ExtractionSpinEffect" ),
	_extractionGuide			= UI.getChildControl ( Panel_Window_Extraction_EnchantStone, "Static_ExtractionGuide" ),	-- 설명
	_equipItem     				= {},

	_extracting_Effect_Step1 	= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Static_ExtractionEffect_Step1" ),	-- 장비 주변 (반시계방향)도는 이팩트,
	_extracting_Effect_Step2 	= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Static_ExtractionEffect_Step2" ),	-- 장비에서 흐르는 이팩트,
	_extracting_Effect_Step3 	= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Static_ExtractionEffect_Step3" ),	-- 결과에 (시계방향)도는 이팩트,

	_blackStone_Weapon			= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Static_BlackStone_Weapon" ),	-- 블랙스톤(무기) 아이콘
	_blackStone_Armor			= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Static_BlackStone_Armor" ),	-- 블랙스톤(방어구) 아이콘
	_blackStone_Count			= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "StaticText_BlackStone_Count" ),	-- 블랙스톤 개수

	_doExtracting				= false,
	_extraction_TargetWhereType	= nil,
	_extraction_TargetSlotNo	= nil,
}

local _buttonQuestion = UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Button_Question" )			-- 물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowExtractionEnchantStone\" )" )									-- 물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"true\")" )			-- 물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"false\")" )			-- 물음표 마우스아웃

local extracting_Effect_Step1 	= nil
local extracting_Effect_Step2 	= nil
local extracting_Effect_Step3 	= nil
local equipItem_Effect 			= nil
local blackStone_Weapon_Effect 	= nil
local blackStone_Armor_Effect 	= nil
-- 이팩트가 저장될 변수


-- 초기화
function EnchantManager:initialize()
	self._buttonApply:addInputEvent( "Mouse_LUp", "ExtractionEnchant_ApplyReady()" )
	self._buttonApply:SetShow(true)

	self._equipItem.icon 		= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Static_Equip_Socket" )
	self._equipItem.slot_On 	= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Static_Equip_Socket_EffectOn" )	-- 장비 넣었을 때
	self._equipItem.slot_Nil 	= UI.getChildControl( Panel_Window_Extraction_EnchantStone, "Static_Equip_Socket_EffectOff" )	-- 장비 없을 때,
	
	self._extractionGuide:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	self._extractionGuide:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_EXTRACTIONGUIDE") ) -- 장비에 강화된 강화석을 강화 수치만큼 추출 할 수 있습니다. \n<PAColor0xFFDB2B2B>※ 추출이 완료되면, 장비는 파괴됩니다.<PAOldColor>

	SlotItem.new( self._equipItem, 'Slot_0', 0, Panel_Window_Extraction_EnchantStone, self._slotConfig )
	self._equipItem:createChild()
	self._equipItem.empty = true
	self._equipItem.icon:addInputEvent( "Mouse_RUp", 	"ExtractionEnchantStone_EquipSlotRClick()" )

	self._blackStone_Weapon:SetShow(false)
	self._blackStone_Armor:SetShow(false)
	self._blackStone_Count:SetShow(false)
	
	self._enchantNumber			= UI.getChildControl ( Panel_Window_Extraction_EnchantStone, "StaticText_Enchant_value" )
	self._enchantNumber:SetShow( false )

	CopyBaseProperty( self._enchantNumber, self._equipItem.enchantText )
	self._equipItem.enchantText:SetSize( self._equipItem.icon:GetSizeX(), self._equipItem.icon:GetSizeY() )
	self._equipItem.enchantText:SetPosX( 0 )
	self._equipItem.enchantText:SetPosY( 0 )
	self._equipItem.enchantText:SetTextHorizonCenter()
	self._equipItem.enchantText:SetTextVerticalCenter()
	self._equipItem.enchantText:SetShow( true )
end

-- 창 끄고 켜기
function ExtractionEnchantStone_ShowAni()
	Panel_Window_Extraction_EnchantStone:SetShow( true )
	UIAni.fadeInSCR_Right(Panel_Window_Extraction_EnchantStone)
	UIAni.AlphaAnimation( 1, EnchantManager._circleEff, 0.0, 0.2 )
	EnchantManager._circleEff:SetVertexAniRun( "Ani_Color_Off", true )
	EnchantManager._circleEff:SetVertexAniRun( "Ani_Rotate_New",true )
	EnchantManager._circleEff:SetShow(true)
end

function ExtractionEnchantStone_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Window_Extraction_EnchantStone, 0.0, 0.2 )
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

	self._blackStone_Weapon:	SetShow(false)
	self._blackStone_Armor:	SetShow(false)
	self._blackStone_Weapon:	SetMonoTone(true)
	self._blackStone_Armor:	SetMonoTone(true)
	self._blackStone_Count:	SetShow(false)
	self._blackStone_Count:	SetText(0)

	self._equipItem.slot_On:SetShow(false)
	self._equipItem.slot_Nil:SetShow(true)

	getEnchantInformation():clearData()
end

function	EnchantManager:registMessageHandler()
	registerEvent("FromClient_ExtractionEnchant_Success", 	"ExtractionEnchant_Success"	)
end

-- 강화석 추출 대상 장비 인벤 필터
function ExtractionEnchantStone_InvenFiler_MainItem( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end

	-- 강화 레벨 0은 필터링
	local itemSSW			= itemWrapper:getStaticStatus():get()
	local equipSlotNo		= itemWrapper:getStaticStatus():getEquipSlotNo()
	local isNotAccessories	= false
	local isNotCashItem		= true

	if (7 ~= equipSlotNo and 8 ~= equipSlotNo and 9 ~= equipSlotNo and 10 ~= equipSlotNo and 11 ~= equipSlotNo and 12 ~= equipSlotNo and 13 ~= equipSlotNo) then
		isNotAccessories = true
	end

	if (itemWrapper:getStaticStatus():isUsableServant()) then
		isNotAccessories = true
	end

	-- 길드 아이템이면 추출하지 못하도록 필터링한다.
	if (itemWrapper:getStaticStatus():isGuildStockable()) then
		isNotAccessories = false
	end

	if itemWrapper:isCash() then
		isNotCashItem = false
	end

	return ( false == ( (0 < itemSSW._key:getEnchantLevel()) and (itemSSW._key:getEnchantLevel() < 16) and isNotAccessories and isNotCashItem ) )
end

-- 강화석 추출, 인벤 필터 후 우클릭
function ExtractionEnchantStone_InteractortionFromInventory( slotNo, itemWrapper, count_s64, inventoryType )
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
	local itemWrapper = getInventoryItemByType( inventoryType, slotNo )
	-- 인벤 선택 아이템이 상단 슬롯에 꼽힘.
	self._equipItem:setItem( itemWrapper )

	-- 마우스 on 툴팁
	self._equipItem.icon:addInputEvent( "Mouse_On", 	"Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"inventory\", true)" )
	self._equipItem.icon:addInputEvent( "Mouse_Out",	"Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"inventory\", false)" )
	Panel_Tooltip_Item_SetPosition(slotNo, self._equipItem, "inventory")

	-- 강화석 개수 설정
	local ItemEnchantStaticStatus = itemWrapper:getStaticStatus():get()
	local blackStone_Count = ItemEnchantStaticStatus._key:getEnchantLevel()

	local thisIsWeapone = ( ItemEnchantStaticStatus:isWeapon() or ItemEnchantStaticStatus:isSubWeapon() )
	if thisIsWeapone then
		if 8 <= blackStone_Count then
			blackStone_Count = "?"
		end
	else
		if 6 <= blackStone_Count then
			blackStone_Count = "?"
		end
	end
	
	self._blackStone_Count:SetText( blackStone_Count )

	-- 장비 종류에 따라, 텍스쳐를 하단에 꼽자.
	if ( itemWrapper:getStaticStatus():get():isWeapon() ) or ( itemWrapper:getStaticStatus():get():isSubWeapon() ) then
		-- 무기 강화석
		self._blackStone_Weapon:SetShow(true)
		self._blackStone_Weapon:SetMonoTone(true)
		self._blackStone_Armor:SetShow(false)
		self._blackStone_Count:SetShow(true)
	else
		-- 방어구 강화석
		self._blackStone_Weapon:SetShow(false)
		self._blackStone_Armor:SetShow(true)
		self._blackStone_Armor:SetMonoTone(true)
		self._blackStone_Count:SetShow(true)
	end

	Inventory_SetFunctor( ExtractionEnchantStone_InvenFiler_MainItem, ExtractionEnchantStone_InteractortionFromInventory, ExtractionEnchantStone_WindowClose, nil )
end

function ExtractionEnchantStone_EquipSlotRClick( )
	EnchantManager._circleEff:ResetVertexAni()
	EnchantManager._circleEff:SetVertexAniRun( "Ani_Color_Off",true )
	EnchantManager._circleEff:SetVertexAniRun( "Ani_Rotate_New",true )
	EnchantManager:clear()
	Inventory_SetFunctor( ExtractionEnchantStone_InvenFiler_MainItem, ExtractionEnchantStone_InteractortionFromInventory, ExtractionEnchantStone_WindowClose, nil )
end

-- 추출하기 버튼을 눌렀다!
function ExtractionEnchant_ApplyReady()
	-- 정말 추출할 거야?
	local messageContent	= PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_APPLYREADY") -- "이 장비의 강화석을 추출하시겠습니까?\n강화석을 추출한 장비는 파괴됩니다."
 	local messageboxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = messageContent, functionYes = ExtractionEnchant_Apply, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

-- 추출하기 버튼을 눌렀다!
function ExtractionEnchant_Apply()
	local self = EnchantManager
	ToClient_ExtractBlackStone(self._extraction_TargetWhereType, self._extraction_TargetSlotNo )

	-- 블랙스톤 추출 효과음~
	audioPostEvent_SystemUi(05,10)
	FGlobal_MiniGame_RequestExtraction() -- 강화석 추출 Quest Check!
end

function ExtractionEnchant_CheckTime( DeltaTime )
	local self = EnchantManager
	
	self._currentTime = self._currentTime + DeltaTime
	-- 윗 서클이 돌고 주변이 환해진다.
	if (0 < self._currentTime) and (1 > self._currentTime) and (true == self._doExtracting) then
		self._extracting_Effect_Step1:SetShow(true)	-- 윗 서클
		if nil == extracting_Effect_Step1 then
			extracting_Effect_Step1 = self._extracting_Effect_Step1:AddEffect("UI_StoneExtract_01", false, 0, 0)
			extracting_Effect_Step1 = self._extracting_Effect_Step1:AddEffect("UI_ItemJewel", false, 0, 0)
			extracting_Effect_Step1 = self._extracting_Effect_Step1:AddEffect("fUI_StoneExtract_SpinSmoke01", false, 0, 0)
		end
		self._extracting_Effect_Step2:SetShow(false)	-- 중간 직선
		self._extracting_Effect_Step3:SetShow(false)	-- 아랫 서클

	-- 장비가 환해지면서 사라진다.
	elseif (1 <= self._currentTime) and (1.8 > self._currentTime) and (true == self._doExtracting) then
		self._extracting_Effect_Step1:SetShow(true)
		self._extracting_Effect_Step2:SetShow(false)
		self._extracting_Effect_Step3:SetShow(false)
		
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
		self._extracting_Effect_Step2:SetShow(false)
		self._extracting_Effect_Step3:SetShow(false)

	--아랫 서클이 돌고 에너지가 뭉친다.
	elseif (2.3 <= self._currentTime) and (3 > self._currentTime) and (true == self._doExtracting) then
		self._extracting_Effect_Step1:SetShow(true)
		self._extracting_Effect_Step2:SetShow(false)
		self._extracting_Effect_Step3:SetShow(false)
		if (nil == blackStone_Weapon_Effect) then
			blackStone_Weapon_Effect = self._blackStone_Weapon:AddEffect("UI_ItemEnchant01", false, -2.5, -2.5)
		end
		if (nil == blackStone_Armor_Effect) then
			blackStone_Armor_Effect = self._blackStone_Armor:AddEffect("UI_ItemEnchant01", false, -2.5, -2.5)
		end

	-- 블랙스톤이 생긴다.
	elseif (3 <= self._currentTime) and (3.8 > self._currentTime) and (true == self._doExtracting) then
		self._extracting_Effect_Step3:SetShow(false)
		self._blackStone_Weapon:SetMonoTone(false)
		self._blackStone_Armor:SetMonoTone(false)
		-- 블랙 스톤 켜 줌.

	elseif (3.8 <= self._currentTime) and (4 > self._currentTime) and (true == self._doExtracting) then
		if nil ~= extracting_Effect_Step1 then
			self._extracting_Effect_Step1:EraseEffect( extracting_Effect_Step1)
			extracting_Effect_Step1 = nil
		end
		if nil ~= blackStone_Weapon_Effect then
			self._blackStone_Weapon:EraseEffect( blackStone_Weapon_Effect )
			blackStone_Weapon_Effect = nil
		end
		if nil ~= blackStone_Armor_Effect then
			self._blackStone_Armor:EraseEffect( blackStone_Armor_Effect )
			blackStone_Armor_Effect = nil
		end
				
		ExtractionEnchant_SuccessXXX()
	end
end

Panel_Window_Extraction_EnchantStone:RegisterUpdateFunc("ExtractionEnchant_CheckTime")

-- 메시지 띄우기
function	ExtractionEnchant_Success()
	local self = EnchantManager
	
	-- 이팩트 카운트 초기화
	self._currentTime  = 0
	self._doExtracting = true
end

function	ExtractionEnchant_SuccessXXX()
	local self = EnchantManager
		
	-- 체크 변수 초기화		
	self._doExtracting	= false
	self._currentTime	= 0
	
	ExtractionEnchantStone_resultShow()
	-- 결과를 알리고 
	EnchantManager:clear()
	-- 장비 슬롯 초기화
end

-- 강화 메시지가 떠 있는 시간을 저장하는 변수
local  ResultMsg_ShowTime = 0
function ExtractionEnchantStone_resultShow()
	if false == Panel_Window_Extraction_Result:GetShow() then
		Panel_Window_Extraction_Result:SetShow(true)
		ResultMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_RESULTMSG") ) -- 강화석이 추출되었습니다.
		ResultMsg_ShowTime = 0
	end
end

function Chk_Extraction_ResultMsg_ShowTime( DeltaTime )
	ResultMsg_ShowTime = ResultMsg_ShowTime + DeltaTime
	if (3 < ResultMsg_ShowTime) and (true == Panel_Window_Extraction_Result:GetShow()) then
		Panel_Window_Extraction_Result:SetShow(false)
	end

	if (5 < ResultMsg_ShowTime) then
		ResultMsg_ShowTime = 0
	end
end

function ExtractionResult_TimerReset()
	ResultMsg_ShowTime = 0
end

-- 강화 성공 메시지 창이 떠 있는 동안 아래 함수가 돈다.
Panel_Window_Extraction_Result:RegisterUpdateFunc("Chk_Extraction_ResultMsg_ShowTime")

function ExtractionEnchantStone_WindowOpen()
	Panel_Window_Extraction_EnchantStone:SetShow(true, true)
	Panel_Window_Extraction_EnchantStone:SetPosY( getScreenSizeY() - ( getScreenSizeY() / 2 ) - ( Panel_Window_Extraction_EnchantStone:GetSizeY() / 2 ) - 20 )
	Panel_Window_Extraction_EnchantStone:SetPosX( getScreenSizeX() - ( getScreenSizeX() / 2 ) - ( Panel_Window_Extraction_EnchantStone:GetSizeX() / 2 ))
	Inventory_SetFunctor( ExtractionEnchantStone_InvenFiler_MainItem, ExtractionEnchantStone_InteractortionFromInventory, ExtractionEnchantStone_WindowClose, nil )
	InventoryWindow_Show()
	EnchantManager._doExtracting = false
end

function ExtractionEnchantStone_WindowClose()
	-- 꺼준다
	Inventory_SetFunctor( nil )
	Panel_Window_Extraction_EnchantStone:SetShow(false, false)
	EnchantManager:clear()
end



EnchantManager:initialize()
EnchantManager:clear()
EnchantManager:registMessageHandler()
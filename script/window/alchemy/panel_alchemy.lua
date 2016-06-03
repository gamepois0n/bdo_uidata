Panel_Alchemy:ActiveMouseEventEffect(true)
Panel_Alchemy:SetShow(false,false)
Panel_Alchemy:setGlassBackground(true)

Panel_Alchemy:RegisterShowEventFunc( true, 'AlchemyShowAni()' )
Panel_Alchemy:RegisterShowEventFunc( false, 'AlchemyHideAni()' )

local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 	 = Defines.Color
local UI_AH 	= CppEnums.PA_UI_ALIGNHORIZON
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode

local _slotConfig =
{	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon		= true,
	createBorder	= true,
	createCount		= true,
	createCash		= true
}

local RecentCook = 
{
	recentCookCount 	= 10,

	_listStartPosY		= 41,
	_listPosYGap		= 43,

	_listNumStartPosY	= 48,
	_listNumPosYGap		= 43,

	_listSlotStartPosX	= 10,
	_listSlotPosXGap	= 35,
	_listSlotStartPosY	= 45,
	_listSlotPosYGap	= 43,

	_listPool			= {},
	_itemPool			= {},
}

local _cookBG_Back = UI.getChildControl( Panel_Alchemy, "Static_Pot_Back" );
local _cookBG_Front = UI.getChildControl( Panel_Alchemy, "Static_Pot_Front" );

local _alchemyBG_Back = UI.getChildControl( Panel_Alchemy, "Static_Pot_Back_2" );
local _alchemyBG_Front = UI.getChildControl( Panel_Alchemy, "Static_Pot_Front_2" );

local recentCookClose = UI.getChildControl( Panel_RecentCook, "Button_Close" )
local recentCookTitle = UI.getChildControl( Panel_RecentCook, "StaticText_Title" )

-- 애니메이션용 슬롯( )
local _aniSlotParent = nil;
local _aniItemSlot = nil;

local SLOT_START_POSX = 81
local SLOT_START_POSY = 378
local SLOT_GAP_POSX = 10

local _slotCount = 5;
local _slotItemKey = {}
local _slotList = {};
for index = 0, _slotCount-1, 1 do
	local createdSlot = {};
	SlotItem.new( createdSlot, 'ItemIconSlot'..index , 0, Panel_Alchemy, _slotConfig );
	createdSlot:createChild();
	createdSlot.icon:addInputEvent( "Mouse_RUp",	"Alchemy_MaterialSlot_Mouse_RUp(" ..index.. ")" )
	createdSlot.icon:addInputEvent( "Mouse_On",		"Alchemy_Tooltip_Item_Show(" ..index.. ")" )
	createdSlot.icon:addInputEvent( "Mouse_Out",  	"Alchemy_Tooltip_Item_Hide(" ..index.. ")" )
	createdSlot.icon:SetIgnore(false);

	-- 한줄에 8개이다.
	local posX = SLOT_START_POSX + (index*createdSlot.icon:GetSizeX()) + (index * SLOT_GAP_POSX)
	local posY = SLOT_START_POSY;

	createdSlot.icon:SetPosX( posX );
	createdSlot.icon:SetPosY( posY );

	if( index < 8 ) then
		posX = SLOT_START_POSX + (index*createdSlot.icon:GetSizeX()) + (index * SLOT_GAP_POSX)
		posY = SLOT_START_POSY;
	else
		posX = SLOT_START_POSX + ((index- 8)*createdSlot.icon:GetSizeX()) + (index * SLOT_GAP_POSX)
	    posY = SLOT_START_POSY + createdSlot.icon:GetSizeY();
	end
	_slotList[index] = createdSlot;
end

local _uiButtonStartAlchemy = UI.getChildControl( Panel_Alchemy, "Button_StartAlchemy")
_uiButtonStartAlchemy:addInputEvent( "Mouse_LUp",  "Alchemy_Start()" )

local _uiButtonMassProduction = UI.getChildControl( Panel_Alchemy, "Button_MassProduction")
_uiButtonMassProduction:addInputEvent( "Mouse_LUp", "Alchemy_MassProductionMSG()")

local _uiButtonClose 	= UI.getChildControl( Panel_Alchemy, "Button_Close" )
_uiButtonClose:addInputEvent( "Mouse_LUp",  "Alchemy_Close()" )

local _buttonQuestion 	= UI.getChildControl ( Panel_Alchemy, "Button_Question" )		-- 물음표 버튼
_buttonQuestion:SetShow( false )

local _uiWindowTitle 	= UI.getChildControl( Panel_Alchemy, "StaticText_Title" )
local _uiCircleName 	= UI.getChildControl( Panel_Alchemy, "StaticText_CircleName" )
local _uiAlchemyIcon 	= UI.getChildControl( Panel_Alchemy, "Static_AlchemyIcon" )

local _frameAlchemy		= UI.getChildControl ( Panel_Alchemy, 	"Frame_Alchemy" )
local _frameScroll		= UI.getChildControl ( _frameAlchemy, 	"VerticalScroll" )
local _frameContent		= UI.getChildControl ( _frameAlchemy, 	"Frame_1_Content" )


local _uiAlchemyDesc 	= UI.getChildControl( _frameContent, "StaticText_AlchemyDesc" )
local _uiListBG			= UI.getChildControl( Panel_Alchemy, "Static_ListBG" )
local _uiNotice1		= UI.getChildControl( Panel_Alchemy, "StaticText_description1" )
-- local _uiNotice2		= UI.getChildControl( Panel_Alchemy, "StaticText_description2" )

local _uiListScroll		= UI.getChildControl( Panel_Alchemy, "Scroll_Bar" )
_uiListScroll:GetControlButton():addInputEvent("Mouse_LPress","AlchemyList_ScrollEvent()" )

local _uiListSelect		= UI.getChildControl( Panel_Alchemy, "Static_SelectList" )
_uiListSelect:SetShow(false)
_uiListSelect:SetIgnore(true)

local TEPLATE_KNOWLEDGE_TEXT = UI.getChildControl( Panel_Alchemy, "StaticText_AlchemyRecipe" )
TEPLATE_KNOWLEDGE_TEXT:SetShow(false)

local KNOWLEDGE_TEXT_COUNT = 13
local _uiListText	=	{}
for index = 0, KNOWLEDGE_TEXT_COUNT-1 do

	local tempText = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, _uiListBG, 'StaticText_AlchemyRecipe_' .. (index) )
	CopyBaseProperty( TEPLATE_KNOWLEDGE_TEXT, tempText );

	tempText:SetPosX( 15 )
	tempText:SetPosY( 15 + (index*tempText:GetSizeY() ) );
	tempText:addInputEvent( "Mouse_UpScroll",	"AlchemyList_ScrollEvent( true )" )
	tempText:addInputEvent( "Mouse_DownScroll",	"AlchemyList_ScrollEvent( false )" )
	tempText:addInputEvent( "Mouse_LUp",  		"AlchemyList_SelectKnowledge("..index..")" )
	tempText:SetIgnore( false );

	_uiListText[index] = tempText;
end

local COOK_MENTALTHEMEKEY = 30010
local COOK_NORMAL_MENTALTHEMEKEY = 28001
local COOK_SPECIAL_MENTALTHEMEKEY = 28002
local AlCHEMY_MENTALTHEMEKEY = 31000
local _currentMentalKey = 0
local _startKnowledgeIndex = 0

function AlchemyShowAni()
	UIAni.fadeInSCR_Down( Panel_Alchemy )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)
	FGlobal_SetNumberPadUiModeNotInput(true)
	_aniSlotParent:AddEffect("fUI_AlchemyCook01", true, 0, 0)

	local aniInfo1 = Panel_Alchemy:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_Alchemy:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Alchemy:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Alchemy:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Alchemy:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Alchemy:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function AlchemyHideAni()
	Panel_Alchemy:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Alchemy:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
	FGlobal_SetNumberPadUiModeNotInput(false)
	_aniSlotParent:EraseAllEffect()
end


------------------------------------------------------------
-- 			아이템 넣을 때 뱅글뱅글 애니메이션
------------------------------------------------------------
function AlchemyItemSlotAni()
	local posX =  80
	local posY =  -100
	local timeRate = 1.0

	-- ♬ 재료 투척 빙글빙글♡
	audioPostEvent_SystemUi(12,12)
	
	local aniCtrl = _aniItemSlot.icon
	aniCtrl:SetShow( true )
	aniCtrl:AddEffect( "fUI_AlchemySplash01", false, 0, 0 )

	local aniInfo = aniCtrl:addMoveAnimation( 0.0 * timeRate, 1.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR )
	aniInfo.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo:SetStartPosition( posX, posY  )
	aniInfo:SetEndPosition( posX, posY + 180 )

	local aniInfo2 = aniCtrl:addRotateAnimation( 0.0 * timeRate, 1.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR )
	aniInfo2:SetStartRotate( 0.0 )
	aniInfo2:SetEndRotate( 1.0 )
	aniInfo2:SetRotateCount( 1 )

end

------------------------------------------------------------
--				SHOW 해주는 함수인 듯 하다
------------------------------------------------------------
function Alchemy_Show(_isCook)
	Inventory_SetFunctor( Alchemy_InvenFilter, Alchemy_PushItemFromInventory, Alchemy_Close, nil  )

	--------------------------------------------
	-- 스크롤은 처음 열릴때만 위치 초기화.
	_startKnowledgeIndex = 0
	_uiListScroll:SetControlPos(0)
	_frameAlchemy:UpdateContentScroll()		-- 스크롤 감도 동일하게
	_uiListSelect:SetShow(false)

	RequestAlchemy_clear()
	Alchemy_UpdateSlot()

	-------------------------------------------------------------------------------------------
	-- 우선 요리 지식을 재구성한다. 추후에 연금술 category가 늘어나면 선택할 수 있게해줘야한다.
	ReconstructionAlchemyKnowledge( _currentMentalKey )
	Alchemy_UpdateKnowledge()

	Panel_Alchemy:SetShow(true,true)
	if (getScreenSizeX() / 2 ) < ( Panel_Window_Inventory:GetSizeX() + ( Panel_Alchemy:GetSizeX() / 2 ) ) then
		Panel_Alchemy:SetPosX( getScreenSizeX() - Panel_Window_Inventory:GetSizeX() - Panel_Alchemy:GetSizeX() + 20 )
	end
	FGlobal_SetInventoryDragNoUse(Panel_Alchemy)

	_uiNotice1:SetTextMode( UI_TM.eTextMode_AutoWrap )
	_uiNotice1:SetAutoResize( true )
	_uiNotice1:SetText( PAGetString(Defines.StringSheet_RESOURCE, "ALCHEMY_COOK_TEXT_DESCRPITION") )
	-- _uiNotice2:SetTextMode( UI_TM.eTextMode_AutoWrap )
	-- _uiNotice2:SetAutoResize( true )
	-- _uiNotice2:SetPosY(_uiNotice1:GetPosY() + _uiNotice1:GetSizeY())

	_uiAlchemyDesc:SetAutoResize(true)
	_uiAlchemyDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )

	-------------------------------------------------------
	-- 		_isCook으로 첫 메시지 판단하고 출력한다.
	if _isCook == true then		-- 요리 창을 열었다!
		_uiAlchemyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_WANTMORE_SELECT_COOKKNOWLEDGE")) 
		-- 요리 지식을 선택하면 자세한 내용을 볼 수 있습니다.
		-- 물음표 대상 요리
		_buttonQuestion:SetShow( true )
		_buttonQuestion:addInputEvent( "Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"PanelCook\" )" )			-- 물음표 좌클릭
		_buttonQuestion:addInputEvent( "Mouse_On",		"HelpMessageQuestion_Show( \"PanelCook\", \"true\")" )	-- 물음표 마우스오버
		_buttonQuestion:addInputEvent( "Mouse_Out",		"HelpMessageQuestion_Show( \"PanelCook\", \"false\")" )	-- 물음표 마우스아웃
		-- ♬ 보글보글. 요리 열었음
		audioPostEvent_SystemUi(12,11)
	else
		_uiAlchemyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_WANTMORE_SELECT_ALCHEMYKNOWLEDGE"))
		-- 연금 지식을 선택하면 자세한 내용을 볼 수 있습니다.
		-- 물음표 대상 연금술
		_buttonQuestion:SetShow( true )
		_buttonQuestion:addInputEvent( "Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"PanelAlchemy\" )" )			-- 물음표 좌클릭
		_buttonQuestion:addInputEvent( "Mouse_On",		"HelpMessageQuestion_Show( \"PanelAlchemy\", \"true\")" )	-- 물음표 마우스오버
		_buttonQuestion:addInputEvent( "Mouse_Out",		"HelpMessageQuestion_Show( \"PanelAlchemy\", \"false\")" )	-- 물음표 마우스아웃
		-- ♬ 연금술 열었음
		audioPostEvent_SystemUi(12,11)
	end

	_frameScroll:SetShow(false)
	_frameContent:SetSize( _frameContent:GetSizeX(), _uiAlchemyDesc:GetSizeY() )
end

function Alchemy_InvenFilter( slotNo, itemWrapper )
	local isVested			= itemWrapper:get():isVested()
	local isPersonalTrade	= itemWrapper:getStaticStatus():isPersonalTrade()

	if (isUsePcExchangeInLocalizingValue()) then
		local isFilter = ( isVested and isPersonalTrade )
		if( isFilter ) then
			return isFilter
		end
	end
end

function Alchemy_Close()
	if Panel_Alchemy:IsShow() then
		local slotCount = RequestAlchemy_getSlotCount();
		for index = 0, _slotCount-1, 1 do
			_slotList[index].icon:SetShow(false);
		end
		Panel_Alchemy:SetShow(false,true);
		Panel_Window_Inventory:SetShow(false,true)
		RecentCookClose()
	end
	-- 호출시 액션이 wait 액션으로 돌아감, 연금술이 시작할때 창을 닫아주므로 우선 주석처리
	--RequestAlchemy_AlchemyStop();
end

function Alchemy_PushItemFromInventory(slotNo, itemWrapper, count)
	if( checkAlchemyAction() ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_NOT_CHANGE") );
		return
	end
	
	Panel_NumberPad_Show(true, count, slotNo, Alchemy_NumberPad_ConfirmBtn )
end

function Alchemy_NumberPad_ConfirmBtn(inputNumber, slotNo)
	local count = RequestAlchemy_getSlotCount()
	if( _slotCount <= count ) then
		--Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT") )
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_CANT_ADD_ITEM") )
		return
	end

	local itemWrapper = getInventoryItem( slotNo )
	if( nil ~= itemWrapper ) then
		if( nil ~= _aniItemSlot ) then
			_aniItemSlot:setItemByStaticStatus( itemWrapper:getStaticStatus(), inputNumber )
			AlchemyItemSlotAni()
		end
	end

	RequestAlchemy_PushItemFromInventory(slotNo, inputNumber)
	Alchemy_UpdateSlot()
end

registerEvent("Event_AlchemyResultList", 		"ResponseAlchemyResultList")
registerEvent("ResponseShowAlchemy", 			"ResponseShowAlchemy")
registerEvent("ResponseAlchemy_updateSlots", 	"ResponseAlchemy_updateSlots")
registerEvent("FromClient_AlchemyFail",			"FromClient_AlchemyFail")
registerEvent("FromClient_UpdateAlchemyRecord",	"FromClient_UpdateAlchemyRecord")

function FromClient_UpdateAlchemyRecord( mentalcardKey )
	RecentCookUpdate( mentalcardKey )
end

function ResponseAlchemy_updateSlots()
	Alchemy_UpdateSlot();
	Alchemy_UpdateKnowledge();
end


function Alchemy_UpdateSlot()
	local slotCount = RequestAlchemy_getSlotCount();
	_slotItemKey = {}
	for index = 0, _slotCount-1, 1 do
		if index < slotCount then
			local itemStatic = RequestAlchemy_getSlotAt(index);
			local itemKey = itemStatic:get()._key
			local itemCount = RequestAlchemy_getSlotItemCount_s64(index);
			_slotList[index]:setItemByStaticStatus( itemStatic, itemCount );
			_slotList[index].icon:SetShow(true);
			_slotItemKey[index] = itemKey
		else
			_slotList[index].icon:SetShow(false);
		end
	end
end

function Alchemy_UpdateKnowledge()

	local count = getCountAlchemyKnowledge();
	if( KNOWLEDGE_TEXT_COUNT < count ) then
		_uiListScroll:SetEnable(true)
		_uiListScroll:SetMonoTone(false)
	else
		_uiListScroll:SetEnable(false)
		_uiListScroll:SetMonoTone(true)
	end

	local endIndex = _startKnowledgeIndex + (KNOWLEDGE_TEXT_COUNT-1);
	if( count-1 < endIndex ) then
		endIndex = count-1
	end

	local ctrlIndex = 0;
	for index=_startKnowledgeIndex, endIndex do
		local mentalCardStaticWrapper = getAlchemyKnowledge(index);
		if( nil ~= mentalCardStaticWrapper ) then
			local isLearn = isLearnMentalCardForAlchemy( mentalCardStaticWrapper:getKey() )
			if( true == isLearn ) then				-- 지식 있을 때 폰트 색깔
				_uiListText[ctrlIndex]:SetFontColor(UI_color.C_FF84FFF5)
				_uiListText[ctrlIndex]:SetText( mentalCardStaticWrapper:getName() );
			else
				_uiListText[ctrlIndex]:SetFontColor(UI_color.C_FF888888)
				_uiListText[ctrlIndex]:SetText( "??? ( " .. mentalCardStaticWrapper:getKeyword() .. " )" )	-- 미확인 지식
			end

			_uiListText[ctrlIndex]:SetShow(true);
		else
			_uiListText[ctrlIndex]:SetShow(false);
		end

		ctrlIndex = ctrlIndex + 1;
	end

end

function AlchemyList_SelectKnowledge( index )

	local posX = _uiListBG:GetPosX() + _uiListText[index]:GetPosX();
	local posY = _uiListBG:GetPosY() + _uiListText[index]:GetPosY();
	_uiListSelect:SetPosX( posX - 15 );
	_uiListSelect:SetPosY( posY - 4 );
	_uiListSelect:SetShow(true);

	local knowledgeIndex = _startKnowledgeIndex + index
	local mentalCardStaticWrapper = getAlchemyKnowledge(knowledgeIndex);
	if( nil ~= mentalCardStaticWrapper ) then

		local isLearn = isLearnMentalCardForAlchemy( mentalCardStaticWrapper:getKey() )
		if( true == isLearn ) then
			_uiAlchemyDesc:SetText( mentalCardStaticWrapper:getDesc() )
			_uiAlchemyIcon:ChangeTextureInfoName(  mentalCardStaticWrapper:getImagePath() )
			if ( 110 < _uiAlchemyDesc:GetSizeY() ) then
				_frameScroll:SetShow(true)
			else
				_frameScroll:SetShow(false)
			end
			_frameScroll:SetControlPos(0)
			_frameContent:SetSize( _frameContent:GetSizeX(), _uiAlchemyDesc:GetSizeY() )
			
			alchemy_RequestRecord( knowledgeIndex )
			-- 알고있는 요리 지식이다. 최근 성공한 요리창을 켜준다.
			Panel_RecentCook:SetShow( true )
			Panel_RecentCook:SetPosX( Panel_Alchemy:GetSizeX() + Panel_Alchemy:GetPosX() - 25 )
			Panel_RecentCook:SetPosY( Panel_Alchemy:GetPosY() +25 )
			Panel_RecentCook:ComputePos()
			RecnetCookSlotClear()
		else
			_uiAlchemyDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_uiAlchemyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_THISKNOWLEDGE_NOT_YET")) -- 해당 지식을 확인하지 못했습니다.
			_uiAlchemyIcon:ChangeTextureInfoName( "UI_Artwork/Unkown_Intelligence.dds" )
			_frameScroll:SetShow(false)
			_frameContent:SetSize( _frameContent:GetSizeX(), _uiAlchemyDesc:GetSizeY() )
			Panel_RecentCook:SetShow( false )
			RecnetCookSlotClear()
		end
				
	end

end

function Alchemy_MaterialSlot_Mouse_RUp( index )

	RequestAlchemy_PopMaterial(index);

	Alchemy_UpdateSlot();
end

function AlchemyList_ScrollEvent( isUp )

	if( false == _uiListScroll:IsEnable() ) then
		return
	end

	local count = getCountAlchemyKnowledge();
	if ( count == 0 ) or ( count <= KNOWLEDGE_TEXT_COUNT) then
		return;
	end

	local maxStartSlotCount = count - KNOWLEDGE_TEXT_COUNT;
	local divideScroll = 1 / maxStartSlotCount;

	if( nil ~= isUp ) then
		if (true == isUp) then
			_startKnowledgeIndex	= _startKnowledgeIndex - 1
			_uiListScroll:ControlButtonUp()
		else
			_startKnowledgeIndex	= _startKnowledgeIndex + 1
			_uiListScroll:ControlButtonDown()
		end

		if	_startKnowledgeIndex < 0	then
			_startKnowledgeIndex	= 0
		end

		if	maxStartSlotCount  < _startKnowledgeIndex	then
			_startKnowledgeIndex	= maxStartSlotCount
		end
	else
		local	currentScrollPos	= _uiListScroll:GetControlPos()
		local	startSlotIndexString	= string.format( "%.0f", currentScrollPos / divideScroll )
		_startKnowledgeIndex	= tonumber(startSlotIndexString)
	end

	_uiListScroll:SetControlPos(  divideScroll * _startKnowledgeIndex )
	AlchemyKnowledge_ClearList()
	Alchemy_UpdateKnowledge();
end

local _isCook = false;	-- 타입으로 바꾸자
function ResponseShowAlchemy(isCook, usingInstallationType)

	_isCook = isCook;

	 if( nil ~= _aniItemSlot ) then
		_aniItemSlot:destroyChild();
		_aniItemSlot = nil
	 end

	_cookBG_Back:SetShow(false);
	_cookBG_Front:SetShow(false);
	_alchemyBG_Back:SetShow(false);
	_alchemyBG_Front:SetShow(false);

	if( false == _isCook ) then
		_aniItemSlot = {};
		_aniSlotParent = _alchemyBG_Back;
		_alchemyBG_Back:SetShow(true);
		_alchemyBG_Front:SetShow(true);
		recentCookTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_RECENTALCHEMYTITLE") ) -- 최근 성공한 연금술
		UI.getChildControl( Panel_Alchemy, "StaticText_Title" ):SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_ALCHEMY")) ; -- 연금술
		_uiButtonStartAlchemy:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_REFINING")) -- 연성하기
		_currentMentalKey = AlCHEMY_MENTALTHEMEKEY;
	else
		_aniItemSlot = {};
		_aniSlotParent = _cookBG_Back;
		_cookBG_Back:SetShow(true);
		_cookBG_Front:SetShow(true);
		recentCookTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_RECENTCOOKTITLE") ) -- 최근 성공한 요리
		UI.getChildControl( Panel_Alchemy, "StaticText_Title" ):SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_COOKING")) ; -- 요리
		_uiButtonStartAlchemy:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_COOK")) -- 요리하기
		_currentMentalKey = COOK_MENTALTHEMEKEY;
	end

	SlotItem.new( _aniItemSlot, 'AniItemSlot1', 0, _aniSlotParent, _slotConfig );
	_aniItemSlot:createChild();
	_aniItemSlot.icon:SetShow(false);

	InventoryWindow_Show()

	Alchemy_Show(_isCook)

end

function ResponseAlchemyResultList( itemDynamicListWrapper )

	local size = itemDynamicListWrapper:getSize()

	for index = 0, size-1, 1 do
		local itemDynamicInformationWrapper = itemDynamicListWrapper:getElement(index)
		local ItemEnchantStaticStatusWrapper = itemDynamicInformationWrapper:getStaticStatus()
		local s64_stackCount 	= itemDynamicInformationWrapper:getCount_s64()
	end
end

function FromClient_AlchemyFail( hint, alchemyType, strErr, bShowMessageBox )
	-- alchemyType = 0 연금술, 1 요리
	-- hint 1 해당 연금식 없음 , 2 재료 부족, 3 연금 레벨 부족 0 strErr 출력
	-- 1. 어떠한 조합에도 해당되지 않을 때 : "이 조합으로는 어떠한 것도 얻을 수 없을 것 같다."
	-- 2. 하나라도 조합에는 해당되는데, 생활 레벨이 안될 때 : "내 실력이 부족해 결과물을 얻을 수 없는 것 같다."
	-- 3. 위의 2경우에 해당되지 않을 때 : "비율을 잘 맞춰보면 무언가 나올 것 같다."
	-- 4. 설비도구 내구도가 0이다.
	
	-- 요리 연금 모두
	-- bShowMessageBox = 연속 생산 실패 시 계속 진행할지 물어보기 위한 파라미터
	if 1 == hint then
		local msg = { main = PAGetString(Defines.StringSheet_GAME, "ALCHEMYFAIL_REASON_1"), sub = "" }

		if 0 == alchemyType then
			Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, 27 )
		else
			Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, 26 )
		end
		-- Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "ALCHEMYFAIL_REASON_1") )
	elseif 2 == hint then
		local msg = { main = PAGetString(Defines.StringSheet_GAME, "ALCHEMYFAIL_REASON_2"), sub = "" }

		if 0 == alchemyType then
			Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, 27 )
		else
			Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, 26 )
		end
		-- Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "ALCHEMYFAIL_REASON_2") )
	elseif 3 == hint then
		local msg = { main = PAGetString(Defines.StringSheet_GAME, "ALCHEMYFAIL_REASON_3"), sub = "" }

		if 0 == alchemyType then
			Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, 27 )
		else
			Proc_ShowMessage_Ack_For_RewardSelect( msg, 2.5, 26 )
		end
		-- Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "ALCHEMYFAIL_REASON_3") )
	elseif 4 == hint then -- 멈추게한다. 연속 생산중이라해도 멈추고, messagebox 는 뿌려주지 않는다.
		Proc_ShowMessage_Ack( strErr )	
		MassProduction_Cancel()
		return;
	else
		Proc_ShowMessage_Ack( strErr )
		bShowMessageBox = false -- 빈슬롯이 없을때 같은 경우 때문에 false처리
	end
	if bShowMessageBox then
		local failMsg = ""
		if ( 0 == alchemyType ) then
			failMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_ALCHEMY")  -- "연금술"
		elseif ( 1 == alchemyType ) then
			failMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_COOKING")  -- "요리"
		end

		local	messageBoxMemo = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ALCHEMY_MSGBOX_FAIL_MEMO", "failMsg", failMsg )  -- failMsg .. "에 실패했습니다. 재료와 개수가 정확하지 않으면 실패할 확률이 생깁니다. 또한 일정 레벨을 요구하는 레시피일 수도 있습니다. 이대로 진행할까요?"
		local	messageBoxData = { title = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMY_MSGBOX_FAIL_TITLE", "failMsg", failMsg), content = messageBoxMemo,  functionYes = MassProduction_Continue, functionNo = MassProduction_Cancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	
end

function MassProduction_Continue()
	local s64_doAlchemyCount = ToClient_GetDoingAlchemyCount()
	RequestAlchemy_AlchemyStart(_isCook, s64_doAlchemyCount)
	
	if( nil == getSelfPlayer() ) then
		_PA_ASSERT(false, "selfplayer가 없습니다. 비정상입니다");
		return 
	end
	
	local tempTime = alchemy_AlchemyTime(_isCook) / 1000;
	if( 0 == tempTime ) then
		return;
	end
	
	if _isCook then
		
		EventProgressBarShow(true, tempTime, 7)
		
		-- ♬ 요리 시작♡
		audioPostEvent_SystemUi(01,00)
	else
		
		EventProgressBarShow(true, tempTime, 9)
		
		-- ♬ 연금술 시작♡
		audioPostEvent_SystemUi(01,00)
	end
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
end

function MassProduction_Cancel()
	ToClient_CancelAlchemy()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
end

function Alchemy_Start()

	local slotCount = RequestAlchemy_getSlotCount();
	if( slotCount <= 0 ) then
		return;
	end
	
	if( nil == getSelfPlayer() ) then
		_PA_ASSERT(false, "selfplayer가 없습니다. 비정상입니다");
		return 
	end
		
	RequestAlchemy_AlchemyStart(_isCook, Defines.s64_const.s64_1);

	local tempTime = alchemy_AlchemyTime(_isCook) / 1000;
	if( 0 == tempTime ) then
		return;
	end
	
	-- 무조건 초
	if _isCook then
		
		EventProgressBarShow(true, tempTime, 7)
		
		-- ♬ 요리 시작♡
		audioPostEvent_SystemUi(01,00)
	else
		
			
		EventProgressBarShow(true, tempTime, 9)
		
		-- ♬ 연금술 시작♡
		audioPostEvent_SystemUi(01,00)
	end

	--Panel_Alchemy:SetShow(false,true);
	InventoryWindow_Close()
	--UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiModeNotInput)
end

function Alchemy_MassProductionMSG()
	local	messageTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE") -- "알 림"
	if _isCook then
		messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MSGBOX_COOK_SEQUENCE_MSG") -- "1회 분의 재료를 올려서 몇 번 조합할지를 결정합니다.\n 1회분의 재료만 올려주세요.\n나머지 재료는 소모됩니다.\n계속 진행 하시겠습니까?"
	else
		messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MSGBOX_ALCHEMY_SEQUENCE_MSG") -- "1회 분의 재료를 올려서 몇 번 연성할지를 결정합니다.\n 1회분의 재료만 올려주세요.\n나머지 재료는 소모됩니다.\n계속 진행 하시겠습니까?"
	end
	local	messageBoxData	= { title = messageTitle, content = messageBoxMemo, functionYes = Alchemy_MassProduction, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData, "middle")
end

-- 연속 생산
local s64_maxCount = Defines.s64_const.s64_0
function Alchemy_MassProduction()
	local slotCount = RequestAlchemy_getSlotCount()
	if( slotCount <= 0 ) then
		return
	end
	
	s64_maxCount = RequestAlchemy_getAlchemyDoMaxCount()
	local s64_2 = toInt64(0, 2)
	
	if s64_maxCount < Defines.s64_const.s64_1 then
		return
	elseif s64_maxCount < s64_2 then
		Alchemy_Start()
		return
	end
	
	Panel_NumberPad_Show(true, s64_maxCount, nil, Alchemy_MassProductionNumberPad_ConfirmBtn )
end

function Alchemy_MassProductionNumberPad_ConfirmBtn(inputNumber)
	if( s64_maxCount < inputNumber ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_STREAMMAKECANTCOUNT") ) -- "연속 생산이 가능한 수량을 초과해서 입력했습니다." )
		return
	end
	
	local s64_2 = toInt64(0, 2)
	if inputNumber < Defines.s64_const.s64_1 then
		return
	elseif inputNumber < s64_2 then
		Alchemy_Start()
		return
	else 
		RequestAlchemy_AlchemyStart(_isCook, inputNumber)
		
		if( nil == getSelfPlayer() ) then
			_PA_ASSERT(false, "selfplayer가 없습니다. 비정상입니다");
			return 
		end
			
		local tempTime = alchemy_AlchemyTime(_isCook) / 1000;
		if( 0 == tempTime ) then
			return;
		end
		
		if _isCook then
			
			EventProgressBarShow(true, tempTime, 7)
		
		-- ♬ 요리 시작♡
			audioPostEvent_SystemUi(01,00)
		else
				
			EventProgressBarShow(true, tempTime, 9)
		
		-- ♬ 연금술 시작♡
			audioPostEvent_SystemUi(01,00)
		end

	--Panel_Alchemy:SetShow(false,true);
	InventoryWindow_Close()
	end
end

function Alchemy_Do()

	if( false == checkAlchemyAction() ) then
		return;
	end

	RequestAlchemy_AlchemyDo();

end

function AlchemyKnowledge_ClearList( )

	for index=0, KNOWLEDGE_TEXT_COUNT-1 do
		_uiListText[index]:SetText("");
		_uiListText[index]:SetShow(false);
	end

	-- _uiKnowledgeBG:SetShow( true );
	_uiListBG:SetShow( true );
	-- _uiListScroll:SetShow( false );

	_uiAlchemyIcon:ReleaseTexture()
	-- _uiAlchemyIcon:ChangeTextureInfoName( ' ' )
	_uiAlchemyIcon:SetShow(true)

	if _isCook then
		_uiAlchemyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_WANTMORE_SELECT_COOKKNOWLEDGE")); -- 요리 지식을 선택하면 자세한 내용을 볼 수 있습니다.
	else
		_uiAlchemyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_WANTMORE_SELECT_ALCHEMYKNOWLEDGE")); -- 연금 지식을 선택하면 자세한 내용을 볼 수 있습니다.
	end
	_frameScroll:SetShow(false)
	_frameContent:SetSize( _frameContent:GetSizeX(), _uiAlchemyDesc:GetSizeY() )
	_uiAlchemyDesc:SetShow(true);
	_uiListSelect:SetShow(false);
end

local _tooltip_Index = nil
function Alchemy_Tooltip_Item_Show(index)
	_tooltip_Index = index
	local itemKey = _slotItemKey[index]
	if itemKey == nil then
		return
	end
	local staticStatusWrapper = getItemEnchantStaticStatus( itemKey )
	local uiBase = _slotList[index].icon
	Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end

function Alchemy_Tooltip_Item_Hide(index)
	if _tooltip_Index ~= index then
		return
	end
	_tooltip_Index = nil
	Panel_Tooltip_Item_hideTooltip()
end

local _slotIconList = {}
function RecentCookInit()
	local self = RecentCook
	for listIdx=0, self.recentCookCount-1 do
		local recentCookList = {}
		recentCookList.cookBG = UI.createAndCopyBasePropertyControl( Panel_RecentCook, "Static_CookRecipeBG", Panel_RecentCook, "RecentCookListBG_" .. listIdx )
		recentCookList.cookBG:SetPosX( 12 )
		recentCookList.cookBG:SetPosY( self._listStartPosY + ( self._listPosYGap * listIdx ) )

		recentCookList.cookNum = UI.createAndCopyBasePropertyControl( Panel_RecentCook, "StaticText_RecentCookNum", Panel_RecentCook, "RecentCookNum_" .. listIdx )
		recentCookList.cookNum:SetPosX( 10 )
		recentCookList.cookNum:SetText( listIdx+1 )
		recentCookList.cookNum:SetPosY( self._listNumStartPosY + ( self._listNumPosYGap * listIdx ) )

		-- local itemStatic = getItemEnchantStaticStatus( ItemEnchantKey(7,0) );
		-- recentSlot.icon:setItemByStaticStatus( itemStatic, 0 );
		recentCookList[0] = UI.createAndCopyBasePropertyControl( Panel_RecentCook, "Static_IconSlot1", Panel_RecentCook, "RecentCookSlot1_" .. listIdx )
		recentCookList[0]:SetPosX( 35 )
		recentCookList[0]:SetPosY( self._listSlotStartPosY + (self._listSlotPosYGap * listIdx ) )

		recentCookList[1] = UI.createAndCopyBasePropertyControl( Panel_RecentCook, "Static_IconSlot2", Panel_RecentCook, "RecentCookSlot2_" .. listIdx )
		recentCookList[1]:SetPosX( 75 )
		recentCookList[1]:SetPosY( self._listSlotStartPosY + (self._listSlotPosYGap * listIdx ) )

		recentCookList[2] = UI.createAndCopyBasePropertyControl( Panel_RecentCook, "Static_IconSlot2", Panel_RecentCook, "RecentCookSlot3_" .. listIdx )
		recentCookList[2]:SetPosX( 115 )
		recentCookList[2]:SetPosY( self._listSlotStartPosY + (self._listSlotPosYGap * listIdx ) )

		recentCookList[3] = UI.createAndCopyBasePropertyControl( Panel_RecentCook, "Static_IconSlot2", Panel_RecentCook, "RecentCookSlot4_" .. listIdx )
		recentCookList[3]:SetPosX( 155 )
		recentCookList[3]:SetPosY( self._listSlotStartPosY + (self._listSlotPosYGap * listIdx ) )

		recentCookList[4] = UI.createAndCopyBasePropertyControl( Panel_RecentCook, "Static_IconSlot2", Panel_RecentCook, "RecentCookSlot5_" .. listIdx )
		recentCookList[4]:SetPosX( 195 )
		recentCookList[4]:SetPosY( self._listSlotStartPosY + (self._listSlotPosYGap * listIdx ) )

		--슬롯 시작
		recentCookList.item = {}
		for idx=0, 4 do
			local recentSlot = {}
			SlotItem.new( recentSlot, 'IconSlot_'.. listIdx .."_"..idx, listIdx, recentCookList[idx], _slotConfig )
			recentSlot:createChild()
			recentSlot.icon:SetPosX( 0 )
			recentSlot.icon:SetPosY( 0 )
			recentSlot.icon:SetSize( 32, 32 )

			recentSlot.count:SetHorizonRight()
			recentSlot.count:SetVerticalBottom()
			recentSlot.count:SetSpanSize(5,2)
			recentSlot.border:SetSize( 32, 32 )

			recentCookList.item[idx] = recentSlot
			-- local itemStatic = getItemEnchantStaticStatus( ItemEnchantKey(7,0) );
			-- recentSlot:setItemByStaticStatus( itemStatic, 9 );
		end

		self._listPool[listIdx] = recentCookList
	end
end

-- 해당 요리를 생성한 적이없으면 별도 이벤트가 들어오지 않기 때문에 별도로 초기화를 해주어야한다.
function RecnetCookSlotClear()
	local self = RecentCook
	for listIdx = 0, self.recentCookCount-1 do	-- 리스트 초기화.
		local list = self._listPool[listIdx]
		list.cookBG:SetShow( false )
		list.cookNum:SetShow( false )
		list.item[0]:clearItem()
		list.item[1]:clearItem()
		list.item[2]:clearItem()
		list.item[3]:clearItem()
		list.item[4]:clearItem()
	end
end

function RecentCookUpdate( mentalcardKey )
	local self = RecentCook
	for listIdx = 0, self.recentCookCount-1 do	-- 리스트 초기화.
		local list = self._listPool[listIdx]
		list.cookBG:SetShow( false )
		list.cookNum:SetShow( false )
		list.item[0]:clearItem()
		list.item[1]:clearItem()
		list.item[2]:clearItem()
		list.item[3]:clearItem()
		list.item[4]:clearItem()
	end


	local recentCookRecipeCount = alchemy_RecordCount()
	if 0 < recentCookRecipeCount then
		for index=0, recentCookRecipeCount-1 do
			local AlchemyRecordWrapper = alchemy_GetRecord( index )
			local materialCount = AlchemyRecordWrapper:getMaterialCount()
			local list = self._listPool[index]
			if nil~= AlchemyRecordWrapper and 0 < materialCount then 
				for itemIndex=0, materialCount-1 do
					local itemStaticWrapper = AlchemyRecordWrapper:getItemStaticStatusWrapper( itemIndex )
					local itemCount = AlchemyRecordWrapper:getItemCount( itemIndex )
					list.item[itemIndex]:setItemByStaticStatus( itemStaticWrapper, itemCount )
					self._listPool[index].cookBG:SetShow( true )
					self._listPool[index].cookNum:SetShow( true )
					list.item[itemIndex].icon:addInputEvent( "Mouse_On", "RecentCookItemToolTipShow(".. itemIndex ..", ".. index .. " )" )
					list.item[itemIndex].icon:addInputEvent( "Mouse_Out", "RecentCookItemToolTipHide()" )
				end
			end
		end
	end
end

function RecentCookItemToolTipShow(itemIndex, index)
	local self = RecentCook
	local AlchemyRecordWrapper = alchemy_GetRecord( index )
	local materialCount = AlchemyRecordWrapper:getMaterialCount()
	local list = self._listPool[index]
	local itemStaticWrapper = AlchemyRecordWrapper:getItemStaticStatusWrapper( itemIndex )
	local itemCount = AlchemyRecordWrapper:getItemCount( itemIndex )
	Panel_Tooltip_Item_Show(itemStaticWrapper, list.item[itemIndex].icon, true, false, nil)	-- Wrapper, uiBase, isStaticWrapper, isItemWrapper, nil
end

function RecentCookItemToolTipHide()
	Panel_Tooltip_Item_hideTooltip()
end

function RecentCookClose()
	Panel_RecentCook:SetShow( false )
	Panel_Tooltip_Item_hideTooltip()
end

function RecentCook_registEventHandler()
	recentCookClose:addInputEvent("Mouse_LUp", "RecentCookClose()")
end

function RecentCook_registMessageHandler()

end

RecentCookInit()
RecentCook_registEventHandler()
RecentCook_registMessageHandler()

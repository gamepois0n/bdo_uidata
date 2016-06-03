local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM 		= CppEnums.TextMode
local cardKeyRaw	= nil

Panel_NewKnowledge:setMaskingChild(true)
Panel_NewKnowledge:ActiveMouseEventEffect(true)
Panel_NewKnowledge:setGlassBackground(true)
Panel_NewKnowledge:RegisterShowEventFunc( true, 'Panel_ImportantKnowledge_ShowAni()' )
Panel_NewKnowledge:RegisterShowEventFunc( false, 'Panel_ImportantKnowledge_HideAni()' )


Panel_NewKnowledge_Value_CountIsCurrent = false

function Panel_ImportantKnowledge_ShowAni()
	Panel_NewKnowledge:SetShow( true )--	임시용
end

function Panel_ImportantKnowledge_HideAni()
	Panel_NewKnowledge:SetShow( false )--	임시용
end

Panel_NewKnowledge:SetShow(false)



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

knowledgeWidget = {}
knowledgeWidget.__index = knowledgeWidget
function knowledgeWidget:showFunctionRaw()
	local newCount = self._cardList:length()
	if( 0 < newCount ) then
		Panel_NewKnowledge_Value_CountIsCurrent = true
		self._staticNewCount:SetText( tostring( newCount ) )
		self._panel:SetShow(true)
		self._buttonNewKnowledge:EraseAllEffect()
		if 0 == self._usingType then
			self._buttonNewKnowledge:AddEffect("fUI_KnowledgeNotice01", true, -2, -2)
		elseif 1 == self._usingType then
			self._buttonNewKnowledge:AddEffect("fUI_KnowledgeNotice_Important01", true, -2, -2)
			self._buttonNewKnowledge:SetPosX( self._buttonNewKnowledge:GetPosX() )
		end
	else
		Panel_NewKnowledge_Value_CountIsCurrent = false
		self._panel:SetShow(false)
	end	
end

function knowledgeWidget:insertCardList(mentalCardStaticStatusWrapper)
	if ( nil == mentalCardStaticStatusWrapper ) then
		return
	end
		
	if ( self._usingType ~= mentalCardStaticStatusWrapper:getMentalCardType() ) then
		return
	end

	local cardData = {
		name		= mentalCardStaticStatusWrapper:getName(),
		desc		= mentalCardStaticStatusWrapper:getDesc(),
		imagePath	= mentalCardStaticStatusWrapper:getImagePath(),
	}
	self._cardList:push_back(cardData)
	if ( false == isFlushedUI() ) then
		self:showFunctionRaw()
	end
	
	-- 카드 키를 저장
	cardKeyRaw = mentalCardStaticStatusWrapper:getKey()
end

function knowledgeWidget:new( arr )
	setmetatable( arr, knowledgeWidget )
		
 	arr._cardList = Array.new()

	return arr
end

function knowledgeWidget:initialize()
	self._buttonNewKnowledge:addInputEvent( "Mouse_LUp", "HandleClicked_ShowNewKnowledgePopup(".. self._usingType .. ")" )
end



knowledgeList = {
	[0] = knowledgeWidget:new(
	{
		_panel					= Panel_NormalKnowledge,
		_buttonNewKnowledge 	= UI.getChildControl ( Panel_NormalKnowledge, "Button_Knowledge" ),		-- 지식 버튼
		_staticNewCount			= UI.getChildControl ( Panel_NormalKnowledge, "StaticText_Number" ),		-- 지식 누적 숫자
		
		_usingType					= 0,
	}),
	[1] = knowledgeWidget:new(
	{
		_panel					= Panel_ImportantKnowledge,
		_buttonNewKnowledge 	= UI.getChildControl ( Panel_ImportantKnowledge, "Button_Important" ),		-- 지식 버튼
		_staticNewCount			= UI.getChildControl ( Panel_ImportantKnowledge, "StaticText_Number" ),		-- 지식 누적 숫자
		
		_usingType					= 1,
	}),
}


function KnowledgeWidget_Restore()
	for _, value in pairs( knowledgeList ) do
		value:showFunctionRaw()
	end
end
UI.addRunPostRestorFunction( KnowledgeWidget_Restore )

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function NewKnowledgeWidget_Show(mentalCardStaticStatusWrapper)
	local temporaryWrapper	= getTemporaryInformationWrapper()
	-- local isPremiumPcRoom	= temporaryWrapper:isPremiumPcRoom()

	if ( nil == mentalCardStaticStatusWrapper ) then
		return
	end

	local target = knowledgeList[mentalCardStaticStatusWrapper:getMentalCardType()]
	if ( nil == target ) then
		return
	end
	target:insertCardList(mentalCardStaticStatusWrapper)
	
	if ( nil ~= GetUIMode ) and ( Defines.UIMode.eUIMode_Default == GetUIMode() ) then
		target:showFunctionRaw()
 	end
	FGlobal_PackageIconUpdate() -- PC방, 스타터 버프, 프리미엄 버프, 펄 버프, 스킬아이콘 위치를 잡을때 지식 아이콘도 같이 잡아주기 위해서 호출한다.
 -- 	if true == isPremiumPcRoom then
	-- 	local knowButtonGap = 540
	--  	local knowCountGap = 79 	
	--  	for i = 0, 1 do
	--  		knowledgeList[i]._panel:SetPosX( knowButtonGap )

	--  		knowButtonGap	= knowButtonGap + 50
	--  		knowCountGap	= knowCountGap + 50
	--   	end
	-- end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local NewKnowledgePopup = 
{
	_panel				= Panel_NewKnowledge,
	_buttonNext 		= UI.getChildControl ( Panel_NewKnowledge, "Button_Next" ),
	_buttonClose		= UI.getChildControl ( Panel_NewKnowledge, "Button_Close" ),
	_buttonWinClose 	= UI.getChildControl ( Panel_NewKnowledge, "Button_WinClose" ),
	_buttonQuestion 	= UI.getChildControl ( Panel_NewKnowledge, "Button_Question" ),		-- 물음표 버튼
	_bubbleNotice 		= UI.getChildControl ( Panel_NewKnowledge, "StaticText_Notice" ),

	_frameKnowledge		= UI.getChildControl ( Panel_NewKnowledge, "Frame_Knowledge_Desc" ),
	_staticTitle		= UI.getChildControl ( Panel_NewKnowledge,		"StaticText_Knowledge_Title" ),
	_staticImage		= UI.getChildControl ( Panel_NewKnowledge,		"Static_Knowledge_Img" ),
	_staticImageBG		= UI.getChildControl ( Panel_NewKnowledge,		"Static_Knowledge_ImgBG" ),
}

function NewKnowledgePopup:initialize()
	self._frameContent		= UI.getChildControl ( self._frameKnowledge,	"Frame_1_Content" )
	self._frameScrollV		= UI.getChildControl ( self._frameKnowledge,	"Frame_1_VerticalScroll" )
	self._staticDesc		= UI.getChildControl ( self._frameContent,		"StaticText_Knowledge_Desc" )
		
	self._buttonNext:addInputEvent( "Mouse_LUp", "HandleClicked_nextNewKnowledge()" )
	self._buttonClose:addInputEvent( "Mouse_LUp", "HandleClicked_closeKnowledgePopup()" )
	self._buttonWinClose:addInputEvent( "Mouse_LUp", "HandleClicked_closeKnowledgePopup()" )
	self._bubbleNotice:SetShow(false)
	
	self._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelImportantKnowledge\" )" )	-- 물음표 좌클릭
	self._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelImportantKnowledge\", \"true\")" )	-- 물음표 마우스오버
	self._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelImportantKnowledge\", \"false\")" )	-- 물음표 마우스아웃
		
	self._staticDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._staticTitle:SetTextMode( UI_TM.eTextMode_AutoWrap )
end
		
function NewKnowledgePopup:show(usingType)
	local target = knowledgeList[usingType]
	local iconPosX = target._panel:GetPosX()
	local iconPosY = target._panel:GetPosY()
	self._usingType = usingType
	-------------------------------
	--		창을 열때만 위치를 잡아준다!
	if not Panel_NewKnowledge:GetShow() then
		self._panel:SetPosX( iconPosX )
		self._panel:SetPosY( iconPosY )
	end

		
	local newCount = target._cardList:length()
	if ( 0 < newCount ) then
		local cardData = target._cardList[1]
		self._staticTitle:SetText( cardData.name )
		self._staticDesc:SetAutoResize( true )
		self._staticDesc:SetText( cardData.desc )
		self._staticDesc:SetSize( self._staticDesc:GetSizeX(), self._staticDesc:GetSizeY() )
		self._staticImage:ChangeTextureInfoName( cardData.imagePath )
				
		self._frameKnowledge:UpdateContentScroll()
		self._frameScrollV:SetControlTop()
		self._frameScrollV:SetInterval(2)
		self._frameKnowledge:UpdateContentPos()
		
		target._cardList:pop_front()
		-------------------------------------------------------
		--	 	지식이 1개 이하일 땐 다음 버튼을 꺼준다!
		--		버릴 카드까지 포함해서 처리한다.
		if ( newCount > 2 ) then
			self._buttonNext:SetShow( true )
		elseif ( newCount == 1 ) then
			self._buttonNext:SetShow( false )
		end
				
		self._panel:SetShow( true, true )
	else
		self._panel:SetShow( false, false )
	end
	target:showFunctionRaw()
end
	
function NewKnowledgePopup:hide()
	if self._panel:IsShow() then
		FGlobal_PackageIconUpdate()
		self._panel:SetShow( false, true )
	end
end




------------------------------------------------
------------------------------------------------
------------------------------------------------
function HandleClicked_ShowNewKnowledgePopup(usingType)
	NewKnowledgePopup:show(usingType)
end
function HandleClicked_nextNewKnowledge()
	NewKnowledgePopup:show(NewKnowledgePopup._usingType)
end
function HandleClicked_closeKnowledgePopup()
	NewKnowledgePopup:hide()
end
------------------------------------------------


function FromClient_NewKnowledge( mentalCardStaticStatusWrapper )
	NewKnowledgeWidget_Show(mentalCardStaticStatusWrapper)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
registerEvent("FromClient_NewKnowledge", 		"FromClient_NewKnowledge" )

for _ , value in pairs(knowledgeList) do
	value:initialize()
end
NewKnowledgePopup:initialize()

function FGlobal_CardKeyReturn()
	return cardKeyRaw
end
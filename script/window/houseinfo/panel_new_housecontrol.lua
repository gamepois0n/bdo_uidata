local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_TM 		= CppEnums.TextMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_PP 		= CppEnums.PAUIMB_PRIORITY
local VCK 			= CppEnums.VirtualKeyCode

eHouseUseGroupType = CppEnums.eHouseUseType


Panel_HouseControl:SetShow( false )
Panel_HouseControl:setMaskingChild( true )
Panel_HouseControl:setGlassBackground(true)
Panel_HouseControl:RegisterShowEventFunc( true, 'Panel_HouseControl_ShowAni()' )
Panel_HouseControl:RegisterShowEventFunc( false, 'Panel_HouseControl_HideAni()' )

-------------------------------------------------
local Panel_HouseControl_Value_HouseKey
---------------------------------------------
-- 				창 끄고 켜기
function Panel_HouseControl_ShowAni()
	Panel_HouseControl:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_HouseControl, 0.0, 0.2 )
end

function Panel_HouseControl_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_HouseControl, 0.0, 0.15 )
	aniInfo:SetHideAtEnd(true)
end

--------------------------------------------------------
--					변수 선언
--------------------------------------------------------
local houseInfoSS = nil

local waitingCancelWorkerNo = {}

HousePanel_Default_PosY=
{
	_UseType_Title 	= 0,
	_UseType_Frame 	= 0,
	_UseType_Scroll	= 0,
	_WorkList_Title = 0,
	_WorkList_Frame = 0,
	_WorkList_Scroll= 0,
	_Manage_Title 	= 0,
	_Manage_Frame 	= 0,
	_Image_Title 	= 0,
	_Image_Frame 	= 0,
	_Progress_Title	= 0,
	_Progress_Frame = 0,
	_Info_Size		= 0,
	_Adjust_Size	= 0,
}

HouseControlManager =
{
	_win_Close					= UI.getChildControl ( Panel_HouseControl, "Button_Win_Close" ),
	_buttonQuestion				= UI.getChildControl ( Panel_HouseControl, "Button_Question" ),		-- 물음표 버튼

	_txt_House_Title			= UI.getChildControl ( Panel_HouseControl, "StaticText_Title" ),
	
	_txt_UseType_Title			= UI.getChildControl ( Panel_HouseControl, "StaticText_UseType_Title" ),
	_controlBG					= UI.getChildControl ( Panel_HouseControl, "Static_HouseControl_BG" ),
	_scrollBar					= UI.getChildControl ( Panel_HouseControl, "Scroll_ScrollBar" ),

	_scrollBarButton			= nil,

	_gradeIconList				= {},
	
	_houseInfo					= nil,
	_houseKey					= 0,
	
	_clickedUseTypeButton		= false,
	_clickedUseType				= 0,

	_clickedIndex				= 0,		--클릭된 index
	_currentUseType				= 0,
	_itemCheck 					= {},

	_offsetIndex				= 0, --스크롤된 수치
	
	_Panel_SizeY				= 0,
	_isUsable					= nil,
	
	_currentLevel				= nil,
	_UseType_Desc				= nil,
	_useTypeName				= nil,
}


local template = 
{
	_button						= UI.getChildControl ( Panel_HouseControl, "Button_Smithy" ),
	_grade						= UI.getChildControl ( Panel_HouseControl, "Button_Smithy_1" ),
	_grade_Mask					= UI.getChildControl ( Panel_HouseControl, "Static_Smithy_Mask" ),
	_onUpgrade					= UI.getChildControl ( Panel_HouseControl, "Static_A_Construction" ),
	_UseTypeIcon				= UI.getChildControl ( Panel_HouseControl, "Static_MakedUseTypeIcon" ),
}

local contributePlus			= UI.getChildControl ( Panel_HouseControl, "Static_ContributePlus" )
local contributeMinus			= UI.getChildControl ( Panel_HouseControl, "Static_ContributeMinus" )


local contentsViewcount = 7


--local 아님
HouseControlManager_buttonList = {}
HouseWorkListSection = 
{
	bgList = {},
	borderList = {},
	overList = {},
	iconList = {},
	levelList = {},
	levelList_nonCraft = {},
	guideList = {},
	viewCount = 4,	-- 리스트 표시 제한 갯수
	viewCount_Craft = 4,	-- 리스트 표시 제한 갯수
	viewCount_nonCraft = 8,	-- 리스트 표시 제한 갯수
	viewIndex = 0,
	contentCount = 0,
	collumMax = 5,
	currentHouseUseType = 0,
	currentReceipeKey	= 0,
	currentLevel	= 0,
	workCount = 0,
	maxCount = 0,
	minCount = 0,
	realTable = {},
	realIndex = {},
	Frame			= UI.getChildControl ( Panel_HouseControl, "Static_WorkList_BG" ),
	scrollButton	= nil,
	Title			= UI.getChildControl ( Panel_HouseControl, "StaticText_WorkList_Title" ),
	BG				= UI.getChildControl ( Panel_HouseControl, "Button_WorkList" ),
	BG_Border		= UI.getChildControl ( Panel_HouseControl, "Static_WorkList_Border" ),
	BG_Over			= UI.getChildControl ( Panel_HouseControl, "Static_WorkList_Over" ),
	level			= UI.getChildControl ( Panel_HouseControl, "StaticText_WorkList_Level" ),
	level_nonCraft	= UI.getChildControl ( Panel_HouseControl, "StaticText_WorkList_Level_nonCraft" ),
	guide			= UI.getChildControl ( Panel_HouseControl, "StaticText_WorkList_Guide" ),
	guide_MyHouse	= UI.getChildControl ( Panel_HouseControl, "StaticText_MyHouse_Guide" ),
	icon			= UI.getChildControl ( Panel_HouseControl, "Static_WorkList_Icon" ),
	scroll			= UI.getChildControl ( Panel_HouseControl, "WorkList_ScrollBar" ),
}

local HouseInfoSection =
{
	_BG					= UI.getChildControl ( Panel_HouseControl, "Static_HouseInfo_BG" ),
	_Name				= UI.getChildControl ( Panel_HouseControl, "StaticText_HouseInfo_Name" ),
	_Desc				= UI.getChildControl ( Panel_HouseControl, "StaticText_HouseInfo_Desc" ),
	_UseType_Icon		= UI.getChildControl ( Panel_HouseControl, "Static_HouseInfo_UseType_Icon" ),
	_UseType_Name		= UI.getChildControl ( Panel_HouseControl, "StaticText_HouseInfo_UseType_Name" ),
	_UseType_Desc		= UI.getChildControl ( Panel_HouseControl, "StaticText_HouseInfo_UseType_Desc" ),
}

local HouseImageSection =
{
	_Title				= UI.getChildControl ( Panel_HouseControl, "StaticText_HouseImage_Title" ),
	_BG					= UI.getChildControl ( Panel_HouseControl, "Static_HouseImage_BG" ),
	_Image				= UI.getChildControl ( Panel_HouseControl, "Static_HouseImage_Image" ),
}

local HouseManageSection =
{
	_Title					= UI.getChildControl ( Panel_HouseControl, "StaticText_Cost_Title" ),
	_BG						= UI.getChildControl ( Panel_HouseControl, "Static_CostBG" ),
		
	_btn_Buy				= UI.getChildControl ( Panel_HouseControl, "Button_Buy_House" ),
	_btn_CantBuy_LD			= UI.getChildControl ( Panel_HouseControl, "Button_CantBuy_LinkDead" ),
	_btn_CantBuy_LowPoint	= UI.getChildControl ( Panel_HouseControl, "Button_CantBuy_LowPoint" ),
	_btn_Sell				= UI.getChildControl ( Panel_HouseControl, "Button_Sell_House" ),
	_btn_CantSell			= UI.getChildControl ( Panel_HouseControl, "Button_CantSell_House" ),
	_cost_BuySell			= UI.getChildControl ( Panel_HouseControl, "StaticText_Cost_BuySell" ),
	_cost_BuySellValue		= UI.getChildControl ( Panel_HouseControl, "StaticText_Cost_BuySell_Value" ),
	_explore_Current		= UI.getChildControl ( Panel_HouseControl, "StaticText_CurrentPoint_Tilte" ),
	_explore_CurrentValue	= UI.getChildControl ( Panel_HouseControl, "StaticText_CurrentPoint_Value" ),
	
	_btn_Change				= UI.getChildControl ( Panel_HouseControl, "Button_ChangeUseType" ),
	_ChangeMax				= UI.getChildControl ( Panel_HouseControl, "Button_ChangeUseType_Max" ),
	_time_Change			= UI.getChildControl ( Panel_HouseControl, "StaticText_ChangeTime" ),
	_time_ChangeValue		= UI.getChildControl ( Panel_HouseControl, "StaticText_ChangeTime_Value" ),
	_cost_Change			= UI.getChildControl ( Panel_HouseControl, "StaticText_ChangeCost" ),
	_cost_ChangeValue		= UI.getChildControl ( Panel_HouseControl, "StaticText_ChangeCost_Value" ),
	_cost_MyMoney			= UI.getChildControl ( Panel_HouseControl, "StaticText_MyMoney" ),
	_cost_MyMoneyValue		= UI.getChildControl ( Panel_HouseControl, "StaticText_MyMoney_Value" ),
	
	_btn_ManageWork			= UI.getChildControl ( Panel_HouseControl, "Button_ManageWork" ),
		
	_BottomPosY				= 0,
	_needTime				= -1,
}

HouseManageSection._ChangeMax:SetEnable( false )
HouseManageSection._ChangeMax:SetMonoTone( true )

local HouseProgressSection =
{
	_Title					= UI.getChildControl ( Panel_HouseControl, "StaticText_ProgressSection_Title" ),
	_BG                     = UI.getChildControl ( Panel_HouseControl, "Static_ProgressSection_BG" ),
	_WorkName               = UI.getChildControl ( Panel_HouseControl, "StaticText_WorkName" ),
	                        
	_Icon_BG                = UI.getChildControl ( Panel_HouseControl, "Static_Working_IconBG" ),
	_Icon_Working           = UI.getChildControl ( Panel_HouseControl, "Static_Working_Icon" ),
	_Icon_UseType           = UI.getChildControl ( Panel_HouseControl, "Static_UseType_Icon" ),
	                        
	_Progress_BG            = UI.getChildControl ( Panel_HouseControl, "Static_WorkingProgress_BG" ),
	_Progress               = UI.getChildControl ( Panel_HouseControl, "Progress2_Working" ),
	_Progress_OnGoing       = UI.getChildControl ( Panel_HouseControl, "Progress2_OnGoing" ),
	                        
	_ProgressText_1         = UI.getChildControl ( Panel_HouseControl, "StaticText_ProgressTxt_1" ),
	_ProgressText_2         = UI.getChildControl ( Panel_HouseControl, "StaticText_ProgressTxt_2" ),
	_ProgressText_Value     = UI.getChildControl ( Panel_HouseControl, "StaticText_Progress_Value" ),
	                        
	_RemainTime             = UI.getChildControl ( Panel_HouseControl, "StaticText_leftTime" ),
	_RemainTime_Vlaue       = UI.getChildControl ( Panel_HouseControl, "StaticText_leftTime_Vlaue" ),
	
	_OnGoingText            = UI.getChildControl ( Panel_HouseControl, "StaticText_OnGoing_Text" ),
	_OnGoingText_Vlaue      = UI.getChildControl ( Panel_HouseControl, "StaticText_OnGoing_Value" ),	
	
	_Btn_CancelWork         = UI.getChildControl ( Panel_HouseControl, "Button_cancelWork" ),
	_Btn_LargCraft	        = UI.getChildControl ( Panel_HouseControl, "Button_LargeCraft" ),

	_Btn_Immediately		= UI.getChildControl ( Panel_HouseControl, "Button_MakeImmediately" ),
	
	_workType			= nil,
	_worker				= nil,
	_workerNo			= {},
	_saveProgress		= 0,
	_saveIcon			= nil,
	_workingProgress	= 0,
	_remainTime			= 0,
	_updateCount 		= 0,
	
	isFale_Init			= false,
	_itemKey_Tooltip	= nil,
}

HouseProgressSection._Btn_Immediately:SetShow(false)	-- 상용화전에는 나오면 안된다 -- 임시처리(who1310)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------ 기본 정보 Section -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function HousePanel_Default_PosY:savePosition()
	self._UseType_Title 	= HouseControlManager._txt_UseType_Title	:GetPosY()
	self._UseType_Frame 	= HouseControlManager._controlBG			:GetPosY()
	self._UseType_Scroll 	= HouseControlManager._scrollBar			:GetPosY()
	self._WorkList_Title 	= HouseWorkListSection.Title				:GetPosY()
	self._WorkList_Frame 	= HouseWorkListSection.Frame				:GetPosY()
	self._WorkList_Scroll 	= HouseWorkListSection.scroll				:GetPosY()
	self._Manage_Title 		= HouseManageSection._Title					:GetPosY()
	self._Manage_Frame 		= HouseManageSection._BG					:GetPosY()
	self._Image_Title 		= HouseImageSection._Title					:GetPosY()
	self._Image_Frame 		= HouseImageSection._BG						:GetPosY()
	self._Progress_Title	= HouseProgressSection._Title				:GetPosY()
	self._Progress_Frame 	= HouseProgressSection._BG                  :GetPosY()
	self._Info_Size			= HouseInfoSection._BG						:GetSizeY()
end

HousePanel_Default_PosY:savePosition()

function HousePanel_Default_PosY:SetPosition()
	HouseControlManager._txt_UseType_Title	:SetPosY(self._UseType_Title 	+ self._Adjust_Size)
	HouseControlManager._controlBG			:SetPosY(self._UseType_Frame 	+ self._Adjust_Size)
	HouseControlManager._scrollBar			:SetPosY(self._UseType_Scroll 	+ self._Adjust_Size)
	HouseWorkListSection.Title				:SetPosY(self._WorkList_Title 	+ self._Adjust_Size)
	HouseWorkListSection.Frame				:SetPosY(self._WorkList_Frame 	+ self._Adjust_Size)
	HouseWorkListSection.scroll				:SetPosY(self._WorkList_Scroll 	+ self._Adjust_Size)
	HouseManageSection._Title				:SetPosY(self._Manage_Title 	+ self._Adjust_Size)
	HouseManageSection._BG					:SetPosY(self._Manage_Frame 	+ self._Adjust_Size)
	HouseImageSection._Title				:SetPosY(self._Image_Title  	+ self._Adjust_Size)
	HouseImageSection._BG					:SetPosY(self._Image_Frame  	+ self._Adjust_Size)
	HouseProgressSection._Title				:SetPosY(self._Progress_Title  	+ self._Adjust_Size)
	HouseProgressSection._BG				:SetPosY(self._Progress_Frame  	+ self._Adjust_Size)
	
	Panel_HouseControl						:SetSize(Panel_HouseControl:GetSizeX(), HouseImageSection._BG:GetPosY() + HouseImageSection._BG:GetSizeY() + 20 )
	Panel_HouseControl						:SetEnableArea( 3, 3, 640, Panel_HouseControl:GetSizeY() - 4 )
end

function FGlobal_Reset_HousePanelPos()
	local PosX = ( getScreenSizeX() - Panel_HouseControl:GetSizeX() ) / 2
	local PosY = ( getScreenSizeY() - Panel_HouseControl:GetSizeY() ) / 2
	Panel_HouseControl:SetPosX(PosX)
	Panel_HouseControl:SetPosY(PosY)	
end
	
function FGlobal_Set_HousePanelPos(_panel)
	if nil == _panel then
		return
	end
	local PosX = _panel:GetPosX()
	local PosY = _panel:GetPosY()
	Panel_HouseControl:SetPosX(PosX)
	Panel_HouseControl:SetPosY(PosY)	
end

local GetBottomPos = function(control)
	if ( nil == control ) then
		UI.ASSERT(false, "GetBottomPos(control) , control nil")
		return
	end
	return control:GetPosY() + control:GetSizeY()
end

function Set_HouseUseType_Texture_BG(_control)
	-- 0 아무것도 아닌타입
	-- 1 일꾼 숙소
	-- 2 창고
	-- 3 목장
	-- 4 무기 단조 공방
	-- 5 갑주 단조 공방
	-- 6 수공예 공방
	-- 7 목공예 공방
	-- 8 세공소
	-- 9 도구 공방
	-- 10 정제소
	-- 11 개량소
	-- 12 대포 제작 공방
	-- 13 조선소
	-- 14 마차 제작소
	-- 15 마구 제작소
	-- 16 가구 공방
	-- 17 특산물 가공소
	-- 18 의상실
	-- 19 공성무기
	-- 20 선박부품
	-- 21 마차부품
	local useType = HouseControlManager._currentGroupType
	local _Target = _control
	if 1 == useType then
		-- 숙소
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 137, 626, 204)
		
	elseif 2 == useType then
		-- 창고
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 273, 626, 340)
	elseif 3 == useType then
		-- 마구간
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 341, 626, 408)
	elseif 4 == useType then
		-- 무기 단조 공방
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 5 == useType then
		-- 갑주 단조 공방
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 6 == useType then
		-- 수공예 공방
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 7 == useType then
		-- 목공예 공방
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 8 == useType then
		-- 세공소
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 9 == useType then
		-- 도구 공방
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 10 == useType then
		-- 정제소
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 11 == useType then
		-- 개량소
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 205, 626, 272)
	elseif 12 == useType then
		-- 대포 제작 공방
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 13 == useType then
		-- 조선소
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 409, 626, 476)
	elseif 14 == useType then
		-- 마차 제작소
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 409, 626, 476)
	elseif 15 == useType then
		-- 마구 제작소
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 16 == useType then
		-- 가구 공방
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 69, 626, 136)
	elseif 17 == useType then
		-- 특산물 가공소
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 477, 626, 544)
	elseif 18 == useType then
		-- 의상실
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 477, 626, 544)
	elseif 19 == useType then
		-- 공성무기
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 477, 626, 544)
	elseif 20 == useType then
		-- 선박부품
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 477, 626, 544)
	elseif 21 == useType then
		-- 마차부품
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 477, 626, 544)
	elseif 0 == useType then
		-- 주거지
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 1, 626, 68)
	else
		-- 빈집
		local path = "new_ui_common_forlua/Window/HouseInfo/HouseInfo_01.dds"
		HouseProgressSection_SetBaseTextureUV( _Target, path, 1, 545, 626, 612)
	end
end

function HouseInfoSection:init()

	self._Name:SetText( HouseControlManager._feature1 )
	
	self._Desc:SetAutoResize( true )
	self._Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._Desc:SetText( HouseControlManager._feature2 )
	
	Set_HouseUseType_Texture_Icon(HouseInfoSection._UseType_Icon)
	
	self._UseType_Name:SetText( HouseControlManager._useTypeName )

	self._UseType_Desc:SetAutoResize( true )
	self._UseType_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	
	HouseControlManager._UseType_Desc = PAGetString( Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_EMPTY" ) 
	if HouseControlManager._currentUseType > -1 then
		HouseControlManager._UseType_Desc = PAGetString( Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_" .. tostring(HouseControlManager._currentUseType) ) 
	end
	
	self._UseType_Desc:SetText( HouseControlManager._UseType_Desc )
	
	Set_HouseUseType_Texture_BG(HouseInfoSection._BG)
	-- self._BG:SetSize(self._BG:GetSizeX(), self._Desc:GetPosY() - self._BG:GetPosY() + self._Desc:GetSizeY() + 5 )
	
	HousePanel_Default_PosY._Adjust_Size = self._BG:GetSizeY() - HousePanel_Default_PosY._Info_Size
	HousePanel_Default_PosY:SetPosition()
end

function HouseImageSection:init()	
	self._BG:AddChild( self._Image )
	Panel_HouseControl:RemoveControl( self._Image )
end
HouseImageSection:init()

function HouseImageSection:setImage(houseInfo)
	-- TODO: 수정할 것
	-- _PA_LOG("LUA","HouseControlManager._screenShotPath : " .. tostring(HouseControlManager._screenShotPath))
	self._Image:ChangeTextureInfoName( HouseControlManager._screenShotPath )
	self._Image:SetPosX( ( self._BG:GetSizeX() - self._Image:GetSizeX() ) / 2 )
	self._Image:SetPosY( ( self._BG:GetSizeY() - self._Image:GetSizeY() ) / 2 )
	self._Image:SetShow(true)
end

-----------------------------------------------------
-- Control Setting 관련 전역 함수
-----------------------------------------------------

function FGlobal_AddChild(_panel, _parent, _child)
	_parent	:AddChild(_child)
	_panel	:RemoveControl(_child)
	
	local _parent_Span = _parent:GetSpanSize()
	local _child_Span = _child:GetSpanSize()
	
	_child	:SetSpanSize(_child_Span.x - _parent_Span.x, _child_Span.y - _parent_Span.y )
end

local _copy_Control = function(_parent, _child, index, _param, rowIndex, collumIndex)
		_child[index] = UI.createControl( _param._type, _parent, tostring(_param._name) .. tostring(rowIndex) .. "_" .. tostring(collumIndex) )		
		CopyBaseProperty( _param._template, _child[index])
		
		_spanX = _param._spanX + _param._gapX * (collumIndex - 1)
		_spanY = _param._spanY + _param._gapY * (rowIndex - 1)		
		_child[index]:SetSpanSize(_spanX, _spanY)
		_child[index]:SetShow(true)		
		_child[index]:SetEnable(true)		
end

local _find_Control = function(_uiBase, _target)
	for key, vlaue in pairs (_uiBase) do
		if tostring(key) == _target then
			return vlaue
		end
	end
end

function FGlobal_Set_Table_Control(_uiBase, _targetName, _gapName, isRow, isCollum)
	local _parent = _uiBase._BG
	local _parent_Span = _parent:GetSpanSize()
	local _target = _find_Control(_uiBase, _targetName)
	local _template = _find_Control(_uiBase._Template, _targetName)
	local _gapBase = _find_Control(_uiBase._Template, _gapName)	
	local _name = _template:GetID() .. "_"
	
	local _GapX = _uiBase._Template._collum_PosX_Gap
	if nil == _GapX then
		_GapX = 0
	end
	local _GapY = _uiBase._Template._row_PosY_Gap
	if nil == _GapY then
		_GapY = 0
	end
	
	local _Param =
	{
		_type = _template:GetType(),
		_name = _name,
		_template = _template,
		_spanX = _template:GetSpanSize().x - _parent_Span.x,
		_spanY = _template:GetSpanSize().y - _parent_Span.y,
		_gapX = _gapBase:GetSizeX() + _GapX,
		_gapY = _gapBase:GetSizeY() + _GapY,
	}
	_template:SetShow(false)	
	
	local index = 1
	if isRow then
		local _rowMax = _uiBase._Template._rowMax
		for rowIndex = 1 , _rowMax do	
			if isCollum then
				local _collumMax = _uiBase._Template._collumMax
				for collumIndex = 1, _collumMax do
					_copy_Control(_parent, _target, index, _Param, rowIndex, collumIndex )	
					index = index + 1
				end
			else 
				_copy_Control(_parent, _target, index, _Param, rowIndex, 1 )
				index = index + 1
			end
		end		
	else
		if isCollum then
			local _collumMax = _uiBase._Template._collumMax
			for collumIndex = 1 , _collumMax do	
				_copy_Control(_parent, _target, index, _Param, 1, collumIndex )
				index = index + 1
			end
		end
	end
end

function FGlobal_Clear_Control(_uiBase)
	for key, value in pairs (_uiBase) do
		value:SetShow(false)
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------ 초기 설정 & 용도 목록 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------
--					초기화 함수
--------------------------------------------------------

local currentLevel = 0
local isMaxLevel = false
local currentLevelSelect = -1
local selectType = -1

function HouseControlManager:initialize()
	self._scrollBarButton = UI.getChildControl ( self._scrollBar, "ScrollBar_CtrlButton" )

	-- self._helpBubble:SetSize(HouseControlManager._helpBubble:GetSizeX(), HouseControlManager._helpBubble:GetSizeY())
	
	self._win_Close:addInputEvent ( "Mouse_LUp", "FGlobal_CloseHoseControl()" )
	self._buttonQuestion:addInputEvent ( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelHouseControl\" )" )		-- 물음표 좌클릭
	self._buttonQuestion:addInputEvent ( "Mouse_On", "HelpMessageQuestion_Show( \"PanelHouseControl\", \"true\")" )		-- 물음표 마우스오버
	self._buttonQuestion:addInputEvent ( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelHouseControl\", \"false\")" )		-- 물음표 마우스아웃
	
	HouseManageSection._btn_Buy:addInputEvent		( "Mouse_LUp", "handleClickedHouseControlBuyHouse()" )
	HouseManageSection._btn_CantBuy_LD:addInputEvent		( "Mouse_LUp", "handleClicked_Check_PrevHouse(true)" )
	HouseManageSection._btn_Sell:addInputEvent		( "Mouse_LUp", "handleClickedHouseControlSellHouse()" )
	HouseManageSection._btn_CantSell:addInputEvent		( "Mouse_LUp", "handleClicked_Check_NextHouse(true)" )
	HouseManageSection._btn_ManageWork:addInputEvent	( "Mouse_LUp", "handleClickedHouseControlDoWorkHouse()" )
	HouseManageSection._btn_Change:addInputEvent ( "Mouse_LUp", "handleClickedHouseControlChangeStateHouse()" )
										  
	--------------------------------------------------------------
	--			버블 도움말의 Z값을 변경해줘야한다	
	-- Panel_HouseControl:SetChildIndex( self._helpBubble:GetKey(), 9999 )
	
	HouseManageSection._btn_Buy:AddChild( contributeMinus )
	HouseManageSection._btn_Sell:AddChild( contributePlus )
	Panel_HouseControl:RemoveControl( contributeMinus )
	Panel_HouseControl:RemoveControl( contributePlus )
	
	-- self._txt_myHouse_Help:SetTextMode( UI_TM.eTextMode_AutoWrap )
	-- self._txt_myHouse_Help:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_HOUSECONTROL_HELP_MYHOUSE" ) )
	
	-- Panel_HouseControl_WorkList:SetShow(false)

	self._controlBG:addInputEvent( "Mouse_UpScroll",	"HouseControlManager:updateScroll(true)" )
	self._controlBG:addInputEvent( "Mouse_DownScroll",	"HouseControlManager:updateScroll(false)" )
	self._scrollBar			:addInputEvent( "Mouse_UpScroll",		"HouseControlManager:updateScroll(true)" )
	self._scrollBar			:addInputEvent( "Mouse_DownScroll",		"HouseControlManager:updateScroll(false)" )
	self._scrollBar:addInputEvent( "Mouse_LPress",		"HouseControlManager:updateScrollPos()" )
	self._scrollBarButton	:addInputEvent( "Mouse_UpScroll",		"HouseControlManager:updateScroll(true)" )
	self._scrollBarButton	:addInputEvent( "Mouse_DownScroll",		"HouseControlManager:updateScroll(false)" )
	self._scrollBarButton:addInputEvent( "Mouse_LPress","HouseControlManager:updateScrollPos()" )

	local type_posYgap = 1
	local type_PosX = template._button:GetSpanSize().x - self._controlBG:GetSpanSize().x
	local type_PosY = template._button:GetSpanSize().y - self._controlBG:GetSpanSize().y
	for index = 1 , contentsViewcount do
		local uigroup = { ui = {} }
		HouseControlManager_buttonList[index] = uigroup
		uigroup._index = index
		
		--template._button
		local button = UI.createControl( UI_PUCT.PA_UI_CONTROL_RADIOBUTTON, self._controlBG, 'Static_Button_' .. index )
		CopyBaseProperty( template._button, button )
		button:SetPosX( type_PosX )
		button:SetPosY( type_PosY )
		button:SetShow( true )
		button:addInputEvent( "Mouse_LUp",			"handleClickedHouseControlSetUseType(" .. index .. ")" )
		button:addInputEvent( "Mouse_UpScroll",		"HouseControlManager:updateScroll(true)" )
		button:addInputEvent( "Mouse_DownScroll",	"HouseControlManager:updateScroll(false)" )
		uigroup.ui._button = button

		type_PosY = type_PosY + button:GetSizeY() + type_posYgap

		local onUpgrade_PosX = template._onUpgrade:GetSpanSize().x - template._button:GetSpanSize().x
		local onUpgrade_PosY = template._onUpgrade:GetSpanSize().y - template._button:GetSpanSize().y
		local onUpgrade = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, button, 'Static_onUpgrade_' .. index )
		CopyBaseProperty( template._onUpgrade, onUpgrade )
		onUpgrade:SetPosX( onUpgrade_PosX )
		onUpgrade:SetPosY( onUpgrade_PosY )
		onUpgrade:SetShow( false )
		onUpgrade:ResetVertexAni()
		
		uigroup._onUpgrade = onUpgrade


		local UseTypeIcon_PosX = template._UseTypeIcon:GetSpanSize().x - template._button:GetSpanSize().x
		local UseTypeIcon_PosY = template._UseTypeIcon:GetSpanSize().y - template._button:GetSpanSize().y
		local UseTypeIcon = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, button, 'Static_UseTypeIcon_' .. index )
		CopyBaseProperty( template._UseTypeIcon, UseTypeIcon )
		UseTypeIcon:SetPosX( UseTypeIcon_PosX )
		UseTypeIcon:SetPosY( UseTypeIcon_PosY )

		uigroup._UseTypeIcon = UseTypeIcon
	
		--template._grade
		uigroup.ui._grade = {}
		uigroup._grade_Mask = {}

		local grade_PosX = template._grade:GetSpanSize().x - template._button:GetSpanSize().x
		local grade_PosY = template._grade:GetSpanSize().y - template._button:GetSpanSize().y
		local grade_posXgap = 1
		for level = 1 , 5 do
			local grade 	 = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, button, 'Static_Grade_' .. index .. "_" .. level )
			local grade_Mask = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, button, 'Static_Grade_Mask_' .. index .. "_" .. level )
			CopyBaseProperty( template._grade, grade )
			CopyBaseProperty( template._grade_Mask, grade_Mask )
			grade:SetPosX( grade_PosX )
			grade:SetPosY( grade_PosY )
			grade_Mask:SetPosX( grade_PosX )
			grade_Mask:SetPosY( grade_PosY )
			grade:SetShow( true )
			grade_Mask:SetShow( false )
			grade:addInputEvent( "Mouse_LUp",			"handleClickedHouseControlSetUseType(" .. index .. ")" )
			grade:addInputEvent( "Mouse_UpScroll",		"HouseControlManager:updateScroll(true)" )
			grade:addInputEvent( "Mouse_DownScroll",	"HouseControlManager:updateScroll(false)" )
			grade:ActiveMouseEventEffect( true )
			
			uigroup.ui._grade[level] = grade
			uigroup._grade_Mask[level] 		= grade_Mask
			grade_PosX = grade_PosX + grade:GetSizeX() + grade_posXgap
		end

		function uigroup:update(houseInfoStaticStatusWrapper)
			local realIndex = HouseControlManager._offsetIndex + self._index -1 -- realIndex = 용도 Button을 넣어줄 Button control의 Index 값

			if ( realIndex < 0 ) or ( houseInfoStaticStatusWrapper:getReceipeCount() <= realIndex ) then
				self.ui._button:SetShow(false)
				return
			end

			local houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)

			self:uicontrol( houseInfoCraftWrapper:getLevel(), houseInfoCraftWrapper:getReciepeName() ) -- 용도 Button에 UseType 이름을 넣고, 레벨 버튼 개수에 맞춰 켜준다.
			self.ui._button:SetShow(true)
			if not HouseControlManager_buttonList[self._index]._onUpgrade:GetShow() then	-- 작업중이지 않을 때 켠다.
				HouseControlManager_buttonList[self._index]._UseTypeIcon:SetShow( true )
			end
			HouseControlManager:UseTypeIconTexture( self._index, houseInfoCraftWrapper:getGroupType() )	-- 용도에 맞춰 아이콘 변경
		end

		function uigroup:uiTextureControl( currentLevel, isSameReceipe ) -- 용도 Button 내부의 레벨 버튼을 현재 레벨에 맞춰 색칠해준다.
			for key, value in pairs( self.ui._grade ) do
				if ( value:GetShow() ) then
					value:ChangeTextureInfoName("new_ui_common_forlua/window/houseinfo/housecontrol_00.dds")
					local x1, y1, x2, y2
					if ( key <= currentLevel ) and ( isSameReceipe ) then
						x1, y1, x2, y2 = setTextureUV_Func( value, 1, 52, 19, 70)
					else
						x1, y1, x2, y2 = setTextureUV_Func( value, 1, 33, 19, 51)
					end
					value:getBaseTexture():setUV(  x1, y1, x2, y2  )
					value:setRenderTexture(value:getBaseTexture())
				end
			end
		end

		function uigroup:updateRentHouse( houseInfoStaticStatusWrapper, rentHouseWrapper )
			local realIndex = HouseControlManager._offsetIndex + self._index -1

			local currentLevel = 0
			local receipeKeyRaw = -1
			if ( nil ~= rentHouseWrapper ) and ( rentHouseWrapper:isSet() ) then
				currentLevel = rentHouseWrapper:getLevel()
				receipeKeyRaw = rentHouseWrapper:getType()
			end

			if ( 0 == receipeKeyRaw ) and ( false == ToClient_IsMyLiveHouse( HouseControlManager._houseKey ) ) then
				currentLevel = 0
			end
						
			local isSameReceipe = receipeKeyRaw == houseInfoStaticStatusWrapper:getReceipeByIndex(realIndex)
			self:uiTextureControl( currentLevel, isSameReceipe )	-- 용도 Button 내부의 레벨 버튼을 현재 레벨에 맞춰 색칠해준다.
		end

		function uigroup:uicontrol( maxLevel, name )   -- 용도 Button에 UseType 이름을 넣고, Control을 켜준다.
			for key, value in pairs( self.ui._grade ) do
				local isShow = (key <= maxLevel)
				value:SetShow( isShow )
			end
			self.ui._button:SetText( name )
		end
		function uigroup:SetTextureUV(pData, pX1, pY1, pX2, pY2)
			pData:ChangeTextureInfoName("new_ui_common_forlua/window/houseinfo/housecontrol_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( pData, pX1, pY1, pX2, pY2 )
			pData:getBaseTexture():setUV(  x1, y1, x2, y2  )
			pData:setRenderTexture(pData:getBaseTexture())
		end

		function uigroup:SetCheck( isCheck ) -- 레벨 버튼의 Check를 모두 끄고/켠다.
			for key, value in pairs( self.ui ) do
				if ( "_grade" ~= key ) then
					value:SetCheck( isCheck )
				end
			end
		end

		function uigroup:SetIgnore( isIgnore )	-- 모든 버튼의 Ignore를 켜고/끈다.
			for key, value in pairs( self.ui ) do
				if ( "_grade" == key ) then
					for key, gradeValue in pairs ( value ) do
						gradeValue:SetIgnore( isIgnore )
					end
				else
					value:SetIgnore( isIgnore )
				end
			end
		end
	end
	
	for key, value in pairs( template ) do
		UI.deleteControl(value)
	end
end

HouseControlManager:initialize()  --- 최초 생성

function HouseControlManager:clear()
	for key,value in pairs (HouseControlManager_buttonList) do
		value._onUpgrade:SetShow(false)
		value._UseTypeIcon:SetShow(false)
		value.ui._button:SetShow(false)
		value.ui._button:ResetVertexAni()
		value.ui._button:SetAlpha(1)
		for _key, _value in pairs (value._grade_Mask) do
			_value:SetShow(false)
		end
	end	
end

function HouseControlManager:updateScroll( isUp )
	-- local houseInfoStaticWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )
	-- if ( nil == houseInfoStaticWrapper ) then
		-- return
	-- end
	if( false == HouseControlManager._isSet	) then
		return;
	end

	local count = HouseControlManager._receipeCount - contentsViewcount
	if ( count < 0 ) then
		count = 0
	end
	if ( isUp ) then
		HouseControlManager._offsetIndex = math.max(HouseControlManager._offsetIndex -1, 0)
	else
		HouseControlManager._offsetIndex = math.min(HouseControlManager._offsetIndex +1, count )
	end
	self._scrollBar:SetControlPos(HouseControlManager._offsetIndex / count)

	HouseControlManager:clear()
	HouseControlManager:UpdateMyHouse()
	HouseControlManager:UpdateCommon()	
end

function HouseControlManager:updateScrollPos()
	local pos = self._scrollBar:GetControlPos()
	
	--local houseInfoStaticWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )
	--local count = houseInfoStaticWrapper:getReceipeCount()

	if ( HouseControlManager._receipeCount < contentsViewcount ) then
		HouseControlManager._offsetIndex = 0
	else
		HouseControlManager._offsetIndex = math.floor( (HouseControlManager._receipeCount - contentsViewcount) * pos )
	end

	HouseControlManager:clear()
	HouseControlManager:UpdateMyHouse()
	HouseControlManager:UpdateCommon()
end

function HouseControlManager:SetIgnore( isIgnore )
	for key, value in pairs(HouseControlManager_buttonList) do
		value:SetIgnore( isIgnore )
	end
end

function HouseControlManager:SetCheck( IsCheck )
	for key, value in pairs(HouseControlManager_buttonList) do
		value:SetCheck( IsCheck )
	end
end


function HouseControlManager:UseTypeIconTexture( index, useType )	-- 리스트 각 용도 아이콘 변경
	local control = HouseControlManager_buttonList[index]._UseTypeIcon
	local pos = {}
	if 1 == useType then		-- 숙소
		pos = { 189, 265, 207, 283 }
	elseif 2 == useType then	-- 창고
		pos = { 208, 265, 226, 283 }
	elseif 3 == useType then	-- 마구간
		pos = { 227, 265, 245, 283 }
	elseif 4 == useType then	-- 무기 단조 공방
		pos = { 246, 265, 264, 283 }
	elseif 5 == useType then	-- 갑주 단조 공방
		pos = { 265, 265, 283, 283 }
	elseif 6 == useType then	-- 수공예 공방
		pos = { 284, 265, 302, 283 }
	elseif 7 == useType then	-- 목공예 공방
		pos = { 303, 265, 321, 283 }
	elseif 8 == useType then	-- 세공소
		pos = { 322, 265, 340, 283 }
	elseif 9 == useType then	-- 도구 공방
		pos = { 170, 284, 188, 302 }
	elseif 10 == useType then	-- 정제소
		pos = { 189, 284, 207, 302 }
	elseif 11 == useType then	-- 개량소
		pos = { 208, 284, 226, 302 }
	elseif 12 == useType then	-- 대포 제작 공방
		pos = { 227, 284, 245, 302 }
	elseif 13 == useType then	-- 조선소
		pos = { 246, 284, 264, 302 }
	elseif 14 == useType then	-- 마차 제작소
		pos = { 265, 284, 283, 302 }
	elseif 15 == useType then	-- 마구 제작소
		pos = { 284, 284, 302, 302 }
	elseif 16 == useType then	-- 가구 공방
		pos = { 303, 284, 321, 302 }
	elseif 17 == useType then	-- 특산물 가공소
		pos = { 322, 284, 340, 302 }
	elseif 18 == useType then	-- 의상실
		pos = { 227, 303, 245, 321 }
	elseif 19 == useType then	-- 공성무기
		pos = { 170, 303, 188, 321 }
	elseif 20 == useType then	-- 선박부품
		pos = { 208, 303, 226, 321 }
	elseif 21 == useType then	-- 마차부품
		pos = { 189, 303, 207, 321 }
	elseif 0 == useType then	-- 주거지
		pos = { 170, 265, 188, 283 }
	else	-- 빈집
		pos = { 0, 0, 0, 0 }
	end

	control:ChangeTextureInfoName( "/New_UI_Common_forLua/Window/HouseInfo/HouseIcon.dds" )			
	local x1, y1, x2, y2 = setTextureUV_Func( control, pos[1], pos[2], pos[3], pos[4] )
	control:getBaseTexture():setUV(  x1, y1, x2, y2  )
	control:setRenderTexture(control:getBaseTexture())	
end

function HouseControlManager:WorkinUseTypeIconTexture( index, useType )	-- 각 용도 작업 중 아이콘 변경
	local control = HouseControlManager_buttonList[index]._onUpgrade
	local path = ""
	if 1 == useType then		-- 숙소
		path = useType .. ".dds"
	elseif 2 == useType then	-- 창고
		path = useType .. ".dds"
	elseif 3 == useType then	-- 마구간
		path = useType .. ".dds"
	elseif 4 == useType then	-- 무기 단조 공방
		path =useType .. ".dds"
	elseif 5 == useType then	-- 갑주 단조 공방
		path = useType .. ".dds"
	elseif 6 == useType then	-- 수공예 공방
		path = useType .. ".dds"
	elseif 7 == useType then	-- 목공예 공방
		path = useType .. ".dds"
	elseif 8 == useType then	-- 세공소
		path = useType .. ".dds"
	elseif 9 == useType then	-- 도구 공방
		path = useType .. ".dds"
	elseif 10 == useType then	-- 정제소
		path = useType .. ".dds"
	elseif 11 == useType then	-- 개량소
		path = useType .. ".dds"
	elseif 12 == useType then	-- 대포 제작 공방
		path = useType .. ".dds"
	elseif 13 == useType then	-- 조선소
		path = useType .. ".dds"
	elseif 14 == useType then	-- 마차 제작소
		path = useType .. ".dds"
	elseif 15 == useType then	-- 마구 제작소
		path = useType .. ".dds"
	elseif 16 == useType then	-- 가구 공방
		path = useType .. ".dds"
	elseif 17 == useType then	-- 특산물 가공소
		path = useType .. ".dds"
	elseif 18 == useType then	-- 의상실
		path = useType .. ".dds"
	elseif 19 == useType then	-- 공성무기
		path = useType .. ".dds"
	elseif 20 == useType then	-- 선박부품
		path = useType .. ".dds"
	elseif 21 == useType then	-- 마차부품
		path = useType .. ".dds"
	elseif 0 == useType then	-- 주거지
		path = useType .. ".dds"
	else	-- 빈집
		path = useType .. ".dds"
	end

	control:ChangeTextureInfoName( "/New_UI_Common_forLua/Window/HouseInfo/useType/" .. path )
	control:setRenderTexture(control:getBaseTexture())	
end

--------------------------------------------------------
--			집 구매시
-- HouseControlManager._clickedGroupType  == 0	.주거지
-- HouseControlManager._clickedGroupType  == 1	숙소
-- HouseControlManager._clickedGroupType  == 2	창고
--------------------------------------------------------

local handleClickedHouseControlBuyHouseContinue = function ()
	ToClient_RequestBuyHouse( HouseControlManager._houseKey, HouseControlManager._clickedUseType)
	
	if ( true == Panel_House_SellBuy_Condition:GetShow() ) and ( true == Panel_HouseControl:GetShow() ) then
		WorldMapPopupManager:pop()	
	end
end

function handleClickedHouseControlBuyHouse()
	if ( workerManager_CheckWorkingOtherChannelAndMsg() ) then
		return
	end

	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )

	if ( false == houseInfoStaticStatusWrapper:isSet() ) then
		return
	end
	local nextRentHouseLevel = 1
	
	local realIndex = houseInfoStaticStatusWrapper:getIndexByReceipeKey(HouseControlManager._clickedUseType)
	local houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)	
	local listCount	= houseInfoStaticStatusWrapper:getNeedItemListCount( HouseControlManager._clickedUseType, nextRentHouseLevel ) 
	local needTime_sec	= houseInfoStaticStatusWrapper:getTransperTime( HouseControlManager._clickedUseType, nextRentHouseLevel, nextRentHouseLevel)
	local needTime = Util.Time.timeFormatting( needTime_sec )
	local houseName = HouseControlManager._houseName
	local useTypeName = houseInfoCraftWrapper:getReciepeName()
	local itemExplain = ""
	itemExplain = itemExplain..PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDPOINT", "needPoint", HouseControlManager._needExplorePoint).."\n"
		
	for index = 0, listCount - 1, 1 do
		local itemKey = houseInfoStaticStatusWrapper:getNeedItemListItemKey( HouseControlManager._clickedUseType, nextRentHouseLevel, index )
		local itemName = getItemEnchantStaticStatus(itemKey):getName()
		local itemCount = houseInfoStaticStatusWrapper:getNeedItemListItemCount( HouseControlManager._clickedUseType, nextRentHouseLevel, index )
			
			
		HouseControlManager._itemCheck[index] = false
		for invenIndex = 0, (inventory_getSize() - 1), 1 do
			if nil ~= getInventoryItem(invenIndex) then
				if itemKey:getItemKey() == getInventoryItem(invenIndex):get():getKey():getItemKey() then
					if itemCount <= getInventoryItem(invenIndex):get():getCount_s64() then 
						HouseControlManager._itemCheck[index] = true
					end	
				end
			end
		end
		local needCost = makeDotMoney(Int64toInt32(itemCount)).." "..itemName
	
		itemExplain = itemExplain..PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDCOST", "needCost", needCost).."\n"
	end
	itemExplain = itemExplain..PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDTIME", "needTime", needTime)
	itemExplain = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BUYHOUSE_CONTENT", "houseName", houseName, "useTypeName", useTypeName) .."\n\n"..itemExplain
	
	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BUYHOUSE_TITLE" ), content = itemExplain, functionYes = handleClickedHouseControlBuyHouseContinue, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData, "top")
end

--------------------------------------------------------
--			집 사용시 
--------------------------------------------------------
local houseUsingLayerFunctionList = {}
function houseUsingLayerFunctionList:beforePop()
	local houseInfoStaticWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )
	local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint( houseInfoStaticWrapper:getParentNodeKey() )
	if ( nil ~= regionInfoWrapper ) and ( regionInfoWrapper:get():isMainOrMinorTown() ) then
		warehouse_requestInfo(houseInfoStaticWrapper:getParentNodeKey())
	end
end
function houseUsingLayerFunctionList:afterPop()
end

function handleClickedHouseControlDoWorkHouse()
	-- 제작 관리를 누를 때
	if false == ToClient_IsUsable( HouseControlManager._houseKey ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_MESSAGE" ) ) -- 용도 변경 중입니다.
	else
		local param =
		{
			_houseName 		= HouseControlManager._houseName,
			_useTypeName	= HouseControlManager._useTypeName,
			_useType_Desc	= HouseControlManager._UseType_Desc,
			_level			= HouseControlManager._currentLevel,
			_useType		= HouseControlManager._currentUseType,
			_houseKey		= HouseControlManager._houseKey,
			_houseUseType	= HouseControlManager._currentGroupType,
		}
		
		if HouseControlManager._currentGroupType == 12 or HouseControlManager._currentGroupType == 13 or HouseControlManager._currentGroupType == 14 then
			FGLobal_PopupAdd(Panel_LargeCraft_WorkManager, houseUsingLayerFunctionList);
			FGlobal_LargeCraft_WorkManager_Open(FGlobal_SelectedHouseInfo(HouseControlManager._houseKey), param)
		else
			
			FGLobal_PopupAdd(Panel_RentHouse_WorkManager, houseUsingLayerFunctionList);
			FGlobal_RentHouse_WorkManager_Open(FGlobal_SelectedHouseInfo(HouseControlManager._houseKey), param)
		end
		-- FGlobal_OpenMultipleWorkManager( FGlobal_SelectedHouseInfo(HouseControlManager._houseKey), CppEnums.NpcWorkingType.eNpcWorkingType_PlantRentHouseLargeCraft )
	end
end

function FGLobal_PopupAdd( panel, addtionalFunctionList )
	if(false == panel:GetShow() ) then
		WorldMapPopupManager:increaseLayer(false, addtionalFunctionList)
		WorldMapPopupManager:push( panel, true )
	end
end

--------------------------------------------------------
--			집 매각시
--------------------------------------------------------
local handleClickedHouseControlSellHouseContinue = function ()
	ToClient_RequestReturnHouse( HouseControlManager._houseKey )
	-- if Panel_House_SellBuy_Condition:GetShow() and Panel_HouseControl:GetShow() then
		WorldMapPopupManager:pop()
--		Panel_House_SellBuy_Condition:SetShow(false)
	-- end
end

function handleClickedHouseControlSellHouse()
	
	local workingcnt = ToClient_getHouseWorkingWorkerList( houseInfoSS )		
	local returnPoint = HouseControlManager._needExplorePoint
	local houseName = HouseControlManager._houseName
	
	if false == ToClient_IsUsable( HouseControlManager._houseKey ) then
		-- 용도 변경 중			
		local sellHouseContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ONCHANGEUSETYPE", "houseName", houseName) .. "\n\n" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RETURNPOINT", "returnPoint", returnPoint)
		local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_TITLE" ), content = sellHouseContent , functionYes = handleClickedHouseControlSellHouseContinue, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData, "top")
	elseif workingcnt > 0 then
		-- 제작 중
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ONCRAFT" ) )
		return
	else
		-- 아무 작업도 하지 않는 상태
		local sellHouseContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_DEFAULT", "houseName", houseName) .. "\n\n" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RETURNPOINT", "returnPoint", returnPoint)
		local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_TITLE" ), content = sellHouseContent , functionYes = handleClickedHouseControlSellHouseContinue, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData, "top")
	end
end

--------------------------------------------------------
--			용도 변경시
--------------------------------------------------------
local handleClickedHouseControlChangeStateHouseContinue = function ()
	local houseIndex = Panel_HouseControl_Value_HouseKey

	local rentHouseWrapper = ToClient_GetRentHouseWrapper( HouseControlManager._houseKey )
	local useType = rentHouseWrapper:getType()
	local level = 1
	if ( useType == HouseControlManager._clickedUseType ) and ( eHouseUseGroupType.Count ~= HouseControlManager._currentGroupType ) then
		level = rentHouseWrapper:getLevel() + 1
	end
	
	ToClient_RequestChangeHouseUseType( HouseControlManager._houseKey, HouseControlManager._clickedUseType, level)
end

function handleClickedHouseControlChangeStateHouse()
	--if false == ToClient_IsUsable( HouseControlManager._houseKey ) then
	--	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_MESSAGE" ) )
	--else	
		local rentHouseWrapper = ToClient_GetRentHouseWrapper( HouseControlManager._houseKey )
		local houseInfoStaticStatusWrapper = rentHouseWrapper:getStaticStatus()
		local useType = rentHouseWrapper:getType()
		local nextRentHouseLevel = 1
		
		if ( HouseControlManager._clickedUseType == useType ) and ( eHouseUseGroupType.Count ~= HouseControlManager._currentGroupType )  then
			nextRentHouseLevel = rentHouseWrapper:getLevel() +1
		end
	
		local realIndex = houseInfoStaticStatusWrapper:getIndexByReceipeKey(HouseControlManager._clickedUseType)
		local houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)
		local targetUseTypeName = houseInfoCraftWrapper:getReciepeName()
		
		realIndex = houseInfoStaticStatusWrapper:getIndexByReceipeKey(HouseControlManager._currentUseType)
		houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)	
		local currentUseTypeName = houseInfoCraftWrapper:getReciepeName()
		
		local rentHouseLevel = rentHouseWrapper:getLevel()
		local listCount = houseInfoStaticStatusWrapper:getNeedItemListCount( HouseControlManager._clickedUseType, nextRentHouseLevel ) 
		local needTime = Util.Time.timeFormatting( houseInfoStaticStatusWrapper:getTransperTime( HouseControlManager._clickedUseType, nextRentHouseLevel, nextRentHouseLevel) )
		local itemExplain = ""
		
		for index = 0, listCount - 1, 1 do
			local itemKey = houseInfoStaticStatusWrapper:getNeedItemListItemKey( HouseControlManager._clickedUseType, nextRentHouseLevel, index )
			local itemName = getItemEnchantStaticStatus(itemKey):getName()
			local itemCount = houseInfoStaticStatusWrapper:getNeedItemListItemCount( HouseControlManager._clickedUseType, nextRentHouseLevel, index )
			
			Panel_HouseControl_Value_HouseKey = HouseControlManager._clickedUseType
			
			HouseControlManager._itemCheck[index] = false
			for invenIndex = 0, (inventory_getSize() - 1), 1 do
				if nil ~= getInventoryItem(invenIndex) then
					if itemKey:getItemKey() == getInventoryItem(invenIndex):get():getKey():getItemKey() then
						if itemCount <= getInventoryItem(invenIndex):get():getCount_s64() then 
							HouseControlManager._itemCheck[index] = true
						end	
					end
				end
			end
			local needCost = Int64toInt32(itemCount).." "..itemName
	
			itemExplain = itemExplain..itemName.." "..Int64toInt32(itemCount)..PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_COUNT" ).."\n"
		end
		itemExplain = itemExplain..PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDTIME", "needTime", needTime)
		local HouseKey = HouseControlManager._houseKey
		local workingcnt = ToClient_getHouseWorkingWorkerList( houseInfoStaticStatusWrapper:get() )
		local _title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_TITLE_1" )
		if false == ToClient_IsUsable( HouseKey ) then
			-- 용도 변경 중
			itemExplain = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_CONTENT_1", "currentTypeName", currentUseTypeName, "targetTypeName", targetUseTypeName) .. "\n\n"..itemExplain
		elseif workingcnt > 0 then
			-- 제작 중
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_CONTENT_2" ) )
			return
		elseif targetUseTypeName == currentUseTypeName then
			-- 단계 상승
			itemExplain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_CONTENT_4", "currentTypeName", currentUseTypeName, "rentHouseLevel", rentHouseLevel, "nextLevel", rentHouseLevel + 1) .. "\n\n"..itemExplain
			_title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_TITLE_2" )
		else
			-- 기본 상태
			itemExplain = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_CONTENT_3", "currentTypeName", currentUseTypeName, "targetTypeName", targetUseTypeName) .. "\n\n"..itemExplain
		end
		
		local messageboxData = { title = _title , content = itemExplain, functionYes = handleClickedHouseControlChangeStateHouseContinue, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData, "top")
	--end	
end

--------------------------------------------------------
--			용도 버튼 클릭 시
--------------------------------------------------------
function handleClickedHouseControlSetUseType(index)

	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )

	if ( false == houseInfoStaticStatusWrapper:isSet() ) then
		return
	end
	local realIndex = HouseControlManager._offsetIndex + index -1
	local receipeKey = houseInfoStaticStatusWrapper:getReceipeByIndex(realIndex)
	local groupType = houseInfoStaticStatusWrapper:getGroupTypeByIndex(realIndex)
	local houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)
	local maxLevel = houseInfoCraftWrapper:getLevel()

	if (HouseControlManager._clickedUseType ~= receipeKey) then
		--TODO: 수정 할 것
		--WorldMapWindow_CloseWorkManage()
	end
	

	HouseControlManager._clickedUseType = receipeKey
	HouseControlManager._clickedUseTypeButton = true
	HouseControlManager._clickedGroupType = groupType

	HouseControlManager:clear()
	HouseControlManager:UpdateMyHouse()
	HouseControlManager:UpdateCommon()
	HouseManageSection:update_ChangeCost()	
	HouseWorkListSection:updateFirstShow(groupType, receipeKey, maxLevel, true)

end

--------------------------------------------------------
--			공통 부분 업데이트
--------------------------------------------------------
function HouseControlManager:UpdateCommon()	
	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( self._houseKey )
	
	if( nil == houseInfoStaticStatusWrapper ) then
		return;
	end
	
	if false == houseInfoStaticStatusWrapper:isSet() then
		return
	end

	local receipeCount = houseInfoStaticStatusWrapper:getReceipeCount()
	UIScroll.SetButtonSize( self._scrollBar, contentsViewcount, receipeCount )	-- 스크롤바 버튼의 크기를 조정한다.
	
	for key, value in pairs( HouseControlManager_buttonList ) do
		-- 용도 Button에 UseType 이름을 넣고, 레벨 버튼 개수에 맞춰 켜준다.
		value:update( houseInfoStaticStatusWrapper )
	end

	local rentHouseWrapper = ToClient_GetRentHouseWrapper( self._houseKey )
	if nil == rentHouseWrapper or false == rentHouseWrapper:isSet() then
		for key, value in pairs( HouseControlManager_buttonList ) do
		-- 용도 Button 내부의 레벨 버튼을 현재 레벨에 맞춰 색칠해준다. (빌린 집 아니니까 모두 검은 칠)
			value:updateRentHouse( houseInfoStaticStatusWrapper, nil )
		end
		return
	end

	for key, value in pairs( HouseControlManager_buttonList ) do
		-- 용도 Button 내부의 레벨 버튼을 현재 레벨에 맞춰 색칠해준다. (빌린 집 이니까, 구입한 Type의 레벨에 색칠)
		value:updateRentHouse( houseInfoStaticStatusWrapper, rentHouseWrapper )
	end
	
end

function HouseControlManager:UpdateCheckTarget(houseInfoStaticStatusWrapper) -- 빈집에서 Type 선택 시, UI에 반영해준다!
	self:SetCheck(false)
	
	local clickedButton = HouseControlManager_buttonList[houseInfoStaticStatusWrapper:getIndexByReceipeKey(self._clickedUseType) - self._offsetIndex + 1]
	if ( nil == clickedButton ) then
		return
	end

	local realIndex = houseInfoStaticStatusWrapper:getIndexByReceipeKey(self._clickedUseType)
	local houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)

	HouseManageSection._btn_Buy:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BUYHOUSE_TITLE" ) .. " : " .. houseInfoCraftWrapper:getReciepeName())	
	
	HouseManageSection:update_ChangeCost()
	
	clickedButton.ui._button:SetCheck( true )
end

--------------------------------------------------------
--					빈 집을 선택했다!!
--------------------------------------------------------

function HouseControlManager:UpdateEmptyHouse() -- 빈집이다! 구매 버튼을 켜주자!
	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( self._houseKey )

	if false == houseInfoStaticStatusWrapper:isSet() then
		return
	end

	local isPurchasable = houseInfoStaticStatusWrapper:isPurchasable(HouseControlManager._clickedGroupType)
	if isPurchasable and HouseControlManager._needExplorePoint <= ToClient_RequestGetMyExploredPoint() then
		HouseManageSection._btn_Buy:SetShow( true )
		HouseManageSection._btn_CantBuy_LowPoint:SetShow( false )
		HouseManageSection._btn_CantBuy_LD:SetShow( false )
	elseif isPurchasable and HouseControlManager._needExplorePoint > ToClient_RequestGetMyExploredPoint() then
		HouseManageSection._btn_Buy:SetShow( false )
		HouseManageSection._btn_CantBuy_LowPoint:SetShow( true )
		HouseManageSection._btn_CantBuy_LD:SetShow( false )
	else
		HouseManageSection._btn_Buy:SetShow( false )
		HouseManageSection._btn_CantBuy_LowPoint:SetShow( false )
		HouseManageSection._btn_CantBuy_LD:SetShow( true )
	end

	HouseManageSection._cost_BuySell:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDEXPLORE" ))
	
	 -- 빈집에서 Type 선택 시, UI에 반영해준다!
	self:UpdateCheckTarget(houseInfoStaticStatusWrapper)

	HouseManageSection._btn_Change:SetShow( false )
	HouseManageSection._btn_Sell:SetShow( false )
	HouseManageSection._btn_ManageWork:SetShow( false )
	-- self._txt_myHouse_Help:SetShow( false )
	
	-- self._currentExplore:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CURRENTEXPLORE" ) )
	HouseManageSection._cost_BuySell:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDEXPLORE" ) )	
	-- self._houseSize:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_HOUSESIZE" ) )		
	
	-- self._currentExplore_R:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_EXPLORE" ).." "..ToClient_RequestGetMyExploredPoint() )
	-- HouseManageSection._cost_BuySellValue:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_EXPLORE" ).." "..houseInfoStaticStatusWrapper:getNeedExplorePoint() )
	-- self._houseSize_R:SetText( self._houseInfo:getStaticStatusWrapper():getObjectStaticStatus():getDescArea() .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_HOUSESIZE_R" ) )
end


--------------------------------------------------------
--				작업관리 버튼이 할일 및 text 결정
--------------------------------------------------------
local changeWorkDataList = {
	--[0] = nil,
	---- [1] = { _text = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_WORKER_MANAGE" ), _runFunc = "WorldMapWindow_OnWaitWorkerManageShowClick()", },
	--[1] = nil,
	--[2] = { _text = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_WAREHOUSE_SHOW" ), _runFunc = "WorldMapWindow_OnWareHouseShowClick()", },
	--[3] = { _text = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_DOWORK" ), _runFunc = "handleClickedHouseControlDoWorkHouse()", },
	--[4] = { _text = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_DOWORK" ), _runFunc = "handleClickedHouseControlDoWorkHouse()", },
	--[5] = { _text = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_DOWORK" ), _runFunc = "handleClickedHouseControlDoWorkHouse()", },
	--[6] = { _text = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_DOWORK" ), _runFunc = "handleClickedHouseControlDoWorkHouse()", },
}

-- local settingChangeWork = function()
	-- --local workData = changeWorkDataList[HouseControlManager._currentUseType]
	-- --if ( nil == workData ) then
	-- --	HouseManageSection._btn_ManageWork:SetShow( false )
	-- --	return
	-- --end

	-- -- if true == ToClient_IsUsable( HouseControlManager._houseKey ) then
		-- -- --HouseManageSection._btn_ManageWork:addInputEvent ("Mouse_LUp", workData._runFunc )
		-- -- --HouseManageSection._btn_ManageWork:SetText( workData._text )
		-- -- HouseManageSection._btn_ManageWork:addInputEvent ("Mouse_LUp", "handleClickedHouseControlDoWorkHouse()" )
		-- -- HouseManageSection._btn_ManageWork:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_DOWORK" ) )
		-- -- HouseManageSection._btn_ManageWork:SetShow( true )
	-- -- else
		-- -- HouseManageSection._btn_ManageWork:SetShow( false )
	-- -- end
	
	
-- end


--------------------------------------------------------
--				내 소유의 집을 선택했다!!
--------------------------------------------------------
local isMaxLevel = false

function HouseControlManager:UpdateMyHouse()  -- 선택한 용도 Button을 Check 상태로 만든다. 선택한 용도 버튼에 따라 용도 변경 Button의 Text를 변경한다. 매각할 수 있으면, 매각 버튼도 켜준다.
	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( self._houseKey )
	
	if( nil == houseInfoStaticStatusWrapper ) then
		return;
	end
	
	if false == houseInfoStaticStatusWrapper:isSet() then
		return
	end
	
	self:SetIgnore( false )		
	self:SetCheck( false )
	
	local rentHouseWrapper = ToClient_GetRentHouseWrapper( self._houseKey )
	if ( nil == rentHouseWrapper ) then
		self:UpdateEmptyHouse()
		return
	end
	
	self._currentUseType = rentHouseWrapper:getType()
	self._currentGroupType = rentHouseWrapper:getHouseUseType()
		
	if false == ToClient_IsMyLiveHouse( self._houseKey ) and eHouseUseGroupType.Empty == self._currentGroupType then
		self._currentGroupType = eHouseUseGroupType.Count
	end
	
	local useType = nil
	if true == self._clickedUseTypeButton then
		useType = self._clickedUseType
	else
		useType = self._currentUseType
	end

	local index = houseInfoStaticStatusWrapper:getIndexByReceipeKey(useType) - HouseControlManager._offsetIndex

	if ( nil ~= HouseControlManager_buttonList[index + 1] ) then
		HouseControlManager_buttonList[index + 1].ui._button:SetCheck(true)
	end
	local workingcnt = ToClient_getHouseWorkingWorkerList( houseInfoStaticStatusWrapper:get() )
	local index = houseInfoStaticStatusWrapper:getIndexByReceipeKey(self._currentUseType) - HouseControlManager._offsetIndex

	if ( nil ~= HouseControlManager_buttonList[index + 1] ) then
		if false == HouseControlManager._isUsable then
			local level = rentHouseWrapper:getLevel()		
			HouseControlManager_buttonList[index + 1]._grade_Mask[level]:SetShow(true)		
		elseif workingcnt > 0 then
			local index = houseInfoStaticStatusWrapper:getIndexByReceipeKey(self._currentUseType) - HouseControlManager._offsetIndex
			HouseControlManager_buttonList[index + 1]._onUpgrade:SetShow( true )		-- 작업 중이니까 켜짐. 타입에 맞춰 이미지를 변경해야 함.
			HouseControlManager:WorkinUseTypeIconTexture( index + 1, self._currentGroupType )

			HouseControlManager_buttonList[index + 1]._UseTypeIcon:SetShow( false )
			HouseControlManager_buttonList[index + 1].ui._button:SetVertexAniRun("Ani_Color_New", true) 
		end
	end
	HouseManageSection._cost_BuySell:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_WITHDRAWEXPLORE" ) )		
	HouseManageSection._btn_Buy:SetShow( false )
	
	
	local isMaxLevel = rentHouseWrapper:isMaxLevel()
	local receipeKeyRaw = rentHouseWrapper:getType()	
	local realIndex = houseInfoStaticStatusWrapper:getIndexByReceipeKey(useType)
	local houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)	
	if true == self._clickedUseTypeButton and ( self._clickedUseType ~= self._currentUseType or (self._clickedGroupType == eHouseUseGroupType.Empty and self._currentGroupType == eHouseUseGroupType.Count) ) and nil ~= houseInfoCraftWrapper then		
		HouseManageSection._ChangeMax:SetShow(false)
		HouseManageSection._btn_Change:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_TITLE_1" ) .. " : " .. houseInfoCraftWrapper:getReciepeName()) -- 용도 변경
		HouseManageSection._btn_Change:SetShow(true)
		HouseManageSection._btn_Change:EraseAllEffect()
		HouseManageSection._btn_Change:AddEffect("UI_ButtonLineRight_WhiteLong", false, -10, -3)
	else		
		if ( true == HouseControlManager._isUsable ) and (false == isMaxLevel) and (eHouseUseGroupType.Empty ~= self._currentUseType) then			
			HouseManageSection._ChangeMax:SetShow(false)
			HouseManageSection._btn_Change:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_GRADEUP_TITLE" )) -- 단계 상승
			HouseManageSection._btn_Change:SetShow( true )
			HouseManageSection._btn_Change:EraseAllEffect()
			HouseManageSection._btn_Change:AddEffect("UI_ButtonLineRight_WhiteLong", false, -10, -3)
		elseif ( true == HouseControlManager._isUsable ) and (true == isMaxLevel) then			
			HouseManageSection._btn_Change:SetShow(false)
			HouseManageSection._ChangeMax:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BTN_MAXLEVEL_1" )) -- 최고 레벨
			HouseManageSection._ChangeMax:SetShow(true)
		else
			HouseManageSection._btn_Change:SetShow(false)
			HouseManageSection._ChangeMax:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BTN_MAXLEVEL_2" )) -- 용도 변경 중
			HouseManageSection._ChangeMax:SetShow(true)
		end
	end
	
	HouseManageSection:update_ChangeCost()
	
	if houseInfoStaticStatusWrapper:isSalable() then
		HouseManageSection._btn_Sell:SetShow( true )
		HouseManageSection._btn_CantSell:SetShow( false )
	else
		HouseManageSection._btn_Sell:SetShow( false )
		HouseManageSection._btn_CantSell:SetShow( true )
	end
	
	HouseManageSection._cost_BuySell:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_WITHDRAWEXPLORE" ))
	
	-- settingChangeWork()
	
	-- self._txt_myHouse_Help:SetShow( true )
	isMaxLevel = false
end

function FGlobal_UpdateHouseControl(houseInfoSSWrapper)
	-- 테스트용
	-- FGlobal_WolrdHouseInfo_Open( houseInfoSSWrapper )

	FGlobal_GrandWorldMap_SearchToWorldMapMode()	-- 검색 상태였을 수 있으니, 풀고 들어온다.

 -- House Icon을 클릭 후 House Control Window를 열기 위해 처음 들어오는 함수
	houseInfoSS									= houseInfoSSWrapper:get()
	HouseControlManager._houseKey				= houseInfoSSWrapper:getHouseKey()
	HouseControlManager._isUsable 				= ToClient_IsUsable( HouseControlManager._houseKey )

	HouseControlManager._feature1 				= ToClient_getHouseFeature1(houseInfoSS)
	HouseControlManager._feature2 				= ToClient_getHouseFeature2(houseInfoSS)
	HouseControlManager._screenShotPath			= ToClient_getScreenShotPath(houseInfoSS, 0)
-- _PA_LOG("LUA","ToClient_getHouseFeature1 : " .. tostring(ToClient_getHouseFeature1(houseInfoSS)))
-- _PA_LOG("LUA","ToClient_getHouseFeature2 : " .. tostring(ToClient_getHouseFeature2(houseInfoSS)))
-- _PA_LOG("LUA","ToClient_getScreenShotPath : " .. tostring(ToClient_getScreenShotPath(houseInfoSS, 0)))
	HouseControlManager._isSalable 				= houseInfoSSWrapper:isSalable()
	HouseControlManager._isPurchasable 			= houseInfoSSWrapper:isPurchasable()
	HouseControlManager._needExplorePoint 		= houseInfoSSWrapper:getNeedExplorePoint()
	HouseControlManager._isSet					= houseInfoSSWrapper:isSet()
	HouseControlManager._receipeCount			= houseInfoSSWrapper:getReceipeCount()
	HouseControlManager._houseName				= houseInfoSSWrapper:getName()
	HouseControlManager._clickedUseType			= 0
	HouseControlManager._clickedUseTypeButton	= false;	
	HouseControlManager._offsetIndex 			= 0 -- 스크롤 내용의 위치 초기화
	HouseControlManager._scrollBar:SetControlPos(0)	-- 스크롤 Bar 위치 초기화
	HouseManageSection:Set()
	HouseImageSection:setImage()
	HouseWorkListSection:clear()
	HouseProgressSection_Hide()
	FGlobal_Hide_Tooltip_Work(nil, true)
	HouseControlManager._Panel_SizeY = Panel_HouseControl:GetSizeY()

	local rentHouse = ToClient_GetRentHouseWrapper( HouseControlManager._houseKey )

	if ( nil ~= rentHouse ) and ( true == rentHouse:isSet() ) then
		-- 용도가 있을 때.
		HouseControlManager._currentUseType			= rentHouse:getType()
		HouseControlManager._currentLevel			= rentHouse:getLevel()
		HouseControlManager._currentGroupType		= rentHouse:getHouseUseType()

		HouseControlManager._clickedUseType			= HouseControlManager._currentUseType
		HouseControlManager._clickedGroupType		= HouseControlManager._currentGroupType
		-- 용도가 있는데, 제작 가능한 용도면 제작으로 보내자.
	else
		-- 빈 집일 때.
		HouseControlManager._currentUseType			= -1
		HouseControlManager._currentGroupType		= eHouseUseGroupType.Count
		HouseControlManager._clickedUseType			= 2
		-- 초기 Click 용도를 창고로 한다!
		-- 함수 구현 후, 값 직접 입력 대신 함수 형태로 수정할 것!
		HouseControlManager._clickedGroupType		= 2
	end

	local realIndex = houseInfoSSWrapper:getIndexByReceipeKey(HouseControlManager._currentUseType)
	local houseInfoCraftWrapper = houseInfoSSWrapper:getHouseCraftWrapperByIndex(realIndex)
	if nil ~= houseInfoCraftWrapper then
		HouseControlManager._useTypeName = houseInfoCraftWrapper:getReciepeName()
	else
		HouseControlManager._useTypeName = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_TYPENAME_EMPTYHOUSE" )
	end
	
	HouseControlManager._txt_House_Title:SetText(HouseControlManager._houseName)	
	HouseInfoSection:init()	
	HouseControlManager:SetCheck(false)

	-- 투자된 용도 Type을 자동으로 선택 상태로 설정한다.
	HouseControlManager._clickedUseTypeButton	= true

	HouseControlManager:clear()
	if true == ToClient_IsMyHouse( HouseControlManager._houseKey ) then
	-- 선택한 용도 Button을 Check 상태로 만든다. 
	-- 선택한 용도 버튼에 따라 용도 변경 Button의 Text를 변경한다. 
	-- 매각할 수 있으면, 매각 버튼도 켜준다.
		HouseControlManager:UpdateMyHouse()
	else
		HouseControlManager:UpdateEmptyHouse()
	end	
	
	HouseControlManager:UpdateCommon()
	
	-- 자동으로 선택된 용도의 상세 정보를 표시한다.
	--local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )
	
	if ( false == houseInfoSSWrapper:isSet() ) then
		return
	end
	
	for realIdx = 0, HouseControlManager._receipeCount do
		
		if ( HouseControlManager._clickedUseType == houseInfoSSWrapper:getReceipeByIndex(realIdx) ) then
			local index = realIdx - HouseControlManager._offsetIndex + 1		
			handleClickedHouseControlSetUseType(index)
			return
		end
	end	
end

function FGlobal_CloseHoseControl()
--	Panel_HouseControl:SetShow(false);
	-- Panel_House_SellBuy_Condition:SetShow(false)
	FGlobal_WorldMapWindowEscape();
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------ 상세 용도 Section -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function HouseWorkListSection:initialize()
	local bgPosX_Deafault = 13
	local bgPosX = bgPosX_Deafault
	local bgPosY = 3
	local iconPosX_Deafault = 16
	local iconPosX = iconPosX_Deafault
	local iconPosY = 6
	local gapX = 15
	local gapY = 6	
	local coloumCount = 0
	local rowCount = 0
	self.contentCount = self.viewCount_Craft * self.collumMax

	for index = 0 , self.contentCount -1 do
		self.bgList[index]	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.Frame, "bgList_" .. tostring(index) )
		CopyBaseProperty( self.BG, self.bgList[index])
		self.bgList[index]:SetPosY(bgPosY)
		self.bgList[index]:SetPosX(bgPosX)
		
		self.borderList[index]	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.Frame, "borderList_" .. tostring(index) )
		CopyBaseProperty( self.BG_Border, self.borderList[index])
		self.borderList[index]:SetPosY(bgPosY)
		self.borderList[index]:SetPosX(bgPosX)
				
		self.iconList[index]	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.Frame, "iconList_" .. tostring(index) )
		CopyBaseProperty( self.icon, self.iconList[index])
		self.iconList[index]:SetPosX(iconPosX)
		self.iconList[index]:SetPosY(iconPosY)
		
		self.overList[index]	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.Frame, "overList_" .. tostring(index) )
		CopyBaseProperty( self.BG_Over, self.overList[index])
		self.overList[index]:SetPosY(bgPosY + 2)
		self.overList[index]:SetPosX(bgPosX + 3)
		
		coloumCount = coloumCount + 1
		if ( 5 == coloumCount ) then
			bgPosY = bgPosY + self.icon:GetSizeY() + gapY
			bgPosX = bgPosX_Deafault
		else
			bgPosX = bgPosX + self.icon:GetSizeX() + gapX
		end
		
		if ( 1 == coloumCount ) then
			self.levelList[rowCount] = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.Frame, "levelList_" .. tostring(rowCount) )
			CopyBaseProperty( self.level, self.levelList[rowCount])
			self.levelList[rowCount]:SetPosY(iconPosY + ( self.icon:GetSizeY() - self.level:GetSizeY() ) / 2  )
		end
		
		if ( 5 == coloumCount ) then
			coloumCount = 0
			iconPosY = iconPosY + self.icon:GetSizeY() + gapY
			iconPosX = iconPosX_Deafault
			rowCount = rowCount + 1
		else
			iconPosX = iconPosX + self.icon:GetSizeX() + gapX
		end
		
		self.overList[index]:addInputEvent ( "Mouse_UpScroll", "HouseWorkListSection:Scroll(true)" )
		self.overList[index]:addInputEvent ( "Mouse_DownScroll", "HouseWorkListSection:Scroll(false)" )
		self.overList[index]:addInputEvent ( "Mouse_On", "HouseWorkListSection_ShowTooltip(".. index ..")" )
		self.overList[index]:addInputEvent ( "Mouse_Out", "HouseWorkListSection_HideTooltip(" .. index .. ")" )
		self.overList[index]:addInputEvent ( "Mouse_LUp", "HandleClickedWorkListIcon(".. index ..")" )
		
		local asdf = {
			_type = 10,
			icon = self.overList[index],
		}
		Panel_Tooltip_Item_SetPosition(index, asdf, "workListMilibogi")
	end
	
	local nonCraft_GapY = 4
	-- local nonCraft_PosX = self.Frame:GetPosX() + 5
	local nonCraft_PosY = nonCraft_GapY
	
	for index = 0 , self.viewCount_nonCraft -1 do	
		self.levelList_nonCraft[index] = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.Frame, "levelList_nonCraft_" .. tostring(index) )
		CopyBaseProperty( self.level_nonCraft, self.levelList_nonCraft[index])
		self.levelList_nonCraft[index]:SetPosY(nonCraft_PosY)

		self.guideList[index] = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.Frame, "guideList_" .. tostring(index) )
		CopyBaseProperty( self.guide, self.guideList[index])
		self.guideList[index]:SetPosY(nonCraft_PosY)
		
		nonCraft_PosY = nonCraft_PosY + self.levelList_nonCraft[index]:GetSizeY() + nonCraft_GapY
	end
	
	self.guideList.MyHouse = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.Frame, "guideList_MyHouse")
	CopyBaseProperty( self.guide_MyHouse, self.guideList.MyHouse)
	
	self.guideList.MyHouse:SetAutoResize( true )
	self.guideList.MyHouse:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self.guideList.MyHouse:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_HOUSECONTROL_HELP_MYHOUSE" ) )
	self.guideList.MyHouse:SetPosX( ( self.Frame:GetSizeX() - self.guideList.MyHouse:GetSizeX() ) / 2 )
	self.guideList.MyHouse:SetPosY( ( self.Frame:GetSizeY() - self.guideList.MyHouse:GetSizeY() ) / 2 )
	
	self.scrollButton = UI.getChildControl ( self.scroll, "Frame_ScrollBar_thumb" ),
	self.Frame:addInputEvent ( "Mouse_UpScroll", "HouseWorkListSection:Scroll(true)" )
	self.Frame:addInputEvent ( "Mouse_DownScroll", "HouseWorkListSection:Scroll(false)" )
	self.Frame:SetIgnore ( false )
	self.scroll:addInputEvent ( "Mouse_UpScroll", "HouseWorkListSection:Scroll(true)" )
	self.scroll:addInputEvent ( "Mouse_DownScroll", "HouseWorkListSection:Scroll(false)" )
	
	self.scroll:addInputEvent ( "Mouse_LDown", "HouseWorkListSection:ScrollOnClick()" )
	self.scroll:addInputEvent ( "Mouse_LUp", "HouseWorkListSection:ScrollOnClick()" )
	self.scrollButton:addInputEvent ( "Mouse_UpScroll", "HouseWorkListSection:Scroll(true)" )
	self.scrollButton:addInputEvent ( "Mouse_DownScroll", "HouseWorkListSection:Scroll(false)" )
	self.scrollButton:addInputEvent ( "Mouse_LPress", "HouseWorkListSection:ScrollOnClick()" )

	self.icon:SetShow(false)
	self.BG:SetShow(false)
end

HouseWorkListSection:initialize()

function HouseWorkListSection:clear()
	for key, value in pairs ( self.bgList ) do
		value:SetShow(false)
	end
	
	for key, value in pairs ( self.borderList ) do
		value:SetShow(false)
	end
	
	for key, value in pairs ( self.overList ) do
		value:SetShow(false)
	end
	
	for key, value in pairs( self.iconList ) do
		value:SetShow(false)
	end
	for key, value in pairs( self.levelList ) do
		value:SetShow(false)
	end
	for key, value in pairs( self.levelList_nonCraft ) do
		value:SetShow(false)
	end
	for key, value in pairs( self.guideList ) do
		value:SetShow(false)
	end
	self.scroll:SetShow(false)
end

function HouseWorkListSection:setRealTable(houseUseType, receipeKey, level, houseInfoStaticStatusWrapper)	
	self.realTable = {}
	self:getWorkList()
	self.workCount = ToClient_getHouseWorkableListByData( HouseControlManager._houseKey, receipeKey, level )
	local workCount = ToClient_getHouseWorkableListByDataOnlySize( receipeKey, 1, level)
	local collumIndex = 0
	local rowIndex = 0
	local indexLevel = 1
	local savedLevel = 0
	local levelCount = 0
	local levelUp = false
	if workCount == 0 then
		self.realTable.isCraft = false
		self.viewCount = self.viewCount_nonCraft
		for lv = 1 , level do
			self.realTable[rowIndex] = {}
			self.realTable[rowIndex].level = lv				
			rowIndex = rowIndex + 1
			
			self.realTable[rowIndex] = {}				
			if eHouseUseGroupType.Lodging == houseUseType then
				local workerCount			= houseInfoStaticStatusWrapper:getWorkerCount(lv)
				self.realTable[rowIndex].guide = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_LODGING2", "workerCount", workerCount) -- {workerCount} 명의 일꾼을 추가 고용할 수 있습니다.
			elseif eHouseUseGroupType.Depot == houseUseType then
				local extendWarehouseCount	= houseInfoStaticStatusWrapper:getExtendWarehouseCount(lv)
				self.realTable[rowIndex].guide = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_DEPOT2", "extendWarehouseCount", extendWarehouseCount) -- extendWarehouseCount.." 칸의 창고를 추가합니다."
			elseif eHouseUseGroupType.Ranch == houseUseType then
				local extendStableCount		= houseInfoStaticStatusWrapper:getExtendStableCount(lv)
				self.realTable[rowIndex].guide = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RANCH2", "extendStableCount", extendStableCount) -- "목장 "..titleLevel.." 단계"
			else
				self.realTable.isCraft = nil
				self.realTable = {}
				rowIndex = 0
				break
			end		
			if ( lv < level ) then
				rowIndex = rowIndex + 1
			end
		end
	elseif ( workCount > 0 ) then
		self.realTable.isCraft = true
		self.viewCount = self.viewCount_Craft
		for index = 0, workCount - 1 do
			if ( index == 0 ) or ( levelUp == true ) then
				if ( nil == self.realTable[rowIndex] ) then
					self.realTable[rowIndex] = {}
				end
				self.realTable[rowIndex].level = indexLevel
				rowIndex = rowIndex + 1
				levelUp = false
			end
			if ( self.realTable[rowIndex] == nil ) then
				self.realTable[rowIndex] = {}
			end
			if ( self.realTable[rowIndex][collumIndex] == nil ) then
				self.realTable[rowIndex][collumIndex] = {}
			end

			self.realTable[rowIndex][collumIndex].index = index
			if indexLevel ~= savedLevel  then
				levelCount = ToClient_getHouseWorkableListByDataOnlySize( receipeKey, 1, indexLevel) - 1
				savedLevel = indexLevel
			end

			if ( index == levelCount ) then
				levelUp = true
				collumIndex = self.collumMax
				indexLevel = indexLevel + 1
				if ( indexLevel > level ) then
					break
				end
			end				
			
			if collumIndex < ( self.collumMax - 1 ) then
				collumIndex = collumIndex + 1
			else
				collumIndex = 0
				rowIndex = rowIndex + 1
			end			
		end
	end
	
	self.viewIndex = 0
	self.maxCount = rowIndex + 1
	self.minCount = self.maxCount - self.viewCount
	if self.minCount < 0 then
		self.minCount = 0
	end
	
end

function HouseWorkListSection:updateFirstShow(houseUseType, receipeKey, level, resetPos)
	self.currentHouseUseType = houseUseType
	self.currentReceipeKey = receipeKey
	self.currentLevel = level
	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )
	
	if resetPos then
		self:setRealTable(houseUseType, receipeKey, level, houseInfoStaticStatusWrapper)
	end

	self:clear()

	local collumIndex = 0
	local rowIndex = self.viewIndex
	self.realIndex= {}
	if ( true == self.realTable.isCraft ) then
		for index = 0, self.contentCount - 1 do
			if ( nil == self.realTable[rowIndex] )then
				break
			end
			if ( nil ~= self.realTable[rowIndex].level ) and ( 0 == collumIndex ) then
				levelRow = math.ceil( ( index + 1 ) / self.collumMax ) - 1
				self.levelList[levelRow]:SetText(self.realTable[rowIndex].level .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_HOUSE_LEVEL"))
				self.levelList[levelRow]:SetShow(true)
				self.realIndex[index] = nil
			end
			if ( nil ~= self.realTable[rowIndex][collumIndex] ) then
				self.realIndex[index] = self.realTable[rowIndex][collumIndex].index 
				local realLevel = self.realTable[rowIndex][collumIndex].level
				local esSSW		= ToClient_getHouseDataWorkableItemExchangeByIndex(self.realIndex[index]);
				if esSSW:isSet() then
					local esSS		= esSSW:get()
	
					local workIcon	= "icon/" .. esSSW:getIcon()
					local itemStatic = nil
					if false == esSSW:getUseExchangeIcon() then
						itemStatic	= esSS:getFirstDropGroup():getItemStaticStatus()
						workIcon	= "icon/" .. getItemIconPath( itemStatic );
					end

					if nil ~= itemStatic then
						local gradeType = 0 --itemStatic:getStaticStatus():getGradeType() 추후 변경
						if (0 < gradeType) and (gradeType <= #UI.itemSlotConfig.borderTexture) then
							self.borderList[index]:ChangeTextureInfoName( UI.itemSlotConfig.borderTexture[gradeType].texture )			
							local x1, y1, x2, y2 = setTextureUV_Func( self.borderList[index], UI.itemSlotConfig.borderTexture[gradeType].x1, UI.itemSlotConfig.borderTexture[gradeType].y1, UI.itemSlotConfig.borderTexture[gradeType].x2, UI.itemSlotConfig.borderTexture[gradeType].y2 )
							self.borderList[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
							self.borderList[index]:setRenderTexture(self.borderList[index]:getBaseTexture())	
							self.borderList[index]:SetShow(true)
						else
							self.borderList[index]:SetShow(false)
						end
					else
						self.borderList[index]:SetShow(false)
					end
					
					self.bgList[index]:SetShow(true)					
					self.overList[index]:SetShow(true)					
					self.iconList[index]:ChangeTextureInfoName(workIcon)
					self.iconList[index]:SetShow(true)
				end			
			end
			if collumIndex < ( self.collumMax - 1 ) then
				collumIndex = collumIndex + 1
			else
				collumIndex = 0
				rowIndex = rowIndex + 1
			end		
		end
	elseif ( false == self.realTable.isCraft ) then
		
		for index = 0, self.viewCount - 1 do
			if ( nil == self.realTable[rowIndex] )then
				break
			end
			if ( nil ~= self.realTable[rowIndex].level ) then
				self.levelList_nonCraft[index]:SetText(self.realTable[rowIndex].level .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_HOUSE_LEVEL"))
				self.levelList_nonCraft[index]:SetShow(true)			
			elseif ( nil ~= self.realTable[rowIndex].guide ) then
				self.guideList[index]:SetText(self.realTable[rowIndex].guide)
				self.guideList[index]:SetShow(true)
			end	
			rowIndex = rowIndex + 1
		end
	elseif ( nil == self.realTable.isCraft ) then
		self.guideList.MyHouse:SetShow(true)
	end
	
	UIScroll.SetButtonSize( self.scroll, self.viewCount, self.maxCount ) -- 스크롤바 버튼의 크기를 조정한다.
	self.scroll:SetControlPos( self.viewIndex / self.minCount) -- 스크롤바 버튼의 위치를 조정한다.
end

function HouseWorkListSection:ScrollOnClick()
	local namnunSize = self.scroll:GetSizeY() - self.scrollButton:GetSizeY() 
	local namnunPercents = self.scrollButton:GetPosY() / namnunSize
	self.viewIndex = math.floor(namnunPercents * (self.maxCount - self.viewCount ))
	self:updateFirstShow( self.currentHouseUseType, self.currentReceipeKey, self.currentLevel, false )
end

function HouseWorkListSection:Scroll(isUp)
	if 0 == self.workCount then
		return
	end
	
	if ( false == isUp ) then
		self.viewIndex = math.min(self.minCount, self.viewIndex + 1)
	else
		self.viewIndex = math.max(0, self.viewIndex -1)
	end	
	
	self:updateFirstShow( self.currentHouseUseType, self.currentReceipeKey, self.currentLevel, false )
	HouseWorkListSection_ShowTooltip_Reflesh()
end
local currentIndex = nil
function HouseWorkListSection_ShowTooltip( index )
	if isKeyPressed( VCK.KeyCode_CONTROL ) then
		Keep_Tooltip_Work = true
		return
	end
	
	local uiBase	= HouseWorkListSection.iconList[index]
	local esSSW		= ToClient_getHouseDataWorkableItemExchangeByIndex(HouseWorkListSection.realIndex[index])
	if esSSW:isSet() then
		FGlobal_Show_Tooltip_Work( esSSW, uiBase )
		currentIndex = index
	end
end
function HouseWorkListSection_ShowTooltip_Reflesh()
	local uiBase	= HouseWorkListSection.iconList[currentIndex]
	local realIndex = HouseWorkListSection.realIndex[currentIndex]
	local esSSW		= ToClient_getHouseDataWorkableItemExchangeByIndex(realIndex)
	if realIndex ~= nil and esSSW:isSet() then
		FGlobal_Show_Tooltip_Work( esSSW, uiBase )
	else		
		FGlobal_Hide_Tooltip_Work(esSSW, true)
	end
end

function HandleClickedWorkListIcon( index )
	if isKeyPressed( VCK.KeyCode_CONTROL ) then
		HouseWorkListSection:getWorkList()
		local esSSW		= ToClient_getHouseDataWorkableItemExchangeByIndex(HouseWorkListSection.realIndex[index]);
		if esSSW:isSet() then
			FGlobal_Show_Tooltip_Work_Copy( esSSW )
		end
	end
end

function HouseWorkListSection_HideTooltip(index)
	if isKeyPressed( VCK.KeyCode_CONTROL ) or currentIndex ~= index then
		return
	end
	local esSSW		= ToClient_getHouseDataWorkableItemExchangeByIndex(HouseWorkListSection.realIndex[index])
	if esSSW:isSet() then
		FGlobal_Hide_Tooltip_Work(esSSW, true)
		currentIndex = nil
	end
end

function HouseWorkListSection:getWorkList()
	self.workCount = ToClient_getHouseWorkableListByData( HouseControlManager._houseKey, self.currentReceipeKey, self.currentLevel )
end
function HouseControl_getItemStaticStatusByIndex( index )
	local realIndex = HouseWorkListSection.realIndex[index]
	if ( nil == realIndex ) then
		return nil
	end	
	local workIcon	= getWorkableExchangeIconByIndex(realIndex);
	if ( nil ~= workIcon ) and ( "" ~= workIcon ) then
		return nil
	end
	local itemEnchantStaticStatusWrapper = getWorkableFirstItemStaticWrapperByIndex(realIndex)
	if ( nil == itemEnchantStaticStatusWrapper:get() ) then
		return nil
	end
	return itemEnchantStaticStatusWrapper
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------ 관리 메뉴 Section -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function HouseManageSection:init()
	
	self._BG:AddChild(self._btn_Buy)
	self._BG:AddChild(self._btn_CantBuy_LD)
	self._BG:AddChild(self._btn_CantBuy_LowPoint)
	self._BG:AddChild(self._btn_Sell)	
	self._BG:AddChild(self._btn_CantSell)
	self._BG:AddChild(self._cost_BuySell)			
	self._BG:AddChild(self._cost_BuySellValue)
	self._BG:AddChild(self._explore_Current)		
	self._BG:AddChild(self._explore_CurrentValue)	
	self._BG:AddChild(self._btn_Change)				
	self._BG:AddChild(self._ChangeMax)				
	self._BG:AddChild(self._time_Change)			
	self._BG:AddChild(self._time_ChangeValue)		
	self._BG:AddChild(self._cost_Change)			
	self._BG:AddChild(self._cost_ChangeValue)		
	self._BG:AddChild(self._cost_MyMoney)			
	self._BG:AddChild(self._cost_MyMoneyValue)		
	self._BG:AddChild(self._btn_ManageWork)
	
	Panel_HouseControl:RemoveControl(self._btn_Buy)
	Panel_HouseControl:RemoveControl(self._btn_CantBuy_LD)
	Panel_HouseControl:RemoveControl(self._btn_CantBuy_LowPoint)
	Panel_HouseControl:RemoveControl(self._btn_Sell)	
	Panel_HouseControl:RemoveControl(self._btn_CantSell)
	Panel_HouseControl:RemoveControl(self._cost_BuySell)			
	Panel_HouseControl:RemoveControl(self._cost_BuySellValue)
	Panel_HouseControl:RemoveControl(self._explore_Current)		
	Panel_HouseControl:RemoveControl(self._explore_CurrentValue)	
	Panel_HouseControl:RemoveControl(self._btn_Change)				
	Panel_HouseControl:RemoveControl(self._ChangeMax)				
	Panel_HouseControl:RemoveControl(self._time_Change)			
	Panel_HouseControl:RemoveControl(self._time_ChangeValue)		
	Panel_HouseControl:RemoveControl(self._cost_Change)			
	Panel_HouseControl:RemoveControl(self._cost_ChangeValue)		
	Panel_HouseControl:RemoveControl(self._cost_MyMoney)			
	Panel_HouseControl:RemoveControl(self._cost_MyMoneyValue)		
	Panel_HouseControl:RemoveControl(self._btn_ManageWork)
	
	local BGSpanX = self._BG:GetSpanSize().x
	local BGSpanY = self._BG:GetSpanSize().y	
	
	self._btn_Buy					:SetSpanSize(self._btn_Buy				:GetSpanSize().x - BGSpanX, self._btn_Buy				:GetSpanSize().y - BGSpanY)	
	self._btn_CantBuy_LD			:SetSpanSize(self._btn_CantBuy_LD		:GetSpanSize().x - BGSpanX, self._btn_CantBuy_LD		:GetSpanSize().y - BGSpanY)
	self._btn_CantBuy_LowPoint	    :SetSpanSize(self._btn_CantBuy_LowPoint	:GetSpanSize().x - BGSpanX, self._btn_CantBuy_LowPoint	:GetSpanSize().y - BGSpanY)
	self._btn_Sell				    :SetSpanSize(self._btn_Sell				:GetSpanSize().x - BGSpanX, self._btn_Sell				:GetSpanSize().y - BGSpanY)
	self._btn_CantSell			    :SetSpanSize(self._btn_CantSell			:GetSpanSize().x - BGSpanX, self._btn_CantSell			:GetSpanSize().y - BGSpanY)
	self._cost_BuySell			    :SetSpanSize(self._cost_BuySell			:GetSpanSize().x - BGSpanX, self._cost_BuySell			:GetSpanSize().y - BGSpanY)
	self._cost_BuySellValue		    :SetSpanSize(self._cost_BuySellValue	:GetSpanSize().x - BGSpanX, self._cost_BuySellValue		:GetSpanSize().y - BGSpanY)
	self._explore_Current		    :SetSpanSize(self._explore_Current		:GetSpanSize().x - BGSpanX, self._explore_Current		:GetSpanSize().y - BGSpanY)
	self._explore_CurrentValue	    :SetSpanSize(self._explore_CurrentValue	:GetSpanSize().x - BGSpanX, self._explore_CurrentValue	:GetSpanSize().y - BGSpanY)
	self._btn_Change				:SetSpanSize(self._btn_Change			:GetSpanSize().x - BGSpanX, self._btn_Change			:GetSpanSize().y - BGSpanY)	
	self._ChangeMax				    :SetSpanSize(self._ChangeMax			:GetSpanSize().x - BGSpanX, self._ChangeMax				:GetSpanSize().y - BGSpanY)	
	self._time_Change			    :SetSpanSize(self._time_Change			:GetSpanSize().x - BGSpanX, self._time_Change			:GetSpanSize().y - BGSpanY)	
	self._time_ChangeValue		    :SetSpanSize(self._time_ChangeValue		:GetSpanSize().x - BGSpanX, self._time_ChangeValue		:GetSpanSize().y - BGSpanY)		
	self._cost_Change			    :SetSpanSize(self._cost_Change			:GetSpanSize().x - BGSpanX, self._cost_Change			:GetSpanSize().y - BGSpanY)	
	self._cost_ChangeValue		    :SetSpanSize(self._cost_ChangeValue		:GetSpanSize().x - BGSpanX, self._cost_ChangeValue		:GetSpanSize().y - BGSpanY)	
	self._cost_MyMoney			    :SetSpanSize(self._cost_MyMoney			:GetSpanSize().x - BGSpanX, self._cost_MyMoney			:GetSpanSize().y - BGSpanY)	
	self._cost_MyMoneyValue		    :SetSpanSize(self._cost_MyMoneyValue	:GetSpanSize().x - BGSpanX, self._cost_MyMoneyValue		:GetSpanSize().y - BGSpanY)	
	self._btn_ManageWork			:SetSpanSize(self._btn_ManageWork		:GetSpanSize().x - BGSpanX, self._btn_ManageWork		:GetSpanSize().y - BGSpanY)		
end
HouseManageSection:init()

function HouseManageSection:Set()
	local gapBtn_TxtY = 40
	local gapTxt_BtnY = 30
	local gapTxt_TxtY = 25
	local adjustGap = 5
	local posY = 10
	local isMyHouse = ToClient_IsMyHouse( HouseControlManager._houseKey )
	local currentExplorePoint = ToClient_RequestGetMyExploredPoint()
	local rentHouseWrapper = ToClient_GetRentHouseWrapper( HouseControlManager._houseKey )

	local isWorkable = (	( true == isMyHouse ) 
						and ( true == ToClient_IsUsable( HouseControlManager._houseKey ) ) 
						and ( rentHouseWrapper:isSet() ) 
						and ( eHouseUseGroupType.ImproveWorkshop <= rentHouseWrapper:getType() ) 
						)

	if ( true == isMyHouse ) then
		posY = posY - adjustGap
		gapBtn_TxtY = gapBtn_TxtY - adjustGap
		gapTxt_BtnY = gapTxt_BtnY - adjustGap
		gapTxt_TxtY = gapTxt_TxtY - adjustGap
	end
	
	self._btn_Buy:SetShow(false)
	self._btn_CantBuy_LD:SetShow(false)
	self._btn_CantBuy_LowPoint:SetShow(false)
	self._btn_Sell:SetShow(false)
	self._btn_CantSell:SetShow(false)
	self._btn_Change:SetShow(false)
	self._ChangeMax:SetShow(false)	
	self._btn_ManageWork:SetShow( false )
		
	self._btn_Buy				:SetSpanSize(self._btn_Buy				:GetSpanSize().x, posY)
	self._btn_CantBuy_LD		:SetSpanSize(self._btn_CantBuy_LD		:GetSpanSize().x, posY)


	self._btn_CantBuy_LowPoint	:SetSpanSize(self._btn_CantBuy_LowPoint	:GetSpanSize().x, posY)
	self._btn_Sell				:SetSpanSize(self._btn_Sell				:GetSpanSize().x, posY)
	self._btn_CantSell			:SetSpanSize(self._btn_CantSell			:GetSpanSize().x, posY)	



	posY = posY + gapBtn_TxtY	
	self._cost_BuySell			:SetSpanSize(self._cost_BuySell			:GetSpanSize().x, posY)

	self._cost_BuySellValue		:SetSpanSize(self._cost_BuySellValue	:GetSpanSize().x, posY)
	self._cost_BuySellValue		:SetText(HouseControlManager._needExplorePoint)
	
	posY = posY + gapTxt_TxtY
	self._explore_Current		:SetSpanSize(self._explore_Current		:GetSpanSize().x, posY)
	self._explore_CurrentValue	:SetSpanSize(self._explore_CurrentValue	:GetSpanSize().x, posY)
	self._explore_CurrentValue	:SetText(currentExplorePoint)	
	
	if ( true == isMyHouse ) then	
		posY = posY + gapTxt_BtnY
		self._btn_Change		:SetSpanSize(self._btn_Change			:GetSpanSize().x, posY)
		self._ChangeMax			:SetSpanSize(self._ChangeMax			:GetSpanSize().x, posY)		


		posY = posY + gapBtn_TxtY
	else
		posY = posY + gapTxt_TxtY
	end	
	
	self._time_Change			:SetSpanSize(self._time_Change			:GetSpanSize().x, posY)
	self._time_ChangeValue		:SetSpanSize(self._time_ChangeValue		:GetSpanSize().x, posY)		
	
	posY = posY + gapTxt_TxtY
	
	self._cost_Change			:SetSpanSize(self._cost_Change			:GetSpanSize().x, posY)
	self._cost_ChangeValue		:SetSpanSize(self._cost_ChangeValue		:GetSpanSize().x, posY)
	
	local _posY = posY + gapTxt_TxtY
	
	self._cost_MyMoney		:SetSpanSize(self._cost_Change			:GetSpanSize().x, _posY)	
	self._cost_MyMoneyValue	:SetSpanSize(self._cost_ChangeValue		:GetSpanSize().x, _posY)
	
	if ( isWorkable ) then
		posY = posY + gapTxt_BtnY
		self._btn_ManageWork	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_DOWORK" ) )
		self._btn_ManageWork	:SetSpanSize(self._btn_ManageWork		:GetSpanSize().x, posY)
	end
end

function HouseManageSection:update_ChangeCost()
	local rentHouseWrapper = ToClient_GetRentHouseWrapper( HouseControlManager._houseKey )
	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )
		
	if ( false == HouseControlManager._isSet ) then
		return
	end
	
	local isMyHouse = ToClient_IsMyHouse( HouseControlManager._houseKey )
	local isMaxLevel = false
	local isUsable = ToClient_IsUsable( HouseControlManager._houseKey )
	
	local nextRentHouseLevel = 1
	
	if ( true == isMyHouse ) and ( rentHouseWrapper:isSet() )then
		isMaxLevel = rentHouseWrapper:isMaxLevel()
		houseUseType = rentHouseWrapper:getType()
		if ( HouseControlManager._clickedUseType == houseUseType ) then
			if isUsable and ( false == isMaxLevel ) then
				nextRentHouseLevel = rentHouseWrapper:getLevel() +1
			elseif ( false == isUsable ) then
				nextRentHouseLevel = rentHouseWrapper:getLevel()
			end
		end
	end
		
	local listCount	= houseInfoStaticStatusWrapper:getNeedItemListCount( HouseControlManager._clickedUseType, nextRentHouseLevel )
	
	local itemKey = {}
	local itemName = {}
	local itemCount = {}
	
	for index = 0, listCount - 1, 1 do
		itemKey[index] = houseInfoStaticStatusWrapper:getNeedItemListItemKey( HouseControlManager._clickedUseType, nextRentHouseLevel, index )
		itemName[index] = getItemEnchantStaticStatus(itemKey[index]):getName()
		itemCount[index] = Int64toInt32( houseInfoStaticStatusWrapper:getNeedItemListItemCount( HouseControlManager._clickedUseType, nextRentHouseLevel, index ) )
	end

	local selfPlayerWrapper = getSelfPlayer()
	local selfPlayer		= selfPlayerWrapper:get()
	local inventory			= selfPlayer:getInventory()
	local myMoney 			= Int64toInt32(inventory:getMoney_s64())
	local myMoneyDot		= makeDotMoney( myMoney )
	self._cost_MyMoneyValue:SetText ( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_HAVEMONEY", "myMoney", myMoneyDot) )
	
	if ( nil ~= itemCount[0] ) and ( nil ~= itemName[0] ) then	-- 용도 변경 비용을 골드로만 한정 했다! 만약 Item의 종류를 추가한다면 변경해야 한다!
		if ( HouseControlManager._clickedUseType == houseUseType ) and ( true == isMaxLevel ) and ( true == isUsable ) then
			self._cost_ChangeValue:SetText( "--" )
		else
			local needMoney			= itemCount[0]
			if needMoney > myMoney then			
				needMoney = "<PAColor0xFFDB2B2B>" .. makeDotMoney(needMoney) .. " " .. itemName[0] .. "<PAOldColor>"
			else
				needMoney = makeDotMoney(needMoney) .. " " .. itemName[0]
			end
			self._cost_ChangeValue:SetText( needMoney )
		end
		
	else
		self._cost_ChangeValue:SetText( "--" )
	end
	
	self._needTime = -1
	local needTime = "--"
	if ( HouseControlManager._clickedUseType == houseUseType ) and ( true == isMaxLevel ) and ( true == isUsable ) then 
		self._needTime	= 0
	else
		self._needTime	= houseInfoStaticStatusWrapper:getTransperTime( HouseControlManager._clickedUseType, nextRentHouseLevel, nextRentHouseLevel)
	end
	
	if ( 0 ~= self._needTime ) then
		needTime	= Util.Time.timeFormatting( self._needTime )
	end	
	self._time_ChangeValue:SetText(needTime)
	local isWorkable = (	( true == isMyHouse ) 
						and ( true == ToClient_IsUsable( HouseControlManager._houseKey ) ) 
						and ( nil ~= rentHouseWrapper ) 
						and ( eHouseUseGroupType.ImproveWorkshop <= rentHouseWrapper:getType() ) 
						)
	
	if HouseControlManager._currentUseType == HouseControlManager._clickedUseType and isWorkable then
		self._btn_ManageWork	:SetShow( true )
		self._cost_MyMoney		:SetShow( false )	
		self._cost_MyMoneyValue	:SetShow( false )
	else
		self._btn_ManageWork	:SetShow( false )
		self._cost_MyMoney		:SetShow( true )	
		self._cost_MyMoneyValue	:SetShow( true )
	end
end

--------------------------------------------------------------------------------------------------------------
--------------------- 작업 진행 상황 Section --------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

function HouseProgressSection:Init()
	self._BG:AddChild(self._WorkName)
	self._BG:AddChild(self._Icon_BG)
	self._BG:AddChild(self._Icon_Working)
	self._BG:AddChild(self._Icon_UseType)
	self._BG:AddChild(self._Progress_BG)
	self._BG:AddChild(self._Progress_OnGoing)
	self._BG:AddChild(self._Progress)
	self._BG:AddChild(self._ProgressText_Value)
	self._BG:AddChild(self._RemainTime)
	self._BG:AddChild(self._RemainTime_Vlaue)
	self._BG:AddChild(self._Btn_CancelWork)
	self._BG:AddChild(self._Btn_LargCraft)
	self._BG:AddChild(self._Btn_Immediately)
	
	Panel_HouseControl:RemoveControl(self._WorkName)
	Panel_HouseControl:RemoveControl(self._Icon_BG)
	Panel_HouseControl:RemoveControl(self._Icon_Working)
	Panel_HouseControl:RemoveControl(self._Icon_UseType)
	Panel_HouseControl:RemoveControl(self._Progress_BG)
	Panel_HouseControl:RemoveControl(self._Progress_OnGoing)
	Panel_HouseControl:RemoveControl(self._Progress)
	Panel_HouseControl:RemoveControl(self._ProgressText_Value)
	Panel_HouseControl:RemoveControl(self._RemainTime)
	Panel_HouseControl:RemoveControl(self._RemainTime_Vlaue)
	Panel_HouseControl:RemoveControl(self._Btn_CancelWork)
	Panel_HouseControl:RemoveControl(self._Btn_LargCraft)
	Panel_HouseControl:RemoveControl(self._Btn_Immediately)
	
	local BGSpanX = self._BG:GetSpanSize().x
	local BGSpanY = self._BG:GetSpanSize().y
	
	self._WorkName				:SetSpanSize(self._WorkName		  	 	:GetSpanSize().x - BGSpanX, self._WorkName			:GetSpanSize().y - BGSpanY)
	self._Icon_BG				:SetSpanSize(self._Icon_BG           	:GetSpanSize().x - BGSpanX, self._Icon_BG			:GetSpanSize().y - BGSpanY)
	self._Icon_Working			:SetSpanSize(self._Icon_Working      	:GetSpanSize().x - BGSpanX, self._Icon_Working		:GetSpanSize().y - BGSpanY)
	self._Icon_UseType			:SetSpanSize(self._Icon_UseType      	:GetSpanSize().x - BGSpanX, self._Icon_UseType		:GetSpanSize().y - BGSpanY)
	self._Progress_BG			:SetSpanSize(self._Progress_BG       	:GetSpanSize().x - BGSpanX, self._Progress_BG		:GetSpanSize().y - BGSpanY)
	self._Progress_OnGoing		:SetSpanSize(self._Progress_OnGoing  	:GetSpanSize().x - BGSpanX, self._Progress_OnGoing	:GetSpanSize().y - BGSpanY)
	self._Progress				:SetSpanSize(self._Progress          	:GetSpanSize().x - BGSpanX, self._Progress			:GetSpanSize().y - BGSpanY)
	self._ProgressText_Value	:SetSpanSize(self._ProgressText_Value	:GetSpanSize().x - BGSpanX, self._ProgressText_Value:GetSpanSize().y - BGSpanY)
	self._RemainTime			:SetSpanSize(self._RemainTime        	:GetSpanSize().x - BGSpanX, self._RemainTime		:GetSpanSize().y - BGSpanY)
	self._RemainTime_Vlaue		:SetSpanSize(self._RemainTime_Vlaue  	:GetSpanSize().x - BGSpanX, self._RemainTime_Vlaue	:GetSpanSize().y - BGSpanY)
	self._Btn_CancelWork		:SetSpanSize(self._Btn_CancelWork    	:GetSpanSize().x - BGSpanX, self._Btn_CancelWork	:GetSpanSize().y - BGSpanY)	
	self._Btn_LargCraft			:SetSpanSize(self._Btn_LargCraft	 	:GetSpanSize().x - BGSpanX, self._Btn_LargCraft		:GetSpanSize().y - BGSpanY)	
	self._Btn_Immediately		:SetSpanSize(self._Btn_Immediately		:GetSpanSize().x - BGSpanX, self._Btn_Immediately	:GetSpanSize().y - BGSpanY)

	FGlobal_AddChild(Panel_HouseControl, self._BG, self._ProgressText_1)
	FGlobal_AddChild(Panel_HouseControl, self._BG, self._ProgressText_2)
	FGlobal_AddChild(Panel_HouseControl, self._BG, self._OnGoingText)
	FGlobal_AddChild(Panel_HouseControl, self._BG, self._OnGoingText_Vlaue)

	self._Title:SetShow(false)
	self._BG:SetShow(false)
	
	self._WorkName:SetTextMode( UI_TM.eTextMode_LimitText )
	
	self._Btn_CancelWork	:addInputEvent("Mouse_LUp","HouseProgressSection_CancelWork()");
	self._Btn_LargCraft		:addInputEvent("Mouse_LUp","handleClickedHouseControlDoWorkHouse()");
	self._Btn_Immediately	:addInputEvent("Mouse_LUp","ImmediatelyComplete()");
end
HouseProgressSection:Init()

function HouseProgressSection_Init()
	local workType = HouseProgressSection._workType
	local houseKey = HouseControlManager._houseKey
	local workingcnt = -1
	currentWorkCountCheck = false
	HouseProgressSection._workerNo = {}
	if ( eWorkType.craft == workType ) then
		workingcnt 				= ToClient_getHouseWorkingWorkerList( houseInfoSS )
		
		if workingcnt == 0 then
			HouseProgressSection.isFale_Init = true
		end
		
		for idx = 0 , workingcnt - 1 , 1 do
			local worker = ToClient_getHouseWorkingWorkerByIndex( houseInfoSS, idx ).workerNo
			local workerNo = worker:get_s64()
			local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
			if esSSW:isSet() then
				local workingIcon = esSSW:getIcon()	
				local workName 	= esSSW:getDescription()
		
				HouseProgressSection._Icon_Working			:ChangeTextureInfoName("icon/" .. workingIcon)
				HouseProgressSection._saveIcon = workingIcon	
				HouseProgressSection._worker = worker		
				HouseProgressSection._workerNo[idx] = workerNo
							
				HouseProgressSection._WorkName			:SetText(workName)
				HouseProgressSection._Icon_BG			:SetShow(true)
				HouseProgressSection._Icon_Working		:SetShow(true)
				HouseProgressSection._Icon_Working		:addInputEvent("Mouse_On","HouseProgressSection_Show_Tooltip_Work()")
				HouseProgressSection._Icon_Working		:addInputEvent("Mouse_Out","HouseProgressSection_Hide_Tooltip_Work()")
				HouseProgressSection._Icon_UseType		:SetShow(false)
				HouseProgressSection._RemainTime		:SetShow(true)
				HouseProgressSection._RemainTime_Vlaue	:SetShow(true)
				HouseProgressSection._Btn_LargCraft		:SetShow(false)
				HouseProgressSection._Btn_CancelWork	:SetShow(true)
				HouseProgressSection._ProgressText_1    :SetShow(true)
				HouseProgressSection._ProgressText_2    :SetShow(false)
				HouseProgressSection._Progress_OnGoing	:SetShow(false)
				HouseProgressSection._OnGoingText       :SetShow(false)
				HouseProgressSection._OnGoingText_Vlaue :SetShow(false)
			end
		end			
	elseif ( eWorkType.changeHouseUseType == workType ) then
		HouseProgressSection._WorkName			:SetText(HouseControlManager._useTypeName .. " " .. HouseControlManager._currentLevel .. " " .. PAGetString( Defines.StringSheet_GAME, "LUA_HOUSECONTROL_ONCHANGE_LEVEL" ))
		Set_HouseUseType_Texture_Icon(HouseProgressSection._Icon_UseType)
		HouseProgressSection._Icon_UseType		:SetShow(true)
		HouseProgressSection._Icon_Working		:SetShow(false)
		HouseProgressSection._Icon_BG			:SetShow(false)
		HouseProgressSection._RemainTime		:SetShow(true)
		HouseProgressSection._RemainTime_Vlaue	:SetShow(true)
		HouseProgressSection._Btn_LargCraft		:SetShow(false)
		HouseProgressSection._Btn_CancelWork	:SetShow(false)
		HouseProgressSection._ProgressText_1    :SetShow(true)
		HouseProgressSection._ProgressText_2    :SetShow(false)
		HouseProgressSection._Progress_OnGoing	:SetShow(false)
		HouseProgressSection._OnGoingText       :SetShow(false)
		HouseProgressSection._OnGoingText_Vlaue :SetShow(false)
		HouseProgressSection._Btn_Immediately	:SetShow(false)

	elseif ( eWorkType.largeCraft == workType ) then
		local currentKey = ToClient_getLargeCraftExchangeKeyRaw( houseInfoSS )
		local workData			= ToClient_getHouseWorkableListCount(houseInfoSS)
		-- self._workableType		= ToClient_getHouseWorkableTypeByIndex( houseInfoSS, 0 )
		local workCount			= ToClient_getRentHouseWorkableListByCustomOnlySize( HouseControlManager._currentUseType, 1, HouseControlManager._currentLevel)
				
		for index = 1, workCount do
			if currentKey == ToClient_getWorkableExchangeKeyByIndex(index - 1) then
				local esSSW			= ToClient_getHouseWorkableItemExchangeByIndex(houseInfoSS ,index - 1)
				if esSSW:isSet() then					
					local itemStatic	= esSSW:getResultItemStaticStatusWrapper():get()
					local workName		= esSSW:getDescription()
					local workIcon 		= "icon/" .. esSSW:getIcon()	
					-- 결과물 정보
					local resultIcon	= workIcon
					local resultName 	= "???"
					local resultKey 	= nil
					
					if false == esSSW:getUseExchangeIcon() then
						resultName	= getItemName( itemStatic )	
						resultKey 	= itemStatic._key
					end
					
					HouseProgressSection._itemKey_Tooltip = resultKey
					
					local esSS					= esSSW:get()
					local eSSCount 				= getExchangeSourceNeedItemList(esSS, true)
					local workingCout			= ToClient_getHouseWorkingWorkerList( houseInfoSS )
					local totalCount			= 0
					local sumProgressCount		= 0
					local sumOnGoingCount		= 0
					
					local workingList = {}
					for idx = 1, workingCout do
						local workerNo 		= ToClient_getHouseWorkingWorkerByIndex( houseInfoSS, idx - 1 ).workerNo:get_s64() -- ???ByIndex(idx)
						local resourceIndex = ToClient_getLargeCraftWorkIndexByWorker(workerNo) + 1
						HouseProgressSection._workerNo[idx] = workerNo
						if nil == workingList[resourceIndex] then
							workingList[resourceIndex] = {}
						end
						local _index = #workingList[resourceIndex] + 1
						workingList[resourceIndex][_index] = workerNo	
					end	
			
					for idx = 1, eSSCount do		
						local onGoingCount 	= 0
						if nil ~= workingList[idx] then
							onGoingCount = #workingList[idx]
						end
						local itemStaticInfomationWrapper 	= getExchangeSourceNeedItemByIndex(idx - 1)
						local fullCount 	= Int64toInt32( itemStaticInfomationWrapper:getCount_s64() )
						local progressCount = ToClient_getLargeCarftCompleteProgressPoint( houseInfoSS, esSSW:getExchangeKeyRaw(), idx - 1 )	
						
						if progressCount < 0 then
							progressCount = 0 
						else
							progressCount = ( fullCount -  progressCount )
						end	
						
						totalCount 			= totalCount + fullCount
						sumProgressCount 	= sumProgressCount + progressCount
						sumOnGoingCount 	= sumOnGoingCount + onGoingCount
					end	
					local _workingProgress = math.floor((sumProgressCount/totalCount) * 100)
					local _onGoingProgress = math.floor(((sumOnGoingCount+sumProgressCount)/totalCount) * 100)
					
					HouseProgressSection._ProgressText_1        :SetShow(false)
					HouseProgressSection._ProgressText_2        :SetShow(true)					
					HouseProgressSection._ProgressText_Value	:SetText(tostring(sumProgressCount) .. "/" .. tostring(totalCount))
					HouseProgressSection._Progress				:SetProgressRate(_workingProgress)
					HouseProgressSection._Progress_OnGoing		:SetProgressRate(_onGoingProgress)
					HouseProgressSection._Progress_OnGoing		:SetShow(true)
					
					HouseProgressSection._OnGoingText_Vlaue     :SetText(tostring(sumOnGoingCount))
					HouseProgressSection._OnGoingText           :SetShow(true)
					HouseProgressSection._OnGoingText_Vlaue     :SetShow(true)					
					
					HouseProgressSection._Icon_Working			:ChangeTextureInfoName(workIcon)
					HouseProgressSection._WorkName				:SetText(workName)
					HouseProgressSection._Icon_BG				:SetShow(true)
					HouseProgressSection._Icon_Working			:SetShow(true)
					HouseProgressSection._Icon_Working			:addInputEvent("Mouse_On","HouseProgressSection_Show_Tooltip_LargeCraft()")
					HouseProgressSection._Icon_Working			:addInputEvent("Mouse_Out","Panel_Tooltip_Item_hideTooltip()")
					HouseProgressSection._Icon_UseType			:SetShow(false)
					HouseProgressSection._RemainTime			:SetShow(false)
					HouseProgressSection._RemainTime_Vlaue		:SetShow(false)
					HouseProgressSection._Btn_LargCraft			:SetShow(true)
					HouseProgressSection._Btn_CancelWork		:SetShow(false)
					break
				end
			end
		end
	end
end

function HouseProgressSection_SetBaseTextureUV(pData, pPath, pX1, pY1, pX2, pY2)
	pData:ChangeTextureInfoName( pPath )
	local x1, y1, x2, y2 = setTextureUV_Func( pData, pX1, pY1, pX2, pY2 )
	pData:getBaseTexture():setUV(  x1, y1, x2, y2  )
	pData:setRenderTexture(pData:getBaseTexture())
end


local houseTextureList = {
	[CppEnums.eHouseUseType.Empty						] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {1, 1, 43, 43} },	-- 아무것도 아닌타입
	[CppEnums.eHouseUseType.Lodging						] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {1, 1, 43, 43} },	-- 일꾼 숙소
	[CppEnums.eHouseUseType.Depot						] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {87, 1, 129, 43} },	-- 창고
	[CppEnums.eHouseUseType.Ranch						] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {130, 1, 172, 43} },	-- 목장
	[CppEnums.eHouseUseType.WeaponForgingWorkshop		] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {173, 1, 215, 43} },	-- 무기 단조 공방
	[CppEnums.eHouseUseType.ArmorForgingWorkshop		] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {216, 1, 258, 43} },	-- 갑주 단조 공방
	[CppEnums.eHouseUseType.HandMadeWorkshop			] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {259, 1, 301, 43} },	-- 수공예 공방
	[CppEnums.eHouseUseType.WoodCraftWorkshop			] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {302, 1, 344, 43} },	-- 목공예 공방
	[CppEnums.eHouseUseType.JewelryWorkshop				] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {345, 1, 387, 43} },	-- 세공소
	[CppEnums.eHouseUseType.ToolWorkshop				] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {388, 1, 430, 43} },	-- 도구 공방
	[CppEnums.eHouseUseType.Refinery					] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {431, 1, 473, 43} },	-- 정제소
	[CppEnums.eHouseUseType.ImproveWorkshop				] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {1, 44, 43, 86} },	-- 개량소
	[CppEnums.eHouseUseType.CannonWorkshop				] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {44, 44, 86, 86} },	-- 대포 제작 공방
	[CppEnums.eHouseUseType.Shipyard					] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {87, 44, 129, 86} },	-- 조선소
	[CppEnums.eHouseUseType.CarriageWorkshop			] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {130, 44, 172, 86} },	-- 마차 제작소
	[CppEnums.eHouseUseType.HorseArmorWorkshop			] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {173, 44, 215, 86} },	-- 마구 제작소
	[CppEnums.eHouseUseType.FurnitureWorkshop			] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {216, 44, 258, 86} },	-- 가구 공방
	[CppEnums.eHouseUseType.LocalSpecailtiesWorkshop	] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {259, 44, 301, 86} },	-- 특산물 가공소
	[CppEnums.eHouseUseType.Wardrobe					] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {345, 259, 387, 301} },	-- 의상실
	[CppEnums.eHouseUseType.SiegeWeapons				] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {431, 44, 473, 86} },	-- 공성무기
	[CppEnums.eHouseUseType.ShipParts					] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {388, 44, 430, 86} },	-- 선박부품
	[CppEnums.eHouseUseType.WagonParts					] = { path = "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", pos = {345, 44, 387, 86} },	-- 마차부품
}

function Set_HouseUseType_Texture_Icon(_Target)
	local textureTarget = houseTextureList[HouseControlManager._currentGroupType]
	if ( nil ~= textureTarget ) then
		HouseProgressSection_SetBaseTextureUV( _Target, textureTarget.path, textureTarget.pos[1], textureTarget.pos[2], textureTarget.pos[3], textureTarget.pos[4])
	else
		-- 빈집
		HouseProgressSection_SetBaseTextureUV( _Target, "new_ui_common_forlua/Window/HouseInfo/HouseIcon.dds", 302, 44, 344, 86)
	end
end

local currentWorkCountCheck = false
function HouseProgressSection_Update()
	if false == HouseProgressSection._BG:GetShow() or ( eWorkType.largeCraft == workType ) then
		return
	end
	
	local workType = HouseProgressSection._workType
	local workingcnt = -1
	HouseProgressSection._updateCount = HouseProgressSection._updateCount + 1
	
	if ( eWorkType.craft == workType ) then
		workingcnt 		= HouseProgressSection:getWorkingList()
		if HouseProgressSection.isFale_Init == true and workingcnt > 0 then
			HouseProgressSection_Init()
			HouseProgressSection.isFale_Init = false
		end
		
		if ( 0 == HouseControlManager._houseKey ) then
			-- WorldMapWindow_CloseNodeMenu()
			return
		end
	
		local workName = HouseProgressSection._WorkName:GetText()
		for idx = 0 , workingcnt - 1 , 1 do
			local worker = getWorkingByIndex( idx ).workerNo
			local workerNo = worker:get_s64()
			-- local staticStatusWrapper = getItemEnchantStaticStatus( staticStatusKey._key )
			
			HouseProgressSection._workingProgress	= getWorkingProgress( workerNo ) * 100000	
			HouseProgressSection._remainTime		= Util.Time.timeFormatting( ToClient_getWorkingTime( workerNo ) )
		
			HouseProgressSection._ProgressText_Value:SetText(string.format("%3.1f%%", HouseProgressSection._workingProgress  ) )
			HouseProgressSection._Progress			:SetProgressRate(HouseProgressSection._workingProgress)
			HouseProgressSection._RemainTime_Vlaue	:SetText( HouseProgressSection._remainTime )
					
			HouseProgressSection._saveProgress = HouseProgressSection._workingProgress	

			if 0 < ToClient_getNpcWorkerWorkingCount( workerNo ) and false == currentWorkCountCheck then
				HouseProgressSection._WorkName:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_WORKNAME", "workName", workName, "workerNo", ToClient_getNpcWorkerWorkingCount( workerNo ) ) ) -- workName .. " (" .. ToClient_getNpcWorkerWorkingCount( workerNo ) .. "회 남음)")
				currentWorkCountCheck = true
			end

			local workStringNo = tostring(workerNo)
			if true == waitingCancelWorkerNo[workStringNo] then
				HouseProgressSection._Btn_CancelWork:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_CANCELRESERVE") ) -- "취소예약")
				HouseProgressSection._Btn_CancelWork:SetEnable( false )
				HouseProgressSection._Btn_CancelWork:SetMonoTone( true )
			else
				waitingCancelWorkerNo[workStringNo] = nil
				HouseProgressSection._Btn_CancelWork:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_WORKCANCEL") ) -- "작업취소")
				HouseProgressSection._Btn_CancelWork:SetEnable( true )
				HouseProgressSection._Btn_CancelWork:SetMonoTone( false )
			end
			
		end	
	elseif ( eWorkType.changeHouseUseType == workType ) then
		HouseProgressSection._workingProgress	= ToClient_GetProgressRateChangeHouseUseType( HouseControlManager._houseKey )	
		HouseProgressSection._remainTime		= Util.Time.timeFormatting( ToClient_GetLeftTimeChangeHouseUseType( HouseControlManager._houseKey ) )
	
		HouseProgressSection._ProgressText_Value:SetText(string.format("%3.1f%%", HouseProgressSection._workingProgress  ) )
		HouseProgressSection._Progress			:SetProgressRate(HouseProgressSection._workingProgress)
		HouseProgressSection._RemainTime_Vlaue	:SetText( HouseProgressSection._remainTime )
	end	
end

function HouseProgressSection_Set(workType)	
	
	HouseProgressSection._Title				:SetShow(true)
	HouseProgressSection._BG   				:SetShow(true)
	HouseProgressSection._Btn_Immediately	:SetShow(false)
	HouseManageSection._Title				:SetShow(false)
	HouseManageSection._BG					:SetShow(false)
	

	HouseProgressSection._workType = workType
	HouseProgressSection._workingProgress = 0
	HouseProgressSection._saveProgress = 0	
	HouseProgressSection._updateCount = 0		

	if HouseProgressSection._workType == eWorkType.craft then					-- 아이템을 제작할 때
		HouseProgressSection._Btn_CancelWork	:SetShow(true)
		HouseProgressSection._Btn_Immediately	:SetShow(true)
		HouseProgressSection._Btn_Immediately	:addInputEvent("Mouse_LUp","HouseProgressSection_Immediately_CraftItem()");
	elseif HouseProgressSection._workType == eWorkType.changeHouseUseType then	-- 집의 용도를 변경할 때
		HouseProgressSection._Btn_CancelWork	:SetShow(false)
		if ( false ) then
			HouseProgressSection._Btn_Immediately	:SetShow(true)
			HouseProgressSection._Btn_Immediately	:addInputEvent("Mouse_LUp","ImmediatelyComplete()");
		end
	elseif HouseProgressSection._workType == eWorkType.largeCraft then
		HouseProgressSection._Btn_CancelWork:SetShow(false)
		if ( false ) then
			HouseProgressSection._Btn_Immediately	:SetShow(true)
			HouseProgressSection._Btn_Immediately	:addInputEvent("Mouse_LUp","ImmediatelyComplete()");
		end
	end

	if not (isGameTypeKorea() or isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_JAP )) then	-- 한국/일본만 즉시 완료를 노출한다.
		HouseProgressSection._Btn_Immediately	:SetShow(false)
	end
	
	HouseProgressSection.isFale_Init = false
	
	HouseProgressSection_Init()
	HouseProgressSection_Update()
end

function HouseProgressSection_Hide()
	HouseProgressSection._Title	:SetShow(false)
	HouseProgressSection._BG   	:SetShow(false)        
	HouseManageSection._Title	:SetShow(true)
	HouseManageSection._BG		:SetShow(true)
	
	HouseProgressSection._workType = nil
	HouseProgressSection._itemKey_Tooltip = nil
	HouseProgressSection._nodekey = 0
	HouseProgressSection._saveProgress = 0
	HouseProgressSection._updateCount = 0
	isFale_Init = false
	currentWorkCountCheck = false
end

function HouseProgressSection_Immediately_CraftItem()	-- 아이템 제작 즉시 완료
	local worker = ToClient_getHouseWorkingWorkerByIndex( houseInfoSS, 0 ).workerNo
	local workerNo = worker:get_s64()
	local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
	if esSSW:isSet() then
		local workingIcon = esSSW:getIcon()	
		local workName 	= esSSW:getDescription()
		
		HouseProgressSection._remainTimeInt = ToClient_getWorkingTime( workerNo )
		HouseProgressSection._needPearl = ToClient_GetUsingPearlByRemainingPearl(CppEnums.InstantCashType.eInstant_CompleteNpcWorking, HouseProgressSection._remainTimeInt)
		local messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_IMMEDIATELYCOMPLETE_MSGBOX_TITLE") -- "즉시 완료"
		local messageBoxMemo	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_USEPEARL", "workName", workName, "needPearl", tostring(HouseProgressSection._needPearl) ) -- "[ ".. workName .. " ]\n" .. tostring(HouseProgressSection._needPearl) .. " 펄을 사용해서 즉시 완료 하시겠습니까?"
		local messageboxData = { title = messageboxTitle, content = messageBoxMemo , functionYes = HouseProgressSection_Immediately_CraftItemYes, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData, "middle")
	end
end

function 	HouseProgressSection_Immediately_CraftItemYes()
	ToClient_requestQuickComplete(HouseProgressSection._worker, HouseProgressSection._needPearl)
end

function HouseProgressSection_CancelWork()	-- 1개면 취소하지 못한다.
	local worker		= ToClient_getHouseWorkingWorkerByIndex( houseInfoSS, 0 ).workerNo
	local workerNo		= worker:get_s64()
	local workingcnt	= ToClient_getNpcWorkerWorkingCount( workerNo )
	local esSSW			= ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(workerNo)
	if esSSW:isSet() and 0 < workingcnt then
		local workingIcon = esSSW:getIcon()	
		local workName 	= esSSW:getDescription()
		local cancelWorkContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CANCELWORK_CONTENT", "workName", workName)
		local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CANCELWORK_TITLE" ), content = cancelWorkContent , functionYes = HouseProgressSection_CancelWork_Continue, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData, "middle")
	elseif esSSW:isSet() and workingcnt < 1 then
		local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CANCELWORK_TITLE" ), content = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_ONLYONEWORK"), functionApply = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageboxData, "middle")
	end
end

function ImmediatelyComplete() -- 즉시 완료 버튼을 눌렀을 경우 메시지 박스를 띄워준다. / 하우스 용도변경 즉시 완료
	local needPearl = ToClient_GetNeedCompletePearl( HouseControlManager._houseKey )
	local messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_IMMEDIATELYCOMPLETE_MSGBOX_TITLE")
	local messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NEW_HOUSECONTROL_USEMOREPEARL", "needPearl", needPearl ) -- needPearl .. " 펄을 사용해서 즉시 완료 하시겠습니까?"
	local messageboxData = { title = messageboxTitle, content = messageBoxMemo , functionYes = HouseProgressSection_ImmediatelyYes, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData, "middle")
end

function HouseProgressSection_ImmediatelyYes()
	ToClient_RequestCompleteChangeUseType( HouseControlManager._houseKey )
end
	
function HouseProgressSection_CancelWork_Continue()
	ToClient_requestCancelNextWorking(HouseProgressSection._worker)
	-- local isSuccess = ToClient_requestStopPlantWorking(HouseProgressSection._worker)
	-- if ( false == isSuccess ) then
	--     Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "Lua_RentHouseNoWorkingByWorkerNotSelect") )
	-- end
end

function HouseProgressSection_Check()
	if HouseControlManager._currentUseType == HouseControlManager._clickedUseType then
		local workingcnt 	= HouseProgressSection:getWorkingList()
		local isUsable 		= ToClient_IsUsable( HouseControlManager._houseKey )
		local isLargeCraft 	= ToClient_getLargeCraftExchangeKeyRaw( houseInfoSS )
		if false == isUsable then -- 용도 변경 중
			if false == HouseProgressSection._BG:GetShow() then
				HouseProgressSection_Set(eWorkType.changeHouseUseType)
			else
				HouseProgressSection_Update()
			end
		elseif isLargeCraft > 0 then
			if false == HouseProgressSection._BG:GetShow() then
				HouseProgressSection_Set(eWorkType.largeCraft)				
			else
				HouseProgressSection_Update()
			end
		elseif workingcnt > 0 then -- 제작 중
			if false == HouseProgressSection._BG:GetShow() then
				HouseProgressSection_Set(eWorkType.craft)				
			else
				HouseProgressSection_Update()
			end
		elseif HouseProgressSection._BG:GetShow() then	
			HouseProgressSection_Hide()
		end
	elseif HouseProgressSection._BG:GetShow() then			 
		HouseProgressSection_Hide()
	end
end

function HouseProgressSection:getWorkingList()
	local workingCnt = getWorkingListAtRentHouse(HouseControlManager._houseKey)
	return workingCnt
end
function HouseProgressSection_Show_Tooltip_Work()
	if isKeyPressed( VCK.KeyCode_CONTROL ) then
		Keep_Tooltip_Work = true
		return
	end

	local uiBase = HouseProgressSection._Icon_BG
	local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(HouseProgressSection._workerNo[0])
	if esSSW:isSet() then
		FGlobal_Show_Tooltip_Work(esSSW, uiBase)
	end
end

function HouseProgressSection_Hide_Tooltip_Work()
	if isKeyPressed( VCK.KeyCode_CONTROL ) then
		return
	end
	local esSSW = ToClient_getItemExchangeSourceStaticStatusWrapperByWorker(HouseProgressSection._workerNo[0])
	FGlobal_Hide_Tooltip_Work(esSSW, false)
end

function HouseProgressSection_Show_Tooltip_LargeCraft()
	local staticStatusKey 	= HouseProgressSection._itemKey_Tooltip
	local uiBase			= HouseProgressSection._Icon_BG
	if ( nil == staticStatusKey ) or ( nil == uiBase ) then
		return
	end
	
	local staticStatusWrapper = getItemEnchantStaticStatus( staticStatusKey )
	
	Panel_Tooltip_Item_Show(staticStatusWrapper, uiBase, true, false)
end


function FromClient_changeLeftHouseProgressSection( workerNo )
	local workStringNo = tostring(workerNo)
	waitingCancelWorkerNo[workStringNo] = true
end
registerEvent("FromClient_changeLeftWorking",		"FromClient_changeLeftHouseProgressSection")

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------ 클라이언트에서 보내는 이벤트 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



registerEvent("FromClient_ReceiveBuyHouse", 		"FromClient_ReceiveBuyHouse")
registerEvent("FromClient_ReceiveReturnHouse", 		"FromClient_ReceiveReturnHouse")
registerEvent("FromClient_ReceiveChangeUseType", 	"FGlobal_ReceiveChangeUseType")
registerEvent("FromClient_ReceiveSetMyHouse", 		"FromClient_ReceiveSetMyHouse")
registerEvent("FromClient_AppliedChangeUseType", 	"FromClient_AppliedChangeUseType")
registerEvent("WorldMap_StopWorkerWorking",			"FromClient_House_StopWork")
registerEvent("WorldMap_WorkerDataUpdateByHouse",	"FromClient_House_StartWork")
Panel_HouseControl:RegisterUpdateFunc("HouseProgressSection_Check")


local Refresh_HouseIcon_Texture = function (houseInfoSSWrapper)
	if nil == houseInfoSSWrapper then
		return
	end
	local _houseKey	= houseInfoSSWrapper:getHouseKey()
	local _houseBtn = ToClient_findHouseButtonByKey(_houseKey)
	FGlobal_HouseHoldButtonSetBaseTexture(_houseBtn)
end

function FromClient_ReceiveBuyHouse( houseInfoSSWrapper )
	Refresh_HouseIcon_Texture(houseInfoSSWrapper) -- 
	local NextHouseCount = houseInfoSSWrapper:getNextHouseCount()	
	for idx = 0, NextHouseCount - 1 do	
		local NextHouseInfoStaticStatusWrapper = houseInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(idx)
		Refresh_HouseIcon_Texture(NextHouseInfoStaticStatusWrapper)
	end
	if Panel_House_SellBuy_Condition:GetShow() then
		handleClicked_Check_PrevHouse(false)
		if Panel_House_SellBuy_Condition:GetShow() and true == House_SellBuy_Condition.isAll then
			HandleClick_House_SellBuy_All()
		else
			House_SellBuy_Condition.isAll = false
		end
	end
	
	if Panel_HouseControl:GetShow() and HouseControlManager._houseKey == houseInfoSSWrapper:getHouseKey() then
		FGlobal_UpdateHouseControl(houseInfoSSWrapper)
	end	
	
	-- FGlobal_HouseHoldButtonSetBaseTexture( HouseControlManager._houseBtn )
	--getSelfPlayer():get():getWorldMapHouseLineWrapper():updateColor()	
	
	--WorldMapWindow_Update_ExplorePoint()

	--local houseKey = HouseControlManager._houseInfo:getHouseKey()
	--local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( houseKey )
	-- if( false == houseInfoSSWrapper:isSet() )then
		-- return
	-- end

	-- local count = houstInfoSSWrapper:getNextHouseCount()
	-- for index = 0 , count - 1 do
		-- local nextHouseInfo = houstInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(index)

		-- local houseIndex = housing_getHouseIndexByCharacterKey( nextHouseInfo:getHouseKey() ) + 1
		-- FGlobal_HouseHoldButtonSetBaseTexture( houseIndex )
	-- end

	-- 좌측 공헌도를 갱신한다.
	if isWorldMapGrandOpen() then
		FGlobal_WorldMapGrand_NodeExplorePoint_Update()
	end
end

function FromClient_ReceiveReturnHouse(houseInfoSSWrapper)
	Refresh_HouseIcon_Texture(houseInfoSSWrapper)
	local NextHouseCount = houseInfoSSWrapper:getNextHouseCount()	
	for idx = 0, NextHouseCount - 1 do	
		local NextHouseInfoStaticStatusWrapper = houseInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(idx)
		Refresh_HouseIcon_Texture(NextHouseInfoStaticStatusWrapper)
	end
	if Panel_House_SellBuy_Condition:GetShow() then
		handleClicked_Check_NextHouse(false)	
		if Panel_House_SellBuy_Condition:GetShow() and true == House_SellBuy_Condition.isAll then
			HandleClick_House_SellBuy_All()
		else
			House_SellBuy_Condition.isAll = false
		end
	end	
	
	if Panel_HouseControl:GetShow() and HouseControlManager._houseKey == houseInfoSSWrapper:getHouseKey() then
		FGlobal_UpdateHouseControl(houseInfoSSWrapper)
	end	
	
	-- local count = houseInfoStaticStatusWrapper:getNextHouseCount()
	-- for index = 0 , count - 1 do
		-- local nextHouseInfo = houseInfoStaticStatusWrapper:getNextHouseInfoStaticStatusWrapper(index)

		-- local houseIndex = housing_getHouseIndexByCharacterKey( nextHouseInfo:getHouseKey() ) + 1
		-- FGlobal_HouseHoldButtonSetBaseTexture( houseIndex )
	-- end

	-- 좌측 공헌도를 갱신한다.
	if isWorldMapGrandOpen() then
		FGlobal_WorldMapGrand_NodeExplorePoint_Update()
	end
end

function FGlobal_ReceiveChangeUseType( houseInfoSSWrapper, hasPreviouseHouse )
	---- Quest Check : From Here
	local _houseKey			= houseInfoSSWrapper:getHouseKey()
	local rentHouse 		= ToClient_GetRentHouseWrapper( _houseKey )
	local _currentGroupType	= eHouseUseGroupType.Count
	
	if ( nil ~= rentHouse ) and ( true == rentHouse:isSet() ) then
		_currentGroupType		= rentHouse:getHouseUseType()
	end
	
	if ( _currentGroupType == eHouseUseGroupType.Empty )	then
		FGlobal_MiniGame_HouseControl_Empty()		-- 주거지다!
		if ( true == hasPreviouseHouse ) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_HOUSE_USETYPE_MYHOUSE") )
		end
	end
	if ( _currentGroupType == eHouseUseGroupType.Depot )	then
		FGlobal_MiniGame_HouseControl_Depot()		-- 창고다!
	end
	if ( _currentGroupType == eHouseUseGroupType.Refinery )	then
		FGlobal_MiniGame_HouseControl_Refinery()	-- 정제소다!
	end
	if ( _currentGroupType == eHouseUseGroupType.LocalSpecailtiesWorkshop )	then
		FGlobal_MiniGame_HouseControl_LocalSpecailtiesWorkshop()	-- 특산물 가공소다!
	end
	if ( _currentGroupType == eHouseUseGroupType.Shipyard )	then
		FGlobal_MiniGame_HouseControl_Shipyard()  -- 조선소다
	end
	---- Quest Check : End
	
	Refresh_HouseIcon_Texture(houseInfoSSWrapper)
	local NextHouseCount = houseInfoSSWrapper:getNextHouseCount()	
	for idx = 0, NextHouseCount - 1 do	
		local NextHouseInfoStaticStatusWrapper = houseInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(idx)
		Refresh_HouseIcon_Texture(NextHouseInfoStaticStatusWrapper)
	end
	local typeName = " "
	local needTime = 0
	local currentHouseLevel = 1
	local changeHouseKey = houseInfoSSWrapper:getHouseKey();	
	local rentHouseWrapper = ToClient_GetRentHouseWrapper( changeHouseKey )	
	
	if ( rentHouseWrapper:isSet() ) then
		local houseInfoStaticStatus = rentHouseWrapper:getStaticStatus()
		local index = houseInfoStaticStatus:getIndexByReceipeKey(rentHouseWrapper:getType())
		local craftWrapper = houseInfoStaticStatus:getHouseCraftWrapperByIndex(index)
		typeName = craftWrapper:getReciepeName()
		currentHouseLevel = rentHouseWrapper:getLevel()
		local currentUseType = rentHouseWrapper:getType()
		local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( changeHouseKey )
		if houseInfoStaticStatusWrapper:isSet() then
			needTime	= houseInfoStaticStatusWrapper:getTransperTime( currentUseType, currentHouseLevel, currentHouseLevel)
		end
	end
	
	--local indexKey = housing_getHouseIndexByCharacterKey( changeHouseKey ) + 1;

	
	-- else
		-- FGlobal_HouseHoldButtonSetBaseTexture( HouseControlManager._houseBtn )	

	
	--local houseInfo = housing_getHouseInfo(indexKey - 1)
	
	if 0 ~= needTime then
		if currentHouseLevel > 1 then			
			Proc_ShowMessage_Ack( houseInfoSSWrapper:getName()..PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_TYPENAME_MESSAGE_1", "typeName", typeName, "typeLevel", currentHouseLevel) )
		elseif currentHouseLevel == 1 then
			Proc_ShowMessage_Ack( houseInfoSSWrapper:getName()..PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_TYPENAME_MESSAGE_2", "typeName", typeName) )			
		end
	end

	if Panel_HouseControl:GetShow() and HouseControlManager._houseKey == houseInfoSSWrapper:getHouseKey() then
		FGlobal_UpdateHouseControl(houseInfoSSWrapper)
	end
		
	--getSelfPlayer():get():getWorldMapHouseLineWrapper():updateColor()
	-- 용도 변경 완료시 하우스 내비 아이콘 업데이트
	FGlobal_MyHouseNavi_Update()
end

function FromClient_ReceiveSetMyHouse(houseInfoSSWrapper)
	Refresh_HouseIcon_Texture(houseInfoSSWrapper)
	local NextHouseCount = houseInfoSSWrapper:getNextHouseCount()	
	for idx = 0, NextHouseCount - 1 do	
		local NextHouseInfoStaticStatusWrapper = houseInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(idx)
		Refresh_HouseIcon_Texture(NextHouseInfoStaticStatusWrapper)
	end

	if Panel_HouseControl:GetShow() and HouseControlManager._houseKey == houseInfoSSWrapper:getHouseKey() then
		HouseControlManager:clear()
		HouseControlManager:UpdateMyHouse()
		HouseControlManager:UpdateCommon()
	end
	
	--local count = housing_getHouseListCount_ForWorldMap()
	--for index = 1, count, 1 do
		--FGlobal_HouseHoldButtonSetBaseTexture( index )
	--end
	--getSelfPlayer():get():getWorldMapHouseLineWrapper():updateColor()
end

function FromClient_AppliedChangeUseType(houseInfoSSWrapper)
	Refresh_HouseIcon_Texture(houseInfoSSWrapper)
	local NextHouseCount = houseInfoSSWrapper:getNextHouseCount()	
	for idx = 0, NextHouseCount - 1 do	
		local NextHouseInfoStaticStatusWrapper = houseInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(idx)
		Refresh_HouseIcon_Texture(NextHouseInfoStaticStatusWrapper)
	end
	FromClient_HouseControl_Refresh(houseInfoSSWrapper)
end

function FromClient_House_StopWork(workerNo, isUserRequest)
	for key, value in pairs (HouseProgressSection._workerNo) do
		if value == workerNo then
			local houseInfoSSWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseControlManager._houseKey )
			FromClient_HouseControl_Refresh( houseInfoSSWrapper )
			break
		end
	end
end

function FromClient_House_StartWork(rentHouseWrapper)
	local houseInfoSSWrapper = rentHouseWrapper:getStaticStatus()
	Refresh_HouseIcon_Texture(houseInfoSSWrapper)
	local NextHouseCount = houseInfoSSWrapper:getNextHouseCount()	
	for idx = 0, NextHouseCount - 1 do	
		local NextHouseInfoStaticStatusWrapper = houseInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(idx)
		Refresh_HouseIcon_Texture(NextHouseInfoStaticStatusWrapper)
	end
	FromClient_HouseControl_Refresh( houseInfoSSWrapper )
end

function FromClient_HouseControl_Refresh(houseInfoSSWrapper)
	Refresh_HouseIcon_Texture(houseInfoSSWrapper)
	local NextHouseCount = houseInfoSSWrapper:getNextHouseCount()	
	for idx = 0, NextHouseCount - 1 do	
		local NextHouseInfoStaticStatusWrapper = houseInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(idx)
		Refresh_HouseIcon_Texture(NextHouseInfoStaticStatusWrapper)
	end
	if Panel_HouseControl:GetShow() and HouseControlManager._houseKey == houseInfoSSWrapper:getHouseKey() then
		FGlobal_UpdateHouseControl(houseInfoSSWrapper)
	end			
end

--------------------------------------------------------------------------------------------------------------
--------------------- 매각/구매 조건 확인 --------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local prevHouse_List = {}
local prevHouse_List_Cost = {}

local best_Junction = 1
local prevHouse_List_End = function()
	if 0 > #prevHouse_List or 0 > #prevHouse_List_Cost then
		return
	end

	local save_Cost = 0
	for idx, value in pairs (prevHouse_List_Cost) do		
		if idx == 1 then
			save_Cost = value
			best_Junction = idx
		elseif save_Cost > value then
			save_Cost = value
			best_Junction = idx
		end
	end	

--	if ( false == Panel_House_SellBuy_Condition:GetShow() ) or ( true == Panel_HouseControl:GetShow() ) then
--		--Panel_House_SellBuy_Condition:SetShow(false)
--		WorldMapPopupManager:popPanel()		
--	end
	show_PrevHouse(prevHouse_List[best_Junction], prevHouse_List_Cost[best_Junction], HouseControlManager._clickedUseType)
--	Panel_House_SellBuy_Condition:SetShow(true)
	FGLobal_PopupAdd( Panel_House_SellBuy_Condition )
	-- WorldMapPopupManager:push(Panel_House_SellBuy_Condition, true)

	prevHouse_List = {}
	prevHouse_List_Cost = {}
end

function prevHouse_List_Continue(continueList)
	local prevHouse_Continue = continueList
	local temp_Continue = {}

	for i = 1,#prevHouse_Continue do
		local junction = prevHouse_Continue[i]

		local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( prevHouse_List[junction][#prevHouse_List[junction]] )		
		local PrevHouseCount = houseInfoStaticStatusWrapper:getPrevHouseCount()	

		for idx = 0, PrevHouseCount - 1 do
			if idx > 0 then
				if nil == prevHouse_List[#prevHouse_List + 1] then
					prevHouse_List[#prevHouse_List + 1] = {}
				end
				for index = 1, #prevHouse_List[junction] do
					prevHouse_List[#prevHouse_List + 1][index] = prevHouse_List[junction][index]
				end
				prevHouse_List_Cost[#prevHouse_List + 1] = prevHouse_List_Cost[junction]
				junction = #prevHouse_List + 1
			end

			local PrevHouseInfoStaticStatusWrapper = houseInfoStaticStatusWrapper:getPrevHouseInfoStaticStatusWrapper(idx)
			local HouseKey = PrevHouseInfoStaticStatusWrapper:getHouseKey()

			if false == ToClient_IsMyHouse( HouseKey ) then
				prevHouse_List[junction][#prevHouse_List[junction] + 1] = HouseKey
				prevHouse_List_Cost[junction] = prevHouse_List_Cost[junction] + PrevHouseInfoStaticStatusWrapper:getNeedExplorePoint()
				temp_Continue[#temp_Continue + 1] = junction			
			elseif ( ToClient_IsMyLiveHouse( HouseKey ) ) then
				prevHouse_List[junction][#prevHouse_List[junction] + 1] = HouseKey
				prevHouse_List_Cost[junction] = prevHouse_List_Cost[junction]
				temp_Continue[#temp_Continue + 1] = junction
			end
		end

	end

	return temp_Continue
end

function handleClicked_Check_PrevHouse(isRefresh)
	clear_HouseSelectedAni_bySellBuy()
	local houseKey = HouseControlManager._houseKey
	if false == isRefresh and House_SellBuy_Condition.conditionKey ~= -1 then
		houseKey = House_SellBuy_Condition.conditionKey	
		if true == ToClient_IsMyHouse( houseKey ) then
			HandleClick_House_SellBuy_Close()
			return
		end
	end
	prevHouse_List = {}
	prevHouse_List[1] = {}
	prevHouse_List[1][1] = houseKey
	
	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( houseKey )
	--local houseInfoStaticStatusWrapper = HouseControlManager._houseInfo
	prevHouse_List_Cost = {}
	prevHouse_List_Cost[1] = houseInfoStaticStatusWrapper:getNeedExplorePoint()
	
	local temp_Continue ={}
	temp_Continue[1] = 1
	
	local maxCostCalcCount = 10
	local costCalcCount = 0
	while ( 0 < #temp_Continue ) and (costCalcCount < maxCostCalcCount) do
		temp_Continue = prevHouse_List_Continue(temp_Continue)
		costCalcCount = costCalcCount +1
	end
	prevHouse_List_End()
end

-------------------------------------
local nextHouse_List = {}
local nextHouse_List_Cost = 0

local nextHouse_List_End = function()
	if 0 > #nextHouse_List then
		return
	end
	
--	if ( false == Panel_House_SellBuy_Condition:GetShow() ) or ( true == Panel_HouseControl:GetShow() ) then
--		WorldMapPopupManager:popPanel()
--		--Panel_House_SellBuy_Condition:SetShow(false)
--	end
	show_NextHouse(nextHouse_List, nextHouse_List_Cost)
	FGLobal_PopupAdd( Panel_House_SellBuy_Condition )
	-- WorldMapPopupManager:push(Panel_House_SellBuy_Condition, true)
	--Panel_House_SellBuy_Condition:SetShow(true)
	nextHouse_List = {}
	nextHouse_List_Cost = 0
end

function nextHouse_List_Check_StandAlnoe(currentKey, closedKey)
	-- 최초 구입해야하는 집까지 추적이 가능하면 true, 아니면 false
	local checkKey = currentKey
	local temp_Continue = {}
	
	for idx = 1, #checkKey do
		
		local HouseKey = checkKey[idx]
		local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( HouseKey )		
		local PrevHouseCount = houseInfoStaticStatusWrapper:getPrevHouseCount()	
		
		if 0 == PrevHouseCount then
			return temp_Continue, true
		end
		
		for idx = 0, PrevHouseCount - 1 do	
			local PrevHouseInfoStaticStatusWrapper = houseInfoStaticStatusWrapper:getPrevHouseInfoStaticStatusWrapper(idx)
			local PrevHouseKey = PrevHouseInfoStaticStatusWrapper:getHouseKey()
							
			if true == ToClient_IsMyHouse( PrevHouseKey ) and (PrevHouseKey ~= closedKey) and ( PrevHouseKey ~= nextHouse_List[1] ) then
				temp_Continue[#temp_Continue + 1] = PrevHouseKey
			end
		end
	end
	return temp_Continue, false
end

function nextHouse_List_Continue(continueList)
	local nextHouse_Continue = continueList
	local temp_Continue = {}

	for i = 1,#nextHouse_Continue do
		local junction = nextHouse_Continue[i]
		local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( nextHouse_List[junction] )		
		local NextHouseCount = houseInfoStaticStatusWrapper:getNextHouseCount()	

		for idx = 0, NextHouseCount - 1 do
			
			local NextHouseInfoStaticStatusWrapper = houseInfoStaticStatusWrapper:getNextHouseInfoStaticStatusWrapper(idx)
			local HouseKey = NextHouseInfoStaticStatusWrapper:getHouseKey()
							
			if true == ToClient_IsMyHouse( HouseKey ) then
				local temp_HouseKey = {}
				temp_HouseKey[1] = HouseKey
				local isStandAlone = false
					
				local maxCostCalcCount = 10
				local costCalcCount = 0
				while ( 0 < #temp_HouseKey ) and (costCalcCount < maxCostCalcCount) do
					temp_HouseKey, isStandAlone = nextHouse_List_Check_StandAlnoe(temp_HouseKey, nextHouse_List[junction])
					costCalcCount = costCalcCount +1
				end
				houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( nextHouse_List[junction] ) -- 꼭 다시 호출해줘야 한다!
				if false == isStandAlone then
					nextHouse_List[#nextHouse_List + 1] = HouseKey
					nextHouse_List_Cost = nextHouse_List_Cost + NextHouseInfoStaticStatusWrapper:getNeedExplorePoint()
					temp_Continue[#temp_Continue + 1] = #nextHouse_List			
				end
			end
		end

	end

	return temp_Continue
end

function handleClicked_Check_NextHouse(isRefresh)
	clear_HouseSelectedAni_bySellBuy()
	local houseKey = HouseControlManager._houseKey
	if false == isRefresh and House_SellBuy_Condition.conditionKey ~= -1 then
		houseKey = House_SellBuy_Condition.conditionKey	
		
		if false == ToClient_IsMyHouse( houseKey ) then
			HandleClick_House_SellBuy_Close()
			return
		end
	end
	nextHouse_List = {}
	nextHouse_List[1] = houseKey
	
	local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper( houseKey )
	nextHouse_List_Cost = houseInfoStaticStatusWrapper:getNeedExplorePoint()
	
	local temp_Continue ={}
	temp_Continue[1] = 1
	
	local maxCostCalcCount = 10
	local costCalcCount = 0
	while ( 0 < #temp_Continue ) and (costCalcCount < maxCostCalcCount) do
		temp_Continue = nextHouse_List_Continue(temp_Continue)
		costCalcCount = costCalcCount +1
	end
	
	nextHouse_List_End()
end

function FromClient_WorldMap_WorkerDataUpdateByHouseControl()
	HouseProgressSection_Init()
	currentWorkCountCheck = false
	HouseProgressSection_Update()
end

registerEvent( "WorldMap_WorkerDataUpdate",					"FromClient_WorldMap_WorkerDataUpdateByHouseControl" )
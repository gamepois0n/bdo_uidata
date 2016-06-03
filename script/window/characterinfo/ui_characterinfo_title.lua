local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode
local UI_color 		= Defines.Color
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM 		= CppEnums.TextMode

Panel_Window_CharInfo_TitleInfo:SetShow( false )

local TitleInfo	= {
	TitleUIPool 				= {},
	_titleListBG				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Static_BG"),
	totalProgress				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Static_TotalProgress_Progress"),
	totalProgressValue			= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgress_Percent"),

	Category_BTN				= {
		[0] = 	UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_AllRound"),
				UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Combat"),
				UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Product"),
				UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Fishing"),
	},

	_titleRightListBG			= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Static_RightBG"),
	
	titleSubject_Btn				= {
		[0] = 	UI.getChildControl( Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_AllRound" ),
				UI.getChildControl( Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Combat" ),
				UI.getChildControl( Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Product" ),
				UI.getChildControl( Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Fish" ),
	},
	
	-- titleList_Subject			= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TitleList_Subject"),
	
	-- btn_titleList_Subject		= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TitleList_Btn"),
	
	-- btn_titleList_L				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Button_TitleList_L"),
	-- btn_titleList_R				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Button_TitleList_R"),
	
	--스크롤
	titleListScroll				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Scroll_TitleList"),

	--칭호 정보 부분
	title_ListAll				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AllRound_CountValue"),
	title_ListCombat			= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Combat_CountValue"),
	title_ListProduct			= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Product_CountValue"),
	title_ListFish				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Fishing_CountValue"),

	title_ListAllPercent		= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AllRound_PercentValue"),
	title_ListCombatPercent		= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Combat_PercentValue"),
	title_ListProductPercent	= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Product_PercentValue"),
	title_ListFishPercent		= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Fishing_PercentValue"),

	title_ListAllProgress		= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "CircularProgress_AllRound"),
	title_ListCombatProgress	= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "CircularProgress_Combat"),
	title_ListProductProgress	= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "CircularProgress_Product"),
	title_ListFishProgress		= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "CircularProgress_Fishing"),
	
	txt_AllRoundDesc			= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AllRoundDesc"),
	txt_CombatDesc				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_CombatDesc"),
	txt_ProductDesc				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_ProductDesc"),
	txt_FishingDesc				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_FishingDesc"),
	
	txt_TotalReward				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgressReward"),
	txt_TotalReward_Value		= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgressReward_Value"),
	
	txt_PartDesc				= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_SelectedType"),

	CurrentCategoryIdx			= 0,
	CurrentCategoryCount		= 0,

	maxTitleShow				= 13,
	NowTitleInterval			= 0,
	MinTitleInterval			= 0,
	MaxTitleInterval			= 0,
	
	title_LastUpdateTime		= UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AcceptCooltime"),
}

TitleInfo.titleListScrollBtn		= UI.getChildControl(TitleInfo.titleListScroll, "Scroll_CtrlButton")

-- TitleInfo.btn_titleList_L:addInputEvent( "Mouse_LUp", "titleList_Button_Next( true )" )
-- TitleInfo.btn_titleList_R:addInputEvent( "Mouse_LUp", "titleList_Button_Next( false )" )
-- TitleInfo.btn_titleList_Subject:addInputEvent( "Mouse_LUp", "titleList_Button_Next( false )" )

	
-- local isTitleList_PageNo = 0		-- 0 ~ 3
-- function titleList_Button_Next( isNext )
	-- local self = TitleInfo
	
	-- for idx = 0, 3 do
		-- self.Category_BTN[idx]:SetCheck( false )
	-- end

	-- self.btn_titleList_Subject:EraseAllEffect()
	-- self.btn_titleList_Subject:AddEffect( "UI_ButtonLineRight_White", false, 0.0, 0.0 )
	-- self.btn_titleList_Subject:AddEffect( "UI_ButtonLineRight_Blue", false, 0.0, 0.0 )

	-- if ( isNext == true ) then
		-- if ( isTitleList_PageNo <= 0 ) then
			-- isTitleList_PageNo = 3
		-- else
			-- isTitleList_PageNo = isTitleList_PageNo-1
		-- end
	-- else
		-- if ( isTitleList_PageNo >= 3 ) then
			-- isTitleList_PageNo = 0
		-- else
			-- isTitleList_PageNo = isTitleList_PageNo+1
		-- end
	-- end

	-- self.Category_BTN[isTitleList_PageNo]:SetCheck( true )

	-- ToClient_SetCurrentTitleCategory( isTitleList_PageNo )
	-- TitleInfo_SetCategory( isTitleList_PageNo )
	-- self.CurrentCategoryCount = ToClient_GetCategoryTitleCount( isTitleList_PageNo )
	-- self:SetScroll()
	-- self:TitleUpdate( isTitleList_PageNo )
	-- -- self:updateCoolTime()
-- end
	
--칭호 관련
local titleTemplate = {
	_titleListBG			= UI.getChildControl( Panel_Window_CharInfo_TitleInfo, "Static_TitleList_TitleBG" ),
	_titleListTitle			= UI.getChildControl( Panel_Window_CharInfo_TitleInfo, "StaticText_TitleList_Title" ),
	_titleSetTitle			= UI.getChildControl( Panel_Window_CharInfo_TitleInfo, "Button_SetTitle" ),
}

function TitleInfo:Initialize()
	local titleStartY	= 75
	local titleGapY		= 35

	for titleIdx = 0, self.maxTitleShow - 1, 1 do
		local tempTitleUIPool 	= {}
		local CreateTitleListBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, self._titleRightListBG, 'Title_ListBG_' .. titleIdx )
		CopyBaseProperty( titleTemplate._titleListBG, CreateTitleListBG )
		CreateTitleListBG:SetPosX( 5 )
		CreateTitleListBG:SetPosY( titleStartY )
		CreateTitleListBG:SetShow( false )
		tempTitleUIPool._titleListBG = CreateTitleListBG

		local CreateTitleListTitle = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateTitleListBG, 'Title_ListTitle_' .. titleIdx )
		CopyBaseProperty( titleTemplate._titleListTitle, CreateTitleListTitle )
		CreateTitleListTitle:SetPosX( 20 )
		CreateTitleListTitle:SetPosY( 5 )
		CreateTitleListTitle:SetShow( false )
		tempTitleUIPool._titleListTitle = CreateTitleListTitle

		local CreateTitleSet = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, CreateTitleListBG, 'Title_ListTitleSet_' .. titleIdx )
		CopyBaseProperty( titleTemplate._titleSetTitle, CreateTitleSet )
		CreateTitleSet:SetPosX( 265 )
		CreateTitleSet:SetPosY( 5 )
		CreateTitleSet:SetShow( false )
		tempTitleUIPool._titleSetBTN = CreateTitleSet

		self.TitleUIPool[titleIdx] = tempTitleUIPool

		titleStartY				= titleStartY + titleGapY
		
		for key, value in pairs(tempTitleUIPool) do
			value:addInputEvent("Mouse_DownScroll", "TitleInfo_ListUpdate( true )")
			value:addInputEvent("Mouse_UpScroll", "TitleInfo_ListUpdate( false )")
		end
	end
end

function TitleInfo_ListUpdate( UpDown )
	local self				= TitleInfo
	local nowTitleInterval	= self.NowTitleInterval  -- 0
	local minTitleInterval	= self.MinTitleInterval  -- 0
	local maxTitleInterval	= self.CurrentCategoryCount - 13
	local categoryCurrent 	= self.CurrentCategoryCount

	if categoryCurrent < self.maxTitleShow then
		return
	end
	
	if ( true == UpDown ) then
		if ( nowTitleInterval < maxTitleInterval ) then
			self.titleListScroll:ControlButtonDown()
			nowTitleInterval 		= nowTitleInterval + 1
			self.NowTitleInterval 	= nowTitleInterval
			self:TitleUpdate( nowTitleInterval )
		else
			return
		end
	else
		if ( minTitleInterval < nowTitleInterval ) then
			self.titleListScroll:ControlButtonUp()
			nowTitleInterval 		= nowTitleInterval - 1
			self.NowTitleInterval 	= nowTitleInterval
			self:TitleUpdate( nowTitleInterval )
		else
			return
		end
	end
end

function TitleInfo:TitleUpdate( startIdx )
	local titleCountByAll		= ToClient_GetTotalTitleCount()					-- 처음 켜질 때에는 대상이 없기 때문에 실행되면 안됨.
	local titleTotalCount		= ToClient_GetTotalTitleBuffCount()
	self.txt_TotalReward_Value:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_TOTALREWARD_VALUE") ) -- "<칭호 보상이 존재하지 않습니다>" )		-- 버프 description 최초. - 인덱스가 없다.
	self.txt_PartDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self.txt_PartDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_PARTDESC") ) -- "<활성화 된 칭호를 선택하여 주세요>" )			-- 디스크립션
	
	if nil == titleCountByAll then
		return
	end
	self.MaxTitleInterval = titleCountByAll

	local gotTitleCountByAll	= ToClient_GetTotalAcquiredTitleCount()			-- 처음 켜질 때에는 대상이 없기 때문에 실행되면 안됨.
	if nil == gotTitleCountByAll then
		return
	end
	local totalPercent			= (gotTitleCountByAll / titleCountByAll) * 100

	-- 총 진행도
	self.totalProgress:SetProgressRate( totalPercent )
	self.totalProgressValue:SetText( string.format( "%.1f", totalPercent ) .. "%" )

	for index = 0, titleTotalCount-1 do
		local titleBuffWrapper = ToClient_GetTitleBuffWrapper( index )

		if nil ~= titleBuffWrapper then
			local buffDescription = titleBuffWrapper:getBuffDescription()		-- 총 진행도 버프 텍스트
			self.txt_TotalReward_Value:SetTextMode( UI_TM.eTextMode_AutoWrap )
			self.txt_TotalReward_Value:SetText( buffDescription )				-- 진행도 버프에 관련된 description 입력.
		end
	end
	
	-- 병과 진행도 및 버튼 클릭.
	for categoryIdx = 0, 3 do
		ToClient_GetCategoryTitleCount( categoryIdx )
		local titleCurrentCount			= ToClient_GetCategoryTitleCount( categoryIdx )
		local titleCurrentGetCount		= ToClient_GetAcquiredTitleCount( categoryIdx )

		local titleCurrentPercent = 0
		if 0 == titleCurrentGetCount then
			titleCurrentPercent = 0
		else
			titleCurrentPercent	= ( titleCurrentGetCount / titleCurrentCount ) * 100
		end

		if self.CurrentCategoryIdx == categoryIdx then
			self.Category_BTN[categoryIdx]:SetCheck( true )
			self.titleSubject_Btn[categoryIdx]:SetCheck( true )
		end

		if 0 == categoryIdx then
			self.title_ListAll				:SetText( titleCurrentGetCount )
			self.title_ListAllPercent		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LISTALL", "percent", string.format( "%.1f", titleCurrentPercent ) ) ) -- "- 세계형 : " .. string.format( "%d", titleCurrentPercent ) .. "%"
			self.title_ListAllProgress		:SetProgressRate( titleCurrentPercent )
		elseif 1 == categoryIdx then
			self.title_ListCombat			:SetText( titleCurrentGetCount )
			self.title_ListCombatPercent	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LISTCOMBAT", "percent", string.format( "%.1f", titleCurrentPercent ) ) ) -- "- 전투형 : " .. string.format( "%d", titleCurrentPercent ) .. "%"
			self.title_ListCombatProgress	:SetProgressRate( titleCurrentPercent )
		elseif 2 == categoryIdx then
			self.title_ListProduct			:SetText( titleCurrentGetCount )
			self.title_ListProductPercent	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LISTPRODUCT", "percent", string.format( "%.1f", titleCurrentPercent ) ) ) -- "- 생활형 : " .. string.format( "%d", titleCurrentPercent ) .. "%"
			self.title_ListProductProgress	:SetProgressRate( titleCurrentPercent )
		elseif 3 == categoryIdx then
			self.title_ListFish				:SetText( titleCurrentGetCount )
			self.title_ListFishPercent		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LISTFISH", "percent", string.format( "%.1f", titleCurrentPercent ) ) ) -- "- 낚시형 : " .. string.format( "%d", titleCurrentPercent ) .. "%"
			self.title_ListFishProgress		:SetProgressRate( titleCurrentPercent )
		end

	end
	
	------------------------------------------------------------------------------
	-- 리스트 시작
	------------------------------------------------------------------------------
	-- 초기화
	for idx = 0, 12 do
		local titleList = self.TitleUIPool[idx]
		for key, value in pairs (titleList) do
			value:SetShow( false )
		end
	end

	local slotLimitedIdx	= 0
	local lastCount			= self.CurrentCategoryCount
	if lastCount < 1 then
		return
	end

	if lastCount <= self.maxTitleShow then
		self.titleListScroll:SetShow( false )
	else
		self.titleListScroll:SetShow( true )
	end

	for titleIdx = startIdx, lastCount - 1 do
		local uiIdx	= titleIdx-startIdx
		local titleWrapper 		= ToClient_GetTitleStaticStatusWrapper( titleIdx )
		local titleSlot			= self.TitleUIPool[uiIdx]
		if titleSlot == nil then -- nil값이 마지막에 하나 들어와서 리턴.
			return
		end
		if ( nil == titleWrapper ) then
			titleSlot._titleListBG:SetShow( false )
		else
			titleSlot._titleListBG		:SetShow( true )
			-- titleSlot._titleListTitle	:SetShow( true )

			if (titleWrapper:isAcquired() == true) then
				titleSlot._titleListBG:SetIgnore( false )
				titleSlot._titleListBG	:SetText( titleWrapper:getName() )
				titleSlot._titleListBG	:addInputEvent( "Mouse_LUp", "HandleClick_ShowDescription(" .. self.CurrentCategoryIdx..","..titleIdx..")")
				titleSlot._titleSetBTN	:SetShow( true )
				titleSlot._titleSetBTN	:addInputEvent("Mouse_LUp", "HandleClick_TitleSet("..self.CurrentCategoryIdx..","..titleIdx..")")
				
				if ToClient_IsAppliedTitle(titleWrapper:getKey()) then
					titleSlot._titleSetBTN:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_RELEASE") ) -- "해 제")
				else
					titleSlot._titleSetBTN:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_APPLICATION") ) -- "적 용")
				end

			else
				titleSlot._titleListBG:SetIgnore( true )
				titleSlot._titleListBG:SetText( "<PAColor0xFF444444>" .. titleWrapper:getName() .. "<PAOldColor>" )
				titleSlot._titleSetBTN:SetShow( false )
			end
		end
		
		if 12 < uiIdx then
			return
		end
	end
	
end

function FromClient_TitleInfo_Update()
	local self = TitleInfo
	self:TitleUpdate( self.NowTitleInterval )
	self:updateCoolTime()
end

function TitleInfo:updateCoolTime()
	local coolTime = ToClient_GetUpdateTitleDelay()
	self.title_LastUpdateTime:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LASTUPDATETIME", "coolTime", coolTime ) ) -- "<PAColor0xFFffbd2e>" .. coolTime .. "<PAOldColor>초 뒤 적용 및 해지가 가능합니다.")
end

function TitleInfo_Open()
	ToClient_SetCurrentTitleCategory(0)
	TitleInfo_SetCategory(0)
	
	local self = TitleInfo
	self.CurrentCategoryCount = ToClient_GetCategoryTitleCount(0)
	self:SetScroll()
	self:TitleUpdate( 0 )
	self:updateCoolTime()
end

function TitleInfo:registEventHandler()
	self._titleRightListBG	:addInputEvent("Mouse_DownScroll",	"TitleInfo_ListUpdate( true )")
	self._titleRightListBG	:addInputEvent("Mouse_UpScroll",	"TitleInfo_ListUpdate( false )")
	self.titleListScroll	:addInputEvent("Mouse_LUp",			"HandleClick_TitleInfo()")
	self.titleListScrollBtn	:addInputEvent("Mouse_LUp",			"HandleClick_TitleInfo()")
	self.titleListScrollBtn	:addInputEvent("Mouse_LPress",		"HandleClick_TitleInfo()")

	for idx = 0, 3 do
		self.Category_BTN[idx]		:addInputEvent("Mouse_LUp",		"TitleInfo_SetCategory( " .. idx .. " )")
		self.titleSubject_Btn[idx]	:addInputEvent("Mouse_LUp",		"TitleInfo_SetCategory( " .. idx .. " )")
		
		self.Category_BTN[idx]		:addInputEvent("Mouse_On",		"HandleMouseEvent_CategoryDesc( " .. idx .. ", true )")
		self.Category_BTN[idx]		:addInputEvent("Mouse_Out",		"HandleMouseEvent_CategoryDesc( " .. idx .. ", false )")
	end
end

function HandleMouseEvent_CategoryDesc( descType, isOn )
	if ( descType == 0 ) and ( isOn == true ) then
		TitleInfo.txt_AllRoundDesc:SetAlpha( 0 )
		TitleInfo.txt_AllRoundDesc:SetFontAlpha( 0 )
		TitleInfo.txt_AllRoundDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, TitleInfo.txt_AllRoundDesc, 0.0, 0.15 )
		TitleInfo.txt_AllRoundDesc:SetShow( true )

	elseif ( descType == 1 ) and ( isOn == true ) then
		TitleInfo.txt_CombatDesc:SetAlpha( 0 )
		TitleInfo.txt_CombatDesc:SetFontAlpha( 0 )
		TitleInfo.txt_CombatDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, TitleInfo.txt_CombatDesc, 0.0, 0.15 )
		TitleInfo.txt_CombatDesc:SetShow( true )
		
	elseif ( descType == 2 ) and ( isOn == true ) then
		TitleInfo.txt_ProductDesc:SetAlpha( 0 )
		TitleInfo.txt_ProductDesc:SetFontAlpha( 0 )
		TitleInfo.txt_ProductDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, TitleInfo.txt_ProductDesc, 0.0, 0.15 )
		TitleInfo.txt_ProductDesc:SetShow( true )
		
	elseif ( descType == 3 ) and ( isOn == true ) then
		TitleInfo.txt_FishingDesc:SetAlpha( 0 )
		TitleInfo.txt_FishingDesc:SetFontAlpha( 0 )
		TitleInfo.txt_FishingDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 1, TitleInfo.txt_FishingDesc, 0.0, 0.15 )
		TitleInfo.txt_FishingDesc:SetShow( true )
	end
	
	if ( descType == 0 ) and ( isOn == false ) then
		TitleInfo.txt_AllRoundDesc:ResetVertexAni()
		local AniInfo = UIAni.AlphaAnimation( 0, TitleInfo.txt_AllRoundDesc, 0.0, 0.1 )
		AniInfo:SetHideAtEnd( true )
		
	elseif ( descType == 1 ) and ( isOn == false ) then
		TitleInfo.txt_CombatDesc:ResetVertexAni()
		local AniInfo1 = UIAni.AlphaAnimation( 0, TitleInfo.txt_CombatDesc, 0.0, 0.1 )
		AniInfo1:SetHideAtEnd( true )
		
	elseif ( descType == 2 ) and ( isOn == false ) then
		TitleInfo.txt_ProductDesc:ResetVertexAni()
		local AniInfo2 = UIAni.AlphaAnimation( 0, TitleInfo.txt_ProductDesc, 0.0, 0.1 )
		AniInfo2:SetHideAtEnd( true )
		
	elseif ( descType == 3 ) and ( isOn == false ) then
		TitleInfo.txt_FishingDesc:ResetVertexAni()
		local AniInfo3 = UIAni.AlphaAnimation( 0, TitleInfo.txt_FishingDesc, 0.0, 0.1 )
		AniInfo3:SetHideAtEnd( true )
	end
end

function TitleInfo_SetCategory( categoryIdx )
	local self = TitleInfo
	
	for idx = 0, 3 do
		self.Category_BTN[idx]:SetCheck( false )
		self.titleSubject_Btn[idx]:SetCheck( false )
		self.titleSubject_Btn[idx]:SetFontColor( 4291083966 )
	end
	
	ToClient_SetCurrentTitleCategory( categoryIdx )
	self.CurrentCategoryCount	= ToClient_GetCategoryTitleCount( categoryIdx )
	self.CurrentCategoryIdx		= categoryIdx

	self.Category_BTN[categoryIdx]:SetCheck( true )
	
	if ( categoryIdx == 0 ) then
		self.titleSubject_Btn[0]:SetFontColor( 4294959762 )
	elseif ( categoryIdx == 1 ) then
		self.titleSubject_Btn[1]:SetFontColor( 4294940310 )
	elseif ( categoryIdx == 2 ) then
		self.titleSubject_Btn[2]:SetFontColor( 4292935574 )
	elseif ( categoryIdx == 3 ) then
		self.titleSubject_Btn[3]:SetFontColor( 4288076287 )
	end
	
	-- if categoryIdx == 0 then
		-- self.btn_titleList_Subject			:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLELIST_SUBJECT_LISTALL") )
		-- self.titleList_Subject:ChangeTextureInfoName( "new_ui_common_forlua/window/gameoption/gameoption_00.dds" )
		-- local x1, y1, x2, y2 = setTextureUV_Func( self.titleList_Subject, 292, 200, 306, 214 )
		-- self.titleList_Subject:getBaseTexture():setUV(  x1, y1, x2, y2  )
		-- self.titleList_Subject:setRenderTexture(self.titleList_Subject:getBaseTexture())
	-- elseif categoryIdx == 1 then
		-- self.btn_titleList_Subject			:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLELIST_SUBJECT_COMBAT") )
		-- self.titleList_Subject:ChangeTextureInfoName( "new_ui_common_forlua/window/gameoption/gameoption_00.dds" )
		-- local x1, y1, x2, y2 = setTextureUV_Func( self.titleList_Subject, 309, 200, 323, 214 )
		-- self.titleList_Subject:getBaseTexture():setUV(  x1, y1, x2, y2  )
		-- self.titleList_Subject:setRenderTexture(self.titleList_Subject:getBaseTexture())
	-- elseif categoryIdx == 2 then
		-- self.btn_titleList_Subject			:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLELIST_SUBJECT_PRODUCT") )
		-- self.titleList_Subject:ChangeTextureInfoName( "new_ui_common_forlua/window/gameoption/gameoption_00.dds" )
		-- local x1, y1, x2, y2 = setTextureUV_Func( self.titleList_Subject, 326, 200, 340, 214 )
		-- self.titleList_Subject:getBaseTexture():setUV(  x1, y1, x2, y2  )
		-- self.titleList_Subject:setRenderTexture(self.titleList_Subject:getBaseTexture())
	-- elseif categoryIdx == 3 then
		-- self.btn_titleList_Subject			:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLELIST_SUBJECT_FISH") )
		-- self.titleList_Subject:ChangeTextureInfoName( "new_ui_common_forlua/window/gameoption/gameoption_00.dds" )
		-- local x1, y1, x2, y2 = setTextureUV_Func( self.titleList_Subject, 258, 200, 272, 214 )
		-- self.titleList_Subject:getBaseTexture():setUV(  x1, y1, x2, y2  )
		-- self.titleList_Subject:setRenderTexture(self.titleList_Subject:getBaseTexture())
	-- end

	self:SetScroll()
	self.NowTitleInterval = 0
	self:TitleUpdate( self.NowTitleInterval )
	self:updateCoolTime()
end

function TitleInfo:SetScroll()
	self.titleListScrollBtn:ComputePos()
	self.titleListScroll:SetInterval( self.CurrentCategoryCount - self.maxTitleShow )

	local titleCtrBtn = (self.titleListScrollBtn:GetSizeY() / self.maxTitleShow) * 3
	if titleCtrBtn < 100 then
		titleCtrBtn = 100
	end
	self.titleListScrollBtn:SetSize(self.titleListScrollBtn:GetSizeX(), titleCtrBtn )
	self.titleListScroll:SetControlTop()
end

function HandleClick_TitleInfo()
	local self					= TitleInfo
	local maxTitleInterval		= self.CurrentCategoryCount - self.maxTitleShow
	local posByTitleInterval	= 1 / maxTitleInterval
	local currentTitleInterval	= math.floor( (self.titleListScroll:GetControlPos() / posByTitleInterval) + 0.5 )
	
	self.NowTitleInterval		= currentTitleInterval
	
	self:TitleUpdate( self.NowTitleInterval )
end

function TitleInfo:registMessageHandler()
	registerEvent("FromClient_TitleInfo_UpdateText", "FromClient_TitleInfo_Update")
end


-- BG 클릭_타이틀 설명 용
function HandleClick_ShowDescription( categoryIdx, titleIdx )
	ToClient_SetCurrentTitleCategory( categoryIdx )
	local titleWrapper = ToClient_GetTitleStaticStatusWrapper( titleIdx )
	
	if ( titleWrapper:isAcquired() == true ) then
		TitleInfo.txt_PartDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		TitleInfo.txt_PartDesc:SetText( titleWrapper:getDescription() )
			-- _PA_LOG("LUA", "헐")
	else
		TitleInfo.txt_PartDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		TitleInfo.txt_PartDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_PARTDESC") ) -- "<활성화 된 칭호를 선택하여 주세요>" )
			-- _PA_LOG("LUA", "헐퀴")
	end
end

-- 실제 칭호가 적용되는 곳
function HandleClick_TitleSet( categoryIdx, titleIdx )
	ToClient_SetCurrentTitleCategory( categoryIdx )
	local titleWrapper = ToClient_GetTitleStaticStatusWrapper( titleIdx )
	TitleInfo.txt_PartDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	TitleInfo.txt_PartDesc:SetText( titleWrapper:getDescription() )

	ToClient_TitleSetRequest( categoryIdx, titleIdx ) 
end

TitleInfo:Initialize()
TitleInfo:registEventHandler()
TitleInfo:registMessageHandler()


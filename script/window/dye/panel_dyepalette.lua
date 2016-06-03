local UI_TM			= CppEnums.TextMode
local UI_color		= Defines.Color
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_DyePalette:SetShow( false )
Panel_DyePalette:ActiveMouseEventEffect(true)
Panel_DyePalette:setGlassBackground(true)

Panel_DyePalette:RegisterShowEventFunc( true, 'DyePalette_ShowAni()' )
Panel_DyePalette:RegisterShowEventFunc( false, 'DyePalette_HideAni()' )

local DyePalette = {
	-- { 컨트롤
		ui	= {
			_btn_Close		= UI.getChildControl( Panel_DyePalette, "Button_Win_Close"),
			_btn_Help		= UI.getChildControl( Panel_DyePalette, "Button_Help"),
			_btn_Confirm	= UI.getChildControl( Panel_DyePalette, "Button_Confirm"),
			_btn_TabAll		= UI.getChildControl( Panel_DyePalette, "RadioButton_Tab_ALL"),
			_btn_TabMy		= UI.getChildControl( Panel_DyePalette, "RadioButton_Tab_My"),
			_scroll			= UI.getChildControl( Panel_DyePalette, "Scroll_Ampule"),
			_panelBG		= UI.getChildControl( Panel_DyePalette, "Static_BG"),

			_btn_Material	= {
				[0]	= UI.getChildControl( Panel_DyePalette, "RadioButton_Material_0"),
				[1]	= UI.getChildControl( Panel_DyePalette, "RadioButton_Material_1"),
				[2]	= UI.getChildControl( Panel_DyePalette, "RadioButton_Material_2"),
				[3]	= UI.getChildControl( Panel_DyePalette, "RadioButton_Material_3"),
				[4]	= UI.getChildControl( Panel_DyePalette, "RadioButton_Material_4"),
				[5]	= UI.getChildControl( Panel_DyePalette, "RadioButton_Material_5"),
				[6]	= UI.getChildControl( Panel_DyePalette, "RadioButton_Material_6"),
				[7]	= UI.getChildControl( Panel_DyePalette, "RadioButton_Material_7"),
			},

			_selectAmpueColor	= UI.getChildControl( Panel_DyePalette, "Static_SelectAmplueColorPart"),
			_selectAmpueName	= UI.getChildControl( Panel_DyePalette, "StaticText_SelectAmpuleName"),
			_selectAmpueCount	= UI.getChildControl( Panel_DyePalette, "Edit_SelectAmpuleCount"),
		},
	-- }

	-- { UI 배열
		slot	= {},
	-- }

	-- { 설정 변수
		config	= {
			maxSlotColsCount 		= 10,
			maxSlotRowsCount 		= 7,
			startPosX				= 5,
			startPosY				= 5,
			cellSpan				= 2,

			selectedCategoryIdx		= 0,
			isShowAll				= true,
			selectedColorIdx		= 0,
			selectedAmplurCount_s64	= 0,

			scrollStartIdx			= 0,
			colorTotalRows			= 0,
		},
	-- }
}
DyePalette.ui._scrollBtn = UI.getChildControl( DyePalette.ui._scroll, "Scroll_CtrlButton")

-- { 내부 로컬 함수
	function DyePalette:Initialize()											-- 초기화
		-- 슬롯 생성
		for slotRowsIdx = 0, self.config.maxSlotRowsCount -1 do
			self.slot[slotRowsIdx] = {}
			for slotColsIdx = 0, self.config.maxSlotColsCount -1 do
				self.slot[slotRowsIdx][slotColsIdx] = {}
				local slot = self.slot[slotRowsIdx][slotColsIdx]
				slot.bg		= UI.createAndCopyBasePropertyControl( Panel_DyePalette, "Static_SlotBG",		self.ui._panelBG,	"DyePaletteSlotBG_"		.. slotColsIdx .. "_" .. slotRowsIdx )
				slot.color	= UI.createAndCopyBasePropertyControl( Panel_DyePalette, "Static_ColorPart",	slot.bg	,			"DyePaletteSlot_"		.. slotColsIdx .. "_" .. slotRowsIdx )
				slot.count	= UI.createAndCopyBasePropertyControl( Panel_DyePalette, "StaticText_Count",	slot.bg	,			"DyePaletteSlot_Count_"	.. slotColsIdx .. "_" .. slotRowsIdx )
				slot.btn	= UI.createAndCopyBasePropertyControl( Panel_DyePalette, "RadioButton_Slot",	slot.bg	,			"DyePaletteSlot_ColorBtn_"	.. slotColsIdx .. "_" .. slotRowsIdx )

				local slotPosX = ((slot.bg:GetSizeX()+self.config.cellSpan) * slotColsIdx) + self.config.startPosX
				local slotPosY = ((slot.bg:GetSizeY()+self.config.cellSpan) * slotRowsIdx) + self.config.startPosY
				slot.color	:SetAlphaIgnore( true )

				slot.bg		:SetPosX( slotPosX )
				slot.bg		:SetPosY( slotPosY )
				slot.color	:SetPosX( 0 )
				slot.color	:SetPosY( 0 )
				slot.count	:SetPosX( 0 )
				slot.count	:SetPosY( 25 )
				slot.btn	:SetPosX( 0 )
				slot.btn	:SetPosY( 0 )

				slot.btn	:addInputEvent( "Mouse_UpScroll", 		"Scroll_DyePalette( true )")
				slot.btn	:addInputEvent( "Mouse_DownScroll",		"Scroll_DyePalette( false )")
			end
		end

		self.ui._selectAmpueColor:SetAlphaIgnore( true )
	end

	function DyePalette:ChangeTexture( isFill, rowsIdx, colsIdx )				-- 색상 텍스처 변경
		local slot	= self.slot[rowsIdx][colsIdx].color
		local x1, y1, x2, y2 = nil, nil, nil, nil
		if true == isFill then	-- 색이 있다.
			x1, y1, x2, y2 = 55, 162, 99, 206	-- 흰색
		else
			x1, y1, x2, y2 = 55, 209, 99, 253	-- 격자
		end

		slot:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Buttons_02.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( slot, x1, y1, x2, y2 )
		slot:getBaseTexture():setUV( x1, y1, x2, y2 )
		slot:setRenderTexture(slot:getBaseTexture())
	end	

	function DyePalette:Update()												-- 업데이트
		local category						= self.config.selectedCategoryIdx
		local isShowAll						= self.config.isShowAll

		self.ui._btn_TabAll		:SetCheck( isShowAll )
		self.ui._btn_TabMy		:SetCheck( not isShowAll )
		for idx = 0, 7 do		-- 재질 타입 버튼 처리.
			if idx == category then
				self.ui._btn_Material[idx]:SetCheck( true )
			else
				self.ui._btn_Material[idx]:SetCheck( false )
			end
		end

		-- { 초기화
			for slotRowsIdx = 0, self.config.maxSlotRowsCount -1 do
				for slotColsIdx = 0, self.config.maxSlotColsCount -1 do
					local slot			= self.slot[slotRowsIdx][slotColsIdx]
					local clearColor	= 16777215

					self:ChangeTexture( false, slotRowsIdx, slotColsIdx )	-- 텍스쳐 변경
					slot.color	:SetColor( clearColor )
					slot.count	:SetText( "0" )
					slot.count	:SetShow( false )
					slot.btn	:SetCheck( false )

					slot.btn	:addInputEvent( "Mouse_LUp",	"")
					slot.btn	:addInputEvent( "Mouse_On",		"")
					slot.btn	:addInputEvent( "Mouse_Out",	"")
					slot.btn	:setTooltipEventRegistFunc( "" )
				end
			end
		-- }

		local DyeingPaletteCategoryInfo		= ToClient_requestGetPaletteCategoryInfo( category, isShowAll )
		if nil ~= DyeingPaletteCategoryInfo then
			local colorCount					= DyeingPaletteCategoryInfo:getListSize()
			self.config.colorTotalRows			= math.ceil((colorCount / self.config.maxSlotColsCount))
			-- { 염색약 업데이트
				local uiIndex = 0
				for slotRowsIdx = 0, self.config.maxSlotRowsCount -1 do
					for slotColsIdx = 0, self.config.maxSlotColsCount -1 do
						local slot		= self.slot[slotRowsIdx][slotColsIdx]
						local dataIdx	= uiIndex + ( (self.config.scrollStartIdx * self.config.maxSlotColsCount) )
						if dataIdx < colorCount then
							local colorValue		= DyeingPaletteCategoryInfo:getColor( dataIdx )
							local itemEnchantKey	= DyeingPaletteCategoryInfo:getItemEnchantKey( dataIdx )

							local isDyeUI			= false
							local ampuleCount		= DyeingPaletteCategoryInfo:getCount( dataIdx, isDyeUI )
							slot.count:SetText( tostring(ampuleCount) )
							self:ChangeTexture( true, slotRowsIdx, slotColsIdx )	-- 텍스쳐 변경
							slot.color:SetColor( colorValue  )
							slot.count:SetShow( true )

							if dataIdx == self.config.selectedColorIdx then	-- 눌린 것을 눌린 처리.
								slot.btn	:SetCheck( true )
							end

							slot.btn	:addInputEvent( "Mouse_LUp",	"HandleClicked_DyePalette_SelectColor( " .. dataIdx .. " )")
							slot.btn	:addInputEvent( "Mouse_On",		"HandleOnOut_DyePalette_Color( true, " .. itemEnchantKey .. ", " .. slotRowsIdx .. ", " .. slotColsIdx .. " )")
							slot.btn	:addInputEvent( "Mouse_Out",	"HandleOnOut_DyePalette_Color( false, " .. itemEnchantKey .. ", " .. slotRowsIdx .. ", " .. slotColsIdx .. " )")
							slot.btn	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Color( true, " .. itemEnchantKey .. ", " .. slotRowsIdx .. ", " .. slotColsIdx .. " )" )
							uiIndex = uiIndex + 1
						end
					end
				end
			-- }

			-- { 선택된 앰플
				local setSelectColor_nil = function()
					self.ui._selectAmpueColor		:SetColor( 16777215 )
					self.ui._selectAmpueName		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_PLZ_SELECT_COLOR") ) -- "꺼내려는 염색약을 선택해주세요."
					self.ui._selectAmpueCount		:SetEditText( "0" )
				end
				
				local selectedColorIdx				= self.config.selectedColorIdx
				if nil ~= selectedColorIdx then
					local isDyeUI						= false
					self.config.selectedAmplurCount_s64	= DyeingPaletteCategoryInfo:getCount( selectedColorIdx, isDyeUI )
					local colorValue					= DyeingPaletteCategoryInfo:getColor( selectedColorIdx )
					local itemEnchantKey				= DyeingPaletteCategoryInfo:getItemEnchantKey( selectedColorIdx )
					local itemEnchantSSW				= getItemEnchantStaticStatus( ItemEnchantKey( itemEnchantKey ) )
					if nil ~= itemEnchantSSW then
						local itemEnchantSS 				= itemEnchantSSW:get()
						local itemName						= getItemName( itemEnchantSS )

						self.ui._selectAmpueColor		:SetColor( colorValue )
						self.ui._selectAmpueName		:SetText( itemName )
						self.ui._selectAmpueCount		:SetEditText( tostring(self.config.selectedAmplurCount_s64) )
					else
						setSelectColor_nil()
					end
				else
					setSelectColor_nil()
				end
			-- }

			UIScroll.SetButtonSize( self.ui._scroll, self.config.maxSlotRowsCount, self.config.colorTotalRows)
		end
	end

	function DyePalette:Open()
		Inventory_SetFunctor( DyePalette_SetInvenFilter, DyePalette_SetInvenRclick, nil, nil )
		Panel_DyePalette:SetShow( true, true )
		Panel_DyePalette:SetPosX( Panel_Window_Inventory:GetPosX() - Panel_DyePalette:GetSizeX() )
		Panel_DyePalette:SetPosY( Panel_Window_Inventory:GetPosY() )

		-- { 초기화
			self.config.isShowAll				= true
			self.config.selectedCategoryIdx		= 0
			self.config.selectedColorIdx		= 0
		-- }
		
		self:Update()
		self.ui._scroll:SetControlPos( 0 )
	end

	function DyePalette:Close()
		Inventory_SetFunctor( nil, nil, nil, nil )
		Panel_DyePalette:SetShow( false, false )

		if Panel_Window_Inventory:GetShow() and not Panel_Equipment:GetShow() then
			Panel_Equipment:SetShow( true )
		end
	end
-- }

-- { 내부용 전역 함수
	function DyePalette_ShowAni()
		local aniInfo1 = Panel_DyePalette:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		aniInfo1:SetStartScale(0.5)
		aniInfo1:SetEndScale(1.12)
		aniInfo1.AxisX = Panel_DyePalette:GetSizeX() / 2
		aniInfo1.AxisY = Panel_DyePalette:GetSizeY() / 2
		aniInfo1.ScaleType = 2
		aniInfo1.IsChangeChild = true
		
		local aniInfo2 = Panel_DyePalette:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		aniInfo2:SetStartScale(1.12)
		aniInfo2:SetEndScale(1.0)
		aniInfo2.AxisX = Panel_DyePalette:GetSizeX() / 2
		aniInfo2.AxisY = Panel_DyePalette:GetSizeY() / 2
		aniInfo2.ScaleType = 2
		aniInfo2.IsChangeChild = true
	end
	function DyePalette_HideAni()
		local aniInfo1 = Panel_DyePalette:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
		aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
		aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
		aniInfo1:SetStartIntensity( 3.0 )
		aniInfo1:SetEndIntensity( 1.0 )
		aniInfo1.IsChangeChild = true
		aniInfo1:SetHideAtEnd(true)
		aniInfo1:SetDisableWhileAni(true)
	end
	function DyePalette_SetInvenFilter( slotNo, itemWrapper, count_s64, inventoryType )
		if nil ~= itemWrapper then
			local isDyeAble = itemWrapper:getStaticStatus():get():isDyeingStaticStatus()
			return not isDyeAble
		else
			return true
		end
		-- return false
	end
	function DyePalette_SetInvenRclick( slotNo, itemWrapper, count_s64, inventoryType )
		local doInsertPalette = function()
			ToClient_requestCreateDyeingPaletteFromItem(inventoryType, slotNo, count_s64)
		end

		local ampuleName		= itemWrapper:getStaticStatus():getName()
		local messageTitle		= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")	-- "알 림"
		local messageBoxMemo	= PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PALETTE_SURE_THIS_AMPLUE", "itemName", ampuleName )	-- ampuleName .. "\n이 염색약을 팔레트에 담으시겠습니까?"
		local messageBoxData	= { title = messageTitle, content = messageBoxMemo, functionYes = doInsertPalette, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end

	function Scroll_DyePalette( isScrollUp )
		DyePalette.config.scrollStartIdx = UIScroll.ScrollEvent( DyePalette.ui._scroll, isScrollUp, DyePalette.config.maxSlotRowsCount, DyePalette.config.colorTotalRows, DyePalette.config.scrollStartIdx, 1 )
		DyePalette:Update()
	end
-- }


-- { 클릭 전역 함수
	function HandleClicked_DyePalette_SelectedCategory( categoryIdx )	-- 재질 선택
		DyePalette.config.selectedCategoryIdx	= categoryIdx
		DyePalette.config.selectedColorIdx		= 0
		DyePalette.config.scrollStartIdx		= 0
		DyePalette.config.selectedColorIdx		= nil
		DyePalette.ui._scroll:SetControlPos( 0 )

		DyePalette:Update()
	end

	function HandleClicked_DyePalette_SelectedType( isShowAll )			-- 소유/비소유 선택
		DyePalette.config.isShowAll				= isShowAll
		DyePalette.config.selectedCategoryIdx	= 0
		DyePalette.config.selectedColorIdx		= 0
		DyePalette.config.scrollStartIdx		= 0
		DyePalette.config.selectedColorIdx		= nil
		DyePalette.ui._scroll:SetControlPos( 0 )

		DyePalette:Update()
	end

	function HandleClicked_DyePalette_SelectColor( dataIdx )			-- 색상 선택
		DyePalette.config.selectedColorIdx			= dataIdx
		toInt64(0,1)

		local category						= DyePalette.config.selectedCategoryIdx
		local showType						= DyePalette.config.isShowAll
		local colorIdx						= DyePalette.config.selectedColorIdx
		local DyeingPaletteCategoryInfo		= ToClient_requestGetPaletteCategoryInfo( category, showType )
		if nil ~= DyeingPaletteCategoryInfo then
			local isDyeUI					= false
			DyePalette.config.selectedAmplurCount_s64	= DyeingPaletteCategoryInfo:getCount( colorIdx, isDyeUI )

			local colorValue				= DyeingPaletteCategoryInfo:getColor( colorIdx )
			local itemEnchantKey			= DyeingPaletteCategoryInfo:getItemEnchantKey( colorIdx )
			local itemEnchantSSW			= getItemEnchantStaticStatus( ItemEnchantKey( itemEnchantKey ) )
			local itemEnchantSS 			= itemEnchantSSW:get()
			local itemName					= getItemName( itemEnchantSS )

			DyePalette.ui._selectAmpueColor		:SetColor( colorValue )
			DyePalette.ui._selectAmpueName		:SetText( itemName )
			DyePalette.ui._selectAmpueCount		:SetEditText( tostring(DyePalette.config.selectedAmplurCount_s64) )
		end
	end

	function HandleOnOut_DyePalette_Color( isShow, itemEnchantKey, rowsIdx, colsIdx )	-- 색상 툴팁
		if true == isShow then
			local uiControl				= DyePalette.slot[rowsIdx][colsIdx].btn
			local itemEnchantSSW		= getItemEnchantStaticStatus( ItemEnchantKey( itemEnchantKey ) )
			local itemEnchantSS 		= itemEnchantSSW:get()
			local itemName				= getItemName( itemEnchantSS )
			local desc 					= nil
			registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
			TooltipSimple_Show( uiControl, itemName, desc )
		else
			TooltipSimple_Hide()
		end
	end

	function HandleClicked_DyePalette_SelectAmplueCount()		-- 꺼내기 버튼
		local category					= DyePalette.config.selectedCategoryIdx
		local isShowAll					= DyePalette.config.isShowAll
		local colorIdx					= DyePalette.config.selectedColorIdx
		local DyeingPaletteCategoryInfo	= ToClient_requestGetPaletteCategoryInfo( category, isShowAll )
		if nil ~= DyeingPaletteCategoryInfo then
			local isDyeUI			= false
			local ampuleCount		= DyeingPaletteCategoryInfo:getCount( colorIdx, isDyeUI )
			Panel_NumberPad_Show( true, ampuleCount, ampuleCount, DyePalette_SetSelectAmplueCount )
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_WRONG_COLORINFO") )	-- "염색약 정보가 올바르지 않습니다."
			return
		end
	end
	function DyePalette_SetSelectAmplueCount( count_s64 )		-- 선택 색상 하단 카운트 적용
		DyePalette.config.selectedAmplurCount_s64 = count_s64
		DyePalette.ui._selectAmpueCount:SetEditText( tostring( DyePalette.config.selectedAmplurCount_s64 ) )
	end

	function HandleClicked_DyePalette_Scroll()
		DyePalette.config.scrollStartIdx	= math.ceil( (DyePalette.config.colorTotalRows-DyePalette.config.maxSlotRowsCount) * DyePalette.ui._scroll:GetControlPos() )
		DyePalette:Update()
	end

	function HandleOnOut_DyePalette_Palette_BtnTooltip( isOn, btnType )
		local control	= nil
		local name		= ""
		local desc		= nil

		if true == isOn then
			if 0 == btnType then
				control = DyePalette.ui._btn_TabAll
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_ALL")
			elseif 1 == btnType then
				control = DyePalette.ui._btn_TabMy
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MY")
			elseif 2 == btnType then
				control = DyePalette.ui._btn_Material[0]
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_0")
			elseif 3 == btnType then
				control = DyePalette.ui._btn_Material[1]
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_1")
			elseif 4 == btnType then
				control = DyePalette.ui._btn_Material[2]
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_2")
			elseif 5 == btnType then
				control = DyePalette.ui._btn_Material[3]
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_3")
			elseif 6 == btnType then
				control = DyePalette.ui._btn_Material[4]
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_4")
			elseif 7 == btnType then
				control = DyePalette.ui._btn_Material[5]
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_5")
			elseif 8 == btnType then
				control = DyePalette.ui._btn_Material[6]
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_6")
			elseif 9 == btnType then
				control = DyePalette.ui._btn_Material[7]
				name	= PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_7")
			end
			registTooltipControl(control, Panel_Tooltip_SimpleText)
			TooltipSimple_Show( control, name, desc )
		else
			TooltipSimple_Hide()
		end
	end

	function HandleClicked_DyePalette_Close()
		DyePalette:Close()
	end

	function HandleClicked_DyePalette_Help()
		-- body
	end

	function HandleClicked_DyePalette_Confirm()
		local isShowAll			= DyePalette.config.isShowAll
		local categoryIndex 	= DyePalette.config.selectedCategoryIdx
		local dataIndex			= DyePalette.config.selectedColorIdx
		local itemCount			= DyePalette.config.selectedAmplurCount_s64

		local DyeingPaletteCategoryInfo	= ToClient_requestGetPaletteCategoryInfo( categoryIndex, isShowAll )
		local itemEnchantKey			= DyeingPaletteCategoryInfo:getItemEnchantKey( dataIndex )
		local itemEnchantSSW			= getItemEnchantStaticStatus( ItemEnchantKey( itemEnchantKey ) )
		local itemEnchantSS 			= itemEnchantSSW:get()
		local itemName					= getItemName( itemEnchantSS )

		local doExportPalette = function()
			ToClient_requestChangeDyeingPaletteToItem(categoryIndex, dataIndex, itemCount, isShowAll)
		end
		local messageTitle		= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")	-- "알 림"
		local messageBoxMemo	= PAGetStringParam2(Defines.StringSheet_GAME, "LUA_PALETTE_SURE_GET_THIS_AMPLUE", "itemName", itemName, "itemCount", tostring(itemCount) )	-- itemName .. "\n이 염색약 " .. tostring(itemCount) .. "개를 팔레트에서 꺼내시겠습니까?"
		local messageBoxData	= { title = messageTitle, content = messageBoxMemo, functionYes = doExportPalette, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
-- }

-- { 외부 전역 함수
	function FGlobal_DyePalette_Open()
		if Panel_AlchemyFigureHead:GetShow() then
			FGlobal_AlchemyFigureHead_Close()
		end

		if Panel_AlchemyStone:GetShow() then
			FGlobal_AlchemyStone_Close()
		end	
		
		if Panel_Manufacture:GetShow() then
			Manufacture_Close()
		end

		if Panel_Equipment:GetShow() then
			Panel_Equipment:SetShow( false )
		end

		DyePalette:Open()
	end

	function FGlobal_DyePalette_Close()
		DyePalette:Close()
	end
-- }

-- { 클라이언트 이벤트
	function FromClient_UpdateDyeingPalette()
		if Panel_Dye_New:GetShow() then
			
		else
			DyePalette:Update()
		end
	end
-- }


function DyePalette:registEventHandler()
	local control = self.ui
	control._btn_Close			:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_Close()")
	control._btn_Help			:addInputEvent( "Mouse_LUp",			"Panel_WebHelper_ShowToggle( \"Dye\" )" )
	control._btn_Help			:addInputEvent( "Mouse_On",				"HelpMessageQuestion_Show( \"Dye\", \"true\")" )
	control._btn_Help			:addInputEvent( "Mouse_Out",			"HelpMessageQuestion_Show( \"Dye\", \"false\")" )
	control._btn_Confirm		:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_Confirm()")

	control._btn_TabAll			:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedType( true )")
	control._btn_TabMy			:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedType( false )")
	control._btn_Material[0]	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedCategory( " .. 0 .. " )")
	control._btn_Material[1]	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedCategory( " .. 1 .. " )")
	control._btn_Material[2]	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedCategory( " .. 2 .. " )")
	control._btn_Material[3]	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedCategory( " .. 3 .. " )")
	control._btn_Material[4]	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedCategory( " .. 4 .. " )")
	control._btn_Material[5]	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedCategory( " .. 5 .. " )")
	control._btn_Material[6]	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedCategory( " .. 6 .. " )")
	control._btn_Material[7]	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectedCategory( " .. 7 .. " )")

	control._btn_TabAll			:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 0 .. " )")
	control._btn_TabAll			:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 0 .. " )")
	control._btn_TabAll			:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 0 .. " )")

	control._btn_TabMy			:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 1 .. " )")
	control._btn_TabMy			:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 1 .. " )")
	control._btn_TabMy			:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 1 .. " )")

	control._btn_Material[0]	:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 2 .. " )")
	control._btn_Material[0]	:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 2 .. " )")
	control._btn_Material[0]	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 2 .. " )")

	control._btn_Material[1]	:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 3 .. " )")
	control._btn_Material[1]	:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 3 .. " )")
	control._btn_Material[1]	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 3 .. " )")

	control._btn_Material[2]	:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 4 .. " )")
	control._btn_Material[2]	:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 4 .. " )")
	control._btn_Material[2]	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 4 .. " )")

	control._btn_Material[3]	:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 5 .. " )")
	control._btn_Material[3]	:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 5 .. " )")
	control._btn_Material[3]	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 5 .. " )")

	control._btn_Material[4]	:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 6 .. " )")
	control._btn_Material[4]	:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 6 .. " )")
	control._btn_Material[4]	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 6 .. " )")

	control._btn_Material[5]	:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 7 .. " )")
	control._btn_Material[5]	:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 7 .. " )")
	control._btn_Material[5]	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 7 .. " )")

	control._btn_Material[6]	:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 8 .. " )")
	control._btn_Material[6]	:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 8 .. " )")
	control._btn_Material[6]	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 8 .. " )")

	control._btn_Material[7]	:addInputEvent( "Mouse_On",				"HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 9 .. " )")
	control._btn_Material[7]	:addInputEvent( "Mouse_Out",			"HandleOnOut_DyePalette_Palette_BtnTooltip( false, " .. 9 .. " )")
	control._btn_Material[7]	:setTooltipEventRegistFunc( "HandleOnOut_DyePalette_Palette_BtnTooltip( true, " .. 9 .. " )")


	control._selectAmpueCount	:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_SelectAmplueCount()")

	control._scroll				:addInputEvent( "Mouse_LUp",			"HandleClicked_DyePalette_Scroll()")
	control._scrollBtn			:addInputEvent( "Mouse_LPress",			"HandleClicked_DyePalette_Scroll()")

	control._panelBG			:addInputEvent( "Mouse_UpScroll", 		"Scroll_DyePalette( true )")
	control._panelBG			:addInputEvent( "Mouse_DownScroll",		"Scroll_DyePalette( false )")
end
function DyePalette:registMessageHandler()
	registerEvent("FromClient_UpdateDyeingPalette",		"FromClient_UpdateDyeingPalette")	-- 열 때, 장비를 리턴한다.
end

DyePalette:Initialize()
DyePalette:registEventHandler()
DyePalette:registMessageHandler()
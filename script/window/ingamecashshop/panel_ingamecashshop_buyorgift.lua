local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_PLT		= CppEnums.CashPurchaseLimitType
local UI_CCC		= CppEnums.CashProductCategory

Panel_IngameCashShop_BuyOrGift:SetShow( false )
Panel_IngameCashShop_BuyOrGift:setGlassBackground( true )
Panel_IngameCashShop_BuyOrGift:ActiveMouseEventEffect( true )

local inGameShopBuy	= {
	_config	=
	{
		_slot	=
		{
			_startX		= 17,
			_startY		= 130,
			_gapX		= 36,
		},
		
		_buy	=
		{
			_startX		= 17,
			_startY		= 130,
			_gapX		= 36,
		},
		
		_sizeGift	= 35,
		_sizeBG		= 30,
		_sizePanel	= 85,

		_giftTopListMaxCount	= 5,
		_giftTopListCount		= 0,
		_giftTopListStart		= 0,

		_giftBotListMaxCount	= 5,
		_giftBotListCount		= 0,
		_giftBotListStart		= 0,
	},

	giftTopList		= {},
	giftBotList		= {},
	giftUserList	= {},

	_panelTitle				= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "StaticText_Title"		),
	_static_LeftBG			= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Static_LeftBG"			),
	-- 패키지 아이템
	_static_ItemIconBG		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Static_GoodsSlotBG"		),
	_static_ItemIcon		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Static_GoodsSlot"		),
	_static_ItemName		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "StaticText_GoodsName"	),
	_static_PearlIcon		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Static_PearlIcon"		),
	
	_static_Gift			= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "StaticText_GiftTo"		),
	_edit_Gift				= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Edit_GiftTo"				),

	_static_GiftListBG		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Static_GiftListBG"		),
	_static_GiftListTopBG	= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Static_GiftListTopBG"	),
	_static_GiftListBotBG	= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Static_GiftListBotBG"	),
	_static_GiftList_NonUser= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "StaticText_NonUser"		),

	_scroll_GiftTopList		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Scroll_GiftTopList"		),
	_scroll_GiftBotList		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Scroll_GiftBotList"		),

	_buttonFriendList		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Button_Friend"			),
	_buttonGuildList		= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Button_Guild"			),
	_button_AddUser			= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Button_AddUser"			),
	_button_Close			= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Button_Win_Close"		),
	_button_Confirm			= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Button_Confirm"			),
	_button_Cancle			= UI.getChildControl( Panel_IngameCashShop_BuyOrGift, "Button_Cancle"			),

	_slotCount				= 20,
	_slots					= Array.new(),
	_needMoneyType			= -1,

	_productNoRaw			= nil,
	_isGift					= false,
	_byCart					= false,
}

local contry = {
	kr = 0,
	jp = 1,
	ru = 2,
	cn = 3,
}

local cashIconType = {
	cash	= 0,
	pearl	= 1,
	mileage	= 2,
	silver	= 3,
}

local cashIconTexture = {
	[0] =	{310,	479,	329,	498},	-- 한국
			{267,	479,	286,	498},	-- 일본
			{310,	479,	329,	498},	-- 러시아
			{310,	479,	329,	498},	-- 중국
}

local giftSendType = {
	userNo			= 0,
	characterName	= 1,
}

local eCountryType		= CppEnums.CountryType
local gameServiceType	= getGameServiceType()
local isKorea			= (eCountryType.NONE == gameServiceType) or (eCountryType.DEV == gameServiceType) or (eCountryType.KOR_ALPHA == gameServiceType) or (eCountryType.KOR_REAL == gameServiceType) or (eCountryType.KOR_TEST == gameServiceType)
local isNaver			= ( CppEnums.MembershipType.naver == getMembershipType() )


function inGameShopBuy:init()
	local	slotConfig		= self._config._slot
	
	for	ii = 0, self._slotCount-1	do
		local	slot		= {}
		slot.iconBG	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Static_SubItemSlotBG",		Panel_IngameCashShop_BuyOrGift,	"InGameShopBuy_Sub_"		.. ii )
		slot.icon	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Static_SubItemSlot",		slot.iconBG,					"InGameShopBuy_Sub_Icon_"	.. ii )
		-- slot.name	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "StaticText_SubItemName",	slot.iconBG,					"InGameShopBuy_Sub_Name_"	.. ii )
		
		-- 좌표 설정.
		--{
			slot.iconBG:SetPosX( slotConfig._startX + slotConfig._gapX * ii )
			slot.iconBG:SetPosY( slotConfig._startY )
		--}
		
		self._slots[ii]	=	slot
	end

	-- 아이템 개수 및 가격
	--{
		self._static_BuyLineBG		= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Static_BuyLineBG",		Panel_IngameCashShop_BuyOrGift,	"InGameShopBuy_Buy"				)
		self._static_PearlIcon		= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Static_PearlIcon",		self._static_BuyLineBG,			"InGameShopBuy_Buy_Icon"		)
		self._static_Price			= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "StaticText_GoodsPrice",	self._static_BuyLineBG,			"InGameShopBuy_Buy_Price"		)
		self._static_BuyCountTitle	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "StaticText_BuyCount",	self._static_BuyLineBG,			"InGameShopBuy_Buy_Count"		)
		self._edit_count			= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Edit_BuyCount",			self._static_BuyLineBG,			"InGameShopBuy_Buy_EditCount"	)
		self._button_CountUp		= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Button_CountPlus",		self._static_BuyLineBG,			"InGameShopBuy_Buy_ButtonPlus"	)
		self._button_CountDown		= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Button_CountMinus",		self._static_BuyLineBG,			"InGameShopBuy_Buy_Button_Minus")
		
		
		self._button_CountUp	:addInputEvent(	"Mouse_LUp",	"InGameShopBuy_Count( true )"	)
		self._button_CountUp	:SetAutoDisableTime(0)
		self._button_CountDown	:addInputEvent(	"Mouse_LUp",	"InGameShopBuy_Count( false )"	)
		self._button_CountDown	:SetAutoDisableTime(0)
		self._edit_count		:addInputEvent(	"Mouse_LUp",	"_InGameShopBuy_DontChangeCount()"	)	-- 직접 입력할 수 없다.
		self._edit_count		:SetEnable( false )
		
		self._edit_count:SetNumberMode( true )
		self._edit_count:SetEditText( 1, false)
	--}

	-- { 선물 리스트
		self._static_GiftListBG:SetPosY( 180 )
		self._static_GiftListBG:SetSize( self._static_GiftListBG:GetSizeX(), 375 )

		-- { 보낼 명단
			self._static_GiftListTopBG:SetPosY( 185 )
			self._static_GiftListTopBG:SetSize( self._static_GiftListTopBG:GetSizeX(), 145 )

			self._static_GiftListTopBG:addInputEvent( "Mouse_UpScroll", 	"Scroll_GiftTopList( true )")
			self._static_GiftListTopBG:addInputEvent( "Mouse_DownScroll",	"Scroll_GiftTopList( false )")

			for giftIdx = 0, self._config._giftTopListMaxCount -1 do
				local slot = {}
				slot.name		= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "StaticText_GiftListName",	self._static_GiftListTopBG,	"GiftTopListName_" .. 	giftIdx	)
				slot.count		= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Edit_GiftListBuyCount",		slot.name,	"GiftTopListCountBox_" .. 	giftIdx	)
				slot.btnPlus	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Button_GiftListCountPlus",	slot.count,	"GiftTopList_BtnPlus_" .. 	giftIdx	)
				slot.btnMinus	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Button_GiftListCountMinus",	slot.count,	"GiftTopList_BtnMinus_" .. 	giftIdx	)
				slot.btnDelete	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Button_GiftListDelete",		slot.count,	"GiftTopList_BtnDelete_" .. 	giftIdx	)

				slot.name		:SetSpanSize( 10, ( 5 + ( 5 + (slot.name:GetSizeY() * giftIdx) )  ) )
				slot.count		:SetSpanSize( 202, -2 )
				slot.btnPlus	:SetSpanSize( slot.count:GetSizeX() + 3, 5 )
				slot.btnMinus	:SetSpanSize( slot.btnPlus:GetSpanSize().x + slot.btnMinus:GetSizeX() + 2, 5 )
				slot.btnDelete	:SetSpanSize( slot.btnMinus:GetSpanSize().x + slot.btnDelete:GetSizeX() + 2, 5 )

				slot.btnPlus	:SetAutoDisableTime( 0 )
				slot.btnMinus	:SetAutoDisableTime( 0 )
				slot.btnDelete	:SetAutoDisableTime( 0 )
				slot.count		:SetIgnore( true )

				slot.name		:addInputEvent( "Mouse_UpScroll", 		"Scroll_GiftTopList( true )")
				slot.name		:addInputEvent( "Mouse_DownScroll",		"Scroll_GiftTopList( false )")
				slot.count		:addInputEvent( "Mouse_UpScroll", 		"Scroll_GiftTopList( true )")
				slot.count		:addInputEvent( "Mouse_DownScroll",		"Scroll_GiftTopList( false )")
				slot.btnPlus	:addInputEvent( "Mouse_UpScroll", 		"Scroll_GiftTopList( true )")
				slot.btnPlus	:addInputEvent( "Mouse_DownScroll",		"Scroll_GiftTopList( false )")
				slot.btnMinus	:addInputEvent( "Mouse_UpScroll", 		"Scroll_GiftTopList( true )")
				slot.btnMinus	:addInputEvent( "Mouse_DownScroll",		"Scroll_GiftTopList( false )")
				slot.btnDelete	:addInputEvent( "Mouse_UpScroll", 		"Scroll_GiftTopList( true )")
				slot.btnDelete	:addInputEvent( "Mouse_DownScroll",		"Scroll_GiftTopList( false )")

				self.giftTopList[giftIdx] = slot
			end

			Panel_IngameCashShop_BuyOrGift	:RemoveControl( self._scroll_GiftTopList )
			Panel_IngameCashShop_BuyOrGift	:RemoveControl( self._static_GiftList_NonUser )

			self._static_GiftListTopBG		:AddChild(self._scroll_GiftTopList)
			self._static_GiftListTopBG		:AddChild(self._static_GiftList_NonUser)

			self._scroll_GiftTopList		:SetSize( self._scroll_GiftTopList:GetSizeX(), self._static_GiftListTopBG:GetSizeY() - 10 )
			self._scroll_GiftTopList		:ComputePos()
		-- }
		
		-- { 보낼 명단에 올릴 수 있는 명단
			self._static_GiftListBotBG:SetPosY( 335 )
			self._static_GiftListBotBG:SetSize( self._static_GiftListBotBG:GetSizeX(), 175 )
			self._static_GiftListBotBG:addInputEvent( "Mouse_UpScroll", 	"Scroll_GiftBotList( true )")
			self._static_GiftListBotBG:addInputEvent( "Mouse_DownScroll",	"Scroll_GiftBotList( false )")

			for giftBotIdx = 0, self._config._giftBotListMaxCount -1 do
				local slot = {}
				slot.name		= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "StaticText_GiftListName",	self._static_GiftListBotBG,	"GiftBotListName_" .. 	giftBotIdx	)
				slot.btnAdd		= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_BuyOrGift, "Button_AddList",			slot.name,					"GiftBotListAddList_" .. 	giftBotIdx	)

				slot.name		:SetSpanSize( 10, ( 35 + ( 5 + (slot.name:GetSizeY() * giftBotIdx) )  ) )
				slot.btnAdd		:SetSpanSize( 257, -3 )

				slot.name	:addInputEvent( "Mouse_UpScroll", 		"Scroll_GiftBotList( true )")
				slot.name	:addInputEvent( "Mouse_DownScroll",		"Scroll_GiftBotList( false )")
				slot.btnAdd	:addInputEvent( "Mouse_UpScroll", 		"Scroll_GiftBotList( true )")
				slot.btnAdd	:addInputEvent( "Mouse_DownScroll",		"Scroll_GiftBotList( false )")

				self.giftBotList[giftBotIdx] = slot
			end

			Panel_IngameCashShop_BuyOrGift	:RemoveControl( self._buttonFriendList )
			Panel_IngameCashShop_BuyOrGift	:RemoveControl( self._buttonGuildList )
			Panel_IngameCashShop_BuyOrGift	:RemoveControl( self._scroll_GiftBotList )

			self._static_GiftListBotBG		:AddChild(self._buttonFriendList)
			self._static_GiftListBotBG		:AddChild(self._buttonGuildList)
			self._static_GiftListBotBG		:AddChild(self._scroll_GiftBotList)

			self._scroll_GiftBotList		:SetSize( self._scroll_GiftBotList:GetSizeX(), self._static_GiftListBotBG:GetSizeY() - 55 )

			self._buttonFriendList			:ComputePos()
			self._buttonGuildList			:ComputePos()
			self._scroll_GiftBotList		:ComputePos()
		-- }
		
	-- }
end

function	inGameShopBuy:registMessageHandler()
	self._button_Close		:addInputEvent(		"Mouse_LUp",	"InGameShopBuy_Close()"			)
	-- self._button_Confirm	:addInputEvent(		"Mouse_LUp",	"InGameShopBuy_Confirm()"		)
	self._button_Confirm	:addInputEvent(		"Mouse_LUp",	"InGameShopBuy_ConfirmMSG()"		)
	self._button_Cancle		:addInputEvent(		"Mouse_LUp",	"InGameShopBuy_Close()"			)
	self._button_AddUser	:addInputEvent(		"Mouse_LUp",	"InGameShopBuy_CheckAddUser()"				)
	self._edit_Gift			:addInputEvent(		"Mouse_LUp",	"HandelClicked_InGameShopBuy_SetAddUser()" )
	--self._edit_Gift			:RegistReturnKeyEvent(			"InGameShopBuy_CheckAddUser()" )	--가문명 캐릭터명 확인창에서 엔터누르면 확인창에서 재입력 받아버려서 막았습니다.
	self._buttonFriendList	:addInputEvent(		"Mouse_LUp",	"HandelClicked_InGameShopBuy_FriendGuild()"			)
	self._buttonGuildList	:addInputEvent(		"Mouse_LUp",	"HandelClicked_InGameShopBuy_FriendGuild()"			)
end

function	inGameShopBuy:registEventHandler()
	registerEvent( "FromClient_NotifyCompleteBuyProduct",	"FromClient_NotifyCompleteBuyProduct"	) -- 구매가 잘 되었다. 여기에 머니 업데이트도 걸어야 한다.
	registerEvent( "FromClient_IncashshopGetUserNickName", "FromClient_IncashshopGetUserNickName" ) --캐릭터유저이름 응답이 왔다. 이함수에서 MessageBox 출력한다.
end

function	inGameShopBuy:update()
	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
	if	( nil == cashProduct )	then
		return
	end
	
	self._static_ItemIcon:ChangeTextureInfoName( "Icon/" .. cashProduct:getIconPath() )
	self._static_ItemName:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._static_ItemName:SetText( cashProduct:getName() )
	self._static_Price:SetText( makeDotMoney(cashProduct:getPrice()) )

	-- 펄 아이콘 변경
	InGameShopBuy_ChangeMoneyIconTexture( cashProduct:getCategory(), cashProduct:isMoneyPrice() )
	
	for	ii = 0, self._slotCount-1	do
		local	slot	= self._slots[ii]
		slot.iconBG:SetShow(false)
	end
	
	local	itemCount	= cashProduct:getItemListCount()
	for ii = 0, itemCount - 1 do
		local	slot		= self._slots[ii]
		local	item		= cashProduct:getItemByIndex( ii )
		local	itemCount	= cashProduct:getItemCountByIndex( ii )
		local	itemGrade	= item:getGradeType()
		
		-- slot.name:SetFontColor( ConvertFromGradeToColor(itemGrade) )
		-- slot.name:SetText( item:getName() )
		slot.icon:ChangeTextureInfoName( "icon/" .. item:getIconPath() )
		slot.icon	:addInputEvent( "Mouse_On", "InGameShopBuy_ShowItemToolTip( true, " .. ii .. " )" )
		slot.icon	:addInputEvent( "Mouse_Out", "InGameShopBuy_ShowItemToolTip( false, " .. ii .. " )" )
		slot.icon:SetText( tostring(itemCount) )
		
		slot.iconBG:SetShow(true)
	end
	
	-- 선물하기
	--{
		local	giftGap	= 0
		self._static_Gift:SetShow(false)
			self._edit_Gift:SetShow(false)
		if	( self._isGift )	then
			self._static_Gift:SetShow(true)
			self._edit_Gift:SetShow(true)
			self._edit_Gift:SetIgnore( false )
			self._edit_Gift:SetEnable( true )
			self._edit_Gift:SetDisableColor( false )
			giftGap	= self._config._sizeGift
		end
	--}
	
	-- 크기 및 사이즈 조절
	--{
		local	buyConfig		= self._config._buy
		self._static_BuyLineBG:SetPosX( buyConfig._startX )
		self._static_BuyLineBG:SetPosY( buyConfig._startY + buyConfig._gapX )

		if self._isGift then
			self._static_BuyLineBG:SetShow( false )	-- 구입 수량 부분
			self._static_LeftBG:SetSize( self._static_LeftBG:GetSizeX(), 130 )	-- buyConfig._startY + buyConfig._gapX + self._config._sizeBG + giftGap
			Panel_IngameCashShop_BuyOrGift:SetSize( Panel_IngameCashShop_BuyOrGift:GetSizeX(), 600 )	-- buyConfig._startY + buyConfig._gapX + self._config._sizePanel + giftGap

			self._static_GiftListBG		:SetShow( true )
			self._static_GiftListTopBG	:SetShow( true )
			self._static_GiftListBotBG	:SetShow( true )
			self._button_AddUser		:SetShow( true )

			-- { 선물 보낼 명단
				inGameShopBuy:AddedListUpdate()
			-- }

			-- { 선물을 보낼 수 있는 명단
				inGameShopBuy:UserListUpdate()
			-- }

		else
			self._static_BuyLineBG:SetShow( true )	-- 구입 수량 부분
			self._static_LeftBG:SetSize( self._static_LeftBG:GetSizeX(), buyConfig._startY + buyConfig._gapX + self._config._sizeBG + giftGap )
			Panel_IngameCashShop_BuyOrGift:SetSize( Panel_IngameCashShop_BuyOrGift:GetSizeX(), buyConfig._startY + buyConfig._gapX + self._config._sizePanel + giftGap )

			self._static_GiftListBG		:SetShow( false )
			self._static_GiftListTopBG	:SetShow( false )
			self._static_GiftListBotBG	:SetShow( false )
			self._button_AddUser		:SetShow( false )
		end
		
		self._static_Gift		:ComputePos()
		self._edit_Gift			:ComputePos()
		self._button_AddUser	:ComputePos()
		self._button_Confirm	:ComputePos()
		self._button_Cancle		:ComputePos()
	--}
end

function inGameShopBuy:AddedListUpdate()
	for giftIdx = 0, self._config._giftTopListMaxCount -1 do
		local slot = self.giftTopList[giftIdx]
		slot.name		:SetShow( false )
	end

	self._config._giftTopListCount = getIngameCashMall():getGiftListCount()

	local uiIdx = 0
	for idx = self._config._giftTopListStart, self._config._giftTopListCount-1 do	-- # 카운트를 하려면 1부터 시작해야 한다.
		if uiIdx <= self._config._giftTopListMaxCount-1 then
			local slot = self.giftTopList[uiIdx]
			local data = getIngameCashMall():getGiftList( idx )

			slot.name:SetShow( true )
			slot.name:SetText( data:getName() )
			slot.count:SetEditText( data:getCount(), true )
			slot.btnPlus	:addInputEvent( "Mouse_LUp", "HandleClicked_InGameShop_ChangeGiftCount( true, " .. idx .. " )" )
			slot.btnMinus	:addInputEvent( "Mouse_LUp", "HandleClicked_InGameShop_ChangeGiftCount( false, " .. idx .. " )" )
			slot.btnDelete	:addInputEvent( "Mouse_LUp", "HandleClicked_InGameShop_DeleteGiftList( " .. idx .. " )" )

			uiIdx = uiIdx + 1
		end
		UIScroll.SetButtonSize( self._scroll_GiftTopList, self._config._giftTopListMaxCount, self._config._giftTopListCount)
	end

	self._static_GiftList_NonUser:SetShow( false )
	if self._config._giftTopListCount <= 0 then
		self._static_GiftList_NonUser:SetShow( true )
	end

	if self._config._giftBotListMaxCount < self._config._giftTopListCount then
		self._scroll_GiftTopList:SetShow( true )
	else
		self._scroll_GiftTopList:SetShow( false )
	end
end


function inGameShopBuy:UserListUpdate()
	for giftBotIdx = 0, self._config._giftBotListMaxCount -1 do
		local slot = self.giftBotList[giftBotIdx]
		slot.name		:SetShow( false )
	end

	self.giftUserList	= {}
	local userCount		= 0
	local isFriend		= self._buttonFriendList:IsCheck()
	if isFriend then
		local friendGroupCount = RequestFriends_getFriendGroupCount()
		for groupIndex = 0,  friendGroupCount-1, 1 do
			local friendGroup 	= RequestFriends_getFriendGroupAt(groupIndex)
			local friendCount = friendGroup:getFriendCount()
			for friendIndex = 0, friendCount-1, 1 do
				local friendInfo	= friendGroup:getFriendAt(friendIndex)
				local friendName	= friendInfo:getName()
				if friendInfo:isOnline() then
					friendName = friendName
				else
					local s64_lastLogoutTime	= friendInfo:getLastLogoutTime_s64()
					friendName = friendName .. "(".. convertStringFromDatetimeOverHour(s64_lastLogoutTime) ..")"
				end
				self.giftUserList[userCount] = { name = friendInfo:getName(), userNo = friendInfo:getUserNo(), sendType = giftSendType.userNo }
				userCount = userCount + 1
			end
		end
	else
		local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
		if nil ~= myGuildListInfo then
			local memberCount		= myGuildListInfo:getMemberCount()
			for index = 0, memberCount - 1, 1 do
				local myGuildMemberInfo = myGuildListInfo:getMember( index )
				if nil ~= myGuildMemberInfo then
					if not myGuildMemberInfo:isSelf() then
						local guildMemberName = ""
						if myGuildMemberInfo:isOnline() == true then
							guildMemberName = myGuildMemberInfo:getName()
						else
							local s64_lastLogoutTime	= myGuildMemberInfo:getElapsedTimeAfterLogOut_s64()
							guildMemberName = myGuildMemberInfo:getName() .. "(" .. convertStringFromDatetimeOverHour(s64_lastLogoutTime) .. ")"
						end

						self.giftUserList[userCount] = { name = myGuildMemberInfo:getName(), userNo = myGuildMemberInfo:getUserNo(), sendType = giftSendType.userNo }
						userCount = userCount + 1
					end
				end
			end
		end
	end

	self._config._giftBotListCount = userCount

	local uiIdx = 0
	for idx = self._config._giftBotListStart, self._config._giftBotListCount-1 do
		if uiIdx <= self._config._giftBotListMaxCount-1 then
			local slot = self.giftBotList[uiIdx]
			local data = self.giftUserList[idx]
			slot.name	:SetShow( true )
			slot.name	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_PANEL_INGAMECASHSHOP_BUYORGIFT_NAME_HAEDKEYWORD", "name", data.name ) )	-- "가문 : {}"

			slot.btnAdd	:addInputEvent( "Mouse_LUp", "HandleClicked_AddGiftTopList( " .. idx .. " )")

			uiIdx = uiIdx +1
		end
		UIScroll.SetButtonSize( self._scroll_GiftBotList, self._config._giftBotListMaxCount, self._config._giftBotListCount)
	end

	if self._config._giftBotListMaxCount -1 < #self.giftUserList then
		self._scroll_GiftBotList:SetShow( true )
	else
		self._scroll_GiftBotList:SetShow( false )
	end
end

function	inGameShopBuy:defaultPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_IngameCashShop_BuyOrGift:GetSizeX()
	local panelSizeY 	= Panel_IngameCashShop_BuyOrGift:GetSizeY()

	Panel_IngameCashShop_BuyOrGift:SetPosX( (scrSizeX / 2) - (panelSizeX / 2) )
	Panel_IngameCashShop_BuyOrGift:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) )
end

----------------------------------------------------------------------------------------------------
-- Window Function
function InGameShopBuy_ConfirmMSG()
	if	( not inGameShopBuy._isGift )	then
		InGameShopBuy_Confirm()
		return
	end

	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( inGameShopBuy._productNoRaw )
	if	( nil == cashProduct )	then
		return
	end

	local userCount = inGameShopBuy._config._giftTopListCount

	if userCount <= 0 then
		local msg = PAGetString ( Defines.StringSheet_GAME, "LUA_PANEL_INGAMECASHSHOP_BUYORGIFT_MUST_SELECT_USER")
		Proc_ShowMessage_Ack( msg )	-- "선물 받을 대상을 선택해야 합니다."
		return
	end

	local	messageBoxtitle	= PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING")
	local	messageBoxMemo	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_PANEL_INGAMECASHSHOP_BUYORGIFT_GIFT_CONFIRM", "countUser", userCount, "itemName", cashProduct:getName() )	-- userCount .. "명에게 " .. cashProduct:getName() .. "을(를) 선물하시겠습니까?"

	local	messageBoxData = { title = messageBoxtitle, content = messageBoxMemo, functionYes = InGameShopBuy_Confirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageBoxData, "middle")
end

function	InGameShopBuy_Confirm()
	local	self		= inGameShopBuy
	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
	if	( nil == cashProduct )	then
		return
	end
	
	local	count	= self._edit_count:GetEditText()
	if	( not self._isGift )	then
		-- 먼저 돈이 있는지 체크
		local haveCash, havePearl, haveMileage = InGameShop_UpdateCash()
		local isEnoughMoney = false
		if UI_CCC.eCashProductCategory_Pearl == cashProduct:getCategory() then					-- 다음캐시가 필요함
			isEnoughMoney = ( cashProduct:getPrice()*toInt64(0, count) <= haveCash )
		elseif UI_CCC.eCashProductCategory_Mileage == cashProduct:getCategory() then			-- 마일리지가 필요함
			isEnoughMoney = ( cashProduct:getPrice()*toInt64(0, count) <= haveMileage )
		else																					-- 펄이 필요함
			isEnoughMoney = ( cashProduct:getPrice()*toInt64(0, count) <= havePearl )
		end

		-- if not isEnoughMoney then
		-- 	_InGameShopBuy_Confirm_LackMoney( cashProduct:getCategory() )
		-- 	audioPostEvent_SystemUi(16,01)
		-- else
			_InGameShopBuy_Confirm_EnoughMoney()	-- 돈이 충분하다.
		-- end
	else
		_InGameShopBuy_Confirm_EnoughMoneyForGift()	-- 돈이 충분하다.
	end
	
	InGameShopDetailInfo_Close()
	InGameShopBuy_Close()
end

function InGameShopBuy_GiftMyFriend()
	PaymentPassword( FGlobal_InGameShopBuy_Gift )
end

function _InGameShopBuy_Confirm_LackMoney( category )
	local	self	= inGameShopBuy
	if CppEnums.CashProductCategory.eCashProductCategory_Mileage == category then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_LACKMONEY_ACK") )-- "마일리지가 부족합니다. 마일리지는 도전과제 보상으로 얻을 수 있습니다." )
		return
	end

	self._needMoneyType = category

	local	messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_ALERT") -- "알  림"
	local	messageBoxMemo	= ""
	local	moneyType		= ""

	if CppEnums.CashProductCategory.eCashProductCategory_Pearl == category then
		moneyType = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_DAUMCASH") -- "다음캐쉬"
		if isNaver then
			moneyType = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_INGAMECASHSHOP_NAVERCASH")	-- "네이버 캐쉬"
		end
	elseif CppEnums.CashProductCategory.eCashProductCategory_Mileage == category then
		moneyType = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_MILEAGE") -- "마일리지"
	else
		moneyType = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_PEARL") -- "펄"
	end
	messageBoxMemo	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CONFIRM_MSGBOX", "moneyType", moneyType, "moneyType2", moneyType ) -- moneyType .. "가 부족합니다. " .. moneyType .. " 구입 페이지로 이동하시겠습니까?"

	local	messageBoxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = _InGameShopBuy_BuyMoney, functionNo = _InGameShopBuy_Confirm_Cancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function _InGameShopBuy_BuyMoney()
	local	self		= inGameShopBuy
	local	category	= self._needMoneyType

	if CppEnums.CashProductCategory.eCashProductCategory_Pearl == category then
		InGameShop_BuyDaumCash()
	elseif CppEnums.CashProductCategory.eCashProductCategory_Mileage == category then
		-- 마일리지를 얻을 수 있는 방법 나크메시지로.
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CONFIRM_MILEAGE") )-- "마일리지가 부족합니다. 마일리지는 도전과제 보상으로 얻을 수 있습니다." )
	else
		InGameShop_BuyPearl()
	end
end

function _InGameShopBuy_Confirm_EnoughMoneyForGift()
	local	selfPlayerWrapper	= getSelfPlayer()
	local	selfPlayer			= selfPlayerWrapper:get()
	local	isCreatePasword		= selfPlayer:isPaymentPassword()

	if false == isCreatePasword then
		InGameShopBuy_GiftMyFriend()			
	else
		local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_GIFTMYFRIEND") -- "먼저 거래 비밀번호 설정을 해야합니다.\n설정 후 다시 시도해주세요."
		local	messageBoxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionApply = InGameShopBuy_GiftMyFriend, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
end

function _InGameShopBuy_Confirm_EnoughMoney()
	local	self		= inGameShopBuy
	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
	if	( nil == cashProduct )	then
		return
	end

	local limitType	= cashProduct:getCashPurchaseLimitType()
	if UI_PLT.None ~= limitType then
		local mylimitCount	= getIngameCashMall():getRemainingLimitCount( self._productNoRaw )
		if mylimitCount < 1 then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_PURCHASELIMIT") )-- "구입 제한만큼 이미 구입하셨습니다. " )
			return
		end
	end

	-- if CppEnums.ContryCode.eContryCode_JAP == getContryTypeLua() then
	-- 	if CppEnums.CashProductCategory.eCashProductCategory_Pearl == cashProduct:getCategory() then
	-- 		local itemCount = tonumber(inGameShopBuy._edit_count:GetEditText())
	-- 		if 20 < itemCount then
	-- 			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCashProductOnceCountOver") )	--  "20개 이상 구매할 수 없습니다."
	-- 			return
	-- 		end
	-- 	end
	-- end
	
	local	count	= self._edit_count:GetEditText()

	local	messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_ALERT") -- "알  림"
	local	messageBoxMemo	= ""
	local	messageBoxData	= nil
	local	addPearlComment = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CONFIRM_PURCHASELIMIT") -- "\n 본 상품은 구입 후 7일이 경과하거나, 상자를 개봉할 경우 쳥약 철회가 불가능한 상품입니다."

	-- 아이템이 클래스에 맞지 않는다면,
	

	-- local	item				= cashProduct:getItemByIndex( 0 )
	local	mathClass			= nil
	local	addmathClassString = ""
	if cashProduct:doHaveDisplayClass() and not cashProduct:isClassTypeUsable(getSelfPlayer():getClassType()) then
		mathClass = false
	else
		mathClass = true
	end

	if false == mathClass then
		addmathClassString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_MATHCLASS") --"플레이어가 사용할 수 없는 아이템입니다.\n"
	end

	if UI_CCC.eCashProductCategory_Pearl == cashProduct:getCategory() then
		messageBoxMemo	= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CONFIRM_REALBUY", "addmathClassString", addmathClassString, "getName", cashProduct:getName(), "count", count ) .. addPearlComment -- "<PAColor0xffd0ee68>[" .. addmathClassString .. cashProduct:getName() .. "] 상품<PAOldColor>\n" .. count .. "개를 정말 구입하시겠습니까?" .. addPearlComment
	else
		messageBoxMemo	= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CONFIRM_REALBUY", "addmathClassString", addmathClassString, "getName", cashProduct:getName(), "count", count ) -- "<PAColor0xffd0ee68>[" .. addmathClassString .. cashProduct:getName() .. "] 상품<PAOldColor>\n" .. count .. "개를 정말 구입하시겠습니까?"
	end
	messageBoxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = InGameShopBuy_ConfirmDo, functionNo = _InGameShopBuy_Confirm_Cancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function InGameShopBuy_ConfirmDo()
	audioPostEvent_SystemUi(16,00)

	local	self		= inGameShopBuy
	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
	if	( nil == cashProduct )	then
		return
	end
	local	count	= self._edit_count:GetEditText()
	getIngameCashMall():requestBuyItem( self._productNoRaw, count, cashProduct:getPrice(), CppEnums.BuyItemReqTrType.eBuyItemReqTrType_None )
end

function _InGameShopBuy_Confirm_Cancel()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_BUYCANCEL") )-- "구입이 취소됐습니다" )
	InGameShopBuy_Close()
end

function FGlobal_InGameShopBuy_Gift()
	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( inGameShopBuy._productNoRaw )
	if nil == cashProduct then
		return
	end

	getIngameCashMall():requestBuyGiftForList( inGameShopBuy._productNoRaw )
	
	inGameShopBuy._scroll_GiftTopList:SetControlTop()

	inGameShopBuy:AddedListUpdate()
end

function InGameShopBuy_Count( isUp )
	local	self		= inGameShopBuy
	local	count		= tonumber(self._edit_count:GetEditText())


	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
	if	( nil == cashProduct )	then
		return
	end

	local	price	= cashProduct:getPrice()
	
	if	( not isUp )	then
		if	( count <= 1 )	then
			return
		end
		
		count	= count - 1
	else
		if 20 <= count then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_OVER20") )	-- "한 번에 20개 이상의 상품을 구매할 수 없습니다."
			return
		end
		-- if CppEnums.CashProductCategory.eCashProductCategory_Pearl == cashProduct:getCategory() then
		-- 	if 20 <= count then
		-- 		return
		-- 	end
		-- 	count	= count + 1
		-- else
			count	= count + 1
		-- end
	end

	-- UI.debugMessage(  .. "/" .. count )
	local sumPrice = Int64toInt32(price) * count
	self._static_Price:SetText( makeDotMoney( sumPrice ) )
	self._edit_count:SetEditText( tostring(count), false )
end


function InGameShopBuy_ChangeMoneyIconTexture( categoryIdx, isEnableSilver )
	local self	= inGameShopBuy
	local icon	= self._static_PearlIcon

	local serviceContry = nil
	local iconType		= nil
	-- 국가에 따라, 캐시 아이콘을 달리 한다.
	local eCountryType		= CppEnums.CountryType
	local gameServiceType	= getGameServiceType()

	if eCountryType.NONE == gameServiceType or eCountryType.DEV == gameServiceType or eCountryType.KOR_ALPHA == gameServiceType or eCountryType.KOR_REAL == gameServiceType or eCountryType.KOR_TEST == gameServiceType then
		serviceContry = contry.kr
	elseif eCountryType.JPN_ALPHA == gameServiceType or eCountryType.JPN_REAL == gameServiceType then
		serviceContry = contry.jp
	elseif eCountryType.RUS_ALPHA == gameServiceType or eCountryType.RUS_REAL == gameServiceType then
		serviceContry = contry.ru
	elseif eCountryType.CHI_ALPHA == gameServiceType or eCountryType.CHI_REAL == gameServiceType then
		serviceContry = contry.cn
	else
		serviceContry = contry.kr
	end

	-- 일단은 카테고리에 맞춰 출력한다.
	if UI_CCC.eCashProductCategory_Pearl == categoryIdx then
		iconType = cashIconType.cash
	elseif UI_CCC.eCashProductCategory_Mileage == categoryIdx then
		iconType = cashIconType.mileage
	else
		local isRussia		= ( isGameTypeRussia() or eCountryType.DEV == gameServiceType )
		local isFixedServer	= isServerFixedCharge()
		if true == isRussia and true == isFixedServer then
			if isEnableSilver then
				iconType = cashIconType.silver
			else
				iconType = cashIconType.pearl
			end
		else
			iconType = cashIconType.pearl
		end
	end
	cashIcon_changeTextureForList( icon, serviceContry, iconType )
end

function FromClient_NotifyCompleteBuyProduct( productNoRaw, isGift, toCharacterName )
	local isPearlBox = false
	if isGift then
		Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_NOTIFYCOMPLETEBUYPRODUCT_GIFT", "toCharacterName", toCharacterName) )-- toCharacterName .. "님의 편지로 선물을 보냈습니다.")
	else
		local cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( productNoRaw )
		local itemWrapper	= cashProduct:getItemByIndex( 0 )												-- 여러 개일 경우 첫번째 것만 검사
		isPearlBox			= cashProduct:isPearlBox()
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_NOTIFYCOMPLETE_ACK") ) -- PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_BUYCOMPLETE") "구입이 완료됐습니다.")
		if itemWrapper:get():isCash() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CONFIRM_PEARLBAG") ) -- "구입하신 상품은 펄 가방에서 확인할 수 있습니다.")
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CONFIRM_NORMALBAG") ) -- "구입하신 상품은 가방에서 확인할 수 있습니다.")
		end
	end

	InGameShop_UpdateCash()
	FGlobal_InGameShop_UpdateByBuy()
	InGameShopBuy_Close()
	
	if isPearlBox then
		local cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( productNoRaw )
		local pearlBoxName	= cashProduct:getName()
		local	messageBoxMemo = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_BUYPEARLBOX", "pearlBoxName", pearlBoxName ) -- "감사합니다.\n<PAColor0xffd0ee68>[" .. pearlBoxName .."]<PAOldColor> 상품을 구입했습니다.\n우측 펄 가방에서 상자를 사용(우클릭)하면 펄이 충전됩니다."
		local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_BUYPEARLBOX_TITLE"), content = messageBoxMemo, functionApply = FGlobal_InGameShop_OpenInventory, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
end

function _InGameShopBuy_DontChangeCount()
	ClearFocusEdit()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_DONTCHANGECOUNT") )--"직접 입력을 지원하지 않습니다.")
	return
end

function Scroll_GiftTopList( isUp )
	inGameShopBuy._config._giftTopListStart = UIScroll.ScrollEvent( inGameShopBuy._scroll_GiftTopList, isUp, inGameShopBuy._config._giftTopListMaxCount, inGameShopBuy._config._giftTopListCount, inGameShopBuy._config._giftTopListStart, 1 )
	inGameShopBuy:AddedListUpdate()
end

function Scroll_GiftBotList( isUp )
	inGameShopBuy._config._giftBotListStart = UIScroll.ScrollEvent( inGameShopBuy._scroll_GiftBotList, isUp, inGameShopBuy._config._giftBotListMaxCount, inGameShopBuy._config._giftBotListCount, inGameShopBuy._config._giftBotListStart, 1 )
	inGameShopBuy:UserListUpdate()
end

function HandleClicked_AddGiftTopList( botIdx )
	local botName		= inGameShopBuy.giftUserList[botIdx].name
	local botUserNo 	= inGameShopBuy.giftUserList[botIdx].userNo
	local botSendType	= inGameShopBuy.giftUserList[botIdx].sendType

	if "" ~= botName or nil ~= botName then
		getIngameCashMall():pushGiftToUser( botName, botUserNo )
	else
		_PA_ASSERT( false, "데이터가 비정상입니다. giftUserList 배열에 해당하는 idx 혹은 name 값이 없습니다." )
	end

	inGameShopBuy:update()
end

function HandleClicked_InGameShop_ChangeGiftCount( isPlus, dataIdx )
	local beforCount	= getIngameCashMall():getGiftList( dataIdx ):getCount()
	if isPlus then
		if 20 <= beforCount then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_INGAMECASHSHOP_BUYORGIFT_MUST_LESS20") )	-- "20 보다 많이 선물할 수 없습니다."
			return
		end
		getIngameCashMall():setGiftCount( dataIdx, beforCount+1 )
	else
		if beforCount <= 1 then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_INGAMECASHSHOP_BUYORGIFT_MUST_BIG1") )	-- "1보다 작을 수 없습니다."
			return
		end
		getIngameCashMall():setGiftCount( dataIdx, beforCount-1 )
	end
	inGameShopBuy:AddedListUpdate()
end

function HandleClicked_InGameShop_DeleteGiftList( dataIdx )
	getIngameCashMall():popGift( dataIdx )
	
	inGameShopBuy._config._giftTopListStart	= 0
	inGameShopBuy._scroll_GiftTopList:SetControlTop()

	inGameShopBuy:AddedListUpdate()
end

function HandelClicked_InGameShopBuy_FriendGuild()
	inGameShopBuy:update()
end

function HandelClicked_InGameShopBuy_SetAddUser()
	inGameShopBuy._edit_Gift:SetEditText( "", true )
	-- UI.Set_ProcessorInputMode( CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode )
end

function HandelClicked_InGameShopBuy_AddUser()
	local userName	= inGameShopBuy._edit_Gift:GetEditText()
	--띄워진 메시지박스에서 확인버튼 눌렀을 경우 진행
	
	getIngameCashMall():pushGiftToCharacter( userName )
	inGameShopBuy:AddedListUpdate()
	inGameShopBuy._edit_Gift:SetEditText( "", true )
	ClearFocusEdit()
	UI.Set_ProcessorInputMode( CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode )
end

function InGameShopBuy_ShowItemToolTip( isShow, index )
	local self			= inGameShopBuy
	if true == isShow then
		local cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
		local itemWrapper	= cashProduct:getItemByIndex( index )
		local slotIcon		= self._slots[index].icon
		Panel_Tooltip_Item_Show( itemWrapper, slotIcon, true, false, nil )
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	FGlobal_InGameShopBuy_Open( productNoRaw, isGift, byCart )
	local self			= inGameShopBuy
	self._productNoRaw	= productNoRaw
	self._isGift		= isGift
	self._byCart		= byCart

	self._edit_count:SetEditText( 1, false)

	if true == isGift then
		self._panelTitle		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_DOGIFT") )-- "선물하기")
		self._button_Confirm	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_GIFT") )--  "선물" )
		self._edit_Gift			:SetEditText("", true)
		self._buttonFriendList	:SetCheck( true )
		self._buttonGuildList	:SetCheck( false )
	else
		self._panelTitle		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_BUYPRODUCT") )-- "상품 구입")
		self._button_Confirm	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_BUY") )--  "구입" )
	end

	self.giftUserList				= {}
	self._config._giftTopListCount	= 0
	self._config._giftBotListCount	= 0
	self._config._giftTopListStart	= 0
	self._config._giftBotListStart	= 0

	self._scroll_GiftTopList:SetControlTop()
	self._scroll_GiftBotList:SetControlTop()

	RequestFriendList_getFriendList()
	getIngameCashMall():clearGift()
	
	self:update()
	self:defaultPosition()
	
	InGameShopBuy_Open()
end

function	InGameShopBuy_Open()
	if	( Panel_IngameCashShop_BuyOrGift:GetShow() )	then
		return
	end
	inGameShopBuy._edit_Gift:SetEditText("", true)
	Panel_IngameCashShop_BuyOrGift:SetShow(true)
end

function	InGameShopBuy_Close()
	if	( not Panel_IngameCashShop_BuyOrGift:GetShow() )	then
		return
	end
	ClearFocusEdit()
	Panel_IngameCashShop_BuyOrGift:SetShow( false )

	UI.Set_ProcessorInputMode( CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode )
end

function	InGameShopBuy_CheckAddUser()
	if Panel_Win_System:GetShow() then
		return
	end
	local checkUserNickName = inGameShopBuy._edit_Gift:GetEditText()
	getIngameCashMall():requestUserNickNameByCharacterName(checkUserNickName)
	
end


function	FromClient_IncashshopGetUserNickName(outUserNickName, isSearched)

	local checkCharacterName = inGameShopBuy._edit_Gift:GetEditText()

	if true == isSearched then
		local	messageBoxtitle	= PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING")
		local	messageBoxMemo	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CHECK_TOUSERNAME", "userNickName", outUserNickName, "characterName", checkCharacterName)  --"<PAColor0xffd0ee68>가문명 : {userNickName}\n 캐릭터명 : {characterName}<PAOldColor>\n 추가시키려고 하는 유저가 맞습니까?"
		local	messageBoxData = { title = messageBoxtitle, content = messageBoxMemo, functionYes = HandelClicked_InGameShopBuy_AddUser, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_HIGH }
		MessageBox.showMessageBox(messageBoxData, "middle")
	else
		local	messageBoxtitle2	= PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING")
		local	messageBoxMemo2	= PAGetString ( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_CHECK_TOUSERNAME_NORESULT") --존재하지 않는 캐릭터명입니다.
		local	messageBoxData2 = { title = messageBoxtitle2, content = messageBoxMemo2, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_HIGH }
		MessageBox.showMessageBox(messageBoxData2, "middle")
	
	end
	
end




----------------------------------------------------------------------------------------------------
-- Tooltip
--function cashShop_Buy_ShowTooltip( isShow, itemIdx )
--	local self		= inGameShopBuy
--	local cPSSW		= ToClient_GetCashProductStaticStatusWrapperByKeyRaw( self._productNoRaw )
--	if	( nil == cPSSW )	then
--		return
--	end
--	
--	local itemSSW	= cPSSW:getItemByIndex( itemIdx )
--	local itemUI	= self.PackingItemUIPool[itemIdx]
--	Panel_Tooltip_Item_Show( itemSSW, itemUI.Slot, true, false )
--end

----------------------------------------------------------------------------------------------------
-- Init
inGameShopBuy:init()
inGameShopBuy:registEventHandler()
inGameShopBuy:registMessageHandler()
local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local ItemClassify	= CppEnums.ItemClassifyType
local IM 			= CppEnums.EProcessorInputMode
local isBuySingle	= nil
local buyItemPrice	= 0
local currentItemCount	= 0
local failCount		= 0
local maxFailCount	= 5

if true == isItemMarketSecureCode() then
	Panel_Window_ItemMarket_BuyConfirm = Panel_Window_ItemMarket_BuyConfirmSecure
	local rndNo_1		= nil
	local rndNo_2		= nil
end

Panel_Window_ItemMarket_BuyConfirm:setGlassBackground( true )
Panel_Window_ItemMarket_BuyConfirm:ActiveMouseEventEffect( true )
Panel_Window_ItemMarket_BuyConfirm:SetShow( false )

local ItemMarketBuyConfirm = {
	txt_ItemBuyQuestion			= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_ItemBuyQuestion"),
	txt_ItemBuyCountQuestion	= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_ItemBuyCountQuestion"),
	buyItemCount				= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"Edit_BuyItemCount"),	
	buyItemTotalPrice			= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_ItemBuyTotalPrice"),	
	buyItemBG					= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"Static_BuyItemBG"),
	btn_Buy						= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"Button_Yes"),
	btn_Close					= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"Button_No"),
	btn_Min						= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"Button_Min" ),
	btn_Max						= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"Button_Max" ),
}

if true == isItemMarketSecureCode() then
	ItemMarketBuyConfirm.buyItemSecureCodeBG	= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"Static_BuySecureCodeBG")
	ItemMarketBuyConfirm.buyItemSecureCode1 	= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_SecureCode1")
	ItemMarketBuyConfirm.buyItemSecureCode2 	= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_SecureCode2")
	ItemMarketBuyConfirm.buySecureCode			= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"Edit_BuySecureCode")
	ItemMarketBuyConfirm.buyGuideText			= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_GuideText")
	ItemMarketBuyConfirm.buyItemBuyCountTit		= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_ItemBuyCountTit")
	ItemMarketBuyConfirm.buyItemBuyPrice		= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_ItemBuyPrice")
	ItemMarketBuyConfirm.buyItemBuyPriceValue	= UI.getChildControl( Panel_Window_ItemMarket_BuyConfirm,	"StaticText_ItemBuyPriceValue")
	
	ItemMarketBuyConfirm.buySecureCode:SetMaxInput( 2 )
	ItemMarketBuyConfirm.buySecureCode:RegistReturnKeyEvent( "HandleClicked_ItemMarket_BuyItem()" )
end

local marketItemName = nil
local marketItemBuyCount		= nil
local marketItemMaxCount		= nil

function ItemMarketBuyConfirm:init()
	self.buyItemCount:SetNumberMode( true )
	self.buyItemCount:SetMaxInput( 4 )
end

function ItemMarketBuyConfirm:Update()
	if true == isItemMarketSecureCode() then
		if true == isBuySingle then		-- 단일, 복수 아이템구매에 따른 레이아웃 변경
			self.txt_ItemBuyQuestion:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_MESSAGEBOX_BUYCONFIRM", "itemName", marketItemName ) )
			self.buyItemSecureCodeBG:SetPosY( 93 )
			self.buySecureCode		:SetPosY( 93 )
			self.buyItemSecureCode1	:SetPosY( 101 )
			self.buyItemSecureCode2	:SetPosY( 101 )
			self.buyGuideText		:SetPosY( 125 )
			self.btn_Buy			:SetPosY( 165 )
			self.btn_Close			:SetPosY( 165 )
			Panel_Window_ItemMarket_BuyConfirm:SetSize( 425, 200 )
			self.buyItemBG			:SetSize( 400, 120 )
			self.buyItemCount:SetShow( false )
			self.txt_ItemBuyCountQuestion:SetShow( false )
			self.buyItemBuyCountTit		:SetShow( false )
			self.buyItemBuyPrice		:SetShow( false )
			self.buyItemBuyPriceValue	:SetShow( false )
			self.btn_Min				:SetShow( false )
			self.btn_Max				:SetShow( false )
		else
			self.buyItemSecureCodeBG:SetPosY( 188 )
			self.buySecureCode		:SetPosY( 188 )
			self.buyItemSecureCode1	:SetPosY( 196 )
			self.buyItemSecureCode2	:SetPosY( 196 )
			self.buyGuideText		:SetPosY( 225 )
			self.btn_Buy			:SetPosY( 265 )
			self.btn_Close			:SetPosY( 265 )
			Panel_Window_ItemMarket_BuyConfirm:SetSize( 425, 300 )
			self.buyItemBG			:SetSize( 400, 190 )
			self.buyItemCount:SetShow( true )
			self.txt_ItemBuyCountQuestion:SetShow( true )
			self.buyItemBuyCountTit:SetShow( true )
			self.buyItemBuyPrice:SetShow( true )
			self.buyItemBuyPriceValue:SetShow( true )
			self.btn_Min				:SetShow( true )
			self.btn_Max				:SetShow( true )
			self.txt_ItemBuyQuestion:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCONFIRM_ITEMBUYQUESTION", "marketItemName", marketItemName ) ) -- "[<PAColor0xFFFFD649>" .. marketItemName .. "<PAOldColor>]을/를 몇 개 구입하시겠습니까?" )
			self.txt_ItemBuyCountQuestion:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCONFIRM_ITEMCOUNTBUYQUESTION", "marketItemBuyCount", makeDotMoney(marketItemMaxCount) ) ) -- "[<PAColor0xFFD20000>" .. makeDotMoney(marketItemBuyCount) .. "<PAOldColor>]개 까지만 구매 가능합니다." )
			self.buyItemCount:SetEditText( makeDotMoney(marketItemBuyCount) )	-- 최대치 기본으로 찍어준다.
			local totalPrice = buyItemPrice * marketItemBuyCount
			self.buyItemBuyPriceValue:SetText(makeDotMoney(totalPrice) )			
		end
	else
		self.txt_ItemBuyQuestion:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCONFIRM_ITEMBUYQUESTION", "marketItemName", marketItemName ) ) -- "[<PAColor0xFFFFD649>" .. marketItemName .. "<PAOldColor>]을/를 몇 개 구입하시겠습니까?" )
		self.txt_ItemBuyCountQuestion:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCONFIRM_ITEMCOUNTBUYQUESTION", "marketItemBuyCount", makeDotMoney(marketItemMaxCount) ) ) -- "[<PAColor0xFFD20000>" .. makeDotMoney(marketItemBuyCount) .. "<PAOldColor>]개 까지만 구매 가능합니다." )		
		self.buyItemCount:SetEditText( makeDotMoney(marketItemBuyCount) )	-- 최대치 기본으로 찍어준다.
		local totalPrice = buyItemPrice * marketItemBuyCount			
		self.buyItemTotalPrice:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCONFIRM_BUYPRICE", "totalPrice", makeDotMoney(totalPrice) ) ) -- "구입가격: " .. "<PAColor0xffdcd489>" .. makeDotMoney(totalPrice) .. "<PAOldColor>" )
	end
end

function HandleClicked_ItemMarket_BuyCountInput()
	local currentNumber = toInt64(0,ItemMarketBuyConfirm.buyItemCount:GetEditText())
	Panel_NumberPad_Show( true, marketItemMaxCount, nil, _itemMarketConfirmFunction, false, nil, true )
end

function _itemMarketConfirmFunction(param0)
	ItemMarketBuyConfirm.buyItemCount:SetEditText( makeDotMoney(param0) )
	currentItemCount = param0	
	local totalPrice = buyItemPrice * currentItemCount
	if true == isItemMarketSecureCode() then
		ItemMarketBuyConfirm.buyItemBuyPriceValue:SetText( makeDotMoney(totalPrice) )
	else
		ItemMarketBuyConfirm.buyItemTotalPrice:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCONFIRM_TOTALPRICE", "totalPrice", makeDotMoney(totalPrice) ) ) -- "구입가격: " .. "<PAColor0xffdcd489>" .. makeDotMoney(totalPrice) .. "<PAOldColor>" )
	end	
end

function HandleClicked_ItemMarket_BuyConfirm_Close()
	FGlobal_ItemMarket_BuyConfirm_Close()
end

function HandleClicked_ItemMarket_BuyConfirm_SetMin()
	ItemMarketBuyConfirm.buyItemCount:SetEditText( makeDotMoney(marketItemBuyCount) )
	local totalPrice = buyItemPrice * marketItemBuyCount
	if true == isItemMarketSecureCode() then
		ItemMarketBuyConfirm.buyItemBuyPriceValue:SetText( makeDotMoney(totalPrice) )
	else
		ItemMarketBuyConfirm.buyItemTotalPrice:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCONFIRM_TOTALPRICE", "totalPrice", makeDotMoney(totalPrice) ) ) -- "구입가격: " .. "<PAColor0xffdcd489>" .. makeDotMoney(totalPrice) .. "<PAOldColor>" )
	end	
end

function HandleClicked_ItemMarket_BuyConfirm_SetMax()
	ItemMarketBuyConfirm.buyItemCount:SetEditText( makeDotMoney(marketItemMaxCount) )
	local totalPrice = buyItemPrice * marketItemMaxCount
	if true == isItemMarketSecureCode() then
		ItemMarketBuyConfirm.buyItemBuyPriceValue:SetText( makeDotMoney(totalPrice) )
	else
		ItemMarketBuyConfirm.buyItemTotalPrice:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYCONFIRM_TOTALPRICE", "totalPrice", makeDotMoney(totalPrice) ) ) -- "구입가격: " .. "<PAColor0xffdcd489>" .. makeDotMoney(totalPrice) .. "<PAOldColor>" )
	end	
end

function ItemMarketBuyConfirm:registEventHandler()
	self.buyItemCount	:addInputEvent( "Mouse_LUp",			"HandleClicked_ItemMarket_BuyCountInput()" )
	self.btn_Buy		:addInputEvent( "Mouse_LUp",			"HandleClicked_ItemMarket_BuyItem()" )
	self.btn_Close		:addInputEvent( "Mouse_LUp",			"HandleClicked_ItemMarket_BuyConfirm_Close()" )
	self.btn_Min		:addInputEvent( "Mouse_LUp",			"HandleClicked_ItemMarket_BuyConfirm_SetMin()" )
	self.btn_Max		:addInputEvent( "Mouse_LUp",			"HandleClicked_ItemMarket_BuyConfirm_SetMax()" )
end


function HandleClicked_ItemMarket_BuyItem()
	local self = ItemMarketBuyConfirm
	local itemCount = self.buyItemCount:GetEditText()
	if true == isBuySingle then
		itemCount = 1
	end
	if true == isItemMarketSecureCode() then
		local secureCode	= self.buySecureCode:GetEditText()
		if "" == secureCode then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYSECURECODE_ALERT1") )	-- 보안코드 숫자를 입력해주세요.
			SetFocusEdit( ItemMarketBuyConfirm.buySecureCode )
			return
		end
		if rndNo_1..rndNo_2 == secureCode then
			FGlobal_HandleClicked_ItemMarket_SingleItem_Do( itemCount )
		else
			if failCount < maxFailCount then
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_BUYSECURECODE_ALERT2") )	-- 보안코드 숫자 두 자리를 다시 확인해주세요.
				buySecureCodeSetting()
				SetFocusEdit( ItemMarketBuyConfirm.buySecureCode )
				failCount = failCount + 1
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYCONFIRM_FAILNOTICE") )	-- "실패 한도를 초과하여 대화창이 종료됩니다." )
				FGlobal_ItemMarket_BuyConfirm_Close()
				FGolbal_ItemMarket_Close()
				
				if Panel_Window_ItemMarket_Function:GetShow() then				-- NPC를 통해 열었는지 체크 / false면 메이드 통해 연 것!
					FGolbal_ItemMarket_Function_Close()
					FGlobal_HideDialog()
				end
			end
		end
	else
		FGlobal_HandleClicked_ItemMarket_SingleItem_Do( itemCount )
	end
end

function FGlobal_ItemMarket_BuyConfirm_Open( itemName, itemBuyCount, isSingle, singleItemPrice )
	local self = ItemMarketBuyConfirm
	isBuySingle = isSingle
	marketItemName = itemName
	marketItemBuyCount	= toInt64(0, 1)
	marketItemMaxCount	= itemBuyCount
	buyItemPrice = singleItemPrice
	
	Panel_Window_ItemMarket_BuyConfirm:SetShow( true )
	
	ItemMarketBuyConfirm:Update()

	if true == isItemMarketSecureCode() then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		SetFocusEdit( self.buySecureCode )
		self.buyItemSecureCodeBG:EraseAllEffect()
		self.buyItemSecureCodeBG:AddEffect("UI_Item_MenuAura04",true, 0.0, -0.5)
		buySecureCodeSetting()
		failCount = 0
	end
end

function buySecureCodeSetting()
	local self = ItemMarketBuyConfirm
	-- 텍스쳐 변경
	rndNo_1		= math.random( 0, 9 )
	rndNo_2		= math.random( 0, 9 )
	local floatRnd_1	= math.random( 0, 5 )
	local floatRnd_2	= math.random( 0, 5 )
	local isNegativeNum = nil
	local isBlindType	= ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)
	self.buySecureCode:SetEditText("",true)
	self.buyItemSecureCode1:ChangeTextureInfoName("New_UI_Common_forLua/Window/ItemMarket/"..rndNo_1..".dds")
	self.buyItemSecureCode2:ChangeTextureInfoName("New_UI_Common_forLua/Window/ItemMarket/"..rndNo_2..".dds")
	self.buyItemSecureCode1:SetAlpha(0.9)
	self.buyItemSecureCode2:SetAlpha(0.9)
	if (1 == isBlindType) or (2 == isBlindType) then
		self.buyItemSecureCode1:SetColor( 4294938624 )
		self.buyItemSecureCode2:SetColor( 4294938624 )
	else
		self.buyItemSecureCode1:SetColor( 4291231744 )
		self.buyItemSecureCode2:SetColor( 4291231744 )
	end
	-- 좌, 우로 roatate 구하기 음수면 좌측, 정수면 우측으로 눕는다
	if 0 == floatRnd_1%2 then isNegativeNum_1 = "0." else isNegativeNum_1 = "-0." end
	if 0 == floatRnd_2%2 then isNegativeNum_2 = "0." else isNegativeNum_2 = "-0." end
	self.buyItemSecureCode1:SetRotate( isNegativeNum_1..floatRnd_1 )
	self.buyItemSecureCode2:SetRotate( isNegativeNum_2..floatRnd_2 )
	-- 텍스쳐의 위치 랜덤 변경
	local rndNoPos_1	= math.random( 0, 25 )
	local rndNoPos_2	= math.random( 0, 25 )
	self.buyItemSecureCode1:SetPosX(120+rndNoPos_1)
	self.buyItemSecureCode2:SetPosX(215+rndNoPos_2)
	-- start1 : 120, start2 : 215, end : 25

	-- 팝업 패널 위치 랜덤 변경
	local rndPosX	= math.random( -15, 20 )
	local rndPosY	= math.random( -15, 20 )
	local panelSecurePosX = (getScreenSizeX()/2)-(Panel_Window_ItemMarket_BuyConfirm:GetSizeX()/2)+rndPosX
	local panelSecurePosY = (getScreenSizeY()/2)-(Panel_Window_ItemMarket_BuyConfirm:GetSizeY()/2)+rndPosY
	Panel_Window_ItemMarket_BuyConfirm:SetPosX( panelSecurePosX )
	Panel_Window_ItemMarket_BuyConfirm:SetPosY( panelSecurePosY )
end

function FGlobal_ItemMarket_BuyConfirm_Close()
	if false == Panel_Window_ItemMarket_BuyConfirm:GetShow() then
		return
	end

	local self = ItemMarketBuyConfirm

	self.buyItemCount:SetEditText("")
	ClearFocusEdit()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	Panel_Window_ItemMarket_BuyConfirm:SetShow( false )
	marketItemMaxCount = nil
end

function FGlobal_isItemMarketBuyConfirm()
	local self = Panel_Window_ItemMarket_BuyConfirm
	return self:GetShow()
end

function FGlobal_ItemMarket_BuyItemConfirm_PriceCheck( itemPrice )
	buyItemPrice = itemPrice
	
	return buyItemPrice
end
ItemMarketBuyConfirm:init()
ItemMarketBuyConfirm:registEventHandler()
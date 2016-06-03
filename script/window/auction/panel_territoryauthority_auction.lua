-- 영지 무역
Panel_TerritoryAuth_Auction:SetShow(false, false)
Panel_TerritoryAuth_Auction:setMaskingChild(true)
Panel_TerritoryAuth_Auction:ActiveMouseEventEffect(true)
Panel_TerritoryAuth_Auction:RegisterShowEventFunc( true, 'TerritoryAuth_AuctionShowAni()' )
Panel_TerritoryAuth_Auction:RegisterShowEventFunc( false, 'TerritoryAuth_AuctionHideAni()' )
Panel_TerritoryAuth_Auction:setGlassBackground( true )

function  TerritoryAuth_AuctionShowAni()
	UIAni.fadeInSCR_Down( Panel_TerritoryAuth_Auction )
end
function TerritoryAuth_AuctionHideAni()
	UIAni.closeAni( Panel_TerritoryAuth_Auction )
end

local UI_ANI_ADV								= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM										 = CppEnums.TextMode
local UI_color									= Defines.Color
local screenX									= nil
local screenY									= nil
local maxCount 									= 5				-- 황실 무역 최대 불러오는 개수
local minBid									= 10000			-- 입찰 최소 금액
local isEnableSupplyTrade						= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 22 ) -- 황실 납품.

local closeBtn			= UI.getChildControl ( Panel_TerritoryAuth_Auction, "Button_Win_Close" )			-- 닫기 버튼
local bidBtn			= UI.getChildControl ( Panel_TerritoryAuth_Auction, "Button_Biding" )				-- 입찰 버튼
local withdrawBidprice	= UI.getChildControl ( Panel_TerritoryAuth_Auction, "Button_MoneyBack" )			-- 입찰금 회수 버튼
local txtExplain		= UI.getChildControl ( Panel_TerritoryAuth_Auction,	"StaticText_Explain" )			-- 설명 텍스트
local txtBidinFinish 	= UI.getChildControl ( Panel_TerritoryAuth_Auction, "StaticText_BiddingFinish" )	-- 입찰 성공 텍스트
local txtRemainTime		= UI.getChildControl ( Panel_TerritoryAuth_Auction, "StaticText_Remain_Time" )		-- 남은 시간
local editBidPrice		= UI.getChildControl ( Panel_TerritoryAuth_Auction, "Edit_BidPrice" )				-- 
local slotBG			= UI.getChildControl ( Panel_TerritoryAuth_Auction, "Static_SlotBG")				-- 슬롯 테두리(슬롯은 new, 테두리는 create)

closeBtn			:addInputEvent( "Mouse_LUp", "Button_TerritoryAuthAuctionClose_Click()" )
bidBtn				:addInputEvent( "Mouse_LUp", "Button_TerritoryAuthAuctionBid_Click()" )					-- 입찰 버튼 클릭 이벤트

txtExplain		:SetTextMode( UI_TM.eTextMode_AutoWrap )
editBidPrice	:SetNumberMode( true )

local slotConfig =
{
	createIcon		= true,
	createBorder	= true,
	createCount		= true,
	createCooltime	= true,
	createCash		= true
}
local slots = {}
local slot_BG = {}

function TerritoryAuth_Resize()
	
end

function EventNotifyResponseAuctionInfo( goodsType, sendType, tempStr, tempStr2, bidRv )
	-- 메디아 관련 메시지는 잠시 막아둔다.
	-- if "메디아 직할령" == tempStr then
		-- return
	-- end
		
	-- sendType = 0(시작), 1(종료)	
		
	local strGoodsType = "";
	local msg = "";
	if ( goodsType == CppEnums.AuctionType.AuctionGoods_House ) then
		if not ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 36 ) then			-- 길드 하우스가 열려있지 않으면 리턴
			return
		end
		strGoodsType	= PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_STRGOODSTYPE") -- "길드 하우스"			-- 길드하우스
		
		if( sendType == 0 ) then
			msg		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_SENDTYPE0_MSG", "tempStr", tempStr ) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_7")		-- 경매가 시작되었습니다.
		elseif( sendType == 1) then
			if( 0 == bidRv ) then
				-- tempStr2 길드 이름
				msg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_SENDTYPE1_MSG1", "tempStr", tempStr, "tempStr2", tempStr2 ) -- tempStr.. "경매에 " .. tempStr2.."길드가 낙찰되었습니다."
			else
				msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_SENDTYPE1_MSG2", "tempStr", tempStr ) -- tempStr.. "경매가 유찰되었습니다."
			end
			
		else
			_PA_ASSERT(false, "작업해주세요");
		end
	
	elseif( goodsType == CppEnums.AuctionType.AuctionGoods_TerritoryTradeAuthority ) then
	
		strGoodsType = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_9")	-- 황실 무역 권한
			
		if( sendType == 0 ) then	
			msg		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION", "tempStr", tempStr, "strGoodsType", strGoodsType ) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_7")		-- 경매가 시작되었습니다.
		elseif( sendType == 1 ) then
			msg		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION", "tempStr", tempStr, "strGoodsType", strGoodsType ) .. " " ..PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_8")		-- 경매가 종료되었습니다.		
		else
			_PA_ASSERT(false, "작업해주세요");
		end
	
	elseif ( goodsType == CppEnums.AuctionType.AuctionGoods_Villa ) then
		strGoodsType = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_15")
		if( sendType == 0 ) then	
			msg		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION", "tempStr", tempStr, "strGoodsType", strGoodsType ) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_7")		-- 경매가 시작되었습니다.
		elseif( sendType == 1 ) then
			msg		= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION", "tempStr", tempStr, "strGoodsType", strGoodsType ) .. " " ..PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_8")		-- 경매가 종료되었습니다.		
		else
			_PA_ASSERT(false, "작업해주세요");
		end
	else
		_PA_ASSERT(false, "작업해주세요");
	end
	
	Panel_MyHouseNavi_Update( true )

	local message = { main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION_MSG_MAIN", "strGoodsType", strGoodsType ), sub = msg, addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( message, 3, 7 )
end

function EventNotifyBidAuctionGoods( goodsType, param1, param2 )
	if(  goodsType == 2 ) then
		local text = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_NOTIFYBIDAUCTIONGOODS") -- "길드에서 집을 입찰 하였습니다"
		Proc_ShowMessage_Ack( text );
	end
end

local bidButtonCheck = false
local _buttonInit = function()
	withdrawBidprice	:SetShow( false )
	editBidPrice		:SetShow( false )
	editBidPrice		:SetEditText( "" )
	bidBtn				:SetShow( false )
	if ( true == bidButtonCheck ) then
		txtBidinFinish:SetShow( true )
	else
		txtBidinFinish:SetShow( false )
	end
end

local territoryAuth_AuctionProgress = false
function EventNotifyTerritoryTradeAuthority( msgType, territoryKey, bidPrice )

	-- 메디아 지역 메시지는 잠시 막아둔다!
	-- if 3 == territoryKey then
		-- return
	-- end
	-- 초기화
	_buttonInit()
	txtBidinFinish:SetShow( false )			-- 임시로 추가

	territoryAuth_AuctionProgress = false
	local territoryName = {
		[0]	= tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),		-- 발레노스령
		[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),		-- 세렌디아령
		[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),		-- 칼페온령
		[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3")),		-- 메디아령
		--[4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_")),		-- 발렌시아령(미정)
	}

	if( msgType == 0 ) then		-- 통보용
		Panel_MyHouseNavi_Update( true )
	elseif( msgType == 1) then	--입찰에 대한응답
		local strDesc = territoryName[territoryKey] .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_1")
		-- "영지 무역(황실 무역) 권한을 입찰하였습니다."

		Proc_ShowMessage_Ack( strDesc )	-- 다이얼로그 안이기 때문에 나크메시지로 쓴다.
		
	elseif( msgType == 2) then	-- 내가 입찰 했는지에 대한 응답
	
		TerritoryAuth_Auction_ShowToggle()
	
		local myAuctionInfo = RequestGetAuctionInfo()
		local tempPrice		= myAuctionInfo:getTerritoryTradeBidPrice()
	
		if  Defines.s64_const.s64_0 < tempPrice	then -- 이미 입찰을 했다
			local strbid = "<PAColor0xFF96D4FC>" .. makeDotMoney( bidPrice ) .. "<PAOldColor> " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_2")		--" 실버로 이미 입찰하였습니다."
			txtBidinFinish:SetShow( true )
			txtBidinFinish:SetText( strbid )
		else										-- 입찰하지 않았다
			editBidPrice:SetEditText("")
			editBidPrice:SetShow(true);	
			bidBtn:SetShow(true);
		end
		TerritoryAuth_UpdateData()	

	elseif( msgType == 3) then	-- 경매가 끝나고 권한이 낙찰되었을때
		local strDesc = territoryName[territoryKey].. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_3")
		--" 영지 무역(황실 무역) 권한을 얻었습니다."
		local message = { main = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_IMPERIAL_BID"), sub = strDesc, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 3, 7 )
				
	elseif( msgType == 4) then	-- 경매가 끝난후 권한이 반납되었을때
		local strDesc = territoryName[territoryKey].. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_4")
		--" 영지 무역(황실 무역) 권한을 반납하였습니다."
		local message = { main = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_IMPERIAL_RETURN"), sub = strDesc, addMsg = "" }
		Proc_ShowMessage_Ack_For_RewardSelect( message, 3, 7 )
	
	elseif( msgType == 5) then	-- 예전 경매에서 입찰데이터가 있을 경우, 돈을 찾아가게한다.
		TerritoryAuth_Auction_ShowToggle()
		withdrawBidprice:SetShow(true);
		
		withdrawBidprice	:addInputEvent( "Mouse_LUp", "Button_TerritoryTradeAuctionWithdrawMoney_Click(" .. bidPrice .. ")" )		-- 입찰금 회수 버튼 클릭 이벤트
		TerritoryAuth_UpdateData()	
		
	elseif( msgType == 6 )	then -- 경매가 진행중이지 않을때, 다음 경매까지 남은시간 출력	
		
		Panel_TerritoryAuth_Auction:SetShow( true, true );
		territoryAuth_AuctionProgress = true
		TerritoryAuth_UpdateData()	

	end
	
	Panel_MyHouseNavi_Update( true )
	txtExplain:SetText( territoryName[territoryKey] .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_5"))
	--" 영지의 황실 무역 권한을 획득하면 위 물품들을 구매하여 다른 영지의 황실 무역 담당자와 자유롭게 거래할 수 있습니다. <PAColor0xFFDB2B2B>※ 입찰에 실패하면 입찰금은 입찰 NPC에게서 되돌려 받습니다.<PAOldColor>")

end

function FromClientNotifySupplyTradeStart()
	if isEnableSupplyTrade then
		return
	end
	local msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_IMPERIAL_START"), sub = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_10"), addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( msg, 3, 8 )
end

function FromClientNotifySupplyShopReset()
	local msg = { main = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_MSG_MAIN"), sub = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_MSG_SUB"), addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( msg, 3, 8 )
end

function TerritoryAuth_UpdateData()
	
	local myAuctionInfo = RequestGetAuctionInfo()
	local itemCount		= myAuctionInfo:getTerritoryTradeItemCount()
	local sizeX 		= slotBG:GetSizeX()					-- 아이콘 영역 사이즈(기본 50)
	local gap 			= sizeX * (3/5)						-- 아이콘 간격(기본 30)
	local startPosX 	= ( Panel_TerritoryAuth_Auction:GetSizeX() - ( sizeX * itemCount + gap * ( itemCount - 1))) / 2			-- 아이콘 시작 위치
	
	if 0 < itemCount then
		local tradeCount = 0
		for i=0, itemCount-1 do
			local itemStaticWrapper = myAuctionInfo:getTerritoryTradeitem(i)
	
			if nil ~= itemStaticWrapper then
				slots[i]:setItemByStaticStatus( itemStaticWrapper )
				tradeCount = tradeCount + 1
				slots[i].icon:addInputEvent("Mouse_On", "TerritoryAuth_Tooltip_Show(" .. i .. ")")
				slots[i].icon:addInputEvent("Mouse_Out", "TerritoryAuth_Tooltip_Hide(" .. i .. ")")
				
				Panel_Tooltip_Item_SetPosition( i, slots[i], "TerritoryAuth_Auction" );

				local posX = startPosX + ( sizeX + gap ) * i
				slots[i].icon:SetPosX( posX )
				slots[i].icon:SetPosY( sizeX * (6/5) )
				slot_BG[i]:SetPosX( -4 )
				slot_BG[i]:SetPosY( -4 )
				slot_BG[i]:SetShow( true )
			else
				slots[i]:clearItem()
				slot_BG[i]:SetShow( false )
			end
		end
	end
	
	-- 남은 시간이랑 짤려도 상관 없다 생각하고 64 -> 32 로 형 변환 한다.
	local s64_remainTime = myAuctionInfo:getTerritoryTradeAuctionRemainTime();
	local tempStr = ""
	
	if ( true == territoryAuth_AuctionProgress ) then
		tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_11") .. " : ".. TerritoryAuth_TimeFormatting( math.floor(Int64toInt32(s64_remainTime) / 1000 ))
	else
		tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_12") .. " : ".. TerritoryAuth_TimeFormatting( math.floor(Int64toInt32(s64_remainTime) / 1000 ) )
	end
	
	txtRemainTime:SetText(tempStr);
	txtRemainTime:SetShow( false )
		
end

function TerritoryAuth_TimeFormatting( second )
	local formatter =
	{
		[0]	= PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE"),
		[1] = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR"),
		[2] = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
	}
	--"분", "시간", "일"

	local timeVal = {}
	timeVal[0] = math.floor( second / 60 )				-- '분'으로 환산
	timeVal[1] = math.floor( timeVal[0] / 60 )			-- '시간'으로 환산
	timeVal[2] = math.floor( timeVal[1] / 24 )			-- '일'로 환산
	
	local resultString = ""
	if ( 0 < timeVal[2] ) then
		resultString = timeVal[2] .. formatter[2]
	end
	if ( 0 < timeVal[1] ) then
		resultString = resultString .. " " .. timeVal[1] % 24 .. formatter[1]
	end
	if ( 0 < timeVal[0] ) then
		resultString = resultString .. " " .. timeVal[0] % 60 .. formatter[0]
	end
	if ( 60 > second ) then
		resultString = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_UNDER_ONEMINUTE") -- "1분 미만"
	end
	
	return( resultString )
end

function Button_TerritoryAuthAuctionClose_Click()

	TerritoryAuth_Auction_ShowToggle()

end

function Button_TerritoryAuthAuctionBid_Click()
	if ( "" == editBidPrice:GetEditText() ) then
		return
	end

	local	messageBoxMemo	= makeDotMoney(tonumber(editBidPrice:GetEditText())) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_13")
	local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_14"), content = messageBoxMemo, functionYes = TerritoryAuth_BidAccept, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function TerritoryAuth_BidAccept()
	requestBidTerritoryTradeAuth( editBidPrice:GetEditText() )
	bidButtonCheck = true
	local selfMoney	= Int64toInt32( getSelfPlayer():get():getInventory():getMoney_s64() )			-- 내가 소유한 돈
	local _bidMoney	= tonumber( editBidPrice:GetEditText() )										-- 입찰한 돈
	if ( minBid <= _bidMoney ) and ( _bidMoney <= selfMoney ) then
		txtBidinFinish:SetShow( false )
		editBidPrice:SetShow( false )
		bidBtn:SetShow( false )
		TerritoryAuth_Auction_ShowToggle()
	else
		txtBidinFinish:SetShow( false )
	end
end



function Button_TerritoryTradeAuctionWithdrawMoney_Click( bidPrice )
	
	requestWithdrawFailbidPriceForTerritoryTrade()
	TerritoryAuth_Auction_ShowToggle()
	
	local message = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_RETURN_MONEY", "bidPrice", makeDotMoney(bidPrice) ) -- "입찰금 <PAColor0xFF96D4FC>" .. makeDotMoney(bidPrice) .. "<PAOldColor> 실버를 돌려받았습니다."
	Proc_ShowMessage_Ack_WithOut_ChattingMessage( message )

end

function TerritoryAuth_Auction_ShowToggle()
	if Panel_TerritoryAuth_Auction:GetShow() then
		Panel_TerritoryAuth_Auction:SetShow( false, false )
		bidButtonCheck = false
	else
		Panel_TerritoryAuth_Auction:SetShow( true, true )
	end
end

function TerritoryAuth_Auction_Close()
	Panel_TerritoryAuth_Auction:SetShow( false, false )
end

function TerritoryAuth_CreateSlot()
	for i=0, maxCount-1 do
		local slot={}
		SlotItem.new( slot, 'Territory_' .. i, i, Panel_TerritoryAuth_Auction, slotConfig )
		slot:createChild()
		slots[i] = slot
		
		local tempItemSlotBG = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.icon, "Static_Slot_".. i )
		CopyBaseProperty( slotBG, tempItemSlotBG )
		slot_BG[i] = tempItemSlotBG
		slot_BG[i]:SetShow( false )
	end
end

function TerritoryAuth_Tooltip_Show( slotNo )
	Panel_Tooltip_Item_Show_GeneralStatic( slotNo, "TerritoryAuth_Auction", true )
end

function TerritoryAuth_Tooltip_Hide( slotNo )
	Panel_Tooltip_Item_Show_GeneralStatic( slotNo, "TerritoryAuth_Auction", false )
end


_buttonQuestion = UI.getChildControl( Panel_TerritoryAuth_Auction, "Button_Question" )						--물음표 버튼
_buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritoryAuth\" )" )				--물음표 좌클릭
_buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"TerritoryAuth\", \"true\")" )		--물음표 마우스오버
_buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"TerritoryAuth\", \"false\")" )		--물음표 마우스아웃

TerritoryAuth_CreateSlot()
registerEvent( "onScreenResize",						"TerritoryAuth_Resize" )
registerEvent( "EventNotifyTerritoryTradeAuthority",	"EventNotifyTerritoryTradeAuthority" )
registerEvent( "FromClientNotifySupplyTradeStart",		"FromClientNotifySupplyTradeStart" )
registerEvent( "FromClient_ResponseAuctionInfo",		"EventNotifyResponseAuctionInfo" )
registerEvent( "FromClient_BidAuctionGoods",			"EventNotifyBidAuctionGoods" )
registerEvent( "FromClientNotifySupplyShopReset", 		"FromClientNotifySupplyShopReset" )


---------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------


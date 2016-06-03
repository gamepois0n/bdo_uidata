local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM 		= CppEnums.TextMode


local _staticDescBG		= UI.getChildControl ( Panel_HelpMessage, "Static_DescBG")
local _staticTextDesc		= UI.getChildControl ( Panel_HelpMessage, "StaticText_Desc")

_staticTextDesc:SetShow(true)
_staticTextDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
_staticDescBG:SetShow(true)


--	물음표에 마우스오버하면 어떤 UI창인지 확인 후, 툴팁 텍스트 변경
function HelpMessageQuestion_Show( where, isTrue )
	
	if where=="PanelImportantKnowledge" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Knowledge") ) -- 지식에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelAlchemy" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Alchemy") ) -- 연금술에 대한 도움말을 확인할 수 있습니다.

	elseif where=="PanelCook" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Cook") ) -- 요리에 대한 도움말을 확인할 수 있습니다.

	elseif where=="PanelManufacture" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Product") ) -- 생산 활동에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="HouseAuction" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HouseAuction") ) -- 집 경매에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelAuction" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Auction") ) -- 경매에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelHouseAuction" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HouseAuction") ) -- 집 경매에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelBuyDrink" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Alcohol") ) -- 술 한잔의 결과 창에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="DeliveryCarriageinformation" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Goods") ) -- 화물 정보에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="DeliveryInformation" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Trans") ) -- 운송 현황에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="DeliveryPerson" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Char_Trans") ) -- 캐릭터 운송에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="DeliveryRequest" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Sent_Receipt") ) -- 발송 접수에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="SpiritEnchant" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_PotenBreak") ) -- -- 잠재력 돌파에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowEquipment" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Equip") ) -- 장비 창에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelExchangeWithPC" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Person_Deal") ) -- 개인 거래에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowExtractionCrystal" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Extraction") ) -- 수정 추출에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowExtractionEnchantStone" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Stone_Extraction") ) -- 강화석 추출에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelGameExit" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Game_Exit") ) -- 게임 종료에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelGuild" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Guild") ) -- 길드 창에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelClan" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Clan") ) -- 클랜 창에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="HouseList" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Get_House") ) -- 집 보유 목록에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelHouseControl" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_House") ) -- 집에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelHouseInfo" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HouseInfo") ) -- 집 정보에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelInn" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Hotel_Rent") ) -- 여관 임대에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowInventory" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Bag") ) -- 가방에 대한 도움말을 확인할 수 있습니다.
				
	elseif where=="PanelServantInventory" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_BoardingBag") ) -- 탑승물 가방에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelLordMenu" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Seignior") ) -- 영주 메뉴에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="Panelmail" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_MailRead") ) -- 편지 읽기에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelMailDetail" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_MailSend") ) -- 편지 읽기에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelMailSend" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_MailSend") ) -- 편지 보내기에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="UIGameOption" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_GameOption") ) -- 게임 설정에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelQuestHistory" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Request") ) -- 의뢰에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelQuestReward" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Request_Reward") ) -- 의뢰 보상에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelFixEquip" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Repair") ) -- 내구도 수리에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelPetSkill" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Obedience") ) -- 조련에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelServantinfo" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_BoardingInfo") ) -- 탑승물 정보에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelEnableSkill" then  
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_GetSkill") ) -- 배울수 있는 스킬에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowSkill" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Skill") ) -- 스킬에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelSkillAwaken" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_SkillAwaken") ) -- 스킬 각성에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="Socket" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_PotenTransition") ) -- 잠재력 전이에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowStableMating" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Mating") ) -- 교배 시장에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowStableMarket" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HorseMarket") ) -- 마시장에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowStableRegister" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Regist") ) -- 등록하기에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWindowStableShop" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Shop") ) -- 상점에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelTradeMarketGraph" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_QuoteStatus") ) -- 시세 현황표에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="HouseManageWork" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_TaskManage") ) -- 작업 관리에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="FarmManageWork" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_TaskManage2") ) -- 작업 관리2에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelWorldMapTownWorkerManage" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_WorkerMange") ) -- 일꾼 관리에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="SelfCharacterInfo" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_MyInfo") ) -- 내 정보에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PanelFriends" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_FriendsList") ) -- 친구 목록에 대한 도움말을 확인할 수 있습니다.
	
	elseif where=="MyVendorList" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_GetShop") ) -- 상점 소유 목록에 대한 도움말을 확인할 수 있습니다.

	elseif where=="HousingConsignmentSale" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Consignment") ) -- 위탁 판매에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="HosingVendingMachine" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_AutoSales") ) -- 자동 판매에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="PartyOption" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_PartySetting") ) -- 파티 설정에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="NodeMenu" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_NodeName") ) -- 노드 명에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="WareHouse" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_WareHouse") ) -- 창고에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="Panel_Farm_ManageWork" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_TaskManage") ) -- 작업 관리에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="NpcShop" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_NpcShop") ) -- NPC 상점에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="HouseRank" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HouseRank") ) -- 집 순위에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="TerritoryAuth" then 
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_ImperialTrade") ) -- 황실 무역 권한 입찰에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="Chatting" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Chatting") ) -- 대화창에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="Worker" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Worker") ) -- "일꾼에 대한 도움말을 확인할 수 있습니다." )
		
	elseif where=="WarInfo" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_WarInfo") ) -- "점령전 현황에 대한 도움말을 확인할 수 있습니다." )
		
	elseif where=="ItemMarket" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_ItemMarket") ) -- "거래소에 대한 도움말을 확인할 수 있습니다." )
	
	elseif where=="Pet" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Pet") ) -- "애완동물에 대한 도움말을 확인할 수 있습니다." )

	elseif where=="ProductNote" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Productnote") ) -- 제작노트에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="Dye" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Dye") ) -- 염색에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="AlchemyStone" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_AlchemyStone") ) -- 연금석에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="LifeRanking" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_LifeRanking") ) -- 생활 순위에 대한 도움말을 확인할 수 있습니다.
		
	elseif where=="ClothExchange" then
		_staticTextDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_ClothExchange") ) -- 의상 교환에 대한 도움말을 확인할 수 있습니다.
		
	end
	
	if isTrue == "true"	then
		HelpMessageQuestion_On()
		
	else
		HelpMessageQuestion_Out()
	end
	
end


--	말풍선 노출
function	HelpMessageQuestion_On()
	
	------------------------------------------------
	-- 마우스 포지션에 따라 화면 분할 변수에 넣는다.
	-- 화면 분할 변수의 변경에 따라 풍선와 대사 위치를 변경한다.
	------------------------------------------------
	if	getMousePosX() <= ( getScreenSizeX() / 2 ) and  getMousePosY() <= ( getScreenSizeY() / 2 ) then			--화면 10시 방향
		
		Panel_HelpMessage:SetPosX(getMousePosX() + 15 )
		Panel_HelpMessage:SetPosY(getMousePosY() + 15 )
	
	
	elseif getMousePosX() > ( getScreenSizeX() / 2 ) and  getMousePosY() <= ( getScreenSizeY() / 2 ) then			--	화면 2시 방향
	
		Panel_HelpMessage:SetPosX(getMousePosX() - 200 )
		Panel_HelpMessage:SetPosY(getMousePosY() + 15 )
		
	elseif  getMousePosX() <= ( getScreenSizeX() / 2 ) and  getMousePosY() > ( getScreenSizeY() / 2 ) then		--	화면8시 방향
	
		Panel_HelpMessage:SetPosX(getMousePosX() + 15 )
		Panel_HelpMessage:SetPosY(getMousePosY() - 90 )
	
	else																																						-- 화면 4시 방향
	
		Panel_HelpMessage:SetPosX(getMousePosX() - 200 )
		Panel_HelpMessage:SetPosY(getMousePosY() - 90 )
	end
	
	Panel_HelpMessage:SetShow(true)
	
	
end


--	말풍선 숨김
function	HelpMessageQuestion_Out()
	Panel_HelpMessage:SetShow(false)
end

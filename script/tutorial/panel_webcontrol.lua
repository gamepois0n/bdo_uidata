local PA_UI 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color 		= Defines.Color
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM			= CppEnums.EProcessorInputMode

Panel_WebControl:RegisterShowEventFunc( true, 'Panel_WebHelper_ShowAni()' )
Panel_WebControl:RegisterShowEventFunc( false, 'Panel_WebHelper_HideAni()' )
Panel_WebControl:setGlassBackground( true )
Panel_WebControl:ActiveMouseEventEffect( true )

local html_WebHelper_Control = UI.createControl( PA_UI.PA_UI_CONTROL_WEBCONTROL, Panel_WebControl, "WebControl_Help_CharInfo" )
local ui = {
	_btn_Close 		= UI.getChildControl ( Panel_WebControl, "Button_Close" ),
	_btn_CloseWin	= UI.getChildControl ( Panel_WebControl, "Button_CloseWindow" ),
	_edit_Question 	= UI.getChildControl ( Panel_WebControl, "Edit_InputQuestion" ),
	_btn_Search 	= UI.getChildControl ( Panel_WebControl, "Button_Search" ),
}

ui._btn_Close:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle()" )
ui._btn_CloseWin:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle()" )


function Panel_WebHelper_ShowToggle( helpType )
	if ( Panel_WebControl:IsShow() ) then
		Panel_WebControl:SetShow( false, true )

		html_WebHelper_Control:ResetUrl()
		return false;
	else
		-- 일본 서비스이면서 CBT상태이면 도움말은 중비중이란 메시지 박스를 띄운다.
		if ( (isGameTypeJapan() or isGameTypeRussia() ) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT ) then
			local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetString(Defines.StringSheet_GAME, "LUA_MSGBOX_COMMON_READY"), functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
			MessageBox.showMessageBox(messageBoxData)
			return false
		end

		if nil == Panel_Login then
			if Panel_WorldMap:GetShow() then
				WorldMapPopupManager:push( Panel_WebControl, true )
			else
				Panel_WebControl:SetShow( true, true )
			end
		else
			Panel_WebControl:SetShow( true, true )
		end
		
		Panel_WebControl_TakeAndShow( helpType )
		return true;
	end
end

function FGlobal_Panel_WebHelper_ShowToggle()
	Panel_WebHelper_ShowToggle( "GUIDE" )
end

------------------------------------------------
--			창 끄고 켜기 애니메이션
------------------------------------------------
function Panel_WebHelper_ShowAni()
	UIAni.fadeInSCR_Down( Panel_WebControl )
	
	local aniInfo1 = Panel_WebControl:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_WebControl:GetSizeX() / 2
	aniInfo1.AxisY = Panel_WebControl:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_WebControl:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_WebControl:GetSizeX() / 2
	aniInfo2.AxisY = Panel_WebControl:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end


function Panel_WebHelper_HideAni()
	-- ♬ 끌 때만 소리가 있는데 이게 맞나?
	audioPostEvent_SystemUi(01,01)
	
	Panel_WebControl:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_WebControl, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end



------------------------------------------------
--				최초 초기화 함수
------------------------------------------------
function Panel_WebControl_Initialize()
	-- 추가할게 있나?
	Panel_WebControl:SetShow( false, false )
	html_WebHelper_Control:SetHorizonCenter()
	html_WebHelper_Control:ResetUrl()
	--html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GUIDE"))
	html_WebHelper_Control:SetSize(960, 600)
	html_WebHelper_Control:SetSpanSize(0, 5)
	html_WebHelper_Control:SetShow(false)	
end

function Panel_WebControl_TakeAndShow( helpType )
	
	Panel_WebControl:SetShow( true, true )
	
	html_WebHelper_Control:SetHorizonCenter()
	
	--------------------------------
	--	게임 정보
	--------------------------------
	if helpType == "GUIDE" then						-- 내 정보
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GUIDE"))
		
	elseif helpType == "SelfCharacterInfo" then						-- 내 정보
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_SELFCHARACTERINFO"))
		
	elseif helpType == "PanelImportantKnowledge"	then		-- 지식
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_PANELIMPORTANTKNOWLEDGE"))
		
	elseif helpType == "PanelWindowEquipment"	then			-- 장비
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_WINDOWEQUIPMENT"))
				
	elseif helpType == "PanelGameExit"	then					-- 게임종료
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_GAMEEXIT"))
		
	elseif helpType == "PanelWindowInventory"	then			-- 가방
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_WINDOWINVENTORY"))
		
	elseif helpType == "UIGameOption"	then					-- 게임옵션
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_GAMEOPTION"))
		
	elseif helpType == "PanelQuestHistory"	then				-- 의뢰
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_QUESTHISTORY"))
		
	elseif helpType == "PanelQuestReward"	then				-- 의뢰 보상
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_QUESTREWARD"))
		
	elseif helpType == "PanelFixEquip"	then					-- 수리
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_FIXEQUIP"))
		
	elseif helpType == "NodeMenu" then							-- 노드
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_NODE"))

	elseif helpType == "NpcShop" then							-- NPC 상점
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_NPCSHOP"))	

	elseif helpType == "PanelBuyDrink"	then					-- 지식 획득법
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_BUYDRINK"))	
		
	elseif helpType == "Chatting" then							-- 대화창 옵션
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_CHATTING"))	

	--------------------------------
	--	생활
	--------------------------------
	elseif helpType == "PanelAlchemy"	then					-- 연금
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_ALCHEMY"))

	elseif helpType == "PanelCook"	then						-- 요리
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_COOK"))	
		
	elseif helpType == "PanelManufacture"	then				-- 가공
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_MANUFACTURE"))		
		
	elseif helpType == "PanelHouseControl"	then				-- 하우스
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_HOUSECONTROL"))
		
	elseif helpType == "PanelTradeMarketGraph"	then			-- 무역
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_TRADEMARKETGRAPH"))
		
	elseif helpType == "TerritoryTrade"	then					-- 황실 무역
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_TERRITORYTRADE"))
		
	elseif helpType == "TerritorySupply"	then				-- 황실 납품
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_TERRITORYSUPPLY"))
		
	elseif helpType == "TerritoryAuth"	then					-- 황실 무역 권한
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_TERRITORYTRADE"))
		
	elseif helpType == "HouseManageWork"	then				-- 작업 관리
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_HOUSEMANAGEWORK"))
		
	elseif helpType == "PanelWorldMapTownWorkerManage"	then	-- 
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_WORLDMAPTOWNWORKERMANAGE"))
		
	elseif helpType == "FarmManageWork" then					--
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_FARMMANAGEWORK"))	
		
	elseif helpType == "PanelWindowHouse" then					-- 하우스
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_WINDOWHOUSE"))
		
	elseif helpType == "PanelWindowTent" then					-- 텃밭
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_WINDOWTENT"))
		
	elseif helpType == "Gathering" then							-- 채집
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_GATHERING"))
	
	elseif helpType == "Pet" then								-- 애완동물
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_PET"))
	
	elseif helpType == "Dye" then								-- 염색
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_DYE"))
		
	elseif helpType == "HouseRank" then							-- 집순위
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_HOUSERANK"))
	
	elseif helpType == "Worker" then							-- 일꾼
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_WORKER"))
		
	elseif helpType == "AlchemyStone" then						-- 연금석
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_ALCHEMYSTONE"))

	elseif helpType == "LifeRanking" then						-- 생활 순위
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFERANKING"))
		
	--------------------------------
	--	편의 기능
	--------------------------------
	elseif helpType == "DeliveryPerson"	then					-- 이동 예약
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_DELIVERYPERSON"))
		
	elseif helpType == "PanelServantinfo"	then				-- 탈것 정보
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_SERVANTINFO"))
		
	elseif helpType == "PanelServantInventory"	then			-- 탈것 가방
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_SERVANTINVENTORY"))
		
	elseif helpType == "PanelWindowStableShop"	then			-- 마굿간
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WINDOWSTABLEMARKET"))
		
	elseif helpType == "PanelWindowStableMarket"	then		-- 마굿간 마시장
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WINDOWSTABLEMARKET"))
		
	elseif helpType == "PanelWindowStableMating"	then		-- 마굿간 교배시장
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WINDOWSTABLEMATING"))
		
	elseif helpType == "PanelWindowStableRegister"	then		-- 탈것 등록
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WINDOWSTABLEREGISTER"))

	elseif helpType == "HousingConsignmentSale" then			-- 위탁 판매
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_HOUSINGCONSIGNMENTSALE"))		

	elseif helpType == "HosingVendingMachine" then				-- 가판대
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_HOUSINGVENDINGMACHINE"))	
		
	elseif helpType == "WareHouse" then							-- 창고
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WAREHOUSE"))	
				
	elseif helpType == "DeliveryInformation"	then			-- 운송 현황
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_DELIVERYINFORMATION"))
		
	elseif helpType == "DeliveryRequest"	then				-- 발송 접수
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_DELIVERYREQUEST"))
		
	elseif helpType == "MyVendorList"	then					-- 내 상점 소유 목록
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_MYVENDORLIST"))
		
	elseif helpType == "ProductNote" then						-- 제작 노트
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_PRODUCTNOTE"))
		
	elseif helpType == "ItemMarket" then						-- 거래소
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_ITEMMARKET"))
	
	elseif helpType == "ClothExchange" then						-- 의상 교환
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CLOTHEXCHANGE"))

	elseif helpType == "QuickSlot" then							-- 퀵슬롯
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_QUICKSLOT"))
	

	--------------------------------
	--	전투
	--------------------------------
	elseif helpType == "SpiritEnchant"	then					-- 잠재력 돌파
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_SPIRITENCHANT"))
		
	elseif helpType == "PanelWindowExtractionCrystal"	then	-- 수정 추출
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_WINDOWEXTRACTIONCRYSTAL"))
		
	elseif helpType == "PanelWindowExtractionEnchantStone"	then	-- 강화석 추출
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_WINDOWEXTRACTIONENCHANTSTONE"))
		
	elseif helpType == "PanelWindowSkill"	then				-- 스킬
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_WINDOWSKILL"))
		
	elseif helpType == "PanelEnableSkill"	then				-- 배울 수 있는 스킬
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_ENABLESKILL"))
		
	elseif helpType == "PanelSkillAwaken"	then				-- 스킬 각성
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_SKILLAWAKEN"))
		
	elseif helpType == "Socket"	then							-- 잠재력 전이
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_SOCKET"))
		
	elseif helpType == "WarInfo"	then					-- 점령전
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_WARINFO"))

		--------------------------------
	--	커뮤니티
	--------------------------------
	elseif helpType == "PanelExchangeWithPC"	then			-- 거래
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_EXCHANGEWITHPC"))				
		
	elseif helpType == "PanelFriends"	then					-- 친구
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_FRIENDS"))
		
	elseif helpType == "PanelClan"	then						-- 클랜
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_CLAN"))
		
	elseif helpType == "PanelGuild"	then						-- 길드
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_GUILD"))
		
	elseif helpType == "PanelLordMenu"	then					-- 영주
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_LORDMENU"))
		
	elseif helpType == "Panelmail"	then						-- 우편
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_MAIL"))
		
	elseif helpType == "PartyOption" then						-- 파티 옵션
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_PARTYOPTION"))	
		
	elseif helpType == "HouseAuction"	then					-- 집 경매(길드 하우스)
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_HOUSEAUCTION"))	
		
	elseif helpType == "PanelMailSend"	then					-- 편지 보내기
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_MAILSEND"))
		
		
	--------------------------------
	--	안쓰는 창들
	--------------------------------
	elseif helpType == "DeliveryCarriageinformation"	then	-- 
		html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Delivery/WebHelper_Delivery_CarriageInformation.html")
		
	elseif helpType == "HouseList"	then						-- 호출하는 곳 없음
		html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/HouseInfo/WebHelper_HouesList.html")
		
	elseif helpType == "PanelHouseInfo"	then					-- 호출하는 곳 없음
		html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/HouseInfo/WebHelper_Panel_HouseInfo.html")
		
	elseif helpType == "PanelInn"	then						-- 기능 사라짐
		html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Inn/WebHelper_Inn.html")
		
	elseif helpType == "PanelMailDetail"	then
		html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Mail/WebHelper_Mail_Detail.html")
		
	elseif helpType == "PanelPetSkill"	then					-- 호출하는 곳 없음
		html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Servant/WebHelper_PetSkill.html")
		
	elseif helpType == "PanelAuction"	then					-- 기능 사라짐
		html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Auction/WebHelper_Panel_Auction.html")		
	else
		html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEGUIDE"))		
	end
	
	html_WebHelper_Control:SetSize(960, 600)
	html_WebHelper_Control:SetPosY( 40 )
	html_WebHelper_Control:SetSpanSize(0, 5)
	html_WebHelper_Control:SetShow(true)	
end


Panel_WebControl_Initialize()

local UI_ANI_ADV 			= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local preUIMode				= Defines.UIMode.eUIMode_InGameCashShop
local UI_SERVICE_RESOURCE	= CppEnums.ServiceResourceType

Panel_IngameCashShop_ChargeDaumCash:SetShow( false )
Panel_IngameCashShop_ChargeDaumCash:setGlassBackground( true )
Panel_IngameCashShop_ChargeDaumCash:ActiveMouseEventEffect( true )

local termsofDaumCash = {
	panelTitle = UI.getChildControl( Panel_IngameCashShop_ChargeDaumCash, "StaticText_Title"),
}

local eCountryType		= CppEnums.CountryType
local gameServiceType	= getGameServiceType()
local isKorea			= (eCountryType.NONE == gameServiceType) or (eCountryType.DEV == gameServiceType) or (eCountryType.KOR_ALPHA == gameServiceType) or (eCountryType.KOR_REAL == gameServiceType) or (eCountryType.KOR_TEST == gameServiceType)
local isNaver			= ( CppEnums.MembershipType.naver == getMembershipType() )


Panel_IngameCashShop_ChargeDaumCash:RegisterShowEventFunc( true, 'Panel_IngameCashShop_ChargeDaumCash_ShowAni()' )
Panel_IngameCashShop_ChargeDaumCash:RegisterShowEventFunc( false, 'Panel_IngameCashShop_ChargeDaumCash_HideAni()' )
-----------------------------------------------------------
--					창 애니메이션 처리
-----------------------------------------------------------
function Panel_IngameCashShop_ChargeDaumCash_ShowAni()
	-- Panel_IngameCashShop_ChargeDaumCash:SetShow(true)
	-- Panel_IngameCashShop_ChargeDaumCash:SetAlpha( 0 )
	UIAni.fadeInSCR_Down( Panel_IngameCashShop_ChargeDaumCash )
	
	local aniInfo1 = Panel_IngameCashShop_ChargeDaumCash:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_IngameCashShop_ChargeDaumCash:GetSizeX() / 2
	aniInfo1.AxisY = Panel_IngameCashShop_ChargeDaumCash:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_IngameCashShop_ChargeDaumCash:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_IngameCashShop_ChargeDaumCash:GetSizeX() / 2
	aniInfo2.AxisY = Panel_IngameCashShop_ChargeDaumCash:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_IngameCashShop_ChargeDaumCash_HideAni()
	Panel_IngameCashShop_ChargeDaumCash:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_IngameCashShop_ChargeDaumCash, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
local _btn_Close 		= UI.getChildControl( Panel_IngameCashShop_ChargeDaumCash,	"Button_Close" )
local _Web 				= nil
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
--					최초 초기화 함수
------------------------------------------------------------
function Panel_IngameCashShop_ChargeDaumCash_Initialize()
	_Web = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_IngameCashShop_ChargeDaumCash, 'WebControl_ChargeDaumCash_WebLink' )
	_Web:SetShow( true )
	_Web:SetPosX( 43 )
	_Web:SetPosY( 63 )
	_Web:SetSize( 917, 586 )
	_Web:ResetUrl()
end
Panel_IngameCashShop_ChargeDaumCash_Initialize()

------------------------------------------------------------
--						오픈
------------------------------------------------------------
function chargeDaumCash_Open()
	local self = termsofDaumCash
	local url = nil
	local langType = "EN"
	if UI_SERVICE_RESOURCE.eServiceResourceType_EN == getGameServiceResType() then
		langType = "EN"
	elseif UI_SERVICE_RESOURCE.eServiceResourceType_FR == getGameServiceResType() then
		langType = "FR"
	elseif UI_SERVICE_RESOURCE.eServiceResourceType_DE == getGameServiceResType() then
		langType = "DE"
	end

	if isGameServiceTypeKorReal()  then	-- 결제를 한다.
		if isNaver then
			url = "http://black.game.naver.com/black/billing/shop/index.daum"
		else
			url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_URL1")
		end
	elseif (CppEnums.GameServiceType.eGameServiceType_DEV == getGameServiceType()) then
		url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_URL2")
	elseif isGameTypeEnglish() then
		if (CppEnums.GameServiceType.eGameServiceType_NA_ALPHA == getGameServiceType()) then	-- 북미 테스트
			url = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_NA_TEST", "langType", langType )
		elseif (CppEnums.GameServiceType.eGameServiceType_NA_REAL == getGameServiceType()) then	-- 북미 리얼 라이브 서버
			url = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_NA_REAL", "langType", langType )
		end
	else	-- 한국, 북미를 제외한 다른 국가 조건이다.
		url = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_URL_URL2")
	end

	-- 한국이면 결제 페이지는 강제로 IE로 띄운다.
	local exeIE = true
	if isGameTypeKorea() then
		exeIE = true
	else
		exeIE = false
	end
	ToClient_OpenChargeWebPage(url, exeIE)
	local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_NOTIFY_CHARGEDAUMCASH")  
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = IngameCashShop_ChargeComplete, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}	
	
	MessageBox.showMessageBox(messageBoxData)
	
	--_Web:SetSize( 917, 600 )
	--_Web:ResetUrl()
	--_Web:SetUrl( 917, 600, url )
	--self.panelTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CHARGEDAUMCASH_PANELTITLE") )-- "다음캐쉬 충전")
	
	-- 다음 캐시 요청창을 띄울 때 캐시 요청을 다시 하라고 설정한다.
	--{
	--	local	selfProxy	= getSelfPlayer():get()
	--	local	cash		= selfProxy:setRefreshCash()
	--}

	--Panel_IngameCashShop_ChargeDaumCash:SetShow( true, true )
end

function IngameCashShop_ChargeComplete()
	ToClient_ChargeComplete()
	InGameShop_RefreshCash()
end

function chargeDaumCash_Close()
	--_Web:ResetUrl()
	-- ♬ 창이 꺼질 때 소리
	audioPostEvent_SystemUi(13,05)
	Panel_IngameCashShop_ChargeDaumCash:SetShow( false, false )
end

function HandleClicked_ChargeDaumCash_Close()

	-- 충전 Url 창을 닫을때 캐시 요청을 보낸다.
	--{
		if not isNaver then
			cashShop_requestCash()
		end
	--}

	chargeDaumCash_Close()
end

--캐시 충전 버튼을 눌렀다.
function FGlobal_BuyDaumCash()
	chargeDaumCash_Open()
end

function	FromClient_NeedPublishCash()
	local messageboxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_NEEDPUBLISHCASH") -- "캐쉬가 부족합니다. 충전하시겠습니까?"
	local messageboxData	= { title = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYPEARLBOX_CONFIRM"), content = messageboxMemo, functionYes = FGlobal_BuyDaumCash, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
_btn_Close			:addInputEvent( "Mouse_LUp", "HandleClicked_ChargeDaumCash_Close()" )
registerEvent( "FromClient_NeedPublishCash",			"FromClient_NeedPublishCash" 			)
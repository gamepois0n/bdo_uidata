local _collect_100per = UI.getChildControl ( Panel_Collect_Bar, "Static_100per" )
local _product_100per = UI.getChildControl ( Panel_Product_Bar, "Static_100per" )
local _enchant_100per = UI.getChildControl ( Panel_Enchant_Bar, "Static_100per" )
local _casting_100per = UI.getChildControl ( Panel_Casting_Bar, "Static_Effect_BG" )

local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV			= CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT			= CppEnums.PAUI_TEXTURE_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 		= Defines.Color

local _collectText = UI.getChildControl ( Panel_Collect_Bar, "StaticText_CollectingNow" )
--
-- 프로그래스 바 관련
--
---------------------------
-- Panel Init
---------------------------
Panel_Collect_Bar:SetShow(false, false);
Panel_Product_Bar:SetShow(false, false);
Panel_Enchant_Bar:SetShow(false, false);
Panel_Casting_Bar:SetShow(false, false);


Panel_Collect_Bar:RegisterShowEventFunc( true, 'CollectBarShowAni()' )
Panel_Collect_Bar:RegisterShowEventFunc( false, 'CollectBarHideAni()' )

function CollectBarShowAni()
	Panel_Collect_Bar:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local CollectBar_Alpha = Panel_Collect_Bar:addColorAnimation( 0.0, 0.05, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	CollectBar_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	CollectBar_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	CollectBar_Alpha.IsChangeChild = true
end
function CollectBarHideAni()
	Panel_Collect_Bar:SetShow(false, false)
end


Panel_Product_Bar:RegisterShowEventFunc( true, 'ProductBarShowAni()' )
Panel_Product_Bar:RegisterShowEventFunc( false, 'ProductBarHideAni()' )

function ProductBarShowAni()
	Panel_Product_Bar:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local CollectBar_Alpha = Panel_Product_Bar:addColorAnimation( 0.0, 0.05, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	CollectBar_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	CollectBar_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	CollectBar_Alpha.IsChangeChild = true
end
function ProductBarHideAni()
	Panel_Product_Bar:SetShow(false, false)
end


Panel_Enchant_Bar:RegisterShowEventFunc( true, 'EnchantBarShowAni()' )
Panel_Enchant_Bar:RegisterShowEventFunc( false, 'EnchantBarHideAni()' )

function EnchantBarShowAni()
	Panel_Enchant_Bar:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local CollectBar_Alpha = Panel_Enchant_Bar:addColorAnimation( 0.0, 0.05, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	CollectBar_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	CollectBar_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	CollectBar_Alpha.IsChangeChild = true
end
function EnchantBarHideAni()
	Panel_Enchant_Bar:SetShow(false, false)
end


Panel_Casting_Bar:RegisterShowEventFunc( true, 'CastingBarShowAni()' )
Panel_Casting_Bar:RegisterShowEventFunc( false, 'CastingBarHideAni()' )

function CastingBarShowAni()
	Panel_Casting_Bar:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local casting_Alpha = Panel_Casting_Bar:addColorAnimation( 0.0, 0.05, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	casting_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	casting_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	casting_Alpha.IsChangeChild = true
end
function CastingBarHideAni()
	Panel_Casting_Bar:SetShow(false, false)
end

---------------------------
-- Local Variables
---------------------------

local collectBar =
{
	_progressText,
	_progressControl,
	_progressTime,
	_currentTime,
	_endEventFunction = nil, -- 필요할 경우 설정한다.
	_checkActionFunction = nil,
	_useType = 0
}

local productBar =
{
	_progressText,
	_progressControl,
	_progressTime,
	_currentTime,
	_endEventFunction = nil, -- 필요할 경우 설정한다.
}

local enchantBar =
{
	_progressText,
	_progressControl,
	_progressTime = 0,
	_currentTime = 0,
	_endEventFunction = nil, -- 필요할 경우 설정한다.
}

local castingBar =
{
	_progressControl = nil,
	_progressTime = 0,
	_currentTime = 0,
	_endEventFunction = nil, -- 필요할 경우 설정한다.
}

---------------------------
-- Functions
---------------------------

----------------------------------------------------------------------------
-- 채집 ProgressBar
-----------------------------------------------------------------------------
function collectBar:Init()

	collectBar._titleText 		= UI.getChildControl(Panel_Collect_Bar, "StaticText_CollectingNow")
	collectBar._progressText 	= UI.getChildControl(Panel_Collect_Bar, "StaticText_Bar")
	collectBar._progressControl = UI.getChildControl(Panel_Collect_Bar, "Progress2_1")

end

function collectBar:Show( isShow, progressTime, endFunction, checkFunction )

	if ( true == isShow ) then
		Panel_Collect_Bar:SetShow(true, true);
	--	Panel_Collect_Bar:SetProcess( true );

		collectBar._progressControl:SetShow(true)
		collectBar._progressTime 	= progressTime;
		collectBar._currentTime		= 0;

		local strTemp = string.format( "%.1f", progressTime);
		collectBar._progressText:SetText( strTemp );
		collectBar._progressControl:SetProgressRate( 0 );
		collectBar._endEventFunction = endFunction;
		collectBar._checkActionFunction = checkFunction
	else
		collectBar:Stop();
	end

end

function collectBar:Update( fDeltaTime )
	if( 0 == collectBar._progressTime ) then
		return;
	end
	
	if( nil ~= collectBar._checkActionFunction ) then
		if( false == collectBar._checkActionFunction() ) then
			collectBar:Stop();
		end
	end
	
	local nextTime = collectBar._currentTime + fDeltaTime;
	collectBar._currentTime = nextTime;

	local percent = nextTime / collectBar._progressTime * 100

	if( 100 < percent ) then
		if( nil ~= collectBar._endEventFunction ) then
			collectBar._endEventFunction()
		end
		collectBar:Stop();
	else
		local remainTime = collectBar._progressTime - collectBar._currentTime;
		local strTemp = string.format( "%.1f", remainTime);
		collectBar._progressText:SetText( strTemp );
		collectBar._progressControl:SetProgressRate( percent );
		
		if( collectBar._useType == 1) then
			local curEndurance = repair_getSelfRepairItemEndurance()
			local strEndurance = string.format( "%d", curEndurance )
			--local tempString =  ("수리중.. 현재내구도 : ")..curEndurance			--	수리중.. 현재내구도
			collectBar._titleText:SetText(PAGetStringParam1( Defines.StringSheet_GAME, "PANEL_PROGRESSBAR_REPAIRING_P1", "endurance", strEndurance ));
			Manufacture_UpdateRepairTime();
		end
		
	end
end

function collectBar:Stop()
	collectBar._progressTime 	= 0;
	collectBar._endEventFunction	= nil;
	collectBar._checkActionFunction  = nil;
	collectBar._progressControl:SetShow(false)
--	Panel_Collect_Bar:SetProcess( false );

	if ( true == Panel_Collect_Bar:IsShow() ) then
		-- _collect_100per:ResetVertexAni()
		_collect_100per:SetVertexAniRun( "Ani_Color_100per_0", true )
		-- 꺼준다
		Panel_Collect_Bar:SetShow(false, true)
	end

	-- Panel_Collect_Bar:SetShow(false, false);
end


----------------------------------------------------------------------------
-- 제작 ProgressBar
----------------------------------------------------------------------------
function productBar:Init()

	productBar._titleText = UI.getChildControl(Panel_Product_Bar, "StaticText_ProductNow")
	productBar._progressText = UI.getChildControl(Panel_Product_Bar, "StaticText_Bar");
	productBar._progressControl = UI.getChildControl(Panel_Product_Bar, "Progress2_1")

end

function productBar:Show( isShow, progressTime, endFunction )

	if ( true == isShow ) then
		Panel_Product_Bar:SetShow(true, true)
--		Panel_Product_Bar:SetProcess(true)
		productBar._progressControl:SetShow(true)
		productBar._progressTime 	= progressTime
		productBar._currentTime		= 0
		local strTemp = string.format( "%.1f", progressTime)
		productBar._progressText:SetText( strTemp )
		productBar._progressControl:SetProgressRate( 0 )
		productBar._endEventFunction = endFunction
	else
		productBar:Stop()
	end
end

function productBar:Update( fDeltaTime )
	if( 0 == productBar._progressTime ) then
		return
	end

	local nextTime = productBar._currentTime + fDeltaTime
	productBar._currentTime = nextTime

	local percent = nextTime / productBar._progressTime * 100
	if( 100 < percent ) then
		if( nil ~= productBar._endEventFunction ) then
			productBar._endEventFunction()
		end
		-- _product_100per:ResetVertexAni()
		_product_100per:SetVertexAniRun( "Ani_Color_100per_0", true )

	-- 꺼준다
		Panel_Product_Bar:SetShow(false, true)
		productBar:Stop()
	else
		local remainTime = productBar._progressTime - productBar._currentTime
		local strTemp = string.format( "%.1f", remainTime)
		productBar._progressText:SetText( strTemp )
		productBar._progressControl:SetProgressRate( percent )
	end

end

function productBar:Stop()
	productBar._progressTime 	= 0
	productBar._endEventFunction	= nil
	productBar._progressControl:SetShow(false)
--	Panel_Product_Bar:SetProcess(false)

	if ( true == Panel_Product_Bar:IsShow() ) then
		-- _product_100per:ResetVertexAni()
		_product_100per:SetVertexAniRun( "Ani_Color_100per_0", true )

	-- 꺼준다
		Panel_Product_Bar:SetShow(false, true)
	end
end



----------------------------------------------------------------------------
-- 강화 ProgressBar
----------------------------------------------------------------------------
function enchantBar:Init()
	enchantBar._titleText 		= UI.getChildControl ( Panel_Enchant_Bar, "StaticText_ProductNow")
	enchantBar._progressText 	= UI.getChildControl ( Panel_Enchant_Bar, "StaticText_Bar")
	enchantBar._progressControl = UI.getChildControl ( Panel_Enchant_Bar, "Progress2_1")
	progress_Enchant			= UI.getChildControl ( Panel_Enchant_Bar, "Progress2_1" )
	progress_Enchant_Head		= UI.getChildControl ( progress_Enchant, "Progress2_1_Bar_Head" )
end

function enchantBar:Show( isShow, progressTime, endFunction, enchantType )
	progress_Enchant:EraseAllEffect()
	progress_Enchant_Head:EraseAllEffect()
	if ( true == isShow ) then
		if ( enchantType == 0 ) then			-- 무기일 때
			-- progress_Enchant:SetColor ( UI_color.C_FF002A56 )
			-- progress_Enchant:ResetVertexAni()
			progress_Enchant:SetVertexAniRun( "Ani_Color_Weapon", true )
		elseif ( enchantType == 1 ) then		-- 방어구일 때
			-- progress_Enchant:SetColor ( UI_color.C_FFD20000 )
			-- progress_Enchant:ResetVertexAni()
			progress_Enchant:SetVertexAniRun( "Ani_Color_Armor", true )
		end
		
		Panel_Enchant_Bar:SetShow(true, true)
--		Panel_Enchant_Bar:SetProcess( true )
		enchantBar._progressControl:SetShow(true)
		enchantBar._progressTime 	= progressTime
		enchantBar._currentTime		= 0
		local strTemp = string.format( "%.1f", progressTime)
		enchantBar._progressText:SetText( strTemp )
		enchantBar._progressControl:SetProgressRate( 0 )
		enchantBar._endEventFunction = endFunction
		progress_Enchant:SetNotAbleMasking( true )
		progress_Enchant_Head:SetNotAbleMasking( true )
		progress_Enchant:AddEffect ( "UI_ButtonLineRight_Blue", true, 0, 0 )
	else
		progress_Enchant:EraseAllEffect()
		progress_Enchant_Head:EraseAllEffect()
		enchantBar:Stop()
	end
end

function enchantBar:Update( fDeltaTime )
	if( 0 == enchantBar._progressTime ) then
		return;
	end

	if( false == isEnchantingAction() ) then
		enchantBar:Stop()
		Enchant_CloseButton()
	end
	
	local nextTime = enchantBar._currentTime + fDeltaTime
	enchantBar._currentTime = nextTime
	
	progress_Enchant_Head:AddEffect ( "fUI_Repair01B", true, 0, 0 )
	
	local percent = nextTime / enchantBar._progressTime * 100
	if( 100 < percent ) then
		if( nil ~= enchantBar._endEventFunction ) then
			enchantBar._endEventFunction()
		end
		-- _enchant_100per:ResetVertexAni()
		_enchant_100per:SetVertexAniRun( "Ani_Color_100per_0", true )

	-- 꺼준다
		enchantBar:Stop()
	else
		local remainTime = enchantBar._progressTime - enchantBar._currentTime
		local strTemp = string.format( "%.1f", remainTime)
		enchantBar._progressText:SetText( strTemp )
		enchantBar._progressControl:SetProgressRate( percent )
	end

end

function enchantBar:Stop()
	enchantBar._progressTime 	= 0;
	enchantBar._endEventFunction	= nil
	enchantBar._progressControl:SetShow(false)
--	Panel_Enchant_Bar:SetProcess( false )

	if ( true == Panel_Enchant_Bar:IsShow() ) then
		-- _enchant_100per:ResetVertexAni()
		_enchant_100per:SetVertexAniRun( "Ani_Color_100per_0", true )

	-- 꺼준다
		Panel_Enchant_Bar:SetShow(false, true)
	end
	-- Panel_Enchant_Bar:SetShow(false, false)
end



----------------------------------------------------------------------------
-- 캐스팅 ProgressBar
-----------------------------------------------------------------------------
function castingBar:Init()
	castingBar._progressControl = UI.getChildControl(Panel_Casting_Bar, "Progress2_SP");
end

function castingBar:Show( isShow, progressTime, endFunction )
	if isShow then
		Panel_Casting_Bar:SetShow(true, true);
--		Panel_Casting_Bar:SetProcess( true )
		castingBar._progressControl:SetShow(true)
		castingBar._progressTime 	= progressTime;
		castingBar._currentTime		= 0;

		castingBar._progressControl:SetProgressRate( 0 );
		castingBar._endEventFunction = endFunction;
	else
		castingBar:Stop();
	end
end

function castingBar:Update( fDeltaTime )
	if( 0 == castingBar._progressTime ) then
		return;
	end

	local nextTime = castingBar._currentTime + fDeltaTime;
	castingBar._currentTime = nextTime;

	local percent = nextTime / castingBar._progressTime * 100;
	if( 100 < percent ) then
		if( nil ~= castingBar._endEventFunction ) then
			castingBar._endEventFunction();
		end
		-- _casting_100per:ResetVertexAni()
		_casting_100per:SetVertexAniRun( "Ani_Color_Start_1", true )

	-- 꺼준다
		Panel_Casting_Bar:SetShow(false, true)

		castingBar:Stop()
	else
		castingBar._progressControl:SetProgressRate( percent );
	end

end

function castingBar:Stop()
	castingBar._progressTime 	= 0;
	castingBar._endEventFunction	= nil;
	castingBar._progressControl:SetShow(false);
--	Panel_Casting_Bar:SetProcess(false)

	if ( true == Panel_Casting_Bar:IsShow() ) then
		-- _enchant_100per:ResetVertexAni()
		_enchant_100per:SetVertexAniRun( "Ani_Color_Start_1", true )

	-- 꺼준다
		Panel_Casting_Bar:SetShow(false, true)
	end
end


----------------------------------------------------------------------------
-- 전역함수
-----------------------------------------------------------------------------
function ProgressBar_Collect_Show( isShow, progressTime, endfuction )
	collectBar:Show( isShow, progressTime, endfuction, nil )
end

function ProgressBar_Product_Show( isShow, progressTime, endfuction )
	productBar:Show( isShow, progressTime, endfuction )
end

function ProgressBar_Enchant_Show( isShow, progressTime, endfuction, enchantType )
	enchantBar:Show( isShow, progressTime, endfuction, enchantType )
end

function ProgressBar_Collect_Update( fDeltaTime )
	collectBar:Update( fDeltaTime )
end

function ProgressBar_Product_Update( fDeltaTime )
	productBar:Update( fDeltaTime )
end

function ProgressBar_Enchant_Update( fDeltaTime )
	enchantBar:Update( fDeltaTime )
end

function ProgressBar_Casting_Update( fDeltaTime )
	castingBar:Update( fDeltaTime )
end

function checkCollectAction()
	return isCollectingAction();
end

function checkBuildTentAction()
	return isDoingAction("BUILD_TENT");
end

function checkTakeDownTentAction()
	return isDoingAction("TAKEDOWN_TENT");
end

function checkTakeDownCannonAction()
	return isDoingAction("TAKEDOWN_CANNON");
end

function checkRepairKingOrLordTentAction()
	return isDoingAction("COMMAND_REPAIR");
end

function checkBuidingUpgradeAction()
	return isDoingAction("BUILDING_UPGRADE");
end

function checkRepairAction()
	return repair_IsRepairingAction();
end

function checkCampfireAction()
	return isDoingAction("CAMPFIRE");
end

function checkCookAction()
	return isDoingAction("ALCHEMYSYSTEM_COOK");
end

function checkReadBookAction()
	return isDoingAction("READ_BOOK");
end

function checkManufactureAction()
	return isManufactureAction();
end

function checkAlchemyAction()
	local isDoing = isDoingAction("ALCHEMYSYSTEM_COOK") or isDoingAction("ALCHEMYSYSTEM_ALCHEMY")
	return isDoing;
end

----------------------------------------------------------------------------
-- 이벤트
-----------------------------------------------------------------------------

function EventProgressBarShow( isShow, progressTime, barType, param )

	local endFunction  = nil;
	local checkActionFunction = nil;
	
	--_PA_LOG("lua_debug" , "EventProgressBarShow : "..tostring(isShow).." "..tostring(barType) );
	
	if( isShow ) then
		if( 0 == barType ) then	-- 캐스팅
			
			castingBar:Show(isShow, progressTime, nil );
			
		elseif( 1 == barType ) then -- 제작
		
			ProgressBar_Product_Show( isShow, progressTime, nil )
	
		elseif( 2 == barType ) then	-- 채집
			
			if(  0 == param ) then	-- 일반 채집
				collectBar._titleText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PROGRESSBAR_COLLECTING" ).."..");		--	채집 중
			elseif( 1 == param ) then
				collectBar._titleText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PROGRESSBAR_HARVEST") );					-- 수확하기
			elseif( 2 == param ) then
				collectBar._titleText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PROGRESSBAR_SEEDS") );					-- 씨앗수확
			elseif( 3 == param ) then		
				collectBar._titleText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PROGRESSBAR_PRUNING") );					-- 가지치기
			elseif( 4 == param ) then
				collectBar._titleText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PROGRESSBAR_WORM") );						-- 벌레잡기
			else 
				collectBar._titleText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PROGRESSBAR_COLLECTING" ).."..");		--	채집 중
			end

			collectBar._useType = 0;
			endFunction = nil;
			checkActionFunction = checkCollectAction;
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction );
		elseif( 3 == barType ) then -- 텐트 설치
			collectBar._titleText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PROGRESSBAR_INSTALL_TENT" ).."..");		--	채집 중
			collectBar._useType = 0;
			endFunction = nil;
			checkActionFunction = checkBuildTentAction;	
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction );
		elseif( 4 == barType ) then -- 텐트 해제
			collectBar._titleText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PROGRESSBAR_REMOVE_TENT" ).."..");		--	채집 중
			collectBar._useType = 0;
			endFunction = nil;
			checkActionFunction = checkTakeDownTentAction;			
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction );
		elseif( 5 == barType ) then -- 캠프 파이어
			collectBar._titleText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PROGRESSBAR_INSTALL_TENT" ).."..");		--	채집 중
			collectBar._useType = 0;
			endFunction = nil;
			checkActionFunction = checkCampfireAction;			
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction );
		elseif( 6 == barType ) then	-- 자가 수리
			collectBar._useType = 1;
			endFunction = nil;
			checkActionFunction = checkRepairAction;			
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction );
		elseif( 7 == barType ) then  -- 요리 하기
			collectBar._titleText:SetText(PAGetString( Defines.StringSheet_GAME, "GAME_MANUFACTURE_COOK" ).."..");		--	요리하기
			collectBar._useType = 0;
			endFunction = Alchemy_Do;
			checkActionFunction = checkCookAction;	
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction );
		elseif( 8 == barType ) then  -- 책 읽기
			collectBar._titleText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PROGRESSBAR_READING" ).."..");		--	독서 중
			collectBar._useType = 0;
			endFunction = nil;
			checkActionFunction = checkReadBookAction;
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction );
		elseif( 9 == barType ) then  -- 연성 하기
			collectBar._titleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PROGRESSBAR_COLLECTBAR_TITLE"));		--	연성 중..
			collectBar._useType = 0;
			endFunction = Alchemy_Do;
			checkActionFunction = checkAlchemyAction;	
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction );
		elseif( 10 == barType )	then
			collectBar._titleText:SetText(PAGetString( Defines.StringSheet_GAME, "PANEL_PROGRESSBAR_REMOVE_CANNON" ).."..");		--	채집 중
			collectBar._useType = 0;
			endFunction = nil;
			checkActionFunction = checkTakeDownCannonAction;			
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction )
		elseif( 11 == barType )	then	-- 성채 수리중
			collectBar._titleText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_PROGRESSBAR_REPAIR") );		-- "성채/지휘소 수리중"
			collectBar._useType = 0;
			endFunction = nil;
			checkActionFunction = checkRepairKingOrLordTentAction;			
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction )
		elseif( 12 == barType )	then	-- 업그레이드 중
			collectBar._titleText:SetText( "업그레이드 중" );		-- "업그레이드 중"
			collectBar._useType = 0;
			endFunction = nil;
			checkActionFunction = checkBuidingUpgradeAction;			
			collectBar:Show(isShow, progressTime, endFunction, checkActionFunction )
		end
	else
		if( 0 == barType ) then
			castingBar:Show(false, 0, nil );
		elseif( 1 == barType ) then
			ProgressBar_Product_Show( false, 0, nil );
		else
			collectBar:Show(false, 0, nil, nil);
		end		
	end
	
	
end

registerEvent("EventProgressBarShow", 					"EventProgressBarShow" );


----------------------------------------------------------------------------
-- 초기화
-----------------------------------------------------------------------------
Panel_Collect_Bar:RegisterUpdateFunc( "ProgressBar_Collect_Update" );
Panel_Product_Bar:RegisterUpdateFunc( "ProgressBar_Product_Update" );
Panel_Enchant_Bar:RegisterUpdateFunc( "ProgressBar_Enchant_Update" );
Panel_Casting_Bar:RegisterUpdateFunc( "ProgressBar_Casting_Update" );

collectBar:Init();
productBar:Init();
enchantBar:Init();
castingBar:Init();

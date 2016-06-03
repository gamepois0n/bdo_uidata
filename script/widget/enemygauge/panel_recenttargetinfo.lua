local UCT			= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM			= CppEnums.TextMode
local UI_color 		= Defines.Color
---------------------------
-- Panel Init
---------------------------
--Panel_Monster_Bar:SetShow( true, true )


---------------------------
-- Local Variables
---------------------------
local blackBg								= UI.getChildControl(Panel_Monster_Bar, "Static_blackBG" )
local lua_TargetInfo_Name 					= UI.getChildControl(Panel_Monster_Bar, "Static_Name_TargetName")

-- 일반 몬스터 HP
local lua_TargetInfo_NormalEnemyGauge 		= UI.getChildControl(Panel_Monster_Bar, "EnemyGauge_Back")
local lua_TargetInfo_NormalHpRate 			= UI.getChildControl(Panel_Monster_Bar, "Progress2_TargetHP_Rate")
local lua_TargetInfo_NormalHpRate_Later 	= UI.getChildControl(Panel_Monster_Bar, "Progress2_TargetHP_Rate_Later")
-- 보스 HP
local lua_TargetInfo_BossEnemyGauge 		= UI.getChildControl(Panel_Monster_Bar, "BossEnemyGauge_Back")
local lua_TargetInfo_BossHpRate 			= UI.getChildControl(Panel_Monster_Bar, "BossProgress2_TargetHP_Rate")
local lua_TargetInfo_BossHpRate_Later 		= UI.getChildControl(Panel_Monster_Bar, "BossProgress2_TargetHP_Rate_Later")
-- 플레이어 HP
local lua_TargetInfo_PlayerEnemyGauge 		= UI.getChildControl(Panel_Monster_Bar, "PlayerEnemyGauge_Back")
local lua_TargetInfo_PlayerHpRate 			= UI.getChildControl(Panel_Monster_Bar, "PlayerProgress2_TargetHP_Rate")
local lua_TargetInfo_PlayerHpRate_Later 	= UI.getChildControl(Panel_Monster_Bar, "PlayerProgress2_TargetHP_Rate_Later")

local lua_TargetInfo_StunRate_Back 			= UI.getChildControl(Panel_Monster_Bar, "EnemyGaugeStun_Back")
local lua_TargetInfo_StunRate 				= UI.getChildControl(Panel_Monster_Bar, "Progress2_TargetStun_Rate")

local _stunEffect			 				= UI.getChildControl(Panel_Monster_Bar, "Static_StunMaxEffect")
local lua_EnemyTypeIcon						= UI.getChildControl(Panel_Monster_Bar, "Static_Enemy_TypeIcon")
local lua_EnemyTypeText						= UI.getChildControl(Panel_Monster_Bar, "StaticText_Type")
local monsterBuffIcon_Base					= UI.getChildControl(Panel_Monster_Bar, "Static_EnemyBuffIcon")
local EnemyBuffListBoarder					= UI.getChildControl(Panel_Monster_Bar, "Static_EnemyBuffListBoarder")

local _darkSpirit			 				= UI.getChildControl(Panel_Monster_Bar, "Static_Darkspirit")
local _helpBubble			 				= UI.getChildControl(Panel_Monster_Bar, "Static_HelpBubble")
local _helpMsg				 				= UI.getChildControl(Panel_Monster_Bar, "StaticText_HelpMsg")

local _RunawayBG		 					= UI.getChildControl(Panel_Monster_Bar, "Static_Runaway")
local _txt_Runaway		 					= UI.getChildControl(Panel_Monster_Bar, "StaticText_Runaway")

local lua_EnemyNightIcon = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, EnemyBuffListBoarder, 'monsterNightIcon')
CopyBaseProperty( monsterBuffIcon_Base, lua_EnemyNightIcon )

local elapsedTime = 0.0
local monsterList = {}
local appliedBuff_UIPool = {}
local appliedBuff_UIPool_Last = 0
local appliedBuff_DATAPool = {}
local targetActorKey = 0
isMonsterBarShow = false

--------------------------------------------------------------------------------
-- 툴팁 설정
--------------------------------------------------------------------------------
-- local tooltipBase 	= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_1")
-- local helpWidget	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, Panel_Monster_Bar, "HelpWindow_For_NightBuffIcon" )
-- CopyBaseProperty( tooltipBase, helpWidget )
-- helpWidget:SetColor( ffffffff )
-- helpWidget:SetAlpha( 1.0 )
-- helpWidget:SetFontColor( UI_color.C_FFC4BEBE )
-- helpWidget:SetAutoResize( true )
-- helpWidget:SetTextMode( UI_TM.eTextMode_AutoWrap )
-- helpWidget:SetShow( false )
-- helpWidget:SetTextHorizonCenter()

---------------------------
-- Functions
---------------------------

lua_TargetInfo_NormalEnemyGauge:SetShow( false )
lua_TargetInfo_NormalHpRate:SetShow( false )
lua_TargetInfo_NormalHpRate_Later:SetShow( false )
lua_TargetInfo_BossEnemyGauge:SetShow( false )
lua_TargetInfo_BossHpRate:SetShow( false )
lua_TargetInfo_BossHpRate_Later:SetShow( false )
lua_TargetInfo_PlayerEnemyGauge:SetShow( false )
lua_TargetInfo_PlayerHpRate:SetShow( false )
lua_TargetInfo_PlayerHpRate_Later:SetShow( false )


local getMaxLevel = function()
	local level = 0
	for actorKey,monsterLevel in pairs(monsterList) do
		if level < monsterLevel then
			level = monsterLevel
		end
	end
	return level
end

local updateStunGauge = function( targetActor, stun, maxStun )
	local percents = stun / maxStun * 100
	if ( targetActor:hasStun() ) and ( 0 < stun ) then
		-- local percents = stun / maxStun * 100

		EnemyBuffListBoarder:SetSpanSize( -15, 0 )	-- 버프 아이콘 위치

		lua_TargetInfo_StunRate:SetShow(true)
		lua_TargetInfo_StunRate_Back:SetShow(true)

		lua_TargetInfo_StunRate:SetProgressRate( percents )
		lua_TargetInfo_StunRate:SetCurrentProgressRate( percents )
		return true
	else
		-- ♬ 스턴 게이지가 다 찼을 때 효과음 추가 ( 임의로 추가 )
		-- audioPostEvent_SystemUi(02,03)
		
		_stunEffect:SetShow( true )
		-- _stunEffect:AddEffect( "UI_Monster_StunGauge", false, 0, 0 )
		
		EnemyBuffListBoarder:SetSpanSize( -15, 15 )	-- 버프 아이콘 위치

		lua_TargetInfo_StunRate:SetShow(false)
		lua_TargetInfo_StunRate_Back:SetShow(false)

		-- lua_TargetInfo_StunRate:SetProgressRate( 0 )
		-- lua_TargetInfo_StunRate:SetCurrentProgressRate( 0 )

		return false
	end
end


local nowTarget = {
}

function Panel_MonsterInfo_UpdateStun( actorKey, stun, maxStun )
	if ( targetActorKey == actorKey ) then
		--_PA_LOG("LUA", tostring(stun) .. "   " .. tostring(maxStun) )
		local targetActor = getCharacterActor( actorKey )
		updateStunGauge(targetActor:get(), stun, maxStun)
	end
end
function targetHpInfo_Update_Monster( actorKey, nowHP )
	local targetActor = getCharacterActor( actorKey )
	if nil == targetActor then
		FGlobal_DangerAlert_Show( false )
		return
	end
	
	local monsterLevel = targetActor:get():getCharacterStaticStatus().level
	local playerLevel = getSelfPlayer():get():getLevel()
	
	local levelDiff = (monsterLevel - playerLevel) + 6
	levelDiff = math.max( levelDiff, 1 )
	levelDiff = math.min( levelDiff, 11 )

	-- else	-- 이렇게 걸면 위험 표시할 때 문제가 생긴다.
		_darkSpirit:EraseAllEffect()
		_darkSpirit:SetShow( false )
		_RunawayBG:SetShow( false )
		_txt_Runaway:SetShow( false )
		
		if 4 ~= targetActor:getCharacterGradeType() then
			-- 일반 몬스터 일 때
			----------------------------------------------------------------------------
			-- HP 설정 (지식 유무 처리)
			----------------------------------------------------------------------------
			if ( checkActiveCondition( targetActor:getCharacterKey() ) == true ) then		-- 몬스터에 대한 지식이 있을 경우 체크한다
				_darkSpirit:SetShow( false )
				_helpBubble:SetShow( false )
				_helpMsg:SetShow( false )
				lua_TargetInfo_NormalHpRate:ResetVertexAni()
				lua_TargetInfo_NormalHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
				lua_TargetInfo_NormalHpRate:SetProgressRate( nowHP )

				lua_TargetInfo_NormalHpRate_Later:ResetVertexAni()
				lua_TargetInfo_NormalHpRate_Later:SetVertexAniRun("Ani_Color_Damage_White", true)
				lua_TargetInfo_NormalHpRate_Later:SetProgressRate( nowHP )
				
				-- 기본적으로 100% 텍스쳐 셋팅해준다
				lua_TargetInfo_NormalHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_01.dds")
				local x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 72, 233, 78 )
				lua_TargetInfo_NormalHpRate:getBaseTexture():setUV(  x1, y1, x2, y2  )
				lua_TargetInfo_NormalHpRate:setRenderTexture(lua_TargetInfo_NormalHpRate:getBaseTexture())
				
			else	-- ＃＃＃＃ 지식이 없다!! ＃＃＃＃
				if _darkSpirit:GetShow() then
					_darkSpirit:SetShow( false )
					_helpBubble:SetShow( false )
					_helpMsg:SetShow( false )
				end
				
				if ( playerLevel <= 20 ) then	-- 플레이어 레벨 20까지만 흑정령이 나온다.
					_darkSpirit:SetShow( true )
					_helpBubble:SetShow( true )
					_helpMsg:SetShow( true )
					
					_darkSpirit:EraseAllEffect()
					_darkSpirit:AddEffect( "fUI_DarkSpirit_Tutorial", true, 0, 0 )
					_helpMsg:SetTextMode( UI_TM.eTextMode_AutoWrap )
					_helpMsg:SetAutoResize( true )
					_helpMsg:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ENEMYGAUGE_DARKSPIRIT" ) )	-- 이것에 대한 지식이 없으면 색만 바뀔거야. 지식을 얻으라구!
					_helpBubble:SetSize( _helpBubble:GetSizeX(), _helpMsg:GetSizeY() + 37 )
					_helpMsg:SetPosY( _helpBubble:GetPosY() + 27 )
				end

				lua_TargetInfo_NormalHpRate:ResetVertexAni()
				lua_TargetInfo_NormalHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
				lua_TargetInfo_NormalHpRate:SetProgressRate( 100 )
				
				-- 남은 %에 따라 색을 바꾼다.
				lua_TargetInfo_NormalHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_01.dds")
				local x1, y1, x2, y2
				if ( nowHP > 75.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 72, 233, 78 )
				elseif ( nowHP > 50.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 79, 233, 85 )
				elseif ( nowHP > 25.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 86, 233, 92 )
				elseif ( nowHP > 10.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 93, 233, 99 )
				elseif ( nowHP > 5.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 100, 233, 106 )
				else
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 100, 233, 106 )
				end
				lua_TargetInfo_NormalHpRate:getBaseTexture():setUV( x1, y1, x2, y2 )
				lua_TargetInfo_NormalHpRate:setRenderTexture(lua_TargetInfo_NormalHpRate:getBaseTexture())
			end
		else
			-- 일반 몬스터 이상 일 때(엘리트 부터)
			----------------------------------------------------------------------------
			-- HP 설정 (지식 유무 처리)
			----------------------------------------------------------------------------
			if ( checkActiveCondition( targetActor:getCharacterKey() ) == true ) then		-- 몬스터에 대한 지식이 있을 경우 체크한다
				_darkSpirit:SetShow( false )
				_helpBubble:SetShow( false )
				_helpMsg:SetShow( false )
				lua_TargetInfo_BossHpRate:ResetVertexAni()
				lua_TargetInfo_BossHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
				lua_TargetInfo_BossHpRate:SetProgressRate( nowHP )

				lua_TargetInfo_BossHpRate_Later:ResetVertexAni()
				lua_TargetInfo_BossHpRate_Later:SetVertexAniRun("Ani_Color_Damage_White", true)
				lua_TargetInfo_BossHpRate_Later:SetProgressRate( nowHP )
				
				-- 기본적으로 100% 텍스쳐 셋팅해준다
				lua_TargetInfo_BossHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/EnemyGauge_01.dds")
				local x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_BossHpRate, 1, 20, 212, 32 )
				lua_TargetInfo_BossHpRate:getBaseTexture():setUV(  x1, y1, x2, y2  )
				lua_TargetInfo_BossHpRate:setRenderTexture(lua_TargetInfo_BossHpRate:getBaseTexture())
			else
				if _darkSpirit:GetShow() then
					_darkSpirit:SetShow( false )
					_helpBubble:SetShow( false )
					_helpMsg:SetShow( false )
				end
				
				if ( playerLevel <= 20 ) then	-- 플레이어 레벨 20까지만 흑정령이 나온다.
					_darkSpirit:SetShow( true )
					_helpBubble:SetShow( true )
					_helpMsg:SetShow( true )
					
					_darkSpirit:EraseAllEffect()
					_darkSpirit:AddEffect( "fUI_DarkSpirit_Tutorial", true, 0, 0 )
					_helpMsg:SetTextMode( UI_TM.eTextMode_AutoWrap )
					_helpMsg:SetAutoResize( true )
					_helpMsg:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ENEMYGAUGE_DARKSPIRIT" ) )
					-- 이것에 대한 지식이 없으면 색만 바뀔거야. 지식을 얻으라구!
					_helpBubble:SetSize( _helpBubble:GetSizeX(), _helpMsg:GetSizeY() + 37 )
					_helpMsg:SetPosY( _helpBubble:GetPosY() + 27 )
				end

				lua_TargetInfo_BossHpRate:ResetVertexAni()
				lua_TargetInfo_BossHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
				lua_TargetInfo_BossHpRate:SetProgressRate( 100 )
				
				-- 남은 %에 따라 색을 바꾼다.
				lua_TargetInfo_BossHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/EnemyGauge_01.dds")
				local x1, y1, x2, y2
				if ( nowHP > 75.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_BossHpRate, 1, 20, 212, 32 )
				elseif ( nowHP > 50.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_BossHpRate, 1, 33, 212, 45 )
				elseif ( nowHP > 25.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_BossHpRate, 1, 46, 212, 58 )
				elseif ( nowHP > 10.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_BossHpRate, 1, 59, 212, 71 )
				elseif ( nowHP > 5.0 ) then
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_BossHpRate, 1, 72, 212, 83 )
				else
					x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_BossHpRate, 1, 72, 212, 83 )
				end
				lua_TargetInfo_BossHpRate:getBaseTexture():setUV( x1, y1, x2, y2 )
				lua_TargetInfo_BossHpRate:setRenderTexture(lua_TargetInfo_BossHpRate:getBaseTexture())
			end
		end
	
	-- if ( levelDiff >= 11 ) and (monsterLevel < 99) then -- 갈매기를 화승총으로 죽이는 퀘스트 때문에 임시로 설정해두었음.(갈매기 종류가 레벨 99로 셋팅되어있음)
	if not isNearMonsterAlert() and FromClient_ContactOfStrongMonster() then
		_darkSpirit:SetShow( true )
		_RunawayBG:SetShow( true )
		_txt_Runaway:SetShow( true )
		_helpBubble:SetShow( false )
		_helpMsg:SetShow( false )
		
		_darkSpirit:EraseAllEffect()
		_darkSpirit:AddEffect( "fUI_DarkSpirit_Tutorial", true, 0, 0 )
					
		_txt_Runaway:SetAutoResize( true )
		_txt_Runaway:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ENEMYGAUGE_DARKSPIRIT_RUNAWAY" ) )	-- 달아나 바보야! 네가 감당할 수 있는 수준의 적이 아니라구!
		
		_RunawayBG:SetSize( _txt_Runaway:GetTextSizeX() + 25, _txt_Runaway:GetSizeY() + 37 )
		_RunawayBG:SetPosX( _darkSpirit:GetPosX() - _RunawayBG:GetSizeX() )
		_txt_Runaway:SetPosX( _RunawayBG:GetPosX() + 70 )
		_txt_Runaway:SetPosY( _RunawayBG:GetPosY() + 27 )
		if Panel_Monster_Bar:GetShow() then
			FGlobal_DangerAlert_Show( true )
			FGlobal_ChattingAlert_Call()
		end
	else
		FGlobal_DangerAlert_Show( false )
	end
		
	-- end
end
function targetHpInfo_Update_Player( actorKey, nowHP )
	local targetActor = getCharacterActor( actorKey )
	if nil == targetActor then
		return
	end
	_darkSpirit:SetShow( false )
	_helpBubble:SetShow( false )
	_helpMsg:SetShow( false )
		
	local playerLevel = getSelfPlayer():get():getLevel()
	lua_TargetInfo_PlayerHpRate:ResetVertexAni()
	lua_TargetInfo_PlayerHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
	lua_TargetInfo_PlayerHpRate:SetProgressRate( nowHP )

	lua_TargetInfo_PlayerHpRate_Later:ResetVertexAni()
	lua_TargetInfo_PlayerHpRate_Later:SetVertexAniRun("Ani_Color_Damage_White", true)
	lua_TargetInfo_PlayerHpRate_Later:SetProgressRate( nowHP )
	
	-- -- 기본적으로 100% 텍스쳐 셋팅해준다
	-- lua_TargetInfo_PlayerHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/EnemyGauge_01.dds")
	-- local x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_PlayerHpRate, 1, 72, 233, 78 )
	-- lua_TargetInfo_PlayerHpRate:getBaseTexture():setUV(  x1, y1, x2, y2  )
	-- lua_TargetInfo_PlayerHpRate:setRenderTexture(lua_TargetInfo_PlayerHpRate:getBaseTexture())
end
function targetHpInfo_Update_Other( actorKey, nowHP )
	-- UI.debugMessage("targetHpInfo_Update_Other")
	local targetActor = getCharacterActor( actorKey )
	if nil == targetActor then
		return
	end
	local playerLevel = getSelfPlayer():get():getLevel()
	-- 일반 몬스터 일 때
	----------------------------------------------------------------------------
	-- HP 설정 (지식 유무 처리)
	----------------------------------------------------------------------------
	if ( checkActiveCondition( targetActor:getCharacterKey() ) == true ) then		-- 몬스터에 대한 지식이 있을 경우 체크한다
		_darkSpirit:SetShow( false )
		_helpBubble:SetShow( false )
		_helpMsg:SetShow( false )
		lua_TargetInfo_NormalHpRate:ResetVertexAni()
		lua_TargetInfo_NormalHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
		lua_TargetInfo_NormalHpRate:SetProgressRate( nowHP )

		lua_TargetInfo_NormalHpRate_Later:ResetVertexAni()
		lua_TargetInfo_NormalHpRate_Later:SetVertexAniRun("Ani_Color_Damage_White", true)
		lua_TargetInfo_NormalHpRate_Later:SetProgressRate( nowHP )
		
		-- 기본적으로 100% 텍스쳐 셋팅해준다
		lua_TargetInfo_NormalHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_01.dds")
		local x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 72, 233, 78 )
		lua_TargetInfo_NormalHpRate:getBaseTexture():setUV(  x1, y1, x2, y2  )
		lua_TargetInfo_NormalHpRate:setRenderTexture(lua_TargetInfo_NormalHpRate:getBaseTexture())
	else
		if ( playerLevel <= 20 ) then	-- 플레이어 레벨 20까지만 흑정령이 나온다.
			_darkSpirit:SetShow( true )
			_helpBubble:SetShow( true )
			_helpMsg:SetShow( true )
			
			_darkSpirit:EraseAllEffect()
			_darkSpirit:AddEffect( "fUI_DarkSpirit_Tutorial", true, 0, 0 )
			_helpMsg:SetTextMode( UI_TM.eTextMode_AutoWrap )
			_helpMsg:SetAutoResize( true )
			_helpMsg:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_ENEMYGAUGE_DARKSPIRIT" ) )
			-- 이것에 대한 지식이 없으면 색만 바뀔거야. 지식을 얻으라구!
			_helpBubble:SetSize( _helpBubble:GetSizeX(), _helpMsg:GetSizeY() + 37 )
			_helpMsg:SetPosY( _helpBubble:GetPosY() + 27 )
		else
			_darkSpirit:SetShow( false )
			_helpBubble:SetShow( false )
			_helpMsg:SetShow( false )
		end

		lua_TargetInfo_NormalHpRate:ResetVertexAni()
		lua_TargetInfo_NormalHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
		lua_TargetInfo_NormalHpRate:SetProgressRate( 100 )
		
		-- 남은 %에 따라 색을 바꾼다.
		lua_TargetInfo_NormalHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_01.dds")
		local x1, y1, x2, y2
		if ( nowHP > 75.0 ) then
			x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 72, 233, 78 )
		elseif ( nowHP > 50.0 ) then
			x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 79, 233, 85 )
		elseif ( nowHP > 25.0 ) then
			x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 86, 233, 92 )
		elseif ( nowHP > 10.0 ) then
			x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 93, 233, 99 )
		elseif ( nowHP > 5.0 ) then
			x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 100, 233, 106 )
		else
			x1, y1, x2, y2 = setTextureUV_Func( lua_TargetInfo_NormalHpRate, 1, 100, 233, 106 )
		end
		lua_TargetInfo_NormalHpRate:getBaseTexture():setUV( x1, y1, x2, y2 )
		lua_TargetInfo_NormalHpRate:setRenderTexture(lua_TargetInfo_NormalHpRate:getBaseTexture())
	end
end

function panel_Update_Monster_Info( actorKey )
	-- 일단 끈다.
	lua_TargetInfo_NormalEnemyGauge:SetShow( false )
	lua_TargetInfo_NormalHpRate:SetShow( false )
	lua_TargetInfo_NormalHpRate_Later:SetShow( false )
	lua_TargetInfo_BossEnemyGauge:SetShow( false )
	lua_TargetInfo_BossHpRate:SetShow( false )
	lua_TargetInfo_BossHpRate_Later:SetShow( false )
	lua_TargetInfo_PlayerEnemyGauge:SetShow( false )
	lua_TargetInfo_PlayerHpRate:SetShow( false )
	lua_TargetInfo_PlayerHpRate_Later:SetShow( false )

	local targetActor = getCharacterActor( actorKey )
	if nil == targetActor then
		return
	end
	targetActorKey = actorKey

	local monsterLevel = targetActor:get():getCharacterStaticStatus().level
	local playerLevel = getSelfPlayer():get():getLevel()
	monsterList[targetActorKey] = monsterLevel
	local maxLevel = getMaxLevel()
	-- if monsterLevel < maxLevel then
	-- 	return
	-- end
	elapsedTime = 0.0

	-- local isShowNpcDialog = Panel_Npc_Dialog:GetShow()
	local modecheck = GetUIMode()
	if ( Defines.UIMode.eUIMode_NpcDialog ~= modecheck ) then
		Panel_Monster_Bar:SetShow( true, false )
		FGlobal_Panel_Monster_Bar_RePos()
	else
		isMonsterBarShow = true
	end

	if (targetActor:get():isHiddenName()) then
		lua_TargetInfo_Name:SetShow(false)
	else
		lua_TargetInfo_Name:SetShow(true)
	end

	updateStunGauge(targetActor:get(), targetActor:get():getStun(), targetActor:get():getMaxStun())
	
	EnemyBuffListBoarder:SetShow( true )		-- 버프 박스는 항상 켜두자.

	----------------------------------------------------------------------------
	-- 버프 아이콘 끄기
	----------------------------------------------------------------------------
	for buffIcon_idx = 0, appliedBuff_UIPool_Last do
		if appliedBuff_UIPool[buffIcon_idx] then
			appliedBuff_UIPool[buffIcon_idx]:SetShow( false )
		end
	end

	----------------------------------------------------------------------------
	-- 버프 설정
	----------------------------------------------------------------------------
	local appliedBuff		= targetActor:getAppliedBuffBeginNotSort()
	local appliedBuff_Idx	= 0
	appliedBuff_DATAPool	= {}
	while ( nil ~= appliedBuff ) do
		local appliedBuffType = nil
		-- Pool에 해당 Idx가 있는지 체크하고 없으면 생성.
		if nil == appliedBuff_UIPool[appliedBuff_Idx] then
			local buffIcon = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, EnemyBuffListBoarder, 'monsterBuffIcon_' .. appliedBuff_Idx)
			CopyBaseProperty( monsterBuffIcon_Base, buffIcon )
			appliedBuff_UIPool[appliedBuff_Idx] = buffIcon			-- UI 저장
			if appliedBuff_UIPool_Last < appliedBuff_Idx then		-- 생성된 UI 카운트 갱신
				appliedBuff_UIPool_Last = appliedBuff_Idx
			end
		end

		-- 아이콘 세팅
		appliedBuff_UIPool[appliedBuff_Idx]:ChangeTextureInfoName( "icon/" .. appliedBuff:getIconName() )
		local x1, y1, x2, y2 = setTextureUV_Func( appliedBuff_UIPool[appliedBuff_Idx], 0, 0, 32, 32 )
		appliedBuff_UIPool[appliedBuff_Idx]:getBaseTexture():setUV(  x1, y1, x2, y2  )
		appliedBuff_UIPool[appliedBuff_Idx]:setRenderTexture(appliedBuff_UIPool[appliedBuff_Idx]:getBaseTexture())
		appliedBuff_UIPool[appliedBuff_Idx]:SetShow( true )

		-- 아이콘 위치
		appliedBuff_UIPool[appliedBuff_Idx]:SetSpanSize( appliedBuff_UIPool[appliedBuff_Idx]:GetSizeX()*appliedBuff_Idx , appliedBuff_UIPool[appliedBuff_Idx]:GetSpanSize().y )

		-- 아이콘 부모 콘트롤(가운데 정렬 및 위치 수정용)
		EnemyBuffListBoarder:SetSize( (monsterBuffIcon_Base:GetSizeX()*appliedBuff_Idx) ,EnemyBuffListBoarder:GetSizeY() )
		EnemyBuffListBoarder:ComputePos()

		-- 데이터 저장
		appliedBuff_DATAPool[appliedBuff_Idx]	= appliedBuff
		appliedBuff_Idx							= appliedBuff_Idx + 1
		appliedBuff								= targetActor:getAppliedBuffNextNotSort()
	end
	-- 버프 넘버 초기화
	appliedBuff_Idx = 0

	----------------------------------------------------------------------------
	-- 이름 설정
	----------------------------------------------------------------------------
	lua_TargetInfo_Name:SetText( targetActor:getName() )


	----------------------------------------------------------------------------
	-- HP 설정
	----------------------------------------------------------------------------
	local curHP = targetActor:get():getHp()
	local maxHP = targetActor:get():getMaxHp()
	local nowHP = ( curHP * 100 ) / maxHP
	if curHP < 1 then
		Panel_Monster_Bar:SetShow( false, false )
		monsterList = {}
		FGlobal_DangerAlert_Show( false )
	end

	----------------------------------------------------------------------------
	-- 액터 타입에 따라 HP를 처리한다.
	----------------------------------------------------------------------------
	if targetActor:get():isMonster() then
		-- 몬스터
		targetHpInfo_Update_Monster( actorKey, nowHP )
		_recentTargetInfo_TendencyOnDead_MSG( targetActor, actorKey )	-- 성향이 0 큰 몹을 때리면 경고 메시지
	elseif targetActor:get():isPlayer() then
		-- 플레이어
		targetHpInfo_Update_Player( actorKey, nowHP )
	else
		-- 나머지
		targetHpInfo_Update_Other( actorKey, nowHP )
		_recentTargetInfo_TendencyOnDead_MSG( targetActor, actorKey )	-- 성향이 0 큰 몹을 때리면 경고 메시지
	end

	----------------------------------------------------------------------------
	-- HP 설정 (HP 비공개 캐릭터)
	----------------------------------------------------------------------------
	if (targetActor:get():getCharacterStaticStatus()._isHiddenHp) then
		lua_TargetInfo_NormalEnemyGauge:SetShow(false)
		lua_TargetInfo_NormalHpRate:SetShow(false)
		lua_TargetInfo_NormalHpRate_Later:SetShow(false)
		lua_TargetInfo_StunRate_Back:SetShow(false)
		lua_TargetInfo_StunRate:SetShow(false)
		_darkSpirit:SetShow(false)
		_helpBubble:SetShow(false)
		_helpMsg:SetShow(false)
	else
		if targetActor:get():isMonster() then
			if 4 == targetActor:getCharacterGradeType() then
				lua_TargetInfo_BossEnemyGauge:SetShow( true )
				lua_TargetInfo_BossHpRate:SetShow( true )
				lua_TargetInfo_BossHpRate_Later:SetShow( true )
			else
				lua_TargetInfo_NormalEnemyGauge:SetShow(true)
				lua_TargetInfo_NormalHpRate:SetShow(true)
				lua_TargetInfo_NormalHpRate_Later:SetShow(true)
			end
		elseif targetActor:get():isPlayer() then
			lua_TargetInfo_PlayerEnemyGauge:SetShow( true )
			lua_TargetInfo_PlayerHpRate:SetShow( true )
			lua_TargetInfo_PlayerHpRate_Later:SetShow( true )
		else
			lua_TargetInfo_NormalEnemyGauge:SetShow(true)
			lua_TargetInfo_NormalHpRate:SetShow(true)
			lua_TargetInfo_NormalHpRate_Later:SetShow(true)
		end
		-- lua_TargetInfo_StunRate_Back:SetShow(true)
		-- lua_TargetInfo_StunRate:SetShow(true)
	end

	----------------------------------------------------------------------------
	-- 몬스터 종족 설정
	----------------------------------------------------------------------------
	lua_EnemyTypeIcon:SetShow( false )
	lua_EnemyTypeText:SetShow( false )
	if targetActor:get():isMonster() then
		lua_EnemyTypeText:SetShow( true )
		lua_EnemyTypeText:SetPosX( lua_EnemyTypeIcon:GetPosX() / 2 + 27 )
		lua_EnemyTypeText:SetPosY( lua_EnemyTypeIcon:GetPosY() + 11 )
		local monsterType = ""
		local checkMonsterType = targetActor:getCharacterStaticStatusWrapper():getTribeType()
		if CppEnums.TribeType.eTribe_Human == checkMonsterType then
			lua_EnemyTypeIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/human.dds")
			lua_EnemyTypeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_HUMAN") ) -- "인간족" )
		elseif	CppEnums.TribeType.eTribe_Ain == checkMonsterType then
			lua_EnemyTypeIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/ain.dds")
			lua_EnemyTypeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_AIN") ) -- "아인족" )
		elseif	CppEnums.TribeType.eTribe_Animal == checkMonsterType then
			lua_EnemyTypeIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/animal.dds")
			lua_EnemyTypeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_ETRIBEANIMAL") ) -- "동물/식물" )
		elseif	CppEnums.TribeType.eTribe_Undead == checkMonsterType then
			lua_EnemyTypeIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/undead.dds")
			lua_EnemyTypeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_UNDEAD") ) -- "언데드" )
		elseif	CppEnums.TribeType.eTribe_Reptile == checkMonsterType then
			lua_EnemyTypeIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/Violent.dds")
			lua_EnemyTypeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_ETRIBEREPTILE") ) -- "포악함" )
		elseif	CppEnums.TribeType.eTribe_Untribe == checkMonsterType then
			lua_EnemyTypeIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/etc.dds")
			lua_EnemyTypeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_UNTRIBE") ) -- "견고함" )
		elseif	CppEnums.TribeType.eTribe_Hunting == checkMonsterType then
			lua_EnemyTypeIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/hunt.dds")
			lua_EnemyTypeText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_HUNT") ) -- "수렵" )
		end
		
		local x1, y1, x2, y2 = setTextureUV_Func( lua_EnemyTypeIcon, 0, 0, 32, 32 )
		lua_EnemyTypeIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
		lua_EnemyTypeIcon:setRenderTexture(lua_EnemyTypeIcon:getBaseTexture())
		lua_EnemyTypeIcon:SetShow( true )

		-- 밤 버프 이펙트
		local hour				= math.floor( getIngameTime_minute() / 60 )
		local darkNightPowerUp	= targetActor:get():getCharacterStaticStatus()._isPowerUpInNight
		if ( 22 == hour or 0 == hour or 1 == hour ) and darkNightPowerUp then
			lua_EnemyTypeIcon:EraseAllEffect()
			lua_EnemyTypeIcon:AddEffect("UI_Monster_Emergency", true, 0, 0)	-- 밤버프 이팩트!!
		else
			lua_EnemyTypeIcon:EraseAllEffect()
		end
	end
end

function _recentTargetInfo_TendencyOnDead_MSG( targetActor, actorKey )
	if targetActor:get():hasVehicleOwner() then
		return
	end
	local targetName = targetActor:getCharacterStaticStatusWrapper():getName()
	local characterTOD = targetActor:getCharacterStaticStatusWrapper():getTendencyOnDead()
	if nil ~= characterTOD and characterTOD < 0 then
		if nil ~= nowTarget[actorKey] then
			if nowTarget[actorKey] < 10 then
				nowTarget[actorKey] = nowTarget[actorKey] + 1
			else
				nowTarget[actorKey] = 0
				Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_CHARACTERTOD", "getName", targetName ) )
				-- "<PAColor0xFFD20000>[" .. targetActor:getCharacterStaticStatusWrapper():getName() .. "] : 죽이면 성향치가 떨어집니다.<PAOldColor>")
			end
		else
			nowTarget[actorKey] = 0
			Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_CHARACTERTOD", "getName", targetName ) )
			-- "<PAColor0xFFD20000>[" .. targetActor:getCharacterStaticStatusWrapper():getName() .. "] : 죽이면 성향치가 떨어집니다.<PAOldColor>")
		end
	end
end

function updateTargetInfoCheckTime( fDeltatime )
	elapsedTime = elapsedTime + fDeltatime
	
	if 20.0 < elapsedTime then
		elapsedTime = 0.0
		monsterList = {}
		Panel_Monster_Bar:SetShow( false, false )
		clearTargetActor()
		FGlobal_DangerAlert_Show( false )
	end
end

function FGlobal_Panel_Monster_Bar_RePos()
	if Panel_LocalWar:GetShow() then			-- 국지전 위젯이 켜져 있으면,
		Panel_Monster_Bar:SetPosY( Panel_LocalWar:GetPosY() + Panel_LocalWar:GetSizeY() - 5 )
		blackBg:SetShow( false )
	else
		Panel_Monster_Bar:SetPosY( 5 )
		blackBg:SetShow( true )
	end
end

function hideRecentTargetInfo()
	monsterList = {}
	Panel_Monster_Bar:SetShow( false, false )
	FGlobal_DangerAlert_Show( false )
end

registerEvent("EvnetLeaveInstanceDungeon", "hideRecentTargetInfo")
registerEvent("update_Monster_Info_Req", "panel_Update_Monster_Info")
registerEvent("stunChanged", "Panel_MonsterInfo_UpdateStun")
Panel_Monster_Bar:RegisterUpdateFunc("updateTargetInfoCheckTime")

local _const = Defines.s64_const
local UI_color		= Defines.Color
local UI_PSFT		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local _lvupTitle		= UI.getChildControl ( Panel_Levelup_Reward, "StaticText_LeveupTitle" )
local _stminaupTitle	= UI.getChildControl ( Panel_Levelup_Reward, "StaticText_StaminaupTitle" )
local _strengthupTitle	= UI.getChildControl ( Panel_Levelup_Reward, "StaticText_StrengthupTitle" )
local _healthupTitle	= UI.getChildControl ( Panel_Levelup_Reward, "StaticText_HealthupTitle" )

------------------------------------------------------
-- 						저장값들
------------------------------------------------------

local _txt_lvupStatus = {} --create 한 컨트롤 목록
local copyBaseCount = 4	--create할 갯수

local currTime = 0	--꺼질 시간 판단용 timeValue
local isFirstShow = true	--첫번째는 안보여줌
local isUpdateList = { false, false, false, false }	--데이터가 바뀐정보


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

------------------------------------------------------
-- 		각 컨트롤 별 Y값을 저장하기 위한 함수
------------------------------------------------------
local GetBottomPos = function(control)
	if ( nil == control ) then
		return
	end
	return control:GetPosY() + control:GetSizeY()
end


------------------------------------------------------
-- 		
------------------------------------------------------
function LevelUp_ShowStatus_Init()
	------------------------------------------------------
	--				STATIC TEXT 를 복사해준다!
	------------------------------------------------------
	local _c_lvup_Status	= UI.getChildControl ( Panel_Levelup_Reward, "StaticText_Status_sample" )

	for index = 1, copyBaseCount do
		local _lvup_Status = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Levelup_Reward, "StaticText_Status_" .. index )
		CopyBaseProperty( _c_lvup_Status, _lvup_Status )
		_lvup_Status:SetShow( false )
		_lvup_Status:SetAlpha( 0 )
		
		_txt_lvupStatus[index] = _lvup_Status
	end

	Panel_Levelup_Reward:RemoveControl(_c_lvup_Status)
end

local aniType =
{
	staminaUp	= 0,
	strengthUp	= 1,
	healthUp	= 2,
	levelUP		= 3,
}

local Reward_AniFunc = function( _type )
	local endTime = { 0.3, 0.6, 0.9, 1.2 }
	if ( aniType.levelUP == _type ) then
		chatting_sendMessage( "", PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LEVELUP_REWARD_LEVELUP_TITLE") , CppEnums.ChatType.System )
		_lvupTitle		:SetShow( true )
		_stminaupTitle	:SetShow( false )
		_strengthupTitle:SetShow( false )
		_healthupTitle	:SetShow( false )
	elseif ( aniType.staminaUp == _type ) then
		chatting_sendMessage( "", PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_STAMINAUP"), CppEnums.ChatType.System ) -- 지구력 상승
		_lvupTitle		:SetShow( false )
		_stminaupTitle	:SetShow( true )
		_strengthupTitle:SetShow( false )
		_healthupTitle	:SetShow( false )
	elseif ( aniType.strengthUp == _type ) then
		chatting_sendMessage( "", PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_STRENGTHUP"), CppEnums.ChatType.System ) -- 힘 상승
		_lvupTitle		:SetShow( false )
		_stminaupTitle	:SetShow( false )
		_strengthupTitle:SetShow( true )
		_healthupTitle	:SetShow( false )
	elseif ( aniType.healthUp == _type ) then
		chatting_sendMessage( "", PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_HEALTHUP"), CppEnums.ChatType.System ) -- 건강 상승
		_lvupTitle		:SetShow( false )
		_stminaupTitle	:SetShow( false )
		_strengthupTitle:SetShow( false )
		_healthupTitle	:SetShow( true )
	end
	local isShow = false
	for index = 1, copyBaseCount do
		if ( isUpdateList[index] ) then
			_txt_lvupStatus[index]:SetShow( true )
			_txt_lvupStatus[index]:SetFontAlpha( 0 )
			_txt_lvupStatus[index]:SetAlpha( 0 )
	
			local statusAni1 = _txt_lvupStatus[index]:addColorAnimation( 0.0, endTime[index], UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
			statusAni1:SetStartColor( UI_color.C_00FFFFFF )
			statusAni1:SetEndColor( UI_color.C_FFFFFFFF )
			statusAni1:SetStartIntensity( 3.0 )
			statusAni1:SetEndIntensity( 1.0 )
	
			_txt_lvupStatus[index]:AddEffect( "UI_ButtonLineRight_Blue", false, -20, 0 )
			
			chatting_sendMessage( "", _txt_lvupStatus[index]:GetText() , CppEnums.ChatType.System )

			isShow = true
		else
			_txt_lvupStatus[index]:SetShow( false )
			_txt_lvupStatus[index]:SetFontAlpha( 0 )
			_txt_lvupStatus[index]:SetAlpha( 0 )
		end
	end
	Panel_Levelup_Reward:SetShow(isShow)
end

------------------------------------------------------
--		레벨업 하면 스테이터스를 보여준다!
------------------------------------------------------
local positionY = GetBottomPos( _lvupTitle )
local posY_gab = 5

function LevelUp_Update_ShowFunction( deltaTime )
	currTime = currTime + deltaTime
	
	if ( currTime > 5 ) and ( Panel_Levelup_Reward:IsShow() == true ) then
		currTime = 0
		local levelUP_Reward_Hide = UIAni.AlphaAnimation( 0, Panel_Levelup_Reward, 0.0, 0.6 )
		levelUP_Reward_Hide:SetHideAtEnd(true)
	end
end

function ToClient_SelfPlayerLevelUp(hp, mp, stun, weight)
	local playerWrapper = getSelfPlayer()
	local classType 	= playerWrapper:getClassType()

	local positionY = GetBottomPos( _lvupTitle )
	----------------------------------------------------------
	-- 				계산해서 수치를 보여준다!
	----------------------------------------------------------
	-- HP를 계산해서 보여준다
	if ( 0 < hp ) then
		_txt_lvupStatus[1]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXHPUP").."<PAColor0xFFFFBD2E>+"..( hp ).."<PAOldColor>" )
		_txt_lvupStatus[1]:SetPosY( 25 )
		positionY = GetBottomPos( _txt_lvupStatus[1] )
		isUpdateList[1] = true
	else
		isUpdateList[1] = false
	end

	-- MP를 계산해서 보여준다
	if ( 0 < mp ) then
		if ( classType == 0 ) then
			_txt_lvupStatus[2]:SetText(	PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXFPUP").."<PAColor0xFFFFBD2E>+"..( mp ).."<PAOldColor>" )
		elseif ( classType == 4 ) then
			_txt_lvupStatus[2]:SetText(	PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP").."<PAColor0xFFFFBD2E>+"..( mp ).."<PAOldColor>" )
		elseif ( classType == 8 ) then
			_txt_lvupStatus[2]:SetText(	PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP").."<PAColor0xFFFFBD2E>+"..( mp ).."<PAOldColor>" )
		elseif ( classType == 12 ) then
			_txt_lvupStatus[2]:SetText(	PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXFPUP").."<PAColor0xFFFFBD2E>+"..( mp ).."<PAOldColor>" )
		else
			-- 등록된 직업외에는 파이터게이지를 표시를 쓴다.
			_txt_lvupStatus[2]:SetText(	PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXMPUP").."<PAColor0xFFFFBD2E>+"..( mp ).."<PAOldColor>" )
		end

		_txt_lvupStatus[2]:SetPosY( positionY + posY_gab )
		positionY = GetBottomPos( _txt_lvupStatus[2] )
		isUpdateList[2] = true
	else
		isUpdateList[2] = false
	end

	-- 스턴 게이지를 계산해서 보여준다
	if ( 0 < stun ) then
		_txt_lvupStatus[3]:SetText(	PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXSTUNRESISTUP").."<PAColor0xFFFFBD2E>+".. ( stun ).."<PAOldColor>" )
		_txt_lvupStatus[3]:SetPosY( positionY + posY_gab )
		positionY = GetBottomPos( _txt_lvupStatus[3] )

		isUpdateList[3] = true
	else
		isUpdateList[3] = false
	end

	--무게를 계산해서 보여준다
	if ( Defines.s64_const.s64_0 < weight ) then
		_txt_lvupStatus[4]:SetText(	PAGetString(Defines.StringSheet_GAME, "LUA_LEVELUP_REWARD_MAXWEIGHTUP").."<PAColor0xFFFFBD2E>+".. (Int64toInt32( weight )/10000) .."<PAOldColor>" )
		_txt_lvupStatus[4]:SetPosY( positionY + posY_gab )
		positionY = GetBottomPos( _txt_lvupStatus[4] )
		isUpdateList[4] = true
	else
		isUpdateList[4] = false
	end
	Reward_AniFunc( aniType.levelUP )
	enableSkill_UpdateData()
	
	if ( 6 >= getSelfPlayer():get():getLevel() ) then				-- UI 간소화 6레벨까지만 체크
		SimpleUI_Check()										-- UI_GameOption.lua 펑션
	end
end

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
LevelUp_ShowStatus_Init()
Panel_Levelup_Reward:RegisterUpdateFunc( "LevelUp_Update_ShowFunction" )

registerEvent( "ToClient_SelfPlayerLevelUp", "ToClient_SelfPlayerLevelUp" )
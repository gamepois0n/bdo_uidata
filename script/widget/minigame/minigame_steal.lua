-- 미니게임 12 ( 주머니 도둑 )

local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AH = CppEnums.PA_UI_ALIGNHORIZON
local MGKT = CppEnums.MiniGameKeyType

Panel_MiniGame_Steal:setMaskingChild(true)
Panel_MiniGame_Steal:setGlassBackground(true)


Panel_MiniGame_Steal:RegisterShowEventFunc( true, 'Minigame_Steal_ShowAni()' )
Panel_MiniGame_Steal:RegisterShowEventFunc( false, 'Minigame_Steal_HideAni()' )

---------------------------------------------------------
-- 					창 끄고 켜기
---------------------------------------------------------
function Minigame_Steal_ShowAni()
	Panel_MiniGame_Steal:SetShow( true )
	Panel_MiniGame_Steal:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_MiniGame_Steal, 0.0, 0.2 )
end

function Minigame_Steal_HideAni()
	Panel_MiniGame_Steal:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_MiniGame_Steal, 0.0, 0.2 )
	aniInfo:SetHideAtEnd( true )
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ui =
{
	_pocket			= UI.getChildControl ( Panel_MiniGame_Steal, "Static_MyPocket" ),
	_theifHand		= UI.getChildControl ( Panel_MiniGame_Steal, "Static_TheifHand_0" ),
	_myHand			= UI.getChildControl ( Panel_MiniGame_Steal, "Static_MyHand" ),
}


--------------------------------------
--		글로벌 매뉴얼 가져오기
local _title				= UI.getChildControl ( Panel_Global_Manual, "StaticText_Purpose" )
local _steal_Icon_Title		= UI.getChildControl ( Panel_Global_Manual, "Static_Minigame_Steal_Title" )


--------------------------------------
--				각종 변수
local currTime 		= 0
local stealValue 	= 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------
--				스크린 사이즈 업데이트
---------------------------------------------------------
function Minigame_Steal_ScreenResize()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	Panel_Global_Manual:SetSize ( scrX, scrY )
	Panel_Global_Manual:SetPosX(0)
	Panel_Global_Manual:SetPosY(50)

	Panel_MiniGame_Steal:ComputePos()
end


---------------------------------------------------------
--				주머니 도둑 초기화 함수
---------------------------------------------------------
function Minigame_Steal_Initialize()
	currTime = 0
	stealValue = 0
	
	--------------------------------------------------
	--			일반 손 텍스쳐로 변경해준다
	ui._theifHand:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Instance/MiniGame_01.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( ui._theifHand, 1, 1, 151, 151 )
	ui._theifHand:getBaseTexture():setUV(  x1, y1, x2, y2  )
	ui._theifHand:setRenderTexture(ui._theifHand:getBaseTexture())
	
end


---------------------------------------------------------
--				주머니 도둑 게임 시작
---------------------------------------------------------
function Panel_Minigame_Steal_Start()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_Global_Manual:SetShow ( true )
	Panel_Global_Manual:SetSize ( scrX, scrY )
	Panel_Global_Manual:SetPosX(0)
	Panel_Global_Manual:SetPosY(50)
	
	Panel_MiniGame_Steal:SetShow( true, true )
	
	_steal_Icon_Title:SetShow(true)
	_title:SetShow(true)
	_title:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_STEAL_0") )	-- <PAColor0xFFFFD649>'스페이스 바'<PAOldColor> 를 눌러 도둑의 손을 막아내세요
	
	ui._pocket:SetPosX( 90 )
	ui._pocket:SetPosY( 130 )
	ui._myHand:SetShow( false )
	ui._theifHand:SetIgnore( false )
	
	currTime = 0
	stealValue = 0

	--------------------------------------------------
	--			일반 손 텍스쳐로 변경해준다
	ui._theifHand:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Instance/MiniGame_01.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( ui._theifHand, 1, 1, 151, 151 )
	ui._theifHand:getBaseTexture():setUV(  x1, y1, x2, y2  )
	ui._theifHand:setRenderTexture(ui._theifHand:getBaseTexture())
	
	ui._theifHand:ResetVertexAni()
	ui._theifHand:SetVertexAniRun( "Ani_Move_Pos_New", true )
	ui._theifHand:addInputEvent( "Mouse_LUp", "Minigame_Steal_Cut()" )
end


---------------------------------------------------------
--				주머니 도둑 게임 종료
---------------------------------------------------------
function Panel_Minigame_Steal_End()
	ui._theifHand:ResetVertexAni()
	Panel_Global_Manual:SetShow ( false )
	Panel_MiniGame_Steal:SetShow( false, true )
	
	--------------------------------------------------
	--		돈이 빼앗겼다고 클라로 보내야한다!
	
	currTime = 0
	stealValue = 0
end


---------------------------------------------------------
--				타이머를 체크한다
---------------------------------------------------------
function Minigame_Steal_KeyPressTimeCheck( deltaTime )
	currTime = currTime + deltaTime
	
	if ( currTime >= 0.65 ) and ( 2.0 >= currTime ) and ( stealValue == 0 ) then
		--------------------------------------------------
		--		돈 훔쳐가는 손 텍스쳐로 변경해준다
		ui._theifHand:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Instance/MiniGame_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( ui._theifHand, 303, 1, 453, 151 )
		ui._theifHand:getBaseTexture():setUV(  x1, y1, x2, y2  )
		ui._theifHand:setRenderTexture( ui._theifHand:getBaseTexture() )

		--------------------------------------------------
		--				주머니를 흔들어준다
		local periodTime = 0.035
		local moveCount = 2
		local randomizeValue = 4

		for idx = 0 , moveCount do
			local aniInfo0 = ui._pocket:addMoveAnimation( periodTime * idx , periodTime * ( idx + 1 ) , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
			aniInfo0.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
			aniInfo0.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
			aniInfo0:SetStartPosition( ui._pocket:GetPosX() + getRandomValue(-randomizeValue, randomizeValue), ui._pocket:GetPosY() + getRandomValue(-randomizeValue, randomizeValue))
			aniInfo0:SetEndPosition(ui._pocket:GetPosX() + getRandomValue(-randomizeValue, randomizeValue), ui._pocket:GetPosY() + getRandomValue(-randomizeValue, randomizeValue))
		end

		local endTime = periodTime * ( moveCount + 1 )

		local periodTime_vertical = 0.03
		local moveCount_vertical = 2
		local randomizeValue_vertical = 5

		for idx = 0 , moveCount_vertical do
			local aniInfo0 = ui._pocket:addMoveAnimation( endTime + periodTime_vertical * idx , endTime + periodTime_vertical * ( idx + 1 ) , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
			aniInfo0.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
			aniInfo0.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
			aniInfo0:SetStartPosition( ui._pocket:GetPosX() , ui._pocket:GetPosY() + getRandomValue(-randomizeValue_vertical, randomizeValue_vertical))
			aniInfo0:SetEndPosition(ui._pocket:GetPosX() , ui._pocket:GetPosY() + getRandomValue(-randomizeValue_vertical, randomizeValue_vertical))
		end

		endTime = endTime + periodTime_vertical * ( moveCount_vertical + 1 )

		local aniInfo1 = ui._pocket:addMoveAnimation( endTime, endTime + periodTime_vertical , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
		aniInfo1.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo1.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo1:SetStartPosition( ui._pocket:GetPosX() , ui._pocket:GetPosY() )
		aniInfo1:SetEndPosition(ui._pocket:GetPosX() , ui._pocket:GetPosY() )
		
		stealValue = 1
	end
	
	if ( stealValue == 1 ) then
		ui._theifHand:SetIgnore( true )
	end
	
	if ( currTime >= 3.75 ) then
		Panel_Minigame_Steal_End()
	end
end


---------------------------------------------------------
--				키를 누르는지 체크
---------------------------------------------------------
function Minigame_Steal_PressKey( keyType )
	if ( MGKT.MiniGameKeyType_Space == keyType ) then
		if ( stealValue == 0 ) then
			Minigame_Steal_Cut()
			
			--------------------------------------------------
			--			놀란 손 텍스쳐로 변경해준다
			ui._theifHand:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Instance/MiniGame_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( ui._theifHand, 215, 152, 365, 302 )
			ui._theifHand:getBaseTexture():setUV(  x1, y1, x2, y2  )
			-- ui._theifHand:setRenderTexture( ui._theifHand:getBaseTexture() )
			
		elseif ( stealValue == 1 ) then
			-- UI.debugMessage("아무것도 하지 않는다")
		end
	end
end


---------------------------------------------------------
--					이 도둑노무 섀키!
---------------------------------------------------------
function Minigame_Steal_Cut()
	currTime = 2.1		-- 2.1을 한 이유는 3.75 의 CurrTime 에서 게임 자체가 종료되기 때문
	stealValue = 1
	
	ui._myHand:SetShow( true )
	ui._myHand:SetVertexAniRun( "Ani_Move_Pos_New", true )
	ui._pocket:SetVertexAniRun( "Ani_Move_Pos_New", true )
	ui._theifHand:ResetVertexAni()
	
	--------------------------------------------------
	--			놀란 손 텍스쳐로 변경해준다
	ui._theifHand:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Instance/MiniGame_01.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( ui._theifHand, 215, 152, 365, 302 )
	ui._theifHand:getBaseTexture():setUV(  x1, y1, x2, y2  )
	ui._theifHand:setRenderTexture( ui._theifHand:getBaseTexture() )
	
	--------------------------------------------------
	--				놀란 손을 흔들어준다
	local periodTime = 0.025
	local moveCount = 6
	local randomizeValue = 7

	for idx = 0 , moveCount do
		local aniInfo0 = ui._theifHand:addMoveAnimation( periodTime * idx , periodTime * ( idx + 1 ) , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
		aniInfo0.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo0.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo0:SetStartPosition( ui._theifHand:GetPosX() + getRandomValue(-randomizeValue, randomizeValue), ui._theifHand:GetPosY() + getRandomValue(-randomizeValue, randomizeValue))
		aniInfo0:SetEndPosition(ui._theifHand:GetPosX() + getRandomValue(-randomizeValue, randomizeValue), ui._theifHand:GetPosY() + getRandomValue(-randomizeValue, randomizeValue))
	end

	local endTime = periodTime * ( moveCount + 1 )

	local periodTime_vertical = 0.020
	local moveCount_vertical = 4
	local randomizeValue_vertical = 8

	for idx = 0 , moveCount_vertical do
		local aniInfo0 = ui._theifHand:addMoveAnimation( endTime + periodTime_vertical * idx , endTime + periodTime_vertical * ( idx + 1 ) , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
		aniInfo0.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo0.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo0:SetStartPosition( ui._theifHand:GetPosX() , ui._theifHand:GetPosY() + getRandomValue(-randomizeValue_vertical, randomizeValue_vertical))
		aniInfo0:SetEndPosition(ui._theifHand:GetPosX() , ui._theifHand:GetPosY() + getRandomValue(-randomizeValue_vertical, randomizeValue_vertical))
	end

	endTime = endTime + periodTime_vertical * ( moveCount_vertical + 1 )

	local aniInfo1 = ui._theifHand:addMoveAnimation( endTime, endTime + periodTime_vertical , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo1.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo1.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo1:SetStartPosition( ui._theifHand:GetPosX() , ui._theifHand:GetPosY() )
	aniInfo1:SetEndPosition(ui._theifHand:GetPosX() , ui._theifHand:GetPosY() )
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Minigame_Steal_Initialize()

Panel_MiniGame_Steal:RegisterUpdateFunc("Minigame_Steal_KeyPressTimeCheck")
registerEvent("onScreenResize", "Minigame_Steal_ScreenResize")



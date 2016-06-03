Panel_CounterAttack:SetShow( false )

----------------------------------------------------------------------
--					카운터 어택 화면에 맞추기
----------------------------------------------------------------------
function CounterAttack_ResizeScreen()
	Panel_CounterAttack:SetSize( getScreenSizeX(), getScreenSizeY() )
end


----------------------------------------------------------------------
--					카운터 어택 애니메이션 처리
----------------------------------------------------------------------
function CounterAttack_Show()
	Panel_CounterAttack:ResetVertexAni()
	Panel_CounterAttack:SetShow( true )
	Panel_CounterAttack:SetVertexAniRun( "Ani_Color_Counter", true )
end


CounterAttack_ResizeScreen()
registerEvent("onScreenResize", "CounterAttack_ResizeScreen")

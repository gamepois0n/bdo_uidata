Panel_MainStatus_User_ProductSkillPoint:SetShow( true )

local _staticSkillExp = UI.getChildControl( Panel_MainStatus_User_ProductSkillPoint, "CircularProgress_SkillExp_p" )
local _staticSkillPoint = UI.getChildControl( Panel_MainStatus_User_ProductSkillPoint, "StaticText_SkillPoint_p" )
--registerEvent("EventCharacterInfoUpdate", "Panel_User_ProductSkillPoint_Update")


function Panel_User_ProductSkillPoint_Update()
	local skillPointInfo = getSkillPointInfo( 2 )--생산스킬포인트(2번이니까)

	--UI.debugMessage( "생산포인트" ..skillPointInfo._remainPoint )		
	-- skill Point	
	_staticSkillPoint:SetText(tostring(skillPointInfo._remainPoint))	
	
	-- skill Exp
	local skillExpRate = skillPointInfo._currentExp / skillPointInfo._nextLevelExp
	_staticSkillExp:SetProgressRate( skillExpRate * 100 )
end



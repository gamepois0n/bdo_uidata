local IM 			= CppEnums.EProcessorInputMode
local UI_TM 		= CppEnums.TextMode
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

Panel_InstallationMode_FarmInfo:SetShow( false )
Panel_InstallationMode_FarmInfo:SetDragEnable( false )

local radioBtn_Crop				= UI.getChildControl( Panel_InstallationMode_FarmInfo, "RadioButton_Crop" )
local radioBtn_DomesticAnimal	= UI.getChildControl( Panel_InstallationMode_FarmInfo, "RadioButton_DomesticAnimal" )

radioBtn_Crop:addInputEvent( "Mouse_LUp", "FarmGuide_DescChange( 0 )" )
radioBtn_DomesticAnimal:addInputEvent( "Mouse_LUp", "FarmGuide_DescChange( 1 )" )

local farmGuideDesc = { [0] = {}, [1] = {} }
farmGuideDesc[0][0] = 
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_0"), -- "씨앗 획득",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_1"), -- "온도",
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_2"), -- "습도",
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_3"), -- "지하수",
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_4"), -- "수분",
	[5] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_5"), -- "건강",
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_10"), -- "씨앗 상인에게 구입하거나 의뢰 보상으로 획득할 수 있습니다. 각종 작물 또는 수풀이나 덤불에서 채집 시 일정 확률로 얻기도 합니다.",
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_11"), -- "작물이 성장하기 좋은 온도라면 성장 속도가 빨라집니다",
	[12] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_12"), -- "작물이 성장할 때 병충해 발생 확률에 영향을 끼칩니다.",
	[13] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_13"), -- "작물의 수분량에 영향을 미칩니다. 물을 뿌리면 지하수량을 늘릴 수 있습니다. 지하수량이 많으면 수분이 회복되고, 적으면 서서히 감소합니다.",
	[14] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_14"), -- "작물에 포함된 수분 정도로, 0이 되면 작물이 말라 수확량이 감소합니다.",
	[15] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_15"), -- "작물의 건강 상태로, 새 서리를 당하면 줄어듭니다. 건강이 나빠질수록 재배시간이 늘어납니다.",
}
farmGuideDesc[0][1] =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_0"), -- "허수아비 설치",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_1"), -- "수로 설치",
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_2"), -- "가지치기",
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_3"), -- "병충해 치료",
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_10"), -- "새 서리 확률을 큰 폭으로 낮춰 줍니다. 허수아비는 목공예 공방에서 제작할 수 있습니다.",
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_11"), -- "작물 성장 시 소모되는 지하수량을 절반으로 낮춰 줍니다. 수로는 목공예 공방에서 제작할 수 있습니다.",
	[12] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_12"), -- "이벤트 발생 시 작물의 성장이 멈추며, 여러 개의 작물을 심을수록 발생 확률이 올라갑니다. 해당 작물에 상호작용하면 해제할 수 있습니다.",
	[13] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_13"), -- "이벤트 발생 시 작물의 성장이 멈추며, 습도가 맞지 않을수록 발생 확률 올라갑니다. 해당 작물에 상호작용하면 해제할 수 있습니다.",
}
farmGuideDesc[0][2] =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_0"), -- "열매 수확",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_1"), -- "품종 개량",
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_10"), -- "재배한 작물을 대량 수확합니다. 수확 시 높은 등급의 작물이 추가로 나올 수 있습니다.",
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_11"), -- "열매 대신 씨앗을 수확합니다. 수확 시 하나 이상의 씨앗을 얻을 수 있으며, 간혹 높은 등급의 씨앗이 나올 수도 있습니다.",
}

farmGuideDesc[1][0] = 
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_6"), -- "먹이 획득",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_1"), -- "온도",
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_2"), -- "습도",
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_3"), -- "지하수",
	[4] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_4"), -- "식수",
	[5] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_5"), -- "건강",
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_20"), -- "식물을 말려 획득할 수 있습니다. 건초 더미는 잡초 50개를 말려 획득합니다.",
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_21"), -- "가축을 사육하기 좋은 온도라면 가축이 먹이를 더 잘 먹습니다. 적절한 온도가 아니라면 덜 먹게 됩니다.",
	[12] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_22"), -- "가축을 사육하는 도중 기생충 발생 확률에 영향을 끼칩니다.",
	[13] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_23"), -- "가축의 식수량에 영향을 미칩니다. 물을 뿌리면 지하수량을 늘릴 수 있습니다. 지하수량이 많으면 식수가 회복되고, 적으면 서서히 감소합니다.",
	[14] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_24"), -- "가축에 필요한 수분 정도로, 0이 되면 가축이 갈증을 느끼며 수확량이 감소합니다.",
	[15] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_25"), -- "가축의 건강 상태로, 먹이를 새에게 서리 당하면 줄어듭니다. 건강이 나빠질수록 목축시간이 늘어납니다.",
}
farmGuideDesc[1][1] =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_0"), -- "허수아비 설치",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_1"), -- "수로 설치",
	[2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_4"), -- "먹이 관리",
	[3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_5"), -- "기생충 잡기",
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_10"), -- "새 서리 확률을 큰 폭으로 낮춰 줍니다. 허수아비는 목공예 공방에서 제작할 수 있습니다.",
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_14"), -- "가축 사육 시 소모되는 지하수량을 절반으로 낮춰 줍니다. 수로는 목공예 공방에서 제작할 수 있습니다.",
	[12] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_15"), -- "가축 사육이 멈추며, 여러 개의 먹이를 설치할 수록 발생 확률이 올라갑니다. 해당 먹이에 상호작용하면 해제할 수 있습니다.",
	[13] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_16"), -- "가축 사육이 멈추며, 습도가 맞지 않을수록 발생 확률이 올라갑니다. 해당 먹이에 상호작용하면 해제할 수 있습니다.",
}
farmGuideDesc[1][2] =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_2"), -- "수확하기",
	[1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_1"), -- "품종 개량",
	[10] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_12"), -- "가축의 생산물을 대량 수확합니다. 수확 시 낮은 확률로 생산물이 추가로 나올 수 있습니다.",
	[11] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_13"), -- "생산물 대신 먹이 개량을 시도합니다. 수확 시 하나 이상의 먹이를 얻을 수 있으며, 간혹 높은 등급의 먹이가 나올 수도 있습니다.",
}



local farmGuideIcon = {}

farmGuideIcon[0] =
{
	[0] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmBaseInfoIcon1" ),
	[1] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmBaseInfoIcon2" ),
	[2] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmBaseInfoIcon3" ),
	[3] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmBaseInfoIcon4" ),
	[4] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmBaseInfoIcon5" ),
	[5] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmBaseInfoIcon6" ),
}

farmGuideIcon[1] =
{
	[0] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmManagementInfoIcon1" ),
	[1] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmManagementInfoIcon2" ),
	[2] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmManagementInfoIcon3" ),
	[3] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmManagementInfoIcon4" ),
	[4] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmManagementInfoIcon5" ),
	[5] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmManagementInfoIcon6" ),
}

farmGuideIcon[2] =
{
	[0] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmHavestInfoIcon1" ),
	[1] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmHavestInfoIcon2" ),
	[2] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmHavestInfoIcon3" ),
	[3] = UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_FarmHavestInfoIcon4" ),
}

local selectIcon	= UI.getChildControl( Panel_InstallationMode_FarmInfo, "Static_C_IconSelect" )

local descTitle		= UI.getChildControl( Panel_InstallationMode_FarmInfo, "StaticText_FarmInfoTitle" )
local descContent	= UI.getChildControl( Panel_InstallationMode_FarmInfo, "StaticText_FarmInfoDesc" )
	  descContent	: SetTextMode( UI_TM.eTextMode_AutoWrap )

local iconToolTip	= UI.getChildControl( Panel_InstallationMode_FarmInfo, "StaticText_ToolTip" )

local IconAddInputEvnet = function( icon, iconType )
	for i = 0, #icon do
		icon[i]:addInputEvent("Mouse_LUp", "HandleClicked_ShowDesc(" .. i .. ", " .. iconType .. ")")
		icon[i]:addInputEvent("Mouse_On", "HandleOn_ShowBubble(" .. i .. ", " .. iconType .. ")")
		icon[i]:addInputEvent("Mouse_Out", "HandleOn_ShowBubble()")
		icon[i]:setTooltipEventRegistFunc("HandleOn_ShowBubble(" .. i .. ", " .. iconType .. ")")
	end
	
	farmGuideIcon[1][4]:addInputEvent("Mouse_LUp", "HandleClicked_ShowDesc(" .. 2 .. ", " .. 1 .. ")")
	farmGuideIcon[1][4]:addInputEvent("Mouse_On", "HandleOn_ShowBubble(" .. 2 .. ", " .. 1 .. ")")
	farmGuideIcon[1][4]:addInputEvent("Mouse_Out", "HandleOn_ShowBubble()")
	farmGuideIcon[1][4]:setTooltipEventRegistFunc("HandleOn_ShowBubble(" .. 2 .. ", " .. 1 .. ")")
	
	farmGuideIcon[1][5]:addInputEvent("Mouse_LUp", "HandleClicked_ShowDesc(" .. 3 .. ", " .. 1 .. ")")
	farmGuideIcon[1][5]:addInputEvent("Mouse_On", "HandleOn_ShowBubble(" .. 3 .. ", " .. 1 .. ")")
	farmGuideIcon[1][5]:addInputEvent("Mouse_Out", "HandleOn_ShowBubble()")
	farmGuideIcon[1][5]:setTooltipEventRegistFunc("HandleOn_ShowBubble(" .. 3 .. ", " .. 1 .. ")")
	
	farmGuideIcon[2][2]:addInputEvent("Mouse_LUp", "HandleClicked_ShowDesc(" .. 0 .. ", " .. 2 .. ")")
	farmGuideIcon[2][2]:addInputEvent("Mouse_On", "HandleOn_ShowBubble(" .. 0 .. ", " .. 2 .. ")")
	farmGuideIcon[2][2]:addInputEvent("Mouse_Out", "HandleOn_ShowBubble()")
	farmGuideIcon[2][2]:setTooltipEventRegistFunc("HandleOn_ShowBubble(" .. 0 .. ", " .. 2 .. ")")
	
	farmGuideIcon[2][3]:addInputEvent("Mouse_LUp", "HandleClicked_ShowDesc(" .. 1 .. ", " .. 2 .. ")")
	farmGuideIcon[2][3]:addInputEvent("Mouse_On", "HandleOn_ShowBubble(" .. 1 .. ", " .. 2 .. ")")
	farmGuideIcon[2][3]:addInputEvent("Mouse_Out", "HandleOn_ShowBubble()")
	farmGuideIcon[2][3]:setTooltipEventRegistFunc("HandleOn_ShowBubble(" .. 1 .. ", " .. 2 .. ")")
end
for ii = 0, 2 do
	IconAddInputEvnet( farmGuideIcon[ii], ii )
end

function HandleClicked_ShowDesc( index, descType )
	local radioIndex = 0
	if radioBtn_Crop:IsCheck() then
		radioIndex = 0
	elseif radioBtn_DomesticAnimal:IsCheck() then
		radioIndex = 1
	end
	descTitle	:SetText( "- " .. farmGuideDesc[radioIndex][descType][index] )
	descContent	:SetText( farmGuideDesc[radioIndex][descType][index+10] )
	selectIcon	:SetPosX( farmGuideIcon[descType][index]:GetPosX() - 1 )
	selectIcon	:SetPosY( farmGuideIcon[descType][index]:GetPosY() - 1 )
end

function HandleOn_ShowBubble( index, descType )
	if nil == index then
		iconToolTip:SetShow( false )
		return
	end

	local radioIndex = 0
	if radioBtn_Crop:IsCheck() then
		radioIndex = 0
	elseif radioBtn_DomesticAnimal:IsCheck() then
		radioIndex = 1
	end
	registTooltipControl(farmGuideIcon[descType][index], iconToolTip)
	iconToolTip:SetShow( true )
	iconToolTip:SetText( farmGuideDesc[radioIndex][descType][index] )
	iconToolTip:SetSize( iconToolTip:GetTextSizeX() + 10, iconToolTip:GetTextSizeY() + 5 )
	Panel_InstallationMode_FarmInfo:SetChildIndex( iconToolTip, 9999 )
	
	iconToolTip:SetPosX( farmGuideIcon[descType][index]:GetPosX() - 1 )
	iconToolTip:SetPosY( farmGuideIcon[descType][index]:GetPosY() - iconToolTip:GetSizeY() - 5 )
end

function FarmGuide_DescChange( index )
	if 0 == index then
		farmGuideIcon[1][2]:SetShow( true )
		farmGuideIcon[1][3]:SetShow( true )
		farmGuideIcon[1][4]:SetShow( false )
		farmGuideIcon[1][5]:SetShow( false )
		farmGuideIcon[2][0]:SetShow( true )
		farmGuideIcon[2][1]:SetShow( true )
		farmGuideIcon[2][2]:SetShow( false )
		farmGuideIcon[2][3]:SetShow( false )
	elseif 1 == index then
		farmGuideIcon[1][2]:SetShow( false )
		farmGuideIcon[1][3]:SetShow( false )
		farmGuideIcon[1][4]:SetShow( true )
		farmGuideIcon[1][5]:SetShow( true )
		farmGuideIcon[2][0]:SetShow( false )
		farmGuideIcon[2][1]:SetShow( false )
		farmGuideIcon[2][2]:SetShow( true )
		farmGuideIcon[2][3]:SetShow( true )
	end
	HandleClicked_ShowDesc( 0, 0 )
end

function FGlobal_FarmGuide_Open()
	Panel_InstallationMode_FarmInfo:SetShow( true )
	radioBtn_Crop:SetCheck( true )
	radioBtn_DomesticAnimal:SetCheck( false )
	FarmGuide_SetPosition()
	HandleClicked_ShowDesc( 0, 0 )
end
function FGlobal_FarmGuide_Close()
	Panel_InstallationMode_FarmInfo:SetShow( false )
end

function FarmGuide_BtnTextPosition()
	local btnCropSizeX						= radioBtn_Crop:GetSizeX()+23
	local btnCropTextPosX					= (btnCropSizeX - (btnCropSizeX/2) - ( radioBtn_Crop:GetTextSizeX() / 2 ))
	local btnAnimalSizeX					= radioBtn_DomesticAnimal:GetSizeX()+23
	local btnAnimalTextPosX					= (btnAnimalSizeX - (btnAnimalSizeX/2) - ( radioBtn_DomesticAnimal:GetTextSizeX() / 2 ))
	
	radioBtn_Crop			:SetTextSpan( btnCropTextPosX, 5 )
	radioBtn_DomesticAnimal	:SetTextSpan( btnAnimalTextPosX, 5 )
end

function FarmGuide_SetPosition()
	Panel_InstallationMode_FarmInfo:SetPosX( 10 )
	Panel_InstallationMode_FarmInfo:SetPosY( (getScreenSizeY() / 4) - ( Panel_InstallationMode_FarmInfo:GetSizeY()/ 4) )
end

registerEvent("onScreenResize", "FarmGuide_SetPosition" )
FarmGuide_BtnTextPosition()
local CT			= CppEnums.ClassType

--{ 각성 무기 열림 체크
PaGlobal_AwakenSkill = {
	awakenWeapon = 
	{
		[CT.ClassType_Warrior]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 901 ),					-- 워리어
		[CT.ClassType_Ranger]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 902 ),					-- 레인저
		[CT.ClassType_Sorcerer]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 903 ),					-- 소서러
		[CT.ClassType_Giant]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 904 ),					-- 자이언트
		[CT.ClassType_Tamer]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 905 ),					-- 금수랑
		[CT.ClassType_BladeMaster]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 906 ),					-- 무사
		[CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 907 ),					-- 매화
		[CT.ClassType_Valkyrie]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 908 ),					-- 발키리
		[CT.ClassType_Wizard]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 909 ),					-- 위자드
		[CT.ClassType_WizardWomen]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 910 ),					-- 위치
		[CT.ClassType_NinjaMan]			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 911 ),					-- 닌자
		[CT.ClassType_NinjaWomen]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 912 ),					-- 쿠노이치
	},			
				
	isAwakenWeaponContentsOpen = false																										-- 해당 직업의 각성 무기가 열려 있나 체크
}

function PaGlobal_AwakenSkill:initalize()
	self.isAwakenWeaponContentsOpen = self.awakenWeapon[getSelfPlayer():getClassType()]

	PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SKILL_AWAKEN_WEAPONS") )	-- 각성무기
	if self.isAwakenWeaponContentsOpen then
		PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:SetShow( true )
	else
		PaGlobal_Skill.radioButtons[PaGlobal_Skill.awakenTabIndex]:SetShow( false )
	end
end
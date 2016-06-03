local VCK = CppEnums.VirtualKeyCode
-----------------------------------
-- 전역 Key Event Main 함수!!!
-----------------------------------

--globalKeyBinder.lua에 같은 함수가 있지만, 여긴 플레이하지 않는 곳만 사용한다.( ex 로그인 화면 )
local GlobalKeyBinder_CheckKeyPressed = function( keyCode )
	return isKeyDown_Once( keyCode )
end

function GlobalKeyBinder_UpdateNotPlay( deltaTime )
	if MessageBox.isPopUp() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) or GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_SPACE ) then
			MessageBox.keyProcessEnter()
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			MessageBox.keyProcessEscape()
		end
		return
	end
	
	--로그인 화면에서 엔터키 사용	/ 이용약관이 떠있으면 엔터키, ESC키 사용가능하도록 추가  /	패스워드 화면이 떠있으면 엔터키, ESC키 사용 또는 계정명 입력 화면이 떠있으면 엔터키 사용
    if nil ~= Panel_Login and Panel_Login:GetShow() then
    	if nil ~= Panel_TermsofGameUse and Panel_TermsofGameUse:GetShow() then
    		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
    			FGlobal_HandleClicked_TermsofGameUse_Next()
    		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
    			FGlobal_TermsofGameUse_Close()
    		end
		elseif nil ~= Panel_Login_Password and Panel_Login_Password:GetShow() then
			if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
				LoginPassword_Enter()
			elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
				LoginPassword_Cancel()
			end
		elseif nil ~= Panel_Login_Nickname and Panel_Login_Nickname:GetShow() then
			return;
		elseif GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
			Panel_Login_BeforOpen()
        end
    end
	
	-- 캐릭터 선택화면에서 ESC 사용하면 이전 화면(서버선택화면)으로 이동
	-- if nil ~= Panel_CharacterSelect and Panel_CharacterSelect:GetShow() then
	-- 	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
	-- 		click_backServerSelect()
	-- 	end
	-- end

	if nil ~= Panel_CharacterSelectNew and Panel_CharacterSelectNew:GetShow() then
		if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_ESCAPE ) then
			CharacterSelect_Back()
		end
	end
	
	-- 캐릭터 생성 화면(캐릭터명 입력 화면)에서 ENTER키 사용
	-- if nil ~= Panel_CustomizationMain and Panel_CustomizationMain:GetShow() then
	-- 	if GlobalKeyBinder_CheckKeyPressed( VCK.KeyCode_RETURN ) then
	-- 		-- Panel_CharacterCreateOK_NewCustomization()
	-- 	end
	-- end
	
end

registerEvent("EventGlobalKeyBinderNotPlay",	"GlobalKeyBinder_UpdateNotPlay");

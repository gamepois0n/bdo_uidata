--[[ Lua 전용 유틸 함수들입니다.
\\ Time 관련 : Util.Time
\\ Math 관련 : Util.Math
\\ Lua Table 관련 : Util.Table
\\ Array 관련 : Util.Array
]]

-- 대표 건역 객체
Util = {}

-- global ShortCut!!!
local _math_floor = math.floor
local _math_sin = math.sin
local _math_cos = math.cos
local _math_pi = math.pi
local _math_sqrt = math.sqrt
local _math_atan2 = math.atan2

---------------------------------------------------
-- Time
---------------------------------------------------
local _time_Formatting = function(second)
	local formatter = {
		[0]	=PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
			,PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE")
			,PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR")
			,PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") };
	--"초", "분", "시간", "일" };

	if second == 0 then
		return tostring(0) .. formatter[0];
	end

	local timeVal = {};
	timeVal[0] = second;
	timeVal[1] = _math_floor(timeVal[0] / 60);
	timeVal[0] = timeVal[0] - timeVal[1] * 60;
	timeVal[2] = _math_floor(timeVal[1] / 60);
	timeVal[1] = timeVal[1] - timeVal[2] * 60;
	timeVal[3] = _math_floor(timeVal[2] / 24);
	timeVal[2] = timeVal[2] - timeVal[3] * 24;
	
	local resultString = "";

	for i = 0, 3, 1 do
		if 0 < string.len(resultString) then
			resultString = " " .. resultString;
		end
		if timeVal[i] > 0 then
			resultString = tostring(timeVal[i]) .. formatter[i] .. resultString;
		end
	end

	return resultString;
end

local _time_Formatting_Minute = function(second)
	local formatter = {
		[0]	=PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")
			,PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE")
			,PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR")
			,PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") };
	--"분", "시간", "일" };

	if second < 60 then
		return (" 0" .. formatter[1]);
	end

	local timeVal = {};
	timeVal[0] = second;
	timeVal[1] = _math_floor(timeVal[0] / 60);
	timeVal[0] = timeVal[0] - timeVal[1] * 60;
	timeVal[2] = _math_floor(timeVal[1] / 60);
	timeVal[1] = timeVal[1] - timeVal[2] * 60;
	timeVal[3] = _math_floor(timeVal[2] / 24);
	timeVal[2] = timeVal[2] - timeVal[3] * 24;
	
	local resultString = "";

	for i = 1, 3, 1 do
		if 0 < string.len(resultString) then
			resultString = " " .. resultString;
		end
		if timeVal[i] > 0 then
			resultString = tostring(timeVal[i]) .. formatter[i] .. resultString;
		end
	end

	return resultString;
end


local u64_Zero = Defines.u64_const.u64_0
local u64_1000 = Defines.u64_const.u64_1000
local u64_Hour = toUint64(0, 3600)
local u64_Minute = toUint64(0, 60)

local _time_Formatting_ShowTop = function(second_u64)
	if second_u64 > (u64_Hour)*toInt64(0,2) then
		local	recalc_time	= second_u64 / u64_Hour
		local	strHour		= string.format( "%d", Int64toInt32(recalc_time) )
		return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_HOUR", "time_hour", strHour )

	elseif second_u64 > u64_Minute then
		local	recalc_time = second_u64 / u64_Minute
		local	strMinute	= string.format( "%d", Int64toInt32(recalc_time) )
		return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_MINUTE", "time_minute", strMinute )

	else
		local	recalc_time	= second_u64
		local	strSecond	= string.format( "%d", Int64toInt32(recalc_time) )
		return PAGetStringParam1(Defines.StringSheet_GAME, "BUFF_SECOND", "time_second", strSecond )

	end			
end

local _time_GameTimeFormatting = function ( inGameMinute )
	local clockMinute = ( inGameMinute % 60 )
	local clockHour = _math_floor( inGameMinute / 60 )

	local calcMinute = "00"
	if clockMinute < 10 then
		calcMinute = "0" .. clockMinute
	else
	    calcMinute = "" .. clockMinute
	end

	local calcHour = "";
	if clockHour < 12 or clockHour == 24 then
		calcHour = "AM ";
	else
		calcHour = "PM ";
	end
	if clockHour > 12 then
		clockHour = clockHour - 12;
	end
	calcHour = calcHour .. tostring(clockHour) .. " : " .. calcMinute;

	return calcHour;
end

Util.Time =
{
	timeFormatting			= _time_Formatting,
	timeFormatting_Minute   = _time_Formatting_Minute,
	inGameTimeFormatting	= _time_GameTimeFormatting,
	inGameTimeFormattingTop	= _time_Formatting_ShowTop,
}

---------------------------------------------------
-- Math
---------------------------------------------------
local _math_calculateCross = function ( lho, rho )
	local v = {};
    return float3(lho.y * rho.z - lho.z * rho.y, lho.z * rho.x - lho.x * rho.z, lho.x * rho.y - lho.y * rho.x);
end

local _math_calculateDot = function ( lho, rho )
    return lho.x * rho.x + lho.y * rho.y + lho.z * rho.z;
end

local _math_calculateLength = function ( vector )
	return _math_sqrt(_math_calculateDot(vector, vector));
end

local _math_calculateDistance = function ( from, to )
	return _math_calculateLength(float3(from.x - to.x, from.y - to.y, from.z - to.z));
end

local _math_calculateNormalVector = function ( vector )
	local len = _math_calculateLength(vector);
	return float3(vector.x / len, vector.y / len, vector.z / len);
end

local _math_calculateSpinVector = function ( axis, radian )
	local axisCorss = _math_calculateCross( { x = 0, y = 1, z = 0 }, axis );
	local axisUp	= _math_calculateCross( axisCorss, axis );

	return _math_calculateNormalVector(float3(axisCorss.x * -_math_cos(radian) + axisUp.x * -_math_sin(radian), axisCorss.y * -_math_cos(radian) + axisUp.y * -_math_sin(radian), axisCorss.z * -_math_cos(radian) + axisUp.z * -_math_sin(radian)));
end

local _math_lerp = function ( from, to, factor )
	return from * (1.0 - factor) + to * factor;
end

local _math_lerpVector = function ( from, to, factor )
	return float3( _math_lerp(from.x, to.x, factor), _math_lerp(from.y, to.y, factor), _math_lerp(from.z, to.z, factor) );
end

local _math_calculateDirection = function ( from, to )
	return _math_calculateNormalVector(float3(to.x - from.x, to.y - from.y, to.z - from.z));
end

local _math_convertRotationToDirection = function ( radian )
	return{ x = -_math_sin(radian), y = 0, z = -_math_cos(radian) };
end

local _math_convertDirectionToRotation = function ( dir )
	return(_math_atan2( -dir.x, -dir.z ));
end

local _math_radianFix = function ( radian )
	local fixRadian = radian;
	if ( fixRadian < 0 ) then
		local nDivide = _math_floor( -fixRadian / ( _math_pi * 2 ) ) + 1;
		fixRadian = fixRadian + nDivide * _math_pi * 2;
	else
		local nDivide = _math_floor( fixRadian / ( _math_pi * 2 ) ) + 1;
		fixRadian = fixRadian - nDivide * _math_pi * 2;
	end

	return fixRadian;
end

local _math_calculateSinCurve = function (startPoint, endPoint, offset, height, rotate, lerpFactor)
	local SunHeight = _math_sin( lerpFactor * _math_pi ); -- Height -- 0.0 ~ 1.0;

	local resultPoint = float3(0, 0, 0);
	resultPoint.x = _math_lerp(startPoint.x, endPoint.x, lerpFactor);
	resultPoint.y = _math_lerp(startPoint.y, endPoint.y, lerpFactor);
	resultPoint.z = _math_lerp(startPoint.z, endPoint.z, lerpFactor);

	local spinAxis = _math_calculateDirection( endPoint, startPoint );
	spinAxis  = _math_calculateSpinVector( spinAxis, _math_pi * rotate );

	resultPoint.x = resultPoint.x + offset.x + spinAxis.x * SunHeight * height;
	resultPoint.y = resultPoint.y + offset.y + spinAxis.y * SunHeight * height;
	resultPoint.z = resultPoint.z + offset.z + spinAxis.z * SunHeight * height;

	return resultPoint;
end

local _math_AddVectorToVector = function ( lho, rho )
	return float3(lho.x + rho.x, lho.y + rho.y, lho.z + rho.z);
end

local _math_AddNumberToVector = function ( lho, rho )
	return float3(lho.x + rho, lho.y + rho, lho.z + rho);
end

local _math_MulNumberToVector = function ( lho, rho )
	return float3(lho.x * rho, lho.y * rho, lho.z * rho);
end

local _math_calculateSinCurveList = function (startPoint, endPoint, offset, height, rotate, lerpCount)
	local spinAxis = _math_calculateDirection( endPoint, startPoint );
	spinAxis  = _math_calculateSpinVector( spinAxis, _math_pi * rotate );

	local resultPointList = {};
	local lerpFactor;
	for i = 0, lerpCount, 1 do
		lerpFactor = i / lerpCount;
		resultPointList[i] = _math_AddVectorToVector( _math_AddVectorToVector( offset, _math_lerpVector(startPoint, endPoint, lerpFactor) ), _math_MulNumberToVector(spinAxis, _math_sin( lerpFactor * _math_pi ) * height));
	end

	return resultPointList;
end

Util.Math =
{
	calculateCross					= _math_calculateCross,
	calculateDot					= _math_calculateDot,
	calculateLength					= _math_calculateLength,
	calculateDistance				= _math_calculateDistance,
	calculateNormalVector			= _math_calculateNormalVector,
	calculateSpinVector				= _math_calculateSpinVector,
	Lerp							= _math_lerp,
	LerpVector						= _math_lerpVector,
	calculateDirection				= _math_calculateDirection,
	convertRotationToDirection		= _math_convertRotationToDirection,
	convertDirectionToRotation		= _math_convertDirectionToRotation,
	radianFix						= _math_radianFix,
	calculateSinCurve				= _math_calculateSinCurve,
	AddVectorToVector				= _math_AddVectorToVector,
	AddNumberToVector				= _math_AddNumberToVector,
	MulNumberToVector				= _math_MulNumberToVector,
	calculateSinCurveList			= _math_calculateSinCurveList,
}

---------------------------------------------------
-- Table
---------------------------------------------------
local _table_sizeofDictionary = function (dictionary)
	local size = 0;
	for key, values in pairs(dictionary) do
		size = size + 1;
	end
	return size;
end

local _table_isEmptyDictionary = function (dictionary)
	for key, values in pairs(dictionary) do
		return false;
	end
	return true;
end

local _table_fill = function( _table, _start, _end, _value )
	for ii = _start, _end do
		_table[ ii ] = _value
	end
end

Util.Table =
{
	sizeofDictionary	= _table_sizeofDictionary,
	isEmptyDictionary	= _table_isEmptyDictionary,
	fill				= _table_fill,
}

---------------------------------------------------
-- Array Class
---------------------------------------------------
Array = {}
Array.__index = Array

function Array.new()
	local arr = {}
	setmetatable( arr, Array )
	return arr
end

function Array:resize( _size, _value )
	if( #self < _size ) then
		_table_fill( self, #self+1, _size, _value )
	elseif( _size < #self ) then
		_table_fill( self, _size+1, #self, nil )
	end
end
function Array:fill( from, to, iter )
	local ii = 1
	iter = iter or 1
	for value = from, to, iter do
		self[ii] = value
		ii = ii + 1
	end
end
function Array:printi( f )
	f = f or print
	for k,v in ipairs(self) do
		f( v )
	end
end
function Array:length()
	return #self
end
function Array:push_back( msg )
	self[ self:length() + 1 ] = msg
end
function Array:pop_back()
	local length = self:length()
	local v = self[ length ]
	self[ length ] = nil
	return v
end
function Array:pop_front()
	if 0 < self:length() then
		local tmp, _length
		tmp = self[1]
		_length = self:length()
		for ii = 2, _length do
			self[ii-1] = self[ii]
		end
		self[ _length ] = nil
		return tmp
	end
	return
end
function Array:toString( deliminator )
	deliminator = deliminator or '\n'
	local tmpStr = ''
	for k,v in ipairs(self) do
		tmpStr = tmpStr .. v .. deliminator
	end
	return tmpStr
end
-- remark : @param f :: function( arr[i] , arr[j] );
-- i < j 이면 양수를 리턴
-- i > j 이면 음수를 리턴
-- i == j 이면 0 을 리턴
function Array:quicksort( f )
	if 'function' ~= type(f) then
		return
	end
	self.compFunc = f
	self:_quicksort(1, #self)
	self.compFunc = nil
end
function Array:_quicksort( is, ie )
	local mid = self:_sortPartition( is, ie )
	if is < mid then
		self:_quicksort( is, mid-1 )
	end
	if mid < ie then
		self:_quicksort( mid + 1, ie )
	end
end
function Array:_sortPartition( is, ie )
	-- local ir = math.random( is, ie ) 일관된 결과를 얻기 위해, sort seed 를 random 하게 뽑지 않는다!
	local ir = _math_floor((is + ie) / 2)
	self[ir], self[ie] = self[ie], self[ir]
	local i, j = is - 1, is
	while j < ie do
		if 0 < self.compFunc( self[j], self[ie] ) then
			i = i + 1
			self[i], self[j] = self[j], self[i]
		end
		j = j + 1
	end
	self[i+1], self[ie] = self[ie], self[i+1]
	return i+1
end


---------------------------------------------------
-- String Util Extention
---------------------------------------------------
local __string_find		= string.find
local __string_sub		= string.sub
local __string_len		= string.len

function string.split(str,pattern)
	local pattern_length	= __string_len(pattern)
	local str_length		= __string_len(str)

	if (pattern_length <= 0) or (str_length < pattern_length) then
		return { str }
	end

	local fStart, fEnd
	local index = 1
	local ii = 1
	local res = {}

	while true do
		if str_length < index then
			break
		end

		fStart, fEnd = __string_find( str, pattern, index, true )
		if nil == fStart then
			res[ii] = __string_sub( str, index, str_length )
			break
		end

		res[ii] = __string_sub( str, index, fStart - 1 )
		index = fEnd + 1
		ii = ii + 1
	end

	return res
end

--[[
local __string_split_unittest = function( src, pattern, count )
	count = count or 1
	local startTime = os.clock()
	local res
	for ii = 1, count do
		res = string.split(src, pattern)
	end
	for idx,v in ipairs(res) do
		print( '[' .. idx .. '] ' .. v)
	end
	print( 'string.split : ' .. (os.clock() - startTime) )
end

__string_split_unittest( '//123/456/789//', '/', 1000000 )
__string_split_unittest( '//123/456/789//', '/', 1000000 )
]]

function string.wlen( str )
	local len = string.len( str )
	local strwLen = 1
	local retVal = 0
	local byteVal = ""
	while strwLen <= len do
		byteVal = string.byte( str, strwLen )
		if byteVal >= 0x80 then
			strwLen = strwLen + 2
		else
			strwLen = strwLen + 1	
		end
		retVal = retVal + 1
	end
	return retVal
end

function GlobalExitGameClient()
	exitGameClient(true)
end

---------------------------------------------------
-- String By DateTime
-- 20130924:홍민우
---------------------------------------------------

function 	converStringFromLeftDateTime( s64_datetime )
	local leftDate = getLeftSecond_TTime64( s64_datetime )
	return convertStringFromDatetime( leftDate )
end

function	convertStringFromDatetime( s64_datetime )

	local s64_dayCycle 		= toInt64(0, (24*60*60) );
	local s64_hourCycle 	= toInt64(0, (60*60) );
	local s64_minuteCycle	= toInt64(0, 60);
	
	local s64_day			= s64_datetime / s64_dayCycle;
	local s64_hour			= (s64_datetime - (s64_dayCycle*s64_day)) / s64_hourCycle;
	local s64_minute		= (s64_datetime - (s64_dayCycle*s64_day) - ( s64_hourCycle*s64_hour ) ) / s64_minuteCycle;
	local s64_Second		= (s64_datetime - (s64_dayCycle*s64_day) - ( s64_hourCycle*s64_hour ) - ( s64_minuteCycle*s64_minute ) );
	
	local	strDate	= "";
	if( Defines.s64_const.s64_0 < s64_day ) and ( Defines.s64_const.s64_0 < s64_hour ) then
		strDate	= ( tostring(s64_day).. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") .. tostring(s64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR") )
	elseif( Defines.s64_const.s64_0 < s64_day ) then
		strDate	= ( tostring(s64_day).. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") )	
	elseif( Defines.s64_const.s64_0 < s64_hour ) then
		strDate	= (  tostring(s64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR") .. tostring(s64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE"))
	elseif( Defines.s64_const.s64_0 < s64_minute ) then
		strDate	= (  tostring(s64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE") ..  tostring(s64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND"))
	elseif( Defines.s64_const.s64_0 <= s64_Second ) then
		strDate	= (  tostring(s64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND") )
	else
		strDate	= ( "" )
	end
	return(strDate)
end

function	convertStringFromDatetimeOverHour( s64_datetime )


	local s64_dayCycle 		= toInt64(0, (24*60*60) );
	local s64_hourCycle 	= toInt64(0, (60*60) );
	
	local s64_day				= s64_datetime / s64_dayCycle;
	local s64_hour			= (s64_datetime - (s64_dayCycle*s64_day)) / s64_hourCycle;
	
	local	strDate	= "";
	if( Defines.s64_const.s64_0 < s64_day ) then
		strDate	= ( tostring(s64_day).. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") )
	elseif( Defines.s64_const.s64_0 < s64_hour ) then
		strDate	= (  tostring(s64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR") )
	else
		strDate	= ( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR_IN") )
	end
	return(strDate)
end

function	convertStringFromMillisecondtime( u64_Millisecondtime )
	local u64_dayCycle 		= toUint64(0, (24*60*60*1000) );
	local u64_houseCycle 	= toUint64(0, (60*60*1000) );
	local u64_minuteCycle	= toUint64(0, 60*1000);
	
	local u64_day			= u64_Millisecondtime / u64_dayCycle;
	local u64_hour			= (u64_Millisecondtime - (u64_dayCycle*u64_day)) / u64_houseCycle;
	local u64_minute		= (u64_Millisecondtime - (u64_dayCycle*u64_day) - ( u64_houseCycle*u64_hour ) ) / u64_minuteCycle;
	local u64_Second		= (u64_Millisecondtime - (u64_dayCycle*u64_day) - ( u64_houseCycle*u64_hour ) - ( u64_minuteCycle*u64_minute ) ) / toUint64(0,1000);

	local	strDate	= "";
	if( Defines.u64_const.u64_0 < u64_day ) then
		strDate	= ( tostring(u64_day).. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") .. tostring(u64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR"))
	elseif( Defines.u64_const.u64_0 < u64_hour ) then
		strDate	= (  tostring(u64_hour) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR") .. tostring(u64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE"))
	elseif( Defines.u64_const.u64_0 < u64_minute ) then
		strDate	= (  tostring(u64_minute) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE") ..  tostring(u64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND"))
	elseif( Defines.u64_const.u64_0 < u64_Second ) then
		strDate	= (  tostring(u64_Second) .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND") )
	else
		strDate	= ( "" )
	end
	return(strDate)
end

local UI_color 		= Defines.Color
local UI_CT 		= CppEnums.ChatType
local UI_CNT	 	= CppEnums.EChatNoticeType

function Chatting_MessageColor(msgChatType, msgNoticeType)
	local msgColor = UI_color.C_FFE7E7E7
	
	if (UI_CT.Public ==  msgChatType) then
		msgColor = UI_color.C_FFE7E7E7
	elseif (UI_CT.Party ==  msgChatType) then
		msgColor = UI_color.C_FF8EBD00
	elseif (UI_CT.Guild ==  msgChatType) then
		msgColor = UI_color.C_FF84FFF5
	elseif (UI_CT.World ==  msgChatType) then
		msgColor = UI_color.C_FFFF973A
	elseif (UI_CT.Private ==  msgChatType) then
		msgColor = UI_color.C_FFF601FF 
	elseif (UI_CT.System ==  msgChatType) then	
		msgColor = UI_color.C_FFC4BEBE
	elseif (UI_CT.Notice ==  msgChatType) and (UI_CNT.Normal ==  msgNoticeType) then	
		msgColor = UI_color.C_FFFFEF82
	elseif (UI_CT.Notice ==  msgChatType) and (UI_CNT.Campaign ==  msgNoticeType) then	
		msgColor = UI_color.C_FFBBFF84
	elseif (UI_CT.Notice ==  msgChatType) and (UI_CNT.Emergency ==  msgNoticeType) then	
		msgColor = UI_color.C_FFFF4B4B
	elseif (UI_CT.Alliance ==  msgChatType) then
		msgColor = UI_color.C_FF84FFF5
	elseif ( UI_CT.WorldWithItem == msgChatType ) then
		msgColor = UI_color.C_FF00F3A0
	--elseif (UI_CT.Market ==  msgChatType) then
	--	msgColor = UI_color.C_FF8EBD00	
	elseif ( UI_CT.LocalWar == msgChatType ) then
		msgColor = UI_color.C_FFB97FEF
	elseif ( UI_CT.RolePlay == msgChatType ) then
		msgColor = 4278236415					-- UI_color.C_FF00B4FF
	end	

	return msgColor
end

function	getUseMemory()
	return collectgarbage("count", 0)
end

function in_array ( e, t )	--	e : 변수, t : 배열
	for _,v in pairs(t) do
		if (v==e) then return true end
		end
	return false
end

function getContryTypeLua()	
	local returnValue = -1
	local gameServiceType = getGameServiceType()
	local eCountryType = CppEnums.CountryType;

	if eCountryType.NONE == gameServiceType or eCountryType.DEV == gameServiceType
	 or eCountryType.KOR_ALPHA == gameServiceType or eCountryType.KOR_REAL == gameServiceType
	  or eCountryType.KOR_TEST == gameServiceType then
		-- 한국
		returnValue = CppEnums.ContryCode.eContryCode_KOR
	elseif eCountryType.JPN_ALPHA == gameServiceType or eCountryType.JPN_REAL == gameServiceType then
		-- 일본
		returnValue = CppEnums.ContryCode.eContryCode_JAP
	elseif eCountryType.RUS_ALPHA == gameServiceType or eCountryType.RUS_REAL == gameServiceType then
		-- 러시아
		returnValue = CppEnums.ContryCode.eContryCode_RUS
	elseif eCountryType.CHI_ALPHA == gameServiceType or eCountryType.CHI_REAL == gameServiceType then
		-- 중국
		returnValue = CppEnums.ContryCode.eContryCode_CHI
	elseif eCountryType.NA_ALPHA == gameServiceType or eCountryType.NA_REAL == gameServiceType then
		returnValue = CppEnums.ContryCode.eContryCode_NA
	else	-- 그외
		returnValue = CppEnums.ContryCode.eContryCode_Count
	end

	return returnValue
end

function isGameTypeThisCountry( country )
	if( country == getContryTypeLua() ) then
		return true;
	end

	return false;
end

function getGameContentsServiceType()
	local returnValue = -1
	local gameContentServiceType = getContentsServiceType()
	local eContentType = CppEnums.ContentsServiceType;

	if eContentType.eContentsServiceType_Closed == gameContentServiceType then		-- 비공개
		returnValue = eContentType.eContentsServiceType_Closed
	elseif eContentType.eContentsServiceType_CBT == gameContentServiceType then		-- CBT
		returnValue = eContentType.eContentsServiceType_CBT
	elseif eContentType.eContentsServiceType_Pre == gameContentServiceType then		-- 사전 다운로드 기간(커스터마이징만 가능.)
		returnValue = eContentType.eContentsServiceType_Pre
	elseif eContentType.eContentsServiceType_OBT == gameContentServiceType then		-- OBT서비스
		returnValue = eContentType.eContentsServiceType_OBT
	elseif eContentType.eContentsServiceType_Commercial == gameContentServiceType then	-- 상용화
		returnValue = eContentType.eContentsServiceType_Commercial
	else
		returnValue = eContentType.eContentsServiceType_Count
	end

	return returnValue
end

function isGameContentServiceType( serviceType )
	if ( serviceType == getGameContentsServiceType() ) then
		return true;
	end

	return false;
end

function isGameTypeKorea()
	-- local gameServiceType = getGameServiceType()
	-- local koreaArray = {0, 1, 2, 3, 4}
	-- if in_array ( gameServiceType, koreaArray ) then
	-- 	return true
	-- else
	-- 	return false
	-- end

	return isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR );
end

function isGameTypeRussia()
	return isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_RUS );
end

function isGameTypeJapan()
	return isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_JAP );
end

function isGameTypeEnglish()
	return isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_NA );
end

function isCommonGameType()
	local returnValue = false
	if isGameTypeJapan() then
		returnValue = true
	elseif isGameTypeRussia() then
		returnValue = true
	elseif isGameTypeEnglish() then
		returnValue = true
	else
		returnValue = false
	end
	return returnValue
end

function isItemMarketSecureCode()
	local isSecureCode = true	-- secureCode 사용여부 (전체 끄려면 여기 false)
	if (isGameTypeKorea() or isGameTypeJapan() or isGameTypeRussia() or isGameTypeEnglish()) and true == isSecureCode then
		return true
	else
		return false
	end
end

--[[ 루아 타이머

]]--

local timerObject = { 
	_timerNo = 0,
	_endTime = 0,
	_function = nil,
	_isRepeat = false,
	_repeatTime = 0
}

local g_TimerNo = 0
local g_Timerlist = {}
local g_TimerCount = 0;

function luaTimer_UpdatePerFrame( fDelta )

	if( g_TimerCount <= 0 ) then
		return;
	end
	
	local currentTickCount = getTickCount32();
	local removeTimerList = {}
	local removeIndex = 1
	for index, timer in pairs( g_Timerlist ) do
	
		if( nil ~= timer ) then
			
			if( timer._endTime <= currentTickCount  ) then
				
				timer._function()	-- 호출
			
				if( false == timer._isRepeat ) then
					--removeTimerList[removeIndex] = index
					--removeIndex = removeIndex + 1
					local tempIndex = timer._timerNo;
					g_Timerlist[ tempIndex ] = nil	
					g_TimerCount = g_TimerCount - 1;
				else
					timer._endTime = currentTickCount + timer._repeatTime;
				end
				
			end				
		else
			_PA_LOG("LUA" , "timer 가 nil 이다~~!!!!" );
		end
	
	end
end

function luaTimer_AddEvent( func, endTime, isRepeat, repeatTime )
	
	g_TimerNo = g_TimerNo + 1;

	local tempTimer = {};
	tempTimer._timerNo = g_TimerNo;
	tempTimer._endTime = getTickCount32() + endTime;
	tempTimer._function = func;
	tempTimer._isRepeat = isRepeat;
	tempTimer._repeatTime = remainTime;
	
	if( nil == g_Timerlist ) then
		g_Timerlist = {}
	end
	
	g_Timerlist[g_TimerNo] = tempTimer
	g_TimerCount = g_TimerCount + 1;

	return g_TimerNo
end

function luaTimer_RemoveEvent( timerNo )

	if( nil ~= g_Timerlist[timerNo] ) then 
		g_Timerlist[timerNo] = nil
		g_TimerCount = g_TimerCount - 1;
	end

end

registerEvent( "FromClient_LuaTimer_UpdatePerFrame", "luaTimer_UpdatePerFrame" )
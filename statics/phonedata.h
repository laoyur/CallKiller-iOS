#ifndef _PHONEDATA_H_
#define _PHONEDATA_H_

#if defined(_WIN32)
	#if _MSC_VER >= 1600
		#pragma execution_character_set("utf-8")
	#else
		#error Visual Studio 2010 SP1 or above required
	#endif
#endif

#include <vector>
#include <cstdint>
#include <string>
#include <sstream>
#include <iostream>

enum CARDTYPE
{
	UNKNOWN = 0,	// 未知，查找失败
	CMCC,			// 中国移动
	CUCC,			// 中国联通
	CTCC,			// 中国电信
	CTCC_V,			// 电信虚拟运营商
	CUCC_V,			// 联通虚拟运营商
	CMCC_V			// 移动虚拟运营商
};

enum DATALEN
{
	CHAR_LENGTH  = 1,
	INT_LENGTH	 = 4,
	PHONE_LENGTH = 7,
	HEAD_LENGTH  = 8,
	PHONE_INDEX_LENGTH = 9
};

enum RECORD
{
	PROVINCE = 0,	// 省份
	CITY,			// 城市
	ZIPCODE,		// 邮编
	AREACODE		// 长途区号
};

std::string getPhoneType(CARDTYPE type);

struct PhoneInfo
{
	PhoneInfo() 
		: type(UNKNOWN), phone(0) {	}

	CARDTYPE type;
	uint32_t phone;
	std::string zipCode;
	std::string areaCode;
	std::string province;
	std::string city;
};

struct DataHead
{
	char version[4];
	uint32_t offset;
};

struct Record
{
	uint32_t phone;
	uint32_t offset;
	uint8_t type;
};

class PhoneData
{
public:
	PhoneData(const char *path);
    std::string version();
	PhoneInfo lookUp(int64_t phone) const;
	PhoneInfo lookUp(const std::string &phone) const;

private:
	PhoneInfo _lookUp(uint32_t phone7) const;
	static std::string getRecordContent(const std::vector<char> &buffer, size_t startOffset);

private:
	std::vector<char> buffer;
	DataHead *head;
	size_t recordCount;
};

#endif // !_PHONEDATA_H_

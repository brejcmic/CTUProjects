/* rtc.h
 * 
 */
 //---------------------------------------------------------
 //Adresy zarizeni PCF8563
 //---------------------------------------------------------
 #define RTC_READ			0xA3
 #define RTC_WRITE			0xA2
 
 //---------------------------------------------------------
 //Adresy registru
 //---------------------------------------------------------
 /*Kontrolni a stavove registry */
 #define RTC_CTRL_STAT1		0x00
 #define RTC_CTRL_STAT2		0x01
 
 /*Registry s casem */
 #define RTC_SECONDS		0x02
 #define RTC_MINUTES		0x03
 #define RTC_HOURS			0x04
 #define RTC_DAYS			0x05
 #define RTC_WEEK_DAYS		0x06
 #define RTC_MONTHS			0x07
 #define RTC_YEARS			0x08
 
 /*Alarmy */
 #define RTC_A_MINUTES		0x09
 #define RTC_A_HOUR			0x0A
 #define RTC_A_DAY			0x0B
 #define RTC_A_WEEK_DAY		0x0C
 
 /*CLKOUT ridici registr*/
 #define RTC_CLKOUT_CTRL	0x0D
 
 /*Casovace*/
 #define RTC_TIMER_CTRL		0x0E
 #define RTC_TIMER			0x0F
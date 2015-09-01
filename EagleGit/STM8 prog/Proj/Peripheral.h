/* Peripheral.h
 * 
 */
 
 //---------------------------------------------------------
 //masky bitu
 
 #define	P_B0					0x01
 #define	P_B1					0x02
 #define	P_B2					0x04
 #define	P_B3					0x08
 
 #define	P_B4					0x10
 #define	P_B5					0x20
 #define	P_B6					0x40
 #define	P_B7					0x80
 
 //---------------------------------------------------------
 //masky a konstanty pro uart
 #define	UART_RX_BUF_LEN			32 //musi byt mocnina 2
 #define	UART_RX_BUF_IDX_MSK		(UART_RX_BUF_LEN-1)
 
 #define	UART_TX_BUF_LEN			8 //musi byt mocnina 2
 #define	UART_TX_BUF_IDX_MSK		(UART_TX_BUF_LEN-1)
 
 //---------------------------------------------------------
 //masky a konstanty pro i2c
 #define	I2C_ADDR_READ			0xA3
 #define	I2C_ADDR_WRITE			0xA2
 
 #define	I2C_ST_BUSYR			0x01
 #define	I2C_ST_BUSYW			0x02
 #define	I2C_ST_UPDATE			0x04
 #define	I2C_ST_BCDCUT			0x08
 #define	I2C_ST_WRITE			0x10
 #define	I2C_ST_PRINT			0x80
 
 #define	I2C_SR1_SB				0x01
 #define	I2C_SR1_ADDR			0x02
 #define	I2C_SR1_BTF				0x04
 #define	I2C_SR1_STOPF			0x10
 #define	I2C_SR1_RXNE			0x40
 #define	I2C_SR1_TXE				0x80
 
 #define	I2C_CR2_START			0x01
 #define	I2C_CR2_STOP			0x02
 #define	I2C_CR2_ACK				0x04
 
 void InitPeripherals(void);
 void setOutput(char val);
 char readInput(void);
 char printMsg(char *message);
 void rtcPrint(void);
 char rtcWrite(char addr, char val);
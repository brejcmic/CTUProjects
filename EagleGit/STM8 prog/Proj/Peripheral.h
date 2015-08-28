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
 
 #define	I2C_ST_INIT				0x10
 #define	I2C_ST_READ				0x20
 #define	I2C_ST_SET				0x40
 #define	I2C_ST_PRINT			0x80
 
 #define	I2C_SR1_SB				0x01
 #define	I2C_SR1_ADDR			0x02
 
 void InitPeripherals(void);
 void setOutput(char val);
 char readInput(void);
 char printMsg(char *message);
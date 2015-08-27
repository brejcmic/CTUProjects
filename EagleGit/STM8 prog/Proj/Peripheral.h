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
 
 #define	UART_RX_BUF_LEN			32 //musi byt mocnina 2
 #define	UART_RX_BUF_IDX_MSK		(UART_RX_BUF_LEN-1)
 
 #define	UART_TX_BUF_LEN			8 //musi byt mocnina 2
 #define	UART_TX_BUF_IDX_MSK		(UART_TX_BUF_LEN-1)
 
 void InitPeripherals(void);
 void setOutput(char val);
 char readInput(void);
 char printMsg(char *message);
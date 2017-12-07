watch_dog_base		  EQU      0x53000000;�}������}
		IMPORT xmain ;�D�{��
		
		;IMPORT  |Image$$SRAM$$Base| ;SRAM���s��}
				
		
			 PRESERVE8 ;SP 8�r�`���
         AREA RESET, CODE, READONLY
      
		 ENTRY
 
start
         bl disable_watchdog
on_sdram
         ldr sp,=4096
         ldr r0,=xmain
		 ;add r0,r0,#8
		 ;movs pc,r0
		 bl xmain
halt
         B halt
		 
disable_watchdog
		ldr r0,=watch_dog_base
		mov r1,#0
		str r1,[r0]
		mov pc,lr
	END
#include "S3C2440.h"
#include "config.h"
.text
.global _start

_start:


/*----------�����ݪ���-----------*/
ldr r0 , =pWTCON
mov r1,#0
str r1,[r0]
/*-------------------------------*/

/*----------�]�m����-------------*/
ldr	r0, =CLKDIVN
mov	r1, #3
str	r1, [r0]

/*
�]�����W�t�m�� FCLK:HCLK:PCLK = 1:2:4
�]��HCLK�D0 ������U���컡 �o�ر��p�U�n�]�m�����Bbus

�]�m���Bbus
*/
mrc p15,0,r1,c1,c0,0
orr r1,r1,#0xc0000000
mcr p15,0,r1,c1,c0,0

/*
    set MPLL_200M
	���W�t�m������ �Y�i�]�m�W�v
	FCLK=200M HCLK=400M PCLK=800M
*/
	ldr r0,=MPLLLCON 
	ldr r1,=S3C2440_MPLL_200M
	str r1,[r0]
/*----------------------------------*/


/*----------�t�m�s�x�޲z����SDRAM�i�H�ϥ�-------------*/
	ldr r0,=BWSCON
	adr r1,sdram_config
	add r3,r0,#(13*4)
	
0:	
	ldr r2,[r1],#4
	str r2,[r0],#4
	cmp r0,r3
	bne 0b
/*------------------------------------------------------*/

/*--------------�N�N�X�ƻs��N�X���өҦb���챵�a�}�W------------------*/
	ldr sp,=0x34000000
	bl     uart0_init
	/*
		���F�o��N�X�q���סA�i�H�g�L²�檺�B�⭫�챵�}�� ex : bss�q�_�I - _start(�N�X�q�_�l�I)
		�U���N�X�N�O�n�N�쥻0�a�}���N�X�ƻs��_start�챵�}���]�w���a�}�A�᭱����~�i�H������j��RAM����
	*/
	ldr r0,=0
	ldr r1,=_start
	ldr r2,=__bss_start
	sub r2,r2,r1
	bl	copy_code_to_SDRAM
	bl 	clean_bss
	
	
	
/*----------------------�����main------------------------*/
	ldr lr,=halt
	ldr pc,=main	
halt:
	b	halt

sdram_config:
	.long 0x22011110	 //BWSCON
	.long 0x00000700	 //BANKCON0
	.long 0x00000700	 //BANKCON1
	.long 0x00000700	 //BANKCON2
	.long 0x00000700	 //BANKCON3  
	.long 0x00000700	 //BANKCON4
	.long 0x00000700	 //BANKCON5
	.long 0x00018005	 //BANKCON6
	.long 0x00018005	 //BANKCON7
	.long 0x008C04F4	 // REFRESH
	.long 0x000000B1	 //BANKSIZE
	.long 0x00000030	 //MRSRB6
	.long 0x00000030	 //MRSRB7


	
kpK        bit   00h
FLAG       BIT   01H
COUNTER    DATA  30H


                ORG     0000h
                LJMP    RT

          ORG    000BH          ;TIMER INT-0
          PUSH   ACC
          PUSH   PSW
          LCALL  CAMERA
          POP    PSW
          POP    ACC	
	  RETI 

 RT:
                MOV    p3,#0ffh
                MOV    sp,#60H
		mov    p2,#00h
		MOV    IE,#82H
	        MOV    TMOD,#01H
        	MOV    TH0,#0FFH
        	MOV    TL0,#0FFH
                mov    p1,#0ffh
	        setb   p2.7
		CLR    KPK
		CLR    FLAG
CLR TR0
		

      MAIN:    JNB     p1.4,lc0     ;\\storbe signal\\
               LCALL   chk_value
        lc0:   ljmp    main



chk_value:  	MOV	a,p1
		anl	a,#0fh
                cjne    a,#02h,l1
                clr p2.0
		clr p2.3
	        setb p2.1
	        setb p2.2
		setb p2.6
		SETB p2.7

                ret
	l1: cjne  a,#05h,l3
                clr p2.1
	        clr p2.2
	        setb p2.0
	        setb p2.3
	        setb p2.6
	        SETB p2.7
	         ret
       l3:     cjne a,#01h,l5
		clr p2.0
	        clr p2.2
		setb p2.1
	        setb p2.3
		setb p2.6
        	SETB p2.7
               ret        

        l5:     cjne    a,#03h,l7
	       clr p2.1
	       clr p2.3
	       setb p2.0
	       setb p2.2
	       setb p2.6
        	SETB p2.7
		ret

        l7:   cjne    A,#0AH,L9
               setb p2.6
	       setb p2.0
	       setb p2.1
	       setb p2.2
	       setb p2.3
	       clr  p2.7
	       CLR  TR0
	       setb p2.4
	       setb p2.5
	        ret
         L9:  cjne a,#06h,L10
	      SETB  P2.7
	      SETB  TR0
              RET
         L10:  cjne a,#07h,L11
               SETB p2.7
	       setb p2.4
	       setb p2.5
	       CLR  TR0
L11:	       ret

CAMERA:
JB   KPK,GOON
JB   P3.2,CHK
CPL  FLAG
SETB KPK
CHK:
JNB  FLAG,CHK1
CLR  P2.4
SETB P2.5
AJMP OUT
CHK1:
SETB  P2.4
CLR   P2.5
OUT:
MOV  TH0,#0F0H
MOV  TL0,#00H
RET
GOON:INC COUNTER
MOV A,COUNTER
CJNE A,#0FFH,OUT
MOV COUNTER,#00H
CLR KPK
AJMP OUT


		end

;------------------------------------------------------------------------
;	Base para TRABALHO PRATICO - TECNOLOGIAS e ARQUITECTURAS de COMPUTADORES
;   
;	ANO LECTIVO 2022/2023
;--------------------------------------------------------------
; Demostra��o da navega��o do cursor do Ecran 
;
;		arrow keys to move 
;		press ESC to exit
;
;--------------------------------------------------------------

.8086
.model small
.stack 2048

dseg	segment para public 'data'



        Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
        Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
        Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
        Fich         	db      'jogo.TXT',0
		FichNome		db		'nomes.TXT',0
		FichMenu		db 		'menu.TXT', 0
        HandleFich      dw      0
		HandleNome      dw      0
		HandleMenu		dw		0
		car_menu		db 		0
		car_nome		db 		0
        car_fich        db      ?


		Car				db	32	; Guarda um caracter do Ecran 
		Car2 			db 	32  ; Guarda um caracter do Ecran 
		Car3 			db 	32  ; Guarda um caracter do Ecran
		Cor				db	7	; Guarda os atributos de cor do caracter
		POSy			db	1	; a linha pode ir de [1 .. 25]
		POSx			db	2	; POSx pode ir [1..80]	

		nomeJ1			db 		? ; Guarda o nome do jogador 1
		nomeJ2			db		? ; Guarda o nome do jogador 2

dseg	ends

cseg	segment para public 'code'
assume		cs:cseg, ds:dseg



;########################################################################
goto_xy	macro		POSx,POSy
		mov		ah,02h
		mov		bh,0		; numero da pagina
		mov		dl,POSx
		mov		dh,POSy
		int		10h
endm


;ROTINA PARA APAGAR ECRAN


apaga_ecran	proc
			mov		ax,0B800h
			mov		es,ax
			xor		bx,bx
			mov		cx,25*80
		
apaga:		mov		byte ptr es:[bx],' '
			mov		byte ptr es:[bx+1],7
			inc		bx
			inc 	bx
			loop	apaga
			ret
apaga_ecran	endp


;#############################################################################
;ROTINA PARA MUDAR COR

cor_x	proc
		xor		bx,bx
		mov		cx,25*80
		
muda:	
		mov al, es:[bx]
		cmp al,'X'
		jne next
		mov		byte ptr es:[bx+1],4   ;AQUI COLOCAS A COR DOS X!!!!!!!!
next:	
		inc bx
		inc bx
		loop 	muda
fim:
		ret
		
cor_x	endp


cor_o	proc
		xor		bx,bx
		mov		cx,25*80
		
muda:	
		mov al, es:[bx]
		cmp al,'O'
		jne next
		mov		byte ptr es:[bx+1],3   ;AQUI COLOCAS A COR DOS 0!!!!!!!!
next:	
		inc bx
		inc bx
		loop 	muda
fim:
		ret
		
cor_o	endp

cor_nome_jogador proc
		 mov 	si, 240 	; origem(01,40)	

ciclo:
		mov al,es:[si] ; le caracter
		cmp al, ' '
		je fim
		mov		byte ptr es:[si+1],7 
		inc si
		inc si
		loop ciclo 
fim: 
	ret
cor_nome_jogador endp

cor_espetador proc
mov 	si, 400 	; origem(02,40)	

ciclo:
		mov al,es:[si] ; le caracter
		cmp al, ' '
		je fim
		mov		byte ptr es:[si+1],8	 
		inc si
		inc si
		loop ciclo 
fim: 
	ret
cor_espetador endp
;########################################################################

;########################################################################
; IMP_NOMES

IMP_NOMES	PROC

		;abre ficheiro
        mov     ah,3dh
        mov     al,0
        lea     dx,FichNome
        int     21h
        jc      erro_abrir
        mov     HandleNome,ax
        jmp     ler_ciclo

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai_m

ler_ciclo:
        mov     ah,3fh
        mov     bx,HandleNome
        mov     cx,1
        lea     dx,car_nome
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_nome
		int		21h
		jmp		ler_ciclo

erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleNome
        int     21h
        jnc     sai_m

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h
sai_m:	
		RET
		
IMP_NOMES	endp


;########################################################################
; IMP_MENU

IMP_MENU	PROC

		;abre ficheiro
        mov     ah,3dh
        mov     al,0
        lea     dx,FichMenu
        int     21h
        jc      erro_abrir
        mov     HandleMenu,ax
        jmp     ler_ciclo

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai_m

ler_ciclo:
        mov     ah,3fh
        mov     bx,HandleMenu
        mov     cx,1
        lea     dx,car_menu
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_menu
		int		21h
		jmp		ler_ciclo

erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleMenu
        int     21h
        jnc     sai_m

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h
sai_m:	
		RET
		
IMP_MENU	endp


;########################################################################
; IMP_FICH

IMP_FICH	PROC

		;abre ficheiro
        mov     ah,3dh
        mov     al,0
        lea     dx,Fich
        int     21h
        jc      erro_abrir
        mov     HandleFich,ax
        jmp     ler_ciclo

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai_f

ler_ciclo:
        mov     ah,3fh
        mov     bx,HandleFich
        mov     cx,1
        lea     dx,car_fich
        int     21h
		jc		erro_ler
		cmp		ax,0		;EOF?
		je		fecha_ficheiro
        mov     ah,02h
		mov		dl,car_fich
		int		21h
		jmp		ler_ciclo

erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai_f

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h
sai_f:	
		RET
		
IMP_FICH	endp	
	


;########################################################################
; LE UMA TECLA	

LE_TECLA	PROC
		
		mov		ah,08h
		int		21h
		mov		ah,0
		cmp		al,0
		jne		SAI_TECLA
		mov		ah, 08h
		int		21h
		mov		ah,1
SAI_TECLA:	RET
LE_TECLA	endp

LE_TECLA_MENU PROC
		MOV	ah,08H
		INT	21H
		MOV	ah,0
		CMP	al,0
		JNE	SAI_TECLA
		MOV	ah, 08H
		INT	21H
		MOV ah, 1

SAI_TECLA:	
		RET
LE_TECLA_MENU	ENDP


LE_TECLADO_MENU PROC
		MOV	ah,08H
		INT	21H
		MOV	ah,0
		CMP	al,0
		JNE	SAI_TECLA
		MOV	ah, 08H
		INT	21H
		MOV	ah, 02h
		MOV dl, al
		int 21h

SAI_TECLA:	
		RET
LE_TECLADO_MENU	ENDP


;########################################################################
; Assinala caracter no menu no ecran	

assinala_Menu	PROC
		mov POSx, 29
		mov POSy, 3

CICLO:	
		; goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		; mov		ah, 02h
		; mov		dl, Car	; Repoe Caracter guardado 
		; int		21H		
		
		
		goto_xy	POSx,POSy	; Vai para nova posição
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h			; Read Character and Attribute at Cursor Position
		mov		Car2, al		; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah		; Guarda a cor que está na posição do Cursor
		
LER_SETA:	
		call 	LE_TECLA_MENU
		cmp		ah, 1
		je		ESTEND
		
		CMP 	AL, 27	; ESCAPE
		JE		FIM
		CMP		AL, 13  ; ENTER
		je		ASSINALA
		jmp		LER_SETA
		
ESTEND:	cmp 	al,48h
		jne		BAIXO
		dec		POSy		;cima
		dec		POSy
		dec		POSy
		dec		POSy
		dec		POSy
		cmp 	POSy, -2
		jbe		RETURNUP
		jmp		CICLO

RETURNUP: 						;Não sai por cima do tabuleiro
		mov POSy, 3
		jmp CICLO

BAIXO:	cmp		al,50h
		jne		LER_SETA 		;É só para andar para cima e para baixo
		inc 	POSy		;Baixo
		inc 	POSy
		inc 	POSy
		inc 	POSy
		inc 	POSy
		cmp 	POSy, 13
		jae		RETURNDOWN
		jmp		CICLO

RETURNDOWN: 						;Não sai por cima do tabuleiro
		mov POSy, 8
		jmp CICLO


ASSINALA:
		cmp POSy, 3
		je 		fim
		cmp POSy, 8
		je		SAIR
		jmp		CICLO

SAIR:
		call 	apaga_ecran
		goto_xy	0,0
		mov     ah,4ch
        int     21h

fim:	
		RET
assinala_Menu	endp
;########################################################################


;########################################################################
; Assinala caracter no menu no ecran	

assinala_Nomes	PROC
		mov POSx, 18
		mov POSy, 3

CICLO:	
		 goto_xy	18,3	; Vai para a posição anterior do cursor
		 mov		ah, 02h
		 mov		dl, Car3	; Repoe Caracter guardado 
		 int		21H		
		
		
		goto_xy	POSx,POSy	; Vai para nova posição
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h			; Read Character and Attribute at Cursor Position
		mov		Car3, al		; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah		; Guarda a cor que está na posição do Cursor
		
LER_SETA:	
		call 	LE_TECLA_MENU
		cmp		ah, 1
		je		ESTEND
		
		
		CMP		AL, 13  ; ENTER
		je		ASSINALA
		goto_xy	POSx,POSy 	; verifica se pode escrever o caracter no ecran
		mov		CL, Car3
		;cmp		CL, 32		; Só escreve se for espaço em branco
		;JNE 	LER_SETA
		mov		ah, 02h		; coloca o caracter lido no ecra
		mov		dl, al
		int		21H	
		CMP 	al, 8h		; CARACTER DE APAGAR
		JE		APAGA_CAR
		CMP 	POSX, 45
		JNGE	INC_POSX
		;CMP 	POSY, 3
		;JNA 	RESETA	
		goto_xy	18,POSy
		jmp		LER_SETA

INC_POSX:
		INC POSX

;RESETA:
;		goto_xy	18,5

APAGA_CAR:
		CMP POSX, 18
		JNG	LER_SETA
		;ADD POSX, -1	
		goto_xy	POSx,POSy
		MOV Car3, 32
		mov		ah, 02h		; coloca o caracter lido no ecra
		mov		dl, Car3
		int		21H	
		;DEC POSX 

		
;TECLADO:
		;CALL LE_TECLADO_MENU
ESTEND:	cmp 	al,48h
		jne		BAIXO
		dec		POSy		;cima
		dec		POSy
		cmp 	POSy, 7
		jbe		RETURNUP
		jmp		CICLO

RETURNUP: 						;Não sai por cima do tabuleiro
		mov POSy, 3
		mov POSx, 18
		jmp CICLO

BAIXO:	cmp		al,50h
		jne		LER_SETA 		;É só para andar para cima e para baixo
		inc 	POSy		;Baixo
		inc 	POSy
		cmp 	POSy, 7
		jae		RETURNDOWN
		jmp		CICLO

RETURNDOWN: 						;Não sai por cima do tabuleiro
		mov POSy, 7
		mov POSx, 28
		jmp CICLO


ASSINALA:
		cmp POSy, 7
		je 		fim
		cmp POSy, 28
		je		SAIR
		jmp		CICLO

POS_NOME1:
mov ax, 0B800h ; mem.video
     mov es, ax

	 mov si, 516  ; origem (03,18)
     ;mov di, 2000 ; destino (12,40)
     mov cx, 13
	 jmp LE_NOME1

LE_NOME1:
	 mov al, es:[si] ; ler letra
     mov nomeJ1[si], al
     mov ah, es:[si+1] ; atributo
     ;mov es:[di], al ; escrever
     mov byte ptr es:[di+1], 00000010b
     add si, 2
    ; add di, 2
     loop LE_NOME1
	 JMP POSE_NOME1

POSE_NOME1:
	 mov si, 516  ; origem (03,18)
     mov di, 196 ; destino (01,60)
     mov cx, 13
	 ;jmp ESCREVE_NOME1

;ESCREVE_NOME1:
;	 mov al, nomeJ1[si]
 ;    mov es:[di], al
  ;   mov byte ptr es:[di+1], 00000010b
   ;  add si, 2
     ;add di, 2
    ; loop ESCREVE_NOME1

SAIR:
		call 	apaga_ecran
		goto_xy	0,0
		mov     ah,4ch
        int     21h

fim:	
		RET
assinala_Nomes	endp
;########################################################################



;########################################################################
; Avatar

AVATAR	PROC
			mov		ax,0B800h
			mov		es,ax
CICLO:			
			goto_xy	POSx,POSy		; Vai para nova possição
			mov 	ah, 08h
			mov		bh,0			; numero da página
			int		10h		
			mov		Car, al			; Guarda o Caracter que está na posição do Cursor
			mov		Cor, ah			; Guarda a cor que está na posição do Cursor
		
			goto_xy	78,0			; Mostra o caractr que estava na posição do AVATAR
			mov		ah, 02h			; IMPRIME caracter da posição no canto
			mov		dl, Car	
			int		21H			
	
			goto_xy	15,7	; Vai para posição do cursor
		
LER_SETA:	call 	LE_TECLA
			cmp		ah, 1
			je		ESTEND
			CMP 	AL, 27		; ESCAPE
			JE		FIM
			goto_xy	POSx,POSy 	; verifica se pode escrever o caracter no ecran
			mov		CL, Car
			cmp		CL, 32		; Só escreve se for espaço em branco
			JNE 	LER_SETA
			mov		ah, 02h		; coloca o caracter lido no ecra
			mov		dl, al
			int		21H	
			goto_xy	POSx,POSy
			
			
			jmp		LER_SETA
	
		
ESTEND:		cmp 	al,48h
			jne		BAIXO
			dec		POSy		;cima
			cmp 	POSy, 2
			jbe		RETURNUP_l1
			cmp 	POSy, 5
			je		RETURNUP_l2
			cmp 	POSy, 9
			je		RETURNUP_l3
			jmp 	CICLO

RETURNUP_l1: 					;Não sai por cima do tabuleiro
		mov POSy, 2
		jmp CICLO

RETURNUP_l2:			;passa do tabuleiro 2 para o tabuleiro 1
		mov POSy, 4
		jmp CICLO

RETURNUP_l3:
		mov POSy, 8
		jmp CICLO

BAIXO:		cmp		al,50h
			jne		ESQUERDA	
			inc 	POSy		;Baixo
			cmp 	POSy, 5
			je		RETURNDOWN_l1
			cmp 	POSy, 9
			je		RETURNDOWN_l2
			cmp 	POSy, 12
			jae		RETURNDOWN_l3
			jmp		CICLO

RETURNDOWN_l1:
		mov POSy, 6
		jmp CICLO

RETURNDOWN_l2:
		mov POSy, 10
		jmp CICLO

RETURNDOWN_l3:
		mov POSy, 12
		jmp CICLO

ESQUERDA:
			cmp		al,4Bh
			jne		DIREITA
			dec		POSx
			dec		POSx		;Esquerda
			cmp 	POSx, 4
			jbe		RETURNESQ_c1
			cmp 	POSx, 11
			je		RETURNESQ_c2
			cmp 	POSx, 20
			je		RETURNESQ_c3
			cmp 	POSx, 26
			jae		RETURNESQ_c4
			jmp		CICLO


RETURNESQ_c1:
		mov POSx, 4
		jmp		CICLO

RETURNESQ_c2:
		mov POSx, 8
		jmp		CICLO

RETURNESQ_c3:
		mov POSx, 17
		jmp		CICLO

RETURNESQ_c4:
		mov POSx, 26
		jmp		CICLO


DIREITA:
			cmp		al,4Dh
			jne		LER_SETA 
					;Direita
			cmp 	POSx, 8
			je		RETURNDIR_c1
			cmp 	POSx, 17
			je		RETURNDIR_c2
			cmp 	POSx, 26
			jae		RETURNDIR_c3
			inc		POSx
			inc		POSx
			jmp		CICLO

RETURNDIR_c1:
		mov POSx, 13
		jmp CICLO

RETURNDIR_c2:
		mov POSx, 22
		jmp CICLO

RETURNDIR_c3:
		mov POSx, 26
		jmp CICLO

fim:				
			RET
AVATAR		endp



;########################################################################
Main  proc
		mov			ax, dseg
		mov			ds,ax
		
		mov			ax,0B800h
		mov			es,ax
		
		call		apaga_ecran
		goto_xy		0,0
		call 		IMP_MENU
		call		assinala_Menu
		call 		apaga_ecran
		goto_xy		0,0
		call 		IMP_NOMES
		call		assinala_Nomes
		call 		apaga_ecran
		goto_xy		0,0
		call		IMP_FICH
		call 		cor_o
		call 		cor_x
		call 		cor_nome_jogador
		call 		cor_espetador
		call 		AVATAR
		goto_xy		0,22
		
		mov			ah,4CH
		INT			21H
Main	endp
Cseg	ends
end	Main


		

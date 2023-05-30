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

		nplayer 		db	2	; numero do jogador a jogar varia entre 1 e 2
		n_tab			db  5   ; numero do tabuleiro a jogar varia entre 1 e 9
		
		win1			db  1, 1, 1, ?, ?, ?, ?, ?, ? ; arrays com todas as possibilidades de ganhar
		win2			db  ?, ?, ?, 1, 1, 1, ?, ?, ?
		win3			db  ?, ?, ?, ?, ?, ?, 1, 1, 1
		win4			db  ?, ?, 1, ?, 1, ?, 1, ?, ?
		win5			db  1, ?, ?, ?, 1, ?, ?, ?, 1
		win6			db  1, ?, ?, 1, ?, ?, 1, ?, ?
		win7			db  ?, 1, ?, ?, 1, ?, ?, 1, ?
		win8			db  ?, ?, 1, ?, ?, 1, ?, ?, 1


		jtab1			db 9 dup(?)		;guarda as jogadas efetuadas em cada tabuleiro
		jtab2			db 9 dup(?)
		jtab3			db 9 dup(?)
		jtab4			db 9 dup(?)
		jtab5			db 9 dup(?)
		jtab6			db 9 dup(?)
		jtab7			db 9 dup(?)
		jtab8			db 9 dup(?)
		jtab9			db 9 dup(?)

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


jogador_jogar macro nplayer   ;coloca a cor do jogador e do espetador 
		cmp nplayer, 1
		je jx
		cmp nplayer, 2
		je	jy
jx:
	mov 	si, 240 	; origem(01,40)	
	jmp ciclo1
ciclo1:
	mov al,es:[si] ; le caracter
	cmp al, ' '
	je jy_espetador
	mov		byte ptr es:[si+1],7 
	inc si
	inc si
	loop ciclo1

jy_espetador:
	mov 	si, 400 	; origem(02,40)
	jmp ciclo2
ciclo2:
		mov al,es:[si] ; le caracter
		cmp al, ' '
		je fim
		mov		byte ptr es:[si+1],8	 
		inc si
		inc si
		loop ciclo2

jy:
	mov 	si, 400 	; origem(02,40)
	jmp ciclo3
ciclo3:
		mov al,es:[si] ; le caracter
		cmp al, ' '
		je jx_espetador
		mov		byte ptr es:[si+1],7	 
		inc si
		inc si
		loop ciclo3

jx_espetador:
	mov 	si, 240 	; origem(01,40)	
	jmp ciclo4
ciclo4:
	mov al,es:[si] ; le caracter
	cmp al, ' '
	je fim
	mov		byte ptr es:[si+1],8
	inc si
	inc si
	loop ciclo4


fim:
	int 10h
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
		;cmp		ah, 1 	
		;je		ESTEND
		cmp		AL, 13  	; ENTER
		je		ASSINALA
		goto_xy	POSx,POSy
		cmp		POSy, 7
		je 		NO_TECLA
		cmp 	al, 30h
		je		APAGA_CAR 	
		mov		ah, 02h		; coloca o caracter lido no ecra
		mov		dl, al
		int		21H	
		inc 	POSx
		cmp 	POSx, 45
		jae 	MANTER
		goto_xy	POSx,POSy 	; coloca cursor na posicao seguinte
		jmp		LER_SETA

NO_TECLA:					; garante que apenas aceita o enter no botao começar
		cmp		al, 13
		jne		LER_SETA
		je 		fim

MANTER:
		mov POSx, 45
		goto_xy POSx, POSy
		jmp LER_SETA

APAGA_CAR:
		cmp 	POSX, 18
		jnae	LER_SETA	
		goto_xy	POSx,POSy	
		mov 	al, 32
		mov		ah, 02h		; coloca o caracter lido no ecra
		mov		dl, al
		int		21H	
		dec 	POSX
		cmp 	POSX, 17
		je		clear_c
		goto_xy	POSx,POSy  	; coloca cursor na nova posicao apos apagar caracter
		jmp 	LER_SETA

clear_c:					; faz com que o caracter apaga nao vá para alem da posicao 18
		mov POSx, 18
		goto_xy	POSx,POSy
		jmp 	LER_SETA

ASSINALA:
		cmp 	POSy, 3
		je  	NAME2
		cmp 	POSy, 5
		je		START
		cmp 	POSy, 7
		je 		fim
		jmp		CICLO

NAME2:
		mov 	POSy, 5
		mov 	POSx, 18
		goto_xy	POSx, POSy
		jmp 	POS_NOME1
		jmp 	LER_SETA

START:
		mov 	POSy, 7
		mov 	POSx, 28
		goto_xy	POSx, POSy
		jmp 	POS_NOME2
		jmp 	LER_SETA

POS_NOME1:

	 mov ax, 0B800h ; mem.video
     mov es, ax

	 mov si, 516  ; origem (03,18)
     mov di, 0 ; destino (12,40)
     ;mov cx, 13
	 jmp BUSCA_NOME1

BUSCA_NOME1:
	 mov al, es:[si] ; ler letra
	 cmp al, 32
	 jne GUARDA1
	 mov nomeJ1[di+1], '$'
     jmp LER_SETA
     
GUARDA1:
	mov nomeJ1[di], al
     ;mov ah, es:[si+1] ; atributo
     ;mov es:[di], al ; escrever
     ;mov byte ptr es:[si+1], 00000010b
    add si, 2
    add di, 1
	loop BUSCA_NOME1
;POSE_NOME1:
;	 mov di, 0  ; origem (03,18)
 ;    mov si, 1494 ; destino (09,27)
	 ;mov cx, 13
;	 jmp ESCREVE_NOME1

;ESCREVE_NOME1:
;	 mov al, nomeJ1[di]
;	 cmp al, '$'
;	 je LER_SETA
 ;    mov es:[si], al
  ;   mov byte ptr es:[si+1], 00000010b
   ;  add si, 2
    ; add di, 1
     ;loop ESCREVE_NOME1


POS_NOME2:

	 mov ax, 0B800h ; mem.video
     mov es, ax

	 mov si, 836  ; origem (03,18)
     mov di, 0 ; destino (12,40)
     ;mov cx, 13
	 jmp BUSCA_NOME2

BUSCA_NOME2:
	 mov al, es:[si] ; ler letra
	 cmp al, 32
	 jne GUARDA2
	 mov nomeJ2[di+1], '$'
     jmp LER_SETA
     
GUARDA2:
	mov nomeJ2[di], al
     ;mov ah, es:[si+1] ; atributo
     ;mov es:[di], al ; escrever
     ;mov byte ptr es:[si+1], 00000010b
    add si, 2
    add di, 1
	loop BUSCA_NOME2
;POSE_NOME2:
;	 mov di, 0  ; origem (03,18)
 ;    mov si, 1654 ; destino (09,27)
	 ;mov cx, 13
;	 jmp ESCREVE_NOME2

;ESCREVE_NOME2:
;	 mov al, nomeJ2[di]
;	 cmp al, '$'
;	 je LER_SETA
 ;    mov es:[si], al
  ;   mov byte ptr es:[si+1], 00000010b
   ;  add si, 2
    ; add di, 1
     ;loop ESCREVE_NOME2

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
			mov 	POSy, 7
			mov 	POSx, 15
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
	
			goto_xy	POSx,POSy	; Vai para posição do cursor

			
			jmp POSE_NOME1

POSE_NOME1:
	 mov di, 0  ; contador
	 mov si, 240 ; destino (01,40)
	 ;mov cx, 13
	 jmp ESCREVE_NOME1

ESCREVE_NOME1:
	 mov al, nomeJ1[di]
	 cmp al, '$'
	 je POSE_NOME2
     mov es:[si], al
    ; mov byte ptr es:[si+1], 00000010b
     add si, 2
     add di, 1
     loop ESCREVE_NOME1

POSE_NOME2:
	 mov di, 0  ; contador
	 mov si, 400 ; destino (02,40)
	 ;mov cx, 13
	 jmp ESCREVE_NOME2

ESCREVE_NOME2:
	 mov al, nomeJ2[di]
	 cmp al, '$'
	 je LER_SETA
     mov es:[si], al
     mov byte ptr es:[si+1], 00000010b
     add si, 2
     add di, 1
     loop ESCREVE_NOME2
		
LER_SETA:	
			jogador_jogar nplayer ; coloca sempre o nome dos jogadores com cor atualizada
			call 	LE_TECLA
			cmp		ah, 1
			je		ESTEND
			CMP 	AL, 27		; ESCAPE
			JE		fima
			cmp 	al, 13      ; ENTER
			je 		ASSINALA_JOGADA
			;goto_xy	POSx,POSy 	; verifica se pode escrever o caracter no ecran
			;mov		CL, Car
			;cmp		CL, 32		; Só escreve se for espaço em branco
			;JNE 	LER_SETA
			;mov		ah, 02h		; coloca o caracter lido no ecra
			;mov		dl, al
			;int		21H	
			goto_xy	POSx,POSy
			
			jmp		LER_SETA
	
ASSINALA_JOGADA:
		goto_xy	POSx,POSy 	; verifica se pode escrever o caracter no ecran
		mov		CL, Car
		cmp		CL, 32		; Só escreve se for espaço em branco
		JNE 	LER_SETA
		cmp 	nplayer, 1
		je		JOGA_X
		cmp 	nplayer, 2
		je		JOGA_O
JOGA_X:
	 	mov 	al, 'X'
		mov 	ah, 02h
		mov 	dl, al
		int 	21h
		call 	cor_x
	 	mov 	nplayer, 2
		cmp 	POSy, 2    ; verifica em que linha jogou para alterar o tabuleiro 
		je		vePosx1
		cmp 	POSy, 3
		je		vePosx2
		cmp 	POSy, 4
		je		vePosx3
		cmp 	POSy, 6	   
		je		vePosx1
		cmp 	POSy, 7
		je		vePosx2
		cmp 	POSy, 8
		je		vePosx3
		cmp 	POSy, 10  
		je		vePosx1
		cmp 	POSy, 11
		je		vePosx2
		cmp 	POSy, 12
		je		vePosx3
		jmp 	LER_SETA

JOGA_O:
		mov 	al, 'O'
		mov 	ah, 02h
		mov 	dl, al
		int 	21h
		call 	cor_o
		mov 	nplayer, 1
		cmp 	POSy, 2    ; verifica em que linha jogou para alterar o tabuleiro 
		je		vePosx1
		cmp 	POSy, 3
		je		vePosx2
		cmp 	POSy, 4
		je		vePosx3
		cmp 	POSy, 6	   
		je		vePosx1
		cmp 	POSy, 7
		je		vePosx2
		cmp 	POSy, 8
		je		vePosx3
		cmp 	POSy, 10  
		je		vePosx1
		cmp 	POSy, 11
		je		vePosx2
		cmp 	POSy, 12
		je		vePosx3
		jmp 	LER_SETA

vePosx1:
		cmp posx, 4
		je	mudaTab1
		cmp posx, 6
		je  mudaTab2
		cmp posx, 8
		je  mudaTab3
		cmp	posx, 13
		je	mudaTab1
		cmp posx, 15
		je  mudaTab2
		cmp posx, 17
		je  mudaTab3
		cmp	posx, 22
		je	mudaTab1
		cmp posx, 24
		je  mudaTab2
		cmp posx, 26
		je  mudaTab3
		jmp LER_SETA

vePosx2:	
		cmp posx, 4
		je	mudaTab4
		cmp posx, 6
		je  mudaTab5
		cmp posx, 8
		je  mudaTab6
		cmp	posx, 13
		je	mudaTab4
		cmp posx, 15
		je  mudaTab5
		cmp posx, 17
		je  mudaTab6
		cmp	posx, 22
		je	mudaTab4
		cmp posx, 24
		je  mudaTab5
		cmp posx, 26
		je  mudaTab6
		jmp LER_SETA

vePosx3:	
		cmp posx, 4
		je	mudaTab7
		cmp posx, 6
		je  mudaTab8
		cmp posx, 8
		je  mudaTab9
		cmp	posx, 13
		je	mudaTab7
		cmp posx, 15
		je  mudaTab8
		cmp posx, 17
		je  mudaTab9
		cmp	posx, 22
		je	mudaTab7
		cmp posx, 24
		je  mudaTab8
		cmp posx, 26
		je  mudaTab9
		jmp LER_SETA

mudaTab1:
		mov n_tab, 1
		mov posX, 4
		mov posy, 2
		goto_xy posX, posy
		jmp LER_SETA

mudaTab2:
		mov n_tab, 2
		mov posX, 13
		mov posy, 2
		goto_xy posX, posy
		jmp LER_SETA

mudaTab3:
		mov n_tab, 3
		mov posX, 22
		mov posy, 2
		goto_xy posX, posy
		jmp LER_SETA

mudaTab4:
		mov n_tab, 4
		mov posX, 4
		mov posy, 6
		goto_xy posX, posy
		jmp LER_SETA

mudaTab5:
		mov n_tab, 5
		mov posX, 13
		mov posy, 6
		goto_xy posX, posy
		jmp LER_SETA

mudaTab6:
		mov n_tab, 6
		mov posX, 22
		mov posy, 6
		goto_xy posX, posy
		jmp LER_SETA

mudaTab7:
		mov n_tab, 7
		mov posX, 4
		mov posy, 10
		goto_xy posX, posy
		jmp LER_SETA

mudaTab8:
		mov n_tab, 8
		mov posX, 13
		mov posy, 10
		goto_xy posX, posy
		jmp LER_SETA

mudaTab9:
		mov n_tab, 9
		mov posX, 22
		mov posy, 10
		goto_xy posX, posy
		jmp LER_SETA

ESTEND:		cmp 	al,48h
			jne		BAIXO
			dec		POSy		;cima
			cmp 	n_tab, 1
			je		configCima_tl1
			cmp 	n_tab, 2
			je		configCima_tl1
			cmp 	n_tab, 3
			je		configCima_tl1
			cmp 	n_tab, 4
			je		configCima_tl2
			cmp 	n_tab, 5
			je		configCima_tl2
			cmp 	n_tab, 6
			je		configCima_tl2
			cmp 	n_tab, 7
			je		configCima_tl3
			cmp 	n_tab, 8
			je		configCima_tl3
			cmp 	n_tab, 9
			je		configCima_tl3
			jmp 	CICLO

configCima_tl1:			;Não sai por cima do tabuleiro 
		cmp POSy, 2
		jnbe CICLO
		mov POSy, 2
		jmp CICLO

configCima_tl2:			;Não sai por cima do tabuleiro
		cmp POSy, 6
		jnbe CICLO 
		mov POSy, 6
		jmp CICLO		

configCima_tl3:			;Não sai por cima do tabuleiro 
		cmp POSy, 10
		jnbe CICLO
		mov POSy, 10
		jmp CICLO				

BAIXO:		cmp		al,50h
			jne		ESQUERDA	
			inc 	POSy		;Baixo
			cmp 	n_tab, 1
			je		configBaixo_tl1
			cmp 	n_tab, 2
			je		configBaixo_tl1
			cmp 	n_tab, 3
			je		configBaixo_tl1
			cmp 	n_tab, 4
			je		configBaixo_tl2
			cmp 	n_tab, 5
			je		configBaixo_tl2
			cmp 	n_tab, 6
			je		configBaixo_tl2
			cmp 	n_tab, 7
			je		configBaixo_tl3
			cmp 	n_tab, 8
			je		configBaixo_tl3
			cmp 	n_tab, 9
			je		configBaixo_tl3
			jmp		CICLO


configBaixo_tl1:			;Não sai por baixo do tabuleiro 
		cmp Posy, 4
		jnae CICLO
		mov POSy, 4
		jmp CICLO

configBaixo_tl2:			;Não sai por baixo do tabuleiro 
		cmp Posy, 8
		jnae CICLO
		mov POSy, 8		
		jmp CICLO

configBaixo_tl3:			;Não sai por baixo do tabuleiro 
		cmp Posy, 12
		jnae CICLO
		mov POSy, 12
		jmp CICLO


ESQUERDA:
			cmp		al,4Bh
			jne		DIREITA
			dec		POSx
			dec		POSx		;Esquerda
			cmp 	n_tab, 1
			je		configEsq_tc1
			cmp 	n_tab, 2
			je		configEsq_tc2
			cmp 	n_tab, 3
			je		configEsq_tc3
			cmp 	n_tab, 4
			je		configEsq_tc1
			cmp 	n_tab, 5
			je		configEsq_tc2
			cmp 	n_tab, 6
			je		configEsq_tc3
			cmp 	n_tab, 7
			je		configEsq_tc1
			cmp 	n_tab, 8
			je		configEsq_tc2
			cmp 	n_tab, 9
			je		configEsq_tc3						
			;cmp 	POSx, 4			;NAO DEIXA PASSAR AS MARGENS DO TABULEIRO GRANDE
			;jbe		RETURNESQ_c1
			;cmp 	POSx, 11
			;je		RETURNESQ_c2
			;cmp 	POSx, 20
			;je		RETURNESQ_c3
			;cmp 	POSx, 26
			;jae		RETURNESQ_c4
			;jmp		CICLO


configEsq_tc1:					;Não sai pela esquerda do tabuleiro 
		cmp Posx, 4
		jnbe CICLO
		mov POSx, 4
		jmp CICLO

configEsq_tc2:			;Não sai por esquerda do tabuleiro 
		cmp POSx, 13
		jnbe CICLO
		mov POSx, 13		
		jmp CICLO

configEsq_tc3:			;Não sai por esquerda do tabuleiro 
		cmp POSx, 22
		jnbe CICLO
		mov POSx, 22
		jmp CICLO


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
			inc		POSx		;Direita
			inc		POSx
			cmp 	n_tab, 1
			je		configDir_tc1
			cmp 	n_tab, 2
			je		configDir_tc2
			cmp 	n_tab, 3
			je		configDir_tc3
			cmp 	n_tab, 4
			je		configDir_tc1
			cmp 	n_tab, 5
			je		configDir_tc2
			cmp 	n_tab, 6
			je		configDir_tc3
			cmp 	n_tab, 7
			je		configDir_tc1
			cmp 	n_tab, 8
			je		configDir_tc2
			cmp 	n_tab, 9
			je		configDir_tc3	
			jmp		CICLO


configDir_tc1:					;Não sai pela esquerda do tabuleiro 
		cmp Posx, 8
		jnae CICLO
		mov POSx, 8
		jmp CICLO

configDir_tc2:			;Não sai por esquerda do tabuleiro 
		cmp POSx, 17
		jnae CICLO
		mov POSx, 17		
		jmp CICLO

configDir_tc3:			;Não sai por esquerda do tabuleiro 
		cmp POSx, 26
		jnae CICLO
		mov POSx, 26
		jmp CICLO

fima:				
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
		jogador_jogar nplayer
		call 		AVATAR
		goto_xy		0,22
		
		mov			ah,4CH
		INT			21H
Main	endp
Cseg	ends
end	Main


		

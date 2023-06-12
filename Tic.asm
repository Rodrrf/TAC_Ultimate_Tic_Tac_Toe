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

		pos_ecra 		word	0 	;indice de mem. video 
		lin				db 		?	;linha monitor
		col 			db 		?	;coluna monitor

		nomeJ1			db 		? ; Guarda o nome do jogador 1
		nomeJ2			db		? ; Guarda o nome do jogador 2

		writeNome		db	0	; Varia entre 0 e 1, 1 se já escreveu o nome dos jogadores

		nplayer 		db	2	; numero do jogador a jogar varia entre 1 e 2
		n_tab			db  5   ; numero do tabuleiro a jogar varia entre 1 e 9

		bt1 			db	0	; 0 se tabuleiro 1 nao estiver bloqueado 1 se estiver bloqueado 2 para passar para outro tab
		bt2 			db	0	; 0 se tabuleiro 2 nao estiver bloqueado 1 se estiver bloqueado
		bt3 			db	0	; 0 se tabuleiro 3 nao estiver bloqueado 1 se estiver bloqueado
		bt4 			db	0	; 0 se tabuleiro 3 nao estiver bloqueado 1 se estiver bloqueado
		bt5 			db	0	; 0 se tabuleiro 3 nao estiver bloqueado 1 se estiver bloqueado
		bt6 			db	0	; 0 se tabuleiro 3 nao estiver bloqueado 1 se estiver bloqueado
		bt7 			db	0	; 0 se tabuleiro 3 nao estiver bloqueado 1 se estiver bloqueado
		bt8 			db	0	; 0 se tabuleiro 3 nao estiver bloqueado 1 se estiver bloqueado
		bt9 			db	0	; 0 se tabuleiro 3 nao estiver bloqueado 1 se estiver bloqueado
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


;########################################################################
posicao_ecra proc

     pushf
     push ax
     push dx
     push si 

     mov al, lin
     mov dl, 160
     mul dl         ;AX  = al * (dl)   8bits
     mov si, ax
     mov al, col
     mov dl, 2
     mul dl
     add si, ax
	 mov pos_ecra, si

     pop si
     pop dx 
     pop ax 
     popf

     ret
posicao_ecra endp

;########################################################################
mudaCorTab1 proc ; muda a cor de fundo do tabuleiro 1 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corV
	cmp nplayer, 2
	je corA 
corV:
	 mov lin, 2
     mov col, 3
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_ext
ciclo_ext:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclod:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclod

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_ext 
	jmp fim_muda

corA:
	 mov lin, 2
     mov col, 3
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extA
ciclo_extA:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodA:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodA

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extA 
	jmp fim_muda


fim_muda:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab1 endp
;########################################################################

;########################################################################
mudaCorTab2 proc ; muda a cor de fundo do tabuleiro 2 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corV2
	cmp nplayer, 2
	je corA2 
corV2:
	 mov lin, 2
     mov col, 12
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_ext2
ciclo_ext2:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclod2:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclod2

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_ext2 
	jmp fim_muda2

corA2:
	 mov lin, 2
     mov col, 12
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extA2
ciclo_extA2:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodA2:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodA2

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extA2
	jmp fim_muda2


fim_muda2:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab2 endp
;########################################################################

mudaCorTab3 proc ; muda a cor de fundo do tabuleiro 3 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corVt3
	cmp nplayer, 2
	je corAt3
corVt3:
	 mov lin, 2
     mov col, 21
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extt3
ciclo_extt3:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodt3:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclodt3

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extt3 
	jmp fim_mudat3

corAt3:
	 mov lin, 2
     mov col, 21
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extAt3
ciclo_extAt3:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodAt3:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodAt3

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extAt3
	jmp fim_mudat3


fim_mudat3:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab3 endp
;########################################################################

mudaCorTab4 proc ; muda a cor de fundo do tabuleiro 3 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corV
	cmp nplayer, 2
	je corA
corV:
	 mov lin, 6
     mov col, 3
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_ext
ciclo_ext:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclod:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclod

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_ext
	jmp fim_muda

corA:
	 mov lin, 6
     mov col, 3
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extA
ciclo_extA:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodA:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodA

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extA
	jmp fim_muda


fim_muda:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab4 endp
;########################################################################

;########################################################################

mudaCorTab5 proc ; muda a cor de fundo do tabuleiro 3 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corV
	cmp nplayer, 2
	je corA
corV:
	 mov lin, 6
     mov col, 12
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_ext
ciclo_ext:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclod:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclod

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_ext
	jmp fim_muda

corA:
	 mov lin, 6
     mov col, 12
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extA
ciclo_extA:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodA:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodA

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extA
	jmp fim_muda


fim_muda:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab5 endp
;########################################################################

;########################################################################

mudaCorTab6 proc ; muda a cor de fundo do tabuleiro 3 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corV
	cmp nplayer, 2
	je corA
corV:
	 mov lin, 6
     mov col, 21
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_ext
ciclo_ext:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclod:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclod

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_ext
	jmp fim_muda

corA:
	 mov lin, 6
     mov col, 21
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extA
ciclo_extA:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodA:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodA

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extA
	jmp fim_muda


fim_muda:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab6 endp
;########################################################################

;########################################################################

mudaCorTab7 proc ; muda a cor de fundo do tabuleiro 3 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corV
	cmp nplayer, 2
	je corA
corV:
	 mov lin, 10
     mov col, 3
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_ext
ciclo_ext:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclod:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclod

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_ext
	jmp fim_muda

corA:
	 mov lin, 10
     mov col, 3
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extA
ciclo_extA:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodA:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodA

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extA
	jmp fim_muda


fim_muda:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab7 endp
;########################################################################

;########################################################################

mudaCorTab8 proc ; muda a cor de fundo do tabuleiro 3 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corV
	cmp nplayer, 2
	je corA
corV:
	 mov lin, 10
     mov col, 12
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_ext
ciclo_ext:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclod:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclod

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_ext
	jmp fim_muda

corA:
	 mov lin, 10
     mov col, 12
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extA
ciclo_extA:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodA:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodA

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extA
	jmp fim_muda


fim_muda:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab8 endp
;########################################################################

;########################################################################

mudaCorTab9 proc ; muda a cor de fundo do tabuleiro 3 
	
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp nplayer, 1
	je corV
	cmp nplayer, 2
	je corA
corV:
	 mov lin, 10
     mov col, 21
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_ext
ciclo_ext:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclod:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 01001111b
        add si, 2
        add di, 2
        loop ciclod

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_ext
	jmp fim_muda

corA:
	 mov lin, 10
     mov col, 21
     call posicao_ecra
     mov si, pos_ecra
	 mov di, pos_ecra
     mov cx, 3
	 jmp ciclo_extA
ciclo_extA:
        push cx ;guarda
        push si 
        push di 
        mov cx, 7
ciclodA:
        mov al, es:[si]
        mov es:[di], al
        mov byte ptr es:[di+1], 00011111b
        add si, 2
        add di, 2
        loop ciclodA

        pop di  ;recupera
        pop si 
        pop cx 

        add si, 160 ; mudar de linha
        add di, 160
        loop ciclo_extA
	jmp fim_muda


fim_muda:
	pop si 	;recupera
    pop dx 
    pop ax 
    popf

    ret
mudaCorTab9 endp
;########################################################################

preencheTabUltimate proc 

	push cx ;guarda
    push si 
    push di 

	cmp bt1, 1
	je	vJ1
	cmp bt2, 1
	je 	vJ2
	cmp bt3, 1
	je 	vJ3
	cmp bt4, 1
	je 	vJ4
	cmp bt5, 1
	je 	vJ5
	cmp bt6, 1
	je 	vJ6
	cmp bt7, 1
	je 	vJ7
	cmp bt8, 1
	je 	vJ8
	cmp bt9, 1
	je 	vJ9
vJ1:
	mov bt1, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP1v
	cmp nplayer, 2
	je preencheP1A
preencheP1v:
	mov al, 0
	mov al, 6
	mov lin, al 
	mov al, 0
	mov al, 43
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP1A:
	mov al, 0
	mov al, 6
	mov lin, al 
	mov al, 0
	mov al, 43
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

vJ2:
	mov bt2, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP2v
	cmp nplayer, 2
	je preencheP2A
preencheP2v:
	mov al, 0
	mov al, 6
	mov lin, al 
	mov al, 0
	mov al, 45
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP2A:
	mov al, 0
	mov al, 6
	mov lin, al 
	mov al, 0
	mov al, 45
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

vJ3:
	mov bt3, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP1vt3
	cmp nplayer, 2
	je preencheP1At3
preencheP1vt3:
	mov al, 0
	mov al, 6
	mov lin, al 
	mov al, 0
	mov al, 47
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP1At3:
	mov al, 0
	mov al, 6
	mov lin, al 
	mov al, 0
	mov al, 47
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

vJ4:
	mov bt4, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP4v
	cmp nplayer, 2
	je preencheP4A
preencheP4v:
	mov al, 0
	mov al, 7
	mov lin, al 
	mov al, 0
	mov al, 43
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP4A:
	mov al, 0
	mov al, 7
	mov lin, al 
	mov al, 0
	mov al, 43
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

vJ5:
	mov bt5, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP5v
	cmp nplayer, 2
	je preencheP5A
preencheP5v:
	mov al, 0
	mov al, 7
	mov lin, al 
	mov al, 0
	mov al, 45
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP5A:
	mov al, 0
	mov al, 7
	mov lin, al 
	mov al, 0
	mov al, 45
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

vJ6:
	mov bt6, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP6v
	cmp nplayer, 2
	je preencheP6A
preencheP6v:
	mov al, 0
	mov al, 7
	mov lin, al 
	mov al, 0
	mov al, 47
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP6A:
	mov al, 0
	mov al, 7
	mov lin, al 
	mov al, 0
	mov al, 47
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

vJ7:
	mov bt7, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP7v
	cmp nplayer, 2
	je preencheP7A
preencheP7v:
	mov al, 0
	mov al, 8
	mov lin, al 
	mov al, 0
	mov al, 43
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP7A:
	mov al, 0
	mov al, 8
	mov lin, al 
	mov al, 0
	mov al, 43
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

vJ8:
	mov bt8, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP8v
	cmp nplayer, 2
	je preencheP8A
preencheP8v:
	mov al, 0
	mov al, 8
	mov lin, al 
	mov al, 0
	mov al, 45
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP8A:
	mov al, 0
	mov al, 8
	mov lin, al 
	mov al, 0
	mov al, 45
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

vJ9:
	mov bt9, 2
	mov col, 0 
	mov lin, 0
	cmp nplayer, 1
	je preencheP9v
	cmp nplayer, 2
	je preencheP9A
preencheP9v:
	mov al, 0
	mov al, 8
	mov lin, al 
	mov al, 0
	mov al, 47
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'X' 	;escreve caracter X no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 4
	jmp fimPreenche

preencheP9A:
	mov al, 0
	mov al, 8
	mov lin, al 
	mov al, 0
	mov al, 47
	mov col, al 
	call posicao_ecra
	mov si, pos_ecra
	mov al, 0
	mov al, 'O' 	;escreve caracter O no tabuleiro ultimate
    mov es:[si], al
    mov byte ptr es:[si+1], 3
	jmp fimPreenche

fimPreenche:
	pop di  ;recupera
    pop si 
    pop cx 
	
	ret
preencheTabUltimate endp

;########################################################################

verTab1_X proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 2
	je y2_vPx 	;verifica a coluna
	cmp POSy, 3
	je y3_vPx 
	cmp POSy, 4
	je y4_vPx

y2_vPx:
	cmp POSx, 4
	je	t1p1   ; tabuleiro 1 posicao 1
	cmp POSx, 6
	je 	t1p2
	cmp POSx, 8
	je 	t1p3
y3_vPx:
	cmp POSx, 4
	je	t1p4    ; tabuleiro 1 posicao 4
	cmp POSx, 6
	je 	t1p5
	cmp POSx, 8
	je 	t1p6
y4_vPx:
	cmp POSx, 4
	je	t1p7	; tabuleiro 1 posicao 7
	cmp POSx, 6
	je 	t1p8
	cmp POSx, 8
	je 	t1p9

t1p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1

     
t1p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1


t1p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1
t1p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1
t1p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1

t1p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2
t1p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2
t1p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1
t1p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3

verProxLin1:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1
verProxCol1:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1
verProxDiag1:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1
verAntLin1:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1
verAntLin2:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1
verAntCol1:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1
verAntCol2:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1
verAntDiag1:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1
verAntDiag2:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1

verAntDiagP5:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1

verAntDiagP1:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1

verAntDiag3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT1
	mov bt1, 1
	jmp fim_verT1


fim_verT1:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab1_X endp
;########################################################################

verTab1_O proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 2
	je y2_vPo 	;verifica a coluna
	cmp POSy, 3
	je y3_vPo 
	cmp POSy, 4
	je y4_vPo

y2_vPo:
	cmp POSx, 4
	je	t1p1o   ; tabuleiro 1 posicao 1
	cmp POSx, 6
	je 	t1p2o
	cmp POSx, 8
	je 	t1p3o
y3_vPo:
	cmp POSx, 4
	je	t1p4o    ; tabuleiro 1 posicao 4
	cmp POSx, 6
	je 	t1p5o
	cmp POSx, 8
	je 	t1p6o
y4_vPo:
	cmp POSx, 4
	je	t1p7o	; tabuleiro 1 posicao 7
	cmp POSx, 6
	je 	t1p8o
	cmp POSx, 8
	je 	t1p9o

t1p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t1p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t1p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t1p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t1p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t1p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t1p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t1p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t1p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt1, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab1_O endp
;########################################################################

verTab2_O proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 2
	je y2_vPo 	;verifica a coluna
	cmp POSy, 3
	je y3_vPo 
	cmp POSy, 4
	je y4_vPo

y2_vPo:
	cmp POSx, 13
	je	t3p1o   ; tabuleiro 2 posicao 1
	cmp POSx, 15
	je 	t3p2o
	cmp POSx, 17
	je 	t3p3o
y3_vPo:
	cmp POSx, 13
	je	t3p4o    ; tabuleiro 2 posicao 4
	cmp POSx, 15
	je 	t3p5o
	cmp POSx, 17
	je 	t3p6o
y4_vPo:
	cmp POSx, 13
	je	t3p7o	; tabuleiro 2 posicao 7
	cmp POSx, 15
	je 	t3p8o
	cmp POSx, 27
	je 	t3p9o

t3p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t3p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t3p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t3p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t3p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t3p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t3p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t3p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t3p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt2, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab2_O endp

;#######################################################################################

verTab2_X proc   ;verifica vencedor no tabuleiro 2 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 2
	je y2_vPxt3 	;verifica a coluna
	cmp POSy, 3
	je y3_vPxt3
	cmp POSy, 4
	je y4_vPxt3

y2_vPxt3:
	cmp POSx, 13
	je	t3p1   ; tabuleiro 3 posicao 1
	cmp POSx, 15
	je 	t3p2
	cmp POSx, 17
	je 	t3p3
y3_vPxt3:
	cmp POSx, 13
	je	t3p4    ; tabuleiro 3 posicao 4
	cmp POSx, 15
	je 	t3p5
	cmp POSx, 17
	je 	t3p6
y4_vPxt3:
	cmp POSx, 13
	je	t3p7	; tabuleiro 3 posicao 7
	cmp POSx, 15
	je 	t3p8
	cmp POSx, 17
	je 	t3p9

t3p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1t3

     
t3p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3


t3p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1t3
t3p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
t3p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1t3

t3p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
t3p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2t3
t3p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3
t3p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3t3

verProxLin1t3:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3
verProxCol1t3:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3
verProxDiag1t3:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3
verAntLin1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3
verAntLin2t3:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verAntCol1t3:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3
verAntCol2t3:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3
verAntDiag1t3:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3
verAntDiag2t3:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3

verAntDiagP5t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3

verAntDiagP1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3

verAntDiag3t3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt2, 1
	jmp fim_verT3


fim_verT3:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab2_X endp
;########################################################################
;########################################################################

verTab3_X proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 2
	je y2_vPxt3 	;verifica a coluna
	cmp POSy, 3
	je y3_vPxt3
	cmp POSy, 4
	je y4_vPxt3

y2_vPxt3:
	cmp POSx, 22
	je	t3p1   ; tabuleiro 3 posicao 1
	cmp POSx, 24
	je 	t3p2
	cmp POSx, 26
	je 	t3p3
y3_vPxt3:
	cmp POSx, 22
	je	t3p4    ; tabuleiro 3 posicao 4
	cmp POSx, 24
	je 	t3p5
	cmp POSx, 26
	je 	t3p6
y4_vPxt3:
	cmp POSx, 22
	je	t3p7	; tabuleiro 3 posicao 7
	cmp POSx, 24
	je 	t3p8
	cmp POSx, 26
	je 	t3p9

t3p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1t3

     
t3p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3


t3p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1t3
t3p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
t3p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1t3

t3p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
t3p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2t3
t3p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3
t3p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3t3

verProxLin1t3:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verProxCol1t3:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verProxDiag1t3:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verAntLin1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verAntLin2t3:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verAntCol1t3:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verAntCol2t3:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verAntDiag1t3:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3
verAntDiag2t3:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3

verAntDiagP5t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3

verAntDiagP1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3

verAntDiag3t3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt3, 1
	jmp fim_verT3


fim_verT3:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab3_X endp
;########################################################################

;########################################################################

verTab3_O proc   ;verifica vencedor no tabuleiro 3 car =
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 2
	je y2_vPo 	;verifica a coluna
	cmp POSy, 3
	je y3_vPo 
	cmp POSy, 4
	je y4_vPo

y2_vPo:
	cmp POSx, 22
	je	t3p1o   ; tabuleiro 3 posicao 1
	cmp POSx, 24
	je 	t3p2o
	cmp POSx, 26
	je 	t3p3o
y3_vPo:
	cmp POSx, 22
	je	t3p4o    ; tabuleiro 3 posicao 4
	cmp POSx, 24
	je 	t3p5o
	cmp POSx, 26
	je 	t3p6o
y4_vPo:
	cmp POSx, 22
	je	t3p7o	; tabuleiro 3 posicao 7
	cmp POSx, 24
	je 	t3p8o
	cmp POSx, 26
	je 	t3p9o

t3p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t3p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t3p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t3p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t3p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t3p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t3p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t3p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t3p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt3, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab3_O endp
;########################################################################

;########################################################################

verTab4_X proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 6
	je y2_vPx   	;verifica a coluna
	cmp POSy, 7
	je y3_vPx
	cmp POSy, 8
	je y4_vPx

y2_vPx:
	cmp POSx, 4
	je	t3p1   ; tabuleiro 4 posicao 1
	cmp POSx, 6
	je 	t3p2
	cmp POSx, 8
	je 	t3p3
y3_vPx:
	cmp POSx, 4
	je	t3p4    ; tabuleiro 4 posicao 4
	cmp POSx, 6
	je 	t3p5
	cmp POSx, 8
	je 	t3p6
y4_vPx:
	cmp POSx, 4
	je	t3p7	; tabuleiro 4 posicao 7
	cmp POSx, 6
	je 	t3p8
	cmp POSx, 8
	je 	t3p9

t3p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1t3

     
t3p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3


t3p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1t3
t3p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
t3p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1t3

t3p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
t3p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2t3
t3p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3
t3p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3t3

verProxLin1t3:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3
verProxCol1t3:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3
verProxDiag1t3:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3
verAntLin1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3
verAntLin2t3:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3
verAntCol1t3:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3
verAntCol2t3:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3
verAntDiag1t3:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3
verAntDiag2t3:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3

verAntDiagP5t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3

verAntDiagP1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3

verAntDiag3t3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt4, 1
	jmp fim_verT3


fim_verT3:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab4_X endp
;########################################################################

;########################################################################

verTab4_O proc   ;verifica vencedor no tabuleiro 3 car =
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 6
	je y2_vPo 	;verifica a coluna
	cmp POSy, 7
	je y3_vPo 
	cmp POSy, 8
	je y4_vPo

y2_vPo:
	cmp POSx, 4
	je	t3p1o   ; tabuleiro 3 posicao 1
	cmp POSx, 6
	je 	t3p2o
	cmp POSx, 8
	je 	t3p3o
y3_vPo:
	cmp POSx, 4
	je	t3p4o    ; tabuleiro 3 posicao 4
	cmp POSx, 6
	je 	t3p5o
	cmp POSx, 8
	je 	t3p6o
y4_vPo:
	cmp POSx, 4
	je	t3p7o	; tabuleiro 3 posicao 7
	cmp POSx, 6
	je 	t3p8o
	cmp POSx, 8
	je 	t3p9o

t3p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t3p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t3p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t3p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t3p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t3p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t3p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t3p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t3p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt4, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab4_O endp
;########################################################################

;########################################################################

verTab5_X proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 6
	je y2_vPx   	;verifica a coluna
	cmp POSy, 7
	je y3_vPx
	cmp POSy, 8
	je y4_vPx

y2_vPx:
	cmp POSx, 13
	je	t3p1   ; tabuleiro 4 posicao 1
	cmp POSx, 15
	je 	t3p2
	cmp POSx, 17
	je 	t3p3
y3_vPx:
	cmp POSx, 13
	je	t3p4    ; tabuleiro 4 posicao 4
	cmp POSx, 16
	je 	t3p5
	cmp POSx, 17
	je 	t3p6
y4_vPx:
	cmp POSx, 13
	je	t3p7	; tabuleiro 4 posicao 7
	cmp POSx, 15
	je 	t3p8
	cmp POSx, 17
	je 	t3p9

t3p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1t3

     
t3p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3


t3p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1t3
t3p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
t3p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1t3

t3p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
t3p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2t3
t3p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3
t3p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3t3

verProxLin1t3:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3
verProxCol1t3:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3
verProxDiag1t3:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3
verAntLin1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3
verAntLin2t3:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3
verAntCol1t3:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3
verAntCol2t3:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3
verAntDiag1t3:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3
verAntDiag2t3:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3

verAntDiagP5t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3

verAntDiagP1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3

verAntDiag3t3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt5, 1
	jmp fim_verT3


fim_verT3:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab5_X endp
;########################################################################

;########################################################################

verTab5_O proc   ;verifica vencedor no tabuleiro 3 car =
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 6
	je y2_vPo 	;verifica a coluna
	cmp POSy, 7
	je y3_vPo 
	cmp POSy, 8
	je y4_vPo

y2_vPo:
	cmp POSx, 13
	je	t3p1o   ; tabuleiro 3 posicao 1
	cmp POSx, 15
	je 	t3p2o
	cmp POSx, 17
	je 	t3p3o
y3_vPo:
	cmp POSx, 13
	je	t3p4o    ; tabuleiro 3 posicao 4
	cmp POSx, 15
	je 	t3p5o
	cmp POSx, 17
	je 	t3p6o
y4_vPo:
	cmp POSx, 13
	je	t3p7o	; tabuleiro 3 posicao 7
	cmp POSx, 15
	je 	t3p8o
	cmp POSx, 17
	je 	t3p9o

t3p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t3p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t3p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t3p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t3p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t3p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t3p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t3p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t3p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt5, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab5_O endp
;########################################################################

;########################################################################

verTab6_X proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 6
	je y2_vPx   	;verifica a coluna
	cmp POSy, 7
	je y3_vPx
	cmp POSy, 8
	je y4_vPx

y2_vPx:
	cmp POSx, 22
	je	t3p1   ; tabuleiro 4 posicao 1
	cmp POSx, 24
	je 	t3p2
	cmp POSx, 26
	je 	t3p3
y3_vPx:
	cmp POSx, 22
	je	t3p4    ; tabuleiro 4 posicao 4
	cmp POSx, 24
	je 	t3p5
	cmp POSx, 26
	je 	t3p6
y4_vPx:
	cmp POSx, 22
	je	t3p7	; tabuleiro 4 posicao 7
	cmp POSx, 24
	je 	t3p8
	cmp POSx, 26
	je 	t3p9

t3p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1t3

     
t3p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3


t3p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1t3
t3p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
t3p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1t3

t3p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
t3p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2t3
t3p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3
t3p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3t3

verProxLin1t3:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3
verProxCol1t3:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3
verProxDiag1t3:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3
verAntLin1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3
verAntLin2t3:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3
verAntCol1t3:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3
verAntCol2t3:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3
verAntDiag1t3:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3
verAntDiag2t3:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3

verAntDiagP5t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3

verAntDiagP1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3

verAntDiag3t3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt6, 1
	jmp fim_verT3


fim_verT3:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab6_X endp
;########################################################################
;########################################################################

verTab6_O proc   ;verifica vencedor no tabuleiro 3 car =
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 6
	je y2_vPo 	;verifica a coluna
	cmp POSy, 7
	je y3_vPo 
	cmp POSy, 8
	je y4_vPo

y2_vPo:
	cmp POSx, 22
	je	t3p1o   ; tabuleiro 3 posicao 1
	cmp POSx, 24
	je 	t3p2o
	cmp POSx, 26
	je 	t3p3o
y3_vPo:
	cmp POSx, 22
	je	t3p4o    ; tabuleiro 3 posicao 4
	cmp POSx, 24
	je 	t3p5o
	cmp POSx, 26
	je 	t3p6o
y4_vPo:
	cmp POSx, 22
	je	t3p7o	; tabuleiro 3 posicao 7
	cmp POSx, 24
	je 	t3p8o
	cmp POSx, 26
	je 	t3p9o

t3p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t3p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t3p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t3p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t3p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t3p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t3p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t3p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t3p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt6, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab6_O endp
;########################################################################

;########################################################################

verTab7_X proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 10
	je y2_vPx   	;verifica a coluna
	cmp POSy, 11
	je y3_vPx
	cmp POSy, 12
	je y4_vPx

y2_vPx:
	cmp POSx, 4
	je	t3p1   ; tabuleiro 4 posicao 1
	cmp POSx, 6
	je 	t3p2
	cmp POSx, 8
	je 	t3p3
y3_vPx:
	cmp POSx, 4
	je	t3p4    ; tabuleiro 4 posicao 4
	cmp POSx, 6
	je 	t3p5
	cmp POSx, 8
	je 	t3p6
y4_vPx:
	cmp POSx, 4
	je	t3p7	; tabuleiro 4 posicao 7
	cmp POSx, 6
	je 	t3p8
	cmp POSx, 8
	je 	t3p9

t3p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1t3

     
t3p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3


t3p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1t3
t3p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
t3p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1t3

t3p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
t3p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2t3
t3p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3
t3p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3t3

verProxLin1t3:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3
verProxCol1t3:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3
verProxDiag1t3:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3
verAntLin1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3
verAntLin2t3:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3
verAntCol1t3:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3
verAntCol2t3:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3
verAntDiag1t3:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3
verAntDiag2t3:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3

verAntDiagP5t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3

verAntDiagP1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3

verAntDiag3t3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt7, 1
	jmp fim_verT3


fim_verT3:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab7_X endp
;########################################################################
;########################################################################

verTab7_O proc   ;verifica vencedor no tabuleiro 3 car =
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 10
	je y2_vPo 	;verifica a coluna
	cmp POSy, 11
	je y3_vPo 
	cmp POSy, 12
	je y4_vPo

y2_vPo:
	cmp POSx, 4
	je	t3p1o   ; tabuleiro 3 posicao 1
	cmp POSx, 6
	je 	t3p2o
	cmp POSx, 8
	je 	t3p3o
y3_vPo:
	cmp POSx, 4
	je	t3p4o    ; tabuleiro 3 posicao 4
	cmp POSx, 6
	je 	t3p5o
	cmp POSx, 8
	je 	t3p6o
y4_vPo:
	cmp POSx, 4
	je	t3p7o	; tabuleiro 3 posicao 7
	cmp POSx, 6
	je 	t3p8o
	cmp POSx, 8
	je 	t3p9o

t3p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t3p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t3p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t3p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t3p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t3p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t3p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t3p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t3p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt7, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab7_O endp
;########################################################################

;########################################################################

verTab8_X proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 10
	je y2_vPx   	;verifica a coluna
	cmp POSy, 11
	je y3_vPx
	cmp POSy, 12
	je y4_vPx

y2_vPx:
	cmp POSx, 13
	je	t3p1   ; tabuleiro 4 posicao 1
	cmp POSx, 15
	je 	t3p2
	cmp POSx, 17
	je 	t3p3
y3_vPx:
	cmp POSx, 13
	je	t3p4    ; tabuleiro 4 posicao 4
	cmp POSx, 15
	je 	t3p5
	cmp POSx, 17
	je 	t3p6
y4_vPx:
	cmp POSx, 13
	je	t3p7	; tabuleiro 4 posicao 7
	cmp POSx, 15
	je 	t3p8
	cmp POSx, 17
	je 	t3p9

t3p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1t3

     
t3p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3


t3p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1t3
t3p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
t3p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1t3

t3p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
t3p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2t3
t3p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3
t3p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3t3

verProxLin1t3:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3
verProxCol1t3:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3
verProxDiag1t3:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3
verAntLin1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3
verAntLin2t3:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3
verAntCol1t3:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3
verAntCol2t3:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3
verAntDiag1t3:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3
verAntDiag2t3:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3

verAntDiagP5t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3

verAntDiagP1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3

verAntDiag3t3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt8, 1
	jmp fim_verT3


fim_verT3:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab8_X endp
;########################################################################
;########################################################################

verTab8_O proc   ;verifica vencedor no tabuleiro 3 car =
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 10
	je y2_vPo 	;verifica a coluna
	cmp POSy, 11
	je y3_vPo 
	cmp POSy, 12
	je y4_vPo

y2_vPo:
	cmp POSx, 13
	je	t3p1o   ; tabuleiro 3 posicao 1
	cmp POSx, 15
	je 	t3p2o
	cmp POSx, 17
	je 	t3p3o
y3_vPo:
	cmp POSx, 13
	je	t3p4o    ; tabuleiro 3 posicao 4
	cmp POSx, 15
	je 	t3p5o
	cmp POSx, 17
	je 	t3p6o
y4_vPo:
	cmp POSx, 13
	je	t3p7o	; tabuleiro 3 posicao 7
	cmp POSx, 15
	je 	t3p8o
	cmp POSx, 17
	je 	t3p9o

t3p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t3p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t3p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t3p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t3p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t3p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t3p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t3p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t3p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt8, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab8_O endp
;########################################################################

;########################################################################

verTab9_X proc   ;verifica vencedor no tabuleiro 1 car X
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 10
	je y2_vPx   	;verifica a coluna
	cmp POSy, 11
	je y3_vPx
	cmp POSy, 12
	je y4_vPx

y2_vPx:
	cmp POSx, 22
	je	t3p1   ; tabuleiro 4 posicao 1
	cmp POSx, 24
	je 	t3p2
	cmp POSx, 26
	je 	t3p3
y3_vPx:
	cmp POSx, 22
	je	t3p4    ; tabuleiro 4 posicao 4
	cmp POSx, 24
	je 	t3p5
	cmp POSx, 26
	je 	t3p6
y4_vPx:
	cmp POSx, 22
	je	t3p7	; tabuleiro 4 posicao 7
	cmp POSx, 24
	je 	t3p8
	cmp POSx, 26
	je 	t3p9

t3p1:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxDiag1t3

     
t3p2:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3


t3p3:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag1t3
t3p4:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
t3p5:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP5t3

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiagP1t3

t3p6:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin1t3
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
t3p7:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verProxCol1t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag2t3
t3p8:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol1t3
t3p9:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntLin2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntCol2t3
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'X'
     je  verAntDiag3t3

verProxLin1t3:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3
verProxCol1t3:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3
verProxDiag1t3:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3
verAntLin1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3
verAntLin2t3:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3
verAntCol1t3:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3
verAntCol2t3:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3
verAntDiag1t3:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3
verAntDiag2t3:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3

verAntDiagP5t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3

verAntDiagP1t3:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3

verAntDiag3t3:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'X'
	jne fim_verT3
	mov bt9, 1
	jmp fim_verT3


fim_verT3:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab9_X endp
;########################################################################
;########################################################################

verTab9_O proc   ;verifica vencedor no tabuleiro 3 car =
	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp POSy, 10
	je y2_vPo 	;verifica a coluna
	cmp POSy, 11
	je y3_vPo 
	cmp POSy, 12
	je y4_vPo

y2_vPo:
	cmp POSx, 22
	je	t3p1o   ; tabuleiro 3 posicao 1
	cmp POSx, 24
	je 	t3p2o
	cmp POSx, 26
	je 	t3p3o
y3_vPo:
	cmp POSx, 22
	je	t3p4o    ; tabuleiro 3 posicao 4
	cmp POSx, 24
	je 	t3p5o
	cmp POSx, 26
	je 	t3p6o
y4_vPo:
	cmp POSx, 22
	je	t3p7o	; tabuleiro 3 posicao 7
	cmp POSx, 24
	je 	t3p8o
	cmp POSx, 26
	je 	t3p9o

t3p1o:
	 mov al,0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al,0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxDiag1o

     
t3p2o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o


t3p3o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag1o
t3p4o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
t3p5o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 3 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP5_O

	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao 1 da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiagP1_O

t3p6o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao abaixo possui o mesmo char
	 add lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin1o
	
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
t3p7o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na acima abaixo possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verProxCol1o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag2o
t3p8o:
	 mov al, 0 
	 mov al, POSy
	 mov lin, al	;verifica se na posicao acima possui o mesmo char
	 sub lin, 1
	 mov al, 0 
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à direita possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 add col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol1o
t3p9o:
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na linha acima possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntLin2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao à esquerda possui o mesmo char
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntCol2o
	 
	 mov al, 0
	 mov al, POSy
	 mov lin, al	;verifica se na posicao da diagonal possui o mesmo char
	 sub lin, 1
	 mov al, 0
	 mov al, POSx
	 mov col, al 
	 sub col, 2
	 call posicao_ecra
	 mov si, pos_ecra
	 mov al, es:[si] ; ler letra ecra
     cmp al, 'O'
     je  verAntDiag3o

verProxLin1o:
	add lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o
verProxCol1o:
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o
verProxDiag1o:
	add lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o
verAntLin1o:
	mov al, 0
	mov al, POSy
	mov lin, al
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o
verAntLin2o:
	sub lin, 1
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o
verAntCol1o:
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o
verAntCol2o:
	sub  col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o
verAntDiag1o:
	add lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o
verAntDiag2o:
	sub lin, 1
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o

verAntDiagP5_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o

verAntDiagP1_O:
	mov al, 0
	mov al, POSy
	mov lin, al
	add lin, 1
	mov al, 0
	mov al, POSx
	mov col, al
	add col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o

verAntDiag3o:
	sub lin, 1
	sub col, 2
	call posicao_ecra
	mov si, pos_ecra
	mov al, es:[si] ; ler letra ecra
    cmp al, 'O'
	jne fim_verT1o
	mov bt9, 1
	jmp fim_verT1o


fim_verT1o:
    pop si 	;recupera
    pop dx 
    pop ax 
    popf

	ret

verTab9_O endp
;########################################################################

ver_venc_minTab proc; verifica se há vencedor no mini tabuleiro

	pushf     ;guarda
    push ax
    push dx
    push si 

	cmp n_tab, 1
	je  t1
	cmp n_tab, 2
	je	 t2
	cmp n_tab, 3
	je	 t3
	cmp n_tab, 4
	je	 t4
	cmp n_tab, 5
	je	 t5
	cmp n_tab, 6
	je	 t6
	cmp n_tab, 7
	je	 t7
	cmp n_tab, 8
	je	 t8
	cmp n_tab, 9
	je	 t9

t1:
 	cmp nplayer, 1
	je px1
	cmp nplayer, 2
	je py1
t2:
	cmp nplayer, 1
	je px2
	cmp nplayer, 2
	je py2
t3:
	cmp nplayer, 1
	je px3
	cmp nplayer, 2
	je py3
t4:
	cmp nplayer, 1
	je px4
	cmp nplayer, 2
	je py4
t5:
	cmp nplayer, 1
	je px5
	cmp nplayer, 2
	je py5
t6:
	cmp nplayer, 1
	je px6
	cmp nplayer, 2
	je py6
t7:
	cmp nplayer, 1
	je px7
	cmp nplayer, 2
	je py7
t8:
	cmp nplayer, 1
	je px8
	cmp nplayer, 2
	je py8
t9:
	cmp nplayer, 1
	je px9
	cmp nplayer, 2
	je py9

px1:  		;jogou X no tabuleiro 1
	call verTab1_X
	cmp bt1, 1
	jne fimVer_minTab
	call mudaCorTab1
	call preencheTabUltimate
	jmp fimVer_minTab
px2:		;jogou X no tabuleiro 2
	call verTab2_X
	cmp bt2, 1
	jne fimVer_minTab
	call mudaCorTab2
	call preencheTabUltimate
	jmp fimVer_minTab
px3:		;jogou X no tabuleiro 3
	call verTab3_X
	cmp bt3, 1
	jne fimVer_minTab
	call mudaCorTab3
	call preencheTabUltimate
	jmp fimVer_minTab
px4:
	call verTab4_X
	cmp bt4, 1
	jne fimVer_minTab
	call mudaCorTab4
	call preencheTabUltimate
	jmp fimVer_minTab
px5:
	call verTab5_X
	cmp bt5, 1
	jne fimVer_minTab
	call mudaCorTab5
	call preencheTabUltimate
	jmp fimVer_minTab
px6:
	call verTab6_X
	cmp bt6, 1
	jne fimVer_minTab
	call mudaCorTab6
	call preencheTabUltimate
	jmp fimVer_minTab
px7:
	call verTab7_X
	cmp bt7, 1
	jne fimVer_minTab
	call mudaCorTab7
	call preencheTabUltimate
	jmp fimVer_minTab
px8:
	call verTab8_X
	cmp bt8, 1
	jne fimVer_minTab
	call mudaCorTab8
	call preencheTabUltimate
	jmp fimVer_minTab
px9:
	call verTab9_X
	cmp bt9, 1
	jne fimVer_minTab
	call mudaCorTab9
	call preencheTabUltimate
	jmp fimVer_minTab


py1: 		;player o tabuleiro 1
	call verTab1_O
	cmp bt1, 1
	jne fimVer_minTab
	call mudaCorTab1
	call preencheTabUltimate
	jmp fimVer_minTab
py2:	;player o tabuleiro 2
	call verTab2_O
	cmp bt2, 1
	jne fimVer_minTab
	call mudaCorTab2
	call preencheTabUltimate
	jmp fimVer_minTab
py3:
	call verTab3_O
	cmp bt3, 1
	jne fimVer_minTab
	call mudaCorTab3
	call preencheTabUltimate
	jmp fimVer_minTab
py4:
	call verTab4_O
	cmp bt4, 1
	jne fimVer_minTab
	call mudaCorTab4
	call preencheTabUltimate
	jmp fimVer_minTab
py5:
	call verTab5_O
	cmp bt5, 1
	jne fimVer_minTab
	call mudaCorTab5
	call preencheTabUltimate
	jmp fimVer_minTab
py6:
	call verTab6_O
	cmp bt6, 1
	jne fimVer_minTab
	call mudaCorTab6
	call preencheTabUltimate
	jmp fimVer_minTab
py7:
	call verTab7_O
	cmp bt7, 1
	jne fimVer_minTab
	call mudaCorTab7
	call preencheTabUltimate
	jmp fimVer_minTab
py8:
	call verTab8_O
	cmp bt8, 1
	jne fimVer_minTab
	call mudaCorTab8
	call preencheTabUltimate
	jmp fimVer_minTab
py9:
	call verTab9_O
	cmp bt9, 1
	jne fimVer_minTab
	call mudaCorTab9
	call preencheTabUltimate
	jmp fimVer_minTab


fimVer_minTab: 
	 pop si 	;recupera
     pop dx 
     pop ax 
     popf

     ret
ver_venc_minTab endp
;########################################################################

jogador_jogar macro nplayer   ;coloca a cor do jogador e do espetador 
		cmp nplayer, 1
		je jx
		cmp nplayer, 2
		je	jy
jx:
	mov lin, 1
	mov col, 40
	call posicao_ecra
	mov 	si, pos_ecra 	; origem(01,40)	
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
	mov lin, 2
	mov col, 40
	call posicao_ecra
	mov 	si, pos_ecra  	; origem(02,40)
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
	mov lin, 2
	mov col, 40
	call posicao_ecra
	mov 	si, pos_ecra  	; origem(02,40)
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
	mov lin, 1
	mov col, 40
	call posicao_ecra
	mov 	si, pos_ecra  	; origem(01,40)	
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

			cmp writeNome, 1
			jne POSE_NOME1
			cmp writeNome, 0
			jne LER_SETA
POSE_NOME1:
	 mov writeNome, 1
	 xor si, si
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
	 xor si, si
	 mov di, 0  ; contador
	 mov lin, 2
	 mov col, 40
	 call posicao_ecra
	 mov si, pos_ecra ; destino (02,40)
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
		call 	ver_venc_minTab;chamar procedimento para verificar se ganhou
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
		call 	ver_venc_minTab;chamar procedimento para verificar se ganhou
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


		

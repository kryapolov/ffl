;FFl
        model   tiny

        .code
        org     100h
EXTRN BinToAscDec:Proc,StrWrite:Proc,GetParams:Proc,GetOneParam:Proc,ParamCount:Proc
EXTRN NewLine:Proc,StrUpper:proc
start:
        mov     ax,2524h
        lea     dx,int_24
        int     21h

    Call GetParams
    Call ParamCount
    mov  di,offset Welcome
    Call StrWrite
    or   dx,dx
    jz   @10p
    call NewLine
    xor cx,cx
    push cs
    pop  ds
    call GetOneParam ; получить параметр и
    ;Call StrUpper ; преобразовать в прописные
    ;    xchg di,ax
    mov ax,word ptr cs:[di]
    mov  word ptr cs:[path],ax

    mov cx,1
    call GetOneParam ; получить параметр и
    Call StrUpper ; преобразовать в прописные
    mov si,di
    mov di,offset massa+1
    movsw
    movsb


    ;    mov     ah,19h
    ;    int     21h
    ;    mov     dl,al
    ;    mov     ah,0eh
    ;    int     21h
    ;    add     al,41h
    ;    add al,43h
    ;    mov     tik,al
nachalo:
        mov     ah,4eh    ; поиск по первой
        mov     cx,37h    ;
        lea     dx,path   ;
        int     21h
        jnc     no_problem
        jmp     quit      ; есть проблемы.
@10p:
      jmp exit


no_problem:
        mov     si,95h              ; Тестируем аттрибуты.
        test    byte ptr [si],10h   ;
        jnz     dir                 ;

        mov     si,9eh
        mov     cx,13
        mov     bx,0
        mov     di,offset massa
kk1:
        mov     al,[si]
        mov     dl,[di]
        cmp     al,'.'
        je      Pardon1
        inc si
        loop    kk1
        jmp next

 Pardon1:
   inc si  ;+
   inc di  ;+

 mardon1:
    mov     al,[si]
    mov     dl,[di]
    cmp     al,dl
    je      mpsx
 ssW:
 inc si
 loop  mardon1

cmp bx,3
je  nexus
jne next

mpsx:
 cmp bx,3
 je nexus
 inc bx
 inc di
jmp SSw

nexus:
        inc [index]
        call    lotos
        mov     ax,0a20h    ; Стиаем стаое содежимое стоки на экане.
        mov     cx,80       ;
        mov     bh,0        ;
        int     10h         ;
        lea     si,path
        cld
; Вывод пути к файлу
sled:   mov     ah,0eh
        mov     bh,0
        lodsb
        cmp     al,'*'
        je      end_dir
        int     10h
        jmp     short sled
end_dir:
; Вывод имени самого файла.
        mov     si,9eh
sled1:
        mov     ah,0eh
        mov     bh,0
        lodsb
        cmp     al,0
        je      end_name
        int     10h
        jmp     short sled1
end_name:
        mov     al,13
        int     10h
Pardon:
        jmp     short next
dir:
        mov     si,9eh
        cmp     byte ptr [si],'.'
        je      next
        lea     di,path
        add     di,offs
        cld
opium:
        lodsb
        stosb
        inc     offs  ; ?овышаем ранг.
        cmp     al,0
        jne     opium
        dec     di
        call    form
        cld
        mov     si,80h
        mov     cx,22
push_loop:
        lodsw
        push    ax
        loop    push_loop
        jmp     nachalo

next:
        mov     ah,4fh
        int     21h
        ;jnc     no_problem
        jc Quit
        jmp  no_problem
quit:
        cmp     offs,3
        je      exit ; Ведь так ? ... диск кончился и мы завешаем аботу.

        lea     di,path   ; Чет побеpи есть и дpугие каталоги.
        add     di,offs   ; Ставим указатель на конец.
        dec     di   ;-1  ; Имя состоит минимум из 1го символа.
found:
        dec     di   ;-1
        dec     offs ;-1
        ; Ставим указатель на постедний каталог.
        cmp     byte ptr [di],'\' ; Опpеделяем это
        jne     found
        call    form  ; дописываем маску в конец каталога.
        mov     cx,22      ; байты необходимые для поиска дальше.
        mov     di,80h+42  ; Опpеделяем нужное место в DTA.
        std     ; Автоуменьшение.
pop_loop:
        pop     ax ; Забиаем из стека.
        stosw   ; Кидаем в DTA.
        loop    pop_loop  ; Зацикливаем.
        jmp     short next ; пpодолжаем поиск дальше.

exit:
;
;ret
;

;lea     si,path
;mov     al,byte ptr [si]  ; 'C'
;cmp     tik,al
;je      ex
;inc     al                 ; al+1
;mov     byte ptr [si],al
;mov     offs,3
;jmp     nachalo

ex:
        mov     ax,0a20h  ; Стиpаем последнюю стpоку поиска с экpана.
        mov     cx,80     ;
        mov     bh,0      ;
        int     10h       ;


   ;mov bx,1
   ;mov cx,22
   ;lea dx,Wri_1    ; Вывод  сообщения
   ;mov ah,40h
   ;int 21h
   lea di,Wri_1
   call StrWrite



    mov ax,[Index]
    mov cx,1
    mov di,offset Rezu
    call BinToAscDec
    mov di,offset Rezu
    call StrWrite


   ;mov bx,1
   ;mov cx,2
   ;mov ah,40h
   ;lea dx,Index    ; Вывод  сообщения
   ;int 21h
   ret

form:

        lea     si,maska   ;  Копиpуем маску поиска в стpоку пути.
        cld                ;
        mov     cx,5       ;
        rep     movsb      ;
        ret                ;

lotos:
        mov     si,9eh
        mov     cx,13
l0:
        mov     al,[si]
        cmp     al,80h
        jae     l10
        cmp     al,5bh
        jae     l201
        cmp     al,40h
        jbe     l201
        add     al,20h
        jmp     short l20
l10:
        cmp     al,0a0h
        jae     l201
        cmp     al,90h
        jb      l15
        add     al,50h
        jmp     short l20
l15:
        add     al,20h
l20:
        mov     [si],al
l201:
        inc     si
        loop    l0
        ret

int_24:
        mov     al,3
        iret

        .data
offs    dw      3
;tik     db      0

Wri_1   db 'найдено *.xxx файлов: ',0
Welcome db 'пожалуйста ждите , идет поиск...',0
index   dw 0
rezu    db 20 dup (0)
maska   db      '\*.*',0
Massa   db    '.COM'
Buffel  db 13 dup (0)
path    db      'D:\*.*',0

        end     start
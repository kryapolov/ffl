;FFl

      IDEAL
      model   small
      Stack 512

   dataSeg
offs    dw      3
Wri_1   db 'Найдено *.xxx файлов: ',0
Welcome db 'Пожалуйста ждите , идет поиск...',0
index   dw 0
rezu    db 20 dup (0)
Dta     db 60 dup (0)
maska   db      '\*.*',0
Massa   db    '.COM'
Buffel  db 13 dup (0)
path    db   'D:\*.*',90 dup(0),0

        codeSeG
EXTRN BinToAscDec:Proc,StrWrite:Proc,GetParams:Proc,GetOneParam:Proc,ParamCount:Proc
EXTRN NewLine:Proc,StrUpper:proc
start:
    mov  ax,@data
    mov  es,ax
    mov  ds,ax


        mov     ax,2524h
        mov     dx,offset int_24
        int     21h

    Call GetParams
    Call ParamCount
    mov  di,offset Welcome
    Call StrWrite
    or   dx,dx
    jz   @10p
    call NewLine
    xor cx,cx
    call GetOneParam ; Получить параметр и
    mov si,di
    mov di,offset Path
    movsw
    ;Call StrUpper ; преобразовать в прописные
    ;    xchg di,ax
    ;mov ax,[di]
    ;mov bx,offset Path
    ;mov [bx],ax

    ;mov word ptr [Path],ax

   ; mov cx,1
   ; call GetOneParam ; Получить параметр и
   ; Call StrUpper ; преобразовать в прописные
   ; mov si,di
   ; mov di,offset massa+1
   ; movsw
   ; movsb


    ;    mov     ah,19h
    ;    int     21h
    ;    mov     dl,al
    ;    mov     ah,0eh
    ;    int     21h
    ;    add     al,41h
    ;    add al,43h
    ;    mov     tik,al

    mov dx,offset Dta
    mov ah,1Ah
    int 21h


nachalo:
        mov     ah,4eh    ; Поиск по первой
        mov     cx,37h    ;
        mov     dx,offset path   ;
        int     21h
        jnc     no_problem
        jmp     quit      ; есть проблемы.
@10p:
      jmp exit


no_problem:
        mov     si,offset Dta + 21;95h              ; Тестируем аттрибуты.
        mov     ax,[si]
        ;test    byte ptr [si],10h   ;
        test    ax,10h
        jnz     dir                 ;

        mov     si,offset Dta+30;9eh
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
        mov     si,offset path
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
        mov     si,offset Dta+30;9eh
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
        mov     si,offset Dta+30;9eh
        mov     ax,[si]
        cmp     ax,'.'
        je      next
        mov     di,offset path
        add     di,[offs]
        cld
opium:
        lodsb
        stosb
        inc     [offs]  ; Повышаем ранг.
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
        cmp     [offs],3
        je      exit ; Ведь так ? ... диск кончился и мы завешаем аботу.

        mov     di,offset path   ; Чет побеpи есть и дpугие каталоги.
        add     di,[offs]   ; Ставим указатель на конец.
        dec     di   ;-1  ; Имя состоит минимум из 1го символа.
found:
        dec     di   ;-1
        dec     [offs] ;-1
        ; Ставим указатель на постедний каталог.
        mov ax,[di]
        cmp     ax,'\' ; Опpеделяем это
        jne     found
        call    form  ; дописываем маску в конец каталога.
        mov     cx,22      ; Байты необходимые для поиска дальше.
        mov     di,80h+42  ; Опpеделяем нужное место в DTA.
        std     ; Автоуменьшение.
pop_loop:
        pop     ax ; Забиаем из стека.
        stosw   ; Кидаем в DTA.
        loop    pop_loop  ; Зацикливаем.
        jmp     short next ; Пpодолжаем поиск дальше.

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
   mov di,offset Wri_1
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

        mov     si,offset maska   ;  Копиpуем маску поиска в стpоку пути.
        cld                ;
        mov     cx,5       ;
        rep     movsb      ;
        ret                ;

lotos:
        mov     si,offset Dta+30;9eh
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

        end     start
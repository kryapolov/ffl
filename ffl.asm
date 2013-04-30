;
;FFl utility


        model   tiny

        .code
        org     100h
start:
        mov     ax,2524h
        lea     dx,int_24
        int     21h

        mov     ah,19h
        int     21h
        mov     dl,al
        mov     ah,0eh
        int     21h
        add     al,41h
        ;add al,43h
        mov     tik,al
nachalo:
        mov     ah,4eh    ; Поиск по первой
        mov     cx,37h    ;
        lea     dx,path   ;
        int     21h
        jnc     no_problem
        jmp     quit      ; есть проблемы.
no_problem:
        mov     si,95h              ; Тестируем аттрибуты.
        test    byte ptr [si],10h   ;
        jnz     dir                 ;

      ;  call    lotos
        mov     ax,0a20h
        mov     cx,80
        mov     bh,0
        int     10h
        lea     si,path
        cld
sled:   mov     ah,0eh
        mov     bh,0
        lodsb
        cmp     al,'*'
        je      end_dir
        int     10h
        jmp     short sled
end_dir:
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
        inc     offs  ; Повышаем ранг.
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
        jmp     short nachalo

next:
        mov     ah,4fh
        int     21h
        jnc     no_problem

quit:
        cmp     offs,3
        je      exit
        lea     di,path
        add     di,offs
        dec     di
found:
        dec     di
        dec     offs
        cmp     byte ptr [di],'\'
        jne     found
        call    form
        mov     cx,22
        mov     di,80h+42
        std
pop_loop:
        pop     ax
        stosw
        loop    pop_loop
        jmp     short next

exit:
;
ret
;
lea     si,path
        mov     al,byte ptr [si]  ; 'C'
        cmp     tik,al
        je      ex
        inc     al                 ; al+1
        mov     byte ptr [si],al
        mov     offs,3

        jmp     nachalo
ex:
        mov     ax,0a20h
        mov     cx,80
        mov     bh,0
        int     10h

        ret


form:
        lea     si,maska
        cld
        mov     cx,5
        rep     movsb
        ret

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
tik     db      0

maska   db      '\*.*',0

path    db      'C:\*.*',0

        end     start
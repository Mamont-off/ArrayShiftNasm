global _main

extern _exit
extern _scanf
extern _printf

%macro printArray 1
	
    mov esi, -1

    printelem:
        inc esi

        mov eax, [array + esi * %1]

        push eax
        push dword formatout  
        call _printf
        add esp,8

	    cmp esi,[count]
	    jne printelem

%endmacro

section .data

    formatin: db "%d", 0  ; формат ввода
    formatout: db "%d", 0xA, 0 ; формат вывода 1 элемент
    formatoutline: db "%d %d %d", 0xA, 0 ; формат вывода 3 элементов

    array: dd 6,1,2 ;массив
    count: dd 2 ;размер массива

    integer: times 4 db 0 ;ввод пользователя

section .text

_main:

    call printArrayLine

    push integer
    push formatin
    call _scanf
    add esp, 8

    mov esi, 0

    movetocount:
        push esi ;сохраняем esi

        mov eax, dword [integer]
        test eax, eax
        js moveleft ; знак есть
        jns moveright ; знак нет

        endmove:

        pop esi ;востанавливаем esi
        inc esi
        cmp esi,eax
        jne movetocount ; проверяем закончили ли мы

    call printArrayLine

    ;"пауза"
    push integer
    push formatin
    call _scanf
    add esp, 8

   push dword 0
   call _exit
ret

moveright:
	mov esi, 0 ;обнуляем счетчик
	mov eax, [array+esi*4] ; сохраняем элемент

	onemover:
		inc esi ;увеличиваем счетчик

		mov ebx, [array+esi*4] ; сохраняем следующий элемент в ebx
		mov [array+esi*4], eax ; заменяем следущий предыдущим
		mov eax, ebx ; сохраняем убранный элемент

		cmp esi,[count] ; не конец ли массива
		jne onemover

	mov [array+0], eax ; последний сохраненный = первый
	mov eax, dword [integer]
	jmp endmove ; возврат 

moveleft:
	mov esi, [count]
	mov eax, [array+esi*4]

	onemovel:
		dec esi ; уменьшаем счетчик

		mov ebx, [array+esi*4]
		mov [array+esi*4], eax
		mov eax, ebx

		cmp esi, 0
		jne onemovel

	mov esi, [count]
	mov [array+esi*4], eax

	mov eax, dword [integer]
	neg eax ; для сравнения с esi делаем значение положительным
	jmp endmove 

printArrayLine:
    mov esi, -1

    pushprintelem:
        inc esi
        mov eax, [array + esi * 4]
        
        push eax

	    cmp esi,[count]
	    jne pushprintelem

    push dword formatoutline  
    call _printf
    add esp,16 ;3 элемента по 4 байта + 4
ret ; возврат        
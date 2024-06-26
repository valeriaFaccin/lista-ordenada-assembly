#########################################################################
#	Universidade Federal da Fronteira Sul - Campus Chapec�, SC	#
#		Ci�ncias da Computa��o					#
#	Disciplina: Organiza��o de Computadores				#
#	Docente: Luciano Lores Caimi					#
#	Discentes: Jo�o Vitor Gomes da Silva e Val�ria Faccin		#
#########################################################################

		.data
head:		.word 0

		#inputs simples para o usuario
txt_inserido:	.string " foi inserido no �ndice: "
txt_removido0:	.string " O elemento de "
txt_removidoV:	.string "�ndice "
txt_removidoI:	.string "valor "
txt_removido1:	.string " foi removido."
txt_input:	.string "\n Digite um n�mero\n "
txt_imprimir:	.string	"\n Elementos da Lista\n "
sem_elementos:	.string	"\n N�o h� elementos na lista\n"
separador:	.string " | "
txt_maior: 	.string "\n Maior elemento da Lista: "
txt_menor:	.string "\n Menor elemento da Lista: "
txt_qtd_ins:	.string "\n N�mero(s) inserido(s): "
txt_qtd_remv:	.string "\n N�mero(s) removido(s): "
txt_list_vazia:	.string	"\n Lista Vazia!"
qtd_total:	.string "\n Quantidade de elementos na Lista: "
txt_invalido:	.string "\n ***DIGITE UMA OP��O V�LIDA***"
txt_erro_in:	.string " N�o foi posss�vel inserir na lista"
txt_erro_remv:	.string	" N�o foi poss�vel remover na lista\n"

		#print do menu
menu:		.ascii "\n\n *** MENU ***\n\n"
op1:		.ascii " 1 - Inserir\n"
op2:		.ascii " 2 - Remover por indice\n"
op3:		.ascii " 3 - Remover por valor\n"
op4:		.ascii " 4 - Imprimir lista\n"
op5:		.ascii " 5 - Estat�sticas\n"
op6:		.asciz " 6 - Sair\n "

		.text
main:
	li s0, 0		# Inicia o registrador de controle do maior n�mero
	li s2, 0		# Inicia o registrador de controle da quantidade de inser��es
	li s3, 0		# Inicia o registrador de controle da quantidade de remo��es
	
loop_menu:
	li a7, 4 		# Comando para PrintString
	la a0, menu		# Carrega o menu para ser printado
	ecall			# Chama o OS
	li a7, 5		# Comando para ReadInt
	ecall			# Chama o OS
	li t0, 1		# Insere inteiro
	beq t0, a0, trata_insere 
	li t0, 2		# Remover por �ndece
	beq t0, a0, trata_removeI
	li t0, 3		# Remover por valor
	beq t0, a0, trata_removeV
	li t0, 4		# Imprimir lista
	beq t0, a0, trata_print
	li t0, 5		# Estat�sticas
	beq t0, a0, trata_estatistica
	li t0, 6
	beq t0, a0, fim		# Se op��o = 6 encerra 

invalido:
	la a0,txt_invalido	# Salva a mensagem "inv�lida" para retorno
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	j loop_menu		# Volta para o loop

trata_insere:
	jal input_a1a0
	jal insere_inteiro
	li a7, 4		# Chama a mensagem
	bltz a0, erro_ins
	mv t0, a0
	la a0, txt_inserido	# Mensagem final
	ecall
	li a7, 1
	mv a0, t0
	ecall
	j loop_menu		# Volta para o loop
	
erro_ins:
	la a0, txt_erro_in
	ecall
	j loop_menu		# Volta para o loop
	
trata_removeI:
	jal input_a1a0
	jal remove_por_indice
	bltz a0, erro_rmv
	la t0, txt_removidoI
	j output
	
trata_removeV:
	jal input_a1a0
	jal remove_por_valor
	bltz a0, erro_rmv
	la t0, txt_removidoV
	j output		
	
output:
	li a7, 4
	la a0, txt_removido0
	ecall
	mv a0, t0
	ecall
	mv a0, a1
	li a7, 1
	ecall
	la a0, txt_removido1
	li a7, 4
	ecall
	j loop_menu
	
erro_rmv:
	la a0, txt_erro_remv
	li a7, 4
	ecall
	j loop_menu
	
trata_print:
	la a0, head
	jal imprime_lista
	j loop_menu		# Volta para o loop
	
trata_estatistica:
	jal estatistica
	j loop_menu		# Volta para o loop
	
fim:
	li a0, 0		# Coloca 0 no retorno do programa
	li a7, 93		# Comando para encerrar programa
	ecall			# Chama OS

#################################################################
# Fun��o: int insere_inteiro(int *head, int valor)		#
#   Adiciona o inteiro no final da lista			#
#   e atualiza a estat�stica numeros inseridos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o indice inserido				#
#################################################################

insere_inteiro:
	mv t2, zero		# Indice, i = 0
	lw t0, 0(a0)		# Salva em t0 o valor do endere�o de a0
	mv t1, a0		# Move o valor para t1
	
	
procura_fim:
	beqz t0, att_maior	# Se t0 for 0, vai para insere
	lw t3, (t0)
	bge t3, a1, insere
	
	addi t2, t2, 1		# Incrementa o �ndice i ++
	addi t1, t0, 4 		# ponteiro para o proximo t1 = temp->next
	lw t0, 4(t0)		# Passa para a proxima posi��o t0 = temp->next->next
	
	j procura_fim

att_maior:
	mv s0, a1
	
insere:
	li a7, 9 		# Codigo para alocar mem�ria
	li a0, 8 		# Aloca 8 bytes de mem�ria
	ecall 	
	li t3, -1 		# se skrb retornar -1 n�o d� para alocar m�moria
	beq t0, t3, erro_insere	 
	sw t0, 4(a0)		# novo->next = temp->next
	sw a1, 0(a0) 		# Salva o valor no novo n�
	sw a0, 0(t1) 		# temp->next = novo
	addi s2, s2, 1		# Contador de n�meros inseridos
	mv a0, t2		# Move o �ndice para o print e para o retorno da fun��o
	ret			# retorna da fun��o
	
erro_insere:
	li a0, -1		#indice -1 se for erro
	ret	
	
#################################################################
# fun��o: int remove_por_indice(int *head, int indice);  	#
#   remove um elemento da lista pelo indice			#
#   e atualiza a estat�stica numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o valor removido ou exce��o			#
#################################################################

remove_por_indice:
	bltz a1, erro			# Se a1 < 0, indice menor que a lista
	sub t0, s2, s3			# Quantidade de elementos na lista
	bge a1, t0, erro		# Se a1 >= n, indice maior que a lista
	
	addi t1, a0, -4
	addi t3, zero, 0		# inicia o contador de �ndices
	
procura_indice:
	beq t3, a1, remover_indice	# i == valor
	lw t1, 4(t1)			# prev = prev->next
	addi t3, t3, 1			# incrementa o contador do �ndice
	j procura_indice		# retorna para procura_indice, para nova itera��o na lista

erro:
        li a0, -1
        li a1, -1
        ret

remover_indice:
	lw t0, 4(t1)			# removido = prev->next
	lw a1, 0(t0)			# a1 = removido->valor
	mv t2, ra			# salva o retorno
	jal remove_item			# chama a fun��o geral de remo��o
	jr t2
	
#################################################################
# fun��o: int remove_por_valor(int *head, int valor)		#
#   remove um elemento da lista pelo valor			#
#   e atualiza a estat�stica numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o indice do removido ou exce��o		#
#################################################################

remove_por_valor:
	addi t0, a0, -4
	li t3, 0

procura_valor:
	mv t1, t0			# prev = temp
	lw t0, 4(t0)			# temp = temp->next
	beqz t0, nao_encontrou		# N�o encontrou o valor
	lw t2, 0(t0)			# temp = temp->valor
	beq t2, a1, remover_valor	# temp->valor == valor
	addi t3, t3, 1			# i++
	bge a1, t2, procura_valor	# temp->valor < valor

nao_encontrou:
        li a0, -1
        li a1, -1
        ret

remover_valor:
	mv t2, ra			# Salva o endereco
	jal remove_item			# Chama a fun��o geral de remo��o
	mv a1, t3
	jr t2
	
#################################################################
# fun��o: void imprime_lista(int *head)				#
#   Imprime a lista						#
# entrada: a0 - ponteiro head					#
#################################################################

imprime_lista:
	mv t2, a0			# Salva o valor de a0 (head) em t2	
	la a0, txt_imprimir  
        li a7, 4              		# Comando para PrintString
        ecall				# Chama OS
	
	lw t0, 0(t2)			# Salva em t0 o valor de t2
	beqz t0, nenhum_elemento	# Vai para label se t0 = 0, ou seja, n�o h� elementos na lista

imprimir:
        lw a0, 0(t0)			# Salva em a0 o valor em t0
        li a7, 1             		# Comando para PrintInteger
        ecall				# Chama OS

        lw t0, 4(t0)          		# Salva em t0 o pr�ximo endere�o da lista
        beqz t0, fim_imprimir     	# Vai para fim_imprimir se t0 = 0, ou seja, estar no fim da lista
    
        la a0, separador  
        li a7, 4              		# Comando para PrintString
        ecall				# Chama OS
    
        j imprimir			# Volta para imprimir

nenhum_elemento:
        la a0, sem_elementos  
        li a7, 4              		# Comando para PrintString
        ecall				# Chama OS

fim_imprimir:
        ret

#################################################################
# fun��o: void estatistica()					#
#   Exibe as estat�sticas, maior n�mero, menor n�mero,		#
#   quantidade de elementos, quantidade inserida e removida	#				
#################################################################

estatistica:
	la a0, head
	lw t0, 0(a0)		# Salva em t0 o endere�o de a0 (head)
	beqz t0, vazio		# Vai para vazio se t0 = 0, ou seja, lista vazia
	lw t0, 0(t0)		# Salva em t0 o valor de t0
	
	la a0, txt_menor
	li a7, 4		# Comando para PrintString
	ecall
	mv a0, t0		# Salva o valor de t0 (primeiro elemento da lista) em a0
	li a7, 1		# Comando para PrintInteger
	ecall   
	
	la a0, txt_maior
	li a7, 4		# Comando para PrintString
	ecall
	mv a0, s0		# Salva o valor de maior em a0
	li a7, 1		# Comando para PrintInteger
	ecall      	
	
imprime_estatistica:
	la a0, qtd_total
	li a7, 4		# Comando para PrintString
	ecall
	sub t0, s2, s3
	mv a0, t0		# Salva em a0 o valor de t0
	li a7, 1		# Comando para PrintInteger
	ecall
	
	la a0, txt_qtd_ins
	li a7, 4		# Comando para PrintString
	ecall
	mv a0, s2		# Salva em a0 o valor de s2
	li a7, 1		# Comando para PrintInteger
	ecall
	
	la a0, txt_qtd_remv
	li a7, 4		# Comando para PrintString
	ecall
	mv a0, s3		# Salva em a0 o valor de s3
	li a7, 1		# Comando para PrintInteger
	ecall	
	ret	

vazio:
	la a0, txt_menor
	li a7, 4		# Comando para PrintString
	ecall
	la a0, txt_list_vazia
	li a7, 4		# Comando para PrintString
	ecall
	
	la a0, txt_maior
	li a7, 4		# Comando para PrintString
	ecall
	la a0, txt_list_vazia
	li a7, 4		# Comando para PrintString
	ecall
	
	j imprime_estatistica	# Volta para imprime_estatistica		
	
#################################################################
# fun��o: retorna par�metros					#
#   Retorna os par�metros para as fun��es principais		#
#   1 fun��o - Carrega um int em a1,				#
#   2 fun��o - Carrega o ponteiro head em a0			#
#################################################################
	
input_a1a0:
	li a7, 4		# Comando para PrintString
	la a0, txt_input	# Coloca a mensagem de input para ser exibida
	ecall			# Chama OS para exibir
	li a7, 5		# Comando para ReadInt
	ecall			# Chama OS
	mv a1, a0		# Move o valor para a1
	la a0, head		# Carrega o head em a0
	ret

#################################################################
# fun��o: remo��o geral de elementos 				#
# entrada: t0 e t1						#
# saida: retorna a0	  					#
################################################################# 

remove_item:
	lw t0, 4(t0)       	# temp = removido->next
  	sw t0, 4(t1)           	# prev->next = removido->next
  	addi s3, s3, 1  	# Incrementa o registrador do n�mero de remo��es              
	
	bnez t0, fim_remv	# if(removido-> next != null) return 1
	lw s0, 0(t1)		# else atualizaMaior()
	
fim_remv:
	li a0, 1		# Retorno de sucesso
	ret

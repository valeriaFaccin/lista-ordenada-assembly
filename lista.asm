#########################################################################
#	Universidade Federal da Fronteira Sul - Campus Chapec�, SC	#
#		Ci�ncias da Computa��o					#
#	Disciplina: Organiza��o de Computadores				#
#	Docente: Luciano Lores Caimi					#
#	Discentes: Jo�o Vitor Gomes da Silva e Val�ria Faccin		#
#########################################################################

		.data
		#estatisticas

head:		.word 0
maior:		.space 4
menor:		.space 4

		#inputs simples para o usuario
txt_inserido:	.string "foi inserido no �ndice: "
txt_qtd_ins:	.string " n�mero(s) inserido(s)\n"
txt_removido:	.string "foi removido\n"
txt_input:	.string "\nDigite um n�mero\n"
n_implementado:	.string "\nEsta opera��o n�o foi implementada\n"
txt_invalido:	.string "\n***DIGITE UMA OP��O V�LIDA***\n"

		#print do menu
menu:		.ascii "\n*** MENU ***\n\n"
op1:		.ascii "1 - Inserir\n"
op2:		.ascii "2 - Remover por indice\n"
op3:		.ascii "3 - Remover por valor\n"
op4:		.ascii "4 - Imprimir lista\n"
op5:		.ascii "5 - Estat�sticas\n"
op6:		.asciz  "6 - Sair\n"

		.text
main:
	li s2, 0		# Inicia o registrador de controle da quantidade de inser��es
	li s3, 0		# Inicia o registrador de controle da quantidade de remo��es
	
loop_menu:
	li a7, 4 		# Comando para PrintString
	la a0, menu		# Carrega o menu para ser printado
	ecall			# Chama o OS
	li a7, 5		# Comando para ReadInt
	ecall			# Chama o OS
	li t0, 6
	beq t0, a0, fim		# Se op��o = 6 encerra 
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

invalido:
	la a0 txt_invalido	# Salva a mensagem "inv�lida" para retorno
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	j loop_menu		# Volta para o loop

trata_insere:
	jal input_a1a0
	jal insere_inteiro
	mv t0, a0
	li a7, 4		# Chama a mensagem
	la a0, txt_inserido	# Mensagem final
	ecall
	li a7, 1
	mv a0, t0
	j loop_menu		# Volta para o loop
	
trata_removeI:
	jal input_a1a0
	jal remove_por_indice
	j loop_menu		# Volta para o loop
	
trata_removeV:
	jal input_a1a0
	jal remove_por_valor
	j loop_menu		# Volta para o loop
	
trata_print:
	jal input_a0
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
	beqz t0, insere		# Se t0 for 0, vai para insere
	
procura_fim:
	addi t2, t2, 1		# Incrementa o �ndice i ++
	addi t1, t0, 4 		# ponteiro para o proximo
	lw t0, 4(t0)		# Passa para as pr�ximas 4 posi��es de t0
	bnez t0, procura_fim	# Enquanto t0 n�o for 0, volta para procura_fim
	 
insere:
	li a7, 9 		# Codigo para alocar mem�ria
	li a0, 8 		# Aloca 8 bytes de mem�ria
	ecall 		
	sw zero, 4(a0)		# inicia como null
	sw a0, 0(t1) 		# Salva em a0 o endere�o em t1
	sw a1, 0(a0) 		# Salva em a1 o valor em a0
			
	mv a0, t2		# Move o �ndice para o print e para o retorno da fun��o
	addi s2, s2, 1		# Contador de n�meros inseridos
	ret			# retorna da fun��o

#################################################################
# fun��o: int remove_por_indice(int *head, int indice);  	#
#   remove um elemento da lista pelo indice			#
#   e atualiza a estat�stica numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o valor removido ou exce��o			#
#################################################################

remove_por_indice:
	la a0, txt_removido
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	ret
	
#################################################################
# fun��o: int remove_por_valor(int *head, int valor)		#
#   remove um elemento da lista pelo valor			#
#   e atualiza a estat�stica numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o indice do removido ou exce��o		#
#################################################################

remove_por_valor:
	la a0, n_implementado
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	ret
	
#################################################################
# fun��o: void imprime_lista(int *head)				#
#   Imprime a lista						#
# entrada: a0 - ponteiro head					#
#################################################################

imprime_lista:
	la a0, n_implementado
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	ret
	
#################################################################
# fun��o: void estatistica()					#
#   Exibe as estat�sticas, maior n�mero, menor n�mero,		#
#   quantidade de elementos, quantidade inserida e removida	#
#################################################################

estatistica:
	la a0, n_implementado
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	ret
	
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
	
input_a0:
	la a0, head		# Carrega o head em a0
	ret

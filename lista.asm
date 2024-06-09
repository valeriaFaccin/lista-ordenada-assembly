#########################################################################
#	Universidade Federal da Fronteira Sul - Campus Chapecó, SC	#
#		Ciências da Computação					#
#	Disciplina: Organização de Computadores				#
#	Docente: Luciano Lores Caimi					#
#	Discentes: João Vitor Gomes da Silva e Valéria Faccin		#
#########################################################################

		.data
		#estatisticas

head:		.word 0
maior:		.space 4
menor:		.space 4

		#inputs simples para o usuario
txt_inserido:	.string "foi inserido no índice: "
txt_qtd_ins:	.string " número(s) inserido(s)\n"
txt_removido:	.string "foi removido\n"
txt_input:	.string "\nDigite um número\n"
n_implementado:	.string "\nEsta operação não foi implementada\n"
txt_invalido:	.string "\n***DIGITE UMA OPÇÃO VÁLIDA***\n"

		#print do menu
menu:		.ascii "\n*** MENU ***\n\n"
op1:		.ascii "1 - Inserir\n"
op2:		.ascii "2 - Remover por indice\n"
op3:		.ascii "3 - Remover por valor\n"
op4:		.ascii "4 - Imprimir lista\n"
op5:		.ascii "5 - Estatísticas\n"
op6:		.asciz  "6 - Sair\n"

		.text
main:
	li s2, 0		# Inicia o registrador de controle da quantidade de inserções
	li s3, 0		# Inicia o registrador de controle da quantidade de remoções
	
loop_menu:
	li a7, 4 		# Comando para PrintString
	la a0, menu		# Carrega o menu para ser printado
	ecall			# Chama o OS
	li a7, 5		# Comando para ReadInt
	ecall			# Chama o OS
	li t0, 6
	beq t0, a0, fim		# Se opção = 6 encerra 
	li t0, 1		# Insere inteiro
	beq t0, a0, trata_insere 
	li t0, 2		# Remover por índece
	beq t0, a0, trata_removeI
	li t0, 3		# Remover por valor
	beq t0, a0, trata_removeV
	li t0, 4		# Imprimir lista
	beq t0, a0, trata_print
	li t0, 5		# Estatísticas
	beq t0, a0, trata_estatistica

invalido:
	la a0 txt_invalido	# Salva a mensagem "inválida" para retorno
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
	ecall
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
# Função: int insere_inteiro(int *head, int valor)		#
#   Adiciona o inteiro no final da lista			#
#   e atualiza a estatística numeros inseridos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o indice inserido				#
#################################################################

insere_inteiro:
	mv t2, zero		# Indice, i = 0
	lw t0, 0(a0)		# Salva em t0 o valor do endereço de a0
	mv t1, a0		# Move o valor para t1
	beqz t0, insere		# Se t0 for 0, vai para insere
	lw t3, (t0)
	bge t3, a1, insere
	
procura_fim:
	addi t2, t2, 1		# Incrementa o índice i ++
	addi t1, t0, 4 		# ponteiro para o proximo t1 = temp->next
	lw t0, 4(t0)		# Passa para a proxima posição t0 = temp->next->next
	
	beqz t0, insere		# Ou até achar o fim
	lw t3, (t0)		# Pega o valor do proximo elemento t3
	bge a1, t3, procura_fim # Vai procurar até achar alguém maior 
	 
insere:
	li a7, 9 		# Codigo para alocar memória
	li a0, 8 		# Aloca 8 bytes de memória
	ecall 		
	sw t0, 4(a0)		# novo->next = temp->next
	sw a1, 0(a0) 		# Salva o valor no novo nó
	sw a0, 0(t1) 		# temp->next = novo
	
	mv a0, t2		# Move o índice para o print e para o retorno da função
	addi s2, s2, 1		# Contador de números inseridos
	ret			# retorna da função

#################################################################
# função: int remove_por_indice(int *head, int indice);  	#
#   remove um elemento da lista pelo indice			#
#   e atualiza a estatística numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o valor removido ou exceção			#
#################################################################

remove_por_indice:
	la a0, txt_removido
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	ret
	
#################################################################
# função: int remove_por_valor(int *head, int valor)		#
#   remove um elemento da lista pelo valor			#
#   e atualiza a estatística numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o indice do removido ou exceção		#
#################################################################

remove_por_valor:
	la a0, n_implementado
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	ret
	
#################################################################
# função: void imprime_lista(int *head)				#
#   Imprime a lista						#
# entrada: a0 - ponteiro head					#
#################################################################

imprime_lista:
	la a0, n_implementado
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	ret
	
#################################################################
# função: void estatistica()					#
#   Exibe as estatísticas, maior número, menor número,		#
#   quantidade de elementos, quantidade inserida e removida	#
#################################################################

estatistica:
	la a0, n_implementado
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	ret
	
#################################################################
# função: retorna parâmetros					#
#   Retorna os parâmetros para as funções principais		#
#   1 função - Carrega um int em a1,				#
#   2 função - Carrega o ponteiro head em a0			#
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

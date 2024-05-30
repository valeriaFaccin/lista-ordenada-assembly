#########################################################################
#	Universidade Federal da Fronteira Sul - Campus Chapecó, SC	#
#		Ciências da Computação					#
#	Disciplina: Organização de Computadores				#
#	Docente: Luciano Lores Caimi					#
#	Discentes: João Vitor Gomes da Silva e Valéria Faccin		#
#########################################################################

		.data
		#estatisticas
qtd_inserido:	.word 0
qtd_removido:	.word 0
head:		.word 0
maior:		.space 4
menor:		.space 4
funcoes:	.space 20

		#inputs simples para o usuario
txt_inserido:	.string "foi inserido\n"
txt_removido:	.string "foi removido\n"
txt_input:	.string "\nDigite um número\n"
n_implementado:	.string "\nEsta operação não foi implementada\n"
txt_invalido:	.string "\n***DIGITE UMA OPÇÃO VÁLIDA***\n"

		#print do menu
menu:		.ascii "*** MENU ***\n\n"
op1:		.ascii "1 - Inserir\n"
op2:		.ascii "2 - Remover por indice\n"
op3:		.ascii "3 - Remover por valor\n"
op4:		.ascii "4 - Imprimir lista\n"
op5:		.ascii "5 - Estatísticas\n"
op6:		.asciz "6 - Sair\n"

		.text
main:
	li s0, 0		# Inicia o registrador de controle das opções menores inválidas 
	li s1, 6		# Inicia o registrador de controle das opções maiores inválidas 
	la t0, funcoes		# Carrega o vetor de funções
	la t1, insere_inteiro	# Endereço da função de inserir	
	sw t1, 0(t0)		# Adiciona a função no vetor v[0]
	la t1, remove_por_indice 
	sw t1, 4(t0)		# Adiciona a função no vetor v[1]
	la t1, remove_por_valor # Endereço da função de remover por valor	
	sw t1, 8(t0) 		# Adiciona a função no vetor v[2]
	la t1, imprime_lista	
	sw t1, 12(t0)		# Adiciona a função no vetor v[3]
	la t1, estatistica	
	sw t1, 16(t0)		# Adiciona a função no vetor v[4]
	li a7, 4 		# Comando para PrintString
	
loop_menu:
	la a0, menu		# Carrega o menu para ser printado
	ecall			# Chama o OS
	li a7, 5		# Comando para ReadInt
	ecall			# Chama o OS
	beq a0, s1, fim		# Se opção = 6 encerra 
	blt s1, a0, invalido	# Se opção > 6 é inválida 
	bge s0, a0, invalido	# Se 0 >= opção é inválida
	mv t2, a0		# Coloca opções em uma var temporaria para calculo de indice
	addi t2, t2, -1		# Tira um para trabalhar com 0 até 4
	la t0, funcoes		# Carrega o vetor de funções temporiamente
	slli t2, t2, 2		# Multiplica o indice por 4
	add t0, t0, t2		# Faz o deslocamento v[i]
	li t1, 3		# Carrega 3 para comparar as opções inserir e remover
	ble a0, t1, ins_rmv	# Se opções <= 3 a função recebe a1 e a0
	li t1, 4		# Carrega 4 para comparar função estatística
	beq a0, t1, load_head	# Se opções = 4 a função recebe a0
	j chama_func		# se opções = 5 a função não recebe parâmetro 

invalido:
	la a0 txt_invalido	# Salva a mensagem "inválida" para retorno
	j volta_loop		# Vai para o label printar a mensagem e voltar para o loop
	
ins_rmv:
	li a7, 4		# Comando para PrintString
	la a0, txt_input	# Coloca a mensagem de input para ser exibida
	ecall			# Chama OS para exibir
	li a7, 5		# Comando para ReadInt
	ecall			# Chama OS
	mv a1, a0		# Move o valor para a1
	
load_head:
	la a0, head		# Carrega o head em a0
	
chama_func:
	lw t1, 0(t0)		# Carrega o função
	jalr t1			# Chama a função
	
volta_loop:
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
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
# saida: retorna o inteiro inserido				#
#################################################################

insere_inteiro:
	la a0, txt_inserido
	ret

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
	ret
	
#################################################################
# função: void imprime_lista(int *head)				#
#   Imprime a lista						#
# entrada: a0 - ponteiro head					#
#################################################################

imprime_lista:
	la a0, n_implementado
	ret
	
#################################################################
# função: void estatistica()					#
#   Exibe as estatísticas, maior número, menor número,		#
#   quantidade de elementos, quantidade inserida e removida	#
#################################################################

estatistica:
	la a0, n_implementado
	ret
	
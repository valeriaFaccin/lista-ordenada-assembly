#########################################################################
#	Universidade Federal da Fronteira Sul - Campus Chapecó, SC	#
#		Ciências da Computação					#
#	Disciplina: Organização de Computadores				#
#	Docente: Luciano Lores Caimi					#
#	Discentes: João Vitor Gomes da Silva e Valéria Faccin		#
#########################################################################

		.data
head:		.word 0

		#inputs simples para o usuario
txt_inserido:	.string "foi inserido no índice: "
txt_removido:	.string "foi removido\n"
txt_input:		.string "\nDigite um número\n"
txt_imprimir:	.string	"\nElementos da Lista\n"
n_implementado:	.string "\nEsta operação não foi implementada\n"
sem_elementos:	.string	"\nNão há elementos na lista\n"
separador:		.string " | "
txt_maior: 		.string "\nMaior elemento da Lista: "
txt_menor:		.string "\nMenor elemento da Lista: "
txt_qtd_ins:	.string "\nNúmero(s) inserido(s): "
txt_qtd_remv:	.string "\nNúmero(s) removido(s): "
txt_list_vazia:	.string	"\nLista Vazia!"
qtd_total:		.string "\nQuantidade de elementos na Lista: "
txt_invalido:	.string "\n***DIGITE UMA OPÇÃO VÁLIDA***\n"
txt_erro_in:	.string "Não foi posssível inserir na lista"
txt_erro_remv:	.string	"Não foi possível remover na lista\n"

		#print do menu
menu:		.ascii "\n*** MENU ***\n\n"
op1:		.ascii "1 - Inserir\n"
op2:		.ascii "2 - Remover por indice\n"
op3:		.ascii "3 - Remover por valor\n"
op4:		.ascii "4 - Imprimir lista\n"
op5:		.ascii "5 - Estatísticas\n"
op6:		.asciz "6 - Sair\n"

		.text
main:
	li s0, 0		# Inicia o registrador de controle do maior número
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
	la a0,txt_invalido	# Salva a mensagem "inválida" para retorno
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
	j loop_menu		# Volta para o loop
	
trata_removeV:
	jal input_a1a0
	jal remove_por_valor
	j loop_menu		# Volta para o loop
	
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
	beqz t0, att_maior	# Se t0 for 0, vai para insere
	lw t3, (t0)
	bge t3, a1, insere
	
procura_fim:
	addi t2, t2, 1		# Incrementa o índice i ++
	addi t1, t0, 4 		# ponteiro para o proximo t1 = temp->next
	lw t0, 4(t0)		# Passa para a proxima posição t0 = temp->next->next
	
	beqz t0, att_maior	# Ou até achar o fim
	lw t3, (t0)		# Pega o valor do proximo elemento t3
	bge a1, t3, procura_fim # Vai procurar até achar alguém maior 

att_maior:
	mv s0, a1
	
insere:
	li a7, 9 		# Codigo para alocar memória
	li a0, 8 		# Aloca 8 bytes de memória
	ecall 	
	li t3, -1 		# se skrb retornar -1 não dá para alocar mémoria
	beq t0, t3, erro_insere	 
	sw t0, 4(a0)		# novo->next = temp->next
	sw a1, 0(a0) 		# Salva o valor no novo nó
	sw a0, 0(t1) 		# temp->next = novo
	addi s2, s2, 1		# Contador de números inseridos
	mv a0, t2		# Move o índice para o print e para o retorno da função
	ret			# retorna da função
	
erro_insere:
	li a0, -1		#indice -1 se for erro
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
	#mv t0, a0			# Salva em t0 o valor de a0, temp = head
	bltz a1, erro			# Se a1 < 0, indice menor que a lista
	sub t0, s2, s3			# Quantidade de elementos na lista
	bge a1, t0, erro		# Se a1 >= n, indice maior que a lista
	
	addi t1, a0, -4
	addi t3, zero, 0		# inicia o contador de índices
	
procura_indice:
	beq t3, a1, remover_indice	# i == valor
	lw t1, 4(t1)			# prev = prev->next
	addi t3, t3, 1			# incrementa o contador do índice
	j procura_indice		# retorna para procura_indice, para nova iteração na lista

erro:
        li a0, -1
        li a1, -1
        ret

remover_indice:
	lw t1, 4(t0)	# removido = prev->next
	sw a1, 0(t0	# a1 = removido->valor
	mv t2, ra	# salva o retorno
	jal remove_item			# chama a função geral de remoção
	jr t2
	
#################################################################
# função: int remove_por_valor(int *head, int valor)		#
#   remove um elemento da lista pelo valor			#
#   e atualiza a estatística numeros removidos			#
# entrada: a0 - ponteiro head					#
#	   a1 - valor						#
# saida: retorna o indice do removido ou exceção		#
#################################################################

remove_por_valor:
	mv t0, a0			# Salva em t0 o valor de a0, temp = head
	mv t1, t0			# Salva em t1 o valor de t0, prev = temp
	lw t0, 0(t0)			# Salva em t0 o valor em t0
	beqz t0, lista_vazia		# Verifica se a lista está vazia
	
	lw t2, (t0)			# Salva em t2 o valor de t1
	beq t1, a1, remover_valor	# Verifica se o valor em t2 é igual ao valor do elemento a ser removido

procura_valor:
	mv t1, t0			# prev = temp
	lw t0, 4(t0)			# temp = temp->next
	beqz t0, att_maior_Rmv_valor	# Não encontrou o valor
	
	lw t2, 0(t0)			# temp = temp->valor
	beq t2, a1, remover_valor	# temp->valor == valor
	j procura_valor

att_maior_Rmv_valor:
	lw s0, 0(t1)			# atualiza o valor do maior elemento no registrador s0
	j fim_remv_por_valor

lista_vazia:
        la a0, sem_elementos  
        li a7, 4              		# Comando para PrintString
        ecall				# Chama OS
        j fim_remv_por_valor

remover_valor:
	jal remove_item			# chama a função geral de remoção

fim_remv_por_valor:
	ret
	
#################################################################
# função: void imprime_lista(int *head)				#
#   Imprime a lista						#
# entrada: a0 - ponteiro head					#
#################################################################

imprime_lista:
	mv t2, a0			# Salva o valor de a0 (head) em t2	
	la a0, txt_imprimir  
        li a7, 4              		# Comando para PrintString
        ecall				# Chama OS
	
	lw t0, 0(t2)			# Salva em t0 o valor de t2
	beqz t0, nenhum_elemento	# Vai para label se t0 = 0, ou seja, não há elementos na lista

imprimir:
        lw a0, 0(t0)			# Salva em a0 o valor em t0
        li a7, 1             		# Comando para PrintInteger
        ecall				# Chama OS

        lw t0, 4(t0)          		# Salva em t0 o próximo endereço da lista
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
# função: void estatistica()					#
#   Exibe as estatísticas, maior número, menor número,		#
#   quantidade de elementos, quantidade inserida e removida	#				
#################################################################

estatistica:
	la a0, head
	lw t0, 0(a0)		# Salva em t0 o endereço de a0 (head)
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
# função: retorna parâmetros									#
#   Retorna os parâmetros para as funções principais			#
#   1 função - Carrega um int em a1,							#
#   2 função - Carrega o ponteiro head em a0					#
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
# função: remoção geral de elementos 				#
#   								#
################################################################# 

remove_item:
	lw t0, 4(t0)       	# temp = removido->next
  	sw t0, 4(t1)           	# prev->next = removido->next
  	addi s3, s3, 1  	# incrementa o registrador do número de remoções              
	li a0, 1		# retorno de sucesso
	bnez t0, fim_remv	# if(removido-> next != null) return 1
	lw s0, 0(t1)		# else atualizaMaior()
fim_remv:
	ret
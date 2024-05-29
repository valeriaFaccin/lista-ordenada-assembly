#	Universidade Federal da Fronteira Sul - Campus Chapec�, SC
#		Ci�ncias da Computa��o
#	Disciplina: Organiza��o de Computadores
#	Docente: Luciano Lores Caimi
#	Discentes: Jo�o Vitor Gomes da Silva e Val�ria Faccin

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
txt_input:	.string "Digite um n�mero\n"
n_implementado:	.string "\nEsta opera��o n�o foi implementada\n"
txt_invalido:	.string "\n***DIGITE UMA OP��O V�LIDA***\n"

		#print do menu
menu:		.ascii "*** MENU ***\n\n"
op1:		.ascii "1 - Inserir\n"
op2:		.ascii "2 - Remover por indice\n"
op3:		.ascii "3 - Remover por valor\n"
op4:		.ascii "4 - Imprimir lista\n"
op5:		.ascii "5 - Estat�sticas\n"
op6:		.asciz "6 - Sair\n"

		.text
main:
	li s0, 0		# Inicia o registrador de controle das op��es menores inv�lidas 
	li s1, 6		# Inicia o registrador de controle das op��es maiores inv�lidas 
	la t0, funcoes		# Carrega o vetor de fun��es
	la t1, insere_inteiro	# Endere�o da fun��o de inserir	
	sw t1, 0(t0)		# Adiciona a fun��o no vetor v[0]
	la t1, remove_por_indice 
	sw t1, 4(t0)		# Adiciona a fun��o no vetor v[1]
	la t1, remove_por_valor # Endere�o da fun��o de remover por valor	
	sw t1, 8(t0) 		# Adiciona a fun��o no vetor v[2]
	la t1, imprime_lista	
	sw t1, 12(t0)		# Adiciona a fun��o no vetor v[3]
	la t1, estatistica	
	sw t1, 16(t0)		# Adiciona a fun��o no vetor v[4]
	li a7, 4 		# Comando para PrintString
	
loop_menu:
	la a0, menu		# Carrega o menu para ser printado
	ecall			# Chama o OS
	li a7, 5		# Comando para ReadInt
	ecall			# Chama o OS
	beq a0, s1, fim		# Se op��o = 6 encerra 
	blt s1, a0, invalido	# Se op��o > 6 � inv�lida 
	bge s0, a0, invalido	# Se 0 >= op��o � inv�lida
	addi a0, a0, -1		# Tira um para trabalhar com 0 at� 4
	la t0, funcoes		# Carrega o vetor de fun��es temporiamente
	slli a0, a0, 2		# Multiplica o indice por 4
	add t0, t0, a0		# Faz o deslocamento v[i]
	la a0, head		# Coloca o ponteiro para in�cio da lista em a0
	lw t1, 0(t0)		# Carrega o fun��o
	jalr t1			# Chama a fun��o
	j volta_loop		# Vai para o print do retorno da fun��o
	
invalido:
	la a0 txt_invalido	# Salva a mensagem "inv�lida" para retorno

volta_loop:
	li a7, 4		# Comando para PrintString
	ecall			# Chama OS
	j loop_menu		# Volta para o loop

fim:
	li a0, 0		# Coloca 0 no retorno do programa
	li a7, 93		# Comando para encerrar programa
	ecall			# Chama OS
		
insere_inteiro:
	la a0, txt_inserido
	ret
remove_por_indice:
	la a0, txt_removido
	ret
remove_por_valor:
	la a0, n_implementado
	ret
imprime_lista:
	la a0, n_implementado
	ret
estatistica:
	la a0, n_implementado
	ret
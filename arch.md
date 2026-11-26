vlista: encadeada
vfila: FIFO
vpilha: LIFO

Telemetria():
	prox: inteiro

## dados
modificar_dados:
	mostra_todos_talhoe_existentes
	pede o id, e modifica os dados.

## lista encadeada
reiniciar_estruturas():
	inicio_lista <- NULO
    topo <- 1
    final <- 0
    topo_pilha <- 0

esta_ativo:
	percorre todos os elementos ate achar um que tenha o mesmo id, retorna verdadeiro, caso ache.

inserir_na_lista:
	encontra atual conexão e insere
	[x] -> [y] -> ... [z]
	               ^
remover_da_lista:
	encontra atual e anterior
	se atual = id entao
      se ant = NULO entao
         inicio_lista <- vlista[id].prox
      senao
         vlista[ant].prox <- vlista[id].prox
      fimse
      vlista[id].prox <- NULO
   fimse

desativar_pivo():
	pega o id
	se o pivo esta ativo: remover_da_lista(talhao)

reativar_pivo():
	pega o id
	se o pivo estiver deativo: inserir_na_lista(talhao)

exibir_lista():
	se inicio_lista for nulo, o lista esta vazia.
	caso contrario:
		itera sobre os talhoes e mostra seus dados.

cadastrar_talhoes():
	reiniciar_estruturas()
	vlista[x] <- dados
	inserir_na_lista()

## fila telemetria
drone_coletar():
	itera sob a lista encadeada de telhoes
	para cada talhao adiciona dados na pilha e.g. classificar

exibir_fila():
	itera do topo da fila ate ate seu fim:
		mostra seus respectivos dados

# pilha emergencial

empilhar_emergencias:
	itera sob todos elementos da lista:
	 - adiciona a pilha caso o status seja de emergencia e umidade abaixo de 25%

processar_fila():
	enquanto o topo da pilha não ter chegado a seu final se itera
	e acrescentado ao contador do topo

	topo <- 1  // topo fila
    final <- 0

    empilhar_emergencias()

exibir_pilha():
	itera inversamente do topo ate 1
	mostra seus respectivos dados


## utilitarios

inicializa():
regitra_quantidade_talhoes():

sistema_loop():
	exibir_menu
	leia(resp)
	processa_resposta()
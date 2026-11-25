Algoritmo "Projeto_Final_TED_UNIPAC"
// Tema 10 - Agronegocio: Telemetria de Drones e Irrigacao
//
// Fluxo geral:
//   vlista  : pool fixo de talhoes (indice = idTalhao). Os campos "prox" encadeiam
//             apenas os talhoes ATIVOS (lista de irrigacao). Desativar um pivo
//             = retira-lo da cadeia, sem apagar o talhao do vetor.
//   Drone   : percorre a cadeia (pula os desativados) e enfileira um pacote
//             de telemetria por talhao em vfila (FIFO).
//   Fila    : processada em ordem de chegada; define o status de cada talhao.
//   vpilha  : pilha LIFO de emergencia (talhoes ativos com umidade < 25,0%).

Tipo
   Telemetria = registro
      idTalhao : inteiro
      cultura : caractere
      umidadePct : real
      volAgua : real
      statusManejo : caractere   // "E" = emergencia | "N" = normal
      prox : inteiro             // indice do proximo talhao ativo (NULO = fim)
   Fimregistro

Var
   vpilha, vlista, vfila : vetor [1..15] de Telemetria

   MAX, NULO : inteiro          // constantes (VisuAlg nao tem const)
   LIMITE : real
   qtde, fim, resp : inteiro
   topo, final : inteiro        // controle da fila FIFO
   topoPilha : inteiro          // controle da pilha LIFO
   inicioLista : inteiro        // cabeca da lista de irrigacao ativa
   cadastrado : logico

// ---------------------------------------------------------------
// UTILITARIOS
// ---------------------------------------------------------------
funcao classificar(u : real) : caractere
inicio
   se u < LIMITE entao
      retorne "E"
   senao
      retorne "N"
   fimse
fimfuncao

procedimento reiniciarEstruturas
inicio
   inicioLista <- NULO
   topo <- 1
   final <- 0
   topoPilha <- 0
fimprocedimento

procedimento exibirMenu
inicio
   Escreval("===== MENU =====")
   Escreval("1: Insercao dos talhoes")
   Escreval("2: Modificacao dos dados")
   Escreval("3: Desativar pivo (remove da lista de irrigacao)")
   Escreval("4: Reativar pivo")
   Escreval("5: Visualizacao da lista de irrigacao ativa")
   Escreval("6: Drone coleta telemetria (enfileira)")
   Escreval("7: Processar fila de telemetria")
   Escreval("8: Visualizacao da fila de telemetria")
   Escreval("9: Visualizacao da pilha de emergencia")
   Escreval("0: Sair")
fimprocedimento

procedimento lerQuantidade
inicio
   // DEFINICAO DA QUANTIDADE DE TALHOES
   repita
      Escreval("Qual a quantidade de talhoes?")
      Escreval("Valor maximo: 15")
      Leia(qtde)

      se (qtde > 15) ou (qtde <= 0) entao
         Escreval("Quantidade invalida!")
      fimse
   ate (qtde <= 15) e (qtde > 0)
fimprocedimento

// ---------------------------------------------------------------
// LISTA ENCADEADA DE IRRIGACAO (usa o campo prox)
// ---------------------------------------------------------------
funcao estaAtivo(id : inteiro) : logico
var atual : inteiro
inicio
   atual <- inicioLista
   enquanto (atual <> NULO) e (atual <> id) faca
      atual <- vlista[atual].prox
   fimenquanto
   retorne (atual = id)
fimfuncao

// Insere mantendo a cadeia ordenada por idTalhao
procedimento inserirNaLista(id : inteiro)
var ant, atual : inteiro
inicio
   ant <- NULO
   atual <- inicioLista
   enquanto (atual <> NULO) e (atual < id) faca
      ant <- atual
      atual <- vlista[atual].prox
   fimenquanto

   se atual <> id entao
      vlista[id].prox <- atual
      se ant = NULO entao
         inicioLista <- id
      senao
         vlista[ant].prox <- id
      fimse
   fimse
fimprocedimento

// Remove qualquer no (inicio, meio ou fim)
procedimento removerDaLista(id : inteiro)
var ant, atual : inteiro
inicio
   ant <- NULO
   atual <- inicioLista
   enquanto (atual <> NULO) e (atual <> id) faca
      ant <- atual
      atual <- vlista[atual].prox
   fimenquanto

   se atual = id entao
      se ant = NULO entao
         inicioLista <- vlista[id].prox
      senao
         vlista[ant].prox <- vlista[id].prox
      fimse
      vlista[id].prox <- NULO
   fimse
fimprocedimento

procedimento exibirLista
var x : inteiro
inicio
   Escreval("===== LISTA DE IRRIGACAO ATIVA =====")
   se inicioLista = NULO entao
      Escreval("Nenhuma zona de irrigacao ativa!")
   senao
      x <- inicioLista
      enquanto x <> NULO faca
         Escreval("Talhao: ", vlista[x].idTalhao, " | Cultura: ", vlista[x].cultura)
         Escreval("Umidade: ", vlista[x].umidadePct, "% | Volume de agua: ", vlista[x].volAgua, " litros | Status: ", vlista[x].statusManejo)
         Escreval("----------------------")
         x <- vlista[x].prox
      fimenquanto
   fimse
fimprocedimento

// ---------------------------------------------------------------
// CADASTRO E MODIFICACAO DOS TALHOES
// ---------------------------------------------------------------
procedimento cadastrarTalhoes
var x : inteiro
inicio
   reiniciarEstruturas

   para x de 1 ate qtde faca

      Escreval("Identificacao do talhao: ", x)
      vlista[x].idTalhao <- x

      Escreval("Informe a cultura")
      Leia(vlista[x].cultura)

      Escreval("Informe a umidade do solo (%)")
      Leia(vlista[x].umidadePct)

      Escreval("Informe o volume de agua (litros)")
      Leia(vlista[x].volAgua)

      // DEFINICAO DO STATUS DE MANEJO
      vlista[x].statusManejo <- classificar(vlista[x].umidadePct)

      // TODO TALHAO CADASTRADO ENTRA ATIVO NA LISTA DE IRRIGACAO
      vlista[x].prox <- NULO
      inserirNaLista(x)
   fimpara

   cadastrado <- verdadeiro
   Escreval("Cadastro concluido!")
fimprocedimento

procedimento modificarDados
var x, talhao : inteiro
    novaUmidade, novoVolume : real
inicio
   para x de 1 ate qtde faca
      Escreval("Talhao: ", vlista[x].idTalhao)
      Escreval("Umidade: ", vlista[x].umidadePct, "%")
      Escreval("Volume de agua: ", vlista[x].volAgua, " litros")
   fimpara

   Escreval("Qual talhao deseja modificar?")
   Leia(talhao)

   se (talhao >= 1) e (talhao <= qtde) entao
      Escreval("Nova umidade do solo (%)")
      Leia(novaUmidade)

      Escreval("Novo volume de agua (litros)")
      Leia(novoVolume)

      // ATUALIZACAO DO CADASTRO PRINCIPAL
      vlista[talhao].umidadePct <- novaUmidade
      vlista[talhao].volAgua <- novoVolume
      vlista[talhao].statusManejo <- classificar(novaUmidade)

      // A pilha so e atualizada quando a fila for processada (opcao 7)
      Escreval("Modificacao realizada com sucesso!")
   senao
      Escreval("Talhao inexistente!")
   fimse
fimprocedimento

procedimento desativarPivo
var talhao : inteiro
inicio
   Escreval("Qual pivo (talhao) deseja desativar?")
   Leia(talhao)

   se (talhao >= 1) e (talhao <= qtde) entao
      se estaAtivo(talhao) entao
         removerDaLista(talhao)
         Escreval("Pivo do talhao ", talhao, " desativado!")
      senao
         Escreval("Este pivo ja esta desativado!")
      fimse
   senao
      Escreval("Talhao inexistente!")
   fimse
fimprocedimento

procedimento reativarPivo
var talhao : inteiro
inicio
   Escreval("Qual pivo (talhao) deseja reativar?")
   Leia(talhao)

   se (talhao >= 1) e (talhao <= qtde) entao
      se estaAtivo(talhao) entao
         Escreval("Este pivo ja esta ativo!")
      senao
         inserirNaLista(talhao)
         Escreval("Pivo do talhao ", talhao, " reativado!")
      fimse
   senao
      Escreval("Talhao inexistente!")
   fimse
fimprocedimento

// ---------------------------------------------------------------
// DRONE + FILA FIFO DE TELEMETRIA
// ---------------------------------------------------------------
procedimento droneColetar
var emTalhao : inteiro     // posicao atual do drone
inicio
   // O drone segue a cadeia de ativos: talhoes desativados sao pulados
   emTalhao <- inicioLista
   enquanto emTalhao <> NULO faca
      se final < MAX entao
         // ENFILEIRA O PACOTE DE TELEMETRIA (final da fila)
         final <- final + 1
         vfila[final] <- vlista[emTalhao]
         vfila[final].prox <- NULO
         vfila[final].statusManejo <- classificar(vlista[emTalhao].umidadePct)
      senao
         Escreval("Fila cheia! Processe a fila (opcao 7).")
      fimse
      emTalhao <- vlista[emTalhao].prox
   fimenquanto
   Escreval("Coleta do drone concluida!")
fimprocedimento

procedimento exibirFila
var x : inteiro
inicio
   Escreval("===== FILA DE TELEMETRIA =====")

   se final < topo entao
      Escreval("Fila vazia!")
   senao
      para x de topo ate final faca
         Escreval("Posicao na fila: ", x)
         Escreval("Talhao: ", vfila[x].idTalhao)
         Escreval("Umidade: ", vfila[x].umidadePct, "%")
         Escreval("Volume de agua: ", vfila[x].volAgua, " litros")
         Escreval("Status: ", vfila[x].statusManejo)
         Escreval("----------------------")
      fimpara
   fimse
fimprocedimento

// ---------------------------------------------------------------
// PILHA LIFO DE EMERGENCIA
// ---------------------------------------------------------------
// Empilhamento automatico dos talhoes ATIVOS com umidade < 25%
// (reconstroi a pilha a cada processamento, evitando duplicatas)
procedimento empilharEmergencias
var j : inteiro
inicio
   topoPilha <- 0
   j <- inicioLista
   enquanto j <> NULO faca
      se (vlista[j].idTalhao <> 0) e (vlista[j].statusManejo = "E") e (vlista[j].umidadePct < LIMITE) entao
         se (topoPilha < MAX) entao
            topoPilha <- topoPilha + 1
            vpilha[topoPilha] <- vlista[j]
         fimse
      fimse
      j <- vlista[j].prox
   fimenquanto
fimprocedimento

// Desenfileira todos os pacotes (FIFO), atualiza o status e monta a pilha
procedimento processarFila
var id : inteiro
inicio
   se final < topo entao
      Escreval("Fila vazia! Nada a processar.")
   senao
      enquanto topo <= final faca
         id <- vfila[topo].idTalhao
         vlista[id].statusManejo <- vfila[topo].statusManejo
         topo <- topo + 1
      fimenquanto

      // fila esvaziada: reinicia os indices
      topo <- 1
      final <- 0

      empilharEmergencias
      Escreval("Fila processada!")
   fimse
fimprocedimento

procedimento exibirPilha
var i : inteiro
inicio
   // CONTROLE DE EMERGENCIA - PILHA LIFO
   Escreval("===== PILHA DE EMERGENCIA HIDRICA =====")
   se (topoPilha = 0) entao
      Escreval("Nenhum talhao na pilha de emergencia.")
   senao
      para i de topoPilha ate 1 passo -1 faca
         Escreval("[Pos ", i, "] ID Talhao: ", vpilha[i].idTalhao, " | Umidade: ", vpilha[i].umidadePct:4:1, "% | Vol: ", vpilha[i].volAgua:6:1, "L | Status: ", vpilha[i].statusManejo)
      fimpara
   fimse
fimprocedimento

// ---------------------------------------------------------------
// PROGRAMA PRINCIPAL
// ---------------------------------------------------------------
Inicio

   MAX <- 15
   NULO <- 0
   LIMITE <- 25.0
   fim <- 0
   cadastrado <- falso
   reiniciarEstruturas

   lerQuantidade

   // MENU PRINCIPAL
   enquanto fim = 0 faca

      exibirMenu
      Leia(resp)

      se (resp >= 2) e (resp <= 9) e (nao cadastrado) entao
         Escreval("Cadastre os talhoes primeiro (opcao 1)!")
      senao
         escolha resp
            caso 1
               cadastrarTalhoes
            caso 2
               modificarDados
            caso 3
               desativarPivo
            caso 4
               reativarPivo
            caso 5
               exibirLista
            caso 6
               droneColetar
            caso 7
               processarFila
            caso 8
               exibirFila
            caso 9
               exibirPilha
            caso 0
               // SAIDA DO SISTEMA
               fim <- 1
               Escreval("Sistema encerrado!")
            outrocaso
               Escreval("Opcao invalida!")
         fimescolha
      fimse
   fimenquanto

Fimalgoritmo

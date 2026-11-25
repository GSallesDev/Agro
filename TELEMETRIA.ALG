algoritmo "telemetria"
// Autores:
//   - May
//   - Bernado
//   - Matheus S.
//   - Gustavo Salles
// Data atual  : 25/11/2026


// Convensao status E/N - Matheus S.

tipo
    // Matheus S.
    Telemetria = registro
        idTalhao : inteiro
        cultura : caractere
        umidadePct : real
        volAgua : real
        statusManejo : caractere   // "E" = emergencia | "N" = normal
        prox : inteiro
    fimregistro

var
    DEPURAR: logico
    MAX, NULO : inteiro
    LIMITE : real

    // NOTA: o visualg requer que os vetores tenham um tamanho fixo.
    // então coloquei MAX = 15, sei lá, se precisar pode aumentar
    // mas tem que atualizar a variavel MAX, de acordo.
    vpilha, vlista, vfila : vetor[1..15] de Telemetria

    FLAG_TALHOES_VARIAVEIS: logico
    FLAG_TALHOES_OUTRAS_INFORMACOES: logico

    deveria_terminar: logico
    cadastrado: logico

    qtde, resp: inteiro

    ACAO_INSERIR_TALHOES, ACAO_MODIFICAR_DADOS, ACAO_DESATIVAR_PIVOT, ACAO_REATIVAR_PIVOT, ACAO_VISUALIZAR_LISTA_IRRIGACAO_ATIVA, ACAO_COLETAR_TELEMETRIA, ACAO_PROCESSAR_TELEMETRIA, ACAO_VISUALIZAR_TELEMETRIA, ACAO_VISUALIZAR_PILHA_EMERGENCIA, ACAO_SAIR: inteiro

    topo, final : inteiro        // controle da fila FIFO
    topo_pilha : inteiro         // controle da pilha LIFO
    inicio_lista : inteiro       // cabeca da lista de irrigacao ativa

// Gustavo Salles
procedimento depurar_escreve(mensagem: caracter)
inicio
    se DEPURAR entao
        escreval(mensagem)
    fimse
fimprocedimento

// Gustavo Salles
// Matheus S.
procedimento reiniciar_estruturas()
inicio
    inicio_lista <- NULO
    topo <- 1
    final <- 0
    topo_pilha <- 0
    // depurar_escreve(" > reiniciar_estruturas()")
fimprocedimento

// Matheus S. (adaptado)
funcao classificar(u : real) : caractere
inicio
   se u < LIMITE entao
      retorne "E"
   senao
      retorne "N"
   fimse
fimfuncao

// ---------------------------------------------------------------
// TLDR; IDK, F This shit.

// Gustavo Salles
procedimento inicializa() 
inicio
    DEPURAR <- verdadeiro
    MAX <- 15
    NULO <- 0
    LIMITE <- 25.0

    FLAG_TALHOES_VARIAVEIS <- falso
    FLAG_TALHOES_OUTRAS_INFORMACOES <- verdadeiro

    deveria_terminar <- falso
    cadastrado <- falso

    reiniciar_estruturas()

    // NOTA: Acho que era 5 talhoes, mas vou deixar 3 talhoes como padrao
    // caso FLAG_TALHOES_VARIAVEIS esteja desativado, caso contrario o sistema
    // lerá normalmenete.
    qtde <- 3

    ACAO_INSERIR_TALHOES <- 1
    ACAO_MODIFICAR_DADOS <- 2
    ACAO_DESATIVAR_PIVOT <- 3
    ACAO_REATIVAR_PIVOT <- 4
    ACAO_VISUALIZAR_LISTA_IRRIGACAO_ATIVA <- 5
    ACAO_COLETAR_TELEMETRIA <- 6
    ACAO_PROCESSAR_TELEMETRIA <- 7
    ACAO_VISUALIZAR_TELEMETRIA <- 8
    ACAO_VISUALIZAR_PILHA_EMERGENCIA <- 9
    ACAO_SAIR <- 0

fimprocedimento

// Matheus S.
procedimento regitra_quantidade_talhoes()
inicio
    repita
        escreval("Qual a quantidade de talhoes?")
        escreval("Valor maximo: 15")
        leia(qtde)

        se (qtde > 15) ou (qtde <= 0) entao
            Escreval("ERROR: Quantidade invalida")
        fimse
    ate (qtde <= 15) e (qtde > 0)
fimprocedimento

// Bernado
// Matheus S.
// Gustavo Salles
// May
procedimento exibir_menu()
inicio
    // Matheus
    escreval(ACAO_INSERIR_TALHOES, ": Insercao dos talhoes")
    escreval(ACAO_MODIFICAR_DADOS, ": Modificacao dos dados")

    // Gustavo
    escreval(ACAO_DESATIVAR_PIVOT, ": Desativar pivo")
    escreval(ACAO_REATIVAR_PIVOT, ": Reativar pivo")
    // Lista de irrigação
    // A FAZER: Atualizar nomenclatura

    escreval(ACAO_VISUALIZAR_LISTA_IRRIGACAO_ATIVA, ": Visualizacao da lista de irrigacao ativa")
    escreval(ACAO_COLETAR_TELEMETRIA, ": Drone coleta telemetria") // Enfilerar

    escreval(ACAO_PROCESSAR_TELEMETRIA, ": Processar fila de telemetria")

    // Gustavo Salles (adaptado do codigo do Bernado)
    escreval(ACAO_VISUALIZAR_TELEMETRIA, ": Visualizacao da fila de telemetria")
    escreval(ACAO_VISUALIZAR_PILHA_EMERGENCIA, ": Visualizacao da pilha de emergencia")
    escreval(ACAO_SAIR, ": Sair")
fimprocedimento

// Gustavo Salles.
procedimento inserir_na_lista(id : inteiro)
    var ant, atual: inteiro
inicio
    ant <- NULO
    atual <- inicio_lista

    // Encontra (anterior e atual)
    enquanto (atual <> NULO) e (atual < id) faca
        ant <- atual
        atual <- vlista[atual].prox
    fimenquanto

    // Concatena (link de zelda para epona)
    se atual <> id entao
        vlista[id].prox <- atual
        se ant = NULO entao
            inicio_lista <- id

        senao
            vlista[ant].prox <- id
        fimse
    fimse

    // se DEPURAR entao
    //     atual <- inicio_lista
    //     enquanto (atual <> NULO) faca
    //         ant <- atual
    //         atual <- vlista[atual].prox
    //         escreval(ant, " -> ", atual)
    //     fimenquanto
    // fimse
    
fimprocedimento

// Matheus S.
procedimento cadastrar_talhoes()
var 
    x: inteiro
inicio
    reiniciar_estruturas()

    // A FAZER: Separa o codigo que se repete em procedimento a parte.
    para x de 1 ate qtde faca
        escreval(" > talhao", x)
        vlista[x].idTalhao <- x

        escreval("Informe a umidade do solo (%)")
        escreva(" < ")
        leia(vlista[x].umidadePct)

        se FLAG_TALHOES_OUTRAS_INFORMACOES entao
            escreval("Informe a cultura")
            escreva(" < ")
            leia(vlista[x].cultura)
 
            escreval("Informe o volume de agua L")
            escreva(" < ")
            leia(vlista[x].volAgua)
        fimse

        vlista[x].statusManejo <- classificar(vlista[x].umidadePct)

        vlista[x].prox <- NULO
        inserir_na_lista(x)
   fimpara

   cadastrado <- verdadeiro
   escreval(" > Cadastro concluido com sucesso.")
fimprocedimento

// Matheus S.
procedimento modificar_dados()
var 
    x, talhao: inteiro
    novaUmidade, novoVolume : real

inicio
    para x de 1 ate qtde faca
        escreval("< talhao: ", vlista[x].idTalhao)
        escreval("< umidade: ", vlista[x].umidadePct, "%")

        se FLAG_TALHOES_OUTRAS_INFORMACOES entao
            escreval("< volume de agua: ", vlista[x].volAgua, " litros")
        fimse
    fimpara

    escreva(" < modificar:")
    leia(talhao)

    se (talhao >= 1) e (talhao <= qtde) entao
        escreva(" < umidade do solo %")
        leia(novaUmidade)

        se FLAG_TALHOES_OUTRAS_INFORMACOES entao
            escreva(" < novo volume de agua L")
            leia(novoVolume)
        fimse

        vlista[talhao].umidadePct <- novaUmidade
        vlista[talhao].volAgua <- novoVolume
        vlista[talhao].statusManejo <- classificar(novaUmidade)

        // NOTA: A pilha ainda não é atualizada.
        escreval(" > modificacao realizada com sucesso.")
    senao
        escreval(" > talhao inexistente.")
    fimse
fimprocedimento

// Gustavo Salles
procedimento processa_resposta()
inicio
    se (resp <> ACAO_INSERIR_TALHOES) e (resp <> ACAO_SAIR) e (nao cadastrado) entao
        escreval(" > Cadastre os talhoes antes de proceguir com as operacoes.")
    senao
        // A FAZER: Fazer uma formatacao melhor do codigo
        escolha resp
            caso ACAO_INSERIR_TALHOES
               cadastrar_talhoes()

            caso ACAO_MODIFICAR_DADOS
               modificar_dados()

            caso ACAO_DESATIVAR_PIVOT
               // desativarPivo

            caso ACAO_REATIVAR_PIVOT
               // reativarPivo

            caso ACAO_VISUALIZAR_LISTA_IRRIGACAO_ATIVA
               // exibirLista

            caso ACAO_COLETAR_TELEMETRIA
               // droneColetar

            caso ACAO_PROCESSAR_TELEMETRIA
               // processarFila

            caso ACAO_VISUALIZAR_TELEMETRIA
               // exibirFila

            caso ACAO_VISUALIZAR_PILHA_EMERGENCIA
               // exibirPilha

            caso ACAO_SAIR
               deveria_terminar <- verdadeiro

            outrocaso
               escreval(" > ERRO: Opcao invalida.")
         fimescolha
      fimse
fimprocedimento

// Gustavo Salles
procedimento sistema_loop()
inicio
    repita
        exibir_menu()
        leia(resp)
        processa_resposta()
    ate deveria_terminar = verdadeiro
fimprocedimento

inicio
    inicializa()
    se FLAG_TALHOES_VARIAVEIS entao 
        regitra_quantidade_talhoes()
    fimse

    sistema_loop()
fimalgoritmo

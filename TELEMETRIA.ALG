algoritmo "telemetria"
// Autores:
//   - May
//   - Bernado
//   - Matheus S.
//   - Gustavo Salles
// Data atual  : 25/11/2026

var
   talhoes_variaveis: logico
   deveria_terminar: logico
   cadastrado: logico

   qtde, resp: inteiro

    ACAO_INSERIR_TALHOES, ACAO_MODIFICAR_DADOS, ACAO_DESATIVAR_PIVOT, ACAO_REATIVAR_PIVOT, ACAO_VISUALIZAR_LISTA_IRRIGACAO_ATIVA, ACAO_COLETAR_TELEMETRIA, ACAO_PROCESSAR_TELEMETRIA, ACAO_VISUALIZAR_TELEMETRIA, ACAO_VISUALIZAR_PILHA_EMERGENCIA, ACAO_SAIR: inteiro


// Gustavo Salles
procedimento inicializa() 
inicio
    talhoes_variaveis <- falso
    deveria_terminar <- falso
    cadastrado <- falso

    // NOTA: Acho que era 5 talhoes, mas vou deixar 3 talhoes como padrao
    // caso talhoes_variaveis esteja desativado, caso contrario o sistema
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

// Gustavo Salles
// Bernado
// Matheus S.
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

// Gustavo Salles
procedimento processa_resposta()
inicio
    se (resp <> ACAO_INSERIR_TALHOES) e (resp <> ACAO_SAIR) e (nao cadastrado) entao
        escreval(" > Cadastre os talhoes antes de proceguir com as operacoes.")
    senao
        // A FAZER: Fazer uma formatacao melhor do codigo
        escolha resp
            caso ACAO_INSERIR_TALHOES
               // cadastrarTalhoes

            caso ACAO_MODIFICAR_DADOS
               // modificarDados

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
    se talhoes_variaveis entao 
        regitra_quantidade_talhoes()
    fimse

    sistema_loop()
fimalgoritmo

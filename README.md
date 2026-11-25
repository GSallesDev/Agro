Usem as flags para controlar o comportamento do codigo:
FLAG_TALHOES_VARIAVEIS: o Matheus tinha implementado que os talhoes fossem variaveis, basta ativa-la para voltar este funcionamento.
FLAG_TALHOES_OUTRAS_INFORMACOES: Adiciona as outras informações que no codigo não usamos, como cultura, e volume d'agua.

A operação do sistema segue:
 * Insira os talhoes e suas respectivas informações
 * Coletar dados de telemetria
 * Processar a fila de telemetria

Você pode visualizar os dados nas funções de visualização
E pode Ativar/desativar ou modificar um talhão.

As reponsabilidades eram:
 - Registro/Menu
 - Lista
 A lista encadeada de cada talhao, caso desativo são pulados.

 - Fila
 Os drones percorrem a lista encadeada de talhoes, e preenchem a fila com a telemetria

 - Pilha
 A pilha de emergencia e criada com base nos dados da lista de telemetria:



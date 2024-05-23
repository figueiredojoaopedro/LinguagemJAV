import time
from functions.transacaoEscolhida import transacaoEscolhida
from functions.chegouCliente import chegouCliente
from Queue import Queue
from Guiche import Guiche


def main():
    expedientTotalTime = 6  # 6 hours
    realTimeElapsed = 120  # 2 minutes
    simulationTime = 0
    beginningTime = 10  # opens at 10 am
    equivalentToOneHour = int(realTimeElapsed / expedientTotalTime)

    guiches = Queue()
    # criação de 3 Guiches
    guiches.push(Guiche())
    guiches.push(Guiche())
    guiches.push(Guiche())

    filaDeClientes = Queue()
    maiorTempoDeTransacao = 0
    totalClientesAtendidos = 0
    totalOperacoesRealizadas = 0
    totalSaquesRealizados = 0
    totalDepositosRealizados = 0
    totalPagamentosRealizados = 0

    # Expediente:
    print("{}:00 Horas".format(beginningTime))
    while simulationTime < realTimeElapsed or filaDeClientes.lgt > 0:
        # Diz o tempo de simulação
        print("simulation time: {}".format(simulationTime))
        if ((simulationTime == 20
             or simulationTime == 40
             or simulationTime == 60
             or simulationTime == 80
             or simulationTime == 100
             or simulationTime == 120) and simulationTime % equivalentToOneHour == 0):
            beginningTime += 1  # add + 1 hour
            print("{}:00 Horas".format(beginningTime))

        # Cliente chega:
        if chegouCliente() == 0:
            # Cliente entra na fila
            filaDeClientes.pushEnd(simulationTime)
            cliente = filaDeClientes.getFirstNode()

            # Mostra a situação da fila:
            while cliente != None:
                print("cliente: {}".format(cliente.getData()))
                cliente = cliente.getNextNode()
            print("Comprimento da fila: {}".format(filaDeClientes.lgt))

        # Verifica se há guichê vazio
        print("\n")
        guiche = guiches.getFirstNode()
        while guiche != None:
            if guiche.getData().getTempoTransacao() == 0 and filaDeClientes.lgt > 0:  # se for false...
                # Guichê livre
                tempoTransacao = transacaoEscolhida()
                guiche.getData().setTempoTransacao(tempoTransacao)  # set ocupação true
                # Remove primeira posição da fila
                print("Cliente Atendido: {}".format(filaDeClientes.getFirstNode().getData()))
                filaDeClientes.popBegin()
                totalClientesAtendidos += 1
                totalOperacoesRealizadas += 1

                # Atualizar contagem de operações
                if tempoTransacao == 3:
                    totalSaquesRealizados += 1
                elif tempoTransacao == 6:
                    totalDepositosRealizados += 1
                elif tempoTransacao == 9:
                    totalPagamentosRealizados += 1

            print("Guichê Ocupação: {}".format(guiche.getData().getTempoTransacao()))
            guiche = guiche.getNextNode()

        print("\n")

        # Decresce 1 segundo do tempo de ocupação dos guichês:
        guiche = guiches.getFirstNode()
        while guiche != None:
            if guiche.getData().getTempoTransacao() > 0:
                guiche.getData().setTempoTransacao(guiche.getData().getTempoTransacao() - 1)
            guiche = guiche.getNextNode()

        time.sleep(2)
        simulationTime += 1

    # Escrever relatório:
    relatorio_content = f"Total de Clientes Atendidos: {totalClientesAtendidos}\n"
    relatorio_content += f"Total de Operações Realizadas: {totalOperacoesRealizadas}\n"
    relatorio_content += f"Total de Saques Realizadas: {totalSaquesRealizados}\n"
    relatorio_content += f"Total de Depositos Realizadas: {totalDepositosRealizados}\n"
    relatorio_content += f"Total de Pagamentos Realizadas: {totalPagamentosRealizados}\n"


    with open("Relatorio.md", "w", encoding="utf-8") as file:
        file.write(relatorio_content)

if __name__ == "__main__":
    main()

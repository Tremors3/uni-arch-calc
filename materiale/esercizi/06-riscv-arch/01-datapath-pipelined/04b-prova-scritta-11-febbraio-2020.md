## [LINK FIGURA](07-prova-scritta-11-febbraio-2020.png)

#### QUESITO

a. Si dica che valori assumono i segnali di controllo generati per questa istruzione (cerchiati in figura)

b. quali blocchi funzionali del datapath effettuano lavoro utile per questa istruzione?

c. quali blocchi funzionali del datapath NON producono output per questa istruzione o producono un output che non è utilizzato?

#### RISOLUZIONE

a. Si dica che valori assumono i segnali di controllo generati per questa istruzione (cerchiati in figura):
- **RegWrite = 1**
- **ALUSrc = 0**
- **ALU Operation = 0000**
- **MemWrite = 0**
- **MemReed = 0**
- **MemtoReg = 0**

b. quali blocchi funzionali del datapath effettuano lavoro utile per questa istruzione?
- **Register File**
- **ALU**

c. quali blocchi funzionali del datapath NON producono output per questa istruzione o producono un output che non è utilizzato?
- **ImmGen**
- **Data Memory**

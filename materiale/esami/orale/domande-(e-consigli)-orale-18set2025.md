
# DOMANDE E ESERCIZI ORALE ARCHITETTURA - 18 set 2025

## NOTE

- Una interrogazione dura in media 30 minuti a testa.
- A molti studenti ha richiesto di risolvere 1 solo esercizio. A volte se l'esercizio è corto e rimane del tempo ne chiede anche un secondo.
- Gli esercizi che chiede all'orale sono della stessa tipologia di quelli sbagliati allo scritto, ma non proprio gli stessi e generalmente più semplici. Raramente assegna un esercizio identico a quello sbagliato nello scritto.
- Raramente ha fatto domande specifiche di teoria. Le fa principalmente nei casi di voti alti nello scritto.
- Il prof ti supervisiona ed è disponibile se vuoi esporgli il ragionamento durante lo svolgimento dell'esercizio e ti aiuta a ragionare.

## STUDENTI

### STUDENTE 1

#### Esercizi

1. Data una funzione scrivere il main (solo il main) e: allocare la stringa sorgente e destinazione sul segmento dati statici; scrivere le istruzioni che servono ad invocare la procedura `strcpy` (quest'ultima già fornita).
    - Particolare attenzione a come allocare array e stringhe nel segmento dati statici del file ELF (.data).
    - Ricordare che le stringhe in C sono terminate con il carattere terminatore '\0' (0).
    - Il main esce con una chiamata alla syscall `Exit`. Ricordare come chiamare la syscall correttamente.
    - Come va gestito lo stack della funzione?

#### Domande

1. Quali parti della CPU RISC-V consentono l'esecuzione di un istruzione di salto? Come l'indirizzo di salto viene calcolato?

#### Esito

- Passato.

---

### STUDENTE 2

#### Esercizi

1. Progetto di una rete logica identica a quella dell'esame scritto (riconoscimento di sequenza; realizzato con mealy; con tre variabili di ingresso e due variabili di codifica degli stati).

#### Esito

- Passato.

---

### STUDENTE 3

#### Esercizi

1. Mi mostri dove in un codice fornito dal prof si trovano possibili `data hazards`.
    - Dove sono situate le dipendenze tra istruzioni.
    - Prova a spiegarmi nella pipeline dove si forma il problema.
    - Inserire le opportune NOP (No Operation) per consentire il corretto funzionamento del codice su una pipeline sprovvista di Hazard Detection e Forwarding Unit.

2. Dato un programma RiscV calcolare la miss prediction rate dato un predittore a singolo bit inizialmente settato a Branch Not Taken.

#### Esito

- Passato.

---

### STUDENTE 4

#### Esercizi

1. Progetto di una rete logica identica a quella dell'esame scritto (riconoscimento di sequenza; realizzato con mealy; con tre variabili di ingresso e due variabili di codifica degli stati).

2. Dimmi in questo codice dove ci sono dei data hazards.

#### Esito

- Passato.

---

### STUDENTE 5

#### Esercizi

1. Data una funzione scrivere il main (solo il main) e: allocare la stringa sorgente e destinazione sul segmento dati statici; scrivere le istruzioni che servono ad invocare la procedura `strcpy` (quest'ultima già fornita).
    - Particolare attenzione a come allocare array e stringhe nel segmento dati statici del file ELF (.data).
    - Che differenza c'è tra l'istruzione `jal` e `jalr`?

2. Disegna il datapath pipeline RISC-V semplificato. Per poi spiegare dove (in che fase) e cosa avviene durante la fase di IF (Instruction Fetch). Dove si strova l'indirizzo della prossima istruzione da eseguire? Come faccio a fare in modo che la prossima istruzione da eseguire non è quella sequenzialmente successiva all'istruzione di salto, ma la prima dopo il salto. Saper interpretare la pipeline identificando gli adder che sommano al PC. 

#### Esito

- Passato.

---

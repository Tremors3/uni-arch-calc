
#### QUESITO

Un gruppo di studenti discute dell’efficienza di una pipeline a 5 stadi, quando uno di loro fa presente che non tutte le istruzioni usano tutti gli stadi della pipeline. Dopo aver deciso di ignorare gli effetti degli hazard, gli studenti traggono le seguenti conclusioni. Quali sono corrette?

- **A)** Consentire alle istruzioni di tipo ALU e branch di usare meno stadi dei cinque richiesti dalla load migliorerebbe la performance della pipeline in tutte le circostanze.
- **B)** Cercare di ridurre il numero di cicli per alcune istruzioni non aiuta, dato che il throughput è determinato dal periodo di clock; il numero di stadi di pipeline per istruzione impatta la latenza, non il throughput.
- **C)** Non si può far sì che le istruzioni ALU impieghino meno cicli per via del writeback dei risultati. I branch però possono impiegare meno cicli, quindi c’è margine di miglioramento.
- **D)** Piuttosto che cercare di far eseguire le istruzioni in meno cicli, sarebbe opportuno cercare di rendere la pipeline più lunga. In questo modo le istruzioni richiederebbero più cicli per eseguire, ma i cicli sarebbero più corti. Questo migliorerebbe la performance.

#### RISOLUZIONE

- **`B)`, `D)`**

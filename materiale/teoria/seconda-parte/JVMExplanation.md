
## Java Virtual Machine

La **Java Virtual Machine (JVM)** è un *processore virtuale*, nel senso che espone una propria **Instruction Set Architecture virtuale**, cioè il set di istruzioni dei **bytecode Java**. Queste istruzioni non corrispondono direttamente a quelle della CPU reale, ma la JVM le **traduce ed esegue** sulla macchina host.

Come fa la JVM a eseguire i bytecode? Ci sono due approcci principali:

1. **Interpretazione**: la JVM legge il bytecode istruzione per istruzione e lo traduce in operazioni equivalenti da eseguire con la CPU host (come un interprete che legge e traduce al volo).

2. **Compilazione Just-In-Time (JIT)**: parti di bytecode vengono tradotte al volo in codice macchina nativo (cioè nell’ISA specifico dell’host, ad esempio x86-64 o ARM), così da accelerare molto l’esecuzione.

### Quindi, in sintesi:

- Il bytecode Java è **comune e indipendente dall’architettura**.

- La JVM è implementata in maniera diversa su ogni architettura (es. JVM per Windows/x86-64, JVM per Linux/ARM, ecc.).

- Una volta che la JVM gira su una macchina host, è lei a occuparsi di trasformare i bytecode nelle istruzioni effettivamente eseguibili dalla CPU fisica.

- In questo senso, sì: la JVM è un “processore virtuale” che **usa la CPU reale come backend** per far girare i programmi Java.

---

## JVM vs Real CPU

1. **Instruction Set**

   - **CPU reale (RISC-V, x86, ARM, ecc.)**: ha un **ISA fisico**, cioè un insieme di istruzioni codificate in binario, eseguite direttamente dall’hardware.

   - **JVM**: ha un **ISA virtuale**, cioè il set di istruzioni dei **Java bytecode**. Queste istruzioni non sono capite direttamente dall’hardware, ma devono essere eseguite dalla JVM.

---

2. **Esecuzione del codice**

   - **CPU reale**: quando la memoria contiene un’istruzione macchina (es. `ADD x1, x2, x3` in RISC-V), la CPU la decodifica e la esegue con l’ALU e i registri fisici.

   - **JVM**: quando trova un bytecode (es. `iadd` per sommare due interi), non ha un’ALU reale, ma lo traduce in un’operazione equivalente che verrà eseguita **dalla CPU reale** su cui gira la JVM.

---

3. **Architettura**

   - **CPU reale**: ha registri, ALU, unità di controllo, pipeline, memoria cache.

   - **JVM**: non ha hardware fisico, ma **emula** queste componenti in software. Ad esempio:
     - al posto dei registri usa uno **stack virtuale** (lo “operand stack” della JVM), dove mette i dati temporanei.
     - le operazioni (`iadd`, `iload`, `istore`, ...) agiscono su questo stack.
     - per i salti e i branch gestisce un **program counter virtuale**.

---

4. **Portabilità**

   - **CPU reale**: un programma compilato per RISC-V non gira su x86, perché le istruzioni binarie sono diverse.

   - **JVM**: il bytecode Java è lo stesso ovunque. Sarà la JVM, diversa per ogni piattaforma, a tradurlo nelle istruzioni corrette per la CPU fisica.
     - Esempio: lo stesso file `.class` con bytecode può girare su Windows/x86, Linux/ARM o macOS/Apple Silicon.

---

5. **Ottimizzazione**

   - **CPU reale**: ottimizza in hardware (pipeline, branch predictor, superscalar, ecc.).

   - **JVM**: ottimizza in software. Ad esempio, con il JIT compiler, traduce parti di bytecode in istruzioni native e le mantiene in memoria, così da eseguirle velocemente come se fossero codice nativo.

---

6. 🔑 **Analogia finale**:

   - La JVM **è come un processore virtuale con un suo linguaggio** (**bytecode**). Ma non avendo un’ALU fisica né registri reali, per eseguire si appoggia alla CPU vera dell’host, che diventa il “motore” che realizza le operazioni.

---

## Which language JVM is written with?

La **JVM non è un unico programma**, ma un insieme di implementazioni diverse.

Il linguaggio in cui è scritta **dipende dall’implementazione specifica**, ma la maggior parte delle JVM è sviluppata in **C, C++ e assembly (machine-dependant)**, perché servono prestazioni molto elevate (la JVM deve eseguire miliardi di bytecode al secondo).

Non tutta la JVM è in C/C++; alcune parti possono essere **in Java stesso**. Questo è possibile perché si parte comunque da una base nativa minima, che avvia il resto.

---

## Java Program Execution Pipeline

```bash
java Programma
```

1. **🔹Avvio del launcher**

   - Quando scrivi `java Programma`, non stai avviando direttamente la JVM, ma un **launcher nativo** (`java.exe` su Windows, `java` su Linux/macOS).

   - Questo launcher è scritto in **C**, e ha il compito di:

     - leggere le opzioni della riga di comando,
     - configurare il **classpath**,
     - trovare il file `.class` o `.jar`,
     - caricare la **JVM nativa** (HotSpot, OpenJ9, ecc.).

2. **🔹Caricamento della JVM**

   - La JVM stessa è un **programma nativo** scritto in C/C++.

   - A questo punto viene avviato il “cuore” della JVM:

     - allocazione dell’**heap** Java,
     - setup dello **stack** delle thread,
     - inizializzazione del **garbage collector**,
     - setup del **class loader** primario.

3. **🔹Caricamento delle classi di base**

   - La JVM deve poter gestire tipi come `String`, `Object`, `System`, ecc.

   - Per questo carica dal **Java Runtime Environment (JRE)** il pacchetto base (`java.base` → contiene `java.lang.*`, `java.util.*`, ecc.).

   - Queste librerie sono **scritte in Java**, ma vengono caricate come bytecode `.class`.

4. **🔹Bytecode Verifier**

   - Prima di eseguire il bytecode, la JVM lo **verifica** per sicurezza:

     - controlla che i tipi siano corretti,
     - che non ci siano accessi a memoria illegali,
     - che non vengano violati i limiti di sicurezza.

   - Questo step è fondamentale perché il bytecode potrebbe arrivare da fonti esterne (es. scaricato da Internet).

5. **🔹Interpretazione e/o JIT Compilation**

   - A questo punto, la JVM ha due modi per eseguire le istruzioni del bytecode:

     1. **Interpreter**: legge le istruzioni bytecode una per una e le traduce in operazioni native immediate.

     2. **JIT Compiler**: identifica le parti “calde” del codice (es. cicli che si ripetono spesso) e le compila in **codice nativo** dell’host (x86, ARM, RISC-V…) per eseguirle più velocemente.

6. **🔹Esecuzione del main**

   - Quando tutto è pronto, la JVM cerca nella classe Programma il metodo:

        ```java
        public static void main(String[] args)
        ```

   - Avvia lo **stack frame virtuale** e inizia l’esecuzione delle istruzioni bytecode, traducendole via via in operazioni native.

7. **🔹Durante l’esecuzione**

   - La JVM continua a:

      - gestire l’**heap** e il **garbage collector**,
      - tradurre codice “caldo” con il JIT,
      - interfacciarsi con l’OS per thread, I/O, ecc.

   - Tutto il tempo, il **bytecode rimane lo stesso** e indipendente dalla macchina: è la JVM che si occupa della traduzione.

- **🔑 Riassunto**

  1. **Launcher (C)** → avvia la JVM nativa.
  2. **JVM nativa (C/C++)** → prepara heap, GC, class loader.
  3. **Caricamento classi base** (`java.lang.*`, ecc.).
  4. **Verifica del bytecode** per sicurezza.
  5. **Esecuzione**: interpretazione + JIT.
  6. Chiamata al `main()` e avvio del programma.

---

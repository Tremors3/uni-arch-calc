## Inizializzazione Registro

Ci sono diversi modi per **inizializzare un registro**.

1) Se voglio inizializzare un registro con il **valore di un altro registro**:

    ```asm
    add x29, x0, x30    # i = j
    ```

2) Se voglio inizializzare un registro con il valore **0**:
    
    ```asm
    add x29, x0, x0     # i = 0
    ```

3) Se voglio inizializzare un registro con un **immediato a scelta**:

    ```asm
    addi x29, x0, 1     # i = 1
    ```

## Tabella di conversione: indice → offset in byte

Quando accedi a un array in RISC-V Assembly, **l’indice va moltiplicato per la dimensione dell’elemento** per ottenere l’offset in byte. Per efficienza, invece della moltiplicazione puoi usare **shift a sinistra**.

| Dimensione elemento | Abbreviazione| Byte per elemento | Shift equivalente | Significato               |
|---------------------|--------------|-------------------|-------------------|---------------------------|
| **Byte**            | `b`          | 1 byte            | `index << 0`      | Nessun shift              |
| **Halfword**        | `h`          | 2 byte            | `index << 1`      | Shift a sinistra di 1 bit |
| **Word**            | `w`          | 4 byte            | `index << 2`      | Shift a sinistra di 2 bit |
| **Doubleword**      | `dw`         | 8 byte            | `index << 3`      | Shift a sinistra di 3 bit |

- In Assembly RISC-V, *gli offset nelle istruzioni di load/store sono sempre espressi in byte*.
- Formula di **accesso all'i-esimo elemento** di un array:

    $$ \textit{Target\_Address} = \textit{Base\_Array\_Address} + (\textit{Index } \times \textit{Element\_Size}) $$

    Ricordando che il prodotto $(\textit{Index } \times \textit{Element\_Size})$ si sostituisce con uno shift verso sinistra, come mostrato in tabella. Per esempio, nel caso dovessimo accedere all'i-esimo elemento di un array i quali elementi hanno dimensione pari a una Word (4 bytes), avremmo:
    
    ```asm
    # x5  = temp
    # x10 = arr
    # x29 = i

    slli x5, x29, 2     # temp = (i * 4)
    add x5, x5, x10     # temp = arr + (i * 4)
    lw x5, 0(x5)        # temp = arr[i]
    ```

## Tabella: Condizione C → Branch RISC-V (condizione invertita)

Quando si cerca di tradurre costrutti di linguaggi ad alto livello (if-else, cicli for, ...) nei corrispettivi assembly, può convenire invertire le condizioni, facendo riferimento alla seguente tabella:

| Condition in C   | Condition RISC-V | To use  | Instruction Meaning                 |
|------------------|------------------|---------|-------------------------------------|
| oper1 `<`  oper2 | oper1 `>=` oper2 | **bge** | Jump if oper1 $\mathbf{\geq}$ oper2 |
| oper1 `>`  oper2 | oper2 `>=` oper1 | **bge** | Jump if oper1 $\mathbf{\leq}$ oper2 |
| oper1 `<=` oper2 | oper2 `<`  oper1 | **blt** | Jump if oper1 $\mathbf{>}$ oper2    |
| oper1 `>=` oper2 | oper1 `<`  oper2 | **blt** | Jump if oper1 $\mathbf{<}$ oper2    |
| oper1 `==` oper2 | oper1 `!=` oper2 | **bne** | Jump if oper1 $\mathbf{\neq}$ oper2 |
| oper1 `!=` oper2 | oper1 `==` oper2 | **beq** | Jump if oper1 $\mathbf{=}$ oper2    |

- In RISC-V le istruzioni $\text{\textcolor{red}{ble} }(\leq)$ e $\text{\textcolor{red}{bgt} }(>)$ **NON ESISTONO**! Al loro posto si usano `BGE` $(\geq)$ e `BLT` $(<)$ rispettivamente, ricordandosi di **INVERTIRE GLI OPERANDI**. Come mostrato nella tabella soprastante.

## Traduzione di una `if-else` da C a RISC-V

**Codice C**:

```c
if (oper1 < oper2) {
    // then-block
} else {
    // else-block
}
```

**Traduzione in RISC-V**:

Si **inverte la condizione** (`oper1 >= oper2`) e si **salta all’etichetta** `ELSE` se è vera.

```asm
    bge oper1, oper2, ELSE      # Salta a ELSE se (oper1 >= oper2)
    ...                         # then-block
    jal x0, ENDIF               # Salta a ENDIF (salta l'else)
ELSE:
    ...                         # else-block
ENDIF:
```

## Condizioni logiche `&&` e `||`

- **AND** (`&&`) È facile da gestire: si sfrutta la cortocircuitazione. Se una condizione è falsa, si esce subito.

    ```c
    if (a < b && x == y)
    ```
    ```asm
        bge a, b, end_if     # Se a ≥ b → salta
        bne x, y, end_if     # Se x ≠ y → salta
        ...                  # Entrambe vere → esegui
    end_if:
    ```

- **OR** (`||`) Richiede più attenzione: basta una vera per entrare. Si usano if-else in sequenza.

    ```c
    if (a < b || x == y)
    ```
    ```asm
        blt a, b, then       # Se a < b → entra
        beq x, y, then       # Se x == y → entra
        jal x0, end_if       # Nessuna vera → salta
    then:
        ...                  # Almeno una vera → esegui
    end_if:
    ```

## Traduzione di un ciclo `for` da C a RISC-V

**Codice C**:

```c
for (int i = 0; i < n; i++)
{
    // for-block
}
```

**Traduzione in RISC-V**:

Si **inverte la condizione** (`i >= n`) e si esce dal ciclo quando è vera.

```asm
    add x29, x0, x0         # i = 0
LOOP:
    bge x29, x21, END       # Goto END if (i >= n)
    ...                     # for-block
    addi x29, x29, 1        # i++
    jal x0, LOOP            # Goto LOOP
END:
```
- Qui `x29` è usato come **contatore i**, e `x21` contiene il **valore n**.

## Istruzione Jal e il Salto Incondizionato

In RISC-V, l’istruzione `jal` (*Jump And Link*) serve per eseguire un salto verso un’etichetta e, allo stesso tempo, salvare nel primo operando l’indirizzo di ritorno, ovvero il valore del program counter (PC) successivo al salto. Questo è utile, ad esempio, nelle chiamate a funzione, perché consente di tornare al punto da cui si è saltati.

Tuttavia, se come primo operando specifichi il registro `x0` (cioè `zero`), stai dicendo esplicitamente al processore di **non salvare** alcun indirizzo di ritorno. Questo perché il registro `x0` è speciale: vale sempre zero e non può mai essere modificato. Di conseguenza, qualsiasi valore si tenti di scrivere in `x0` viene scartato.

Quindi, quando scrivi `jal x0, LABEL`, stai eseguendo un **salto incondizionato** puro verso l’etichetta `LABEL`, senza lasciare tracce di dove eri prima. Non c’è ritorno possibile, ed è proprio questo il comportamento desiderato in molti casi di controllo del flusso, come nei salti all’interno di un `for`, tra un blocco `then` e `else`, o per uscire da un ciclo.

## Allocazione e disallocazione dello stack in RISC-V

L’utilizzo dello stack dipende dalla tipologia di funzione che stiamo implementando:

- Una funzione si dice **leaf** quando non effettua chiamate ad altre funzioni. In questo caso, non è necessario allocare lo stack, perché non serve salvare alcun contesto.

- Una funzione è **non-leaf** quando chiama altre funzioni. In questi casi, lo stack va allocato per salvare informazioni che potrebbero essere sovrascritte durante la chiamata. In particolare, bisogna salvare:

    - **`x1` (Return Address)**: Va sempre salvato se la funzione chiama un’altra funzione. Serve a tornare al punto corretto dopo la chiamata.

    - **Registri `x10-x17` (Argument registers)**: Se la funzione chiama una sotto-procedura e deve preservare i propri parametri, questi registri vanno salvati prima della chiamata.

    - **Contatori o variabili temporanee (es. `i`, `j`)**: Se un ciclo contiene chiamate a funzione, i contatori vanno salvati nello stack, perché potrebbero essere messi in registri temporanei (t0–t6) che vengono sovrascritti dalle sotto-procedure.

    - **Valori di ritorno (`x10-x11`)** Se la funzione riceve più valori da diverse chiamate (es. a = f1(); b = f2();), bisogna salvare il primo valore prima della seconda chiamata, altrimenti verrà sovrascritto.

    - In generale: **Qualsiasi registro il cui valore deve persistere prima e dopo una chiamata a funzione** deve essere salvato. Questo include variabili locali importanti, indirizzi, contatori, ecc. 

Il numero esatto di registri da salvare dipende dall’analisi del corrispondente codice C: occorre **individuare tutte le variabili che devono sopravvivere alle chiamate a funzione** e che quindi non possono stare in registri temporanei o volatili.

- Evita di allocare lo stack inutilmente;
- Se la funzione è leaf e non ha bisogno di preservare nulla, non allocare lo stack.

## Le 7 fasi di una procedura in RISC-V 

1. **Saving Registers**

    Alloca spazio nello stack e salva i registri che devono essere preservati.

2. **Move Parameters**

    Sposta i parametri ricevuti (`a0`, `a1`, ...) in registri salvati (`sN`) se devono essere mantenuti.

3. **Procedure Body**

    Contiene la logica della funzione: operazioni, cicli, condizioni.

4. **Procedure Calling**

    Imposta i parametri in `a0`, `a1`, ... e chiama un’altra funzione. Salva il valore di ritorno.

5. **Save Return Value**

    Inserisce il valore finale da restituire nel registro `a0`.

6. **Restoring Registers**

    Ripristina i registri salvati e dealloca lo stack.

7. **Procedure Return**
    
    Ritorna al chiamante tramite `jr ra`.

Esempio completo:

```asm
fun:
    # 1. Saving Registers
    addi sp, sp, -40       # Alloca 40 byte nello stack
    sd ra,  0(sp)          # Salva ra (return address)
    sd s0,  8(sp)          # Salva s0 (per il contatore i)
    sd s1, 16(sp)          # Salva s1 (per il risultato sum)
    sd s2, 24(sp)          # Salva s2 (1° argomento)
    sd s3, 32(sp)          # Salva s3 (2° argomento)

    # 2. Move Parameters
    mv s2, a0              # Copia a0 in s2
    mv s3, a1              # Copia a1 in s3

body:
    # 3. Procedure Body
    ...                    # Logica della funzione, cicli, condizioni, ecc.

    # 4. Procedure Calling
    mv a0, ...             # Imposta primo argomento per fun2
    mv a1, ...             # Imposta secondo argomento per fun2
    jal ra, fun2           # Chiama fun2
    mv s1, a0              # Salva il valore di ritorno di fun2

    ...
end:
    # 5. Save Return Value
    mv a0, ...             # Imposta il valore di ritorno della funzione

    # 6. Restoring Registers
    ld ra,  0(sp)          # Ripristina ra
    ld s0,  8(sp)          # Ripristina s0
    ld s1, 16(sp)          # Ripristina s1
    ld s2, 24(sp)          # Ripristina s2
    ld s3, 32(sp)          # Ripristina s3
    addi sp, sp, 40        # Dealloca 40 byte dallo stack

    # 7. Procedure Return
    jr ra                  # Ritorna al chiamante
```

## Chiamare una Subroutine in RISC-V

Per **chiamare una funzione** si usa l’istruzione `jal` con `ra` (x1) come registro di ritorno. Gli argomenti vanno nei registri `a0`, `a1`, ..., e il valore di ritorno sarà in `a0`.

```asm
mv a0, ...          # Imposta 1° argomento
mv a1, ...          # Imposta 2° argomento
jal ra, fun2        # Chiama la funzione fun2
mv t0, a0           # Salva il valore di ritorno
```

## Calcolare funzioni matematiche

| Formula     | Metodo in Assembly       | Valido se...               |
|-------------|--------------------------|----------------------------|
| $2^N$       | `1 << N`                 | Sempre                     |
| $\log_2(N)$ | Conta gli shift `N >> 1` | Solo se `N` è potenza di 2 |
| $M^N$       | Moltiplicare `M` per sé stesso, `N-1` volte | Sempre  |
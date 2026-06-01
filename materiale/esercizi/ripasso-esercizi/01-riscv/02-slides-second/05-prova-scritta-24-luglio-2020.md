
#### QUESITO

Assumendo che ci sia un array int arr[6] = {3, 1, 4, 1, 5, 9} il cui primo elemento risiede all’indirizzo 0xBFFFFF00, e che questo indirizzo sia memorizzato nel registro s0:

- b) Scrivere un pezzo di codice assembly che effettui l’operazione:
    `arr[1] = arr[0] + arr[2]`

#### RISOLUZIONE

```asm
lw x5, 0(s0)        # x5 = arr[0]
lw x6, 8(s0)        # x6 = arr[2]
add x7, x5, x6      # x7 = arr[0] + arr[2]
lw x7, 4(s0)        # arr[1] = arr[0] + arr[2]
```
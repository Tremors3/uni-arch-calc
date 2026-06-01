
## Tre tipologie principali di Cache Misses

- **Compulsory misses (o cold misses)**: si verificano al **primo accesso** a un dato. Anche se la cache fosse enorme, dovresti comunque caricare il blocco almeno una volta, quindi sono inevitabili. Possono solo essere mitigati con strategie come il *prefetching*.

- **Conflict misses**: derivano da **collisioni di mapping**. In una cache direct mapped o set associative, più blocchi di memoria che competono per lo stesso set o linea si rimpiazzano continuamente, causando miss anche se ci sarebbe spazio altrove. Aumentare l’associatività riduce il problema, e una cache fully associative non soffre di conflict misses.

- **Capacity misses**: questi si verificano quando l’insieme dei dati attivi di un programma (**working set**) è più grande della capacità della cache. In questo caso, indipendentemente dall’associatività, la cache non riesce a contenere tutto ciò che serve, e i blocchi devono essere continuamente rimpiazzati. L’unico modo per ridurre i capacity misses è aumentare la dimensione della cache o ottimizzare l’accesso ai dati (per esempio con tecniche software di *blocking* o *tiling*).

Quindi, in breve:

- **Compulsory = inevitabili, primo accesso**.
- **Conflict = dovuti al mapping limitato**.
- **Capacity = dovuti alla cache troppo piccola rispetto al working set**.

---

## Regole veloci per i calcoli:

Calcolo dell'indirizzo:

- **Indice = `(indirizzo / size_linea) mod num_linee`**.
- **Tag = `(indirizzo / size_linea) / num_linee`**.
- **Offset = `(indirizzo mod size_linea)`**.

Suddivisione dell'indirizzo:

```
|  Tag  |  Indice  |  Offset  |
```

Calcolo della dimensione della Cache:

- **DMapp → 1 linea per set → `line_dim × line_num × 1`**.
- **2-way → 2 linee per set → `line_dim × line_num × 2`**.
- **4-way → 4 linee per set → `line_dim × line_num × 4`**.

---

# Instruções de Execução: C-Note_3

De modo a executar o programa basta carregar o ficheiro c-note.pl para o SICStus Prolog.

## Execução dos predicado Solver

Para correr o predicado que resolve o problema, basta inserir no terminal do SICStus: 

```
cNote(+InputList,+Sum).
```

Em que *InputList* é a grelha do problema (lista de listas) e *Sum* a soma das colunas e linhas desejada.



## Execução dos predicado Generator

Para correr o predicado que gera um problema com solução única, basta inserir no terminal do SICStus: 

```
cNoteGenerateUnique(+RowLength, +Sum, -Matrix).
```

Em que *RowLength* é o tamanho de linhas e colunas da grelha do problema, *Sum* a soma das colunas e linhas desejada e *Matrix* é a grelha do problema gerado (lista de listas).

Para correr o predicado que gera um problema com múltiplas soluções, basta inserir no terminal do SICStus: 

```
cNoteGenerate(+RowLength, +Sum, -Matrix).
```

Em que *RowLength* é o tamanho de linhas e colunas da grelha do problema, *Sum* a soma das colunas e linhas desejada e *Matrix* é a grelha do problema gerado (lista de listas).



## Execução do programa pela interface de menus

Outro método de correr o solver e o generator é através da interface de menus fornecida. Para iniciar os menus basta inserir no terminal do SICStus:

```
cNoteMenu.
```

Este comando imprime o menu na consola, para prosseguir basta inserir o número da opção desejada.

**Notas**: 

- Quando o menu pede a grelha/matriz desejada para resolver tem que se inserir o input em forma de lista de listas.
- Quando se chama o menu este resolve/gera os problemas sempre com a soma das colunas/linhas para 100. Para alterar este valor é necessário correr os predicados manualmente.

​			
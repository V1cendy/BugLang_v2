# BugLang - Compilador com AST

BugLang é uma linguagem de programação educacional com sintaxe simplificada, construída com Flex e Bison, que suporta estruturas básicas como variáveis, entrada e saída, expressões aritméticas, condicionais, laços e manipulação de strings. Agora, com suporte a Árvore de Sintaxe Abstrata (AST).

---

## ✅ Funcionalidades Suportadas

### 1. Declaração de Variáveis

```buglang
start
    var x
end
```

### 2. Atribuição com Tipagem Dinâmica

```buglang
start
    var x
    x = 10       // int
    x = 3.14     // float
    x = "texto"  // string
end
```

### 3. Entrada de Dados (`read`)

```buglang
start
    var nome
    read(nome)
end
```

### 4. Saída de Dados (`print`)

```buglang
start
    var nome
    nome = "BugLang"
    print(nome)

    print("String direta")
    print(3 + 2 * 5) // Expressão
end
```

### 5. Expressões Aritméticas

```buglang
start
    var x
    var y
    x = 4
    y = x * (2 + 3)
    print(y)
end
```

### 6. Operadores Lógicos e de Comparação

- `>` `>=` `<` `<=` `==` `!=`
- `||` `&&`

```buglang
start
    var a
    var b
    a = 10
    b = 20
    print(a < b && b > 15) // imprime 1 (true)
end
```

### 7. Estrutura Condicional `if` / `else`

```buglang
start
    var nota
    nota = 7
    if (nota >= 6) {
        print("Aprovado")
    } else {
        print("Reprovado")
    }
end
```

### 8. Laço de Repetição `while`

```buglang
start
    var i
    i = 0
    while (i < 5) {
        print(i)
        i = i + 1
    }
end
```

---

## 🛠️ Como Compilar e Executar

1. Gere o analisador léxico:

```bash
flex BugLang.l
```

2. Gere o analisador sintático:

```bash
bison -d BugLang.y
```

3. Compile o código:

```bash
gcc BugLang.tab.c -o BugLang -lm
```

4. Execute com um arquivo `.bug`:

```bash
./BugLang
```

Certifique-se de que seu arquivo chamado `codigo_teste.bug` esteja presente no mesmo diretório.

---

## 📁 Exemplo de código_teste.bug

```buglang
start
    var nome
    var idade

    read(nome)
    read(idade)

    if (idade >= 18) {
        print("Maior de idade")
    } else {
        print("Menor de idade")
    }

    print(nome)
end
```

---

## ℹ️ Observações

- O tipo da variável é inferido na **primeira atribuição**.
- As variáveis são armazenadas numa estrutura ligada (`VARS`).
- O interpretador usa uma **Árvore de Sintaxe Abstrata (AST)** para processar comandos.
- Strings podem ser impressas com ou sem variáveis.
- A linguagem é sensível à sintaxe e exige `start` e `end` delimitando o programa.

---

Desenvolvido por Victor Souza da Silva ✨

# BugLang ++

BugLang é uma linguagem de programação educacional com sintaxe simplificada, construída com Flex e Bison, que suporta estruturas básicas como variáveis, entrada e saída, expressões aritméticas, condicionais, laços e manipulação de strings.

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

```buglang
start
    var a
    var b
    a = 10
    b = 20
    print(a < b) // imprime 1 (true)
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

Os arquivos necessario seram compilados dentro do Makefile, certifique que ele esteja dentro do diretorio junto dos
outros arquivos. Com isso é só digitar 'make' no terminal para compilar e executar:

```bash
make
```

Certifique-se de que seu arquivo chamado `codigo_teste.bug` esteja presente no mesmo diretório.

---

## 📁 Exemplo de código_teste.bug

```buglang
/*
Buglang
compiladores
ifce - aracati
*/

start

//calculo de media de notas do IFCE

var nota1
var nota2
var nota3
var nota4
var media
var N1
var N2


print("Digite a primeira nota:")
read(nota1)
print("Digite a segunda nota:")
read(nota2)
print("Digite a terceira nota:")
read(nota3)
print("Digite a quarta nota:")
read(nota4)

print("Digite o peso da N1:")
read(N1)
print("Digite o peso da N2:")
read(N2)

media = (N1*((nota1 + nota2)/2) + N2*((nota3 + nota4)/2))/5

print("Média final:")
print(media)

if (media >= 7) {
    print("Aluno aprovado!")
} else {
    if (media >= 5) {
        print("Aluno em recuperação.")
    } else {
        print("Aluno reprovado.")
    }
}

end


```
---

Desenvolvido por Victor Souza da Silva ✨

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

// Estrutura de variável (mantida do compilador sem AST)
typedef struct vars {
    char name[50];
    char tipo[20];
    int inte;
    float flo;
    char s_valor[100];
    struct vars *prox;
} VARS;

VARS *listaVars = NULL;

VARS *ins(VARS *l, char n[]) {
    VARS *new = (VARS *)malloc(sizeof(VARS));
    strcpy(new->name, n);
    strcpy(new->tipo, "indefinido");
    new->prox = l;
    return new;
}

VARS *srch(VARS *l, char n[]) {
    VARS *aux = l;
    while (aux != NULL) {
        if (strcmp(n, aux->name) == 0)
            return aux;
        aux = aux->prox;
    }
    return NULL;
}

// Estruturas da AST
typedef enum {
    NODE_PROGRAM, NODE_BLOCK, NODE_DECL, NODE_ASSIGN, NODE_PRINT, NODE_SCAN,
    NODE_IF, NODE_WHILE, NODE_EXPR, NODE_NUM, NODE_STRING, NODE_ID
} NodeType;

typedef struct ast {
    NodeType nodetype;
    int fn; // Para operadores comparativos e lógicos
    struct ast *l;
    struct ast *r;
} Ast;

typedef struct numval {
    NodeType nodetype;
    double number;
} Numval;

typedef struct strval {
    NodeType nodetype;
    char str[100];
} Strval;

typedef struct idval {
    NodeType nodetype;
    char id[50];
} Idval;

typedef struct flow {
    NodeType nodetype;
    Ast *cond;
    Ast *tl; // then ou body
    Ast *el; // else (opcional)
} Flow;

typedef struct symasgn {
    NodeType nodetype;
    char id[50];
    Ast *v;
} Symasgn;

// Funções para criar nós da AST
Ast *newast(NodeType nodetype, int fn, Ast *l, Ast *r) {
    Ast *a = (Ast *)malloc(sizeof(Ast));
    if (!a) { printf("out of space\n"); exit(1); }
    a->nodetype = nodetype;
    a->fn = fn;
    a->l = l;
    a->r = r;
    return a;
}

Ast *newnum(double d) {
    Numval *a = (Numval *)malloc(sizeof(Numval));
    if (!a) { printf("out of space\n"); exit(1); }
    a->nodetype = NODE_NUM;
    a->number = d;
    return (Ast *)a;
}

Ast *newstring(char *s) {
    Strval *a = (Strval *)malloc(sizeof(Strval));
    if (!a) { printf("out of space\n"); exit(1); }
    a->nodetype = NODE_STRING;
    strncpy(a->str, s, 100);
    return (Ast *)a;
}

Ast *newid(char *s) {
    Idval *a = (Idval *)malloc(sizeof(Idval));
    if (!a) { printf("out of space\n"); exit(1); }
    a->nodetype = NODE_ID;
    strncpy(a->id, s, 50);
    return (Ast *)a;
}

Ast *newflow(NodeType nodetype, Ast *cond, Ast *tl, Ast *el) {
    Flow *a = (Flow *)malloc(sizeof(Flow));
    if (!a) { printf("out of space\n"); exit(1); }
    a->nodetype = nodetype;
    a->cond = cond;
    a->tl = tl;
    a->el = el;
    return (Ast *)a;
}

Ast *newasgn(char *id, Ast *v) {
    Symasgn *a = (Symasgn *)malloc(sizeof(Symasgn));
    if (!a) { printf("out of space\n"); exit(1); }
    a->nodetype = NODE_ASSIGN;
    strncpy(a->id, id, 50);
    a->v = v;
    return (Ast *)a;
}

Ast *newscan(char *id) {
    Idval *a = (Idval *)malloc(sizeof(Idval));
    if (!a) { printf("out of space\n"); exit(1); }
    a->nodetype = NODE_SCAN;
    strncpy(a->id, id, 50);
    return (Ast *)a;
}

Ast *newdecl(char *id) {
    Idval *a = (Idval *)malloc(sizeof(Idval));
    if (!a) { printf("out of space\n"); exit(1); }
    a->nodetype = NODE_DECL;
    strncpy(a->id, id, 50);
    return (Ast *)a;
}

// Função para avaliar a AST
double eval(Ast *a) {
    double v = 0.0;
    if (!a) {
        printf("internal error: null eval\n");
        return 0.0;
    }
    switch (a->nodetype) {
        case NODE_NUM:
            v = ((Numval *)a)->number;
            break;
        case NODE_STRING:
            v = 0.0; // Strings não retornam valor numérico
            break;
        case NODE_ID: {
            VARS *var = srch(listaVars, ((Idval *)a)->id);
            if (!var) {
                printf("Erro: variável %s não declarada\n", ((Idval *)a)->id);
                return 0.0;
            }
            if (strcmp(var->tipo, "int") == 0) v = var->inte;
            else if (strcmp(var->tipo, "float") == 0) v = var->flo;
            else v = 0.0;
            break;
        }
        case NODE_EXPR:
            switch (((Ast *)a)->fn) {
                case '+': v = eval(((Ast *)a)->l) + eval(((Ast *)a)->r); break;
                case '-': v = eval(((Ast *)a)->l) - eval(((Ast *)a)->r); break;
                case '*': v = eval(((Ast *)a)->l) * eval(((Ast *)a)->r); break;
                case '/': v = eval(((Ast *)a)->l) / eval(((Ast *)a)->r); break;
                case '%': v = (int)eval(((Ast *)a)->l) % (int)eval(((Ast *)a)->r); break;
                case 1: v = eval(((Ast *)a)->l) > eval(((Ast *)a)->r); break; // >
                case 2: v = eval(((Ast *)a)->l) < eval(((Ast *)a)->r); break; // <
                case 3: v = eval(((Ast *)a)->l) >= eval(((Ast *)a)->r); break; // >=
                case 4: v = eval(((Ast *)a)->l) <= eval(((Ast *)a)->r); break; // <=
                case 5: v = eval(((Ast *)a)->l) == eval(((Ast *)a)->r); break; // ==
                case 6: v = eval(((Ast *)a)->l) != eval(((Ast *)a)->r); break; // !=
                default: printf("internal error: bad expr fn %d\n", ((Ast *)a)->fn); break;
            }
            break;
        case NODE_ASSIGN: {
            VARS *var = srch(listaVars, ((Symasgn *)a)->id);
            if (!var) {
                printf("Erro: variável %s não declarada\n", ((Symasgn *)a)->id);
                return 0.0;
            }
            if (((Symasgn *)a)->v->nodetype == NODE_STRING) {
                strcpy(var->s_valor, ((Strval *)((Symasgn *)a)->v)->str);
                strcpy(var->tipo, "string");
            } else {
                v = eval(((Symasgn *)a)->v);
                var->flo = v;
                var->inte = (int)v;
                strcpy(var->tipo, floor(v) == v ? "int" : "float");
            }
            break;
        }
        case NODE_PRINT: {
            if (a->l->nodetype == NODE_STRING) {
                char temp[100];
                char *str = ((Strval *)a->l)->str;
                if (str[0] == '"' && str[strlen(str)-1] == '"') {
                    strncpy(temp, str + 1, strlen(str) - 2);
                    temp[strlen(str) - 2] = '\0';
                    printf("%s\n", temp);
                } else {
                    printf("%s\n", str);
                }
            } else if (a->l->nodetype == NODE_ID) {
                VARS *var = srch(listaVars, ((Idval *)a->l)->id);
                if (!var) {
                    printf("Erro: variável %s não declarada\n", ((Idval *)a->l)->id);
                } else if (strcmp(var->tipo, "int") == 0) {
                    printf("%d\n", var->inte);
                } else if (strcmp(var->tipo, "float") == 0) {
                    printf("%.2f\n", var->flo);
                } else {
                    char temp[100];
                    char *str = var->s_valor;
                    if (str[0] == '"' && str[strlen(str)-1] == '"') {
                        strncpy(temp, str + 1, strlen(str) - 2);
                        temp[strlen(str) - 2] = '\0';
                        printf("%s\n", temp);
                    } else {
                        printf("%s\n", str);
                    }
                }
            } else {
                v = eval(a->l);
                if (floor(v) == v) {
                    printf("%d\n", (int)v);
                } else {
                    printf("%.2f\n", v);
                }
            }
            break;
        }
        case NODE_SCAN: {
            VARS *var = srch(listaVars, ((Idval *)a)->id);
            if (!var) {
                printf("Erro: variável %s não declarada\n", ((Idval *)a)->id);
                return 0.0;
            }
            char buffer[100];
            scanf(" %99[^\n]", buffer);
            int int_val;
            float float_val;
            if (sscanf(buffer, "%d", &int_val) == 1 && strchr(buffer, '.') == NULL) {
                var->inte = int_val;
                strcpy(var->tipo, "int");
            } else if (sscanf(buffer, "%f", &float_val) == 1) {
                var->flo = float_val;
                strcpy(var->tipo, "float");
            } else {
                snprintf(var->s_valor, sizeof(var->s_valor), "%s", buffer);
                strcpy(var->tipo, "string");
            }
            break;
        }
        case NODE_DECL: {
            VARS *var = srch(listaVars, ((Idval *)a)->id);
            if (!var) {
                listaVars = ins(listaVars, ((Idval *)a)->id);
            }
            break;
        }
        case NODE_IF: {
            if (eval(((Flow *)a)->cond) != 0) {
                if (((Flow *)a)->tl) v = eval(((Flow *)a)->tl);
            } else {
                if (((Flow *)a)->el) v = eval(((Flow *)a)->el);
            }
            break;
        }
        case NODE_WHILE: {
            while (eval(((Flow *)a)->cond) != 0) {
                if (((Flow *)a)->tl) v = eval(((Flow *)a)->tl);
            }
            break;
        }
        case NODE_BLOCK: {
            if (a->l) eval(a->l);
            if (a->r) v = eval(a->r);
            break;
        }
        case NODE_PROGRAM: {
            if (a->l) v = eval(a->l);
            break;
        }
        default:
            printf("internal error: bad node %d\n", a->nodetype);
            break;
    }
    return v;
}
%}

%union {
    float flo;
    int fn;
    char str[100];
    Ast *node;
}

%token INICIO FIM VAR PRINT SCAN IF ELSE WHILE
%token CMP
%token <str> ID STRING
%token <flo> NUMBER

%type <node> programa bloco comando declaracao atribuicao leitura escrita condicional repeticao expressao
%type <fn> CMP

%left '+' '-' OR AND
%left '*' '/' '%'
%nonassoc CMP
%nonassoc IFX

%%

programa:
    INICIO bloco FIM { $$ = newast(NODE_PROGRAM, 0, $2, NULL); eval($$); }
    ;

bloco:
    { $$ = NULL; }
    | comando bloco { $$ = newast(NODE_BLOCK, 0, $1, $2); }
    ;

comando:
      declaracao { $$ = $1; }
    | atribuicao { $$ = $1; }
    | leitura { $$ = $1; }
    | escrita { $$ = $1; }
    | condicional { $$ = $1; }
    | repeticao { $$ = $1; }
    ;

declaracao:
    VAR ID { $$ = newdecl($2); }
    ;

atribuicao:
    ID '=' STRING { $$ = newasgn($1, newstring($3)); }
    | ID '=' expressao { $$ = newasgn($1, $3); }
    ;

leitura:
    SCAN '(' ID ')' { $$ = newscan($3); }
    ;

escrita:
    PRINT '(' expressao ')' { $$ = newast(NODE_PRINT, 0, $3, NULL); }
    | PRINT '(' ID ')' { $$ = newast(NODE_PRINT, 0, newid($3), NULL); }
    | PRINT '(' STRING ')' { $$ = newast(NODE_PRINT, 0, newstring($3), NULL); }
    ;

condicional:
    IF '(' expressao ')' '{' bloco '}' %prec IFX { $$ = newflow(NODE_IF, $3, $6, NULL); }
    | IF '(' expressao ')' '{' bloco '}' ELSE '{' bloco '}' { $$ = newflow(NODE_IF, $3, $6, $10); }
    ;

repeticao:
    WHILE '(' expressao ')' '{' bloco '}' { $$ = newflow(NODE_WHILE, $3, $6, NULL); }
    ;

expressao:
      expressao '+' expressao { $$ = newast(NODE_EXPR, '+', $1, $3); }
    | expressao '-' expressao { $$ = newast(NODE_EXPR, '-', $1, $3); }
    | expressao '*' expressao { $$ = newast(NODE_EXPR, '*', $1, $3); }
    | expressao '/' expressao { $$ = newast(NODE_EXPR, '/', $1, $3); }
    | expressao '%' expressao { $$ = newast(NODE_EXPR, '%', $1, $3); }
    | expressao CMP expressao { $$ = newast(NODE_EXPR, $2, $1, $3); }
    | NUMBER { $$ = newnum($1); }
    | ID { $$ = newid($1); }
    | '(' expressao ')' { $$ = $2; }
    ;

%%

#include "lex.yy.c"

int main() {
    yyin = fopen("codigo_teste.bug", "r");
    if (!yyin) {
        printf("Erro ao abrir o arquivo\n");
        return 1;
    }
    yyparse();
    fclose(yyin);
    return 0;
}
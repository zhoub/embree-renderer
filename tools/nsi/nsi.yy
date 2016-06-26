%locations
%pure_parser
%error-verbose

%{
#include <cstdio>
#include <iostream>

#include "nsi.yy.hpp"

typedef void *yyscan_t;

extern int yylex(YYSTYPE *yylval_param, YYLTYPE *yylloc_param, yyscan_t yyscanner);

void yyerror(YYLTYPE *yylloc_param, yyscan_t yyscanner, const char *yymsg);
%}

%parse-param { yyscan_t *scanner }
%lex-param { scanner }

%union
{
    float fval;
    int   ival;
    char* sval;
}

%token<fval> FLOAT
%token<ival> INTEGER
%token<sval> STRING

%token CREATE
%token SET_ATTRIBUTE
%token CONNECT


%%

stmts:
    stmts stmt
    |
    ;

stmt:
    create
    | set_attribute
    | connect
    ;

create:
    CREATE STRING STRING { std::cout << "Create" << std::endl; }
    ;

set_attribute:
    SET_ATTRIBUTE STRING params { std::cout << "SetAttribute" << std::endl; }
    ;

connect:
    CONNECT STRING STRING STRING STRING { std::cout << "Connect" << std::endl; }
    ;

params:
    params param
    |
    ;

param:
    STRING STRING INTEGER value
    ;

value:
    FLOAT
    | INTEGER
    | STRING
    | array
    ;

array:
    '[' numbers ']'
    ;

numbers:
    numbers number
    |

number:
    INTEGER
    | FLOAT
    ;

%%

typedef void *yyscan_t;
typedef struct yy_buffer_state *YY_BUFFER_STATE;

extern int yylex_init(yyscan_t *yyscanner);
extern void yyset_in(FILE *in_str, yyscan_t yyscanner);
extern YY_BUFFER_STATE yy_scan_string(const char *yy_str, yyscan_t yyscanner);
extern void yy_delete_buffer(int state, yyscan_t scanner);
extern int yylex_destroy(yyscan_t yyscanner);

extern int yyparse(yyscan_t *yyscanner);

int nsi_parse_file(FILE *file)
{
    if (! file)
    {
        return 1;
    }

    yyscan_t scanner = NULL;
    if (yylex_init(&scanner))
    {
        return 1;
    }
    yyset_in(file, scanner);
    yyparse(&scanner);
    yylex_destroy(scanner);

    return 0;
}

int nsi_parse_string(const char *str)
{
    yyscan_t scanner = NULL;
    if (yylex_init(&scanner))
    {
        return 1;
    }
    YY_BUFFER_STATE state = yy_scan_string(str, scanner);
    if (state)
    {
        yyparse(&scanner);
    }
    yylex_destroy(scanner);

    return 0;
}

void yyerror(YYLTYPE *yylloc_param, yyscan_t yyscanner, const char *yymsg)
{
    fprintf(stderr, "%d : %s", yylloc_param->first_line, yymsg);
}

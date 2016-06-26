%option bison-bridge
%option bison-locations
%option case-insensitive
%option never-interactive
%option nounistd
%option noyywrap
%option yylineno
%option reentrant

%{
#include <cstdio>
#include <cstdlib>

#include "nsi.yy.hpp"

%}

%%

[ \r\t\n]                     {}

-?[1-9][0-9]*                 { yylval->ival = 0; sscanf(yytext, "%d", &yylval->ival); return INTEGER; }

[-+]?[0-9]*\.?[0-9]+          { yylval->fval = 0; sscanf(yytext, "%f", &yylval->fval); return FLOAT; }

\"[^\"]*\"                    { yylval->sval = yytext; return STRING; }

"["                           { return '['; }
"]"                           { return ']'; }

Create                        { yylval->sval = yytext; return CREATE; }
SetAttribute                  { yylval->sval = yytext; return SET_ATTRIBUTE; }
Connect                       { yylval->sval = yytext; return CONNECT; }

%%

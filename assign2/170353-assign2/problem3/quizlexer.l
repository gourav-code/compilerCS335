%{
# include <stdio.h>
# include <iostream>
# include "quizparser.hpp"
using namespace std;
%}
DIGIT               [0-9]
S                   [\"][ |\n]*[">"]
STRING              [a-zA-Z0-90-9][a-zA-Z0-9]*
%%
"<"[ |\n]*[q|Q][u|U][i|I][z|Z][ |\n]*">"                      { return QUIZ; }
"</"[ |\n]*[q|Q][u|U][i|I][z|Z][ |\n]*">"                     { return ENDQUIZ; }
"<"[ |\n]*[s|S][i|I][n|N][g][l|L][e|E][s|S][e|E][l|L][e|E][c|C][t|T][ |\n]*[m|M][a|A][r|R][k|K][s|S][ |\n]*=[ |\n]*\"     { return SINGLESELECT; }
{DIGIT}                                         { yylval.num = atoi(yytext); return MARKS;}
{S}                                             { return LASTSYMBOL; }
{STRING}                                        { yylval.str = yytext; return STRINGS; }
"</"[ |\n]*[s|S][i|I][n|N][g][l|L][e|E][s|S][e|E][l|L][e|E][c|C][t|T][ |\n]*">"      { return ENDSINGLESELECT; }
"<"[ |\n]*[m|M][u|U][l|L][t|T][i|I][s|S][e|E][l|L][e|E][c|C][t|T][ |\n]*[m|M][a|A][r|R][k|K][s|S][ |\n]*=[ |\n]*\"      { return MULTISELECT; }
"</"[ |\n]*[m|M][u|U][l|L][t|T][i|I][s|S][e|E][l|L][e|E][c|C][t|T][ |\n]*">"       { return ENDMULTISELECT; }
"<"[ |\n]*[c|C][h|H][o|O][i|I][c|C][e|E][ |\n]*">"         { return CHOICE; }
"</"[ |\n]*[c|C][h|H][o|O][i|I][c|C][e|E][ |\n]*">"            {  return ENDCHOICE; }
"<"[ |\n]*[c|C][o|O][r|R][r|R][e|E][c|C][t|T][ |\n]*">"        { return CORRECT; }
"</"[ |\n]*[c|C][o|O][r|R][r|R][e|E][c|C][t|T][ |\n]*">"       { return ENDCORRECT; }
[ \t\n]+                                         { /* Ignore whitespace*/ }
.                                                { /* Ignore character */ }

%%

int yywrap() {
    return 1;
}

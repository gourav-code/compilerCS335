%{
#include <stdio.h>
#include <stdlib.h>
#include <bits/stdc++.h>
#include "quizparser.hpp"
extern char *yytext;
extern FILE* yyin;
void yyerror(const char* s);
int yylex(void);
int yyparse(void);
int numQuestion = 0;
int numChoices = 0;
int numCorrect = 0;
int singleQues = 0;
int multieQues = 0;
int totalMarks = 0;
int oneMarkQuestion = 0;
int twoMarkQuestion = 0;
int threeMarkQuestion = 0;
int fourMarkQuestion = 0;
int fiveMarkQuestion = 0;
int sixMarkQuestion = 0;
int sevenMarkQuesiton = 0;
int eightMarkQuestion = 0;
%}

%union {
    char* str;
    int num;
}

%token QUIZ ENDQUIZ SINGLESELECT ENDSINGLESELECT MULTISELECT ENDMULTISELECT CHOICE ENDCHOICE CORRECT ENDCORRECT LASTSYMBOL
%token <num> MARKS
%token <str> STRINGS

%%

quiz: 
    QUIZ questions ENDQUIZ 
    { /* Perform statistics calculation here */ 
        printf("number of questions: %d\n",numQuestion);
        printf("number of choices : %d\n",numChoices);
        printf("number of correct answer: %d\n",numCorrect);
        printf("number of single question: %d\n",singleQues);
        printf("number of multiple question: %d\n",multieQues);
        printf("Total marks : %d\n",totalMarks);
        printf("Number of 1 marks question: %d\n", oneMarkQuestion);
        printf("Number of 2 marks question: %d\n", twoMarkQuestion);
        printf("Number of 3 marks question: %d\n", threeMarkQuestion);
        printf("Number of 4 marks question: %d\n", fourMarkQuestion);
        printf("Number of 5 marks question: %d\n", fiveMarkQuestion);
        printf("Number of 6 marks question: %d\n", sixMarkQuestion);
        printf("Number of 7 marks question: %d\n", sevenMarkQuesiton);
        printf("Number of 8 marks question: %d\n", eightMarkQuestion);
    }
    ;

questions: 
    | questions question
    ;

question: singleselect      { numQuestion++; }
    | multiselect           { numQuestion++; }
    ;

singleselect: 
    SINGLESELECT MARKS LASTSYMBOL choices ENDSINGLESELECT {
         /* Handle singleselect question */ 
         if( $2 == 1)   oneMarkQuestion++;
         if( $2 == 2)   twoMarkQuestion++;
         totalMarks += $2;
         singleQues++;
         }
    ;

multiselect: 
    MULTISELECT MARKS LASTSYMBOL choices ENDMULTISELECT {
         /* Handle multiselect question */ 
         if( $2 == 2)   twoMarkQuestion++;
         if( $2 == 3)   threeMarkQuestion++;
         if( $2 == 4)   fourMarkQuestion++;
         if( $2 == 5)   fiveMarkQuestion++;
         if( $2 == 6)   sixMarkQuestion++;
         if( $2 == 7)   sevenMarkQuesiton++;
         if( $2 == 8)   eightMarkQuestion++;
         totalMarks += $2;
         multieQues++;
         }
    ;

choices: 
    | choices string CHOICE string ENDCHOICE string { numChoices++;}
    | choices string CORRECT string ENDCORRECT string { numCorrect++; }
    ;

string:
    | string STRINGS
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    exit(EXIT_FAILURE);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s input_file\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error opening file");
        return 1;
    }

    yyin = input_file; 

    yyparse();  // Start parsing

    fclose(input_file);

    return 0;
}



%{
#include<iostream>
#include<vector>
#include<string>
#include<fstream>



using namespace std; 




class analyzer{
    public:
	string Lexeme;
	int token;
	int count;
};

vector<analyzer>Lexical_record;
void analize(int);


int next_line=1;



#define OPERATOR                0
#define KEYWORD                 1
#define IDENTIFIER              2
#define STRING_LITERAL          3
#define DELIMITER              4
#define MULTI_LINE_COMMENT      5
#define SINGLE_LINE_COMMENT     6
#define INVALID_TOKEN           7


%}

delim	[ \t\n]
whitespaces	{delim}+
letter	[A-Za-z]
nonzero_digit   [1-9]
digit	[0-9]
Letter_string	{letter}({letter}|{digit})*
number	{digit}+(\.{digit}+)?
literals	{number}|\".\"|\'.\'

%%


"ARRAY"|"BEGIN"|"BOOLEAN"|"COMMENT"|"CONTINUE"|"DO"|"DOUBLE"|"ELSE"|"END"|"FALSE"|"FOR"|"IF"|"INTEGER"|"LABEL"|"LIST"|"LONG"|"OWN"|"PROCEDURE"|"STEP"|"SWITCH"|"THEN"|"TRUE"|"UNTIL"|"VALUE"|"WHILE"|"array"|"begin"|"boolean"|"continue"|"comment"|"do"|"double"|"else"|"end"|"false"|"for"|"if"|"integer"|"label"|"list"|"long"|"own"|"procedure"|"step"|"switch"|"then"|"true"|"until"|"value"|"while"	   {
  analize(KEYWORD);}
{literals}	{ 
	analize(STRING_LITERAL);}  
";"|":"|","|"\'"|"["|"]"|"{"|"}"|"("|")"|"\"" {
	analize(DELIMITER);
    }

":="|"*"|"+"|"-"|"%"|"<<"|">>"|"&"|"^"|"/"|"<="|">="|"|" {
 analize(OPERATOR);}

"AND"|"OR"|"LEQ"|"LT"|"GEQ"|"GT"|"NOT"|"EQL"|"NEQ" {
 analize(OPERATOR);}


\n\t	{ 
	next_line++; }
"{"[^{}]*"}"|{whitespaces}	

{Letter_string}	{
	 analize(IDENTIFIER);}
.	{ cout << "token is illegeal "<< yytext <<" find in the  line:" << next_line << endl;}

%%



void analize(int token)
{   int fnd = 0;

	if(Lexical_record.empty())
	    Lexical_record.push_back({yytext,token,1});
    		
	int m=Lexical_record.size(), cnt=0;
	while(cnt<m){
		if(Lexical_record[cnt].Lexeme==yytext){
			Lexical_record[cnt].count=Lexical_record[cnt].count+1;
			fnd=1;
			break;
		}
		cnt=cnt+1;
	}
   


        if(!fnd){     
		 Lexical_record.push_back({yytext,token,1});
        }
}



int yywrap(){}



int main(int argc, char* argv[])
{
    yyin = fopen(argv[1],"r");

    yylex();
    fstream fout;

    fout.open("statistics.csv",ios::out);

    fout<<"LEXEME,TOKEN,COUNT,\n";
    string Lexical_token;
	int m=Lexical_record.size(),cnt=0;
	while(cnt<m){
		if(Lexical_record[cnt].token == KEYWORD){
			Lexical_token="Keyword";
			
		}
		if(Lexical_record[cnt].token == IDENTIFIER){
			Lexical_token="Identifier";
			
		}
		if(Lexical_record[cnt].token == OPERATOR){
			Lexical_token="Operator";
			
		}
		if(Lexical_record[cnt].token == DELIMITER){
			Lexical_token="delimiter";
			
		}
		if(Lexical_record[cnt].token == STRING_LITERAL){
			Lexical_token="string_literal";
			
		}
		if(Lexical_record[cnt].token == DELIMITER)
		Lexical_record[cnt].Lexeme = "\""+Lexical_record[cnt].Lexeme + "\"";
	    fout<<Lexical_record[cnt].Lexeme << "," << Lexical_token << "," << Lexical_record[cnt].count << ",\n";
        cnt=cnt+1;
	}
  
    fout.close();
    return 0;
}


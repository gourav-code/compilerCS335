%{
    #include <bits/stdc++.h>
    using namespace std;
    
    struct ajeet{
        string lex;
        string tkn;
        string count;
    };

    vector<ajeet> ajeet1;

    void upd_table(string output, string new_tkn){
        for( int i = 0; i < ajeet1.size(); ++i){
            if( output == ajeet1[i].lex){
                int val = stoi(ajeet1[i].count);
                val=val+1;
                ajeet1[i].count = to_string(val);
                return ;
            }
        }

        ajeet val = {output,  new_tkn, "1"};
        ajeet1.push_back(val);
        
        return ;
    }

    void print_data(){
        sort(ajeet1.begin(), ajeet1.end(), [&](const auto& arg1, const auto& arg2){
            return arg1.lex < arg2.lex;
        });

        ofstream MyFile("answer.txt");
        for(int i = 0; i < ajeet1.size(); ++i){

            MyFile << "                 "<< ajeet1[i].tkn << "               " << ajeet1[i].count << "               " << ajeet1[i].lex << endl; 
        }

        MyFile.close();
        return;
    }
%}

%%
[ \t\n]+                            //whitespace
"{"                             {
                                    int reg1;

                                    while (1){
                                        while ((reg1 = getchar()) != '}' && reg1 != EOF)
                                        ; 

                                        if (reg1 == '}') break;

                                        if (reg1 == EOF){
                                        printf ("Error: EOF in comment.,%d,endl",__LINE__);
                                        break;
                                        }
                                    }
                                }
\'[^\'\"]*\'|\"[^\"\']*\"    {
        string tmp{ "STRING" };
        upd_table( yytext, tmp);
                }   
                                          
"ARRAY"|"BEGIN"|"BOOLEAN"|"COMMENT"|"CONTINUE"|"DO"|"DOUBLE"|"ELSE"|"END"|"FALSE"|"FOR"|"IF"|"INTEGER"|"LABEL"|"LIST"|"LONG"|"OWN"|"PROCEDURE"|"STEP"|"SWITCH"|"THEN"|"TRUE"|"UNTIL"|"VALUE"|"WHILE"|"array"|"begin"|"boolean"|"comment"|"continue"|"do"|"double"|"else"|"end"|"false"|"for"|"if"|"integer"|"label"|"list"|"long"|"own"|"procedure"|"step"|"switch"|"then"|"true"|"until"|"value"|"while"         {
                                            std::string tmp{ "KEYWORD" };
                                            upd_table( yytext, tmp);
                                        }
          
                            
"AND"|"OR"|"LEQ"|"LT"|"GEQ"|"GT"|"NOT"|"EQL"|"NEQ"|"and"|"or"|"leq"|"lt"|"geq"|"gt"|"not"|"eql"|"neq"|"^"|"|"|"&"|"<<"|">>"|":="|"+"|"-"|"*"|"/"|"%"        {
                                            std::string tmp{ "OPERATOR" };
                                            upd_table( yytext, tmp);
                                        }
          
"]"|"{"|"}"|"("|")"|";"|":"|","|"\'"|"["   {
        string tmp{ "DELIMITER" };
        upd_table( yytext, tmp);
                                        }                                                       

[a-zA-Z][0-9a-zA-Z]*    {
        string tmp{ "IDENTIFIER" };
        upd_table( yytext, tmp);
                }   
(0[xX][0-9a-fA-F]+)    {
        string tmp{ "HEXADECIMAL" };
        upd_table( yytext, tmp);
            }
([1-9][0-9]*|0)   {
        string tmp{ "INTEGER" };
        upd_table( yytext, tmp);
                    }
[0-9]+(\.[0-9]{1,6})          {
        string tmp{ "FLOATING_POINT" };
        upd_table( yytext, tmp);
                 }                                                           
.                {
         cout << yylineno << " " << yytext << endl;
                 }
%%

 int yywrap(){}

int main(int argc, char *argv[]){
    if(argc < 2){
      cerr << "Invalid" <<endl;
      return 1;
    }

    yyin = fopen(argv[1],"r");
    if(yyin == NULL){
        cerr << "not open" << endl;
        yyterminate();
    }

    string check = argv[1];
    if(check.substr(check.find_last_of(".") + 1) != "knp") {
        cout << " wrong file extension" << endl;
        exit(1);
    }
    yylineno = 1;
    yylex(); 
    print_data();

    return 0;
}
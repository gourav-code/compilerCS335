%{
    #include <stdio.h>
    #include <iostream>
    #include <string>
    #include <vector>
    #include <fstream>
    #include <algorithm>

    struct wholeBox
    {
        std::string lexeme;
        std::string count;
        std::string token;
    };

    std::vector<wholeBox> assign1Box;

    void updateTable(std::string content, std::string newToken){
        int tmpCnt = 0;
        for( int i = 0; i < assign1Box.size(); ++i){
            if( content == assign1Box[i].lexeme){
                int temp = stoi(assign1Box[i].count);
                ++temp;
                assign1Box[i].count = std::to_string(temp);
                return ;
            }
            if (newToken == "KEYWORD" || newToken == "OPERATOR"){
                std::string a,b;
                a.resize(content.size());
                b.resize(assign1Box[i].lexeme.size());
                for (int j=0; j < content.size(); ++j){
                    a[j] = tolower(content[j]);
                }
                for (int j = 0; j < assign1Box[i].lexeme.size(); ++j){
                    b[j] = tolower(assign1Box[i].lexeme[j]);
                }
                if (a == b){
                    int temp = stoi(assign1Box[i].count);
                    ++temp;
                    tmpCnt = temp;
                    assign1Box[i].count = std::to_string(temp);
                }
            }
        }
        if( 0 != tmpCnt ){
            wholeBox temp = {content, std::to_string(tmpCnt), newToken};
            assign1Box.push_back(temp);
            return ;
        }
        wholeBox temp = {content, "1", newToken};
        assign1Box.push_back(temp);
        
        return ;
    }

    void printTable(){
        std::sort(assign1Box.begin(), assign1Box.end(), [&](const auto& a, const auto& b){
            return a.lexeme < b.lexeme;
        });

        std::ofstream MyFile("output.txt");
        MyFile << "___________________________________________________" << std::endl;
        for(int i = 0; i < assign1Box.size(); ++i){
            if(i == 0){
                MyFile << "              "<< "Token" << "            " << "Count" << "            " << "Lexeme" << std::endl;    
                MyFile << "___________________________________________________" << std::endl;
            }
            MyFile << "              "<< assign1Box[i].token << "            " << assign1Box[i].count << "            " << assign1Box[i].lexeme << std::endl; 
        }

        MyFile.close();
        return;
    }
%}
%option yylineno 
%option noyywrap
%%
[ \t\n]+                             /* eat up whitespace */
"{"                             {
                                    register int c;

                                    for (;;)
                                    {
                                        while ((c = yyinput()) != '}' && c != EOF)
                                        ; /* eat up text of comment. */

                                        if (c == '}')
                                        {
                                            break; /* found the end. */
                                        }

                                        if (c == EOF)
                                        {
                                        printf ("Error: EOF in comment.\n");
                                        break;
                                        }
                                    }
                                }
ARRAY|BEGIN|BOOLEAN|COMMENT|CONTINUE|DO|DOUBLE|ELSE|END|FALSE|FOR|IF|INTEGER|LABEL|LIST|LONG|OWN|PROCEDURE|STEP|SWITCH|THEN|TRUE|UNTIL|VALUE|WHILE         {
                                            updateTable( yytext, "KEYWORD");
                                        }
array|begin|boolean|comment|continue|do|double|else|end|false|for|if|integer|label|list|long|own|procedure|step|switch|then|true|until|value|while          {
                                            updateTable( yytext, "KEYWORD");
                                        }                              
AND|OR|LEQ|LT|GEQ|GT|NOT|EQL|NEQ        {   updateTable( yytext, "OPERATOR"); }
and|or|leq|lt|geq|gt|not|eql|neq        {   updateTable( yytext, "OPERATOR"); }                               
":="|"+"|"-"|"*"|"/"|"%"|"^"|"|"|"&"|"<<"|">>"|"<="|">="    {
                                            updateTable( yytext, "OPERATOR");
                                        }
";"|":"|","|"["|"]"|"{"|"}"|"("|")"     {   updateTable( yytext, "DELIMITER");  }                                                       
[a-zA-Z][0-9a-zA-Z]*                    {   updateTable( yytext, "IDENTIFIER");   }
\'[^\'\"]*\'|\"[^\"\']*\"               {   updateTable( yytext, "STRING");   }
(0[xX][0-9a-fA-F]+)                     {   updateTable( yytext, "HEXADECIMAL");  }
([1-9][0-9]*|0)                         {   updateTable( yytext, "INTEGER");  }
[0-9]+(\.[0-9]{1,6})                    {   updateTable( yytext, "FLOATING_POINT");   }                                                           
.                                       { std::cout <<"Error is on line no. " <<yylineno << " and yytext is " << yytext << std::endl; }
%%

int main(int argc, char *argv[]){
    if(argc < 2){
      std::cerr << "program name not given" << std::endl;
      return 1;
    }
    std::string check = argv[1];
    if(check.substr(check.find_last_of(".") + 1) != "knp") {
        std::cout << "File extension is not correct" << std::endl;
        exit(1);
    }

    yyin = fopen(argv[1],"r");
    if(yyin == NULL){
        std::cerr << "program name not able to open.\nMay be file not present" << std::endl;
        yyterminate();
    }
   
    yylineno = 1;
    yylex(); 
    printTable();

    return 0;
}
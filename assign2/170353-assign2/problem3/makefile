CC=g++ -std=c++14 -w
BIN=.
SRC=.

$(BIN)/compiler: $(SRC)/quizparser.cpp $(SRC)/quizlexer.cpp 
	$(CC) -o $@ $^

$(SRC)/quizlexer.cpp: $(SRC)/quizlexer.l
	flex -o $@ $^
	
$(SRC)/quizparser.cpp: $(SRC)/quizparser.y
	bison -d -o $@ $^ 

clean:
	rm -f $(SRC)/quizlexer.cpp $(SRC)/quizparser.hpp $(SRC)/quizparser.cpp $(SRC)/stack.hh $(BIN)/compiler

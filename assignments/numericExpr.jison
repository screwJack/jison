%lex
%%

\n 				{ return 'NEW_LINE'; }
\s+				{ /* skip */ }
[0-9]+			{ return 'NUM'; }
"+"				{ return '+'; }
"-"				{ return '-'; }
"*"				{ return '*'; }
"/"				{ return '/'; }
"^"				{ return '^'; }
"="				{ return '='; }
"("     		{ return '('; }
")"     		{ return ')'; }
[a-zA-Z0-9]+	{ return 'VARIABLE'; }
';'				{ return 'SEMI_COL'}

/lex

%{
	var ParseTree = require('./numericExprLib.js');
	var converter = require('number-to-words');
	var variableStroage = {};
	var result;
%}

%start startingExpr
%left '=' 'SEMI_COL' 'NEW_LINE'
%left '+' '-'
%left '*' '/'
%left '^'
%left UMINUS
%%

startingExpr
	: Expr
		{
			var cloner = require('js-cloner');
			var resultClone = cloner.clone(result);
			console.log("The expression is:", result.toString()," values of variables:",variableStroage," And the answer is:",result.evaluate(resultClone))
		}
	;

Expr
	: Expr NEW_LINE Expr
	| Statement
	;
		
Statement
 	: Statement SEMI_COL
 	| Term
 	;
 	
Term
	: '(' Term ')'
	 	{ $$ = $2 }
	| Term '+' Term
		{ $$ = new ParseTree("+",$1,$3, variableStroage); result = $$;} 
	| Term '-' Term
		{ $$ = new ParseTree("-",$1,$3, variableStroage); result = $$;} 	
	| Term '*' Term
		{ $$ = new ParseTree("*",$1,$3, variableStroage); result = $$;}
	| Term '/' Term
		{ $$ = new ParseTree("/",$1,$3, variableStroage); result = $$;}	
	| Term '^' Term
	    { $$ = new ParseTree("^",$1,$3, variableStroage); result = $$;}
 	| VARIABLE '=' NUM
 		{ variableStroage[$1] = $3; }
 	| NUM
 		{$$ = Number(yytext);}
 	| VARIABLE
 	| SEMI_COL Term
	;

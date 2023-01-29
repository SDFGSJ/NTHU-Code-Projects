#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

#define MAXLEN 256
#define TBLSIZE 64

// Set PRINTERR to 1 to print error message while calling error()
// Make sure you set PRINTERR to 0 before you submit your code
#define PRINTERR 0

// Call this macro to print error message and exit the program
// This will also print where you called it in your program
#define error(errorNum) { \
    if (PRINTERR) \
        fprintf(stderr, "error() called at %d: ", __LINE__); \
    err(errorNum); \
}

//Token types
typedef enum{
    UNKNOWN, END, ENDFILE,
    INT, ID,
    ADDSUB, MULDIV,
    ASSIGN,
    LPAREN, RPAREN,
	OR,XOR,AND,INCDEC
}TokenSet;

//Error types
typedef enum {
    UNDEFINED, MISPAREN, NOTNUMID, NOTFOUND, RUNOUT, NOTLVAL, DIVZERO, SYNTAXERR
}ErrorType;

//Structure of the symbol table
typedef struct {
    int val;
    char name[MAXLEN];
}Symbol;

//Structure of a tree node
typedef struct _Node {
    TokenSet data;
    int val,reg,depth;
    char lexeme[MAXLEN];
    struct _Node *left,*right;
}BTNode;

TokenSet getToken(void);
int match(TokenSet token);
void advance(void);
char* getLexeme(void);
int max(int a,int b){
	if(a>b)	return a;
	else return b;
}
void initTable(void);
int getval(char *str);
int setval(char *str, int val);
BTNode *makeNode(TokenSet tok, const char *lexe);
void freeTree(BTNode *root);

//complete grammar
void statement(void);
BTNode* assign_expr(void);
BTNode* or_expr(void);
BTNode* or_expr_tail(BTNode *left);
BTNode* xor_expr(void);
BTNode* xor_expr_tail(BTNode *left);
BTNode* and_expr(void);
BTNode* and_expr_tail(BTNode *left);
BTNode* addsub_expr(void);
BTNode* addsub_expr_tail(BTNode *left);
BTNode* muldiv_expr(void);
BTNode* muldiv_expr_tail(BTNode *left);
BTNode* unary_expr(void);
BTNode* factor(void);

int evaluateTree(BTNode *root);
int assembly(BTNode* root);
void printPrefix(BTNode *root);
void printInfix(BTNode* root);

//Print error message and exit the program
void err(ErrorType errorNum);

//unused
BTNode* term(void);
BTNode* term_tail(BTNode *left);
BTNode* expr(void);
BTNode* expr_tail(BTNode *left);
/*====================================*/
int sbcount;
Symbol table[TBLSIZE];
TokenSet curToken=UNKNOWN;
char lexeme[MAXLEN];

char prevstr[MAXLEN];
int prevtoken=UNKNOWN;

int isdivide;
int id_at_right;
int reg[8];
/*============================================================================================
lex implementation
============================================================================================*/

TokenSet getToken(void)
{
    int i=0;
    char c='\0';

    while((c=fgetc(stdin))==' ' || c=='\t');
    
    if(isdigit(c)){ //檢查以數字開頭的變數
        lexeme[0] = c;
        c = fgetc(stdin);
        i = 1;
        while (isdigit(c) && i < MAXLEN) {
            lexeme[i] = c;
            ++i;
            c = fgetc(stdin);
        }
        
        if(isalpha(c) || c=='_'){
        	error(SYNTAXERR);
		}
		
        ungetc(c, stdin);
        lexeme[i] = '\0';
        return INT;
    }else if(c=='+' || c=='-'){
    	lexeme[0]=c;
    	c=fgetc(stdin);
    	if(c==lexeme[0]){
    		lexeme[1]=c;
    		lexeme[2]='\0';
    		return INCDEC;
		}else{
			ungetc(c,stdin);
			lexeme[1]='\0';
			return ADDSUB;
		}
    }else if(c == '*' || c == '/'){
        lexeme[0] = c;
        lexeme[1] = '\0';
        return MULDIV;
    }else if(c == '\n'){
        lexeme[0] = '\0';
        return END;
    }else if(c == '='){
        strcpy(lexeme, "=");
        return ASSIGN;
    }else if(c == '('){
        strcpy(lexeme, "(");
        return LPAREN;
    }else if(c == ')'){
        strcpy(lexeme, ")");
        return RPAREN;
    }else if(isalpha(c) || c=='_'){ //變數有可能是以'_'開頭
        lexeme[i]=c,i++;
        c=fgetc(stdin);
        while(isalpha(c) || isdigit(c) || c=='_'){
        	lexeme[i]=c,i++;
        	c=fgetc(stdin);
		}
		ungetc(c,stdin);    //這邊記得將c吐回去
		lexeme[i]='\0';
		return ID;
    }else if(c==EOF){
        return ENDFILE;
    }else if(c=='|'){
    	lexeme[0]='|';
    	lexeme[1]='\0';
    	return OR;
	}else if(c=='^'){
		lexeme[0]='^';
		lexeme[1]='\0';
		return XOR;
	}else if(c=='&'){
		lexeme[0]='&';
		lexeme[1]='\0';
		return AND;
	}else{
        return UNKNOWN;
    }
}

void advance(void){
    curToken=getToken();
}

int match(TokenSet token){
    if(curToken==UNKNOWN)
        advance();
    return token==curToken;
}

char* getLexeme(void){
    return lexeme;
}


/*============================================================================================
parser implementation
============================================================================================*/

void initTable(void){
    strcpy(table[0].name,"x");
    table[0].val=0;
    strcpy(table[1].name,"y");
    table[1].val=0;
    strcpy(table[2].name,"z");
    table[2].val=0;
    sbcount=3;
}

int getval(char *str){
    int i;
    int existed=1;
    for(i=0;i<sbcount;i++)
        if(strcmp(str,table[i].name)==0)
            return table[i].val;

    if(sbcount>=TBLSIZE)
        error(RUNOUT);

	if(existed)
		error(NOTFOUND);
		
    strcpy(table[sbcount].name,str);
    table[sbcount].val=0;
    sbcount++;
    return 0;
}

int setval(char* str,int val){
    int i;
    for(i=0;i<sbcount;i++){
        if(strcmp(str,table[i].name)==0){
            table[i].val=val;
            return val;
        }
    }

    if(sbcount>=TBLSIZE)
        error(RUNOUT);

    strcpy(table[sbcount].name,str);
    table[sbcount].val=val;
    sbcount++;
    return val;
}

BTNode* makeNode(TokenSet tok,const char* lexe){
    BTNode* node=(BTNode*)malloc(sizeof(BTNode));
    strcpy(node->lexeme,lexe);
    //printf("node's lexeme : %s\n",node->lexeme);
    node->data=tok;
    node->val=0;
    node->depth=0;
    node->reg=-1;
    node->left = node->right = NULL;
    return node;
}

void freeTree(BTNode *root){
    if(root!=NULL){
        freeTree(root->left);
        freeTree(root->right);
        free(root);
    }
}

//statement := END | assign_expr END
void statement(void) {
    BTNode* retp=NULL;	
	char c;
    	
	if (match(ENDFILE)) {
		printf("MOV r0 [0]\nMOV r1 [4]\nMOV r2 [8]\nEXIT 0\n");
        exit(0);
    } else if (match(END)) {
        advance();
    } else {
        retp = assign_expr();
        if (match(END)) {
            //printf("ans=%d\n", evaluateTree(retp));
            evaluateTree(retp);
            assembly(retp);
            /*printf("Prefix traversal: ");
            printPrefix(retp);
            printf("\n");
            printf("Infix  traversal: ");
            printInfix(retp);
            printf("\n");*/
            
            freeTree(retp);
            advance();
        } else {
        	//printf("curtoken=%d\n",curToken);
            error(SYNTAXERR);
        }
    }
}

BTNode* assign_expr(void){
	BTNode *node=NULL,*left=NULL;
	if(match(ID)){
		prevtoken=ID;
		strcpy(prevstr,getLexeme());
		
		advance();
		
		if(match(END) || match(ENDFILE) || match(RPAREN)){
			node=makeNode(ID,prevstr);
			memset(prevstr,0,sizeof(prevstr));
			prevtoken=UNKNOWN;
		}else if(match(ID) || match(INT) || match(UNKNOWN) || match(LPAREN) || match(INCDEC)){
			err(SYNTAXERR);
		}else{
			if(match(ASSIGN)){
				left=makeNode(ID,prevstr);
				node = makeNode(ASSIGN,getLexeme());
				
				memset(prevstr,0,sizeof(prevstr));
				prevtoken=UNKNOWN;
				
				advance();
				node->left=left;
				node->right=assign_expr();
				node->depth=max(node->left->depth,node->right->depth)+1;
			}else{
				node=or_expr();
			}
		}
	}else{
		node=or_expr();
	}
	return node;
}
//or_expr := xor_expr or_expr_tail
BTNode* or_expr(void){	//ok!
	BTNode* node=xor_expr();
	return or_expr_tail(node);
}

//or_expr_tail := OR xor_expr or_expr_tail | NiL
BTNode* or_expr_tail(BTNode *left){	//ok!
	BTNode* node=NULL;
	
	if(match(OR)){
		node=makeNode(OR,getLexeme());
		advance();
		node->left=left;
		node->right=xor_expr();
		node->depth=max(node->left->depth,node->right->depth)+1;
		return or_expr_tail(node);
	}else{
		return left;
	}
}

//xor_expr := and_expr xor_expr_tail
BTNode* xor_expr(void){	//ok!
	BTNode* node=and_expr();
	return xor_expr_tail(node);
}

//xor_expr_tail := XOR and_expr xor_expr_tail | NiL
BTNode* xor_expr_tail(BTNode *left){	//ok!
	BTNode* node=NULL;
	
	if(match(XOR)){
		node=makeNode(XOR,getLexeme());
		advance();
		node->left=left;
		node->right=and_expr();
		node->depth=max(node->left->depth,node->right->depth)+1;
		return xor_expr_tail(node);
	}else{
		return left;
	}
}

//and_expr := addsub_expr and_expr_tail | NiL
BTNode* and_expr(void){	//ok!
	BTNode* node=addsub_expr();
	return and_expr_tail(node);
}

//and_expr_tail := AND addsub_expr and_expr_tail | NiL
BTNode* and_expr_tail(BTNode *left){	//ok!
	BTNode* node=NULL;
	
	if(match(AND)){
		node=makeNode(AND,getLexeme());
		advance();
		node->left=left;
		node->right=addsub_expr();
		node->depth=max(node->left->depth,node->right->depth)+1;
		return and_expr_tail(node);
	}else{
		return left;
	}
}

//addsub_expr := muldiv_expr addsub_expr_tail
BTNode* addsub_expr(void){	//ok!
	BTNode* node=muldiv_expr();
	return addsub_expr_tail(node);
}

//addsub_expr_tail := ADDSUB muldiv_expr addsub_expr_tail | NiL
BTNode* addsub_expr_tail(BTNode *left){	//ok!
	BTNode* node=NULL;
	
	if(match(ADDSUB)){
		node=makeNode(ADDSUB,getLexeme());
		advance();
		node->left=left;
		node->right=muldiv_expr();
		node->depth=max(node->left->depth,node->right->depth)+1;
		return addsub_expr_tail(node);
	}else{
		return left;
	}
}

//muldiv_expr := unary_expr muldiv_expr_tail
BTNode* muldiv_expr(void){	//ok!
	BTNode* node=unary_expr();
	return muldiv_expr_tail(node);
}

//muldiv_expr_tail := MULDIV unary_expr muldiv_expr_tail | NiL
BTNode* muldiv_expr_tail(BTNode *left){	//ok!
	BTNode* node=NULL;
	
	if(match(MULDIV)){
		node=makeNode(MULDIV,getLexeme());
		advance();
		node->left=left;
		node->right=unary_expr();
		node->depth=max(node->left->depth,node->right->depth)+1;
		return muldiv_expr_tail(node);
	}else{
		return left;
	}
}

//unary_expr := ADDSUB unary_expr | factor
BTNode* unary_expr(void){
	BTNode* node=NULL;
	
	if(match(ADDSUB) && prevtoken==UNKNOWN){
		node=makeNode(ADDSUB,getLexeme());
		advance();
		node->left=makeNode(INT,"0");
		node->right=unary_expr();
		node->depth=max(node->left->depth,node->right->depth)+1;
	}else{
		node=factor();
	}
	return node;
}



//factor := INT | ID | INCDEC ID | LPAREN assign_expr RPAREN
BTNode* factor(void){
    BTNode *retp = NULL;

    if( match(INT) ){
        retp = makeNode(INT, getLexeme());
        advance();
    }else if( match(ID) ){
        retp = makeNode(ID, getLexeme());
        advance();
    }else if(match(INCDEC)){	//INCDEC ID
    	char* str=getLexeme();
    	char* inc_or_dec;
    	if(str[0]=='+'){
    		inc_or_dec="1";
		}else if(str[0]=='-'){
			inc_or_dec="-1";
		}else{
			error(UNDEFINED);
		}
    	advance();
    	if(match(ID)){
    		retp = makeNode(ASSIGN,"=");
    		retp->depth=2;
    		
    		retp->left=makeNode(ID,getLexeme());
    		
    		retp->right=makeNode(ADDSUB,"+");
    		retp->right->depth=2;
    		
    		retp->right->left=makeNode(ID,getLexeme());
    		retp->right->right=makeNode(INT,inc_or_dec);
    		advance();
		}else{
			error(SYNTAXERR);
		}
	} else if (match(LPAREN)) {
        advance();
        retp = assign_expr();
        if (match(RPAREN))
            advance();
        else
            error(MISPAREN);
    }else if(prevtoken!=UNKNOWN){
    	retp=makeNode(prevtoken,prevstr);
    	
    	prevtoken=UNKNOWN;
    	memset(prevstr,0,sizeof(prevstr));
	}else{
        error(NOTNUMID);
    }
    return retp;
}

void err(ErrorType errorNum){
    if (PRINTERR) {
        fprintf(stderr, "error: ");
        switch (errorNum) {
            case MISPAREN:
                fprintf(stderr, "mismatched parenthesis\n");
                break;
            case NOTNUMID:
                fprintf(stderr, "number or identifier expected\n");
                break;
            case NOTFOUND:
                fprintf(stderr, "variable not defined\n");
                break;
            case RUNOUT:
                fprintf(stderr, "out of memory\n");
                break;
            case NOTLVAL:
                fprintf(stderr, "lvalue required as an operand\n");
                break;
            case DIVZERO:
                fprintf(stderr, "divide by constant zero\n");
                break;
            case SYNTAXERR:
                fprintf(stderr, "syntax error\n");
                break;
            default:
                fprintf(stderr, "undefined error\n");
                break;
        }
    }
    printf("EXIT 1\n");
    exit(0);
}


/*============================================================================================
codeGen implementation
============================================================================================*/
int evaluateTree(BTNode* root){
    int retval = 0, lv = 0, rv = 0,i,j;
	
    if(root != NULL){
        switch(root->data){
            case ID:
            	if(isdivide)
            		id_at_right=1;
                retval = getval(root->lexeme);
                break;
            case INT:
            	retval = atoi(root->lexeme);
                break;
            case ASSIGN:
                rv = evaluateTree(root->right);	//先算出right tree的值
                retval = setval(root->left->lexeme, rv);
                break;
            case ADDSUB:
            case MULDIV:
            	if(root->left->depth > root->right->depth){
            		lv = evaluateTree(root->left);
            		rv = evaluateTree(root->right);
				}else{
					if(strcmp(root->lexeme, "/") == 0)
	                	isdivide=1;
					rv = evaluateTree(root->right);
					lv = evaluateTree(root->left);
				}
                
                
                	
                
                if (strcmp(root->lexeme, "+") == 0) {
                    retval = lv + rv;
                    
                } else if (strcmp(root->lexeme, "-") == 0) {
                    retval = lv - rv;
                    
                } else if (strcmp(root->lexeme, "*") == 0) {
                    retval = lv * rv;
                    
                } else if (strcmp(root->lexeme, "/") == 0) {
                	//retval = lv / rv;
                    if (rv == 0 && !id_at_right)
                        error(DIVZERO);
					id_at_right = isdivide = 0;
                }
                break;
			case OR:
				if(root->left->depth > root->right->depth){
            		lv = evaluateTree(root->left);
            		rv = evaluateTree(root->right);
				}else{
					rv = evaluateTree(root->right);
					lv = evaluateTree(root->left);
				}
                retval = lv | rv;
				break;
			case AND:
				if(root->left->depth > root->right->depth){
            		lv = evaluateTree(root->left);
            		rv = evaluateTree(root->right);
				}else{
					rv = evaluateTree(root->right);
					lv = evaluateTree(root->left);
				}
                retval = lv & rv;
				break;
			case XOR:
				if(root->left->depth > root->right->depth){
            		lv = evaluateTree(root->left);
            		rv = evaluateTree(root->right);
				}else{
					rv = evaluateTree(root->right);
					lv = evaluateTree(root->left);
				}
                retval = lv ^ rv;
				break;
			case INCDEC:
				if(root->left->depth > root->right->depth){
            		lv = evaluateTree(root->left);
            		rv = evaluateTree(root->right);
				}else{
					rv = evaluateTree(root->right);
					lv = evaluateTree(root->left);
				}
				retval = lv + rv;
				break;
            default:
                retval = 0;
        }
    }
    return retval;
}
int assembly(BTNode* root){
    int retval = 0, lv = 0, rv = 0,i,j;

    if(root != NULL){
        switch(root->data){
            case ID:
            	if(isdivide)
            		id_at_right=1;
                retval = getval(root->lexeme);
                
                for(i=0;i<sbcount;i++){	//找這個節點的變數
                	if(strcmp(table[i].name,root->lexeme)==0){
                		break;
					}
				}
				for(j=0;j<8;j++){
					if(!reg[j]){
						reg[j]=1;
						root->reg=j;	//這個node使用的是第j個register
						printf("MOV r%d [%d]\n",j,i*4);
						break;
					}
				}
                break;
            case INT:
            	retval = atoi(root->lexeme);

            	for(i=0;i<8;i++){
            		if(!reg[i]){
            			reg[i]=1;
            			root->reg=i;
            			printf("MOV r%d %d\n",i,retval);
            			break;
					}
				}
                break;
            case ASSIGN:
                rv = assembly(root->right);	//先算出right tree的值
                retval = setval(root->left->lexeme, rv);

                for(i=0;i<sbcount;i++){
                	if(strcmp(table[i].name,root->left->lexeme)==0){
                		break;
					}
				}
                printf("MOV [%d] r%d\n",i*4,root->right->reg);
                root->reg=root->right->reg;	//怕root上面還有東西，所以要先記著right是用哪個register
                break;
            case ADDSUB:
            case MULDIV:
            	if(root->left->depth > root->right->depth){
            		lv = assembly(root->left);
            		rv = assembly(root->right);
				}else{
					if(strcmp(root->lexeme, "/") == 0)
	                	isdivide=1;
					rv = assembly(root->right);
					lv = assembly(root->left);
				}
				
				
                if (strcmp(root->lexeme, "+") == 0) {
                    retval = lv + rv;
                    printf("ADD r%d r%d\n",root->left->reg,root->right->reg);
                    reg[root->right->reg]=0;
                    root->reg=root->left->reg;
                    
                } else if (strcmp(root->lexeme, "-") == 0) {
                    retval = lv - rv;
                    printf("SUB r%d r%d\n",root->left->reg,root->right->reg);
                    reg[root->right->reg]=0;
                    root->reg=root->left->reg;
                    
                } else if (strcmp(root->lexeme, "*") == 0) {
                    retval = lv * rv;
                    printf("MUL r%d r%d\n",root->left->reg,root->right->reg);
                    reg[root->right->reg]=0;
                    root->reg=root->left->reg;
                    
                } else if (strcmp(root->lexeme, "/") == 0) {
                	//retval = lv / rv;
                    if (rv == 0 && !id_at_right)
                        error(DIVZERO);
					id_at_right = isdivide = 0;
                    printf("DIV r%d r%d\n",root->left->reg,root->right->reg);
                    reg[root->right->reg]=0;
                    root->reg=root->left->reg;
                }
                break;
			case OR:
				if(root->left->depth > root->right->depth){
            		lv = assembly(root->left);
            		rv = assembly(root->right);
				}else{
					rv = assembly(root->right);
					lv = assembly(root->left);
				}
                retval = lv | rv;
                printf("OR r%d r%d\n",root->left->reg,root->right->reg);
                reg[root->right->reg]=0;
                root->reg=root->left->reg;
				break;
			case AND:
				if(root->left->depth > root->right->depth){
            		lv = assembly(root->left);
            		rv = assembly(root->right);
				}else{
					rv = assembly(root->right);
					lv = assembly(root->left);
				}
                retval = lv & rv;
                printf("AND r%d r%d\n",root->left->reg,root->right->reg);
                reg[root->right->reg]=0;
                root->reg=root->left->reg;
				break;
			case XOR:
				if(root->left->depth > root->right->depth){
            		lv = assembly(root->left);
            		rv = assembly(root->right);
				}else{
					rv = assembly(root->right);
					lv = assembly(root->left);
				}
                retval = lv ^ rv;
                printf("XOR r%d r%d\n",root->left->reg,root->right->reg);
                reg[root->right->reg]=0;
                root->reg=root->left->reg;
				break;
			case INCDEC:
				if(root->left->depth > root->right->depth){
            		lv = assembly(root->left);
            		rv = assembly(root->right);
				}else{
					rv = assembly(root->right);
					lv = assembly(root->left);
				}
				retval = lv + rv;
				break;
            default:
                retval = 0;
        }
    }
    /*for(int i=0;i<8;i++){
    	printf("%d ",reg[i]);
	}
	printf("\n");*/
    return retval;
}
void printPrefix(BTNode* root){
    if(root!=NULL){
        printf("%s ",root->lexeme);
        printPrefix(root->left);
        printPrefix(root->right);
    }
}
void printInfix(BTNode* root){
	if(root!=NULL){
		printInfix(root->left);
		printf("%s ",root->lexeme);
		printInfix(root->right);
	}
}

/*============================================================================================
main
============================================================================================*/
/*
statement        := END | assign_expr END 
assign_expr      := ID ASSIGN assign_expr | or_expr 
or_expr          := xor_expr or_expr_tail 
or_expr_tail     := OR xor_expr or_expr_tail | NiL 
xor_expr         := and_expr xor_expr_tail 
xor_expr_tail    := XOR and_expr xor_expr_tail | NiL 
and_expr         := addsub_expr and_expr_tail | NiL 
and_expr_tail    := AND addsub_expr and_expr_tail | NiL 
addsub_expr      := muldiv_expr addsub_expr_tail 
addsub_expr_tail := ADDSUB muldiv_expr addsub_expr_tail | NiL 
muldiv_expr      := unary_expr muldiv_expr_tail 
muldiv_expr_tail := MULDIV unary_expr muldiv_expr_tail | NiL 
unary_expr       := ADDSUB unary_expr | factor 
factor           := INT | ID | INCDEC ID | LPAREN assign_expr RPAREN
*/
int main(){
    initTable();
    //printf(">> ");
    while(1){
    	memset(reg,0,sizeof(reg));
        statement();
    }
    return 0;
}

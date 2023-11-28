grammar Linguagem;

@header{
    import java.util.*;
}

@members {
    Variavel x = new Variavel();
    ControleVariavel cv = new ControleVariavel();
    String codigoJava="";
    int escopo;
    int tipo;
    String nome;
    int valor_int;
    float valor_float;
    String valor_string;

    private void indent(StringBuilder code, int level) {
        for (int i = 0; i < level; i++) {
            code.append("\t");
        }
    }

   private void printBraces(StringBuilder code, int level, boolean open) {
        indent(code, level);
        code.append(open ? "{\n" : "}\n");
   }
}

start: declVar 'run' OPENCURLYBRACKETS {codigoJava += "public class Codigo{\n";}
    {codigoJava += "\tpublic static void main(String args[]){\n";}
    declVar
    cmd
    CLOSECURLYBRACKETS
    'end' {codigoJava += "\n\t}\n";}
    {codigoJava += "}\n";}
    {System.out.println(codigoJava);};

declVar: (type SPACE*
    ID SPACE* {
        codigoJava += $ID.text;
        x = new Variavel($ID.text, tipo, 0);
        boolean resultado = cv.adiciona(x);
        if(!resultado){
              System.out.println("A variavel "+x.getNome()+" ja foi declarada");
              System.exit(0);
        }
    } SPACE*
    SEMICOLON {codigoJava += ";\n";}
    )*;

type: ( 'int' {codigoJava += "\tint "; tipo = 0;} | 'string' {codigoJava += "\tString "; tipo = 1;} | 'float' {codigoJava += "\tfloat ";tipo = 2;});

cmd: (cmdif | cmdwhile | cmdfor | cmdwrite | cmdattr | cmdreadint | cmdreadfloat | cmdreadstring | cmdwriteVar)*;

cmdif: 'if' {
        codigoJava += "\n\tif(";
    } comp
    {
        codigoJava += ")";
    } OPENCURLYBRACKETS
    {
        codigoJava += "{\n\t";
    } cmd CLOSECURLYBRACKETS
    {
        codigoJava += "\n\t}\n";
    } ('else'{
        codigoJava += "else";
    } OPENCURLYBRACKETS
    {
        codigoJava += "{\n\t";
    } cmd CLOSECURLYBRACKETS
    {
        codigoJava += "\n\t}\n";
    })?;

cmdwhile: 'while' SPACE* {
        codigoJava += "\n\twhile (";
    } SPACE* comp SPACE* OPENCURLYBRACKETS
    {
        codigoJava += "){\n\t";
    } cmd CLOSECURLYBRACKETS
    {
        codigoJava += "\n\t}";
    };


cmdreadint: 'int' SPACE ID SPACE* '=' SPACE*{
        codigoJava+="\tScanner " + $ID.text + "int = new Scanner(System.in);\n";
    } 'read' OPENBRACKETS 'int' CLOSEBRACKETS{
        codigoJava+="\tint " + $ID.text + " = " + $ID.text + "int.nextLine();\n";
    } SEMICOLON;

cmdreadfloat: 'float' SPACE ID SPACE* '=' SPACE*{
        codigoJava+="\tScanner " + $ID.text + "float = new Scanner(System.in);\n";
    } 'read' OPENBRACKETS 'float' CLOSEBRACKETS{
        codigoJava+="\tfloat " + $ID.text + " = " + $ID.text + "float.nextLine();\n";
    } SEMICOLON;

cmdreadstring: 'string' SPACE ID SPACE* '=' SPACE* {
        codigoJava+="\tScanner " + $ID.text + "string = new Scanner(System.in);\n";
    } 'read' OPENBRACKETS 'string' CLOSEBRACKETS{
        codigoJava+="\tString " + $ID.text + " = " + $ID.text + "string.nextLine();\n";
    } SEMICOLON;

cmdwrite: 'write' SPACE* STRING SPACE* SEMICOLON {
    codigoJava += "\tSystem.out.println(" + $STRING.text + ");\n";
};

cmdwriteVar: 'write' SPACE* ID SPACE* SEMICOLON {
    codigoJava += "\tSystem.out.println(" + $ID.text + ");\n";
};

cmdfor: 'for' SPACE* OPENBRACKETS
        {
            codigoJava += "\tfor (";
        }
        SPACE* cmdattr SPACE* SEMICOLON SPACE*
        {
            codigoJava += "; ";
        }
        SPACE* comp SPACE* SEMICOLON SPACE*
        {
            codigoJava += "; ";
        }
        SPACE* ID SPACE*
        {
            codigoJava += $ID.text;
        }
        SPACE* logicalOperators (ID | NUMBER)? SPACE* CLOSEBRACKETS OPENCURLYBRACKETS
        {
            codigoJava += "){\n\t";
        }
        cmd
    CLOSECURLYBRACKETS
        {
            codigoJava += "\n\t}";
        }
    ;


cmdattr: ID SPACE* {Variavel var1 = cv.busca($ID.text); codigoJava += "\t" + $ID.text;}
         EQUAL SPACE* {codigoJava += " = ";}
         (SPACE* ID  SPACE*{Variavel var2 = cv.busca($ID.text);
                if(var1.getTipo()!=var2.getTipo()){
                     System.out.println("Atribuição invalida");
                     System.exit(0);
                }
             codigoJava += $ID.text+";\n";}
         | SPACE* NUMBER SPACE*{codigoJava += $NUMBER.text + "\n";})
         ;

comp: (SPACE* ID SPACE* {codigoJava += $ID.text;} | SPACE* NUMBER SPACE*{codigoJava += $NUMBER.text;}) relationalOperators (SPACE* ID SPACE*{codigoJava += $ID.text;} | SPACE* NUMBER SPACE*{codigoJava += $NUMBER.text;});

logicalOperators: (SPACE* '+' SPACE* {codigoJava += " + ";} | SPACE* '-' SPACE*{codigoJava += " - ";} | SPACE* '/' SPACE*{codigoJava += " / ";} | SPACE* '*' SPACE*{codigoJava += " * ";} | SPACE* '++' SPACE*{codigoJava += "++ ";} | SPACE* '--' SPACE*{codigoJava += "-- ";});
relationalOperators: (SPACE* '>' SPACE* {codigoJava += " > ";} | SPACE* '<' SPACE*{codigoJava += " < ";} | SPACE* '>=' SPACE* {codigoJava += " >= ";} | SPACE* '<=' SPACE* {codigoJava += " <= ";} | SPACE* '==' SPACE*{codigoJava += " == ";} | SPACE* '!=' SPACE*{codigoJava += " != ";}) ;

ID: [A-Za-z]+[0-9]*;
NUMBER: [0-9]+.?[0-9]*;
SEMICOLON: ';';
OPENCURLYBRACKETS: '{' ;
CLOSECURLYBRACKETS: '}' ;
OPENBRACKETS: '(' ;
CLOSEBRACKETS: ')' ;
SPACE: [ \t];
EQUAL: '=';
WS: [ \t\r\n]+ -> skip;
STRING: '"' .*? '"' ;
grammar Linguagem;

@header{
    import java.util.*;
    import java.util.Scanner;
}

@members {
      Variavel x = new Variavel();
      ControleVariavel cv = new ControleVariavel();
      String codigoJava="";
      int escopo;
      int tipo;
      String nome;
}

start: declVar 'run' OPENCURLYBRACKETS {codigoJava += "public class Codigo{\n";}
    {codigoJava += "\tpublic static void main(String args[]){\n";}
    declVar
    cmd
    CLOSECURLYBRACKETS
    'end' {codigoJava += "\n\t}\n";}
    {codigoJava += "}\n";}
    {System.out.println(codigoJava);};

declVar: (type
    ID {
        codigoJava += $ID.text;
        x = new Variavel($ID.text, tipo, 0);
        boolean resultado = cv.adiciona(x);
        if(!resultado){
              System.out.println("A variavel "+x.getNome()+" ja foi declarada");
              System.exit(0);
        }
    }
    SEMMICOLLON {codigoJava += ";\n";}
    )*;

type: ( 'int' {codigoJava += "\tint "; tipo = 0;} | 'string'{codigoJava += "\tchar "; tipo = 1;} | 'float'{codigoJava += "\tfloat ";tipo = 2;});

cmd: cmdif | cmdwhile | cmdfor | cmdread | cmdwrite | cmdattr;

cmdif: 'if' {
        codigoJava: += "\n\tif(";
    } comp
    {
        codigoJava += ")";
    } '{' OPENCURLYBRACKETS
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

cmdwhile: 'while' {
        codigoJava += "\twhile (";
    } comp
    {
        codigoJava += "){\n\t";
    } cmd CLOSECURLYBRACKETS
    {
        codigoJava += "\n\t}"
    };

cmdread: 'read' {
            codigoJava += "\tScanner sc = new Scanner(";
         } ID
         {
            codigoJava += $ID.text+")";
         } SEMMICOLLON {codigoJava+=";\n";};

cmdwrite: 'write' {
        codigoJava += "\tSystem.out.println(";
    } ID {
        codigoJava += $ID.text+")";
    } SEMMICOLLON {
        codigoJava += ";"
    };

cmdfor: 'for' OPENBRACKETS
    {
        codigoJava += "\tfor (";
    } cmdattr ';'
    {
        codigoJava += "; ";
    } comp ';'
    {
        codigojava += "; ";
    } ID
    {
        codigoJava += $ID.text;
    } logicalOperators (ID{codigoJava += $ID.text} | NUMBER{codigoJava += $NUMBER.text}) CLOSEBRACKETS OPENCURLYBRACKETS
    {
        codigoJava += ") {\n\t";
    } cmd CLOSECURLYBRACKETS
    {
        codigoJava += "\n\t}";
    };

cmdattr: ID {Variavel var1 = cv.busca($ID.text); codigoJava += $ID.text;}
         EQUAL {codigoJava += " = ";}
         (ID {Variavel var2 = cv.busca($ID.text);
                if(var1.getTipo()!=var2.getTipo()){
                     System.out.println("Atribuição invalida");
                     System.exit(0);
                }
             codigoJava += $ID.text+";";}
         | NUMBER{codigoJava += $NUMBER.text;})
         ;

comp: (ID {codigoJava += $ID.text;}| NUMBER{codigoJava += $NUMBER.text;}) relationalOperators (ID {codigoJava += $ID.text;}| NUMBER{codigoJava += $NUMBER.text;});

logicalOperators: ('+'{saida += " + ";} | '-'{saida += " - ";} | '/'{saida += " / ";} | '*'{saida += " * ";});
relationalOperators: ('>'{saida += " > ";} | '<'{saida += " < ";} | '>='{saida += " >= ";} | '<='{saida += " <= ";} | '=='{saida += " == ";} | '!='{saida += " != ";}) ;

ID: [A-Za-z]+;
NUMBER: [0-9]+.?[0-9]*;
SEMMICOLLON: ';';
OPENCURLYBRACKETS: '{' ;
CLOSECURLYBRACKETS: '}' ;
OPENBRACKETS: '(' ;
CLOSEBRACKETS: ')' ;

EQUAL: '=';
WS: [ \t\r\n]+ -> skip;

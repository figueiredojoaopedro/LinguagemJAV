/**
 *
 * @author amgjunior
 */
public class Variavel {
    private String nome;
    private int tipo;
    private int escopo;

    private int valor_int;
    private float valor_float;
    private String valor_string;

    public int getValor_int() {
        return valor_int;
    }

    public void setValor_int(int valor_int) {
        this.valor_int = valor_int;
    }

    public float getValor_float() {
        return valor_float;
    }

    public void setValor_float(float valor_float) {
        this.valor_float = valor_float;
    }


    public String getValor_string() {
        return valor_string;
    }

    public void setValor_string(String valor_string) {
        this.valor_string = valor_string;
    }

    public Variavel(String nome, int tipo, int escopo) {
        this.nome = nome;
        this.tipo = tipo;
        this.escopo = escopo;
    }

    public Variavel() {
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getTipo() {
        return tipo;
    }

    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    public int getEscopo() {
        return escopo;
    }

    public void setEscopo(int escopo) {
        this.escopo = escopo;
    }

    public void imprime(){
        System.out.println("Nome: "+nome+"\nTipo: "+tipo+"\nEscopo: "+escopo);
    }
}

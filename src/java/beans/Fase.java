
package beans;


public class Fase {
    private String id;
    private String codice;
    private String nome;
    private String categoria;
    private String note;
    private String stato;
    private int ordinamento;
    
    public int getOrdinamento() {
        return ordinamento;
    }

    public void setOrdinamento(int ordinamento) {
        this.ordinamento = ordinamento;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }
    
    public String getCodice() {
        return codice;
    }

    public void setCodice(String codice) {
        this.codice = codice;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }
    
    
    
    
    
    
}

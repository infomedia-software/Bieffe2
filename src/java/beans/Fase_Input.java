package beans;


public class Fase_Input {
    
    private String id;
    private String nome;
    private String codice;
    private String categoria;
    private String sequenza;
    private String note;
    private String stato;
    private String esterna;
    
    private String stampa;
    private String allestimento;
    
    private Fase fase;

    public String getStampa() {
        return stampa;
    }

    public void setStampa(String stampa) {
        this.stampa = stampa;
    }

    public String getAllestimento() {
        return allestimento;
    }

    public void setAllestimento(String allestimento) {
        this.allestimento = allestimento;
    }

    public String getEsterna() {
        return esterna;
    }

    public void setEsterna(String esterna) {
        this.esterna = esterna;
    }

    
    public Fase getFase() {
        return fase;
    }

    public void setFase(Fase fase) {
        this.fase = fase;
    }
    
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCodice() {
        return codice;
    }

    public void setCodice(String codice) {
        this.codice = codice;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getSequenza() {
        return sequenza;
    }

    public void setSequenza(String sequenza) {
        this.sequenza = sequenza;
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
    
    
    
}

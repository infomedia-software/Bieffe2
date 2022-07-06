package beans;


public class Precedenza {
    private int id;
    private Attivita attivita;
    private Attivita precedente;
    private String note;
    private double scostamento;
    private String stato;

    public double getScostamento() {
        return scostamento;
    }

    public void setScostamento(double scostamento) {
        this.scostamento = scostamento;
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Attivita getAttivita() {
        return attivita;
    }

    public void setAttivita(Attivita attivita) {
        this.attivita = attivita;
    }

    public Attivita getPrecedente() {
        return precedente;
    }

    public void setPrecedente(Attivita precedente) {
        this.precedente = precedente;
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

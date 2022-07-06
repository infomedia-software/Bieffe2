package beans;


public class Consegna {

    private String id;
    private String tipologia;
    private String data_ritiro;
    private String data_consegna;
    private String soggetto_id;
    private String soggetto_nome;
    private String commessa_numero;
    private String commessa_descrizione;
    private String commessa_cliente;
    private String commessa_note;
    
    private String note;
    
    private String stampa;
    private String allestimento;

    private String situazione;
    
    public String getCommessa_note() {
        return commessa_note;
    }

    public void setCommessa_note(String commessa_note) {
        this.commessa_note = commessa_note;
    }
    
    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    
    public String getCommessa_cliente() {
        return commessa_cliente;
    }

    public void setCommessa_cliente(String commessa_cliente) {
        this.commessa_cliente = commessa_cliente;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTipologia() {
        return tipologia;
    }

    public void setTipologia(String tipologia) {
        this.tipologia = tipologia;
    }

    public String getData_ritiro() {
        return data_ritiro;
    }

    public void setData_ritiro(String data_ritiro) {
        this.data_ritiro = data_ritiro;
    }

    public String getData_consegna() {
        return data_consegna;
    }

    public void setData_consegna(String data_consegna) {
        this.data_consegna = data_consegna;
    }

    public String getSoggetto_id() {
        return soggetto_id;
    }

    public void setSoggetto_id(String soggetto_id) {
        this.soggetto_id = soggetto_id;
    }

    public String getSoggetto_nome() {
        return soggetto_nome;
    }

    public void setSoggetto_nome(String soggetto_nome) {
        this.soggetto_nome = soggetto_nome;
    }

    public String getCommessa_numero() {
        return commessa_numero;
    }

    public void setCommessa_numero(String commessa_numero) {
        this.commessa_numero = commessa_numero;
    }

    public String getCommessa_descrizione() {
        return commessa_descrizione;
    }

    public void setCommessa_descrizione(String commessa_descrizione) {
        this.commessa_descrizione = commessa_descrizione;
    }

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

    public String getSituazione() {
        return situazione;
    }

    public void setSituazione(String situazione) {
        this.situazione = situazione;
    }
    
 
    
    
}

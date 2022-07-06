package beans;

public class OrdineFornitore {

    private String id;
    
    private String numero;
    private String anno;
    
    private String data_creazione;
    private Commessa commessa;
    private Soggetto fornitore;
    private String referente;
    private Indirizzo indirizzo0;
    private Indirizzo indirizzo1;
    
    private String data_ordine;
    private String data_ritiro;
    private String data_consegna;
    
    private double prezzo;
    private String tipologia;
    private String note;
    private String stato;

    private String situazione;
    private String descrizione;
    private double qta;

    private String ddt;
    
    public static String situazione_APERTO="aperto";
    public static String situazione_LAVORATO="lavorato";
    public static String situazione_CHIUSO="chiuso";

    public String getDdt() {
        return ddt;
    }

    public void setDdt(String ddt) {
        this.ddt = ddt;
    }
    
    public String getSituazione() {
        return situazione;
    }

    public void setSituazione(String situazione) {
        this.situazione = situazione;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public double getQta() {
        return qta;
    }

    public void setQta(double qta) {
        this.qta = qta;
    }
    
    
    public String getId() {
        return id;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getAnno() {
        return anno;
    }

    public void setAnno(String anno) {
        this.anno = anno;
    }
    
    
    

    public void setId(String id) {
        this.id = id;
    }

    public String getData_creazione() {
        return data_creazione;
    }

    public void setData_creazione(String data_creazione) {
        this.data_creazione = data_creazione;
    }

    public Commessa getCommessa() {
        return commessa;
    }

    public void setCommessa(Commessa commessa) {
        this.commessa = commessa;
    }

    public Soggetto getFornitore() {
        return fornitore;
    }

    public void setFornitore(Soggetto fornitore) {
        this.fornitore = fornitore;
    }

    public String getReferente() {
        return referente;
    }

    public void setReferente(String referente) {
        this.referente = referente;
    }

    public Indirizzo getIndirizzo0() {
        return indirizzo0;
    }

    public void setIndirizzo0(Indirizzo indirizzo0) {
        this.indirizzo0 = indirizzo0;
    }

    public Indirizzo getIndirizzo1() {
        return indirizzo1;
    }

    public void setIndirizzo1(Indirizzo indirizzo1) {
        this.indirizzo1 = indirizzo1;
    }

    public String getData_ordine() {
        return data_ordine;
    }

    public void setData_ordine(String data_ordine) {
        this.data_ordine = data_ordine;
    }

    public String getData_ritiro() {
        return data_ritiro;
    }

    public void setData_ritiro(String data_ritiro) {
        this.data_ritiro = data_ritiro;
    }

    public double getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(double prezzo) {
        this.prezzo = prezzo;
    }

    public String getTipologia() {
        return tipologia;
    }

    public void setTipologia(String tipologia) {
        this.tipologia = tipologia;
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

    public String getData_consegna() {
        return data_consegna;
    }

    public void setData_consegna(String data_consegna) {
        this.data_consegna = data_consegna;
    }
    
    
}

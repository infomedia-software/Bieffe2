package beans;

import utility.Utility;

public class Commessa {
    
    private String id;
    private String numero;
    private String anno;
    private Soggetto soggetto;
    private String descrizione;
    private String data;
    private String scadenza;
    private String rifofferta;
    private String rifordine;
    private String immagine;
    private double importo;
    private double costoorario;
    private String note;
    private String situazione;
    private String stato;
    private String colore;
    private String data_consegna;
    private String dettagli;
    private String fsc;
    private String pefc;    
    private String allestimento;
    private String stampa;

    private double qta;
    
    private String consegnata;

    public double getQta() {
        return qta;
    }

    public void setQta(double qta) {
        this.qta = qta;
    }

    public String getFsc() {
        return fsc;
    }

    public void setFsc(String fsc) {
        this.fsc = fsc;
    }

    public String getConsegnata() {
        return consegnata;
    }

    public void setConsegnata(String consegnata) {
        this.consegnata = consegnata;
    }
    
    public String getAllestimento() {
        return allestimento;
    }

    public void setAllestimento(String allestimento) {
        this.allestimento = allestimento;
    }

    public String getStampa() {
        return stampa;
    }

    public void setStampa(String stampa) {
        this.stampa = stampa;
    }
    
    public String getData_consegna() {
        return data_consegna;
    }
    
    public String getData_consegna_it() {
        String toReturn="";        
        if(data_consegna!=null){
            if(!data_consegna.equals("") && !data_consegna.startsWith("3001")){
                data_consegna=data_consegna.replace("T", " ");
                toReturn=Utility.convertiDatetimeFormatoIT(data_consegna);                
                toReturn=toReturn.substring(0,10);
            }
        }
        return toReturn;
    }
    
    public void setData_consegna(String data_consegna) {
        this.data_consegna = data_consegna;
    }

    public String getDettagli() {
        return dettagli;
    }

    public void setDettagli(String dettagli) {
        this.dettagli = dettagli;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public Soggetto getSoggetto() {
        return soggetto;
    }

    public void setSoggetto(Soggetto soggetto) {
        this.soggetto = soggetto;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getScadenza() {
        return scadenza;
    }

    public void setScadenza(String scadenza) {
        this.scadenza = scadenza;
    }

    public String getRifofferta() {
        return rifofferta;
    }

    public void setRifofferta(String rifofferta) {
        this.rifofferta = rifofferta;
    }

    public String getRifordine() {
        return rifordine;
    }

    public void setRifordine(String rifordine) {
        this.rifordine = rifordine;
    }

    public String getImmagine() {
        return immagine;
    }

    public void setImmagine(String immagine) {
        this.immagine = immagine;
    }

    public double getImporto() {
        return importo;
    }

    public void setImporto(double importo) {
        this.importo = importo;
    }

    public double getCostoorario() {
        return costoorario;
    }

    public void setCostoorario(double costoorario) {
        this.costoorario = costoorario;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getSituazione() {
        return situazione;
    }

    public void setSituazione(String situazione) {
        this.situazione = situazione;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public String getColore() {
        return colore;
    }

    public void setColore(String colore) {
        this.colore = colore;
    }

    public String getPefc() {
        return pefc;
    }

    public void setPefc(String pefc) {
        this.pefc = pefc;
    }
        
}

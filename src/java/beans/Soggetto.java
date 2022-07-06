
package beans;

import java.util.ArrayList;


public class Soggetto {
    private String id;
    
    private String codice;
    
    private String nome;
    private String cognome;
    
    private String alias;
    private String ragionesociale;
    private String piva;
    private String cf;
   
    public ArrayList<Indirizzo> indirizzi;
    
    private String pec;
    private String tipologia;
    private double costo;
    private String note;
    
    private String stato;

    public Soggetto(){
        indirizzi=new ArrayList<Indirizzo>();        
    }
    
    public void aggiungi_indirizzo(Indirizzo indirizzo_temp){
        indirizzi.add(indirizzo_temp);
    }
    
    

    public ArrayList<Indirizzo> getIndirizzi() {
        return indirizzi;
    }

    public void setIndirizzi(ArrayList<Indirizzo> indirizzi) {
        this.indirizzi = indirizzi;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public String getRagionesociale() {
        return ragionesociale;
    }

    public void setRagionesociale(String ragionesociale) {
        this.ragionesociale = ragionesociale;
    }

    public String getPiva() {
        return piva;
    }

    public void setPiva(String piva) {
        this.piva = piva;
    }

    public String getCf() {
        return cf;
    }

    public void setCf(String cf) {
        this.cf = cf;
    }

    public String getPec() {
        return pec;
    }

    public void setPec(String pec) {
        this.pec = pec;
    }

    public String getTipologia() {
        return tipologia;
    }

    public void setTipologia(String tipologia) {
        this.tipologia = tipologia;
    }

    public double getCosto() {
        return costo;
    }

    public void setCosto(double costo) {
        this.costo = costo;
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


package beans;

import utility.Utility;


public class ActTsk {
    
    private String id;
    
    private Act act;
    private Soggetto soggetto;
    private String inizio;
    private String fine;
    private String note;

    public String commessa_colore(){
        return act.getCommessa().getColore();
    }
    
    public String commessa_numero(){
        return act.getCommessa().getNumero();
    }
    public String commessa_descrizione(){
        return act.getCommessa().getDescrizione();   
    }
    public String commessa_cliente(){
        return act.getCommessa().getSoggetto().getAlias();   
    }
    
    public boolean is_concluso(){
        return (fine!=null);
    }
    
    public Soggetto getSoggetto() {
        return soggetto;
    }

    public void setSoggetto(Soggetto soggetto) {
        this.soggetto = soggetto;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Act getAct() {
        return act;
    }

    public void setAct(Act act) {
        this.act = act;
    }

    public String getInizio() {
        return inizio;
    }
    public String getInizio_it() {
        return Utility.convertiDatetimeFormatoIT(inizio);
    }

    public void setInizio(String inizio) {
        this.inizio = inizio;
    }

    public String getFine() {
        return fine;
    }
    public String getFine_it() {
        return Utility.convertiDatetimeFormatoIT(fine);
    }

    public void setFine(String fine) {
        this.fine = fine;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
   
    
}

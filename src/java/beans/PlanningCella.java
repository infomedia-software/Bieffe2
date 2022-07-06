package beans;

import utility.Utility;


public class PlanningCella {
    
    private String id;
    private String risorsa;
    private String inizio;
    private String fine;
    
    private String valore;
    private String note;
    
    public boolean is_attiva(){
        if(!valore.equals("-1"))
            return true;
        else
            return false;
    }
    
    public String stampa_note(){
        String toReturn=note;
        toReturn=toReturn.replace("{PLANNING_CELLA_OPZIONE_1}", "");
        toReturn=toReturn.replace("{PLANNING_CELLA_OPZIONE_2}", "");
        toReturn=toReturn.replace("{PLANNING_CELLA_OPZIONE_3}", "");
        toReturn=toReturn.replace("{PLANNING_CELLA_OPZIONE_4}", "");
        toReturn=toReturn.replace("{PLANNING_CELLA_OPZIONE_5}", "");
        return toReturn;
    }
    
    public String getInizioData(){
        String toReturn="";
        if(!inizio.equals(""))
            toReturn=inizio.substring(0,10);
        return toReturn;
    }
    
    public int getInizioOra(){
        int toReturn=-1;
        if(!inizio.equals(""))
            toReturn=Utility.convertiStringaInInt(inizio.substring(11,13));
        return toReturn;
    }
    
    public String ora_minuti(){
        String toReturn="";
        toReturn=inizio.substring(11,16);
        return toReturn;
    }
     
     
    public int getInizioMinuti(){
        int toReturn=-1;
        if(!inizio.equals(""))
            toReturn=Utility.convertiStringaInInt(inizio.substring(14,16));
        return toReturn;
    }
    
    
    public String getFineData(){
        String toReturn="";
        if(!fine.equals(""))
            toReturn=fine.substring(0,10);
        return toReturn;
    }
    
     public int getFineOra(){
        int toReturn=-1;
        if(!fine.equals(""))
            toReturn=Utility.convertiStringaInInt(fine.substring(11,13));
        return toReturn;
    }
     
    public int getFineMinuti(){
        int toReturn=-1;
        if(!fine.equals(""))
            toReturn=Utility.convertiStringaInInt(fine.substring(14,16));
        return toReturn;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRisorsa() {
        return risorsa;
    }

    public void setRisorsa(String risorsa) {
        this.risorsa = risorsa;
    }

    public String getInizio() {
        return inizio;
    }

    public void setInizio(String inizio) {
        this.inizio = inizio;
    }

    public String getFine() {
        return fine;
    }

    public void setFine(String fine) {
        this.fine = fine;
    }

    public String getValore() {
        return valore;
    }

    public void setValore(String valore) {
        this.valore = valore;
    }
    
}

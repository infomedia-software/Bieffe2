package beans;

import utility.Utility;

public class Task {

    private String id;
    
    private Commessa commessa;
    private Soggetto soggetto;
    private Risorsa risorsa;    
    private String inizio;
    private String fine;
    private String note;
    private String stato;
    private String id_esterno;
    private String attivo;
    
    private int durata;
    
    private Attivita attivita;
    
    
    public double durata_arrotondata(){                
        double toReturn=0;        
        int hhh = durata / 60;  
        int mmm = durata % 60;  
        
        if(mmm==0){
            toReturn=hhh;
        }
        if(mmm>30){
            toReturn=hhh+1;
        }
        if(mmm > 0 && mmm<=30){
            toReturn=hhh+0.5;
        }    
        return toReturn;
    }
    
    
    public String durata_ore_minuti(){
        String toReturn="";
        int hhh = durata / 60;
        int mmm = durata % 60;
        
        String h=""+hhh;
        
        String m=""+mmm;
        /*
            if(hhh<10);
                h="0"+h;            
            if(mmm<10);
                m="0"+m;        
        */
        toReturn=h+":"+m;
        return toReturn;
    }
    
    public String inizio_data(){
        String inizio_data="";
        if(!inizio.equals(""))
            inizio_data=inizio.substring(0,10);
        return inizio_data;
    }
    
    public String inizio_orario(){
        String inizio_ora="";
        if(!inizio.equals(""))
            inizio_ora=inizio.substring(11,19);
        return inizio_ora;
    }
    
    public int inizio_ora(){
        int toReturn=-1;
        if(!inizio.equals(""))
            toReturn=Utility.convertiStringaInInt(inizio.substring(11,13));
        return toReturn;
    }
     
    public int inizio_minuti(){
        int toReturn=-1;
        if(!inizio.equals(""))
            toReturn=Utility.convertiStringaInInt(inizio.substring(14,16));
        return toReturn;
    }

    
    public int getDurata() {
        return durata;
    }

    public void setDurata(int durata) {
        this.durata = durata;
    }
    
    
    public String getAttivo() {
        return attivo;
    }

    public void setAttivo(String attivo) {
        this.attivo = attivo;
    }
    
    public Commessa getCommessa() {
        return commessa;
    }

    public void setCommessa(Commessa commessa) {
        this.commessa = commessa;
    }

    public String getId_esterno() {
        return id_esterno;
    }

    public void setId_esterno(String id_esterno) {
        this.id_esterno = id_esterno;
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

    
    public Risorsa getRisorsa() {
        return risorsa;
    }

    public void setRisorsa(Risorsa risorsa) {
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

    public Attivita getAttivita() {
        return attivita;
    }

    public void setAttivita(Attivita attivita) {
        this.attivita = attivita;
    }
    
    
    
    
    
}

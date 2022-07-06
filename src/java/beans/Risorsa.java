package beans;

import utility.Utility;

public class Risorsa {
    private String id;
    private String codice;
    private String nome;
    private String ordinamento;
    private String note;
    private String stato;
    
    private Fase fase;
    
    private String fasi_input;
    private String fasi_produzione;
    
    private String reparti;
    private String planning;
    
    private String inizio;
    private String fine;
    private String inizio2;
    private String fine2;
    private String inizio3;
    private String fine3;

    
    public int inizio_ora(){
        int toReturn=0;
        if(!inizio.equals("")){
            toReturn=Utility.convertiStringaInInt(inizio.substring(11,13));
        }
        return toReturn;
    }

    public int inizio_minuti(){
        int toReturn=0;
        if(!inizio.equals("")){
            toReturn=Utility.convertiStringaInInt(inizio.substring(13,14));
        }
        return toReturn;
    }

    public String getFasi_produzione() {
        return fasi_produzione;
    }

    public void setFasi_produzione(String fasi_produzione) {
        this.fasi_produzione = fasi_produzione;
    }

    
    
    public void setInizio2(String inizio2) {
        this.inizio2 = inizio2;
    }

    public void setFine2(String fine2) {
        this.fine2 = fine2;
    }

    public void setInizio3(String inizio3) {
        this.inizio3 = inizio3;
    }

    public void setFine3(String fine3) {
        this.fine3 = fine3;
    }

    
    public String stampa(){
        return codice+" "+nome;
    }
    

    public String getFasi_input() {
        return fasi_input;
    }

    public void setFasi_input(String fasi_input) {
        this.fasi_input = fasi_input;
    }
    

    public Fase getFase() {
        return fase;
    }

    public void setFase(Fase fase) {
        this.fase = fase;
    }

    
    public String getCodice() {
        return codice;
    }
    
    public void setCodice(String codice) {
        this.codice = codice;
    }

    public String getReparti() {
        return reparti;
    }

    public void setReparti(String reparti) {
        this.reparti = reparti;
    }

    public String getPlanning() {
        return planning;
    }

    public void setPlanning(String planning) {
        this.planning = planning;
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

    public String getOrdinamento() {
        return ordinamento;
    }

    public void setOrdinamento(String ordinamento) {
        this.ordinamento = ordinamento;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public String getInizio2() {
        return inizio2;
    }

    public String getFine2() {
        return fine2;
    }

    public String getInizio3() {
        return inizio3;
    }

    public String getFine3() {
        return fine3;
    }
    
    
    
    
    
    
}

package beans;

import gestioneDB.GestionePlanning;
import utility.Utility;

public class Attivita {
    
    private String id;   
    private Commessa commessa;
    private Risorsa risorsa;
    private String descrizione;
    private String inizio;
    private String fine;
    private String id_act;
    private int ore;
    private int minuti;
    private double durata;
    
    private double durata_tasks;
    private String inizio_tasks;
    
    
    private double ritardo;
    private String carta;  
    
    private double seq;         // Indica la sequenza con cui dovrà essere realizzata l'attività
    private double seq_input;   // Indica la sequenza con cui dovrà essere realizzata l'attività
    
    private String bloccata;
    
    private String note;
    
    private String errore;
    
    private String situazione;
    private String completata;
    private String stato;

    private Fase_Input fase_input;

    private double scostamento;
    
    private String libero1;
    private String libero2;
    private String libero3;
    private String libero4;
    private String libero5;
    private String libero6;
    private String libero7;
    
    private String attiva;
    
    public static String DAPROGRAMMARE="da programmare";
    public static String INPROGRAMMAZIONE="in programmazione";
    
    private String task;
    
    private String attesa_fornitore;
    private String id_ordine_fornitore;
    private String descrizione_ordine_fornitore;
    private String note_ordine_fornitore;
    private String specifiche_tecniche;
    private String composizione;
    private double qta_ordine_fornitore;
    private double prezzo_ordine_fornitore;
    private Soggetto fornitore_preventivo;
    
    public OrdineFornitore ordine_fornitore;
    
    private String attiva_infogest;
    
    public String toString(){
        return  descrizione+" | "+commessa.getNumero()+" "+commessa.getSoggetto().getAlias()+" - "+commessa.getDescrizione();
    }
    
    /***
     * Conta il numero di celle occupate nella data in input
     * @param data
     * @param planning_ora_inizio
     * @param planning_ora_fine
     * @return 
     */
     
    public int contaCelleOccupate(String data,String planning_ora_inizio,String planning_ora_fine){
        String inizio_temp="";
        String fine_temp="";
        
        inizio_temp=inizio;
        fine_temp=fine;            
        if(Utility.compareTwoTimeStamps(inizio,planning_ora_inizio)<0)
            inizio_temp=planning_ora_inizio;
        
        if(Utility.compareTwoTimeStamps(fine, planning_ora_fine)>0)
            fine_temp=planning_ora_fine;

        double minuti=Utility.compareTwoTimeStamps(fine_temp,inizio_temp);
        int toReturn=(int)(minuti/60*2);        
        return toReturn;
    }
    
     public boolean is_in_planning(){
        boolean toReturn=false;
        String prima_data_planning=GestionePlanning.getIstanza().prima_data_planning();
        if(Utility.viene_prima(prima_data_planning, inizio))
            toReturn=true;
        return toReturn;
    }
    
    public boolean is_in_programmazione(){
        boolean toReturn=false;
        if(situazione.equals(Attivita.INPROGRAMMAZIONE) && !inizio.startsWith("3001-01-01") && !fine.startsWith("3001-01-01") && !risorsa.getId().equals(""))
            toReturn=true;
        return toReturn;
    }
    
    public boolean is_da_programmare(){
        return (situazione.equals(Attivita.DAPROGRAMMARE));
    }
    
    public boolean is_completata(){
        return completata.toLowerCase().equals("si");
    }
    
    public boolean is_attiva_infogest(){
        if(attiva_infogest.toLowerCase().equals("si"))
            return true;
        else
            return false;
    }

    public String getAttiva_infogest() {
        return attiva_infogest;
    }

    public void setAttiva_infogest(String attiva_infogest) {
        this.attiva_infogest = attiva_infogest;
    }

    public String getCarta() {
        return carta;
    }

    public void setCarta(String carta) {
        this.carta = carta;
    }
    
    
    public OrdineFornitore getOrdine_fornitore() {
        return ordine_fornitore;
    }

    public void setOrdine_fornitore(OrdineFornitore ordine_fornitore) {
        this.ordine_fornitore = ordine_fornitore;
    }

    public Soggetto getFornitore_preventivo() {
        return fornitore_preventivo;
    }

    public void setFornitore_preventivo(Soggetto fornitore_preventivo) {
        this.fornitore_preventivo = fornitore_preventivo;
    }
    
    public static String getDAPROGRAMMARE() {
        return DAPROGRAMMARE;
    }

    public static void setDAPROGRAMMARE(String DAPROGRAMMARE) {
        Attivita.DAPROGRAMMARE = DAPROGRAMMARE;
    }

    public double getPrezzo_ordine_fornitore() {
        return prezzo_ordine_fornitore;
    }

    public void setPrezzo_ordine_fornitore(double prezzo_ordine_fornitore) {
        this.prezzo_ordine_fornitore = prezzo_ordine_fornitore;
    }

    public String getAttesa_fornitore() {
        return attesa_fornitore;
    }

    public void setAttesa_fornitore(String attesa_fornitore) {
        this.attesa_fornitore = attesa_fornitore;
    }

    public String getId_ordine_fornitore() {
        return id_ordine_fornitore;
    }

    public void setId_ordine_fornitore(String id_ordine_fornitore) {
        this.id_ordine_fornitore = id_ordine_fornitore;
    }

    public String getDescrizione_ordine_fornitore() {
        return descrizione_ordine_fornitore;
    }

    public void setDescrizione_ordine_fornitore(String descrizione_ordine_fornitore) {
        this.descrizione_ordine_fornitore = descrizione_ordine_fornitore;
    }

    public String getNote_ordine_fornitore() {
        return note_ordine_fornitore;
    }

    public void setNote_ordine_fornitore(String note_ordine_fornitore) {
        this.note_ordine_fornitore = note_ordine_fornitore;
    }
   

    public double getQta_ordine_fornitore() {
        return qta_ordine_fornitore;
    }

    public void setQta_ordine_fornitore(double qta_ordine_fornitore) {
        this.qta_ordine_fornitore = qta_ordine_fornitore;
    }

    public String getSpecifiche_tecniche() {
        return specifiche_tecniche;
    }

    public void setSpecifiche_tecniche(String specifiche_tecniche) {
        this.specifiche_tecniche = specifiche_tecniche;
    }

    public String getComposizione() {
        return composizione;
    }

    public void setComposizione(String composizione) {
        this.composizione = composizione;
    }
    
    /****
     * Metodo che arrotondata la durata dei task (memorizzata in minuti) nel valore utile per ore
     *  es. 125 minuti -> 2.5 h
    */
    public double durata_tasks_arrotondata(){
        return Utility.converti_durata_task_per_attivita((int)durata_tasks);
    }
    
    
    public String getAttiva() {
        return attiva;
    }

    public void setAttiva(String attiva) {
        this.attiva = attiva;
    }
    
     public String inizio_task_data(){
        String inizio_data="";
        if(!inizio_tasks.equals(""))
            inizio_data=inizio_tasks.substring(0,10);
        return inizio_data;
    }
    
    public String inizio_task_orario(){
        String inizio_ora="";
        if(!inizio_tasks.equals(""))
            inizio_ora=inizio_tasks.substring(11,19);
        return inizio_ora;
    }
    
    public int inizio_task_ora(){
        int toReturn=-1;
        if(!inizio_tasks.equals(""))
            toReturn=Utility.convertiStringaInInt(inizio_tasks.substring(11,13));
        return toReturn;
    }
     
    public int inizio_task_minuti(){
        int toReturn=-1;
        if(!inizio_tasks.equals(""))
            toReturn=Utility.convertiStringaInInt(inizio_tasks.substring(14,16));
        return toReturn;
    }

    
    

    public String getTask() {
        return task;
    }

    public void setTask(String task) {
        this.task = task;
    }

    public double getDurata_tasks() {
        return durata_tasks;
    }

    public void setDurata_tasks(double durata_tasks) {
        this.durata_tasks = durata_tasks;
    }

    public String getInizio_tasks() {
        return inizio_tasks;
    }

    public void setInizio_tasks(String inizio_tasks) {
        this.inizio_tasks = inizio_tasks;
    }
    

    public Fase_Input getFase_input() {
        return fase_input;
    }

    public void setFase_input(Fase_Input fase_input) {
        this.fase_input = fase_input;
    }
    public double getSeq_input() {
        return seq_input;
    }

    public void setSeq_input(double seq_input) {
        this.seq_input = seq_input;
    }
    
    public double getRitardo() {
        return ritardo;
    }

    public void setRitardo(double ritardo) {
        this.ritardo = ritardo;
    }

    public String getCompletata() {
        return completata;
    }

    public void setCompletata(String completata) {
        this.completata = completata;
    }
  
    public double getSeq() {
        return seq;
    }

    public void setSeq(double seq) {
        this.seq = seq;
    }
    
    public String getInizioData(){
        String toReturn="";
        if(!inizio.equals(""))
            toReturn=inizio.substring(0,10);
        return toReturn;
    }
    
        
    public String getInizioOrario(){
        String toReturn="";
        if(!inizio.equals(""))
            toReturn=inizio.substring(11,16);
        return toReturn;
    }
    
    public int getInizioOra(){
        int toReturn=-1;
        if(!inizio.equals(""))
            toReturn=Utility.convertiStringaInInt(inizio.substring(11,13));
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
    public String getFineOrario(){
        String toReturn="";
        if(!fine.equals(""))
            toReturn=fine.substring(11,16);
        return toReturn;
    }
    
        
    public double getDurata(){
        double toReturn=0;
        toReturn=toReturn+ore;
        if(minuti==30)
            toReturn=toReturn+0.5;
        return toReturn;
    }
    
    
    
    public String getErrore() {
        return errore;
    }

    public void setErrore(String errore) {
        this.errore = errore;
    }

    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSituazione() {
        return situazione;
    }

    public void setSituazione(String situazione) {
        this.situazione = situazione;
    }
    
    public Commessa getCommessa() {
        return commessa;
    }

    public void setCommessa(Commessa commessa) {
        this.commessa = commessa;
    }

    public Risorsa getRisorsa() {
        return risorsa;
    }

    public void setRisorsa(Risorsa risorsa) {
        this.risorsa = risorsa;
    }


    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getInizio() {
        return inizio;
    }
    public String getInizio_it() {
        String toReturn="";
        
        if(inizio!=null){
            if(!inizio.equals("") && !inizio.startsWith("3001")){
                String temp=Utility.convertiDatetimeFormatoIT(inizio);
                toReturn=temp.substring(0,16);
            }
        }
        return toReturn;
        
    }
    
    public String getFine_it() {
        String toReturn="";
        if(fine!=null){
            if(!fine.equals("") && !fine.startsWith("3001")){                
                String temp=Utility.convertiDatetimeFormatoIT(fine);
                toReturn=temp.substring(0,16);
            }
        }
        return toReturn;        
    }
    
    public String getFine_data(){
        String toReturn="";
        if(fine!=null){
            if(!fine.equals("") && !fine.startsWith("3001")){                                
                toReturn=fine.substring(0,10);
            }
        }
        return toReturn;   
    }

    public String getFine_orario(){
        String toReturn="";
        if(fine!=null){
            if(!fine.equals("") && !fine.startsWith("3001")){                                
                toReturn=fine.substring(11,16);
            }
        }
        return toReturn;   
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

    public int getOre() {
        return ore;
    }

    public void setOre(int ore) {
        this.ore = ore;
    }

    public int getMinuti() {
        return minuti;
    }

    public void setMinuti(int minuti) {
        this.minuti = minuti;
    }

  
    public String getBloccata() {
        return bloccata;
    }

    public void setBloccata(String bloccata) {
        this.bloccata = bloccata;
    }

    
    
    public String getNote() {
        if(note.equals("null"))
            note="";
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

    public double getScostamento() {
        return scostamento;
    }

    public void setScostamento(double scostamento) {
        this.scostamento = scostamento;
    }

    public String getLibero1() {
        return libero1;
    }

    public void setLibero1(String libero1) {
        this.libero1 = libero1;
    }

    public String getLibero2() {
        return libero2;
    }

    public void setLibero2(String libero2) {
        this.libero2 = libero2;
    }

    public String getLibero3() {
        return libero3;
    }

    public void setLibero3(String libero3) {
        this.libero3 = libero3;
    }

    public String getLibero4() {
        return libero4;
    }

    public void setLibero4(String libero4) {
        this.libero4 = libero4;
    }

    public String getLibero5() {
        return libero5;
    }

    public void setLibero5(String libero5) {
        this.libero5 = libero5;
    }

    public String getLibero6() {
        return libero6;
    }

    public void setLibero6(String libero6) {
        this.libero6 = libero6;
    }

    public String getLibero7() {
        return libero7;
    }

    public void setLibero7(String libero7) {
        this.libero7 = libero7;
    }

    public static String getINPROGRAMMAZIONE() {
        return INPROGRAMMAZIONE;
    }

    public static void setINPROGRAMMAZIONE(String INPROGRAMMAZIONE) {
        Attivita.INPROGRAMMAZIONE = INPROGRAMMAZIONE;
    }

    public String getId_act() {
        return id_act;
    }

    public void setId_act(String id_act) {
        this.id_act = id_act;
    }
      
    
    
    
    
}

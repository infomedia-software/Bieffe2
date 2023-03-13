package beans;

import utility.Utility;


public class Act {

    private String id;
    private Commessa commessa;
    private ActRes act_res;
    private Fase fase;
    
    private String descrizione;
    private String inizio;
    private String fine;
    private double durata;
    private double ritardo;
    private String programmata;    
    private String completata;
    private String attiva;    
    private String note;
    private String libero1;
    private String libero2;
    private String libero3;
    private String libero4;
    private String libero5;
    private String libero6;
    private String libero7;
    private String libero8;
    private String libero9;
    private String libero10;
    
    private String data_creazione;
    private String data_modifica;
    
    private String stato;
    
    
    public String colore(){
        return commessa.getColore();        
    }
    
    public String commessa(){
        return commessa.getNumero()+" "+commessa.getDescrizione();        
    }
    public String commessa_numero(){
        return commessa.getNumero();
    }
    public String commessa_descrizione(){
        return commessa.getDescrizione();        
    }
    public String commessa_colore(){
        return commessa.getColore();        
    }
    
    public String cliente(){
        return commessa.getSoggetto().getAlias();        
    }
    
    
    public boolean occupa_data_ora(String data,String ora){
        boolean toReturn=false;
        String data_ora=data+" "+ora+":00.0";            
        if(Utility.viene_prima(inizio, data_ora) && Utility.viene_prima(data_ora, fine) && !fine.equals(data_ora) )
            toReturn=true;             
        return toReturn;
    }
    
    public boolean is_completata(){
        return completata.equals("si");
    }
    public boolean is_attiva(){
        return attiva.equals("si");
    }

    
    public String inizio_data(){
        String toReturn="";
        if(inizio!=null)
            toReturn=inizio.substring(0,10);        
        return toReturn;
    }
    
     public String inizio_ora(){
        String toReturn="";
        if(inizio!=null)
            toReturn=inizio.substring(11,16);        
        return toReturn;
    }
            
    public String fine_data(){
        String toReturn="";
        if(fine!=null)
            toReturn=fine.substring(0,10);        
        return toReturn;
    }
    
     public String fine_ora(){
        String toReturn="";
        if(fine!=null)
            toReturn=fine.substring(11,16);        
        return toReturn;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Commessa getCommessa() {
        return commessa;
    }

    public void setCommessa(Commessa commessa) {
        this.commessa = commessa;
    }

    public ActRes getAct_res() {
        return act_res;
    }

    public void setAct_res(ActRes act_res) {
        this.act_res = act_res;
    }

    public Fase getFase() {
        return fase;
    }

    public void setFase(Fase fase) {
        this.fase = fase;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getInizio() {
        String toReturn="";
        if(inizio!=null){
            toReturn=inizio.substring(0,16);
        }
        return toReturn;
    }
    public String getInizio_string() {
        String toReturn="";
            if(inizio!=null){
                toReturn=Utility.convertiDatetimeFormatoIT(inizio).substring(0,16);
            }
        return toReturn;
    }

    public void setInizio(String inizio) {
        this.inizio = inizio;
    }

    public String getFine() {
        String toReturn="";
        if(fine!=null){
            toReturn=fine.substring(0,16);
        }
        return toReturn;
    }
    
    public String getFine_string() {
        String toReturn="";
            if(fine!=null){
                toReturn=Utility.convertiDatetimeFormatoIT(fine).substring(0,16);
            }
        return toReturn;
    }

    public void setFine(String fine) {
        this.fine = fine;
    }

    public double getDurata() {
        return durata;
    }
    public String getDurata_string() {
        return Utility.elimina_zero(durata);
    }

    public void setDurata(double durata) {
        this.durata = durata;
    }

    public double getRitardo() {
        return ritardo;
    }

    public void setRitardo(double ritardo) {
        this.ritardo = ritardo;
    }

    public String getProgrammata() {
        return programmata;
    }

    public void setProgrammata(String programmata) {
        this.programmata = programmata;
    }

    public String getCompletata() {
        return completata;
    }

    public void setCompletata(String completata) {
        this.completata = completata;
    }

    public String getAttiva() {
        return attiva;
    }

    public void setAttiva(String attiva) {
        this.attiva = attiva;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
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

    public String getLibero8() {
        return libero8;
    }

    public void setLibero8(String libero8) {
        this.libero8 = libero8;
    }

    public String getLibero9() {
        return libero9;
    }

    public void setLibero9(String libero9) {
        this.libero9 = libero9;
    }

    public String getLibero10() {
        return libero10;
    }

    public void setLibero10(String libero10) {
        this.libero10 = libero10;
    }

    public String getData_creazione() {
        return data_creazione;
    }

    public void setData_creazione(String data_creazione) {
        this.data_creazione = data_creazione;
    }

    public String getData_modifica() {
        return data_modifica;
    }

    public void setData_modifica(String data_modifica) {
        this.data_modifica = data_modifica;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }
    
    
    
}

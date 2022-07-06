package utility;

import java.util.ArrayList;


public class Th {
    
    private String id;
    private String campo_db;
    private String testo;
    private String tipo;
    private int ordinamento;
    private String width;
    private String valore_iniziale;
    private ArrayList<String> opzioni;

    public static String tipo_TEXT="text";
    public static String tipo_DATE="date";
    public static String tipo_NUMBER="number";
    public static String tipo_SELECT="select";
    
    public Th(){
        opzioni=new ArrayList<String>();
        width="auto";
    }

    public String getValore_iniziale() {
        return valore_iniziale;
    }

    public void setValore_iniziale(String valore_iniziale) {
        this.valore_iniziale = valore_iniziale;
    }
    
    public String getId() {
        return id;
    }

    public String getWidth() {
        return width;
    }

    public void setWidth(String width) {
        this.width = width;
    }


    public void setId(String id) {
        this.id = id;
    }

    public String getCampo_db() {
        return campo_db;
    }

    public void setCampo_db(String campo_db) {
        this.campo_db = campo_db;
    }

    public String getTesto() {
        return testo;
    }

    public void setTesto(String testo) {
        this.testo = testo;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public int getOrdinamento() {
        return ordinamento;
    }

    public void setOrdinamento(int ordinamento) {
        this.ordinamento = ordinamento;
    }

    public ArrayList<String> getOpzioni() {
        return opzioni;
    }

    public void setOpzioni(ArrayList<String> opzioni) {
        this.opzioni = opzioni;
    }
    
    
    
    
    
    
}

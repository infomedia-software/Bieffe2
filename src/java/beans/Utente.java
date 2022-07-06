package beans;


public class Utente extends Soggetto{
    
    private String nomeutente;
    private String password;    
    private String privilegi;

    
    public static String AMMINISTRATORE="amministratore";
    public static String UFFICIO="ufficio";
    public static String REPARTO="reparto";
    public static String MAGAZZINO="magazzino";
    public static String MONTAGGIO="montaggio";
    
    
    public boolean is_montaggio(){
        return privilegi.equals(MONTAGGIO);
    }
    public boolean is_magazzino(){
        return privilegi.equals(MAGAZZINO);
    }
    
    public boolean is_amministratore(){
        return privilegi.equals(AMMINISTRATORE);
    }
    
    public boolean is_ufficio(){
        return privilegi.equals(UFFICIO);
    }
    
    public boolean is_reparto(){
        return privilegi.equals(REPARTO);
    }
    
    public String getNomeutente() {
        return nomeutente;
    }

    public void setNomeutente(String nomeutente) {
        this.nomeutente = nomeutente;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPrivilegi() {
        return privilegi;
    }

    public void setPrivilegi(String privilegi) {
        this.privilegi = privilegi;
    }

    
    
    
}

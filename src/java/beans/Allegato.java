package beans;

public class Allegato {

    private int id;
    private String idrif;
    private String rif;    
    private String url;
    private String descrizione;
    private String data;
    private String stato;

    
    public Allegato(){
        
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getIdrif() {
        return idrif;
    }

    public void setIdrif(String idrif) {
        this.idrif = idrif;
    }

    public String getRif() {
        return rif;
    }

    public void setRif(String rif) {
        this.rif = rif;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
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

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }
    
    

    
    
}

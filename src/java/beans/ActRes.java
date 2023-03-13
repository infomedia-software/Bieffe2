
package beans;

import java.util.HashMap;
import java.util.Map;

public class ActRes {

    private String id;
    private String codice;
    private String nome;
    private String id_fasi;
    private String id_soggetti;
    private int ordinamento;
    
    private Map<String,String> celle;

    @Override
    public String toString() {
        return codice + " - " + nome;
    }
    
    public int inizio(){
        int inizio=0;
        for(int i=0;i<=47;i++){
            if(get_cella(i).equals("")){
                inizio=i;
                break;
            }
        }
        return inizio;
    }
    
    public int fine(){
        int fine=0;
        for(int i=47;i>=0;i--){
            if(get_cella(i).equals("")){
                fine=i+1;
                break;
            }
        }
        return fine;
    }

    public String getId_soggetti() {
        return id_soggetti;
    }

    public void setId_soggetti(String id_soggetti) {
        this.id_soggetti = id_soggetti;
    }
    

    public int getOrdinamento() {
        return ordinamento;
    }

    public void setOrdinamento(int ordinamento) {
        this.ordinamento = ordinamento;
    }
    
        public String get_cella(int indice){
        return celle.get("c"+indice);
    }
    
    public ActRes(){
        celle=new HashMap<String,String>();
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

    public String getId_fasi() {
        return id_fasi;
    }

    public void setId_fasi(String id_fasi) {
        this.id_fasi = id_fasi;
    }

    public Map<String, String> getCelle() {
        return celle;
    }

    public void setCelle(Map<String, String> celle) {
        this.celle = celle;
    }
    
    
    
            
            
}

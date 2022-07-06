package beans;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class Planning {
    
    private String data;
    
    private Map<String,ArrayList<PlanningCella>> planning;

    public Planning(){
        planning=new HashMap<String,ArrayList<PlanningCella>>();
    }
    
    public synchronized Map<String,PlanningCella> mappa_celle_inizio(String risorsa){
        Map<String,PlanningCella> toReturn=new HashMap<String,PlanningCella>();        
        if(planning.get(risorsa)!=null){
            for(PlanningCella pc:planning.get(risorsa)){                
                String key=pc.getInizio().substring(0,pc.getInizio().lastIndexOf(".0"));                
                toReturn.put(key, pc);
            }
        }        
        return toReturn;
    }
    
    public synchronized Map<Integer,PlanningCella> mappa_celle(String risorsa){
        Map<Integer,PlanningCella> toReturn=new HashMap<Integer,PlanningCella>();        
        if(planning.get(risorsa)!=null){
            for(PlanningCella pc:planning.get(risorsa)){
                int key=pc.getInizioOra()*2;
                if(pc.getInizioMinuti()==30)
                    key=key+1;
                toReturn.put(key, pc);
            }
        }        
        return toReturn;
    }
    
    /**
     * 
     * @param risorsa
     * @return 
     */
    public synchronized ArrayList<PlanningCella> celle(String risorsa){
        ArrayList<PlanningCella> toReturn=null;
        if(planning.get(risorsa)!=null)
            toReturn=planning.get(risorsa);
        else
            toReturn=new ArrayList<PlanningCella>();
        return toReturn;
    }
    
    public synchronized void aggiungiPlanningCella(String risorsa,PlanningCella pc){
        if(planning.get(risorsa)==null)
            planning.put(risorsa, new ArrayList<PlanningCella>());
        planning.get(risorsa).add(pc);
    }
    
    
    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }
    
    public int risorse_size(){
        return planning.size();
    }
    
      
    public synchronized boolean esiste(){
        boolean toReturn=false;
        if(planning.size()>0)
            toReturn=true;
        return toReturn;
    }
    

 
    
    
}

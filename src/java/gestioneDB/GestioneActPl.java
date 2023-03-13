package gestioneDB;

import beans.Act;
import beans.ActCel;
import beans.ActRes;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneActPl {
    
    private static GestioneActPl istanza;
    
    public static GestioneActPl getIstanza(){
        if(istanza==null)
            istanza=new GestioneActPl();
        return istanza;
    }
    
    public String riprogramma_act_res(String id_act_res,String data,String ora,String id_act){
        
        String new_inizio=data+" "+ora+":00";
        System.out.println("\n *** riprogramma_act_res ***");
        System.out.println("id_act_res=>"+id_act_res+"<");
        System.out.println("new_inizio=>"+new_inizio+"<");
        System.out.println("id_act    =>"+id_act+"<");

        if(!id_act.equals(""))
            Utility.getIstanza().query("UPDATE act SET inizio=null,fine=null,id_act_res='' WHERE id="+id_act);            
        ArrayList<Act> lista_act=GestioneAct.getIstanza().ricerca(" act.inizio>="+Utility.isNull(new_inizio)+" AND id_act_res="+Utility.isNull(id_act_res)+" AND act.inizio IS NOT null AND act.stato='1' ORDER BY act.inizio ASC");
        if(!id_act.equals("")){
            Act act_input=GestioneAct.getIstanza().get_act(id_act);
            lista_act.add(0,act_input);
        }
        System.out.println(lista_act.size());

        int indice_raggiunto=0;

        System.out.println("*** _programma_act.jsp ***");

        ArrayList<ActCel> celle=GestioneActCel.getIstanza().ricerca(id_act_res, data, ora);

        for(int j=0;j<lista_act.size();j++){
            System.out.println("*** *** *** *** ***");
            Act curr=lista_act.get(j);
            Act succ=null;
            System.out.println(curr.getId()+" > "+curr.getDurata()+" >"+curr.getInizio());
            if(j<lista_act.size()-1)                
                succ=lista_act.get(j+1);

            String inizio="";
            String fine="";
            double durata_raggiunta=0.0;


                for(int i=indice_raggiunto;i<celle.size();i++){

                    ActCel act_cel=celle.get(i);                
                    System.out.println(act_cel.data_ora_inizio()+" / "+act_cel.data_ora_fine()+" => "+act_cel.getValore()+" > "+Utility.elimina_zero(durata_raggiunta)+"/"+curr.getDurata_string());
                    if(act_cel.getValore().equals("") && inizio.equals("")){
                        inizio=act_cel.data_ora_inizio();
                        System.out.println(" trovato inizio=>"+inizio+"<");
                    }
                    if(act_cel.getValore().equals("")){
                        durata_raggiunta=durata_raggiunta+0.5;
                    }
                    if(durata_raggiunta==curr.getDurata()){
                        fine=act_cel.data_ora_fine();
                        curr.setFine(fine);

                        System.out.println(" trovata fine=>"+fine+"< => durata_raggiunta"+durata_raggiunta);
                        System.out.println("    new_inizio=>"+inizio);
                        System.out.println("    new_fine=>"+fine);
                        indice_raggiunto=i+1;
                        Utility.getIstanza().query("UPDATE act SET inizio="+Utility.isNull(inizio)+",fine="+Utility.isNull(fine)+",id_act_res="+Utility.isNull(id_act_res)+" WHERE id="+curr.getId());
                        break;
                    }            
                    if(i==(celle.size()-1) && fine.equals("")){

                        String data_successiva=Utility.dataFutura(celle.get(i).getData(), 1);
                        System.out.println(" >>> PLANNING TERMINATO <<<");
                        System.out.println(" >>> creo => "+data_successiva);
                        GestioneActPl.getIstanza().crea_act_pl(data_successiva);
                        ArrayList<ActCel> celle_create=GestioneActCel.getIstanza().ricerca(id_act_res, data_successiva, "00:00");
                        celle.addAll(celle_create);
                    }
                }

                
            if(succ!=null){
                System.out.println("curr.getFine()   =>"+curr.getFine());
                System.out.println("succ.getInizio() =>"+succ.getInizio());
                System.out.println(">"+Utility.viene_prima(curr.getFine(), succ.getInizio())+"<");
                if(Utility.viene_prima(curr.getFine(), succ.getInizio())){
                    break;
                }
            }

            System.out.println("*** *** *** *** ***");

        }

        System.out.println("*** *** *** *** *** \n");
        return "";
    }
    
    
    
    
    public String crea_act_pl(String data_input){
    
        String ultima_data_creata=Utility.getIstanza().querySelect("SELECT max(data) as ultima_data FROM act_pl WHERE 1","ultima_data" );
        if(ultima_data_creata==null)
            ultima_data_creata=Utility.dataFutura(data_input, -1);
        
        String ultima_data_da_creare=data_input;
        if(Utility.giornoDellaSettimana(ultima_data_da_creare).equals("sab")){
            ultima_data_da_creare=Utility.dataFutura(data_input, 2);
        }
        if(Utility.giornoDellaSettimana(ultima_data_da_creare).equals("dom")){
            ultima_data_da_creare=Utility.dataFutura(data_input, 1);
        }
        
        String data=Utility.dataFutura(ultima_data_creata, 1);
                
        do{
            System.out.println("***");
            System.out.println("ultima_data_creata=>"+ultima_data_creata);
            System.out.println("ultima_data_da_creare=>"+ultima_data_da_creare);
            System.out.println("data=>"+data);
        
            
            String giorno_settimana=Utility.giornoDellaSettimana(data);                    
            if(giorno_settimana.equals("sab") || giorno_settimana.equals("dom")){
                Utility.getIstanza().query("INSERT INTO act_cal(data,attivo) VALUES("+Utility.isNull(data) +",'')");                
                System.out.println("sab o dom=> "+data);
            }else{                
                Utility.getIstanza().query("INSERT IGNORE INTO act_cal(data,attivo) VALUES("+Utility.isNull(data) +",'si')");
                ArrayList<ActRes> risorse=GestioneActRes.getIstanza().ricerca("1");
                
                for(ActRes act_res:risorse){
                    String id_act_res=act_res.getId();            

                    String query_celle="";
                    String query_valori="";
                    for(int i=0;i<=47;i++){
                        query_celle=query_celle+"c"+i+",";                
                        query_valori=query_valori+Utility.isNull(act_res.get_cella(i))+",";
                    }
                    query_celle=Utility.rimuovi_ultima_occorrenza(query_celle, ",");
                    query_valori=Utility.rimuovi_ultima_occorrenza(query_valori, ",");
                    String query_risorsa="INSERT INTO act_pl(data,id_act_res,"+query_celle+") VALUES("+Utility.isNull(data)+","+Utility.isNull(id_act_res)+","+query_valori+")";            
                    Utility.getIstanza().query(query_risorsa);                    
                }
                System.out.println("inserisce data=> "+data+"<");
            }                 
            data=Utility.dataFutura(data, 1);
            
            System.out.println("***");
        }while(!data.equals(Utility.dataFutura(ultima_data_da_creare, 1)));
        return "";
    }
    
    
    
}

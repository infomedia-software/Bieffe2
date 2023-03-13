<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="gestioneDB.GestioneActRes"%>
<%@page import="beans.ActRes"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%
    String data=Utility.eliminaNull(request.getParameter("data"));
    
    Utility.getIstanza().query("UPDATE act_cal SET attivo='si' WHERE data="+Utility.isNull(data));
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


%>
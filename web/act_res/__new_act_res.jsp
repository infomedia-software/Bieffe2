
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneActCal"%>
<%@page import="java.util.Map"%>
<%@page import="utility.Utility"%>
<%
    String nome=Utility.eliminaNull(request.getParameter("nome"));
    String codice=Utility.eliminaNull(request.getParameter("codice"));
    
    int max_ordinamento=(int)Utility.getIstanza().querySelectDouble("SELECT max(ordinamento)+1 as max_ordinamento FROM act_res WHERE stato='1'", "max_ordinamento");
    String id_act_res=Utility.getIstanza().query_insert("INSERT INTO act_res(codice,nome,ordinamento,stato) VALUES("+ Utility.isNull(codice)+","+ Utility.isNull(nome)+","+max_ordinamento+",'1')");        
    String query_c="";
    for(int i=0;i<=47;i++){
        String etichetta="c"+i;
        String valore_input=Utility.eliminaNull(request.getParameter(etichetta));
        String valore="-1";
        if(valore_input.equals("attivo"))valore="";
        query_c=query_c+etichetta+"="+Utility.isNull(valore)+", ";                
    }
    query_c=Utility.rimuovi_ultima_occorrenza(query_c, ",");
        
    String query="UPDATE act_res SET "+query_c+" WHERE id="+Utility.isNull(id_act_res);
    Utility.getIstanza().query(query);
    
    
    ArrayList<String> date=new ArrayList<String>();
    String prima_data=Utility.dataOdiernaFormatoDB();
    String ultima_data=Utility.dataFutura(prima_data, 60);
    while(!prima_data.equals(ultima_data)){
        date.add(prima_data);
        prima_data=Utility.dataFutura(prima_data, 1);
    }
    
    Map<String,String> calendario=GestioneActCal.getIstanza().ricerca(" data>="+prima_data);

    for(String data:date){
        if(calendario.get(data)!=null){
            String query_celle="";
            String query_valori="";

            for(int i=0;i<=47;i++){
                query_celle=query_celle+"c"+i+",";                
                String valore_input=Utility.eliminaNull(request.getParameter("c"+i));
                String valore="-1";
                if(calendario.get(data).equals("si")){
                    if(valore_input.equals("attivo"))
                        valore="";                    
                }
                query_valori=query_valori+Utility.isNull(valore)+",";
            }
            query_celle=Utility.rimuovi_ultima_occorrenza(query_celle, ",");
            query_valori=Utility.rimuovi_ultima_occorrenza(query_valori, ",");
            
            String query_risorsa="INSERT INTO act_pl(data,id_act_res,"+query_celle+") VALUES("+Utility.isNull(data)+","+Utility.isNull(id_act_res)+","+query_valori+")";            
            Utility.getIstanza().query(query_risorsa);
        }
    }
%>
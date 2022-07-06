<%@page import="server.ws.WsServer"%>
<%@page import="beans.PlanningCella"%>
<%@page import="java.util.Map"%>
<%@page import="beans.Planning"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%@page import="utility.Utility"%>
<%    
    String risorsa=Utility.eliminaNull(request.getParameter("risorsa"));
    String data=Utility.eliminaNull(request.getParameter("data"));
    String planning_ultima_data=Utility.eliminaNull(request.getParameter("planning_ultima_data"));
    
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));
    
    String inizio=Utility.eliminaNull(request.getParameter("inizio"));
    String fine=Utility.eliminaNull(request.getParameter("fine"));

    String inizio2=Utility.eliminaNull(request.getParameter("inizio2"));
    String fine2=Utility.eliminaNull(request.getParameter("fine2"));
   
    String start_riprogramma_risorse=data+" 00:00:00";
    
    String applica_sempre=Utility.eliminaNull(request.getParameter("applica_sempre"));
    
    if(applica_sempre.equals("false"))
        planning_ultima_data=Utility.dataFutura(data, 1);
    
   
    
    while(!data.equals(planning_ultima_data)){
        
        String situazione=Utility.getIstanza().getValoreByCampo("calendario", "situazione", "data="+Utility.isNull(data));
        
        if(situazione.equals("abilitato")){
            
            String inizio_temp=data+" "+inizio+":00";
            String fine_temp=data+" "+fine+":00";
            String inizio2_temp="";
            String fine2_temp="";
            if(!fine2.equals(""))
                fine2_temp=data+" "+fine2+":00";
            if(!inizio2.equals(""))
                inizio2_temp=data+" "+inizio2+":00";

            // Disabilita
            if(newvalore.equals("-1")){
                Utility.getIstanza().query("DELETE FROM planning WHERE risorsa="+Utility.isNull(risorsa)+" AND DATE(inizio)="+Utility.isNull(data));
            }
            // Abilita
            if(newvalore.equals("1")){

                Utility.getIstanza().query("DELETE FROM planning WHERE risorsa="+Utility.isNull(risorsa)+" AND DATE(inizio)="+Utility.isNull(data)+" AND inizio<"+Utility.isNull(inizio_temp));

                if(fine2.equals("")){
                    Utility.getIstanza().query("DELETE FROM planning WHERE risorsa="+Utility.isNull(risorsa)+" AND DATE(inizio)="+Utility.isNull(data)+" AND fine>"+Utility.isNull(fine_temp));            
                }else{
                    Utility.getIstanza().query("DELETE FROM planning WHERE risorsa="+Utility.isNull(risorsa)+" AND DATE(inizio)="+Utility.isNull(data)+" AND fine>"+Utility.isNull(fine2_temp));                    
                    Utility.getIstanza().query("DELETE FROM planning WHERE risorsa="+Utility.isNull(risorsa)+" AND DATE(inizio)="+Utility.isNull(data)+" "
                            + "AND inizio>="+Utility.isNull(fine_temp)+" AND inizio<"+Utility.isNull(inizio2_temp));
                }

                Planning planning=GestionePlanning.getIstanza().getPlanning(data);
                Map<String,PlanningCella> celle=planning.mappa_celle_inizio(risorsa);

                String orario_temp=inizio_temp;       
                String query_insert="INSERT INTO planning(risorsa,inizio,fine,valore) VALUES ";
                while(!orario_temp.equals(fine_temp)){            
                    if(!celle.get(orario_temp).is_attiva()){
                        String fine_ok=Utility.aggiungiOre(orario_temp, 0, 30);
                        query_insert=query_insert+"("+Utility.isNull(risorsa) +","+Utility.isNull(orario_temp)+","+Utility.isNull(fine_ok)+",'1'),";
                    }            
                    orario_temp=Utility.aggiungiOre(orario_temp, 0, 30);            
                }
                orario_temp=inizio2_temp;      
                while(!orario_temp.equals(fine2_temp)){            
                    if(!celle.get(orario_temp).is_attiva()){
                        String fine_ok=Utility.aggiungiOre(orario_temp, 0, 30);
                        query_insert=query_insert+"("+Utility.isNull(risorsa) +","+Utility.isNull(orario_temp)+","+Utility.isNull(fine_ok)+",'1'),";
                    }            
                    orario_temp=Utility.aggiungiOre(orario_temp, 0, 30);            
                }


                if(query_insert.endsWith(",")){
                    query_insert=query_insert.substring(0,query_insert.length()-1);
                    Utility.getIstanza().query(query_insert);
                }
            }   
        }
        data=Utility.dataFutura(data, 1);                
        
    }
    
    GestionePlanning.getIstanza().riprogrammaRisorse(risorsa,start_riprogramma_risorse);

%>
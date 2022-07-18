<%@page import="gestioneDB.GestioneOpzioni"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="gestioneDB.GestioneCalendario"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String data=Utility.eliminaNull(request.getParameter("data"));
    String operazione=Utility.eliminaNull(request.getParameter("operazione"));    
        
    String new_data="";
    String data_min_calendario=GestioneOpzioni.getIstanza().getOpzione("DATA_MIN_CALENDARIO");
    
    String data_corrente=Utility.dataOdiernaFormatoDB();
    String data_max=Utility.dataFutura(data_corrente, 60);
    
    if(Utility.viene_prima(data_max, data)){
        new_data="ERRORE:Il planning non può essere creato per la data selezionata poichè è superiore a 60 gg da oggi";
    }else{
        
        if(Utility.viene_prima_date(data, data_min_calendario)){
            new_data="ERRORE:Il planning non esiste per la data selezionata poichè è antecedente alla prima data del planning.";
        }else{
            if(operazione.equals("")){
                boolean data_creata=GestioneCalendario.getIstanza().is_data_creata(data);                

                new_data=data;
                if(data_creata==false){            
                    String data_temp=GestionePlanning.getIstanza().ultima_data_planning();

                    data_temp=Utility.dataFutura(data_temp, 1);            
                    String data_finale=Utility.dataFutura(new_data, 1);

                    while(!data_temp.equals(data_finale)){
                        String giorno_settimana=Utility.giornoDellaSettimana(data_temp);      
                        if(giorno_settimana.equals("sab") || giorno_settimana.equals("dom")){
                            Utility.getIstanza().query("INSERT INTO calendario(data,situazione,stato) VALUES ("+Utility.isNull(data_temp)+",'disabilitato','1')");                
                        }else{
                            GestionePlanning.getIstanza().creaPlanning(data_temp);                                           
                        }                        
                        data_temp=Utility.dataFutura(data_temp, 1);                
                    }
                }

            }    
            if(operazione.equals("+1")){
                new_data=GestioneCalendario.getIstanza().prima_data_succ(data);                
                if(new_data==null){
                    new_data=Utility.dataFutura(data, 1);
                    String giorno_settimana=Utility.giornoDellaSettimana(new_data);      

                    if(giorno_settimana.equals("sab")){
                        Utility.getIstanza().query("INSERT INTO calendario(data,situazione,stato) VALUES ("+Utility.isNull(new_data)+",'disabilitato','1')");
                        Utility.getIstanza().query("INSERT INTO calendario(data,situazione,stato) VALUES ("+Utility.isNull(Utility.dataFutura(new_data, 1))+",'disabilitato','1')");
                        new_data=Utility.dataFutura(new_data, 2);
                    }
                    if(giorno_settimana.equals("dom")){
                        Utility.getIstanza().query("INSERT INTO calendario(data,situazione,stato) VALUES ("+Utility.isNull(new_data)+",'disabilitato','1')");
                        new_data=Utility.dataFutura(new_data, 1);
                    }
                    GestionePlanning.getIstanza().creaPlanning(new_data);                        
                }
            }
            if(operazione.equals("-1")){
                new_data=GestioneCalendario.getIstanza().prima_data_prec(data);                
            }
        }
    }
    
    out.print(new_data);
%>
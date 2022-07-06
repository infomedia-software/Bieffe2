<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%
    String data=Utility.eliminaNull(request.getParameter("data"));
    
    String campodamodificare=Utility.eliminaNull(request.getParameter("campodamodificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));
    
    
    String datasuccessiva=Utility.dataFutura(data, 1);    
    
    ArrayList<Risorsa> risorse=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.planning='si' AND risorse.stato='1'");
    
    for(Risorsa risorsa:risorse){
        String inizio=data+" 00:00:00";
        String fine=datasuccessiva+" 00:00:00";
        if(campodamodificare.equals("valore") && newvalore.equals("1")){
            inizio=data+" "+risorsa.getInizio()+":00";
            fine=data+" "+risorsa.getFine()+":00";
        }
        String query=" UPDATE planning "
                + " SET "+campodamodificare+"="+Utility.isNull(newvalore)+" "
                + " WHERE "
                + " risorsa="+Utility.isNull(risorsa.getId())+" AND "                        
                + " inizio>="+Utility.isNull(inizio)+" AND "
                + " fine<="+Utility.isNull(fine);        
        Utility.getIstanza().query(query);
    }
%>
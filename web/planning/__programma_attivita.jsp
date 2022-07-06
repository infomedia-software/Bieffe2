
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="beans.Attivita"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="gestioneDB.DBUtility"%>
<%@page import="utility.GestioneErrori"%>
<%@page import="connection.ConnectionPoolException"%>
<%@page import="utility.GestioneErrori"%>
<%@page import="java.sql.SQLException"%>
<%@page import="gestioneDB.DBConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.PlanningCella"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    
    String idattivita=Utility.eliminaNull(request.getParameter("idattivita"));
    String inizio_input=Utility.eliminaNull(Utility.dataOraCorrente_String());
    
    String toReturn="";
    
    /****************************************************************************************** 
     *                      Programmazione della singola attività
     ******************************************************************************************/
    if(!idattivita.equals("")){
        
        ArrayList<Attivita> listaattivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+idattivita);
        Attivita attivita_da_programmare=listaattivita.get(0);  
        
        String risorsa_assegnata=attivita_da_programmare.getRisorsa().getId();
        
        if(risorsa_assegnata.equals("")){                               // Non è stata assegnata la risorsa
            
            String fase_input=attivita_da_programmare.getFase_input().getId();
            
            ArrayList<Risorsa> risorse=GestioneRisorse.getIstanza().ricercaRisorse(" planning='si' AND fasi_input LIKE "+Utility.isNullLike(fase_input)+" ");
            
            if(risorse.size()>0){                                       // Considera la prima risorsa di quella fase        
                risorsa_assegnata=risorse.get(0).getId();               
            }
            else
            {
                toReturn="Impossibile programmare l'attività.\nNessuna risorsa associata alla fase!";
            }
        }
        
        if(!risorsa_assegnata.equals("")){
            Utility.getIstanza().query("CALL `riposizionaAttivita`("
                + Utility.isNull(idattivita) +","
                + Utility.isNull(inizio_input) +", "
                + Utility.isNull(risorsa_assegnata) +")");            
            
            String id_attivita_insieme=Utility.getIstanza().getValoreByCampo("attivita", "id", "libero7="+Utility.isNull(idattivita));
            
            if(!id_attivita_insieme.equals("")){
                String risorsa_attivita_insieme=Utility.getIstanza().getValoreByCampo("attivita", "risorsa", "id="+id_attivita_insieme);
                
                Utility.getIstanza().query("CALL `riposizionaAttivita`("
                    + Utility.isNull(id_attivita_insieme) +","
                    + Utility.isNull(inizio_input) +", "
                    + Utility.isNull(risorsa_attivita_insieme) +")");            
                }
            
            GestionePlanning.getIstanza().riprogrammaRisorse(risorsa_assegnata, "");
        }
     
    
        // Verifico se viene inficiata la fase di stampa o allestimento
        if(attivita_da_programmare.getFase_input().getStampa().equals("si")){          
            String colore=GestioneCommesse.getIstanza().verifica_fase_commessa(attivita_da_programmare.getCommessa().getId(),"stampa");
            Utility.getIstanza().query("UPDATE commesse SET stampa="+Utility.isNull(colore)+" WHERE id="+attivita_da_programmare.getCommessa().getId());           
        }
        if(attivita_da_programmare.getFase_input().getAllestimento().equals("si")){    
            String colore=GestioneCommesse.getIstanza().verifica_fase_commessa(attivita_da_programmare.getCommessa().getId(),"allestimento");
            Utility.getIstanza().query("UPDATE commesse SET allestimento="+Utility.isNull(colore)+" WHERE id="+attivita_da_programmare.getCommessa().getId());           
        }
    } 
    
    
    out.print(toReturn);
%>
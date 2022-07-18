<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="java.util.HashMap"%>
<%@page import="gestioneDB.DBUtility"%>
<%@page import="java.sql.SQLException"%>
<%@page import="utility.GestioneErrori"%>
<%@page import="connection.ConnectionPoolException"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%    
    String id_commessa=Utility.eliminaNull(request.getParameter("id_commessa"));
    
    if(!Utility.url.contains("localhost")){
        // Cancello tutte le attività non in programmazione o da programmare o non sono collegate ad ordine fornitore
        String query="DELETE FROM attivita WHERE situazione!='in programmazione' AND situazione!='da programmare' AND id_ordine_fornitore='' ";    
        if(!id_commessa.equals("")){
            query=query+ " AND commessa="+Utility.isNull(id_commessa)+" ";
            Utility.getIstanza().query(query);
            String numero_commessa=Utility.getIstanza().getValoreByCampo("commesse", "numero", "id="+id_commessa);
            GestioneSincronizzazione.getIstanza().sincronizza_commesse(numero_commessa);
        }else{        
            GestioneSincronizzazione.getIstanza().sincronizza_commesse("");
        }        
    }
    Utility.getIstanza().query("UPDATE opzioni SET valori=NOW() WHERE etichetta='ULTIMA_SINCRONIZZAZIONE'");    
%>

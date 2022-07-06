<%@page import="beans.Fase"%>
<%@page import="beans.CommessaElemento"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    int numero=GestioneCommesse.getIstanza().prossimoNumeroCommessa();
    String query="";
    
    // FASE 1 : Copia commessa
    query=" INSERT INTO commesse"
            + "("
            + "`soggetto`, `data`, `scadenza`, `numero`, `anno`, `descrizione`, `rifofferta`, `rifordine`, "
            + "`immagine`, `costoorario`, `importo`, `situazione`, `note`, `colore`, `stato`"
            + ")"
            + " SELECT "
            + "`soggetto`, '"+Utility.dataOdiernaFormatoDB()+"', `scadenza`, "+Utility.isNull(numero)+", `anno`, `descrizione`, `rifofferta`, `rifordine`, "
            + "`immagine`, `costoorario`, `importo`, `situazione`, `note`, `colore`, `stato`"
            + " FROM commesse "
            + " WHERE id="+Utility.isNull(id);
    Utility.getIstanza().query(query);
    String idcommessacreata=Utility.getIstanza().getValoreByCampo("commesse", "id", "numero="+numero);
    
    
    ArrayList<CommessaElemento> elementi=GestioneCommesse.getIstanza().ricercaElementi(" commessa="+id);
    
    for(CommessaElemento ce:elementi){
        
        // FASE 2 : Copia commessa elementi
        query=" INSERT INTO commessa_elementi "
        + "(`commessa`, `codice`, `descrizione`, `note`) "
        + " VALUES ("
                +Utility.isNull(idcommessacreata)+", "
                +Utility.isNull(ce.getCodice())+", "
                +Utility.isNull(ce.getDescrizione())+", "
                +Utility.isNull(ce.getNote())+" ) ";
        Utility.getIstanza().query(query);
        
        String idelementocreato=Utility.getIstanza().getValoreByCampo("commessa_elementi", "id", " 1 ORDER BY id DESC LIMIT 0,1");
        
        ArrayList<Fase> fasi=GestioneCommesse.getIstanza().ricercaFasi(" commessa="+id+" AND elemento="+ce.getId()+ " AND stato=1");
        for(Fase f:fasi){
            // FASE 3 : Copia fasi per ogni elemento
            query=" INSERT INTO fasi "
            + " ( `elemento`, `commessa`, `descrizione`, `note`, `durata`, `stato` )"
            + " VALUES "
            + "("
                +Utility.isNull(idelementocreato)+" , "
                +Utility.isNull(idcommessacreata)+", "
                +Utility.isNull(f.getDescrizione())+", "
                +Utility.isNull(f.getNote())+", "
                +Utility.isNull(f.getDurata())+","
                +Utility.isNull(f.getStato())
            +")";
            
            Utility.getIstanza().query(query);
        }
    }
 
    out.print(idcommessacreata);
%>
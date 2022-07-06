<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true" %>
<%
      
    String codice=Utility.eliminaNull(request.getParameter("codice"));
    String nome=Utility.eliminaNull(request.getParameter("nome"));
    String fase=Utility.eliminaNull(request.getParameter("fase"));    
    
    
    String note=Utility.eliminaNull(request.getParameter("note"));;
    
    String ordinamento=Utility.eliminaNull(Utility.getIstanza().querySelect(" SELECT max(ordinamento) as maxordinamento FROM risorse "
            + "WHERE stato='1' AND fase="+Utility.isNull(fase), "maxordinamento"));
    
    int ordinamento_int=0;
    if(ordinamento.equals("")){
        // Cerca il massimo ordinamento della risorsa su fase precedente
        String ordinamento_fase_selezionata=Utility.getIstanza().getValoreByCampo("fasi", "ordinamento", "id="+fase);
        int ordinamento_fase_selezionata_int=Utility.convertiStringaInInt(ordinamento_fase_selezionata);       
        String fase_precedente=Utility.getIstanza().getValoreByCampo("fasi", "id", "ordinamento="+(ordinamento_fase_selezionata_int-1));
        
        if(fase_precedente.equals("")){
            ordinamento="0";
        }else{
             ordinamento=Utility.eliminaNull(Utility.getIstanza().querySelect(" SELECT max(ordinamento) as maxordinamento FROM risorse "
                + "WHERE stato='1' AND fase="+Utility.isNull(fase_precedente), "maxordinamento"));
            ordinamento_int=Utility.convertiStringaInInt(ordinamento);
            ordinamento_int++;
        }
                
    }else{       
        ordinamento_int=Utility.convertiStringaInInt(ordinamento);
        ordinamento_int++;
    }
    
    
    String query="INSERT INTO risorse(codice,nome,fase,ordinamento,note) VALUES("
            + Utility.isNull(codice)+","
            + Utility.isNull(nome)+","
            + Utility.isNull(fase)+","      
            + ordinamento_int+","
            + Utility.isNull(note)+")";
    String id_risorsa=Utility.getIstanza().query_insert(query);
    
    
    // Aggiorna l'ordinamento delle macchine immediatamente successive
    Utility.getIstanza().query("UPDATE risorse SET ordinamento=ordinamento+1 WHERE ordinamento>="+ordinamento_int+" AND id!="+id_risorsa);
    
    out.print(id_risorsa);
%>
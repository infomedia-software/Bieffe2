<%@page import="utility.Utility"%>
<%    
    String codice=Utility.eliminaNull(request.getParameter("codice"));
    String nome=Utility.eliminaNull(request.getParameter("nome"));
    
    int ordinamento=(int)Utility.getIstanza().querySelectDouble("SELECT max(ordinamento)+1 AS max_ordinamento FROM fasi WHERE stato='1'", "max_ordinamento");
    
    Utility.getIstanza().query(""
        + "INSERT INTO fasi(codice,nome,ordinamento)"
            + "VALUES("+
            Utility.isNull(codice)+","+
            Utility.isNull(nome)+","+
            Utility.isNull(ordinamento)+")");
    
%>

<%@page import="utility.Utility"%>
<%
    String risorsa=Utility.eliminaNull(request.getParameter("risorsa"));
    String spostamento=Utility.eliminaNull(request.getParameter("spostamento"));
    
    String ordinamento=Utility.getIstanza().getValoreByCampo("risorse", "ordinamento", "id="+risorsa);
    int oldordinamento=Utility.convertiStringaInInt(ordinamento);
    
    int newordinamento=0;
    if(spostamento.equals("dx")){
        newordinamento=oldordinamento+1;
    }
    if(spostamento.equals("sx")){
        newordinamento=oldordinamento-1;
    }
    
    String risorsadascambiare=Utility.getIstanza().getValoreByCampo("risorse", "id", "ordinamento="+newordinamento);
    Utility.getIstanza().query("UPDATE risorse SET ordinamento="+oldordinamento+" WHERE id="+risorsadascambiare);
    Utility.getIstanza().query("UPDATE risorse SET ordinamento="+newordinamento+" WHERE id="+risorsa);

%>
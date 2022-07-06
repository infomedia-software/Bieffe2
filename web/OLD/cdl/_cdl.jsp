<%@page import="utility.Utility"%>
<%@page import="beans.CDL"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneCDL"%>
<%
    String querycdl=Utility.eliminaNull(request.getParameter("querycdl")); 
    ArrayList<CDL> listacdl=GestioneCDL.getIstanza().ricerca(querycdl);
%>

<table class="tabella">
    <tr>
        <th style="width: 75px;"></th>
        <th>Codice</th>
        <th>Nome</th>
        <th>Note</th>       
    </tr>
    <%for(CDL cdl:listacdl){%>
    <tr>
        <td>
            <a href="<%=Utility.url%>/cdl/centrodilavoro.jsp?id=<%=cdl.getId()%>" target="_blank" class="pulsantesmall">
                <img src="<%=Utility.url%>/images/edit.png">
            </a>
        </td>
        <td><%=cdl.getCodice()%></td>
        <td><%=cdl.getNome()%></td>
        <td><%=cdl.getNote()%></td>
    </tr>
    <%}%>    
</table>
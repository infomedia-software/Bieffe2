<%@page import="java.util.Map"%>
<%@page import="beans.Fase"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Commessa"%>
<%
    String commessa=Utility.eliminaNull(request.getParameter("commessa"));
    Commessa c=GestioneCommesse.getIstanza().ricerca(" commesse.id="+commessa).get(0);
    String query=Utility.eliminaNull(request.getParameter("query"));
    
    Map<String,Double> duratafasi=GestioneCommesse.getIstanza().durataFasi(" attivita.commessa="+commessa);
%>


        <div class="height10"></div>        
        
        <%if(!query.equals("")){%>
                 
            <table class="tabella">
                <tr>
                    <th style='width: 90px'></th>
                    <th style="width: 100px;">Codice</th>
                    <th>Descrizione</th>
                    <th style='width: 100px'>Durata</th>
                    <th style='width: 100px'>Durata<br>Pianificata</th>
                    <th style='width: 100px'>Note</th>
                    <th style='width: 90px'></th>
                </tr>               
                    <%
                    double totaledurata=0;
                    double totaleduratapianificata=0;    
                    for(Fase f:GestioneCommesse.getIstanza().ricercaFasi(" commessa="+Utility.isNull(c.getNumero())+" AND fasi.stato='1' ORDER by fasi.id ASC")){                        
                        double duratapianificata=0;
                        if(duratafasi.get(f.getId())!=null)
                            duratapianificata=duratafasi.get(f.getId());
                        totaledurata=totaledurata+f.getDurata();
                        totaleduratapianificata=totaleduratapianificata+duratapianificata;                        
                        %>                    
                        <tr>
                            <td style="background-color:white">   
                                <button class='pulsantesmall' onclick="mostrapopup('<%=Utility.url%>/commesse/_fase.jsp?idfase=<%=f.getId()%>','Fase');">
                                    <img src="<%=Utility.url%>/images/edit.png" alt='' >    
                                </button>
                            </td>
                            <td style="background-color:white"></td>
                            <td style="background-color:white"><%=f.getDescrizione()%></td>
                            <td style="background-color:white"><%=f.getDurata()%></td>
                            <td style="background-color:white">
                                <%=duratapianificata%>
                            </td>
                            <td style="background-color:white"><%=f.getNote()%></td>
                            <td style="background-color:white">
                                <%if(duratapianificata==0){%>
                                    <button class='pulsantesmall delete' onclick="cancellafase('<%=f.getId()%>')">
                                        <img src="<%=Utility.url%>/images/delete.png" alt='' >
                                    </button>
                                <%}%>
                            </td>
                        </tr>      
                    <%}%>                    
        </table>
        <%}%>
    
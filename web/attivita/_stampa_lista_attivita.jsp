<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Attivita"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String query=Utility.eliminaNull(request.getParameter("query"));
    String risorsa=Utility.eliminaNull(request.getParameter("risorsa"));
    String ordinamento=Utility.eliminaNull(request.getParameter("ordinamento"));
    
    if(ordinamento.equals(""))
        ordinamento=" attivita.inizio ASC";
    query=query+" ORDER BY "+ordinamento;
    
    ArrayList<Attivita> lista_attivita=GestionePlanning.getIstanza().ricercaAttivita(query);
    
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista Attività | <%=Utility.nomeSoftware%></title>
         <link rel="stylesheet" type="text/css" href="<%=Utility.url%>/css/stile_print_1.0.css">
        <script type="text/javascript">    
            window.print();
        </script>
        
        <style type="text/css">
            #tabella_lista_attivita tr td, #tabella_lista_attivita td{
                border:1px solid lightgray;
            }
        </style>
    </head>
    <body>
        
        <h1>        
            <%if(!risorsa.equals("")){
                Risorsa risorsa_temp=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.id="+Utility.isNull(risorsa)+" ").get(0);%>
                <%=risorsa_temp.getCodice()+" "+risorsa_temp.getNome()+" - "%>                
            <%}%>                   
            Sono state trovate <%=lista_attivita.size()%> attività
        </h1>
        
        <table class="tabella_stampa" id="tabella_lista_attivita">
            <tr>
                <th>Inizio</th>
                <th>Durata</th>
                
                <th>Data Consegna</th>                
                <th>Commessa</th>                
                <th>Cliente</th> 
                <th>Descrizione</th> 
                <th></th>
                <th style="width: 260px"></th>
                <th>Note</th>
                
            </tr>
            <%for(Attivita attivita:lista_attivita){%> 
                <tr>
                    <td><%=Utility.convertiDatetimeFormatoIT(attivita.getInizio()).substring(0,10)%></td>
                    <td><%=Utility.elimina_zero(attivita.getDurata())%> h</td>                    
                    <td>
                        <%if(!attivita.getCommessa().getData_consegna().equals("")){%>
                            <%=Utility.convertiDatetimeFormatoIT(attivita.getCommessa().getData_consegna()).substring(0,10)%>
                        <%}%>
                    </td>
                    <td>
                        <b><%=attivita.getCommessa().getNumero()%></b>
                    </td>
                    <td>
                        <%=attivita.getCommessa().getSoggetto().getAlias()%>
                    </td>
                    <td>
                        <%=attivita.getCommessa().getDescrizione()%>
                    </td>                    
                    <td>
                        <%if(risorsa.equals("")){%>
                            <%=attivita.getRisorsa().getNome()%>
                        <%}%>
                        <%=attivita.getCommessa().getNote()%>
                    </td>                    
                    <td>
                        <div class="ball" style="background-color: #444;">
                            <%if(attivita.getCarta().contains("_1_")){%>
                            <img src="<%=Utility.url%>/images/v.png">                                
                            <%}%>                            
                        </div>
                        <span style="font-size: 11px;float: left;">MAG 1</span>
                        
                        <div style="width: 20px;float: left"></div>
                        <div class="ball" style="background-color: #444;">
                            <%if(attivita.getCarta().contains("_2_")){%>
                            <img src="<%=Utility.url%>/images/v.png">                                
                            <%}%>                            
                        </div>
                        <span style="font-size: 11px;float: left;">MAG 2</span>
                        
                        <div style="width: 20px;float: left"></div>
                        <div class="ball" style="background-color: #444;">
                            <%if(attivita.getCarta().contains("_3_")){%>
                            <img src="<%=Utility.url%>/images/v.png">                                
                            <%}%>                            
                        </div>
                        <span style="font-size: 11px;float: left;">MACC</span>
                        
                        <div style="width: 20px;float: left"></div>
                        <div class="ball" style="background-color: #444;">
                            <%if(attivita.getCarta().contains("_4_")){%>
                            <img src="<%=Utility.url%>/images/v.png">                                
                            <%}%>                            
                        </div>
                        <span style="font-size: 11px;float: left;">LASTRE</span>
                        
                    </td>
                    <td><%=attivita.getNote()%></td>      
                </tr>
            <%}%>
        </table>
    </body>
</html>

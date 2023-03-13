<%@page import="gestioneDB.GestioneSoggetti"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneUtenti"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Utente"%>
<%@page import="gestioneDB.GestioneActCel"%>
<%@page import="beans.ActRes"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneActRes"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String id_act_res=Utility.eliminaNull(request.getParameter("id_act_res"));
    ActRes act_res=GestioneActRes.getIstanza().get_act_res(id_act_res);

    ArrayList<Soggetto> utenti=GestioneSoggetti.getIstanza().ricerca(" soggetti.stato='1' AND LOWER(soggetti.tipologia)='d' ORDER BY soggetti.cognome ASC");

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=act_res.toString()%> | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            function modifica_act_res(id_act_res,inField){                       
                var new_valore=inField.value;
                var campo_da_modificare=inField.id;      
                if(inField.type==="checkbox"){
                    if(inField.checked===true)
                        new_valore="";
                    else
                        new_valore="-1";
                }                              
                function_modifica_act_res(id_act_res,campo_da_modificare,new_valore);
            }            
            function function_modifica_act_res(id_act_res,campo_da_modificare,new_valore){
                
                  $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act_res/__modifica_act_res.jsp",
                    data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id_act_res="+id_act_res,
                    dataType: "html",
                    success: function(msg){
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_act_res");
                    }
                });
            }
            
            function modifica_id_soggetti(){
                var id_soggetti = $('.checkbox_id_soggetto:checked').map(function() {return this.value;}).get().toString();
                if(id_soggetti!=="")
                    id_soggetti="_"+id_soggetti.replaceAll(",","__")+"_";                
                function_modifica_act_res('<%=id_act_res%>','id_soggetti',id_soggetti);
                return checkedValues;
            }
        </script>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <div class="width50 float-left">
                <h1><%=act_res.toString()%></h1>
                <div class="box">
                    <div class="etichetta">Codice</div>
                    <div class="valore"><input type="text" id="codice" value="<%=act_res.getCodice()%>" onchange="modifica_act_res('<%=act_res.getId()%>',this)"></div>
                
                    <div class="etichetta">Nome</div>
                    <div class="valore"><input type="text" id="nome" value="<%=act_res.getNome()%>" onchange="modifica_act_res('<%=act_res.getId()%>',this)"></div>
                </div>
                <div class="box">
                    <h3>Orari</h3>
                    <%for(int i=0;i<=47;i++){%>
                        <div style="width: fit-content;float: left;">
                        <div class="etichetta"><%=GestioneActCel.calcola_orario_act_cel_from_indice(i)%> / <%=GestioneActCel.calcola_orario_act_cel_from_indice(i+1)%></div>
                        <div class="valore">
                            <input type="checkbox" id="<%="c"+i%>" value="" <%if(act_res.getCelle().get("c"+i).equals("")){%> checked="true"<%}%>  onchange="modifica_act_res('<%=act_res.getId()%>',this)">
                        </div>
                        </div>
                    <%}%>                    
                </div>
            </div>
            
            <div class="width50 float-left">
                <div class="box">
                    <%for(Soggetto utente:utenti){%>
                        <div class="etichetta"><%=utente.getCognome()%> <%=utente.getNome()%></div>
                        <div class="valore">
                            <input type="checkbox" class="checkbox_id_soggetto"  value="<%=utente.getId()%>" onchange="modifica_id_soggetti()" <%if(act_res.getId_soggetti().contains("_"+utente.getId()+"_")){%> checked="true" <%}%>  >
                        </div>
                    <%}%>
                </div>
            </div>
                
        </div>
    </body>
</html>

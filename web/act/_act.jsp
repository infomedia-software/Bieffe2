<%@page import="beans.Utente"%>
<%@page import="beans.Act"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="utility.Utility"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");
    String id_act=Utility.eliminaNull(request.getParameter("id_act"));
    Act act=GestioneAct.getIstanza().get_act(id_act);
%>


<script type="text/javascript">
    $(function(){
        $('input, select, textarea').on('change', function() {            
            $(this).addClass('changed');
        });  
    });
    
    function verifica_durata(){
        var durata=$("#durata").val();
        if(validazione_durata(durata)===false){
            $("#durata").addClass('errore');
        }else{
            $("#durata").removeClass('errore');
        }
    }
    
    function modifica_act(){        
        $('#form_act input:not(.changed), textarea:not(.changed)').prop('disabled', true);                 
        var data_temp=$("#form_act").serialize().replace('%5B', '[').replace('%5D', ']');        
        var con_errore=$('#form_act .errore').length;
        if(con_errore===0){
            mostraloader("Aggiornamento in corso");
            data_temp=data_temp+"&id_act=<%=id_act%>";        
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/act/__modifica_act.jsp",
                data: data_temp,
                dataType: "html",
                success: function(msg){
                    aggiorna_act_pl();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                }
            });
        }else{
            alert("Impossibile salvare.");
        }
    }
</script>

<div class="box <%if(!utente.is_amministratore()){%> pointer-events-none <%}%>" >
    
    <div class="etichetta">Commessa</div>
    <div class="valore">
        <a href="<%=Utility.url%>/commesse/commessa.jsp?id=<%=act.getCommessa().getId()%>" target="_blank">
            <span>
                <div class="ball" style="background-color: <%=act.commessa_colore()%>"></div>
                <%=act.commessa_numero()%> <%=act.commessa_descrizione()%>
            </span>
        </a>
    </div>      
    
    <div class="etichetta">Cliente</div>
    <div class="valore"><span style="overflow: hidden;"><%=act.cliente()%></span></div>

    <form id="form_act">
        <input type="hidden" name="id_act" value="<%=id_act%>">
        <div class="etichetta">Descrizione</div>
        <div class="valore">
            <textarea id="descrizione" name="descrizione"><%=act.getDescrizione()%></textarea>
        </div>

        <div class="etichetta">Durata</div>
        <div class="valore">
            <input type="number" id="durata" name="durata" value="<%=act.getDurata_string()%>" onchange="verifica_durata()" style="">
        </div>

        <div class="etichetta">Note</div>
        <div class="valore">
            <textarea id="note" name="note"><%=act.getNote()%></textarea>
        </div>
        
        
        <%if(!act.getInizio_string().equals("")){%>
            <div class="etichetta">Inizio</div>
            <div class="valore"><span><%=act.getInizio_string()%></span></div>

            <div class="etichetta">Fine</div>
            <div class="valore"><span><%=act.getFine_string()%></span></div>
        <%}%>
        <div class="etichetta">Completata</div>
        <div class="valore">
            <select id="completata" name="completata" style="width: 50px">
                <option value="no">No</option>
                <option value="si" <%if(act.is_completata()){%> selected="true"<%}%> >Si</option>
            </select>
        </div>
        <%if(utente.is_amministratore()){%>
            <button class="pulsante float-right" onclick="modifica_act()" type="button"><img src="<%=Utility.url%>/images/save.png">Salva</button>
        <%}%>
        <div class="clear"></div>
    </form>
</div>
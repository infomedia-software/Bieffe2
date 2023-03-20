<%@page import="beans.ActPh"%>
<%@page import="gestioneDB.GestioneActPh"%>
<%@page import="gestioneDB.GestioneActRes"%>
<%@page import="beans.ActRes"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%
    String id_commessa="";
    String id_act_ph="";
    String descrizione="";
    double durata=1;
    String note="";
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    
    if(!id_attivita.equals("")){
        Attivita attivita=GestionePlanning.getIstanza().get_attivita(id_attivita);
        id_commessa=attivita.getCommessa().getId();
        descrizione=attivita.getDescrizione();
        durata=attivita.getDurata();
        note=attivita.getNote();
        id_act_ph=attivita.getFase_input().getId();
    }
    
    
    ArrayList<ActRes> list_act_res=GestioneActRes.getIstanza().ricerca("");
    
    ArrayList<ActPh> fasi=GestioneActPh.getIstanza().ricerca("");

%>

<script type="text/javascript">
    function new_act(){
        if(confirm("Procedere all'inserimento dell'attività?")){
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/act/__new_act.jsp",
                data: $("#form_new_act").serialize(),
                dataType: "html",
                success: function(msg){
                    alert("Attività correttamente configurata");
                    location.reload();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE new_act");
                }
            });
        }
    }
</script>

<div class="box">
    
    <form id="form_new_act">

        <input type="hidden" name="id_attivita" value="<%=id_attivita%>">
        <input type="hidden" name="id_commessa" value="<%=id_commessa%>">
        
        
        <div class="etichetta">Descrizione</div>
        <div class="valore">
            <textarea id="descrizione" name="descrizione"><%=descrizione%></textarea>
        </div>

        <div class="etichetta">Durata</div>
        <div class="valore">
            <input type="number" id="durata" name="durata" value="<%=Utility.elimina_zero(durata)%>">
        </div>
        
        <div class="etichetta">Fase</div>
        <div class="valore">
            <select id="id_act_ph" name="id_act_ph">
                <option value=""></option>
                <%for(ActPh fase:fasi){%>
                    <option value="<%=fase.getId()%>"><%=fase.getNome()%></option>
                <%}%>
            </select>
        </div>
        
        <div class="etichetta">Risorsa</div>
        <div class="valore">
            <select name="id_act_res" id="id_act_res">
                <option value=""></option>
                <%for(ActRes act_res:list_act_res){%>
                    <option value="<%=act_res.getId()%>"><%=act_res.getCodice()%> <%=act_res.getNome()%></option>
                <%}%>
            </select>
        </div>
            
        <div class="etichetta">Note</div>
        <div class="valore">
            <textarea id="note" name="note"><%=note%></textarea>
        </div>
            
            
        <button class="pulsante nuovo float-right" type="button" onclick="new_act()">Conferma</button>
    </form>
</div>
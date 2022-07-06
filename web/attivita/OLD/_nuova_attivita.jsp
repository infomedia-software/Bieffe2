<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="beans.Fase"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
<%    
    
    String idcommessa=Utility.eliminaNull(request.getParameter("idcommessa"));    
    
%>

<script type="text/javascript">
       
    function nuovaattivita(){        
        if(confirm('Procedere all\'inserimento dell\'attività?')){                                        
            mostraloader("Operazione in corso...");                            
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/attivita/__nuovaattivita.jsp",
                data: $("#formnuovaattivita").serialize(),
                dataType: "html",
                success: function(msg){
                    aggiornaattivita();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovaattivita()");
                }
            });
        }   
    }
    
    
</script>

<form id="formnuovaattivita" action="" onsubmit="confermanuovaattivita();" >
    
    
    <div class="etichetta">Commessa</div>
    <div class="valore">
        <select id="commessa" name="commessa" onchange="selezionacommessa();">
            <option value="">Seleziona la commessa</option>
            <%for(Commessa c:GestioneCommesse.getIstanza().ricerca(" commesse.situazione='incorso' AND commesse.stato='1' ORDER BY commesse.numero ASC")){%>
                <option value="<%=c.getId()%>" <%if(c.getId().equals(idcommessa)){out.print("selected='true';");}%> ><%=c.getNumero()%> <%=c.getDescrizione()%></option>
            <%}%>
        </select>
    </div>
    
    <div class="etichetta">Fase</div>
    <div class="valore">
        <select id="fase" name="fase">
            <option value="">Seleziona la Fase</option>
            <%for(Fase  fase_cat:GestioneFasi.getIstanza().ricerca(" stato='1' ORDER BY nome ASC")){%>
                <option value="<%=fase_cat.getId()%>"><%=fase_cat.getNome()%> [<%=fase_cat.getCodice()%>]</option>
            <%}%>
        </select>
    </div>
        
    <div class="etichetta">
        Durata
    </div>
    <div class="valore">                        
        <input type="text" id="durata" name="durata" placeholder="es 2.5">
    </div>
    
    <div class="etichetta">
        Descrizione
    </div>
    <div class="valore">
        <textarea id="descrizione" name="descrizione"></textarea>
    </div>
    
    <div class="etichetta">
        Note
    </div>
    <div class="valore">
        <textarea id="note" name="note"></textarea>
    </div>


    <button class="pulsante float-right" type="button" onclick="nuovaattivita()" >Conferma</button>
    
    <div class="clear"></div>
</form>
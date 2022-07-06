<%@page import="beans.Fase"%>
<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetti"%>


<%
    ArrayList<Fase> fasi=GestioneFasi.getIstanza().ricerca("");
%>

<script type="text/javascript">
    function nuovarisorsa(){                
        var nome=$("#nome").val();
        var fase=$("#fase").val();        
        if(nome==="" || fase===""  ){
            alert("Impossibile proseguire nell'inserimento di una nuova risorsa.\nVerifica di aver inserito nome e fase ");
            return;
        }
        
        if(confirm("Procedere all'inserimento di una nuova risorsa?")){                                
            
            mostraloader("Inserimento di una nuova risorsa in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/risorse/__nuovarisorsa.jsp",
                data: $("#formnuovarisorsa").serialize(),
                dataType: "html",
                success: function(id_risorsa){
                    location.href='<%=Utility.url%>/risorse/risorsa.jsp?id='+id_risorsa;
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovarisorsa()");
                }
            });
        }       
    }
</script>


<form id="formnuovarisorsa">
    
    <div class="etichetta">Codice</div>
    <div class="valore">
        <input type="text" name="codice" id="codice">
    </div>
    
    <div class="etichetta">Nome</div>
    <div class="valore">
        <input type="text" name="nome" id="nome">
    </div>
            
    <div class="etichetta">Fase</div>
    <div class="valore">
        <select id="fase" name="fase">
            <option value="">Seleziona la fase</option>
            <%for(Fase fase:fasi){%>
                <option value="<%=fase.getId()%>"><%=fase.getCodice()%> <%=fase.getNome()%></option>
            <%}%>
        </select>
    </div>
        
    <button class="pulsante float-right" onclick="nuovarisorsa()" type="button">Procedi</button>
    
    <div class="clear"></div>
</form>
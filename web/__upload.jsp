<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="utility.Utility"%>
<%@page import="java.io.DataInputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
    <%
    String saveFile="";
    session=request.getSession();
   
    String contentType = request.getContentType();
    if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) {
        DataInputStream in = new DataInputStream(request.getInputStream());
        int formDataLength = request.getContentLength();
        byte dataBytes[] = new byte[formDataLength];
        int byteRead = 0;
        int totalBytesRead = 0;
        while (totalBytesRead < formDataLength) {
            byteRead = in.read(dataBytes, totalBytesRead,formDataLength);
            totalBytesRead += byteRead;
        }
        
        String file = new String(dataBytes);            
        saveFile = file.substring(file.indexOf("filename=\"") + 10);
        saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
        saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1,saveFile.indexOf("\""));

        // Crea la cartella post (se non esiste già)
        String percorso=getServletContext().getRealPath("/")+"allegati/";
        File cartella=new File(percorso);
        cartella.mkdirs();            
        
        if(saveFile.contains(" "))
            saveFile=saveFile.replaceAll(" ", "-");
        String nomeFile=saveFile;
        
        
        saveFile=percorso+"/"+saveFile;
        
        int lastIndex = contentType.lastIndexOf("=");
        String boundary = contentType.substring(lastIndex + 1,contentType.length());
        int pos;
        pos = file.indexOf("filename=\"");
        pos = file.indexOf("\n", pos) + 1;
        pos = file.indexOf("\n", pos) + 1;
        pos = file.indexOf("\n", pos) + 1;
        int boundaryLocation = file.indexOf(boundary, pos) - 4;
        int startPos = ((file.substring(0, pos)).getBytes()).length;
        int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;            
        
        // Verifica se il file esiste già
        String nomeFileOriginale=saveFile;
        int indice=1;
        File f = new File(saveFile);                
        while(true){
            if(f.exists()==false)
            {
                break;
            }
            else
            {                                
                String temp=nomeFileOriginale.substring(0,nomeFileOriginale.lastIndexOf("."));
                String estensione=saveFile.substring(saveFile.lastIndexOf("."),saveFile.length());
                saveFile=temp+"_"+indice+estensione;
                nomeFile=saveFile.substring(saveFile.lastIndexOf("/")+1,saveFile.length());
                f=new File(saveFile);
                indice++;                
            }                
        }
        
        // Crea il file fisicamente                
        FileOutputStream fileOut = new FileOutputStream(f);                        
        fileOut.write(dataBytes, startPos, (endPos - startPos));
        fileOut.flush();
        fileOut.close();           
        out.print(nomeFile);
    }%>
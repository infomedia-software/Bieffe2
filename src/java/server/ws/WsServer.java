package server.ws;
 
import java.util.ArrayList;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
 
@ServerEndpoint("/websocketendpoint")
public class WsServer {
     
    private static final Map<String,Session> SESSIONS = new ConcurrentHashMap<>();
    
    @OnOpen
    public void onOpen(Session session){        
        SESSIONS.put(session.getId(), session);
    }
     
    @OnClose
    public void onClose(Session session){        
        SESSIONS.remove(session.getId());
    }
     
    @OnMessage
    public String onMessage(String message){
        //System.out.println("Message from the client: " + message);
        String echoMsg = "Echo from the server : " + message;
        return echoMsg;
    }
 
    @OnError
    public void onError(Throwable e){
        e.printStackTrace();
    }
    
    public static void sendAll(String text) {
        synchronized (SESSIONS) {
            //System.out.println(SESSIONS.size());
            ArrayList<String> session_ids = new ArrayList(SESSIONS.keySet());
            for (String session_id: session_ids) {
                Session session=SESSIONS.get(session_id);
                if (session.isOpen()) {
                    session.getAsyncRemote().sendText(text);
                }
            }
        }
        
    }
 
}

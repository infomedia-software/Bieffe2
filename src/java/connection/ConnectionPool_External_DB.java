package connection;

import java.util.*;
import java.sql.*;

// La classe che gestisce un pool di connessioni
public class ConnectionPool_External_DB {

  // La variabile che gestisce l'unica istanza di ConnectionPool
  private static ConnectionPool_External_DB connectionPool = null;  

  private Vector freeConnections;  // La coda di connessioni libere
  private String dbUrl;           // Il nome del database
  private String dbDriver;        // Il driver del database
  private String dbLogin;         // Il login per il database
  private String dbPassword;      // La password di accesso al database

  // Costruttore della classe ConnectionPool
  private ConnectionPool_External_DB() throws ConnectionPoolException {
    freeConnections = new Vector();  // Costruisce la coda delle connessioni libere
    loadParameters();                // Carica I parametric per l'accesso alla base di dati
    loadDriver();                    // Carica il driver del database
  }


  // Funzione privata che carica i parametri per l'accesso al database
  private void loadParameters() {
         
    //dbUrl = "jdbc:sqlserver://192.168.1.153:1433;databaseName=Infomedia";             // VPN
    dbUrl = "jdbc:sqlserver://185.5.246.242:1433;databaseName=Infomedia";               // SU NS SERVER
    dbLogin = "sa";                                                                     // Login della base di dati
    dbPassword = "edigit";                                                              // Password per l'accesso al database
    dbDriver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";                          // Driver per database mysql
    
  }

  // Funzione privata che carica il driver per l'accesso al database. 
  // In caso di errore durante il caricamento del driver solleva un'eccezione.
  private void loadDriver() throws ConnectionPoolException {
    try {
        java.lang.Class.forName(dbDriver);
    }
    catch (Exception e) {
      throw new ConnectionPoolException();
    }
  }

  public static synchronized ConnectionPool_External_DB getConnectionPool() throws ConnectionPoolException {
    if(connectionPool == null) {
      connectionPool = new ConnectionPool_External_DB();      
    }
    return connectionPool;
  }

  // Il metodo getConnection restituisce una connessione libera prelevandola 
  // dalla coda freeConnections oppure se non ci sono connessioni disponibili
  // creandone una nuova con una chiamata a newConnection
  public synchronized Connection getConnection() throws ConnectionPoolException {
    Connection con;
      
    if(freeConnections.size() > 0) {      // Se la coda delle connessioni libere non � vuota
      con = (Connection)freeConnections.firstElement();  // Preleva il primo elemento
      freeConnections.removeElementAt(0);                // e lo cancella dalla coda
      try {
        if(con.isClosed()) {          // Verifica se la connessione non � pi� valida
          con = getConnection();    // Richiama getConnection ricorsivamente
        }
      }
      catch(SQLException e) {           // Se c'� un errore
        con = getConnection();        // richiama getConnection ricorsivamente 
      }
    }
    else {                                // se la coda delle connessioni libere � vuota 
      con = newConnection();            // crea una nuova connessione
    }
    return con;                           // restituisce una connessione valida
  } 
    
  // Il metodo newConnection restituisce una nuova connessione
  private Connection newConnection() throws ConnectionPoolException {
    Connection con = null;
      
    try {
      //con = DriverManager.getConnection(dbUrl+"?user="+dbLogin+"&password="+dbPassword+"&zeroDateTimeBehavior=convertToNull");  // crea la connessione
      con = DriverManager.getConnection(dbUrl, dbLogin, dbPassword);
    }
    catch(SQLException e) {                      // in caso di errore
      throw new ConnectionPoolException(e.toString());       // solleva un'eccezione
    }
    return con;                                  // restituisce la nuova connessione
  }

  // Il metodo releaseConnection rilascia una connessione inserendola
  // nella coda delle connessioni libere
  public synchronized void releaseConnection(Connection con) {
    freeConnections.add(con);   // Inserisce la connessione nella coda
  }
}

    

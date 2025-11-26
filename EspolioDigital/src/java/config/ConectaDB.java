/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe de conexão com o banco de dados 'espoliodigital'.
 * 1. Usa o driver moderno (com.mysql.cj.jdbc.Driver).
 * 2. Usa o nome correto do banco ('espoliodigital', sem underscore).
 * 3. Lança as exceções (throws) para que o DAO possa tratá-las.
 */
public class ConectaDB {
    
    // Nome do banco conforme seu schema SQL
    private static final String URL = "jdbc:mysql://localhost:3306/espoliodigital"; 
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    // Driver JDBC moderno do MySQL (cj)
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * Tenta estabelecer uma conexão com o banco de dados.
     * @return um objeto Connection.
     * @throws SQLException Se ocorrer um erro de acesso ao banco (ex: banco não existe, usuário/senha errados).
     * @throws ClassNotFoundException Se o driver JDBC (o arquivo .jar) não for encontrado.
     */
    public static Connection conectar() throws SQLException, ClassNotFoundException {
        // 1. Registra o driver
        Class.forName(DRIVER);
        
        // 2. Retorna a conexão (se falhar, vai lançar a SQLException)
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package config;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Classe de utilidade para criar hashes SHA-256.
 * ESSENCIAL para a segurança. NUNCA salve senhas em texto puro.
 */
public class HashUtil {

    /**
     * Converte uma string de texto puro (senha, palavra-chave) em um hash SHA-256.
     *
     * @param text O texto a ser hasheado.
     * @return A representação hexadecimal do hash SHA-256.
     */
    public static String toSHA256(String text) {
        if (text == null || text.isEmpty()) {
            return null;
        }
        try {
            // Obtém uma instância do algoritmo SHA-256
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            
            // Calcula o hash
            byte[] hashBytes = digest.digest(text.getBytes(StandardCharsets.UTF_8));
            
            // Converte o array de bytes para uma string hexadecimal
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
            
        } catch (NoSuchAlgorithmException e) {
            // Em um app real, isso não deve acontecer se o SHA-256 for padrão.
            System.err.println("Erro: Algoritmo SHA-256 não encontrado.");
            throw new RuntimeException("Erro de criptografia", e);
        }
    }
}

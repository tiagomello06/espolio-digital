/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package config;

import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

public class CryptoUtil {

    // CHAVE SECRETA DO SISTEMA (Deve ter 16 caracteres exatos para AES-128)
    // Em produção, isso ficaria em uma variável de ambiente, mas para o projeto acadêmico pode ficar aqui.
    private static final String CHAVE_MESTRA = "EspolioDigital25"; // 16 chars

    public static String criptografar(String valorOriginal) {
        if (valorOriginal == null || valorOriginal.isEmpty()) {
            return null;
        }
        try {
            SecretKeySpec secretKey = new SecretKeySpec(CHAVE_MESTRA.getBytes(), "AES");
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            
            byte[] dadosCriptografados = cipher.doFinal(valorOriginal.getBytes());
            // Retorna em Base64 para poder salvar no banco como String/Varchar
            return Base64.getEncoder().encodeToString(dadosCriptografados);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String descriptografar(String valorCriptografado) {
        if (valorCriptografado == null || valorCriptografado.isEmpty()) {
            return null;
        }
        try {
            SecretKeySpec secretKey = new SecretKeySpec(CHAVE_MESTRA.getBytes(), "AES");
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, secretKey);
            
            byte[] dadosOriginais = cipher.doFinal(Base64.getDecoder().decode(valorCriptografado));
            return new String(dadosOriginais);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
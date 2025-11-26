/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model.DAO;

import config.ConectaDB;
import config.CryptoUtil; // Importamos a nova classe
import model.AtivoDigital;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AtivoDigitalDAO {

    // Cadastrar (COM CRIPTOGRAFIA)
    public boolean cadastrarAtivoDigital(AtivoDigital ad) {
        String sql = "INSERT INTO ativodigital (id_usuario_titular, id_herdeiro, tipo_ativodigital, login, senha, frase_recuperacao, mensagem) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ad.getIdUsuarioTitular());
            ps.setInt(2, ad.getIdHerdeiro());
            ps.setString(3, ad.getTipoAtivoDigital());
            
            // Dados normais
            ps.setString(4, ad.getLogin());
            
            // --- CRIPTOGRAFIA APLICADA AQUI ---
            // Só criptografa se o dado existir
            String senhaCripto = (ad.getSenha() != null) ? CryptoUtil.criptografar(ad.getSenha()) : null;
            String fraseCripto = (ad.getFraseRecuperacao() != null) ? CryptoUtil.criptografar(ad.getFraseRecuperacao()) : null;
            String msgCripto   = (ad.getMensagem() != null) ? CryptoUtil.criptografar(ad.getMensagem()) : null;
            
            ps.setString(5, senhaCripto); 
            ps.setString(6, fraseCripto);
            ps.setString(7, msgCripto);
            // ----------------------------------
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Verificar Duplicidade (Mantém igual, compara string normal com banco)
    // Obs: Se quiser verificar duplicidade de senha criptografada, teria que criptografar a entrada antes de comparar.
    // Mas como login geralmente não é criptografado, o método abaixo continua funcionando para login.
    public boolean verificarDuplicidade(int idTitular, String tipo, String login) {
        if (login == null || login.isEmpty()) { return false; }
        String sql = "SELECT count(*) FROM ativodigital WHERE id_usuario_titular = ? AND tipo_ativodigital = ? AND login = ?";
        try (Connection conn = ConectaDB.conectar(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTitular);
            ps.setString(2, tipo);
            ps.setString(3, login);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { return rs.getInt(1) > 0; }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Listar (Traz os dados criptografados do banco, o Java não precisa ler eles na dashboard)
    public List<AtivoDigital> listarAtivosDigitaisDoTitular(int idTitular) {
        List<AtivoDigital> lista = new ArrayList<>();
        String sql = "SELECT a.*, h.nome as nome_herdeiro " +
                     "FROM ativodigital a " +
                     "JOIN herdeiro h ON a.id_herdeiro = h.id " +
                     "WHERE a.id_usuario_titular = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idTitular);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                AtivoDigital ad = new AtivoDigital();
                ad.setId(rs.getInt("id"));
                ad.setIdUsuarioTitular(rs.getInt("id_usuario_titular"));
                ad.setIdHerdeiro(rs.getInt("id_herdeiro"));
                ad.setTipoAtivoDigital(rs.getString("tipo_ativodigital"));
                ad.setLogin(rs.getString("login")); // Login continua legível
                
                // Os campos abaixo virão "embaralhados" (criptografados) do banco
                // O dashboard só verifica se é != null, então tudo bem vir embaralhado.
                ad.setSenha(rs.getString("senha")); 
                ad.setFraseRecuperacao(rs.getString("frase_recuperacao"));
                ad.setMensagem(rs.getString("mensagem"));
                
                ad.setNomeHerdeiro(rs.getString("nome_herdeiro"));
                
                lista.add(ad);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    // Excluir (Mantém igual)
    public boolean excluirAtivoDigital(int idAtivo) {
        String sql = "DELETE FROM ativodigital WHERE id = ?";
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAtivo);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
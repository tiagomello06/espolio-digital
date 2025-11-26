/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model.DAO;

import config.ConectaDB;
import model.LegadoDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

public class SolicitacaoDAO {

    // --- MÉTODO ATUALIZADO: Recebe byte[] docPdf ao invés de String ---
    public boolean solicitarDesbloqueioPorTitular(int idTitular, int idHerdeiroLogado, byte[] docPdf) {
        
        // SQL ajustada: Assume-se que a coluna 'caminho_documento' ou similar seja do tipo BLOB/LONGBLOB
        String sql = "INSERT INTO solicitacao_liberacao (id_ativo, id_usuario_solicitante, caminho_documento, status) " +
                     "SELECT id, ?, ?, 'PENDENTE' " +
                     "FROM ativodigital " +
                     "WHERE id_usuario_titular = ? AND id_herdeiro = (SELECT id FROM herdeiro WHERE id_usuario_titular = ? AND cpf = (SELECT cpf FROM usuario WHERE id = ?)) " +
                     "AND id NOT IN (SELECT id_ativo FROM solicitacao_liberacao WHERE id_usuario_solicitante = ?)";

        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idHerdeiroLogado);
            
            // MUDANÇA AQUI: Usamos setBytes para gravar o arquivo PDF
            ps.setBytes(2, docPdf); 
            
            ps.setInt(3, idTitular);
            
            // Parametros da subquery de validação do herdeiro
            ps.setInt(4, idTitular); 
            ps.setInt(5, idHerdeiroLogado);
            
            // Parametro do NOT IN
            ps.setInt(6, idHerdeiroLogado); 
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<LegadoDTO> listarLegadosDoHerdeiro(int idUsuarioLogado, String cpfUsuarioLogado) {
        List<LegadoDTO> lista = new ArrayList<>();
        
        String sql = "SELECT a.id as id_ativo, a.tipo_ativodigital, a.login, a.senha, a.frase_recuperacao, a.mensagem, " +
                     "       u_titular.id as id_titular, u_titular.nome as nome_titular, u_titular.foto_perfil, " +
                     "       s.status as status_solicitacao " +
                     "FROM ativodigital a " +
                     "JOIN herdeiro h ON a.id_herdeiro = h.id " +
                     "JOIN usuario u_titular ON a.id_usuario_titular = u_titular.id " +
                     "LEFT JOIN solicitacao_liberacao s ON s.id_ativo = a.id AND s.id_usuario_solicitante = ? " +
                     "WHERE h.cpf = ?"; 

        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuarioLogado);
            ps.setString(2, cpfUsuarioLogado); 
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                LegadoDTO dto = new LegadoDTO();
                dto.setIdAtivo(rs.getInt("id_ativo"));
                dto.setTipoAtivo(rs.getString("tipo_ativodigital"));
                dto.setLogin(rs.getString("login"));
                dto.setSenhaCripto(rs.getString("senha"));
                dto.setFraseCripto(rs.getString("frase_recuperacao"));
                dto.setMensagemCripto(rs.getString("mensagem"));
                dto.setNomeTitular(rs.getString("nome_titular"));
                
                // --- TRATAMENTO DA FOTO ---
                Blob blob = rs.getBlob("foto_perfil");
                if (blob != null) {
                    byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                    String base64 = Base64.getEncoder().encodeToString(imageBytes);
                    dto.setFotoTitularBase64(base64);
                }
                
                dto.setIdTitular(rs.getInt("id_titular"));
                
                String st = rs.getString("status_solicitacao");
                dto.setStatusSolicitacao(st == null ? "BLOQUEADO" : st);
                
                lista.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
}
/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model.DAO;

import config.ConectaDB;
import model.Herdeiro;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64; // Importante para converter a foto
import java.util.List;

public class HerdeiroDAO {

    public boolean cadastrarHerdeiro(Herdeiro h) {
        String sql = "INSERT INTO herdeiro (id_usuario_titular, nome, cpf, parentesco) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, h.getIdUsuarioTitular());
            ps.setString(2, h.getNome());
            ps.setString(3, h.getCpf());
            ps.setString(4, h.getParentesco());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Herdeiro> listarPorUsuario(int idTitular) {
        List<Herdeiro> lista = new ArrayList<>();
        String sql = "SELECT * FROM herdeiro WHERE id_usuario_titular = ?";
        
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idTitular);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Herdeiro h = new Herdeiro();
                h.setId(rs.getInt("id"));
                h.setIdUsuarioTitular(rs.getInt("id_usuario_titular"));
                h.setNome(rs.getString("nome"));
                h.setCpf(rs.getString("cpf"));
                h.setParentesco(rs.getString("parentesco"));
                
                // CHAMA O MÉTODO AUXILIAR QUE PREENCHE FOTO E STATUS
                buscarDadosDoUsuarioNaPlataforma(h, conn);
                
                lista.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    // MÉTODO NOVO: Verifica se existe e já pega a foto se tiver
    private void buscarDadosDoUsuarioNaPlataforma(Herdeiro h, Connection conn) {
        String sql = "SELECT foto_perfil FROM usuario WHERE cpf = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getCpf());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Se entrou aqui, o usuário existe
                h.setUsuarioCadastrado(true);
                
                // Tenta pegar a foto (BLOB)
                Blob blob = rs.getBlob("foto_perfil");
                if (blob != null) {
                    byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                    if (imageBytes != null && imageBytes.length > 0) {
                        // Converte bytes para String Base64 para exibir no HTML
                        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                        h.setFotoPerfilBase64(base64Image);
                    }
                }
            } else {
                h.setUsuarioCadastrado(false);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public boolean excluirHerdeiro(int idHerdeiro) {
        String sql = "DELETE FROM herdeiro WHERE id = ?";
        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idHerdeiro);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
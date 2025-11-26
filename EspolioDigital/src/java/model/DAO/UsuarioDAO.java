/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model.DAO;

import config.ConectaDB; // Importa sua classe de conexão
import model.Usuario;  // Importa a classe de modelo

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Classe DAO (Data Access Object) para a entidade Usuario.
 * Contém todos os métodos CRUD (Create, Read, Update)
 * para interagir com a tabela 'usuario' no banco de dados.
 */
public class UsuarioDAO {

    /**
     * INSERIR (Create)
     * Insere um novo usuário no banco de dados.
     * ATUALIZADO: Retorna boolean para seguir o padrão do professor (cliente.jsp).
     *
     * @param usuario O objeto Usuario contendo (nome, cpf, senhaHash, palavraChaveHash)
     * @return true se a inserção foi bem-sucedida, false caso contrário.
     */
    public boolean insertUsuario(Usuario usuario) {
// ... (código existente do insertUsuario) ...
        String sql = "INSERT INTO usuario (nome, cpf, senha_hash, palavra_chave_hash) VALUES (?, ?, ?, ?)";

        try (Connection conn = ConectaDB.conectar(); // Obtém uma conexão
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, usuario.getNome());
            ps.setString(2, usuario.getCpf());
            ps.setString(3, usuario.getSenhaHash());
            ps.setString(4, usuario.getPalavraChaveHash());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Retorna true se 1 (ou mais) linhas foram afetadas

        } catch (SQLException | ClassNotFoundException e) { 
            System.err.println("Erro ao inserir usuário: " + e.getMessage());
            // Se houver erro (ex: CPF duplicado), retorna false
            return false;
        }
    }

    /**
     * SELECIONAR (Read) - Por CPF
     * Busca um usuário no banco de dados pelo seu CPF.
     *
     * @param cpf O CPF (11 dígitos, apenas números) a ser buscado.
     * @return Um objeto Usuario completo se encontrado, ou null se não encontrado.
     */
    public Usuario getUsuarioPorCPF(String cpf) {
// ... (código existente do getUsuarioPorCPF) ...
        String sql = "SELECT * FROM usuario WHERE cpf = ?";
        Usuario usuario = null;

        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, cpf);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Se encontrou, popula o objeto Usuario
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNome(rs.getString("nome"));
                    usuario.setCpf(rs.getString("cpf"));
                    usuario.setSenhaHash(rs.getString("senha_hash"));
                    usuario.setPalavraChaveHash(rs.getString("palavra_chave_hash"));
                    usuario.setFotoPerfil(rs.getBytes("foto_perfil"));
                }
            }

        } catch (SQLException | ClassNotFoundException e) { 
            System.err.println("Erro ao buscar usuário por CPF: " + e.getMessage());
        }
        
        return usuario; // Retorna o usuário (ou null se não achou)
    }

    /**
     * SELECIONAR (Read) - Por ID
     * Busca um usuário no banco de dados pelo seu ID (chave primária).
     *
     * @param id O ID (int) do usuário.
     * @return Um objeto Usuario completo se encontrado, ou null se não encontrado.
     */
    public Usuario getUsuarioPorId(int id) {
// ... (código existente do getUsuarioPorId) ...
        String sql = "SELECT * FROM usuario WHERE id = ?";
        Usuario usuario = null;

        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNome(rs.getString("nome"));
                    usuario.setCpf(rs.getString("cpf"));
                    usuario.setSenhaHash(rs.getString("senha_hash"));
                    usuario.setPalavraChaveHash(rs.getString("palavra_chave_hash"));
                    usuario.setFotoPerfil(rs.getBytes("foto_perfil"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) { 
            System.err.println("Erro ao buscar usuário por ID: " + e.getMessage());
        }
        
        return usuario;
    }


    /**
     * ATUALIZAR (Update) - Recuperação de Senha (versão antiga)
     * Este método não é seguro para recuperação, pois não valida a palavra-chave.
     * Vamos manter, mas criar um novo e melhor.
     */
    public boolean updateSenhaPorCPF(String cpf, String novaSenhaHash) {
// ... (código existente do updateSenhaPorCPF) ...
        String sql = "UPDATE usuario SET senha_hash = ? WHERE cpf = ?";

        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, novaSenhaHash);
            ps.setString(2, cpf);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Retorna true se 1 (ou mais) linhas foram afetadas

        } catch (SQLException | ClassNotFoundException e) { 
            System.err.println("Erro ao atualizar senha por CPF: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * ATUALIZAR (Update) - Edição de Perfil
     * Atualiza os dados do perfil (foto, senha) com base no ID.
     * Este método não altera mais a palavra-chave.
     *
     * @param id O ID do usuário a ser atualizado.
     * @param foto A nova foto (em bytes), ou null para não alterar.
     * @param novaSenhaHash A nova senha (com hash), ou null/vazio para não alterar.
     * @return true se a atualização foi bem-sucedida, false caso contrário.
     */
    public boolean updatePerfil(int id, byte[] foto, String novaSenhaHash) {
// ... (código existente do updatePerfil) ...
        // SQL dinâmico para atualizar apenas os campos necessários
        StringBuilder sql = new StringBuilder("UPDATE usuario SET ");
        boolean needComma = false;

        if (foto != null && foto.length > 0) {
            sql.append("foto_perfil = ?");
            needComma = true;
        }

        if (novaSenhaHash != null && !novaSenhaHash.isEmpty()) {
            if (needComma) sql.append(", ");
            sql.append("senha_hash = ?");
            needComma = true;
        }
        
        // Se nenhum campo foi alterado, não faz nada
        if (!needComma) {
            System.out.println("Nenhum campo para atualizar.");
            return true; // Nenhum erro, mas nada a fazer
        }

        sql.append(" WHERE id = ?");

        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;

            if (foto != null && foto.length > 0) {
                ps.setBytes(paramIndex++, foto);
            }
            if (novaSenhaHash != null && !novaSenhaHash.isEmpty()) {
                ps.setString(paramIndex++, novaSenhaHash);
            }
            
            ps.setInt(paramIndex, id);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) { 
            System.err.println("Erro ao atualizar perfil do usuário: " + e.getMessage());
            return false;
        }
    }
    
    // =================================================================
    // ===== NOVO MÉTODO PARA RECUPERAÇÃO DE SENHA =====
    // =================================================================
    
    /**
     * ATUALIZAR (Update) - Redefinição de Senha Segura
     * Atualiza a senha APENAS SE o CPF e a Palavra Chave baterem.
     *
     * @param cpf O CPF do usuário.
     * @param palavraChaveHash A palavra-chave (já com hash)
     * @param novaSenhaHash A nova senha (já com hash)
     * @return true se a atualização foi bem-sucedida, false caso contrário.
     */
    public boolean redefinirSenha(String cpf, String palavraChaveHash, String novaSenhaHash) {
        // Este SQL é atômico: ele só vai atualizar (e retornar 1) se
        // AMBAS as condições (cpf E palavra_chave_hash) forem verdadeiras.
        String sql = "UPDATE usuario SET senha_hash = ? WHERE cpf = ? AND palavra_chave_hash = ?";

        try (Connection conn = ConectaDB.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, novaSenhaHash);
            ps.setString(2, cpf);
            ps.setString(3, palavraChaveHash);
            
            int rowsAffected = ps.executeUpdate();
            
            // Se rowsAffected > 0, significa que o CPF e a Palavra-Chave bateram
            return rowsAffected > 0; 

        } catch (SQLException | ClassNotFoundException e) { 
            System.err.println("Erro ao redefinir senha: " + e.getMessage());
            return false;
        }
    }
}
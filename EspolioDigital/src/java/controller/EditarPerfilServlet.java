/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package controller;

import config.HashUtil;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.DAO.UsuarioDAO;
import model.Usuario;
// Você precisa adicionar a biblioteca 'Apache Commons IO' ao projeto
import org.apache.commons.io.IOUtils; 

/**
 * Servlet para processar a ATUALIZAÇÃO do perfil do usuário.
 * 1. Recebe a foto (se houver)
 * 2. Recebe a nova senha (se houver)
 * 3. Atualiza o banco de dados
 * 4. Atualiza a sessão
 * @MultipartConfig é OBRIGATÓRIO para formulários que enviam arquivos (fotos).
 */
@WebServlet(name = "EditarPerfilServlet", urlPatterns = {"/EditarPerfilServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class EditarPerfilServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false); // Pega a sessão existente

        // 1. Guarda de Segurança: Verifica se o usuário está logado
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login_cadastro.html?loginErro=true");
            return;
        }

        // 2. Pega o usuário da sessão
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
        int idUsuario = usuarioLogado.getId();
        
        // 3. Prepara variáveis para o DAO
        byte[] fotoBytes = null;
        String novaSenhaHash = null;
        
        // Flag para sabermos se a atualização no DAO foi bem-sucedida
        boolean sucessoDAO = false;
        boolean algoParaAtualizar = false;

        try {
            // 4. Processa a FOTO (se ela foi enviada)
            Part filePart = request.getPart("fotoPerfil"); // 'fotoPerfil' é o 'name' do input
            if (filePart != null && filePart.getSize() > 0) {
                algoParaAtualizar = true; // Marcamos que temos algo para salvar
                try (InputStream inputStream = filePart.getInputStream()) {
                    // Usamos a biblioteca Apache Commons IO para converter InputStream para byte[]
                    fotoBytes = IOUtils.toByteArray(inputStream);
                }
            }

            // 5. Processa a SENHA (se ela foi enviada)
            String novaSenha = request.getParameter("senha");
            if (novaSenha != null && !novaSenha.trim().isEmpty()) {
                algoParaAtualizar = true; // Marcamos que temos algo para salvar
                String confirmaSenha = request.getParameter("confirmar_senha");
                
                // Validação de confirmação (o JS já fez, mas checamos de novo)
                if (novaSenha.equals(confirmaSenha)) {
                    novaSenhaHash = HashUtil.toSHA256(novaSenha);
                } else {
                    System.err.println("Tentativa de alterar senha falhou: senhas não conferem.");
                    // Se as senhas não batem, redireciona com erro
                    response.sendRedirect("1 - usuario/2 - tela geral.jsp?erro=senhas");
                    return;
                }
            }

            // 6. Chama o DAO para atualizar (apenas se houver algo para mudar)
            if (algoParaAtualizar) {
                UsuarioDAO usuarioDAO = new UsuarioDAO();
                sucessoDAO = usuarioDAO.updatePerfil(idUsuario, fotoBytes, novaSenhaHash);

                if (sucessoDAO) {
                    // 7. IMPORTANTE: Atualizar a sessão!
                    // Buscamos o usuário atualizado do banco
                    Usuario usuarioAtualizado = usuarioDAO.getUsuarioPorId(idUsuario);
                    session.setAttribute("usuarioLogado", usuarioAtualizado);
                }
            } else {
                // Se não tinha nada para atualizar (ex: só clicou em salvar)
                // consideramos um "sucesso" pois não houve erro.
                sucessoDAO = true;
            }
            
            // 8. Redireciona de volta para a tela de Edição com feedback
            if (sucessoDAO) {
                response.sendRedirect("1 - usuario/2 - tela geral.jsp?sucesso=true");
            } else {
                response.sendRedirect("1 - usuario/2 - tela geral.jsp?erro=true");
            }

        } catch (Exception e) {
            System.err.println("Erro no EditarPerfilServlet: " + e.getMessage());
            e.printStackTrace();
            // Em caso de erro, manda para a tela de edição com feedback de erro
            response.sendRedirect("1 - usuario/2 - tela geral.jsp?erro=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para processar a edição do perfil do usuário.";
    }
}
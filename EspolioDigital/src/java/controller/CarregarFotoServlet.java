/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package controller;

import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Usuario;

/**
 * Servlet dedicado a carregar e exibir a foto de perfil do usuário
 * que está logado na sessão.
 */
@WebServlet(name = "CarregarFotoServlet", urlPatterns = {"/CarregarFotoServlet"})
public class CarregarFotoServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false); // Pega a sessão, não cria uma nova

            // 1. Guarda de Segurança: Verifica se o usuário está logado
            if (session == null || session.getAttribute("usuarioLogado") == null) {
                // Se não estiver logado, não há foto para mostrar
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 2. Pega o usuário da sessão
            Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
            byte[] fotoBytes = usuarioLogado.getFotoPerfil();

            // 3. Verifica se o usuário TEM uma foto
            if (fotoBytes != null && fotoBytes.length > 0) {
                
                // 4. Configura a Resposta
                response.setContentType("image/jpeg"); // Ou image/png, dependendo do upload
                response.setContentLength(fotoBytes.length);
                
                // Define cabeçalhos para evitar cache (para que a foto mude se o usuário atualizar)
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                // 5. Escreve os bytes da imagem diretamente na resposta
                try (OutputStream out = response.getOutputStream()) {
                    out.write(fotoBytes);
                }
                
            } else {
                // 6. Se o usuário não tem foto, envia um 404 (Não Encontrado)
                // O navegador mostrará o 'alt' text ou o ícone de imagem quebrada.
                // (No JSP, nós tratamos isso mostrando um ícone padrão)
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            System.err.println("Erro ao carregar foto: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
}
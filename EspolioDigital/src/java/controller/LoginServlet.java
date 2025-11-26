/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package controller;

import config.HashUtil;
import model.DAO.UsuarioDAO;
import model.Usuario;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet (Controller) para processar o login do usuário.
 * Mapeado para a URL "/LoginServlet", que é o 'action' do formulário de login.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // 1. Obter os dados do formulário (da tela login_cadastro.html)
            String cpf = request.getParameter("cpf");
            String senhaDigitada = request.getParameter("senha");

            // Validação simples
            if (cpf == null || senhaDigitada == null || cpf.trim().isEmpty() || senhaDigitada.trim().isEmpty()) {
                // Redireciona de volta com erro
                response.sendRedirect("login_cadastro.html?erro=1");
                return;
            }

            // 2. Criptografar a senha digitada para comparar com o banco
            String senhaHashDigitada = HashUtil.toSHA256(senhaDigitada);

            // 3. Chamar o DAO para verificar o usuário
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuarioDoBanco = usuarioDAO.getUsuarioPorCPF(cpf);

            // 4. Lógica de Verificação
            // Verifica se o usuário existe E se a senha hasheada do banco é igual à senha hasheada digitada
            if (usuarioDoBanco != null && usuarioDoBanco.getSenhaHash().equals(senhaHashDigitada)) {
                
                // SUCESSO NO LOGIN
                
                // 5. Criar uma Sessão para "manter o usuário logado"
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuarioDoBanco); // Salva o objeto 'Usuario' inteiro na sessão
                session.setAttribute("usuarioNome", usuarioDoBanco.getNome()); // Salva só o nome (para facilitar o "Olá, João!")
                
                // 6. Redirecionar para o Dashboard Principal
                // (Caminho baseado na sua estrutura de arquivos)
                response.sendRedirect("1 - usuario/1 - tela geral.jsp");
                
            } else {
                
                // FALHA NO LOGIN
                
                // 7. Redirecionar de volta para a tela de login com uma mensagem de erro
                // O '?erro=1' será lido pelo JavaScript no HTML para mostrar a mensagem
                response.sendRedirect("login_cadastro.html?erro=1");
            }

        } catch (Exception e) {
            // Lidar com erros inesperados
            System.err.println("Erro grave no LoginServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login_cadastro.html?erro=2"); // Erro genérico
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
        return "Servlet para autenticação de usuário";
    }
}
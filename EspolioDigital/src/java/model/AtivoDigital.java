/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model;

public class AtivoDigital {
    private int id;
    private int idUsuarioTitular;
    private int idHerdeiro;
    private String tipoAtivoDigital; // Variável renomeada
    
    private String login;
    private String senha;
    private String fraseRecuperacao;
    private String mensagem;
    
    // Auxiliar para exibição
    private String nomeHerdeiro; 

    public AtivoDigital() {}

    public AtivoDigital(int idUsuarioTitular, int idHerdeiro, String tipoAtivoDigital, String login, String senha, String fraseRecuperacao, String mensagem) {
        this.idUsuarioTitular = idUsuarioTitular;
        this.idHerdeiro = idHerdeiro;
        this.tipoAtivoDigital = tipoAtivoDigital;
        this.login = login;
        this.senha = senha;
        this.fraseRecuperacao = fraseRecuperacao;
        this.mensagem = mensagem;
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuarioTitular() { return idUsuarioTitular; }
    public void setIdUsuarioTitular(int idUsuarioTitular) { this.idUsuarioTitular = idUsuarioTitular; }

    public int getIdHerdeiro() { return idHerdeiro; }
    public void setIdHerdeiro(int idHerdeiro) { this.idHerdeiro = idHerdeiro; }

    public String getTipoAtivoDigital() { return tipoAtivoDigital; }
    public void setTipoAtivoDigital(String tipoAtivoDigital) { this.tipoAtivoDigital = tipoAtivoDigital; }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public String getFraseRecuperacao() { return fraseRecuperacao; }
    public void setFraseRecuperacao(String fraseRecuperacao) { this.fraseRecuperacao = fraseRecuperacao; }

    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }

    public String getNomeHerdeiro() { return nomeHerdeiro; }
    public void setNomeHerdeiro(String nomeHerdeiro) { this.nomeHerdeiro = nomeHerdeiro; }
}
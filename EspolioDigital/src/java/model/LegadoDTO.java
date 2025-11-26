/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model;

public class LegadoDTO {
    
    // --- Dados do Ativo ---
    private int idAtivo;
    private String tipoAtivo;
    private String login;
    private String senhaCripto;    // Só mostraremos se estiver aprovado
    private String fraseCripto;
    private String mensagemCripto;
    
    // --- Dados do Titular (Falecido) ---
    private int idTitular;         // Novo: Usado para agrupar os cards
    private String nomeTitular;
    private String fotoTitularBase64; // Novo: Foto de perfil do titular
    
    // --- Dados da Solicitação ---
    private String statusSolicitacao; // NULL (não pediu), PENDENTE, APROVADO

    
    // ================= GETTERS E SETTERS =================

    public int getIdAtivo() {
        return idAtivo;
    }

    public void setIdAtivo(int idAtivo) {
        this.idAtivo = idAtivo;
    }

    public String getTipoAtivo() {
        return tipoAtivo;
    }

    public void setTipoAtivo(String tipoAtivo) {
        this.tipoAtivo = tipoAtivo;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getSenhaCripto() {
        return senhaCripto;
    }

    public void setSenhaCripto(String senhaCripto) {
        this.senhaCripto = senhaCripto;
    }

    public String getFraseCripto() {
        return fraseCripto;
    }

    public void setFraseCripto(String fraseCripto) {
        this.fraseCripto = fraseCripto;
    }

    public String getMensagemCripto() {
        return mensagemCripto;
    }

    public void setMensagemCripto(String mensagemCripto) {
        this.mensagemCripto = mensagemCripto;
    }

    // --- Getters/Setters do Titular ---

    public int getIdTitular() {
        return idTitular;
    }

    public void setIdTitular(int idTitular) {
        this.idTitular = idTitular;
    }

    public String getNomeTitular() {
        return nomeTitular;
    }

    public void setNomeTitular(String nomeTitular) {
        this.nomeTitular = nomeTitular;
    }

    public String getFotoTitularBase64() {
        return fotoTitularBase64;
    }

    public void setFotoTitularBase64(String fotoTitularBase64) {
        this.fotoTitularBase64 = fotoTitularBase64;
    }

    // --- Getters/Setters do Status ---

    public String getStatusSolicitacao() {
        return statusSolicitacao;
    }

    public void setStatusSolicitacao(String statusSolicitacao) {
        this.statusSolicitacao = statusSolicitacao;
    }
}
/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model;

public class Herdeiro {
    private int id;
    private int idUsuarioTitular;
    private String nome;
    private String cpf;
    private String parentesco;
    
    private boolean usuarioCadastrado; 
    
    // NOVO CAMPO: Para guardar a foto convertida em texto
    private String fotoPerfilBase64;

    public Herdeiro() {}

    public Herdeiro(int idUsuarioTitular, String nome, String cpf, String parentesco) {
        this.idUsuarioTitular = idUsuarioTitular;
        this.nome = nome;
        this.cpf = cpf;
        this.parentesco = parentesco;
    }

    // Getters e Setters existentes...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuarioTitular() { return idUsuarioTitular; }
    public void setIdUsuarioTitular(int idUsuarioTitular) { this.idUsuarioTitular = idUsuarioTitular; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    
    public String getParentesco() { return parentesco; }
    public void setParentesco(String parentesco) { this.parentesco = parentesco; }

    public boolean isUsuarioCadastrado() { return usuarioCadastrado; }
    public void setUsuarioCadastrado(boolean usuarioCadastrado) { this.usuarioCadastrado = usuarioCadastrado; }

    // NOVOS GETTER E SETTER DA FOTO
    public String getFotoPerfilBase64() { return fotoPerfilBase64; }
    public void setFotoPerfilBase64(String fotoPerfilBase64) { this.fotoPerfilBase64 = fotoPerfilBase64; }
}
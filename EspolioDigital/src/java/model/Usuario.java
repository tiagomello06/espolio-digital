/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model;

/**
 * Classe de Modelo (POJO) que representa a entidade 'usuario' do banco de dados.
 * Esta classe é baseada nos campos do formulário de cadastro 
 * (Nome, CPF, Senha, Palavra-Chave) e na tabela 'usuario' do schema SQL.
 */
public class Usuario {

    private int id;
    private String nome;
    private String cpf; // Usado como login e identificador único
    private String senhaHash; // Armazena a senha com hash (ex: SHA-256)
    private String palavraChaveHash; // Armazena a palavra-chave com hash
    private byte[] fotoPerfil; // Armazena os bytes da imagem (MEDIUMBLOB)

    /**
     * Construtor padrão (vazio).
     */
    public Usuario() {
    }

    /**
     * Construtor para INSERIR um novo usuário (sem id, pois é AUTO_INCREMENT).
     * A foto é nula no cadastro inicial.
     */
    public Usuario(String nome, String cpf, String senhaHash, String palavraChaveHash) {
        this.nome = nome;
        this.cpf = cpf;
        this.senhaHash = senhaHash;
        this.palavraChaveHash = palavraChaveHash;
        // fotoPerfil começa como null
    }

    /**
     * Construtor completo para LER um usuário do banco de dados.
     */
    public Usuario(int id, String nome, String cpf, String senhaHash, String palavraChaveHash, byte[] fotoPerfil) {
        this.id = id;
        this.nome = nome;
        this.cpf = cpf;
        this.senhaHash = senhaHash;
        this.palavraChaveHash = palavraChaveHash;
        this.fotoPerfil = fotoPerfil;
    }

    // --- Getters e Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getSenhaHash() {
        return senhaHash;
    }

    public void setSenhaHash(String senhaHash) {
        this.senhaHash = senhaHash;
    }

    public String getPalavraChaveHash() {
        return palavraChaveHash;
    }

    public void setPalavraChaveHash(String palavraChaveHash) {
        this.palavraChaveHash = palavraChaveHash;
    }

    public byte[] getFotoPerfil() {
        return fotoPerfil;
    }

    public void setFotoPerfil(byte[] fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }
}
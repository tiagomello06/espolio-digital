/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model;

import java.sql.Timestamp;

public class SolicitacaoLiberacao {
    private int id;
    private int idAtivo;
    private int idUsuarioSolicitante;
    private Timestamp dataSolicitacao;
    private String status;
    
    // MUDANÇA IMPORTANTE:
    // Antes era String (caminho), agora é byte[] (o arquivo PDF em si)
    // No banco de dados, isso mapeia para a coluna 'caminho_documento' (que virou LONGBLOB)
    private byte[] documentoArquivo; 

    // Construtores
    public SolicitacaoLiberacao() {}

    // Construtor atualizado para receber byte[]
    public SolicitacaoLiberacao(int idAtivo, int idUsuarioSolicitante, byte[] documentoArquivo) {
        this.idAtivo = idAtivo;
        this.idUsuarioSolicitante = idUsuarioSolicitante;
        this.documentoArquivo = documentoArquivo;
        this.status = "PENDENTE";
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdAtivo() { return idAtivo; }
    public void setIdAtivo(int idAtivo) { this.idAtivo = idAtivo; }

    public int getIdUsuarioSolicitante() { return idUsuarioSolicitante; }
    public void setIdUsuarioSolicitante(int idUsuarioSolicitante) { this.idUsuarioSolicitante = idUsuarioSolicitante; }

    public Timestamp getDataSolicitacao() { return dataSolicitacao; }
    public void setDataSolicitacao(Timestamp dataSolicitacao) { this.dataSolicitacao = dataSolicitacao; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Getters e Setters atualizados para o arquivo
    public byte[] getDocumentoArquivo() { return documentoArquivo; }
    public void setDocumentoArquivo(byte[] documentoArquivo) { this.documentoArquivo = documentoArquivo; }
}
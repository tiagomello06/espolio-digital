/**
 * TIAGO KAUAN 
 * DIEGO HENRIQUE
 * NICOLY MARTINELI
 */

package model;

import java.util.ArrayList;
import java.util.List;

public class LegadoAgrupado {
    private int idTitular;
    private String nomeTitular;
    private String fotoTitularBase64; // Novo: Foto do falecido
    private String statusGeral; // BLOQUEADO, PENDENTE, APROVADO
    private List<LegadoDTO> ativos; // Lista dos itens (Face, Insta, etc)

    public LegadoAgrupado() {
        this.ativos = new ArrayList<>();
        this.statusGeral = "BLOQUEADO"; // Padrão
    }

    public void adicionarAtivo(LegadoDTO ativo) {
        this.ativos.add(ativo);
    }

    // Getters e Setters
    public int getIdTitular() { return idTitular; }
    public void setIdTitular(int idTitular) { this.idTitular = idTitular; }

    public String getNomeTitular() { return nomeTitular; }
    public void setNomeTitular(String nomeTitular) { this.nomeTitular = nomeTitular; }

    public String getFotoTitularBase64() { return fotoTitularBase64; }
    public void setFotoTitularBase64(String fotoTitularBase64) { this.fotoTitularBase64 = fotoTitularBase64; }

    public String getStatusGeral() { return statusGeral; }
    public void setStatusGeral(String statusGeral) { this.statusGeral = statusGeral; }

    public List<LegadoDTO> getAtivos() { return ativos; }
    public void setAtivos(List<LegadoDTO> ativos) { this.ativos = ativos; }
}
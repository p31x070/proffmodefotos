## Documentação do Script: Atualização de Metadados, Permissões e Geração de Hash de Fotos (Linux)

### Descrição

Este script em Bash automatiza o processo de atualização de metadados, permissões e geração de hash de arquivos de imagem em uma pasta especificada. Ele é projetado para ser usado em ambientes Linux, especialmente no Ubuntu, e requer o ExifTool e jq para funcionar corretamente.

### Funcionalidades

1. **Inserção de Metadados:**
   - Adiciona informações de autor e contato (e-mail) aos metadados XMP das imagens.
   - Os valores padrão para autor e e-mail podem ser alterados diretamente no código-fonte do script:
     - `autor="Luiz Peixoto de Siqueira Filho"`
     - `email="peixoto@luizpeixoto.com"`

2. **Cálculo de Hash:**
   - Calcula o hash SHA256 de cada arquivo de imagem para fins de verificação de integridade.

3. **Exportação de Metadados:**
   - Exporta os metadados das imagens, incluindo o hash calculado, para um arquivo CSV ou JSON.
   - O formato de saída pode ser escolhido através de uma opção de linha de comando.

4. **Alteração de Permissões:**
   - Define as permissões dos arquivos de imagem para que apenas o proprietário possa modificá-los.

### Uso

**Pré-requisitos:**

* **ExifTool:**
   - Repositório: `universe`
   - Instalação: `sudo apt install libimage-exiftool-perl`
* **jq:**
   - Repositório: `universe`
   - Instalação: `sudo apt install jq`
* **curl:**
   - Repositório: `main`
   - Instalação: `sudo apt install curl`

**Execução:**

1. **Baixe o script:**
   ```bash
   curl -O https://seu_servidor/atualizar_fotos_pasta.sh
   ```
   Substitua `https://seu_servidor/atualizar_fotos_pasta.sh` pelo URL real do script.

2. **Dê permissão de execução:**
   ```bash
   chmod +x atualizar_fotos_pasta.sh
   ```

3. **Execute o script:**
   ```bash
   ./atualizar_fotos_pasta.sh [-d pasta] [-f formato_saida] [-h]
   ```

**Opções:**

* `-d pasta`: Caminho para a pasta contendo as imagens (obrigatório).
* `-f formato_saida`: Formato de saída dos metadados (`csv`, `json` ou `ambos`, opcional, padrão: `csv`).
* `-h`: Exibe a ajuda do script.

**Exemplos:**

```bash
# Atualiza metadados, gera CSV e altera permissões na pasta "fotos"
./atualizar_fotos_pasta.sh -d fotos

# Atualiza metadados, gera JSON e altera permissões na pasta "imagens"
./atualizar_fotos_pasta.sh -d imagens -f json

# Atualiza metadados, gera CSV e JSON, e altera permissões na pasta "pics"
./atualizar_fotos_pasta.sh -d pics -f ambos
```

### Saída

* **CSV:** Um arquivo chamado `metadados_fotos.csv` com as colunas "Arquivo", "Hash", "Autor" e "Email".
* **JSON:** Um arquivo chamado `metadados_fotos.json` com um array de objetos, cada um contendo as informações "Arquivo", "Hash", "Autor" e "Email" de uma imagem.

### Observações

* O script processa apenas arquivos regulares (não diretórios) dentro da pasta especificada.
* Os arquivos de saída CSV e JSON são criados na mesma pasta do script.
* Certifique-se de ter permissão de escrita na pasta de destino dos arquivos de saída.
* Esta é uma versão para Linux. Versões para Windows serão disponibilizadas posteriormente.

### Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir um pull request no repositório do projeto.

### Licença

Este script é distribuído sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

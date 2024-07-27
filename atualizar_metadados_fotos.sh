#!/bin/bash

# Função para exibir a ajuda
function mostrar_ajuda {
    echo "Uso: $0 [-d pasta] [-f formato_saida] [-h]"
    echo "  -d pasta: Pasta contendo as fotos (obrigatório)"
    echo "  -f formato_saida: Formato de saída (csv ou json, opcional, padrão: csv)"
    echo "  -h: Exibe esta ajuda"
    exit 1
}

# Verificar se o ExifTool está instalado
command -v exiftool >/dev/null 2>&1 || { echo >&2 "ExifTool não encontrado. Instale-o com 'sudo apt install libimage-exiftool-perl'"; exit 1; }

# Dados do autor (padrão)
autor="Luiz Peixoto de Siqueira Filho"
email="peixoto@luizpeixoto.com"

# Opções de linha de comando
pasta=""
formato_saida="csv"

while getopts ":d:f:h" opt; do
    case $opt in
        d) pasta="$OPTARG" ;;
        f) formato_saida="$OPTARG" ;;
        h) mostrar_ajuda ;;
        \?) echo "Opção inválida: -$OPTARG" >&2; mostrar_ajuda ;;
    esac
done

# Verificar se a pasta foi especificada
if [[ -z "$pasta" ]]; then
    echo "Especifique a pasta com a opção -d." >&2
    mostrar_ajuda
fi

# Verificar se a pasta existe
if [[ ! -d "$pasta" ]]; then
    echo "Pasta não encontrada: $pasta" >&2
    exit 1
fi

# Verificar se o formato de saída é válido
if [[ "$formato_saida" != "csv" && "$formato_saida" != "json" && "$formato_saida" != "ambos" ]]; then
    echo "Formato de saída inválido. Use 'csv', 'json' ou 'ambos'." >&2
    exit 1
fi

# Nomes dos arquivos de saída
nome_arquivo_csv="metadados_fotos.csv"
nome_arquivo_json="metadados_fotos.json"

# Cabeçalho do CSV
if [[ "$formato_saida" == "csv" || "$formato_saida" == "ambos" ]]; then
    echo "Arquivo,Hash,Autor,Email" > "$nome_arquivo_csv"
fi

# Processar as fotos na pasta
for foto in "$pasta"/*; do
    if [[ -f "$foto" ]]; then
        # Inserir metadados
        exiftool -XPAuthor="$autor" -XPComment="$email" "$foto"

        # Calcular hash
        hash=$(sha256sum "$foto" | awk '{print $1}')

        # Exportar metadados (com hash)
        if [[ "$formato_saida" == "csv" || "$formato_saida" == "ambos" ]]; then
            echo "$foto,$hash,$autor,$email" >> "$nome_arquivo_csv"
        fi
        if [[ "$formato_saida" == "json" || "$formato_saida" == "ambos" ]]; then
            exiftool -json -a -u -g1 "$foto" > temp.json
            jq -n --arg arquivo "$foto" --arg hash "$hash" --arg autor "$autor" --arg email "$email" '{Arquivo: $arquivo, Hash: $hash, Autor: $autor, Email: $email} + .' temp.json >> "$nome_arquivo_json"
            rm temp.json
        fi

        # Alterar permissões (somente proprietário pode escrever)
        chmod u+w,go-w "$foto"
    fi
done

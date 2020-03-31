# Preparando seu ambiente de estudos

Vamos assumir que o diretório onde você vai manter seus arquivos de estudos será
`~/ep`.

## 1. Clone o repositório da CLI do Estágio em Programação

A CLI (Command Line Interface) do Estágio em Programação será usada para
inicializar a sua pasta de estudos:

```bash
git clone https://github.com/infosimples/estagio-em-programacao-cli.git ~/ep
```

## 2. Prepare o ambiente Docker

Instale Docker: https://docs.docker.com/install/

Prepare seu ambiente:

```bash
cd ~/ep
docker build -t ep .
docker run -it -v ~/ep:/root/ep ep bash
```


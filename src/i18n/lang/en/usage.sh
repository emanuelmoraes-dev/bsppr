# displays help message
_usage () {
	cat <<EOF
 usage: ${0##*/} [Options|Flags]
   Options:
     --install,  -i  Instala bsprp
     --unistall, -u  Desinstala bsprp
     --version,  -v  Mostra a versão
     --help,     -h  Mostra uma mensagem de ajuda
     --update,   -U  Atualiza o seu sistema
   Flags:
     --pt            Define a linguagem para porguês. Detectado
                     automaticamente por padrão
     --en            Define a linguagem para inglês. Detectado
                     automaticamente por padrão
     --use-colors    Coloriza as mensagens, erros e avisos. Ista flag é
                     habilitada por padrão
     --not-colors    Não coloriza as mensagens, erros e avisos. Ista flag
                     não é habilitada por padrão
     --use-wallpaper Define um novo papel de parede. Esta flag é
                     habilitada por padrão
     --not-wallpaper Não define um novo papel de parede. Esta flag não é
                     habilitada por padrão
     --wallpaper     O próximo parâmetro define o caminho para o novo
                     papel de parede. Valor padrão:
                     bsprp/img/wallpaper.jpg
     --apt-based     Usa apt-get para instalar os pacotes. Detectado
                     automaticamente por padrão
     --pacman-based  Usa pacman para instalar os pacotes. Detectado
                     automaticamente por padrão
     --linux-mint    Define o nome da distribuição para "Linux Mint".
                     Detectado automaticamente por padrão
     --ubuntu        Define o nome da distribuição para "Ubuntu".
                     Detectado automaticamente por padrão
     --debian        Define o nome da distribuição para "Debian".
                     Detectado automaticamente por padrão
     --arch-linux    Define o nome da distribuição para "Arch Linux".
                     Detectado automaticamente por padrão
     --generic       Define o nome da distribuição para "Linux". Detectado
                     automaticamente por padrão
     --distroname    O próximo parâmetro define o nome da distribuição que
                     irá estar graficamente visível (isto não identifica a
                     sua distribuição). Valor padrão: o mesmo valor
                     definido por --linux-mint, --ubuntu, --debian,
                     --arch-linux ou --generic

 * Marcos Oliveira - <terminalroot.com.br> - APTPORN 2.0
 * Emanuel Moraes - <https://github.com/emanuelmoraes-dev> - BSPRP 3.0
EOF
}


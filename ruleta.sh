#!/bin/bash

# Colores
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

function ctrl_c(){
	echo -e "${red}\n\n[!] Saliendo...${end}\n"
	tput cnorm; exit 1

}

# Ctrl + C
trap ctrl_c INT


#Funciones
function helpPanel(){
	echo -e "${yellow}\n[+]${end} ${gray}Uso:${end} ${purple}$0${end} "
	echo -e "\t ${blue}-m)${end} ${green}Dinero con el que se desea jugar${end}"
	echo -e "\t ${blue}-t)${end}${green} Técnica a utilizar (martingala o inverseLabrouchere)\n${end}"

}

function martingala(){
	echo -e "${yellow}\n[+]${end} ${blue}Dinero actual:${end} ${gray}$money${end} ${blue}€${end}"
	echo -ne "${yellow}[+]${end} ${blue}¿Cuánto dinero tienes pensado apostar?${end} ${purple}->${end} " && read initial_bet
	echo -ne "${yellow}[+]${end} ${blue}¿A que deseas apostar continuamente? (${end}${green}par${end}${blue}/${end}${green}impar${end}${blue})${end} ${purple}->${end} " && read par_impar

	echo -e "\n${yellow}[+]${end} ${blue}Se va a comenzar apostando${end} ${green}$initial_bet${end} ${blue}€ a números${end} ${green}$par_impar${end}"
	backup_bet=$initial_bet
	tput civis # Ocultar el cursos

	play_counter=1
	jugadas_malas=""
	max_money="$money"

	while true; do
		money=$(($money-$initial_bet))
		echo -e "${yellow}\n\n\n[+]${end} ${blue}Acabas de apostar${end} ${green}$initial_bet${end}${blue} €, te quedan${end} ${green}$money${end}${blue} €${end}"
		random_number="$((RANDOM % 37))"
		echo -e "\n${yellow}[+]${end} ${blue}Ha salido el número${end} ${green}$random_number${end}"



	if [ ! "$money" -lt 0 ]; then
		if [ "$par_impar" == "par" ]; then
			if [ "$(($random_number % 2))" -eq 0 ]; then

				if [ "$random_number" -eq 0 ]; then
					echo -e "${yellow}[+]${end} ${blue}Ha salido el 0,${end} ${red}¡Has perdido!${end}"
					initial_bet=$(($initial_bet*2))
					jugadas_malas+="$random_number "


				else

					echo -e "${yellow}[+]${end} ${blue}El número que ha salido es par,${end} ${purple}¡Has ganado!${end}"
					reward=$(($initial_bet*2))
					money=$(($money+$reward))
					echo -e "${yellow}[+]${end} ${blue}Has ganado${end}${green} $reward${end} ${blue}€, ${end}${blue}ahora tienes${end} ${green}$money${end}${blue} € de dinero ${end}"
					initial_bet=$backup_bet
					jugadas_malas=""

					if [ $money -gt $max_money ]; then
						max_money="$money"
					fi


				fi
			else
				echo -e "${yellow}[+]${end} ${blue}El número es impar,${end} ${red}¡Has perdido!${end}"
				initial_bet=$(($initial_bet*2))
				jugadas_malas+="$random_number "
			fi

			# Para números impares

		else

			if [ "$(($random_number % 2))" -eq 1 ]; then

				echo -e "${yellow}[+]${end} ${blue}El número que ha salido es par,${end} ${purple}¡Has ganado!${end}"
				reward=$(($initial_bet*2))
#				echo -e "${yellow}[+]${end} ${blue}Has ganado${end}${green} $reward${end} ${blue}€${end}"
				money=$(($money+$reward))
				echo -e "${yellow}[+]${end} ${blue}Has ganado${end}${green} $reward${end} ${blue}€, ${end}${blue}ahora tienes${end} ${green}$money${end}${blue} € de dinero ${end}"
				initial_bet=$backup_bet
				jugadas_malas=""
				if [ $money -gt $max_money ]; then
					max_money="$money"
				fi



			else
				echo -e "${yellow}[+]${end} ${blue}El número es impar,${end} ${red}¡Has perdido!${end}"
				initial_bet=$(($initial_bet*2))
 				jugadas_malas+="$random_number "
			fi

		fi
	else
		# Se agota el dinero para apostar

		echo -e "\n${red}[!] Te has quedado sin dinero, no puedes continuar jugando${end}\n"


		echo -e "\n\n${yellow}------------------------------<[ RESUMEN ]>------------------------------ ${end}"
		echo -e "${yellow}[*]${end}${purple} Se han producido${end} ${green}$play_counter${end}${purple} jugadas${end}"
		echo -e "${yellow}[*]${end}${purple} Llegaste a tener una cantidad de${end}${green} $max_money${end}${purple} €${end} "
		echo -e "${yellow}[*]${end}${purple} Jugadas malas consecutivas:${end} ${green}$jugadas_malas ${end}"



		tput cnorm; exit 0
	fi


		let play_counter+=1
	done

	tput cnorm # Recuperar el cursor

}


while getopts "m:t:h" arg; do
	case $arg in
	m) money=$OPTARG ;;
	t) technique=$OPTARG ;;
	h) helpPanel;;
	esac
done

if [ "$money" ] && [ $technique ] ;then

	if [ "$technique" == "martingala" ]; then
		martingala

	else
		echo -e "\n${red}[!] La técnica introducida no existe.${end} ${gray}Técnicas: ${end}${green}martingala${end}${gray} e ${end}${green}inverseLabrouchere${end}\n"
	fi

else
	helpPanel
fi

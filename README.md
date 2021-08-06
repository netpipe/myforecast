# myforecast
myforecast.com weather script for bash

was hoping to add ncurses support and xmlstarlet support
also text icons or something like imgcat

![screenshot ](screenshot.png)

https://www.shellcheck.net/?id=cb37630 bugfixes still

(https://erikflowers.github.io/weather-icons/)!

https://github.com/netpipe/Giffer


			-normal)        color="\033[00m" ;;
			-black)         color="\033[30;01m" ;;
			-red)           color="\033[31;01m" ;;
			-green)         color="\033[32;01m" ;;
			-yellow)        color="\033[33;01m" ;;
			-blue)          color="\033[34;01m" ;;
			-magenta)       color="\033[35;01m" ;;
			-cyan)          color="\033[36;01m" ;;
			-white)         color="\033[37;01m" ;;
			-n)             one_line=1;   shift ; continue ;;
			*)              echo -n "$1"; shift ; continue ;;

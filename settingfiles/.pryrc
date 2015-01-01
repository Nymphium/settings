# vim: ft=ruby

Pry.config.editor = "vim"

Pry.config.prompt = [
	proc{"\033[1;32m>> \033[1;34m=\033[1;31mpry\033[1;34m>>\033[0m "}, 
	proc{"\033[1;32m>> \033[1;34m=\033[1;31mpry\033[1;34m>>>>\033[0m"}
]


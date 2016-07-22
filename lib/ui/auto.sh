if ndef __AUTO_UI_CG_SH; then
define __AUTO_UI_CG_SH

## \brief Provides auto_ui function
## \desc The auto_ui function takes two arguments, the first one is the
## command to be executed if in a command-line environment
## (like xterm, linux, screen), and the second one is the command to
## be executed in a graphical environment (assumed if not command-line).
##
## This function finds its usefulness when writing a script that has to
## be runable on both command-line and graphical environment, without
## separating the code in two parts.

## \brief Executes one of two commands depending on the environment
## (graphical or command-line like).
## \param $1 Command-line command
## \param $2 Graphical command
## \return Return code of the executed command
auto_ui() {
	case $TERM in
		xterm*|rxvt*|linux*|screen*)
			eval $1
			return $? ;;
		*)
			eval $2
			return $? ;;
	esac
}

fi # __AUTO_UI_CG_SH

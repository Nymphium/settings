COMP_IGNORES+=(
	lock # lock file
	a o # somewhat object files
	cmi cmo cma cmx cmxa opt run cache annot omc # OCaml
	out dvi lfs fdb_latexmk blg bbl aux log pdf fls synctex.gz # LaTeX
)

_apply_comp_ignores () {
	zstyle ':completion:*:*:'${EDITOR}':*' file-patterns '^*.('"${(j:|:)COMP_IGNORES}"')' '*:all-files'
}

add_comp_ignores () {
	COMP_IGNORES+=(${@})
	_apply_comp_ignores
}

remove_comp_ignores () {
	COMP_IGNORES=(${COMP_IGNORES:|argv})
	_apply_comp_ignores
}

_apply_comp_ignores

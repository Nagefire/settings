function fish_prompt
	set_color yellow
	echo -n 'aftix '
	set_color cyan
	echo -n (pwd)
	set_color green
	echo -n ' → '
end

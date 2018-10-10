SOURCE	 = powscript-installer.pow
OUT	     = powscript-installer.sh
POW	     = ./powscript/powscript
FLAGS	 = --compile --to bash --no-cache


all:
	$(POW) $(FLAGS) $(SOURCE) -o $(OUT)
	chmod +x $(OUT)

clean:
	rm -f $(OUT)
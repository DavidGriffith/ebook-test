LATEX = xelatex
TEX4EBOOK = tex4ebook
MAKE4HT = make4ht
TEX4HT = tex4ht
TEXLUA = texlua

NAME = test

#LATEX_OPTS = -shell-escape
TEX4EBOOK_SWITCHES = -x -c config.cfg
#TEX4EBOOK_OPTS = \"$(NAME)\"
#TEX4EBOOK_OPTS = \"MyFonts\"
MAKE4HT_SWITCHES = -x


pdf:
	$(LATEX) $(OPTS) $(NAME).tex
	$(LATEX) $(OPTS) $(NAME).tex

#epub:	htf
epub:
	$(TEX4EBOOK) $(TEX4EBOOK_SWITCHES) $(NAME).tex $(TEX4EBOOK_OPTS)

htf:
	$(MAKE4HT) $(MAKE4HT_SWITCHES) $(NAME)
	$(TEXLUA) makehtf.lua $(NAME).xdv

clean:
	rm -f *.html *.dvi *.eps
	rm -f *.aux *.log *.out *.toc *.bbl *blg *.cot *.idx
	rm -f *.tmp *.xref *.4ct *.4tc *.idv *.lg
	rm -f *.mx1 *.mx2 *.opf *.ncx *.env *.bak *.xdv
	rm -f *.htf
	rm -f $(NAME).css
	rm -f $(NAME).tar.gz
	rm -rf *-epub

distclean: clean
	rm -f $(NAME).tar.gz
	rm -f *.pdf *.ps *.epub *.html *.dvi *.eps

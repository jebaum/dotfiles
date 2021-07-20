My custom pkgbuild for the ttf-nerd-fonts-input AUR package. I like slightly different settings than the guy who made that.
In particular: `ss` for a and g, slashed zeroes, and little rounded thingies on `i` and `l`

Go here to customize download link: https://input.djr.com/preview/?size=16&language=python&theme=solarized-dark&family=InputMono&width=300&weight=400&line-height=1.1&a=ss&g=ss&i=topserif&l=serifs_round&zero=slash&asterisk=0&braces=0&preset=default&customize=please

When going to the download page, you'll get a string something like this:

fontSelection=whole&a=0&g=0&i=0&l=0&zero=0&asterisk=0&braces=0&preset=default&line-height=1.2&accept=I+do&email="

Which is the important part of the final download link. Append it to:

http://input.fontbureau.com/build/?

Sample download link:

'http://input.fontbureau.com/build/?fontSelection=whole&a=ss&g=ss&i=topserif&l=serifs_round&zero=slash&asterisk=0&braces=0&preset=default&line-height=1.2&accept=I+do&email='


original: fontSelection=whole&a=0&g=0&i=0&l=0&zero=0&asterisk=0&braces=0&preset=default&line-height=1.2&accept=I+do&email="

mine:     fontSelection=whole&a=ss&g=ss&i=topserif&l=serifs_round&zero=slash&asterisk=0&braces=0&preset=default&line-height=1.2&accept=I+do&email=

(also need to update the sha256sum)

then just `makepkg -si` in the directory with the PKGBUILD file and bob's your uncle

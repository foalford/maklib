# Maklib 

Makefile is an ancient tool however very powerful. A lots of tools 
borrow its idea around such as gradle, capstrano, ansible. For a 
small project it would be grateful if there is an universal tool 
which can handle most build and deploy tasks without heavy dependencies.

That's why I create this maklib.

## Install

cp /path/to/maklib.tgz .
curl https://raw.githubusercontent.com/foalford/maklib/master/Makefile > Makefile
make install && rm Makefile

or 

git clone --depth=1 https://github.com/foalford/maklib maklib
make build && make install


## Usage

In your makefile, create something like
```Makefile
include maklib/utils/check
include maklib/inventory/install/php.mk


all: $(call require,php,5.6)
    echo "Install all dependencies"


.PHONY: all
```


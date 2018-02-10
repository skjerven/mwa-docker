FROM kernsuite/base:dev

LABEL maintainer "brian.skjerven@pawsey.org.au"

RUN docker-apt-install \
      #21cmfast \
      aoflagger \
      #casacore-data \
      #casacore-dev \
      #casacore-doc \
      #casacore-tools \
      #libcasa* \
      #casalite \
      #casarest \
      #cassbeam \
      #chgcentre \
      #cub-dev \
      #cubical \
      #cwltool \
      #drive-casa \
      dspsr \
      #dysco \
      #factor \
      #galsim \
      #karma \
      #kittens \
      ##lofar \
      #losoto \
      #lsmtool \
      #makems \
      #meqtrees-timba \
      #msutils \
      #mt-imager \
      #multinest \
      #obit \
      #oskar \
      #owlcat \
      #parseltongue \
      #prefactor \
      #presto \
      #psrcat \
      #psrchive \
      #purr \
      #pymoresane \
      #python-casacore \
      #python-keepalive \
      python-pip
      #python-scatterbrane \
      #python-typing \
      #pyxis \
      #rmextract \
      #rpfits \
      #sagecal \
      #sigproc \
      #sigpyproc \
      #simfast21 \
      #simms \
      #sopt \
      #stimela \
      #sunblocker \
      #tempo \
      #tempo2 \
      #tigger \
      #tirific \
      #tmv-dev \
      #wsclean

RUN pip install --upgrade pip && pip install \
      attrdict \
      katdal \
      katpoint \
      katversion
      #montblanc \
      #meqtrees_cattery \
      #pythonqwt \
      #pyvo \
      #rfimasker \
      #sharedarray \
      #sourcery \
      #tkp \
      #transitions

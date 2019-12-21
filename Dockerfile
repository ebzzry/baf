FROM nixos/nix

LABEL maintainer="Rommel MARTINEZ <rom@mimix.io>"
LABEL version="1.0.0"

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --update
RUN nix-env -iA nixpkgs.git nixpkgs.sbcl nixpkgs.gnumake nixpkgs.curl nixpkgs.cl-launch nixpkgs.bzip2 nixpkgs.nix-prefetch-scripts
RUN mkdir -p ~/common-lisp

RUN git clone https://gitlab.common-lisp.net/asdf/asdf.git ~/common-lisp/asdf
RUN git clone https://github.com/ebzzry/baf ~/common-lisp/baf

RUN curl -O https://beta.quicklisp.org/quicklisp.lisp
RUN sbcl --load quicklisp.lisp --eval  '(quicklisp-quickstart:install)' --eval '(let ((ql-util::*do-not-prompt* t)) (ql:add-to-init-file) (ql:quickload :cl-launch) (sb-ext:quit))'

RUN make -C ~/common-lisp/baf

ENTRYPOINT [ "/root/common-lisp/baf/baf" ]

# jsCoq Docker image using Rocq 9.0 and HoTT 9.0
FROM debian:12-slim AS builder

RUN apt-get update && apt-get install -y \
    git curl opam m4 build-essential patch rsync ca-certificates unzip \
    nodejs npm && rm -rf /var/lib/apt/lists/*

RUN opam init -a --disable-sandboxing --bare && \
    opam switch create jscoq 4.12.0 && \
    eval $(opam env) && \
    opam install -y dune js_of_ocaml js_of_ocaml-ppx js_of_ocaml-lwt \
       yojson ppx_deriving_yojson ppx_import lwt_ppx sexplib ppx_sexp_conv \
       zarith zarith_stubs_js

WORKDIR /opt/jscoq
COPY . .
RUN ./etc/toolchain-setup.sh --64 && make coq && make jscoq

FROM node:18-slim
WORKDIR /jscoq
COPY --from=builder /opt/jscoq/_build/jscoq+64bit/dist ./
EXPOSE 8080
CMD ["npx", "http-server", "-p", "8080", "."]

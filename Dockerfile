FROM haskell
MAINTAINER FP-hackathon
# First, copy the build files, to get the dependencies for stack
ADD ./stack.yaml /payment/stack.yaml
ADD ./payment.cabal /payment/payment.cabal
WORKDIR /payment
# "Install" without the rest of the source code - this will get all deps and then fail
RUN stack install || true
# Now add the rest of the source...
ADD . /payment
# And build for real
RUN stack install

CMD "/root/.local/bin/payment-exe"

EXPOSE 8080


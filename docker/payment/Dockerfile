FROM ghanique/payment-haskell-base
MAINTAINER FP-hackathon

# Now add the rest of the source...
ADD . /payment
# And build for real
RUN stack install

CMD "/root/.local/bin/payment-exe"

EXPOSE 8080


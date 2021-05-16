kubectl delete namespace devsecops-meetup
kubectl create namespace devsecops-meetup

kubectl -n devsecops-meetup create secret generic grpc-server-certificates \
  --from-file=./serverCertificates/grpc-server.crt \
  --from-file=./serverCertificates/grpc-server.key \
  --from-file=./certificatesChain/grpc-root-ca-and-grpc-server-ca-chain.crt

kubectl -n devsecops-meetup create secret generic grpc-ingress-server-certificates \
  --from-file=tls.crt=./serverCertificates/grpc-server.crt \
  --from-file=tls.key=./serverCertificates/grpc-server.key \
  --from-file=ca.crt=./certificatesChain/grpc-root-ca-and-grpc-server-ca-chain.crt

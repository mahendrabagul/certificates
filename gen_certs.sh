echo "==================================================================="
echo "Creating rootCA folder ..."
mkdir -p rootCA
cd rootCA || exit
echo "Generating Root CA certificate ..."
echo "==================================================================="
openssl genrsa -passout pass:1111 -out grpc-root-ca.key 4096
openssl req -new -x509 -days 365 -key grpc-root-ca.key -subj "/C=IN/ST=MH/L=Pune/O=KubeDaily/OU=DevSecOps Meetup/CN=Root CA" -out grpc-root-ca.crt -passin pass:1111 -set_serial 0 -extensions v3_ca -config ../openssl.cnf

cd ..
echo "==================================================================="
echo "Creating serverCA folder ..."
mkdir -p serverCA
cd serverCA || exit
echo "Generating gRPC Server Intermediate CA certificate ..."
echo "==================================================================="
openssl req -nodes -new -keyout grpc-server-ca.key -out grpc-server-ca.csr -subj "/C=IN/ST=MH/L=Pune/O=KubeDaily/OU=DevSecOps Meetup/CN=Server Intermediate CA" -config ../openssl.cnf -passout pass:1111
openssl x509 -days 365 -req -in grpc-server-ca.csr -CAcreateserial -CA ../rootCA/grpc-root-ca.crt -CAkey ../rootCA/grpc-root-ca.key -out grpc-server-ca.crt -extfile ../openssl.cnf -extensions v3_intermediate_ca -passin pass:1111

cd ..
echo "==================================================================="
echo "Creating serverCertificates folder ..."
mkdir -p serverCertificates
cd serverCertificates || exit
echo "Generating gRPC Server certificate ..."
echo "==================================================================="
openssl req -nodes -new -keyout grpc-server.key -out grpc-server.csr -subj "/C=IN/ST=MH/L=Pune/O=KubeDaily/OU=DevSecOps Meetup/CN=localhost" -config ../openssl.cnf -passout pass:1111
openssl x509 -days 365 -req -in grpc-server.csr -CAcreateserial -CA ../serverCA/grpc-server-ca.crt -CAkey ../serverCA/grpc-server-ca.key -out grpc-server.crt -extfile ../openssl.cnf -extensions server_cert -passin pass:1111

cd ..
echo "==================================================================="
echo "Creating certificatesChain folder ..."
mkdir -p certificatesChain
cd certificatesChain || exit
echo "Generating certificate chain..."
echo "==================================================================="
cat ../serverCA/grpc-server-ca.crt ../rootCA/grpc-root-ca.crt >grpc-root-ca-and-grpc-server-ca-chain.crt

cd ..

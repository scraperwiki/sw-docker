set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

[ -d cobalt ] || git clone git://github.com/scraperwiki/cobalt
[ -d custard ] || git clone git://github.com/scraperwiki/custard

[ -e ${HOME}/.profile ] && ln -sf ${HOME}/.profile $DIR/profile || touch profile
[ -e ${HOME}/.bashrc ] && ln -sf ${HOME}/.bashrc $DIR/bashrc || touch bashrc

# Generate CA certificate for MITM'ing the container
openssl genpkey -algorithm rsa -out mitm-ca.key -pkeyopt rsa_keygen_bits:4096
openssl req -new -x509 -days 365 -key mitm-ca.key -out mitm-ca.crt

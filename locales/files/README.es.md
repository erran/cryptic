# Cryptic [![Estado de Creación](https://secure.travis-ci.org/ipwnstuff/cryptic.png)](http://travis-ci.org/ipwnstuff/cryptic) [![Estado de Dependencia](https://gemnasium.com/ipwnstuff/cryptic.png)](https://gemnasium.com/ipwnstuff/cryptic)
## Documentacion
En Español: # TODO: Añade un enlace al versión española del documentación
En Inglès: http://www.rubydoc.info/github/ipwnstuff/cryptic

## Installation
Sólo corra `gem install cryptic` o añada `gem 'cryptic'` a su `Gemfile`.
También se puede descargar desde el código fuente.

## Usage
### Command line

```
[ecarey @ cryptic]$ cryptic
Commands:
  cryptic decrypt [CLAVE_PRIVADA] [FICHERO_CIFRADO] [OPCIONES]  # Descifre una fichero con una clave privada
  cryptic encrypt [CLAVE_PUBLICO] [FICHERO_TEXTO] [OPTIONS]     # Cifre una fichero con una clave pública
  cryptic generate [OPTIONS]                                    # Genere un nuevas claves
  cryptic help [COMMAND]                                        # Describe available commands or one specific command
```

### Ruby

```ruby
require 'cryptic'

# Para cargar las claves existantes:
claves = Cryptic::Keypair.new('cryptic_private.pem', public_key: 'cryptic_public.pem')

# Usar las métodos `private_key` y `private_key` para obtener las claves desde el objeto `Cryptic::Keypair`
clave_privada = claves.private_key
clave_publica = claves.public_key

datos = File.read('foo.txt')
cifrado = Cryptic::EncryptedData.new(datos, clave_publica, :base64)

cifrado.data

descifrado = cifrado.decrypt(clave_privada, 'P4$SpHr4z3', :base64)
```
## Contribuyendo

1. Bifurcalo
2. Cree un rama de la característica en Inglés (`git checkout -b feature/my-awesome-feature`)
3. Comfirma sus cambios (`git commit -am 'Add some feature'`)
4. Empuje to the branch (`git push origin feature/my-awesome-feature`)
5. Cree una nuevo Pull Request
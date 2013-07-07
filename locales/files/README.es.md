# Cryptic [![Estado de Creación](https://secure.travis-ci.org/ipwnstuff/cryptic.png)](http://travis-ci.org/ipwnstuff/cryptic) [![Estado de Dependencia](https://gemnasium.com/ipwnstuff/cryptic.png)](https://gemnasium.com/ipwnstuff/cryptic)
Una Ruby gem para cifrar datos con su clave pública, descifrarlos con su clave privada, y generar nuevas claves.

## Documentación
En Español: # TODO: Un enlace al versión española del documentación

En Inglès: http://www.rubydoc.info/github/ipwnstuff/cryptic

## Instalación
Sólo corra `gem install cryptic` o añada `gem 'cryptic'` a su `Gemfile`.
También se puede descargar desde el código fuente.

## Uso
### Línea de Comandos

```
[ecarey @ cryptic]$ cryptic
Commands:
  cryptic decrypt [CLAVE_PRIVADA] [FICHERO_CIFRADO] [OPCIONES]  # Descifrar una fichero con una clave privada
  cryptic encrypt [CLAVE_PUBLICO] [FICHERO_TEXTO] [OPTIONS]     # Cifrar una fichero con una clave pública
  cryptic generate [OPTIONS]                                    # Generar nuevas claves
  cryptic help [COMMAND]                                        # Describe available commands or one specific command
```

### Ruby

```ruby
require 'cryptic'

# Para cargar las claves existantes:
claves = Cryptic::Keypair.new('cryptic_private.pem', public_key: 'cryptic_public.pem')

# Obtener las claves desde el objeto `Cryptic::Keypair`:
clave_privada = claves.private_key
clave_publica = claves.public_key

# Cifrar un fichero:
datos = File.read('foo.txt')
cifrado = Cryptic::EncryptedData.new(datos, clave_publica, :base64)

# Retornar los datos cifrados:
cifrado.data

# Descifrarlos con su clave privada y su contraseña:
descifrado = cifrado.decrypt(clave_privada, 'P4$SpHr4z3', :base64)
```

## Contribuyendo
1. Bifurcarlo
2. Crear un rama de la característica en Inglés (`git checkout -b feature/my-awesome-feature`)
3. Comfirmar su cambios con un mensaje Inglés (`git commit -am 'Add some feature'`)
4. Empujar a su rama (`git push origin feature/my-awesome-feature`)
5. Crear un nuevo Pull Request

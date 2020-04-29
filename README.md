# Autenticação com SD Card

Rotina para autenticação de usuários em microcontroladores através da leitura de um arquivo de texto como base de dados em um SD Card.

Utilizado em conjunto com IHM's, preferencialmente com tela de toque.


### Instalação

Clone o repositório, obtendo todos os arquivos gerados pelo projeto do mikroC, tanto o hexadecimal para gravação, quanto os arquivos `.c` e `.h`.

```sh
$ git clone https://github.com/marocama/SD_Card_Auth.git
```

### Utilização

Por padrão, o programa busca autenticar o usuário `admin` com a senha `654321` por meio do arquivo `USERS.TXT`. No entanto, para efetuar a autenticação de outro usuário, a rotina pode ser chamada por meio da função `M_Check_User`.

```sh
$ void M_Check_User(char *usr, char *pwd);
```

Pode-se implementar um retorno para essa função, a fim de melhor implementação em outros programas.
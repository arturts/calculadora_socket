# Calculadora Distribuída (Multithread) - FIAP 4º SIR 2017

## Instruções:

- Instalar um interpretador [**ruby**](https://www.ruby-lang.org/en/documentation/installation/) (de preferência jruby ou rubinius, que não possuem _Global Interpreter Lock_, tornando a execução de mais de um _thread_ ao mesmo tempo possível)
- Dentro do diretório `tcp` ou `udp`, execute o comando `bin/server` para iniciar o servidor.
- No mesmo diretório, executar `bin/client` para iniciar o cliente.
- Insira comandos no formato `[operando1][operador][operando2]`

Execute `bin/server --help` para mais opções.
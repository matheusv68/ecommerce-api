# Ecommerce API

API construída com Rails 8, Ruby 3.3.1 e PostgreSQL. Ela usa Solid Cache e
Solid Queue, que também armazenam dados no PostgreSQL.

## Pré-requisitos

Escolha uma das formas de execução abaixo:

- **Com Docker:** Docker Engine e Docker Compose v2.
- **Sem Docker:** Ruby 3.3.1, Bundler e PostgreSQL instalados localmente.

O arquivo `config/master.key` é necessário para iniciar o Rails em produção.
Ele não é versionado e não deve ser enviado para o repositório.

## Executar com Docker

O `docker-compose.yml` reutiliza o `Dockerfile` de produção e inicia dois
serviços: `app` (Rails, Thruster e Solid Queue) e `db` (PostgreSQL 16).

1. Crie o arquivo de variáveis local, caso ele ainda não exista:

   ```bash
   cp .env.example .env
   ```

2. Defina uma senha segura para `ECOMMERCE_API_DATABASE_PASSWORD` no `.env`.
   O `POSTGRES_HOST` é sobrescrito pelo Compose para `db`.

3. Confirme que `config/master.key` existe localmente. O Compose o monta no
   container somente para leitura.

4. Construa e inicie os serviços:

   ```bash
   docker compose up --build -d
   ```

5. Confira o estado dos containers:

   ```bash
   docker compose ps
   ```

   Os serviços `app` e `db` devem aparecer como `healthy`.

### Validar a execução com Docker

```bash
# Health check do Rails
curl -fsS http://localhost/up

# PostgreSQL está aceitando conexões
docker compose exec db pg_isready -U ecommerce_api -d ecommerce_api_production

# Bancos usados pela aplicação, cache e fila
docker compose exec db psql -U ecommerce_api -d ecommerce_api_production -c '\l'

# Logs para diagnosticar uma falha de inicialização
docker compose logs --tail=100 app db
```

O entrypoint da aplicação executa `bin/rails db:prepare` na inicialização. Por
isso, além de `ecommerce_api_production`, os bancos de cache e de fila são
criados automaticamente quando o PostgreSQL está disponível.

Para parar os serviços e manter os dados persistidos:

```bash
docker compose down
```

Para também apagar os volumes do PostgreSQL e do Active Storage (ação
destrutiva):

```bash
docker compose down -v
```

> O Compose desabilita SSL somente no ambiente local com
> `RAILS_FORCE_SSL=false`. Fora dele, o padrão de produção continua exigindo
> HTTPS.

## Executar sem Docker

Em uma distribuição Linux com PostgreSQL gerenciado pelo `systemd`, inicie o
serviço e confirme que ele aceita conexões:

```bash
sudo systemctl start postgresql
pg_isready
```

Em outros sistemas, use o gerenciador de serviços equivalente. A configuração
de desenvolvimento usa o usuário local do sistema para se conectar ao
PostgreSQL por socket.

Instale as dependências, prepare o banco e inicie o Rails:

```bash
bundle install
bin/rails db:prepare
bin/rails server
```

O backend ficará disponível em `http://localhost:3000`.

### Validar a execução local

Em outro terminal:

```bash
# Health check do backend
curl -i http://localhost:3000/up

# Confirma a conexão nativa com o banco de desenvolvimento
psql -d ecommerce_api_development -c "SELECT 1;"
```

O endpoint `/up` deve retornar `200 OK` e o comando SQL deve retornar uma
linha. Caso `bin/rails db:prepare` falhe com erro de role ou permissão, crie ou
ajuste o usuário local do PostgreSQL para o usuário com o qual você está
executando o Rails.

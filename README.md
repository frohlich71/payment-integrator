# Payment Integrator API

Uma API RESTful em Go para integração de pagamentos, construída com Gin, GORM e PostgreSQL.

## 🚀 Tecnologias

- **Go 1.21** - Linguagem de programação
- **Gin** - Framework web
- **GORM** - ORM para Go
- **PostgreSQL** - Banco de dados
- **Docker & Docker Compose** - Containerização
- **Redis** - Cache (opcional)

## 📋 Funcionalidades

- ✅ CRUD completo de usuários
- ✅ CRUD completo de pagamentos
- ✅ Relacionamento entre usuários e pagamentos
- ✅ Filtros e paginação
- ✅ Validação de dados
- ✅ Middleware CORS
- ✅ Health check endpoint
- ✅ Dockerização completa

## 🏗️ Estrutura do Projeto

```
payment-integrator/
├── main.go                 # Arquivo principal da aplicação
├── go.mod                  # Dependências do Go
├── Dockerfile              # Configuração do container
├── docker-compose.yml      # Orquestração de containers
├── .env                    # Variáveis de ambiente
├── init.sql                # Script de inicialização do banco
├── models/
│   └── models.go          # Modelos de dados
├── handlers/
│   └── handlers.go        # Handlers da API
└── README.md              # Este arquivo
```

## 🚦 Endpoints da API

### Health Check
- `GET /api/v1/health` - Verificar status da API

### Usuários
- `POST /api/v1/users` - Criar usuário
- `GET /api/v1/users` - Listar usuários (com paginação)
- `GET /api/v1/users/:id` - Buscar usuário por ID

### Pagamentos
- `POST /api/v1/payments` - Criar pagamento
- `GET /api/v1/payments` - Listar pagamentos (com filtros)
- `GET /api/v1/payments/:id` - Buscar pagamento por ID
- `PUT /api/v1/payments/:id` - Atualizar pagamento
- `DELETE /api/v1/payments/:id` - Deletar pagamento

## 🐳 Como Executar com Docker

1. **Clone o repositório e navegue até o diretório:**
   ```bash
   cd /Users/victorfrohlich/payment-integrator
   ```

2. **Execute com Docker Compose:**
   ```bash
   docker-compose up -d
   ```

3. **A API estará disponível em:**
   - API: http://localhost:8080
   - pgAdmin: http://localhost:5050 (admin@admin.com / admin)
   - PostgreSQL: localhost:5432
   - Redis: localhost:6379

## 🛠️ Como Executar Localmente

1. **Instalar dependências:**
   ```bash
   go mod tidy
   ```

2. **Configurar banco PostgreSQL local ou usar Docker:**
   ```bash
   docker run -d \
     --name postgres \
     -e POSTGRES_USER=postgres \
     -e POSTGRES_PASSWORD=postgres \
     -e POSTGRES_DB=payment_integrator \
     -p 5432:5432 \
     postgres:15-alpine
   ```

3. **Executar a aplicação:**
   ```bash
   go run main.go
   ```

## 📝 Exemplos de Uso

### Criar usuário
```bash
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@email.com",
    "phone": "11999999999"
  }'
```

### Criar pagamento
```bash
curl -X POST http://localhost:8080/api/v1/payments \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "amount": 100.50,
    "currency": "BRL",
    "method": "credit_card",
    "description": "Pagamento de teste"
  }'
```

### Listar pagamentos com filtros
```bash
curl "http://localhost:8080/api/v1/payments?user_id=1&status=pending"
```

## 🔧 Configuração

As configurações podem ser feitas através de variáveis de ambiente no arquivo `.env`:

- `PORT` - Porta da aplicação (padrão: 8080)
- `DATABASE_URL` - URL de conexão com PostgreSQL
- `GIN_MODE` - Modo do Gin (debug/release)
- `REDIS_URL` - URL de conexão com Redis

## 🔨 Próximos Passos

- [ ] Implementar autenticação JWT
- [ ] Adicionar integração com gateways de pagamento (Stripe, MercadoPago)
- [ ] Implementar webhooks
- [ ] Adicionar logs estruturados
- [ ] Implementar testes unitários
- [ ] Adicionar documentação Swagger/OpenAPI
- [ ] Implementar rate limiting
- [ ] Adicionar monitoramento e métricas

## 📄 Licença

Este projeto está sob a licença MIT.
# payment-integrator

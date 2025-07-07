# API Payment Integrator - Versão Simplificada

Esta é uma versão simplificada da API que apenas recebe JSON no endpoint `/payment` e faz log das informações recebidas. Opcionalmente, você pode usar Redis para armazenamento.

## 🚀 Como executar

### Opção 1: Localmente
1. **Executar a aplicação:**
   ```bash
   go run main.go
   ```

2. **Ou compilar e executar:**
   ```bash
   go build -o main .
   ./main
   ```

### Opção 2: Com Docker Compose (Recomendado)
1. **Iniciar aplicação com Redis:**
   ```bash
   ./dev.sh start
   ```

2. **Parar aplicação:**
   ```bash
   ./dev.sh stop
   ```

A aplicação estará disponível em: http://localhost:9999

## 📋 Endpoints Disponíveis

### Health Check
```bash
curl -X GET http://localhost:9999/api/v1/health
```

**Resposta:**
```json
{
  "status": "ok",
  "message": "Payment Integrator API is running"
}
```

### Payment Endpoint
```bash
curl -X POST http://localhost:9999/api/v1/payment \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 100.50,
    "currency": "BRL",
    "method": "credit_card",
    "description": "Pagamento de teste",
    "user": {
      "name": "João Silva",
      "email": "joao@email.com"
    }
  }'
```

**Resposta:**
```json
{
  "status": "success",
  "message": "Pagamento recebido e processado com sucesso",
  "timestamp": "2025-07-07 19:25:30",
  "received_data": {
    "amount": 100.5,
    "currency": "BRL",
    "description": "Pagamento de teste",
    "method": "credit_card",
    "user": {
      "email": "joao@email.com",
      "name": "João Silva"
    }
  }
}
```

## � Comandos Docker

```bash
# Iniciar aplicação e Redis
./dev.sh start

# Ver logs da aplicação
./dev.sh logs

# Ver logs do Redis
./dev.sh logs-redis

# Conectar ao Redis CLI
./dev.sh redis

# Testar endpoint de payment
./dev.sh test-payment

# Parar aplicação
./dev.sh stop
```

## �📝 Exemplos de Teste

### Pagamento com cartão de crédito
```bash
curl -X POST http://localhost:9999/api/v1/payment \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 150.00,
    "currency": "BRL",
    "method": "credit_card",
    "card_number": "4111111111111111",
    "card_holder": "João Silva",
    "expiry_date": "12/25",
    "cvv": "123",
    "description": "Compra online"
  }'
```

### Pagamento PIX
```bash
curl -X POST http://localhost:9999/api/v1/payment \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 250.00,
    "currency": "BRL",
    "method": "pix",
    "pix_key": "joao@email.com",
    "description": "Transferência PIX"
  }'
```

### Pagamento com dados complexos
```bash
curl -X POST http://localhost:9999/api/v1/payment \
  -H "Content-Type: application/json" \
  -d '{
    "transaction_id": "txn_123456789",
    "amount": 99.99,
    "currency": "BRL",
    "method": "boleto",
    "customer": {
      "id": "cust_001",
      "name": "Maria Santos",
      "email": "maria@email.com",
      "phone": "11999999999",
      "document": "123.456.789-10",
      "address": {
        "street": "Rua das Flores, 123",
        "city": "São Paulo",
        "state": "SP",
        "zip_code": "01234-567"
      }
    },
    "items": [
      {
        "name": "Produto A",
        "quantity": 2,
        "price": 49.99
      }
    ],
    "metadata": {
      "source": "website",
      "campaign": "black_friday_2025"
    }
  }'
```

## 📊 Logs

Quando você enviar uma requisição para `/payment`, você verá logs detalhados no console da aplicação:

```
=== PAYMENT RECEIVED ===
Timestamp: 2025-07-07 19:25:30
IP Cliente: ::1
User-Agent: curl/8.4.0
Content-Type: application/json
Dados recebidos:
{
  "amount": 100.5,
  "currency": "BRL",
  "description": "Pagamento de teste",
  "method": "credit_card",
  "user": {
    "email": "joao@email.com",
    "name": "João Silva"
  }
}
========================
```

## ⚙️ Configuração

Você pode configurar a aplicação através do arquivo `.env`:

- `PORT=9999` - Porta da aplicação
- `GIN_MODE=debug` - Modo do Gin (debug/release)
- `REDIS_URL=redis://localhost:6379` - URL do Redis
- `LOG_LEVEL=info` - Nível de log
- `CORS_ALLOW_ORIGIN=*` - Configuração CORS

## 🔧 Funcionalidades

- ✅ Recebe qualquer JSON no endpoint `/payment`
- ✅ Faz log detalhado de todas as informações recebidas
- ✅ Retorna resposta de sucesso com timestamp
- ✅ Inclui informações do cliente (IP, User-Agent)
- ✅ Middleware CORS habilitado
- ✅ Health check endpoint
- ✅ Configuração via variáveis de ambiente
- ✅ Redis disponível para armazenamento (opcional)
- ✅ Docker Compose para fácil desenvolvimento

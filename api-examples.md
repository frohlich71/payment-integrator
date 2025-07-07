# Exemplos de API - Payment Integrator

Este arquivo contém exemplos de requisições para testar a API do Payment Integrator.

## Health Check

```bash
curl -X GET http://localhost:8080/api/v1/health
```

## Usuários

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

### Listar usuários
```bash
curl -X GET http://localhost:8080/api/v1/users
```

### Listar usuários com paginação
```bash
curl -X GET "http://localhost:8080/api/v1/users?page=1&page_size=5"
```

### Buscar usuário por ID
```bash
curl -X GET http://localhost:8080/api/v1/users/1
```

## Pagamentos

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

### Criar pagamento PIX
```bash
curl -X POST http://localhost:8080/api/v1/payments \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "amount": 250.00,
    "currency": "BRL",
    "method": "pix",
    "description": "Pagamento via PIX"
  }'
```

### Listar todos os pagamentos
```bash
curl -X GET http://localhost:8080/api/v1/payments
```

### Filtrar pagamentos por usuário
```bash
curl -X GET "http://localhost:8080/api/v1/payments?user_id=1"
```

### Filtrar pagamentos por status
```bash
curl -X GET "http://localhost:8080/api/v1/payments?status=pending"
```

### Filtrar pagamentos por usuário e status
```bash
curl -X GET "http://localhost:8080/api/v1/payments?user_id=1&status=approved"
```

### Buscar pagamento por ID
```bash
curl -X GET http://localhost:8080/api/v1/payments/1
```

### Atualizar status do pagamento
```bash
curl -X PUT http://localhost:8080/api/v1/payments/1 \
  -H "Content-Type: application/json" \
  -d '{
    "status": "approved"
  }'
```

### Atualizar múltiplos campos do pagamento
```bash
curl -X PUT http://localhost:8080/api/v1/payments/1 \
  -H "Content-Type: application/json" \
  -d '{
    "status": "approved",
    "external_id": "stripe_pi_1234567890"
  }'
```

### Deletar pagamento
```bash
curl -X DELETE http://localhost:8080/api/v1/payments/1
```

## Exemplos com jq (formatação JSON)

Se você tem o `jq` instalado, pode usar para formatar as respostas:

```bash
curl -s http://localhost:8080/api/v1/health | jq .
curl -s http://localhost:8080/api/v1/users | jq .
curl -s http://localhost:8080/api/v1/payments | jq .
```

## Testando com múltiplos usuários e pagamentos

### Criar múltiplos usuários
```bash
# Usuário 1
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"name": "João Silva", "email": "joao@email.com", "phone": "11999999999"}'

# Usuário 2
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Maria Santos", "email": "maria@email.com", "phone": "11888888888"}'

# Usuário 3
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Pedro Oliveira", "email": "pedro@email.com", "phone": "11777777777"}'
```

### Criar múltiplos pagamentos
```bash
# Pagamento 1 - Cartão de crédito
curl -X POST http://localhost:8080/api/v1/payments \
  -H "Content-Type: application/json" \
  -d '{"user_id": 1, "amount": 100.50, "method": "credit_card", "description": "Compra online"}'

# Pagamento 2 - PIX
curl -X POST http://localhost:8080/api/v1/payments \
  -H "Content-Type: application/json" \
  -d '{"user_id": 1, "amount": 250.00, "method": "pix", "description": "Transferência PIX"}'

# Pagamento 3 - Boleto
curl -X POST http://localhost:8080/api/v1/payments \
  -H "Content-Type: application/json" \
  -d '{"user_id": 2, "amount": 99.99, "method": "boleto", "description": "Pagamento boleto"}'

# Pagamento 4 - Cartão de débito
curl -X POST http://localhost:8080/api/v1/payments \
  -H "Content-Type: application/json" \
  -d '{"user_id": 3, "amount": 150.75, "method": "debit_card", "description": "Compra com débito"}'
```

## Métodos de Pagamento Suportados

- `credit_card` - Cartão de crédito
- `debit_card` - Cartão de débito
- `pix` - PIX
- `boleto` - Boleto bancário

## Status de Pagamento

- `pending` - Pendente (padrão)
- `approved` - Aprovado
- `rejected` - Rejeitado
- `cancelled` - Cancelado

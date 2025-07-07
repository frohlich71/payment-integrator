#!/bin/bash

# Script para facilitar o desenvolvimento da Payment Integrator API

echo "🚀 Payment Integrator API - Scripts de Desenvolvimento"
echo "=================================================="

case "$1" in
    "start")
        echo "📦 Iniciando aplicação com Docker Compose..."
        docker-compose up -d
        echo "✅ Aplicação iniciada!"
        echo "📍 API: http://localhost:9999"
        echo "📍 Redis: localhost:6379"
        ;;
    
    "stop")
        echo "🛑 Parando aplicação..."
        docker-compose down
        echo "✅ Aplicação parada!"
        ;;
    
    "restart")
        echo "🔄 Reiniciando aplicação..."
        docker-compose down
        docker-compose up -d
        echo "✅ Aplicação reiniciada!"
        ;;
    
    "logs")
        echo "📋 Logs da aplicação..."
        docker-compose logs -f api
        ;;
    
    "logs-redis")
        echo "📋 Logs do Redis..."
        docker-compose logs -f redis
        ;;
    
    "build")
        echo "🔨 Fazendo build da aplicação..."
        go build -o main .
        echo "✅ Build concluído!"
        ;;
    
    "run")
        echo "🏃 Executando aplicação localmente..."
        go run main.go
        ;;
    
    "test")
        echo "🧪 Executando testes..."
        go test ./...
        ;;
    
    "deps")
        echo "📦 Atualizando dependências..."
        go mod tidy
        go mod download
        echo "✅ Dependências atualizadas!"
        ;;
    
    "clean")
        echo "🧹 Limpando containers e volumes..."
        docker-compose down -v
        docker system prune -f
        echo "✅ Limpeza concluída!"
        ;;
    
    "redis")
        echo "🗄️ Conectando ao Redis..."
        docker-compose exec redis redis-cli
        ;;
    
    "health")
        echo "🏥 Verificando health da API..."
        curl -s http://localhost:9999/api/v1/health | jq . 2>/dev/null || curl -s http://localhost:9999/api/v1/health
        ;;
    
    "test-payment")
        echo "💳 Testando endpoint de payment..."
        curl -X POST http://localhost:9999/api/v1/payment \
          -H "Content-Type: application/json" \
          -d '{
            "amount": 100.50,
            "currency": "BRL",
            "method": "credit_card",
            "description": "Pagamento de teste via script",
            "user": {
              "name": "João Silva",
              "email": "joao@email.com"
            }
          }' | jq . 2>/dev/null || curl -X POST http://localhost:9999/api/v1/payment \
          -H "Content-Type: application/json" \
          -d '{
            "amount": 100.50,
            "currency": "BRL",
            "method": "credit_card",
            "description": "Pagamento de teste via script",
            "user": {
              "name": "João Silva",
              "email": "joao@email.com"
            }
          }'
        ;;
    
    *)
        echo "❓ Uso: $0 {start|stop|restart|logs|logs-redis|build|run|test|deps|clean|redis|health|test-payment}"
        echo ""
        echo "Comandos disponíveis:"
        echo "  start        - Inicia a aplicação com Docker Compose"
        echo "  stop         - Para a aplicação"
        echo "  restart      - Reinicia a aplicação"
        echo "  logs         - Mostra os logs da aplicação"
        echo "  logs-redis   - Mostra os logs do Redis"
        echo "  build        - Faz build da aplicação Go"
        echo "  run          - Executa a aplicação localmente"
        echo "  test         - Executa os testes"
        echo "  deps         - Atualiza as dependências Go"
        echo "  clean        - Remove containers e volumes"
        echo "  redis        - Conecta ao Redis CLI"
        echo "  health       - Verifica se a API está rodando"
        echo "  test-payment - Testa o endpoint de payment"
        exit 1
        ;;
esac

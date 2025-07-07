#!/bin/bash

# Script para desenvolvimento local (sem Docker)

echo "🚀 Payment Integrator API - Desenvolvimento Local"
echo "================================================"

case "$1" in
    "setup")
        echo "⚙️ Configurando ambiente de desenvolvimento..."
        
        # Verificar se PostgreSQL está instalado
        if ! command -v psql &> /dev/null; then
            echo "❌ PostgreSQL não encontrado!"
            echo "💡 Para instalar no macOS: brew install postgresql"
            exit 1
        fi
        
        # Verificar se o serviço está rodando
        if ! pg_isready -h localhost -p 5432 &> /dev/null; then
            echo "⚠️ PostgreSQL não está rodando. Iniciando..."
            brew services start postgresql
            sleep 3
        fi
        
        # Criar banco de dados
        echo "📦 Criando banco de dados..."
        createdb payment_integrator 2>/dev/null || echo "📦 Banco de dados já existe"
        
        # Executar script de inicialização
        psql -h localhost -d payment_integrator -f init.sql
        
        echo "✅ Ambiente configurado!"
        ;;
    
    "start")
        echo "🏃 Iniciando aplicação..."
        go run main.go
        ;;
    
    "build")
        echo "🔨 Fazendo build da aplicação..."
        go build -o main .
        echo "✅ Build concluído!"
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
    
    "db")
        echo "🗄️ Conectando ao banco de dados..."
        psql -h localhost -d payment_integrator
        ;;
    
    "health")
        echo "🏥 Verificando health da API..."
        curl -s http://localhost:8080/api/v1/health | jq . 2>/dev/null || curl -s http://localhost:8080/api/v1/health
        ;;
    
    "demo")
        echo "🎯 Executando demonstração da API..."
        echo ""
        echo "1. Criando usuários..."
        curl -s -X POST http://localhost:8080/api/v1/users \
          -H "Content-Type: application/json" \
          -d '{"name": "João Silva", "email": "joao@email.com", "phone": "11999999999"}' | jq . 2>/dev/null
        
        curl -s -X POST http://localhost:8080/api/v1/users \
          -H "Content-Type: application/json" \
          -d '{"name": "Maria Santos", "email": "maria@email.com", "phone": "11888888888"}' | jq . 2>/dev/null
        
        echo ""
        echo "2. Criando pagamentos..."
        curl -s -X POST http://localhost:8080/api/v1/payments \
          -H "Content-Type: application/json" \
          -d '{"user_id": 1, "amount": 100.50, "method": "credit_card", "description": "Compra online"}' | jq . 2>/dev/null
        
        curl -s -X POST http://localhost:8080/api/v1/payments \
          -H "Content-Type: application/json" \
          -d '{"user_id": 1, "amount": 250.00, "method": "pix", "description": "Transferência PIX"}' | jq . 2>/dev/null
        
        echo ""
        echo "3. Listando usuários..."
        curl -s http://localhost:8080/api/v1/users | jq . 2>/dev/null
        
        echo ""
        echo "4. Listando pagamentos..."
        curl -s http://localhost:8080/api/v1/payments | jq . 2>/dev/null
        ;;
    
    *)
        echo "❓ Uso: $0 {setup|start|build|test|deps|db|health|demo}"
        echo ""
        echo "Comandos disponíveis:"
        echo "  setup   - Configura o ambiente local (PostgreSQL)"
        echo "  start   - Inicia a aplicação localmente"
        echo "  build   - Faz build da aplicação Go"
        echo "  test    - Executa os testes"
        echo "  deps    - Atualiza as dependências Go"
        echo "  db      - Conecta ao banco PostgreSQL local"
        echo "  health  - Verifica se a API está rodando"
        echo "  demo    - Executa uma demonstração da API"
        echo ""
        echo "📋 Para começar:"
        echo "  1. $0 setup    # Configurar ambiente"
        echo "  2. $0 start    # Iniciar aplicação"
        echo "  3. $0 demo     # Testar API (em outro terminal)"
        exit 1
        ;;
esac

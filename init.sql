-- Script de inicialização do banco de dados
-- Este arquivo será executado automaticamente quando o container PostgreSQL subir

-- Criar extensões úteis
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Criar índices adicionais se necessário
-- (As tabelas serão criadas automaticamente pelo GORM)

-- Inserir dados de exemplo (opcional)
-- Descomentar as linhas abaixo se quiser dados de teste

-- INSERT INTO users (name, email, phone, created_at, updated_at) VALUES 
-- ('João Silva', 'joao@email.com', '11999999999', NOW(), NOW()),
-- ('Maria Santos', 'maria@email.com', '11888888888', NOW(), NOW()),
-- ('Pedro Oliveira', 'pedro@email.com', '11777777777', NOW(), NOW());

-- INSERT INTO payments (user_id, amount, currency, status, method, description, created_at, updated_at) VALUES 
-- (1, 100.50, 'BRL', 'approved', 'credit_card', 'Pagamento de teste 1', NOW(), NOW()),
-- (1, 250.00, 'BRL', 'pending', 'pix', 'Pagamento de teste 2', NOW(), NOW()),
-- (2, 99.99, 'BRL', 'approved', 'credit_card', 'Pagamento de teste 3', NOW(), NOW());

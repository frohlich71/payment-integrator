# Build stage
FROM golang:1.21-alpine AS builder

# Instalar dependências necessárias
RUN apk add --no-cache git

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos de dependências
COPY go.mod go.sum ./

# Baixar dependências
RUN go mod download

# Copiar código fonte
COPY . .

# Build da aplicação
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Production stage
FROM alpine:latest

# Instalar ca-certificates para requisições HTTPS
RUN apk --no-cache add ca-certificates

# Criar usuário não-root
RUN adduser -D -s /bin/sh appuser

WORKDIR /root/

# Copiar binário da aplicação
COPY --from=builder /app/main .

# Copiar arquivo .env se existir
COPY --from=builder /app/.env* ./

# Mudar para usuário não-root
USER appuser

# Expor porta
EXPOSE 9999

# Comando para executar a aplicação
CMD ["./main"]

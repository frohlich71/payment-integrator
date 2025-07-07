package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Carregar variáveis de ambiente
	if err := godotenv.Load(); err != nil {
		log.Println("Arquivo .env não encontrado, usando variáveis do sistema")
	}

	// Configurar Gin
	if os.Getenv("GIN_MODE") == "release" {
		gin.SetMode(gin.ReleaseMode)
	}

	router := gin.Default()

	// Middleware
	router.Use(corsMiddleware())

	// Rotas da API
	api := router.Group("/api/v1")
	{
		// Endpoint de payment que recebe JSON e faz log
		api.POST("/payment", handlePayment)
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "9999"
	}

	log.Printf("Servidor rodando na porta %s", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatal("Falha ao iniciar o servidor:", err)
	}
}

// handlePayment processa o pagamento recebido e faz log do JSON
func handlePayment(c *gin.Context) {
	// Capturar o timestamp da requisição
	timestamp := time.Now().Format("2006-01-02 15:04:05")

	// Ler o corpo da requisição
	var paymentData map[string]interface{}
	if err := c.ShouldBindJSON(&paymentData); err != nil {
		log.Printf("[%s] Erro ao processar JSON: %v", timestamp, err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "JSON inválido",
			"message": err.Error(),
		})
		return
	}

	// Converter para JSON formatado para log
	jsonBytes, err := json.MarshalIndent(paymentData, "", "  ")
	if err != nil {
		log.Printf("[%s] Erro ao formatar JSON para log: %v", timestamp, err)
	}

	// Log detalhado do pagamento recebido
	log.Printf("=== PAYMENT RECEIVED ===")
	log.Printf("Timestamp: %s", timestamp)
	log.Printf("IP Cliente: %s", c.ClientIP())
	log.Printf("User-Agent: %s", c.GetHeader("User-Agent"))
	log.Printf("Content-Type: %s", c.GetHeader("Content-Type"))
	log.Printf("Dados recebidos:")
	log.Printf("%s", string(jsonBytes))
	log.Printf("========================")

	// Resposta de sucesso
	c.JSON(http.StatusOK, gin.H{
		"status":        "success",
		"message":       "Pagamento recebido e processado com sucesso",
		"timestamp":     timestamp,
		"received_data": paymentData,
	})
}

func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Credentials", "true")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Header("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

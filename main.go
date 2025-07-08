package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

var totalRequests []int
var totalAmount []float64

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

		api.GET("/payments-summary", handlePaymentSumamary)
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "9999"
	}

	if err := router.Run(":" + port); err != nil {
		log.Fatal("Falha ao iniciar o servidor:", err)
	}
}

// handlePayment processa o pagamento recebido e faz log do JSON
func handlePayment(c *gin.Context) {
	var paymentData PostPaymentRequest

	// Ler o corpo da requisição
	if err := c.ShouldBindJSON(&paymentData); err != nil {
		log.Printf("[%s] Erro ao processar JSON: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "JSON inválido",
			"message": err.Error(),
		})
		return
	}

	// Converter para JSON formatado para log
	_, err := json.MarshalIndent(paymentData, "", "  ")
	if err != nil {
		log.Printf("[%s] Erro ao formatar JSON para log: %v", err)
	}

	totalRequests = append(totalRequests, 1)

	// Resposta de sucesso
	c.JSON(http.StatusOK, gin.H{
		"Response": paymentData,
	})
}

func handlePaymentSumamary(c *gin.Context) {

	c.JSON(http.StatusOK, gin.H{
		"message":       "Resumo gerado com sucesso",
		"totalRequests": len(totalAmount),
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

type PostPaymentRequest struct {
	CorrelationID string  `json:"correlationId" binding:"required"`
	Amount        float64 `json:"amount" binding:"required"`
}

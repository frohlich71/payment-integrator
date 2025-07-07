package models

import (
	"time"
)

type Payment struct {
	ID        uint      `gorm:"primarykey" json:"id"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	Amount    float64   `gorm:"not null" json:"amount" binding:"required,gt=0"`
}

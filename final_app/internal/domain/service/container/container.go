package serviceСontainer

import (
	"github.com/gin-gonic/gin"
	"github.com/MrDaniLLka/HW_TBD/final_app/internal/domain/entity"
	"github.com/MrDaniLLka/HW_TBD/final_app/internal/domain/service/repository"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/auth"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/config"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/database"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/hash"
	"github.com/sirupsen/logrus"
)

func New(filename string) (*Container, error) {
	cfg, err := config.LoadConfig(filename)
	if err != nil {
		return nil, err
	}

	conn, err := database.NewConnection(cfg,
		&entity.User{},
		&entity.Share{},
	)

	if err != nil {
		return nil, err
	}

	repo := repository.NewRepository(conn)
	hasher := hash.NewPasswordsHasher()
	authManager := auth.NewJWTManager()

	return &Container{
		Config: cfg,
		Logger: logrus.New(),
		Router: gin.Default(),
		Repo:   repo,
		Hasher: hasher,
		Auth:   authManager,
	}, nil
}

type Container struct {
	Config config.Config
	Logger Logger
	Router Router
	Repo   Repository
	Hasher PasswordsHasher
	Auth   JWTManager
}

package usecase

import (
	"context"

	serviceСontainer "github.com/MrDaniLLka/HW_TBD/final_app/internal/domain/service/container"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/auth"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/config"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/gen/proto/tinkoff/investapi"
)

type Tokens struct {
	AccessToken  string
	RefreshToken string
}

func CreateUserSession(userId uint, repo serviceСontainer.Repository, authManager serviceСontainer.JWTManager, cfg config.Config) (Tokens, error) {
	var (
		result Tokens
		err    error
	)

	signingKey := cfg.GetString("Auth.JWTSecret")

	result.AccessToken, err = authManager.CreateAccessToken(int(userId), auth.AccessTokenExpireDuration, signingKey)
	if err != nil {
		return result, err
	}

	refreshToken, err := authManager.CreateRefreshToken()
	if err != nil {
		return result, err
	}

	result.RefreshToken = refreshToken
	return result, repo.UpdateRefreshToken(userId, refreshToken)
}

func CreateTinkoffSandboxAccount(URL string, Token string, ctx context.Context) (string, error) {
	sandboxClient := investapi.CreateSandboxServiceClient(URL, Token)
	openAccountReq := investapi.OpenSandboxAccountRequest{}
	protoOpenAccountMsg, err := sandboxClient.OpenSandboxAccount(ctx, &openAccountReq)
	if err != nil {
		return "", err
	}

	return protoOpenAccountMsg.AccountId, nil
}

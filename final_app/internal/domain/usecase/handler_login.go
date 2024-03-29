package usecase

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/MrDaniLLka/HW_TBD/final_app/internal/domain/entity"
	"github.com/MrDaniLLka/HW_TBD/final_app/internal/transport/dto/request"
)

func authenticateUser(h *handler, reqData *request.UserAuth) (*entity.User, error) {
	user, err := h.Repo.GetUserByLogin(reqData.Login)
	if err != nil {
		return nil, err
	}

	if err = h.Hasher.CheckPassword(reqData.Password, user.PasswordHash); err != nil {
		return nil, err
	}

	return user, nil
}

func (h *handler) Login(c *gin.Context) {
	reqData, err := prepareAuthReq(c)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	user, err := authenticateUser(h, reqData)
	if err != nil {
		c.String(http.StatusForbidden, err.Error())
		return
	}

	tokens, err := CreateUserSession(user.ID, h.Repo, h.Auth, h.Config)
	if err != nil {
		c.String(http.StatusBadGateway, fmt.Sprintf("error: %s", err))
		return
	}

	c.JSON(http.StatusOK, tokens)
}

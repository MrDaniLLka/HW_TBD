package usecase

import (
	"context"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jinzhu/copier"
	"github.com/MrDaniLLka/HW_TBD/final_app/internal/domain/entity"
	"github.com/MrDaniLLka/HW_TBD/final_app/internal/transport/dto/request"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/gen/proto/tinkoff/investapi"
)

func getUser(h *handler, headers http.Header) (*entity.User, error) {
	signingKey := h.Config.GetString("Auth.JWTSecret")
	claims, err := h.Auth.AuthorizateUser(headers, signingKey)
	if err != nil {
		return nil, err
	}
	user, err := h.Repo.GetUserByID(claims.Id)
	if err != nil {
		return nil, err
	}
	return user, nil
}

func prepareBuyShareReq(c *gin.Context) (*request.BuyingShare, error) {
	var req request.BuyingShare
	if err := c.BindJSON(&req); err != nil {
		return nil, err
	}
	if err := req.Validate(); err != nil {
		return nil, err
	}
	return &req, nil
}

func getShareInfoByTicker(ctx context.Context, h *handler, classCode, id string) (*investapi.ShareResponse, error) {
	instrumentClient := investapi.CreateInstrumentsServiceClient(h.Config.GetString("Tinkoff.URL"), h.Config.GetString("Tinkoff.Token"))

	gettingShareReq := investapi.InstrumentRequest{
		IdType:    investapi.InstrumentIdType_INSTRUMENT_ID_TYPE_TICKER,
		ClassCode: classCode,
		Id:        id,
	}

	return instrumentClient.ShareBy(ctx, &gettingShareReq)
}

func addShareToPortfolio(h *handler, reqData *request.BuyingShare, userId uint) (uint, error) {
	share := &entity.Share{}

	if err := copier.Copy(share, reqData); err != nil {
		return 0, err
	}

	share.UserID = userId
	share.Ticker = reqData.Id

	return h.Repo.CreateShare(share)
}

func prepareResponse(ctx context.Context, h *handler, quantity int64, figi, userAccountID, shareId string) (*investapi.PostOrderResponse, error) {
	sandboxClient := investapi.CreateSandboxServiceClient(h.Config.GetString("Tinkoff.URL"), h.Config.GetString("Tinkoff.Token"))
	return sandboxClient.PostSandboxOrder(ctx, &investapi.PostOrderRequest{
		Quantity:  quantity,
		Figi:      figi,
		Direction: investapi.OrderDirection_ORDER_DIRECTION_BUY,
		AccountId: userAccountID,
		OrderType: investapi.OrderType_ORDER_TYPE_MARKET,
		OrderId:   shareId,
	})
}

func (h *handler) BuyShare(c *gin.Context) {
	user, err := getUser(h, c.Request.Header)
	if err != nil {
		c.String(http.StatusForbidden, err.Error())
		return
	}

	reqData, err := prepareBuyShareReq(c)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	shareData, err := getShareInfoByTicker(c, h, reqData.ClassCode, reqData.Id)
	if err != nil {
		c.String(http.StatusNotFound, err.Error())
		return
	}

	shareId, err := addShareToPortfolio(h, reqData, user.ID)
	if err != nil {
		c.String(http.StatusBadGateway, err.Error())
		return
	}

	resp, err := prepareResponse(
		c, h, int64(reqData.Quantity),
		shareData.Instrument.Figi, user.AccountID, fmt.Sprint(shareId),
	)
	if err != nil {
		c.String(http.StatusBadGateway, err.Error())
		return
	}

	c.JSON(http.StatusOK, resp)
}

package usecase

import (
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/golang/mock/gomock"
	serviceСontainer "github.com/MrDaniLLka/HW_TBD/final_app/internal/domain/service/container"
	"github.com/MrDaniLLka/HW_TBD/final_app/internal/domain/service/repository"
	mock_repository "github.com/MrDaniLLka/HW_TBD/final_app/internal/domain/service/repository/mocks"
	mock_auth "github.com/MrDaniLLka/HW_TBD/final_app/pkg/auth/mocks"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/config"
	"github.com/MrDaniLLka/HW_TBD/final_app/pkg/hash"
	"github.com/sirupsen/logrus"
	"github.com/stretchr/testify/assert"
)

func TestHandler_getShare(t *testing.T) {
	testTable := []struct {
		name               string
		tickerId           string
		classCode          string
		expectedStatusCode int
	}{
		{
			name:               "OK",
			tickerId:           "GAZP",
			classCode:          "TQBR",
			expectedStatusCode: 200,
		},
		{
			name:               "OK",
			tickerId:           "AAAAAAAAA",
			classCode:          "TQBR",
			expectedStatusCode: 404,
		},
		{
			name:               "OK",
			tickerId:           "GAZP",
			classCode:          "BBBBBBBBB",
			expectedStatusCode: 400,
		},
	}

	for _, testCase := range testTable {
		t.Run(testCase.name, func(t *testing.T) {
			c := gomock.NewController(t)
			defer c.Finish()

			cfg, err := config.LoadConfig(RelativeConfigPath)
			if err != nil {
				panic(err)
			}

			// Mock data
			user := mock_repository.NewMockUser(c)
			JWTAuth := mock_auth.NewMockJWT(c)
			hasher := &hash.PasswordsHasher{}
			repository := &repository.Repository{User: user}

			url := "/share"
			r := gin.Default()

			container := &serviceСontainer.Container{
				Config: cfg,
				Logger: logrus.New(),
				Router: r,
				Repo:   repository,
				Hasher: hasher,
				Auth:   JWTAuth,
			}
			handler := NewHandler(container)

			r.GET(url, handler.GetShare)

			// Test request
			httpTestRecorder := httptest.NewRecorder()
			testRequest := httptest.NewRequest("GET", url, nil)

			q := testRequest.URL.Query()
			q.Add("id", testCase.tickerId)
			q.Add("classCode", testCase.classCode)
			testRequest.URL.RawQuery = q.Encode()

			// Perform Request
			r.ServeHTTP(httpTestRecorder, testRequest)

			// Assert
			assert.Equal(t, testCase.expectedStatusCode, httpTestRecorder.Code)
		})
	}
}

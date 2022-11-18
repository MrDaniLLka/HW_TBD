package store

import (
	"context"
	"errors"
	"fmt"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/jmoiron/sqlx"

	"github.com/jackc/pgx/v4"
)

type Store struct {
	conn *pgx.Conn
}

type People struct {
	ID   int
	Name string
}

// NewStore creates new database connection
func NewStore(connString string) *Store {
	conn, err := pgx.Connect(context.Background(), connString)
	if err != nil {
		panic(err)
	}
	db, err := sqlx.Connect("postgres", connString)

	driver, err := postgres.WithInstance(db, &postgres.Config{
		DatabaseName: "miakotin",
		SchemaName:   "public",
	})
	if err != nil {
		fmt.Errorf("Connect failed %w", err)
	}

	m, err := migrate.NewWithDatabaseInstance("file://migrations/init_schema.up.sql", "miakotin", driver)
	if err != nil {
		fmt.Errorf("Connect failed %w", err)
	}

	if err := m.Up(); err != nil && !errors.Is(err, migrate.ErrNoChange) {
		fmt.Errorf(err)
	}

	return &Store{
		conn: conn,
	}
}

func (s *Store) ListPeople() ([]People, error) {
	var people []People
	rows, err := s.conn.Query(context.Background(), "SELECT id, name FROM people")
	if err != nil {
		return nil, fmt.Errorf("Incorrect query! %w", err)
	}
	defer rows.Close()

	for rows.Next() {
		p := People{}
		err := rows.Scan(&p.ID, &p.Name)
		if err != nil {
			return nil, fmt.Errorf("rows gg: %w\n", err)
		}
		people = append(people, p)

	}
	return people, nil
}

func (s *Store) GetPeopleByID(id string) (People, error) {
	p := People{}
	err := s.conn.QueryRow(context.Background(), "SELECT * FROM people WHERE id=%w", id).Scan(&p.ID, &p.Name)
	if err != nil {
		return p, fmt.Errorf("id doesnt exist: %w", err)
	}
	return p, nil
}


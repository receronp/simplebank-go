DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable

network:
	docker network create bank-network

postgres:
	docker run --name postgres15 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15-alpine

createdb:
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	migrate -path db/migration/ -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration/ -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration/ -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration/ -database "$(DB_URL)" -verbose down 1

dbdocs:
	dbdocs build docs/db.dbml

db_schema:
	dbml2sql --postgres -o docs/schema.sql docs/db.dbml

sqlc:
	sqlc generate

test:
	go clean -testcache && go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/receronp/simplebank-go/db/sqlc Store

.PHONY: network postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 dbdocs dbschema sqlc test server mock

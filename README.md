# github-search
Application that pulls github repository information based on a search criteria.

## Setup
### With Docker
- Start container: `docker-compose up --build`
- Exec into container: `docker exec -it github-search_web_1 bash`

### Locally
Dependencies
- Ruby version: 2.7.1

Install the gems
```
bundle
```

Create and migrate the DB
```
rake db:create
rake db:migrate
```

Run the tests
```
bundle exec rspec
```

Start the server
```
rails s
```

# Conference API

This is an API, made with Ruby on Rails, the objective of this API is to manage Presentations/Lectures in a conference, for that we have a basic CRUD and an endpoint that can import data (about the presentations) from a JSON file (more about it down below).

# Database
ThisAPI uses Postgres SQL
* Do not forget to change your credentials in __database.yml__

Things you may want to cover:

# Endpoints
Register a presentation/lecture
- POST /lectures
```json
{
  "name": "SomeName",
  "duration": "lightning" // Opts.: "30 min", 30, "lightning"
}
```
Delete a presentation/lecture
- DELETE /lectures/:id

Show all presentations/lectures
- GET /lectures

Update a presentation/lecture
- PUT /lectures/:id
```json
{
  "name": "SomeName",
  "duration": "lightning" // Opts.: "30 min", 30, "lightning"
}
```
Show all tracks that the event will have
- GET /tracks

Import data from file
- POST /tracks

## Importing data from file

This API has an endpoint that enables it, if you send a json file (via POST) para __/tracks__, those lectures/presentations will be saved on the database and the return will be all the tracks that already existed and the ones that were on the JSON file.
- File content example
```json
{
  "presentations" : [
    {
      "name": "Test  1",
      "duration": "30min"
    },
    {
      "name": "Test  2",
      "duration": "lightning"
    },
    {
      "name": "Test  3",
      "duration": 60
    }
  ] 
}
```

# Running the server
To run this API locally, run:
```bash
rails s
```


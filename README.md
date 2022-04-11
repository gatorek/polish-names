# Run the app
Create `.env` file - using the `.env-example` as a template.
Run `docker compose build` to build the image.
Run `docker compose up` to start the app.

App will be available at `localhost:8012`

# TODO
- [x] fix date setting on the edit form
- [x] add search form (the search works now by manual adding parameters to URL - eg `name=ada`)
- [ ] add tests for failed paths in controller
- [ ] wrap import into transaction
- [ ] add error handling in API Client
- [ ] make sure the record ordering in API Client is correct
- [ ] parallelize API Client calls
- [ ] move API URLs to config
- [ ] for production - secure the postgres setup
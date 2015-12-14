## Port

Port is a simple Rails application to take static webpages (`html`, `xml`) and bolt-on some basic authorization.

Port provides access to a dashboard that allows an administrator to set particular pages as public or private.

Any pages that have private visibility require a valid `access code` to be entered before access to the contents of the page is granted. The `access code` is stored in the user's session, so once a valid code is supplied, a user may browse all private pages throughout the session.

Note: It is a good idea to make the main `index.html` file that maps to the route `/` to be public as many controller methods will redirect to this page as a landing page.

Another Note: Any files that are with the `static/assets` directory are always publicly visible. This way one does not have to maintain the visibility of all asset files individually. Be warned.

### Setup

A new Port deployment will display a 404 page at the root url (i.e. `http://localhost:3000/`). This is because there are no `html` pages in the `app/views/static` directory. By default, Port will setup the root url to the `app/views/static/index.html` file.

Here's a few steps that will setup a new deployment:

1. Execute `bundle install` to install dependencies.
2. Migrate the database: `rake db:migrate`.
3. Create an admin account: `rake admin:create[email,password]`.
4. Copy your static `html` files to the `app/views/static` directory.
5. Visit `/dashboard` and login using the newly created admin account to update the pages in the database, or call `rake pages:scan`. By default, the main `index.html` file will be publicly viewable.
6. Presto! You should be able to reach any publicly viewable pages from theor traditional urls.

### Dashboard

An admin dashboard may be reached at the `/dashboard` url. Once an administrator has logged in, they may set the visibility of pages, or create/delete access codes.

The directory containing the static templates is scanned and updated upon successful login to the admin dashboard. Therefore, one should visit the admin dashboard after adding templates to the static directory.

A `rake pages:scan` task is available to update the pages in the database to match the filesystem without visiting the admin dashboard.

A `rake admin:create` task may be used to generate a new administrator account as such:

```bash
rake admin:create[test@test.com,12345678,12345678]
```

where the options provided are the corresponding `email`, `password` and `password_confirmation` attributes.

### Configuration

By default, any files ending in `.html` or `.xml` inside the `app/views/static` directory will be considered static templates.

The static directory may be changed by setting the `config.x.static_root` key to the requested path in the appropriate rails environment file (likely `production.rb`).

A contact email address is supplied to users requesting access to private pages. This specifed by setting the `PORT_CONTACT_EMAIL` evironment variable, or it may be directly set via the `config.x.port_contact_email` key in `application.rb`.

### License

Port is licensed under the MIT License. Please see LICENSE for details.